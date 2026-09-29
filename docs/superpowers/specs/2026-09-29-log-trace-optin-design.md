# Opt-in log file and UI trace (spec, 2026-09-29)

Status: **spec, awaiting review.** A detour before SE Wave 4, raised by
Andrew's BBS: a native Clarus app writes and `FlushVol`s its `out` file
on every UI trace line, so a timer-driven app hits the disk every tick
and wears out an SD card.

Anchors below are as of `main` at `99a2be8c`.

## 1. Goal and exit

A production native app writes nothing to disk unless it asks to, and
when it asks, it writes in large chunks, not per line. Every existing
test boot keeps today's capture protocol byte for byte.

**Exit:**
- A native program that never calls `app.writeLog` creates no `out` file
  and performs no File Manager writes for `log`, trace, `alert` or panic.
- `app.writeLog(name)`, `app.flushLog()` and `app.trace(on)` work as
  in §3 on the native lane, and `writeLog`/`flushLog` work on the host.
- Every capture-mode boot (core and toolbox suites, UI goldens, Snow
  ClarusC tests, every other `mactest/` boot) is unchanged: no trace
  golden, no `.behavior` blob and no harness parser moves.
- T1, T2, and `mactest/snow/clarusc_bake` on the IIcx pass.

## 2. Decisions (Andrew, 2026-09-29)

| #   | Decision                                                                                                                                                                                  |
|-----|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| L1  | Tracing is enabled **in code**, at startup or later: `app.trace(true)`. Off by default.                                                                                                     |
| L2  | Writing a log file at all is opt-in: `app.writeLog(name)`. Off by default; while off, no log buffer is allocated.                                                                          |
| L3  | `app.flushLog()` writes the pending buffer to disk and clears it, so an app can flush from a tick or `every` handler.                                                                       |
| L4  | Trace lines go **into the log** with everything else, under the same buffering. `app.trace(true)` without `writeLog` produces nothing on disk.                                               |
| L5  | A full buffer flushes itself (replacing today's silent truncation at 4 KB).                                                                                                                  |
| L6  | **Capture mode**: a compiler flag reproduces today's `out` test protocol exactly, so no test output moves. `--events` implies it.                                                         |
| L7  | With the log off, nothing touches the disk. With it on, `alert` text (non-UI programs) and the panic/uncaught-abort report go into the log, and a panic or abort flushes immediately; normal quit flushes. No trailer, no markers, no timestamps. |
| L8  | `writeLog` on an existing file **appends**.                                                                                                                                                  |

## 3. Behavior

### 3.1 The API

Three runtime calls in the existing `app.` namespace (today it holds
only the compile-time constants `app.doctype`/`app.id`):

| Call                        | Effect                                                                                                                                                                                  |
|-----------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `app.writeLog(name: string)` | Turns log writing on. Opens `name` (resolved like every other `file.*` path; created as `TEXT`/`app.id` if missing, positioned at its end if it exists) and allocates the log buffer. Lines logged before the first call are not kept. Calling it again flushes the pending buffer to the old file, closes it, and switches to `name`. If the open fails, logging stays off and `lastError` is set; the call does not abort. |
| `app.flushLog()`            | Writes the pending buffer to the log file, then clears it. A no-op while logging is off or the buffer is empty.                                                                         |
| `app.trace(on: bool)`       | Turns UI trace lines on or off. Off by default. A no-op in a non-UI program.                                                                                                             |

All three are statements (no result). They may be called from any
handler, any number of times.

### 3.2 Production mode (the default)

- **Logging off (default):** `log(...)` still fires `App.log` handlers
  exactly as today (reference, `App.log` rule 1's "persistent channel"
  becomes "the log file, when one is enabled"), and writes nothing.
  Trace lines are not built at all while trace is off. A GUI program's
  panic or uncaught abort still beeps and shows its alert, as the
  reference already specifies. No `out` file is created: `natInit`
  (`runtime/clarus/native.cla:402`) no longer creates or opens a file.
- **Logging on:** `log` lines, trace lines (when `app.trace(true)`),
  non-UI `alert` text, and the panic or uncaught-abort report are
  appended in order to one buffer (`natLogBuf`-sized, 4 KB). Each line
  is CR→LF rendered with a trailing LF, as today. The buffer is written:
  - when the next line would not fit (the buffer is written first, then
    the line is added; a single line longer than the buffer is written
    directly);
  - on `app.flushLog()`;
  - at quit (normal or `quit n`);
  - immediately after a panic or uncaught-abort report is added.

  One write per flush, then one `FlushVol`. No `##CLARUS-EXIT##` or
  `##CLARUS-LOG##` markers are written in production mode.

### 3.3 Capture mode

Capture mode is today's `out` protocol, unchanged:
- the file is `out`, created and truncated at first use as today;
- trace is on from startup, and trace and `alert` lines are written and
  flushed live;
- `log` lines are buffered and written after `##CLARUS-EXIT## <code>` /
  `##CLARUS-LOG##` at quit, with today's 4 KB truncation;
- panics keep today's live `natAlert` copy plus the buffered copy
  (`native.cla` ~l.586-650).

It is selected by a new `clarusc emit68k --capture` flag, and implied
by `--events`. In capture mode `app.trace(false)` is ignored (the trace
is part of the protocol), while `app.writeLog`/`app.flushLog` behave as
in production **in addition to** the capture stream: the named file
receives the log lines and the production-format report, and `out`
still receives everything the protocol requires. This is what lets the
core suite test the production writer natively (§5).

### 3.4 Implementation shape

- **Mode flag.** `emit68k --capture` (and `--events`) makes the native
  startup (`cgEmitStartup`, `clarusc/cg68k.cla:3237`) set one runtime
  global, e.g. `natCapture = true`, before any user code runs. Parse it
  next to `--events` (`clarusc/main.cla:459`). ClarusC.APPL's own
  emit68k path takes no flag, so what it compiles is production mode.
  ClarusC.APPL itself is built in capture mode only when
  `build-clarusc-mac.sh` is given `--events` (the Snow tests); a plain
  build is production, like any other app.
- **Native runtime (`runtime/clarus/native.cla`).** `natInit` splits
  into the capture open (today's code) and the production writer
  (`writeLog`'s open/append, the buffer, flush-on-full, `flushLog`).
  `natLog`, `natAlert`, `nat_CorePanic`, `natQuit` and `nat_UiTestEmit`
  branch on `natCapture`. The trace helpers' single choke point,
  `rtUiEmitLine` (`runtime/clarus/uiscript.cla:332`), gains the
  `app.trace` gate; the per-tick `rtUiTraceEveryFire` call and the
  other `rtUiTrace*` builders are skipped entirely (not just their
  emit) when trace is off, so no `text` is allocated per tick.
- **Checker / lowering.** `app.writeLog`, `app.flushLog` and
  `app.trace` are new intrinsics beside the existing `app.` constant
  handling (`clarusc/check.cla`, the `appProps` table ~l.964), with
  the argument types in §3.1.
- **Host C lane.** `log` keeps writing to stderr. `app.writeLog` /
  `app.flushLog` additionally append log lines to the named file under
  the same buffering (so the host has a cheap T1 test), in
  `runtime/host/rt.c` next to `rt_log`. `app.trace` is a no-op on the
  host.
- **Retro68/cprint lane (demoted).** No-op stubs in `runtime/mac/`
  so programs still build. It keeps its own `RT_MAC_TEST` capture.
- **Reference.** A new section on the log file and tracing (the three
  calls, production vs. capture, append, flushing, what goes in the
  log). Chapter 12's `log` paragraph (`docs/clarus-language-reference.md`
  ~l.1680, "a destination reserved for a later release") and `App.log`
  rule 1 (~l.928) are updated. CLAUDE.md gains a line on `--capture`.

## 4. Output policy

| Change                                         | Label                                                                                                   |
|------------------------------------------------|---------------------------------------------------------------------------------------------------------|
| `native.cla`/`uiscript.cla` runtime changes     | output-changing for every compiled native program: the cg68k `.s` and bake twins move once; isolated rebless with a reason |
| emitui C goldens                               | move only if `uiscript.cla`'s shared trace gate changes the C output; rebless with a reason if so        |
| capture-mode boots                             | byte-identical: trace goldens, suite logs, Snow captures, `.behavior` blobs unchanged                  |
| checker intrinsics                             | byte-identical for programs that do not call them                                                        |
| snapshot regeneration                          | needed once `clarusc/*.cla` may use the new calls (it need not; ClarusC.APPL's own logging is unchanged) |

## 5. Tests

- **Host (T1):** `writeLog` creates, then appends across two runs;
  `flushLog` makes lines visible mid-run; a burst larger than 4 KB
  auto-flushes with nothing lost; with no `writeLog`, no file appears;
  `App.log` still fires with the log off.
- **Core suite, native (capture mode):** a new case calls
  `app.writeLog("core_log.txt")`, logs lines, `app.flushLog()`, reads
  the file back with `file.readText`, and checks the exact bytes (no
  markers, CR→LF, append on a second `writeLog`). Case count moves in
  the five places.
- **Production-mode native boot:** one LaunchAPPL boot of a program
  built **without** `--capture` that calls `app.writeLog("out")`, logs
  three lines, turns trace on, and quits. `out` must contain exactly
  those lines plus its trace lines, and no `##CLARUS-EXIT##` trailer.
  A second program that never calls `writeLog` must leave no `out`
  (LaunchAPPL reports empty output).
- **Build plumbing:** every script that boots a native binary passes
  `--capture` (or `--events`): `scripts/build-68k.sh`,
  `scripts/build-clarusc-mac.sh`, the `tests/lib_mac.sh` /
  `tests/lib_snow.sh` helpers, and each `tests/mactest/*.sh` that calls
  `emit68k` directly. Compile-only tests (cg68k goldens, bake identity,
  size) build without it and so pin the production default.
- **Gates:** T1 per task; T2 and `mactest/snow/clarusc_bake` at the end.

## 6. Out of scope

- Timestamps, log rotation, size limits.
- A per-line "sync" option for production logs.
- Changing the capture protocol itself, or the Retro68 lane's capture.
- Host-side trace output.
