// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// modules_test.go re-hosts the pre-deletion TestClarusModules lane
// (recovered from tag go-compiler-final's driver_test.go). Its only role
// for the frozen Go compiler was as a build vehicle -- clarusc itself was
// always the module under test, the Go compiler never the oracle -- so
// Task 7 of the Go-compiler-deletion phase deleted it along with the rest
// of driver_test.go's package. Re-hosted here on the current-source
// bootstrap: for each clarusc/test/*_test.cla driver (one per clarusc
// module -- lex, parse, ast, ir, types, check, lib, asm68k; each includes
// its module under test via a relative `include "../X.cla"`, so a single
// file suffices), builds it with claruscboot.CurrentExe + `clarusc emit`
// + `cc` (the same recipe internal/mactest/suite_host_test.go's
// buildHostFromFixtures uses -- mirrored here rather than imported, since
// this package must not depend on internal/mactest) and byte-compares its
// stdout against the committed clarusc/test/<name>.out golden.
package selfhost

import (
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"

	"clarus/internal/claruscboot"
)

// buildModuleDriver emits claPath's C with the current-source clarusc and
// compiles it with `cc` against the on-disk runtime sources, returning the
// resulting binary's path.
func buildModuleDriver(t *testing.T, root, claPath string) string {
	t.Helper()
	exe := claruscboot.CurrentExe(t)
	work := t.TempDir()
	outC := filepath.Join(work, "drv.c")
	rtDir := filepath.Join(root, "runtime", "clarus") + string(filepath.Separator)

	emit := exec.Command(exe, "emit", "--rtdir", rtDir, "-o", outC, claPath)
	if out, err := emit.CombinedOutput(); err != nil {
		t.Fatalf("clarusc emit %s: %v\n%s", claPath, err, out)
	}

	bin := filepath.Join(work, "drv")
	cc := exec.Command("cc", "-O1", "-I", filepath.Join(root, "internal", "build", "rt"),
		outC, filepath.Join(root, "internal", "build", "rt", "rt.c"), "-o", bin)
	if out, err := cc.CombinedOutput(); err != nil {
		t.Fatalf("cc compile emitted C for %s: %v\n%s", claPath, err, out)
	}
	return bin
}

// checkModuleGolden builds claPath's driver and byte-compares its stdout
// against the committed <base>.out golden.
func checkModuleGolden(t *testing.T, root, claPath string) {
	t.Helper()
	want, err := os.ReadFile(strings.TrimSuffix(claPath, ".cla") + ".out")
	if err != nil {
		t.Fatal(err)
	}
	bin := buildModuleDriver(t, root, claPath)
	got, err := exec.Command(bin).Output()
	if err != nil {
		t.Fatalf("run %s: %v", claPath, err)
	}
	if string(got) != string(want) {
		t.Errorf("%s:\n got: %q\nwant: %q", claPath, got, want)
	}
}

func TestClarusModules(t *testing.T) {
	root := repoRootBehavior(t)
	files, _ := filepath.Glob(filepath.Join(root, "clarusc", "test", "*_test.cla"))
	if len(files) == 0 {
		t.Fatal("no clarusc/test/*_test.cla drivers found")
	}
	for _, f := range files {
		f := f
		t.Run(filepath.Base(f), func(t *testing.T) { checkModuleGolden(t, root, f) })
	}
}
