// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

package mactest

import (
	"bufio"
	"bytes"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
	"testing"
)

// TestLeakGate pins the memory-leak-fix phase (docs/superpowers/plans/
// 2026-08-12-memory-leak-fix.md): the compiler must not retain heap
// blocks across compiles in one process, and .clear()/store-temp
// machinery must not leak. Host-lane only (uses runtime/host's
// CLARUS_MEM_STRICT ledger); the native lane is covered by parity
// goldens + the gated suite boots.
func TestLeakGate(t *testing.T) {
	t.Run("StoreTemps", func(t *testing.T) {
		runLeakFixture(t, "../../testdata/leakgate/stemp.cla")
	})
	t.Run("ArrStore", func(t *testing.T) {
		// fix-round-1 regression: a rec-bearing KArr __store temp (whole
		// fixed-array assignment of handle-bearing record elements) --
		// see testdata/leakgate/arrstore.cla's own doc comment. Must cc
		// build clean (the miscompile this pins was a build-time cc
		// error, not a runtime leak) and report zero live blocks.
		runLeakFixture(t, "../../testdata/leakgate/arrstore.cla")
	})
	t.Run("ClearRefElems", func(t *testing.T) {
		runLeakFixture(t, "../../testdata/leakgate/clearprobe.cla")
	})
	t.Run("ArrElem", func(t *testing.T) {
		// fix-round-1 regression: cgContainerElemNeedsWalk/
		// cgContainerElemRelease (native) and cpEmitRelease/
		// cpEmitElemReleaseWalk's per-kind branches (host) had no KArr
		// arm -- a `list of Item[3]` (or the map/sortedmap/intmap
		// value-type equivalent) silently skipped releasing the
		// record-held text handles packed inside each array-typed
		// slot/value, on both the `.clear()` Deep walk and the
		// pre-existing scope-exit teardown walk. See
		// testdata/leakgate/arrelem.cla's own doc comment for why it
		// uses Item[3] (array-of-record) rather than text[3]
		// (array-of-text): the latter hits a separate, pre-existing,
		// out-of-this-fix-round's-scope push/set-retain gap.
		runLeakFixture(t, "../../testdata/leakgate/arrelem.cla")
	})
	t.Run("DoubleCompile", func(t *testing.T) {
		runDoubleCompileGate(t)
	})
}

// parseLiveCount reads a CLARUS_MEM_REPORT file and returns the
// "##CLARUS-MEM## live=N" total, plus up to the first 20 "rt_mem: leak"
// lines (for a failing assertion's diagnostic dump).
func parseLiveCount(t *testing.T, reportPath string) (int, []string) {
	t.Helper()
	f, err := os.Open(reportPath)
	if err != nil {
		t.Fatalf("open mem report %s: %v", reportPath, err)
	}
	defer f.Close()

	live := -1
	var leaks []string
	sc := bufio.NewScanner(f)
	for sc.Scan() {
		line := sc.Text()
		if n, ok := strings.CutPrefix(line, "##CLARUS-MEM## live="); ok {
			v, err := strconv.Atoi(n)
			if err != nil {
				t.Fatalf("parse live count %q: %v", line, err)
			}
			live = v
			continue
		}
		if strings.HasPrefix(line, "rt_mem: leak") && len(leaks) < 20 {
			leaks = append(leaks, line)
		}
	}
	if err := sc.Err(); err != nil {
		t.Fatalf("scan mem report %s: %v", reportPath, err)
	}
	if live < 0 {
		t.Fatalf("mem report %s has no ##CLARUS-MEM## line", reportPath)
	}
	return live, leaks
}

// runLeakFixture builds claPath (single-file, host oracle; package-dir-
// relative, e.g. "../../testdata/leakgate/stemp.cla" -- go test always
// runs with cwd == the package dir, so this resolves without joining
// against repoRoot) and runs it under CLARUS_MEM_STRICT, asserting zero
// live blocks at exit.
func runLeakFixture(t *testing.T, claPath string) {
	t.Helper()
	exe := buildHostFromFixture(t, claPath, "leakfixture")

	work := t.TempDir()
	reportPath := filepath.Join(work, "report.txt")
	cmd := exec.Command(exe)
	cmd.Dir = work
	cmd.Env = append(os.Environ(),
		"CLARUS_MEM_STRICT=1",
		"CLARUS_MEM_REPORT="+reportPath)
	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	if err := cmd.Run(); err != nil {
		t.Fatalf("run %s: %v\nstdout: %s\nstderr: %s", claPath, err, stdout.String(), stderr.String())
	}

	live, leaks := parseLiveCount(t, reportPath)
	if live != 0 {
		t.Fatalf("%s: live=%d blocks at exit, want 0\n%s", claPath, live, strings.Join(leaks, "\n"))
	}
}

// buildDblcompile builds clarusc/test/dblcompile.cla (self-contained via
// its own includes) and returns the exe path.
func buildDblcompile(t *testing.T) string {
	t.Helper()
	root := repoRoot(t)
	return buildHostFromFixture(t, filepath.Join(root, "clarusc", "test", "dblcompile.cla"), "dblcompile")
}

// runDblcompileOnce runs exe with the given argv (entry .cla paths) in
// workDir, under CLARUS_MEM_STRICT, and returns the parsed live count.
// workDir must sit close enough under the repo root for dblcompile's own
// nested clarusc.findRtDir walk-up ("../" up to 10 times) to locate
// runtime/clarus/ at run time -- this is a SECOND, runtime-only runtime
// lookup, distinct from the --rtdir baked into the harness binary itself
// at build time (that one only serves the harness program's OWN runtime
// needs, not the nested compiles it drives).
func runDblcompileOnce(t *testing.T, exe, workDir string, argv []string) int {
	t.Helper()
	reportPath := filepath.Join(workDir, "report.txt")
	cmd := exec.Command(exe, argv...)
	cmd.Dir = workDir
	cmd.Env = append(os.Environ(),
		"CLARUS_MEM_STRICT=1",
		"CLARUS_MEM_REPORT="+reportPath)
	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	if err := cmd.Run(); err != nil {
		t.Fatalf("run dblcompile %v: %v\nstdout: %s\nstderr: %s", argv, err, stdout.String(), stderr.String())
	}
	live, _ := parseLiveCount(t, reportPath)
	return live
}

// runDoubleCompileGate proves the compiler doesn't retain heap blocks
// across repeated in-process compiles: compile the same entry once, then
// three times, and require the live-block growth per extra compile to
// stay near zero (a small allowance for genuinely process-lifetime
// state). Also byte-compares the first and third fork of the 3-compile
// run -- the stale-intern-index oracle.
func runDoubleCompileGate(t *testing.T) {
	t.Helper()
	root := repoRoot(t)
	exe := buildDblcompile(t)
	tickprobe := filepath.Join(root, "testdata", "cg68k", "tickprobe.cla")

	// workDir must live under the repo tree (not the system tempdir) so
	// dblcompile's runtime-side findRtDir walk-up can find runtime/clarus/.
	scratchRoot := filepath.Join(root, "build-run")
	if err := os.MkdirAll(scratchRoot, 0o755); err != nil {
		t.Fatalf("mkdir %s: %v", scratchRoot, err)
	}

	work1, err := os.MkdirTemp(scratchRoot, "leakgate-1x-")
	if err != nil {
		t.Fatalf("mkdtemp: %v", err)
	}
	defer os.RemoveAll(work1)
	live1 := runDblcompileOnce(t, exe, work1, []string{tickprobe})

	work3, err := os.MkdirTemp(scratchRoot, "leakgate-3x-")
	if err != nil {
		t.Fatalf("mkdtemp: %v", err)
	}
	defer os.RemoveAll(work3)
	live3 := runDblcompileOnce(t, exe, work3, []string{tickprobe, tickprobe, tickprobe})

	growthPerCompile := (live3 - live1) / 2
	if growthPerCompile > 64 {
		t.Fatalf("live-block growth per extra compile = %d (live1=%d live3=%d), want <= 64", growthPerCompile, live1, live3)
	}

	fork0, err := os.ReadFile(filepath.Join(work3, "leakfork_0.bin"))
	if err != nil {
		t.Fatalf("read leakfork_0.bin: %v", err)
	}
	fork2, err := os.ReadFile(filepath.Join(work3, "leakfork_2.bin"))
	if err != nil {
		t.Fatalf("read leakfork_2.bin: %v", err)
	}
	if !bytes.Equal(fork0, fork2) {
		t.Fatalf("leakfork_0.bin (%d bytes) != leakfork_2.bin (%d bytes): stale state leaked into the 3rd compile's fork", len(fork0), len(fork2))
	}

	// Strictly stronger oracle: alternate a DIFFERENT fixture into the
	// middle slot (tickprobe, catprobe, tickprobe) so the byte-identity
	// check can't be satisfied by trivially re-running the exact same
	// compile three times -- it proves no state survives a compile of a
	// DIFFERENT entry, not just repeats of the same one.
	catprobe := filepath.Join(root, "testdata", "mac-resident", "catprobe.cla")
	workAlt, err := os.MkdirTemp(scratchRoot, "leakgate-3x-alt-")
	if err != nil {
		t.Fatalf("mkdtemp: %v", err)
	}
	defer os.RemoveAll(workAlt)
	liveAlt := runDblcompileOnce(t, exe, workAlt, []string{tickprobe, catprobe, tickprobe})

	growthPerCompileAlt := (liveAlt - live1) / 2
	if growthPerCompileAlt > 64 {
		t.Fatalf("alternating-fixture live-block growth per extra compile = %d (live1=%d liveAlt=%d), want <= 64", growthPerCompileAlt, live1, liveAlt)
	}

	forkAlt0, err := os.ReadFile(filepath.Join(workAlt, "leakfork_0.bin"))
	if err != nil {
		t.Fatalf("read leakfork_0.bin (alt): %v", err)
	}
	forkAlt2, err := os.ReadFile(filepath.Join(workAlt, "leakfork_2.bin"))
	if err != nil {
		t.Fatalf("read leakfork_2.bin (alt): %v", err)
	}
	if !bytes.Equal(forkAlt0, forkAlt2) {
		t.Fatalf("alternating run: leakfork_0.bin (%d bytes) != leakfork_2.bin (%d bytes): stale state leaked across a different-fixture compile", len(forkAlt0), len(forkAlt2))
	}
}
