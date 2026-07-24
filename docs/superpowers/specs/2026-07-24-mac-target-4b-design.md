# Mac Target 4b — Core UI (windows/menus/events) — Design

Date: 2026-07-24. Status: approved design, pre-implementation.
Roadmap context: `docs/ROADMAP.md` Plan 4. Builds on 4a
(`2026-07-24-mac-target-4a-design.md`): the rt.h ABI runtime, build-mac
pipeline, capture harness, and corpus suite are all assumed present.

## Goal

The declarative UI core of the language reference — windows, widgets,
menus, timers, the event loop — running Toolbox-native on the Mac Plus,
lowered by clarusc, tested without a host oracle. Acceptance artifacts:
the Chapter 11 bounce demo and a new menu demo as double-clickable apps.

## Phase re-split (supersedes the roadmap's 4b acceptance)

The roadmap's "both Appendix C examples" acceptance predates this design
and contradicts its own phase split (both examples need next-phase
machinery). Decided re-split — each phase ships a real artifact:

- **4b (this spec):** core UI. Acceptance: bounce + menu demo.
- **4c:** `textview`/`field` (TextEdit), `standard edit` menu, Standard
  File (`askOpen`/`askSave`), `App.openDocument`. Acceptance: the
  Appendix C Text Editor.
- **4d:** forms + binding walker, `popup`, `table`/List Manager, real
  Handle-backed records, `file.save`/`load`. Acceptance: the Appendix C
  Bookmark Manager.

ROADMAP.md is updated to this split as part of 4b's doc task.

## Scope (4b)

Per the reference (Ch8, Ch9, Ch11 minus deferred items; the reference is
normative — where this spec summarizes it, the reference wins):

- **Windows:** declarations → instances (`open`/`close`, multiple
  instances of one window type, `Type.front`), `title`/`size`/
  `resizable[: min(w,h)]`, per-window `var`s, window events
  `closeRequest`, `closed`, `resized`, `key(k: char)`.
- **Widgets:** `button` (caption/at/width/default/cancel; runtime
  caption/enabled; `click`), `check` (unbound: caption/at; runtime
  `checked`; `change`), `canvas` (at/fill/buffered; runtime
  width/height; `click(x,y)`, `drag(x,y)`; Ch11 drawing ops), `label`
  (text/at; runtime text).
- **Layout:** `at: x,y` absolute and `next`/`right`/`bottom` relative
  forms; `width: fill`; `fill: both`; automatic resize re-layout with
  edge pinning (Ch8 Layout).
- **Menus:** declarations (items, key equivalents, separators), menu bar
  assembly, `enabled` control, app-level `extend MenuName` handlers and
  window-scoped `extend Win { extend MenuName }` nesting with automatic
  dimming of window-scoped items when no such window is frontmost (Ch9).
- **Timers:** top-level `every N ticks` blocks, fired from the event loop.
- **Lifecycle:** `App.launch`/`startEmpty` as in 4a; `quit` sends
  `closeRequest` to every open window, any cancel aborts the quit.

**Non-goals (4b):** `field`, `textview`, `popup`, `table`, forms/`edit`,
`standard edit`, `App.openDocument`, Standard File, color, printing.
Host execution of UI programs (unchanged: host builds of UI programs are
unsupported; UI runs on the Mac target only).

## Lowering — C descriptor tables (decided)

clarusc continues to emit exactly one `.c` per program:

- Each `window` declaration → a `static const` window descriptor: bounds,
  title, flags (resizable, min size), and a widget array (kind, name id,
  declaration properties, layout spec). Each `menu` → a menu descriptor
  (title, items with labels/keys/separator marks).
- Handlers (`extend` bodies, window events, widget events, menu items,
  `every` blocks) → ordinary emitted C functions, referenced from
  dispatch tables (window-type vtable: event kind + widget/menu index →
  function pointer; a tick table for `every`).
- Per-window user `var`s → a per-instance state struct; widget runtime
  properties are accessed through rt_ui calls, not raw fields.
- Emitted UI programs `#include "rt_ui.h"` in addition to `rt.h`.
  Programs with no UI declarations emit exactly as today (4a output is
  byte-stable — guarded by the existing emitter goldens and suite).

`rt.h` and `rt.c` stay FROZEN. `rt_ui.h` is a new Mac-only header in
`runtime/mac/` — the UI ABI contract between emitted code and runtime.
The Go compiler is not extended (per the freeze: no differential
counterpart for UI emission; the 4b harness is the safety net). clarusc's
own source continues to use no UI features (conservative-subset rule).

## Runtime — `runtime/mac/rt_ui.c`

- **Init:** eager — `rt_ui_startup(descriptors...)` runs Toolbox init
  (4a's lazy init is subsumed), builds menus, then fires launch/start
  handlers, then enters the loop. Emitted `main()` calls it; the 4a
  alert-only path keeps working for UI-free programs.
- **Event loop:** `WaitNextEvent`; mouseDown routed via `FindWindow`
  (menu bar → MenuSelect + dispatch; drag/grow/goAway; content → widget
  hit test via Control Manager / canvas rects); updates (controls via
  Control Manager; canvas blits its offscreen buffer when `buffered`,
  else fires redraw per Ch11); activate; keyDown (menu key equivalents
  first, then frontmost window's `key` handler); timer check via
  `TickCount` deltas.
- **Instances:** Handle-backed per-instance structs (window record,
  widget storage, user vars), a per-type registry providing `Type.front`
  and the dispatch back-pointer (refCon → instance).
- **Menu dimming:** recomputed on frontmost-window change; window-scoped
  items dim when no window of that type is frontmost.
- **Quit cascade:** `quit` iterates open windows front-to-back firing
  `closeRequest`; any cancel aborts; otherwise windows close and the
  loop exits (normal-build exit-code loss noted in 4a review stands;
  test build records the code as in 4a).

## Testing (decided: trace + scripted events + framebuffer goldens)

No host oracle exists for UI; blessed Mac output becomes the golden,
diffed with 4a's capture discipline.

- **UI trace (RT_MAC_TEST):** every UI-visible action appends one line to
  the 4a capture stream (`out`): window open/close/front, widget property
  changes, handler fires (`FIRE Doc.Go.click`), menu selections, timer
  fires. Vocabulary defined once in rt_ui.c and documented in the plan;
  stable formatting is part of the contract (goldens depend on it).
- **Scripted events (RT_MAC_TEST):** the harness writes an `events` file
  onto the boot disk; the test build's loop consumes it INSTEAD of real
  input: `click X,Y [win]`, `drag X,Y`, `key C`, `menu M I`, `close`,
  `resize W,H`, `tick N` (advances virtual time; timers fire from
  scripted ticks, never TickCount, making runs deterministic),
  `snap NAME`, `quit`. Script exhaustion implies `quit`.
- **Framebuffer goldens:** `snap NAME` captures the 1-bit 512×342 screen
  (10,944 bytes) via CopyBits, hex-encoded into the capture stream
  between `##CLARUS-SNAP## NAME` / `##CLARUS-SNAP-END##` sentinels. The
  harness decodes and byte-compares against `testdata/uisnaps/NAME.pbm`
  (stored as PBM so snapshots are viewable). `--bless` regenerates.
- **Harness:** `internal/mactest` gains gated UI tests: scenario apps
  (Clarus programs + event scripts + expected traces/snaps) run one boot
  each; plus scripted smokes of the two acceptance examples. 4a's suite
  and standalone apps keep running unchanged.
- **Ungated:** emitter goldens for descriptor-table lowering (emitted C
  for UI fixtures compared textually, like existing emit tests — this
  needs no Mac and keeps clarusc's UI lowering under fast test).

## Acceptance

1. `testdata/valid/bounce.cla` (Ch11 demo) and new
   `examples/menu-demo.cla` (two window types, menus with window-scoped
   dimming, check + label + button) build via `scripts/build-mac.sh` and
   run as double-clickable apps in Mini vMac — screenshot-verified.
2. Gated `CLARUS_MAC_TESTS=1 go test ./internal/mactest` green: new UI
   scenario traces + snaps AND the unchanged 4a suite byte-compare.
3. Ungated `go test ./...` green throughout; UI-free emission byte-stable.
4. Frozen surfaces untouched: `cmd/`, existing `internal/` packages,
   `internal/build/rt/`, Go compiler; clarusc gains UI lowering but its
   own source uses no UI features; existing goldens unmodified.

## Risks / probes

- **Trace/snap blessing bootstrap:** first goldens are hand-verified from
  screenshots before committing (bless mode makes regeneration cheap but
  the FIRST bless of each snap is reviewed by eye).
- **Determinism of snaps:** background pattern, cursor, and window
  stacking must be controlled (cursor hidden in test build; snaps taken
  after update processing). Probe early with a hand-written descriptor
  app before the emitter exists (sequencing below).
- **Emitter surface growth:** UI lowering is clarusc's largest addition
  since v2; the ungated emitter goldens keep it under fast host test.
- **Event-script fidelity:** scripted clicks bypass real Toolbox mouse
  tracking (TrackControl etc.); the runtime must route scripted events
  through the same dispatch code paths real events take, or the tests
  test a parallel universe. Design rule: injection replaces ONLY
  `WaitNextEvent`'s return value; everything downstream is shared.
  (True end-to-end input stays covered by the 4a-style manual/screenshot
  smokes of the acceptance apps.)
- **Memory:** offscreen canvas buffers (bounce: ~200×200 1-bit ≈ 5KB)
  and per-instance Handles are small; no pressure expected on 4MB.

## Sequencing

1. Probe/runtime-first: hand-written descriptor-table C app proves the
   event loop, layout, canvas, menus, scripted events, trace, and snap
   machinery — before clarusc lowering exists (4a probe-first pattern).
2. clarusc UI lowering (+ ungated emitter goldens).
3. Harness UI scenarios (gated) over compiled Clarus fixtures.
4. Acceptance examples + screenshot verification.
5. Docs (ROADMAP re-split recorded) + final review.
Main stays green; branch `mac-target-4b`.
