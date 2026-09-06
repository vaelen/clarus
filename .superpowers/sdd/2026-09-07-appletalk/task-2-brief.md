### Task 2: Host LocalTalk-over-UDP stack — `rt_atalk.inc`, unit test, `atalkdrive`

Pure C, no Clarus involvement; runs in parallel with Task 1. Spec §6.1–6.2.

**Files:**
- Create: `runtime/host/rt_atalk.inc`, `runtime/host/rt_atalk_test.c`, `tests/tools/atalkdrive.c`, `tests/hostrt/atalk.sh`, `tests/atalkdrive/{lookup,call}.sh`.
- Modify: `runtime/host/rt.c` (add `#include "rt_atalk.inc"` BEFORE `#include "rt_serial.inc"`, with a comment in the style of the `rt_fileh.inc` one at `rt.c:247-254`).
- Read first: `runtime/host/rt_serial.inc` (whole; the style to match), `runtime/host/rt_serial_test.c:1-60` (CHECK macro, `OK` contract), `tests/tools/tcpdrive.c:1-60` (CLI shape), `tests/hostrt/serial.sh`, `Makefile:1-24`.

**Interfaces:**
- Produces (C, instance API — used by the test and by `atalkdrive`):

```c
typedef struct rt_atalk rt_atalk;
typedef struct { uint16_t net; uint8_t node, socket; } rt_at_addr;
typedef struct { rt_at_addr addr; char obj[33], type[33], zone[33]; } rt_at_tuple;
typedef struct { rt_at_addr from; uint16_t tid; uint8_t bitmap; int xo;
                 int32_t userbytes; uint8_t data[578]; int len; } rt_at_req;

rt_atalk *rt_at_open(const char *iface_ip);   /* NULL + errno on failure; joins the group, acquires a node id */
void      rt_at_close(rt_atalk *a);
int       rt_at_fd(const rt_atalk *a);        /* for select() */
uint8_t   rt_at_node(const rt_atalk *a);
void      rt_at_poll(rt_atalk *a);            /* drain UDP, run retransmit/release timers; never blocks */
/* NBP */
int  rt_at_nbp_register(rt_atalk *a, const char *obj, const char *type, uint8_t socket); /* 0, or -1027 nbpDuplicate */
int  rt_at_nbp_remove(rt_atalk *a, const char *obj, const char *type);                  /* 0, or -1028 */
int  rt_at_nbp_lookup_start(rt_atalk *a, int lk, const char *obj, const char *type, const char *zone); /* lk 0..9 */
int  rt_at_nbp_lookup_done(rt_atalk *a, int lk);                                        /* 1 when the 3x1s window has elapsed */
int  rt_at_nbp_lookup_count(rt_atalk *a, int lk);
const rt_at_tuple *rt_at_nbp_lookup_get(rt_atalk *a, int lk, int i);
/* ATP responder */
int  rt_at_atp_open(rt_atalk *a);                     /* socket 128..254, or negative OSErr */
void rt_at_atp_close(rt_atalk *a, int sock);
int  rt_at_atp_get_request(rt_atalk *a, int sock, rt_at_req *out);   /* 1 if one was dequeued */
int  rt_at_atp_send_response(rt_atalk *a, int sock, const rt_at_req *req, int32_t userbytes, const uint8_t *data, int len); /* len <= 4624 */
/* ATP requester (blocking; internally polls with select) */
int  rt_at_atp_call(rt_atalk *a, rt_at_addr to, int32_t userbytes, const uint8_t *req, int reqlen,
                    uint8_t *resp, int respcap, int *resplen, int32_t *resp_userbytes, int timeout_s, int retries); /* 0, or -1096 reqFailed, -3106 atpLenErr */
```

- Produces (Clarus-facing `rt_ext_AtalkH*` on ONE process-global instance; these are what `atalk_c.cla` declares in Task 7). `string` parameters arrive as `const uint8_t *` Pascal strings (`rt_fileh.inc:44-55`'s `path_to_cstr` idiom); names going back to Clarus are written into caller buffers as Pascal strings:

```c
int32_t rt_ext_AtalkHUp(void);                                  /* lazy rt_at_open(getenv("CLARUS_ATALK_IFACE")); 0 or errno */
int32_t rt_ext_AtalkHNode(void);
int32_t rt_ext_AtalkHRegister(const uint8_t *obj, const uint8_t *type, int32_t sock);
int32_t rt_ext_AtalkHRemove(const uint8_t *obj, const uint8_t *type);
int32_t rt_ext_AtalkHLookupStart(int32_t lk, const uint8_t *obj, const uint8_t *type, const uint8_t *zone);
int32_t rt_ext_AtalkHLookupDone(int32_t lk);
int32_t rt_ext_AtalkHLookupCount(int32_t lk);
int32_t rt_ext_AtalkHLookupAddr(int32_t lk, int32_t i);         /* packed: net<<16 | node<<8 | socket */
void    rt_ext_AtalkHLookupName(int32_t lk, int32_t i, void *out); /* Pascal "obj:type" into a 68-byte buffer */
int32_t rt_ext_AtalkHAtpOpen(void);
void    rt_ext_AtalkHAtpClose(int32_t sock);
int32_t rt_ext_AtalkHAtpGetRequest(int32_t sock, void *buf, int32_t cap); /* len >= 0, or -1 none */
int32_t rt_ext_AtalkHAtpReqOp(void);   int32_t rt_ext_AtalkHAtpReqFrom(void);   /* of the last dequeued request */
int32_t rt_ext_AtalkHAtpSendResponse(int32_t sock, int32_t code, void *buf, int32_t n);
int32_t rt_ext_AtalkHAtpCall(int32_t addr, int32_t op, void *req, int32_t reqLen, void *resp, int32_t respCap); /* resp len, or negative OSErr */
int32_t rt_ext_AtalkHAtpCallCode(void);
void    rt_ext_AtalkHPoll(void);
int32_t rt_ext_AtalkHFd(void);                                   /* -1 when the stack is down; rt_ext_ConnHIdle adds it to its select set */
```

- Wire formats (Inside AppleTalk 2nd ed.; Task 1's recorded frames are the oracle): LToUDP datagram = 4-byte sender id + LLAP frame `dst node, src node, LLAP type, payload`; LLAP types 1 (short DDP), 2 (long DDP), $81 `lapENQ`, $82 `lapACK`. Short DDP header (5 bytes): `[hop/len hi][len lo][dst socket][src socket][DDP type]`, length = header + data, data ≤ 586. DDP types: 2 NBP, 3 ATP, 6 ZIP, 7 ADSP. NBP header: `[func<<4 | tuple count][NBP id]` then tuples `AddrBlock(4) enumerator(1) obj type zone` (packed Pascal); functions 1 BrRq, 2 LkUp, 3 LkUp-Reply, 4 FwdReq; lookups go to node 255 socket 2 (NIS). ATP header (8 bytes): `[control: func<<6 | XO 0x20 | EOM 0x10 | STS 0x08][bitmap/seq][TID hi][TID lo][userbytes ×4]`, func 1 TReq, 2 TResp, 3 TRel; response packets carry ≤ 578 data bytes, ≤ 8 per transaction; the requester's TReq bitmap has bit *n* set for each response packet still wanted; the responder sets EOM on its last packet.

- [ ] **Step 1: Write the failing unit test**

`runtime/host/rt_atalk_test.c`, `rt_serial_test.c`'s CHECK style, printing `OK` at the end. Two instances `a`/`b` from `rt_at_open(NULL)` (skips with `OK` after printing `SKIP: multicast unavailable` if both opens fail with `errno` `ENODEV`/`EADDRNOTAVAIL` — a sandbox without multicast must not fail the gate). Cases:
1. `rt_at_node(a) != rt_at_node(b)`, both in 1..127.
2. Forced collision: a private test hook `rt_at_test_force_node(b, rt_at_node(a))` re-acquires and ends on a different id (so `lapENQ`/`lapACK` work).
3. NBP: register `("Unit-<pid>", "ClarusTest", sock 200)` on `a`; lookup `("=", "ClarusTest", "*")` from `b` → at least one tuple whose obj matches; duplicate register on `b` → `-1027`; remove → later lookup finds none with that obj.
4. ATP: `sock = rt_at_atp_open(a)`; from `b`, `rt_at_atp_call(a's addr/sock, userbytes 7, "ping", 4, ...)` in a thread-free way: the test drives `a` by calling `rt_at_poll(a)` + `rt_at_atp_get_request` from a callback hook `rt_at_test_idle_hook(fn)` that `rt_at_atp_call`'s internal wait loop invokes each iteration; the hook answers with `userbytes 9` and a 4000-byte response (≥ 7 packets). Assert `resplen == 4000`, bytes are `i & 0xFF`, `resp_userbytes == 9`.
5. Dropped packet: `rt_at_test_drop_next_tx(a, 3)` (drop the 4th outgoing datagram once) → the call still succeeds (bitmap retransmit).
6. XO duplicate replay: `rt_at_test_drop_next_rx(a, RT_AT_DROP_TREL)` makes `a` ignore the next TRel it receives, so the completed transaction stays in `a`'s XO list; then `rt_at_test_resend_last_treq(b)` re-injects `b`'s last TReq verbatim, and `a` must answer it from the list — the test's idle hook counts `rt_at_atp_get_request` successes and asserts the count is still 1 while `b` received a full second response.
7. Oversize: `reqlen 579` → `-3106`; `rt_at_atp_send_response` with `len 4625` → `-3106`.
8. Idle wake: `select` on `rt_at_fd(a)` with a 2 s timeout returns > 0 within 100 ms after `b` sends a lookup.

Run: `cc -std=c99 -Wall -Werror -I runtime/host runtime/host/rt_atalk_test.c runtime/host/rt.c -o /tmp/atalktest && /tmp/atalktest`. Expected: compile failure (no `rt_at_*` yet).

- [ ] **Step 2: Implement `rt_atalk.inc`**

Sections, in this order, each with a header comment: (a) constants and the instance struct (fd, sender id, node, per-`lk` lookup slots ×10 with tuple arrays of 32, names table ×4, ATP sockets ×4 each with a request queue of 4 `rt_at_req`, an XO transactions list of 8 `{tid, from, response copy, expiry}`, and a requester state); (b) LToUDP I/O: `rt_at_tx(a, dst, type, payload, len)` prepends sender id + LLAP header, `sendto` the group; `rt_at_rx` drops own sender id, frames not for our node or broadcast (255); (c) LLAP node acquisition: random id 1–127, send `lapENQ` 3× at 20 ms apart, on any `lapACK` pick another id, at most 20 tries → `EADDRINUSE`; answer `lapENQ` for our id with `lapACK` forever after; (d) DDP short header encode/decode, dynamic socket allocation 128–254; (e) NBP: local names table answers `LkUp` (function 2) whose obj/type/zone match (case-insensitive, `=` full wildcard, `*` zone) with a `LkUp-Reply` (function 3) to the requester's socket; `lookup_start` broadcasts `LkUp` to 255/2 three times 1 s apart, replies accumulate de-duplicated by (addr, enumerator), `lookup_done` after 3 s; `register` does a verify lookup first and refuses on a match; (f) ATP requester: TID counter, TReq with XO, bitmap = (1<<n)-1 for n=8, resend every `timeout_s` with the bitmap of missing packets, up to `retries`; assemble by sequence number; on completion send TRel; (g) ATP responder: TReq → if TID in XO list, replay stored packets; else enqueue for `get_request` (drop with STS unused if the queue is full); `send_response` splits into ≤ 8 packets of ≤ 578, EOM on the last, stores a copy in the XO list with a 30 s expiry; TRel removes; `rt_at_poll` expires; (h) the `rt_ext_AtalkH*` layer over a static `rt_at_global` instance with `CLARUS_ATALK_IFACE`, plus `rt_ext_AtalkHFd`. Test hooks under `#ifdef RT_ATALK_TEST_HOOKS` (the test defines it before including `rt.h`? — no: `rt.c` is compiled separately; expose the hooks unconditionally but prefixed `rt_at_test_`, documented as test-only).

- [ ] **Step 3: Run the unit test to green; add `tests/hostrt/atalk.sh`**

```sh
#!/bin/sh
# hostrt/atalk -- compile rt_atalk_test.c against rt.c (which #includes
# rt_atalk.inc) and run it: two LToUDP stack instances on loopback
# multicast. Prints OK (or SKIP: multicast unavailable, still OK).
. "$(dirname "$0")/../lib.sh" || exit 2
run_c_test runtime/host/rt_atalk_test.c || die "rt_atalk_test"
```
Run: `make test T=hostrt/atalk`. Expected: `PASS hostrt/atalk`.

- [ ] **Step 4: `atalkdrive`**

`tests/tools/atalkdrive.c`: `#include "../../runtime/host/rt_atalk.inc"` is not possible (it depends on `rt.h`); instead compile it as `$(CC) -std=c99 -Wall -Werror -I runtime/host -o $@ $< runtime/host/rt.c` — add a Makefile rule specialization for this one tool (`$(BR)/tools/atalkdrive: tests/tools/atalkdrive.c runtime/host/rt.c $(RT_HOST)`) above the generic `$(BR)/tools/%` rule. CLI:

```
atalkdrive lookup TYPE [ZONE]            -> one line per tuple: "net.node.socket obj:type@zone"; exit 0
atalkdrive register OBJ TYPE SECS        -> registers on a fresh ATP socket, prints "registered node=N sock=S", idles SECS, removes
atalkdrive call OBJ TYPE OP [--timeout S] [--retries N]   -> request = stdin, reply -> stdout, "code N" -> stderr; exit 0 ok, 3 on code!=0 (still prints reply), 1 on reqFailed
atalkdrive serve OBJ TYPE SECS SCRIPT    -> registers + serves for SECS; SCRIPT lines "OP CODE REPLYFILE" map an op to a reply (unknown op -> code -1 empty); logs "request op=N len=L from=A" per request to stderr
```
`tests/atalkdrive/lookup.sh`: `register` in the background for 8 s, `lookup` finds the name (skip on multicast unavailable: `atalkdrive` exits 77 with `SKIP: ...` when `rt_at_open` fails; the script propagates with `skip`). `tests/atalkdrive/call.sh`: `serve` with a script mapping op 1 → code 0 `reply.bin` (a 0–255 sweep ×16 = 4096 bytes) and op 2 → code 5 empty; `call ... 1` returns the sweep byte-exact; `call ... 2` exits 3 with `code 5`; `call` to a bogus name exits 1 within 8 s. Run: `make -j tools && make test T=atalkdrive/`. Expected: both PASS.

- [ ] **Step 5: T1 + commit**

Run: `scripts/test-task.sh --smoke` (touches `runtime/`). Expected: PASS, zero golden churn.
```bash
git add runtime/host/rt_atalk.inc runtime/host/rt_atalk_test.c runtime/host/rt.c tests/tools/atalkdrive.c Makefile tests/hostrt/atalk.sh tests/atalkdrive/
git commit -m "feat(host): LocalTalk-over-UDP stack (LLAP/DDP/NBP/ATP) with unit test and atalkdrive tool"
```

---

