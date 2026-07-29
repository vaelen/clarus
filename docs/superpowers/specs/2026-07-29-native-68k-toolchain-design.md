# Native 68k Toolchain (Plan 5) — Design

**Date:** 2026-07-29
**Status:** Approved (brainstorm with Andrew, 2026-07-29)

## Goal

Clarus becomes entirely self-contained on the Macintosh: clarusc, running as
a native 68k application, compiles Clarus source directly into a
double-clickable APPL — no Retro68, no C compiler, no separate linker
anywhere in the app-building path. A developer on a 4MB Mac Plus/SE under
System 6 builds real applications with nothing but clarusc and a text
editor.

## Decisions (with rationale)

1. **The Mac runtime is rewritten in Clarus.** A prebuilt C-runtime blob was
   rejected because it drags gcc's ABI and object format into our linker
   forever, and because the runtime co-evolves with the language — a blob
   hides the cross-toolchain dependency rather than removing it. With the
   runtime in Clarus, the native backend only ever links code it generated
   itself: we define the calling convention, and no foreign object parsing
   exists anywhere.
2. **The C printer stays as the host path.** One clarusc source, two
   backends. cprint keeps powering `clarus check`/host builds, CI, the
   differential corpus, and the bootstrap snapshot. Cost accepted: language
   features land in two backends.
3. **Whole-program codegen; no object files, no separate linker.** Partial
   compilation comes from a per-file compilation cache (interface +
   post-lower IR), not from a frozen relocatable format.
4. **Hardware envelope:** building typical apps must work on a 4MB
   Plus/SE under System 6. Full self-compilation of clarusc is promised only
   on an 8MB-class 68k machine, verified in emulation.
5. **Mac UX: a picker-driven build tool**, itself a Clarus GUI app. askOpen
   (or drag-and-drop) the entry `.cla`; includes resolve automatically;
   progress window; scrollable error list; APPL written next to the source.
   No project files. An IDE is a possible later roadmap item built on top.
6. **Narrow waist at the Toolbox API.** The C runtime shrinks toward a
   minimal Toolbox-shaped shim; everything above it is shared Clarus. The
   acid test: adding a new backend (e.g. LLVM IR) should cost one code
   generator, not a third runtime implementation.

## Architecture

```
lex → parse → check → lower → IR ─┬→ tree-shake → cprint     → C     (host)
                                  └→ tree-shake → codegen68k → APPL  (Mac)
```

### The narrow waist: declared Toolbox externals

Each Toolbox routine used by the runtime is declared once, with its trap
number and calling convention — conceptually:

    external func NewHandle(size: int): ptr = trap 0xA122 reg

A call site means different things per backend:

- **codegen68k** inlines the trap (push args / A-line word / pop result for
  Pascal-convention Toolbox traps; A0/D0 moves for register-based OS traps).
- **cprint** emits a call to a same-named C function in the host shim.
- A future LLVM backend would emit a call to the same shim.

There is no user-facing raw-trap syntax and no FFI layer; the portability
seam is this declaration set.

### Above the waist: the shared Clarus runtime

Strings, lists, maps, ARC bookkeeping, the serializer, widget/form logic,
event dispatch — one `.cla` source tree, compiled by whichever backend is
building. The UI runtime portion is Mac-only and is simply never reachable
(hence never emitted) in host builds.

The runtime is implicit: clarusc always feeds its runtime sources (or their
cache files) into the front of the program; user programs do not `include`
it. Tree-shaking drops whatever a program doesn't use — this is also the
answer to optional subsystems like networking: no configuration mechanism,
unreferenced functions get no code.

### Below the waist: the host C shim

A minimal C implementation of the Toolbox subset host builds exercise:
memory (NewHandle/DisposeHandle/BlockMove…), file I/O, console output — a
dozen-odd functions. The leak-gate/strict-ledger instrumentation moves to
the shim's allocation entry points, where it then validates the *actual
shared allocator logic* that ships on the Mac, not a parallel host
implementation. The shim never fully disappears — its floor is whatever cc
needs for the bootstrap snapshot — and that is fine; it is the moral
equivalent of an OS.

### Low-level language additions

The smallest unsafe surface that lets the runtime be Clarus:

- **`ptr`** — an untyped 32-bit address, distinct from `int`; obtainable
  from Handles/traps; offsettable (`p + n`).
- **Typed peek/poke** — read/write byte/word/long at a `ptr`. Toolbox record
  fields (WindowRecord, TERec…) are accessed via named offset constants,
  Inside Macintosh style. An "overlay record" sugar may be added later if
  runtime code proves unbearable; not in v1.
- **Declared Toolbox externals** as above.

Explicit non-goals for v1: address-of-arbitrary-variable, inline machine
code, general callbacks from the Toolbox (the event loop is ours; the
LDEF/CDEF case keeps the committed JMP-stub trick).

**Endianness rule:** peek/poke mean *native* byte order (68k big-endian,
hosts typically little-endian). Internally consistent for shim-owned
structures — but any byte layout that leaves the process (the CLRD
serializer, resource forks) must use explicit byte-at-a-time packing, never
peekw/peekl.

### codegen68k

- **Naive first:** stack-oriented codegen — IR temps on the stack, D0/A0
  scratch, no register allocation. Correctness over quality, measured
  against the ROADMAP's 68k timing baseline. A peephole/regalloc pass is a
  later, separate item — and note honestly: with the runtime's hot paths
  (retain/release, string concat, list ops) moving from gcc -O2 C to naive
  Clarus codegen, that pass is *likely needed soon after*, not optional
  someday.
- **Segmentation:** functions packed first-fit into CODE resources up to the
  ~32KB limit. Intra-segment calls direct PC-relative; cross-segment calls
  via the CODE 0 jump table (Segment Loader contract). Globals in the A5
  world.
- **App writer:** clarusc constructs the resource fork bytes itself
  (resource map; CODE 0/1..n; SIZE; optionally BNDL/FREF/ICN#), writes them
  to the output's resource fork, and sets type/creator — all via Toolbox
  traps from the runtime. No Rez, no MacBinary detour.

### Compilation cache

Per-file cache alongside the source (`foo.cla` → `foo.clc`) holding the
module's **exported interface** (for checking dependents without
re-front-ending) and its **post-lower IR**. A module = one include unit; the
`include` graph is the dependency graph — no new language surface.

Staleness (any hit → silently recompile from source; self-healing):

- source mod-date newer than cache;
- cache format-version stamp ≠ compiler's (the format changes freely between
  releases — this is what keeps it from being a frozen object format);
- any imported interface's stamp differs from what the cache recorded
  (transitive-staleness guard).

Mod-dates, not hashes: period-authentic, cheap on an 8MHz machine;
correctness only requires never *under*-rebuilding, which the dependency
stamps cover. Whole-program codegen consumes merged IR (fresh + cached).
Libraries: a directory of `.cla` plus optional pre-warmed `.clc`; IR-only
(closed-source) distribution works but is coupled to compiler version —
rebuild-per-release territory, acceptable.

## Migration strategy — every step shippable

The runtime port is decoupled from the native backend: during the
transition, the Mac build still goes through Retro68, and a ported module
compiles via cprint into C and links into the Mac build like any other
emitted code. Each module migrates independently with the full differential
+ Mac harness green after each one.

Port order: **serializer first** (pure byte logic, no Toolbox surface,
golden-tested), then core strings/lists/maps, then **mem/ARC last** (most
recently hardened, highest regression risk), UI runtime alongside the
native-backend milestone. Retro68 retires from the app path only when the
native backend passes the full corpus.

## Verification and bootstrap

- **Differential gate extends, not changes:** every corpus program builds
  twice — host (C path) and native 68k (run under Mini vMac via the existing
  mactest/uisnaps harness) — outputs byte-compared. The native backend grows
  up against this corpus.
- **Emulator boots are amortized via suite apps, never per-program.**
  Booting the emulator dominates test wall-clock, so the native 5d gate is
  ONE suite app (the existing monolithic `testdata/suite/test_suite.cla`,
  compiled by codegen68k, checked against the same host-stdout expectation)
  plus the small irreducible set of abort/runerr programs that must die in
  their own process (currently 5) — not one boot per corpus program. The
  same rule holds going forward for non-UI coverage generally: new logic
  tests join the suite app. New UI coverage extends an existing scenario's
  event script rather than adding a new scenario app, unless it needs a
  different launch context (e.g. document-open vs empty launch) or must end
  the app.
- **Bootstrap chain untouched:** the snapshot remains `clarusc.c` + the
  (shrinking) C shim, buildable by any cc. The snapshot's C includes the
  emitted C of migrated runtime modules — the same interlingua trick as
  today.
- **New fixed-point test:** cross-built clarusc.APPL and Mac-self-compiled
  clarusc.APPL must be byte-identical (same source, same backend,
  deterministic codegen), verified on an 8MB emulated machine. This is the
  "compiling on a Macintosh really works" proof.

## Sequencing (each phase gets its own spec + plan, like 4a–4e)

- **5a — Language + waist:** `ptr`, typed peek/poke, declared Toolbox
  externals; checker support; cprint lowering to shim calls; host shim
  skeleton with ledger instrumentation at the seam.
- **5b — Runtime migration wave 1:** serializer, then core
  strings/lists/maps; differential green throughout.
- **5c — Compilation cache:** interface/IR serialization, staleness rules,
  tree-shake pass at the IR level (also shrinks emitted C).
- **5d — 68k codegen v1:** naive codegen, segmentation + jump table,
  resource-fork app writer; non-UI corpus green under emulator.
- **5e — Runtime migration wave 2:** mem/ARC + UI runtime; UI corpus green
  against uisnaps goldens from native builds.
- **5f — Mac-resident clarusc:** picker GUI app, self-compile on 8MB,
  fixed-point APPL check; Retro68 retires from the app-build path.

Ordering note: 5c may slide after 5d — the cache is a usability feature for
on-Mac builds, not a correctness dependency.

## Risks (recorded honestly)

- **Perf regression on Mac:** runtime hot paths lose gcc -O2; naive codegen
  must be measured against the 68k timing baseline, with peephole/regalloc
  as the planned buy-back.
- **Re-porting hardened code:** rt_mem/ARC was just stabilized through the
  memory-audit and ARC milestones; porting it risks reintroducing eliminated
  bugs. Mitigation: it ports last, behind the proven pattern, under the
  strict-ledger gate now living at the shim seam.
- **Self-compile memory ceiling:** clarusc's biggest modules (~4.5k lines)
  set the peak front-end footprint; the 8MB envelope is believed sufficient
  but must be validated early in 5d/5f, in emulation, before it can gate the
  milestone.
