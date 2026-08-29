# Textview `scrollToEnd()` — design

**Date:** 2026-08-29
**Status:** approved (brainstorm 2026-08-29, andrew)
**Origin:** `../68kbbs/docs/language-gaps.md` §9 — a log window fed from
`on App.log` sits at whatever line the user last dragged to, so the lines
that matter most (the last ones before a crash) are off-screen.

## Problem

A `textview`'s only runtime property is `text`. A programmatic set
(`LogView.text = t`) keeps the previous scroll offset, clamped to the new
range (`rtUiTeScrollSync`, `runtime/clarus/uitext.cla:323`). There is no
way for a program to scroll the view at all.

The gap doc's shelved alternative — implicit follow-if-at-end in the
setter — was rejected in brainstorming: "at end" is ambiguous when the
content *fits* the view (offset 0 == max 0), so opening a short document
over another short one would jump to its end, and restricting follow to
"was overflowing" leaves a log window stuck at the top from the moment it
first overflows. An explicit call is the honest primitive.

## Language surface

One new widget method, `textview` only:

```
LogView.scrollToEnd()
```

- Statement form only (returns nothing), same grammar as the existing
  `canvas` methods (Ch11: `g.Board.clear()`), both the explicit
  `w.Body.scrollToEnd()` and the bare in-handler `Body.scrollToEnd()`
  shape. No arguments.
- Scrolls the view so its last line is fully visible: the vertical offset
  becomes `max(0, nLines*lineHeight - viewHeight)`; the vertical
  scrollbar's value is pinned to the same number. Horizontal offset
  untouched.
- No-op when the content already fits. A `textview` declared without
  `scrollbar:` has a TE but no control: the TE still scrolls, there is
  just no thumb to pin. Mac-only, like every other widget call — the host
  lane (`clarusc emit` + `cc`, `runtime/host`) has no UI runtime at all,
  so no host code is touched.
- Programmatic: never fires `change` — the same "programmatic writes are
  silent" rule the setter follows.
- On any other widget kind, `Widget.scrollToEnd()` is a check error
  (`undefined: scrollToEnd`), the same diagnostic a non-canvas widget
  method already gets. Argument arity is checked by the shared
  `checkTableMethod` signature machinery.

## Compiler (clarusc)

Follow the canvas-method precedent exactly; every site is a one-arm
addition beside an existing arm.

| File | Change |
|---|---|
| `clarusc/check.cla` | New `textviewMethods` table (`sigStart(); textviewMethods["scrollToEnd"] = sigEnd(-1)`, registered where `canvasMethods` is, ~`:1795`). `checkMethodCall`'s `TyWidget` case (~`:2215`) dispatches `"textview"` to it beside `"canvas"`. |
| `clarusc/ir.cla` | New intrinsic name `IUiScrollToEnd()` → `intern("ui_scroll_to_end")`, beside `IUiSetTextviewText` (~`:4682`). |
| `clarusc/lower.cla` | `lowMethodCall`'s `TyWidget` arm (~`:1336`) routes by `findWidgetKind`: `"textview"` → new `lowTextviewMethod`, which resolves the receiver with `lowWidgetRecv`, appends the widget index, and returns `newIRExprStmt(newIRIntr(IUiScrollToEnd(), head, irVoidT))` — i.e. `lowWidgetSetAssign`'s shape minus the value arg. Unknown name → `lowUnsupported`. |
| `clarusc/cg68k.cla` | New `rnUiWidgetScrollToEnd = intern("rtUiWidgetScrollToEnd")` (~`:508`) and an `IUiScrollToEnd` arm in the intrinsic dispatcher: `cgIntrUiForward(e, rnUiWidgetScrollToEnd)` (the canvas arms' helper, `:9360`). |
| `clarusc/cprint.cla` | `IUiScrollToEnd` arm: `fpEmit("clar_fn_rtUiWidgetScrollToEnd(" + a0 + ", " + a1 + ");")`, beside `IUiCanvasClear` (~`:3864`). |

No parser change: `Widget.name(args)` already parses (canvas). The
checker's `widgetRuntimeProps` table is untouched — this is a method, not
a property.

## Runtime (`runtime/clarus/uiwidgets.cla`)

```
func rtUiWidgetScrollToEnd(instV: ptr, wIdx: int)
```

beside `rtUiWidgetSetText`. Steps:

1. Resolve `w = RtUiWinst(instV)`, `te = rtUiTeAt(w, wIdx)`; return if the
   kind is not `rtUiKindTextview` or `te == ptr(0)`.
2. `rtUiTeScrollSync(instV, wIdx)` first, so the scrollbar maximum and the
   TE offset are already consistent (it re-derives `teMp` after every
   Toolbox call that can move memory — keep that discipline here).
3. Re-derive `teMp = UiHandleDeref(te)`; compute `viewH`, `contentH =
   nLines*lineHeight`, `maxScroll = max(0, contentH - viewH)`, `offset =
   viewRect.top - destRect.top` from the same fields `rtUiTeScrollSync`
   reads (`rtUiTeViewRect`/`rtUiTeDestRect`/`rtUiTeNLines`/
   `rtUiTeLineHeight`, `uitext.cla:49-57`).
4. If `offset < maxScroll`: `UiSetPort(w.wp)` bracketed by
   `rtUiGetPortSaved`/`UiSetPort(savedPort)` like the setter,
   `UiTEScroll(0, offset - maxScroll, te)` (negative dv moves content up),
   then, if `rtUiCtrlAt(w, wIdx) != ptr(0)`, `UiSetControlValue(sb,
   maxScroll)`.

`TEScroll` redraws the view itself, so no `TEUpdate`/`InvalRect` dance is
needed; the existing scroll-thumb handlers (`uitext.cla:819-861`) already
use `UiTEScroll` + `UiSetControlValue` this way.

Host lane: nothing to add — `runtime/host` has no UI. The cprint arm emits
a call into the same Clarus runtime module compiled for the Retro68 lane.

## Tests

- **Hardware (toolbox suite, both lanes):** new case `ScrollToEnd`
  (`testsuite/toolbox/cases_scrollend.cla`) against `harness.cla`'s
  existing `TextWin` (`Body` is widget index 3, `scrollbar: vertical`).
  Oracle: a new `UiTestTextviewScroll(i: int): int` in
  `runtime/clarus/uitest.cla` — sibling of `UiTestPopupBoxLeft` — returning
  `viewRect.top - destRect.top` for widget `i` of the front window
  (`rtUiTeAt(rtUiWinstOf(UiFrontWindow()), i)`). The case: set 100 short
  lines → scroll reads 0; `w.Body.scrollToEnd()` → scroll reads a value
  `> 0`; a second `scrollToEnd()` → unchanged (idempotent); set 3 lines →
  `scrollToEnd()` reads 0 (fits ⇒ no-op). Wire into `runner.cla` (enum,
  name, `tbAllCases`, dispatch, `nTbCases` 33→34) and BOTH Go file lists
  (`internal/mactest/coresuite_test.go`'s `toolboxFiles` + result-count
  assertions, and `internal/bake/bakeidentity_test.go`'s
  `toolboxSuiteGUIFiles` — the LeakCheck landing missed the second one).
- **Check errors:** `testdata/errors/scrollend_kind.cla` (`Name.
  scrollToEnd()` on a `field` → `undefined: scrollToEnd`) and
  `testdata/errors/scrollend_arity.cla` (`Body.scrollToEnd(1)` → the
  shared `wrong number of arguments` diagnostic), each with its `.expect`
  (path form `../../testdata/errors/<f>.cla:L:C: msg`; runner is
  `internal/selfhost/diag_test.go`, T2 — run it directly during the task
  with `go test -count=1 -timeout 30m ./internal/selfhost -run Diag`).
- **Positive compile (T1):** extend `testdata/emitui/textwidgets.cla`
  with both the explicit `w.Body.scrollToEnd()` and bare in-handler
  `Body.scrollToEnd()` shapes and regenerate its `.c.golden` (the emitted
  C, byte-for-byte; `internal/emitui` then m68k compile-checks it — the
  spliced runtime modules' own prototypes are in the emitted C, so the
  new `clar_fn_rtUiWidgetScrollToEnd` resolves with no header change).
- **Snapshot:** `clarusc/clarusc.c` regenerated (`TestSnapshotFixedPoint`).
- Gates: T1 `--smoke` after each task; T2 before merge.

## Docs

- `docs/clarus-language-reference.md`: Ch8 "Widgets" — after the widget
  table, note that `textview` has one method, `scrollToEnd()`, with the
  semantics above (fits ⇒ no-op, horizontal untouched, silent). Ch8's
  `Events` paragraph on programmatic silence gains `scrollToEnd` in its
  list. Ch11's "only a canvas has methods" phrasing, if present, updated.
- `docs/HISTORY.md`/`STATUS.md`/`ROADMAP.md`/`TODO.md` close-out entries;
  `CLAUDE.md`'s toolbox-suite count (33→34) sentence.
- `../68kbbs/docs/language-gaps.md` §9: mark SHIPPED with the as-shipped
  shape (separate repo; leave uncommitted there, as with earlier gaps).

## Explicitly out of scope

`scrollToTop`, a general `scroll` int property, implicit follow mode, and
app-side log trimming (needs nothing new — `text.textAt`). Add when
68kbbs asks.
