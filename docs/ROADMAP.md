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
