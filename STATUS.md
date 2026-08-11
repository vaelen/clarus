# Session status — 2026-08-11 (layer1-compiler-perf close-out)

Handoff summary for the next session. Branch: `worktree-native-perf-findings`
(stacked on unmerged `mac-resident-clarusc` → `map-hashtable` →
`datetime-instrumentation`, pushed to origin, **not merged** — merge is
Andrew's call).

## Why this session happened

The native-compiler performance findings doc (`docs/superpowers/specs/
2026-08-10-native-compiler-performance-findings.md`) catalogued algorithmic
bugs in clarusc itself — Layer 1 of a three-layer diagnosis. This phase
worked that list end to end: 19 tasks, every §1.1-§1.8 item addressed
(fixed, already-fixed, or explicitly deferred with rationale), plus a new
`.clear()` language feature the fix set needed.

## 1. layer1-compiler-perf phase (IMPLEMENTED, this branch)

Ledger: `.superpowers/sdd/2026-08-11-layer1-compiler-perf/progress.md` (19
tasks, all review-clean; commits `94bc1f1..d3581f5`). Findings doc now
annotated per-item (`[FIXED]`/`[DEFERRED]`/`[DROPPED]`/`[ALREADY FIXED]`/
`[STALE]`). Full detail in the ROADMAP phase entry — summary here:

- **Fixed:** §1.1 (`keywordKind` intern storm), §1.3 (`cgHeurOnCycle`
  O(V²·E) BFS → iterative Tarjan SCC), §1.4 (codegen linear scans →
  interned-int lookups), §1.5 (`cgIntr` string dispatch → int arms), §1.6
  (peephole's 384-byte record copies → in-place access, then the record
  itself shrunk to 72 bytes via side tables), and every §1.8 near-free item
  except `numToStr` (dropped, moot) and `scopeLookup` (already fixed).
- **Already fixed:** §1.2 (`exprTypeOf[numToStr(e)]`) — the prior
  map-hashtable phase's `intmap` migration already closed this.
- **Deferred:** §1.7 (every function code-generated twice) — the cheap
  single-segment-reuse fix wouldn't help `ClarusC.APPL` itself (32
  segments); the full fix needs relocation entries, which is Layer 3
  (architecture/caching) scope, not this phase's.
- **Language addition:** `.clear()` for `list`/`map`/`intmap`/`sortedmap`
  (Task 8) — surface syntax over runtime functions that already existed,
  enabling O(1) arena resets instead of pop-loop drains (70 call sites
  converted). Core suite grew 57 → 58 (`ClearBasics`).
- **Unplanned fixes found mid-phase:** Task 0b (a pre-existing
  `macgui.cla` declare-before-use bug broken since the
  datetime-instrumentation phase, fixed for real); Task 8b (`.clear()`'s
  own ~210 new globals broke macgui's 32KB segment limit — fixed by
  restricting `staterows` dispatch arms to list-typed globals only).
- **Gate amendment (Task 10):** multi-segment byte-identity checks moved to
  a frozen source tree (`/tmp/l1src`, git-archive of a fixed commit)
  instead of the live working tree, once `macgui.cla` itself became a file
  later tasks edit — otherwise "input changed" and "compiler behavior
  changed" are inseparable.

### Measured results (10-pair interleaved medians unless noted)

| Benchmark | Pre-phase | Post-phase | Speedup |
|---|---|---|---|
| Host self-compile (`emit clarusc/main.cla`) | 0.531s | 0.465s | 1.14x |
| `emit68k testdata/cg68k/tickprobe.cla` | 0.122s | 0.034s | 3.60x |
| `emit testdata/emitui/every.cla` | 0.066s | 0.047s | 1.40x |
| Frozen-fixture macro (`emit68k` of frozen `macgui.cla`, per-task tracked) | 2.69s (Task 0) | 0.55s (Task 18) | ~4.9x |
| Peak RSS, `emit68k tickprobe.cla` | 129.1 MB | 36.9 MB | 3.5x |
| Peak RSS, `emit68k` frozen macgui | 882.5 MB | 215.3 MB | 4.1x |

Host self-compile gains are modest relative to the 68k macro numbers
because host codegen hot paths are native-side and the self-compile
fixture is small — **the frozen-fixture 68k numbers are the honest
headline: ~4.9x faster, ~4.1x less peak memory**, on the exact workload
that matters (compiling a real multi-segment 68k app).

### Debt / deferrals (all recorded in the ROADMAP entry)

- §1.7 (double codegen) deferred to a future Layer-3 phase — needs
  relocation entries for segment-independent emission.
- Layer 2 (systemic runtime/codegen costs — 256-byte `Str255`, etc.) and
  Layer 3 (architecture/caching) both untouched this phase, by design
  (findings doc's own suggested sequencing).
- **T2 (`scripts/test-merge.sh`) still owed before any merge** — now
  covers three stacked, unmerged phases (map-hashtable,
  datetime-instrumentation, this phase). Not run this session.
- **On-Mac instrumented timing capture still pending** — see next steps
  below; this is the single most valuable next experiment.

## 2. Prior phase context (still true, unchanged this session)

- **map/sortedmap/intmap** (map-hashtable phase, done 2026-08-10): `map of
  T` is a real hashtable on both lanes. Full detail: ROADMAP's
  map-hashtable entry.
- **datetime + instrumentation** (datetime-instrumentation phase, done
  2026-08-11): `now()`/`dateTimeStr()`/`durationStr()` builtins, plus the
  `feProgress` seam giving clarusc always-on progress + per-phase
  `TickCount()` output on both the host CLI and `ClarusC.APPL`'s Log
  window. Full detail: ROADMAP's datetime-instrumentation entry.
- **Snow acceptance run (mac-resident-clarusc):** last run FAILED with a
  milestone — compile #1 succeeded on real Mac hardware (full-size fork);
  compile #2 died OOM in a 48MB partition. That run predates BOTH the
  hashtable fix and this phase's ~5x compiler speedup, and predates the
  progress instrumentation entirely (so it also gave no visible sign it
  was running before the OOM).

## Recommended next steps (in order)

1. **Rebuild `ClarusC.APPL` from THIS branch and rerun the Snow
   acceptance.** This branch now carries the map-hashtable fix, working
   progress instrumentation, AND this phase's ~5x native compiler speedup
   with ~4x less peak memory — the OOM's odds of recurring are much lower,
   and if it does recur, the Log window and stderr will show exactly where
   for the first time.
2. **Capture real on-Mac per-phase timings** using the instrumentation
   built last phase — the decisive step that turns the findings doc's
   memory-derived Layer-1 ranking into measured fact, and would validate
   (or redirect) which Layer-2/Layer-3 target to pick next.
3. **DONE (clarusc-live-log phase, 2026-08-11, this branch).** Landed the
   live-log-window spec (`2026-08-10-clarusc-mac-live-log-design.md`,
   including its §3b amendment) — full detail in the ROADMAP's
   `clarusc-live-log` phase entry. Frozen-scenario goldens re-verified,
   no churn.
4. Pick a Layer-2/Layer-3 target once on-Mac numbers exist: candidates are
   `string`'s 256-byte `Str255` representation, §1.7's full double-codegen
   fix (needs relocation), or codegen's calls-out-for-everything pattern
   (findings doc §2.3).
5. Run T2 (`scripts/test-merge.sh`) before any merge to main; expect
   possible module-golden churn (standing debt across all three stacked
   phases).
6. Merge decisions (Andrew's): `mac-resident-clarusc` still gated on a
   Snow acceptance PASS; `map-hashtable`, `datetime-instrumentation`, and
   `layer1-compiler-perf` are all review-approved and stacked on top of
   it, unmerged.
