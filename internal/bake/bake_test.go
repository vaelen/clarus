// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

package bake

import (
	"bytes"
	"os"
	"path/filepath"
	"testing"

	"clarus/internal/claruscboot"
)

// wantModuleCounts mirrors clarusc/bake.cla's bakeModuleList: 18 modules
// for the 68k lane (17 shared + native.cla), 17 for the c lane (same 17,
// no native.cla -- native.cla is 68k-only Toolbox-trap glue with no C
// runtime under it at all).
var wantModuleCounts = map[string]int{"68k": 18, "c": 17}
var wantLaneTag = map[string]int{"68k": 0, "c": 1}

// TestBakeTwiceIdentical asserts bake-twice-byte-identical (the design
// spec's own "Bake determinism gets its own check" success criterion),
// for both lanes.
func TestBakeTwiceIdentical(t *testing.T) {
	exe := claruscboot.CurrentExe(t)
	for _, lane := range []string{"68k", "c"} {
		lane := lane
		t.Run(lane, func(t *testing.T) {
			dir := t.TempDir()
			a := RunBakeIR(t, exe, lane, filepath.Join(dir, "a.clir"))
			b := RunBakeIR(t, exe, lane, filepath.Join(dir, "b.clir"))
			if !bytes.Equal(a, b) {
				t.Fatalf("bake --lane %s not deterministic: %d bytes vs %d bytes differ", lane, len(a), len(b))
			}
		})
	}
}

// TestBakeHeaderSanity parses each lane's artifact and checks the fixed
// header fields (magic, format version, lane tag, non-empty stamp,
// per-lane module count) plus that the section table accounts for every
// byte in the file (ParseHeader's own trailing-byte check) and carries
// the expected section count (clarusc/bake.cla's bkSectionCount).
func TestBakeHeaderSanity(t *testing.T) {
	exe := claruscboot.CurrentExe(t)
	for _, lane := range []string{"68k", "c"} {
		lane := lane
		t.Run(lane, func(t *testing.T) {
			dir := t.TempDir()
			data := RunBakeIR(t, exe, lane, filepath.Join(dir, "out.clir"))

			hdr, err := ParseHeader(data)
			if err != nil {
				t.Fatalf("ParseHeader: %v", err)
			}
			if hdr.FormatVersion != 6 {
				t.Errorf("FormatVersion = %d, want 6 (object-code-linker Task 2: bkSecObjCode + bkSecObjMeta added)", hdr.FormatVersion)
			}
			if hdr.Lane != wantLaneTag[lane] {
				t.Errorf("Lane = %d, want %d", hdr.Lane, wantLaneTag[lane])
			}
			if len(hdr.Stamp) == 0 {
				t.Error("Stamp is empty, want a non-empty compiler-identity hash")
			}
			if len(hdr.Modules) != wantModuleCounts[lane] {
				t.Errorf("len(Modules) = %d, want %d\nmodules: %v", len(hdr.Modules), wantModuleCounts[lane], hdr.Modules)
			}
			if len(hdr.Sections) != 46 {
				t.Errorf("len(Sections) = %d, want 46 (bkSectionCount, object-code-linker Task 2: +bkSecObjCode +bkSecObjMeta)", len(hdr.Sections))
			}
			// Every module key follows rtModuleKey's "runtime/clarus/NAME"
			// scheme (drive.cla:532), and native.cla is present iff 68k.
			haveNative := false
			for _, m := range hdr.Modules {
				if m == "runtime/clarus/native.cla" {
					haveNative = true
				}
				if filepath.Dir(m) != "runtime/clarus" {
					t.Errorf("module key %q not under runtime/clarus/", m)
				}
			}
			wantNative := lane == "68k"
			if haveNative != wantNative {
				t.Errorf("native.cla present = %v, want %v (lane %s)", haveNative, wantNative, lane)
			}
		})
	}
}

// TestBakeHeaderBodyHashMasked pins the Snow bake-path fix wave's own
// symptom shut (2026-08-13, snow-failure-rca.md): bkHashTextFrom
// (clarusc/bake.cla) always ends its loop with `h = h & 0x7FFFFFFF`, so a
// correctly-computed body hash can never have bit 31 set. Before the fix,
// cprint.cla's fpBin emitted the FNV multiply as plain signed `int32_t *`,
// which is signed-overflow UB that clang -O1+ used to prove (wrongly, for
// this program) that the following mask was dead code and delete it --
// so a HOST-written header carried the raw unmasked 32-bit FNV instead,
// differing from the masked value a real 68k AND.L always computes,
// which is exactly what made the Mac refuse the artifact. This is a
// direct, lane-independent proxy for that acceptance check: it doesn't
// need real 68k hardware to prove bit 31 is clear, only that the HOST
// writer itself, which computes and re-verifies its own bodyHash in the
// same process (see clarusc/bake.cla's bkCheckRtbakeHeader doc comment on
// why the host lane was structurally blind to this), now emits a value
// that the mask could actually have produced.
func TestBakeHeaderBodyHashMasked(t *testing.T) {
	exe := claruscboot.CurrentExe(t)
	for _, lane := range []string{"68k", "c"} {
		lane := lane
		t.Run(lane, func(t *testing.T) {
			dir := t.TempDir()
			data := RunBakeIR(t, exe, lane, filepath.Join(dir, "out.clir"))

			hdr, err := ParseHeader(data)
			if err != nil {
				t.Fatalf("ParseHeader: %v", err)
			}
			if hdr.BodyHash&0x80000000 != 0 {
				t.Errorf("BodyHash = 0x%08x has bit 31 set; bkHashTextFrom's `& 0x7FFFFFFF` mask cannot produce this value -- signed-overflow UB regression (snow-failure-rca.md)", hdr.BodyHash)
			}
		})
	}
}

// TestBakeCorruptStampFixture proves CorruptStampFixture actually
// corrupts the stamp (and nothing else the header cares about): the
// corrupt file still parses structurally (ParseHeader succeeds -- only
// the STAMP VALUE changed, not the framing), but its Stamp bytes differ
// from the valid bake's. Task 4's own loader-refusal test is expected to
// call CorruptStampFixture directly rather than read a committed binary
// blob (see CorruptStampFixture's own doc comment for why).
func TestBakeCorruptStampFixture(t *testing.T) {
	exe := claruscboot.CurrentExe(t)
	dir := t.TempDir()

	corruptPath := CorruptStampFixture(t, exe, "68k", dir)
	validData, err := os.ReadFile(filepath.Join(dir, "valid-68k.clir"))
	if err != nil {
		t.Fatalf("read valid-68k.clir (written by CorruptStampFixture): %v", err)
	}
	validHdr, err := ParseHeader(validData)
	if err != nil {
		t.Fatalf("ParseHeader(valid): %v", err)
	}

	corruptData, err := os.ReadFile(corruptPath)
	if err != nil {
		t.Fatalf("read %s: %v", corruptPath, err)
	}
	corruptHdr, err := ParseHeader(corruptData)
	if err != nil {
		t.Fatalf("ParseHeader(corrupt): %v -- a corrupted STAMP byte must not break the file's structural framing", err)
	}

	if bytes.Equal(validHdr.Stamp, corruptHdr.Stamp) {
		t.Fatal("corrupt fixture's stamp equals the valid bake's stamp; corruption did not take effect")
	}
	if len(validData) != len(corruptData) {
		t.Fatalf("corrupt fixture length %d != valid bake length %d; corruption should only flip one byte in place", len(corruptData), len(validData))
	}
	diffs := 0
	for i := range validData {
		if validData[i] != corruptData[i] {
			diffs++
		}
	}
	if diffs != 1 {
		t.Fatalf("corrupt fixture differs from the valid bake in %d bytes, want exactly 1", diffs)
	}
}
