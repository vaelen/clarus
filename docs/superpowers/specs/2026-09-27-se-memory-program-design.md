# SE memory program: ClarusC.APPL in 4 MB (program design, 2026-09-27)

Status: **program design, approved 2026-09-27. Wave 0 (measurement) is
merged (2026-09-28). Wave 1 (lifetimes) is merged
(2026-09-28), at 6,324,316 bytes against its 6 MB target (§9.2). Wave 2
(representation) is merged (2026-09-28), at 3,668,312
bytes against its 4 MB target (§9.3). Wave 3 (narrow scalars) is
merged (2026-09-29), at 3,399,176 bytes against its
3.5 MB target (§9.4). Wave 4 (lazy runtime library) is merged to
main (2026-09-29, `f62e67d5`), at 1,194,744 bytes against its 1.2 MB target
(§9.5). Wave 5 (close on the SE) is complete on branch `se-wave5-close`
(2026-09-30, not yet merged): ClarusC.APPL compiles `bookmarks.cla` on
the Snow SE with a lowest free of 1130 KB, gated by a 1017 KB floor
(§9.6). D1 is done; the program is closed. Wave 6 is no-go (Andrew,
2026-09-30).**
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
| Budget on the SE (measured in Wave 0, §9.1)                  |      3808 KB app space; ClarusC heap target 2221 KB |

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

| #   | Decision                                                                                                                                                                                                                                                                                                                                                                                                                                                       | Why                                                                                                                                                        |
|-----|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| D1  | "Done" = Waves 0–5 plus an on-target compile of `bookmarks.cla` on the SE. Wave 6 (separate compilation + linker) is a **go/no-go decided after Wave 5**. **Done (2026-09-30, §9.6):** ClarusC compiles `bookmarks.cla` on the Snow SE, lowest free 1130 KB. **Wave 6: no-go** (Andrew, 2026-09-30); separate compilation plus a streaming linker is recorded in `docs/FUTURE.md`.                                                                             | The memory goal is reachable without a linker (findings §4, Wave 3 → ~1 MB heap).                                                                          |
| D2  | **Memory wins over speed.** Compile #2 in a ClarusC session may get slower until Wave 4 (bake staging copies are freed). The host perfgate must not regress; on-target compile time is recorded but not gated.                                                                                                                                                                                                                                                 | The ~3.2 MB of staging kept for a fast second compile is unaffordable on the SE.                                                                           |
| D3  | New scalar types **`uint8`, `int16`, `uint16`**. No 32-bit unsigned type (`uint`) for now; record it in `docs/FUTURE.md`.                                                                                                                                                                                                                                                                                                                                      | `uint16` is cheap once `int16` exists. `uint` alone needs unsigned compares and divide, a new `rtUIntToStr`, literal-range work and C-lane mixing hazards. |
| D4  | **Mixing rule A**: implicit widening of `uint8`/`int16`/`uint16` → `int`, and arithmetic happens at 32 bits. Narrowing is explicit via `uint8(x)`/`int16(x)`/`uint16(x)` and **truncates** (like `char(i)` today). In-range literals are accepted wherever a narrow type is expected.                                                                                                                                                                          | Least noise without silent truncation. It also matches codegen: widen at load, truncate only at an explicit conversion.                                    |
| D5  | **Extern boundary rule**: at an `external func`/`= ptr` argument and an `extern record` field store, an `int` value is accepted for a narrow-typed slot and truncated, exactly as today's marshaling does. Everywhere else narrowing stays explicit.                                                                                                                                                                                                           | This keeps the ~317 existing `word` declarations' call sites compiling unchanged after the rename (D6).                                                    |
| D6  | The contextual extern types **`word` → `int16` and `byte` → `uint8`** are renamed repo-wide (`.cla`, the language reference, the cookbook, fixtures), then the old spellings are **removed**, with no aliases.                                                                                                                                                                                                                                                 | Andrew: one set of integer names, not Toolbox terminology drifting from the language's. There are no external users (`m68k-bbs` has zero uses).            |
| D7  | **Enums become 2 bytes on the native lane**, as the language reference (`docs/clarus-language-reference.md` ~l.157, ~l.314) already specifies. Today `cgSizeOfUncached` stores them as 4 (`clarusc/cg68k.cla` ~l.1939). **Revised by Wave 3's N8:** enums are 2 bytes on both lanes; the C lane stores an enum field or element as `uint16_t` (locals, parameters, globals and returns stay `int32_t`).                                                        | Spec conformance, and it shares the 16-bit storage plumbing with `int16`.                                                                                  |
| D8  | **Serializer v2**: `file.save` writes format version 2 with **2-byte enum fields**. `file.load` accepts v1 (4-byte enums) and v2. One deliberate re-pin of the frozen CLRD goldens (`CLRD_BLESS=1`), plus a new frozen **v1** fixture proving old files still load. New narrow field types take their natural widths (1/2/2 bytes). No other format guard is needed: the file carries no type codes, which live in the program's compiled descriptor.          | The only real users are `examples/bookmarks.cla` (its record has an enum field) and the test suite.                                                        |
| D9  | A user-facing **`segment "name"` directive** plus runtime segment unloading, with ClarusC.APPL as its first user. With no directive, packing stays exactly as today. **Amended by Wave 5's V2 (2026-09-30):** the directive, `UnloadSeg` and ClarusC's phase overlays leave the SE program, which closed without them, and become their own later ROADMAP phase. Smaller walker frames and a streamed fork went to TODO; Wave 5's Task 7a then did the frames. | Plus/SE apps need overlays as much as the compiler does (the `#pragma segment` idiom).                                                                     |
| D10 | **`list`/`map`/`text` `.release()` and `.shrink()`** join the language. `release()` drops storage back to canonical empty. `shrink()` trims capacity to count. `clear()` keeps its current keep-capacity meaning, now documented.                                                                                                                                                                                                                              | Today the only way to free a container is to reassign a fresh one, and `astReset()` gets that wrong (`.clear()` frees nothing).                            |
| D11 | **Acceptance machine**: the Snow SE (4 MB, System 6.0.8) with ClarusC launched **single-app via boot-block autostart**, no MultiFinder. **Measurement machine**: the Snow Mac IIcx (128 MB, System 7.1, 32-bit addressing), where ClarusC runs today.                                                                                                                                                                                                          | Andrew's choice. Single-app gives ClarusC all free RAM.                                                                                                    |
| D12 | Process: **Opus** for implementation and review; plans **maximize parallelism**; **emulator runs only at the end of each wave** (Wave 0 excepted).                                                                                                                                                                                                                                                                                                             | Andrew: fewer follow-up fixes, and faster implementation.                                                                                                  |

## 3. Environment (Linux, as of 2026-09-27)

Everything here is also in `CLAUDE.md`. The emulator infrastructure
came from branch `emulator-linux`, merged to `main` on 2026-09-27
(`62b718c4`).

- **Display.** Shells on this machine usually have no `DISPLAY`. Boots
  need `export DISPLAY=:1 XAUTHORITY=/run/user/1000/gdm/Xauthority`.
- **Snow** (`snow/clarus-snow`):
  - `snow/system6`: SE, 4 MB, System 6.0.8 (`system6.snoww`,
    `system6.img`). SCSI 1 is `clarus.img` (volume `Clarus`), SCSI 3 is
    Ethernet; LocalTalk comes from `--serial-bridge-b localtalk`.
  - `snow/system7`: Mac IIcx, 128 MB, System 7.1, `rominator.rom`
    (32-bit clean), 8•24 display card, `system7.pram` (32-bit
    addressing), `start_fastforward: true`. SCSI 1 is `clarus.img`,
    SCSI 3 is Ethernet.
  - Test boots go through `tests/lib_snow.sh`: `snow_disk [6|7]` clones
    the template's disks, ROM paths and PRAM into `$WORK/snow`.
    `SNOW_SYSTEM` picks the machine; the default is 6, and the ClarusC
    scripts use 7. Boots use a private serial port.
  - Fast-forward at boot works on the current Snow (~4.3–4.9x). It once
    hung the old macOS Mac II lane (`docs/HISTORY.md`); no longer.
    `snow/adsp_listener` forces real-time (`snow_realtime`).
  - ClarusC on the IIcx (measured 2026-09-27): `clarusc_bake` passes in
    ~9–18 min; `macresident` ~44 min; `macresident_failed_compile`
    ~30 min. System 6 has no MacTCP; System 7's guest is 10.0.0.2
    (gateway 10.0.0.1, NAT outbound-only).
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

| After wave | `bookmarks --rtbake` peak | Other exit criterion                                                                                                       |
|------------|--------------------------:|----------------------------------------------------------------------------------------------------------------------------|
| 0          |     11.79 MB (11,789,468) | SE app budget 3808 KB recorded; Mac IIcx per-phase baseline recorded (§9.1)                                                |
| 1          |   6.32 MB (6,324,316) [a] | every task byte-identical                                                                                                  |
| 2          |   3.67 MB (3,668,312) [b] | ≤ 4 MB met                                                                                                                 |
| 3          |   3.40 MB (3,399,176) [c] | serializer writes v2, loads v1                                                                                             |
| 4          |   1.19 MB (1,194,744) [d] | runtime library read with `readAt`; no whole-resource read                                                                 |
| 5          |   1.19 MB (1,194,728) [e] | met: ClarusC compiles `bookmarks.cla` on the SE (lowest free 1130 KB, floor 1017 KB); `snow/clarusc_bake` passes on the SE |

The budgets are targets. A wave's spec may revise its own number with a
measured justification. It may not remove the ratchet.

[a] Wave 1's target was ≤ 6 MB (6,291,456). It measured 6,324,316, which
misses by 32,860 bytes (0.5%), and its budget is 6,387,378. The wave
spec's §1 records the revision and its justification: the peak is a
transient inside the bake parse, and the levers that remove it are
Wave 2 items (§9.2).

[b] Wave 2's target was ≤ 4 MB and it measured 3,668,312 (budget
3,704,996). From Wave 2 on, memgate measures this subcase from outside
the repo (`$WORK`): Wave 1's 6,324,316 was a host-only read of the 4 MB
`clarusc/clarusc.c` in the stamp check, which ClarusC never does, and
the same Wave 1 code measured that way peaks at 5,836,696 (§9.3).

[c] Wave 3's target was ≤ 3.5 MB (3,670,016) and it measured 3,399,176
(budget 3,433,168), 270,840 bytes (7.4%) under. The host counts about
75 KB of the arena saving that the 68k layout does not see (§9.4).

[d] Wave 4's target was ≤ 1.2 MB (1,258,291) and it measured 1,194,744
(budget 1,206,692), 63,547 bytes (5.1%) under. The wave spec's §1
number stands (§9.5).

[e] Wave 5 did not target the host heap. Its gate is on the SE:
`clarusc_memprobe` fails when ClarusC's lowest per-phase free drops
under `tests/mactest/snow/se_floor.txt` (1017 KB, 90% of the measured
1130 KB). The host peak fell 16 bytes and the budgets were not
ratcheted (§9.6).

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

**Revised by the wave spec** (`2026-09-30-se-wave5-close-design.md`,
V1/V2): a spike showed ClarusC already fitting the SE after Wave 4, so
Wave 5 shipped the table-driven `cg_free_globals`, a measured stack
reserve with a depth guard, the scripted pump's disk mount and the SE
gate. The directive, unloading and overlays became a later ROADMAP
phase (D9 amended). Task 7a did the smaller frames at close; the
streamed fork is in `docs/TODO.md`. The brief below is kept as written.

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

**Decided: no-go** (Andrew, 2026-09-30), with Wave 5's numbers in hand:
the SE compile has 1130 KB free at its low point and ClarusC's CODE is
1.14 MB. The lever is recorded in `docs/FUTURE.md`: pull it for larger
programs, for a real SE with less free memory, or for rebuild speed.

## 7. Per-wave on-target measurement (the Mac IIcx)

At each wave close, run ClarusC.APPL on the Mac IIcx compiling
`bookmarks.cla` and record in §9:
- the per-phase `FreeMem`/`MaxBlock`;
- the peak heap used;
- the stack high-water;
- the compile time in ticks. Recorded, not gated (D2). Wave 0 found
  that ticks are **not** stable under Snow's fast-forward: two runs of
  the same compile took 81753 and 89619 ticks (§9.1). Compare ticks
  only within one run.

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

| Wave                               | Status                                 | Branch                    | Numbers recorded                                                                                                                                                                                       |
|------------------------------------|----------------------------------------|---------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| prerequisite: Linux emulator lanes | merged to main 2026-09-27 (`62b718c4`) | `emulator-linux`          | T1 116 pass / 0 fail; `mactest/` 30 pass, 6 opt-in skips, 0 fail (all 9 Snow scripts pass)                                                                                                             |
| 0 Measurement                      | merged to main 2026-09-28 (`87dcf389`) | `se-wave0-measurement`    | memgate peaks 11,789,468 (rtbake) / 14,190,252 (src) / 10,194,664 (hello); SE app space 3808 KB, ClarusC target 2221 KB; IIcx low point 12035 KB used, stack 187 KB; peak calibration 0.96–1.08 (§9.1) |
| 1 Lifetimes                        | merged to main 2026-09-28 (`fadb19af`) | `se-wave1-lifetimes`      | memgate peaks 6,324,316 (rtbake, target 6 MB missed by 32,860) / 8,605,188 (src) / 8,531,984 (hello); IIcx low point 7977 KB used (−4058 KB), stack 187 KB (§9.2)                                      |
| 2 Representation                   | merged to main 2026-09-28 (`378ccd10`) | `se-wave2-representation` | memgate peaks 3,668,312 (rtbake, 4 MB target met) / 7,639,484 (src) / 7,570,224 (hello); IIcx low point 6272 KB used (−1705 KB), stack 187 KB (§9.3)                                                   |
| 3 Narrow scalars                   | merged to main 2026-09-29 (`3642e8ec`) | `se-wave3-narrow-scalars` | memgate peaks 3,399,176 (rtbake, 3.5 MB target met) / 7,377,444 (src) / 7,308,336 (hello); IIcx low point 6111 KB used (−161 KB), stack 187 KB (§9.4)                                                  |
| 4 Lazy runtime library             | merged to main 2026-09-29 (`f62e67d5`) | `se-wave4-lazy-library`   | memgate peaks 1,194,744 (rtbake, 1.2 MB target met) / 6,923,184 (src) / 6,919,612 (hello); IIcx low point 2443 KB used (−3668 KB), stack 194 KB (§9.5)                                                 |
| 5 Close on the SE                  | complete 2026-09-30, not yet merged    | `se-wave5-close`          | SE lowest free 1130 KB (2024 KB used; spike 342 KB), floor 1017 KB; IIcx low point 2027 KB used (−416 KB); CODE 1,607,548 → 1,141,980 B; stack 49/392 KB SE, 163/408 KB IIcx; memgate unchanged (§9.6) |
| Wave 6 decision                    | **no-go** (Andrew, 2026-09-30)         | —                         | lever recorded in `docs/FUTURE.md`                                                                                                                                                                     |

`emulator-linux` is merged (2026-09-27); Wave 0 relied on its Snow
lane. That branch also carried a host AppleTalk fix for routed
networks (`rt_atalk.inc`: accept any zone name on NBP lookups, treat
net 0 as matching any network).

### 9.1 Wave 0 measurements (2026-09-28)

All of these come from branch `se-wave0-measurement`. The wave spec
(`2026-09-27-se-wave0-measurement-design.md` §5) defines them. The task
reports and the `progress.md` ledger are in
`.superpowers/sdd/2026-09-27-se-wave0-measurement/`. Sizes are in bytes,
and KB means 1024 bytes. "MB" follows the findings document, which uses
decimal megabytes (the 1.92 MB CLIR is 1,923,629 bytes).

**SE app budget** (Snow SE, 4 MB, System 6.0.8, single-app via the
boot-block autostart, no window open; `tests/mactest/snow/se_budget.sh`).
The raw line:

```
SEBUDGET FreeMem=3651694 MaxBlock=3651430 ApplZone=270364 ApplLimit=4040916 HeapEnd=4040916 CurStackBase=4159146 BufPtr=4170186 MemTop=4194304
```

| Quantity                                                    |         Bytes |       KB |
|-------------------------------------------------------------|--------------:|---------:|
| `FreeMem` after startup (heap available)                    |     3,651,694 |     3566 |
| `MaxBlock`                                                  |     3,651,430 |     3566 |
| App space, `BufPtr − ApplZone` (heap + stack together)      |     3,899,822 |     3808 |
| Probe app's own stack, `CurStackBase − ApplLimit`           |       118,230 |      115 |
| **ClarusC target** (spec §5.1): app space − 64 KB − 1.56 MB | **2,274,286** | **2221** |
| Same, with the measured 187 KB stack in place of 64 KB      |     2,148,334 |     2098 |

- The target is app space − a 65,536-byte stack − 1,560,000 bytes of
  resident code. If "1.56 MB" is read as binary megabytes (1,635,779
  bytes), the target is 76 KB lower, 2,198,507 bytes (2147 KB).
- **64 KB of stack is not enough today.** ClarusC's measured high-water
  on the IIcx is 187 KB (see below), which is why the second row
  exists. Sizing the stack is a Wave 5 input.
- **The target does not count the CLIR resource.** ClarusC reads the
  1,923,629-byte `__clir_bake_68k__` resource and never releases it.
  Until Wave 4 replaces that read, the resource sits in the same heap
  and leaves about 0.35 MB of the target for everything else.
- The budget is Snow's System 6 image. Andrew's real SE has more
  INITs/cdevs, so its budget will be somewhat smaller.

**Host memory gate** (`tests/memgate/budget.txt`, in T1). Peak live heap
in 68k-equivalent bytes (H = 8). Every subcase peaks in the `Built fork`
phase, and the peaks are identical across runs.

| Subcase                      | Peak (bytes) | Budget = int(peak × 1.01) + 1 |
|------------------------------|-------------:|------------------------------:|
| `bookmarks_rtbake` (primary) |   11,789,468 |                    11,907,363 |
| `bookmarks_src`              |   14,190,252 |                    14,332,155 |
| `hello_src`                  |   10,194,664 |                    10,296,611 |

A fresh run on 2026-09-28 of `bookmarks --rtbake`, with scratch output
paths, peaked at 11,786,332, which is 3,136 bytes (0.03%) below Task 7's
run. That run is the source of the calibration numbers below.

**Mac IIcx per-phase baseline** (Snow IIcx, 128 MB, System 7.1, 32-bit
addressing, fast-forward; `tests/mactest/snow/clarusc_memprobe.sh`,
ClarusC compiling `examples/bookmarks.cla` on the bake path). Free and
max come from the `mem:` lines. "Used" is launch free minus free at that
phase. The mem columns come from run 2 (Task 8's fix round, saved log
`build-run/memprobe-saved/clarusc_memprobe.fix1.log`). Run 1's mem
values agree to within about 45 KB (its `Built fork` free was 36061 KB),
and its ticks are in the last column.

| Point                       |   Free KB | Max KB |   Used KB |        Ticks, run 1 |        Ticks, run 2 |
|-----------------------------|----------:|-------:|----------:|--------------------:|--------------------:|
| launch (heap zone 48400 KB) |     48106 |  48106 |         0 |                   — |                   — |
| pre-compile (CLIR loaded)   |     43949 |  43948 |      4157 |                   — |                   — |
| Parsed user program         |     38327 |  38327 |      9779 |                 398 |                 952 |
| Checked user program        |     38112 |  38111 |      9994 |                1099 |                1216 |
| Installed baked runtime     |     36462 |  36461 |     11644 |               13729 |               16833 |
| Lowered                     |     36170 |  36169 |     11936 |                 236 |                 215 |
| Shaken                      |     38188 |  38187 |      9918 |                 598 |                 639 |
| Measured                    |     36342 |  36342 |     11764 |               39768 |               50247 |
| Packed 4 segments           |     36340 |  36338 |     11766 |                 422 |                 459 |
| Emitted segment 1           |     36279 |  36278 |     11827 |                7720 |                6246 |
| Emitted segment 2           |     36249 |  36248 |     11857 |                3245 |                3174 |
| Emitted segment 3           |     36209 |  36209 |     11897 |                4417 |                5204 |
| Emitted segment 4           |     36199 |  36197 |     11907 |                4042 |                3570 |
| **Built fork (low point)**  | **36071** |  36069 | **12035** |                6027 |                 815 |
| Finished                    |     36172 |  36169 |     11934 |                   — |                   — |
| **Compile total**           |           |        |           | **81753** (22m 42s) | **89619** (24m 53s) |

- **Stack:** high-water 187 KB of a 735 KB reserve (`CurStackBase −
  ApplLimit` on the IIcx), the same in both runs.
- **Ticks are not stable under fast-forward.** §7 assumed they would be.
  Two runs of the same binary on the same input differ by 9.6% in total,
  and single phases differ by much more (`Measured` 39768 vs 50247,
  `Built fork` 6027 vs 815). Compare ticks only within one run.
- Outside the compile ticks, "Loading Baked Runtime" (the CLIR read and
  verify, before "Starting") took about 18–19 minutes of guest time in
  each run.
- On the IIcx, `free` equals `max` to within 3 KB at every point, so this
  machine says nothing about fragmentation on the SE.

**Census, top 10 globals at the peak phase** (`scripts/memcensus.sh
--rtbake examples/bookmarks.cla`, `Built fork`, host bytes = handle
size):

| #   | Global               |     Bytes |   Count | Elem size |     Cap |
|-----|----------------------|----------:|--------:|----------:|--------:|
| 1   | `cv_rtbakeBytes`     | 2,097,152 | 1923629 |         1 | 2097152 |
| 2   | `cv_irExprs`         | 1,310,720 |   29189 |        40 |   32768 |
| 3   | `cv_bkLdIrExprs`     | 1,310,720 |   28890 |        40 |   32768 |
| 4   | `cv_a68Items`        | 1,179,648 |    1967 |        72 |   16384 |
| 5   | `cv_strPool`         | 1,048,576 |    3336 |       256 |    4096 |
| 6   | `cv_bkLdStrPool`     | 1,048,576 |    3123 |       256 |    4096 |
| 7   | `cv_bkLoadedSymbols` |   294,912 |    5366 |        36 |    8192 |
| 8   | `cv_irStmts`         |   229,376 |    7772 |        28 |    8192 |
| 9   | `cv_bkLdIrStmts`     |   229,376 |    7665 |        28 |    8192 |
| 10  | `cv_cgObjHoles`      |   196,608 |    3672 |        48 |    4096 |

**Calibration** (spec §5.3). IIcx used at phase k = launch free (48106
KB) − free at k. Host at k = `live68k + 4 × blocks` (H = 12) from the
matching `memprobe:` line of the fresh `bookmarks --rtbake` run. The
Δ columns are the change since the previous row. The excess column is
ΔIIcx − Δhost, which is memory the Mac spent in that phase that the host
model did not.

| Phase                   | IIcx used KB | Host (H=12) KB | Raw ratio | ΔIIcx KB | Δhost KB | Excess KB |
|-------------------------|-------------:|---------------:|----------:|---------:|---------:|----------:|
| Parsed user program     |         9779 |           7688 |     1.272 |     9779 |     7688 |     +2091 |
| Checked user program    |         9994 |           7710 |     1.296 |      215 |       22 |      +193 |
| Installed baked runtime |        11644 |           9499 |     1.226 |     1650 |     1789 |      −139 |
| Lowered                 |        11936 |           9502 |     1.256 |      292 |        4 |      +288 |
| Shaken                  |         9918 |           9536 |     1.040 |    −2018 |       34 |     −2052 |
| Measured                |        11764 |          11047 |     1.065 |     1846 |     1511 |      +335 |
| Packed 4 segments       |        11766 |          11049 |     1.065 |        2 |        2 |         0 |
| Emitted segment 1       |        11827 |          11119 |     1.064 |       61 |       70 |        −9 |
| Emitted segment 2       |        11857 |          11148 |     1.064 |       30 |       29 |        +1 |
| Emitted segment 3       |        11897 |          11188 |     1.063 |       40 |       40 |         0 |
| Emitted segment 4       |        11907 |          11197 |     1.063 |       10 |       10 |         0 |
| Built fork              |        12035 |          11325 |     1.063 |      128 |      128 |         0 |

How to read it:

- **Where no new compiler code loads, the model is exact.** From
  `Packed` through `Built fork` the Mac spent 271 KB and the host
  modelled 279 KB. The phases differ by at most 9 KB, and `Built fork`'s
  128 KB matches exactly. This is the independent evidence that the
  H = 12 cost model is right for data.
- **The big excesses have known causes that the host never sees:**
  - *Parsed* (+2091 KB): the CLIR resource handle (1,923,629 bytes, 1879
    KB, read and never released) plus the code segments for the lexer,
    parser and bake loader. Minus the resource, the excess is +212 KB.
  - *Checked, Lowered, Measured* (+193, +288, +335 KB): the first run of
    the checker, lowering and code-generation passes. ClarusC calls no
    `UnloadSeg`, so each pass's CODE segments load then and stay
    resident. That fits "cg ~310 KB" (§6 Wave 5).
  - *Shaken* (−2052 KB): macgui's `gcCompile` sets `rtbakeBytes = ""`
    right after `driveCompile` returns, which frees the 2 MB CLIR copy
    (its capacity is 2,097,152 bytes). The host driver (`main.cla`)
    never frees it, and the census still shows `cv_rtbakeBytes` resident
    at `Built fork`.
  - *Installed* (−139 KB): the host modelled more than the Mac spent.
    This is unexplained, and it fits W2's pointer-width overcount (the
    install copies tables that hold pointers). It is a hypothesis.
- **Peak ratio.** IIcx low point (`Built fork`, 12035 KB used) against
  the host:

  | Comparison                                                                | IIcx KB | Host KB | Ratio |
  |---------------------------------------------------------------------------|--------:|--------:|------:|
  | raw, vs host `live68k + 4 × blocks` at the phase boundary                 |   12035 |   11325 | 1.063 |
  | raw, vs host `peakAll68k + 4 × blocks` (11786332 + 4 × 23562)             |   12035 |   11602 | 1.037 |
  | − CLIR resource (1879), + `rtbakeBytes` the Mac freed (2048), code kept   |   12204 |   11325 | 1.078 |
  | same, also − ~1028 KB of code estimated as loaded after launch (boundary) |   11176 |   11325 | 0.987 |
  | same, vs host peak                                                        |   11176 |   11602 | 0.963 |

  - **What is known:** the partition is 50,331,648 bytes (the heap zone
    at launch is 48400 KB), and ClarusC's CODE is about 1.56 MB over 47
    segments. The launch state (CODE 1, the jump table and A5 world, and
    runtime init) is 294 KB, which the launch zero point already
    excludes. The resource and the rtbake copy are exact sizes.
  - **What is not known:** exactly which segments are resident at the
    peak. The ~1028 KB of code is inferred from the excess column (212
    + 193 + 288 + 335), so it is not independent of this data. It also
    includes the Log window and progress buffer. The ceiling is 1.56 MB
    minus the part already resident at launch.
  - Every adjusted ratio falls inside the 0.85–1.15 band, so **no model
    term is flagged as wrong.** The 3.7% gap between the boundary and
    peak rows is the host's intra-phase peak inside `Built fork` (+277
    KB), which the Mac's once-per-phase sample cannot see.
- **Wave 1 inputs from the calibration** (not model errors):
  - The host gate charges about 2 MB that ClarusC does not hold at its
    peak: `main.cla` keeps `rtbakeBytes` where macgui frees it. Wave 1's
    "free the bake staging + blob after install" item removes it from
    both drivers. Until then, the gate overstates ClarusC's real peak by
    that amount.
  - The Mac-only CLIR resource (1.88 MB) is invisible to the gate. It is
    Wave 4's job, and until then the SE budget has to include it.

### 9.2 Wave 1 measurements (2026-09-28)

All of these come from branch `se-wave1-lifetimes`. The wave spec is
`2026-09-28-se-wave1-lifetimes-design.md`. The task reports, the IIcx
write-up (`task-7-memprobe.md`) and the `progress.md` ledger are in
`.superpowers/sdd/2026-09-28-se-wave1-lifetimes/`. Units are as in §9.1.

**Host memory gate** (`tests/memgate/budget.txt`; 68k-equivalent bytes,
H = 8; identical across three runs):

| Subcase                      | Wave 0 peak | Wave 1 peak |     Change | Wave 1 budget |
|------------------------------|------------:|------------:|-----------:|--------------:|
| `bookmarks_rtbake` (primary) |  11,789,468 |   6,324,316 | −5,465,152 |     6,387,378 |
| `bookmarks_src`              |  14,190,252 |   8,605,188 | −5,585,064 |     8,691,240 |
| `hello_src`                  |  10,194,664 |   8,531,984 | −1,662,680 |     8,617,304 |

- **The 6 MB target (6,291,456) is missed by 32,860 bytes (0.5%).** The
  wave spec's §1 records the measured figure and revises its own number
  (see "Where the rtbake peak is now", below).
- The `bookmarks_rtbake` budget is 6,387,378, not peak + 1% (6,387,560):
  Task 4 had already lowered it to that value, and budgets only go down.
  The headroom is 0.99%.

**What each task bought.** Tasks 2–4 ran in parallel from the same base,
so each is measured alone on the Wave 0 base. The later rows are the
merged branch.

| Change                                                        | `bookmarks_rtbake` | `bookmarks_src` | `hello_src` |
|---------------------------------------------------------------|-------------------:|----------------:|------------:|
| Wave 0 baseline                                               |         11,789,468 |      14,190,252 |  10,194,664 |
| Task 1 alone: `.release()`/`.shrink()` [b]                    |         11,807,132 |      14,286,344 |  10,208,836 |
| Task 2 alone: free AST, tokens and checker tables after lower |         11,756,380 |       9,313,792 |   8,530,388 |
| Task 3 alone: per-function `a68Items` reset in measure        |         11,199,644 |      10,650,284 |  10,193,128 |
| Task 4 alone: bake install by move, re-parse, free the blob   |          6,324,136 |      14,190,252 |  10,194,664 |
| Tasks 2 + 3 + 4 merged                                        |          6,324,136 |       8,534,088 |   8,530,388 |
| + Task 1 (Wave A tip)                                         |          6,324,316 |       8,607,108 |   8,533,776 |
| + Task 5: free sites use `.release()`; minors (final)         |          6,324,316 |       8,605,188 |   8,531,984 |

[b] Task 1's implementer read its +96 KB on `bookmarks_src` as an IR
arena list crossing a doubling boundary, not the size of the new code.

- The rtbake gain is almost all Task 4 (−5.47 MB). The front-end frees
  (Task 2) and the measure reset (Task 3, −25% on `bookmarks_src` alone)
  carry the source path.
- **Task 2's and Task 3's wins do not add.** Task 3 removes the measure
  peak and Task 2 the front-end one, so the source-path peak moves
  between phases, and the merged figure is not the sum of the two
  deltas.

**Where the rtbake peak is now** (`scripts/memcensus.sh --rtbake
examples/bookmarks.cla`, Task 6). The peak moved from `Built fork` to
the bake parse, reported under `Parsed user program`:

```
memprobe: Parsed user program | live68k=3887596 peak68k=6324316 live=3789260 peak=6314360 blocks=9788 handles=5008 allocs=27967
```

Top 10 at the end of that phase (live at the phase boundary, not at the
peak moment; host bytes = handle size):

| #   | Global                |     Bytes | Count | Elem size |   Cap |
|-----|-----------------------|----------:|------:|----------:|------:|
| 1   | `cv_bkLdIrExprs`      | 1,310,720 | 29120 |        40 | 32768 |
| 2   | `cv_strPool`          | 1,048,576 |  3197 |       256 |  4096 |
| 3   | `cv_bkLdIrStmts`      |   229,376 |  7718 |        28 |  8192 |
| 4   | `cv_cgObjHoles`       |   196,608 |  3679 |        48 |  4096 |
| 5   | `cv_strIndex`         |   163,840 |  3197 |         4 |  4096 |
| 6   | `cv_bkLdIrTypes`      |   131,072 |  4283 |        16 |  8192 |
| 7   | `cv_cgObjRuns`        |    65,536 |  4420 |         8 |  8192 |
| 8   | `cv_bkLdIrLocals`     |    65,536 |  3000 |        16 |  4096 |
| 9   | `cv_bkLdIrFuncs`      |    28,672 |   767 |        28 |  1024 |
| 10  | `cv_bkLdIrFieldSlots` |    14,336 |   369 |        28 |   512 |

- The peak (6.32 MB) sits inside `bkLoadRtbake`, before
  `rtbakeBytes.release()`. Live at the phase end is 3.89 MB, so 2.43 MB
  is transient. About 1.94 MB of that is `rtbakeBytes` itself (the CLIR
  is 1,939,178 bytes), which is live while the whole IR is decoded. The
  other ~0.5 MB fits list-doubling transients in the `bkRead*` readers:
  `bkReadIrExprs` knows `n` (29120) up front but grows by `add`, so at
  the 16384 → 32768 step the old 655 KB and new 1.31 MB blocks are live
  together. This attribution is inferred; memcensus samples only at
  phase boundaries.
- **The revised Wave 1 number is the measured 6,324,316.** Closing the
  last 33 KB needs either pre-sized `bkRead*` lists (a list
  capacity/reserve primitive, out of Wave 1's scope per its spec §7) or
  progressive release of `rtbakeBytes` during the parse. Either removes
  far more than 33 KB, and both are Wave 2 candidates (`docs/TODO.md`).
  Adding a task for them in Wave 1 was ruled against in the ledger.

**Mac IIcx per-phase** (`tests/mactest/snow/clarusc_memprobe.sh`, same
machine and input as §9.1; saved log
`build-run/memprobe-saved/clarusc_memprobe.wave1.log`; one compile per
boot). "Used" is measured from each run's own launch free: Wave 1's
launch free is 48066 KB (zone 48398 KB), 40 KB below Wave 0's, most
likely the slightly larger app.

| Point                       | W0 used KB | W1 free KB | W1 used KB | W1 − W0 KB | W0 ticks, run 2 | W1 ticks |
|-----------------------------|-----------:|-----------:|-----------:|-----------:|----------------:|---------:|
| pre-compile (CLIR read)     |       4157 |      43990 |       4076 |        −81 |               — |        — |
| Parsed user program         |       9779 |      42158 |       5908 |      −3871 |             952 |      465 |
| Checked user program        |       9994 |      41910 |       6156 |      −3838 |            1216 |      690 |
| Installed baked runtime     |      11644 |      41917 |       6149 |      −5495 |           16833 |      507 |
| Lowered [c]                 |      11936 |      41654 |       6412 |      −5524 |             215 |      190 |
| Shaken                      |       9918 |      41619 |       6447 |      −3471 |             639 |      534 |
| Measured                    |      11764 |      40808 |       7258 |      −4506 |           50247 |    37860 |
| Packed 4 segments           |      11766 |      40806 |       7260 |      −4506 |             459 |      358 |
| Emitted segment 1           |      11827 |      40297 |       7769 |      −4058 |            6246 |    16005 |
| Emitted segment 2           |      11857 |      40267 |       7799 |      −4058 |            3174 |     2588 |
| Emitted segment 3           |      11897 |      40227 |       7839 |      −4058 |            5204 |     3699 |
| Emitted segment 4           |      11907 |      40217 |       7849 |      −4058 |            3570 |     2752 |
| **Built fork (low point)**  |  **12035** |      40089 |   **7977** |  **−4058** |             815 |     2341 |
| Finished                    |      11934 |      40190 |       7876 |      −4058 |               — |        — |
| **Compile total**           |            |            |            |            |           89619 |    68040 |

[c] Task 2's front-end free runs before `driveProgressPhase("Lowered")`,
so Wave 1's `Lowered` line is taken after the free and Wave 0's before
it. `Parsed` is not like-for-like either: it now includes the bake
re-parse and the `rtbakeBytes` release (see below). Compare the rows
from `Measured` on, and the low point.

- **Launch→low heap used: 12035 KB → 7977 KB, −4058 KB (−33.7%).** The
  low point is still `Built fork`. Free equals max to within 1 KB at
  every point.
- **Stack:** high-water 187 KB of a 737 KB reserve, unchanged.
- The Wave 0 dip at `Shaken` (macgui freeing the 2 MB `rtbakeBytes`
  copy) is gone: `driveCompile` now frees it right after the bake parse,
  so Wave 1's used climbs steadily to the low point.
- **Where the per-compile re-parse is logged.** `bkLoadRtbake` (plus
  `bkInstallPool` and `bkComputeManifestPaths`) runs at the top of
  `driveCompile`, *before* `drvStartTicks` is set and before the
  "Starting" line (`drive.cla` ~l.2129–2162). It was there in Wave 0 as
  well, behind the `bkParsedValid` memo. So the re-parse is outside the
  compile ticks altogether: it is the guest wall-clock span from
  "Verifying Baked Runtime" to "Starting", **5m 28s** in Wave 1 (18m 46s
  in Wave 0 run 2, when compile #1 also parsed). Its memory lands in the
  `Parsed user program` row, since the `pre-compile` probe
  (`macgui.cla` ~l.709) is taken before `driveCompile`. With one
  compile per boot the log cannot show a compile #2; by construction
  (spec L6) compile #2 now pays the same span, where Wave 0's skipped
  it.
  - Why the span shrank ~3.4× is not measured. The one parse-path change
    is Task 4 skipping the CheckerSymbols section outside `--testapi`;
    fast-forward variance (§9.1) cannot be ruled out either.
- **"Installed baked runtime" is 507 ticks, not 13729–16833, and −7
  KB.** That phase is `irReset` + `bkInstallArenas` (the re-parse is
  not in it, see above). Wave 0's install cloned the staging with the
  `bkCopy*` helpers so the memo stayed valid; Wave 1 moves it (Task 4),
  which removes both the copy time and the 1650 KB the copies cost.
- **`Emitted segment 1` costs +509 KB (Wave 0: +61 KB) and 16005 ticks
  (Wave 0: 6246–7720).** This is the measure reset's cost moving, not a
  leak. In Wave 0, `cg68Measure` ran the whole program into one
  `a68Items` stream, so the list arrived at emission already grown to
  whole-program size and segment 1 fit in it. Wave 1's
  `cgMeasureDropItems` uses `.clear()`, which keeps capacity, so after
  measure `a68Items` (and `a68CommentTexts`/`a68DataTexts`) is only as
  large as the biggest single function (or pool entry). The
  per-segment `a68Reset` (`cg68k.cla` ~l.15858) also keeps capacity, so
  segment 1, the largest, regrows the lists by doubling, and segments
  2–4 fit in what it left. From segment 2 on, the per-segment deltas
  (+30/+40/+10 KB, `Built fork` +128 KB) equal Wave 0's exactly. The
  extra ticks fit the regrowth (handle resizes, possibly relocation),
  but tick variance under fast-forward is large enough that the time
  figure is not established.

### 9.3 Wave 2 measurements (2026-09-28)

All of these come from branch `se-wave2-representation`. The wave spec
is `2026-09-28-se-wave2-representation-design.md`. The task reports,
IIcx write-up and ledger were git-ignored scratch, deleted after the
final review; the rulings are in `docs/HISTORY.md`'s Wave 2 entry. Units
are as in §9.1.

**Host memory gate** (`tests/memgate/budget.txt`; 68k-equivalent bytes,
H = 8; identical across five runs):

| Subcase                      | Wave 1 peak | Wave 2 peak |     Change | Wave 2 budget |
|------------------------------|------------:|------------:|-----------:|--------------:|
| `bookmarks_rtbake` (primary) |   6,324,316 |   3,668,312 | −2,656,004 |     3,704,996 |
| `bookmarks_src`              |   8,605,188 |   7,639,484 |   −965,704 |     7,715,879 |
| `hello_src`                  |   8,531,984 |   7,570,224 |   −961,760 |     7,645,927 |

- **The 4 MB target (4,194,304) is met**, with 525,992 bytes (12.5%) to
  spare. The wave spec's §1 number stands.
- **The rtbake change is not all Wave 2's.** Task 4's census found that
  Wave 1's 6,324,316 was a host-only artifact: the host CLI's stamp
  check (`feExpectedStamp` → `bkFindClarusC`) reads the whole 4 MB
  `clarusc/clarusc.c` while the CLIR buffer is live, where ClarusC reads
  a 4-byte stamp resource. memgate now runs the bake and the rtbake
  compile from `$WORK`, outside the repo, where the stamp lookup fails
  and both stamps are 0. Measured that way, the Wave 1 code peaks at
  **5,836,696**, so Wave 2's own rtbake saving is 2,168,384 bytes
  (−37.1%). The source subcases never read the stamp and are unaffected.

**What each task bought.** Wave A (Tasks 1–5) ran in parallel from the
Wave 1 tip and Wave B (Tasks 7 and 8) from the Wave A tip plus Task 6's
snapshot, so each task is measured alone on its wave's base. Rows up to
Task 4's fix round use the old in-repo rtbake measurement.

| Change                                                        | `bookmarks_rtbake` | `bookmarks_src` | `hello_src` |
|---------------------------------------------------------------|-------------------:|----------------:|------------:|
| Wave 1 tip (in-repo rtbake)                                   |          6,324,316 |       8,605,188 |   8,531,984 |
| Task 1 alone: `list.reserve`/`text.removeFirst`               |          6,324,376 |       8,605,864 |   8,536,604 |
| Task 2 alone: compact intern pool [d]                         |          6,324,420 |       7,638,636 |   7,565,432 |
| Task 3 alone: per-function emit → encode → discard [e]        |          6,324,436 |       8,605,308 |   8,532,104 |
| Task 4: rtbake measured from `$WORK` (Wave 1 code)            |          5,836,696 |       8,605,188 |   8,531,984 |
| Task 5 alone: `MoreMasters` (ClarusC only)                    |          unchanged |       unchanged |   unchanged |
| Wave A tip (Tasks 1–5 merged)                                 |          4,875,420 |       7,639,432 |   7,570,172 |
| Task 8 alone on Wave A: flat `cgObjRuns`                      |          4,597,600 |       7,639,484 |   7,570,224 |
| Task 7 alone on Wave A: bake parse pre-size, progressive free |          4,010,244 |       7,639,432 |   7,570,172 |
| Wave B tip (Tasks 7 + 8 merged)                               |          3,668,312 |       7,639,484 |   7,570,224 |
| + Task 9: 68k box sizes (host unchanged, R6)                  |          3,668,312 |       7,639,484 |   7,570,224 |
| + Task 10: snapshot, ratchet (final)                          |          3,668,312 |       7,639,484 |   7,570,224 |

[d] On the old in-repo rtbake measurement the peak was the stamp read,
so Task 2 could not show there, though every later phase's live heap
fell ~966 KB. Measured from `$WORK`, Wave A's tip is 961,276 below the
Wave 1 code, which is the pool's staging copy (`bkLdStrPool`, 1 MB of
256-byte slots at Wave 1's peak).

[e] Task 3 moved no whole-compile peak alone, because each peak was set
in an earlier phase. What it cut is the emit phase: `Emitted segment 1`
live fell 0.45 MB (rtbake), 1.03 MB (src) and 1.10 MB (hello), and the
rtbake `Built fork` phase peak fell from 5,422,560 to 4,975,192. That is
why `Built fork` came down with the parse once Task 7 removed the parse
peak.

- **Task 7's first version reserved exactly `n` and made things worse**:
  the first user append after install doubled each whole arena
  (`Lowered` live 2.92 → 4.20 MB, overall peak 5,291,324). Rounding the
  reserve up to the capacity doubling would reach anyway keeps the
  post-install capacities as they were and still removes the parse's
  doubling transient. The spec's ~0.25 MB tail-slack saving was not
  taken.
- Merged, Tasks 7 and 8 save slightly more than the sum of their
  solo savings (−1,207,108 against −865,176 − 277,820 = −1,142,996).
- Without its `shrink()`, Task 8's blob would sit at the next power of
  two (262,144 bytes for 154,668), because `text.reserve` rounds up
  through `rtTextGrow`; the peak would have been 4,640,964.

**Where the rtbake peak is now** (`scripts/memcensus.sh --rtbake
--at-peak examples/bookmarks.cla`, Task 10). The peak moved from the
bake parse to building the resource fork after segment 4:

```
memprobe: Built fork | live68k=3384824 peak68k=3668312
memprobe: TOTAL | peakAll68k=3668312
memprobe: peakcensus at live68k=3668312
```

The runner-up is `Parsed user program` (peak68k 3,372,076). Top 10 at
the peak moment (the census snapshot is exact, not a phase boundary):

| #  | Global             |     Bytes |  Count | Elem size |    Cap |
|----|--------------------|----------:|-------:|----------:|-------:|
| 1  | `cv_irExprs`       | 1,310,720 |  29492 |        40 |  32768 |
| 2  | `cv_irStmts`       |   229,376 |   7845 |        28 |   8192 |
| 3  | `cv_cgObjHoles`    |   196,608 |   3682 |        48 |   4096 |
| 4  | `cv_strIndex`      |   163,840 |   3349 |         4 |   4096 |
| 5  | `cv_cgObjRunBytes` |   154,668 | 154668 |         1 | 154668 |
| 6  | `cv_a68Items`      |   147,456 |    337 |        72 |   2048 |
| 7  | `cv_irTypes`       |   131,072 |   4348 |        16 |   8192 |
| 8  | `cv_strBlob`       |    65,536 |  42003 |         1 |  65536 |
| 9  | `cv_irLocals`      |    65,536 |   3062 |        16 |   4096 |
| 10 | `cv_cgSizeMemo`    |    32,768 |   4348 |         4 |   8192 |

- No bake buffer or parse staging is live at the peak.
- `irExprs` alone is 36% of the peak: 40-byte entries, 29,492 used.
  That, `irStmts` and `irTypes` are Wave 3's narrow-scalar targets.
- The compact pool is now 65,536 bytes of blob for 3,349 strings, plus
  `strIndex`, where Wave 1 had 1 MB of 256-byte slots.
- `a68Items` holds 337 items at the peak, against the ~15k per segment
  that §6's Wave 2 scope counted before per-function encode.

**Mac IIcx per-phase** (`tests/mactest/snow/clarusc_memprobe.sh`, same
machine and input as §9.1 and §9.2; saved log
`build-run/memprobe-saved/clarusc_memprobe.wave2.log`; one compile per
boot; 5/5 PASS in 367 s). "Used" is measured from each run's own launch
free: Wave 2's launch free is 48114 KB (zone 48398 KB, the same as
Wave 1). The launch probe runs before Task 5's `MoreMasters` loop, so
every Wave 2 "used" figure includes its ~40 KB of master pointers.

| Point                      | W1 free KB | W2 free KB | W1 used KB | W2 used KB | W2 − W1 KB | W1 ticks | W2 ticks |
|----------------------------|-----------:|-----------:|-----------:|-----------:|-----------:|---------:|---------:|
| pre-compile (CLIR read)    |      43990 |      43897 |       4076 |       4217 |       +141 |        — |        — |
| Parsed user program        |      42158 |      43381 |       5908 |       4733 |      −1175 |      465 |      130 |
| Checked user program       |      41910 |      43134 |       6156 |       4980 |      −1176 |      690 |      171 |
| Installed baked runtime    |      41917 |      43113 |       6149 |       5001 |      −1148 |      507 |      248 |
| Lowered                    |      41654 |      42881 |       6412 |       5233 |      −1179 |      190 |      114 |
| Shaken                     |      41619 |      42814 |       6447 |       5300 |      −1147 |      534 |      456 |
| Measured                   |      40808 |      42127 |       7258 |       5987 |      −1271 |    37860 |    16412 |
| Packed 4 segments          |      40806 |      42125 |       7260 |       5989 |      −1271 |      358 |      202 |
| Emitted segment 1          |      40297 |      42050 |       7769 |       6064 |      −1705 |    16005 |     6202 |
| Emitted segment 2          |      40267 |      42019 |       7799 |       6095 |      −1704 |     2588 |     2166 |
| Emitted segment 3          |      40227 |      41981 |       7839 |       6133 |      −1706 |     3699 |     2820 |
| Emitted segment 4          |      40217 |      41970 |       7849 |       6144 |      −1705 |     2752 |     2014 |
| **Built fork (low point)** |      40089 |      41842 |   **7977** |   **6272** |  **−1705** |     2341 |     1899 |
| Finished                   |      40190 |      41942 |       7876 |       6172 |      −1704 |        — |        — |
| **Compile total**          |            |            |            |            |            |    68040 |    32864 |

| Metric                                      |  Wave 0 |  Wave 1 | Wave 2 |
|---------------------------------------------|--------:|--------:|-------:|
| Launch→low heap used (KB)                   |   12035 |    7977 |   6272 |
| Stack high-water (KB of 737 KB reserve)     |       — |     187 |    187 |
| Compile ticks (total)                       |   89619 |   68040 |  32864 |
| Compile wall clock (guest)                  |       — | 18m 54s |  9m 7s |
| "Verifying Baked Runtime" → "Starting" span | 18m 46s |  5m 28s | 2m 01s |

- **Launch→low heap used: 7977 KB → 6272 KB, −1705 KB (−21.4%)**;
  −5763 KB (−47.9%) from Wave 0. The low point is still `Built fork`.
  Without the ~40 KB of `MoreMasters` preallocation the like-for-like
  saving is about 1745 KB. Free equals max to within 2 KB at every
  point.
- **Stack:** high-water 187 KB of 737 KB, unchanged.
- **The re-parse span is 2m 01s** (14:48:08 → 14:50:09; Wave 1:
  5m 28s). It is still outside the compile ticks (§9.2). Task 7's
  progressive free copies the remaining CLIR tail at each removal, and
  that did not slow the parse on this machine; the SE, at 8 MHz, is
  not measured.
- **`Emitted segment 1` costs +75 KB over `Packed` (Wave 1: +509 KB)
  and 6202 ticks (Wave 1: 16005).** Per-function encode (Task 3)
  removed Wave 1's `a68Items` regrowth. Segments 2–4 and `Built fork`
  cost +31/+38/+11/+128 KB, as in Wave 1 (+30/+40/+10/+128).
- **`Measured` costs +687 KB over `Shaken`** (Wave 1: +811 KB) and
  16412 ticks (Wave 1: 37860).
- **The front end:** `Parsed` is 1175 KB below Wave 1 and the gap holds
  through `Shaken`. The box sizes (Task 9, which only this measurement
  can see, spec R6), the compact pool, and the bake parse pre-size and
  progressive free all land here; this run cannot separate them. After
  `Parsed`, the phase deltas match Wave 1 to within about 30 KB until
  `Measured`.

Observations, not claims:

- **`pre-compile` is +141 KB above Wave 1.** About 40 KB of it is
  `MoreMasters`. The other ~100 KB is not attributed; it may be the CLIR
  read or startup allocations sized differently. It is gone by
  `Parsed`, so it does not touch the low point.
- **The ticks roughly halved (32864 vs 68040), including in phases
  Wave 2 did not target**: `Checked` 690 → 171, `Installed` 507 → 248,
  `Lowered` 190 → 114. Guest ticks should not depend on fast-forward
  speed, but this is one run per side. Fewer Memory Manager moves
  (smaller boxes, preallocated master pointers, pre-sized lists) is
  plausible and not established.
- **The host gate and the IIcx differ by ~2.7 MB at the low point**
  (host peak 3,668,312 bytes = 3582 KB; IIcx 6272 KB used). §9.1's
  calibration charged that kind of gap to what only the Mac holds: the
  1,923,629-byte CLIR resource (1879 KB, read and never released until
  Wave 4) and ~1 MB of CODE segments loaded after launch and never
  unloaded. Those two terms would account for about 2.9 MB of it, but
  neither was re-measured this wave, and the host counts host
  box/element sizes where the Mac now uses Task 9's 68k ones. It is an
  open question for Waves 3 and 4 (`docs/TODO.md`).

### 9.4 Wave 3 measurements (2026-09-29)

All of these come from branch `se-wave3-narrow-scalars`. The wave spec
is `2026-09-28-se-wave3-narrow-scalars-design.md`. The rulings are in
`docs/HISTORY.md`'s Wave 3 entry. Units are as in §9.1.

**Host memory gate** (`tests/memgate/budget.txt`; 68k-equivalent bytes,
H = 8; identical across three runs):

| Subcase                      | Wave 2 peak | Wave 3 peak |   Change | Wave 3 budget |
|------------------------------|------------:|------------:|---------:|--------------:|
| `bookmarks_rtbake` (primary) |   3,668,312 |   3,399,176 | −269,136 |     3,433,168 |
| `bookmarks_src`              |   7,639,484 |   7,377,444 | −262,040 |     7,451,219 |
| `hello_src`                  |   7,570,224 |   7,308,336 | −261,888 |     7,381,420 |

- **The 3.5 MB target (3,670,016) is met**, with 270,840 bytes (7.4%)
  to spare. The wave spec's §1 number stands.
- **About 75 KB of it is host-only.** The host lays out C structs,
  which align an `int` to 4 bytes where the 68k aligns it to 2, so the
  host had more padding for the arena reorder to remove: it took the
  host `IRExpr` 36 → 32 bytes and `A68Item` 72 → 68. The 68k `IRExpr`
  goes only 32 → 30, and its `A68Item` does not change. At 32,768 `irExprs` slots and 2048 `a68Items` slots that
  is about 64 KB + 8 KB the gate credits and the Mac does not see
  (`budget.txt`'s change-log line says so).

**What each step bought** (`bookmarks_rtbake` from `$WORK`, as in
§9.3). Tasks 1–9 changed the language, the runtime and the generated
code, not the compiler's own arenas; the saving is all Task 10.

| Change                                                     | `bookmarks_rtbake` | `bookmarks_src` | `hello_src` |
|------------------------------------------------------------|-------------------:|----------------:|------------:|
| Wave 2 final                                               |          3,668,312 |       7,639,484 |   7,570,224 |
| Wave A2 tip (Tasks 1–4) = Task 5 snapshot                  |          3,669,528 |       7,640,100 |   7,570,992 |
| Wave B tip (Tasks 6–8)                                     |          3,669,892 |       7,640,100 |   7,570,992 |
| Task 9: 2-byte enums in the runtime and generated code     |          3,670,024 |       7,640,100 |   7,570,992 |
| Task 10 step 1: snapshot regen (compiler has 2-byte enums) |          3,538,440 |       7,508,516 |   7,439,408 |
| Task 10 step 3: enum fields grouped in `IRExpr`/`A68Item`  |          3,399,176 |       7,377,444 |   7,308,336 |
| Tasks 11–13: rename, removal, final regen, ratchet         |          3,399,176 |       7,377,444 |   7,308,336 |

- Tasks 1–9 raised the peak by 1,712 bytes, from a larger runtime
  (the narrow form checks, serializer v2, the 2-byte enum UI accesses).
- The regeneration alone is −131,584: until then `clarusc-current` was
  emitted by a snapshot that still laid enums out as 4 bytes.
- The reorder is −139,264. Before it, `IRExpr` was
  `kind; a, b, name, intVal; global; convOp; ty, next; argCopy`, 36
  bytes on the host with the two enums apart; after it `kind, convOp`
  lead and the two `bool`s trail (32 bytes). `IRStmt` and `IRType` hold
  one enum each, so reordering gains nothing there. No explicit `uint8`
  field was adopted: `bool` fields are already `uint8_t` in C.

**Where the rtbake peak is now** (`scripts/memcensus.sh --rtbake
--at-peak examples/bookmarks.cla`, Task 13). The peak is still at
`Built fork`. Top entries at the peak moment:

| #   | Global             |     Bytes |  Count | Elem size |    Cap |
|-----|--------------------|----------:|-------:|----------:|-------:|
| 1   | `cv_irExprs`       | 1,048,576 |  29692 |        32 |  32768 |
| 2   | `cv_irStmts`       |   229,376 |   7889 |        28 |   8192 |
| 3   | `cv_cgObjHoles`    |   196,608 |   3691 |        48 |   4096 |
| 4   | `cv_strIndex`      |   163,840 |   3360 |         4 |   4096 |
| 5   | `cv_cgObjRunBytes` |   155,788 | 155788 |         1 | 155788 |
| 6   | `cv_a68Items`      |   139,264 |    341 |        68 |   2048 |
| 7   | `cv_irTypes`       |   131,072 |   4348 |        16 |   8192 |
| 8   | `cv_strBlob`       |    65,536 |  42165 |         1 |  65536 |
| 9   | `cv_irLocals`      |    65,536 |   3072 |        16 |   4096 |
| 10  | `cv_cgSizeMemo`    |    32,768 |   4348 |         4 |   8192 |

- `irExprs` is still the largest single entry, 31% of the peak, and
  29,692 of its 32,768 slots are used, so the next doubling is close.
- `cgObjHoles` (48 bytes, all `int` plus one `bool`, no enums) is the
  next narrowing candidate: `uint8` kind/class/op/mode fields. That is
  out of this wave's scope (N6 narrows no index field, and these are
  not enums).

**Mac IIcx per-phase** (`tests/mactest/snow/clarusc_memprobe.sh`, same
machine and input as §9.1–§9.3; saved log
`build-run/memprobe-saved/clarusc_memprobe.wave3.log`; one compile per
boot; 5/5 PASS in 509 s). "Used" is measured from each run's own launch
free: Wave 3's is 48177 KB (Wave 2: 48114 KB; zone 48398 KB in both).

| Point                      | W2 free KB | W3 free KB | W2 used KB | W3 used KB | W3 − W2 KB | W2 ticks | W3 ticks |
|----------------------------|-----------:|-----------:|-----------:|-----------:|-----------:|---------:|---------:|
| pre-compile (CLIR read)    |      43897 |      43949 |       4217 |       4228 |        +11 |        — |        — |
| Parsed user program        |      43381 |      43594 |       4733 |       4583 |       −150 |      130 |      174 |
| Checked user program       |      43134 |      43316 |       4980 |       4861 |       −119 |      171 |      175 |
| Installed baked runtime    |      43113 |      43327 |       5001 |       4850 |       −151 |      248 |      206 |
| Lowered                    |      42881 |      43093 |       5233 |       5084 |       −149 |      114 |      114 |
| Shaken                     |      42814 |      43026 |       5300 |       5151 |       −149 |      456 |      500 |
| Measured                   |      42127 |      42350 |       5987 |       5827 |       −160 |    16412 |    16371 |
| Packed 4 segments          |      42125 |      42349 |       5989 |       5828 |       −161 |      202 |      195 |
| Emitted segment 1          |      42050 |      42273 |       6064 |       5904 |       −160 |     6202 |     6017 |
| Emitted segment 2          |      42019 |      42241 |       6095 |       5936 |       −159 |     2166 |     2141 |
| Emitted segment 3          |      41981 |      42204 |       6133 |       5973 |       −160 |     2820 |     2818 |
| Emitted segment 4          |      41970 |      42193 |       6144 |       5984 |       −160 |     2014 |     2260 |
| **Built fork (low point)** |      41842 |      42066 |   **6272** |   **6111** |   **−161** |     1899 |     4296 |
| Finished                   |      41942 |      42166 |       6172 |       6011 |       −161 |        — |        — |
| **Compile total**          |            |            |            |            |            |    32864 |    35298 |

| Metric                                      |  Wave 0 |  Wave 1 | Wave 2 | Wave 3 |
|---------------------------------------------|--------:|--------:|-------:|-------:|
| Launch→low heap used (KB)                   |   12035 |    7977 |   6272 |   6111 |
| Stack high-water (KB of 737 KB reserve)     |       — |     187 |    187 |    187 |
| Compile ticks (total)                       |   89619 |   68040 |  32864 |  35298 |
| Compile wall clock (guest)                  |       — | 18m 54s |  9m 7s | 9m 48s |
| "Verifying Baked Runtime" → "Starting" span | 18m 46s |  5m 28s | 2m 01s | 1m 53s |

- **Launch→low heap used: 6272 KB → 6111 KB, −161 KB (−2.6%)**;
  −5924 KB (−49.2%) from Wave 0. The low point is still `Built fork`.
  Free equals max to within 2 KB at every point.
- **The saving is in place by `Parsed`** (−150 KB) and holds at
  −149 to −161 KB through `Finished`. That fits the arenas being
  smaller from the moment the bake parse fills them. It is less than
  the host's −269 KB minus the ~75 KB host-only share (~194 KB); this
  run does not say where the other ~33 KB went.
- **Stack:** high-water 187 KB of 737 KB, unchanged.
- **The re-parse span is 1m 53s** (04:35:17 → 04:37:10; Wave 2:
  2m 01s), still outside the compile ticks.

Observations, not claims:

- **The compile took 2434 more ticks (35298 vs 32864), and 2397 of
  them are `Built fork`** (1899 → 4296 ticks, 31 s → 1m 11s guest).
  Every other phase together moved by +37 ticks, within ±5% each except
  `Parsed` (+44), `Shaken` (+44) and `Emitted segment 4` (+246, while
  segment 1 fell 185). `Built fork` writes the output's resource fork,
  and its heap delta (+127 KB) matches Wave 2's (+128 KB), so the extra
  time is not more work in memory.
- The wave does make ClarusC's own code slightly slower and larger:
  every 2-byte enum load is `CLR.L D0; MOVE.W src,D0` (4 bytes) where it
  was one 2-byte `MOVE.L`, and a 2-byte enum local loses the size-4
  store/reload peephole (Task 9; `docs/TODO.md`). That cost would spread
  over every phase. The per-phase ticks do not show it above the
  run-to-run noise (Wave 0 saw 81753 vs 89619 ticks for the same
  compile), so it cannot account for a jump concentrated in one
  disk-writing phase. One run per side; not established.
- **Launch free is 63 KB higher than Wave 2** (48177 vs 48114 KB), and
  `pre-compile` used is +11 KB. Neither is attributed.
- **The host gate and the IIcx still differ by ~2.7 MB at the low
  point** (host peak 3,399,176 bytes = 3320 KB; IIcx 6111 KB used), the
  gap §9.3 left open for Wave 4 (`docs/TODO.md`).

### 9.5 Wave 4 measurements (2026-09-29)

All of these come from branch `se-wave4-lazy-library`. The wave spec
is `2026-09-29-se-wave4-lazy-library-design.md`. The rulings are in
`docs/HISTORY.md`'s Wave 4 entry. Units are as in §9.1.

**Host memory gate** (`tests/memgate/budget.txt`; 68k-equivalent bytes,
H = 8; identical across three runs):

| Subcase                      | Wave 3 peak | Wave 4 peak |     Change | Wave 4 budget |
|------------------------------|------------:|------------:|-----------:|--------------:|
| `bookmarks_rtbake` (primary) |   3,399,176 |   1,194,744 | −2,204,432 |     1,206,692 |
| `bookmarks_src`              |   7,377,444 |   6,923,184 |   −454,260 |     6,992,416 |
| `hello_src`                  |   7,308,336 |   6,919,612 |   −388,724 |     6,988,809 |

- **The 1.2 MB target (1,258,291) is met**, with 63,547 bytes (5.1%)
  to spare. The wave spec's §1 number stands.
- `hello_src`'s change is net of the log/trace detour's +69 KB, which
  landed between the waves (it was at 7,377,464, 99.9% of its budget,
  when Wave 4 started).

**What each step bought** (`bookmarks_rtbake` from `$WORK`, as in
§9.3; "—" = not measured separately):

| Change                                                          | `bookmarks_rtbake` | `bookmarks_src` | `hello_src` |
|-----------------------------------------------------------------|-------------------:|----------------:|------------:|
| Wave 3 final                                                    |          3,399,176 |       7,377,444 |   7,308,336 |
| Wave 4 start (after the log/trace detour)                       |          3,404,020 |       7,381,036 |   7,377,464 |
| Wave A (Tasks 1–4) + Task 5 snapshot                            |          3,374,496 |       6,923,320 |   6,919,748 |
| Task 6: CLIR v9, no IR bodies, lazy object code                 |          1,827,512 |       6,923,304 |   6,919,732 |
| Task 7: library in ClarusC's data fork                          |          1,827,512 |       6,923,612 |   6,920,040 |
| Task 8 step 1: pre-sized fork, segments released as copied      |          1,581,420 |               — |           — |
| Task 8 step 2: flat per-function pool refs                      |          1,434,984 |               — |           — |
| Task 8 step 3: `a68Items`/`bkObjBuf` released before the fork   |          1,269,936 |               — |           — |
| Task 8 step 4: `irTypes` shrink, `cgSizeMemo` +64 growth; final |          1,194,744 |       6,923,184 |   6,919,612 |

- **The from-source saving is Task 4** (−458,752 on both: `toks`
  393,216 + `lexSrc` 65,536, freed after the last parse and before
  lowering, where that peak sits). Task 4's reachable-only codegen
  lists were −72,900 on `bookmarks_rtbake`.
- Task 1 (+22 KB: object code for the 26 formerly tainted functions)
  and Task 2 (+21 KB: the resident call-graph summary) raised the
  rtbake peak before Task 6 removed the IR bodies (−1,546,984).
  Task 6 also found a dead 131 KB `bkLoadBuf` box that survived to
  the peak.
- **Lazy read** (`tests/bake/lazyread.sh`, measured at Task 6): a
  `hello-mac` compile reads 278,211 bytes of the 775,953-byte 68k
  library (39,537 of 293,205 bytes of object code), `bookmarks` reads
  389,457 (150,783). Neither reads a runtime IR body; CheckerSymbols
  and FieldInfo are read only under `--testapi`.

**Where the rtbake peak is now** (`scripts/memcensus.sh --rtbake
--at-peak examples/bookmarks.cla`, Task 8). The peak moved from
`Built fork` to `Emitted segment 4`. Top entries at the peak moment:

| #   | Global           |   Bytes | Count |   Cap | Note                  |
|-----|------------------|--------:|------:|------:|-----------------------|
| 1   | `cv_strIndex`    | 163,840 |  3388 |  4096 | `map of int`          |
| 2   | `cv_bkObjBuf`    | 150,783 |     — | exact | reachable object code |
| 3   | `cv_a68Items`    | 139,264 |    17 |  2048 | 68 B per item         |
| 4   | `cv_irTypes`     |  70,912 |  4369 |  4432 | 16 B per type         |
| 5   | `cv_strBlob`     |  65,536 | 42507 | 65536 |                       |
| 6   | `cv_irLocals`    |  32,768 |  1364 |  2048 |                       |
| 7   | `cv_a68BytesOut` |  32,768 | 16330 | 32768 |                       |

- `irExprs` (1 MB at Wave 3's peak) and `irStmts` are gone from the
  top: runtime bodies are no longer installed.
- `strIndex` is now the largest entry. An open-addressed index over
  `strBlob`/`strOff` would save ~130 KB, but it rewrites `intern`, the
  hot path of every compile, so it is left for Wave 5.
- `a68Items` is sized by the largest function during emission; the
  68-byte record is the lever left.

**Mac IIcx per-phase** (`tests/mactest/snow/clarusc_memprobe.sh`, same
machine and input as §9.1–§9.4; saved log
`build-run/memprobe-saved/clarusc_memprobe.wave4.log`; one compile per
boot). "Used" is measured from each run's own launch free: Wave 4's is
48122 KB (Wave 3: 48177 KB); zone 48382 KB (Wave 3: 48398 KB). The
compile took the bake path (`clarusc: bake path (CLIR library in the
data fork)`), so `pre-compile` is now only the header check.

| Point                   | W3 free KB | W4 free KB | W3 used KB | W4 used KB | W4 − W3 KB | W3 ticks | W4 ticks |
|-------------------------|-----------:|-----------:|-----------:|-----------:|-----------:|---------:|---------:|
| pre-compile             |      43949 |      47851 |       4228 |        271 |      −3957 |        — |        — |
| Parsed user program     |      43594 |      47003 |       4583 |       1119 |      −3464 |      174 |      184 |
| Checked user program    |      43316 |      46757 |       4861 |       1365 |      −3496 |      175 |      196 |
| Installed baked runtime |      43327 |      46729 |       4850 |       1393 |      −3457 |      206 |      269 |
| Lowered                 |      43093 |      46518 |       5084 |       1604 |      −3480 |      114 |      125 |
| Shaken                  |      43026 |      46332 |       5151 |       1790 |      −3361 |      500 |      477 |
| Measured                |      42350 |      45868 |       5827 |       2254 |      −3573 |    16371 |     1079 |
| Packed 4 segments       |      42349 |      45866 |       5828 |       2256 |      −3572 |      195 |      135 |
| Emitted segment 1       |      42273 |      45761 |       5904 |       2361 |      −3543 |     6017 |     1056 |
| Emitted segment 2       |      42241 |      45728 |       5936 |       2394 |      −3542 |     2141 |      275 |
| Emitted segment 3       |      42204 |      45691 |       5973 |       2431 |      −3542 |     2818 |      427 |
| Emitted segment 4       |      42193 |      45679 |       5984 |   **2443** |      −3541 |     2260 |      619 |
| Built fork              |      42066 |      45954 |   **6111** |       2168 |      −3943 |     4296 |      131 |
| Finished                |      42166 |      45958 |       6011 |       2164 |      −3847 |        — |        — |
| **Compile total**       |            |            |            |            |            |    35298 |     4993 |

| Metric                                      |  Wave 0 |  Wave 1 |  Wave 2 |  Wave 3 |  Wave 4 |
|---------------------------------------------|--------:|--------:|--------:|--------:|--------:|
| Launch→low heap used (KB)                   |   12035 |    7977 |    6272 |    6111 |    2443 |
| Stack high-water (KB of reserve)            |       — | 187/737 | 187/737 | 187/737 | 194/752 |
| Compile ticks (total)                       |   89619 |   68040 |   32864 |   35298 |    4993 |
| Compile wall clock (guest)                  |       — | 18m 54s |   9m 7s |  9m 48s |  1m 23s |
| "Verifying Baked Runtime" → "Starting" span | 18m 46s |  5m 28s |  2m 01s |  1m 53s |     27s |

- **Launch→low heap used: 6111 KB → 2443 KB, −3668 KB (−60.0%)**;
  −9592 KB (−79.7%) from Wave 0. The low point moved from `Built fork`
  to `Emitted segment 4`, as on the host: Task 8 releases `a68Items`
  and `bkObjBuf` before the fork, and `Built fork` now frees 275 KB.
- **The saving is in place by `pre-compile`** (−3957 KB: the 1879 KB
  CLIR resource is no longer read or hashed) and holds
  at −3361 to −3573 KB through `Emitted segment 4`.
- **The SE target is 2221 KB** (§9.1). The IIcx low point is 222 KB
  above it. That is Wave 5's gap, before its own code and stack levers.
- **Stack:** high-water 194 KB (Wave 3: 187 KB); the reserve reads
  752 KB (Wave 3: 737 KB). Neither change is attributed.
- **The "Verifying → Starting" span is 27 s** (18:26:21 → 18:26:48;
  Wave 3: 1m 53s). The whole-body hash is gone (the wave spec's W6: a
  header stamp instead) and nothing is re-parsed; what the 27 s is
  spent on is not broken down.

Observations, not claims:

- **Compile ticks fell 86% (35298 → 4993).** `Measured` (16371 →
  1079), the four `Emitted segment` phases (13236 → 2377) and `Built
  fork` (4296 → 131) account for almost all of it. That fits the 26
  formerly tainted runtime functions being pasted instead of generated
  (Task 1), per-function lists for reachable functions only (Task 4)
  and the pre-sized fork with no data copy (Task 8), but it is not
  attributed per task. Ticks are unreliable under fast-forward
  (`docs/TODO.md`), though not by an order of magnitude. One run per
  side.
- `Parsed` adds 848 KB over `pre-compile` (Wave 3: 355 KB). Wave 3's
  `pre-compile` came right after reading the library resource, so the
  two deltas do not measure the same heap state; not attributed.
- **The host gate and the IIcx now differ by ~1.3 MB at the low
  point** (host 1,194,744 bytes = 1167 KB; IIcx 2443 KB used), down
  from ~2.7 MB. The CLIR resource term of Wave 0's calibration is gone;
  the ~1 MB of CODE loaded after launch would cover most of the rest,
  but it was not re-measured (`docs/TODO.md`).

### 9.6 Wave 5 measurements (2026-09-30)

All of these come from branch `se-wave5-close`. The wave spec is
`2026-09-30-se-wave5-close-design.md`. The rulings are in
`docs/HISTORY.md`'s Wave 5 entry. Units are as in §9.1. Saved logs, in
`build-run/memprobe-saved/`:

- `clarusc_memprobe.wave5-se.log`: the SE, final tip (`16e29ff9`);
- `clarusc_memprobe.wave5-se-pre7a.log`: the SE at `c4ebb7d3`, before
  Task 7a;
- `clarusc_memprobe.wave5.log`: the IIcx, final tip;
- `clarusc_memprobe.wave4.log`: the IIcx, Wave 4 (§9.5).

One compile per boot, one run per side. Every compile took the bake
path (`clarusc: bake path (CLIR library in the data fork)`).

**Host memory gate** (`tests/memgate/budget.txt`). Wave 5 did not target
the host heap, and the budgets are unchanged:

| Subcase                      | Wave 4 peak | Wave 5 peak | Change |    Budget |
|------------------------------|------------:|------------:|-------:|----------:|
| `bookmarks_rtbake` (primary) |   1,194,744 |   1,194,728 |    −16 | 1,206,692 |
| `bookmarks_src`              |   6,923,184 |   6,923,184 |      0 | 6,992,416 |
| `hello_src`                  |   6,919,612 |   6,919,612 |      0 | 6,988,809 |

- The −16 bytes were not ratcheted: 1% of the new value moves the budget
  by 17 bytes, and the drift may predate the wave.

**The SE, the acceptance machine** (Snow SE, 4 MB, System 6.0.8,
single-app through boot-block autostart, D11). The "spike" column is
Wave 4's tip plus a scripted disk mount, run on 2026-09-30 (the wave
spec's §1); it recorded only these points. "Used" is measured from each
run's own launch free: 3154 KB for Wave 5 and 2783 KB for the spike. The
zones are 3383 KB and 3038 KB.

| Point                   | Spike free KB | W5 free KB | Spike used KB | W5 used KB | W5 − spike KB | W5 ticks |
|-------------------------|--------------:|-----------:|--------------:|-----------:|--------------:|---------:|
| launch                  |          2783 |       3154 |             0 |          0 |             — |        — |
| pre-compile             |             — |       2885 |             — |        269 |             — |        — |
| Parsed user program     |          1666 |       2165 |          1117 |        989 |          −128 |      381 |
| Checked user program    |             — |       1983 |             — |       1171 |             — |      524 |
| Installed baked runtime |             — |       1987 |             — |       1167 |             — |      635 |
| Lowered                 |             — |       1872 |             — |       1282 |             — |      357 |
| Shaken                  |             — |       1685 |             — |       1469 |             — |     1193 |
| Measured                |           531 |       1286 |          2252 |       1868 |          −384 |     4079 |
| Packed 4 segments       |             — |       1285 |             — |       1869 |             — |      493 |
| Emitted segment 1       |             — |       1211 |             — |       1943 |             — |     3509 |
| Emitted segment 2       |             — |       1179 |             — |       1975 |             — |     1012 |
| Emitted segment 3       |             — |       1142 |             — |       2012 |             — |     1608 |
| Emitted segment 4       |           342 |   **1130** |          2441 |   **2024** |          −417 |     2359 |
| Built fork              |           617 |       1404 |          2166 |       1750 |          −416 |      288 |
| Finished                |             — |       1409 |             — |       1745 |             — |        — |
| **Compile total**       |               |            |               |            |               |    16515 |

- **D1 is met.** ClarusC compiles `bookmarks.cla` on the SE with its
  lowest free at **1130 KB** (`Emitted segment 4`), against the spike's
  342 KB (+788 KB). Heap used at that point is 2024 KB, 197 KB under
  Wave 0's 2221 KB target (§9.1). That target assumed a 64 KB stack
  and all CODE resident, so the free figure is the one gated.
- **Where the margin came from.** The zone grew 345 KB, which is the
  stack reserve falling from 736 KB to 392 KB (W3). Heap used fell
  128 KB by `Parsed` and 417 KB by the low point. That fits the 465 KB
  of CODE that W2 removed, since ClarusC's segments load into the
  heap, but it is not attributed per segment.
- **The floor is 1017 KB** (`tests/mactest/snow/se_floor.txt`,
  floor(0.9 × 1130)). The re-run printed `PASS se_floor`. It is
  measured on Snow's clean System 6 image; Andrew's real SE has more
  INITs/cdevs and less free memory.
- **Before Task 7a** (`c4ebb7d3`, `.wave5-se-pre7a.log`), every point
  from `Lowered` on read the same free KB to within 1 KB. At
  `pre-compile`, `Checked` and `Installed` the final tip has 32–33 KB
  less free; not attributed. The stack high-water was 128 KB there
  (see below).

**The Mac IIcx** (same machine and input as §9.1–§9.5; saved log
`clarusc_memprobe.wave5.log`). Launch free is 48502 KB (Wave 4:
48122 KB) and the zone 48726 KB (Wave 4: 48382 KB, +344 KB: the stack
reserve).

| Point                   | W4 free KB | W5 free KB | W4 used KB | W5 used KB | W5 − W4 KB | W4 ticks | W5 ticks |
|-------------------------|-----------:|-----------:|-----------:|-----------:|-----------:|---------:|---------:|
| pre-compile             |      47851 |      48231 |        271 |        271 |          0 |        — |        — |
| Parsed user program     |      47003 |      47511 |       1119 |        991 |       −128 |      184 |      136 |
| Checked user program    |      46757 |      47329 |       1365 |       1173 |       −192 |      196 |      159 |
| Installed baked runtime |      46729 |      47333 |       1393 |       1169 |       −224 |      269 |      191 |
| Lowered                 |      46518 |      47217 |       1604 |       1285 |       −319 |      125 |      101 |
| Shaken                  |      46332 |      47031 |       1790 |       1471 |       −319 |      477 |      532 |
| Measured                |      45868 |      46632 |       2254 |       1870 |       −384 |     1079 |     1145 |
| Packed 4 segments       |      45866 |      46630 |       2256 |       1872 |       −384 |      135 |      138 |
| Emitted segment 1       |      45761 |      46556 |       2361 |       1946 |       −415 |     1056 |      906 |
| Emitted segment 2       |      45728 |      46524 |       2394 |       1978 |       −416 |      275 |      277 |
| Emitted segment 3       |      45691 |      46487 |       2431 |       2015 |       −416 |      427 |      427 |
| Emitted segment 4       |      45679 |      46475 |   **2443** |   **2027** |       −416 |      619 |      626 |
| Built fork              |      45954 |      46749 |       2168 |       1753 |       −415 |      131 |      113 |
| Finished                |      45958 |      46754 |       2164 |       1748 |       −416 |        — |        — |
| **Compile total**       |            |            |            |            |            |     4993 |     4771 |

- **Launch→low heap used: 2443 KB → 2027 KB, −416 KB (−17.0%)**;
  −10008 KB (−83.2%) from Wave 0's 12035 KB.
- The SE and the IIcx agree to within 3 KB of heap used at every
  point (2024 vs 2027 KB at the low point).

**Summary**

| Metric                                      | W4 IIcx | W5 IIcx | Spike SE |   W5 SE |
|---------------------------------------------|--------:|--------:|---------:|--------:|
| Launch→low heap used (KB)                   |    2443 |    2027 |     2441 |    2024 |
| Lowest free (KB)                            |   45679 |   46475 |      342 |    1130 |
| Stack high-water (KB of reserve)            | 194/752 | 163/408 |  128/736 |  49/392 |
| Compile ticks (total)                       |    4993 |    4771 |        — |   16515 |
| Compile wall clock (guest)                  |  1m 23s |  1m 19s |   4m 39s |  4m 35s |
| "Verifying Baked Runtime" → "Starting" span |     27s |     31s |        — | ~1m 13s |

**ClarusC.APPL's CODE** (the sum of every `CODE` resource, `CODE 0`
included; `tests/bake/clarusc_codesize.sh` holds it under 1,193,734):

| Build                                      |     CODE bytes | CODE resources |
|--------------------------------------------|---------------:|---------------:|
| Wave 0 baseline (§1)                       |       ~1.56 MB |             47 |
| Wave 5 start (Wave 4 compiler, `f5a38fc1`) |      1,607,548 |             50 |
| Task 2: table-driven `cg_free_globals`     |      1,141,980 |             36 |
| Task 6: snapshot build                     |      1,142,308 |             36 |
| Task 7a: cold abort helpers                | ~1,142,692 [a] |             36 |

[a] Task 7a measured `ClarusC.bin` at +384 bytes (1,143,808 →
1,144,192); the CODE sum was not re-taken.

- **−465,568 bytes (−29%) and 14 fewer segments.** The duplicated glue
  per segment, before and after W2 (Task 2's measurement, from the
  listing):

| Program            | Segments | free-globals B/seg | record walks B/seg | mul/div/mod B/seg | free-globals total |
|--------------------|---------:|-------------------:|-------------------:|------------------:|-------------------:|
| ClarusC (before)   |       49 |             10,972 |                432 |               352 |            537,628 |
| ClarusC (after)    |       35 |              2,404 |                432 |               352 |             84,140 |
| bookmarks (before) |        4 |                184 |                  0 |               352 |                736 |
| bookmarks (after)  |        4 |                136 |                  0 |               352 |                544 |

- ClarusC's 2,404-byte stub is a 1,512-byte table (377 entries) plus
  892 bytes of loop and nine kind bodies. Five kinds are list walks that
  differ only in the element release; a shared walk would save ~13 KB
  (`docs/TODO.md`). The record walks (21 KB in all) stay duplicated.

**Stack.** ClarusC's `app` section asks for `stack: 393216` (384 KB, W3:
2× the IIcx's Wave 4 high-water of 194 KB, rounded). The memprobe line
reads the region as 392 KB on the SE and 408 KB on the IIcx.

| Build                         | Machine | Reserve read (KB) | High-water (KB) |
|-------------------------------|---------|------------------:|----------------:|
| Wave 4 tip (§9.5)             | IIcx    |               752 |             194 |
| Spike (Wave 4 tip)            | SE      |               736 |             128 |
| Wave 5 `c4ebb7d3` (before 7a) | SE      |               392 |             128 |
| Wave 5 final (`16e29ff9`)     | SE      |               392 |              49 |
| Wave 5 final (`16e29ff9`)     | IIcx    |               408 |             163 |

- **Task 7a cut the frames.** At `c4ebb7d3`, `macresident_failed_compile`
  failed on the SE: its `badabort.cla` (40 nested `attempt`s) tripped
  `drvStackGuard` in the parser at 332 of 392 KB, before cg68k's own
  bail-depth abort. A controller probe (a 150-arm `else if` chain plus
  12 nested `if`s) tripped it at 331 KB. The cause: cg68k gave every
  native function a 4 × 512-byte big-temp floor (`cgBigTmpFloor`) on
  the real pass, so almost all of ClarusC's 2645 functions had frames
  of 2.1 KB or more. Task 7a keeps the floor on the measure pass only
  and moves cold abort strings out of the recursive walkers:

| Path, pass           |  Before | After | Reduction |
|----------------------|--------:|------:|----------:|
| else-if arm, parse   | 2.14 KB |  88 B |       24× |
| else-if arm, check   | 2.12 KB |  68 B |       31× |
| else-if arm, lower   | 2.13 KB |  84 B |       25× |
| else-if arm, cg68k   | 7.41 KB | 242 B |       31× |
| attempt level, parse | 8.56 KB | 348 B |       25× |
| attempt level, check | 6.36 KB | 218 B |       29× |
| attempt level, lower | 6.39 KB | 246 B |       26× |
| attempt level, cg68k | 7.41 KB | 246 B |       30× |

- After 7a on the SE: the probe compiled at a 51 KB high-water,
  `macresident_failed_compile`'s two compiles at 32 and 76 KB, and
  `bookmarks.cla` at 49 KB. `clarusc_deep` still reports `source too
  deeply nested` (at `c4ebb7d3` the guard fired at 333 of 392 KB).
  Every native program now uses about 2 KB less stack per active call;
  code bytes are unchanged.
- **The reserve is now generous.** V3's rule (2× the largest measured
  high-water) gives 2 × 163 = 326 KB. The reserve stays at 384 KB this
  wave (ruling); the rule is re-applied at the next ClarusC-affecting
  close (`docs/TODO.md`).

**Compile time** (recorded, not gated, D2): IIcx 4993 → 4771 ticks
(1m 23s → 1m 19s), within fast-forward noise. SE 4m 39s (spike, and
16,752 ticks at `c4ebb7d3`) → 4m 35s (16,515 ticks) at the final tip.
The "Verifying → Starting" span is ~1m 13s on the SE and 31 s on the
IIcx (Wave 4: 27 s).

Observations, not claims:

- The IIcx's stack high-water (163 KB) is over 3× the SE's (49 KB) for
  the same compile. System 7's own stack use is a candidate, but it is
  not measured.
- Launch free grew 380 KB on the IIcx and 371 KB on the SE, more than
  the 344 KB of stack reserve; the rest is not attributed.
