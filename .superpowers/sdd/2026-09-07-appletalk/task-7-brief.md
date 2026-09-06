### Task 7: Runtime `atalk.cla` + `atalk_c.cla` (host, complete) + `atalk_68k.cla` (stubs), host splice

Spec §5.2–5.7 lane-neutral logic, §6 host twin. Dormant: nothing lowers to it yet (Task 8). Host-lane spliced under `usesConn or usesAtalk`; NOT on the 68k lane (Task 9). Zero native churn.

**Files:**
- Create: `runtime/clarus/atalk.cla`, `runtime/clarus/atalk_c.cla`, `runtime/clarus/atalk_68k.cla`.
- Modify: `clarusc/drive.cla:1628-1654` (host splice) and `2138-2140` (rtbake fallback).
- Create: `tests/atalk/splice.sh`.
- Read first: `runtime/clarus/conn.cla`, `conn_c.cla` (whole), `runtime/clarus/text.cla:534-558` (`rtTextFromBytes`), `core.cla:59-71` (`rtSetLastErr`), `fileh.cla:318` (`list of string` out-param precedent), Task 2's `rt_ext_AtalkH*` block.

**Interfaces:**
- Produces (`atalk.cla`, lane-neutral; `h` is the 1-based handle, `slot = h - 1`, `h == 0` → `rtPanic("use of nil <kind>")`):

```
const rtLsnMax: int = 2      const rtBrsMax: int = 2      const rtSvcMax: int = 2
const rtAtLookupMax: int = 10   // lookup slots: 0-1 browsers, 2-9 connection opens (conn slot + 2)
const rtAtErrNoHost: int = -1273   // errOpenDenied reused: "streams not available on this lane"
// globals (parallel fixed arrays; the COMPLETE table, never grown later):
var rtAtUp: bool
var rtLsnState: int[2]; var rtLsnPendFailedCode: int[2]; var rtLsnPendFailedMsg: string[2]
var rtBrsState: int[2]; var rtBrsPendFailedCode: int[2]; var rtBrsPendFailedMsg: string[2]; var rtBrsPendDone: bool[2]
var rtSvcState: int[2]; var rtSvcSock: int[2]; var rtSvcInHandler: bool[2]; var rtSvcReplied: bool[2]
var rtSvcPendFailedCode: int[2]; var rtSvcPendFailedMsg: string[2]
var rtAdspPhase: int[8]     // 0 none, 1 lookup pending, 2 open pending, 3 open  (conn slots)
var rtConnSlotTransport: int[8]   // 0 serial (or unused), 1 ADSP -- read by conn.cla from Task 9 on
var rtAtLastErr: int
// dispatchers (bare externs, synthesized by Task 8):
external func clar_lsn_fire_accepted(slot: int, c: int)
external func clar_lsn_fire_failed(slot: int, code: int, msg: string)
external func clar_brs_fire_found(slot: int, name: string, addr: int)
external func clar_brs_fire_done(slot: int)
external func clar_brs_fire_failed(slot: int, code: int, msg: string)
external func clar_svc_fire_request(slot: int, op: int, req: text, from: int)
external func clar_svc_fire_failed(slot: int, code: int, msg: string)
// API called by lowering:
func rtLsnRegister(h: int, name: string, typ: string)
func rtLsnStop(h: int)
func rtBrsFind(h: int, typ: string, zone: string)          // lowering passes "*" for the 1-arg form
func rtBrsZones(h: int, out: list of string)
func rtSvcServe(h: int, name: string, typ: string)
func rtSvcReply(h: int, code: int, data: text)
func rtSvcReplyStr(h: int, code: int, s: string)
func rtSvcStop(h: int)
func rtSvcCallAddr(h: int, addr: int, op: int, req: text, reply: text): bool
func rtSvcCallName(h: int, name: string, op: int, req: text, reply: text): bool   // "Name:Type" -> sync lookup first
func rtAtalkAddrStr(addr: int): string            // "net.node.socket"
func rtAtalkPump()
func rtAtalkAlive(): bool                          // any service open, browser searching, listener registered, or event pending
// ADSP waist used by conn.cla (Task 9): 
func rtAdspOpenName(slot: int, spec: string): int  // starts lookup on lookup slot slot+2; 0 ok
func rtAdspOpenAddr(slot: int, addr: int): int
func rtAdspPoll(slot: int): int                    // 1 became open, 0 pending, <0 failed (error code)
func rtAdspAvail(slot: int): int;  func rtAdspReadInto(slot: int, t: text): int   // reads min(avail, 1024) bytes into the scratch buffer with ONE rtAdspDevRead, then appends them to t (t.append(char(peekb(scratch + i))) -- one Toolbox call per chunk instead of conn.cla's one per byte; rtTextFromBytes takes a raw ptr and is not reachable from a text value, so the per-byte append stays)
func rtConnOpenAddr(h: int, addr: int)             // connection.open(addr): sets rtConnSlotTransport[slot] = 1, rtAdspOpenAddr; the pump fires opened/failed
func rtAdspWrite(slot: int, p: ptr, n: int): int;  func rtAdspClose(slot: int);  func rtAdspGone(slot: int): bool
```
Per-lane waist (`atalk_c.cla` real over `AtalkH*`; `atalk_68k.cla` stubs this task, real in Task 9 — same names):
```
func rtAtDevUp(): int
func rtAtDevRegister(obj: string, typ: string, sock: int): int
func rtAtDevRemove(obj: string, typ: string): int
func rtAtDevLookupStart(lk: int, obj: string, typ: string, zone: string): int
func rtAtDevLookupDone(lk: int): bool
func rtAtDevLookupCount(lk: int): int
func rtAtDevLookupAddr(lk: int, i: int): int
func rtAtDevLookupName(lk: int, i: int): string      // "obj:type"
func rtAtDevZones(out: list of string): int          // 0, or an OSErr (noBridgeErr on the host, always); atalk.cla substitutes ["*"] on any error
func rtAtDevAtpOpen(): int                           // socket > 0, or 0 with rtAtDevLastErr()
func rtAtDevAtpClose(sock: int)
func rtAtDevAtpArm(slot: int, sock: int): int        // (re)issue the async get-request for service slot
func rtAtDevAtpPoll(slot: int): int                  // 1 request ready, 0 pending, <0 error
func rtAtDevAtpReqOp(slot: int): int;  func rtAtDevAtpReqFrom(slot: int): int
func rtAtDevAtpReqLen(slot: int): int; func rtAtDevAtpReqPtr(slot: int): ptr
func rtAtDevAtpRespond(slot: int, code: int, p: ptr, n: int): int   // copies p[0..n) into the slot reply buffer, sends (async natively)
func rtAtDevAtpRespBusy(slot: int): bool
func rtAtDevAtpCall(addr: int, op: int, req: ptr, reqLen: int): int   // sync; resp len >= 0 or negative OSErr
func rtAtDevAtpCallCode(): int;  func rtAtDevAtpCallPtr(): ptr
func rtAtDevLastErr(): int
func rtAtDevPoll()                                    // host: AtalkHPoll(); native: no-op
// ADSP + listener dev layer (host twin: every function returns rtAtErrNoHost / false / 0):
func rtAdspDevOpen(slot: int, addr: int): int;  func rtAdspDevOpenPoll(slot: int): int
func rtAdspDevAvail(slot: int): int;  func rtAdspDevRead(slot: int, p: ptr, n: int): int
func rtAdspDevWrite(slot: int, p: ptr, n: int): int;  func rtAdspDevClose(slot: int);  func rtAdspDevGone(slot: int): bool
func rtLsnDevInit(slot: int): int;  func rtLsnDevListen(slot: int): int;  func rtLsnDevPoll(slot: int): int
func rtLsnDevAccept(slot: int, connSlot: int): int;  func rtLsnDevDeny(slot: int): int;  func rtLsnDevRemove(slot: int)
func rtLsnDevSocket(slot: int): int                  // the listener's DDP socket after Init (for the NBP registration); host stub returns 0
```
- `atalk_c.cla` externs (family prefix `AtalkH`, one per Task 2 `rt_ext_AtalkH*`): `AtalkHUp(): int`, `AtalkHNode(): int`, `AtalkHRegister(obj: string, typ: string, sock: int): int`, `AtalkHRemove(obj: string, typ: string): int`, `AtalkHLookupStart(lk: int, obj: string, typ: string, zone: string): int`, `AtalkHLookupDone(lk: int): int`, `AtalkHLookupCount(lk: int): int`, `AtalkHLookupAddr(lk: int, i: int): int`, `AtalkHLookupName(lk: int, i: int, out: ptr)`, `AtalkHAtpOpen(): int`, `AtalkHAtpClose(sock: int)`, `AtalkHAtpGetRequest(sock: int, buf: ptr, cap: int): int`, `AtalkHAtpReqOp(): int`, `AtalkHAtpReqFrom(): int`, `AtalkHAtpSendResponse(sock: int, code: int, buf: ptr, n: int): int`, `AtalkHAtpCall(addr: int, op: int, req: ptr, reqLen: int, resp: ptr, respCap: int): int`, `AtalkHAtpCallCode(): int`, `AtalkHPoll()`. Scratch buffers via `SerNewPtr`/`SerDisposePtr` (already-spliced `ser.cla` externs, the `conn.cla` precedent) — a 600-byte request scratch and a 4700-byte response scratch allocated once (`ptr` globals in `atalk_c.cla`: `rtAtCReqBuf: ptr[2]`, `rtAtCRespBuf: ptr`, `rtAtCNameBuf: ptr`).
- Semantics to implement in `atalk.cla` (from the spec): `rtSvcServe` → `rtAtDevUp` (failure → pending failed `"AppleTalk unavailable"`), `rtAtDevAtpOpen`, `rtAtDevRegister(name, typ, sock)` (−1027 → pending failed `"name in use"`), `rtAtDevAtpArm`; state open. `rtAtalkPump`: `rtAtDevPoll()`; per service slot: drain pending failed; if open and not `RespBusy` and `AtpPoll == 1`: build the `req` text by appending `ReqLen` bytes from `ReqPtr` (`t.append(char(peekb(p + i)))`, at most 578 iterations), set `InHandler`, `Replied = false`, fire `clar_svc_fire_request(slot, op, req, from)`, then if not `Replied` → `rtAtDevAtpRespond(slot, -1, ptr(0), 0)`; clear `InHandler`; re-arm only when `RespBusy` is false (checked each pass). `rtSvcReply`: `not InHandler` → `rtPanic("reply outside a request handler")`; `Replied` → `rtPanic("reply already sent")`; `data.length > 4624` → pending failed `"reply too long"` + automatic −1 reply; else copy the text's bytes into a `SerNewPtr` scratch with the `pokeb` loop `rtConnSendText` uses and call `AtpRespond` (which copies again into the slot's reply buffer, so the scratch is disposed right after). `rtSvcCallAddr`: `req.length > 578` → `rtSetLastErr(-3106, "request too long")`, false; `n = rtAtDevAtpCall(addr, op, reqPtr, len)`; `n < 0` → `rtSetLastErr(n, "no response")`, false; `code = AtpCallCode()`; empty `reply` (`reply.clear()`) and append `n` bytes from `CallPtr` with the same per-byte loop; `code != 0` → `rtSetLastErr(code, "service")`, false; else true. `rtSvcCallName`: split at the first `:` (obj, type); `rtAtDevLookupStart(lk = 2 + ?)` — sync: use lookup slot 9 reserved for name-calls, spin `while not LookupDone { rtAtDevPoll() }` (host) / Toolbox sync lookup (native handles inside `LookupStart` returning done immediately), count 0 → `rtSetLastErr(-1025, "name not found")`. `rtBrsFind`: parse `typ`; `LookupStart(slot, "=", typ, zone)`; state searching. Pump: when `LookupDone`, fire `found` per tuple (`name = LookupName`, `addr`), then `done`, state idle. `rtBrsZones`: `out.clear()`; `rtAtDevZones(out)`; on `noBridgeErr`/`reqFailed`/any error → `out.clear(); out.add("*")`. `rtLsnRegister`: `rtAtDevUp`, `rtLsnDevInit(slot)` (rtAtErrNoHost → pending failed `"streams not available on this lane"`), `rtAtDevRegister(name, typ, listenerSocket)`, `rtLsnDevListen`. Pump: `rtLsnDevPoll == 1` → find a free conn slot (`rtConnState[i] == stClosed` — conn.cla's arrays; conn.cla is always spliced alongside), `rtLsnDevAccept(slot, i)` → set `rtConnState[i] = stOpen`, `rtConnSlotTransport[i] = 1` (declared in `atalk.cla`'s global table as `var rtConnSlotTransport: int[8]`, so `conn.cla` can read it in Task 9 without gaining a global of its own), fire `clar_lsn_fire_accepted(slot, i + 1)`; no free slot → `rtLsnDevDeny`; re-listen. `rtAdsp*`: thin state machine over `rtAdspDev*` + lookup slot `slot + 2`.

- [ ] **Step 1: Write the three modules** per Interfaces (stubs in `atalk_68k.cla` return `rtAtErrNoHost`/false/0 — Task 9 replaces bodies only).
- [ ] **Step 2: Splice** — `drive.cla` host branch becomes `else if usesConn or usesAtalk { conn.cla, conn_c.cla, atalk.cla, atalk_c.cla }`; the rtbake fallback condition gains `or ((usesConn or usesFileh or usesAtalk) and not want68k)` (spec §7, TODO fix (b)) with the log line `"clarusc --rtbake: host program uses connection/filehandle/AppleTalk; falling back to a from-source compile"`. Do NOT touch the `want68k` branch or `bake.cla`.
- [ ] **Step 3: `tests/atalk/splice.sh`** — `host_build` a program that only declares `var s: service` and `var b: serviceBrowser` (no method calls; `on App.startCLI` logs and quits): assert the build succeeds and the emitted C defines `clar_fn_rtAtalkPump` and `clar_fn_rtSvcServe` (the splice happened and every module function compiles on the host). Also `emit --rtbake` of the same program against a fresh C-lane bake: assert the log contains `falling back` and the output compiles (the C-lane gap's closing test). Also build `tests/conntest/testdata/echo.cla` (serial only) and assert it still runs (`make test T=conntest/connect`) — conn programs now carry `atalk.cla` too. Regenerate `testdata/emitui/connpump_abort.c.golden` if its emission changed (it will: the extra module's functions); quote the diff summary in the report.
- [ ] **Step 4: Gate + commit** — `make test T=atalk/ T=conntest/ T=emitui/ T=bake/`, then `scripts/test-task.sh --smoke`. Expected: zero cg68k churn (68k lane untouched).
```bash
git add runtime/clarus/atalk.cla runtime/clarus/atalk_c.cla runtime/clarus/atalk_68k.cla clarusc/drive.cla tests/atalk/splice.sh testdata/emitui/
git commit -m "feat(runtime): atalk.cla with host twin over the LToUDP stack; host splice; rtbake C-lane fallback"
```

---

