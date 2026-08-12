# Precompiled runtime artifacts — design notes (2026-08-12)

Status: **discussion notes, not a spec.** Captures the design conversation
around the 2026-08-10 performance findings doc's Layer 3 items 3 (bake the
runtime pre-parsed), 5 (precompiled object code + linker), and 6 (on-disk
artifact cache). Deliberately parked: the agreed prerequisite is §2.1's
param-ABI change (see "Sequencing decision" at the end), which gets
its own spec (`2026-08-12-param-abi-immutability-design.md`). Pick this
doc back up when that phase lands.

## The unifying idea

All three items are one trick applied at different pipeline depths:
**snapshot the compiler's state after phase N for the part of the input
that never changes** (the ~12.9k-line runtime/toolbox splice) and reload
the snapshot instead of recomputing. The deeper the snapshot, the more
work skipped and the harder the relocation problem:

| Artifact | Snapshot after | Skips | Hard part |
|---|---|---|---|
| Pre-parsed bake (L3 item 3) | parse (later: check) | expand/lex/parse (~5+ min Mac time); with the check extension, check#2's runtime share | index relocation, splice variants |
| Object code + linker (item 5) | codegen | everything for the runtime, all phases | relocation records, ABI stability |
| Artifact cache (item 6) | any of the above | same, generalized to user code | keying/invalidation |

Period precedents (same machine class as the target): THINK C's
precompiled `<MacHeaders>` (symbol-table dump), MPW's OMF object files +
`Link`, and — the closest model for Clarus — **Turbo/THINK Pascal
units**: one artifact carrying both an *interface section* (symbols, for
the checker) and an *object section* (code + relocations, for the
linker). THINK C's "smart link" (per-function dead-strip at link time) is
the precedent for moving tree-shaking into the linker.

## Item 3 — pre-parsed bake ("precompiled headers")

The classic PCH hard problem is pointer swizzling. **Clarus doesn't have
it**: the AST is four flat arenas of fixed-shape records whose fields are
all ints (`exprs`/`stmts`/`decls`/`typeExprs`, ast.cla:361-364; the
program is a decl chain linked by `next` indices). Serialization is
therefore nearly mechanical:

- **Format:** a versioned resource (working name `'CLPA'`) alongside the
  existing baked `'CLFS'` source resources: compiler-build-hash stamp,
  then per-arena sections (count + records as fixed-width big-endian
  ints), the intern pool (`strPool`) as length-prefixed strings, and the
  per-module head/tail indices + module keys the splice logic needs.
- **Relocation:** load the bake at **arena base 0** and every internal
  index is valid as-is; user files parse on top (indices N+1..). Arena
  population order is independent of decl-chain order, so
  `driveEarlySplice`'s runtime-first chain linking and check #1's
  user-standalone walk both survive unchanged. Fallback if base-0 ever
  fails: relocation = "add base to every index field," a mechanical walk
  over known record shapes.
- **Staleness:** regenerate at `--bake` time on the host; the version
  stamp makes a stale bake impossible to load by accident.
- **Obstacles** (from the findings doc, all tractable): splice set varies
  by program shape (UI/ser/native → a few bake variants or per-module
  payloads chosen by the existing manifest logic); `curPathIdx`
  diagnostics stamps; include-dedup hoisting (drive.cla:750-768) must
  dedup a user `include` of a runtime file against the bake's module-key
  manifest.

**v2 — bake post-check interface:** serialize the runtime's checked
symbols (`FuncSig` table, record layouts, enum values, extern
registrations) so the checker verifies user code against preloaded
symbols instead of re-checking 12.9k lines. This is the step that attacks
the dominant whole-program-check cost, and it is the *interface section*
of the unit model below. Requires making check incremental (runtime
checked once at bake time; user chain checked in a context preloaded with
runtime symbols). `usesFileSaveLoad` (computed during check #1) drives
the ser.cla splice decision and must keep working.

## Item 5 — object code + a real linker

An object file is finished machine code **with holes**: per function, the
emitted bytes plus a relocation table (`{offset-in-code, kind, symbol}`
entries) plus symbol tables (exports, imports, globals with sizes,
literal pool). The linker assigns final addresses/slots, patches holes,
concatenates, packs segments.

The findings doc's "why the runtime is recompiled today" list is exactly
the required relocation-kind list — which is why this is feasible rather
than speculative:

- **A5-relative globals** (`cgAssignGlobalOffsets`, whole-program):
  reloc kind patches the 16-bit `d16(A5)` displacement once the linker
  assigns final offsets from all modules' global tables.
- **Jump-table slots** (`cgAssignFinalJtSlots`): cross-segment calls go
  through 8-byte CODE 0 JT entries (`_LoadSeg` self-rewriting form,
  cg68k.cla:2118). Slots are *already* finalized only after
  `cgPackProgram` — the compiler already contains late call-site
  patching machinery; a linker generalizes it.
- **String/constant pool** (`lowStrIdx` merges all literals;
  `cgPackProgram` already tracks per-function pool-reference sets): each
  module carries its literal table; the linker dedups by value and
  patches references.
- **Intra-segment PC-relative calls:** distance depends on packing.
  v1: route all calls through the JT (uniform, slightly slower); an
  intra-segment reloc kind is a later optimization.

**The artifact is the Pascal unit:** interface section (post-check
symbols, so check works) + object section (per-function bytes + relocs +
sizes, so link works). Per compile, only user code runs the pipeline,
then a link pass. Two big side effects:

1. **§1.7 (double codegen) mostly dissolves for the runtime** — function
   sizes live in the artifact, so `cg68Measure` measures user functions
   only.
2. **Smart linking**: with per-function granularity and a symbol
   reference graph in the artifact, tree-shaking becomes link-time
   inclusion of reachable functions (shake.cla's worklist BFS over
   artifact metadata instead of live IR).

**Honest cost — ABI discipline:** anything changing record layout rules,
RC glue, calling conventions, or `cgSizeOf` decisions invalidates every
artifact. Version stamp + host-side regeneration makes that *safe*, but
it is a standing tax on future codegen changes: the bake becomes a
compatibility boundary.

## Item 6 — on-disk artifact cache

A cache is either artifact above plus a keying policy: **key =
hash(module source bytes) + compiler version stamp + relevant flags**,
value = the artifact. The runtime bake is the degenerate case (key pinned
at `--bake` time). Generalizing to user modules gives incremental
compilation: edit one file → recompile one module → relink. On-Mac, the
natural home is a per-app project file holding per-module artifacts —
literally THINK C's `.π` project design. Correctness gate writes itself:
cold vs cached compiles must be fork byte-identical (determinism already
verified, `a259d0f`).

## Staging

1. Bake post-parse AST (item 3 v1) — smallest step; proves serialization,
   version stamping, base-0 loading; kills Mac lex/parse.
2. Extend bake to post-check interface — makes check incremental; attacks
   the 35-minute whole-program check.
3. Object section + relocations + link pass (item 5) — runtime cost ~zero
   across all phases; §1.7 and shake move to link time.
4. Cache keying for user modules (item 6) — falls out of whichever
   artifact level exists when incremental user builds are wanted.

Synergy: this **replaces** Layer 3 item 2 (session-resident runtime) in
its risky form. A loaded bake is immutable — "resident across compiles"
becomes "reload the snapshot," sidestepping the stale-index bug class
(`a259d0f`) instead of auditing every index-keyed side table.

## Sequencing decision (2026-08-12, with Andrew)

Do **§2.1 (string call ABI) first**, then freeze the ABI and build
artifacts on it. Rationale: the artifacts freeze exactly the ABI surface
(parameter passing, returns, layouts, `cgSizeOf` answers), and §2.1 is
the only remaining findings item that rewrites that surface — the §2.3
items are function-internal codegen changes that don't cross it. §2.1
also compounds: clarusc is itself a Clarus program full of string
parameters, so every later phase (including the future link pass) speeds
up, and artifacts shrink. Not a hard blocker (version stamp → artifacts
regenerate free on host), but doing the one known big ABI rewrite first
avoids churning the compatibility boundary twice.

§2.1 scope agreed (widened during brainstorming, same day): **immutable
parameters (language change) + by-reference string AND record parameter
calling convention, storage unchanged** (`cgSizeOf(KStr)` stays 256;
records stay inline) — see `2026-08-12-param-abi-immutability-design.md`.
Variable-length string storage stays a separate, later decision (a memory
play, and the one that would destabilize the ABI again).
