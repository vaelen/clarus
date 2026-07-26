# Window Zoom + Horizontal Scrolling Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Resizable Clarus windows get a zoom (maximize) box and a visible grow icon; `scrollbar: both` on a `textview` becomes real no-wrap horizontal scrolling; the Text Editor example demonstrates both.

**Architecture:** All changes are Mac-runtime-side (`runtime/mac/rt_ui.{h,c}`) plus docs/example flips — clarusc already lowers `scrollbar: both` to `RTUI_SCROLL_V | RTUI_SCROLL_H` and already emits the window `resizable` flag, so **no compiler changes anywhere**. Zoom routes through the existing `rt_ui_apply_resize` funnel; the horizontal bar is a second Control Manager scrollbar in a new parallel `hbars` array, distinguished from the vertical bar by a refCon bit.

**Tech Stack:** Classic Toolbox C (Retro68 m68k), Clarus scenario files, Go test harness (`internal/mactest`).

Spec: `docs/superpowers/specs/2026-07-26-window-zoom-hscroll-design.md`.

## Global Constraints

- The Go compiler (`cmd/clarus`, `internal/`) is FROZEN. Do not touch it. No clarusc (`clarusc/*.cla`) changes are needed either — if you think you need one, stop and report instead.
- `.cla` files are MacRoman-encoded; all new scenario content in this plan is pure ASCII, so no transcoding steps are needed. Do not paste non-ASCII characters into `.cla` files.
- Gated Mac tests: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run <Name> -v` (needs `toolchain/` + `macplus/` symlinks, present in this checkout). Blessing goldens: additionally set `CLARUS_MAC_BLESS=1` (any non-empty value). LaunchAPPL runs block for up to ~1-3 min per scenario.
- Host suite must stay green: `go build -o clarus ./cmd/clarus && go test ./...`.
- Branch: `window-zoom-hscroll` (already created). Commit at the end of every task.
- Existing UI goldens (`testdata/ui/*.trace`, `testdata/uisnaps/*.pbm`) other than the ones a task explicitly blesses MUST NOT change. If a task's change makes an existing golden fail, that is a regression to fix, not a golden to rebless — the sole exception is `texteditor.roundtrip.pbm` in Task 3, whose change is the point of the task.
- C style: match rt_ui.c exactly — K&R-ish Toolbox C, declarations at block top, `(short)`/`(Boolean)` casts as in surrounding code, comments explaining constraints not narration.

## Reference: facts about rt_ui.c you will need (verified 2026-07-26)

- `rt_ui.c` is ~3387 lines; `rt_ui.h` ~295. Line numbers below drift as you edit — they're orientation, not gospel.
- Constants: `RTUI_MENUBAR_H 20`, `RTUI_TITLEBAR_H 19`, `RTUI_SCREEN_MARGIN 2` (rt_ui.c:130-143); `RTUI_TE_FRAME_INSET 3`, `RTUI_SCROLLBAR_W 15` (rt_ui.c:191-193); `RTUI_GAP 8`.
- Widget flags: `RTUI_SCROLL_V 8`, `RTUI_SCROLL_H 16` (rt_ui.h:59-66) — H is currently a documented no-op.
- `rt_ui_winst` struct at rt_ui.c:319-355. `ctrls[i]` is a single ControlHandle slot per widget; a textview's vertical scrollbar lives there, tagged via `contrlRfCon = 0x8000 | i` (ordinary widgets use plain `i`). Arrays are allocated in `rt_ui_open` (rt_ui.c:2845-2851) via `rt_ui_alloc_locked` and disposed in `rt_ui_close` — mirror the `ctrlsH`/`ctrls` lines exactly for any new array.
- `rt_ui_make_widgets` (rt_ui.c:710): TEXTVIEW case at :755-770 creates the TE (`TENew`) and, when `RTUI_SCROLL_V`, the vertical scrollbar via `NewControl(..., scrollBarProc, 0L)` with a zero placeholder rect.
- `rt_ui_te_relayout` (rt_ui.c:890-916): computes the scrollbar rect + TE view/dest rects from `inst->rects[i]`; lane reservation and wrap width (`destRect.right`) live HERE and nowhere else; ends with `TECalText` + `rt_ui_te_scroll_sync`. Its caller `rt_ui_layout` brackets with GetPort/SetPort — do not add port fiddling inside relayout.
- `rt_ui_te_scroll_sync` (rt_ui.c:807-828): sets vertical control max from `nLines*lineHeight - viewH` and clamps. Called from `rt_ui_te_mutated` (:875, the single content-mutation funnel) and relayout (:915).
- `rt_ui_scrollbar_action` (rt_ui.c:959-995): TrackControl action proc; decodes `wIdx = rfCon & 0x7FFF`; arrows step `±lineHeight`, pages `±viewH`; applies `TEScroll(0, oldVal - newVal, te)`.
- `rt_ui_handle_scrollbar_click` (rt_ui.c:999-1026): scripted branch (one discrete `rt_ui_scrollbar_action` nudge per arrow/page click; thumb no-op), real branch (TrackControl + thumb TEScroll).
- Scrollbar click dispatch: `rt_ui_handle_content_click` (rt_ui.c:1843), fork at :1847-1861 on `rfCon & 0x8000L`.
- `rt_ui_apply_resize` (rt_ui.c:1738-1748): SizeWindow → layout → canvas realloc → `T FIRE <Win>.resized` trace → `winEvent(RTUI_EV_RESIZED)`. `rt_ui_handle_grow` (:1750-1786) feeds it; scripted `resize W H` (`rt_ui_script_resize`, :2590) feeds it too.
- Mouse switch `rt_ui_handle_mouse_down` (rt_ui.c:1908-1947): cases inGoAway/inDrag/inGrow/inContent/inMenuBar. **No inZoomIn/inZoomOut cases exist.**
- Window creation (rt_ui.c:2892-2893): `NewWindow(..., d->resizable ? documentProc : noGrowDocProc, ...)` after open-time position/size clamping (:2860-2888). No `DrawGrowIcon` anywhere — resizable windows currently have an invisible grow box.
- Update handler draws widgets then `DrawControls(wp)` at rt_ui.c:1654; textview frame is `FrameRect` of viewRect un-inset by 3 (:1671-1673).
- Script harness (`RT_MAC_TEST` block from rt_ui.c:2399): verbs parsed in `rt_ui_run_scripted` (:2692) via `sscanf("%31s %63s %63s")`; each verb ends with `rt_ui_pump_passive()`. Unknown verbs are SILENTLY ignored — typos pass green, so double-check verb spelling in .events files. End of script = implicit quit.
- Trace formats: `T OPEN/CLOSE/FRONT <Type> <n>`, `T FIRE <Type>.<event>`, `T FIRE <Type>.<Widget>.<event>`, `T SET ...`. Snaps: `snap NAME` verb hex-dumps the 512×342 screen between `##CLARUS-SNAP##` sentinels; goldens are `testdata/uisnaps/<scenario>.<NAME>.pbm` (P4, 22 KB).
- Go harness: `internal/mactest/ui_test.go`. Scenarios are hand-registered test funcs calling `runUIScenario(t, "<name>", 0)` (source defaults to `testdata/ui/<name>.cla`, events `<name>.events`, trace golden `<name>.trace`). Bless writes trace (:112-115) and PBMs (:134-139). See `TestCanvasUIScenario` (~:208-228) for the snap-inequality assertion idiom (`canvas` asserts S1 ≠ S2) — clone its exact helper usage for new tests.

---

### Task 1: Zoom box + visible grow icon (runtime) with `zoomwin` scenario

**Files:**
- Modify: `runtime/mac/rt_ui.c` (window proc, mouse switch, new zoom functions, apply_resize inval, update-handler grow icon, script verb)
- Create: `testdata/ui/zoomwin.cla`, `testdata/ui/zoomwin.events`, `testdata/ui/zoomwin.trace`
- Create (blessed): `testdata/uisnaps/zoomwin.S1.pbm`, `zoomwin.S2.pbm`, `zoomwin.S3.pbm`
- Modify: `internal/mactest/ui_test.go` (new test func)

**Interfaces:**
- Consumes: `rt_ui_apply_resize(WindowPtr, rt_ui_winst*, short newW, short newH)` (existing, unchanged signature).
- Produces: `static void rt_ui_apply_zoom(WindowPtr wp, rt_ui_winst *inst, short part)` — shared by the mouse path and the script verb; script verb `zoom` (no args, toggles). Task 2 does not depend on this task's code, only on the harness precedent.

- [ ] **Step 1: Write the scenario (test-first)**

`testdata/ui/zoomwin.cla`:

```
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// zoomwin.cla: gated UI scenario (window-zoom-hscroll Task 1) -- zoom box
// end to end: snap the 300x200 window (S1), `zoom` out to the standard
// state (full screen minus menu bar; fires `resized`, S2), `zoom` back in
// (ZoomWindow restores the saved userState; fires `resized` again, S3).
// The Go test asserts S2 differs from S1 and S3 is byte-identical to S1
// (geometry round-trips), on top of the golden compares.

window Panel {
    title: "Zoom"
    size: 300, 200
    resizable: min(200, 120)

    textview Body { at: 10, 10; fill: both; scrollbar: vertical }
}

on App.launch {
    open Panel
}
```

`testdata/ui/zoomwin.events`:

```
snap S1
zoom
snap S2
zoom
snap S3
close
```

`testdata/ui/zoomwin.trace` (hand-written expectation — two resized fires):

```
T OPEN Panel 1
T FRONT Panel 1
T FIRE Panel.resized
T FIRE Panel.resized
T FIRE Panel.closeRequest
T CLOSE Panel 1
T FIRE Panel.closed
```

- [ ] **Step 2: Register the Go test**

In `internal/mactest/ui_test.go`, clone `TestCanvasUIScenario`'s structure (its golden compare + snap-inequality assertions, ~line 208) into:

```go
func TestZoomwinUIScenario(t *testing.T) {
	// zoom out must change the screen; zoom back in must restore it exactly
	out := runUIScenario(t, "zoomwin", 0)
	s1, s2, s3 := out.snap(t, "S1"), out.snap(t, "S2"), out.snap(t, "S3")
	if bytes.Equal(s1, s2) {
		t.Fatalf("zoom out changed nothing (S1 == S2)")
	}
	if !bytes.Equal(s1, s3) {
		t.Fatalf("zoom in did not restore the original geometry (S1 != S3)")
	}
}
```

Adapt the snap-access lines to whatever accessor `TestCanvasUIScenario` actually uses (read it first — the helper's return shape is the source of truth; the assertions above are the requirement).

- [ ] **Step 3: Run to verify it fails**

Run: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestZoomwinUIScenario -v`
Expected: FAIL — `zoom` is an unknown verb (silently skipped), so the trace lacks both `T FIRE Panel.resized` lines (trace mismatch) and S1 == S2.

- [ ] **Step 4: Implement zoom in rt_ui.c**

4a. Window proc (rt_ui.c:2892-2893): `documentProc` → `zoomDocProc`:

```c
    inst->wp = NewWindow(NULL, &bounds, d->title, (Boolean)0,
                          d->resizable ? zoomDocProc : noGrowDocProc,
                          (WindowPtr)-1L, (Boolean)1, 0L);
```

4b. New functions, placed next to `rt_ui_handle_grow` (~:1750):

```c
/* Zoom shares rt_ui_apply_resize's post-size funnel. stdState is refreshed
   before every zoom-out: the full screen minus menu bar (same constants as
   the open-time clamp), so zoom can never put the title bar off-screen.
   ZoomWindow itself saves the current rect into userState on inZoomOut and
   restores it on inZoomIn. */
static void rt_ui_apply_zoom(WindowPtr wp, rt_ui_winst *inst, short part)
{
    GrafPtr save;

    if (part == inZoomOut) {
        WStateData **ws;
        Rect std;
        short screenW, screenH;

        screenW = (short)(qd.screenBits.bounds.right - qd.screenBits.bounds.left);
        screenH = (short)(qd.screenBits.bounds.bottom - qd.screenBits.bounds.top);
        SetRect(&std, 4, RTUI_MENUBAR_H + RTUI_TITLEBAR_H,
                (short)(screenW - RTUI_SCREEN_MARGIN),
                (short)(screenH - RTUI_SCREEN_MARGIN));
        ws = (WStateData **)((WindowPeek)wp)->dataHandle;
        if (ws) (*ws)->stdState = std;
    }
    GetPort(&save);
    SetPort(wp);
    EraseRect(&wp->portRect); /* classic pre-ZoomWindow erase: avoids the old content flashing inside the new frame */
    ZoomWindow(wp, part, (Boolean)(wp == FrontWindow()));
    InvalRect(&wp->portRect);
    SetPort(save);
    rt_ui_apply_resize(wp, inst,
                       (short)(wp->portRect.right - wp->portRect.left),
                       (short)(wp->portRect.bottom - wp->portRect.top));
}

static void rt_ui_handle_zoom(WindowPtr wp, rt_ui_winst *inst, Point where, short part)
{
    if (!inst->desc->resizable) return; /* can't happen (no zoom box without zoomDocProc); cheap symmetry with handle_grow */
    if (!TrackBox(wp, where, part)) return;
    rt_ui_apply_zoom(wp, inst, part);
}
```

4c. Mouse switch (rt_ui.c:1930, after the `inGrow` case):

```c
    case inZoomIn:
    case inZoomOut:
        inst = rt_ui_winst_of(wp);
        if (inst) rt_ui_handle_zoom(wp, inst, ev->where, part);
        break;
```

4d. Grow-corner invalidation so the grow icon redraws at its new home. New helper next to `rt_ui_apply_resize`, and call it around `SizeWindow` (rt_ui.c:1738-1748). Note `rt_ui_apply_resize` currently touches no port; InvalRect needs one:

```c
static void rt_ui_inval_grow_corner(WindowPtr wp)
{
    Rect r;

    r = wp->portRect;
    r.left = (short)(r.right - RTUI_SCROLLBAR_W);
    r.top = (short)(r.bottom - RTUI_SCROLLBAR_W);
    InvalRect(&r);
}

static void rt_ui_apply_resize(WindowPtr wp, rt_ui_winst *inst, short newW, short newH)
{
    GrafPtr save;

    GetPort(&save);
    SetPort(wp);
    rt_ui_inval_grow_corner(wp); /* old corner: erase the stale grow icon */
    SizeWindow(wp, newW, newH, (Boolean)1);
    rt_ui_inval_grow_corner(wp); /* new corner */
    SetPort(save);
    rt_ui_layout(inst);
    rt_ui_canvas_realloc_all(inst); /* buffered canvas sizes may have tracked the resize (fill: both) */
#ifdef RT_MAC_TEST
    rt_ui_trace_fire1(inst->desc->name, "resized");
#endif
    if (inst->desc->handlers && inst->desc->handlers->winEvent)
        inst->desc->handlers->winEvent(inst, RTUI_EV_RESIZED, 0, 0);
}
```

4e. Draw the grow icon: in the update handler, immediately after `DrawControls(wp)` (rt_ui.c:1654). DrawGrowIcon also draws full-height/width scrollbar-lane outlines along the window edges; our widgets are inset from the edges, so clip to the 15×15 corner:

```c
    if (inst->desc->resizable) {
        Rect corner;
        RgnHandle saveClip;

        corner = wp->portRect;
        corner.left = (short)(corner.right - RTUI_SCROLLBAR_W);
        corner.top = (short)(corner.bottom - RTUI_SCROLLBAR_W);
        saveClip = NewRgn();
        GetClip(saveClip);
        ClipRect(&corner); /* corner only: widgets are inset from the window edge, the full-edge lane lines would cut through them */
        DrawGrowIcon(wp);
        SetClip(saveClip);
        DisposeRgn(saveClip);
    }
```

4f. Script verb. Handler next to `rt_ui_script_resize` (~:2590); direction is chosen by comparing the current global content rect against the would-be standard state:

```c
/* `zoom`: real zooming is interactive (TrackBox blocks on a real mouse);
   a script toggles directly. Direction: if the window already occupies the
   standard state, zoom back in; otherwise zoom out. */
static void rt_ui_script_zoom(void)
{
    WindowPtr wp;
    rt_ui_winst *inst;
    Rect content, std;
    short screenW, screenH, part;

    wp = FrontWindow();
    if (!wp) return;
    inst = rt_ui_winst_of(wp);
    if (!inst || !inst->desc->resizable) return;
    screenW = (short)(qd.screenBits.bounds.right - qd.screenBits.bounds.left);
    screenH = (short)(qd.screenBits.bounds.bottom - qd.screenBits.bounds.top);
    SetRect(&std, 4, RTUI_MENUBAR_H + RTUI_TITLEBAR_H,
            (short)(screenW - RTUI_SCREEN_MARGIN),
            (short)(screenH - RTUI_SCREEN_MARGIN));
    content = (*((WindowPeek)wp)->contRgn)->rgnBBox;
    part = EqualRect(&content, &std) ? inZoomIn : inZoomOut;
    rt_ui_apply_zoom(wp, inst, part);
}
```

Dispatch entry in `rt_ui_run_scripted`, next to the `resize` arm (~:2732):

```c
        } else if (strcmp(verb, "zoom") == 0) {
            rt_ui_script_zoom();
```

- [ ] **Step 5: Bless snaps, verify trace unchanged, then run clean**

Run: `CLARUS_MAC_TESTS=1 CLARUS_MAC_BLESS=1 go test ./internal/mactest -run TestZoomwinUIScenario -v`
Then: `git diff testdata/ui/zoomwin.trace` — MUST be empty (the blessed trace matches the hand-written expectation from Step 1; any diff means the implementation or the expectation is wrong — investigate, do not just accept the blessed version).
Then rerun WITHOUT bless: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestZoomwinUIScenario -v`
Expected: PASS. Open the three PBMs (they're viewable) and eyeball: S1 small window with grow icon in its corner, S2 full-screen-minus-menu-bar, S3 identical to S1.

- [ ] **Step 6: Regression: existing gated UI scenarios + host suite**

Run: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestButtons|TestCanvas|TestTextwidgets' -v` (the resize/snap-sensitive ones; apply_resize changed, so `buttons` exercising `resize` must stay green with its existing golden)
Run: `go build -o clarus ./cmd/clarus && go test ./...`
Expected: all PASS, zero golden diffs outside the new zoomwin files.

- [ ] **Step 7: Commit**

```bash
git add runtime/mac/rt_ui.c testdata/ui/zoomwin.* testdata/uisnaps/zoomwin.*.pbm internal/mactest/ui_test.go
git commit -m "rt_ui: zoom box (zoomDocProc, inZoom, script zoom verb) + visible grow icon"
```

---

### Task 2: Horizontal textview scrollbar (`scrollbar: both` becomes real) with `hscroll` scenario

**Files:**
- Modify: `runtime/mac/rt_ui.h` (RTUI_SCROLL_H comment)
- Modify: `runtime/mac/rt_ui.c` (winst struct + alloc/dispose, make_widgets, te_relayout, te_scroll_sync, scrollbar action/click/dispatch refCon scheme, new constants)
- Create: `testdata/ui/hscroll.cla`, `testdata/ui/hscroll.events`, `testdata/ui/hscroll.trace`
- Create (blessed): `testdata/uisnaps/hscroll.S1.pbm`, `hscroll.S2.pbm`, `hscroll.S3.pbm`
- Modify: `internal/mactest/ui_test.go` (new test func)

**Interfaces:**
- Consumes: the `zoom`-era harness unchanged; `rt_ui_apply_resize` funnel from Task 1.
- Produces: refCon scheme change — textview vertical bar `0x8000|i`, horizontal bar `0xC000|i`, index mask now `0x3FFF` (was `0x7FFF`); `rt_ui_winst.hbars` parallel ControlHandle array; constants `RTUI_TE_NOWRAP_W 2000`, `RTUI_HSCROLL_STEP 8`. Task 3 relies on `scrollbar: both` rendering no-wrap + two bars.

- [ ] **Step 1: Write the scenario (test-first)**

`testdata/ui/hscroll.cla`:

```
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// hscroll.cla: gated UI scenario (window-zoom-hscroll Task 2) --
// `scrollbar: both` end to end: no-wrap (the long line set in `opened`
// stays on one line, clipped at the view's right edge -- under the old
// wrap behavior it would fold into several lines), a horizontal page-right
// via a scripted click in the bar's track (S1 vs S2), and a grow through
// the same relayout funnel with both bars present (S3).
//
// Coordinate math (mirrors buttons.cla's convention): 300x200 content
// opens centered-left at global (106, 44). Body fills from local (10,10)
// to (292,192) (8px RTUI_GAP). H bar spans local (10,177)-(277,192) (15px
// lane, right end stopped 15px short of the V bar's lane). A click at
// local (200,184) = global (306,228) lands in the H track right of the
// thumb -> one page-right nudge (scripted scrollbar clicks are discrete).

window HWin {
    title: "HScroll"
    size: 300, 200
    resizable: min(200, 120)

    textview Body { at: 10, 10; fill: both; scrollbar: both }
}

on App.launch {
    open HWin
}

extend HWin {
    on opened {
        Body.text = "The quick brown fox jumps over the lazy dog and keeps running well past the right edge of the view rectangle"
    }
}
```

`testdata/ui/hscroll.events`:

```
snap S1
click 306 228
snap S2
resize 340 220
snap S3
close
```

`testdata/ui/hscroll.trace` (hand-written expectation; programmatic `Body.text` set fires no change trace — userEdit=0 path):

```
T OPEN HWin 1
T FRONT HWin 1
T FIRE HWin.opened
T FIRE HWin.resized
T FIRE HWin.closeRequest
T CLOSE HWin 1
T FIRE HWin.closed
```

- [ ] **Step 2: Register the Go test**

Same cloning instructions as Task 1 Step 2 (read `TestCanvasUIScenario` for the actual helper shape):

```go
func TestHscrollUIScenario(t *testing.T) {
	// page-right must visibly shift the unwrapped line
	out := runUIScenario(t, "hscroll", 0)
	s1, s2 := out.snap(t, "S1"), out.snap(t, "S2")
	if bytes.Equal(s1, s2) {
		t.Fatalf("horizontal page-right changed nothing (S1 == S2)")
	}
}
```

- [ ] **Step 3: Run to verify it fails**

Run: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestHscrollUIScenario -v`
Expected: FAIL — no horizontal bar exists, the click at (306,228) falls through to the TE/window, S1 == S2. (The trace may also mismatch; either failure is the red state.)

- [ ] **Step 4: Implement in rt_ui.h/rt_ui.c**

4a. `rt_ui.h` (:59-66): replace the RTUI_SCROLL_H no-op comment:

```c
#define RTUI_SCROLL_V 8   /* textview: vertical scrollbar (mac-target-4c Task 1) */
#define RTUI_SCROLL_H 16  /* textview: horizontal scrollbar (window-zoom-hscroll Task 2).
                             Implies no word wrap: the TE is created crOnly (lines break
                             only at CR) with a fixed RTUI_TE_NOWRAP_W-wide destRect --
                             the wrap-off + wide-dest pair is the classic TE idiom, and
                             the fixed width doubles as the scroll range ceiling. */
```

4b. Constants (rt_ui.c, next to `RTUI_SCROLLBAR_W` ~:193):

```c
#define RTUI_TE_NOWRAP_W  2000 /* no-wrap destRect width == horizontal scroll ceiling; longest-line tracking rejected in the spec */
#define RTUI_HSCROLL_STEP 8    /* horizontal arrow nudge, roughly one character */
```

4c. `rt_ui_winst` (~:340, next to `teH`): add the parallel array, and update the struct's refCon comment to the new scheme:

```c
    Handle hbarsH; ControlHandle *hbars; /* nWidgets; textview horizontal scrollbar (RTUI_SCROLL_H) or NULL */
```

refCon scheme (update the comment above `teH` too): ordinary widget `i`; textview V bar `0x8000|i`; textview H bar `0xC000|i`; scrollbar test is `rfCon & 0x8000L`, horizontal test `rfCon & 0x4000L`, index mask `0x3FFF`.

Allocate in `rt_ui_open` by mirroring the `ctrlsH` line exactly (~:2845-2851), dispose in `rt_ui_close` by mirroring `ctrlsH`'s disposal. (The controls themselves die with `DisposeWindow`, same as the vertical bar.)

4d. `rt_ui_make_widgets` TEXTVIEW case (~:755-770): after `TENew`, add:

```c
            if (wd->flags & RTUI_SCROLL_H) {
                (*inst->tes[i])->crOnly = -1; /* no word wrap: lines break only at CR */
                inst->hbars[i] = NewControl(inst->wp, &placeholder, kEmptyPStr,
                                             (Boolean)1, 0, 0, 0, scrollBarProc, 0L);
                (*inst->hbars[i])->contrlRfCon = (long)(0xC000L | i);
            } else {
                inst->hbars[i] = NULL;
            }
```

(`hbars` is NewHandleClear'd so non-textview slots are already NULL; the explicit else keeps the textview case self-documenting.)

4e. `rt_ui_te_relayout` (~:890-916): replace the single-bar lane block with two lanes + notch, and the destRect assignment with the no-wrap width. The full replacement body between `teRect = box;` and `InsetRect`:

```c
    teRect = box;
    if (wd->kind == RTUI_TEXTVIEW) {
        Boolean hasV, hasH;

        hasV = inst->ctrls[i] != NULL;
        hasH = inst->hbars[i] != NULL;
        if (hasV) {
            /* stops RTUI_SCROLLBAR_W short of the bottom when an H bar
               shares the corner -- the standard grow-notch square */
            SetRect(&sbRect, (short)(box.right - RTUI_SCROLLBAR_W), box.top,
                    box.right, (short)(box.bottom - (hasH ? RTUI_SCROLLBAR_W : 0)));
            MoveControl(inst->ctrls[i], sbRect.left, sbRect.top);
            SizeControl(inst->ctrls[i], (short)(sbRect.right - sbRect.left),
                        (short)(sbRect.bottom - sbRect.top));
            teRect.right = (short)(teRect.right - RTUI_SCROLLBAR_W);
        }
        if (hasH) {
            SetRect(&sbRect, box.left, (short)(box.bottom - RTUI_SCROLLBAR_W),
                    (short)(box.right - (hasV ? RTUI_SCROLLBAR_W : 0)), box.bottom);
            MoveControl(inst->hbars[i], sbRect.left, sbRect.top);
            SizeControl(inst->hbars[i], (short)(sbRect.right - sbRect.left),
                        (short)(sbRect.bottom - sbRect.top));
            teRect.bottom = (short)(teRect.bottom - RTUI_SCROLLBAR_W);
        }
    }
```

and after the existing degenerate-rect clamps:

```c
    (*te)->viewRect = teRect;
    (*te)->destRect = teRect;
    if (wd->kind == RTUI_TEXTVIEW && inst->hbars[i])
        (*te)->destRect.right = (short)(teRect.left + RTUI_TE_NOWRAP_W);
    TECalText(te);
    rt_ui_te_scroll_sync(inst, i);
```

(Keep the FIELD label-offset line and the existing clamps untouched.)

4f. `rt_ui_te_scroll_sync` (~:807-828): rewrite to sync BOTH axes, and — deliberate semantics upgrade — set each control's value from the TE's *actual* view/dest offset instead of only clamping downward. Relayout resets destRect to the view origin, so after any resize the old code could leave a thumb pointing at a scroll position the TE no longer had; deriving value-from-offset makes the control truthful on every path. Existing vertical goldens are unaffected (in every blessed scenario the offset at sync time is 0, matching the old behavior — Step 6 proves it):

```c
static void rt_ui_te_scroll_sync(rt_ui_winst *inst, short wIdx)
{
    TEHandle te;
    ControlHandle sb, hb;
    short viewH, contentH, maxScroll, offset;

    te = inst->tes[wIdx];
    if (!te) return;
    sb = inst->ctrls[wIdx];
    hb = inst->hbars[wIdx];
    if (sb) {
        viewH = (short)((*te)->viewRect.bottom - (*te)->viewRect.top);
        contentH = (short)((*te)->nLines * (*te)->lineHeight);
        maxScroll = (short)(contentH - viewH);
        if (maxScroll < 0) maxScroll = 0;
        SetControlMaximum(sb, maxScroll);
        offset = (short)((*te)->viewRect.top - (*te)->destRect.top);
        if (offset > maxScroll) {
            TEScroll(0, (short)(offset - maxScroll), te); /* positive dv: content back down */
            offset = maxScroll;
        }
        SetControlValue(sb, offset);
    }
    if (hb) {
        short viewW, destW;

        viewW = (short)((*te)->viewRect.right - (*te)->viewRect.left);
        destW = (short)((*te)->destRect.right - (*te)->destRect.left);
        maxScroll = (short)(destW - viewW);
        if (maxScroll < 0) maxScroll = 0;
        SetControlMaximum(hb, maxScroll);
        offset = (short)((*te)->viewRect.left - (*te)->destRect.left);
        if (offset > maxScroll) {
            TEScroll((short)(offset - maxScroll), 0, te);
            offset = maxScroll;
        }
        SetControlValue(hb, offset);
    }
}
```

Note the guard change: the old code bailed when `!sb`; the new code must proceed when only `hb` exists (`scrollbar: both` always creates both today, but the code shouldn't depend on that).

4g. `rt_ui_scrollbar_action` (~:959-995): decode `horiz` from the refCon, mask the index with `0x3FFF`, branch the step table and the TEScroll axis:

```c
    long rfCon;
    Boolean horiz;
    ...
    rfCon = (*ctrl)->contrlRfCon;
    horiz = (rfCon & 0x4000L) != 0;
    wIdx = (short)(rfCon & 0x3FFFL);
    ...
    if (horiz) {
        short viewW;

        viewW = (short)((*te)->viewRect.right - (*te)->viewRect.left);
        switch (part) {
        case kControlUpButtonPart:   step = (short)-RTUI_HSCROLL_STEP; break; /* left arrow */
        case kControlDownButtonPart: step = RTUI_HSCROLL_STEP; break;         /* right arrow */
        case kControlPageUpPart:     step = (short)-viewW; break;
        case kControlPageDownPart:   step = viewW; break;
        default: return;
        }
    } else {
        /* existing vertical step table, verbatim */
    }
    ...
        if (applied == 0) return;
        SetControlValue(ctrl, newVal);
        if (horiz) TEScroll(applied, 0, te);
        else       TEScroll(0, applied, te);
```

4h. `rt_ui_handle_scrollbar_click` thumb branch (~:1012-1020): same axis branch:

```c
    if (cpart == kControlIndicatorPart) {
        short oldVal, newVal;
        Boolean horiz;

        horiz = ((*ctrl)->contrlRfCon & 0x4000L) != 0;
        oldVal = GetControlValue(ctrl);
        if (TrackControl(ctrl, where, NULL) != 0) {
            newVal = GetControlValue(ctrl);
            if (newVal != oldVal && inst->tes[wIdx]) {
                if (horiz) TEScroll((short)(oldVal - newVal), 0, inst->tes[wIdx]);
                else       TEScroll(0, (short)(oldVal - newVal), inst->tes[wIdx]);
            }
        }
    }
```

4i. Dispatch (~:1852): index mask `0x7FFF` → `0x3FFF` (the `rfCon & 0x8000L` scrollbar test already catches `0xC000`-tagged bars). Grep the file for `0x7FFF` to catch every decode site — there must be none left.

- [ ] **Step 5: Bless snaps, verify trace, run clean**

Run: `CLARUS_MAC_TESTS=1 CLARUS_MAC_BLESS=1 go test ./internal/mactest -run TestHscrollUIScenario -v`
Then `git diff testdata/ui/hscroll.trace` MUST be empty (same rule as Task 1 Step 5).
Rerun without bless → PASS. Eyeball the PBMs: S1 one clipped unwrapped line + both bars + corner notch; S2 line shifted left by one page; S3 bigger window, bars re-laid, grow icon in the window corner.

- [ ] **Step 6: Regression: ALL existing gated UI scenarios + host suite**

Run: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -v` (full gated suite — the sync-semantics change and refCon change touch every scrollbar path; every pre-existing golden must pass unchanged)
Run: `go build -o clarus ./cmd/clarus && go test ./...`
Expected: all PASS, `git status` shows no modified goldens beyond the new hscroll files.

- [ ] **Step 7: Commit**

```bash
git add runtime/mac/rt_ui.h runtime/mac/rt_ui.c testdata/ui/hscroll.* testdata/uisnaps/hscroll.*.pbm internal/mactest/ui_test.go
git commit -m "rt_ui: real horizontal textview scrollbar -- scrollbar: both = no-wrap + H bar"
```

---

### Task 3: Reference + Text Editor flip to `scrollbar: both`

**Files:**
- Modify: `docs/clarus-language-reference.md` (:839 resizable row, ~:844 zoom note, :890 resized row, :914 Mac note, :1483 Appendix C listing line)
- Modify: `testdata/valid/editor.cla` (:9), `examples/texteditor.cla` (:27)
- Modify (reblessed): `testdata/uisnaps/texteditor.roundtrip.pbm`

**Interfaces:**
- Consumes: Task 2's `scrollbar: both` runtime behavior.
- Produces: nothing downstream; this is the user-visible surface.

- [ ] **Step 1: Reference edits**

1a. Window-properties table row (:839):

```markdown
| `resizable` | `resizable` or `resizable: min(300, 200)` | grow box + zoom box + optional minimum |
```

1b. After the existing "Mac note — `size` on a small screen" paragraph (:844), add:

```markdown
**Mac note — zoom:** a resizable window's zoom box toggles it between its current size and position and a standard state — the full screen minus the menu bar, clamped to the screen the same way `size` is at open. Zooming (either direction) fires the window's `resized` event.
```

1c. `resized` event row (:890):

```markdown
| `resized` | `on resized { }` | The user resized or zoomed the window (resizable windows only). |
```

1d. Replace the `scrollbar: both` Mac note (:914) entirely:

```markdown
**Mac note — `scrollbar: both`:** `scrollbar: vertical` wraps text at the view's width (prose style). `scrollbar: both` turns word wrap off — lines break only at Return, long lines extend right (code and log style) — and adds a horizontal scrollbar. The horizontal scroll range is a fixed 2,000 pixels: text beyond that width is retained but cannot be scrolled into view.
```

1e. Appendix C Text Editor listing (:1483): `scrollbar: vertical` → `scrollbar: both` (preserve the two-space alignment: `fill: both;  scrollbar: both`). Leave the Chapter 8 examples at :864/:1483-context untouched apart from this one listing line — the Ch8 `Doc` examples showing `scrollbar: vertical` remain valid prose-style examples.

- [ ] **Step 2: Flip the two source copies (keeping all three copies identical where they overlap)**

- `testdata/valid/editor.cla:9` → `    textview Body { fill: both;  scrollbar: both }`
- `examples/texteditor.cla:27` → same line. Verify the verbatim invariant still holds:

Run: `diff <(grep -v '^app \|^    name:\|^    version:\|^    author:\|^    about:\|^    icon:\|^    id:\|^}' examples/texteditor.cla) testdata/valid/editor.cla || true` — don't script-golf this: the documented check is simply that `examples/texteditor.cla` is `editor.cla` plus the `app` block and the size guard, per its own header comment. Read both and confirm the scrollbar lines match and nothing else changed.

- [ ] **Step 3: Host suite (both checkers accept `both` already)**

Run: `go build -o clarus ./cmd/clarus && go test ./...`
Expected: PASS with no golden churn. If any emitted-C golden over `editor.cla` diffs, the test output prints its regeneration instructions — read them and follow them only if the diff is exactly the `RTUI_SCROLL_V | RTUI_SCROLL_H` flag change.

- [ ] **Step 4: Rebless the Text Editor snap (rendering legitimately changes: no-wrap)**

Run: `CLARUS_MAC_TESTS=1 CLARUS_MAC_BLESS=1 go test ./internal/mactest -run TestTexteditor -v`
Then: `git status` — ONLY `testdata/uisnaps/texteditor.roundtrip.pbm` may have changed (the trace must not; if `texteditor.trace` or the bigfile/quit goldens changed, investigate). Eyeball the new PBM: the editor window now shows both scrollbars and unwrapped text.
Rerun without bless: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestTexteditor -v` → PASS.

- [ ] **Step 5: Commit**

```bash
git add docs/clarus-language-reference.md testdata/valid/editor.cla examples/texteditor.cla testdata/uisnaps/texteditor.roundtrip.pbm
git commit -m "reference+texteditor: zoom box documented, scrollbar: both real (no-wrap + H bar)"
```

---

### Task 4: Full verification + live emulator validation (main session, not a subagent)

- [ ] Full host suite: `go build -o clarus ./cmd/clarus && go test ./...` → green.
- [ ] Full gated suite: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -v` → green.
- [ ] Live validation: `scripts/build-mac.sh TextEditor examples/texteditor.cla`, launch in Mini vMac with real input (per CLAUDE.md emulator section): click the zoom box (window fills the screen), click it again (restores), grow the window via the corner (grow icon visible), type a long line (no wrap), drag both scrollbar thumbs and click all four arrows/track pages, then resize small to the 200×120 minimum. Screenshot evidence at each step.
- [ ] Whole-branch review (superpowers:requesting-code-review), then hold for Andrew's merge decision (merge only on request).

## Out of scope (do not "fix" these in passing)

- The pre-existing `NewControlActionUPP` per-click leak, the TEClick-autoscroll thumb desync, and scripted `resize`'s lack of min/screen clamping — all predate this plan; leave them.
- Longest-line horizontal range tracking; `zoomable` syntax; `wrap` property — rejected in the spec.
