// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// array_assign_test.go: final-review C1 regression, updated by native-5e
// Task 2. Whole-fixed-array assignment (`b = a` for `arr N of T`, including
// `r.field = arrVar`) used to fall through cgStmt's SAssign catch-all as a
// bare a68Comment -- a silent no-op that dropped the store (host/native
// miscompile of Ch3's documented copy-by-value semantics) -- and 5d's
// final-review converted that catch-all to a named log+quit error
// (fail-closed) as an interim measure. Task 2 implements the real fix
// (cgExprAddr + cgBlockCopy, cgEmitStoreArr in cg68k.cla): this test now
// pins the POSITIVE behavior -- emit68k succeeds and produces a real,
// vasm-encodable block-copy sequence for the same shape the old test
// fixed the error message for. Full semantic correctness (the copy
// actually preserves values and isn't an alias) is covered by
// testdata/lowlevel/arr_whole_assign.cla under internal/lowlevel (host
// lane) plus a manual native boot spot-check (task-2-report.md).
package cg68k

import (
	"bytes"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
)

func TestSAssignWholeArraySucceeds(t *testing.T) {
	exe := buildClarusc(t)
	vasm := requireVasm(t)
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
	cmd := exec.Command(exe, "emit68k", "-o", outBin, "--listing", src)
	out, err := cmd.CombinedOutput()
	if err != nil {
		t.Fatalf("clarusc emit68k -o %s --listing %s: %v\n%s", outBin, src, err, out)
	}
	if _, statErr := os.Stat(outBin); statErr != nil {
		t.Fatalf("emit68k reported success but left no .bin: %v", statErr)
	}

	segS := filepath.Join(dir, "out.seg1.s")
	segDat := filepath.Join(dir, "out.seg1.dat")
	vasmOut := filepath.Join(dir, "vasm_out.bin")
	vasmCmd := exec.Command(vasm, "-quiet", "-m68000", "-no-opt", "-Fbin", "-o", vasmOut, segS)
	if out, err := vasmCmd.CombinedOutput(); err != nil {
		t.Fatalf("vasm assemble %s: %v\n%s", segS, err, out)
	}
	want, err := os.ReadFile(segDat) // cg68k.cla's own encoder (via asm68k.cla)
	if err != nil {
		t.Fatalf("read %s: %v", segDat, err)
	}
	got, err := os.ReadFile(vasmOut) // vasm's assembly of the same listing
	if err != nil {
		t.Fatalf("read %s: %v", vasmOut, err)
	}
	if !bytes.Equal(want, got) {
		t.Fatalf("%s: vasm round-trip diverged (encoder %d bytes, vasm %d bytes)", segS, len(want), len(got))
	}
}

// TestSAssignWholeArrayHandleElemFailsClosed is fix-round-1's regression:
// a scalar-element whole-array assign now succeeds (TestSAssignWholeArraySucceeds
// above), but an element type that itself needs ARC release (text[n] here;
// same for list-of/map-of or a handle-bearing record element) must still
// fail closed -- cgEmitStoreArr's raw block copy has no retain/release walk,
// so silently allowing it would duplicate the handle with no retain and
// leak/UAF the dst's old value. Pins the exact named error cgStmt's SAssign
// KArr arm now raises for this shape, mirroring the pre-Task-2 pinned-error
// test this file used to have for the (now-fixed) scalar case.
func TestSAssignWholeArrayHandleElemFailsClosed(t *testing.T) {
	exe := buildClarusc(t)
	dir := t.TempDir()

	src := filepath.Join(dir, "wholearraytext.cla")
	body := `on App.launch {
    var a: text[2]
    var b: text[2]
    a[0] = "x"
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
		t.Fatalf("emit68k unexpectedly succeeded on a handle-bearing whole-array assignment:\n%s", out)
	}
	if !strings.Contains(string(out), "whole-array assignment of handle-bearing elements unsupported natively") {
		t.Fatalf("expected the named handle-bearing-element fail-closed error, got:\n%s", out)
	}
	if _, statErr := os.Stat(outBin); statErr == nil {
		t.Errorf("emit68k left a .bin behind despite the whole-array-assign error")
	}
}
