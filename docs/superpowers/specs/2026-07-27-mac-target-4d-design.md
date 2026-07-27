# Mac Target 4d: Forms and Data — Design

Date: 2026-07-27
Status: approved (brainstormed with Andrew)

## Goal

The fourth Mac milestone (per docs/ROADMAP.md phase re-split): bound form
windows, the `popup` widget, the `table` widget (List Manager), the `edit`
statement with `accepted`/`cancelled`/`isNew`, and `file.save`/`file.load`
record serialization — culminating in the Appendix C **Bookmark Manager**
as a shippable, double-clickable application with persistence.

The front end needs **zero work**: both compilers already parse and
type-check the entire Ch10 surface (`form for`, `binds:`, `popup`, `table`
with `rows:`/`column`, `edit`, `accepted`/`cancelled`, `isNew`,
`file.save`/`load`) at full diagnostic parity, with fixtures in
`testdata/diag/`. The work is clarusc lowering + runtime (rt_ui.c,
rt_mac.c, rt.c) + test harness + acceptance. The Go compiler stays frozen
and untouched.

Current abort sites this phase removes (all clarusc):
- `lower.cla:867` — `file.save`/`file.load`
- `lower.cla:1366` — `StEdit` (falls to generic "statement kind N")
- `lower.cla:2157` — widget kinds `popup`, `table`
- `lower.cla:2320` — `form for`
- `lower.cla:2643` — window events `accepted`/`cancelled`

## Scope decisions

- **"Real Handle-backed records" is dropped from 4d.** The reference (Ch3)
  defines records as value types ("assigned by value: the entire contents
  are copied") and the current plain-struct representation implements
  exactly that; list elements already live in Handle-backed list storage.
  The underlying concern was leaked Handles (lists, text, menus, window
  instances are never freed; plus the deferred close-leak item), which is
  a runtime hygiene problem, not a record-representation problem. A new
  roadmap phase **immediately after 4d — memory-management audit and
  cleanup** — replaces it.
- The reference's Appendix C Bookmark Manager stays verbatim; the shipped
  acceptance app `examples/bookmarks.cla` extends it with persistence
  (auto-load at launch, save on change).

## Part 0 — Shared foundation: record field-layout descriptors

For each record type used in a form window or in `file.save`/`load`,
cprint emits one static layout table: per field
`{fieldType, offset, size, enumLabels*, enumCount}` (enum label pointers
only for enum fields; labels fall back to member names, Ch3). Offsets are
`offsetof` into the emitted `clar_rec_NAME` struct, so host and Mac each
get their own correct values for free.

Both the form binding walker and the serializer interpret these tables at
runtime — validation and serialization logic each live once in the
runtime, not duplicated into every app.

## Part 1 — popup widget (rt_ui kind 6)

- **System 6 baseline (manual path):** rt_ui draws label, current item
  text, and drop-shadow box. Click → `InsertMenu(menu, -1)` +
  `PopUpMenuSelect` + `DeleteMenu`. The MenuHandle is built from the bound
  enum's labels via `AppendMenu("x")`-then-`SetItem` so label text is
  immune to Menu Manager metacharacters. Popup menu IDs allocate from
  1000 + widgetIndex, clear of app menu IDs.
- **System 7 enhancement (CDEF path):** when the existing version probe
  reports System 7+, create a real Control with `popupMenuProc` and
  replace the MenuHandle in its `popupPrivateData` (IM VI-documented
  layout) with the same programmatically built menu. Interaction,
  drawing, and value tracking then ride the standard Control machinery
  (`TrackControl`, `Draw1Control`, `GetCtlValue`/`SetCtlValue`). The
  manual path remains the golden-tested baseline; the CDEF path is
  validated live on 7.1 (same asymmetry precedent as 4c's AppleEvents
  path — the gated harness boots System 6.0.8).
- Runtime property `selected` (int, get **and set** — requires the new
  `rt_ui_widget_set_int` entry point; `rt_ui_widget_get_int` exists).
  Programmatic set does not fire `change`.
- Event `change` fires on a user pick that changes the value.
- Popup items exist only via the enum binding, so an **unbound popup is a
  loud clarusc lowering error** ("popup requires binds"). Lowering is
  clarusc-only, so frozen-frontend parity is unaffected.
- Port discipline rule (rt_ui.h) applies to every new entry point.

## Part 2 — table widget (rt_ui kind 7, List Manager)

- `LNew`: one column, `dataBounds` 1×0, `hasVScroll`, no grow box; cell
  height from the window font metrics.
- **Custom LDEF via JMP stub:** a 6-byte handle (`JMP abs.l` + C function
  address) installed as `listDefProc`. The draw routine renders all
  declared columns into the single wide cell: string/int/fixed/char as
  text, bool as a checkmark, enum as its member label. Column x-positions
  come from the widget's column descriptors (`width N` fixed;
  `width fill` computed at layout from remaining window width).
- The LDEF reads row bytes via `rt_list_at(list, row)` **on every draw**
  — never cached, since any list growth invalidates the pointer.
- Column headers are drawn by rt_ui in a header strip above the list
  view (LM has no header concept); the strip participates in layout and
  resize.
- **Liveness:** no Clarus code runs outside handlers, so after every
  handler dispatch rt_ui re-syncs each visible table: compare
  `rt_list.count` to LM row count, `LAddRow`/`LDelRow` the difference,
  and invalidate the view rect. O(visible), no mutation instrumentation.
- Selection: single-select. `selected` int property ↔
  `LGetSelect`/`LSetSelect`, −1 when nothing selected; settable.
- Events: `LClick`'s Boolean return distinguishes `doubleClick(i)` from
  `select(i)` — two new widget event codes carrying the row index.
- Resize: `LSize` + header strip relayout; participates in `fill`.
- New parallel winst arrays (ListHandle, per the existing pattern) with
  allocation in `rt_ui_open` and disposal in `rt_ui_close_internal`.

## Part 3 — modal forms and the edit statement

- **Modality is a filter flag**, not a nested event loop: rt_ui state
  gains `modalInst`. While set: clicks in other app windows and the menu
  bar beep; everything else (update/activate events, `every` timers, TE
  idle) runs unchanged in the single WaitNextEvent loop. The scripted
  harness needs no twin because scripts drive the same dispatch
  functions. A second `edit` while a modal is up is a runtime panic.
- Form windows open as `movableDBoxProc`. `button X { default }` draws
  the default-button ring and wires Return/Enter; `{ cancel }` wires
  Escape (and Cmd-period).
- `edit Form, target` lowering emits:
  1. Evaluate `target`; copy it into the form's working buffer (a
     `clar_rec_T` in the form's per-instance state).
  2. Record a **writeback descriptor** — tagged union: address (global or
     window-state var), `(rt_list*, index)`, or `(rt_map*, key copy)`.
     List/map targets are re-derived and bounds-checked at writeback
     time, since timers can mutate collections while the form is up; a
     vanished target (index out of range, key removed) drops the
     writeback but still fires `accepted` with the buffer.
  3. `new T` → default-initialized buffer, no writeback, isNew flag set.
  4. Fill widgets from the buffer via the binding walker; open modal.
- **Binding walker** (runtime, driven by Part 0 layout tables plus a
  per-form binding table `{widgetIndex, fieldIndex}`):
  - Fill: field ← formatted field value; check ← bool; popup ←
    enum ordinal.
  - Typing filters: int fields accept digits and a leading `-`; fixed
    adds `.`; `string(n)` fields clamp length at n (TE keystroke gate).
  - OK validation, declaration order: int/fixed must parse (empty or
    malformed fails); check/popup/string always valid by construction.
    First failure: beep, focus + select-all that field, stay open.
  - Writeback: parse each bound widget into the buffer, then apply the
    writeback descriptor.
- `accepted(rec: T)` fires after writeback with the buffer; `cancelled`
  fires on Cancel/Escape after discarding. Close box on a form window
  acts as Cancel.
- **isNew:** no hidden struct field. The modal state carries the flag;
  `b.isNew` lowers to it **only when `b` names the enclosing `accepted`
  handler's parameter** — the spec's only defined use. Any other `isNew`
  read (on a record without a literal `isNew` field) becomes a loud
  `lowUnsupported`, fixing the current clarusc defect where `lowSelect`
  emits uncompilable C (`lower.cla:1119`; Go already diagnoses this,
  `internal/lower/expr.go:522`).

## Part 4 — file.save / file.load

- **Canonical big-endian, field-wise format** — identical bytes from host
  and Mac builds, so serialization gets cheap host-side golden tests:
  - Header: magic `'CLRS'`, format version byte (1), then the payload.
  - Record: each field in declaration order — int/fixed/enum as 4-byte
    big-endian, bool/char as 1 byte, `string(n)` as 1 length byte +
    exactly n data bytes (fixed width, so layout is version-checkable).
  - `list of R`: 4-byte count + that many records.
  - `map of R`: 4-byte count + entries (1 length byte + key bytes +
    record) in key order.
- Implemented once per runtime: `rt_file_save`/`rt_file_load` in rt.c
  (host, stdio) and rt_mac.c (FSOpen/FSWrite, type `'CLRD'`, creator from
  the app section), both driven by the Part 0 layout tables.
- `load` fills in place (clearing list/map first); short read, bad magic,
  or version mismatch → `false` + `lastError`; the target is left in a
  defined state (empty collection / default record).
- Record fields of reference type (`text`, `list`, `map`), if the checker
  admits them at all, are a loud clarusc lowering error for save/load.
- Mac file type for saved data files is `'CLRD'` so documents (`'TEXT'`)
  and data files stay distinguishable in the Finder.

## Part 5 — test harness extensions

- New script verbs: `dblclick X Y` (synthetic double-click) and
  `answer-popup N` (pre-queued popup pick, consumed when a click hits a
  popup — same sanctioned-bypass pattern as the existing TrackControl and
  Alert bypasses, since `PopUpMenuSelect`/`TrackControl` block the script
  reader).
- New trace helper `trace_set_int` (`T SET Win.W.selected N`);
  `rt_ui_prop_name` already knows `selected`.
- New gated UI scenarios (testdata/ui + blessed goldens): popup pick via
  both paths' shared dispatch, table select/doubleClick/live add-remove,
  edit accept with writeback, edit cancel, validation-failure beep+focus,
  save→quit→relaunch→load round trip.
- Host-side Go tests: serializer byte-goldens (compile fixture with
  clarusc host build, run, compare emitted file bytes), plus emit goldens
  (testdata/emitui) for form/table/popup lowering shapes.

## Part 6 — acceptance: the Bookmark Manager

`examples/bookmarks.cla`: the Appendix C example verbatim, plus
persistence — `file.load("Bookmarks Data", bookmarks)` on
`App.startEmpty` (ignore `false`: first launch), `file.save` after
`accepted` and `Remove.click`. Built with `scripts/build-mac.sh`,
double-clickable, About box via the existing `app` section.

Acceptance checklist (live, real input, System 6.0.8 and 7.1):
- Add via form (popup + check + validation), edit via double-click, remove.
- Table redraws live on add/edit/remove; selection behaves; `width fill`
  column tracks window resize.
- Port field rejects non-numeric input at OK with beep+focus.
- Quit, relaunch: bookmarks restored from disk.
- System 7: popup renders via the CDEF path.

## Part 7 — documentation

Doc-first (reference edits land before implementation), covering the
three contract clarifications this design introduces:
1. Unbound `popup` (no `binds:`) is rejected at build time.
2. `file.save`/`load` require records of value-type fields only.
3. `isNew` is defined only on the `accepted` handler's parameter.

Roadmap: mark 4d in progress; insert the post-4d **memory-management
audit** phase (Handle/close leaks: lists, text, menus, window instances,
the deferred ClosePort item).

## Settled during planning (not blocking design approval)

- Whether a `window` without `size:` (the appendix's `EditForm`) already
  derives its size from layout, or natural sizing must be added.
- Exact `lastError` codes for load failures (bad magic vs short read vs
  version).
- LDEF JMP-stub cache-flush needs on 68030+ (likely none for Mini vMac's
  68000; verify against Retro68 conventions).
