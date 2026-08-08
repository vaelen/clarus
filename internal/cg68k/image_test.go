// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// image_test.go: native-5d Task 10's structural gate for app68k.cla's
// output. Builds clarusc (buildClarusc, shared with golden_test.go),
// runs `clarusc emit68k -o out.bin <fixture>`, and parses the resulting
// .bin from scratch in Go -- an INDEPENDENT reader, not a port of
// app68k.cla's writer, mirroring how Retro68's own ResourceFile.cc /
// ResourceFork.cc read a MacBinary+resource-fork file back. Also pins
// determinism: emitting the same fixture twice, in two different temp
// dirs, must produce byte-identical .bin files (clarusc has no clock
// access on this backend and app68k.cla's MacBinary dates are a fixed
// constant -- see clarusc/app68k.cla's own file header comment).
package cg68k

import (
	"encoding/binary"
	"os"
	"os/exec"
	"path/filepath"
	"testing"
)

// crc16Xmodem is an INDEPENDENT CRC-16/XMODEM implementation (poly
// 0x1021, init 0, MSB-first, no reflection, no final XOR) -- written
// fresh against the standard algorithm, not copied from
// clarusc/app68k.cla's app68Crc16. Verified against the standard test
// vector below (TestCrc16XmodemVector).
func crc16Xmodem(data []byte) uint16 {
	var crc uint16
	for _, b := range data {
		crc ^= uint16(b) << 8
		for i := 0; i < 8; i++ {
			if crc&0x8000 != 0 {
				crc = (crc << 1) ^ 0x1021
			} else {
				crc <<= 1
			}
		}
	}
	return crc
}

func TestCrc16XmodemVector(t *testing.T) {
	got := crc16Xmodem([]byte("123456789"))
	if got != 0x31C3 {
		t.Fatalf("crc16Xmodem(\"123456789\") = %#04x, want 0x31c3 (standard CRC-16/XMODEM test vector)", got)
	}
}

// resEntry is one parsed resource: its 4-char type, numeric ID, resource-
// map name (""  if unnamed -- Task 5 mac-resident-clarusc), and raw data
// bytes.
type resEntry struct {
	typ  string
	id   int16
	name string
	data []byte
}

// parseResourceFork parses a raw (unpadded) resource fork -- the same
// format Retro68's ResourceFork.cc::Resources(istream&) reads -- into
// its resource list. Independent of app68k.cla's own fixed 2-type/3-
// resource layout: walks the real type list/ref list/data-offset chain
// generically, so it doesn't just mirror app68k.cla's own hardcoded
// offsets back at it. Task 5 (mac-resident-clarusc) additionally decodes
// each entry's name from the name list (Inside Macintosh resource-map
// layout: ref-list entry's 2-byte name-offset field is 0xFFFF if unnamed,
// else an offset from the name list's own start to a Pascal string --
// length byte + bytes).
func parseResourceFork(t *testing.T, fork []byte) (dataOff, mapOff, dataLen, mapLen uint32, entries []resEntry) {
	t.Helper()
	if len(fork) < 16 {
		t.Fatalf("resource fork too short: %d bytes", len(fork))
	}
	dataOff = binary.BigEndian.Uint32(fork[0:4])
	mapOff = binary.BigEndian.Uint32(fork[4:8])
	dataLen = binary.BigEndian.Uint32(fork[8:12])
	mapLen = binary.BigEndian.Uint32(fork[12:16])

	if dataOff != 256 {
		t.Errorf("resource fork data offset = %d, want 256", dataOff)
	}
	if mapOff != dataOff+dataLen {
		t.Errorf("resource fork map offset = %d, want dataOffset+dataLength = %d", mapOff, dataOff+dataLen)
	}
	if int(mapOff+mapLen) != len(fork) {
		t.Errorf("resource fork map end (%d) != fork length (%d)", mapOff+mapLen, len(fork))
	}

	m := fork[mapOff:]
	if len(m) < 30 {
		t.Fatalf("resource map too short: %d bytes", len(m))
	}
	typeListOff := binary.BigEndian.Uint16(m[24:26])
	nameListOff := binary.BigEndian.Uint16(m[26:28])
	nl := m[nameListOff:]
	tl := m[typeListOff:]
	numTypes := int(binary.BigEndian.Uint16(tl[0:2])) + 1

	anyNamed := false
	for ti := 0; ti < numTypes; ti++ {
		th := tl[2+ti*8:]
		typ := string(th[0:4])
		count := int(binary.BigEndian.Uint16(th[4:6])) + 1
		refListOff := binary.BigEndian.Uint16(th[6:8])
		rl := tl[refListOff:]
		for ri := 0; ri < count; ri++ {
			re := rl[ri*12:]
			id := int16(binary.BigEndian.Uint16(re[0:2]))
			name := ""
			if nameOff := binary.BigEndian.Uint16(re[2:4]); nameOff != 0xFFFF {
				anyNamed = true
				nameLen := int(nl[nameOff])
				name = string(nl[int(nameOff)+1 : int(nameOff)+1+nameLen])
			}
			packed := binary.BigEndian.Uint32(re[4:8])
			attr := byte(packed >> 24)
			off := packed & 0x00FFFFFF
			if attr != 0 {
				t.Errorf("resource %s %d: attr byte = %#x, want 0", typ, id, attr)
			}
			data := fork[dataOff:]
			resLen := binary.BigEndian.Uint32(data[off : off+4])
			resData := data[off+4 : off+4+resLen]
			entries = append(entries, resEntry{typ: typ, id: id, name: name, data: resData})
		}
	}
	// TestImageStructure/TestSegment... (this package's only two callers)
	// build fixtures with no --bake flag, so no resource is ever named --
	// the name list stays empty and sits right at the map's own end.
	if !anyNamed && nameListOff != uint16(mapLen) {
		t.Errorf("resource map name list offset = %d, want %d (map length -- no names, so the name list is empty and sits right at the end)", nameListOff, mapLen)
	}
	return
}

// buildImage runs `clarusc emit68k -o out.bin <fixture>` in dir and
// returns the emitted bytes.
func buildImage(t *testing.T, exe, fixture, dir string) []byte {
	t.Helper()
	outBin := filepath.Join(dir, "out.bin")
	cmd := exec.Command(exe, "emit68k", "-o", outBin, fixture)
	if out, err := cmd.CombinedOutput(); err != nil {
		t.Fatalf("clarusc emit68k -o %s %s: %v\n%s", outBin, fixture, err, out)
	}
	got, err := os.ReadFile(outBin)
	if err != nil {
		t.Fatalf("read %s: %v", outBin, err)
	}
	return got
}

// TestImageStructure parses globals.cla's emitted .bin end to end:
// MacBinary header fields (name/type/creator/fork lengths/version bytes/
// CRC), resource fork self-consistency, CODE 0's jump-table entries
// (segment number, trailer word, and that every entry's offset lands
// inside CODE 1's own code range), and SIZE(-1)'s exact payload.
func TestImageStructure(t *testing.T) {
	root := repoRoot(t)
	exe := buildClarusc(t)
	fixture := filepath.Join(root, "testdata", "cg68k", "globals.cla")

	img := buildImage(t, exe, fixture, t.TempDir())

	if len(img) < 128 {
		t.Fatalf("image too short: %d bytes", len(img))
	}
	if len(img)%128 != 0 {
		t.Errorf("image length %d is not a multiple of 128", len(img))
	}

	h := img[:128]

	// -- MacBinary header --
	if h[0] != 0 {
		t.Errorf("header[0] (version byte) = %d, want 0", h[0])
	}
	nameLen := int(h[1])
	if nameLen == 0 || nameLen > 63 {
		t.Fatalf("header[1] (name length) = %d, out of range", nameLen)
	}
	name := string(h[2 : 2+nameLen])
	if name != "out" {
		t.Errorf("app name = %q, want %q (derived from the -o path's own base name, cgAppName)", name, "out")
	}
	if typ := string(h[65:69]); typ != "APPL" {
		t.Errorf("file type = %q, want APPL", typ)
	}
	if creator := string(h[69:73]); creator != "????" {
		t.Errorf("creator = %q, want ????", creator)
	}
	dataForkLen := binary.BigEndian.Uint32(h[83:87])
	if dataForkLen != 0 {
		t.Errorf("data fork length = %d, want 0", dataForkLen)
	}
	rsrcForkLen := binary.BigEndian.Uint32(h[87:91])
	creation := binary.BigEndian.Uint32(h[91:95])
	modification := binary.BigEndian.Uint32(h[95:99])
	if creation != 0 || modification != 0 {
		t.Errorf("creation/modification dates = %d/%d, want 0/0 (fixed, no clock access)", creation, modification)
	}
	if h[122] != 129 || h[123] != 129 {
		t.Errorf("MacBinary version bytes = %d/%d, want 129/129", h[122], h[123])
	}
	wantCRC := crc16Xmodem(h[:124])
	gotCRC := binary.BigEndian.Uint16(h[124:126])
	if gotCRC != wantCRC {
		t.Errorf("header CRC = %#04x, want %#04x (independent CRC-16/XMODEM over bytes 0-123)", gotCRC, wantCRC)
	}

	// The resource fork occupies the rest of the (128-padded) image;
	// rsrcForkLen is the RAW (unpadded) length recorded in the header.
	fork := img[128:]
	if int(rsrcForkLen) > len(fork) {
		t.Fatalf("resource fork length %d exceeds remaining image bytes %d", rsrcForkLen, len(fork))
	}
	fork = fork[:rsrcForkLen]
	// Every byte from 128+rsrcForkLen to the end of the (128-padded) file
	// must be zero padding.
	for i := 128 + int(rsrcForkLen); i < len(img); i++ {
		if img[i] != 0 {
			t.Fatalf("non-zero padding byte at image offset %d", i)
			break
		}
	}

	_, _, _, _, entries := parseResourceFork(t, fork)

	var code0, code1, sizeRes []byte
	codeCount := 0
	sizeCount := 0
	for _, e := range entries {
		switch e.typ {
		case "CODE":
			codeCount++
			if e.id == 0 {
				code0 = e.data
			} else if e.id == 1 {
				code1 = e.data
			} else {
				t.Errorf("unexpected CODE id %d", e.id)
			}
		case "SIZE":
			sizeCount++
			if e.id != -1 {
				t.Errorf("SIZE resource id = %d, want -1", e.id)
			}
			sizeRes = e.data
		default:
			t.Errorf("unexpected resource type %q", e.typ)
		}
	}
	if codeCount != 2 {
		t.Fatalf("found %d CODE resources, want 2", codeCount)
	}
	if sizeCount != 1 {
		t.Fatalf("found %d SIZE resources, want 1", sizeCount)
	}
	if code0 == nil || code1 == nil || sizeRes == nil {
		t.Fatal("missing CODE 0, CODE 1, or SIZE(-1)")
	}

	// -- SIZE(-1) --
	if len(sizeRes) != 10 {
		t.Fatalf("SIZE resource length = %d, want 10", len(sizeRes))
	}
	flags := binary.BigEndian.Uint16(sizeRes[0:2])
	if flags != 0x0080 {
		t.Errorf("SIZE flags = %#04x, want 0x0080 (is32BitCompatible only)", flags)
	}
	preferred := binary.BigEndian.Uint32(sizeRes[2:6])
	minimum := binary.BigEndian.Uint32(sizeRes[6:10])
	if preferred != 393216 || minimum != 393216 {
		t.Errorf("SIZE preferred/minimum = %d/%d, want 393216/393216 (384KB)", preferred, minimum)
	}

	// -- CODE 1 header + raw code range --
	if len(code1) < 4 {
		t.Fatalf("CODE 1 length = %d, too short for its 4-byte header", len(code1))
	}
	firstEntryOff := binary.BigEndian.Uint16(code1[0:2])
	entryCount := binary.BigEndian.Uint16(code1[2:4])
	if firstEntryOff != 0 {
		t.Errorf("CODE 1 first-JT-entry offset = %d, want 0 (single segment)", firstEntryOff)
	}
	code1RawLen := len(code1) - 4

	// -- CODE 0: A5-world header + jump table --
	if len(code0) < 16 {
		t.Fatalf("CODE 0 length = %d, too short for its 16-byte header", len(code0))
	}
	aboveA5 := binary.BigEndian.Uint32(code0[0:4])
	belowA5 := binary.BigEndian.Uint32(code0[4:8])
	jtLen := binary.BigEndian.Uint32(code0[8:12])
	jtOff := binary.BigEndian.Uint32(code0[12:16])
	if jtOff != 32 {
		t.Errorf("CODE 0 JT offset from A5 = %d, want 32", jtOff)
	}
	if jtLen%8 != 0 {
		t.Fatalf("CODE 0 JT length = %d, not a multiple of 8", jtLen)
	}
	nEntries := int(jtLen / 8)
	if uint32(nEntries) != uint32(entryCount) {
		t.Errorf("CODE 0 JT entry count (%d) != CODE 1 header's own count (%d)", nEntries, entryCount)
	}
	if belowA5 == 0 {
		// globals.cla declares two below-A5 globals (an int and a
		// string(255)) -- belowA5 must reflect real, nonzero storage.
		t.Errorf("CODE 0 below-A5 size = 0, want > 0 (globals.cla declares globals)")
	}
	if aboveA5 != 32+jtLen {
		t.Errorf("CODE 0 above-A5 size = %d, want 32+jtLen = %d", aboveA5, 32+jtLen)
	}
	if nEntries == 0 {
		t.Fatal("CODE 0 has no jump-table entries")
	}
	jt := code0[16:]
	for i := 0; i < nEntries; i++ {
		e := jt[i*8:]
		off := binary.BigEndian.Uint16(e[0:2])
		filler := binary.BigEndian.Uint16(e[2:4])
		seg := binary.BigEndian.Uint16(e[4:6])
		trailer := binary.BigEndian.Uint16(e[6:8])
		if filler != 0x3F3C {
			t.Errorf("JT entry %d: filler word = %#04x, want 0x3F3C", i, filler)
		}
		if seg != 1 {
			t.Errorf("JT entry %d: segment number = %d, want 1", i, seg)
		}
		if trailer != 0xA9F0 {
			t.Errorf("JT entry %d: trailer word = %#04x, want 0xA9F0", i, trailer)
		}
		// The entry's own offset field is the routine's offset from the
		// first byte of CODE 1's *code* -- _LoadSeg skips the segment's own
		// 4-byte header itself, so nothing may be added here. It must land
		// inside CODE 1's actual code bytes.
		if int(off) > code1RawLen {
			t.Errorf("JT entry %d: offset %d out of CODE 1's code range [0, %d]", i, off, code1RawLen)
		}
	}
	// JT entry 0 is the synthesized startup routine, and it's always the
	// very first thing emitted into the stream (cgEmitStartup runs before
	// any reachable function's own body) -- so its offset must be exactly
	// 0. This is the entry point the Segment Loader jumps to: a stray +4
	// here enters startup one instruction late, past its
	// `LEA -belowA5(A5),A0`, so the below-A5 zero loop runs with a garbage
	// A0 (globals never zeroed, 292 bytes of wild writes). That was the
	// native-5d Task 11 first-boot blocker; Elf2Mac writes this same entry
	// as literally `0000 3F3C 0001 A9F0` (Object.cc:265).
	if off0 := binary.BigEndian.Uint16(jt[0:2]); off0 != 0 {
		t.Errorf("JT entry 0 (startup, JT slot 0) offset = %d, want 0", off0)
	}
}

// TestImageDeterminism emits globals.cla's .bin twice, into two different
// temp dirs, and requires the bytes to be byte-identical -- app68k.cla
// has no clock access and uses a fixed MacBinary date constant (see its
// own file header comment), so nothing should vary between runs.
func TestImageDeterminism(t *testing.T) {
	root := repoRoot(t)
	exe := buildClarusc(t)
	fixture := filepath.Join(root, "testdata", "cg68k", "globals.cla")

	a := buildImage(t, exe, fixture, t.TempDir())
	b := buildImage(t, exe, fixture, t.TempDir())

	if len(a) != len(b) {
		t.Fatalf("emitted image lengths differ: %d vs %d", len(a), len(b))
	}
	for i := range a {
		if a[i] != b[i] {
			t.Fatalf("emitted images differ at byte offset %d: %#02x vs %#02x", i, a[i], b[i])
		}
	}
}
