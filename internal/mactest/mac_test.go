// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

package mactest

import (
	"bytes"
	"context"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
	"testing"
	"time"
)

func requireMac(t *testing.T) {
	if os.Getenv("CLARUS_MAC_TESTS") == "" {
		t.Skip("set CLARUS_MAC_TESTS=1 (needs Retro68 toolchain + Mini vMac + display)")
	}
}

// repoRoot returns the repo root, computed from the package directory (go
// test always runs with cwd == the package dir).
func repoRoot(t *testing.T) string {
	t.Helper()
	wd, err := os.Getwd()
	if err != nil {
		t.Fatalf("getwd: %v", err)
	}
	return filepath.Join(wd, "..", "..")
}

// runBuildMac invokes scripts/build-mac.sh NAME ARGS... and returns the
// built .bin's absolute path. Shared by BuildMac (4a) and ui_test.go's
// events-driven builds (Task 6) -- both just assemble a different ARGS list
// for the same script and the same "did it produce a .bin" check.
func runBuildMac(t *testing.T, name string, args ...string) string {
	t.Helper()
	return runBuildMacEnv(t, name, nil, args...)
}

// runBuildMacEnv is runBuildMac with explicit extra environment variables
// (in addition to the test process's own os.Environ()) -- native-5e Task 7's
// own ported-lane runner uses this to set CLARUS_UIPORT=1 on the build-mac.sh
// child process EXPLICITLY (a parameter, not ambient global env mutation
// shared across concurrently-running tests) rather than requiring the whole
// `go test` invocation itself to run under that env var.
func runBuildMacEnv(t *testing.T, name string, extraEnv []string, args ...string) string {
	t.Helper()
	root := repoRoot(t)
	cmdArgs := append([]string{name}, args...)
	cmd := exec.Command(filepath.Join(root, "scripts", "build-mac.sh"), cmdArgs...)
	if len(extraEnv) > 0 {
		cmd.Env = append(os.Environ(), extraEnv...)
	}
	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	if err := cmd.Run(); err != nil {
		t.Fatalf("build-mac.sh %s failed: %v\nstdout: %s\nstderr: %s", name, err, stdout.String(), stderr.String())
	}
	bin := filepath.Join(root, "build-mac", name, name+".bin")
	if _, err := os.Stat(bin); err != nil {
		t.Fatalf("expected built binary: %v (build-mac.sh output: %s)", err, stdout.String())
	}
	return bin
}

// BuildMac invokes scripts/build-mac.sh and returns the built .bin's
// absolute path. claFiles are resolved relative to the current package
// directory, same convention as BuildSuiteHost/RunSuiteHost.
func BuildMac(t *testing.T, name string, test bool, claFiles ...string) string {
	t.Helper()
	args := append([]string{}, claFiles...)
	if test {
		args = append(args, "--test")
	}
	return runBuildMac(t, name, args...)
}

const exitMarker = "##CLARUS-EXIT## "
const logMarker = "##CLARUS-LOG##\n"

// parseCapture splits LaunchAPPL's echoed `out` bytes at the LAST
// occurrence of the exit marker (the record may legitimately start at
// position 0 for an alert-free program), per the Task 10 capture
// protocol.
func parseCapture(t *testing.T, raw []byte) (out, log string, exitCode int) {
	t.Helper()
	s := string(raw)
	idx := strings.LastIndex(s, exitMarker)
	if idx < 0 {
		t.Fatalf("no %q trailer in capture (%d bytes): %q", exitMarker, len(s), s)
	}
	out = s[:idx]
	rest := s[idx+len(exitMarker):]
	nl := strings.IndexByte(rest, '\n')
	if nl < 0 {
		t.Fatalf("malformed trailer: no newline after exit code: %q", rest)
	}
	code, err := strconv.Atoi(rest[:nl])
	if err != nil {
		t.Fatalf("malformed exit code %q: %v", rest[:nl], err)
	}
	after := rest[nl+1:]
	if !strings.HasPrefix(after, logMarker) {
		t.Fatalf("malformed trailer: expected %q, got %q", logMarker, after)
	}
	return out, after[len(logMarker):], code
}

// RunMac launches bin via LaunchAPPL/minivmac (bounded by timeout) and
// returns the extracted out/log/exit-code per the capture protocol.
func RunMac(t *testing.T, bin string, timeout time.Duration) (out, log string, exitCode int) {
	t.Helper()
	launchappl := filepath.Join(repoRoot(t), "toolchain", "bin", "LaunchAPPL")
	ctx, cancel := context.WithTimeout(context.Background(), timeout)
	defer cancel()
	cmd := exec.CommandContext(ctx, launchappl, "-e", "minivmac", bin)
	cmd.Dir = t.TempDir() // LaunchAPPL makes its temp dir in cwd
	// LaunchAPPL launches Mini vMac via `open -nWa`, which detaches into its
	// own process outside LaunchAPPL's process group -- a context kill only
	// terminates LaunchAPPL, not the detached emulator, which can keep our
	// stdout/stderr pipes open and hang Wait() forever. WaitDelay bounds
	// that: once ctx expires, Wait() kills the remaining I/O goroutines
	// after this grace period instead of blocking on them indefinitely.
	cmd.WaitDelay = 10 * time.Second
	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	err := cmd.Run()
	if ctx.Err() != nil {
		// Best-effort: the emulator itself survives a context kill (see
		// above), so sweep it up explicitly rather than leave an orphaned
		// minivmac process running.
		exec.Command("pkill", "-f", "minivmac.app").Run()
		t.Fatalf("LaunchAPPL %s timed out after %s (emulator killed): %v\nstderr: %s\nstdout: %s", bin, timeout, err, stderr.String(), stdout.String())
	}
	if err != nil {
		t.Fatalf("LaunchAPPL %s failed: %v\nstderr: %s\nstdout: %s", bin, err, stderr.String(), stdout.String())
	}
	return parseCapture(t, stdout.Bytes())
}

// firstDiff reports the line number and both lines at the first mismatch
// between want and got (line-oriented, for readable divergence reports).
func firstDiff(want, got string) string {
	wl := strings.Split(want, "\n")
	gl := strings.Split(got, "\n")
	n := len(wl)
	if len(gl) < n {
		n = len(gl)
	}
	for i := 0; i < n; i++ {
		if wl[i] != gl[i] {
			return fmt.Sprintf("\n line %d:\n want: %q\n got:  %q", i+1, wl[i], gl[i])
		}
	}
	if len(wl) != len(gl) {
		return fmt.Sprintf("\n line count differs: want %d got %d", len(wl), len(gl))
	}
	return ""
}

func TestSuiteOnMac(t *testing.T) {
	requireMac(t)
	expected := RunSuiteHost(t, BuildSuiteHost(t))
	bin := BuildMac(t, "TestSuite", true, "../../testdata/suite/test_suite.cla")
	got, _, exitCode := RunMac(t, bin, 15*time.Minute)
	if exitCode != 0 {
		t.Fatalf("suite exit code %d, want 0", exitCode)
	}
	if got != expected {
		t.Fatalf("mac/host divergence:%s", firstDiff(expected, got))
	}
}

func TestRunErrOnMac(t *testing.T) {
	requireMac(t)
	files, err := filepath.Glob("../../testdata/runerr/*.cla")
	if err != nil || len(files) == 0 {
		t.Fatalf("no runerr corpus: %v", err)
	}
	for _, f := range files {
		f := f
		t.Run(filepath.Base(f), func(t *testing.T) {
			want, err := os.ReadFile(strings.TrimSuffix(f, ".cla") + ".err")
			if err != nil {
				t.Fatal(err)
			}
			name := "Err" + strings.TrimSuffix(filepath.Base(f), ".cla")
			bin := BuildMac(t, name, true, f)
			_, log, exitCode := RunMac(t, bin, 3*time.Minute)
			if exitCode != 3 {
				t.Errorf("exit: got %d want 3", exitCode)
			}
			if !strings.Contains(log, strings.TrimSpace(string(want))) {
				t.Errorf("log %q missing %q", log, strings.TrimSpace(string(want)))
			}
		})
	}
}

// TestAbortAppsOnMac covers the two suite-excluded, abort-by-design run
// goldens (emit_array, emit_enum): each deliberately panics partway
// through, so it runs standalone (from its wrapper path, exactly like any
// program) rather than inside test_suite.cla. Expectation is byte-exact
// out == its .out golden and exit code == its .exit golden.
func TestAbortAppsOnMac(t *testing.T) {
	requireMac(t)
	for _, name := range []string{"emit_array", "emit_enum"} {
		name := name
		t.Run(name, func(t *testing.T) {
			wrapper := "../../testdata/run/" + name + ".cla"
			wantOut, err := os.ReadFile("../../testdata/run/" + name + ".out")
			if err != nil {
				t.Fatal(err)
			}
			wantExitBytes, err := os.ReadFile("../../testdata/run/" + name + ".exit")
			if err != nil {
				t.Fatal(err)
			}
			wantExit, err := strconv.Atoi(strings.TrimSpace(string(wantExitBytes)))
			if err != nil {
				t.Fatalf("malformed golden exit code %q: %v", wantExitBytes, err)
			}
			bin := BuildMac(t, "Abort"+name, true, wrapper)
			out, _, exitCode := RunMac(t, bin, 3*time.Minute)
			if exitCode != wantExit {
				t.Errorf("exit: got %d want %d", exitCode, wantExit)
			}
			if out != string(wantOut) {
				t.Errorf("out mismatch:%s", firstDiff(string(wantOut), out))
			}
		})
	}
}
