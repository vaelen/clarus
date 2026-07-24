# Mac Target 4a — "hello, Macintosh" — Design

Date: 2026-07-24. Status: approved design, pre-implementation.
Roadmap context: `docs/ROADMAP.md` "Mac target (Plan 4)" — this spec covers
4a only. 4b (windows/menus/events) gets its own design later.

## Goal

Prove the printer seam end to end: a Clarus program emitted to C by clarusc,
compiled with Retro68 against a Toolbox-native runtime, running as a real
APPL on a Mac Plus (Mini vMac, System 6), with the existing host corpus as
the regression net. Acceptance artifact: an alert-only "hello, Macintosh"
program on screen in the emulator.

## Non-goals (4a)

- No windows, menus, canvases, event loop, forms, timers — that is 4b.
- No networking, no Standard File dialogs (later phases per roadmap).
- No compiler changes (Go compiler stays frozen; clarusc stays a pure
  emitter). Any emitted-C incompatibility with Retro68 gcc is fixed in the
  runtime or build glue, not by forking the printer — unless the printer has
  an actual portability bug, which lands in clarusc + reference as usual.

## Pipeline

`scripts/build-mac.sh <Name> <files.cla...>` orchestrates; no compiler
changes:

1. Host-built clarusc: `clarusc emit -o build-mac/<Name>.c <files.cla...>`
2. Retro68 cmake (`add_application`, toolchain file
   `toolchain/m68k-apple-macos/cmake/retro68.toolchain.cmake`) compiles the
   emitted C + `runtime/mac/` into `<Name>.bin` / `.APPL` / `.dsk`.

Emitted C needs zero changes: `main()` already calls `rt_args_init` then the
launch/start handlers; Retro68 supplies `main(argc, argv)` with empty argv,
so `App.startCLI` programs fall back to `startEmpty` naturally.

Prerequisites (developer machine): `Retro68/`, `toolchain/`, `macplus/`
symlinks per CLAUDE.md, `~/.LaunchAPPL.cfg` configured (minivmac backend).

## Mac runtime — `runtime/mac/`

Implements the full existing ABI in `internal/build/rt/rt.h` (shared header;
single source of ABI truth — the Mac runtime must not fork it). Toolbox-
native per the roadmap: Handles, BlockMoveData, real Str255. No malloc, no
console library (Retro68's console lib is known-broken on the Mac Plus and
unneeded).

- **Strings**: the `[len][bytes]` layout is already Str255 — semantics
  (clamping, lastError on truncation, strict slice bounds) copied from the
  host implementation.
- **text / list / map**: Handle-backed growable buffers
  (`NewHandle`/`SetHandleSize`), same amortized growth and sorted-key map
  semantics as host. Handles are locked only around access, or accessed via
  dereference-and-BlockMove, never cached across Toolbox calls that can move
  memory.
- **rt_alert**: modal alert — `ParamText` + stock ALRT/DITL resource (Rez).
  Clarus `\n` is CR, which dialog text renders as a line break natively.
  Toolbox init (`InitGraf`/`InitFonts`/`InitWindows`/`InitMenus`/
  `TEInit`/`InitDialogs`/`InitCursor`) happens lazily on the first UI call.
- **rt_log**: no-op in the normal build (no stderr on System 6; revisit in
  4b, e.g. a debug window). Captured in the test build.
- **rt_panic**: alert showing `runtime error: MSG`, then exit with code 3
  (test build: recorded instead).
- **rt_file_read_text / rt_file_write_text / rt_file_name**: File Manager
  (`FSOpen`/`FSRead`/`FSWrite`/`Create`), byte-faithful (binary-fidelity
  guarantee: no newline translation), paths resolved relative to the app's
  volume/directory. Text files get type `TEXT`.
- **rt_quit**: flush any pending state, `ExitToShell` (normal build).
- **rt_args_init / rt_args_list**: empty args list (no CLI on classic Mac).

## Corpus restructuring (host-visible, Mac-motivated)

Each `testdata/run` program is split so the suite can be composed in pure
Clarus — no linker tricks, portable to the future Mac-resident clarusc:

- `X.cla` — the test logic. Top-level names uniquified across the corpus
  (one shared namespace when concatenated). Exposes one entry func
  (`runX()`). No `on` handlers, no `quit`.
- `run_X.cla` — standalone wrapper: the launch/start handlers and any
  terminal `quit`, calling `runX()`. `clarus run X.cla run_X.cla` behaves
  byte-identically to today's single file; existing goldens are unchanged.
- `test_suite.cla` — generated or hand-maintained list: compiled together
  with every `X.cla`; its launch handler runs each entry func between
  `=== X ===` alert delimiters.

The 3 `testdata/runerr` programs (deliberate panics, specific exit codes)
stay standalone apps — pure Clarus has no catch, so panic isolation remains
a process concept. They are small and few.

Multi-file compilation (declared file order) is an existing language
feature; the suite exercises it as a bonus.

## Testing strategy

Differential, same as everything else in this project: **the host run of
`test_suite` is the expected output; the Mac run must byte-match.**

- Test build of the Mac runtime (`-DRT_MAC_TEST`): `rt_alert` and `rt_log`
  append to a capture file on the boot volume (named `out` — probe whether
  LaunchAPPL echoes it back on stdout; if not, extract via `hcopy` from a
  preserved image). Everything else behaves normally.
- Opt-in Go test (`internal/mactest`, gated on `CLARUS_MAC_TESTS=1` since it
  needs the toolchain, emulator, and a display):
  1. Build `test_suite` for host, run it, capture stdout (expected).
  2. Build it for Mac (test build), run via `LaunchAPPL -e minivmac`,
     extract the capture file, byte-compare.
  3. For each runerr program: same build/run/extract, compare captured
     output against its `.err` content and recorded exit code.
- Ungated `go test ./...` stays fast and green; the Mac harness runs on
  demand.
- Emulator control/screenshot recipes per CLAUDE.md (window geometry via
  System Events, `screencapture -R`, `scripts/click.swift`).

## Milestone artifact

`examples/hello-mac.cla`: alert-only program (`on App.launch { alert(...) }`).
Built by `scripts/build-mac.sh`, launched via LaunchAPPL in Mini vMac,
alert visible in a screenshot, clean exit (LaunchAPPL exit 0).

## Acceptance

1. `scripts/build-mac.sh HelloMac examples/hello-mac.cla` produces a
   `.bin`/`.APPL`/`.dsk`; the app shows the alert in Mini vMac and exits
   cleanly (screenshot + LaunchAPPL exit 0).
2. `CLARUS_MAC_TESTS=1 go test ./internal/mactest` is green: suite output
   from the Mac byte-matches the host run; runerr apps match `.err` +
   exit codes.
3. Ungated `go test ./...` remains green after the corpus restructuring
   (wrappers reproduce today's behavior; goldens unchanged).
4. No compiler changes: `cmd/`, the compiler packages under `internal/`,
   and `clarusc/*.cla` are untouched. Test harnesses may adapt (the golden/
   differential runners learn the `X.cla` + `run_X.cla` pairing; the new
   `internal/mactest` is added).

## Risks and probes

- **LaunchAPPL `out` round-trip**: unknown whether the minivmac backend
  echoes the `out` file for non-console apps. Probe first; fallback is
  `hcopy` extraction. (Plan should front-load this probe.)
- **Emitted-C portability**: gcc 16 for m68k may warn/misbehave on emitted
  idioms (e.g. the `t1;` unused-value temps observed in the snapshot).
  Warnings are acceptable; miscompiles are not — caught by the suite diff.
- **Memory ceiling**: suite app = 21 tests' code + data in a 4 MB Mac Plus.
  Expected to fit easily (host suite C is well under 1 MB of code); if not,
  shard the suite list into K compilations = K boots.
- **Charset**: Clarus source/output is byte-oriented; capture-file
  comparison is byte-wise, so MacRoman-vs-ASCII is a non-issue for the
  existing corpus (ASCII-only).

## Sequencing note

Corpus restructuring lands first (host-only, fully testable by the existing
suite), then the Mac runtime + build script, then the harness, then the
hello artifact — main stays green throughout per project convention.
