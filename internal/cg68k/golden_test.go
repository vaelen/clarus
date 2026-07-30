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
