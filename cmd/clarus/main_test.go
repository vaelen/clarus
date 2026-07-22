package main

import (
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
)

// buildCLI builds the clarus binary once per test into a fresh temp dir and
// returns its path, so these tests exercise the real main()/os.Exit paths
// (in-process testing can't: os.Exit would kill the test binary itself).
func buildCLI(t *testing.T) string {
	t.Helper()
	exe := filepath.Join(t.TempDir(), "clarus")
	cmd := exec.Command("go", "build", "-o", exe, ".")
	if out, err := cmd.CombinedOutput(); err != nil {
		t.Fatalf("go build: %v\n%s", err, out)
	}
	return exe
}

// TestBuildMissingOValue covers item 9: `clarus build -o` with no following
// value used to fall through to treating "-o" itself as the source file
// path (an OS "no such file" error, exit 1) instead of a usage/exit-2 guard.
func TestBuildMissingOValue(t *testing.T) {
	exe := buildCLI(t)
	cmd := exec.Command(exe, "build", "-o")
	var stderr strings.Builder
	cmd.Stderr = &stderr
	err := cmd.Run()
	ee, ok := err.(*exec.ExitError)
	if !ok || ee.ExitCode() != 2 {
		t.Fatalf("want exit 2, got %v (stderr=%q)", err, stderr.String())
	}
	if !strings.Contains(stderr.String(), "usage") {
		t.Fatalf("want a usage message, got %q", stderr.String())
	}
}

// TestRunCleansTempDirOnNonzeroExit covers item 7: runRun's `defer
// os.RemoveAll(workdir)` never ran on a nonzero exit path, since every exit
// there is via os.Exit (which skips deferred calls) — every failing `clarus
// run` leaked its throwaway build dir under TMPDIR forever.
func TestRunCleansTempDirOnNonzeroExit(t *testing.T) {
	exe := buildCLI(t)
	dir := t.TempDir()

	// Out-of-range array index: type-checks clean, panics (rt_panic, exit 3)
	// at runtime — a nonzero child exit, not a build failure, so runRun
	// reaches its cmd.Run()/os.Exit(exitErr.ExitCode()) path.
	prog := filepath.Join(dir, "prog.cla")
	src := "on App.launch {\n    var a: int[1]\n    var x: int\n    x = a[5]\n}\n"
	if err := os.WriteFile(prog, []byte(src), 0o644); err != nil {
		t.Fatal(err)
	}

	tmpRoot := filepath.Join(dir, "tmproot")
	if err := os.Mkdir(tmpRoot, 0o755); err != nil {
		t.Fatal(err)
	}

	cmd := exec.Command(exe, "run", prog)
	cmd.Env = append(os.Environ(), "TMPDIR="+tmpRoot)
	err := cmd.Run()
	ee, ok := err.(*exec.ExitError)
	if !ok || ee.ExitCode() != 3 {
		t.Fatalf("want the child's exit 3 forwarded, got %v", err)
	}

	leftover, err := filepath.Glob(filepath.Join(tmpRoot, "clarus-run-*"))
	if err != nil {
		t.Fatal(err)
	}
	if len(leftover) != 0 {
		t.Fatalf("workdir leaked: %v", leftover)
	}
}

func TestSplitRunArgs(t *testing.T) {
	cases := []struct {
		in        []string
		wantFiles []string
		wantArgs  []string
	}{
		{[]string{"a.cla"}, []string{"a.cla"}, nil},
		{[]string{"a.cla", "--", "x", "y"}, []string{"a.cla"}, []string{"x", "y"}},
		{[]string{"a.cla", "b.cla", "--"}, []string{"a.cla", "b.cla"}, []string{}},
		{[]string{"--", "x"}, []string{}, []string{"x"}},
	}
	for _, c := range cases {
		files, args := splitRunArgs(c.in)
		if !eqSlice(files, c.wantFiles) || !eqSlice(args, c.wantArgs) {
			t.Errorf("%v: got files=%v args=%v", c.in, files, args)
		}
	}
}

func eqSlice(a, b []string) bool {
	if len(a) != len(b) {
		return false
	}
	for i := range a {
		if a[i] != b[i] {
			return false
		}
	}
	return true
}
