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
that, merge decisions cover five stacked phases (`mac-resident-clarusc`,
`map-hashtable`, `datetime-instrumentation`, `layer1-compiler-perf`,
`memory-leak-fix`).

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
4. Pick a Layer-2/Layer-3 target once on-Mac numbers exist: candidates are
   `string`'s 256-byte `Str255` representation, §1.7's full double-codegen
   fix (needs relocation), or codegen's calls-out-for-everything pattern
   (findings doc §2.3).
5. **DONE (memory-leak-fix phase close-out, 2026-08-12) — see section 3
   above.** T2 (`scripts/test-merge.sh`'s `go test ./internal/selfhost`
   body) is fully green; the two pre-existing `TestClarusModules` goldens
   are fixed.
6. Merge decisions (Andrew's): `mac-resident-clarusc` still gated on a
   Snow acceptance PASS; `map-hashtable`, `datetime-instrumentation`,
   `layer1-compiler-perf`, and `memory-leak-fix` are all review-approved
   and stacked on top of it, unmerged.
