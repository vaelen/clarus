# Mandelbrot Sample App + Canvas Pattern Fills Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a `pattern(level: int)` canvas method (dithered gray fills) to the framework, then build `examples/mandelbrot.cla` — a progressive Mandelbrot renderer for the Mac Plus — as the acceptance app that exercises it.

**Architecture:** The feature follows the existing canvas-method pipeline exactly: `clarusc/check.cla` signature table → `clarusc/lower.cla` intrinsic → `clarusc/cprint.cla` C emission → `runtime/mac/rt_ui.c` QuickDraw implementation. The app is a single fixed-size window with one buffered canvas, rendered by successive-refinement grid passes (16→8→4→2→1 px) driven by `every 1 ticks` with a fixed per-tick sample budget.

**Tech Stack:** Clarus (clarusc self-hosted compiler), C (Mac runtime, Retro68 m68k toolchain), Go test harnesses.

**Spec:** `docs/superpowers/specs/2026-07-25-mandelbrot-sample-design.md`

## Global Constraints

- The Go compiler (`cmd/clarus`, `internal/`) is FROZEN. `pattern` lands in reference + clarusc + Mac runtime only.
- `TestDifferentialFences` requires Go/clarusc diagnostic parity on every ```` ```rust ```` fence in `docs/clarus-language-reference.md`. The reference edit for `pattern` must therefore touch only the **untagged** method-list fence (line ~1063) and prose — do NOT add any ```` ```rust ```` fence containing `pattern`, and do not renumber existing fences.
- `pattern` must NOT appear in any file under `testdata/valid/`, `testdata/errors/`, `testdata/run/`, `testdata/runerr/`, `testdata/include/`, `testdata/diag/` — those are swept by the frozen Go compiler. `testdata/emitui/`, `testdata/ui/`, and `examples/` are safe (compiled only by clarusc).
- After any `clarusc/*.cla` change, the committed snapshot `clarusc/clarusc.c` must be regenerated (see Task 2) or `TestSnapshotCurrent` fails.
- New source files start with the standard header:
  `// Copyright 2026, Andrew C. Young <andrew@vaelen.org>` / `// SPDX-License-Identifier: MIT` (use `/* ... */` in C).
- Gated Mac tests: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run <Test>` (add `CLARUS_MAC_BLESS=1` to write goldens). Each scenario boots the emulator; allow ~1–3 min.
- Working branch: `mandelbrot-sample` (already exists; spec is committed on it).

---

### Task 1: Runtime — `rt_ui_canvas_pattern`

**Files:**
- Modify: `runtime/mac/rt_ui.h` (prototype, next to `rt_ui_canvas_rect` at ~line 171)
- Modify: `runtime/mac/rt_ui.c` (canvas-buf struct ~line 148, init in `rt_ui_open` ~line 1490, ops ~line 1771)

**Interfaces:**
- Produces: `void rt_ui_canvas_pattern(void *inst, short wIdx, short level);` — clamps `level` to 0..8 and stores it per-canvas; `rt_ui_canvas_rect(..., fill=1)` and `rt_ui_canvas_fill_circle` fill with the stored dither pattern (default level 8 = solid black, so existing behavior is unchanged). Task 2's cprint emission calls exactly this signature.

- [ ] **Step 1: Add the pattern level to the canvas buffer struct**

In `runtime/mac/rt_ui.c`, change line 148:

```c
typedef struct { GrafPtr port; BitMap bits; Ptr pixels; short patLevel; } rt_ui_canvas_buf;
```

- [ ] **Step 2: Add the dither table and the setter**

In `runtime/mac/rt_ui.c`, immediately above `rt_ui_canvas_clear` (~line 1745):

```c
/* Nine 8x8 fill patterns, level 0 (white) .. 8 (black): an ordered-dither
   density ramp (levels 5-7 are the bitwise complements of 3-1). QuickDraw
   aligns patterns to the port, not the filled rect, so adjacent fills at
   any rect size tile into one seamless dither (Ch11: pattern). */
static const Pattern rt_ui_gray_pats[9] = {
    {{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}},   /* 0: white  */
    {{0x88, 0x00, 0x22, 0x00, 0x88, 0x00, 0x22, 0x00}},   /* 1: 12.5%  */
    {{0x88, 0x22, 0x88, 0x22, 0x88, 0x22, 0x88, 0x22}},   /* 2: 25%    */
    {{0xAA, 0x22, 0xAA, 0x88, 0xAA, 0x22, 0xAA, 0x88}},   /* 3: 37.5%  */
    {{0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55}},   /* 4: 50%    */
    {{0x55, 0xDD, 0x55, 0x77, 0x55, 0xDD, 0x55, 0x77}},   /* 5: 62.5%  */
    {{0x77, 0xDD, 0x77, 0xDD, 0x77, 0xDD, 0x77, 0xDD}},   /* 6: 75%    */
    {{0x77, 0xFF, 0xDD, 0xFF, 0x77, 0xFF, 0xDD, 0xFF}},   /* 7: 87.5%  */
    {{0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF}},   /* 8: black  */
};

void rt_ui_canvas_pattern(void *instV, short wIdx, short level)
{
    rt_ui_winst *inst;

    inst = (rt_ui_winst *)instV;
    if (level < 0) level = 0;
    if (level > 8) level = 8;
    inst->canvases[wIdx].patLevel = level;
}
```

- [ ] **Step 3: Apply the pattern in the two fill ops**

In `rt_ui_canvas_rect`, replace `if (fill) PaintRect(&r);` with:

```c
    if (fill) FillRect(&r, &rt_ui_gray_pats[inst->canvases[wIdx].patLevel]);
```

In `rt_ui_canvas_fill_circle`, replace `PaintOval(&box);` with:

```c
    FillOval(&box, &rt_ui_gray_pats[inst->canvases[wIdx].patLevel]);
```

- [ ] **Step 4: Default every canvas slot to black**

In `rt_ui_open` (runtime/mac/rt_ui.c, right after the `inst->canvases = ... rt_ui_alloc_locked(...)` line, ~line 1490 — the alloc zero-fills, and zero would mean white):

```c
    {
        short wi;
        for (wi = 0; wi < d->nWidgets; wi++) inst->canvases[wi].patLevel = 8;
    }
```

- [ ] **Step 5: Add the prototype**

In `runtime/mac/rt_ui.h`, directly after the `rt_ui_canvas_rect` prototype (~line 171):

```c
void  rt_ui_canvas_pattern(void *inst, short wIdx, short level);
```

- [ ] **Step 6: Compile-check with the m68k toolchain**

```sh
toolchain/bin/m68k-apple-macos-gcc -c -Iruntime/mac -Iinternal/build/rt \
    -o /tmp/rt_ui_check.o runtime/mac/rt_ui.c
```

Expected: exit 0, no warnings about `rt_ui_canvas_pattern` or `Pattern`. (If the `Pattern` initializer syntax fights the Universal Interfaces' struct definition, adjust the braces — the goal is nine 8-byte rows exactly as listed.)

- [ ] **Step 7: Run the ungated suite to prove nothing regressed**

```sh
go test ./...
```

Expected: PASS (this task touches no Go-visible surface; emitui's golden compile-checks still compile against the new rt_ui.h).

- [ ] **Step 8: Commit**

```sh
git add runtime/mac/rt_ui.c runtime/mac/rt_ui.h
git commit -m "rt_ui: canvas fill patterns (rt_ui_canvas_pattern, 9-level dither ramp)"
```

---

### Task 2: clarusc surface + snapshot + reference

**Files:**
- Modify: `clarusc/check.cla` (~line 1016, after the `fillCircle` signature block)
- Modify: `clarusc/ir.cla` (~line 2079, after `IUiCanvasFillCircle`)
- Modify: `clarusc/lower.cla` (~line 795, `lowCanvasMethod`'s name dispatch)
- Modify: `clarusc/cprint.cla` (~line 978, the canvas intrinsic emission chain)
- Create: `testdata/emitui/canvas_pattern.cla` + `testdata/emitui/canvas_pattern.c.golden`
- Modify: `clarusc/clarusc.c` (regenerated snapshot)
- Modify: `docs/clarus-language-reference.md` (Chapter 11 §Canvas Drawing Methods, ~lines 1062–1070)

**Interfaces:**
- Consumes: `rt_ui_canvas_pattern(inst, wIdx, level)` from Task 1.
- Produces: the Clarus surface `c.pattern(level: int)` — checked (1 int arg, no result), lowered to intrinsic `ui_canvas_pattern`, emitted as `rt_ui_canvas_pattern(<inst>, <widgetIdx>, <level>);`. Tasks 3–4 write Clarus code that calls it.

- [ ] **Step 1: Write the failing-fixture test input**

Create `testdata/emitui/canvas_pattern.cla`:

```
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// canvas_pattern.cla: lowering fixture for the canvas `pattern` method
// (Ch11) -- one buffered canvas whose every-block sets a dither level and
// fills with it; the golden pins the rt_ui_canvas_pattern emission shape.

window W {
    title: "P"
    size: 100, 100

    canvas C { at: 0, 0; fill: both; buffered }
}

on App.launch {
    open W
}

every 1 ticks {
    var w: W = W.front
    if w != nil {
        w.C.pattern(4)
        w.C.fillRect(0, 0, 10, 10)
    }
}
```

- [ ] **Step 2: Verify it fails against current clarusc**

```sh
go run ./cmd/clarus build -o /tmp/clarusc-dev clarusc/main.cla
/tmp/clarusc-dev check testdata/emitui/canvas_pattern.cla
```

Expected: a diagnostic on the `w.C.pattern(4)` line (unknown canvas method), non-zero exit.

- [ ] **Step 3: Add the checker signature**

In `clarusc/check.cla`, after the `fillCircle` block (~line 1016), matching its shape exactly:

```
    sigStart()
    sigAdd(psPlain(IntT))
    canvasMethods["pattern"] = sigEnd(-1)
```

- [ ] **Step 4: Add the intrinsic id**

In `clarusc/ir.cla`, after `IUiCanvasFillCircle` (~line 2079):

```
func IUiCanvasPattern(): int {
    return intern("ui_canvas_pattern")
}
```

- [ ] **Step 5: Lower the method**

In `clarusc/lower.cla`, in `lowCanvasMethod`'s dispatch chain, after the `fillCircle` branch (~line 795):

```
    } else if nm == "pattern" {
        intrName = IUiCanvasPattern()
```

- [ ] **Step 6: Emit the C call**

In `clarusc/cprint.cla`, in the canvas emission chain after the `IUiCanvasFillCircle` branch (~line 978):

```
    } else if nm == IUiCanvasPattern() {
        fpEmit("rt_ui_canvas_pattern(" + fpExpr(a0) + ", " + fpExpr(a1) + ", " + fpExpr(fpArgAt(a0, 2)) + ");")
        return toText("")
```

- [ ] **Step 7: Verify the fixture now checks and generate its golden**

```sh
go run ./cmd/clarus build -o /tmp/clarusc-dev clarusc/main.cla
/tmp/clarusc-dev check testdata/emitui/canvas_pattern.cla   # expect: silent, exit 0
/tmp/clarusc-dev emit -o testdata/emitui/canvas_pattern.c.golden testdata/emitui/canvas_pattern.cla
grep rt_ui_canvas_pattern testdata/emitui/canvas_pattern.c.golden
```

Expected: the grep shows exactly one call of the form `rt_ui_canvas_pattern(<inst expr>, 0, 4);`.

- [ ] **Step 8: Run the emitui gate**

```sh
go test ./internal/emitui -run TestEmitUiGoldens -v
```

Expected: PASS, including the new `canvas_pattern` subtest (byte-compare + m68k compile of the golden against Task 1's rt_ui.h).

- [ ] **Step 9: Regenerate the bootstrap snapshot**

clarusc source changed, so the committed `clarusc/clarusc.c` is stale:

```sh
go run ./cmd/clarus build -o /tmp/clarusc clarusc/main.cla
/tmp/clarusc emit -o clarusc/clarusc.c clarusc/main.cla
```

- [ ] **Step 10: Document `pattern` in the reference (untagged fence + prose ONLY)**

In `docs/clarus-language-reference.md`, Chapter 11 §Canvas Drawing Methods: inside the existing **untagged** method-list fence, add one line after `c.drawText(x, y: int, s: string)`:

```
c.pattern(level: int)          // fill pattern for fillRect/fillCircle
```

Then append to the paragraph below the fence (the one ending "...current size in pixels."), as a new paragraph:

> `pattern` sets the canvas's current fill pattern: `level` runs 0 (white) through 8 (black), with 1–7 ordered-dither grays of increasing density; out-of-range values clamp. The pattern applies to `fillRect` and `fillCircle` only — `rect`, `circle`, `line`, `drawText`, and `clear` are unaffected. Each canvas starts at level 8 (black), and the setting persists until changed. Patterns align to the window, not to the filled rectangle, so adjacent fills of any size tile into one seamless dither.

Do NOT add any ```` ```rust ```` fence (Global Constraints — fence differential).

- [ ] **Step 11: Full ungated suite**

```sh
go test ./...
```

Expected: PASS — in particular `TestSnapshotCurrent`, `TestBootstrapFixedPoint`, `TestDifferential*`, `TestCheckCleanFences`, and emitui.

- [ ] **Step 12: Commit**

```sh
git add clarusc/check.cla clarusc/ir.cla clarusc/lower.cla clarusc/cprint.cla \
    clarusc/clarusc.c testdata/emitui/canvas_pattern.cla \
    testdata/emitui/canvas_pattern.c.golden docs/clarus-language-reference.md
git commit -m "clarusc+reference: canvas pattern(level) -- dithered fill levels 0-8"
```

---

### Task 3: Gated UI scenario for `pattern`

**Files:**
- Create: `testdata/ui/pattern.cla`
- Create: `testdata/ui/pattern.events`
- Create (blessed): `testdata/ui/pattern.trace`, `testdata/uisnaps/pattern.S1.pbm`
- Modify: `internal/mactest/ui_test.go` (one test func, after `TestCanvasUIScenario` ~line 195)

**Interfaces:**
- Consumes: `c.pattern(level: int)` from Task 2 (via the regenerated snapshot — `scripts/build-mac.sh` builds with `clarusc/clarusc.c`).
- Produces: nothing downstream; this is the feature's pinned visual gate.

- [ ] **Step 1: Write the scenario**

Create `testdata/ui/pattern.cla`:

```
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// pattern.cla: gated UI scenario for the canvas `pattern` method (Ch11).
// One buffered canvas, painted once from `opened`: the nine dither levels
// as a swatch row (0..8, white -> black), two clamp swatches (-3 -> 0,
// 99 -> 8), a mid-gray fillCircle (FillOval path), and a black `rect`
// outline proving frames ignore the fill pattern. pattern.events snaps S1
// after one tick (buffered blit happens on the run-loop iteration) and
// quits; the S1 PBM golden IS the visual proof of the dither ramp.

window Pal {
    title: "Patterns"
    size: 460, 140

    canvas Board { at: 0, 0; fill: both; buffered }
}

on App.launch {
    open Pal
}

extend Pal {
    on opened {
        var lvl: int
        lvl = 0
        while lvl <= 8 {
            Board.pattern(lvl)
            Board.fillRect(6 + lvl * 48, 6, 40, 40)
            lvl = lvl + 1
        }
        Board.pattern(-3)
        Board.fillRect(6, 56, 40, 40)
        Board.pattern(99)
        Board.fillRect(54, 56, 40, 40)
        Board.pattern(4)
        Board.fillCircle(140, 76, 20)
        Board.rect(170, 56, 40, 40)
    }
}
```

- [ ] **Step 2: Write the events script**

Create `testdata/ui/pattern.events`:

```
tick 1
snap S1
quit
```

- [ ] **Step 3: Add the Go test**

In `internal/mactest/ui_test.go`, after `TestCanvasUIScenario`:

```go
// TestPatternUIScenario: the canvas `pattern` method (Ch11) -- one snap
// showing the 9-level dither ramp, clamped out-of-range levels, the
// FillOval path, and a frame op unaffected by the fill pattern.
func TestPatternUIScenario(t *testing.T) {
	runUIScenario(t, "pattern", 0)
}
```

- [ ] **Step 4: Bless the goldens**

```sh
CLARUS_MAC_TESTS=1 CLARUS_MAC_BLESS=1 go test ./internal/mactest -run TestPatternUIScenario -v
```

Expected: PASS (writes `testdata/ui/pattern.trace` and `testdata/uisnaps/pattern.S1.pbm`; snap size 21888 asserted while blessing).

- [ ] **Step 5: Eyeball the blessed snap**

Open/read `testdata/uisnaps/pattern.S1.pbm` (it is a viewable PBM image). Verify: nine swatches left-to-right strictly lightest→darkest, first clamp swatch pure white (invisible against the canvas except by position), second pure black, circle mid-gray, rectangle a black outline. If the ramp is not monotonic or a swatch repeats, fix `rt_ui_gray_pats` in Task 1's table and re-bless.

- [ ] **Step 6: Verify the golden compare passes (no bless)**

```sh
CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestPatternUIScenario -v
```

Expected: PASS byte-exact.

- [ ] **Step 7: Commit**

```sh
git add testdata/ui/pattern.cla testdata/ui/pattern.events testdata/ui/pattern.trace \
    testdata/uisnaps/pattern.S1.pbm internal/mactest/ui_test.go
git commit -m "mactest: gated pattern scenario -- dither ramp, clamping, FillOval, frame ops"
```

---

### Task 4: The Mandelbrot app + smoke scenario

**Files:**
- Create: `examples/mandelbrot.cla`
- Create: `testdata/ui/smoke_mandel.events`
- Create (blessed): `testdata/ui/smoke_mandel.trace`, `testdata/uisnaps/smoke_mandel.{S1,S2,S3}.pbm`
- Modify: `internal/mactest/ui_test.go` (one test func, after `TestSmokeMenuDemoUIScenario`)

**Interfaces:**
- Consumes: `c.pattern(level: int)`; `runUIScenarioSrc(t, scenario, claRel, wantExit)` from `internal/mactest/ui_test.go:102`.
- Produces: the shippable sample app (double-clickable via `scripts/build-mac.sh Mandelbrot examples/mandelbrot.cla`).

- [ ] **Step 1: Write the app**

Create `examples/mandelbrot.cla`:

```
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// mandelbrot.cla: progressive Mandelbrot renderer -- the acceptance app
// for the canvas `pattern` method (Ch11), and a worked example of the
// budget-limited `every` pattern for long computations that must keep the
// UI responsive (no code runs outside a handler or timer, so the render
// is sliced into BUDGET-sample chunks, one chunk per tick).
//
// Rendering: successive-refinement grid passes. Pass 1 samples every 16th
// pixel and fills 16x16 blocks (a rough full-screen image in seconds on a
// Mac Plus); then 8, 4, 2, 1. Passes after the first skip points already
// sampled by a coarser pass -- the coarse block already shows exactly
// that sample's pattern, so the skip saves both the compute AND the draw.
//
// Escape-time coloring: escape at iteration i -> dither level min(i-1, 7)
// (fast escape = white, slow = dark halo); never escaped in 32 -> 8
// (black interior). All math is 16.16 fixed (Ch3): view fits the full set
// to the canvas height (y in [-1.25, 1.25], x centered on -0.75).
//
// 504x298 is the largest clean window on the 512x342 Mac Plus screen:
// the runtime centers windows with top = 44 (512 wide would clamp to
// left = 4 and hang off the right edge).
//
// File menu: New (reopens the window if closed -- closing does not quit
// -- or restarts the render if open), Quit.

const BUDGET: int = 16
const MAXITER: int = 32

window Fractal {
    title: "Mandelbrot"
    size: 504, 298

    canvas Plot { at: 0, 0; fill: both; buffered }

    var step: int
    var px: int
    var py: int
    var done: bool
    var x0: fixed
    var y0: fixed
    var d: fixed
}

menu File {
    item New  "New"  key "N"
    separator
    item Quit "Quit" key "Q"
}

on App.launch {
    open Fractal
}

extend Fractal {
    on opened {
        resetFractal(window)
    }
}

extend File {
    on New.select {
        var f: Fractal = Fractal.front
        if f == nil {
            open Fractal
        } else {
            resetFractal(f)
        }
    }
    on Quit.select {
        quit
    }
}

every 1 ticks {
    var f: Fractal = Fractal.front
    if f != nil and not f.done {
        renderChunk(f)
    }
}

// resetFractal (re)starts the render: pass cursor to the top-left of the
// 16px pass, view scale fit to the canvas's current height.
func resetFractal(f: Fractal) {
    f.step = 16
    f.px = 0
    f.py = 0
    f.done = false
    f.d = 2.5 / fixed(f.Plot.height)
    f.y0 = -1.25
    f.x0 = -0.75 - fixed(f.Plot.width / 2) * f.d
    f.Plot.clear()
}

// mandelLevel: dither level 0..8 for the point c = (cx, cy).
func mandelLevel(cx: fixed, cy: fixed): int {
    var zx: fixed
    var zy: fixed
    var xx: fixed
    var yy: fixed
    var i: int

    zx = 0.0
    zy = 0.0
    i = 1
    while i <= MAXITER {
        xx = zx * zx
        yy = zy * zy
        if xx + yy > 4.0 {
            if i > 8 {
                return 7
            }
            return i - 1
        }
        zy = zx * zy + zx * zy + cy
        zx = xx - yy + cx
        i = i + 1
    }
    return 8
}

// renderChunk computes and draws up to BUDGET samples, then returns so
// the event loop stays responsive. Skipped (already-sampled) points cost
// no budget.
func renderChunk(f: Fractal) {
    var n: int
    var lvl: int
    var w: int
    var h: int
    var cx: fixed
    var cy: fixed

    n = 0
    while n < BUDGET {
        if f.done {
            return
        }
        if f.step < 16 and f.px mod (f.step * 2) == 0 and f.py mod (f.step * 2) == 0 {
            // sampled by a coarser pass; block already painted correctly
        } else {
            cx = f.x0 + fixed(f.px) * f.d
            cy = f.y0 + fixed(f.py) * f.d
            lvl = mandelLevel(cx, cy)
            w = f.step
            h = f.step
            if f.px + w > f.Plot.width {
                w = f.Plot.width - f.px
            }
            if f.py + h > f.Plot.height {
                h = f.Plot.height - f.py
            }
            f.Plot.pattern(lvl)
            f.Plot.fillRect(f.px, f.py, w, h)
            n = n + 1
        }
        advance(f)
    }
}

// advance moves the pass cursor one sample; at the end of a pass, halves
// the step, and after the 1px pass sets done.
func advance(f: Fractal) {
    f.px = f.px + f.step
    if f.px >= f.Plot.width {
        f.px = 0
        f.py = f.py + f.step
        if f.py >= f.Plot.height {
            f.py = 0
            if f.step == 1 {
                f.done = true
            } else {
                f.step = f.step / 2
            }
        }
    }
}
```

- [ ] **Step 2: Check and build it**

```sh
scripts/build-mac.sh Mandelbrot examples/mandelbrot.cla
```

Expected: builds `build-mac/Mandelbrot/Mandelbrot.{bin,APPL,dsk}` with no diagnostics. (This uses the regenerated snapshot from Task 2.)

- [ ] **Step 3: Write the smoke events script**

Create `testdata/ui/smoke_mandel.events` — 10 ticks (160 samples: five rough 16px rows visible), snap; 30 more ticks (pass 1 done at 38 ticks, well into pass 2), snap; File→New (menu 2 item 1) resets and clears; 3 ticks (48 fresh coarse samples); snap; File→Quit (menu 2 item 3; the separator is item 2):

```
tick 1
tick 1
tick 1
tick 1
tick 1
tick 1
tick 1
tick 1
tick 1
tick 1
snap S1
tick 1
tick 1
tick 1
tick 1
tick 1
tick 1
tick 1
tick 1
tick 1
tick 1
tick 1
tick 1
tick 1
tick 1
tick 1
tick 1
tick 1
tick 1
tick 1
tick 1
tick 1
tick 1
tick 1
tick 1
tick 1
tick 1
tick 1
tick 1
tick 1
tick 1
snap S2
menu 2 1
tick 1
tick 1
tick 1
snap S3
menu 2 3
```

- [ ] **Step 4: Add the Go test**

In `internal/mactest/ui_test.go`, after `TestSmokeMenuDemoUIScenario`:

```go
// TestSmokeMandelUIScenario builds examples/mandelbrot.cla ITSELF (the
// canvas-pattern acceptance app) and scripts its progressive render: S1
// after 10 ticks (a rough 16px band), S2 after 40 (first pass complete,
// second underway) -- must differ (refinement actually progressed); then
// File > New resets, S3 after 3 more ticks must differ from S2 (the New
// clear + fresh coarse samples), and File > Quit exits 0. Fixed-point
// math plus the constant per-tick budget makes all three snaps
// deterministic.
func TestSmokeMandelUIScenario(t *testing.T) {
	snaps := runUIScenarioSrc(t, "smoke_mandel", filepath.Join("..", "..", "examples", "mandelbrot.cla"), 0)
	byName := map[string][]byte{}
	for _, s := range snaps {
		byName[s.name] = s.bytes
	}
	if byName["S1"] == nil || byName["S2"] == nil || byName["S3"] == nil {
		t.Fatalf("smoke_mandel: expected snaps S1, S2, S3; got %d snap(s)", len(snaps))
	}
	if bytes.Equal(byName["S1"], byName["S2"]) {
		t.Fatalf("smoke_mandel: S1 == S2 -- the render did not progress between snaps")
	}
	if bytes.Equal(byName["S2"], byName["S3"]) {
		t.Fatalf("smoke_mandel: S2 == S3 -- File > New did not restart the render")
	}
}
```

- [ ] **Step 5: Bless and eyeball**

```sh
CLARUS_MAC_TESTS=1 CLARUS_MAC_BLESS=1 go test ./internal/mactest -run TestSmokeMandelUIScenario -v
```

Expected: PASS. Then view the three PBMs under `testdata/uisnaps/`: S1 a coarse gray-banded band across the top ~80px of the canvas; S2 the full rough fractal (the classic cardioid-and-bulb silhouette in black, dithered halo around it); S3 mostly white with one fresh coarse band. If S2 shows no recognizable Mandelbrot silhouette, debug the fixed-point math (most likely suspect: the `2*zx*zy` term or the x0 centering) before re-blessing.

- [ ] **Step 6: Verify byte-exact (no bless), and run the full gated + ungated suites**

```sh
CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestSmokeMandelUIScenario -v
CLARUS_MAC_TESTS=1 go test ./internal/mactest
go test ./...
```

Expected: all PASS.

- [ ] **Step 7: Commit**

```sh
git add examples/mandelbrot.cla testdata/ui/smoke_mandel.events testdata/ui/smoke_mandel.trace \
    testdata/uisnaps/smoke_mandel.S1.pbm testdata/uisnaps/smoke_mandel.S2.pbm \
    testdata/uisnaps/smoke_mandel.S3.pbm internal/mactest/ui_test.go
git commit -m "examples: mandelbrot -- progressive dithered renderer, the pattern acceptance app"
```

---

## Final verification (whole branch)

- [ ] `go test ./...` green.
- [ ] `CLARUS_MAC_TESTS=1 go test ./internal/mactest` green (all scenarios, not just the new ones).
- [ ] Manual run for the human: `scripts/build-mac.sh Mandelbrot examples/mandelbrot.cla && toolchain/bin/LaunchAPPL -e minivmac build-mac/Mandelbrot/Mandelbrot.bin` (background; blocks until quit) — watch the fractal refine, File→New, close box then File→New, File→Quit.
- [ ] Whole-branch review (superpowers:requesting-code-review); merge only on request.
