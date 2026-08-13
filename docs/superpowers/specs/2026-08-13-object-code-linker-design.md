# Object Code + Link Pass (precompiled-artifacts stage 3.5) — Design

Date: 2026-08-13. Status: approved by Andrew (brainstorm session, this
date). Successor to the fallback-trigger-narrowing phase (merged to main
at `e143af1`); implements the precompiled-artifacts notes' item 5
(`2026-08-12-precompiled-artifacts-design-notes.md`) at the "Approach A"
scope agreed in brainstorming: **grow the CLIR artifact; the "linker" is
the existing late-patch machinery, generalized** — not a standalone
object-file format or a separate pipeline stage (that generality is
deferred to stage 4, which actually needs it).

## Problem

On the 68k lane, every compile code-generates every reachable runtime
function twice: `cg68Measure` performs complete code generation (full
instruction selection + peephole) per function to learn sizes for
segment bin-packing, throws the bytes away, then the per-segment emit
loop generates everything again for real (findings doc §1.7, cg68k.cla).
Codegen is ~67% of the profile; the runtime is the large, never-changing
majority of the reachable set. The IR bake (runtime-ir-bake phase)
removed the runtime's parse/check/lower cost but codegen — the dominant
phase — is untouched: Measure alone was ~36m of TickProbe's pre-leak-fix
~66m Mac compile (~10m post-fix), roughly half of which is runtime
functions being measured and then re-emitted.

Goal: runtime codegen cost ~zero on the bake path. Runtime function
BYTES ship in the artifact; per compile, only user functions run
codegen, and Measure measures user functions only.

## Correctness oracle (decided first, constrains everything)

**Byte-identity, same as every phase**: `--rtbake` output with object
sections ≡ from-source output, byte-for-byte, full corpus, both suite
compositions, both consumers (host `emit68k --rtbake` and
`ClarusC.APPL`'s default path). Divergence = STOP-and-investigate, never
re-bless. Consequence accepted in brainstorming: the link pass
reproduces today's deterministic layout exactly (packing order, pool
ordering, JT slot assignment); link-time layout improvements (better
packing, pool dedup) are a later, separately-gated phase. A further
consequence: the precompiled-artifacts notes' v1 simplification ("route
all calls through the JT, PC-relative reloc later") is off the table —
today's output uses intra-segment PC-relative calls, so the reloc-kind
set includes PC-relative displacements from day one.

## Mechanism

### Artifact: CLIR v5 → v6, 68k lane only

New sections (IDs from 48, `bkSectionCount` bumped per the existing
one-section-per-version precedent; lane-c artifacts carry none of this
and are structurally unchanged apart from the version bump). Per
reachable runtime function, the artifact carries what `cg68Measure`
produces today (scout-verified inventory, cg68k.cla:1022-1148):

- **bytes** — the function's emitted code, post-peephole;
- **size** (`cgFuncSize`) and **frame size** (`cgFuncFrameSizes`);
- **pool-reference sets** — `cgFuncStrLits`/`cgFuncEnumTables`/
  `cgFuncSerdescs` index lists plus the `cgFuncUsesUiBlob`/
  `cgFuncUsesUiEvents` flags (consumed by `cgPackProgram`'s per-segment
  pool need-sets — sizes alone are not enough to skip Measure);
- **reloc table** — `{offset-in-bytes, kind, symbol}` entries.

**Reloc kinds — three, not four.** The scout confirmed runtime globals'
A5 offsets are position-stable: `bkInstallArenas` loads `irGlobals` as a
verbatim prefix (bake.cla:3055) and user globals only ever append
(ir.cla:2114-2123), while `cgAssignGlobalOffsets` (cg68k.cla:2173-2204)
is a declaration-order prefix-sum — so offsets for indices `[0, N)` are
identical in the bake-time (runtime-only) and compile-time
(runtime+user) universes, and **A5 displacements bake into the bytes
with no relocation entry**. The remaining kinds:

1. **JT-slot displacement** — cross-segment `JSR d16(A5)` call sites;
   the displacement is `cgJtDisp(slot)` (cg68k.cla:2142-2144) and slots
   shift when user functions pack into segments.
2. **PC-relative pool reference** — `LEA d16(PC)` via `AmPCLabel`
   against a pool label (`cgPoolStrRef`-family, cg68k.cla:11301-11306);
   position depends on the segment's final layout.
3. **PC-relative same-segment call** — calls to other functions in the
   same segment; position-dependent the same way. Intra-function
   branches are self-contained (the function's internal layout is
   fixed) and are NOT relocs.

> **[Task 1 annotation, 2026-08-13 — Amendment A1, blocking]** Kinds 1
> and 3 above (JT-slot displacement vs PC-relative same-segment call)
> are wrong as a BAKE-TIME distinction — the probe's cross-universe diff
> found 1481 flips of the same runtime call site between the two shapes
> across 15 program pairs. `cgCallFunc` (cg68k.cla:2161-2167) picks
> `BSR.W <label>` vs `JSR d16(A5)` from `cgFuncSegment[fi] ==
> cgCurFuncSegment` — a COMPILE-TIME property (which segment each
> function packs into), not something the bake can know. Both shapes are
> 4 bytes, but the OPCODE WORD differs, not merely the displacement —
> so a bake that recorded "JT-slot displacement, patch the extension
> word" would emit a stray `JSR` where a from-source compile emits
> `BSR`, on the very first mixed-segment program. Implemented instead as
> ONE call reloc, `{offset, targetFuncIdx}`, 4 bytes wide: the link pass
> re-emits via `cgCallFunc(targetFuncIdx)` verbatim and lets it choose
> the opcode from THIS compile's own live segment assignment. Kind 3
> survives only as the non-call PC-relative kind (glue labels, RC-walk
> labels) whose shape doesn't vary. Full taxonomy and the amendment's
> own reasoning: `.superpowers/sdd/2026-08-13-object-code-linker/
> task-1-report.md`, "Amendment A1."

Nothing else in a function's bytes depends on placement
(scout-verified: no per-function alignment padding — the only
`a68Align` calls are pool-table emission, cg68k.cla:11385/11448/11467;
no self-segment constants; `cgCurFuncSegment` steers the same/cross
branch in `cgCallFunc` but is never emitted as data).

Also serialized once, not per function: the Measure-time fixed-cost
buckets (`cgSeg1ExtraSize`/`cgGlueBundleSize`/`cgPoolSize`) and
per-pool-entry sizes (`cgStrLitSize`-family, cg68k.cla:1135-1148), so
compile-time Measure needs no runtime-side emission at all.

> **[Task 3 annotation, 2026-08-13 — the fixed-bucket PLAN DEFECT]**
> "So compile-time Measure needs no runtime-side emission at all" is
> WRONG for this one paragraph's own scalars, and Task 3 deliberately
> did not implement the substitution this sentence implies.
> `cgEmitInitGlobalsStub`/`cgEmitFreeGlobalsStub`/`cgEmitRcWalks`/
> `cgEmitPoolsBody` (the routines that produce `cgSeg1ExtraSize`/
> `cgGlueBundleSize`/`cgPoolSize` and the per-pool-entry size tables)
> all measure the CURRENT PROGRAM's full `irGlobals`/`irRecords`/pool
> state — the runtime-baked prefix PLUS whatever this program's own
> user globals/records/literals append — while the artifact only ever
> captured a bare runtime-only baseline with zero user code
> (`cgObjCaptureRuntime`'s own doc comment). Substituting the baked
> scalar would silently UNDER-measure `cgPackProgram`'s own per-segment
> budget for any program with even one user `var`/`record`/literal —
> i.e. nearly every real program — risking a segment-packing decision
> that diverges from what a from-source compile would choose: byte-
> identity breaks on segment LAYOUT, not on any one function's own
> bytes, exactly the failure shape that shows up on some fixtures and
> not others. These eight scalars stay real-measured every compile,
> unconditionally, regardless of baking; only the ~500 per-function
> `cgEmitFunc` calls are skipped, which is where the actual payoff
> lives anyway (these routines are cheap — proportional to
> `irGlobals.count`/`irRecords.count`/pool bytes, never to the runtime's
> own function count). Review confirmed this explicitly: "fixed-bucket
> deviation confirmed a PLAN DEFECT, implementer right." Full reasoning:
> `.superpowers/sdd/2026-08-13-object-code-linker/task-3-report.md`,
> "Deviation from the brief," and cg68k.cla's own
> `cgObjPasteEligible` section header (~cg68k.cla:13040-13063).

### Bake-time generation (`--bake-ir --lane 68k`)

`--bake-ir` today never touches cg68k.cla (scout-verified: zero
references). It grows a codegen step: after the existing check+lower,
run the existing `cgEmitFunc` per runtime function in the runtime-only
universe, capturing bytes with a reloc site recorded wherever the
emitter uses a JT displacement or a label operand of the two
PC-relative kinds. Feasibility rests on two properties the current
compiler already proves about itself: peephole determinism between the
Measure and real passes (peep68k.cla:9-11), and Measure/emit size
identity (displacement widths do not vary with final layout — if they
did, today's Measure sizes would already be wrong).

> **[Task 2 annotation, 2026-08-13 — two unplanned mechanisms]** "Run
> the existing `cgEmitFunc` per runtime function in the runtime-only
> universe" undersold what capturing EVERY runtime function
> unconditionally reachable (vs. Task 1's probe, which only ever
> exercised organically-reachable functions in six real programs)
> actually requires. Two previously-latent gaps surfaced immediately:
> (1) **callback-glue trampolines** (`cg68SynthCbGlue`'s
> `clar_cb_<name>` functions) don't exist until codegen synthesizes
> them, yet the capture's own unconditional `cgEmitStartup` call reaches
> a reference to one before any exist — fixed by calling
> `cg68SynthCbGlue()` inside the capture and adding a fourth hole kind,
> `cgHoleCbGlueAddr`, resolved by `irCbGlueNames` position (its
> `irFuncs` index isn't bake-stable, the same instability class as
> Amendment A2's panic literal); (2) **reverse-waist UI dispatchers**
> (`clar_ui_fire_winevent` and seven siblings) are deliberately never
> part of the baked IR at all, so a reference to one is structurally
> unresolvable at bake time — an exclude-before-rooting approach was
> tried and rejected (`shakeProgram`'s transitive BFS defeats it), fixed
> instead with a taint-and-discard mechanism: the referencing function's
> capture is marked incomplete and simply isn't baked, falling back to
> ordinary `cgEmitFunc` at real compile time (a missed optimization for
> those specific functions, not a correctness gap). Neither mechanism
> is in this design's own reloc-kind or capture-representation
> sections. Full writeup:
> `.superpowers/sdd/2026-08-13-object-code-linker/task-2-report.md`,
> "Two correctness gaps beyond Task 1's own probe."

### Compile-time consumption

- **Boundary:** the runtime/user boundary (`irFuncs.count` immediately
  after `bkInstallArenas`) is retained in a named global — today it is
  reconstructable but unnamed (scout Q7); `bkLdBaseIrFuncsCount`
  remains the separate base-vs-testapi boundary within the baked set.
- **Measure:** `cg68Measure` skips `cgEmitFunc` for baked functions,
  filling `cgFuncSize`/`cgFuncFrameSizes`/pool-ref lists from the
  artifact. This is where the Measure payoff lands: user functions
  only. `cgAssignGlobalOffsets` runs unchanged (its output for the
  runtime prefix provably matches the baked bytes).
- **Packing / JT:** `cgPackProgram` and `cgAssignFinalJtSlots` run
  unchanged, consuming artifact-sourced sizes and pool sets.
- **Emit ("the link pass"):** in the per-segment loop
  (cg68ProgramFork, cg68k.cla:12421-12548), a baked function is
  **pasted, not re-generated**: its artifact bytes stream into a68 as
  raw data, with each reloc site re-registered as an a68 label fixup
  (pool labels, same-segment function labels) or computed JT
  displacement — then `a68Finish`'s existing two-pass back-patching
  resolves them exactly as it does for freshly emitted code
  (cg68k.cla:11314-11319 documents the unbound-label contract). User
  functions in the same segment emit through `cgEmitFunc` as today;
  the scout confirmed nothing couples one function's byte content to a
  sibling's beyond the named holes (Q2). The JT-table fill
  (`jtEntries`/`jtSegNums` after each segment's `a68Finish`,
  cg68k.cla:12503-12514) is untouched.

### testapi

The baked object set covers the testapi extras; the non-testapi
truncation to `bkLdBaseIrFuncsCount` applies to the object sections
symmetrically with the IR truncation `bkInstallArenas` already performs
(bake.cla:3020-3035). A non-testapi build never sees testapi objects.

### Unchanged, deliberately

- **Shake stays on baked IR** (decided in brainstorming): the IR body
  remains in the artifact; shake.cla's BFS runs over live IR as today
  and its verdict is the link-time inclusion set. Smart-link (shake
  over artifact metadata, IR-body removal from the 68k lane) is a later
  phase.
- **Lane c** consumes the IR body exactly as today.
- **Everything the fallback-trigger-narrowing phase built** — per-module
  drift hashes, check-only include, testapi dedup — is untouched; a
  collision-triggered from-source fallback simply doesn't use the
  object sections (it doesn't use the bake at all).
- **Fallback:** any artifact refusal (format/version/lane/stamp/body
  hash) falls back to from-source exactly as today; object sections
  ride the same acceptance decision, no separate gate. The body-
  integrity hash (v4) covers the new sections for free by construction
  (it hashes the whole body).

## Oracles and tests

- Full-corpus byte-identity, both lanes, both suite compositions, under
  the existing `CLARUS_BAKE_FULL` frame — now proving paste-with-fixups
  ≡ regeneration.
- Existing `internal/bake` header/sanity fixtures update v5→v6; loader
  refuses non-6 via the existing message path; artifacts are never
  committed, no compat shim.
- Leak gate (DoubleCompile) — pasted-bytes path must not leak.
- T1 `--smoke` per task; full T2 at tip.
- Snow standing rule applies (bake.cla changes ⇒ manual
  `TestClarusCBakePathOnSnow` before merge), and the Snow run doubles
  as the headline measurement: **on-Mac Measure + emit wall-clock**,
  compared against the phase-entry numbers (Measure ~10m post-leak-fix
  for TickProbe compile #1).

## Load-bearing assumptions → probe task

Three assumptions get a probe (Task 1, commits nothing) before
implementation, in the runtime-ir-bake Task-1 pattern:

1. **Hole-completeness:** bake-time bytes ≡ compile-time bytes outside
   the three named reloc kinds, for the full runtime function set (the
   A5-stability argument and the Q6 "nothing else" claim, verified
   empirically by diffing per-function Measure emissions between the
   two universes).
2. **Paste mechanics:** streaming raw bytes + re-registered fixups
   through a68 reproduces `a68Finish` output byte-identically on a real
   segment mixing pasted and generated functions.
3. **testapi truncation symmetry** for the object sections.

A probe failure amends the plan before code lands (the runtime-ir-bake
probe caught the dispatcher-synthesis gate this way).

## Out of scope

- Smart linking / IR-body removal from the 68k lane; link-time layout
  improvements (both gated behind a future oracle-relaxation decision).
- Stage 4 user-module artifact cache (standalone object files, keying).
- The pre-existing call-lowering debt class recorded in the
  fallback-trigger-narrowing ledger (address pushed across a
  later-evaluated allocating argument) — adjacent to files this phase
  touches, but a separate correctness question; revisit when cg68k's
  call lowering is next open.
- Stamp-proxy-global gap: unchanged, still open (recorded debt).

## Shape

~4 tasks: (1) probe wave verifying the three assumptions; (2) artifact
+ serializer + bake-time codegen (v6); (3) compile-time consumption
(Measure skip + paste-with-fixups) against the full-corpus gate;
(4) oracles, housekeeping, snapshot regen, docs, full T2 + Snow with
Measure timings.
