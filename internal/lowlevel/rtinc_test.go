// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// rtinc_test.go: Plan 5b Task 4's implicit runtime-module inclusion
// machinery (--rtdir, usage flags, re-check flow). Drives the same
// clarusc-build helper as lowlevel_test.go against the testdata/rtinc
// fixtures: a stand-in runtime module (rt/ser.cla) and a program that
// exercises file.save (prog.cla) or doesn't (noflag.cla).
package lowlevel

import (
	"bytes"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
)

func TestRtInc(t *testing.T) {
	root := repoRoot(t)
	exe := buildClarusc(t)
	prog := filepath.Join(root, "testdata", "rtinc", "prog.cla")
	noflag := filepath.Join(root, "testdata", "rtinc", "noflag.cla")
	rtDir := filepath.Join(root, "testdata", "rtinc", "rt")

	t.Run("IncludesRuntimeModule", func(t *testing.T) {
		// rt/ser.cla itself `include`s rt/helper.cla -- this subtest also
		// covers a multi-file runtime module: expand(rtPath) recurses into
		// rtPath's own includes before appending rtPath's own head, so a
		// single expand call can push more than one asmHeads entry. main.cla
		// must capture the WHOLE range it added, not just the last entry, or
		// helper.cla's rtIncHelper would be parsed/diagnosed but silently
		// never spliced into the emitted program.
		outC := filepath.Join(t.TempDir(), "main.c")
		cmd := exec.Command(exe, "emit", "-o", outC, "--rtdir", rtDir, prog)
		var stdout, stderr bytes.Buffer
		cmd.Stdout = &stdout
		cmd.Stderr = &stderr
		if err := cmd.Run(); err != nil {
			t.Fatalf("clarusc emit --rtdir %s %s: %v\nstdout: %s\nstderr: %s", rtDir, prog, err, stdout.String(), stderr.String())
		}
		c, err := os.ReadFile(outC)
		if err != nil {
			t.Fatal(err)
		}
		src := string(c)
		idxProbe := strings.Index(src, "clar_fn_rtIncProbe")
		if idxProbe < 0 {
			t.Fatalf("emitted C missing clar_fn_rtIncProbe:\n%s", src)
		}
		idxHelper := strings.Index(src, "clar_fn_rtIncHelper")
		if idxHelper < 0 {
			t.Fatalf("emitted C missing clar_fn_rtIncHelper (ser.cla's own include) -- an included dependency of a runtime module was silently dropped:\n%s", src)
		}
		if idxHelper >= idxProbe {
			t.Fatalf("clar_fn_rtIncHelper (at byte %d) must precede clar_fn_rtIncProbe (at byte %d) -- helper.cla is ser.cla's dependency, so its decls must come first (declare-before-use):\n%s", idxHelper, idxProbe, src)
		}
		if firstFn := strings.Index(src, "clar_fn_"); firstFn != idxHelper {
			t.Fatalf("clar_fn_rtIncHelper (at byte %d) is not the first clar_fn_ symbol (first is at %d) -- runtime-module decls must precede user decls:\n%s", idxHelper, firstFn, src)
		}
	})

	t.Run("MissingRtdirErrors", func(t *testing.T) {
		cwd := t.TempDir() // no runtime/clarus/ anywhere above this
		outC := filepath.Join(t.TempDir(), "main.c")
		cmd := exec.Command(exe, "emit", "-o", outC, prog)
		cmd.Dir = cwd
		var stdout, stderr bytes.Buffer
		cmd.Stdout = &stdout
		cmd.Stderr = &stderr
		err := cmd.Run()
		if err == nil {
			t.Fatalf("expected nonzero exit, got success\nstdout: %s", stdout.String())
		}
		if !strings.Contains(stderr.String(), "runtime module") {
			t.Fatalf("stderr missing %q: %s", "runtime module", stderr.String())
		}
	})

	t.Run("NoInclusionWithoutUsage", func(t *testing.T) {
		outC := filepath.Join(t.TempDir(), "main.c")
		cmd := exec.Command(exe, "emit", "-o", outC, noflag)
		var stdout, stderr bytes.Buffer
		cmd.Stdout = &stdout
		cmd.Stderr = &stderr
		if err := cmd.Run(); err != nil {
			t.Fatalf("clarusc emit %s: %v\nstdout: %s\nstderr: %s", noflag, err, stdout.String(), stderr.String())
		}
		c, err := os.ReadFile(outC)
		if err != nil {
			t.Fatal(err)
		}
		if strings.Contains(string(c), "rtIncProbe") {
			t.Fatalf("emitted C unexpectedly contains rtIncProbe with no file.save usage and no --rtdir:\n%s", string(c))
		}
	})
}
