// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// Package asm68k is the vasm round-trip oracle (native-5d Task 6): proof
// that clarusc/asm68k.cla's listing text and its own binary encoder agree,
// by handing the listing to a REAL third-party 68000 assembler (vasm) and
// byte-comparing its output against asm68k.cla's own a68Bytes(). Neither
// side is trusted a priori -- convergence is the evidence.
//
// vasm itself is not vendored as a binary (see requireVasm below for the
// exact rebuild recipe); this package skips outright if it's missing or
// can't produce -Fbin output, same spirit as mactest's requireMac.
package asm68k

import (
	"bytes"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"

	"clarus/internal/build"
)

func repoRoot(t *testing.T) string {
	t.Helper()
	wd, err := os.Getwd()
	if err != nil {
		t.Fatalf("getwd: %v", err)
	}
	return filepath.Join(wd, "..", "..")
}

// requireVasm returns the path to a working vasmm68k_mot, or skips the test
// with a rebuild recipe if it's missing or lacks the -Fbin (binary output)
// module.
//
// vasm/ in this repo ships only vasm's doc + a gitignored binary (like the
// Retro68/toolchain symlinks -- see repo CLAUDE.md); the binary is NOT
// committed and must be built locally from vasm 1.8g source with the bin
// output module enabled:
//
//	cd <vasm-source-checkout>          # e.g. a sibling clone of vasm 1.8g
//	make CPU=m68k SYNTAX=mot           # top-level Makefile; OUTFMTS in
//	                                    # Makefile already includes -DOUTBIN
//	cp vasmm68k_mot <clarus-repo>/vasm/vasmm68k_mot
//
// The probe below (real assemble-and-check, not just a banner grep) is
// what matters: a stale local binary built without the bin module (this
// repo has hit that before -- see the "CRITICAL environment fact" in
// native-5d Task 6's brief) must SKIP, not fail, since that's an
// environment gap, not a code bug.
func requireVasm(t *testing.T) string {
	t.Helper()
	exe := filepath.Join(repoRoot(t), "vasm", "vasmm68k_mot")
	if _, err := os.Stat(exe); err != nil {
		t.Skipf("vasm/vasmm68k_mot not found (%v) -- build it from vasm source with the bin output module; see requireVasm's doc comment for the exact recipe", err)
	}

	dir := t.TempDir()
	probeSrc := filepath.Join(dir, "probe.s")
	if err := os.WriteFile(probeSrc, []byte("\tdc.b\t1,2,3,4\n\tend\n"), 0o644); err != nil {
		t.Fatalf("write probe.s: %v", err)
	}
	probeBin := filepath.Join(dir, "probe.bin")
	cmd := exec.Command(exe, "-quiet", "-m68000", "-no-opt", "-Fbin", "-o", probeBin, probeSrc)
	out, err := cmd.CombinedOutput()
	if err != nil {
		t.Skipf("vasm/vasmm68k_mot failed a -Fbin probe (likely built without the bin output module -- see requireVasm's doc comment for the rebuild recipe): %v\n%s", err, out)
	}
	got, err := os.ReadFile(probeBin)
	if err != nil || !bytes.Equal(got, []byte{1, 2, 3, 4}) {
		t.Skipf("vasm/vasmm68k_mot -Fbin probe produced unexpected output (got %x, err %v) -- see requireVasm's doc comment for the rebuild recipe", got, err)
	}
	return exe
}

// hexWindow renders data[max(0,off-16) : off+16] as space-separated hex,
// for a divergence report readable without reaching for xxd.
func hexWindow(data []byte, off int) string {
	lo := off - 16
	if lo < 0 {
		lo = 0
	}
	hi := off + 16
	if hi > len(data) {
		hi = len(data)
	}
	var b strings.Builder
	for i := lo; i < hi; i++ {
		if i == off {
			b.WriteString("[")
		}
		fmt.Fprintf(&b, "%02x", data[i])
		if i == off {
			b.WriteString("]")
		}
		b.WriteByte(' ')
	}
	return b.String()
}

// TestVasmRoundTrip builds internal/asm68k/exercise.cla with the frozen Go
// compiler, runs it to get asm68k.cla's own listing (exer.s) and its own
// encoded bytes (exer.dat) for the SAME exerciser stream
// (a68SelfExercise()), assembles exer.s with vasm, and requires the result
// to be byte-identical to exer.dat. A divergence means the table is wrong
// -- either the encoder or the listing printer -- since both are driven
// off the same per-instruction fields; see asm68k.cla's own header comment
// ("ONE TABLE, TWO CONSUMERS").
func TestVasmRoundTrip(t *testing.T) {
	vasm := requireVasm(t)
	root := repoRoot(t)

	runDir := t.TempDir()
	exe := filepath.Join(runDir, "exercise")
	diags, err := build.Build([]string{filepath.Join(root, "internal", "asm68k", "exercise.cla")}, exe)
	if err != nil || len(diags) > 0 {
		t.Fatalf("build exercise.cla: err=%v diags=%v", err, diags)
	}

	cmd := exec.Command(exe)
	cmd.Dir = runDir // exercise.cla writes exer.s/exer.dat via relative paths
	if out, err := cmd.CombinedOutput(); err != nil {
		t.Fatalf("run exercise: %v\n%s", err, out)
	}

	exerS := filepath.Join(runDir, "exer.s")
	exerDat := filepath.Join(runDir, "exer.dat")
	outBin := filepath.Join(runDir, "out.bin")

	vasmCmd := exec.Command(vasm, "-quiet", "-m68000", "-no-opt", "-Fbin", "-o", outBin, exerS)
	vasmCmd.Dir = runDir
	if out, err := vasmCmd.CombinedOutput(); err != nil {
		t.Fatalf("vasm assemble exer.s: %v\n%s", err, out)
	}

	want, err := os.ReadFile(exerDat) // asm68k.cla's own encoder
	if err != nil {
		t.Fatalf("read exer.dat: %v", err)
	}
	got, err := os.ReadFile(outBin) // vasm's assembly of asm68k.cla's own listing
	if err != nil {
		t.Fatalf("read out.bin: %v", err)
	}

	if !bytes.Equal(want, got) {
		n := len(want)
		if len(got) < n {
			n = len(got)
		}
		off := n
		for i := 0; i < n; i++ {
			if want[i] != got[i] {
				off = i
				break
			}
		}
		t.Fatalf("vasm round-trip diverged at byte offset %d (encoder %d bytes, vasm %d bytes)\n encoder: %s\n vasm:    %s",
			off, len(want), len(got), hexWindow(want, off), hexWindow(got, off))
	}
}
