# UI widgets batch for 68kBBS (spec, 2026-10-25)

Status: **design, not started.** Source of the request:
`../m68k-bbs/docs/clarus-ui-requirements.md` (2026-10-24), "the
requirements" below; its section numbers are cited as R1..R9. The
requirements' syntax is a proposal: where this spec differs, this spec
wins, and every difference is listed in §2.

Anchors below are as of `main` at `9121955a` (v1.1). Language version
after this phase: **1.2** (`claruscVersion`, ClarusC.APPL's `version:`
literal, a `## 1.2` changelog section).

## 1. Goal and exit

68kBBS rebuilds its main window (three label pairs, a callers table, a
log, separated by rules, laid out by its own `opened`/`resized`
handlers) from real widgets, and drops its hand-drawn log canvas, its
`list of string` log ring and its dim-the-active-menu-item workaround.
Every existing Clarus program compiles and behaves as before, except
the two deliberate visible changes in §2 (Select All, literal menu
captions).

**Exit:**
- Every item R1-R9 behaves as in §3 on the native `emit68k` lane, and
  **compiles** through the cprint/Retro68 C lane (C14): both lanes
  share the `runtime/clarus/ui*.cla` sources, so the C lane needs a
  cprint arm per new intrinsic and an `rt_ext_Ui*` shim per new trap in
  `runtime/mac/rt_ext_mac.inc`; the `testdata/emitui` goldens are the
  evidence. No C-lane boot is required.
- New `testsuite/toolbox` cases (§5) pass in `mactest/toolbox_68k`.
- T1 and T2 pass; `tests/memgate/budget.txt` and
  `tests/mactest/snow/se_floor.txt` are not loosened (a program that
  uses none of the new features, ClarusC.APPL included, may grow only
  by the always-linked pieces listed in §4.9, and the SE floor must
  still pass); `CLARUS_SNOW_TESTS=1 make test T=mactest/snow/clarusc_bake`
  passes on the SE (the standing rule, since ClarusC.APPL is a UI
  program and its runtime changes).
- Reference (Ch8-11, Appendix A grammar, Appendix B events) and
  changelog updated.

## 2. Decisions

Andrew's, in this conversation (2026-10-25):

| #   | Decision |
|-----|----------|
| D1  | The whole batch R1-R9 is one phase. |
| D2  | R9 (literal menu captions) is in: `AppendMenu` metacharacters are a Toolbox detail leaking through a plain Clarus string. |
| D3  | A table's selection follows its **record** across list mutations (an `unshift` keeps the same caller highlighted), not its row number. Other apps will need this too. |
| D4  | `standard edit` gains **Select All** (Cmd-A) in every program, working in fields, textviews and logpanels. |
| D5  | Labels must not use a live TextEdit record (no editability, no per-update re-wrap cost). Resolved by §3.3: labels stop using `TETextBox` too and draw with `DrawText`. |
| D6  | `setStyle` **replaces** the whole style; the style words are `plain`, `bold`, `italic`, `underline`; `setStyle(plain)` clears. No `clearStyle()`. `style: plain` is legal in declarations. |

Mine (Claude's calls; Andrew may override while reading):

| #   | Call |
|-----|------|
| C1  | **No host UI lane is built.** No window/menu program builds for `runtime/host` today (`cprint.cla` includes the Mac-only `rt_ui.h` for any UI program), and 68kBBS's host tests include only its pure modules, never `bbs.cla`. R7's "host lane" therefore means: both Mac lanes compile everything; scripted (`--events`) builds record the new property writes in the UI trace like existing ones. |
| C2  | Bound-table refresh uses a small runtime registry of **observed** list boxes (one entry per bound table: box, change counter, tracked index), maintained by the list operations only when the registry is non-empty (§4.5). The list box itself does not grow: an earlier draft added 8 bytes to every list, which the builder check showed would break the memgate budgets and the SE floor (the compiler holds thousands of list boxes). |
| C3  | `setBounds` is deferred: it records the rect; the runtime applies every pending rect after the handler returns, with one invalidate pass and one update-event paint (§4.2). |
| C4  | LogPanel and formatted-column runtime code is linked only into programs that use them, through compiler-synthesized dispatchers (the `UiTableRows` -> `clar_ui_fire_staterows` pattern), so ClarusC.APPL and other non-users don't pay for them. |
| C5  | Formatted-column error policy: an `abort` raised inside a column's function is contained: that cell draws empty and the first such abort per column per window instance is logged once. A runtime error (Ch3 "Runtime Errors": index out of range, divide by zero...) stays fatal, as it is everywhere else in Clarus; panics are not recoverable and this phase does not make them so. |
| C6  | Column alignment uses the column grammar's existing no-colon style: `column "Time" shows durationStr(secs) width fill align right`. Widget-level alignment (labels) uses `align: right`. |
| C7  | `style:` is keyed per kind: text widgets take font styles (`plain`/`bold`/`italic`/`underline`); `divider` takes `single`/`double`. |
| C8  | `font:` on `button`, `check` or `popup` is a check-time error ("buttons, checks and popups use the system font"). `height:` on `field`, `button`, `check`, `popup` is accepted and ignored at declaration (natural height kept); `setBounds` on them moves and sets width but keeps natural height. Reference says so. |
| C9  | LogPanel lines are `string`s (at most 255 bytes, like any Clarus `string`); `maxLines:` defaults to **200**; drawing clips. |
| C10 | Select All in a textview/field is `TESetSelect(0, 32767)`. |
| C11 | Fix the pre-existing bug found in recon: `uiblob.cla:1013` drops every non-`standard edit` entry of a menu that also contains `standard edit` (the checker allows mixing). The menu keeps both, in declaration order. |
| C12 | Submenus must be declared above the menu that uses them (same single-pass rule as a window's `menus:`). A menu used as a submenu never appears in the menu bar and cannot also be named in a window's `menus:` (check error). |
| C14 | The cprint/Retro68 C lane is held to **compiles** (emitui goldens), not booted: it is an opt-in diagnostic lane slated for retirement, its toolbox suite twin no longer builds, and no gate boots a cprint UI program today. C-lane arms are folded into each feature task, not a separate track. |
| C13 | Window `contentWidth`/`contentHeight` are reachable through a window reference (`m.contentWidth`) and bare inside that window's own `extend` handlers, like `title`. A user global of the same name is shadowed inside handlers, as `title` already is. |

## 3. Behavior

### 3.1 Widget geometry (R1)

- **`height: N`** on every widget kind. `canvas`, `textview`, `table`,
  `logpanel`, `label`, `divider` honor it. `field`, `button`, `check`,
  `popup` keep their natural height (C8). Kinds that lack `width:`
  today (`textview`, `canvas`, `table`) gain it.
- **Read-only `x`, `y`, `width`, `height`** (`int`, window content
  coordinates) on every widget. `width`/`height` exist on canvas today;
  the others are new. Assigning any of them is a check error
  (`readOnlyPropName` gains the widget cases; today a write passes the
  checker and dies in lowering).
- **`w.X.setBounds(x, y, width, height)`**, a statement, any handler.
  Negative sizes clamp to 0; a 0-size widget draws nothing and takes
  no clicks. From the first call on, the widget is **placed by code**:
  the automatic relayout (window resize, zoom) never moves it again.
  Widgets never given `setBounds` keep today's layout, and a later
  auto/`next`/`right`-placed widget measures from a code-placed
  widget's current rect.
- **Deferred apply (C3).** `setBounds` stores the rect and marks the
  window "geometry pending". The properties read back the new values
  immediately. When control returns to the event loop (after the
  handler, before the next event), the runtime applies every pending
  rect: per widget, invalidates old rect ∪ new rect, then repositions
  without drawing (controls hidden around `MoveControl`/`SizeControl`
  or the port clipped empty; TE viewRect/destRect + `TECalText`; table
  rView + `LSize` + cellSize; buffered canvas realloc only when its
  size actually changed). The window then paints once in its update
  event. Calling `setBounds` on every widget from `resized` must not
  flicker; that includes the resize path's own relayout running first
  (§4.2 orders them so the runtime relayout skips code-placed widgets
  and no control is drawn twice).
- **Window `contentWidth`, `contentHeight`** (read-only `int`): the
  port rect's size, the area widgets live in (C13).
- **Tables honor width** (R1.4): the compiler stops forcing
  `widthIsFill` on tables (`lower.cla:6225`); a table without `width:`
  keeps today's fill behavior, so existing programs are unchanged.
  (Builder: confirm by golden that no existing table changes size.)
- `opened` runs before the window's first update, so a layout done in
  `opened` paints once.

Target usage (R1.5) must compile and behave as written:

```rust
extend Main {
    on opened { layoutMain(window) }
    on resized { layoutMain(window) }
}
func layoutMain(m: Main) {
    var w: int = m.contentWidth
    var h: int = m.contentHeight
    var top: int = h / 2
    m.Callers.setBounds(161, 0, w - 161, top)
    m.TopRule.setBounds(0, top, w, 3)
    m.SideRule.setBounds(160, 0, 1, top)
    m.Log.setBounds(0, top + 3, w, h - top - 3)
}
```

(`window` is the handler's own instance, reference Ch8 "Window
Instances".)

### 3.2 Fonts (R2)

- **Declaration:** `font: "Name", size` and `style: w1, w2...` (words
  from `plain`, `bold`, `italic`, `underline`; D6) on `label`, `field`,
  `textview`, `table` (rows and header), `canvas`, `logpanel`. The name
  resolves with `GetFNum` at window open; an unknown name (GetFNum
  returns 0 for a non-system name) falls back to the application font
  (`applFont`, Geneva), silently. `font:` is checked: a string literal
  and an int literal 1..127. `style:` with an unknown word is a check
  error. `font:`/`style:` on a button/check/popup is a check error
  (C8).
- **Runtime:** `w.X.setFont(name: string, size: int)` and
  `w.X.setStyle(s...)` with the same words (D6; one to three words,
  `plain` only alone). The style words are contextual: valid only as
  `style:` values and `setStyle` arguments, never general identifiers
  (they shadow nothing). Each call redraws the widget; for table and
  logpanel it recomputes the row/line height from `GetFontInfo`
  (table: cellSize.v plus header height; today cellSize.v is set only
  at `LNew`).
- **Per-widget fonts on a shared port:** every non-TE widget (label,
  table header and LDEF rows, field label lane, logpanel, unbuffered
  canvas) draws through the window's GrafPort, so each draw site sets
  TextFont/TextSize/TextFace before drawing and restores the window's
  defaults after. TE widgets (field, textview) set the TERec's
  txFont/txSize/txFace, line height and ascent, then `TECalText`.
- **Canvas (R2.4, the old TODO item "Language: canvas text font"):**
  the font is stored per canvas and reapplied every time the offscreen
  GrafPort is recreated (each resize; `OpenPort` resets fonts).
  `drawText`, `textWidth`, `lineHeight` and `ascent` use it. An
  unbuffered canvas sets/restores around each drawing call like any
  other non-TE widget. Remove the TODO item when done.

### 3.3 Label (R3)

- Draws with `DrawText` (no `TETextBox`, no TERec, no allocation per
  draw), single line, clipped to its rect, vertically placed at the
  font's ascent from the top (centered in the rect when `height:` is
  taller than one line: builder's choice, documented).
- `align: left | center | right`, default `left`; aligns within the
  rect using `StringWidth`.
- Assigning the text it already shows is a **no-op**: no trace line,
  no erase, no draw, no `ValidRect`. (Today it always traces, erases,
  draws and `ValidRect`s, which also cancels any other pending update
  under it.) An unchanged label driven from a 1-second timer costs one
  string compare.
- Labels are never editable and take no clicks (true today; unchanged).

### 3.4 LogPanel (R4)

New widget kind `logpanel`:

```
logpanel Log { maxLines: 100; font: "Monaco", 9; scrollbar: both; fill: both }
```

- Properties: `maxLines:` (int literal ≥ 1, default 200), `scrollbar:
  vertical | both` (default vertical), `at`, `width`, `height`, `fill`,
  `font`, `style`.
- Members:

| Member            | Meaning |
|-------------------|---------|
| `appendLine(s)`   | Add `s` (`string`). Each CR or LF in `s` ends a line (CRLF counts once); empty lines are kept; a trailing CR/LF does not add an empty line after it. |
| `clear()`         | Drop every line; clears the selection. |
| `lineCount`       | Lines held (`int`, read-only). |
| `line(i)`         | Line `i` (`string`), 0 = oldest. Out of range is a runtime error ("logpanel line out of range"), as for lists. |
| `scrollToEnd()`   | Scroll so the last line is visible; resumes following. |

- **Storage:** one relocatable handle holding the lines as a ring of
  length-prefixed bytes plus one offset table (builder picks the exact
  layout); each line costs its length + a small fixed overhead, never
  256. Past `maxLines`, the oldest line is dropped. If growing the
  handle fails, oldest lines are dropped until the new line fits; an
  append never aborts or panics. State lives in per-instance storage
  (§4.1), never module globals (A5 globals are never shaken).
- **No TextEdit**, no 32,000-byte limit; only visible lines are drawn.
- **Batching:** appends mark the panel dirty; the screen is updated
  once per event-loop pass at the same point buffered canvases flush
  (`ui.cla:2761`), however many lines were appended.
- **Following:** a panel is "following" when its last line is in view.
  While following, appends keep the end in view; when exactly the
  newly arrived lines need to come into view and fewer than a
  panel-height of them arrived, the panel scrolls with `ScrollRect`
  and draws only the new lines (no full repaint). More than a page:
  repaint. When the user has scrolled up, appends do not move the
  view; the scrollbar max/thumb update; lines dropped off the top
  shift the scroll position by the number dropped so the same text
  stays on screen (clamped at 0). Scrolling back to the bottom
  resumes following. `scrollbar: both` adds a horizontal bar whose
  range is the widest line held (pixel width in the panel's font;
  builder may track a running max and recompute only when the widest
  line drops off).
- **Selection (whole lines):** click selects one line; drag or
  shift-click extends a contiguous range; selected lines draw
  inverted. Appends leave the selection on the same lines; dropped
  lines shrink it, and it clears when all its lines drop. `clear()`
  clears it.
- **Focus and Edit menu:** clicking the panel makes it the window's
  edit focus (the role `focusIdx` plays for fields/textviews today;
  §4.6). With a logpanel focused: Copy is enabled iff it has a
  selection, and puts the selected lines joined with CR (no trailing
  CR) on the scrap as `TEXT` (`ZeroScrap` + `PutScrap`); Select All
  (enabled when it has lines) selects every line; Cut, Paste, Clear
  are disabled. Keystrokes to a focused logpanel are ignored (no
  `TEKey`). No caret, so a focused logpanel does not force the event
  loop's 1-tick sleep.
- **Events:** none in this phase.
- **Trace (scripted builds):** `appendLine`/`clear` are not traced per
  call (a log would flood the trace); selection changes and Copy are
  traced like other UI actions (builder picks the line shapes, in the
  existing `T ...` vocabulary).

### 3.5 Table (R5)

- **Formatted columns (R5.1):** `shows` takes either a row field name
  (today) or a call to a user function: `shows shortDateTime(connected)`.
  Row fields are in scope bare inside the call's arguments; other
  arguments may be literals and globals. The callee must be a
  top-level user `func` with a result; the result type follows the
  existing column rules (string as-is; int/narrow ints/fixed/bool/
  char/enum rendered as today). Anything else (a method call, an
  operator expression at the top, a call returning `text`/list/record)
  is a check error. Evaluated at draw time for visible rows only.
  Errors: C5.
- **Column `align left|center|right`** (C6), default left; the header
  text follows its column's alignment.
- **Every list mutation refreshes the bound table (R5.3)**: `add`/
  `push`, `pop`, `shift`, `unshift`, `remove`, `clear`, `release`,
  `reserve` (no visible change, but harmless), `shrink`, `l[i] = v`,
  field writes through an element (`l[i].name = x`), whole-list
  reassignment of the bound global, and `edit` writeback. Small
  tables: invalidating the whole table on any change is fine.
  Detection: §4.5.
- **Selection follows the record (D3):** after `unshift`, the same
  record stays highlighted at its new index; removing the selected
  record (by `pop`, `shift`, `remove`, `clear`, `release`) sets
  `selected` to -1. A record replaced in place by `l[i] = v` keeps the
  selection on index `i`. Whole-list reassignment clears it.
  Programmatic changes never fire `select`.
- **`scrollTo(i)`** (statement): make row `i` visible (`LScroll`);
  `scrollTo(0)` scrolls to the top. Out-of-range `i` clamps (not an
  error).
- **`selected` writable**: assigning `-1` clears, `i` selects (clamped
  as today). Never fires `select`. Already works in lowering
  (`lower.cla:4742`); confirm, document, test.
- `font:`/`style:` apply to rows and header (§3.2).

### 3.6 Divider (R6)

```
divider TopRule  { style: double }
divider SideRule { }
```

Horizontal when its rect is wider than tall, vertical otherwise.
`style: single` (default) draws a 1-pixel line along the rect's
center line; `double` draws two 1-pixel lines with a 1-pixel gap
(intended for a 3-pixel-thick rect). No events, no runtime members
beyond geometry. Positioned with `at`/`width`/`height`/`fill`/
`setBounds`.

### 3.7 Menu checkmarks and submenus (R7)

- **Checkmarks:** `item Speed9600 "9600" checked` (declared) and
  runtime `Modem.Speed9600.checked = b` (`CheckItem`), readable too.
  (Today `.enabled` is assignment-only; reading `.enabled` gains a
  lowering at the same time, since the checker already accepts it.)
- **Submenus:** `item PortSpeed "Port Speed" submenu Speed`, where
  `Speed` is a declared `menu` above (C12). The submenu is inserted
  with `InsertMenu(m, -1)`, its parent item gets cmd `0x1B` and mark =
  the submenu's ID, it never appears in the menu bar, and its items'
  `on Speed.S9600.select` handlers dispatch as for any menu. It counts
  toward the existing 31-menu limit. Menu IDs stay `2 + declIndex`
  (inside the hierarchical 1..235 range). A menu may be the submenu of
  at most one item; nesting deeper than one level is allowed if it
  falls out for free, otherwise a check error (builder's choice,
  documented). Hierarchical menus work on System 6 (64K ROM excluded;
  Plus and later) and System 7 without a Gestalt check.

### 3.8 Canvas text measurement (R8)

- `c.textWidth(s: string): int` (`StringWidth` in the canvas's font).
- `c.lineHeight` (ascent + descent + leading) and `c.ascent`, read-only
  `int`s from `GetFontInfo` in the canvas's font. `drawText`'s `y` is
  the baseline (unchanged), so text whose top is at `t` draws at
  `t + c.ascent`.

### 3.9 Literal menu captions (R9, D2)

Every item caption is shown exactly as written: append a placeholder
item (carrying `/key` when the item has one), then `SetMenuItemText`
(SetItem) the real caption, the popup builder's existing pattern
(`uiwidgets.cla:773`). Applies to declared menus and to the Apple
menu's "About" item if it takes a user string. `( / ^ ! < ;` all show
literally. Remove 68kBBS's "no `(` in captions" rule (note it in the
changelog).

### 3.10 Select All (D4)

`standard edit` becomes Undo, -, Cut, Copy, Paste, Clear, **Select All
(Cmd-A)**. Enabled when the focus is a field/textview (selects all
text, C10) or a logpanel with lines. The hard-coded item indices in
`rtUiMenuRecomputeDim` and `rtUiStdEditDispatch` (`ui.cla:1468-1548`)
and the std-edit dim trace change; the affected goldens are reblessed.

## 4. Implementation notes (where it lands)

Recon map (runtime and compiler) is summarized here; file:line anchors
are at `9121955a`.

### 4.1 Descriptor blob and per-instance state

- Widget blob entry is 13 int32 = 52 bytes (`uidesc.cla:17-71, 382-444`;
  writer `uiblob.cla:798-839, 942-943`). Add fields for height, font
  (name string offset + size), style bits, align, maxLines, divider
  style; stride bump on writer and reader together (blob and runtime
  always compile together; the header's version stays unchecked by
  the runtime; bump it anyway). Column entries gain align and a
  formatter id (-1 = plain field).
- Per-instance runtime state (`RtUiWinst`, `uidesc.cla:799-854`, 120
  bytes with 12 spare) needs per-widget: code-placed flag, pending
  rect, current font/size/style. Allocate as per-widget parallel arrays
  like the existing ones (`ui.cla:822-850`), disposed in teardown.
  LogPanel state hangs off its own per-widget handle.
- New module-level globals in `ui*.cla` move nearly all 74
  `testdata/cg68k/*.s` goldens (the A5 map); prefer per-instance
  state, and batch unavoidable global changes into one rebless.

### 4.2 Layout and resize ordering

`rtUiApplyResize` (`ui.cla:2044-2059`) runs SizeWindow, `rtUiLayout`,
canvas realloc, then fires `resized`. `rtUiLayout` (`uiwidgets.cla:
447-605`) must skip code-placed widgets (still feeding their rect into
the `prev*` chain), and must not draw controls; the resize path then
fires `resized`, and the single deferred apply (§3.1) runs after the
handler. Today label/popup/canvas old pixels are never erased on grow
and the table invalidates only its new rect; the apply pass fixes both
by invalidating old ∪ new. `rtUiTeRelayout`'s flush-scrollbar logic
reads the blob's fill flags (`uitext.cla:571-582`); a code-placed
textview must not.

### 4.3 Kind plumbing

New kinds `logpanel` and `divider` touch: `isWidgetKind`
(`parse.cla:2146`), `widgetDeclProps`/`widgetRuntimeProps`
(`check.cla:953-1015`), the lowering whitelist (`lower.cla:6097`),
`uibWidgetKindNum` (`uiblob.cla:250`), runtime kind constants
(`uiwidgets.cla:151`, `uitable.cla:213`) and every runtime kind switch
(KindHeight/Width, Layout, MakeWidgets, NaturalSize, HandleUpdate,
HandleActivate, HandleContentClick, teardown, WidgetGet/Set). Widget
methods are canvas/textview-only today (`check.cla:2455`,
`lower.cla:1533`); generalize to per-kind method tables plus a
common-to-all table (`setBounds`). Each new intrinsic: checker sig,
lowering, `IUi*` in `ir.cla`, cprint arm, cg68k arm (`cgIntrUiForward`
where it fits), shake root, prop codes kept in sync across
`uiwidgets.cla:184`, `cg68k.cla:10037`, `runtime/mac/rt_ui.h:141`, and
trace prop names (`uiscript.cla:632`).

### 4.4 Check-time value validation

`checkWidget` (`check.cla:4102`) validates only property names today;
values are interpreted ad hoc in `lowWidgetDesc`. Every new property
gets real value checks in the checker (literal kinds, ranges, allowed
words), so a wrong value is a check error, not silent.

### 4.5 List change tracking (C2, D3)

There is no mutation hook today: `rtUiTablesSync` (`uitable.cla:994`)
polls each pass and compares only counts. The list box (`RtList`,
`list.cla:138`, 20 bytes, mirrored by `struct rt_list` +
`rt_list_layout_check` in `runtime/host/rt_core.inc:495-510`) does
**not** grow.

- **Registry.** `list.cla` gains a small fixed registry of observed
  boxes, one entry per bound table instance: `{box, gen, mark}`, plus a
  count. Kept as one pointer + one count in A5 (the registry block is
  allocated on first registration), so a program with no tables pays
  two globals and one `count == 0` test per mutating list call. A table
  registers its bound list's box at window open and on every sync
  where the bound global holds a different box, and unregisters at
  window close.
- **Hook.** Each mutating list operation (`add`/`push`, `pop`, `shift`,
  `unshift`, `remove`, `clear`, `release`, `reserve`, `shrink`, and
  `clone` into an observed destination if that path mutates in place)
  tests the count and, when non-zero, calls one cold function that
  finds the box's entries, bumps `gen`, and adjusts `mark`: `unshift`
  +1; `shift` -1 (mark 0 -> -1); `remove(i)` (i == mark -> -1, i < mark
  -> mark - 1); `pop` (mark == last -> -1); `clear`/`release` -> -1;
  the rest leave it.
- **Inline element stores.** `l[i] = v` and element-field writes are
  inline addressing in both backends (`IListSet`, `cg68k.cla:9749`)
  and do not go through `list.cla`. The compiler emits a call to a
  `rtListNoteSet(box)` hook (same count test) after each such store
  **only in programs that declare a `table`**; other programs' code
  is unchanged.
- **Table side.** The table writes its selection into its entry's
  `mark` on select (user click or code) and reads it back on sync; it
  invalidates when `gen` differs from the value it last drew, or the
  bound global now holds a different box (whole-list reassignment:
  selection -1, re-register).
- Two tables bound to the same list keep separate entries, so separate
  selections (the hook updates every entry for the box).
- Memgate and the SE floor must not move for programs without tables
  beyond the two globals; measure and report.

### 4.6 Edit focus

`focusIdx` assumes a TE: `rtUiHandleKey` calls `TEKey` unguarded
(`ui.cla:2643-2679`), `rtUiRun` sleeps 1 tick whenever focused
(`ui.cla:2740`). Generalize focus to "field/textview or logpanel" and
guard every TE use on the focus kind.

### 4.7 Formatted columns in the LDEF

Cells draw inside the List Manager LDEF callback (`rtUiLdefDraw`,
`uitable.cla:607`) with the row block `HLock`ed. A formatted cell
calls a synthesized per-program dispatcher (`clar_ui_fire_colfmt`
shape, like `lowSynthTableRows`, `lower.cla:7685`) that binds the row,
calls the user function, and renders its result into a Str255 buffer,
inside an abort-containment frame (C5). The user function may allocate
and move memory: the LDEF must not hold a dereferenced row pointer
across the call (copy the needed fields first, or re-derive after).
Builder decides the safest shape; the relocation comments in
`uitable.cla` describe the hazard.

### 4.8 Menus

`rtUiBuildMenus` (`ui.cla:1296-1371`): placeholder + `SetMenuItemText`
(R9); exclude submenus from bar insertion and from the claimed/bar
masks (`ui.cla:1319-1366`, `rtUiSyncMenuBar`); `CheckItem` and
`SetItemMark`/`SetItemCmd` externs (new traps; add to
`toolbox/` catalog per the standing principle, with the rest of the
Menu Manager items not yet declared where feasible). Menu item entry
blob grows (4 int32 today) for flags (`checked`) and submenu index.
`rtUiMenuRecomputeDim` re-asserts enable state on front change and can
overwrite program-set `.enabled`; leave as is (out of scope) but do
not let it touch `checked`.

### 4.9 What every UI program pays

Always linked (cannot be gated): geometry storage and the deferred
apply, label `DrawText`/align/same-text check, font set/restore,
divider drawing (tiny), Select All, caption fix, check/submenu menu
building, the observed-list registry globals and the `count == 0`
test in each mutating list call. Gated (C4, linked only when used):
LogPanel, formatted-column dispatch. Builder may gate more if it is
cheap. Report the before/after code size of `bookmarks` and
ClarusC.APPL in the phase's final summary.

### 4.10 New traps

`GetFNum`, `StringWidth`, `GetFontInfo` (exists in `uitable.cla:106`),
`CheckItem`, `SetItemMark`, `SetItemCmd`, `LScroll`, `ScrollRect`,
`TESetSelect` (check if present), `PutScrap`/`ZeroScrap` (exist,
`uitext.cla:241`). Each new one: native trap clause, C-lane shim, and
a `toolbox/` catalog entry (fonts in a new `toolbox/fonts.cla` or the
QuickDraw catalog file if one exists; menus in the menu catalog).

## 5. Tests

- **Compiler (T1):** check-error fixtures for every new rule (bad
  `font:` values, `font:` on a button, unknown style word, `plain`
  combined, assigning `x`/`width`/`lineCount`/`contentWidth`,
  submenu declared below its user, a submenu also in `menus:`,
  `shows` with a non-call expression or a `text`-returning function);
  emitui/cg68k goldens reblessed (serialization points).
- **Toolbox suite (native, `mactest/toolbox_68k`), new cases**, each
  bumping the five case-count places:
  - `SetBounds`: move/resize every kind, read back x/y/width/height,
    code-placed widgets survive a scripted resize, zero size draws
    nothing, one paint (checksum stable across an extra update).
  - `LabelFontAlign`: font/style/align render (band checksums),
    same-text assignment produces no trace line and no draw.
  - `LogPanelRing`: `maxLines` drop, `line(i)`/`lineCount`, CR/LF
    splitting, empty lines kept.
  - `LogPanelFollow`: following scrolls with appends; scrolled up stays
    on the same text while lines drop; back to bottom resumes.
  - `LogPanelSelect`: selection survives appends, shrinks/clears on
    drop, Copy puts exactly the selected lines joined by CR on the
    scrap (read back with `GetScrap`), Select All.
  - `TableBinding`: `unshift`+`pop` at a fixed count redraws, `l[i] = v`
    redraws, selection follows the record through `unshift`, clears on
    removal, writable `selected`, `scrollTo`.
  - `TableFormat`: formatted column renders, alignment, an aborting
    formatter gives an empty cell and one log line.
  - `MenuCheckSub`: declared and runtime `checked`, submenu dispatch,
    literal caption with `( / ;`, Select All in a textview.
  - `CanvasText`: `textWidth`/`lineHeight`/`ascent` for two fonts, font
    survives a resize.
  - `Divider`: single/double, horizontal/vertical.
- **Core suite:** the observed-list registry is internal; no new core
  case unless the builder finds observable list behavior changed.
- **Memory:** memgate budgets and the SE floor (§1 exit).
- **Snow:** `mactest/snow/clarusc_bake` on the SE (standing rule).
- A frozen-scenario golden (`smoke_*`, `texteditor`, `bookmarks`)
  moving is expected only for Select All (menu trace) and possibly
  label pixels; anything else moving is a bug to explain.

## 6. Docs

- Reference: Ch8 widget table (new rows/columns, `logpanel`, `divider`,
  `height`, geometry members, `setBounds`, fonts, Mac notes on natural
  heights and the C5 policy), Ch8 Layout (code placement; correct the
  "edge pinning" sentence, which the runtime never did: only fill
  tracks the window), Ch9 (checked, submenu, literal captions, Select
  All), Ch10 (formatted columns, align, the live-update promise made
  true and exact, selection follows the record, `scrollTo`, writable
  `selected`), Ch11 (canvas font, `textWidth`/`lineHeight`/`ascent`),
  Appendix A grammar, Appendix B events. Fix the Ch8 intro's
  "readable and assignable" to say which properties are read-only.
- Changelog `## 1.2`, one entry per item, plus the two visible changes
  to existing programs (Select All, literal captions).
- `docs/TODO.md`: remove "Language: canvas text font"; record the
  popup menu-ID collision found in recon (`1000 + widgetIdx` repeats
  across windows) and the `RecomputeDim` overwrite of program-set
  `.enabled`, both out of scope.
- `docs/ROADMAP.md`/`docs/HISTORY.md` per the usual phase close.

## 7. Left to the builder

Exact blob layouts, LogPanel ring layout, trace line shapes, label
vertical placement in a tall rect, whether submenus nest deeper than
one level, how the deferred apply suppresses control drawing, the
LDEF relocation strategy, which extra Menu Manager/Font Manager traps
join the catalog, and task/track split (plan maximizes parallel tracks
on disjoint files; golden reblesses and `clarusc/clarusc.c` snapshot
regenerations are serialization points; new syntax used inside
`clarusc/*.cla` needs a snapshot regen first, but nothing here should
require clarusc itself to use the new syntax).
