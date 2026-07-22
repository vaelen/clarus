// Package selfhost holds the reusable Clarus-test-driver runner used by
// clarusc's self-hosted modules (Tasks 5-9): each module under test gets a
// small clarusc/test/*_test.cla that includes it and prints results via
// alert, checked byte-for-byte against a golden *_test.out file.
package selfhost

import (
	"clarus/internal/build"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
)

// runClarusTest builds a clarusc test-driver .cla (which includes its module
// under test) and runs it, returning stdout. Fails on build or nonzero exit.
func runClarusTest(t *testing.T, claPath string) string {
	t.Helper()
	exe := filepath.Join(t.TempDir(), "drv")
	diags, err := build.Build([]string{claPath}, exe)
	if err != nil || len(diags) > 0 {
		t.Fatalf("build %s: err=%v diags=%v", claPath, err, diags)
	}
	out, err := exec.Command(exe).Output()
	if err != nil {
		t.Fatalf("run %s: %v", claPath, err)
	}
	return string(out)
}

func checkGolden(t *testing.T, claPath string) {
	t.Helper()
	want, err := os.ReadFile(strings.TrimSuffix(claPath, ".cla") + ".out")
	if err != nil {
		t.Fatal(err)
	}
	got := runClarusTest(t, claPath)
	if got != string(want) {
		t.Errorf("%s:\n got: %q\nwant: %q", claPath, got, want)
	}
}

func TestClarusModules(t *testing.T) {
	files, _ := filepath.Glob("../../clarusc/test/*_test.cla")
	for _, f := range files {
		f := f
		t.Run(filepath.Base(f), func(t *testing.T) { checkGolden(t, f) })
	}
}
