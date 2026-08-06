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
	root := repoRoot(t)
	cmdArgs := append([]string{name}, args...)
	cmd := exec.Command(filepath.Join(root, "scripts", "build-mac.sh"), cmdArgs...)
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

// TestSuiteOnMac (the core suite's Retro68/cprint-lane CLI boot gate,
// test-suite-review Task 9's Mac-gate swap) was retired by test-
// consolidation Task 7 -- audit row R12, DELETE: all 41 CoreTest cases
// already run through this same Retro68/cprint pipeline via
// TestCoreSuiteGUIOnMac (R21, coresuite_test.go); the only signal lost is
// byte-exact core-CLI stdout log-formatting parity against the host
// (Decision 3, not semantic coverage -- mirrors TestSuiteOn68k's own
// native-lane retirement, test-consolidation Task 6, audit row N19).
// coreCLIMacFiles (suite_host_test.go) had no other caller and was deleted
// alongside this test; core/cli_mac.cla itself is NOT deleted --
// internal/cg68k/segment_test.go depends on it independently (audit
// claim 7) -- and BuildMac/RunMac survive, still used by
// TestRunErrOnMac/TestAbortAppsOnMac below.

// TestRunErrOnMac was reduced by test-consolidation Task 7 to the single
// representative fixture, `oob` (audit row R16, KEEP -- plain array-bounds
// panic, the simplest real-mode trap shape, mirroring TestRunErrOn68k's own
// native-lane reduction, test-consolidation Task 6) -- badenum/emptypop/
// mapmiss/slicerange/strindex (rows R13/R14/R15/R17/R18, all DELETE) are
// dropped as per-lane boots since their semantic panic coverage is pinned
// host-side, lane-independently, by internal/selfhost/behavior_test.go
// against each fixture's own testdata/runerr/*.behavior golden (T1,
// ungated). The .cla/.err/.behavior files for all 6 fixtures STAY -- the
// host test still consumes them.
func TestRunErrOnMac(t *testing.T) {
	requireMac(t)
	files := []string{"../../testdata/runerr/oob.cla"}
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

// TestAbortAppsOnMac was reduced by test-consolidation Task 7 to the
// single representative fixture, emit_array (audit row R19, KEEP -- its
// 7-line pre-panic alert() capture proves the abort-capture shape more
// strongly than emit_enum's 5, row R20, DELETE, mirroring
// TestAbortOn68k's own native-lane reduction, test-consolidation Task 6);
// emit_enum's own semantic coverage (bad-enum-conversion panic) is
// separately pinned host-side by testdata/runerr/badenum.behavior (T1,
// ungated). Neither runerr fixture has any pre-panic output, so this
// abort-app boot is NOT absorbable by TestRunErrOnMac's own representative
// (audit claim 6) -- it stays, per lane. Each deliberately panics partway
// through, so it runs standalone (from its wrapper path, exactly like any
// program) rather than inside test_suite.cla. Expectation is byte-exact
// out == its .out golden and exit code == its .exit golden.
func TestAbortAppsOnMac(t *testing.T) {
	requireMac(t)
	for _, name := range []string{"emit_array"} {
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
