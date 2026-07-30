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
  Goldens are our own listing output; the objdump oracle (Testing ring 2)
  compares structurally, never textually — objdump emits MIT syntax and
  its formatting drifts across binutils versions.
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
2. **Disassembler oracle (host):** emitted CODE run through Retro68's
   m68k objdump and sanity-compared; gated on toolchain presence like
   mactest. Retro68 as oracle, never as production path.
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
