# AppleTalk phase — final whole-branch review

Range `dbacb90..a43b522` (branch `appletalk`, 31 commits, 93 files).
Reviewed in six passes, in this order: **runtime** (`atalk.cla`,
`atalk_c.cla`, `atalk_68k.cla`, `conn.cla`/`conn_68k.cla`), **host C**
(`rt_atalk.inc`/`.h`, `rt_serial.inc`, `rt_ext_host.inc`, `rt.c`),
**compiler** (`lower.cla`, `check.cla`, `cprint.cla`, `drive.cla`,
`bake.cla`, `ir.cla`, `shake.cla`, `cg68k.cla`, `types.cla`),
**catalog** (`toolbox/appletalk.cla`, `memory.cla`), **tests**
(`tests/atalk/`, `tests/atalkdrive/`, `tests/hostrt/atalk.sh`,
`tests/bake/`, `tests/conntest/`, `tests/mactest/`, `tests/lib_atalk.sh`,
`tests/lib_mac.sh`, `testsuite/`), **docs** (reference, cookbook,
TODO/FUTURE/ROADMAP) plus a golden spot-check and two focused host
builds. No emulator and no multicast test was run; the tree was not
mutated.

## Strengths

- **Spec fidelity across §4 is close to exact.** Async `open` with
  `opened` only from the pump; `accepted` with no `opened`; deny-when-
  full via `dspCLDeny` with no server-side event; `done` after the
  `found`s *in the same pass*; `zones` → `["*"]` on every failure path;
  the automatic `-1` reply; `reply` twice / outside a handler as
  `rtPanic`; 578/4624 enforced and never truncated; `call` true only on
  code 0 with `lastError = {code, "service"}` otherwise; caps 8/2/2/2
  enforced in lowering with the exact diagnostics; `stdio`/`pty`; the
  `every` term in the host lifetime rule. I checked each of these against
  code, not against the reports.
- **The lane-twin architecture is reused faithfully.** `atalk.cla` names
  nothing but `rtAtDev*`/`rtAdspDev*`/`rtLsnDev*`, both twins answer the
  same set, and the return conventions line up at the seam: the host's
  `-1 = none` from `AtalkHAtpGetRequest` is normalized in `atalk_c.cla`
  (`n < 0` → 0, never `<= 0`, so a zero-length request still dispatches),
  and the native poll returns a sign-corrected `ioResult` that the pump
  reads as `< 0`. `rtSvcArmed` gives exactly one `rtAtDevAtpArm` per
  outstanding get-request, and `rtAtDevAtpArm` re-checks `rtAt68Pending`
  defensively on top of that.
- **Native memory/PB discipline is real, not aspirational.** Five stated
  rules, each visible in the code: `rtAt68Zero` before every reuse; a
  separate `rtAt68DspAux` block for the four calls that must run while
  another block is live (`dspClose`/`dspRemove`/`dspCLDeny`/`dspCLRemove`);
  `rtAt68SignW` for every negative `word`; `int[]`-held block addresses
  because `ptr` is not a legal element type; and `rtAt68DspFree` giving
  the CCB, both queues and the attention buffer back on every close and
  every failed open.
- **`rtAtDevLookupStart` fails before it clobbers**, which the browser's
  re-entrant-`find` correctness depends on, and the browser pump's
  `while j < n and rtBrsState[i] == rtAtIdle` bound plus the guarded
  `done` handle a `found` handler that restarts the search. That is a
  subtle case and it is handled deliberately, with the reasoning written
  down.
- **The host stack parses defensively.** Every wire decoder bounds-checks
  before it reads (`rt_at_get_pstr`'s `n + 1 > avail`, `rt_at_nbp_in`'s
  `at + 5 > n`, `rt_at_atp_in`'s `n < 8` and `seq >= RT_AT_NPKT`,
  `rt_at_frame_in`'s `len > plen` for both header forms). `npkt` maxes at
  exactly `RT_AT_NPKT`. The `rt_at_lookup_add` pattern re-check against a
  shared multicast group is a genuinely good catch.
- **Tests are not vacuous.** `atalk_68k.sh`'s `same_entity` subcase closes
  the "somebody else's Clock on the group would satisfy every assertion"
  hole; `done_line` is `grep -qx`-anchored; `echo578` is byte-exact at
  ATP's own ceiling; `zones.sh` pins the exact log line; `runerr.sh`
  distinguishes exit code *and* message. The `tests/bake/atalk.sh`
  `emit68k_pair` twin landed in the same task as the module, per the
  standing rule.
- **A pre-existing bug was found and fixed properly** (`bake.cla`'s
  `lowStrIdx` filtered against the truncated pool) — root cause, with the
  reproduction recorded in the comment.
- **The rebless is provably renumbering + addition.** I re-ran the
  normalization on `testdata/cg68k/arith.s`: after `s/-?N(A5)/OFF(A5)/`
  and label normalization the only residue is the globals-size immediate
  (`#797` → `#3454`, i.e. 1596 → 6910 bytes) and the appended
  `clar_*_fire_*` roots.
- **`cpEmitMain`'s parenthesization care** (`!clar_aborting && (a || b || 1)`
  vs. the one-term shape that keeps `connpump_abort` byte-identical) is
  exactly the kind of detail that silently breaks abort semantics.
- Documentation is thorough and honest, including the wart paragraphs
  (pty close truncation, ADSP availability, no way back from
  `string(addr)`).

## Issues

### Critical (Must Fix)

**C1. `tests/mactest/adsp_68k.sh` is committed red and will fail T2.**
`tests/mactest/adsp_68k.sh:31-32` gates only on `CLARUS_MAC_TESTS` and
`[ -d "$ROOT/macplus2" ]`; there is no `.DSP`-absent skip anywhere in the
script (its own header says so: "There is no multicast/no-peer skip").
The ledger records that `.DSP`/`.XPP` are −43 on LaunchAPPL's stripped
boot disk and that the green run is Task 13, blocked on an out-of-repo
LaunchAPPL patch. So `CLARUS_MAC_TESTS=1 make -j1 test T=mactest/` —
Task 14's Step 2 — will report `FAIL mactest/adsp_68k` on
`server_accepted`, `server_sweep`, `server_hello`, `server_closed`,
`client_opened`, `client_sweep_echo`, `client_hello_echo`,
`client_echo_exact`, and both `*_exit` subcases. `main` must stay green,
so this cannot merge as is.
*Fix (pick one):* (a) apply the LaunchAPPL patch and get the green run —
the Task 13 plan; or (b) gate the script the way every other
not-yet-runnable lane is gated, e.g. `require_env CLARUS_ADSP_TESTS`
plus a note in CLAUDE.md's opt-in-lanes list, and keep the un-gated
proof for Task 13. Option (b) is the lazy one and does not lose the
script. `atalk_selfserve.sh` shows the third option done well (it is
written to pass on *both* boot disks) but that shape cannot express a
two-machine ADSP echo.

**C2. `svc.call`'s `reply` out-parameter accepts a `string` and emits
type-confused C.** `clarusc/check.cla:1751-1756` registers
`serviceMethods["call"]` with `sigAdd(psPlain(TextT))` for `reply`, and a
`string` argument is accepted there (string→text coercion at a call
argument). `clarusc/lower.cla`'s `lowServiceMethod` then passes it
through **uncoerced** (`irExprListAppend(tail, lowExpr(replyArg))` — the
deliberate "out-param passes through" rule). Reproduced against
`build-run/clarusc-current`:

```
var s: string
... svc.call("A:B", 1, "", s)          // clarusc check: exit 0, no diagnostic
```
```c
static int32_t clar_fn_rtSvcCallName(..., rt_text * cv_req, rt_text * cv_reply);
t2 = clar_fn_rtSvcCallName(cv_svc, &(clar_lit_153), 1, t1, &(cv_s));
// warning: incompatible pointer types passing 'clar_str_255 *' to 'rt_text *'
```
`cc` emits a **warning, not an error**, so the binary links; at runtime
`rtSvcCallAddr` does `reply.clear()` and `rtAtAppendBytes(reply, ...)`
through a `clar_str_255 *` — a wild-pointer write into the heap.

Calibration, because it matters: the underlying checker hole is
**pre-existing and class-wide** (`file.readText(path, s)` and
`fh.readAt(0, 4, s)` both check clean too). The difference is the failure
mode. `readText` bottoms out in an intrinsic whose prototype takes
`rt_text *` by value, so `cc` **errors** and the user is stopped;
`svc.call` bottoms out in a lowered Clarus function whose param is
`text`, so `cc` only warns and the user ships a corrupting binary. This
phase adds the first site of the class with a silent failure mode, and
`string`-where-`text`-is-meant is a very natural thing for a user to
write.
*Fix (≈5 lines, mirrors the `zones` arm added in this same phase),
`clarusc/check.cla` around :2375:*
```
result = checkTableMethod(serviceMethods, sel, argsHead)
if name == "call" and <4th arg present> {
    checkRejectParamFill(arg4)                       // widget-prop / value-param guard
    if typeKind(exprTypeGet(arg4)) != TyText {
        emitDiag(..., "call's reply must be a text variable")
    }
}
```
plus a `testdata/errors/svc_call_reply.{cla,expect}` fixture. Record the
class-wide hole (string accepted at any `text` out-param) in
`docs/TODO.md` — it is bigger than this phase.

### Important (Should Fix)

**I1. The `atalk_lock` narrowing the controller ruled on has not been
applied.** `tests/lib_atalk.sh:80-130` plus the nine call sites: every
building script takes the lock *before* `atalk_build` (`tests/atalk/{call,
find,runerr,serve,zones}.sh` — `atalk_lock` at line 10-15, `atalk_build`
after), so each script holds the global mutex across its own `clarusc
emit` + `cc`, and those compiles are serialized against every other
network script. That is most of the 34 s → ~2.3 min T1 regression. The
ruling (ledger line 116) was: keep the lock, but take it *after* the
build and before the multicast probe, add an ownership check to
`atalk_unlock`, and raise the wait bound 300 → 600 s. None of the three is
in the tree.
*Fix:* move `atalk_lock` to just above `atalk_skip_unless_multicast` in
the five `tests/atalk/*.sh` builders (the two `atalkdrive/` scripts and
`hostrt/atalk.sh` build nothing and are already fine); in
`atalk_unlock`, `[ "$(cat "$ATALK_LOCK/pid" 2>/dev/null)" = "$$" ] || return 0`
before the `rm -rf` (today a waiter that steals a dead holder's lock can
race a second waiter into deleting a *live* holder's directory); bound
600. Keeping the lock is right — determinism on a group shared with
Andrew's live sessions beats the seconds.

**I2. `tests/atalk/runerr.sh` hides three network-free assertions behind
the multicast gate.** `runerr.sh:15` calls `atalk_skip_unless_multicast`
before everything, but subcases 1 (`reply_outside`, `send_unopened_adsp`
— both are pure `rtPanic` paths that never reach the wire… except
`rtSvcReply`'s panic fires before any device call, and
`send_unopened_adsp` panics in `rtConnSendText`) and 3 (the three
`too_many_*` **build**-time cap diagnostics) need no group at all. On any
host without multicast — a CI box, a sandbox — the entire error-principle
fence silently disappears.
*Fix:* run subcases 1 and 3 unconditionally; move the skip down to just
above the `reply_twice` section, which is the only one needing a peer.

**I3. A listener that fails a `dspCLListen` goes permanently deaf with no
further signal.** `runtime/clarus/atalk.cla:~905` (the pump's listener
arm): `if pr < 0 { rtLsnSetFailed(...) } else if pr == 1 { ...; rtLsnDevListen(i) }`
— the re-arm lives only in the `pr == 1` branch. Natively
`rtLsnDevPoll` has already cleared `rtAt68LsnLive[slot]`, so every later
poll returns 0: the listener stays `rtAtActive` (so `rtAtalkAlive` keeps
the program running and `stop()` is still required), the NBP name stays
advertised, and no client will ever be accepted again — after exactly one
`failed` event.
*Fix:* re-arm on the failure path too (`rtLsnDevListen(i)` after
`rtLsnSetFailed`), or drop the slot to `rtAtIdle` and remove the name so
the state matches what the program is told. One line either way.

**I4. The reference documents no host-lane AppleTalk behavior.** Spec
§4.6 is a whole subsection ("Discovery, `zones`, `serve`, and `call` work
for real over LToUDP; stream `open`, `register`, `accepted` fail with an
event on the host this phase") and §12 lists the reference among the
documentation moves. `docs/clarus-language-reference.md`'s new Chapter 12
sections describe only the Mac. The single sentence at :1390 ("a system
without it makes `open(appletalk ...)` … fail") is the closest thing, and
a reader will not map "a system without `.DSP`" onto "every host build".
`CLARUS_ATALK_IFACE` appears nowhere in `docs/` outside the spec and plan,
even though the Serial section sets the precedent by documenting
`CLARUS_SERIAL_*` in full.
*Fix:* one paragraph in the Service Discovery/Services area, modelled on
the serial host paragraph: on a command-line host the program is a real
LocalTalk-over-UDP peer on 239.192.76.84:1954 (so it can talk to a Mini
vMac or Snow on the same machine), discovery and services work for real,
streams (`open(appletalk …)`, `open(addr)`, `listener.register`) fail
with `failed`, the zone list is always `["*"]`, and `CLARUS_ATALK_IFACE`
selects the interface on a multi-homed host.

### Minor (Nice to Have)

- **`runtime/host/rt_ext_host.inc:404-412`** — `due[idx] = now + periodTicks`
  is signed `int32_t` addition and can overflow (UB) near the tick wrap,
  while the comment above claims "no signed overflow anywhere". Make the
  arming `(int32_t)((uint32_t)now + (uint32_t)periodTicks)` and fix the
  comment; the *compare* is already correct.
- **`rt_ext_host.inc:398`** — more than `RT_EVERY_MAX` (16) `every` blocks
  silently never fire. A one-line `abort`/diagnostic in
  `lowSynthEveryPump` when `irEveryCount > 16` would be better than a
  silent no-op.
- **`runtime/clarus/atalk.cla:~470`** — `rtSvcCallName`'s
  `while not rtAtDevLookupDone(...) { rtAtDevPoll() }` is a 100 %-CPU spin
  for up to 3 s on the host (`AtalkHPoll` is a non-blocking drain). A
  `select`-with-10 ms inside the host twin's poll, or a host-side
  `rt_at_tick`, would make it a sleep instead.
- **`runtime/clarus/atalk.cla:~425`** — `rtSvcCallAddr` only does
  `reply.clear()` after a successful call, so every pre-call failure path
  (`request too long`, `AppleTalk unavailable`, out of memory, `reqFailed`)
  leaves the caller's previous `reply` content in place. The spec is
  silent; either clear on entry or say so in the reference.
- **`runtime/clarus/atalk_68k.cla:~1170`** — `rtAdspDevRead` returns 0 on
  error, so `rtAdspReadInto`'s `got < 0` branch is dead natively (it is
  live on no lane). Return the OSErr or delete the branch.
- **Host `rt_ext_AtalkHFd` is dead code.** Spec §6.1's "`rt_ext_ConnHIdle`
  adds the UDP socket to its `select` set so a host server sleeps until
  traffic" is not implemented — `rt_ext_ConnHIdle`
  (`rt_serial.inc:564-590`) walks only the serial slots, so an
  AppleTalk-only host server `usleep`s 20 ms per pass. Cost is latency and
  50 wakeups/s, not correctness, but it is an unrecorded spec deviation:
  either wire it or move it to `docs/FUTURE.md`.
- **`runtime/host/rt_serial.inc:110-112`** — the 8-element slot
  initializer trips `-Wmissing-field-initializers` under `-Wextra` (8
  warnings; the project's `-Wall -Werror` build is unaffected). `= {{ -1 }}`
  plus an fd fix-up loop, or listing the fields, removes the noise.
- **`clarusc/types.cla:51`** — `TyService` was inserted mid-enum, shifting
  `TyAddress` and everything after it. `TypeKind` *is* serialized into
  CLIR (`bake.cla:3113`, `ti.kind = TypeKind(bkGetU32())`) with no format
  version bump. Safe today (no `.clir` blob is committed, and every
  producer/consumer pair is the same binary), but the enum's neighbours
  carry an "append last" comment for exactly this reason — add the comment
  or move the member last.
- **~70 duplicated lines** between `lowSynthAtalkFire{Simple,Failed}` and
  `lowSynthConnFire{Simple,Failed}`. My recommendation is **do not fold
  now**: the fold has to edit the connection builders, which every
  `emitui` and `cg68k` golden pins, for zero behavior change at the end of
  a phase that already reblessed the corpus. Record it and fold in the
  MacTCP phase, when a third copy would make the case unarguable.
- **Stale citations:** `clarusc/drive.cla:2355,2368` and
  `tests/atalk/splice.sh:49` still cite "docs/TODO.md's fix (b)", which
  this phase deleted from TODO. Spec §5.6 still says "a 2 KB return
  buffer" where `atalk_68k.cla` correctly uses 4096 (`rtAt68LkBufSz`) —
  the close-out amendment the ledger records is still owed.
- **`toolbox/appletalk.cla:18`** cites
  `Retro68/InterfacesAndLibraries/Interfaces/CIncludes`, while the plan
  and Task 14's CLAUDE.md item standardize on
  `toolchain/universal/CIncludes`. Same files, two spellings.
- **Examples compiled by no test:** `examples/atalkclock.cla` is built
  only inside the gated `mactest/atalk_68k.sh`; `atalkchat.cla` only
  inside `adsp_68k.sh`; `atalkfind.cla` by nothing at all. Same gap
  `serialecho.cla` already has; a `tests/atalk/examples.sh` doing three
  `clarusc` check-only runs would be ~15 lines and catch bit-rot.
- **`tests/lib_mac.sh` `run_mac_pair`** waits on A before B, so a B launch
  error burns A's full budget before either is swept. Cosmetic under a
  420 s deadline.
- **Host stack nits** (all recorded, none reachable today): a non-XO
  `send_response` can evict a live XO slot; `rt_at_nbp_lookup_{done,count,get}`
  accept the private verify slot `RT_AT_NLK` while `lookup_start` refuses
  it; `rt_at_drain`'s 256-datagram guard vs. a 256 KB `SO_RCVBUF`; the
  `TResp` sender gate compares `net` (all-zero on this lane today);
  `rt_at_name_match` has no 0xC5 partial wildcard.
- **`testsuite/toolbox/cases_atalk.cla`** never disposes its `NewPtrClear`
  buffers (matches `cases_serial.cla` house style, and no FreeMem
  assertion is absolute, so nothing breaks) — but `AdspLeak` arrives in
  Task 13 and will want the file to be tidy.

## Deferred-list triage

One line per ledger entry in `final-review-deferred.md`, grouped where
several lines are the same item.

- **27, 28, 29, 50, 68, 85, 101, 105, 106** (process rulings: wave gating,
  models, probe-task review, early dispatch, post-merge gate) — KEEP
  RECORDED; no code implication, already discharged.
- **36** (Task 3's `string(addr)` finding deferred to Task 8) — WRONG *now*:
  it was resolved; `string(addr)` lowers to `rtAtalkAddrStr` and
  `testdata/errors/addr_string.expect` pins the diagnostic.
- **37a** `checkTableMethod` builds `name + "/" + argc` twice — KEEP
  RECORDED (micro).
- **37b** `TyService` mid-enum without the append-last comment — KEEP
  RECORDED, with the CLIR note in Minor above.
- **37c/37d** caps not yet enforced, `usesAtalk` set-but-unread — WRONG now:
  both live (caps in `lowerProgram`, `usesAtalk` in `drive.cla`/`lower.cla`/
  `cprint.cla`).
- **40a** >16 `every` blocks silently never fire — KEEP RECORDED (TODO);
  see Minor.
- **40b** cprint Mac lane can no longer link a window-less `every` program
  — KEEP RECORDED (FUTURE); that lane is slated for 5f deletion.
- **40c** `app` + `every` + no window still forces `rt_ui.h` — KEEP
  RECORDED (pre-existing).
- **40d** `lowSynthConnDispatchers` doc says "one entry point" — KEEP
  RECORDED (comment).
- **45a** `/macplus2` gitignore — WRONG now: done in `df4d86e`.
- **45b, 52-tail** `resfork` rejects `resProtected` (attr 0x20) — KEEP
  RECORDED (TODO); unrelated to AppleTalk.
- **47a** pre-attach pty output discarded — KEEP RECORDED; documented in
  the reference, which is the right resolution.
- **47b** `ConnHClose` does not restore raw mode — KEEP RECORDED; `atexit`
  covers the documented "at exit" contract.
- **47c/47d** `pty.sh` prefix assertion, `head -c` trailing garbage — KEEP
  RECORDED (test precision).
- **47e, 56a** Linux `-D_DEFAULT_SOURCE`, Linux unattached-pty busy-spin —
  KEEP RECORDED (FUTURE); this repo's gate is macOS.
- **56b** EINTR retry now covers the socket send path — KEEP RECORDED; a
  deliberate improvement, correctly called out.
- **48a** `every.sh` header still says "6 ticks" — KEEP RECORDED (comment);
  fix if a fix wave runs anyway.
- **48b** `rt_ext_host.inc` comment overclaims "no signed overflow" — FIX
  BEFORE MERGE (2 lines: the arming cast + the comment); see Minor.
- **48c** no committed conn+`every` fixture — KEEP RECORDED.
- **52** Task 1 carry-forwards (PB padding, re-zeroing, socket-verbatim,
  kill-by-cwd, ENQ bursts) — WRONG as open items: every one is honored in
  the code I read; they are history, not debt.
- **57** register-blocks-for-verify, spec §6.1 amendment — WRONG now: the
  spec carries the amendment.
- **58a** non-XO `send_response` can steal a live XO slot — KEEP RECORDED
  (unreachable: nothing sends non-XO).
- **58b** XO 30 s expiry only runs in `rt_at_poll` — KEEP RECORDED.
- **58c** no test for the 30 s release timer or the responder queue-full
  drop — KEEP RECORDED (test gap, low value).
- **58d** lookup-slot guard asymmetric — KEEP RECORDED; read-only, harmless.
- **58e** NULL obj/type unchecked in register/remove — KEEP RECORDED
  (C-API only; the Clarus path always passes a Pascal string).
- **58f** unit-test case 5 defeatable by an unrelated `LkUp-Reply` — KEEP
  RECORDED.
- **58g** process-global instance never closed — KEEP RECORDED.
- **58h** `atalkdrive call` truncates stdin past 578 — KEEP RECORDED (a
  test tool; the limit is the protocol's).
- **58i** `IP_MULTICAST_LOOP`/`IF` return values ignored — KEEP RECORDED
  (best-effort by design; `IP_ADD_MEMBERSHIP` *is* checked).
- **58j** `rt_atalk.h` include-order comment contradicts itself — KEEP
  RECORDED (comment).
- **58k / 70c** a blocking `call` cannot answer incoming requests; a
  self-call can never succeed on the host — KEEP RECORDED; both are
  documented in `rtSvcCallName`'s own comment, which is the right place.
- **61a** `TResp` sender gate compares `net` — KEEP RECORDED with the
  tripwire noted (`atalk_68k.sh` is green, so all-net-0 holds today).
- **61b** empty-dequeue clear untested — KEEP RECORDED; the code path
  (`rt_at_g_req_live = 0`) is correct and commented.
- **61c** live flag not reset on stack reopen — KEEP RECORDED (never torn
  down).
- **69, 78** name-call lookup slot 10 / `rtAtDevLookupStart` fail-before-
  clobber — WRONG as open items: both verified in the code
  (`rtAtNameCallLk = 10`, `RT_AT_NLK = 11`, `lk[RT_AT_NLK+1]`; the
  native start returns before touching the slot).
- **70a** `tests/bake/atalk.sh` must land with Task 9 — WRONG now: it did.
- **70b** unreachable C-lane SKIP branch + stale TODO lines — WRONG now:
  both removed (`9d39588`, `5624758`).
- **70d** `rtSvcCallAddr` leaves stale reply content — KEEP RECORDED, or
  take the one-line clear-on-entry; see Minor.
- **70e** host `rtAtDevAtpPoll` never returns < 0 — KEEP RECORDED
  (documented at both ends).
- **75** `atalk.cla` at 974 lines — KEEP RECORDED; it is 994 now and reads
  fine.
- **77** the LaunchAPPL/ADSP boot-path block — **FIX BEFORE MERGE**, as
  C1: it is the reason `adsp_68k.sh` cannot pass, and the branch cannot
  go to `main` with a red T2 stage.
- **81a** `appletalk.cla` header should point at `toolbox/files.cla` for
  `IOParam` — KEEP RECORDED (comment).
- **81b, 83a** case buffers never disposed; the `nbpBuffOvr` comment for
  `maxToGet 16` — KEEP RECORDED.
- **83b** `catalog.sh` header still says "copied verbatim from
  catalog_test.go" — KEEP RECORDED (stale comment, Go lane is gone).
- **87** Task 8 carry-forwards (`and not want68k`, `tests/bake/atalk.sh`,
  the length check hoist) — WRONG as open items: all three are in
  (`lowSynthConnPump`, `bake/atalk.sh`, `rtSvcCallName`'s hoisted check).
- **89a** ~70 duplicated dispatcher-builder lines — KEEP RECORDED; do NOT
  fold before merge (reasoning in Minor).
- **89b, 111b** `examples/atalkfind.cla` / `atalkclock.cla` compiled by no
  T1 test — KEEP RECORDED (TODO), with the cheap fixture suggested above.
- **89c** `runerr.sh` skips the cap cases without multicast — **FIX BEFORE
  MERGE** (I2): it is a ~5-line gate move and it protects the phase's own
  cap diagnostics on any machine without multicast.
- **89d** `lowUiSynthExternName`'s mid-function `usesAtalk` guard — WRONG
  now: made unconditional in Task 9, with the reason recorded.
- **89e, 116** `tests/atalk/` T1 cost / narrow the lock — **FIX BEFORE
  MERGE** (I1): the controller's own ruling scheduled the narrowing for
  this wave and it is not in the tree.
- **89f** `call.sh` hardcodes `Nobody-T$$` — KEEP RECORDED (fine: `$$` is
  the per-run suffix).
- **89g** `atalkfind` header says 30 lines — KEEP RECORDED (comment).
- **96** stale "docs/TODO.md's fix (b)" citations; no gate covers cookbook
  fences — KEEP RECORDED; fix the three citations if a fix wave runs, and
  put the cookbook-fence gate in TODO (255 new cookbook lines are
  currently unchecked by anything).
- **98** cookbook `lookupType` returns 0 on a refNum mismatch; ragged
  FUTURE line — KEEP RECORDED.
- **103a** spec §5.6 2 KB vs code 4096 — FIX BEFORE MERGE only in the
  trivial sense: it is the close-out spec amendment Task 14 owes, one
  line.
- **103b** `rtAtDevLookupStart`'s re-entrant spin has no deadline — KEEP
  RECORDED; NBP's own 8×3-tick budget bounds it and the comment says so.
- **103c** `rtLsnDevAccept`'s `dspOpen(ocAccept)` is synchronous (~3 s UI
  stall on a failing accept) — KEEP RECORDED (FUTURE).
- **103d** `rtAdspDevRead` returns 0 on error — KEEP RECORDED; see Minor.
- **103e** `rtAt68LkTuple` O(n²) walk — KEEP RECORDED (32 tuples max).
- **103f** lookup/service pools never freed (~40 KB worst case) — KEEP
  RECORDED; bounded, and `AdspLeak` (Task 13) should take its baseline
  after the first `serve`/`stop`, as noted.
- **103g** accepted connections may land in a user-declared connection
  variable's slot — KEEP RECORDED; spec-intended shared table.
- **103h** "own address from NTE+4..7" requirement retired — WRONG as an
  open item; the ruling stands and nothing needs it.
- **111a** `kill "$hostpid"` does not kill an in-flight `atalkdrive` child
  — KEEP RECORDED (a leaked 10 s tool process at worst).
- **112, 113, 120** Task 11 minors (identical events files, A-before-B
  wait, the `~5 free ticks` comment, `client_echo_bytes` vacuous on an
  empty log, no T1 build of `atalkchat`) — KEEP RECORDED; note that
  `client_echo_exact` covers the vacuity and the pair-wait is cosmetic.
- **122** Task 10's `at_call` retry to be re-tested and deleted if
  redundant — KEEP RECORDED; the retry is correctly scoped (it retries
  only the NBP resolve, never an ATP verdict) and deleting it is
  optional.

## Recommendations

1. **Gate or fix `adsp_68k.sh` before T2** (C1). Everything else in Task
   14 is mechanical; this is the only thing that can turn the merge gate
   red on its own.
2. **Take the four small code fixes as one fix wave** — C2 (the `call`
   reply guard + fixture), I1 (lock narrowing + ownership check + 600 s),
   I2 (runerr gate move), I3 (listener re-arm). Together they are well
   under 100 lines and each is independently testable on the host.
3. **Then the doc pass**: I4's host-lane reference paragraph, the spec
   §5.6 amendment, the three stale "fix (b)" citations, and Task 14's own
   CLAUDE.md items (the `tests/atalk/` and `tests/atalkdrive/` groups,
   `CLARUS_ATALK_IFACE`, the stale `Retro68/InterfacesAndLibraries` path,
   and — worth adding — `atalk.cla`/`atalk_68k.cla` in the runtime-module
   and bake-list prose).
4. **Do not refactor the dispatcher duplication in this phase.** It is
   the one "should we fold it" question the ledger raises, and the answer
   is no: the fold edits golden-pinned connection builders for zero
   behavior change, immediately after a corpus rebless. MacTCP makes it a
   third copy and pays for itself then.
5. **Backward compatibility is sound but not free, and that is worth a
   line in HISTORY:** every native program's A5 globals grew 1596 → 6910
   bytes (the unconditional 68k `atalk` splice plus conn's 4 → 8 slots),
   and every host `connection` program now carries the `atalk_c.cla`
   wrappers (visible in `connpump_abort.c.golden`). Both were planned;
   neither is reversible without un-picking the splice decision.
6. **After the fixes, re-run T1 and time it.** If the narrowed lock does
   not bring T1 back near a minute, the next lever is running the
   `tests/atalk/` group's builds outside the lock entirely (they are pure
   compiles) rather than dropping the lock.

## Assessment

**Ready to merge?** With fixes

**Reasoning:** The engineering is strong — spec-faithful across the whole
§4 surface, disciplined about 68k parameter-block and heap lifetime,
defensively parsed on the wire, and tested with assertions that would
actually fail if the properties broke — but one committed test
(`mactest/adsp_68k.sh`) cannot pass on the current boot disk and would
turn T2 red, and `svc.call`'s unguarded `reply` out-parameter lets a
plausible one-line user program compile into a heap-corrupting binary.
Both fixes are small and local; with those plus the three Important
items, this is ready.
