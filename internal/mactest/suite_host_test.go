// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

package mactest

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"sync"
	"testing"
)

var (
	snapshotClaruscOnce sync.Once
	snapshotClaruscExe  string
	snapshotClaruscErr  error
	snapshotClaruscSkip string
)

// bootstrapSnapshotClarusc compiles the committed clarusc/clarusc.c
// snapshot straight to a binary with `cc` alone -- no Go compiler
// involved. This is the host-oracle half of test-suite-review Task 5:
// mactest's HOST comparisons (BuildSuiteHost here, and
// runNativeHostCompareSeglimit's host half in native_test.go) no longer
// need build.Build, so the Mac gates no longer need the Go compiler.
// Duplicated from internal/selfhost/behavior_test.go's own
// bootstrapSnapshotClarusc/internal/perfgate's buildClarusc (mactest
// cannot import either -- see buildNativeClarusc's comment in
// native_test.go:39-42 doing exactly this same duplication). Memoized:
// one bootstrap per `go test` invocation, reused by every host build in
// this package.
func bootstrapSnapshotClarusc(t *testing.T) string {
	t.Helper()
	snapshotClaruscOnce.Do(func() {
		if _, err := exec.LookPath("cc"); err != nil {
			snapshotClaruscSkip = "cc not found on PATH, skipping Go-free host oracle"
			return
		}
		root := repoRoot(t)
		dir, err := os.MkdirTemp("", "clarusc-snapshot-*")
		if err != nil {
			snapshotClaruscErr = err
			return
		}
		exe := filepath.Join(dir, "clarusc")
		cmd := exec.Command("cc", "-O1", "-I", filepath.Join(root, "internal", "build", "rt"),
			"-o", exe,
			filepath.Join(root, "clarusc", "clarusc.c"),
			filepath.Join(root, "internal", "build", "rt", "rt.c"))
		if out, err := cmd.CombinedOutput(); err != nil {
			snapshotClaruscErr = fmt.Errorf("bootstrap clarusc from snapshot: %v\n%s", err, out)
			return
		}
		snapshotClaruscExe = exe
	})
	if snapshotClaruscSkip != "" {
		t.Skip(snapshotClaruscSkip)
	}
	if snapshotClaruscErr != nil {
		t.Fatal(snapshotClaruscErr)
	}
	return snapshotClaruscExe
}

// buildHostFromFixture emits claPath's C with the snapshot-bootstrapped
// clarusc and compiles it with `cc` against the on-disk runtime sources
// (internal/build/rt/rt.c) -- the build-mac.sh step-1 pipeline, run
// straight to a host binary instead of a Mac one. Shared by BuildSuiteHost
// here and runNativeHostCompareSeglimit's host half in native_test.go.
func buildHostFromFixture(t *testing.T, claPath, binName string) string {
	t.Helper()
	root := repoRoot(t)
	claruscExe := bootstrapSnapshotClarusc(t)
	work := t.TempDir()
	outC := filepath.Join(work, binName+".c")
	rtDir := filepath.Join(root, "runtime", "clarus") + string(filepath.Separator)

	emit := exec.Command(claruscExe, "emit", "--rtdir", rtDir, "-o", outC, claPath)
	if out, err := emit.CombinedOutput(); err != nil {
		t.Fatalf("clarusc emit %s: %v\n%s", claPath, err, out)
	}

	exe := filepath.Join(work, binName)
	cc := exec.Command("cc", "-O1", "-I", filepath.Join(root, "internal", "build", "rt"),
		outC, filepath.Join(root, "internal", "build", "rt", "rt.c"), "-o", exe)
	if out, err := cc.CombinedOutput(); err != nil {
		t.Fatalf("cc compile emitted C for %s: %v\n%s", claPath, err, out)
	}
	return exe
}

// BuildSuiteHost builds testdata/suite/test_suite.cla with the snapshot-
// bootstrapped clarusc (emit + cc) and returns the executable path.
func BuildSuiteHost(t *testing.T) string {
	t.Helper()
	fixture := filepath.Join(repoRoot(t), "testdata", "suite", "test_suite.cla")
	return buildHostFromFixture(t, fixture, "suite")
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
