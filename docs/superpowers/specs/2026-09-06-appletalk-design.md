# AppleTalk: discovery, RPC, and streams via `connection` — design

Brainstormed with Andrew 2026-09-06. Second phase of the "language
usability" networking arc (serial → **AppleTalk** → MacTCP, driving
toward a BBS server). Approved section by section in-chat; this
document is the written record. Sources: *Inside AppleTalk*, 2nd ed.
(1990) for protocol semantics; *Inside Macintosh: Networking* (1994)
and *Inside Macintosh* Volumes II/V/VI for the Macintosh API (csCodes,
parameter-block offsets).

## 1. Problem

A Clarus program cannot see the network. The reference already
specifies the shape (`connection.open(appletalk "Name:Type")`,
`listener.register(name, type)`, `serviceBrowser.find(type)`,
`address`), and the checker types all of it, but lowering rejects every
use with `unsupported construct: method call on receiver kind 13/14/15`
and no runtime exists. There is also no request/response facility of
any kind. The phase delivers, on real LocalTalk (Mini vMac and Snow,
both LocalTalk-over-UDP) and on the host:

- **Service discovery**: list zones, list every registered entity in a
  zone (the only "node listing" AppleTalk has), find services by type.
- **Request/response services** (a new `service` resource): a server
  advertises an NBP name and answers integer-coded operations; a client
  calls them synchronously.
- **Stream services**: ADSP as `connection`'s second transport, with
  `listener` accepting incoming streams.
- The two serial items recorded in `docs/TODO.md`: host `stdio`/`pty`
  transports and `every` timers in the host CLI pump.

## 2. Findings that shaped the design

- Every AppleTalk call is `_Control` with a csCode on one of four
  drivers: `.MPP` (DDP, NBP, AEP), `.ATP`, `.XPP` (ZIP zone calls, ASP
  client), `.DSP` (ADSP). The existing `toolbox/devices.cla` Device
  Manager catalog carries all of it.
- **ASP has no server API.** *IM: Networking* p. 8-3: to implement a
  server, use ATP. So request/response is ATP directly: one request
  packet of up to 578 bytes, a response of up to 8 × 578 = 4624 bytes,
  a 32-bit user-bytes field in each direction, exactly-once (XO) mode
  built in. ASP's session/tickle/attention layers are not needed.
- **ADSP is System 7.** On System 6 it is Apple's separate `ADSP` INIT
  (type `INIT`, from the Network Software Installer); detection is
  `OpenDriver(".DSP")` failing — there is no Gestalt selector for it.
  NBP and ATP are in the Mac Plus ROM. `.XPP` is in the System file on
  a Plus, in ROM on SE/II.
- **Polling works without completion routines.** `PGetRequest` and
  `dspRead` block until satisfied, so the event-loop shape is issue
  async, poll `ioResult` each pump pass. `dspStatus.recvQPending` is
  the bytes-available query, which maps ADSP onto `conn.cla`'s
  six-function transport waist unchanged.
- **Zones need a router.** On a routerless LocalTalk net
  `GetZoneList`/`GetMyZone` return `noBridgeErr` (−93) and the only
  valid zone is `*`. There is no node-enumeration protocol; "list
  nodes" is an NBP wildcard lookup (`=:=@*`) grouped by address.
- **Emulators.** `macplus/MacPlus.app` and `macplus2/MacPlus2.app` are
  LocalTalk-over-UDP (LToUDP) builds — each carries the multicast
  address 239.192.76.84. Snow's LocalTalk-over-UDP speaks the same
  framing. Andrew's separate EtherTalk↔LToUDP bridge, when running,
  exposes the real extended network (zones, routers) to both; normal
  testing runs without it.
- **Compiler state.** `connection` values are 1-based `int` handles
  into a fixed slot table; each transport is a six-function waist with
  `_68k`/`_c` lane twins; `rtConnOpen` carries a reserved transport
  tag 1 for `appletalk`; `listener`/`serviceBrowser`/`address`, their
  methods and events, are fully checked. Only lowering and runtime are
  missing.

## 3. Decisions (approved in brainstorm)

| # | Question | Decision |
|---|---|---|
| Q1 | Host lane | **Real LToUDP peer in C**: DDP + NBP + ATP for real; a host program is a genuine peer of the emulators and the harness gets a driver tool. |
| Q2 | ADSP scope | **ADSP on the Macs only** this phase (System 6 via the `ADSP` INIT on the test disk, System 7 built in). Host ADSP → `docs/FUTURE.md`. |
| Q3 | RPC client | **Synchronous `call`**, `bool` + `lastError`, the `file.*` convention. Fixed 2 s × 3 retries. |
| Q4 | Endpoints | **One service = one NBP name + one ATP socket; integer `op` in the ATP user bytes**, one `request` handler, `switch` over a program enum. No new declaration form. |
| Q5 | Discovery | `find(type[, zone])` → `found` per entity then `done`; `zones()` sync, `["*"]` with no router; nodes = `find("=")`. No echo probe. |
| Q6 | Mac tests | Host `atalkdrive` tool as the peer for NBP/ATP (one boot); **two Mini vMac boots** for ADSP; Snow opt-in for System 7. |
| Q7 | Serial roll-in | `stdio`/`pty` host transports and host `every` timers **in**; the native UI/non-UI pump gap → `docs/FUTURE.md`. |

## 4. Language surface (reference changes)

### 4.1 Connections

- `c.open(appletalk "Name:Type")`: NBP lookup of `Name:Type@*`, then an
  ADSP open to the first match. `c.open(addr)` opens ADSP straight to
  an `address`. Both are asynchronous like every `open`: `opened` fires
  on a later pump pass, or `failed` (no such name, `.DSP` absent, open
  timed out, slot table full).
- Events keep `connection`'s shape. `closed` fires when the peer
  closes or the connection tears down (unlike serial, ADSP has a
  closure concept). `send` writes to the ADSP send queue. `received`
  delivers whatever `dspStatus` reports pending, once per pump pass,
  binary-safe. `send`/`close` on an unopened connection stay runtime
  errors.
- The connection slot table grows from 4 to 8, so a server can hold
  clients; the reference's own listener example already uses
  `connection[8]`. The "4 connection variables" cap becomes 8.

### 4.2 Listeners

- `l.register(name: string, type: string)`: an ADSP connection
  listener plus NBP registration of `name:type`. `accepted(c:
  connection)` hands over a fresh, already-open connection — no
  `opened` fires for it. When all 8 slots are taken the runtime denies
  the request (`dspCLDeny`) and the client's open fails.
- `l.stop()` (new): removes the name and the listener. Idempotent.
- `l.failed(err: error)`: `.DSP` absent, name already in use
  (`nbpDuplicate`), listener init failure.
- `l.listen(port: int)` stays a MacTCP fence (rejected in lowering as
  today).

### 4.3 Service discovery

- `b.find(type: string)` and `b.find(type: string, zone: string)`
  (new overload): an NBP lookup of `=:type@zone` (`*` when omitted).
  One `found(name: string, addr: address)` per match, then `done`
  (new event). `find("=")` lists every registered entity in the zone.
- `b.zones(out: list of string)` (new, synchronous): empties `out` and
  fills it with the router's zone list (`GetZoneList` via `.XPP`); with
  no router (`noBridgeErr`) or no `.XPP`, the one-element list `["*"]`,
  so programs never special-case the routerless network.
- `b.failed(err: error)`: lookup could not be issued (`.MPP` failed to
  open, bad zone name). A lookup that simply matches nothing is
  `done` with no `found`, not a failure.
- `string(addr)` (new conversion) renders an `address` as
  `net.node.socket` for display. `address` is an inline 4-byte value
  laid out as `AddrBlock` (`net` 2 bytes, `node` 1, `socket` 1), so it
  passes through records and arrays with no retain/release.

### 4.4 Services (new resource type `service`)

```rust
var svc: service

svc.serve(name: string, type: string)      // open ATP socket, register NBP name
svc.reply(code: int, data: text)           // only inside a request handler; string also accepted
svc.stop()                                 // remove name, close socket; idempotent
svc.call(target, op: int, req: text, reply: text): bool   // synchronous; target: address or "Name:Type"

on svc.request(op: int, req: text, from: address) { }
on svc.failed(err: error) { }
```

- `op` and `code` are the ATP user bytes: 32-bit signed integers.
- A `request` handler that returns without calling `reply` gets an
  automatic empty reply with code `-1`, so the requester never waits
  out its timeout. `reply` twice in one handler, or outside a handler,
  is a runtime error.
- `call` returns `true` only when a response arrived **and** its
  `code` is `0`; `reply` then holds the concatenated response. It
  returns `false` and sets `lastError` on: no response after 2 s × 3
  retries (`reqFailed`, −1096, message `no response`), NBP lookup miss
  for the string form (`nbpNoConfirm`), request over 578 bytes,
  `.MPP` unavailable — and on a nonzero server `code`, in which case
  `lastError` is `{ code, "service" }` and `reply` still holds
  whatever payload the server sent. So `code` is the server's
  application-level status (`0` = success, anything else = the
  server's own error namespace), and `lastError` keeps its reference
  meaning: the detail behind the most recent soft failure. A server
  that wants to return a positive status with a successful reply puts
  it in the payload.
- Limits are ATP's and are enforced, never truncated: request ≤ 578
  bytes, reply ≤ 4624 bytes (`reply` with more is a `failed` event on
  the server and an automatic `-1` reply to the requester).
- `call` on a serving variable is allowed; the requester uses its own
  socket. A client-only program never calls `serve`.
- Timing is fixed this phase: request timeout 2 s, 3 retries; NBP
  lookup interval 1 s, 3 tries. A retry knob is recorded in
  `docs/FUTURE.md`.

The idiom for typed ops is the reference's existing checked enum
conversion, guarded so a bad op from the wire cannot raise:

```rust
enum ClockOp { Time 1 "Time", Echo 2 "Echo" }

on svc.request(op: int, req: text, from: address) {
    if op < 1 or op > 2 {
        svc.reply(-1, "")
        return
    }
    switch ClockOp(op) {
        case Time: svc.reply(0, timeText)
        case Echo: svc.reply(0, req)
    }
}
// client: clock.call(addr, int(Time), "", reply)
```

### 4.5 Caps and error principle

- Global resource variables per program: 8 `connection`, 2 `listener`,
  2 `serviceBrowser`, 2 `service`. Over the cap is a build error naming
  the cap.
- Unchanged principle: **contract violations are runtime errors;
  environmental failures are events or `false` + `lastError`.**
  Contract: `send` before `open`, `reply` outside a handler, use of a
  nil resource. Environmental: `.DSP` missing, no response, name in
  use, slot table full.

### 4.6 Host lane summary

Discovery, `zones` (always `["*"]`), `serve`, and `call` work for real
over LToUDP. AppleTalk stream `open`, `register`, and therefore
`accepted` fail with an event on the host this phase.

### 4.7 Serial additions

- `CLARUS_SERIAL_MODEM`/`CLARUS_SERIAL_PRINTER` accept two new values:
  `stdio` (read fd 0, write fd 1; raw-mode `tcsetattr` on open when fd
  0 is a tty, restored at exit) and `pty` (`posix_openpt`/`grantpt`/
  `unlockpt`; the slave path printed to stderr; no slave attached
  behaves like the `listening` state). Existing `listen:PORT`/
  `connect:HOST:PORT` unchanged.
- Host CLI lifetime rule gains `every`: after `App.startCLI` returns
  the program stays alive while any connection or service is open, a
  browser search is in flight, an event is pending, **or an `every`
  timer is armed**, and `every` handlers fire from that loop.

## 5. Runtime architecture (native lane)

### 5.1 Toolbox catalog — fill the manager

One new file, `toolbox/appletalk.cla`: driver names `.MPP`/`.ATP`/
`.XPP`/`.DSP`; every csCode (NBP `confirmName` 250, `lookupName` 251,
`removeName` 252, `registerName` 253, `killNBP` 254; DDP `writeDDP`
246, `closeSkt` 247, `openSkt` 248; `setSelfSend` 256; ATP
`nSendRequest` 248, `relRspCB` 249, `closeATPSkt` 250, `addResponse`
251, `sendResponse` 252, `getRequest` 253, `openATPSkt` 254,
`sendRequest` 255, `relTCB` 256, `killGetReq` 257, `killSendReq` 258,
`killAllGetReq` 259; ZIP `xCall` 246 with subcodes `zipGetLocalZones`
5, `zipGetZoneList` 6, `zipGetMyZone` 7; ADSP `dspInit` 255 …
`dspNewCID` 241); the flag and mode constants (`atpXOvalue` 32,
`atpEOMvalue` 16, `atpSTSvalue` 8, `ocRequest` 1, `ocPassive` 2,
`ocAccept` 3, `ocEstablish` 4, `sOpen` 4, `sClosing` 5, `sClosed` 6,
`eClosed` $80 …); and the extern records `AddrBlock` (4), `EntityName`
(99), `NamesTableEntry` (108), `BDSElement` (12), `MPPParamBlock`,
`ATPParamBlock`, `XPPParamBlock`, `DSPParamBlock`, `TRCCB` (242), with
the field offsets the books tabulate (`ioRefNum` 24, `csCode` 26,
variant fields from 28; DSP `ioCRefNum` 24, `ccbRefNum` 32, variant
from 34). All calls go through `toolbox/devices.cla`'s existing
`_Control`, sync or async. `NBPSetNTE`/`NBPSetEntity`/`NBPExtract` are
library glue, not traps: the runtime builds and parses those byte
layouts itself. Provenance comments cite volume and page, the
`toolbox/files.cla` convention. `docs/clarus-toolbox-cookbook.md` gains
an AppleTalk `PBControl` transcription example.

### 5.2 Runtime modules

`runtime/clarus/atalk.cla` (lane-neutral state + pump) with
`atalk_68k.cla` and `atalk_c.cla` twins — the `conn.cla` /
`datetime.cla` precedent: same function names, exactly one twin
spliced. State is fixed parallel arrays like `conn.cla`: 2 listeners,
2 browsers, 2 services, each with its async parameter blocks living in
runtime globals so `ioResult` can be polled across pump passes.
`.MPP` is opened lazily on first use with `OpenDriver`, never closed
(Apple's warning: other processes may be using it).

### 5.3 ADSP as connection transport 1

- `rtConnOpen` finally switches on its transport tag: 2 → serial
  (`rtConnDev*`), 1 → a new `rtAdsp*` six-function waist (open, avail,
  readByte→batched read, write, close, gone), selected per slot by a
  new `rtConnSlotTransport` array that `rtConnPump` consults.
- Per slot: a 242-byte CCB, 1 KB send and 1 KB receive queues, a
  570-byte attention buffer (~3 KB; ~24 KB for 8 slots).
- `avail` = `dspStatus.recvQPending`; read = sync `dspRead` with
  `reqCount` = pending, into a scratch buffer, appended to the
  `received` text in one step (the batched `rtConnDevReadInto`
  upgrade `conn.cla`'s ponytail comment already names); `gone` = CCB
  `state` ≥ `sClosing`; `write` = sync `dspWrite`, `flush` set.
- Opening is a per-slot state machine driven by the pump: NBP lookup
  pending (async `PLookupName`) → `dspInit` + `dspOpen(ocRequest)`
  pending → open, then `opened`; a failure at any step → `failed`.
  The `address` form skips the lookup step.

### 5.4 Listener

`register`: `dspCLInit` (listener CCB) + `PRegisterName` (verify on)
+ async `dspCLListen`. The pump sees completion, takes a free
connection slot, `dspInit` + `dspOpen(ocAccept)` with the returned
remote CID, address, and sequence numbers, marks the slot open with
transport 1, fires `accepted(c)`, and re-arms `dspCLListen`. No free
slot → `dspCLDeny`, re-arm. `stop`: `PRemoveName`, `dspCLRemove`.

### 5.5 Service

- `serve`: `POpenATPSkt` (socket 0 → assigned), `PRegisterName`,
  async `PGetRequest` into the slot's 578-byte request buffer.
- Pump, on `PGetRequest` completion: fire `request(op = userData,
  req = reqLength bytes, from = addrBlock)`; the handler's `reply`
  copies the payload into the slot's 4624-byte reply buffer, builds an
  8-entry BDS over it, and issues `PSendResponse` **async** with the
  XO flag so the server never blocks on the requester's `TRel` (in XO
  mode a sync `PSendResponse` completes only on `TRel` or the 30 s
  release timer). While that response is outstanding `PGetRequest` is
  not re-armed — one transaction at a time per slot; ATP's requester
  retries cover the gap (`// ponytail:` single reply buffer, add a
  second if a busy server measurably drops requests).
- `call`: sync `PSendRequest`, XO, `timeOutVal` 2, `retryCount` 3,
  BDS over a shared 4624-byte response buffer; on completion the
  `numOfResps` entries' `dataSize` bytes are concatenated into the
  caller's `reply` text and `code` = the first response's `userBytes`.
  The string target form does a sync NBP lookup first.
- `stop`: `PRemoveName`, `PCloseATPSkt`.

### 5.6 Browser

`find`: async `PLookupName` with a 2 KB return buffer, `maxToGet` 32,
interval 8 (1 s), count 3. The pump fires `found` per extracted tuple
(runtime `NBPExtract` equivalent) then `done`. `zones`: sync
`GetZoneList` loop over `.XPP` until `zipLastFlag`; `["*"]` on
`noBridgeErr`, `reqFailed`, or `.XPP` failing to open.

### 5.7 Pump

`rtConnPump` gains a call into `rtAtalkPump`, so neither the UI event
loop nor the host CLI loop needs a new hook. `rtConnAlive` gains
"service open or browser searching".

## 6. Host lane

### 6.1 `runtime/host/rt_atalk.inc` — LocalTalk-over-UDP stack

A C unit beside `rt_serial.inc`, included from `rt.c`, wrapped by
`atalk_c.cla`'s externs. Written **instance-able** (one struct per
stack) so a unit test can run two peers in one process.

- **LToUDP framing.** One UDP socket joined to multicast
  239.192.76.84 port 1954, `IP_MULTICAST_LOOP` on. Datagram = 4-byte
  sender id (random per instance; own packets dropped) + LLAP frame
  (dst node, src node, LLAP type, payload). `CLARUS_ATALK_IFACE=<ipv4>`
  selects the interface on a multi-homed host. Bind/join failure →
  `failed` or `false` + `lastError`, never a crash.
- **LLAP node acquisition.** Random node id in 1–127 (workstation
  range), `lapENQ` ($81) several times, move on to another id on
  `lapACK` ($82). Acquired on the first open.
- **DDP.** Short header only (LLAP type 1, 5 bytes, net 0, no
  checksum). Dynamic sockets 128–254. Extended-header packets (type 2)
  are accepted; replies never route to a non-zero net (no router
  support on this lane).
- **NBP.** Local names table answering `LkUp` for our names; `LkUp`
  broadcast (node 255, socket 2) with reply collection for lookups;
  verify-lookup before register. Retry 3 × 1 s. Zone always `*`.
- **ATP.** Requester: XO, TID, bitmap, retransmit on timeout, `TRel`
  on completion. Responder: XO transactions list with duplicate
  replay, 30 s release timer; `STS` unused. Same 578/4624 limits.
- **No ADSP.** DDP type 7 dropped; the `rtAdsp*` waist fails at open.
- Non-blocking throughout except `call` and `zones`, which loop on
  `select` under their own deadline. `rt_ext_ConnHIdle` adds the UDP
  socket to its `select` set so a host server sleeps until traffic or
  the next timer.

### 6.2 Driver tool

`build-run/tools/atalkdrive`, a sibling of `tcpdrive`: the same
`rt_atalk.inc` compiled standalone with a small CLI — `lookup TYPE`,
`register NAME TYPE`, `call NAME TYPE OP` (request on stdin, reply on
stdout, code on stderr/exit), `serve NAME TYPE` (echo with a scripted
op table). Tests and the T2 emulator scripts drive it.

### 6.3 Serial roll-in, `rt_serial.inc`

Two spec values in the same parser: `stdio` and `pty` (§4.7). Per-slot
`read`/`write` vs `recv`/`send` by fd kind; a per-slot `gone` flag set
when `read` returns 0 replaces the `MSG_PEEK` trick for non-sockets;
`FIONREAD` and `select` already work on ttys and pipes. Pipe-pair and
pty cases in `rt_serial_test.c`. Then a deliberate re-pin in 68kbbs
(outside this repo).

### 6.4 `every` on the host CLI pump

The post-`startCLI` loop becomes: pump connections, pump AppleTalk,
fire due `every` timers, idle until the nearest deadline. The timer
bookkeeping moves out of the UI runtime into a small lane-neutral
module both loops share; the Mac UI loop's behavior is unchanged.

## 7. Compiler and bake

- **Parser/checker.** `appletalk` is already tag 1 and `address` an
  `open` argument type. Add: the `service` type (four methods, two
  events), `find(type, zone)`, `zones(out)`, the `done` event,
  `listener.stop()`, `string(addr)` in the conversion family.
- **Lowering.** The seam is `lowConnMethod`'s fallback. Method calls on
  kinds 13 (`appletalk`/`address` open), 14 (`listener`), 15
  (`serviceBrowser`), and the new `service` kind lower to runtime calls
  carrying the variable's slot. A slot pre-pass per resource kind
  assigns slots in declaration order with §4.5's caps and a clear
  diagnostic past the cap. Handlers synthesize `clar_atalk_fire_*`
  dispatchers in the `clar_conn_fire_*` reverse-waist family
  (unconditional synthesis, empty switch when nothing is declared,
  self-rooted). `accepted` passes a connection handle, `found` a
  string and a 4-byte address, `request` an int, a text, and an
  address. `reply`'s "inside a handler" contract is a runtime flag.
- **Splice/bake.** `atalk.cla` (+ `_68k`) joins the unconditional 68k
  superset beside `conn.cla`; the host lane splices `atalk.cla` +
  `atalk_c.cla` under a new `usesAtalk` gate. Planned consequences:
  one golden rebless wave (global renumbering, and the 4 → 8 slot
  growth in the same wave); the standing `CLARUS_SNOW_TESTS=1 make test
  T=mactest/snow/clarusc_bake` run because `bake.cla`'s module list
  changes; `tests/bake/atalk.sh` `emit68k_pair` twin in the same task
  as the module (standing rule).
- **C-lane `--rtbake` gap, fixed.** The recorded gap (the bake path
  skips the usage-gated conn/fileh splice, so baked host C fails to
  compile) would swallow `atalk_c.cla` too. This phase takes the
  TODO's fix (b): `drive.cla`'s existing from-source fallback also
  triggers on `haveRtbake and not want68k and (usesConn or usesFileh
  or usesAtalk)`. No `bake.cla` change beyond the module list, no
  golden movement from it, and `bake/full_corpus_emitui`'s self-
  retiring SKIP retires.

## 8. Testing

### 8.1 T1, host, every task

- `runtime/host/rt_atalk_test.c`: two stack instances in one process
  on loopback multicast. LLAP acquisition with a forced collision; NBP
  register/lookup/wildcard/duplicate-reject; ATP request/response
  including a dropped-packet retransmit and an XO duplicate replay;
  oversize rejection; a `select`-idle wake on traffic.
- End-to-end programs: a Clarus service program against `atalkdrive`
  as client; a Clarus `call` program against `atalkdrive` as server;
  browser `find`/`done` and `zones` = `["*"]`; `every` in the CLI pump;
  `stdio` pipe-pair and `pty` cases for serial.
- Compiler fixtures: emitui and cg68k goldens for every new lowered
  shape; reftest fences for the reference's new sections; runerr
  fixtures for `reply` outside a handler, `send` on an unopened ADSP
  connection, each cap overflow; `tests/bake/atalk.sh`.

### 8.2 T2, `CLARUS_MAC_TESTS=1 make -j1 test T=mactest/`

- `mactest/atalk_68k.sh`: one Mini vMac boot of an app that serves and
  browses, `atalkdrive` on the host as the peer: the tool finds the
  app's name, calls its ops and checks replies, then serves a name the
  app calls back. NBP and ATP both ways against ROM code.
- `mactest/adsp_68k.sh`: two Mini vMac boots, `macplus/` as listener
  and `macplus2/` as client, each `--events`-driven, each writing its
  own log trailer: `register`, `accepted`, `open(appletalk ...)`,
  byte-exact echo both ways, `closed` on the peer's close. Needs a
  `run_mac_pair` helper in `tests/lib_mac.sh` with independent kill
  and capture; two LaunchAPPL runs vs the `open -na` + `mnvm_dat` path
  is a probe finding.
- Toolbox suite case `AtalkSelf`: open `.MPP`, register a name, look
  it up, and (if the probe says the ROM answers its own lookups,
  possibly via `SetSelfSend`) an ATP self-transaction. Hardware-proves
  the catalog with no peer, the `SerialOpenWrite` pattern. Toolbox
  count 38 → 39 in all five places.
- One FreeMem check across an ADSP open/close cycle in the suite (the
  ~3 KB per-slot allocation must come back).

### 8.3 Opt-in Snow, `CLARUS_SNOW_TESTS=1`

`mactest/snow/adsp_listener.sh`: Snow as listener, Mini vMac as
client — the System 7 proof of `.DSP` built in. Plus the standing
`clarusc_bake` rerun.

### 8.4 Environment rules

- The `ADSP` INIT goes into the System 6 image that `~/.LaunchAPPL.cfg`
  boots, and the config points at `disk1.dsk`; `macplus/` and
  `macplus2/` disks stay identical copies.
- Every test registers names with a per-run suffix and tolerates
  unrelated entities in lookup results: multicast sees Andrew's live
  sessions and, when up, the bridge.
- Test timeouts assume no router: a zone call fails fast with
  `noBridgeErr` rather than waiting.
- `.gitignore` gains `/macplus2`.

### 8.5 Acceptance apps

- `examples/atalkclock.cla`: a window listing zones and every entity
  found, a served clock service, a button that calls the nearest clock.
- `examples/atalkchat.cla`: a listener plus a connection — a two-Mac
  chat, the subject of the two-boot script and of Andrew's manual
  bridge testing.

## 9. Task 1 probe wave (before any build-out)

1. **ADSP INIT.** Locate Apple's `ADSP` INIT, install it on the System
   6 image, confirm `OpenDriver(".DSP")` succeeds on a boot and fails
   without it. If it cannot be found, streams become Snow-only this
   phase (Q2's (ii) degrades to (iii)) — Andrew's decision, not the
   plan's.
2. **LToUDP reach.** A hand-rolled trap-level Clarus program registers
   an NBP name on one Mini vMac; the other looks it up; a throwaway
   host C sniffer joined to the group sees the lookup. Confirms
   `OpenDriver(".MPP")` from a program works regardless of the
   Chooser's AppleTalk setting, and that the host sees the group.
3. **Self-lookup.** Whether NBP answers a node's own lookup and whether
   an ATP self-transaction needs `SetSelfSend` — decides `AtalkSelf`'s
   shape.
4. **Two-boot launcher.** Two Mini vMac instances at once from a test
   script, independent kill and log capture.
5. **Snow interop.** Snow's LocalTalk-over-UDP against Mini vMac, one
   NBP lookup each way.

## 10. Risks

- **Host ATP fidelity against ROM code**: XO release and bitmap
  retransmit are where a home-grown stack diverges. Mitigation:
  `atalk_68k.sh` exercises the host stack against the ROM's ATP both
  ways.
- **Sync `call` freezes the Mac UI for up to 6 s** on a dead target.
  Documented; fixed timing this phase; knob in `docs/FUTURE.md`.
- **ADSP heap**: ~24 KB for 8 slots — fine on a Plus, checked once in
  the suite.
- **Rebless wave** and the 30-minute Snow bake gate — planned.
- **Multicast noise** — the naming rule.

## 11. Out of scope

Host ADSP; ASP sessions, tickle, attention messages; routers, extended
DDP headers, multi-zone on the host lane; `listener.listen(port)` and
MacTCP; async `call`; declared endpoints; a retry knob; the AppleTalk
Transition Queue; AEP probing; the native non-UI pump gap; connection
open-filters; ADSP forward reset.

## 12. Documentation moves

- Reference: `appletalk`/`address` forms in Connections; `register`/
  `stop` in Listeners; `find`/`zones`/`done` in Service Discovery; a
  new Services section with the enum-guard idiom; `string(addr)`;
  serial `stdio`/`pty`; `every` in the host lifetime rule; the 8-slot
  cap.
- Cookbook: an AppleTalk `PBControl` transcription example.
- `docs/TODO.md`: the two serial items and the C-lane bake gap leave
  (fixed). `docs/FUTURE.md` gains host ADSP, the UI/non-UI pump gap
  (moved from TODO), and the `call` retry knob.
- ROADMAP status line; HISTORY on merge; CLAUDE.md suite-count line.
