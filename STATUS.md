# Session status — 2026-08-15 (clir-load-perf COMPLETE: all gates GREEN on tip 1d88846; merge on Andrew's word)

Handoff summary. **The `clir-load-perf` phase is COMPLETE and fully
gated — T1 throughout, T2 PASS (261s, pre-follow-on tip; every
follow-on task re-ran the gate set incl. both native suite boots), and
BOTH Snow-hardware gates PASS on the final tip `1d88846`
(`TestClarusCBakePathOnSnow` 1206s; `TestMacResidentFailedCompileStaysAliveOnSnow`
1201s, 20m settle + toolbar fast-forward procedure). The branch is NOT
merged — merge is Andrew's call.** The local checkout works on `main`
directly (no-worktree convention); `clir-load-perf` is ahead of `main`
at `42c7265`.

Post-Task-10 follow-ons on the branch (each subagent-implemented +
independently reviewed, ledger in `.superpowers/sdd/2026-08-15-clir-load-perf/`):
`u32At`→`intAt` rename; `stringAt` switched to a 1-byte Pascal prefix
(CLIR format unchanged — loader hops the 3 zero bytes);
**`list.clone()`** (flat-element bulk copy, fixed the field-measured
4m21s copy-on-install regression to 9s); progress-bar repaints removed
from the uitest trace; **`on App.log(line: string)`** handler +
ClarusC adoption (the captured `out` trailer is now the persistent
timestamped compile log).

**Field-proven numbers (Snow guest time, final tip):** compile #1 load
window ~4m55s–5m23s (baseline 10m02s) + install 4–9s; **compile #2
skips load entirely** ("parsed earlier this session" memo line) —
**install-only ~5s vs ~10m baseline (~120x on the repeat-compile
path)**. The spec's ≤60s first-compile target remains missed (~5min);
the residual lever (runtime loop-body ~10x off theoretical floor) is
recorded debt.

## 0. START HERE next session

**Remaining: merge.** All gates are green on `1d88846`; merge to
`main` happens only on Andrew's explicit request (fast-forward). If a
follow-up perf phase is wanted for the ~5min first compile, the debt
list's "runtime loop-body residual" lever is the starting point;
`strPool`'s install loop is now `clone()`-eligible too (clone review
M3).

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
minors; three new panic fixtures (`stringat_oor`/`textrange_overflow`/
`textrange_oor`) are host-only (pinned by
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
