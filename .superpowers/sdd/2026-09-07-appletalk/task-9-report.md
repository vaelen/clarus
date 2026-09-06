# Task 9 report — Native integration: `atalk_68k.cla` real bodies, ADSP in `conn.cla`, the 68k splice, the golden rebless

Worktree `/Users/andrew/repos/clarus-wt/t9`, branch `appletalk-t9`, on top of 8ef9fe6.

## 1. What was implemented

### `runtime/clarus/atalk_68k.cla` — every waist body, no stub left (198 -> 1450 lines)

All 30 waist entries (`rtAtDev*` x 23, `rtAdspDev*` x 7, `rtLsnDev*` x 7) are real Device
Manager `_Control`/`_Status`/`_Open` calls against `.MPP`/`.ATP`/`.XPP`/`.DSP`, every csCode
and offset taken from `toolbox/appletalk.cla`.

Five rules the file states in its own header and obeys throughout:

1. **Full re-zero before every reuse** (`rtAt68Zero`) — the probe's three hangs.
2. **Never reissue into a driver-owned block.** `rtAt68Pending(pb)` is `ioResult == 1`.
   Calls that must run WHILE a block is live (`dspClose`, `dspRemove`, `dspCLDeny`,
   `dspCLRemove`) go through a separate `rtAt68DspAux` block instead of the slot's own.
   Every remaining reissue site has a defensive `rtAt68Pending` guard that fails the call
   rather than clobbering the block.
3. **`peekw` zero-extends** — the coordinator's mid-task note, which matched what I had
   already built: the in-progress test is `== 1`, never a sign-dependent `<= 0`, and every
   16-bit value that can be negative (`ioResult`, a driver refNum, an OSErr) goes through
   `rtAt68SignW` / `rtAt68Result`. `word` *record fields* already read sign-extended, so the
   extern-record locals (refNums from `PBOpenSync`, `numOfResps`) need no correction.
4. **NBP registers the socket verbatim** — the ATP socket (service) or the listener's DDP
   socket goes into `NTE + nteAddress + 3` before `registerName`.
5. **`ptr` is not a legal container element** (language reference Ch13), so every per-slot
   block address lives in an `int[]` and round-trips through `int()`/`ptr()`. Exact on this
   lane. See deviations below.

Structure:

- **Bring-up** (`rtAtDevUp`): `PBOpenSync` `.MPP` then `.ATP` (both ROM-resident; a failure
  is a real "no AppleTalk"), then `.XPP` and `.DSP` with failure TOLERATED —
  `rtAt68XppRef == 0` makes `rtAtDevZones` answer `noBridgeErr` (atalk.cla substitutes
  `["*"]`), `rtAt68DspRef == 0` makes every `rtAdspDev*`/`rtLsnDev*` answer
  `rtAtErrNoHost`. That is the LaunchAPPL stripped-boot-disk path, and it is exercised for
  real by the new hardware boot.
- **NBP registration**: a 4-entry NamesTableEntry pool (2 services + 2 listeners, spec
  §4.5's caps). `rtAtDevRemove` finds its entry by comparing the caller's object/type
  against the packed entity already sitting in the NTE.
- **NBP lookup**: 11 lookup slots (2 browsers, 8 connection slots at `slot+2`, slot 10 for
  the synchronous name-call), each with a lazily allocated PB + entity + reply buffer.
  Async `PBControlAsync` `lookupName`, `interval` 8, `count` 3, `maxToGet` 32.
  `rtAtDevLookupStart` fails BEFORE touching the slot's buffer or entity on every path
  (driver missing, allocation failure), per the review ruling.
  `rtAt68LkTuple`/`rtAt68SkipPStr` walk the variable-stride reply tuples;
  `rtAtDevLookupName` returns `"Object:Type"`, the same spelling the host lane produces.
- **ZIP zones**: sync `xCall`/`zipGetZoneList` loop over `.XPP` until `zipLastFlag`,
  appending each Pascal string. The `XCallParam` local is deliberately reused across the
  loop — `zipInfoField` is ZIP's own continuation state and must NOT be cleared between
  calls of one sequence (and the call is synchronous, so the block is never driver-owned
  between iterations).
- **ATP service side**: `openATPSkt` (socket 0 -> dynamic), async `getRequest` armed exactly
  once per outstanding request (`rtAt68SvcGetLive` is the device-side twin of atalk.cla's
  `rtSvcArmed`, and is what stops a completed-but-not-yet-re-armed block being read twice),
  async `sendResponse` with an 8-entry BDS over the slot's own 4624-byte reply buffer,
  `rtAtDevAtpRespBusy` = that block's `ioResult == 1`.
- **ATP requester**: sync `sendRequest`, XO, `timeOutVal` 2, `retryCount` 3, BDS x8 over a
  shared 4624-byte buffer, responses COMPACTED to the front (each lands at its own 578-byte
  slot, so a short response leaves a gap the caller must never see), code =
  `BDS[0].userBytes`.
- **ADSP**: per connection slot a 242-byte CCB, 1 KB send + 1 KB receive queues, a 570-byte
  attention buffer and a reused 68-byte parameter block. `dspInit` + async
  `dspOpen(ocRequest)`; `avail` = `dspStatus.recvQPending`; `read` = sync `dspRead`;
  `write` = sync `dspWrite` with `flush`; `gone` = `peekw(ccb + ccbState) >= sClosing`
  (`TRCCB.state` is a UInt16, so `peekw`, not `peekb`); `close` = `dspClose` + `dspRemove` +
  `DisposePtr` of the four blocks, so Task 11's `AdspLeak` can prove FreeMem flat.
- **Listener**: `dspCLInit` -> socket read out of `ccb + ccbLocalSocket` (what
  `rtLsnDevSocket` returns and NBP registers), async `dspCLListen`, `rtLsnDevAccept` builds
  a connection end on the free slot and `dspOpen`s it `ocAccept` carrying `remoteCID`,
  `remoteAddress`, `sendSeq`, `sendWindow`, `attnSendSeq` from the completed listen block,
  `dspCLDeny`/`dspCLRemove` through the aux block.

### `runtime/clarus/conn.cla` — transport dispatch and 8 slots

- `rtConnMax` 4 -> 8; all four state arrays `[4]` -> `[8]`; new
  `const rtConnTransportAtalk: int = 1`.
- `rtConnOpen` switches: tag 1 -> `rtAdspOpenName(slot, spec)`, no `rtConnPendOpened` (the
  slot stays `stClosed`; the pump flips it), tag 2 -> serial exactly as before, and the
  serial success path now clears the slot's transport tag.
- `rtConnSendText` -> `rtAdspWrite` for transport 1.
- `rtConnClose` -> `rtAdspClose` (which resets the tag and phase via `rtAdspFailed`) and
  then clears the tag unconditionally.
- `rtConnPump` gained a new arm ahead of the servicing block: a transport-1 slot that is not
  yet open drives `rtAdspPoll`, firing `opened` on 1 and staging `failed` on < 0. The
  servicing block routes gone/avail/read per transport, using `rtAdspReadInto(i, t)` — the
  batched read spec §5.3 asks for — instead of the byte-at-a-time serial loop.

### `runtime/clarus/atalk.cla`

One line of the carried Task 8 review fix: `rtSvcCallName`'s `req.length > rtAtMaxReq`
check hoisted above the NBP lookup (spec §4.4: rejected "before any packet leaves").
`tests/atalk/call.sh`'s runtime bound tightened 20 s -> 15 s to match (three lookups now,
not four).

### Sizes

`runtime/clarus/conn_68k.cla` `rtConnOutRef`/`rtConnInRef` `[4]` -> `[8]`;
`runtime/host/rt_serial.inc` `RT_CONN_MAX` 4 -> 8 with four more initializer rows.

### Compiler

- `clarusc/lower.cla`: connection cap 4 -> 8 in the slot pre-pass (and its abort message)
  and in all four `while i < 4` dispatcher loops; `lowSynthConnPump`'s `rtAtalkPump()` gate
  loses `and not want68k`; `lowSynthAtalkDispatchers` gate becomes `usesAtalk or want68k`;
  `lowUiSynthExternName`'s AppleTalk block became UNCONDITIONAL (see finding 2 below).
- `clarusc/drive.cla`: the `want68k` splice adds `atalk.cla` + `atalk_68k.cla` after
  `conn_68k.cla`.
- `clarusc/bake.cla`: `bakeModuleList`'s 68k lane adds the same pair in the same position
  (23 -> 25 modules; `tests/bake/header.sh`'s literal bumped with it).
- `clarusc/cg68k.cla`: `cgSeveredFamily` classifies `clar_lsn_fire_`/`clar_brs_fire_`/
  `clar_svc_fire_` as family 1 alongside `clar_ui_fire_`/`clar_conn_fire_` (see finding 3).
- `scripts/build-clarusc-mac.sh`: NO change needed — its `--bake` loop is
  `for f in runtime/clarus/*.cla toolbox/*.cla`, a glob, so `atalk_68k.cla` is picked up
  automatically.

### New tests and fixtures

- `testdata/cg68k/atalk_server.cla` + `atalk_client.cla` (+ 5 blessed `.s` segments each):
  between them every AppleTalk lowering site the phase added.
- `tests/bake/atalk.sh`: the `emit68k_pair` `--rtbake` byte-identity twin (`PAIRFB=forbid`),
  the standing rule for a new value-typed runtime module. Its fixture touches serve / reply
  (text AND string) / stop / call (address AND "Name:Type") / find (both arities) / zones /
  register / `open(appletalk ...)` / `open(addr)` / send / close / `string(addr)`, with one
  handler per event so all seven dispatchers get non-empty arms.
- `testdata/atalk/selfserve.cla` + `tests/mactest/atalk_selfserve.sh`: the new no-peer
  native hardware boot.

## 2. Tests

### T1 gate — `scripts/test-task.sh --smoke`

```
tests: 102 passed, 31 skipped, 0 failed      (make -j t1)
PASS perfgate/tripwire 0s
tests: 1 passed, 0 skipped, 0 failed         (make test T=perfgate/)
PASS mactest/smoke_bounce 7s
PASS mactest/tick 3s
tests: 2 passed, 0 skipped, 0 failed         (make smoke)
test-task.sh: PASS in 41s (smoke=1)
```

### `make test T=bake/` (full group)

```
tests: 23 passed, 7 skipped, 0 failed
PASS bake/atalk 0s          <- the new twin
PASS bake/connfileh 0s
PASS bake/header 0s         <- 25 modules on the 68k lane
PASS bake/identity 1s
PASS bake/twice 0s
(the 7 SKIPs are the CLARUS_BAKE_FULL=1 full_corpus_* scripts, T2-only)
```

### Host lane, AppleTalk + connection + emitui groups

```
PASS atalk/splice 1s     PASS atalk/zones 4s      PASS atalk/find 16s
PASS atalk/call 18s      PASS atalk/serve 30s     PASS atalk/runerr 15s
PASS emitui/goldens 3s   PASS testsuite/catalog 0s  PASS testsuite/catalog_ui 1s
PASS conntest/* (11)     PASS atalkdrive/lookup 7s
```

### `make test T=cg68k/`

```
PASS cg68k/goldens 1s   (after CLARUS_CG68K_BLESS=1, 57 fixtures)
PASS cg68k/selfemit, vasm, determinism, image, release, segments,
     array_assign, include_retry, nested_tmp_alias, pop_rec_release,
     rtdir_symlink, unspliced_guard
```

## 3. The rebless proof

Procedure: capture each golden as committed at 8ef9fe6 (`git show HEAD:...`), regenerate,
then diff after normalizing A5 offsets and label numbers. The brief's normalizer
(`sed -E 's/-?[0-9]+\(A5\)/OFF(A5)/g; s/L[0-9]+/L/g'`) does NOT match this backend's label
spelling — cg68k emits `LBL_227:`, and `L[0-9]+` requires a digit immediately after `L`, so
every label line survived as noise. The normalizer actually used adds that case:

```sh
sed -E 's/-?[0-9]+\(A5\)/OFF(A5)/g; s/LBL_[0-9]+/LBL/g; s/\bL[0-9]+/L/g'
```

Three unrelated goldens, HEAD vs reblessed:

| golden | raw diff lines | normalized | hunks | code REMOVED | code ADDED |
|---|---|---|---|---|---|
| `arith.s` | 3520 | 448 | 42 | **2** | 323 |
| `bounce.s` | 153 | 75 | 5 | **1** | 1 |
| `bounce.seg2.s` | 22 | **0** | 0 | 0 | 0 |
| `bounce.seg3.s` | 384 | **0** | 0 | 0 | 0 |
| `bounce.seg4.s` | 801 | 373 | 37 | **1** | 322 |
| `calls.s` | 3512 | 448 | 42 | **2** | 323 |

("code" = the diff with the `;`-prefixed globals-listing comment block filtered out.)

Every REMOVED code line across all six, in full:

```
arith.s        MOVE.W #797,D0     MOVEQ #65,D0
bounce.s       MOVE.W #799,D0
bounce.seg4.s  MOVEQ #65,D0
calls.s        MOVE.W #797,D0     MOVEQ #65,D0
```

That is the whole residual: the startup globals block-zero word count (797 -> 4478, 799 ->
4480) and the handle-typed-globals release count in `cg_free_globals` (65 -> 126, the new
`string[2]`/`string[8]` arrays). Nothing else was removed or CHANGED anywhere — every other
normalized line is a pure ADDITION, and they decompose as:

- the four `clar_conn_fire_*` dispatchers' new slot 4..7 arms (8 lines apiece: the
  `MOVE.L n(A6),D1 / MOVEQ #k,D0 / CMP.L / SEQ / ANDI.L / TST.L / BEQ.W / BRA.W` shape,
  plus the fall-through labels);
- exactly **7** new `LINK A6,#-2100` function bodies — `clar_lsn_fire_accepted`,
  `clar_lsn_fire_failed`, `clar_brs_fire_found`, `clar_brs_fire_done`,
  `clar_brs_fire_failed`, `clar_svc_fire_request`, `clar_svc_fire_failed` (JT slots
  170..176 in `arith`), all seven with empty arms in a program that declares no AppleTalk
  resource.

`bounce.seg2.s` and `bounce.seg3.s` normalize to a ZERO-line diff: those segments are pure
user code and moved only by A5 offsets and label renumbering.

Globals grew from 1596 to 6910 bytes below A5 in every native program. 505 of those 5314
bytes are `atalk_68k.cla`'s own; the rest is `atalk.cla`'s (Task 7's tables — four
`string[2]` name arrays and three `string[2]` message arrays are 3.5 KB of it). One fixture
(`arr_whole_assign`) crossed a segment boundary and gained a `seg2.s` golden.

Then `CLARUS_CG68K_BLESS=1 make test T=cg68k/goldens` — 57 fixtures, 71 `.s` files rewritten
(including the two new AppleTalk fixtures' 10).

## 4. Hardware checks (`CLARUS_MAC_TESTS=1 make -j1 test T=mactest/...`)

```
PASS mactest/toolbox_68k 303s     39 case PASS lines, 0 FAIL, incl. PASS AtalkSelf
PASS mactest/atalk_selfserve 15s  (NEW)
PASS mactest/smoke_bounce 7s
PASS mactest/tick 3s
tests: 2 passed, 0 skipped, 0 failed  /  make smoke: 2 passed
```

`atalk_selfserve` per-case output, all through the new native bodies with no peer:

```
PASS exit               ##CLARUS-EXIT## 0
PASS served             POpenATPSkt + PRegisterName(verify) + async PGetRequest
PASS no_svc_failure     no svc.failed staged by any of those three
PASS zones              "zones 1 *"  -- .XPP absent -> noBridgeErr -> ["*"]
PASS lookup_done        "done 0"     -- async PLookupName completed, 0 tuples parsed
PASS no_brs_failure     no brs.failed
PASS no_watchdog        the program ended from `done`, not from its own timer
PASS call_no_name       "call err -1025 name not found" -- the sync name-call path
                        (lookup slot 10, spun to completion) on lookup slot 10
PASS stopped            PRemoveName + PCloseATPSkt
PASS listener_no_dsp    lsn.register failed with exactly
                        "-1273 streams not available on this lane" (.DSP absent)
```

It passed on the first boot, with no hang — the PB re-zero discipline held.

## 5. Files changed

Runtime: `runtime/clarus/atalk_68k.cla` (+1408/-155), `runtime/clarus/conn.cla`,
`runtime/clarus/conn_68k.cla`, `runtime/clarus/atalk.cla` (+8), `runtime/host/rt_serial.inc`.

Compiler: `clarusc/lower.cla` (+97), `clarusc/cg68k.cla` (+16), `clarusc/drive.cla`,
`clarusc/bake.cla`.

Tests: `tests/bake/atalk.sh` (new), `tests/mactest/atalk_selfserve.sh` (new),
`tests/bake/header.sh` (module count), `tests/atalk/call.sh` (runtime bound).

Fixtures/goldens: `testdata/atalk/selfserve.cla` (new),
`testdata/cg68k/atalk_{server,client}.cla` + 10 new `.s` (new),
`testdata/cg68k/arr_whole_assign.seg2.s` (new segment), 48 reblessed `testdata/cg68k/*.s`,
5 reblessed `testdata/emitui/*.c.golden`.

## 6. Findings, deviations, and things the next task should know

**1. `testdata/emitui` goldens DID change — and were already red at 8ef9fe6.**
The brief's item 10 said they must not. Two independent reasons they had to move:

- They were STALE ON ARRIVAL. `git show HEAD:testdata/emitui/atalk_browser.c.golden` still
  declares `cv_rtBrsPendDone`, a global `atalk.cla` has not had since Task 8's fix round 1,
  and lacks `cv_rtSvcArmed`, which that round added. `make test T=emitui/goldens` fails on
  the branch tip before any edit of mine. Task 8 changed `atalk.cla` without reblessing the
  five goldens that carry the host runtime.
- My own `conn.cla` change moves them regardless: `rtConnState` and friends become `[8]`
  (new `clar_arr_*_8` typedefs, new loop bounds in the globals initializer), and
  `rtConnOpen`'s new ADSP branch interns `"could not open connection"` before
  `"invalid connection spec"`, swapping two string literals' indices.

Five goldens reblessed (`atalk_browser`, `atalk_client`, `atalk_listener`, `atalk_server`,
`connpump_abort`) by re-running `clarusc emit`. **Merge-conflict risk**: the concurrent
compiler-fix subagent (`lower.cla`/`cprint.cla`, host `every` pump) may touch these same
files and `lower.cla`.

**2. `lowUiSynthExternName`'s AppleTalk block had to become UNCONDITIONAL, not
`usesAtalk or want68k`.** Making it mirror `lowSynthAtalkDispatchers` exactly broke
`clarusc --bake-ir --lane 68k` outright: the bake lowers the whole runtime chain with BOTH
`want68k` and `usesAtalk` false (main.cla quits before either is set), so the gate answered
-1, `rtAtalkPump`'s `ECallExt` fell through to cg68k's ordinary extern dispatch, and the
bake aborted with `extern clar_svc_fire_failed has no trap clause and no nat_ fallback` —
21 `bake/` scripts red. The connection five have always been unconditional, which is exactly
why they never hit this: an unconditional answer routes the call to `cgCallExtUiSynth`,
which TAINTS the capture under `cgBakeCapture` instead of crashing. Consequence on the host
lane, verified: a serial-only host program (`connpump_abort`) now emits seven fewer
`extern rt_ext_clar_*_fire_*` prototypes — for functions it never references, since
`shake.cla` roots `rtAtalkPump` only under `irUsesAtalk`. Strictly an improvement, and part
of that golden's rebless.

**3. `cgSeveredFamily` now classifies the seven AppleTalk dispatchers as family 1**
(`clar_lsn_fire_`/`clar_brs_fire_`/`clar_svc_fire_`, beside `clar_ui_fire_`/
`clar_conn_fire_`). Not in the brief; added because this is the wave that first makes those
dispatchers exist on the native lane. They are built by `newIRFunc` directly, never through
`lowFuncBody`, so `irFuncBail` is always -1 for them — without the classification,
`cgCurFuncIsUiDispatcher` is false inside them and an `abort` raised in an
`on svc.request`/`on lsn.accepted` handler gets neither the §3.5 in-place default nor a bail
target. Same treatment a `connection` handler has had since serial-connection Task 6. No
test covers it (an abort-in-AppleTalk-handler fixture would be a good Task 11/12 addition).

**4. `PSendResponse` sets `atpEOMvalue` as well as the XO flag.** The brief's sequence said
XO only. Inside Macintosh's `PSendResponse` takes EOM too, and it is load-bearing rather
than decorative: ATP's requester completes on "every bitmap packet received AND an
end-of-message packet seen". The host lane's own stack states that rule in code —
`rt_atalk.inc`'s `rt_at_rq_done` is `eom_seq >= 0 && bitmap == 0` — and that stack is the
peer Task 10 drives the Mac against, so without EOM every cross-lane `atalkdrive call`
would have timed out with `reqFailed`. Header-vs-IM rule applied: the header supplied the
offsets, IM supplied the sequencing.

**5. The brief's global table wrote the per-slot block arrays as `ptr[10]`, `ptr[2]`,
`ptr[8]`. The language forbids it** — `T[n]` of `ptr` is a build-time error (reference
Ch13, "It may not be a container element"), the same constraint `atalk_c.cla`'s own header
already records. They are `int[]` here, round-tripped through `int()`/`ptr()`; exact on a
lane where both are 32 bits, and this module is never spliced on the host.

**6. Deviations from the brief's global table, each for a stated reason:**
- Lookup slots are **11**, not 10 — `atalk.cla`'s `rtAtLookupMax` is 11 (2 browsers + 8
  connection slots at `slot+2` + slot 10 for the name-call), per the Task 7 review ruling.
- Lookup reply buffers are **4096**, not 2048. A tuple is at most 104 bytes and `maxToGet`
  is 32, so 2048 would answer `nbpBuffOvr` on a populated zone instead of returning
  tuples — the exact sizing trap `cases_atalk.cla`'s own lookup comment records. Allocated
  lazily per slot, so a one-browser program pays 4 KB, not 44.
- `rtAt68SvcNte`/`rtAt68LsnNte` are one shared **4-entry NTE pool** instead of two 2-entry
  arrays: `rtAtDevRegister`/`-Remove` take no slot index (the waist signature is the host
  lane's), so a pool is the only shape that works, and 4 is exactly 2 services + 2 listeners.
  Remove matches on the packed entity already in the NTE rather than a parallel
  `string[4]` pair — two of those would have been 2 KB of A5 globals in every native
  program.
- `rtAt68Scratch` was not created (YAGNI: `rtAdspReadInto` allocates its own).
- One extra block the table did not list: `rtAt68DspAux`, a single 68-byte DSP parameter
  block for the four calls that must run while a slot's own block may still be
  driver-owned (`dspClose`, `dspRemove`, `dspCLDeny`, `dspCLRemove`).

**7. A lookup RESTART while that slot's own lookup is still in flight SPINS the old one out
rather than cancelling it** (`rtAtDevLookupStart`, marked `ponytail:`). Reissuing into a
live block is the probe's hang, and `killNBP` (csCode 254) is exactly the shape of ROM call
the probe found unimplemented on the Mac Plus (`killAllGetReq` answered -17). NBP's own
retry budget bounds the spin at ~3 s, and only a re-entrant `find` from inside a `found`
handler can reach it. Upgrade path recorded in the code: `killNBP` behind a hardware check
that it works on this ROM.

**8. For Task 11's `AdspLeak`:** `rtAdspDevClose` disposes the CCB, both queues and the
attention buffer (~3.4 KB) but KEEPS the slot's 68-byte parameter block — freeing a block
the driver may still own is the hazard rule 2 exists for. So FreeMem is exactly flat across
cycles 2..n, and 68 bytes lower after cycle 1 than before it. Measure the baseline after the
first open/close, not before.

**9. The connection cap is now 8** (`clarusc emit: too many connection variables (max 8)`).
Nothing in `docs/` or `tests/` pinned the old "max 4" text, so no doc edit was needed here —
but the docs task should make sure the reference says 8.

**10. `bake/header.sh`'s 68k module count is a hand-maintained literal**, 23 -> 25. Same
class of by-hand sync as the suite case counts.

## 7. Self-review against the task's own checklist

- Every waist body implemented, no stub left: **yes** — 30 entries, all real calls.
- PB re-zero discipline: **yes**, plus a `rtAt68Pending` refusal at every reissue site and
  a separate aux block for the four calls that cannot use the slot's own.
- `conn.cla` dispatch complete for all six operations + open/close/pump: **yes**
  (open, send, close, gone, avail, read, and the pump's own open state machine).
- Caps 8: **yes** — `conn.cla` (const + 4 arrays), `conn_68k.cla` (2 arrays),
  `rt_serial.inc` (macro + initializer), `lower.cla` (pre-pass + 4 dispatcher loops).
- Both gate flips: **yes**, plus the third one they forced (finding 2).
- Goldens reblessed with the proof: **yes**, §3.
- Bake twin green: **yes**, `PASS bake/atalk`.
- Hardware checks green: **yes**, §4.
- emitui goldens unchanged: **NO** — see finding 1. They moved, for two reasons, one of
  which predates this task.

## 8. Commit

`6646efb` on `appletalk-t9` (single commit — the runtime, the compiler splice and the
goldens are mutually dependent, so splitting would have left two red intermediate commits):
`feat(native): AppleTalk on the 68k lane (NBP/ATP/ZIP/ADSP/listener), ADSP as connection
transport 1, 8 connection slots; golden rebless`.

## 9. Concerns for the coordinator

1. **Conflict risk with the concurrent compiler-fix subagent** on `clarusc/lower.cla` and
   `testdata/emitui/*.c.golden`. My `lower.cla` edits are the two gate flips, the cap 4->8,
   and the `lowUiSynthExternName` block; my emitui reblesses are all five conn/atalk
   goldens. Whoever merges second re-runs `clarusc emit` over the emitui fixtures.
2. **`tests/emitui/goldens` has no bless variable** — the goldens are updated by
   `clarusc emit -o <golden> <fixture>` by hand. That is why Task 8's fix rounds left them
   stale and nobody noticed until this task ran the group. Worth a `CLARUS_EMITUI_BLESS=1`
   in a cleanup pass, or at minimum a note in CLAUDE.md's bless-variable list.
3. **Task 10 depends on finding 4** (`atpEOMvalue`). If the two-machine ATP test ever comes
   back `reqFailed` with the Mac as server, that flag is the first thing to check.
4. **Task 11's `AdspLeak` baseline** — see finding 8: the per-slot 68-byte parameter block
   is allocated once and kept.
5. **No test covers `abort` inside an AppleTalk handler** on the native lane, even though
   finding 3 made the codegen support it.
6. The docs task should make the reference say **8** connection variables, not 4.
