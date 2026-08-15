# Session status — 2026-08-15 (clir-load-perf: 10/10 tasks DONE, host T1 green; T2 + Snow gates + merge PENDING, branch unmerged)

Handoff summary for the next session. **The `clir-load-perf` phase's
implementation is COMPLETE (Tasks 1-10, host-gated throughout) but the
branch is NOT merged.** Three phase-close gates are outstanding and
need to run before any merge decision: T2 (`scripts/test-merge.sh`),
and two Snow-hardware runs required by the standing rule because
`bake.cla`/`macgui.cla` both changed this phase. The local checkout is
on `main` (this phase works directly on the `main` checkout per this
project's no-worktree-for-toolchain-symlinks convention, same as every
prior phase); `clir-load-perf`'s own commits are ahead of `main` at
`42c7265` and not yet fast-forwarded in.

## 0. START HERE next session

**What Andrew needs to decide/run, in order:**

1. **Run T2** (`scripts/test-merge.sh` — includes `internal/selfhost`
   at 30m timeout and the native `mactest` lane). Not yet run this
   phase.
2. **Run the two Snow gates** (`CLARUS_SNOW_TESTS=1`):
   `TestClarusCBakePathOnSnow` AND
   `TestMacResidentFailedCompileStaysAliveOnSnow` — the standing rule
   fires because `bake.cla`/`macgui.cla` both changed this phase (see
   0b's "Standing rules"). Use the 20m-settle/fast-forward procedure
   the attempt-abort phase established (0b below), not the old 55m
   figure. **Capture the Log-window "Verifying Baked Runtime" →
   `driveCompile` "Starting" timestamps** — this is the real Snow
   before/after; everything in the ROADMAP entry's Measured Results
   table is a Mac-Plus-scale emulator projection (~4.4x, ~145.2s
   Plus-equivalent), not a Snow measurement.
3. **Read the honesty caveat before deciding anything**: the spec's
   own ≤60s first-compile target is **likely MISSED** — projected
   ~2-2.5 minutes on Snow, not ≤60s. The **repeat-compile** target
   (skip verify+parse entirely, ~2s install only) IS met. Whether
   ~2-2.5min-down-from-~10min is good enough to ship as-is, or whether
   it's worth a follow-up phase against the debt list's "runtime
   loop-body residual" lever (hand-emitted hash/copy helpers, ~10x off
   a theoretical floor), is Andrew's call — full numbers and reasoning
   in the ROADMAP `clir-load-perf` entry.
4. **Merge only on Andrew's request**, after 1-2 are green (or after
   an explicit decision to accept a red/skipped Snow gate — that's
   also Andrew's call, not a default).

Full task ledger, measured numbers, rulings, and the complete debt
list: ROADMAP's `clir-load-perf` entry. Ledger + reports:
`.superpowers/sdd/2026-08-15-clir-load-perf/` (progress.md is the
authoritative per-task record; task-9-report.md has the raw emulator
probe numbers this phase's perf table is built from).

## 0a. clir-load-perf close-out (IMPLEMENTATION DONE — gates pending)

**What it is:** cuts the CLIR (baked-IR) load path's cost — the stretch
that clocked 10m 2s on Snow between "Verifying Baked Runtime" and
`driveCompile`'s "Starting" line for a 1.3MB artifact. Three designs,
all landed: **A** drops a redundant load-time header-hash re-verify
(`bkHeaderVerified` consume-once flag); **B** parses the CLIR once per
app session instead of every compile (`bkParsedValid` memo +
copy-on-install fix for a reference-aliasing hazard `bkInstallArenas`
would otherwise have hit); **C** adds four bulk `text` range-read
methods (`hashStep`/`intAt`/`stringAt`/`textAt`) plus a cheaper djb2
hash shape, bumping `bkFormatVersion` 6→7, and rewrites `bake.cla`'s
load path onto them.

**Scale:** 10 tasks, 11 commits (`11cf5d6..5db9e1a`), one opus-run
audit task (no commits — proved B's copy-on-install safe across 43
arenas), one measurement-only task (no commits — the emulator perf
probe), each task subagent-implemented and independently reviewed
(opus for the two load-bearing tasks: the audit and design B's own
implementation).

**Numbers that matter (Mac-Plus-scale emulator probe, real-CLIR
projection):** body hash 153.98→60.63 µs/byte (2.54x); U32 parse walk
200.91→55.05 µs/byte (3.65x); bulk byte-range copy 182.14→0.51 µs/byte
(359x). Projected real-CLIR (1,255,314 bytes) load-path window:
638.8s→145.2s (~4.4x). **Spec's ≤60s first-compile target: likely
MISSED (~2-2.5min projected on Snow).** Repeat-compile target (install
only, ~2s): met. See ROADMAP entry for the full methodology and
honesty caveats — these are Mac Plus (8MHz, no-cache) guest-tick
numbers extrapolated linearly; no Mac II boot lane exists to measure
Snow directly yet.

**Gates status:**
- **T1: GREEN throughout** (every task; `--smoke` where `runtime/`/
  `clarusc/` were touched).
- **T2: NOT YET RUN this phase.**
- **`CLARUS_SNOW_TESTS=1` `TestClarusCBakePathOnSnow`: NOT YET RUN**
  this phase (standing rule fires — `bake.cla`/`macgui.cla` changed).
- **`CLARUS_SNOW_TESTS=1`
  `TestMacResidentFailedCompileStaysAliveOnSnow`: NOT YET RUN** this
  phase (same standing rule; also proves design B via the Task 8
  session-log assertion).
- **Merge: NOT DONE.** `clir-load-perf` branch sits ahead of `main` at
  `42c7265`; fast-forward is a merge-time decision, not automatic.

**Debt carried (full list with citations in the ROADMAP entry):**
runtime loop-body residual (~480 cycles/byte, ~10x theoretical —
future lever: hand-emitted helpers or loop-codegen work); memo
lane-tag gap; testapi single-compile coverage gap; `stringAt`
hardware-consumption-shapes watch item; `ser.cla` still per-byte
(deliberate non-goal); `drive.cla:1854` stale parenthetical;
`bkLoadOverrun`/`rtTextStringAt`/`bkCheckRtbakeHeader` comment-drift
minors; four new panic fixtures (`stringat_cap`/`stringat_negative`/
`textrange_overflow`/`textrange_oor`) are host-only (pinned by
`internal/selfhost/behavior_test.go`, never booted natively, matching
the established convention for fixtures whose semantics don't need
hardware); `bkReadObjCode`'s pre-existing `nHoles` spin; truncate-on-
reuse recorded as an alternative to B's copy-on-install, not chosen;
host `--rtbake` path still verifies once per process (fine, by
design). Also fixed this task: four stale ROADMAP cross-references to
the now-deleted `bkInstallObjCode` (Task 7 of this phase deleted it),
each reconciled in place with a superseded-claim parenthetical, plus
one reconciling sentence in `clarusc/ir.cla:375`.

## 0b. Prior phases (all merged; recap pointers only)

- **attempt-abort** (`attempt { } aborted msg { }` + `abort(msg)`,
  cooperative unwinding, both lanes) — merged 2026-08-15 (fast-forward
  `97d043c..d299b72`), pushed to `origin/main`. host self-compile
  −11.5% vs pre-feature after the Task 6b `canAbort` fixpoint;
  `ClarusC.APPL` panics and uncaught aborts are now user-visible
  (beep+alert) instead of silent exits; two real unwind leak classes
  found and fixed. Full detail: ROADMAP's `attempt-abort` entry.
  Ledger: `.superpowers/sdd/2026-08-14-attempt-abort/` (retained, incl.
  `deferred-gates.md` — every item marked run/green). Reference:
  `docs/clarus-language-reference.md` Ch5 ("Attempt and Abort"), Ch12,
  Ch13. Debt carried forward from this phase (still open, not
  clir-load-perf's concern): PBM icon parser rejects CR line endings on
  the Mac (deferred per Andrew, "worry about that later"); a
  `rt_ext_UiValidRect` Retro68 link gap blocks fresh Retro68/cprint-lane
  rebuilds (pre-existing, unrelated); cprint-lane UI dispatcher has no
  abort-default check (acceptable — that lane is slated for
  retirement); no automated dispatcher-default test on either lane;
  `declIsRuntimeOrigin`'s symlink-equivalence residual;
  `TestRunErrOn68k` can't boot `App.startCLI`-shaped fixtures.
- **object-code-linker** (stage 3.5, CLIR v6 baked object code,
  −41%/−35% emit68k) — merged 2026-08-14 (`e143af1..6009c65`). Its
  Snow saga (C-lane signed-overflow UB hash bug, CLAR_*32 fix, re-run
  PASS) is recorded in ROADMAP; debt list in its entry. Note:
  clir-load-perf's Task 7 deleted this phase's `bkInstallObjCode`
  function outright (design B needed the pending arenas it truncated
  to survive un-truncated across compiles) — the object-code-linker
  ROADMAP entry's own references to that function now carry
  superseded-claim parentheticals pointing here.
- **fallback-trigger-narrowing** (CLIR v5 per-module source hash,
  include-dedup by construction) — merged 2026-08-13.
- **runtime-ir-bake / param-abi / memory-leak-fix /
  layer1-compiler-perf / datetime-instrumentation / map-hashtable /
  mac-resident-clarusc** — the 2026-08-12/13 stack, all merged
  (`322765a..b16e8f0`). Highlights that remain operationally relevant:
  the leak fix made per-compile growth 0 and compile #2 ≈ compile #1
  on hardware (later superseded in kind, not premise, by
  clir-load-perf's design B, which now skips compile #2's parse
  entirely rather than merely making it cheap); `cgEmitPanic`'s
  empty-message bug is fixed and regression-tested
  (`TestRunErrOn68k`); the ~5x compiler speedup and hashtable maps
  underlie current perf.

**Standing rules (unchanged):** re-run `TestClarusCBakePathOnSnow`
(`CLARUS_SNOW_TESTS=1`) after ANY change to `clarusc/bake.cla` or
`clarusc/macgui.cla` — it is the only proof of the `ClarusC.APPL`
default bake path (fires for clir-load-perf; NOT yet satisfied — see
0/0a above). `internal/selfhost` always gets `-count=1 -timeout 30m`.
Merge only on Andrew's request; main stays green.
