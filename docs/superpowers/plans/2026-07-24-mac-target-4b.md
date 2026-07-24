# Mac Target 4b — Core UI — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Windows, widgets (button/check/canvas/label), menus, timers, and the WaitNextEvent loop running Toolbox-native, lowered by clarusc to C descriptor tables, tested via trace capture + scripted events + framebuffer goldens.

**Architecture:** Runtime-first: `runtime/mac/rt_ui.{h,c}` is built and proven with a hand-written descriptor-table C probe app (real input first, then scripted-event/trace/snap test machinery). Only then does clarusc learn to emit the same descriptor tables and dispatch wiring. A gated harness runs scenario fixtures (Clarus program + event script + trace/snap goldens); ungated emitter goldens keep the lowering under fast host test.

**Tech Stack:** C (Retro68 m68k gcc), Clarus (clarusc emit), Go (harness), Rez only for the existing alert resource, LaunchAPPL + Mini vMac.

**Spec:** `docs/superpowers/specs/2026-07-24-mac-target-4b-design.md` (the language reference Ch8/9/11 is normative above both).

## Global Constraints

- Branch `mac-target-4b`; main stays green; merge only on user request.
- FROZEN: `cmd/`, all pre-existing `internal/` packages (new sub-tests inside `internal/mactest` ARE allowed — 4a created it), `internal/build/rt/rt.h`, `internal/build/rt/rt.c`. The Go compiler gains NO UI emission.
- `clarusc/*.cla` MAY change (that's the point of Tasks 4-5) under these rules: clarusc's own source uses only the pre-4b language subset (conservative-subset rule — the Go compiler must still build it); EVERY task that touches `clarusc/*.cla` must, within that task: regenerate the snapshot (`build clarusc via Go, then ./clarusc emit -o clarusc/clarusc.c clarusc/main.cla` — exact procedure printed by `TestSnapshotCurrent` on failure), re-verify `go test ./internal/selfhost -count=1` (bootstrap fixed point + snapshot + differential — UI-free corpus emission must stay byte-identical between compilers).
- Every `.cla` file: 3-line license header. `go test ./...` green at the end of every task.
- Commit trailer (required):
  Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>
  Claude-Session: https://claude.ai/code/session_01AkyoymLw41UBXuxLrXzQE5
- Toolchain: `toolchain/bin/m68k-apple-macos-gcc`, cmake toolchain file `toolchain/m68k-apple-macos/cmake/retro68.toolchain.cmake`, emulator per CLAUDE.md (no `timeout` binary — Go contexts or background Bash). Compile checks: `-Wall`, warning baseline is 4a's (6 ParamText -Wpointer-sign normal / +1 unused-function in RT_MAC_TEST); no new warnings.
- LaunchAPPL echoes ONLY the boot-volume file `out` (4a probe). ALL test output (trace, snaps, 4a exit trailer) multiplexes through it.

## Contracts pinned by this plan (all tasks conform; goldens depend on them)

**Trace lines** (RT_MAC_TEST only, appended to the `out` capture stream, LF-terminated):
```
T OPEN <WinType> <id>            # id: 1-based per-type instance counter
T CLOSE <WinType> <id>
T FRONT <WinType> <id>           # frontmost changed (open/close/click-to-front)
T FIRE <WinType>.<event>         # window event: closeRequest|closed|resized|key
T FIRE <WinType>.<Widget>.<event>    # click|change|drag
T FIRE <Menu>.<Item>.select
T FIRE every.<n>                 # n: declaration index of the every-block, 0-based
T SET <WinType>.<Widget>.<prop> <value>   # runtime property writes via rt_ui
T DIM <Menu>.<Item> <0|1>        # dimming recompute changed an item
```
**Event script** (`rt_ui_test_script`, compiled in; one command per line):
```
click X Y      # GLOBAL coords; routed through the same FindWindow dispatch as real clicks
drag X Y       # mouse-moved-while-down at global coords (canvas drag)
key C          # single printable char
menu M I       # 1-based menu position in bar, 1-based item
close          # goAway click on frontmost
resize W H     # frontmost (resizable windows)
tick N         # advance virtual time N ticks; fire due every-blocks
snap NAME      # framebuffer checkpoint
quit           # same path as the quit statement; script exhaustion implies quit
```
In the test build, virtual time replaces TickCount for `every` scheduling; the injection point is EXACTLY the WaitNextEvent return value — all downstream dispatch is shared with real input.

**Snap encoding** in the capture stream:
```
##CLARUS-SNAP## NAME
<hex of 21,888 screen bytes (512x342 1-bit), uppercase, 128 hex chars per line>
##CLARUS-SNAP-END##
```
Harness decodes to `testdata/uisnaps/<scenario>.<NAME>.pbm` (P4 header `P4\n512 342\n` + raw bytes). `CLARUS_MAC_BLESS=1` rewrites goldens instead of comparing.

**rt_ui.h ABI (emitted code and probe both consume; exact names):**
```c
/* descriptors (static const in emitted C / probe) */
typedef struct { short kind;              /* RTUI_BUTTON/CHECK/CANVAS/LABEL */
                 const char *name;        /* widget name for traces */
                 const unsigned char *caption;  /* Str255 or NULL */
                 short atKind, x, y;      /* RTUI_AT_XY/NEXT/RIGHT; y or RTUI_BOTTOM */
                 short width;             /* px, or RTUI_FILL */
                 short fill;              /* RTUI_FILL_NONE/BOTH */
                 short flags;             /* RTUI_DEFAULT|RTUI_CANCEL|RTUI_BUFFERED */
} rt_ui_widget_desc;
typedef struct { const char *name; const unsigned char *title;  /* Str255 */
                 short w, h; short resizable, minW, minH;
                 short nWidgets; const rt_ui_widget_desc *widgets;
                 short stateSize;         /* per-instance user-var struct size */
                 const struct rt_ui_handlers *handlers; } rt_ui_window_desc;
typedef struct { const char *name; const unsigned char *title;
                 short nItems; const struct rt_ui_item_desc *items; } rt_ui_menu_desc;
typedef struct rt_ui_item_desc { const char *name; const unsigned char *label;
                 unsigned char key; short separator; } rt_ui_item_desc;
/* handler tables: entries may be NULL */
typedef struct rt_ui_handlers {
  void (*winEvent)(void *inst, short event, long a, long b); /* RTUI_EV_* */
  void (*widget)(void *inst, short widgetIndex, short event, long a, long b);
} rt_ui_handlers;
typedef struct { void (*fire)(void); long ticks; } rt_ui_every_desc;
typedef struct { void (*fire)(void *frontInstOrNull); const char *menu, *item;
                 short menuIndex, itemIndex; const rt_ui_window_desc *scope; } rt_ui_menu_handler;

/* runtime API (called by emitted code / probe) */
void  rt_ui_startup(const rt_ui_window_desc **wins, short nWins,
                    const rt_ui_menu_desc **menus, short nMenus,
                    const rt_ui_menu_handler *mh, short nMh,
                    const rt_ui_every_desc *ev, short nEv);
void  rt_ui_run(void);                       /* the event loop; returns on quit */
void *rt_ui_open(const rt_ui_window_desc *d);        /* `open W`  -> instance */
void  rt_ui_close(void *inst);                       /* `close w` */
void *rt_ui_front(const rt_ui_window_desc *d);       /* `W.front`, NULL if none */
void *rt_ui_state(void *inst);                       /* per-instance user vars */
void  rt_ui_set_title(void *inst, const unsigned char *s);
void  rt_ui_widget_set_str(void *inst, short wIdx, short prop, const unsigned char *s);
void  rt_ui_widget_set_bool(void *inst, short wIdx, short prop, int v);
int   rt_ui_widget_get_bool(void *inst, short wIdx, short prop);
short rt_ui_widget_get_int(void *inst, short wIdx, short prop);  /* canvas width/height */
void  rt_ui_menu_enable(short menuIdx, short itemIdx, int on);
/* canvas ops (Ch11 subset used by bounce + demos) */
void  rt_ui_canvas_clear(void *inst, short wIdx);
void  rt_ui_canvas_fill_circle(void *inst, short wIdx, short x, short y, short r);
void  rt_ui_canvas_line(void *inst, short wIdx, short x0, short y0, short x1, short y1);
void  rt_ui_canvas_rect(void *inst, short wIdx, short x, short y, short w, short h, int fill);
```
(Constants RTUI_* defined in rt_ui.h. If the reference's Ch11 op list for canvas differs, the reference wins — adjust in Task 2 and note it.)

## File Structure (end state)

```
runtime/mac/rt_ui.h / rt_ui.c        UI runtime (normal + RT_MAC_TEST paths)
internal/mactest/uiprobe/probe_ui.c  hand-written descriptor app (+ CMakeLists.txt)
internal/mactest/uiprobe/events.c    compiled-in script for probe test runs
internal/mactest/ui_test.go          gated scenario harness + snap decode/bless
internal/emitui/emitui_test.go       ungated emitter goldens (NEW package)
testdata/ui/<scenario>.cla|.events|.trace   scenario fixtures
testdata/uisnaps/<scenario>.<name>.pbm      blessed framebuffer goldens
testdata/emitui/<fixture>.cla|.c.golden     lowering goldens
examples/menu-demo.cla               acceptance example
clarusc/{lower,ir,cprint,...}.cla    UI lowering (Tasks 4-5)
scripts/build-mac.sh                 gains --events FILE (generates events.c)
```

---

### Task 1: rt_ui core — windows, widgets, layout, real-input event loop + probe app

**Files:** Create `runtime/mac/rt_ui.h`, `runtime/mac/rt_ui.c`, `internal/mactest/uiprobe/probe_ui.c`, `internal/mactest/uiprobe/CMakeLists.txt`.

**Interfaces:** Produces the rt_ui.h ABI above (frozen for later tasks except canvas/menu additions in T2). Probe app is the living example of descriptor authorship Task 4's emitter must reproduce.

- [ ] Write rt_ui.h exactly per the contract block (menus/canvas/every parts declared but may stub in .c until T2).
- [ ] Implement in rt_ui.c: eager `rt_ui_startup` (Toolbox init once — subsume 4a's lazy init by having it call the same internal init), window open/close/front/registry (Handle-backed instances: WindowRecord + widget storage + user-var block, refCon → instance), the layout engine (Ch8: at x,y / next / right / bottom, width fill, fill both; resize re-pins edge-relative widgets), widget create/draw for button/check/label via Control Manager + TETextBox for label, `rt_ui_run` WaitNextEvent loop handling mouseDown (drag/grow/goAway/content → FindControl/TrackControl → widget handler dispatch), update (DrawControls + labels), activate, keyDown → frontmost `key` handler (menu keys come in T2).
- [ ] Write probe_ui.c: hand-authored descriptors — one window type ("Probe", resizable) with button (`default`), check, label; handlers that prove dispatch by mutating state (button click toggles check via rt_ui_widget_set_bool and rewrites the label; window `key` handler sets title to the typed char; closeRequest allows close). CMakeLists mirrors internal/mactest/probe/ (links rt_ui.c + rt_mac.c + alert.r).
- [ ] Gates: m68k `-Wall` compile of rt_ui.c both modes (no new warnings); probe builds; run probe via LaunchAPPL, interact per CLAUDE.md recipes (click the button, type a key), screenshot to `build-mac/uiprobe-shot.png`, READ the screenshot confirming window+widgets render and the click visibly toggled state; clean exit via close box (verify LaunchAPPL exit 0). `go test ./...` green.
- [ ] Commit `runtime/mac: rt_ui core — windows, widgets, layout, event loop + UI probe`.

### Task 2: rt_ui menus, canvas, timers

**Files:** Modify `runtime/mac/rt_ui.{h,c}`, `internal/mactest/uiprobe/probe_ui.c`.

- [ ] Menus: build from descriptors at startup (NewMenu/AppendMenu/InsertMenu/DrawMenuBar; key equivalents), MenuSelect + MenuKey dispatch through the rt_ui_menu_handler table (app-scope handlers always enabled; window-scoped: fire with front instance, dim via `rt_ui_menu_enable` recompute on frontmost change — trace `T DIM` lines come in T3), checkmarks out of scope (not in reference core).
- [ ] Canvas: widget kind with optional offscreen 1-bit GrafPort when `RTUI_BUFFERED` (ops draw offscreen, update blits via CopyBits; unbuffered draws direct per Ch11 — read Ch11 and match its redraw semantics exactly; if Ch11's op list differs from the header sketch, the reference wins — adjust rt_ui.h and note in report), ops: clear/fillCircle/line/rect; click/drag hit dispatch with widget-local coords.
- [ ] Timers: every-table scheduling on TickCount deltas in rt_ui_run (normal build).
- [ ] Extend probe: add a menu ("Probe" menu: item toggling the check, window-scoped item; a second window type to prove dimming) and a buffered canvas animated by an every-block (bouncing square).
- [ ] Gates: compiles both modes no new warnings; probe run — screenshots prove menu pulls down (screenshot while held is hard: instead select the item via click coords and verify its visible effect), canvas animates (two screenshots ≥1s apart differ in square position; READ both), dimming (screenshot menu bar with/without the scoped window... visible effect: select scoped item with no window → no trace/no effect; verify via state), clean exit. `go test ./...` green.
- [ ] Commit `runtime/mac: rt_ui menus, canvas, timers; probe exercises all three`.

### Task 3: RT_MAC_TEST UI machinery — trace, scripted events, snaps

**Files:** Modify `runtime/mac/rt_ui.c` (+minor rt_ui.h), `scripts/build-mac.sh`, `internal/mactest/uiprobe/` (add `events.c` sample), Create nothing else.

- [ ] Trace: every contract-listed action emits its exact line to the 4a capture stream (reuse rt_mac.c's rt_test_emit path via a shared internal hook; normal build compiles it all out).
- [ ] Scripted events: `extern const char rt_ui_test_script[];` (weak default empty in rt_ui.c). In RT_MAC_TEST when non-empty, rt_ui_run's WaitNextEvent is replaced by a script reader producing synthetic EventRecords/actions per the contract grammar — injection ONLY at that point; `tick N` advances virtual time driving the every-table (TickCount unused in test builds); `snap NAME` dumps the screen bits hex-encoded per the contract (screenBits.baseAddr, 21,888 bytes — hide the cursor in test builds at startup); `menu M I` routes through the same dispatch as MenuSelect's result; script end or `quit` → quit cascade.
- [ ] build-mac.sh: add `--events FILE` — generates `<out>/events.c` defining rt_ui_test_script from FILE's contents (C-escaped), adds it to the cmake app sources.
- [ ] Gates: compile both modes; build probe with a sample script (click button, tick 120, snap S1, quit) via `--test --events`; run via LaunchAPPL; verify captured stdout contains expected `T FIRE Probe.Go.click`-style lines in order, a well-formed snap block (21,888 bytes of hex → decode with `xxd -r -p | wc -c` = 21888), and the 4a exit trailer with code 0. Non-scripted --test probe still runs with real input. `go test ./...` green.
- [ ] Commit `runtime/mac: UI trace, scripted event injection, framebuffer snaps; build-mac --events`.

### Task 4: clarusc lowering I — descriptors + UI expression/statement lowering

**Files:** Modify `clarusc/*.cla` (lower/ir/cprint/lib as its architecture dictates — read clarusc's module docs first), `clarusc/clarusc.c` (regenerated snapshot). Create `testdata/emitui/win_basic.cla` + `.c.golden`, `menu_basic.cla` + `.c.golden`, `internal/emitui/emitui_test.go`.

**Interfaces:** Consumes rt_ui.h ABI (T1/T2 headers are the target). Produces: emitted descriptor tables + lowered UI expressions; Task 5 adds handler wiring.

- [ ] Lower `window`/`menu` declarations to static const rt_ui_*_desc tables in emitted C (names/layout/flags per descriptor contract; per-window user vars → state struct; stateSize set; handlers tables emitted as all-NULL until T5).
- [ ] Lower UI statements/expressions through the IR's abstract-intrinsic pattern: `open W` → rt_ui_open, `close w`, `W.front` (typed instance value; nil-comparable), instance var access via rt_ui_state cast, widget runtime property get/set → rt_ui_widget_* / rt_ui_set_title, canvas ops → rt_ui_canvas_*, `Menu.Item.enabled = b` → rt_ui_menu_enable.
- [ ] emitui_test.go (ungated; NEW package internal/emitui): builds clarusc via the Go compiler (`build.Build` on clarusc/main.cla, as selfhost tests do), runs `clarusc emit` on each testdata/emitui fixture, compares output to `.c.golden` byte-exact; goldens are committed after hand-review. Also m68k compile-check each golden against rt_ui.h (compile only, no link — handlers are NULL).
- [ ] Snapshot regeneration + `go test ./internal/selfhost -count=1` (fixed point holds; UI-free corpus differential still byte-identical — UI lowering must not perturb existing emission).
- [ ] Gates: `go test ./... -count=1` green (includes new emitui). Commit `clarusc: lower window/menu declarations + UI intrinsics to rt_ui descriptor tables`.

### Task 5: clarusc lowering II — handlers, dispatch, every, main wiring

**Files:** Modify `clarusc/*.cla` (+ snapshot), extend `testdata/emitui/` fixtures (add `handlers.cla`/`every.cla` + goldens).

- [ ] Lower `extend` bodies: window/widget/menu handlers → C functions with the rt_ui_handlers signatures (widget/event indices resolved at compile time; window-scoped menu handlers get their scope descriptor), `every` blocks → rt_ui_every_desc table entries, `quit` inside UI programs → the cascade entry point.
- [ ] Emitted main() for UI programs: rt_args_init → clar_init_globals → rt_ui_startup(tables) → launch/start handlers → rt_ui_run(). UI-free programs emit exactly as before (byte-stable — assert via differential suite).
- [ ] Acceptance-in-small: `./clarusc emit` of `testdata/valid/bounce.cla` succeeds and the output compiles (m68k, link against rt_ui+rt_mac — full link this time).
- [ ] Snapshot regen + selfhost suite; emitui goldens extended; `go test ./...` green.
- [ ] Commit `clarusc: lower handlers/every/dispatch; UI programs emit runnable main`.

### Task 6: gated harness — UI scenarios

**Files:** Create `internal/mactest/ui_test.go`, `testdata/ui/` fixtures (3 scenarios: `buttons.cla` — clicks/property writes/window events; `menus.cla` — two window types, scoped dimming, menu fires; `canvas.cla` — buffered canvas + ticks + 2 snaps), their `.events` + `.trace` goldens + snap PBMs (blessed).

- [ ] Harness: for each scenario, build via `scripts/build-mac.sh <Name> testdata/ui/<n>.cla --test --events testdata/ui/<n>.events`, run via LaunchAPPL (reuse 4a's RunMac plumbing: context timeout, WaitDelay, pkill cleanup), split capture into trace lines / snap blocks / exit trailer; compare trace to `.trace` golden byte-exact, decode snaps and compare to PBMs byte-exact; `CLARUS_MAC_BLESS=1` writes goldens instead. Gated by CLARUS_MAC_TESTS as in 4a.
- [ ] First blessing: run with bless, then READ each snap PBM (convert to PNG via `sips` if needed) and eyeball-verify plausibility before committing; document each snap's expected content in the fixture's header comment.
- [ ] Gates: ungated `go test ./...` green (gated tests skip); `CLARUS_MAC_TESTS=1 go test ./internal/mactest -count=1 -timeout 30m` fully green including the unchanged 4a suite; deliberately corrupt one trace golden locally → confirm loud failure → restore (evidence in report, not committed).
- [ ] Commit `mactest: gated UI scenario harness (trace + snap goldens, bless mode)`.

### Task 7: acceptance examples

**Files:** Create `examples/menu-demo.cla`; scenario-ize both examples (`testdata/ui/` smoke scripts + goldens for bounce and menu-demo may reference examples via relative path — keep fixtures self-contained by making the smoke scripts run the example files directly).

- [ ] Author menu-demo.cla: two window types, app + window-scoped menus (dimming visible), check/label/button interplay; license header; must also pass `clarus check` (Go front end) since the frontend corpus may gain it later — keep to checked language surface.
- [ ] Build both examples via build-mac.sh (normal build); run each in Mini vMac via LaunchAPPL with REAL input per CLAUDE.md: for bounce verify animation (two screenshots differ), for menu-demo click through the menu and verify the visible effect; screenshot both to build-mac/; READ screenshots to confirm; clean exits.
- [ ] Add gated smoke scenarios (scripted) for both so CI-by-harness covers them without a human.
- [ ] Gates: full gated run green; `go test ./...` green. Commit `examples: bounce + menu-demo as double-clickable 4b acceptance apps`.

### Task 8: docs, snapshot sanity, final review

**Files:** Modify `docs/ROADMAP.md` (4b done; record the 4b/4c/4d re-split as decided 2026-07-24; 4c next), `CLAUDE.md` (UI harness + --events + bless-mode lines).

- [ ] Docs updated in each file's voice; final `go test ./... -count=1` + gated full run + `TestSnapshotCurrent`/fixed-point green.
- [ ] Commit `docs: 4b done — core UI runtime, clarusc UI lowering, scenario harness`.
- [ ] Whole-branch final review (most capable model) with the ledger's minors; one consolidated fix wave if needed; offer merge (do not merge unprompted).

## Self-review notes

- Spec coverage: scope→T1/T2, lowering→T4/T5, testing 1+2+3→T3/T6, acceptance→T7, re-split docs→T8, probe-first sequencing honored. Frozen surfaces: emitui is a NEW package; mactest additions were pre-authorized by 4a's precedent; rt.h untouched (rt_ui.h separate).
- The rt_ui.h contract is pinned here so T1 (hand-written) and T4/T5 (emitted) converge on one ABI; T2 may amend canvas ops per Ch11 with the amendment recorded in its report (T4 reads the header as built, not this plan's sketch).
- Snapshot regen is inside T4 and T5 (not deferred to T8) so `go test ./...` stays green per-task.
- Event injection replaces only WaitNextEvent's return; TrackControl in scripted mode: synthetic clicks call the shared post-FindControl dispatch path directly (documented in T3) — the one deliberate divergence, confined and traced.
