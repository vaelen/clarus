# Clarus Language Changelog

What changed in the language between versions, at a glance. Each entry
is a summary with a pointer into `docs/clarus-language-reference.md`,
which stays the normative spec: where this file and the reference
disagree, the reference wins. Entries marked **Action:** may need a
change to an existing program.

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
- **`clarusc --version`** prints the language version (`1.1`).
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
