package build

import (
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
	"testing"
)

// readOptional returns the file's contents and true, or "", false if the
// file doesn't exist (any other stat/read error is fatal — a golden with a
// malformed extension file is a test-authoring bug, not an absent one).
func readOptional(t *testing.T, path string) (string, bool) {
	t.Helper()
	b, err := os.ReadFile(path)
	if err != nil {
		if os.IsNotExist(err) {
			return "", false
		}
		t.Fatalf("read %s: %v", path, err)
	}
	return string(b), true
}

func TestRunGoldens(t *testing.T) {
	requireGoCompiler(t)
	files, _ := filepath.Glob("../../testdata/run/*.cla")
	if len(files) == 0 {
		t.Fatal("no run goldens")
	}
	for _, f := range files {
		f := f
		t.Run(filepath.Base(f), func(t *testing.T) {
			base := strings.TrimSuffix(f, ".cla")
			want, err := os.ReadFile(base + ".out")
			if err != nil {
				t.Fatal(err)
			}
			exe := filepath.Join(t.TempDir(), "prog")
			if diags, err := Build([]string{f}, exe); err != nil || len(diags) > 0 {
				t.Fatalf("build: %v %v", err, diags)
			}

			// Extensions (CLI/self-hosting features plan, Task 5): NAME.args
			// supplies argv (whitespace-split), NAME.log pins exact stderr,
			// NAME.exit pins the expected exit code (default 0; a nonzero
			// value means that code is accepted instead of requiring
			// success). Absent files reproduce the exact prior behavior.
			var argv []string
			if s, ok := readOptional(t, base+".args"); ok {
				argv = strings.Fields(s)
			}
			wantExit := 0
			if s, ok := readOptional(t, base+".exit"); ok {
				wantExit, err = strconv.Atoi(strings.TrimSpace(s))
				if err != nil {
					t.Fatalf("bad .exit: %v", err)
				}
			}

			// cwd = a fresh per-test temp dir, distinct from exe's own
			// TempDir above: run goldens that touch files (files.cla) use
			// relative paths, and must not litter the source tree or race
			// each other. Fixtures that don't touch the filesystem are
			// unaffected by cwd.
			cmd := exec.Command(exe, argv...)
			cmd.Dir = t.TempDir()
			var stdout, stderr strings.Builder
			cmd.Stdout = &stdout
			cmd.Stderr = &stderr
			runErr := cmd.Run()

			gotExit := 0
			if runErr != nil {
				ee, ok := runErr.(*exec.ExitError)
				if !ok {
					t.Fatalf("run: %v", runErr)
				}
				gotExit = ee.ExitCode()
			}
			if gotExit != wantExit {
				t.Fatalf("exit code: got %d want %d (stderr: %s)", gotExit, wantExit, stderr.String())
			}

			if stdout.String() != string(want) {
				t.Errorf("stdout:\n got: %q\nwant: %q", stdout.String(), want)
			}
			if wantLog, ok := readOptional(t, base+".log"); ok && stderr.String() != wantLog {
				t.Errorf("stderr:\n got: %q\nwant: %q", stderr.String(), wantLog)
			}
		})
	}
}

func TestRunErrGoldens(t *testing.T) {
	requireGoCompiler(t)
	files, _ := filepath.Glob("../../testdata/runerr/*.cla")
	for _, f := range files {
		f := f
		t.Run(filepath.Base(f), func(t *testing.T) {
			want, err := os.ReadFile(strings.TrimSuffix(f, ".cla") + ".err")
			if err != nil {
				t.Fatal(err)
			}
			exe := filepath.Join(t.TempDir(), "prog")
			if diags, err := Build([]string{f}, exe); err != nil || len(diags) > 0 {
				t.Fatalf("build: %v %v", err, diags)
			}
			cmd := exec.Command(exe)
			var stderr strings.Builder
			cmd.Stderr = &stderr
			err = cmd.Run()
			ee, ok := err.(*exec.ExitError)
			if !ok || ee.ExitCode() != 3 {
				t.Fatalf("want exit 3, got %v", err)
			}
			if !strings.Contains(stderr.String(), strings.TrimSpace(string(want))) {
				t.Errorf("stderr %q missing %q", stderr.String(), want)
			}
		})
	}
}
