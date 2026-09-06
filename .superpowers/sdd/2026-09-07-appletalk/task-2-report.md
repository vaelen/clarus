# Task 2 report — Host LocalTalk-over-UDP stack (`rt_atalk.inc`, unit test, `atalkdrive`)

**Status:** DONE
**Worktree:** `/Users/andrew/repos/clarus-wt/t2` (branch `appletalk-t2`)
**Commit:** `7d2add1` feat(host): LocalTalk-over-UDP stack (LLAP/DDP/NBP/ATP) with unit test and atalkdrive tool

## What was implemented

### `runtime/host/rt_atalk.inc` (1226 lines), `#include`d from `rt.c`

The eight sections the brief listed, in order, each with its header comment:

- **(a) constants + instance struct.** `rt_atalk` is heap-allocated by `rt_at_open`
  (instance-able so two peers live in one process): fd, 4-byte LToUDP sender id,
  node, 11 lookup slots (0..9 public + slot 10 as `register`'s private verify
  lookup), a 4-entry names table, 4 ATP sockets each with a 4-deep request queue
  and an 8-entry XO transaction list, and one requester state.
- **(b) LToUDP I/O.** `rt_at_tx` prepends the sender id + LLAP header (`dst, src,
  type`) and `sendto`s the group; `rt_at_drain` reads to `EAGAIN`, drops our own
  sender id, and drops frames addressed to neither our node nor 255.
- **(c) LLAP node acquisition.** Random 1..127, `lapENQ` ×3 at 20 ms, any `lapACK`
  (or a competing `lapENQ` for the same candidate mid-acquisition) moves us on;
  20 tries then `EADDRINUSE`. After acquisition a `lapENQ` for our node is
  answered with `lapACK` forever.
- **(d) DDP.** Short header on send (net 0, no checksum); long headers accepted on
  receipt. Dynamic socket allocation 128..254.
- **(e) NBP.** Local names table answers `LkUp`/`BrRq` with a `LkUp-Reply` (obj/type
  matched case-insensitively, `=` full wildcard, zone `*`); `lookup_start`
  broadcasts to 255/2 three times 1 s apart with de-duplicated reply collection
  and a 3 s window; `register` runs a verify-lookup first and returns `-1027` on a
  match.
- **(f) ATP requester.** TID counter, XO `TReq` with bitmap `0xFF`, retransmit each
  `timeout_s` carrying the bitmap of the packets still missing, assembly by
  sequence number, `TRel` on completion.
- **(g) ATP responder + `rt_at_poll`.** A `TReq` whose (TID, peer) is in the XO list
  is replayed from it; a `TReq` already in the queue is recognised as a retransmit;
  otherwise it is enqueued (a full queue drops, the peer retransmits).
  `send_response` splits into ≤ 8 packets of ≤ 578 with EOM on the last and stores
  the copy with a 30 s expiry; `TRel` removes it; `rt_at_poll` expires it.
- **(h) `rt_ext_AtalkH*`.** All 19 wrappers over one lazily opened process-global
  instance, `CLARUS_ATALK_IFACE` honoured, Pascal-string arguments, addresses
  packed `net<<16 | node<<8 | socket`, `"obj:type"` written back as a Pascal string.

Multicast setup is exactly as the controller specified: bind `INADDR_ANY:1954`
with `SO_REUSEADDR` + `SO_REUSEPORT`, `IP_ADD_MEMBERSHIP` on 239.192.76.84,
`IP_MULTICAST_LOOP` = 1, `IP_MULTICAST_IF` only when an interface is named.

### Interfaces — completeness check

Every symbol in the brief's Interfaces block is present with the exact signature:
`rt_at_open/close/fd/node/poll`, `rt_at_nbp_register/remove/lookup_start/
lookup_done/lookup_count/lookup_get`, `rt_at_atp_open/close/get_request/
send_response/call`, and all 19 `rt_ext_AtalkH*` (`Up, Node, Register, Remove,
LookupStart, LookupDone, LookupCount, LookupAddr, LookupName, AtpOpen, AtpClose,
AtpGetRequest, AtpReqOp, AtpReqFrom, AtpSendResponse, AtpCall, AtpCallCode, Poll,
Fd`). Test hooks: `rt_at_test_force_node/idle_hook/drop_next_tx/drop_next_rx/
resend_last_treq`.

### Deviations from the brief (all deliberate, all noted in the code)

1. **New file `runtime/host/rt_atalk.h` (89 lines).** `rt_atalk_test.c` and
   `tests/tools/atalkdrive.c` both link `rt.c` and both need `rt_at_req` /
   `rt_at_tuple` / `rt_at_addr`. Three hand-copied struct definitions is a silent
   ABI bug waiting to happen, so the layouts and the `rt_at_*` prototypes live in
   one header included by all three. The `rt_ext_AtalkH*` symbols are still *not*
   declared there — they keep `rt.h`'s "callers declare their own extern" rule.
2. **`#include "rt_atalk.inc"` goes last in `rt.c`,** after `rt_serial.inc` and
   `rt_fileh.inc` — the controller's ownership ruling. `rt_ext_ConnHIdle` is
   untouched (Task 4 owns `rt_serial.inc`); only `rt_ext_AtalkHFd()` is provided,
   with a comment saying a later task wires it into the pump's select set.
3. **`rt_at_test_resend_last_treq` takes out-params** — `(rt_atalk *a, uint8_t
   *resp, int respcap, int *resplen)`. The brief wrote a bare `(b)`, but the test
   has to observe that B received a full second response, which needs the
   response back.
4. **`tests/hostrt/atalk.sh` does not use `run_c_test`.** `run_c_test` captures
   `2>&1` and demands stdout be exactly `OK`, so a binary that prints a skip
   diagnostic can never skip through it. The test instead exits **77** with
   `SKIP: multicast unavailable (<reason>)` and the script propagates it with
   `skip`. The compile line in the script is `run_c_test`'s, verbatim
   (`-std=c99 -Wall -Werror`).
5. **NBP `register`'s verify-lookup uses a 3 × 250 ms window,** not the public
   3 × 1 s one — a register that blocked for 3 s would make every service start
   feel broken. The public `lookup_start` window is unchanged.
6. **Lookup de-duplication is by (address, obj, type)** rather than (address,
   enumerator): the name is the finer key and it survives a peer that
   re-registers with a fresh enumerator mid-window.

### `tests/tools/atalkdrive.c` (250 lines) + Makefile rule

All four verbs per the brief's grammar: `lookup TYPE [ZONE]`, `register OBJ TYPE
SECS`, `call OBJ TYPE OP [--timeout S] [--retries N]`, `serve OBJ TYPE SECS
SCRIPT`. Exit codes 0 ok / 1 transaction failed / 2 usage / 3 nonzero response
code / 77 `SKIP: multicast unavailable`. The Makefile gets an explicit rule
*above* the generic `$(BR)/tools/%` one:

```make
$(BR)/tools/atalkdrive: tests/tools/atalkdrive.c runtime/host/rt.c $(RT_HOST)
	@mkdir -p $(BR)/tools
	$(CC) -std=c99 -Wall -Werror -I runtime/host -o $@ $< runtime/host/rt.c
```

`make -j tools` still builds all six tools.

## Tests and results

| Test | Result |
|---|---|
| `hostrt/atalk` | PASS 15s |
| `atalkdrive/lookup` (2 subcases) | PASS 4s |
| `atalkdrive/call` (4 subcases) | PASS 12s |
| `make -j t1` | **91 passed, 30 skipped, 0 failed** |

`hostrt/atalk` covers all eight cases the brief listed plus a ninth:
1. `rt_at_node(A) != rt_at_node(B)`, both 1..127.
2. `rt_at_test_force_node(B, node(A))` ends on a different id (proves
   `lapENQ`/`lapACK`).
3. NBP register / `=`-wildcard lookup / duplicate `-1027` / remove `0` / second
   remove `-1028` / post-remove lookup finds nothing.
4. 4000-byte ATP transaction (7 packets): length, every body byte, response user
   bytes 9, request user bytes 7, exactly one `get_request`.
5. `drop_next_tx(A, 3)` — the bitmap retransmit still brings it home.
6. XO duplicate replay: `drop_next_rx(A, RT_AT_DROP_TREL)` then
   `resend_last_treq(B)` — B gets a full second response while A's
   `get_request` count stays at 1.
7. Oversize: `reqlen 579` → `-3106`; `send_response len 4625` → `-3106`.
8. `select()` on `rt_at_fd(A)` wakes in well under 500 ms on B's lookup.
9. (added) The `rt_ext_AtalkH*` layer end to end on a third, process-global
   instance: `Up` (and its idempotence), `Node`, `Fd`, `LookupStart/Done/Count/
   Addr/Name`, the packed address decomposed back to net 0 / A's node / socket
   200, and `"obj:ClarusTest"` as a Pascal string. Nothing else exercises the
   shim Task 7 will call, and it is where the Pascal-string and packing bugs
   live.

`atalkdrive/lookup`: a `register` process for 8 s, a separate `lookup` process
must see `OBJ:TYPE`. `atalkdrive/call`: a `serve` process with a two-op script,
then op 1 → a byte-exact 4096-byte reply (8 ATP packets), op 2 → exit 3 with
`code 5`, and a call to an unregistered name → exit 1 in under 8 s.

Both groups were run 3× back to back with no flakiness; `hostrt/atalk` 5× on its
own. Names carry the pid throughout and nothing asserts an entity count, so the
live emulator sessions / EtherTalk bridge on the same group cannot break them.

## TDD evidence

**RED** — `cc -std=c99 -Wall -Werror -I runtime/host runtime/host/rt_atalk_test.c runtime/host/rt.c -o /tmp/atalktest`:

```
Undefined symbols for architecture arm64:
  "_rt_at_atp_call", referenced from: _test_atp ... _one_call ...
  "_rt_at_atp_close", ... "_rt_at_atp_get_request", ... "_rt_at_atp_open", ...
  "_rt_at_atp_send_response", ... "_rt_at_close", ... "_rt_at_fd", ...
  "_rt_at_nbp_lookup_count", ...   (every rt_at_* symbol)
```

**First run after implementing** (one real defect found, not a spurious green):

```
FAIL: XO replay reached get_request instead of the XO list (rt_atalk_test.c:212)
FAILED
```

Diagnosed with temporary `DBG TREQ`/`DBG TREL` traces: the drop-TRel hook was
consuming the *previous* case's TRel, because `rt_at_atp_call` returns the instant
it sends its own TRel and A had not polled yet. Fixed in the test (a `pump(100)`
settle at the end of `one_call`, commented as such) — the stack itself was right.

**GREEN** — `/tmp/atalktest` → `OK`, exit 0, ~13 s.

**Mutation check on the new case 9** (`(addr & 0xFF) == 200` → `201`):

```
FAIL: packed address has the wrong socket (/tmp/mut.c:317)
FAILED
```

— i.e. the added assertions really run and really assert.

## Files changed

| File | |
|---|---|
| `runtime/host/rt_atalk.inc` | new, 1226 lines |
| `runtime/host/rt_atalk.h` | new, 89 lines (see deviation 1) |
| `runtime/host/rt_atalk_test.c` | new, 364 lines |
| `runtime/host/rt.c` | +9 (the `#include` and its comment, at the end) |
| `tests/tools/atalkdrive.c` | new, 250 lines |
| `Makefile` | +7 (the `atalkdrive` rule above the generic one) |
| `tests/hostrt/atalk.sh` | new, 27 lines |
| `tests/atalkdrive/lookup.sh` | new, 60 lines |
| `tests/atalkdrive/call.sh` | new, 92 lines |

## Self-review findings (fixed before commit)

- `rt_at_xo` initially reused the *peer's* socket as the source socket when
  replaying — wrong sender. Added `mysock` to the XO entry.
- `if (seq < 0 …)` on a `uint8_t`-derived value was dead; removed.
- An unused `enumerator` local in the NBP parser (`-Wunused-but-set-variable`
  once the dedup key changed); removed with a comment marking the wire field.
- Added `<time.h>` rather than relying on `rt.c`'s transitive includes for `time()`.
- `awk 'printf "%c"'` for the 4096-byte sweep emitted UTF-8 above 127; replaced
  with a `printf` octal-escape loop. `$(wc -c < f)` keeps macOS's leading spaces,
  so the size assertion needed `| tr -d ' '`.
- `sleep 0.2` had no precedent in `tests/` and POSIX only defines integer
  seconds; both scripts now poll with `sleep 1`.

## Checks

- `-std=c99 -Wall -Werror` clean for `rt.c` (with the new `.inc`), the unit test,
  and `atalkdrive`.
- The Retro68/cprint Mac lane is unaffected: `scripts/build-mac.sh` compiles
  `runtime/mac/rt_mac.c`, never `runtime/host/rt.c`, so the new socket code cannot
  reach a 68k build.
- `tests/runner/syntax.sh` (`sh -n` over every `tests/**/*.sh`) passes in T1.
- YAGNI: no ADSP (DDP type 7 dropped), no extended DDP header on send, no router
  or ZIP support, no zone list.
- `rt_atalk.inc` is 1226 lines, under the 1500-line split threshold.

## Concerns

1. **`hostrt/atalk` costs ~15 s of T1** (three 3 s NBP windows plus three 0.75 s
   register verifies). It is the slowest host test now. Trimming to one public
   lookup would save ~6 s if the controller wants T1 tighter.
2. **The tests need working loopback multicast.** They pass here; a CI sandbox
   without it will SKIP (exit 77) rather than fail, and `atalkdrive` does the
   same. But that means a broken stack in such an environment reports SKIP, not
   FAIL — the usual cost of a gated lane.
3. **`rt_ext_AtalkHFd()` is not yet in any select set** (controller ruling: Task 4
   owns `rt_serial.inc`). Until a later task wires it into `rt_ext_ConnHIdle`,
   host AppleTalk latency is bounded by the pump's 20 ms idle, not by traffic.
4. **`rt_ext_AtalkHAtpSendResponse` implicitly answers the last request
   `AtalkHAtpGetRequest` dequeued** (there is no request handle in the Clarus-facing
   signature the brief specified). That is fine for the one-request-at-a-time
   shape `service` will have, but Task 7 must not dequeue a second request before
   answering the first.
5. **`macplus2/` is untracked in this worktree** — the spec says Andrew gitignored
   it on 2026-09-07, but that `.gitignore` change is not on this branch. Not
   touched; the merge will presumably bring it.

---

# Fix round 1 (review findings) — commit `f646322`

`fix(host): stale-request replay, spec NBP verify window, three review minors`

## What changed

**Important 1 — stale-request replay in `rt_ext_AtalkHAtpSendResponse`.** Confirmed:
`rt_at_g_req` was only overwritten on a successful dequeue, so a `SendResponse`
after an empty `AtalkHAtpGetRequest` re-sent the *previous* transaction's response
and re-armed a fresh 30 s XO entry under the old TID. Added
`static int rt_at_g_req_live`, cleared when a dequeue comes up empty **and** when a
response is successfully sent (so the same request cannot be answered twice
either), set on a successful dequeue. `rt_ext_AtalkHAtpSendResponse` now returns
`RT_AT_ERR_REQFAIL` (−1096) when nothing is live.

**Important 2 — register verify-lookup back to 3 × 1 s** per the controller's
ruling, with the Mac-parity rationale recorded in the function's comment. Both
callers now use the same window, so `rt_at_lookup_begin`'s `interval`/`ntx`
parameters were deleted along with the difference (two constants,
`RT_AT_LK_INT` / `RT_AT_LK_TRY`, feed the one path). The public lookup window is
unchanged, and `register` blocking ~3 s is now the documented behaviour.

**Minor (a).** `rt_atalk.inc` now `#include <stdio.h>` for its own `snprintf`
instead of relying on `rt.c`'s earlier includes — same reasoning as the `<time.h>`
addition in the first round.

**Minor (b).** `rt_at_atp_in`'s TResp path adds `if (!rt_at_same_peer(from, r->to))
return;`. A foreign peer on the shared group that happens to reuse our TID can no
longer splice bytes into a response. (Comment notes that `net` is 0 on both sides
on this routerless lane, which is why the full `same_peer` compare is safe here.)

**Minor (c).** The TRel path now does `x = rt_at_xo_find(...); if (x == NULL)
return;` *before* consulting `drop_rx_trel`, so a foreign peer's TRel cannot
consume the test hook's arm.

**Test.** `test_ext` gained a case for Important 1: open an ATP socket through the
Clarus-facing wrappers, confirm `AtalkHAtpGetRequest` returns −1 with nothing
pending, then confirm `AtalkHAtpSendResponse` returns −1096 rather than replaying.
The test's watchdog comment was updated for the longer register windows.

## Commands and output

Mutation check that the new assertion is live (guard line deleted):

```
$ sed 's/    if (!rt_at_g_req_live) return RT_AT_ERR_REQFAIL;//' rt_atalk.inc > … ; ./mutant
FAIL: AtalkHAtpSendResponse answered a stale request (runtime/host/rt_atalk_test.c:338)
FAILED
mutant exit=1
```

Focused re-run:

```
$ make test T='hostrt/atalk atalkdrive/'
PASS hostrt/atalk 20s
PASS atalkdrive/call 14s
PASS atalkdrive/lookup 6s
tests: 3 passed, 0 skipped, 0 failed

$ cat build-run/tests/atalkdrive/*.log
PASS serve
PASS call_ok
PASS call_code
PASS call_missing
PASS register
PASS lookup
```

Full gate:

```
$ make -j t1
…
PASS atalkdrive/call 14s
PASS lowlevel/run 21s
PASS hostrt/atalk 23s
tests: 91 passed, 30 skipped, 0 failed
```

## Files changed in this round

`runtime/host/rt_atalk.inc`, `runtime/host/rt_atalk_test.c`. No other file touched.

## Note

`hostrt/atalk` is now ~23 s in T1 (was ~15 s): the three registers in the test each
carry a 3 s verify window instead of 0.75 s, which is the accepted cost of the
ruling. If T1 wall time matters more than the coverage, the test's third register
(the one in `test_ext`, which exists to give the `rt_ext` lookup something to find)
could reuse a name already registered instead — worth ~3 s.

---

# Fix round 2 (T1 interference) — commit `bd534e6`

`fix(host): LLAP node acquisition waited on a select, not a clock; serialize the LToUDP tests`

Rebased worktree on `appletalk` tip `f4b6546`.

## Reproduction

`make -j t1` and `make -j test T='hostrt/atalk atalkdrive/ atalk/'` were both green
on the first several attempts — the race needs more simultaneous stacks than the
harness reliably produces. Six copies of the unit-test binary started at once
(18 live stacks) reproduces it every time:

```
$ for n in 1 2 3 4 5 6; do (/tmp/at1 > /tmp/s$n.out 2>&1 &); done
1: FAIL: forced collision left B on A's node id (rt_atalk_test.c:113)
2: FAIL: forced collision left B on A's node id
3: FAIL: forced collision left B on A's node id
4: OK
5: FAIL: forced collision left B on A's node id
6: OK
```

## Root cause

`rt_at_acquire` sent each `lapENQ` and then waited for the `lapACK` with
`rt_at_tick(a, 20)`. **`rt_at_tick`'s `select` returns the instant *any* datagram
lands**, not after `ms`. On a group with a dozen live stacks there is always a
foreign datagram pending, so every `select` returned immediately and the whole
eight-probe loop finished in roughly a millisecond — far quicker than the ACK
round trip. The stack then concluded "no answer, the id is free" and claimed a
node id whose real owner was still in the middle of answering.

That is the head of the whole cascade the coordinator observed. A `LkUp-Reply` is
**unicast to the requester's node**, and the only thing selecting which lookup slot
consumes it is the 8-bit NBP id (which every fresh instance started at 1). So two
processes holding the same node id feed each other's lookups:

- another process's `Unit-<theirPid>:ClarusTest` reply lands in *our* `register`
  verify lookup → the verify sees a tuple → `register on A failed` (−1027);
- with A holding no name, `wildcard lookup found nothing` / `missed A's registered
  name` and `remove on A failed` follow, and B's "duplicate" register *succeeds*
  → `duplicate register did not return nbpDuplicate`;
- B now holds `Unit-<pid>:ClarusTest` at socket 201 while `test_ext` re-registers
  it on A at socket 200, so the `rt_ext` lookup returns **two** tuples with the
  same name at different addresses and the loop asserts on both → `packed address
  has the wrong node` / `wrong socket`. That pair is the fingerprint that made the
  duplicate-node diagnosis certain.

## What changed in the stack

1. **`rt_at_acquire` waits on a clock**: each probe runs
   `while (rt_at_now() < until && !a->collided) rt_at_tick(a, 5);` with a 25 ms
   deadline. This is the actual fix.
2. **`rt_at_lookup_add` only accepts tuples matching the slot's own obj/type
   pattern.** A lookup must report what it asked for; this makes a
   cross-delivered reply harmless instead of poisonous, and it is correct NBP
   behaviour independently of the race.
3. **A fresh instance's `nbp_id` starts at a random value**, not 1 — two
   instances' concurrent lookups no longer share an id by construction.
4. **`SO_RCVBUF` raised to 256 KB.** A stack is drained once per pump pass; the
   default buffer overflows on a busy group, and a dropped `lapACK` costs a
   duplicate node id.
5. **Eight `lapENQ` probes rather than three** (Inside AppleTalk sends up to 20).

Verification, same harness:

```
6 concurrent : OK OK OK OK OK OK
10 concurrent, round 1: OK OK OK OK OK OK OK OK OK OK
10 concurrent, round 2: OK OK OK OK OK OK OK OK OK OK
```

i.e. 30 live stacks racing, 20/20 processes green, where 4/6 failed before.

## Determinism: the cross-script lock

`tests/lib_atalk.sh` gains `atalk_lock` / `atalk_unlock`:

- `mkdir` is the lock — the one atomic create POSIX sh has (macOS has no `flock`).
- The holder's pid is written inside, so a killed holder's lock is **stolen** by the
  next waiter rather than blocking every later run until the bound expires.
- Bounded wait of 300 s, then `die`.
- Released from a `trap … EXIT` that also re-does `lib.sh`'s own `rm -rf "$WORK"`:
  `lib.sh` is frozen, so a handler cannot be chained onto its trap, and replacing
  it without the `rm` would leak the work directory. `INT`/`TERM` get the same
  handler plus `exit 2`.

Taken by `tests/hostrt/atalk.sh`, `tests/atalkdrive/{call,lookup}.sh` and the five
network `tests/atalk/{call,find,runerr,serve,zones}.sh`, immediately after the
helper-lib source line so the multicast probe is inside the critical section too.
`tests/atalk/splice.sh` does **not** take it — it is compile-only and never opens a
socket; locking it would just lengthen the chain.

## Three-run evidence

```
===== t1 run 1   tests: 103 passed, 31 skipped, 0 failed
PASS atalk/call 21s   PASS atalk/find 43s    PASS atalk/runerr 136s
PASS atalk/serve 75s  PASS atalk/splice 7s   PASS atalk/zones 26s
PASS atalkdrive/call 120s  PASS atalkdrive/lookup 105s  PASS hostrt/atalk 97s

===== t1 run 2   tests: 103 passed, 31 skipped, 0 failed
PASS atalk/call 73s   PASS atalk/find 112s   PASS atalk/runerr 54s
PASS atalk/serve 33s  PASS atalk/splice 6s   PASS atalk/zones 38s
PASS atalkdrive/call 127s  PASS atalkdrive/lookup 134s  PASS hostrt/atalk 94s

===== t1 run 3   tests: 103 passed, 31 skipped, 0 failed
PASS atalk/call 107s  PASS atalk/find 18s    PASS atalk/runerr 88s
PASS atalk/serve 72s  PASS atalk/splice 5s   PASS atalk/zones 135s
PASS atalkdrive/call 130s  PASS atalkdrive/lookup 115s  PASS hostrt/atalk 39s
```

(The per-test seconds now include time spent waiting on the lock, which is why they
vary so much and why they no longer reflect the work each test does.)

## T1 wall-clock cost of serialization — measured

| | wall clock |
|---|---|
| `make -j t1` with the lock | **139 s** |
| `make -j t1` with `atalk_lock` stubbed to `return 0` (same tree, same run conditions) | **34 s** |

Both green. The serialized chain of eight network scripts is ~125 s of work that
used to overlap with the rest of T1's ~34 s.

## Files changed in this round

`runtime/host/rt_atalk.inc`, `tests/lib_atalk.sh`, `tests/hostrt/atalk.sh`,
`tests/atalkdrive/{call,lookup}.sh`, `tests/atalk/{call,find,runerr,serve,zones}.sh`.

## Concerns / levers for the controller

1. **T1 goes 34 s → 139 s.** That is a 4× cost on the per-task gate, paid dozens of
   times. Worth a deliberate decision, because the stack fix alone survived 30
   concurrent stacks (20/20) — the lock is now insurance, not the fix. Two levers:
   (a) narrow it to `hostrt/atalk` (the only script with three stacks in one
   process and the only one that ever failed), or (b) drop it entirely and rely on
   the acquisition fix. I kept the full lock because this round was explicitly
   about determinism.
2. **~18 s of the critical section is `atalk_skip_unless_multicast`**, a full 3 s
   NBP lookup run six times. Moving `atalk_lock` to *after* that probe would
   recover it; I left it inside so the invariant is "no LToUDP stack of any kind
   overlaps another", with no exception to reason about.
3. **A polled stack can only defend its node id while something is polling it.**
   Inherent to the design (no thread), and it is why a test process sitting between
   operations is a soft target. The acquisition fix removes the failure mode in
   practice, but a host program that stops pumping for seconds can still lose its
   node to a newcomer.
