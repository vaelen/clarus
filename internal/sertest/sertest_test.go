// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// Package sertest is the host round-trip gate for Task 2 of the
// 2026-07-27 mac-target-4d plan: clarusc's file.save/file.load lowering
// through emitted per-record layout tables (cprint.cla's cpEmitLayouts).
// Unlike internal/emitui (compile-check only, m68k), this package builds
// clarusc via the Go compiler (same buildClarusc pattern as
// internal/emitui/emitui_test.go and internal/selfhost's
// differential_test.go), emits testdata/sertest/roundtrip.cla, compiles the
// result with the HOST cc against runtime/host/rt.c, and actually RUNS
// it in a temp cwd -- proving the emitted rt_field_desc/rt_layout_desc
// tables agree with rt_ser.inc at runtime, not just at compile time.
package sertest

import (
	"bytes"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"

	"clarus/internal/claruscboot"
)

// repoRoot returns the repo root, computed from the package directory (go
// test always runs with cwd == the package dir) -- same convention
// internal/emitui/internal/mactest's own repoRoot uses.
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

// TestRoundtrip emits testdata/sertest/roundtrip.cla, compiles it host-side
// against rt.c, and runs it in a fresh cwd: a Bookmark record (every
// serializable field kind: string(n)/int/bool/char/fixed/enum) round-trips
// through file.save/file.load as a bare record, a `list of`, and a `map
// of`. Compares the run's stdout to roundtrip.out.golden AND the bare
// record's saved file (rec.dat) to roundtrip.bytes.golden byte-for-byte --
// the latter pins the on-disk format (magic/version/container header, BE
// ints, zero-padded strings) exactly, not just "it round-trips".
func TestRoundtrip(t *testing.T) {
	root := repoRoot(t)
	exe := buildClarusc(t)

	buildDir := t.TempDir()
	outC := filepath.Join(buildDir, "roundtrip.c")
	emitFixture(t, exe, outC, filepath.Join(root, "testdata", "sertest", "roundtrip.cla"))

	binExe := filepath.Join(buildDir, "roundtrip")
	ccCmd := exec.Command(claruscboot.CCPath(),
		"-I", filepath.Join(root, "runtime", "host"),
		outC, filepath.Join(root, "runtime", "host", "rt.c"),
		"-o", binExe)
	if out, err := ccCmd.CombinedOutput(); err != nil {
		t.Fatalf("cc: %v\n%s", err, out)
	}

	runDir := t.TempDir()
	runCmd := exec.Command(binExe)
	runCmd.Dir = runDir
	var runOut, runErr bytes.Buffer
	runCmd.Stdout = &runOut
	runCmd.Stderr = &runErr
	if err := runCmd.Run(); err != nil {
		t.Fatalf("run %s: %v\nstdout: %s\nstderr: %s", binExe, err, runOut.String(), runErr.String())
	}

	wantOut, err := os.ReadFile(filepath.Join(root, "testdata", "sertest", "roundtrip.out.golden"))
	if err != nil {
		t.Fatal(err)
	}
	if !bytes.Equal(runOut.Bytes(), wantOut) {
		t.Errorf("stdout mismatch\n--- got ---\n%s\n--- want ---\n%s", runOut.String(), string(wantOut))
	}

	gotBytes, err := os.ReadFile(filepath.Join(runDir, "rec.dat"))
	if err != nil {
		t.Fatalf("read rec.dat: %v", err)
	}
	wantBytes, err := os.ReadFile(filepath.Join(root, "testdata", "sertest", "roundtrip.bytes.golden"))
	if err != nil {
		t.Fatal(err)
	}
	if !bytes.Equal(gotBytes, wantBytes) {
		t.Errorf("rec.dat bytes mismatch\ngot:  % x\nwant: % x", gotBytes, wantBytes)
	}

	gotPad, err := os.ReadFile(filepath.Join(runDir, "pad.dat"))
	if err != nil {
		t.Fatalf("read pad.dat: %v", err)
	}
	wantPad, err := os.ReadFile(filepath.Join(root, "testdata", "sertest", "padprobe.bytes.golden"))
	if err != nil {
		t.Fatal(err)
	}
	if !bytes.Equal(gotPad, wantPad) {
		t.Errorf("pad.dat bytes mismatch\ngot:  % x\nwant: % x", gotPad, wantPad)
	}
}

// TestBadFieldRejected asserts that a record with a `text` field reaching
// file.save fails clarusc emit loudly (lower.cla's
// lowCheckSerializableFields) instead of silently emitting an unserializable
// layout table: nonzero exit, and the value-field message on stderr. No
// golden -- this fixture never successfully emits.
func TestBadFieldRejected(t *testing.T) {
	root := repoRoot(t)
	exe := buildClarusc(t)
	fixture := filepath.Join(root, "testdata", "sertest", "badfield.cla")

	cmd := exec.Command(exe, "emit", "-o", filepath.Join(t.TempDir(), "out.c"), fixture)
	var stderr bytes.Buffer
	cmd.Stderr = &stderr
	err := cmd.Run()
	if err == nil {
		t.Fatalf("clarusc emit %s: want nonzero exit, got success (stderr: %s)", fixture, stderr.String())
	}
	const want = "file.save: record Note field body is not a value type"
	if !strings.Contains(stderr.String(), want) {
		t.Errorf("stderr %q missing %q", stderr.String(), want)
	}
}
