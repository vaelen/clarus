# Task 1 findings: LaunchAPPL file extraction channel

## Result: `launchappl-echo` works. Use it.

After a `LaunchAPPL -e minivmac <app>.bin` run, the contents the app wrote
to its default-volume file named `out` (a file LaunchAPPL pre-creates on the
boot disk, type `TEXT`/`MPS `) are echoed verbatim to LaunchAPPL's own
stdout once the app quits and the emulator session ends. No disk-image
copy-aside or `hcopy` step was needed.

`probe_marker` (a file the probe app creates itself, not part of
LaunchAPPL's pre-made set) is **not** echoed anywhere — only `out` gets
this treatment. So the harness contract is: write your result to the file
literally named `out` on the default volume; read it back from LaunchAPPL's
captured stdout on the host.

## Commands used

Build:

```sh
cd internal/mactest/probe
cmake -B build -DCMAKE_TOOLCHAIN_FILE=$PWD/../../../toolchain/m68k-apple-macos/cmake/retro68.toolchain.cmake
make -C build
```
`build/Probe.bin` produced, no errors (one unrelated CMake deprecation
warning about `cmake_minimum_required(VERSION 3.9)`).

Run (macOS has no `timeout` binutil by default — none of `timeout`/
`gtimeout` were on PATH — so wall-clock was bounded via the Bash tool's own
timeout instead of a shell `timeout` wrapper; either works, since the app
exits immediately and LaunchAPPL returns as soon as the emulated Mac shuts
down):

```sh
cd internal/mactest/probe
../../../toolchain/bin/LaunchAPPL -e minivmac build/Probe.bin > launchappl.stdout 2>&1
echo "exit: $?"
cat launchappl.stdout
```

Output, two independent runs:

```
exit: 0
```
```
$ xxd launchappl.stdout
00000000: 5052 4f42 452d 4f55 542d 3432 0d         PROBE-OUT-42.
```

Both runs produced byte-identical stdout: exactly the 13 bytes
`PROBE-OUT-42\r` that `probe.c` wrote to `out` — no extra framing, no
trailing newline beyond the app's own `\r`.

## Exit-code behavior

`LaunchAPPL` exits `0` on a clean app quit in both runs. No non-zero exits
were observed; this task did not exercise a crash/hang path.

## Wall-clock for one boot

Two timed runs: **2.51 s** and **2.15 s** end-to-end (process start to
`LaunchAPPL` return), including Mini vMac boot, app run, and shutdown.
Comfortably under any reasonable per-test timeout (Task 11 can budget
~10-15 s per test to be safe on a loaded machine).

## The `hcopy` fallback was not needed

Because `launchappl-echo` worked on the first try, the copy-aside-the-disk-
image fallback (poll cwd for LaunchAPPL's temp dir, copy
`minivmac.app/Contents/mnvm_dat/disk1.dsk` while the emulator is up, then
`hmount`/`hcopy`/`humount` after exit) was not exercised. It remains
documented in the task brief as the fallback if a future probe's file
isn't named `out`, but is not required for the current harness design.

## Implication for Task 10 / Task 11

- **Task 11 (`mac_test.go`)**: capture LaunchAPPL's stdout, parse it as the
  test app's output file contents. No disk-image tooling needed at test
  time.
- **Task 10 (`rt_mac.c`)**: the proven write pattern is `Create` (only for
  files that don't already exist) → `FSOpen` → `SetEOF(ref, 0)` →
  `FSWrite` → `FSClose` → `FlushVol(NULL, 0)`. To use the echo channel,
  runtime output/result files intended for host-side inspection must be
  named `out` on the default (boot) volume.

## Concerns

- Only one output channel (`out`) is echoed; if a future test needs to
  recover more than one file's contents (e.g. stdout-equivalent plus a
  separate error log), it will need the `hcopy` fallback described above
  and in the task brief, since only `out` gets the automatic echo
  treatment.
- This behavior was empirically observed via LaunchAPPL's implementation,
  not documented behavior we control — it should stay pinned by this
  probe/test rather than assumed to be true of unrelated LaunchAPPL
  versions.
