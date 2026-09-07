# Task 13c brief -- Snow (System 7): interop probe, `mactest/snow/adsp_listener.sh`, the `clarusc_bake` gate

Plan: `docs/superpowers/plans/2026-09-07-appletalk.md` Task 13 Steps 1-4 (`task-13-brief.md`
is that text verbatim). Spec 8.3 / 9.5. The ONLY Snow boots of the phase. Prerequisites:
Task 13a (native ADSP green on Mini vMac, `task-13a-report.md`) and 13b.

## Before any boot

- `pgrep -fl Snow` -- Andrew's own Snow session may be running (the 68kbbs one uses
  `--serial-bridge-a tcp:1234`); `snow_run` refuses to start beside another Snow. If one
  is running, report NEEDS_CONTEXT naming the pid -- do not kill it.
- The Snow group's helper `tests/lib_snow.sh` clones `snow/Clarus.snoww` + `hdd0.img` +
  `clarus.pram` into `$WORK/snow` (`snow_disk`), installs the app into Startup Items
  (`snow_put_bin`), boots with `snow_run SECS DONE_CMD [SNOW_ARGS]`. Andrew's NETWORK
  workspace is `snow/MacII.snoww` (AppleTalk on the printer port, own `macii.pram`; see
  the header of that file and `tests/mactest/snow/serial_echo.sh` for the serial-bridge
  precedent). AppleTalk on/off lives in PRAM and the Chooser, so the `Clarus.snoww` clone
  may boot with AppleTalk INACTIVE. First job: establish, with one probe boot, whether
  the scratch clone has LocalTalk (LToUDP on `239.192.76.84:1954`, the group the host
  `atalkdrive` tool and both Mini vMacs use) alive -- e.g. boot Task 1's `register`
  program (source in `task-1-report.md` P2, rebuilt with `scripts/build-68k.sh`) and run
  `build-run/tools/atalkdrive` `find` from the host (`tests/atalk/find.sh` shows the
  invocation) -- and if not, what `lib_snow.sh` needs (a `snow_disk` variant that clones
  `MacII.snoww`/`macii.pram`, or a Snow flag). Amend `tests/lib_snow.sh` minimally and
  say what you changed and why; do not fork a second helper library.
- Snow shares the multicast group with any Mini vMac boot and the host tests: take
  `tests/lib_atalk.sh`'s `atalk_lock` around anything that puts a stack on the group,
  exactly as `tests/mactest/atalk_68k.sh` does.

## Step 1 -- interop probe (Task 1's P5)

Task 1's `register` on Snow and `lookup` on `macplus/` (LaunchAPPL boot), then the
reverse. Record the result as an appendix "P5 (Task 13c, <date>)" appended to
`.superpowers/sdd/2026-09-07-appletalk/task-1-report.md`: both directions' output lines,
node numbers, and anything System 7's AppleTalk (the version on that disk -- record it)
did differently from the Mac Plus ROM (P2/P3 verdicts: `setSelfSend`, self-lookup).

## Step 2 -- `tests/mactest/snow/adsp_listener.sh`

`require_env CLARUS_SNOW_TESTS` (and `CLARUS_MAC_TESTS`, since the client is a LaunchAPPL
boot). Snow runs `examples/atalkchat.cla` as the SERVER (built with
`testdata/ui/atalkchat_server.events`, installed via `snow_put_bin`), `macplus/` runs
the CLIENT via `run_mac` (`tests/lib_mac.sh`) with `atalkchat_client.events` -- the same
per-run NBP-type `sed` stamp `tests/mactest/adsp_68k.sh` applies, and the SAME twelve
assertions (copy `adsp_68k.sh`'s `want_line` block; the server log is extracted from the
Snow disk with `snow_get`, the client log from `run_mac`'s capture). Sequencing: Snow
must be serving before the client boots -- `snow_run`'s DONE_CMD is the hook (the
serve-then-client-then-wait choreography runs inside it, or the client boot is done
from the DONE_CMD script the way `serial_echo.sh` drives its exchange), and the server's
own watchdog/quit writes the `##CLARUS-EXIT##` trailer (`snow_done_when_trailer`). Keep
the header comment honest about the timing budget. `# timeout:` generous (the Snow
boot alone is minutes).

Run: `CLARUS_SNOW_TESTS=1 CLARUS_MAC_TESTS=1 make -j1 test T=mactest/snow/adsp_listener`
-- 12/12. If System 7's `.DSP` behaves differently and an assertion fails for a reason in
the runtime, STOP and report DONE_WITH_CONCERNS with the logs (runtime edits are the
controller's ruling: goldens).

## Step 3 -- the standing gate

`CLARUS_SNOW_TESTS=1 make test T=mactest/snow/clarusc_bake` (~30 min; ends on the guest's
own trailer). Owed because `clarusc/bake.cla` changed twice this phase. Paste the result
lines. A failure here is a phase blocker: report it with the log tail, do not retry
blindly.

## Verification / commit

`sh -n tests/mactest/snow/adsp_listener.sh`; `make test T=runner/` (the harness's own
syntax sweep); `scripts/test-task.sh` (Snow scripts SKIP in T1 -- confirm the new one
SKIPs cleanly without the env). Commit on `appletalk-t13`:
`test(snow): System 7 ADSP listener proof; clarusc_bake gate re-run` (+ a separate
commit if `lib_snow.sh` changed). Emulator discipline as in Task 13a's brief; never
leave Snow running.
