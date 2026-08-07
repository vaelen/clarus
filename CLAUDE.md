# CLAUDE.md

Clarus is a compiled, event-driven language for System 6/7 68k Macs.
Read `docs/ROADMAP.md` first — it is the authoritative record of sequencing
and strategy. `docs/clarus-language-reference.md` is the normative language
spec; where any other doc disagrees, the reference wins.
`docs/clarus-toolbox-cookbook.md` is a how-to companion for transcribing
Inside Macintosh declarations into Clarus `extern`/`callback` forms.

## Working conventions

- Design-first: brainstorm → spec → plan → implement (specs in
  `docs/superpowers/specs/`, plans in `docs/superpowers/plans/`).
- Implementation is ALWAYS subagent-driven (superpowers:subagent-driven-development)
  using cheaper models (`model: sonnet` for implementation and review tasks;
  `haiku` for mechanical batch edits). The top-level (Fable) session designs,
  dispatches, reviews, and integrates — it does not write implementation code
  itself. Final whole-branch review may use the most capable model.
- Feature branch per plan; main stays green; merge only on request.
- Toolbox calls (runtime included) go through `toolbox/*.cla`; when a new
  feature needs a new Toolbox routine, enable the rest of that manager's
  interface at the same time where feasible. Users get friendly Clarus
  abstractions (80/20 — a standard app needs zero Toolbox knowledge); the
  catalog is the escape hatch. Prefer 1980s-IM (System 6) APIs; gate
  System 7-only features behind a Gestalt check with graceful fallback.
  Full statement: ROADMAP item 3's GUIDING PRINCIPLE block.

## Build and test

```sh
scripts/clarus-run.sh FILE.cla [-- args...]  # Go-free day-to-day `clarus run`
scripts/test-task.sh              # T1: per-task gate (~15s)
scripts/test-merge.sh             # T2: per-merge gate (~5m, needs the emulator)
```

- `scripts/clarus-run.sh` is the Go-free replacement for `clarus run` day
  to day: it bootstraps clarusc from the committed `clarusc/clarusc.c`
  snapshot with `cc` alone (cached under `build-run/`, keyed on the
  snapshot's mtime), emits C for `FILE.cla`, compiles that against the
  on-disk host runtime (`runtime/host`), and execs the result with
  any args after `--`. No Go compiler involved.

Tiered test gates:

- `scripts/test-task.sh` — T1, run after every task. Every package except
  `internal/selfhost`, with `-count=1` (see below). Add `--smoke` when a
  task touches `runtime/` or `clarusc/`, which additionally runs the two
  native-68k emulator smoke tests (`CLARUS_MAC_TESTS=1`,
  `TestSmokeBounceOn68k` / `TestRealEventLoopTickOn68k` in
  `internal/mactest`). The Go compiler was deleted in the Go-compiler-deletion
  phase (tag `go-compiler-final`); the gauntlet is all-harness, no
  compiler-unit packages remain.
- `scripts/test-merge.sh` — T2, run before merging to main. T1's body plus
  `internal/selfhost` (30m-timeout bootstrap suite) plus the gated
  `internal/mactest` package's native (emit68k) lane (`CLARUS_MAC_TESTS=1`,
  needs the Retro68 toolchain + Mini vMac). The Retro68/cprint-gcc lane
  (pack3-standardfile phase, 2026-08-07) is demoted off this gate — it's an
  opt-in diagnostic behind `CLARUS_CPRINT_MAC_TESTS=1`, kept as a
  cross-lane localization oracle (the native lane already covers every
  case it checks) rather than deleted; deletion is deferred to the 5f
  Retro68-retirement phase. The C printer's remaining first-class role is
  host builds (`clarusc emit` + `cc`).
- Both pass `-count=1` to bust the Go test cache. Plain `go test` caches a
  package's result keyed on its `.go` inputs; it does not know about
  `.cla` fixtures a test reads at runtime (e.g. emitui-style
  golden/snapshot tests), so an edited `.cla` with unchanged `.go` can
  silently replay a stale PASS. `-count=1` forces a real re-run every
  time, closing that silent-red hole.
- `internal/selfhost` has outgrown `go test`'s default 10-minute
  per-package timeout — always pass `-timeout 30m` when running it
  directly, or it can spuriously fail on an otherwise-green tree.

- The Go compiler is DELETED (tag `go-compiler-final`). clarusc
  (`clarusc/*.cla`) is the only compiler; new language features land in the
  reference + clarusc.
- `clarusc/clarusc.c` is the committed bootstrap snapshot. If
  `TestSnapshotFixedPoint` (`internal/selfhost`) fails, it prints the
  Go-free regeneration instructions.
- Bootstrap from C alone:
  `cc -I runtime/host -o clarusc clarusc/clarusc.c runtime/host/rt.c`
- `--testapi` (`clarusc emit`/`emit68k`/`appinfo`, ui-scenario-retirement
  phase): for a UI program, splices the UI runtime modules PLUS
  `runtime/clarus/uitest.cla` (`UiTestVerb` + wrappers +
  `UiTestChecksum`) in early, before the ordinary clean-standalone check,
  so the program can name runtime/`UiTest*` functions. Without the flag,
  ordinary programs cannot name runtime functions at all (clarusc
  enforces user code checks standalone before any runtime module is
  consulted) and behavior is byte-identical to no-flag builds — the
  emitui/frozen-scenario goldens are the proof. A no-op on non-UI
  programs. Check-only mode (bare `clarusc FILE...`) doesn't recognize
  the flag at all — it's only matched under `emitMode`/`emitMode68k`/
  `appinfoMode` (`clarusc/main.cla`); in check-only mode it falls into
  the generic positional-file-args branch and is treated as a bogus
  entry filename (`clarusc --testapi FILE.cla` fails `cannot open entry
  file`, exit 1). Only the suites' GUI (`gui.cla`, `--events`-driven)
  builds pass it — `core`'s non-UI host CLI (`cli.cla`) doesn't need it;
  nothing outside the two suites does.

### `core`/`toolbox` test suites (`testsuite/`)

Clarus-native test suites (test-suite-review phase, Tasks 8-13) — ordinary
Clarus functions returning pass/fail, run in-process by a hand-maintained
enum + runner, not one boot per case.

- `testsuite/core/` (42 `CoreTest` cases: 41 real + `SelfCheck`) runs on
  host and natively; `testsuite/toolbox/` (24 `ToolboxTest` cases: 23 real +
  `SelfCheck`, grown from 7 by the ui-scenario-retirement phase — 12 of the
  legacy `testdata/ui` scenarios migrated in as cases, plus two new
  machinery cases, `UiTestVerbSmoke` and `PostEventClick` — then to 22 real
  by the test-consolidation phase, which migrated `formedit`/
  `texteditor_bigfile` in as `FormEdit`/`BigText` — then to 23 real by the
  toolbox-cookbook phase's `Catalog` case, which hardware-proves the
  `toolbox/` catalog below) needs
  the real Toolbox/emulator. Each has `runner.cla` (the enum + dispatch +
  `tkReport` result log) plus `cases_*.cla` families; `core` additionally
  has a host CLI (`cli.cla`, real argv) and a Mac/native front end
  (`cli_mac.cla` — `cli.cla` can't boot natively, see its own doc comment:
  cg68k's non-UI startup stub fires `App.startCLI` with a never-marshaled
  `args` list). Both suites also have a scriptable GUI front end
  (`gui.cla`, driven by `--events` the same way the legacy UI goldens are).
- **Run `core` on host** (compose recipe — no single-file entry point,
  `clarusc emit`/`emit68k` both take multiple `.cla` files positionally):
  ```sh
  cc -O1 -I runtime/host -o build-run/clarusc clarusc/clarusc.c runtime/host/rt.c   # once
  build-run/clarusc emit --rtdir runtime/clarus/ -o /tmp/core_cli.c \
      testsuite/kit.cla testsuite/core/runner.cla testsuite/core/cases_*.cla testsuite/core/cli.cla
  cc -O1 -I runtime/host -o /tmp/core_cli /tmp/core_cli.c runtime/host/rt.c
  /tmp/core_cli all   # or one/some case names by `CoreTest` enum name; nonzero exit on any FAIL
  ```
  `SelfCheck` as the CLI's lone explicit arg always FAILs, by contract
  design: it asserts all 40 other cases ran in the same invocation
  (`casesRun == nCoreCases - 1`), so pass it alongside other names (or use
  `all`), never alone.
  (Exact file list: `internal/mactest/suite_host_test.go`'s
  `coreCLIHostFiles`/`coreCLIFiles`.) `toolbox` has no host CLI by design
  (Toolbox/hardware-only) — it only runs via a Mac/native boot.
- **The four gated suite-boot tests** (`internal/mactest/coresuite_test.go`),
  one boot each, both platform lanes: `TestCoreSuiteGUIOn68k`/
  `TestCoreSuiteGUIOnMac` (native `emit68k` / Retro68-cprint twins,
  `core/gui.cla` + `--events`) and `TestToolboxSuiteOn68k`/
  `TestToolboxSuiteOnMac` (same, `toolbox/gui.cla`). Each parses the
  captured `tkReport` log and fans it out into one Go subtest per case
  (`t.Run(caseName, ...)`) for per-case red/green. The `On68k` halves run
  under T2's default `CLARUS_MAC_TESTS=1 go test ./internal/mactest`
  (`scripts/test-merge.sh`); not part of T1. The `OnMac` twins are the
  Retro68/cprint lane, demoted (pack3-standardfile phase, 2026-08-07) to
  an opt-in diagnostic behind `CLARUS_CPRINT_MAC_TESTS=1` — SKIP under
  bare `CLARUS_MAC_TESTS=1`, so they no longer run as part of T2 by
  default.
- `toolbox/{memory,events,osutils,scrap,standardfile,files}.cla`
  (toolbox-cookbook phase; the last two added by pack3-standardfile) is a
  curated extern catalog of real Inside Macintosh trap declarations,
  ready to compose into a build (positionally or via `include`) for new
  UI code instead of hand-declaring traps; `internal/testsuite/
  catalog_test.go` is its T1 check. See
  `docs/clarus-toolbox-cookbook.md` for worked transcription examples.

## Retro68 / Mac toolchain (symlinks, not in git)

- `Retro68/` → Retro68 source; Universal Interfaces in
  `Retro68/InterfacesAndLibraries`.
- `toolchain/` → built cross-toolchain (`toolchain/bin`: gcc, Rez, LaunchAPPL,
  hfsutils h* tools). Prebuilt samples: `../Retro68-build/build-target/Samples/`.
- `macplus/` → Mini vMac emulator (`MacPlus.app`) + `vMac.ROM`.

To build a Mac app from C: `CMakeLists.txt` with `add_application(Name src.c)`, then

```sh
cmake -B build -DCMAKE_TOOLCHAIN_FILE=$REPO/toolchain/m68k-apple-macos/cmake/retro68.toolchain.cmake
make -C build    # produces Name.bin (for LaunchAPPL), Name.APPL, Name.dsk
```

## Running Mac apps in the emulator

`~/.LaunchAPPL.cfg` is already configured (minivmac backend: `macplus/MacPlus.app`,
`macplus/vMac.ROM`, system image `~/mac/System 6.0.8.dsk`, AutoQuit at
`~/mac/macplus/autoquit-1.1.1.dsk`).

```sh
toolchain/bin/LaunchAPPL -e minivmac App.bin   # takes MacBinary (.bin)
```

- Build a Clarus program for Mac: `scripts/build-mac.sh <Name> <files.cla...> [--test]`
  (snapshot-bootstrapped clarusc emit → Retro68 cmake → `.bin`/`.APPL`/`.dsk`
  under `build-mac/`).
- Build a Clarus program as a NATIVE 68k binary (no C, no cmake, no
  Retro68): `scripts/build-68k.sh [Name] <files.cla...> [--events FILE]`
  (snapshot-bootstrapped clarusc `emit68k` directly → `.bin` under
  `build-68k/`; `Name` is optional — derived from `clarusc appinfo` when
  the first arg is a `.cla` file). `--events FILE` pours a scripted-event
  file into the native constant pool for deterministic UI driving, the
  native counterpart to `build-mac.sh`'s own `--events` below.
- Gated Mac-vs-host byte-compare harness (needs the toolchain + emulator):
  `CLARUS_MAC_TESTS=1 go test ./internal/mactest`.
- UI test scenarios live in `testdata/ui`, with blessed goldens (trace +
  PBM framebuffer snaps) under `testdata/uisnaps` — the snaps are viewable
  PBMs. `CLARUS_MAC_BLESS=1` regenerates both, via the **native** lane
  (`internal/mactest/native_test.go`'s `clarusc emit68k` boots) — the
  test-consolidation phase's Task 7 (2026-08-06) retired the Retro68/cprint
  scenario lane outright (`ui_test.go`'s per-scenario `TestSmokeBounceUIScenario`/
  `TestSmokeMandelUIScenario`/`TestTexteditorUIScenario`/`TestBookmarksUIScenario`),
  so the native lane is now the ONLY lane that boots these scenarios, and
  the only place `CLARUS_MAC_BLESS=1` has any effect (`checkUIGoldens`,
  shared by both lanes before Task 7, is now called only from
  `native_test.go`). `scripts/build-68k.sh`/`clarusc emit68k --events FILE`
  compile a scripted event sequence into a test build for deterministic UI
  driving (no real input needed); `scripts/build-mac.sh` still takes
  `--events FILE` too, for the two opt-in Retro68/cprint suite-gate
  diagnostics (`TestCoreSuiteGUIOnMac`/`TestToolboxSuiteOnMac`, demoted
  behind `CLARUS_CPRINT_MAC_TESTS=1` by the pack3-standardfile phase,
  2026-08-07) and any future Retro68-lane build, but no longer for
  scenario goldens. The
  ui-scenario-retirement phase (2026-08-05) migrated 12 of the original 23
  scenarios into `testsuite/toolbox` cases and retired their
  `testdata/ui`/`testdata/uisnaps` fixtures; the test-consolidation phase
  migrated two more (2026-08-06): Task 3 migrated `formedit` (now
  `testsuite/toolbox/cases_formedit.cla`'s `FormEdit` case, once the
  blocking native-68k `accepted(rec)` trailing-`bool` codegen bug was
  fixed) and Task 4 migrated `texteditor_bigfile` (its >32,000-byte
  clamp/lastError/tail-content shape now lives in the toolbox suite's
  `BigText` case, testsuite/toolbox/cases_bigtext.cla; its own
  alert-message/close-cascade business logic stays covered by
  `examples/texteditor.cla` remaining in the `texteditor` acceptance boot).
  4 survive as frozen golden scenarios (`smoke_bounce`, `smoke_mandel`,
  `texteditor`, `bookmarks`), each booted ONLY on the native lane now
  (Task 7); `about`'s own coverage lives inside `smoke_mandel`'s events
  script, and `texteditor`'s own script has absorbed `opendoc`/
  `opendoc_empty`/`texteditor_quit`'s coverage — none of those four have
  their own standalone scenario anymore.
- This sandboxed display has a short (well under a minute of zero real HID
  activity) idle-lock; a naive long `sleep` with no synthetic input during
  manual real-input testing can look identical to a frozen app — nudge with
  a synthetic `CGEvent(mouseMoved)` (no click) periodically during waits.

- LaunchAPPL builds a stripped boot disk (System + AutoQuit + app), boots it
  in a fresh Mini vMac copy, and BLOCKS until the app quits — run it in the
  background. It creates a temp dir in the cwd (auto-removed on clean exit;
  delete it manually if you kill the process). Exit 0 = app ran and quit.
- To run an app with the full Finder instead: copy `MacPlus.app` to a scratch
  dir, put `vMac.ROM` and a bootable image as `Contents/mnvm_dat/disk1.dsk`
  (app disk as `disk2.dsk`), and `open -na` the copy. Mini vMac auto-mounts
  the `mnvm_dat` disks.

### Controlling and screenshotting the emulator

The emulator window is the Mac's 512×342 screen at 2× (1024×684 + title bar).

```sh
# window geometry {x, y, w, h}:
osascript -e 'tell application "System Events" to tell process "minivmac" to get {position, size} of window 1'
# screenshot that region:
screencapture -x -Rx,y,w,h shot.png
# mouse (CGEvent): screen coords = window origin + 2 × Mac coords
swift scripts/click.swift <x> <y> [double]
# keyboard (focus the window first):
osascript -e 'tell application "System Events" to set frontmost of process "minivmac" to true'
osascript -e 'tell application "System Events" to keystroke "text"'
```

Screenshot → read the image → click at computed coords → screenshot again.
System 6 boots in ~2-3 s; sleep ~10 s after launch before interacting.

### Known issues

- Retro68's console-library samples (HelloWorld, Raytracer) crash on launch
  with system error 3 (illegal instruction) on the Mac Plus — the binary
  itself, not the launch path. Plain Toolbox apps (Dialog sample) work fine.
  Don't use the console library as a reference for whether the pipeline works.
