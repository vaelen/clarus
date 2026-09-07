# Task 13a brief -- `mactest/adsp_68k` green: the first real exercise of the native ADSP path

Plan: `docs/superpowers/plans/2026-09-07-appletalk.md` Task 13 (first item of the
scoped-down list; see `task-13-brief.md` for the whole task and the ledger's Task 11
ruling that moved this item here). Spec: `docs/superpowers/specs/2026-09-06-appletalk-design.md`
sections 4.1/4.2 (ADSP as `connection`, `accepted`), 8.2 (the two-Mac proof).

## What changed today (2026-09-07 10:48 JST)

The out-of-repo blocker is gone: `toolchain/bin/LaunchAPPL` was rebuilt from a
Retro68 `MiniVMac.cc` that now copies the `AppleTalk` system file onto the stripped
boot disk (`CopySystemFile("AppleTalk", false)`; the previous binary is
`toolchain/bin/LaunchAPPL.orig`). `.DSP` and `.XPP` now open on every harness boot.

`CLARUS_MAC_TESTS=1 make -j1 test T=mactest/adsp_68k` therefore no longer SKIPs. First
real run (appletalk 5aab2a7, unchanged tree), 3 PASS / 8 FAIL:

```
server log:  serving Chat-5627 | watchdog role 1
client log:  connecting | found Chat-5627:ClarusChat2025 0.91.253 | failed -1025 could not open connection
PASS server_exit client_exit server_registered client_echo_bytes(vacuous)
FAIL server_accepted server_sweep server_hello server_closed
FAIL client_opened client_sweep_echo client_hello_echo client_echo_exact
```

Facts to start from (verify them, do not trust them):
- `.DSP` opened: the listener registered (`serving Chat-5627`, no `failed -1273`).
- The client's *browse* (NBP lookup by type) found the server at `0.91.253`.
- The client's `open(appletalk "Chat-5627:ClarusChat2025")` failed with **-1025**.
  In this tree -1025 is `nbpNoConfirm` / `rtAtErrNoConfirm` ("no such name",
  `runtime/clarus/atalk.cla:69`), NOT ADSP's `errOpening` (-1277,
  `toolbox/appletalk.cla:258`). So the first suspect is the open-by-name path's own
  NBP resolve (`rtAdspOpenName` -> native lookup/confirm in `atalk_68k.cla`), not the
  `dspOpen(ocRequest)` itself -- but the ADSP open, the listener's `dspCLListen`/
  `ocAccept`, `read`/`write`/`close` have ALL never run on hardware either. Expect
  more than one bug. Task 9's report (`task-9-report.md`, "ADSP"/"Listener" bullets)
  and the review of it list what was verified statically only.
- The server never logged `accepted`; its watchdog quit it (`watchdog role 1`).

## Your job

Make `CLARUS_MAC_TESTS=1 make -j1 test T=mactest/adsp_68k` PASS all twelve assertions
(`tests/mactest/adsp_68k.sh`; the example is `examples/atalkchat.cla`, the scripts
`testdata/ui/atalkchat_{server,client}.events`). Debug with `superpowers:systematic-debugging`:
reproduce, instrument, find the root cause, fix, re-run. Trap-level probe programs in
the style of Task 1 (`task-1-report.md`, P1/P2) booted one at a time via
`toolchain/bin/LaunchAPPL -e minivmac X.bin` (build with `scripts/build-68k.sh`) are a
legitimate tool; Inside Macintosh VI's ADSP chapter is at `inside-macintosh-v2/`
(read PDFs with the Read tool's `pages` parameter).

## Constraints (binding)

- Fix `runtime/clarus/atalk_68k.cla` BODIES (and, if the bug is transport-neutral,
  `runtime/clarus/atalk.cla` / `conn.cla` bodies). The module globals tables and every
  waist function NAME are frozen. A new global in a 68k-spliced module = another
  golden rebless; if unavoidable, say so in the report and do the rebless
  (`CLARUS_CG68K_BLESS=1` for `testdata/cg68k`, plus the emitui goldens per
  CLAUDE.md's AppleTalk paragraph: any `atalk.cla` edit moves
  `testdata/cg68k/atalk_{server,client}.s` and all four
  `testdata/emitui/atalk_*.c.golden`). Bodies-only edits to `atalk_68k.cla` move the
  cg68k goldens too -- rebless those and inspect the diff is confined to your change.
- Do NOT change `tests/mactest/adsp_68k.sh`'s assertions or `examples/atalkchat.cla`'s
  observable behaviour to make it pass. Timing (the example's `every 12 ticks` beat and
  `Delay(10)`) may be tuned only if you show the root cause is timing, and say so.
- Emulator discipline: you are the only emulator owner right now. One boot (or one
  `run_mac_pair`) at a time. NEVER `pkill -f minivmac.app` or `pkill -f MacPlus.app`
  -- kill by the launch cwd only (see `run_mac_pair` in `tests/lib_mac.sh`). Andrew
  may start his own Snow session; leave `Snow` processes alone.
- Toolbox calls go through `toolbox/*.cla` externs (CLAUDE.md).
- The host lane has no ADSP (FUTURE); nothing to do there.

## Verification before you report

1. `CLARUS_MAC_TESTS=1 make -j1 test T=mactest/adsp_68k` -- 12/12 PASS, paste the
   server/client logs into the report.
2. `CLARUS_MAC_TESTS=1 make -j1 test T='mactest/atalk_68k mactest/atalk_selfserve mactest/toolbox_68k'`
   -- the other native AppleTalk proofs (toolbox_68k takes ~7-8 min; 39/39).
3. `scripts/test-task.sh --smoke` green (T1 + perfgate + the two smoke boots).

## Commit

On branch `appletalk-t13` in `/Users/andrew/repos/clarus-wt/t13`; one commit per
root-caused fix, subject style `fix(native): ...`, plus one for reblessed goldens if
any. Do not merge; the controller merges from the main checkout.
