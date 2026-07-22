package build

import (
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
)

func TestRunGoldens(t *testing.T) {
	files, _ := filepath.Glob("../../testdata/run/*.cla")
	if len(files) == 0 {
		t.Fatal("no run goldens")
	}
	for _, f := range files {
		f := f
		t.Run(filepath.Base(f), func(t *testing.T) {
			want, err := os.ReadFile(strings.TrimSuffix(f, ".cla") + ".out")
			if err != nil {
				t.Fatal(err)
			}
			exe := filepath.Join(t.TempDir(), "prog")
			if diags, err := Build([]string{f}, exe); err != nil || len(diags) > 0 {
				t.Fatalf("build: %v %v", err, diags)
			}
			out, err := exec.Command(exe).Output()
			if err != nil {
				t.Fatalf("run: %v", err)
			}
			if string(out) != string(want) {
				t.Errorf("stdout:\n got: %q\nwant: %q", out, want)
			}
		})
	}
}

func TestRunErrGoldens(t *testing.T) {
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
