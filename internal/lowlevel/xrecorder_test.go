// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// xrecorder_test.go: native-gaps-cleanup Task 8's T1-visible twin of
// testdata/errors/xrec_order.cla + .expect (internal/selfhost's
// TestErrorGoldens). That golden lives in internal/selfhost, which
// CLAUDE.md's T1 gate (scripts/test-task.sh) explicitly excludes -- it
// only runs under T2 (scripts/test-merge.sh). A regression of the panic
// class this fixture pins (`var r: SomeXRec` with `extern record SomeXRec`
// declared AFTER the using func -- checks clean under the checker's
// order-independent two-phase declaration pass, but pre-fix crashed during
// lowering's own single sequential pass with "runtime error: list index
// out of range", exit 3) would otherwise be invisible until T2. This
// package (internal/lowlevel) IS part of T1, so this twin, modeled on
// rtinc_test.go's buildClarusc/repoRoot pattern, closes that gap: it runs
// `clarusc emit` on the SAME fixture (single source of truth, no
// duplicated .cla content) and asserts nonzero exit plus the diagnostic
// substring, and explicitly asserts the OLD panic string is gone.
package lowlevel

import (
	"bytes"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
)

func TestXRecOrderDiagnoses(t *testing.T) {
	root := repoRoot(t)
	exe := buildClarusc(t)
	fixture := filepath.Join(root, "testdata", "errors", "xrec_order.cla")

	outC := filepath.Join(t.TempDir(), "out.c")
	cmd := exec.Command(exe, "emit", "-o", outC, fixture)
	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	err := cmd.Run()
	combined := stdout.String() + stderr.String()

	if err == nil {
		t.Fatalf("clarusc emit %s: expected nonzero exit (unresolved extern-record layout), got success\nstdout: %s", fixture, stdout.String())
	}
	if _, ok := err.(*exec.ExitError); !ok {
		t.Fatalf("run clarusc emit %s: %v", fixture, err)
	}
	const wantSubstr = "extern record SomeXRec is not declared before this use"
	if !strings.Contains(combined, wantSubstr) {
		t.Fatalf("diagnostic missing %q: stdout: %s\nstderr: %s", wantSubstr, stdout.String(), stderr.String())
	}
	const panicStr = "list index out of range"
	if strings.Contains(combined, panicStr) {
		t.Fatalf("output still contains the old panic string %q -- guard regressed: stdout: %s\nstderr: %s", panicStr, stdout.String(), stderr.String())
	}
}
