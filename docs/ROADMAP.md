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
     toolbox suite grew 29 → 30 real cases (`nTbCases`, `runtime.cla`).
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
