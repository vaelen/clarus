// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// Package bake is the Go-side harness for clarusc's `--bake-ir` host mode
// (clarusc/bake.cla, runtime-ir-bake Task 3): running the mode against a
// current-source clarusc build, and parsing the resulting 'CLIR' artifact's
// header/section framing (magic, format version, lane tag, stamp, module
// manifest, section table) far enough to sanity-check it without decoding
// every section's own payload -- full decode is the future loader's job
// (Task 4). CorruptStampFixture generates a one-byte-flipped-stamp fixture
// on demand (not a committed binary blob, which would go stale the moment
// clarusc/clarusc.c is regenerated and the real stamp changes) for the
// loader-refusal test Task 4 adds.
package bake

import (
	"encoding/binary"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"testing"
)

// RepoRoot walks up from the test package's own directory (internal/bake
// is two levels below the repo root, matching internal/cg68k's own
// repoRoot helper).
func RepoRoot(t *testing.T) string {
	t.Helper()
	wd, err := os.Getwd()
	if err != nil {
		t.Fatalf("getwd: %v", err)
	}
	return filepath.Join(wd, "..", "..")
}

// Section is one parsed section header (id + length), with Offset pointing
// at its payload's first byte within the whole file.
type Section struct {
	ID     int
	Length int
	Offset int
}

// Header is the parsed CLIR header plus the section table (ids/lengths/
// offsets only -- payload content is a future loader's concern).
type Header struct {
	FormatVersion int
	Lane          int
	Stamp         []byte
	StampOffset   int // offset of Stamp's first byte within the file
	BodyHash      uint32
	BodyOffset    int // offset of the first body byte (everything BodyHash covers) within the file
	Modules       []string
	Sections      []Section
}

// ParseHeader parses data as a CLIR artifact per clarusc/bake.cla's format
// (magic 'CLIR' | formatVersion(4) | laneTag(1) | stampLen(2) | stamp |
// bodyHash(4) | moduleCount(2) | [keyLen(1) key]... | sectionCount(2) |
// [id(2) len(4) payload]...) -- bodyHash (format v4, final-review fix
// wave) is an FNV hash over everything from BodyOffset to the end of the
// file, the loader's own integrity check over bkCheckRtbakeHeader's
// counterpart in clarusc/bake.cla. Verifies the section table accounts
// for every remaining byte (a structural well-formedness check, not a
// section-content decode).
func ParseHeader(data []byte) (*Header, error) {
	pos := 0
	need := func(n int) error {
		if pos+n > len(data) {
			return fmt.Errorf("bake: truncated at offset %d, need %d more bytes, have %d", pos, n, len(data)-pos)
		}
		return nil
	}

	if err := need(4); err != nil {
		return nil, err
	}
	if string(data[pos:pos+4]) != "CLIR" {
		return nil, fmt.Errorf("bake: bad magic %q, want \"CLIR\"", data[pos:pos+4])
	}
	pos += 4

	if err := need(4); err != nil {
		return nil, err
	}
	formatVersion := int(binary.BigEndian.Uint32(data[pos:]))
	pos += 4

	if err := need(1); err != nil {
		return nil, err
	}
	lane := int(data[pos])
	pos++

	if err := need(2); err != nil {
		return nil, err
	}
	stampLen := int(binary.BigEndian.Uint16(data[pos:]))
	pos += 2
	if err := need(stampLen); err != nil {
		return nil, err
	}
	stampOffset := pos
	stamp := append([]byte(nil), data[pos:pos+stampLen]...)
	pos += stampLen

	if err := need(4); err != nil {
		return nil, err
	}
	bodyHash := binary.BigEndian.Uint32(data[pos:])
	pos += 4
	bodyOffset := pos

	if err := need(2); err != nil {
		return nil, err
	}
	moduleCount := int(binary.BigEndian.Uint16(data[pos:]))
	pos += 2
	modules := make([]string, 0, moduleCount)
	for i := 0; i < moduleCount; i++ {
		if err := need(1); err != nil {
			return nil, err
		}
		keyLen := int(data[pos])
		pos++
		if err := need(keyLen); err != nil {
			return nil, err
		}
		modules = append(modules, string(data[pos:pos+keyLen]))
		pos += keyLen
	}

	if err := need(2); err != nil {
		return nil, err
	}
	sectionCount := int(binary.BigEndian.Uint16(data[pos:]))
	pos += 2
	sections := make([]Section, 0, sectionCount)
	for i := 0; i < sectionCount; i++ {
		if err := need(6); err != nil {
			return nil, err
		}
		id := int(binary.BigEndian.Uint16(data[pos:]))
		pos += 2
		length := int(binary.BigEndian.Uint32(data[pos:]))
		pos += 4
		if err := need(length); err != nil {
			return nil, err
		}
		sections = append(sections, Section{ID: id, Length: length, Offset: pos})
		pos += length
	}

	if pos != len(data) {
		return nil, fmt.Errorf("bake: %d trailing bytes after the last section (consumed %d of %d)", len(data)-pos, pos, len(data))
	}

	return &Header{
		FormatVersion: formatVersion,
		Lane:          lane,
		Stamp:         stamp,
		StampOffset:   stampOffset,
		BodyHash:      bodyHash,
		BodyOffset:    bodyOffset,
		Modules:       modules,
		Sections:      sections,
	}, nil
}

// RunBakeIR runs `clarusc --bake-ir --lane LANE -o outPath` (exe from
// claruscboot.CurrentExe, run with cmd.Dir at the repo root so the
// default --rtdir search finds runtime/clarus/ the same way an ordinary
// `clarusc emit68k` invocation does) and returns the written bytes.
func RunBakeIR(t *testing.T, exe, lane, outPath string) []byte {
	t.Helper()
	cmd := exec.Command(exe, "--bake-ir", "--lane", lane, "-o", outPath)
	cmd.Dir = RepoRoot(t)
	if out, err := cmd.CombinedOutput(); err != nil {
		t.Fatalf("clarusc --bake-ir --lane %s: %v\n%s", lane, err, out)
	}
	data, err := os.ReadFile(outPath)
	if err != nil {
		t.Fatalf("read %s: %v", outPath, err)
	}
	return data
}

// CorruptStampFixture bakes a fresh valid lane artifact into dir, flips
// one bit of its stamp's first byte, writes the result to
// dir/corrupt-stamp-<lane>.clir, and returns that path. Task 4's loader-
// refusal test is expected to call this (not read a committed binary
// fixture, which would go stale the moment clarusc/clarusc.c is
// regenerated and the real stamp changes).
func CorruptStampFixture(t *testing.T, exe, lane, dir string) string {
	t.Helper()
	validPath := filepath.Join(dir, "valid-"+lane+".clir")
	data := RunBakeIR(t, exe, lane, validPath)

	hdr, err := ParseHeader(data)
	if err != nil {
		t.Fatalf("parse header of freshly-baked %s: %v", validPath, err)
	}
	if len(hdr.Stamp) == 0 {
		t.Fatalf("bake %s: empty stamp, cannot corrupt", lane)
	}

	corrupt := append([]byte(nil), data...)
	corrupt[hdr.StampOffset] ^= 0xFF

	corruptPath := filepath.Join(dir, "corrupt-stamp-"+lane+".clir")
	if err := os.WriteFile(corruptPath, corrupt, 0o644); err != nil {
		t.Fatalf("write %s: %v", corruptPath, err)
	}
	return corruptPath
}

// CorruptBodyFixture bakes a fresh valid lane artifact into dir, flips
// one bit of a byte PAST the header (inside the module manifest/section
// body bkCheckRtbakeHeader's format-v4 bodyHash now covers), writes the
// result to dir/corrupt-body-<lane>.clir, and returns that path -- the
// final-review fix wave's own loader-refusal test is expected to call
// this rather than read a committed binary fixture (same reasoning as
// CorruptStampFixture, above).
func CorruptBodyFixture(t *testing.T, exe, lane, dir string) string {
	t.Helper()
	validPath := filepath.Join(dir, "valid-body-"+lane+".clir")
	data := RunBakeIR(t, exe, lane, validPath)

	hdr, err := ParseHeader(data)
	if err != nil {
		t.Fatalf("parse header of freshly-baked %s: %v", validPath, err)
	}
	if hdr.BodyOffset >= len(data) {
		t.Fatalf("bake %s: empty body, cannot corrupt", lane)
	}

	corrupt := append([]byte(nil), data...)
	corrupt[hdr.BodyOffset] ^= 0xFF

	corruptPath := filepath.Join(dir, "corrupt-body-"+lane+".clir")
	if err := os.WriteFile(corruptPath, corrupt, 0o644); err != nil {
		t.Fatalf("write %s: %v", corruptPath, err)
	}
	return corruptPath
}

// CorruptObjCodeFixture bakes a 68k-lane artifact via clarusc's own
// undocumented `--bake-ir --corrupt-objcode-testonly` flag
// (clarusc/main.cla; same convention as emit68k's own `--seglimit`):
// bkWriteObjCode (clarusc/bake.cla) overwrites the first call-kind
// hole's reloc symbol with an impossibly large value BEFORE the real
// bkHashText computes the body hash, so the result is a structurally-
// valid bake whose body hash is genuinely correct for its own
// (corrupted) content -- unlike CorruptBodyFixture/CorruptStampFixture,
// which patch bytes in an already-written file. A Go-side byte patch
// plus a from-scratch FNV reimplementation was tried first and
// discarded: it could not be made to agree with the real compiled hash
// arithmetic reliably enough to trust as a test fixture, and disagreeing
// would make this test refuse via the WRONG check (body hash mismatch)
// instead of the one it exists to prove (bkObjRelocSymValid). Letting
// the real compiler compute its own hash removes that whole class of
// risk. Returns the written path.
func CorruptObjCodeFixture(t *testing.T, exe, dir string) string {
	t.Helper()
	outPath := filepath.Join(dir, "corrupt-objcode-68k.clir")
	cmd := exec.Command(exe, "--bake-ir", "--lane", "68k", "--corrupt-objcode-testonly", "-o", outPath)
	cmd.Dir = RepoRoot(t)
	if out, err := cmd.CombinedOutput(); err != nil {
		t.Fatalf("clarusc --bake-ir --lane 68k --corrupt-objcode-testonly: %v\n%s", err, out)
	}
	return outPath
}
