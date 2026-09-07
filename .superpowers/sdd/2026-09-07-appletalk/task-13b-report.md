# Task 13b report -- `AdspLeak`: BLOCKED on a compiler visibility boundary

**Status: NEEDS_CONTEXT. Nothing implemented, nothing committed, worktree clean at
4606155.** No emulator time was spent -- the blocker is a compile-time wall, found
before any boot.

## The finding

The brief's design does not compile. A `testsuite/toolbox` case **cannot name
`rtAtEnsureUp` / `rtAt68DspInitEnd` / `rtAdspDevClose` / `rtLsnDevInit` /
`rtLsnDevSocket` / `rtAt68DspRef`**, because `--testapi` does not make
`atalk.cla` / `atalk_68k.cla` / `conn.cla` visible to user code.

The brief's premise was that `--testapi` is what lets `cases_uitest.cla` call
`rtUiEveryPump()` and friends, so any runtime name is reachable. It is narrower
than that: `--testapi` early-splices a **fixed thirteen-module list** ahead of
check#1, and the AppleTalk modules are not in it.

- `clarusc/drive.cla:1284-1332` (`driveEarlySplice`) -- the from-source list is
  exactly `core, str, text, list, map, uidesc, ui, uiwidgets, uitext, uitable,
  uiscript, uidialogs, uitest`.
- `clarusc/bake.cla:413+` (`bakeModuleList`) + `bakeGenerateChain`'s
  `earlyVisibleAsmHeadsBoundary` -- the bake path pins the same thirteen as "the
  testapi-visible checker-symbol boundary"; everything else
  (`sortedmap/datetime/ser/native`, and the AppleTalk family) is manifest-splice
  only, i.e. spliced AFTER check#1 and invisible to user code.
- `runtime/clarus/atalk*.cla` are in the 68k **superset** (spliced into every
  native build, per `CLAUDE.md`) -- but "spliced into the program" and "visible
  to check#1" are different things, and only the latter lets user code name them.

### Evidence (verbatim)

Probe: `caseAtalkSelf`'s file, plus

```
func atProbe(): int {
    var e: int
    e = rtAtEnsureUp()
    if rtAt68DspRef == 0 {
        return -43
    }
    e = rtAt68DspInitEnd(7)
    rtAdspDevClose(7)
    return e + rtLsnDevInit(7) + rtLsnDevSocket(7)
}
```

built exactly as `tests/lib_mac.sh`'s `toolbox_emit68k` builds the suite
(`emit68k --rtdir runtime/clarus/ --events testdata/ui/toolboxsuite.events
--testapi --bake testdata/mac-resident/resbake.bin` + `toolbox_files.txt`, run
from `build-run/emitcwd`):

```
../../testsuite/toolbox/cases_atalk.cla:226:21: undefined: rtAtEnsureUp
../../testsuite/toolbox/cases_atalk.cla:227:8: undefined: rtAt68DspRef
../../testsuite/toolbox/cases_atalk.cla:230:25: undefined: rtAt68DspInitEnd
../../testsuite/toolbox/cases_atalk.cla:231:19: undefined: rtAdspDevClose
../../testsuite/toolbox/cases_atalk.cla:232:28: undefined: rtLsnDevInit
../../testsuite/toolbox/cases_atalk.cla:232:48: undefined: rtLsnDevSocket
```

The same file list without the probe compiles clean (`Finished`), so this is the
probe's names and nothing else.

## Routes I checked and ruled out

**D -- pass the runtime modules as ordinary entry files** (a `toolbox_files.txt`
edit only, no runtime/compiler edit). Adding `runtime/clarus/{conn,atalk,
atalk_68k}.cla` positionally cascades into the rest of the manifest set:

```
../../runtime/clarus/conn.cla:458:52: undefined: rtConnDevReadByte
../../runtime/clarus/atalk.cla:236:18: undefined: SerNewPtr
../../runtime/clarus/atalk.cla:368:18: undefined: SerDisposePtr
../../runtime/clarus/atalk.cla:430:22: undefined: SerDisposePtr
../../runtime/clarus/atalk.cla:735:24: undefined: SerNewPtr
../../runtime/clarus/atalk.cla:746:18: undefined: SerDisposePtr
```

Chasing that means hand-listing `ser.cla`/`native.cla`/the lane files as entries
too -- i.e. hand-rebuilding the manifest splice, and changing the suite's build
shape (and its `--bake` manifest) far more than a new case should.

**C -- reach the waist through the language surface.** The connection-end path is
`c.open(appletalk "Name:Type")` (NBP first, so a no-peer cycle never reaches
`dspInit`) or `c.open(addr)`, which needs an `address` value that only
`serviceBrowser.found` / `service.request` can produce -- not constructible in a
case. The listener path IS exercisable with no peer (`serve` -> `rtLsnStart` ->
`rtLsnDevInit`), but `rtLsnStart` registers the NBP name, ~3.2 s per cycle
(`registerName` with `verifyFlag`, task-1-report P2) -- 20 cycles is ~64 s of
suite wall clock on top of a budget that already had ~126 s of headroom, to prove
only half of what the brief asked.

**E -- a standalone `tests/mactest/adspleak_68k.sh` program instead of a suite
case.** Same wall: the visibility rule is per-compile, not per-suite. A standalone
program cannot name `rt*` either.

## Options for the controller

**A (recommended, implementable today, zero runtime/compiler edits).** Build
`AdspLeak` at the **catalog** level, the exact house style `AtalkSelf`'s own
header already claims ("the catalog files supply the externs, this case only
calls them"): open `.DSP` (FAIL with the OSErr if it does not open -- non-vacuous),
then N cycles of `NewPtrClear(ccbSize)` + two `NewPtrClear(rtAt68QSz)` +
`NewPtrClear(attnBufSize)` + `dspInit` + `dspRemove(abort)` + four `DisposePtr`,
with `TbFreeMem` exactly flat across them. `toolbox/appletalk.cla` already exports
everything needed (`DSPParam`, `dspInit` 255, `dspRemove` 254, `ccbSize` 242,
`attnBufSize` 570, and the whole `dspInit*`/`dspCloseAbort` offset family, lines
171-234 and 511-535).

- What it proves, honestly: the ROM `.DSP`'s own `dspInit`/`dspRemove` pair
  releases everything it took -- the part that genuinely cannot be known without
  hardware -- and that the five-block shape `rtAt68CcbEnsure`/`rtAt68DspFree` use
  is balanced.
- What it does NOT prove: that `rtAt68DspFree` actually disposes what
  `rtAt68CcbEnsure` allocated. That balance is statically auditable in twenty
  lines (`atalk_68k.cla:992-1030`), but a future runtime edit that dropped a
  `DisposePtr` would not be caught by this case.
- Cost: milliseconds of suite time, no network waits. The commit subject and the
  `CLAUDE.md` sentence would have to say "the ROM's ADSP connection-end
  init/remove pair", not "the native ADSP connection-end lifecycle".

**B (the brief's exact claim, but a compiler change).** Add the AppleTalk family
to the `--testapi` early-visible set in BOTH `driveEarlySplice` and
`bakeModuleList`/`bkGenEarlyVisibleAsmHeadsBoundary`. That moves the
testapi-visibility boundary, the bake manifest classification and the
`--rtbake`/bake goldens -- its own task with its own T2, not a line in this one.

**C (defer).** Drop `AdspLeak` from this phase and record it in `docs/TODO.md`
against B.

My recommendation is **A now, B recorded in `docs/TODO.md`** if the controller
wants the true-waist proof later. A is the cheap 80% and it is the half hardware
is needed for; B is the half a code reader can already check.

## Files changed

None. Probes were appended to `testsuite/toolbox/cases_atalk.cla` and reverted;
`git status --short` is empty and HEAD is 4606155.

## Notes

- Unrelated but worth knowing for anyone reproducing a suite build by hand: the
  interactive shell here is **zsh**, which does not word-split an unquoted
  `$args`. The harness's `toolbox_emit68k` idiom only works under `sh`; run it
  from a `#!/bin/sh` script or every entry lands as one argv word and clarusc
  answers `cannot open entry file`.

---

# Task 13b report (2) -- implemented per the controller's option-A ruling

**Status: DONE.** Commit `8b4e3a7` on `appletalk-t13` in
`/Users/andrew/repos/clarus-wt/t13`, on top of Task 13a's `4606155`.

## The case

`caseAdspLeak()` at the foot of `testsuite/toolbox/cases_atalk.cla`, next to
`AtalkSelf`, in that file's house style (Rule 2 fresh blocks, `atPStr`, header
comment saying what it proves and what it deliberately does not).

1. **Open `.DSP`** by name through `toolbox/devices.cla`'s `PBOpenSync` and the
   catalog's `IOParam`. `.DSP` is not in the Mac Plus ROM -- it comes from the
   `AppleTalk` system file -- so this doubles as the case's environment gate. A
   nonzero OSErr or a zero refNum FAILs with both values in the detail
   (`open .DSP err N refNum M`). There is no skip verdict in this suite, and a
   silently-skipped leak check is worse than a red one, so this cannot pass
   vacuously.
2. **20 connection-end cycles** through `tbAdspEndCycle(dspRef)`: `NewPtrClear`
   the five blocks `rtAt68CcbEnsure` allocates (CCB 242 = `ccbSize`, send queue
   1024, receive queue 1024, attention buffer 570 = `attnBufSize`, parameter
   block 68) plus a SEPARATE remove block, `dspInit`, then `dspRemove` with
   `dspCloseAbort` = 1 through that fresh block, then `DisposePtr` on all six.
   Every OSErr is returned and FAILs the case with the cycle index.
3. **20 connection-listener cycles** through `tbAdspLsnCycle(dspRef)`:
   `dspCLInit` with `localSocket` 0 (a CCB and the socket byte only -- exactly
   the two fields `rtLsnDevInit` sets; no queues, no attention buffer) then
   `dspCLRemove` with abort through a fresh block, all three blocks disposed.
   Task 13a confirmed on hardware that `dspCLInit` with `localSocket` 0 assigns
   a dynamic DDP socket, so this loop also incidentally proves `dspCLRemove`
   gives that socket back -- 21 cycles would otherwise start eating into DDP's
   128..254 dynamic range.

### Design choices

- **Slot: none.** The runtime's slot table is not reachable (see below), so the
  case owns its blocks outright and the "slot 7" question does not arise. That
  also removes the brief's collision worry entirely -- no suite case can hold
  one of these blocks live, because they never leave `tbAdsp*Cycle`.
- **Warm-up baseline.** `before` is taken AFTER one full cycle in each loop. The
  first `dspInit` on a freshly opened `.DSP` is where the driver builds whatever
  per-driver state it keeps, and where the Memory Manager first grows the zone
  for our own six blocks; that one-time cost is not a leak. The listener loop
  gets its own warm-up for the same reason (its first `dspCLInit` is the first
  listener the driver has ever seen this boot).
- **Listener loop included**, per the ruling and because Task 13a's report
  confirmed the `dspCLInit`/`dspCLRemove` pair on real hardware. The catalog has
  every constant it needs (`dspCLInit` 251, `dspCLRemove` 250,
  `toolbox/appletalk.cla:175-176`), so nothing was skipped and no catalog extern
  was added.
- **Exact equality, not slack.** Unlike `LeakCheck`, which brackets
  Memory-Manager-heavy handle traffic and needs jitter headroom, every cycle here
  is a strict `NewPtrClear`/`DisposePtr` pair in the application zone. One
  retained byte is a real finding.
- **`FreeMem()` from `toolbox/memory.cla`, not a local extern.** The brief said
  "declared locally exactly as `cases_leak.cla` does", but that file's local
  `TbFreeMem` is already in this build, so a second local declaration of the same
  name would collide; and `toolbox/memory.cla` (already in
  `tests/mactest/toolbox_files.txt`) exports the curated `FreeMem` twin that
  `cases_leak.cla`'s own comment points at. Using it is this file's stated
  discipline -- "the catalog files supply the externs, this case only calls them".
- **Non-vacuity beyond the `.DSP` gate.** Each loop counts completed cycles into
  `ran` and the pass condition is `after == before AND ran == tbAdspCycles`, so
  the loop count is observable and a loop that did not run cannot pass.

## Verification

All four commands run in the worktree, verbatim output.

### 1. `CLARUS_MAC_TESTS=1 make -j1 test T=mactest/toolbox_68k`

```
PASS mactest/toolbox_68k 319s
tests: 1 passed, 0 skipped, 0 failed
```

`build-run/tests/mactest/toolbox_68k.log` (all 40 lines, `AdspLeak` second from
the end):

```
PASS TickCountAdvances
PASS MenuKeyMatches
PASS CanvasChecksum
PASS A5Live
PASS GestaltNamed
PASS EventXRec
PASS UiTestVerbSmoke
PASS PostEventClick
PASS Pattern
PASS Buttons
PASS Winvar
PASS Textwidgets
PASS Menus
PASS Editmenu
PASS Canvas
PASS Zoomwin
PASS Hscroll
PASS Popuptable
PASS Dialogs
PASS Hdim
PASS FormEdit
PASS FieldCap
PASS BigText
PASS Catalog
PASS FInfoStamp
PASS ResourceBake
PASS WriteResStamp
PASS DateTimeRoundTrip
PASS LivePaint
PASS SerialOpenWrite
PASS AtalkSelf
PASS NarrowPopup
PASS LeakCheck
PASS ScrollToEnd
PASS ClearWarm
PASS CasesTable
PASS CanvasIdle
PASS WindowMenus
PASS AdspLeak
PASS SelfCheck
```

40 PASS, 0 FAIL. The `TOTAL 40 PASS 40 FAIL 0` line is asserted by
`suite_report_check` itself (`tests/lib_mac.sh:185`, `grep -qx "TOTAL $2 PASS $2
FAIL 0"`) against `$WORK/cap.out`; the capture directory is removed on a clean
exit, so the script's own PASS is the evidence that line matched exactly. The
same helper's `[ "$_p" -eq "$2" ]` is what turns "40" into a hard count.

**Wall clock: 319 s** for the whole script (emit + Mini vMac boot + suite),
against `run_mac`'s 420 s settle and the script's own `# timeout: 20m`. Task
13a's run of the same script at 39 cases was 286 s, so `AdspLeak` costs roughly
33 s -- 82 synchronous `.DSP` control calls plus ~3 KB of `NewPtrClear`/
`DisposePtr` per cycle on an emulated Mac Plus. That leaves about 100 s of settle
headroom. It fits, but the next case added here should expect to be the one that
forces the settle up; I did NOT raise it.

### 2. `CLARUS_MAC_TESTS=1 make -j1 test T=mactest/toolbox_jiggle`

```
PASS mactest/toolbox_jiggle 331s
tests: 1 passed, 0 skipped, 0 failed
```

`build-run/tests/mactest/toolbox_jiggle.log`: 40 `^PASS ` lines, 0 `^FAIL `
lines, including `PASS AdspLeak`. (Same 40-line body as above; the jiggle lane
forces a `CompactMem` before every scripted dispatch and at the `UiNewPtr`
waist, so `AdspLeak` passing here also says the case survives heap compaction --
which it should, since it holds only non-relocatable pointers.)

### 3. `make test T='testsuite/ emitui/ cg68k/goldens'`

```
PASS testsuite/catalog_ui 0s
PASS testsuite/catalog 0s
PASS testsuite/core_cli 1s
PASS testsuite/lazyintern 3s
PASS emitui/appinfo 0s
PASS emitui/errconst 0s
PASS emitui/goldens 3s
PASS emitui/popupguards 0s
PASS emitui/uiblob 1s
PASS cg68k/goldens 1s
tests: 10 passed, 0 skipped, 0 failed
```

### 4. `scripts/test-task.sh`

```
PASS testsuite/catalog_ui 0s
PASS lowlevel/run 14s
PASS testsuite/core_cli 1s
PASS testsuite/lazyintern 3s
PASS runner/timeout 5s
PASS atalk/call 48s
PASS atalkdrive/lookup 55s
PASS atalk/find 73s
PASS hostrt/atalk 85s
PASS atalk/zones 99s
PASS atalk/serve 130s
tests: 104 passed, 33 skipped, 0 failed
PASS perfgate/tripwire 0s
tests: 1 passed, 0 skipped, 0 failed
test-task.sh: PASS in 131s (smoke=0)
```

`--smoke` was not used: this task touches neither `runtime/` nor `clarusc/`.

Emulator hygiene: `pgrep -fl "minivmac|MacPlus|Snow"` was empty before the first
boot and after the last. Two emulator sessions total (one per gated script);
nothing was killed by app name.

## Files changed

- `testsuite/toolbox/cases_atalk.cla` -- `caseAdspLeak` plus its two cycle
  helpers, `tbAdspFreeIf`, the three sizing constants and the header comment.
  Also corrected the file's existing stale claim that "`.XPP` and `.DSP` are not
  opened at all: both are -43 (fnfErr) on this boot disk" -- true when
  `AtalkSelf` was written, false since Task 13a, and directly contradicted by
  the new case two hundred lines below it.
- `testsuite/toolbox/runner.cla` -- **count site 1**: `nTbCases` 39 -> 40 (and
  its "38 real" comment -> "39 real"), the `AdspLeak` enum member, its
  `tbCaseName` arm, its `tbAllCases` row, its dispatch branch, and a header
  paragraph in the file's own running case log.
- `tests/mactest/toolbox_68k.sh` -- **count site 2**: `suite_report_check ... 40`
  (and its "each of the 39 result lines" comment).
- `tests/mactest/toolbox_jiggle.sh` -- **count site 3**: same.
- `tests/mactest/toolbox_mac.sh` -- **count site 4**: same (the
  `CLARUS_CPRINT_MAC_TESTS=1` lane, not run here).
- `CLAUDE.md` -- **count site 5**: `39 ... 38 real` -> `40 ... 39 real`, and the
  new clause in the running count sentence, worded per the ruling ("the ROM
  `.DSP` `dspInit`/`dspRemove` and `dspCLInit`/`dspCLRemove` pairs leak nothing
  at the runtime's own block sizes", explicitly NOT "the runtime's lifecycle").
- `docs/TODO.md` -- one entry in the AppleTalk phase section, in the file's own
  bullet style: the runtime-waist version needs the AppleTalk modules in
  `--testapi`'s early-visible set (`clarusc/drive.cla`'s `driveEarlySplice`,
  `clarusc/bake.cla`'s `bakeModuleList`), a compiler change that moves the bake
  manifest and the golden corpus, scheduled with the next corpus rebless
  (MacTCP).

**No golden moved, and none could have.** No file under `runtime/` or `clarusc/`
was touched; `cg68k/goldens`, `emitui/goldens` and the whole T1 sweep are green
above.

## Self-review

- *Completeness*: 40/40 on both toolbox boots (`toolbox_68k` and
  `toolbox_jiggle`), all five count sites bumped, no golden moved, the TODO entry
  the ruling asked for is in.
- *Non-vacuity*: the case cannot pass without a working `.DSP` (a failed open
  FAILs with the OSErr), without every cycle returning 0 (each failure carries
  the cycle index), or without both loops actually running
  (`ran != tbAdspCycles` FAILs). FreeMem is compared for EXACT equality, so the
  proof is not smuggled in through slack.
- *Honesty of the claim*: the "does not prove `rtAt68DspFree`" limitation is
  stated in three places -- the case's own header comment, `runner.cla`'s case
  log, and `CLAUDE.md`'s count sentence -- plus the `docs/TODO.md` entry that
  schedules the real fix.
- *Discipline*: no runtime edits, no compiler edits, no catalog externs added, no
  settle raised, no test weakened, no subagents dispatched.

## Concerns

1. **FreeMem was exactly flat on the first try, both loops, both lanes.** That is
   the result the ruling wanted, but it means the case has never been observed to
   FAIL, so its failure detail strings are unexercised. Cheap to sanity-check in
   a future session by temporarily deleting one `tbAdspFreeIf` call; I did not
   burn a boot on it.
2. **The suite's settle headroom is down to ~100 s** (319 s of a 420 s budget,
   from 286 s before this case). Whatever case is added next will very likely be
   the one that has to raise `run_mac`'s settle in `toolbox_68k.sh`.
3. **`docs/TODO.md`'s existing AppleTalk bullet is now stale** -- "`mactest/
   adsp_68k.sh` SKIPs on every current boot disk" was true before Task 13a and is
   not any more. Left alone as out of scope for this task; flagging it for the
   controller's ledger pass.
