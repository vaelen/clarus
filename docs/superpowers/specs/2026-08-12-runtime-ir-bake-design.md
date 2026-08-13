# Runtime IR bake — precompiled-artifacts item 3, at IR depth (2026-08-12)

Status: **DONE (2026-08-13, branch `runtime-ir-bake`, commits
`322765a..3bdbb3b`), full T2 GREEN (232s)** — see the ROADMAP
`runtime-ir-bake` entry and
`.superpowers/sdd/2026-08-12-runtime-ir-bake/progress.md` for the task
ledger, and the entry's own "T2 blocker" subsection for two
pre-existing, latent bugs (unrelated to this design) that Task 7's
first full native-emulator T2 run discovered and a same-day follow-up
root-caused and fixed. Annotations below (Task N/7, 2026-08-13) mark
claims the implementation narrowed; the design otherwise landed as
approved.
Originally: design approved in discussion (Andrew, 2026-08-12 evening),
pre-plan. Implements the first stage of the precompiled-artifacts
program (`2026-08-12-precompiled-artifacts-design-notes.md`), deepened
from that doc's "pre-parsed bake" v1 to a **post-lower IR bake** by the
brainstorm decisions recorded here. Prerequisite phase: param-abi
(immutable params + by-address string/record ABI) — DONE, branch
`param-abi`, fully gated. This phase builds on it and freezes against
its ABI.

## Decisions made in brainstorm (Andrew, 2026-08-12)

1. **Bake depth: post-lower IR** (not post-parse, not post-check). The
   artifact captures the runtime chain's state AFTER `lowerProgram` —
   per compile, the runtime's expand/lex/parse, check, and lower all
   vanish; user code alone runs the front half of the pipeline.
2. **Variant strategy: one superset bake + shake.** A single image
   contains the full runtime (core/str/text/list/map + ui* + ser +
   native + uitest) lowered together. Tree-shaking — which already runs
   before codegen — drops what a given program doesn't reach, exactly
   as it does today for spliced-but-unused code. The manifest
   conditionals (`usesFileSaveLoad` gating ser.cla, UI-program gating
   ui*.cla) are retired on the bake path.
   **Consequence (post-brainstorm research, 2026-08-12): the
   FROM-SOURCE path moves to the superset splice too.** Today's
   from-source compiles splice subsets, so their IR indices — and
   therefore jump-table slots and A5 offsets — would never match a
   superset bake's, making the byte-identity oracle impossible. Making
   the from-source splice unconditionally superset (plan Task 2, its
   own golden re-bless) restores identity by construction and retires
   the manifest conditionals everywhere, not just on the bake path.
   `uitest.cla` remains the one `--testapi`-gated module on both
   paths. The A5/fork-size cost of superset on small programs is
   measured by plan Task 1 before Task 2 commits to it, with
   shake-aware global emission as the recorded mitigation if needed.
   **[Task 4/7 annotation, 2026-08-13]** "`--testapi`-gated" means
   checker-*visibility*-gated, not bake-*inclusion*-gated: the CLIR
   artifact always carries `uitest.cla`'s lowered IR unconditionally
   (Task 4 found this carried-but-gated shape); the gate is enforced at
   symbol-preload time on the from-source `--testapi` check, not by
   excluding the module from the bake itself.
3. **Lane roles:** ClarusC.APPL consumes the baked resource **by
   default** (that is the point of the phase); the host CLI gains an
   **opt-in flag** (`--rtbake FILE`) with from-source remaining the
   host default, so the byte-identity oracle always has both paths to
   compare.

## Why (honest payoff, current numbers)

Post-leak-fix Mac numbers for a small 3-segment compile: Measure ~10m,
seg-1 emit ~3.5m, seg-2 ~2.5m; check and lower were 5m11s and 2m23s
pre-leak-fix (so plausibly ~1.5–3m combined now); phase A smaller
still. Therefore:

- This phase removes the runtime's share of phase A + check + lower —
  order of **2–4 minutes of today's ~20-minute Mac compile**, plus the
  same work from every host `emit`/`emit68k` (gate-turnaround win).
- It does NOT touch Measure/emit (~16m), which is §1.7 double-codegen —
  that is item 4/5 (relocation/linker) territory, NOT this phase.
- The strategic value is the **foundation**: the serializer, version
  stamp, loader, and base-0 index discipline this phase builds are
  exactly the machinery the 3.5 unit/linker artifact needs, and the
  pipeline gets structurally simpler (check#2 retired — see below).

## The artifact

New resource kind `'CLIR'` (working name), regenerated at `--bake` time
on the host, alongside the existing `'CLFS'` source resources in
ClarusC.APPL; on the host lane the same bytes live in an ordinary file
passed via `--rtbake`.

- **Header:** format-version int; content stamp = hash of the
  generating compiler (the `clarusc.c` snapshot identity) — loader
  refuses a mismatched stamp, so a stale bake cannot run; the runtime
  **module-key manifest** (for include-dedup, below).
- **Body, flat sections:**
  - every IR arena `irReset` clears (fixed-shape int-field records →
    big-endian int streams; exact list frozen by the plan's inventory
    task);
  - the intern pool (`strPool`, length-prefixed) — user parsing interns
    on top of it at load;
  - the IR string-literal pool and `lowStrIdx` end state;
  - end-values of lowering's program-wide counters (`lowSwitchN` and
    siblings) so user lowering continues numbering where the bake
    stopped;
  - the checker symbol tables for the runtime (used ONLY on the
    `--testapi` path, where user code may legally name `UiTest*`
    runtime functions);
    **[Task 5/7 annotation, 2026-08-13]** narrower than stated: it's not
    just `UiTest*`. From-source `--testapi` check#1 sees every symbol
    from all 13 early-spliced modules (three `cases_*.cla` toolbox-suite
    files name raw runtime internals directly, not just `UiTest*`
    wrappers), so the bake path's preload widened to match (format v3,
    `bkSecCheckerVisibility`) — manifest-spliced modules
    (ser/sortedmap/datetime/native) stay invisible either way. See
    `.superpowers/sdd/2026-08-12-runtime-ir-bake/task-5-report.md`
    (fix round 2).
  - `curPathIdx` path stamps for baked decls, so runtime-attributed
    diagnostics/panics still name the right source file.
- **Not baked:** memoized `I*()` intrinsic caches and lazy-init guards
  (cheap to re-derive; the leak-fix phase's reset-discipline gate
  `TestLazyInternGuardsAreReset` governs them), and the runtime's AST
  (nothing after lower needs it — verified, not assumed: plan task).

## Pipeline restructure

Today: expand/lex/parse user → check#1 (user standalone) → splice +
re-read/re-lex/re-parse runtime → check#2 (whole program) → lower
(whole program) → shake → cg68Measure → pack → emit → fork.

Bake path: **load `'CLIR'` at arena base 0** (stamp-checked) →
expand/lex/parse user → check#1 (unchanged; `--testapi` additionally
preloads the baked runtime symbols into scope) → **lower user code
only**, appending IR at base N, resolving runtime callees by
interned-name lookup against baked IR → shake → codegen → fork, all
untouched.

**check#2 is retired on the bake path.** Rationale: the standalone rule
(ordinary user code cannot name runtime symbols; clarusc enforces user
code checks standalone before any runtime module is consulted) means
whole-program check adds nothing over check#1 for ordinary programs;
`--testapi` is the one exception and is handled by symbol preload.
**This is the phase's load-bearing assumption and the plan's first task
verifies it differentially across the corpus rather than assuming it**
— any program where check#2 emits a diagnostic check#1 didn't, or
where check#2 mutates state lower depends on, narrows the claim and
the design adapts (worst case: a user-only check#2 pass over the user
chain with baked symbols visible).

> **[Task 1/7 annotation, 2026-08-13]** Probed literally, this claim
> FAILS 100% of the corpus: check#2 is currently the *only* pass that
> type-checks the runtime chain's own internal calls (not just
> user→runtime references), so skipping it outright would silently stop
> checking the runtime against itself. The design's actual dependency
> survives narrowed: check#2 adds nothing *new for user code
> specifically* over check#1. Task 3's bake-time one-shot runtime check
> (run once, at `--bake-ir` generation time, not per compile) plus
> `--testapi` symbol preload are what uphold the narrowed claim; Tasks
> 4-5's full-corpus byte-identity oracle is the proof (not a standalone
> re-verification of the original, broader claim). See
> `.superpowers/sdd/2026-08-12-runtime-ir-bake/task-1-report.md`
> (Step 2) and the ROADMAP `runtime-ir-bake` entry.

## The oracle

Byte-identity, the house style: for every corpus program (cg68k
goldens, emitui fixtures, both suites, self-compile), `emit68k
--rtbake` and plain from-source `emit68k` must produce **byte-identical
forks** (and `emit --rtbake` identical C). A new T1 gate runs a
representative slice on every task; the full corpus runs at phase
close. Bake determinism gets its own check (bake twice → identical
bytes). ClarusC.APPL's baked-vs-CLFS-source equivalence is covered by
the same oracle running under the emulator lane at close-out.

## Interactions handled explicitly

- **Include-dedup hoisting:** a user `include` of a runtime file dedups
  against the bake header's module-key manifest instead of a live
  parse; the hoisting path (a user file pulled into the runtime chain)
  forces a **from-source fallback for that compile** (correctness over
  speed; rare case; counted in the report).
- **Reset discipline:** the baked image is immutable on disk; each
  compile re-installs it (fresh load or reuse of a pristine in-memory
  copy — implementer's choice, but per-compile state cleanliness must
  match today's `driveReset`/`irReset` guarantees; the leak gate's
  DoubleCompile oracle extends to the bake path).
- **Memory:** superset IR resident during compile is a few MB —
  acceptable in the 48MB partition; the 8MB-machine path remains a
  Layer-3 item (notes doc), unchanged by this phase.
- **KArr / ABI:** the bake freezes against the param-abi ABI; the
  stamp ties artifacts to the exact compiler build, so future ABI
  changes invalidate cleanly (regenerate at --bake).

## Out of scope

- Measure/emit reuse, relocation, per-module composition, linking —
  item 3.5 (the notes doc's staging).
- On-disk caching of USER modules — item 3.6 (falls out later; the
  bake is its degenerate pinned-key case).
- The 8MB memory path; shake-early for check (moot here — check#2 is
  retired outright on the bake path).
- Post-parse/post-check bake variants — superseded by the IR depth
  decision.

## Success criteria

1. Byte-identity oracle green across the corpus, both host modes and
   the emulator lane.
2. Bake determinism + stamp-refusal tests green; leak gate green on
   the bake path (0 growth/compile).
3. ClarusC.APPL compiles via `'CLIR'` by default on the emulator
   (suite boots green); measured per-phase Mac timings show the
   runtime's phase-A/check/lower share gone.
4. Host `emit68k --rtbake` measurably faster than from-source on the
   macgui macro benchmark (expectation: check+lower share of ~0.46s
   removed; exact number recorded, no target pinned).
5. The serializer/loader lands as reusable machinery with the 3.5
   follow-on explicitly in mind (documented interface).
