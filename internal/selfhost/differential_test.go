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
	"clarus/internal/reftest"
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

// diffOne runs both front ends on path and fails if stdout or exit code differ.
func diffOne(t *testing.T, exe, path string) {
	t.Helper()
	wantOut, wantCode := goCheck(path)
	gotOut, gotCode := runClarusc(t, exe, path)
	if gotOut != wantOut || gotCode != wantCode {
		t.Errorf("divergence on %s\n  go     (exit %d): %q\n  clarusc(exit %d): %q",
			path, wantCode, wantOut, gotCode, gotOut)
	}
}

// corpusFiles globs the whole differential corpus: testdata/{valid,errors,
// run,runerr,include,diag} plus clarusc's own main.cla (clarusc checks
// itself). Shared by TestDifferential and TestSelfBuiltDifferential so both
// walk exactly the same file list.
func corpusFiles(t *testing.T) []string {
	t.Helper()
	var files []string
	for _, g := range []string{
		"../../testdata/valid/*.cla",
		"../../testdata/errors/*.cla",
		"../../testdata/run/*.cla",
		"../../testdata/runerr/*.cla",
		"../../testdata/include/*.cla",
		"../../testdata/diag/*.cla",
	} {
		m, _ := filepath.Glob(g)
		files = append(files, m...)
	}
	files = append(files, "../../clarusc/main.cla")
	if len(files) == 0 {
		t.Fatal("no corpus files matched")
	}
	return files
}

// TestDifferential is the parity gate over the whole file corpus: for every
// file in testdata/{valid,errors,run,runerr,include} AND clarusc's own
// main.cla (clarusc checks itself), clarusc's stdout and exit code must match
// the Go front end's byte-for-byte. Include entry files exercise multi-file
// expansion (parse-phase per-file attribution, check-phase per-decl
// attribution) on both sides.
func TestDifferential(t *testing.T) {
	exe, err := buildClarusc()
	if err != nil {
		t.Fatalf("build clarusc: %v", err)
	}

	for _, f := range corpusFiles(t) {
		f := f
		t.Run(filepath.Base(f), func(t *testing.T) { diffOne(t, exe, f) })
	}
}

// TestDifferentialFences extends parity to EVERY ```rust fence in the language
// reference (not just the manifest-clean subset): each fence is written to a
// temp file and both front ends must produce identical diagnostics, whether
// the fence is a clean program, an intentional-error snippet, or a fragment
// that fails to parse/resolve the same way on both sides.
func TestDifferentialFences(t *testing.T) {
	exe, err := buildClarusc()
	if err != nil {
		t.Fatalf("build clarusc: %v", err)
	}
	fences, err := reftest.ExtractFences("../../docs/clarus-language-reference.md")
	if err != nil {
		t.Fatal(err)
	}
	if len(fences) == 0 {
		t.Fatal("no reference fences extracted")
	}
	dir := t.TempDir()
	for _, fe := range fences {
		fe := fe
		t.Run(fmt.Sprintf("fence%03d_line%d", fe.Index, fe.Line), func(t *testing.T) {
			p := filepath.Join(dir, fmt.Sprintf("fence%03d.cla", fe.Index))
			if err := os.WriteFile(p, []byte(fe.Code), 0o644); err != nil {
				t.Fatal(err)
			}
			diffOne(t, exe, p)
		})
	}
}

// TestClaruscChecksItself pins the self-host property explicitly: clarusc's own
// source (main.cla plus its includes) must check CLEAN (empty stdout, exit 0)
// under both the Go front end and clarusc itself.
func TestClaruscChecksItself(t *testing.T) {
	exe, err := buildClarusc()
	if err != nil {
		t.Fatalf("build clarusc: %v", err)
	}
	const self = "../../clarusc/main.cla"
	goOut, goCode := goCheck(self)
	if goOut != "" || goCode != 0 {
		t.Fatalf("go check %s not clean: exit %d, out %q", self, goCode, goOut)
	}
	ccOut, ccCode := runClarusc(t, exe, self)
	if ccOut != "" || ccCode != 0 {
		t.Fatalf("clarusc check %s not clean: exit %d, out %q", self, ccCode, ccOut)
	}
}
