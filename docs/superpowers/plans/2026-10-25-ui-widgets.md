# UI Widgets Batch (68kBBS) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship requirements R1-R9 of `../m68k-bbs/docs/clarus-ui-requirements.md`: widget geometry, fonts, label fixes, the `logpanel` and `divider` widgets, formatted and aligned table columns with live list tracking, menu checkmarks/submenus, canvas text measurement, literal menu captions, and Select All.

**Architecture:**
- **The compiler surface lands first, serially (Wave 1).** All new declaration syntax, the descriptor blob fields, every new member's lowering, and the runtime entry points (stub bodies) are defined in two tasks on the branch tip.
- **Runtime features then run as parallel tracks (Waves 2-3), in separate worktrees.** Each track fills in the stub bodies in the files it owns.
- **The synthesized pieces are a parallel compiler-only track.** These are the formatted-column dispatcher, the LogPanel gate dispatcher, and the element-store notify hook; they touch only compiler files.
- **Wave 4 integrates:** goldens, snapshot, docs, gates.

**Tech Stack:** Clarus (`clarusc/*.cla`, `runtime/clarus/*.cla`), C (`runtime/mac/rt_ext_mac.inc`, `runtime/mac/rt_ui.h`), POSIX sh tests, Mini vMac via LaunchAPPL, Snow (SE) for the final bake check.

**Spec:** `docs/superpowers/specs/2026-10-25-ui-widgets-design.md` (decisions D1-D6, calls C1-C14; section refs below are §N of the spec).

## Global Constraints

- **Branch and merging.**
  - Branch `ui-widgets` off `main` (`9121955a`).
  - Wave 2/3 tracks each get a worktree branched from the branch tip after the previous wave merges: `ui-widgets-<track>`.
  - The top-level session merges tracks into `ui-widgets`. Merging to `main` happens only when Andrew asks.
- **Model.** Implementers and reviewers run with `model: opus`.
- **Gates.**
  - Per task: `scripts/test-task.sh --smoke`, since every task touches `runtime/` or `clarusc/`.
  - Toolbox suite boot: `CLARUS_MAC_TESTS=1 make test T=mactest/toolbox_68k`.
  - Wave 4 runs `scripts/test-merge.sh` plus `CLARUS_SNOW_TESTS=1 make test T=mactest/snow/clarusc_bake` (SE).
- **Emulator boots across worktrees are serialized.** Wrap every `CLARUS_MAC_TESTS=1` make in `flock "$HOME/.cache/clarus-macboot.lock" …` (create `~/.cache` if missing).
  - Export `DISPLAY=:1 XAUTHORITY=/run/user/1000/gdm/Xauthority` first.
  - Never `pgrep`/`pkill` an emulator by name. Stop only pids you launched.
  - Never boot or write `macplus/`, `macplus2/` or `snow/` images directly.
- **grep.** Use `/usr/bin/grep -a` over `.cla` files (MacRoman bytes).
- **No new syntax inside `clarusc/*.cla`.** clarusc-current is built by the committed snapshot. Runtime `.cla` may use anything this branch adds (it is compiled by clarusc-current). `clarusc/clarusc.c` is regenerated once, in Task 12. Until then `selfhost/fixedpoint` is expected red; every other `selfhost/` script must pass.
- **Compile-only goldens** (`testdata/cg68k/*.s`, `testdata/emitui/*.c.golden`, `uiblob_probe.*`) move whenever runtime or blob changes.
  - A task reblesses them in its own last commit, `test: rebless goldens (<task>)`, after hand-inspecting one representative diff.
  - Commands:
    - `CLARUS_CG68K_BLESS=1 make test T=cg68k/goldens`
    - `for f in testdata/emitui/*.cla; do g=${f%.cla}.c.golden; [ -f "$g" ] && build-run/clarusc-current emit -o "$g" "$f"; done`
    - `make test T=emitui/` (must pass after).
  - On a merge conflict in any of these files, resolve by re-running the bless on the merged tree, never by hand-merging.
- **Frozen UI scenario goldens** (`testdata/ui/*.trace`, `testdata/uisnaps/*.pbm`) are reblessed only in Task 12 (`CLARUS_MAC_BLESS=1`).
  - Expected movers: the std-edit dim trace lines and the Edit menu (Select All), and label pixels (DrawText instead of TETextBox).
  - Any other change is a bug to explain.
- **Toolbox case count** goes from 41 to **53** (12 new cases, listed per task). It lives in five places: `testsuite/toolbox/runner.cla` `nTbCases`, `tests/mactest/toolbox_68k.sh`, `toolbox_jiggle.sh`, `toolbox_mac.sh` and `CLAUDE.md`.
  - Each task adds its cases and bumps the five places by its own count.
  - On merge, the count is the sum: 41 + cases merged so far.
  - New cases go in their own `testsuite/toolbox/cases_<name>.cla`, which also declares any test window the case needs, so `harness.cla` is not a shared edit.
  - Each new file is appended to `tests/mactest/toolbox_files.txt`.
- **New check errors** are `testdata/errors/<name>.cla` + `.expect` pairs (checked by `make test T=selfhost/diag`). Exact messages are pinned in Task 1/2.
- **Memory.**
  - Never raise `tests/memgate/budget.txt` or lower `tests/mactest/snow/se_floor.txt`.
  - If a peak drops, lower its budget in the same commit (standing rule).
  - Every task's report states the `memgate/peak` result.
- **Per-instance, not global.** New runtime state lives in per-instance or per-widget storage. Only these new A5 globals are allowed:
  - `rtListObsBlk: ptr` and `rtListObsCount: int` (Task 4);
  - at most one scratch pointer per new module, if a task can justify it in its report.
- **Commits.** Messages end with:
  ```
  Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
  ```

## Shared Interfaces (fixed by this plan; every task uses these names)

Constants, all in the files named:

| Name | Value | File |
|------|-------|------|
| `rtUiKindLogpanel` | 8 | `uiwidgets.cla` |
| `rtUiKindDivider` | 9 | `uiwidgets.cla` |
| `rtUiPropX` / `rtUiPropY` | 7 / 8 | `uiwidgets.cla`, mirrored in `cg68k.cla` prop table (~10037) and `runtime/mac/rt_ui.h` (~141) |
| `rtUiPropLineHeight` / `rtUiPropAscent` | 9 / 10 | same three places |
| `rtUiFaceBold` / `Italic` / `Underline` | 1 / 2 / 4 (QuickDraw `Style` bits) | `uiwidgets.cla` |
| `rtUiAlignLeft` / `Center` / `Right` | 0 / 1 / 2 | `uiwidgets.cla` |
| `rtUiLogDefaultMax` | 200 | `uilog.cla` |
| `rtUiLogOp*` | Make 0, Dispose 1, Draw 2, Click 3, Flush 4, Copy 5, SelectAll 6, HasSel 7, HasLines 8, Relayout 9, SetFont 10, Scroll 11 | `uilog.cla` |
| Std-edit item numbers | Undo 1, sep 2, Cut 3, Copy 4, Paste 5, Clear 6, Select All 7 | `ui.cla` |

**Blob v2** (writer `clarusc/uiblob.cla`, reader `runtime/clarus/uidesc.cla`; header version 1 → 2):

- **Widget entry**, stride 52 → 80. The existing 13 int32 are followed by 7 more:
  1. `height` (0 = kind default)
  2. `fontNameOff` (0 = none)
  3. `fontSize` (0 = none)
  4. `face` (style bits)
  5. `align`
  6. `maxLines` (logpanel; 0 = default)
  7. `divStyle` (0 single, 1 double)

  New `flags` bit: `rtUiFlagFontSet = 32`.
- **Column entry**, 4 → 7 int32. After `{headerOff, widthPx, widthFill, fieldIndex}` come `align`, `fmtId` (-1 = plain field), and `fmtLayoutOff`. `fmtLayoutOff` is the absolute offset of a one-field Layout descriptor for the formatter's result type, in the same format as the table's own Layout entries; 0 when `fmtId == -1`.
- **Menu item entry**, 4 → 6 int32. After the existing four come `itemFlags` (bit 0 = checked) and `submenuIdx` (-1 = none).
- `uidesc.cla` accessors, one per new field: `uidWidgetHeight`, `uidWidgetFontName`, `uidWidgetFontSize`, `uidWidgetFace`, `uidWidgetAlign`, `uidWidgetMaxLines`, `uidWidgetDivStyle`, `uidColAlign`, `uidColFmtId`, `uidColFmtLayout`, `uidItemFlags`, `uidItemSubmenu`. Each matches the existing accessor shape at `uidesc.cla:382-444`.

**Runtime entry points.** Lowering targets these. Task 2 creates each with a stub body in the file shown; the owning task replaces the stub. All widget functions take `(instV: ptr, wIdx: int, …)` like `rtUiCanvasDrawText`.

| Function | File | Owner |
|----------|------|-------|
| `rtUiWidgetSetBounds(instV, wIdx, x, y, w, h)` | `uiwidgets.cla` | T6 |
| `rtUiWidgetGetInt` gains X/Y/LineHeight/Ascent, all kinds | `uiwidgets.cla` | T6 (X/Y/W/H), T10 (LineHeight/Ascent) |
| `rtUiWinContentW(instV): int`, `rtUiWinContentH(instV): int` | `ui.cla` | T6 |
| `rtUiWidgetSetFont(instV, wIdx, name: ptr /*Str255*/, size: int)` | `uifont.cla` (new) | T10 |
| `rtUiWidgetSetStyle(instV, wIdx, face: int)` | `uifont.cla` | T10 |
| `rtUiCanvasTextWidth(instV, wIdx, s: ptr): int` | `uifont.cla` | T10 |
| `rtUiTableScrollTo(instV, wIdx, row: int)` | `uitable.cla` | T5 |
| `rtUiTableSetSel(instV, wIdx, row: int)` (Task 2 moves `rtUiWidgetSetInt`'s table `selected` branch into this function verbatim; T5 extends it to write `mark`) | `uitable.cla` | T5 |
| `rtUiLogAppend(instV, wIdx, s: ptr)`, `rtUiLogClear(instV, wIdx)`, `rtUiLogLineCount(instV, wIdx): int`, `rtUiLogLine(instV, wIdx, i: int, dst255: ptr)`, `rtUiLogScrollToEnd(instV, wIdx)` | `uilog.cla` (new) | T8 |
| `rtUiLogDo(op: int, instV: ptr, wIdx: int, a: int, b: int): int` (the op switch the dispatcher calls) | `uilog.cla` | T8 |
| `rtUiMenuSetChecked(menuIdx, itemIdx, b: bool)`, `rtUiMenuGetChecked(menuIdx, itemIdx): bool`, `rtUiMenuGetEnabled(menuIdx, itemIdx): bool` | `ui.cla` | T7 |
| `rtListObserve(box: ptr): int`, `rtListUnobserve(e: int)`, `rtListObsGen(e: int): int`, `rtListObsMark(e: int): int`, `rtListObsSetMark(e: int, i: int)`, `rtListNoteSet(box: ptr)` | `list.cla` | T4 |

**Synthesized dispatchers.** These are compiler-generated in the `lowSynthTableRows` shape (`lower.cla:7685`), on both lanes.

- `external func UiLogOp(op: int, instV: ptr, wIdx: int, a: int, b: int): int`
  - Declared in `uilog.cla`; called by `ui.cla` at its hook sites.
  - The synthesized body calls `rtUiLogDo(...)` when the program declares any `logpanel`, else returns 0. This makes the whole of `uilog.cla` unreachable (shaken) in programs without one (C4).
- `external func UiColFmt(fmtId: int, rec: ptr, out: ptr): bool`
  - Declared in `uitable.cla`.
  - The synthesized body switches on `fmtId`. It binds `rec` as the row record and calls the column's function, with field names lowered as fields of `rec`. It stores the result into `out`, typed per the column's result type.
  - It returns `false` when the call raised an abort (contained; C5), else `true`.
  - Programs with no formatted column get `return false`.
- **Element-store hook.** In a program that declares any `table`, after every inline list element store (`IListSet`/`IListSetRetain`) and every element-field store, the compiler emits `rtListNoteSet(box)`.

---

## Wave 1 (serial, on `ui-widgets`)

### Task 1: Declaration surface, blob v2, runtime kind stubs

**Files:**
- Modify: `clarusc/parse.cla`
  - `isWidgetKind` (~2146): add `logpanel`, `divider`.
  - `parseColumn` (~2327): `shows` takes `parseExpr()`, stored in DkColumn slot `c`. Keep `a` set to the field name when the expression is a bare identifier. Optional trailing `align IDENT`.
  - `parseMenuEntry` (~2386): optional `checked` and `submenu IDENT` after caption/key, as flag bits in `intVal` plus the submenu name.
- Modify: `clarusc/ast.cla`: column `c` slot accessor; menu-entry flag bits and submenu-name slot.
- Modify: `clarusc/check.cla`
  - `widgetDeclProps` (~953): `height` on all kinds; `width` on textview/canvas/table; `font`/`style` on label/field/textview/table/canvas/logpanel; `align` on label; `maxLines`/`scrollbar`/`fill`/`at`/`width`/`height` on logpanel; `style`/`at`/`width`/`height`/`fill` on divider.
  - `checkWidget` (~4102): validate values (messages below).
  - `checkColumn` (~4169): a call expression is checked in a scope declaring the row record's fields bare (model: `windowScope`, ~4398). The callee must be a top-level user func with a result type from the column-renderable set (`string`, `int`, `uint8`, `int16`, `uint16`, `fixed`, `bool`, `char`, enum).
  - `checkMenuDecl` (~4259): resolve `submenu` against menus declared above (C12). A submenu named in any window's `menus:`, or used by two items, is an error.
- Modify: `clarusc/lower.cla`
  - `lowWidgetDesc` (~6064-6255): new fields; drop the forced `widthIsFill` on tables (~6225) only when `width:` is declared; whitelist the new kinds (~6097).
  - `lowMenuDecl` (~6438): item flags and submenu index.
  - For now a formatted column lowers with `fmtId = -1` and `fmtLayoutOff = 0`, and draws its argument-free fallback (an empty cell). Task 3 assigns real ids.
- Modify: `clarusc/ir.cla`: `newIRWidgetDesc`, `newIRColumnDesc`, `IRMenuItemDesc` gain the fields.
- Modify: `clarusc/uiblob.cla`
  - Blob v2 as in Shared Interfaces: `uibEmitWidget`, stride 80, column and item entries, `uibWidgetKindNum` 8/9, version 2.
  - Fix C11: the `standard edit` branch (~1013) must emit the menu's other entries in declaration order.
- Modify: `runtime/clarus/uidesc.cla`: stride 80 (~311, ~383), the twelve new accessors, the header comment.
- Modify: `runtime/clarus/uiwidgets.cla`
  - Add the kind constants.
  - `rtUiKindHeight`/`rtUiKindWidth`: logpanel 100/200, divider 1/1.
  - `rtUiMakeWidgets`: logpanel calls `UiLogOp(rtUiLogOpMake, …)`; divider creates nothing. No `else`-arm quit for them.
- Modify: `runtime/mac/rt_ui.h`: kind/flag macros if the C lane has them.
- Create: `testdata/emitui/ui_batch_decl.cla` + `.c.golden`. It declares one of every new attribute, both new kinds, a formatted + aligned column, a `checked` item and a submenu.
- Create: error fixtures (below).

**Interfaces:**
- Produces: blob v2 and its `uid*` accessors; kinds 8/9; parsed `checked`/`submenu`/`shows <expr>`/`align`.
- Produces: `IRColumnDesc` field `fmtExpr` (the call AST, for Task 3) and `align`.

**Check-error messages** (exact; one fixture each, named in parentheses):

| Fixture | Source | Message |
|---------|--------|---------|
| `font_bad` | `label L { font: 9 }` | `font: expects a font name string and a size from 1 to 127` |
| `font_button` | `button B { font: "Geneva", 9 }` | `buttons, checks and popups use the system font` |
| `style_unknown` | `label L { style: heavy }` | `unknown style heavy (expected plain, bold, italic or underline)` |
| `style_plain_mix` | `label L { style: plain, bold }` | `plain cannot be combined with other styles` |
| `align_bad` | `label L { align: middle }` | `align: expects left, center or right` |
| `maxlines_bad` | `logpanel G { maxLines: 0 }` | `maxLines: expects an integer literal of at least 1` |
| `divider_style` | `divider D { style: bold }` | `divider style: expects single or double` |
| `column_expr` | `shows a + b` | `column shows expects a field name or a function call` |
| `column_fmt_type` | `shows f(name)` where f returns `text` | `column function must return a string, number, bool, char or enum` |
| `submenu_order` | submenu declared below its user | `undefined menu X` (reuse the existing undefined-name form if one exists; record which in the report) |
| `submenu_inbar` | submenu also in a window's `menus:` | `menu X is a submenu and cannot appear in menus:` |

- [ ] **Step 1: Write the eleven error fixtures and their `.expect` files.** Each `.expect` is the single diagnostic line in the existing format (`../../testdata/errors/<f>.cla:L:C: <message>`).
- [ ] **Step 2: Run `make test T=selfhost/diag`.** Expect FAIL on the eleven new fixtures, PASS on the rest.
- [ ] **Step 3: Write `ui_batch_decl.cla`, and extend `tests/emitui/uiblob.sh`'s probe** (or `uiblob_probe.cla`) to dump one widget with every new field set. Assert the dump shows `height`, `fontSize`, `face`, `align`, `maxLines`, `divStyle`, column `align`, item `itemFlags = 1` and `submenuIdx`.
- [ ] **Step 4: Implement the parser, AST, checker, lowering, IR, blob writer and reader, and the runtime kind stubs** above.
- [ ] **Step 5: Run `make test T=selfhost/diag T=emitui/`.** Expect PASS. Then run `make test T=reftest/`: no existing fence may change verdict.
- [ ] **Step 6: Check that a table declared with no `width:` emits `widthIsFill = 1` exactly as before.** Diff the blob dump of `testdata/emitui/popuptable.cla` before and after, ignoring the new trailing fields.
- [ ] **Step 7: Commit the feature, then the goldens rebless commit, and run `scripts/test-task.sh --smoke`.** Expect PASS, apart from `selfhost/fixedpoint` if it runs.

### Task 2: Member plumbing for every new property and method

**Files:**
- Modify: `clarusc/check.cla`
  - `widgetRuntimeProps` (~1004): `x`/`y`/`width`/`height` on all kinds; `lineCount` on logpanel; `lineHeight`/`ascent` on canvas.
  - `readOnlyPropName` (~4827): add TyWidget `x`/`y`/`width`/`height`/`lineCount`/`lineHeight`/`ascent` and TyWindowRef `contentWidth`/`contentHeight`.
  - `checkWindowRefSelect` (~4329) and `windowScope` (~4406): `contentWidth`/`contentHeight`.
  - Generalize the TyWidget method arm (~2455) to per-kind tables plus a common table:
    - common: `setBounds(int,int,int,int)`
    - label/field/textview/table/canvas/logpanel: `setFont(string,int)` and `setStyle(...)`
    - logpanel: `appendLine(string)`, `clear()`, `line(int): string`, `scrollToEnd()`
    - table: `scrollTo(int)`
    - canvas: `textWidth(string): int`
  - `setStyle` arguments: 1-3 bare identifiers from the style words, folded to a face int. `plain` must stand alone. A non-word argument gives `setStyle expects style words: plain, bold, italic, underline`.
  - Menu items: `.checked` read/write; `.enabled` read.
- Modify: `clarusc/lower.cla`
  - `lowWidgetPropGet` (~3058) and `lowWidgetSetAssign` (~4715).
  - `lowMethodCall` TyWidget arm (~1533) → new per-kind `lowLogpanelMethod`/`lowTableMethod`/`lowCommonWidgetMethod`, alongside `lowCanvasMethod`/`lowTextviewMethod` (~2041-2110).
  - `lowWindowInstSelect` (~3039).
  - Menu `.checked` assign/read and `.enabled` read, cloned from `lowMenuEnableAssign` (~4681).
  - Shake roots in `lowUiPortAddRoots` (~9094) for every new entry point **except** the `rtUiLog*` family. Those are rooted only when the program declares a logpanel (the dispatcher in Task 3 reaches the rest).
  - Synthesize stub dispatchers `UiLogOp` → `return 0` and `UiColFmt` → `return false` for every UI program, so the runtime externs always resolve. Task 3 replaces their bodies.
- Modify: `clarusc/ir.cla`: one `IUi*` intrinsic per new runtime entry point, named `IUiSetBounds`, `IUiGetX`, `IUiGetY`, `IUiContentW`, `IUiContentH`, `IUiSetFont`, `IUiSetStyle`, `IUiTextWidth`, `IUiGetLineHeight`, `IUiGetAscent`, `IUiTableScrollTo`, `IUiLogAppend`, `IUiLogClear`, `IUiLogLineCount`, `IUiLogLine`, `IUiLogScrollToEnd`, `IUiMenuSetChecked`, `IUiMenuGetChecked`, `IUiMenuGetEnabled`.
- Modify: `clarusc/cprint.cla` (~3979-4060) and `clarusc/cg68k.cla` (~10390-10470, `cgIntrUiForward` where the shape fits): one arm each.
- Modify: `runtime/clarus/uiwidgets.cla`, `ui.cla`, `uitable.cla`, `list.cla`: stub bodies for the Shared Interfaces functions owned by T4-T7. A stub does nothing and returns 0/false. `rtUiWidgetGetInt` X/Y return the rect's left/top for every kind now: real behavior, cheap.
- Create: `runtime/clarus/uilog.cla`. Header comment; `rtUiLogOp*` and `rtUiLogDefaultMax` constants; `external func UiLogOp(...)`; stub `rtUiLog*` and `rtUiLogDo` bodies.
- Create: `runtime/clarus/uifont.cla`. Header comment and stub `rtUiWidgetSetFont`/`rtUiWidgetSetStyle`/`rtUiCanvasTextWidth`.
- Modify: wire both new modules into every UI module list, after `uitable.cla` and before `uidialogs.cla`:
  - `clarusc/drive.cla` (~1341 early list and ~1687 needed list);
  - `clarusc/bake.cla` `bakeModuleList` (~494);
  - any test that counts the early-spliced modules ("13 early-spliced modules", `tests/bake/testapi_include_parity.sh` and kin). Update those counts and say so in the report.
- Modify: `runtime/clarus/ui.cla`: call `UiLogOp` at the hook sites, each guarded by `kind == rtUiKindLogpanel`:
  - teardown (~996): Dispose
  - `rtUiHandleUpdate` (~1772): Draw
  - `rtUiHandleContentClick` (~2385): Click, with `a = (v << 16) | (h & 0xFFFF)` and `b = modifiers`
  - the per-pass flush point (~2761): Flush
  - after `rtUiLayout` repositions it: Relayout
- Modify: `runtime/mac/rt_ext_mac.inc`: no new traps yet (they arrive with their owning tasks).
- Modify: `testdata/emitui/ui_batch_decl.cla` gains a handler that uses every new member; regenerate its golden.
- Create: error fixtures `readonly_x` (`w.L.x = 3` → `cannot assign to read-only property x`), `readonly_content` (`m.contentWidth = 1` → `cannot assign to read-only property contentWidth`) and `setstyle_bad` (`L.setStyle(3)` → the setStyle message above).

**Interfaces:**
- Consumes: Task 1's blob and kinds.
- Produces: every Shared Interfaces entry point exists with a stub; `UiLogOp`/`UiColFmt` resolve; both new modules are spliced.

- [ ] **Step 1: Write the three error fixtures. Extend `ui_batch_decl.cla` with an `on opened` that calls every member once**, including `m.contentWidth`, `w.Log.line(0)` and `Modem.S9600.checked = true`.
- [ ] **Step 2: Run `make test T=selfhost/diag T=emitui/`.** Expect FAIL (unknown members).
- [ ] **Step 3: Implement the checker, lowering, IR, both backends, stubs, module wiring and hook sites.**
- [ ] **Step 4: Verify the build and the shaking:**
  - `make test T=selfhost/diag T=emitui/ T=bake/ T=testsuite/` passes.
  - `build-run/clarusc-current emit68k --listing testdata/cg68k/bounce.cla` (or whichever UI fixture `tests/cg68k/goldens.sh` builds) contains no `rtUiLog` symbol.
  - `ui_batch_decl.cla`'s listing does contain `rtUiLogDo`.
- [ ] **Step 5: Commit, rebless, and run `scripts/test-task.sh --smoke`.**

---

## Wave 2 (parallel worktrees, branched after Task 2 merges)

| Track | Tasks | Files owned (only these) |
|-------|-------|--------------------------|
| A | 3 | `clarusc/lower.cla`, `ir.cla`, `cprint.cla`, `cg68k.cla` |
| B | 4 → 5 | `runtime/clarus/list.cla`, `uitable.cla`; `ui.cla` only `rtUiHandleUpdate`'s table-header arm; `rt_ext_mac.inc` (LScroll shim); `toolbox/` list catalog |
| C | 6 | `runtime/clarus/uiwidgets.cla` (layout, bounds, GetInt), `uitext.cla` (`rtUiTeRelayout` only), `ui.cla` (`rtUiApplyResize`, the loop's apply point, `rtUiHandleUpdate`'s divider arm, content-size getters), `uitable.cla` (`rtUiTableRelayout` only; tell Track B) |
| D | 7 | `runtime/clarus/ui.cla` menu functions (`rtUiBuildMenus`, `rtUiSyncMenuBar`, `rtUiMenuEnable`, `rtUiMenuRecomputeDim`, `rtUiStdEditDispatch`, `rtUiMenuDispatch`, `rtUiBuildAppleMenu`), `uitext.cla` (Select All helper only), `rt_ext_mac.inc` menu shims, `toolbox/` menu catalog |
| E | 8 | `runtime/clarus/uilog.cla`, `runtime/clarus/uitest.cla` (append-only) |

Each task's tests (its own toolbox `cases_*.cla`) need only that task's runtime plus Waves 1-2's merged compiler. A test that also needs Task 3's dispatchers (TableFormat, and the LogPanel cases' real dispatch) is written in Wave 2 but turned on after Track A merges: the case file is listed in `toolbox_files.txt` only once A is in. The integrating session merges A first.

### Task 3 (Track A): Synthesized dispatchers and element-store hook

**Files:** `clarusc/lower.cla` (next to `lowSynthTableRows`, ~7685), `clarusc/ir.cla`, `clarusc/cprint.cla`, `clarusc/cg68k.cla`.

**Interfaces:**
- Consumes: `IRColumnDesc.fmtExpr`, the `UiLogOp`/`UiColFmt` stubs, and `rtListNoteSet` (Task 2 stub).
- Produces:
  - real `UiLogOp` (calls `rtUiLogDo(op, instV, wIdx, a, b)` when any window declares a logpanel);
  - real `UiColFmt` (`fmtId` 0..n-1 in program-wide column declaration order, written into the blob's `fmtId`; `fmtLayoutOff` points at a one-field Layout entry for the result type);
  - `rtListNoteSet(box)` emitted after inline element stores in table-declaring programs.

- [ ] **Step 1: Write a host-free check: `tests/emitui/colfmt.sh`.** It emits `testdata/emitui/ui_batch_decl.cla` and asserts:
  - the C output contains a `clar_ui_fire_colfmt` (name per the existing `clar_ui_fire_*` scheme) with one arm per formatted column;
  - `UiLogOp`'s body references `rtUiLogDo`;
  - a `l[i] = v` on a list in that program is followed by a `rtListNoteSet` call;
  - the same statement in `testdata/emitui/win_basic.cla` (no table) is not.

  Also add `testdata/emitui/ui_colfmt_abort.cla`, whose formatter `abort`s, and assert its dispatcher contains the abort-containment frame (the same IR shape `attempt` lowers to; grep for the marker the cprint output uses).
- [ ] **Step 2: Run `make test T=emitui/colfmt`.** Expect FAIL.
- [ ] **Step 3: Implement.**
  - The formatter arm evaluates the column's call with field names lowered as `FieldRef`s on `rec` (a pointer to a copy of the row; Task 5 makes the copy). It stores the result into `out` with the type's normal store (string: Str255 copy).
  - It wraps the call in the abort-containment frame and returns `false` from the abort path.
  - Element-field stores (`l[i].f = x`) count as element stores.
- [ ] **Step 4: Run `make test T=emitui/ T=cg68k/ T=selfhost/diag T=bake/`.** Expect PASS after rebless.
- [ ] **Step 5: Commit, rebless, and run `scripts/test-task.sh --smoke`.**

### Task 4 (Track B): Observed-list registry

**Files:** `runtime/clarus/list.cla`.

**Interfaces:**
- Produces the registry functions (Shared Interfaces), with this behavior:
  - `rtListObserve(box)` returns an entry id ≥ 0. It allocates the registry block on first use (8 entries, growing by doubling; each entry holds `box: ptr, gen: int, mark: int, live: bool`). `mark` starts at -1.
  - `rtListUnobserve(e)` frees the slot. The block is freed when the count drops to 0.
  - Every mutating op starts with `if rtListObsCount != 0 { rtListObsNote(l, op, i) }`. The ops are add/push, pop, shift, unshift, remove, clear, release (`rtListDropStorage`), shrink and reserve.
  - `rtListObsNote` bumps `gen` on every entry whose `box == l` and adjusts `mark`:

    | Op | `mark` change |
    |----|---------------|
    | unshift | +1 |
    | shift | -1; mark 0 → -1 |
    | remove(i) | i == mark → -1; i < mark → mark - 1 |
    | pop | mark == old count - 1 → -1 |
    | clear, release | -1 |
    | add, push, reserve, shrink | unchanged |

  - `rtListNoteSet(box)` bumps `gen` only.
- Note: `list.cla` is shared by every program on every lane. It is not a UI module, so the registry must not reference any `rtUi*` symbol.

- [ ] **Step 1: Add toolbox suite case `ListObserve`** (+1, `testsuite/toolbox/cases_listobs.cla`). It lives in the toolbox suite because only the suites' `--testapi` GUI builds can name runtime functions (the core host CLI cannot). Confirm `list.cla` is in the early-visible set; if it is not, report it before going further. Assertions, on a `list of int` with 5 elements:
  - observe, set mark 2, `unshift` → mark 3 and `gen` changed;
  - `pop` → mark 3;
  - `shift` → mark 2;
  - `remove(0)` → mark 1;
  - `remove(1)` → mark -1;
  - a second observer on the same box sees the same `gen` changes;
  - after unobserving both, `rtListObsCount == 0`;
  - an unobserved list's ops leave every entry's `gen` unchanged.
- [ ] **Step 2: Boot.** `flock … CLARUS_MAC_TESTS=1 make test T=mactest/toolbox_68k`. Expect `ListObserve` FAIL.
- [ ] **Step 3: Implement.**
- [ ] **Step 4: Boot again, then run `make test T=memgate/ T=testsuite/core_cli`.** Expect PASS, and memgate within budget. Report the peak delta, which should be about 0.
- [ ] **Step 5: Commit, rebless, and run `scripts/test-task.sh --smoke`.**

### Task 5 (Track B): Table runtime

**Files:** `runtime/clarus/uitable.cla` (all of it except `rtUiTableRelayout`), `runtime/clarus/ui.cla` (`rtUiHandleUpdate`'s table-header arm only), `runtime/mac/rt_ext_mac.inc` (`LScroll` shim), `toolbox/` (the List Manager catalog file; create `toolbox/lists.cla` if none exists, with `LScroll` and the rest of the List Manager routines `uitable.cla` declares privately).

**Interfaces:**
- Consumes: Task 4's registry, Task 3's `UiColFmt`, and the blob accessors `uidColAlign`/`uidColFmtId`/`uidColFmtLayout`.
- Produces: `rtUiTableScrollTo`, selection following (D3) and the live refresh.

Behavior (§3.5, §4.5, §4.7):
- **Registration.** At table make: `rtListObserve(box)`. On every `rtUiTableSyncOne`, if the bound global's box differs from the observed one: unobserve, observe the new box, deselect.
- **Sync.** Redraw (InvalRect the rView) when `gen` changed or the count changed. Then fix the LM row count. Then select row `mark`, or deselect when -1.
- **Selection writes into `mark`.** User clicks write `mark` (`rtUiTableClick`), and so does assigning `selected`, through `rtUiTableSetSel` (Task 2 already routes the assignment there).
- **Formatted cells.**
  - Copy the row's element bytes into a per-table scratch block (allocated at make, `elemsize` bytes) before calling `UiColFmt(fmtId, scratch, outSlot)`.
  - Unlock the list handle across the call, then re-derive.
  - On `false`: draw nothing in that cell, and the first time per (window instance, column) `log("table column <header>: formatter aborted")`.
  - On `true`: draw `outSlot` through `rtUiTableDrawField` with the `fmtLayoutOff` descriptor.
- **Alignment.** Cells and headers are aligned with `TextWidth`: center = (colW - textW) / 2, right = colW - textW - 2, with the left inset 2 as today.
- **`rtUiTableScrollTo(row)`.** Clamp to 0..count-1, then `LScroll(0, row - topVisibleRow)`.
- **Teardown.** `rtListUnobserve`.

Test cases (+2 toolbox cases):

- [ ] **Step 1: Write `cases_tablebind.cla`** (`TableBinding`), with a window holding `table T { rows: tbRows; column "N" shows n width 60 }` over a `list of TbRow { n: int }` of 50 rows. Assertions:
  - Select row 3 (`w.T.selected = 3`), then `tbRows.unshift(...)` and `tbRows.pop()`, then `UiTestTick(1)` → `w.T.selected == 4` and the band checksum over row 0 changed.
  - `tbRows[10] = TbRow(999)` + tick → checksum over row 10's band changed.
  - `tbRows.remove(4)` → `selected == -1`.
  - `w.T.scrollTo(40)` + tick → the band over the first visible row shows row 40's checksum.
  - Assigning `selected` never fires `select` (counter stays 0).
- [ ] **Step 2: Write `cases_tablefmt.cla`** (`TableFormat`, enabled once Track A merges): a formatted column `shows fmtN(n) width 60 align right` and a second whose function aborts for `n == 7`. Assertions:
  - The right-aligned cell's leftmost 10 px band is blank while its rightmost band is not.
  - Row 7's aborting cell band is blank.
  - The other rows draw.
  - The log contains exactly one `formatter aborted` line (read through the suite's log capture; see `cases_events.cla` for how a case inspects logged lines, or count with a `on App.log` handler in the case's window).
- [ ] **Step 3: Boot.** `flock … CLARUS_MAC_TESTS=1 make test T=mactest/toolbox_68k`. Expect the two new cases FAIL.
- [ ] **Step 4: Implement.**
- [ ] **Step 5: Boot again.** Expect all 41 + 2 to PASS. Also run `examples/bookmarks.cla`'s frozen scenario (`make test T=mactest/ui_scenarios`). It must pass unchanged, or with an explained pixel-only change.
- [ ] **Step 6: Commit, rebless, and run `scripts/test-task.sh --smoke`.**

### Task 6 (Track C): Geometry, deferred bounds, content size, divider

**Files:** as in the track table.

**Interfaces:**
- Consumes: blob `height`/`divStyle`, `rtUiPropX`/`Y`.
- Produces:
  - `rtUiWidgetSetBounds` and `rtUiWinContentW`/`H`;
  - per-widget arrays in `RtUiWinst` for `codePlaced: bool` and `pending` rects (two `H`+ptr field pairs; see `ui.cla:822-850` for the allocation pattern; dispose in teardown);
  - `rtUiApplyPendingBounds(inst: ptr)`, called once per loop pass before the flush point and from the scripted pump (`uiscript.cla:1331`; Track C owns that one line).

Behavior (§3.1, §4.2):
- **`rtUiWidgetSetBounds`.** Clamp w/h to ≥ 0, store the pending rect, set `codePlaced`, and mark the window pending. Reads of x/y/width/height return the pending rect immediately.
- **`rtUiLayout` with code-placed widgets.** It skips code-placed widgets: they keep their current rect, and the `prev*` chain reads it.
- **Kind-default heights.** `height:` from the blob replaces `rtUiKindHeight` for canvas/textview/table/logpanel/label/divider. field/button/check/popup keep their natural height (C8). `width:` is honored on textview/canvas/table.
- **`rtUiApplyPendingBounds`.** For each pending widget:
  - `InvalRect(old)` and `InvalRect(new)`;
  - reposition without drawing: hide controls (`HideControl` → `MoveControl`/`SizeControl` → `ShowControl` inside a `ClipRect` of an empty rect, restoring the clip after), then call `rtUiTeRelayout`, `rtUiTableRelayout`, and the canvas realloc **only** if the size changed, and `UiLogOp(rtUiLogOpRelayout)` for logpanels;
  - clear pending. Nothing paints until the update event.
- **`rtUiApplyResize` order.** SizeWindow, `rtUiLayout` (skipping code-placed widgets), `InvalRect` of the whole port rect (replacing the per-widget partial invalidation), canvas realloc for widgets not code-placed, fire `resized`, then `rtUiApplyPendingBounds`.
- **`rtUiTeRelayout`.** Ignores the blob's fill flags for a code-placed textview.
- **`rtUiTableRelayout`.** Invalidates old ∪ new.
- **Divider.** Drawn in `rtUiHandleUpdate`: horizontal if w > h, else vertical. Single draws a line through the center; double draws two lines at offsets 0 and 2 across the thickness. Zero size draws nothing.
- **Zero-size widgets.** Take no clicks: the hit tests skip empty rects.

Test cases (+2):

- [ ] **Step 1: Write `cases_setbounds.cla`** (`SetBounds`). The window has a label, button, canvas, textview, table and divider.
  - In `on opened`, `setBounds` each widget, then read back x/y/width/height and assert equality, with button height kept natural (20).
  - `UiTestResize(400, 300)`: the code-placed widgets keep their rects, and a `width: fill` widget not code-placed tracks the new width.
  - Zero size: `w.C.setBounds(10, 10, 0, 0)` → width/height read 0, and a click there fires no `click`.
  - **One paint.** Checksum the whole content after the first update. `UiTestTick(1)` again must give the same checksum, and `UiTestCanvasBlits` for the canvas increases by at most 1 across a resize that re-`setBounds` everything in `resized`.
  - `m.contentWidth`/`contentHeight` equal the front window's portRect width and height after the resize (read with QuickDraw externs from the `toolbox/` catalog).
- [ ] **Step 2: Write `cases_divider.cla`** (`Divider`). A horizontal single (w 100, h 1), a horizontal double (w 100, h 3) and a vertical single (w 1, h 50).
  - Checksums of each rect are non-blank.
  - The double's middle row is blank and its outer rows are black (1-row band checksums).
  - A divider set to 0×0 leaves its old rect blank after the next update.
- [ ] **Step 3: Boot.** Expect FAIL.
- [ ] **Step 4: Implement.**
- [ ] **Step 5: Boot.** Expect PASS, plus `make test T=mactest/ui_scenarios` unchanged (bounce/mandel/texteditor/bookmarks do not use `setBounds`; a pixel change here is a bug).
- [ ] **Step 6: Commit, rebless, and run `scripts/test-task.sh --smoke`.**

### Task 7 (Track D): Menus: literal captions, checked, submenus, Select All

**Files:** as in the track table. New traps (native clause + `rt_ext_mac.inc` shim + `toolbox/` entry): `CheckItem` (0xA945), `SetItemMark` (0xA944), `SetItemCmd` (0xA84F). Add them to the existing Menu Manager catalog file if there is one, else create `toolbox/menus.cla` with every Menu Manager routine the runtime declares privately plus these. Verify each trap number against `toolchain/universal/CIncludes/Menus.h` (CR line endings) and record the check in the report.

**Interfaces:**
- Consumes: blob `uidItemFlags`/`uidItemSubmenu`.
- Produces: `rtUiMenuSetChecked`/`GetChecked`/`GetEnabled`, and std-edit item 7.
- Produces `rtUiFocusKind(inst): int`, returning the focused widget's kind or -1. Task 9 extends the dispatch through it.

Behavior (§3.7, §3.9, §3.10):
- **Literal captions.** Every declared item appends `"x"` (plus `/K` when keyed) and then gets `UiSetMenuItemText(mh, n, caption)`. This applies to the Apple menu's About item too when its text is user-supplied.
- **Checked items.** `CheckItem` at build for `itemFlags & 1`. `rtUiMenuSetChecked` → `CheckItem`. `rtUiMenuGetChecked` reads the mark (`GetItemMark` — add it too), and `rtUiMenuGetEnabled` reads the enable bit from the MenuInfo `enableFlags` (bit itemIdx+1).
- **Submenus.**
  - `InsertMenu(mh, -1)`.
  - The parent item gets `SetItemCmd(parent, n, 0x1B)` and `SetItemMark(parent, n, char(submenuId))`.
  - Submenus are excluded from bar insertion and from `rtUiClaimedMask`/`rtUiBarMask` and `rtUiSyncMenuBar`.
  - Selection dispatch arrives with the submenu's own ID in the high word, so the existing ID → menuIdx path handles it. Verify.
- **Standard edit.**
  - Append `Select All/A` as item 7.
  - In `rtUiMenuRecomputeDim`, items 3-6 are unchanged in rule (field/textview focus). Item 7 is enabled when the focus is a field/textview. Task 9 adds logpanel.
  - `rtUiStdEditDispatch`: item 7 → `TESetSelect(0, 32767, te)` (add the extern if absent, native trap 0xA9D1).
  - Update the std-edit dim trace for the 7th item.
  - Program-set `checked` is never touched by `RecomputeDim`.

Test case (+1):

- [ ] **Step 1: Write `cases_menuchecksub.cla`** (`MenuCheckSub`). It declares `menu TbSpeed { item S300 "300"; item S9600 "9600" checked }` and `menu TbModem { item Init "Init (Hayes); Reset/Q"; item Speed "Speed" submenu TbSpeed }`. Assertions:
  - `TbSpeed.S9600.checked == true` at start; set S300 true and S9600 false and read back.
  - `UiTestMenu` on the submenu's item fires its `select` handler (counter == 1).
  - The caption is literal: read the item text back with `GetMenuItemText` (add to the catalog) and compare to `"Init (Hayes); Reset/Q"`. The menu has exactly 2 items (no split on `;`), and `TbModem.Init.enabled` reads `true`.
  - In a textview holding `"hello"`, `UiTestMenu(edit, 7)` then Copy puts `"hello"` on the scrap (read with `GetScrap` from `toolbox/scrap.cla`).
- [ ] **Step 2: Boot.** Expect FAIL.
- [ ] **Step 3: Implement.**
- [ ] **Step 4: Boot.** Expect PASS, then run `make test T=mactest/ui_scenarios`. The trace goldens are expected to move only in std-edit dim lines and Edit menu shape: do not rebless (Task 12 does). Report the exact diff lines.
- [ ] **Step 5: Commit, rebless the compile-only goldens, and run `scripts/test-task.sh --smoke`.**

### Task 8 (Track E): LogPanel core

**Files:** `runtime/clarus/uilog.cla`; `runtime/clarus/uitest.cla` (append `UiTestLogTop(i: int): int`, the first visible line index of logpanel widget `i` in the front window, and `UiTestLogSel(i: int): int` returning `(selFirst << 16) | (selLast & 0xFFFF)`, or -1 when no selection); `runtime/mac/rt_ext_mac.inc` (`ScrollRect` shim if absent).

**Interfaces:**
- Consumes: the `UiLogOp` hook sites in `ui.cla` (Task 2) and the blob `maxLines`/font/scrollbar fields.
- Produces: the `rtUiLog*` functions, and `rtUiLogDo` implementing every op:
  - `HasSel`/`HasLines`/`Copy`/`SelectAll` are used by Task 9;
  - `Copy` builds the CR-joined selection and puts it on the scrap itself (`ZeroScrap` + `PutScrap('TEXT')`).

Behavior (§3.4):
- **State.** Per-widget state is one non-relocatable record per logpanel. Its pointer is kept in the existing per-widget `canvases`-style array, or a new per-widget `ptr` array allocated at Make. Fields: ring handle, offset table, head, count, maxLines, top line, follow flag, selection first/last/anchor, line height, ascent, widest, scroll bars, font/size/face, and dirty/new-line count.
- **Storage.** One handle holds the line bytes as a ring of `[len byte][bytes]`, plus a `maxLines`-entry int32 offset table. Appending past `maxLines` drops the head.
  - When the byte ring lacks room: grow by `SetHandleSize` (doubling, capped at `maxLines * 64` bytes initially and then as needed).
  - If that fails, drop oldest lines until the new line fits.
  - A single line longer than the whole ring forces growth or is truncated to what fits. Never panic.
- **Line splitting.** `appendLine` splits on CR, LF and CRLF. Empty lines are kept, and no empty line follows a trailing terminator.
- **Fonts.** At Make, and on SetFont: `GetFNum` (new extern, trap 0xA900; shim; `toolbox/fonts.cla` created with `GetFNum`, `GetFontName`, `RealFont`, `GetFontInfo`, `StringWidth`, `TextFont`/`TextSize`/`TextFace`; Task 10 consumes it). Fall back to `applFont` (1) when `GetFNum` yields 0 and the name is not the system font's. Line height = ascent + descent + leading.
- **Drawing.** Only visible lines, each `MoveTo` + `DrawText` clipped to the panel rect minus scrollbars. Selected lines are drawn then `InvertRect`ed.
- **Flush.** If dirty and following, with k new lines (k < visible lines): `ScrollRect` up by k × lineHeight, then draw only the k new lines. Otherwise invalidate the panel.
- **Follow and scrolling.**
  - While not following, dropped lines decrement `top` (clamped to 0).
  - The vertical scrollbar max = max(0, count − visible).
  - Scrolling to the max sets follow.
  - The horizontal bar (`scrollbar: both`) has range = widest − view width; the widest is kept as a running max and recomputed by scan only when the widest line drops off.
- **Selection.** Click selects the line under the point. Shift-click extends from the anchor. Drag (StillDown loop, autoscroll at the edges) extends. Dropped lines shift the selection indices down, and it clears when its last line drops.
- **`line(i)`.** Out of range → `rtPanic("logpanel line out of range")`.

Test cases (+2):

- [ ] **Step 1: Write `cases_logring.cla`** (`LogPanelRing`). The window holds `logpanel G { maxLines: 5; height: 60 }`. Assertions:
  - Append `"a"`..`"g"` → `lineCount == 5`, `line(0) == "c"` and `line(4) == "g"`.
  - `appendLine("x\ry\n\nz")` → the last four lines are `x`, `y`, `""`, `z`.
  - `appendLine("t\r")` adds exactly one line.
  - `clear()` → `lineCount == 0`.
  - 200 appends of a 3-byte line on a default-`maxLines` panel: FreeMem drops by less than 200 × 16 bytes (compact storage; the case's comment shows the arithmetic).
- [ ] **Step 2: Write `cases_logfollow.cla`** (`LogPanelFollow`). A panel with `maxLines: 50`, 4 visible lines. Assertions:
  - Append 10, tick → `UiTestLogTop == 6`.
  - Scroll up (click the up arrow twice via `UiTestClick` at the bar, or the `Scroll` op) → top 4; append 3 more and tick → top still 4 (+0, nothing dropped).
  - Append 40 more (drops 3) → top 1.
  - `scrollToEnd()` → following resumes; append 1 and tick → top == lineCount − 4.
  - `UiTestCanvasBlits`-style proof of no full repaint is optional. If skipped, say so in the report.
- [ ] **Step 3: Boot.** Expect FAIL. These cases need Task 3's real `UiLogOp`: once Track A merges into `ui-widgets`, merge `ui-widgets` into this worktree before booting. Until then, test with Track A's branch merged locally, without committing that merge.
- [ ] **Step 4: Implement.**
- [ ] **Step 5: Boot.** Expect PASS.
- [ ] **Step 6: Commit, rebless, and run `scripts/test-task.sh --smoke`.**

---

## Wave 3 (parallel worktrees, after Wave 2 merges)

| Track | Tasks | Files owned |
|-------|-------|-------------|
| F | 9 | `runtime/clarus/ui.cla`: `rtUiHandleKey`, `rtUiRun` sleep rule, `rtUiTeSetFocus` callers, content-click focus, `rtUiMenuRecomputeDim`/`rtUiStdEditDispatch` logpanel arms; `uitext.cla` `rtUiTeSetFocus` |
| G | 10 | `runtime/clarus/uifont.cla`; draw sites in `ui.cla` `rtUiHandleUpdate` (label, field label lane, table header); `uiwidgets.cla` (label set, canvas make/realloc/drawText, GetInt LineHeight/Ascent); `uitext.cla` (TE font); `uitable.cla` (LDEF font, row height) |
| H | 11 | `docs/` only |

### Task 9 (Track F): LogPanel focus, Copy and Select All

**Interfaces:** Consumes `rtUiFocusKind` (Task 7) and `UiLogOp` `HasSel`/`HasLines`/`Copy`/`SelectAll` (Task 8).

Behavior: §3.4 "Focus and Edit menu", §4.6.
- A content click on a logpanel sets `focusIdx` to it, deactivating any TE.
- Every TE use of `focusIdx` checks the focused kind first: `TEKey`, `TEIdle`, cut/copy/paste/clear, activate.
- The 1-tick sleep applies only to a TE focus.
- Std-edit enabling with a logpanel focus:

  | Item | Enabled when |
  |------|--------------|
  | Cut, Paste, Clear | never |
  | Copy | `HasSel` |
  | Select All | `HasLines` |

- Recompute the enable state on every selection change (the logpanel calls `rtUiMenuRecomputeDim` after a click: add an op-return convention, `Click` returns 1 when the selection changed).

Test case (+1):

- [ ] **Step 1: Write `cases_logselect.cla`** (`LogPanelSelect`). The window holds a textview and a logpanel with 10 lines. Assertions:
  - Click line 2, then shift-click line 4 → `UiTestLogSel == (2 << 16) | 4`.
  - Copy (`UiTestMenu(edit, 4)`) → the scrap holds `"l2\rl3\rl4"`.
  - Append 3 lines → the selection is unchanged.
  - On a `maxLines: 10` panel, append 3 more (drops 3) → selection `(0,1)`. Append 2 more → selection cleared, and Copy is disabled (read with a new `UiTestEditEnabled(item: int): bool` appended to `uitest.cla`, which reads the Edit menu's `enableFlags` bit).
  - Select All → `UiTestLogSel == (0 << 16) | 9`.
  - Cut, Paste and Clear are disabled while the panel is focused.
  - Typing a key with the panel focused changes neither panel nor textview.
  - The textview's Select All + Copy still works after focus moves back.
- [ ] **Step 2: Boot.** Expect FAIL.
- [ ] **Step 3: Implement.**
- [ ] **Step 4: Boot.** Expect PASS.
- [ ] **Step 5: Commit, rebless, and run `scripts/test-task.sh --smoke`.**

### Task 10 (Track G): Fonts, labels, canvas text measurement

**Interfaces:**
- Consumes: `toolbox/fonts.cla` (Task 8) and the blob font/face/align fields.
- Produces:
  - `rtUiWidgetSetFont`/`SetStyle`/`rtUiCanvasTextWidth`;
  - `rtUiFontApply(instV: ptr, wIdx: int)` and `rtUiFontRestore()`, used at every non-TE draw site;
  - `rtUiPropLineHeight`/`Ascent` in `rtUiWidgetGetInt`.

Behavior (§3.2, §3.3, §3.8):
- **Font storage.** Per-widget font/size/face arrays in `RtUiWinst` (allocated only if the window has any font-bearing widget; else nil and the defaults apply).
- **Declared fonts.** Resolved with `GetFNum` at window open. Unknown → `applFont` (1).
- **Draw sites.** Every non-TE site calls `rtUiFontApply` before drawing and `rtUiFontRestore` after.
- **TE widgets.** Set txFont/txFace/txSize, lineHeight and fontAscent in the TERec (offsets `uitext.cla:37-58`), then `TECalText`.
- **Table.** Font change → cellSize.v = new row height (`LCellSize`), header height = rowH + 4, relayout.
- **Canvas.**
  - Store the font in the canvas buffer record. The `RtUiCanvasBuf` stride grows 44 → 52 (`uidesc.cla:871-889`; update the stride and its doc).
  - Re-apply after every `rtUiCanvasMake`.
  - `drawText`, `textWidth` (`StringWidth`), `lineHeight` and `ascent` use it.
  - An unbuffered canvas applies and restores around each op.
- **Labels.**
  - `DrawText` replaces `TETextBox`, clipped to the rect.
  - Baseline = top + ascent, vertically centered when the rect is taller than one line: baseline = top + (h − lineHeight) / 2 + ascent.
  - Aligned per the blob.
  - Setting `text` to the identical Str255 returns before tracing and drawing. Otherwise: trace, copy, `InvalRect` (no immediate paint and no `ValidRect`). The label paints in the next update event. **Confirm** this does not break any existing frozen scenario's trace ordering; if it does, keep the immediate paint but erase only the label rect and drop the `ValidRect`, and say which you chose.
- **`setFont`/`setStyle`.** Invalidate the widget. On a logpanel, forward to `UiLogOp(rtUiLogOpSetFont, instV, wIdx, fontNum, (size << 8) | face)` instead (Task 8 handles that op).
- **Cleanup.** Remove the `docs/TODO.md` item "Language: canvas text font".

Test cases (+2):

- [ ] **Step 1: Write `cases_labelfont.cla`** (`LabelFontAlign`). Labels `A { text: "Hi"; width: 100; align: right }`, `B { text: "Hi"; font: "Monaco", 9; style: bold }` and `C { text: "a very long label that will not fit"; width: 60 }`. Assertions:
  - A's left 50 px band is blank and its right 30 px band is not.
  - B's checksum differs from an identical plain Geneva label's.
  - C draws one line only: the band below its first line height is blank, and its height is 16.
  - Same-text: record the trace line count, assign `A.text = "Hi"`, tick → the trace line count is unchanged (the suite's trace capture counter or `UiTestCanvasBlits`-style counter; add `UiTestTraceLines(): int` to `uitest.cla` if none exists).
  - `B.setStyle(plain)` changes B's checksum; `B.setFont("NoSuchFont", 12)` does not abort and B still draws.
- [ ] **Step 2: Write `cases_canvastext.cla`** (`CanvasText`). A buffered canvas `font: "Monaco", 9`. Assertions:
  - `textWidth("MMMM") == 4 * textWidth("M")` (Monaco is monospaced).
  - `lineHeight > ascent > 0`.
  - After `UiTestResize`, `textWidth("M")` is unchanged (font reapplied).
  - `setFont("Geneva", 12)` → `lineHeight` changes.
  - Rows drawn at `y = i * lineHeight + ascent` don't overlap: band checksums between rows are blank.
- [ ] **Step 3: Boot.** Expect FAIL.
- [ ] **Step 4: Implement.**
- [ ] **Step 5: Boot.** Expect PASS, then `make test T=mactest/ui_scenarios`. Label pixel changes in the frozen scenarios are expected. Report them and do not rebless (Task 12 does).
- [ ] **Step 6: Commit, rebless the compile-only goldens, and run `scripts/test-task.sh --smoke`.**

### Task 11 (Track H): Reference, changelog, TODO

**Files:** `docs/clarus-language-reference.md`, `docs/clarus-language-changelog.md`, `docs/TODO.md`, and `docs/clarus-toolbox-cookbook.md` (a line for each new catalog file).

Content per spec §6. In addition:
- The changelog gets a `## 1.2` section with one entry per R item plus the two visible changes (Select All, literal captions).
- The reference gets a Mac note on C5 (formatter aborts vs runtime errors) and C8 (natural heights).
- `tests/reftest/manifest.txt`: add the fence indices of new examples that must check clean, and run `make test T=reftest/`. A fence using new members can only check clean once Waves 1-2 are merged, which they are by now.
- `docs/TODO.md`: add the popup menu-ID collision item and the `RecomputeDim` `.enabled` overwrite item (spec §6).

- [ ] **Step 1: Write the docs.**
- [ ] **Step 2: Run `make test T=reftest/`.** Expect PASS.
- [ ] **Step 3: Commit.**

---

## Wave 4 (serial, on `ui-widgets`)

### Task 12: Integration, acceptance, snapshot, gates

**Files:**
- `clarusc/drive.cla`: `claruscVersion` → `1.2`.
- `clarusc/macgui.cla`: `version:` literal → `1.2`.
- `clarusc/clarusc.c`: regenerated with the recipe printed by `tests/selfhost/fixedpoint.sh`'s `snapshot_fresh` failure.
- Frozen goldens: `testdata/ui/*.trace`, `testdata/uisnaps/*.pbm`.
- New `testsuite/toolbox/cases_bbslayout.cla` (+1 case: `BbsLayout`).
- `docs/ROADMAP.md`, `docs/HISTORY.md` (phase entry), and `CLAUDE.md` (toolbox case count 53 with the per-case history sentence, the new `uilog.cla`/`uifont.cla` modules in the UI module notes).

- [ ] **Step 1: Write `BbsLayout`.**
  - It reproduces the requirements' target window: three label pairs, two dividers, `Callers` table (four columns, two formatted, `Time` right-aligned, `font: "Geneva", 9`) over 50 records, and a `logpanel Log { maxLines: 100; font: "Monaco", 9; scrollbar: both }`.
  - It is laid out by R1.5's `layoutMain` from `opened` and `resized`.
  - The `Modem` menu has `Speed` and `Port` submenus with checkmarks.
  - Assertions:
    - after open: every widget's bounds equal `layoutMain`'s arithmetic;
    - after `UiTestResize(500, 320)`: the same bounds again;
    - 20 appends plus `unshift`/`pop` at count 50 within one handler cost one update (checksum stable on a second tick);
    - `Log.line(0)` reads back.
- [ ] **Step 2: Bump the version and regenerate the snapshot.** Then run `make test T=selfhost/ T=claruscboot/`. Expect PASS.
- [ ] **Step 3: Rebless the frozen goldens.** `CLARUS_MAC_BLESS=1 make -j1 test T=mactest/smoke_bounce T=mactest/ui_scenarios`. Inspect every changed trace line (only std-edit and label-related changes are allowed) and view each changed PBM. Commit with the list of changes in the message.
- [ ] **Step 4: Rebless the compile-only goldens on the merged tree.** Then run `scripts/test-merge.sh` and expect every stage PASS.
- [ ] **Step 5: Run the SE bake check.** `CLARUS_SNOW_TESTS=1 make test T=mactest/snow/clarusc_bake` and `T=mactest/snow/clarusc_memprobe`. Expect PASS. The SE floor holds.
- [ ] **Step 6: Report.** Give code size of `bookmarks` and ClarusC.APPL before and after (spec §4.9), and the memgate peaks.
- [ ] **Step 7: Update ROADMAP, HISTORY and CLAUDE.md, then commit.** Then ask Andrew about merging.

---

## Review Focus

1. **A `resized` handler that calls `setBounds` on a widget that is also `width: fill`.** It must stay where code put it on every later resize, and no auto-placed widget after it may jump. The Task 6 `SetBounds` case includes a fill widget that is code-placed in `resized`: assert its rect after two consecutive resizes.
2. **A formatted column whose function allocates** (builds a string with `+`) while the list is large enough that the row block is near a heap boundary. Neither the cell nor the next row may read garbage. Task 5's `TableFormat` formatter must concatenate strings, and the case runs it over 50 rows after a `release()` + refill, to force relocation.
3. **`appendLine` called from a timer while the user drags a selection in the same panel.** The drag loop must not see a ring that moved under it. Task 9's case appends from a scripted `tick` between the press and the shift-click, and asserts the selection matches the same text, not the same indices.
4. **A window with two tables bound to the same list.** Each keeps its own highlight, per the spec (§4.5), and closing one window must not unobserve the other's entry. Task 5's `TableBinding` adds a second window on `tbRows`, closes it, then repeats the `unshift` assertion on the first.
5. **Menu captions with every metacharacter** (`( / ^ ! < ;`) and an item with both a caption and a `key`. The key still works and nothing else is parsed. Task 7's case adds `item Meta "a(b/c^d!e<f;g" key "M"` and asserts its text reads back exactly and Cmd-M fires its `select`.
