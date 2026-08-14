# Clarus Roadmap

Living document — the authoritative sequencing and strategy record. Updated
2026-08-10. The per-task execution history lives in `.superpowers/sdd/progress.md`
(gitignored scratch; git history is the durable record).

Completed phases are archived in `docs/HISTORY.md`.

## Standing principles

**GUIDING PRINCIPLE (Andrew, 2026-08-07 — governs all future Toolbox work;
ratifies and extends the sunset follow-on):** any call into the Toolbox goes
through the appropriate `toolbox/*.cla` interface — runtime code included — to
unify the cprint and native backends and cut duplication. When a new feature
needs a new Toolbox function, enable the rest of that manager's interface at
the same time where feasible, rather than declaring one routine at a time.
Layering follows the 80/20 rule: the RUNTIME uses Toolbox calls directly, but
the majority of user code should never need to — most Toolbox routines hide
behind friendlier Clarus abstractions (e.g. cut/copy/paste is a simple
capability on text controls, not a Scrap Manager lesson), so a "standard"
application is written entirely through the lens of the Clarus language. The
catalog exists so users CAN drop to the Toolbox outside the common case, not so
they must. API-era discipline: prefer the Toolbox as defined by the 1980s
Inside Macintosh volumes (I–V; Volume VI covers System 7.0) — target System 6
features whenever possible, and gate any System 7-only feature behind a version
check (Gestalt) with a graceful fallback when the feature is absent.

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
    `text` methods (`hashStep`/`u32At`/`stringAt`/`textAt`, Chapter 3),
    the CLIR body/stamp/manifest hash swapped from FNV-mul to a
    shift-add djb2 step (the multiply was noise per the motivating
    probe; inside a per-call loop it would have become the dominant
    term), and `bake.cla`'s load path rewritten onto the four bulk
    reads behind the existing overrun soft-fail guard.
    `bkFormatVersion` 6→7 (byte layout unchanged, hash meaning
    changed).

  **Task ledger** (commits `11cf5d6..5db9e1a` before this docs task):
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

  **Measured results** (Mini vMac / Mac Plus, 8MHz 68000, 60.15 guest
  ticks/s, N=65536-byte probe buffer;
  `.superpowers/sdd/2026-08-15-clir-load-perf/task-9-report.md`):

  | pass | old (µs/byte) | new (µs/byte) | speedup |
  |---|---:|---:|---:|
  | body hash | 153.98 (`hash-exact`, per-byte) | 60.63 (`bulk-hash-chunked`, shipped 32KB-chunk shape) | **2.54x** |
  | U32 section-field walk | 200.91 (`getbyte-walk`) | 55.05 (`bulk-u32`) | **3.65x** |
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
    stringat_cap`, `stringat_negative`, `textrange_overflow`,
    `textrange_oor`): pinned by `internal/selfhost/behavior_test.go`'s
    `.behavior` goldens (T1, both lanes' semantics proven equivalent by
    construction) but, unlike `oob`/`listindex`, never booted natively
    by `TestRunErrOn68k` — the same "host-pinned, no per-lane boot"
    convention test-consolidation established for panic fixtures whose
    semantic coverage doesn't need a hardware boot.
  - **`bkReadObjCode`'s `nHoles` spin** (Task 5 minor, pre-existing):
    the loop spins on a corrupt hole count before the framing check
    fires — not new to this phase, not fixed by it.
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
  shape is corpus-untriggered. (Formerly documented in
  internal/selfhost/inventory.md, deleted as orphaned in the
  Go-compiler-deletion final-review wave, 2026-08-05; recoverable from tag
  `go-compiler-final`.)
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
- **ARC milestone: DONE** — see docs/HISTORY.md (Done item 11). All `.leaks` goldens at zero
  (files deleted); the 4e escape-analysis apparatus deleted.
- **Retain/release elision (conditional follow-on, not triggered):** the
  ARC design's own non-goal was naive ARC first, elision only if the 68k
  measurement demanded it. Measured (docs/HISTORY.md, Done item 11): Bookmarks +0.12s
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
- **`accepted(rec)` trailing-bool codegen bug: DONE** — already fixed by
  small-scalar-width commit `8278ae7` (`rtUiFormAccept` bool writeback
  `pokel`→`pokeb`, `runtime/clarus/uidialogs.cla`); root-caused and
  `formedit` migrated to `testsuite/toolbox/cases_formedit.cla` during
  test-consolidation (2026-08-06), which pins the regression (the case
  FAILs at the pre-fix commit). Originally found during
  ui-scenario-retirement, 2026-08-05, when the bug blocked `formedit`'s
  migration and it stayed a scripted-lane scenario, temporarily, until
  this fix landed.
- **Launch-an-application-from-Clarus (deferred, ui-scenario-retirement
  spec Out-of-scope 1, Andrew 2026-08-05; also out of scope for
  test-consolidation, 2026-08-06):** a function to launch another
  app from inside Clarus so an on-Mac suite could exercise the example
  apps (mandelbrot, texteditor, …) directly. System 6's `_Launch`
  REPLACES the running application (no MultiFinder supervision), so this
  needs its own design (sub-launch conventions, result handoff via file,
  relaunch-the-suite chaining, or System 7/MultiFinder gating). The
  remaining 4 scripted-lane scenarios (`smoke_bounce`, `smoke_mandel`,
  `texteditor`, `bookmarks` — down from 11 after test-consolidation
  merged/migrated/deleted the rest, native lane only since that phase's
  Task 7 also retired the Retro68/cprint scenario lane) eventual fate
  rides on this.
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
- **Menu-bar cleanup / per-window menu bars (found post-ui-scenario-
  retirement, Andrew 2026-08-05):** toolbox-suite cases (and harness
  windows generally) install menus they never tear down; more broadly, a
  multi-window application may want its own menu-bar set per window
  (swapped on activate), which needs its own design. Current behavior: a
  composed suite program shows all app-scope menus, in declaration order,
  for the whole run.
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
- **Remaining odd-C-size record-layout divergences (filed 2026-08-06,
  strn-field-alignment spec Out-of-scope):** the same divergence family
  the `string(n)` fix closed still exists for the other odd-C-sized field
  kinds — `char[n]`/`bool[n]` array fields with odd n (cg68k even-rounds
  the field slot, `char[3]` occupies 4 with 2-byte alignment; C packs at
  exact size, natural alignment 1), the degenerate `char[1]`/`bool[1]`
  case (where cg68k's even-rounded 2-byte slot arguably contradicts the
  reference's "packs at 1-byte alignment, same as a bare bool/char field"
  sentence — decide reference wording vs `cgSlotSizeOf` before fixing),
  and all-byte records (odd C `sizeof`, unrounded, struct alignment 1 —
  diverging from cg68k's even-rounded `cgRecordSize` in total size,
  nested-record field offset, and array-of-record stride). Same root
  cause, rarer shapes, offsets never consumed cross-lane (latent). Note
  the `string(n)` fix's pad walk already converges a `string(n)` field
  that FOLLOWS one of these shapes; only non-str fields after them, and
  the totals themselves, still diverge.
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
- **Transient `emit68k` extern-record-decay crash (found during
  toolbox-cookbook Task 4, 2026-08-06; unconfirmed/environment-
  sensitive):** a single observed `emit68k` crash (`runtime error: list
  index out of range`) compiling an `extern record` decayed to a pointer
  at a real trap call site. A 5-rung minimal-pair ladder (single-file
  standalone shapes up through the exact original crashing composition,
  rebuilt fresh from the untouched `clarusc/clarusc.c`) failed to
  reproduce it, 0/28 attempts including 28 runs of the exact original
  composition. Recorded as unconfirmed rather than fixed or dismissed.
  Repro ladder archived at
  `.superpowers/sdd/2026-08-06-toolbox-cookbook/repro-decay-crash/`.

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
