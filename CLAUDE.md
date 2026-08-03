# CLAUDE.md

Clarus is a compiled, event-driven language for System 6/7 68k Macs.
Read `docs/ROADMAP.md` first — it is the authoritative record of sequencing
and strategy. `docs/clarus-language-reference.md` is the normative language
spec; where any other doc disagrees, the reference wins.

## Working conventions

- Design-first: brainstorm → spec → plan → implement (specs in
  `docs/superpowers/specs/`, plans in `docs/superpowers/plans/`).
- Implementation is ALWAYS subagent-driven (superpowers:subagent-driven-development)
  using cheaper models (`model: sonnet` for implementation and review tasks;
  `haiku` for mechanical batch edits). The top-level (Fable) session designs,
  dispatches, reviews, and integrates — it does not write implementation code
  itself. Final whole-branch review may use the most capable model.
- Feature branch per plan; main stays green; merge only on request.

## Build and test

```sh
go build -o clarus ./cmd/clarus   # host toolchain: check / build / run
scripts/clarus-run.sh FILE.cla [-- args...]  # Go-free day-to-day `clarus run`
scripts/test-task.sh              # T1: per-task gate (~35s)
scripts/test-merge.sh             # T2: per-merge gate (~15m+, needs the emulator)
```

- `scripts/clarus-run.sh` is the Go-free replacement for `clarus run` day
  to day: it bootstraps clarusc from the committed `clarusc/clarusc.c`
  snapshot with `cc` alone (cached under `build-run/`, keyed on the
  snapshot's mtime), emits C for `FILE.cla`, compiles that against the
  on-disk host runtime (`internal/build/rt`), and execs the result with
  any args after `--`. No Go compiler involved.

Tiered test gates:

- `scripts/test-task.sh` — T1, run after every task. Every package except
  `internal/selfhost`, with `-count=1` (see below). Add `--smoke` when a
  task touches `runtime/` or `clarusc/`, which additionally runs the two
  native-68k emulator smoke tests (`CLARUS_MAC_TESTS=1`,
  `TestSmokeBounceOn68k` / `TestRealEventLoopTickOn68k` in
  `internal/mactest`). T1 no longer builds or links the Go compiler for
  any test it runs (see `CLARUS_GO_DIFF` below) — packages that are pure
  Go-compiler unit tests (`internal/lexer`, `parser`, `check`, `types`,
  `lower`, `cprint`, `driver`, `cmd/clarus`) report as passing-with-no-tests
  by default; `internal/build`'s Go-compiler tests (`build_test.go`,
  `golden_test.go`, `unsupported_test.go`) skip individually while its rt
  C-runtime tests (`rtsmoke`, `memtest_c`, `rctest_c`, `sertest_c` — these
  exercise `rt.c` with `cc`, not the Go compiler, and every lane depends on
  `rt.c`) keep running unconditionally.
- `scripts/test-merge.sh` — T2, run before merging to main. T1's body plus
  `internal/selfhost` (30m-timeout bootstrap suite, run with
  `CLARUS_GO_DIFF=1` so the Go lanes below are included) plus the full
  gated `internal/mactest` package (`CLARUS_MAC_TESTS=1`, needs the Retro68
  toolchain + Mini vMac).
- Both pass `-count=1` to bust the Go test cache. Plain `go test` caches a
  package's result keyed on its `.go` inputs; it does not know about
  `.cla` fixtures a test reads at runtime (e.g. emitui-style
  golden/snapshot tests), so an edited `.cla` with unchanged `.go` can
  silently replay a stale PASS. `-count=1` forces a real re-run every
  time, closing that silent-red hole.
- `internal/selfhost` has outgrown `go test`'s default 10-minute
  per-package timeout — always pass `-timeout 30m` when running it
  directly, or it can spuriously fail on an otherwise-green tree.

### `CLARUS_GO_DIFF` — Go-compiler lanes are opt-in

`internal/selfhost` and every package that IS the frozen Go compiler
(`internal/lexer`, `parser`, `check`, `types`, `lower`, `cprint`, `driver`,
`cmd/clarus`, plus `internal/build`'s `Build()`-calling tests) gate their
tests behind `CLARUS_GO_DIFF=1`, unset by default. The default `go test
./...` gauntlet is Go-free — it never builds, links, or runs a Go-compiled
`clarusc` binary — because Tasks 3-5b of test-suite-review landed Go-free
oracles that cover the same ground without the Go compiler as a reference:
`internal/selfhost/behavior_test.go` (snapshot-built clarusc vs. committed
`.behavior` goldens, including the paranoid-allocator `.leaks` pin),
`crossgen_test.go` (snapshot generation vs. current-source generation, both
built without Go), and `snapshot_test.go`'s `TestSnapshotBuilds` /
`TestSnapshotFixedPoint` (C-snapshot self-consistency). Set
`CLARUS_GO_DIFF=1` to reinstate the Go differential/bootstrap/coverage
lanes — for ad hoc debugging (`CLARUS_GO_DIFF=1 go test ./internal/selfhost
-timeout 30m`) or via `scripts/test-merge.sh`, which exports it for its
`internal/selfhost` and full runs.

- The Go compiler (`cmd/clarus`, `internal/`) is FROZEN — it is the
  differential-testing reference only. New language features land in the
  reference + `clarusc` (the self-hosted compiler, `clarusc/*.cla`).
- `clarusc/clarusc.c` is the committed bootstrap snapshot. If
  `TestSnapshotCurrent` fails (`CLARUS_GO_DIFF=1`; it needs a Go-built
  clarusc as the freshness oracle), it prints regeneration instructions.
- Bootstrap from C alone:
  `cc -I internal/build/rt -o clarusc clarusc/clarusc.c internal/build/rt/rt.c`

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
  PBMs. `CLARUS_MAC_BLESS=1` regenerates both. `scripts/build-mac.sh` takes
  `--events FILE` to compile a scripted event sequence into a test build for
  deterministic UI driving (no real input needed).
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
