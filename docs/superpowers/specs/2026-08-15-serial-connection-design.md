# Serial ports via `connection` — design

Brainstormed with Andrew 2026-08-15. First phase of the "language
usability" roadmap arc (serial → AppleTalk → MacTCP, driving toward a
BBS server). Approved section by section in-chat; this document is the
written record.

## 1. Problem

Clarus programs cannot touch the Macintosh serial ports at all, and the
language's networking abstraction — the `connection` type the reference
already specifies normatively (Chapter 12: `open`/`send`/`close` +
events `opened`/`received`/`closed`/`failed`) — is a fence: the checker
implements the full front half (`check.cla` registers
`connection`/`listener`/`serviceBrowser`, their method tables, and all
five events), but lowering rejects every use (`unsupported construct:
method call on receiver kind 13`). The next big application target is a
BBS server, first over serial, later over MacTCP.

## 2. Approach (decided)

Do NOT invent a parallel "stream"/"serial" API. Implement `connection`
end to end with **serial as its first transport**, exactly per the
type's own philosophy ("the transport is chosen at `open` and invisible
afterward"). The BBS gets written against `connection` from day one;
the MacTCP phase later adds a transport + `listener` to the same
machinery instead of a second API. `listener`/`serviceBrowser`/
`address`, ADSP, and MacTCP stay check-only fences this phase.

Alternatives considered in brainstorm: a `serial.*` namespace (like
`file.*`) — rejected because the BBS's I/O layer would need a rewrite
or shim when MacTCP arrives; a new built-in `stream` type — superseded
by the discovery that `connection` already IS that type, named,
specified, and half-built.

## 3. Language surface (reference changes)

New transport form in `connection.open`, matching the existing
contextual-keyword-prefix style (`appletalk "Name:Type"`); the keyword
tags the literal, it is not a value:

```rust
var conn: connection

on App.launch {
    conn.open(serial "modem:9600")     // or "printer:9600"
}
```

- Ports: `"modem"` (SCC channel A, `.AIn`/`.AOut`) and `"printer"`
  (channel B, `.BIn`/`.BOut`).
- Baud: the standard Serial Driver set (300, 600, 1200, 1800, 2400,
  3600, 4800, 7200, 9600, 19200, 57600). Framing fixed at 8N1, no
  handshake — exotic configs go through the Toolbox catalog escape
  hatch, per the 80/20 principle.
- The port spec string may be non-literal; it is parsed at open time.
- Host lane: the same program maps the port to a TCP endpoint from an
  environment variable — `CLARUS_SERIAL_MODEM` / `CLARUS_SERIAL_PRINTER`
  = `listen:PORT` or `connect:HOST:PORT`; baud is ignored. This mirrors
  Snow's own `--serial-bridge-a/-b tcp:PORT` byte-for-byte: the same
  BBS logic talks TCP on the host and the SCC on the Mac. Unset
  variable ⇒ open fails (⇒ `failed` event).

### Semantics

Error principle: **contract violations are runtime errors; environmental
failures are events.**

- `opened` — fires after a successful open, on the next pump pass (not
  inside `open` itself), so handler ordering is uniform across
  transports.
- `failed(err: error)` — open errors and I/O errors; `err` is the
  Chapter 3 `error` record `{code, message}` (OSErr on the Mac,
  errno-flavored on the host).
- `received(data: text)` — fires once per event-loop pass when bytes
  are waiting; `data` is a fresh `text` holding the raw bytes.
  Fully binary-safe: no CR/LF translation, all 256 byte values pass
  through unchanged.
- `closed` — fires when the *underlying channel* goes away (host TCP
  peer disconnect). A local `c.close()` does NOT fire it. A raw Mac
  serial line has no closure concept in v1 (no carrier detect), so on
  the native lane `closed` never fires for serial — documented as a
  transport property, not a lane bug.
- `send(t)` — accepts `text` or `string`; synchronous write
  (PBWrite / socket write). Send on a never-opened or closed
  connection is a **runtime error** (a bug, not weather).
- `close()` — idempotent.
- Reopening an already-open connection var ⇒ `failed`.
- Opening both ports = two connection vars; fine.

### Program lifetime

- Mac: the UI event loop pumps connections each pass (the BBS is
  naturally a small UI app). Native NON-UI programs are out of scope
  (that startup stub can't even boot `App.startCLI` today — see TODO).
- Host CLI: after `App.startCLI` returns, the program stays alive
  **while any connection is open or an event is pending**, pumping;
  then exits normally. `quit` works anytime. This is what makes the
  host BBS dev loop work.

### Receiver scope (this phase)

Global `connection` vars only. Connection arrays, record fields,
locals, `listener`, `serviceBrowser`, `address`, ADSP, MacTCP: stay
exactly as today — check-clean (reftest fences keep passing), rejected
in lowering with a not-yet-implemented diagnostic.

## 4. Implementation architecture

### Toolbox catalog (fill-the-manager)

- **`toolbox/devices.cla`** — the Device Manager proper: `_Open`
  (0xA000) / `_Close` / `_Read` / `_Write` / `_Control` / `_Status` /
  `_KillIO` sync PB traps plus the `IOParam`/`CntrlParam` extern
  records. Its own file because AppleTalk's drivers (`.MPP`/`.ATP`)
  ride the same manager next phase. Every trap word and struct layout
  verified against Universal Interfaces inline words (the
  `toolbox/files.cla` provenance-comment convention; multiversal
  uncited).
- **`toolbox/serial.cla`** — serial-specific: driver name constants
  (`.AIn`/`.AOut`/`.BIn`/`.BOut`), `SerReset`/`SerSetBuf`/`SerHShake`/
  `SerGetBuf` csCodes, baud/format config-word constants.

### Runtime (datetime-style lane split)

- **`runtime/clarus/conn.cla`** (shared): small fixed connection-slot
  table, per-slot state machine, deferred-event queue, and
  `rtConnPump()` — per open connection: transport-poll available →
  read → fire `received`; detect underlying closure; drain deferred
  `opened`/`failed`.
- **`conn_68k.cla`** (native transport): Device Manager calls through
  the catalog — open both unidirectional drivers, `SerReset` with the
  config word, `SerSetBuf` a generous input buffer (8KB) against pump
  starvation, `SerGetBuf` poll, sync `PBRead`/`PBWrite`.
- **`conn_c.cla`** (host transport): externs onto new C glue
  `runtime/host/rt_serial.inc` — non-blocking TCP listen-or-connect
  per the env var, `select()`-with-timeout wait primitive so the host
  pump doesn't spin.
- Retro68/cprint Mac lane: stub (open always fails) — it is a demoted
  diagnostic lane headed for retirement; real SCC glue there is waste.

### Compiler

- Parser: `serial` contextual keyword inside `open(...)`, joining
  `appletalk`.
- Lowering: receiver-kind-13 method calls (`open`/`send`/`close`) →
  runtime calls carrying the var's slot id; `on conn.<event>` handlers
  → synthesized per-program dispatchers (`clar_conn_fire_*`) in the
  existing reverse-waist family (`lowSynthUiDispatchers` sibling:
  unconditional synthesis, empty switch when no handlers are declared).
  That family is already excluded from baked IR/object code
  (taint-and-discard), so the bake path needs no format change.
- `conn.cla` joins the unconditional runtime superset splice. Known
  consequences, planned not discovered: a one-time golden rebless wave
  (runtime global renumbering — established mechanism), and the
  standing `TestClarusCBakePathOnSnow` rerun (the manifest changes).

### Pump wiring

`rtConnPump()` is called from the Mac UI loop (real and scripted
paths, `rtUiEveryPump`'s sibling) and from the host CLI's new
post-`startCLI` service loop (alive while open-or-pending, per §3).

## 5. Testing

- **T1, host, every task:**
  - Fixtures: bad open spec, send-before-open (`testdata/runerr`),
    emitui/cg68k goldens for the new lowered shapes; reftest green with
    the reference's new serial fences.
  - **Host end-to-end echo** (Go test): build an echo program, run it
    with `CLARUS_SERIAL_MODEM=connect:127.0.0.1:<port>`, assert a full
    0–255 byte sweep round-trips, multiple `received` firings, `closed`
    on peer disconnect, and the lifetime rule (exits when nothing is
    open).
  - **Toolbox-suite case `SerialOpenWrite`**: on a real (emulated) Mac,
    opening the serial drivers succeeds with nothing attached — so the
    existing Mini vMac suite lane can hardware-prove the catalog
    transcription (open, SerReset, write, `SerGetBuf` == 0, close) with
    no bridge at all.
- **Gated Snow acceptance** (`CLARUS_SNOW_TESTS=1`):
  `TestSerialEchoOnSnow` — boot the echo app on Snow with
  `--serial-bridge-a tcp:<port>`, connect from Go, sweep bytes both
  directions byte-exact, send a QUIT command over the wire, assert
  clean exit. Plus the standing-rule `TestClarusCBakePathOnSnow` rerun.
  (Environment note, 2026-08-15: Andrew's `snow/MacII.snoww` workspace
  is preconfigured for the networking arc — TCP:1984 convention on the
  modem port, AppleTalk-over-UDP on the printer port, DaynaPORT SCSI
  Ethernet with NATted MacTCP at 10.0.0.2/gw 10.0.0.1. The serial test
  can keep using the scratch-clone harness with `--serial-bridge-a`;
  the preconfigured image matters from the AppleTalk phase on. Manual
  live checks can use port 1984 to match Andrew's own setup.)
- **Acceptance app** `examples/serialecho.cla`: small UI app (status
  window, byte counters) opening `modem:9600` and echoing; subject of
  the scripted test AND Andrew's manual live check (connect a real
  terminal to the bridge and type).

## 6. Risks

- **Snow SCC fidelity unproven** — the implementation plan starts with
  a probe-wave task (hand-rolled minimal trap-level program through the
  bridge) before the full build-out, per the established Task-1-probe
  pattern.
- **SCC input overflow** if a handler runs long between pumps —
  mitigated by the 8KB `SerSetBuf` at open; the cooperative constraint
  gets documented in the reference.
- **Host pump vs `every` timers**: `every` machinery is UI-runtime-
  entangled today; the host CLI pump services connections only. Not
  promised this phase; recorded.

## 7. Out of scope (this phase)

`listener`/`serviceBrowser`/`address`; ADSP; MacTCP; connection
arrays/record-fields/locals; handshake/flow control, carrier detect,
break signals, non-8N1 framing (catalog escape hatch only); async
completion routines; host PTY mode (TCP only); Mini vMac serial
bridging; `every` in the host CLI pump; new binary language features
(the packers etc. get pulled in only if the echo/BBS work actually
needs them).
