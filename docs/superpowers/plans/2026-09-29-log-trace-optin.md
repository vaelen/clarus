# Opt-in Log File and UI Trace Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** A production native Clarus app writes nothing to disk unless it calls `app.writeLog(name)`. When it does, it writes in buffered chunks. UI trace is opt-in via `app.trace(true)`. Every test boot keeps today's `out` capture protocol through a new `emit68k --capture` flag, which `--events` implies.

**Architecture:**
- A startup global `natCapture` selects between two modes in `runtime/clarus/native.cla`:
  - capture mode is today's protocol, kept byte for byte;
  - production mode is the new model: no file until `writeLog`, then one append-mode file fed by one buffer.
- The shared UI trace builders (`runtime/clarus/uiscript.cla`) ask a per-lane extern `UiTraceOn()` before building a line. So trace costs nothing when off, and no new global is added to `uiscript.cla` (a new runtime global renumbers `Table.rowsIdx` in every UI blob; see the warning at `uiscript.cla` ~l.299).
- The three `app.` calls lower to runtime functions on both lanes.

**Tech Stack:** Clarus (`clarusc/*.cla`, `runtime/clarus/*.cla`), C99 host runtime, POSIX sh tests, Mini vMac via LaunchAPPL.

**Spec:** `docs/superpowers/specs/2026-09-29-log-trace-optin-design.md`

## Global Constraints

- **Branch and merging.** Branch `log-trace-optin`. Merge only when Andrew asks.
- **Model.** Implementers and reviewers run on Opus (`model: opus`).
- **Serial tasks.** Tasks 1→2→3 all touch `native.cla` and run in order on the branch tip (no worktrees).
- **Gates.**
  - Per-task: `scripts/test-task.sh`.
  - Emulator: `export DISPLAY=:1 XAUTHORITY=/run/user/1000/gdm/Xauthority; CLARUS_MAC_TESTS=1 make -j1 test T=mactest/` (the whole Mini vMac group).
  - **No Snow runs** (Andrew, 2026-09-29).
- **Process safety.** Never `pgrep`/`pkill` an emulator by name. Stop only pids you launched. Never boot or write the pristine `macplus/`, `macplus2/` or `snow/` images.
- **grep.** Use `/usr/bin/grep -a` over `.cla` files (ugrep skips MacRoman files).
- **Snapshot.** `clarusc-current` is built by the committed snapshot, so `clarusc/*.cla` must not call the new `app.` functions. Task 3 regenerates `clarusc/clarusc.c` once. Until then `selfhost/fixedpoint` is expected to fail; the other `selfhost/` scripts must pass.
- **Byte-identity of capture boots.** Every capture-mode boot must produce the same `out` as before: the UI trace goldens, the core and toolbox suite logs, `mactest/*` expectations. Compile-only goldens (`testdata/cg68k/*.s`, emitui, bake twins) move because the runtime changed. Rebless them only in a dedicated commit whose message gives the reason, after a hand-inspected representative diff.
- **Memgate.** Do not raise a budget. If a peak drops, leave the budget alone and record the new peak in the report.
- **Case counts.** Core moves 89 → 90 in Task 2, in all five places CLAUDE.md lists. Toolbox stays at 41.
- **Commits.** Messages end with:
  ```
  Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
  Claude-Session: https://claude.ai/code/session_01TSN5Gu3dKXT51LZnfqpfFP
  ```

## Review Focus

1. **A single `log` line longer than the 4 KB buffer** is written whole and directly (spec §3.2), not truncated or dropped. Task 2's host test pins it.
2. **`app.writeLog` called twice** flushes the pending buffer to the first file before switching. Neither file loses or duplicates a line. Task 2's host test and core case pin it.
3. **A panic or uncaught abort after `writeLog`** leaves the report in the file even though the program dies at once. Task 2's host test uses a deliberate panic.
4. **`writeLog` on a path that cannot be opened** (a missing folder) sets `lastError`, leaves logging off, and does not abort. A later `log` must not crash. Task 2's host test and core case pin it.
5. **A production (non-capture) native app creates no `out` file.** Task 1's new `mactest/nolog` boot pins this, and Task 2 extends the same boot to a `writeLog("out")` program.

---

### Task 1: Capture-mode flag; production mode writes nothing

The runtime changes the golden output. Capture-mode boots must be byte-identical.

**Files:**
- Modify: `clarusc/main.cla`
  - Parse `--capture` next to `--events` (~l.459).
  - `--events` sets capture too.
  - Add `--capture` to the three usage strings.
  - Pass the flag to cg68k (e.g. a `cgCaptureMode: bool` global beside `cgEventsBytes`).
- Modify: `clarusc/cg68k.cla`. In `cgEmitStartup` (~l.3237), when `cgCaptureMode` is set, store `true` into the runtime global `natCapture` before any user code runs.
  - Use the same mechanism the startup already uses to seed a runtime global, or have it JSR a new `natSetCapture` runtime entry point: pick whichever the file already has a pattern for, and say which in the report.
  - A build without the flag must not reference it at all (production is the zero-initialized default).
- Modify: `runtime/clarus/native.cla`
  - Add `var natCapture: bool` (default false).
  - Today's behavior of `natInit`, `natAlert`, `natLog`, `natQuit`, `nat_CorePanic` and `nat_UiTestEmit` becomes the `natCapture` branch, unchanged.
  - Production branch, for this task:
    - `natInit` creates or opens nothing (it may still allocate the scratch it needs for `natArgs` etc., but no `out` file and no `natLogBuf`);
    - `natAlert`, `natLog` and `nat_UiTestEmit` do nothing;
    - `natQuit` skips the trailer and the file close, and still calls `ExitToShell`;
    - `nat_CorePanic` keeps its beep/alert-free behavior and quits.
  - Task 2 adds the writer.
- Modify: `runtime/clarus/uiscript.cla`
  - Declare `external func UiTraceOn(): bool` beside `UiTestEmit` (~l.41), clause-less, the same pattern.
  - At the top of every `rtUiTrace*` builder (and anything else that builds a `T …` line through `rtUiEmitLine`), return early when `not UiTraceOn()`, so no `text` is allocated per tick.
  - Keep `rtUiTraceSuppressed` as is.
  - Do not add a global to this file.
- Modify: `runtime/clarus/native.cla`: `func nat_UiTraceOn(): bool { return natCapture }`. Task 2 adds the `app.trace` flag to it.
- Modify: the C lane.
  - `runtime/host/rt_ext_host.inc` and `runtime/mac/rt_ext_mac.inc` each get `rt_ext_UiTraceOn` returning 1. Follow how `rt_ext_UiTestEmit` is declared and defined on each lane.
  - The Retro68 lane keeps its `RT_MAC_TEST` capture, and the host `UiTestEmit` stays whatever it is today.
- Modify: the build plumbing.
  - `scripts/build-68k.sh` gains a `--capture` passthrough. It is **not** implied, because Andrew builds real apps with this script; `--events` still implies it inside clarusc.
  - `scripts/build-clarusc-mac.sh` passes `--capture` only when given `--events`.
  - Every test that **boots** an `emit68k` binary must build in capture mode. Audit with `/usr/bin/grep -a -rln 'emit68k\|build-68k.sh' tests/ scripts/`, and for each hit decide boot vs compile-only.
    - A boot either passes `--events` or gets an explicit `--capture`: `tests/lib_mac.sh`'s `toolbox_emit68k` and any other helper, `tests/lib_snow.sh`'s build helpers (so Snow keeps working even though we don't run it now), and each `tests/mactest/*.sh` calling `emit68k`/`build-68k.sh` directly.
    - Compile-only callers (`tests/lib_bake.sh`'s `emit68k_pair`, `tests/cg68k/*`, `scripts/size-68k.sh`) get no flag.
    - List every file and your boot/compile-only verdict in the report.
- Create: `tests/mactest/nolog.sh` plus the fixture `testdata/mactest/nolog.cla`: a tiny non-UI program that calls `log("x")` and `quit 0`, built **without** `--capture`, booted with the same LaunchAPPL invocation `run_mac` uses. Read `tests/lib_mac.sh`'s `run_mac` first:
  - if LaunchAPPL treats a missing `out` as an empty capture, assert the capture is empty (no `##CLARUS-EXIT##`);
  - if it errors on a missing `out`, assert that specific error and exit status;
  - either way, write the observed behavior into the script's header comment.
  - Gate it like its siblings (`require_env CLARUS_MAC_TESTS`).
- Modify: `CLAUDE.md`, one paragraph under "Running Mac apps": `emit68k --capture` is the test capture protocol, `--events` implies it, and builds without it are production (no `out`).

- [ ] **Step 1: Failing test.** Write `tests/mactest/nolog.sh` and its fixture. Run `CLARUS_MAC_TESTS=1 make -j1 test T=mactest/nolog`. Expected: FAIL, because today the program writes `out` with the trailer.
- [ ] **Step 2: Implement** the compiler flag, the `natCapture` branches, the `UiTraceOn` gate and the build plumbing.
- [ ] **Step 3: Host and compile-only checks.** Run:
  - `make -j tools bootstrap`
  - `make test T='cg68k/ emitui/ bake/ lowlevel/ testsuite/ selfhost/diag selfhost/modules'`
  - `CLARUS_BAKE_FULL=1 make test T=bake/`

  Goldens that move: inspect one cg68k `.s` and one emitui golden by hand, confirm the diff is only the `native.cla`/`uiscript.cla` runtime change (the new `natCapture` branches and the trace gate calls), then rebless:
  - `CLARUS_CG68K_BLESS=1 make test T=cg68k/goldens`;
  - the emitui goldens by the mechanism their scripts use.

  Commit each family separately with that reason.
- [ ] **Step 4: Emulator proof.** Run the Global Constraints emulator command (the whole `mactest/` group). Expected:
  - every script PASS or its usual SKIP;
  - core 89/89 and toolbox 41/41;
  - `ui_scenarios`/`smoke_bounce` with no `CLARUS_MAC_BLESS` needed, which proves the capture byte-identity;
  - `nolog` PASS.
- [ ] **Step 5: Gate and commit.** Run `scripts/test-task.sh`, then commit: `feat(runtime): production native builds write no out file; --capture keeps the test protocol`.

**Interfaces produced:** `natCapture: bool` (native.cla); `UiTraceOn(): bool` extern with `nat_UiTraceOn`/`rt_ext_UiTraceOn`; `cgCaptureMode` (cg68k.cla); `emit68k --capture`; `build-68k.sh --capture`.

---

### Task 2: `app.writeLog` / `app.flushLog` / `app.trace` and the production writer

**Files:**
- Modify: `clarusc/check.cla`, `clarusc/lower.cla`, `clarusc/cg68k.cla`, `clarusc/cprint.cla`
  - Add `app.writeLog(name: string)`, `app.flushLog()` and `app.trace(on: bool)` as statement calls (no result) in the `app.` namespace. `app.doctype`/`app.id` are compile-time constants today (`check.cla`'s `appProps` ~l.964).
  - Lower each to a runtime call, following whichever existing runtime-routed builtin is closest (read how `file.*` builtins reach `native.cla`/`rt.c` and copy that shape).
  - Target names: native `natAppWriteLog(name: ptr-or-string, per the existing file.* convention)`, `natAppFlushLog()`, `natAppTrace(on: bool)`; C lane `rt_app_write_log`, `rt_app_flush_log`, `rt_app_trace`.
  - A wrong argument type is a checker error in the existing builtin-arity/type wording.
- Modify: `runtime/clarus/native.cla`, production branch:
  - `natAppWriteLog`:
    - if a log file is open, flush and close it;
    - resolve `name` like `natFileWriteText` resolves paths; create it (stamp `TEXT`/`app.id`, the same stamp helper `natFileWriteText` uses) if missing, open read/write, and `SetFPos` to EOF (append);
    - allocate `natLogBuf` (4096) on first use;
    - on failure, set `lastError` through `nat_CoreSetLastErr`, leave logging off, and return (no abort).
  - `natLog` in production: if a file is open, append the CR→LF-rendered line plus LF to the buffer. When the line does not fit, write the buffer first. A line longer than the whole buffer is written directly.
  - `natAppFlushLog`: write the buffer, `FlushVol`, reset the length.
  - `natAlert` (non-UI `alert`) in production: the same as `natLog`.
  - `nat_CorePanic` in production: add the report line, flush, then quit.
  - `natQuit` in production: flush, close, `ExitToShell`.
  - `nat_UiTestEmit` in production: add the line like `natLog`, only if the trace flag is on and a file is open.
  - `natAppTrace` sets `natTraceOn`; `nat_UiTraceOn` returns `natCapture or natTraceOn`.
  - In **capture mode**, `natAppWriteLog`/`natAppFlushLog`/`natLog`/`nat_CorePanic` also feed the named file exactly as in production, **in addition to** the unchanged capture stream (spec §3.3). `natAppTrace(false)` is ignored in capture mode.
  - Uncaught-abort reporting: find where the native top-level abort default writes its message (it goes through `log`/`CorePanic`-like paths, see reference Ch5 ~l.846). Make sure it lands in the file and flushes.
- Modify: `runtime/host/rt.c`, next to `rt_log`.
  - `rt_log` keeps writing stderr. When a log file is open it also buffers the line (4096-byte buffer, the same rules: flush when full, a long line written directly).
  - `rt_app_write_log`: `fopen(name, "ab")`, flushing and closing any previous file; on failure set lastError the way host `file.*` helpers do.
  - `rt_app_flush_log`: write the buffer and `fflush`.
  - `rt_app_trace`: no-op.
  - `rt_panic` (and the uncaught-abort path) flushes the log file before exiting.
  - Normal exit flushes via the existing exit path (`rt_quit`/atexit, whichever the file uses).
- Modify: `runtime/mac/rt_mac.c` (Retro68, demoted): no-op `rt_app_write_log`/`rt_app_flush_log`/`rt_app_trace`, so C-lane Mac builds still link.
- Create: `tests/hostrt/logfile.sh`, built with `host_build` from `tests/lib.sh` (read how sibling `tests/hostrt/*.sh` or `tests/lowlevel/*.sh` build and run a `.cla` on the host), plus its fixtures under `testdata/hostrt/`. Subcases, each a `t_pass`/`t_fail`:
  - `create_append`: run a program that `writeLog("L.txt")`, logs `a`,`b`; run it again logging `c`. File is exactly `a\nb\nc\n`.
  - `flush_midrun`: log `x`, `app.flushLog()`, then the program reads `L2.txt` back with `file.readText` and prints its length. Expect 2.
  - `autoflush`: log 300 lines of 20 chars (more than 4 KB). The file has all 300 lines in order.
  - `longline`: one 5000-char line. The file has it whole.
  - `switch`: `writeLog("A.txt")`, log `1`, `writeLog("B.txt")`, log `2`. A is `1\n` and B is `2\n`.
  - `panic`: `writeLog("P.txt")`, log `before`, then trigger a runtime panic (an out-of-range list index). The file ends with `before\n` then the `runtime error: …` line.
  - `badpath`: `writeLog("nosuchdir/x.txt")`. `lastError` is set, the program continues, and a following `log("y")` still reaches stderr and doesn't crash.
  - `off`: a program that never calls `writeLog` creates no file in its cwd.
- Create: `testsuite/core/cases_logfile.cla`, a `LogFile` case, registered like Wave 3's `SerV1Enum` (enum, name, dispatch, `nCoreCases` 89 → 90, and the other four places plus the file lists `tests/testsuite/core_cli.sh`, `tests/mactest/coregui_files.txt`, `tests/cg68k/segments.sh` if it lists core files). It:
  - `app.writeLog("core_log.txt")`, `log("one")`, `app.flushLog()`, and reads the file with `file.readText`. It must end with `one\n`, because the file is append-mode and earlier runs may have left lines; delete it first with `file.delete` so the check is exact: `one\n`.
  - `app.writeLog("core_log2.txt")` (switch), `log("two")`, `app.flushLog()`. `core_log.txt` is still `one\n` and `core_log2.txt` is `two\n`.
  - `app.writeLog("nosuchdir/x.txt")`: `lastError` is set, and a following `log("z")` does not crash.
  - Cleans up both files.
- Modify: `tests/mactest/nolog.sh`. Add a second fixture `testdata/mactest/logout.cla`, built without `--capture`, that calls `app.writeLog("out")`, logs `l1`/`l2`/`l3` and quits 0. Assert the capture is exactly `l1\nl2\nl3\n`, with no `##CLARUS-EXIT##`.
- Modify: `docs/clarus-language-reference.md`
  - a new "Log File and Tracing" section (spec §3.1–3.3 in reference voice: the three calls, append, when the buffer is written, what goes in the log, that `App.log` fires regardless, and a sentence that test builds use `--capture`);
  - Chapter 12's `log` paragraph (~l.1680, "a destination reserved for a later release");
  - `App.log` rule 1 (~l.928).

- [ ] **Step 1: Failing tests.** Write `tests/hostrt/logfile.sh` and the fixtures. Run `make test T=hostrt/logfile`. Expected: FAIL (`app.writeLog` unknown).
- [ ] **Step 2: Implement** the checker/lowering, the native writer, the host writer and the Retro68 stubs.
- [ ] **Step 3: Host checks.** Run `make test T='hostrt/ testsuite/ lowlevel/ emitui/ bake/ cg68k/ selfhost/diag selfhost/modules'` and `CLARUS_BAKE_FULL=1 make test T=bake/`. Rebless moved compile-only goldens in a separate commit, with the reason and a hand-inspected diff.
- [ ] **Step 4: Emulator proof.** Run the whole `mactest/` group. Expected: core 90/90 including `LogFile`, toolbox 41/41, `nolog` PASS (both subcases), the rest unchanged.
- [ ] **Step 5: Gate and commit.** Run `scripts/test-task.sh`, then commit: `feat(lang): app.writeLog/flushLog/trace -- opt-in buffered log file`.

**Interfaces consumed:** Task 1's `natCapture`, `UiTraceOn`, `--capture`.

---

### Task 3: Snapshot regeneration, docs, final gates

**Files:** `clarusc/clarusc.c` (regenerated), `docs/HISTORY.md` (a new entry: what changed, the rulings from the ledger, gate results), `docs/ROADMAP.md` (one line: detour done), `docs/TODO.md` (anything deferred).

- [ ] **Step 1:** Regenerate the snapshot: run `make test T=selfhost/fixedpoint` and follow its printed recipe until it passes. Then `make test T=selfhost/` must be 6/6. Commit `clarusc/clarusc.c` alone.
- [ ] **Step 2:** `make test T=memgate/`. Record the peaks. Budgets are only ever lowered, never raised.
- [ ] **Step 3:** Docs. Every Markdown table must have aligned columns.
- [ ] **Step 4:** The gates:
  - `scripts/test-task.sh`;
  - `CLARUS_MAC_TESTS=1 make -j1 test T=mactest/`;
  - `CLARUS_BAKE_FULL=1 make test T=bake/`.

  Record the results in HISTORY. (Andrew: no Snow run for this detour.)
- [ ] **Step 5:** Commit: `docs(log-trace): history, roadmap, TODO`.
