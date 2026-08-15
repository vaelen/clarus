# Serial via `connection` Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the reference's fenced `connection` type real end to end, with the Macintosh serial ports as its first transport (`conn.open(serial "modem:9600")`), event-driven (`opened`/`received`/`closed`/`failed`), on both lanes — SCC via the Serial Driver natively, a TCP bridge on the host.

**Architecture:** A probe wave first proves Snow's SCC + `--serial-bridge` fidelity with a throwaway trap-level program. Then, in order: the Device Manager / Serial Driver toolbox catalog (hardware-proved by a Mini vMac suite case); the `serial` parse/check surface + reference text; a dormant shared runtime module (`conn.cla`) with host TCP glue; lowering (methods, slots, handlers, reverse-waist dispatchers) + the host CLI pump loop, closed by a host end-to-end echo test; the native lane (superset splice, UI-loop pump, one planned golden rebless wave); the `serialecho` acceptance app + gated Snow echo test; snapshot regen + docs close-out.

**Tech Stack:** Clarus (`clarusc/*.cla` compiler, `runtime/clarus/*.cla` runtime), C host glue (`runtime/host/*.inc`), Go test harness (`internal/*`), Mini vMac (suite lane) and Snow (`--serial-bridge-a tcp:PORT`) emulators, Universal Interfaces (`Retro68/InterfacesAndLibraries`) as the sole trap-verification source.

**Spec:** `docs/superpowers/specs/2026-08-15-serial-connection-design.md` — read it first; every task below argues from it.

## Global Constraints

- Branch: all work on `serial-connection` (created in Task 1 from `main`). Merge only on Andrew's explicit request; `main` stays green.
- After every task: `scripts/test-task.sh --smoke` (every task here touches `runtime/` or `clarusc/`; `--smoke` is mandatory per CLAUDE.md).
- Go tests always `-count=1`. `internal/selfhost` only at phase close, always `-count=1 -timeout 30m`.
- Emulator-gated tests need `CLARUS_MAC_TESTS=1`. Snow-gated tests (`CLARUS_SNOW_TESTS=1`) run only where a task explicitly says so; the standing `TestClarusCBakePathOnSnow` rerun happens once, at phase close, controller-run.
- Trap words, csCodes, config-word constants, and PB struct offsets are NEVER trusted from memory or this plan alone: verify each against `Retro68/InterfacesAndLibraries/` (`CIncludes/Devices.h`, `CIncludes/Serial.h`, `CIncludes/Files.h`, corroborate in `AIncludes/*.a`), decoding inline words per the `toolbox/files.cla` provenance-comment convention. Values in this plan are labeled *expected* — the probe (Task 1) and the sources are authoritative.
- Before editing any `.cla` file, check for non-ASCII bytes (`LC_ALL=C grep -nP '[\x80-\xff]' FILE`); if any, do NOT use the Edit tool — use `LC_ALL=C sed` and byte-diff (project memory rule).
- Golden policy: Tasks 2–5 must produce ZERO golden churn (new runtime code is dormant or host-conditional; if a golden churns, STOP and investigate). Task 6 contains the one PLANNED rebless wave (new superset module + dispatcher family); rebless there only with a normalization-diff proof that the churn is pure renumbering/addition, per house precedent.
- Commit after every task (prefix `feat:`/`fix:`/`test:`/`docs:`).

## File map (who owns what)

- `toolbox/devices.cla` (new) — Device Manager PB traps + `IOParam`/`CntrlParam` extern records (Task 2).
- `toolbox/serial.cla` (new) — serial driver names, csCodes, baud/format constants (Task 2).
- `testsuite/toolbox/cases_serial.cla` (new) + `testsuite/toolbox/runner.cla` — `SerialOpenWrite` case (Task 2).
- `clarusc/parse.cla`, `clarusc/check.cla`, `clarusc/ast.cla` — `serial` prefix, open-form validation (Task 3).
- `docs/clarus-language-reference.md` — serial open form, semantics, lifetime rule (Task 3).
- `runtime/clarus/conn.cla` (new, shared), `conn_c.cla` (new, host transport), `conn_68k.cla` (new, native transport) (Tasks 4, 6).
- `runtime/host/rt_serial.inc` (new) + `runtime/host/rt.c`/`rt.h` include wiring — host TCP glue (Task 4).
- `clarusc/drive.cla` — module splice (host-conditional Task 4; 68k superset Task 6). `scripts/build-clarusc-mac.sh` — `--bake` flags (Task 6).
- `clarusc/lower.cla` — receiver-kind-13 methods, slots, handler minting, `clar_conn_fire_*` dispatchers (Task 5).
- `clarusc/cprint.cla` — host CLI pump loop in `cpEmitMain` (Task 5). `clarusc/cg68k.cla` — reverse-waist extern-call arm + object-capture taint (Task 6).
- `runtime/clarus/ui.cla` — pump call in both loop paths (Task 6).
- `internal/conntest/` (new) — host end-to-end echo test (Task 5).
- `examples/serialecho.cla` (new) + `internal/mactest/serial_snow_test.go` (new) — acceptance (Task 7).
- `clarusc/clarusc.c`, `docs/ROADMAP.md`, `STATUS.md`, `docs/TODO.md` — close-out (Task 8).

---

### Task 1: Probe wave — Snow SCC + bridge fidelity (NO tree commits)

Per the established probe pattern (runtime-ir-bake Task 1): everything here is throwaway; the deliverable is a report + go/no-go + amendments to Tasks 2–7. Create the branch first: `git checkout -b serial-connection main`.

**Files:**
- Create (scratch only, delete before finishing): `/tmp/serprobe/serprobe.cla`, plus a scratch copy of the Snow launch machinery notes.
- Read: `internal/mactest/snow_test.go:333-370` (`runSnow` — note it currently execs `Snow <workspace>` with no extra args), `Retro68/InterfacesAndLibraries/CIncludes/{Devices.h,Serial.h,Files.h}`.

**Interfaces:**
- Produces: `task-1-report.md` in `.superpowers/sdd/2026-08-15-serial-connection/` recording (a) the VERIFIED trap words/offsets/constants table for Task 2, (b) bridge fidelity results, (c) any amendment to later tasks.

- [ ] **Step 1: Transcribe the minimum trap set from Universal Interfaces**

Open `CIncludes/Devices.h`, `CIncludes/Serial.h`, `CIncludes/Files.h`. Record, with header line numbers: `_Open`/`_Close`/`_Read`/`_Write`/`_Control`/`_Status`/`_KillIO` trap words (expected 0xA000/0xA001/0xA002/0xA003/0xA004/0xA005/0xA006, A0=pb D0=OSErr, OS convention); `IOParam` offsets (expected: ioCompletion@12, ioResult@16, ioNamePtr@18, ioVRefNum@22, ioRefNum@24:2, ioPermssn@27:1, ioBuffer@32, ioReqCount@36, ioActCount@40, ioPosMode@44:2); `CntrlParam` (csCode@26:2, csParam@28); serial csCodes (expected: SerReset control 8, SerSetBuf 9, SerHShake 10, SerGetBuf status 2, SerStatus status 8); the baud/format config constants (expected shape: `baud9600 10`, `data8 3072`, `noParity 8192`, `stop10 16384`); driver names `.AIn`/`.AOut`/`.BIn`/`.BOut` and their conventional refNums (-6/-7/-8/-9 — record what the headers actually say). ALL values go in the report as the verified table Task 2 transcribes from.

- [ ] **Step 2: Write the throwaway probe program**

`/tmp/serprobe/serprobe.cla` — pure user code (TickProbe precedent: user programs may declare traps themselves), no compiler changes: declare the PB extern records + `_Open`/`_Read`/`_Write`/`_Control`/`_Status` traps from Step 1's table; open `.AOut` then `.AIn`; `SerReset` with the 9600-8N1 config word; write `"SERPROBE-HELLO\n"`; then loop ~60s: poll `SerGetBuf`, `_Read` whatever is available, echo the bytes straight back out via `_Write`, and additionally echo each byte value `b` as `(b + 1) & 0xFF` on a second line ONLY for a distinguished 0x00–0xFF sweep marker — simplest is: echo verbatim; the Go-side check does the sweep. Quit on receiving the 4 bytes `QUIT`. Build natively: `scripts/build-68k.sh SerProbe /tmp/serprobe/serprobe.cla`.

- [ ] **Step 3: Boot it on Snow with the bridge and drive it by hand**

Clone the scratch-workspace machinery the way `TestSnowRoundTrip` does (or hand-run: copy `snow/Clarus.snoww` + `hdd0.img` clone + pram to a scratch dir with absolutized paths, `hcopy` the app in, set it as startup). Launch `snow/Snow <scratch.snoww> --serial-bridge-a tcp:1985` in the background. From the host: `nc 127.0.0.1 1985` (or a tiny Go scratch program) — confirm (a) the port accepts, (b) `SERPROBE-HELLO` arrives, (c) a full 0–255 byte sweep sent in echoes back byte-exact (binary safety), (d) sustained echo at 9600 works without drops, (e) `QUIT` quits the app cleanly. Also confirm `runSnow`-style launch tolerates the extra CLI arg (it must — plain argv append).

- [ ] **Step 4: Probe the failure modes the runtime will rely on**

While connected: kill the `nc` side — confirm the Mac side just sees silence (no error; informs the `closed`-never-fires-natively contract). Reconnect — confirm the bridge accepts a second TCP client after the first drops (report actual behavior; the Snow bridge's reconnect policy shapes the manual-test workflow, not the runtime).

- [ ] **Step 5: Write the report, clean up, no commits**

`task-1-report.md` with the verified-values table, each fidelity result, timing observations (how long from launch until the TCP port accepts — Task 7's connect-retry budget), and explicit amendments (or "none") to Tasks 2–7. Delete `/tmp/serprobe` and the scratch workspace. `git status` must be clean.

---

### Task 2: Toolbox catalog — `devices.cla` + `serial.cla`, hardware-proved

**Files:**
- Create: `toolbox/devices.cla`, `toolbox/serial.cla`
- Create: `testsuite/toolbox/cases_serial.cla`
- Modify: `testsuite/toolbox/runner.cla` (enum + dispatch + case count), `internal/mactest/coresuite_test.go` (toolbox TOTAL expectation — read the CURRENT literals first; the case count has drifted before, trust the file not this plan)
- Read first: `toolbox/files.cla` (provenance-comment convention, extern record shape), `toolbox/osutils.cla`, `testsuite/toolbox/cases_a5.cla` (suite-case shape), Task 1's verified table.

**Interfaces:**
- Produces (`toolbox/devices.cla`): `record IOPB` (extern record, IOParam layout) and `record CtlPB` (CntrlParam layout); `external func PBOpenSync(pb: IOPB): int = trap ...`, likewise `PBCloseSync`, `PBReadSync`, `PBWriteSync`, `PBControlSync(pb: CtlPB): int`, `PBStatusSync(pb: CtlPB): int`, `PBKillIOSync` — exact trap words from Task 1's table, OS/register convention (`reg`, pb in A0, OSErr in D0).
- Produces (`toolbox/serial.cla`): constants `serReset`/`serSetBuf`/`serHShake`/`serGetBuf`/`serStatus` (csCodes) and `baud300`…`baud57600`, `data8`, `noParity`, `stop10` (config words) as `const int`s, plus doc comments naming the four driver strings `.AIn`/`.AOut`/`.BIn`/`.BOut`.
- Consumed by: `conn_68k.cla` (Task 6) and the suite case below.

- [ ] **Step 1: Write `toolbox/devices.cla`**

Transcribe from Task 1's verified table with the full provenance-comment convention (`CIncludes/Devices.h:<lines>`, decoded inline words, `AIncludes` corroboration) — one comment block per declaration, mirroring `toolbox/files.cla`'s style, including the trailing-pad treatment for unused struct tail fields. Declare only the sync PB forms (spec: no async this phase).

- [ ] **Step 2: Write `toolbox/serial.cla`**

Constants + doc comments per the Interfaces block; provenance from `CIncludes/Serial.h`. Include a worked doc-comment example composing the 9600-8N1 config word (`baud9600 + data8 + noParity + stop10`).

- [ ] **Step 3: Check-compile the catalog**

Run: `scripts/clarus-run.sh --help >/dev/null 2>&1 || true` — then the real gate: `go test ./internal/testsuite -run TestCatalog -count=1 -v` (the existing T1 catalog check; read `internal/testsuite/catalog_test.go` first and add the two new files to whatever file list it checks).
Expected: PASS with both new files included.

- [ ] **Step 4: Write the `SerialOpenWrite` suite case**

`testsuite/toolbox/cases_serial.cla`, following `cases_a5.cla`'s structure. The case: include `../../toolbox/devices.cla` + `../../toolbox/serial.cla` (match how other cases reach the catalog — read `cases_catalog.cla` first and copy its include idiom); open `.AOut` (PBOpenSync, `ioPermssn = 0`), open `.AIn`; SerReset the output driver with the 9600-8N1 word; PBWriteSync 5 bytes (`"HELLO"`) to `.AOut` and assert `ioActCount == 5` and OSErr 0; SerGetBuf on `.AIn` and assert 0 bytes waiting (nothing attached); PBCloseSync `.AIn` (input driver only — leave `.AOut` open, classic discipline: closing the output serial driver is not required and input-close is the documented disable step; cite IM II in the comment); return pass. Register it in `runner.cla` (enum member `SerialOpenWrite`, dispatch arm, bump `nTbCases` and the header count comment by one).

- [ ] **Step 5: Hardware-prove it on the Mini vMac lane**

Run: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestToolboxSuiteOn68k -count=1 -v` (after updating `coresuite_test.go`'s toolbox TOTAL expectation).
Expected: PASS, with the new `SerialOpenWrite` subtest green — this is the catalog's real hardware proof, no bridge needed.

- [ ] **Step 6: T1 + commit**

Run: `scripts/test-task.sh --smoke`. Expected: PASS, zero golden churn (nothing outside `toolbox/`/`testsuite/` changed).
```bash
git add toolbox/devices.cla toolbox/serial.cla testsuite/toolbox/ internal/mactest/coresuite_test.go
git commit -m "feat: Device Manager + Serial Driver toolbox catalog, hardware-proved by SerialOpenWrite"
```

---

### Task 3: Surface — `serial` prefix, checker, reference

**Files:**
- Modify: `clarusc/parse.cla` (~line 110 contextual words, `parseArgs` ~line 606, and the call-node flag stash — read `parseArgsAppleTalk`'s doc comment at ~line 54 and `ast.cla:52`'s `intVal=appletalk flag (0/1)` note first)
- Modify: `clarusc/ast.cla` (the flag comment: 0/1 becomes 0/1/2)
- Modify: `clarusc/check.cla` (`connectionMethods["open"]` validation, ~line 1488; the `checkTableMethod` path at ~1907)
- Modify: `docs/clarus-language-reference.md` (Chapter 12 Connections)
- Create: `testdata/errors/conn_serial_badarg.cla` + `.err` golden
- Read first: how `testdata/errors` goldens are generated/asserted (`internal/selfhost` reads them at T2, but the error-golden harness that runs at T1 — find it via `grep -rn "testdata/errors" internal/ | head`).

**Interfaces:**
- Produces: call-argument transport tag on the open call's AST node — `0` none, `1` appletalk, `2` serial (extends the existing 0/1 `intVal` flag; name the parser stash `parseArgsTransport`, retiring the bool `parseArgsAppleTalk` in place — update its consumers, found via `grep -n parseArgsAppleTalk clarusc/*.cla`). Checker rule: `serial` prefix legal ONLY on `connection.open` with exactly one `string`-typed argument; anywhere else → the same diagnostic shape the appletalk misuse produces today (find it: `grep -n appletalk clarusc/check.cla`).
- Consumed by: Task 5's lowering (reads the tag off the call node).

- [ ] **Step 1: Parser — recognize `serial`**

In `parse.cla`: intern `cwSerial` next to `cwAppletalk` (~line 110); in `parseArgs` (~line 617), accept either contextual word (`cwAppletalk` → tag 1, `cwSerial` → tag 2) under the same `isPrimaryStart(peekKind())` disambiguation; stash the int tag in `parseArgsTransport`. Update the flag's consumers and `ast.cla`'s comment (tag 0/1/2).

- [ ] **Step 2: Checker — validate the serial open form**

In `check.cla`, where the appletalk flag is validated today: tag 2 follows the same rule as tag 1 (only on `connection.open`, one `string` arg). No new type enters the arena — the tag is syntax.

- [ ] **Step 3: Error fixture**

`testdata/errors/conn_serial_badarg.cla`:
```rust
var conn: connection

on App.launch {
    conn.send(serial "oops")
}
```
Generate/bless its `.err` golden per the harness's convention; assert the diagnostic names the misplaced transport prefix.

- [ ] **Step 4: Reference — Chapter 12 Connections**

Add to the open row: `c.open(serial "modem:9600")` — serial port, `"modem"`/`"printer"`, baud after the colon. Add a short "Serial" subsection stating, per spec §3: the supported baud set (300, 600, 1200, 1800, 2400, 3600, 4800, 7200, 9600, 19200, 57600), fixed 8N1 no-handshake framing (Toolbox catalog is the escape hatch); `opened` fires on the next event-loop pass, not inside `open`; `received(data: text)` delivers raw bytes, binary-safe, once per pass; `closed` fires only when the underlying channel goes away — never for a raw Mac serial line in this release (no carrier detect), and a local `close()` never fires it; `send` on a never-opened/closed connection is a runtime error while environmental failures arrive as `failed(err)`; the host-lane TCP mapping (`CLARUS_SERIAL_MODEM`/`CLARUS_SERIAL_PRINTER` = `listen:PORT`/`connect:HOST:PORT`, baud ignored); the command-line lifetime rule (program stays alive after `App.startCLI` while a connection is open or an event is pending); and the cooperative constraint (a long-running handler starves the pump; the runtime buffers 8KB of input against it). Add one ```rust fence exercising the serial form (a compact echo shape: open in `App.startCLI`, echo in `received`, `quit` on a `Q` byte) — it must check clean, extending the reftest manifest per that file's convention (`internal/reftest/manifest.go` — read its header comment for how new fences are added).

- [ ] **Step 5: T1 + commit**

Run: `scripts/test-task.sh --smoke`. Expected: PASS; reftest green with the new fence; zero golden churn (parser/checker additions are inert for programs that don't use them — if any emitui/cg68k golden churns, STOP).
```bash
git add clarusc/parse.cla clarusc/ast.cla clarusc/check.cla testdata/errors/ docs/clarus-language-reference.md internal/reftest/manifest.go
git commit -m "feat: serial transport prefix parses and checks; reference documents the serial connection form"
```

---

### Task 4: Dormant runtime — `conn.cla`, host TCP glue, host-conditional splice

Everything lands compilable and spliced (host lane, usage-gated) but nothing calls it yet — lowering arrives in Task 5. Deliverable: T1 green, byte-zero golden churn, glue unit-provable.

**Files:**
- Create: `runtime/clarus/conn.cla`, `runtime/clarus/conn_c.cla`
- Create: `runtime/host/rt_serial.inc`; Modify: `runtime/host/rt.c` (include it — read how `rt_ser.inc` is included and mirror), `runtime/host/rt.h` if a prototype is needed
- Modify: `clarusc/drive.cla` (~line 1491, next to the datetime splice block), `clarusc/check.cla` (a `usesConn` usage flag — find the existing `usesSortedMap` flag via grep and mirror its plumbing end to end)
- Read first: `runtime/clarus/datetime.cla` + `datetime_c.cla` (lane-split convention, `Dt`-prefixed externs), `runtime/host/rt_ext_host.inc:389-405` (`rt_ext_Dt*` glue naming), `runtime/clarus/ser.cla`'s header comment (why runtime externs carry a family prefix).

**Interfaces:**
- Produces (`conn.cla`, all shared): `rtConnOpen(slot: int, transport: int, spec: string)`, `rtConnSendText(slot: int, t: text)`, `rtConnSendStr(slot: int, s: string)`, `rtConnClose(slot: int)`, `rtConnPump()`, `rtConnAlive(): bool`. Constants: `rtConnMax = 4` slots; transport tag `2` = serial (matching Task 3's parse tag; tag values 0/1 are structurally unreachable here this phase). Per-slot state: `stClosed = 0` / `stOpen = 1`, plus pending-event fields (`pendOpened: bool`, `pendFailedCode: int`, `pendFailedMsg: string` per slot — at most one open result can be pending per slot, so fields, not a queue).
- Produces (reverse-waist externs declared IN `conn.cla`, bodies synthesized by Task 5): `external func clar_conn_fire_opened(slot: int)`, `clar_conn_fire_received(slot: int, data: text)`, `clar_conn_fire_closed(slot: int)`, `clar_conn_fire_failed(slot: int, code: int, msg: string)` — mirror how `ui.cla` declares its `clar_ui_fire_*` externs.
- Produces (per-lane waist, implemented in `conn_c.cla` now, `conn_68k.cla` in Task 6 — same names, one file spliced per lane, the `rtNow` precedent): `rtConnDevOpen(slot: int, portIdx: int, baud: int): int` (0 ok / OSErr-or-errno), `rtConnDevAvail(slot: int): int`, `rtConnDevReadByte(slot: int): int` (next byte 0–255; only called when avail > 0), `rtConnDevWrite(slot: int, p: ptr, n: int): int`, `rtConnDevClose(slot: int)`, `rtConnDevGone(slot: int): bool` (peer closed underneath — host TCP only; native returns false).
- Produces (`rt_serial.inc` C glue, extern-declared in `conn_c.cla` with the `ConnH` family prefix per `ser.cla`'s collision rule): `rt_ext_ConnHOpen(int32_t slot, int32_t portIdx)`, `rt_ext_ConnHAvail`, `rt_ext_ConnHReadByte`, `rt_ext_ConnHWrite(slot, void* p, int32_t n)`, `rt_ext_ConnHClose`, `rt_ext_ConnHGone`, `rt_ext_ConnHIdle(int32_t ms)` (select()-style sleep across open fds — Task 5's host pump loop uses it so the CLI doesn't spin).
- Consumed by: Task 5 (lowering routes methods here; cprint pump loop calls `rtConnAlive`/`rtConnPump`), Task 6 (`conn_68k.cla` implements the same waist natively).

- [ ] **Step 1: Write `rt_serial.inc`**

C, mirroring `rt_ext_host.inc`'s style: a 4-slot fd table; `rt_ext_ConnHOpen` reads `CLARUS_SERIAL_MODEM` (portIdx 0) / `CLARUS_SERIAL_PRINTER` (portIdx 1) — `listen:PORT` binds+listens (nonblocking, accept deferred to the avail poll), `connect:HOST:PORT` connects (blocking connect is fine — open happens once), unset/garbled returns a nonzero errno-ish code; `rt_ext_ConnHAvail` accepts a pending client if listening, then `ioctl(FIONREAD)`; `rt_ext_ConnHReadByte` reads one byte (only called when avail said >0); `rt_ext_ConnHWrite` loops `send()` to completion; `rt_ext_ConnHGone` detects orderly peer close (recv peek returning 0); `rt_ext_ConnHIdle` is `select()` with an ms timeout over open fds (or plain `usleep` when none). Include it from `rt.c` exactly the way `rt_ser.inc` is included.

- [ ] **Step 2: Write `conn_c.cla`**

Extern declarations for the seven glue functions (`ConnH` prefix), plus the six `rtConnDev*` waist functions delegating to them. Port-spec parsing does NOT live here — `conn.cla` owns it.

- [ ] **Step 3: Write `conn.cla`**

Shared logic: `rtConnOpen` parses `spec` (`"modem"`/`"printer"` before the colon → portIdx 0/1; baud after it, validated against the eleven-rate set; parse or validation failure → set `pendFailedCode`/`Msg`, no device touch) then calls `rtConnDevOpen`; success → `pendOpened = true`, state `stOpen`; device error → pending failed. Reopen of an open slot → pending failed (spec §3). `rtConnSendText`/`SendStr`: state != `stOpen` → `rtPanic("connection not open")`; else marshal bytes and `rtConnDevWrite` (for the text form, copy through a fixed scratch buffer; read how `ser.cla` moves bytes to externs and reuse that idiom). `rtConnClose`: idempotent; `rtConnDevClose` + state `stClosed`; does NOT fire `closed`. `rtConnPump()`: per slot — drain pending (`clar_conn_fire_failed` then return to closed state, or `clar_conn_fire_opened`); if open and `rtConnDevGone` → close device, state closed, `clar_conn_fire_closed`; else while `rtConnDevAvail() > 0`, build a fresh `text` of everything available (`t.append(char(rtConnDevReadByte(slot)))` loop — per-byte is fine at serial rates; leave a `ponytail:` comment naming the bulk lever) and `clar_conn_fire_received(slot, t)`. `rtConnAlive()`: any slot open or any pending event.

- [ ] **Step 4: Splice, usage-gated on the host lane**

In `check.cla`: set `usesConn` when any global declares type `connection` (mirror `usesSortedMap`'s plumbing exactly — declaration site, reset site, and the drive-visible accessor). In `drive.cla` next to the datetime block (~1491): non-68k lanes add `conn.cla` + `conn_c.cla` only when `usesConn`; the 68k superset does NOT change yet (Task 6). This keeps every existing build byte-identical.

- [ ] **Step 5: Prove the glue standalone**

`runtime/host` has standalone C test files (`rt_ser_test.c`, `rt_mem_test.c`) — read one, then add `rt_serial_test.c`: spawn a listener via the glue (env var set in-process with `setenv`), connect a plain BSD socket to it, push 256 bytes each way through `ConnHWrite`/`ConnHReadByte`, assert `ConnHGone` after closing the client end. Wire it into whatever runs the sibling tests (find via `grep -rn rt_ser_test internal/ scripts/ Makefile* 2>/dev/null`) — if the siblings are run by a Go package, add it there; if hand-run, document the compile-and-run line at the top of the file and run it now.

- [ ] **Step 6: T1 + zero-churn check + commit**

Run: `scripts/test-task.sh --smoke`. Expected: PASS. Then confirm byte-identity for a non-conn program: `build-run/clarusc emit --rtdir runtime/clarus/ -o /tmp/before_after.c testdata/run/lib/hello.cla` style — pick any existing fixture, emit at HEAD~ vs working tree, `cmp` identical (the splice is usage-gated, so nothing changes).
```bash
git add runtime/clarus/conn.cla runtime/clarus/conn_c.cla runtime/host/ clarusc/drive.cla clarusc/check.cla
git commit -m "feat: dormant connection runtime -- shared conn.cla, host TCP glue, usage-gated splice"
```

---

### Task 5: Lowering + host pump loop + host end-to-end echo

The heart: connection programs compile and RUN on the host lane.

**Files:**
- Modify: `clarusc/lower.cla` (the receiver-kind-13 rejection site at ~line 1277; handler minting — find where `on` decls become handler IRFuncs via `grep -n "handler" clarusc/lower.cla | head -30` and read that region; dispatcher synthesis next to `lowSynthUiDispatchers` ~6186 and `lowSynthFireWinEvent` ~6363; `lowSynthAppLog` ~6866 is the guard-global precedent)
- Modify: `clarusc/cprint.cla` (`cpEmitMain`, ~7280)
- Create: `internal/conntest/conntest_test.go`, `internal/conntest/testdata/echo.cla`
- Create: `testdata/runerr/conn_send_closed.cla` + goldens (host-only pinning, the `stringat_oor` convention)

**Interfaces:**
- Consumes: Task 3's transport tag; Task 4's `rtConn*` runtime surface and `clar_conn_fire_*` extern names (must match EXACTLY — `clar_conn_fire_opened(slot)`, `clar_conn_fire_received(slot, data)`, `clar_conn_fire_closed(slot)`, `clar_conn_fire_failed(slot, code, msg)`).
- Produces: slot assignment — lowering enumerates global vars of connection type in declaration order; slot = index; more than 4 → build error naming the limit. `conn.open(serial "spec")` → `rtConnOpen(slot, 2, spec)`; other transports/receivers (arrays, fields, locals, non-serial tags) → the existing `lowUnsupported` not-yet-implemented diagnostic, EXACTLY as today (fences must stay check-only-clean and emit-rejected). `conn.send(x)` → `rtConnSendText`/`rtConnSendStr` by arg type; `conn.close()` → `rtConnClose(slot)`. `on <connvar>.<event>` handler bodies become ordinary handler IRFuncs (whatever naming the existing minting path produces); the four `clar_conn_fire_*` dispatchers are synthesized as if-chains over slots (the `lowSynthFireWinEvent` shape) — synthesized ONLY when `usesConn` (host lane stays churn-free for conn-less programs; unconditional synthesis would churn every golden — that is Task 6's planned wave, not this one. NOTE: this means Task 6 must revisit synthesis unconditionality for the 68k superset; the report must carry that note forward). `irUsesConn` exported for cprint.
- Produces (cprint): non-UI `main` gains, after the startCLI/startEmpty dispatch and before `return 0`, when `irUsesConn`:
```c
    while (clar_fn_rtConnAlive()) {
        clar_fn_rtConnPump();
        rt_ext_ConnHIdle(20);
    }
```
(match the emitted-name mangling `cpEmitMain` actually uses for runtime Clarus functions — read how it spells `clar_fn_handler_App_startCLI` and mirror for `rtConnAlive`/`rtConnPump`.)

- [ ] **Step 1: Failing fixture first**

`internal/conntest/testdata/echo.cla`:
```rust
var conn: connection

on App.startCLI(args: list of string) {
    conn.open(serial "modem:9600")
}

on conn.opened {
    conn.send("READY\n")
}

on conn.received(data: text) {
    var i: int = 0
    var quit3: int = 0
    conn.send(data)
    while i < data.length {
        if data[i] == 'Q' { quit3 = quit3 + 1 } else { quit3 = 0 }
        if quit3 == 3 { conn.close() }
        i = i + 1
    }
}

on conn.closed {
    log("peer gone")
}

on conn.failed(err: error) {
    log("failed: " + err.message)
    quit 1
}
```
Run `scripts/clarus-run.sh internal/conntest/testdata/echo.cla` — Expected: FAIL with today's `unsupported construct: method call on receiver kind 13`.

- [ ] **Step 2: Lower methods + handlers + dispatchers**

Implement the Interfaces block above. Order of work inside `lower.cla`: (a) slot table from global decls; (b) method arm at the kind-13 rejection site (open/send/close; everything else keeps the existing rejection); (c) handler minting for the four events (follow the window-event minting path); (d) the four dispatchers under `usesConn`, if-chains over declared handlers with an empty fall-through (a slot with no handler for that event is a no-op, not a panic — `received` with no handler just drops the text). `err: error` is the inline record `{code, message}` — build the record value in the `failed` dispatcher from the two scalar params (find how the checker laid out `error`/`ErrTIndex` and construct accordingly).

- [ ] **Step 3: cprint pump loop**

Per the Interfaces block; UI-lane `cpEmitUiMain` is untouched (native/UI pump is Task 6).

- [ ] **Step 4: Host end-to-end echo test**

`internal/conntest/conntest_test.go`: build the echo fixture with the snapshot-bootstrapped compiler + `cc` (copy the compose recipe from `internal/mactest/suite_host_test.go`'s host-CLI build helpers — same bootstrap, same `-I runtime/host` link); start a `net.Listener` on 127.0.0.1:0; run the binary with `CLARUS_SERIAL_MODEM=connect:127.0.0.1:<port>`; assert in order: `READY\n` arrives (opened fired); a 0–255 sweep written in comes back byte-exact (binary-safe received/send); a second write also echoes (multiple received firings); send `QQQ` → connection closes from the program side and the process EXITS 0 on its own (lifetime rule: close leaves nothing open → `rtConnAlive` false → main returns). Add a second subtest: `listen:` mode — program listens, test dials, same sweep. And a third: env var unset → process exits 1 with `failed:` on stderr (the `failed` route).
Run: `go test ./internal/conntest -count=1 -v`. Expected: PASS.

- [ ] **Step 5: send-before-open runerr fixture**

`testdata/runerr/conn_send_closed.cla` — a `startCLI` body calling `conn.send("x")` with no open; expect the `connection not open` panic. Bless its goldens per the host-only convention (`stringat_oor` precedent — `internal/selfhost/behavior_test.go` auto-discovers the glob at T2; generate the `.behavior`/`.err` files the way that harness's header comment documents).

- [ ] **Step 6: T1 + zero-churn + commit**

Run: `scripts/test-task.sh --smoke`. Expected: PASS, and STILL zero golden churn (dispatchers/pump are `usesConn`/`irUsesConn`-gated; conn-less emission is byte-identical — spot-check one fixture with `cmp` as in Task 4 Step 6).
```bash
git add clarusc/lower.cla clarusc/cprint.cla internal/conntest/ testdata/runerr/
git commit -m "feat: connection lowering + host pump loop; host serial echo runs end to end"
```

---

### Task 6: Native lane — `conn_68k.cla`, superset splice, UI pump, the planned rebless wave

**Files:**
- Create: `runtime/clarus/conn_68k.cla`
- Modify: `clarusc/drive.cla` (68k superset module list — the same block Task 4 touched; also the CLFS/manifest list if separate — find every place `datetime_68k.cla` appears in `clarusc/*.cla` and `scripts/build-clarusc-mac.sh` and mirror ALL of them), `scripts/build-clarusc-mac.sh` (`--bake` flags)
- Modify: `runtime/clarus/ui.cla` (pump call in the real loop and the scripted loop — grep `rtUiEveryPump()` call sites, add `rtConnPump()` beside each)
- Modify: `clarusc/lower.cla` (dispatcher synthesis becomes unconditional under `want68k` — the superset carries `conn.cla`, whose `clar_conn_fire_*` externs must resolve in every native build; keep host-lane synthesis `usesConn`-gated as landed in Task 5)
- Modify: `clarusc/cg68k.cla` (reverse-waist extern-call handling + object-capture taint: find `cgCallExtUi` and the taint site in `cgObjDumpSegment`, extend both to the `clar_conn_fire_` prefix)
- Rebless: `testdata/cg68k/*.s`, `testdata/emitui/*.c.golden`, and any frozen-scenario goldens that churn
- Read first: `runtime/clarus/datetime_68k.cla`, `toolbox/` catalog from Task 2, the object-code-linker HISTORY entry's taint-and-discard paragraph.

**Interfaces:**
- Consumes: Task 2's catalog (include it from `conn_68k.cla` the way runtime modules include toolbox files — check how `osutils.cla` is reached by runtime code, or declare the traps with the module's own `Conn`-prefixed twins per `ser.cla`'s collision rule if runtime modules can't include catalog files; READ `drive.cla`'s manifest/nested-include handling first and follow what `toolbox/files.cla`'s existing consumers do), Task 4's waist signatures (implement all six `rtConnDev*` natively).
- Produces: native serial. `rtConnDevOpen`: PBOpenSync `.AOut` then `.AIn` (portIdx 0) / `.BOut`+`.BIn` (portIdx 1), stash both refNums in per-slot arrays; SerReset the OUTPUT driver with the config word built from the baud + `data8 + noParity + stop10` (per the reference: input driver inherits — verify against Serial.h's comment and do what it says, resetting both if the header says both); SerSetBuf an 8KB NewPtr'd buffer on `.AIn` (spec §6 overflow mitigation). `rtConnDevAvail`: SerGetBuf via PBStatusSync on the input refNum. `rtConnDevReadByte`: PBReadSync 1 byte (or maintain a small drain buffer — simplest correct thing; per-byte PBRead at serial rates is acceptable, leave the `ponytail:` ceiling comment). `rtConnDevWrite`: PBWriteSync. `rtConnDevClose`: PBCloseSync the INPUT driver only (Task 2's discipline). `rtConnDevGone`: `false` always (no carrier detect — spec §3).

- [ ] **Step 1: Write `conn_68k.cla`** per the Interfaces block.

- [ ] **Step 2: Wire the 68k superset + bake list + UI pump + cg68k arms**

All four modify-sites above. The superset list, the `--bake` flag list, and any CLFS name list must ALL gain the new modules or `ClarusC.APPL` breaks — the mac-resident HISTORY entry's `rtModuleKey` lesson; grep is the tool, `datetime_68k.cla` is the tracer.

- [ ] **Step 3: The planned rebless wave**

Re-emit the native goldens; produce a normalization diff proving the churn is exactly: new runtime module code/globals, renumbered pool literals, the four new dispatcher IRFuncs, and the `rtConnPump()` call sites — no unexplained opcode changes in untouched functions. Then rebless (`CLARUS_MAC_BLESS=1` for scenario goldens if they churn; direct regeneration for `.s`/`.c.golden` per each harness's convention). If anything outside that taxonomy churns, STOP and investigate.

- [ ] **Step 4: Emulator gates**

Run: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestCoreSuiteGUIOn68k|TestToolboxSuiteOn68k|TestSmokeBounceOn68k|TestRealEventLoopTickOn68k|TestUiScenariosOn68k' -count=1`.
Expected: all PASS (conn machinery is dormant in every one of these programs — the pump runs, finds no slots open, does nothing).

- [ ] **Step 5: T1 + commit**

Run: `scripts/test-task.sh --smoke`. Expected: PASS.
```bash
git add runtime/clarus/conn_68k.cla runtime/clarus/ui.cla clarusc/ scripts/build-clarusc-mac.sh testdata/
git commit -m "feat: native serial transport -- superset splice, UI-loop pump, reverse-waist conn dispatchers"
```

---

### Task 7: Acceptance — `examples/serialecho.cla` + gated Snow echo test

**Files:**
- Create: `examples/serialecho.cla`
- Create: `internal/mactest/serial_snow_test.go`
- Read first: `internal/mactest/snow_test.go` (`newSnowDisk`/`runSnow` — the scratch-workspace clone machinery to reuse; `runSnow` needs an optional extra-args way through — smallest change wins), Task 1's report (port-accept timing budget).

**Interfaces:**
- Consumes: everything. Produces: the phase's acceptance artifacts.

- [ ] **Step 1: Write the acceptance app**

`examples/serialecho.cla` — a small UI app: window `Echo` with two labels (bytes in / bytes out counters) and a Quit-able File menu; `on App.launch` opens `serial "modem:9600"`; `on conn.opened` sends `"READY\n"`; `on conn.received` echoes and updates counters; three consecutive `Q` bytes → `quit`; `on conn.failed` alerts the message. Keep it Appendix-C-plain — this doubles as the manual demo Andrew connects a terminal to (port 1984 convention).

- [ ] **Step 2: The gated Snow test**

`internal/mactest/serial_snow_test.go`, `TestSerialEchoOnSnow`, gated `CLARUS_SNOW_TESTS=1`: build `serialecho` via `scripts/build-68k.sh` (no `--events` — the REAL event loop must pump the connection; that's part of what this test proves); stage it startup-booting on a `newSnowDisk` clone; launch Snow with `--serial-bridge-a tcp:<free port>`; dial with retry until accept (budget from Task 1's report, generous timeout); assert `READY\n`, then the 0–255 sweep echo byte-exact, then a second sweep (sustained), then `QQQ` → app quits cleanly (reuse the existing done-detection/quit machinery `runSnow` provides). 
Run it once now: `CLARUS_SNOW_TESTS=1 go test ./internal/mactest -run TestSerialEchoOnSnow -count=1 -v -timeout 30m`.
Expected: PASS — this is the spec's acceptance gate.

- [ ] **Step 3: T1 + commit**

Run: `scripts/test-task.sh --smoke`. Expected: PASS.
```bash
git add examples/serialecho.cla internal/mactest/serial_snow_test.go
git commit -m "feat: serialecho acceptance app + gated Snow serial echo test"
```

---

### Task 8: Close-out — snapshot regen, selfhost, docs

**Files:**
- Modify: `clarusc/clarusc.c` (regen), `docs/ROADMAP.md`, `STATUS.md`, `docs/TODO.md`
- Read first: `internal/selfhost/fixedpoint_test.go`'s regeneration instructions.

- [ ] **Step 1: Snapshot regen to a Go-free fixed point**

Per the fixed-point test's own printed instructions (stage-1 from committed snapshot → emit gen1 → cc → emit gen2 → `cmp` identical; converge and re-verify once more).

- [ ] **Step 2: Full selfhost gate**

Run: `go test ./internal/selfhost -count=1 -timeout 30m`. Expected: PASS including `TestSnapshotFixedPoint` (and the new runerr fixture's behavior golden via its glob).

- [ ] **Step 3: T2**

Run: `scripts/test-merge.sh` (foreground, capture the log to the SDD workspace). Expected: PASS.

- [ ] **Step 4: Docs**

`STATUS.md` rewritten as the phase handoff; `docs/ROADMAP.md`: mark the serial item done in "Next: language usability"; `docs/TODO.md`: record this phase's deferrals verbatim from the task reports (expected at minimum: per-byte read path ceiling + bulk lever; no carrier detect; Snow-bridge reconnect behavior note from Task 1; host `every`-timer pump gap; anything a review deferred). Commit.

- [ ] **Step 5: Report the two controller-run finals**

NOT this task's job to run: the standing-rule `TestClarusCBakePathOnSnow` rerun (the runtime manifest changed) and a final `TestSerialEchoOnSnow` at the true tip — the controller runs both post-final-review, then the phase is merge-eligible on Andrew's word. State this explicitly in `STATUS.md`.

---

## Self-review notes (spec coverage)

- Spec §3 surface → Tasks 3 (syntax/reference), 5 (semantics: deferred `opened`, error principle, lifetime rule). Baud set, env vars, binary safety all pinned by the Task 5 test.
- Spec §4 architecture → Tasks 2 (catalog), 4 (shared runtime + host glue + cprint-lane stub *by construction*: the Retro68/cprint Mac lane never splices `conn_c.cla`'s TCP glue — `rt_ext_mac.inc` gains nothing, so an open there fails to link only if used; since that lane builds only suite/scenario programs that never use connections, no stub code is actually required — recorded here so the implementer doesn't invent one), 5 (lowering/dispatchers/pump), 6 (native + superset + rebless + Snow standing-rule flag).
- Spec §5 testing → Tasks 2 (SerialOpenWrite), 5 (host echo incl. sweep/lifetime/failed), 3+5 (fixtures), 7 (Snow echo + manual app), 8 (T2 + finals).
- Spec §6 risks → Task 1 (fidelity probe), Task 6 SerSetBuf 8KB, Task 8 TODO recording.
- Spec §7 out-of-scope → enforced by Task 5's "everything else keeps the existing rejection".
