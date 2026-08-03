# Clarus Roadmap

Living document — the authoritative sequencing and strategy record. Updated
2026-07-23. The per-task execution history lives in `.superpowers/sdd/progress.md`
(gitignored scratch; git history is the durable record).

## Done (all merged to main)

1. **Language reference** (`docs/clarus-language-reference.md`) — the living,
   normative spec. The design spec (`docs/superpowers/specs/…`) is historical
   rationale; where they disagree, the reference wins.
2. **Front end** — `clarus check`: lexer, parser, checker (`internal/…`).
3. **IR + host backend** — `clarus build` / `clarus run` on the host; typed IR
   with abstract intrinsics (no libc concepts); portable C host runtime
   (`internal/build/rt/`); golden harness (`testdata/run`, `testdata/runerr`);
   reference-fence check suite (`internal/reftest`, index manifest).
4. **CLI/self-hosting language features** — break/continue, switch (desugared
   to if-chains in lowering), const (inline-lowered), slices `s[start,len]`,
   indexOf, text.append, `App.startCLI(args)` with startEmpty fallback, log,
   `quit [code]`, binary-faithful file I/O guarantee, sorted-by-key map
   iteration (Option B — binary-search host map; Mac layout: key-sorted
   offset table over packed arena, no hashing).
5. **clarusc v2 (self-hosted compiler, C emission + bootstrap)** — `clarusc`
   (`clarusc/*.cla`) checks and emits C for the full host subset with
   byte-exact differential parity against the Go compiler over the whole
   corpus; self-emission of clarusc's own source compiles clean; the
   three-stage bootstrap fixed point holds (stage2 C == stage3 C,
   885,785 bytes — `internal/selfhost/bootstrap_test.go`); the ground-floor
   snapshot is committed at `clarusc/clarusc.c`, guarded by
   `internal/selfhost/snapshot_test.go` (`TestSnapshotBuilds`: cc + rt.c alone,
   no Go, no prior Clarus binary, reproduces a working checker;
   `TestSnapshotCurrent`: fails loudly with regeneration instructions if the
   snapshot drifts from clarusc's own source). **The Go compiler is now
   FROZEN** at the bootstrap-subset level — see the strategy section below.
6. **Mac target 4a ("hello, Macintosh")** — Toolbox-native runtime
   (`runtime/mac/rt_mac.c`, `runtime/mac/alert.r`) implementing the full
   `rt.h` ABI (Handles, BlockMoveData, Str255, File Manager files, ALRT 128
   alerts); `scripts/build-mac.sh` drives snapshot-bootstrapped clarusc emit →
   Retro68 cmake → `.bin`/`.APPL`/`.dsk` under `build-mac/`;
   `examples/hello-mac.cla` ran in Mini vMac (alert, clean exit) — milestone
   verified on-screen. `testdata/run` was split into `lib/<name>.cla` logic +
   thin wrapper pairs (harnesses untouched) plus a monolithic
   `testdata/suite/test_suite.cla` (39 in-process tests; `emit_array`,
   `emit_enum`, and the 6 runerr fixtures run as standalone abort apps).
   `internal/mactest` gates Mac-vs-host byte-compare behind
   `CLARUS_MAC_TESTS=1` — zero divergences across the corpus. Go compiler,
   clarusc, and `rt.h`/`rt.c` untouched (frozen surfaces held).
   (Count basis for the "N gated tests" figures below, items 7/8: top-level
   `go test ./internal/mactest -list '.*'` entries under `CLARUS_MAC_TESTS=1`
   at each phase's own merge, not the count including per-file subtests —
   4a's own count is untracked, having predated this convention.)
7. **Mac target 4b (core UI: windows, menus, events)** — core UI runtime
   (`runtime/mac/rt_ui.{h,c}`): windows/instances, button/check/canvas/label,
   Ch8 layout with resize re-pinning, menus (Apple menu + app/window-scoped
   with auto-dimming), every-tick timers, WaitNextEvent loop; `RT_MAC_TEST`
   adds UI trace lines, scripted event injection (deterministic virtual
   time), and 21,888-byte framebuffer snaps, all through the 4a `out`
   capture channel. clarusc lowers window/menu declarations to C descriptor
   tables + UI intrinsics + handler dispatch/every tables/UI main (snapshot
   regenerated; bootstrap fixed point holds; UI-free emission stays
   byte-identical; new ungated `internal/emitui` golden tests).
   `scripts/build-mac.sh` links `rt_ui.c` always; `--events FILE` compiles
   an event script into test builds. `internal/mactest` adds a gated UI
   scenario harness (trace + PBM snap goldens under `testdata/ui` and
   `testdata/uisnaps`, `CLARUS_MAC_BLESS=1` bless mode) plus smokes of both
   acceptance apps — 9 gated tests total (same count basis as item 8 below;
   corrected from an earlier "34", which used an untracked, inconsistent
   basis). Acceptance:
   `testdata/valid/bounce.cla` (now opens its window via `App.launch`) and
   `examples/menu-demo.cla` run as real Mac apps, verified with real input.
   Two real clarusc bugs (menu index base; window `var` defaults dropped)
   were found by the harness/real usage — evidence the test strategy works.
8. **Mac target 4c (text editing: TextEdit, Standard File, document
   launch)** — `field`/`textview` widgets (TENew, click-to-focus, TEKey
   with the 32,000-byte clamp + `lastError`, vertical scrollbar, real
   scrap-backed `standard edit`); `askOpen`/`askSave`/`askSaveChanges`
   (Standard File, scripted via an `RT_MAC_TEST` answer queue); bare
   `title` reads (`GetWTitle`); `App.openDocument` on both System 6
   (`GetAppFiles`) and System 7+ (AppleEvents, gated on an `app` section's
   `SIZE(-1)` `isHighLevelEventAware` bit); the `app` section itself
   (name/version/author/about/icon/creator id — About box, `vers`,
   `ICN#`/`ICON`/`FREF`/`BNDL`). Acceptance: `examples/texteditor.cla`,
   Appendix C's Text Editor verbatim plus an `app` section and an
   over-32,000-byte open guard, builds a real double-clickable
   `Text-Editor.{bin,APPL,dsk}` (SIZE(-1), both document/app icons, both
   FREFs) and passes three new gated scenarios: a real save/reopen file
   round trip, the two-dirty-document quit-cascade (cancel aborts mid-cascade,
   already-closed windows stay closed, unvisited ones stay open), and the
   too-large-file open guard (alert + clean close, no truncated content
   ever shown) — 25 gated `internal/mactest` tests total (same count basis
   as item 7 above: top-level test functions, cumulative over 4a+4b+4c).
9. **Mac target 4d (forms, binding, tables, persistence): DONE.**
   `form for`, the binding walker (`binds:` on
   `field`/`check`/`popup`), the `edit` statement (movable-modal, all four
   target shapes: `new T`/lvalue var/list element/map element),
   `accepted`/`cancelled` and the synthetic `isNew`; `popup` (System 6
   manual `PopUpMenuSelect`, System 7 CDEF scaffolding parked — see the
   small-open-items list); `table`/List Manager (JMP-stub LDEF, live
   add/remove/writeback redraw, column binding); `file.save`/`file.load`
   record and list/map serialization. Layout-default gap (found by this
   phase's own acceptance app, not by any earlier task): the reference's
   Appendix C `EditForm` declares no `size:` and none of its widgets an
   `at:` at all — Ch8's Layout section now documents the runtime default
   this relies on (a vertical stack, one gap below the previous widget, at
   a fixed left margin — unless `fill: both`, which keeps the pre-existing
   origin default — and a window with no `size:` sizes itself to fit that
   stack); implemented in `clarusc/lower.cla` (a new `RTUI_AT_AUTO` atKind
   for a widget with no `at:` property at all) and `runtime/mac/rt_ui.c`
   (`rt_ui_natural_size`, the `RTUI_AT_AUTO` layout case). A second,
   related runtime fix landed alongside it: a `field`'s fixed 70px label
   lane could reduce a narrower declared `width:` (Appendix C's own `Port`
   field is 60px) to a zero-width, permanently unclickable edit box —
   clamped to leave a minimum usable width instead. Neither fix moved any
   pre-existing golden (verified byte-identical; every prior fixture
   declares explicit `at:`/`size:`/wide-enough `width:`). Acceptance: the
   Appendix C Bookmark Manager (`examples/bookmarks.cla`) verbatim plus an
   `app` section and `file.save`/`file.load` persistence (`Remove.click`
   and `accepted` both save; `App.startEmpty` loads, ignoring a missing
   file), builds a real double-clickable `Bookmarks.{bin,APPL,dsk}`, and
   passes a new gated add/edit/remove scenario (popup pick, favorite
   check, one port-validation failure, a dblclick-edit writeback round, and
   a remove) — 32 gated `internal/mactest` tests total (same count basis
   as items 7/8 above). Handle-backed records were dropped per the 4d spec —
   records stay value types per the reference; the underlying Handle-hygiene
   concern moved to the 4e memory audit.
10. **Mac target 4e (memory-management audit): DONE.** One memory model,
    no forks: `internal/build/rt/rt_mem.h` + the paranoid host shim
    (`rt_mem_host.inc`) implement the real Toolbox Memory Manager subset
    (double-indirected handles, `SetHandleSize` relocation, `0xA5` scramble
    on move/dispose, guard bytes, an allocation-tag ledger); the Mac build
    just includes `<Memory.h>` — no wrapper. Two-tier paranoia: handle
    relocation on resize is unconditional everywhere, but the full
    every-allocation-moves-everything sweep is opt-in via
    `CLARUS_MEM_PARANOID=1` (corpus test lanes only — bootstrap-scale runs
    stay linear). `rt_mac.c`'s text/list/map collections and the pure
    str255 helpers moved into a single shared `internal/build/rt/rt_core.inc`
    (`rt.c`'s malloc-backed twins deleted); the struct box switched from a
    forever-locked Handle to a plain `NewPtr`, making it disposable. New
    dispose API (`rt_text_free`/`rt_list_free`/`rt_map_free`,
    `rt_register_cleanup`) is shallow and NULL-safe; double-free is caught
    by the scramble/ledger. clarusc now frees conservatively wherever it can
    prove sole ownership: statement-level expression temporaries, non-escaping
    handler locals on every scope-exit path (including if-condition temps on
    branch jumps), generated `cl_free_globals()` for every global text/list/
    map (registered via `rt_register_cleanup`), and a generated per-window
    release function that frees handle-backed window vars at teardown —
    closing the rt_mac.c:479 leak recorded as a small open item since 4d.
    A real pre-existing bug found along the way: `rt_ser.inc`'s
    `rt_file_save`/`rt_file_load` leaked a whole `rt_text` per call on both
    runtimes — fixed, now enforced forever by the paranoid shim. Enforcement:
    a strict-mode (`CLARUS_MEM_STRICT=1`) exit hook reports every live
    un-noted block and fails the process; the full clarusc-emitted golden
    corpus now runs under strict+paranoid mode with per-program `.leaks`
    goldens (default 0) as a permanent ratchet — 32 of 50 programs were at
    zero at merge, the other 18 were blessed goldens tracing to documented
    leak-by-design classes (call-result/reassignment orphans, element-read
    containers, record fields out of the local-free pre-pass's scope,
    disqualified globals and window vars) that remained until ARC — **all
    resolved, see Done item 11.** Go compiler, its emitted output, and the
    bootstrap chain are unaffected — frees are unobservable in program
    output. Full spec + per-site dispositions:
    `docs/superpowers/specs/2026-07-28-memory-audit-design.md`.

11. **ARC (automatic reference counting): DONE.** Refcounted boxes
    (`int32_t rc` as the first field of `rt_text`/`rt_list`/`rt_map`,
    `rt.h`/`rt_core.inc`) replace 4e's escape-analysis apparatus outright:
    retain on every reference copy (assignment, container store, record
    copy, return), release at scope exit/container removal/global-and-
    window teardown, all inserted locally by `lower.cla` with no
    whole-program qualification. Clarus has no recursive types, so the
    ownership graph is a DAG — refcounting is sound AND complete here,
    not an approximation (no cycle collector needed). Deep release
    (list/map-of-handle element loops, record retain/release walk
    helpers) is compiler-generated per element/field type, mirroring the
    4e `cpEmitFree` machinery. Migration proceeded class-by-class (temps/
    call-results → locals → container elements → globals/window vars →
    records), holding the no-UAF invariant at every intermediate state
    via a `*_free == *_release` alias during the transition. All 18
    nonzero `.leaks` goldens (item 10) went to zero; the golden files
    themselves are now deleted (absent == 0 stays the ratchet's default).
    The 4e escape-analysis apparatus (`lowEscapeWalk*` and friends, ~1000
    lines of `lower.cla`) is deleted outright. One real bug found and
    fixed by the migration's own final review: a discarded `pop()`/
    `shift()` result (`lst.pop();`, value unused) is an ownership
    TRANSFER with nowhere to land — leaked under naive translation until
    `fpDiscardExprIdx` (`clarusc/cprint.cla`) special-cased it. Hard-won
    lesson: transfer-convention intrinsics (pop/shift) don't get the
    statement-temp tracker's automatic release-when-discarded coverage
    that +1-convention intrinsics (first/last/map-get, user calls) get
    for free — anything added later with transfer semantics needs the
    same explicit wiring (open item below). Emitted C grew substantially
    from the retain/release traffic, measured at snapshot regen:
    `clarusc/clarusc.c` 1,633,052 → 2,332,983 bytes (+43%). Mac gate:
    full `internal/mactest` suite (`TestSuiteOnMac`, `TestRunErrOnMac`,
    `TestAbortAppsOnMac`, all 23 UI scenarios) byte-identical, same as
    every prior Mac milestone — counts are unobservable in program
    output. 68k timing baseline (the elision-decision measurement the
    design doc committed to before deciding on elision): Bookmarks and
    Text Editor, both built from the SAME `examples/*.cla` + `.events`
    script pre- and post-ARC (pre-ARC clarusc rebuilt from a worktree at
    `5f136f4`, the commit immediately before Task 1), wall-clocked over 3
    LaunchAPPL runs each in Mini vMac. Bookmarks: 9.09s pre-ARC → 9.21s
    post-ARC (+0.12s, ~1.3%). Text Editor: 3.98s pre-ARC → 3.97s
    post-ARC (no measurable change). Both deltas are within run-to-run
    noise (observed spread ~0.05-0.2s per binary) and neither is
    subjectively perceptible on the emulator — **elision is NOT
    triggered by this measurement.** Full design + counting-rules table:
    `docs/superpowers/specs/2026-07-29-arc-design.md`.

## Decided sequencing (REORDERED from the older plan docs' roadmap notes)

The user chose to pursue self-hosting BEFORE the Mac target, because clarusc
development is fully host-testable and will surface language defects that
should be fixed before the Mac runtime freezes contracts. The older plans'
"Roadmap context" sections predate this reorder — this file wins.

**Decided 2026-07-23: clarusc is next.** The order is:

1. **clarusc** — the compiler written in Clarus, developed host-side against
   the Go compiler with differential testing, through the three-stage
   bootstrap and the committed C snapshot (strategy below). **DONE** — see
   "Done" item 5.
2. **Mac target** (4a "hello, Macintosh", then 4b core UI, then 4c text
   editing, then 4d forms/binding, then 4e memory audit). 4a **DONE** — see
   "Done" item 6. 4b **DONE** — see "Done" item 7. 4c **DONE** — see "Done"
   item 8. 4d **DONE** — see "Done" item 9. 4e **DONE** — see "Done" item
   10.
3. Memory + forms runtime, then networking.
4. clarusc's 68k build — compiling Clarus on a Macintosh — once the Mac
   target exists.

## clarusc / self-hosting strategy (agreed in discussion, 2026-07-22)

- **The Go compiler is now FROZEN at the bootstrap-subset level (decided
  2026-07-23, clarusc v2 complete).** It served as the bootstrap + reference
  implementation through self-hosting; that job is done. It is kept ONLY as
  the differential-testing reference. New language features land in the
  reference (`docs/clarus-language-reference.md`) + clarusc first; the Go
  compiler is updated only as needed for differential coverage of those
  features, not as a first-class implementation target.
- **One-feature freeze exception: `\xHH` string/char escapes backported to
  the Go compiler, 2026-07-28, at Andrew's explicit direction.** Rationale:
  it's a spec-level lexical feature, not a new implementation target, and
  without it the reference's Appendix C fences and the differential corpus
  would have to keep working around a byte-escape the reference itself
  documents. The freeze remains in force for everything else — this is a
  named, deliberate exception, not a reopening.
- **Bootstrap chain — HOLDS:** Go compiler compiles clarusc.cla → stage1;
  stage1 compiles clarusc → stage2; stage2 compiles clarusc → stage3; stage2
  and stage3 outputs are byte-identical (fixed point: 885,785 bytes —
  `internal/selfhost/bootstrap_test.go`, `TestBootstrapFixedPoint`).
- **C snapshot as interlingua — committed:** clarusc's own generated C is
  checked in at `clarusc/clarusc.c` — the ground-floor bootstrap, buildable
  by any C compiler (cc + `internal/build/rt`) with no Go and no prior Clarus
  binary (`internal/selfhost/snapshot_test.go`, `TestSnapshotBuilds`). This
  means the Go compiler does NOT need indefinite maintenance. At each future
  release the snapshot is regenerated by the PREVIOUS release's compiler
  (build clarusc via that compiler, `clarusc emit -o clarusc/clarusc.c
  clarusc/main.cla`, commit) and guarded against drift by
  `TestSnapshotCurrent`, which fails with regeneration steps if
  `clarusc/clarusc.c` no longer matches a fresh emission of clarusc's own
  source.
- **Conservative subset rule:** clarusc's own source avoids new language
  features for at least one release cycle, keeping the bootstrap chain wide.
- **Differential testing:** both compilers build the full golden/fence corpus;
  outputs must agree.
- **AST idiom:** Clarus has no recursive types — clarusc uses arena style
  (`list of Node` + int indices for child links). Deliberate, period-authentic.
- **Cross + native:** one clarusc source; host printer build = modern
  cross-compiler; 68k printer build (after Mac target) = compiling on the Mac.
  The Mac-resident version is a GUI app (askOpen/alert), not a CLI.

## Mac target (Plan 4) — 4a through 4e all done

- **4a "hello, Macintosh": DONE.** Toolbox runtime implementing the same
  intrinsic ABI (Handles, BlockMove, real Str255), Retro68 pipeline
  (`/Users/andrew/repos/Retro68-build/toolchain` — note: built toolchain is in
  Retro68-build, NOT the Retro68 source dir), `scripts/build-mac.sh`,
  alert-only program in Mini vMac. Printer seam proven — see "Done" item 6.
- **4b core UI (windows/menus/events): DONE.** Windows, widgets
  (button/check/canvas/label), Ch8 layout, menus, every-tick timers, the
  WaitNextEvent loop, and a deterministic scripted-event test harness — see
  "Done" item 7. Acceptance: bounce + menu demo as double-clickable apps,
  real-input verified.
- **4c text editing (TextEdit, Standard File, document launch): DONE.**
  `textview`/`field`, `standard edit`, `askOpen`/`askSave`/
  `askSaveChanges`, bare `title` reads, `App.openDocument` (System 6
  `GetAppFiles` + System 7+ AppleEvents), and the `app` section (Finder
  identity, About box, icon) — see "Done" item 8. Acceptance: the
  Appendix C Text Editor (`examples/texteditor.cla`), a real
  double-clickable app with a save/reopen round trip, the multi-window
  quit-cascade, and the too-large-file guard all verified.
- **Phase re-split (decided 2026-07-24, superseding the old "both Appendix C
  examples" 4b acceptance — each phase ships a real artifact):**
  - **4d (branch mac-target-4d): DONE.** Forms + binding walker,
    `popup`, `table`/List Manager, `file.save`/`load` — see "Done" item 9.
    Acceptance: the Appendix C Bookmark Manager (`examples/bookmarks.cla`),
    verbatim plus persistence. Handle-backed records were dropped per the
    4d spec — records stay value types per the reference; the underlying
    Handle-hygiene concern moved to the 4e memory audit.
  - **4e (branch memory-audit-4e): DONE.** Memory Manager shim + unified
    `rt_core.inc`, dispose API, conservative clarusc frees (temps/locals/
    globals/window vars), the `rt_ser` save/load leak fix, and a
    strict+paranoid leak gate over the golden corpus — see "Done" item 10.
    Full design and per-site dispositions:
    `docs/superpowers/specs/2026-07-28-memory-audit-design.md`.
- Then: networking (MacTCP + ADSP/NBP; needs Basilisk II or real hardware —
  Mini vMac networking is limited).

## Native 68k toolchain (Plan 5)

- **5a (landed on branch `native-5a`, 2026-07-29):** the language + waist
  additions from the Plan 5 design — `ptr` as a distinct 32-bit-address
  scalar type (banned as a container element in v1), typed peek/poke
  builtins (`peekb`/`peekw`/`peekl`, `pokeb`/`pokew`/`pokel`), declared
  `external func` Toolbox-style routine decls with cprint lowering to a
  `rt_ext_` host shim seam (ledger-instrumented), a new `internal/lowlevel`
  differential harness (fixtures `extmem`, `extorder`), and language
  reference Chapter 13 plus the `ClaruscOnly` fence mechanism that lets this
  clarusc-only surface skip Go-compiler parity. Trap-clause syntax for
  `external func` (inlining traps directly in codegen68k) is deferred to
  5d/5e; the Handle-master-pointer-via-peekl idiom was found to be
  68k-only and needs a proper deref primitive, designed in 5b. Full design:
  `docs/superpowers/specs/2026-07-29-native-68k-toolchain-design.md`; task
  plan: `docs/superpowers/plans/2026-07-29-native-5a-lowlevel.md`.
- **5b (runtime migration wave 1, landed on branch `native-5b`, 2026-07-30):
  DONE.** `rt_ser` and the `rt_str_*`/`rt_text_*`/`rt_list_*`/`rt_map_*`
  families ported from C to Clarus (`runtime/clarus/{ser,str,text,list,
  map}.cla`, 2,127 lines) over the 5a waist, clarusc-fed implicitly per
  program (gated on IR usage marks — no user `include`). cprint's intrinsic
  arms redirect per family (`cpSerPorted`/`cpStrPorted`/`cpTextPorted`/
  `cpListPorted`/`cpMapPorted`) to the ported Clarus functions once a
  module is included; the C originals stay in `rt.c`/`rt_mac.c` forever as
  the frozen Go compiler's only backend and as the port's differential
  oracle. Also landed: `overlay` record types (Chapter 13; scalar-field-only
  pointer-backed structs giving portable Toolbox-record-shaped field access
  without recursive-type or ARC concerns), external `str`/`text` param
  marshalling, a Handle-deref waist primitive, and flat pointer-free
  `clar_serdesc_<REC>[]` int32 descriptor tables so the serializer can walk
  record layout portably with `peekl` alone. Birth allocation
  (`TextNewRaw`/`ListNewRaw`/`MapNewRaw`) delegates whole-box construction
  to the existing C `rt_*_new` (refcount stays C-owned, written exactly
  once) rather than having ported Clarus code poke a raw `rc` field — the
  design's anticipated lazier option. RC/lastref/free and every other
  memory-management primitive stay untouched in C, reached through
  `rt_ext_*` waist externals — this wave moves container *logic*, not RC
  *policy*. **Plan defect found and adjudicated (Task 6):** the plan's
  original oracle for the serializer stage — a Go-compiler-vs-clarusc
  double build with byte-compared CLRD output — is unbuildable, because the
  frozen Go host compiler permanently rejects `file.save`/`file.load`
  programs (a restriction predating this wave). Adjudicated to a
  golden-based oracle instead: frozen C-serializer CLRD bytes + stdout
  committed under `testdata/sertest/clrd_goldens/`, clarusc builds
  byte-compared against them (`internal/sertest/clrdcompare_test.go`) — the
  same guarantee held through every later family's port, goldens
  untouched. Verification: an 18-probe adversarial container matrix
  (reassign/discard/alias × value/str/text/list/map slot classes) over the
  fully-ported runtime found zero live leaks and zero bugs. Full outcomes
  record (redirect-exclusion list as-built, extern-naming convention,
  ported-flag mechanism, `cpEmitDefaultInitFnProtos` forward-declaration
  fix): `docs/superpowers/specs/2026-07-29-runtime-migration-wave1-design.md`
  ("Outcomes" section); task plan:
  `docs/superpowers/plans/2026-07-29-runtime-migration-wave1.md`. Retro68
  stays in the Mac app path unchanged — ported modules still compile to C
  via cprint and link into the Mac build through Retro68's gcc -O2 exactly
  as before; Retro68 only retires from the app-build path at 5f. The C
  runtime (`internal/build/rt/`, `runtime/mac/rt_mac.c`) is retained
  permanently as the frozen Go compiler's backend, not deleted. **68k
  timing:** as expected, ≈no change — the full gated `internal/mactest`
  suite (31 tests: `TestSuiteOnMac`, `TestRunErrOnMac`, `TestAbortAppsOnMac`,
  all 23 UI scenarios, plus 5 non-boot build/unit tests) ran green in
  157.0s wall-clock; the Bookmarks scenario (heaviest single UI boot, now
  running the fully-ported serializer/str/text/list/map runtime end to end)
  landed at 9.83s build+boot here, in the same ballpark as the ARC-era
  baseline's pure-launch 9.09-9.21s over 3 runs (Done item 11) — consistent
  with §7 of the design spec ("explicitly not at risk"): ported modules
  still compile to C and link under Retro68 gcc -O2, so there is no naive-
  codegen cost to pay until 5d.
- **Resequenced 2026-07-30 (5d design brainstorm):** next is **5c′ —
  runtime migration wave 2a (mem/ARC in Clarus)**, a hard prerequisite of
  5d because the native backend links only Clarus-generated code; ported
  and verified on the existing cprint → Retro68 path, own spec/plan/branch.
  Then **5d — codegen68k**: direct binary emission via an instruction-table
  layer (encoder + listing printer + future peephole share one table; no
  asm-text assembler, ever), C-style calling convention (caller-cleans, D0
  result — the 68000 has no RTD, Pascal results ping through memory, and
  caller-cleans lets peephole batch stack pops), IR tree-shake pulled into
  5d from old 5c, trap clauses land in 5d. The compilation cache (rest of
  old 5c) slides to after 5d. Design:
  `docs/superpowers/specs/2026-07-30-native-5d-codegen68k-design.md`.
- **5c′ (runtime migration wave 2a, landed on branch `native-5c`,
  2026-07-30): DONE.** The mem/ARC waist for Text/List/Map moved from C to
  Clarus: rc arithmetic (retain/release), the `lastref` "am I the only
  owner" predicate, and birth allocation are now entirely Clarus-owned for
  all three container families — `rtTextNew`/`rtListNew`/`rtMapNew` build
  the box, acquire the Handle(s), and set `rc = 1` themselves (via
  `TextNewPtr`/`ListNewPtr`/`MapNewPtr` + `*NewHandle` + overlay pokes),
  rather than delegating whole-box construction to C the way 5b's
  `TextNewRaw`/`ListNewRaw`/`MapNewRaw` did — those three externs are
  deleted from both `rt_ext_*.inc` shims. `rtListAt` was ported fresh for
  this wave (it did NOT pre-exist from 5b, correcting the task plan's
  assumption); `rtMapValAt`/`rtMapCount` did pre-exist and needed no work.
  Sequence: Task 1 (`fd76df6`) added 13 new `rt_ext_*` waist externs per
  `.inc` shim (26 total) — `*NewHandle`/`*DisposeHandle`/`*RcCheck` for all
  three families plus `*NewPtr`/`*DisposePtr` for List/Map (Text already
  had them from 5b); the host `*RcCheck` body matches `rt_rc_check`'s exact
  `"rt_rc: over-release at %s\n"` diagnostic, the Mac body is a no-op. Task
  2 (text: `736690d`/`2e256aa`/`a938313`/`3afa5fd`), Task 3 (list:
  `c6d10e0`/`bbc1b2d`), and Task 4 (map: `5e4f6fd`/`5c284ff`) ported each
  family's birth/retain/release/lastref in turn, redirecting
  `cpTextArcPorted`/`cpListArcPorted`/`cpMapArcPorted` (cprint.cla) to the
  new Clarus functions at every emission site (`IRetain`/`IRelease`/
  `I*FreeVar` intrinsics, `cpEmitRetain`/`cpEmitRelease`'s per-kind arms
  including inside the other families' element-release walks,
  `fpRetainVal`/`fpReleaseVal`/`fpNewTmp`-composed retain/release, and the
  container-accessor `_retain` suffix sites). A deliberate parity gap,
  wave-wide: the C reference calls `rt_rc_check` unconditionally on both
  retain and release (`rt_core.inc:800-864` — retain calls it before
  incrementing too); the port only guards the cold `rc <= 0` release path
  and never checks on retain at all. Task 5 (`322e0c9`) swept `cprint.cla`
  for every literal and composed `rt_text_*`/`rt_list_*`/`rt_map_*`
  ARC-suffix emission site (3 stems × 4 suffixes) and found none missed,
  then added two adversarial
  fixtures (list-of-map, globals) to the ARC matrix, both clean at
  `live == 0`. **What stayed C, and why:** the `rt_mem_host.inc` leak
  ledger (host-only debug infra the leak gates read), `rt_register_
  cleanup`/`rt_run_cleanup` (a C function-pointer slot), the `rt_rc_check`
  host body itself (still reached via the per-family `*RcCheck` externs on
  the cold path only), the four pure ADDRESSING sites in `cprint.cla`
  (`fpIndexRef`'s own `rt_list_at`, `fpForListStmt`'s per-iteration element
  deref, `IListSet`'s ref, `IListRemove`'s old-value read — documented at
  `fpIndexRef`'s own doc comment), `fpUiEditStmt`'s `kind==2`/`kind==3` arms
  (`rt_list_at`/`rt_map_get_dv`, a Ch10/mac-target-4c UI exclusion
  predating this wave, not an RC one), and the C originals in
  `rt_core.inc` forever, as the frozen Go compiler's backend and this
  wave's differential oracle. **Verification:** zero `.leaks` and zero CLRD
  golden churn held through every task (the differential corpus doubled as
  the rc oracle) — the snapshot and `emitui` `.c.golden` files DID churn
  mechanically each time a family's redirect flipped (the emitted C text
  itself changes; `2e256aa`/`bbc1b2d`/`5c284ff`), but no behavior output
  ever did. Gauntlet (`go test ./...`, `internal/selfhost` ~250-590s per
  run) green on every task. **68k timing:** as expected, ≈no change — the
  final full gated `internal/mactest` suite (31 tests) ran green in
  172.666s wall-clock (5b baseline: 157.0s); the Bookmarks scenario
  (heaviest single UI boot) landed at 10.27s build+boot (5b baseline:
  9.83s) — same ballpark, since ported ARC still compiles through Retro68
  gcc -O2, no naive-codegen cost until 5d. Full task-by-task detail:
  `.superpowers/sdd/2026-07-30-native-5c-runtime-wave2a/task-{1..6}-report.md`;
  plan: `docs/superpowers/plans/2026-07-30-native-5c-runtime-wave2a.md`.
  **5d-input inventory** (runtime logic still in C, feeding the 5d
  codegen68k design's Resequencing section): the four C ADDRESSING sites
  above, `fpUiEditStmt`'s two arms above, `lasterr` reads (`rt_str_store`
  over a C global), `rt_arr_check`, `rt_enum_from_int`, file I/O
  emissions, `rt_register_cleanup` — plus runtime logic not yet inventoried
  for native: `rt_print`/console, `rt_panic`, `rt_args`. Full list also
  recorded in
  `docs/superpowers/specs/2026-07-30-native-5d-codegen68k-design.md`'s
  Resequencing section.
- **5d (codegen68k, landed on branch `native-5d`, 2026-08-01): DONE.**
  clarusc gained a second backend: direct 68000 binary emission through a
  shared instruction-table layer (`clarusc/asm68k.cla`, an encoder +
  Motorola-syntax listing printer that never gets parsed back — the listing
  is checked by a **vasm round-trip oracle**, `vasm/vasmm68k_mot -m68000
  -no-opt -Fbin` byte-compared against the encoder's own bytes,
  `internal/asm68k`, 254/254 instruction forms). `clarusc/cg68k.cla`
  (`cg68Program`) compiles the shaken IR straight to 68000 machine code —
  no object files, no linker, no assembler-as-text step ever — with a
  C-style calling convention (caller cleans, D0 result, LINK/UNLK A6;
  D0/D1/A0/A1 scratch, D2-D7/A2-A4 preserved even though naive codegen
  never needs the extra callee-saves yet), naive stack-oriented temp
  allocation, and `.W`-branch/backpatch control flow. `clarusc/app68k.cla`
  writes the MacBinary/resource-fork container (CODE 0 jump table + N CODE
  segments, SIZE(-1), type/creator) — same bytes on Mac and host, different
  wrapper (real resource fork vs MacBinary for `LaunchAPPL`). Tree-shake
  (IR reachability from entry + event handlers) moved into this phase from
  old 5c, as does trap-clause codegen for `external func` (register-convention
  reg traps evaluated into A0/A1/D0/D1 by a fixed rule, pascal-stack traps,
  inline clauses, a `nat_` fallback convention for anything without a
  hand-written trap). The remaining C runtime leaves that would have blocked
  a Clarus-only-linked native app were ported first: `core.cla`
  (lasterr/panic/array+enum bounds checks/fixed mul-div) and `ser.cla`'s
  last ten `rt_list_*`/`rt_map_*` externs redirected to the already-Clarus
  list/map (Tasks 3-4).

  **The end gate (Task 16):** the same `testdata/suite/test_suite.cla`
  `TestSuiteOnMac` already runs — every runtime family, file I/O (host-side
  only, see gate limits), and panics — built via `clarusc emit68k` (no C, no
  cmake, no Retro68 at all) and booted on Mini vMac, byte-identical to the
  host build's stdout, exit 0. Plus the 6 `testdata/runerr/*.cla` panic
  fixtures (exit 3, log message matches) and the 2 suite-excluded
  abort-by-design programs (`emit_array`/`emit_enum`, exit-code + stdout
  goldens) — 9 boots total, mirroring the Retro68 gate's own structure
  exactly (`TestSuiteOn68k`/`TestRunErrOn68k`/`TestAbortOn68k`,
  `internal/mactest/native_test.go`). New `scripts/build-68k.sh` (usage:
  `build-68k.sh NAME file.cla...`) bootstraps clarusc from the committed
  snapshot exactly like `build-mac.sh`'s own step 1 (cached on
  `clarusc.c`'s mtime), then `emit68k --rtdir runtime/clarus/ -o
  build-68k/$NAME/$NAME.bin FILES` directly — no C, no cmake, no Retro68;
  it works standalone (verified: all 9 gate fixtures build clean through
  it) but the gate tests themselves use the same in-test emit pattern every
  other `native_test.go` boot already uses (`buildNativeClarusc` +
  `clarusc emit68k` invoked directly), for the same reason: one memoized
  clarusc build amortized across all 9 boots in a `go test` run, vs.
  bootstrapping-by-subprocess per boot.

  Gate results: 9/9 boots green (`CLARUS_MAC_TESTS=1 go test
  ./internal/mactest -run 'On68k' -timeout 60m`, 32.634s total): 1×
  `TestHelloOn68k` (5.71s, pre-existing), `TestSuiteOn68k` (4.48s),
  `TestRunErrOn68k`'s 6 subtests (16.58s total, 2.7-2.8s each),
  `TestAbortOn68k`'s 2 subtests (5.54s total, 2.75-2.79s each).

  **Timing** (no pass/fail threshold in 5d — this number seeds the
  peephole/regalloc phase's buy-back target). Two framings, both measured
  same machine/same session: **(1) total wall-clock** (build+boot+run,
  what the gate tests themselves report) — `TestSuiteOn68k` alone (own
  process, pays its own one-time clarusc build): 7.26s; `TestSuiteOnMac`
  alone (Retro68/gcc -O2, same conditions): 8.52s — native is FASTER
  overall (≈0.85×), because `clarusc emit68k`'s direct-binary-emission
  build step (no C compile, no cmake, no linker) is much cheaper than
  Retro68's gcc -O2 + cmake + link pipeline, and that build-time saving
  outweighs naive codegen's execution cost for this workload. **(2)
  boot-to-exit only** (LaunchAPPL wall-clock in isolation, both paths'
  own already-built `.bin`, build time excluded — the real codegen-quality
  signal): native 3.844s vs Retro68/gcc -O2 3.659s — a **≈1.05× native-
  vs-gcc-O2 ratio**, i.e. naive codegen with zero peephole/regalloc runs
  this suite only ~5% slower than -O2. Honest reading: `test_suite.cla` is
  dominated by Toolbox trap round-trips (`_NewHandle`, the modal alert
  loop, etc.) identical on both backends, not hot numeric/ARC loops where
  naive codegen would be expected to pay the most — the parent spec's own
  expectation ("naive codegen of hot ARC paths will need buy-back") is
  neither confirmed nor refuted by this workload; it just isn't the right
  stress test for that question. (ROADMAP baseline for context: 5c′'s full
  31-test gated suite was 172.7s wall-clock; that number is the whole
  `internal/mactest` gate, not `TestSuiteOnMac` alone, so it isn't
  directly comparable to the ratios above — recorded here for continuity,
  not as the baseline itself.)

  **Three recorded gate limits (honest, from the plan, unchanged by
  Task 16):** (1) native rc-leak parity is structural, not measured — the
  host leak ledger can't run on the Mac; the mirror-of-cprint discipline
  plus the host-side leak gates on identical IR is the guarantee. (2)
  `file.save`/`file.load` never joins the native gate in 5d — the host
  suite expectation is built by the frozen Go compiler, which rejects
  those programs outright; `ser.cla`'s native fallbacks
  (`nat_SerFileWriteData`/`nat_SerFileReadTextInto`, Task 14) compile and
  run but have no emulator test until 5f's self-host exercises file I/O
  heavily. (3) Division by zero natively raises the 68k divide exception
  (system error) unguarded, matching host UB — no fixture divides by zero.

  **The 15.5 FROZEN-GO-COMPILER FIX — PENDING ANDREW'S RATIFICATION.**
  Task 15's multi-segment hardware boot investigation traced a real bug
  (list-of-text losing earlier entries across `a68Reset()` cycles) to
  `internal/lower/stmt.go:137`: `text = <string>` was lowered as an
  in-place `ITextStore` overwrite, contradicting the language reference's
  own rebind semantics (Ch3:191,345 — `text=<string>` assignment REBINDS
  the variable to a new handle, it does not mutate the existing one
  in-place). This silently truncated shared handles and miscompiled
  `clarusc` itself via every Go-lane harness build — not a new bug, a
  pre-existing one the multi-segment boot happened to expose. Fixed via
  `coerceStr`/`ITextOfStr` (commit `b57ef5b`, snapshot re-bless
  `8103f5b`); pinned by `testdata/run/arc_text_realias.cla` (both lanes,
  `live=0`); the Task 15 workaround (forced string-concat copy) was
  removed once the real fix landed. This is a change to `internal/`, the
  FROZEN Go-compiler reference — CLAUDE.md is explicit that only clarusc
  gets new behavior. Precedent: the `go-xhh-escape` named exception. It is
  landed on this branch (revert path: revert `b57ef5b`'s `internal/` hunk
  + restore the Task 15 workaround) but **not yet ratified by Andrew** —
  flagged loudly here per the branch's own convention for FREEZE
  exceptions. Known side effects: the Go lane leaks text handles on this
  path (always did, unmeasured before); `t = "x"` on a `str`/`text`
  parameter no longer mutates the caller's binding on the Go lane (this
  now MATCHES clarusc/the reference spec, which is the point).

  **The lasterr storage inversion (12.5) — recorded plan-defect
  adjudication.** The 5c′-derived assumption that `lasterr` storage could
  stay entirely platform-owned (C globals) turned out wrong for native:
  Task 3's original fix-up (Clarus-side sync writes) was a workaround for
  a problem the plan mis-scoped. Adjudicated mid-flight (5b precedent):
  `lasterr` STORAGE stays behind the waist, platform-owned; Clarus WRITES
  via a `CoreSetLastErr` extern; Clarus READS via a per-backend intrinsic
  arm (cprint: the pre-existing C globals; cg68k: `nat*` functions over
  `native.cla`'s own state). This deleted the Task 3 file-I/O sync
  fixups outright rather than patching them further. Also restored
  `TestTextwidgetsUIScenario` (attributed to a Task 3 regression in
  `rt_ui.c`'s event-loop TE-clamp write path, not a pre-existing failure —
  see below).

  **Hard-won lessons:**
  - **JT entry +2, not +0 (Task 15 crash root cause).** A classic 8-byte
    jump-table entry's first word is DATA (segment number or an offset) in
    BOTH its unloaded and loaded forms; its CODE starts at +2
    (`MOVE.W #segnum,-(SP)` / `JMP xxx.L`). Cross-segment `JSR d16(A5)`
    must target the entry's own code point at +2. Targeting +0 produces an
    "illegal instruction"/"coprocessor not installed" crash on the very
    first `_LoadSeg`-triggered cross-segment call, with no explanation from
    caller framing or callee complexity — found via a 4-way isolated repro
    table and Inside Macintosh's own Segment Manager chapter, fixed as a
    one-term change plus a structural regression guard (`ab63cb2`).
  - **The Segment Loader / LoadSeg contract** de-risked by forced-
    multi-segment boots below the real 32,760-byte budget
    (`TestNativeSmokeForcedMultiSegment`, `--seglimit`, undocumented
    test-only flag): proving cross-segment `JSR`-through-the-JT and
    `_LoadSeg` work on real hardware with a small, fast, known-good
    fixture BEFORE staking the whole suite app on it (15-segment forced
    split, green) was what let Task 16 proceed with confidence once the
    JT+2 fix landed.
  - **Silent-zero hardening found real bugs.** Task 14.7 hardened
    `cgExpr`'s non-scalar arms and `cgIntr`'s catch-all from silently
    emitting `move.l #0` placeholders to log+quit — this immediately
    surfaced two previously-invisible bugs: `fix_mul`/`fix_div` were never
    implemented (silently returned 0), and `needsHidden` was computed from
    result SIZE instead of result KIND, so a `string`-typed return ≤4 bytes
    silently skipped the hidden-pointer convention every caller assumed
    and came back empty. Both fixed; the lesson generalizes — a
    catch-all default that produces a plausible-looking wrong value is
    strictly worse than one that stops the build.
  - **The A0/A1 walk-protection saga (Task 11 → Task 12 fix rounds).**
    `cgIntrPoke`'s `poke(dst, peek(src))` clobbered A0 mid-sequence (Task
    11's boot-blocking bug, alongside the app68k JT-entry+4 offset error —
    both fixed together to get the very first hardware boot green). Task
    12's record-walk codegen had the same class of bug twice more: an
    "A0-drift" issue in nested-call KRec/KStr arguments (fix round 1), then
    a NEW bug in that fix's own mechanism — an A1 stash clobbered across a
    `JSR` into nested `cg_retain_`/`cg_release_` calls (fix round 2,
    proven empirically, 3 call sites bracketed). Recurring theme: any
    codegen path that stashes a scratch register across a call to
    emitted-not-inlined runtime code must treat that call as a full
    scratch-register clobber, not just a data clobber.

  - **Task 16 itself found four real native-only correctness bugs, all
    invisible to every fixture booted before the suite app** (the suite is
    the first program to exercise: a read-before-write local scalar, a
    global text initialized from a string literal, an array-of-record
    element store, and a `char[]` buffer round-tripped through
    `toBytes`/`fromBytes` alongside direct indexing):
    1. **Local default-init only ever covered five container-ish
       kinds.** `cgEmitFunc`'s per-local default-init gate (built up
       reactively across Tasks 12/13/14.7, each widening it by exactly one
       more kind as a crash was found) stayed scoped to
       `KRec/KText/KList/KMap/KErr` — every OTHER kind (every scalar, and
       critically every fixed ARRAY) got NO default-init at all, contrary
       to `cprint.cla`'s own `cpEmitFunc`, which calls `cpDefaultInit`
       UNCONDITIONALLY for every local, all kinds. `cgDefaultInitAt`
       already handled every kind correctly (including `KArr` via the
       already-written `cgArrDefaultAt`) — it just was never called. Fixed
       by dropping the kind restriction entirely (every local, no gate).
       Found via `emit_array.cla`'s own "int/char array zero-init" checks
       reading stack garbage; a same-shape bare-scalar probe confirmed
       this was general, not array-specific — almost certainly the actual
       root cause of a since-resolved 15-minute `TestSuiteOn68k` hang too
       (garbage feeding a loop bound/index is exactly the class Task 13's
       own container-ARC section had already reproduced once as an
       emulator hang, not a clean crash).
    2. **A `text` global initialized from a string literal was a literal
       `TODO ... unsupported this task` stub** (`cgEmitGlobalInitExpr`,
       left over from Task 12) — the global stayed permanently empty.
       Fixed by filling the already-birthed handle via `rtTextStore`
       (mirrors `cgIntrTextOfStr`'s own shape). Found via
       `emit_record.cla`'s "text global from string literal" check and
       `arc_global_alias.cla`'s `gaT1`/`textassignGt` globals.
    3. **Assigning into a fixed-array element of record type was
       silently a no-op.** `cgStmt`'s `SAssign` dispatcher routed
       `KRec`-typed destinations to `cgEmitStoreRec` only for
       `EVarRef`/`EFieldRef`, never `EIndexRef` — `h.items[0] =
       makeArrItem(...)` fell through to the generic "TODO SAssign"
       stub and never executed. `cgEmitStoreRec` was already fully
       dst-kind-agnostic (every arm routes through the already-general
       `cgExprAddr`) — the restriction was never a real requirement, just
       the scope Task 12 originally built it for. Found via
       `arc_fixwave_arrays.cla`'s `holder-store`/`standalone-store`
       checks (an `Item[3]` array-of-record element store).
    4. **`toBytes`/`fromBytes` assume a tight `char[N]` buffer; cg68k's
       own arrays are 2-byte-padded per element (deliberate, documented
       LAYOUT AUTHORITY design).** Calling `rtStrToBytes`/`rtTextToBytes`/
       etc directly against a native `char[]` local's own padded address
       silently touched only every OTHER element (`"ABCDEFGH"` written as
       `"A_C_E_G_"`). A `toBytes`-then-`fromBytes` round trip through the
       SAME buffer, with no direct `buf[i]` indexing in between, happened
       to keep working anyway (both ends agreed on the same wrong tight
       assumption) — only `strings.cla`'s `buf[3] = 'z'` (mixing an
       indexed write in between) exposed it. Fixed by adapting through a
       fresh tight scratch buffer at the four `cgIntrStr/TextToBytes/
       FromBytes` call sites (`cgFillTightScratchFromPaddedArr`/
       `cgDrainTightScratchToPaddedArr`) rather than changing the array
       layout itself — a narrower, lower-risk seam than reopening the
       padding decision.

  **5e-input inventory** (deferred UI-runtime work, feeding 5e's design):
  UI intrinsics (window/menu/dialog Toolbox traps — no reg-trap coverage
  yet, 5d's trap-clause work only covered non-UI traps), `fpUiEditStmt`'s
  two arms still routing through cprint-only C (`kind==2`→`rt_list_at`,
  `kind==3`→`rt_map_get_dv`, carried unresolved from 5c′), uisnaps-from-
  native (the 23 UI scenario goldens are all Retro68/gcc-O2-built today;
  native has no UI runtime at all yet), pascal-trap byte-order
  verification for bool/char stack arguments (Task 9's own note: the
  LOW-byte placement claim rests on secondary sources, unexercised by any
  5d trap — 5e's first real pascal trap with byte args must verify against
  uisnaps), and the **discarded handle-returning call statement leak**
  (final-review ledger T13: a bare `makeStr();`-shaped `ECallFn` result
  discarded as a statement is never released natively — the bare
  `lst.pop();` discard IS handled via the existing tracked-temp machinery,
  only the discarded-call-result shape leaks; leak-not-corruption, harmless
  in 5d's run-once apps, becomes real in 5e's event loops against a 384KB
  heap — fix by routing it through the same `cgNewTrackedTmp` path the
  pop/shift discard shape already uses, before any long-running native
  app ships).

  **Known gap (final-review C1, fixed fail-closed, not fixed for real):**
  whole-fixed-array assignment (`b = a` / `r.field = arrVar` for `arr N of
  T`) has no native codegen — `cgStmt`'s `SAssign` catch-all now log+quits
  with a named error instead of silently no-op'ing the store (the prior
  behavior was a silent host/native miscompile of Ch3's copy-by-value
  semantics). Real fix is a `cgExprAddr`+block-copy codegen arm, a 5e item;
  no corpus file exercises the shape today.

  **Full gated `internal/mactest` suite** (`CLARUS_MAC_TESTS=1 go test
  ./internal/mactest -timeout 60m` — every Retro68 test AND every native
  test in one run): 40 top-level tests (56 counting subtests), 0
  failures, 226.933s wall-clock — the Retro68 gate (suite/runerr/abort +
  23 UI scenarios, `TestTextwidgetsUIScenario` included and green, the
  12.5 regression fix confirmed still holding) plus this task's 9 native
  boots, all in one green run.

  Full task-by-task detail:
  `.superpowers/sdd/2026-07-30-native-5d-codegen68k/task-{1..16}-report.md`
  (progress ledger: same directory's `progress.md`); design:
  `docs/superpowers/specs/2026-07-30-native-5d-codegen68k-design.md`
  ("Outcomes" section); plan:
  `docs/superpowers/plans/2026-07-30-native-5d-codegen68k.md`.

- **5e (UI runtime port, landed on branch `native-5e`, 2026-08-03): DONE.**
  `runtime/mac/rt_ui.c` (5,723 lines, ~169 Toolbox routines) ported to
  Clarus — `runtime/clarus/{ui,uiwidgets,uitable,uidialogs}.cla` — so that
  UI apps build and run entirely through `clarusc emit68k`, no C, no
  cmake, no Retro68. **All 23 `testdata/ui` scenarios are byte-identical
  (trace + PBM snaps) against the SAME frozen goldens the Retro68/gcc
  lane already used** — one golden set, no per-backend re-bless, exactly
  the ratified end gate. `rt_ui.c` + `uiprobe` stay in-tree, frozen, out
  of the app-build path — the port's oracle until 5f's Retro68
  retirement, per the spec's own decision 5.

  **Staging as executed.** The spec's per-family two-lane plan (Retro68
  redirect proven first, native flip once all 23 goldens are green ported)
  held, but the redirect mechanism itself was a plan-time adjudication, not
  the spec's original per-family framing: the UI runtime is one
  interconnected event loop (shared `winst`/`gModal` state), so a
  half-ported/half-C split couldn't be per-family — a temporary
  `clarusc emit --uiport` flag flipped the WHOLE ported runtime in per
  SCENARIO as each scenario's own widget surface landed (Tasks 7-10 moved
  scenarios into the ported set slice by slice: 8 first, 9 more, 21, then
  the last 2 blocked on a real hang — see below), with the flag and every
  legacy `rt_ui_*_desc` emission arm deleted outright once all 23 were
  green ported (Task 11, "the flip"). Native bring-up (Tasks 12-14) was
  the single late stage the spec called for, not interleaved — the native
  lane links only Clarus code, so a partial UI runtime cannot run there at
  all.

  **The record ABI is lane-specific — the branch's biggest lesson, found
  twice.** The UI descriptor blob's `Layout` section (record size +
  per-field byte offsets — the numbers `rtUiFormFill`/`rtUiFormAccept`/
  `rtUiTableDrawField` peek and poke a record through) cannot use one
  layout rule for both backends: the cprint lane's real record shape is
  the emitted C struct (`bool`/`char` fields are a full 4-byte
  `int32_t`/`uint8_t`-but-4-byte-aligned slot, matching m68k GCC's own
  16-bit `BIGGEST_ALIGNMENT`), while cg68k's own naive record layout gives
  `bool`/`char` a 2-byte slot everywhere. **Task 10** hit this first, on
  the cprint/ported lane: `uibEmitLayout` had sourced the blob from
  cg68k's rules even though nothing native existed yet, so a 2-record-with-
  a-bool form (`formedit`/`bookmarks`) overran its scratch Handle by 2
  bytes on every accept, corrupting the Memory Manager's free list just
  enough that the NEXT `DisposeWindow` call spun forever — a real-hardware
  hang with zero captured output, bisected over five ruled-out hypotheses
  before the actual root cause (a `recSize` off-by-2, 330 vs. the real 332)
  was found. Fixed by giving cprint its own C-ABI layout authority
  (`cpCRecordSize`/`cpCFieldOffset` in `cprint.cla`) plus a compile-time
  `clar_ui_layoutassert_<R>` guard so a future divergence is a build
  error, not a silent corruption. **Task 14** hit the SAME class a second
  time, natively: `cgRecordSize`/`cgFieldOffset` (cg68k's own layout
  authority, which the blob's native lane correctly sourced from per
  Task 12's carry) gave a record's `bool`/`char` FIELD the same 2-byte
  slot a bare local/param gets, but the shared runtime's `bool`-field read
  is a hardcoded 4-byte `peekl` (matching the serialization/cprint
  convention) — `popuptable`'s `favorite: bool` column showed every row
  checked, a 4-byte overread into the next field. Fixed by splitting
  record-field sizing from local/param/array sizing (`cgRecFieldSizeOf`/
  `cgRecFieldAlignOf`, used only inside `cgFieldOffset`/`cgRecordSize`/
  `cgRecordCtorAt`/`cgEmitOneRcWalk`) so a record's `bool`/`char` field
  gets the full 4-byte slot the shared runtime already assumes, without
  touching a bare local/param's 2-byte sizing anywhere else. The ruling
  (recorded in the ledger, carried into both fixes): record-field ABI is
  decided per lane, deliberately, never inherited by copy-paste from the
  other lane's own authority.

  **The pascal byte-arg placement question is settled, and the 5d-era
  guess was wrong.** 5d's own doubt (no byte-arg pascal trap existed yet
  to test against) guessed a `bool`/`char` pascal parameter's value sits in
  the padded word's LOW byte. The first real byte-arg trap this branch
  exercised (`NewWindow`'s `goAwayFlag`, `smoke_bounce`'s native boot)
  proved the opposite empirically, via A/B `log()` instrumentation
  comparing the native lane against the ported/gcc lane over the same
  shared `ui.cla` source: the ROM trap dispatcher reads the value back as a
  single byte at the padded word's OWN (lowest) address, which in 68k
  big-endian layout is that word's HIGH-order byte. The mirror-image bug
  (a Boolean pascal RESULT read from the wrong half after popping) was
  found and fixed a task later (`winvar`'s snap: a correctly-traced click
  that never repainted, because `UiGetNextEvent`'s own "no event" read was
  wrong). Both fixed in `cgCallExtPascal` (`LSL.W #8` before an arg push,
  `LSR.L #8` instead of `AND.L #255` after a result pop); the language
  reference's Trap and Inline Clauses section now states this as
  normative, replacing the superseded low-byte text (Task 15). A THIRD
  instance of the identical byte-position bug (`cgEmitLdefGlue`'s
  hand-rolled inbound `lSelect` read) was found by code review, not a live
  boot — it predated the fix and was never routed through the general
  `cgCallExtPascal` path this fix covers, a reminder that a convention
  fixed in one place doesn't retroactively fix every hand-rolled call site
  that duplicates it.

  **The JT/glue-address mechanism.** Three real Toolbox→Clarus callback
  seams (the ListManager LDEF, control action procs, AppleEvent handlers)
  all need a `pascal`-convention entry point the ROM can call. cprint kept
  small C `pascal` wrapper functions in the mac shim (gcc implements the
  convention for free); cg68k instead synthesizes two empty-bodied IRFuncs
  (`clar_ui_glue_ldef`/`clar_ui_glue_action`) that get a real jump-table
  slot for free from the existing JT-assignment pass, then hand-emits their
  bodies (`cgEmitLdefGlue`/`cgEmitActionGlue`): LINK, read the pascal args
  at their own fixed positive-A6 offsets, re-push in Clarus's own
  convention, JSR the real ported function, UNLK, pop the return address,
  ADDA the caller's own pushed arg bytes (the 68000 has no RTD — the
  callee must clean up by hand), JMP back. The glue's own call-site address
  (what `UiLdefEntry()`/`UiActionEntry()` return to the Toolbox) is the JT
  ENTRY's address (`LEA 32+8*slot+2(A5),A0` — segment-safe from any
  segment, the classic Mac idiom), not a raw code label — cg68k has no
  data-relocation mechanism and needed none once this route was chosen.
  AppleEvent handler glue (×4) was never built: no `external func
  UiAeEntry` exists anywhere in the ported source — AE wiring stayed
  hardcoded C in `rt_ext_mac.inc` on the cprint lane, so there was nothing
  to wire on the native lane either; real native AE dispatch remains
  untested (see Honest limits).

  **The List Manager selector-trap discovery.** Package Manager routines
  like the entire List Manager family (`LNew`/`LAddRow`/`LSetSelect`/…)
  share ONE trap word (`0xA9E7`) distinguished only by a selector WORD the
  real Toolbox glue pushes immediately before the trap — a shape the
  5d-era trap-clause grammar had no way to express at all. `popuptable`'s
  native boot crashed with "illegal instruction" before any window ever
  drew, because every List Manager extern read whatever garbage happened
  to be on the stack as its selector. Fixed with a new grammar clause,
  `= trap NNNN sel SELECTOR` (mutually exclusive with `reg`, since a
  selector-dispatch trap is always Pascal-convention) — the selector is
  pushed as one more `.W` word, closest to the trap, after every declared
  argument; the trap dispatcher pops it along with the rest.

  **`SetApplLimit` stack reservation.** `smoke_menudemo`/`smoke_mandel`
  (the full acceptance examples, not the small `testdata/ui` fixtures) hung
  the emulator with a real "stack collision with heap" system error once
  the earlier bugs above were fixed — `cgEmitStartup` called
  `_MaxApplZone` with no preceding `_SetApplLimit`, so the heap zone grew
  right up to wherever the stack pointer happened to sit at boot, leaving
  zero room for the stack to grow into during a real scripted event's deep
  call chain (naive per-function LINK frames, no peephole/regalloc yet, so
  a single `str` temp alone costs 256 bytes and a menu dispatch stacks
  several such frames). Fixed by reading the current `ApplLimit`
  (`GetApplLimit`, a low-memory-global read, the same "inline glue reads a
  global" mechanism `MemError`'s own `$0220` uses), lowering it by a fixed
  32KB reserve via a real `SetApplLimit` trap, before `MaxApplZone`.

  **Honest limits.** (1) The Mini vMac ROM's `Gestalt` trap dispatch never
  reaches a real Gestalt implementation on this emulator — `err`/D0 comes
  back a clean 0/noErr but `resp` is heap garbage, which without a guard
  misread as a plausible System-7 version and selected the wrong window
  WDEF for modal forms; `rtUiStartup` bounds `resp` to a plausible BCD
  system-version range before trusting it (strictly safe for the cprint
  lane too, whose real Gestalt result is always correct either way) — a
  workaround for this ROM/emulator, not a language or codegen limit.
  (2) Real-hardware-untested: LM selector-trap dispatch and the Gestalt
  bound above are proven only on Mini vMac, never a real 68k Mac; AppleEvent
  handler glue was never built (nothing to wire, see above), so native AE
  launch/open-document dispatch is untested by any golden; Scrap Manager
  (`TEFromScrap`/`TEToScrap`) and real `SFGetFile`/`SFPutFile` are clean
  fail-closed/false-returning stubs on the native lane (`uitext.cla`/
  `uidialogs.cla`) — every scripted scenario's `askOpen`/`askSave`/copy-
  paste path uses the already-ported test-mode substitute instead, so
  neither the real StandardFile Package-dispatch trap nor real Scrap
  round-tripping has ever run natively. (3) rc-leak parity remains
  structural, not measured, same limit 5d recorded — the host leak ledger
  cannot run on the Mac; the mirror-of-cprint discipline is the guarantee.
  (4) Purgeable resource attribute bits are still not reproduced in
  `app68k`'s resource-fork writer (carried from 5d's resource-parity work,
  correctness-neutral, ~1.5KB non-purgeable on a 384KB heap). (5) Full
  minors list (13 items found and adjudicated across Tasks 1-14, most
  deferred as pre-existing/out-of-scope/code-behavior — 4 cheap doc/comment
  ones fixed in Task 15, the rest left for final review triage): see
  `.superpowers/sdd/2026-08-01-native-5e-ui-runtime/progress.md`.

  **Gate numbers.** Full gated `internal/mactest` suite
  (`CLARUS_MAC_TESTS=1 go test ./internal/mactest -timeout 60m`, every
  Retro68 test AND every native test in one run): **777.6s wall-clock, 0
  FAIL** — 23/23 UI scenarios on BOTH lanes, `smoke_bounce`/`about`/
  `texteditor_bigfile`/suite/runerr/abort on native, resource parity, one
  run, no flags. Per-scenario native timing (build = `clarusc emit68k`
  wall time, ~0.3s constant after the first scenario in a process; boot =
  `RunMac` wall time, LaunchAPPL + Mini vMac + full scripted run) ranged
  3.47s (`buttons`, few-widget) to 43.45s (`textwidgets`, 32,000-byte
  textview clamp-boundary string work) — `bookmarks` (file I/O + table +
  form, 17.16s) and `formedit` (modal form + validation, 13.51s) were the
  next-heaviest. This is naive-codegen's own lower bound with zero
  peephole/regalloc — the same "buy-back baseline" framing 5d recorded,
  now with a real per-scenario UI table to buy back against (full table:
  `.superpowers/sdd/2026-08-01-native-5e-ui-runtime/task-14-report.md`).
  `go test ./... -timeout 30m`: green throughout, including
  `internal/selfhost`'s bootstrap/fixed-point/differential-fence suite,
  `internal/cg68k`'s golden/vasm/determinism suite (extended to every
  emitted CODE segment, not just segment 1, during review), and
  `internal/emitui`'s golden suite.

  **5f-input inventory** (deferred work feeding 5f — Retro68
  retirement/self-host, per the spec's own non-goals): `rt_ui.c` +
  `uiprobe` deletion (frozen, in-tree, out of the build path since Task 11
  — 5f's Retro68-retirement business, not 5e's); Mac-resident `clarusc`
  (no native-hosted compiler yet — this branch only ever cross-compiles
  from the host); the compilation cache (parked since 5d, still parked);
  the peephole/regalloc buy-back phase, now with a full 23-scenario native
  timing baseline (task-14-report.md) to measure against instead of a
  single suite number; the honest limits above (Scrap/SF real dispatch,
  AE handler glue, real-hardware LM/Gestalt verification) as candidate
  follow-up work, not blocking anything already gated.

  Full task-by-task detail:
  `.superpowers/sdd/2026-08-01-native-5e-ui-runtime/task-{1..15}-report.md`
  (progress ledger: same directory's `progress.md`); design:
  `docs/superpowers/specs/2026-08-01-native-5e-ui-runtime-design.md`
  ("Outcomes" section); plan:
  `docs/superpowers/plans/2026-08-01-native-5e-ui-runtime.md`.

- **Real-event-loop trap-convention fixes (main, `5faaa6c`, 2026-08-03):**
  the first real (non-`--events`) native boots exposed two `ui.cla` extern
  declarations with the wrong calling convention — `UiTickCount` declared
  `reg` (stale D0; `every` blocks never fired on a real boot) and
  `UiMenuKey(ch: char)` (high-byte pascal push where MenuKey's ABI is
  CharParameter, a low-byte numeric word; cmd-key shortcuts never matched).
  Invisible to all 23 scripted goldens by construction: the scripted lane
  runs on `gVirtualTicks` and script-engine menu verbs, so neither trap
  ever executes under `--events`. Regression pin:
  `testdata/cg68k/tickprobe.cla` + `TestRealEventLoopTickOn68k`
  (`internal/mactest`) — the only test in either lane on `rtUiRun`'s real
  WaitNextEvent/`rtUiEveryPump` path; its `every` block counts 60 real
  ticks and quits, so timeout IS the failure signal (verified failing
  under the re-introduced bug). **Standing lesson for the test-review
  phase below: scripted-golden green says nothing about real-mode trap
  conventions — an extern clause is only proven by a lane that actually
  executes it.**

- **Decided sequencing 2026-08-03 (discussion with Andrew): three phases
  land BEFORE 5f (Mac-resident clarusc / Retro68 retirement).** Agreed end
  state motivating the middle phase: a Clarus programmer opens Inside
  Macintosh, writes one `external func` declaration from the IM page +
  trap table, and calls it as ordinary Clarus code — no hand-written
  wrapper layer required. The mechanism already covers the large
  plain-pascal-trap + `sel`-package subset (proved in USER code: the
  TickProbe session declared `= trap 0xA975` itself and it ran); the
  remaining gaps and their fixes were ranked in the 2026-08-03 discussion.
  Order:

  1. **Test-suite review/velocity phase (FIRST, explicitly before any
     feature work — Andrew's call):** review and improve the test suite so
     the feature phases can move fast. Own brainstorm/spec to come. Standing
     inputs: the full `go test ./...` gauntlet's wall-clock (selfhost
     ~250-590s/run; gated mactest 777.6s for the full double-lane run —
     both paid repeatedly per task under SDD); the `5faaa6c` lesson above
     (where else does coverage LOOK green while exercising nothing? — the
     real-event-loop path went 23-for-23 green with dead timers); and the
     Go-test-cache staleness gotcha (`.cla` runtime files are invisible to
     the cache key — a cached mactest PASS proved nothing until
     `-count=1`).
  2. **Toolbox integration phase** — the three features, each landing
     reference-first then clarusc + cg68k with a native gate:
     (a) **named-register trap clause** (e.g. `= trap 0xA1AD reg(d0:
     selector, a1: response) ret d0`) — replaces the positional
     A0/A1+D0/D1 rule's hard 2+2 limit for quirky OS traps and retires the
     `cgCallExtGestalt` by-name special case (cg68k.cla:7068);
     (b) **`extern record`** with Mac 68k packed layout (2-byte-aligned,
     1-byte Booleans — deliberately NOT the unified Clarus record ABI's
     4-byte bool/char slots) so IM struct definitions transcribe
     field-for-field and trap calls take `ptr`-to-record instead of
     hand-computed peek/poke offsets (the EventRecord/SFReply idiom
     today, and where this session's offset bugs lived);
     (c) **callback declarations** (a `pascal func`/`callback` form whose
     address can be taken) — generalizes the hand-rolled LDEF/action-proc
     glue (`cgEmitLdefGlue`) into user-facing surface, unlocking the
     ProcPtr territory of IM (ModalDialog filters, TrackControl action
     procs, SF dlgHooks, defprocs). Interrupt-time completion routines
     stay an explicit non-goal (A5/allocation restrictions the language
     cannot make safe).
  3. **Docs cookbook (AFTER the features land — Andrew's call):** Ch13
     gains the IM→Clarus mapping table (CHAR→`word` CharParameter,
     Boolean→`bool`, Point-by-value→packed `int` or the new extern-record
     story, VAR→`ptr`, Str255→`str`, plus the trap-table reading guide)
     and worked IM examples. A curated `toolbox/` extern catalog (per-IM-
     manager `.cla` declaration files shipping with the compiler) is the
     candidate follow-on — it needs the extern-dedup story
     (`irRegisterExtern` currently rejects duplicate names outright)
     decided in this phase.

  **The native Standard File (_Pack3) port is DEFERRED until after the
  Toolbox phase** (Andrew, 2026-08-03; spec already committed at
  `docs/superpowers/specs/2026-08-03-native-standardfile-pack3-design.md`,
  `f3546bb`). It stands to benefit directly: SFReply becomes an `extern
  record` instead of a 74-byte peek-offset scratch, and a dlgHook becomes
  expressible if callbacks land first. The spec is written against
  today's surface; revise at implementation time if the new features
  offer a cleaner shape. Then **5f** (Mac-resident clarusc, Retro68
  retirement, compilation cache, peephole/regalloc buy-back — inventory
  in the 5e entry above).

## Small open items (not yet scheduled)

- `clarus run prog.cla -- args…` pass-through: DONE (clarus-run-dashdash).
- **Lexer diagnostic quality (FOLLOW-UP, deferred — decided 2026-07-23):** a
  bad escape inside a double-quoted string (e.g. `"a\qb"`) should report
  `invalid escape sequence`, NOT `unterminated string literal` — the literal
  is well-formed, only the escape is wrong. AND it should not cascade a second
  spurious `unterminated string literal` from the eager `lexAll` scanning past
  the error to EOF (Go's lazy lexer stops once the parser fail-fast aborts;
  clarusc's eager lexer does not). Fixing the message is small; fixing the
  cascade is architectural (lazy/on-demand lexing, or truncate lexer diags
  after the first at an offset). Land BOTH together with a triggering fixture,
  since adding the fixture before the fix turns the differential red. Both
  compilers currently agree via `'\q'` (char literal); the double-quoted-string
  shape is corpus-untriggered. See internal/selfhost/inventory.md.
- `text + char` concatenation does not exist (append accepts char; `+` does
  not). Deliberate for now; revisit if it keeps surprising. (`char + string`
  and `string + text` WERE added 2026-07-23 — see the reference Ch4.)
- **Widget-property out-param fill-in-place gap (found during mac-target-4c
  final review):** the reference's own Appendix C Text Editor calls
  `file.readText(p, d.Body.text)` — a widget property passed directly as a
  fill-in-place out-parameter. clarusc's lowering compiles this without
  error, but the read materializes into a discarded temporary (a widget
  property read is a fresh copy, not a real binding to the underlying TE
  buffer) rather than filling `d.Body.text` itself. `examples/texteditor.cla`
  (the shipped acceptance app) works around this with a local `var t: text`
  read then a separate `d.Body.text = t` assignment. Proper fix — a loud
  compile-time error for this shape, or a real fill-in-place binding for
  widget properties — is 4d's binding-walker work.
- **Two clarusc gaps found during window-zoom-hscroll: DONE** — fixed on
  branch `clarusc-ui-gaps` (2026-07-26): (1) widget-set Str→Text coercion
  (`Body.text = "lit"` now compiles); (2) handle-backed window-var
  construction (window `var t: text` no longer NULL-crashes at runtime). The
  shipped scenario workarounds in `testdata/ui/hscroll.cla` and
  `testdata/ui/dialogs.cla` were unwound to exercise the fixed shapes
  directly.
- **ARC milestone: DONE** — see Done item 11. All `.leaks` goldens at zero
  (files deleted); the 4e escape-analysis apparatus deleted.
- **Retain/release elision (conditional follow-on, not triggered):** the
  ARC design's own non-goal was naive ARC first, elision only if the 68k
  measurement demanded it. Measured (Done item 11): Bookmarks +0.12s
  (~1.3%), Text Editor no measurable change, both within run-to-run noise
  and neither subjectively perceptible on the emulator. Trigger not met —
  no elision work scheduled. Revisit if a future, more refcount-traffic-
  heavy acceptance app (or real hardware, not Mini vMac) shows real
  degradation.
- **`form for` handle-backed-record checker gap: resolved (clarusc
  enforces).** Found during ARC Task 9 close-out: the language reference
  (`docs/clarus-language-reference.md`: "`form for T` requires every field
  of `T` to be a by-value type... the same build-time error... as
  `file.save`/`file.load`") documents a compile-time error that the
  checker (`internal/check/`) does not actually enforce for `form for` — a
  record with a `text`/`list`/`map` field compiled without a checker
  diagnostic where the reference says it shouldn't. The restriction dates
  to 4d (`ea50f13`), predates ARC, and is not an ARC regression. Fixed in
  the ARC fix-wave (Task 3, Important 7) on the `clarusc`-only side:
  `clarusc/check.cla`'s `checkWindowDecl` now walks a resolved `form for`
  record's fields (recursing into nested records/arrays) and rejects a
  handle-backed field with its own diagnostic, at check time, before
  lowering. `internal/check/` (the frozen Go compiler) is intentionally
  left as-is — clarusc-only is project-normal for new-since-ARC checker
  work, per `CLAUDE.md`. (`clarusc/lower.cla` already had a shallower,
  one-level, `lowUnsupported`-driven fallback for this shape via
  `lowCheckSerializableFields`, shared with `file.save`/`file.load`/table
  rows; the new checker diagnostic now fires first, with a proper message
  and location, for any program that reaches it — the lowering fallback
  still catches whatever the checker doesn't, e.g. this exact shape when
  reached from `internal/`.)
- **Discard-tracking generality (found during ARC Tasks 8-9):** only
  `pop`/`shift` (`clarusc/cprint.cla`'s `fpDiscardExprIdx`) consult the
  machinery that releases a transfer-convention intrinsic's result when
  its enclosing statement discards it. Every other container/call result
  uses the +1-retain convention, which the ordinary statement-temp
  tracker already releases-when-discarded for free — so pop/shift are
  the only known transfer-convention intrinsics today, and the residual
  class is narrow. If a future intrinsic is added with transfer (not +1)
  semantics, it needs the same explicit wiring; nothing currently audits
  for that automatically.
- **Parameter-escape-summary precision upgrade (optional, follow-on to 4e,
  not yet scheduled):** per-function parameter-escape summaries (whole-
  program compilation, no indirect calls, so a cheap fixpoint) to shrink
  the "passed to a user function" escape bucket that clarusc's Task 5/7
  conservative pre-pass currently treats as leak-by-design wholesale. Only
  worth doing if the `.leaks` goldens prove noisy in practice.
- Parking lot (deferred features, from the design spec §14 + later
  decisions): HTTP layer, UDP/DDP, auto-generated forms, float/SANE,
  case-insensitive maps, handle-backed map values, printing, color QuickDraw,
  labeled break, const arithmetic, `switch` on text, substring/indexOf as
  library code conventions for clarusc.
- **S7 native popup CDEF (parked 2026-07-28):** `rt_ui.c` has dormant
  scaffolding behind `RTUI_POPUP_CDEF` (0); enabling requires clarusc/
  build-mac.sh to emit real per-popup `'MENU'` resources (enum labels are
  compile-time constants) so the CDEF's `initCntl` `GetMenu` succeeds;
  private-data poke alone verified non-functional on 7.1.
- **Popup label-lane latent bug (found alongside mac-target-4d Task 9's
  field fix, not itself fixed):** `rt_ui_popup_box` and the popup draw
  branch (`rt_ui.c`) still use the raw, unclamped `RTUI_FIELD_LABEL_W`; a
  `popup` with a `label:` and a declared `width:` under ~90px would
  reproduce the exact zero-width, unclickable-box collision the field fix
  resolved. No current fixture declares one. Fix belongs in `rt_ui_layout`'s
  width computation for labeled popups: mirror the labeled-field branch there
  (the one that replaced the constant `RTUI_FIELD_LABEL_W` lane) instead of
  the raw constant `rt_ui_popup_box` currently applies; field-clamp helper
  was deleted.
- **Unreproduced live-input popup anomaly (mac-target-4d final validation):**
  the Protocol popup failed to open on repeat Edit Bookmark dialogs in ONE
  live session; 20+ deliberate repro attempts across System 6 and System 7
  failed, and the popup's menu-list bookkeeping was proven correct on the
  evidence available. Guarded by the `rt_ui_popup_assert_alive` menu-integrity
  tripwire, now wired into both scripted popup lanes — if that tripwire ever
  fires, the anomaly is real; investigate menu lifecycle across form reopen.
- **Modal form map-element writeback upserts (mac-target-4d final review):**
  `rt_ui.c`'s `RT_UI_WB_MAP` writeback case uses `rt_map_set` (upsert), so a
  key removed by a timer mid-edit is re-inserted on OK. Deliberate; the spec
  said drop-writeback on a vanished target — if upsert proves wrong in
  practice, the writeback descriptor carries what's needed to check-then-set
  instead.
- **Reference erratum candidate (mac-target-4d final review):** Appendix C's
  Bookmark Manager `Remove.click` calls `bookmarks.remove(Marks.selected)`
  without guarding `selected == -1` — a user clicking Remove with no
  selection panics the app. Since the example is normative and shipped
  verbatim, fix reference-side (guard in the appendix example) in a future
  docs pass rather than papering over it in the acceptance app.

## Process conventions that worked (for future sessions)

- Doc-first: reference updated and committed BEFORE implementation plans;
  the reference is the compiler's contract.
- Subagent-driven development with per-task review gates and a whole-branch
  final review (most capable model) + one consolidated fix wave; reviews
  probe (compile/run/ASan), not just read.
- Feature branches per plan; main stays green; reftest may be red mid-branch
  when the reference gains fences for unimplemented features (manifest
  regeneration is always the branch's final task).
- Golden outputs are hand-computed before running, then reconciled.
