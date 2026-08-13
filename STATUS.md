# Session status — 2026-08-13 (runtime-ir-bake MERGED; fallback-trigger-narrowing specced+planned)

Handoff summary for the next session. Current branch:
`fallback-trigger-narrowing` (created from `main` after the
runtime-ir-bake merge). **`runtime-ir-bake` was MERGED to `main`
(fast-forward `322765a..b16e8f0`, Andrew's instruction, 2026-08-13
09:56 JST) and pushed to origin** — the six-phase stack plus
runtime-ir-bake are all on `origin/main`.

## 0. START HERE next session: implement fallback-trigger-narrowing

Brainstormed, specced, and planned 2026-08-13 morning (Andrew-approved
design). **Spec (normative):**
`docs/superpowers/specs/2026-08-13-fallback-trigger-narrowing-design.md`
**Plan (4 tasks):**
`docs/superpowers/plans/2026-08-13-fallback-trigger-narrowing.md`

One-paragraph summary: a user `include` of a bake-carried file (the 18
runtime modules or the three transitively-baked toolbox catalog files)
currently abandons the bake for that compile. The fix mirrors
from-source's hoist-dedup by construction: parse the user's copy for
check#1 visibility only, drop it before lowering (the baked IR already
holds the module at the hoist position), so byte-identity holds by
construction. A per-module source hash (CLIR v4→v5) scopes the remaining
fallback to genuine on-disk drift. Housekeeping folded in: the
`macgui.cla` fallback-reason string (stale since the v4 body hash) and
the dead tight-scratch indirection in `cg68k.cla` (zero-churn goldens
required). Execution: subagent-driven per CLAUDE.md (sonnet impl/review,
opus for the hardest reviews, most-capable final review; NEVER Fable for
subagents; log models at dispatch). Task 1 is a probe wave (commits
nothing) verifying the two load-bearing assumptions — checker-state
parity and exact-drop — and choosing the subtree-drop mechanic; its
report may amend Tasks 2-3. Merge gate: full T2 at tip PLUS the standing
Snow rerun (`TestClarusCBakePathOnSnow`, ~1h) since `bake.cla`/
`macgui.cla` change.

After this phase, stage 3.5 (object code + linker) per
`docs/superpowers/specs/2026-08-12-precompiled-artifacts-design-notes.md`.

## 1. runtime-ir-bake close-out (DONE, merged)

`runtime-ir-bake` is DONE, full `scripts/test-merge.sh` GREEN (232s at
commit `3bdbb3b`, re-confirmed 233s at tip `b16e8f0`). Task 7's own
first full T2 run found a real, pre-existing regression (two independent
latent bugs, neither introduced by this phase); it was root-caused and
fixed the same day, in a follow-up session, with a regression test added
after. Short version (full writeup: ROADMAP `runtime-ir-bake` entry's
"T2 blocker" subsection, and
`.superpowers/sdd/2026-08-12-runtime-ir-bake/t2-blocker-fix-report.md`):

- **Bug 1 (the crash):** `rtUiTableRelayout` and four sibling functions
  (`runtime/clarus/{uitable,uitext,ui,uiwidgets}.cla`) wrote through a
  List/TE Manager master pointer captured BEFORE an intervening
  `UiNewPtr` call, which can relocate the unlocked handle during heap
  compaction — a stale write that left `PopupTableWin`'s table view rect
  zeroed, so a scripted click computed an out-of-range row index. All
  five sites now re-derive the master pointer immediately before use.
- **Bug 2 (why the panic message was empty, hiding bug 1 for a whole
  session):** `cgEmitPanic` (`clarusc/cg68k.cla`) still used the
  pre-param-abi by-value `Str255` push for `rtPanic(msg)`; the param-abi
  phase's by-address `KStr` ABI made every param slot hold a pointer
  instead, so `rtPanic` read the panic literal's own first 4 bytes as an
  address — every native list-bounds panic printed an empty message,
  compiler-wide, not just for this crash. Fixed to push the address.
- **`e72b92a`'s Task 5 splice reorder never caused this** — the prior
  session's leading hypothesis was disproven, not confirmed: a
  code-independent flip (changing only a `--bake` resource NAME's byte
  length, not the compiled code) reproduced the crash with byte-identical
  emitted segments, ruling out every code-layout theory. Both bugs are
  genuinely pre-existing; any earlier PASS of `TestToolboxSuiteOn68k` was
  heap-layout luck.
- **Regression test added** (Task 7 finisher, same day):
  `testdata/runerr/listindex.cla`/`.err`/`.behavior`, exercising
  `cgEmitPanic`'s inline list-bounds path specifically (as opposed to
  `oob.cla`'s ordinary fixed-array path) in `TestRunErrOn68k` — asserts
  the real panic TEXT on a booted native binary, so this bug class can't
  hide silently again.
- Tree is clean; `git worktree list` shows only the main worktree
  (scratch investigation worktrees from the earlier session were
  removed).
- **Final-review fix wave (2026-08-13, commits after `1f75848`):** added
  a CLIR body-integrity hash (format v4 — see ROADMAP entry's "Deferred
  / phase debt" for the write-up) plus a `bkGetByte` bounds guard, a
  `driveReset` defensive-reset parity fix, and doc corrections. **Standing
  rule going forward: re-run `TestClarusCBakePathOnSnow`
  (`CLARUS_SNOW_TESTS=1`) manually after any future change to
  `clarusc/bake.cla` or `clarusc/macgui.cla`** — it's the only proof of
  the `ClarusC.APPL` default bake path, and neither T1 nor T2 boots it.

Design context (unchanged): **Spec (normative):**
`docs/superpowers/specs/2026-08-12-runtime-ir-bake-design.md` (now
annotated where Tasks 1/4/5 narrowed its claims). **Plan (7 tasks):**
`docs/superpowers/plans/2026-08-12-runtime-ir-bake.md`. **Parent design
context:** `docs/superpowers/specs/2026-08-12-precompiled-artifacts-design-notes.md`.

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

## 3. memory-leak-fix phase close-out (2026-08-12, this session, branch `memory-leak-fix`)

**COMPLETE.** 16 commits (`bf07436..f3419bc`) plus one T2-debt-fix commit
on top implementing the 8-task plan referenced in step 0 below: per-compile
growth went from ~42,845 Memory Manager blocks/compile to 0, with the
leak-gate (`internal/mactest/leakgate_test.go`'s `DoubleCompile` alternating
oracle) and the byte-identity oracle both green, and the bootstrap snapshot
(`clarusc/clarusc.c`) regenerated with the fixed codegen.

T2 (`go test ./internal/selfhost -count=1 -timeout 30m`) was staged green
this session **except** two pre-existing, cross-phase `TestClarusModules`
failures unrelated to the leak fix itself:

- `check_test.cla`: the datetime-instrumentation/live-log phases added
  `driveProgressTick()` calls inside `check.cla`, but `driveProgressTick`
  lives in `drive.cla`, which this module test's file list doesn't include
  (by design — it would drag the whole driver/front-end world into a
  checker-only test). Fixed by giving `check_test.cla` its own no-op
  `driveProgressTick()` stub, the same fe*-seam pattern `main.cla`/
  `macgui.cla` already use for their own front-end hooks.
- `asm68k_test.cla`: a golden mismatch from the layer1-compiler-perf
  phase's findings-1.8 commit (`9faa69f`), which gated `asm68k.cla`'s
  self-exerciser's `"end of exerciser"` listing comment behind
  `a68ListingOn` (default false, matching `--listing`'s own default) —
  legitimate behavior change, golden never refreshed. Golden regenerated
  from the current driver's actual output (verified via direct diff: the
  removed comment line was the only delta).

With both fixed, T2 is fully green. Next: the Snow two-compile rerun (step
1 below) is the remaining validation step for the leak fix on real
hardware (expect compile #2 timings to now track compile #1's, not the
degraded ~4x-slower numbers the original investigation measured); after
that, merge decisions cover six stacked phases (`mac-resident-clarusc`,
`map-hashtable`, `datetime-instrumentation`, `layer1-compiler-perf`,
`memory-leak-fix`, `param-abi`).

## 4. param-abi phase close-out (2026-08-12, this session, branch `param-abi`)

**Phase complete on branch `param-abi` (stacked on `memory-leak-fix`).**
Implements the 2026-08-10 performance findings doc's §2.1: immutable
parameters (language + checker) plus by-address `KStr`/`KRec` parameter
passing on both lanes (storage unchanged — see the ROADMAP's param-abi
entry for full detail, design doc, and fix-round history). 8 tasks,
commits `94725e2..f210e4f`; ledger:
`.superpowers/sdd/2026-08-12-param-abi-immutability/progress.md`.

- **Snapshot regen (Task 8 step 1):** `clarusc/clarusc.c` regenerated to a
  Go-free fixed point in 2 iterations (the first re-emission still
  differed — `retain_FuncSig`/`retain_Scope`/etc. gained `const` params —
  a second boot-and-reemit cycle converged to byte-identical output).
  `TestSnapshotFixedPoint` PASS.
- **Full selfhost gate (Task 8 step 2):** `go test ./internal/selfhost
  -count=1 -timeout 30m` — **green, 0 failures, 89s** (`TestClarusModules`
  incl. `check_test`/`asm68k_test`, `TestErrorGoldens` incl.
  `param_assign`, `TestSnapshotFixedPoint`, the works).
- **Perf (Task 8 step 3), 10-pair interleaved medians, old = merge-base
  `cc3f798` snapshot vs. new = this phase's regenerated snapshot:**

  | Benchmark | Old | New | Delta |
  |---|---|---|---|
  | Host self-compile (`emit clarusc/main.cla`) | 0.42s | 0.39s | 1.08x faster |
  | `emit68k testdata/cg68k/tickprobe.cla` wall time | 0.02s | 0.02s | no measurable change |
  | Peak RSS, `emit68k tickprobe.cla` | 29.35 MB | 30.64 MB | ~4% higher |
  | `emit68k clarusc/macgui.cla` (33 segments) wall time | 0.52s | 0.46s | 1.13x faster |
  | Peak RSS, `emit68k clarusc/macgui.cla` (33 segments) | 172.5 MB | 188.1 MB | +9.05% higher |

  `tickprobe.cla` is too small a fixture to exercise the copy-avoidance
  this phase targets; its numbers are dominated by fixed compiler-process
  overhead. The macgui row is the representative signal — a real
  33-segment `ClarusC.APPL`-shaped compile, genuinely **1.13x faster** —
  using the CURRENT working-tree `clarusc/macgui.cla` (byte-identical
  between old and new base since Task 1 never touched it, so no fresh
  freeze was needed; the layer1 phase's own `/tmp/l1src` frozen-source
  procedure is confirmed stale — its source predates this phase's
  immutable-parameters checker and fails to compile against it, 11
  `cannot assign to parameter` errors — but wasn't required here). The
  RSS increase (+9.05%) is real at this scale too, not a small-fixture
  artifact; recorded as an open observation in the ROADMAP entry
  (plausible suspects: new call-site copy temps, classification-flag
  arena growth), not investigated further this task.
- **T2 fully green at `5e44fd3`** (run post-final-review, 2026-08-12
  17:36 JST): `scripts/test-merge.sh` PASS in 225s — T1 body 18s,
  `internal/selfhost` 89s, gated native `internal/mactest` emulator lane
  118s. (The whole gate now fits in under 4 minutes — the stacked
  phases' compiler speedups shrank what used to need a 30m selfhost
  ceiling.) Merge remains Andrew's call.
- **Docs (Task 8 step 4):** findings doc §2.1 annotated `[FIXED
  2026-08-12]`; ROADMAP phase entry added (design/plan paths, task
  ledger, fix rounds, perf table, deferred items); this STATUS section.
- **Deferred (full detail in ROADMAP entry):** bare-`EIntr` arg release
  gap on both lanes (pre-existing, narrowed not closed); `KArr` param ABI
  still out of scope (KStr/KRec only this phase); `toBytes` mutation
  guard fires on method name alone (inert today, one registrant).

**Next steps unblocked by this phase:** the precompiled-artifacts design
notes (`docs/superpowers/specs/
2026-08-12-precompiled-artifacts-design-notes.md`) were deliberately
parked pending this ABI rewrite (its own "Sequencing decision" section) —
that prerequisite is now satisfied, so a future session can pick that doc
back up and plan the bake/object-code/artifact-cache work on a frozen
param ABI.

## 5. runtime-ir-bake phase (2026-08-12/13, branch `runtime-ir-bake`) — DONE, T2 GREEN

Implements precompiled-artifacts item 3 at IR depth: bakes the runtime's
post-`lowerProgram` IR (unconditional superset, all 17 68k-lane modules)
into a stamped `'CLIR'` resource; `ClarusC.APPL` consumes it by default,
the host CLI opts in via `--rtbake FILE`. check#2 and every manifest
splice conditional are retired. See the ROADMAP's `runtime-ir-bake` entry
for the full task ledger, latent-bug finds, design-claim narrowing, perf
table, deferred items, AND the T2-blocker root-cause/fix writeup —
summary here.

- **7 tasks, commits `322765a..c99d95a`, a Task 7 close-out wave
  (`c99d95a..ac423b0`), then the T2-blocker fix (`3bdbb3b`).** Task 1
  (probe, no tree commits) found the naive superset splice breaks 26/28
  non-UI native fixtures (dispatcher-synthesis gate bug) and narrowed
  the check#2 assumption. Task 2 fixed the dispatcher bug + made the
  from-source splice unconditional superset. Task 3 built the `'CLIR'`
  serializer. Task 4 built the loader (`--rtbake`) + leak-gate bake-path
  twin. Task 5 closed the full-corpus byte-identity gap both lanes (3
  fix rounds, Opus review). Task 6 wired `ClarusC.APPL`'s bake-by-default
  path and root-caused a real cg68k `fromBytes`/`toBytes` stride-2
  codegen bug the bake path exposed (2 fix rounds), then proved
  byte-identity on real Snow hardware (3 Snow runs). Full ledger:
  `.superpowers/sdd/2026-08-12-runtime-ir-bake/progress.md`.
- **Task 7, Step 0 (housekeeping, commit `a5d23fd`):** fixed three
  deferred review minors — stale doc comments describing retired
  conditional-splice gates as live consumers (`check.cla`, `cprint.cla`);
  reverted `cases_resources.cla`'s workaround for the now-fixed cg68k
  stride bug back to the natural `.toBytes()`+`buf[i]` form, making it a
  standing regression test; added the loud duplicate-reserved-name
  refusal `cliResolveBakeIr` was missing (`main.cla`).
- **Step 1 (snapshot regen, commit `ac423b0`):** `clarusc/clarusc.c`
  regenerated to a Go-free fixed point in 2 bootstrap rounds (same as
  param-abi's own regen). Verified freshness and fixed point
  independently before committing. Full `go test ./internal/selfhost
  -count=1 -timeout 30m` green, **93s**, including
  `TestSnapshotFixedPoint`. `CLARUS_BAKE_FULL=1 go test ./internal/bake
  -run TestBakeFullCorpus` green too.
- **Step 2 (perf), 10-pair interleaved medians, host,
  `/usr/bin/time -l`, using the regenerated snapshot compiler
  (`-O1`):**

  | Benchmark | From-source | `--rtbake` | Speedup |
  |---|---|---|---|
  | `emit68k clarusc/macgui.cla` (37 segments) wall time | 0.335s | 0.170s | ~1.97x faster |
  | Peak RSS, `emit68k clarusc/macgui.cla` | 197.0 MB | 198.8 MB | ~1% higher |
  | Host self-compile (`emit clarusc/main.cla`) wall time | 0.625s | 0.410s | ~1.52x faster |
  | Peak RSS, host self-compile | 330.6 MB | 328.1 MB | ~1% lower |
  | Bake generation (one-off), `--bake-ir --lane 68k` | 0.04s / 22.5 MB peak RSS | — | — |
  | Bake generation (one-off), `--bake-ir --lane c` | 0.02s / 18.7 MB peak RSS | — | — |

  Both benchmarks show real wall-time wins with flat peak RSS either way.
  Raw 10-pair data in `.superpowers/sdd/2026-08-12-runtime-ir-bake/task-7-report.md`.
  The Mac-side win was measured on real Snow hardware in Task 6: a
  bake-path `TickProbe` compile completed in 55m2s wall clock
  (settle=55m), against the pre-phase ~66m reference — directional, not
  a controlled pair (different sessions/settle windows/baselines).
- **Step 3 (docs):** ROADMAP `runtime-ir-bake` phase entry (task ledger,
  latent-bug finds, design-claim narrowing, perf table, deferred items,
  T2-blocker root-cause/fix writeup); this STATUS section;
  precompiled-artifacts notes doc's Staging section marked stages 1+2
  implemented; the design doc annotated at the three claims Tasks 1/4/5
  narrowed.
- **Step 4, T2 first run: found a real, pre-existing regression** (two
  independent latent bugs — a stale List/TE Manager master pointer
  across heap-compacting `NewPtr` calls in 5 sites across
  `uitable`/`uitext`/`ui`/`uiwidgets.cla`, and `cgEmitPanic`'s
  pre-param-abi by-value string push, which made every native
  list-bounds panic print an EMPTY message and hid bug 1's own
  diagnostic for a full session). Root-caused and fixed same day,
  commit `3bdbb3b` — see section 0 above and the ROADMAP entry's "T2
  blocker" subsection for the full narrative. The prior session's
  leading hypothesis (Task 5's splice reorder, `e72b92a`) was disproven
  by a code-independent repro flip, not confirmed.
- **Step 4 finisher (regression test, same day):** added
  `testdata/runerr/listindex.cla`/`.err`/`.behavior` to
  `TestRunErrOn68k`, exercising `cgEmitPanic`'s inline list-bounds path
  specifically (host-side `behavior_test.go` also auto-picks it up via
  its glob, T2 not T1).
- **T2: GREEN at `3bdbb3b`, 232s** (T1 body 11s, `internal/selfhost`
  92s, gated native `internal/mactest` lane 124s, `CLARUS_BAKE_FULL`
  bake corpus 5s). **Merge-ready from a testing standpoint.**

**Deferred / phase debt (full detail in ROADMAP entry):** `rtUiTableClick`'s
row math still has no upper clamp against the live row count (deliberate
— a clamp would mask a recurrence of the same bug class); include-dedup
fallback trigger is broad (correct but slower, narrowing direction
recorded); object code + linker (stage 3.5) is next, no longer blocked;
everything param-abi already deferred remains open. Plus, from the
final-review fix wave: the stamp-proxy gap (stamp hashes the committed
`clarusc.c` snapshot, not a mid-phase dev binary's own edited sources —
bounded/accepted, longer-term fix is hashing the runtime module source
set); deliverable 5(c)'s honest narrowing (runtime-attributed
diagnostics are unreachable on the bake path — check#1 never walks
baked decls; `declFileTab`'s actual consumer is nested-include dedup via
`bkComputeManifestPaths`); and a standing rule — **re-run
`TestClarusCBakePathOnSnow` (opt-in, `CLARUS_SNOW_TESTS=1`) manually
after any change to `clarusc/bake.cla` or `clarusc/macgui.cla`**, it is
the only proof of the `ClarusC.APPL` default path and neither T1 nor T2
boots it.

## Recommended next steps (in order)

0. **RESOLVED (memory-leak-fix phase, 2026-08-12) — root-caused and fixed
   host-side.** The cross-compile slowdown investigated below was
   clarusc leaking ~42,845 Memory Manager blocks per compile (missing
   release, rc=1 — synthetic store-temp prologue births, `.clear()`
   skipping element release, and never-reset intern-pool tables); see
   `docs/superpowers/specs/2026-08-12-cross-compile-degradation-findings.md`
   (per-item `[FIXED]`/`[DEFERRED]`) and the ROADMAP's memory-leak-fix
   phase entry. Fixed on both lanes; the host-side `DoubleCompile` gate
   (`internal/mactest/leakgate_test.go`) now proves 0 growth/compile,
   byte-identity-clean. The Snow two-compile rerun below is now the
   validation step for the fix (expect compile #2 ≈ compile #1 per-phase
   timing); once confirmed, `CLARUS_MACRESIDENT_SETTLE` sizing in step 1
   can drop from its degraded-compile-2 numbers back toward compile-#1-only
   sizing. Original investigation notes (context for the fix), unchanged:
   In one `ClarusC.APPL` process, compile #2 (`catprobe.cla`, comparably
   tiny) ran ~4x slower than compile #1 across EVERY phase — whole-program
   check 35m vs 5m, Measure 2h20m vs 36m, segment-1 emit 49m vs 20m
   (emulated Mac II time; `now()` reads emulated Time, so these are true
   real-hardware durations even under fast-forward). Uniform cross-phase
   degradation pointed at heap/Memory-Manager-level trouble (fragmentation
   or compaction thrash as the 48MB partition fills across compiles) —
   i.e. something surviving `driveReset`/`resetDiags`/`astReset`, or
   allocation churn the arena resets don't return — rather than one bad
   algorithm, which is exactly what the fix confirmed. Both reruns were
   killed/failed on settle timing, NOT on a compile error: compile #1
   PASSed and BUILT every time (live bar + spinner + ticker confirmed
   working on screen by Andrew, 2026-08-12); compile #2 also proceeded
   correctly, just degraded. Evidence: the live-log phase ledger's timing
   entries (`.superpowers/sdd/2026-08-11-clarusc-live-log/progress.md`)
   and screenshots under that workspace's `evidence/`.
1. **IN PROGRESS (launched 2026-08-12 09:48 JST, detached): the Snow
   acceptance rerun.** Running at commit `0e633c2` via
   `.superpowers/sdd/2026-08-12-memory-leak-fix/snow-rerun.sh`
   (`CLARUS_MACRESIDENT_SETTLE=2h30m`, `-timeout 5h`, mouse-move nudger
   against the display idle-lock); log:
   `.superpowers/sdd/2026-08-12-memory-leak-fix/snow-rerun.log`. The
   formal assertions (byte-identity vs host oracles, alert-free trace,
   standalone TickProbe boot) fire when the settle expires ~12:18 JST —
   CHECK THAT LOG for the verdict. Interim results confirmed live by
   Andrew (10:15-10:45 JST): compile #1 itself is 3-6x faster (Measure
   36m34s -> ~10m, seg-1 emit 20m34s -> ~3.5m, seg-2 ~2.5m) — the leaks
   were self-poisoning even the first compile — and compile #2's
   per-phase times ≈ compile #1's (degradation GONE on hardware). Both
   compiles finished and ClarusC.APPL quit cleanly to Finder, no alert.
   Once the verdict is PASS, future runs can size
   `CLARUS_MACRESIDENT_SETTLE` off ~20m/compile (e.g. 45m-1h settle),
   not the old degraded numbers. Procedure notes (for future runs): boot
   Snow at 1x, engage fast-forward from the TOOLBAR after the app is up
   (`start_fastforward` at boot hangs the launch path —
   `macresident_test.go:79`); fast-forward is not a steady ratio
   (observed 4-7x). The worktree now HAS the `snow/`/`toolchain/`/
   `macplus/`/`Retro68/` symlinks (created 2026-08-12, not in git).
2. **Capture real on-Mac per-phase timings** using the instrumentation —
   partially DONE 2026-08-12: compile-#1 numbers for tickprobe (3 seg)
   are in the ledger (Measured 36m34s / seg-1 emit 20m34s of ~66m total —
   §1.7's double-codegen dominates); the degradation investigation (step
   0) supersedes the rest of this item.
3. **DONE (clarusc-live-log phase, 2026-08-11, this branch).** Landed the
   live-log-window spec (`2026-08-10-clarusc-mac-live-log-design.md`,
   including its §3b amendment) — full detail in the ROADMAP's
   `clarusc-live-log` phase entry. Frozen-scenario goldens re-verified,
   no churn.
4. **PARTIALLY DONE (param-abi phase, 2026-08-12) — see section 4 above.**
   §2.1 (`string`'s by-value `Str255` call ABI) is fixed — parameters now
   pass `KStr`/`KRec` by address, storage unchanged. Remaining
   Layer-2/Layer-3 candidates: §1.7's full double-codegen fix (needs
   relocation — this is now unblocked to plan against a frozen ABI, see
   the precompiled-artifacts design notes), or codegen's
   calls-out-for-everything pattern (findings doc §2.3).
5. **DONE (memory-leak-fix phase close-out, 2026-08-12) — see section 3
   above.** T2 (`scripts/test-merge.sh`'s `go test ./internal/selfhost`
   body) is fully green; the two pre-existing `TestClarusModules` goldens
   are fixed.
6. Merge decisions (Andrew's): `mac-resident-clarusc` still gated on a
   Snow acceptance PASS; `map-hashtable`, `datetime-instrumentation`,
   `layer1-compiler-perf`, `memory-leak-fix`, `param-abi`, and now
   `runtime-ir-bake` are all stacked on top of it, unmerged, in that
   order. `param-abi`'s full `scripts/test-merge.sh` ran GREEN at
   `5e44fd3` (2026-08-12, 225s total incl. the native emulator lane) —
   fully gated and merge-ready. **`runtime-ir-bake`'s full
   `scripts/test-merge.sh` is ALSO GREEN**, at `3bdbb3b` (232s) — fully
   gated and merge-ready from a testing standpoint. None of the six
   stacked, unmerged phases have been merged yet.
7. **Next session: precompiled-artifacts stage 3.5 (object code +
   linker)** is next in line — the param-ABI prerequisite landed in the
   param-abi phase, the runtime-ir-bake phase's T2 blocker that would
   have made starting 3.5 premature is now fixed, and the IR-bake
   serializer/loader is the reusable foundation 3.5 builds on (see the
   notes doc's own staging). No spec/plan exists yet for 3.5 — first job
   is speccing it, same as runtime-ir-bake specced item 3.
