# Session status — 2026-08-29 (68k-call-result-release: COMPLETE, T2 green, not merged)

Handoff summary. **The `68k-call-result-release` phase (branch
`68k-call-result-release`, based on `main` at `0148c6a` — `extern-ptr-call`
and everything before it are already merged to local `main`, NOT pushed)
fixes a real `emit68k` memory leak recorded in `../68kbbs/docs/
memory-leak.md`: a user function's handle-typed result (or a textview
`.text` getter box) consumed directly — as an argument, operand, or
receiver — was never released on the native lane. Fix is producer-side
tracking in `cg68k.cla`: `cgCallFnScalar` and the `IUiGetTextviewText` arm
now spill their +1 result to a `cgNewTrackedTmp` slot with
`cgLastTrackedOff` set LAST, so the existing `SAssign`/`SReturn` handoffs
and the end-of-statement flush release it exactly like any other tracked
temp — no new consumer-side code needed. Two hardenings landed alongside
(both leak-only, no UAF risk either way): a `cgLastTrackedOff` latch/
restore in `cgEmitStoreScalarAny` (a dst-address side effect can no longer
stomp the src's own verdict) and a clear-before-value-eval in the six
container-set/push arms (a tracked receiver can no longer be handed off in
place of the value). Two enablers were required first: `cgTmpSlots` bumped
14 -> 24 (a real in-tree `cprint.cla:3868` statement sits at exactly the
old 14-slot ceiling today and needs 21 after the fix — proven empirically,
not just estimated — with a full mechanical 31-fixture golden rebless) and
a `fpIntrCall12` split in `cprint.cla` for CODE-segment headroom (the
semantic fix alone pushed that function past the 32 KB single-segment
ceiling; the split is proven output-neutral by byte-diffing emitted C for
fixed inputs before/after, the same remedy native-5e's Task 14 used the
first time `fpIntrCall` was split). Host lane is untouched (it was already
correct) and unaffected throughout.

**Close-out's first T2 run found a real red** on
`TestToolboxSuiteJiggleOn68k/Popuptable` — every logical/data assertion in
the case passed, only the visual checksum triple failed. A per-commit
bisect (one native boot per commit, in a scratch worktree) proved this
PRE-EXISTING, not a regression from this phase's codegen: the first bad
commit is `520f227`, which is test-only (adds the 33rd suite case,
`LeakCheck`); every codegen commit (`49e1999`, `8fc85dd` incl. `064b37a`/
`5bf7080`, `cbc1949`) passes the jiggle gate standalone. Root cause,
confirmed with a heap probe: `rtUiLdefDraw` (`runtime/clarus/uitable.cla`)
derived its row's master pointer via `rtListAt` once, above the per-column
draw loop, then let three allocating Toolbox calls per column run before
reading through it — the stale-master-pointer-across-compaction class this
file's own Standing rules section already tracks (now eight instances,
see that section). `LeakCheck` merely grew the image and the suite's own
case-row list enough to shift heap layout past the tipping point where the
stale read actually bites; the bug itself predates this phase and was
already present (dormant) on `main`. Fixed in `bff3268` (`runtime/clarus/
uitable.cla`, +29/-2): the derive moves inside the column loop,
immediately before the read, plus an identical latent fix in the
`RtFtChar` column-draw arm. Shared runtime file — the cprint/host lane had
the same bug (identical two hunks in the emitui golden diff) — so the fix
is not native-only, even though nothing on the host lane could observe it.
`internal/cg68k` (55 fixtures) and `internal/emitui` (14 fixtures) goldens
reblessed mechanically as a result (the fixed function grows, shifting
label ids/JT slots/segment packing everywhere, same shape as the
`cgTmpSlots` bump's own rebless). Four more sites with the same defect
shape were found but deliberately NOT fixed (each needs its own analysis;
none is implicated in this failure) — filed in `docs/TODO.md`. Full
detail: `.superpowers/sdd/2026-08-29-68k-call-result-release/
task-debug-report.md`.

Full T2 PASS at `bff3268` (see §1). NOT merged, NOT
pushed — merge only on Andrew's request.**

## 0. START HERE next session

No pre-merge obligations are owed by this phase specifically: the fix is
pure native-lane (`emit68k`/`cg68k.cla`) codegen with no new Toolbox trap
surface and no OS-version-dependent behavior, so there is no System 7
(Snow) spot check the way filesystem-api's new HFS traps needed. The proof
is hardware-level: the toolbox suite's new `LeakCheck` case shows FreeMem
exactly flat (3570496 -> 3570496 bytes) across 1500x4 direct-consumption
shapes on the emulated Mac Plus (System 6, Mini vMac,
`TestToolboxSuiteOn68k`).

Otherwise the phase is fully closed on the branch: snapshot regenerated
and fixed-point-verified, T2 green (after the debug detour above), docs
closed out.

**Residual risk worth a second look before merge, per the debug report's
own §8:** the fix's own verification run (`internal/cg68k`, `internal/
emitui`, `scripts/test-task.sh --smoke`) did not include the four frozen
UI scenario goldens (`smoke_bounce`, `smoke_mandel`, `texteditor`,
`bookmarks`) or the rest of T2 — that only ran as part of THIS close-out
task's own full `scripts/test-merge.sh`, see §1. Also worth noting: the
suite GUI's own case table was drawing through the identical stale
pointer in failing builds (nothing asserts on its pixels today, so it
never went red) — a future case that checksums the suite GUI's own table
would catch this defect class earlier next time.

**One item is deliberately left leaking, one type-kind over, and recorded
in `docs/TODO.md` rather than fixed here:** `makeRec().field` (a
handle-bearing `KRec` call result used as a receiver/operand) still leaks
— `cgExprAddr`'s generic fallback materializes it via untracked
`cgAllocTmpOff` rather than `cgNewTrackedTmp`. Confirmed by the Task 1
probe report, ruled out of scope by the spec ("Any KRec-return redesign
beyond probe item 2's verification"), and left as a suggested follow-up
(`cgMaterializeToTemp` should use `cgNewTrackedTmp` when
`irExprKind(e) == ECallFn and cgNeedsRelease(irExprType(e))`).

**What this phase built** (4 implementation tasks + this close-out; full
detail in `.superpowers/sdd/2026-08-29-68k-call-result-release/`):

1. **Probe wave** (Task 1, `fc85c1a`, fix round `ce8d87d`) — verified six
   assumptions from the spec against the unmodified tree: handoff coverage
   PASSES (with two documented pre-existing narrow leaks and one
   recommended hardening); no argument/assignment/discard `KRec` sibling
   gap (the receiver-context hole above is the one exception, out of
   scope); `cgTmpSlots` headroom **FAILS** — a real bump is mandatory, not
   optional (proven empirically: `cprint.cla:3868` sits at 14/14 today,
   needs 21 post-fix); no D0-clobber reorder is needed in
   `cgCallFnScalar` (`cgFlushArgReleases` already brackets its walk with a
   D0/D1 save/restore); no double-tracking risk across the 14 existing
   `cgNewTrackedTmp` call sites; golden blast radius scoped (one `cg68k`
   fixture touched by the semantic fix alone, all 31 touched by the
   `cgTmpSlots` bump).
2. **Producer-side fix** (Task 2, `49e1999` cgTmpSlots bump + mechanical
   rebless, `064b37a` fpIntrCall12 split, `5bf7080`/`8fc85dd` semantic fix)
   — `cgCallFnScalar`'s scalar-return path unconditionally spills a
   `cgNeedsRelease` result into a `cgNewTrackedTmp` slot (folding the old
   discard-only branch into the general case), storing D0 without
   reloading it (`cgStoreD0At` leaves D0 intact) and setting
   `cgLastTrackedOff` as the LAST action so it always reflects THIS call's
   result. Review's fix round moved the tracking block to after the
   arg-release flush (matching the probe's ruling-1 ordering) and
   corrected an unflagged report deviation.
3. **Getter-arm fix** (Task 3, `cbc1949`) — the `IUiGetTextviewText` arm
   gets the identical treatment; pre-fix N=4 concurrent leaked slots,
   post-fix N=5 (one more tracked, correctly released), spill slot
   `-20(A6)` verified. Zero golden rebless (this arm has no existing
   fixture coverage).
4. **Hardware proof** (Task 4, `520f227`) — toolbox suite's new
   `LeakCheck` case: FreeMem exactly flat (3570496 -> 3570496) across
   1500x4 direct-consumption shapes on the emulated Mac Plus. Suite is
   now 33 cases (32 real + `SelfCheck`).
5. **Hardware proof surfaced a pre-existing bug, debugged and fixed**
   (unplanned debug task, `bff3268`) — Task 5's first T2 run went red on
   `TestToolboxSuiteJiggleOn68k/Popuptable`; bisected to PRE-EXISTING
   (first bad commit is the test-only `520f227`, no codegen commit is at
   fault) and root-caused to a stale-master-pointer bug in
   `rtUiLdefDraw` (`runtime/clarus/uitable.cla`) that predates this
   phase. Fixed with a minimal re-derive-after-allocation change (+29/-2,
   two sites in the same function); `internal/cg68k`/`internal/emitui`
   goldens reblessed mechanically. Full detail above and in
   `.superpowers/sdd/2026-08-29-68k-call-result-release/
   task-debug-report.md`.
6. **Close-out (Task 5, this commit)** — bootstrap snapshot regenerated
   (twice — once pre-fix, redone against `bff3268` after the debug task
   landed) and fixed-point-verified; full T2 green; `docs/TODO.md`/
   `docs/ROADMAP.md`/`CLAUDE.md` closed out (this file included).

**Deferred follow-ups** (from the Task 1 probe report plus the debug
task's own §8, all recorded in `docs/TODO.md`, not re-litigated): the
`makeRec().field` receiver-context sibling leak (above); extending
`testdata/cg68k/smalltmp_ceiling.cla` to pin the new 24-slot ceiling
(optional polish — it currently pins "works at 14", which the bump
doesn't invalidate); a host-lane parity note that `pop`/`shift` used as an
operand or receiver leaks identically on both lanes (pre-existing,
report-only per the spec); four more stale-master-pointer sites of the
exact shape `bff3268` fixed, found but not fixed (`uitable.cla:411`'s
`RtFtStr` in-trap `DrawText` read, `uitable.cla:887`'s
`rtUiTableSyncOne` `InvalRect`, `uiwidgets.cla:853`/`955`'s TERec
`InvalRect` paired with `ValidRect`, `uiwidgets.cla:1093`'s `table.
selected` setter `InvalRect`).

## 1. Gate results (this phase)

1. **Snapshot fixed point**: PASS, twice. First (pre-debug, at `520f227`):
   `go test -count=1 -timeout 30m -run TestSnapshotFixedPoint
   ./internal/selfhost` FAILed (stale snapshot — `cg68k.cla`/`cprint.cla`
   changed under this phase), regenerated Go-free per the printed recipe,
   re-run -> PASS. That snapshot was then DISCARDED (checked out back to
   HEAD) once `bff3268` landed, and the regen redone from scratch against
   the new HEAD (same recipe, `runtime/clarus/uitable.cla` now included
   in the compiler's own build) -> PASS again ("snapshot fixed point
   reached").
2. **First T2 run** (`scripts/test-merge.sh`, foreground, at `520f227`):
   T1 body PASS (25s), `internal/selfhost` PASS (132s), then
   `internal/mactest` FAILed — `TestToolboxSuiteJiggleOn68k/Popuptable`,
   see the handoff summary above and the debug report for the full
   bisect/root-cause trail. Debugged and fixed out-of-band (`bff3268`,
   not this task).
3. **Second T2 run** (`scripts/test-merge.sh`, foreground, at `bff3268`):
   T1 body PASS, `internal/selfhost` PASS, `internal/mactest` PASS (347s
   — the jiggle gate and all 4 frozen UI scenario goldens included,
   confirming `bff3268` actually fixes the regression), then the
   `CLARUS_BAKE_FULL=1 internal/bake` full-corpus step FAILed:
   `testsuite/toolbox/runner.cla:482:34: undefined: caseLeakCheck`. Root
   cause: `internal/bake/bakeidentity_test.go`'s hand-maintained
   `toolboxSuiteGUIFiles` mirror of `internal/mactest`'s own file list
   was never updated by Task 4 (`520f227`) to include the new
   `cases_leak.cla` — a real, pre-existing gap in that commit, unrelated
   to `bff3268`. This was the first time in the whole phase that T2 had
   run far enough to reach this late, opt-in-only step. Fixed
   out-of-band (`cd43280`, one-line file-list addition, not this task).
4. **Third T2 run** (`scripts/test-merge.sh`, foreground, at `cd43280`):
   PASS — see this task's own report for the per-suite timing breakdown
   and confirmation the four frozen UI scenario goldens passed UNCHANGED.
5. **Docs**: this file, `docs/ROADMAP.md` (new "Where we are" paragraph
   plus the regression-story addendum and the Standing-rules bug-count
   bump), `docs/TODO.md` (seven deferred follow-ups: three from the
   probe report, four from the debug report's §8), `CLAUDE.md`
   (toolbox-suite count 31->32 real, one-line phase mention in the
   build/phases narrative) — all committed alongside `clarusc/clarusc.c`.

## 2. Prior phases (all merged; recap pointers only)

- **extern-ptr-call** (`= ptr`, pascal-convention call through a runtime
  pointer) — merged to local `main` 2026-08-28 (this branch's own base,
  `0148c6a`). NOT pushed (local main is 12 commits ahead of
  `origin/main` = `9b2eea8`).
- **filesystem-api** (`file.makeDir/delete/list/exists/info/setInfo/
  rename/move`, both lanes) — merged AND pushed. System 7 (Snow)
  verification for that phase remains UNVERIFIED — still owed; see that
  phase's own `docs/HISTORY.md` entry.
- **transfer-crcs** (`text.crc16x`/`text.crc32`) — merged to local `main`
  2026-08-25 (part of this branch's own base).
- **binary-files** (`filehandle`, `connection` as a value, `text` binary
  accessors + `crc16`, `string(n)`, the `toolbox/` include fallback,
  emit68k's per-function big-temp pool) — merged to local `main`
  2026-08-23 (part of this branch's own base).
- **correctness-cleanup** — merged to `main` (ff `48a4696..3a4c054`),
  pushed 2026-08-18.
- **serial-connection** (fenced `connection` type, serial as first
  transport, both lanes, Snow-hardware-proved) — merged 2026-08-16.
- **clir-load-perf** — merged 2026-08-15/16. Both Snow gates PASSED.
- **attempt-abort** — merged 2026-08-15.
- **object-code-linker** — merged 2026-08-14.
- **fallback-trigger-narrowing / runtime-ir-bake / param-abi /
  memory-leak-fix / layer1-compiler-perf / datetime-instrumentation /
  map-hashtable / mac-resident-clarusc** — the 2026-08-12/13 stack, all
  merged. Recap pointers only; see HISTORY.

**Doc-hygiene note (pre-existing, not this task's job):** `attempt-abort`,
`serial-connection`, and `correctness-cleanup` are all merged to `main`
but none has its full write-up archived into `docs/HISTORY.md` yet
(HISTORY jumps from `clir-load-perf` straight to `binary-files`, with a
note explaining the gap) — a future docs pass should catch HISTORY up
through all three.

**Standing rules:** `internal/selfhost` always gets `-count=1 -timeout
30m`. Merge only on Andrew's request; main stays green (this branch does
NOT touch main).
