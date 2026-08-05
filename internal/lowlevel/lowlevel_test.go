// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// Package lowlevel is the host run harness for Plan 5a's Ch13 low-level
// memory surface (`ptr`, `peek`/`poke`, `external func`): unlike
// internal/selfhost's differential/check-only suites, this package builds
// clarusc via the Go compiler (same buildClarusc pattern as
// internal/sertest/sertest_test.go), emits each testdata/lowlevel/*.cla
// fixture to C, compiles the result with the HOST cc against
// runtime/host/rt.c, and actually RUNS it under the strict/paranoid
// leak gate (CLARUS_MEM_STRICT/CLARUS_MEM_PARANOID) -- proving an
// `external func` call really reaches the instrumented rt_ext_* host shim
// (rt_mem_host.inc's ledger), not just that clarusc-emitted C compiles.
// Task 3 (native-5a) seeds this package with its first fixture (extmem.cla,
// the NewHandle/GetHandleSize/SetHandleSize/DisposeHandle round trip); Task
// 4 (peek/poke) adds fixtures to the same glob.
package lowlevel

import (
	"bytes"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"

	"clarus/internal/claruscboot"
)

func repoRoot(t *testing.T) string {
	t.Helper()
	wd, err := os.Getwd()
	if err != nil {
		t.Fatalf("getwd: %v", err)
	}
	return filepath.Join(wd, "..", "..")
}

// buildClarusc returns the current-source clarusc via the shared Go-free
// bootstrap (Go-compiler-deletion phase; was build.Build on
// clarusc/main.cla). Kept as a local name so fixture call sites are
// untouched.
func buildClarusc(t *testing.T) string {
	t.Helper()
	return claruscboot.CurrentExe(t)
}

// emitFixture runs `clarusc emit -o outC fixture`, failing the test loudly
// (with stdout/stderr) on a nonzero exit.
func emitFixture(t *testing.T, exe, outC, fixture string) {
	t.Helper()
	cmd := exec.Command(exe, "emit", "-o", outC, fixture)
	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	if err := cmd.Run(); err != nil {
		t.Fatalf("clarusc emit -o %s %s: %v\nstdout: %s\nstderr: %s", outC, fixture, err, stdout.String(), stderr.String())
	}
}

// checkMemReport reads the rt_mem strict-mode leak report (see
// rt_mem_host.inc's rt_mem_exit_check for the exact "##CLARUS-MEM##
// live=<N>" format) and requires live == 0 -- every lowlevel fixture must
// free everything it allocates through the waist; a live count above 0
// means an `external func` allocation escaped the host shim's ledger, or
// the fixture itself leaked.
func checkMemReport(t *testing.T, reportPath string) {
	t.Helper()
	report, err := os.ReadFile(reportPath)
	if err != nil {
		t.Fatalf("runtime wrote no mem report -- is STRICT plumbed? (%v)", err)
	}
	firstLine, _, _ := strings.Cut(string(report), "\n")
	var gotLive int
	if _, err := fmt.Sscanf(firstLine, "##CLARUS-MEM## live=%d", &gotLive); err != nil {
		t.Fatalf("mem report missing ##CLARUS-MEM## header: %q", string(report))
	}
	if gotLive != 0 {
		t.Errorf("live leaks: got %d want 0\n--- mem report ---\n%s", gotLive, string(report))
	}
}

// TestLowlevel emits every testdata/lowlevel/*.cla fixture, compiles it
// host-side against rt.c, and runs it under the strict/paranoid leak gate:
// stdout must match the sibling .out byte-for-byte, exit must be 0, and the
// mem report must show live=0.
func TestLowlevel(t *testing.T) {
	root := repoRoot(t)
	exe := buildClarusc(t)
	rtDir := filepath.Join(root, "runtime", "host")

	files, err := filepath.Glob(filepath.Join(root, "testdata", "lowlevel", "*.cla"))
	if err != nil {
		t.Fatal(err)
	}
	if len(files) == 0 {
		t.Fatal("no lowlevel fixtures")
	}
	for _, fixture := range files {
		fixture := fixture
		t.Run(filepath.Base(fixture), func(t *testing.T) {
			base := strings.TrimSuffix(fixture, ".cla")
			want, err := os.ReadFile(base + ".out")
			if err != nil {
				t.Fatal(err)
			}

			buildDir := t.TempDir()
			outC := filepath.Join(buildDir, "main.c")
			emitFixture(t, exe, outC, fixture)

			bin := filepath.Join(buildDir, "prog")
			ccCmd := exec.Command(claruscboot.CCPath(),
				"-std=c99", "-O1",
				"-I", rtDir,
				outC, filepath.Join(rtDir, "rt.c"),
				"-o", bin)
			if ccOut, err := ccCmd.CombinedOutput(); err != nil {
				t.Fatalf("cc: %v\n%s", err, ccOut)
			}

			runDir := t.TempDir()
			report := filepath.Join(runDir, "mem.txt")
			runCmd := exec.Command(bin)
			runCmd.Dir = runDir
			runCmd.Env = append(os.Environ(), "CLARUS_MEM_STRICT=1", "CLARUS_MEM_PARANOID=1", "CLARUS_MEM_REPORT="+report)
			var stdout, stderr bytes.Buffer
			runCmd.Stdout = &stdout
			runCmd.Stderr = &stderr
			if err := runCmd.Run(); err != nil {
				t.Fatalf("run %s: %v\nstdout: %s\nstderr: %s", bin, err, stdout.String(), stderr.String())
			}

			if stdout.String() != string(want) {
				t.Errorf("stdout:\n got: %q\nwant: %q", stdout.String(), string(want))
			}

			checkMemReport(t, report)
		})
	}
}

