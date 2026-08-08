// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// selfemit_test.go: Task 13's (mac-resident-clarusc, native-5f) headline
// gate -- clarusc emitting ITSELF (clarusc/main.cla) via emit68k must get
// PAST the pool-duplication blocker Task 3 found: the pre-Task-13 design
// duplicated the WHOLE constant pool (32.8KB, clarusc's own -- every
// string literal in the whole compiler) into EVERY CODE segment against
// a 32,760-byte budget, so no function -- however small -- could ever
// pack (task-3-report.md's own "Blocking finding" section; this file's
// own cg68k.cla Task 13 header comment). Task 13 fixes that (each
// segment now carries only the pool entries its own packed functions
// reference), but self-emit still doesn't fully succeed: it now fails
// LATER, on a DIFFERENT, unrelated structural limit -- a single
// function, fpIntrCall (cprint.cla's own giant C-target intrinsic-call
// dispatcher), compiles alone to ~105KB of native code, more than 3x the
// whole segment budget, so no packing strategy can fit it in one
// segment (confirmed by raising --seglimit far past 32760: self-emit
// packs cleanly into 5 segments at --seglimit 200000, isolating this as
// a single-oversized-function problem, not a pool or packing-logic bug).
// Splitting an oversized function is a different, larger piece of work
// than pool segmentation -- out of this task's scope, flagged as a
// follow-on item in its own report.
//
// TestSelfEmit68k therefore pins exactly what Task 13 actually delivers:
// self-emit must NOT fail with the old pool-duplication error (or any
// OTHER unexpected error -- a regression signal), and if it fails at
// all, must fail with precisely the known, already-isolated fpIntrCall
// segment-size error. If a future task splits fpIntrCall (or otherwise
// closes that gap) and self-emit starts succeeding outright, this test
// accepts that too (and logs it) -- it only fails on a SURPRISE.
package cg68k

import (
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
)

func TestSelfEmit68k(t *testing.T) {
	root := repoRoot(t)
	exe := buildClarusc(t)

	runDir := t.TempDir()
	outBin := filepath.Join(runDir, "clarusc68k.bin")
	rtdir := filepath.Join(root, "runtime", "clarus") + string(filepath.Separator)
	mainCla := filepath.Join(root, "clarusc", "main.cla")

	cmd := exec.Command(exe, "emit68k", "--rtdir", rtdir, "-o", outBin, "--listing", mainCla)
	out, err := cmd.CombinedOutput()
	if err == nil {
		base := filepath.Join(runDir, "clarusc68k")
		segCount := discoverSegments(t, base)
		t.Logf("clarusc self-emit fully succeeded, packed into %d CODE segment(s) (fpIntrCall's own segment-size blocker must have closed -- update this test's own doc comment)", segCount)
		return
	}

	const knownBlocker = "function fpIntrCall exceeds the 32KB segment limit"
	if !strings.Contains(string(out), knownBlocker) {
		t.Fatalf("clarusc emit68k --rtdir %s -o %s --listing %s failed with an UNEXPECTED error (want either success or the known fpIntrCall blocker %q): %v\n%s",
			rtdir, outBin, mainCla, knownBlocker, err, out)
	}
	t.Logf("clarusc self-emit reached the known fpIntrCall segment-size blocker (pool segmentation itself works -- see this task's own report)")
}
