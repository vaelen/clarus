// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// resparity_test.go: native-5e Task 13's resource-parity golden test.
// TestApp68kResourceParity builds the two probe fixtures (testdata/ui/
// appres.cla -- app section WITH a declared icon; testdata/ui/about.cla --
// app section with NO icon) via `clarusc emit68k` (no Retro68, no cmake,
// no emulator -- clarusc's own native writer, clarusc/app68k.cla +
// res68k.cla), parses the resulting .bin's resource fork from scratch in
// Go, and byte-compares the ALRT/DITL/vers/signature-STR/FREF/BNDL/ICN#/
// ICON resources it finds against testdata/mac/resparity/*.bin -- pinned,
// once, from a REAL Retro68 build of the SAME two fixtures (`scripts/
// build-mac.sh testdata/ui/{appres,about}.cla --test`, resource fork
// parsed and each resource's raw data dumped to those goldens; the
// extraction script/procedure is recorded in this task's own report, not
// checked in -- the goldens themselves are the durable artifact).
//
// These goldens are FROZEN the same way testdata/ui/*.trace and
// testdata/uisnaps/*.pbm are (plan's "Golden policy (ratified)"): any
// divergence here is a real app68k/res68k regression, not something to
// re-bless casually -- re-extracting them requires the Retro68 toolchain
// (gated CLARUS_MAC_TESTS, `TestAppResResources`'s own build already
// exercises that path) and a fresh byte-for-byte re-dump.
package mactest

import (
	"bytes"
	"encoding/binary"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
)

// resparEntry is one parsed resource: 4-char type, numeric id, raw data,
// and its resource-map name (""  if unnamed -- name-list offset 0xFFFF,
// Task 5 mac-resident-clarusc). An independent reader, not a port of
// app68k.cla's own writer -- mirrors internal/cg68k/image_test.go's
// parseResourceFork (a different Go package, so not directly importable;
// duplicated here deliberately rather than exported cross-package for one
// extra caller, same call this repo's other near-duplicate test helpers
// already made).
type resparEntry struct {
	typ  string
	id   int16
	name string
	data []byte
}

// resparParseFork walks a raw (unpadded) resource fork's type list/ref
// list/data-offset chain generically -- see internal/cg68k/image_test.go's
// parseResourceFork for the format documentation (Retro68's own
// ResourceFork.cc::Resources(istream&) layout). Task 5 (mac-resident-
// clarusc) additionally decodes each entry's name, per Inside Macintosh's
// resource-map name-list layout: the ref-list entry's 2-byte name-offset
// field is either 0xFFFF (unnamed) or an offset, from the name list's own
// start (map-start-relative nameListOff, map header offset 26), to a
// Pascal string (length byte + bytes).
func resparParseFork(t *testing.T, fork []byte) []resparEntry {
	t.Helper()
	if len(fork) < 16 {
		t.Fatalf("resource fork too short: %d bytes", len(fork))
	}
	dataOff := binary.BigEndian.Uint32(fork[0:4])
	mapOff := binary.BigEndian.Uint32(fork[4:8])

	m := fork[mapOff:]
	typeListOff := binary.BigEndian.Uint16(m[24:26])
	nameListOff := binary.BigEndian.Uint16(m[26:28])
	nl := m[nameListOff:]
	tl := m[typeListOff:]
	numTypes := int(binary.BigEndian.Uint16(tl[0:2])) + 1

	var entries []resparEntry
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
				nameLen := int(nl[nameOff])
				name = string(nl[int(nameOff)+1 : int(nameOff)+1+nameLen])
			}
			packed := binary.BigEndian.Uint32(re[4:8])
			off := packed & 0x00FFFFFF
			data := fork[dataOff:]
			resLen := binary.BigEndian.Uint32(data[off : off+4])
			resData := data[off+4 : off+4+resLen]
			entries = append(entries, resparEntry{typ: typ, id: id, name: name, data: resData})
		}
	}
	return entries
}

// resparBuildAndParse runs `clarusc emit68k -o out.bin <fixture>` (via the
// memoized buildNativeClarusc, native_test.go) and returns the emitted
// MacBinary header's creator field plus every parsed resource fork entry.
func resparBuildAndParse(t *testing.T, fixture string) (creator string, entries []resparEntry) {
	t.Helper()
	exe := buildNativeClarusc(t)
	bin := filepath.Join(t.TempDir(), "out.bin")
	cmd := exec.Command(exe, "emit68k", "-o", bin, "--rtdir", filepath.Join(repoRoot(t), "runtime", "clarus"), fixture)
	if out, err := cmd.CombinedOutput(); err != nil {
		t.Fatalf("clarusc emit68k -o %s %s: %v\n%s", bin, fixture, err, out)
	}
	img, err := os.ReadFile(bin)
	if err != nil {
		t.Fatalf("read %s: %v", bin, err)
	}
	if len(img) < 128 {
		t.Fatalf("image too short: %d bytes", len(img))
	}
	h := img[:128]
	creator = string(h[69:73])
	rsrcForkLen := binary.BigEndian.Uint32(h[87:91])
	fork := img[128:]
	if int(rsrcForkLen) > len(fork) {
		t.Fatalf("resource fork length %d exceeds remaining image bytes %d", rsrcForkLen, len(fork))
	}
	fork = fork[:rsrcForkLen]
	entries = resparParseFork(t, fork)
	return creator, entries
}

// resparFind returns the single entry matching typ/id, failing the test
// if it's missing or duplicated.
func resparFind(t *testing.T, entries []resparEntry, typ string, id int16) []byte {
	t.Helper()
	var found []byte
	n := 0
	for _, e := range entries {
		if e.typ == typ && e.id == id {
			found = e.data
			n++
		}
	}
	if n == 0 {
		t.Fatalf("resource %s %d not found", typ, id)
	}
	if n > 1 {
		t.Fatalf("resource %s %d found %d times, want 1", typ, id, n)
	}
	return found
}

// resparGolden reads testdata/mac/resparity/<name>.bin.
func resparGolden(t *testing.T, name string) []byte {
	t.Helper()
	p := filepath.Join(repoRoot(t), "testdata", "mac", "resparity", name+".bin")
	b, err := os.ReadFile(p)
	if err != nil {
		t.Fatalf("reading golden %s: %v", p, err)
	}
	return b
}

// resparCheck byte-compares entries's (typ,id) resource against the
// pinned golden <prefix>_<name>.bin.
func resparCheck(t *testing.T, entries []resparEntry, typ string, id int16, prefix, name string) {
	t.Helper()
	got := resparFind(t, entries, typ, id)
	want := resparGolden(t, prefix+"_"+name)
	if !bytes.Equal(got, want) {
		t.Errorf("%s %s %d: mismatch against golden %s_%s.bin\n got  %X\nwant %X", prefix, typ, id, prefix, name, got, want)
	}
}

// TestApp68kResourceParity is Task 13's own end gate: no emulator, no
// Retro68, no cmake -- just `clarusc emit68k` plus an independent Go
// resource-fork reader, byte-compared against goldens pinned from a real
// Retro68 build (see this file's own header comment).
func TestApp68kResourceParity(t *testing.T) {
	root := repoRoot(t)

	t.Run("appres_icon", func(t *testing.T) {
		fixture := filepath.Join(root, "testdata", "ui", "appres.cla")
		creator, entries := resparBuildAndParse(t, fixture)

		if creator != "PRBR" {
			t.Errorf("creator = %q, want %q (appres.cla declares id: \"PRBR\")", creator, "PRBR")
		}

		resparCheck(t, entries, "ALRT", 128, "appres", "ALRT_128")
		resparCheck(t, entries, "DITL", 128, "appres", "DITL_128")
		resparCheck(t, entries, "ALRT", 129, "appres", "ALRT_129")
		resparCheck(t, entries, "DITL", 129, "appres", "DITL_129") // 5-item variant: has the Icon item
		resparCheck(t, entries, "ALRT", 130, "appres", "ALRT_130")
		resparCheck(t, entries, "DITL", 130, "appres", "DITL_130")
		resparCheck(t, entries, "vers", 1, "appres", "vers_1")
		resparCheck(t, entries, "PRBR", 0, "appres", "PRBR_0")
		resparCheck(t, entries, "FREF", 128, "appres", "FREF_128")
		resparCheck(t, entries, "FREF", 129, "appres", "FREF_129")
		resparCheck(t, entries, "BNDL", 128, "appres", "BNDL_128")
		resparCheck(t, entries, "ICN#", 128, "appres", "ICN#_128")
		resparCheck(t, entries, "ICON", 128, "appres", "ICON_128")
		resparCheck(t, entries, "ICN#", 129, "appres", "ICN#_129")
		resparCheck(t, entries, "ICON", 129, "appres", "ICON_129")

		// SIZE(-1): only the FLAG WORD is required to match Rez's output
		// (isHighLevelEventAware set, since appres.cla declares an app
		// section) -- the two size longs are this backend's own tuning
		// choice, not a Rez byte-for-byte target (app68k.cla's own
		// app68BuildSize doc comment explains why).
		size := resparFind(t, entries, "SIZE", -1)
		if len(size) != 10 {
			t.Fatalf("SIZE resource length = %d, want 10", len(size))
		}
		if flags := binary.BigEndian.Uint16(size[0:2]); flags != 0x00C0 {
			t.Errorf("SIZE flags = %#04x, want 0x00C0 (is32BitCompatible|isHighLevelEventAware)", flags)
		}
	})

	t.Run("about_noicon", func(t *testing.T) {
		fixture := filepath.Join(root, "testdata", "ui", "about.cla")
		creator, entries := resparBuildAndParse(t, fixture)

		if creator != "PRBA" {
			t.Errorf("creator = %q, want %q (about.cla declares id: \"PRBA\")", creator, "PRBA")
		}

		resparCheck(t, entries, "ALRT", 128, "about", "ALRT_128")
		resparCheck(t, entries, "DITL", 128, "about", "DITL_128")
		resparCheck(t, entries, "ALRT", 129, "about", "ALRT_129")
		resparCheck(t, entries, "DITL", 129, "about", "DITL_129") // 4-item variant: no icon declared
		resparCheck(t, entries, "ALRT", 130, "about", "ALRT_130")
		resparCheck(t, entries, "DITL", 130, "about", "DITL_130")
		resparCheck(t, entries, "vers", 1, "about", "vers_1")

		// about.cla declares no icon: no signature STR/FREF/BNDL/ICN#/ICON
		// family at all.
		for _, typ := range []string{"FREF", "BNDL", "ICN#", "ICON"} {
			for _, e := range entries {
				if e.typ == typ {
					t.Errorf("unexpected %s resource (id %d): about.cla declares no icon", typ, e.id)
				}
			}
		}

		size := resparFind(t, entries, "SIZE", -1)
		if flags := binary.BigEndian.Uint16(size[0:2]); flags != 0x00C0 {
			t.Errorf("SIZE flags = %#04x, want 0x00C0 (is32BitCompatible|isHighLevelEventAware)", flags)
		}
	})
}

// TestApp68kIconMissingWarns is attempt-abort Task 7's own host-side gate
// (spec %6): cg68ResourceParitySet's icon block used to `quit 1` on a
// missing/malformed icon file; it now warns on both channels and falls
// back to hasIcon=false, exactly the path an icon-less program already
// takes. No emulator, no Retro68 -- `clarusc emit68k` plus a plain byte
// compare, same no-emulator discipline as TestApp68kResourceParity above
// (the least-novel home for this check: this file already builds+parses
// icon-related emit68k output for the two adjacent fixtures).
func TestApp68kIconMissingWarns(t *testing.T) {
	root := repoRoot(t)
	exe := buildNativeClarusc(t)
	rtDir := filepath.Join(root, "runtime", "clarus")
	fixture := filepath.Join(root, "testdata", "ui", "iconmissing.cla")

	src, err := os.ReadFile(fixture)
	if err != nil {
		t.Fatalf("reading %s: %v", fixture, err)
	}

	// Compile the fixture as-is (declares a nonexistent icon path) and its
	// icon-stripped twin (every `icon:` line removed) into SEPARATELY
	// named work dirs sharing the SAME -o basename ("out.bin") -- the
	// MacBinary header's own filename field mirrors -o's basename, so two
	// different -o names would make an otherwise byte-identical fork
	// differ at byte 2 for a reason that has nothing to do with the icon
	// fallback (confirmed empirically while writing this test).
	withIconDir := t.TempDir()
	strippedDir := t.TempDir()
	withIconSrc := filepath.Join(withIconDir, "iconmissing.cla")
	strippedSrc := filepath.Join(strippedDir, "iconmissing.cla")
	if err := os.WriteFile(withIconSrc, src, 0o644); err != nil {
		t.Fatal(err)
	}
	var stripped []byte
	for _, line := range strings.Split(string(src), "\n") {
		if strings.Contains(line, "icon:") {
			continue
		}
		stripped = append(stripped, []byte(line+"\n")...)
	}
	if err := os.WriteFile(strippedSrc, stripped, 0o644); err != nil {
		t.Fatal(err)
	}

	withIconBin := filepath.Join(withIconDir, "out.bin")
	cmd := exec.Command(exe, "emit68k", "-o", withIconBin, "--rtdir", rtDir, withIconSrc)
	out, err := cmd.CombinedOutput()
	if err != nil {
		t.Fatalf("clarusc emit68k (icon missing) failed (want success): %v\n%s", err, out)
	}
	wantWarn := "warning: cannot read app icon " + filepath.Join(withIconDir, "no-such-file.pbm") + ": "
	wantSuffix := "; using default icon"
	if !strings.Contains(string(out), wantWarn) || !strings.Contains(string(out), wantSuffix) {
		t.Errorf("clarusc emit68k stderr/log missing icon warning\n want substring %q ... %q\n got: %s", wantWarn, wantSuffix, out)
	}

	strippedBin := filepath.Join(strippedDir, "out.bin")
	cmd = exec.Command(exe, "emit68k", "-o", strippedBin, "--rtdir", rtDir, strippedSrc)
	out, err = cmd.CombinedOutput()
	if err != nil {
		t.Fatalf("clarusc emit68k (icon stripped) failed: %v\n%s", err, out)
	}
	if strings.Contains(string(out), "warning:") {
		t.Errorf("icon-stripped fixture unexpectedly warned: %s", out)
	}

	gotWithIcon, err := os.ReadFile(withIconBin)
	if err != nil {
		t.Fatal(err)
	}
	gotStripped, err := os.ReadFile(strippedBin)
	if err != nil {
		t.Fatal(err)
	}
	if !bytes.Equal(gotWithIcon, gotStripped) {
		t.Errorf("icon-missing fork (%d bytes) not byte-identical to icon-stripped fork (%d bytes)", len(gotWithIcon), len(gotStripped))
	}

	// Icon-PRESENT regression check: examples/mandelbrot.cla's own pbm
	// resolves, so its compile must still succeed with no warning at all.
	mandel := filepath.Join(root, "examples", "mandelbrot.cla")
	mandelBin := filepath.Join(t.TempDir(), "mandel.bin")
	cmd = exec.Command(exe, "emit68k", "-o", mandelBin, "--rtdir", rtDir, mandel)
	out, err = cmd.CombinedOutput()
	if err != nil {
		t.Fatalf("clarusc emit68k %s failed: %v\n%s", mandel, err, out)
	}
	if strings.Contains(string(out), "warning:") {
		t.Errorf("examples/mandelbrot.cla (icon present, resolves) unexpectedly warned: %s", out)
	}
}
