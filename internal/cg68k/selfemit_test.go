// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// selfemit_test.go: Task 13's (mac-resident-clarusc, native-5f) headline
// gate -- clarusc emitting ITSELF (clarusc/main.cla) via emit68k must
// succeed outright at the default segment limit. Task 13 fixed the
// pool-duplication blocker Task 3 found (the pre-Task-13 design
// duplicated the WHOLE constant pool into EVERY CODE segment against a
// 32,760-byte budget, so no function -- however small -- could ever
// pack). Self-emit then hit a second, unrelated structural limit: a
// single function, fpIntrCall (cprint.cla's own giant C-target
// intrinsic-call dispatcher), compiled alone to ~105KB of native code,
// more than 3x the whole segment budget. Task 14 split it at source
// level into fpIntrCall1..7 (a thin fpIntrCall dispatcher chaining
// through them via a fpIntrMatched fallthrough signal), each comfortably
// under the per-function budget, closing this blocker too -- see that
// task's own report for the size audit. TestSelfEmit68k now pins
// unconditional success: any failure here is a regression.
package cg68k

import (
	"os/exec"
	"path/filepath"
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
	if err != nil {
		t.Fatalf("clarusc emit68k --rtdir %s -o %s --listing %s failed (want success -- fpIntrCall split should have closed the last self-emit blocker): %v\n%s",
			rtdir, outBin, mainCla, err, out)
	}

	base := filepath.Join(runDir, "clarusc68k")
	segCount := discoverSegments(t, base)
	t.Logf("clarusc self-emit succeeded, packed into %d CODE segment(s)", segCount)
}
