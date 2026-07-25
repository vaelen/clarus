# Mac Target 4c: Text Editing Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** TextEdit-backed `textview`/`field` widgets, `standard edit` menu, Standard File dialogs, and `App.openDocument` (System 6 + System 7) — acceptance: the Appendix C Text Editor as a shippable app.

**Architecture:** rt_ui.c grows TE widget machinery (parallel TE-handle array, focus model, event-loop hooks) and dialog/AppleEvent plumbing; clarusc's seven `lowUnsupported` abort sites on this path become real lowering; the scripted harness gains `type`, dialog-answer, and `launchdoc` verbs so everything is deterministic on the System 6 Mac Plus; System 7 (`odoc` while running) is verified manually on the Mac II emulator via the Finder flow.

**Tech Stack:** C (classic Toolbox: TextEdit, StandardFile, Scrap, AppleEvents, Gestalt via Retro68), Clarus (clarusc), Rez, bash, Go test harnesses.

**Spec:** `docs/superpowers/specs/2026-07-25-mac-target-4c-design.md` (read first).

## Global Constraints

- Go compiler (cmd/clarus, non-test internal/) FROZEN. `testdata/valid/editor.cla` is IN the differential corpus and must stay byte-identical (it already checks clean in both compilers — never edit it). The acceptance app is a NEW file `examples/texteditor.cla`.
- Differential/check behavior must not change at all: 4c needs ZERO checker/parser/ast edits (front end already validates everything — verified). Only lower.cla/ir.cla/cprint.cla/main-adjacent clarusc files change; snapshot regen after every clarusc edit:
  ```sh
  go run ./cmd/clarus build -o /tmp/clarusc clarusc/main.cla
  /tmp/clarusc emit -o clarusc/clarusc.c clarusc/main.cla
  go test ./internal/selfhost/
  ```
- New emit fixtures ONLY in `testdata/emitui/` (+ scenarios in `testdata/ui/`); never in the six Go-swept testdata dirs.
- Existing UI goldens byte-identical except where a task explicitly blesses new ones. Full gated suite (`CLARUS_MAC_TESTS=1 go test ./internal/mactest`) green at every task end; host `go test ./...` green at every commit.
- rt_ui.h header comment pins the descriptor ABI — update it when structs change; uiprobe (`internal/mactest/uiprobe/probe_ui.c`) uses positional initializers and must be kept in sync with any struct change.
- TE cap: **32,000 bytes** (`RTUI_TE_MAX`); every mutation path clamps and truncation sets `lastError` via `rt_set_lasterr`.
- Port discipline rule (rt_ui.h:125-138): every rt_ui entry point that draws saves/sets/restores the port.
- Emulator env note: kill stray `minivmac` processes if LaunchAPPL/hfs complains the System image is busy.
- Branch: all tasks commit to `mac-target-4c`.

**Key research facts** (verified; cite in briefs as needed):
- rt_ui widget kinds end at `RTUI_LABEL 3` (rt_ui.h:26-29) → `RTUI_FIELD 4`, `RTUI_TEXTVIEW 5`. Flags `short` has bits 1/2/4 used → scrollbar bits 8 (`RTUI_SCROLL_V`) / 16 (`RTUI_SCROLL_H`). `RTUI_PROP_TEXT 1` is reserved for exactly this. Widget events end at `RTUI_WEV_DRAG 2` → `RTUI_WEV_ENTER 3`.
- Instance state is parallel locked-Handle arrays in `rt_ui_winst` (rt_ui.c:164-176, alloc :1579-1586, dispose :1658-1667); controls stash their widget index in `contrlRfCon` (:545, read :1053). A textview's scrollbar ControlHandle can live in `ctrls[wIdx]` with rfCon `0x8000|wIdx` as discriminator.
- Layout hooks: `rt_ui_kind_height/width` (rt_ui.c:391-414); derived TE view/dest rects recomputed after `SetRect` at :494-498 and on resize (:961-971).
- Event loop insertion points: TEIdle beside `rt_ui_every_pump` (:1557-1559; drop WNE sleep to 1 when a TE is focused, :1540); TEKey ordering in `rt_ui_handle_key` (:1141-1169): cmdKey → focused-field Return fires `enter` → focused-TE `TEKey` → existing default/cancel/key chain; content-click TE hit in the FindControl-miss branch (:1076-1080); update draw branch in :917-927; activate (:940-951) — fix the 4b `HiliteControl` blanket dim there (ponytail note :936-939) with a per-instance `logicalEnabled` array (also fixes `rt_ui_widget_get_bool` :1788 reading `contrlHilite` while deactivated).
- clarusc abort sites to convert: lower.cla:2099 (widget kind), :2295 (standard edit), :1201 (prop read), :1541 (prop set), :2562 (widget event enter), :679 (askOpen/askSave/askSaveChanges), :1933 (App.openDocument). `cpWidgetKindMacro` (cprint.cla:1570-1584) falls through to RTUI_LABEL — make explicit or it silently mislabels new kinds. `IRWidgetDesc` (ir.cla:260, ctor :1336) needs a scrollbar field; `IRWidgetHandlerEntry` (ir.cla:363) needs `enterFn`. `saveChoice` already seeded (types.cla:267-274) and `c == Cancel` folds to an int const (lower.cla:565-567).
- `field.text` is `strT(255)`, `textview.text` is `TextT` (check.cla:483-485) — field reuses the Str255 `fpStrAddr` convention (needs a NEW `rt_ui_widget_get_str` for reads — none exists); textview needs `rt_ui_widget_get_text/set_text(void*, short, rt_text*)` following the `rt_file_read_text` fill-in-place shape; rt_ui.h gets `typedef struct rt_text rt_text;` forward decl (do NOT include rt.h).
- Emitted UI main shape (cprint.cla:2259-2272): startup → `clar_fn_handler_App_launch` → `clar_fn_handler_App_startEmpty` → `rt_ui_run`. openDocument replaces the direct startEmpty call with a runtime dispatch call (Task 5).
- rt_mac file I/O: Str255 paths on the default volume via old FS traps (`FSOpen(path,0,..)`, `Create(path,0,'MPS ','TEXT')` rt_mac.c:1037). NO path helpers/SetVol exist. SF strategy: `SetVol(NULL, reply.vRefNum)` then use bare `reply.fName`.
- SIZE: Retro68APPL.r emits `SIZE(-1)` `notHighLevelEventAware`; a `SIZE(-1)` in appres.r silently REPLACES it (Rez map-assign, positionals after template — add_application.cmake:66-72 documents this as the intended override). appres.r exists only when `app=1` → System 7 AE mode requires an `app` section; without one, System 7 Finder falls back to the old app-files mechanism our System 6 path handles (document this).
- All needed headers are inline traps (no glue lib): TextEdit.h, StandardFile.h (SFReply :130-138), Scrap.h, AppleEvents.h (AEInstallEventHandler :128), AEInteraction.h (AEProcessAppleEvent :95), Gestalt.h (`gestaltAppleEventsAttr` :610; use Gestalt.h NOT GestaltEqu.h which #errors). Grep these headers with `grep -a`.
- Script reader: `sscanf(line, "%31s %63s %63s", ...)` (rt_ui.c:1501 area) — verbs needing spaces/paths must parse the rest-of-line manually. `key` sends ONE char and can't send space → new `type` verb loops `rt_ui_script_key` over rest-of-line bytes.
- Scenario inventory: 8 scenarios (ui_test.go:157-250); goldens trace + 21,888-byte PBM snaps; CLARUS_MAC_BLESS=1 blesses.
- Mac II: `macii/MacII.app` (executable `mnvm0026`, same auto-copied mnvm_dat convention), `macii/MacII.rom`, `macii/System 7.1.dsk`. NO autquit7 image exists → LaunchAPPL cannot drive System 7 runs; manual verification uses the full-Finder flow (`open -na` a copy with disk1=System 7.1.dsk, disk2=app dsk). `pkill -f minivmac.app` cleanup still matches (LaunchAPPL renames bundles); for Finder-flow runs kill by the copy's path.

---

### Task 1: rt_ui.c TextEdit widget foundation (probe-tested, no clarusc changes)

**Files:**
- Modify: `runtime/mac/rt_ui.h` (kind/flag/event constants, rt_text fwd decl, new entry points, ABI comment)
- Modify: `runtime/mac/rt_ui.c` (winst arrays, create/layout/draw/activate/click/key/idle, setters/getters, `type` verb, logicalEnabled fix)
- Modify: `internal/mactest/uiprobe/probe_ui.c` (+ its events/goldens; read the probe's driving test in internal/mactest first and follow its conventions)
- Test: extended uiprobe scenario with blessed goldens

**Interfaces:**
- Produces (contracts for Tasks 2-6):
  ```c
  #define RTUI_FIELD    4
  #define RTUI_TEXTVIEW 5
  #define RTUI_SCROLL_V 8       /* widget_desc.flags */
  #define RTUI_SCROLL_H 16
  #define RTUI_WEV_ENTER 3
  #define RTUI_TE_MAX 32000
  typedef struct rt_text rt_text;  /* fwd decl; do not include rt.h */
  void rt_ui_widget_get_str (void *inst, short wIdx, short prop, unsigned char *dst255);
  void rt_ui_widget_get_text(void *inst, short wIdx, rt_text *out);
  void rt_ui_widget_set_text(void *inst, short wIdx, const rt_text *t);  /* clamp RTUI_TE_MAX + rt_set_lasterr on truncation */
  ```
  (set_str/get existing dispatchers gain RTUI_FIELD/RTUI_TEXTVIEW × RTUI_PROP_TEXT branches; field label uses the existing labels[] lane; rt_text bridging via rt_text_from_bytes/rt_text_to_bytes — see rt.h:34-51. rt_ui.c may call rt.h functions directly; only the HEADER avoids the include.)
- Behavior contract: click-to-focus (one focused TE per window, `TEDeactivate`/`TEActivate` on switch and on window activate); typing via `TEKey` with clamp; field Return/Enter fires `enter` (no insertion), textview Return inserts; every content mutation funnels through one hook that recomputes the scrollbar (when present), traces `T FIRE <Win>.<W>.change`, and fires `RTUI_WEV_CHANGE`; textview draws frame + `TEUpdate`, optional vertical scrollbar (rfCon `0x8000|wIdx`) wired via `TEScroll`; TEIdle caret in both event loops (real + `rt_ui_script_tick`); the activate-time blanket `HiliteControl` bug is fixed via a per-instance `logicalEnabled` array (new locked Handle) honored by activate, `RTUI_PROP_ENABLED` set, and `get_bool`.
- Script: new verb `type <rest-of-line>` — bytes after the single space go through `rt_ui_script_key` one at a time (spaces included; parse rest-of-line manually, not `%63s`).

- [ ] **Step 1:** Read the uiprobe harness end to end (probe_ui.c, its CMakeLists, events.c, the Go test that runs it and where its goldens live). Write the failing probe extension: add to probe_ui.c a window with one field (with label), one textview (`fill: both`-equivalent descriptor values + `RTUI_SCROLL_V`), handler function tracing change/enter; events: click-to-focus each, `type` text into both (including a space and a Return in the textview), field Return → enter, snap. Run gated probe test — fails (unknown kinds render nothing / no goldens).
- [ ] **Step 2:** Implement rt_ui.h constants/decls + rt_ui.c: TE array + focusIdx + logicalEnabled in `rt_ui_winst` (alloc/dispose beside :1579/:1658); creation in `rt_ui_make_widgets` (TENew with inset view/dest rects; scrollbar NewControl when flagged); `rt_ui_kind_height/width` entries (field: RTUI_BUTTON_H-like 20/200 default; textview 100/200 defaults — pick and pin in the header comment); post-SetRect TE relayout + resize path; update-draw branch (FrameRect + TEUpdate + label lane for field); activate fix + TE caret handling; content-click focus/TEClick + scrollbar TrackControl with TEScroll action; key path ordering per contract; mutation funnel; setters/getters incl. the three new entry points; `type` verb + rest-of-line parsing.
- [ ] **Step 3:** Bless probe goldens; eyeball the snap (text visible in Chicago, caret line, scrollbar drawn) and trace (focus-change, change events per keystroke batch — define and pin: `change` fires once per `TEKey`/cut/paste/set, not coalesced). Re-run without bless → green.
- [ ] **Step 4:** Full gated suite + host suite: all pre-existing goldens byte-identical (activate fix must not change any existing scenario — existing scenarios never disable widgets before deactivate; verify).
- [ ] **Step 5:** Commit `rt_ui: TextEdit field/textview widgets, focus model, type verb; logical-enabled activate fix`.

### Task 2: clarusc lowering — widgets, text properties, enter handler

**Files:**
- Modify: `clarusc/lower.cla` (:2099 guard, :2114-2159 scrollbar prop, :1177-1208 reads, :1514-1549 sets, :2545-2564 enter)
- Modify: `clarusc/ir.cla` (IRWidgetDesc scrollbar field :260/:1336; IRWidgetHandlerEntry enterFn :363; new intrinsic names)
- Modify: `clarusc/cprint.cla` (cpWidgetKindMacro explicit dispatch :1570; widget row emission with scrollbar flags :1603-1628; new intrinsic emission beside :906-955; dispatcher enter case :1991-2030)
- Create: `testdata/emitui/textwidgets.cla` + `.c.golden`
- Regenerate: `clarusc/clarusc.c`

**Interfaces:**
- Consumes Task 1's rt_ui API exactly.
- Produces: `field`/`textview` descriptors emit `RTUI_FIELD`/`RTUI_TEXTVIEW` (+ `|RTUI_SCROLL_V`/`|RTUI_SCROLL_H` in flags for `scrollbar: vertical|both`); `field.text` read/write → `rt_ui_widget_get_str`/`rt_ui_widget_set_str` (get via `fpNewTmp("clar_str_255")` temp, IFileName pattern cprint.cla:900-904); `textview.text` read/write → `rt_ui_widget_get_text`/`set_text` with a fresh `rt_text` temp on read; `on X.enter` → enterFn slot → `RTUI_WEV_ENTER` case in the widget dispatcher. New intrinsics named in ir.cla beside IUiSetText (:2018-2054).

- [ ] **Step 1:** Failing fixture: `textwidgets.cla` — window with field (label/at/width) + textview (`fill: both; scrollbar: vertical`), handlers for field.change/field.enter/textview.change, code reading and writing both `.text` props (field↔string var, textview↔text var), open on launch. Run clarusc emit → aborts at widget-kind guard (quote in report).
- [ ] **Step 2:** Implement the four files per Interfaces. The scrollbar prop parse joins the property walk at lower.cla:2114-2159; `cpWidgetKindMacro` becomes explicit five-way dispatch with a loud fallthrough.
- [ ] **Step 3:** Generate golden, eyeball (descriptor rows, dispatcher switch with RTUI_WEV_ENTER, get/set calls with temps), commit golden; `go test ./internal/emitui/` green (m68k compile check proves header/API agreement with Task 1).
- [ ] **Step 4:** Scenario: `testdata/ui/textwidgets.cla` (same shape) + events using click/type/enter + snap + a handler that sets/reads .text props; add test func in ui_test.go; bless; full gated suite green with all old goldens byte-identical.
- [ ] **Step 5:** Snapshot regen + full suite + commit `clarusc: lower field/textview widgets, text props, enter events`.

### Task 3: standard edit menu

**Files:**
- Modify: `clarusc/lower.cla` (:2294 abort → isStandardEdit flag), `clarusc/ir.cla` (IRMenuDesc flag :318/:1504), `clarusc/cprint.cla` (menu desc emission :1855-1878)
- Modify: `runtime/mac/rt_ui.h` (`rt_ui_menu_desc` gains trailing `short standardEdit;` — update ABI comment + uiprobe initializers), `runtime/mac/rt_ui.c` (build hook :736, dispatch hook :828-831, dim recompute :786-803)
- Create: `testdata/emitui/editmenu.cla` + golden; `testdata/ui/editmenu.cla` scenario
- Regenerate: `clarusc/clarusc.c`

**Interfaces:**
- Produces: a standard-edit menu emits `{ "<name>", "\p<title>", 0, 0, 1 }`; runtime builds Undo(⌘Z, permanently disabled)/-/Cut(⌘X)/Copy(⌘C)/Paste(⌘V)/Clear at `RTUI_MENU_ID_BASE+i` (bar-position identity preserved for `menu M I` scripting); dispatch: DA frontmost → `SystemEdit(itemIdx-1)` first refusal; else focused TE gets TECut/TECopy/TEPaste/TEDelete with scrap sync (ZeroScrap+TEToScrap after cut/copy; TEFromScrap before paste, paste clamped to RTUI_TE_MAX via the mutation funnel); items 3-6 dim when the front window has no focused TE (recompute on front change AND focus change); mutations route through Task 1's funnel (change fires).

- [ ] **Step 1:** Failing fixture + scenario: window with two textviews, `menu Edit { standard edit }`; events: focus A, type, select-all-equivalent (drag-select via `drag`), menu cut, focus B, menu paste, snap both states, plus `menu` on Edit while nothing focused (dim assertions via T DIM trace). clarusc emit aborts at :2295 (quote).
- [ ] **Step 2:** Implement clarusc flag + emission; runtime build/dispatch/dim per Interfaces.
- [ ] **Step 3:** Bless scenario; verify trace shows DIM transitions and snaps show text moved between views. Gated suite + host suite green; old goldens byte-identical (rt_ui_menu_desc struct gained a field — uiprobe + all emitted descriptors must initialize it; emitui goldens for OLD fixtures change only if the emitter always emits the field — regenerate those goldens deliberately and byte-diff to confirm only the new field appears; call this out in the report).
- [ ] **Step 4:** Reference: Ch9 standard-edit paragraph gets the Undo-dimmed sentence (docs/clarus-language-reference.md ~:944).
- [ ] **Step 5:** Snapshot regen + commit `clarusc+rt_ui: standard edit menu - scrap-wired cut/copy/paste, Undo dimmed`.

### Task 4: Standard File dialogs + askSaveChanges

**Files:**
- Modify: `runtime/mac/rt_ui.h`/`rt_ui.c` (three dialog entry points; answer queue + verbs + traces), `runtime/mac/alert.r` (ALRT/DITL 130)
- Modify: `clarusc/lower.cla` (:679 → three intrinsics), `clarusc/ir.cla` (names), `clarusc/cprint.cla` (emission)
- Create: `testdata/emitui/dialogs.cla` + golden; `testdata/ui/dialogs.cla` scenario
- Regenerate: `clarusc/clarusc.c`

**Interfaces:**
- Produces:
  ```c
  int   rt_ui_ask_open(uint8_t *path255);                       /* SFGetFile, 'TEXT' filter; SetVol(NULL, reply.vRefNum); copies fName into path255; 0 on Cancel */
  int   rt_ui_ask_save(uint8_t *path255, const uint8_t *suggested); /* SFPutFile */
  short rt_ui_ask_save_changes(const uint8_t *name);            /* Alert(130) via ParamText ^0; returns 0=Save 1=Discard 2=Cancel (saveChoice values) */
  ```
  clarusc lowers `askOpen(p)` → `rt_ui_ask_open((uint8_t*)&(p))` (bool result), etc.; `askSaveChanges` result is the 16-bit enum word compared against folded constants. ALRT 130 bounds/DITL: "Save changes to “^0”?" text, buttons Save (item 1, default), Don't Save (item 2), Cancel (item 3) — item-1-minus-1 maps to the enum values.
  RT_MAC_TEST: answer queue (fixed array of {kind, Str255}) fed by script verbs `answer-open <rest-of-line path>`, `answer-save <path>`, `answer-changes save|discard|cancel`, `answer-cancel`; each consumed answer emits `T ASKOPEN <path>` / `T ASKSAVE <path>` / `T ASKCHANGES <choice>`; consuming from an empty queue → `rt_panic("scripted dialog with no queued answer")`. SF dialog positioning/filtering details stay out of test builds entirely.

- [ ] **Step 1:** Failing fixture+scenario: program calling all three (open→readText→set textview; save→writeText; saveChanges branches on all three answers); events queue answers incl. a cancel; clarusc emit aborts `call to askOpen` (quote).
- [ ] **Step 2:** Implement runtime (real + test paths), alert.r 130, clarusc lowering/emission.
- [ ] **Step 3:** Bless; trace asserts the three T ASK* lines + branch effects; file round-trip via the boot volume works under LaunchAPPL (files created beside the app; `out` capture unaffected). Gated + host suites green.
- [ ] **Step 4:** Reference Ch12 dialog subsection: confirm wording matches behavior (fill-in-place, cancel semantics); add Mac note only if behavior deviates (it shouldn't).
- [ ] **Step 5:** Snapshot regen + commit `clarusc+rt_ui: Standard File dialogs and askSaveChanges (scriptable in test builds)`.

### Task 5: App.openDocument — System 6 and System 7

**Files:**
- Modify: `clarusc/lower.cla` (:1933 fourth branch + irHasOpenDocument), `clarusc/ir.cla` (flag), `clarusc/cprint.cla` (main emission :2259-2272)
- Modify: `runtime/mac/rt_ui.h`/`rt_ui.c` (launch dispatch + AE plumbing + `launchdoc` verb)
- Modify: `scripts/build-mac.sh` (SIZE(-1) override + TEXT FREF/doc-icon in appres.r), `internal/mactest/appres_test.go` (assertions)
- Create: `testdata/emitui/opendoc.cla` + golden; `testdata/ui/opendoc.cla` scenario
- Regenerate: `clarusc/clarusc.c`

**Interfaces:**
- Produces:
  ```c
  void rt_ui_launch(void (*openDoc)(const uint8_t *path255), void (*startEmpty)(void));
  ```
  emitted in main() AFTER `handler_App_launch`, REPLACING the direct startEmpty call (openDoc/startEmpty are the generated handlers or 0; a program with neither still calls it with 0,0). Handler param convention: follow how `handler_App_startCLI` receives params (read cprint's existing emission) — openDocument's `path: string` arrives as the usual by-value Str255.
  Behavior: `RT_MAC_TEST` → pre-scan `rt_ui_test_script` for `launchdoc <rest-of-line>` lines, dispatch each to openDoc (trace `T OPENDOC <path>`), startEmpty only if none (script reader skips launchdoc lines); real build → Gestalt `gestaltAppleEventsAttr` AND own SIZE(-1) isHighLevelEventAware bit set (GetResource check) → AE mode: install AEInstallEventHandler for oapp (→startEmpty), odoc (→AEGetNthPtr FSSpec → `OpenWD(vRefNum,parID,'ERIK',&wd)`+`SetVol(NULL,wd)` → openDoc with bare name), pdoc (return errAEEventNotHandled), quit (→rt_ui_quit); event loop routes `kHighLevelEvent` → `AEProcessAppleEvent`; do NOT call startEmpty/openDoc directly (Finder's first AE decides). Else (System 6 or not AE-aware) → `CountAppFiles`: >0 → per file `SetVol(NULL, vRefNum)` (from GetAppFiles) + openDoc(fName) + `ClrAppFiles`; 0 → startEmpty.
- build-mac.sh appres.r additions (app=1): `SIZE(-1)` copied from Retro68APPL.r's shape with `isHighLevelEventAware` (and `acceptSuspendResumeEvents`? NO — keep every other flag identical to the template; only the HLE flag flips); when icon declared: `FREF 129 { 'TEXT', 1, "" }`, a static generic-document `ICN#`/`ICON` 129 (hardcoded hex block in the heredoc — dog-eared page shape), BNDL arrays extended to `{ 0, 128, 1, 129 }` both.

- [ ] **Step 1:** Failing fixture+scenario: window + `on App.startEmpty { open ... }` + `on App.openDocument(p) { ...readText into textview... }`; events with two `launchdoc` lines (one path with a space) + snap; second events variant with none (startEmpty). clarusc emit aborts `handler App.openDocument` (quote).
- [ ] **Step 2:** Implement clarusc + runtime + build-mac.sh + appres_test.
- [ ] **Step 3:** Bless (both scenario variants — two test funcs or one scenario + a `_empty` sibling); gated + host green; appres.r for a fixture with icon shows SIZE(-1)+FREF 129+BNDL extension (assert in appres_test).
- [ ] **Step 4:** Reference Ch7: Mac note — System 6 documents arrive at launch only; "dropped while running" requires System 7 (and an `app` section, which is what makes the build AE-aware).
- [ ] **Step 5:** Snapshot regen + commit `clarusc+rt_ui+build: App.openDocument - GetAppFiles on System 6, AppleEvents on System 7`.

### Task 6: Text Editor acceptance

**Files:**
- Create: `examples/texteditor.cla`, `examples/texteditor.pbm` (32×32 icon: dog-eared page with pencil, hand-drawn P1)
- Create: `testdata/ui/texteditor.events`(+variants), blessed goldens; ui_test.go funcs
- Modify: `docs/clarus-language-reference.md` (Ch8 Mac note: 32,000-byte textview cap + lastError; `scrollbar: both` horizontal no-op disclosure if Task 1 landed it that way)
- Modify: `docs/ROADMAP.md` (4c → DONE line, 4d next)

**Interfaces:** consumes everything.

- [ ] **Step 1:** `examples/texteditor.cla` = Appendix C Text Editor verbatim PLUS: an `app` section (name "Text Editor", version "1.0", author as usual, about text, icon, id "CTED"), and openPath extended with the too-large guard (readText then `if t.length > 32000 { alert(...); close d; return }` — match the example's actual variable names; the reference example itself stays untouched in the appendix and in testdata/valid/editor.cla).
- [ ] **Step 2:** Scenarios (runUIScenarioSrc against examples/texteditor.cla):
  - `texteditor`: startEmpty → type → dirty → File Save → answer-save → close (clean); reopen via launchdoc variant → content snap.
  - `texteditor_quit`: two dirty docs → Quit → first answer-changes save + answer-save, second answer-changes cancel → quit aborted (windows remain; trace) → Quit again → discard both → exit 0. (The 4b carry-over multi-window cascade fixture.)
  - `texteditor_bigfile`: launchdoc a >32,000-byte file (created by the scenario itself via writeText in a startEmpty branch, or pre-staged — pick the simplest that stays deterministic) → alert path (test-build alert goes to capture; note parseUIOutput treats unknown lines as fatal — route the assertion through whatever the harness already allows, e.g. check the trace shows the doc closed; document the choice).
  - oversize property set: fold into `texteditor_bigfile` or textwidgets scenario — assert truncation + lastError via a handler that alerts lastError.message (same capture caveat) or sets a title breadcrumb.
- [ ] **Step 3:** Bless all; FULL gated suite + host suite; existing goldens byte-identical.
- [ ] **Step 4:** Reference + ROADMAP edits.
- [ ] **Step 5:** Commit `examples: Text Editor acceptance app + scenarios; 4c reference notes`.

---

### Final validation (top-level session)

1. System 6 (Mac Plus, LaunchAPPL): real-input session — launch texteditor, type, Save via dialog, quit; relaunch, Open… the saved file; About box sanity. Screenshots.
2. System 7.1 (Mac II, Finder flow — NO LaunchAPPL, no autquit7 exists): scratch copy of `macii/MacII.app`, `MacII.rom` alongside, disk1 = `System 7.1.dsk` copy, disk2 = texteditor .dsk. Verify: launch → startEmpty; drag saved TEXT doc onto app icon → odoc opens it (both at launch and while app running); Finder Quit AE (Special > Restart triggers quit AEs — or drag-open then Cmd-Q) respects dirty-doc cancel. Screenshots. Process name is `mnvm0026` for window queries.
3. Whole-branch review (most capable model), fix wave if needed, merge only on Andrew's request.
