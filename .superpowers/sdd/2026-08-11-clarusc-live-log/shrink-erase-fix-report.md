# Shrink-erase stale-pixels bugfix — report

## Bug

`rtUiWidgetSetText`'s live-paint block (added this phase, `runtime/clarus/uiwidgets.cla`)
draws a textview's fresh content synchronously (`UiTEUpdate`) then cancels the
queued update event (`UiValidRect`) so a programmatic `textview.text = ...`
set is visible immediately, mid-handler, without waiting for a real update
event. When the new content is **shorter** than what it replaces, this leaves
stale pixels: `TEUpdate` only draws the new content's own lines, it never
erases anything below them, and `UiValidRect` cancels the one event
(the queued update) that would otherwise have repainted — and thus erased —
that remainder. Andrew saw this live on Snow: `ClarusC.APPL`'s second
compile's short, fresh 2-line ticker painted on top of the first compile's
long restored log, leaving old lines visible below the new ones.

`rtUiWidgetSetStr`'s label branch (`uiwidgets.cla` ~line 812) was checked and
is **not** affected — it draws via `UiTextBox` (TETextBox), whose own header
comment states it erases its whole rect first, so a shorter label leaves no
residue. No change was made there.

## Fix

In `rtUiWidgetSetText`, before the existing `UiTEUpdate`/`UiValidRect` pair,
erase the portion of the TE view rect below the new content's bottom:

```
teMp = UiHandleDeref(te)
viewTop = peekw(teMp + rtUiTeViewRect + 0)
viewBottom = peekw(teMp + rtUiTeViewRect + 4)
contentBottom = peekw(teMp + rtUiTeDestRect + 0) + peekw(teMp + rtUiTeNLines) * peekw(teMp + rtUiTeLineHeight)
if contentBottom < viewTop { contentBottom = viewTop }
if contentBottom < viewBottom {
    eraseRect = UiNewPtr(rtUiRectSize)
    UiSetRect(eraseRect, peekw(teMp + rtUiTeViewRect + 2), contentBottom, peekw(teMp + rtUiTeViewRect + 6), viewBottom)
    UiEraseRect(eraseRect)
    UiDisposePtr(eraseRect)
}
UiTEUpdate(teMp + rtUiTeViewRect, te)
UiValidRect(teMp + rtUiTeViewRect)
```

`contentBottom` uses the same `teMp` fields `rtUiTeScrollSync` (uitext.cla:334-346)
already reads to compute scroll range (`rtUiTeDestRect` top + `rtUiTeNLines`
* `rtUiTeLineHeight`), clamped into the view rect. The erase is skipped
entirely when content already fills the view (nothing stale to clear, and it
avoids a whole-view flicker on every ticker repaint that already fills its
box). `UiEraseRect` (trap `0xA8A3`) was already declared in `uiwidgets.cla`
(line 68) — no new extern needed. The scratch rect uses the same
`UiNewPtr(rtUiRectSize)` / `UiDisposePtr` idiom as the update path's own TE
frame draw (`ui.cla:1660`).

## TDD: RED before, GREEN after

`caseLivePaint` (`testsuite/toolbox/cases_textwidgets.cla`) was extended with
a shrink leg: a probe region low in Body's TE view rect
(`(88,272)-(152,304)`), a `shrinkBaseline` checksum taken while that region
is genuinely blank (before this leg's own first set — the same convention
used by the case's existing growth-leg `before`/`after` pair), then a tall
30-line set (paints ink into the probe), then a short 1-line set, then a
final checksum that must equal `shrinkBaseline`.

Deriving the probe took two iterations, both worth recording since they
explain the constants in the final test:

- First attempt used a 1-character-per-line fill (`"X\n"` x30). The
  checksum came back 0 even for the TALL leg — a 1-char glyph only paints a
  few pixels near the view's left edge and never reached the probe's
  `x=88` column regardless of line count. Fixed by using a full-width line
  (`"XXXXXXXXXXXXXXXXXXXX\n"` x30) instead.
- Confirmed the probe's geometry against `rtUiLayout`/`rtUiTeRelayout`
  (`uiwidgets.cla`/`uitext.cla`) directly rather than trusting the header
  comment's "approximately": Body's TE view rect is exactly
  `(79,95)-(438,313)` GLOBAL for `TextWin`'s `size: 400, 280`, so `(88,272)-
  (152,304)` sits comfortably inside it.

RED (before the runtime fix, `CLARUS_MAC_TESTS=1 go test ./internal/mactest
-run TestToolboxSuiteOn68k -count=1 -timeout 20m -v`):

```
FAIL LivePaint: before 0 after 4302 beforeL 0 afterL 5426 shrinkBaseline 0 shrinkAfterTall 10470 shrinkAfterShort 10470
TOTAL 30 PASS 29 FAIL 1
```

`shrinkAfterShort` (10470) equals `shrinkAfterTall` (10470), not
`shrinkBaseline` (0) — the shrink never erased the tall content's stale
pixels, exactly the reported bug.

GREEN (after the runtime fix, same command):

```
--- PASS: TestToolboxSuiteOn68k/LivePaint (0.00s)
...
ok  	clarus/internal/mactest	48.031s
```

All 30/30 cases pass.

## Golden outcomes

- `testdata/emitui/*.c.golden`: all 14 files changed, each with the exact
  same ~27-line diff (the new `rtUiWidgetSetText` body is spliced into every
  UI build). Eyeballed `win_basic.c.golden`'s diff — matches the `.cla`
  change 1:1 (new locals, the `contentBottom`/erase-rect block, `teMp` reuse
  in the trailing `UiTEUpdate`/`UiValidRect` calls).
- `testdata/cg68k/*.s`: T1 (`scripts/test-task.sh --smoke`) first run showed
  `TestCg68kGoldens` FAIL (assembly churn from the new locals/branches in
  `rtUiWidgetSetText`, propagating through `bounce`/`tickprobe`'s segmented
  output) — same pattern the plan's own Task 1 hit. Reblessed with
  `CLARUS_CG68K_BLESS=1 go test ./internal/cg68k -run TestCg68kGoldens
  -count=1`: 7 files updated (`bounce.s`/`.seg2-4.s`, `tickprobe.s`/`.seg2-3.s`)
  plus one new segment, `testdata/cg68k/tickprobe.seg4.s` (260 lines) — the
  extra code pushed `tickprobe` over its 2nd segment boundary. Re-ran T1
  --smoke afterward: PASS (includes the two native-68k emulator smoke
  tests).

## Files touched

- `runtime/clarus/uiwidgets.cla` — the fix, in `rtUiWidgetSetText`.
- `testsuite/toolbox/cases_textwidgets.cla` — `caseLivePaint`'s shrink leg
  and its new `tbLpShrink*` constants.
- `testdata/emitui/*.c.golden` (14 files) — regenerated.
- `testdata/cg68k/*.s` (7 files) + new `tickprobe.seg4.s` — reblessed.
- `.superpowers/sdd/2026-08-11-clarusc-live-log/progress.md` — ledger entry.
