# Native 5d — codegen68k design

Date: 2026-07-30. Child spec of
`2026-07-29-native-68k-toolchain-design.md` (Plan 5); this document refines
the "codegen68k" section into a buildable design. Where the parent spec
already decided something (whole-program codegen, no object files, no
linker, segmentation model, app writer via traps), this spec inherits it
without re-arguing.

## Resequencing decided 2026-07-30

- **5c′ — runtime migration wave 2a (mem/ARC in Clarus) — is a hard
  prerequisite of 5d and becomes its own phase** (own spec/plan/branch, the
  5b playbook). Reason: the native backend links only code it generated
  (parent decision #1), but 5b deliberately left birth allocation,
  refcounting, and lastref/free C-owned. A codegen68k-built app cannot link
  that C, so every reachable line of the non-UI runtime must be Clarus
  before 5d's end-gate can run. 5c′ is ported and verified entirely on the
  existing cprint → Retro68 path (full differential + mactest green), so
  the new backend's first consumer is an already-proven runtime — codegen
  bugs never alias with port bugs.
- **The IR tree-shake pass moves from 5c into 5d** (it directly serves
  segment packing; also shrinks emitted C).
- **The compilation cache (rest of old 5c) slides to after 5d.** It is an
  on-Mac usability feature; nothing needs it before 5f.
- **5c′ landed 2026-07-30, branch `native-5c`:** rc arithmetic (retain/
  release), `lastref`, and birth allocation (`rtTextNew`/`rtListNew`/
  `rtMapNew` building the box + Handle(s) + `rc = 1` entirely in Clarus)
  are now Clarus-owned for Text/List/Map, ported and verified entirely
  over the existing cprint → Retro68 path exactly as scoped above (full
  differential + mactest green, zero `.leaks`/CLRD golden churn). Full
  outcome record: `docs/ROADMAP.md`'s 5c′ entry;
  `.superpowers/sdd/2026-07-30-native-5c-runtime-wave2a/task-{1..6}-report.md`.
  **5d-input inventory** — runtime logic this design's codegen must still
  reach through C, or otherwise account for, since it did not move in 5c′:
  - The four C ADDRESSING sites (`fpIndexRef`'s own `rt_list_at` user-level
    indexing, `fpForListStmt`'s per-iteration element deref, `IListSet`'s
    ref, `IListRemove`'s old-value read) — doc comment at `fpIndexRef`.
  - `fpUiEditStmt`'s arms: `rt_list_at` (kind==2), `rt_map_get_dv`
    (kind==3).
  - `lasterr` reads (`rt_str_store` over a C global).
  - `rt_arr_check`.
  - `rt_enum_from_int`.
  - File I/O emissions.
  - `rt_register_cleanup`.
  - Runtime logic not yet inventoried for native: `rt_print`/console,
    `rt_panic`, `rt_args`.

## Decision: direct binary emission, no assembler

Three options considered:

1. **Asm text → external assembler (Retro68 gas + Elf2Mac):** rejected.
   Re-introduces the dependency 5f exists to retire, and gas's
   ELF-and-linker path doesn't speak CODE-resource + jump-table without
   Retro68's bespoke glue.
2. **Asm text → our own assembler (eventually in Clarus):** rejected. A
   second compiler (lexer, parser, symbol table, two-pass layout) whose
   only customer is our own codegen, plus a text round-trip that an
   8MHz/8MB self-host pays for on every build. The classic argument for an
   assembler — separately assembled modules and a linker — is already
   ruled out by whole-program/no-object-files.
3. **Direct binary emission through an instruction-table layer: CHOSEN.**
   Codegen builds instructions as structured values; an encoder emits
   words; a text *printer* (listing mode) provides the human-readable
   output an assembler would have — without ever writing a parser for it.

## The instruction layer

One instruction table — mnemonic, operand shapes, encoding recipe — drives
three consumers:

- **Encoder:** instruction stream → 68000 words, with backpatching for
  forward references (whole program is in memory; trivial).
- **Listing printer:** the same stream → readable asm text, for debugging
  and committed test goldens (`--listing`-style flag on the build path).
  **Syntax: Motorola, as in Inside Macintosh / MPW Asm** (`MOVE.L
  (A7)+,D0`, `LINK A6,#-8`, `_NewHandle` for known trap words) — it
  matches the reference books and MacsBug's on-screen disassembly, and we
  only print it, never parse it, so gas/MIT compatibility buys nothing.
  Goldens are our own listing output. A second payoff (Testing ring 2):
  Motorola syntax is exactly what the in-repo vasm assembles, enabling a
  listing → vasm → bytes round-trip oracle.
- **Peephole/regalloc (later phase):** rewrites the structured stream
  before encoding. The parent spec says this pass is "likely needed soon
  after" — the table exists now so that pass has material to work on.

Nothing writes raw code words directly; codegen's only output vocabulary
is table entries. ISA scope is the 68000 subset naive codegen actually
emits (MOVE/LEA/PEA, ADD/SUB/CMP/NEG, AND/OR/EOR/NOT, shifts, MULS/DIVS,
Bcc/BSR/JSR/JMP, LINK/UNLK, TST/EXT, A-line words) — the table grows on
demand, it is not a full ISA catalog.

## Calling convention: C-style, not Pascal

Considered matching the Toolbox's Pascal convention for uniformity.
Rejected, for one hardware reason and two code-quality ones:

- **The 68000 has no RTD** (68010+). Pascal is callee-cleans, so every
  function epilogue becomes the manual dance: pop return address to a
  scratch register, `ADDA` args off SP, store the result into the caller's
  reserved slot, `JMP (A0)`. Per-function boilerplate on every Plus/SE.
- **Pascal results ping through memory** (caller reserves a stack slot,
  callee stores, caller pops). C-style leaves the result in D0. With ARC,
  retain/release and str/list helpers are called constantly; a memory
  round-trip per result is pure waste at 8MHz.
- **Caller-cleans batches; callee-cleans can't.** The classic peephole win
  merges stack pops across consecutive calls (one `ADDA` for three calls).
  That only exists if the caller owns cleanup.

Uniformity buys nothing: Toolbox traps are inlined A-line words, not
Pascal JSRs — the arg sequence at a trap site is dictated by the trap
declaration regardless of our internal convention — and Toolbox-calls-us
stays fenced to the committed JMP-stub trick, where the stub translates.

**The convention:** caller pushes args left-to-right (no varargs, so the
choice is free; left-to-right matches the push order already used at
Pascal trap sites, one order to think in everywhere), caller cleans,
32-bit result in D0, LINK/UNLK A6 frames, callee saves the registers it
clobbers. Pascal/register semantics exist only at trap sites, driven by
the `external func` trap clause. One seam, in the one place the Toolbox
forces it.

## Codegen strategy (naive v1)

- Stack-oriented: IR temps on the stack, D0/A0 scratch, no register
  allocation. Correctness over quality, measured against the ROADMAP 68k
  timing baseline.
- **Trap clauses land here** (deferred from 5a): `external func ... = trap
  0xA122 reg`-style declarations. codegen68k inlines the A-line word
  (stack-convention push/trap/pop for Pascal traps; D0/A0 moves for
  register OS traps); cprint continues to ignore the clause and call the
  `rt_ext_` shim.
- Branches: emit `.W` displacements with backpatch everywhere; shrinking
  to `.B` is peephole's job later.
- **Determinism is a hard requirement** (the 5f fixed-point test
  byte-compares a cross-built and a Mac-self-compiled clarusc.APPL):
  stable iteration order everywhere, no address-dependent choices.

## Tree-shake (moved into 5d)

IR-level reachability walk from the entry point plus event handlers,
run before either backend (per the parent architecture diagram).
Unreferenced functions get no code — this is also the optional-subsystem
answer (no config; unused = absent) and shrinks emitted C on the host
path as a side effect.

## Segmentation and app writer

Inherited from the parent spec: first-fit packing into <32KB CODE
resources; intra-segment calls PC-relative BSR; cross-segment calls via
the CODE 0 jump table (Segment Loader contract); globals in the A5 world.
A single function exceeding the segment limit is a compile error (with
the function name — not a crash).

Addition the parent spec didn't cover: the resource-fork byte image
(resource map, CODE 0/1..n, SIZE, optionally BNDL/FREF/ICN#) is built
identically on every platform, but the **container** differs:

- **On the Mac:** written to the real resource fork via Toolbox traps,
  type/creator set. No Rez, no MacBinary.
- **On the host** (how the 5d gate cross-builds): wrapped in MacBinary so
  `LaunchAPPL` consumes it directly. Same bytes, two wrappers.

## Testing

Three rings:

1. **Encoder unit tests** against committed listing + byte goldens.
2. **vasm round-trip oracle (host):** the listing printer's output is
   assembled by `vasm/vasmm68k_mot -m68000 -no-opt -Fbin` (vasm 1.8g,
   installed in-repo at `vasm/`) and the resulting flat binary is
   **byte-compared** against our encoder's output for the same
   instruction stream. `-no-opt` is required — vasm otherwise rewrites
   branch sizes and addressing modes, assembling something other than
   what the listing literally says. Gated on `vasm/` presence, like
   mactest's toolchain gate. Constraint this imposes: the listing must
   stay vasm-assemblable — trap words print as `DC.W $Axxx` with the
   trap name as a trailing comment (`; _NewHandle`), labels/directives
   in vasm's Motorola syntax. This is strictly stronger than the earlier
   objdump idea (byte equality, not structural comparison) and replaces
   it.
3. **End-gate (per parent spec):** the monolithic suite app
   (`testdata/suite/test_suite.cla`) compiled by codegen68k, run under
   Mini vMac, stdout byte-compared against the host build — plus the ~5
   abort/runerr programs that must die in their own process. Emulator
   boots stay amortized: new logic tests join the suite app.

## Out of scope for 5d

- Peephole/regalloc (next phase after, likely soon — the parent spec is
  honest that naive codegen of hot ARC paths will need buy-back).
- Compilation cache (old 5c, now post-5d).
- UI runtime port and uisnaps-from-native (5e), Mac-resident clarusc (5f).

## Outcomes (2026-08-01, Tasks 1-16 landed)

The design landed close to as-written; every deviation below is either an
as-designed confirmation or a small addition the exploration surfaced, not
a redesign.

- **Direct binary emission via the instruction table: as designed.**
  `clarusc/asm68k.cla`'s single table drives the encoder and the listing
  printer exactly as planned; no parser was ever written. The vasm
  round-trip oracle (`internal/asm68k`) reached 254/254 instruction forms
  byte-identical, confirming the "goldens are our own listing output, vasm
  is only a second independent assembler for byte comparison" design.
- **C-style calling convention: as designed.** Caller-cleans, D0 result,
  LINK/UNLK A6, D0/D1/A0/A1 scratch. Trap-site Pascal/register conventions
  stayed fenced to the `external func` trap clause exactly as scoped —
  never leaked into the internal convention.
- **Rule-based reg traps, as designed.** The `external func` trap clause
  (Task 2) carries a convention flag (0=none, 1=pascal trap, 2=reg trap,
  3=inline deref, 4=inline nop); reg traps are checker-enforced to ≤2 ptr
  + ≤2 int/bool/char params (the fixed A0/A1+D0/D1 rule) at compile time,
  not runtime.
- **Inline clauses, as designed.** `HandleToPtr`-shaped deref and no-op
  clauses compile to zero-call inline code (Task 9), no `rt_ext_` shim
  round-trip.
- **`nat_` fallback convention (addition confirmed useful beyond plan
  scope).** Any `external func` with no trap/inline clause AND no
  hand-written `nat_<Name>` Clarus function is a HARD compile error
  ("extern X has no trap clause and no nat_ fallback") rather than a
  silent no-op or a runtime crash — this is what let Tasks 11-14 land
  `native.cla`'s console/quit/panic/args/file-I/O surface incrementally,
  one missing extern at a time, with the compiler naming exactly which
  one was still missing.
- **Per-segment constant pools: as designed.** String literals, enum
  tables, and serdesc tables are `LEA d16(PC)`-referenced per-CODE-segment
  pools, duplicated across segments when a constant is referenced from
  more than one (rare, harmless, deterministic) — no DATA resource, no
  startup copy step, exactly the design's tradeoff.
- **Capture-protocol-always-on (as-built convention, not explicitly
  named in the original design).** `native.cla`'s console/log/exit-code
  capture protocol (`##CLARUS-EXIT##`/`##CLARUS-LOG##` trailer, ported
  from `runtime/mac/rt_mac.c:83-253`) runs unconditionally in every
  native build, not gated behind a test-only flag the way Retro68's
  `RT_MAC_TEST` define is — every native `.bin`, including ones a user
  might eventually run standalone, always emits the same trailer. This
  made the harness side trivial (byte-identical `parseCapture` for both
  backends) at the cost of the trailer always being present in real
  output; acceptable since 5d has no non-test native consumer yet.
- **The Task 14.7 gap-closure insertion (real deviation from the plan's
  task sequence, not the design).** The design's own corpus assumption —
  that Tasks 7-13's codegen would already compile `test_suite.cla` — was
  wrong: Task 13's controller probe found `test_suite.cla` didn't compile
  under `emit68k` at all (first error: `cgExprAddr EIntr` no-address,
  a slice/intrinsic-in-expression-position class the design's addressing
  section hadn't enumerated). Task 14.7 was inserted between Tasks 14 and
  15 specifically to close that gap before segmentation (Task 15) could
  inherit unknown codegen holes — 5 error classes fixed at shared choke
  points (`cgExprAddr` materialize-fallback, a big-temp scratch pool for
  >4-byte container elements, str-builder intrinsics that previously
  silently no-op'd, `KErr`'s fixed layout, `EIndexRef` added to
  addressable call-arg shapes), landing a 62/62 compile-clean corpus.
- **Segmentation and the JT: as designed, with one real bug found on
  real hardware the design's own static verification didn't catch.**
  First-fit packing into ≤32,760-byte segments, intra-segment `BSR.W`,
  cross-segment `JSR d16(A5)` through the CODE 0 jump table — all as
  designed. What the design didn't anticipate: a classic 8-byte JT
  entry's first word is DATA in both its unloaded and loaded forms, and
  code starts at +2 — cross-segment `JSR` must target +2, not +0. This
  was invisible to static verification (the JT/offset arithmetic itself
  was provably correct) and only surfaced as a real-hardware crash on the
  first cross-segment `_LoadSeg` call (Task 15; see ROADMAP for the full
  writeup and Task 16's `TestSuiteOn68k`/forced-multi-segment gate that
  exercises the fix under load).
- **Resource fork + MacBinary host container: as designed.** Same
  resource-fork bytes on both platforms; MacBinary wrapper only on the
  host build path, exactly per the design's split.
- **End gate: as designed, per the parent spec's own testing-ring-3
  description.** `TestSuiteOn68k`/`TestRunErrOn68k`/`TestAbortOn68k` (9
  boots total) mirror the Retro68 gate's own three-test structure
  exactly; the same `RunSuiteHost`/`BuildSuiteHost` expectation now
  backs both `TestSuiteOnMac` and `TestSuiteOn68k`.
- **The LAYOUT AUTHORITY padding decision (parent spec + this design's
  own cg68k.cla header comment) is confirmed as-designed, but its
  interaction with the SHARED runtime modules (`str.cla`/`text.cla`,
  ported once for both backends in 5b/5c′) was an unexamined seam.**
  Padding every `bool`/`char` array element to 2 bytes was a deliberate,
  documented choice (no odd-byte-addressed struct/stack story on the
  68000) — but `rtStrToBytes`/`rtStrFromBytes`/`rtTextToBytes`/
  `rtTextFromBytes` assume a TIGHT byte buffer (correct for cprint's own
  C `char[N]`, which really is tight), and nothing in either the parent
  spec or this design flagged that the padding decision would silently
  break that shared contract for any `char[]` buffer touched by both
  direct indexing AND a `toBytes`/`fromBytes` call. Found and fixed by
  Task 16 (see ROADMAP's "hard-won lessons" list) via a scratch-buffer
  adapter at the four call sites, not a change to the padding rule
  itself or to the shared runtime.

Nothing in the design was reverted or found fundamentally wrong; the
deviations above are additions (nat_ fallback, capture-protocol-always-on,
Task 14.7's insertion), hardware-only findings (JT+2), or a cross-module
seam the design didn't examine (str/text buffer tightness vs. array
padding) — none of them required reopening a decision the design actually
made.
