// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// crossgen_test.go: test-suite-review Task 4's cross-generation
// differential -- the second Go-free oracle. TestCrossGenDifferential
// builds two clarusc generations without ever invoking a Go compiler
// package: generation N is the snapshot bootstrap Task 3 already builds
// (bootstrapSnapshotClarusc, from the committed clarusc/clarusc.c);
// generation N+1 is "current-source clarusc" -- generation N used to
// `emit` C for clarusc/main.cla (the compiler's own current source), which
// `cc` then builds into a binary. This is generation N+1 built BY
// generation N -- not via Go's own build tooling, and not the frozen Go
// compiler (both long gone).
//
// For every fixture in the runnable corpus (testdata/run, testdata/runerr,
// via runnableFixtures -- shared with behavior_test.go's
// TestBehaviorGoldens), both generations emit+compile+run the fixture
// through runBehaviorFixture, and their behaviorBlob-captured run output
// (exit, stdout, stderr) is compared. Simplest correct v1 per the task
// brief: run-output comparison, not byte-identical emitted C -- the same
// oracle strength as the retired Go differential sweep, with zero Go.
//
// Arbiter rule: this test is expected to be GREEN whenever the current
// clarusc source has no INTENTIONAL behavior change since the snapshot.
// If a change to clarusc/*.cla deliberately changes runtime behavior, the
// fix is: re-bless Task 3's affected testdata/*.behavior golden(s) (with a
// justification in the commit message), and this test's expectation
// follows automatically -- it only ever compares the two live-built
// generations against each other, never against a frozen third copy. The
// snapshot side (clarusc/clarusc.c) is untouched here; it is regenerated
// only at the next release per the existing snapshot policy.
package selfhost

import (
	"os"
	"path/filepath"
	"strings"
	"testing"

	"clarus/internal/claruscboot"
)

// bootstrapCurrentClarusc returns current-source clarusc (generation N+1,
// built BY the snapshot generation) via the shared bootstrap.
func bootstrapCurrentClarusc(t *testing.T) string {
	t.Helper()
	return claruscboot.CurrentExe(t)
}

// TestCrossGenDifferential is the second Go-free oracle: for every fixture
// in the runnable corpus, it compares generation N (snapshot) against
// generation N+1 (current source, built BY generation N) on captured run
// output. See the file header for the arbiter rule on intentional
// divergence.
func TestCrossGenDifferential(t *testing.T) {
	snapExe := bootstrapSnapshotClarusc(t)
	root := repoRootBehavior(t)
	curExe := bootstrapCurrentClarusc(t)

	runFiles, runerrFiles := runnableFixtures(t)

	check := func(t *testing.T, f string, argv []string) {
		t.Helper()
		snapExit, snapOut, snapErr, _ := runBehaviorFixture(t, snapExe, root, f, argv, false)
		curExit, curOut, curErr, _ := runBehaviorFixture(t, curExe, root, f, argv, false)

		snapBlob := behaviorBlob(snapExit, snapOut, snapErr)
		curBlob := behaviorBlob(curExit, curOut, curErr)
		if string(snapBlob) != string(curBlob) {
			t.Errorf("generation divergence for %s:\nsnapshot: %s\ncurrent:  %s", f, snapBlob, curBlob)
		}
	}

	for _, f := range runFiles {
		f := f
		t.Run("run/"+filepath.Base(f), func(t *testing.T) {
			base := strings.TrimSuffix(f, ".cla")
			var argv []string
			if b, err := os.ReadFile(base + ".args"); err == nil {
				argv = strings.Fields(string(b))
			}
			check(t, f, argv)
		})
	}

	for _, f := range runerrFiles {
		f := f
		t.Run("runerr/"+filepath.Base(f), func(t *testing.T) {
			check(t, f, nil)
		})
	}
}
