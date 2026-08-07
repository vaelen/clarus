// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// incdedup_test.go: pack3-standardfile Task 1's include-once identity fix --
// dedup keys on the LEXICALLY NORMALIZED path, not the raw include spelling.
package lowlevel

import (
	"bytes"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
)

// TestIncludeDedup (pack3-standardfile Task 1): include-once identity is the
// lexically normalized path, not the raw spelling. main.cla reaches
// sub/common.cla as both "sub/common.cla" and "sub/../sub/common.cla";
// pre-fix that double-includes and fails the duplicate-decl check.
func TestIncludeDedup(t *testing.T) {
	root := repoRoot(t)
	exe := buildClarusc(t)
	main := filepath.Join(root, "testdata", "incdedup", "main.cla")

	t.Run("TwoSpellings", func(t *testing.T) {
		outC := filepath.Join(t.TempDir(), "main.c")
		cmd := exec.Command(exe, "emit", "-o", outC, main)
		var stdout, stderr bytes.Buffer
		cmd.Stdout = &stdout
		cmd.Stderr = &stderr
		if err := cmd.Run(); err != nil {
			t.Fatalf("clarusc emit %s: %v\nstdout: %s\nstderr: %s", main, err, stdout.String(), stderr.String())
		}
		c, err := os.ReadFile(outC)
		if err != nil {
			t.Fatal(err)
		}
		src := string(c)
		// "clar_fn_common42(" alone also matches the forward declaration and
		// the call site inside App.startCLI's handler; the definition marker
		// (body-opening "{") is what distinguishes a genuine duplicate
		// DEFINITION, which is what a pre-fix double-include would produce.
		if n := strings.Count(src, "clar_fn_common42(void) {"); n != 1 {
			t.Fatalf("expected exactly one definition of clar_fn_common42(, got %d:\n%s", n, src)
		}
	})

	t.Run("EntryFileDedup", func(t *testing.T) {
		outC := filepath.Join(t.TempDir(), "main.c")
		// Built by string concatenation, NOT filepath.Join/Clean, so the
		// "/./" segment survives byte-for-byte -- this must be a textually
		// distinct spelling of the same file, or the pre-fix raw-string-keyed
		// seenPaths map would already dedup it trivially.
		second := filepath.Dir(main) + "/./main.cla"
		cmd := exec.Command(exe, "emit", "-o", outC, main, second)
		var stdout, stderr bytes.Buffer
		cmd.Stdout = &stdout
		cmd.Stderr = &stderr
		if err := cmd.Run(); err != nil {
			t.Fatalf("clarusc emit %s %s: %v\nstdout: %s\nstderr: %s", main, second, err, stdout.String(), stderr.String())
		}
	})
}
