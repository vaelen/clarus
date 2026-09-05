# Language-runtime-cleanup Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Clear `docs/TODO.md`'s "Language features (needed)", "Compiler correctness / cleanup", "ABI / performance", and "Runtime / Toolbox robustness" sections in one phase: three new language features (array-literal initializers, window-owned menu sets, `file.openRF`) plus twenty mechanical fixes, with the `.s` goldens blessed exactly twice and the `clarusc.c` snapshot regenerated exactly once.

**Architecture:** Two waves. Wave 1 (Tasks 1-5, parallel) touches only `runtime/clarus/*.cla`, `runtime/host/*`, `toolbox/`, `testsuite/`, `tests/`, and `scripts/`, ending in bless #1 (Task 6) with the differential oracle proving every golden hunk is a runtime ripple. Wave 2 (Tasks 7-13, up to 5 in parallel, then Task 14) touches the compiler, ending in bless #2, the snapshot regen, the Snow bake gate, and the whole-branch review (Task 15). Both lanes run the SAME `.cla` runtime; `runtime/mac/rt_ui.c` is a frozen, never-linked oracle and is not edited.

**Tech Stack:** Clarus (compiler `clarusc/*.cla`, runtime `runtime/clarus/*.cla`), the C host runtime (`runtime/host/*.inc`, `rt.c`), POSIX-sh tests under `tests/`, Mini vMac for native boots, Snow for the System 7 bake gate.

**Spec:** `docs/superpowers/specs/2026-09-06-language-runtime-cleanup-design.md` — every task cites its spec section; read that section before starting the task. Where this plan and the spec differ, the plan's "Deviations from the spec" list in Global Constraints wins (the spec was patched to match when this plan was written).

## Global Constraints

- Branch `language-runtime-cleanup` off `main` at `14e2e0e` or later. Feature branch per plan; `main` stays green; merge only on Andrew's request.
- Implementation is subagent-driven. Andrew's ruling for this phase: implementers and reviewers may be `model: opus` (Opus 5); `sonnet` remains fine for small tasks and `haiku` for mechanical batch edits. Up to **5 implementers in parallel**, each in its own worktree under `.claude/worktrees/` created off the branch; the controller merges. State each subagent's model at dispatch. The top-level session does not write implementation code.
- `.cla` files may contain MacRoman bytes. NEVER use the Edit tool on a `.cla` file that contains them; use `LC_ALL=C sed` or a Python script writing bytes, then byte-diff (`git diff --stat` + `cmp`). Check first: `LC_ALL=C grep -c $'[\x80-\xff]' FILE`.
- Test scripts are `#!/bin/sh`, POSIX only (no arrays, `[[ ]]`, `local`, `echo -e`), start with `. "$(dirname "$0")/../lib.sh" || exit 2`, print `PASS <name>`/`FAIL <name>: <detail>` via `t_pass`/`t_fail`, end with `t_done`, exit 77 via `skip`/`require_env`/`require_tool` for a missing gate. `tests/lib.sh` is FROZEN.
- No test result cache; every `make test T=...` re-runs the selected scripts. `make -j tools bootstrap` first in a fresh checkout; `build-run/clarusc-current` is the current-source compiler after that.
- Per-task gate: `scripts/test-task.sh` (T1); add `--smoke` when the task touches `runtime/` or `clarusc/`. Only one Mini vMac boot at a time on this machine: before any `CLARUS_MAC_TESTS=1` run, `pgrep -x minivmac`; if one is running, wait or defer that proof to the wave-end task and say so in the report.
- **Blessing:** only Task 6 blesses in wave 1 and only Task 15 blesses in wave 2 (`CLARUS_CG68K_BLESS=1` for `testdata/cg68k/*.s`, the `emitui` regeneration loop, `CLARUS_BLESS_BEHAVIOR=1` for `.behavior`, `CLARUS_MAC_BLESS=1` only if a trace/snap golden legitimately moved). Every other task that sees a golden diff REPORTS it (paste `first_diff` output) and does not bless. A bless variable must be exactly `1`.
- **`testdata/run` fixtures** are exercised by T2's `selfhost/behavior` and `selfhost/crossgen` only, not T1. A task that adds one commits `<name>.cla` and `<name>.out` (stdout golden, produced by running it on the host: `scripts/clarus-run.sh testdata/run/<name>.cla > testdata/run/<name>.out`) and verifies by eye that the output is what the fixture asserts; the wave-end task creates the `.behavior` blob with `CLARUS_BLESS_BEHAVIOR=1` and checks that ONLY new `.behavior` files appear in `git status` (a modified pre-existing one is a regression, not a bless).
- **Snapshot regeneration** happens ONCE, in Task 15. Wave-2 tasks compile with `build-run/clarusc-current` (rebuilt from source by `make bootstrap`) and never touch `clarusc/clarusc.c`.
- **`clarusc/bake.cla` is edited in exactly two tasks** (7: array-literal pool section; 12: the window descriptor's `menuMask`). Both bump `bkFormatVersion` 7 -> 8 (whichever merges second keeps 8, one bump total). The 55-minute Snow `clarusc_bake` gate runs ONCE, in Task 15.
- **Suite case counts** are hand-maintained in four places per lane: the runner's `nTbCases`/`nCoreCases`, the boot scripts' `suite_report_check ... N` literal (`tests/mactest/toolbox_68k.sh`, `toolbox_jiggle.sh`, `coresuite_68k.sh`), and CLAUDE.md's growth-history sentence. A task adding a case bumps the runner constant and the boot-script literals by one RELATIVE TO WHAT IS ON THE BRANCH WHEN IT MERGES (Tasks 1 and 12 both add a toolbox case; Task 11 adds a core case). CLAUDE.md is updated once, in Task 15.
- **Deviations from the spec, all patched into it on 2026-09-06:** (1) the window property is spelled `menus: File, Edit` (colon form), so the parser is untouched; (2) a window's menu set is a 32-bit bitmask (`menuMask`, one int32 appended to the window descriptor, at most 31 menus per program) rather than a new blob section; (3) `runtime/mac/rt_ui.c` is never edited; (4) the `KArr` borrow ABI applies to arrays whose element carries no handle (`not cgNeedsRelease(t)`); a handle-bearing array parameter keeps by-value passing, decided by one shared predicate on both sides of the call; (5) an array argument that needs a copy and exceeds the 512-byte big-temp slot aborts the compile with a message naming the ceiling, the same way an oversized record does today.
- Commit messages end with the two attribution lines given in the session's system reminder.
- Task reports go to `.superpowers/sdd/2026-09-06-language-runtime-cleanup/task-N-report.md` (the SDD workspace is a phase record; never delete it).

---

## Wave 1 — runtime and harness (Tasks 1-5 in parallel, then Task 6)

### Task 1: Canvas dirty flag + `CanvasIdle` toolbox case (spec §2.1)

**Files:**
- Modify: `runtime/clarus/uidesc.cla` (~861 `overlay record RtUiCanvasBuf`; ~877 `const rtUiCanvasBufSize: int = 36`; the file-header comment naming 9 fields)
- Modify: `runtime/clarus/uiwidgets.cla` (~1369 `rtUiFlushBufferedCanvases`; the drawing ops `rtUiCanvasPattern` ~1532, `rtUiCanvasClear` ~1549, `rtUiCanvasLine` ~1569, `rtUiCanvasRect` ~1578, `rtUiCanvasFillCircle` ~1600, `rtUiCanvasCircle` ~1618, `rtUiCanvasDrawText` ~1630; `rtUiCanvasMake` ~1302)
- Modify: `runtime/clarus/ui.cla` (~1635 `rtUiFlushAllBuffered`'s call; ~1849 the update-path call inside `rtUiHandleUpdate`)
- Modify: `runtime/clarus/uitest.cla` (new `UiTestCanvasBlits(i: int): int` after `UiTestTextviewScroll` ~338)
- Modify: `testsuite/toolbox/harness.cla` (new window `IdleCanvasWin`), `testsuite/toolbox/runner.cla` (enum member `CanvasIdle`, name switch, `l.add`, dispatch arm, `nTbCases` +1), `tests/mactest/toolbox_files.txt`, `tests/bake/full_corpus_suite_toolbox.sh` (both lists: add `testsuite/toolbox/cases_canvasidle.cla` right after `cases_canvas.cla`), `tests/mactest/toolbox_68k.sh` and `tests/mactest/toolbox_jiggle.sh` (`suite_report_check` literal +1)
- Create: `testsuite/toolbox/cases_canvasidle.cla`

**Interfaces:**
- Consumes: `RtUiCanvasBuf` overlay record; `rtUiCanvasBufAt(w, i): ptr`; `UiTestVerb`/`UiTestTick(n)`; `TbFreeMem()` (declared in `cases_leak.cla`; redeclare identically in the new case file, or reference the existing one — an identical `external func` redeclaration is legal, Ch13 dedup).
- Produces: `RtUiCanvasBuf.dirty: int` (field 10, offset 36) and `.blits: int` (field 11, offset 40); `rtUiCanvasBufSize = 44`; `rtUiFlushBufferedCanvases(inst: ptr, force: bool)`; `UiTestCanvasBlits(i: int): int` (front window's widget i's blit counter, -1 if not a buffered canvas).

- [ ] **Step 1: Widen the record.** In `uidesc.cla` append two fields to `RtUiCanvasBuf` after `patLevel`:
```
    patLevel: int                  // gray-pattern animation level
    dirty: int                     // language-runtime-cleanup: 1 = drawn since last blit
    blits: int                     // language-runtime-cleanup: blit counter (UiTestCanvasBlits)
```
and change `const rtUiCanvasBufSize: int = 36` to `44`, updating its comment ("11 fields x 4 = 44"). `ui.cla:791` allocates `nWidgets * rtUiCanvasBufSize` and `uiwidgets.cla:247` strides by it, so nothing else needs the number. Run `LC_ALL=C grep -c $'[\x80-\xff]' runtime/clarus/uidesc.cla runtime/clarus/uiwidgets.cla runtime/clarus/ui.cla` first; if any is non-zero use sed/Python, not Edit.

- [ ] **Step 2: Set the flag in every drawing op.** In `uiwidgets.cla`, each of `rtUiCanvasPattern/Clear/Line/Rect/FillCircle/Circle/DrawText` obtains the canvas buffer (read how `rtUiCanvasBegin(instV, wIdx)` finds it — `rtUiCanvasBufAt(w, wIdx)`). Add one helper next to `rtUiCanvasBufAt`:
```
// rtUiCanvasMarkDirty (language-runtime-cleanup, spec %2.1): every drawing
// op calls this so rtUiFlushBufferedCanvases only blits canvases that
// changed since their last blit.
func rtUiCanvasMarkDirty(instV: ptr, wIdx: int) {
    var buf: RtUiCanvasBuf

    buf = RtUiCanvasBuf(rtUiCanvasBufAt(RtUiWinst(instV), wIdx))
    if buf.port != ptr(0) {
        buf.dirty = 1
    }
}
```
and call `rtUiCanvasMarkDirty(instV, wIdx)` as the first statement of each of the seven ops. In `rtUiCanvasMake` set `dirty = 1` and `blits = 0` after the port is created (a fresh canvas must blit once so the window shows its cleared content).

- [ ] **Step 3: Gate the flush.** Change `rtUiFlushBufferedCanvases(inst: ptr)` to `rtUiFlushBufferedCanvases(inst: ptr, force: bool)`; inside the loop replace `if buf.port != ptr(0) {` with `if buf.port != ptr(0) and (force or buf.dirty != 0) {` and, after the `UiCopyBits` call, add `buf.dirty = 0` and `buf.blits = buf.blits + 1`. Update the doc comment (drop the `rt_ui.c:2172-2187` line-cite or leave it as heritage — either is fine, but say the flush is now dirty-gated). Callers: `ui.cla:1635` (`rtUiFlushAllBuffered`, the per-pass flush) passes `false`; `ui.cla:1849` (inside `rtUiHandleUpdate`, window exposure) passes `true`. `grep -n 'rtUiFlushBufferedCanvases(' runtime/clarus/*.cla` must show exactly those two call sites plus the definition.

- [ ] **Step 4: Probe.** In `uitest.cla` after `UiTestTextviewScroll`:
```
// UiTestCanvasBlits (language-runtime-cleanup): the FRONT window's widget
// i's blit counter (RtUiCanvasBuf.blits), or -1 when widget i is not a
// buffered canvas. Bridge for testsuite/toolbox's CanvasIdle case.
func UiTestCanvasBlits(i: int): int {
    var buf: RtUiCanvasBuf

    buf = RtUiCanvasBuf(rtUiCanvasBufAt(RtUiWinst(rtUiWinstOf(UiFrontWindow())), i))
    if buf.port == ptr(0) {
        return -1
    }
    return buf.blits
}
```

- [ ] **Step 5: Harness window.** In `harness.cla` after `CanvasWin`'s `extend` block:
```
// IdleCanvasWin (language-runtime-cleanup, cases_canvasidle.cla): a
// buffered canvas drawn ONCE on open and never again -- the shape whose
// per-pass re-blit flickered the cursor before the dirty flag (spec %2.1).
window IdleCanvasWin {
    title: "IdleCanvas"
    size: 200, 120
    canvas Idle { at: 10, 10; buffered }
}

extend IdleCanvasWin {
    on opened {
        Idle.clear()
        Idle.fillRect(20, 20, 40, 40)
    }
}
```
(Match `CanvasWin`'s canvas declaration syntax exactly — read it first; `buffered` is the property name per the reference's Chapter 8 widget table.)

- [ ] **Step 6: Case.** Create `testsuite/toolbox/cases_canvasidle.cla`:
```
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// cases_canvasidle.cla: CanvasIdle (language-runtime-cleanup, spec %2.1).
// A buffered canvas drawn once must blit exactly once and then cost
// nothing per event-loop pass: 200 idle ticks may not advance its blit
// counter, and FreeMem stays exactly flat (no CopyBits scratch churn).

func caseCanvasIdle(): TestResult {
    var w: IdleCanvasWin
    var b0: int
    var b1: int
    var m0: int
    var m1: int

    w = open IdleCanvasWin
    UiTestTick(2)
    b0 = UiTestCanvasBlits(0)
    if b0 < 1 {
        close w
        return tkFail("CanvasIdle", "no initial blit (got " + tkIntToStr(b0) + ")")
    }
    m0 = TbFreeMem()
    UiTestTick(200)
    m1 = TbFreeMem()
    b1 = UiTestCanvasBlits(0)
    close w
    if b1 != b0 {
        return tkFail("CanvasIdle", "idle ticks blitted: " + tkIntToStr(b0) + " -> " + tkIntToStr(b1))
    }
    if m1 != m0 {
        return tkFail("CanvasIdle", "FreeMem moved: " + tkIntToStr(m0) + " -> " + tkIntToStr(m1))
    }
    return tkPass("CanvasIdle")
}
```
`Idle` is widget index 0 in its window. If `close w` is not the suite's close idiom, copy whatever `caseLeakCheck` does with its `LogWin`. Register the case in `runner.cla` exactly as `CasesTable` is registered (enum member after `CasesTable`, the `tbCaseName` arm, the `l.add(...)` line, the dispatch `if wantAll or tbHas(deduped, CanvasIdle)` arm — `grep -n CasesTable testsuite/toolbox/runner.cla` lists every site) and bump `nTbCases` by one. Add the file to both file lists; bump both `suite_report_check` literals.

- [ ] **Step 7: Host build + T1.** `make -j tools bootstrap && scripts/test-task.sh --smoke`. Expect the cg68k/emitui goldens for UI fixtures to FAIL with hunks only in the canvas flush/draw functions and the widened record stride; paste one `first_diff` into the report, do not bless.

- [ ] **Step 8: Native proof.** `pgrep -x minivmac || CLARUS_MAC_TESTS=1 make -j1 test T=mactest/toolbox_68k`. Expected: `PASS CanvasIdle` and `TOTAL 37 PASS 37 FAIL 0` (37 = 36 + this case; if Task 12 merged first the number is 38). Also boot `smoke_bounce` (the animated canvas): `CLARUS_MAC_TESTS=1 make test T=mactest/smoke_bounce` must stay green — Bounce draws every frame, so its trace/snap goldens must not move.

- [ ] **Step 9: Commit.**
```sh
git add runtime/clarus/uidesc.cla runtime/clarus/uiwidgets.cla runtime/clarus/ui.cla runtime/clarus/uitest.cla testsuite/toolbox/ tests/mactest/toolbox_files.txt tests/bake/full_corpus_suite_toolbox.sh tests/mactest/toolbox_68k.sh tests/mactest/toolbox_jiggle.sh
git commit -m "runtime(ui): dirty-gate buffered canvas blits; CanvasIdle toolbox case"
```

---

### Task 2: Widen the heap-jiggle waist; delete dead code (spec §2.2, §2.4)

**Files:**
- Modify: `runtime/clarus/ui.cla` (~182-201 the `UiNewPtrRaw`/`UiNewPtr` wrapper, `UiNewPtrClear`, `UiNewHandleClear`; ~228 `UiNewWindow`; ~257 `UiNewMenu`; ~1140 `UiNewMenuStr` — delete it, it is the dead declaration TODO.md's test-coverage section also names; the two `(new)` tags ~1192/1203)
- Modify: `runtime/clarus/uiwidgets.cla` (~29 `UiNewControl`, ~81 `UiNewRgn`; ~568 the dead `ctrlMp = UiHandleDeref(ctrl)`)
- Modify: `runtime/clarus/uitext.cla` (~88 `UiTENew`), `runtime/clarus/uitable.cla` (~65 `UiLNew`)

**Interfaces:**
- Consumes: `rtUiJiggleTick()` (`uiscript.cla:90`).
- Produces: no signature changes — every existing call site keeps calling `UiNewPtrClear`, `UiNewHandleClear`, `UiNewRgn`, `UiTENew`, `UiLNew`, `UiNewMenu`, `UiNewControl`, `UiNewWindow` by the same name.

- [ ] **Step 1: Rename each extern to `...Raw` and add the wrapper.** The pattern is `UiNewPtr` at `ui.cla:182-197`. For each of the eight declarations, rename the `external func` to `<Name>Raw` (same trap, same signature) and add directly below it:
```
func <Name>(<same params>): <same ret> {
    rtUiJiggleTick()
    return <Name>Raw(<same args>)
}
```
(`UiNewWindow` has several params — copy its signature verbatim.) `rtUiJiggleTick` lives in `uiscript.cla`, spliced into every UI program, so each of the four files can call it. Confirm with `grep -n 'Raw(' runtime/clarus/{ui,uiwidgets,uitext,uitable}.cla` that each Raw name is called exactly once (its wrapper).

- [ ] **Step 2: Dead code.** Delete `uiwidgets.cla:568`'s `ctrlMp = UiHandleDeref(ctrl)` (the sibling at ~717 is live: the next line pokes through it — leave it). Delete `UiNewMenuStr`'s declaration in `ui.cla` (grep confirms zero callers). Delete the two `(new)` markers in `ui.cla`'s About-box helper comments (the words only, keep the comments).

- [ ] **Step 3: T1.** `scripts/test-task.sh --smoke`. Golden diffs: every UI fixture's `.s` gains eight tiny wrapper functions and the call sites change from `JSR`-to-trap to `JSR wrapper`; report, do not bless.

- [ ] **Step 4: Jiggle boot.** `pgrep -x minivmac || CLARUS_MAC_TESTS=1 make -j1 test T=mactest/toolbox_jiggle`. Expected green. **If a case goes red**, that is a real pre-existing stale-master-pointer bug the wider waist just exposed: find the site (the failing case names the widget; look for a master pointer derived before the newly-jiggled allocation and read after), fix it with the "re-derive after the allocating call" or lock/restore shape compiler-cleanup §3.1 used, record it in the report as a find, and re-run. Do not narrow the waist.

- [ ] **Step 5: Commit.**
```sh
git add runtime/clarus/ui.cla runtime/clarus/uiwidgets.cla runtime/clarus/uitext.cla runtime/clarus/uitable.cla
git commit -m "runtime(ui): route every allocating Toolbox wrapper through the jiggle waist; drop dead ctrlMp/UiNewMenuStr/(new) tags"
```

---

### Task 3: Map runtime minors (spec §2.3)

**Files:**
- Modify: `runtime/clarus/map.cla` (~276-290 `mapIndexFindSlot`, ~327-345 `mapIndexSlotFor`, ~385-397 `mapIndexRepoint`: the three `while true` probe loops; ~473-540 `mapGrowEntries`/`mapGrowVals`/`mapGrowPool`)
- Modify: `runtime/host/rt_core.inc` (~623 `MAP_KEYBLOCK`; ~652 `rt_map_layout_check`)

- [ ] **Step 1: Bound the probes.** In each of the three loops add a step counter that panics after one full sweep:
```
    steps = 0
    while true {
        ...existing body...
        slot = (slot + 1) & (indexcap - 1)
        steps = steps + 1
        if steps > indexcap {
            rtPanic("map: index corrupt")
        }
    }
```
Declare `var steps: int` in each function. The index always has at least one EMPTY slot (the load-factor rule the file header states), so a healthy table never trips this.

- [ ] **Step 2: One grower.** Replace the three growers' shared body with one helper and three two-line callers:
```
// mapGrowHandle: amortized-doubling SetHandleSize for a per-entry Handle
// (language-runtime-cleanup, spec %2.3 -- the three near-identical growers
// collapsed). Returns the new capacity in `unit`s.
func mapGrowHandle(h: ptr, cap: int, need: int, unit: int): int {
    var newcap: int

    if cap > 0 {
        newcap = cap
    } else {
        newcap = 4
    }
    while newcap < need {
        newcap = newcap * 2
    }
    if MapSetHandleSize(h, newcap * unit) != 0 {
        rtPanic("out of memory")
    }
    return newcap
}
```
`mapGrowEntries` becomes `if need > rm.cap { rm.cap = mapGrowHandle(rm.keys, rm.cap, need, MAP_ENTRY_STRIDE) }` (keep the `RtMap(m)` overlay read/write shape the file uses); `mapGrowVals` the same with `rm.vals`, `rm.valcap`, `rm.valsize`; `mapGrowPool` with `rm.keypool`, `rm.poolcap`, unit 1. Read `mapGrowPool`'s current body first — if it doubles from a different floor, keep its floor by passing it in.

- [ ] **Step 3: C side.** Delete `#define MAP_KEYBLOCK 256` and its comment (grep `MAP_KEYBLOCK` across `runtime/host` first — zero other uses expected). Replace the `sizeof`-only `rt_map_layout_check` typedef with `offsetof` assertions, one per field in the order `map.cla`'s `overlay record RtMap` reads them:
```c
#include <stddef.h>
typedef char rt_map_layout_check_rc[offsetof(rt_map, rc) == 0 ? 1 : -1];
typedef char rt_map_layout_check_keys[offsetof(rt_map, keys) == 4 ? 1 : -1];
typedef char rt_map_layout_check_vals[offsetof(rt_map, vals) == 8 ? 1 : -1];
typedef char rt_map_layout_check_valsize[offsetof(rt_map, valsize) == 12 ? 1 : -1];
typedef char rt_map_layout_check_count[offsetof(rt_map, count) == 16 ? 1 : -1];
typedef char rt_map_layout_check_cap[offsetof(rt_map, cap) == 20 ? 1 : -1];
typedef char rt_map_layout_check_valcap[offsetof(rt_map, valcap) == 24 ? 1 : -1];
typedef char rt_map_layout_check_keypool[offsetof(rt_map, keypool) == 28 ? 1 : -1];
typedef char rt_map_layout_check_poolused[offsetof(rt_map, poolused) == 32 ? 1 : -1];
typedef char rt_map_layout_check_poolcap[offsetof(rt_map, poolcap) == 36 ? 1 : -1];
typedef char rt_map_layout_check_index[offsetof(rt_map, index) == 40 ? 1 : -1];
typedef char rt_map_layout_check_indexcap[offsetof(rt_map, indexcap) == 44 ? 1 : -1];
typedef char rt_map_layout_check_tombs[offsetof(rt_map, tombs) == 48 ? 1 : -1];
typedef char rt_map_layout_check_size[sizeof(rt_map) == 52 ? 1 : -1];
```
The offsets assume 4-byte pointers on the 68k and must ALSO hold on a 64-bit host, where `Handle` is 8 bytes — they will not. Read how `rt_list_layout_check` above it handles the host/Mac difference (it is the precedent); if it only asserts `sizeof` against a struct literal because the host has 8-byte pointers, then assert field ORDER with `offsetof(rt_map, keys) > offsetof(rt_map, rc)` chains instead of absolute numbers, which is the property the overlay actually needs. Write the one that compiles on both.

- [ ] **Step 4: Tests.** `make test T=hostrt/ T=testsuite/` (the `core` suite's `Map`/`IntMap`/`SortedMap` cases and the C memory harnesses). Then `scripts/test-task.sh --smoke`. Golden diffs in `map.cla`-splicing fixtures: report, do not bless.

- [ ] **Step 5: Commit.**
```sh
git add runtime/clarus/map.cla runtime/host/rt_core.inc
git commit -m "runtime(map): bound the probe loops, one grower, offsetof layout check, drop MAP_KEYBLOCK"
```

---

### Task 4: Filesystem minors, both lanes (spec §2.5, §2.6, §2.7, §2.8)

**Files:**
- Modify: `runtime/clarus/fileh_68k.cla` (~418 `rtFh68kEnsureState`; ~432 `rtFh68kFourCCToStr`; ~506-545 `rtFhDevStat`'s `rtFh68kState + 28` stash; ~763 `rtFhDevRename`)
- Modify: `runtime/host/rt_fileh.inc` (~214 `rt_fh_mac_time`; ~321 `rt_ext_FhHListNext`; ~367 `rt_ext_FhHRename`; ~377 `rt_ext_FhHMove`), `runtime/host/rt_ext_host.inc` (~382 `rt_dt_now_mac`), `runtime/host/rt_fileh_test.c`
- Modify: `testsuite/toolbox/cases_catalog.cla` (~219 `PBCreateSync(fpb)`)
- Modify: `docs/clarus-language-reference.md` (the `file.info` / `FileInfo` entry, ~line 1460-1480: one sentence)

- [ ] **Step 1: Epoch helper.** In `rt_ext_host.inc` above `rt_dt_now_mac`:
```c
/* rt_unix_to_mac_secs: Unix seconds -> Mac-epoch LOCAL seconds (the Mac
 * clock is local time). Shared by rt_dt_now_mac ("now") and rt_fileh.inc's
 * rt_fh_mac_time (a file's stat times). */
static uint32_t rt_unix_to_mac_secs(time_t t) {
    struct tm tmv;
    localtime_r(&t, &tmv);
    return (uint32_t)((unsigned long)t + (unsigned long)tmv.tm_gmtoff + RT_MAC_EPOCH_DELTA);
}
```
`rt_dt_now_mac` becomes `return rt_unix_to_mac_secs(time(NULL));`; `rt_fh_mac_time` becomes `return (int32_t)rt_unix_to_mac_secs(t);` (keep its doc comment, pointing at the shared helper).

- [ ] **Step 2: Host clamps set an error.** In `rt_ext_FhHListNext` replace `if (n > 255) n = 255;` with `if (n > 255) { rt_fh_errno = ENAMETOOLONG; return -1; }`. In `rt_ext_FhHRename` and `rt_ext_FhHMove`, check `snprintf`'s return: `if (snprintf(target, sizeof target, ...) >= (int)sizeof target) { rt_fh_errno = ENAMETOOLONG; return -1; }`. `rtFhDevListFailed`'s host arm already maps a -1 from `ListNext` to `lastError` (read `fileh_c.cla`'s `rtFhDevListNext` to confirm; if it treats -1 as "end", make the over-long-name case set `rt_fh_errno` and return -1 exactly like the `readdir` error path it already has). Add to `rt_fileh_test.c` a `test_long_names` case: create a directory entry of 256 'a's (`mkdir` of a 256-char name fails on most filesystems — instead use a 300-byte `newName` for `FhHRename` and a 300-byte `dirPath` for `FhHMove` and assert `-1` with `rt_ext_FhHErrno() == ENAMETOOLONG`); call it from `main`. `make test T=hostrt/fileh`.

- [ ] **Step 3: Native minors.** In `fileh_68k.cla`: (a) `rtFh68kEnsureState` — after `rtFh68kState = SerNewPtr(44)` add `if rtFh68kState == ptr(0) { rtFh68kLastErr = -108 ; return }` (memFullErr = -108) and make the second `SerNewPtr(256)` checked the same way (set the +40 slot only on success); then make every caller that follows `rtFh68kEnsureState()` with a state read bail when `rtFh68kState == ptr(0)` (grep `rtFh68kEnsureState()`; there are a handful — each returns its failure value, `false`/`-1`/`0`, right after the call). Widen the block to 48 bytes (`SerNewPtr(48)`) for step (c). (b) `rtFh68kFourCCToStr`: add the comment `// A zero fdType (an untyped file) and a folder both read back as "" -- isDir is the discriminator; documented in the reference's file.info entry.` (c) `rtFhDevStat`: where it stores the directory hit's DirID at `+28`, ALSO store `ci.ioFlParID` at `+44` on every successful stat (file or folder). `rtFhDevRename`: replace its own `PBGetCatInfoSync` block with `if not rtFhDevStat(path) { return rtFh68kLastErr }` and `hp.ioDirID = peekl(rtFh68kState + 44)`. Read `rtFhDevStat` first: it must leave `rtFh68kLastErr` set on failure, and `ioFlParID`'s offset must be the field `CInfoPBRec` declares (the `ci.ioFlParID` read the old code did).

- [ ] **Step 4: Catalog test.** `cases_catalog.cla` ~219: `err = PBCreateSync(fpb)` then `if err != 0 and err != -48 { return tkFail("Catalog", "PBCreateSync " + tkIntToStr(err)) }` (dupFNErr = -48). Declare `var err: int` in that function's var block if absent.

- [ ] **Step 5: Reference.** In the `file.info` prose (grep `isDir` in the reference to find it), append: "A file with no Finder type set reads back `type == ""`, the same as a folder; `isDir` is the reliable discriminator." Run `make test T=reftest/` — prose only, no fence change, so the manifest is untouched.

- [ ] **Step 6: T1 + native.** `scripts/test-task.sh --smoke`; then `pgrep -x minivmac || CLARUS_MAC_TESTS=1 make -j1 test T=mactest/coresuite_68k T=mactest/toolbox_68k` (`DirOps` exercises rename natively; `Catalog` the create check). Golden diffs in `fileh_68k.cla`-splicing fixtures: report, do not bless.

- [ ] **Step 7: Commit.**
```sh
git add runtime/clarus/fileh_68k.cla runtime/host/rt_fileh.inc runtime/host/rt_ext_host.inc runtime/host/rt_fileh_test.c testsuite/toolbox/cases_catalog.cla docs/clarus-language-reference.md
git commit -m "runtime(files): shared epoch helper, host clamps set lastError, native rename reuses stat, checked SerNewPtr, catalog create check"
```

---

### Task 5: `ser.cla` bulk int reads + `size-68k.sh` reads the file lists (spec §2.9, §2.10)

**Files:**
- Modify: `runtime/clarus/ser.cla` (~304 `rtSerGetByte`, ~316 `rtSerGetI32`)
- Modify: `scripts/size-68k.sh` (~46-76 the two `measure` invocations)

- [ ] **Step 1: `rtSerGetI32` via `intAt`.**
```
func rtSerGetI32(t: text): int {
    var v: int

    if rtSerBad or rtSerPos > t.length - 4 {
        rtSerBad = true
        return 0
    }
    v = t.intAt(rtSerPos)
    rtSerPos = rtSerPos + 4
    return v
}
```
`text.intAt(pos)` is the big-endian reader (`rtTextIntAt`, `text.cla:655`), the same byte order the old four `rtSerGetByte` calls composed. `rtSerGetByte` itself stays (the string(n)/bool/char field arms read fixed-width byte runs through it and are not this task's scope). Prove byte-identity: `make test T=sertest/` (the `.bytes.golden` and `clrd_goldens` are frozen; a diff there is a bug in this step, never a bless) and `make test T=testsuite/core_cli` (`Ser` case).

- [ ] **Step 2: `size-68k.sh` reads the lists.** Replace the inline `measure coregui ...` file list with a read of `tests/mactest/coregui_files.txt` and the `measure toolboxgui --testapi ...` list with `tests/mactest/toolbox_files.txt`, keeping `--testapi` for the toolbox build:
```sh
files_from() { tr '\n' ' ' < "$1"; }
# shellcheck disable=SC2046
measure coregui $(files_from tests/mactest/coregui_files.txt)
# shellcheck disable=SC2046
measure toolboxgui --testapi $(files_from tests/mactest/toolbox_files.txt)
```
Update the header comment (it currently claims to mirror those lists; now it reads them). Run `scripts/size-68k.sh` and paste its three `SIZE` lines into the report as the phase's pre-wave-2 baseline (Task 15 records the after numbers).

- [ ] **Step 3: T1.** `scripts/test-task.sh --smoke`. Golden diffs in `ser.cla`-splicing fixtures: report, do not bless.

- [ ] **Step 4: Commit.**
```sh
git add runtime/clarus/ser.cla scripts/size-68k.sh
git commit -m "runtime(ser): intAt for I32 reads; size-68k.sh reads the suite file lists"
```

---

### Task 6: Wave-1 bless #1, differential oracle, native gate (spec §2.11)

Runs after Tasks 1-5 are merged to the branch. Serial (owns the emulator).

**Files:**
- Modify (bless only): `testdata/cg68k/*.s`, `testdata/emitui/*.c.golden`.

- [ ] **Step 1: Differential oracle.** The wave changed no compiler file, so the PRE-PHASE compiler over the wave-1 runtime must reproduce the wave-1 compiler's output exactly:
```sh
git stash list >/dev/null; base=$(git merge-base main HEAD)
git worktree add /tmp/lrc-base "$base" && (cd /tmp/lrc-base && cc -O1 -I runtime/host -o /tmp/lrc-base-cc clarusc/clarusc.c runtime/host/rt.c)
make -j tools bootstrap
for f in testdata/cg68k/*.cla; do
  b=${f##*/}; b=${b%.cla}
  /tmp/lrc-base-cc emit68k --rtdir runtime/clarus/ --listing -o /tmp/o1.bin "$f" >/dev/null 2>&1
  build-run/clarusc-current emit68k --rtdir runtime/clarus/ --listing -o /tmp/o2.bin "$f" >/dev/null 2>&1
  for s in /tmp/o1.seg*.s; do cmp -s "$s" "/tmp/o2${s#/tmp/o1}" || echo "DIFF $b ${s##*/}"; done
done
git worktree remove /tmp/lrc-base
```
Expected: no `DIFF` lines (both compilers read the same `runtime/clarus/`). Any `DIFF` means a wave-1 task changed the compiler — stop and report.

- [ ] **Step 2: Baseline the golden diff.** `make test T=cg68k/goldens T=emitui/goldens 2>&1 | tail -40`. Pick three failing `.s` fixtures (one UI, one map-using, one file-using) and confirm via `first_diff` that every hunk is one of: the canvas record stride / flush gate (Task 1), the eight jiggle wrappers (Task 2), map probe/grow bodies (Task 3), `fileh_68k` rename/state (Task 4), `rtSerGetI32` (Task 5). Anything else: stop and report.

- [ ] **Step 3: Bless.** `CLARUS_CG68K_BLESS=1 make test T=cg68k/goldens`. emitui goldens have no bless variable; regenerate with the same invocation `tests/emitui/goldens.sh` uses (line 30: `"$CLARUSC" emit -o out.c "$fixture"`, no extra flags):
```sh
for f in testdata/emitui/*.cla; do g=${f%.cla}.c.golden; [ -f "$g" ] || continue; build-run/clarusc-current emit -o "$g" "$f" || echo "FAILED $f"; done
make test T=emitui/goldens
```
Record `git diff --stat testdata/ | tail -1` in the report.

- [ ] **Step 4: T1.** `scripts/test-task.sh --smoke` — green.

- [ ] **Step 5: Native gate.** `CLARUS_MAC_TESTS=1 make -j1 test T=mactest/` — green, including `PASS CanvasIdle`, `TOTAL 37 PASS 37 FAIL 0` in `toolbox_68k` and `toolbox_jiggle`, and the four frozen scenarios unchanged (if a trace/snap golden moved, investigate before considering `CLARUS_MAC_BLESS=1` — nothing in wave 1 should change a scenario's pixels; the Bounce canvas draws every frame).

- [ ] **Step 6: Commit.**
```sh
git add testdata/
git commit -m "test: bless #1 -- runtime-ripple goldens after wave 1 (canvas dirty flag, jiggle waist, map/fileh/ser minors)"
```

---

## Wave 2 — compiler (Tasks 7-11 in parallel first; 12-13 as slots free; 14 after 7; then Task 15)

Every wave-2 task builds with `make -j tools bootstrap` (rebuilds `build-run/clarusc-current` from source) and runs `scripts/test-task.sh --smoke`. Golden diffs are reported, never blessed (Task 15). Snapshot untouched.

### Task 7: Array-literal initializers, dedicated pool class (spec §4.1-§4.5) — critical path, start first

**Files:**
- Modify: `clarusc/ast.cla` (`enum ExprKind` ~ExAppConst; new `newArrLit`/`arrLitElemsHead`/`arrLitCount` next to `newIndex` ~715)
- Modify: `clarusc/parse.cla` (`parseConstDecl` ~1395; `parseVarDecl` ~1541; new `parseArrLit`)
- Modify: `clarusc/types.cla` (`record Symbol` ~611: `constArrIdx: int`)
- Modify: `clarusc/check.cla` (`checkConstDecl` ~2816; `checkVarDecl` ~2670; `checkExpr`'s kind switch — new `ExArrLit` arm; `checkIdent`'s const branch ~5153; the index-assignment check that rejects assignment to a constant — find it via `grep -n 'cannot assign to constant' clarusc/check.cla`; new globals `arrLitVals/arrLitStart/arrLitCount/arrLitElemT`, `arrLitIdxOf: intmap of int`, `constUseArr: intmap of int`, reset in `checkReset`)
- Modify: `clarusc/ir.cla` (`enum IRExprKind`: `EArrLit`; `irArrLit*` tables + `irAddArrLit`/`newIRArrLit`/`irArrLitIdx`; reset alongside `irStrLits`)
- Modify: `clarusc/lower.cla` (`lowExpr` ExArrLit arm; `lowIdent` ~957 const-array branch; `lowArrLitIrIdx: intmap of int` memo)
- Modify: `clarusc/cg68k.cla` (constant pool: twin every `cgStrLitLabels`/`cgCurPoolStrLits`/`cgCurPoolStrLitBits`/`cgStrLitSize`/`cgFuncStrLits`/`cgRecordStrLit`/`cgReserveStrLitLabels`/`cgPoolStrRef` site — `grep -n 'StrLit' clarusc/cg68k.cla` lists them all; `cgEmitPoolsBody` ~12878; `cgExprAddr` ~5951 new `EArrLit` arm; `cgObjSetLbl` loop ~14128; `const cgRelClsPoolArr: int = 12` after `cgRelClsJt`)
- Modify: `clarusc/cprint.cla` (`cpEmitArrLits` after `cpEmitStrLits` ~7445; `fpExpr` `EArrLit` arm ~1292)
- Modify: `clarusc/bake.cla` (`const bkSecIrArrLits` — next free section id after the highest `bkSec*`; `bkWriteIrArrLits`/`bkReadIrArrLits` next to the `IrStrLits` pair ~1169/~3492; `bkLdIrArrLits*` load-side lists ~2154; the install/truncate logic that handles `bkLdIrStrLits` ~4226-4240; `bkObjRelocSymValid` ~3121; `bkFormatVersion` 7 -> 8)
- Modify: `docs/clarus-language-reference.md` (Constants section ~431; the `T[n]` row ~159), `tests/reftest/manifest.txt`
- Create: `testdata/run/arrlit.cla` + `.out`; `testdata/cg68k/arrlit.cla` (golden `.s` blessed in Task 15); `testdata/errors/arrlit_count.cla` + `.expect`, `testdata/errors/arrlit_assign.cla` + `.expect`; `tests/bake/arrlit.sh` (an `emit68k_pair` twin proving the baked pool class round-trips)

**Interfaces:**
- Produces (AST): `ExArrLit` with `a = elems head` (chained by `next`), `intVal = count`; `newArrLit(elemsHead, count, line, col)`, `arrLitElemsHead(i)`, `arrLitCount(i)`.
- Produces (checker): `Symbol.constArrIdx` (0 = not a `const` array, else literal index + 1, so every existing zero-initialized `Symbol` construction site stays correct); `arrLitIdxOf[exprIdx] = litIdx`; `constUseArr[identExprIdx] = litIdx`; literal tables `arrLitElemT[l]`, `arrLitStart[l]`, `arrLitCount[l]`, flat `arrLitVals`.
- Produces (IR): `EArrLit` (`intVal = irArrLits index`, `ty = the T[n] type`); `irAddArrLit(elemT: int, vals: list of int): int`; `irArrLitCount()`, `irArrLitElemT(i)`, `irArrLitN(i)`, `irArrLitVal(i, j)`; `newIRArrLit(idx, ty)`; `irArrLitIdx(e)`.
- Produces (cg68k): `cgRelClsPoolArr = 12`; `cgArrLitLabels`; `cgPoolArrRef(idx)`. (cprint): `clar_arrlit_<i>` statics. (bake): `bkSecIrArrLits`, `bkLdIrArrLits*`.
- Task 14 consumes `const NAME: int[256] = [...]` at module level in `runtime/clarus/text.cla`, so a `const` array must work inside a spliced runtime module AND through `--rtbake` (that is what `tests/bake/arrlit.sh` proves).

- [ ] **Step 1: Fixtures first (they fail until the end).** `testdata/run/arrlit.cla`:
```
// arrlit.cla (language-runtime-cleanup, spec %4): const and var array
// literals -- pool-backed const reads, a var global block-copied from the
// pool, a local likewise, a const array borrowed as a KArr argument, and
// every element kind the phase admits (int, bool, char, fixed, enum).
enum Mode { Off, On, Auto }

const squares: int[5] = [0, 1, 4, 9, 16]
const flags: bool[3] = [true, false, true]
const letters: char[3] = ['a', 'b', 'c']
const modes: Mode[2] = [Auto, Off]
const three: int = 3
const withConst: int[2] = [three, 0x7FFFFFFF]

var table: int[4] = [10, 20, 30, 40]

func sumOf(a: int[5]): int {
    var i: int
    var s: int

    i = 0
    while i < 5 {
        s = s + a[i]
        i = i + 1
    }
    return s
}

on App.launch {
    var local: int[3] = [7, 8, 9]
    var i: int

    alert("squares[4] = " + string(squares[4]))
    alert("sum = " + string(sumOf(squares)))
    alert("flags = " + string(int(flags[0])) + string(int(flags[1])) + string(int(flags[2])))
    alert("letters[1] = " + string(letters[1]))
    if modes[0] == Auto and modes[1] == Off {
        alert("modes ok")
    }
    alert("withConst = " + string(withConst[0]) + " " + string(withConst[1]))
    table[1] = table[1] + 1
    alert("table = " + string(table[0]) + " " + string(table[1]) + " " + string(table[3]))
    local[0] = local[0] + local[2]
    alert("local = " + string(local[0]) + " " + string(local[1]))
}
```
Expected `.out` (write it now; confirm at Step 12): `squares[4] = 16`, `sum = 30`, `flags = 101`, `letters[1] = b`, `modes ok`, `withConst = 3 2147483647`, `table = 10 21 40`, `local = 16 8`, one per line. Check `alert`'s host output shape against any existing `testdata/run/*.out` first (it may prefix lines). `testdata/cg68k/arrlit.cla` is the same program minus `alert` noise (keep `sumOf` and the const/var/local shapes; a cg68k fixture just needs to emit). `testdata/errors/arrlit_count.cla`: `const t: int[3] = [1, 2]` → expect `array literal has 2 elements, type has 3`; `testdata/errors/arrlit_assign.cla`: `const t: int[2] = [1, 2]` and a handler doing `t[0] = 5` → expect `cannot assign to constant t`. `.expect` files embed the path `../../testdata/errors/<f>.cla:L:C: <msg>`; generate them from `tests/selfhost/` exactly as `tests/selfhost/diag.sh` does (read it).

- [ ] **Step 2: AST + parser.** `ast.cla`: add `ExArrLit` to `enum ExprKind`; constructor mirroring `newIndex` with `n.kind = ExArrLit; n.a = elemsHead; n.intVal = count`. `parse.cla`:
```
// parseArrLit parses `"[" (literalOrIdent ("," literalOrIdent)*)? "]"` --
// legal ONLY as a const/var initializer whose declared type is T[n]
// (checked by the checker, not here). Elements follow parseLiteralOrIdent's
// own palette: a literal, an enum member, or a previously declared const.
func parseArrLit(): int {
    var line: int
    var col: int
    var head: int
    var tail: int
    var e: int
    var n: int

    line = curLine()
    col = curCol()
    expect(TkLBracket)
    head = -1
    tail = -1
    n = 0
    while curKind() != TkRBracket and not parseAborted {
        e = parseLiteralOrIdent()
        if head == -1 { head = e } else { exprSetNext(tail, e) }
        tail = e
        n = n + 1
        if curKind() == TkComma {
            advance()
        } else if curKind() != TkRBracket {
            expect(TkRBracket)
        }
    }
    advance() // ']'
    return newArrLit(head, n, line, col)
}
```
Use whatever next-link setter the argument-list parser already uses (`grep -n 'Next(' clarusc/parse.cla | head`); if there is none, add `exprSetNext(i, nxt)` to `ast.cla` next to `exprNext`. In `parseConstDecl` replace `val = parseLiteralOrIdent()` with `if curKind() == TkLBracket { val = parseArrLit() } else { val = parseLiteralOrIdent() }`; in `parseVarDecl` the same in front of `initExpr = parseExpr()`.

- [ ] **Step 3: Checker.** Add `constArrIdx: int` to `Symbol` (types.cla); every existing site that builds a `Symbol` leaves it 0 — make -1 the sentinel by setting `sym.constArrIdx = -1` in `checkConstDecl` and `checkVarDecl`, and treating 0 as "not an array const" is WRONG (index 0 is a real literal), so instead store `litIdx + 1` (0 = none). New tables and the literal check:
```
// Array literals (language-runtime-cleanup, spec %4): per-literal element
// type / start / count into the flat arrLitVals, keyed by the literal's own
// ExprNode index (arrLitIdxOf) for lower.cla to pick up.
var arrLitElemT: list of int
var arrLitStart: list of int
var arrLitCount: list of int
var arrLitVals: list of int
var arrLitIdxOf: intmap of int
var constUseArr: intmap of int

func checkArrLit(e: int, want: int): int {
    var et: int
    var ek: TypeKind
    var n: int
    var x: int
    var cv: CVal
    var litIdx: int

    if want == -1 or typeKind(want) != TyArr {
        emitDiag(exprLine(e), exprCol(e), "array literal needs a fixed-array declared type")
        return InvalidT
    }
    et = typeElem(want)
    ek = typeKind(et)
    if ek != TyInt and ek != TyFixed and ek != TyChar and ek != TyBool and ek != TyEnum {
        emitDiag(exprLine(e), exprCol(e), "array literal element type must be int, fixed, char, bool, or enum")
        return InvalidT
    }
    n = typeN(want)
    if arrLitCount(e) != n {
        emitDiag(exprLine(e), exprCol(e), "array literal has " + numToStr(arrLitCount(e)) + " elements, type has " + numToStr(n))
        return InvalidT
    }
    litIdx = arrLitElemT.count
    arrLitElemT.add(et)
    arrLitStart.add(arrLitVals.count)
    arrLitCount.add(n)
    x = arrLitElemsHead(e)
    while x != -1 {
        cv = constValue(x, et)
        arrLitVals.add(cv.intVal)
        x = exprNext(x)
    }
    arrLitIdxOf[e] = litIdx
    return want
}
```
`typeN` is whatever `types.cla` calls the fixed-array length accessor (`grep -n 'func typeElem' clarusc/types.cla` and read its neighbours). `constValue` already handles enum members, consts, and literals with type compatibility diagnostics; a `bool` literal must yield 0/1 through `literalConstVal` (verify `cvInt(boolLitVal)` exists there; add it if `ExBoolLit` is missing). Wire it: in `checkExpr`'s kind switch add `case ExArrLit { return checkArrLit(e, want) }` where `want` is the expected-type parameter `checkVarDecl` passes as `t`. In `checkConstDecl`: allow `TyArr` in the type gate, and when `k == TyArr`: `if exprKind(constDeclValue(d)) != ExArrLit { emitDiag(..., "const array initializer must be an array literal"); return }`, `t2 = checkExpr(constDeclValue(d), t)`, and on success `sym.constArrIdx = arrLitIdxOf.get(constDeclValue(d), -1) + 1` (skip the scalar `constValue` path). In `checkIdent`'s const branch (~5153) add first: `if symbols[symIdx].constArrIdx != 0 { constUseArr[e] = symbols[symIdx].constArrIdx - 1; return symbols[symIdx].typeIdx }` (do NOT fall into the `constUseIsStr` bookkeeping). Assignment ban: find the existing "cannot assign to constant" site and make sure an index-assignment whose ROOT identifier is a const array reaches it (`checkIndexAssign`/`checkAssignStmt` — walk `indexX` down to the `ExIdent`); the `arrlit_assign` fixture pins it. Add every new global to `checkReset`'s clear list (grep `constUseInt.clear` or however it resets intmaps).

- [ ] **Step 4: IR.** `ir.cla`: `EArrLit` in `enum IRExprKind`; tables and constructors:
```
// irArrLits (language-runtime-cleanup, spec %4.4): array literals, one
// constant-pool entry each -- element IR type, first index into the flat
// irArrLitVals, element count. Parallel to irStrLits.
var irArrLitElemT: list of int
var irArrLitStart: list of int
var irArrLitN: list of int
var irArrLitVals: list of int

func irAddArrLit(elemT: int, vals: list of int): int {
    var i: int

    irArrLitElemT.add(elemT)
    irArrLitStart.add(irArrLitVals.count)
    irArrLitN.add(vals.count)
    i = 0
    while i < vals.count {
        irArrLitVals.add(vals[i])
        i = i + 1
    }
    return irArrLitElemT.count - 1
}

func irArrLitCount(): int { return irArrLitElemT.count }
func irArrLitVal(i: int, j: int): int { return irArrLitVals[irArrLitStart[i] + j] }

func newIRArrLit(idx: int, ty: int): int {
    var n: IRExpr

    n.kind = EArrLit
    n.intVal = idx
    n.ty = ty
    n.next = -1
    irExprs.add(n)
    return irExprs.count - 1
}

func irArrLitIdx(e: int): int { return irExprs[e].intVal }
```
Reset the four lists wherever `irStrLits` is reset between compiles (grep `irStrLits = `).

- [ ] **Step 5: Lower.** `lowExpr`'s ExArrLit arm and the const-array identifier:
```
func lowArrLitFromChecker(litIdx: int, ty: int): int {
    var vals: list of int
    var j: int
    var irIdx: int

    if lowArrLitIrIdx.has(litIdx) {
        return newIRArrLit(lowArrLitIrIdx.get(litIdx, -1), ty)
    }
    j = 0
    while j < arrLitCount[litIdx] {
        vals.add(arrLitVals[arrLitStart[litIdx] + j])
        j = j + 1
    }
    irIdx = irAddArrLit(lowResolveType(arrLitElemT[litIdx]), vals)
    lowArrLitIrIdx[litIdx] = irIdx
    return newIRArrLit(irIdx, ty)
}
```
In `lowExpr`: `case ExArrLit { return lowArrLitFromChecker(arrLitIdxOf.get(e, -1), lowMustType(e)) }`. In `lowIdent` (before the `constUseIsStr` test): `if constUseArr.has(key) { return lowArrLitFromChecker(constUseArr.get(key, -1), ty) }`. `lowArrLitIrIdx` is an `intmap of int` global cleared with the other lower-side memos. A global `var t: int[4] = [...]` then lowers through the existing `lowGlobalVar` (`init = lowExpr(initAst)` → `EArrLit`, `isBirth` false — `lowStoreIsBirth` must return false for ExArrLit; check its switch) and a local through `lowCountedStore(dst, init, t)` (read it: a KArr store must route to the plain store statement, not a retain, since scalar-element arrays need no ARC — confirm `lowCountedStore` already treats `KArr` of scalars that way, because `var a: int[4] = b` works today).

- [ ] **Step 6: cg68k pool class.** Mirror the string-literal family exactly. Read `grep -n 'StrLit' clarusc/cg68k.cla` end to end first (about 40 hits). Twin each: `cgArrLitLabels`, `cgCurPoolArrLits` + `cgCurPoolArrLitBits`, `cgArrLitSize`, `cgFuncArrLits`, `cgRecordArrLit(idx)`, `cgReserveArrLitLabels()`, `cgPoolArrRef(idx)`, and the per-segment pool-size accounting in `cgPackProgram` (wherever `cgStrLitSize`/`cgFuncStrLits` feed `cgPoolDeltaPeek`/`cgPoolDeltaAndUnion`). Then:
  - `const cgRelClsPoolArr: int = 12` after `cgRelClsJt`; in the `cgObjSetLbl` loop add `cgObjSetLbl(lblCls, lblSym, cgArrLitLabels[i], cgRelClsPoolArr, i)` over `cgArrLitLabels`; `grep -n 'cgRelClsPoolEnum' clarusc/cg68k.cla` — every switch that names the enum class gets an `Arr` twin arm (the object-code capture/paste label-class resolution).
  - `cgExprAddr`: `} else if k == EArrLit { a68Emit(OpLea, 0, AmPCLabel, 0, cgPoolArrRef(irArrLitIdx(e)), AmAn, 0, 0) }` right after the `EStrConst` arm.
  - `cgEmitPoolsBody`, after the string loop:
```
    if a68ListingOn { a68Comment("constant pool: array literals") } else { a68CommentMarker() }
    i = 0
    while i < cgCurPoolArrLits.count {
        idx = cgCurPoolArrLits[i]
        before = a68SizeSoFar()
        a68Bind(cgArrLitLabels[idx])
        stride = cgArrElemStride(irArrLitElemT[idx])
        j = 0
        while j < irArrLitN[idx] {
            v = irArrLitVal(idx, j)
            if stride == 1 { a68DcB(v & 0xFF) } else if stride == 2 { a68DcW(v & 0xFFFF) } else { a68DcL(v) }
            j = j + 1
        }
        a68Align()
        if cgMeasuringPoolSizes { cgArrLitSize[idx] = a68SizeSoFar() - before }
        i = i + 1
    }
```
`cgArrElemStride(elemT)` is the same authority `cgArrDefaultAt`/`cgSizeOf(KArr)` use, so `a[i]`'s address arithmetic (`cgArrElemAddr`) matches the pool layout by construction. `cgEmitStoreArr(dst, src)` with `src` an `EArrLit` already works (it calls `cgExprAddr(src)` then `cgBlockCopy`). Confirm `cgExpr(EArrLit)` in scalar value context aborts with the existing "non-scalar reached in value context" message rather than emitting garbage.

- [ ] **Step 7: cprint.** After `cpEmitStrLits()` in the emission order add `cpEmitArrLits()`:
```
func cpEmitArrLits() {
    var i: int
    var j: int
    var body: text
    var ty: int

    i = 0
    while i < irArrLitCount() {
        ty = irArrType(irArrLitElemT[i], irArrLitN[i])
        cpEnsureArr(ty)
        body = ""
        j = 0
        while j < irArrLitN[i] {
            if j > 0 { body = body + ", " }
            body = body + numToStr(irArrLitVal(i, j))
            j = j + 1
        }
        cpRecBuf.add("static const " + cpCTypeName(ty) + " clar_arrlit_" + numToStr(i) + " = {{" + body + "}};")
        i = i + 1
    }
}
```
It goes into `cpRecBuf` (not `cpLitBuf`) because `cpEnsureArr` writes the wrapper typedef there and the literal must follow it. `irArrType(elem, n)` is whatever `ir.cla` calls the fixed-array type constructor (`grep -n 'KArr' clarusc/ir.cla | head`). `fpExpr`: `case EArrLit { return toText("clar_arrlit_" + numToStr(irArrLitIdx(e))) }`. A `var` store then prints as a plain struct assignment (`cv_table = clar_arrlit_0;`, the wrapper struct is assignable) and `fpIndexRef` on an `EArrLit` base prints `(clar_arrlit_0).e[...]`; a borrowed `const` array argument prints `&(clar_arrlit_0)` once Task 9 lands (until then it copies by value, which is also correct).

- [ ] **Step 8: bake.cla.** Section id: `grep -n '^const bkSec' clarusc/bake.cla | sort -t= -k2 -n | tail -1` gives the highest; use the next integer. Writer, after `bkWriteIrStrLits`:
```
func bkWriteIrArrLits(): text {
    var sec: text
    var i: int
    var j: int

    bkPutU32(sec, irArrLitCount())
    i = 0
    while i < irArrLitCount() {
        bkPutU32(sec, irArrLitElemT[i])
        bkPutU32(sec, irArrLitN[i])
        j = 0
        while j < irArrLitN[i] {
            bkPutU32(sec, irArrLitVal(i, j))
            j = j + 1
        }
        i = i + 1
    }
    return sec
}
```
Emit it right after `bkEmitSection(body, bkSecIrStrLits, ...)` (~1779). Reader: in the section switch (~3492) add `} else if id == bkSecIrArrLits { bkReadIrArrLits() }` filling `bkLdIrArrLitElemT/N/Vals` lists, and install them into `irArrLit*` at the same point `bkLdIrStrLits` is installed (~4226-4240 — read the clone/truncate logic there: baked entries come first, user entries are appended after, and the drift fallback truncates back to the baked count; mirror it with a `bkLdBaseIrArrLitsCount` captured where `bkGenBaseIrStrLitsCount` is, ~751 and ~1449). `bkObjRelocSymValid`: `if cls == cgRelClsPoolArr { return sym >= 0 and sym < bkLdIrArrLitElemT.count }`. Every other `cgRelClsPoolEnum` switch in bake.cla (`grep -n cgRelClsPoolEnum clarusc/bake.cla`) gets an `Arr` twin. `bkFormatVersion` 7 -> 8 (if Task 12 already merged and bumped it, leave 8). Element IR types are arena indices: check how `bkWriteIrStrLits`' neighbours serialize an IR TYPE index (the IR type arena is itself baked — `grep -n 'bkSecIrTypes' clarusc/bake.cla`) so `irArrLitElemT[i]` survives the load as a valid index.

- [ ] **Step 9: bake twin.** `tests/bake/arrlit.sh`, modeled on `tests/bake/connfileh.sh`: bake `68k`, write a fixture with one `const` array read in a handler and one `var` array initializer, `emit68k_pair arrlit "$WORK/arrlit.cla"`, `t_pass`/`t_fail`, `t_done`. Also run `CLARUS_BAKE_FULL=1 make test T=bake/` once at the end of this task and report.

- [ ] **Step 10: Reference.** Constants section (~431): after the existing `const` paragraph add a fenced example and prose:
```rust
const kermitTab: int[4] = [0x0000, 0x1189, 0x2312, 0x329B]
var keymap: char[3] = ['a', 'b', 'c']
```
"An **array literal** `[e1, e2, …]` is legal only as the initializer of a `const` or `var` whose declared type is a fixed array `T[n]`. Its elements follow the `const` rule above (a literal, an enum member, or a previously declared constant — no expressions), `T` must be `int`, `fixed`, `char`, `bool`, or an enum, and the element count must equal `n` exactly; a mismatch is a compile error naming both counts. A `const` array lives in the program's constant pool: reading `tab[i]` costs one bounds-checked load and nothing at startup, and passing it to a function borrows it in place. A `var` array with a literal is copied from the pool once, when the variable is initialized. Assigning to an element of a `const` array is a compile error. Nested literals, `string(n)` or record elements, and array literals in any other expression position are not supported." Also the `T[n]` row of the type table (~159): append "; literal initializer `[…]` for `const`/`var` declarations (Constants)". Then the fence manifest: the new fence shifts every later index by one. Recipe:
```sh
# lib_reftest.sh's `fences FILE find SUBSTR` prints the 0-based index of the
# first ```rust fence containing SUBSTR (tests/lib_reftest.sh:8).
new=$(sh -c '. tests/lib.sh; . tests/lib_reftest.sh; fences "$REFMD" find kermitTab')
awk -v n="$new" '
    /^[0-9]+$/        { if ($1 + 0 >= n) $1 = $1 + 1 }
    /^# [0-9]+/       { split($0, a, " "); if (a[2] + 0 >= n) sub(/^# [0-9]+/, "# " (a[2] + 1)) }
    { print }' tests/reftest/manifest.txt > /tmp/m && mv /tmp/m tests/reftest/manifest.txt
printf '%s\n' "$new" >> tests/reftest/manifest.txt   # the new fence checks clean standalone
```
(`fences FILE find SUBSTR` prints the 0-based index of the first fence containing SUBSTR — see `tests/lib_reftest.sh:8`.) Sort the manifest's numeric lines back into position if the script requires order (read `manifest_indices`; it only greps, so append is fine). `make test T=reftest/` — green, and `tests/reftest/required.sh` still passes.

- [ ] **Step 11: Errors goldens.** Generate the two `.expect` files per `tests/selfhost/diag.sh`; `make test T=selfhost/diag`.

- [ ] **Step 12: Run everything.** `make -j tools bootstrap`; `scripts/clarus-run.sh testdata/run/arrlit.cla` → matches `.out` (fix the `.out` if the alert format differs, never the assertion); `make test T=cg68k/goldens` (new fixture has no golden yet — it reports missing; Task 15 blesses) and `build-run/clarusc-current emit68k --listing -o /tmp/a.bin testdata/cg68k/arrlit.cla` must succeed with the pool section visible in `/tmp/a.seg1.s`; `scripts/test-task.sh --smoke`; `make test T=bake/ T=selfhost/modules`.

- [ ] **Step 13: Native proof.** Add an array-literal arm to the core suite's `Arr` case (`testsuite/core/cases_arr.cla`, existing case function — no new enum member): a module-level `const coreArrLitTab: int[4] = [3, 1, 4, 1]` read in the case plus a `var` initializer, asserting the values. `pgrep -x minivmac || CLARUS_MAC_TESTS=1 make -j1 test T=mactest/coresuite_68k`.

- [ ] **Step 14: Commit** (one commit per layer is fine, or one for the task):
```sh
git add clarusc/ast.cla clarusc/parse.cla clarusc/types.cla clarusc/check.cla clarusc/ir.cla clarusc/lower.cla clarusc/cg68k.cla clarusc/cprint.cla clarusc/bake.cla docs/clarus-language-reference.md tests/reftest/manifest.txt testdata/ tests/bake/arrlit.sh testsuite/core/cases_arr.cla
git commit -m "feat(lang): array-literal initializers -- const arrays in a dedicated pool class, var arrays block-copied; CLIR v8"
```

---

### Task 8: Global initializers that call functions; one extern-index scan (spec §3.2, §3.3)

**Files:**
- Modify: `clarusc/cg68k.cla` (`cgEmitInitGlobalsStub` ~5039; `cgExternIdxByName` ~10437)
- Modify: `clarusc/cprint.cla` (`cpEmitFuncs` ~6025 split; the emission order ~7717-7724; `fpExternIdxByName` ~1600)
- Create: `testdata/run/global_init_call.cla` + `.out`
- Modify: `testsuite/core/cases_misc.cla` (a global initialized by a call, asserted in the existing case function)

- [ ] **Step 1: Fixture.**
```
// global_init_call.cla (language-runtime-cleanup, spec %3.2): a top-level
// initializer may call a function (reference, Ch1 initialization order).
// Pre-phase this aborted natively (no temp pool in cg_init_globals) and
// failed to compile on the host (the call was printed before its prototype).
func mk(): text {
    var t: text

    t.append("made")
    return t
}

func readsLater(): int {
    return later + 1
}

var g: text = mk()
var h: text = "ab" + "c"
var early: int = readsLater()
var later: int = 41

on App.launch {
    alert("g = " + g)
    alert("h = " + h)
    alert("early = " + string(early))
}
```
Expected `.out`: `g = made`, `h = abc`, `early = 1` (declaration order: `later` is still 0 when `early`'s initializer runs — the reference's own caution). Adjust `alert`'s output shape to match existing `.out` files.

- [ ] **Step 2: cprint.** Split `cpEmitFuncs` into `cpEmitFuncProtos()` (the first loop, prototypes) and `cpEmitFuncBodies()` (the second); change the call sequence to `cpEmitAbortGlobals(); cpEmitExternProtos(); cpEmitFuncProtos(); cpEmitGlobalsInit(); cpEmitCallbackGlueProtos(); cpEmitFuncBodies();`. Global declarations (`static T cv_g;`) are emitted by `cpEmitGlobalsInit` and function bodies reference them, so bodies must stay after it — they do. Update the `cpEmitRcWalks` ordering comment (it names `cpEmitFuncs`). This moves the prototype block above the globals in EVERY emitted C file, so all 22 `emitui` goldens move (Task 15 regenerates them; report the count).

- [ ] **Step 3: cg68k stub temp pool.** `cgEmitInitGlobalsStub` runs in both the measure pass (`cgRecMode == 1`) and the real pass, exactly like a function. Give it its own pool with two module-level high-water globals:
```
var cgInitGlobalsSmallNeed: int
var cgInitGlobalsBigNeed: int
```
In the stub, before the LINK: compute `runningNeg = 0`, lay out `cgInitGlobalsSmallNeed` small slots (4 bytes each, descending, into a fresh `cgTmpBaseOffs`), then `cgBigTmpFloor`-or-`cgInitGlobalsBigNeed` big slots (`cgBigTmpSize` each) into a fresh `cgBigTmpBaseOffs`, then `runningNeg = cgReserveDeepScratch(runningNeg)`, `cgSmallTmpFirstOff = runningNeg - 4`, `frameSize = 0 - runningNeg`; set `cgStmtTmpNext = 0`, `cgStmtBigTmpNext = 0`, `cgFuncSmallTmpHigh = 0`, `cgFuncBigTmpHigh = 0`; emit `LINK A6,#-frameSize`. This is `cgEmitFunc`'s ~5318-5395 layout with the function's own need tables swapped for the two globals — copy that block, do not re-derive it. After each `cgEmitGlobalInitExpr(i, gt, initE)` call the same end-of-statement flush a statement gets (`grep -n 'func cgFreeStmtTmps\|func cgFlushStmt' clarusc/cg68k.cla` — the routine `cgStmt` calls after every statement to release tracked temps and reset `cgStmtTmpNext`/`cgStmtBigTmpNext`), so a `text`-returning call's +1 result handed into the global is released correctly and the next initializer starts from an empty per-statement pool. At the end of the stub (both passes) record `cgInitGlobalsSmallNeed = cgFuncSmallTmpHigh` and `cgInitGlobalsBigNeed = cgFuncBigTmpHigh` when `cgRecMode == 1`; reset both to 0 wherever `cgFuncSmallTmpNeed` is reset between compiles. In the real pass `cgAllocTmpOff`'s "emitted outside a laid-out function frame" abort can no longer fire from here — delete that clause of its message.

- [ ] **Step 4: One scan.** `cgExternIdxByName` body becomes `return irExternLookup(nameIdx)`; `fpExternIdxByName` likewise (keep both names — their callers are unchanged — and shrink the doc comments to one line each pointing at `irExternLookup`).

- [ ] **Step 5: Native assertion.** In `testsuite/core/cases_misc.cla`, at module level: `func coreMkInitText(): text { var t: text; t.append("init-call"); return t }` and `var coreInitViaCall: text = coreMkInitText()`; in the existing `caseMisc` (or whichever case the file holds — read it) add `if coreInitViaCall != "init-call" { return tkFail(...) }` before its final `tkPass`.

- [ ] **Step 6: Verify.** `make -j tools bootstrap`; `scripts/clarus-run.sh testdata/run/global_init_call.cla` matches `.out`; `build-run/clarusc-current emit68k -o /tmp/g.bin testdata/run/global_init_call.cla` succeeds (pre-fix it aborted); `scripts/test-task.sh --smoke` (emitui goldens fail as expected — report count); `pgrep -x minivmac || CLARUS_MAC_TESTS=1 make -j1 test T=mactest/coresuite_68k`.

- [ ] **Step 7: Commit.**
```sh
git add clarusc/cg68k.cla clarusc/cprint.cla testdata/run/global_init_call.cla testdata/run/global_init_call.out testsuite/core/cases_misc.cla
git commit -m "compiler: global initializers may call functions on both lanes; one extern-index scan"
```

---

### Task 9: `KArr` borrow ABI for handle-free arrays (spec §3.4)

**Files:**
- Modify: `clarusc/lower.cla` (~1200 the copy gate)
- Modify: `clarusc/cg68k.cla` (new `cgParamByRef(t)`; `cgArgSlotSize` ~5843; the callee frame-ref marking ~5217; `cgPushArgs`' by-address gate ~10007; `cgMaterializeToTemp` ~5891 `KArr` arm)
- Modify: `clarusc/cprint.cla` (new `cpParamByRef(t)`; `cpByRefParams` fill ~5830; `cpFuncProto` ~4966+26; `fpCallFnArg` ~1437)
- Modify: `docs/clarus-language-reference.md` (Chapter 6 parameters, one sentence)
- Create: `testdata/cg68k/karr_param.cla`; `testdata/run/karr_abi.cla` + `.out`
- Modify: `testsuite/core/cases_param.cla` (array arm in the existing case)

**Interfaces:**
- Produces: `cgParamByRef(t: int): bool` = `k == KStr or k == KRec or k == KErr or (k == KArr and not cgNeedsRelease(t))`; `cpParamByRef(t)` = the same predicate spelled with cprint's `fpNeedsRelease`-family test for a handle-bearing element (read `fpNeedsRelease` and `irRecHasHandleField`; an array is handle-bearing when its element, recursively through records and nested arrays, contains `text`/`list`/`map`). Both sides of a call consult ONLY this predicate.

- [ ] **Step 1: Fixtures.** `testdata/run/karr_abi.cla`:
```
// karr_abi.cla (language-runtime-cleanup, spec %3.4): fixed arrays pass by
// address when the callee cannot observe a mutation (plain borrow), by copy
// when the argument aliases a global the callee writes, and forwarded
// borrows stay borrows.
var g: int[4]

func sum4(a: int[4]): int {
    return a[0] + a[1] + a[2] + a[3]
}

func fwd(a: int[4]): int {
    return sum4(a)
}

func bump(a: int[4]): int {
    g[0] = 100
    return a[0]
}

on App.launch {
    var l: int[4]

    l[0] = 1
    l[1] = 2
    l[2] = 3
    l[3] = 4
    g[0] = 7
    alert("sum = " + string(sum4(l)))
    alert("fwd = " + string(fwd(l)))
    alert("bump = " + string(bump(g)))
    alert("g0 = " + string(g[0]))
}
```
Expected: `sum = 10`, `fwd = 10`, `bump = 7` (the copy rule: `g` aliases a global `bump` writes, so `a` is a snapshot and still reads 7), `g0 = 100`. `testdata/cg68k/karr_param.cla` is the same program without alerts (a `.s` golden Task 15 blesses; its listing shows `LEA`+push for the borrow and a block copy for the aliased call).

- [ ] **Step 2: Lower.** `lower.cla:1200`: `if (k == KStr or k == KRec or k == KArr) and lowArgNeedsCopy(le) {` — `lowArgNeedsCopy`'s root walk already treats `KArr` as a value kind (`lowIsValueKind`, ~1024), so the aliasing classification works unchanged. The copy must be skipped for a handle-bearing array (by-value stays): gate with the checker-visible equivalent of `cgNeedsRelease` if lower has one (`lowIsRecBearing`/`lowTypeNeedsRelease` — grep); otherwise mark the copy and let the backends ignore the mark for by-value arrays (they do: `irArgNeedsCopy` is only consulted on the by-address path).

- [ ] **Step 3: cg68k.** Add the predicate next to `cgArgSlotSize`:
```
// cgParamByRef (language-runtime-cleanup, spec %3.4): the ONE predicate both
// the caller (cgPushArgs/cgArgSlotSize) and the callee (cgEmitFunc's frame
// ref bit) consult for "this parameter kind passes by address". KArr joins
// KStr/KRec/KErr when its element carries no handle -- a handle-bearing
// array would need a retain walk on the copy path and stays by value.
func cgParamByRef(t: int): bool {
    var k: IRKind

    k = irtKind(t)
    if k == KStr or k == KRec or k == KErr {
        return true
    }
    return k == KArr and not cgNeedsRelease(t)
}
```
Replace the three existing `KStr or KRec or KErr` tests (`cgArgSlotSize`, the frame-ref marking in `cgEmitFunc` ~5217, `cgPushArgs` ~10007) with `cgParamByRef(t)`. In `cgPushArgs`' materialize branch the `KRec` retain/schedule sub-arms stay `KRec`-only; a copied `KArr` needs no retain. `cgMaterializeToTemp`: add `} else if irtKind(t) == KArr { cgEmitStoreArr(dst, e) }` before the scalar fallback. `cgAllocBigTmpOff`'s size abort fires for an array over `cgBigTmpSize` (512) that needs a copy — reword that message to name arrays too ("str/rec/array temp >512 bytes ... an array argument that aliases a global the callee writes needs a copy; pass a smaller array or a `list`"). `cgIsAddressableArgShape` must accept an `EVarRef`/`EFieldRef`/`EIndexRef`/`EArrLit` base for `KArr` (read it; it is kind-gated).

- [ ] **Step 4: cprint.** `cpParamByRef(t)` next to `cpByRefParams`; the fill loop (~5830) and `cpFuncProto`'s `const T *` arm use it. `fpCallFnArg`: change the early `if k != KStr and k != KRec { return fpExpr(a) }` to `if not cpParamByRef(t) { return fpExpr(a) }`, and in the borrow/copy logic below, the `KRec`-specific retain remains `KRec`-gated (`handleBearing` is already computed from `irRecHasHandleField`); a `KArr` borrow prints `&(<addrable>)` via `fpAddrable` (confirm it handles a `KArr` var/index/field; `EArrLit` prints `&(clar_arrlit_N)` — a `const` array borrowed into a `const T *` parameter is exactly right) and a `KArr` copy uses the untracked `fpNewTmp` path.

- [ ] **Step 5: Reference.** Chapter 6, the parameters-are-immutable paragraph (~850): append "Fixed arrays with scalar elements are passed by reference like `string` and `record` values (the callee borrows the caller's storage; a copy is made only when the argument aliases storage the callee writes), so passing a large table costs nothing."

- [ ] **Step 6: Suite arm.** In `cases_param.cla`'s existing case, add the `sum4`/`bump` shapes with a module-level global and assert the same four values.

- [ ] **Step 7: Verify.** `make -j tools bootstrap`; run `karr_abi.cla` on the host and compare; `scripts/test-task.sh --smoke` (cg68k goldens for every fixture passing an array move — report); `pgrep -x minivmac || CLARUS_MAC_TESTS=1 make -j1 test T=mactest/coresuite_68k`.

- [ ] **Step 8: Commit.**
```sh
git add clarusc/lower.cla clarusc/cg68k.cla clarusc/cprint.cla docs/clarus-language-reference.md testdata/ testsuite/core/cases_param.cla
git commit -m "compiler(abi): fixed arrays of scalars pass by address (borrow-or-copy), one shared predicate per lane"
```

---

### Task 10: `cg_init_globals` skips all-zero defaults; looped array init (spec §3.5)

**Files:**
- Modify: `clarusc/cg68k.cla` (`cgEmitInitGlobalsStub` ~5039; `cgArrDefaultAt` ~3567; new `cgDefaultIsAllZero`; read `cgEmitStartup`'s below-A5 zero loop first)

- [ ] **Step 1: Confirm the sweep.** Read `cgEmitStartup` (grep `func cgEmitStartup`) and find the loop that zeroes the A5 globals area before `cg_init_globals` is called. Cite its label/line in the new predicate's comment. If no such loop exists, STOP: the skip is unsound; report and do only the array loop half.

- [ ] **Step 2: Predicate.**
```
// cgDefaultIsAllZero (language-runtime-cleanup, spec %3.5): true when t's
// default value is all-zero bytes, so a GLOBAL of that type needs no
// cg_init_globals store at all -- cgEmitStartup's below-A5 sweep (see
// <cite>) already zeroed it. Locals are NOT pre-zeroed and keep their
// explicit default-init.
func cgDefaultIsAllZero(t: int, scalarDefault: int, strDefaultIdx: int): bool {
    var k: IRKind
    var ri: int
    var f: int

    k = irtKind(t)
    if k == KInt or k == KBool or k == KFixed or k == KChar or k == KEnum {
        return scalarDefault == 0
    }
    if k == KPtr or k == KWinRef or k == KOverlay {
        return true
    }
    if k == KStr {
        return strDefaultIdx == -1
    }
    if k == KArr {
        return cgDefaultIsAllZero(irtElem(t), 0, -1)
    }
    if k == KRec {
        ri = cgFindRecordByName(irtName(t))
        f = irRecordLayoutFieldsHead(ri)
        while f != -1 {
            if not cgDefaultIsAllZero(irFieldSlotType(f), irFieldSlotDefault(f), irFieldSlotDefaultStr(f)) {
                return false
            }
            f = irFieldSlotNext(f)
        }
        return true
    }
    return false
}
```
(`KText`/`KList`/`KMap`/`KSortedMap`/`KIntMap`/`KErr`/`KUiState` → false: containers need a birth call; KErr keeps its explicit init for safety.) In `cgEmitInitGlobalsStub`: `if not fullReplace and not cgDefaultIsAllZero(gt, 0, -1) { cgDefaultInitAt(5, cgGlobalOffsets[i], gt, 0, -1) }`.

- [ ] **Step 3: Loop for large zero arrays (locals).** In `cgArrDefaultAt`, when `cgDefaultIsAllZero(et, 0, -1)` and `n * esz > 32` and `reg == 6` (a frame-relative local — the only caller where D0/A0 are free at this point; keep the unrolled path for `reg == 0`'s mid-expression walks and for records):
```
        // language-runtime-cleanup: a large all-zero array local -- one
        // CLR.L loop instead of n unrolled stores.
        a68Emit(OpLea, 0, AmDisp16, reg, off, AmAn, 0, 0)
        words = (n * esz) / 4
        a68Emit(OpMove, 4, AmImm, 0, words - 1, AmDn, 0, 0)
        loopLbl = a68NewLabel()
        a68Bind(loopLbl)
        a68Emit(OpClr, 4, AmNone, 0, 0, AmPostInc, 0, 0)
        a68Emit(OpDbra, 0, AmDn, 0, 0, AmLabel, 0, loopLbl)
        tail = (n * esz) - words * 4
        if tail >= 2 { a68Emit(OpClr, 2, AmNone, 0, 0, AmPostInc, 0, 0); tail = tail - 2 }
        if tail == 1 { a68Emit(OpClr, 1, AmNone, 0, 0, AmInd, 0, 0) }
```
Read `asm68k.cla`'s opcode/addressing-mode enums for the exact `OpClr`/`OpDbra`/`AmPostInc`/`AmImm`/`AmLabel` spellings and the DBRA operand form used elsewhere (`grep -n OpDbra clarusc/cg68k.cla | head -3`); DBRA counts a 16-bit word, so cap `words - 1` at 65535 (an array that large cannot exist in a 32 KB frame anyway). If a `reg == 5` (global) caller can reach here it is now skipped by Step 2, so only `reg == 6` matters.

- [ ] **Step 4: Verify.** `make -j tools bootstrap && scripts/test-task.sh --smoke`. Every `cg68k` golden's `cg_init_globals` shrinks — report the total `.s` line delta (`for f in testdata/cg68k/*.cla; do ...; done | wc -l` before/after, or Task 15 does it) and paste one `first_diff`. The runtime-error fixtures (`testdata/runerr`) and `selfhost/behavior` still pass on the host lane (unchanged C). Native: `pgrep -x minivmac || CLARUS_MAC_TESTS=1 make -j1 test T=mactest/coresuite_68k T=mactest/toolbox_68k` — every global still reads its default (the suites' own globals are the proof; `SelfCheck` counts).

- [ ] **Step 5: Commit.**
```sh
git add clarusc/cg68k.cla
git commit -m "cg68k: cg_init_globals skips all-zero defaults; CLR.L loop for large zero array locals"
```

---

### Task 11: `file.openRF` — resource-fork `filehandle`, both lanes (spec §6)

**Files:**
- Modify: `clarusc/check.cla` (`fileFuncs["open"]` ~1723 — add `openRF`; the `usesFileh` hook ~2117-2129 — add `openRF` to its name list)
- Modify: `clarusc/lower.cla` (~1777 the `"open"` arm — add `"openRF"`)
- Modify: `runtime/clarus/fileh.cla` (~60 `rtFhOpen` — add `rtFhOpenRF`), `runtime/clarus/fileh_68k.cla` (~89 `rtFhDevOpen` — add `rtFhDevOpenRF`), `runtime/clarus/fileh_c.cla` (~31/~50 — `FhHOpenRF` extern + `rtFhDevOpenRF`)
- Modify: `toolbox/files.cla` (declare `PBOpenRFSync` = trap `0xA00A` beside `PBOpenSync`, with the IM citation line the file's other single-trap entries carry)
- Modify: `runtime/host/rt_fileh.inc` (`rt_ext_FhHOpenRF`; `rt_ext_FhHFlush` ~177 and `rt_ext_FhHClose` ~192 gain the sidecar write-back), `runtime/host/rt_fileh_test.c`
- Modify: `docs/clarus-language-reference.md` (file table ~1457; `filehandle` section ~1482), `tests/bake/connfileh.sh` (one `openRF` line in its fixture)
- Modify: `testsuite/core/cases_fileh.cla` (new `caseOpenRF`), `testsuite/core/runner.cla` (`OpenRF` member, name, `l.add`, dispatch, `nCoreCases` +1), `tests/mactest/coresuite_68k.sh` (`suite_report_check` literal +1)
- Create: `testdata/run/openrf.cla` + `.out`

**Interfaces:**
- Produces: `file.openRF(path: string): filehandle`; runtime `rtFhOpenRF(path: string): int`; per-lane `rtFhDevOpenRF(path: string): int`; host `int32_t rt_ext_FhHOpenRF(const uint8_t *path)`; env var `CLARUS_FORCE_APPLEDOUBLE=1`.

- [ ] **Step 1: Compiler.** `check.cla`: after `fileFuncs["open"] = sigEnd(fileHandleT)` add the same `sigStart(); sigAdd(psPlain(strT(255))); fileFuncs["openRF"] = sigEnd(fileHandleT)` block (copy `open`'s exactly); in the `usesFileh` hook, wherever `"open"` appears in the name test, add `or name == "openRF"`. `lower.cla`: `} else if nm == "openRF" { return newIRCallFn(intern("rtFhOpenRF"), lowArgs(callArgsHead(e)), ty) }`.

- [ ] **Step 2: Runtime, shared + native.** `fileh.cla`:
```
// rtFhOpenRF (language-runtime-cleanup, spec %6): the resource-fork twin of
// rtFhOpen -- same handle, same positioned I/O, a different fork.
func rtFhOpenRF(path: string): int {
    var h: int

    h = rtFhDevOpenRF(path)
    if h == 0 {
        rtSetLastErr(rtFhDevLastOSErr(), "open failed")
    }
    return h
}
```
`toolbox/files.cla`: `external func PBOpenRFSync(paramBlock: ptr): int = trap 0xA00A reg` with a citation comment in the file's own style (`_OpenRF`, Files.h `PBOpenRFSync`, IM IV). `fileh_68k.cla`: `rtFhDevOpenRF` is `rtFhDevOpen` verbatim with `PBOpenRFSync(pb)` in place of `PBOpenSync(pb)` (same `IOParam`, same `fsRdWrPerm`). `fileh_c.cla`: `external func FhHOpenRF(path: string): int` next to `FhHOpen` and `func rtFhDevOpenRF(path: string): int { return FhHOpenRF(path) }`.

- [ ] **Step 3: Host lane.** In `rt_fileh.inc`, after `rt_ext_FhHOpen`:
```c
/* ==================== resource fork (language-runtime-cleanup, spec %6.3) ====================
 * macOS: the fork is the file's com.apple.ResourceFork xattr, reachable as
 * an ordinary fd through the "<path>/..namedfork/rsrc" pseudo-path; the
 * kernel stores it natively on APFS/HFS+ and as an AppleDouble "._name"
 * sidecar on FAT/NFS/SMB-without-streams, so this one open covers every
 * volume. Elsewhere (and on macOS under CLARUS_FORCE_APPLEDOUBLE=1, the
 * harness's way to exercise this path on the dev machine): the fork lives
 * in an AppleDouble v2 sidecar "._name" beside the data file -- the exact
 * layout macOS writes on non-native volumes, so a sidecar written here is a
 * real fork to a Mac reading the same share. It is mirrored into an
 * unlinked temp file at open (so readAt/writeAt/size/setSize need no
 * fork-specific code) and written back on flush and close. */
#define RT_FH_RF_MAX 32
static struct { int fd; char sidecar[1024]; unsigned char finfo[32]; int hasFinfo; } rt_fh_rf[RT_FH_RF_MAX];

static int rt_fh_rf_slot(int fd) { int i; for (i = 0; i < RT_FH_RF_MAX; i++) if (rt_fh_rf[i].fd == fd + 1) return i; return -1; }

static uint32_t rt_fh_be32(const unsigned char *p) { return ((uint32_t)p[0] << 24) | ((uint32_t)p[1] << 16) | ((uint32_t)p[2] << 8) | p[3]; }
static void rt_fh_put32(unsigned char *p, uint32_t v) { p[0] = (unsigned char)(v >> 24); p[1] = (unsigned char)(v >> 16); p[2] = (unsigned char)(v >> 8); p[3] = (unsigned char)v; }

/* rt_fh_sidecar_load: copy the sidecar's resource-fork entry (id 2) into fd
 * and stash its Finder-info entry (id 9, 32 bytes) for the rewrite. A
 * missing sidecar is an empty fork. Returns -1 only on a malformed header. */
static int rt_fh_sidecar_load(int slot, int fd) {
    unsigned char hdr[26], ent[12], buf[4096];
    FILE *f; uint32_t n, i, id, off, len, done;
    f = fopen(rt_fh_rf[slot].sidecar, "rb");
    if (!f) return 0;
    if (fread(hdr, 1, 26, f) != 26 || rt_fh_be32(hdr) != 0x00051607u) { fclose(f); return -1; }
    n = ((uint32_t)hdr[24] << 8) | hdr[25];
    for (i = 0; i < n; i++) {
        if (fseek(f, 26 + (long)i * 12, SEEK_SET) != 0 || fread(ent, 1, 12, f) != 12) { fclose(f); return -1; }
        id = rt_fh_be32(ent); off = rt_fh_be32(ent + 4); len = rt_fh_be32(ent + 8);
        if (id == 9 && len == 32) { fseek(f, (long)off, SEEK_SET); if (fread(rt_fh_rf[slot].finfo, 1, 32, f) == 32) rt_fh_rf[slot].hasFinfo = 1; }
        if (id == 2) {
            fseek(f, (long)off, SEEK_SET);
            for (done = 0; done < len; ) {
                size_t want = len - done > sizeof buf ? sizeof buf : len - done;
                size_t got = fread(buf, 1, want, f);
                if (got == 0) break;
                if (pwrite(fd, buf, got, (off_t)done) < 0) { fclose(f); return -1; }
                done += (uint32_t)got;
            }
        }
    }
    fclose(f);
    return 0;
}

/* rt_fh_sidecar_store: rewrite the sidecar from fd's current contents --
 * header (26 bytes), two entries (Finder info at 50, resource fork at 82).
 * An empty fork with no Finder info removes the sidecar instead. */
static int rt_fh_sidecar_store(int slot, int fd) {
    unsigned char hdr[82], buf[4096]; struct stat st; FILE *f; off_t pos; ssize_t got;
    if (fstat(fd, &st) != 0) return -1;
    if (st.st_size == 0 && !rt_fh_rf[slot].hasFinfo) { unlink(rt_fh_rf[slot].sidecar); return 0; }
    memset(hdr, 0, sizeof hdr);
    rt_fh_put32(hdr, 0x00051607u); rt_fh_put32(hdr + 4, 0x00020000u); hdr[24] = 0; hdr[25] = 2;
    rt_fh_put32(hdr + 26, 9); rt_fh_put32(hdr + 30, 50); rt_fh_put32(hdr + 34, 32);
    rt_fh_put32(hdr + 38, 2); rt_fh_put32(hdr + 42, 82); rt_fh_put32(hdr + 46, (uint32_t)st.st_size);
    memcpy(hdr + 50, rt_fh_rf[slot].finfo, 32);
    f = fopen(rt_fh_rf[slot].sidecar, "wb");
    if (!f) return -1;
    if (fwrite(hdr, 1, 82, f) != 82) { fclose(f); return -1; }
    for (pos = 0; pos < st.st_size; pos += got) {
        got = pread(fd, buf, sizeof buf, pos);
        if (got <= 0) break;
        if (fwrite(buf, 1, (size_t)got, f) != (size_t)got) { fclose(f); return -1; }
    }
    return fclose(f) == 0 ? 0 : -1;
}

int32_t rt_ext_FhHOpenRF(const uint8_t *path) {
    char cpath[256], tmpl[64], dirbuf[256], basebuf[256];
    struct stat st; int fd, slot, i;
    path_to_cstr(cpath, path);
    if (stat(cpath, &st) != 0) { rt_fh_errno = errno; return 0; }
#if defined(__APPLE__)
    if (!getenv("CLARUS_FORCE_APPLEDOUBLE")) {
        char rsrc[300];
        snprintf(rsrc, sizeof rsrc, "%s/..namedfork/rsrc", cpath);
        fd = open(rsrc, O_RDWR | O_CREAT, 0644);
        if (fd < 0) { rt_fh_errno = errno; return 0; }
        return (int32_t)(fd + 1);
    }
#endif
    slot = -1;
    for (i = 0; i < RT_FH_RF_MAX; i++) if (rt_fh_rf[i].fd == 0) { slot = i; break; }
    if (slot < 0) { rt_fh_errno = EMFILE; return 0; }
    strcpy(tmpl, "/tmp/clarus-rf-XXXXXX");
    fd = mkstemp(tmpl);
    if (fd < 0) { rt_fh_errno = errno; return 0; }
    unlink(tmpl);
    strcpy(dirbuf, cpath); strcpy(basebuf, cpath);
    snprintf(rt_fh_rf[slot].sidecar, sizeof rt_fh_rf[slot].sidecar, "%s/._%s", dirname(dirbuf), basename(basebuf));
    rt_fh_rf[slot].hasFinfo = 0; memset(rt_fh_rf[slot].finfo, 0, 32);
    if (rt_fh_sidecar_load(slot, fd) != 0) { close(fd); rt_fh_errno = EFTYPE; return 0; }
    rt_fh_rf[slot].fd = fd + 1;
    return (int32_t)(fd + 1);
}
```
(`EFTYPE` is BSD/macOS-only; use `EINVAL` if the Linux build complains.) `rt_ext_FhHFlush`: before its `fsync`, `slot = rt_fh_rf_slot(fd); if (slot >= 0 && rt_fh_sidecar_store(slot, fd) != 0) { rt_fh_errno = errno; return -1; }`. `rt_ext_FhHClose`: `slot = rt_fh_rf_slot(fd); if (slot >= 0) { rt_fh_sidecar_store(slot, fd); rt_fh_rf[slot].fd = 0; }` before `close(fd)`. Add `#include <stdlib.h>` and `#include <stdio.h>` if missing. Note the `dirname`/`basename` calls must use copies (they may modify their argument) — the existing rename/move code already does this.

- [ ] **Step 4: C harness.** In `rt_fileh_test.c` add `extern int32_t rt_ext_FhHOpenRF(const uint8_t *path);` and:
```c
/* test_openrf: a data-fork file gets a resource fork written, reopened,
 * and read back; the data fork is untouched. Runs twice on macOS -- once
 * through the native fork, once forced onto the AppleDouble sidecar -- and
 * once elsewhere. */
static void test_openrf_once(const char *label) {
    uint8_t path[256]; int32_t h; unsigned char rs[4] = "RSRC", buf[8]; int32_t got;
    mkpath(path, "fileh_test_rf.dat");
    h = rt_ext_FhHCreate(path);
    CHECK(h != 0, label);
    CHECK(rt_ext_FhHWriteAt(h, 0, (void *)"data!", 5) == 0, label);
    rt_ext_FhHClose(h);
    h = rt_ext_FhHOpenRF(path);
    CHECK(h != 0, label);
    CHECK(rt_ext_FhHWriteAt(h, 0, rs, 4) == 0, label);
    CHECK(rt_ext_FhHFlush(h) == 0, label);
    rt_ext_FhHClose(h);
    h = rt_ext_FhHOpenRF(path);
    CHECK(h != 0, label);
    CHECK(rt_ext_FhHSize(h) == 4, label);
    memset(buf, 0, sizeof buf);
    got = rt_ext_FhHReadAt(h, 0, buf, 4);
    CHECK(got == 4 && memcmp(buf, rs, 4) == 0, label);
    rt_ext_FhHClose(h);
    h = rt_ext_FhHOpen(path);
    CHECK(h != 0 && rt_ext_FhHSize(h) == 5, label);
    rt_ext_FhHClose(h);
    CHECK(rt_ext_FhHOpenRF((const uint8_t *)"\x08no.such") == 0, "openRF on a missing file fails");
    unlink("fileh_test_rf.dat"); unlink("._fileh_test_rf.dat");
}
static void test_openrf(void) {
    test_openrf_once("openRF native");
    setenv("CLARUS_FORCE_APPLEDOUBLE", "1", 1);
    test_openrf_once("openRF sidecar");
    { FILE *f; unsigned char m[4]; uint8_t path[256]; int32_t h;
      mkpath(path, "fileh_test_rf.dat"); h = rt_ext_FhHCreate(path); rt_ext_FhHClose(h);
      h = rt_ext_FhHOpenRF(path); rt_ext_FhHWriteAt(h, 0, (void *)"x", 1); rt_ext_FhHClose(h);
      f = fopen("._fileh_test_rf.dat", "rb"); CHECK(f != NULL, "sidecar written");
      if (f) { CHECK(fread(m, 1, 4, f) == 4 && m[0] == 0 && m[1] == 5 && m[2] == 0x16 && m[3] == 7, "AppleDouble magic"); fclose(f); }
      unlink("fileh_test_rf.dat"); unlink("._fileh_test_rf.dat"); }
    unsetenv("CLARUS_FORCE_APPLEDOUBLE");
}
```
Call `test_openrf()` from `main`. `make test T=hostrt/fileh`.

- [ ] **Step 5: Fixtures and cases.** `testdata/run/openrf.cla`: create `rf.dat` with `file.create`, write `"data!"`, close; `openRF`, `writeAt(0, t)` where `t` holds `"RSRC"`, close; `openRF` again, `readAt(0, f.size(), out)`, `alert(out)` and `alert(string(file.open("rf.dat").size()))` — expected `RSRC` then `5`; `file.delete("rf.dat")` at the end (and the sidecar: `file.delete("._rf.dat")` guarded by `file.exists`). `.out` accordingly. Core case `caseOpenRF` in `cases_fileh.cla` in the `caseFileHandleRW` shape (create, openRF, write, close, reopen, size == 4, read back, data fork size still 5, delete); register `OpenRF` in `runner.cla` after `StrPerf` (every site `grep -n StrPerf testsuite/core/runner.cla` shows), `nCoreCases` +1, `coresuite_68k.sh` literal +1. `tests/bake/connfileh.sh`: add `fh = file.openRF("scratch.dat")` + `fh.close()` after the existing `fh.close()`.

- [ ] **Step 6: Reference.** File table (~1457): `| openRF | file.openRF(path: string): filehandle | opens an existing file's resource fork read/write; nil + lastError if the file does not exist |`. `filehandle` section: a paragraph — "`file.openRF(path)` opens the resource fork of an existing file; the returned `filehandle` is identical in every way to `file.open`'s, so a whole-fork read is `f.readAt(0, f.size(), out)` and a fork written alongside an existing data fork is `file.create` (or an existing file), `openRF`, `writeAt`, `close`. On a host build the fork is stored where the host keeps it: on macOS as the file's `com.apple.ResourceFork` attribute (a real fork on APFS/HFS+, an AppleDouble `._name` sidecar on FAT/NFS/SMB volumes — the kernel chooses); on other hosts as that same AppleDouble sidecar beside the file, written on `flush` and `close`. `readResource`/`writeRes` are unchanged." No new fence → manifest untouched. `make test T=reftest/`.

- [ ] **Step 7: Verify.** `make -j tools bootstrap`; host run of `openrf.cla` matches `.out`; `CLARUS_FORCE_APPLEDOUBLE=1 scripts/clarus-run.sh testdata/run/openrf.cla` matches too; `scripts/test-task.sh --smoke`; `make test T=bake/connfileh T=hostrt/fileh T=testsuite/core_cli`; `pgrep -x minivmac || CLARUS_MAC_TESTS=1 make -j1 test T=mactest/coresuite_68k` (`PASS OpenRF`, `TOTAL 82 PASS 82 FAIL 0`).

- [ ] **Step 8: Commit.**
```sh
git add clarusc/check.cla clarusc/lower.cla runtime/clarus/fileh.cla runtime/clarus/fileh_68k.cla runtime/clarus/fileh_c.cla toolbox/files.cla runtime/host/rt_fileh.inc runtime/host/rt_fileh_test.c docs/clarus-language-reference.md tests/bake/connfileh.sh testsuite/core/ tests/mactest/coresuite_68k.sh testdata/run/openrf.cla testdata/run/openrf.out
git commit -m "feat(files): file.openRF -- resource-fork filehandle; native PBOpenRF, host xattr/AppleDouble"
```

---

### Task 12: Window-owned menu sets (`menus:` property) (spec §5)

**Files:**
- Modify: `clarusc/check.cla` (`buildUiTables` ~913 `windowTopProps["menus"]`; `checkWindowDecl`'s `DkProperty` arm ~3493)
- Modify: `clarusc/ir.cla` (`record IRWindowDesc`: `menuMask: int`; its constructor + accessor `irWindowDescMenuMask`)
- Modify: `clarusc/lower.cla` (~5860-5880 the window-property loop; `newIRWindowDesc` call; new `lowMenuDeclIndex`)
- Modify: `clarusc/uiblob.cla` (~929 `* 48` -> `* 52`; the window emission ~979-991: a 13th `uibI32`; the header comment naming 12 int32)
- Modify: `runtime/clarus/uidesc.cla` (~36 and ~305 comments; ~309 `* 48` -> `* 52`; new `uidWinMenuMask(winIdx): int` at `+48`; `uidNWins`-style count accessor — grep `func uidN` for the window count)
- Modify: `runtime/clarus/ui.cla` (~1259 `rtUiBuildMenus`; ~1370 `rtUiAfterFrontChange`; new `rtUiSyncMenuBar`; new globals `rtUiClaimedMask`, `rtUiBarMask`)
- Modify: `clarusc/bake.cla` (~1047 `bkWriteIrWindowDescs` and ~2746 its reader: put/get `menuMask`; `bkFormatVersion` 7 -> 8 if not already)
- Modify: `docs/clarus-language-reference.md` (Chapter 8 window property table ~1001; Chapter 9 a paragraph), `tests/reftest/manifest.txt` (only if a fence is added — the plan adds none; put the example inside the existing window-declaration fence? No: prose + the table row only)
- Create: `testsuite/toolbox/cases_winmenus.cla` (windows + menus + case); modify `runner.cla` (`WindowMenus`), `toolbox_files.txt` + `full_corpus_suite_toolbox.sh` (add the file just before `gui.cla`), `toolbox_68k.sh` + `toolbox_jiggle.sh` (+1)

**Interfaces:**
- Produces: window property `menus: A, B, ...` (identifiers naming declared menus, declared BEFORE the window); `IRWindowDesc.menuMask` (bit i = menu declaration index i claimed); blob window entry field 13 `menuMask`; `uidWinMenuMask(winIdx)`; `rtUiSyncMenuBar()`.

- [ ] **Step 1: Checker.** `windowTopProps["menus"] = 1`. In `checkWindowDecl`'s `DkProperty` arm, after the unknown-property test:
```
            if poolGet(propertyName(item)) == "menus" {
                vh = propertyValuesHead(item)
                if vh == -1 {
                    emitDiag(declLine(item), declCol(item), "menus: needs at least one menu name")
                }
                seenMenus.clear()
                nMenus = 0
                while vh != -1 {
                    if exprKind(vh) != ExIdent {
                        emitDiag(exprLine(vh), exprCol(vh), "menus: expects menu names")
                    } else {
                        symIdx = scopeLookup(curScope, identName(vh))
                        if symIdx == -1 or not symbols[symIdx].isMenu {
                            emitDiag(exprLine(vh), exprCol(vh), poolGet(identName(vh)) + " is not a declared menu")
                        } else if seenMenus.has(poolGet(identName(vh))) {
                            emitDiag(exprLine(vh), exprCol(vh), "menus: " + poolGet(identName(vh)) + " listed twice")
                        } else {
                            seenMenus[poolGet(identName(vh))] = 1
                        }
                    }
                    nMenus = nMenus + 1
                    vh = exprNext(vh)
                }
            }
```
(`seenMenus: map of int` and `symIdx`/`nMenus` as locals.) A menu declared AFTER the window is "not a declared menu" under declare-before-use — the reference says so (Step 6). Add a global cap check where menus are declared: if the program declares more than 31 menus, `emitDiag(..., "at most 31 menus per program")` (the mask is 32 bits with bit 31 unused; find the menu-declaration checker, `sym.isMenu = true` ~3899, and count there).

- [ ] **Step 2: IR + lower.** `IRWindowDesc` gains `menuMask: int` (last field); extend `newIRWindowDesc`'s parameter list and every caller (`grep -n newIRWindowDesc clarusc/*.cla`); accessor `irWindowDescMenuMask(i)`. In `lower.cla`'s window-property loop add:
```
            } else if pname == "menus" {
                v = vh
                while v != -1 {
                    menuMask = menuMask | (1 << lowMenuDeclIndex(identName(v)))
                    v = exprNext(v)
                }
            }
```
with `lowMenuDeclIndex(nameIdx)` walking the program's top-level declarations in order, counting `DkMenu` decls until the name matches (whole-program declaration order is the order `rtUiBuildMenus` creates them, `cases_menus.cla`'s header comment documents that rule). Find how top-level decls are iterated elsewhere in `lower.cla` (`declNext` over the program head) and the menu decl kind name (`grep -n DkMenu clarusc/ast.cla`).

- [ ] **Step 3: Blob + descriptor + bake.** `uiblob.cla`: `uibBaseWidgets = uibBaseWindows + irWindowDescs.count * 52`; after `uibI32(uibWindows, formOff)` add `uibI32(uibWindows, irWindowDescMenuMask(i))`; fix the "Window" comment (13 int32, 52 bytes). `uidesc.cla`: both stride sites to 52, comments to 13/52, and `func uidWinMenuMask(winIdx: int): int { return uidI32(uidWinBase(winIdx) + 48) }`. `bake.cla`: `bkPutU32(sec, irWindowDescs[i].menuMask)` after `formBindsHead`, `e.menuMask = bkGetU32()` in the reader; version 8. The C lane reads the same blob through the same `uidesc.cla`, so nothing else moves.

- [ ] **Step 4: Runtime.** `ui.cla`: two globals `var rtUiClaimedMask: int` and `var rtUiBarMask: int`. In `rtUiBuildMenus`, before the creation loop compute `rtUiClaimedMask` = OR of `uidWinMenuMask(w)` over every window type (`uidNWins()` or whatever the count accessor is — grep `uidWinsOff`'s neighbours); inside the loop replace `UiInsertMenu(mh, 0)` with `if (rtUiClaimedMask & (1 << i)) == 0 { UiInsertMenu(mh, 0); rtUiBarMask = rtUiBarMask | (1 << i) }`. New function after it:
```
// rtUiSyncMenuBar (language-runtime-cleanup, spec %5.2): the bar shows
// Apple + the app-scope menus (unclaimed by any window) + the FRONT
// window's own `menus:` set, in declaration order. Menus leaving the bar
// are deleted, arriving ones appended in index order (InsertMenu beforeID
// 0 = append), then one DrawMenuBar -- skipped entirely when nothing
// changes, so ordinary activation stays free. Every MenuHandle lives for
// the whole run; only bar membership changes.
func rtUiSyncMenuBar() {
    var front: ptr
    var inst: ptr
    var target: int
    var i: int
    var bit: int
    var mh: ptr

    if rtUiMenuHandlesArr == ptr(0) {
        return
    }
    target = (0x7FFFFFFF ^ rtUiClaimedMask) & ((1 << rtUiNMenusVal) - 1)
    front = UiFrontWindow()
    if front != ptr(0) and peekw(front + 108) == rtUiWindowKind {
        inst = rtUiWinstOf(front)
        if inst != ptr(0) {
            target = target | uidWinMenuMask(RtUiWinst(inst).winIdx)
        }
    }
    if target == rtUiBarMask {
        return
    }
    i = 0
    while i < rtUiNMenusVal {
        bit = 1 << i
        if (rtUiBarMask & bit) != 0 and (target & bit) == 0 {
            UiDeleteMenu(rtUiMenuIdBase + i)
        }
        i = i + 1
    }
    i = 0
    while i < rtUiNMenusVal {
        bit = 1 << i
        if (target & bit) != 0 and (rtUiBarMask & bit) == 0 {
            mh = ptr(peekl(rtUiMenuHandlesArr + i * 4))
            UiInsertMenu(mh, 0)
        }
        i = i + 1
    }
    rtUiBarMask = target
    UiDrawMenuBar()
}
```
(`peekw(wp + 108) == rtUiWindowKind` is the "one of ours" test `rtUiFlushAllBuffered` uses; `rtUiNMenusVal` and `rtUiMenuIdBase` exist.) Call it as the FIRST line of `rtUiAfterFrontChange()` (before `rtUiMenuRecomputeDim`) — that hook already fires on open, close, and click-to-front (`ui.cla:929, 983, 2460, 2474`). If a `menu M I` scripted verb maps its bar position to a handle-array index by subtracting 2 (read `rtUiScriptMenu` in `uiscript.cla`), leave it: the new case only drives its own menus through `UiTestMenu` while the owning window is front, at the bar position the case computes (Apple + app-scope count + 1).

- [ ] **Step 5: Case.** `testsuite/toolbox/cases_winmenus.cla` — declared BEFORE `gui.cla` in the file list, so `File` stays the last app-scope menu (its bar position is unchanged because the two new menus are claimed and never in the app-scope bar):
```
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// cases_winmenus.cla: WindowMenus (language-runtime-cleanup, spec %5.4).
// Two window types each claim one menu via `menus:`. The bar band's
// checksum must change when each becomes frontmost, revert when it closes,
// and a claimed menu's item must dispatch while its window is front.

menu WmA {
    item WmOne "One"
}

menu WmB {
    item WmTwo "Two"
}

window WmWinA {
    title: "WmA"
    size: 200, 100
    menus: WmA
}

window WmWinB {
    title: "WmB"
    size: 200, 100
    menus: WmB
}

var tbWmOneCount: int

extend WmA {
    on WmOne.select {
        tbWmOneCount = tbWmOneCount + 1
    }
}

// The bar band: y 0..19, full width, 8px-aligned per UiTestChecksum's
// contract (see uitest.cla's header).
const tbWmBarX: int = 0
const tbWmBarY: int = 0
const tbWmBarW: int = 512
const tbWmBarH: int = 20

func caseWindowMenus(): TestResult {
    var a: WmWinA
    var b: WmWinB
    var c0: int
    var c1: int
    var c2: int
    var c3: int

    c0 = UiTestChecksum(tbWmBarX, tbWmBarY, tbWmBarW, tbWmBarH)
    a = open WmWinA
    UiTestTick(1)
    c1 = UiTestChecksum(tbWmBarX, tbWmBarY, tbWmBarW, tbWmBarH)
    if c1 == c0 {
        close a
        return tkFail("WindowMenus", "bar unchanged with WmWinA front")
    }
    // WmA sits right after the app-scope menus: Apple(1) + Ops/Edit/File = position 5.
    if not UiTestMenu(5, 1) {
        close a
        return tkFail("WindowMenus", "menu verb rejected")
    }
    if tbWmOneCount != 1 {
        close a
        return tkFail("WindowMenus", "WmOne did not dispatch: " + tkIntToStr(tbWmOneCount))
    }
    b = open WmWinB
    UiTestTick(1)
    c2 = UiTestChecksum(tbWmBarX, tbWmBarY, tbWmBarW, tbWmBarH)
    if c2 == c1 or c2 == c0 {
        close b
        close a
        return tkFail("WindowMenus", "bar unchanged with WmWinB front")
    }
    close b
    UiTestTick(1)
    c3 = UiTestChecksum(tbWmBarX, tbWmBarY, tbWmBarW, tbWmBarH)
    if c3 != c1 {
        close a
        return tkFail("WindowMenus", "bar did not revert to WmWinA's set")
    }
    close a
    UiTestTick(1)
    if UiTestChecksum(tbWmBarX, tbWmBarY, tbWmBarW, tbWmBarH) != c0 {
        return tkFail("WindowMenus", "bar did not revert to the app-scope set")
    }
    return tkPass("WindowMenus")
}
```
Confirm the app-scope menu count (Ops, Edit, File = 3 → WmA at bar position 5) by reading `cases_menus.cla`'s derivation; if the harness has grown another app-scope menu, adjust the literal and say so in the report. `UiTestChecksum`'s width may need to be ≤ its alignment cap — read its contract; if 512 is rejected, checksum x 128..511 (the region right of the Apple menu). Register `WindowMenus` in `runner.cla` (after `CanvasIdle` if Task 1 merged first, else after `CasesTable`), `nTbCases` +1, file lists, boot-script literals +1.

- [ ] **Step 6: Reference.** Window property table row: `| menus | menus: File, Edit | the menus shown (after the app-wide ones) while a window of this type is frontmost; each must be declared above this window |`. Chapter 9, after "Window-Scoped Commands": "**Window-owned menus.** A window declaration may claim menus with `menus: A, B`. A menu claimed by any window is not part of the application-wide menu bar; it appears, after the application-wide menus and in declaration order, only while a window of a claiming type is frontmost, and leaves the bar when that window closes or another window comes to the front. Menus no window claims form the application-wide bar, exactly as before. Item enabling and window-scoped dimming are unaffected: every menu exists for the whole run, only its presence in the bar changes. At most 31 menus may be declared." `make test T=reftest/`.

- [ ] **Step 7: Verify.** `make -j tools bootstrap && scripts/test-task.sh --smoke` (every UI golden's blob widens by 4 bytes per window — report); `make test T=bake/`; `pgrep -x minivmac || CLARUS_MAC_TESTS=1 make -j1 test T=mactest/toolbox_68k` (`PASS WindowMenus`, and `Menus`/`Editmenu`/`MenuKeyMatches` still green — their bar positions are unchanged), then `T=mactest/smoke_mandel T=mactest/texteditor` (frozen scenarios with menus: no trace/snap movement expected, since no `menus:` clause exists in them).

- [ ] **Step 8: Commit.**
```sh
git add clarusc/check.cla clarusc/ir.cla clarusc/lower.cla clarusc/uiblob.cla clarusc/bake.cla runtime/clarus/uidesc.cla runtime/clarus/ui.cla docs/clarus-language-reference.md testsuite/toolbox/ tests/mactest/toolbox_files.txt tests/bake/full_corpus_suite_toolbox.sh tests/mactest/toolbox_68k.sh tests/mactest/toolbox_jiggle.sh
git commit -m "feat(ui): window-owned menu sets via `menus:`; bar synced on front change; WindowMenus case"
```

---

### Task 13: `lst.pop().field` on a handle-bearing record, native lane (spec §3.1)

**Files:**
- Modify: `clarusc/cg68k.cla` (`cgMaterializeToTemp` ~5891-5906 gate)
- Modify: `testsuite/toolbox/cases_leak.cla` (new shapes inside `caseLeakCheck`'s loop)
- Create: `testdata/cg68k/pop_rec.cla`; `tests/cg68k/pop_rec_release.sh`

- [ ] **Step 1: Gate.** In `cgMaterializeToTemp` change the tracked-temp condition to:
```
    if (irExprKind(e) == ECallFn and cgNeedsRelease(t)) or (irExprKind(e) == EIntr and irtKind(t) == KRec and cgNeedsRelease(t) and lowIntrIsOwningContainerRead(irIntrName(e))) {
        off = cgNewTrackedTmp(t)
```
and extend the comment: a popped/shifted handle-bearing RECORD consumed as a receiver or operand is materialized here (cgExprAddr's fallback) — `cgIntrListPopLike` deliberately leaves its KRec scratch untracked (see its comment), so this tracked temp becomes the record's one owner and the end-of-statement flush releases its fields; handle kinds are excluded because `cgIntrListPopLike` already tracks them at the producer (double-tracking would double-release). `lowIntrIsOwningContainerRead` lives in `lower.cla` and is visible here (both are compiler modules); confirm with the existing reference in `cg68k.cla`'s comments (~9971).

- [ ] **Step 2: Fixture + listing check.** `testdata/cg68k/pop_rec.cla`:
```
record PopRec {
    n: int
    t: text
}

func popMk(): PopRec {
    var r: PopRec

    r.n = 3
    r.t.append("abc")
    return r
}

on App.launch {
    var lst: list of PopRec
    var k: int

    lst.push(popMk())
    k = lst.pop().t.length
    lst.push(popMk())
    k = k + lst.pop().n + 1
    alert(string(k))
}
```
`tests/cg68k/pop_rec_release.sh`: emit68k `--listing` the fixture, locate the `App.launch` handler in `out.seg1.s` (its label comment), and count `JSR` lines to the `PopRec` release walk between that label and the next function label — expected exactly 2 (one per `pop()` consumption; pre-fix 0). Find the walk's label name by grepping the listing for `Release` and `PopRec` (`cgRecReleaseLbls` names carry the record name in listing mode — verify and adapt the grep). `t_pass`/`t_fail`/`t_done`. The `.s` golden itself is blessed by Task 15.

- [ ] **Step 3: LeakCheck arm.** In `cases_leak.cla`, add at module level `record TlkRec { n: int; t: text }` (or whatever field syntax the file's neighbours use) and `func tlkMkRec(): TlkRec` (n = 3, t = "abc"); inside the 1500-iteration loop add:
```
        // pop()/shift() of a handle-bearing RECORD in receiver and operand
        // position (compiler-cleanup follow-up, spec %3.1): native leaked
        // one text block per evaluation before the materialize gate fix.
        recs.push(tlkMkRec())
        n = n + recs.pop().t.length
        recs.push(tlkMkRec())
        n = n + recs.pop().n
        recs.push(tlkMkRec())
        n = n + recs.shift().t.length
```
with `var recs: list of TlkRec` declared. FreeMem stays exactly flat.

- [ ] **Step 4: Verify.** `make -j tools bootstrap`; `make test T=cg68k/pop_rec_release`; `scripts/test-task.sh --smoke`; `pgrep -x minivmac || CLARUS_MAC_TESTS=1 make -j1 test T=mactest/toolbox_68k` (`PASS LeakCheck` with the new arms; pre-fix it FAILS with FreeMem falling — run once on the pre-fix compiler to see the red, paste it in the report).

- [ ] **Step 5: Commit.**
```sh
git add clarusc/cg68k.cla testsuite/toolbox/cases_leak.cla testdata/cg68k/pop_rec.cla tests/cg68k/pop_rec_release.sh
git commit -m "cg68k: track a popped handle-bearing record materialized as receiver/operand; LeakCheck arms"
```

---

### Task 14: The three CRC tables as `const` arrays (spec §4.6) — after Task 7

**Files:**
- Modify: `runtime/clarus/text.cla` (~785 `rtTextCrc16`, ~827 `rtTextCrc16X`, ~876-907 `rtCrc32Tab`/`rtCrc32TabInit`, ~919 `rtTextCrc32`)

- [ ] **Step 1: Generate the tables** (throwaway; paste the script into the report):
```python
def refl16(poly):
    t=[]
    for i in range(256):
        c=i
        for _ in range(8): c=(c>>1)^poly if c&1 else c>>1
        t.append(c)
    return t
def fwd16(poly):
    t=[]
    for i in range(256):
        c=i<<8
        for _ in range(8): c=((c<<1)^poly)&0xFFFF if c&0x8000 else (c<<1)&0xFFFF
        t.append(c)
    return t
def refl32(poly):
    t=[]
    for i in range(256):
        c=i
        for _ in range(8): c=(c>>1)^poly if c&1 else c>>1
        t.append(c)
    return t
def emit(name, vals, w):
    print(f"const {name}: int[256] = [")
    for i in range(0,256,8):
        print("    " + ", ".join(f"0x{v:0{w}X}" for v in vals[i:i+8]) + ("," if i<248 else ""))
    print("]")
emit("rtCrc16KTab", refl16(0x8408), 4)
emit("rtCrc16XTab", fwd16(0x1021), 4)
emit("rtCrc32Tab", refl32(0xEDB88320), 8)
```
A 32-bit hex literal above `0x7FFFFFFF` lexes as a negative `int` (the existing `testdata/run/crc16.cla` already uses `0xCBF43926`), which is exactly the bit pattern the table needs. If the array-literal grammar rejects a trailing comma, the script emits none on the last row.

- [ ] **Step 2: Replace.** Delete `var rtCrc32Tab: ptr` and `rtCrc32TabInit`; paste the three `const` declarations above `rtTextCrc16`. Inner loops:
  - `rtTextCrc16`: `crc = (rtCrc16KTab[(crc ^ b) & 0xFF] ^ (crc >> 8)) & 0xFFFF` (drop the 8-step `j` loop).
  - `rtTextCrc16X`: `crc = (rtCrc16XTab[((crc >> 8) ^ b) & 0xFF] ^ ((crc << 8) & 0xFFFF)) & 0xFFFF`.
  - `rtTextCrc32`: `crc = rtCrc32Tab[(crc ^ b) & 0xFF] ^ ((crc >> 8) & 0x00FFFFFF)`; delete the `if rtCrc32Tab == ptr(0)` init.
  Update the three doc comments (table-driven; the `const` array lives in the constant pool, no heap block, no startup cost).

- [ ] **Step 3: Verify bit-exactness.** `scripts/clarus-run.sh testdata/run/crc16.cla` — output unchanged against `testdata/run/crc16.out`; `make test T=testsuite/core_cli` (`Crc16` case); `scripts/test-task.sh --smoke` (goldens: `text.cla` is spliced everywhere — every `.s` moves by the removed `ptr` global's A5 shift plus the pool; report); `make test T=bake/` (the pool class through `--rtbake`); `pgrep -x minivmac || CLARUS_MAC_TESTS=1 make -j1 test T=mactest/coresuite_68k` (`Crc16`). Optional but worth one line in the report: time `crc16` over 64 KB in the core CLI before/after.

- [ ] **Step 4: Commit.**
```sh
git add runtime/clarus/text.cla
git commit -m "runtime(text): CRC-16/KERMIT, CRC-16/XMODEM, CRC-32 tables as const arrays; retire the lazy heap block"
```

---

### Task 15: Wave-2 integration — bless #2, snapshot, docs, T2, Snow gate, final review (spec §7)

Runs after Tasks 7-14 are merged. Serial.

**Files:**
- Modify (bless/regen): `testdata/cg68k/*.s` (+ new `arrlit.s`, `karr_param.s`, `pop_rec.s`), `testdata/emitui/*.c.golden`, new `testdata/run/*.behavior` (arrlit, global_init_call, karr_abi, openrf), `clarusc/clarusc.c`, `clarusc/test/*.out` only if `selfhost/modules` reports movement
- Modify: `docs/TODO.md`, `docs/FUTURE.md` (no change expected), `docs/HISTORY.md`, `docs/ROADMAP.md`, `CLAUDE.md`, `STATUS.md`, `docs/superpowers/specs/2026-09-06-language-runtime-cleanup-design.md` (an "As-built notes" section, the compiler-cleanup spec's §8 shape)

- [ ] **Step 1: Bless #2.** `make test T=cg68k/goldens 2>&1 | tail -60`; confirm via `first_diff` on three fixtures that hunks are: `cg_init_globals` shrink (Task 10), `LEA`+push for array args (Task 9), the array-literal pool section and `text.cla`'s globals shift (7, 14), the jiggle wrappers are already blessed (wave 1). Then `CLARUS_CG68K_BLESS=1 make test T=cg68k/goldens`; delete any now-stale `*.segN.s` the script reports as unexpected (compiler-cleanup precedent: fixtures that shrank below a segment boundary). emitui: regenerate with the Task 6 loop (every golden moves: prototype block reorder from Task 8); `make test T=emitui/goldens`.

- [ ] **Step 2: Snapshot.**
```sh
cc -O1 -I runtime/host -o /tmp/boot clarusc/clarusc.c runtime/host/rt.c
/tmp/boot emit --rtdir runtime/clarus/ -o /tmp/cur.c clarusc/main.cla
cc -O1 -I runtime/host -o /tmp/cur /tmp/cur.c runtime/host/rt.c
/tmp/cur emit --rtdir runtime/clarus/ -o clarusc/clarusc.c clarusc/main.cla
make -j tools bootstrap
make test T=selfhost/fixedpoint
```
Expected `PASS snapshot_fresh`, `PASS fixed_point`. If not at fixed point after one regen (the new compiler compiles itself differently), run the recipe once more — two passes is the documented ceiling; a third means a nondeterminism bug.

- [ ] **Step 3: Behavior blobs.** `CLARUS_BLESS_BEHAVIOR=1 make test T=selfhost/behavior`; then `git status --short testdata/run | grep -v '^??'` must be EMPTY (only untracked new `.behavior` files; a modified existing blob is a regression — investigate). `make test T=selfhost/` green.

- [ ] **Step 4: Fence manifest + modules.** `make test T=reftest/` green (Task 7 renumbered the manifest; Tasks 9/11/12 added prose only). `make test T=selfhost/modules`; if a `clarusc/test/*.out` moved for a legitimate reason (a module driver prints an extern index?), `CLARUS_MODULES_BLESS=1` and say why.

- [ ] **Step 5: Size numbers.** `scripts/size-68k.sh` — paste the three `SIZE` lines next to Task 5's baseline in the report. Also the `.s` corpus line delta for HISTORY: `cat testdata/cg68k/*.s | wc -l` now, and the same count at the wave-1 bless commit (`git worktree add /tmp/lrc-w1 <Task 6 commit> && cat /tmp/lrc-w1/testdata/cg68k/*.s | wc -l; git worktree remove /tmp/lrc-w1`).

- [ ] **Step 6: T1 + full T2.** `scripts/test-task.sh --smoke`; then `scripts/test-merge.sh` — every stage prints `PASS`; paste each `test-merge.sh: <stage> PASS in Ns` line. `CLARUS_BAKE_FULL=1` is part of T2 (the full-corpus sweep must accept the new pool class and the wider window entry).

- [ ] **Step 7: Snow bake gate.** `pgrep Snow` first (a 68kbbs session may own it — wait, do not kill). `CLARUS_SNOW_TESTS=1 make test T=mactest/snow/clarusc_bake` (~55 min). Record the duration. This is the one run covering both `bake.cla` edits.

- [ ] **Step 8: Docs.** `docs/TODO.md`: delete the four sections this phase clears in full (Language features (needed), Compiler correctness / cleanup, ABI / performance, Runtime / Toolbox robustness) — every entry is closed except `rtUiTableClick`, whose note moves verbatim into `docs/ROADMAP.md`'s Standing rules as a third bullet. `docs/HISTORY.md`: a `## language-runtime-cleanup phase (2026-09-06, branch language-runtime-cleanup)` entry in the compiler-cleanup entry's shape — the 24 dispositions, the two bless points, the snapshot regen, the `.s` line delta, the size numbers, the Snow duration, and honest notes: which jiggle finds (if any) Task 2 uncovered, the handle-bearing-array by-value exception, the 31-menu cap. `docs/ROADMAP.md` "Where we are": one paragraph, "COMPLETE — full T2 green, Snow bake gate PASS, NOT YET merged (merge only on Andrew's request)"; the 68kBBS bullet gains array literals, `menus:`, `openRF`. `CLAUDE.md`: core suite count 81 -> 82 (`OpenRF`), toolbox 36 -> 38 (`CanvasIdle`, `WindowMenus`) in the growth-history sentences; the binary-files paragraph mentions `file.openRF`; the standing-rule list gains nothing new. Spec: append `## 10. As-built notes` recording every deviation the tasks reported. `STATUS.md`: the handoff.

- [ ] **Step 9: Commit.**
```sh
git add testdata/ clarusc/clarusc.c clarusc/test/ docs/ CLAUDE.md STATUS.md
git commit -m "chore: bless #2, snapshot regen, behavior blobs, docs for the language-runtime-cleanup phase"
```

- [ ] **Step 10: Final whole-branch review.** Dispatch the most capable available model with the spec, this plan, `git log main..language-runtime-cleanup`, and every task report; it probes (compile, run the fixtures, boot the toolbox suite once), not just reads. Fix findings in one consolidated fix wave; re-run T2 if any `clarusc/` or `runtime/` file changed, and the Snow gate again only if `bake.cla` changed. Merge only on Andrew's request.

---

## Parallelism summary

| Wave | Parallel (≤5 agents) | Serial after |
|------|----------------------|--------------|
| 1 | Tasks 1, 2, 3, 4, 5 — disjoint files except `ui.cla`/`uiwidgets.cla` (1 and 2 edit different functions; trivial merge). Emulator boots (1, 2, 4) serialize on `pgrep -x minivmac`. | Task 6 (oracle, bless #1, native gate) |
| 2 | Start Tasks 7, 8, 9, 10, 11 together (7 is the critical path). As each finishes, start 12 then 13. 14 starts only after 7 merges. Overlaps: 7/9/10/13 all edit `cg68k.cla` in different functions; 7/12 both edit `bake.cla` (different sections) and `check.cla`/`lower.cla`/`ir.cla` (different functions) and both bump `bkFormatVersion` (keep one bump); 8/9 both edit `cprint.cla` (different functions); 11/12 both edit `check.cla`. Expect small merges, no semantic conflicts. Suite-count literals: apply "+1 relative to the branch at merge time" (Global Constraints). | Task 15 (bless #2, snapshot, behavior blobs, T2, Snow gate, docs, final review) |

Critical path: Task 7 (array literals, nine files, a new pool class, a bake section, the reference and manifest) then Task 14, then Task 15's T2 (~15 min) plus the Snow gate (~55 min).
