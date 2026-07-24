// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

package mactest

import (
	"os/exec"
	"path/filepath"
	"strings"
	"testing"

	"clarus/internal/build"
)

// BuildSuiteHost builds testdata/suite/test_suite.cla with the host
// toolchain and returns the executable path.
func BuildSuiteHost(t *testing.T) string {
	t.Helper()
	exe := filepath.Join(t.TempDir(), "suite")
	diags, err := build.Build([]string{"../../testdata/suite/test_suite.cla"}, exe)
	if err != nil || len(diags) > 0 {
		t.Fatalf("build suite: err=%v diags=%v", err, diags)
	}
	return exe
}

// RunSuiteHost runs the host suite binary and returns its stdout. This
// output is the byte-exact expectation for the Mac run (mac_test.go).
func RunSuiteHost(t *testing.T, exe string) string {
	t.Helper()
	cmd := exec.Command(exe)
	cmd.Dir = t.TempDir() // suite tests touch relative-path files
	out, err := cmd.Output()
	if err != nil {
		t.Fatalf("run suite: %v", err)
	}
	return string(out)
}

// suiteExcluded names lib files that test_suite.cla deliberately omits:
// each one's entry func aborts the process by design (rt_panic, exit 3),
// which is incompatible with the shared-process monolithic suite. They
// are not dropped from coverage -- they run as standalone apps under the
// Mac harness (mac_test.go, plan Task 11), checked against their existing
// pre-abort stdout/panic-message/exit-code goldens individually.
var suiteExcluded = map[string]bool{
	"emit_array": true,
	"emit_enum":  true,
}

func TestSuiteRunsAllTests(t *testing.T) {
	out := RunSuiteHost(t, BuildSuiteHost(t))
	names, _ := filepath.Glob("../../testdata/run/lib/*.cla")
	if len(names) == 0 {
		t.Fatal("no lib corpus")
	}
	for _, n := range names {
		name := strings.TrimSuffix(filepath.Base(n), ".cla")
		if suiteExcluded[name] {
			continue
		}
		delim := "=== " + name + " ==="
		if !strings.Contains(out, delim) {
			t.Errorf("suite output missing %q", delim)
		}
	}
	if !strings.Contains(out, "=== suite done ===") {
		t.Error("missing final delimiter")
	}
}
