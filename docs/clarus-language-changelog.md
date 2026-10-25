# Clarus Language Changelog

What changed in the language between versions, at a glance. Each entry
is a summary with a pointer into `docs/clarus-language-reference.md`,
which stays the normative spec: where this file and the reference
disagree, the reference wins. Entries marked **Action:** may need a
change to an existing program.

## 1.2

The ui-widgets phase (2026-10-25): the widget, menu and table features
68kBBS asked for (its `docs/clarus-ui-requirements.md`, items R1–R9),
plus two visible changes to existing programs (Select All, literal menu
captions). The design is
`docs/superpowers/specs/2026-10-25-ui-widgets-design.md`.

### New syntax and types

- **`height:` on every widget, `width:` on `textview`, `canvas` and
  `table`** (R1). `field`, `button`, `check` and `popup` keep their
  natural height: `height:` is accepted on them and ignored
  (reference §Layout, Mac note — natural heights).
- **`font: "Name", size` and `style: word, ...`** on `label`, `field`,
  `textview`, `table`, `canvas` and `logpanel`, with the style words
  `plain`, `bold`, `italic`, `underline` (R2). An unknown font name
  falls back to Geneva. `font:`/`style:` on a `button`, `check` or
  `popup` is a build error (reference §Fonts and Styles).
- **`label` gains `align: left | center | right`** (R3) (reference
  §Labels).
- **New widget `logpanel`**: a scrolling list of read-only lines with
  `maxLines:` (default 200) and `scrollbar: vertical | both` (R4)
  (reference §Log Panels).

  ```rust
  logpanel Log { maxLines: 100; font: "Monaco", 9; scrollbar: both; fill: both }
  ```

- **Formatted and aligned table columns**: `shows` takes a call to a
  top-level function, with the row's fields in scope bare, and a
  column may end with `align left | center | right` (R5) (reference
  §Table Columns).

  ```rust
  column "Time" shows minutes(secs) width fill align right
  ```

- **New widget `divider`**, a horizontal or vertical rule with
  `style: single | double` (R6) (reference §Dividers).
- **Menu items take `checked` and `submenu Name`** (R7). A submenu must
  be declared above the menu that uses it, never appears in the menu
  bar, and cannot be named in a window's `menus:`
  (reference §Checkmarks and Submenus).

  ```rust
  item PortSpeed "Port Speed" submenu Speed
  item S9600 "9600" checked
  ```

### New built-ins and methods

- **Widget geometry** (R1): read-only `x`, `y`, `width`, `height` on
  every widget; `w.X.setBounds(x, y, width, height)`, which places a
  widget by code from then on and is applied once, without flicker,
  after the handler returns; read-only window `contentWidth` and
  `contentHeight` (reference §Geometry and Code Placement, §Window
  Instances).
- **`setFont(name, size)` and `setStyle(word, ...)`** on the
  font-carrying widgets (R2). `setStyle` replaces the whole style;
  `setStyle(plain)` clears it (reference §Fonts and Styles).
- **`logpanel` members** `appendLine(s)`, `clear()`, `lineCount`,
  `line(i)` and `scrollToEnd()` (R4). Lines are selectable, and Copy
  and Select All work on them (reference §Log Panels).
- **Table `scrollTo(i)`**, and `selected` is now documented as
  assignable (`-1` clears) (R5) (reference §Table Selection).
- **Menu item `checked`**, readable and assignable, and `enabled` is
  now readable as well as assignable (R7) (reference §Runtime Menu-Item
  Properties).
- **Canvas `textWidth(s)`, `lineHeight` and `ascent`**, in the
  canvas's own font, which also survives a resize (R8) (reference
  §Canvas Text).

### Changed behaviour

- **Select All in `standard edit`.** Every program's standard Edit menu
  gains a seventh item, Select All (⌘A), for fields, textviews and
  logpanels. **Action:** a menu item of your own with `key "A"` now
  collides with it silently; give it another key
  (reference §Standard Edit).
- **Menu captions are literal** (R9). `(`, `/`, `^`, `!`, `<` and `;`
  in an item caption are shown as written instead of being read as
  Menu Manager commands, so `"Init (Hayes); Reset"` shows exactly that.
  **Action:** none needed. A program that avoided those characters
  (68kBBS's "no `(` in captions" rule) can drop the workaround
  (reference §Menu Declaration).
- **A menu that mixes `standard edit` with its own items keeps both.**
  The seven standard items come first, then the declared items in
  order. Before 1.2 the declared items were silently dropped
  (reference §Standard Edit).
- **Tables follow every change to their list** (R5). Every list
  mutation, element store, element field write, `edit` writeback and
  reassignment of the bound variable redraws the table; before 1.2 a
  change that kept the row count the same could leave it stale. The
  selection now follows its record: after `unshift` the same record
  stays selected, and removing the selected record clears `selected`
  to `-1` (it used to stay on the row number) (reference §Table
  Binding, §Table Selection).
- **A table with `width:` honors it.** A table without `width:` still
  fills the window, as before (reference §Layout).
- **Labels draw directly**, with no TextEdit, and assigning a label
  the text it already shows does nothing (R3) (reference §Labels).
- **After a resize, zoom or applied `setBounds`, the update erases the
  invalidated area**, so moved widgets leave no stale pixels. An
  unbuffered canvas is wiped there and must be redrawn by the program
  (reference §Geometry and Code Placement, Mac note).
- **`text.reserve(n)` sizes to exactly `n`**, as `list.reserve(n)`
  does, instead of rounding up. Contents and the "at least `n`"
  contract are unchanged (reference §Text).

### Compiler and tooling

- **New build errors** for the new properties' values, for example
  `font: expects a font name string and a size from 1 to 127`,
  `unknown style X (expected plain, bold, italic or underline)`,
  `plain cannot be combined with other styles`,
  `align: expects left, center or right`,
  `maxLines: expects an integer literal of at least 1`,
  `column shows expects a field name or a function call`, and
  `cannot assign to read-only property x` for the geometry
  properties.
- The `toolbox/` catalog gained `menus.cla` (the Menu Manager),
  `fonts.cla` (Font Manager and QuickDraw text) and `lists.cla` (the
  List Manager).

## 1.1 (2026-09-30)

Everything user-visible that landed during the SE memory program
(Waves 0–5, 2026-09-27 to 2026-09-30) and the log-trace-optin detour
between Waves 3 and 4. The history behind each item is in
`docs/HISTORY.md`.

### New syntax and types

- **Narrow integer types `uint8`, `int16`, `uint16`.** Storage types
  of 1, 2 and 2 bytes in records, arrays and `list of`/`map of`
  elements; in expressions they are ordinary `int`s. Widening to `int`
  is implicit and all arithmetic and comparison is 32-bit
  (reference §Narrow Integers, §Types table).

  ```rust
  record Pixel {
      x:     int16
      y:     int16
      level: uint8
  }
  var p: Pixel
  var total: int = p.x + p.y          // widens implicitly
  ```

- **Explicit narrowing conversions** `uint8(x)`, `int16(x)`,
  `uint16(x)` take an `int`, a `char` or another narrow type and keep
  the low 8 or 16 bits: `uint8(300)` is 44, `int16(40000)` is −25536,
  `uint16(-1)` is 65535. Assigning an `int` (or a different narrow
  type) to a narrow slot without one is a build error
  (`cannot assign int to int16`) (reference §Narrow Integers).
- **Literals adopt the narrow type** where one is expected (assignment
  target, argument, return value, field default, `case` label, the
  other side of a comparison) if in range; out of range is a build
  error, e.g. `300 is out of range for uint8 (0..255)`. `string(n)`
  renders any narrow value in decimal (reference §Narrow Integers).

  ```rust
  var port: uint16 = 8080             // OK
  var bad: uint8 = 300                // error: out of range
  ```

- **`int16` and `uint8` replace `word` and `byte` at the Toolbox
  boundary.** `int16` is the 16-bit `INTEGER` type of an
  `external func`/`callback func` signature (including `reg`
  parameters and `= ptr` externs) and of an `extern record` field;
  `uint8` is the 1-byte `extern record` field type. `uint16` anywhere
  at the boundary, and `uint8` in a signature, are build errors
  (`uint16 cannot cross the Toolbox boundary; use int16 or int`)
  (reference §The `int16` Extern Type, §Field Palette, §Narrow
  Integers). **Action:** see "`word`/`byte` removed" under Changed
  behaviour.

  ```rust
  external func UiMoveTo(h: int16, v: int16) = trap 0xA893
  extern record Point {
      v: int16
      h: int16
  }
  ```

- **`= inline sp`**, a compiler intrinsic with signature `(): ptr`
  that reads the 68k stack pointer (A7), for stack-depth probes.
  Native lane only (reference §Trap and Inline Clauses).

  ```rust
  external func CurrentSP(): ptr = inline sp
  ```

- **Narrow fields in forms and tables.** A form `field` bound to a
  narrow record field takes numeric input and fails OK validation for
  a value outside the type's range (or with a minus sign for
  `uint8`/`uint16`); a table `column` shows it in decimal
  (reference §Type-Driven Widget Behavior).

### New built-ins and methods

- **`.release()` and `.shrink()`** on `list of`, `map of`,
  `sortedmap of`, `intmap of` and `text`. `release()` empties the
  container (releasing elements exactly as `clear()` does) and frees
  its storage, back to a freshly declared state; `shrink()` trims
  capacity to the current contents. Both act on the container itself,
  so every alias sees the result (reference §Lists, §Maps, §Sorted
  maps, §Integer maps, §Text).
- **`list.reserve(n)`** pre-grows a list's capacity to exactly `n`
  elements with at most one resize; never shrinks; a no-op when
  capacity already suffices or `n <= 0` (reference §Lists).
- **`text.removeFirst(n)`** drops the first `n` bytes in place
  (`n` clamped to `0..length`), resizes the buffer to the new length,
  never allocates (reference §Text).
- **`file.openRead(path)`** returns a read-only `filehandle` (`nil` +
  `lastError` if missing or unopenable). Reads, `size` and `close`
  work as on `file.open`'s handle; `writeAt`, `append` and `setSize`
  return `false` with `lastError`; `flush` succeeds
  (reference §Files).
- **`app.writeLog(name)`, `app.flushLog()`, `app.trace(on)`** control
  an opt-in log file. `writeLog` opens (or creates as `TEXT` with the
  app's creator) and appends to `name`; lines are buffered 4 KB at a
  time and written on overflow, `flushLog()`, quit, or a runtime error
  report. `trace(true)` adds the Macintosh UI trace to the log
  (reference §Log File and Tracing).

  ```rust
  on App.launch { app.writeLog("MyApp Log") }
  ```

### Changed behaviour

- **`word`/`byte` removed.** The contextual extern types `word` and
  `byte` no longer exist, with no aliases; using one gives
  `undefined: word` (or `byte`), and the extern diagnostics now name
  `int16`/`uint8`. **Action:** rename `word` → `int16` in
  `external func`/`callback func` signatures and `extern record`
  fields, and `byte` → `uint8` in `extern record` fields. Call sites
  need no change: a plain `int` still passes to an `int16` slot and is
  truncated (reference §The `int16` Extern Type, §Field Palette,
  §Transcribing Inside Macintosh Declarations).

  | 1.0 spelling            | 1.1 spelling             |
  |-------------------------|--------------------------|
  | `x: word` (extern)      | `x: int16`               |
  | `): word` (extern)      | `): int16`               |
  | `f: byte` (extern rec.) | `f: uint8`               |

- **Boundary `int16`/`uint8` read back as `int`.** An extern result, a
  callback parameter or an `extern record` field declared
  `int16`/`uint8` is an `int` in Clarus code, as `word`/`byte` were.
  Storing one in an `int16` variable needs an explicit conversion,
  e.g. `s = int16(FindWindow(pt, wp))` (reference §Narrow Integers).
- **Enums are 2 bytes in storage on both lanes**, as the reference
  already specified (the compiler had stored them as 4). Record
  layouts, array strides and container element sizes holding enums
  shrink; code that pokes or peeks such records by hand-computed
  offset must follow the new layout (reference §Types table, §Enums).
- **Serializer format v2.** `file.save` now writes format version 2:
  enum fields take 2 bytes on disk (they took 4) and narrow fields
  their natural 1/2/2 bytes. `file.load` still reads version 1 files,
  so existing data files load unchanged; files written by 1.1 cannot
  be read by a 1.0 build. (Not spelled out in the reference, which
  describes `save`/`load` without a format; see `docs/HISTORY.md`'s
  Wave 3 entry and the SE program design's D8.)
- **Production native programs write no `out` file.** At 1.0 every
  native Macintosh program wrote its `log(...)` lines, UI trace and
  (non-UI) alert text to an `out` file, flushing to disk on each line.
  In 1.1, `log(...)` on the Macintosh goes to the log file only once
  the program has called `app.writeLog`, and nowhere otherwise; the UI
  trace is off until `app.trace(true)`. **Action:** a program that
  relied on the `out` file calls `app.writeLog("out")` (plus
  `app.trace(true)` for the UI trace) at startup (reference §Logging,
  §Log File and Tracing, §`App.log`).
- **A command-line program can also enable a log file**; its `log`
  lines then go to both standard error and the file
  (reference §Logging).

### Compiler and tooling

- **`clarusc emit68k --capture`** selects the test capture protocol
  (the `out` file with its `##CLARUS-EXIT##` trailer); `--events`
  implies it. Without either, a build is a production build (see
  above). `scripts/build-68k.sh` accepts `--capture`
  (reference §Log File and Tracing).
- **`clarusc --version`** prints the compiler's version (`clarusc 1.1`),
  which is also the language version it implements.
- **ClarusC.APPL runs on a 4 MB Macintosh SE** (System 6.0.8), where
  it compiles `examples/bookmarks.cla` with about 1.1 MB to spare.
- **New compile error `source too deeply nested`** from ClarusC.APPL
  when a program's nesting would exhaust the compiler's stack; the
  compile fails cleanly and the next compile is unaffected. The host
  `clarusc` never raises it.
- The `toolbox/` catalog gained `segload.cla` (`GetAppParms`,
  `UnloadSeg`, `ExitToShell`) and twelve more Memory Manager traps in
  `memory.cla` (`MaxBlock`, `StackSpace`, `MaxApplZone`, ...).

## 1.0

The baseline: the language as specified by
`docs/clarus-language-reference.md` just before the SE memory program
began (the tree at the parent of commit `c9c8d2b4`, 2026-09-27). There
is no changelog before it; the reference is the whole story.
