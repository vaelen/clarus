# 68k call-result release — design

**Date:** 2026-08-29
**Status:** approved (brainstorm 2026-08-29, andrew)
**Origin:** `../68kbbs/docs/memory-leak.md` — the fsxNet-toss OOM crash.
That doc is the primary evidence record (symptom, repro, listings,
per-site leak costs); this spec covers the compiler fix only.

## Problem

In `emit68k` (`clarusc/cg68k.cla`), a +1-owning handle result (any
`cgNeedsRelease` kind: KText/KList/KMap/KSortedMap/KIntMap) produced by

1. a user-function call (`ECallFn` through `cgCallFnScalar`), or
2. the `IUiGetTextviewText` intrinsic (a fresh `rtTextNew` box filled by
   `rtUiWidgetGetText`)

is never released when the result is consumed **directly** — as a call
argument (`f(g())`), an operand (`getter + x`), or a receiver
(`g().length`). Only two contexts are balanced today: assignment/return
(the +1 hands off into the destination slot) and the *discarded* bare
call (`cgCallFnScalar`'s `cgDiscardExprIdx` branch routes through
`cgNewTrackedTmp`).

The host lane (cprint) is unaffected — `fpCallFn` materializes every
heap-typed call result into a tracked temp and `fpFreeStmtTmps` releases
it — so no host test can see the bug. On a real Mac it leaked ~630 KB
per tossed fsxNet packet and took the 68kbbs BBS down mid-toss.

Per `lower.cla`'s `lowStoreIsBirth`/`lowStoreIntrOwnsResult` contracts,
every one of these shapes hands back a genuine +1 nothing else owns, so
the fix is purely "track the temp"; no retain-count design work.

## Fix: producer-side tracking (approach A)

Make the two untracked +1-in-D0 producers register their result exactly
the way intrinsic birth sites (`cgIntrTextConcat` et al.) already do:

- **`cgCallFnScalar`**: when `cgNeedsRelease(irFuncRet(fi))`, ALWAYS
  (not just on discard) store D0 to a `cgNewTrackedTmp(retType)` slot,
  set `cgLastTrackedOff = off`, and leave D0 holding the result. The
  existing discard-only branch collapses into this.
- **`IUiGetTextviewText`** (`cgIntr`, cg68k.cla:9153 area): track the
  fresh box the same way (tracked temp + `cgLastTrackedOff`), keeping
  the existing stack-stash evaluation shape.

Consumers need nothing new:

- `SAssign`/`SReturn` already check `cgLastTrackedOff` and call
  `cgHandoff`, so `raw = pktReadZ()` keeps today's exact semantics —
  release-old + store the handed-off +1, no double release.
- Every other context (argument, operand, receiver, index) is released
  by the existing end-of-statement flush (`cgFreeStmtTmps`), which the
  abort/early-exit machinery already walks. Statement-end release
  satisfies the borrow contract: the callee borrows a pushed argument,
  and `+`/`append` into an alias must still see it alive — the release
  lands after the consuming call returns.

This mirrors the host lane's discipline rather than inventing a new one
(the memory-leak doc's explicit requirement), and it is the root-cause
shape: one fix at the producers, not per-site spill lists at every
consumer (the Task 8 pop/shift-as-arg patch was consumer-side and left
exactly these sibling holes).

### Rejected alternatives

- **Consumer-side spills** (`cgPushArgs`, each operand/receiver site):
  many sites, per-site ownership lists, already demonstrated to leave
  gaps.
- **Lowering-level materialization** (`lower.cla` `__store` temps for
  all call results): shared IR feeds cprint too, which already balances
  these — the host lane would double-handle (double-release or leak
  depending on shape).

## Probe task (plan Task 1)

Close these before writing the fix; each is a verification, and any
"no" upgrades the design:

1. **Handoff coverage:** every ownership-taking consumer of a call
   result checks `cgLastTrackedOff`. `SAssign`'s handle-kind arm does
   (cg68k.cla:11994 area). Confirm `SReturn`, store-into-field,
   store-into-element, and any other store shape that can take an
   `ECallFn`/getter source. A missing handoff = double release (UAF),
   strictly worse than the leak — this is the phase's main risk.
2. **No KRec sibling gap:** `cgCallFnInto` (>4-byte returns) and
   `cgPushArgs`' KRec arm (`cgPendingArgReleases`) already balance
   record results in all consumption contexts.
3. **Pool headroom:** the per-statement tracked-temp hard-error ceiling
   and the binary-files-phase per-function pool sizing absorb the extra
   temps in deep nested expressions (e.g. `wrapText(stripKludges(
   postBody(id)), …)`). Bump the ceiling const if needed.
4. **No machinery change needed** in the pending-arg-release
   (`cgSaveArgReleases`/`cgFlushArgReleases`) or abort-path flush code.
5. **Existing special cases stay coherent:** the `cgPushArgs`
   `lowIntrIsOwningContainerRead` scalar-arm patch and
   `cgCallFnScalar`'s discard branch — fold or leave, but no path may
   track the same value twice.

## Verification

- **Listing regression pin (T1):** a Go test compiles the minimal repro
  (the memory-leak doc's `direct()`/`viaLocal()` pair) with
  `emit68k --listing` and asserts a `rtTextRelease` lands after the
  consuming call in `direct`, and that `viaLocal` keeps exactly its
  current release count (no double release).
- **Native heap proof (T2):** new `ToolboxTest` suite case — loop
  `f(g())`, an operand form (`g() + x`), and a getter form a few
  thousand iterations, sampling `FreeMem` (toolbox/memory.cla) before
  and after; assert free heap does not fall. Runs on the native lane
  via `TestToolboxSuiteOn68k`.
- **Host lane byte-identical:** cprint untouched; existing goldens and
  `TestSnapshotFixedPoint` prove it (snapshot regen at close-out is the
  ordinary compiler-source-changed regen, not a host-codegen change).
- Usual gates: T1 `--smoke` per task, T2 before merge.

## Out of scope

- 68kbbs `bin/clarusc` pin refresh and the BBS packet-toss acceptance
  run (that repo's follow-up; its workaround doc already covers the
  interim).
- Any KRec-return redesign beyond probe item 2's verification.
- Lowering/IR changes; host-lane changes.
