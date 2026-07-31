// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// array_assign_test.go: final-review C1 regression. Whole-fixed-array
// assignment (`b = a` for `arr N of T`, including `r.field = arrVar`) used
// to fall through cgStmt's SAssign catch-all as a bare a68Comment -- a
// silent no-op that dropped the store (host/native miscompile of Ch3's
// documented copy-by-value semantics). The fix converts that catch-all to
// a named log+quit error, mirroring the array-as-param/return hard-errors
// already established elsewhere in cg68k.cla (cgExpr's EVarRef/EFieldRef/
// EIndexRef non-scalar arms). This test pins the fail-closed error message
// rather than a silent bad build, per TestSegmentationOversizedFunction's
// own pattern.
package cg68k

import (
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
)

func TestSAssignWholeArrayFailsClosed(t *testing.T) {
	exe := buildClarusc(t)
	dir := t.TempDir()

	src := filepath.Join(dir, "wholearray.cla")
	body := `on App.launch {
    var a: int[3]
    var b: int[3]
    a[0] = 1
    b = a
}
`
	if err := os.WriteFile(src, []byte(body), 0o644); err != nil {
		t.Fatal(err)
	}

	outBin := filepath.Join(dir, "out.bin")
	cmd := exec.Command(exe, "emit68k", "-o", outBin, src)
	out, err := cmd.CombinedOutput()
	if err == nil {
		t.Fatalf("emit68k unexpectedly succeeded on a whole-fixed-array assignment:\n%s", out)
	}
	if !strings.Contains(string(out), "cg68k: cgStmt: SAssign dst kind") || !strings.Contains(string(out), "whole fixed-array assignment") {
		t.Fatalf("expected the named whole-array-assign fail-closed error, got:\n%s", out)
	}
	if _, statErr := os.Stat(outBin); statErr == nil {
		t.Errorf("emit68k left a .bin behind despite the whole-array-assign error")
	}
}
