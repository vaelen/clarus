# AppleTalk phase — Task 1 report: probe wave, Mac side

Date: 2026-09-07. Worktree `/Users/andrew/repos/clarus-wt/t1`, branch
`appletalk-t1`, base `8068737`. Probes P1–P4 only; **P5 (Snow interop) was
not run** — it is deferred to Task 13 per the dispatch, and no Snow
emulator was booted.

Everything below was produced by throwaway Clarus programs built with
`scripts/build-68k.sh` (native `emit68k`, no Retro68) and booted under
`toolchain/bin/LaunchAPPL -e minivmac`. All scratch sources and build
directories were deleted at the end of the task; the exact sources are
reproduced inline where a later task needs them.

---

## Summary of verdicts

| Probe | Question | Verdict |
|---|---|---|
| P1 | `.MPP`/`.ATP`/`.XPP`/`.DSP` open on the LaunchAPPL boot disk | **`.MPP`/`.ATP` yes (ROM). `.XPP`/`.DSP` NO — `-43`.** The stripped disk carries no `AppleTalk` file. Tasks 9/11 need a different boot path for ADSP. |
| P2 | NBP register on one Mac, lookup from the other, host sniffer sees both | **Works, first try.** `gotten=1`, correct tuple, both LkUp and LkUp-Reply captured on the multicast group. Frame bytes recorded below. |
| P3 | Self-lookup and `SetSelfSend`; ATP self-transaction | **Neither is available on the Mac Plus ROM AppleTalk.** `setSelfSend` → `-17` (controlErr); self-lookup → `gotten=0` before and after; ATP self-transaction → `sendRequest` `-1096`, the async `getRequest` never completes. `AtalkSelf` must be reshaped — see Amendment 3. |
| P4 | Two-boot launcher | **Works.** Both instances run simultaneously with independent captures. **But the brief's `pkill -f MacPlus2.app` recipe is wrong** — see Amendment 5. |

Two additional load-bearing findings fell out of P3 and are written up as
Amendments 2 and 4: **a Device Manager parameter block must not be reused
for a second AppleTalk call without being re-zeroed** (reuse hung the
emulated Mac hard), and **`registerName` fills the caller's
`nteAddress` with the node's own address**, which is the cheapest way for
a program to learn its own net/node.

---

## P1 — `.DSP`/`.XPP` on the LaunchAPPL boot disk

### Result: `.MPP` and `.ATP` open; `.XPP` and `.DSP` fail with `-43`. Plan around it.

The probe program (`drivers.cla`) declared its own `IOParam` extern record
(copied verbatim from `toolbox/files.cla:181-199`) plus
`external func PBOpenSync(paramBlock: ptr): int = trap 0xA000 reg`, and
opened the four drivers in order, writing one line per driver through
`alert()`.

```sh
cd /Users/andrew/repos/clarus-wt/t1
scripts/build-68k.sh Drivers $SCRATCH/atprobe/drivers.cla
cd $SCRATCH/launch1
/Users/andrew/repos/clarus-wt/t1/toolchain/bin/LaunchAPPL -e minivmac \
    /Users/andrew/repos/clarus-wt/t1/build-68k/Drivers/Drivers.bin
```

LaunchAPPL stdout (the `out`-file echo channel), exit 0, 2.8 s wall:

```
.MPP refnum=-10 err=0
.ATP refnum=-11 err=0
.XPP refnum=0 err=-43
.DSP refnum=0 err=-43
##CLARUS-EXIT## 0
##CLARUS-LOG##
```

`-43` is `fnfErr` — `OpenDriver` found no `'DRVR'` resource of that name
anywhere in the resource chain. `.MPP` (−10) and `.ATP` (−11) are in the
Mac Plus ROM, so they open regardless.

### What the stripped boot disk actually contains

LaunchAPPL's temp image was copied out mid-boot (background the launch,
`find <cwd> -name disk1.dsk`, `cp`) and listed with hfsutils:

```sh
toolchain/bin/hmount $SCRATCH/stripped.dsk
toolchain/bin/hls -l
```
```
Volume name is "SysAndApp"
f  APPL/????     31592         0 Sep  7 01:04 App
f  FNDR/MACS      1121         0 Oct  6  2012 AutoQuit
f  TEXT/MPS          0         0 Sep  7 01:04 out
f  ZSYS/MACS    639032       860 Sep  7 00:14 System
```

Four files. This is not an accident of our image — it is exactly what
`Retro68/LaunchAPPL/Client/MiniVMac.cc:338-400` builds. For a System 6
(non-AutQuit7) boot it copies, from the source system image: the System
file named in the boot block, the boot block's *debugger* file (absent
here), `32-Bit QuickDraw`, `TrueType™ 1.0`; then the app as `App`, then
`AutoQuit` from the autoquit image, then an empty `out`. The
`AppleTalk` file is not in that list and there is no option to add one.

For contrast, the source image (`macplus/disk1.dsk` →
`/Users/andrew/mac/macplus/disk1.dsk`) does carry it:

```
f  ZSYS/MACS     60988         0 Jun  1  1994 AppleTalk     (System Folder)
```

and its resource fork holds exactly the four drivers the spec claims
(extracted with `hcopy -m` and parsed with a throwaway resource-map
reader, since `build-run/tools/resfork` rejects the file — it aborts on
`vers` resources with a non-zero attribute byte, `attr = 0x20`):

```
DRVR    10 attr=0x50 '.ATP'
DRVR    40 attr=0x50 '.XPP'
DRVR   126 attr=0x50 '.DSP'
DRVR     9 attr=0x50 '.MPP'
```

### How to make the boot disk carry it — options, ranked

None of these was implemented (out of scope for a probe); they are ranked
by cost with the evidence each rests on.

1. **Second disk image + `OpenResFile` (cheapest, untested).**
   `MiniVMac.cc:298-310` copies the whole `MacPlus.app` bundle into the
   run's temp dir *before* writing `disk1.dsk` into its `mnvm_dat`. A
   `disk2.dsk` placed in a scratch copy of the bundle would therefore be
   carried along and auto-mounted by Mini vMac, and `--minivmac-dir`/
   `--minivmac-path` can point at that scratch copy so nothing shared is
   touched. The app would then `HOpenResFile`/`OpenResFile` the
   `AppleTalk` file on that volume before `OpenDriver(".DSP")`, so its
   `'DRVR'` resources join the resource chain. **Risk:** AppleTalk 58's
   `.DSP` may expect AppleTalk 58's `.MPP` (which would *not* be loaded —
   the ROM `.MPP` wins), and nothing here proves it tolerates that.
2. **Patch `MiniVMac.cc` to `CopySystemFile("AppleTalk", false)` and
   rebuild LaunchAPPL.** One line, semantically exactly right (the file
   lands in the System Folder equivalent, the System's own boot path
   installs it, `.MPP` is replaced by the 58.1.4 one). Cost: a Retro68
   rebuild of a symlinked prebuilt toolchain.
3. **Build our own boot image and drive Mini vMac directly** (the
   `open -na` + `mnvm_dat` path CLAUDE.md documents for manual runs),
   re-implementing MiniVMac.cc's disk build in shell with hfsutils. Full
   control, but loses the `out` echo channel and blocks-until-quit
   semantics that `run_mac` depends on.
4. **Bake `.DSP`/`.XPP` as `'DRVR'` resources into the Clarus app's own
   resource fork.** `OpenDriver` searches the app's resource file first,
   so this needs no disk change at all — but it needs `clarusc emit68k`
   to emit arbitrary resources, which today it does not (only the
   `--bake` `'CLFS'` path exists).

**Do not** patch the source image's boot-block debugger-name field to
"AppleTalk" to smuggle it through `CopySystemFile(debuggerFileName, …)`:
System 6 would then try to load the AppleTalk file as a debugger at boot.

---

## P2 — NBP register on one Mac, lookup from the other, host sniffer

### Result: works end to end, first try. Use it.

`register.cla` opened `.MPP`, built a 108-byte `NamesTableEntry` with
`NewPtrClear` (`qNext`@0, `nteAddress`@4, `filler`@8, packed entity at @9),
registered `Probe-1:ClarusProbe@*` with `csCode` 253 / `interval` 8 /
`count` 3 / `ntQElPtr`@30 / `verifyFlag`@34 = 1, idled 3600 ticks, then
removed the name with `csCode` 252 and `entityPtr`@30 = NTE+9.
`lookup.cla` opened `.MPP` and ran `csCode` 251 for `=:ClarusProbe@*` with
`retBuffPtr`@34 → a 1024-byte buffer, `retBuffSize`@38 = 1024,
`maxToGet`@40 = 16, decoding each returned tuple as
`AddrBlock`(4) + enumerator(1) + three packed Pascal strings.

Both parameter-block layouts came straight from
`toolchain/universal/CIncludes/AppleTalk.h:565-581` (`NBPparms`) and were
verified field by field: `interval`@28, `count`@29, `nbpPtrs`@30,
then either `verifyFlag`@34 or `retBuffPtr`@34 / `retBuffSize`@38 /
`maxToGet`@40 / `numGotten`@42.

Driver script (`pair.sh`): start the sniffer, start `Register` on
`macplus/` via the default `~/.LaunchAPPL.cfg`, wait 5 s, start `Lookup`
on `macplus2/` from a *different* cwd with per-invocation overrides.

**The macplus2 command line that worked, verbatim:**

```sh
cd $SOME_OTHER_DIR && \
/Users/andrew/repos/clarus-wt/t1/build-run/tools/timeout 120 \
  /Users/andrew/repos/clarus-wt/t1/toolchain/bin/LaunchAPPL -e minivmac \
    --minivmac-dir /Users/andrew/repos/clarus-wt/t1/macplus2 \
    --minivmac-path ./MacPlus2.app \
    --system-image ./disk1.dsk \
    --autoquit-image ./autoquit-1.1.1.dsk \
    /Users/andrew/repos/clarus-wt/t1/build-68k/Lookup/Lookup.bin
```

`--minivmac-rom` was **not** needed: it defaults to `./vMac.ROM` relative
to `--minivmac-dir`, and `macplus2/vMac.ROM` exists.

Captures — each instance's `out` echo landed in its own stdout file, no
interleaving:

```
$ cat cap_register.txt              $ cat cap_lookup.txt
.MPP refnum=-10 err=0               .MPP refnum=-10 err=0
register err=0                      lookup err=0 gotten=1
remove err=0                        0.106.0 Probe-1:ClarusProbe@*
##CLARUS-EXIT## 0                   ##CLARUS-EXIT## 0
##CLARUS-LOG##                      ##CLARUS-LOG##
```

Both LaunchAPPL processes exited 0. Wall clock for the pair: 66 s
(dominated by the register program's own 60 s idle).

### The sniffer

`sniff.py`, a throwaway: `SO_REUSEADDR` + `SO_REUSEPORT`, `bind(('', 1954))`,
`IP_ADD_MEMBERSHIP` on `239.192.76.84`, 1 s socket timeout, printing each
datagram as hex plus a decode of the 4-byte LToUDP sender id, the LLAP
header (dst/src/type), the short/long DDP header and, for `ddpType` 2, the
NBP function/tuple decode.

Both emulators appear on the group as UDP from `192.168.68.15:*`, each
with its own stable 4-byte sender id (`b698b788` = the `macplus/`
instance, `fe09e09a` = `macplus2/`). No other traffic was on the group
during the run.

### The two frames Task 2's encoder/decoder is written against

**LkUp** — from the lookup Mac (node 18), broadcast:

```
datagram: fe09e09a  ff1201001c028c0221010000128c00013d0b436c6172757350726f6265012a
          ^sender   ^LLAP+payload
```
| bytes | meaning |
|---|---|
| `fe09e09a` | LToUDP sender id (4 bytes, not part of the LLAP frame) |
| `ff 12 01` | LLAP: dst = 255 (broadcast), src = 18, type = 1 (short DDP) |
| `00 1c` | DDP short header: datagram length 28 (includes these 5 header bytes) |
| `02` | destination socket 2 (NIS, the Names Information Socket) |
| `8c` | source socket 140 |
| `02` | DDP protocol type 2 (NBP) |
| `21` | NBP: function 2 (LkUp) in the high nibble, tuple count 1 in the low |
| `01` | NBP transaction id 1 |
| `00 00 12 8c` | tuple address: net 0, node 18, socket 140 (where to reply) |
| `00` | enumerator 0 |
| `01 3d` | object `"="` |
| `0b 436c6172757350726f6265` | type `"ClarusProbe"` |
| `01 2a` | zone `"*"` |

**LkUp-Reply** — from the register Mac (node 106), unicast back to node 18:

```
datagram: b698b788  126a0100228c0202310100006a00010750726f62652d310b436c6172757350726f6265012a
```
| bytes | meaning |
|---|---|
| `b698b788` | LToUDP sender id |
| `12 6a 01` | LLAP: dst = 18, src = 106, type = 1 (short DDP) |
| `00 22` | DDP short header: length 34 |
| `8c` | destination socket 140 |
| `02` | source socket 2 |
| `02` | DDP type 2 (NBP) |
| `31` | NBP: function 3 (LkUp-Reply), tuple count 1 |
| `01` | transaction id 1 (echoes the request's) |
| `00 00 6a 00` | tuple address: net 0, node 106, **socket 0** |
| `01` | enumerator 1 |
| `07 50726f62652d31` | object `"Probe-1"` |
| `0b 436c6172757350726f6265` | type `"ClarusProbe"` |
| `01 2a` | zone `"*"` |

Note the reply's socket is **0** because the probe left the NTE's
`nteAddress.aSocket` zero. NBP fills in net and node but takes the socket
verbatim from the caller — see Amendment 1.

### Other traffic observed, and the timings

- **LLAP node acquisition**: each instance sent **exactly 640** LLAP ENQ
  frames (`<node> <node> 0x81`, 3 bytes, dst == src == the tentative
  node) in a burst — 184 ms for the first instance, 170 ms for the
  second. Nothing else on the wire during the burst. A test that watches
  the group must tolerate this storm; a host LToUDP peer (Task 2) must
  answer ENQ only for addresses it actually owns.
- **RTMP-req**: right after acquisition, each node broadcast `ddpType` 5
  (`ff <node> 01 0006 01 01 05`) twice, looking for a router. Nothing
  answered — routerless net, net number 0, zone `*`, exactly as the spec
  assumes.
- **`verifyFlag` really verifies**: the register Mac, on `registerName`
  with `verifyFlag = 1`, broadcast its own full-name LkUp three times
  (t = 3.891, 5.554, 6.634 s) before returning `err = 0`. Nobody
  answered, so the name was unique.
- **`lookupName` runs all its retries even after a reply.** With
  `interval = 8`, `count = 3`, the lookup Mac broadcast LkUp at 8.534,
  10.230 and 11.327 s and got a LkUp-Reply back within **12 ms** each
  time; the sync `PBControlSync` did not return early. So a lookup costs
  ≈ `count × interval × 8 ticks` ≈ 3.2 s at 8/3 regardless of how fast
  the answer arrives. Task 11 must budget for that, and Task 8's
  `serviceBrowser` should pick its interval/count with that in mind.

**Boot to first AppleTalk packet** (from `LaunchAPPL` process start):
- instance 1: first LLAP ENQ at **2.69 s**, first NBP frame at **2.89 s**;
- instance 2: first LLAP ENQ at **2.35 s**, first NBP frame at **2.53 s**.

So ~3 s of boot before a program's `OpenDriver(".MPP")` has a node.

---

## P3 — self-lookup, `SetSelfSend`, ATP self-transaction

### Result: NONE of the three works on the Mac Plus ROM AppleTalk. `AtalkSelf` must be reshaped.

Three separate boots, all on `macplus/` via the default config.

**(a) Self-lookup, before and after `setSelfSend`.** One program:
open `.MPP`, register `Probe-Self:ClarusSelf@*`, look up `=:ClarusSelf@*`,
call `setSelfSend` (`csCode` 256, `newSelfFlag`@28 = 1, `oldSelfFlag`@29
read back), look up again with a **fresh** parameter block, remove.

```
.MPP refnum=-10 err=0
register err=0
selflookup(before) err=0 gotten=0
A: before setSelfSend
setSelfSend err=-17 old=0
B: before lookup2
selflookup(after,fresh PB) err=0 gotten=0
C: before remove
remove err=0
##CLARUS-EXIT## 0
```

- `setSelfSend` returns **`-17` (controlErr)** — the Mac Plus ROM `.MPP`
  does not implement csCode 256. Confirmed independently with a
  three-line program that opens `.MPP` and does nothing but the
  `setSelfSend` call (same `-17`, clean exit).
- Self-lookup returns **`gotten = 0`** both before and after. NBP on this
  node never answers its own lookup, and there is no way to turn
  self-send on.

This is a consequence of P1: the ROM `.MPP` is what we get, because the
`AppleTalk` 58.1.4 file (whose `.MPP` DRVR 9 *would* replace it and does
implement `setSelfSend`) is not on the stripped boot disk. If Tasks 9/11
solve P1 by loading the AppleTalk file, `setSelfSend` should be retried —
but nothing in this phase may assume it.

**(b) ATP self-transaction.** Open `.MPP`, register a name (to learn our
own address, see Amendment 4), open `.ATP`, `openATPSkt` (csCode 254,
`atpSocket`@28 = 0), issue an **async** `getRequest` via
`external func PBControlAsync(paramBlock: ptr): int = trap 0xA404 reg`
(csCode 253, `reqPointer`@36 → 600-byte buffer, `reqLength`@34 = 578),
then a **sync** `sendRequest` (csCode 255, `addrBlock`@30 = our own
net/node + the ATP socket, `atpFlags`@29 = 32 (XO), `bdsPointer`@40 → one
12-byte BDS entry over a 578-byte buffer, `numOfBuffs`@44 = 1,
`timeOutVal`@45 = 2, `retryCount`@47 = 3):

```
.MPP refnum=-10 err=0
register err=0 nteAddress=0.106.0
.ATP refnum=-11 err=0
openATPSkt err=0 socket=202
getRequest(async) err=0 ioResult=1
about to sendRequest to 0.106.202
sendRequest err=-1096 numOfResps=0
getRequest ioResult=1 reqTID=0 transID=0 reqLength=578
killAllGetReq err=-17
closeATPSkt err=0
remove err=0
##CLARUS-EXIT## 0
```

- `openATPSkt` works and hands out a dynamic socket (202 this run).
- The async `getRequest` is accepted (`err = 0`) and stays pending
  (`ioResult = 1`).
- The sync `sendRequest` to our own address fails with **`-1096`**
  (`reqFailed`, retry count exhausted) after all three retries, and the
  `getRequest` **never completes** — `ioResult` is still 1 afterwards.
  The request packet never came back to our own node, exactly as expected
  with self-send off and no way to turn it on.
- `killAllGetReq` (csCode 259) returns **`-17`**. Caveat, stated honestly:
  that call was made on the same parameter block that still carried the
  pending async `getRequest`, which is itself the reuse pattern
  Amendment 2 warns about — so treat the `-17` as indicative of "not
  implemented on the ROM `.ATP`" rather than proven. Either way, do not
  build on `killAllGetReq`; use `PBKillIOSync` on the `.ATP` refnum.
- `closeATPSkt` and `removeName` both returned 0, and the app quit
  cleanly, even with a request left pending.

**So one-program ATP self-transactions are not viable** — and neither is
NBP self-lookup. See Amendment 3 for what `AtalkSelf` can assert instead.

---

## P4 — two-boot launcher

### Result: two simultaneous instances work; but identify and kill them by CWD, not by app name.

`p4.sh` started `Register.bin` on `macplus/` (default config), waited 3 s,
started the same binary on `macplus2/` with the overrides above from a
different cwd, then at t = 15 s dumped the process table, screenshotted,
killed the second instance and re-dumped.

**(a) Both up at once — yes.** Eight processes, four per instance:

```
79521 .../build-run/tools/timeout 120 .../LaunchAPPL -e minivmac .../Register.bin
79522 .../toolchain/bin/LaunchAPPL -e minivmac .../Register.bin
79523 open -nWa /…/scratchpad/p4a/a723-7657-dd1c-07de/minivmac.app
79524 /…/scratchpad/p4a/a723-7657-dd1c-07de/minivmac.app/Contents/MacOS/minivmac
79653 .../build-run/tools/timeout 120 .../LaunchAPPL -e minivmac --minivmac-dir …/macplus2 --minivmac-path ./MacPlus2.app --system-image ./disk1.dsk --autoquit-image ./autoquit-1.1.1.dsk .../Register.bin
79654 .../toolchain/bin/LaunchAPPL -e minivmac --minivmac-dir …/macplus2 …
79655 open -nWa /…/scratchpad/p4b/817d-290f-bc12-bfa7/minivmac.app
79656 /…/scratchpad/p4b/817d-290f-bc12-bfa7/minivmac.app/Contents/MacOS/minivmac
```

A screenshot at t = 15 s shows **two Mini vMac Dock icons**, but only one
window: both instances open their window at the identical default screen
position, so the second is exactly behind the first. Fine for
`--events`-driven tests (no HID interaction), but a screenshot-based
assertion can only ever see the front one, and only the front one is
click-targetable.

**(b) Each `out` echo in its own capture — yes**, proven by the P2 run
above: `cap_register.txt` and `cap_lookup.txt` each held only their own
program's output.

**(c) `pkill -f MacPlus2.app` does NOT do what the brief expected.**

```
$ pgrep -f 'MacPlus2.app'      $ pgrep -f 'MacPlus.app'
79653                          (no match)
79654
```

It matches the *`timeout` and `LaunchAPPL` wrapper processes* — because
`MacPlus2.app` appears in LaunchAPPL's own argv — and never the emulator.
And `MacPlus.app` matches nothing at all for instance 1, because that
path comes from `~/.LaunchAPPL.cfg`, not the command line. Worse, **both
emulator processes are literally `<temp>/minivmac.app/Contents/MacOS/minivmac`**:
`MiniVMac.cc:300-303` copies whatever bundle it was given to a fixed name,
`minivmac.app`, inside the run's temp dir. So `run_mac`'s existing
`pkill -f minivmac.app` would kill **both** instances.

The reliable discriminator is the **per-instance working directory**,
which is where LaunchAPPL creates its temp dir and which therefore appears
in both the `open -nWa …` and the `minivmac` argv. Verified:

```sh
pkill -f "$SP/p4b"      # -> "pkill matched"
```
killed exactly instance 2's `open` and `minivmac` (LaunchAPPL then exited
with status 1) and left instance 1 running to completion (status 0). Both
`wait`s returned; nothing was orphaned.

---

## Amendments to later tasks

**Amendment 1 (Task 2, Task 6, Task 9) — NBP registers the socket you
give it, verbatim.** `registerName` fills the NTE's `nteAddress` net and
node itself, but copies `aSocket` (offset 7 in the NTE — `nteAddress`@4 +
3) straight through. The probe left it zero and the resulting LkUp-Reply
advertised socket 0. A real service must write its listening socket (its
ATP socket from `openATPSkt`, or the ADSP socket) into NTE+7 **before**
calling `registerName`, or clients will get an unusable address.

**Amendment 2 (Task 2, Task 6, Task 7, Task 9) — never reuse an
AppleTalk parameter block without re-zeroing it.** This one hung the
emulated Mac hard, three boots in a row, with no bomb and no error: a
second `lookupName` issued on the *same* `NBPparms` block that had just
completed a first `lookupName` (with only `csCode`, `numGotten`,
`retBuffPtr`, `retBuffSize` and `maxToGet` rewritten) never returned.
The identical program with a **fresh, zero-initialized** block for the
second lookup completed normally. The stale queue fields (`qLink`@0 /
`qType`@4) are the likely culprit. Runtime code that keeps a long-lived
PB per connection/listener slot **must** clear the whole block between
calls, not just the fields it sets — and Task 11's tests should include a
back-to-back double lookup as the regression for it.

Two related disciplines confirmed while chasing this:
- Pad every AppleTalk parameter-block `extern record` out to at least 52
  bytes, the same rule `toolbox/devices.cla`'s header comment already
  states for `CntrlParam`'s 50. The Device Manager's `ParamBlockRec`
  union is bigger than the fields any one call names; a short record is a
  stack overrun waiting to stomp its neighbours. (52, not 50, because
  ATP's `SendReqparms` is 52 bytes.)
- `extern record` cannot be an array element, so per-slot PBs in the
  runtime need `NewPtrClear` + `peek*`/`poke*` by offset — which makes
  the re-zeroing above a plain `NewPtrClear`-equivalent memory clear,
  cheap to do unconditionally.

**Amendment 3 (Task 6 / spec §8.2) — `AtalkSelf` must be register +
lookup-of-a-name-that-isn't-there, not a self-lookup and not an ATP
self-transaction.** The spec's parenthetical "(if the probe says the ROM
answers its own lookups, possibly via `SetSelfSend`)" resolves to **no**:
`setSelfSend` is `-17` and self-lookup is `gotten = 0`. The no-peer
hardware proof that *is* available, all verified above on real ROM:

| assertion | observed |
|---|---|
| `PBOpenSync(".MPP")` | `err = 0`, refNum `-10` |
| `registerName` (verifyFlag 1) | `err = 0` |
| `nteAddress` filled in | net 0, node in 1..254 (106 and 18 seen) |
| `lookupName` for an unregistered type | `err = 0`, `gotten = 0` |
| `removeName` | `err = 0` |
| `PBOpenSync(".ATP")` | `err = 0`, refNum `-11` |
| `openATPSkt` | `err = 0`, socket in the dynamic range (202 seen) |
| `closeATPSkt` | `err = 0` |

Note the case must not assert a *fixed* node number (it is acquired
dynamically per boot) and must budget ≈ 3.2 s for each `lookupName` at
interval 8 / count 3, plus ≈ 3.2 s for `registerName`'s verify.

**Amendment 4 (Task 6, Task 8) — a program learns its own address for
free from `registerName`.** After the call, NTE+4..7 holds
`net(2) node(1) socket(1)` — the probe read back `0.106.0`. No
`GetNodeAddress` glue, no low-memory poking, no self-lookup needed. This
is the source Task 8's `address` values and Task 6's `AtalkSelf` should
use.

**Amendment 5 (Task 11, `run_mac_pair`) — kill by cwd, not by app name.**
Replace the brief's `pkill -f MacPlus2.app` with `pkill -f "$per_run_cwd"`.
Concretely, `run_mac_pair` should give each instance its own working
directory under `$WORK` (e.g. `$WORK/launchA`, `$WORK/launchB`), because
that path is (a) where LaunchAPPL creates its temp dir, (b) the only
string that appears in exactly one instance's process tree, and (c)
already needed anyway since LaunchAPPL makes its temp dir in cwd and two
instances must not share one. Note also that the existing `run_mac`
timeout path's `pkill -f minivmac.app` would kill *both* instances of a
pair; the pair helper must not reuse it.

**Amendment 6 (Tasks 9 and 11) — ADSP has no boot path today.** Spec
§8.2's `mactest/adsp_68k.sh` (two Mini vMac boots, one listener, one
client) cannot run as written: `OpenDriver(".DSP")` is `-43` on the
LaunchAPPL boot disk. Task 9 must pick one of the four P1 options above
and Task 11 must build the harness around it, or ADSP moves out of this
phase. Option 2 (one line in `MiniVMac.cc` + a LaunchAPPL rebuild) is the
semantically correct one; option 1 (a second disk carried in a scratch
bundle copy) is the cheapest but rests on the untested assumption that
AppleTalk 58's `.DSP` runs against the ROM `.MPP`. **This is the biggest
open risk in the phase and should be re-probed before Task 9 is
dispatched, not during it.**

**Amendment 7 (Task 2, host LToUDP peer) — LLAP details worth building
to.** Each datagram on `239.192.76.84:1954` is `4-byte sender id` +
`LLAP frame`; both emulators sent a stable per-instance id. Node
acquisition is a burst of ~640 3-byte ENQ frames (`dst == src == tentative
node`, LLAP type `0x81`) inside ~180 ms — the host peer must ignore ENQ
for addresses it does not own and must not treat the burst as a flood.
All observed DDP was **short-header** (LLAP type 1), net 0, with no router
answering the RTMP-req broadcasts.

**No amendments** to Task 10 (nothing in the probe touched it).

---

## Housekeeping notes

- **`macplus2` is untracked in this worktree.** Spec §8.4 says
  "`/macplus2` is already in `.gitignore` (Andrew, 2026-09-07)", but on
  `appletalk-t1`'s base (`8068737`) `.gitignore` line 3 is `/macplus`
  only. `git status` therefore shows `?? macplus2`. I deliberately did
  not add the line — five worktrees editing `.gitignore` in the same wave
  is a needless conflict — but somebody should, before the wave merges.
- **`build-run/tools/resfork` cannot read System-file-era resource
  forks.** It aborts with `parse error: resource vers 2: attr byte =
  0x20, want 0`. `attr 0x20` is `resProtected`, perfectly legal. If any
  later task wants to inspect Apple's own resource files with it, that
  strictness has to be relaxed first. Not filed as debt — recorded here.
- **`progress.md` was appended to, not created.** The controller had
  already created the ledger in the main repo; this task added its own
  Task 1 row rather than overwriting a file another agent is actively
  editing. Only `task-1-report.md` is committed on this branch, for the
  same reason.
- Scratch deleted: `$SCRATCH/atprobe/`, and `build-68k/{Drivers,Register,
  Lookup,SelfSend,SelfNbp,SelfNbp3,SelfNbp4,SelfFlag,SelfAtp}`. No stray
  emulator processes were left running (`pgrep -lf minivmac` clean).

---

## P5 (Task 13c, 2026-09-07) — Snow / System 7 interop

Run from `/Users/andrew/repos/clarus-wt/t13` on branch `appletalk-t13`, two
Snow boots (the first without the LocalTalk bridge, the second with it),
each paired with one Mini vMac boot on `macplus/`. Probe programs were
throwaway Clarus, not trap-level: `p5snow.cla` (Snow) and `p5mac.cla`
(Mini vMac) used the shipped `service`/`listener`/`serviceBrowser` surface
for register and lookup, plus one `toolbox/appletalk.cla` call —
`setSelfSend`, csCode 256, on an `NBPParam` whose `interval`@28 /
`count`@29 are the same bytes as `newSelfFlag` / `oldSelfFlag`. Both
sources were deleted afterwards; everything they printed is below.

### The wire: Snow needs its LocalTalk bridge turned on by hand

**Snow's emulated LocalTalk is NOT on the LToUDP group by default, and
nothing outside its GUI can put it there.** First boot: the guest's own
AppleTalk was completely alive — `.MPP` open, NBP register with
verification `err 0`, `.DSP` open, node acquired — and *nothing* on the
host saw it. Nine `atalkdrive lookup` sweeps across the app's 45 s of life
returned zero tuples, and the Mini vMac peer found nothing either.

Snow v1.5.0-b81dbcc has exactly one way to bridge SCC channel B to
`239.192.76.84:1954`: **Ports → Channel B (printer) → Enable LocalTalk
(UDP)**, in the menu bar egui draws *inside* the window. Ruled out, each
measured:

- `--serial-bridge-b localtalk` / `ltoudp` / `udp` → `WARN snowemu::app
  Invalid serial bridge mode: '<v>'. Use 'pty' or 'tcp:PORT'`, then
  ignored.
- The `Workspace` serde field list in the binary (`…pram_path
  extension_rom_path disks scsi_targets windows init_args model
  scaling_algorithm pause_on_state_load shared_dir disassembly_labels
  floppy_images custom_datetime shader_enabled shader_configs
  ethernet_link_type`) has no serial-bridge field, so saving a `.snoww`
  cannot carry it. `Clarus.snoww` and Andrew's networked `MacII.snoww`
  are identical in this respect.
- `~/Library/Application Support/snowemu/Snow/settings.json` does not
  hold it either, so it does not survive a quit.
- PRAM cannot help: `clarus.pram` and `macii.pram` differ in only two
  bytes, `0x12` (`SPATalkB`, the AppleTalk node hint: 0x01 vs 0x16) and
  `0xBB`. `SPConfig`@0x13 is `0x21` in **both** — port B already
  `useATalk`. The guest side was never the problem.

`tests/lib_snow.sh` gained `snow_localtalk_b` for this: three CGEvent
clicks at fixed offsets from the Snow window's top-left corner (Ports
+250,+49; Channel B +310,+95; Enable LocalTalk +498,+184), armed in the
background before `snow_run` and verified against Snow's own
`LocalTalk bridge enabled` stdout line, dying loudly if it never arrives.
The real fix is a `--serial-bridge-b localtalk` flag upstream.

With the bridge on, the host saw the guest 35 s after Snow launched.

### Both directions

**Snow (System 7, node 1) → Mini vMac (System 6, node 16)** — the Snow
guest's own log, verbatim (`out`, after `##CLARUS-LOG##`):

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

**Mini vMac → Snow** — the LaunchAPPL capture, verbatim:

```
served MacP5:ClarusP5M
found SnowP5:ClarusP5S 0.1.252
done 1
stopped
```

**Host (`build-run/tools/atalkdrive`) → Snow**, both of the Snow guest's
names, verbatim:

```
0.1.252 SnowP5:ClarusP5S@*
0.1.251 SnowLsn:ClarusP5L@*
```

Both boots exited 0. The Snow node was `1` (the `SPATalkB` PRAM hint,
uncontested); the Mini vMac node was `16`. Net 0 and zone `*` on both, no
router — same routerless LocalTalk P2 saw.

### What System 7's AppleTalk does differently from the Mac Plus ROM

| | Mac Plus ROM (P1/P3) | System 7 / Snow (P5) |
|---|---|---|
| AppleTalk version | ROM `.MPP`, no Gestalt asked | Gestalt `'atlk'` err 0, **58** |
| `.XPP` / `.DSP` | `-43`, absent from the boot disk | **present** — `lsn.register` opens `.DSP`, gets a dynamic ADSP socket and NBP-advertises it (`SnowLsn:ClarusP5L` at socket **251**) |
| `setSelfSend` (csCode 256) | **`-17`** (controlErr) — not implemented | **`err 0`**, `oldSelfFlag 0` — implemented, and off by default |
| self-lookup | `gotten 0` before and after | **`0` before, `1` after** — `found p2 SnowP5:ClarusP5S 0.1.252`. System 7's `.MPP` answers its own NBP lookups once self-send is on |
| zone list, routerless | `["*"]` | `["*"]` — unchanged |
| own node number | dynamic, 106 / 18 seen | **1**, taken from the PRAM `SPATalkB` hint and never contested |

Amendment 3's reshaping of `AtalkSelf` therefore stands **for the Mini
vMac lane only**. On System 7 the original spec sketch (register, then
find your own name) works exactly as first imagined — provided
`setSelfSend` is called first. Nothing in this phase depends on that; it
is recorded for whoever writes a System 7 AppleTalk case later.
