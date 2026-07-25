# Mac Target 4c: Text Editing — Design

Date: 2026-07-25
Status: approved (brainstormed with Andrew)

## Goal

The third Mac milestone (per docs/ROADMAP.md phase re-split): TextEdit-backed
text widgets, the standard Edit menu, Standard File dialogs, and
`App.openDocument` — culminating in the Appendix C **Text Editor** as a
shippable, double-clickable application. This also discharges the 4b
carry-over items that need a multi-document app (quit-cascade multi-window
fixture; activate-time HiliteControl tracking).

The front end needs **zero work**: clarusc's checker already validates
`textview`/`field` declarations and properties, `standard edit`,
`askOpen`/`askSave`/`askSaveChanges`, `saveChoice`, and `App.openDocument`
(v1 parity port). `file.readText`/`writeText`/`name` exist on both runtimes
(4a). `rt_ui_set_title` exists (4b). The work is lowering (clarusc) +
runtime (rt_ui.c / rt_mac.c) + build (SIZE resource) + tests + acceptance.

Out of scope (4d): `binds`/form windows, `popup`, `table`/List Manager,
`file.save`/`load` of records. The Go compiler stays frozen.

## Part 1 — TextEdit widgets (rt_ui.c)

Each `textview`/`field` instance owns a TE record (`TENew`) stored in the
window's widget state.

**textview** (`at`, `fill`, `scrollbar: vertical|both`):
- Bordered rect from the Ch8 layout engine, view/dest rects inset for the
  frame (and scrollbar lane when declared).
- Optional vertical scrollbar: a Control Manager scrollbar glued to the TE
  via `TEScroll`, range recomputed from `nLines`×`lineHeight` on every
  content change and resize. (`scrollbar: both` reserves the horizontal
  lane; horizontal scrolling itself may no-op in v1 with word-wrap on —
  disclose in the reference if so.)
- Runtime property `text` (type `text`): get copies the TE handle's bytes
  out into an `rt_text`; **set clamps at 32,000 bytes** (TE offsets are
  signed shorts; 32,767 is the hard ceiling and the margin keeps
  Toolbox-internal `short` arithmetic away from overflow). A clamped set
  **sets `lastError`** so careful programs can detect truncation.
- Event: `change` — fires on any content mutation (typing, cut, paste,
  clear), not on selection movement.

**field** (`label`, `at`, `width`; standalone only — `binds` is 4d):
- Single-line TE with the label drawn like `label` widgets; no scrollbar.
- Runtime property `text` (type `string`): Str255-bounded both ways.
- Events: `change` (as above) and `enter` (Return/Enter pressed; the key
  does not insert a newline in a field).

**Focus and typing** (shared machinery):
- Click-to-focus: one focused TE per window; clicks route via `TEClick`
  (shift-extends). Focus switch = `TEDeactivate` old + `TEActivate` new.
- Window activate/deactivate events toggle the focused TE's caret state;
  `TEIdle` runs in the event loop for caret blink.
- `TEKey` handles typing; every mutation path enforces the 32,000 cap
  (clamp + `lastError`, silently dropping input past the cap).
- The 4b carry-over "activate-time HiliteControl needs logically-enabled
  tracking" is fixed here — same activate-event plumbing.

Mutations through cut/paste/typing keep the scrollbar range and `dirty`
paths honest by funneling through one post-mutation hook (recompute
scroll, fire `change`).

## Part 2 — `standard edit` menu

- Lowering marks the menu descriptor as standard-edit (the parser already
  produces the DkMenuEntry variant); the runtime builds the items itself:
  Undo (⌘Z), separator, Cut (⌘X), Copy (⌘C), Paste (⌘V), Clear.
- **Undo is permanently dimmed** — classic TE has no undo; this is what
  period System 6 apps did. One honest sentence in the reference; a real
  undo buffer can land later without breaking anything.
- Cut/Copy/Paste/Clear act on the focused TE (`TECut`/`TECopy`/`TEPaste`/
  `TEDelete`), with real desk scrap sync (`ZeroScrap` + `TEToScrap` after
  cut/copy, `TEFromScrap` before paste) so the clipboard works across
  applications and DAs.
- When a desk accessory is frontmost, `SystemEdit` gets first refusal —
  the historical reason this menu is required boilerplate.
- Item dimming: Cut/Copy/Clear need a focused TE with a non-empty
  selection is over-fine for v1 — dim Cut/Copy/Paste/Clear when no TE is
  focused in the front window; leave them enabled otherwise. (Selection-
  aware dimming is a later polish; disclosed.)
- Paste respects the 32,000 cap (clamp + `lastError`).

## Part 3 — Standard File + askSaveChanges

- `askOpen(path)` → `SFGetFile` filtered to `'TEXT'`, fills `path`
  (working-directory-qualified so `file.readText` opens it), returns
  false on Cancel.
- `askSave(path, suggested)` → `SFPutFile` pre-filled with `suggested`.
- `askSaveChanges(name)` → new 3-button alert (ALRT/DITL 130 in
  runtime/mac/alert.r): "Save changes to “^0”?", buttons Save /
  Don't Save / Cancel, returning the built-in `saveChoice` enum.
- **RT_MAC_TEST builds are script-driven, never modal** (About-trace
  precedent): new event-script verbs queue answers ahead of time —
  `answer-open <path>`, `answer-save <path>`, `answer-changes
  save|discard|cancel`, and `answer-cancel` (for open/save Cancel).
  Each consumed answer emits a trace line (`T ASKOPEN <path>` etc.);
  an unanswered dialog in a test build is a scripted-run failure (loud),
  never a hang.
- Files written/read by scenarios live on the test boot volume; the
  harness already captures byte-exact output via the trace/snap stream.

## Part 4 — App.openDocument (System 6 AND System 7)

Startup does a Gestalt check for the Apple Event Manager
(`gestaltAppleEventsAttr`); the runtime enables what the host OS provides:

- **System 6 path** (no AppleEvents): `CountAppFiles`/`GetAppFiles`/
  `ClrAppFiles` at launch; one `App.openDocument(path)` dispatch per file
  (full path built from the vRefNum); `App.startEmpty` suppressed when
  documents were provided.
- **System 7+ path**: the SIZE resource declares `isHighLevelEventAware`
  (emitted via build-mac.sh's appres.r generation; SIZE flags verified
  against Retro68's template at plan time); the runtime installs the
  required suite — `oapp` → `startEmpty`, `odoc` → `openDocument` (fires
  at launch AND while running: double-clicked docs and drag-onto-running-
  app), `quit` → the existing 4b quit cascade. The WaitNextEvent loop
  routes `kHighLevelEvent` to `AEProcessAppleEvent`. `pdoc` replies
  errAEEventNotHandled (no printing).
- Reference Ch7 gets a Mac note: "dropped on it while running" requires
  System 7; on System 6 documents arrive at launch only.

**Finder document wiring** (needed to exercise odoc manually):
build-mac.sh's generated BNDL gains a second FREF for `'TEXT'` documents
(generic document icon) when the app declares an icon/id, so the Finder
accepts dropping a text file onto the app icon — the odoc trigger. 4a's
`file.writeText` output type/creator gets checked at plan time; type must
be `'TEXT'` (creator may stay generic — drag-onto-icon does not require a
creator match, and full doc-creator stamping is the Ch12 document-type
declaration, deferred).

**Verification**: the deterministic gated harness stays on the System 6
Mac Plus (Mini vMac, existing LaunchAPPL config) — launch-docs covered by
a test-script verb that injects launch documents. System 7 behavior
(odoc at launch and while running via drag-onto-icon, AE quit) is
verified manually on the new Mac II emulator (`macii/MacII.app` +
`macii/System 7.1.dsk`) with the standard screenshot workflow.

## Part 5 — clarusc lowering (clarusc-only; snapshot regen)

- Widget kinds `field`/`textview` lowered into the descriptor tables
  (new RTUI widget-kind constants + their props: label/width/fill/
  scrollbar), and their handler entries (change/enter) into the dispatch
  tables — same shape as button/check/canvas/label from 4b.
- `textview.text` (text) and `field.text` (string) property reads/writes
  → new rt_ui get/set calls; `window.title` set already works (4b).
- Standard-edit menus lowered as a flagged menu descriptor (no items).
- Builtins `askOpen`/`askSave`/`askSaveChanges` lowered to rt_ui calls
  (fill-in-place runtime calling convention per Ch6; `saveChoice` result
  is the 16-bit enum word). These are Mac-only: the frozen Go host
  backend already rejects them for host builds, and clarusc host emit
  keeps whatever behavior v2 shipped (verify at plan time; do not
  regress differential parity).
- `App.openDocument` handlers registered into the generated startup so
  the runtime can dispatch launch/odoc documents into user code.
- Fixtures: `testdata/emitui/` goldens (textview/field/standard-edit/
  dialog-builtin emission) + `clarusc/test` check goldens only if any
  checker gap surfaces (none expected).

## Part 6 — Acceptance and tests

- **examples/texteditor.cla**: the Appendix C Text Editor verbatim
  (modulo an `app` section with name/version/author/about/icon/id —
  4c's example ships with full app identity like Mandelbrot), openPath
  extended with the documented too-large check (readText then length
  check > 32,000 → alert, close) so the shipped example never silently
  truncates.
- UI scenarios (gated, System 6, blessed trace + PBM snaps — TE renders
  deterministically in Chicago):
  - typing/focus: two fields + textview; click focus changes, type, snap;
    `enter` on field; `change` traces.
  - edit menu: cut/copy/paste round-trip through the real scrap between
    two textviews; Undo dimmed; items dim with no focus.
  - dialogs: answer-verbs drive askOpen/askSave/askSaveChanges incl.
    Cancel paths; traces assert the fill-ins.
  - texteditor lifecycle: launch-doc injection → openDocument; edit →
    dirty → close → save-changes Save/Cancel/Discard; **multi-window
    quit cascade with one cancel** (the 4b carry-over fixture).
  - oversize set: assign > 32,000 bytes → truncated content + lastError
    trace.
- Manual acceptance: real-input Text Editor session on Mac Plus/System 6
  (create, edit, save, reopen via Finder double-click of the saved TEXT
  doc if creator/type wiring from the `app` section permits — else via
  askOpen) AND on Mac II/System 7.1 (odoc at launch, odoc while running
  via drag-onto-running-app, AE quit), screenshots both.

## Risks / verify-at-plan-time

- Retro68's SIZE resource handling (does the template emit one; can
  appres.r add/override with `isHighLevelEventAware` without duplicate-ID
  conflict).
- SFGetFile/SFPutFile reply paths on System 6 use vRefNum working
  directories — path strings handed to `file.readText` must round-trip
  (rt_mac.c's existing path handling decides the join strategy).
- Mac II emulator app/process name for the screenshot workflow (may
  differ from `minivmac`).
- TE in an inactive window vs. scroll-without-focus interactions
  (TEScroll works while deactivated; verify caret/hilite behavior).

## Non-goals

- Undo implementation (dimmed item only).
- Selection-aware Edit-menu dimming (coarse focus-based dimming in v1).
- Horizontal scrolling in textviews (word-wrap on; `scrollbar: both`
  reserves the lane at most — disclosed).
- Styled text (TextEdit styles, fonts) — plain Chicago only.
- System 7 'pdoc' printing, stationery, or any AE beyond the required
  suite.
