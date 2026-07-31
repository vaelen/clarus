// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// segment_test.go: native-5d Task 15's gate for real multi-segment CODE
// packing. TestSegmentationMultiSegment compiles the monolithic
// testdata/suite/test_suite.cla via emit68k on the host and asserts it
// really does produce more than one CODE segment (the whole reason Task
// 15 exists -- test_suite.cla exceeds the classic 32KB CODE-resource
// limit as one blob), that every jump-table entry resolves into ITS OWN
// owning segment's actual code range, that every produced .segN.s/
// .segN.dat pair round-trips through vasm byte-identically (Task 6/8's
// own oracle, extended per-segment), and that emitting the same program
// twice produces a byte-identical .bin (cgPackProgram/cg68Program's own
// determinism requirement: packing input is declaration order over
// shaken functions, no size-dependent reordering).
// TestSegmentationOversizedFunction pins the compile-error (not crash)
// path for a single function too large to fit even a fresh segment.
package cg68k

import (
	"bytes"
	"encoding/binary"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strconv"
	"strings"
	"testing"
)

// discoverSegments finds every <base>.segN.s produced alongside outBin
// (N starting at 1, contiguous, stopping at the first gap), returning
// the highest N found (0 if none).
func discoverSegments(t *testing.T, base string) int {
	t.Helper()
	n := 0
	for {
		next := n + 1
		if _, err := os.Stat(fmt.Sprintf("%s.seg%d.s", base, next)); err != nil {
			break
		}
		n = next
	}
	return n
}

func TestSegmentationMultiSegment(t *testing.T) {
	root := repoRoot(t)
	exe := buildClarusc(t)
	fixture := filepath.Join(root, "testdata", "suite", "test_suite.cla")

	runDir := t.TempDir()
	outBin := filepath.Join(runDir, "out.bin")
	cmd := exec.Command(exe, "emit68k", "-o", outBin, "--listing", fixture)
	if out, err := cmd.CombinedOutput(); err != nil {
		t.Fatalf("clarusc emit68k -o %s --listing %s: %v\n%s", outBin, fixture, err, out)
	}

	base := strings.TrimSuffix(outBin, ".bin")
	segCount := discoverSegments(t, base)
	t.Logf("test_suite.cla packed into %d CODE segment(s)", segCount)
	if segCount <= 1 {
		t.Fatalf("test_suite.cla produced %d CODE segment(s), want >1 -- this is Task 15's whole reason to exist (the suite exceeds the 32KB single-segment limit)", segCount)
	}

	// -- every JT entry resolves into its OWN owning segment's code range --
	img, err := os.ReadFile(outBin)
	if err != nil {
		t.Fatalf("read %s: %v", outBin, err)
	}
	if len(img) < 128 {
		t.Fatalf("image too short: %d bytes", len(img))
	}
	h := img[:128]
	rsrcLen := binary.BigEndian.Uint32(h[87:91])
	fork := img[128:]
	if int(rsrcLen) > len(fork) {
		t.Fatalf("resource fork length %d exceeds remaining image bytes %d", rsrcLen, len(fork))
	}
	fork = fork[:rsrcLen]

	_, _, _, _, entries := parseResourceFork(t, fork)

	codeByID := map[int16][]byte{}
	sizeCount := 0
	for _, e := range entries {
		switch e.typ {
		case "CODE":
			codeByID[e.id] = e.data
		case "SIZE":
			sizeCount++
		default:
			t.Errorf("unexpected resource type %q", e.typ)
		}
	}
	if sizeCount != 1 {
		t.Errorf("found %d SIZE resources, want 1", sizeCount)
	}
	wantCode := segCount + 1 // CODE 0 (JT) + one per segment
	if len(codeByID) != wantCode {
		t.Fatalf("found %d CODE resources, want %d (CODE 0 + %d segments)", len(codeByID), wantCode, segCount)
	}
	code0, ok := codeByID[0]
	if !ok {
		t.Fatal("missing CODE 0")
	}
	if len(code0) < 16 {
		t.Fatalf("CODE 0 length = %d, too short for its 16-byte header", len(code0))
	}
	jtLen := binary.BigEndian.Uint32(code0[8:12])
	if jtLen%8 != 0 {
		t.Fatalf("CODE 0 JT length = %d, not a multiple of 8", jtLen)
	}
	nEntries := int(jtLen / 8)
	if nEntries == 0 {
		t.Fatal("CODE 0 has no jump-table entries")
	}
	jt := code0[16:]
	segsSeen := map[int16]bool{}
	for i := 0; i < nEntries; i++ {
		e := jt[i*8:]
		off := binary.BigEndian.Uint16(e[0:2])
		filler := binary.BigEndian.Uint16(e[2:4])
		seg := int16(binary.BigEndian.Uint16(e[4:6]))
		trailer := binary.BigEndian.Uint16(e[6:8])
		if filler != 0x3F3C {
			t.Errorf("JT entry %d: filler word = %#04x, want 0x3F3C", i, filler)
		}
		if trailer != 0xA9F0 {
			t.Errorf("JT entry %d: trailer word = %#04x, want 0xA9F0", i, trailer)
		}
		segData, ok := codeByID[seg]
		if !ok {
			t.Errorf("JT entry %d: owning segment %d has no matching CODE resource", i, seg)
			continue
		}
		segsSeen[seg] = true
		if int(off) > len(segData)-4 {
			t.Errorf("JT entry %d: offset %d out of CODE %d's own code range [0, %d]", i, off, seg, len(segData)-4)
		}
	}
	if off0 := binary.BigEndian.Uint16(jt[0:2]); off0 != 0 {
		t.Errorf("JT entry 0 (startup, JT slot 0) offset = %d, want 0", off0)
	}
	if seg0 := binary.BigEndian.Uint16(jt[4:6]); seg0 != 1 {
		t.Errorf("JT entry 0 (startup, JT slot 0) segment = %d, want 1 (Startup always stays in CODE 1)", seg0)
	}
	// Every real segment (1..segCount) must own at least one JT entry --
	// otherwise cg68WriteImage built a CODE resource nothing ever points
	// at, which would mean cgAssignFinalJtSlots/the per-segment emission
	// loop disagree about which segments exist.
	for s := 1; s <= segCount; s++ {
		if !segsSeen[int16(s)] {
			t.Errorf("segment %d owns no jump-table entry at all", s)
		}
	}

	// -- every cross-segment call aims at a JT entry's ENTRY POINT (+2) --
	//
	// Both forms of a classic 8-byte JT entry keep their first word as
	// DATA (routine offset when unloaded, segment number once _LoadSeg has
	// patched it) and their code at entry+2. So a cross-segment
	// `JSR d16(A5)` must satisfy (d16 - 32) % 8 == 2; aiming at the entry
	// start executes that data word as an opcode, which bombs with
	// illegal-instruction / F-line / A-line depending on the word's
	// numeric value. That is exactly the bug that blocked Task 15's first
	// attempt, and this is the cheap structural check that catches it
	// without booting an emulator.
	jsrA5 := regexp.MustCompile(`JSR\s+(-?\d+)\(A5\)`)
	crossSegCalls := 0
	for n := 1; n <= segCount; n++ {
		segS := fmt.Sprintf("%s.seg%d.s", base, n)
		src, err := os.ReadFile(segS)
		if err != nil {
			t.Fatalf("read %s: %v", segS, err)
		}
		for _, m := range jsrA5.FindAllStringSubmatch(string(src), -1) {
			d, err := strconv.Atoi(m[1])
			if err != nil {
				t.Fatalf("%s: unparsable displacement %q", segS, m[1])
			}
			crossSegCalls++
			if d < 32 || (d-32)%8 != 2 {
				t.Errorf("segment %d: cross-segment call %q targets JT byte %d, which is not a slot entry point (want d >= 32 and (d-32)%%8 == 2)", n, m[0], d)
			}
			if slot := (d - 34) / 8; slot >= nEntries {
				t.Errorf("segment %d: cross-segment call %q targets JT slot %d, past the last slot %d", n, m[0], slot, nEntries-1)
			}
		}
	}
	if crossSegCalls == 0 {
		t.Error("no cross-segment JSR d16(A5) call sites found in a multi-segment build -- the entry-point assertion above is vacuous")
	}

	// -- per-segment vasm round-trip on every .segN.s/.segN.dat pair --
	vasm := requireVasm(t)
	for n := 1; n <= segCount; n++ {
		segS := fmt.Sprintf("%s.seg%d.s", base, n)
		segDat := fmt.Sprintf("%s.seg%d.dat", base, n)
		vasmOut := filepath.Join(runDir, fmt.Sprintf("vasm_seg%d.bin", n))

		vasmCmd := exec.Command(vasm, "-quiet", "-m68000", "-no-opt", "-Fbin", "-o", vasmOut, segS)
		if out, err := vasmCmd.CombinedOutput(); err != nil {
			t.Fatalf("vasm assemble %s: %v\n%s", segS, err, out)
		}
		want, err := os.ReadFile(segDat)
		if err != nil {
			t.Fatalf("read %s: %v", segDat, err)
		}
		got, err := os.ReadFile(vasmOut)
		if err != nil {
			t.Fatalf("read %s: %v", vasmOut, err)
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
			t.Fatalf("segment %d: vasm round-trip diverged at byte offset %d (encoder %d bytes, vasm %d bytes)\n encoder: %s\n vasm:    %s",
				n, off, len(want), len(got), hexWindow(want, off), hexWindow(got, off))
		}
	}

	// -- double-emit determinism on the multi-segment image itself --
	runDir2 := t.TempDir()
	outBin2 := filepath.Join(runDir2, "out.bin")
	cmd2 := exec.Command(exe, "emit68k", "-o", outBin2, fixture)
	if out, err := cmd2.CombinedOutput(); err != nil {
		t.Fatalf("clarusc emit68k -o %s %s: %v\n%s", outBin2, fixture, err, out)
	}
	runDir3 := t.TempDir()
	outBin3 := filepath.Join(runDir3, "out.bin")
	cmd3 := exec.Command(exe, "emit68k", "-o", outBin3, fixture)
	if out, err := cmd3.CombinedOutput(); err != nil {
		t.Fatalf("clarusc emit68k -o %s %s: %v\n%s", outBin3, fixture, err, out)
	}
	img2, err := os.ReadFile(outBin2)
	if err != nil {
		t.Fatal(err)
	}
	img3, err := os.ReadFile(outBin3)
	if err != nil {
		t.Fatal(err)
	}
	if !bytes.Equal(img2, img3) {
		t.Fatalf("emit68k is non-deterministic on a multi-segment build: test_suite.cla's .bin differs across two runs (%d vs %d bytes)", len(img2), len(img3))
	}
}

// TestSegmentationOversizedFunction pins the "function <name> exceeds the
// 32KB segment limit" compile-error path (a diagnostic, not a crash) for
// a single function too large to fit even a fresh, otherwise-empty
// segment: a synthetic function with several thousand statements, each
// one a real instruction cgPackProgram must count against the budget.
func TestSegmentationOversizedFunction(t *testing.T) {
	exe := buildClarusc(t)
	dir := t.TempDir()

	var b strings.Builder
	b.WriteString("func hugefn(): int {\n")
	b.WriteString("    var x: int\n")
	b.WriteString("    x = 0\n")
	for i := 0; i < 6000; i++ {
		fmt.Fprintf(&b, "    x = x + %d\n", i)
	}
	b.WriteString("    return x\n")
	b.WriteString("}\n")
	b.WriteString("on App.launch {\n")
	b.WriteString("    var r: int\n")
	b.WriteString("    r = hugefn()\n")
	b.WriteString("}\n")

	src := filepath.Join(dir, "oversized.cla")
	if err := os.WriteFile(src, []byte(b.String()), 0o644); err != nil {
		t.Fatal(err)
	}

	outBin := filepath.Join(dir, "out.bin")
	cmd := exec.Command(exe, "emit68k", "-o", outBin, src)
	out, err := cmd.CombinedOutput()
	if err == nil {
		t.Fatalf("emit68k unexpectedly succeeded on an oversized function:\n%s", out)
	}
	if !strings.Contains(string(out), "function hugefn exceeds the 32KB segment limit") {
		t.Fatalf("expected the named oversized-function error, got:\n%s", out)
	}
	if _, statErr := os.Stat(outBin); statErr == nil {
		t.Errorf("emit68k left a .bin behind despite the oversized-function error")
	}
}
