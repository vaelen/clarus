// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// clrdcompare_test.go is Task 6 of the 2026-07-29 runtime-migration-wave1
// plan: the CLRD byte-compare gate.
//
// WHY THIS IS GOLDEN-BASED, NOT A GO-COMPILER-VS-CLARUSC DIFF: the plan's
// original design called for building each save-capable fixture BOTH with
// the Go compiler (build.Build) and with clarusc emit+cc (clarusc itself
// now built via the shared Go-free bootstrap, claruscboot), then diffing
// the two. That is impossible: internal/build's host backend permanently
// refuses to build any program calling file.save/file.load
// (internal/lower/expr.go's lowerFileCall emits "host build does not
// support file.save/file.load yet" unconditionally -- pinned by
// internal/build/unsupported_test.go's TestBuildUnsupportedConstructs, and
// deliberate/enforced per docs/superpowers/plans/2026-07-22-clarus-backend-
// host.md's host-build scope). Extending the frozen Go compiler to lower
// file.save/load would fix this, but CLAUDE.md declares internal/ frozen,
// so that's out of scope here (and out of scope for this plan generally).
//
// Instead, the oracle is a golden baseline captured from TODAY's clarusc
// (which still redirects file.save/load to the C rt_ser.inc serializer,
// same as the Go compiler would if it could build these programs at all):
// testdata/sertest/clrd_goldens/<fixture>.<file> pins the exact bytes
// rt_ser.inc produces, and <fixture>.stdout pins the run's output. This
// test rebuilds+reruns the fixture with the CURRENT clarusc and compares
// against those goldens. It is green today (clarusc still runs the C
// serializer) and must STAY green with zero golden changes through Task 7,
// when clarusc's file.save/load redirect switches to the ported Clarus
// serializer -- that byte-for-byte identity against the frozen C-serializer
// baseline is the same proof the plan wanted, just anchored to a pinned
// snapshot instead of a live Go-compiler build.
//
// Do not "fix" this back to comparing against a live Go-compiler build
// (build.Build) -- see above.
package sertest

import (
	"bytes"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"testing"

	"clarus/internal/build"
)

// clrdFixtures maps each save-capable sertest fixture (relative to
// testdata/sertest) to the .dat files its program produces. roundtrip.cla
// is the only one -- badfield.cla never reaches file.save (clarusc emit
// rejects it first, per TestBadFieldRejected).
var clrdFixtures = map[string][]string{
	"roundtrip.cla": {"rec.dat", "list.dat", "map.dat"},
}

// goldenDir is testdata/sertest/clrd_goldens, holding <fixture>.<datfile>
// and <fixture>.stdout goldens for TestCLRDByteCompare.
func goldenDir(root string) string {
	return filepath.Join(root, "testdata", "sertest", "clrd_goldens")
}

// buildAndRunFixture emits+compiles+runs fixture with the current clarusc
// (mirrors TestRoundtrip's mechanics) and returns its stdout plus the
// contents of each file named in datFiles, read from the fresh run dir.
func buildAndRunFixture(t *testing.T, exe, root, fixture string, datFiles []string) (stdout []byte, files map[string][]byte) {
	t.Helper()
	buildDir := t.TempDir()
	outC := filepath.Join(buildDir, "prog.c")
	emitFixture(t, exe, outC, filepath.Join(root, "testdata", "sertest", fixture))

	binExe := filepath.Join(buildDir, "prog")
	ccCmd := exec.Command(build.CCPath(),
		"-I", filepath.Join(root, "internal", "build", "rt"),
		outC, filepath.Join(root, "internal", "build", "rt", "rt.c"),
		"-o", binExe)
	if out, err := ccCmd.CombinedOutput(); err != nil {
		t.Fatalf("cc: %v\n%s", err, out)
	}

	runDir := t.TempDir()
	runCmd := exec.Command(binExe)
	runCmd.Dir = runDir
	var runOut, runErr bytes.Buffer
	runCmd.Stdout = &runOut
	runCmd.Stderr = &runErr
	if err := runCmd.Run(); err != nil {
		t.Fatalf("run %s: %v\nstdout: %s\nstderr: %s", binExe, err, runOut.String(), runErr.String())
	}

	files = make(map[string][]byte, len(datFiles))
	for _, name := range datFiles {
		b, err := os.ReadFile(filepath.Join(runDir, name))
		if err != nil {
			t.Fatalf("%s: read %s: %v", fixture, name, err)
		}
		files[name] = b
	}
	return runOut.Bytes(), files
}

// compareBytes reports a mismatch between got and want, naming fixture,
// file, and the first differing offset (or a length mismatch).
func compareBytes(t *testing.T, fixture, name string, got, want []byte) {
	t.Helper()
	if bytes.Equal(got, want) {
		return
	}
	if len(got) != len(want) {
		t.Errorf("%s: %s length mismatch: got %d bytes, golden %d bytes", fixture, name, len(got), len(want))
		return
	}
	for i := range got {
		if got[i] != want[i] {
			t.Errorf("%s: %s byte mismatch at offset %d: got 0x%02x, golden 0x%02x", fixture, name, i, got[i], want[i])
			return
		}
	}
}

// TestCLRDByteCompare is the Task 6 gate: for each save-capable sertest
// fixture, build+run with the current clarusc and byte-compare stdout and
// every produced .dat file against the pinned goldens in
// testdata/sertest/clrd_goldens. Run with CLRD_BLESS=1 to (re)write the
// goldens instead of comparing -- only ever do this deliberately (see the
// package doc comment above: this must stay a frozen C-serializer baseline
// through Task 7, not track clarusc's current output).
func TestCLRDByteCompare(t *testing.T) {
	root := repoRoot(t)
	exe := buildClarusc(t)
	bless := os.Getenv("CLRD_BLESS") != ""
	gdir := goldenDir(root)

	for fixture, datFiles := range clrdFixtures {
		fixture, datFiles := fixture, datFiles
		t.Run(fixture, func(t *testing.T) {
			stdout, files := buildAndRunFixture(t, exe, root, fixture, datFiles)

			if bless {
				if err := os.MkdirAll(gdir, 0o755); err != nil {
					t.Fatal(err)
				}
				if err := os.WriteFile(filepath.Join(gdir, fixture+".stdout"), stdout, 0o644); err != nil {
					t.Fatal(err)
				}
				for name, data := range files {
					if err := os.WriteFile(filepath.Join(gdir, fixture+"."+name), data, 0o644); err != nil {
						t.Fatal(err)
					}
				}
				return
			}

			wantStdout, err := os.ReadFile(filepath.Join(gdir, fixture+".stdout"))
			if err != nil {
				t.Fatalf("%s: read stdout golden: %v", fixture, err)
			}
			compareBytes(t, fixture, "stdout", stdout, wantStdout)

			for _, name := range datFiles {
				wantFile, err := os.ReadFile(filepath.Join(gdir, fmt.Sprintf("%s.%s", fixture, name)))
				if err != nil {
					t.Fatalf("%s: read %s golden: %v", fixture, name, err)
				}
				compareBytes(t, fixture, name, files[name], wantFile)
			}
		})
	}
}
