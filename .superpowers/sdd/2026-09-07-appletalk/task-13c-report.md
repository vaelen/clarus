# Task 13c report — Snow / System 7: interop probe, `mactest/snow/adsp_listener`, the `clarusc_bake` gate

Worktree `/Users/andrew/repos/clarus-wt/t13`, branch `appletalk-t13`, base
`8b4e3a7`. Seven Snow boots of the workspace (plus nine throwaway
launches with no workspace), six Mini vMac boots.

**Result: `mactest/snow/adsp_listener` is 12/12, three times; the `clarusc_bake`
gate is green; P5 is answered in both directions and appended to
`task-1-report.md`. One finding the phase record must carry: Snow's
LocalTalk-over-UDP bridge is OFF by default and cannot be enabled from
the command line, the workspace file, PRAM or Snow's own settings file —
only by clicking three items in the menu bar egui draws inside the Snow
window. `tests/lib_snow.sh` gained `snow_localtalk_b` to do exactly that,
verified against Snow's own log line and fatal if it ever stops working.**

---

## 1. The network question: does the `Clarus.snoww` clone have LocalTalk alive?

**The GUEST does. The HOST-side bridge does not, and no configuration
turns it on.**

Boot 1 (the P5 probe, no bridge) was unambiguous. The Snow guest's own
AppleTalk was completely healthy — `Gestalt('atlk')` err 0 value **58**,
`svc.serve` registered a verified NBP name with no `svcfail`,
`lsn.register` opened `.DSP` and got an ADSP socket with no `lsnfail`,
`brs.zones` answered `["*"]`, and the node came up as 1 — while nine
`atalkdrive lookup` sweeps from the host across the app's 45 s of life
returned **zero** tuples, and the Mini vMac peer found nothing either.
The guest was talking to nobody.

Everything I ruled out, each measured rather than assumed:

| candidate | what I found |
|---|---|
| `--serial-bridge-b localtalk` / `ltoudp` / `udp` | `WARN snowemu::app Invalid serial bridge mode: '<v>'. Use 'pty' or 'tcp:PORT'`, then silently ignored. There is no localtalk CLI mode in v1.5.0-b81dbcc. |
| a `snow_disk` variant cloning `MacII.snoww` + `macii.pram` (the brief's first suggestion) | would change nothing. The two workspaces are JSON-identical apart from `pram_path`, `shared_dir` and `scsi_targets[3]` (`Ethernet`, the DaynaPORT for MacTCP). Neither names a serial bridge. |
| PRAM | `clarus.pram` and `macii.pram` differ in exactly two bytes: `0x12` (`SPATalkB`, the AppleTalk node hint — `0x01` vs `0x16`) and `0xBB`. **`SPConfig`@0x13 is `0x21` in both** — port B is already `useATalk`. PRAM only chooses which guest port AppleTalk uses; it cannot reach the host side of the wire. |
| saving a workspace with the bridge on | the `Workspace` struct's serde field list in the Snow binary is `…pram_path extension_rom_path disks scsi_targets windows init_args model scaling_algorithm pause_on_state_load shared_dir disassembly_labels floppy_images custom_datetime shader_enabled shader_configs ethernet_link_type` — no serial-bridge field at all. |
| Snow's own settings file | `~/Library/Application Support/snowemu/Snow/settings.json` holds recents, file-dialog state and UI preferences. No bridge setting; it does not survive a quit. |
| System Events / AppleScript menu drive | Snow's macOS menu bar is `Apple, Snow` only — Workspace/Machine/State/Drives/Ports/… are drawn by **egui inside the window**, invisible to the accessibility API. |

What is left is **Ports → Channel B (printer) → Enable LocalTalk (UDP)**,
clicked by screen position. I verified by hand that it works and joins the
right group:

```
[2026-09-07T03:04:08Z INFO  snow_core::mac::localtalk_bridge] LocalTalk bridge started on port 1954, multicast 239.192.76.84, sender_id=77778
[2026-09-07T03:04:08Z INFO  snow_core::emulator] SCC bridge enabled on channel B: LocalTalk (node ?, tx:0 rx:0)
[2026-09-07T03:04:08Z INFO  snow_core::emulator] LocalTalk bridge enabled
```

### What I changed, and why

`tests/lib_snow.sh` gained one helper, `snow_localtalk_b` (no second
library, no `snow_disk` variant, no change to `snow_run`). It arms a
background clicker before `snow_run` — which blocks for the whole boot, so
nothing can run after it — that waits up to 60 s for Snow's window,
reads its origin with `osascript`, and posts three `scripts/click.swift`
clicks at offsets from the window's **top-left** (so they are independent
of window size and of the guest's screen resolution):

```
Ports                    (+250,  +49)
Channel B (printer)      (+310,  +95)
Enable LocalTalk (UDP)   (+498, +184)
```

It is fragile — a Snow release that moves those menus breaks it — but it
is not *silently* fragile: it then waits for Snow's own
`LocalTalk bridge enabled` stdout line and exits non-zero with the exact
geometry it used if that never arrives, and `adsp_listener.sh` turns that
into a `die`, not twelve confusing FAILs. Clicking early is also correct
on the guest's terms: the bridge only has to exist before the guest opens
`.MPP`, which is ~35 s into the boot.

**The right long-term fix is upstream: a `--serial-bridge-b localtalk`
mode in Snow** — the same one-line shape as the LaunchAPPL AppleTalk
patch. Until then every Snow AppleTalk test carries this clicker. That is
a decision the controller may want to revisit; I flagged it rather than
hiding it, and left the helper's whole rationale in its header comment.

---

## 2. P5 — the interop probe

Written into `task-1-report.md` as the appendix
**"P5 (Task 13c, 2026-09-07) — Snow / System 7 interop"**, with both
directions' verbatim output, the node numbers, the ruled-out list above
and a comparison table. Summary here.

Probe programs were throwaway Clarus, not trap-level: `p5snow.cla` and
`p5mac.cla` drove the shipped `service`/`listener`/`serviceBrowser`
surface for register and lookup, plus one `toolbox/appletalk.cla` call —
`setSelfSend` (csCode 256) on an `NBPParam` whose `interval`@28 /
`count`@29 are the same bytes as `newSelfFlag` / `oldSelfFlag`. That is
strictly more informative than re-deriving Task 1's raw parameter blocks:
it proves the *shipped* runtime on System 7, not just the driver.
Both sources were deleted afterwards.

### Both directions, verbatim

Snow guest (System 7, node 1), its `out` log after `##CLARUS-LOG##`:

```
gestalt atlk err 0 val 58
served SnowP5:ClarusP5S
registered SnowLsn:ClarusP5L
zones 1 *
done p1 0
selfsend err 0 old 0
found p2 SnowP5:ClarusP5S 0.1.252
done p2 1
done p3 0
done p3 0
found p3 MacP5:ClarusP5M 0.16.253
done p3 1
stopped
```

Mini vMac (System 6, node 16), the LaunchAPPL capture:

```
served MacP5:ClarusP5M
found SnowP5:ClarusP5S 0.1.252
done 1
stopped
```

Host `build-run/tools/atalkdrive lookup`, both Snow names:

```
0.1.252 SnowP5:ClarusP5S@*
0.1.251 SnowLsn:ClarusP5L@*
```

Both boots exited 0. Snow → Mini vMac, Mini vMac → Snow and host → Snow
all resolve. Net 0, zone `*`, no router — the same routerless LocalTalk
P2 saw.

### System 7's AppleTalk version, and what it does differently

**AppleTalk 58** (`Gestalt('atlk')` err 0, value 58).

| | Mac Plus ROM (P1/P3) | System 7 / Snow (P5) |
|---|---|---|
| `.XPP` / `.DSP` | `-43`, absent from the stripped boot disk | **present** — `lsn.register` opens `.DSP`, takes a dynamic ADSP socket and NBP-advertises it (`SnowLsn:ClarusP5L` at socket **251**) |
| `setSelfSend` (csCode 256) | **`-17`** (controlErr) | **`err 0`**, `oldSelfFlag 0` — implemented, off by default |
| self-lookup | `gotten 0` before and after | **0 before, 1 after** — System 7's `.MPP` answers its own NBP lookups once self-send is on |
| zones, routerless | `["*"]` | `["*"]` — unchanged |
| own node | dynamic; 106 and 18 seen | **1**, taken from the PRAM `SPATalkB` hint and never contested |

So `task-1-report.md`'s Amendment 3 (why `AtalkSelf` cannot be a
self-lookup) is a **Mini vMac / Mac Plus ROM** verdict, not an AppleTalk
verdict. Nothing in this phase depends on the difference; it is recorded
for whoever writes a System 7 AppleTalk case later.

One incidental measurement worth keeping: **Snow's guest screen is
640×480** (`"monitor": "HiRes14"`), not the Mac Plus's 512×342. `ui.cla`
centers a window on the real screen (`left = (screenW - reqW) / 2`), so a
300-wide window opens at left **170**, not 106 — which moves every
`--events` click coordinate on this lane. `adsp_listener.sh` restamps the
Serve click accordingly, and `server_registered` passing is the proof it
landed.

---

## 3. `tests/mactest/snow/adsp_listener.sh`

### Design

- **Roles.** Snow (System 7, Mac II, Clarus.snoww scratch clone) is the
  ADSP **listener**, installed into Startup Items with `snow_put_bin`;
  Mini vMac (System 6, `macplus/`, via `run_mac`) is the **client**. Same
  `examples/atalkchat.cla` source on both sides, the same per-run NBP-type
  `sed` stamp `adsp_68k.sh` uses, and the same twelve assertions copied
  from `adsp_68k.sh`'s `want_line` block.
- **The Serve click.** `testdata/ui/atalkchat_server.events`' committed
  `click 156 64` is correct for a 512-wide screen. The script `sed`s it to
  `click 220 64` (the same Serve button at Snow's 640-wide screen) and
  `die`s if the restamp does not take, so a change to the committed events
  file cannot silently turn this into a boot that never serves.
- **Sequencing.** `snow_run` blocks for the whole boot, so the client half
  runs in a background subshell started before it. It does not boot
  immediately: it polls `atalkdrive lookup $TYPE` on the shared group
  until the server's own NBP name is registered — a real signal, not a
  guessed sleep — and only then calls `run_mac`. (`trap - EXIT` inside it,
  because a backgrounded subshell that inherits `lib.sh`'s
  `rm -rf "$WORK"` would delete the tree the parent is still writing
  into; `run_mac`'s `die` path is wrapped in an inner subshell so
  `client.done` is written either way and `snow_run` is never left
  spinning to its ceiling.)
- **Done command.** `snow_done_when_trailer 20` — the server quits itself
  on `chat.closed`, and `natQuit`'s `##CLARUS-EXIT##` trailer reaches the
  live disk image mid-boot. Both captures are then split with
  `capture_split`, the same parse both lanes' `out` streams use, so the
  server's exit code is a real assertion (`server_exit`) rather than
  inferred.
- **The lock.** `atalk_lock` is taken as late as possible — after both
  fixture compiles, which need no network. `snow_run` installs its own
  `EXIT` trap and leaves `rm -rf "$WORK"` behind it, dropping the unlock,
  so the script restores `trap 'atalk_unlock; rm -rf "$WORK"' EXIT`
  immediately after. A lock leaked by a crash in the gap is self-healing:
  `atalk_lock` steals a lock whose recorded holder pid is gone.
- **The bridge.** `snow_localtalk_b` armed before `snow_run`; a failure is
  a `die` with Snow's log, deliberately **not** a thirteenth assertion —
  this script's contract is `adsp_68k.sh`'s twelve result lines exactly,
  and a dead bridge would fail all twelve for a reason that has nothing to
  do with ADSP.

### Timing budget (`# timeout: 30m`)

Measured, not guessed. The host's `atalkdrive` first sees the Snow guest's
NBP name **35 s** after Snow launches (System 7 boot + Startup Items
launch + NBP's ~3.2 s verified register) — identical on the probe boot and
on both real runs. The scripted server then has 400 `tick 12` lines ×
`Delay(10)` ≈ **66 s** of real life before its own watchdog quits it, and
the client needs ~20 s from LaunchAPPL start to `closing` (13a: the whole
two-boot Mini vMac pair is 20 s). So the exchange sits inside a ~66 s
server window with ~45 s of slack. `snow_run 600` is the **ceiling** for a
boot that never writes a trailer, not an expectation; `run_mac`'s own
300 s and the client half's 240 s discovery bound sit under it. Observed
wall clock for the whole script: **72 s**, **73 s** and **73 s** across
three runs.

### Verbatim logs and result lines

Run 3 (the last, on the committed script),
`build-run/tests/mactest/snow/adsp_listener.log` verbatim:

```
snow: exit trailer (over baseline 0) first seen at epoch 1788753134, held 20s, quitting at epoch 1788753155
  snow: snow_localtalk_b: Snow window at 780,165 after 0s
  snow: snow_localtalk_b: [2026-09-07T03:51:31Z INFO  snow_core::mac::localtalk_bridge] LocalTalk bridge started on port 1954, multicast 239.192.76.84, sender_id=24570
  host: listener visible after 34s: 0.1.252 Chat-3019:ClarusChat24462@*|
  server: serving Chat-3019
  server: accepted
  server: received 256
  server: received 5
  server: closed
  client: connecting
  client: found Chat-3019:ClarusChat24462 0.1.252
  client: opened
  client: received 257
  client: echo ok
  client: received 6
  client: echo ok
  client: closing
PASS server_exit
PASS client_exit
PASS server_registered
PASS server_accepted
PASS server_sweep
PASS server_hello
PASS server_closed
PASS client_opened
PASS client_sweep_echo
PASS client_hello_echo
PASS client_echo_exact
PASS client_echo_bytes
```

Runs 1 and 2 were identical modulo the per-run suffixes (`Chat-429` /
`ClarusChat81477` and `Chat-519` / `ClarusChat82908`). Note the listener's
address in all three:
`0.1.252` — Snow's node 1 and the dynamic ADSP socket the runtime's
`dspCLInit` took and NBP advertised, resolved by a System 6 client on the
other emulator.

Harness result lines:

```
$ CLARUS_SNOW_TESTS=1 CLARUS_MAC_TESTS=1 make -j1 test T=mactest/snow/adsp_listener
PASS mactest/snow/adsp_listener 72s
tests: 1 passed, 0 skipped, 0 failed

$ CLARUS_SNOW_TESTS=1 CLARUS_MAC_TESTS=1 make -j1 test T=mactest/snow/adsp_listener   # repeat
PASS mactest/snow/adsp_listener 73s
tests: 1 passed, 0 skipped, 0 failed

$ CLARUS_SNOW_TESTS=1 CLARUS_MAC_TESTS=1 make -j1 test T=mactest/snow/adsp_listener   # after the last edit
PASS mactest/snow/adsp_listener 73s
tests: 1 passed, 0 skipped, 0 failed
```

### What System 7's `.DSP` did NOT do differently

Nothing. Every ADSP body — `dspCLInit` with `localSocket 0`,
`dspCLListen`, `dspOpen(ocAccept)` on a second connection end,
`dspStatus`/`dspRead`/`dspWrite`, the orderly `dspClose`/`dspRemove` —
behaved exactly as 13a measured against the Mac Plus ROM's `.DSP`, at the
same `ocInterval 6` / `ocMaximum 3` and the same queue sizes, with the
peer on a different system version. No runtime or compiler file was
touched and no golden moved.

---

## 4. The standing `clarusc_bake` gate

Owed because `clarusc/bake.cla` changed twice this phase. **Green, first
try, no retry.**

```
$ CLARUS_SNOW_TESTS=1 make test T=mactest/snow/clarusc_bake
PASS mactest/snow/clarusc_bake 2232s
tests: 1 passed, 0 skipped, 0 failed
    (PASS bake_path_taken no_clfs_fallback dispatches no_error_markers
     clean_exit tickprobe_fork_identity -- 6/6)

CLARUS_SNOW_TESTS=1 make test T=mactest/snow/clarusc_bake  650.03s user 50.28s system 31% cpu 37:12.54 total
```

Wall clock **37m 12s** end to end (host `--bake` build of `ClarusC.APPL`,
Snow boot, the on-Mac compile, the 30 s trailer hold and the fork
comparison); the harness attributes **2232 s** to the script itself. The
guest's own timing line, from the captured trace:

```
[09-07-26 12:47:54] Compiled :::tickprobe.cla - 18m 42s (67330 ticks)
```

with `Measured` alone taking 11m 57s — the same shape the phase record
has always had for this gate. `tickprobe_fork_identity` passed, so the
Mac-resident compiler's baked-`'CLIR'` output is still byte-identical to
the host compiler's for the same fixture.

---

## 5. Boots, verification, files

### Boots

**Six Snow boots of the Clarus workspace clone:**

1. **P5 probe, no bridge** — established that the guest's AppleTalk is
   alive and that nothing on the host can see it. The whole network
   question turns on this one.
2. **Menu probe** (hand-driven, scratch clone of the workspace, no app
   installed) — found and verified the Ports → Channel B → Enable
   LocalTalk (UDP) path and its `LocalTalk bridge started … 239.192.76.84`
   log line. This is where `snow_localtalk_b`'s three offsets come from.
3. **P5 probe, with the bridge** — both interop directions, the
   `setSelfSend` / self-lookup verdicts, the AppleTalk version.
4. **`mactest/snow/adsp_listener` run 1** — 12/12.
5. **`mactest/snow/adsp_listener` run 2** — 12/12 (flake check).
6. **`mactest/snow/clarusc_bake`** — the standing gate, 6/6.

Plus **run 3** of `adsp_listener` (12/12) after a last cosmetic edit —
seven Snow boots of the workspace in total — and **nine throwaway Snow
launches with no workspace at all** (`--serial-bridge-b <value>` against
`rominator.rom`, ~6-12 s each, killed by `build-run/tools/timeout`) to
find out that no CLI mode enables the bridge.

**Six Mini vMac boots:** the P5 peer twice, the `adsp_listener` client
three times, and `make smoke`'s two (`smoke_bounce` + `tick`) inside
`scripts/test-task.sh --smoke`.

Snow was always quit through `snow_run`'s `osascript -e 'quit app "Snow"'`
(or, for the hand-driven menu probe, the same command by hand); nothing
was ever killed by app name from this task. `run_mac`'s pre-existing
timeout-path `pkill -f minivmac.app` never fired.

### Verification, verbatim

```
$ sh -n tests/mactest/snow/adsp_listener.sh && echo OK
OK
$ sh -n tests/lib_snow.sh && echo OK
OK

$ sh tests/mactest/snow/adsp_listener.sh ; echo exit=$?
SKIP: CLARUS_SNOW_TESTS not set
exit=77
$ CLARUS_SNOW_TESTS=1 sh tests/mactest/snow/adsp_listener.sh ; echo exit=$?
SKIP: CLARUS_MAC_TESTS not set
exit=77

$ make test T=runner/
PASS runner/selfcheck 1s
PASS runner/syntax 1s
PASS runner/timeout 5s

$ scripts/test-task.sh --smoke
tests: 104 passed, 34 skipped, 0 failed
PASS perfgate/tripwire 1s
tests: 1 passed, 0 skipped, 0 failed
PASS mactest/smoke_bounce 7s
PASS mactest/tick 4s
tests: 2 passed, 0 skipped, 0 failed
test-task.sh: PASS in 142s (smoke=1)

$ pgrep -fl 'Snow|minivmac'
(no output)
```

T1's skip count is **34**, one more than Task 13a's 33: the new
`mactest/snow/adsp_listener`, which SKIPs without `CLARUS_SNOW_TESTS`
exactly as every other Snow script does. `runner/syntax` (`sh -n` over
every `tests/**/*.sh`) covers both new files. The whole `atalk/` LToUDP
group and `hostrt/atalk` are green, so `atalk_lock` was released
correctly after the Snow boots.

### Files changed

| file | change |
|---|---|
| `tests/lib_snow.sh` | +85: one new helper, `snow_localtalk_b`, and its rationale. Nothing existing touched. |
| `tests/mactest/snow/adsp_listener.sh` | new, 207 lines. |
| `.superpowers/sdd/2026-09-07-appletalk/task-1-report.md` | +113: the P5 appendix. |

Not in git, but changed on disk: **`snow/Snow` was missing** and I
recreated it as a symlink to `/Applications/Snow.app/Contents/MacOS/Snow`.
`tests/lib_snow.sh`'s `SNOW_BIN` is `$ROOT/snow/Snow` and CLAUDE.md
documents that path, but only `snow/ClarusSnow` (the same target) existed
— so every Snow script would have died at `snow_run`'s
`"$SNOW_BIN" not found` check. `/snow` is gitignored, so this is an
environment repair, not a commit.

No runtime, compiler, example, golden or `testdata/` file was touched.
The two throwaway probe programs and their driver script lived in the
scratchpad and are gone.

### Self-review

- **Completeness.** P5 appendix written into `task-1-report.md` with both
  directions and the System 7 comparison table; `adsp_listener` 12/12
  three times with the harness lines quoted verbatim; `clarusc_bake`
  PASS 2232 s / 37m12s wall; the new script SKIPs cleanly for each
  missing gate variable, verbatim above.
- **Cannot pass vacuously.** The twelve assertions need specific whole
  lines in two independently captured logs from two different emulators;
  both exit codes are asserted from real `##CLARUS-EXIT##` trailers; the
  Serve-click restamp `die`s if it does not take; a missing client log
  `die`s; and a LocalTalk bridge that never came up `die`s with Snow's own
  message rather than producing twelve identical FAILs.
- **Honest header.** The timing budget quotes measurements (35 s to first
  NBP sighting, 66 s server window, ~20 s client) and says plainly that
  the 600 s is a ceiling, not an expectation. The 640×480 screen and the
  moved click coordinate are explained where the `sed` is.
- **Discipline.** No runtime or compiler edit; no golden moved (the full
  T1 above, which contains every golden check, is the proof); no test
  weakened; no timing tuned; no subagent dispatched; no emulator left
  running; nothing killed by app name.

### Concerns

1. **`snow_localtalk_b` clicks pixels, and that is a design decision the
   controller should ratify.** Section 1 has every alternative I measured
   and rejected. It is verified rather than hoped (Snow's own log line,
   fatal on absence) and its three offsets are anchored to the window's
   top-left corner rather than to the screen, but a Snow release that
   moves the Ports menu will break it, and every future Snow AppleTalk
   test inherits it. **The clean fix is upstream: a
   `--serial-bridge-b localtalk` mode**, exactly the shape of the
   LaunchAPPL AppleTalk patch that unblocked 13a. Worth asking Andrew for.
2. **This lane needs a real display.** The clicker posts CGEvents at
   screen coordinates, so `adsp_listener` cannot run headless or over a
   locked screen — a constraint the rest of the Snow group did not have.
   It is already opt-in behind `CLARUS_SNOW_TESTS`, so no gate changes.
3. **The Serve click coordinate is a second Snow-screen-size dependency.**
   `220,64` is derived from `ui.cla`'s centering on a 640-wide screen. Any
   future scripted-events test on the Snow lane has the same problem, and
   there is no shared helper for it — one restamp `sed` in one script is
   not worth abstracting yet, but a second one would be.
4. **`snow/Snow` was missing from a documented path.** Recreated (above).
   If other machines have the same gap the whole Snow group fails rather
   than skips, because `snow_run`'s check is a `die`. Making that a `skip`
   would match CLAUDE.md's own claim that a missing `snow/` makes the
   group SKIP — not done here, out of scope, flagged.

### For the phase record (Task 13d)

- `tests/mactest/snow/adsp_listener.sh` exists and is 12/12: System 7's
  `.DSP` as the listener, System 6 Mini vMac as the client, over LToUDP.
- **System 7 (AppleTalk 58) differs from the Mac Plus ROM in exactly two
  ways that matter to this phase**: `setSelfSend` works (`err 0` vs
  `-17`), and self-lookup then works (1 tuple vs 0). `.XPP`/`.DSP` are
  present without any boot-disk patching. `task-1-report.md`'s
  Amendment 3 is therefore a Mini vMac verdict, not an AppleTalk one.
- **Nothing about System 7's `.DSP` behaved differently** from 13a's
  Mac Plus ROM measurements — same `dspCLInit`/`dspCLListen`/
  `dspOpen(ocAccept)`/`dspClose` shape, same socket handling, no runtime
  change needed.
- **Snow's LocalTalk-over-UDP bridge is GUI-only** and `lib_snow.sh` now
  clicks it on. This is the one piece of the AppleTalk lane that is not
  self-contained, and the standing ask is a Snow CLI flag.
- Snow's guest screen is 640×480, so `--events` click coordinates from the
  512-wide Mini vMac lane do not transfer.
- The standing `clarusc_bake` gate was re-run for this phase and is green
  (PASS, 2232 s).

---

## Fix report (review round 1, 2026-09-07)

Four items taken: Important 1 (both halves), minors 2, 3, 4 and 5.
No re-run of `clarusc_bake` (not asked for, nothing it covers changed).

### Important 1(a) — an orphaned clicker could click somebody else's Snow

Real, and worse than a nuisance: `snow_localtalk_b` was armed two lines
before `snow_run`'s `pgrep -x Snow` refusal, so on a machine already
running Andrew's 68kbbs Snow the parent died on that refusal, nothing
reaped `$SNOW_LTALK_PID`, and the surviving clicker's
`tell process "Snow" to get position of window 1` would have found HIS
window and posted three clicks into HIS Ports menu — with its own log
already deleted along with `$WORK`. Both halves of the fix are in:

- **The clicker now waits for `$WORK/snow.log` before it looks at any
  window at all** (`tests/lib_snow.sh`). That file is created by
  `snow_run`'s own launch redirection (`lib_snow.sh:280`) and by nothing
  else, so "our Snow has been launched" is now a precise precondition
  rather than "a process named Snow exists". Its give-up message says
  which of the two it was waiting on:
  `no window from our own Snow after Ns (snow.log present|absent)`.
- **`adsp_listener.sh` hoists its own `pgrep -x Snow` refusal** above
  everything it arms, so the case never gets that far. The comment says
  why the duplicate exists.
- `snow_localtalk_b`'s header now states the ordering constraint
  outright: *"It must only be started once snow_run is about to launch:
  it waits for `$WORK/snow.log`…"*.

### Important 1(b) — background halves outliving the script

`atalk_lock`'s trap had no kills and `snow_run` replaces the trap
entirely, so a `die` in `snow_disk`/`snow_put_bin` left the client half
free to go on and boot Mini vMac for up to 240 s + a boot after the
script was gone, with `atalk_lock` released but the group still in use.
Two layers, because neither alone covers everything:

- A `cleanup` function (`atalk_68k.sh`'s shape) installed right after
  `atalk_lock` and **re-installed after `snow_run` returns**: kills
  `$SNOW_LTALK_PID` and `$CLIPID` (both `${…:-}`-guarded under `set -u`),
  `pkill -f "$WORK/launch"` — the per-run cwd, never an app name, so it
  cannot touch an unrelated session's emulator — then `atalk_unlock` and
  `rm -rf "$WORK"`. `INT`/`TERM` get it too.
- **Both halves give up on their own when `$WORK` disappears**
  (`[ -d "$WORK" ] || return 0` at the top of the client half's poll loop
  and immediately before its `run_mac`; `[ -d "$WORK" ] || exit 1` in the
  clicker's). Every EXIT trap in play removes `$WORK`, so this is the
  one signal that covers the window neither trap does — a `die` *inside*
  `snow_run`, which runs `snow_run`'s trap and not ours.

The unlock happens on all of those paths: `cleanup` calls
`atalk_unlock`, and a lock leaked by anything more violent is
self-healing (`atalk_lock` steals a lock whose recorded holder pid is
gone).

### Minor 2 — file mode

`git update-index --chmod=+x tests/mactest/snow/adsp_listener.sh`; it is
now `100755`, matching all eight siblings.

### Minor 3 — the missing `-1273` skip is deliberate

Stated in the script header, one sentence: unlike `adsp_68k.sh` there is
no boot-disk skip here, because a machine that can run the Snow lane at
all is by definition one with the LaunchAPPL AppleTalk patch and a
System 7 disk that carries `.DSP` — twelve loud FAILs beat a
green-by-skip. Same ruling as the toolbox suite's `AdspLeak`.

### Minor 4 — `click.swift`'s stderr

The `> /dev/null 2>&1` is gone; both streams now land in
`$WORK/ltalk.log`, which the failure path already dumps into the test
log. A missing `swift` or a revoked Accessibility permission now says so
instead of masquerading as "Snow's menu layout moved". Comment says why.

### Minor 5 — `window 1`

One clause added to the helper's robustness comment: `window 1` is
System Events' *frontmost* window of the Snow process, so a modal Snow
dialog would be window 1 instead; our boots open none, and the
`LocalTalk bridge enabled` check is what notices if one ever does. No
code change.

### Verification, verbatim

```
$ sh -n tests/mactest/snow/adsp_listener.sh && sh -n tests/lib_snow.sh && echo "sh -n OK"
sh -n OK

$ make test T=runner/
PASS runner/selfcheck 1s
PASS runner/syntax 0s
PASS runner/timeout 5s
tests: 3 passed, 0 skipped, 0 failed

$ CLARUS_SNOW_TESTS=1 CLARUS_MAC_TESTS=1 make -j1 test T=mactest/snow/adsp_listener
PASS mactest/snow/adsp_listener 73s
tests: 1 passed, 0 skipped, 0 failed

  snow: snow_localtalk_b: Snow window at 780,165 after 1s
  snow: snow_localtalk_b: [2026-09-07T04:06:53Z INFO  snow_core::mac::localtalk_bridge] LocalTalk bridge started on port 1954, multicast 239.192.76.84, sender_id=33893
  host: listener visible after 35s: 0.1.252 Chat-3940:ClarusChat33784@*|
  server: serving Chat-3940
  server: accepted
  server: received 256
  server: received 5
  server: closed
  client: connecting
  client: found Chat-3940:ClarusChat33784 0.1.252
  client: opened
  client: received 257
  client: echo ok
  client: received 6
  client: echo ok
  client: closing
PASS server_exit
PASS client_exit
PASS server_registered
PASS server_accepted
PASS server_sweep
PASS server_hello
PASS server_closed
PASS client_opened
PASS client_sweep_echo
PASS client_hello_echo
PASS client_echo_exact
PASS client_echo_bytes

$ pgrep -fl 'Snow|minivmac'
(no output)
```

Four green runs of `adsp_listener` now (72 s / 73 s / 73 s / 73 s), the
last on the reviewed script. Minor 6 (`client_echo_bytes` being vacuous
on an empty client log) left alone as instructed — it mirrors
`adsp_68k.sh`, and `client_opened` immediately above it is what makes an
empty log impossible to pass with.
