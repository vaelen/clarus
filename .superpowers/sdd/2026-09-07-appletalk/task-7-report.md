# Task 7 report — runtime `atalk.cla` + twins, host splice, `--rtbake` fallback

Worktree `/Users/andrew/repos/clarus-wt/t7`, branch `appletalk-t7`, commit
`bb6e1e8`.

## What I implemented

### `runtime/clarus/atalk.cla` (924 lines, lane-neutral)

Every function from the brief's API and ADSP-waist lists, with the exact
signatures, plus five private helpers (`rtAtEnsureUp`, `rtAtRegMsg`,
`rtSvcSetFailed`/`rtBrsSetFailed`/`rtLsnSetFailed`, `rtAtTextToPtr`,
`rtAtAppendBytes`). Semantics implemented per spec §4:

- `rtSvcServe`: `Up` → `AtpOpen` → `Register(name, typ, sock)` → `AtpArm`;
  every failure stages a `failed` (`"AppleTalk unavailable"`, `"name in
  use"` on −1027, `"could not open socket"`, `"could not receive
  requests"`). Re-serving a serving slot stages `failed` with conn.cla's
  own `rtConnErrAlreadyOpen` rather than leaking the socket.
- `rtAtalkPump`: `rtAtDevPoll()`, then per service slot drain the staged
  `failed`, and while not `RespBusy` poll for one request, build `req`
  from `ReqPtr`/`ReqLen` (clamped to 578), set `InHandler`, fire
  `clar_svc_fire_request`, and **auto-reply −1** when the handler did not
  reply; re-arm only when `RespBusy` is false, checked fresh. One request
  per slot per pass, always answered before the next slot is polled (the
  device layer answers "the last dequeued request"; dequeuing a second
  first would strand the first with −1096).
- `rtSvcReply`: panics `"reply outside a request handler"` /
  `"reply already sent"`; > 4624 bytes stages `"reply too long"`
  (atpLenErr) **and** sends the automatic −1; otherwise `pokeb`-marshals
  into a `SerNewPtr` scratch, `AtpRespond`s and disposes immediately.
  `rtSvcReplyStr` is the one-line `string`→`text` form.
- `rtSvcCallAddr`: > 578 → `lastError` −3106 `"request too long"`, false;
  `n < 0` → `(n, "no response")`, false; else `reply.clear()` + append `n`
  bytes; nonzero `code` → `(code, "service")`, false, with `reply` still
  holding the payload.
- `rtSvcCallName`: splits at the first `:` (locals, not scratch globals),
  starts a lookup on the reserved slot 9, spins `while not LookupDone {
  rtAtDevPoll() }`, count 0 → −1025 `"name not found"`, else
  `rtSvcCallAddr`. Its doc comment records that a self-call can never
  succeed on the host (own datagrams are dropped).
- `rtBrsFind`/pump: `LookupStart(slot, "=", typ, zone)` (`""` treated as
  `"*"`); on `LookupDone` fire one `found` per tuple, then `done` from the
  **next** pass via `rtBrsPendDone` (which is also what keeps
  `rtAtalkAlive()` true across the gap).
- `rtBrsZones`: `out.clear()`, `["*"]` on any error or an empty list.
- `rtLsnRegister`/pump: `Up` → `LsnDevInit` (rtAtErrNoHost → `"streams
  not available on this lane"`) → `Register(name, typ, LsnDevSocket)` →
  `LsnDevListen`; the pump takes the first free conn slot
  (`rtConnState[i] == stClosed and rtAdspPhase[i] == rtAdspNone`, scanned
  over `rtConnMax` so the 4→8 growth needs no edit here), `LsnDevAccept`,
  marks it open with transport 1 and ADSP phase 3, fires
  `clar_lsn_fire_accepted(slot, i + 1)`, **denies when full**, and
  re-listens either way.
- `rtAdsp*`: the phase machine (none/lookup/opening/open) over
  `rtAdspDev*` on lookup slot `slot + 2`; `rtAdspPoll` reports 1 exactly
  once (an already-open slot answers 0, so `opened` cannot fire twice).
  `rtAdspReadInto` does one `rtAdspDevRead` of `min(avail, 1024)` into a
  per-call scratch and appends. `rtConnOpenAddr` tags transport 1 and
  stages conn.cla's own `failed` on an immediate error.
- `rtAtalkAddrStr` → `"net.node.socket"`; `rtAtalkAlive()` → serving /
  registered / searching / any pending event.

### `runtime/clarus/atalk_c.cla` (313 lines, host)

The 18 `AtalkH*` externs from the brief, the whole `rtAtDev*` waist over
them, and the ADSP/listener half stubbed to `rtAtErrNoHost`/`0`/`false`
(spec §4.6). Scratch buffers allocated once on the first successful `Up`
via ser.cla's `SerNewPtr` (two 578-byte request buffers, one 4624-byte
response buffer, one 68-byte name buffer). `rtAtDevAtpPoll` snapshots
`op`/`from`/`len` per slot at poll time (the glue's request state is
process-global) and tests `n < 0`, never `<= 0`, so a genuine zero-length
request is dispatched. `rtAtDevZones` always reports noBridgeErr.
`rtAtDevPoll` is guarded so it can never reach a stack that was never
opened.

### `runtime/clarus/atalk_68k.cla` (195 lines, stubs)

Same names and signatures as the host twin (verified by diff — the only
difference is the host-private `rtAtCReqBuf` helper), all reporting
unavailable, spliced nowhere. Its header carries the Task 1 probe
findings and the §5.2–5.6 recipe Task 9 fills in (full PB re-zero before
every reuse, NBP registers the socket verbatim, async XO `PSendResponse`
being what `rtAtDevAtpRespBusy` exists for, etc.).

### `clarusc/drive.cla`

- Host splice: `else if usesConn or usesAtalk { conn.cla, conn_c.cla,
  atalk.cla, atalk_c.cla }`. The `want68k` arm and `bake.cla` are
  untouched.
- `--rtbake` C-lane gap (TODO fix (b)): the fallback body is now
  `driveRtbakeFallback(entries, testapi)`, called from the existing drift
  site and from a new site that logs `"clarusc --rtbake: host program uses
  connection/filehandle/AppleTalk; falling back to a from-source
  compile"`.

## Deviations (both deliberate, both flagged)

1. **The fallback site is not `drive.cla:2138`.** `docs/TODO.md`'s fix (b)
   claims `usesConn`/`usesFileh` "are already set at that point"; they are
   not. That site sits in Phase A, before the checker runs, and
   `checkReset()` clears all three. I verified empirically: with the
   condition at the drift site the repro still emitted a bake fork with
   `cv_rtAtUp` absent and no log line. The new check therefore sits right
   after `driveProgressPhase("Checked user program")` and after the
   `wantEmit` gate (a check-only run splices no runtime and has no gap).
   Behaviour is identical apart from one wasted user-check pass.

2. **Four globals beyond the brief's "complete" table**: `rtSvcName`,
   `rtSvcType`, `rtLsnName`, `rtLsnType`. `rtAtDevRemove(obj, typ)` takes
   the entity name from its caller (the signature is fixed and the native
   `PRemoveName` needs a fresh NTE), and nothing else on either lane
   remembers it — so without these, `stop()` could close the socket but
   never remove the name, contradicting spec §4.4/§4.2 and leaving a
   restarted server failing with nbpDuplicate. I did *not* add scratch
   globals for the `"Name:Type"` split (the brief's shape would have added
   two more); the two call sites use locals instead.

   Note also that the brief's `rtAtCReqBuf: ptr[2]` is not expressible:
   `ptr cannot be a container element`. It is two scalars behind a
   `rtAtCReqBuf(slot)` accessor.

## Tests and results

- `tests/atalk/splice.sh` (new, with `tests/atalk/testdata/splice.cla`):
  11 subcases — host build of the `service`/`serviceBrowser` fixture; five
  splice witnesses in the emitted C (`cv_rtAtUp`, `cv_rtSvcState`,
  `cv_rtAdspPhase`, `cv_rtConnSlotTransport`, `cv_rtConnState`); the
  binary runs; `--bake-ir --lane c` then a `--rtbake` fork of the fixture
  logs the fallback, splices atalk and compiles; the same for
  `tests/conntest/testdata/echo.cla` (serial only), which additionally
  asserts `clar_fn_rtConnOpen` is now *defined*; and a negative — a
  runtime-free program must NOT fall back, so an over-triggering condition
  cannot silently retire the `--rtbake` fast path. **PASS.**
- `make -j t1`: **94 passed, 30 skipped, 0 failed** (twice, before and
  after the final trim).
- `make test T=conntest/` 8/8, `T=emitui/` 5/5, `T=bake/` 22 passed /
  7 skipped, `T=atalk/` 1/1. No perfgate, no `--smoke` (controller's job).
- **Zero `testdata/cg68k` churn** — `git status` shows only
  `clarusc/drive.cla`, `testdata/emitui/connpump_abort.c.golden`, the
  three new runtime modules and `tests/atalk/`.

### Golden regenerated: `testdata/emitui/connpump_abort.c.golden`

Expected, per the brief. `181 insertions(+), 18 deletions(-)`. Breakdown
of the added lines: 31 atalk global declarations, 7 `extern
rt_ext_clar_{lsn,brs,svc}_fire_*` declarations, 4 new array typedefs
(`clar_arr_int_2`/`bool_2`/`str255_2`/`int_8`), 35 renumbered string
literals, and 104 global-init/declaration lines. Every one of the 18
deleted lines is a `clar_lit_N` line that reappears under a higher N — the
diff is purely "the extra module's globals plus literal renumbering", no
change to any emitted statement. Every other emitui golden is
byte-identical.

### Extra verification not committed

Shake drops every runtime function nothing roots, and `rtAtalkPump` is not
rooted until Task 8 wires it (`shake.cla`'s `irUsesConn` arm is the
precedent) — so the committed test can only witness the splice through the
module's *globals*. To prove the bodies actually lower and emit valid C
today, I built a throwaway copy of `runtime/clarus/` with a
`rtAtalkRootAll()` calling all 21 public entry points and a one-line hook
in `rtConnPump`: all 21 appear in the emitted C (42 decl+def lines) and
`cc -O1 -Wall -c` compiles it clean (only the pre-existing
unused-literal/unused-function warnings). The link fails only on the seven
`rt_ext_clar_*_fire_*` dispatchers, exactly conn.cla's own state before
Task 5. Task 8's rooting is what turns this into permanent coverage.

## Self-review findings

- Every brief API/waist function present with the exact signature; the two
  twins' signature sets are identical (mechanical diff).
- Spec §4 semantics checked one by one: auto −1 reply ✓, reply-twice and
  reply-outside panics ✓, 578 request / 4624 reply limits enforced not
  truncated ✓, `["*"]` zone fallback ✓, `done` after the `found`s ✓,
  deny-when-full ✓, nil-handle panics on all six public receivers ✓,
  events only ever fired from the pump ✓.
- `and`/`or` are short-circuit (reference §, precedence table), so
  `rtBrsZones`'s chained condition is safe.
- The listener's free-slot scan uses `rtConnMax`, so the spec's 4 → 8 conn
  slot growth needs no edit here.

## Concerns

1. `atalk.cla` is 924 lines — past the brief's ~900 threshold, so per the
   task instructions this is DONE_WITH_CONCERNS rather than a split. It is
   ~590 lines of code and ~260 of comment; I trimmed where the comment was
   redundant with `atalk_68k.cla`'s longer version and stopped there.
2. The four name globals above are a real deviation from "the COMPLETE
   table, never grown later" — Task 9's native twin is unaffected (it
   writes no globals of atalk.cla's), but the controller should confirm
   before Task 8 freezes anything against the table.
3. No hardware or emulator coverage this task by design; the host lane's
   real NBP/ATP behaviour is exercised only through Task 2's own
   `hostrt/atalk` and `atalkdrive/*` scripts, which stay green.

---

# Fix round 1 (commit `078b389`)

Three Important findings plus three minors, all behavior-only; every public
function name and signature is unchanged (Task 8 cut from `bb6e1e8` is
unaffected).

## Important 1 — lookup slot 9 was double-booked

`runtime/host/rt_atalk.h`: `RT_AT_NLK` 10 → 11, with a comment recording
the Clarus map. Everything else keys off the macro — the `lk[RT_AT_NLK + 1]`
array, the `lk >= RT_AT_NLK` public-range guard, register's own private
verify slot (`RT_AT_NLK`), and the two sweep loops — so no other line in
`rt_atalk.inc` needed a number change (one stale `0..9` comment updated).
Nothing in `tests/` or `tests/tools/atalkdrive.c` pins the count.

`atalk.cla`: `rtAtLookupMax = 11`, `rtAtNameCallLk = 10`, and the slot-map
comment now describes the real map (0-1 browsers, 2-9 conn opens, 10
name-calls) and says why 10 and not 9 — an ADSP name-open sits in
`rtAdspLookup` across pump passes, so a `call("Name:Type", …)` in that
window restarted conn slot 7's live lookup.

`runtime/host/rt_atalk_test.c` (`test_ext`): two new CHECKs — a lookup
STARTS on slot 10, and `RT_AT_NLK` itself is refused (it is register's
private verify slot). No wait loop: that it starts is the whole claim.

## Important 2 — unconditional re-arm

New `var rtSvcArmed: bool[2]` in the global table, with a comment saying it
is still the initial declaration of that table (atalk.cla is not on the 68k
lane, no golden pins its globals). Set on a successful `rtAtDevAtpArm`
(both in `rtSvcServe` and in the pump), cleared when `rtAtDevAtpPoll`
returns 1 and in `rtSvcStop`; the pump's arm is now
`if not rtSvcArmed[i] and not rtAtDevAtpRespBusy(i)`. `atalk_68k.cla`'s
Task 9 recipe states the resulting contract: Arm is called exactly once per
outstanding get-request, so the body may assume the PB is free — and still
re-zeroes it before reuse, per the probe.

## Important 3 — `rtConnOpenAddr` vs `rtConnOpen`'s contract

(a) Already-open guard added, staging `rtConnErrAlreadyOpen` /
`"connection already open"` exactly like `conn.cla:224`.

(b) `rtAtalkAlive()` now also returns true while any connection slot's
`rtAdspPhase` is neither `rtAdspNone` nor `rtAdspOpen` — i.e. a lookup or
open still in flight, which owes an `opened`/`failed` that neither
`rtConnAlive` (the slot is not `stOpen` yet) nor anything else covered.

(c) Fixed at the root rather than in the one caller the finding named: the
two `rtAdspOpen*` functions now own the slot's transport tag — set to 1
only once the attempt is under way, and put back to 0 (with the phase) by
the new `rtAdspFailed(slot)` on every failure path in `rtAdspOpenName`,
`rtAdspOpenAddr`, `rtAdspPoll` and `rtAdspClose`. So Task 9's `conn.cla`
path through `rtAdspOpenName` gets the same guarantee `rtConnOpenAddr`
does, with no rule to remember: a failed AppleTalk open can never leave a
tag that sends a later serial open on the same variable down the ADSP
waist. `rtConnOpenAddr` no longer touches the tag itself.

## Minors

- `rtSvcCallAddr`'s allocation failure now reports `{memFullErr, "out of
  memory"}`.
- `done` fires in the SAME pump pass, right after the founds, guarded by
  `if rtBrsState[i] == rtAtIdle` so a `find()` called from inside a `found`
  handler (which sets the state back to active) does not get a spurious
  early `done` — its own `done` comes when its own window closes. This
  retires `rtBrsPendDone`, which had no remaining reader; the alive check
  it fed is covered by `rtBrsState` plus the new ADSP-phase loop.
- `tests/atalk/splice.sh`'s header now states what the test proves (check +
  spliced globals) and that the bodies stay shaken until Task 8 roots them.

## Commands and output

```
make test T=hostrt/atalk      -> PASS hostrt/atalk 20s        (1 passed)
make test T=atalk/            -> PASS atalk/splice 1s         (1 passed)
make test T=conntest/         -> 8 passed, 0 skipped, 0 failed
make test T=emitui/           -> 5 passed, 0 skipped, 0 failed
make test T=bake/             -> 22 passed, 7 skipped, 0 failed
make -j t1                    -> 94 passed, 30 skipped, 0 failed
```

Re-ran the throwaway-root emission check (a copy of `runtime/clarus/` with
`rtAtalkRootAll()` hooked into `rtConnPump`): all 21 public functions still
emit (42 decl+def lines) and `cc -O1 -Wall -c` compiles clean.

`testdata/emitui/connpump_abort.c.golden` regenerated again: `4 insertions,
4 deletions` — `cv_rtBrsPendDone` out, `cv_rtSvcArmed` in (same
`clar_arr_bool_2` slot) and three shifted initialiser lines. No other
golden moved; still zero `testdata/cg68k` churn.

## Files changed

`runtime/host/rt_atalk.h`, `runtime/host/rt_atalk.inc` (comment),
`runtime/host/rt_atalk_test.c`, `runtime/clarus/atalk.cla`,
`runtime/clarus/atalk_68k.cla`, `tests/atalk/splice.sh`,
`testdata/emitui/connpump_abort.c.golden`.

## Note

`atalk.cla` is now 974 lines (the round's added guards and comments), still
past the ~900 mark flagged in the original report.

---

# Fix round 2 (commit `4ff08f7`)

One Important and two minors. No signature or name changed; no golden moved
(verified by re-emitting `connpump_abort` and `cmp`-ing — byte-identical).

## Important — `rtSvcArmed` stuck true on a poll error

`rtAtalkPump`'s `pr < 0` branch staged `"request failed"` but left
`rtSvcArmed[i]` set, so the arm below never re-issued and the slot silently
stopped serving for the rest of the program. A poll error means the
get-request COMPLETED (with an error) and the parameter block is free, so
the flag is now cleared in that branch, next to the `pr == 1` clear, with a
comment saying why (host never returns < 0 here; Task 9's native
`PGetRequest` completing with an error is exactly this case).

## Minor (a) — stale tuples after a restart from inside `found`

Chose the one-condition fix over snapshotting: the loop bound is now

```
while j < n and rtBrsState[i] == rtAtIdle {
```

A `find()` from inside a `found` handler sets the state back to
`rtAtActive` and restarts that same lookup slot, which the device layer
zeroes — so every remaining tuple of the old search is genuinely gone and
there is nothing correct left to deliver. They are dropped; the new search
owns the slot and gets its own `done` when its own window closes (the
existing `if rtBrsState[i] == rtAtIdle` guard on `done` already handled
that half). Snapshotting would have meant two new lists per pass to deliver
data the caller just invalidated.

## Minor (b) — the slot-10 CHECK left a lookup running

`rt_at_g` is a `static` inside `rt.c`, so `rt_atalk_test.c` (a separate
translation unit that sees only the opaque `rt_atalk` typedef) cannot reach
`a->lk[10].active` to clear it. The two range CHECKs therefore move to the
END of `test_ext` — which is itself the last test `main()` runs — so the
started lookup has nothing left to perturb, and the comment records both
facts. No new API surface, no added wait.

## Commands and output

```
make test T=atalk/       -> PASS atalk/splice 1s   (1 passed)
make test T=hostrt/atalk -> PASS hostrt/atalk 20s  (1 passed)
make test T=conntest/    -> 8 passed, 0 skipped, 0 failed
make -j t1               -> 94 passed, 30 skipped, 0 failed
```

## Files changed

`runtime/clarus/atalk.cla` (+14/-1), `runtime/host/rt_atalk_test.c`
(+22/-9 — the CHECK block moved). Still zero `testdata/cg68k` churn and no
golden movement.
