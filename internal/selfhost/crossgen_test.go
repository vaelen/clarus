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
// generation N -- NOT internal/build.Build, and NOT the frozen Go
// compiler.
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
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"sync"
	"testing"
)

var (
	currentClaruscOnce sync.Once
	currentClaruscExe  string
	currentClaruscErr  error
)

// bootstrapCurrentClarusc builds "current-source clarusc": the
// snapshot-bootstrapped compiler (snapshotExe, from bootstrapSnapshotClarusc)
// emits C for clarusc/main.cla -- the compiler's own current source --
// which cc then compiles into generation N+1. Memoized since every fixture
// in the corpus reuses the same exe.
func bootstrapCurrentClarusc(t *testing.T, snapshotExe, root string) string {
	t.Helper()
	currentClaruscOnce.Do(func() {
		dir, err := os.MkdirTemp("", "clarusc-current-*")
		if err != nil {
			currentClaruscErr = err
			return
		}
		curC := filepath.Join(dir, "cur.c")
		rtDir := filepath.Join(root, "runtime", "clarus") + string(filepath.Separator)
		emit := exec.Command(snapshotExe, "emit", "--rtdir", rtDir, "-o", curC,
			filepath.Join(root, "clarusc", "main.cla"))
		if out, err := emit.CombinedOutput(); err != nil {
			currentClaruscErr = fmt.Errorf("snapshot clarusc emit current source: %v\n%s", err, out)
			return
		}

		exe := filepath.Join(dir, "clarusc")
		cc := exec.Command("cc", "-O1", "-I", filepath.Join(root, "internal", "build", "rt"),
			"-o", exe, curC, filepath.Join(root, "internal", "build", "rt", "rt.c"))
		if out, err := cc.CombinedOutput(); err != nil {
			currentClaruscErr = fmt.Errorf("cc compile current-gen clarusc: %v\n%s", err, out)
			return
		}
		currentClaruscExe = exe
	})
	if currentClaruscErr != nil {
		t.Fatal(currentClaruscErr)
	}
	return currentClaruscExe
}

// TestCrossGenDifferential is the second Go-free oracle: for every fixture
// in the runnable corpus, it compares generation N (snapshot) against
// generation N+1 (current source, built BY generation N) on captured run
// output. See the file header for the arbiter rule on intentional
// divergence.
func TestCrossGenDifferential(t *testing.T) {
	snapExe := bootstrapSnapshotClarusc(t)
	root := repoRootBehavior(t)
	curExe := bootstrapCurrentClarusc(t, snapExe, root)

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
