// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// Package cg68k is the listing-golden gate for native-5d Task 7's `emit68k`
// skeleton (clarusc/cg68k.cla): for each testdata/cg68k/<fixture>.cla, it
// builds clarusc via the memoized buildClarusc() pattern (mirrors
// internal/selfhost/differential_test.go's own buildClarusc), runs
// `clarusc emit68k -o out.bin --listing <fixture>` in a temp dir, and
// compares the resulting out.seg1.s against the committed
// testdata/cg68k/<fixture>.s golden byte-for-byte. Run with
// CLARUS_CG68K_BLESS=1 to (re)write the goldens instead of comparing.
package cg68k

import (
	"bytes"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"sync"
	"testing"

	"clarus/internal/build"
	"clarus/internal/source"
)

func repoRoot(t *testing.T) string {
	t.Helper()
	wd, err := os.Getwd()
	if err != nil {
		t.Fatalf("getwd: %v", err)
	}
	return filepath.Join(wd, "..", "..")
}

// clarusc is built once per `go test` invocation and reused across every
// fixture (mirrors internal/selfhost/differential_test.go's buildClarusc).
var (
	claruscOnce sync.Once
	claruscExe  string
	claruscErr  error
)

func buildClarusc(t *testing.T) string {
	t.Helper()
	claruscOnce.Do(func() {
		dir, err := os.MkdirTemp("", "clarusc-cg68k-*")
		if err != nil {
			claruscErr = err
			return
		}
		exe := filepath.Join(dir, "clarusc")
		diags, err := build.Build([]string{filepath.Join(repoRoot(t), "clarusc", "main.cla")}, exe)
		if err != nil {
			claruscErr = err
			return
		}
		if len(diags) > 0 {
			claruscErr = &diagError{diags: diags}
			return
		}
		claruscExe = exe
	})
	if claruscErr != nil {
		t.Fatal(claruscErr)
	}
	return claruscExe
}

type diagError struct{ diags []source.Diag }

func (e *diagError) Error() string {
	var b strings.Builder
	b.WriteString("clarusc build produced diagnostics:")
	for _, d := range e.diags {
		b.WriteString("\n  ")
		b.WriteString(d.String())
	}
	return b.String()
}

// TestCg68kGoldens runs `clarusc emit68k -o out.bin --listing <fixture>` on
// every testdata/cg68k/*.cla fixture and compares out.seg1.s against the
// committed <fixture>.s golden. CLARUS_CG68K_BLESS=1 regenerates the
// goldens instead of comparing.
func TestCg68kGoldens(t *testing.T) {
	root := repoRoot(t)
	exe := buildClarusc(t)
	bless := os.Getenv("CLARUS_CG68K_BLESS") != ""

	fixtures, err := filepath.Glob(filepath.Join(root, "testdata", "cg68k", "*.cla"))
	if err != nil {
		t.Fatal(err)
	}
	if len(fixtures) == 0 {
		t.Fatal("no testdata/cg68k/*.cla fixtures found")
	}

	for _, fixture := range fixtures {
		fixture := fixture
		name := filepath.Base(fixture)
		t.Run(name, func(t *testing.T) {
			runDir := t.TempDir()
			outBin := filepath.Join(runDir, "out.bin")
			cmd := exec.Command(exe, "emit68k", "-o", outBin, "--listing", fixture)
			out, err := cmd.CombinedOutput()
			if err != nil {
				t.Fatalf("clarusc emit68k -o %s --listing %s: %v\n%s", outBin, fixture, err, out)
			}

			segS := filepath.Join(runDir, "out.seg1.s")
			got, err := os.ReadFile(segS)
			if err != nil {
				t.Fatalf("read %s: %v", segS, err)
			}

			golden := filepath.Join(root, "testdata", "cg68k", name[:len(name)-len(".cla")]+".s")
			if bless {
				if err := os.WriteFile(golden, got, 0o644); err != nil {
					t.Fatal(err)
				}
				return
			}

			want, err := os.ReadFile(golden)
			if err != nil {
				t.Fatalf("read golden %s (run with CLARUS_CG68K_BLESS=1 to create it): %v", golden, err)
			}
			if string(got) != string(want) {
				t.Errorf("%s: emitted listing does not match %s\n--- got ---\n%s\n--- want ---\n%s", fixture, golden, got, want)
			}
		})
	}
}

// requireVasm returns the path to a working vasmm68k_mot, or skips the
// test with a rebuild recipe if it's missing or lacks the -Fbin (binary
// output) module -- a near-duplicate of internal/asm68k/vasm_test.go's own
// requireVasm (same probe: a real assemble-and-check, not just a banner
// grep), kept local here rather than exported cross-package for a single
// ~20-line helper (native-5d Task 8 brief's own "your call").
func requireVasm(t *testing.T) string {
	t.Helper()
	exe := filepath.Join(repoRoot(t), "vasm", "vasmm68k_mot")
	if _, err := os.Stat(exe); err != nil {
		t.Skipf("vasm/vasmm68k_mot not found (%v) -- see internal/asm68k/vasm_test.go's requireVasm for the build recipe", err)
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
		t.Skipf("vasm/vasmm68k_mot failed a -Fbin probe (likely built without the bin output module): %v\n%s", err, out)
	}
	got, err := os.ReadFile(probeBin)
	if err != nil || !bytes.Equal(got, []byte{1, 2, 3, 4}) {
		t.Skipf("vasm/vasmm68k_mot -Fbin probe produced unexpected output (got %x, err %v)", got, err)
	}
	return exe
}

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

// TestCg68kVasmRoundTrip is native-5d Task 8's proof that listing and
// bytes agree for REAL function bodies (Task 7's own TestVasmRoundTrip-
// style sibling covers only asm68k.cla's self-exerciser, which never
// exercises cg68k.cla's own emission choices): for every testdata/cg68k
// fixture, assemble the just-emitted out.seg1.s with vasm and require the
// result to be byte-identical to out.seg1.dat (cg68k.cla's own encoder,
// via asm68k.cla's a68Bytes()).
func TestCg68kVasmRoundTrip(t *testing.T) {
	root := repoRoot(t)
	exe := buildClarusc(t)
	vasm := requireVasm(t)

	fixtures, err := filepath.Glob(filepath.Join(root, "testdata", "cg68k", "*.cla"))
	if err != nil {
		t.Fatal(err)
	}
	if len(fixtures) == 0 {
		t.Fatal("no testdata/cg68k/*.cla fixtures found")
	}

	for _, fixture := range fixtures {
		fixture := fixture
		name := filepath.Base(fixture)
		t.Run(name, func(t *testing.T) {
			runDir := t.TempDir()
			outBin := filepath.Join(runDir, "out.bin")
			cmd := exec.Command(exe, "emit68k", "-o", outBin, "--listing", fixture)
			if out, err := cmd.CombinedOutput(); err != nil {
				t.Fatalf("clarusc emit68k -o %s --listing %s: %v\n%s", outBin, fixture, err, out)
			}

			segS := filepath.Join(runDir, "out.seg1.s")
			segDat := filepath.Join(runDir, "out.seg1.dat")
			vasmOut := filepath.Join(runDir, "vasm_out.bin")

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
				t.Fatalf("%s: vasm round-trip diverged at byte offset %d (encoder %d bytes, vasm %d bytes)\n encoder: %s\n vasm:    %s",
					name, off, len(want), len(got), hexWindow(want, off), hexWindow(got, off))
			}
		})
	}
}

// TestCg68kDeterminism runs emit68k twice on control.cla (the control-flow
// fixture -- the one most likely to expose any non-deterministic label
// numbering or map-iteration-order dependence, given its nested loops and
// if/else-if chain) and requires the two out.seg1.dat byte streams to be
// identical.
func TestCg68kDeterminism(t *testing.T) {
	root := repoRoot(t)
	exe := buildClarusc(t)
	fixture := filepath.Join(root, "testdata", "cg68k", "control.cla")

	run := func() []byte {
		runDir := t.TempDir()
		outBin := filepath.Join(runDir, "out.bin")
		cmd := exec.Command(exe, "emit68k", "-o", outBin, "--listing", fixture)
		if out, err := cmd.CombinedOutput(); err != nil {
			t.Fatalf("clarusc emit68k -o %s --listing %s: %v\n%s", outBin, fixture, err, out)
		}
		data, err := os.ReadFile(filepath.Join(runDir, "out.seg1.dat"))
		if err != nil {
			t.Fatal(err)
		}
		return data
	}

	first := run()
	second := run()
	if !bytes.Equal(first, second) {
		t.Fatalf("emit68k is non-deterministic: control.cla's out.seg1.dat differs across two runs (%d vs %d bytes)", len(first), len(second))
	}
}
