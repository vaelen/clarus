# Memory-leak fix phase — design (2026-08-12)

Companion to `2026-08-12-cross-compile-degradation-findings.md` (the
investigation record; evidence, numbers, and probe inventory live
there). This spec covers the fix. Scope decision (Andrew, 2026-08-12):
**full reset story** — fix both rc-leak classes AND retire the
never-reset/unbounded-growth tables, so a long-lived `ClarusC.APPL`
process has bounded memory no matter how many compiles it runs. Clarus
manages memory for the programmer; the compiler must hold itself to the
same standard.

Target: after this phase, a `dblcompile`-harness run shows ~zero live
Memory Manager blocks retained per additional compile, and compile #2
on Snow runs at compile-#1 speed.

## Section 1 — synthetic `__store` temps: no prologue birth

The dominant leak (~18.5k lists/compile): lowering's per-counted-store
synthetic `__storeN` locals are container-birthed by both backends'
unconditional prologue default-init, but only released at their own
store site — every return path that skips that site leaks the birth
(findings §root-cause-1; repro `clarusc/test/stemp.cla`).

Fix: **synthetic store temps are not birthed; they default-init to
NULL/0.**

- IR: a per-local no-birth flag (new parallel arena field or flag bit on
  the local, set by `lowCountedStore` when it mints the temp via
  `lowAddLocal`; ordinary user locals never set it).
- cprint: `cpDefaultInit` emits `= NULL` (or `{0}`) for flagged locals
  instead of the `rtListNew`/`rtTextNew`/`rtMapNew` birth.
- cg68k: `cgEmitFunc`'s prologue loop (cg68k.cla:4770-4774) emits
  CLR.L for flagged locals instead of `cgDefaultInitAt`'s birth call.
- Safety argument: the store-site sequence is
  `release(temp); temp = <fresh>; <transfer>; temp = 0` — the release
  is NULL-safe on both lanes (`rtListRelease` et al. are documented
  NULL-safe), and the hazard the unconditional prologue init originally
  fixed (cg68k Task 13) was stack GARBAGE read as a handle, not NULL.
  No other code path reads a store temp: lowering creates each one
  exclusively for its own store site.
- The synthetic RETURN temp (`lowNewReturnTemp`) keeps its existing
  explicit birth-release handling (lowReturn already releases its
  default-init orphan); it is NOT flagged in this phase unless review
  shows the same flag simplifies it for free.
- Side benefit: thousands fewer birth traps per compile on the Mac.

Rejected alternative: adding store temps to `lowFreeNames` (release at
every return). Correct but emits O(returns x temps) release calls —
`cgIntr` alone would gain ~560 JSR sites, a real risk against the 32KB
per-function/segment ceilings macgui already presses.

## Section 2 — `.clear()` releases reference elements

`rtListClear`/`rtMapClear`/`rtIntMapClear`/`rtSortedMapClear` are
bookkeeping-only hard resets; `.clear()` on a container whose elements
own heap references silently leaks the whole element population
(findings §root-cause-2; repro `clarusc/test/clearprobe.cla`). Known
leaking sites: `funcSigs.clear()` (FuncSig.params lists),
`scopes.clear()` (Scope.names intmaps), `a68DataTexts` (list of text,
cleared per Measure pass AND per segment), and the host-lane cprint
buffers (`cpTypeBuf`/`cpLitBuf`/`cpRecBuf`/`cpUiBuf`/`cpRestBuf`/
`fpBody`/`fpStmtTmps`/`fpStmtTmpRel`).

Fix: **`.clear()` becomes element-aware at compile time.**

- Lowering dispatches on the element type using the SAME predicates the
  container-release walk already uses (`lowEscapeTrackableKind` /
  `lowIsRecBearing` / `lowArrHeapScalarBearing`):
  - Scalar-only elements: unchanged — the existing O(1) hard-reset
    intrinsic.
  - Ref-bearing elements: emit an element-release walk (the same
    per-element release machinery container release uses — compiler-
    generated record walks included), THEN the hard reset.
- Both lanes get this for free at the IR level if the walk is lowered
  as IR statements; otherwise each backend mirrors its existing
  container-release element loop. Prefer the IR-level lowering so the
  logic exists once.
- Reference doc (`docs/clarus-language-reference.md`) `.clear()` entry
  gains the semantics sentence: `.clear()` releases the elements it
  drops; it is O(1) only for scalar element types, O(n) for
  reference-bearing element types.
- The map keypool note stands: `rtMapClear`'s `poolused = 0` already
  reclaims key bytes on full clear; no change.

No compile-error alternative: rejecting `.clear()` on ref-bearing
containers was considered and dropped — the operation is legitimate
and wanted (the layer1 conversion sites are exactly that); it just has
to do its job.

## Section 3 — full per-compile reset: retire the never-reset tables

History (why these were never reset): the host CLI was single-shot, so
no between-compiles existed; when macgui became the first multi-compile
front end, the pool was declared process-lifetime ("unbounded-growth-
but-harmless", drive.cla:447-454) to avoid auditing every pool-index
consumer, and later tables leaned on that invariant to skip their own
clears (shake.cla:95-105, ir.cla:756-784) or bought correctness with
the progGen key-namespacing hack (check.cla:751-752). This phase does
the audit those decisions deferred.

Fix:

- **`libReset()`** (lib.cla): fresh-reassigns `strPool`/`strIndex`.
  Called from `driveReset()` — the per-compile battery (macgui runs it
  before every compile; the single-shot host CLI never calls
  `driveReset` and never needs the reset, since its pool starts empty)
  — whose doc-comment pool exemption flips to document the reset.
- **Every invariant dependent resets with it**, same battery:
  - `shakeFuncIdxByName` (shake.cla) — cleared per compile instead of
    overwritten-not-cleared.
  - `irRcWalkNeededByName`, `irLayoutNeededByName` (ir.cla) — added to
    `irReset`.
  - `irColumnDescs` — added to `irReset` (the standalone oversight).
  - check.cla's never-reset maps fold into `checkReset`:
    `windowIsForm`, `windowFormRecType`, `windowVarsHead`,
    `windowWidgetsHead`, `funcScopeByDecl`, `funcRetByDecl`,
    `funcSigByDecl`, `xrecSizeByName`, `xrecFirstDeclByName`,
    `menuItems`, `externFirstDeclByName`.
  - `menuItems`/`externFirstDeclByName` drop the `progGen` namespacing
    (keys become plain names; `progGen` and its per-access concat cost
    are deleted outright if nothing else consumes them).
- **Audit task (its own task, before the reset lands):** enumerate
  every module global that stores pool indices or is keyed by them
  (grep `intern(`/`poolGet(`/`intmap` globals across clarusc/*.cla) and
  confirm each is covered by some per-compile reset or is provably
  per-call state. Deliverable: a table in the task report; any
  uncovered consumer becomes a fix in the same task.
- **Ordering constraint:** `driveReset()` (and therefore `libReset()`)
  runs BEFORE any per-compile interning. Front-end sequences already
  satisfy this (macgui gcCompile resets before driveCompile; main.cla
  is single-shot). The audit confirms nothing interns before the
  battery runs (e.g. CLI flag parsing that interns would need its
  indices treated as per-compile).

Failure mode to design against: a missed cross-compile pool-index
consumer reads a WRONG string after reset (indices recycle) — silent
wrong output, not a crash. Hence the oracle below.

## Section 4 — verification

TDD; every leak class pins red-first:

1. **Leak gate (new, permanent):** a Go test (internal/, T1) builds the
   investigation's double-compile harness shape (`dblcompile.cla`
   promoted from probe to checked-in fixture) with
   `CLARUS_MEM_STRICT=1` + `CLARUS_MEM_REPORT`, runs N=1 and N=3
   compiles of the same file in one process, and asserts live-block
   growth per additional compile is ~zero (small fixed allowance for
   genuinely process-lifetime noted blocks). RED today (+42,845/compile
   measured), GREEN after sections 1-3.
2. **Class fixtures:** `stemp.cla` / `clearprobe.cla`-shaped programs
   land as run fixtures asserting zero live blocks at exit (the
   existing `CLARUS_MEM_STRICT` machinery), covering: untaken-arm store
   temps, `.clear()` on list-of-lists / map-valued records /
   list-of-text.
3. **Stale-index oracle (Andrew's addition):** the double-compile
   harness also asserts compile #2's output fork is BYTE-IDENTICAL to
   compile #1's for the same input — the strongest cheap check against
   a missed pool-index consumer after `libReset()`. (The investigation
   harness already showed byte-stable forks pre-reset; this pins it
   through the reset change.)
4. **Existing gates:** T1 `--smoke` per task; expect cg68k + emitui
   golden churn from sections 1-2 (prologue and `.clear()` codegen
   change on both lanes) — re-bless with the standard procedure;
   differential/selfhost suite is the merge gate for section 3
   specifically; T2 before any merge (standing debt, now four stacked
   phases).
5. **Hardware validation (final, Andrew-gated):** Snow two-compile
   rerun — expect compile #2 ≈ compile #1 per-phase times and no OOM;
   this simultaneously unblocks the mac-resident acceptance PASS
   (STATUS.md steps 0-1).

## Execution shape

- New branch stacked on `worktree-native-perf-findings` (same worktree
  chain; merge decisions remain Andrew's).
- Subagent-driven (sonnet implementers/reviewers, haiku for mechanical
  batch edits; Fable designs/dispatches/reviews). Emulator-boot tasks,
  if any, run boots FOREGROUND per the standing dispatch lesson.
- Section order: 1 → 2 → 3 (audit task first within 3), verification
  strands land with their sections; the leak gate lands first RED
  (skipped-until-fixed marker per repo convention if needed).
