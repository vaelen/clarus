# MacTCP: TCP streams via `connection` — design

Brainstormed with Andrew 2026-09-07. Third phase of the "language
usability" networking arc (serial → AppleTalk → **MacTCP**, driving
toward a BBS server). Approved section by section in-chat; this
document is the written record. Sources: the *MacTCP Programmer's
Guide* (Apple, `inside-macintosh-v2/MacTCP Programmers Guide.pdf`) for
driver semantics; Universal Interfaces 3.4's `MacTCP.h`
(`Retro68/InterfacesAndLibraries/Interfaces/CIncludes/MacTCP.h`, CR-only)
for csCodes, parameter-block offsets and error codes; Snow's Ethernet
manual (`docs.snowemu.com/manual/network/ethernet`) for the emulator's
NAT link.

## 1. Problem

`connection` is specified as "a single reliable byte-stream abstraction
over both AppleTalk (ADSP) and TCP (MacTCP)", and `listener.listen` as
"a TCP listening socket (MacTCP)", but both are fences: lowering rejects
them with `unsupported construct: method call on receiver kind 13/14`
(`clarusc/lower.cla`'s `lowConnMethod` fallback and `lowListenerMethod`,
whose doc comment names `l.listen(port)` as "a MacTCP fence"). No
runtime exists on either lane. The phase delivers TCP as `connection`'s
third transport and `listener`'s second, on the Macintosh through
MacTCP's `.IPP` driver and on the host through BSD sockets, plus three
compiler/harness debts parked "until the MacTCP phase reblesses the
corpus".

## 2. Findings that shaped the design

- **No MacTCP on the System 6 test disks.** `macplus/disk1.dsk`,
  `macplus2/disk1.dsk` and `~/mac/System 6.0.8.dsk` carry no MacTCP,
  and Mini vMac has no link layer MacTCP could drive (MacTCP over
  LocalTalk needs a MacIP gateway nothing here provides). The only
  emulator with a TCP/IP stack is Snow's Mac II (`snow/hdd0.img`:
  `MacTCP` cdev/ztcp, `MacTCP DNR` cdev/mtcp, `MacTCP Prep`, the
  DaynaPORT driver, IP 10.0.0.2, gateway 10.0.0.1). Hardware proof is
  therefore the opt-in Snow lane; T2 gains nothing this phase.
- **Snow's NAT link is outbound-only.** The manual documents a
  userland NAT that translates TCP/UDP (not ICMP) from the guest to the
  world, with no port forwarding: the guest can dial the host, the host
  cannot dial the guest. So the hardware test is a **guest self-connect**
  (a listener and a client in one program), which proves our
  integration with the driver, not the network — the agreed scope.
- **The DNR is not in the toolchain.** `MacTCP.h` declares no
  `OpenResolver`/`StrToAddr`/`hostInfo`; `AddressXlation.h` and Apple's
  `dnr.c` glue are absent from `Retro68/`. The resolver is a `'dnrp'`
  code resource in the "MacTCP DNR" file (System 7, type `cdev` creator
  `mtcp`) or the MacTCP control panel (1.x, `cdev`/`ztcp`), whose first
  long word is a jump-table procedure called **C-convention** with a
  selector as the first argument (guide p. 75). Clarus's `= ptr` extern
  clause is pascal-only and there is no general inline facility, so
  name resolution needs a compiler feature. Decision: dotted-quad only
  this phase, DNR next.
- **The ASR is optional.** `TCPCreate`'s `notifyProc` may be nil; a
  receive command outstanding on the stream is how an application
  learns of data (guide p. 38), and `TCPRcv` completes with
  `connectionClosing` when the peer has closed and every byte is
  delivered, `connectionTerminated` on a reset (p. 51). The
  AppleTalk phase's `atalk_68k.cla` discipline — every call
  `PBControlAsync`, `ioResult` polled on later pump passes, no
  interrupt-time code — carries over unchanged.
- **`TCPRcv` over `TCPNoCopyRcv`.** The copying receive needs no RDS
  and no `TCPRcvBfrReturn` pairing; a runtime that copies into its own
  `text` anyway gains nothing from zero-copy.
- **One passive open is one connection.** A stream holds one
  connection at a time; a server re-issues `TCPPassiveOpen` on a fresh
  stream for the next client (p. 31, 43). `localPort` 0 asks for a
  dynamic port; `commandTimeoutValue` 0 waits forever.
- **`TCPClose` is a half-close** ("no more data to send"); the remote
  may keep sending, the application must keep receiving, and only when
  both sides have closed should it `TCPRelease` (p. 34, 52). The close
  parameter block carries its own ULP timeout and action, which bounds
  a peer that never closes.
- **Header vs guide.** `TCPReceivePB`'s `filler` position differs
  between the printed guide and `MacTCP.h`; the header wins. The
  header defines no names for `connectionState` values and no
  `TCPRelease` csParam (only the common header + `tcpStream`);
  `invalidRDS` and `invalidWDS` share -23014.

## 3. Decisions (approved in brainstorm)

| # | Question | Decision |
|---|---|---|
| Q1 | Hardware lane | **Snow only, opt-in**; guest self-connect on `127.0.0.1` (own address from `ipctlGetAddr` as fallback if MacTCP has no loopback). No Snow port-forward work, no MacIP gateway for Mini vMac (→ `docs/FUTURE.md`). |
| Q2 | Syntax | **`c.open(tcp "host:port")`** and **`l.listen(tcp port)`** — a contextual keyword like `appletalk`/`serial`, reserving `udp`. The reference's plain-string `open("host:port")` form is removed; a bare string is a compile error. |
| Q3 | Name resolution | **Dotted quad only, both lanes** (the host could resolve for free, but a program must not pass on the host and fail on the Mac). DNR is the next roadmap phase. |
| Q4 | Carried debts | **All three in**, as the plan's first tasks: dispatcher-builder fold, `delay N` script verb, AppleTalk + TCP in the `--testapi` early-visible set. |
| Q5 | Native mechanism | **Polled async parameter blocks, no ASR** (approach A). |

## 4. Language surface (reference changes)

### 4.1 Connections

- `c.open(tcp "host:port")`: `host` is a dotted quad (`a.b.c.d`, each
  0–255), `port` 1–65535. A malformed spec, a non-numeric host ("host
  names need the DNR" — both lanes, until the DNR phase), MacTCP absent
  (`.IPP` fails to open), no free MacTCP stream, and a full slot table
  all arrive as `failed(err: error)` on a later pump pass, never a
  crash. `opened` fires when the active open completes; a refused or
  unreachable peer (`openFailed`) or a 30 s open timeout is `failed`.
- `received(data: text)`: whatever one completed receive delivered,
  binary-safe, at most once per pump pass per connection.
- `closed`: the peer closed (`connectionClosing`) or the connection was
  reset/terminated (`connectionTerminated`). The slot is released; a
  later `send` is the existing `connection not open` runtime error. A
  local `close()` never fires `closed`, on any transport.
- `close()`: pending sends drain first, then a graceful close with a
  10 s ULP timeout whose action is abort, so a peer that never closes
  cannot pin the slot; bytes the peer sends after a local close are
  discarded. Re-`open` on the same variable afterwards is fine.
- `send(t)`: appends to the connection's send queue; the runtime pushes
  every chunk (`pushFlag` set) so a line-oriented peer sees it at once.
- The plain-string `open("host:port")` form leaves the reference. A
  bare string with no transport keyword is a compile error: `open needs
  a transport: tcp, appletalk, or serial`.

### 4.2 Listeners

- `l.listen(tcp port: int)`: port 1–65535. `accepted(c: connection)`
  hands over an already-open connection — no `opened`, as with
  `register`. `listen` without the `tcp` keyword is a compile error
  naming the required form.
- Slot table full: the runtime aborts that client's connection and
  re-arms silently — the client sees a reset, the server sees nothing
  (the `register` rule).
- `l.failed(err)`: MacTCP absent, port already in use
  (`duplicateSocket`), stream creation failure. After a successful
  `listen`, a failed re-arm tears the listener down like `register`'s
  lost-listen rule (the program must `listen` again); a single client
  that could not be accepted does not.
- `l.stop()`: aborts and releases the listening stream; idempotent;
  safe on a never-started listener. One listener variable serves either
  `register` or `listen` at a time; the other form on a started
  listener fails with `listener already registered`.

### 4.3 Host lane

The same surface for real over BSD sockets: `open`, `listen`,
`accepted`, `received`, `closed`, `failed`, with the same dotted-quad
rule. The command-line lifetime rule is unchanged: after
`App.startCLI` returns the program stays alive while a TCP connection
or listener is open, so a host build is a working server.

### 4.4 Not in this phase (recorded)

IP `address` values and a `remoteAddress` getter; `system.hasTCP()`
(the has* family, `docs/TODO.md`); UDP; the DNR; OpenTransport.

## 5. Runtime architecture (native lane)

### 5.1 Toolbox catalog — `toolbox/mactcp.cla`

The whole `.IPP` control interface transcribed from `MacTCP.h`,
`toolbox/appletalk.cla`'s shape: csCodes (`ipctlGetAddr` 15,
`ipctlEchoICMP` 17, `ipctlLAPStats` 19; TCP 30–43; UDP 20–29), the
102-byte `TCPiopb` (32-byte common header: `ioCompletion` 12,
`ioResult` 16, `ioCRefNum` 24, `csCode` 26, `tcpStream` 28; csParam at
32) with every variant's offsets — create (`rcvBuff` 32, `rcvBuffLen`
36, `notifyProc` 40, `userDataPtr` 44), open (`ulpTimeoutValue` 32,
`ulpTimeoutAction` 33, `validityFlags` 34, `commandTimeoutValue` 35,
`remoteHost` 36, `remotePort` 40, `localHost` 42, `localPort` 46, …
`userDataPtr` 94), send (`pushFlag` 35, `wdsPtr` 38, `sendLength` 46),
receive (`commandTimeoutValue` 32, `rcvBuff` 36, `rcvBuffLen` 40),
close (`ulpTimeoutValue` 32, `ulpTimeoutAction` 33, `validityFlags`
34), status (`connectionState` 52, `amtUnackedData` 58,
`amtUnreadData` 60) — `wdsEntry`/`rdsEntry` (6 bytes: length, ptr;
zero-length terminator), `GetAddrParamBlock`, the validity/ToS flag
bits, the ASR event and termination codes, and the error codes
-23000…-23048. UDP is catalogued (fill the manager) but unused. The
existing `toolbox/devices.cla` supplies `PBOpenSync`/`PBControlAsync`.
`tests/testsuite/catalog.sh` picks the file up.

### 5.2 Runtime modules

`runtime/clarus/tcp.cla` (shared, lane-neutral state machine) over a
per-lane waist, `tcp_68k.cla` (MacTCP) / `tcp_c.cla` (host binding),
the `atalk` trio's shape. `tcp.cla` + `tcp_68k.cla` join the 68k
superset; `tcp.cla` + `tcp_c.cla` are usage-gated on the host lane by
the existing `usesConn` signal (they travel with `conn.cla`).

The waist is ten calls, deliberately narrow so an OpenTransport backend
is a second implementation chosen by a Gestalt check in `DevInit`, not
a rewrite: `rtTcpDevInit` (open `.IPP` once, cache the refnum),
`DevCreate(slot)`, `DevActiveOpen(slot, ip, port)`,
`DevPassiveOpen(slot, port)`, `DevPoll(slot)` (returns the completed
event, if any: opened / failed(code) / received(n) / closed / sent /
none), `DevSend(slot, ptr, len)`, `DevRecv(slot)` (arm the next
receive), `DevClose(slot)`, `DevAbort(slot)`, `DevRelease(slot)`.

### 5.3 Per-slot state

An 8-entry table in `tcp.cla` parallel to `conn.cla`'s, keyed by the
connection slot: phase (`Idle`, `Opening`, `Established`, `Closing`),
the MacTCP stream pointer, three non-relocatable blocks — the 8 KB
stream receive buffer handed to MacTCP at create (the guide's
character-application minimum), a 4 KB receive copy buffer, a 4 KB
send chunk — two async parameter blocks (one receive; one for
open/send/close in turn), a WDS, and a pending-send `text`. About
16 KB per open slot, allocated at open and freed at release, never held
for idle slots. `ponytail:` 8/4/4 KB are the knobs if probe 3 shows
receive latency or a throughput case wants more.

### 5.4 Lifecycle

- **open**: parse the quad; `DevCreate`; `DevActiveOpen` with
  `ulpTimeoutValue` 30, action abort, validity flags set; phase
  `Opening`.
- **pump, `Opening`**: open PB `noErr` → `opened`, arm the first
  receive, `Established`; any error → `failed`, abort + release.
- **pump, `Established`**: receive PB done with bytes → copy out as
  `received`, re-arm; `connectionClosing`/`connectionTerminated` →
  `closed`, release. Send PB done → next 4 KB chunk from the pending
  `text`, if any.
- **send**: append to the pending `text`; if no send is in flight, move
  up to 4 KB into the send chunk, fill the WDS, `TCPSend` with
  `pushFlag`.
- **close()**: phase `Closing`; once the send queue is empty the pump
  issues `TCPClose` (`ulpTimeoutValue` 10, action abort); receives keep
  being re-armed but their bytes are dropped; the terminating receive
  triggers release.
- **release**: `DevAbort` if a connection could still exist, then
  `DevRelease` (returns the stream buffer to us), then dispose all
  blocks. A release never races a completion: every outstanding call is
  aborted first (the guide does not state `TCPRelease`'s behaviour with
  a pending command; we never rely on it).
- **quit / abort path**: every open slot and listener is aborted and
  released so MacTCP never keeps a pointer into freed memory, the
  `rtAt68DspFree` teardown rule.

### 5.5 Listener

The listener slot table gains a transport tag, as `rtConnSlotTransport`
did for connections. A TCP listener owns one stream with a passive open
outstanding (`remoteHost`/`remotePort` 0 wildcard, `commandTimeoutValue`
0, `localPort` = the port). When it completes: claim a free connection
slot, move the stream and its buffers into it (already `Established`,
first receive armed), fire `accepted`, and create a fresh stream plus
passive open for the next client; no free slot → abort and release that
stream, re-arm. `stop()` aborts and releases the listening stream.

### 5.6 Pump

`rtConnPump` gains a third transport arm calling `rtTcpPollConn(slot)`.
`rtTcpPump` (listeners) is called from the synthesized `clar_conn_pump`
beside `rtAtalkPump`, and `rtTcpAlive` joins the CLI liveness
predicate.

## 6. Host lane

### 6.1 `runtime/host/rt_tcp.inc`

Included from `rt.c` like `rt_serial.inc`/`rt_atalk.inc`. One
non-blocking file descriptor per connection slot and per listener slot,
implementing the same ten-call waist so `tcp.cla`'s state machine runs
unchanged:

- `DevActiveOpen`: non-blocking `connect` (`EINPROGRESS`); `DevPoll`
  reports `opened` when the socket turns writable with `SO_ERROR` clear,
  `failed` otherwise.
- `DevPoll` reports `received` when `recv` returns bytes, `closed` on a
  zero read or `ECONNRESET`.
- `DevSend` writes the chunk; a short write leaves the remainder for
  the next poll, so the one-chunk-in-flight rule holds on both lanes.
- `DevPassiveOpen`: `socket`/`bind` (`SO_REUSEADDR`)/`listen`; poll
  `accept`s and hands back the new fd.
- `DevClose`: `shutdown(SHUT_WR)`, then drain to EOF with the same 10 s
  cap as the Mac, enforced by wall clock in the poll.
- No `select` loop: the CLI lifetime pump polls every pass, as
  `rt_serial.inc` does.

`tcp_c.cla` is the thin `rt_ext_Tcp*` binding, `conn_c.cla`'s shape.
The dotted-quad parse lives in `tcp.cla`, shared, so the host never
calls `getaddrinfo` this phase. `rt_serial.inc`'s `rt_conn_connect`/
`rt_conn_listen` are blocking and serial-slot-bound; `rt_tcp.inc` is
written fresh, with their fd discipline as the model. `tcpdrive`
(`listen`/`connect`/`pick-port`) is already the peer tool.

## 7. Compiler and bake

- **Parse.** `parseArgs` learns the contextual keyword `tcp` (transport
  tag 3) beside `appletalk`/`serial`, interned in `cwInit`; accepted as
  the single argument of `open` and of `listen`.
- **Check.** `checkCall`'s transport rule extends to `tcp`: `open`'s
  argument must be a string, `listen`'s an int; `listen` without a
  keyword and `open` with a bare string are new diagnostics with
  `testdata/errors` fixtures. No new usage flag.
- **Lower.** `lowConnMethod` lowers `open(tcp spec)` to
  `rtConnOpen(h, 3, spec)`; `lowListenerMethod` grows a `listen` arm
  lowering to `rtLsnListen(h, port)`. The two fences go away.
- **Splice and bake.** The tcp trio joins `driveManifestSplice` and
  `bakeModuleList` per §5.2; `tests/bake/tcp.sh` gets its `emit68k_pair`
  twin in the same task (the standing rule).
- **Debt 1, dispatcher fold.** `lowSynthConnFire{Simple,Failed}` and
  `lowSynthAtalkFire{Simple,Failed}` become one builder parameterized
  by kind string and slot count. Zero behaviour change.
- **Debt 2, `delay N`.** `runtime/clarus/uiscript.cla` gets a `delay N`
  verb that waits N real ticks while still pumping connections;
  `examples/atalkchat.cla` drops its `Delay(10)` hack and
  `toolbox/osutils.cla` include; the AppleTalk event scripts move to
  it.
- **Debt 3, early-visible set.** The AppleTalk family and the tcp trio
  join `driveEarlySplice` and `bakeModuleList`'s `--testapi` set, so a
  suite case can name `rtAt68DspFree` and friends (the `docs/TODO.md`
  item).
- **Ordering.** The three debts are the plan's first tasks, before any
  TCP code: one rebless up front, then every later golden diff is real
  TCP change only.

## 8. Testing

### 8.1 T1, host, every task

- `tests/hostrt/tcp.sh`: a C unit test over `rt_tcp.inc` in one process
  — connect to own listener, echo, half-close drain, refused connect,
  short-write chaining.
- `tests/tcp/` group, end-to-end host programs against `tcpdrive`:
  client `open`/`opened`/echo/`closed` on peer close; server
  `listen`/`accepted`/echo; `failed` on refused, on a non-numeric host,
  on a malformed spec; the 9th client denied with the server seeing
  nothing; `send` after `closed` as a runtime error; `every` timers
  coexisting with a listener.
- Compiler fixtures: `testdata/errors` for bare-string `open`,
  keyword-less `listen`, wrong-typed arguments; emitui and cg68k
  goldens for a tcp client and a tcp server shape; `tests/bake/tcp.sh`;
  `tests/testsuite/catalog.sh` covers `toolbox/mactcp.cla`; reftest
  fences for the reference's new text.

### 8.2 T2

Nothing new: the Mini vMac disks have no MacTCP, so no `mactest/`
script and no toolbox suite case this phase. The existing
`adsp_68k.sh` re-proves the `delay N` migration of `atalkchat`.

### 8.3 Opt-in Snow, `CLARUS_SNOW_TESTS=1`

`tests/mactest/snow/tcp_selfconnect.sh`: one boot of an
`--events`-driven fixture that listens on a port, opens
`tcp "127.0.0.1:port"` to itself, echoes a byte-exact payload both
ways, closes from one end, sees `closed` on the other, and writes the
log trailer; the script asserts each step. Plus the standing
`clarusc_bake` rerun, since `bake.cla` changes.

### 8.4 Acceptance app

`examples/tcpchat.cla`, `atalkchat`'s twin: either end of a TCP
conversation — the program to point `telnet`/`nc` at on the host, or
run on Snow against a host `tcpdrive`. The BBS itself stays the
external 68kbbs project this phase serves.

## 9. Task 1 probe wave (before any build-out)

Each a throwaway trap-level program booted on Snow:

1. **`.IPP` opens and `ipctlGetAddr` answers** from a Clarus program.
   Confirms the refnum path and the catalog's first offsets.
2. **Loopback.** Passive open on a port plus active open to
   `127.0.0.1:port` in one program: does MacTCP connect them
   internally? Fallback: the own address from probe 1. Decides the
   self-connect test's spelling.
3. **Receive completion timing.** `TCPRcv` outstanding into 4 KB, peer
   sends 5 unpushed bytes: time to completion. That is `received`'s
   latency; if seconds, shrink the copy buffer or revisit.
4. **Close with ULP abort.** `TCPClose` (10 s, abort) against a peer
   that never closes: the stream terminates itself and `TCPRelease`
   then succeeds.
5. **Snow scripted-lane wall clock.** `delay N` on Snow is real ticks;
   a scripted boot stays deterministic with it.

## 10. Risks

- No loopback and the own-address fallback also fails through the NAT
  link: the Snow test then proves only the client direction against a
  host `tcpdrive`, and the listener is proved on the host lane alone.
  Recorded, not blocking.
- `TCPRelease` with a pending receive is unstated; the runtime always
  aborts first, so a release never races a completion.
- Three locked blocks per slot in the application heap: ordinary
  `NewPtr` (non-relocatable by nature), freed at release, count kept
  small.

## 11. Out of scope (recorded)

- **DNR phase, immediately after** (roadmap): a C-convention `= ptr`
  variant (arguments pushed right-to-left as longs, caller pops, result
  in D0), the resource-file search by type/creator (`cdev`/`mtcp` in
  the System Folder, then `cdev`/`ztcp` in Control Panels and the
  System Folder), a result-procedure probe (interrupt time, A5), then
  host names on both lanes.
- UDP: connected-peer `open(udp "host:port")` on `connection`; a
  separate datagram-server resource (a UDP server is not
  accept-shaped).
- IP `address` values / `remoteAddress`; `system.hasTCP()`;
  OpenTransport backend (a second waist implementation); a MacIP
  gateway on the host LToUDP stack for System 6 Mini vMac
  (`docs/FUTURE.md`); Snow port forwarding.

## 12. Documentation moves

Reference: Chapter 12 connection/listener tables and prose (the `tcp`
keyword, the dotted-quad rule, the close semantics, the listener
rules); the `external func` chapter is untouched this phase. Cookbook:
a MacTCP transcription note beside the AppleTalk one. `docs/ROADMAP.md`:
MacTCP in progress, DNR next. `docs/TODO.md`: the three debts closed.
`docs/FUTURE.md`: MacIP gateway, Snow port forward.
