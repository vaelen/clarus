# SE memory program: ClarusC.APPL in 4 MB (program design, 2026-09-27)

Status: **program design, approved 2026-09-27. No wave has started.**
This is the umbrella document for a multi-wave program. Each wave gets
its own spec (`docs/superpowers/specs/`) and plan
(`docs/superpowers/plans/`) when it starts. This document holds
everything a fresh session needs to begin any wave: the goal, the
decisions already made (don't re-argue them), the environment, the
rules, and each wave's scope, starting points and exit criteria.

Companion document: `2026-09-27-se-memory-footprint-findings.md` (same
directory) is the measured analysis this design is built on. Section 1
below summarizes what matters from it.

## 0. How to start a wave in a new session

1. Read `CLAUDE.md`, this document, then the findings document.
2. Check the **Status** table (§9) for which wave is next and whether
   its prerequisites have merged.
3. Brainstorm that wave only, using §6's entry for it as the brief.
   Decisions listed as *decided* are inputs, not questions. *Open for
   the spec* items are the questions to settle.
4. Write the wave spec, then the plan. The plan must follow §5's
   process rules: Opus subagents, parallel tracks, host-only gates per
   task, and emulators only at the end of the wave.
5. At wave close: run the end-of-wave gates (§5.3), record the numbers
   in §9, move the wave's ROADMAP entry to `docs/HISTORY.md`, and
   update this document's status line.

## 1. Goal and baseline

**Goal.** `ClarusC.APPL`, the Clarus compiler running on the Mac,
compiles a small program (acceptance program: `examples/bookmarks.cla`,
122 lines, a UI app) on a **Macintosh SE with 4 MB under System 6.0.8,
launched single-app (no MultiFinder)**. "Done" means Waves 0–5 are
merged and that compile succeeds on the acceptance machine within its
measured budget, with the host memory gate enforcing the budget in CI.

**Baseline** (measured 2026-09-27 on the host; details in the findings
doc):

| Item                                                         |                                               Today |
|--------------------------------------------------------------|----------------------------------------------------:|
| Peak live heap, `bookmarks.cla`, from source                 |                                             14.0 MB |
| Peak live heap, `bookmarks.cla`, `--rtbake` (ClarusC's path) |                                             11.5 MB |
| … live before the user file is even parsed (`--rtbake`)      |                                              7.6 MB |
| ClarusC.APPL CODE (47 segments)                              | 1.56 MB (~37% is duplicated `cg_free_globals` glue) |
| `__clir_bake_68k__` resource (read, copied, never released)  |                                             1.92 MB |
| Stack reserve (`SetApplLimit`)                               |                                              729 KB |
| Budget on the SE (to be measured in Wave 0)                  |                                   ~3.0–3.3 MB total |

A 6-line program costs 10 MB, because every compile checks and lowers
the entire ~13k-line runtime and only then tree-shakes. Nothing in the
language forces whole-program work: there is no overloading, no global
type inference and no monomorphization. The couplings are all in the
implementation (findings §2).

**Already proven (findings §3).** Three small scratch-copy changes were
prototyped. The output stayed byte-identical on five examples and on the
CLIR bake:
- from-source peak: 14.0 → 8.4 MB;
- `--rtbake` peak: 11.5 → 9.5 MB, with codegen running in ~5 MB.

§6's Wave 1 entry gives the exact changes.

## 2. Decision log

Every decision below was made with Andrew on 2026-09-27. Each wave's
spec takes them as given.

| #   | Decision                                                                                                                                                                                                                                                                                                                                                                                                                                              | Why                                                                                                                                                        |
|-----|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| D1  | "Done" = Waves 0–5 plus an on-target compile of `bookmarks.cla` on the SE. Wave 6 (separate compilation + linker) is a **go/no-go decided after Wave 5**.                                                                                                                                                                                                                                                                                             | The memory goal is reachable without a linker (findings §4, Wave 3 → ~1 MB heap).                                                                          |
| D2  | **Memory wins over speed.** Compile #2 in a ClarusC session may get slower until Wave 4 (bake staging copies are freed). The host perfgate must not regress; on-target compile time is recorded but not gated.                                                                                                                                                                                                                                        | The ~3.2 MB of staging kept for a fast second compile is unaffordable on the SE.                                                                           |
| D3  | New scalar types **`uint8`, `int16`, `uint16`**. No 32-bit unsigned type (`uint`) for now; record it in `docs/FUTURE.md`.                                                                                                                                                                                                                                                                                                                             | `uint16` is cheap once `int16` exists. `uint` alone needs unsigned compares and divide, a new `rtUIntToStr`, literal-range work and C-lane mixing hazards. |
| D4  | **Mixing rule A**: implicit widening of `uint8`/`int16`/`uint16` → `int`, and arithmetic happens at 32 bits. Narrowing is explicit via `uint8(x)`/`int16(x)`/`uint16(x)` and **truncates** (like `char(i)` today). In-range literals are accepted wherever a narrow type is expected.                                                                                                                                                                 | Least noise without silent truncation. It also matches codegen: widen at load, truncate only at an explicit conversion.                                    |
| D5  | **Extern boundary rule**: at an `external func`/`= ptr` argument and an `extern record` field store, an `int` value is accepted for a narrow-typed slot and truncated, exactly as today's marshaling does. Everywhere else narrowing stays explicit.                                                                                                                                                                                                  | This keeps the ~317 existing `word` declarations' call sites compiling unchanged after the rename (D6).                                                    |
| D6  | The contextual extern types **`word` → `int16` and `byte` → `uint8`** are renamed repo-wide (`.cla`, the language reference, the cookbook, fixtures), then the old spellings are **removed**, with no aliases.                                                                                                                                                                                                                                        | Andrew: one set of integer names, not Toolbox terminology drifting from the language's. There are no external users (`m68k-bbs` has zero uses).            |
| D7  | **Enums become 2 bytes on the native lane**, as the language reference (`docs/clarus-language-reference.md` ~l.157, ~l.314) already specifies. Today `cgSizeOfUncached` stores them as 4 (`clarusc/cg68k.cla` ~l.1939).                                                                                                                                                                                                                               | Spec conformance, and it shares the 16-bit storage plumbing with `int16`.                                                                                  |
| D8  | **Serializer v2**: `file.save` writes format version 2 with **2-byte enum fields**. `file.load` accepts v1 (4-byte enums) and v2. One deliberate re-pin of the frozen CLRD goldens (`CLRD_BLESS=1`), plus a new frozen **v1** fixture proving old files still load. New narrow field types take their natural widths (1/2/2 bytes). No other format guard is needed: the file carries no type codes, which live in the program's compiled descriptor. | The only real users are `examples/bookmarks.cla` (its record has an enum field) and the test suite.                                                        |
| D9  | A user-facing **`segment "name"` directive** plus runtime segment unloading, with ClarusC.APPL as its first user. With no directive, packing stays exactly as today.                                                                                                                                                                                                                                                                                  | Plus/SE apps need overlays as much as the compiler does (the `#pragma segment` idiom).                                                                     |
| D10 | **`list`/`map`/`text` `.release()` and `.shrink()`** join the language. `release()` drops storage back to canonical empty. `shrink()` trims capacity to count. `clear()` keeps its current keep-capacity meaning, now documented.                                                                                                                                                                                                                     | Today the only way to free a container is to reassign a fresh one, and `astReset()` gets that wrong (`.clear()` frees nothing).                            |
| D11 | **Acceptance machine**: the Snow SE (4 MB, System 6.0.8) with ClarusC launched **single-app via boot-block autostart**, no MultiFinder. **Measurement machine**: the Snow Mac IIcx (128 MB, System 7.1, 32-bit addressing), where ClarusC runs today.                                                                                                                                                                                                 | Andrew's choice. Single-app gives ClarusC all free RAM.                                                                                                    |
| D12 | Process: **Opus** for implementation and review; plans **maximize parallelism**; **emulator runs only at the end of each wave** (Wave 0 excepted).                                                                                                                                                                                                                                                                                                    | Andrew: fewer follow-up fixes, and faster implementation.                                                                                                  |

## 3. Environment (Linux, as of 2026-09-27)

Everything here is also in `CLAUDE.md`. The emulator infrastructure
lives on branch `emulator-linux` (see §9: it must be merged before
Wave 0 starts).

- **Display.** Shells on this machine usually have no `DISPLAY`. Boots
  need `export DISPLAY=:1 XAUTHORITY=/run/user/1000/gdm/Xauthority`.
- **Snow** (`snow/clarus-snow`):
  - `snow/system6`: SE, 4 MB, System 6.0.8 (`system6.snoww`,
    `system6.img`). SCSI 1 is `clarus.img` (volume `Clarus`), SCSI 2 is
    Ethernet; LocalTalk comes from `--serial-bridge-b localtalk`.
  - `snow/system7`: Mac IIcx, 128 MB, System 7.1, `rominator.rom`
    (32-bit clean), 8•24 display card, `system7.pram` (32-bit
    addressing), `start_fastforward: true`. SCSI 1 is `clarus.img`,
    SCSI 2 is Ethernet.
  - Test boots go through `tests/lib_snow.sh`: `snow_disk [6|7]` clones
    the template's disks, ROM paths and PRAM into `$WORK/snow`.
    `SNOW_SYSTEM` picks the machine; the default is 6, and the ClarusC
    scripts use 7. Boots use a private serial port.
  - `docs/HISTORY.md` records that fast-forward *at boot* once hung the
    old Mac II launch path. The `emulator-linux` work checks this on
    the current Snow; see its report or the lane's comments.
- **Mini vMac** (`macplus/macplus`, `macplus2/macplus2`): Linux
  LocalTalk builds, Mac Plus 4 MB, System 6.0.8. They are driven by
  LaunchAPPL (upstream Retro68, which includes `--system-extra-file`)
  with every option passed explicitly by `tests/lib_mac.sh`.
- **Process safety (non-negotiable).** Andrew runs his own emulators
  beside test boots: the BBS (`~/bbs/snowemu`), `~/mac/macse`,
  `snow/system6`/`system7` themselves, and `./macplus/macplus`.
  - Never `pgrep`/`pkill` an emulator by name.
  - Stop only pids you launched, or processes whose command line
    contains your own `$WORK` path.
  - Never boot or write the pristine images in `snow/`, `macplus/` or
    `macplus2/`.
- **The LocalTalk network is real and routed** (a router on net 6801,
  many zones and foreign nodes). Tests use per-run-unique NBP names and
  never assert exact zone lists or node counts.
- **Grep hygiene.** `grep` in this shell is ugrep, which silently skips
  the MacRoman files `clarusc/lex.cla` and `clarusc/lib.cla`. Use
  `/usr/bin/grep -a` for "who reads X" audits.

## 4. Measurement method (the Wave 0 starting point)

The findings were produced with a throwaway instrumented build. Wave 0
turns it into a tool. The recipe:

1. **Instrumented memory shim.** Copy `runtime/host/`. In
   `rt_mem_host.inc` add `live`/`peak`/`blocks`/`allocs` counters:
   - `+size` in `rt_mem_alloc_block`;
   - `±delta` in both `rt_mem_set_handle_size` paths (relocating grow
     and locked in-place shrink);
   - `-size` in `DisposeHandle`/`DisposePtr`.

   Add an `rtm_dump()` that prints them, plus a per-`tag` live-bytes
   histogram (tags are runtime `file:line`, e.g. `rt_ext_host.inc:244`
   is list data handles). Reset `peak` after each dump so every dump
   shows the peak within the phase just ended.
2. **Phase hook.** Call `rtm_dump()` from `rt_ext_TickCount`
   (`runtime/host/rt_ext_host.inc` ~l.371). The compiler calls
   `TickCount()` exactly at each `driveProgressPhase` mark
   (`clarusc/drive.cla` ~l.860) during `emit68k` compiles.
3. **Global census.** Scan the generated `clarusc/clarusc.c` for
   `static rt_list * cv_X;` / `rt_map` / `rt_text` globals. Generate an
   `rtm_census()` that prints each one's handle size, count, elemsize
   and cap, using local mirrors of `struct rt_list` and `struct rt_map`
   from `runtime/host/rt_core.inc` (~l.495, ~l.626). Call it from
   `rtm_dump()`.
4. **Runs.** `clarusc-instrumented emit68k --rtdir runtime/clarus/
   [--rtbake FILE.clir] -o OUT.bin examples/bookmarks.cla`, where the
   CLIR comes from `clarusc --bake-ir --lane 68k --rtdir
   runtime/clarus/ -o FILE.clir`.

**Accounting caveat.** The host is 64-bit, so pointer and handle fields
are 8 bytes where the 68k has 4, container boxes are sized for 8-byte
pointers, and Memory Manager block headers are absent. The compiler's
big arenas are int-only records, identical on both lanes. The Wave 0
gate must report **68k-equivalent bytes**: count box and handle
payloads at native widths, and add a per-block header estimate (the
spec decides the exact model).

## 5. Rules every wave follows

### 5.1 Process

- Each wave follows brainstorm → spec → plan →
  superpowers:subagent-driven-development, on its own branch off `main`.
  A big wave may split into several spec/plan pairs.
- **Opus** (`model: opus`) does implementation and review; `haiku` only
  does purely mechanical batch edits. The top-level session designs,
  dispatches, reviews and integrates; it does not write implementation
  code.
- **Parallel plans.** Group tasks into independent tracks that touch
  disjoint files and dispatch them concurrently. Tracks that would
  collide go in separate git worktrees and are merged back by the
  controller. Serialization points run alone after the parallel tracks
  land: golden reblesses, `clarusc/clarusc.c` snapshot regenerations,
  and anything that moves every `testdata/cg68k/*.s` golden.
- `main` stays green. A wave merges only when Andrew asks.

### 5.2 Per-task gates (host only)

- T1: `scripts/test-task.sh`, **without** `--smoke`.
- The memory gate (from Wave 0 onward): `make test T=memgate/`.
- No emulator boots during implementation (Wave 0 excepted).

### 5.3 End-of-wave gates

- T2 in full on this machine: `scripts/test-merge.sh`, meaning T1,
  perfgate, `selfhost/`, `mactest/` at `-j1` (Mini vMac and Snow,
  LocalTalk and MacTCP included), and the `bake/` full-corpus sweep.
- `CLARUS_SNOW_TESTS=1 make test T=mactest/snow/clarusc_bake` on the
  Mac IIcx, whenever the wave touched `clarusc/bake.cla` or
  `clarusc/macgui.cla`.
- The wave's on-target measurement (§7) on the Mac IIcx, plus its
  on-target exit criterion, if any.

### 5.4 Output policy

- Every plan task is labeled **byte-identical** or **output-changing**.
- **Byte-identical tasks** leave every golden untouched: the
  `testdata/cg68k/*.s`, emitui, `bake/` byte-identity (the `--rtbake`
  twins and the full sweep) and `selfhost/` oracles.
- **Output-changing tasks** are small and isolated. Their rebless is a
  separate step with a written reason per golden family.
- Frozen oracles (the CLRD goldens, the frozen UI scenarios) are
  re-pinned only by a task that exists to do exactly that.

### 5.5 Memory ratchet

`tests/memgate/` (built in Wave 0) measures peak live heap in
68k-equivalent bytes:
- **primary:** `bookmarks.cla` compiled with `--rtbake`;
- **secondary:** `bookmarks.cla` from source, and `hello-mac.cla`.

Each wave commits a lower budget, and no later change may exceed it:

| After wave | `bookmarks --rtbake` peak | Other exit criterion                                                             |
|------------|--------------------------:|----------------------------------------------------------------------------------|
| 0          |       baseline (~11.5 MB) | SE app budget measured and recorded; Mac IIcx per-phase baseline recorded        |
| 1          |                    ≤ 6 MB | every task byte-identical                                                        |
| 2          |                    ≤ 4 MB |                                                                                  |
| 3          |                  ≤ 3.5 MB | serializer writes v2, loads v1                                                   |
| 4          |                  ≤ 1.2 MB | runtime library read with `readAt`; no whole-resource read                       |
| 5          |      within the SE budget | ClarusC compiles `bookmarks.cla` on the SE; `snow/clarusc_bake` passes on the SE |

The budgets are targets. A wave's spec may revise its own number with a
measured justification. It may not remove the ratchet.

### 5.6 Documentation

- Language changes update `docs/clarus-language-reference.md` in the
  same task. Toolbox-facing changes also update
  `docs/clarus-toolbox-cookbook.md`.
- At close: ROADMAP → `docs/HISTORY.md`; debt → `docs/TODO.md`;
  deferrals → `docs/FUTURE.md`.
- CLAUDE.md is updated wherever a documented fact changes. That covers
  the hand-maintained suite case counts (5 places each), the standing
  test rules, and the environment.

## 6. The waves

File and line anchors are as of `main` at `c960bb96`. Re-verify them
before relying on them.

### Wave 0: Measurement

**Scope**
- `tests/memgate/`: the §4 instrumentation turned into a supported
  host build mode (e.g. `CLARUS_MEM_PEAK=1` in `rt_mem_host.inc`), with
  68k-equivalent accounting, per-phase output and a budget check.
  Prefer an instrumented runtime linked into a test-local compiler
  build over editing the frozen `tests/lib.sh`.
- ClarusC.APPL on-target probes, reported through its per-phase
  progress lines (`driveProgressPhase`):
  - `FreeMem`/`MaxBlock` after each phase;
  - a stack high-water probe: paint the stack region at startup with a
    pattern, and after a compile scan for the deepest overwritten word.
    The low-memory globals `CurStackBase` (0x908) and `ApplLimit`
    (0x130) bound the region.
- On-target runs:
  - **SE app budget:** boot the System 6 SE single-app with a small
    probe app that reports `FreeMem`/`MaxBlock` and `ApplLimit`, and
    record the free memory.
  - **Mac IIcx baseline:** run ClarusC compiling `bookmarks.cla` with
    the probes, and record the per-phase heap and stack high-water.
- Record every number in §9 and in the wave's HISTORY entry.

**Decided:** D11 (the machines). The gate budget starts at the measured
baseline.

**Open for the spec**
- The block-header model for 68k-equivalent accounting (an SE's 24-bit
  Memory Manager has 8-byte block headers plus a 4-byte master pointer
  per handle).
- Whether the probe lines are always on or behind a flag. They must not
  disturb the C `emit` lane's byte-silence (see `drive.cla`'s
  instrumentation comment ~l.740).

**Exit:** gate in T1 and green at baseline; SE budget and Mac IIcx
baseline recorded.

### Wave 1: Lifetimes

All byte-identical except the `.release()`/`.shrink()` language
addition, which is additive.

**Scope**
- **D10: `.release()`/`.shrink()`** for `list`, `map`/`intmap`/
  `sortedmap` and `text`, on both lanes. Documented in the reference,
  with core-suite cases. **Remember the 5-place case-count rule.**
- **Free the AST + tokens after lowering.** Prototype A: after
  `lowerProgram` succeeds in `driveCompile` (`drive.cla` ~l.2536 bake
  path and ~l.2556 source path), release `exprs`/`stmts`/`decls`/
  `typeExprs` (`ast.cla` ~l.385) and `toks` (`lex.cla:41`), plus
  `lexSrc` (`lex.cla:19`). Keep `declFileTab` only under `--bake-ir`
  (`bake.cla` ~l.1504–1551 reads it). Verified: nothing downstream of
  lowering reads the AST.
- **Free the checker tables after lowering** (`symbols`, `scopes`,
  `funcSigs`, `typeArena`, and the check-only maps `funcScopeByDecl`,
  `funcRetByDecl`, `funcSigByDecl`, `xrecSizeByName`,
  `xrecFirstDeclByName`, `externFirstDeclByName`,
  `constFirstDeclByName`, `recFieldsHeadByName`) unless `--bake-ir` is
  set. The only `cg68k.cla` hit is a string in an error message
  (~l.5618). Lower reads some of these: free them **after**
  `lowerProgram`, not after check.
- **Per-function `a68Items` reset in `cg68Measure`.** Prototype B: in
  the per-function loop (`cg68k.cla` ~l.14288–14328), after
  `cgFuncSize.add(a68SizeSoFar() - before)`, clear `a68Items`,
  `a68CommentTexts` and `a68DataTexts`. Do NOT clear `a68LabelAddr`/
  `a68LabelDefined`/`a68Pc`, because cross-function label ids must stay
  valid. Apply the same per-entry reset inside `cgEmitPoolsBody`'s
  measure loop. `peepFunc(startIdx)` works on the current function's
  range, so a reset list is fine.
- **Free the bake staging + blob after install.** Prototype C: release
  `bkLdIr{Types,Stmts,Exprs,Locals}`, `bkLdStrPool`,
  `bkLoaded{FuncSigs,Symbols,Scopes,DeclFileTab}` (`bake.cla`
  ~l.2243–2335) and `rtbakeBytes` (`drive.cla:98`). **Check every
  reader first.** `bkLdObjFuncSize` and the other `bkLdObj*` tables
  ARE read later by `cg68Measure` (`cg68k.cla` ~l.14302–14311), so
  keep those. Per D2, compile #2 in a ClarusC session re-decodes the
  bake. Adjust `macgui.cla`'s reuse path (`drive.cla` ~l.2064
  comment, `bkParsedValid`) so it re-parses instead of cloning freed
  staging.
- **Install by move, not `.clone()`** (`bkInstallArenas`, `bake.cla`
  ~l.4303–4344; `bkInstallPool` ~l.4076–4092). This removes the
  install-time peak, which is where the bake-path peak sits after
  prototype C (9.5 MB).
- **Parse CheckerSymbols only under `--testapi`** (`bake.cla` ~l.3649,
  inside `bkLoadSections`; its consumer at ~l.4598 is already gated).

**Prototype code** (scratch-verified byte-identical). Wave 1 replaces
the reassignment idiom with `.release()`:

```
func astFreeAll() {
    var e: list of ExprNode
    var st: list of StmtNode
    var d: list of DeclNode
    var t: list of TypeExpr
    var tk: list of Token
    exprs = e
    stmts = st
    decls = d
    typeExprs = t
    toks = tk
}
// cg68Measure, per-function branch, after cgFuncSize.add(...):
a68Items.clear()
a68CommentTexts.clear()
a68DataTexts.clear()
```

**Open for the spec**
- The `.release()`/`.shrink()` semantics on a borrowed or aliased
  container.
- How compile #2's re-decode is triggered.
- Whether the host `emit` lane gets the same frees. It should, since
  both lanes share `driveCompile`.

**Exit:** `bookmarks --rtbake` ≤ 6 MB, and every golden unchanged
except the new suite cases.

### Wave 2: Representation

**Scope**
- **Compact string pool.** `strPool: list of string` spends 256 B per
  entry (`lib.cla:7`), about 1 MB. Replace it with one byte blob plus
  a `list of int` of offsets, keeping the `intern`/`poolGet`/
  `internText` contracts (`lib.cla:11–42`). The bake's pool section
  and `bkLdStrPool` follow. Expected saving: ~1.0 MB, plus ~1.0 MB of
  staging.
- **Per-function emit → encode → discard** in the per-segment emit loop
  (`cg68ProgramFork`, `cg68k.cla` ~l.15716). Encode each function's
  items to bytes plus holes right away, using the existing
  `cgObjRuns`/`cgObjHoles` capture shape (`cg68k.cla` ~l.14802–14836;
  `cgObjDumpSegment` ~l.15136, whose byte-count assertion at ~l.15209
  is the oracle). Keep only that, and drop the items. This bounds
  `a68Items` to one function instead of one segment (~15k items,
  ~1.1 MB).
- **Pre-size** big arenas with `reserve()` from known counts, instead of
  doubling. A relocating grow needs old + new contiguous at once.
- **68k-correct container box sizes** via `_68k.cla` companions: list
  40 → 20 B, text 32 → 16 B, map 112 → 52 B, sortedmap 56 → 28 B
  (`list.cla:196`, `text.cla:198`, `map.cla:580`, `sortedmap.cla:208`).
  This is output-changing (box-size immediates), so it gets its own
  isolated rebless task.
- **`MoreMasters` count** sized for ~10k live blocks. Today only 256
  master pointers are preallocated (`native.cla` ~l.1416–1432).
- **Flat `cgObjRuns`**: one byte pool plus (offset, len), instead of
  `list of text`, which has ~4,400 handles at bookmarks scale.

**Open for the spec**
- The `MoreMasters` sizing policy (static count vs derived).
- Whether `sortedmap`'s 256-byte key blocks (`sortedmap.cla:46–69`)
  matter to the compiler. Measure first.

**Exit:** `bookmarks --rtbake` ≤ 4 MB.

### Wave 3: Narrow scalars

Output-changing. Decided: D3–D8.

**Scope and starting facts** (from the 2026-09-27 surveys)
- **Type representation.** Add a **width/signedness tag on the existing
  int kind** rather than new kinds: `TyInt` in `types.cla` ~l.34 and
  `KInt` in `ir.cla` ~l.98. Reuse the `n`/aux field the way `TyStr`
  stores its capacity. Most checker sites use a single int-kind guard
  and need no change. About a dozen need per-width rules:
  - result type (`checkArith` ~`check.cla:5578`);
  - assignability (`assignable`, `types.cla:442`, whose same-kind
    fallthrough at ~l.495 must compare widths);
  - literal range;
  - `>>` and negation (`checkUnary` ~l.5516);
  - `string()` and the conversions (~l.5990–6030);
  - UI field binding (`check.cla` ~l.4155);
  - the extern and callback gates.

  `lower.cla` has only 3 int-specific sites (~l.402, 1280, 2186).
- **Codegen (cg68k).**
  - Sub-word handling is already generalized for `bool`/`char`:
    1-byte fields and array elements (`cgRecFieldSizeOf`,
    `cgArrElemStride`), 2-byte frame slots (`cgSlotSizeOf`).
  - `uint8` clones the `char` path.
  - `int16`/`uint16` need a new `sz==2` branch at about 6 load, store,
    push and return sites: `cgLoadVar` ~l.6760, `cgStoreScalarVar`
    ~l.6780, `cgLoadFieldScalar` ~l.6800, `cgEmitStoreScalarAny`
    ~l.6829, `cgPushArgs` ~l.10572, and the returns. Loads use
    `EXT.W`/`EXT.L` for `int16` and zero-extend for `uint16`.
  - After a widening load, 32-bit arithmetic, compares and shifts are
    already correct for all three types. No unsigned compare or divide
    is needed without `uint`.
  - `peep68k.cla`'s patterns are size-1/size-4 only. New word shapes
    simply don't match them, which is safe.
- **C lane.** `cpCType` (`cprint.cla` ~l.940) emits
  `int16_t`/`uint16_t`/`uint8_t`, and C promotion keeps arithmetic
  correct.
- **Enums → 2 bytes** (D7). This changes `cgSizeOfUncached`'s `KEnum`
  case (~l.1939) and the comment at ~l.4876. It is an output-changing
  rebless of most native goldens, done as an isolated task after the
  `sz==2` plumbing exists.
- **Serializer** (D8). `runtime/clarus/ser.cla`:
  - the header version byte goes 1 → 2;
  - the ENUM field is read and written as 2 bytes in memory, and as 2
    bytes on disk in v2;
  - the loader accepts v1's 4-byte enums;
  - new `RtFt*` codes for `uint8`/`int16`/`uint16` go in at the three
    producers (`uibFieldTypeNum` `uiblob.cla` ~l.282, `cpSerFieldRow`
    in `cprint.cla`, `cgBuildSerdescInts` `cg68k.cla` ~l.4968) and the
    one consumer (`ser.cla` ~l.98–103, 132, ~366);
  - `uidesc.cla` ~l.64–67 shares the numbering.
- **Bake.** `IRKind` is serialized as a raw ordinal (`bake.cla` ~l.828,
  ~l.2543). Append new kinds at the end of the enum; tags on the
  existing `KInt` don't change ordinals at all.
- **Rename** (D5, D6), in this order:
  1. The new types are accepted at extern and callback positions, with
     marshaling identical to `word`/`byte` (`KWord` in `ir.cla`
     ~l.142–155, used only by the extern registry; `TxWord`/`TxByte`
     in `ast.cla` ~l.292–315, `parse.cla` ~l.1359/1682, `check.cla`
     ~l.2492–2525).
  2. Mechanical rename across ~317 `word` and ~51 `byte` uses in the
     `.cla` files, ~200 doc mentions, and ~10 diagnostic fixtures.
  3. The old spellings are removed.

  Expected: every compiled program is byte-identical across the rename
  except ClarusC.APPL, which bakes source text.
- **Compiler arenas adopt narrow fields** where the value range allows,
  e.g. AST/IR `kind`, `line`/`col`, and `A68Item`'s op/size/mode
  fields. Measure before and after.
- Record `uint` (32-bit unsigned) in `docs/FUTURE.md` with the cost
  list from D3.

**Open for the spec**
- Exact literal typing: an untyped literal adopting the narrow target
  type, and the diagnostic wording for out-of-range literals.
- Whether `text.wordAt`/`wordAtLE` should return `uint16`. The spec
  already says 0–65535; under D4 the change is compatible.
- Which compiler records narrow, and by how much.
- The UI binding rules for narrow fields in forms.

**Exit:** `bookmarks --rtbake` ≤ 3.5 MB; v2 save and v1 load proven by
the core suite and the CLRD goldens; no `word`/`byte` spelling remains.

### Wave 4: Lazy runtime library

Output-changing: a new bake/library format. This is the decisive wave.

**Scope**
- **Call-graph summary section** (per function: outgoing edges, plus
  the unconditional shake roots, `shake.cla` ~l.34–70). Shake runs
  over the summary **before** any IR or object code loads.
- **Per-function object index** into the ObjCode section
  (`bkWriteObjCode`, `bake.cla` ~l.1609–1684, already frames bytes per
  function). Only reachable functions' bytes and holes are pasted.
  Runtime functions that bake cleanly need **no IR at all**. Only
  functions tainted at bake time (~21) and user code go through lower
  and cg.
- **On-demand checker interface.** A symbol lookup miss fetches that
  name's signature, record or enum from an index, instead of installing
  ~5,300 symbols up front. `bkInstallCheckerSymbolsForTestapi`
  (`bake.cla` ~l.4598–4620) proves the data shape.
- **The library is a data-fork file read with `filehandle.readAt`**,
  not a resource. That makes it System 6-safe and removes the
  unreleasable 1.9 MB resource read in `natReadResource`
  (`native.cla` ~l.1099–1130, which deliberately never calls
  `ReleaseResource` after a hardware hang). Resident library data
  becomes the index plus the pieces in use.
- **Consequences to handle:**
  - `lowStrIdx` (`lower.cla` ~l.43–59, 585–589) stops resuming from
    the bake's end state. Literal pools become per-module and are
    deduped at emit or link time.
  - Lowering's declaration-order slot numbering (`lowConnSlotOf` and
    friends, `uiMenuIdx`, `lower.cla` ~l.158–191, 235–236) becomes
    reachability-ordered.
  - `lowComputeCanAbort` (`lower.cla` ~l.8779, reverse propagation
    ~l.8727–8744) must treat runtime functions conservatively: user
    code can make a runtime dispatcher `canAbort`, and a prebuilt
    library cannot know that in advance.
  - `cg_free_globals`, init-globals, RC walks and pools stay
    per-program synthesis. They are not captured (`cg68k.cla`
    ~l.15330–15353 explains why).

**Open for the spec**
- The library file format and its version stamp.
- How the file ships with ClarusC.APPL (beside it on disk, or found by
  name).
- How the host from-source path relates to it.
- Whether the from-source path keeps whole-runtime lowering (it may; it
  is a host-only path).
- The on-target library size target (~0.4 MB estimated).

**Exit:** `bookmarks --rtbake` ≤ 1.2 MB; no whole-resource read in
ClarusC's compile path.

### Wave 5: Code and stack

Output-changing.

**Scope**
- **Table-driven `cg_free_globals` + RC walks.** Today these are
  unrolled into every segment (`cgEmitFreeGlobalsStub`, `cg68k.cla`
  ~l.5443, synthesized per segment ~l.15896). The fix is a
  constant-pool table of (A5 offset, kind) plus one release loop, which
  saves ~550 KB of ClarusC's 1.56 MB. `docs/TODO.md`'s "ABI /
  performance" entry has the analysis.
- **D9: `segment "name"` directive plus unloading.**
  - Grammar: a file-level directive that applies to the declarations
    after it, possibly with a per-function form. `cgPackProgram`
    (`cg68k.cla` ~l.14420) packs named groups separately. With no
    directive, today's packing is unchanged.
  - Runtime: `UnloadSeg` at safe points only. A segment can't be
    unloaded while any of its code is on the stack.
  - Callback bodies (`callback func`, which the Toolbox calls through a
    code address) must be forced into a resident segment.
- **ClarusC phase overlays.** Put the front end, checker, lower and cg
  in named segments, and have `drive.cla` unload each phase's segments
  after that phase's top-level call returns. Expected resident code:
  the largest phase (cg, ~310 KB) plus runtime, driver and UI
  (~150 KB).
- **Stack sized from measurement.** Wave 0's high-water probe sets
  ClarusC's `stack:` app field, instead of `cgStackHeuristic`'s static
  all-paths bound of 729 KB (`cg68k.cla` ~l.3099).
- **Smaller frames on the deep recursive walks** (`checkExpr`,
  `lowExpr`, `cgEmitExpr`): fewer 256-byte string temps, and a smaller
  big-temp floor (`cgBigTmpFloor` 4 × `cgBigTmpSize` 512 B,
  `cg68k.cla` ~l.1483).
- **Stream the output fork.** Write each CODE segment as it is
  finished, instead of accumulating `segBytes` and then copying the
  whole fork again for MacBinary (`app68BuildFork`/`app68WrapFork`,
  `app68k.cla` ~l.582–639).
- **On-target acceptance** on the SE (System 6, single-app): ClarusC
  compiles `bookmarks.cla`, and `snow/clarusc_bake` passes there.
  Secondary check: the same on the Mac IIcx under System 7.1.

**Open for the spec**
- The directive's exact grammar.
- Explicit vs automatic unloading (e.g. unload all non-resident
  segments whenever the event loop goes idle).
- How the stack size stays correct as the compiler evolves (a measured
  number plus margin, re-measured at each wave close?).

**Exit:** D1's "done".

### Decision point: Wave 6 (separate compilation + linker)

Taken after Wave 5 with its numbers in hand. The end-state sketch is in
the findings doc §4 (Wave 5 there): per-file objects (interface summary
+ code bytes + holes + global counts + local literal pool) and a
streaming linker. The existing object-code machinery (`cgObjRuns`/
`cgObjHoles`, five hole kinds, `cgObjPasteFunc`) is the foundation.
Language surface: `import` (interface-only) alongside the textual
`include`.

## 7. Per-wave on-target measurement (the Mac IIcx)

At each wave close, run ClarusC.APPL on the Mac IIcx compiling
`bookmarks.cla` and record in §9:
- the per-phase `FreeMem`/`MaxBlock`;
- the peak heap used;
- the stack high-water;
- the compile time in ticks. It is emulated, so it stays valid under
  fast-forward. Recorded, not gated (D2).

## 8. Dependencies

```
Wave 0 ─┬─> Wave 1 ─> Wave 2 ─> Wave 3 ─> Wave 4 ─> Wave 5 ─> decision (Wave 6)
        └──────────────────────────────────────────────> (Wave 5 stack sizing uses Wave 0's probe)
```

- Wave 1's `.release()` is used by every later wave's frees.
- Wave 2's per-function encode feeds Wave 4's object capture.
- Wave 3 runs before Wave 4 so the library format is cut once, after
  the IR kinds and enum widths settle.
- Waves may overlap in time only through separate branches. Each merges
  green on its own.

## 9. Status

| Wave                               | Status                               | Branch           | Numbers recorded |
|------------------------------------|--------------------------------------|------------------|------------------|
| prerequisite: Linux emulator lanes | in progress (2026-09-27), not merged | `emulator-linux` | —                |
| 0 Measurement                      | not started                          | —                | —                |
| 1 Lifetimes                        | not started                          | —                | —                |
| 2 Representation                   | not started                          | —                | —                |
| 3 Narrow scalars                   | not started                          | —                | —                |
| 4 Lazy runtime library             | not started                          | —                | —                |
| 5 Code and stack                   | not started                          | —                | —                |
| Wave 6 decision                    | pending                              | —                | —                |

`emulator-linux` must merge before Wave 0 starts, because Wave 0 relies
on the Snow lane. It also carries a host AppleTalk fix for routed
networks (`rt_atalk.inc`: accept any zone name on NBP lookups, treat
net 0 as matching any network).
