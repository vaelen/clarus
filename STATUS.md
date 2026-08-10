# Session status — 2026-08-10 (native compiler performance / map rework)

Handoff summary for the next session. Branch: `worktree-native-perf-findings`
(stacked on unmerged `mac-resident-clarusc`, pushed to origin, final
whole-branch review MERGEABLE AS-IS, **not merged** — merge is Andrew's call).

## Why this session happened

On-Mac compiles with `ClarusC.APPL` take hours — useless to a real
programmer. This session (1) audited the compiler for performance problems,
(2) fixed the worst one (maps), and (3) monitored the Snow acceptance run.

## 1. Performance review (no-code exploration)

Full ranked findings: `docs/superpowers/specs/2026-08-10-native-compiler-performance-findings.md`.
Three layers:

- **Layer 1 — algorithmic bugs in clarusc**: `keywordKind` re-interns 33
  keyword literals per identifier (~80-95% of lex time); `exprTypeOf[numToStr(e)]`
  and 7 sibling int-keyed tables laundered through string maps (O(E²)·260B
  ≈ 40-100GB of trap-dispatched memmove per 12k-line compile);
  `cgHeurOnCycle` O(V²·E); codegen inner-loop linear scans with 256-byte
  string compares; every function code-generated twice (measure + emit);
  384-byte `A68Item` copied 8-24× per instruction by the peephole.
- **Layer 2 — systemic runtime costs**: `string` = 256-byte by-value Str255;
  `map` was a sorted array with 256-byte key blocks (docs claimed hashtable);
  every small copy is a `_BlockMoveData` trap; `* / mod` are subroutine
  calls (div = 32-iteration loop); `text[i]` is a JSR; ARC is a full JSR per
  op; every frame reserves ≥8KB.
- **Layer 3 — architecture**: every compile re-lexes/parses/checks/lowers
  ~12.9k runtime lines; tree-shake runs only before codegen; nothing cached
  across compiles. Options ranked: shake-early, session-resident runtime,
  baked pre-parsed runtime, single codegen pass, true separate
  compilation/linker.

Baseline: host does the compile the Mac takes hours on in ~1.25s/142MB RSS.

## 2. map/sortedmap/intmap phase (IMPLEMENTED, this branch)

Spec: `docs/superpowers/specs/2026-08-10-map-hashtable-design.md`; plan:
`docs/superpowers/plans/2026-08-10-map-hashtable.md`; ledger:
`.superpowers/sdd/2026-08-10-map-hashtable/progress.md` (11 tasks, all
review-clean; ~33 commits `7a7d6e1..` incl. the docs below).

- **`map of T` is now a real hashtable in BOTH lanes**
  (`runtime/clarus/map.cla` + `runtime/host/rt_core.inc`, byte-identical
  algorithms): dense insertion-order entries + open-addressed power-of-two
  index, djb2 hash 31-bit-masked per step, mask-only arithmetic (no div),
  variable-length key pool (256-byte key blocks GONE), swap-last remove.
  Iteration order is now **unspecified-but-deterministic** (reference
  updated); drop-in otherwise — same API, panics, contracts.
- **`sortedmap of T`** — the old sorted implementation preserved verbatim as
  a new type (ascending-key iteration contract), spliced only when used.
- **`intmap of T`** — int keys, identity hash, always spliced (lives in
  map.cla). Key single-evaluation bug found in review and fixed (749e91f).
- **Compiler migrated to intmap** (Stage B): `exprTypeOf` family keyed by
  arena index directly (numToStr keys deleted), `Scope.names` keyed by
  interned nameIdx, shake/ir name tables. Emitted output proven
  byte-identical pre/post; snapshot regenerated twice
  (Stage A `dc24e96`, Stage B `9cc5c1c`), fixed point holds.
- **Tests**: core suite 42→54 cases (map stress, sortedmap ordering
  contract, intmap incl. growth/negative keys); order-dependent
  expectations made order-agnostic BEFORE the switch; 68k emulator suite
  green: core 54/54, toolbox 28/28 — the hashtable's first hardware run.
- **Measured results (host)**: the silently-red-on-main
  `TestEmitPerfTripwire` went GREEN — host emit median ~1.1-1.5s → **0.205s**
  (vs 0.300s baseline); the old O(n)·256B sorted-array map insert WAS that
  regression. The compiler-internal intmap migration measured host-NEUTRAL
  (initial ~6% claim retracted after review) — its rationale is the
  **unmeasured 68k lane**, where each old lookup paid a numToStr allocation
  + string hash + per-probe rtStrCmp calls.
- **Debt/deferrals** (all in the ROADMAP phase entry): T2/`internal/selfhost`
  NOT run this phase (expect possible `clarusc/test/*.out` churn on first
  T2); Stage C candidates: intmapHash multiplicative mixer (if 68k
  measurement shows clustering), remaining int-keyed tables
  (ast.cla externReg*, checkEnumDecl seen, recFieldsHeadByName/xrecSizeByName),
  probe-loop corruption guards, offsetof layout assertions, map/sortedmap
  `get(k, dv)` host-vs-native argument-evaluation-order corner,
  `edit sm[k]` diagnostic quality, ir\*NeededByName cross-compile reset.

## 3. Docs housekeeping

`docs/ROADMAP.md` split (2,385 → 792 lines): all merged-to-main phase
records moved verbatim to new `docs/HISTORY.md` (1,632 lines, newest-last);
ROADMAP keeps sequencing, Standing principles (the Toolbox GUIDING
PRINCIPLE), the two unmerged phase entries, small open items, process
conventions. CLAUDE.md pointers updated.

## 4. Snow acceptance run (mac-resident-clarusc) — FAILED, with a milestone

The unattended 13h run (started 05:47 JST, verdict 18:48 JST) FAILED:

- **Milestone: compile #1 SUCCEEDED on the Mac** — `TickProbe` extracted at
  **102,016 bytes**, a full-size fork (not the 12KB husk). The CR-lexer fix
  (0637077) is proven on hardware; ClarusC fully compiled a real program
  on-Mac for the first time.
- **Failure: compile #2 (catprobe) died with `runtime error: out of
  memory` (exit 3)** inside the 48MB partition. Likely mechanism: single
  compile peaks at 39.8MB (task-1 profile, OLD map runtime) and compile #2
  starts from a heap carrying compile #1's residue (never-reset intern
  pool + irLayoutNeededByName/irRcWalkNeededByName by design, plus
  fragmentation).
- Log: `/private/tmp/claude-501/-Users-andrew-repos-clarus/6e547e26-.../scratchpad/integration-run-final.log`;
  run-by-run history in
  `/Users/andrew/repos/clarus/.superpowers/sdd/2026-08-08-mac-resident-clarusc/progress.md`
  (main checkout) and its task-11-report.md.

## Recommended next steps (in order)

1. **Rebuild `ClarusC.APPL` from THIS branch and rerun the Snow
   acceptance.** The failed run used the pre-hashtable runtime; the map
   rework directly attacks both the OOM (6-10MB of exprTypeOf keys alone,
   256-byte key blocks gone) and the multi-hour compile time (the O(E²)
   memmove and intern-pool costs were 68k-lane dominant). This is the
   cheapest decisive experiment.
2. Measure per-phase `TickCount()` on-Mac to convert the findings doc's
   memory-derived ranking into real 68k timings.
3. Next perf targets from the findings doc (Layer 1): `keywordKind`
   pre-interned constants (~10× lexing), `cgHeurOnCycle` adjacency+SCC,
   codegen lookup maps + `cgSizeOf` memo, `a68Comment` gating, single
   codegen pass.
4. Run T2 (`scripts/test-merge.sh`) before any merge to main; expect
   possible module-golden churn (documented debt).
5. Merge decisions (Andrew's): `mac-resident-clarusc` still gated on a
   Snow acceptance PASS; `worktree-native-perf-findings` is
   review-approved and stacked on it.
