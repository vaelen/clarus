// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// fixedpoint_test.go: the snapshot fixed-point + freshness oracle. It never
// builds or imports the Go compiler -- the Go differential/bootstrap lanes
// that once lived alongside it (differential_test.go, driver_test.go,
// emit_test.go, bootstrap_test.go, coverage_test.go) are deleted
// (Go-compiler-deletion phase, Task 7); Tasks 3-5b's Go-free oracles
// (behavior_test.go, crossgen_test.go, snapshot_test.go's TestSnapshotBuilds)
// already cover the same ground without it.
package selfhost

import (
	"bytes"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
)

// emitCDir is the dir-taking core of emitC: it runs
// `clarusc emit -o <dir>/main.c claPath` and returns the emitted C bytes, or
// an error (never t.Fatalf) so callers that need to memoize a build across
// multiple top-level tests -- where a per-test t.TempDir() would be cleaned
// up as soon as the first such test finishes -- can use a longer-lived
// directory.
func emitCDir(exe, claPath, dir string) ([]byte, error) {
	mainC := filepath.Join(dir, "main.c")

	cmd := exec.Command(exe, "emit", "-o", mainC, claPath)
	var out, errb bytes.Buffer
	cmd.Stdout = &out
	cmd.Stderr = &errb
	if err := cmd.Run(); err != nil {
		return nil, fmt.Errorf("clarusc emit -o %s %s: %v\nstderr: %s", mainC, claPath, err, errb.String())
	}

	emitted, err := os.ReadFile(mainC)
	if err != nil {
		return nil, fmt.Errorf("read emitted C at %s: %w", mainC, err)
	}
	return emitted, nil
}

// emitC runs `clarusc emit` for claPath and returns the emitted C bytes.
func emitC(t *testing.T, exe, claPath string) []byte {
	t.Helper()
	c, err := emitCDir(exe, claPath, t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	return c
}

// diffFirstDivergence returns a human-readable report of the first line at
// which a and b differ: the 1-based line number plus a few lines of context
// from each side. It exists so a bootstrap-fixed-point failure is
// debuggable ("here's what changed") rather than just "bytes differ".
func diffFirstDivergence(a, b []byte) string {
	linesA := bytes.Split(a, []byte("\n"))
	linesB := bytes.Split(b, []byte("\n"))
	n := len(linesA)
	if len(linesB) < n {
		n = len(linesB)
	}
	i := 0
	for i < n && bytes.Equal(linesA[i], linesB[i]) {
		i++
	}

	ctx := func(lines [][]byte, at int) string {
		lo, hi := at-2, at+3
		if lo < 0 {
			lo = 0
		}
		if hi > len(lines) {
			hi = len(lines)
		}
		var b strings.Builder
		for j := lo; j < hi; j++ {
			marker := "    "
			if j == at {
				marker = ">>> "
			}
			fmt.Fprintf(&b, "%s%5d: %s\n", marker, j+1, lines[j])
		}
		return b.String()
	}

	if i >= len(linesA) || i >= len(linesB) {
		return fmt.Sprintf("first divergence at line %d: one side ends early (c2 has %d lines, c3 has %d lines)\n--- c2 ---\n%s--- c3 ---\n%s",
			i+1, len(linesA), len(linesB), ctx(linesA, i), ctx(linesB, i))
	}
	return fmt.Sprintf("first divergence at line %d:\n--- c2 ---\n%s--- c3 ---\n%s",
		i+1, ctx(linesA, i), ctx(linesB, i))
}

// TestSnapshotFixedPoint is the snapshot fixed-point + freshness oracle:
// it never builds or imports the Go compiler. Generation N is the
// snapshot-bootstrapped clarusc (bootstrapSnapshotClarusc, shared with
// behavior_test.go); it emits C for clarusc's own source, which cc compiles
// into generation N+1 (bootstrapCurrentClarusc, shared with
// crossgen_test.go). Generation N+1 then emits the same source again. If
// both emissions are byte-identical, self-compilation has reached a fixed
// point without ever touching the Go compiler.
//
// It also enforces the snapshot-freshness check, Go-free: gen1 -- the
// snapshot-built compiler's emission of the CURRENT clarusc/main.cla --
// must byte-equal the committed clarusc/clarusc.c (readSnapshot,
// snapshot_test.go). When the snapshot is fresh, snapExe embodies the same
// compiler logic that produced clarusc.c, and emission is deterministic, so
// re-running it over unchanged source reproduces clarusc.c exactly. If
// clarusc/*.cla changed without regenerating the snapshot, gen1 diverges
// from clarusc.c and this fails.
func TestSnapshotFixedPoint(t *testing.T) {
	snapExe := bootstrapSnapshotClarusc(t)
	root := repoRootBehavior(t)
	mainCla := filepath.Join(root, "clarusc", "main.cla")

	gen1 := emitC(t, snapExe, mainCla)

	if committed := readSnapshot(t); !bytes.Equal(gen1, committed) {
		t.Fatalf(`clarusc/clarusc.c is stale: committed snapshot (%d bytes) != fresh emission from the snapshot-built compiler (%d bytes).

The committed snapshot must always match what clarusc currently emits for
its own source. To regenerate it (Go-free, from the old snapshot):

  cc -O1 -I runtime/host -o /tmp/boot clarusc/clarusc.c runtime/host/rt.c
  /tmp/boot emit --rtdir runtime/clarus/ -o /tmp/cur.c clarusc/main.cla
  cc -O1 -I runtime/host -o /tmp/cur /tmp/cur.c runtime/host/rt.c
  /tmp/cur emit --rtdir runtime/clarus/ -o clarusc/clarusc.c clarusc/main.cla

Then commit the updated clarusc/clarusc.c.
%s`, len(committed), len(gen1), diffFirstDivergence(committed, gen1))
	}

	curExe := bootstrapCurrentClarusc(t)
	gen2 := emitC(t, curExe, mainCla)

	if !bytes.Equal(gen1, gen2) {
		t.Fatalf("snapshot fixed point FAILED: generation N emission (%d bytes) != generation N+1 emission (%d bytes)\n%s",
			len(gen1), len(gen2), diffFirstDivergence(gen1, gen2))
	}
	t.Logf("snapshot fixed point reached: gen1 == gen2 (%d bytes), and matches the committed snapshot", len(gen1))
}
