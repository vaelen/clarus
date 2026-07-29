// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// Package emitui holds the ungated lowering-goldens gate for Tasks 4-5 of
// the 2026-07-24 mac-target-4b plan: clarusc's window/menu descriptor + UI
// intrinsic lowering (Task 4), then `extend`/`every` handler/dispatch
// lowering (Task 5). For each testdata/emitui/<fixture>.cla, it builds
// clarusc via the Go compiler (same pattern as internal/selfhost's
// buildClarusc/emitCDir: build.Build on clarusc/main.cla, then run that
// exe's own `emit` subcommand -- clarusc is never built from its own
// snapshot here), compares the emitted C to a committed <fixture>.c.golden
// byte-for-byte, then compile-checks the GOLDEN against rt_ui.h with the
// m68k toolchain (compile only, no link -- this package verifies LOWERING,
// fixture by fixture; the full compile-AND-LINK gate is a real program,
// testdata/valid/bounce.cla, built end to end via scripts/build-mac.sh,
// which every emitui fixture's handler/dispatch C shape is hand-verified
// against).
package emitui

import (
	"bytes"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"sync"
	"testing"

	"clarus/internal/build"
	"clarus/internal/source"
)

// repoRoot returns the repo root, computed from the package directory (go
// test always runs with cwd == the package dir) -- same convention
// internal/mactest's own repoRoot uses.
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
		dir, err := os.MkdirTemp("", "clarusc-emitui-*")
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

// m68kGCC returns the Retro68 m68k cross-compiler's path, per CLAUDE.md's
// toolchain layout.
func m68kGCC(t *testing.T) string {
	t.Helper()
	p := filepath.Join(repoRoot(t), "toolchain", "bin", "m68k-apple-macos-gcc")
	if _, err := os.Stat(p); err != nil {
		t.Skipf("m68k toolchain not found at %s (build it per CLAUDE.md first): %v", p, err)
	}
	return p
}

// TestEmitUiGoldens runs `clarusc emit` on every testdata/emitui/*.cla
// fixture, compares the emitted C to its committed .c.golden byte-for-byte,
// then m68k compile-checks the golden against rt_ui.h (compile only, no
// link -- see the package doc comment).
func TestEmitUiGoldens(t *testing.T) {
	root := repoRoot(t)
	exe := buildClarusc(t)
	gcc := m68kGCC(t)

	allFixtures, err := filepath.Glob(filepath.Join(root, "testdata", "emitui", "*.cla"))
	if err != nil {
		t.Fatal(err)
	}
	// Only fixtures with a committed .c.golden run this loop -- an error
	// fixture (e.g. err_const_at.cla) has none by design (see
	// TestEmitUiErrConstAt) and never successfully emits.
	var fixtures []string
	for _, f := range allFixtures {
		if _, err := os.Stat(strings.TrimSuffix(f, ".cla") + ".c.golden"); err == nil {
			fixtures = append(fixtures, f)
		}
	}
	if len(fixtures) == 0 {
		t.Fatal("no testdata/emitui/*.cla fixtures with a .c.golden found")
	}

	for _, fixture := range fixtures {
		fixture := fixture
		t.Run(filepath.Base(fixture), func(t *testing.T) {
			golden := strings.TrimSuffix(fixture, ".cla") + ".c.golden"
			want, err := os.ReadFile(golden)
			if err != nil {
				t.Fatalf("read golden %s: %v", golden, err)
			}

			outC := filepath.Join(t.TempDir(), "out.c")
			cmd := exec.Command(exe, "emit", "-o", outC, fixture)
			var stdout, stderr bytes.Buffer
			cmd.Stdout = &stdout
			cmd.Stderr = &stderr
			if err := cmd.Run(); err != nil {
				t.Fatalf("clarusc emit -o %s %s: %v\nstdout: %s\nstderr: %s", outC, fixture, err, stdout.String(), stderr.String())
			}
			got, err := os.ReadFile(outC)
			if err != nil {
				t.Fatalf("read emitted %s: %v", outC, err)
			}
			if !bytes.Equal(got, want) {
				t.Errorf("%s: emitted C does not match %s\n--- got ---\n%s\n--- want ---\n%s", fixture, golden, got, want)
			}

			// Compile-check the GOLDEN (the committed contract), not the
			// freshly emitted bytes -- so a mismatch above is reported as a
			// golden-mismatch failure, and this step still exercises the
			// pinned contract even if emission has drifted. `-x c` is
			// REQUIRED: gcc picks a source language purely from the file
			// extension, ".c.golden" isn't in its table, and -- without -x --
			// it silently treats the file as an unrecognized/link-only input,
			// warns, and exits 0 with NO object emitted at all (found
			// verifying this exact check while adding Task 5's fixtures: the
			// step had never actually compiled anything since Task 4).
			obj := filepath.Join(t.TempDir(), "out.o")
			ccCmd := exec.Command(gcc, "-x", "c", "-c",
				"-I"+filepath.Join(root, "internal", "build", "rt"),
				"-I"+filepath.Join(root, "runtime", "mac"),
				golden, "-o", obj)
			var ccOut bytes.Buffer
			ccCmd.Stdout = &ccOut
			ccCmd.Stderr = &ccOut
			if err := ccCmd.Run(); err != nil {
				t.Fatalf("m68k-apple-macos-gcc -c %s: %v\n%s", golden, err, ccOut.String())
			}
			if fi, statErr := os.Stat(obj); statErr != nil || fi.Size() == 0 {
				t.Fatalf("m68k-apple-macos-gcc -c %s: no object file produced (stat: %v)\n%s", golden, statErr, ccOut.String())
			}
		})
	}
}

// TestEmitUiErrConstAt asserts that a window property whose geometry value
// is a named int constant rather than a literal (legal syntax -- checkWidget
// validates only the property NAME, not this value's shape) fails clarusc
// emit loudly (lower.cla's lowRequireIntLit) instead of silently reading a
// wrong value: nonzero exit, and the diagnostic on stderr.
func TestEmitUiErrConstAt(t *testing.T) {
	root := repoRoot(t)
	exe := buildClarusc(t)
	fixture := filepath.Join(root, "testdata", "emitui", "err_const_at.cla")

	cmd := exec.Command(exe, "emit", "-o", filepath.Join(t.TempDir(), "out.c"), fixture)
	var stderr bytes.Buffer
	cmd.Stderr = &stderr
	err := cmd.Run()
	if err == nil {
		t.Fatalf("clarusc emit %s: want nonzero exit, got success (stderr: %s)", fixture, stderr.String())
	}
	const want = "window property requires an integer literal"
	if !strings.Contains(stderr.String(), want) {
		t.Errorf("stderr %q missing %q", stderr.String(), want)
	}
}

// TestEmitUiTablePopupGuards asserts clarusc's mac-target-4d Task 5
// popup/table lowering guards: each fixture below is checker-clean syntax
// (or, for popup_nonform.cla, syntax the checker itself already rejects --
// see that fixture's own doc comment on why) that clarusc emit must still
// reject loudly with a nonzero exit and a matching stderr message. No
// golden for any of them: none ever successfully emits.
func TestEmitUiTablePopupGuards(t *testing.T) {
	root := repoRoot(t)
	exe := buildClarusc(t)

	cases := []struct {
		fixture string
		want    string
	}{
		// lower.cla's lowWidgetDesc popup guard (lowUnsupported -> log ->
		// stderr): no `binds:` at all.
		{"popup_unbound.cla", "popup requires binds inside a form window"},
		// check.cla's checkBindsProperty: binds given, but the window
		// isn't a form -- caught by the CHECKER before lowering runs (see
		// the fixture's own doc comment). Checker diagnostics print via
		// `alert` (main.cla), which is stdout, not stderr -- unlike the
		// two lowUnsupported-driven cases here.
		{"popup_nonform.cla", "binds: requires the window to declare form for"},
		// lower.cla's lowWidgetDesc table guard: `rows:` is a call
		// expression, not a bare identifier.
		{"table_rows_expr.cla", "table rows must be a global list variable"},
		// Checker-level rejection (stdout, see popup_nonform.cla's note
		// above): `rows:` names a window-local var, invisible to
		// widget-declaration-time property checking (see the fixture's
		// own doc comment).
		{"table_rows_local.cla", "undefined: localRows"},
		// mac-target-4d Task 7: a zero-column table (deferred minor from
		// Task 5) -- lower.cla's lowWidgetDesc table branch.
		{"table_zero_cols.cla", "table must have at least one column"},
		// Task 7: `isNew` read on a record that isn't the accepted
		// handler's own parameter -- lower.cla's lowSelect TyRec case.
		{"isnew_wrong.cla", "isNew is only defined on the accepted handler's parameter"},
		// Task 7: an edit target shape lower.cla's lowEditStmt doesn't
		// support (a nested field of a list element).
		{"edit_bad_target.cla", "edit target must be a variable, list element, or map element"},
		// ARC fix-wave Task 3 (Important 7): check.cla's checkWindowDecl
		// now enforces "every field of a form's record must be a
		// by-value type" (docs/clarus-language-reference.md ~line 1008)
		// itself, at `form for` resolution -- caught by the CHECKER
		// (stdout, see popup_nonform.cla's note above), before lower.cla's
		// own pre-existing (shallower, one-level, lowUnsupported-driven)
		// lowCheckSerializableFields guard ever gets a chance to fire for
		// this shape.
		{"form_for_handle_field.cla", "form for NoteRec: field body must be a by-value type"},
	}

	for _, c := range cases {
		c := c
		t.Run(c.fixture, func(t *testing.T) {
			fixture := filepath.Join(root, "testdata", "emitui", c.fixture)
			cmd := exec.Command(exe, "emit", "-o", filepath.Join(t.TempDir(), "out.c"), fixture)
			var out bytes.Buffer
			cmd.Stdout = &out
			cmd.Stderr = &out
			err := cmd.Run()
			if err == nil {
				t.Fatalf("clarusc emit %s: want nonzero exit, got success (output: %s)", fixture, out.String())
			}
			if !strings.Contains(out.String(), c.want) {
				t.Errorf("output %q missing %q", out.String(), c.want)
			}
		})
	}
}
