# Session status — 2026-08-14 (attempt-abort Task 8 close-out DONE, host gates GREEN, emulator checklist deferred)

Handoff summary for the next session. **`attempt-abort` (branch
`attempt-abort`, off `main` at `97d043c`) is feature-complete and
close-out is DONE — all 8 tasks (plus unplanned Task 6b) implemented,
reviewed, and closed out.** Every HOST-side gate is green, including a
second snapshot regen to a Go-free fixed point. The branch is **NOT
merged** — merge is Andrew's call, per usual — and the phase's own
emulator-dependent verification (native `attempt`/`abort` behavior on
real/emulated 68k hardware) is explicitly **DEFERRED**: Snow was
occupied by Andrew's own manual `ClarusC.APPL` testing for this whole
phase (that session's field observations are this phase's own
motivation, spec §1), so every emulator-gated item is written up as a
checklist to run the moment the display frees, not run this phase.

## 0. START HERE next session

The `attempt-abort` phase (section 0a below) is DONE from a host-testing
standpoint; **the deferred emulator checklist is the very next thing to
run**, before any merge decision:
`.superpowers/sdd/2026-08-14-attempt-abort/deferred-gates.md`. Highlights
(full detail in that file):

1. `scripts/test-task.sh --smoke` (Mini vMac smoke pair) — expect clean,
   feature-independent.
2. Full `scripts/test-merge.sh` (T2, native `internal/mactest` lane) —
   `TestCoreSuiteGUIOn68k` should show 69/69 PASS including the 5 new
   `Abort*` cases (Task 8 wired `cases_abort.cla` + bumped the hardcoded
   count, compile-verified host-side, never booted). **Open design
   question found while preparing the checklist:** `TestRunErrOn68k`
   was expected to also cover the new `abort_uncaught`/
   `abort_launch_uncaught` fixtures, but neither is actually wired in,
   and both use `on App.startCLI`, which **hangs** the native non-UI
   boot path outright (a pre-existing, documented native-compat gap,
   not new to this phase) — resolve this (new native-safe fixture
   variants, or drop the sub-item with rationale) before relying on that
   part of T2.
3. `TestClarusCBakePathOnSnow` (`CLARUS_SNOW_TESTS=1`, ~55m) —
   MANDATORY per the standing rule (`bake.cla`/`macgui.cla` changed).
4. **NEW**: `TestMacResidentFailedCompileStaysAliveOnSnow`
   (`internal/mactest/macresident_test.go`) — written and host-compile-
   verified this session, never booted. Proves the phase's own field
   defect is fixed: a failing on-Mac compile (a fixture that
   deterministically trips a real `abort()` site) no longer
   ExitToShells the whole `ClarusC.APPL` session — it alerts, returns to
   idle, and a SECOND compile in the same session still succeeds.
5. `CLARUS_MAC_BLESS=1` regen of the 4 frozen scenario goldens + JT-slot
   shift from `rtUiAlertMsg` becoming always-rooted (Task 4's A4 fix) —
   EXPECTED churn, not a regression.
6. `out`'s on-disk `TEXT`/`ttxt` FInfo stamp (Task 7, spec §6b) — verify
   via hfsutils after any native boot above.

With that checklist run and any findings folded in, `attempt-abort` is
ready for a merge decision. Nothing else is outstanding on this branch.

The prior phase, `object-code-linker` (section 0b below), remains
MERGED to `main` as of the previous session (fast-forward
`e143af1..6009c65`) and pushed to origin. `attempt-abort` branches off
`main` at `97d043c` (a couple of docs-only commits past `6009c65`).

## 0a. attempt-abort close-out (DONE, this session; branch NOT merged)

Branch `attempt-abort`, off `main` at `97d043c`. Design
`docs/superpowers/specs/2026-08-14-attempt-abort-design.md` (now
annotated where Task 7's review found the spec's own §6b wording
self-contradictory, and where §3.2/§3.3's landed design differs from the
naive scheme originally specced). Plan:
`docs/superpowers/plans/2026-08-14-attempt-abort.md`. Full ledger:
`.superpowers/sdd/2026-08-14-attempt-abort/progress.md`. Reference entry:
`docs/clarus-language-reference.md`, Chapter 5 ("Attempt and Abort") +
Chapter 12 (Errors, fifth failure category) + Chapter 13 (callback
boundary note). Deferred emulator checklist:
`.superpowers/sdd/2026-08-14-attempt-abort/deferred-gates.md` (see
section 0 above).

Adds `attempt { } aborted msg { }` + `abort(msg)`: cooperative,
flag-propagated unwinding on both lanes (no runtime mark stack, no
setjmp — every frame's own ARC releases run on the way out, via a
per-function bail block synthesized in LOWERING, not codegen). Fixes the
field defect that motivated it (spec §1): any of ~150 `log(msg); quit 1`
pipeline sites inside `ClarusC.APPL` used to kill the whole app with no
visible error; all ~150 are now `abort(msg)`, and `gcCompile` wraps its
pipeline in `attempt`/`aborted` (beep + alert + return-to-idle, prior Log
window content preserved). Also: pre-compile progress/liveness feedback,
a missing app icon now warns + falls back to the default icon instead of
failing the compile, and the native `out` trace file is stamped
`TEXT`/`ttxt` so TeachText can open it.

- **Tasks 1-8 (+ unplanned 6b) all DONE, reviewed clean.** Front end
  (lexer/parser/checker/IR/lowering, Task 2); C-lane codegen (Task 3);
  68k-lane codegen + the native UI top-level default made FULL-STRENGTH
  per-dispatch, stronger than the C lane's own narrower default (Task
  4); core-suite cases + two REAL leak classes found and fixed + snapshot
  regen #1 (Task 5); the ~150-site clarusc conversion + `gcCompile` catch
  (Task 6); an unplanned interprocedural `canAbort` analysis, triggered
  by Task 6's own perf snapshot (Task 6b); `ClarusC.APPL` feedback +
  icon warning + `out` FInfo stamp (Task 7); this close-out (Task 8).
- **Site classification** (all ~150 converted `abort()` sites,
  `.superpowers/sdd/2026-08-14-attempt-abort/site-classification.md`):
  124 real sites, **84 INTERNAL-INVARIANT / 40 USER-REACHABLE** (Task 6's
  own report summary said 72/52 — wrong; the classification file's own
  footer, 84/40, is the correct, audited total).
- **Perf: a naive scheme regressed clarusc's own self-compile, an
  authorized follow-up fixed it net-positive.** Task 6's "check after
  every non-runtime-origin user call" scheme measured **+26.3%** host
  self-compile / **+6.8%** native `emit68k` (10-pair medians) — well
  above the spec's own "low single digits" expectation, tripping §8's
  own deferred-item trigger. Task 6b's interprocedural `canAbort`
  fixpoint (seed: functions containing `abort`; propagate caller-ward
  over the direct call graph) narrowed checks from 273 to 5 in the
  `abort_bake.cla` sample and brought the numbers to **−11.5%** host
  self-compile (faster than the pre-feature baseline outright,
  reproduced across 3 independent 10-pair batches) / **~0%** native
  `emit68k`.
- **`TestSelfEmit68k` segment count:** 51 (pre-feature baseline) → 61
  (Task 6, after the ~150-site conversion made clarusc itself
  abort-enabled) → 54 (Task 6b, after the `canAbort` narrowing recovered
  most but not all of the growth — some is permanent source growth, not
  check-count-driven).
- **Two real leak classes found (Task 1's own P5 probe) and fixed (Task
  5), not just documented:** (a) a heap-typed function return whose
  synthetic `__retN` return-temp was never released when a function
  aborted before its own `return` executed — 4000 leaked blocks over
  2000 iterations before the fix, 0 after (fixed by handing `__retN`
  itself off through the bail block, which also fixed a separate
  struct-shaped-return compile break as a side effect); (b) a
  mid-statement transient temp (`x = makeText() + f()`, `f` aborts) the
  abort check's `goto` abandoned before the end-of-statement release
  flush ran — 12000 leaked blocks before the fix (compounded with class
  (a) in the same probe fixture), 0 after. `TestAbortLeakBaseline`
  (host-only, `CLARUS_MEM_STRICT`) pins both at zero permanently.
- **Core suite grown 64 → 69 cases**
  (`testsuite/core/cases_abort.cla`: `AbortCatch`/`AbortDeep`/
  `AbortNested`/`AbortReabort`/`AbortRelease`) — proven via the host CLI
  (`TOTAL 69 PASS 69 FAIL 0`); the native/GUI suite boot itself is on the
  deferred checklist (Task 8 wired the file-list/case-count changes so
  that boot doesn't fail on a stale composition the moment it's tried).
- **Golden churn**, per-task review-corrected counts: Task 4's A4
  `alert()`-native fix reblessed 2 pre-existing `internal/cg68k` goldens
  (`bounce.cla`/`tickprobe.cla`, net "one new function, no new
  dependencies, no removals" after its own fix round 1, corrected from
  an initial "three new functions" mid-review reading); Task 7's `out`
  FInfo stamp reblessed **34 modified + 2 added `testdata/cg68k/*.s`
  files** (36 total — Task 7's own report claimed 39+2=41, corrected by
  its review's Finding 2 against the actual `git diff --name-status`).
  The 4 frozen native-lane scenario goldens + 2 suite-boot goldens are
  EXPECTED to need `CLARUS_MAC_BLESS=1` regen once the emulator runs
  (JT-slot shift from `rtUiAlertMsg` becoming always-rooted, plus its
  trace line moving from buffered to immediate) — not done this phase,
  on the deferred checklist.
- **Doc corrections made this close-out:** the design spec's §6b
  "after the successful NatOpen" wording was self-contradictory with its
  own cited reference pattern (which is itself before-Open) — annotated
  to match the landed, functionally-verified-safe before-Open placement;
  its "`natPb` is NOT `NewPtrCLEAR`'d" premise was wrong (it is) —
  annotated; a misleading `clarusc/cg68k.cla` doc comment implying
  `cprint.cla` has special-case handling for the native UI dispatcher's
  abort default was corrected to state the real, parked phase debt (the
  C lane's own UI dispatch loop has NO per-handler-dispatch abort check
  at all, only the native lane does).
- **Real bug found and fixed while regenerating the snapshot** (not just
  a doc issue): `declIsRuntimeOrigin` (`clarusc/lower.cla`, Task 2's own
  Ruling A3) used a literal path-PREFIX check ("starts with
  `runtime/clarus/`"), which silently broke under the DEFAULT (no
  `--rtdir`) rtDir resolution itself — `findRtDir` prepends one `../` per
  directory level walked upward, so any compile launched from somewhere
  other than the repo root (every Go test package in this tree, for
  one) records runtime-module paths like `"../../runtime/clarus/core.cla"`,
  which never matches the literal prefix. Every runtime function was
  silently misclassified as non-runtime-origin whenever `clarusc` ran
  this way, giving it incorrect bail-block/check machinery. Fixed (after
  two superseded rounds — an initial substring search widened the
  dangerous misclassification direction, and a raw-`rtDir` prefix
  compare re-broke under a `./`-prefixed `--rtdir`): normalize `rtDir`
  through the same `normalizePath` the decl path itself already went
  through, then directory-prefix-compare against that — correct for
  the default upward-search case, the canonical `--rtdir
  runtime/clarus/` case, and any other `--rtdir` spelling denoting the
  same real directory; the separately-known, already-accepted
  symlink-equivalence limitation is unchanged, not made worse.
  `testdata/cg68k/abort_bake.s` reblessed as a result (net −327 lines —
  erroneous scaffolding removed from ~10 misclassified runtime
  functions; the fixture's own real `inner`/`outer`/`run` abort
  machinery is unaffected, spot-checked).
- **Snapshot regen #2**: `clarusc/clarusc.c` regenerated to a fresh
  Go-free fixed point at the end of this close-out (after every other
  code change, including the bug fix above); full `go test
  ./internal/selfhost -count=1 -timeout 30m` GREEN including
  `TestSnapshotFixedPoint`.
- **Not run this phase (by design):** every emulator-gated item — see
  section 0's checklist above / `deferred-gates.md` in full. Nothing
  else is outstanding; the branch is ready for the deferred checklist,
  then a merge decision.

## 0b. object-code-linker close-out (DONE, prior session)

Branch `precompiled-artifacts`. Design
`docs/superpowers/specs/2026-08-13-object-code-linker-design.md` (now
annotated at the A1 call-reloc amendment, the fixed-bucket PLAN DEFECT,
and the two unplanned v6 capture mechanisms). Plan:
`docs/superpowers/plans/2026-08-13-object-code-linker.md`. Full ledger:
`.superpowers/sdd/2026-08-13-object-code-linker/progress.md`. Full
detail: ROADMAP's `object-code-linker` entry — summary here.

Implements the precompiled-artifacts notes' stage 3.5: runtime function
BYTES now ship in the CLIR artifact (68k lane, format v6) instead of
being code-generated twice per compile (once to measure sizes for
segment packing, once for real). A `--rtbake` compile's Measure pass
skips `cgEmitFunc` for every reachable runtime function (filling
size/frame/pool-ref data from the artifact instead) and the per-segment
emit pass pastes the captured bytes with fixups rather than
regenerating them.

- **Task 1 (probe, no commits):** all three load-bearing assumptions
  PASS (3886 cross-universe byte comparisons, 0 diffs; 2923 pasted
  function bodies, byte-identical). Six amendments to Tasks 2-3, two
  blocking: **A1** — the spec's separate JT-slot vs same-segment-call
  reloc kinds are wrong at bake time (`cgCallFunc`'s `BSR`-vs-`JSR`
  choice is compile-time-only, 1481 flips observed); collapsed to one
  call reloc, the link pass re-emits via `cgCallFunc` itself. **A2** —
  the codegen-synthesized panic literal (`cgListOobMsgIdx`) needs a
  symbolic reloc, not a numeric index (its bake-time position isn't
  compile-time-stable).
- **Task 2 (`440fa83`, fix round 1 `0047d6d`):** CLIR v6 (`bkSecObjCode`/
  `bkSecObjMeta`), bake-time capture (`cgObjCaptureRuntime`), loader
  staging (`bkLd*`). Two unplanned mechanisms found mid-implementation
  (both consequences of forcing every runtime function reachable, which
  no real compile ever does): callback-glue trampolines needed a fourth
  hole kind (`cgHoleCbGlueAddr`); reverse-waist UI dispatchers needed a
  taint-and-discard fallback (structurally unbakeable, not just
  index-unstable). Growth: 68k lane +14.8% (+160,859 bytes, almost
  entirely the captured object data itself), lane c +52 bytes (empty
  framing only). Self-compile segment-budget crisis (found via
  `TestSelfEmit68k`) fixed by flattening three nested-list staging
  globals to nine flat ones.
- **Task 3 (`a02fa25`):** Measure skip + paste-with-fixups link pass.
  Four bugs found via the full-corpus gate (all in the Measure-skip's
  reconstructed metadata, not the paste mechanic — that worked first
  try): a strlit-count double-count, a strlit-order loss, a missed
  `cgMul32Used`-class glue-usage side effect, and a stale staging global
  surviving an in-process bake→from-source fallback. **The fixed-bucket
  PLAN DEFECT:** the brief said to substitute the once-per-artifact size
  buckets from the artifact; the implementer read the actual measuring
  routines first and refused to, correctly — they measure the CURRENT
  program's universe (runtime prefix + user globals/records/literals),
  not the bake-time runtime-only baseline, so substituting would
  silently under-measure segment packing for any program with user
  state. Review confirmed explicitly: plan text wrong, deviation right.
  Perf (host, 10-pair medians, pre-regen — illustrative not SLA):
  `macgui.cla` emit68k **-41%**, self-compile emit68k **-35%**.
- **Task 4 (this session, commits `c07882d`/`6dcf8aa` + docs/T2):**
  close-out. Step 0 fixed two stale doc comments (Task 3 review) and
  added "deliberately unconsumed" comments to eleven staged-but-unread
  wire fields, naming the hazard (a future reader wiring them into
  `cg68Measure` as a shortcut). Step 0c ran a broader corpus (35
  compiles: 28 `cg68k` fixtures, self-compile, testapi variants, three
  `examples/`, both suite compositions) under local, reverted
  instrumentation, closing Task 3's own recorded coverage gap: **489
  baked functions, 478 pasted at least once, 11 never pasted by any
  corpus program** (`rtStrIndexOfChar`, `rtTextStoreText`,
  `rtTextIndexOfChar`, and eight UI-descriptor-blob accessors —
  `uidWinHandlerMask`, `uidWidgetEventMask`, `uidMenuNameOff`,
  `uidMenuName`, `uidItemNameOff`, `uidItemName`,
  `uidMenuHandlerHandlerIdx`, `uidLayoutNFields`). Step 1 regenerated
  `clarusc/clarusc.c` to a Go-free fixed point in **1 round**
  (4,322,988 bytes); `go test ./internal/selfhost -count=1 -timeout 30m`
  green, 93s. Step 2 wrote this entry + the ROADMAP entry + spec
  annotations + the precompiled-artifacts notes doc's Staging update.

**T2 (`scripts/test-merge.sh`): GREEN, 228s** (T1 body 18s,
`internal/selfhost` 78s, gated native `internal/mactest` lane 126s,
`CLARUS_BAKE_FULL` bake corpus 6s). Log:
`.superpowers/sdd/2026-08-13-object-code-linker/task4-t2.log`.

**Snow: PASS** (first run FAILED on the C-lane UB hash bug — see
section 0 — the fix wave landed, and the re-run at tip `6bf4f6e`
PASSED 2026-08-14, zero fallback lines, forks byte-identical). The
standing-rule obligation for this phase is satisfied; merge-ready from
a testing standpoint.

**Deferred / phase debt (full detail in ROADMAP entry and each task's
own report):** taint-and-discard is silent/uncounted; `bkGetBytes`
unbounded read (no length cap); `bkObjRelocSymValid` doesn't validate
`kind` range; the ~484-byte segment-margin figure is illustrative, not
independently verified; `srcSlot` derivation is over-broad;
capture-side vs load-side globals are half-shared (a footgun for a
future reader); `bkRuntimeFuncBoundary` is still never reset per
compile (now correctly documented as not the bake predicate, but the
underlying behavior is unchanged); `--listing` + `--rtbake` loses
runtime function annotations; two hole-list walks with no early exit
(do not optimize without measuring); the perf snapshot has no maxrss;
everything fallback-trigger-narrowing/runtime-ir-bake/param-abi already
deferred remains open. Out of scope by design: smart linking/IR-body
removal, link-time layout improvements, stage 4's cache, the
pre-existing call-lowering debt class, the stamp-proxy-global gap.

## 0c. fallback-trigger-narrowing close-out (DONE, prior session)

Design `docs/superpowers/specs/2026-08-13-fallback-trigger-narrowing-design.md`
(now annotated where Task 2 narrowed a claim). Plan (4 tasks)
`docs/superpowers/plans/2026-08-13-fallback-trigger-narrowing.md`. Full
ledger: `.superpowers/sdd/2026-08-13-fallback-trigger-narrowing/progress.md`.
Full detail: ROADMAP's `fallback-trigger-narrowing` entry.

Resolved runtime-ir-bake's own recorded debt item, "include-dedup
fallback trigger too broad": a user `include` of a bake-carried file (the
18 runtime modules, or nested includes like `toolbox/{files,standardfile,
appleevents}.cla`) used to abandon the bake unconditionally for that
compile. Now it mirrors from-source's own hoist-dedup by construction —
parse the user's copy for check#1 visibility, drop it before lowering —
so byte-identity holds by construction, and a new per-module source hash
(CLIR format v4 → v5) scopes the REMAINING fallback to genuine on-disk
drift only, logging the drifted path.

- **4 tasks, commits `fa59108..f05d15c`.** Task 1 (probe, no tree
  commits) verified both load-bearing assumptions PASS and chose the
  decl-chain-surgery drop mechanic. Task 2 (`fa59108`, fix round 1
  `9afbf72`) implemented the mechanism + CLIR v5, and along the way found
  and fixed a real latent gap in the ORIGINAL runtime-ir-bake testapi
  preload (it never baked `check.cla`'s own `fieldInfos`/
  `recFieldsHeadByName` side tables, silently breaking any record-bearing
  early-visible manifest module under the new dedup path — closed with a
  new `bkSecFieldInfo` section). Task 3 (`d8ee325`, fix round 1
  `5e71b1f`) built the oracle set (collision/drift/testapi-parity tests,
  plus one bonus coverage-gap test). Task 4 (this session,
  `a65cdd5`/`0570af5`/`4d1beb4`) did the housekeeping the design folded
  in: `macgui.cla`'s fallback-reason string now enumerates the real v5
  refusal set (was stale since the v4 body-hash check) and documents the
  new drift-fallback reason; `cg68k.cla`'s now-redundant tight-to-tight
  scratch buffer in `fromBytes`/`toBytes` codegen was initially removed
  for all four intrinsics (arrays passed by address directly since
  `cgArrElemStride` made them tight) — the final review found this unsafe
  for one of the four (next bullet), so the shipped state keeps the
  scratch for that one; the bootstrap snapshot was regenerated to a
  Go-free fixed point after both edits.
- **Final-review fix wave (`a408e2a`/`f05d15c`):** two Important findings,
  both in Task 4's cg68k work. **I1:** `cgIntrTextFromBytes`'s direct
  address pass was unsafe — `rtTextFromBytes` calls the allocating
  `rtTextGrow` BEFORE its own `TextBlockMoveData` read, so an array
  argument resolving into a list element's relocatable Handle storage
  could go stale mid-call; the other three intrinsics' own runtime
  functions do their BlockMove immediately with no allocating call
  first, so they stay direct. Fixed by restoring the scratch-fill shape
  for `cgIntrTextFromBytes` only (real fix, not a comment — this bug
  class has now bitten the project six times counting the runtime-ir-bake
  T2 blocker's five sites). **I2:** the ROADMAP's "zero golden churn, as
  required" wording was corrected — no golden exercises this code path at
  all, so the gate is INERT here, not evidence; real coverage is the
  source-level argument above plus T2's native lane, and neither native
  fixture exercises a heap-resident array either. Snapshot regenerated
  again (converged round 1, reverified round 2), `TestSnapshotFixedPoint`
  + full `internal/selfhost` (93s) green.
- **Deviation from the design** (Task 2 fix round 1, annotated in the
  spec's own "testapi interaction" section): the design's case (b)
  ("full dedup, no parse") is implemented as "dedup BEFORE THE CHECKER"
  — `expand()` still parses the collided file (harmless, hash-proven
  identical), only the excise from the checker/lowering is new, because
  `isUiProg` isn't known until Phase A finishes. Observable behavior
  matches "full dedup" (proven by the corpus byte-identity gate); the
  parse-cost saving the design's wording implied does not.
- **T2 (`scripts/test-merge.sh`): GREEN at `4d1beb4`, 240s**, then
  **RE-RUN GREEN at `f05d15c` (post-fix-wave), 224s** (T1 body 17s,
  `internal/selfhost` 77s, gated native `internal/mactest` lane 125s,
  `CLARUS_BAKE_FULL` bake corpus 5s). Both runs this session, foreground,
  logged to `task4-t2.log` and `task4-t2-fixwave.log` respectively.
- **All deferred minors** (from both Task 2's and Task 3's own review
  rounds — drift-log-line/`--rtdir` edge case, bake-time `readText`
  failure with no diagnostic, `bkInstallFieldInfo`'s widened preload
  contract, the still-open field-table visibility-boundary gap, the
  `bkSecFieldInfo` unrecorded-invariant note, `driveRebuildChainSkipping`'s
  missing early exit, the drift fixture's semantically-null mutation, the
  four root-directory test fixtures, `copyTree`'s mode-flattening) are
  recorded in the ROADMAP entry's "Deferred / phase debt" list — none
  newly introduced this task, all carried honestly rather than smoothed
  over.
- **Standing rule satisfied — Snow PASS**: `TestClarusCBakePathOnSnow`
  (`CLARUS_SNOW_TESTS=1`, 55m settle) re-run at the true tip `7642deb`
  after the final-review fix wave, PASS (3302s, exit 0), no
  drift-fallback lines in the captured output — the `ClarusC.APPL`
  default bake path is proven on hardware with this phase's
  `bake.cla`/`macgui.cla`/`cg68k.cla` changes in place.

## 0d. runtime-ir-bake close-out recap (DONE, merged to main)

`runtime-ir-bake` is DONE, full `scripts/test-merge.sh` GREEN (232s at
commit `3bdbb3b`, re-confirmed 233s at tip `b16e8f0`). Task 7's own
first full T2 run found a real, pre-existing regression (two independent
latent bugs, neither introduced by this phase); it was root-caused and
fixed the same day, in a follow-up session, with a regression test added
after. Short version (full writeup: ROADMAP `runtime-ir-bake` entry's
"T2 blocker" subsection, and
`.superpowers/sdd/2026-08-12-runtime-ir-bake/t2-blocker-fix-report.md`):

- **Bug 1 (the crash):** `rtUiTableRelayout` and four sibling functions
  (`runtime/clarus/{uitable,uitext,ui,uiwidgets}.cla`) wrote through a
  List/TE Manager master pointer captured BEFORE an intervening
  `UiNewPtr` call, which can relocate the unlocked handle during heap
  compaction — a stale write that left `PopupTableWin`'s table view rect
  zeroed, so a scripted click computed an out-of-range row index. All
  five sites now re-derive the master pointer immediately before use.
- **Bug 2 (why the panic message was empty, hiding bug 1 for a whole
  session):** `cgEmitPanic` (`clarusc/cg68k.cla`) still used the
  pre-param-abi by-value `Str255` push for `rtPanic(msg)`; the param-abi
  phase's by-address `KStr` ABI made every param slot hold a pointer
  instead, so `rtPanic` read the panic literal's own first 4 bytes as an
  address — every native list-bounds panic printed an empty message,
  compiler-wide, not just for this crash. Fixed to push the address.
- **`e72b92a`'s Task 5 splice reorder never caused this** — the prior
  session's leading hypothesis was disproven, not confirmed: a
  code-independent flip (changing only a `--bake` resource NAME's byte
  length, not the compiled code) reproduced the crash with byte-identical
  emitted segments, ruling out every code-layout theory. Both bugs are
  genuinely pre-existing; any earlier PASS of `TestToolboxSuiteOn68k` was
  heap-layout luck.
- **Regression test added** (Task 7 finisher, same day):
  `testdata/runerr/listindex.cla`/`.err`/`.behavior`, exercising
  `cgEmitPanic`'s inline list-bounds path specifically (as opposed to
  `oob.cla`'s ordinary fixed-array path) in `TestRunErrOn68k` — asserts
  the real panic TEXT on a booted native binary, so this bug class can't
  hide silently again.
- Tree is clean; `git worktree list` shows only the main worktree
  (scratch investigation worktrees from the earlier session were
  removed).
- **Final-review fix wave (2026-08-13, commits after `1f75848`):** added
  a CLIR body-integrity hash (format v4 — see ROADMAP entry's "Deferred
  / phase debt" for the write-up) plus a `bkGetByte` bounds guard, a
  `driveReset` defensive-reset parity fix, and doc corrections. **Standing
  rule going forward: re-run `TestClarusCBakePathOnSnow`
  (`CLARUS_SNOW_TESTS=1`) manually after any future change to
  `clarusc/bake.cla` or `clarusc/macgui.cla`** — it's the only proof of
  the `ClarusC.APPL` default bake path, and neither T1 nor T2 boots it.

Design context (unchanged): **Spec (normative):**
`docs/superpowers/specs/2026-08-12-runtime-ir-bake-design.md` (now
annotated where Tasks 1/4/5 narrowed its claims). **Plan (7 tasks):**
`docs/superpowers/plans/2026-08-12-runtime-ir-bake.md`. **Parent design
context:** `docs/superpowers/specs/2026-08-12-precompiled-artifacts-design-notes.md`.

## Why this session happened

The native-compiler performance findings doc (`docs/superpowers/specs/
2026-08-10-native-compiler-performance-findings.md`) catalogued algorithmic
bugs in clarusc itself — Layer 1 of a three-layer diagnosis. This phase
worked that list end to end: 19 tasks, every §1.1-§1.8 item addressed
(fixed, already-fixed, or explicitly deferred with rationale), plus a new
`.clear()` language feature the fix set needed.

## 1. layer1-compiler-perf phase (IMPLEMENTED, this branch)

Ledger: `.superpowers/sdd/2026-08-11-layer1-compiler-perf/progress.md` (19
tasks, all review-clean; commits `94bc1f1..d3581f5`). Findings doc now
annotated per-item (`[FIXED]`/`[DEFERRED]`/`[DROPPED]`/`[ALREADY FIXED]`/
`[STALE]`). Full detail in the ROADMAP phase entry — summary here:

- **Fixed:** §1.1 (`keywordKind` intern storm), §1.3 (`cgHeurOnCycle`
  O(V²·E) BFS → iterative Tarjan SCC), §1.4 (codegen linear scans →
  interned-int lookups), §1.5 (`cgIntr` string dispatch → int arms), §1.6
  (peephole's 384-byte record copies → in-place access, then the record
  itself shrunk to 72 bytes via side tables), and every §1.8 near-free item
  except `numToStr` (dropped, moot) and `scopeLookup` (already fixed).
- **Already fixed:** §1.2 (`exprTypeOf[numToStr(e)]`) — the prior
  map-hashtable phase's `intmap` migration already closed this.
- **Deferred:** §1.7 (every function code-generated twice) — the cheap
  single-segment-reuse fix wouldn't help `ClarusC.APPL` itself (32
  segments); the full fix needs relocation entries, which is Layer 3
  (architecture/caching) scope, not this phase's.
- **Language addition:** `.clear()` for `list`/`map`/`intmap`/`sortedmap`
  (Task 8) — surface syntax over runtime functions that already existed,
  enabling O(1) arena resets instead of pop-loop drains (70 call sites
  converted). Core suite grew 57 → 58 (`ClearBasics`).
- **Unplanned fixes found mid-phase:** Task 0b (a pre-existing
  `macgui.cla` declare-before-use bug broken since the
  datetime-instrumentation phase, fixed for real); Task 8b (`.clear()`'s
  own ~210 new globals broke macgui's 32KB segment limit — fixed by
  restricting `staterows` dispatch arms to list-typed globals only).
- **Gate amendment (Task 10):** multi-segment byte-identity checks moved to
  a frozen source tree (`/tmp/l1src`, git-archive of a fixed commit)
  instead of the live working tree, once `macgui.cla` itself became a file
  later tasks edit — otherwise "input changed" and "compiler behavior
  changed" are inseparable.

### Measured results (10-pair interleaved medians unless noted)

| Benchmark | Pre-phase | Post-phase | Speedup |
|---|---|---|---|
| Host self-compile (`emit clarusc/main.cla`) | 0.531s | 0.465s | 1.14x |
| `emit68k testdata/cg68k/tickprobe.cla` | 0.122s | 0.034s | 3.60x |
| `emit testdata/emitui/every.cla` | 0.066s | 0.047s | 1.40x |
| Frozen-fixture macro (`emit68k` of frozen `macgui.cla`, per-task tracked) | 2.69s (Task 0) | 0.55s (Task 18) | ~4.9x |
| Peak RSS, `emit68k tickprobe.cla` | 129.1 MB | 36.9 MB | 3.5x |
| Peak RSS, `emit68k` frozen macgui | 882.5 MB | 215.3 MB | 4.1x |

Host self-compile gains are modest relative to the 68k macro numbers
because host codegen hot paths are native-side and the self-compile
fixture is small — **the frozen-fixture 68k numbers are the honest
headline: ~4.9x faster, ~4.1x less peak memory**, on the exact workload
that matters (compiling a real multi-segment 68k app).

### Debt / deferrals (all recorded in the ROADMAP entry)

- §1.7 (double codegen) deferred to a future Layer-3 phase — needs
  relocation entries for segment-independent emission.
- Layer 2 (systemic runtime/codegen costs — 256-byte `Str255`, etc.) and
  Layer 3 (architecture/caching) both untouched this phase, by design
  (findings doc's own suggested sequencing).
- **T2 (`scripts/test-merge.sh`) still owed before any merge** — now
  covers three stacked, unmerged phases (map-hashtable,
  datetime-instrumentation, this phase). Not run this session.
- **On-Mac instrumented timing capture still pending** — see next steps
  below; this is the single most valuable next experiment.

## 2. Prior phase context (still true, unchanged this session)

- **map/sortedmap/intmap** (map-hashtable phase, done 2026-08-10): `map of
  T` is a real hashtable on both lanes. Full detail: ROADMAP's
  map-hashtable entry.
- **datetime + instrumentation** (datetime-instrumentation phase, done
  2026-08-11): `now()`/`dateTimeStr()`/`durationStr()` builtins, plus the
  `feProgress` seam giving clarusc always-on progress + per-phase
  `TickCount()` output on both the host CLI and `ClarusC.APPL`'s Log
  window. Full detail: ROADMAP's datetime-instrumentation entry.
- **Snow acceptance run (mac-resident-clarusc):** last run FAILED with a
  milestone — compile #1 succeeded on real Mac hardware (full-size fork);
  compile #2 died OOM in a 48MB partition. That run predates BOTH the
  hashtable fix and this phase's ~5x compiler speedup, and predates the
  progress instrumentation entirely (so it also gave no visible sign it
  was running before the OOM).

## 3. memory-leak-fix phase close-out (2026-08-12, this session, branch `memory-leak-fix`)

**COMPLETE.** 16 commits (`bf07436..f3419bc`) plus one T2-debt-fix commit
on top implementing the 8-task plan referenced in step 0 below: per-compile
growth went from ~42,845 Memory Manager blocks/compile to 0, with the
leak-gate (`internal/mactest/leakgate_test.go`'s `DoubleCompile` alternating
oracle) and the byte-identity oracle both green, and the bootstrap snapshot
(`clarusc/clarusc.c`) regenerated with the fixed codegen.

T2 (`go test ./internal/selfhost -count=1 -timeout 30m`) was staged green
this session **except** two pre-existing, cross-phase `TestClarusModules`
failures unrelated to the leak fix itself:

- `check_test.cla`: the datetime-instrumentation/live-log phases added
  `driveProgressTick()` calls inside `check.cla`, but `driveProgressTick`
  lives in `drive.cla`, which this module test's file list doesn't include
  (by design — it would drag the whole driver/front-end world into a
  checker-only test). Fixed by giving `check_test.cla` its own no-op
  `driveProgressTick()` stub, the same fe*-seam pattern `main.cla`/
  `macgui.cla` already use for their own front-end hooks.
- `asm68k_test.cla`: a golden mismatch from the layer1-compiler-perf
  phase's findings-1.8 commit (`9faa69f`), which gated `asm68k.cla`'s
  self-exerciser's `"end of exerciser"` listing comment behind
  `a68ListingOn` (default false, matching `--listing`'s own default) —
  legitimate behavior change, golden never refreshed. Golden regenerated
  from the current driver's actual output (verified via direct diff: the
  removed comment line was the only delta).

With both fixed, T2 is fully green. Next: the Snow two-compile rerun (step
1 below) is the remaining validation step for the leak fix on real
hardware (expect compile #2 timings to now track compile #1's, not the
degraded ~4x-slower numbers the original investigation measured); after
that, merge decisions cover six stacked phases (`mac-resident-clarusc`,
`map-hashtable`, `datetime-instrumentation`, `layer1-compiler-perf`,
`memory-leak-fix`, `param-abi`).

## 4. param-abi phase close-out (2026-08-12, this session, branch `param-abi`)

**Phase complete on branch `param-abi` (stacked on `memory-leak-fix`).**
Implements the 2026-08-10 performance findings doc's §2.1: immutable
parameters (language + checker) plus by-address `KStr`/`KRec` parameter
passing on both lanes (storage unchanged — see the ROADMAP's param-abi
entry for full detail, design doc, and fix-round history). 8 tasks,
commits `94725e2..f210e4f`; ledger:
`.superpowers/sdd/2026-08-12-param-abi-immutability/progress.md`.

- **Snapshot regen (Task 8 step 1):** `clarusc/clarusc.c` regenerated to a
  Go-free fixed point in 2 iterations (the first re-emission still
  differed — `retain_FuncSig`/`retain_Scope`/etc. gained `const` params —
  a second boot-and-reemit cycle converged to byte-identical output).
  `TestSnapshotFixedPoint` PASS.
- **Full selfhost gate (Task 8 step 2):** `go test ./internal/selfhost
  -count=1 -timeout 30m` — **green, 0 failures, 89s** (`TestClarusModules`
  incl. `check_test`/`asm68k_test`, `TestErrorGoldens` incl.
  `param_assign`, `TestSnapshotFixedPoint`, the works).
- **Perf (Task 8 step 3), 10-pair interleaved medians, old = merge-base
  `cc3f798` snapshot vs. new = this phase's regenerated snapshot:**

  | Benchmark | Old | New | Delta |
  |---|---|---|---|
  | Host self-compile (`emit clarusc/main.cla`) | 0.42s | 0.39s | 1.08x faster |
  | `emit68k testdata/cg68k/tickprobe.cla` wall time | 0.02s | 0.02s | no measurable change |
  | Peak RSS, `emit68k tickprobe.cla` | 29.35 MB | 30.64 MB | ~4% higher |
  | `emit68k clarusc/macgui.cla` (33 segments) wall time | 0.52s | 0.46s | 1.13x faster |
  | Peak RSS, `emit68k clarusc/macgui.cla` (33 segments) | 172.5 MB | 188.1 MB | +9.05% higher |

  `tickprobe.cla` is too small a fixture to exercise the copy-avoidance
  this phase targets; its numbers are dominated by fixed compiler-process
  overhead. The macgui row is the representative signal — a real
  33-segment `ClarusC.APPL`-shaped compile, genuinely **1.13x faster** —
  using the CURRENT working-tree `clarusc/macgui.cla` (byte-identical
  between old and new base since Task 1 never touched it, so no fresh
  freeze was needed; the layer1 phase's own `/tmp/l1src` frozen-source
  procedure is confirmed stale — its source predates this phase's
  immutable-parameters checker and fails to compile against it, 11
  `cannot assign to parameter` errors — but wasn't required here). The
  RSS increase (+9.05%) is real at this scale too, not a small-fixture
  artifact; recorded as an open observation in the ROADMAP entry
  (plausible suspects: new call-site copy temps, classification-flag
  arena growth), not investigated further this task.
- **T2 fully green at `5e44fd3`** (run post-final-review, 2026-08-12
  17:36 JST): `scripts/test-merge.sh` PASS in 225s — T1 body 18s,
  `internal/selfhost` 89s, gated native `internal/mactest` emulator lane
  118s. (The whole gate now fits in under 4 minutes — the stacked
  phases' compiler speedups shrank what used to need a 30m selfhost
  ceiling.) Merge remains Andrew's call.
- **Docs (Task 8 step 4):** findings doc §2.1 annotated `[FIXED
  2026-08-12]`; ROADMAP phase entry added (design/plan paths, task
  ledger, fix rounds, perf table, deferred items); this STATUS section.
- **Deferred (full detail in ROADMAP entry):** bare-`EIntr` arg release
  gap on both lanes (pre-existing, narrowed not closed); `KArr` param ABI
  still out of scope (KStr/KRec only this phase); `toBytes` mutation
  guard fires on method name alone (inert today, one registrant).

**Next steps unblocked by this phase:** the precompiled-artifacts design
notes (`docs/superpowers/specs/
2026-08-12-precompiled-artifacts-design-notes.md`) were deliberately
parked pending this ABI rewrite (its own "Sequencing decision" section) —
that prerequisite is now satisfied, so a future session can pick that doc
back up and plan the bake/object-code/artifact-cache work on a frozen
param ABI.

## 5. runtime-ir-bake phase (2026-08-12/13, branch `runtime-ir-bake`) — DONE, T2 GREEN

Implements precompiled-artifacts item 3 at IR depth: bakes the runtime's
post-`lowerProgram` IR (unconditional superset, all 17 68k-lane modules)
into a stamped `'CLIR'` resource; `ClarusC.APPL` consumes it by default,
the host CLI opts in via `--rtbake FILE`. check#2 and every manifest
splice conditional are retired. See the ROADMAP's `runtime-ir-bake` entry
for the full task ledger, latent-bug finds, design-claim narrowing, perf
table, deferred items, AND the T2-blocker root-cause/fix writeup —
summary here.

- **7 tasks, commits `322765a..c99d95a`, a Task 7 close-out wave
  (`c99d95a..ac423b0`), then the T2-blocker fix (`3bdbb3b`).** Task 1
  (probe, no tree commits) found the naive superset splice breaks 26/28
  non-UI native fixtures (dispatcher-synthesis gate bug) and narrowed
  the check#2 assumption. Task 2 fixed the dispatcher bug + made the
  from-source splice unconditional superset. Task 3 built the `'CLIR'`
  serializer. Task 4 built the loader (`--rtbake`) + leak-gate bake-path
  twin. Task 5 closed the full-corpus byte-identity gap both lanes (3
  fix rounds, Opus review). Task 6 wired `ClarusC.APPL`'s bake-by-default
  path and root-caused a real cg68k `fromBytes`/`toBytes` stride-2
  codegen bug the bake path exposed (2 fix rounds), then proved
  byte-identity on real Snow hardware (3 Snow runs). Full ledger:
  `.superpowers/sdd/2026-08-12-runtime-ir-bake/progress.md`.
- **Task 7, Step 0 (housekeeping, commit `a5d23fd`):** fixed three
  deferred review minors — stale doc comments describing retired
  conditional-splice gates as live consumers (`check.cla`, `cprint.cla`);
  reverted `cases_resources.cla`'s workaround for the now-fixed cg68k
  stride bug back to the natural `.toBytes()`+`buf[i]` form, making it a
  standing regression test; added the loud duplicate-reserved-name
  refusal `cliResolveBakeIr` was missing (`main.cla`).
- **Step 1 (snapshot regen, commit `ac423b0`):** `clarusc/clarusc.c`
  regenerated to a Go-free fixed point in 2 bootstrap rounds (same as
  param-abi's own regen). Verified freshness and fixed point
  independently before committing. Full `go test ./internal/selfhost
  -count=1 -timeout 30m` green, **93s**, including
  `TestSnapshotFixedPoint`. `CLARUS_BAKE_FULL=1 go test ./internal/bake
  -run TestBakeFullCorpus` green too.
- **Step 2 (perf), 10-pair interleaved medians, host,
  `/usr/bin/time -l`, using the regenerated snapshot compiler
  (`-O1`):**

  | Benchmark | From-source | `--rtbake` | Speedup |
  |---|---|---|---|
  | `emit68k clarusc/macgui.cla` (37 segments) wall time | 0.335s | 0.170s | ~1.97x faster |
  | Peak RSS, `emit68k clarusc/macgui.cla` | 197.0 MB | 198.8 MB | ~1% higher |
  | Host self-compile (`emit clarusc/main.cla`) wall time | 0.625s | 0.410s | ~1.52x faster |
  | Peak RSS, host self-compile | 330.6 MB | 328.1 MB | ~1% lower |
  | Bake generation (one-off), `--bake-ir --lane 68k` | 0.04s / 22.5 MB peak RSS | — | — |
  | Bake generation (one-off), `--bake-ir --lane c` | 0.02s / 18.7 MB peak RSS | — | — |

  Both benchmarks show real wall-time wins with flat peak RSS either way.
  Raw 10-pair data in `.superpowers/sdd/2026-08-12-runtime-ir-bake/task-7-report.md`.
  The Mac-side win was measured on real Snow hardware in Task 6: a
  bake-path `TickProbe` compile completed in 55m2s wall clock
  (settle=55m), against the pre-phase ~66m reference — directional, not
  a controlled pair (different sessions/settle windows/baselines).
- **Step 3 (docs):** ROADMAP `runtime-ir-bake` phase entry (task ledger,
  latent-bug finds, design-claim narrowing, perf table, deferred items,
  T2-blocker root-cause/fix writeup); this STATUS section;
  precompiled-artifacts notes doc's Staging section marked stages 1+2
  implemented; the design doc annotated at the three claims Tasks 1/4/5
  narrowed.
- **Step 4, T2 first run: found a real, pre-existing regression** (two
  independent latent bugs — a stale List/TE Manager master pointer
  across heap-compacting `NewPtr` calls in 5 sites across
  `uitable`/`uitext`/`ui`/`uiwidgets.cla`, and `cgEmitPanic`'s
  pre-param-abi by-value string push, which made every native
  list-bounds panic print an EMPTY message and hid bug 1's own
  diagnostic for a full session). Root-caused and fixed same day,
  commit `3bdbb3b` — see section 0d above and the ROADMAP entry's "T2
  blocker" subsection for the full narrative. The prior session's
  leading hypothesis (Task 5's splice reorder, `e72b92a`) was disproven
  by a code-independent repro flip, not confirmed.
- **Step 4 finisher (regression test, same day):** added
  `testdata/runerr/listindex.cla`/`.err`/`.behavior` to
  `TestRunErrOn68k`, exercising `cgEmitPanic`'s inline list-bounds path
  specifically (host-side `behavior_test.go` also auto-picks it up via
  its glob, T2 not T1).
- **T2: GREEN at `3bdbb3b`, 232s** (T1 body 11s, `internal/selfhost`
  92s, gated native `internal/mactest` lane 124s, `CLARUS_BAKE_FULL`
  bake corpus 5s). **Merge-ready from a testing standpoint.**

**Deferred / phase debt (full detail in ROADMAP entry):** `rtUiTableClick`'s
row math still has no upper clamp against the live row count (deliberate
— a clamp would mask a recurrence of the same bug class); include-dedup
fallback trigger is broad (correct but slower, narrowing direction
recorded); object code + linker (stage 3.5) is next, no longer blocked;
everything param-abi already deferred remains open. Plus, from the
final-review fix wave: the stamp-proxy gap (stamp hashes the committed
`clarusc.c` snapshot, not a mid-phase dev binary's own edited sources —
bounded/accepted, longer-term fix is hashing the runtime module source
set); deliverable 5(c)'s honest narrowing (runtime-attributed
diagnostics are unreachable on the bake path — check#1 never walks
baked decls; `declFileTab`'s actual consumer is nested-include dedup via
`bkComputeManifestPaths`); and a standing rule — **re-run
`TestClarusCBakePathOnSnow` (opt-in, `CLARUS_SNOW_TESTS=1`) manually
after any change to `clarusc/bake.cla` or `clarusc/macgui.cla`**, it is
the only proof of the `ClarusC.APPL` default path and neither T1 nor T2
boots it.

## Recommended next steps (in order)

0. **RESOLVED (memory-leak-fix phase, 2026-08-12) — root-caused and fixed
   host-side.** The cross-compile slowdown investigated below was
   clarusc leaking ~42,845 Memory Manager blocks per compile (missing
   release, rc=1 — synthetic store-temp prologue births, `.clear()`
   skipping element release, and never-reset intern-pool tables); see
   `docs/superpowers/specs/2026-08-12-cross-compile-degradation-findings.md`
   (per-item `[FIXED]`/`[DEFERRED]`) and the ROADMAP's memory-leak-fix
   phase entry. Fixed on both lanes; the host-side `DoubleCompile` gate
   (`internal/mactest/leakgate_test.go`) now proves 0 growth/compile,
   byte-identity-clean. The Snow two-compile rerun below is now the
   validation step for the fix (expect compile #2 ≈ compile #1 per-phase
   timing); once confirmed, `CLARUS_MACRESIDENT_SETTLE` sizing in step 1
   can drop from its degraded-compile-2 numbers back toward compile-#1-only
   sizing. Original investigation notes (context for the fix), unchanged:
   In one `ClarusC.APPL` process, compile #2 (`catprobe.cla`, comparably
   tiny) ran ~4x slower than compile #1 across EVERY phase — whole-program
   check 35m vs 5m, Measure 2h20m vs 36m, segment-1 emit 49m vs 20m
   (emulated Mac II time; `now()` reads emulated Time, so these are true
   real-hardware durations even under fast-forward). Uniform cross-phase
   degradation pointed at heap/Memory-Manager-level trouble (fragmentation
   or compaction thrash as the 48MB partition fills across compiles) —
   i.e. something surviving `driveReset`/`resetDiags`/`astReset`, or
   allocation churn the arena resets don't return — rather than one bad
   algorithm, which is exactly what the fix confirmed. Both reruns were
   killed/failed on settle timing, NOT on a compile error: compile #1
   PASSed and BUILT every time (live bar + spinner + ticker confirmed
   working on screen by Andrew, 2026-08-12); compile #2 also proceeded
   correctly, just degraded. Evidence: the live-log phase ledger's timing
   entries (`.superpowers/sdd/2026-08-11-clarusc-live-log/progress.md`)
   and screenshots under that workspace's `evidence/`.
1. **IN PROGRESS (launched 2026-08-12 09:48 JST, detached): the Snow
   acceptance rerun.** Running at commit `0e633c2` via
   `.superpowers/sdd/2026-08-12-memory-leak-fix/snow-rerun.sh`
   (`CLARUS_MACRESIDENT_SETTLE=2h30m`, `-timeout 5h`, mouse-move nudger
   against the display idle-lock); log:
   `.superpowers/sdd/2026-08-12-memory-leak-fix/snow-rerun.log`. The
   formal assertions (byte-identity vs host oracles, alert-free trace,
   standalone TickProbe boot) fire when the settle expires ~12:18 JST —
   CHECK THAT LOG for the verdict. Interim results confirmed live by
   Andrew (10:15-10:45 JST): compile #1 itself is 3-6x faster (Measure
   36m34s -> ~10m, seg-1 emit 20m34s -> ~3.5m, seg-2 ~2.5m) — the leaks
   were self-poisoning even the first compile — and compile #2's
   per-phase times ≈ compile #1's (degradation GONE on hardware). Both
   compiles finished and ClarusC.APPL quit cleanly to Finder, no alert.
   Once the verdict is PASS, future runs can size
   `CLARUS_MACRESIDENT_SETTLE` off ~20m/compile (e.g. 45m-1h settle),
   not the old degraded numbers. Procedure notes (for future runs): boot
   Snow at 1x, engage fast-forward from the TOOLBAR after the app is up
   (`start_fastforward` at boot hangs the launch path —
   `macresident_test.go:79`); fast-forward is not a steady ratio
   (observed 4-7x). The worktree now HAS the `snow/`/`toolchain/`/
   `macplus/`/`Retro68/` symlinks (created 2026-08-12, not in git).
2. **Capture real on-Mac per-phase timings** using the instrumentation —
   partially DONE 2026-08-12: compile-#1 numbers for tickprobe (3 seg)
   are in the ledger (Measured 36m34s / seg-1 emit 20m34s of ~66m total —
   §1.7's double-codegen dominates); the degradation investigation (step
   0) supersedes the rest of this item.
3. **DONE (clarusc-live-log phase, 2026-08-11, this branch).** Landed the
   live-log-window spec (`2026-08-10-clarusc-mac-live-log-design.md`,
   including its §3b amendment) — full detail in the ROADMAP's
   `clarusc-live-log` phase entry. Frozen-scenario goldens re-verified,
   no churn.
4. **PARTIALLY DONE (param-abi phase, 2026-08-12) — see section 4 above.**
   §2.1 (`string`'s by-value `Str255` call ABI) is fixed — parameters now
   pass `KStr`/`KRec` by address, storage unchanged. Remaining
   Layer-2/Layer-3 candidates: §1.7's full double-codegen fix (needs
   relocation — this is now unblocked to plan against a frozen ABI, see
   the precompiled-artifacts design notes), or codegen's
   calls-out-for-everything pattern (findings doc §2.3).
5. **DONE (memory-leak-fix phase close-out, 2026-08-12) — see section 3
   above.** T2 (`scripts/test-merge.sh`'s `go test ./internal/selfhost`
   body) is fully green; the two pre-existing `TestClarusModules` goldens
   are fixed.
6. **SUPERSEDED — merged.** `mac-resident-clarusc`, `map-hashtable`,
   `datetime-instrumentation`, `layer1-compiler-perf`, `memory-leak-fix`,
   `param-abi`, and `runtime-ir-bake` (the six-phase stack plus
   runtime-ir-bake) were all merged to `main` 2026-08-13 09:56 JST
   (fast-forward `322765a..b16e8f0`) and pushed to `origin/main` — see
   the top of this document. `fallback-trigger-narrowing` is now on
   `origin/main` too (its own Snow rerun PASSED, section 0c above);
   `precompiled-artifacts` (the `object-code-linker` phase,
   section 0b above) was merged and pushed too (2026-08-14, after its
   Snow re-run PASSED) — see the top of this document.
7. **DONE and MERGED — see section 0b above.** Precompiled-artifacts
   stage 3.5 (object code + linker) was speced, planned, implemented,
   fully gated (T2 GREEN, Snow PASS at `6bf4f6e`), and merged to
   `origin/main` (`e143af1..6009c65`, 2026-08-14). Stage 4 (the
   user-module artifact cache) is next in the precompiled-artifacts
   notes doc's own staging.
