# Textview `scrollToEnd()` Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `Widget.scrollToEnd()`, a `textview`-only widget method that scrolls the view to its last line, on both the native (`emit68k`) and Retro68/cprint lanes.

**Architecture:** One new runtime function `rtUiWidgetScrollToEnd(instV, wIdx)` in the Mac-only Clarus UI runtime, reached through one new intrinsic (`ui_scroll_to_end`) wired along the exact path the existing `canvas` widget methods already take: `check.cla` method table → `lower.cla` widget-method lowering → `cg68k.cla`/`cprint.cla` one-arm forwarders. A new `UiTestTextviewScroll(i)` probe in `uitest.cla` lets the toolbox suite hardware-prove it.

**Tech Stack:** Clarus (clarusc is self-hosted — `clarusc/*.cla`; runtime is `runtime/clarus/*.cla`), Go test harness (`internal/…`), Retro68 + Mini vMac for the hardware gate.

**Spec:** `docs/superpowers/specs/2026-08-29-textview-scroll-to-end-design.md`

## Global Constraints

- Branch `textview-scroll-to-end` (already created off `main` at `36b76ab`); main stays green; merge only on request.
- Method is `textview`-only; any other widget kind → check error `undefined: scrollToEnd`; wrong arity → the shared `wrong number of arguments` diagnostic.
- Programmatic: never fires `change`. Horizontal offset untouched. Fits ⇒ no-op.
- Mac-only runtime; `runtime/host` is untouched (no UI runtime there).
- Toolbox call discipline: re-derive a TE master pointer (`UiHandleDeref`) after any Toolbox call that can move memory; every existing function in `uitext.cla`/`uiwidgets.cla` shows the pattern.
- `.cla` files are MacRoman-safe ASCII here — keep new files pure ASCII; do NOT introduce non-ASCII bytes into `.cla` files (the Edit tool corrupts MacRoman bytes; nothing in this plan needs any).
- The reference (`docs/clarus-language-reference.md`) must not gain a new ```` ``` ```` code fence: `internal/reftest/manifest.go` indexes fences by position, so a new fence breaks `TestCheckCleanFences`. Use inline backticks for the example.
- Every commit message ends with:
  ```
  Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>
  Claude-Session: https://claude.ai/code/session_01EpxS9ov2exdgTGF5fB3iK9
  ```
- Gates: `scripts/test-task.sh --smoke` (T1 + the two emulator smoke boots; needed because runtime/ and clarusc/ change) after every task; `scripts/test-merge.sh` (T2) once at the end of Task 4.
- Scratch files go under `build-run/` (gitignored), not `/tmp`.

**Building the current-source compiler by hand** (what the Go tests do internally via `internal/claruscboot`), when a step says "build clarusc from source":

```sh
cc -O1 -I runtime/host -o build-run/boot clarusc/clarusc.c runtime/host/rt.c
build-run/boot emit --rtdir runtime/clarus/ -o build-run/cur.c clarusc/main.cla
cc -O1 -I runtime/host -o build-run/clarusc build-run/cur.c runtime/host/rt.c
```

`build-run/clarusc` is then the compiler built from the CURRENT `clarusc/*.cla` sources.

---

### Task 1: Runtime — `rtUiWidgetScrollToEnd` + the `UiTestTextviewScroll` probe

**Files:**
- Modify: `runtime/clarus/uiwidgets.cla` (insert directly after `rtUiWidgetSetText`, which ends at the `UiSetPort(savedPort)` / `}` just before `func rtUiWidgetSetBool`, ~line 994)
- Modify: `runtime/clarus/uitest.cla` (append after `UiTestPopupBoxRight`, end of file)

**Interfaces:**
- Consumes (all existing): `RtUiWinst(inst)`, `rtUiTeAt(w, i): ptr`, `rtUiCtrlAt(w, i): ptr`, `uidWidgetKind(winIdx, wIdx)`, `rtUiKindTextview` (=5), `rtUiGetPortSaved(): ptr`, `UiSetPort`, `UiHandleDeref`, `rtUiTeScrollSync(inst, wIdx)`, `UiTEScroll(dh, dv, te)`, `UiSetControlValue(ctrl, v)`, TE record offsets `rtUiTeDestRect` (0), `rtUiTeViewRect` (8), `rtUiTeLineHeight` (24), `rtUiTeNLines` (94) (`uitext.cla:49-57`), `rtUiWinstOf(wp): ptr` (`ui.cla:599`), `UiFrontWindow(): ptr` (`ui.cla:227`).
- Produces: `func rtUiWidgetScrollToEnd(instV: ptr, wIdx: int)` (Task 2's backends call it by this exact name) and `func UiTestTextviewScroll(i: int): int` (Task 3's case calls it; returns `viewRect.top - destRect.top` of widget `i` in the front window, `-1` if that widget has no TE).

- [ ] **Step 1: Add `rtUiWidgetScrollToEnd` to `uiwidgets.cla`**

Insert after `rtUiWidgetSetText`'s closing `}` (before `func rtUiWidgetSetBool`):

```
// rtUiWidgetScrollToEnd (textview-scroll-to-end phase): `Widget.
// scrollToEnd()` for a TEXTVIEW -- scrolls the view so its last line is
// visible and pins the vertical scrollbar (if any) to the same offset.
// Horizontal offset untouched; a no-op when the content already fits
// (maxScroll == 0) or the view is already at the end; a programmatic
// action, so no trace/`change` event, same as rtUiWidgetSetText. Runs
// rtUiTeScrollSync first so the control's maximum and the TE's own
// offset are consistent before the end offset is computed from the same
// viewRect/destRect/nLines/lineHeight fields the sync reads. TEScroll
// redraws the view itself (the thumb handlers in uitext.cla rely on the
// same), so no TEUpdate/InvalRect is needed here.
func rtUiWidgetScrollToEnd(instV: ptr, wIdx: int) {
    var w: RtUiWinst
    var te: ptr
    var teMp: ptr
    var sb: ptr
    var savedPort: ptr
    var viewH: int
    var contentH: int
    var maxScroll: int
    var offset: int

    w = RtUiWinst(instV)
    te = rtUiTeAt(w, wIdx)
    if uidWidgetKind(w.winIdx, wIdx) != rtUiKindTextview or te == ptr(0) {
        return
    }
    savedPort = rtUiGetPortSaved()
    UiSetPort(w.wp)
    rtUiTeScrollSync(instV, wIdx)
    teMp = UiHandleDeref(te) // AFTER the sync -- its Toolbox calls can move memory
    viewH = peekw(teMp + rtUiTeViewRect + 4) - peekw(teMp + rtUiTeViewRect + 0)
    contentH = peekw(teMp + rtUiTeNLines) * peekw(teMp + rtUiTeLineHeight)
    maxScroll = contentH - viewH
    if maxScroll < 0 {
        maxScroll = 0
    }
    offset = peekw(teMp + rtUiTeViewRect + 0) - peekw(teMp + rtUiTeDestRect + 0)
    if offset < maxScroll {
        UiTEScroll(0, offset - maxScroll, te) // negative dv: content moves up
        sb = rtUiCtrlAt(w, wIdx)
        if sb != ptr(0) {
            UiSetControlValue(sb, maxScroll)
        }
    }
    UiSetPort(savedPort)
}
```

- [ ] **Step 2: Add `UiTestTextviewScroll` to `uitest.cla`**

Append at end of file:

```
// UiTestTextviewScroll (textview-scroll-to-end phase): the FRONT window's
// widget i's current vertical scroll offset -- viewRect.top - destRect.top
// of its TE record, the same quantity rtUiTeScrollSync (uitext.cla) pins
// the scrollbar to -- or -1 when widget i has no TE (not a field/
// textview). Internal-only bridge for testsuite/toolbox's ScrollToEnd
// case, same rtUiWinstOf(UiFrontWindow()) lookup UiTestPopupBoxLeft
// above uses; Ch8 exposes no scroll position at the user-facing level.
func UiTestTextviewScroll(i: int): int {
    var te: ptr
    var teMp: ptr

    te = rtUiTeAt(RtUiWinst(rtUiWinstOf(UiFrontWindow())), i)
    if te == ptr(0) {
        return -1
    }
    teMp = UiHandleDeref(te)
    return peekw(teMp + rtUiTeViewRect + 0) - peekw(teMp + rtUiTeDestRect + 0)
}
```

- [ ] **Step 3: Check the runtime still compiles on both lanes**

Run: `scripts/test-task.sh --smoke`
Expected: all PASS (the runtime is spliced into every UI build the smoke boots make; a typo here fails `TestSmokeBounceOn68k` or the emitui compile step). Nothing exercises the new function yet — Task 3 does.

- [ ] **Step 4: Commit**

```bash
git add runtime/clarus/uiwidgets.cla runtime/clarus/uitest.cla
git commit -m "feat(runtime): rtUiWidgetScrollToEnd + UiTestTextviewScroll probe"
```

---

### Task 2: Compiler — `Widget.scrollToEnd()` end to end (check, IR, lower, both backends) + fixtures + snapshot

**Files:**
- Modify: `clarusc/check.cla` — map decl beside `var canvasMethods: map of int` (~`:571`); registration inside `buildMethodTables()` beside `canvasMethods["clear"]` (~`:1802`); `checkMethodCall`'s `case TyWidget` (~`:2215`)
- Modify: `clarusc/ir.cla` — beside `IUiSetTextviewText` (~`:4682`)
- Modify: `clarusc/lower.cla` — `lowMethodCall`'s `TyWidget` arm (~`:1336`); new `lowTextviewMethod` right after `lowCanvasMethod` (~`:1672`)
- Modify: `clarusc/cg68k.cla` — `var rnUiWidgetSetText: int` (~`:358`) / `rnInit()` (~`:508`) / `cgIntrUi`'s `IUiCanvasClear` arm (~`:9185`)
- Modify: `clarusc/cprint.cla` — `fpIntrCall12`'s `IUiCanvasClear` arm (~`:3864`)
- Modify: `testdata/emitui/textwidgets.cla` + regenerate `testdata/emitui/textwidgets.c.golden`
- Create: `testdata/errors/scrollend_kind.cla`, `.expect`; `testdata/errors/scrollend_arity.cla`, `.expect`
- Regenerate: `clarusc/clarusc.c`

**Interfaces:**
- Consumes: Task 1's `rtUiWidgetScrollToEnd(instV: ptr, wIdx: int)`.
- Produces: intrinsic name `IUiScrollToEnd()` = `intern("ui_scroll_to_end")`; args `(instIR, widgetIdx)`, result `irVoidT`.

- [ ] **Step 1: Write the failing positive fixture**

Edit `testdata/emitui/textwidgets.cla`: extend `TextWin`'s `on Body.change` handler and add a bare-shape use. Replace the `extend TextWin { … }` block's `on Body.change` with:

```
    on Body.change {
        bodyText = Body.text
        Body.text = bodyText
        Body.text = "from literal"
        Body.scrollToEnd()
    }
```

and replace `on App.launch` with:

```
on App.launch {
    var w: TextWin
    w = open TextWin
    w.Body.scrollToEnd()
    open NoteWin
}
```

Append to the fixture's header comment (after the NoteWin paragraph):

```
//
// `Body.scrollToEnd()` (bare, in-handler) and `w.Body.scrollToEnd()`
// (explicit instance) are the textview-scroll-to-end phase's fixture for
// the textview's one method: lower.cla's lowTextviewMethod -> the
// ui_scroll_to_end intrinsic -> clar_fn_rtUiWidgetScrollToEnd(inst, 1)
// (Body is TextWin's widget index 1).
```

- [ ] **Step 2: Run it to see it fail**

Run: `go test -count=1 ./internal/emitui -run TestEmitUiGoldens/textwidgets -v 2>&1 | tail -20`
Expected: FAIL — clarusc reports `undefined: scrollToEnd` (the checker's non-canvas `TyWidget` arm).

- [ ] **Step 3: check.cla — the `textviewMethods` table**

Beside `var canvasMethods: map of int` add:

```
var textviewMethods: map of int
```

In `buildMethodTables()`, directly after the `canvasMethods["clear"] = sigEnd(-1)` registration block, add:

```
    // textview (Ch8: Widgets) -- textview-scroll-to-end phase: the
    // textview's one method, zero-arg, statement form.
    sigStart()
    textviewMethods["scrollToEnd"] = sigEnd(-1)
```

In `checkMethodCall`'s `case TyWidget`, change the body to:

```
    case TyWidget {
        // canvas (Ch11: Drawing) and textview (Ch8: scrollToEnd) are the
        // only widget kinds with methods; every other kind -- and
        // window-ref/menu-item values -- has none, so it falls through
        // to the "undefined" default below.
        if poolGet(typeNameIdx(xt)) == "canvas" {
            return checkTableMethod(canvasMethods, sel, argsHead)
        }
        if poolGet(typeNameIdx(xt)) == "textview" {
            return checkTableMethod(textviewMethods, sel, argsHead)
        }
        emitDiag(exprLine(sel), exprCol(sel), "undefined: " + name)
        return InvalidT
    }
```

- [ ] **Step 4: ir.cla — the intrinsic name**

Directly after the `IUiSetTextviewText()` function add:

```
// IUiScrollToEnd (textview-scroll-to-end phase): `textview.scrollToEnd()`
// -> rtUiWidgetScrollToEnd(inst, widgetIdx); void.
var iUiScrollToEndIdx: int = -1

func IUiScrollToEnd(): int {
    if iUiScrollToEndIdx == -1 {
        iUiScrollToEndIdx = intern("ui_scroll_to_end")
    }
    return iUiScrollToEndIdx
}
```

- [ ] **Step 5: lower.cla — dispatch + `lowTextviewMethod`**

In `lowMethodCall`, change the `TyWidget` arm to dispatch on the method NAME (the checker already guaranteed kind/name agree, and resolving the kind here would lower the receiver twice):

```
    if xk == TyWidget {
        // Widget methods: selectX(fn) is itself a widget-select
        // (`w.Board`), never lowered as a standalone value -- each lowerer
        // peels both levels itself, same as lowWidgetPropGet does for a
        // property read, so recv is never computed generically here.
        // Dispatch on the method name: the checker only admits
        // scrollToEnd on a textview and the drawing set on a canvas.
        if poolGet(selectName(fn)) == "scrollToEnd" {
            return lowTextviewMethod(e, fn, ty)
        }
        return lowCanvasMethod(e, fn, ty)
    }
```

Directly after `lowCanvasMethod`'s closing `}` add:

```
// lowTextviewMethod lowers `w.Body.scrollToEnd()` (Ch8: the textview's
// one method, textview-scroll-to-end phase): receiver peeled exactly like
// lowCanvasMethod, arg list = (instance, widget index), void result --
// lowWidgetSetAssign's shape minus the value argument.
func lowTextviewMethod(e: int, fn: int, ty: int): int {
    var recv: LowWidgetRecv
    var widgetIdx: int
    var head: int
    var nm: string

    recv = lowWidgetRecv(selectX(fn))
    widgetIdx = uiWidgetIndex(recv.winNameIdx, recv.wgName)
    nm = poolGet(selectName(fn))
    if nm != "scrollToEnd" {
        lowUnsupported("textview method " + nm)
        return -1
    }
    head = recv.instIR
    irExprListAppend(head, newIRIntConst(widgetIdx, irIntT))
    return newIRIntr(IUiScrollToEnd(), head, ty)
}
```

(`ty` is the call's own type from `lowMustType(e)` — void for a statement call, the same value `lowCanvasMethod` returns through for `clear()`.)

- [ ] **Step 6: cg68k.cla — name + forwarder arm**

Beside `var rnUiWidgetSetText: int` add `var rnUiWidgetScrollToEnd: int`. In `rnInit()` beside `rnUiWidgetSetText = intern("rtUiWidgetSetText")` add `rnUiWidgetScrollToEnd = intern("rtUiWidgetScrollToEnd")`. In `cgIntrUi`, directly before the `if nm == IUiCanvasClear() {` arm add:

```
    if nm == IUiScrollToEnd() {
        cgIntrUiForward(e, rnUiWidgetScrollToEnd)
        return
    }
```

- [ ] **Step 7: cprint.cla — printer arm**

In `fpIntrCall12`, directly before `if nm == IUiCanvasClear() {` add:

```
    if nm == IUiScrollToEnd() {
        fpEmit("clar_fn_rtUiWidgetScrollToEnd(" + fpExpr(a0) + ", " + fpExpr(a1) + ");")
        return toText("")
    } else
```

so the chain reads `if nm == IUiScrollToEnd() { … } else if nm == IUiCanvasClear() { …`. (Update `fpIntrCall12`'s doc comment: "`IUiScrollToEnd` (textview-scroll-to-end phase) leads the chain".)

- [ ] **Step 8: Regenerate the emitui golden and verify**

Build clarusc from source (Global Constraints recipe), then:

```sh
build-run/clarusc emit -o testdata/emitui/textwidgets.c.golden testdata/emitui/textwidgets.cla   # from the repo root, no --rtdir: exactly the flags internal/emitui uses (findRtDir's upward search resolves runtime/clarus/)
git diff --stat testdata/emitui/textwidgets.c.golden
grep -n "clar_fn_rtUiWidgetScrollToEnd" testdata/emitui/textwidgets.c.golden
```

Expected: the grep shows exactly two call lines, `clar_fn_rtUiWidgetScrollToEnd(<inst>, 1);` (one in the launch handler with the explicit instance, one in `Body.change` with the handler's own instance). Then:

Run: `go test -count=1 ./internal/emitui -v 2>&1 | tail -5`
Expected: PASS (byte-compare + m68k compile-check of the golden).

- [ ] **Step 9: Error fixtures**

`testdata/errors/scrollend_kind.cla`:

```
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// textview-scroll-to-end phase: scrollToEnd is a TEXTVIEW method only --
// on any other widget kind (a field here) it is "undefined", the same
// diagnostic every non-canvas, non-textview widget method already gets.
window W {
    title: "W"
    size: 200, 100
    field Name { label: "Name:"; at: 20, 20; width: 100 }
}

extend W {
    on Name.change {
        Name.scrollToEnd()
    }
}

on App.launch {
    open W
}
```

`testdata/errors/scrollend_arity.cla`:

```
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// textview-scroll-to-end phase: scrollToEnd takes no arguments -- the
// shared checkTableMethod arity rule rejects any.
window W {
    title: "W"
    size: 200, 100
    textview Body { at: 20, 20; fill: both; scrollbar: vertical }
}

extend W {
    on Body.change {
        Body.scrollToEnd(1)
    }
}

on App.launch {
    open W
}
```

Generate each `.expect` the way `diag_test.go` captures them — from `internal/selfhost` so the relative path matches:

```sh
cd internal/selfhost
../../build-run/clarusc emit --rtdir ../../runtime/clarus/ -o ../../build-run/x.c ../../testdata/errors/scrollend_kind.cla > ../../testdata/errors/scrollend_kind.expect; echo "exit $?"
../../build-run/clarusc emit --rtdir ../../runtime/clarus/ -o ../../build-run/x.c ../../testdata/errors/scrollend_arity.cla > ../../testdata/errors/scrollend_arity.expect; echo "exit $?"
cd ../..
cat testdata/errors/scrollend_kind.expect testdata/errors/scrollend_arity.expect
```

Expected: both exit 1; the first `.expect` is one line ending `undefined: scrollToEnd`, the second one line ending `wrong number of arguments`, both prefixed `../../testdata/errors/<name>.cla:<line>:<col>: `. If a message differs, the compiler change is wrong — fix it, don't bless the wrong text.

Run: `go test -count=1 -timeout 30m ./internal/selfhost -run 'Diag' -v 2>&1 | tail -8`
Expected: PASS incl. the two new fixtures.

- [ ] **Step 10: Regenerate the snapshot**

```sh
cc -O1 -I runtime/host -o build-run/boot clarusc/clarusc.c runtime/host/rt.c
build-run/boot emit --rtdir runtime/clarus/ -o build-run/cur.c clarusc/main.cla
cc -O1 -I runtime/host -o build-run/cur build-run/cur.c runtime/host/rt.c
build-run/cur emit --rtdir runtime/clarus/ -o clarusc/clarusc.c clarusc/main.cla
go test -count=1 -timeout 30m ./internal/selfhost -run TestSnapshotFixedPoint -v 2>&1 | tail -3
```

Expected: `snapshot fixed point reached`.

- [ ] **Step 11: Segment-headroom check for the two touched dispatchers**

`cgIntrUi` and `fpIntrCall12` each sit under a 32 KB single-segment CODE ceiling when clarusc compiles ITSELF natively (the last phase had to split `fpIntrCall12` for this). Prove the one-arm additions still fit:

Run: `scripts/build-clarusc-mac.sh 2>&1 | tee build-run/clarusc-mac.log | grep -c "exceeds the 32KB segment limit"`
Expected: `0` (and the script exits 0 — check `tail -3 build-run/clarusc-mac.log`). If it prints a function name, split that function the way `fpIntrCall12` was split from `fpIntrCall11` (move the trailing arms verbatim into a new `fpIntrCall14`/`cgIntrUi2` tail function and chain to it from the original's final `else`), then redo Step 10.

- [ ] **Step 12: T1 gate**

Run: `scripts/test-task.sh --smoke`
Expected: all PASS. (`internal/cg68k` goldens must be untouched — no fixture there uses the new method; if any `.s` golden diffs, something else changed and must be understood before proceeding.)

- [ ] **Step 13: Commit**

```bash
git add clarusc/check.cla clarusc/ir.cla clarusc/lower.cla clarusc/cg68k.cla clarusc/cprint.cla clarusc/clarusc.c testdata/emitui/textwidgets.cla testdata/emitui/textwidgets.c.golden testdata/errors/scrollend_kind.cla testdata/errors/scrollend_kind.expect testdata/errors/scrollend_arity.cla testdata/errors/scrollend_arity.expect
git commit -m "feat(clarusc): textview.scrollToEnd() widget method (check/lower/cg68k/cprint, snapshot regen)"
```

---

### Task 3: Hardware proof — toolbox suite `ScrollToEnd` case

**Files:**
- Create: `testsuite/toolbox/cases_scrollend.cla`
- Modify: `testsuite/toolbox/runner.cla` — enum (`:162`, before `SelfCheck`), `nTbCases` (`:171`, 33→34 and its comment "32 real" → "33 real"), `tbCaseName` (`:273-275` pattern), `tbAllCases` (`:318` pattern), dispatch (`:481-484` pattern), and the header comment listing cases (~`:121`)
- Modify: `internal/mactest/coresuite_test.go` — `toolboxFiles` (add after `cases_leak.cla`, `:319`), the file-list comment (~`:265-270`), the count comment (`:456-458`), `if len(results) != 33` (`:484-485`) and `"TOTAL 33 PASS 33 FAIL 0"` (`:495`) → 34
- Modify: `internal/bake/bakeidentity_test.go` — `toolboxSuiteGUIFiles` (add after its `cases_leak.cla` entry)

**Interfaces:**
- Consumes: Task 1's `UiTestTextviewScroll(i: int): int`; Task 2's `w.Body.scrollToEnd()`; `harness.cla`'s existing `TextWin` (widgets in order: `Name`=0, `Fill32000`=1, `Fill32001`=2, `Body`=3; `Body` has `scrollbar: vertical`; per-instance `bodyChanges: int` counter read as `w.bodyChanges`, the way `cases_textwidgets.cla` reads it).
- Produces: `ToolboxTest.ScrollToEnd`, `func caseScrollToEnd(): TestResult`.

- [ ] **Step 1: Write the case**

`testsuite/toolbox/cases_scrollend.cla`:

```
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// cases_scrollend.cla: ScrollToEnd (textview-scroll-to-end phase) --
// hardware-proves `textview.scrollToEnd()` (rtUiWidgetScrollToEnd,
// uiwidgets.cla) against harness.cla's TextWin, whose Body textview is
// widget index 3 (Name 0, Fill32000 1, Fill32001 2, Body 3) and has a
// vertical scrollbar. UiTestTextviewScroll(3) (uitest.cla) reads Body's
// TE offset (viewRect.top - destRect.top) straight off the front window.
//
// Four assertions: (1) a fresh 100-line set leaves the view at the top
// (offset 0 -- rtUiTeScrollSync never moves a view that is in range);
// (2) scrollToEnd moves it to a strictly positive offset; (3) a second
// scrollToEnd is idempotent (same offset); (4) after replacing the
// content with 3 lines that fit, scrollToEnd leaves the offset at 0 (the
// fits => no-op branch: maxScroll clamps to 0, never negative). Plus:
// bodyChanges stays 0 throughout -- scrollToEnd is programmatic and must
// never fire Body.change.
const tbSeLines: int = 100

func caseScrollToEnd(): TestResult {
    var w: TextWin
    var t: text
    var i: int
    var s0: int
    var s1: int
    var s2: int
    var s3: int
    var changes: int
    var ok: bool
    var detail: string

    w = open TextWin

    i = 0
    while i < tbSeLines {
        t.append("line\n")
        i = i + 1
    }
    w.Body.text = t
    s0 = UiTestTextviewScroll(3)
    w.Body.scrollToEnd()
    s1 = UiTestTextviewScroll(3)
    w.Body.scrollToEnd()
    s2 = UiTestTextviewScroll(3)
    w.Body.text = "a\nb\nc\n"
    w.Body.scrollToEnd()
    s3 = UiTestTextviewScroll(3)
    changes = w.bodyChanges

    close w

    ok = s0 == 0 and s1 > 0 and s2 == s1 and s3 == 0 and changes == 0
    if ok {
        return tkPass("ScrollToEnd")
    }
    // Built up piecewise, same native-68k per-statement temp-slot budget
    // reason as cases_bigtext.cla's own detail string.
    detail = "s0 " + tkIntToStr(s0)
    detail = detail + " s1 " + tkIntToStr(s1)
    detail = detail + " s2 " + tkIntToStr(s2)
    detail = detail + " s3 " + tkIntToStr(s3)
    detail = detail + " changes " + tkIntToStr(changes)
    return tkFail("ScrollToEnd", detail)
}
```

- [ ] **Step 2: Wire it into `runner.cla`**

Add `ScrollToEnd` to the `ToolboxTest` enum right after `LeakCheck` (before `SelfCheck`); `nTbCases` 33 → 34 and its comment's "32 real" → "33 real"; in `tbCaseName` add

```
    case ScrollToEnd {
        return "ScrollToEnd"
    }
```

after the `LeakCheck` case; in `tbAllCases` add `l.add(ScrollToEnd)` after `l.add(LeakCheck)`; in the dispatch add, after the `LeakCheck` block:

```
    if wantAll or tbHas(deduped, ScrollToEnd) {
        results.add(caseScrollToEnd())
        casesRun = casesRun + 1
    }
```

and extend the runner's header comment (after the LeakCheck sentence): "ScrollToEnd (cases_scrollend.cla) is the textview-scroll-to-end phase's addition: hardware-proves `textview.scrollToEnd()` against TextWin's Body — see that case's own header comment."

- [ ] **Step 3: Wire the file into BOTH Go lists**

`internal/mactest/coresuite_test.go`: add `filepath.Join("testsuite", "toolbox", "cases_scrollend.cla"),` after the `cases_leak.cla` line in `toolboxFiles`; change `33` → `34` in the `len(results)` check, its error string, and `"TOTAL 33 PASS 33 FAIL 0"` → `"TOTAL 34 PASS 34 FAIL 0"`; update the count comment ("then to 34 by the textview-scroll-to-end phase's ScrollToEnd addition … 33 real cases + SelfCheck") and the file-list comment.

`internal/bake/bakeidentity_test.go`: add the same `cases_scrollend.cla` entry after `cases_leak.cla` in `toolboxSuiteGUIFiles`. (The LeakCheck landing forgot this list and needed a follow-up commit — don't repeat that.)

- [ ] **Step 4: Compile-check the suite before booting**

Run: `go test -count=1 ./internal/bake -run 'Toolbox|Identity' -v 2>&1 | tail -5`
Expected: PASS (proves the suite composition, with the new case, emits natively with and without `--rtbake`).

- [ ] **Step 5: Boot it on the emulator**

Run: `CLARUS_MAC_TESTS=1 go test -count=1 -timeout 30m ./internal/mactest -run 'TestToolboxSuiteOn68k$' -v 2>&1 | grep -E "^(=== RUN|--- (PASS|FAIL)|\s+--- (PASS|FAIL))" | grep -E "ScrollToEnd|SelfCheck|TestToolboxSuiteOn68k"`
Expected: `--- PASS: TestToolboxSuiteOn68k/ScrollToEnd` and `/SelfCheck` (SelfCheck fails if the dispatch block was missed) and the parent PASS. On a FAIL, the `tkFail` detail (`s0 … s1 … s2 … s3 … changes …`) is in the captured log — read the runtime, don't loosen the assertions.

- [ ] **Step 6: T1 gate**

Run: `scripts/test-task.sh --smoke`
Expected: all PASS.

- [ ] **Step 7: Commit**

```bash
git add testsuite/toolbox/cases_scrollend.cla testsuite/toolbox/runner.cla internal/mactest/coresuite_test.go internal/bake/bakeidentity_test.go
git commit -m "test: toolbox suite ScrollToEnd case (34 cases) hardware-proves textview.scrollToEnd()"
```

---

### Task 4: Docs, close-out, T2

**Files:**
- Modify: `docs/clarus-language-reference.md` — Ch8 "Widgets" (after the paragraph beginning "`binds` connects a `field`…", ~`:1074`); the Ch8 Events "programmatic writes are silent" sentence (~`:2049`); Ch11 "Canvas Drawing Methods" intro sentence (~`:1272`) if it claims canvases are the only widgets with methods
- Modify: `CLAUDE.md` — the `testsuite/toolbox/` count sentence (`:122`, "33 `ToolboxTest` cases: 32 real +" → 34/33, with a "then to 33 real by the textview-scroll-to-end phase's `ScrollToEnd` case" clause appended in the same style as the `LeakCheck` clause)
- Modify: `docs/ROADMAP.md` — a new phase entry directly after the `68k-call-result-release` entry (`:170`), same shape; `STATUS.md` — replace the §0 handoff header/summary for this phase; `docs/TODO.md` — a `### textview-scroll-to-end phase (2026-08-29)` section only if a deferral was actually found (otherwise none)
- Modify: `../68kbbs/docs/language-gaps.md` — §9 marked SHIPPED (separate repo; edit only, do not commit there)

**Interfaces:** none new.

- [ ] **Step 1: Reference — Ch8 widget method paragraph**

Insert after the "`binds` connects a `field`…" paragraph:

```
A `textview` has one method, `scrollToEnd()`, callable as a statement from any handler (`Body.scrollToEnd()` inside the window's own `extend` block, or `w.Body.scrollToEnd()` through a window reference) — the same call shape a `canvas`'s drawing methods use (Chapter 11). It scrolls the view so its last line is visible and moves the vertical scrollbar to match; when the content already fits it does nothing, and the horizontal position is never changed. Like every programmatic write to a widget, it never fires `change`. A log window fed from `on App.log` (Chapter 7) assigns its `text` and then calls `scrollToEnd()` so the newest line is always the one on screen. It is a `textview` method only — on any other widget kind it is a check error.
```

- [ ] **Step 2: Reference — events sentence and Ch11 intro**

In the sentence at ~`:2049` ("…and never for a program's own assignment to the widget's property (e.g. `Body.text = t`)…") extend the parenthetical to "(e.g. `Body.text = t`, or a `textview`'s `scrollToEnd()`)". Read the Ch11 "Canvas Drawing Methods" opening sentence; if it says or implies canvases are the only widgets with methods, add "— and the `textview`'s `scrollToEnd()` (Chapter 8) is the only other widget method" in its own clause. Do NOT add a code fence anywhere.

Run: `go test -count=1 ./internal/reftest -v 2>&1 | tail -4`
Expected: PASS (no fence count change).

- [ ] **Step 3: CLAUDE.md, ROADMAP.md, STATUS.md, TODO.md**

- `CLAUDE.md:122`: update the toolbox count to "34 `ToolboxTest` cases: 33 real + `SelfCheck`" and append, after the `LeakCheck` clause, "— then to 33 real by the textview-scroll-to-end phase's `ScrollToEnd` case, which hardware-proves the new `textview.scrollToEnd()` widget method on both lanes".
- `docs/ROADMAP.md`: after the `68k-call-result-release` entry add a bold-led paragraph in the same shape: **`textview-scroll-to-end` phase (branch `textview-scroll-to-end`, 2026-08-29, based on `main` at `36b76ab`) is COMPLETE — full T2 green, NOT YET merged:** one new widget method, `textview.scrollToEnd()` (`../68kbbs/docs/language-gaps.md` §9's log-window ask), wired along the canvas-method path (`check.cla` `textviewMethods` → `lower.cla` `lowTextviewMethod` → `ui_scroll_to_end` intrinsic → `cg68k.cla`/`cprint.cla` one-arm forwarders → `rtUiWidgetScrollToEnd`, `uiwidgets.cla`), hardware-proved by the toolbox suite's new `ScrollToEnd` case (34 cases) via a new `UiTestTextviewScroll` probe; the shelved implicit follow-if-at-end setter semantics were rejected (ambiguous when content fits — spec §Problem). Spec: `docs/superpowers/specs/2026-08-29-textview-scroll-to-end-design.md`; ledger `.superpowers/sdd/2026-08-29-textview-scroll-to-end/`.
- `STATUS.md`: rewrite the title line and first paragraph as the handoff for THIS phase (same content as the ROADMAP paragraph, plus: the 68k-call-result-release phase is merged to local `main` at `36b76ab`, NOT pushed; next up is still AppleTalk → MacTCP per ROADMAP). Keep the rest of the file's still-true sections; delete sections that only described the previous phase's in-flight state.
- `docs/TODO.md`: add a section only for real deferrals discovered during Tasks 1-3 (e.g. a `scrollToTop`/general `scroll` property request, or a segment split forced by Task 2 Step 11). If none, add nothing.

- [ ] **Step 4: 68kbbs gap doc**

In `../68kbbs/docs/language-gaps.md` §9's heading append " — SHIPPED", and add a final bullet:

```
- **Shipped** (2026-08-29) — as shipped: `LogView.scrollToEnd()`, a
  `textview`-only method (statement form, no arguments). Scrolls so the
  last line is visible and pins the vertical scrollbar; no-op when the
  content fits; horizontal position untouched; never fires `change`.
  The implicit follow-if-at-end setter alternative was rejected: "at
  end" is ambiguous when content fits (opening a short document over
  another would jump to its end). App side: `LogView.text = t` then
  `LogView.scrollToEnd()` in `on App.log`; the trim-to-newest-16KB half
  still needs nothing new.
```

Update the summary table's row 9 to "Textview scroll-to-end — shipped" and the closing paragraph's "Item 9 (textview scrolling) is a UI gap…" sentence to say it shipped 2026-08-29. Do not commit in that repo.

- [ ] **Step 5: T1, then full T2**

Run: `scripts/test-task.sh --smoke`
Expected: all PASS.

Run: `scripts/test-merge.sh 2>&1 | tee build-run/t2.log | tail -30`
Expected: every package `ok`, including `internal/selfhost` and the gated `internal/mactest` native lane (`TestToolboxSuiteOn68k`/`TestToolboxSuiteJiggleOn68k` with 34/34, `TestCoreSuiteGUIOn68k`, the four frozen scenario goldens unchanged). Any red: stop and report with the failing test's output; do not rebless goldens to make it pass.

- [ ] **Step 6: Commit**

```bash
git add docs/clarus-language-reference.md CLAUDE.md docs/ROADMAP.md STATUS.md docs/TODO.md
git commit -m "docs: textview-scroll-to-end close-out (reference, CLAUDE.md, ROADMAP, STATUS)"
```

(`../68kbbs` stays uncommitted, per the standing convention for that repo's gap doc.)
