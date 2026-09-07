# Task 13b brief -- `AdspLeak` toolbox-suite case (39 -> 40)

Plan: `docs/superpowers/plans/2026-09-07-appletalk.md` Task 11's `AdspLeak` item, moved
to Task 13 by ledger ruling (see `task-11-brief.md` "Interfaces: AdspLeak" and
`task-13-brief.md`). Spec: `docs/superpowers/specs/2026-09-06-appletalk-design.md` 8.2.
Prerequisite: Task 13a (`task-13a-report.md`) -- read its "what the ROM's .DSP does
differently" notes before you design the case; the native bodies it fixed are what you
are measuring.

## The case

`testsuite/toolbox/cases_atalk.cla` gains `caseAdspLeak(): TestResult` (the file already
holds `AtalkSelf`; keep its house style -- Rule 2 fresh parameter blocks, `atPStr`,
header comment explaining what the case proves and what it deliberately does not).

What it proves: the native ADSP connection-end lifecycle leaks NOTHING. FreeMem
(`TbFreeMem`, declared locally exactly as `cases_leak.cla` does) must be EXACTLY flat --
not "within slack" -- across 20 cycles of "build a connection end, tear it down" through
the runtime's own waist:

- build = `rtAt68DspInitEnd(slot)` (dspInit on a fresh CCB + queues; allocates the
  slot's five blocks via `rtAt68CcbEnsure`), tear-down = `rtAdspDevClose(slot)`
  (dspClose on a never-opened end is harmless; then `dspRemove` through the aux block,
  then `rtAt68DspFree`'s `DisposePtr`s). No `dspOpen` -- there is no peer.
- The suite is built with `--testapi` (`tests/mactest/toolbox_68k.sh`,
  `tests/mactest/toolbox_files.txt`), which is why a case may name runtime functions
  directly (`cases_uitest.cla` calls `rtUiEveryPump()` etc. the same way).
- The runtime's driver bring-up must have run first (`rtAt68DspRef != 0`): find the
  bring-up entry (`runtime/clarus/atalk_68k.cla` ~line 300, the function that opens
  `.MPP`/`.ATP`/`.XPP`/`.DSP`) and call it through whatever public waist name the
  runtime exposes for it; if `.DSP` still fails to open (`rtAt68DspRef == 0`) the case
  must FAIL with the OSErr in its detail, never pass vacuously.
- Baselines: take `before` AFTER one warm-up cycle -- the aux parameter block
  (`rtAt68DspAuxPb`) and the slot's own PB (`rtAt68Pb[slot]`, deliberately kept by
  `rtAt68DspFree`) are allocated lazily and legitimately survive. Task 13's brief also
  says "after the first serve/stop" -- that applies only if you also cycle a LISTENER
  end (`rtLsnDevInit`/its teardown); do that as a second 20-cycle loop in the same case
  if Task 13a's report shows the listener path is sound, with its own warm-up; if the
  listener teardown is not exercisable without a peer, say so in the case comment and
  the report instead of faking it.
- Use a connection slot no suite case can hold live (the suite declares no `connection`
  globals; slot 7 of `rtConnMax` 8 is the conventional choice -- justify in a comment).
- Detail on failure: `before N after M` like `LeakCheck`.

## Counts: 39 -> 40 in FIVE places

`testsuite/toolbox/runner.cla` (`nTbCases`, the enum, `tkName`), `tests/mactest/toolbox_68k.sh`,
`tests/mactest/toolbox_jiggle.sh`, `tests/mactest/toolbox_mac.sh`, and `CLAUDE.md`'s
toolbox-count sentence (append "-- then to 39 real by Task 13b's `AdspLeak` case, which
hardware-proves ..." in the existing style; update the leading "39 `ToolboxTest` cases:
38 real" to 40/39).

## Wall clock

The toolbox suite's `run_mac` settle is 420 s and the suite was near it before this phase
(`toolbox_68k.sh` header). Measure: report the suite's total from the capture. 40
dspInit/dspRemove cycles are cheap (no network waits) -- if the suite nonetheless
overruns, say so; do not raise the settle without reporting it.

## Verification

1. `CLARUS_MAC_TESTS=1 make -j1 test T=mactest/toolbox_68k` -- 40/40, paste the
   `AdspLeak` line and the TOTAL line and the wall clock.
2. `CLARUS_MAC_TESTS=1 make -j1 test T=mactest/toolbox_jiggle` -- 40/40.
3. `make test T='testsuite/ emitui/ cg68k/goldens'` (no golden should move: this task
   adds no runtime code).
4. `scripts/test-task.sh`.

## Constraints

No runtime edits in this task (if the case exposes a runtime leak, STOP and report
DONE_WITH_CONCERNS with the numbers -- the fix is a ruling for the controller, because
runtime edits move goldens). Emulator discipline as in Task 13a's brief. Commit on
`appletalk-t13` in `/Users/andrew/repos/clarus-wt/t13` (on top of Task 13a's commits):
`test(toolbox): AdspLeak -- native ADSP connection-end lifecycle is FreeMem-flat (40 cases)`.
