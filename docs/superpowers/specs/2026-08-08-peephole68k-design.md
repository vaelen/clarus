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
