// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// diag_test.go covers testdata/errors/*.cla, six fixtures with committed
// .expect goldens that lost their only consumer (internal/driver's
// TestErrorGoldens, deleted with the frozen Go compiler in the
// Go-compiler-deletion phase) even though the fixtures and goldens
// themselves survived. Re-hosted here on clarusc directly: each fixture is
// run through clarusc's default check mode (no subcommand -- see
// clarusc/main.cla's usage comment), which prints one "path:line:col:
// message" line per diagnostic (formatDiag) and exits 1 if any. The
// captured stdout is compared byte-for-byte against the fixture's
// <base>.expect golden, whose one committed line already contains the
// exact "../../testdata/errors/<fixture>.cla:..." path clarusc echoes back
// when invoked with that same relative path -- this file runs from
// internal/selfhost, the same nesting depth (internal/X) the goldens were
// originally captured from, so the relative path round-trips unchanged.
package selfhost

import (
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"

	"clarus/internal/claruscboot"
)

func TestErrorGoldens(t *testing.T) {
	exe := claruscboot.CurrentExe(t)
	files, _ := filepath.Glob("../../testdata/errors/*.cla")
	if len(files) == 0 {
		t.Fatal("no testdata/errors fixtures found")
	}
	for _, f := range files {
		f := f
		t.Run(filepath.Base(f), func(t *testing.T) {
			want, err := os.ReadFile(strings.TrimSuffix(f, ".cla") + ".expect")
			if err != nil {
				t.Fatal(err)
			}

			cmd := exec.Command(exe, f)
			out, err := cmd.CombinedOutput()
			if err == nil {
				t.Fatalf("%s: want nonzero exit, got 0 (out: %q)", f, out)
			}
			if _, ok := err.(*exec.ExitError); !ok {
				t.Fatalf("run clarusc %s: %v", f, err)
			}
			if string(out) != string(want) {
				t.Errorf("%s:\n got: %q\nwant: %q", f, out, want)
			}
		})
	}
}
