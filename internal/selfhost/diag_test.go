// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// diag_test.go covers testdata/errors/*.cla, fixtures with committed
// .expect goldens that lost their only consumer (internal/driver's
// TestErrorGoldens, deleted with the frozen Go compiler in the
// Go-compiler-deletion phase) even though the fixtures and goldens
// themselves survived. Re-hosted here on clarusc directly: each fixture is
// run through `clarusc emit` (NOT bare check-only mode -- native-gaps-cleanup
// Task 8: check-only mode's own gate (main.cla) never calls lowerProgram,
// only the emit/emit68k path does, so a lowering-phase diagnostic like
// Task 8's own xrec_order.cla fixture is UNREACHABLE from bare mode -- it
// would check clean and exit 0, silently defeating this golden). emit's
// own Phase B (checkProgram, print diags, quit 1) is IDENTICAL code run
// unconditionally before the emitMode branch, so every pre-existing
// checker-phase fixture here still produces byte-identical output; emit
// additionally exercises lowering, which bare mode never did. Each run
// prints one "path:line:col: message" line per diagnostic (formatDiag) and
// exits 1 if any. The captured stdout is compared byte-for-byte against the
// fixture's <base>.expect golden, whose committed line(s) already contain
// the exact "../../testdata/errors/<fixture>.cla:..." path clarusc echoes
// back when invoked with that same relative path -- this file runs from
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

			outC := filepath.Join(t.TempDir(), "out.c")
			cmd := exec.Command(exe, "emit", "-o", outC, f)
			out, err := cmd.CombinedOutput()
			if err == nil {
				t.Fatalf("%s: want nonzero exit, got 0 (out: %q)", f, out)
			}
			if _, ok := err.(*exec.ExitError); !ok {
				t.Fatalf("run clarusc emit %s: %v", f, err)
			}
			if string(out) != string(want) {
				t.Errorf("%s:\n got: %q\nwant: %q", f, out, want)
			}
		})
	}
}
