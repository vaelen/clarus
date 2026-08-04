// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// gogate_test.go: test-suite-review Task 6. Gates every selfhost test that
// builds or exercises the frozen Go compiler (build.Build, or a self-built
// clarusc descended from it) behind CLARUS_GO_DIFF=1, so the default `go
// test ./...` gauntlet is Go-free -- Tasks 3-5b's Go-free oracles
// (behavior_test.go, crossgen_test.go, snapshot_test.go's TestSnapshotBuilds)
// already cover the same ground without it. CLARUS_GO_DIFF=1 reinstates the
// Go lanes for T2/merge (see scripts/test-merge.sh) and ad hoc differential
// debugging. See CLAUDE.md's CLARUS_GO_DIFF documentation.
package selfhost

import (
	"bytes"
	"os"
	"path/filepath"
	"testing"
)

// requireGoCompiler skips t unless CLARUS_GO_DIFF=1 is set.
func requireGoCompiler(t *testing.T) {
	t.Helper()
	if os.Getenv("CLARUS_GO_DIFF") != "1" {
		t.Skip("CLARUS_GO_DIFF=1 not set; skipping Go-compiler-lane test (see CLAUDE.md)")
	}
}

// TestSnapshotFixedPoint is the Go-free counterpart to bootstrap_test.go's
// TestBootstrapFixedPoint: it never builds or imports the Go compiler.
// Generation N is the snapshot-bootstrapped clarusc (bootstrapSnapshotClarusc,
// shared with behavior_test.go); it emits C for clarusc's own source, which
// cc compiles into generation N+1 (bootstrapCurrentClarusc, shared with
// crossgen_test.go). Generation N+1 then emits the same source again. If
// both emissions are byte-identical, self-compilation has reached a fixed
// point without ever touching the Go compiler.
//
// It also restores, ungated, the snapshot-freshness check that gating
// TestSnapshotCurrent (snapshot_test.go) took out of the default run:
// gen1 -- the snapshot-built compiler's emission of the CURRENT
// clarusc/main.cla -- must byte-equal the committed clarusc/clarusc.c
// (readSnapshot, snapshot_test.go). When the snapshot is fresh, snapExe
// embodies the same compiler logic that produced clarusc.c, and emission
// is deterministic, so re-running it over unchanged source reproduces
// clarusc.c exactly. If clarusc/*.cla changed without regenerating the
// snapshot, gen1 diverges from clarusc.c and this fails -- the same
// contract TestSnapshotCurrent enforced, now enforced Go-free.
func TestSnapshotFixedPoint(t *testing.T) {
	snapExe := bootstrapSnapshotClarusc(t)
	root := repoRootBehavior(t)
	mainCla := filepath.Join(root, "clarusc", "main.cla")

	gen1 := emitC(t, snapExe, mainCla)

	if committed := readSnapshot(t); !bytes.Equal(gen1, committed) {
		t.Fatalf(`clarusc/clarusc.c is stale: committed snapshot (%d bytes) != fresh emission from the snapshot-built compiler (%d bytes).

The committed snapshot must always match what clarusc currently emits for
its own source. To regenerate it:

  go run ./cmd/clarus build -o /tmp/clarusc clarusc/main.cla
  /tmp/clarusc emit -o clarusc/clarusc.c clarusc/main.cla

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
