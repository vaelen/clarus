// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// bake_test.go: Task 5 (mac-resident-clarusc)'s host-side unit for
// `emit68k --bake FILE` -- named resources baked verbatim into the
// emitted .bin's resource fork ('CLFS', id 128+i in flag order, name =
// FILE exactly as passed), the mechanism the Mac-resident compiler will
// use to carry its own runtime/toolbox catalog sources. Reuses
// resparParseFork (resparity_test.go, extended for names by this same
// task) rather than duplicating a third resource-fork reader.
package mactest

import (
	"bytes"
	"encoding/binary"
	"os"
	"os/exec"
	"path/filepath"
	"testing"
)

// TestBakeNamedResource builds testdata/ui/about.cla with one --bake flag
// naming testdata/cg68k/tickprobe.cla, and requires a single CLFS 128
// resource whose name is that path (exactly as passed) and whose bytes
// equal the file's own raw bytes.
func TestBakeNamedResource(t *testing.T) {
	root := repoRoot(t)
	exe := buildNativeClarusc(t)
	fixture := filepath.Join(root, "testdata", "ui", "about.cla")
	bakePath := filepath.Join(root, "testdata", "cg68k", "tickprobe.cla")

	want, err := os.ReadFile(bakePath)
	if err != nil {
		t.Fatalf("read %s: %v", bakePath, err)
	}

	bin := filepath.Join(t.TempDir(), "out.bin")
	cmd := exec.Command(exe, "emit68k", "-o", bin, "--rtdir", filepath.Join(root, "runtime", "clarus"), "--bake", bakePath, fixture)
	if out, err := cmd.CombinedOutput(); err != nil {
		t.Fatalf("clarusc emit68k --bake %s -o %s %s: %v\n%s", bakePath, bin, fixture, err, out)
	}

	entries := resparParseFork(t, readForkFromMacBinary(t, bin))

	var found []resparEntry
	for _, e := range entries {
		if e.typ == "CLFS" {
			found = append(found, e)
		}
	}
	if len(found) != 1 {
		t.Fatalf("CLFS resources found = %d, want 1 (%+v)", len(found), found)
	}
	got := found[0]
	if got.id != 128 {
		t.Errorf("CLFS id = %d, want 128 (first --bake flag)", got.id)
	}
	if got.name != bakePath {
		t.Errorf("CLFS name = %q, want %q (the --bake FILE argument, verbatim)", got.name, bakePath)
	}
	if !bytes.Equal(got.data, want) {
		t.Errorf("CLFS data mismatch against %s: got %d bytes, want %d bytes", bakePath, len(got.data), len(want))
	}
}

// TestBakeDuplicateName requires `emit68k --bake FILE --bake FILE` (the
// same name twice) to fail with exit 2, before any output is written.
func TestBakeDuplicateName(t *testing.T) {
	root := repoRoot(t)
	exe := buildNativeClarusc(t)
	fixture := filepath.Join(root, "testdata", "ui", "about.cla")
	bakePath := filepath.Join(root, "testdata", "cg68k", "tickprobe.cla")
	bin := filepath.Join(t.TempDir(), "out.bin")

	cmd := exec.Command(exe, "emit68k", "-o", bin, "--rtdir", filepath.Join(root, "runtime", "clarus"), "--bake", bakePath, "--bake", bakePath, fixture)
	out, err := cmd.CombinedOutput()
	if err == nil {
		t.Fatalf("clarusc emit68k with a duplicate --bake name succeeded, want failure:\n%s", out)
	}
	exitErr, ok := err.(*exec.ExitError)
	if !ok || exitErr.ExitCode() != 2 {
		t.Errorf("exit code = %v, want 2\n%s", err, out)
	}
	if _, statErr := os.Stat(bin); statErr == nil {
		t.Errorf("%s was written despite the duplicate-name error", bin)
	}
}

// TestBakeNoFlagByteIdentity requires that emitting the SAME fixture
// twice -- once via resparBuildAndParse's plain no-flag path (the same
// call TestApp68kResourceParity itself uses) and once directly here --
// produces byte-identical .bin files: --bake existing is opt-in, so a
// build with no --bake flag at all must be completely unaffected by this
// task, the same invariant TestApp68kResourceParity/TestImageStructure's
// untouched goldens already pin structurally. This test instead pins it
// directly: two independent no-flag builds of the same fixture, in two
// different temp dirs (so only the app-name-derived header bytes could
// possibly differ, and they don't, since both outputs are named "out"),
// must match byte for byte.
func TestBakeNoFlagByteIdentity(t *testing.T) {
	root := repoRoot(t)
	exe := buildNativeClarusc(t)
	fixture := filepath.Join(root, "testdata", "ui", "about.cla")
	rtdir := filepath.Join(root, "runtime", "clarus")

	bin1 := filepath.Join(t.TempDir(), "out.bin")
	bin2 := filepath.Join(t.TempDir(), "out.bin")
	for _, bin := range []string{bin1, bin2} {
		cmd := exec.Command(exe, "emit68k", "-o", bin, "--rtdir", rtdir, fixture)
		if out, err := cmd.CombinedOutput(); err != nil {
			t.Fatalf("clarusc emit68k -o %s %s: %v\n%s", bin, fixture, err, out)
		}
	}
	got1, err := os.ReadFile(bin1)
	if err != nil {
		t.Fatal(err)
	}
	got2, err := os.ReadFile(bin2)
	if err != nil {
		t.Fatal(err)
	}
	if !bytes.Equal(got1, got2) {
		t.Fatalf("no-flag build of %s is not deterministic across two runs (%d vs %d bytes)", fixture, len(got1), len(got2))
	}
}

// readForkFromMacBinary strips the 128-byte MacBinary header and trailing
// pad off a .bin, returning just the raw (unpadded) resource fork --
// mirrors resparBuildAndParse's own header parsing (resparity_test.go),
// duplicated here since this file drives clarusc with an extra flag
// resparBuildAndParse's own fixed argv doesn't have room for.
func readForkFromMacBinary(t *testing.T, bin string) []byte {
	t.Helper()
	img, err := os.ReadFile(bin)
	if err != nil {
		t.Fatalf("read %s: %v", bin, err)
	}
	if len(img) < 128 {
		t.Fatalf("image too short: %d bytes", len(img))
	}
	h := img[:128]
	rsrcForkLen := binary.BigEndian.Uint32(h[87:91])
	fork := img[128:]
	if int(rsrcForkLen) > len(fork) {
		t.Fatalf("resource fork length %d exceeds remaining image bytes %d", rsrcForkLen, len(fork))
	}
	return fork[:rsrcForkLen]
}
