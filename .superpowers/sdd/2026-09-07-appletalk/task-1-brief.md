### Task 1: Probe wave — Mac side (no tree commits except the ledger)

Per the established pattern (serial-connection Task 1): throwaway programs; the deliverable is a report with go/no-go findings and amendments to later tasks. Snow interop is NOT probed here (Task 13).

**Files:**
- Create: `.superpowers/sdd/2026-09-07-appletalk/progress.md`, `task-1-report.md`.
- Scratch (delete after): `$SCRATCH/atprobe/*.cla`, a python multicast sniffer.
- Read: `toolchain/universal/CIncludes/AppleTalk.h`, `ADSP.h` (CR-converted), `toolbox/devices.cla`, `testsuite/toolbox/cases_serial.cla` (trap-level PB idiom), `tests/lib_mac.sh:20-32` (`run_mac`), `tests/mactest/probe/FINDINGS.md` (report convention).

**Interfaces:**
- Produces: answers to probe questions P1–P4 below, recorded in `task-1-report.md`, each as "Result: X. Use it." plus the exact commands.

- [ ] **Step 1: P1 — `.DSP`/`.XPP` open on the LaunchAPPL boot disk**

Write `$SCRATCH/atprobe/drivers.cla`: a pure user program (declares its own `IOParam` extern record and `PBOpenSync`, copying `toolbox/devices.cla`'s shapes) that opens `.MPP`, `.ATP`, `.XPP`, `.DSP` in that order with `PBOpenSync` and writes one line per driver `NAME refnum=N err=E` to the file `out` (the LaunchAPPL echo channel, `tests/mactest/probe/FINDINGS.md`). Build with `scripts/build-68k.sh Drivers $SCRATCH/atprobe/drivers.cla`; boot with `toolchain/bin/LaunchAPPL -e minivmac build-68k/Drivers/Drivers.bin`. Expected: all four `err=0`; `.MPP` refnum −10, `.XPP` −41, `.DSP` some negative refnum. If `.DSP` fails, the LaunchAPPL stripped boot disk dropped the `AppleTalk` file: record what the stripped disk contains (`hls` on the temp image LaunchAPPL builds in cwd) and how to make it carry the file — this decides whether Tasks 9/11 need a custom boot image.

- [ ] **Step 2: P2 — NBP register on one Mac, lookup from the other, host sniffer sees both**

`register.cla`: opens `.MPP`, builds a packed `NamesTableEntry` (108 bytes via `NewPtrClear`: `qNext`@0, `nteAddress`@4 (4 bytes, zero), `filler`@8, then at @9 the packed entity: `[len]"Probe-<n>"` `[len]"ClarusProbe"` `[len]"*"`), `PBControlSync` with `csCode` 253 (`registerName`), `interval`@28 = 8, `count`@29 = 3, `ntQElPtr`@30 = the NTE, `verifyFlag`@34 = 1; writes `register err=E` to `out`, then idles 60 s (a `while TickCount() < deadline` loop) so the other Mac can look it up, then removes the name (csCode 252, `entityPtr`@30 pointing at the packed entity) and quits.
`lookup.cla`: opens `.MPP`, builds a packed entity `=` / `ClarusProbe` / `*`, `PBControlSync` csCode 251 (`lookupName`) with `entityPtr`@30, `retBuffPtr`@34 → a 1024-byte `NewPtrClear` buffer, `retBuffSize`@38 = 1024, `maxToGet`@40 = 16, `interval` 8, `count` 3; writes `lookup err=E gotten=N` and, per tuple in the buffer (tuple = `AddrBlock` 4 bytes, enumerator 1 byte, then three packed Pascal strings), `net.node.socket obj:type@zone`. Boot `register` on `macplus/` via the default LaunchAPPL config, and 5 s later `lookup` on `macplus2/` via `LaunchAPPL -e minivmac --minivmac-dir $ROOT/macplus2 --minivmac-path ./MacPlus2.app --system-image ./disk1.dsk --autoquit-image ./autoquit-1.1.1.dsk build-68k/Lookup/Lookup.bin` (from a different cwd, since LaunchAPPL makes its temp dir in cwd). Meanwhile run the sniffer: python3 joining `239.192.76.84:1954` (`IP_ADD_MEMBERSHIP`, `SO_REUSEPORT`), printing each datagram as hex with the 4-byte sender id, LLAP dst/src/type, and the DDP type byte. Expected: `gotten=1` naming `Probe-<n>` at the register Mac's node, and the sniffer shows LLAP type 1 (short DDP) frames with DDP type 2 (NBP) both ways. Record the exact bytes of one `LkUp` and one `LkUp-Reply` frame — Task 2's NBP encoder/decoder is written against them.

- [ ] **Step 3: P3 — self-lookup and `SetSelfSend`**

Extend `register.cla` (a variant) to look up its OWN name after registering, once without and once after a `setSelfSend` control (csCode 256, `newSelfFlag`@28 = 1) — record whether `gotten` is 0 or 1 in each case. Then an ATP self-transaction: `openATPSkt` (csCode 254, `atpSocket`@28 = 0, result socket in `atpSocket`), an async `getRequest` (`PBControlAsync` = trap `0xA404 reg`, csCode 253, `atpSocket`@28, `reqPointer`@36 → 600-byte buffer, `reqLength`@34 = 578), then a sync `sendRequest` (csCode 255, `addrBlock`@30 = own net/node from the `AddrBlock` of P2's own tuple with the ATP socket, `atpFlags`@29 = 32 (XO), `reqLength`@34, `reqPointer`@36, `bdsPointer`@40 → one 12-byte BDS entry over a 578-byte buffer, `numOfBuffs`@44 = 1, `timeOutVal`@45 = 2, `retryCount`@47 = 3), and before that a poll loop is impossible in one sync program — so instead: issue the async `getRequest`, then the sync `sendRequest`, and after it returns check the `getRequest` PB's `ioResult`@16 ≤ 0 and respond with `sendResponse` (csCode 252, `bdsPointer`@40, `numOfBuffs`@44 = 1, `transID`@46 = the request's `transID`@46). Record whether the sync `sendRequest` completes (it can only complete if the response was sent — so if `ioResult` stays 1 and `sendRequest` times out with −1096, self-transactions are not viable in one program and `AtalkSelf` (Task 6) is register + self-lookup only). This decides `AtalkSelf`'s shape.

- [ ] **Step 4: P4 — two-boot launcher**

From a POSIX sh script, start `register` on `macplus/` in the background (`run_mac`-style: `$TOOLS/timeout 120 LaunchAPPL ... > cap1 2> err1 &`), and `lookup` on `macplus2/` 5 s later in a different cwd, capture both stdouts, wait for both, and confirm (a) both windows appear on screen at once, (b) each `out` echo lands in its own capture, (c) `pkill -f MacPlus2.app` kills only the second instance (record the process names `pgrep -l` shows for each). This is the `run_mac_pair` helper's design input (Task 11).

- [ ] **Step 5: Write the report; create the ledger; clean up**

`task-1-report.md`: P1–P4 verdicts, the recorded frame bytes, the exact LaunchAPPL override command line that worked for `macplus2/`, timing (boot to first NBP packet), and explicit amendments (or "none") to Tasks 2, 6, 9, 10, 11. `progress.md` with the task table. Delete `$SCRATCH/atprobe`, `build-68k/Drivers`, `build-68k/Register`, `build-68k/Lookup`. `git status` must show only the ledger.

```bash
git add .superpowers/sdd/2026-09-07-appletalk/
git commit -m "docs(sdd): appletalk Task 1 probe report"
```

---

