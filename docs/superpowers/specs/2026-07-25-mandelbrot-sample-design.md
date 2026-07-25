# Mandelbrot Sample App + Canvas Pattern Fills — Design

Date: 2026-07-25
Status: approved (brainstormed with Andrew)

## Goal

A double-clickable sample app that exercises the 4b UI framework end to end:
a Mandelbrot renderer for the Mac Plus that draws progressively (rough
first, refining), stays responsive via the `every` timer, and represents
escape-time regions with dithered gray fills. Building it drives one real
framework gap: the canvas API has no pattern/gray fill support, so this
work has two deliverables:

1. **Framework:** a new canvas method `pattern(level: int)` — reference +
   clarusc + Mac runtime (the Go compiler stays frozen per CLAUDE.md).
2. **App:** `examples/mandelbrot.cla`, plus test scenarios.

## Part 1 — Canvas `pattern` method

### Language surface (reference §Drawing, Chapter 11)

```
c.pattern(level: int)
```

Sets the canvas's current *fill pattern*. `level` runs 0–8: 0 is white,
8 is black, 1–7 are ordered-dither grays of increasing density (a built-in
table of nine 8×8 QuickDraw patterns). Out-of-range values clamp. The
pattern applies to `fillRect` and `fillCircle` only; `rect`, `circle`,
`line`, `drawText`, and `clear` are unaffected. Each canvas starts at
level 8 (black), so existing programs behave exactly as before. The
setting is per-canvas and persists until changed.

Because QuickDraw patterns are aligned to the port, adjacent fills at any
rectangle size tile into a seamless dither — filling one region with many
small rects looks identical to filling it with one large rect.

### Implementation

- **Reference:** add `pattern` to the Drawing chapter's method list and the
  per-resource event/method inventory. One short paragraph as above.
- **clarusc `check.cla`:** `canvasMethods["pattern"]` with one plain `int`
  parameter (same shape as the existing entries).
- **clarusc `lower.cla` / intrinsics / cprint:** new intrinsic
  `IUiCanvasPattern` → `rt_ui_canvas_pattern`, lowered exactly like the
  other canvas methods (instance, widget index, args).
- **`runtime/mac/rt_ui.c/h`:** store a `Pattern` (or a 0–8 level) in
  `rt_ui_canvas_buf`, defaulting to black. `rt_ui_canvas_pattern(inst,
  wIdx, level)` clamps and stores. `rt_ui_canvas_rect` (fill arm) switches
  from `PaintRect` to `FillRect(&r, &pat)`; `rt_ui_canvas_fill_circle`
  from `PaintOval` to `FillOval(&box, &pat)`. The nine patterns are a
  static table in `rt_ui.c`.

## Part 2 — The app (`examples/mandelbrot.cla`)

### Window and widgets

- `window Fractal { title: "Mandelbrot"; size: 504, 298 }` — not
  resizable. The runtime centers windows with `top = 44`, so 504×298 is
  the largest clean fit on the 512×342 Mac Plus screen (512 wide would
  clamp to `left = 4` and hang off the right edge).
- One widget: `canvas Plot { at: 0, 0; fill: both; buffered }`. Buffered
  so window update events redraw accumulated work for free.

### Math

All arithmetic in 16.16 `fixed` (no float type exists; `*` is `FixMul`).
View: the full set, fit to height — y ∈ [−1.25, 1.25], x centered on
−0.75 (x span derived from the canvas aspect). Escape when x² + y² > 4;
`maxIter = 32`. Intermediate magnitudes stay far below the 16.16 range.

Iteration → dither level: escape at iteration i → `min(i − 1, 7)` (fast
escape = white, slow = dark halo); never escaped = 8 (black interior).

### Progressive rendering

Successive-refinement grid passes with per-instance window vars:
`step` (16 → 8 → 4 → 2 → 1), cursor `px, py`, `done`. Initialized in
`on opened`.

An `every 1 ticks` block: fetch `Fractal.front`; if nil or `done`, return.
Otherwise compute up to `BUDGET` samples (a named constant, initially 16;
a tuning knob, not a promise), each drawn as `pattern(level);
fillRect(px, py, step, step)` clamped to the canvas edge. Passes after
the first skip points whose coordinates were sampled by a coarser pass
(`px mod (step*2) == 0 and py mod (step*2) == 0`) — the coarse block
already shows that sample's pattern, so skipping is both a compute and a
draw saving. After the 1-px pass completes, `done = true`.

### Menus and lifecycle

```
menu File {
    item New  "New"  key "N"
    separator
    item Quit "Quit" key "Q"
}
```

- **New:** if `Fractal.front` is nil, `open Fractal` (its `opened` handler
  initializes state and rendering begins). Otherwise reset the existing
  instance: clear the canvas, reset `step`/`px`/`py`/`done`. New exists
  precisely because closing the window does not exit the app.
- **Quit:** `quit` (existing cascade).
- `on App.launch { open Fractal }`.
- No `closeRequest` handler: closing the window leaves the app running
  with the File menu, and File → New brings the window back.

## Testing

- **Pattern scenario:** `testdata/ui/pattern.cla` + blessed trace/snap
  goldens — draws fills at several levels including clamped out-of-range
  values; the PBM snap visually proves the dithers and their alignment.
- **App smoke scenario:** following the `smoke_bounce` pattern — scripted
  events run the app for N ticks (partial fractal), select File → New,
  run again, then Quit. Fixed-point math plus the fixed per-tick budget
  makes the snap fully deterministic.
- **Toolchain:** bootstrap/snapshot tests as usual for the clarusc
  changes. `clarus check` (frozen Go compiler) will not know `pattern`;
  the example and scenario are clarusc-only, consistent with CLAUDE.md's
  rule that new features land in reference + clarusc.

## Out of scope (this version)

- Window resizing / zoom box, click-to-zoom navigation, adaptive quadtree
  rendering, configurable iteration depth, saving images.
