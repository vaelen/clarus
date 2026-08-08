# 68k Peephole Pass — Design

**Date:** 2026-08-08
**Status:** Approved (brainstorm with Andrew, 2026-08-08)
**Phase:** First sub-phase of 5f (decomposed 2026-08-08: peephole → Mac-resident
clarusc → compilation cache → Retro68 retirement, each with its own spec/plan)

## Goal

Buy back native code quality lost to 5d's deliberately naive codegen. The
motivating workload is the eventual on-Mac clarusc self-compile (Mac-resident
clarusc is the next sub-phase); the primary metric is a compiler-shaped native
benchmark, and emitted code size (bytes + segment count) is a co-goal — smaller
code means fewer 32KB segments, less Segment Loader traffic, and a smaller
memory footprint inside the 8MB self-compile envelope. No fixed numeric
target: take the cheap wins, stop at diminishing returns, report the numbers
honestly.

Explicitly NOT this phase: register allocation (D2–D7 caching), `.B` branch
relaxation, cprint changes, instruction scheduling. Regalloc gets its own
phase only if post-peephole measurement says it is still needed.

## Context (what 5d already paid for)

- Instructions are a rewritable arena, not bytes: `record A68Item`
  (`clarusc/asm68k.cla:173`), `a68Items: list of A68Item`, appended in program
  order, kinds `KindInstr/KindBind/KindData/KindTrap/KindComment`. Only
  `a68Finish` dereferences label addresses; sizes come from one table
  (`a68InstrExtWords`/`a68InstrWord`/`a68WriteExtWords`).
- The 5d spec named this pass as the table's third consumer ("rewrites the
  structured stream before encoding") and chose caller-cleans calling
  convention partly so a peephole could batch stack pops.
- Naive codegen is a pure stack machine (`cg68k.cla:239-263`): `cgExpr`
  leaves every value in D0; every binary op does
  `MOVE.L D0,-(A7)` / eval right / `MOVE.L (A7)+,D1`. D1 is the second
  operand, A0/A1 address scratch, D2–D7/A2–A4 essentially unused. The
  push/pop temp traffic is the dominant redundancy (229 pushes vs 42 pops
  across cg68k's emission).
- `cg68Measure` measures function sizes by calling the real `cgEmitFunc` and
  diffing `a68SizeSoFar()`; `cg68Program` re-runs `cgEmitFunc` per segment.
  Anything that changes emission must run identically in both passes.
- The FIXED-SIZE INVARIANT (`cg68k.cla:322-347`): BSR.W / JSR d16(A5) /
  JSR d16(PC) are all exactly 4 bytes, which is what lets measure and emit
  agree. `.B` branch shrinking breaks it — hence out of scope.
- Timing baseline: task-14-report.md's 23-scenario table (native boot-to-exit;
  ~3.5s of every boot is fixed emulator overhead, so that table is a
  regression guard, not the primary meter). Build times are host-side and
  flat (~0.3s) — host compile speed is not this phase's problem.

## Architecture

One new module, `clarusc/peep68k.cla`, included from `main.cla`. Entry point
`peepFunc(startIdx: int)`, called at the tail of `cgEmitFunc` — after all of a
function's instructions are in the arena, before return. Because the measure
pass calls the real `cgEmitFunc`, the pass runs identically under measurement
and emission, so `cgFuncSize` and segment packing stay exact by construction.

The pass sweeps `a68Items[startIdx..count)` applying each pattern in a fixed
order, repeating the sweep until no pattern fires. Termination is structural:
every rewrite strictly deletes items or keeps/shrinks their encoded size,
never grows.

New infrastructure in `asm68k.cla`: `a68Relayout(fromIdx)` — re-walk the arena
from `fromIdx`, recompute each item's `len` from the existing
`a68InstrExtWords` table and its `addr` from the running PC, re-bind each
`KindBind` item's label address (the bind item carries its label), reset
`a68Pc`. Called once by `peepFunc` after the rewrite loop settles. Patterns
never read `it.addr` — layout is derived state, recomputed afterward. Since a
per-function peephole edits only the just-emitted tail, earlier functions'
layout is unaffected, and forward references are patched at `a68Finish` as
today.

Diagnostic affordance: a `--nopeep` flag on `emit68k` skips the pass entirely
(one `if`). First question for any future byte-level native bug: does it
reproduce under `--nopeep`?

The cprint/host path is untouched. `peep68k.cla` is new compiler source, so
the committed snapshot `clarusc/clarusc.c` gets one routine regeneration at
branch end (the `TestSnapshotFixedPoint` recipe).

## Safety rules (the correctness core)

A match window:

- **never spans a `KindBind`** — a label means control can enter mid-window;
- **never spans control flow or opaque effects** — `Bcc`/`BRA`/`BSR`/`JSR`/
  `JMP`/`DBRA`, `KindTrap`, and `KindData` all end the window (calls and
  traps have unknown register effects);
- **skips `KindComment` transparently** (zero-length, listing-only);
- **matches exact shapes only** — a pattern names specific
  op/size/mode/register combinations. "The right operand doesn't touch
  D1/A7" is established by whitelisting the handful of single-instruction
  load shapes naive codegen actually emits (immediate load, `d16(A6)`/
  `d16(A5)`/`d16(An)` load, `LEA`), never by general effect analysis.

Rewrites are same-size-or-smaller and never change function→segment
assignment or frame layout. Consequently the fixed-size call invariant, the
jump table (`cgAssignFinalJtSlots` contiguity), and the stack heuristic's
`frameSize` inputs are all untouched. The pass is a pure, order-stable
function of the item list — no new nondeterminism source for the determinism
suite or the future cross-vs-self-compiled fixed-point check.

CCR conservatism: rewrites that change condition-code behavior (`MOVEQ`,
`CLR`, quick forms all set CCR) are applied only where the following
whitelisted instruction overwrites CCR before any `Bcc`/`Scc` could read it.

## Pattern set (initial)

Each pattern is one small function inspecting 2–4 items through the safety
walker, ordered most-frequent first:

1. **Push/pop pair elimination.** `MOVE.L D0,-(A7)` · one whitelisted simple
   load into D0 · `MOVE.L (A7)+,D1` → `MOVE.L D0,D1` · same load. (NOT
   "retarget the load to D1": that would leave left/right swapped across
   D0/D1, breaking non-commutative consumers like `CMP.L D0,D1`. Moving
   left into D1 up front preserves the D1=left/D0=right contract for every
   consumer.) Fires on nearly every binary op and compare; 3 instructions
   → 2, and the 14+12-cycle push/pop pair becomes a 4-cycle register move.
2. **Accumulator shuffle cleanup.** `MOVE.L D1,D0` (the non-commutative-op
   restore) or `MOVE.L D0,Dn` immediately followed by a full overwrite of
   the destination before any read → delete. Also `MOVE X→D0`/`MOVE D0→X`
   round trips within a window.
3. **`ADDA`/`ADDQ` pop-batching.** Consecutive post-call stack cleanups
   merged into one `ADDA.W #n,A7` (or `ADDQ` when ≤8) — the win the
   caller-cleans convention was chosen for.
4. **Dead `CLR.L D0` elimination.** The bool/char load shape
   (`CLR.L D0` + `MOVE.B …,D0`) when followed by a whitelisted byte-width
   consumer or full overwrite.
5. **Quick-form strength reduction.** `MOVE.L #imm,Dn`, −128 ≤ imm ≤ 127 →
   `MOVEQ` (6 bytes → 2); immediate add/sub 1..8 → `ADDQ`/`SUBQ`;
   `MOVE #0` → `CLR` — all under the CCR conservatism rule. Needs one new op
   (`OpMoveq`) added to asm68k's three table functions + vasm oracle
   coverage (`OpAddq`/`OpSubq`/`OpClr` already exist).

The set is expected to grow during implementation as listings get eyeballed.
The spec fixes the safety rules and machinery, not the final pattern census;
every added pattern follows the same recipe: fixture, golden, vasm
round-trip, suites green.

## Measurement

Two meters, both established as a baseline task BEFORE any pattern lands:

- **Compile-shaped native benchmark (primary):** a new bench app composing
  clarusc's own `lex.cla` + `parse.cla` (ordinary includable modules) over an
  embedded representative source, N iterations, reporting elapsed ticks via
  the existing capture-console protocol. Built by `emit68k`, booted on the
  native lane. NOT a T2 gate (emulator timing is noisy) — a measured-report
  instrument, run at baseline and after each pattern, numbers in task
  reports.
- **Size meter (co-goal):** `emit68k` cross-build of `clarusc/main.cla` —
  total CODE bytes and segment count — plus the same for the two suite GUIs.
  Deterministic, host-side, cheap; recorded before/after each pattern.

The phase report ends with the task-14-style scenario table re-measured once,
for the record (regression guard, ~3.5s fixed boot overhead acknowledged).

## Testing and verification

- **Per-pattern golden fixtures:** each pattern gets a minimal `.cla` under
  `testdata/cg68k/` whose listing golden shows the rewrite fired. Existing
  `internal/cg68k` listing goldens churn as patterns land — regenerated
  deliberately, diffs eyeballed per pattern, never blind-blessed.
- **Encoding:** the existing vasm `-no-opt` round-trip oracle validates every
  rewritten listing byte-for-byte, including the new `OpMoveq` entry.
- **Behavior:** T1 per task with `--smoke`; native suite boots (core GUI +
  toolbox GUI, all cases), the 4 frozen scenarios' framebuffer/trace goldens
  (must stay BYTE-IDENTICAL — the screen doesn't change, only the code
  producing it), and `TestRealEventLoopTickOn68k`. T2 before merge.
- **Determinism:** existing determinism suite; additionally, `--nopeep`
  output must be byte-identical to pre-phase output — a cheap invariant
  proving the pass is truly isolated.
- **Snapshot:** one regeneration at branch end; `TestSnapshotFixedPoint`
  proves the fixed point holds with the peephole in the loop.

## Risks

- **A wrong pattern is a silent-corruption factory.** Mitigation: the safety
  walker's hard window rules, exact-shape matching, per-pattern goldens, and
  the 67-case + 4-scenario behavior net. `--nopeep` gives instant
  triangulation.
- **CCR subtleties** (`MOVEQ`/`CLR`/quick forms set flags): the CCR
  conservatism rule; pattern 5 lands last and can be dropped piecemeal if
  the whitelist gets hairy.
- **Win size unknown on the real meter.** The benchmark baseline lands first
  precisely so every pattern's contribution is measured, and the phase can
  stop early with honest numbers if returns diminish.

## Follow-ons (recorded, not scheduled here)

Remaining 5f sub-phases in order: Mac-resident clarusc (next; its brainstorm
inherits post-peephole timing), compilation cache, Retro68 retirement.
Regalloc and `.B` branch relaxation only if measurement demands them.

## Outcome (2026-08-08)

9 tasks, branch `peephole68k`. Not yet merged to main — merge is Andrew's
call (`superpowers:finishing-a-development-branch`).

### Pattern census

**Landed:**

1. **Pattern 1 — push/pop pair elimination** (Task 4): a value pushed then
   immediately popped back (across an intervening, provably A7-neutral
   window) retargets the pop's destination straight from the push's
   source, deleting both. Dominant win — 229 pushes vs. 42 pops in the
   naive stack machine's own emission was the phase's opening observation.
2. **Pattern 2a — load retarget** (Task 5): a simple D0 load immediately
   followed by a move that fully consumes it retargets the load's
   destination directly, deleting the intermediate move. **Pattern 2b**
   (a sibling dead-move arm) was drafted but proved unreachable by
   construction against the real corpus (a reviewer multiset audit showed
   every observed golden delta was attributable to 2a alone) — deleted
   rather than shipped as untested dead code, after one fix round.
3. **Pattern 4 — dead `CLR.L` elimination** (Task 7): a `CLR.L` whose
   destination is overwritten before being read is deleted. Small but
   real: 4 fire sites (2 in the fixture, 2 in the corpus —
   `nat_CoreSetLastErr`, `caseFormEdit`).
4. **Pattern 5 — `MOVEQ` + `ADDA.W` strength reduction** (Task 8): a
   `MOVE.L #imm,Dn` with `-128 <= imm <= 127` narrows to the 2-byte
   `MOVEQ`; an `ADDA.L #imm,An` with `0 <= imm <= 32767` narrows to the
   4-byte `ADDA.W`. Required one new encoder entry, `OpMoveq`, in
   `asm68k.cla` (opcode word, no extension words, listing text). This
   was the first pattern to shrink CODE segments outright (both suite
   GUIs dropped a segment), not just bytes in place. Interplay with
   patterns 1/2a (a cross-sweep "starvation" risk where a later-sweep
   `MOVEQ` stops matching 1/2a's own `OpMove`-shaped guards) was
   mitigated by teaching the shared `peepIsSimpleLoadToD0` helper to
   recognize `OpMoveq`-to-D0 as an equally valid simple load — unexercised
   by the current corpus (1/2a and 5 already collapse in the same sweep
   today) but correct and cheap insurance for a future codegen shape.

**Dropped:** **Pattern 3 — stack-cleanup batching** (Task 6), ratified by
Andrew (2026-08-08). Proved structurally unreachable under this backend's
calling convention, not merely rare: every nonzero `cgCleanupStack` call
site's very next real instruction is unconditionally a push (`AmPreDec`
A7) — because the backend keeps zero callee-saved registers, any value
that must survive a nested call (e.g. `cgArith`'s D1 stash before
evaluating the right operand) has no register-only path and must go
through the stack. `peepIsA7Neutral` correctly excludes `AmPreDec`, so no
A7-neutral window ever exists between two cleanups without crossing the
call itself. Confirmed both structurally (every `cgCleanupStack` call
site read directly: `cgPushArgs`, `cgCallFnScalar`/`cgCallFnInto`/
`cgCallRuntime`, `cgPushArgMaterialized`/`cgMaterializeCallResult`,
`cgEmitCallbackGlue`, `cgForListStmt`/`cgForMapStmt`) and empirically
(corpus-wide grep over every committed `testdata/cg68k/*.s` golden with a
strictly looser proxy pattern than the real whitelist — zero hits; two
hand-built probe fixtures, both breaking at the first hop). Full
analysis: `.superpowers/sdd/2026-08-08-peephole68k/task-6-report.md`.
Revisit only alongside a future regalloc/ABI phase that defers or batches
argument pushes across adjacent calls — it falls out nearly free there.

### Measured numbers

**Size** (deterministic, host-only, `scripts/size-68k.sh`; cumulative from
the Task 1 baseline):

| target | baseline | final | delta |
|---|---|---|---|
| coregui | 249918 bytes / 8 segments | 213054 bytes / 7 segments | −14.8%, and one fewer CODE segment |
| toolboxgui | 293652 bytes / 9 segments | 252082 bytes / 8 segments | −14.2%, and one fewer CODE segment |

(The third target, `clarusc/main.cla` self-`emit68k`, stays unmeasurable
this phase — see "Pre-existing gaps found" below.)

**Timing — the controlled peephole-vs-`--nopeep` comparison.** The
bench-meter recalibration below is exactly why this, not a delta against
an old baseline, is the headline number: the current-tree lexer-only
compiler-shaped bench (`testdata/bench/parsebench.cla`, composition
`clarusc/lib.cla`+`tok.cla`+`lex.cla`+`toolbox/events.cla`) was built
twice from the SAME tree in the SAME session — once `emit68k` (peephole
on, the default) and once `emit68k --nopeep` — and each binary run three
times foreground via `LaunchAPPL`/Mini vMac directly (not through
`internal/mactest`'s gated `TestParseBench68k`, whose own 8-minute-per-run
`RunMac` timeout budget doesn't fit six back-to-back runs in one
session):

- Peephole ON: **15818 / 15818 / 15818** ticks (three runs, ~4m26s wall
  each).
- `--nopeep`: **18080 / 18080 / 18080** ticks (three runs, ~5m04s wall
  each).
- **≈12.5% faster with the peephole pass on**, on this tree, measured the
  honest way.

Both readings are exactly reproducible within their own session (zero
run-to-run spread) — consistent with Task 7/8's own finding that the tick
meter is deterministic *per binary*.

### Bench-meter recalibration lesson (Tasks 7-9)

Task 7 first found ~15% apparent run-to-run noise (14157/16285/16285 on
what should have been one binary); Task 8 re-measured the SAME binary
three times and got 15818/15818/15818 — zero spread — showing the earlier
"noise" was actually a different binary (a different tree state), not
jitter. Task 9 adds one more data point that sharpens the lesson further:
building the `--nopeep` composition today and byte-comparing it against
what the pre-branch (committed-snapshot) compiler emits for the identical
source (`clarusc/lib.cla`+`tok.cla`+today's already-hoisted `lex.cla`)
confirms the two binaries are **byte-identical** — yet Task 2's own
original baseline for this same byte-identical code, measured in an
earlier session, was 17175-17295 ticks, not today's 18080. So even a
byte-for-byte identical binary can read a different absolute tick count
across separate measurement sessions (host load, Mini vMac wall-clock
timing drift — 68000 instruction timing itself doesn't depend on absolute
load addresses). **The upshot: cross-session tick deltas against an old
baseline are not trustworthy evidence of a codegen change, only same-
session, same-tree, flag-toggled A/B comparisons are** — exactly the
protocol this task's controlled bench above follows, and the reason the
phase's headline timing claim is peephole-vs-`--nopeep`, not
peephole-vs-Task-2.

### `--nopeep` isolation proof

Two independent byte-compares, both showing the flag is a true no-op when
set, confirming the peephole plumbing (the `cgEmitFunc` hook, `peep68k.cla`
itself, the `asm68k.cla` additions, `main.cla`'s flag parsing) never
changes emitted code when disabled:

```
# boot = pre-branch compiler (committed clarusc/clarusc.c, unregenerated
# at this point in the task — predates this whole branch)
cc -O1 -I runtime/host -o /tmp/boot clarusc/clarusc.c runtime/host/rt.c

# 1. single-file UI fixture
/tmp/boot emit68k -o /tmp/iso_boot/tickprobe.bin testdata/cg68k/tickprobe.cla
/tmp/cur  emit68k --nopeep -o /tmp/iso_nopeep/tickprobe.bin testdata/cg68k/tickprobe.cla
cmp /tmp/iso_boot/tickprobe.bin /tmp/iso_nopeep/tickprobe.bin   # => identical

# 2. the lexer-bench composition (exercises the lex.cla hoist too)
/tmp/boot emit68k -o /tmp/bench_boothoist/parsebench.bin \
    clarusc/lib.cla clarusc/tok.cla clarusc/lex.cla toolbox/events.cla \
    testdata/bench/parsebench.cla
/tmp/cur  emit68k --nopeep -o /tmp/bench_nopeep/parsebench.bin \
    clarusc/lib.cla clarusc/tok.cla clarusc/lex.cla toolbox/events.cla \
    testdata/bench/parsebench.cla
cmp /tmp/bench_boothoist/parsebench.bin /tmp/bench_nopeep/parsebench.bin  # => identical
```

(`cur` is the current-tree two-stage-bootstrapped compiler.) Both
comparisons came back byte-identical. The second is the stronger proof:
`boot` (main's cg68k, no peephole machinery at all) compiling today's
`lex.cla` (which DOES carry the Task 2 hoist) is exactly "hoist only, no
peephole" — matching `--nopeep`'s own claimed behavior — and the two
outputs match exactly.

### Scenario re-measure (gate, not a timing headline)

`CLARUS_MAC_TESTS=1 go test ./internal/mactest -run
'TestUiScenariosOn68k|TestSmokeBounceOn68k' -count=1 -v -timeout 30m`: all
4 frozen scenarios PASS, framebuffer/trace goldens BYTE-IDENTICAL to their
blessed goldens (the required gate — codegen changed, the screen did not).
Per-scenario native times, recorded for the regression-guard record only
(~3.5s fixed boot overhead + binary-layout sensitivity, per the bench-meter
lesson above — not to be read as a peephole timing claim):

| scenario | build | boot |
|---|---|---|
| smoke_bounce | — (single total 7.90s) | — |
| smoke_mandel | 0.41s | 12.27s |
| texteditor | 0.40s | 8.81s |
| bookmarks | 0.42s | 15.40s |

### Snapshot regeneration

Followed `internal/selfhost/fixedpoint_test.go`'s Go-free recipe exactly
(boot from the old snapshot → emit current source → build current →
re-emit `clarusc/clarusc.c`). `TestSnapshotFixedPoint`: **PASS** — fixed
point holds (gen1 == gen2, 4157567 bytes) with the peephole pass compiled
into the snapshot compiler itself.

### Pre-existing gaps found this phase (inputs to Mac-resident clarusc)

Neither is a peephole68k design question, and neither was fixed beyond
the one approved one-line hoist below — both are recorded as scoping
input for the Mac-resident-clarusc phase, which needs clarusc to
self-host natively:

- **`clarusc/main.cla` cannot `emit68k` at all** (Task 1): "too many
  str/rec temps needed in one statement" (`cgBigTmpSlots`), and once that
  constant is bumped, a second, deeper gap — "`cgPushArgs`: unaddressable,
  unmaterializable KStr/KRec argument". `scripts/size-68k.sh` measures
  `clarusc` last and tolerates this failure by design.
- **The same gap class blocks clarusc's own lexer** (Task 2): a
  freshly-concatenated string literal passed directly as a call argument
  (`clarusc/lex.cla:617`'s `emitDiag(..., "unexpected character '" + b +
  "'")`) trips the identical `cgPushArgs` error the moment anything calls
  `lexAll`/`lexNext` natively. Andrew approved ONE hoist (bind the
  concatenation to a local `unexpMsg` var first, comment names the gap)
  to unblock this phase's bench; `clarusc/parse.cla` has roughly 14 more
  `parseErrorf(...)` call sites with the identical shape, deliberately
  left unfixed (patching the code generator itself, not one call site at
  a time, is Mac-resident clarusc's job).

### Caller-cleans footnote

5d's design spec gave three justifications for choosing caller-cleans
(`docs/superpowers/specs/2026-07-30-native-5d-codegen68k-design.md`): no
RTD on the 68000, Pascal-convention results ping through memory, and
"caller-cleans lets peephole batch stack pops". Task 6's pattern-3
analysis (above) shows the third justification does not hold in practice
— this backend's D0-staged, push-per-argument, zero-callee-saved-register
convention means a cleanup is never followed by an A7-neutral window, so
no batching opportunity exists to buy back. The other two justifications
(no RTD; Pascal memory-passed results) are untouched by this finding and
still stand as the real reasons for the convention.

### Deferred minors (for a future phase, not blocking)

- Negative-immediate `MOVEQ` encoding (`sv & 0xFF` for `sv < 0`,
  hand-verified `0x76FF` for `MOVEQ #-1,D3`) has no executable coverage —
  Clarus never constant-folds negative literals, so no fixture can
  produce a negative `AmImm` `MOVE` to `Dn` today. Revisit when constant
  folding lands.
- No `ADDA` 32767/32768 boundary fixture.
- The `parse.cla` gap sites named above.

### Verification

- Per-pattern golden fixtures under `testdata/cg68k/`, vasm `-no-opt`
  round-trip on every rewritten listing (including the new `OpMoveq`),
  determinism suite: all green throughout.
- T1 (`--smoke` where the task touched `runtime/`/`clarusc/`) after every
  task; T2 (`scripts/test-merge.sh`, run as its three component commands
  separately, foreground) at phase end: **PASS** — T1 body ~15s,
  `internal/selfhost` ~89s, gated `internal/mactest` native lane ~130s
  (4 frozen scenarios + `TestRealEventLoopTickOn68k` + core/toolbox suite
  GUI boots + native codegen tests + runerr/abort + resource parity, 0
  FAIL).

Full task-by-task detail:
`.superpowers/sdd/2026-08-08-peephole68k/task-{1..9}-report.md` (ledger:
same directory's `progress.md`); plan:
`docs/superpowers/plans/2026-08-08-peephole68k.md`.
