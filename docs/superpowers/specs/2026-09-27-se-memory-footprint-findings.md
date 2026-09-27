# ClarusC.APPL memory footprint: path to a 4 MB Macintosh SE (2026-09-27)

Status: **findings/analysis only. No repo code changed.**

> **Numbering note.** The approved program
> (`2026-09-27-se-memory-program-design.md`) renumbers the waves proposed
> here: program Wave 0 = measurement (§8 here), 1 = this doc's Wave 1,
> 2 = Wave 2, **3 = narrow scalars (new)**, 4 = this doc's Wave 3 (lazy
> library), 5 = this doc's Wave 4 (code + stack), and the linker (this
> doc's Wave 5) is the post-Wave-5 decision. The program doc's decision
> log overrides anything here. Input to a
future phase (or several). It follows
`2026-08-10-native-compiler-performance-findings.md`, which was about
time. This one is about memory. The Compiler-on-Mac target has been on
hold since 2026-09-05 (`docs/TODO.md`); this doc is the case for
resuming it with a memory budget as the acceptance criterion.

## Goal

`ClarusC.APPL` compiles a small program (e.g. `examples/bookmarks.cla`)
on a **4 MB Macintosh SE under System 6**. That leaves roughly **3.0-3.3 MB
for the whole application**: code, heap, stack and loaded resources.
Measure this number on the real configuration before relying on it (see
§8).

Today the same compile needs **~14 MB of live heap alone**. On top of
that come 1.56 MB of code, a 729 KB stack reserve and a 1.92 MB resource
that is never released. So the gap is roughly **6x in total, and larger
than 10x in heap**.

## How this was measured

Everything below was measured on the host, not on a Mac. A scratch copy
of `runtime/host/rt_mem_host.inc` counted live bytes, the peak, blocks
and allocations. A generated census function walked every global
`list`/`map`/`text` in the compiler's own C (`clarusc/clarusc.c`) and
printed its handle size. Both dumped at every `driveProgressPhase` mark,
hooked through `rt_ext_TickCount`. The repo was untouched.

On sizes: the host is 64-bit. Every compiler arena that matters here
(AST, IR, tokens, symbols, `A68Item`) is a record of `int`/enum/bool
fields only. Those records have the same element size on both lanes,
which was checked against the emitted C structs and `cgSizeOfUncached`.
Box and handle overhead is double on the host, and Memory Manager block
headers are not counted at all. The host numbers are therefore a fair
proxy for arena bytes, and slightly low for block-heavy structures.

Six parallel code reviews supplied the analysis: front end, checker and
pipeline, IR/lower, 68k backend, runtime data representation, and
bake/linker. Their file:line findings are folded in below. The three
"lifetime" fixes in §4 were then **prototyped on scratch copies of the
sources** and re-measured.

## 1. Baseline

### 1.1 Peak live heap per compile (host-measured)

| Program (lines)       | From source | `--rtbake` (ClarusC.APPL's default) |
|-----------------------|------------:|------------------------------------:|
| `hello-mac.cla` (6)   |    10.04 MB |                            10.19 MB |
| `bookmarks.cla` (122) |    14.03 MB |                            11.54 MB |
| `texteditor.cla`      |    14.02 MB |                                   — |
| `tcpchat.cla` (313)   |    14.43 MB |                            11.99 MB |

Program size barely matters. **The cost is the runtime** (about 13k
lines, 767 functions), which every compile processes in full.

### 1.2 Where `bookmarks.cla` spends it (from source)

| Phase mark                          | Live after |       Δ |
|-------------------------------------|-----------:|--------:|
| Parse + check user program          |    0.14 MB |         |
| Splice runtime + check #2           |    6.67 MB | +6.5 MB |
| Lower (whole program)               |    8.44 MB | +1.8 MB |
| Shake                               |    8.47 MB |         |
| `cg68Measure`                       |   13.47 MB | +5.0 MB |
| Emit 4 segments + build fork (peak) |   14.03 MB |         |

About 90% of live bytes are list data handles. The top tables at the
`cg68Measure` mark:

| Global              |  Bytes (cap) |  Count |  Elem | Notes                                     |
|---------------------|-------------:|-------:|------:|-------------------------------------------|
| `a68Items`          |      4.72 MB | 48,554 |  72 B | whole program's instructions, never reset |
| `exprs` (AST)       |      2.36 MB | 34,796 |  36 B | dead since lowering                       |
| `irExprs`           |      1.31 MB | 28,800 |  40 B | 38% belongs to functions shake discards   |
| `strPool`           |      1.05 MB |  3,280 | 256 B | fixed Str255 slot per interned name       |
| `stmts` (AST)       |      0.59 MB |  9,938 |  36 B | dead since lowering                       |
| `toks`              |      0.39 MB |  2,553 |  24 B | dead since parsing (cap 16,384)           |
| `symbols`           |      0.29 MB |  5,296 |  36 B | dead since lowering                       |
| `decls`/`typeExprs` | 0.29 MB each | ~5,500 |  36 B | dead since lowering                       |

With `--rtbake`, **7.6 MB is live before the user program is even
parsed**. That breaks down as the 1.92 MB CLIR blob, the installed
arenas, and a second copy of the same arenas in the `bkLd*`/`bkLoaded*`
staging lists (3.18 MB, live for the entire compile).

### 1.3 Static footprint of ClarusC.APPL (self-build of `clarusc/macgui.cla`)

| Item                                          |          Size | Notes                                                        |
|-----------------------------------------------|--------------:|--------------------------------------------------------------|
| CODE, 47 segments                             |       1.56 MB | no `UnloadSeg` anywhere in compiler or runtime               |
| … of which `cg_free_globals` + RC-walk glue   |       ~560 KB | about 37% of instructions; duplicated into every segment     |
| … of which cg68k/asm68k/peep68k/app68k/res68k |       ~310 KB |                                                              |
| … of which check + types                      |       ~130 KB |                                                              |
| … of which lower + ir + shake                 |       ~180 KB |                                                              |
| … of which parse + ast + lex + tok            |        ~70 KB |                                                              |
| `__clir_bake_68k__` resource                  |       1.92 MB | read, copied, **never released** (`native.cla:1099-1130`)    |
| CLFS runtime/toolbox source resources         |       1.04 MB | only read on the fallback path and for `include "toolbox/…"` |
| Stack reserve (`SetApplLimit`)                |        729 KB | `cgStackHeuristic`, `cg68k.cla:3099`                         |
| A5 globals / jump table                       | 14 KB / 18 KB |                                                              |

The per-file code shares were estimated from instruction counts in the
`--listing` output and scaled to the real CODE byte total.

## 2. Diagnosis: three kinds of waste

1. **Lifetime: dead data held to the end of the compile.** The AST,
   tokens and checker tables have no readers after `lowerProgram`. This
   was verified by grep over cg68k/shake/asm68k/peep68k/app68k/res68k/
   bake/uiblob; the only checker-table hit is inside an error-message
   string. Even so, they stay live through codegen, which is where the
   peak is. `cg68Measure` calls `a68Reset()` once
   (`cg68k.cla:14096`) and piles every instruction of the program into
   `a68Items`, although only the per-function size delta is ever read.
   The bake staging copies and the raw blob outlive the install.
2. **Representation: 256-byte strings, doubling that never shrinks,
   oversized boxes.**
   - `strPool` spends 256 B per name, against an average identifier of
     about 8 bytes (`lib.cla:7`).
   - `list.clear()` only sets `count = 0` (`list.cla:442-447`), so
     capacity stays at its high-water mark forever. `astReset()`
     "resets" nothing, and the only real free is reassigning a fresh
     list, the `libReset` idiom (`lib.cla:51-56`).
   - Container boxes are sized for 8-byte pointers on the 68k too: list
     40 B vs 20 B needed, map 112 B vs 52 B (`list.cla:196`,
     `map.cla:580`).
   - The language reference says an enum is 2 bytes, but the native
     lane stores it in 4 (`cg68k.cla:1939`).
   - `sortedmap` still uses 256-byte key blocks (`sortedmap.cla:46-69`).
3. **Architecture: every compile processes the entire runtime, and the
   whole program at once.**
   - The runtime is spliced unconditionally (`drive.cla:1640-1714`), so
     that IR indices stay stable for the bake.
   - It is checked and lowered in full, and shaken only afterwards:
     475 of 767 functions are reachable for bookmarks.
   - The bake installs every runtime function's IR plus its checker
     symbols wholesale, and gives no index for loading lazily.
   - Codegen measures the whole program before it can pack segments.

The language itself does not force whole-program work. There is no
overloading, no global type inference, and no monomorphization. The
couplings are all *implementation*:
- A5 offsets (`cgAssignGlobalOffsets`, `cg68k.cla:2520`)
- JT slots (`cgAssignFinalJtSlots`, `:2340`)
- segment packing (`cgPackProgram`, `:14420`)
- the merged string-literal pool (`lowStrIdx`, `lower.cla:43`)
- `lowComputeCanAbort`'s interprocedural fixpoint (`lower.cla:8779`)
- lowering's declaration-order slot numbering (`lower.cla:158-191`)
- `cg_free_globals` (`cg68k.cla:1053`)
- the bake's positional runtime/user boundary (`bake.cla:2470-2490`)

## 3. What the prototype proved

These three changes were made to scratch copies of `clarusc/*.cla`. The
existing compiler emitted and built them, and every output was
**byte-identical** to baseline: hello-mac, bookmarks, texteditor,
mandelbrot and tcpchat from source, bookmarks/tcpchat/hello-mac with
`--rtbake`, and the CLIR bake itself.

- **A.** After `lowerProgram` succeeds, free `exprs`/`stmts`/`decls`/
  `typeExprs`/`toks` by reassigning fresh lists, not by calling
  `.clear()`.
- **B.** In `cg68Measure`'s per-function loop, clear `a68Items`/
  `a68CommentTexts`/`a68DataTexts` after each size delta is recorded.
  The label tables and `a68Pc` are kept.
- **C.** On the bake path, after install, free `bkLdIr{Types,Stmts,Exprs,
  Locals}`, `bkLdStrPool`, `bkLoaded{FuncSigs,Symbols,Scopes,
  DeclFileTab}`, and `rtbakeBytes`.

| bookmarks.cla | Baseline peak | A+B (+C) peak | Live after lowering | Codegen phase |
|---------------|--------------:|--------------:|--------------------:|--------------:|
| from source   |      14.03 MB |       8.44 MB |             4.51 MB |     ≤ 6.56 MB |
| `--rtbake`    |      11.54 MB |       9.48 MB |             3.91 MB |     ≤ 5.38 MB |

About 40 lines of change took roughly 5.5 MB off the from-source peak.
The peak now sits where A–C cannot reach it: whole-program check and
lower from source, or install on the bake path, where staging and
installed copies still coexist briefly.

What is still live after lowering on the bake path, 3.9 MB:
- `irExprs` 1.31 MB
- `strPool` 1.05 MB
- `irStmts` 0.23 MB
- `cgObjHoles` 0.20 MB
- `strIndex` 0.16 MB
- `irTypes` 0.13 MB
- `cgObjRuns` 0.07 MB plus about 4,400 tiny text handles
- about 9,800 heap blocks in total

## 4. Proposals

Each proposal gives: the saving at bookmarks scale (host bytes ≈ 68k
arena bytes), effort S/M/L, and risk. They are grouped into waves that
can ship independently. Every one is checkable on the host with the
existing byte-identity oracles, plus a new memory gate (§8).

### Wave 1: lifetimes (S, byte-identical, no language change)

| #   | Change                                                                                                                                                                                     |                                                     Saves | Effort | Risk                                                                                                                                                                     |
|-----|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------:|:------:|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1a  | Free AST + `toks` + `lexSrc` after lowering (prototype A); keep `declFileTab` only for `--bake-ir`                                                                                         |                                                    3.9 MB |   S    | Low                                                                                                                                                                      |
| 1b  | Free checker tables after lowering (`symbols`, `scopes`, `funcSigs`, check-only maps such as `funcScopeByDecl`/`funcRetByDecl`/`xrecSizeByName`, `check.cla:6457-6538`) unless `--bake-ir` |                                                   0.4 MB+ |   S    | Low                                                                                                                                                                      |
| 1c  | Per-function `a68Items` reset in `cg68Measure` (prototype B), including the pool-entry loop in `cgEmitPoolsBody`                                                                           |                                    4.2 MB at the old peak |   S    | Low                                                                                                                                                                      |
| 1d  | Free bake staging + blob after install (prototype C)                                                                                                                                       |                                      3.2 MB + 1.9 MB blob |   S    | Medium: Design B's second-compile fast path (`2026-08-15-clir-load-perf-design.md` §4) re-clones from staging. Make it single-shot on the SE, or re-decode on compile #2 |
| 1e  | Install by moving the staging lists into the live arenas, not `.clone()` (`bake.cla:4303-4344`, `bkInstallPool` `:4076-4092`)                                                              | removes the 9.5 MB install peak (~1.9 MB coexisting copy) |   S    | Low                                                                                                                                                                      |
| 1f  | Parse the CheckerSymbols section only under `--testapi` (`bake.cla:3649`; its consumer at `:4598` is already gated)                                                                        |                                     0.36 MB + 217 KB read |   S    | Low                                                                                                                                                                      |
| 1g  | Add `list.release()`/`shrink()` so phases can hand back capacity; rewrite `astReset` and friends to really free                                                                            |                                          enables the rest |  S–M   | Low                                                                                                                                                                      |

**Expected after wave 1:** bake-path peak ≈ 5–6 MB, set by
installed-IR-for-the-whole-runtime + `strPool` + codegen.

### Wave 2: representation (M, mostly byte-identical)

| #   | Change                                                                                                                                                                                    |                                             Saves | Effort | Risk                                                              |
|-----|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------:|:------:|-------------------------------------------------------------------|
| 2a  | `strPool` becomes one byte blob + `list of int` offsets. `intern`/`poolGet` contracts unchanged (`lib.cla:7-42`). Same for the bake's pool section                                        |                         ~1.0 MB (+1.0 MB staging) |   M    | Low–Med                                                           |
| 2b  | Per-function emit in the segment loop too: generate → peephole → encode → keep bytes + holes (the existing `cgObjRuns`/`cgObjHoles` shape, `cg68k.cla:14802-14836`) → drop the items      | segment-pass items ~1.1 MB → one function's worth |   M    | Med (the A3 byte-count assertion `cg68k.cla:15209` is the oracle) |
| 2c  | `cgObjRuns` becomes one flat byte pool + (offset, len) instead of `list of text`                                                                                                          |                           ~4,400 handles, ~0.2 MB |   M    | Med                                                               |
| 2d  | 68k-correct container box sizes via `_68k.cla` companions                                                                                                                                 |    20–60 B per container; thousands of containers |   S    | Low                                                               |
| 2e  | Correct `MoreMasters` count for ~10k live blocks (only 256 are pre-allocated today, `native.cla:1416-1432`)                                                                               |                          fragmentation, not bytes |   S    | Low                                                               |
| 2f  | Pre-size (`reserve`) big arenas from known counts instead of doubling. Growing a big handle needs old + new contiguous at once: `a68Items`' next doubling would need ~13.5 MB transiently |                           worst-case transient 2x |   S    | Low                                                               |
| 2g  | Pack `IRExpr`'s bools and fold flags into spare bits (`ir.cla:325-338`)                                                                                                                   |                           40 → 32 B/node, ~0.2 MB |  S–M   | Low                                                               |

### Wave 3: lazy runtime library (L, the decisive change)

Make the baked runtime a **library you query, not a blob you install**:

- **3a.** A call-graph summary section: per function, its outgoing
  edges plus the unconditional shake roots. Run shake against the
  summary *before* loading any IR or object code.
- **3b.** A per-function offset index into the ObjCode section. Paste
  only reachable functions' bytes + holes, fetching them per function.
  Most runtime functions never need IR at all: they are pasted object
  code. Only the ~21 functions tainted at bake time, plus user code, go
  through lower and cg.
- **3c.** An on-demand checker interface. On a symbol-lookup miss,
  fetch that name's signature/record/enum from an index, instead of
  installing 5,300 symbols up front. The existing `--testapi` preload
  (`bkInstallCheckerSymbolsForTestapi`, `bake.cla:4598-4620`) proves
  the data shape. Only the loading policy changes.
- **3d.** Store the library in a **data-fork file read with
  `filehandle.readAt`**, not a resource.
  - `ReadPartialResource` is System 7 only, and the whole-resource read
    path already leaks a 1.9 MB unreleasable handle
    (`native.cla:1099-1130`).
  - Positioned reads are System 6-safe and already hardware-proven
    (the binary-files phase).
  - They cap resident library data at the index + the pieces in use.
- **3e.** Consequences for the bake path:
  - `lowStrIdx` must stop resuming from the bake's end state. It needs
    per-module literal pools, deduped at link time.
  - Lowering's slot numbering (`lower.cla:158-191`) must become
    reachability-ordered.
  - `lowComputeCanAbort` must treat the runtime conservatively: user
    code can make a runtime dispatcher `canAbort`, and a prebuilt
    library cannot know that in advance (`lower.cla:8727-8744`).

**Expected:** runtime residency 7.6 MB → a few hundred KB. The library
file shrinks from 1.92 MB to about 0.4 MB: drop the IR bodies (1.32 MB,
69%) and move CheckerSymbols to a `--testapi` sidecar, leaving ObjCode
+ ObjMeta + index. That brings the small-program compile to an estimated
**~1 MB of heap**:
- ~50 KB compact pool
- ~0.2 MB user AST/IR
- a few hundred KB of interface + object pieces
- one 32 KB segment buffer
- ~0.2 MB of tables and block overhead

### Wave 4: code and stack footprint (M–L)

| #   | Change                                                                                                                                                                                                                                                                                              |                       Saves |      Effort     | Risk                              |
|-----|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------:|:---------------:|-----------------------------------|
| 4a  | Table-driven `cg_free_globals` + RC walks (TODO.md "ABI / performance" lever (a)), or a JT slot so it lives in one segment (lever (b))                                                                                                                                                              |     ~550 KB of 1.56 MB CODE |        M        | Med (reblesses every `.s` golden) |
| 4b  | **Code overlays**: phase-grouped segment packing (`cgPackProgram` bucketed by source file / phase tag) + `UnloadSeg` of a finished phase's segments from `drive.cla`, where no phase code is on the stack. Peak resident code becomes the largest phase (cg, ~310 KB) + runtime/driver/UI (~150 KB) | ~1.0 MB → ~0.46 MB resident |        L        | Med                               |
| 4c  | Measure the real stack high-water mark on the Mac (paint the stack at startup, scan it after a compile). Then set ClarusC's `stack:` app field from data, not from the static all-paths bound. 729 KB is a sound upper bound for the whole UI → drive → phases → deepest recursion chain            |    likely 729 KB → ≤ 128 KB | S (measure) / M | Low with measurement              |
| 4d  | Shrink the frames on the deep recursive walks (`checkExpr`/`lowExpr`/`cgEmitExpr`): fewer 256-byte string locals/temps (use `string(n)` or pool indices) and a smaller big-temp floor (4 × 512 B per frame, `cg68k.cla:1483`). Explicit work stacks only if 4c shows it is needed                   |               frame × depth |       M–L       | Med                               |

### Wave 5: separate compilation and a linker (L, the end state)

The object-code + relocation machinery already exists and has passed
byte-identity testing, but only for runtime functions:
- `cgObjRuns`/`cgObjHoles`
- five hole kinds: call, JT address, label with 12 relocation classes,
  callback-glue address
- the paste path `cgObjPasteFunc`

Generalizing it gives THINK C's model:
- **Compile** each `.cla` into an object: an interface summary + code
  bytes + holes + global counts + a local literal pool. Peak memory is
  one module's AST/IR plus the interfaces it imports (looked up on
  demand, as in 3c).
- **Link** in a streaming pass:
  - read the symbol tables
  - shake over the summaries
  - assign A5 offsets, JT slots and segments from the metadata
  - synthesize `cg_free_globals`/init-globals/RC walks/pools
  - copy each segment's bytes with fixups, then write it with
    `AddResource`/`WriteResource`

  Estimated peak: well under 1 MB, dominated by symbol tables.
- **Whole-program couplings** to generalize: the list at the end of §2,
  plus the `--testapi` early-splice prefix rule.
- **Output side**: stop accumulating every segment and the whole fork,
  and stop copying the fork again for MacBinary (`app68k.cla:582-639`).

Wave 3 buys most of the memory. Wave 5 is what makes compile time scale
with the *edited* module instead of the program, and what lets a larger
user program fit at all.

## 5. Language features: what each would buy

| Feature                                                                                                         | What it buys the compiler                                                                                                                           | Priority                   |
|-----------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------|
| `list.release()` / `list.shrink()` (and `map`/`text` equivalents); make `clear()`'s capacity semantics explicit | the only safe way to hand memory back between phases; today it takes a hand-written reassignment idiom that `astReset` gets wrong                   | **High**                   |
| Enum = 2 bytes on the native lane, as the spec already says                                                     | spec conformance. ~2 B per enum field. Small but free, and the `A68Item`/AST/IR `kind` fields take it                                               | Medium (reblesses goldens) |
| `int16` / `byte` scalar field types                                                                             | AST/IR node 36 → ~24 B, `A68Item` 72 → ~36 B. ~30% of *arena* bytes, but mostly moot once waves 1–3 shrink arena residency                          | Low–Medium                 |
| `segment "name"` directive (per file/func) + runtime `unloadSegment`/automatic phase unload                     | what makes 4b expressible for *user* programs too, the classic `#pragma segment` idiom; user apps on a Plus/SE need it as much as the compiler does | Medium                     |
| `import` (interface-only, separately compiled) alongside textual `include`                                      | the language surface for wave 5; `include` stays textual                                                                                            | End state                  |
| Variable-length string value type                                                                               | not needed by the compiler: the only big 256-byte structure is `strPool` (2a). Worth it for user programs later                                     | Low here                   |

## 6. Recommended sequencing

1. **Build the memory gate first** (§8). It gives every later wave a
   number to beat.
2. **Wave 1.** Days, not weeks. Mostly prototyped already.
   Byte-identical.
3. **Wave 2a + 2b + 2f**, then re-measure. Expected bake-path peak
   ~3–4 MB, still above target, with the whole-runtime IR install as
   the floor.
4. **Wave 3.** The decisive step for the SE. Also removes the
   unreleasable 1.9 MB resource handle, via 3d.
5. **Wave 4a + 4c** (cheap code and stack wins), then 4b if the
   on-target total still doesn't fit.
6. **Wave 5** when edit-compile time or bigger user programs demand it.

Projected SE budget after waves 1–4:

| Item                       |        Today |                  Target |
|----------------------------|-------------:|------------------------:|
| Resident code              |      1.56 MB |            ~0.46–1.0 MB |
| Stack                      |       729 KB |                ≤ 128 KB |
| Heap (small program)       |     ~11.5 MB |                 ~1.0 MB |
| Library/resource residency |      1.92 MB | index + pieces, ~100 KB |
| **Total**                  | **~15.7 MB** |         **~1.7–2.3 MB** |

The target leaves margin for fragmentation and for the Toolbox.

## 7. Things verified to be fine (don't spend time here)

- Tokens are a per-file rolling buffer. Only the high-water capacity is
  wasted, which Wave 1 fixes.
- `strIndex` already uses `map`'s compact keypool. Only `strPool` wastes
  space.
- No persisted AST/IR record carries a `string` field. They all carry
  pool indices.
- `MaxApplZone`/`SetApplLimit`/`MoreMasters` are already called at
  startup (`cg68k.cla:3283-3288`); only the `MoreMasters` count is low.
- The user-program front end is cheap: 0.14 MB for 122 lines.

## 8. Measurement gaps and tooling to add

- **Host memory gate.** Promote the scratch instrumentation to a real
  `CLARUS_MEM_PEAK` report in `rt_mem_host.inc`, reported in 68k-
  equivalent bytes: count box and handle payloads at native widths, and
  add a per-block header estimate. Add a `tests/memgate/` script that
  fails when bookmarks' peak exceeds a budget, perfgate-style. This is
  what lets waves 1–3 be ratcheted down on Linux, where the emulator
  lanes SKIP.
- **On-target truth.**
  - Measure a Mini vMac Plus/SE configured at 4 MB with System 6.0.8:
    free memory after boot, both without MultiFinder and under
    MultiFinder with a Finder partition. That turns "~3.0–3.3 MB" into a
    fixed number.
  - Add `FreeMem`/`MaxBlock` to ClarusC's per-phase progress lines on
    the Mac.
  - Measure the stack high-water mark (4c).
- **Grep hygiene.** `lex.cla` and `lib.cla` are MacRoman, and this
  shell's `grep` (ugrep) silently skips them as binary. Use
  `/usr/bin/grep -a` for "no readers" audits.
