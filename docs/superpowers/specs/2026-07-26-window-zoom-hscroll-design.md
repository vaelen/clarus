# Window Zoom + Horizontal Scrolling — Design

Date: 2026-07-26
Status: approved (brainstormed with Andrew)

## Goal

Complete resizable-window support: document windows get a zoom (maximize)
box, and `scrollbar: both` on a `textview` becomes real horizontal
scrolling instead of a documented no-op. The Text Editor acceptance app
(`examples/texteditor.cla`, Appendix C) demonstrates both. Resize itself,
`resizable: min(w, h)`, and the vertical scrollbar already exist and are
untouched.

Decisions made during brainstorming:

- **Zoom comes automatically with `resizable`** — no new syntax. Classic
  Mac document windows virtually always pair the grow box with a zoom box;
  a resizable Clarus window uses `zoomDocProc` instead of `documentProc`.
- **`scrollbar: both` implies no word wrap** — lines break only at Return
  and long lines extend right (code/log style). `scrollbar: vertical`
  keeps wrapping (prose style). One knob, self-consistent: a wrapped view
  has nothing to scroll horizontally, so no separate `wrap` property.

The Go compiler stays frozen. clarusc already accepts and lowers
`scrollbar: both` (it sets `RTUI_SCROLL_H`); compiler changes are expected
to be nil — the plan verifies this.

## Part 1 — Reference (docs/clarus-language-reference.md)

- Ch8 window-properties table, `resizable` row: grow box **+ zoom box** +
  optional minimum. Add a short note: zoom toggles between the user-set
  size/position and a standard state (the full screen minus the menu bar,
  clamped like window-open); zooming fires `resized`.
- `resized` event row: fired on user resize **or zoom**.
- Replace the "`scrollbar: both` is accepted but has no effect" Mac note
  with the real semantics: `both` disables word wrap and adds a horizontal
  scrollbar; `vertical` wraps. Note the fixed wide destination width
  (~2000 px, the classic TE idiom) as the horizontal scroll range.

## Part 2 — Zoom (runtime/mac/rt_ui.c)

- `NewWindow` proc: `resizable ? zoomDocProc : noGrowDocProc` (today:
  `documentProc` / `noGrowDocProc`).
- Event loop `inZoom` (both `inZoomIn` and `inZoomOut` part codes):
  `TrackBox`, then `ZoomWindow`, then route through the existing
  `rt_ui_apply_resize` funnel (layout, canvas realloc, TE relayout,
  scrollbar recompute, `resized` trace + handler). Set the port to the
  window before `ZoomWindow` (Toolbox requirement).
- Standard state: set the window's `stdState` rect to the screen minus
  menu bar before zooming out, clamped the same way open-time clamping
  already works, so zoom never puts the title bar or grow box off-screen.
- Script harness: a `zoom` event line (no arguments, toggles) compiled by
  `--events`, driving the same code path as `inZoom`, so UI snap tests are
  deterministic.

## Part 3 — Horizontal scrollbar (rt_ui.c)

`RTUI_SCROLL_H` becomes real:

- TE record created no-wrap: destRect fixed at ~2000 px wide (classic
  idiom; constant, not longest-line tracking), so TE breaks lines only at
  Return.
- A horizontal scrollbar control along the bottom edge of the textview,
  sharing the vertical bar's track/thumb/page/arrow logic; scrolling calls
  `TEScroll` with a horizontal delta. Range = destRect width − viewRect
  width; recomputed in the same clamp/recompute funnel the vertical bar
  already uses (content change, resize, zoom).
- When both bars are present, each bar stops 15 px short of the corner so
  the standard grow-box notch is preserved; the layout engine's scrollbar
  lane logic extends to reserve the bottom lane.
- `scrollbar: vertical` behavior is byte-identical to today.

## Part 4 — Example (examples/texteditor.cla + Appendix C)

- `textview Body { fill: both; scrollbar: both }` — the whole app diff.
  The window already declares `resizable: min(200, 120)`.
- Appendix C's editor source in the reference (and
  `testdata/valid/editor.cla`) updated to match, keeping the "verbatim
  plus app section" invariant documented at the top of texteditor.cla.

## Part 5 — Testing

- `testdata/ui` scenarios (blessed goldens via `CLARUS_MAC_BLESS=1`,
  trace + PBM snaps):
  - zoom out → snap → zoom in → snap (geometry restored),
  - horizontal scroll across a long unwrapped line,
  - resize with both bars present (bars re-laid-out, grow notch intact),
  - existing vertical-only scenarios stay green unchanged.
- Gated harness: `CLARUS_MAC_TESTS=1 go test ./internal/mactest`.
- Live emulator validation of the Text Editor (zoom, drag both bars,
  resize) before merge.

## Out of scope

- Longest-line tracking for the horizontal range (fixed 2000 px ceiling;
  revisit only if real documents hit it).
- Zoom for non-resizable windows, a separate `zoomable` property, and a
  `wrap` property — all rejected in brainstorming.
- Horizontal scrollbars on any widget other than `textview`.

## Addendum (2026-07-26, branch review feedback)

Andrew, reviewing the branch live, requested classic scrollbar behavior for
the horizontal bar, superseding two "out of scope" lines above:

- Scroll range tracks the widest line (longest-line tracking is now IN
  scope); when the content fits the view, max = 0 — the standard
  thumbless inactive bar ("dimmed when not needed").
- The view auto-scrolls to keep the caret visible (TEAutoView, both axes,
  textviews only), with scrollbars re-synced from the TE's actual
  view/dest offset afterward.
- The horizontal bar joins the deactivate HiliteControl dim loop (closing
  the deferred Task 2 minor).

Known ceiling, accepted: widest-line measurement is O(text length) per
content change; if live typing feel on a multi-KB document is sluggish,
add a current-line fast path (full rescan only on shrinking/bulk edits).
