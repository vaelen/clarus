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

`clarusc/tok.cla:104-139` is a chain of 33 `if nameIdx == intern("<kw>")`
tests, run for **every identifier** (`lex.cla:401`). Each `intern`
(`lib.cla:11-21`) is a 256-byte by-value string copy + `has()` binary
search + `get()` binary search (the same search twice), each probe a
`rtStrCmp` call, each midpoint a software divide (see 2.3). Estimated
**80–95% of all lex time** — essentially the entire 264 s bench number.

Fix: compare the already-computed `nameIdx` against 33 module-level int
consts interned once at startup. Expected ~10× on lexing from one small
change.

### 1.2 `exprTypeOf[numToStr(e)]` per expression node — CRITICAL

`check.cla:4848-4853`: every checked expression writes an int→int fact
into a **string-keyed map** keyed by `numToStr(e)`. Clarus maps are
sorted arrays with fixed 256-byte key blocks and an O(n) tail memmove per
insert (`runtime/clarus/map.cla:165,422`; host mirror
`rt_core.inc:600-697`). Decimal keys insert in effectively random order →
average tail n/2 → **O(E²)·260 bytes ≈ 40–100 GB of BlockMoveData for a
12k-line compile**, plus 6–10 MB of key storage in one handle.
`lower.cla` reads it back through `exprTypeGet` at 43 sites, paying
`numToStr` + binary search again.

Seven sibling tables use the same idiom: `funcSigByDecl`,
`funcScopeByDecl`/`funcRetByDecl` (`check.cla:2170,2234`),
`constUseIsStr`/`constUseInt`/`constUseStr` (`check.cla:4188-4192`),
`enumConstOf` (`check.cla:4202`); also `ir.cla:733,751` and
`lower.cla:3303` — so lowering/IR likely pay the same quadratic.

Fix: parallel `list of int` indexed by arena index (the
`declFileTab`/`setDeclFile` idiom in `lib.cla:104-118` already does
exactly this). Deletes the map, the `numToStr` calls, and the quadratic
in one edit.

### 1.3 `cgHeurOnCycle`: O(V²·E) whole-graph BFS — CRITICAL for cg68k

`cg68k.cla:1818`, driven per reachable function at `cg68k.cla:2070-2075`,
run **twice** (measure pass `:10328`, segment-1 pass `:10750`). The call
graph is two flat undeduped edge lists (`shake.cla:106-110`, one edge per
call site) with no adjacency index, so "successors of X" scans all E
edges; the BFS does that per dequeued node → O(V·E) per call, per
function → O(V²·E) ≈ 10¹⁰ edge visits at self-host scale. Also allocates
a fresh V-sized `visited` list per call. The author's own comment at
`cg68k.cla:1815-1817` names "the 5f Mac-resident self-compile is slow" as
the upgrade trigger — reached.

Fix: build a CSR/bucketed adjacency index once after `shakeProgram` and
answer "on a cycle" for all nodes with one Tarjan/Kosaraju SCC pass —
O(V+E) total. ~40 lines.

### 1.4 Codegen inner-loop linear scans with 256-byte string compares — VERY HIGH

All run twice (measure + emit):

- `cgFindGlobalOffset` (`cg68k.cla:4179`) — scans all `irGlobals` with
  `poolGet` (256 B copy) + `rtStrCmp` per element, called via `cgVarOff`
  (`:4204`) for **every variable reference**.
- `cgFindFrameOffset` (`cg68k.cla:4164`) — same shape over the frame.
- `cgFindRecordByName` (`cg68k.cla:1405`) / `cgFindSerdescLabel`
  (`:3447`) — scan all `irRecords`, two 256 B copies per element.
- `cgSizeOf`/`cgFieldOffset`/`cgRecordSize` (`cg68k.cla:1178,1428,1454`)
  — **unmemoized, recursive**, re-running `cgFindRecordByName` at every
  nesting level; `cgFieldRefAddr` (`:4469`) pays it per field access;
  54 `cgSizeOf` call sites. IRTypes are never interned (`ir.cla:1118`
  appends unconditionally), forcing structural compares.
- `findIRFuncIdxByName(intern("literal"))` (`ir.cla:1893`, linear scan of
  ~1,600 `irFuncs`) at **every emitted runtime call site** — 40 call
  sites in cg68k including `cgCallRuntime` (`:7736`), `cgEmitPtrRcCall`
  (`:2663`), `cgEmitAtCall` (`:3171`).

Fix: interned-name→index maps (globals, records, funcs) built once per
compile, per-function frame map, and two `list of int` memo tables for
size/align keyed by IRType index. ~50 lines total, trivial.

### 1.5 `cgIntr` string dispatch — HIGH

`cg68k.cla:6184`: `nm = poolGet(irIntrName(e))` (256 B copy) then up to
59 sequential `nm == "literal"` compares, plus 37 more in `cgIntrUi`
(which takes `nm` by value — another 256 B). 162 `== "` compares in
cg68k.cla overall, some on hotter paths (`:4361` per address computation,
`:7461` per call argument). The sibling backend proves the fix: cprint.cla
has exactly **one** string compare in 5,871 lines — it dispatches on
interned ints.

### 1.6 Peephole copies a 384-byte record 8–24× per instruction — HIGH

`A68Item` (`asm68k.cla:180-199`) carries `trapName: string(63)` +
`commentText: string(255)` + a refcounted `text` handle for all item
kinds → ~384 B per whole-record copy, plus an RC op each time.
`peep68k.cla` copies at `:111,176,216,262` (per pass), `:78,141` (probe
helpers), `:50` (`peepKill` copies to flip one field); 4 passes to
fixpoint, ≥2 sweeps typical, ×2 (measure+emit) → ~10 KB memcpy per
emitted instruction. The window scan itself is correctly bounded — the
cost is the record copy, not the scan.

Fix: move `trapName`/`commentText`/`dataText` into side tables; shrink
`A68Item` to ~48 B of ints; read fields in place instead of copying.

### 1.7 Every function code-generated twice — HIGH

`cg68Measure` (`cg68k.cla:10196`) emits every reachable function purely
to size it for segment packing; the per-segment loop (`:10717+`) emits
everything again — ~2× the phase that is 67% of peak. Labels/fixups are
segment-relative and pools are per-segment, so full reuse is nontrivial,
but the single-segment case already has a partial restore path
(peephole68k progress notes, Task 13).

### 1.8 Smaller, near-free

- `a68Comment` (`asm68k.cla:435`) builds+stores comment strings
  unconditionally even without `--listing`; built with concat+`numToStr`
  per function/param/local/global (`cg68k.cla:3816,3861,3882,1717`).
  **1-line gate.**
- `intern` does `has()` then `get()` then a third search on insert
  (`lib.cla:14-20`, `map.cla:430`) — collapse to one positional lookup.
- ~116 `IStrConcat()`-style helpers (`ir.cla:2861` etc., 101 in
  lower.cla, 85 in shake.cla) re-intern a literal per call; memoize each
  into a module int reset by `irReset`.
- `cgPackProgram` set-membership via `cgIntListHas` linear scans
  (`cg68k.cla:399,304,10505-10537`; also `:9739`, `:3428`) — O(F·S·P·M)
  ≈ 10⁸ compares; replace with presence bitmaps. The `ponytail:` note at
  `cg68k.cla:298-303` ("one-time cost, not a hot path") no longer holds
  at self-host scale.
- `irIsExtern`/`irExternLookup` (`ir.cla:912,930`) — per-call-site scan
  of ~269 externs with two 256 B copies per element during lowering.
- Field/member lookups compare via `poolGet(...) == name` when **both
  sides are already interned ints** (`check.cla:4566-4602,3620,3173,
  3208,4196`) — compare `nameIdx == nameIdx`.
- `scopeLookup` (`types.cla:624-637`) de-interns the symbol to a 256 B
  string then does `has`+`get` (two searches) per scope level; collapse
  probes, int-key the scope table.
- Literal-name compares ahead of every lookup: `resolveType`
  (`check.cla:1660-1675`), `checkIdentCall` (`:4790`), `"file"` probes
  (`:4544,1574`) — pre-intern at `checkReset`.
- `readOnlyPropName` re-type-checks the LHS receiver subtree on every
  assignment (`check.cla:3600` vs `:3645`), doubling `exprTypeOf` writes
  for `a.b = …`.
- Scopes are never popped (`types.cla:595-601`, `check.cla:3688`) — ~3
  Memory Manager allocations per block, ~9,000 live blocks fragmenting
  the heap through the whole check phase; block scopes are strictly LIFO
  and could be freed/reused.
- Arena clears via `while n>0 { pop() }` loops (`lex.cla:645`,
  `ast.cla:360-373`, `lib.cla:84-92`, `irReset` draining ~20 arenas) —
  `rtListClear` (`list.cla:444`) exists and is unused there.
- `numToStr` (`lib.cla:128-141`) builds by per-digit string *prepend*
  (256 B scratch + runtime calls per digit) and pays two software-divide
  loops per digit; fill a 12-byte buffer backwards.
- `assignable` lacks the `src == dst` early-out `typesEqual` has
  (`types.cla:396` vs `:462`).
- Parser: `curTok`/`curKind` re-fetch through `rt_list_at` 12–20× per
  primary expression (`parse.cla:64-97`, 124 `curKind()` sites); cache
  the current token in globals. `poolGet(t.nameIdx) == "app"` runs per
  identifier primary (`parse.cla:570`).

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
