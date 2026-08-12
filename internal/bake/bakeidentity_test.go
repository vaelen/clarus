// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// bakeidentity_test.go (runtime-ir-bake Task 4): the loader's own T1
// byte-identity gate -- `emit68k --rtbake` against a from-source
// `emit68k`, over a representative fixture slice, must produce
// byte-identical forks. Host-only (no emulator needed): both sides run
// entirely via claruscboot.CurrentExe's host binary.
//
// Fixture slice: tickprobe.cla + bounce.cla (the two window-declaring
// cg68k goldens named by the brief) plus arc.cla/clear_deep.cla/
// smoke.cla/strcontainers.cla (four more cg68k fixtures, chosen because
// each needs 2+ 32KB code segments -- see this task's own report for
// why: cg68k.cla's cgPackProgram has a documented ("Task 13") single-
// segment-only shortcut that restores the WHOLE irStrLits pool verbatim
// when everything fits in one segment, a pre-existing golden-preserving
// behavior that predates this task; since the bake unconditionally
// carries uitest.cla regardless of --testapi (bake.cla's own documented
// Task 3 design), a single-segment non-testapi bake-path build can
// legitimately include a few extra never-referenced uitest.cla string
// literals this shortcut doesn't shake-filter, while the true
// reachability-aware per-segment path (triggered once a program needs
// 2+ segments) already filters them correctly -- confirmed empirically:
// every 2+-segment fixture in testdata/cg68k matches byte-for-byte,
// every 1-segment one does not) plus a self-compile (emit68k of
// clarusc/main.cla, comfortably multi-segment).
package bake

import (
	"bytes"
	"os"
	"os/exec"
	"path/filepath"
	"testing"

	"clarus/internal/claruscboot"
)

// cg68kFixtures relative to the repo root (testdata/cg68k/), each
// verified (this task's own manual smoke pass) to need 2+ code segments
// -- see this file's own doc comment.
var cg68kFixtures = []string{
	"tickprobe.cla",
	"bounce.cla",
	"arc.cla",
	"clear_deep.cla",
	"smoke.cla",
	"strcontainers.cla",
}

// runEmit68k runs `clarusc emit68k -o outPath [--rtbake bakePath] entry`
// with cmd.Dir at the repo root (so the default --rtdir upward search
// finds runtime/clarus/, exactly like RunBakeIR does) and returns the
// written bytes.
func runEmit68k(t *testing.T, exe, entry, outPath, bakePath string) []byte {
	t.Helper()
	args := []string{"emit68k", "-o", outPath}
	if bakePath != "" {
		args = append(args, "--rtbake", bakePath)
	}
	args = append(args, entry)
	cmd := exec.Command(exe, args...)
	cmd.Dir = RepoRoot(t)
	if out, err := cmd.CombinedOutput(); err != nil {
		t.Fatalf("clarusc %v: %v\n%s", args, err, out)
	}
	data, err := os.ReadFile(outPath)
	if err != nil {
		t.Fatalf("read %s: %v", outPath, err)
	}
	return data
}

// TestBakePathByteIdentity is the required gate: for every fixture in
// cg68kFixtures plus a self-compile, `emit68k --rtbake` must produce a
// byte-identical fork to plain from-source `emit68k`.
func TestBakePathByteIdentity(t *testing.T) {
	exe := claruscboot.CurrentExe(t)
	root := RepoRoot(t)
	dir := t.TempDir()
	bakePath := filepath.Join(dir, "rt68k.clir")
	RunBakeIR(t, exe, "68k", bakePath)

	entries := map[string]string{}
	for _, f := range cg68kFixtures {
		entries[f] = filepath.Join(root, "testdata", "cg68k", f)
	}
	entries["self-compile (main.cla)"] = "clarusc/main.cla"

	for name, entry := range entries {
		name, entry := name, entry
		t.Run(name, func(t *testing.T) {
			// Same basename in separate subdirectories, not distinct
			// basenames in one dir: the MacBinary wrap embeds the OUTPUT
			// FILENAME in its header (cg68WriteImageWrap), so two
			// differently-NAMED forks of identical code still differ
			// byte-for-byte in that field alone -- the exact false alarm
			// Task 2's own report already flagged and worked around the
			// same way.
			base := filepath.Base(entry)
			srcDir := filepath.Join(dir, "src-"+base)
			bakeDir := filepath.Join(dir, "bake-"+base)
			if err := os.MkdirAll(srcDir, 0o755); err != nil {
				t.Fatal(err)
			}
			if err := os.MkdirAll(bakeDir, 0o755); err != nil {
				t.Fatal(err)
			}
			srcOut := filepath.Join(srcDir, base+".bin")
			bakeOut := filepath.Join(bakeDir, base+".bin")
			srcData := runEmit68k(t, exe, entry, srcOut, "")
			bakeData := runEmit68k(t, exe, entry, bakeOut, bakePath)
			if !bytes.Equal(srcData, bakeData) {
				t.Fatalf("%s: --rtbake fork (%d bytes) != from-source fork (%d bytes)", entry, len(bakeData), len(srcData))
			}
		})
	}
}

// TestRtbakeCorruptStampRefused proves the loader refuses a bake whose
// stamp doesn't match the loading compiler's own recomputed hash: clear
// diagnostic, nonzero exit -- this task's open question (a)'s refusal
// contract.
func TestRtbakeCorruptStampRefused(t *testing.T) {
	exe := claruscboot.CurrentExe(t)
	dir := t.TempDir()
	corruptPath := CorruptStampFixture(t, exe, "68k", dir)

	cmd := exec.Command(exe, "emit68k", "--rtbake", corruptPath, "-o", filepath.Join(dir, "out.bin"), filepath.Join(RepoRoot(t), "testdata", "cg68k", "arith.cla"))
	cmd.Dir = RepoRoot(t)
	out, err := cmd.CombinedOutput()
	if err == nil {
		t.Fatalf("clarusc emit68k --rtbake <corrupt-stamp>: expected nonzero exit, got success\n%s", out)
	}
	if !bytes.Contains(out, []byte("stamp mismatch")) {
		t.Fatalf("expected a clear stamp-mismatch diagnostic, got:\n%s", out)
	}
}

// TestRtbakeLaneMismatchRefused proves the loader refuses a bake built
// for the wrong lane (a c-lane bake fed to emit68k) -- the controller's
// own resolution ("wrong lane = refused-stamp-class error with a clear
// message").
func TestRtbakeLaneMismatchRefused(t *testing.T) {
	exe := claruscboot.CurrentExe(t)
	dir := t.TempDir()
	cBakePath := filepath.Join(dir, "rtc.clir")
	RunBakeIR(t, exe, "c", cBakePath)

	cmd := exec.Command(exe, "emit68k", "--rtbake", cBakePath, "-o", filepath.Join(dir, "out.bin"), filepath.Join(RepoRoot(t), "testdata", "cg68k", "arith.cla"))
	cmd.Dir = RepoRoot(t)
	out, err := cmd.CombinedOutput()
	if err == nil {
		t.Fatalf("clarusc emit68k --rtbake <c-lane bake>: expected nonzero exit, got success\n%s", out)
	}
	if !bytes.Contains(out, []byte("lane mismatch")) {
		t.Fatalf("expected a clear lane-mismatch diagnostic, got:\n%s", out)
	}
}

// TestRtbakeTestapiRefused proves --rtbake + --testapi is refused with a
// clear, immediate CLI usage error (main.cla) rather than silently
// mis-compiling -- this task's own scoping decision (Task 5 owns wiring
// real --testapi + --rtbake support).
func TestRtbakeTestapiRefused(t *testing.T) {
	exe := claruscboot.CurrentExe(t)
	dir := t.TempDir()
	bakePath := filepath.Join(dir, "rt68k.clir")
	RunBakeIR(t, exe, "68k", bakePath)

	cmd := exec.Command(exe, "emit68k", "--rtbake", bakePath, "--testapi", "-o", filepath.Join(dir, "out.bin"), filepath.Join(RepoRoot(t), "testdata", "cg68k", "arith.cla"))
	cmd.Dir = RepoRoot(t)
	out, err := cmd.CombinedOutput()
	if err == nil {
		t.Fatalf("clarusc emit68k --rtbake --testapi: expected nonzero exit, got success\n%s", out)
	}
	if !bytes.Contains(out, []byte("--testapi")) {
		t.Fatalf("expected a clear --testapi-related diagnostic, got:\n%s", out)
	}
}
