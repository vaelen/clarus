# Native compiler performance findings (2026-08-10)

Status: **findings/brainstorm only — no code changed.** Input to a future
compiler-performance phase. Produced while the mac-resident-clarusc
acceptance run was still in flight; nothing here touches that branch.

## Problem statement

Compiling even a small application with the Mac-resident compiler
(`ClarusC.APPL`) takes hours — far too long to be useful to a real
programmer. THINK C and Pascal compilers ran comfortably on 8MB System 6
machines at ~10k lines/min, so this is achievable. This review explored
the compiler and runtime for classic performance problems, caching
opportunities, memory inefficiency, and systemic Clarus-language issues.

## Baseline measurements

| Measurement | Value | Source |
|---|---|---|
| Host compile of `testdata/cg68k/tickprobe.cla` (65 lines + ~12.9k-line runtime splice, `emit68k`) | **1.25 s wall, 142 MB peak RSS** | measured this session |
| Same compile on Mac (Snow) | empty program ≈ 20 min at ~10× FF; tickprobe **>4 h at ~6.8× FF, unfinished** | `.superpowers/sdd/2026-08-08-mac-resident-clarusc/task-11-report.md:936-943` |
| Lexing `lib.cla`+`tok.cla`+`lex.cla` (1,044 lines) on emulated Mac | **~26.4 s per pass ≈ 40 lines/s** (15,818 ticks / 10 iters) | `.superpowers/sdd/2026-08-08-peephole68k/task-9-report.md:62-64` |
| Extrapolated lex time for the 12,907-line UI runtime splice | **~5.4 min of Mac time per compile** — and lexing is the *cheapest* phase | derived |
| Allocations per tickprobe compile | **1,244,652** | `task-1-report.md:171` |
| Peak live heap (Mac lane, host-instrumented) | **39.8 MB** (spec §7 estimated 14–22 MB; partition raised to 48 MB) | `task-1-report.md`, `build-clarusc-mac.sh --partition` |
| Runtime splice size | unconditional core/str/text/list/map+native = 3,674 lines; any UI program = **12,907 lines** | `drive.cla:1020-1050` |

Per-phase live-heap profile (tickprobe, UI):

| Phase | Live bytes after | Δ | Share of peak |
|---|---:|---:|---|
| phase A (expand/lex/parse, user) | 60,040 | +48,656 | |
| checkProgram #1 (user standalone) | 167,184 | +107,144 | |
| runtime manifest splice | 3,660,520 | +3,493,336 | 9% |
| checkProgram #2 (whole program) | 10,658,504 | +6,997,984 | **18%** |
| lowerProgram | 12,191,272 | +1,532,768 | 4% |
| cg68Program | 39,031,652 | +26,840,380 | **67%** |

(`.superpowers/sdd/2026-08-08-mac-resident-clarusc/task-1-report.md:296-341`.
Memory is the only per-phase proxy we have for Mac time; only lexing has a
real Mac-tick measurement. **Instrument per-phase `TickCount()` on-Mac
before betting heavily on this ranking.**)

## Diagnosis

Three layers multiply:

1. **Genuine quadratics and hot-loop linear scans in clarusc's own code**
   (most caused by needing int-keyed tables in a language whose only
   associative container is a string-keyed map).
2. **Constant-factor taxes in the runtime/codegen** that every Clarus
   operation pays (256-byte string copies, a Toolbox trap per byte-move,
   software divide loops, JSR-per-primitive).
3. **Architecture**: every compile re-lexes/re-parses/re-checks/re-lowers
   ~12.9k lines of identical runtime source; tree-shaking runs only
   *after* check and lower; nothing is cached across compiles.

Estimated recoverable: layer 1 alone plausibly 10–50×; layers 2–3 are
what make an 8 MB machine viable (both time and the 39.8 MB → <8 MB
memory path).

---

## Layer 1 — algorithmic bugs in clarusc (small diffs, huge wins)

### 1.1 `keywordKind`: up to 33 `intern()` calls per identifier token — CRITICAL

**Issue:** After the lexer scans an identifier, it must decide whether
it's a keyword (`func`, `var`, `while`, …) or a plain name.
`keywordKind` (`clarusc/tok.cla:104-139`) does this by writing
`if nameIdx == intern("func")`, `if nameIdx == intern("var")`, … 33
times, and it runs for **every identifier token** (`lex.cla:401`). The
catch is that `intern("func")` is not a cheap constant — every call
(`lib.cla:11-21`) copies the 256-byte string literal onto the stack by
value, then searches the string pool *twice* (a `has()` binary search
followed by a `get()` binary search, each probe a full `rtStrCmp`
function call, each midpoint computation a software divide — see 2.3).
Identifying one identifier costs ~66 binary searches, ~1,200
string-compare calls, and ~8 KB of byte copying. Estimated **80–95% of
all lex time** — essentially the entire 264 s bench number, and why
lexing runs at ~40 lines/second on the Mac.

**Fix:** Intern each keyword exactly once at startup into 33
module-level int constants (`kwFunc`, `kwVar`, …). `keywordKind` already
has the identifier's interned `nameIdx` in hand, so the whole function
becomes 33 integer comparisons. Expected ~10× on lexing from a ~40-line
mechanical change.

### 1.2 `exprTypeOf[numToStr(e)]` per expression node — CRITICAL

**Issue:** The checker records the computed type of every expression
node: `exprTypeOf[numToStr(e)] = t` (`check.cla:4848-4853`). The key `e`
is already a small dense integer (an arena index), but Clarus maps only
accept string keys, so it's converted to a decimal string first. Two
problems compound: `numToStr` itself builds the string by repeated
per-digit prepend (a 256-byte scratch + runtime calls per digit), and
the map's insert memmoves its entire tail of 256-byte key blocks to
open a slot (`runtime/clarus/map.cla:165,422`; host mirror
`rt_core.inc:600-697`). Decimal keys arrive in lexicographically random
order, so the average insert shifts half the table. Total cost is
quadratic in expression count — roughly **40–100 GB of trap-dispatched
BlockMoveData for a 12k-line compile** — plus 6–10 MB of key storage in
one handle on a machine with a single-digit-MB heap. `lower.cla` reads
the table back through `exprTypeGet` at 43 sites, paying `numToStr` +
binary search again. Seven sibling tables use the same idiom:
`funcSigByDecl`, `funcScopeByDecl`/`funcRetByDecl`
(`check.cla:2170,2234`), `constUseIsStr`/`constUseInt`/`constUseStr`
(`check.cla:4188-4192`), `enumConstOf` (`check.cla:4202`); also
`ir.cla:733,751` and `lower.cla:3303` — so lowering/IR likely pay the
same quadratic.

**Fix:** Replace each with a plain `list of int` indexed directly by the
arena index, grown to the arena's size — the codebase already does
exactly this for decl→file mapping (`declFileTab`/`setDeclFile`,
`lib.cla:104-118`). Writes and reads become one bounds-checked array
access; the `numToStr` calls and the quadratic memmove vanish in one
edit. Probably the single biggest win in the checker, and the same edit
pattern applies to the IR/lower tables.

### 1.3 `cgHeurOnCycle`: O(V²·E) whole-graph BFS — CRITICAL for cg68k

**Issue:** The stack-size heuristic needs to know which functions sit on
call-graph cycles. The call graph is stored as flat edge lists with one
entry *per call site* (`shake.cla:106-110`) — no deduplication, no
adjacency index — so answering "who does function X call?" requires
scanning every edge in the program (~20k at self-host scale).
`cgHeurOnCycle` (`cg68k.cla:1818`) runs a BFS that does this full-edge
scan per visited node, it's invoked once per reachable function
(~1,000+, driver loop `cg68k.cla:2070-2075`), and the whole thing runs
twice (measure pass `:10328`, segment-1 pass `:10750`) → O(V²·E) ≈ 10¹⁰
edge visits, each a function call. It also allocates and fills a fresh
V-sized `visited` list per call. The author saw this coming: the
`ponytail:` comment at `cg68k.cla:1815-1817` names "the 5f Mac-resident
self-compile is slow" as the upgrade trigger — reached.

**Fix:** Two standard pieces: (a) after `shakeProgram`, build an
adjacency index once — sort/bucket the edge list by source function so
"successors of X" is a direct slice; (b) replace the per-function cycle
probes with one strongly-connected-components pass (Tarjan/Kosaraju),
which answers "is on a cycle" for *every* function in a single O(V+E)
traversal. ~40 lines; turns the worst asymptotic offender in the
backend into noise.

### 1.4 Codegen inner-loop linear scans with 256-byte string compares — VERY HIGH

**Issue:** The hottest loops in cg68k resolve names by walking whole
tables and comparing strings, all of it twice (measure + emit):

- Every variable reference calls `cgVarOff` (`cg68k.cla:4204`), which
  linear-scans either the frame table (`cgFindFrameOffset`, `:4164`) or
  *all* program globals (`cgFindGlobalOffset`, `:4179`), calling
  `poolGet` (a 256 B copy) + `rtStrCmp` per candidate.
- Every record field access calls `cgFieldOffset` (`:1428`), which
  linear-scans `irRecords` by string compare (`cgFindRecordByName`,
  `:1405`; also `cgFindSerdescLabel`, `:3447`) — inside `cgSizeOf`
  (`:1178`), which is recursive and **unmemoized**, so nested records
  re-scan the registry at every level; `cgFieldRefAddr` (`:4469`) pays
  it per field-access node, and there are 54 `cgSizeOf` call sites.
  IRTypes are never interned (`ir.cla:1118` appends unconditionally),
  forcing structural compares.
- Every emitted runtime call (`rtStrStore`, retain/release, panics…)
  calls `findIRFuncIdxByName(intern("literal"))` (`ir.cla:1893`) — a
  fresh intern (two binary searches) plus a linear scan over all ~1,600
  IR functions; 40 call sites in cg68k including `cgCallRuntime`
  (`:7736`), `cgEmitPtrRcCall` (`:2663`), `cgEmitAtCall` (`:3171`).

**Fix:** Build lookup tables once instead of searching repeatedly: an
interned-name→offset map for globals (once per compile), a small frame
map per function, name→index maps for records and IR functions
(`shake.cla:79` already builds exactly this shape for itself), and two
`list of int` memo tables for size/align keyed by IRType index,
invalidated by `irReset`. Hoist the 40
`findIRFuncIdxByName(intern(...))` sites into module globals resolved
once per compile. All mechanical, ~50–100 lines total; removes string
traffic from the innermost codegen loop.

### 1.5 `cgIntr` string dispatch — HIGH

**Issue:** When the code generator meets an intrinsic operation (string
concat, list push, UI calls…), it fetches the intrinsic's *name* as a
string — `nm = poolGet(irIntrName(e))` (`cg68k.cla:6184`), a 256 B copy
— then walks an if/else chain of up to 59 `nm == "literal"` compares,
plus 37 more in `cgIntrUi` (which receives `nm` by value — another
256 B copy). Each `==` is an `rtStrCmp` call. 162 `== "` compares in
cg68k.cla overall, some on paths hotter than `cgIntr` itself (`:4361`
per address computation, `:7461` per call argument). Average cost ~30
string-compare calls plus half a KB of copying per intrinsic node,
twice per function. The proof it's unnecessary is in the same repo:
cprint.cla, the C-printing backend, handles the same IR with exactly
**one** string compare in 5,871 lines — it dispatches on interned ints.

**Fix:** Dispatch on the int: `irIntrName(e)` already returns an
interned pool index, so compare it against pre-resolved int constants
(the memoized `I*()` helpers from 1.8) instead of round-tripping through
`poolGet`. The if-chain structure can stay; only the comparisons change
from string to int. Mechanical edit across ~100 arms, following
cprint.cla's existing pattern.

### 1.6 Peephole copies a 384-byte record 8–24× per instruction — HIGH

**Issue:** Every assembly instruction lives in an `A68Item` record
(`asm68k.cla:180-199`) that carries fields for *all* item kinds at once:
a 64-byte trap-name string, a 256-byte comment string, and a refcounted
`text` handle — ~384 B, even though a typical instruction uses none of
those three. The peephole copies the whole record by value at the top of
each of its 4 passes (`peep68k.cla:111,176,216,262`), again inside its
probe helpers (`:78,141`), and again in `peepKill` (`:50`) just to flip
one field — and each record copy also triggers a retain/release on the
embedded `text` handle. Passes run to fixpoint (≥2 sweeps typical,
since the MOVEQ-narrowing pass fires on essentially every function) and
the whole thing happens twice (measure + emit) → ~10 KB of memcpy plus
RC traffic per emitted instruction. The window scan itself is correctly
bounded to the current function and doesn't restart per change — the
cost is purely the copying.

**Fix:** Shrink `A68Item` to ~48 B of plain ints by moving the three
rarely-used fields (`trapName`, `commentText`, `dataText`) into side
tables indexed by item id — only the item kinds that need them ever
touch them. Then have the peephole read fields in place
(`a68Items[i].op`) instead of copying records into locals. Also cuts
the assembler arena's memory footprint ~8×, which matters for the
8 MB-machine goal.

### 1.7 Every function code-generated twice — HIGH

**Issue:** 68k applications are split into ≤32 KB code segments, and to
bin-pack functions into segments the compiler needs their sizes. It gets
them by running `cg68Measure` (`cg68k.cla:10196`), which performs
*complete* code generation of every reachable function — full
instruction selection, peephole, everything — throws the bytes away
keeping only the sizes, packs the segments, then generates everything
again for real (per-segment loop, `:10717+`). Since codegen is 67% of
the peak-memory profile (and likely a similar share of time), this
doubles the dominant phase.

**Fix:** Cache the measure pass's output and reuse it in the emit pass.
Full reuse is nontrivial — labels are segment-relative and constant
pools are per-segment subsets, so a function's bytes can legitimately
differ once its segment assignment is known — but a partial restore
path already exists for the single-segment case (peephole68k progress
notes, Task 13). Options in ascending effort: reuse bytes whenever a
function's segment context turns out identical (patching only
cross-segment call sites); compute sizes without materializing bytes (a
lighter size-only walk); or make emission segment-independent
(relocation entries) so one pass suffices. Even the first option
roughly halves codegen for small programs, which fit one segment
anyway.

### 1.8 Smaller, near-free

Each is minor alone; together they're a real constant factor, and most
are one-to-twenty-line changes.

- **`a68Comment` always runs** (`asm68k.cla:435`): listing-file comment
  strings — one per function, per parameter, per local, per global
  (`cg68k.cla:3816,3861,3882,1717`) — are built with concat+`numToStr`
  and stored in the arena even when `--listing` is off; downstream
  passes then skip over them (`peep68k.cla:38`). *Fix:* early-return
  when listing is disabled — one line.
- **`intern` triple-searches** (`lib.cla:14-20`, `map.cla:430`): it
  calls `has()`, then `get()`, then on a miss the insert binary-searches
  a third time. *Fix:* one positional lookup that returns "found or
  insertion point."
- **~116 `IStrConcat()`-style helpers** (`ir.cla:2861` etc.; 101 in
  lower.cla, 85 in shake.cla) re-intern a string literal on every call,
  and sit inside per-node dispatch chains. *Fix:* memoize each into a
  module int, reset by `irReset`.
- **`cgPackProgram` membership scans**
  (`cgIntListHas`, `cg68k.cla:399,304,10505-10537`; also `:9739`,
  `:3428`): segment pool bookkeeping tests "is this constant already in
  the segment?" by linear-scanning a growing int list — O(F·S·P·M) ≈
  10⁸ compares per compile. The `ponytail:` note at `cg68k.cla:298-303`
  ("one-time cost, not a hot path") no longer holds at self-host scale.
  *Fix:* a presence bitmap (`list of bool` indexed by pool entry)
  alongside the ordered list.
- **`irIsExtern` per call site** (`ir.cla:912,930`): lowering routes
  every call by scanning ~269 extern names with two 256 B copies per
  candidate. *Fix:* name-index→extern-index map populated at
  registration (`irRegisterExtern`, `ir.cla:837`).
- **String compares where both sides are interned ints**: record-field
  lookup, enum-member scans, widget/window member lookup all do
  `poolGet(field.nameIdx) == name`
  (`check.cla:4566-4602,3620,3173,3208,4196`) when comparing the two int
  indices directly is equivalent. *Fix:* compare `nameIdx == nameIdx`.
- **`scopeLookup` de-interns** (`types.cla:624-637`): symbol lookup
  converts the interned int back to a 256 B string via `poolGet`, then
  probes each scope level with `has()`+`get()` (two binary searches
  each). *Fix:* collapse to one probe; longer-term, int-keyed scope
  tables.
- **Type-name probes before every lookup**: `resolveType`
  (`check.cla:1660-1675`) and `checkIdentCall` (`:4790`) compare against
  `"int"`, `"bool"`, `"fixed"`… as string literals on every type
  reference and call site; `"file"` probes on every select/method call
  (`:4544,1574`). *Fix:* pre-intern the built-in names once at
  `checkReset` and compare ints.
- **`readOnlyPropName` re-checks the LHS** (`check.cla:3600` vs
  `:3645`): every `a.b = x` type-checks the receiver subtree twice —
  once in the main path, once inside the read-only-property check —
  doubling all per-node costs including the 1.2 map writes. *Fix:* pass
  the already-computed receiver type in as an argument.
- **Scopes never freed** (`types.cla:595-601`, `check.cla:3688`): every
  block pushes a `Scope` (3 Memory Manager allocations for its map) that
  stays alive until end of program — ~9,000 live blocks fragmenting the
  heap during checking. Block scopes are strictly LIFO. *Fix:* pop them
  on block exit, or keep a free list of recycled scope slots.
- **Arena clears by pop-loop** (`lex.cla:645`, `ast.cla:360-373`,
  `lib.cla:84-92`, `irReset` draining ~20 arenas): resets drain lists
  one `pop()` call at a time, each copying the element out.
  `rtListClear` (`list.cla:444`) exists and does it in O(1). *Fix:* use
  it.
- **`numToStr` builds backwards by prepend** (`lib.cla:128-141`): one
  string-prepend (256 B scratch + runtime calls) plus two
  software-divide loops per digit. *Fix:* fill a 12-byte buffer
  back-to-front, one `fromBytes` at the end. (Mostly moot once 1.2
  removes its hottest caller.)
- **`assignable` missing early-out** (`types.cla:396` vs `:462`): the
  type-compatibility check has no `src == dst` fast path even though
  `typesEqual` has one, and identical type indices are the common case.
  *Fix:* add the same one-line early return.
- **Parser token re-fetching** (`parse.cla:64-97`, 124 `curKind()`
  sites): `curKind()`/`curTok()` go through a bounds-checked
  `rt_list_at` call (and a 24-byte record copy) every time, and the
  expression-precedence chain calls them 12–20× per primary expression;
  `poolGet(t.nameIdx) == "app"` also runs per identifier primary
  (`parse.cla:570`). *Fix:* cache the current token's kind/line/col in
  globals, refreshed only in `advance()`; compare the `app` check by
  interned int.

### What is already right (verified — don't spend time here)

Assembly accumulation is a single linear encode pass into a doubling
`text` (`asm68k.cla:456-478`); label fixup is O(1) at bind time with no
relaxation (`asm68k.cla:250,718`); lists/text grow geometrically
(`list.cla:153`, `text.cla:159`); tokens carry interned ints, not text
(`tok.cla:92-99`); AST/IR are flat arenas with intrusive `next` chains
and O(1) appends; shake is a proper worklist BFS with a name map
(`shake.cla:79,277`); duplicate detection is map-based; **no
error/diagnostic string formatting on success paths anywhere** (all 16
parse.cla concat sites and all 29 `typeName` call sites verified inside
failure branches); one-error-then-abort parsing; host-side DisposePtr
415× fix (2026-08-03 phase) — though note that fix is **host-only**
(`runtime/host/rt_mem_host.inc:55-68`) and does nothing for the Mac lane.

---

## Layer 2 — systemic Clarus runtime/codegen costs (every program pays)

The language *design* is not inherently slow — the systemic problems are
three implementation decisions:

### 2.1 `string` is a 256-byte by-value Str255

Every parameter, return, list element, and map key slot copies 256 bytes
regardless of content (`cgSizeOf(KStr)` = 256, `cg68k.cla:1231`;
`cgPushArgs` `:7404`). `poolGet` (`lib.cla:37`) = ~512 B copied per call.
A one-string-arg call is ~140 instructions before the callee runs.
Remediation direction: pass strings by reference at the ABI level (the
runtime already takes `ptr` internally), or at minimum copy only
`len+1` bytes.

### 2.2 `map` is a sorted array of 256-byte key blocks, string keys only

`runtime/clarus/map.cla:165,204-222,422-446` (docs claim a hash table;
the implementation is not one). Lookup = log n *function-call* probes
(`rtStrCmp` byte loops), each midpoint a software divide; insert =
O(n) tail memmove of 256 B blocks via trap. This single fact caused most
of Layer 1 — the compiler needed int-keyed tables and had only string
maps. Remediation: hash table with pool-index keys (4 B/slot), or an
int-keyed map type; at minimum variable-length key storage.

### 2.3 Codegen calls out for everything

- **Every small copy is a `_BlockMoveData` A-line trap** — even a 4-byte
  `rtListPush` (`list.cla:302`; call shape `cgRegPassArgsAndTrap`,
  `cg68k.cla:7823`). An inline copy loop already exists
  (`cgBlockCopy`, `cg68k.cla:7341`) — use it below ~64 B.
- **`*`, `/`, `mod` are subroutine calls with no strength reduction**
  (`cgArith`, `cg68k.cla:4989-4995`): `cg_div32`/`cg_mod32` are
  32-iteration restoring-division loops (`:9578`). Paid per list index
  (`cgListAddrFromRegs` `:4604` multiplies by elemsize even when it's 4),
  per binary-search midpoint, per `numToStr` digit. Fold power-of-two
  cases to shifts/AND; use `MULU.W` when operands fit 16 bits.
- **`text[i]` is a JSR** (`cg68k.cla:6383` → `text.cla:509`) — the lexer
  reads every source byte through it, 2–3× per byte (`lex.cla:113,570`);
  `list[i]` is already inlined (`:4627`) — do the same for text.
- **ARC**: full JSR per retain/release with A1 save/restore
  (`cgEmitPtrRcCall`, `cg68k.cla:2660`), callee has a ≥8 KB frame; 2–3
  per counted store (`lower.cla:2301,2375`); container release is a deep
  O(n) per-element JSR walk (`cg68k.cla:3244`). Inline the
  `ADDQ.L #1,(An)` / `SUBQ.L #1,(An); BNE` fast paths.
- **`text` concat allocates per op**: `rtTextConcat`/`rtTextConcatSl`
  (`text.cla:321,372`) do `NewPtr` + `SetHandleSize` + `DisposePtr` each
  — real Memory Manager traps, ~393k `NewPtr` per emit (the 2026-08-03
  host profile's number; on Mac each is a real trap and can trigger
  unbounded heap compaction). Keep a grown-never-freed scratch buffer.
- **String concat**: per `+`, a 256 B stack scratch + `rtStrConcat`
  (2 trapped copies) + `rtStrStore` (a third) (`cg68k.cla:8425-8525`,
  `str.cla:52,71`). No string builder exists for `string` (only `text`
  has one). Fuse `+` chains into one multi-source concat.
- **Every function frame reserves ≥8 KB** (`cgTmpSlots`/`cgBigTmpSlots`,
  `cg68k.cla:835,888-889`) — the code's own comment (`:864-891`) says
  69% of functions use zero big-temp slots and totals 2.17 MB of stack
  across the compiler; per-function counters already exist
  (`cgStmtTmpNext`/`cgStmtBigTmpNext`) — size frames from them. Every
  local is also default-initialized at entry (a 128-iteration `CLR.W`
  loop per string local, `:2302,3946`).
- **`switch` lowers to a linear if-chain** for all subject types
  (`lower.cla:3688-3727`) — no jump tables; a language-wide constant
  factor (65-arm chains exist).
- **Allocation has no pooling**: container birth = `NewPtr` +
  1–2 `NewHandle` traps (`text.cla:211`, `list.cla:206`, `map.cla:334`);
  box structs are fixed 32/40/56 B — a size-class free list / bump arena
  removes 2–3 traps per birth and most fragmentation. 77% of live bytes
  are `list of X` handle boxes (task-1-report).

---

## Layer 3 — architecture and caching (the THINK C / MPW answer)

Pipeline today (per Compile… click, from fully reset state —
`macgui.cla:192-194`): expand/lex/parse user → check #1 (user
standalone) → **splice: re-read+re-lex+re-parse all ~12.9k runtime
lines** (`drive.cla:954,1020-1095`) → check #2 (whole program) → lower
(whole program) → shake → cg68Measure (emit all reachable once for
sizes) → pack segments → emit again per segment → write fork.
**Tree-shaking runs only before codegen** — check #2 and lower process
100% of the runtime regardless of use.

Ranked opportunities (payoff vs. effort), with coupling obstacles found:

1. **Shake before check#2/lower** — an AST-level name-reachability
   pre-pass so check/lower see only the reachable subset. Obstacles:
   existing shake is IR-based (`shake.cla:60-70`) so a new AST pass is
   needed; 17 runtime core names are rooted unconditionally (cprint
   default-init/RC glue — shake.cla header); decl order is load-bearing
   (`drive.cla:91-98`); `usesFileSaveLoad` is computed during check #1
   (`check.cla:1585`) and drives the `ser.cla` splice decision.
2. **Session-resident runtime across compiles** — the runtime chain is
   identical per click; stop resetting it. Obstacle: exactly the
   stale-index bug class already hit (`a259d0f`); requires auditing every
   index-keyed side table (note `irLayoutNeededByName`/
   `irRcWalkNeededByName`, `ir.cla:733,751`, are *already* never cleared
   — a latent cross-compile leak either way). First compile still pays.
3. **Bake the runtime pre-parsed (precompiled headers)** — serialize
   post-parse AST (or post-check symbols) at `--bake` time on the host,
   ship binary `'CLFS'` payloads instead of source. Kills ~5+ min of Mac
   lex time + parse + the 3.5 MB splice churn. Obstacles: AST arenas are
   index-based and reset per compile (`ast.cla:360`) so serialized
   indices need relocation; `curPathIdx` diagnostics stamps; the
   include-dedup "hoisting" path (`drive.cla:750-768,1119-1137`) can pull
   a user file into the runtime chain; splice set varies by program shape
   (UI / ser / 68k) so a few variants or per-module granularity.
4. **Single codegen pass** — reuse measure-pass bytes; single-segment
   restore special case partly exists. Obstacles: segment-relative
   labels (`cg68k.cla:1542`), per-segment pool subsets.
5. **Precompiled runtime object code + a real linker** — the only option
   removing runtime cost from *all* phases. Obstacles (why the runtime is
   recompiled today): `cgAssignGlobalOffsets` (`cg68k.cla:1672`) assigns
   A5 offsets whole-program; `cgAssignFinalJtSlots` (`:1571`) whole-
   program jump-table slots; `cgPackProgram` packs whole-program;
   `lowStrIdx` merges runtime+user string literals into one pool
   (`lower.cla:42`). Needs genuine relocation records. Notably **no
   monomorphization exists** (`list of X` is boxed) — the coupling is
   purely address/slot/pool assignment, so a linker is feasible.
6. **On-disk artifact cache** keyed by module name + checksum (forks are
   already deterministic — verified in `a259d0f`).
7. **Memory path to 8 MB**: shake-early (drops most runtime AST/IR
   work), retire the AST after lower (measured 10.7 MB —
   task-1-report:379), shrink `A68Item` (1.6), variable-length map keys,
   box-struct arena. Also: drop the unconditional core/str/text/list/map
   splice for programs referencing none of it (`drive.cla:1021-1033`
   hardcodes all five `true`; bounded win, blocked by shake's 17-name
   root set).

## Suggested sequencing

1. **Instrument first**: per-phase `TickCount()` build of ClarusC, one
   on-Mac run — confirm the memory-derived ranking (only lexing has a
   real Mac timing today).
2. **Quick-wins branch** (independent, host-verifiable by fork
   byte-identity + wall clock): 1.1 keywordKind, 1.2 exprTypeOf-family
   de-mapping, intern single-lookup + memoized `I*()`, 1.4 lookup
   maps + sizeof memo, 1.3 SCC, 1.8's one-liners (comment gating,
   `assignable` early-out, `rtListClear`). Expected **10–50× combined**.
3. **Codegen/runtime constants** (2.3: shifts, inline small copies,
   inline `text[i]`, inline RC fast paths, frame sizing) — compounds
   step 2 because the compiler itself is a Clarus program.
4. Re-measure on Mac; then decide how far up Layer 3 to climb.
   Shake-early + session-resident runtime may already give a pleasant
   edit-compile loop; separate compilation (3.5) is the endgame.

## Sources

Five parallel read-only reviews (front end; checker/symbols; backend;
runtime data structures; pipeline/caching) over `clarusc/*.cla`,
`runtime/clarus/*.cla`, `runtime/host/rt*.c/.inc`, plus the measured
profiles in `.superpowers/sdd/2026-08-08-mac-resident-clarusc/`
(task-1-report.md memory profile, task-11-report.md wall-clock data) and
`.superpowers/sdd/2026-08-08-peephole68k/task-9-report.md` (lex bench).
Host baseline (1.25 s / 142 MB) measured 2026-08-10 on
`build-run/clarusc-current`.
