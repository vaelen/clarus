# Task 13a report -- `mactest/adsp_68k` green

Worktree `/Users/andrew/repos/clarus-wt/t13`, branch `appletalk-t13`, cut from
`appletalk` at 5aab2a7.

**Result: 12/12 PASS, one bug, one line, zero runtime changes.** Every native ADSP
body written blind in Task 9 (`dspInit`, `dspOpen(ocRequest)`, `dspCLInit`/
`dspCLListen`/`dspOpen(ocAccept)`, `dspStatus`/`dspRead`/`dspWrite`, `dspClose`/
`dspRemove`) is correct as written against the ROM's `.DSP`. `runtime/clarus/
atalk_68k.cla`, `atalk.cla` and `conn.cla` are untouched, so no goldens moved.

## The bug

**Symptom.** First real run (brief): client logs `connecting` / `found
Chat-5627:ClarusChat2025 0.91.253` / `failed -1025 could not open connection`;
server never logs `accepted` and is killed by its own watchdog at 380 beats.

**Evidence.** -1025 is `nbpNoConfirm`/`rtAtErrNoConfirm` ("no such name",
`runtime/clarus/atalk.cla:69`), not any ADSP error -- so the failure is the
open-by-name path's own NBP resolve, before any ADSP packet. Reading the two
sides of that resolve:

- `rtAtDevLookupName` (`runtime/clarus/atalk_68k.cla:576-589`) returns
  `obj + ":" + typ` -- documented in its own comment as "the same spelling the
  host lane's `AtalkHLookupName` produces". The client's own log line proves it:
  the `name` handed to `brs.found` was `Chat-5627:ClarusChat2025`, type included.
- `examples/atalkchat.cla`'s `on brs.found` then called
  `chat.open(appletalk name + ":" + chatType)`, i.e. the spec string
  `"Chat-5627:ClarusChat2025:ClarusChat2025"`.
- `rtAdspOpenName` (`atalk.cla:629-651`) splits at the FIRST colon (correct --
  NBP names cannot contain `:`), so it looked up object `Chat-5627`, type
  `ClarusChat2025:ClarusChat2025`.
- Nothing is registered under that type, so the lookup completed with 0 tuples
  and `rtAdspPoll`'s `rtAtDevLookupCount(slot + 2) == 0` arm returned
  `rtAtErrNoConfirm`, which `conn.cla`'s pump staged as
  `failed -1025 could not open connection`. The server's `dspCLListen` never
  saw a request, so `accepted` never fired and the watchdog quit it -- exactly
  the 8 observed failures, all downstream of this one.

**Root cause.** The example doubled the NBP type. `found`'s `name` is already
NBP's `"Object:Type"` spelling on both lanes (spec 4.3 gives `found(name, addr)`
with no separate type parameter), and that IS the `"Name:Type"` form spec 4.1's
`open(appletalk ...)` parses. IM citation is not needed for the ADSP layer here:
the bug is one level above it, in the NBP name the program dialed. (The NBP
side itself matches IM II ch.10 / IM VI ch.29's `LookupName`: object, type and
zone are three separate Pascal strings in the packed entity, so a type
containing a colon can never match a registered name.)

**Fix.** `examples/atalkchat.cla:176` -- `chat.open(appletalk name)`, with a
comment saying why. Nothing else changed; no assertion in
`tests/mactest/adsp_68k.sh` was touched, no timing was tuned, and the example's
observable log shape (`connecting` / `found ...` / `opened` / `received 257` /
`echo ok` / `received 6` / `echo ok` / `closing`) is exactly what the test
already asserted.

## Boots run

Four emulator sessions total, all through the harness (no hand-built probe
program was needed -- the first boot after the fix was already green, so
trap-level instrumentation would have been work spent on a solved problem):

1. `mactest/adsp_68k` after the fix -- 12/12 (evidence boot; the pair is two
   Mini vMac boots).
2. `mactest/adsp_68k` again -- 12/12, to rule out a flake on a network test
   whose two peers race on a stagger.
3. `mactest/atalk_68k` + `mactest/atalk_selfserve` + `mactest/toolbox_68k`.
4. `make smoke` (inside `scripts/test-task.sh --smoke`).

No emulator was left running (`pgrep -fl "minivmac|MacPlus"` empty at the end);
nothing was ever killed by app name.

### Final `adsp_68k` logs, verbatim (run 2)

```
  server: serving Chat-6269
  server: accepted
  server: received 256
  server: received 5
  server: closed
  client: connecting
  client: found Chat-6269:ClarusChat10748 0.27.253
  client: opened
  client: received 257
  client: echo ok
  client: received 6
  client: echo ok
  client: closing
```

Run 1 was identical modulo the per-run suffixes
(`Chat-6231` / `ClarusChat10354` / `0.20.253`).

## Verification

```
$ CLARUS_MAC_TESTS=1 make -j1 test T=mactest/adsp_68k
PASS mactest/adsp_68k 20s
tests: 1 passed, 0 skipped, 0 failed
    (PASS server_exit client_exit server_registered server_accepted
     server_sweep server_hello server_closed client_opened
     client_sweep_echo client_hello_echo client_echo_exact
     client_echo_bytes -- 12/12)

$ CLARUS_MAC_TESTS=1 make -j1 test T=mactest/adsp_68k        # repeat
PASS mactest/adsp_68k 20s
tests: 1 passed, 0 skipped, 0 failed

$ CLARUS_MAC_TESTS=1 make -j1 test T='mactest/atalk_68k mactest/atalk_selfserve mactest/toolbox_68k'
PASS mactest/atalk_68k 217s
PASS mactest/atalk_selfserve 18s
PASS mactest/toolbox_68k 286s
tests: 3 passed, 0 skipped, 0 failed          (toolbox_68k = 39/39)

$ scripts/test-task.sh --smoke
tests: 104 passed, 33 skipped, 0 failed       (t1)
PASS perfgate/tripwire 0s
PASS mactest/smoke_bounce 7s
PASS mactest/tick 4s
test-task.sh: PASS in 140s (smoke=1)
```

T1 includes `tests/atalk/examples.sh`, which compiles the edited example on both
lanes, and the whole `atalk/` LToUDP group -- all green.

## Files changed / goldens

- `examples/atalkchat.cla` -- one statement plus a five-line comment.
- **No goldens reblessed, and none needed to be.** The edit is in an example, not
  in a 68k-spliced runtime module: `testdata/cg68k/atalk_{server,client}.s` and
  the four `testdata/emitui/atalk_*.c.golden` files are generated from
  `runtime/clarus/atalk*.cla` fixtures, none of which changed. The full T1 run
  above (which contains every golden check) is the proof.
- No new globals, no new waist functions, no frozen name touched.

## Self-review

- *Completeness*: all twelve assertions pass, twice; `atalk_68k`,
  `atalk_selfserve`, `toolbox_68k` (39/39) and `test-task.sh --smoke` all pass.
- *Root cause, not symptom*: the fix is the wrong NBP name the program dialed,
  named and explained, not a retry/timeout/tolerance patch. I checked the sibling
  `found` handlers for the same mistake -- `examples/atalkclock.cla` (adds `name`
  to a list, then calls by the stored string), `examples/atalkfind.cla` and
  `testdata/atalk/selfserve.cla` all use `name` as-is. `atalkchat` was the only
  one that re-appended the type.
- *Discipline*: no test weakening, no timing tuning, no unrelated edits, no
  subagents dispatched.

## Concerns / notes for later tasks

1. **The brief's commit-subject style was `fix(native): ...`**; the bug turned
   out not to be in the native runtime at all, so the commit is
   `fix(examples): ...`. Flagging the deviation rather than mislabelling it.
2. **`brs.found`'s `name` carrying the type is a real ergonomic edge.** It is
   what the spec and both lanes do, and `open(appletalk name)` is the natural
   spelling -- but this example's author got it wrong on the first try, which
   suggests `docs/clarus-language-reference.md`'s `serviceBrowser.found` entry
   would earn its keep by saying, in one line, "`name` is already
   `Object:Type`; pass it straight to `open(appletalk ...)`". Not done here
   (out of scope, and a doc edit would want the controller's call).
3. **Nothing the ROM's `.DSP` does differs from IM VI as transcribed.** I
   re-derived every `DSPParamBlock`/`TRCCB` offset in `toolbox/appletalk.cla`
   from `toolchain/universal/CIncludes/ADSP.h` before booting (`ccbRefNum`@32,
   `TRinitParams` 34..59, `TRopenParams` 34..67 with `ocMode`@64, `TRioParams`
   34..43, `TRstatusParams` 34..45, `TRcloseParams.abort`@34, `TRCCB.state`@6 /
   `localSocket`@9, `ccbSize` 242, `attnBufSize` 570) -- all correct, and the
   green run exercised each of them. Specifically confirmed on hardware, for
   the AdspLeak and Snow System 7 listener tasks:
   - `dspCLInit` with `localSocket = 0` assigns a dynamic DDP socket and leaves
     it in `TRCCB.localSocket` (253 in both runs) -- `rtLsnDevSocket`'s
     `peekb` of it is what NBP advertises, and the client resolved it.
   - `dspOpen(ocAccept)` issued SYNCHRONOUSLY on a second connection end, with
     `remoteCID`/`remoteAddress`/`sendSeq`/`sendWindow`/`attnSendSeq` copied out
     of the completed `dspCLListen` block, completes without the caller ever
     touching `recvSeq` -- no extra field is required.
   - `ocInterval 6` / `ocMaximum 3` (~3 s) is comfortably enough for a peer
     whose pump only runs every 12 ticks and blocks 10 of them in `Delay`.
   - The peer's orderly `dspClose` drives the local `TRCCB.state` to
     `>= sClosing`, so `rtAdspDevGone`'s state read is sufficient -- the
     `ccbUserFlags` `eClosed` bit was never needed.
   - `rtAt68DspAux` (rule 2's separate block for `dspClose`/`dspRemove`/
     `dspCLDeny`/`dspCLRemove`) held up: both ends tore down cleanly and both
     boots exited 0.
4. **The pair is not flaky over two runs**, but two runs is two runs. Both peers
   are emulators this script boots itself, so the only shared resource is the
   host's LocalTalk-over-UDP group; the per-run PID-stamped NBP type
   (`tests/mactest/adsp_68k.sh`'s own `sed`) is what keeps a concurrent session
   out of it.
