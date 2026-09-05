# Clarus TODO — technical debt and needed improvements, not yet scheduled

Condensed from completed phases' deferred/debt lists. The verbatim
context for every item is the originating phase's entry in
`docs/HISTORY.md` (named in the sub-heading or in parentheses) and that
phase's `.superpowers/sdd/<date>-<phase>/` ledger. Items here are
recorded, not committed — scheduling is `docs/ROADMAP.md`'s job. This is
a to-do list, not a history: a fixed item is deleted, not struck through.

Ideas, "if it ever bites" levers, and other maybe-someday items live in
`docs/FUTURE.md` instead (split 2026-09-05).

## Language features (needed)

- **Array-literal initializers** (transfer-crcs phase, Andrew
  2026-08-25): `var t: int[256] = {…}` / `const` arrays do not exist —
  fixed arrays are always zero-filled and `const` initializers are single
  literals — so lookup tables (the `crc32` table, sine tables, MacRoman
  translation tables, keycode maps) must be built at run time. `crc32`'s
  table is built lazily at first call as a stopgap (a 4-byte table pointer in every
  program's data segment, since shake prunes unreachable functions but
  never globals — a second, smaller follow-up in its own right; the 1 KB
  block itself is heap-allocated only by programs that call `crc32`). Needs
  parser + checker + IR + both backends (cg68k constant pool; cprint
  static initializer). Spec: `docs/superpowers/specs/2026-08-25-transfer-crcs-design.md` §2.3.
  The `crc32` table ended up as a heap block rather than a global array
  for the `cg_init_globals` reason recorded under ABI / performance —
  an array literal would also need a zero-cost (constant-pool)
  representation to be the right home for it.

- **Per-window menu bars / menu teardown** (Andrew 2026-08-05): suite
  cases install menus they never tear down; a multi-window app may want
  its own menu set swapped on activate. Needs a design.

### Serial/connection phase (2026-08-16)

- **Host-lane `stdio` and `pty` transports for the serial ports**
  (Andrew 2026-08-30, from 68kbbs's standalone BASIC interpreter):
  `CLARUS_SERIAL_MODEM`/`CLARUS_SERIAL_PRINTER` accept only
  `listen:PORT` and `connect:HOST:PORT` today (`runtime/host/
  rt_serial.inc`'s `rt_ext_ConnHOpen`), so a host CLI program's only
  terminal is a TCP peer — 68kbbs's `scripts/basic.sh` has to start the
  binary listening and attach `nc` to it. Add two more spec values in
  the same parser: `stdio` (read fd 0, write fd 1; optionally raw-mode
  `tcsetattr` on open, restored at exit, for per-keystroke input) and
  `pty` (`posix_openpt`/`grantpt`/`unlockpt`, print the slave path;
  a master with no slave attached behaves like the `listening` state).
  Same env-var-at-open mechanism, no build flag — one binary serves
  any transport by how it is launched. The four functions that assume
  a socket must branch for non-socket fds: `ReadByte`/`Write`
  (`recv`/`send` → `read`/`write`, `ENOTSOCK` on a tty), and `Gone`,
  whose `MSG_PEEK` trick has no tty/pipe equivalent — keep a per-slot
  `gone` flag set when `read` returns 0. `FIONREAD` (`Avail`) and
  `select` (`Idle`) already work on ttys and pipes. Roughly 100 lines of
  C plus a `pipe()`-pair case in `rt_serial_test.c` and a spec
  paragraph; then a deliberate re-pin in 68kbbs.

### binary-files phase (2026-08-22)

- **UI/non-UI connection-pump lane gap** (Task 9's report) — the native
  lane only pumps `connection` traffic (`nat_UiConnPump`) for
  UI-classified programs (window/menu/`every` present); the host C lane
  only ever compiles NON-UI programs (`cprint` emits `#include
  "rt_ui.h"`, which lives only under `runtime/mac/`, so `cc` against
  `runtime/host` fails outright for any program with a `window`/`menu`).
  There is no single program shape that both boots on the host dev lane
  AND pumps connections on native — a serial/BBS-style program has to
  carry at least one throwaway status window purely to get native
  pumping (`examples/pagefile.cla`'s workaround). Serial-connection
  phase's own spec §3/§7 promised one program shape on both lanes; it
  doesn't hold today. Also affects `examples/serialecho.cla`'s doc
  comment, fixed this task to state the real constraint instead of
  claiming host-lane runnability it never had.

### filesystem-api phase (2026-08-26)

- **Resource-fork-as-bytes / `file.openRF`** (Andrew 2026-09-05, moved
  here from 68kbbs's since-retired `docs/language-gaps.md`, item 4 — the
  last unshipped ask on that list) — this phase's `file.*` family covers the data fork
  only; `readResource`/`writeRes` (binary-files phase) remain the only
  resource-fork surface, and both are narrower than what 68kbbs needs:
  `writeRes` writes a fork but leaves the data fork EMPTY (whole-file),
  and `readResource` reads a *named resource from the current resource
  chain*, not an arbitrary file's fork as a blob. Ask: read a named
  file's entire resource fork into a `text`, and write a `text` as a
  file's resource fork alongside an existing data fork. Unlocks
  MacBinary encode on download / decode on upload — transferring real
  Mac files (applications, documents with icons/preferences) faithfully;
  without it BBS file areas can only carry flat data-fork content, which
  rules out most period Mac software. Shape, either: the fork-level
  counterparts to `readText`/`writeText` — `file.readResFork(path, out):
  bool` / `file.writeResFork(path, fork): bool` (data fork preserved) —
  or `file.openRF(path): filehandle` giving positioned I/O against the
  resource fork (mirroring `file.open`'s data-fork `filehandle`), with
  the blob forms built on top. Toolbox: `PBHOpenRF` (already declared in
  `toolbox/files.cla`) + the existing positioned read/write path;
  `file.setInfo` already covers restamping type/creator/dates after a
  decode. Named out of scope by the filesystem-api spec (§7),
  unscheduled.

## Compiler correctness / cleanup

### extern-ptr-call phase (2026-08-27)

- **Converge the three byte-identical extern-index scans** —
  `irExternLookup` (ir.cla:1036), `cgExternIdxByName` (cg68k.cla), and
  `fpExternIdxByName` (cprint.cla) each do the same linear scan over the
  extern registry by name; collapse the latter two onto `irExternLookup`.
  Pure deletion, no behavior change; deferred because it forces a
  snapshot regen + full T2 for zero user-visible effect.

### compiler-cleanup phase (2026-09-05)

- **Native and host now differ on `pop`/`shift` tracking for a
  handle-bearing RECORD element** (Task 6 review, Minor 3) — the shape is
  `lst.pop().field` / `lst.pop() + x` where `lst` is a `list of R` and
  `R` is a record with at least one handle field (`text`/`list`/`map`),
  popped and consumed in a receiver or operand position rather than
  assigned, returned, or passed as an argument. **Lane: native
  (`emit68k`) only** — the host lane (`cprint`) releases it correctly, so
  this is a lane asymmetry, not a symmetric leak. **Why:** this phase's
  §4.1b fix made `cgIntrListPopLike` (`clarusc/cg68k.cla`) track its
  result in every position, but gated on `cgIsHandleKind(irtKind(elemT))`
  rather than the spec's literal `cgNeedsRelease` — deliberately, because
  `cgNeedsRelease` is additionally true for a handle-bearing `KRec`, and
  a `KRec` element is >4 bytes, so the pop writes into a big-pool scratch
  whose OFFSET is handed back to `cgEmitStoreRec` / `cgEmitReturnRec` /
  `cgMaterializeToTemp`; those `cgCopyScratchToDst` the bytes (a raw
  block copy, no retain) into a destination that then owns them, and none
  can untrack the scratch because `cgLastTrackedOff` is only ever
  consulted for a handle kind. Tracking a `KRec` scratch would
  double-release fields the destination is still using. In a
  receiver/operand position nothing takes ownership, so the record's
  handle fields leak — one block per evaluation. The bare-discard arm
  stays as the one `KRec` position that IS tracked.
  **Fix when scheduled:** extend §4.1a's `cgMaterializeToTemp` gate to
  `irExprKind(e) == EIntr and lowIntrIsOwningContainerRead(irIntrName(e))`
  **for `KRec` only** — extending it to handle kinds would double-track
  against §4.1b, which already tracks those at the producer. Plus a
  `LeakCheck` shape, since no fixture in the tree pops a handle-bearing
  record today. Full analysis:
  `.superpowers/sdd/2026-09-05-compiler-cleanup/task-6-report.md`'s
  "Concern 2, restated precisely".

- **Pre-existing, not introduced by this phase: a global `text`
  initializer with a non-literal expression is unsupported on BOTH
  lanes** (final-review wave, Minor 11) — `var g: text = mk()` aborts
  natively with the new named message (`clarusc/cg68k.cla`'s
  `cgAllocTmpOff` abort, ~line 4193; the big-pool sibling `big-temp need
  mismatch` fires the same way for `var h: text = "ab" + "c"`, identical
  on the pre-phase 311af68 compiler), and the host lane (`cprint`) emits
  the initializer call before the function's own prototype, so `cc`
  fails with `clar_fn_mk` undeclared. Found by the final whole-branch
  review's live probe, not by any task; no fixture pins it. Follow-up:
  support global-initializer temps (native) and hoist prototypes ahead
  of global initializers (host), or diagnose it cleanly at check time
  until then.

## ABI / performance

- **`KArr` param ABI** still copies arrays by value at call sites
  (param-abi covered `KStr`/`KRec` only).

- **`ser.cla` still reads per-byte** (`file.save`/`file.load`) —
  deliberate clir-load-perf non-goal, not yet adopted onto bulk reads.

### Correctness-cleanup phase (2026-08-17)

- **`scripts/size-68k.sh` suite composition is stale/broken** — missing
  `cases_param`/`abort`/`textrange`/`errret`/`evalorder`; repair before
  the next size-sensitive phase. This phase's own code-size growth
  (jiggle machinery in the always-spliced `uiscript.cla`, plus the
  div/mod guard added to every glue site; 7 fixtures newly crossed into
  seg2) went unmeasured as a result — record that gap alongside the fix.

### transfer-crcs phase (2026-08-25)

- **`cg_init_globals` re-zeroes what the startup zero-loop already
  zeroed, and unrolls arrays element by element** (transfer-crcs Task 1
  finding): `cgEmitInitGlobalsStub` default-inits EVERY global via
  `cgDefaultInitAt` even when the type's default is all-zero and the
  below-A5 sweep has already zeroed it, and `cgArrDefaultAt` unrolls
  `T[N]` into N stores — a 256-int global costs ~1.5 KB of startup code
  in every native program. Skipping all-zero-default globals (or
  looping large scalar arrays) would shrink every native program's
  startup code; it is a planned rebless wave of its own (every cg68k
  golden's `cg_init_globals` changes). The `crc32` table went to the
  heap to sidestep this.

- **Migrate `crc16` and `crc16x` to table-driven loops** (Andrew
  2026-08-26): both are still per-bit loops (`rtTextCrc16`,
  `rtTextCrc16X` in `runtime/clarus/text.cla`, 8 iterations per byte);
  the Snow probe measured 277 / 287 ticks per 64 KB against `crc32`'s
  120 with its table, so a 512-byte table each (256 × 16-bit entries:
  reflected `0x8408` for KERMIT, forward `0x1021` for XMODEM — the
  standard byte-indexed formulations, `crc = tab[(crc ^ b) & 0xFF] ^
  (crc >> 8)` reflected, `crc = tab[((crc >> 8) ^ b) & 0xFF] ^ ((crc
  << 8) & 0xFFFF)` forward) should bring each down to roughly `crc32`'s
  per-byte cost. Follow the `crc32` pattern exactly: a lazily
  `TextNewPtr`-allocated heap block behind one `ptr` global each, NOT
  an `int[256]` global (the `cg_init_globals` unrolled-init cost just
  above). Each new `ptr` global shifts every later global's A5 offset
  — a full cg68k/emitui golden rebless per global — so land both
  together, ideally in the same wave as the `cg_init_globals` fix or
  the array-literal-initializer phase (which would make all three
  tables constant-pool data and retire the heap blocks). Test vectors
  already pinned: `"123456789"` → `0x2189` (KERMIT), `0x31C3` (XMODEM),
  plus the chunked/n==0 cases in `testdata/run/crc16.cla` and the core
  suite's `Crc16` case; the KERMIT one is also `examples/pagefile.cla`'s
  journal checksum, so the migration must stay bit-exact.

## Runtime / Toolbox robustness

- **Buffered canvases blit every event-loop pass, flickering the mouse
  pointer** (68kbbs canvas log window, Andrew 2026-09-02):
  `rtUiFlushBufferedCanvases` (uiwidgets.cla:1329 / rt_ui.c:2172) does
  a full CopyBits of EVERY buffered canvas with an offscreen
  (`buf.port != 0`) on every rtUiRun iteration, drew or not. A program
  with an `every 2 ticks` block therefore blits a static canvas ~30x/s;
  each blit makes QuickDraw shield the cursor, so the pointer visibly
  flickers over/near the window, and ~17 KB/blit of needless CopyBits
  traffic burns real 68k CPU. Fix: a per-canvas dirty flag in
  RtUiCanvasBuf -- set by every canvas drawing op (clear/line/rect/
  fillRect/circle/fillCircle/drawText), tested by the flush (skip
  clean canvases), cleared after the blit; the updateEvt path must
  force-blit regardless of the flag so window exposure still repaints.
  Both lanes (rt_ui.c mirrors the .cla module). ~10 lines. A static
  canvas then costs zero per pass and the flicker disappears;
  animation loops (the Bounce example) are unaffected since they draw
  every frame anyway.

- **`rtUiTableClick` scripted row math has no upper clamp** against the
  live row count — deliberate tripwire (runtime-ir-bake T2 blocker): a
  clamp would mask the next stale-master-pointer bug. Do not "fix"
  casually.

- **Map runtime minors** (map-hashtable Task 5 review): unbounded index
  probe loops have no corruption guard; `rt_map_layout_check` is
  `sizeof`-only; dead `MAP_KEYBLOCK` constant; three near-identical
  growers; keypool is append-only until release/clear (fine for compiler
  workloads, a real ceiling otherwise).

### Correctness-cleanup phase (2026-08-17)

- **Heap-jiggle stress mode only hooks the `UiNewPtr` waist** (Task 3):
  `rtUiJiggleTick()` forces a full-heap `CompactMem` at each scripted
  dispatch and each `UiNewPtr` call, but core text/list allocations
  (`TENew`, List Manager row storage) and Toolbox-internal moves that
  don't route through `UiNewPtr` are not jiggled — a stale-master-pointer
  bug reachable only through one of those paths would not be caught by
  the harness as it stands today. The stride lever named in the brief
  (tick every Nth call, for when per-call `CompactMem` overhead becomes
  unacceptable) is unused — Task 3's one measured script ran well under
  budget (44.75s vs. a 15m allowance), so no stride was needed.

- **`rtUiLayout`'s dead `ctrlMp` assignment** (`runtime/clarus/
  uiwidgets.cla`, Task 4 audit): `ctrlMp = UiHandleDeref(ctrl)` is
  computed and never read. Harmless (not a staleness hazard — nothing
  consumes the stale value), left in place per the audit's "don't churn
  safe code" rule; worth deleting in a future cleanup pass through that
  function.

- **`(new)` doc-comment tag is a one-off convention** (`runtime/clarus/
  ui.cla:1192,1203`, Task 1): marks the two About-box helpers as new
  relative to the file's inherited `rt_ui.c`-heritage citation style;
  cosmetic, not reused anywhere else in the runtime.

### Serial/connection phase (2026-08-16)

- **Host `every`-timer gap in the CLI pump** (design doc
  `docs/superpowers/specs/2026-08-15-serial-connection-design.md` §6/§7)
  — `every` machinery is UI-runtime-entangled today; the host CLI pump
  services open connections only, not `every` timers. Deliberately not
  promised this phase.

- **Task 7 leftover minors, all deferred**: `serial_snow_test.go`'s
  `done()` blocks ~34s inside `runSnow`'s poll loop, suspending
  died-mid-run detection for that window (now
  `tests/lib_snow.sh`'s `snow_run`); `tests/conntest/listen.sh`
  has a stolen-port edge case; `examples/serialecho.cla`'s
  quit-in-loop keeps scanning the rest of a chunk after the 3rd `Q`
  instead of returning immediately; `runtime/host/rt_serial_test.c` has
  three stale/contradictory comments (alarm numbers, a retry-loop
  reference, and `set_recv_timeout`'s stated rationale).

### binary-files phase (2026-08-22)

- **`testsuite/toolbox/cases_catalog.cla` discards `PBCreateSync`'s own
  error** (Task 2 minor; final-review wave M5; ~line 219,
  `PBCreateSync(fpb) // dupFNErr on a rerun is fine; PBOpenSync below is
  the real gate`) — test-side only, `PBOpenSync` right after is the real
  pass/fail gate for this case. NOT made moot by the final-review wave's
  M2 fix (the `wbuf` `NewPtr(64)` leak a few lines below, in the same
  function) — M2 only disposes the write buffer; it does not touch this
  discarded return value. The *runtime* sibling of this same class of
  gap (`rtFhDevCreate` reporting the OPEN error over a real non-dupFNErr
  CREATE error) is the final-review wave's M4, fixed for real.

### filesystem-api phase (2026-08-26)

- **`rt_fh_mac_time` duplicates `rt_dt_now_mac`'s 3-line Unix-to-Mac-
  epoch-local conversion** (Task 3 minor, deferred; `runtime/host/
  rt_fileh.inc:210-214`, `rt_ext_host.inc`'s `rt_dt_now_mac`) — share
  one helper instead of two independently-maintained copies.

- **`rtFhDevRename` (native lane) re-implements the by-name
  `PBGetCatInfoSync` block instead of reusing a state-block slot**
  (Task 5 minor, deferred; `runtime/clarus/fileh_68k.cla:731`) —
  `rtFhDevStat` already stashes a directory hit's own DirID at
  `rtFh68kState+28`; `rtFhDevRename` could stash the SAME lookup's
  parent DirID at a new `+44` slot and reuse it instead of issuing its
  own separate `PBGetCatInfoSync` call. Correctness is unaffected (both
  calls read the identical field), purely a duplicate-call cost.

- **`rtFh68kEnsureState` does not check `SerNewPtr`'s result** (Task 5
  minor, deferred; `runtime/clarus/fileh_68k.cla:395`) — pre-existing
  idiom for this file's global-lifetime allocation block; an
  out-of-memory native Mac would crash on the next `peekl`/`pokel`
  rather than fail cleanly.

- **`rtFh68kFourCCToStr` maps a zero `fdType` to `""`, conflating an
  untyped file with a folder** (Task 5 minor, deferred; `runtime/
  clarus/fileh_68k.cla:409`) — both a folder and a file with no
  Finder type set read back `type == ""` from `file.info`; `isDir` is
  the only reliable discriminator today. Comment-only fix recorded,
  unimplemented.

- **Host `readdir` names over 255 bytes are silently clamped, and
  `FhHRename`/`FhHMove`'s `snprintf` into a 512-byte `target` buffer
  silently truncates a 255+255-byte path/newName combination**
  (final-review wave, Minor 7, deferred; `runtime/host/rt_fileh.inc`'s
  `rt_ext_FhHListNext:321`/`rt_ext_FhHRename:367`/`rt_ext_FhHMove:377`)
  — neither ceiling sets `lastError`, both just quietly clip. An
  HFS-authored path never reaches either limit (31-byte name cap), but
  a host filesystem entry created by another program could.

## Test coverage gaps (recorded by audits, mostly need real input/hardware)

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

- **Dead runtime declarations**: `UiNewMenuStr` (unused `string`-typed
  NewMenu overload) and the runtime's own `UiCurrentA5` (the `A5Live`
  suite case covers the codegen via its own local extern) — delete or
  wire up in a cleanup pass.

- **Datetime glue loose ends**: host `rt_ext` glue for the catalog's
  `ReadDateTime`/`SecondsToDate`/`DateToSeconds` never added (nothing
  host-side calls them); `rt_ext_mac.inc`'s Date-Time glue is
  header-verified but first really compiled whenever the opt-in cprint
  lane next runs.

- **Suite bookkeeping minors**: the expected case counts are hand-written
  literals in the ported scripts too (`suite_report_check "$WORK/cap.out"
  81` in `tests/mactest/coresuite_68k.sh`, `35` in `toolbox_68k.sh`, each
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
  36/36 as of 2026-09-05.)

### Correctness-cleanup phase (2026-08-17)

- **`rt_ext_UiCompactMem` (Task 3's cprint-lane no-op stub for
  `CompactMem`) is unexercised** — no jiggle test targets the Retro68/
  cprint Mac lane (`TestToolboxSuiteJiggleOn68k` is native-68k-only), so
  the stub is only really compiled whenever the opt-in cprint lane next
  runs (`CLARUS_CPRINT_MAC_TESTS=1`), same class of gap as the existing
  Datetime glue entry above.

### Serial/connection phase (2026-08-16)

- **Toolbox-suite compose file list duplicated across the `bake` and
  `mactest` groups** — `tests/bake/full_corpus_suite_toolbox.sh`'s inline
  list (still labelled `toolboxSuiteGUIFiles` after its Go origin) and
  `tests/mactest/toolbox_files.txt` are hand-maintained twins with a
  "keep in sync" comment as the only enforcement; Task 2 updated one and
  missed the other, undetected until this task's T2 run (see `STATUS.md`
  §3, fix commit `0907364`). A shared source (one list, imported by both) or a
  T1-level consistency check would prevent the next miss.
  Recurred 2026-09-05 (compiler-cleanup Task 10: `cases_casestable.cla`
  was added to `toolbox_files.txt` but not
  `full_corpus_suite_toolbox.sh`; only T2's full sweep caught it) — have
  the bake script read `tests/mactest/toolbox_files.txt` directly.

- **No committed emit-time fixture pinning the unchanged
  `lowUnsupported` rejection for `appletalk`/local-receiver shapes**
  (Task 5) — those shapes still reject the same way pre-phase; nothing
  regresses that specifically today.

- **`tests/conntest/envunset.sh` rebuilds `echo.cla` instead of reusing
  `tests/conntest/connect.sh`'s binary** (Task 5) — T1
  hot-path cost, harmless but avoidable. (Each script has its own `$WORK`,
  so sharing now needs a cached build under `build-run/`, not just a
  reordering.)

- **No coverage for the >4-connections build error** (Task 5) — the
  cap exists and is enforced, just untested.

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

## Compiler-on-Mac (`ClarusC.APPL`) — on hold

The Mac-resident compiler target is on hold (Andrew, 2026-09-05). Nothing
here matters until it resumes: compile-time performance and memory of
clarusc running ON a 68k Mac, the baked runtime IR/object-code (`CLIR`)
machinery that exists to make that fast, and the Snow boots that prove
it. Recorded so the work is not lost, not scheduled.

### ABI / performance

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

- **`--rtbake --lane c` silently drops the `connection`/`filehandle`
  runtime** — a HOST program that uses either type compiles under
  `--rtbake` to C that CALLS `clar_fn_rtConnOpen`/`clar_fn_rtFhOpen`
  (etc.) without ever declaring or defining them, so the emitted C does
  not compile. **Pre-existing, not introduced by this phase**, and
  reproducible on `main`: `tests/conntest/testdata/echo.cla` (unchanged
  since go-retirement) forks 74,570 bytes from source vs 57,795 from the
  bake, the difference being the entire `rtConn*` family; a minimal
  `file.create`/`append`/`close` program forks 59,282 vs 52,371 the same
  way. **Why:** `bake.cla`'s `bakeModuleList` deliberately leaves
  `conn.cla`/`conn_c.cla` and `fileh.cla`/`fileh_c.cla` out of the
  **C-lane** baked chain (its own comment says so) because
  `driveManifestSplice` gates that pair on `usesConn`/`usesFileh` for the
  host lane, keeping every non-conn host program's manifest and IR
  indices byte-identical. But `driveCompile`'s `haveRtbake` branch
  **bypasses `driveManifestSplice` entirely**, so on the bake path
  nothing ever consults `usesConn`/`usesFileh` and nothing ever splices
  the pair. The 68k lane is unaffected — it splices conn/fileh
  unconditionally on both sides, which is why `tests/bake/connfileh.sh`
  (an `emit68k_pair`) has always passed.
  **Found by** the compiler-cleanup phase's close-out T2: spec §3.5's new
  `testdata/emitui/connpump_abort.cla` is the first fixture in the C-lane
  `bake/full_corpus_emitui` sweep to declare a `connection`. That sweep
  now SKIPs the shape with an explicit reason naming this entry, and the
  skip retires itself when the gap closes (it only fires when the
  from-source fork declares the entry point, the bake fork does not, AND
  the bake fork still CALLS it -- that third clause added by Task 11,
  2026-09-05, so a fixture that merely dropped an unused declaration
  cannot take the SKIP).
  **Two candidate fixes**, neither taken here (this phase's spec forbids
  touching `clarusc/bake.cla`, which would fire the 55-minute Snow
  `clarusc_bake` gate):
  (a) add `conn.cla`/`conn_c.cla` and `fileh.cla`/`fileh_c.cla` to the
  C-lane `bakeModuleList` unconditionally, mirroring the 68k lane —
  correct and simple, but it moves every existing host program's baked
  manifest and IR indices, so it needs its own bless;
  (b) extend the existing from-source fallback in `drive.cla` (the
  `bkManifestDriftPath` site that logs "falling back to a from-source
  compile" and re-enters `driveCompile` with `haveRtbake = false`) with
  `haveRtbake and not want68k and (usesConn or usesFileh)` — no
  `bake.cla` edit, no golden movement, reuses machinery that already
  exists, at the cost of a full recompile for those programs. `usesConn`/
  `usesFileh` are already set at that point (the user program is checked
  before the `haveRtbake` branch).
  **Repro** (runnable from this entry alone, from the repo root, using
  the snapshot-bootstrapped `build-run/clarusc-current`):
  ```
  $ build-run/clarusc-current --bake-ir --lane c -o RTC.clir
  $ build-run/clarusc-current emit --rtdir runtime/clarus/ -o SRC tests/conntest/testdata/echo.cla
  $ build-run/clarusc-current emit --rtdir runtime/clarus/ --rtbake RTC.clir -o BAKE tests/conntest/testdata/echo.cla
  $ wc -c SRC BAKE
     74570 SRC
     57795 BAKE
  $ grep -c 'clar_fn_rtConnOpen' BAKE
  1                       # one CALL, zero definitions -- BAKE does not compile
  ```

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

- **Taint-and-discard is silent/uncounted** (object-code-linker): a
  "captured N of M, D discarded" log line or floor assertion would
  surface silent baked-set shrinkage.

- **`bkObjRelocSymValid` never validates `kind` range** — `kind=99`
  falls through the class switch as `Label`.

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

- **`bkReadObjCode` spins on a corrupt `nHoles` count** before the
  framing check fires (pre-existing).

- **Comment-drift minors** (clir-load-perf): `bkParsedValid` should
  state "lane cannot change mid-session"; `bkLoadOverrun` names only
  `bkGetByte` as a setter (four exist); `rtTextStringAt` cites a moved
  idiom; `bkCheckRtbakeHeader`'s header doc still names
  `bkHashTextFrom`; `drive.cla`'s "rtbakeBytes still held"
  parenthetical is wrong for the memoized drift-interleaving case.

#### filesystem-api phase (2026-08-26)

- **Pre-existing: the C (host) lane's `--rtbake` cannot compile any
  `filehandle` program** — `fileh*.cla` is not in `clarusc/bake.cla`'s
  `bakeModuleList` on that lane (found by Task 3's reviewer while
  checking the `prelude.cla` bake path; not introduced by this phase,
  not fixed by it either — the native/`emit68k` `--rtbake` lane is
  unaffected).

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
