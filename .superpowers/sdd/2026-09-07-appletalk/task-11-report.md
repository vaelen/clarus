# Task 11 (scoped) report: `run_mac_pair`, `adsp_68k.sh`, `examples/atalkchat.cla`

Worktree `/Users/andrew/repos/clarus-wt/t11`, branch `appletalk-t11`,
commit **1a9ce1a** (on top of f4b6546).

Scope as bound by the controller: `run_mac_pair`, the `atalkchat` example
plus its two events files, and `tests/mactest/adsp_68k.sh`. The `AdspLeak`
suite case and the toolbox 39 -> 40 count bump were explicitly moved to
Task 13 and are NOT in this commit.

## What was implemented

### `run_mac_pair BIN1 BIN2 SECS` (`tests/lib_mac.sh`)

Boots BIN1 on `macplus/` (the `~/.LaunchAPPL.cfg` default) and, 5 s later,
BIN2 on `macplus2/` with LaunchAPPL's per-invocation overrides and no
second config file (spec 8.4):

```
LaunchAPPL -e minivmac --minivmac-dir $ROOT/macplus2 --minivmac-path ./MacPlus2.app \
    --system-image ./disk1.dsk --autoquit-image ./autoquit-1.1.1.dsk BIN2
```

- Each boot runs from its OWN cwd (`$WORK/launchA`, `$WORK/launchB`),
  because LaunchAPPL makes its temp dir -- and the copy of the emulator
  app it actually executes -- in cwd.
- Both boots are backgrounded under `$TOOLS/timeout SECS` and `wait`ed
  individually (`$_rcA`/`$_rcB`).
- On ANY nonzero rc from either (124 = timeout included) it sweeps up
  **both** cwds with `pkill -f "$WORK/launchA"` / `"$WORK/launchB"` and
  `die`s with both stderr heads. `run_mac`'s blanket
  `pkill -f minivmac.app` is deliberately not reused, per the brief: it
  would kill the other half of the pair and any concurrent session's
  emulator (Task 10 was running boots throughout this task), and it does
  not even match the second instance, whose app copy is `MacPlus2.app`.
- Captures split via the existing `capture_split` into
  `$WORK/cap1.{out,log}` / `$WORK/cap2.{out,log}` with `MAC_EXIT1` /
  `MAC_EXIT2`. `capture_split` writes the un-numbered `cap.*` names, so
  each split is renamed before the next overwrites it -- no duplication
  of the awk trailer parser.

### `examples/atalkchat.cla`

One program, either end of an ADSP conversation, role chosen by the
button the events script clicks (spec 8.5).

- **Serve**: `lsn.register("Chat-<n>", "ClarusChat")`, logs
  `serving <name>`; on `accepted` stores the connection in the program's
  single `connection` global and logs `accepted`; echoes every
  `received` chunk back with a `'>'` prepended; logs `closed` and quits
  when the peer closes.
- **Connect**: `brs.find("ClarusChat")`; on `found` logs
  `found <name> <net.node.socket>` and opens
  `appletalk name + ":" + chatType` (the string/NBP form the brief asks
  for, not `open(addr)`); on `opened` sends a 0..255 byte sweep; verifies
  each echo byte for byte (`echo ok` / `echo bad`); sends `"hello"` after
  the sweep's echo; closes after `">hello"` arrives, then quits a few
  beats later so the close reaches the server.
- Per-run NBP suffix from `now() mod 10000` (no Toolbox needed for the
  suffix). The client takes the FIRST `ClarusChat` entity NBP hands it --
  it cannot know the server's suffix -- and logs which name it picked, so
  a foreign server (Andrew's own session) is visible in the test log
  rather than silently substituted.
- `brs.done` with no match retries the lookup up to 8 times (each retry
  is a full NBP lookup, so it is self-paced) before logging
  `no server found` and quitting -- covers the server not having finished
  registering when the client's first lookup goes out.

Two deliberate deviations from the brief's wording, both documented in
the file header:

1. **Lock-step, not "sweep and hello on `opened`".** The brief's own
   assertions require the server to see `received 256` and `received 5`
   as separate lines. Sending both up front lets ADSP coalesce them into
   one 261-byte delivery on a slow pump pass -- legal stream behavior
   that would make those lengths unassertable. The client therefore sends
   `"hello"` only after the sweep's echo has arrived.
2. **A `Delay` in the beat handler**, via `include "toolbox/osutils.cla"`.
   A scripted boot's ticks are VIRTUAL (`uiscript.cla`'s
   `rtUiVirtualTicks` -- the real clock is never consulted in scripted
   mode, and each script line does exactly one `UiConnPump`). Without it
   a 400-line events script runs out in well under a second, long before
   the peer has booted, and the program quits with nothing to show.
   `every 4 ticks` + `Delay(10)` turns each `tick 4` line into ~1/6 s of
   real time, so a 400-line script is ~66 s of overlap between the two
   boots; the app's own watchdog fires at 380 beats so a stall produces a
   log line rather than a silent script exhaustion. In a real interactive
   build this costs only that much latency on a beat the app spends
   waiting for the network anyway.

### `testdata/ui/atalkchat_{server,client}.events`

`click 156 64` / `click 246 64` (Serve / Connect) then 400 `tick 4` lines
each. Coordinates derived the same way `testsuite/toolbox/gui.cla`
derives its own: content top-left = `((512 - width) / 2, 44)` = `(106,44)`
for `size: 300, 160`, buttons default 80x20 at local `(10,10)` and
`(100,10)`. **Both coordinates were confirmed correct on hardware** --
each boot's log shows its role handler ran.

### `tests/mactest/adsp_68k.sh`

`# timeout: 25m`, `require_env CLARUS_MAC_TESTS`, no
skip-without-multicast (both peers are emulators this script boots
itself). Two `emit68k` builds of the same source with the two events
files, `run_mac_pair ... 420`, then the committed GREEN contract:

- both exits 0;
- server log: `accepted`, `received 256`, `received 5`, `closed`;
- client log: `opened`, `received 257`, `received 6`;
- plus `echo ok` present and `echo bad` absent -- the byte-for-byte half
  of spec 8.2's "byte-exact echo both ways" (the length lines alone would
  pass on a stream that dropped or reordered bytes).

Assertions use `grep -qxF` (whole-line) rather than `grep -qF`, so
`received 5` cannot be satisfied by a `received 57`. Both captured logs
are echoed into the test's own log, prefixed `  server: ` / `  client: `,
so a failure is readable and no guest line can ever look like a runner
result line.

## Which assertions actually ran, and which are pending

**Executed and PASSING, on real hardware:**

- `run_mac_pair` itself, proved by a temporary `tests/mactest/pairsmoke.sh`
  (deleted before commit) that pair-booted `testdata/cg68k/tickprobe.cla`
  twice: `PASS exit1 / PASS exit2 / PASS cap1 / PASS cap2` -- two
  simultaneous Mini vMac instances, both captures split, both exits 0,
  no cross-kill.
- `adsp_68k.sh`'s `server_exit`, `client_exit`, `client_echo_bytes`
  (no `echo bad`) -- these pass today, twice, on two full pair runs.

**Blocked by the boot disk, NOT by this code** (the LaunchAPPL harness's
stripped boot disk drops the `AppleTalk` system file, so
`OpenDriver(".DSP")` is -43; Andrew's LaunchAPPL patch is in flight):
`server_accepted`, `server_sweep`, `server_hello`, `server_closed`,
`client_opened`, `client_sweep_echo`, `client_hello_echo`,
`client_echo_exact`. Task 13 runs the script for real after the patch.

**The temporary-only evidence** (asserted here in the report, NOT in the
committed script, per the brief) is that both halves reach the expected
`-1273` path cleanly and exit 0. Verbatim, from the second full pair run
(`CLARUS_MAC_TESTS=1 sh tests/mactest/adsp_68k.sh`, 40 s wall):

```
  server: serving Chat-1668
  server: failed -1273 streams not available on this lane
  client: connecting
  client: no server found
PASS server_exit
PASS client_exit
...
PASS client_echo_bytes
```

That log is a real proof of everything below ADSP: the server's `Serve`
click fired, `lsn.register` lowered and reached the native waist, the
waist correctly answered "`.DSP` absent"; the client's `Connect` click
fired, `brs.find` issued eight real NBP lookups (the retry path) and
`done` fired each time with no match; both `--events` scripts drove a
real boot to a clean `quit` with a well-formed `##CLARUS-EXIT##` /
`##CLARUS-LOG##` trailer that `capture_split` parsed.

The FIRST pair run exposed and fixed one real bug: `now()` on a Mac whose
clock was never set reads back NEGATIVE, and `mod` is a remainder, so the
server registered `Chat--8422`. Now folded back into 0..9999
(`((now() mod 10000) + 10000) mod 10000`); the rerun registered
`Chat-1668`.

## Gate

- `make -j t1` in the worktree: **103 passed, 32 skipped, 0 failed**
  (exit 0). No `hostrt/atalk` flake -- it passed under `-j`, so no
  solo rerun was needed.
- `tests/runner/syntax.sh`: `PASS parsed 153 files`.
- No perfgate, no smoke (per the brief).
- Non-ASCII audit: all four new/changed files are pure ASCII
  (`LC_ALL=C grep -c '[^ -~\t]'` = 0 on each).

Timing datum for Task 13: a full pair run took **40 s** wall today, but
both halves quit early on the `-1273` failure. A boot to app launch is
~15-20 s, so the 5 s stagger plus the example's ~66 s of scripted pacing
is ample margin for the green path.

## Files changed

- `tests/lib_mac.sh` (+`run_mac_pair`, `MAC_EXIT1`/`MAC_EXIT2`)
- `tests/mactest/adsp_68k.sh` (new)
- `examples/atalkchat.cla` (new)
- `testdata/ui/atalkchat_server.events`, `testdata/ui/atalkchat_client.events` (new)

## Concerns for the reviewer / Task 13

1. **The `Delay` pacing is the load-bearing design choice.** If Task 13's
   green run shows the exchange completing far faster than expected, the
   400-line scripts are simply longer than needed (they cost nothing but
   constant-pool bytes). If it shows the exchange starved for pump passes,
   the knob is `Delay(10)` down and the line count up -- 400 lines is
   ~66 s at 1/6 s per line.
2. **First-found, not name-matched.** The client connects to the first
   `ClarusChat` entity NBP returns. If Andrew has a chat server of his own
   up during the gate, the client can attach to it and the echo
   assertions will fail on a peer that does not echo. The client's
   `found <name> <addr>` line is in the test log precisely so this is
   diagnosable; there is no way for the client to learn the server boot's
   own suffix from outside.
3. **Fragmentation risk on the 256/257-byte deliveries.** ADSP's max
   packet is well above 257 bytes and the pump drains all of
   `recvQPending` per pass, so a split is unlikely, but it is not
   impossible. If Task 13 sees `received 128` + `received 128`, the fix is
   to accumulate in the app rather than to weaken the assertion.
4. **`AdspLeak` and the toolbox 39 -> 40 count bump are not done** --
   moved to Task 13 by the controller. `CLAUDE.md`, the runner's
   `nTbCases`, and the three `tests/mactest/toolbox_*.sh` literals are all
   untouched by this commit.
5. `run_mac_pair`'s 5 s stagger is hardcoded (the brief specified it). If
   a future pair test wants a different one it becomes a fourth
   parameter; nothing needs it today.

---

# Fix round 1 (commit 38cfa5f)

Three Important findings plus six minors from the Task 11 review.

## Important

1. **`tests/lib_mac.sh` comment was factually inverted.** It claimed
   `pkill -f minivmac.app` "does not even match the second instance,
   whose app copy is named MacPlus2.app". Wrong: `MiniVMac.cc` copies
   whatever bundle it is handed to a fixed `minivmac.app` name (Task 1 P4
   (c)), so that one pattern matches BOTH halves of the pair and every
   unrelated session's emulator -- which is the real, and sufficient,
   reason not to reuse it. The false claim is deleted; the true reason
   is kept and now cites P4 (c).

2. **`Delay` duty cycle was misstated and the beat was mis-tuned.** With
   `every 4 ticks` (1/15 s period) against a 10-tick blocking `Delay`,
   the handler was longer than its own period: 100% duty, beats dropping
   from 15/s to ~6/s, WaitNextEvent starved outright -- and the comment
   called it "only that much latency". Per the controller's ruling no
   scripted-lane `delay` verb was added (a `uiscript.cla` change would
   rebless every UI golden). Instead the period is now `every 12 ticks`
   against the same `Delay(10)`: the block is 10 of every 12 ticks, ~83%
   duty, ~5 free ticks a second, a click waiting up to ~167 ms. The
   comment now states that duty cycle honestly and says plainly that a
   real app would not need this -- it exists only because the scripted
   lane never advances the real clock. The events files' `tick 4` lines
   became `tick 12`, so the same 400 lines still cover the same ~66 s of
   wall clock.

3. **First-found peer was a live false-failure vector.** The client can
   only search by TYPE, so the example's per-run NAME suffix did not
   protect it from a concurrent `ClarusChat` on the group.
   `adsp_68k.sh` now stamps a PID-per-run type into a `$WORK` copy of the
   example (`sed "s/ClarusChat/ClarusChat$$/g"`) and emits both binaries
   from that copy; the committed example keeps the plain `"ClarusChat"`
   so it stays a readable demo. Verified: the stamped copy carries
   `var chatType: string = "ClarusChat74537"` and compiles (the
   `include "toolbox/osutils.cla"` still resolves, via the compiler's own
   `toolbox/` fallback, from a source file outside the tree).

## Minors, all folded in

- `server_registered`: `grep -q '^serving Chat-'` on the server log. It
  also happens to be the only proof the scripted click hit the right
  widget, which is why the comment says so.
- `[ -d "$ROOT/macplus2" ] || skip "macplus2 not present"`.
- `// result ignored; Delay is called for its blocking` on the binding.
- `roleIdle`/`roleServer`/`roleClient` are now `const`.
- The watchdog comment's `selfserve.cla` is now
  `testdata/atalk/selfserve.cla`.
- `run_mac_pair`'s `die` now prints `tail -5` of each guest capture
  (`cap1.raw`/`cap2.raw`, newline-folded) alongside LaunchAPPL's stderr
  head -- on a timeout the guest's partial stdout is the only evidence of
  how far the boot actually got.

## Verification

`CLARUS_MAC_TESTS=1 make -j1 test T=mactest/adsp_68k` -- one real pair
boot, 40 s wall, `FAIL(exit 1) mactest/adsp_68k 40s` as expected:

```
  server: serving Chat-2436
  server: failed -1273 streams not available on this lane
  client: connecting
  client: no server found
PASS server_exit
PASS client_exit
PASS server_registered
FAIL server_accepted / server_sweep / server_hello / server_closed
FAIL client_opened / client_sweep_echo / client_hello_echo / client_echo_exact
PASS client_echo_bytes
```

The pair still boots with the stamped per-run type on both halves, four
assertions pass, and the only failures remain the eight that need `.DSP`
on the boot disk. `make test T=runner/syntax`: `PASS parsed 153 files`.
All changed files remain pure ASCII.
