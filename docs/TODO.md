# Clarus TODO — technical debt and needed improvements, not yet scheduled

Condensed from completed phases' deferred/debt lists. The verbatim
context for every item is the originating phase's entry in
`docs/HISTORY.md` (named in the sub-heading or in parentheses) and that
phase's `.superpowers/sdd/<date>-<phase>/` ledger. Items here are
recorded, not committed — scheduling is `docs/ROADMAP.md`'s job. This is
a to-do list, not a history: a fixed item is deleted, not struck through.

Ideas, "if it ever bites" levers, and other maybe-someday items live in
`docs/FUTURE.md` instead (split 2026-09-05).

## Test coverage gaps (recorded by audits, mostly need real input/hardware)

### SE memory program, Wave 5 (2026-09-30)

- **Nothing pins Task 7a's stack reduction.** The recursive walkers'
  per-level stack fell 25–30× (umbrella §9.6), but a change that puts
  a big temp back into `parseStmt`/`cgStmt`/`lowExpr` would pass every
  test until an SE compile trips the depth guard. The controller's
  probe (a 150-arm `else if` chain plus 12 nested `if`s, 51 KB on the
  SE) is uncommitted scratch (`.superpowers/sdd/2026-09-30-se-wave5-close/
  realdepth.cla`, `zz_realdepth.sh`). Commit it as a Snow script, or
  add a host check on the walkers' `LINK` sizes from `emit68k
  --listing`.
- **No runtime-observable finalizer-order fixture for the table-driven
  `cg_free_globals`.** Host releases only free memory and `filehandle`
  has no finalizer, so the fixtures' `quit` paths cannot show release
  order. The committed `testdata/cg68k/freeglobals/*.order` dumps
  (compared against the old unrolled code's order) stand in.
- **`tests/cg68k/freeglobals.sh`'s 512 + 4N size bound needs vasm** and
  is skipped without it.
- **`tests/bake/stackguard.sh`'s `abort_codegen` subcase does not check
  that the abort lands in codegen**, only that it aborts cleanly and the
  next compile is byte-identical. Its guard-call bisection also adds
  ~11 s to T1.
- **`clarusc_deep.sh` lexes a 40 KB single-line source** (`DEPTH=20000`
  nested parentheses) before the guard can fire. After Task 7a the guard
  fires much deeper than before; if the lexer or parser runs out of
  heap on the SE first, the script fails without the diagnostic
  instead of proving the guard. It passed at the final tip.

### Opt-in log file (2026-09-29)

- **Native `app.trace(false)` is untested.** `nolog`'s `tracelog`
  subcase only turns trace on; nothing proves turning it off again stops
  trace lines reaching the log (the host `app.trace` is a no-op).
- **`PBSetFInfo` on a 64-byte PB.** `natPbSize = 64`, and every
  native `NatSetFInfo` (`natInit`'s `out`, `natAppWriteLog`,
  `natFileWriteText` and `natWriteRes` on `natFilePb`) passes such a block.
  IM's `SetFileInfo` also reads `ioFlCrDat` (offset 72) and `ioFlMdDat`
  (76), which lie past the end, so a newly created file may get its
  dates from neighbouring heap bytes. Grow the PB to 80 and set both
  dates (`GetDateTime`), or confirm against IM that the call ignores
  them.
- **Snow `macresident` is unverified** (Snow not run this detour): its
  TickProbe now opts in with `app.writeLog("out")` + `app.trace(true)`
  (ruling R3), and `build-68k.sh`/`build-clarusc-mac.sh --capture` go
  through the regenerated snapshot on the Snow scripts. Run
  `CLARUS_SNOW_TESTS=1 make test T=mactest/snow/` before relying on it.

- **cprint-lane `UiLaunchReal`** (real AppleEvent glue in
  `rt_ext_mac.inc`) has no test — every Retro68 build uses `--events`;
  needs a no-events Mac-lane smoke or real Finder launch.

- **Real modal halves** (`rtUiAskSaveChanges`'s `Alert(130)`,
  `rtUiAskOpen`/`rtUiAskSave`'s real SF halves) and **real
  mouse-tracking continuations** (`TrackControl`/`LClick`/
  `UiPopUpMenuSelect` branches) are `rtUiScripted`-gated and never
  exercised — need live input, the display's documented carve-out.

- **No automated abort-dispatcher-default test on either lane**; the
  C lane's UI dispatch loop has no abort-default check at all (parked —
  the opt-in cprint lane isn't where ClarusC.APPL builds).

- **`stringAt` return-arm/materialize consumption shapes** are
  read-verified, not hardware-exercised — add one assertion if touched
  again; the `textAt` core case never pins its freshness contract.

- **Dead runtime declaration**: the runtime's own `UiCurrentA5`
  (`runtime/clarus/uiscript.cla`) has no Clarus call site -- the `A5Live`
  suite case covers the codegen via its own local extern. Delete or wire
  up in a cleanup pass. (`UiNewMenuStr`, its former twin, was deleted by
  the language-runtime-cleanup phase, 2026-09-06.)

- **Suite bookkeeping minors**: the expected case counts are hand-written
  literals in the ported scripts too (`suite_report_check "$WORK/cap.out"
  83` in `tests/mactest/coresuite_68k.sh`, `38` in `toolbox_68k.sh`, each
  duplicated in that script's own doc comment), so adding a suite case
  still means editing two places per lane — the original
  `internal/mactest/coresuite_test.go` complaint, carried over by the
  go-retirement port rather than fixed. `caseIntMapGrowIter` lacks the
  masked-hash-collision partner pair a fuller test would pin.

- **Transient `emit68k` extern-record-decay crash** (2026-08-06,
  unconfirmed): one observed crash, 0/28 repro attempts. Repro ladder
  archived in `.superpowers/sdd/2026-08-06-toolbox-cookbook/
  repro-decay-crash/`. Recorded, not dismissed.

### extern-ptr-call phase (2026-08-27)

- **Retro68/cprint-lane (OnMac twins) restoration, remaining scope** — the
  `*/`-in-comment build break from `ae662a3` is FIXED (2026-08-28, with
  the drift it had been hiding: ten missing `FhH*` failure stubs from
  filesystem-api, `UiValidRect`/`UiNewMenuStr` wrappers from live-log);
  `TestCoreSuiteGUIOnMac` now compiles, links, boots, and runs 78/80.
  Remaining, deliberately unfixed pending a scope decision: (1) the two
  red cases (`FileHandleRW`, `DirOps`) fail BY DESIGN — binary-files gave
  this lane permanent-failure FhH stubs while also adding suite cases
  that need real file I/O, so the twin can only go green via real
  C-side HFS FhH implementations for this lane, lane-aware case skips,
  or accepting a documented 78/80. (The toolbox twin itself runs green,
  38/38 as of 2026-09-06.)

### Correctness-cleanup phase (2026-08-17)

- **`rt_ext_UiCompactMem` (Task 3's cprint-lane no-op stub for
  `CompactMem`) is unexercised** — no jiggle test targets the Retro68/
  cprint Mac lane (`TestToolboxSuiteJiggleOn68k` is native-68k-only); the
  stub compiles and links (the cprint toolbox twin runs 38/38) but no
  test ever drives it.

### Serial/connection phase (2026-08-16)

- **No committed emit-time fixture pinning the `lowUnsupported`
  rejection for local-receiver connection shapes** (Task 5) — the
  `appletalk` half of this entry was closed by the AppleTalk phase
  (2026-09-07), which lowers those shapes; the local-receiver shapes
  still reject the same way pre-phase, and nothing regresses that
  specifically today.

- **No coverage for the >8-connections build error** (Task 5; the cap
  was raised 4 → 8 by the AppleTalk phase) — the listener,
  serviceBrowser and service caps got fixtures in
  `tests/atalk/runerr.sh` (`too_many_lsn`/`too_many_brs`/
  `too_many_svc`); the connection cap did not.

### binary-files phase (2026-08-22)

- **No fixture asserts `readAt`/`writeAt` with `count == 0`** (Task 5
  minor; final-review wave M5) — the `pos == EOF` case IS covered
  (`readAt(600,10)` past EOF, `readAt(512,100)` crossing EOF); only a
  zero-length request is unpinned. `rtFhWriteRaw`'s `n == 0` early
  return means a zero-length `writeAt` never reaches the device
  (correct, undocumented); `readAt`'s zero-length behavior is likewise
  unexercised.

### filesystem-api phase (2026-08-26)

- **Folder rename untested on hardware** (Task 5) — `DirOps` only
  renames a file (`a.dat` → `c.dat`); `rtFhDevRename`'s use of
  `ci.ioFlParID` as the parent DirID for a FOLDER hit relies on the
  DirInfo/HFileInfo union sharing that field's meaning at offset 100
  (documented Inside Macintosh behavior, not independently re-derived
  by Task 1's probe the way `ioDirID`@48's file/folder difference was).

- **`file.list("")` untested** (Task 5) — `file.exists("")`/
  `file.info("")` are pinned (fix round 1, both lanes); `list("")` (the
  program's own folder) has no fixture on either lane.

- **`rtFhDevListFailed`'s true branch is unexercised natively** (Task
  4/5) — the host lane's `readdir()`-error path is pinned by a C
  harness test (fix round 1); the native lane's `PBGetCatInfoSync`
  hard-failure path (as opposed to the ordinary `fnfErr` end-of-listing
  case) has no fixture on real hardware.

- **System 7 (Snow) is entirely unverified for this phase** — Task 1's
  probe wave, Task 5's native `fileh_68k.cla` lane, and the
  `mactest/snow/clarusc_bake` gate (owed after any runtime-module addition,
  deferred per the ledger's Task 7 ruling) all ran on Mini vMac/System 6
  only; a live 68kbbs session owned the one Snow instance throughout
  this phase. Every `PBH*`/`_HFSDispatch` trap predates System 7, so no
  difference is expected, but none of this phase's own hardware claims
  are System-7-backed.

- **The full-path spike (Task 1 (b)) was verified only on the boot
  volume** — `PBGetVolSync` + `vol + ":path"` opened successfully
  against `"SysAndApp"` (the probe's own boot volume); a second,
  non-boot mounted volume was never exercised.

- **A core-suite jiggle twin** (crash-report.md §9, the `rtUiTeWidestLine`
  find) — `TestToolboxSuiteJiggleOn68k` is the ONLY heap-jiggle boot in
  the tree, and it is T2-only; a `TestCoreSuiteGUIJiggleOn68k` twin (or
  a jiggle variant of one frozen UI scenario) would widen the net for
  the next stale-master-pointer-across-compaction bug at the cost of
  one more T2 boot. Every UI program shares the same runtime the
  toolbox suite's jiggle boot exercises, so the gap is real, not
  hypothetical.

### native-array-return-and-fileh-guards phase (2026-09-06)

- **The read-only-directory close-errno check is a silent no-op under
  root and does not check `mkdir`** (`runtime/host/rt_fileh_test.c`,
  `test_openrf`'s forced-AppleDouble block, added by the phase's
  deferred-minors wave): the `EACCES` assertion is skipped when
  `geteuid() == 0` (root bypasses directory modes) without printing a
  SKIP, and `mkdir("rf_ro_dir", 0755)`'s return is unchecked, so a stale
  0555 `rf_ro_dir` left by a killed run surfaces as a confusing
  `close errno: openRF` failure rather than naming the directory. Two
  lines each.

- **`ArrReturn`'s independence-failure message is a 167-character source
  line** (`testsuite/core/cases_arr.cla`, the `assigned copy not
  independent` `tkFail`) in a file wrapped at ~72 columns — the same wave
  wrapped a 190-character comment for the same reason. Cosmetic; split
  the concatenation across two lines.

### AppleTalk phase (2026-09-07)

- **The listener teardown path has no runtime test.** The final fix
  wave's I3 made `rtAtalkPump`'s listener arm call `rtLsnStop(i + 1)`
  after `rtLsnSetFailed` when `rtLsnDevPoll` returns negative, so a
  listener that loses its `dspCLListen` is torn down (NBP name removed,
  device slot released, state back to `rtAtIdle`) instead of staying
  `rtAtActive` and permanently deaf. Nothing exercises it: the failure
  needs a real `.DSP` that then fails, and no test drives one into
  failing. The change is pinned only by goldens (four
  `testdata/emitui/atalk_*.c.golden`, ten `testdata/cg68k/atalk_*.s`) --
  shape, not behaviour. The cheap check is now buildable -- Task 13a's
  LaunchAPPL `AppleTalk`-file patch means `mactest/adsp_68k.sh` runs
  both boots against a real `.DSP` -- and is a subcase that kills the
  server mid-run and asserts the client's next `find` no longer sees the
  name.

- **`atalk_lock`'s stale-holder steal path is still racy between two
  waiters** (`tests/lib_atalk.sh`). The fix wave closed the UNLOCK half
  -- `atalk_unlock` now refuses to `rm -rf` a lock directory whose
  `pid` file is not `$$`, so a waiter that stole a dead holder's lock and
  then exited can no longer delete a second waiter's live lock. The STEAL
  half is unguarded: two waiters can both pass the same dead holder's
  `kill -0` check, and then waiter A `rm -rf`s the dead directory and
  `mkdir`s its own (A now holds the lock) -- while waiter B, already past
  its check, `rm -rf`s A's FRESH directory and `mkdir`s its own. Both
  believe they hold the lock.
  Pre-existing shape, never observed, and it only costs determinism on a
  test group (two LToUDP stacks racing for node ids, which is exactly what
  the lock exists to prevent). Real fix: make the steal an atomic
  `mv`-into-place of a uniquely named directory, or drop the mkdir mutex
  for `flock` on a lock FILE where the platform has it.

## Compiler: type checking

### ui-widgets phase (2026-10-25)

- **A user function named like a builtin is silently replaced by the
  builtin.** `lowCall` (`lower.cla`) maps `durationStr`, `dateTimeStr`
  and `now` to the runtime's own functions before it looks at user
  symbols, so a program's own `func durationStr(...)` is never called
  (found by ui-widgets Task 3: `testdata/emitui/ui_batch_decl.cla`'s
  formatter calls `rtDurationStr`). Pre-existing. Fix: resolve user
  symbols first, or make redeclaring a builtin a check error.

### SE memory program, Wave 3 (2026-09-29)

- **Boundary `int16`/`uint8` read back as `int`** (Task 6, ruling R10).
  At an extern/callback signature or an `extern record` field, `int16`
  and `uint8` build the `TxWord`/`TxByte` nodes (`parse.cla`'s
  `parseExternType`/`parseXRecFieldType`), so an extern result, a
  callback parameter or a field read is typed `int`:
  `var part: int16; part = FindWindow(pt, wp)` (FindWindow returns an
  INTEGER) needs `int16(...)`. Resolve them to the narrow types instead while keeping
  the KWord/`XFByte` lowering. That also needs D5-style `int` acceptance
  at a callback's own `return`, so a body like `return w + n` (int
  arithmetic, int16 return) keeps compiling.
- **The extern RETURN diagnostic omits `int16`** (Task 13 review).
  `check.cla`'s "external functions may only use int, ptr, bool, or
  char" is wrong since Wave 3: `int16` is a legal extern return too.
  The parameter diagnostic got the same one-word fix in Task 13; this
  one was left so the final snapshot would not go stale. Add `int16`
  and move whichever `.expect`/`check_test.out` lines carry it.

### SE memory program, Wave 0 (2026-09-28)

- **`= inline nop` with a `string` parameter passes the checker but
  aborts cg68k.** A call such as `external func MemProbe(phase: string)
  = inline nop` checks clean. On the 68k lane (`cg68k/selfemit`,
  `bake/identity`), it then dies with `cg68k: cgExpr: EVarRef
  non-scalar (str/rec/arr) reached in value context -- bind/store it
  instead of reading its value directly` (`cg68k.cla` ~l.10303),
  because the nop expansion still evaluates its arguments in value
  context. Wave 0 worked around it: `main.cla`'s `MemProbe` is a
  clause-less extern with a no-op `nat_MemProbe`. There are two fixes:
  - have the `inline nop` call site skip argument evaluation, since
    there is nothing to pass;
  - or have the checker reject non-scalar parameters on `inline nop`.

  The reference (~l.1965) shows only a no-parameter example.

### MacTCP phase (2026-09-08)

- **The `--rtbake --testapi` symbol preload does not carry the
  identical-repeat extern accommodation.** From source, a second
  `external func` sharing a name with one an earlier decl in the SAME
  `checkProgram` call already registered is legal iff its clause is
  identical (`check.cla`'s `externFirstDeclByName`/`externMergeCandidate`,
  `checkFuncSig`'s `DkExternFunc` arm). `bkInstallCheckerSymbolsForTestapi`
  installs baked `funcSigs`/`symbols`/`scopes` but not that table -- it is
  keyed by DECL INDEX, and the bake carries no decl arena -- so a user
  file redeclaring an early-visible baked extern gets a plain
  "redeclaration of X" under `--rtbake` while checking clean from source.
  Found by this phase's debt-3 widening: `toolbox/memory.cla` rode into
  the early-visible set with `atalk_68k.cla`, and
  `testsuite/core/cases_ptrcall.cla`'s own `NewPtr`/`DisposePtr` copies
  then failed `bake/full_corpus_suite_core`. Worked around there by
  `include`ing `toolbox/memory.cla` instead (the mechanism
  `tests/bake/testapi_include_parity.sh` already proves has full
  path-dedup parity), which is the right shape for a suite case anyway --
  but the underlying parity gap is still there for the next user file
  that repeats a baked extern.
  Real fix needs a decl-free merge key: bake the early-visible extern
  NAMES (a `bkSec*` section, `bkSecFieldInfo`'s own precedent) and seed
  `externFirstDeclByName` with a sentinel meaning "declared by the bake",
  guarding `checkExternFunc`'s clause comparison for it. Note the
  tradeoff that needs deciding first: with no baked decl there is nothing
  to compare the trap word/conv against, so a sentinel merge would accept
  a user extern that reuses a baked name with a DIFFERENT trap. Either
  bake enough of the clause to compare, or accept the loosening
  deliberately.

### AppleTalk phase (2026-09-07)

- **Text out-parameters accept a `string`, and nothing but `cc` catches
  it.** Every `text` out-parameter in the language -- `file.readText(path,
  t)`, `fh.readAt(pos, n, t)`, `svc.call(target, op, req, reply)` -- is
  registered in `clarusc/check.cla` as an ordinary `psPlain(TextT)`
  parameter, and a `string` argument is admitted there by the ordinary
  string->text call-argument coercion. Lowering then passes an
  out-parameter through UNCOERCED (deliberately -- the callee must write
  into the caller's own storage), so a `string` argument arrives at a
  `rt_text *` parameter as a `clar_str_255 *`. For `readText`/`readAt`
  the callee is an intrinsic whose prototype takes `rt_text` by value, so
  `cc` errors and the user is stopped; for `svc.call` the callee is a
  lowered Clarus function, so `cc` only WARNS and the program ships with
  a wild write into the string's storage. The AppleTalk phase's fix wave
  put a one-off `typeKind(...) != TyText` guard on `svc.call`'s fourth
  argument (`testdata/errors/svc_call_reply.{cla,expect}`) because that
  was the site with the silent failure mode; the general fix is real
  out-parameter typing in the checker -- a parameter-shape flag that
  suppresses the coercion and rejects any argument whose kind is not the
  declared one -- applied to the whole family at once, so the next
  `text` out-parameter added does not have to remember the guard.

## Language: feature-support queries (after the AppleTalk release)

- **A `system.has*()` family for optional platform features** (Andrew,
  2026-09-07, during the AppleTalk brainstorm). A program running on
  System 6 without the `.DSP` driver should be able to learn that and
  disable its ADSP features itself, rather than discovering it through
  a `failed` event. Shape: `system.hasADSP(): bool` first, then
  whatever other optional things need a check later (`.XPP`/zone
  calls, MacTCP, Gestalt-gated System 7 features). Mostly syntactic
  sugar over the corresponding Toolbox calls (`OpenDriver` probes,
  Gestalt selectors), but abstracting them lets the host lane answer
  the same questions (`hasADSP()` is `false` on the host until host
  ADSP lands, see `docs/FUTURE.md`). Scheduled AFTER the initial
  AppleTalk implementation ships, not inside it.

## Runtime / Toolbox robustness

### ui-widgets phase (2026-10-25)

- **Popup menu IDs collide across windows.** A popup's menu ID is
  `rtUiPopupMenuIdBase + widgetIdx` (`uiwidgets.cla` `rtUiMakeWidgets`),
  so popup 0 of one window and popup 0 of another open window get the
  same ID, and the Menu Manager's menu list holds two menus with one
  ID. Found in recon (spec §6); out of the phase's scope. Fix: number
  popups program-wide (window index × widgets + widget index), or
  allocate IDs from a free range at open.
- **`rtUiMenuRecomputeDim` overwrites a program-set `.enabled`.** On
  every front-window change it re-enables or dims each window-scoped
  item (and std-edit items 3–7) from the front window alone, so an
  `Item.enabled = false` the program set on such an item is lost at
  the next window switch. It never touches `checked`. Fix: keep a
  per-item "program disabled" bit and AND it into the computed state.
- **The host C lane's `file.load` bypasses the observed-list hook.**
  `runtime/host/rt_ser.inc` fills a list through `rt_list_*` calls
  that do not go through `list.cla`'s `rtListObsNote`, so a table bound
  to that list would not redraw. Harmless today (no host UI lane, spec
  C1); it matters if one is ever built.
- **`setBounds` writes no UI-trace line.** Scripted builds trace every
  other widget property write; a frozen scenario that moves widgets
  would not show it in its trace. No scenario calls it today.
- **No Window Manager catalog file in `toolbox/`.**
  `testsuite/toolbox/cases_setbounds.cla` declares `FrontWindow`
  (0xA924) locally for want of one. Add `toolbox/windows.cla` with the
  rest of the Window Manager, per the Toolbox-first principle.

### Opt-in log file (2026-09-29)

- **`natWlVRef` is a working-directory refnum.** `app.writeLog` records
  `PBGetVol`'s ioVRefNum, which under HFS is a WD refnum. If the app
  (or a Standard File call) closes that WD with `PBCloseWD`, later
  flushes fail with lastError. A `PBGetWDInfo` → real vRefNum + dirID
  pair (`PBHOpen`) would survive it.
- **`natWlPb`'s `ioFVersNum` is not zeroed before `Create`.** The PB is
  reused (`natAppWriteLog` re-zeroes only the FInfo region), so
  whatever byte 26 holds from an earlier call is passed to `Create`.
  HFS ignores it; MFS would not. Zero it to be safe.

### SE memory program, Wave 3 (2026-09-29)

- **`runtime/host/rt_ser.inc` is dead weight** (Task 7, ruling R2).
  `drive.cla` sets `cpSerPorted = true` unconditionally, so every host
  build routes `file.save`/`file.load` through `ser.cla`; only
  `rt_ser_test.c` (`tests/hostrt/ser_leak.sh`) still reaches
  `rt_file_save`/`rt_file_load`. It still writes v1 with 4-byte enums,
  and its switches have no `default:`, so codes 6–8 (`U8`/`I16`/`U16`)
  would be skipped silently. Delete it with its test, or add
  `default: rt_panic(...)` to its switches.
- **A fresh `irTypes` entry per narrow-typed expression** (ruling R4).
  `lowTypeAt` (`clarusc/lower.cla`) calls `irNarrowIntType` for every
  uint8/int16/uint16-typed node it lowers -- including, since the final
  review's fix, every int literal the checker typed narrow -- and
  `irNarrowIntType` (`clarusc/ir.cla`) appends a new `KInt` entry each
  time, like `irStrType`. Harmless for today's runtime and compiler
  (neither is narrow-heavy), but a user program full of narrow locals,
  fields and literals grows `irTypes` per use, not per type. Fix: a
  lazily-created per-compile cache of the three narrow entries (tags 8,
  -16, 16), created on first use rather than at init so no existing
  program's `irTypes` indices move. Check the bake path first: a baked
  runtime restores `irTypes` wholesale (`bkLdIrTypes`, `clarusc/bake.cla`),
  so the cache must be reset (or re-derived) after that restore, never
  carried across it pointing at a stale index.
- **`NarrowForm` covers only `uint16`** (`testsuite/toolbox`). The
  toolbox suite's form case exercises one narrow field kind; nothing
  drives a form mixing `uint8`, an `int16` with a negative prefill and
  an enum popup, and no case has a narrow `table` column. The modal
  form/table field-type codes 6-8 are only covered for `uint16` on
  hardware.
- **Native coverage gaps for narrow/enum containers.** The core suite
  (both lanes) now covers narrow fields in a `list of record` and a
  `map of record` (and LIST/MAP save/load of them) via `EnumStorage`,
  but nothing yet runs natively for: a `sortedmap` of a narrow type;
  `for x in` over a `list of int16` (sign extension on the loop
  variable); `for k, v in` over an enum-valued `sortedmap`/`intmap`;
  and `pop()`/`first()`/`last()` on a `list of <enum>` (the 2-byte
  out-temp path). Each is a few lines in an existing core case.

### MacTCP phase (2026-09-08)

- **`tcp.cla`'s `rtTcpPending: text[8]` global makes EVERY native
  program pay for TCP at boot.** `runtime/clarus/tcp.cla` is in the 68k
  superset (spliced into every native build, like `atalk.cla`), and its
  per-slot pending-receive buffer is a fixed array of eight `text`
  handles, so a program that never opens a connection still allocates
  eight handles at startup and carries +438 B of A5 globals -- measured
  on the splice commit, which moved all 60 `testdata/cg68k/*.s` goldens
  (`arith.s`: A5 frame 6910 -> 7348, plus eight new `rtTextNew` calls in
  the boot sequence). Two levers, either one enough: usage-gate
  `tcp.cla` off the 68k superset the way the host lane already gates it
  (`conn.cla`/`atalk.cla` would have to stop naming `rtTcp*`
  unconditionally first), or keep ONE scratch `text` and give each slot
  an offset into it. Not urgent -- 438 B of a 2 MB partition -- but it
  is a cost every program pays for a feature most do not use.

- **`rtTcpListenMsg` hardcodes errno 48 as "port in use"**
  (`runtime/clarus/tcp.cla`). 48 is `EADDRINUSE` on BSD/macOS; Linux is
  98, so a Linux host would report the generic "could not start
  listener" for a port already in use -- and `tests/tcp/lfailed.sh`,
  which asserts the specific wording, would fail there. The host waist
  hands up a raw errno; the fix is to map it symbolically in
  `runtime/host/rt_tcp.inc`, where `EADDRINUSE` is in scope, rather
  than matching a number in Clarus.

- **The cprint-lane script engine has no `delay` verb and ignores
  unknown verbs silently** (`runtime/mac/rt_ui.c`,
  `rt_ui_run_scripted`'s `strcmp(verb, ...)` chain, which has no final
  `else`). The uiscript `delay N` verb this phase added (real-tick
  waits in `--events` scripts) exists only in the native lane's engine,
  so a `build-mac.sh --events` script using `delay` would not wait and
  would say nothing about it. Only matters if a Retro68-lane build ever
  drives a `delay` script -- nothing does today, and the lane is slated
  for deletion in 5f -- but the silent fall-through is the half worth
  fixing if the lane survives.

- **The 68k stack heuristic prices every frame WITHOUT its temp pools.**
  `clarusc/cg68k.cla`'s `cgStackHeuristic` sums `cgFuncFrameSizes` along
  the deepest call chain, but the value in that list is recorded on the
  MEASURE pass, where both temp pools are laid out EMPTY by construction
  (`cgFuncSmallTmpNeed`/`cgFuncBigTmpNeed` are still 0), so the native
  stack reserve under-counts by the sum of the string/record temp pools
  along that chain. Pre-existing since the pools
  became per-function (binary-files / compiler-cleanup phases); surfaced
  by this phase's Task 9, which had to guard the real-pass write with
  `if cgRecMode == 1` to fix a `--rtbake` identity failure (the baked
  path carried the FINAL frame, the from-source path the measure one --
  one differing byte in the startup `ADDA`) and left a `ponytail:`
  comment at the site saying the under-reserve is a separate, real bug.
  Not folded into a TCP task because fixing it changes every native
  program's stack reserve and so moves every `testdata/cg68k` golden --
  do it in a phase that is already reblessing the corpus.
  **SE wave 5 addendum:** the measure pass lays the big pool out at
  `cgBigTmpFloor` (4 × 512 B), not empty, and since Task 7a the real
  pass drops that floor. So the heuristic now OVER-counts about 2 KB
  per frame on the priced chain for most functions: a native program
  without `stack:` keeps its old default reserve, and 7a's ~2 KB per
  frame saving never reaches its heap. Safe (it over-reserves), but
  pricing the real-pass frame needs the same `--rtbake` agreement
  described above.

### native-array-return-and-fileh-guards phase (2026-09-06)

- **A resource fork that SHRINKS between `fstat` and the copy still
  yields a truncated AppleDouble sidecar reported as success**
  (`runtime/host/rt_fileh.inc`, `rt_fh_sidecar_store`): the resource-fork
  entry length is written into the header from `st.st_size` BEFORE the
  copy loop, and the loop's `got == 0` break (end of file) exits early if
  the fork got shorter in between, so the header's length exceeds the
  data that follows it. The phase's `pread` follow-up made a read ERROR
  fail (errno preserved); this is the remaining short-copy path. Only
  reachable if another writer truncates the same open fork mid-store —
  host lane, AppleDouble path only (non-Apple host or
  `CLARUS_FORCE_APPLEDOUBLE=1`). Fix candidates: re-`fstat` after the
  loop and fail on a mismatch, or copy first and write the header last
  with the byte count actually copied.

## Native code size

### SE memory program, Wave 5 (2026-09-30)

- **The table-driven `cg_free_globals` tests kind 0 with `CMPI.W
  #0,D1`** where `TST.W D1` is 2 bytes shorter, in every segment of
  every native program. Moves every `testdata/cg68k` golden.
- **Two helpers Task 7a split out keep big frames:** `lowUnary` (568 B)
  stays on a nested-unary recursion such as `-(-(-x))` (evaluating its
  operand first would reorder `intern` against IR allocation), and
  `expectKind` (564 B) returns before any recursion. Neither is on a
  common deep path.

### Opt-in log file (2026-09-29)

- **The log writer is in every native program.** `cg68AddRoots` roots
  every `nat*` function, so `natAppWriteLog`/`natAppFlushLog`/
  `natAppTrace`/`natAbortLog`/`natWl*` (a few hundred bytes) ship in
  every native build whether it calls `app.writeLog` or not; four
  `testdata/cg68k` fixtures gained a segment. An SE size lever: rename
  the intrinsic-only entries off the `nat*` prefix and root them only
  when the program uses `app.writeLog`/`flushLog`/`trace`.

### SE memory program, Wave 3 (2026-09-29)

- **Every native program carries the whole UI table/form draw path.**
  `ui.cla`/`uidialogs.cla`/`uitable.cla` (`rtUiTableDrawField` and the
  LDEF path) are spliced into every native build, so even a non-UI
  program pays for them: Task 4's narrow-field range check alone added
  +224 B to every native program and +776 B to `bookmarks`, and Task 9's
  2-byte enum column read moved even `arith.s`/`traps.s`/`xrec.s`. A
  usage gate (only programs with a table or form get the path) is an SE
  size lever. Moves every `testdata/cg68k` golden.
- **No size-2 peephole shapes** (Task 9). `peep68k.cla` matches only
  size-1 and size-4 load/store pairs, so a 2-byte enum (or `int16`/
  `uint16`) local loses the store/reload peephole a 4-byte one gets,
  and every 2-byte enum load is `CLR.L D0; MOVE.W src,D0` (4 bytes)
  where the 4-byte enum was one 2-byte `MOVE.L` (visible in
  `testdata/cg68k/enums.s`). This touches ClarusC.APPL's own code too.
  Adding the word shapes to the peephole moves the goldens of every
  program with enum locals.

## Compiler-on-Mac (`ClarusC.APPL`) — on hold

The Mac-resident compiler target is on hold (Andrew, 2026-09-05). Nothing
here matters until it resumes: compile-time performance and memory of
clarusc running ON a 68k Mac, the baked runtime IR/object-code (`CLIR`)
machinery that exists to make that fast, and the Snow boots that prove
it. Recorded so the work is not lost, not scheduled.

### SE memory program, Wave 0 (2026-09-28)

The SE memory program (2026-09-27) resumed work on this target. See
`docs/ROADMAP.md`.

### SE memory program, Wave 5 (2026-09-30)

The wave spec's "smaller frames on the recursive walkers" item was
resolved in the wave (Task 7a), not deferred, so it has no entry here.
Neither does the record-walk follow-up: Task 2 measured the duplicated
record walks at 21 KB across ClarusC and left them (the RESOLVED entry
under "ABI / performance" below).

- **ClarusC's stack reserve is now generous.** It is 384 KB
  (`stack: 393216` in `clarusc/macgui.cla`); after Task 7a the
  `bookmarks.cla` high-water is 49 KB on the SE and 163 KB on the IIcx.
  The spec's V3 rule (2× the largest measured high-water) would give
  326 KB. Re-apply the rule at the next ClarusC-affecting close, and
  give the freed heap to the SE. Why the IIcx uses over 3× the SE's
  stack for the same compile is not measured.
- **Stream the output fork.** `app68BuildFork`/`app68WrapFork`
  (`app68k.cla`) still assemble the whole output fork in the heap
  before it is written (Wave 4 pre-sized it and releases each segment
  as it is copied). Writing each CODE segment as it is finished would
  keep the image out of the heap. Parked by the wave spec (V2).
- **The Wave 4 leftovers are still open:** the `strIndex` rewrite, the
  `a68Items` 68-byte record and `reserve`'s power-of-two slack (the
  Wave 4 entries below). Wave 5 did not need them; its low point on
  the SE is 1130 KB free.

### SE memory program, Wave 4 (2026-09-29)

- **`strIndex` is the largest entry at the rtbake peak** (164 KB: a
  `map of int` whose keypool duplicates `strBlob`). An open-addressed
  index over `strBlob`/`strOff` saves ~130 KB but rewrites `intern`,
  the hot path of every compile, and bake's pool install. A lever
  with `a68Items`' 68-byte record (139 KB at the peak); Wave 5 left
  both open.
- **The Toolbox calls ClarusC's discovery uses are not in the
  catalog** (ruling R11): `PBGetVolSync`, `PBGetFCBInfoSync`,
  `PBHGetVolSync`, `PBHSetVolSync` and the `FCBPBRec`/`WDPBRec` records
  are declared locally in `macgui.cla`. Moving them into
  `toolbox/files.cla` adds prototypes to every UI program's emitted C
  and moves the emitui goldens; do it in a phase that blesses.
- **A read-only `filehandle`'s `flush()` succeeds** (ruling R3). To
  make it fail: `fcntl(F_GETFL)` in the host `FhHFlush`, the FCB
  write-permission bit on the 68k.
- **The self-compile segment budget is tight.** `cgPackProgram`'s
  segment carries the per-segment `cg_free_globals` glue, and every
  handle-typed clarusc global adds a release there. At Task 6, 2 more
  such globals fit and a third failed `function cgPackProgram exceeds
  the 32KB segment limit`; Task 8 removed 2 net, so about 4 fit now.
  Fix: split `cgPackProgram` or trim globals. (SE wave 5: the glue is
  table-driven now -- 4 bytes a global instead of ~18, and ~8.5 KB
  smaller per segment -- so the pressure is largely gone; re-measure
  before acting on this.)
- **The library-load fallback reruns the whole compile from source**
  (`driveCompileFork`) -- slow on the Mac, but only on a corrupt
  library. It logs only `diags[0]` before falling back.
- **ClarusC restores the caller's default as (volume, dirID)**, not
  the WD refnum it had; a later `PBGetVol`-only caller would see just
  the volume. Nothing in ClarusC does that today. An exact WD restore
  is optional.
- **The scripted `askOpen` default move is an imitation** (ruling
  R13): `gcScriptedSetDefault` sets the default from the answer's
  folder prefix, as `SFGetFile` does; a real launch with a real dialog
  remains the final proof of the different-folder discovery.
- **Object-code corruption is caught at the lazy read, not at load**:
  a compile only validates the records it reads, so a corrupt record
  of an unreached function is never noticed. The compile still fails
  cleanly (or falls back on ClarusC).
- **A short ShakeSummary is not cross-checked at load**: the section is
  validated structurally (`bkShakeSummaryValid`), but a summary with
  fewer function entries than `bkRuntimeFuncBoundary` is not compared
  with `bkLdIrFuncs.count`, so a corrupt library could under-mark
  reachability (the bodyless-library guard `cgObjLibMissing` then
  likely catches the missing record). `main.cla` ~l.384's
  `--corrupt-objcode-testonly` comment still talks about the v4 body
  hash.
- **DeclFileTab is written but never read** (its path set comes from
  `bkSecManifestHashes`' keys): a dead section in every library.
- **Smaller Wave 4 minors** (from the task reviews):
  `cg68k.cla` ~l.1281 overlong doc-comment line; `driveFreeFrontEnd`'s
  comment should say its `toks`/`lexSrc` release is now a safety net;
  `rtFhDevOpenRead` is a deliberate near-copy of `rtFhDevOpen` (golden-
  preserving) and needs a comment saying why; the `OpenRead` case
  leaves `core_openread.dat` in the cwd (as `cases_fileh` does);
  `shake.cla` ~l.592 has a redundant `fIdx < shakeSumFuncs` guard;
  `--shake-dump` reflects only the last `shakeProgram` run (say so in
  a comment); `asm68k`'s `trapNameIdx` field comment should mention the
  synth-call tag; Task 1's +1024 B on both `_src` memgate subcases is
  unexplained; `tests/bake/untaint.sh` should `grep -m1`; the header
  read log counts `bkHeaderMax` (4096) bytes, not the bytes used;
  `app68Build` (`app68k.cla` ~l.660) is unused and lacks
  `app68BuildFork`'s note (delete it); `cgFuncPoolAt` rescans
  its range per call (quadratic at bake time, small n).
- **The fixed-headroom reserves may fight `reserve`'s rounding**:
  `drive.cla` ~l.2680 (`irTypes.shrink()` then `reserve(count + 64)`)
  and `cg68k.cla` ~l.2004 (`cgSizeOf`'s `cgSizeMemo.reserve(irTypes.count
  + 64)`) aim for small fixed headroom instead of doubling slack, but if
  list `reserve(n)` rounds up to a power of two they save less than
  their comments claim (or nothing). Verify against the rtbake census
  at the peak, then keep, drop or reword them (Wave 5 left this open).

### Opt-in log file (2026-09-29)

- **`drive.cla` `dirOf` splits only on `/`.** An HFS path such as
  `Clarus:bookmarks.cla` gives `dirOf(...) == ""`, so the volume is
  lost. `cgAppIconPath` (`drive.cla` ~l.1580) then resolves the `icon:`
  file relative to the default directory, and ClarusC always logs
  `warning: cannot read app icon bookmarks.pbm: could not open file;
  using default icon`, even with the `.pbm` next to the source. The
  Mac-built app gets the default icon. `tests/mactest/snow/
  clarusc_memprobe.sh` filters out that exact line. The other callers
  (`drive.cla` ~l.399 and ~l.1071, include resolution) probably have
  the same blind spot for relative includes next to an HFS-path entry,
  but that is unverified. Fix: split on `:` as well when the path
  contains one, and join with `:` to match.
- **On-target compile ticks are not reliable under Snow fast-forward.**
  Two IIcx runs of the same ClarusC binary compiling the same
  `bookmarks.cla` took 81753 and 89619 ticks. Single phases varied by
  up to 7× (`Built fork` 6027 vs 815, `Measured` 39768 vs 50247), while
  the mem/stack figures agreed to within ~45 KB. The program design's §7
  assumed emulated ticks survive fast-forward, and they do not. Compare
  ticks only within one run. For a real timing number, force real time
  (`snow_realtime`) or count instructions instead.
- **ClarusC's `out` log is near its cap after one compile.** The log
  is `natLogCap` (4096 B) and silently truncates. The SE-wave-0 probes
  add ~500 B per compile, so ONE `bookmarks.cla` compile now fills ~3
  KB. The two-compile Snow sessions (`macresident.sh`,
  `macresident_failed_compile.sh`) may therefore lose the second
  compile's tail and hide an error marker there; their assertions cannot
  turn red from it. Fix: raise `natLogCap` or grow the log onto a
  handle. That changes output and moves every native golden (`natInit`'s
  `MOVE.L #4096,D0`).

### SE memory program, Wave 2 (2026-09-28)

- **The host gate and the IIcx differ by ~2.7 MB at the low point, and
  the gap is not re-attributed.** Host peak 3,668,312 bytes (3582 KB)
  against 6272 KB used on the IIcx (program design §9.3). Wave 0's
  calibration terms (the never-released 1879 KB CLIR resource, ~1 MB
  of CODE loaded after launch) would cover it, but neither was
  re-measured, and the host still counts host box/element sizes. Also
  unattributed: +141 KB used at `pre-compile` on the IIcx against Wave 1,
  of which only `MoreMasters`' ~40 KB is explained (~100 KB open), and compile ticks halving in phases Wave 2 did
  not target. Settle these before Wave 4 sizes its target. Wave 3
  (program design §9.4): still ~2.7 MB (host 3,399,176 bytes = 3320 KB,
  IIcx 6111 KB used); the host also credits ~75 KB of arena saving the
  68k layout does not see, and Wave 3's +63 KB launch free and the
  +2397 ticks in `Built fork` are unattributed. Wave 4 (§9.5): ~1.3 MB
  (host 1,194,744 bytes = 1167 KB, IIcx 2443 KB used); the CLIR
  resource term is gone, the ~1 MB CODE term was not re-measured, and
  Wave 4's +848 KB at `Parsed`, 86% tick drop, stack 187 → 194 KB and
  737 → 752 KB reserve, and 27 s "Verifying → Starting" span are
  unattributed.
- **`MoreMasters`' 64 per call is unproven on the target.** `macgui.cla`
  calls it 153 times assuming the zone's `moreMast` is 64; a memprobe
  line peeking the zone header would confirm it. The comment's
  "8-byte block header" is 8–12 B under 32-bit addressing.
- **`rtListReserve` computes `n * elemsize` unchecked**, like
  `rtListGrow`; a huge `n` can overflow before the resize.
- **A crafted bake with a valid hash can make `bkFitCount` reserve tens
  of MB.** It caps a count at remaining bytes / 4, but most elements
  are far larger than 4 bytes on the wire, so a per-reader minimum
  wire size would bound it properly. (Since CLIR v9 there is no body
  hash; the section directory bounds each reader to its section's
  length, which caps the damage at that length / 4 elements.)
- **`text.reserve(n)` rounds up to a power of two** (through
  `rtTextGrow`) while `list.reserve(n)` is exact. Task 8 had to
  `shrink()` its blob after reserving; the reference should say which,
  or the two should agree (changing `text.reserve` moves goldens).
  The concrete cost now: `app68k.cla` ~l.89 reserves the output fork
  (Wave 4 Task 8) and gets up to 2× before the `shrink()` -- slack at
  the peak, and a hole mid-heap on the SE.
- **`bkReadStrPool`'s blob is not pre-sized.** It reserves the offsets
  list but grows the blob by doubling -- the kind of transient Wave 2
  removed elsewhere. `expectedPos - bkLoadPos` (the section length) is
  an upper bound to reserve up front. Perf only.
- **Task 3's encode-drift guard `abort()`s** instead of a clean
  diagnostic and `false`: it is an internal invariant, but on the Mac it
  kills ClarusC. `a68SelfExercise` also has no direct flush /
  forward-reference fixup case (the goldens and bake twins cover it
  indirectly).
- **Smaller Wave 2 gaps:** `cgObjRunAdd` copies each run twice at
  capture; `memcensus.sh`
  writes its duplicate-box table before its `n < 4096` guard (353
  globals today), names only the last alias in `also=`, shares
  `$BR/memcensus` with manual runs, and gives no message for a missing
  FILE argument.

### SE memory program, Wave 1 (2026-09-28)

- **A failed bake-path compile leaves the parse staging alive while
  ClarusC idles.** A compile that fails user check returns before
  `bkInstallArenas`, so the `bkLd*`/`bkLoaded*` staging (a few MB)
  stays until the next compile's `bkLoadRtbake` frees it first thing
  (`bkFreeParseStaging` at its top, Task 5). Nothing accumulates. Fix:
  one `bkFreeParseStaging()` in `gcCompile` after a failed
  `driveCompile`, or on `driveCompile`'s failure returns.
- **`driveRtbakeFallback` restores `haveRtbake = true` over consumed
  bytes (Wave 2 left it as is: remove or rethink).** After a drift fallback the
  outer compile sets `haveRtbake = true` again, but its own bake parse
  already released `rtbakeBytes`, leaving (`haveRtbake = true`, bytes
  empty). It is harmless today only because every front end re-arms
  both per compile (`gcResolveBakePath`, `dblcompile_bake.cla`;
  `main.cla` compiles once). A future front end that calls
  `driveCompile` twice without re-arming `rtbakeBytes` gets a
  bad-header diagnostic instead of a from-source compile. Drop the
  assignment (leave it false) or have the fallback own re-arming.
  Since Wave 4 the front end's `rtbakeFh` stays open across the
  fallback (`driveDropLibrary` drops only the loader's reference), so
  the restored flag may now point at a usable handle: re-check, and
  delete this entry if so.
- **`irStorageRow` caches misses until `irReset`.** Since Task 5,
  `irStorAdd` probes `strIndex.get(intr, -1)` instead of interning, so
  an intrinsic name not yet in the pool gets row value −1 and stays
  that way in the table. That is sound only because the table is built
  after lowering and `irReset` empties it before every `lowerProgram`.
  A caller that runs two lowerings back to back and consults the table
  between them without an `irReset` (the `bakeGenerateChain` shape)
  would see stale misses. The precondition is documented in `ir.cla`;
  nothing enforces it.
- **`cg68Measure` does not reset items in `cgEmitEnumTables`/
  `cgEmitSerdescTables`.** They have their own per-entry measure
  `before`s, but Task 3 reset only `cgEmitPoolsBody`'s. The tables are
  small, so the saving is too.

### ABI / performance

- **RESOLVED (SE wave 5): `cg_free_globals` was ~11 KB of glue
  duplicated into EVERY segment of ClarusC.APPL.** It unrolled one
  release per handle-typed global (10,972 bytes x 49 segments at
  f5a38fc1). Lever (a) landed: each segment's copy is now one loop over
  a DC.W (A5 offset, kind) table plus one release body per distinct kind
  (`cgEmitFreeGlobalsStub`), 2,404 bytes for ClarusC's 377 table entries
  and 9 kinds. ClarusC.APPL's CODE total went 1,607,548 -> 1,141,980
  bytes in Task 2's build (1,142,758 at the wave's tip; 50 -> 36 CODE
  resources); `tests/bake/clarusc_codesize.sh`
  holds it under 1,193,734. What is left, if it ever matters: the 9 kind
  bodies are 892 bytes a segment, 5 of them inline list walks that
  differ only in the per-element release (a shared walk taking the
  element routine would save ~380 bytes x 35 segments); lever (b), a
  jump-table slot, would remove the rest. The duplicated record walks
  and arithmetic helpers were measured at the same time and are small
  (432 + 352 bytes a segment for ClarusC, ~38 KB in all), so they stay
  duplicated.

- **param-abi RSS increase (+4-9%) unexplained** — profile before
  further Layer-2/3 memory work; suspects are the call-site copy temps
  and classification side tables.

- **§1.7 double codegen** (layer1 findings doc): full fix needs
  relocation entries so emission becomes segment-independent — Layer 3
  (caching/architecture) scope.

- **Layer 2 systemic costs** (256-byte `Str255` etc.) untouched by the
  layer1 phase.

- **intmap Stage C candidates** (map-hashtable): `intmapHash` is the
  identity function — add a multiplicative mixer if an on-target
  measurement shows clustering; remaining int-keyed string maps to
  migrate (`recFieldsHeadByName`/`xrecSizeByName` in check.cla,
  `ast.cla`'s `externRetRegBy*` family, `checkEnumDecl`'s `seen`).
  Stage B's own premise (68k-lane win) is still unmeasured on-target.

- **`natLogCap` is 4096 bytes** — a multi-compile `ClarusC.APPL`
  session's `##CLARUS-LOG##` trailer clips at the tail. Raising it
  reblesses ~40 native goldens (`MOVE.L #4096,D0` in every `.s`); do it
  when a real session loses lines that matter.

### Bake / CLIR artifact machinery

#### string-perf phase (2026-09-02)

- **Second baked panic-message identity** — the object/bake format's
  `cgRelClsPanicMsg` carries exactly one codegen-emitted message
  (`cgListOobMsgIdx`, hardcoded at `cg68k.cla` record/resolve sites).
  The phase's inline `s[i]` sidestepped it by delegating its cold path
  to `rtStrIndex`; the next inline bounds check wanting its own message
  must either do the same or extend the format.

#### compiler-cleanup phase (2026-09-05)

- **Stamp-proxy gap** (runtime-ir-bake, still open): the CLIR stamp
  hashes the committed `clarusc/clarusc.c` snapshot, not the live
  runtime source set; the per-module drift hashes close only the
  include-collision slice. Longer-term fix: hash the live runtime
  module sources.

- **Drift log can mislead under a `--rtdir` override**
  (fallback-trigger-narrowing): "absent hash entry" doesn't distinguish
  not-in-manifest from hashed-under-a-different-`--rtdir`; wants a
  `--rtdir`-mismatch test.

- **Bake-time `file.readText` failure silently skips a manifest hash
  entry** (`bake.cla`) — surfaces later as defensive drift-fallback, no
  diagnostic at `--bake-ir` time.

- **`bkInstallFieldInfo` runs on every testapi+UI bake compile**, not
  only case-(b) collisions; and the field-table install has no
  visibility boundary (regression oracle exists:
  `TestRtbakeTestapiManifestOnlyIncludeParity`; underlying gap not
  fixed). `bkSecFieldInfo`'s sufficiency rests on an undocumented
  invariant (baked modules have no `method`/`window`/`form`/`every`/`on`
  decls) — add the doc note near `bake.cla`'s section writer.

- **Drift fixture's mutation is semantically null**
  (`TestRtbakeDriftFallback` appends a comment byte); stronger variant
  (add + call a new extern) recorded, unimplemented.

- **`srcSlot` derivation over-broad** (cg68k paste fixups): claims any
  A5-relative source is the hole rather than exactly the classified
  slot.

- **Capture-side vs load-side object-code globals are half-shared** —
  `cgObjValid`/`RunFirst`/`HoleFirst`/`NHoles` are stale capture-side
  values after a load; read `bkLdObj*` for those. Footgun for readers
  assuming symmetry.

- **A future fourth lazily-set glue flag** (beyond
  `cgMul32Used`/`cgDiv32Used`/`cgMod32Used`) needs
  `cgObjApplyGlueUsage`-style replay or it silently reproduces
  object-code-linker Task 3's bug 3.

- **Comment-drift minors** (clir-load-perf): `bkLoadOverrun` names only
  `bkGetByte` as a setter (four exist); `rtTextStringAt` cites a moved
  idiom. SE Wave 4 left `scripts/memcensus.sh` ~l.46 naming
  `cv_rtbakeBytes` (gone).

### Test coverage

- **No automated test of the 10-stage progress sequence**
  (clarusc-live-log) — order/count/`total` growth only exercised by
  real compile boots; the "Checking Whole Program" stage placement
  depends on the unconditional `native.cla` splice (comment not added).

- **`/tmp/l1src` frozen-source byte-identity procedure is stale**
  (predates param-abi's immutable-params rule); any future phase using
  it needs a fresh re-freeze.

#### filesystem-api phase (2026-08-26)

- **No test exercises `emit68k --rtbake [--testapi]` over a
  `file.info`-calling program** (Task 3's own deferred test gap) —
  closing test: one `tests/bake/` script asserting the bake path was
  taken (`bkRuntimeFuncBoundary > 0`) and that its output matches the
  from-source build's. Task 3's own manual `--rtbake`/`--rtbake
  --testapi` experiments (task-3-report.md) are the only current
  evidence this path works.

#### go-retirement phase (2026-09-05)

- **The Snow `macresident` / `macresident_failed_compile` scripts are
  ported but NOT live-validated** (Task 14) — `tests/mactest/snow/
  macresident.sh` and `macresident_failed_compile.sh` are faithful ports
  of `TestMacResidentClaruscOnSnow` / `...FailedCompileStaysAlive`
  (110-minute default settle, `CLARUS_MACRESIDENT_SETTLE` /
  `CLARUS_MACRESIDENT_DONE` overrides), but neither has been run to
  completion against real Snow: the Go twin needed ~12 h per run on this
  host and the one Snow instance is contended. The rest of the Snow lane
  (`serial_echo`, `pagefile`, `clarusc_boot`, `clarusc_bake`) has been
  booted; `roundtrip` has too. Closing
  action: run both once, opt-in (`CLARUS_SNOW_TESTS=1 make test
  T=mactest/snow/macresident`), when the screen and a long window are
  free, and record the durations.
