package selfhost

import (
	"bytes"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"sync"
	"testing"

	"clarus/internal/build"
	"clarus/internal/driver"
)

// clarusc is built once per `go test` invocation and reused across every
// differential case: the ~8-module compile is the dominant cost, so a
// sync.Once memoizes it (the built exe lives in a temp dir cleaned up by the
// OS). Any build failure is captured and re-reported by every case.
var (
	claruscOnce sync.Once
	claruscExe  string
	claruscErr  error
)

func buildClarusc() (string, error) {
	claruscOnce.Do(func() {
		dir, err := os.MkdirTemp("", "clarusc-*")
		if err != nil {
			claruscErr = err
			return
		}
		exe := filepath.Join(dir, "clarusc")
		diags, err := build.Build([]string{"../../clarusc/main.cla"}, exe)
		if err != nil {
			claruscErr = err
			return
		}
		if len(diags) > 0 {
			claruscErr = fmt.Errorf("clarusc build produced %d diagnostic(s): %v", len(diags), diags)
			return
		}
		claruscExe = exe
	})
	return claruscExe, claruscErr
}

// goCheck reproduces exactly what `clarus check path` writes to stdout (one
// Diag.String() line per diagnostic) and the exit code it uses (1 on any
// diagnostic or hard error, else 0). This is the parity oracle clarusc is
// diffed against.
func goCheck(path string) (string, int) {
	diags, err := driver.Check([]string{path})
	if err != nil {
		// clarus check prints the error to stderr and exits 1 with no
		// stdout; the differential only compares stdout + exit code.
		return "", 1
	}
	var b strings.Builder
	for _, d := range diags {
		b.WriteString(d.String())
		b.WriteByte('\n')
	}
	code := 0
	if len(diags) > 0 {
		code = 1
	}
	return b.String(), code
}

// runClarusc runs the built clarusc on path (relative to this package's
// directory, the same string handed to goCheck) and returns its stdout and
// exit code.
func runClarusc(t *testing.T, exe, path string) (string, int) {
	t.Helper()
	cmd := exec.Command(exe, path)
	var out bytes.Buffer
	cmd.Stdout = &out
	err := cmd.Run()
	if ee, ok := err.(*exec.ExitError); ok {
		return out.String(), ee.ExitCode()
	}
	if err != nil {
		t.Fatalf("run clarusc %s: %v", path, err)
	}
	return out.String(), 0
}

// TestDifferential is the parity gate: for every file in the subset corpus,
// clarusc's stdout and exit code must match the Go front end's byte-for-byte.
func TestDifferential(t *testing.T) {
	exe, err := buildClarusc()
	if err != nil {
		t.Fatalf("build clarusc: %v", err)
	}

	var files []string
	for _, g := range []string{
		"../../testdata/valid/*.cla",
		"../../testdata/errors/*.cla",
		"../../testdata/runerr/*.cla",
	} {
		m, _ := filepath.Glob(g)
		files = append(files, m...)
	}
	if len(files) == 0 {
		t.Fatal("no corpus files matched")
	}

	for _, f := range files {
		f := f
		t.Run(filepath.Base(f), func(t *testing.T) {
			wantOut, wantCode := goCheck(f)
			gotOut, gotCode := runClarusc(t, exe, f)
			if gotOut != wantOut || gotCode != wantCode {
				t.Errorf("divergence on %s\n  go     (exit %d): %q\n  clarusc(exit %d): %q",
					f, wantCode, wantOut, gotCode, gotOut)
			}
		})
	}
}
