// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

package mactest

import (
	"bytes"
	"encoding/hex"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"
	"testing"
)

// buildPbm2Icn compiles scripts/pbm2icn.c with the host cc into t.TempDir()
// and returns the binary's path. Not gated on CLARUS_MAC_TESTS -- this is a
// host-side converter, no Retro68/emulator needed.
func buildPbm2Icn(t *testing.T) string {
	t.Helper()
	root := repoRoot(t)
	bin := filepath.Join(t.TempDir(), "pbm2icn")
	cmd := exec.Command("cc", "-Wall", "-o", bin, filepath.Join(root, "scripts", "pbm2icn.c"))
	var stderr bytes.Buffer
	cmd.Stderr = &stderr
	if err := cmd.Run(); err != nil {
		t.Fatalf("cc scripts/pbm2icn.c: %v\n%s", err, stderr.String())
	}
	return bin
}

// runPbm2Icn runs bin on pbmPath, returning stdout and the exit code.
func runPbm2Icn(t *testing.T, bin, pbmPath string) (string, int) {
	t.Helper()
	cmd := exec.Command(bin, pbmPath)
	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	err := cmd.Run()
	exitCode := 0
	if err != nil {
		ee, ok := err.(*exec.ExitError)
		if !ok {
			t.Fatalf("run pbm2icn: %v", err)
		}
		exitCode = ee.ExitCode()
	}
	if exitCode != 0 && stderr.Len() == 0 {
		t.Errorf("nonzero exit (%d) with no stderr message", exitCode)
	}
	return stdout.String(), exitCode
}

// readPbmP1Bits parses a plain P1 PBM into a 1024-long row-major []bool
// (true = black), tolerating '#' comments anywhere between tokens.
func readPbmP1Bits(t *testing.T, path string) []bool {
	t.Helper()
	data, err := os.ReadFile(path)
	if err != nil {
		t.Fatal(err)
	}
	var sb strings.Builder
	s := string(data)
	for i := 0; i < len(s); i++ {
		if s[i] == '#' {
			for i < len(s) && s[i] != '\n' {
				i++
			}
			continue
		}
		sb.WriteByte(s[i])
	}
	fields := strings.Fields(sb.String())
	if len(fields) < 3 || fields[0] != "P1" {
		t.Fatalf("expected P1 header in %s", path)
	}
	bits := make([]bool, 0, 1024)
	for _, f := range fields[3:] {
		for _, c := range f {
			bits = append(bits, c == '1')
		}
	}
	if len(bits) != 1024 {
		t.Fatalf("expected 1024 bits, got %d", len(bits))
	}
	return bits
}

// bitsToICNBytes packs row-major bits (true=black) into 128 MSB-first bytes.
func bitsToICNBytes(bits []bool) []byte {
	out := make([]byte, 128)
	for i, b := range bits {
		if b {
			out[i/8] |= 0x80 >> uint(i%8)
		}
	}
	return out
}

// expectedMask mirrors pbm2icn.c's flood-fill algorithm in Go, as an
// independent check on the C implementation: BFS from every white border
// pixel (4-connectivity); mask bit = 1 unless the pixel is white AND was
// reached from the border (i.e. black pixels and enclosed white holes stay
// opaque).
func expectedMask(bits []bool) []byte {
	const n = 32
	get := func(r, c int) bool { return bits[r*n+c] }
	visited := make([]bool, n*n)
	var queue [][2]int
	mark := func(r, c int) {
		if r < 0 || r >= n || c < 0 || c >= n {
			return
		}
		if !visited[r*n+c] && !get(r, c) {
			visited[r*n+c] = true
			queue = append(queue, [2]int{r, c})
		}
	}
	for c := 0; c < n; c++ {
		mark(0, c)
		mark(n-1, c)
	}
	for r := 0; r < n; r++ {
		mark(r, 0)
		mark(r, n-1)
	}
	for h := 0; h < len(queue); h++ {
		r, c := queue[h][0], queue[h][1]
		for _, d := range [][2]int{{1, 0}, {-1, 0}, {0, 1}, {0, -1}} {
			mark(r+d[0], c+d[1])
		}
	}
	maskBits := make([]bool, n*n)
	for i := range maskBits {
		maskBits[i] = !(!bits[i] && visited[i]) // white = !bits[i]
	}
	return bitsToICNBytes(maskBits)
}

var hexBlockRe = regexp.MustCompile(`\$"([0-9A-Fa-f ]+)"`)

// extractHexBlocks parses the ICN# icon/mask hex blocks and the trailing
// ICON icon hex block (8 lines of 16 bytes each) out of pbm2icn's Rez
// output.
func extractHexBlocks(t *testing.T, out string) (icon, mask, iconRes []byte) {
	t.Helper()
	matches := hexBlockRe.FindAllStringSubmatch(out, -1)
	if len(matches) != 24 {
		t.Fatalf("expected 24 hex-string lines (8 ICN# icon + 8 ICN# mask + 8 ICON), got %d:\n%s", len(matches), out)
	}
	join := func(lines [][]string) []byte {
		var hexStr strings.Builder
		for _, m := range lines {
			hexStr.WriteString(strings.ReplaceAll(m[1], " ", ""))
		}
		b, err := hex.DecodeString(hexStr.String())
		if err != nil {
			t.Fatalf("bad hex in output: %v", err)
		}
		if len(b) != 128 {
			t.Fatalf("expected 128 bytes, got %d", len(b))
		}
		return b
	}
	return join(matches[:8]), join(matches[8:16]), join(matches[16:24])
}

func TestPbm2Icn(t *testing.T) {
	bin := buildPbm2Icn(t)
	probe := filepath.Join(repoRoot(t), "tests", "mactest", "testdata", "icon_probe.pbm")

	bits := readPbmP1Bits(t, probe)
	wantIcon := bitsToICNBytes(bits)
	wantMask := expectedMask(bits)

	out, exitCode := runPbm2Icn(t, bin, probe)
	if exitCode != 0 {
		t.Fatalf("exit %d, want 0:\n%s", exitCode, out)
	}
	if !strings.Contains(out, "resource 'ICN#' (128, purgeable)") {
		t.Fatalf("missing ICN# resource header:\n%s", out)
	}
	if !strings.Contains(out, "resource 'ICON' (128, purgeable)") {
		t.Fatalf("missing ICON resource header:\n%s", out)
	}
	gotIcon, gotMask, gotIconRes := extractHexBlocks(t, out)
	if !bytes.Equal(gotIcon, wantIcon) {
		t.Errorf("icon bytes mismatch:\n got  %X\n want %X", gotIcon, wantIcon)
	}
	if !bytes.Equal(gotMask, wantMask) {
		t.Errorf("mask bytes mismatch:\n got  %X\n want %X", gotMask, wantMask)
	}
	if !bytes.Equal(gotIconRes, wantIcon) {
		t.Errorf("ICON resource bytes mismatch (should equal icon, not mask):\n got  %X\n want %X", gotIconRes, wantIcon)
	}

	// Spot-check the center row: the ring's interior hole is white (icon
	// bit 0) but fully enclosed by the black annulus, so its mask bit must
	// stay 1 (opaque) even though it's white -- proving the mask isn't a
	// naive "invert the icon" but a real flood fill from the border.
	const centerRow = 15
	bitAt := func(bmp []byte, row, col int) byte {
		i := row*32 + col
		return (bmp[i/8] >> uint(7-i%8)) & 1
	}
	holeFound := false
	for col := 0; col < 32; col++ {
		if bitAt(gotIcon, centerRow, col) != 0 {
			continue // black ring pixel, not the hole
		}
		if col > 10 && col < 21 { // interior hole, well away from the exterior border
			holeFound = true
			if bitAt(gotMask, centerRow, col) != 1 {
				t.Errorf("expected opaque mask bit at enclosed hole (row %d col %d)", centerRow, col)
			}
		}
	}
	if !holeFound {
		t.Fatalf("test fixture assumption broken: no white interior hole found in center row")
	}

	// A P4 (raw) encoding of the same bitmap must produce byte-identical
	// output to the P1 (ASCII) encoding.
	p4Path := filepath.Join(t.TempDir(), "icon_probe_p4.pbm")
	var p4 bytes.Buffer
	p4.WriteString("P4\n32 32\n")
	p4.Write(wantIcon)
	if err := os.WriteFile(p4Path, p4.Bytes(), 0o644); err != nil {
		t.Fatal(err)
	}
	p4Out, p4Exit := runPbm2Icn(t, bin, p4Path)
	if p4Exit != 0 {
		t.Fatalf("P4 variant: exit %d, want 0:\n%s", p4Exit, p4Out)
	}
	if p4Out != out {
		t.Fatalf("P4 output differs from P1 output for the same bitmap:\nP1: %s\nP4: %s", out, p4Out)
	}
}

func TestPbm2IcnErrors(t *testing.T) {
	bin := buildPbm2Icn(t)
	dir := t.TempDir()

	small := filepath.Join(dir, "small.pbm")
	if err := os.WriteFile(small, []byte("P1\n16 16\n"+strings.Repeat("0 ", 256)), 0o644); err != nil {
		t.Fatal(err)
	}
	if _, exit := runPbm2Icn(t, bin, small); exit != 1 {
		t.Errorf("16x16 PBM: exit %d, want 1", exit)
	}

	garbage := filepath.Join(dir, "garbage.pbm")
	if err := os.WriteFile(garbage, []byte("not a pbm file at all\n"), 0o644); err != nil {
		t.Fatal(err)
	}
	if _, exit := runPbm2Icn(t, bin, garbage); exit != 1 {
		t.Errorf("garbage file: exit %d, want 1", exit)
	}

	missing := filepath.Join(dir, "does-not-exist.pbm")
	if _, exit := runPbm2Icn(t, bin, missing); exit != 1 {
		t.Errorf("unreadable file: exit %d, want 1", exit)
	}
}
