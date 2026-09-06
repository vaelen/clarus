# Clarus History — completed work

This is the verbatim archive of completed (merged-to-main) entries moved
out of `docs/ROADMAP.md` (first move 2026-08-10, second move 2026-08-15),
newest-last within each move; `docs/ROADMAP.md` remains the authoritative
record of sequencing and strategy going forward, and `docs/TODO.md` holds
the condensed open follow-ups extracted from these entries.

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

## clarusc / self-hosting strategy (agreed in discussion, 2026-07-22)

**Superseded 2026-08-05 — the Go compiler is deleted (tag
`go-compiler-final`); see the Go-compiler-deletion Done entry below.**

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
  gets the full 4-byte slot the shared runtime already assumes (since
  narrowed to 1 byte — small-scalar-width phase, 2026-08-05), without
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

  **Honest limits.** (1) ~~The Mini vMac ROM's `Gestalt` trap dispatch never
  reaches a real Gestalt implementation on this emulator~~ — **DISPROVEN,
  pack3-standardfile Task 5a (2026-08-07).** The ROM's Gestalt works fine
  and answers `0x0607` for `'sysv'`; the garbage `resp` was OUR bug. The
  raw `_Gestalt` trap returns its response VALUE in **A0** (Gestalt.h's
  `TWOWORDINLINE(0xA1AD, 0x2288)`, whose second word is `MOVE.L A0,(A1)` —
  glue that stores it through the caller's pointer), and every Clarus
  transcription bound `a1: response` as an input the trap ignores and read
  `ret d0`, dropping A0 entirely. `*response` was therefore never written,
  so `resp` was whatever uninitialized `NewPtr` heap the slot held —
  `err`/D0 really was a clean noErr because the trap really did succeed.
  Fixed by declaring the trap twice, once per result register
  (`GestaltErr` `ret d0` / `GestaltValue` `ret a0`); the BCD range bound in
  `rtUiStartup` is kept as a cheap sanity guard rather than as
  compensation. See `docs/clarus-toolbox-cookbook.md` §4 and
  `.superpowers/sdd/2026-08-07-pack3-standardfile/task-5a-report.md`.
  (2) Real-hardware-untested: LM selector-trap dispatch and the Gestalt
  bound above are proven only on Mini vMac, never a real 68k Mac; AppleEvent
  handler glue was never built (nothing to wire, see above), so native AE
  launch/open-document dispatch is untested by any golden. Scrap: the
  real native TE↔desk-scrap bridge (`nat_UiTEFromScrap`/`nat_UiTEToScrap`,
  `uitext.cla:193-230`) landed in the toolbox-cookbook phase (`0f2534e`)
  and IS hardware-proven by the toolbox suite's `Catalog` case roundtrip
  (both lanes, T2); every scripted scenario's copy-paste path still uses
  the test-mode substitute, by design. (Real `SFGetFile`/`SFPutFile`
  were the same kind of stub in `uidialogs.cla` until the
  pack3-standardfile phase, 2026-08-07, replaced them with real `_Pack3`
  selector-dispatch transcriptions and live-drove them on the emulator —
  see that phase's DONE entry below; the scripted scenarios still take
  the test-mode substitute, by design.) (3) rc-leak parity remains
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

     **In scope (decided 2026-08-03, Andrew): Go-compiler retirement,
     demote-now-delete-deliberately.** The Go compiler's four remaining
     jobs and their replacements: (a) independent semantic anchor for the
     frozen subset (the bootstrap fixed point proves self-consistency,
     NOT correctness — the differential sweep is what catches drift) →
     replaced by committed behavior goldens over the corpus (drift becomes
     a reviewable git diff) PLUS a cross-generation differential against
     the committed C snapshot (the previous generation's compiler, in
     frozen bytes; honest caveat recorded: same lineage, so a
     pre-self-hosting bug common to both generations escapes it — the
     normative reference + goldens is the real truth anchor, and the
     cprint-vs-emit68k backend byte-compare already catches what a second
     frontend never could); (b) host-run oracle for the Mac gates
     (`BuildSuiteHost`/`runNativeHostCompare` build expectations via
     `build.Build` today) → snapshot-bootstrapped clarusc → cprint → cc,
     the exact pipeline `build-mac.sh` step 1 already uses; (c) bootstrap
     origin → already replaced by the committed C snapshot (nothing to
     do); (d) the `clarus check/build/run` CLI → a `clarusc run`
     subcommand or wrapper script (emit → cc → exec). THIS PHASE does the
     demote: oracle swap, golden conversion, snapshot-differential, and an
     env gate (`CLARUS_GO_DIFF=1`-style) so the Go lanes stop running in
     the default gauntlet. The Toolbox phase then soaks on the new
     machinery with Go parked as the parachute; **deletion (cmd/clarus +
     the Go frontend/IR/printer packages + the differential harness's Go
     half) is a deliberate commit at the END of the Toolbox phase** if the
     parachute went unused — before 5f, which wants a single-frontend
     world anyway (the Mac-resident compiler is clarusc; Go was never
     going to run there). NOT deletion targets, ever: `internal/build/rt`
     (the shared C runtime — the snapshot bootstrap and cprint lane need
     it forever) and `clarusc/clarusc.c` + its snapshot tests. Expected
     payoff: kills the per-task selfhost differential cost and the
     `ClaruscOnly` fence/corpus-fork complexity (which otherwise grows
     with every Toolbox-phase feature), and ends the freeze-exception
     ceremony (two named exceptions ratified to date). (Deletion executed
     2026-08-05, see the Go-compiler-deletion phase entry.)

  2. **Toolbox integration phase (branch `toolbox-integration`, 2026-08-04):
     DONE.** — the three features, each landing
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

     **Outcome:** all three features plus the cross-cutting extern-dedup
     rule landed, reference-first, each with a native gate against a real
     Toolbox trap/callback. (A) named-register trap clause: `reg(REG:
     param, ...)` binding + `ret REG`; the `word`-result sign-extension
     rule unified across both `reg` forms (a Ch13 correction — the prior
     text said `word` occupied a full register slot like `int`, which
     contradicted the one shipping call site); `cgCallExtGestalt` and its
     by-name dispatch hook (cg68k.cla:7068) deleted — `UiGestalt` now
     declares the clause directly. Extern dedup: identical-signature merge
     for both `external func` and `extern record`, the C-header model,
     unblocking user IM transcription over runtime-declared traps. (B)
     `extern record`: a Mac-packed-layout storage kind with ONE shared
     offset/size authority consumed by both backends (cg68k + cprint), a
     byte-array C emission on the C lane. (C) `callback func`: compiler-
     generated pascal-convention glue with tree-shake auto-rooting on
     address decay; the runtime's own `rtUiLdefDraw`/
     `rtUiScrollbarAction` migrated to it, and `cgEmitLdefGlue`,
     `cgEmitActionGlue`, their hand-listed `shakeAddRoot` calls, and the
     `UiLdefEntry`/`UiActionEntry` by-name specials are all deleted (zero
     grep hits left in `clarusc/`) — the generated glue verified
     instruction-identical to the deleted hand glue at the listing level,
     and the 23 frozen UI goldens (`testdata/uisnaps`) stayed
     byte-identical through the migration (zero diffs), the feature's own
     acceptance proof. Evidence at HEAD: `testsuite/toolbox` 7/7 both
     lanes (grew from test-suite-review's 5 cases: +`GestaltNamed`
     (Feature A's native gate), +`EventXRec` (Feature B's, a real
     `OSEventAvail` trap filling an `extern record EventRecord`,
     cross-checked byte-for-byte against manual `peek`)); `testsuite/core`
     41/41 (40 real + `SelfCheck`, up from 40 total pre-phase — Task 6
     added the `XRecFieldsRoundtrip` case); snapshot green, all 9 tasks'
     reviews closed clean. Spec:
     `docs/superpowers/specs/2026-08-04-toolbox-integration-design.md`
     (see its "Outcome (2026-08-04)" section); plan:
     `docs/superpowers/plans/2026-08-04-toolbox-integration.md`; ledger:
     `.superpowers/sdd/2026-08-04-toolbox-integration/progress.md`.

     **Filed during the phase, for later:**
     1. `runtime/clarus/ui.cla:263`'s `UiFlushEvents = trap 0xA032` is
        mis-declared pascal-convention for what bit 11 (clear) marks as
        an OS-dispatch/register trap — the same bug shape Task 6's review
        caught on `TbOSEventAvail`/`0xA030`. Latent hazard; fix
        deliberately deferred (out of this phase's scope — `UiFlushEvents`
        was not touched by any Toolbox-phase feature).
     2. The bit-11 trap-table reading rule, worth recording as cookbook-
        phase (item 3, below) input: `trap & 0x0800` — set means
        Toolbox/pascal convention, clear means OS/register convention.
     3. Hard-won lesson from Task 6: Mini vMac does not model 68000
        address errors. A native-gate PASS does not prove alignment
        correctness — goldens must be eyeballed for odd `.W`/`.L` bases
        (the packed byte-array-of-bool/char shape that motivated
        `cgSlotSizeOf`'s even-rounding fix).

  2b. **Character/byte-type surface review (Andrew, 2026-08-04: AFTER
     Go-compiler deletion, BEFORE the Docs cookbook): DONE (2026-08-05,
     small-scalar-width phase).** Revisit `byte`,
     `char`, `bool`, and `text` as a set. Context: the Toolbox
     integration spec adds `byte` as an extern-record field-type name
     (1-byte unsigned, reads/writes as `int` — the 8-bit sibling of the
     `word` boundary type) rather than reusing `char`, because `char` is
     a character type (numeric flag fields would need `int(...)`
     ceremony) and `char` already has a width asterisk (4-byte slot
     inside ordinary records — the Task-14/RT_FT descriptor rule — vs
     2-byte slots elsewhere). Andrew accepted `byte` provisionally and
     wants a deliberate pass over the whole small-scalar/text surface
     once the single-frontend world has settled, before the cookbook
     freezes the IM→Clarus mapping table's wording.

     **Outcome:** kept all four types — no fold, rename, or widening.
     `bool`/`char` = 1 byte in every aggregate (ordinary records, arrays,
     extern records) on both lanes now, closing the width asterisk that
     motivated this review (previously 4 bytes inside an ordinary record,
     the Task-14/RT_FT descriptor workaround); a standalone local,
     parameter, or global still gets its own 2-byte slot, and Ch13's trap-
     marshaling rules are unchanged. `byte` stays extern-record-
     contextual, as provisionally accepted. `text` is documented as the
     heap-backed binary buffer type, distinct from `char`'s inline scalar
     role. Scope grew during implementation to cover `runtime/mac/
     rt_ui.c`'s three `RT_FT_BOOL` descriptor sites, which needed the same
     1-byte read/write fix for the new record layout to hold. Spec:
     `docs/superpowers/specs/2026-08-05-small-scalar-width-design.md`;
     plan: `docs/superpowers/plans/2026-08-05-small-scalar-width.md`.

  3. **Docs cookbook (branch `toolbox-cookbook`, 2026-08-06): DONE.** Ch13
     gains the IM→Clarus mapping table (CHAR→`word` CharParameter,
     Boolean→`bool`, Point-by-value→packed `int` or the new extern-record
     story, VAR→`ptr`, Str255→`str`, plus the trap-table reading guide)
     and worked IM examples. A curated `toolbox/` extern catalog (per-IM-
     manager `.cla` declaration files shipping with the compiler) is the
     candidate follow-on — it needs the extern-dedup story
     (`irRegisterExtern` currently rejects duplicate names outright)
     decided (by the toolbox-integration phase, 2026-08-04 — see the
     Outcome below).

     **Settled mapping inputs (small-scalar-width phase, 2026-08-05):**
     Boolean→`bool` (1 byte, in every aggregate as of that phase);
     SignedByte/Byte→`byte`; CharParameter→`word`, never `char` — the
     MenuKey lesson (`testsuite/toolbox/cases_events.cla`'s `TbMenuKey`:
     IM's CHAR parameter is a plain 16-bit INTEGER with the char code in
     the low byte, not Clarus's `bool`/`char` extern shape, which pads
     into the word's high byte instead — declaring it `char` silently
     broke every key-equivalent match); and the bit-11 trap-table rule
     already noted above: `trap & 0x0800` — set means Toolbox/pascal
     convention, clear means OS/register convention.

     **Outcome:** all six tasks landed, reference-first. (1) A curated
     `toolbox/{memory,events,osutils,scrap}.cla` extern catalog — real IM
     names, every trap word hand-verified against Retro68's multiversal
     Universal Interfaces defs, and a claimed Gestalt register discrepancy
     between multiversal and `Gestalt.h` documented rather than papered
     over (`osutils.cla`) — that write-up resolved the discrepancy the
     WRONG way and was corrected by pack3-standardfile Task 5a:
     multiversal was right, the trap returns its response in A0, and the
     A1 reading came from mistaking `Gestalt.h`'s inline glue for the
     trap's own contract; a T1
     check test (`internal/testsuite/catalog_test.go`) pins it. (2) The
     `testsuite/toolbox` `Catalog` case wires the catalog into a real
     suite build (22→23 real cases, 24 total incl. `SelfCheck`);
     `cases_event.cla`'s local `Point`/`EventRecord` types were deleted in
     favor of the catalog's copies from `toolbox/events.cla`. (3) Rider 1:
     `UiFlushEvents` (`0xA032`)'s mis-declared pascal-vs-OS/register
     convention (filed under item 2, above) fixed via the bit-11 rule; 14
     `emitui` + 5 `cg68k` goldens regenerated and verified byte-
     reproducible, all four frozen scenario goldens diff-free. (4) Rider
     2: a real native TE↔desk-scrap bridge
     (`nat_UiTEFromScrap`/`nat_UiTEToScrap`, via `TEScrpHandle`/
     `TEScrpLength` + `UiGetScrap`/`UiPutScrap`) makes inter-app
     clipboard real on the native lane; `Catalog` grew a TE↔desk
     roundtrip case (both lanes 24/24). (5) Ch13's "Transcribing Inside
     Macintosh Declarations" subsection — the normative IM→Clarus
     mapping table + bit-11 rule, placed before `callback func`. (6)
     `docs/clarus-toolbox-cookbook.md`, a 10-part how-to companion to the
     reference. Plan-stage corrections: `ScrapStuff` shipped as
     peek-offset documentation, not an `extern record` (its returned
     pointer has no `Name(p)` conversion, and the overlay lacks word
     fields); no snapshot regen was needed (the snapshot embeds only
     compiler source, verified before Task 1). **Two new bugs filed, not
     fixed (see Small open items):** a cg68k size/shape-sensitive
     silent-corruption bug found during Task 4 (repro archived), and a
     transient `emit68k` extern-record-decay crash (0/28
     re-reproductions, recorded unconfirmed/environment-sensitive).
     **Recorded follow-on, not scheduled:** sunset the runtime's `Ui*`
     1:1 trap externs onto catalog names — see the spec's "Recorded
     follow-on" section for the costs (runtime-wide rename,
     emitui/frozen-scenario re-blessing, a snapshot regen, and a
     reserved-vocabulary language-surface decision) that keep it out of
     this phase.

     **GUIDING PRINCIPLE block moved to ROADMAP.md's Standing principles
     section.**

     Spec:
     `docs/superpowers/specs/2026-08-06-toolbox-cookbook-design.md`;
     plan: `docs/superpowers/plans/2026-08-06-toolbox-cookbook.md`;
     ledger: `.superpowers/sdd/2026-08-06-toolbox-cookbook/progress.md`.

  **Compiler-performance phase (originally slotted after Toolbox
  integration, before 5f; ran BEFORE Toolbox integration instead, at
  Andrew's direction, 2026-08-04): DONE.** the test-suite-review phase's
  Task 7 attributed the 30x clarusc-emitted-C-vs-Go-emitted-C slowdown to
  a single O(n) linear scan in the host-only memory shim's `DisposePtr`
  (not ARC volume, not `clar_str_255` copies, not container access). The
  fix (2026-08-04): a ptr-keyed open-addressing hash index over
  `rt_mem_blocks` in `internal/build/rt/rt_mem_host.inc`, giving
  `DisposePtr` O(1) block-record recovery; the ledger itself
  (`rt_mem_blocks`) is untouched, entries are never removed from the
  index. Measured: `every.cla` emit median 11.65s pre-fix (Task 1) →
  0.269s post-fix (Task 2's tripwire re-measurement); `clarusc/main.cla`
  self-emission 631.43s → ~2.07s (Task 2, ~305x).
  Byte-identical output proven both ways: a direct `cmp` of pre-/post-fix
  emitted C, and the Go-free `internal/selfhost` lanes (`TestBehavior*`
  including the `.leaks` paranoid-allocator pin, `TestCrossGen*`,
  `TestSnapshotBuilds`, `TestSnapshotFixedPoint`) all green post-fix.
  `internal/perfgate/baseline.txt` was re-baselined per this ROADMAP's
  own re-baseline note below (7.6s → 0.3s, the tripwire's 2x gate
  falling from 15.2s to 0.6s); spec:
  `docs/superpowers/specs/2026-08-03-compiler-performance-design.md`
  (see its "Outcome (2026-08-04)" section), plan:
  `docs/superpowers/plans/2026-08-04-compiler-performance.md`.

  **The native Standard File (_Pack3) port: DONE (pack3-standardfile
  phase, 2026-08-07, branch `pack3-standardfile`).** Deferred from
  2026-08-03 exactly as planned, and the deferral paid: the shipped shape
  is catalog-first per the GUIDING PRINCIPLE (docs/ROADMAP.md's
  Standing principles section) — `toolbox/
  standardfile.cla` (the full classic S6 package: SFPutFile/SFGetFile/
  SFPPutFile/SFPGetFile as `= trap 0xA9EA sel 1..4`, `SFReply` as a real
  `extern record` — the reference's own worked example — plus
  `SFTypeList`/`Str255` buffers) and a deliberately thin `toolbox/
  files.cla` (PBSetVolSync 0xA015, PBGet/SetFInfoSync 0xA00C/0xA00D,
  VolumeParam/FileParam records; full File Manager fill deferred to a
  future file-abstraction phase). `runtime/clarus/uidialogs.cla` includes
  both catalogs — the first runtime consumer of `toolbox/*.cla`. The
  runtime's own include needs no dedup machinery; what the phase's
  clarusc work buys is that a USER program can ALSO compose the very same
  catalog file positionally while the runtime includes it: include-once
  by normalized path (see the reference's include section) makes the
  runtime's include a no-op, and the splice then HOISTS that user-side
  file ahead of `uidialogs.cla` so its record TYPES are declared before
  use. `internal/testsuite/catalog_test.go`'s
  `TestCatalogComposesWithUIRuntime` pins that composition on both emit
  lanes. Its `nat_UiSFGetFile`/
  `nat_UiSFPutFile` deferred stubs became real transcriptions of the C
  wrappers. Native file-create now stamps `'TEXT'`/`'MPS '` FInfo
  (Task 6a — byte-parity with `rt_mac.c`'s `Create` call; previously
  blank, silently unobservable until SFGetFile's type filter existed to
  expose it). Live-drive acceptance (the 4c standard) passed in full:
  real SFPutFile save → quit → relaunch → real SFGetFile reopen, content
  roundtrip byte-exact (`hdir` shows `TEXT/MPS `), Cancel a clean no-op
  on both dialogs. The 08-03 spec is superseded by
  `docs/superpowers/specs/2026-08-07-pack3-standardfile-design.md`.
  Superseded-spec non-goals still standing: AE/
  GetAppFiles launch, System 7 StandardFile variants (sel 5-8,
  Gestalt-gate when wanted), dlgHook exposure. **New known limits from
  this phase, for whoever touches this next:** (a) native `file.save` now
  stamps `'TEXT'`/`'MPS '` where the C lane stamps `'CLRD'`/the app
  creator — so save-blobs are newly VISIBLE to an `SFGetFile('TEXT')`
  filter on the native lane and invisible on the C lane; the two lanes'
  Standard File file lists no longer agree, and unifying the stamp is
  future work. **(a) DONE (native-gaps-cleanup phase, 2026-08-07):**
  `file.writeText`/`file.save` now take mandatory `type`/`creator`
  args (no defaults, no optional-arg machinery) and `askOpen` a
  mandatory `types` filter arg; new `app.doctype`/`app.id` compile-time
  constants (a new `doctype: "XXXX"` app-section field, default
  `"TEXT"`) and a `fileType{Text,Data,Picture,Application}` const
  family make the common case one call
  (`file.writeText(p, t, app.doctype, app.id)`). Every call site on
  both lanes now stamps an explicit, caller-chosen value — closing the
  TEXT/MPS-vs-CLRD/app-creator divergence outright rather than
  unifying toward one side. `rt_app_creator` (the old C-lane global)
  is retired. Hardware-proven on both lanes by the new `FInfoStamp`
  toolbox-suite case (`PBGetFInfoSync` readback asserts exact
  `fdType`/`fdCreator` for both an `app.doctype`/`app.id` write and an
  explicit-literal write). Spec:
  `docs/superpowers/specs/2026-08-07-native-gaps-cleanup-design.md`.
  (b) `rtUiSys7 == true` (`ui.cla:721`) is NEWLY REACHABLE
  now that Task 5a fixed the Gestalt register binding — pre-fix the
  garbage `resp` always failed the `0x0700..0x1000` bound, so the
  System-7 branch was dead code; no boot has ever taken it (Mini vMac
  answers `0x0607`), so it remains entirely unexercised. Also out of this phase's
  fallout, two records elsewhere in this file: the Gestalt register-
  binding correction (Task 5a — see the "Honest limits" and known-issues
  entries it rewrote) and the cprint-Mac demotion (next paragraph).

  [5f decomposition/sequencing statement moved to ROADMAP.md.]

  **cprint/Retro68 Mac-lane test demotion (pack3-standardfile phase,
  2026-08-07):** the seven `internal/mactest` tests that boot through
  Retro68/cmake/gcc (`TestRunErrOnMac`, `TestAbortAppsOnMac`,
  `TestCoreSuiteGUIOnMac`, `TestToolboxSuiteOnMac`, `TestAppResNaming`,
  `TestAppResResources`, `TestAppResBundleBit`) are demoted off the T2
  per-merge gate to an opt-in diagnostic behind `CLARUS_CPRINT_MAC_TESTS=1`
  (Andrew, 2026-08-07: cprint-68k was a stop-gap; host is the C printer's
  job now, and the native `emit68k` lane already runs every case these
  seven cover). Kept, not deleted, as a cross-lane localization oracle —
  it's what previously triangulated the trailing-bool ABI, 2B/4B form-hang,
  and CharParameter marshaling bugs. Deletion of the lane itself
  (`rt_ext_mac.inc`, `scripts/build-mac.sh`) stays deferred to **5f**
  Retro68-retirement, not this phase. Full phase record: Task 6's ledger
  entry, `.superpowers/sdd/2026-08-07-pack3-standardfile/`.

- **Peephole68k (branch `peephole68k`, 2026-08-08 — first sub-phase of
  the decomposed 5f above; not yet merged to main, merge is Andrew's
  call): DONE, pending merge.** Buys back native-68k code quality lost
  to 5d's deliberately naive codegen, ahead of Mac-resident clarusc's
  own self-compile workload. **Pattern census:** landed — 1 (push/pop
  pair elimination), 2a (load retarget; the 2b dead-move arm was deleted
  as unreachable-by-construction, Task 5), 4 (dead `CLR.L` elimination,
  4 real fire sites), 5 (`MOVEQ` + `ADDA.W` strength reduction, a new
  `OpMoveq` encoder entry). **Dropped:** pattern 3 (stack-cleanup
  batching) — proved structurally unreachable under this backend's
  calling convention: every nonzero `cgCleanupStack` is followed by the
  very next call's own argument push (`AmPreDec` A7, since zero registers
  are callee-saved, any value surviving a nested call must go through the
  stack), which `peepIsA7Neutral` correctly rejects, so no A7-neutral
  window ever exists between two cleanups without crossing the call
  itself — confirmed structurally (every call-emission site) and
  empirically (corpus-wide grep, zero hits; two hand probes); ratified by
  Andrew. Full analysis: `.superpowers/sdd/2026-08-08-peephole68k/
  task-6-report.md`.

  **Measured (from the Task 1 baseline):** size — coregui
  249918/8 segments → 213054/7 (−14.8%, and one fewer CODE segment),
  toolboxgui 293652/9 → 252082/8 (−14.2%, also one fewer segment); the
  third target (`clarusc/main.cla` self-emit68k) stays unmeasurable this
  phase on a pre-existing cg68k gap (below). **Controlled timing**
  (same tree, same session, three foreground runs each, on the
  lexer-only compiler-shaped bench — the bench-meter recalibration
  below is why this is the only trustworthy comparison): peephole ON
  15818/15818/15818 ticks vs. `--nopeep` 18080/18080/18080 ticks, ≈12.5%
  faster. **Bench-meter recalibration lesson:** the tick meter is
  deterministic per binary within one measurement session, but even a
  byte-identical binary can read a different absolute tick count across
  separate sessions (host/emulator wall-clock drift) — cross-session
  deltas against old baselines are not trustworthy; only a same-session
  peephole-vs-`--nopeep` A/B is. **`--nopeep` isolation proof:** the
  current compiler's `emit68k --nopeep` output is byte-identical to the
  pre-branch (committed-snapshot) compiler's plain `emit68k` output, on
  both a single-file UI fixture (`testdata/cg68k/tickprobe.cla`) and the
  full lexer-bench composition (`clarusc/lib.cla`+`tok.cla`+`lex.cla`) —
  proving the peephole plumbing is a true no-op when disabled. The 4
  frozen UI scenarios' framebuffer/trace goldens stayed BYTE-IDENTICAL
  throughout (behavior-unchanged gate); per-scenario native times for the
  record (regression guard, ~3.5s fixed boot overhead + layout
  sensitivity, not a headline number): `smoke_bounce` 7.90s total,
  `smoke_mandel` build 0.41s/boot 12.27s, `texteditor` build 0.40s/boot
  8.81s, `bookmarks` build 0.42s/boot 15.40s.

  **Pre-existing cg68k gaps this phase found (recorded as inputs to
  Mac-resident clarusc, not fixed here):** `clarusc/main.cla` itself
  cannot `emit68k` — "too many str/rec temps" (`cgBigTmpSlots`), then,
  once bumped, "`cgPushArgs`: unaddressable, unmaterializable KStr/KRec
  argument" (Task 1); the same gap class (a freshly-concatenated string
  literal passed directly as a call argument) also blocks clarusc's own
  lexer natively, worked around with one approved one-line hoist in
  `clarusc/lex.cla` (bind the concatenation to a local var first, comment
  names the gap) — roughly 14 more `parse.cla` `parseErrorf(...)` call
  sites have the identical shape and are deliberately NOT fixed here
  (Task 2). **Caller-cleans footnote:** 5d's calling-convention spec gave
  three justifications for caller-cleans (no RTD on the 68000, Pascal
  results ping through memory, and caller-cleans lets peephole batch
  stack pops); this phase's Task 6 found the third one unrealizable under
  the D0-staged immediate-push argument convention described above — the
  other two still stand. **Deferred minors** (future-phase follow-up, not
  blocking): negative-immediate `MOVEQ` encoding has no executable
  coverage (Clarus never constant-folds negative literals, so no fixture
  produces a negative `AmImm` `MOVE` to `Dn`) — revisit when constant
  folding lands; the `ADDA` 32767/32768 boundary is unfixtured; the
  `parse.cla` gap sites above.

  T2 green (`scripts/test-merge.sh`'s three components, run separately,
  foreground): T1 body ~15s, `internal/selfhost` ~89s, gated
  `internal/mactest` native lane ~130s. Design:
  `docs/superpowers/specs/2026-08-08-peephole68k-design.md` ("Outcome"
  section); plan: `docs/superpowers/plans/2026-08-08-peephole68k.md`;
  full task-by-task ledger + reports:
  `.superpowers/sdd/2026-08-08-peephole68k/`.

- **Test-suite review phase (landed on branch `test-review`, 2026-08-04):
  DONE.** All 7 success criteria met (full walk:
  `docs/superpowers/specs/2026-08-03-test-suite-review-design.md`'s
  "Outcomes" section). Two Clarus-native test suites landed
  (`testsuite/core` — 40 cases, host CLI + native/Mac GUI, one boot;
  `testsuite/toolbox` — 5 cases, one boot, both lanes), replacing the
  monolithic `testdata/suite/test_suite.cla`; per-case results parsed
  into Go subtests. Gate tiers landed as designed: T1
  (`scripts/test-task.sh`, 33-49s, target <=3min) sweeps every ungated
  package with `.cla`-aware cache busting and an optional native smoke
  boot; T2 (`scripts/test-merge.sh`) is the full double-lane gated
  mactest + selfhost + Go-differential merge gate, rehearsed green at
  2428s (Task 12). Go-compiler demotion executed for the oracle/reference
  lanes: the Go compiler's own differential/bootstrap/unit-test lanes are
  gated (`CLARUS_GO_DIFF=1`, `internal/selfhost` 14 SKIP/0 FAIL by
  default), Mac-gate host oracles swapped to snapshot-bootstrapped
  clarusc, corpus agreement is now committed `.behavior` goldens + a
  cross-generation snapshot differential, and `scripts/clarus-run.sh`
  replaces day-to-day `clarus run` — `cmd/clarus` + the Go frontend
  itself stay parked as the deliberate deletion-at-end-of-Toolbox-phase
  parachute, per the original plan. **The default gauntlet is NOT fully
  Go-free** (final review F1, 2026-08-04 correction): six harnesses still
  build clarusc via `internal/build.Build` as a build vehicle rather than
  an oracle — see the pre-deletion checklist below for all six call
  sites and the swap-after-compiler-perf-phase sequencing. The 30x
  compiler-performance finding was attributed (not fixed, by design) to
  an O(n) `DisposePtr` host-shim scan, ARC exonerated; follow-up spec
  committed (`docs/superpowers/specs/2026-08-03-compiler-performance-
  design.md`) and slotted into this ROADMAP above ("Compiler-performance
  phase"); a perf tripwire is armed at a 7.6s baseline (`internal/
  perfgate`, 2x-regression gate) — **re-baseline note:** once the
  DisposePtr fix lands, `internal/perfgate/baseline.txt` should drop by
  roughly the same order of magnitude, or the tripwire is silently
  toothless from then on (done, compiler-perf phase, 2026-08-04). The
  coverage-honesty audit (Task 13, table above) seeded/closed what was
  cheap and recorded the rest.

  **Two pre-existing compiler bugs fixed mid-phase, both Andrew-
  authorized departures from the plan's own no-clarusc-changes
  constraint** (in addition to the already-landed, pre-phase `5faaa6c`
  MenuKey/TickCount real-mode trap-convention fix referenced above, which
  this phase's Task 12 gave fresh Mac-lane C-shim glue, not a re-fix):
  (1) **5b, for-loop variable aliasing / ARC over-release**
  (`clarusc-emitted` map-of-text/list/nested for-loop element var
  colliding with an outer var of the same name, scheduling the outer var
  for an extra release) — root-caused to `lowFor`/
  `lowCollectScopeExitCandidates` in `clarusc/lower.cla`, fixed via
  `lowExcludeFreeName` at the three loop-var declaration sites
  (`50ffeb9..247755d`); (2) two Mac-lane cprint C-shim additions for
  testsuite-local trap externs that had never had Retro68 glue before
  (`rt_ext_TbTickCount`/`rt_ext_TbMenuKey`, Task 12; `rt_ext_TbCurrentA5`,
  Task 13) plus a parameter-type fix
  (`rt_ext_TbMenuKey`/`rt_ext_UiMenuKey`'s `CharParameter` marshaling —
  cprint emits `short` for a `word` param, the shim had declared
  `uint8_t`, silently masked by m68k's calling convention) — all in
  `runtime/mac/rt_ext_mac.inc`, not `clarusc` sources, but recorded here
  since they're the same "a trap-convention gap only a real-mode/real-
  shim lane can expose" class as `5faaa6c`.

  **Escalations and follow-ups for whoever touches this surface next:**
  - **Known-broken, not just unexercised:** native non-UI `App.startCLI`
    dispatch — see the audit table's own "known-broken" row above (Task
    9's discovery: `cg68Program`'s entry-handler dispatch fires every
    declared app-level handler unconditionally, with `App.startCLI`'s
    `args` never marshaled, hanging the boot). Worked around
    (`testsuite/core/cli_mac.cla` uses `App.launch` instead), not fixed.
    Live hazard for any future native non-UI program declaring
    `App.startCLI`/`App.startEmpty`.
  - **Borrow-var leak, pinned not fixed:** Task 5b's ARC fix left a known
    residual — a borrow-only for-loop element var gets an unfreed birth
    allocation. Pinned, not silent: `for_loop_var_alias`'s `.leaks`
    golden is `live=6` (not 0), by design, so the leak can't regress
    further without tripping the golden. Fix belongs with a future ARC/
    borrow-checker pass, not this phase.
  - **Six `build.Build` call sites still build the Go compiler as a
    clarusc build vehicle (final review F1, 2026-08-04) — ALL SIX must
    swap to the snapshot-bootstrapped clarusc pipeline before the
    Go-compiler deletion at the end of the Toolbox phase**, or deletion
    breaks every one of them outright:
    1. `internal/mactest/native_test.go:43`'s `buildNativeClarusc` (the
       emit68k-lane compiler build every native-lane gated test depends
       on) — gated-lane-only (`CLARUS_MAC_TESTS=1`), out of Task 5's brief
       when the oracle swap landed.
    2. `internal/asm68k/vasm_test.go:119` (`TestVasmRoundTrip`'s
       `buildClarusc`, also builds `exercise.cla` via `build.Build`).
    3. `internal/cg68k/golden_test.go:54` (`buildClarusc`).
    4. `internal/emitui/emitui_test.go:66` (`buildClarusc`).
    5. `internal/lowlevel/lowlevel_test.go:71` (`buildClarusc`).
    6. `internal/sertest/sertest_test.go:58` (`buildClarusc`).

    #2-6 run UNGATED, in the default `go test ./...` gauntlet, on every
    T1 — they're compiler-tooling packages, not Go-compiler-own tests, so
    Task 6's `CLARUS_GO_DIFF` gate never covered them (their file list
    only named `internal/selfhost` + the compiler unit packages; these
    five were structurally invisible to that task's scope). **Sequencing,
    deliberate:** do NOT swap any of these before the compiler-performance
    phase lands — the snapshot-bootstrapped pipeline is the slow lineage
    until that phase removes the 30x `DisposePtr` O(n)-scan tax (Task 7
    attribution); emitui/cg68k in particular emit large fixtures, so an
    early swap would import that tax straight into T1. Swap all six
    together, post-compiler-perf-phase, immediately pre-Go-deletion.
    **Resolved (Go-compiler-deletion phase, 2026-08-05):** all six sites
    swapped onto shared `internal/claruscboot` before the Go compiler was
    deleted — see the Go-compiler-deletion Done entry below.
  - **Deferred minors** (low-priority, recorded rather than fixed this
    phase): `internal/selfhost/crossgen_test.go`'s header lacks a
    "standalone run needs `-timeout` override (~8min bootstrap)" note
    (Task 4); `internal/lowlevel/lowlevel_test.go` fails `gofmt -l`,
    pre-existing and untouched (Task 6); `testsuite/core/gui.cla:229`'s
    `file.writeText` call binds `ok` but never checks it — a silent
    log-write failure is possible (Task 10); the stray untracked `clarus`
    binary at repo root — cleaned up as part of this wrap task (added to
    `.gitignore`, `git status` was already clean otherwise);
    `testsuite/core`'s CLI (`cli.cla`/`runner.cla`) treats `SelfCheck` as
    a lone explicit arg as an always-FAIL by contract design (it asserts
    all 39 other cases ran together, `casesRun == nCoreCases - 1`) — doc
    note promised at Task 8, landed at final review (F4, 2026-08-04) in
    CLAUDE.md's testsuite entry-points subsection.

  Full task-by-task detail:
  `.superpowers/sdd/2026-08-03-test-suite-review/task-{1..14}-report.md`
  (progress ledger: same directory's `progress.md`); design:
  `docs/superpowers/specs/2026-08-03-test-suite-review-design.md`
  ("Outcomes" section); plan:
  `docs/superpowers/plans/2026-08-03-test-suite-review.md`.

  **Go-compiler-deletion phase (branch `go-deletion`, 2026-08-05): DONE.**
  Two stages. Stage 1 swapped every remaining Go-compiler-as-build-vehicle
  call site onto a new shared `internal/claruscboot` package (`CurrentExe` —
  current-source two-stage bootstrap; `SnapshotExe` — the snapshot lineage
  used by `internal/selfhost`'s generation tests; both cached to disk under
  `build-run/`, flock-serialized): the ROADMAP's six `build.Build` call
  sites (escalation above) PLUS a seventh found during design,
  `internal/reftest`'s `driver.Check`; three pre-existing duplicated
  bootstrap helpers were consolidated into it. Parachute-removal gate: a
  final both-worlds T2 run PASSed at 750s (commit `ee5b1e0`), tagged
  `go-compiler-final`. Stage 2 then deleted the frozen Go compiler outright:
  `cmd/clarus` + `internal/{lexer,parser,check,types,lower,cprint,driver,
  ir,ast,token,source}` + `internal/build`'s Go half (`cc.go`/`embed.go`/
  `runtime.go` survive — `CCPath` and the embedded rt sources
  `internal/selfhost`'s `compileCDir` still consumes) + `internal/
  selfhost`'s five Go-lane files + every `CLARUS_GO_DIFF` gate;
  `TestSnapshotBuilds` re-oracled onto `CurrentExe`; `gogate_test.go`
  renamed to `fixedpoint_test.go` with a four-line Go-free regeneration
  recipe. Post-deletion T1 PASSed at 17s. **NOT deleted, ever:**
  `internal/build/rt/`, `clarusc/clarusc.c` + its snapshot tests. Design:
  `docs/superpowers/specs/2026-08-04-go-compiler-deletion-design.md`; plan:
  `docs/superpowers/plans/2026-08-05-go-compiler-deletion.md`; ledger:
  `.superpowers/sdd/2026-08-05-go-compiler-deletion/progress.md`.

  **Follow-up (deferred):** `testdata/include/` and the unsampled majority
  of `testdata/diag/` are currently unreferenced by any Go test (the final
  review's F4 audit) — retire-or-cover decision deferred.

  **runtime-host-move (branch `runtime-host-move`, 2026-08-05): DONE.**
  Host C runtime moved `internal/build/rt` → `runtime/host`; `internal/build`
  dissolved (C tests → `internal/hostrt`, `CCPath` → `claruscboot`,
  `internal/selfhost` reads the rt sources from disk instead of embedding
  them). Every remaining script/doc/comment pointer at the old path
  repointed. Plan: `.superpowers/sdd/2026-08-05-runtime-host-move/`.

  **ui-scenario-retirement (branch `ui-scenario-retirement`, 2026-08-05):
  DONE.** Migrated 12 of the 23 legacy `testdata/ui` scripted-boot
  scenarios (pattern, buttons, winvar, textwidgets, menus, editmenu,
  canvas, zoomwin, hscroll, popuptable, dialogs, hdim) into
  `testsuite/toolbox` cases — one process, in-process pass/fail, instead
  of one emulator boot per scenario — and deleted their `testdata/ui`/
  `testdata/uisnaps` fixtures in the same commits. `testsuite/toolbox`
  grew 7 → 21 `ToolboxTest` cases (20 real + `SelfCheck`), including two
  new machinery cases beyond the migrations themselves
  (`UiTestVerbSmoke`, `PostEventClick`). The scripted lane now keeps 11
  scenarios: `about` (`UIAbout`), `smoke_bounce`, `smoke_menudemo`,
  `smoke_mandel`, `opendoc`, `opendoc_empty`, `texteditor`,
  `texteditor_quit`, `texteditor_bigfile`, `bookmarks`, and `formedit`.

  **`formedit` was NOT migrated** — deferred (Andrew, 2026-08-05) after
  the migration surfaced a real native-68k codegen bug: a form's
  `accepted(rec)` event silently reverts a bound trailing `bool` field to
  `false`. `formedit` stays in the scripted lane temporarily until that
  fix lands and the scenario can migrate too (see Small open items,
  below).

  One clarusc change, explicitly approved: the `--testapi` flag on
  `emit`/`emit68k`/`appinfo` (Component 1b) — for a UI program, splices
  the UI runtime modules plus a new `runtime/clarus/uitest.cla`
  (`UiTestVerb` + wrappers + `UiTestChecksum`, visible ONLY under the
  flag) in before the clean-standalone check, so suite GUI builds can
  name runtime/`UiTest*` functions; byte-identical to no-flag builds
  otherwise. Also `cgStartupStackReserve` 32768 → 131072 (128K native
  stack) — a real fix, not a tuning knob: the old 32K reserve gave
  roughly a 15-call ceiling against ~2128-byte fixed frames and was
  causing genuine native stack-exhaustion crashes. Snapshot regenerated;
  ~20 cg68k `.s` goldens re-blessed; emitui/cg68k goldens regenerated
  once (Task 1, mechanical churn from the uiscript extraction).

  T2: full `scripts/test-merge.sh` PASS in 715s; gated `internal/mactest`
  (both lanes) 614s, UP from the 534s pre-phase reference despite ~24
  fewer emulator boots — the in-process case work + bigger suite builds
  the migration added apparently outweighs the removed boot overhead;
  not investigated further this phase (correctness is green). Follow-ups
  recorded (see Small open items): the `accepted(rec)`
  trailing-bool codegen bug and `formedit`'s deferred migration;
  `rtUiBuildEvery`'s every-block due-time seeding in composed scripted
  builds; `label.text` READ unimplemented; PostEvent extern glue's
  register-clobber list unverified. Spec:
  `docs/superpowers/specs/2026-08-05-ui-scenario-retirement-design.md`
  (see its "Outcome" section); plan:
  `docs/superpowers/plans/2026-08-05-ui-scenario-retirement.md`; ledger:
  `.superpowers/sdd/2026-08-05-ui-scenario-retirement/progress.md`.

  **test-consolidation (branch `test-consolidation`, 2026-08-06): DONE.**
  An audit-first pass over the WHOLE gated `internal/mactest` boot
  inventory (sequel to ui-scenario-retirement, same discipline): **51 →
  16 emulator boots** (native `emit68k` lane 29 → 12: `TestNativeSmoke`,
  `TestNativeStrContainers`, `TestNativeArrWholeAssign`,
  `TestSmokeBounceOn68k`, `TestRealEventLoopTickOn68k`,
  `TestRunErrOn68k/oob`, `TestAbortOn68k/emit_array`,
  `TestCoreSuiteGUIOn68k`, `TestToolboxSuiteOn68k`, and the 3-scenario
  `TestUiScenariosOn68k` table [`smoke_mandel`, `texteditor`,
  `bookmarks`]; Retro68/cprint lane 22 → 4: `TestRunErrOnMac/oob`,
  `TestAbortAppsOnMac/emit_array`, `TestCoreSuiteGUIOnMac`,
  `TestToolboxSuiteOnMac`). Evidence base: the committed audit table,
  `docs/superpowers/specs/2026-08-06-test-consolidation-audit.md` (29+22
  rows, each cited by its deletion/merge/migrate/keep commit).

  **Verdicts that deviated from the spec's own target list** (each the
  audit overriding the spec, not a silent call): **KEEP**
  `TestNativeSmoke`/`TestNativeStrContainers`/`TestNativeArrWholeAssign`
  (audit claim 2) — each proven to exercise native-codegen shapes
  (file-section edge cases; `list of string(N)` >4-byte-element ops +
  expr-position string-literal slice + computed map key;
  whole-fixed-array/record-field-array/array-of-record/nested-array
  assignment) with zero equivalent in any `testsuite/core/cases_*.cla`,
  where the spec had tentatively marked all three for deletion; **one
  abort app per lane kept** (`emit_array`, audit claim 6) rather than
  fully absorbed into the single runerr representative as the spec's
  target end-state assumed — none of the 6 runerr fixtures has any
  pre-panic output, so the abort apps' byte-exact multi-line
  pre-panic-capture proof (7 lines) has no other home; **`smoke_menudemo`
  plain DELETE**, not a migration (audit claim 3) — `cases_menus.cla` +
  `cases_events.cla`'s `MenuKeyMatches` already cover its custom-menu
  dim/undim and shortcut-dispatch shapes; **`cli_mac.cla` (the file)
  retained** (audit claim 7) even though its own boots (`TestSuiteOn68k`/
  `TestSuiteOnMac`) were deleted — `internal/cg68k/segment_test.go`
  depends on it independently, host-side, out of this phase's scope; and
  **`testdata/ui/about.cla` (the file) retained** likewise —
  `internal/mactest/resparity_test.go`'s `about_noicon` resource-parity
  case depends on it independently, even though the `about` scripted
  scenario itself retired (its About-item-dispatch coverage merged into
  `smoke_mandel`'s events script, audit claim 4).

  The blocking **`accepted(rec)` trailing-`bool` native codegen bug is
  RESOLVED** (small-scalar-width phase, commit `8278ae7`,
  `runtime/clarus/uidialogs.cla`'s `rtUiFormAccept` bool writeback:
  `pokel` → `pokeb` — empirically FALSE at the pre-fix commit `67b2705`,
  TRUE after): `formedit` migrated into
  `testsuite/toolbox/cases_formedit.cla`'s `FormEdit` case (Task 3), which
  itself pins the regression (verified FAILing against the pre-fix
  commit before the migration landed, tickprobe precedent). `testsuite/
  toolbox` grew 21 → 23 `ToolboxTest` cases (22 real + `SelfCheck`):
  `FormEdit` (Task 3) and `BigText` (Task 4, absorbing
  `texteditor_bigfile`'s >32,000-byte clamp/lastError/tail-content shape;
  its own alert-message/close-cascade business logic stays covered by
  `examples/texteditor.cla` in the `texteditor` acceptance boot, an
  accepted gap — see below). The scripted/frozen-golden lane shrank to
  **4 survivors, native lane only** (Task 7 retired the Retro68/cprint
  scenario lane outright and moved `CLARUS_MAC_BLESS=1` bless ownership to
  the native lane): `smoke_bounce` (standalone) plus the 3-row
  `TestUiScenariosOn68k` table (`smoke_mandel`, `texteditor`,
  `bookmarks`).

  **Accepted coverage gaps, recorded rather than silently dropped:**
  `examples/texteditor.cla`'s own app-specific open-guard alert/cascade
  business logic is no longer boot-asserted now that `texteditor_bigfile`
  migrated to the toolbox suite's generic `BigText` case (Task 4); and the
  Retro68/cprint lane's About-item dispatch and `GetAppFiles` doc-launch
  coverage retired with the lane (audit rows R2/R6/R7) — accepted per the
  spec's own Decision 2 (example-app acceptance boots are native-lane-only
  by design), so these two paths now have native-lane-only coverage.

  T2 timing: pre-phase gated-`internal/mactest` baseline 380.7s (T2 run
  2026-08-06 17:17, whole T2 485s); Task 6's mid-phase full-gate reading
  246s; **final (this task): gated `internal/mactest` 171s** (both lanes,
  16 boots, all green) — T1 body 15s, `internal/selfhost` 85s, whole T2
  ~271s, roughly **55% faster** than the pre-phase gated-mactest baseline
  despite the suite builds themselves growing (`FormEdit`/`BigText`).
  Spec: `docs/superpowers/specs/2026-08-06-test-consolidation-design.md`
  (see its "Outcome" section); audit:
  `docs/superpowers/specs/2026-08-06-test-consolidation-audit.md`; plan:
  `docs/superpowers/plans/2026-08-06-test-consolidation.md`; ledger:
  `.superpowers/sdd/2026-08-06-test-consolidation/progress.md`.

## Archived from ROADMAP, 2026-08-15 (verbatim)

The sections below were moved verbatim from `docs/ROADMAP.md` on
2026-08-15: the decided-sequencing record and every completed phase from
mac-resident-clarusc through clir-load-perf (all merged to main).
Open follow-ups extracted from these entries were condensed into
`docs/TODO.md`.

## Decided sequencing (REORDERED from the older plan docs' roadmap notes)

The user chose to pursue self-hosting BEFORE the Mac target, because clarusc
development is fully host-testable and will surface language defects that
should be fixed before the Mac runtime freezes contracts. The older plans'
"Roadmap context" sections predate this reorder — this file wins.

**Decided 2026-07-23: clarusc is next.** The order is:

1. **clarusc** — the compiler written in Clarus, developed host-side against
   the Go compiler with differential testing, through the three-stage
   bootstrap and the committed C snapshot (strategy: docs/HISTORY.md's
   "clarusc / self-hosting strategy" section). **DONE** — see
   docs/HISTORY.md ("Done" item 5).
2. **Mac target** (4a "hello, Macintosh", then 4b core UI, then 4c text
   editing, then 4d forms/binding, then 4e memory audit). 4a **DONE** — see
   docs/HISTORY.md ("Done" item 6). 4b **DONE** — see docs/HISTORY.md
   ("Done" item 7). 4c **DONE** — see docs/HISTORY.md ("Done"
   item 8). 4d **DONE** — see docs/HISTORY.md ("Done" item 9). 4e **DONE** —
   see docs/HISTORY.md ("Done" item
   10).
3. Memory + forms runtime, then networking.
4. clarusc's 68k build — compiling Clarus on a Macintosh — once the Mac
   target exists.

## Native 68k toolchain (Plan 5)

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

  All three phases named above (test-suite review/Go-compiler
  retirement, Toolbox integration + small-scalar-width, and the Docs
  cookbook) are DONE — full record moved to docs/HISTORY.md (Test-suite
  review/velocity phase, Toolbox integration phase, Character/byte-type
  surface review, Docs cookbook), along with the Compiler-performance
  phase and the native Standard File (_Pack3) port / pack3-standardfile
  phase (including native-gaps-cleanup and the cprint/Retro68 Mac-lane
  test demotion) that ran alongside/after them.

  Next:
  **5f** (Mac-resident clarusc, Retro68 retirement, compilation cache,
  peephole/regalloc buy-back — inventory in docs/HISTORY.md (5e, UI
  runtime port)).
  **Decomposed 2026-08-08** into four ordered sub-phases, each with its
  own spec/plan/branch, rather than one big 5f: **peephole** (native-68k
  codegen quality buy-back, first — landed, see docs/HISTORY.md
  (Peephole68k)) →
  **Mac-resident clarusc** (next) → **compilation cache** → **Retro68
  retirement** (last).

- **Mac-resident clarusc (branch `mac-resident-clarusc`, 2026-08-08/09 —
  second sub-phase of the decomposed 5f above): CODE-COMPLETE; the
  final live integration-test PASS is the one thing NOT yet in hand (see
  below) — do not merge until a future session runs
  `TestMacResidentClaruscOnSnow` to a clean PASS.**
  `ClarusC.APPL` (`clarusc/macgui.cla`, built by
  `scripts/build-clarusc-mac.sh`) is a real Mac application that runs
  `clarusc emit68k` ON the Mac itself, compiling OTHER `.cla` programs
  with no host machine involved — a real Standard File "Compile..."
  dialog drives the SAME `drive.cla` pipeline the host CLI uses, then
  writes a native `.APPL` to disk via `file.writeRes`. It self-bakes the
  whole `runtime/clarus/*.cla` + `toolbox/*.cla` source catalog into its
  own resource fork (`emit68k --bake FILE`, one flag per file, verbatim
  name), so a compile it runs needs no `runtime/clarus/` directory on the
  Mac disk at all — every `include` and every automatic runtime-module
  splice (core/str/text/list/map/ui*) resolves through a baked `'CLFS'`
  resource instead (Task 8's `driveKeyResolve` + a resource-backed
  `feReadSource`, Task 6/10's front-end seam).

  **Task 11 (final task, phase close) — environment pivot mid-task:** the
  brief was written against a 24-bit Snow acceptance machine
  (`snow/MacIIFDHD-IIx-IIcx.rom`, `pmmu_enabled=false`), which capped
  Process-Manager-allocatable RAM at ~6.8MB regardless of 128MB physical
  RAM (Task 10's own finding) and forced a 4MB `SIZE(-1)` partition
  compromise. Before Task 11 started, the controller re-synced the Snow
  workspace to a 32-bit-clean ROM (`snow/rominator.rom`, real BMOW splash
  confirms "Detected 128 MB RAM, 32-bit mode" at boot; Largest Unused
  Block 129,868K verified) — `scripts/build-clarusc-mac.sh`'s
  `--partition` raised from 4MB to 48MB (50331648 bytes) accordingly,
  matching the design spec's own §7 estimate (14-22MB working set +
  headroom). `internal/mactest/snow_test.go` had two now-stale hardcodes
  fixed to read the acceptance machine's own facts instead of a frozen
  filename: `rom_path`/`display_card_rom_path` are now absolutized from
  whatever `snow/Clarus.snoww` itself names (not a literal
  `MacIIFDHD-IIx-IIcx.rom` string), and the scratch disk image is cloned
  from `scsi_targets[0].Disk` in that same workspace JSON (not a literal
  `hdd0-clarus.img`, which no longer existed post-resync — the controller
  had renamed it to `hdd0.img`). A separate, unrelated build-script bug
  surfaced during revalidation: `scripts/build-68k.sh` cached its
  bootstrap compiler at `build-68k/clarusc`, which — on macOS's default
  case-insensitive filesystem — collides with `build-68k/ClarusC/`, the
  output directory `build-clarusc-mac.sh`'s own build produces; running
  both in the same tree silently clobbered the cached binary with a
  directory. Fixed by moving `build-68k.sh`'s bootstrap cache to
  `build-run/clarusc`, the same shared cache `build-clarusc-mac.sh`/
  `clarus-run.sh` already use for the identical bootstrap recipe.

  **The real bug this task exists to catch, caught:** every prior task in
  this phase built and boot-smoked `ClarusC.APPL`, but none had ever
  driven its "Compile..." action to completion — Task 10's own boot
  smoke used a baked events script that only exercises `App.startEmpty`
  then `quit`, never `Compile.select`. The FIRST attempt at a real
  on-Mac compile (this task) failed immediately: `driveManifestSplice`/
  `driveEarlySplice` (`clarusc/drive.cla`) read every automatic
  runtime-module file (`core.cla`, `ui.cla`, …) via the low-level
  `file.readText` directly, bypassing the `feReadSource` seam `expand()`
  already used for ordinary `include`s. With no `runtime/clarus/`
  directory on the Mac disk (the entire point of `--bake` is to avoid
  needing one), every runtime-module read failed outright — "runtime
  module core.cla not found (searched runtime/clarus/ from the working
  directory upward); use --rtdir" — and `ClarusC.APPL`'s own compile of
  ANY UI program was unreachable code until fixed. Root-cause fix (not a
  guard at the call site): a new `rtModuleKey(mod)` helper
  (`"runtime/clarus/" + mod`, exactly the `--bake` name
  `build-clarusc-mac.sh` gives every runtime file) threaded through both
  the readability probe and the `expand()` call at both splice sites —
  four call sites, one helper. Byte-identical on host: `main.cla`'s own
  `feReadSource` ignores its `key` argument entirely and always reads
  straight off disk, so the swap from `file.readText` to `feReadSource`
  is a pure no-op there, confirmed by T1 staying green.

  **Fixtures (Step 1-2):** `testdata/mac-resident/catprobe.cla` — one
  `include "../../toolbox/osutils.cla"` (deliberately never staged on
  the Snow disk, so it can ONLY resolve via the baked-resource fallback),
  one real cataloged trap call (`GestaltErr(gestaltSystemVersion)` —
  `osutils.cla` doesn't declare `TickCount`, the brief's own sketch was
  wrong about that), self-quit. `testdata/mac-resident/clarusc.events`
  drives two on-Mac compiles: `answer-open :::tickprobe.cla` / `menu 2 1`
  (Compile…) / `answer-open :::catprobe.cla` / `menu 2 1` / `quit` — the
  `:::` HFS up-level idiom is required because `ClarusC` self-launches
  from `:System Folder:Startup Items:` (two levels below the volume
  root, where the harness's `putText` actually places the source files),
  same convention Task 4's own `roundtrip.cla` fixture established; the
  ENTRY file's own resource key always starts at `""` regardless of that
  disk-path spelling (`driveCompile`'s `expand(entries[i], true, "")`),
  so this has no bearing on the baked-resource include resolution above.

  **Integration test (`internal/mactest/macresident_test.go`,
  `TestMacResidentClaruscOnSnow`, gated `CLARUS_SNOW_TESTS=1`):** builds
  `ClarusC.APPL` with the events script baked in, boots it on Snow with
  `tickprobe.cla`/`catprobe.cla` at the volume root and NO
  `toolbox/osutils.cla` anywhere on disk, and requires (1) the captured
  `out` trace shows both scripted compiles were dispatched with no
  alert-visible error text (`gcLog`'s own "BUILT " line, it turns out,
  only ever reaches the on-screen Log textview — never the trace-capture
  stream — so a literal `"BUILT "` search, the brief's own Step 4
  wording, can never match regardless of success; `alert()`, which IS
  trace-visible, is the real per-compile error signal, and every
  `gcCompile` error path calls it); (2) `TickProbe`/`CatProbe`, extracted
  from the boot disk (`hcopy -m`, MacBinary-preserved), have resource
  forks byte-identical to the SAME two fixtures built by the
  current-source HOST compiler (`claruscboot.CurrentExe`, two-stage
  bootstrap — mandatory, since the committed snapshot predates this
  task's own fixes) — THE core assertion; (3) the on-Mac-produced
  `TickProbe`, booted standalone with no `--events` (the real,
  non-scripted `rtUiRun`/`UiTickCount` event loop), actually launches and
  runs to completion — proof the byte-identity check isn't comparing two
  equally-broken outputs.

  **Result: test correctly designed and code-complete; NOT run to a
  final PASS/FAIL within this task's own session.** Four real Snow-boot
  attempts, in order: (1) a killed early manual probe that first
  produced the `driveManifestSplice` crash trace, fixed as above; (2) a
  full 50-minute automated run whose trace proved BOTH
  `Compile.select`/`askOpen` pairs fired with zero alert/error text
  (strong evidence both compiles at least started cleanly), but with no
  exit trailer — compile 2 (catprobe.cla) was still running when the
  50-minute settle elapsed, revealing that ONE compile alone can take
  close to that long (compiling ~12,000 lines of runtime source —
  core/str/text/list/map/ui* — through the full self-hosted
  lex/parse/check/lower/shake/asm68k/peep68k/cg68k pipeline, interpreted
  on emulated 68k hardware; consistent with peephole68k's own bench
  finding that lexing just `lib.cla`+`tok.cla`+`lex.cla` alone took
  ~264s of Mac-tick time); this same run is what surfaced the "BUILT "
  assertion design flaw above. `macResidentCompileSettle` raised to 110
  minutes (runSnow's own timeout to 130m) accordingly; (3) and (4), two
  more attempts with the corrected/lengthened test, both terminated
  partway through (at roughly 51 and 60+ minutes respectively, past the
  point either prior run had reached with zero errors) by what appears
  to be an environment-level background-task lifecycle limit on the
  execution host, unrelated to the code under test — the Go test
  process itself was SIGKILLed externally (no panic, no Go-level
  timeout, nothing past its own first log line), reproducing even after
  deliberately avoiding any accumulation of concurrent background
  helper tasks. Every attempt's OWN evidence (before being cut off) was
  consistent and error-free: clean boots, both askOpen answers accepted,
  zero alert-visible error text, sustained legitimate CPU activity the
  entire time. Task 11's own commit lands with the fix, the corrected
  test, and this honest result — completing the live end-to-end
  byte-identity proof is the clear, well-defined next step for whoever
  next has a session that can hold a ~2-hour foreground Snow boot
  uninterrupted; task-11-report.md (gitignored) has the full run-by-run
  writeup.

  **`start_fastforward` tried and NOT adopted:** enabling it
  (`init_args.start_fastforward=true` in the scratch workspace JSON)
  produced a boot that sat for minutes with no launch at all (host CPU
  usage low and flat, no `ClarusC` window ever appearing within 3+
  minutes of guest time it should not have needed even at 1×) — an
  apparent bad interaction between fast-forward and something latency-
  or timing-sensitive in this specific boot path. Not investigated
  further: real-time already completes inside a practical (if long) test
  timeout, and this is the first time anything in this repo has ever
  tried fast-forward, so there's no regression to chase.

  **Honest limits:** `ClarusC.APPL`'s default-directory compile model is
  exactly what Task 10 documented (an app launched from Startup Items
  has ITS OWN folder as the default directory for a bare relative path;
  reaching the volume root needs the HFS up-level idiom) — there is no
  "open from anywhere" convenience yet, matching the host CLI's own
  plain-argv model. `file.readResource`/`file.writeRes` remain
  Macintosh-only; a host build's `readResource` always returns `false`
  (`docs/clarus-language-reference.md`'s own entry, confirmed unchanged
  and accurate by this task). Design:
  `.superpowers/sdd/2026-08-08-mac-resident-clarusc/` (spec, plan, and
  every task's brief/report/review); full task-11 evidence:
  `task-11-report.md` in that same directory (gitignored).

- **map-hashtable (branch `worktree-native-perf-findings`, 2026-08-10,
  based on `mac-resident-clarusc`): DONE.** Replaced `map of T`'s O(n)
  sorted-array insert with a real insertion-order hashtable on both
  lanes, and split the old ordered-iteration contract off into a new
  `sortedmap of T` type so nothing that actually needed ascending-key
  order lost it. A third new type, `intmap of T` (int-keyed, sharing
  `map`'s hashtable machinery via delegation), replaced the compiler's
  own internal `numToStr`-keyed symbol tables. 11 tasks, full ledger +
  every task's brief/report/review: `.superpowers/sdd/
  2026-08-10-map-hashtable/`; design: `docs/superpowers/specs/
  2026-08-10-map-hashtable-design.md`; plan: `docs/superpowers/plans/
  2026-08-10-map-hashtable.md`.

  **Three types, three contracts:**
  - **`map of T`** (Task 5, both lanes — `runtime/host/rt_core.inc` +
    `runtime/clarus/map.cla`): real open-addressing hashtable (14-field
    `RtMap`/`struct rt_map` overlay, `rtMapBoxSize = 112`), replacing the
    old key-sorted binary-search-over-packed-arena design. **Semantic
    change:** iteration order is now unspecified-but-deterministic
    (insertion/removal-history-dependent, not ascending key order) —
    `docs/clarus-language-reference.md`'s Maps section (iteration bullet
    + the `:161` row) and `rt_core.inc`'s own CONTRACT banner updated to
    say so. Every `map`-of-something existing test, fixture, and golden
    across the corpus was audited for an order dependency and fixed
    order-agnostically BEFORE the rewrite landed (Task 4) — see the T2
    debt note below for what that did and didn't reach.
  - **`sortedmap of T`** (Tasks 1-3): a distinct type preserving the OLD
    ascending-key-order contract exactly (never assignable to or
    comparable with `map`), usage-gated splice (`usesSortedMap` ->
    `cpSortedMapPorted` -> `sortedmap.cla`) so a program that never
    names it pays nothing.
  - **`intmap of T`** (Tasks 6-9): int-keyed hashtable, unconditionally
    spliced (per the spec's own design decision, unlike `sortedmap`'s
    usage-gating), sharing `map`'s hashtable machinery underneath via
    delegation rather than a parallel implementation. Task 10 (Stage B)
    then migrated eight compiler-internal `map of T` tables that were
    already int-keyed under a `numToStr(intKey)` round-trip (e.g.
    `check.cla`'s `exprTypeOf`/`funcSigByDecl`/`enumConstOf` family,
    `types.cla`'s `Scope.names`, `ir.cla`'s two `*NeededByName` tables,
    `shake.cla`'s `shakeFuncIdxByName`) onto real `intmap of T`, dropping
    the string round-trip entirely. Four tables were correctly left as
    string maps (genuinely string-content-keyed: `strIndex`, the
    string-literal dedup pool, two composite-key dedup sets); several
    more int-keyed-but-unmigrated tables were identified and filed as
    Stage C candidates below rather than swept in, since they were
    outside this task's explicit brief list.

  **Test-suite growth: 42 → 54 `CoreTest` cases** (`testsuite/core`,
  `nCoreCases`): 42 → 46 (Task 3, `sortedmap` cases: `SortedMapSetCount`/
  `SortedMapHasRemove`/`SortedMapOfListUpsert`/`SortedMapIterOrder`) → 50
  (Task 5, hashtable-`map` cases: `MapGrowRehash`/`MapRemoveSwap`/
  `MapIterComplete`/`MapLongKeys`) → 54 (Task 8, `intmap` cases:
  `IntMapSetCount`/`IntMapHasRemove`/`IntMapOfListUpsert`/
  `IntMapGrowIter`). `testsuite/toolbox`'s 28 cases (27 real + SelfCheck)
  are untouched by this phase. Two full snapshot regenerations:
  Stage A (`dc24e96`, Task 9's own commit landing after the intmap runtime+compiler
  support (Tasks 6-8) as well, not just the map rewrite — sortedmap/intmap/hashtable-map all
  land in the committed `clarusc.c` together) and Stage B (`9cc5c1c`,
  after Task 10's intmap migration); the three-stage bootstrap fixed
  point was independently re-verified after each.

  **The honest perf story — two separate findings, not one:**
  - **Task 5's hashtable fixed a real, silently-red regression.**
    `TestEmitPerfTripwire` (`internal/perfgate`) was RED on `main` and on
    this phase's own base commit alike BEFORE Task 5 landed — host emit
    median ~1.1-1.5s against the 0.3s baseline set 2026-08-04, more than
    2x over the tripwire's own gate, going unnoticed because nothing had
    re-run it since the baseline was set. Root cause: `map`'s old O(n)
    sorted-array insert, paid on every `clarusc emit` because clarusc
    compiles its own source using `map of T` internally. After Task 5:
    median 0.205s against the same 0.300s baseline — PASS, with headroom.
    This is a real, measured win, not a retracted one.
  - **Task 10's compiler-internal intmap migration measured
    host-NEUTRAL — an initial ~6% claim was retracted.** A 3-run
    tickprobe.cla comparison isn't enough signal on a sub-half-second
    fixture; a proper re-measurement (10 interleaved pre/post pairs of
    clarusc self-compiling its own `main.cla`, to cancel system-load
    drift) came back 10.73s pre / 10.99s post summed user-CPU — noise-
    to-slightly-negative, post winning only 4 of 10 pairs. **Honest
    rationale for keeping the migration anyway:** Task 5's hashtable
    already made the HOST lookup path cheap, so removing Stage B's
    `numToStr` round-trip on top of an already-fast host probe doesn't
    move the needle within measurement noise. The migration's real case
    is the UNMEASURED 68k lane, where every one of those lookups
    previously paid a `numToStr` allocation, a string hash, and a
    per-probe `rtStrCmp` call — real cost on actual 68k hardware that is
    nearly free on a modern host. Nobody has yet measured clarusc's own
    native-68k compile time with this migration in place; that
    measurement, not a host number, is what would validate or refute
    Stage B's premise.

  **T2 debt, explicit (per Andrew's direction, not run this phase):**
  `internal/selfhost`'s full 30-minute suite was NOT run this phase,
  except Task 4's own scoped pre-emptive fix-and-check
  (`go test ./internal/selfhost -run 'TestBehaviorGoldens/run/
  (breakcont|collections|emit_map|for_loop_var_alias)\.cla'`) — those
  four fixtures were the only ones found printing `map`-iteration-
  dependent output anywhere in `testdata/run`, and all four were fixed
  order-agnostically (aggregate sums / fixed-order `.has` lookups
  instead of `alert()`-per-iteration) BEFORE the hashtable switch, with
  their `.out`/`.behavior` goldens regenerated where the fix changed
  printed text. Task 11 re-swept the whole corpus
  (`testdata/run/**`, `testsuite/**`, `clarusc/test/**`) for any other
  `for k, v in <map>` iteration-order dependency and found none beyond
  those four (already fixed) and the ones already known out-of-scope
  (diagnostic-only fixtures, cg68k asm-listing goldens that never run).
  `clarusc/test/*.cla`'s own `map of T` mentions are all
  checker-declaration fixtures (type-checking pins), not iteration/print
  fixtures — no evidence any `clarusc/test/*.out` module golden needs
  regeneration, but this is unverified without an actual `internal/
  selfhost` run. **First T2 run after this phase should still expect
  possible churn in `internal/selfhost` and `clarusc/test/*.out`** — that
  audit reduces the risk, it doesn't replace running the suite.

  **Step 2 finding (Task 11): a stale test-harness expectation, not a
  hashtable bug.** The mandated single UI-suite run
  (`TestCoreSuiteGUIOn68k`/`TestToolboxSuiteOn68k`, native 68k lane) at
  first FAILed — but every one of the 54 individual `CoreTest` cases,
  including all 12 `map`/`sortedmap`/`intmap` cases, PASSed on real
  hardware; the failure was `internal/mactest/coresuite_test.go`'s own
  hardcoded `"TOTAL 42 PASS 42 FAIL 0"` expectation, never updated across
  Tasks 3/5/8's case-count growth (42→46→50→54) because this was the
  first time this phase's work had actually booted the native GUI suite
  (by design — UI-once-at-end). Fixed (hardcoded 42 → 54, comments
  updated to match); re-run clean: `TestCoreSuiteGUIOn68k` PASS (54/54),
  `TestToolboxSuiteOn68k` PASS (28/28, untouched by this phase). No
  goldens were re-blessed this phase — no iteration-order-sensitive
  byte-layout golden was affected by the native run.

  **Stage C candidates (recorded, not scheduled):**
  - `intmapHash` (`runtime/clarus/map.cla:912`) is the identity function
    (`key & 0x7FFFFFFF`) with no mixing; decl-arena indices are
    allocated in a tight sequential/strided pattern that could cluster
    under a power-of-two index-capacity mask — a multiplicative mixer is
    the candidate first fix if a future on-target measurement shows
    clustering or a smaller-than-expected win.
  - `recFieldsHeadByName`/`xrecSizeByName` (`check.cla`) — int-keyed tables
    still on string maps.
  - `ast.cla`'s `externRetRegByDecl`/`externRegBindStart`/
    `externRegBindCount` and `check.cla`'s `checkEnumDecl` `seen` table —
    same `numToStr(intKey)`-round-trip shape as Task 10's migrated
    tables, correctly out of that task's explicit scope, not yet moved.
  - `irLayoutNeededByName`/`irRcWalkNeededByName` (`ir.cla`) cross-compile
    reset — these two tables are never reset between compiles in the
    same process, safe today only because `lib.cla`'s intern pool is
    itself deliberately never reset either; a future Mac-resident
    memory change resetting the intern pool mid-process would need to
    reset these two as well.
  - Two corners found by final review (attribution corrected by its
    scoped re-review): (a) map/sortedmap `get(k, dv)` evaluates k and dv
    in different orders host vs native — the shared native
    `cgIntrMapGetDv` (cg68k.cla) evaluates m, dv, then k, while the host
    emission (cprint.cla's `IMapGetDv`/`ISortedMapGetDv` arms) evaluates
    m, k, then dv; observable only if both k and dv have interacting
    side effects (intmap's own `get` was already made order-consistent
    by Task 7's key-binding fix, 749e91f) — either pin "argument
    evaluation order unspecified" in the reference or align the native
    order; (b) `edit F, sm[k]`/`im[k]` dies in
    lowering with a generic "edit target" message instead of a checker
    diagnostic naming the map-only restriction.
  - Deferred minors from Task 5's own review: unbounded index probe
    loops have no corruption guard (could hang on an invariant break);
    `rt_map_layout_check` is `sizeof`-only (no `offsetof` field-order
    assertions); the dead `MAP_KEYBLOCK` constant in `rt_core.inc`;
    `map.cla`'s three near-identical growers could collapse to one
    helper; the hash's signed-int32 shift-add is UB on overflow in the C
    emission (both lanes agree today, reviewer-verified); the keypool is
    append-only until release/clear (fine for compiler workloads, a real
    ceiling for anything else); `caseIntMapGrowIter` lacks the `-5` vs
    `2147483643` masked-hash-collision partner pair a fuller test would
    pin.

- **Known-unexercised runtime surface (test-suite-review Task 13,
  2026-08-04):** a coverage-honesty audit — every `func nat_` fallback in
  `runtime/clarus/*.cla`, every `UiTestScript()`/`rtUiScripted`
  scripted-vs-real fork, and a full `external func` declaration sweep
  (219 externs) cross-referenced against every call site any existing
  test actually reaches. Two genuinely cheap closures landed this task
  (`testsuite/toolbox/cases_a5.cla`'s new `A5Live` case, toolbox suite
  now 5 cases); everything else below is recorded, not closed, because
  closing it needs real modal/mouse input, real hardware, or a runtime
  code change out of an audit task's scope.

  | Branch / stub | Status | Reason / pointer |
  |---|---|---|
  | `nat_UiSFGetFile`/`nat_UiSFPutFile` (`uidialogs.cla`) | ~~stubbed-by-design~~ **CLOSED, pack3-standardfile (2026-08-07)** | Was: StandardFile's selector-prefixed Package Manager dispatch (`0xA9EA`) never ported on either lane, returning `false` (cancelled) unconditionally. Now real `_Pack3` transcriptions over `toolbox/standardfile.cla`, live-driven on the emulator (save → quit → relaunch → reopen, byte-exact). The scripted scenarios still take the test-mode substitute by design, so the real dispatch is covered by live-drive acceptance, not by a golden. |
  | `nat_UiTEFromScrap`/`nat_UiTEToScrap` (`uitext.cla`) | ~~stubbed-by-design~~ **CLOSED by toolbox-cookbook (`0f2534e`, 2026-08-07)** | Real ports now (`uitext.cla:193-230`: `peekl(0xAB4)`/`UiGetScrap`/`pokew(0xAB0)` and `UiHGetState`/`UiHLock`/`UiPutScrap`), hardware-proven by the toolbox suite `Catalog` case's TE↔desk-scrap roundtrip on both lanes (T2). This row's original no-op-glue description was stale from the moment 0f2534e landed; corrected pack3-standardfile final review, 2026-08-07. `nat_UiTEGetScrapLength` is NOT a stub (a real `peekw(0xAB0)` port) and IS exercised — Paste's 32k-clamp length calc (`uitext.cla:813`) runs on every `editmenu.events` boot. |
  | `nat_UiLaunchReal` (native/cg68k lane, `ui.cla`) | closed by `TestRealEventLoopTickOn68k` | New finding this audit: `tickprobe.cla` boots with no `--events`, so `UiTestScript()` reads empty and `rtUiLaunch` takes its real (non-scripted) branch — `UiLaunchReal()` resolves to `nat_UiLaunchReal` (clause-less extern, native lane), which degrades to `UiFireStartEmpty()`. Not previously documented as closed. |
  | `UiLaunchReal` (cprint/Mac lane, `rt_ext_mac.inc` real C AE glue: `AEInstallEventHandler` + 4 Pascal handlers) | unexercised, recorded | Still genuinely untested — every Mac-lane (Retro68) test build uses `--events`, and `TestRealEventLoopTickOn68k` only covers the native `emit68k` lane (no `TestRealEventLoopTickOnMac` twin exists). Needs a real Finder double-click launch or a dedicated no-events Mac-lane smoke test; not cheap (out of this task's scope to add a new gated Mac boot lane). |
  | `rtUiAskSaveChanges`'s real `Alert(130)` half (`uidialogs.cla`) | unexercised, recorded | Gated on `rtUiScripted`, which is unconditionally `true` for the run's whole lifetime the instant any test's `rtUiRunScripted` starts (`uiscript.cla:1250`) — no existing test ever takes the real half. NOT cheap per this task's own bar: modal `Alert`, needs real input. Same disposition covers `rtUiAskOpen`/`rtUiAskSave`'s own real halves (`UiSFGetFile`/`UiSFPutFile`, row 1 above). |
  | Real mouse-tracking / `TrackControl` continuation (`ui.cla:2117,2144` scrollbar+button tracking, `uitext.cla:731` textview scrollbar drag, `uitable.cla:758` List Manager `LClick` row tracking, `uitable.cla:950,970` `rtUiPopupClick`'s real `UiPopUpMenuSelect` branch) | unexercised, recorded | All `rtUiScripted`-gated: a scripted `click` synthesizes the discrete effect directly (one nudge, one row pick, one `rtUiAnswerPop`-queued popup choice) rather than invoking the real held-mouse tracking/menu-tracking loop (`UiTrackControl`/`UiLClick`/`UiPopUpMenuSelect`). Needs live/held mouse input — CLAUDE.md's own documented carve-out for this display's interactive-testing gap. |
  | Native non-UI `App.startCLI` dispatch (`cg68Program`, cg68k.cla) | **known-broken**, not unexercised | Task 9 escalation, still live: entry-handler dispatch calls every declared app-level handler unconditionally (no platform-exclusivity check) and never marshals `App.startCLI`'s `args` parameter (reads back as uninitialized garbage) — hangs the boot with zero captured output. Worked around, not fixed: `testsuite/core/cli_mac.cla` uses `App.launch` instead. Live hazard for any FUTURE native non-UI program declaring `App.startCLI` (task-9-report.md's own "Flagging for Andrew"). De-prioritized, not scheduled (test-consolidation spec Decision 3, Andrew, 2026-08-06): "CLI targets the host; 68k headless apps are a by-product, not a goal" — the same phase dropped both Mac-lane CLI boots (`TestSuiteOn68k`/`TestSuiteOnMac`) entirely rather than routing around this bug, since the host CLI (`cli.cla`) is the CLI story and `App.launch`-based `cli_mac.cla` already covers the native-lane case-running need. |
  | Real (`= trap`) cmd-key `_MenuKey` dispatch | **closed by `MenuKeyMatches`** | This phase (Task 11): a real Toolbox `_MenuKey` (`0xA93E`) call against the GUI's own installed File menu, run synchronously in-process — no longer needs a real hardware key press to exercise the fixed `CharParameter` marshaling (the `5faaa6c`-era bug shape). |
  | Real-mode `every`-timer scheduling, native (cg68k) lane (`rtUiBuildEvery`/`rtUiEveryPump`'s `UiTickCount()` branch, `ui.cla:1328`) | **closed by `TestRealEventLoopTickOn68k`** | `tickprobe.cla`, no `--events` — the only test exercising `rtUiRun`'s real `WaitNextEvent` loop and real tick scheduling (every scripted scenario runs on `gVirtualTicks` instead). Native (`emit68k`) lane only — same cprint/Mac-lane gap as the `UiLaunchReal` row above (no no-events Mac-lane boot exists at all). |
  | `UiNumToString` (Package 7, `0xA9EE reg`, `uitable.cla`) | closed by golden | Empirically green, not newly tested: `testdata/ui/formedit.events`' second `edit` session (prefilled int field, `kind=2`) is `uitable.cla:122-124`'s own documented "first real exercise" of the fixed register-marshaling shape. No new toolbox case landed — would be redundant. |
  | `UiZeroScrap`/`UiTEGetScrapLength` (`0xA9FC`/`peekw(0xAB0)`) | closed by golden | `testdata/ui/editmenu.events`'s Cut/Copy (`ui.cla:1241-1249`) and Paste (`uitext.cla:813`) already call these through the real Edit-menu dispatch. No new toolbox case landed — would be redundant. |
  | `UiCurrentA5` (`uiscript.cla`'s own declaration, `= inline a5`) | **partially closed, `A5Live` (this task)** | Zero-call-site dead declaration found by the `external func` sweep (`rtUiTestSnap` ended up using `UiScreenBits` instead — see that function's own history). `testdata/cg68k/inline_a5.cla` only pins the emitted listing bytes, never boots. This task's new `A5Live` case (`testsuite/toolbox/cases_a5.cla`) declares its own local `TbCurrentA5` extern against the same clause (same precedent as `TbTickCount`/`TbMenuKey`) and boot-verifies the `cgCallExtA5` codegen for real on both lanes (needed a new `rt_ext_TbCurrentA5` cprint shim, `runtime/mac/rt_ext_mac.inc`). The runtime's OWN `UiCurrentA5` declaration remains unreferenced — wiring a real qd-globals call site into `uiscript.cla` is a runtime code change, out of this audit task's scope. |
  | `UiNewMenuStr` (`ui.cla`, `string`-typed `NewMenu` overload) | unexercised, recorded (dead code) | Zero-call-site dead declaration found by the same sweep — `UiNewMenu` (the `ptr`-typed sibling) is the one actually used for real menu creation (`ui.cla:1029,1099`, exercised by every menu-bearing golden). No coverage gap to close, just an unused declaration; not touched (out of scope to delete dead runtime surface in a test-review task). |
  | `nat_CorePanic`, `nat_CoreSetLastErr`, `nat_SerFileWriteData`/`nat_SerFileReadTextInto`, `nat_UiTestEmit`, `nat_UiRtQuit`, `nat_UiMacInitToolbox`, `nat_UiScreenBounds`, `nat_UiScreenBits` | closed, listed for completeness | All confirmed exercised on the native/Mac lane by existing infrastructure: `TestRunErrOn68k` (panic), `TestSuiteOn68k`'s ser roundtrip cases (file I/O), every native UI boot (TestEmit/RtQuit/MacInitToolbox/ScreenBounds), and the `snap` scripted command — used across a dozen+ `testdata/ui/*.events` goldens — for `ScreenBits`. `rtSetLastErr`'s truncation path is pinned by name in `core.cla`'s own header comment (`TestTextwidgetsUIScenario`'s `trunc32001` snap, one of the 23 frozen golden scenarios). |

- **datetime-instrumentation (branch `worktree-native-perf-findings`,
  2026-08-10/11, based on `map-hashtable`): DONE.** Two deliverables in
  one phase: a minimal date/time surface in the standard library, and
  always-on progress + per-phase `TickCount()` instrumentation in
  clarusc itself — the "instrument first" step the native-compiler
  performance findings doc calls for, and the fix for on-Mac compiles
  giving no sign they're running. 12 tasks, commits `8ee003f..c00188f`;
  full ledger: `.superpowers/sdd/2026-08-10-datetime-instrumentation/
  progress.md`; design: `docs/superpowers/specs/
  2026-08-10-datetime-instrumentation-design.md`.

  **Language surface — three new builtins, no new type.** `now(): int`,
  `dateTimeStr(t: int): string` (`"mm-dd-yy HH:MM:SS"`), `durationStr(secs:
  int): string` (`"Xh Ym Zs"`, leading-zero units omitted, `"-"`-prefixed
  for negative input). A datetime is a **plain `int`**: unsigned Mac-epoch
  local seconds, considered and rejected a nominal `datetime` type as
  retrofittable later. **Unsigned note (documented in the reference):**
  Mac-epoch seconds exceed 2³¹−1 in 1972, so the Mac's unsigned 32-bit
  value lands in a signed Clarus `int` and every realistic clock reading
  is negative — safe because subtraction is bit-identical signed vs.
  unsigned (mod 2³²), ordering is monotonic within the 1972-2040
  half-range, and all calendar decomposition happens inside `Secs2Date`
  (ROM) or its C glue, never in Clarus arithmetic. Difference between two
  datetimes is plain subtraction, documented rather than wrapped.

  **Toolbox catalog (`toolbox/osutils.cla`):** Date-Time Utilities added
  per the fill-the-manager standing principle — `record DateTimeRec`,
  `ReadDateTime`, `SecondsToDate`, `DateToSeconds`. `SetDateTime` is
  deliberately absent (out of scope, §12 of the design). The bit-11
  exception (`GetDateTime` is inline low-memory glue, not a real trap, so
  it can't be a Clarus extern — it gets a doc comment pointing at `now()`
  instead) is documented in both the reference and the catalog's own
  provenance comments.

  **Runtime module + lane variants:** `runtime/clarus/datetime.cla`
  (shared `rtDateTimeStr`/`rtDurationStr`, pure Clarus string building)
  plus per-lane `rtNow`: `datetime_68k.cla` (native — `peekl(0x020C)`,
  a direct read of the low-memory `Time` global, zero-cost since the
  one-second interrupt already maintains it) and `datetime_c.cla` (both
  C lanes — extern `DtTimeNow`, rendered as `rt_ext_DtTimeNow` glue).
  Decomposition strategy: let the ROM do it on native (`Secs2Date` trap,
  correct by construction) and match it with ~10 lines of C civil-date
  math on host/Retro68, pinned by shared test vectors spanning the
  unsigned range (pre-1972 positive value, modern negative-int value,
  month/year boundaries, a leap day, midnight/23:59:59) so `dateTimeStr`
  produces identical strings on every lane.

  **Instrumentation — the `feProgress` seam:** a new front-end-provided
  `feProgress(line: string)` (the `feHasKey` precedent), called from
  `drive.cla` at fixed points (`Starting`, `Compiling <file>`, `Included
  <path>` per actual read — a free liveness heartbeat during the ~17-
  runtime-module splice, `Loading runtime`, one completion line per driver
  phase boundary with `<duration> (<ticks> ticks)`, `Compiled <file> -
  <total>`, `Finished`). Host CLI (`main.cla`) routes to `log()` → stderr,
  keeping stdout clean; `ClarusC.APPL` (`macgui.cla`) buffers lines and
  flushes them into the Log textview via `gcFlushProgress` (a direct
  `w.Output.text` append), on every `gcCompile` exit path (a Task 9
  review fix — two flush holes found and closed). **Gated on `want68k`
  ONLY** — check-only/appinfo mode and non-emit host builds stay quiet, so
  every Class-A byte-golden (`TestErrorGoldens`, `reftest`, `claruscboot`,
  `emitui`, `perfgate`) stays green with no golden churn. Emitted forks
  for programs that don't use the datetime builtins are byte-identical
  before/after this phase (matched-basename fork-diff methodology, the
  map-phase's own precedent — MacBinary embeds the `-o` basename, so a
  naive byte-compare across differently-named builds is a false
  positive).

  **Two-stage bootstrap** (the map-phase pattern): Stage A (`c980554`)
  landed the builtins + runtime module + glue without clarusc using them
  internally; Stage B (`c00188f`) wired the instrumentation into clarusc
  itself. Fixed point held both times (3,261,377 B then 3,278,906 B).

  **Test-suite growth:** core suite 54 → 57 `CoreTest` cases
  (`DurationStrShapes`/`DateTimeStrVectors`/`NowSanity` — the shared
  host-vs-ROM lane-identity vectors); toolbox suite 28 → 29
  (`DateTimeRoundTrip`, hardware-proving `Date2Secs(Secs2Date(t)) == t`).
  **Emulator scope deliberately narrow, by explicit design decision:**
  `TestCoreSuiteGUIOn68k` + `TestToolboxSuiteOn68k` were the phase's ONLY
  emulator runs — no smoke tests, no scenario goldens. Both PASS on the
  first attempt, 40.6s total (core 4.79s, toolbox 35.35s); no fix round
  needed (Task 11, HEAD unchanged at `c00188f`).

  **Debt / deferrals:**
  - Live Mac Log-window painting mid-compile — the compile runs
    synchronously inside an event handler, so today's appended lines
    render only when events next process; deferred to
    `docs/superpowers/specs/2026-08-10-clarusc-mac-live-log-design.md`,
    scheduled after more Layer-1 performance work.
  - Instrumented on-Mac compile timing capture — converting the
    performance findings doc's memory-proxy ranking into real 68k tick
    timings — still pending; this phase built the instrumentation, not
    the on-Mac measurement run.
  - Host `rt_ext` glue for the catalog's Date-Time names (`ReadDateTime`/
    `SecondsToDate`/`DateToSeconds`) unadded — nothing host-side calls
    them yet; only the runtime module's private `Dt`-prefixed twins have
    glue.
  - `rt_ext_mac.inc`'s Date-Time glue is header-verified but not
    Retro68-compiled this phase (the opt-in cprint lane,
    `CLARUS_CPRINT_MAC_TESTS=1`, wasn't run) — first real compile is
    whenever that lane next runs.
  - `TestToolboxSuiteOn68k`'s doc comment (`internal/mactest/
    coresuite_test.go:260`) still says "25 result lines (24 real cases"
    — pre-existing staleness that predates this phase, now doubly stale
    at 29; not fixed (Task 12's docs sweep only touched ROADMAP/STATUS/
    the ledger, not this Go file).
  - **T2 (`scripts/test-merge.sh`) still owed before any merge** —
    standing debt carried forward from the map-hashtable phase, now
    covering this phase's commits too. Recorded here, not run.

- **layer1-compiler-perf (branch `worktree-native-perf-findings`,
  2026-08-11, based on `datetime-instrumentation`): DONE.** Worked the
  native-compiler performance findings doc's Layer 1 list (algorithmic
  bugs in clarusc itself) end to end — 19 tasks, commits
  `94bc1f1..d3581f5`; full ledger + every task's brief/report/review:
  `.superpowers/sdd/2026-08-11-layer1-compiler-perf/progress.md`; findings
  doc: `docs/superpowers/specs/2026-08-10-native-compiler-performance-
  findings.md` (now annotated per-item, see below).

  **What landed, by findings item:**
  - **§1.1** (`keywordKind` up to 33 `intern()` calls/token) — Task 1:
    lazy-init interned keyword globals (`kwInit()`/`kwInited` pattern,
    forced by the plan amendment that global initializers can't call
    `intern()` on the host-C lane).
  - **§1.2** (`exprTypeOf[numToStr(e)]` per node) — already fixed by the
    prior map-hashtable phase's `intmap` migration; verified, not
    re-touched.
  - **§1.3** (`cgHeurOnCycle` O(V²·E) whole-graph BFS) — Task 11:
    iterative Tarjan SCC, verified line-by-line; the plan's prepend-order
    CSR snippet was buggy (edge order is load-bearing for
    `cgHeurLongest`), caught by the CCFROZEN gate and fixed with
    append-order tails + a 0-mismatch debug-oracle proof.
  - **§1.4** (codegen inner-loop 256-byte string-compare scans) — Tasks
    12+13: `irIsExtern` name-index map (Task 12) and 138 call-site
    conversions to interned-int frame lookups (Task 13; the brief
    undercounted by 4).
  - **§1.5** (`cgIntr` string dispatch) — Task 14: 171 arm mappings + 20
    `IOp*` literals converted, arm order/count preserved per function.
  - **§1.6** (384-byte `A68Item` record copies in the peephole) — Tasks
    16+17: in-place field access (16), then the record itself shrunk
    384→72 bytes via int side-table indices for trap names/comments/data
    text (17).
  - **§1.7** (every function code-generated twice) — **explicitly
    deferred**, see below.
  - **§1.8** (near-free bundle) — spread across Tasks 2 (`intern`
    triple-search), 3 (~116 `I*()` string-literal re-intern helpers,
    memoized), 4 (parser cursor caching + lexer length caching), 5
    (checker int-compares: builtins/fields/members, `assignable`
    fast-path, `readOnlyPropName` memo reuse), 6 (checker string-keyed
    maps re-keyed to `intmap`), 7 (block scopes freed on exit via
    `scopesTruncate`), 8–10 (`.clear()` language feature + 70 arena-drain
    call sites converted from pop-loops), 12 (`irIsExtern`, shared with
    §1.4), 15 (`cgIntListHas` presence-bitmap for segment-pool
    membership), 18 (`a68Comment` string construction gated behind
    `--listing`). `numToStr`'s own backwards-prepend fix was **dropped as
    moot** — §1.2's fix already removed its hottest caller.
    `scopeLookup`'s de-intern was **already fixed** (single-probe
    `intmap` lookup, inherited from the map-hashtable phase).

  **Unplanned fixes found mid-phase:**
  - **Task 0b:** `macgui.cla`'s `gcFlushProgress(w: Log)` was declared
    textually before the `window Log` block, violating the file's own
    declare-before-use rule — `emit68k` of `macgui.cla` had been broken
    since `ada40fc` (the datetime-instrumentation phase). Fixed for real
    (not just the temp-reorder Task 0 used to build its oracle); the
    `/tmp/l1old/cc.bin` byte-identity oracle is reproducible from
    committed source again.
  - **Task 8b:** `.clear()`'s own arrival (Task 8) grew macgui by ~210
    new globals, which broke the 32KB code-segment limit via
    `clar_ui_fire_staterows` emitting one dispatch arm per global
    regardless of type. Fixed by restricting arms to list-typed globals
    only (the "list-typed-arms rule" — only list-typed state needs a
    staterows arm at all); macgui is back to 32 segments.
  - **Gate amendment (Task 10):** multi-segment byte-identity checks
    switched to a FROZEN A2 source tree (`/tmp/l1src`, a git-archive of
    commit `1ffb12d`) instead of the live working tree, because compiling
    the working tree's own `macgui.cla` conflates "the input changed"
    with "the compiler's behavior changed" once `macgui.cla` is itself
    among the files a task edits. Plan amended for Tasks 11-18
    accordingly.

  **Language addition:** `.clear()` for `list of T` / `map of T` /
  `intmap of T` / `sortedmap of T` (Task 8) — the runtime functions
  already existed, this added surface syntax and both backends' arms,
  enabling O(1) arena resets in Tasks 9-10 instead of pop-loop drains.
  Core suite grew 57 → 58 `CoreTest` cases (`ClearBasics`).

  **Two-stage bootstrap** (map-phase pattern): Stage A folded into Task
  8's own commit; Stage B this task's own regen (`d3581f5`). Snapshot:
  3,278,906 B (phase start) → 3,361,198 B (Stage B).

  **Measured results:**

  | Benchmark | Pre-phase | Post-phase | Speedup |
  |---|---|---|---|
  | Host self-compile (`emit clarusc/main.cla`, 10-pair median) | 0.531s | 0.465s | 1.14x |
  | `emit68k testdata/cg68k/tickprobe.cla` (10-pair median) | 0.122s | 0.034s | 3.60x |
  | `emit testdata/emitui/every.cla` (10-pair median) | 0.066s | 0.047s | 1.40x |
  | Frozen-fixture macro (`emit68k` of the frozen A2 `macgui.cla`, tracked per-task) | 2.69s (Task 0) | 0.55s (Task 18, reconfirmed post-only 0.56s) | ~4.9x |
  | Peak RSS, `emit68k tickprobe.cla` | 129.1 MB | 36.9 MB | 3.5x |
  | Peak RSS, `emit68k` frozen macgui | 882.5 MB (Task 0 baseline) | 215.3 MB | 4.1x |

  Per-task frozen-fixture macro trail (all against the same frozen A2
  `macgui.cla`): Task 0 baseline 2.69s → Task 11 (Tarjan SCC) 0.98s
  (2.7x) → Task 13 (frame-offset ints) 0.91s (2.9x) → Task 16 (in-place
  peephole) 0.65s (4.1x) → Task 17 (`A68Item` shrink) 0.56s (4.8x) →
  Task 18 (gated listing comments) 0.55s, essentially flat vs. Task 17 —
  expected, since Task 18's saving is proportional to `--listing` usage
  and this benchmark never passes it. Host self-compile A/B trail: Task 1
  0.48→0.45s, Task 3 0.51→0.50s, Task 4 0.50→0.45s (~10%) — small relative
  to the frozen-fixture 68k numbers because host codegen hot paths are
  native-side and the self-compile fixture is small; the 68k macro numbers
  are the honest headline.

  **Explicit deferrals:**
  - **§1.7 (double codegen) deferred**, not attempted this phase. The
    cheap fix (single-segment byte reuse) only helps single-segment
    programs; `ClarusC.APPL` itself is 32 segments, so it wouldn't move
    the number that matters. Full reuse needs relocation entries so
    emission becomes segment-independent — that's Layer 3 scope (caching
    and architecture), not a Layer-1 algorithmic fix.
  - `numToStr`'s prepend-loop fix dropped — moot once §1.2's caller was
    already gone (map-hashtable phase).
  - Layer 2 (systemic runtime/codegen costs: 256-byte `Str255`, `map`'s
    old string-keyed-block layout — now stale, see the findings-doc
    annotation below) and Layer 3 (architecture/caching, including
    §1.7's full fix) are both untouched this phase — explicitly out of
    scope per the findings doc's own suggested sequencing.
  - **T2 (`scripts/test-merge.sh`) still owed before any merge** — now
    covers three stacked, unmerged phases (map-hashtable,
    datetime-instrumentation, this phase). Recorded here, not run.
  - **On-Mac instrumented timing capture still pending** — the
    datetime-instrumentation phase built the `feProgress` seam and
    per-phase `TickCount()` instrumentation; nobody has yet rebuilt
    `ClarusC.APPL` from a branch carrying BOTH that instrumentation AND
    this phase's ~5x native compiler speedup and rerun the Snow
    acceptance boot to capture real on-Mac per-phase timings. That rerun
    is the next decisive experiment.

  **Test-suite growth:** core suite 57 → 58 (`ClearBasics`, Task 8);
  toolbox suite untouched (24 real cases). Emulator scope: this phase's
  ONE permitted boot, `TestCoreSuiteGUIOn68k`, PASS (58/58 cases, 0 FAIL,
  3.63s) — no toolbox suite boot, no smoke tests, by explicit
  narrow-scope design (same discipline as the datetime-instrumentation
  phase).

- **clarusc-live-log (branch `worktree-native-perf-findings`, 2026-08-11,
  based on `layer1-compiler-perf`): DONE.** Implements
  `docs/superpowers/specs/2026-08-10-clarusc-mac-live-log-design.md`
  (including its §3b same-day amendment) — the Mac half of "is a compile
  still running?": `ClarusC.APPL`'s Log window now shows live progress
  while a compile runs, instead of only repainting between event-loop
  pumps. 5 tasks (renumbered from an original Task 4/5 split during
  execution — see the plan's own amendment note), commits
  `7453b0f..b7207a0`; full ledger:
  `.superpowers/sdd/2026-08-11-clarusc-live-log/progress.md`.

  **What landed, three components:**
  1. **Runtime: synchronous paint on programmatic sets**
     (`runtime/clarus/uiwidgets.cla`) — `rtUiWidgetSetText` (textview)
     and the label branch of `rtUiWidgetSetStr` now draw immediately
     (`UiTEUpdate`/`UiTextBox` + `ValidRect`) instead of waiting for a
     deferred update event, so a set made mid-compile is visible before
     the compile returns. New `LivePaint` toolbox case
     (`testsuite/toolbox/cases_textwidgets.cla`) hardware-proves it;
     toolbox suite grew 28 → 29 real cases; `nTbCases` (which includes SelfCheck) grew 29 → 30 (`testsuite/toolbox/runner.cla`).
     Collateral: emitui/cg68k golden regens for the new draw calls.
  2. **`feProgressStep`/`feProgressTick` counted-progress seams**
     (`clarusc/drive.cla` + lane implementers) — originally landed as a
     two-int `feProgressStep(cur, total)` fed only from cg68k's
     per-segment loop (Task 2), then reshaped same-day by the §3b
     amendment (commit `b7207a0`) once the first Snow boot showed the
     bar sitting silent through a 35-minute `Measured` stretch: now
     `feProgressStep(cur: int, total: int, label: string)` announces the
     START of each of 10 fixed whole-pipeline stages (Starting
     Compilation, Parsing, Checking, Loading Runtime, Checking Whole
     Program, Lowering, Shaking, Measuring, Packing, Building Fork) plus
     one "Writing Segment s" step per segment inserted between Packing
     and Building Fork (`total` grows from 10 once Packing knows the
     segment count — the bar may jump backwards there, accepted by
     design). A new no-arg `feProgressTick()` spinner seam is called
     from long-running inner loops (cg68k's measure/emit loops,
     drive's include expansion, the whole-program check) with callers
     never throttling — macgui throttles by `TickCount()` internally.
     Both seams stay behind the same `want68k` gate as the rest of the
     progress machinery; the host CLI's `feProgressStep`/`feProgressTick`
     stay no-ops (already prints per-segment lines to stderr).
  3. **macgui: rolling ticker + status bar + spinner**
     (`clarusc/macgui.cla`) — a fixed 16-line ring (`gcTickerLines`,
     tuned down from the spec's ~18 during a fix round) repaints the Log
     window's `Output` textview live as `feProgress` lines arrive;
     `gcFlushProgress` still restores the full accumulated log
     (`base + gcProgressBuf`) at `gcCompile`'s exit points, so the
     post-compile window stays byte-identical to before this phase. A
     new `Status` label (top of window — Andrew's ruling: accepted as-is,
     not a defect, do not relocate; the DSL declaration order needed a
     dedicated fix round once `fill: both` on `Output` was found to push
     a bottom-anchored `Status` fully off-screen) renders a
     `[#####---------------] Loading Runtime (Step 4/10)`-style bar,
     `gcBarWidth = 20`. The spinner appends a rotating ASCII glyph to the
     status line, throttled to roughly every `gcSpinTicks = 30` ticks.
     `gcCompile`'s flush/exit-path restructure included a fix for the
     `emit68k`-failed path logging before the flush (message previously
     lost under the new flush semantics — Task 3 fix round 1). Two
     `clarusc.c` snapshot regens (Stage A/Stage B, map-phase pattern).

  **Frozen-scenario golden check (this task):** `TestSmokeBounceOn68k`,
  `TestUiScenariosOn68k` (`smoke_mandel`/`texteditor`/`bookmarks`
  subtests), `TestRealEventLoopTickOn68k` — all PASS, **no PBM/trace
  golden churn**. The sync-paint change is a no-op for these goldens
  because none of them captures a mid-compile Log-window frame; nothing
  to re-bless.

  **Deferred minors:**
  - The "Checking Whole Program" stage's placement inside
    `driveManifestSplice` depends on the unconditional `native.cla`
    splice keeping `neededMods` nonempty under `want68k` — a one-line
    comment documenting that dependency at the call site was not added.
  - No automated test exercises the 10-stage sequence itself (order,
    count, `total` growth at Packing) — only exercised indirectly via a
    real compile boot.

  **Open item (deferred to the Snow acceptance rerun, not this task):**
  the second scripted compile's completion is unproven — Task 3's own
  ledger note flags that only the first of two compiles in a session was
  confirmed to finish cleanly during in-branch testing.

  **Future follow-up (recorded, unscheduled):** reuse the
  `feProgressStep`/`feProgressTick` seam architecture to improve the
  HOST CLI's own compile output — a bar/spinner-style progress rendering
  on stderr, mirroring what `ClarusC.APPL` now shows. Not scheduled.

  **Snow acceptance rerun procedure note:** boot Snow at 1x — engaging
  `start_fastforward` AT BOOT hangs the launch path
  (`internal/mactest/macresident_test.go:79`) — then switch to
  fast-forward from the toolbar only once `ClarusC.APPL` is already up.
  `TickCount` is emulated, so this phase's per-stage tick instrumentation
  stays valid under fast-forward.

- **memory-leak-fix (branch `memory-leak-fix`, 2026-08-12, based on
  `clarusc-live-log`): DONE.** Root-causes and closes the cross-compile
  degradation the live-log phase's Snow reruns exposed (STATUS.md step 0):
  clarusc leaked heap blocks on every compile, in-process, on both lanes —
  harmless on the host (malloc doesn't degrade with fragmentation) but
  the direct cause of the Mac's 2-7x compile-#2 slowdown (a Memory-Manager
  zone that fills with dead-but-live blocks compile #2 must walk/compact
  around). 8 tasks, commits `bf07436..d00c2e8`; full ledger:
  `.superpowers/sdd/2026-08-12-memory-leak-fix/progress.md`;
  root-cause writeup: `docs/superpowers/specs/
  2026-08-12-cross-compile-degradation-findings.md` (now annotated
  `[FIXED]`/`[DEFERRED]` per item, see below).

  **Root causes fixed, three, plus one close-out task:**
  1. **Synthetic `__store` temps' prologue births** (Tasks 2+3, both
     lanes) — lowering's synthetic counted-store temps were
     unconditionally default-initialized (a real container birth) at
     function entry, then only released at their own store site; any
     return path that didn't reach that site leaked the birth. Fixed
     with a no-birth IR-level local flag both backends honor (NULL/0
     default-init instead), rather than adding every temp to the
     scope-exit free list (would have bloated 68k code size against the
     32KB segment ceiling). Dominant fix — took per-compile growth from
     42,845 to 5,393 blocks.
  2. **`.clear()` released no elements, plus the whole-array-value ARC
     family** (Tasks 4+5, both lanes) — `rtListClear`/`rtMapClear` were
     hard resets (count=0, no element release), silently leaking every
     reference element in a container of containers/records/text. Fixed
     with an element-aware deep-clear intrinsic (release-walk then
     reset) for ref-bearing element types, keeping the O(1) hard reset
     for scalar elements. Three fix rounds surfaced and closed a related
     family of whole-array-value ARC gaps found along the way: a KArr
     container-element release-walk gap (clear/teardown), a missing
     retain on whole-array-value container stores, a named-slot
     pop-assign leak, and a missing retain on array-typed return
     values/params.
  3. **No per-compile intern-pool reset** (Tasks 6+7) — `libReset` plus
     162 `IXxx` interned-literal caches, 4 lazy-init bool guards, 11
     `check.cla` string-keyed maps folded into `checkReset`, and `progGen`
     namespacing removed from `menuItems`/`externFirstDeclByName` (both
     now cleanly reset instead) — closes the unbounded-growth class.
     Guarded going forward by a new T1 gate,
     `TestLazyInternGuardsAreReset` (`internal/testsuite`), that fails if
     a future lazy-init guard is added without a matching reset.
  4. **This task (8):** flips `TestLeakGate`'s `DoubleCompile` subtest
     from skip to live, and regenerates the committed bootstrap snapshot
     `clarusc/clarusc.c` (Go-free fixed-point regen per
     `internal/selfhost/fixedpoint_test.go`'s `TestSnapshotFixedPoint`
     instructions) — the step that makes the fix set reach
     `ClarusC.APPL` and every other snapshot-bootstrapped build, which
     otherwise ship pre-phase codegen indefinitely.

  **Measured per-compile block growth** (`clarusc/test/dblcompile.cla`
  harness, `CLARUS_MEM_STRICT=1`, host lane — the host shows the same
  leak counts as the Mac, just without the Mac's slowdown):

  | Stage | Live blocks growth/compile |
  |---|---|
  | Pre-phase (Task 1 RED baseline) | 42,845 (19,423 lists + 695 maps + 262 texts, rc=1 on nearly every leaked box) |
  | After Task 2 (store-temp no-birth, host lane) | 5,393 |
  | After full phase (Task 8, `DoubleCompile` gate) | 0 — byte-identity oracle green on both the same-file AND alternating-file (`tickprobe`/`catprobe`-style) 3-compile variants |

  **T2 debt, unchanged by this phase (pre-existing, do not fix here):**
  `internal/selfhost`'s `TestClarusModules` has 2 standing failures —
  `asm68k_test.cla` (golden text mismatch, missing a trailing `; end of
  exerciser` comment line) and `check_test.cla` (`clarusc/check.cla:5437`
  references an undefined `driveProgressTick`) — both present before this
  phase and confirmed unchanged after the snapshot regen.

  **Validation remaining (Andrew-gated, not run this phase):** STATUS.md
  step 0/1 — a Snow two-compile rerun to confirm compile #2 now tracks
  compile #1's per-phase timing (the direct prediction of the 0-growth
  result above), then the formal Snow acceptance PASS.

- **param-abi (branch `param-abi`, 2026-08-12, based on `memory-leak-fix`):
  DONE (T1 + selfhost; T2 emulator body still owed before merge).**
  Implements the 2026-08-10 performance findings doc's §2.1 in its agreed
  "smaller cut, widened" form: design
  `docs/superpowers/specs/2026-08-12-param-abi-immutability-design.md`,
  plan `docs/superpowers/plans/2026-08-12-param-abi-immutability.md`. Two
  coupled changes: (1) **language: parameters are immutable** — rebinding
  a parameter, or storing through a value-typed parameter, is now a build
  error (checker rule + reference update); (2) **ABI: `string` and record
  parameters pass by address** (4-byte pointer) on both lanes instead of
  copying the full 256-byte `Str255`/record payload at every call site,
  with call-site classification into borrow (pass the existing address)
  vs. copy (materialize a temp first) so callee-side immutability is
  actually load-bearing at the ABI level. Storage is unchanged —
  `cgSizeOf(KStr)` stays 256, records stay inline; this is call-convention
  only, not the separate variable-length-string-storage question.

  **8 tasks, commits `94725e2..66abed3`, PLUS a final-review fix wave on
  top (UAF fix + suite case + docs + snapshot regen — see the fix-round
  bullet below for the range); full ledger:
  `.superpowers/sdd/2026-08-12-param-abi-immutability/progress.md`.**
  Task 1 migrated the 13 pre-existing param-rebinding call sites ahead of
  the language change; Task 2 added the checker rule + reference update;
  Task 3 added IR/lowering per-arg borrow/copy classification (no
  behavior change yet); Task 4 landed core-suite aliasing guard cases
  that pass both before and after the ABI flip (58 → 62 cases); Tasks 5/6
  flipped the host (cprint) and native (cg68k) lanes to by-address
  KStr/KRec params; Task 7 deleted the now-redundant callee-entry param
  retain/release walks; Task 8 (this entry) regenerated the bootstrap
  snapshot to a fixed point, ran the full selfhost gate, measured perf,
  and closed out docs.

  **Fix rounds:**
  - **Task 1:** a MacRoman 0xD1 byte in a `lib.cla` comment was corrupted
    to U+FFFD by the initial edit pass — restored byte-for-byte.
  - **Task 2 (3 Critical):** the first checker pass only gated bare
    identifiers; `file.load` record fill, `askOpen`/`askSave` (missed
    field-of-param roots), and `fromBytes`/`toBytes` method mutation all
    slipped through unguarded. Fixed via a shared `isParam`-gating helper
    threaded through the ~30-routine builtin table, with a full
    enumeration spot-check on re-review.
  - **Task 5 (1 Critical):** an ARC leak on nested-call/inline-new
    borrowed record arguments — `ECallFn`/`ENewRec` record rvalues
    reached via the `fpAddrable` fallback stripped ARC tracking through
    `fpHandoff`, so `useDoc(makeDoc())`-shaped calls leaked a handle per
    call, invisible to every existing gate. Fixed with kind-dispatch in
    `fpCallFnArg` (an `ENewRec` value is never addressable in C, so an
    exempt-list approach was rejected in favor of dispatching on the
    argument's expression kind); added a new mandatory core-suite case
    (`ParamNestedCallArg`, case 62) so the shape stays covered.
  - **Task 6 (native lane):** a hardware-only D0/D1 register clobber in
    `cgFlushArgReleases` on the 68k lane, caught only because Task 6 also
    ran the native T2 suite boots as a bonus check (62/62 core, 25/25
    toolbox, both green) — fixed once A1 was confirmed protected by
    `cgEmitRecWalkCall` itself and A0 scratch by calling convention.
  - **Final-review fix wave (both lanes, 1 Critical):** the whole-branch
    review found a use-after-free on non-owning container-read record
    temps (`gm["k"]`, a bare `EIntr` `map_get`) borrowed as call args —
    `lowArgNeedsCopy` never special-cased `EIntr` the way it already did
    `ECallFn`/`ENewRec`, so a callee that removed the just-read key mid-
    call (`use(gm["k"])` where `use` calls `gm.remove("k")`) dangled the
    borrowed handle. Fixed in lowering (reclassify every non-owning
    container-read intrinsic — map/sortedmap/intmap get/get-dv/get-dv-
    birth, list first/last — as copy) plus both backends (cg68k's
    `cgPushArgs` widened to retain+schedule the reclassified copies and
    schedule-release-only the owning `list.pop()`/`list.shift()` case
    cprint already handled via its existing copy path). New mandatory
    core-suite case `ParamContainerElemArg` (case 63). This wave's own
    commits (fix / suite case / docs / snapshot regen, in that order) are
    the four immediately following `66abed3` in `git log`; see
    `.superpowers/sdd/2026-08-12-param-abi-immutability/final-fix-report.md`
    for the full mechanics, before/after emitted code, and gate outputs.

  **Measured results (10-pair interleaved medians; old = merge-base
  `cc3f798`'s bootstrap snapshot, new = this phase's regenerated
  snapshot, both built with the current `runtime/host`):**

  | Benchmark | Old | New | Delta |
  |---|---|---|---|
  | Host self-compile (`emit clarusc/main.cla`) | 0.42s | 0.39s | 1.08x faster |
  | `emit68k testdata/cg68k/tickprobe.cla` wall time | 0.02s | 0.02s | no measurable change (10ms `time` resolution floor) |
  | Peak RSS, `emit68k tickprobe.cla` | 29.35 MB | 30.64 MB | ~4% higher |
  | `emit68k clarusc/macgui.cla` (33 segments) wall time | 0.52s | 0.46s | 1.13x faster |
  | Peak RSS, `emit68k clarusc/macgui.cla` (33 segments) | 172.5 MB | 188.1 MB | +9.05% higher |

  The macgui row uses the CURRENT working-tree `clarusc/macgui.cla` — a
  confound-free apples-to-apples input, since `git diff cc3f798..HEAD --
  clarusc/macgui.cla` is empty (Task 1 never touched it), so the same
  33-segment source compiles under both the old and new snapshot
  compiler. The layer1 phase's own `/tmp/l1src` frozen-source procedure
  was NOT used for this row (see deferred item below) — the working tree
  itself already gave a confound-free comparison.

  Honest read: `tickprobe.cla` is a tiny fixture (2-3 functions), too
  small to exercise the copy-avoidance this phase is actually for — its
  wall time and RSS are dominated by fixed compiler-process overhead. The
  macgui row is the representative signal (a real 33-segment,
  `ClarusC.APPL`-shaped compile): a genuine **1.13x wall-time win**,
  consistent with the self-compile number and with the layer1 phase's own
  observation that a large multi-segment 68k workload is where a
  call-convention win like this should show up clearest. The **RSS
  increase is real, not a small-fixture artifact** — it holds at the
  172MB real-build scale too (+9.05%), so it is recorded as an open
  question rather than explained away (see deferred item below).

  **Deferred / debt:**
  - **RSS increase (~4-9%, both fixture and real-build scale) — open
    observation, not investigated this task.** Plausible suspects: the
    new call-site copy temps (borrow/copy classification materializes
    copy temps into the existing big-temp pool — Task 3/5/6), or growth
    in classification-flag/side-table arenas the ABI flip added. Worth a
    profiling look in a future phase before further Layer-2/3 memory
    work, since a wall-time win that costs meaningfully more peak memory
    is a real tradeoff, not free.
  - **`/tmp/l1src` frozen-source procedure confirmed stale** (layer1
    phase's `docs/superpowers/plans/2026-08-11-layer1-compiler-perf.md`
    byte-identity-gate macro): its frozen source predates this phase's
    own immutable-parameters checker rule and now fails to compile
    against it (`cannot assign to parameter` on 11 pre-existing
    param-rebinding sites in the frozen
    `lib.cla`/`lower.cla`/`res68k.cla`/`cg68k.cla`/`drive.cla`). Not
    needed for the macgui row above (working-tree input sufficed), but a
    future phase relying on that specific frozen-archive procedure needs
    a fresh re-freeze taken post-param-abi.
  - **Bare-`EIntr` arg release gap, both lanes** (pre-existing, narrowed
    but not closed by Task 6): `list_pop`/`list_shift` results passed
    directly as a borrowed call argument get no scheduled release on
    either lane — pre-dates this phase, flagged again here.
  - **`KArr` param ABI still out of scope.** This phase covers `KStr`/
    `KRec` only; array parameters still copy by value at the ABI level.
  - **`toBytes` name-only guard nit** (Task 2, deferred as inert): the
    mutation guard fires on the method name alone, before the
    receiver-kind switch — harmless today because only
    `stringTextMethods` registers a method named `toBytes`, but not a
    principled check.

  **T2 owed before merge:** the full `scripts/test-merge.sh` body
  (`internal/selfhost` plus the gated native `internal/mactest` emulator
  lane) was not run this session — Andrew's merge-gate call, per
  standing project convention. T1 + the full `internal/selfhost` gate
  (including `TestSnapshotFixedPoint`, `TestClarusModules`, and
  `TestErrorGoldens`) are green.

- **runtime-ir-bake (branch `runtime-ir-bake`, 2026-08-12/13, based on
  `param-abi`): DONE, T2 GREEN (232s at `3bdbb3b`).**
  Implements precompiled-artifacts item 3 at IR depth (deepened from the
  notes doc's "pre-parsed bake" v1 during brainstorm): design
  `docs/superpowers/specs/2026-08-12-runtime-ir-bake-design.md`, plan
  `docs/superpowers/plans/2026-08-12-runtime-ir-bake.md`. Bakes the
  runtime's post-`lowerProgram` IR (superset — all 17 68k-lane modules
  lowered together, `uitest.cla` visibility-gated but always carried) into
  a stamped `'CLIR'` resource; per compile, loads it at arena base 0 and
  runs only USER code through expand/lex/parse/check/lower — check#2
  retired on the bake path, manifest-splice conditionals retired
  everywhere (the from-source path also moved to the unconditional
  superset splice, so its IR indices match a superset bake's by
  construction — the byte-identity oracle's whole premise).
  `ClarusC.APPL` consumes the resource by default; the host CLI gets an
  opt-in `--rtbake FILE` (`clarusc --bake-ir --lane 68k|c` generates the
  artifact). Full ledger:
  `.superpowers/sdd/2026-08-12-runtime-ir-bake/progress.md`.

  **7 tasks, commits `322765a..c99d95a`, a Task 7 close-out wave
  (housekeeping + snapshot regen, `c99d95a..ac423b0`), then a T2-blocker
  fix (`3bdbb3b`).** Task 1 was a probe wave (no tree commits — reverted
  after measuring; report + amendments only) that found the naive
  superset splice breaks 26/28 non-UI native fixtures (a latent
  `cg68AddRoots`/dispatcher-synthesis bug, below) and narrowed the
  "check#2 adds nothing" assumption. Task 2 fixed the dispatcher bug and
  made the from-source splice unconditional superset, re-blessing
  goldens once. Task 3 built the `'CLIR'` serializer (`clarusc
  --bake-ir`). Task 4 built the loader (`--rtbake` on the host emit
  paths) plus the leak gate's bake-path twin. Task 5 closed the
  bake-vs-from-source byte-identity gap across the full corpus (both
  lanes) through two controller-directed fix rounds plus a
  changes-requested review's own fix round — the riskiest diff of the
  phase, reviewed by Opus; **Task 5's own fix round 1 was initially
  misattributed as the T2 blocker's cause (see below) — it wasn't.**
  Task 6 wired `ClarusC.APPL` to consume the bake by default
  (`--bake-ir` embedding, stamp sidecar, `--no-bake-ir` opt-out) and
  root-caused a real, previously-**documented-but-not-fixed** cg68k
  codegen bug the bake path exposed (below), then proved the bake path
  byte-identical to the host `--rtbake` oracle for one fixture
  (`tickprobe.cla`, 68k lane) on real Snow hardware (Snow run 3). Task 7
  fixed
  three deferred review minors, regenerated the bootstrap snapshot to a
  fixed point, measured perf, wrote docs, then — running this whole
  phase's FIRST full T2 (including the gated native-emulator lane) —
  found a real regression, root-caused it in a follow-up session
  (below), and closed the phase out T2-green.

  **T2 blocker (found 2026-08-13, Task 7 Step 4; root-caused and fixed
  same day, commit `3bdbb3b`):** `CLARUS_MAC_TESTS=1 go test
  ./internal/mactest -run TestToolboxSuiteOn68k` (the gated
  native-emulator toolbox-suite boot, part of `scripts/test-merge.sh`'s
  native lane) crashed with a native runtime panic (`##CLARUS-EXIT## 3`,
  `nat_CorePanic` fired with a **completely empty message**) at the very
  first UI action inside `testsuite/toolbox/cases_popuptable.cla`'s
  `casePopuptable()` — a table-row `select` on the `PopupTableWin`
  `Marks` table widget.
  - **Two independent, genuinely latent bugs, neither introduced by this
    phase:**
    1. **`rtUiTableRelayout` (`runtime/clarus/uitable.cla`)** captured the
       table's `ListRec` master pointer BEFORE two `UiNewPtr` calls, then
       wrote `rView.top`/`.left`/`cellSize.h` through it. `NewPtr`
       allocates a NONrelocatable block, so the Memory Manager may
       compact the heap and relocate the unlocked `ListHandle` `LNew`
       returned — when it does, those pokes miss the `ListRec` entirely,
       leaving `rView` at `LNew`'s all-zero placeholder rect. The
       scripted click math then computes `row = (54 - 0) / 16 = 3` for a
       3-row table (should be 1), handing user code an out-of-range
       index — proven by arithmetic (0 is the unique `rView.top`
       producing the observed row, and 0 is exactly `uiwidgets.cla`'s
       placeholder rect), not by elimination. A scripted audit for the
       same shape (deref, then an allocating call, then a use) found
       four MORE sites with the identical bug, two of them also stale
       WRITES: `uitext.cla`'s `rtUiTeRelayout` (8 pokes),
       `ui.cla`'s `rtUiHandleUpdate` (twice), `uiwidgets.cla`'s
       `rtUiWidgetSetText`. All five now re-derive the master pointer
       immediately before use — the discipline `uitable.cla`'s own
       `rtUiTableSyncOne` already documented ("re-derive: LAddRow/LDelRow
       can move memory") but the other five sites hadn't followed.
    2. **`cgEmitPanic` (`clarusc/cg68k.cla`)** still used the
       pre-`param-abi` by-value string ABI, pushing a 256-byte `Str255`
       block for `rtPanic(msg)` — but `cgArgSlotSize(KStr) == 4` and
       `cgCurFrameIsRef` mean every `IRFunc`'s str param slot holds an
       ADDRESS now. `rtPanic` therefore read the string literal's own
       first four bytes (length byte + first three chars) as a pointer,
       which is why **every** native list-bounds-check panic printed an
       EMPTY `runtime error: ` message — masking bug 1's own diagnostic
       for a full session (the prior investigation's "empty message"
       puzzle, below). A param-abi-migration gap, missed because
       `cgEmitPanic`'s one call site (`cgListAddrFromRegs`' inline list
       bounds check) has no test that asserts the panic TEXT natively —
       fixed with a regression fixture, `testdata/runerr/listindex.cla`
       (see Verification below).
  - **`e72b92a` did not cause either bug and is untouched by the fix.**
    It changed code sizes, which changed the app heap layout, which
    changed whether the Memory Manager's compaction happened to relocate
    the `ListRec` in bug 1 — a genuine correctness bug that was equally
    present at EVERY commit in the earlier bisection table
    (`322765a` through `c99d95a`), just heap-layout-lucky at some of
    them. **Any earlier PASS of `TestToolboxSuiteOn68k`, this phase or
    before, was luck of the heap layout, not proof of correctness** —
    worth remembering before treating a green native UI boot as proof
    that handle discipline is sound.
  - **How it was found:** isolated via a code-independent flip
    (`--bake`'s own resource-fork NAME argument, `../../testdata/...`
    vs `testdata/...`, changes only the baked resource's byte length,
    not the compiled code) — `cmp` on the emitted segment images showed
    them BYTE-IDENTICAL between a passing and failing build, which
    excluded every code-layout theory (jump tables, glue-table ordinals,
    displacement overflow, segment packing, decl order) — including the
    prior session's own leading hypothesis (an A5 jump-table offset
    corruption from the Task 5 splice reorder), which was consequently
    WRONG, not merely unconfirmed. From there: grepped for the sole
    producer of `runtime error: ` (`nat_CorePanic`), found `cgEmitPanic`
    as the second, undocumented producer, reproduced its ABI bug
    standalone in 3 lines of Clarus, fixed it, rebuilt the failing
    config (now correctly naming the crash), added a temporary probe to
    localize the exact out-of-range index, and traced it to
    `rtUiTableRelayout`'s stale pointer by arithmetic. Full narrative:
    `.superpowers/sdd/2026-08-12-runtime-ir-bake/t2-blocker-fix-report.md`.
  - **Why this evaded Tasks 5/6's own byte-identity gates**: those gates
    only assert "bake-path output == from-source output," never "output
    == correct behavior" — both bugs are equally present on both paths,
    so byte-identity held while both were broken. `TestToolboxSuiteOn68k`
    is a live UI-driven behavioral boot that Task 7 Step 4 was the first
    to run for this exact composition in the whole phase.
  - **Fix does NOT preserve non-testapi byte-identity to pre-fix HEAD**,
    deliberately: `cgEmitPanic` is a real codegen bug affecting every
    native build containing a list index, not something bake-specific.
    `testdata/cg68k/*.s` / `testdata/emitui/*.c.golden` goldens
    regenerated accordingly (a 6-instruction block copy replaced by one
    address push, plus label renumbering) — exactly the expected shape
    for a genuine codegen fix, not unexplained churn.
  - **Regression test added** (Task 7 finisher, same day):
    `testdata/runerr/listindex.cla`/`.err`/`.behavior`, alongside the
    existing `oob.cla` (fixed-array OOB, an ordinary call path) in
    `TestRunErrOn68k` — `listindex` traps via `list of T` indexing,
    which resolves through `cgEmitPanic`'s inline path specifically, and
    asserts the real panic TEXT on a booted native binary. Host-side
    `internal/selfhost/behavior_test.go` auto-discovers the same fixture
    via its `testdata/runerr/*.cla` glob (T2, not T1) — its `.behavior`
    golden was generated and verified stable.
  - **Remaining, deliberately unfixed concern**: `rtUiTableClick`'s
    scripted row math still has no upper clamp against the live row
    count (its own `ponytail:` comment says so). With the relayout bug
    fixed there's no known way to reach it, but the runtime handing user
    code an out-of-range row index is a robustness hole — deliberately
    NOT clamped, since a clamp would mask the next occurrence of this
    bug class exactly the way this one was masked for a session.

  **Latent bugs found (all pre-existing, none introduced by this
  phase):**
  - **Dispatcher-synthesis gate (Task 1→2):** `cg68AddRoots` unconditionally
    roots every native `nat*`-named `IRFunc`, including `ui.cla`'s
    `nat_UiLaunchReal`, which calls `UiFireStartEmpty` — but that
    dispatcher (`clar_ui_fire_startempty`) is only synthesized when
    `irWindowDescs`/`irMenuDescs`/`irEveryCount > 0`. Splicing `ui.cla`
    into a non-UI program (a precondition of any unconditional superset
    splice, from-source or baked) therefore failed to build. Fixed by
    making dispatcher synthesis itself unconditional
    (`lowSynthUiDispatchers`), matching the splice's own new
    unconditional shape.
  - **Double-lowering + checker string-singleton crash (Task 5 round
    1):** `lastDecl` tracking through stitched-together decl chains
    double-lowered some runtime decls when the bake-vs-from-source
    corpus classification surfaced the shape; separately, the checker
    crashed on `string` not being registered as a singleton type in one
    bake-path-only code path. Both fixed; both are general correctness
    bugs, not bake-specific workarounds.
  - **cg68k `fromBytes`/`toBytes` stride-2 regression (Task 6, fix round
    1):** `cgFillTightScratchFromPaddedArr`/`cgDrainTightScratchToPaddedArr`
    kept a 2-byte-stride char-array walk after the 2026-08-04
    `cgArrElemStride` 1-byte repack, corrupting every native
    `fromBytes`/`toBytes` call since (`"rtListNew"` → `"rLsNw"`,
    byte-exact — the mechanism the bake-path resource loader tripped
    over). Fixed by correcting the stride. **Provenance correction**
    (Task 6 review): this bug was already *documented* as a known,
    deferred cg68k bug in `testsuite/toolbox/cases_resources.cla`'s
    comments since 2026-08-09 (mac-resident-clarusc phase) — Task 6
    root-caused and fixed it, but did not newly discover it. Task 7
    reverted that test's workaround to the natural
    `.toBytes()`+`buf[i]` form it had dodged, so the case now stands as
    a standing regression test for the bug class.

  **Design-claim narrowing (recorded in the design doc's own
  annotations, `docs/superpowers/specs/2026-08-12-runtime-ir-bake-design.md`):**
  - **check#2-adds-nothing:** the literal claim, probed as written, FAILS
    100% of the corpus — check#2 is currently the *only* pass that
    type-checks the runtime chain's own internal calls, not just
    user→runtime references. The design's real dependency survives
    narrowed: check#2 adds nothing *new for user code specifically* over
    check#1, which is what Task 3's bake-time one-shot runtime check
    (baked at `--bake-ir` time, not re-run per compile) plus Task 5's
    `--testapi` symbol preload actually need to uphold, and Tasks 4–5's
    full-corpus byte-identity oracle is the proof, not a standalone
    re-verification of the original claim.
  - **`--testapi` visibility:** not just `UiTest*` names. From-source
    `--testapi` check#1 sees every symbol from all 13 early-spliced
    modules (three `cases_*.cla` toolbox-suite files name raw runtime
    internals, not just `UiTest*` wrappers) — the bake path's preload
    widened to match (format v3, `bkSecCheckerVisibility`); the
    always-invisible remainder is the *manifest*-spliced modules
    (ser/sortedmap/datetime/native), never early-spliced ones.
  - **`uitest.cla` "the one `--testapi`-gated module":** true for symbol
    *visibility*, not for bake *inclusion* — the CLIR always carries
    `uitest.cla`'s lowered IR (Task 4 found this; the gate is
    checker-visibility-only, enforced at preload time, not a
    splice-time exclusion from the artifact).

  **Perf (10-pair interleaved medians, host, `/usr/bin/time -l`,
  regenerated snapshot compiler, `-O1`):**

  | Benchmark | From-source | `--rtbake` | Speedup |
  |---|---|---|---|
  | `emit68k clarusc/macgui.cla` (37 segments) wall time | 0.335s | 0.170s | ~1.97x faster |
  | Peak RSS, `emit68k clarusc/macgui.cla` | 197.0 MB | 198.8 MB | ~1% higher |
  | Host self-compile (`emit clarusc/main.cla`) wall time | 0.625s | 0.410s | ~1.52x faster |
  | Peak RSS, host self-compile | 330.6 MB | 328.1 MB | ~1% lower |
  | Bake generation (one-off), `--bake-ir --lane 68k` | 0.04s / 22.5 MB peak RSS | — | — |
  | Bake generation (one-off), `--bake-ir --lane c` | 0.02s / 18.7 MB peak RSS | — | — |

  Both host benchmarks show real, repeatable wall-time wins (raw pairs
  and both distributions in `.superpowers/sdd/2026-08-12-runtime-ir-bake/task-7-report.md`)
  with essentially flat peak RSS either way — unlike param-abi's ABI
  rewrite, this phase trades no memory for the speedup, because the win
  is "skip re-parsing/re-checking/re-lowering the runtime," not a
  storage or call-convention change. The host self-compile distribution
  is bimodal (two RSS/time clusters ~25MB apart in both from-source and
  `--rtbake` samples) — plausibly page-cache/allocator-arena variance
  between runs, not a bake-path artifact (it appears in both arms
  equally); medians are still the honest summary. The **Mac-side win**
  (the actual point of the phase) was measured on real Snow hardware in
  Task 6: a bake-path `TickProbe` compile completed in 55m2s wall clock
  (settle=55m), against the pre-phase (leak-fix investigation,
  2026-08-12) ~66m reference for the same fixture's from-source compile.
  **Caveat:** these two numbers are not a controlled pair — different
  sessions, different settle windows, and the pre-phase number predates
  this phase's own housekeeping/snapshot-regen commits — so treat "~55m
  vs ~66m" as directional (consistent with the design's ~2-4 minute
  prediction plus this phase landing on an already-fast post-leak-fix,
  post-param-abi baseline), not a precise before/after delta.

  **Deferred / phase debt:**
  - **Include-dedup fallback trigger is broad — RESOLVED (fallback-trigger-
    narrowing phase, below).** Was: Task 5 review, Important 3; explicitly
    carried to this entry per the review's own scoping: any program
    `include`-ing `toolbox/{files,standardfile,appleevents}.cla`
    (transitive bake inputs) silently fell back to a from-source compile
    for that build — correct, but loses the speedup, visible only via a
    Log line. The successor phase narrowed the trigger to genuine on-disk
    drift via a per-module source hash (CLIR v5) plus a check-only-include
    mechanism that mirrors from-source's own hoist-dedup — see that
    entry's own writeup for the mechanism and its case-(b) amendment.
  - **`rtUiTableClick`'s row math has no upper clamp** against the live
    row count (T2-blocker fix's own deliberate choice, above) — a
    robustness hole for a future instance of the same stale-master-
    pointer bug class to hide behind again. Not clamped on purpose.
  - **Object code + linker (item 3.5, the precompiled-artifacts notes
    doc's staging) — RESOLVED (object-code-linker phase, below).** The
    T2 blocker that used to gate it was already fixed; the phase itself
    landed the object sections + Measure-skip + paste link pass.
  - Everything param-abi already deferred (bare-`EIntr` arg release gap,
    `KArr` param ABI, `toBytes` name-only guard) is untouched by this
    phase, still open.
  - **Stamp-proxy gap (final-review fix wave, carried from Tasks 3/4's
    own deferred minors):** the stamp hashes the *committed*
    `clarusc/clarusc.c` snapshot, not the running binary's own source —
    a dev binary built from mid-phase, uncommitted `.cla` edits still
    stamps/checks against that same committed snapshot. Bounded and
    accepted: both the generator and every loader share the exact same
    proxy, so a bake generated and loaded by binaries built from the
    same checkout always agree, and the snapshot is regenerated at every
    phase close (`CLAUDE.md`). Longer-term fix, not attempted: hash the
    live runtime module source set instead of the bootstrap snapshot.
    **Still open** — the fallback-trigger-narrowing phase's own per-module
    hash (below) closes only the include-collision slice of this gap (a
    user-included manifest file that's drifted on disk is now detected);
    the stamp itself still hashes the committed `clarusc.c` snapshot, not
    the live runtime source set, for every OTHER path (non-collision
    drift, the stamp's own generator/loader identity check).
  - **Deliverable 5(c)'s honest narrowing** ("baked `curPathIdx` path
    stamps so runtime-attributed diagnostics/panics still name the right
    source file"): runtime-attributed diagnostics are actually an
    UNREACHABLE class on the bake path — check#1 never walks baked
    decls at all, so nothing there can ever attribute a diagnostic to
    one. `declFileTab`'s real (and only) consumer on this path is
    `bkComputeManifestPaths`' nested-include dedup, not diagnostic
    attribution. See the design doc's own `[Task 5/7 annotation]`
    entries for the sibling narrowings this joins.
  - **Standing rule:** `TestClarusCBakePathOnSnow` (opt-in,
    `CLARUS_SNOW_TESTS=1`) is the ONLY proof that `ClarusC.APPL`'s
    default bake path works on real hardware — it must be re-run
    manually after any change to `clarusc/bake.cla` or
    `clarusc/macgui.cla`; neither T1 nor T2 boots it.

  **T2 (`scripts/test-merge.sh`): GREEN at `3bdbb3b`, 232s** (T1 body
  11s, `internal/selfhost` 92s, gated native `internal/mactest` lane
  124s, `CLARUS_BAKE_FULL` bake corpus 5s). **Merge-ready from a testing
  standpoint** (merge itself remains Andrew's call, per standing
  convention).

- **fallback-trigger-narrowing (branch `fallback-trigger-narrowing`,
  2026-08-13, based on `runtime-ir-bake`/`main` at `b16e8f0`): DONE, T2
  GREEN (see below).**
  Successor to runtime-ir-bake, resolving that phase's own recorded debt
  item "include-dedup fallback trigger too broad" (above). Design
  `docs/superpowers/specs/2026-08-13-fallback-trigger-narrowing-design.md`,
  plan `docs/superpowers/plans/2026-08-13-fallback-trigger-narrowing.md`.
  Full ledger:
  `.superpowers/sdd/2026-08-13-fallback-trigger-narrowing/progress.md`.

  On the bake path, a user `include` that resolves to a bake-carried file
  (the 18 runtime modules or their nested includes — notably
  `toolbox/{files,standardfile,appleevents}.cla`, the exact files the
  toolbox cookbook tells users to compose) used to abandon the bake
  unconditionally for that compile. This phase mirrors from-source's own
  hoist-dedup by construction: on a manifest collision, parse the user's
  copy into the user chain for check#1 visibility (diagnostics attribute
  to the real file, same as from-source), then drop the parsed subtree
  before lowering — the baked IR already carries that module's lowered
  form at the hoist position, so byte-identity holds by construction. A
  new per-module source hash (CLIR format v4 → v5) scopes the remaining
  fallback to genuine on-disk drift only, logging the drifted path.

  **4 tasks, commits `fa59108..f05d15c`.** Task 1 was a probe wave (no
  tree commits — hacked `drive.cla` locally, reverted after measuring)
  that verified both load-bearing assumptions PASS (checker-state
  parity: the check-only user-position copy is the only source of a
  non-testapi collision's symbols, so there's no double-registration
  hazard to parity-check against; exact drop: zero stray IR survives a
  decl-chain-surgery sever of the parsed-but-unwanted subtree before
  `lowerProgram`), chose the drop mechanic (decl-chain surgery —
  generalizing `driveEarlySplice`'s own hoisted-skip relink loop to an
  arbitrary skip list, not a new AST-walk skip flag threaded through
  every decl consumer), and captured the exact testapi double-declare
  diagnostic text a real dedup-under-testapi resolution needs to avoid
  (10 `redeclaration of <Name>` lines, one per top-level name in the
  collided file). It also corrected a stale citation (`bkComputeManifestPaths`
  is at `bake.cla:2672`, not the plan's `2623-2631`).

  Task 2 (`fa59108`, fix round 1 `9afbf72`) implemented the mechanism:
  `expand()`'s collision branch now reads the resolved file once, hashes
  it, and compares against a new per-manifest-module hash table
  (`bkSecManifestHashes = 46`, format v5, written at `--bake-ir` time by
  walking `asmHeads` so nested includes get their own hash entry exactly
  like the 18 top-level modules) — hash-equal falls through to an
  ordinary check-only parse (case a); hash-different-or-absent sets the
  first drifted path and returns false, driving the existing fallback
  with a new log line naming the exact file (`clarusc --rtbake: <path>
  differs from the baked copy; falling back to a from-source compile`).
  Before `lowerProgram`, every collided subtree is severed from the decl
  chain the Task 1 probe proved sufficient — `combined2` is only rebuilt
  when a collision actually occurred, so the zero-collision case (the
  overwhelming majority of bake compiles) pays no cost. Under `--testapi`
  with the collided module already early-visible (preloaded checker
  symbols), the excise happens BEFORE `checkPhase1` instead (case b), so
  the parsed-but-unwanted decls never reach the checker or lowering —
  avoiding the hard double-declare Task 1's own probe proved would
  otherwise fire.

  **Unplanned addition, found mid-Task-2 by testing against the real
  toolbox-suite composition rather than a synthetic fixture:** case (b)'s
  excise-before-checker approach silently produced wrong compiles
  (`undefined: ioNamePtr`/`undefined: fdType`, etc.) for any
  record-bearing early-visible manifest module, because the ORIGINAL
  runtime-ir-bake testapi preload only ever baked
  `funcSigs`/`symbols`/`scopes`/`typeArena`/`enumMembers` — never
  `check.cla`'s own `fieldInfos`/`recFieldsHeadByName` side tables, which
  `lower.cla` also reads at lowering time. This is a real, previously
  latent gap in the original phase's preload (nothing before this task
  ever forced a record-bearing early-visible module through a
  no-parse/dedup-fully path), not something the design anticipated —
  fixed in-scope since the toolbox-suite corpus gate is one of this
  task's own required gates: a new `bkSecFieldInfo = 47` section
  (`bkSectionCount` 42 → 44) wholesale-bakes and reinstalls
  `fieldInfos`/`recFieldsHeadByName`, mirroring `bkSecCheckerSymbols`'s
  own convention.

  **Deviation from the design/plan, found by review (Task 2 fix round
  1):** the design's Interfaces line describes case (b) as "full dedup
  (no parse)"; what's actually implemented is "dedup BEFORE THE
  CHECKER" — `expand()` still lexes/parses the collided file into
  `combined` like any other include (harmless, proven content-identical
  by the hash check), and only the excise from `combined` right before
  `checkPhase1` is new. The checker and lowering never see the collided
  decls (proven by the corpus byte-identity gate), so the OBSERVABLE
  behavior matches "full dedup" — but the parse cost the design's wording
  implies removing is still paid. Root cause: the case-(a)/(b) choice
  needs `isUiProg`, which isn't known until Phase A (every `expand()`
  call) finishes, so `expand()` has no way to look ahead mid-Phase-A and
  skip parsing a file it hasn't classified yet. Chosen remedy: a
  documented amendment (drive.cla's own case-(b) doc comment states this
  plainly, with the reasoning) rather than a Phase-A restructure to defer
  the collision decision past every `expand()` call — judged a
  materially bigger, riskier change than this task's scope for a cost
  (some parse cycles on files the checker/lowering already never see)
  nothing in this phase's gates penalizes. Also annotated in the design
  spec's own "testapi interaction" section.

  Task 3 (`d8ee325`, fix round 1 `5e71b1f`) built the oracle set:
  `TestBakeFullCorpusSuiteToolbox` needed no change (Task 2 had already
  flipped it to a genuine no-fallback byte-identity assertion, matching
  `TestBakeFullCorpusSuiteCore`'s shape exactly). `TestRtbakeIncludeCheckOnly`
  (Task 2's own rename/flip of the old dedup-fallback test) was extended
  into a two-fixture table (`CoreCla`, a top-level module with real
  funcs/globals/strlits; `ToolboxFiles`, a nested pure-extern-catalog
  include) plus a negative twin,
  `TestRtbakeIncludeCheckOnlyUndefinedExternNegative`, sharpened in fix
  round 1 to reference `SFGetFile`/`SFReply` — symbols that ARE in the
  bake (a sibling nested include of the same early-spliced module) but
  NOT in the specific collided file, discriminating a real
  visibility-leak bug from the compiler simply reporting an unknown name
  outright. `TestRtbakeDriftFallback` bakes from a private temp copy of
  the runtime tree, mutates a file's bytes post-bake, and asserts the
  exact drift log line fires and the from-source fallback still succeeds
  byte-identical to a plain from-source compile — its path-identity chase
  (a nested manifest module's hash key is fixed at BAKE time via
  `bkLoadedDeclFileTab`, not recomputed against a compile-time `--rtdir`
  override) is recorded in the task report for future readers.
  `TestRtbakeTestapiIncludeParity` proves case (b) end to end on the real
  early-visible/testapi combination (no fallback, byte-identical); its
  own doc comment records why the redeclaration diagnostic shape Task 1
  captured is structurally unreachable once the real dedup lands (that
  shape only ever appeared under Task 1's own probe hack, which
  disabled the real fix to prove it was necessary). A bonus test beyond
  the plan's four,
  `TestRtbakeTestapiManifestOnlyIncludeParity` (a `--testapi` program
  directly including a NOT-early-visible manifest module,
  `runtime/clarus/sortedmap.cla`), closes a real coverage gap for Task
  2's own deferred field-info-visibility-boundary minor — passed clean
  (no bug found), kept as a standing regression oracle for that gap.

  Task 4 (housekeeping + close-out, commits `a65cdd5`, `0570af5`,
  `4d1beb4`, this entry): `macgui.cla`'s `gcResolveBakePath` fallback
  string enumerated a pre-v4 refusal set (missing the body-hash check);
  updated to `format/version/lane/stamp/body-hash mismatch`, and its doc
  comment now documents the new per-module drift fallback as a fourth
  reason category — decided later, inside `driveCompile`, surfaced
  through the same `feProgress`/`log()` seam as `gcResolveBakePath`'s own
  bakeMsg, not by this function. `cg68k.cla`'s
  `cgFillTightScratchFromPaddedArr`/`cgDrainTightScratchToPaddedArr` —
  left in place, self-documented as redundant, by runtime-ir-bake Task
  6's own stride fix — were removed initially for all four
  fromBytes/toBytes intrinsics (`cgIntrStrFromBytes`/`cgIntrStrToBytes`/
  `cgIntrTextFromBytes`/`cgIntrTextToBytes` all made to pass the array
  argument's own address straight to the runtime call); the final review
  found this unsafe for one of the four (see "Final-review fix wave"
  below), so the shipped state keeps the scratch fill for
  `cgIntrTextFromBytes` and removes it for real only in the other three.
  The bootstrap snapshot (`clarusc/clarusc.c`) was regenerated to a
  Go-free fixed point after both this task's own edit and the fix wave's
  correction — each time converged at round 1 (stage-1 snapshot → emit
  gen1 → cc → emit gen2, `cmp` identical) and reverified stable through a
  second round; `TestSnapshotFixedPoint` and the full `go test
  ./internal/selfhost -count=1 -timeout 30m` (91-93s across the two runs)
  both green each time.

  **Final-review fix wave (2026-08-13, commits `a408e2a`/`f05d15c`):** the
  whole-branch final review found the Task 4 cg68k removal above unsafe
  for `cgIntrTextFromBytes` specifically: `rtTextFromBytes`
  (`runtime/clarus/text.cla:537-556`) calls the allocating `rtTextGrow(t,
  n)` BEFORE `TextBlockMoveData(buf, mp, n)` reads through `buf` — if the
  array argument resolves into a list element's own relocatable
  Handle-backed storage (`cgForListStmt`'s own doc comment, ~cg68k.cla
  line 10648, already documents that store as relocatable), a direct
  address taken before the call can go stale by the time
  `TextBlockMoveData` uses it. The other three intrinsics' own runtime
  functions (`rtStrFromBytes`, `rtStrToBytes`, `rtTextToBytes`) do their
  BlockMove immediately with no allocating call in between — verified
  clean, confirmed to stay direct. Restored
  `cgFillTightScratchFromPaddedArr` and `cgIntrTextFromBytes`'s original
  scratch-fill shape (the array is copied into non-relocatable A6 stack
  storage before the call, so the runtime's own source address can never
  move underneath it) rather than a comment-only acknowledgment — this
  project has now found this exact stale-pointer-across-compaction bug
  class SIX times (the runtime-ir-bake T2 blocker's own five sites, plus
  this one caught before it ever shipped), which the review judged strong
  enough precedent to prefer the real fix over documenting the risk.
  **Corrected framing (also final-review, Important #2):** the golden
  gate (`go test ./internal/cg68k/... ./internal/emitui/... -count=1`,
  zero churn both before and after the fix) is **inert for this code
  path**, not evidence of correctness — no `testdata/cg68k`/
  `testdata/emitui` golden exercises `fromBytes`/`toBytes` at all, so the
  gate would show zero churn regardless of what these four functions did.
  The real evidence for the shipped shape is the source-level argument
  above (read each runtime function's own body before deciding whether
  its caller needs the scratch) plus T2's native lane
  (`testsuite/toolbox/cases_resources.cla`'s `.toBytes()`/`buf[i]` round
  trip, `testsuite/core/cases_ser.cla`) — and even those two fixtures only
  exercise LOCAL/global arrays, not a heap-resident (list-element) one, so
  neither independently proves the relocation claim either; the fix is a
  source-level correctness argument about what `rtTextGrow` can do, not
  something any current test forces to fail without it.

  **Deferred / phase debt (all from the task ledger, none newly
  introduced this task):**
  - **Drift log line can fire misleadingly under a `--rtdir` override**
    (Task 2): a resolved path with no baked hash entry (defensive
    "absent means drift" branch) doesn't distinguish "genuinely not in
    the manifest" from "hashed under a different `--rtdir` than this
    compile's" — `drive.cla:891-897` vs `bkComputeManifestPaths`'s own
    dual-keying. Not hit by any oracle in this phase (every fixture uses
    the bake-time `--rtdir`), recorded for a future `--rtdir`-mismatch
    test.
  - **Bake-time `file.readText` failure silently skips a manifest hash
    entry**, no diagnostic (`bake.cla:1415`) — would surface later as
    the "absent" defensive-drift branch above, not a crash, but with no
    direct signal at `--bake-ir` time.
  - **`bkInstallFieldInfo` runs on every testapi+UI bake compile**, not
    only case-(b) collisions (`drive.cla:1937`) — the preload contract
    widened for correctness (see the field-info gap above) rather than
    being scoped to exactly the compiles that need it. Harmless
    (wholesale replace, same convention as the existing
    `bkInstallTypeArenaPrefix`) but broader than strictly necessary.
  - **No visibility boundary on the field-table install**, unlike
    `bkSecCheckerVisibility`'s own gating — Task 3's
    `TestRtbakeTestapiManifestOnlyIncludeParity` closes the coverage gap
    (a manifest-only module's fields get installed wholesale with no
    gate) but does NOT fix the underlying gap; it passed clean because
    each compile's own `checkRecordDecl` run allocates fresh
    type-arena/decl indices for the freshly-parsed check-only copy, so
    the wholesale-installed baked entries and the user-chain entries
    don't collide today — plausible, not independently proven beyond the
    test passing. Now a standing regression oracle: if a future change
    makes them collide, this is the test that goes red.
  - **`bkSecFieldInfo` sufficiency rests on an unrecorded invariant**
    (baked modules have no `method`/`window`/`form`/`every`/`on`
    decls) — a naming/doc note at `bake.cla:2906` area was not added
    this phase; still open.
  - **`driveRebuildChainSkipping`'s membership scan lacks an early
    exit** (`drive.cla:1056-1061`) — cosmetic, collision counts are
    realistically 1-3 per compile.
  - **Drift fixture's mutation is semantically null** (Task 3): the
    `TestRtbakeDriftFallback` byte mutation is a comment-byte append, so
    the byte-compare half of the oracle proves detection only via the
    log line, not via a content-visible difference. A stronger variant
    (append a new external func and call it) is recorded but not
    implemented.
  - **Four Task 3 fixtures are written to the repo root** with
    `t.Cleanup` only (no crash-safe temp location) — a `SIGKILL`
    mid-test leaves untracked `*.cla` files. Pre-existing pattern in
    this test file, forced by include-path resolution
    (`toolbox/files.cla`-style includes resolve against `cmd.Dir`, not
    the fixture's own location).
  - **`TestRtbakeDriftFallback`'s own doc comment overstates which
    runtime the two compiles read** — only `toolbox/files.cla` comes
    from the drifted temp copy; both compiles otherwise read the repo's
    real `runtime/clarus/`. Cosmetic, not corrected this phase.
  - **`copyTree` (Task 3's new test helper) flattens file modes** to
    0644/0755 — harmless for `.cla` fixtures, would matter if ever
    reused to copy executables.
  - **Stamp-proxy gap: only the include-collision slice is closed**
    (see the runtime-ir-bake entry's own updated debt item, above) — the
    per-module hash this phase adds detects drift ONLY for a file a user
    actually `include`s and collides on; the stamp itself still hashes
    the committed `clarusc.c` snapshot for everything else. Longer-term
    fix (hash the live runtime source set) remains open, unattempted.
  - Everything else runtime-ir-bake already deferred (`rtUiTableClick`'s
    unclamped row math, object code/linker stage 3.5 readiness, every
    param-abi-era item) is untouched by this phase, still open.
  - **Standing rule still applies**: this phase touched both
    `clarusc/bake.cla` and `clarusc/macgui.cla`, so
    `TestClarusCBakePathOnSnow` (`CLARUS_SNOW_TESTS=1`) must be
    re-run manually before merge — **pending as of this entry**; the
    controller runs it separately, after final review, at the true tip.

  **T2 (`scripts/test-merge.sh`): GREEN at `4d1beb4`, 240s**, then
  **RE-RUN GREEN at `f05d15c` (post-fix-wave), 224s** (T1 body 17s,
  `internal/selfhost` 77s, gated native `internal/mactest` lane 125s,
  `CLARUS_BAKE_FULL` bake corpus 5s). Full logs:
  `.superpowers/sdd/2026-08-13-fallback-trigger-narrowing/task4-t2.log`
  (pre-fix-wave) and `task4-t2-fixwave.log` (post-fix-wave, the current
  tip's own gate result). The standing Snow rule was then satisfied at
  the same tip: `TestClarusCBakePathOnSnow` PASS (2026-08-13, 55m
  settle, 3302s, zero drift-fallback lines). **Fully gated and
  merge-ready from a testing standpoint** (merge itself remains
  Andrew's call).

- **object-code-linker (branch `precompiled-artifacts`, 2026-08-13/14,
  based on `fallback-trigger-narrowing`/`main` at `e143af1`): DONE, T2
  GREEN, Snow PASS at tip `6bf4f6e` (2026-08-14, after the C-lane UB
  fix wave — first Snow run's FAIL and its RCA are recorded below).**
  Implements the precompiled-artifacts notes doc's item 5 / stage 3.5:
  runtime function BYTES ship in the artifact on the 68k lane, so a
  `--rtbake` compile's Measure pass and per-segment emit pass both skip
  `cgEmitFunc` for every reachable runtime function, pasting its captured
  bytes with fixups instead. Design
  `docs/superpowers/specs/2026-08-13-object-code-linker-design.md` (now
  annotated where Task 1's probe amended it and where Task 3's
  fixed-bucket deviation narrowed it). Plan (4 tasks, though the plan
  numbers the close-out task "4" and folds the probe into "1" — see the
  plan doc). Full ledger:
  `.superpowers/sdd/2026-08-13-object-code-linker/progress.md`.

  **Task 1 (probe wave, commits nothing — the established
  runtime-ir-bake-era pattern):** verified all three load-bearing
  assumptions PASS against a from-scratch two-stage boot with a hacked,
  reverted `cg68ProgramFork` — 3886 cross-universe baked-function byte
  comparisons (0 masked-byte diffs, 0 size diffs, 0 A5-global-
  displacement diffs across 2179 sites) and 2923 pasted function bodies
  across 9 builds, every segment byte-identical. Six amendments to Tasks
  2-3, two of them **blocking** (implementing the spec as literally
  written would have broken byte-identity or crashed):
  - **A1 (blocking):** the spec's separate `bkRelocJt`/call-flavored
    `bkRelocSameSeg` kinds are wrong at BAKE time — `cgCallFunc` picks
    `BSR.W` vs `JSR d16(A5)` from a compile-time segment assignment the
    bake can't know, so the same runtime call site is one shape in one
    program and the other shape in another (1481 flips observed). One
    call reloc, `{offset, targetFuncIdx}`; the link pass re-emits via
    `cgCallFunc` verbatim and lets IT choose the opcode.
  - **A2 (blocking):** `cgReservePanicMsgs`' synthesized "list index out
    of range" literal (`cgListOobMsgIdx`) is appended to `irStrLits`
    AFTER the runtime prefix, so its bake-time numeric index is not
    valid at compile time — needs a symbolic reloc, resolved from the
    live global, never a stored index. Caught the hard way: the paste
    probe crashed (`UNRESERVED strlit 132`) before this was recognized.
  - A3: reloc symbol classes must cover all five pool families
    (strLit/enumTable/serdesc/uiBlob/uiEvents), the four glue labels
    (mul32/div32/mod32/freeGlobals), and the per-record RC retain/
    release walk labels — structurally reachable from runtime code even
    though none appeared in a *baked* function in the six-program probe
    corpus.
  - A4: capture representation — byte runs + typed hole records carrying
    the a68 item shape (op/size/modes/regs/other-operand value), not
    bare `{offset,kind,symbol}` (fails A1) and not full a68-item replay
    (10x artifact blow-up for zero fidelity gain, holes are under 6% of
    instruction-equivalents).
  - A5 (informational): `cg68Measure` produces sizes only, never bytes
    (`a68Finish` is never called on its stream) — Task 3's Measure skip
    is "fill the tables from the artifact," not "suppress byte
    production."
  - A6 (informational): the spec's "baked object set covers the testapi
    extras" claim is backwards-compatible-but-imprecise — capture all
    510 IRFuncs, truncate to `bkLdBaseIrFuncsCount` in `bkInstallObjCode`
    alongside the IR's own truncation; no separate testapi capture path
    is needed. (superseded by clir-load-perf: Task 7 deleted
    `bkInstallObjCode` outright — the truncation this bullet describes is
    now a live bounds check, `cgObjPasteEligible` against
    `bkRuntimeFuncBoundary`, recomputed every compile rather than staged
    once.)

  Complete empirical hole taxonomy (14,134 sites across the corpus, every
  site exactly 4 bytes): `JT` cross-segment call (6892), `FUNCPC`
  same-segment call (3904), `POOLSTR` string-pool ref (2377), `GLUEPC`
  glue-routine ref (728), `POOLUIBLOB` UI descriptor blob (164),
  `RCRELEASE` per-record release walk (41), `POOLUIEVT` `--events` blob
  (16), `RCRETAIN` per-record retain walk (6), `POOLSER` serdesc-table
  ref (4), `POOLENUM` enum value-table ref (2) — no hole ever fell into
  an "OTHER" bucket in any run, so the taxonomy is closed over the
  corpus. 431 of 493 baked runtime functions were cross-universe
  compared in this probe (62 never reachable in the six-program corpus —
  Task 4's own broader full-corpus measurement, below, narrows this
  further).

  **Task 2 (`440fa83`, fix round 1 `0047d6d`): artifact v6, bake-time
  capture, loader.** CLIR `bkFormatVersion` 5→6, `bkSectionCount` 44→46,
  two new sections: `bkSecObjCode` (id 48, per-function byte runs
  interleaved with typed hole records) and `bkSecObjMeta` (id 49, sizes/
  frame sizes/pool-ref sets/once-per-artifact fixed buckets). Bake-time
  capture (`cgObjCaptureRuntime`, hooked into `cg68ProgramFork`'s real
  per-segment pass, gated `cgBakeCapture`, zero behavior change for
  ordinary compiles) forces every runtime function reachable and runs
  the real emit once; the loader stages `bkLd*` fields, `bkInstallObjCode`
  installs post-acceptance, truncating to `bkRuntimeFuncBoundary`
  alongside `bkInstallArenas`' own IR truncation. (superseded by
  clir-load-perf: `bkInstallObjCode` is gone — Task 7's design B needed
  the pending arenas to survive un-truncated across compiles, so the
  boundary is now enforced at read time by `cgObjPasteEligible` instead
  of at install time by this function.) **Two unplanned
  mechanisms**, both direct consequences of Amendment A6's own
  "force everything reachable" instruction (which no real compile, and
  therefore none of Task 1's organically-rooted probe corpus, ever
  exercises):
  - **Callback-glue trampolines** (`cg68SynthCbGlue`'s `clar_cb_<name>`
    functions) don't exist until codegen synthesizes them, yet
    `cg68Measure`'s own unconditional `cgEmitStartup` call reaches a
    reference to one before any exist. Fixed by calling
    `cg68SynthCbGlue()` inside the capture (matching what a real compile
    always does) and adding a fourth hole kind, `cgHoleCbGlueAddr`,
    resolved symbolically by `irCbGlueNames` position rather than a
    numeric `irFuncs` index (which would dangle once the transient
    entries are trimmed back out before serialization).
  - **Reverse-waist UI dispatchers** (`clar_ui_fire_winevent` and seven
    siblings) are deliberately never part of the baked IR at all — a
    reference to one is structurally unresolvable at bake time, not just
    index-unstable. An exclude-before-rooting approach was tried and
    rejected (`shakeProgram`'s own transitive BFS defeats it — any OTHER
    rooted function calling the excluded one pulls it back in anyway).
    Fixed with taint-and-discard: the two `cgCallExtUi*` functions set a
    taint flag and return instead of `quit 1` under capture;
    `cgObjDumpSegment` leaves the tainted function's `cgObjValid` false
    instead of recording incomplete bytes — it simply isn't baked, a
    missed optimization for those specific functions, not a correctness
    gap.

  Growth (v5→v6, worktree-compared at the same commit both ways): lane
  68k **+160,859 bytes (+14.8%)**, decomposing almost exactly into the
  two new sections' own payloads (148,127 + 12,720 = 160,847 of the
  160,859, the remaining 12 being section header words) — essentially no
  incidental framing waste. Lane c **+52 bytes (+0.005%)**, exactly the
  two sections' own empty framing, confirming the "written empty on lane
  c" design held. Object-code section contents (this build): 489 of 510
  runtime `irFuncs` entries captured, 21 discarded via taint-and-skip,
  1,869 hole records, 2,358 byte runs, 96,976 bytes of raw run payload.
  Estimated resident-side cost of installing the whole flat run/hole
  payload unconditionally on a `--rtbake` load: **~180-260 KB** (order of
  magnitude, dominated by the 97 KB of run bytes plus per-value/
  per-record overhead) — not alarming for a host build; relevant to
  `ClarusC.APPL`'s own `SIZE(-1)` partition budget (mac-resident-clarusc
  phase entry).

  Self-compile segment-budget crisis (found via `TestSelfEmit68k`,
  fixed before commit): clarusc is self-hosted, so this task's own new
  top-level `var`s became more `irGlobals` entries when self-compiling
  clarusc itself, duplicated into every segment's glue bundle
  (`cgEmitRcWalks`), pushing an unrelated `cprint.cla` function
  (`cpEmitRelease`) over its 32KB single-function ceiling. Fixed by
  flattening three `list of list of int` staging globals to nine flat
  `list of int` fields, moving per-segment scratch from globals to
  locals/params, and reusing cg68k.cla's own capture-side
  `cgObjRuns`/`cgObjHoles` globals for the loader's payload instead of a
  separate pair — a live deviation from the brief's literal field
  naming, documented in-line (`bkLdObjValid`'s own doc comment).

  Fix round 1 (4 Important findings, all addressed): dormant bake-time
  invariant checks (`cgRelClsUnknown`, `cgObjDumpSegment` fails loudly
  and propagates rather than silently mis-serializing — all four
  provably unreachable on the current corpus, guarding a future emitter
  change); `bkReadObjMeta`'s trailing fixed-bucket reads moved off
  live-global writes mid-parse into locals, matching the rest of the
  file's own staging convention; wire `cls` zeroed for kinds 1/2/4 (was
  contradicting the doc table, changed zero validation behavior); the
  growth/resident-cost measurement above (I4).

  **Task 3 (`a02fa25`): Measure skip + paste-with-fixups link pass.**
  `cg68Measure`'s per-function loop skips `cgEmitFunc` for any
  `cgObjPasteEligible` function, filling size/frame/pool-ref tables from
  the artifact; `cg68ProgramFork`'s segment loop pastes the same
  functions' captured bytes instead of regenerating them. Four bugs
  found via the full-corpus gate (not by inspection), all in the
  Measure-skip's own reconstructed metadata, not the paste mechanic
  itself (which worked correctly on the first try):
  1. StrLit reconstruction appended `cgListOobMsgIdx` once per HOLE
     instead of once per function (a function can have several panic
     holes sharing one deduped pool entry — `nat_UiSFGetFile` has four).
  2. Fixing (1) got the count right but not the ORDER — the wire array
     has the panic entry filtered OUT (Amendment A2), so re-appending it
     at the end doesn't reproduce a real Measure's chronological dedup
     order, which `cgPackProgram`'s segment pool need-set accumulation
     depends on. Fixed by rebuilding a baked function's strlit set
     entirely from its own hole list, in stored order, never touching
     the wire array at all.
  3. `cgMul32Used`/`cgDiv32Used`/`cgMod32Used` (lazy program-wide flags,
     normally set as a side effect of `cgEmitFunc`) never got set for a
     baked-only user of 32-bit multiply/divide/modulo, silently dropping
     the glue routine's bytes and leaving a pasted call hole dangling.
     Fixed with `cgObjApplyGlueUsage`, replaying the side effect from the
     hole list.
  4. A stale `bkLdObjValid` surviving an in-process bake→from-source drift
     fallback (`TestRtbakeDriftFallback` crashed with an out-of-range
     index) — the recursive from-source recompile never re-ran
     `bkInstallObjCode`, so it read the aborted attempt's stale staging
     against a different `irFuncs` index space. Fixed with one line in
     `driveReset()`. (superseded by clir-load-perf: `bkInstallObjCode` no
     longer exists — `driveReset()`'s one-line fix cited here now resets
     the live `bkRuntimeFuncBoundary` global instead of the removed
     function's staging.)

  **The fixed-bucket PLAN DEFECT:** the brief's own Measure-skip bullet
  said to substitute the once-per-artifact fixed buckets
  (`cgSeg1ExtraSize`/`cgGlueBundleSize`/`cgPoolSize`) and per-pool-entry
  size tables from the artifact. The implementer read the actual
  routines that produce them first and did NOT do this, on purpose:
  `cgEmitInitGlobalsStub`/`cgEmitFreeGlobalsStub`/`cgEmitRcWalks`/
  `cgEmitPoolsBody` all measure the CURRENT PROGRAM's full
  `irGlobals`/`irRecords`/pool state — the runtime-baked prefix PLUS
  this program's own appended user globals/records/literals — while the
  artifact only ever captured a bare runtime-only baseline with zero
  user code. Substituting the baked scalar would silently UNDER-measure
  `cgPackProgram`'s own per-segment budget for any program with even one
  user `var`/`record`/literal (i.e. nearly every real program), risking
  a segment-packing decision that diverges from a from-source compile —
  breaking byte-identity on segment LAYOUT, not on any one function's
  bytes, exactly the kind of failure that shows up on some fixtures and
  not others. **The plan text was wrong; the deviation was right** —
  review confirmed this explicitly (Approved, no Critical/Important
  findings): "fixed-bucket deviation confirmed a PLAN DEFECT, implementer
  right." The per-function skip is where the real payoff lives anyway
  (these routines are cheap, proportional to `irGlobals.count`/
  `irRecords.count`/pool bytes, never to the ~500-function runtime).

  **Task 4 (this session, commits `c07882d`/`6dcf8aa` plus this entry):
  close-out.**
  - **Step 0 (housekeeping):** fixed the two stale doc comments Task 3's
    review deferred (`bkRuntimeFuncBoundary`'s own comment wrongly
    implied it was Task 3's baked-index predicate — it is not;
    `cgObjPasteEligible` reads `bkLdObjValid[i]` only, and
    `bkRuntimeFuncBoundary`'s sole consumer is `bkInstallObjCode`'s own
    truncation. (superseded by clir-load-perf: `bkInstallObjCode` is
    deleted — `bkRuntimeFuncBoundary`'s sole consumer as of Task 7 is
    `cgObjPasteEligible`'s own bounds check, a live per-compile global
    rather than staged/truncated install-time state.) The `bkLdObj*`
    section header overstated staging
    readership — the StrLit `First`/`Count`/`Flat` triple and the eight
    once-per-artifact size-bucket scalars are staged/truncated but
    deliberately never read by Task 3's Measure-skip). Added
    "deliberately unconsumed" comments to all eleven affected fields
    explaining the hazard plainly: a future reader must not wire the
    size buckets into `cg68Measure` as a shortcut, because they measure
    the bake-time runtime-only baseline, not the current program's
    universe. Comment-only, `go test ./internal/bake/... -count=1` green
    (`c07882d`).
  - **Step 0c (never-pasted coverage number):** local, uncommitted
    instrumentation (two `log()` calls — one dumping every baked/valid
    index+name once per compile, one on every real paste hit — reverted
    before commit, verified absent from a fresh emit afterward) run
    against a broader corpus than Task 1's probe: all 28
    `testdata/cg68k/*.cla` fixtures, the self-compile, `arith.cla`
    `--testapi`, the three `examples/` programs (plus `texteditor.cla`
    `--testapi`), and both suite compositions (`core`/`toolbox` `gui.cla`,
    `--testapi`) — 35 compiles, zero fallbacks, zero nonzero exits.
    **489 baked functions, 478 pasted at least once, 11 never pasted by
    any corpus program**: `rtStrIndexOfChar`, `rtTextStoreText`,
    `rtTextIndexOfChar` (string/text runtime entry points no fixture's
    code path happens to call), and eight UI-descriptor-blob accessors
    (`uidWinHandlerMask`, `uidWidgetEventMask`, `uidMenuNameOff`,
    `uidMenuName`, `uidItemNameOff`, `uidItemName`,
    `uidMenuHandlerHandlerIdx`, `uidLayoutNFields`). The 489/510 baked
    count matches Task 2's own fix-round-1 measurement exactly,
    corroborating the instrumentation. This closes Task 3's own recorded
    coverage gap ("never-pasted baked-function set unmeasured").
  - **Step 1 (snapshot regen):** `clarusc/clarusc.c` regenerated to a
    Go-free fixed point in **1 round** (cc → emit gen1 → cc → emit gen2 →
    `cmp`: identical, 4,322,988 bytes) — carries Tasks 2-3's CLIR v6
    sections and the Measure-skip/paste link pass. `go test
    ./internal/selfhost -count=1 -timeout 30m` green, **93s**, including
    `TestSnapshotFixedPoint` (`6dcf8aa`).
  - **Step 2 (docs, this entry):** this ROADMAP entry; `STATUS.md`
    rewritten as a phase close-out; the design spec annotated at the A1
    call-reloc amendment, the fixed-bucket deviation, and the two
    unplanned v6 mechanisms; the precompiled-artifacts notes doc's
    Staging section marked stage 3.5 implemented.
  - **Step 3 (T2):** `scripts/test-merge.sh`, foreground, **PASS in
    228s** (T1 body 18s, `internal/selfhost` 78s, gated native
    `internal/mactest` lane 126s, `CLARUS_BAKE_FULL` bake corpus 6s).
    Full log: `.superpowers/sdd/2026-08-13-object-code-linker/task4-t2.log`.
  - **Step 4 (Snow) is explicitly NOT this task's job** — the controller
    runs `TestClarusCBakePathOnSnow` post-final-review, at the true tip,
    per the standing rule (this phase touched `clarusc/bake.cla` and
    `clarusc/cg68k.cla`). **Pending as of this entry.**

  **Perf (Task 3's own host measurement, 10-pair interleaved medians,
  `/usr/bin/time -l`, this session's two-stage-boot host binary — NOTE:
  measured BEFORE Task 4's snapshot regen, treat as illustrative, not a
  committed SLA; a shared/loaded CI host could shift the magnitude, but
  the ~40% relative reduction should hold since it's driven by skipping
  a fixed fraction of `cgEmitFunc` calls):**

  | Fixture | from-source | `--rtbake` | Speedup |
  |---|---:|---:|---:|
  | `clarusc/macgui.cla` (emit68k) | 0.27s | 0.16s | **-41%** (1.69x) |
  | `clarusc/main.cla` self-compile (emit68k) | 0.285s | 0.185s | **-35%** (1.54x) |

  Matches the design's own expectation ("Measure is ~half of codegen and
  codegen dominates") — roughly 2/5 of wall time cut, entirely from
  skipping ~500 runtime functions' worth of `cgEmitFunc` in both Measure
  and the real per-segment pass, with zero change to the fixed-bucket/
  pool-size measurement (the PLAN DEFECT correction above).

  **Deferred / phase debt (full detail in each task's own report,
  `.superpowers/sdd/2026-08-13-object-code-linker/task-{2,3}-report.md`):**
  - **RESOLVED this task:** the two stale doc-comment minors (Task 3
    review) and the never-pasted coverage gap (Task 3's own "coverage
    gap (named)" ledger entry) — see Step 0/0c above.
  - **Taint-and-discard is silent/uncounted** (`cg68k.cla`,
    `cgObjDumpSegment` area) — a log line ("captured N of M, D
    discarded") or floor assertion would surface silent baked-set
    shrinkage; not added.
  - **`bkGetBytes` unbounded read** (`bake.cla`, ~1914-1927) — should cap
    run length against remaining section length; the attacker-artifact
    threat model is already named in `bkObjRelocSymValid`'s own comment.
  - **`bkObjRelocSymValid` never validates `kind` range** — `kind=99`
    falls through the class switch as `Label` (`bake.cla`, ~2887-2906).
  - **~484-byte segment-margin figure (Task 2's self-compile fix) is
    illustrative, not independently verified** from evidence — the
    mitigation mechanism is sound, the arithmetic isn't reproducible from
    what was measured.
  - **`srcSlot` derivation over-broad** (`cg68k.cla` ~12734) —
    `sm==AmDisp16 and sr==5` claims any A5-relative source is the hole,
    when it should be exactly the slot `cgObjHoleOf` classified.
  - **Capture-side vs load-side globals half-shared** — `cgObjRuns`/
    `cgObjHoles` stay live and correct across both capture and load, but
    `cgObjValid`/`RunFirst`/`HoleFirst`/`NHoles` are stale (capture-side
    values) after a load — a live footgun for a future reader who
    assumes symmetry; must read `bkLdObj*` for the latter.
  - **`bkRuntimeFuncBoundary` is never reset per compile** — now
    correctly documented (Step 0) as NOT the bake-compile predicate,
    but the underlying "stays whatever the last install left it, forever"
    behavior is unchanged and still worth a future reader's caution.
  - **The refusal test doesn't pin the staging discipline itself** —
    acceptable for now, noted for a future task in this area.
  - **`--listing` + `--rtbake` loses runtime function annotations**
    (bare `a68CommentMarker` vs `cgEmitFunc`'s func/param/local comments,
    zero byte impact) — worth a docs line, not written.
  - **Two independent hole-list walks + no early exit in the dedup scan**
    (`cgObjBuildFuncStrLits`/`cgObjApplyGlueUsage`) — do not "optimize"
    without measuring; both are per-function, over holes, cheap in
    practice.
  - **Perf snapshot used `/usr/bin/time real` only, no maxrss** — the
    memory story needs a fresh measurement if docs ever want to state
    one; not attempted this task.
  - **`cgObjFuncForJtSlot`'s linear scan** (Task 2, replacing an
    eliminated inverse map to save global footprint) is bake-time-only —
    a future reverse-lookup need at real COMPILE time should not reuse
    it as-is without reconsidering the cost tradeoff.
  - **`bkCorruptObjCodeTestOnly`/`--corrupt-objcode-testonly`** is a
    small, permanent, precedented (`--seglimit`) test-only hook, not
    dead code to clean up.
  - **A future fourth lazily-set program-wide codegen flag** (analogous
    to `cgMul32Used`/`cgDiv32Used`/`cgMod32Used`) would need the same
    `cgObjApplyGlueUsage`-style treatment or it will silently reproduce
    Task 3's bug 3.
  - Everything fallback-trigger-narrowing/runtime-ir-bake/param-abi
    already deferred (bare-`EIntr` arg release gap, `KArr` param ABI,
    `rtUiTableClick`'s unclamped row math, the stamp-proxy gap, etc.) is
    untouched by this phase, still open.
  - **Out of scope (design's own boundary, unchanged):** smart linking /
    IR-body removal from the 68k lane and link-time layout improvements
    (both gated behind a future oracle-relaxation decision); stage 4's
    user-module artifact cache; the pre-existing call-lowering debt class
    (address pushed across a later-evaluated allocating argument);
    the stamp-proxy-global gap.
  - **Standing rule still applies**: this phase touched
    `clarusc/bake.cla` and `clarusc/cg68k.cla` (not `macgui.cla` this
    time, but `bake.cla` alone is enough to trigger the rule), so
    `TestClarusCBakePathOnSnow` (`CLARUS_SNOW_TESTS=1`) must be re-run
    manually before merge — **pending as of this entry**; the controller
    runs it separately, after final review, at the true tip, and the run
    doubles as this phase's own headline on-hardware measurement
    (compare against the runtime-ir-bake phase's ~55m post-leak-fix
    `TickProbe` reference).

  **T2 (`scripts/test-merge.sh`): GREEN, 228s** (T1 body 18s,
  `internal/selfhost` 78s, gated native `internal/mactest` lane 126s,
  `CLARUS_BAKE_FULL` bake corpus 6s). **Snow PENDING** (standing rule,
  controller's job post-final-review). Merge remains Andrew's call.

  **Snow bake-path fix wave (2026-08-13, same branch):** the Snow run
  above DID execute and FAILED — three `CLFS-source fallback` lines
  (`.superpowers/sdd/2026-08-13-object-code-linker/snow-rerun.log`), an
  artifact-acceptance refusal, not a codegen bug. RCA
  (`snow-failure-rca.md` in the same workspace, PROVEN): `bkHashTextFrom`
  (`bake.cla:330`) computes the CLIR body-integrity hash with
  `h = h * bkFnvPrime`, and the C lane's emitted arithmetic (`fpBin`,
  `cprint.cla:1560`) prints that as plain signed `int32_t *` — signed-
  overflow UB that Apple clang -O1+ used to prove the following
  `h & 0x7FFFFFFF` mask dead and delete it. A HOST-written CLIR header's
  bodyHash therefore carried the raw *unmasked* 32-bit FNV, while the
  68k lane's real `AND.L` always applies the mask; the two agree only
  when bit 31 of the raw FNV happens to be 0 (a per-artifact coin
  flip — v5 landed heads and PASSED, v6 landed tails and FAILED).
  (superseded by clir-load-perf: the FNV-1a multiply and `bkFnvPrime`
  cited above were replaced by a djb2-shape shift-add hash — `h = ((h
  << 5) + h + b) & 0x7FFFFFFF` — in the clir-load-perf phase; this RCA's
  own fix, the `& 0x7FFFFFFF` mask, survives unchanged, since the new
  arithmetic routes the same shape through `CLAR_SHL32`/`CLAR_ADD32`.)
  Structurally invisible to every existing host-side oracle, because the
  same UB-affected binary both writes and re-checks its own hash.
  **Latent twin, also cured:** the same bug affects
  fallback-trigger-narrowing's per-module manifest drift-guard hashes —
  9 of the 27 baked runtime/toolbox modules
  (`datetime_68k.cla`/`datetime.cla`/`ser.cla`/`ui.cla`/`uidialogs.cla`/
  `uitable.cla`/`toolbox/{memory,osutils,resources}.cla`) had
  lane-divergent drift hashes, masked from view only because the
  body-hash refusal fired first.

  Fix: `fpBin`/`fpUn` (`cprint.cla`) now route the four wrap-sensitive
  operators — `* + - <<` and unary `-` — through
  `CLAR_{ADD,SUB,MUL,SHL,NEG}32` macros (new, `runtime/host/rt.h`) that
  force `uint32_t` arithmetic, so the C lane wraps by construction
  instead of by luck, matching the 68k lane's real ALU
  (`AND.L`/`MULU.L`/`ASL.L`, which never trap). Division, modulo,
  comparisons, and `>>` are unchanged — `>>` must stay a signed
  arithmetic shift to match the 68k lane's `ASR`, not become an
  unsigned/logical one. Verified: the fixed writer's bodyHash now has
  bit 31 masked, equals an independent reimplementation of the masked
  FNV over the real body bytes, agrees between `-O0` and `-O1` builds
  (the RCA's own discriminating check), and all 9 previously-divergent
  module hashes now store the masked value (confirmed against the OLD
  unfixed snapshot's own output for the same inputs). Regression-pinned
  two ways: `MiscArithWrap32` (`testsuite/core`, runs on both the host
  CLI and natively, so a lane-only-correct wrapped value fails) and
  `internal/bake`'s `TestBakeHeaderBodyHashMasked` (bit31==0 on a
  freshly generated host-side artifact, both lanes).
  `clarusc/clarusc.c` regenerated to a verified fresh fixed point (the
  fix changes the printer, so the self-hosted snapshot embeds it).

  **Correction to the RCA's own "no emitted-C goldens exist" claim:**
  19 `testdata/emitui/*.c.golden` fixtures DO exist and DID need
  regenerating (pure `CLAR_*32(...)` text substitution at every
  wrap-sensitive call site, nothing else changed; each regenerated
  golden re-verified m68k-toolchain-compile-clean). The `--bake-ir`
  artifact byte-identity gates (`internal/bake`'s
  `TestBakePathByteIdentity`/`CLARUS_BAKE_FULL` corpus) confirm the 68k
  lane's own emitted bytes are BYTE-IDENTICAL before and after this fix
  (expected: `cg68k.cla`'s native codegen never had this bug — only the
  C lane's printer did). Full gate results, per-operator reasoning, and
  before/after evidence: `fixwave-report.md` in this workspace. T2
  GREEN again post-fix. **Snow re-run PASSED at tip `6bf4f6e`**
  (2026-08-14, 55m settle, exit 0, zero fallback/drift lines): the v6
  artifact was accepted on the Mac, both on-Mac compiles took the bake
  path, and the produced forks byte-matched the host oracles — the fix
  wave is hardware-proven and the phase's standing-rule obligation is
  satisfied.

- **attempt-abort (branch `attempt-abort`, 2026-08-14, off `main` at
  `97d043c`): Tasks 1-8 (+ unplanned 6b) DONE, host gates GREEN,
  emulator verification DEFERRED — branch not yet merged.** Adds the
  language's first recoverable-error mechanism: `attempt { } aborted msg
  { }` + `abort(msg)`, cooperative flag-propagated unwinding on both
  lanes with no runtime mark stack and no `setjmp` — every frame's own
  ARC releases run on the way out via a per-function bail block
  synthesized in LOWERING (not codegen). Motivated by Andrew's own
  field session with `ClarusC.APPL` on Snow (spec §1): any of ~150
  `log(msg); quit 1` pipeline sites reachable inside a live compile
  killed the whole app with no visible error (ExitToShell) — all ~150
  are now `abort(msg)`, and `gcCompile` wraps its pipeline in
  `attempt`/`aborted` (beep + alert + return-to-idle, prior Log window
  content preserved). Also ships, same phase: pre-compile progress/
  liveness feedback in `ClarusC.APPL`, a missing app icon now warns +
  falls back to the default icon instead of failing the compile, and
  the native `out` trace file is stamped `TEXT`/`ttxt`. Design
  `docs/superpowers/specs/2026-08-14-attempt-abort-design.md` (annotated
  by Task 8 where the landed design differs from the naive spec —
  bail-block placement, the Task 6b `canAbort` narrowing, and a
  self-contradictory §6b FInfo-placement note). Plan:
  `docs/superpowers/plans/2026-08-14-attempt-abort.md`. Full ledger:
  `.superpowers/sdd/2026-08-14-attempt-abort/progress.md`. Reference
  entry: `docs/clarus-language-reference.md` Chapter 5 ("Attempt and
  Abort"), Chapter 12 (Errors' fifth category), Chapter 13 (callback
  boundary note). **Full summary: `STATUS.md` section 0a.** Deferred
  emulator checklist (run before any merge decision):
  `.superpowers/sdd/2026-08-14-attempt-abort/deferred-gates.md`.

  Headline findings, all resolved within the phase: a naive "check after
  every user call" scheme regressed clarusc's own host self-compile
  +26.3% / native `emit68k` +6.8% (10-pair medians), tripping the spec's
  own §8 deferred-item trigger; an unplanned Task 6b (interprocedural
  `canAbort` fixpoint analysis, narrowing checks from 273 to 5 in a
  sample fixture) brought both numbers to **−11.5%** host (faster than
  the pre-feature baseline outright) / **~0%** native. Two real leak
  classes were found (Task 1's own probe) and fixed, not just documented
  (a synthetic return-temp and a mid-statement transient temp, both
  abandoned on the abort path before this phase's fix — 4000→0 and
  12000→0 leaked blocks in their respective 2000-iteration probes,
  `TestAbortLeakBaseline` pins both at zero permanently). Site
  classification of all 124 real converted `abort()` sites: 84
  INTERNAL-INVARIANT / 40 USER-REACHABLE
  (`.superpowers/sdd/2026-08-14-attempt-abort/site-classification.md`).
  `TestSelfEmit68k` segment count: 51 (pre-feature) → 61 (Task 6,
  clarusc itself now abort-enabled) → 54 (Task 6b, after narrowing).
  Snapshot regenerated twice (regen #1 mid-phase, Task 5, to unblock
  clarusc's own source from using the new syntax; regen #2 at close-out,
  Task 8) — both to a verified Go-free fixed point, full
  `internal/selfhost` green including `TestSnapshotFixedPoint` both
  times. Task 8's regen #2 also found and fixed a real, previously
  latent bug: `declIsRuntimeOrigin`'s literal path-prefix check broke
  under the DEFAULT (no `--rtdir`) rtDir resolution whenever `clarusc`
  ran from anywhere but the repo root (every Go test package included),
  silently misclassifying every runtime function as non-runtime-origin
  and giving it needless bail-block machinery — fixed, after two
  superseded rounds (an initial substring search widened the dangerous
  misclassification direction; a raw-`rtDir` prefix compare re-broke
  under a `./`-prefixed `--rtdir`), by normalizing `rtDir` through the
  same `normalizePath` the decl path itself already went through, then
  directory-prefix-comparing against that; one golden reblessed
  (`testdata/cg68k/abort_bake.s`, net −327 lines of erroneous
  scaffolding removed).

  **Deferred / phase debt (final whole-branch review,
  `.superpowers/sdd/2026-08-14-attempt-abort/final-review.md`):**
  - **C-lane UI dispatcher has no abort-default check at all** (Task 3/
    Task 6b review, parked): `cprint.cla`'s synthesized UI dispatch loop
    (`runtime/clarus/ui.cla`) never emits a per-dispatch abort-default
    check, only the native 68k lane does. Fine-as-parked — the demoted
    opt-in diagnostic lane (`CLARUS_CPRINT_MAC_TESTS=1`) is not where the
    phase's shipped UI+abort consumer (`ClarusC.APPL`) builds — but
    tracked here per this review's triage rather than left
    `deferred-gates.md`-only.
  - **No automated dispatcher-default test on either lane** (Task 6b
    review M1): neither the native per-handler-dispatch abort default
    nor the C lane's narrower per-launch/per-event-loop-return default
    has a dedicated regression test; both are only exercised
    incidentally by whatever real UI+abort fixtures happen to hit them.
    The native case is realistically only emulator-testable.
  - **`declIsRuntimeOrigin`'s symlink-equivalence residual** (Task 8
    close-out): two `--rtdir` spellings that resolve to the same real
    directory only via a symlink (not lexical normalization) can still
    be misclassified — a pre-existing, shared limitation of `expand()`'s
    own key comparison, not new debt from this phase's fix rounds.
  - **`TestRunErrOn68k` can't boot the two new native-runerr fixtures**
    (Task 8 finding; cross-referenced in `deferred-gates.md` item 2):
    both `abort_uncaught`/`abort_launch_uncaught` fixtures declare `on
    App.startCLI`, which hangs cg68k's native non-UI startup stub (it
    calls every declared handler unconditionally, including `startCLI`
    with a never-marshaled `args` list) — an open design question with
    two named resolutions (native-safe `App.launch`-only twins, or
    accepting the host-side `behavior_test.go` coverage as sufficient),
    neither adopted yet.
  - **Final-review minors, left as-is (none change end behavior):** M1 —
    native non-UI startup stub has no abort check *between*
    startEmpty/startCLI/openDocument (only after the group), so an abort
    in one degenerates the next into a no-op unwind rather than skipping
    it outright; observable behavior is still correct per §3.5, and the
    path can't boot natively today regardless (same `App.startCLI` gap
    above). M3 — one unreferenced `attN_h` C label (`cprint.cla`'s
    per-function bail-label scoping is deliberately narrower than the
    dead-label check), harmless, repo doesn't build with
    `-Wunused-label`. M4 — every non-runtime function in an abort-enabled
    program pays a `__retN` local + synthetic trailing return even when
    `canAbort` is false everywhere (`lowComputeCanAbort` runs after
    `lowFuncBody`, ordering-forced); bounded by `TestSelfEmit68k`'s
    segment budget. M5 — `lowEnsureTrailingReturn` and
    `lowBuildAbortBailBlock` (`clarusc/lower.cla`) duplicate the same
    "void → `newIRReturn(-1)`, else wrap the return temp" + "walk to
    tail, append" idiom verbatim; a three-line shared helper would remove
    both. M7 — spec §5's "the CLFS-source fallback path and host
    `--rtbake` path get the same messages for free (same seams)" claim
    isn't satisfied: the landed progress ticks are `macgui.cla`-only,
    after `gcResolveBakePath`'s early return, so the CLFS-fallback and
    `--rtbake` paths get nothing; cosmetic only, on a CLI that already
    prints progress, and the load-bearing half (ClarusC.APPL's own silent
    gap) is delivered.
  - **PBM app icons rejected as malformed ON THE MAC (field test,
    2026-08-14):** Andrew's Snow session hit the icon warning ("not a
    well-formed 32x32 P1/P4 PBM") for both example icons that parse fine
    on the host. Likely cause: CR line endings — the files were staged
    via `hcopy -t` (LF→CR translation), and `app68BuildIcnFamily`'s P1
    parser presumably splits on LF only; a Mac-authored PBM would have CR
    endings too, so the parser should accept CR/CRLF/LF, the same
    treatment the lexer's own CR-byte fix got (macroman/lexer phase).
    Deferred per Andrew ("worry about that later"); the warn-and-continue
    fallback behaved exactly as designed on hardware.

  - **Native runtime panics are still SILENT app exits (field test,
    2026-08-14 — FIXED this phase, Task 9):** a real mid-segment-write
    OOM at a 12MB partition quit ClarusC.APPL with no beep and no
    alert. `nat_CorePanic` (`runtime/clarus/native.cla`) used to log
    "runtime error: <msg>" on the BUFFERED channel and call
    `natQuit(3)` — the message reached `out` only at quit's flush.
    Spec §3.7 deliberately keeps panics outside `attempt` (unchanged —
    see its own Task 9 annotation), but the original requirement's
    fallback clause ("any remaining exit should beep and display an
    alert before exiting") was dropped between requirement and spec —
    §3.5's beep+alert default only ever covered uncaught ABORTS.
    Landed fix: `nat_CorePanic` now ALSO writes the trace line
    IMMEDIATELY (hand-copies `full`'s bytes into a preallocated Str255
    scratch buffer via ordinary `string` indexing, then calls
    `natAlert` — same CR->LF + trailing-LF rendering as before, just
    flushed at panic time) IN ADDITION TO the pre-existing buffered
    `natLog` write, not instead of it — fix round 1 (review C1) found
    that dropping the buffered write moves the panic message from the
    `log` field to the `out` field of the native capture protocol
    (`internal/mactest`'s `parseCapture` splits on `natQuit`'s own exit
    markers, and the immediate write lands before them), breaking
    `TestRunErrOn68k` (which asserts against `log`); dual-writing keeps
    that test's own field expectation intact while still getting the
    crash-survival copy into `out`. Reverified: `CLARUS_MAC_TESTS=1 go
    test ./internal/mactest -run TestRunErrOn68k` PASS. Then, when a UI
    is up and NOT scripted, SysBeep(30) + `ui.cla`'s own
    `UiParamText`/`UiAlert` (called directly, no local trap duplicates)
    show the plain-OK ALRT 128 (`runtime/mac/alert.r`) with the
    message, then `natQuit(3)` as before. The "UI initialized, and not
    scripted" gate reads two already-existing signals instead of
    inventing new cross-module machinery: `natQdInited` (native.cla's
    own global, set once `nat_UiMacInitToolbox` has run ALL its Toolbox
    manager init calls including `NatInitDialogs` — fix round 1 (review
    M1) moved the flag from the top of that function to right after
    `NatInitDialogs`, so it can never read true before Alert() is
    actually safe to call; never true for a non-UI program either) AND
    `peekb(UiTestScript()) == 0` (ui.cla's own "not scripted" test,
    called directly — ui.cla turned out to already be spliced into
    every native build regardless of program shape, the runtime-ir-bake
    "full lane superset" splice applying on this lane too, so
    native.cla calling it, or calling `UiParamText`/`UiAlert` directly,
    needs no new plumbing). Deliberately NOT routed through `alert(...)`/
    `rtUiAlertMsg` (that path allocates a `text` to build its trace
    copy — unsafe on a path that must survive an out-of-memory panic
    without touching the Clarus allocator again); the beep+alert
    sequence uses only preallocated, NewPtrCLEAR'd scratch. `clarusc`'s
    own source is untouched by this fix — it lives entirely in
    `runtime/clarus/native.cla`. Scripted boots and non-UI programs
    keep today's exact headless behavior (verified: `internal/selfhost`
    and every host-only gate stay green with the native-lane cg68k
    goldens reblessed for native.cla's own byte growth). Visual
    on-hardware confirmation of the dialog itself is still an emulator
    item — added to `deferred-gates.md`.

  **Field-test data (Andrew, Snow, 2026-08-14 21:53 JST, ClarusC at
  `a0c94dc`):** all five example programs compiled on-Mac; pre-compile
  status lines and icon warning confirmed live. The OOM at 12MB was a
  PANIC-path silent exit (previous wording here wrongly claimed it as
  abort-survival — corrected; the abort path's own field confirmation
  is still outstanding, covered by the deferred Snow
  failed-compile-stays-alive test). bookmarks.cla needs between 12MB
  (OOM at segment 2) and 16MB (clean, 11m44s total); working set sits
  ~4MB until segment write/fork build peaks it. Heap-pressure
  signature confirmed: Measure took 9m14s at 12MB vs 5m52s at 16MB
  (compaction thrash) — consistent with the memory-leak-fix phase's
  degradation analysis. 16MB is a practical floor for small/medium
  programs; the 48MB default keeps its headroom rationale for
  self-compile-scale inputs.

- **clir-load-perf (branch `clir-load-perf`, 2026-08-15, off `main` at
  `42c7265`): Tasks 1-10 DONE, host T1 GREEN throughout — T2, the two
  Snow gates, and merge are DEFERRED to a phase-close session on
  Andrew's go-ahead; branch not yet merged.** Cuts the CLIR (baked-IR)
  load path's byte-by-byte hash-verify + parse cost that made a Snow
  field session clock **10m 2s** between "Verifying Baked Runtime" and
  `driveCompile`'s "Starting" line for a 1,255,314-byte artifact (spec
  §1) — three full per-byte passes over the buffer (two redundant
  header-hash *verifies*, not a write pass — `gcResolveBakePath`'s own
  `bkCheckRtbakeHeader` call and `bkLoadRtbake`'s immediate re-check of
  the identical buffer, both load-time — plus one per-byte
  `bkGetByte`/`bkGetU32` section parse), repeated on **every** compile
  in a session though the resource can't change between compiles.
  Design `docs/superpowers/specs/2026-08-15-clir-load-perf-design.md`.
  Plan (10 tasks): `docs/superpowers/plans/2026-08-15-clir-load-perf.md`.
  Full ledger: `.superpowers/sdd/2026-08-15-clir-load-perf/progress.md`.

  Three independently-landable designs, landed in dependency order (A
  first/smallest, then C's format bump, then B's more delicate
  correctness work on top of C's simpler world):
  - **A — drop the redundant verify:** `bkHeaderVerified` flag,
    consume-once; `gcResolveBakePath` sets it, `bkLoadRtbake` skips its
    own re-verify when set. Host path unchanged — nothing on host ever
    sets the flag, so the host's single verify inside `bkLoadRtbake`
    still runs every process (fine: host load is already fast and one
    compile is one process).
  - **B — parse once per app session:** `bkParsedValid` memo skips
    `bkLoadRtbake` entirely on compile #2+. The load-bearing risk was
    `bkInstallArenas`' reference-assignment aliasing (pending lists
    installed as live compiler state by reference; a live compile would
    then append user IR straight into the pending arrays through that
    alias) — fixed by copy-on-install: every reference-assigned arena
    becomes a fresh `.add`-loop copy (`record` elements are value
    types, so this is a structural fix, not a patch).
  - **C — bulk `text` range reads + CLIR v7:** four new stateless
    `text` methods (`hashStep`/`intAt`/`stringAt`/`textAt`, Chapter 3),
    the CLIR body/stamp/manifest hash swapped from FNV-mul to a
    shift-add djb2 step (the multiply was noise per the motivating
    probe; inside a per-call loop it would have become the dominant
    term), and `bake.cla`'s load path rewritten onto the four bulk
    reads behind the existing overrun soft-fail guard.
    `bkFormatVersion` 6→7 (byte layout unchanged, hash meaning
    changed).

  **Task ledger** (12 implementation commits in `42c7265..5db9e1a` — the
  branch's own off-`main` point through Task 8's snapshot regen; NOT
  `11cf5d6..5db9e1a`, which excludes `11cf5d6` itself, listed as Task 1's
  own commit below — plus this phase's docs close-out commits, `2ca3d48`/
  `889d637` and this sweep):
  1. `11cf5d6` — design A (`bkHeaderVerified` skip).
  2. `058d6f2`/`2b5a1a7`/`01c853d` — the four bulk `text` methods, host
     lane + runtime + core-suite cases + reference; fix rounds closed an
     overflow-wrapping bounds-check hole (all four range checks used a
     `pos + n > rt.len` form CLAR_ADD32 can wrap) and a negative-length
     `stringAt` hole (a `0xFFFFFFFF`-prefixed length silently returned
     `""` instead of panicking), both hardware-provable.
  3. `f57d601`/`8acf38f` — native `cg68k` arms for the four methods
     (hidden-result-pointer ABI independently re-traced by review, not
     copied from a same-shape arm).
  4. `2786a68` — CLIR v7: hash swapped to the djb2 shift-add shape.
  5. `6dc7c06`/`10d5a0d` — load-path rewrite onto the bulk reads
     (`bkGetU32`/`bkGetStr`/`bkGetBytes`), one more overflow-form
     bounds-check fix in `bkGetBytes`'s payload pre-check (plus a real
     pre-existing stack smash in `bkGetStr` closed as a side effect of
     its rewrite).
  6. Audit-only (opus, no commits): all 43 reference-assigned arenas
     confirmed MUST-COPY (root cause: `irReset`/`checkReset` clear the
     live arenas the pending lists would otherwise alias), 1 impure
     reader recorded not fixed (`bkReadObjCode` — memoization proven
     safe there by inspection), two HIGH findings (F1/F2, addressed
     below) and two spec-defect corrections (F8: the spec's "no
     truncation primitive" blocker claim was false — `list.pop` exists;
     F9: the spec's copy-cost estimate was wrong — real cost is ~31k
     copies / ~1.2MB, not what the design doc guessed).
  7. `aac55a5`/`3b44259` — design B landed: F1 (repeat compiles would
     silently disable object-code paste after compile #1) and F2
     (`bkInstallObjCode`'s destructive truncate of *pending* state) both
     solved by **deleting `bkInstallObjCode`** outright rather than
     patching it (Ruling, below); fix round closed a header-refusal
     path that pinned ~1.3MB (`bkLoadBuf`) for the session.
  8. `5db9e1a` — snapshot regen to a verified Go-free fixed point, plus
     a session-log assertion that a session loads the baked runtime
     exactly once (proves B end to end).
  9. Perf measurement (emulator, no commits — see Measured results).
  10. This entry, `STATUS.md`, and reconciling the stale
      `bkInstallObjCode` cross-references this phase orphaned (below).
  11. Post-review rename: `u32At` → `intAt` (one signed `int` type, so
      the u32 name misdescribed the return) across check/lower/ir/
      cprint/cg68k/shake/text.cla, the core-suite case, both runerr
      fixtures, and the reference, plus a snapshot regen.
  12. Post-review convention alignment: `stringAt` switched from a
      4-byte BE length prefix to a 1-byte Pascal-style prefix (matching
      `string`'s own Str255 layout and how the Toolbox world reads
      strings). The CLIR bake format itself is UNCHANGED — pool strings
      still carry a 4-byte BE length field on disk (lengths are always
      ≤255, so the high three bytes are always zero) — `bake.cla`'s
      `bkGetStr` adapts by calling `stringAt(pos + 3)`, landing on the
      real length byte. `text.cla`'s old `l < 0 or l > 255` cap check
      and "string too long" panic are impossible-by-construction now
      (a `peekb`'d byte can't exceed 255) and were deleted; deleting
      that literal reblessed the same 22 `cg68k`/19 `emitui` goldens
      this phase already reblessed twice, same class, same mechanism.
      `stringat_cap`/`stringat_negative` (the old 4-byte->255/negative
      fixtures, now dead concepts at the method level) were deleted and
      replaced by one `stringat_oor` fixture pinning the 1-byte
      payload-overrun panic.
  13. Field measurement on real emulated Mac II hardware (post-phase,
      same session): `bkInstallArenas`' remaining per-element `.add()`
      copy loops (installing the memoized-parse CLIR arenas into live
      compiler state every compile, design B's own copy-on-install fix,
      Task 7 above) cost **4m21s (15706 guest ticks)** per compile — a
      hot spot this phase's own bulk-`text`-method work never touched
      (design C target was the byte-*parse*, not the post-parse
      *install*). Fixed by a fifth bulk method through the identical
      pipeline, `list of T`'s own `l.clone()` (Chapter 3): one
      `BlockMoveData` bulk copy, checker-restricted to flat (no `text`/
      `list`/`map` anywhere) element types since it does no per-element
      retain, reusing `formForFieldIsByValue` (check.cla, the existing
      `form for T` flat-copy predicate) rather than a new type-walk.
      Every flat IR arena `bkInstallArenas` installs (`irTypes`,
      `irStmts`, `irExprs`, `irLocals`, `irFuncs`(testapi)/`irStrLits`
      (testapi), `irCbGlueNames`, `irGlobals`, `irFieldSlots`,
      `irRecords`, `irEnumMembers`, `irEnums`, the ten UI-desc/handler
      arenas, and the ten extern-registry `list of int` parallel
      arrays) switched to `.clone()`; the `Scope`/`FuncSig` lists (each
      has a reference-typed field — `names`/`params`) and the two
      `intmap of int` pending-state maps (`irLayoutNeededByName`/
      `irRcWalkNeededByName`) keep their existing loop/deep-copy
      helpers, checker-barred from `clone()` by design. `bkInstallPool`/
      `bkInstallTypeArenaPrefix`/`bkInstallFieldInfo`/
      `bkInstallCheckerSymbolsForTestapi`'s own analogous loops are OUT
      OF SCOPE for this task (not `bkInstallArenas`) and untouched.
  14. `on App.log(line: string)` (Andrew's design, post-phase, same
      branch): a generic per-line log subscriber — the optional
      top-level handler that fires once per `log(...)` call with that
      call's formatted line, after the line has already reached the
      persistent channel (host stderr / the native `##CLARUS-LOG##`
      trailer), so no handler behavior can lose it. Re-entrancy is
      guarded (a `log()` from inside the handler still persists but does
      not re-fire); runtime-internal writes never reach it (the panic
      path and both backends' uncaught-abort defaults call `natLog`/
      `rt_log` directly, and a runtime module's own `log()` keeps
      lowering to the raw intrinsic); an abort raised by the handler
      propagates out of the `log()` call site like any other callee's.
      Deliberately NOT built on the reverse-waist dispatcher family
      (`lowSynthUiDispatchers`): those are reached from the runtime
      through a bare `external func`, which is unconditional by
      construction, and this feature's hard constraint was **zero golden
      churn for handler-less programs**. Instead `lower.cla`'s
      `lowSynthAppLog` mints one ordinary `IRFunc`
      (`clar_app_fire_log`) plus one guard global, only when the handler
      is declared, and `lowCall`'s own `log` arm routes user call sites
      to it — so **both backends needed no change at all**, and
      handler-less output is byte-identical on both lanes (verified by
      old-vs-new `emit`/`emit68k` compare before the snapshot regen).
      `ClarusC.APPL` adopts it: `feProgress` is now just `log(line)` and
      the Log-window ticker/buffer work moved verbatim into the handler,
      which makes the captured `out` trailer the real, durable,
      timestamped compile log instead of one bake-path verdict line.
      Core-suite case `OnLog` (72nd, `cases_misc.cla`) pins ordering +
      the guard on both lanes; `TestMacResidentFailedCompileStaysAlive
      OnSnow`'s "Loading Baked Runtime" design-B count now names the
      `T SET`-rendered Status-bar stage line specifically (`"Loading
      Baked Runtime (Step"`), since the same words now also appear once
      in the trailer — same one-LOAD-per-session meaning, one source.

  **Measured results** (Mini vMac / Mac Plus, 8MHz 68000, 60.15 guest
  ticks/s, N=65536-byte probe buffer;
  `.superpowers/sdd/2026-08-15-clir-load-perf/task-9-report.md`):

  | pass | old (µs/byte) | new (µs/byte) | speedup |
  |---|---:|---:|---:|
  | body hash | 153.98 (`hash-exact`, per-byte) | 60.63 (`bulk-hash-chunked`, shipped 32KB-chunk shape) | **2.54x** |
  | int section-field walk (`intAt`, née `u32At`) | 200.91 (`getbyte-walk`) | 55.05 (`bulk-u32`) | **3.65x** |
  | bulk byte-range copy | 182.14 (`append-build`, per-byte `t.append`) | 0.51 (`bulk-textAt`, one call) | **359x** (dominated by one `TextBlockMoveData` call vs. 65536 single-char appends) |

  Projected onto the real 1,255,314-byte CLIR, Mac-Plus-equivalent
  guest-tick scale (old modeled as **two** load-time header-hash
  verifies — `gcResolveBakePath`'s own check plus `bkLoadRtbake`'s
  redundant re-check of the *same* buffer, both verify passes, not a
  write pass — plus one per-byte parse pass; new modeled as one
  chunked-hash pass plus one `bulk-u32`-rate parse pass, `bulk-u32`
  chosen over `bulk-textAt`'s rate as the more representative proxy for
  real field-by-field CLIR parsing): **638.8s (~10.6 min) → 145.2s
  (~2.4 min), ~4.4x.** Repeat compiles in the same session: skip verify
  and parse entirely (install only, ~2s) — design B's own target is
  smashed. All figures are Mac-Plus-scale guest ticks, extrapolated
  linearly (justified: no cache, uniform per-byte memory-access cost on
  this hardware); **no Mac II (Snow-class) boot lane exists in this
  harness to measure directly, so treat the seconds as an upper bound
  and the ~4.4x ratio — not the absolute time — as the portable
  takeaway.**

  **Honesty check against the spec's own target (§2):** the spec set
  "first-compile load window ~600s → target ≤60s, stretch ≤30s,
  Snow-class hardware, measured not promised." At Mac-Plus-equivalent
  scale the measured/projected figure is **145.2s**; even allowing for
  a Mac II's real (faster, uncorrected-for-here) hardware, the ≤60s
  target is **likely MISSED**, projected at roughly **2-2.5 minutes on
  Snow**. The **repeat-compile** target (skip verify+parse, ~2s install
  only) is met outright. **Real Snow numbers are pending the
  phase-close Snow runs** (below) — everything above is extrapolation
  from an 8MHz Mac Plus probe, not a measured Snow boot.

  **Rulings that shaped the phase:**
  - **Golden-family rebless distinction** (Task 2): the 41 churned
    compiler-output goldens (22 `cg68k` `.s` + 19 `emitui`) were
    reblessed after the implementer's own normalization diff proved the
    churn was pure literal-pool renumbering (plus one dead literal) —
    satisfies the plan's "no churn" constraint, which meant
    behavior-level goldens, not literal-numbering-stable ones.
  - **Early snapshot regen** (Task 5): forced ahead of the plan's own
    schedule — `bake.cla` started calling the new bulk methods and the
    old snapshot's checker rejects unrecognized syntax, so bootstrap
    breaks without a regen; proven safe via fixed-point + a full
    `internal/selfhost` PASS (which incidentally also exercised Task 2's
    new runerr goldens for the first time). Task 8's regen became a
    re-verify-after-6/7 rather than a fresh forcing event.
  - **Copy-on-install upheld over truncate-on-reuse** (Task 6, after
    F8/F9 disproved the spec's own blocker/cost claims): still ruled to
    stand, because it composes with the existing reset flow, where
    truncate-on-reuse would need reset-flow restructuring — corrected
    cost accepted (~31k copies, ~1.2MB, ~seconds/compile).
  - **F1/F2 solved by deleting `bkInstallObjCode`** (Task 7): rather
    than patch the function to stop clearing pending `bkLdObjValid`
    (F1) or stop destructively truncating pending state (F2), the
    implementer removed it outright — `cgObjPasteEligible` now
    bounds-checks the live `bkRuntimeFuncBoundary` global directly at
    read time, and `driveReset` resets that live boundary instead of
    resetting pending install-time staging.

  **Deferred / phase debt:**
  - **Reciprocal packers for the range-readers** (Andrew, 2026-08-15,
    post-phase): the phase added the READ half only — any program
    producing the packed forms `intAt`/`stringAt` consume still
    hand-rolls byte appends (the write half, `bkPutU32`/`bkPutStr`, is
    compiler-internal). Future language surface, sketch: helpers like
    `packedInt(i: int): string(4)` (4-byte BE) and
    `packedString(s: string)` for the 4-byte-BE length-prefixed pool
    convention, appendable via `t.append`. Design notes recorded now so
    the future spec inherits them: (a) a max-payload packed string
    overflows the `string` cap under BOTH prefix conventions
    (4+255=259, 1+255=256), so `packedString` must either return `text`
    or take the mutator shape `t.appendPackedString(s)`/
    `t.appendPackedInt(i)` — the mutator also skips the intermediate
    copy; (b) `stringAt` is now 1-byte Pascal-style (post-review
    convention alignment, task 12 below) — it reads the SAME layout
    `string` itself uses and the Toolbox world's Str255 convention
    (`bkGetStrShort`, module keys, Str255 resource interop generally),
    so no separate `pstringAt`/`appendPstring` sibling is needed for
    that case anymore; the CLIR pool's own 4-byte-BE wire field is read
    via `bake.cla`'s `bkGetStr` calling `stringAt(pos + 3)` (the wire
    field's high three bytes are provably zero for lengths ≤255, so
    `pos+3` lands on the real Pascal length byte) — a future
    `packedString` targeting the pool's wire convention would still
    produce the 4-byte-BE shape, not `stringAt`'s own 1-byte shape; (c)
    the mutator-shape recommendation from (a) stands unchanged by this
    — `stringAt`'s own 1+255=256 case was already the binding one.
  - **Runtime loop-body residual**: the bulk `text` methods still cost
    ~480 cycles/byte on Mac Plus guest ticks (`bulk-hash-chunked`'s
    60.63 µs/byte at 8MHz), roughly **10x** a straight-line
    `move.b`/`TextBlockMoveData`-class theoretical floor — future lever
    if this matters again: hand-emitted asm helpers (à la `cg_mul32`)
    or a tighter loop-codegen shape; not attempted this phase.
  - **Memo lane-tag gap** (Task 7 minor): `bkParsedValid`'s doc comment
    should say explicitly "lane cannot change mid-session," even though
    that's unreachable today.
  - **testapi single-compile coverage gap** (Task 7 minor): the
    `--testapi` install arms only ever get single-compile coverage,
    inherent to how front ends drive a compile — recorded as a phase
    fact, not a defect.
  - **`stringAt` hardware-consumption-shapes watch item** (Task 3): the
    return-arm + materialize consumption shapes are read-verified but
    not hardware-exercised; add one assertion if this corner is touched
    again.
  - **`ser.cla` still reads per-byte** (`file.save`/`file.load`) —
    deliberate spec non-goal (§2), not adopted onto the new bulk reads.
  - **`drive.cla:1854`'s "rtbakeBytes still held" parenthetical** is now
    wrong for the memoized-compile drift-interleaving case (Task 7
    minor) — stale comment, not a behavior bug.
  - **Comment-drift minors** (Task 5): `bkLoadOverrun`'s doc names only
    `bkGetByte` as a setter (four setters exist now); `rtTextStringAt`
    cites a `bkGetStr` idiom that moved to `bkGetStrShort`;
    `bkCheckRtbakeHeader`'s header doc still names `bkHashTextFrom` for
    the body walk (now chunked `hashStep`).
  - **New panic fixtures are host-only** (`testdata/runerr/
    stringat_oor` — replaces the deleted `stringat_cap`/
    `stringat_negative`, task 12 above — `textrange_overflow`,
    `textrange_oor`): pinned by `internal/selfhost/behavior_test.go`'s
    `.behavior` goldens (T1, both lanes' semantics proven equivalent by
    construction) but, unlike `oob`/`listindex`, never booted natively
    by `TestRunErrOn68k` — the same "host-pinned, no per-lane boot"
    convention test-consolidation established for panic fixtures whose
    semantic coverage doesn't need a hardware boot.
  - **`bkReadObjCode`'s `nHoles` spin** (Task 5 minor, pre-existing):
    the loop spins on a corrupt hole count before the framing check
    fires — not new to this phase, not fixed by it.
  - **Task 2/3 test- and doc-comment minors (deferred):**
    `testsuite/core/runner.cla`'s header comment (~line 78) miscounts
    `TextRange`'s ordinal ("67th real case"; actually 69th, inheriting a
    pre-existing off-by-two from the cases above it); the core case
    for `textAt` never pins its freshness contract (mutate the returned
    copy, assert the source `text` is unchanged); `stringAt`/`textAt`'s
    `EIntr` arms skip `cgAbortCheckAfterCall` like every sibling arm —
    correct today (panic-based errors, no releasable args), worth a
    half-line comment if attempt-able runtime text calls ever appear;
    `internal/mactest/coresuite_test.go` carries the 70-case count as
    two separate literals, a `const` would make the next phase's bump
    one edit instead of two.
  - **`natLogCap` is 4096 bytes** (onlog phase, item 14 above):
    `natLog` silently truncates past it, so a multi-compile
    `ClarusC.APPL` session's `##CLARUS-LOG##` trailer clips at the tail
    (one from-source compile's own progress log measures ~1.9KB).
    Deliberately not raised this task: the constant is emitted as a
    `MOVE.L #4096,D0` immediate inside `natInit`, which every native
    `.s` golden carries, so bumping it reblesses ~40 goldens for a
    ceiling no committed gate is near. Raise it (and rebless) if a real
    session ever loses lines that matter.
  - **Truncate-on-reuse recorded, not chosen** (design B's own
    alternative, spec §4): cheaper per compile (no copy) but needs a
    list-truncation primitive plus a proof no pass mutates prefix
    entries in place; revisit only if copy-on-install's cost is ever
    unacceptable.
  - **Host `--rtbake` path still verifies once per process** (design
    A, by design): the host never sets `bkHeaderVerified`, so its own
    single verify inside `bkLoadRtbake` always runs; fine, since host
    load is already fast and one compile is one process.
  - **Probe files deleted, numbers preserved above**: Task 9's
    `testdata/cg68k/hashprobe.cla` +
    `internal/mactest/hashprobe_test.go` (both throwaway, never
    committed at any point) were deleted after measurement; the working
    tree is clean.

  **Stale cross-references fixed this task:** the object-code-linker
  entry above (Task 1 Amendment A6, Task 2, Task 3 finding 4, Task 4
  Step 0) still described `bkInstallObjCode`, which Task 7 above
  deleted — each site now carries a `(superseded by clir-load-perf: …)`
  parenthetical in place, in line with this file's existing convention
  for superseded claims. `clarusc/ir.cla:375`'s `fromRuntimeModule`
  warning comment (about a different global, `bkRuntimeFuncBoundary`,
  still correct as written) gained one reconciling sentence noting that
  global is now also a live, per-compile-recomputed paste-bound global
  rather than staged-once install state — see `cgObjPasteEligible`.

**Doc-hygiene note (binary-files phase, Task 10, 2026-08-23):** three
merged phases predate this entry without their own full HISTORY
archival yet — `attempt-abort` (merged 2026-08-15), `serial-connection`
(merged 2026-08-16), and `correctness-cleanup` (merged 2026-08-18, ff
`48a4696..3a4c054`). This file otherwise ends at `clir-load-perf`
(merged 2026-08-15/16, above). Their own condensed write-ups live in
`STATUS.md`'s git history and `docs/ROADMAP.md`'s "Where we are"
section; a future docs pass should catch HISTORY up through all three
before adding a fourth phase's entry above this note. Only
`binary-files` (this entry) is archived here now, out of chronological
order with respect to the three gaps above it, because Task 10's own
brief asked for it directly.

- **binary-files (branch `binary-files`, 2026-08-22/23, based on
  `correctness-cleanup`/`main` at `3a4c054`): DONE, T2 PASS.** Closes
  ROADMAP's "Next: language usability" item 1 — all eight 68kBBS
  language gaps in one phase. Spec:
  `docs/superpowers/specs/2026-08-22-binary-files-design.md`; plan (10
  tasks + Task 9b + Task 9c inserted along the way):
  `docs/superpowers/plans/2026-08-22-binary-files.md`; full ledger:
  `.superpowers/sdd/2026-08-22-binary-files/progress.md`.
  - **`filehandle`** — a value-typed handle for positioned file I/O
    (`file.open`/`file.create`, `readAt`/`writeAt`/`append`/`size`/
    `setSize`/`flush`/`close`), a shared host+native runtime waist
    (`fileh.cla`/`fileh_c.cla`/`rt_fileh.inc` host; `fileh_68k.cla`
    native, File Manager positioned I/O via `toolbox/files.cla`'s new
    `PBGetEOF`/`SetEOF`/`GetFPos`/`SetFPos`/`FlushFile`/`FlushVol`/
    `Allocate` traps), hardware-proved on System 6 (Mini vMac) and
    System 7 (Snow). `file.create`'s doctype/creator args reuse the
    literal-4CC-argument check.
  - **`connection` as an ordinary int value** — usable as a param,
    local, or record field, not just a global (the receiver lowers via
    plain `lowExpr` instead of the old slot-lookup design; every method
    call routes through the runtime's own `h == 0` nil check).
  - **`text` binary accessors + `crc16`** — LE/word-typed
    getters/setters on `text` (`intAtLE`/`wordAt`/`wordAtLE`/
    `setIntAt`/`setIntAtLE`/`setWordAt`/`setWordAtLE`) plus a `crc16`
    method (CRC-16/KERMIT: poly 0x8408 reflected, seed 0, no final
    XOR -- published check value 0x2189 for "123456789"), chunked and
    bounds-checked, both lanes.
  - **`string(n)`** — the int-to-decimal-string conversion (`string(i)`,
    `int()`-style, joining `int()`/`fixed()`/`char()`/`ptr()` -- not the
    pre-existing bounded-capacity TYPE syntax of the same name), and
    `IntToStr` migrated onto it from the ad hoc `tkIntToStr`/`intStr`
    reimplementations scattered across the tree.
  - **`toolbox/` include fallback** — `include "toolbox/..."` that
    isn't found relative to the including file falls back to the
    compiler's own `toolbox/` directory (`<rtdir>/../../toolbox/<rest>`
    — the design spec's own `<rtdir>/../toolbox/` was off by one
    directory, corrected with a dated note in the spec rather than
    silently rewritten); `--rtdir` now works in check-only mode too,
    not just `emit`/`emit68k`, so a consumer repo outside this tree
    (68kBBS) can use the fallback without an upward-probe-visible
    `runtime/clarus/`.
  - **emit68k big-temp pool sized per function** — the old flat
    `cgBigTmpSlots` ceiling (a single statement could need at most N
    concurrently-live string/record temps) is gone; the pool is sized
    from a per-function measure pass instead, so a statement needing
    MORE temps than any prior program ever required (a 16-argument
    call, say) just works. One planned golden-rebless wave (frame sizes
    change everywhere a big temp is used) with a normalization-diff
    proof, not a blind rebless.
  - **Four compiler bugs found and fixed along the way:**
    `checkConstDecl` didn't tolerate an identical redeclaration
    reached via two different include paths (Task 2's pre-review fix,
    mirroring the pattern `externFirstDeclByName`/`xrecFirstDeclByName`
    already used); a `return call(...)` where the call's own arg needed
    a string->text coercion temp released that temp (`fpFreeStmtTmps`)
    BEFORE the `return` line that used it ever printed, a host-lane
    (`cprint.cla`) use-after-free (worked around in `fileh.cla`, then
    root-caused and fixed for real, workaround removed, Task 9b, commit
    `ba1a9a4`); the native lane's sibling bug in the same spot —
    `cg68k.cla`'s `cgReturnStmt` emitted the statement-temp RELEASE
    calls (ordinary JSRs) between the value-producing call and the
    `return`, clobbering the D0 register the call's result was sitting
    in, fixed with a D0 save/reload around the releases (only emitted
    when releases actually exist, Task 9b, commit `ba1a9a4`); and a
    `--rtbake` (baked-IR fast compile path) lowering crash for ANY
    program calling a `connection`/`filehandle` method — `lower.cla`'s
    `lowRtCoerceArg` looked up the target runtime function's param type
    by NAME through the checker's symbol table at lowering time, a
    table `--rtbake` never populates for baked runtime functions (it
    skips their parse+check for performance); found by Task 10's own
    close-out T2 run (the first time this phase `internal/bake`'s
    `CLARUS_BAKE_FULL=1` gate actually ran), root-caused via `lldb`,
    fixed in Task 9c by sourcing every runtime-call arg coercion from a
    statically-known target IR type instead of a lookup — the target
    was always fixed at compile time, no lookup was ever load-bearing.
    A new T1-speed regression (`internal/bake`'s
    `TestRtbakeConnFilehByteIdentity`, plain `go test ./internal/bake`,
    not gated) catches this specific class going forward; the broader
    testing-strategy gap it exposed (`--rtbake` as a whole has no other
    T1 smoke, only the opt-in full-corpus gate) is recorded in
    `docs/TODO.md`, alongside a separate still-live compiler robustness
    gap Task 5 found and worked around rather than fixed (an unspliced
    runtime-function reference in a native build crashes clarusc the
    same way instead of diagnosing — a different code path than either
    Task 9b or Task 9c fixed).
  - **Acceptance**: `examples/pagefile.cla` (vDB-shaped pages, a
    journal, `crc16` checksums), hardware-proved on Snow
    (`TestPageFileOnSnow`).
  - Standing rule fired: `fileh.cla`/`fileh_68k.cla` were added to
    `clarusc/bake.cla`'s native runtime module manifest, so
    `TestClarusCBakePathOnSnow` (`CLARUS_SNOW_TESTS=1`, ~55 min) needs
    a controller rerun before/at merge — not run by any task this
    phase (foreground, hardware-gated, by design).

- **transfer-crcs (branch `transfer-crcs`, 2026-08-25, based on
  `main` at `26d6748` — `binary-files` already merged): DONE, T2
  PASS.** Driven by the 68kBBS project's `docs/language-gaps.md` §8:
  XMODEM/YMODEM need CRC-16/XMODEM and ZMODEM needs CRC-32;
  `text.crc16` (binary-files phase) is CRC-16/KERMIT only. Spec:
  `docs/superpowers/specs/2026-08-25-transfer-crcs-design.md`; plan:
  `docs/superpowers/plans/2026-08-25-transfer-crcs.md`; full ledger:
  `.superpowers/sdd/2026-08-25-transfer-crcs/`. Three tasks, one commit
  each (`c4e6c31` Task 1, `213a782` Task 2, `f3e8367` Task 3), plus the
  close-out fix commit.
  - **`t.crc16x(h, pos, n)`** (Task 1, commit `c4e6c31`) — CRC-16/XMODEM,
    poly `0x1021` forward (MSB-first, no reflection), the same bitwise
    per-bit loop shape as `t.crc16` (CRC-16/KERMIT). Check value
    `0x31C3` over `"123456789"`.
  - **`t.crc32(h, pos, n)`** (Task 1) — CRC-32/ZMODEM/IEEE, reflected
    poly `0xEDB88320`, table-driven. The register is returned raw (the
    caller supplies the `0xFFFFFFFF` init and applies the final XOR);
    check value `t.crc32(0xFFFFFFFF, 0, 9) ^ 0xFFFFFFFF == 0xCBF43926`
    over `"123456789"`.
  - **Fix round 1: the `crc32` table moved from a global array to a
    heap block** (Task 1, controller ruling on a mid-task finding).
    The original design was `var rtCrc32Tab: int[256]` + a `bool` ready
    flag, both top-level runtime globals. `clarusc/cg68k.cla`'s
    `cgEmitInitGlobalsStub` default-inits every declared global at
    startup unconditionally (`cgDefaultInitAt`), and unrolls an array
    global's default-init one store per element (`cgArrDefaultAt`) —
    for a 256-int array that is 257 scalars / 514 lines of explicit
    `MOVE.L` code, added to EVERY native program's startup regardless
    of whether it calls `crc32`. This pushed 8 previously
    single-segment cg68k fixtures (`enums`, `globals`, `inline_a5`,
    `peep_clr`, `peep_pushpop`, `peep_quick`, `peep_shuffle`,
    `regnamed`) into a second segment and broke
    `internal/cg68k/image_test.go`'s single-segment assumption for
    `globals.cla`. Controller ruling: the fix belongs on the runtime
    side, not codegen. `rtCrc32Tab` became a single `ptr` global
    (`ptr(0)` until built, the existing `x == ptr(0)` null-test idiom —
    Clarus has no `nil` literal for `ptr`); `rtCrc32TabInit` allocates
    1 KB via `TextNewPtr` on first call (`ptr(0)` result → `rtPanic`,
    the same check `text.cla`'s other `TextNewPtr` sites make), fills
    it with `pokel`, and the per-byte lookup uses `peekl`. The image
    test was reverted to its base form (the single-segment assumption
    holds again). Net global-offset shift across the whole cg68k/emitui
    corpus: a uniform **+4 bytes** (one pointer, proved by joining
    `emit68k --listing`'s per-global name/offset comments across old
    vs. new by global name across four fixtures — one new global, zero
    lost, every pre-existing global shifts by exactly +4) instead of
    round 1's **+1026 bytes** (array + flag, same join technique, same
    proof shape). **Caveat carried over from the round-1 proof:** this
    +4-byte offset shift comes with a matching ~10 bytes of new
    `cg_init_globals` code (one `MOVE.L #0,D0`/`MOVE.L D0,-N(A5)` pair,
    zeroing the new pointer) in every fixture, and in fixtures that were
    ALREADY multi-segment before this phase (`abort_bake`, `bounce`,
    `strcontainers`) that small growth was enough to shift the segment
    packer's own boundary, moving one or a few functions from one
    pre-existing segment to another — JT-slot renumbering and
    `BSR.W`↔`JSR N(A5)` call-shape changes follow deterministically from
    that move. No fixture's segment COUNT changed anywhere in the
    corpus, and `globals.cla` (the one fixture
    `internal/cg68k/image_test.go` actually depends on for its
    single-segment assumption) shows a byte-for-byte identical JT-slot
    listing. `TestSmokeBounceOn68k`'s real 68k-emulator boot of
    `bounce.cla` — the most-reshuffled fixture — passes, confirming the
    reshuffle is the segment packer's normal, correct behavior on a
    fixture already packed close to its own internal boundary, not a
    bug. Rebless redone from a clean base
    (`git checkout 26d6748 -- testdata/cg68k testdata/emitui` before
    reblessing) so the final diff carries only the heap-block shape,
    not round 1's larger array-global churn: 8 stray `.seg2.s` files
    from round 1 are gone, `globals.cla` stays single-segment, and the
    per-file diffs are purely additive (one static pointer declaration
    + one zero-init line) except a `cv_rowsIdx`-style ordinal-index
    literal shifting by exactly +1 in 4 emitui goldens (a widget-table
    dispatch ID whose value depends on how many globals precede it in
    splice order) — the same deterministic mechanism as round 1, now
    proportional to one new global instead of two. All amended into a
    single commit, `0eb644f` → `c4e6c31`.
  - **The table is built lazily, not hardcoded**, because Clarus has
    no array-literal initializer (`var t: int[256]` is always
    zero-filled; `const` initializers are single literals) — filed in
    `docs/TODO.md` as its own future language-feature phase.
  - **`crc16` itself is untouched** — with `crc32` table-driven it no
    longer shares a loop with `crc16x`, so the hardware-proved
    `rtTextCrc16` stays as-is. **`app68Crc16`
    (`clarusc/app68k.cla`, the compiler's own CRC-16/XMODEM used for
    `.APPL` checksums) is deliberately NOT converted to call
    `rtTextCrc16X`** — it lives in the compiler, which the committed
    `clarusc/clarusc.c` bootstrap snapshot must still be able to
    compile; wiring it to a runtime intrinsic would break the
    bootstrap until the snapshot is regenerated, not worth the
    coupling for a 124-byte header.
  - **Core suite coverage** (Task 2, commit `213a782`):
    `testsuite/core/cases_textbinary.cla`'s `caseCrc16` grew XMODEM and
    ZMODEM vectors (one-shot/chunked/`n==0`/table-reuse assertions, no
    new `CoreTest` enum member, no case-count site touched). Proved on
    real 68000 hardware (`TestCoreSuiteGUIOn68k`, System 6, Mini vMac)
    — the aggregate suite-boot check (`PASS ` line count/`TOTAL`
    reconciliation, no per-case subtests for `core`) covers `Crc16`
    among all 78 cases.
  - **Snow timing probe.** Task 2's own attempt (a TickCount-bracketed
    `crc16`/`crc16x`/`crc32` timing loop over a 64 KB buffer) collided
    with a second, unrelated Snow instance sharing this machine's
    display — a concurrent session's own active work, both windows
    spawning at the identical screen position — and was aborted rather
    than risk clicking into someone else's window. A controller rerun
    (`build-run/crctime.cla`, unchanged) completed cleanly on a Mac II
    (16 MHz 68020, model `MacIIFDHD`) Snow instance, read from the
    app's captured out-file (byte-exact, the same mechanism
    `TestSnowRoundTrip` trusts) rather than an on-screen alert — no
    alert dialog was ever observed during the run despite several
    clean, uncontested screenshots, though the clean `##CLARUS-EXIT##
    0` trailer confirms the run completed normally. Single run, no
    repeats. Results (64 KB buffer, ticks at 1/60 s each): `crc16`
    (KERMIT, bitwise) 277 ticks (≈70.4 µs/byte); `crc16x` (XMODEM,
    bitwise) 287 ticks (≈73.0 µs/byte); `crc32` (table-driven) 120
    ticks (≈30.5 µs/byte) — `crc32` ≈2.3-2.4x faster than either
    bitwise loop, less than the ~5x a table alone would suggest (the
    per-byte loop/`peekb`/`peekl` overhead dominates on a 68020). At
    that rate a 1 KB ZMODEM subpacket costs ≈31 ms of `crc32` time
    against the ~180 ms it takes to arrive at 57600 bps (≈72 ms with
    the bitwise loop). Full trail, screenshots, and the raw out-file:
    `.superpowers/sdd/2026-08-25-transfer-crcs/snow-probe-report.md`.
  - **Close-out (Task 3)**: bootstrap snapshot regenerated
    (`TestSnapshotFixedPoint` PASS) and the `.behavior` golden for
    `testdata/run/crc16.cla` — hand-written in Task 1 because the
    committed snapshot didn't know `crc16x`/`crc32` until this task —
    re-verified against the real bless: byte-identical to the
    hand-written version. The real bless surfaced one legitimate new
    artifact the addendum didn't anticipate: a live-leak mismatch
    (`testdata/run/crc16.leaks`, content `1`) for the `crc32` table's
    intentional never-freed heap block (a process-lifetime cache, per
    its own `ponytail:` comment) — precedented by the test-suite-review
    phase's `for_loop_var_alias.leaks`, same mechanism.

- **filesystem-api (branch `filesystem-api`, 2026-08-26, based on
  `main` at `8b8e8e2` — `transfer-crcs` already merged to local `main`,
  NOT pushed): DONE, T2 PASS.** Driven by the 68kBBS project's
  `docs/language-gaps.md` §1/§2/§3/§5/§6/§7: FTN packet directory
  management, catalog dates, and HFS-shaped names had no Clarus surface
  before this phase. Spec:
  `docs/superpowers/specs/2026-08-26-filesystem-api-design.md`; plan:
  `docs/superpowers/plans/2026-08-26-filesystem-api.md`; full ledger:
  `.superpowers/sdd/2026-08-26-filesystem-api/`. Seven tasks (Task 1 a
  probe wave, no code commit), one feat commit + one fix-round commit
  each thereafter, plus this close-out commit.
  - **`file.makeDir/delete/list/exists/info/setInfo/rename/move`**
    (Tasks 3-5, both lanes): `makeDir(path): bool` (one level, parent
    must exist), `delete(path): bool` (file or empty folder),
    `list(path, names: list of string): bool` (names-only, catalog
    order, `""` = program's own folder), `exists(path): bool` (never
    sets `lastError`), `info(path): FileInfo` (returns the record
    directly, zeroed + `lastError` set on failure), `setInfo(path,
    type, creator, created, modified): bool` (`0` date = leave
    unchanged), `rename(path, newName): bool` (leaf name, not a path),
    `move(path, dirPath): bool` (same volume only).
  - **`FileInfo` prelude mechanism** (Task 1 probe, Task 3 build): a
    new `runtime/clarus/prelude.cla` declares the predeclared 7-field
    `FileInfo` record. `clarusc/drive.cla`'s `driveCompile` parses it
    via `expand()` as the very FIRST file, before the user's own
    `entries` loop, so `FileInfo` is visible to the STANDALONE
    (user-code-only) check on every lane/mode, not only whole-program
    builds. Two new globals, `drvPreludeHead`/`drvPreludeAsmIdx`, let
    `driveManifestSplice` strip prelude's decl out of the ordinary
    runtime-module chain it rebuilds for `combined2` and re-prepend it
    once, unconditionally, as `combined2`'s true first thing (a missing
    prelude splice would otherwise land `FileInfo` AFTER `fileh.cla`'s
    own `rtFhInfo(path): FileInfo` signature, an undefined-type error
    inside the runtime itself). A missing/undiscoverable `prelude.cla`
    is never a hard `abort()` — Task 3 found two real T1 tests
    (`internal/lowlevel`'s minimal-`--rtdir` and no-`runtime/clarus/`
    cases) that need the compile to proceed past a miss with an
    ordinary "undefined: FileInfo" diagnostic instead. `--rtbake`
    needed one more fix: `prelude.cla` is independently re-resolved via
    `findRtDir` on every compile (not anchored to a user entry file's
    own directory), so its bake-time vs. use-time path strings can
    legitimately differ with no real content drift (e.g. compiling from
    a nested `build-run/…` subdirectory) — `bkComputeManifestPaths`
    excludes `"prelude.cla"` from the drift-guard's own path set while
    it stays in `bakeModuleList`/`bkManifestHashes` like every other
    baked module, so a genuine on-disk edit still triggers the drift
    fallback (verified empirically) but a mismatched compile depth
    never does. Fix round 1 (opus review) guarded the checker's
    `symbols[scopeLookup(...)]` lookup against a `-1` (undeclared) index
    — an unguarded index was a runtime "list index out of range" crash
    (exit 3) instead of a diagnostic for `file.info` called with no
    discoverable prelude. Also reblessed all 19 `testdata/emitui/*.c.golden`
    files: every one gained the identical `clar_rec_FileInfo` typedef +
    zero-init constructor (no retain/release — every field is scalar),
    the same additive-only shape as Task 2's own rebless above.
  - **Checker**: `MethodSig.retNameIdx` + `sigEndNamed(nameIdx)`
    resolve a method's return type BY NAME at check time
    (`scopeLookup(topScope, …)`, walking up from the scope the call
    site is checked in) — `file.info`'s `FileInfo` return is the first
    consumer. A parallel `ParamSpec.recNameIdx`/`psRecNamed` mechanism
    (for a future name-resolved PARAMETER, not return type) was drafted
    per the plan but never became reachable — no `fileFuncs` entry
    needed it — so Task 3's fix round deleted it outright (controller
    ruling) rather than leave dead code: `sigEndNamed` is the checker's
    only name-resolved-type mechanism this phase actually uses.
  - **`toolbox/files.cla` HFS catalog/directory family** (Task 2,
    commit `75d9c39`, fix round `9549634`): the `_HFSDispatch` trap
    family (`PBGetCatInfoSync`/`PBSetCatInfoSync`/`PBDirCreateSync`/
    `PBCatMoveSync`, all through trap `0xA260` with the selector in D0
    via `moveq #N,D0`) declared as `reg(a0: paramBlock, d0: selector)
    ret d0` — the register convention confirmed by the Files.a macro
    bodies, not merely the C header's `TWOWORDINLINE` pragma; five
    single-trap H-prefixed routines (`PBHDeleteSync 0xA209`/
    `PBHRenameSync 0xA20B`/`PBHGetFInfoSync 0xA20C`/`PBHSetFInfoSync
    0xA20D`/`PBHOpenRFSync 0xA20A`); records `HFileParam`/`CInfoPBRec`
    (the `HFileInfo`/`DirInfo` union, 108 bytes)/`CMovePBRec`/
    `HIOParamRename`; selector and OSErr constants including the
    close-out's own addition, `dirNFErr = -120`. New cookbook §12
    walks the selector-in-D0 register shape end to end. Reblessed all
    19 `testdata/emitui/*.c.golden` files — every UI-runtime composition
    splices `toolbox/files.cla` via `uidialogs.cla`, so each gained the
    identical 9 new `extern` trap prototypes; verified purely additive
    (controller ruling, reviewer-checked).
  - **Host lane** (Task 3/4): HFS `:`-path to POSIX `/`-path
    translation lives in exactly one place, `rt_fh_posix_path`
    (`runtime/host/rt.c`), called from `path_to_cstr` — the single hook
    every path-taking C entry point in `rt.c`/`rt_fileh.inc` (old and
    new) already shares, so the translation covers every new `file.*`
    call automatically. `rt_file_name` was fixed to route through
    `path_to_cstr` before splitting on the leaf's last `/`, since a
    colon-spelled path never contained a `/` before translation. Eight
    new `FhH*` externs plus `rt_fh_unix_time` (the inverse of the
    existing `rt_fh_mac_time`).
  - **Native lane** (Task 5, commit `2084ccc`, fix round `607c2fa`):
    `fileh_68k.cla` drives `PBGetCatInfoSync`/`PBDirCreateSync`/
    `PBCatMoveSync` (the `_HFSDispatch` trio) plus `PBHDeleteSync`/
    `PBHRenameSync`/`PBHGetFInfoSync`/`PBHSetFInfoSync`, using
    function-local `extern record` variables per call (there is no
    `Name(ptr)`-style overlay/conversion form for `extern record` —
    confirmed against the language reference by Task 1's probe) rather
    than a single persisted PB record. ONE new native global,
    `rtFh68kState` — a lazily `SerNewPtr`'d 44-byte heap block holding
    the seven stat scalars, the stat hit's own DirID, and the listing
    cursor (dirID/index) plus its persistent 256-byte name buffer.
    This reblessed the cg68k/emitui golden corpus once: a uniform A5
    shift (every global's offset -4, e.g. globals `1588→1592`), one new
    `cg_init_globals` zero-init store pair per program, and segment
    repacking in files already close to the 32 KB boundary — one
    fixture, `peep_pushpop.s`, crossed into a genuinely new second
    segment (`peep_pushpop.seg2.s`). `internal/emitui` did not churn at
    all (no C-lane surface touches this global). Golden analysis
    confirmed every diff line is either that new global's own listing
    entry or a mechanically-derived A5-relative offset/label-number
    shift — no unusual instruction outside the one new segment file.
  - **Task 1's hardware findings** (probe wave, Mini vMac/System 6
    only — see below): `PBHRenameSync` rejects the ordinary `ioDirID=0`
    + partial-path convention every other HFS call in this phase
    accepts (`bdNamErr`/`dirNFErr`); it needs a BARE LEAF NAME plus the
    item's REAL parent DirID, resolved via one extra `PBGetCatInfoSync`
    call first — `rtFhDevRename` does exactly that. Both a nested
    partial path (`:ProbeA:B:x.dat`) and a full volume-qualified path
    (`vol + ":ProbeA:B:x.dat"`, `vol` from `PBGetVolSync`) opened
    successfully natively with no code changes — verified only against
    the probe's own boot volume (`"SysAndApp"`), never a second mounted
    volume. `ioDirID = 0` genuinely enumerates the DEFAULT folder
    during catalog enumeration, the exact convention `rtFhDevListBegin`
    relies on. Fix round 1 (opus review) generalized `""` beyond just
    `list`: it now names the program's own folder for `exists`/`info`
    too, on BOTH lanes (native already synthesized this; the host
    lane's `rt_ext_FhHStat` substitutes `"."` for an empty translated
    path, the same substitution `FhHListBegin` already made).
  - **Host date glue** (Task 6, commit `856d1d1`): host C twins
    (`rt_ext_host.inc`) for the PUBLIC `toolbox/osutils.cla` externs
    `ReadDateTime`/`SecondsToDate`/`DateToSeconds`, so a host build
    calling them links — previously Mac-lane-only. Caught and corrected
    against the brief's assumption: `rt_ext_ReadDateTime` returns
    `short`, not `int32_t` (`ReadDateTime` is declared `: word` in
    `toolbox/osutils.cla`, and cprint renders a `word` return as C
    `short`).
  - **Core suite**: `testsuite/core/cases_dirops.cla`'s `DirOps` case
    (new), growing `testsuite/core`'s real-case count from 78 to 79
    (`nCoreCases` including `SelfCheck`); wired into every count site
    (`runner.cla`, `internal/testsuite/core_cli_test.go`,
    `internal/cg68k/segment_test.go`, `internal/mactest/
    coresuite_test.go`/`suite_host_test.go`); PASSes on both the host
    CLI and the native `TestCoreSuiteGUIOn68k` boot.
  - **Deferred, recorded for merge**: System 7 (Snow) verification is
    UNVERIFIED for this entire phase — a live 68kbbs session owned the
    one Snow instance throughout (probe wave, native lane, and
    `TestClarusCBakePathOnSnow`, owed after any runtime-module
    addition); see `STATUS.md` §0. Several code minors (`rt_fh_mac_time`
    duplicating `rt_dt_now_mac`, `rtFhDevRename`'s native lane
    re-deriving a parent DirID instead of caching it, an unchecked
    `SerNewPtr` in `rtFh68kEnsureState`, and others) and test gaps
    (folder rename, `file.list("")`, the `--rtbake`/`file.info`
    combination, `rtFhDevListFailed`'s true branch natively) are filed
    in `docs/TODO.md`, not fixed this phase.
  - **Latent bug found (T2's native gate, fix commit `4bc0a07`)**:
    `TestToolboxSuiteJiggleOn68k` bombed natively ("illegal instruction")
    while the plain `TestToolboxSuiteOn68k` stayed green throughout —
    exactly the signal the correctness-cleanup phase's heap-jiggle gate
    exists to catch. Root cause was PRE-EXISTING and unrelated to any
    filesystem-api code: `runtime/clarus/uitext.cla`'s
    `rtUiTeWidestLine` captured a `TEHandle` master pointer, then called
    `rtUiGetPortSaved()` — which allocates (`UiNewPtr(4)`), the exact
    waist `rtUiJiggleTick` forces a full `CompactMem` at — and kept
    reading `inPort`/`txFont`/`txSize`/`txFace`/`hText` through the now-
    stale pointer, eventually handing QuickDraw's `TextWidth` a garbage
    `GrafPtr` whose bogus `grafProcs` it JSRs through (vector 4). No
    filesystem-api commit caused this: two builds of the toolbox suite
    with byte-identical CODE segments (differing only in the `--bake`
    resource's name string) landed on opposite sides of the crash: it
    is a heap-layout coin flip that Task 5's ~400 spliced lines of
    `fileh_68k.cla` plus its one new A5 global merely re-rolled — no
    new filesystem code is even reachable from the toolbox suite. Fixed
    by hoisting the allocating call above the master-pointer capture
    (the function's own loop body already re-derived `teMp` each
    iteration for the identical reason; the hazard at the top of the
    function was missed) plus a warning comment on `rtUiGetPortSaved`
    itself; an audit of all 17 other call sites found none else at
    risk. This is the standing rule's bug class (ROADMAP: "re-derive
    master pointers after any allocating call"), found a seventh time.
    Goldens reblessed, provably nothing but one statement moving (14
    `testdata/emitui/*.c.golden` files, 3 `testdata/cg68k/*.seg2.s`
    files). Full trail:
    `.superpowers/sdd/2026-08-26-filesystem-api/crash-report.md`.
  - **Close-out (Task 7)**: bootstrap snapshot regenerated
    (`TestSnapshotFixedPoint` PASS), `toolbox/files.cla`'s
    `CMovePBRec.ioNewName` comment corrected (destination FOLDER path,
    not a new leaf name) and a `dirNFErr` const added (replacing a bare
    `-120` in `fileh_68k.cla`), the reference's Host-behaviour paragraph
    extended (`setInfo`'s `created` is ignored on a host too — POSIX
    birth time is not settable), `docs/TODO.md`/`docs/ROADMAP.md`/
    `CLAUDE.md`/`STATUS.md` closed out. The 68kBBS project's own
    `docs/language-gaps.md` update was written but deliberately left
    UNCOMMITTED in that separate repo, for Andrew (same precedent as
    the transfer-crcs phase's own cross-repo note). The design spec's
    §6 named two risks going in -- a standalone-gate allow-list the
    prelude type might need, and cg68k golden growth from emitting
    layout tables for an unused record -- and both turned out to be
    non-issues: the from-source splice needed no allow-list, and cg68k
    emits nothing at all for a record type no program in the corpus
    references. The next phase needn't plan around either.

- **extern-ptr-call (branch `extern-ptr-call`, 2026-08-27/28, based on
  `main` at `74c9e46` — `filesystem-api` already merged to `main` and
  pushed, origin/main = `9b2eea8`): DONE, T2 PASS.** Final opus
  whole-branch review: READY WITH FIXES → fix wave applied (`cac7ff1`:
  `CLAR_PASCAL` on the host-lane conv-10 cast + `#define` hoist for
  callback-free `= ptr` programs, cg68k doc-block split, `PtrCallVoid`
  void-return suite check, wording/hygiene), scoped re-review clean, all
  gates re-run green at the tip. The fix wave's OnMac proof run also
  surfaced a PRE-EXISTING main breakage: the opt-in cprint-lane suite
  twin has been dark since `ae662a3` (2026-08-22, `*/`-in-comment in
  `runtime/mac/rt_ext_mac.inc`) — recorded in STATUS/TODO, not this
  phase's file. Adds `= ptr`, a new `external func`
  clause (conv 10) calling through a runtime pointer with the plain
  pascal calling convention instead of a fixed trap number — the
  driving use case is loaded code (a plugin/door module fetched with
  `GetResource`, HLocked, dereffed, and jumped into — 68kBBS territory),
  which had no Clarus surface at all before this phase. Spec:
  `docs/superpowers/specs/2026-08-27-extern-ptr-call-design.md`; plan:
  `docs/superpowers/plans/2026-08-27-extern-ptr-call.md`; full ledger:
  `.superpowers/sdd/2026-08-27-extern-ptr-call/`. Six tasks, one feat
  commit each for Tasks 1-5 (all review-clean, no fix rounds needed),
  this close-out commit for Task 6.
  - **Parser + checker** (Task 1, `c9c2d4f`): new contextual keyword
    `ptr`, recognized only in an `external func`'s clause position. The
    checker requires at least one parameter, with the first declared
    `ptr` — the call target, consumed as the jump address and never
    pushed; a zero-parameter or wrong-first-param-type declaration is a
    compile error naming the rule. `ptr` is mutually exclusive with
    `sel`/`seld0`/`reg`/`memerr`/`ret` at the grammar level — the parser
    has no production for a suffix in that position, so writing one is a
    plain parse error, not a checked diagnostic. The redeclaration-merge
    rule (`externClauseMatches`) needed no extension: it already compares
    `externFuncConv`, so a mismatched conv 10 falls out for free. Seven
    new `check_test` fixture cases.
  - **Host lane** (Task 2, `5f8d225`): `cprint.cla`'s `fpCallExt` casts
    the call-site's first argument through a C function-pointer type
    built from the extern's own declared param/return types
    (`cpCbWireType`/`cpCbRetWireType` — the same wire types a `callback
    func`'s compiler-generated glue already conforms to) and calls
    through it directly. A conv-10 extern has no `rt_ext_` host symbol at
    all (`cpEmitExternProtos` skips emitting a prototype for it) — the
    cast and call happen entirely at the call site. New fixture
    `testdata/lowlevel/ptrcall_host.cla` (`TestLowlevel`), modeled on
    `callback_host.cla`; its `NewPtr`/`DisposePtr` externs carry the
    exact trap clauses `runtime/clarus/list.cla`'s
    `ListNewPtr`/`ListDisposePtr` already use, picking up their existing
    host glue for free via the reference's identical-repeat-extern
    accommodation.
  - **Native lane** (Task 3, `0ae201d`): the pascal arg-push loop was
    extracted verbatim out of `cgCallExtPascal` into a new
    `cgPushPascalArgs(a0, xi, j0)` — conv 1 (plain pascal `trap`) and
    conv 9 emission confirmed byte-identical against the existing golden
    corpus, no rebless needed. New `cgCallExtPtr(e, xi)`: evaluate and
    push the target (arg 0) as a saved long below the result slot, push
    the result slot, push args 1.. via the shared loop against params
    1.., `MOVEA.L` the saved target back into A0 past the pushed
    args+slot, `JSR (A0)`, read the result back through the same three
    signed/short-slot readback arms `cgCallExtPascal` already used
    (including the bool/char high-byte convention — the historically
    buggy arm), `ADDQ.L #4,A7` to discard the saved target since the
    callee only pops its own declared args under pascal discipline. No
    new native globals; `cgCallExt`'s dispatch gained one `else if conv
    == 10` arm ahead of the native-fallback abort.
  - **Core suite `PtrCall` case** (Task 4, `8fa24f7`):
    `testsuite/core/cases_ptrcall.cla` — a word-returning round trip
    (`PtrCallRound` through `callback func pcMixed`, asserting a signed
    result, a `ptr`+`int` side effect via `peekl`, and a bool-steered
    branch) plus a bool-returning round trip (`PtrCallFlag` through
    `callback func pcIsPositive`) added by review specifically to
    exercise the native bool-result readback arm the word case alone
    doesn't reach. `nCoreCases` 79 → 80 (79 real + `SelfCheck`); wired
    into every count site (`runner.cla`,
    `internal/testsuite/core_cli_test.go`, `internal/cg68k/
    segment_test.go`, `internal/mactest/coresuite_test.go`/
    `suite_host_test.go`, `internal/bake/bakeidentity_test.go`). Green
    80/80 on `TestCoreSuiteGUIOn68k` (System 6, Mini vMac).
  - **Docs** (Task 5, `929bd15`): reference grammar production extended
    with `| "ptr"`; new "The `ptr` Clause" subsection (Ch13) covering the
    first-parameter target rule, the no-suffix grammar restriction, the
    unchanged redeclaration-merge rule, the callback-name-as-target
    accommodation, the unchecked nil-target contract, and the
    interrupt-time exclusion; cookbook §13, "Walkthrough: calling loaded
    code — the `= ptr` clause", with a real `toolbox/memory.cla`
    `HLock` trap word in the worked example.
  - **Close-out (Task 6, this commit)**: bootstrap snapshot regenerated
    and fixed-point-verified. Found and fixed a real `internal/reftest`
    gate break, NOT a compiler defect: Task 5's reference edit added a
    closing worked example (`HLock` → `HandleToPtr` → `PluginMain(code,
    1, pb)`) that didn't check clean standalone — bare top-level
    statements (only declarations are legal at Clarus top level) and an
    undeclared `pb`. Fixed by wrapping the example in a
    `callPlugin(h: ptr, pb: ptr): int` function, with `var code: ptr`
    declared (uninitialized) ahead of the `HLock`/`HandleToPtr`/`return`
    statements — Clarus requires every local var declaration at the top
    of a body before any statement, so the assignment into `code` moved
    below the declaration rather than folding into it. The identical fix
    was mirrored into `docs/clarus-toolbox-cookbook.md`'s own copy of the
    example (not gate-checked, kept consistent). This inserted two new
    fences into the reference, shifting every fence index at or after
    the old "word extern type" fence by +2;
    `internal/reftest/manifest.go`'s `CheckClean` list and header
    comments were updated to match (new indices 84/85 added for the
    `ptr`-clause fences; the two Appendix C programs shifted 85/86 →
    87/88). `docs/TODO.md`/`docs/ROADMAP.md`/`CLAUDE.md`/`STATUS.md`
    closed out; the two spec-out-of-scope follow-ups (a named-target
    `= ptr(name)` form, register-convention `= ptr` targets) filed in
    `docs/TODO.md`.

## Resolved "Small open items" (moved verbatim from ROADMAP, 2026-08-15)

- `clarus run prog.cla -- args…` pass-through: DONE (clarus-run-dashdash).
- **Two clarusc gaps found during window-zoom-hscroll: DONE** — fixed on
  branch `clarusc-ui-gaps` (2026-07-26): (1) widget-set Str→Text coercion
  (`Body.text = "lit"` now compiles); (2) handle-backed window-var
  construction (window `var t: text` no longer NULL-crashes at runtime). The
  shipped scenario workarounds in `testdata/ui/hscroll.cla` and
  `testdata/ui/dialogs.cla` were unwound to exercise the fixed shapes
  directly.
- **ARC milestone: DONE** — see docs/HISTORY.md (Done item 11). All `.leaks` goldens at zero
  (files deleted); the 4e escape-analysis apparatus deleted.
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
- **`accepted(rec)` trailing-bool codegen bug: DONE** — already fixed by
  small-scalar-width commit `8278ae7` (`rtUiFormAccept` bool writeback
  `pokel`→`pokeb`, `runtime/clarus/uidialogs.cla`); root-caused and
  `formedit` migrated to `testsuite/toolbox/cases_formedit.cla` during
  test-consolidation (2026-08-06), which pins the regression (the case
  FAILs at the pre-fix commit). Originally found during
  ui-scenario-retirement, 2026-08-05, when the bug blocked `formedit`'s
  migration and it stayed a scripted-lane scenario, temporarily, until
  this fix landed.
- **~~`rtUiBuildEvery` virtual-tick seeding~~ (found during
  ui-scenario-retirement, 2026-08-05) — RESOLVED as a MISDIAGNOSIS by
  native-gaps-cleanup Task 6, 2026-08-07. `rtUiBuildEvery` never had a
  bug.** Verified on real hardware via a revert-before-commit debug
  probe: `UiTestScript()`'s pool-byte read and `rtUiBuildEvery`'s own
  `now = 0` seed both check out correct every time. The real bug was
  `rtUiEveryPump` (`runtime/clarus/ui.cla`) — the one every-array pump
  that didn't gate on `rtUiScripted` the way every sibling touchpoint
  does. `testsuite/toolbox/cases_uitest.cla`'s `casePostEventClick`
  legitimately calls it directly (to replicate a real event-loop idle
  tick after draining a real `PostEvent`), which reschedules every
  program-wide every-block's `due` from real `UiTickCount()` (~46 ticks
  in, this suite's own startup depth) — including Canvas's, whose
  window isn't even open yet, stomping its virtual-tick-seeded `due =
  4` to `50` well before Canvas's own case runs. Fixed by gating
  `rtUiEveryPump` on `rtUiScripted`, forwarding to the already-correct
  `rtUiScriptEveryPump`; `cases_canvas.cla`'s warm-up-tick workaround
  deleted, the case now asserts the un-warmed cadence. **Rider (stale
  per-segment constant-pool duplicates) resolved — policy, not a bug:**
  verified against `testdata/valid/bounce.cla` (a natural 4-segment
  fixture at the real 32760-byte segment budget) — every segment
  carries exactly one full, non-redundant copy of the string-literal
  pool (120 entries), UI descriptor blob (168 bytes), and `--events`
  script bytes (91 bytes+NUL), identical counts in all 4 segments;
  `cgEmitPoolsBody` (`clarusc/cg68k.cla:9081-9094`) does one pass per
  segment, one label-bound entry per `irStrLits` index, no repeats — no
  mechanism exists for a stale duplicate beyond the documented
  one-full-copy-per-segment policy. No fix needed.
- **~~`label.text` READ unimplemented~~ DONE (native-gaps-cleanup phase,
  Task 5, 2026-08-07):** `lowWidgetPropGet` gained an `IUiGetLabelText`
  arm on both lanes, a structural copy of `IUiGetFieldText`'s own
  emission shape; the runtime's `rtUiWidgetGetStr` gained a
  `label`/`text` arm reading the SAME per-window-instance `labels[]`
  Pascal-string slot (`rtUiLabelAt`) the SET path already writes — no
  new storage needed. `cases_buttons.cla`'s checksum-region-inequality
  workaround and `cases_popuptable.cla`'s label-as-field workaround
  were both un-workarounded to read `.text` directly; both now exercise
  the real read path on the native-68k emulator.
- **~~PostEvent extern glue clobber list unverified~~ DONE
  (native-gaps-cleanup phase, Task 7, 2026-08-07):** PostEvent's
  (`0xA02F`) A0 register is not caller-preserved: Apple's pragma, the
  `.a` glue comment, and IM II's own on-entry/on-exit table all omit A0
  from PostEvent's documented outputs, and the sibling trap PPostEvent
  (`0xA12F`, same low trap byte, one extra flag bit) proves via its own
  decoded glue word (`0x2288` = `MOVE.L A0,(A1)`) that the underlying
  Event Manager dispatch code for this trap number does write a live
  result into A0. The prior glue's `"r"(a0)` (plain input, uninvolved
  in the clobber list) was therefore a latent under-clobbering risk;
  fixed to `"+r"(a0)`, keeping the conservative `d1`/`a1`/`cc`/`memory`
  clobbers since none of the three sources documents those as preserved
  either. Verified against the cprint/Retro68 lane's real hardware
  proof: `CLARUS_CPRINT_MAC_TESTS=1 go test ./internal/mactest -run
  TestToolboxSuiteOnMac` passes all 25 subtests including
  `PostEventClick`. (Incidentally corrected a false claim in the same
  comment block: PostEvent DOES have a real `EXTERN_API` prototype in
  Retro68's Universal Interfaces — harmless to the hand-rolled-glue
  choice, since that prototype's own inline form has no post-trap glue
  either.)
- **~~Unresolved `extern record` forward-reference crashes lowering~~
  DONE (native-gaps-cleanup phase, Task 8, 2026-08-07):** `var
  r: SomeXRec` (or any field read/write) naming an `extern record`
  declared later in source order crashed lowering (`runtime error:
  list index out of range`, `irFindRecordLayoutByName` returning -1)
  even though the checker's two-phase declaration pass already accepts
  the program cleanly (order-independent). Fixed: `clarusc/lower.cla`'s
  `lowTypeAt` (the position-carrying form of the old `lowType`) and the
  three field-access sites (`lowXRecAddr`/`lowXRecFieldRead`/
  `lowXRecFieldWrite`) now guard `recIdx == -1` and emit a real
  `path:line:col: extern record NAME is not declared before this use`
  diagnostic instead of panicking, continuing to collect further
  diagnostics rather than aborting. Pinned by `testdata/errors/
  xrec_order.cla`. **Known follow-on gap, not itself fixed:** `ir.cla`'s
  own recursive call inside `irXRecFieldSize`'s `XFRec` case — reachable
  only for a NESTED xrec field whose element record is itself
  forward-referenced — is the same panic class and remains unguarded;
  no current fixture/caller reaches it (out of Task 8's scope, which
  was "the unknown-TYPE path specifically"). Fix the same way (guard,
  diagnose) if a future case ever triggers it.
- **~~Configurable native stack reserve~~ DONE (native-gaps-cleanup
  phase, Task 4, 2026-08-07):** `cgStartupStackReserve`'s flat 131072
  constant is retired. New `app`-section field `stack: N` (int literal,
  checker range 4096..1048576) wins outright when present; otherwise
  cg68k computes a heuristic over the post-tree-shake static call
  graph — deepest reachable acyclic chain (`frameSize+8` per node) +
  one-frame-each cost for every shake-reachable on-cycle node, not
  just ones on that deepest chain (`cycleExtra`) + the deepest
  reachable `callback func` body's own
  chain, added on top rather than maxed (`cbExtra`, covering a Toolbox
  callback firing while an unrelated Clarus chain is already live on
  the stack) + a fixed 8192-byte Toolbox/trap headroom, floored at
  32768 and even-rounded. The toolbox-suite composition (the original
  reason for the 128K bump) now computes ADDA **-72544** via the
  heuristic — about 45% less reserved stack than the old flat 131072 —
  empirically proven sufficient by booting the same composition
  natively (`TestToolboxSuiteOn68k`, all 25 cases PASS). `cbExtra`'s
  known limitation (models at most one live Toolbox callback at a
  time; a callback whose own body triggers a second, distinct nested
  callback would still be undercounted) and the shared-memo cycle
  heuristic's structural-dominance argument (a 2-node mutual-recursion
  fixture, `testdata/cg68k/mutrec.cla`, with the dominance argument
  covering arbitrary N-node cycles) are both documented in
  `cgStackHeuristic`'s own doc comment.
- **Cross-lane `string(n)` record-field alignment divergence: DONE** —
  fixed on branch `strn-field-alignment` (2026-08-06): the cprint lane now
  gives a `string(n)` record field 2-byte alignment and even-rounded size
  (even-padded `clar_str_n` typedef + explicit `clar_pad` struct members),
  matching cg68k, so str-bearing record offsets coincide across the two
  Mac lanes. Spec:
  `docs/superpowers/specs/2026-08-06-strn-field-alignment-design.md`.
- **~~cg68k size/shape-sensitive silent-corruption bug~~ (raised during
  toolbox-cookbook Task 4, 2026-08-06) — RESOLVED as a MISDIAGNOSIS by
  pack3-standardfile Task 5a, 2026-08-07. There was never a cg68k bug.**
  The reported symptom was real and reproduced 2/2 (a branch-per-step
  rewrite of `testsuite/toolbox/cases_catalog.cla`'s `caseCatalog` TE
  section made an unrelated, textually-earlier Gestalt check in the same
  function come back `n == 0`, native `emit68k` lane only), but the cause
  was the Gestalt declaration, not codegen: the raw trap returns its
  response in **A0**, our `reg(d0: selector, a1: response) ret d0` clause
  dropped A0, so `*response` was never written and the check asserted
  `!= 0` against uninitialized `NewPtr` heap. Any edit that moved the heap
  — a branch-heavy rewrite, a segment boundary, even a same-length
  comment — flipped the coin, which is exactly what "size/shape-sensitive"
  was describing. Fixed by transcribing the trap twice (once per result
  register) and by replacing the `!= 0` assertions with a plausible BCD
  system-version range, so the cases now fail deterministically on both
  lanes if the binding regresses. Repro fixture stays archived at
  `.superpowers/sdd/2026-08-06-toolbox-cookbook/repro-shape-corruption/`
  (superseded banner added); full trail in
  `.superpowers/sdd/2026-08-07-pack3-standardfile/task-5a-report.md`.

## go-retirement phase (2026-09-05, branch `go-retirement`)

Recorded here for the same reason the other phase entries are, though
merging to `main` is Andrew's call and had not happened when this was
written. Older entries above keep their `go test` / `internal/...`
references verbatim: they were accurate when written, and this section is
the record of what replaced them.

**What it did.** The Go COMPILER was already deleted (tag
`go-compiler-final`, 2026-08-05); the Go TEST harness was not. 58 files and
14,268 lines of Go under `internal/` (53 `*_test.go` plus five non-test
helpers) still drove every gate, so the project still needed a Go toolchain
to be verified at all. This phase ported all of it — into 117 test scripts,
the frozen `lib.sh` plus seven group helpers, and five C tools — and
deleted `internal/` and `go.mod`.

**The replacement.**

- A root `Makefile`: `make -j tools bootstrap` (five C tools plus the
  two-stage `build-run/clarusc-{snapshot,current}` compilers),
  `make test T='<group>/<name> <group>/'`, `make -j t1` (everything but
  `selfhost/` and `perfgate/`), `make t2` (the whole merge gate),
  `make smoke` (the two native emulator boots). `tests/run1.sh` runs one
  script under its deadline and writes a `PASS|SKIP|FAIL(...) <name>
  <secs>s` result line; `tests/summary.sh` counts them and dumps failing
  logs. No result cache: every invocation re-executes every selected
  script, which is why nothing here needs `-count=1`'s stale-PASS patch.
- `tests/lib.sh`, frozen, is the shared vocabulary: `t_pass`, `t_fail`,
  `t_done`, `die`, `skip` (exit 77), `require_env`, `require_tool`,
  `require_vasm`, `golden_check`, `first_diff`, `host_build`, `emit68k`,
  `run_c_test`, `mem_live`. Per-group helpers are `tests/lib_<group>.sh`
  (`lib_bake`, `lib_conntest`, `lib_mac`, `lib_mactest_host`, `lib_reftest`,
  `lib_selfhost`, `lib_snow`), sourced immediately after it.
- One script per former Go test, grouped by the package it came from:
  `asm68k bake cg68k claruscboot conntest emitui hostrt lowlevel mactest
  perfgate reftest runner selfhost sertest testsuite`, plus
  `mactest/snow/` for the System 7 / Mac II lane.
- Five C tools under `tests/tools/` (~1,400 lines) for what POSIX sh cannot
  express: `timeout` (a deadline that kills the whole process group and
  forwards signals, with `--elapsed` for the perf tripwire), `uiblob` and
  `resfork` (UI-blob and resource-fork dumpers), `clirhdr` (CLIR header
  reader plus the deliberate stamp/body corrupters the bake refusal tests
  need), and `tcpdrive` (port picker, listener and client for the
  `connection` tests).
- Wrappers: `scripts/test-task.sh` = `make -j t1`, then
  `make test T=perfgate/` alone, then `make smoke` under `--smoke`;
  `scripts/test-merge.sh` = the five `t2` stages called one at a time so
  each prints its own `PASS in Ns` line.

**Rulings that are load-bearing, not incidental.**

- **Exit 77 is SKIP, and a `FAIL ` line in the log beats it.** A script
  that reports a failing subcase and then skips is a FAIL, not a SKIP —
  otherwise a late `skip` could launder a real failure. `tests/runner/
  selfcheck.sh` pins the whole precedence table (`pass`, `skip`, `failx`,
  `failline`, `failskip`, `slow`, `minhdr`, `bogus`).
- **A malformed `# timeout:` header falls back to the 600 s default**
  rather than becoming `alarm(0)` — no deadline at all — and the `timeout`
  tool rejects a non-numeric or zero deadline with exit 2.
- **Every helper source line is guarded** (`. .../lib_<group>.sh || die
  "helper lib failed to load"`; `lib.sh`'s own line gets `|| exit 2`).
  An unguarded source of a syntactically broken helper once produced a
  green PASS with zero assertions. `tests/runner/syntax.sh` runs `sh -n`
  over every `tests/**/*.sh`, helper libs included, as the second layer.
- **Emulator boots are serial by construction.** A Mini vMac or Snow boot
  owns the machine's screen, so `mactest/` runs at `-j1`; the Snow lane's
  `snow_run` polls a done-condition, quits Snow with `osascript`, and
  fails loudly if Snow will not quit within 20 s (a killed emulator leaves
  an untrustworthy disk image).
- **`perfgate/` is excluded from `t1` and always run alone**, which closes
  the long-standing under-load tripwire flake (`docs/TODO.md`) as a
  structural matter rather than by widening the margin; the baseline was
  re-measured on a quiet host at the end of the phase.

**Opt-in lanes, unchanged in behavior from the Go gates.**
`CLARUS_CPRINT_MAC_TESTS=1` for the Retro68/cprint twins (still carrying
their two pre-existing cprint-runtime failures, `FileHandleRW: create
failed` and `DirOps: exists("") false`), `CLARUS_SNOW_TESTS=1` for the
Snow lane, `CLARUS_BENCH68K=1` for the 68k calibration bench,
`CLARUS_BAKE_FULL=1` for the bake full-corpus sweep, and the four bless
variables `CLARUS_MAC_BLESS` / `CLARUS_CG68K_BLESS` /
`CLARUS_BLESS_BEHAVIOR` / `CLRD_BLESS` — each recognized only when set to
exactly `1`, and the last of those rewrites the frozen
`testdata/sertest/clrd_goldens/` blobs, so it is deliberate-only.

Spec: `docs/superpowers/specs/2026-09-05-go-retirement-design.md`; plan
`docs/superpowers/plans/2026-09-05-go-retirement.md`; per-task briefs,
reports and the side-by-side parity proof in
`.superpowers/sdd/2026-09-05-go-retirement/`.

## compiler-cleanup phase (2026-09-05, branch `compiler-cleanup`)

Recorded here on the same terms as the go-retirement entry above: merging
to `main` is Andrew's call and had not happened when this was written.

**What it did.** `docs/TODO.md`'s "Compiler correctness / diagnostics"
section had accumulated 30 entries across seven phases (2026-07-23 to
2026-08-29) — one FIXED record and **29 open**. Several forced the same
expensive regeneration (every `testdata/cg68k/*.s` golden, the
`clarusc/clarusc.c` snapshot), so fixing them a phase at a time meant
paying that cost repeatedly. Andrew's direction: clear the whole section
in ONE phase, structured so goldens are blessed at most twice and the
snapshot regenerated once. All 29 are disposed of; the section now holds
only its FIXED record and the one new entry this phase itself opened
(below).

**The 29 dispositions.**

- **26 fixed.** Lexer bad-escape diagnostic + string-literal resync (no
  cascade); `edit F, sm[k]`/`im[k]` rejected by the checker instead of a
  lowering `abort`; `declIsRuntimeOrigin` symlink residual (removed by
  construction — provenance is now recorded at splice time, not
  reconstructed from path strings); discard-tracking generality (one
  predicate, `lowIntrIsOwningContainerRead`, two call sites); exhaustive
  `transportName(tag)`; transport-misuse diagnostic column now points at
  the `serial`/`appletalk` keyword; the three connection-dispatcher
  builders folded; `lowSynthConnFireFailed`'s unused `err` local elided
  when no slot has a `failed` handler; the conn runtime cut out of
  conn-less native builds; an emitted-C golden for `cpEmitMain`'s pump
  loop (`testdata/emitui/connpump_abort.{cla,c.golden}`); a `--rtbake`
  T1 smoke for `datetime` (`tests/bake/datetime.sh`); `expand()` marks
  `seenPaths` only after a successful read; `usesConn` set from ANY
  `connection` type position (locals, params, return types, record
  fields, list/map elements — not just a global `var`); the conversion
  diagnostics reshaped to `X() expects ..., got ...` plus `string(char)`;
  duplicate-`const` cites both declarations; `cgReturnStmt` computes
  `irExprType(x)` once; `makeRec().field` no longer leaks on the native
  lane; `pop`/`shift` as operand/receiver tracked on both lanes;
  `smalltmp_ceiling.cla` extended to 30 concurrent temps and the flat
  24-slot pool replaced by a per-function high-water; the four remaining
  stale-master-pointer sites bracketed with `UiHLock`/`UiHUnlock`; the
  suite GUI's own case table pinned by a new `CasesTable` checksum case;
  `textview` method dispatch switched from method NAME to widget KIND;
  the textview 16-bit scroll ceiling clamped; the cprint-lane toolbox
  twin's link failure fixed with `rt_ext_TbFreeMem` /
  `rt_ext_TbClearWarmFreeMem` shims; the `drive.cla` prelude-splice
  rationale collapsed to one telling.
- **1 already fixed — deleted.** The `cgLastTrackedOff` aliasing hazard
  in `cgIntrMapGetDv` (recorded by the correctness-cleanup phase,
  2026-08-17): the defensive `cgLastTrackedOff = -1` reset it asked for
  had already landed in the **68k-call-result-release phase**
  (`cg68k.cla`, comment "Task 1 probe item 1c hardening"). The TODO
  entry outlived its own fix.
- **1 obsolete — deleted.** "Parameter-escape-summary precision upgrade":
  the static escape analysis it proposed refining was DELETED in
  `e4b592f`; scope-exit release is unconditional now, so there is nothing
  left to make more precise. Reviving an escape analysis is a new phase
  with its own numbers, not a follow-up (spec §6).
- **1 closed with evidence.** The entry recorded since the binary-files
  phase as "**STILL LIVE**: an `emit68k` build referencing a runtime
  function that was not spliced crashes clarusc (`list index out of
  range`, exit 3)". It does not reproduce. Every native name-resolution
  site now guards with a clean abort, `drive.cla` catches a missing
  module pre-splice, and the checker catches an undeclared name; the one
  remaining shape was the `usesConn` gap, fixed in this phase. Task 8
  built the fixture that pins the guard —
  `tests/cg68k/unspliced_guard.sh` — and the observed behavior is
  `cg68k: rtStrStore not found/reachable` with **exit 1**, a clean
  diagnostic, never a runtime crash and never exit 3.

**Structure: two waves, two blesses, one snapshot.** Wave 1 (runtime and
harness, no `clarusc/` change) ended with **bless #1** — a mechanical
rebless of **77 golden files** (63 `testdata/cg68k/*.s` + 14
`testdata/emitui/*.c.golden`), every hunk attributable to the wave-1
runtime edits alone. A differential oracle confirmed the attribution: the
post-wave-1 compiler against the PRE-wave-1 runtime reproduces all
goldens byte-for-byte, i.e. the diagnostics and driver tracks moved zero
output. Wave 2 (the compiler) ended with **bless #2** — **64 golden
files** in `testdata/cg68k/` alone: 46 rewritten and **18 stale
`*.seg2.s` DELETED**, because the smaller frames and the absent conn
runtime shrank several fixtures back below their segment-2 boundary.
Then one snapshot regeneration, and `tests/selfhost/fixedpoint.sh`
reports `PASS snapshot_fresh` / `PASS fixed_point`.

**The `.s` line delta.** Across the whole `testdata/cg68k` corpus:
**501,110 → 478,983 lines, −4.42%**. Item **e** alone (the synthesized
`clar_conn_pump()` stub, empty unless `irUsesConn`, called by
`nat_UiConnPump` instead of `rtConnPump` directly) accounts for
**−4.30%** — `rtConnPump`, `rtConnDevGone`, `rtConnDevClose` and
everything under them drop out of a non-conn build's reachability walk.
The TODO entry that recorded this as a cost had measured it at +5-7%;
−4.30% is the same tax, paid back. Item **d** (the per-function
small-temp high-water replacing the flat 24-slot pool) contributes about
**95 bytes of frame per function**. Root-gating `cg68AddRoots` alone
would NOT have worked and was not the lever: `runtime/clarus/ui.cla`'s
event loop calls `UiConnPump()` unconditionally, so the conn runtime was
reachable through the UI runtime regardless of roots.

**Two deliberate deviations in the codegen track, both accepted by
review.**

1. **The always-track gate is `cgIsHandleKind`, not `cgNeedsRelease`.**
   The spec and brief both said "track whenever `cgNeedsRelease(elemT)`";
   taken literally that introduces a use-after-free on each lane, in a
   different type. `cgNeedsRelease` is additionally true for a
   handle-bearing `KRec`, whose >4-byte scratch is block-copied out by
   `cgCopyScratchToDst` into a destination that then owns it — tracking
   it would double-release. (The spec's own cross-reference points at
   `cgIntrListFirstLast`, whose gate IS `cgIsHandleKind`.) The host lane
   needed the mirror-image restriction for `KArr`, found not by reading
   but by `mactest/leakgate` going red: `fpNewTrackedTmp` was declaring
   every non-`KRec` temp `<ctype> t = NULL`, which does not compile for
   an array type, and once that was fixed, tracking a `KArr` pop in every
   position over-released. `KArr` now tracks only in the bare-discard
   position (`53c60a0`).
2. **`cgSmallTmpFirstOff` is recorded below the whole frame**, after
   `cgReserveDeepScratch`, not "at the point where slot 0 would go". At
   the brief's position, an empty pool (every function, on the measure
   pass — exactly when growth happens) aliases the return-save slot;
   harmless for correctness, but `peepFunc` runs at the end of every
   `cgEmitFunc` and two temps at one displacement is foldable, which
   would make the measure pass under-count and mis-pack segments.

**The honest note on the four stale-master-pointer sites (spec §3.1).**
All four are the shape `bff3268`'s "re-derive immediately before the
call" rule CANNOT fix — the master pointer is passed INTO an allocating
Toolbox trap, so the relocation window is inside the call — and the
heap-jiggle harness hooks only the `UiNewPtr` waist, so it cannot
exercise any of them. **No deterministic red-to-green test exists for
this class, and none was manufactured.** The proof is (a) the full native
suite green — `toolbox_68k`, `toolbox_jiggle`, `coresuite_68k`, the four
frozen scenarios — and (b) reviewer verification that no master pointer
is live across an allocating trap at any of the four sites. Recorded as a
limit of the evidence, not as a passing test.

**The `--rtbake` lesson, made a standing rule.** A whole phase
(binary-files, eight tasks, one new type end-to-end) shipped
`--rtbake`-broken because `--rtbake` was only ever exercised by the
opt-in `CLARUS_BAKE_FULL=1` full-corpus gate, which runs in T2 and
nowhere else. The general fix is not another one-off regression but a
rule, now in `CLAUDE.md`: **a phase that adds a new value-typed runtime
module adds its `tests/bake/<module>.sh` `emit68k_pair` twin in the same
task**, so `--rtbake` byte-identity for it fails in T1, not only in the
opt-in sweep. `tests/bake/datetime.sh` closes the one module that had no
twin.

**The first-read rule cuts both ways (Task 9).** `declIsRuntimeOrigin`
no longer compares path strings; `drive.cla` records
`drvRuntimeFiles[pathIdx] = true` in `expand()` whenever
`drvSpliceActive`, and origin is that lookup. Because `seenPaths` dedupes
on first read, **whoever reads a file first decides its origin**, in both
directions: a `toolbox/*.cla` pulled in by a runtime module's own
`include` classifies **runtime** (harmless — those files have no `func`
bodies, and classification only affects bodies), and a runtime module a
user names in an `include` by path classifies **user**, because
`driveCompile`'s entry loop runs BEFORE both splices. The second
direction is the one with live bodies in it, and it is accepted
semantics: a user who includes runtime source by path is composing it as
user code. Its only consequence is that such a program's runtime funcs
lose the abort-propagation exemption — one extra post-call check each,
correctness unaffected. Both directions are documented in
`drvRuntimeFiles`' and `declIsRuntimeOrigin`'s comments.

**One spec sentence corrected.** Spec §3.2 said `rtUiWidgetScrollToEnd`
"calls the sync and inherits the clamp". It does not — it re-derives its
own `maxScroll` and needed the same `> 32767` clamp added independently
(`af5d749`). The spec text is amended in place, marked "(corrected
2026-09-05, Task 2 review)"; the spec's INTENT (no `int`→`word`
truncation on any textview scroll path) was binding and is what shipped.

**New follow-up this phase opened.** Native and host now differ on
`pop`/`shift` tracking for a handle-bearing RECORD element:
`lst.pop().field` on a `list of R` where `R` has a handle field leaks on
the NATIVE lane only, as a direct consequence of deviation 1 above. Full
entry, with the fix direction, in `docs/TODO.md`'s "Compiler correctness
/ diagnostics" section — the only thing left in it besides the FIXED
record.

**One golden the phase's own T2 caught at close-out.**
`clarusc/test/check_test.out` and `clarusc/test/lex_test.out` — the
hand-maintained stdout goldens for clarusc's per-module driver programs —
still pinned the OLD diagnostic text (`cannot convert bool to char`,
`cannot convert string to ptr`; and the lexer cascade's phantom `IDENT
ZZ` / second `STRINGLIT` tokens plus its two `unterminated string
literal` lines). They are driven only by `tests/selfhost/modules.sh`,
which is a T2-only script, so nothing in T1 saw them move; the
diagnostics track's own `testdata/errors` fixtures were all updated and
all green. Reblessed at close-out — the new bytes are exactly what
§4.2a/§4.2c specify (`char() expects an int, got bool`,
`ptr() expects an int or overlay, got string`, and exactly ONE
`invalid escape sequence` with no phantom tokens). Same coverage-gap
CLASS as the `--rtbake` lesson above, one lane over: a T2-only golden is
a golden a task cannot see itself break.

**Two more things close-out's T2 caught, both pre-existing, neither
fixed here.**

1. **`tests/bake/full_corpus_suite_toolbox.sh`'s hand-maintained file
   list was missing `testsuite/toolbox/cases_casestable.cla`**, so the
   toolbox suite's own `--rtbake` byte-identity check could not even
   compile from source. Exactly the defect the 68k-call-result-release
   phase hit with `LeakCheck` and the same list's `internal/bake`
   ancestor — a hand-mirrored file list drifts the moment a case is
   added, and only the T2-only full-corpus sweep sees it. Fixed by
   adding the file; the list is now `diff`-identical to
   `tests/mactest/toolbox_files.txt`, which is the check worth
   automating some day.
2. **`--rtbake --lane c` silently drops the `connection`/`filehandle`
   runtime.** `bake.cla`'s `bakeModuleList` leaves `conn.cla`/`conn_c.cla`
   and `fileh.cla`/`fileh_c.cla` out of the C-lane baked chain on
   purpose (the host lane gates that pair on `usesConn`/`usesFileh` to
   keep every non-conn program's manifest byte-identical), but
   `driveCompile`'s `haveRtbake` branch bypasses `driveManifestSplice`
   entirely, so on the bake path nothing consults those flags and nothing
   splices the pair — the emitted C calls `rtConnOpen`/`rtFhOpen` without
   declaring them. **Pre-existing on `main`** (reproduced with
   `tests/conntest/testdata/echo.cla`, unchanged since go-retirement, and
   with a minimal `file.create` program); the 68k lane is unaffected,
   which is why `tests/bake/connfileh.sh` always passed. §3.5's new
   `connpump_abort.cla` is simply the first C-lane bake-corpus fixture to
   declare a `connection`. NOT fixed here: both candidate fixes are out
   of this phase's scope (one needs `clarusc/bake.cla`, which the spec
   forbids touching so the Snow gate stays unfired; the other changes
   `--rtbake` fallback behavior). Filed in `docs/TODO.md` under "Bake /
   CLIR artifact machinery" with both candidates worked out, and the
   sweep SKIPs the shape with an explicit reason that retires itself once
   the gap closes.

**Also cleared incidentally.** The cprint-lane toolbox twin now boots
**36/36** (`CLARUS_MAC_TESTS=1 CLARUS_CPRINT_MAC_TESTS=1 make test
T=mactest/toolbox_mac`), including `ScrollToEnd`, which `CLAUDE.md` and
`docs/TODO.md` both recorded as blocked by `main`'s `TbFreeMem` shim gap;
both are corrected. `testsuite/toolbox/runner.cla`'s stale "N real cases
here" comment is gone (§3.4), closing that TODO entry too. The two
pre-existing cprint failures `CLAUDE.md` records — `FileHandleRW: create
failed` and `DirOps: exists("") false` — are in the CORE twin and are
untouched.

**Untouched by design.** `clarusc/bake.cla` (verified: its diff against
`main` is empty), so the 55-minute Snow `clarusc_bake` standing rule did
not fire and that gate was not run. Every other `docs/TODO.md` section. A
canonical-path primitive — §4.4a removed the need instead of adding
surface. A general `cg68AddRoots` `irUsesConn` gate. Proportional
scrollbar remapping above the 16-bit ceiling.

Spec: `docs/superpowers/specs/2026-09-05-compiler-cleanup-design.md`;
plan `docs/superpowers/plans/2026-09-05-compiler-cleanup.md`; per-task
briefs, reports, reviews and the `progress.md` ledger (every `Ruling:`
line) in `.superpowers/sdd/2026-09-05-compiler-cleanup/`.

The final whole-branch review's as-built corrections live in the spec's
§8, and its `conntest/abort` under-`-j` flake is recorded in
`docs/TODO.md`'s "Test coverage gaps" section under this phase's own
heading.

**Follow-up sweep (Task 11, 2026-09-05): all 16 remaining final-review
minors fixed** — compiler: the two lexer resync helpers now skip an
escaped quote instead of ending on it, `checkConversion` gains an
`accepted` fallback, `checkEditStmt`'s three shape tests become one
`else if` chain, `lower.cla`'s `lowConnSlotOf` comment stops implying
`usesConn` ⇒ a slot exists, and the transport keyword's position packs
into `ExprNode`'s ExCall-spare `c` field so the record returns to its
pre-transport size (declaration byte-identical to `311af68`); runtime:
`rtUiLdefDraw` takes ONE `HGetState`/`HLock`/`HSetState` triple per row
instead of one per column; tests: per-subcase exact diagnostics and a
single runtime-tree copy in `cg68k/unspliced_guard.sh`, if/then/else in
`conntest/fieldonly.sh`, the `conntest/abort` deadline hardened to 10 s,
`rtdir_symlink`/`include_retry` moved from `selfhost/` to `cg68k/` so
both tripwires run in T1, the bake gap gate additionally requiring the
bake fork to CALL the symbol, `CLARUS_MODULES_BLESS=1` for the
`clarusc/test/*.out` goldens (the fifth bless variable), plus two new
`testdata/errors` fixtures — an escaped-quote bad escape and a genuine
unterminated string literal; reports: an addendum on `task-5-report.md`
pointing at where the raw native `TOTAL` lines are pasted. The snapshot
was regenerated and the `cg68k`/`emitui` goldens reblessed for the
runtime change, and full T2 re-run.

## language-runtime-cleanup phase (2026-09-06, branch `language-runtime-cleanup`)

Recorded here on the same terms as the two entries above: merging to
`main` is Andrew's call and had not happened when this was written.

**What it did.** `docs/TODO.md` had four sections — "Language features
(needed)", "Compiler correctness / cleanup", "ABI / performance",
"Runtime / Toolbox robustness" — holding **24 entries** accumulated
across nine phases (2026-08-05 to 2026-09-02). Several forced the same
expensive regeneration (every `testdata/cg68k/*.s` golden, the
`clarusc/clarusc.c` snapshot, the ~55-minute Snow bake gate), so fixing
them a phase at a time meant paying those costs repeatedly. Same shape as
the `compiler-cleanup` phase one week earlier, same direction from
Andrew: clear all four sections in ONE phase, structured so the goldens
bless at most twice, the snapshot regenerates once, and the Snow gate
fires once. All 24 are disposed of; all four sections are now gone.

**The 24 dispositions.**

- **23 fixed.** Array-literal initializers (`const t: int[256] = [...]`
  in a dedicated constant-pool class, `var` arrays block-copied from it —
  parser, checker, IR, lowering, both backends, the bake/CLIR format at
  v8); window-owned menu sets (the `menus:` window property, a 32-bit
  `menuMask` in the window descriptor, the bar re-synced on front change,
  a 31-menu ceiling with its own diagnostic); `file.openRF` (a resource
  fork opened as an ordinary `filehandle` — native `PBOpenRFSync`, host
  xattr with an AppleDouble `._` sidecar fallback); the three
  byte-identical extern-index scans converged onto `irExternLookup`; the
  native-only `lst.pop().field` leak on a handle-bearing record;
  function-calling global initializers on both lanes; the `KArr`
  parameter ABI (fixed arrays of scalars pass by address, borrow-or-copy,
  one shared predicate per lane); `ser.cla`'s per-byte reads;
  `scripts/size-68k.sh`'s stale suite composition (it now reads the same
  file lists the boot scripts do); `cg_init_globals` re-zeroing and
  unrolling what the startup loop already covers; `crc16`/`crc16x`/
  `crc32` migrated to `const` table-driven loops; buffered canvases
  blitting every event-loop pass (a per-canvas dirty flag); the map
  runtime minors (bounded probes, one grower, a field-order layout check,
  `MAP_KEYBLOCK` deleted); the heap-jiggle waist widened from `UiNewPtr`
  alone to every allocating Toolbox wrapper; `rtUiLayout`'s dead `ctrlMp`
  assignment; the `(new)` doc-comment tags; `cases_catalog.cla`
  discarding `PBCreateSync`'s error; `rt_fh_mac_time` duplicating
  `rt_dt_now_mac`; `rtFhDevRename` re-issuing the catalog lookup;
  `rtFh68kEnsureState`'s unchecked `SerNewPtr`; a zero `fdType` reading
  back as `""`; the host `readdir`/rename/move buffers clipping silently;
  and the `crc32` table pointer global in every program (deleted outright
  with the lazy heap block behind it).
- **1 excluded by design.** `rtUiTableClick` has no upper row clamp — a
  deliberate tripwire (the runtime-ir-bake T2 blocker): a clamp would
  mask the next stale-master-pointer bug. Its note moved verbatim into
  `docs/ROADMAP.md`'s Standing rules so the section could be deleted, and
  a copy stays in TODO.md's Runtime section where a runtime audit will
  look.

**Structure: two waves, two blesses, one snapshot.** Wave 1 (five
parallel tasks — runtime and harness, no `clarusc/` change) ended with
**bless #1** at `a5b3f8b`, plus a differential oracle proving every hunk
came from the wave-1 runtime edits alone. Wave 2 (eight tasks: the
compiler, the three features, plus two unplanned fix tasks, 7b and 12b)
ended with **bless #2**: **44 existing `testdata/cg68k/*.s` listings
rewritten, 3 new (`arrlit.s`, `karr_param.s`, `pop_rec.s`), 2 stale
`*.seg2.s` DELETED** (`arr_whole_assign` and `recs` pack into one segment
again after the init-stub shrink), **all 20 `testdata/emitui/*.c.golden`**,
and — the one the plan did not predict — the FROZEN
`testdata/emitui/uiblob_probe.{blob,dump}.golden`, which moved by exactly
one byte (`table 0 6 rowsIdx` 49 → 48, because deleting `rtCrc32Tab`
shifts every later `irGlobals` index down by one) and was hand-regenerated
the way that script's own header sanctions.

**The snapshot story is "once, but not where the plan put it."** A
runtime module that USES a new language feature cannot be compiled by the
frozen snapshot, so `text.cla`'s `const` CRC tables forced the
regeneration early: Task 14 regenerated `clarusc/clarusc.c` at `9fa5134`
(commit `2738898`), before its own change landed. Close-out was therefore
a fixed-point VERIFY — `snapshot_fresh` was red for the tables
themselves, one pass of the documented recipe fixed it, and the very next
run reported `PASS snapshot_fresh` / `PASS fixed_point`. No second pass.

**The `.s` line delta.** Across the whole `testdata/cg68k` corpus:
**480,204 lines pre-phase (`7c9d5f8`) → 481,001 after bless #1
(`a5b3f8b`) → 500,523 after bless #2.** The +19,522 headline is entirely
the three NEW fixtures (+35,998) net of the two deleted stale segments
(−2,113): **the 44 pre-existing goldens SHRANK by 14,363 lines**, which
is `cg_init_globals` no longer emitting a `MOVE.L #0,D0 / MOVE.L
D0,-N(A5)` pair per zero-default global and a `LEA/CLR.W (A0)+/DBRA` loop
per zero-default array, net of the new `; constant pool: array literals`
section that `text.cla`'s three 256-entry tables now put into every
program that pulls a CRC in.

**Size numbers** (`scripts/size-68k.sh`, pre-wave-2 baseline from Task 5
on the left):

```
                      baseline (Task 5)              close-out
SIZE coregui     bytes=282180 seg=9  bin=288896  ->  bytes=279584 seg=9  bin=286336
SIZE toolboxgui  bytes=208464 seg=7  bin=213888  ->  bytes=209982 seg=7  bin=215552
SIZE clarusc     bytes=1910688 seg=59 bin=1929600 -> bytes=2006308 seg=62 bin=2025472
```

`coregui` shrank (−2,596 bytes) on the init-stub work alone. `toolboxgui`
grew slightly (+1,518) — two new suite cases and the menu-mask runtime.
`clarusc` grew 5% (+95,620 bytes, 59 → 62 segments): the array-literal
machinery, the menu-mask plumbing, `openRF`, and `text.cla`'s 3 KB of
constant tables, which every program including the compiler now carries.

**Two compiler-correctness bugs nobody had asked for.**

1. **The statement-temp aliasing bug (Task 12b).** `cgStmt` reset the
   statement-temp pool's bump allocators at the start of EVERY statement,
   nested body statements included, while tracked temps are released at
   the end of the statement that OWNS them. A compound statement's own
   tracked temp — `for x in mk()`'s parked list handle, an `if` over a
   handle-returning call — was therefore aliased by the first temp its
   body allocated, and the end-of-statement release then ran
   `rtListRelease` on whatever integer the body had last stored there.
   **Any native program with `for x in f() { … }`, where `f` returns a
   text/list/map, was releasing a wrong pointer before this fix.** It
   surfaced as Task 12's blocker: adding ANY 39th `ToolboxTest` enum
   member hung the toolbox suite's native boot before its first window
   opened, because the member moved `SelfCheck`'s ordinal from 37 to 38
   and `rtListRelease(ptr(37))` happened to be survivable where
   `ptr(38)` was not. Six emulator boots of binary bisection found it.
   The allocators are now saved and restored, not reset; frames grow with
   nesting depth instead (the suite's worst function moved 4 bytes).
   Pinned by `tests/cg68k/nested_tmp_alias.sh`.
2. **The `EArrLit` seam (Task 7b).** The array-literal and `KArr`-ABI
   tasks met at `cgIsAddressableArgShape`, and the fix's blast radius was
   much wider than the seam: accepting `EArrLit` there is required for
   EVERY native `var x: T[n] = [...]` initializer, which the base commit
   aborted outright. `cgEmitStoreArr` also gained a guard turning a
   non-addressable array source into a diagnostic instead of a SIGSEGV.

**The Pack-7 find (Task 2), and a correction to the record.** Widening
the jiggle waist went red, as the spec said it might — but not on a stale
master pointer. `UiNumToString` was declared `= trap 0xA9EE reg`, and
`$A9EE` is `_Pack7`, the Binary/Decimal Conversion Package's SHARED
dispatch trap: its glue pushes a selector word (`MOVE.W #0,-(SP)`) BEFORE
the trap, and `reg` pushes nothing, so the package read whatever 16-bit
word happened to sit at `0(SP)` and dispatched wherever that pointed —
sometimes NumToString, sometimes another Pack7 entry that left the
destination string untouched or zero-lengthed. Latent and
heap-layout-dependent for as long as it existed; the widened waist made
it deterministic. The extern grammar has no "selector word AND register
args" clause shape, so rather than grow one, the four call sites moved to
a plain-Clarus `rtUiIntToPStr`. The stale prose this refuted — in
`macgui.cla`, `cases_a5.cla`, `cases_formedit.cla` (which asserted the
refuted "fixed register-convention" story outright) and `uitable.cla` —
was corrected at close-out, and the dead C glue deleted.

**The 32 KB self-compile cliff, named.** `cg_free_globals` scales with
`irGlobals.count`, so ANY new compiler global grows EVERY segment of
clarusc's own native build. Adding the array-literal pool machinery
pushed `fpIntrCall3` over the 32 KB per-function ceiling; Task 7 split it
into `fpIntrCall3`/`fpIntrCall3b` to recover ~10 KB. This phase spent the
slack it found. The next compiler feature will hit the same wall, and the
levers are another split or a table-driven `cg_free_globals` — recorded
in `docs/TODO.md`.

**Honest limits of the evidence.**

- **Tasks 4 and 5 have no `cg68k` golden coverage at all** — no fixture
  in the corpus reaches their code paths. Their hardware proof rests
  entirely on the `core`/`toolbox` suite boots, which did pass.
- **`cg68k` goldens are extremely coarse** (Task 6): 84,000 lines of diff
  for a semantic change touching ~20 runtime functions, because one new
  runtime function renumbers every label, JT slot and constant-pool
  offset in every fixture. Every runtime task pays that review cost. A
  label-normalizing comparison mode is a `docs/FUTURE.md` candidate.
- **Suite case counts are hand-maintained in FIVE places each**, not the
  two or three the plan named: core = the runner's `nCoreCases`,
  `coresuite_68k.sh`, `coresuite_mac.sh`, `tests/testsuite/core_cases.txt`
  and `CLAUDE.md`; toolbox = `nTbCases`, `toolbox_68k.sh`,
  `toolbox_jiggle.sh`, `toolbox_mac.sh` and `CLAUDE.md`. Task 1 and
  Task 11 each shipped one site short and were caught in review. Now
  recorded in `CLAUDE.md`.
- **The handle-bearing-array exception.** The `KArr` borrow ABI applies
  only to arrays whose element carries no handle (`not
  cgNeedsRelease(t)`) — one shared predicate on both sides of the call.
  An array argument that needs a copy and exceeds the 512-byte big-temp
  slot aborts the compile with a message naming the ceiling.
- **The 31-menu cap** is a checker diagnostic, not a runtime limit: bit
  31 of `menuMask` is the sign bit, so the 32nd menu declaration reports
  `at most 31 menus per program`.
- **`testdata/run/crc16.leaks` was deleted, not blessed** — it recorded
  one live block, `rtCrc32Tab`'s lazily allocated table, which Task 14
  retired. `selfhost/behavior` is T2-only, so Task 14 could not see it
  move. Same coverage-gap class as `compiler-cleanup`'s `--rtbake`
  lesson, one lane over.

**Gates at close-out.** Full T2 (`scripts/test-merge.sh`) and the Snow
`clarusc_bake` gate (`CLARUS_SNOW_TESTS=1 make test
T=mactest/snow/clarusc_bake`, the one run covering both `bake.cla` edits)
— see the Task 15 report in
`.superpowers/sdd/2026-09-06-language-runtime-cleanup/` for the verbatim
stage lines, the golden attributions, and the one open item close-out's
T2 surfaced (a 2-byte `CanvasIdle` `FreeMem` sample, bisected to a
one-time settle transient rather than a per-pass leak).

Spec: `docs/superpowers/specs/2026-09-06-language-runtime-cleanup-design.md`
(its §10 carries the as-built corrections); plan
`docs/superpowers/plans/2026-09-06-language-runtime-cleanup.md`; per-task
briefs, reports, reviews and the `progress.md` ledger in
`.superpowers/sdd/2026-09-06-language-runtime-cleanup/`.

## Archived from ROADMAP, 2026-09-05 (verbatim)

The "Where we are" paragraphs for four merged phases that had no entry of
their own here (`correctness-cleanup`, `68k-call-result-release`,
`textview-scroll-to-end`, `string-perf`), moved verbatim when ROADMAP was
trimmed to unfinished work only. Ledgers: `.superpowers/sdd/<date>-<phase>/`.

**`correctness-cleanup` phase (an interleaved detour, not on the
language-usability list below) is COMPLETE — merged to `main` (ff
`48a4696..3a4c054`) and pushed 2026-08-18:** the About box
now shows real app info in unscripted runs; a labeled `popup` with a
narrow declared width no longer collapses to an unclickable box;
div-by-zero (and INT_MIN/-1) is pinned as a runtime error on both lanes;
a new heap-jiggle stress mode + stale-master-pointer audit (3 real bugs
fixed, `TestToolboxSuiteJiggleOn68k` gated native boot added) make that
bug class deterministically testable instead of heap-layout luck; the
`error`-return hidden-pointer ABI gap is closed; `get(k, dv)`'s
evaluation order now matches host on native; two memory leaks/fd-reuse
gaps are closed; three checker guards (widget-property fill-in-place,
`toBytes` receiver-kind keying, xrec forward-reference) are tightened;
the PBM icon parser accepts CR/CRLF; and the Bookmark Manager reference
erratum is fixed. Full detail: `STATUS.md` §1, or (once merged)
`docs/HISTORY.md`.

**`68k-call-result-release` phase (branch `68k-call-result-release`,
2026-08-29, based on `main` at `0148c6a` — `extern-ptr-call` and
everything before it are already merged to local `main`) is COMPLETE —
full T2 green, NOT YET merged (merge only on Andrew's request):** fixes a
real `emit68k` memory leak (`../68kbbs/docs/memory-leak.md`): a user
function's handle-typed result (or a textview `.text` getter box)
consumed directly — as an argument, operand, or receiver — was never
released. Fix is producer-side tracking in `cg68k.cla`: `cgCallFnScalar`
and the `IUiGetTextviewText` arm spill their +1 result into a
`cgNewTrackedTmp` slot with `cgLastTrackedOff` set last, so the existing
`SAssign`/`SReturn` handoffs and the end-of-statement flush release it
like any other tracked temp. Two hardenings landed alongside: a
`cgLastTrackedOff` latch/restore in `cgEmitStoreScalarAny` (keeps a
dst-address side-effect from stomping the src's own verdict) and a clear
before value evaluation in the six container-set/push arms (keeps a
tracked receiver from being handed off in place of the value). Two
enablers were needed first: `cgTmpSlots` bumped 14 -> 24 (a real
in-tree cprint statement sits at exactly 21 concurrent tracked temps
post-fix, with a full mechanical golden rebless) and a `fpIntrCall12`
split in `cprint.cla` for CODE-segment headroom (output-neutral,
byte-diff-proven). Proof: `internal/cg68k/callresult_release_test.go`
(listing-level release-count pins across direct/local/receiver/operand/
getter shapes) plus the toolbox suite's new `LeakCheck` case (FreeMem
exactly flat, 3570496 -> 3570496, across 1500x4 direct-consumption
shapes on the emulated Mac Plus; toolbox suite now 33 cases, 32 real +
`SelfCheck`). Host lane is untouched (already correct) and unaffected.
**Close-out found a real T2 red** on `TestToolboxSuiteJiggleOn68k/
Popuptable` (only the visual checksum triple failed; every logical
assertion passed) — a per-commit bisect (one native boot each) proved it
PRE-EXISTING, not a codegen regression: the first bad commit is
`520f227`, which is test-only (adds the 33rd suite case, `LeakCheck`);
every codegen commit in the phase passes the gate standalone. Root cause,
confirmed with a heap probe: `rtUiLdefDraw` (`runtime/clarus/uitable.cla`)
derived its row's master pointer via `rtListAt` ONCE, above the per-column
loop, then let three allocating calls per column (`UiNewPtr`/`UiNewRgn`/
`UiGetClip`) run before reading through it — the exact "stale master
pointer across compaction" class this file's own Standing rules section
already tracks (now eight instances). `LeakCheck` merely grew the image
and the suite's own case-row list enough to shift heap layout past the
tipping point; the bug itself predates this phase. Fixed in `bff3268`
(`runtime/clarus/uitable.cla`, +29/-2: the derive moves inside the column
loop, immediately before the read; a second latent instance of the same
defect in the `RtFtChar` column-draw arm fixed alongside). Shared runtime
file — the host/cprint lane had the identical bug (same two hunks in the
emitui golden diff); the fix is not native-only. `internal/cg68k` (55
fixtures) and `internal/emitui` (14 fixtures) goldens reblessed
mechanically. Four more sites with the same shape (an unlocked master
pointer handed to or held across an allocating Toolbox call) were found
but NOT fixed — filed in `docs/TODO.md`. Close-out's T2 also caught a
second, smaller, unrelated pre-existing gap: `internal/bake`'s own
hand-maintained toolbox-suite file-list mirror was missing the
`LeakCheck` case's own fixture file since Task 4, only reachable via the
opt-in `CLARUS_BAKE_FULL=1` step T2 hadn't run to completion until now;
fixed in `cd43280`. Deferred, filed in
`docs/TODO.md`: the `makeRec().field` receiver-context
sibling leak (one type-kind over, out of scope per spec); extending
`testdata/cg68k/smalltmp_ceiling.cla` to pin the new 24-slot ceiling
(optional polish); a host-lane parity note on `pop`/`shift` used as an
operand or receiver (both lanes leak it identically — pre-existing,
out of scope). **The whole-branch final review then found one Critical
at a control-flow seam, also PRE-EXISTING** (this phase only made it
routine): `cgAndOr` short-circuits the RIGHT operand with a real runtime
branch, but tracked-temp registration is emission-time, so the
end-of-statement flush emitted an UNCONDITIONAL release of the right
operand's temp slot past the merge label — on the short-circuit path
that slot was never written this statement, holding either a stale handle
handed off earlier in the same statement (`s = h()` then `if flag and
g().length > 0` — a DOUBLE release of `s`'s live box) or frame garbage
(the pre-existing intrinsic-birth variant, `if flag and (a + a).length >
0`, which bites on `main` too). Fixed by mirroring cprint's guarded temp
scope: `cgAndOr` marks the tracked list before evaluating the right
operand and releases + untracks everything born past that mark on the
operand's own fall-through path, before the branch to the merge label
(D0/D1 bracketed, since Y's bool result is live in D0). Both operands are
bool-typed, so no temp born there can be the expression's own value — the
early release is unconditionally safe, and nested `and`/`or` composes
naturally (each level untracks only past its own, deeper, mark). Pinned
at the listing level by `TestAndOrShortCircuitRelease` (asserts the
release sits INSIDE the guarded region, not just that it happens once)
and on hardware by a new short-circuit shape inside `LeakCheck`, whose
FreeMem assertion is now flat in BOTH directions (a double release frees
early — the opposite signature of a leak). No golden rebless: no `cg68k`
fixture has an and/or with a tracked birth in its right operand. Full
detail: `docs/HISTORY.md` (once archived) or
`.superpowers/sdd/2026-08-29-68k-call-result-release/`.

**`textview-scroll-to-end` phase (branch `textview-scroll-to-end`,
2026-08-29, based on `main` at `36b76ab`) is COMPLETE — full T2 green,
MERGED to local `main` 2026-08-29 (ff 36b76ab..8d4c2e5, NOT pushed):** one new widget method, `textview.scrollToEnd()`
(`../68kbbs/docs/language-gaps.md` §9's log-window ask), wired along the
canvas-method path (`check.cla` `textviewMethods` -> `lower.cla`
`lowTextviewMethod` -> `ui_scroll_to_end` intrinsic -> `cg68k.cla`/
`cprint.cla` one-arm forwarders -> `rtUiWidgetScrollToEnd`,
`uiwidgets.cla`), hardware-proved by the toolbox suite's new `ScrollToEnd`
case (34 cases) via a new `UiTestTextviewScroll` probe; the shelved
implicit follow-if-at-end setter semantics were rejected (ambiguous when
content fits — spec §Problem). Three deviations from the plan: (1) `peekw`
zero-extends but QuickDraw Rect fields are signed, so the plan's runtime
code (copied from `rtUiTeScrollSync`'s shape) went wrong by 65536 once a
scrolled TE's `destRect.top` goes negative — fixed with a new
sign-extending helper, `rtUiPeekSw` (`uiwidgets.cla`), applied to every
Rect-field read in both new functions; (2) the plan's Task 2 file list
missed two required edits (a `shakeAddRoot` line in `lower.cla` and an
`iUiScrollToEndIdx = -1` reset in `ir.cla`), both caught by failing tests,
whose always-on root renumbered every UI program's jump table and forced
a mechanical rebless of 3 `internal/cg68k` fixtures (12 `.s` files) and 12
`emitui` `.c.golden` files; (3) the suite's first emulator boot exposed a
pre-existing bug this phase's own code shares a root with: `rtUiTeScrollSync`'s
clamp compared a zero-extended `destRect.top`, so any `textview` shrunk
while scrolled past its own top was stranded off the end — fixed at the
root by moving the three `destRect` readers (`uitext.cla`, `uiwidgets.cla`)
onto `rtUiPeekSw` too, with a further golden rebless. Spec:
`docs/superpowers/specs/2026-08-29-textview-scroll-to-end-design.md`;
ledger `.superpowers/sdd/2026-08-29-textview-scroll-to-end/`.

**`string-perf` phase (branch `string-perf`, 2026-09-02, based on `main`
at `54292df`) is COMPLETE on its branch — T1 green per task, full T2
pending merge decision, NOT merged:** removes the two dominant measured
string costs on the native lane and adds the warm-buffer text idiom.
Origin: 68kbbs's Snow bench doc traced ~200 ms/row table draws to
Clarus string ops; three read-only code traces plus a new in-repo
calibration bench (`testdata/bench/strbench.cla` + `TestStrBench68k`,
promoted as a permanent measurement instrument) replaced that doc's
guessed model — no Memory Manager traps and no per-char copy on
`string` returns (both hypotheses wrong); the real flat cost was
`cgEmitFunc`'s full-capacity zero loop per string local per call
(~0.48 ms/local measured), plus `s[i]`/`s.length` as out-of-line
`rtStrIndex`/`rtStrLen` calls (~30 instructions of overhead each).
Changes: (1) a plain string local's default-init is now a single
length-byte clear (`cgDefaultInitStrLenOnlyAt`), gated on a zeroed-tail
probe that verified every consumer on both lanes is length-bounded
(ledger Task 1 — globals/record fields/array elements/error messages
keep the whole-slot zero); (2) `IStrLen`/`IStrIndex` emit inline
(unsigned CMP+BCS bounds check; the out-of-range cold path delegates to
`rtStrIndex` for exact panic parity, deliberately avoiding a second
`cgRelClsPanicMsg` identity in the object/bake format); (3) new `text`
methods `clear()` (len=0, capacity kept, zero traps) and `reserve(n)`
(public `rtTextGrow` wrapper), both lanes, reference documented.
Proof: core suite grew to 81 cases (`StrPerf`), toolbox to 35
(`ClearWarm` — FreeMem EXACTLY flat, no slack, across 200 clear+refill
cycles on hardware); after-bench `mklocal4` 10549→1268 ticks (8.3x) and
`strindex` ~71→~24 us/index; snapshot regenerated to fixed point in one
pass. Notable finds: `fpIntrCall3` trips the 32KB segment limit with
two more arms (clear/reserve landed in `fpIntrCall13` per its own
precedent); Mini vMac bench rows are bimodal across runs of the same
binary (TODO.md). Spec:
`docs/superpowers/specs/2026-09-02-string-perf-design.md`; plan
`docs/superpowers/plans/2026-09-02-string-perf.md`; ledger
`.superpowers/sdd/2026-09-02-string-perf/`.
