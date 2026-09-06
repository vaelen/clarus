# Task 10 report — `mactest/atalk_68k.sh` + `examples/atalkclock.cla`

**Status: DONE.** Worktree `/Users/andrew/repos/clarus-wt/t10`, branch
`appletalk-t10`, commit `15147e3` (on top of `f4b6546`).

## What shipped

| File | What it is |
|---|---|
| `examples/atalkclock.cla` | the phase's native acceptance app (spec §8.5) |
| `testdata/atalk/clockdrive.cla` | the boot's `every 60 ticks` driver (see the deviation below) |
| `tests/mactest/atalk_68k.sh` | one Mini vMac boot + `atalkdrive`, `# timeout: 20m` |

### `examples/atalkclock.cla`

A window `Clock` (a `Zones` label, a `textview Peers` listing every
entity found, buttons `Find`/`Call`/`Quit`), a `service clock` served as
`("Clock-" + string(now() & 0xFFF), "ClarusClock")`, and a
`serviceBrowser browser`. Ops: `1` → `dateTimeStr(now())`, `2` → echo,
anything else → `-1`, dispatched through the reference's own guarded
`switch ClockOp(op)` idiom. `Call` walks the peer list and, for every
`"Name:Type"` that is not its own, does `clock.call(peer, 1, "", reply)`
and logs `remote <name> <reply>`. Zero Toolbox: `service`,
`serviceBrowser`, `address`, `now`, `dateTimeStr` are the whole surface.
It check-compiles standalone (`clarusc examples/atalkclock.cla`, exit 0).

### `tests/mactest/atalk_68k.sh`

Skips (77) without multicast (`atalk_skip_unless_multicast`), requires
`CLARUS_MAC_TESTS`, per-run names via `atalk_name` (`Host-T$$`). Flow:

1. `atalkdrive serve Host-T$$ ClarusClock 300 script` in the background
   (op `1` → code 0, file containing `HOSTTIME`); wait for its
   `serving node=` line, remember its node.
2. `emit68k` the example + the driver.
3. A background subshell (started BEFORE `run_mac`, which blocks) polls
   `atalkdrive lookup ClarusClock` every 2 s for up to 120 s, takes the
   `Clock-<digits>:ClarusClock` entry at a node that is neither 0 nor the
   host peer's, then `call`s it: op 2 with a 578-byte sweep (`cmp`
   byte-exact) and op 1 (exit 0, non-empty reply). It writes
   `discover|echo578|time  OK|FAIL …` lines to `$WORK/host.out`.
4. `run_mac … 420`, then assert `$WORK/host.out` and the capture's
   `##CLARUS-LOG##` half: exit 0, `serving Clock-`,
   `remote Host-T$$:ClarusClock HOSTTIME` (grep -F, exact), `done`, and
   no `clock failed`/`browse failed` line.

Nine subcases, all PASS.

## Deviations from the brief (both deliberate, both load-bearing)

1. **No `testdata/ui/atalkclock.events`; a composed
   `testdata/atalk/clockdrive.cla` instead.** Scripted mode
   (`--events`) replaces the real event loop with the script interpreter
   and a VIRTUAL tick counter — `runtime/clarus/uiscript.cla`'s
   `rtUiScriptTick`: *"real TickCount is never consulted in scripted
   mode"* — and `rtUiRunScripted` runs its lines back to back with only
   a passive pump between them. There is no verb that waits in real
   time, so a script cannot hold the app up for the ~60 s the brief's
   Find → wait → Call → wait → Quit needs, nor let an NBP lookup or an
   ATP round trip complete. `clockdrive.cla` is a tiny fixture composed
   onto the example (`emit68k examples/atalkclock.cla
   testdata/atalk/clockdrive.cla`) whose one `every 60 ticks` block
   fires `atClockFind()` at 5 s, `atClockCall()` at 25 s and `quit` at
   150 s in the REAL event loop. The example itself stays a clean
   acceptance app — no timers, no auto-quit, no test scaffolding.
2. **Name suffix from `now() & 0xFFF`, not `TickCount() mod 10000`.**
   `TickCount` would need a Toolbox extern in an app whose whole point
   is that it needs none; `now()` is a language builtin, and masking
   avoids the negative remainder a `mod` of a (negative) Mac datetime
   would produce. The suffix's only job is to be non-constant — NBP
   registration verifies uniqueness, and the host distinguishes the
   app's entry from `tests/atalk/serve.sh`'s concurrent host-side
   `Clock-T<pid>` by the all-digits suffix regex plus the node check.

## Concurrency hygiene

No blanket `pkill` anywhere: the script's EXIT/INT/TERM trap kills only
its own `atalkdrive serve` and host-driver pids. `run_mac`'s own expiry
path does blanket-pkill, so the budget is 420 s against a boot that runs
~170 s — it cannot trip. `tests/lib_atalk.sh` was not modified (no
collision with the t2 lock work).

## Verification

```
CLARUS_MAC_TESTS=1 make -j1 test T=mactest/atalk_68k
  PASS mactest/atalk_68k 176s     (9/9 subcases: peer_serving, exit,
  discover, echo_578, reply_time, serving, remote_call, done_line,
  no_failures)

make -j t1
  tests: 103 passed, 32 skipped, 0 failed
```

`hostrt/atalk` passed under `-j` on this run — no re-run needed.

**Task 9's `PSendResponse` reply path is now hardware-proved.** The host
reading the Mac's clock (op 1) and getting a byte-exact 578-byte echo
back (op 2) is the ROM-side ATP responder answering through the
runtime's waist; `remote Host-T$$:ClarusClock HOSTTIME` in the app's own
log is the ROM-side ATP requester. Both directions worked on the first
boot.

## Concerns

- The Mac→host direction resolves the peer by NAME (`call("Name:Type",
  …)`), which costs one NBP lookup per peer. With a stray third
  `ClarusClock` entity on the group the app would call it too and log an
  extra `remote …` line — harmless (the assertion is `grep -F` for the
  one line that matters), but the 150 s app lifetime is the only budget
  for it.
- `discover` polls for up to 120 s and the app lives 150 s; on a much
  slower machine the two calls could run out of runway. The margins are
  generous today (discovery landed well inside the window) but they are
  wall-clock margins, not handshakes.

---

# Fix round 1 — commit `036505c`

All four **Important** items and all three **Minors** fixed. One extra
change (`at_call`) was forced by a real flake the re-boot exposed; it is
described below.

## Important

1. **`$WORK` leak (`atalk_68k.sh:53`).** The script's own
   `trap cleanup EXIT INT TERM` replaces `lib.sh`'s
   `trap 'rm -rf "$WORK"' EXIT`, so every run left the LaunchAPPL boot-disk
   build, the capture and the `.bin` behind. `cleanup()` now ends with
   `rm -rf "$WORK"`; the own-pids-only kills are unchanged and still first.
2. **`done` was unfalsifiable.** `want_line done_line "done"` (`grep -qF`)
   also matched the example's `browse done N`, which fires seconds after
   launch. Replaced with an anchored `grep -qx "done"` check, and
   `clockdrive.cla`'s header now says the line is matched with `grep -x`
   so nobody reintroduces a substring match.
3. **New `same_entity` subcase.** Discovery accepted any
   `Clock-<digits>:ClarusClock` at a non-host node, so a foreign clock on
   the shared group could have satisfied `discover`/`echo_578`/`reply_time`
   with this boot's app never touched. After `run_mac` the script now
   pulls the entity out of the host half's `discover OK <ent> node=N` line
   and asserts `grep -qx "serving $HOSTENT"` against the app's own log.
4. **`reply[0, reply.length]` clamped (`atalkclock.cla`).** A service reply
   may be 4624 bytes and a `string` holds 255, so the documented
   call-a-peer idiom raised `slice out of range` the first time a peer
   answered with something long. Now clamps to 60 bytes with a comment
   saying exactly that.

## Minors

- (a) The discovery deadline is 170 s (was 120 s) — LaunchAPPL builds its
  boot disk before the app ever runs, out of the same window — and the
  driver's quit moved 150 → 200 beats so the calls keep runway behind it.
  The `discover OK` line now carries the elapsed seconds.
- (b) The header no longer claims "NBP + ATP only, no `zones()`": the
  example *does* call `browser.zones()` for its window label, and the
  comment now says it degrades to `["*"]` without `.XPP` (the same
  `noBridgeErr` path `atalk_selfserve.sh` pins as `zones 1 *`). What is
  actually NBP+ATP-only is every *assertion*.
- (c) `atClockRepaint` returns early when the front window is `nil`
  instead of rebuilding `shown` for nobody.

## One unplanned change: `at_call`

The first re-boot after the fixes failed with

```
PASS discover
FAIL echo_578: echo578 FAIL exit 1 (not found: Clock-2974:ClarusClock|)
FAIL reply_time: time FAIL exit 1, 0 bytes (not found: Clock-2974:ClarusClock|)
PASS same_entity
```

— `same_entity` passing proves the discovered name really was this boot's
app, and `atalkdrive lookup` had just seen it, yet the tool's own NBP
lookup inside `call` came back empty seconds later. That is a lost lookup
on a shared, lossy multicast group (Task 11's concurrent two-boot ADSP
test shares it, and the LToUDP-under-parallelism fix is Task 2's), not a
protocol verdict. `at_call OP IN OUT ERR` retries the call up to three
times **only** when stderr says `not found:`; a real failure (no answer,
a nonzero code) still returns on the first try. Worth flagging to the
controller as corroborating evidence for the t2 host-stack work.

## Boot

```
CLARUS_MAC_TESTS=1 make -j1 test T=mactest/atalk_68k
  PASS mactest/atalk_68k 216s

  PASS peer_serving
  PASS exit
  PASS discover
  PASS echo_578
  PASS reply_time
  PASS serving
  PASS remote_call
  PASS done_line
  PASS same_entity
  PASS no_failures

make -j t1
  tests: 103 passed, 32 skipped, 0 failed   (hostrt/atalk green under -j)
```
