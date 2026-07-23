package selfhost

import (
	"bytes"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
	"sync"
	"testing"

	"clarus/internal/build"
)

// emitCDir is the dir-taking core of emitC: it runs
// `clarusc emit -o <dir>/main.c claPath` and returns the emitted C bytes, or
// an error (never t.Fatalf) so callers that need to memoize a build across
// multiple top-level tests -- where a per-test t.TempDir() would be cleaned
// up as soon as the first such test finishes -- can use a longer-lived
// directory.
func emitCDir(exe, claPath, dir string) ([]byte, error) {
	mainC := filepath.Join(dir, "main.c")

	cmd := exec.Command(exe, "emit", "-o", mainC, claPath)
	var out, errb bytes.Buffer
	cmd.Stdout = &out
	cmd.Stderr = &errb
	if err := cmd.Run(); err != nil {
		return nil, fmt.Errorf("clarusc emit -o %s %s: %v\nstderr: %s", mainC, claPath, err, errb.String())
	}

	emitted, err := os.ReadFile(mainC)
	if err != nil {
		return nil, fmt.Errorf("read emitted C at %s: %w", mainC, err)
	}
	return emitted, nil
}

// emitC runs `clarusc emit` for claPath and returns the emitted C bytes.
func emitC(t *testing.T, exe, claPath string) []byte {
	t.Helper()
	c, err := emitCDir(exe, claPath, t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	return c
}

// compileCDir is the dir-taking core of compileC: it writes cBytes plus the
// embedded host runtime (rt.h/rt.c) into dir and compiles them with the same
// toolchain and flags internal/build uses. It returns the built binary's
// path, or an error (never t.Fatalf) -- same memoization rationale as
// emitCDir.
func compileCDir(cBytes []byte, dir string) (string, error) {
	mainC := filepath.Join(dir, "main.c")
	if err := os.WriteFile(mainC, cBytes, 0o644); err != nil {
		return "", err
	}
	rtC := filepath.Join(dir, "rt.c")
	if err := os.WriteFile(filepath.Join(dir, "rt.h"), build.RuntimeH(), 0o644); err != nil {
		return "", err
	}
	if err := os.WriteFile(rtC, build.RuntimeC(), 0o644); err != nil {
		return "", err
	}

	bin := filepath.Join(dir, "prog")
	cc := exec.Command(build.CCPath(), "-std=c99", "-O1", mainC, rtC, "-o", bin)
	if ccOut, err := cc.CombinedOutput(); err != nil {
		return "", fmt.Errorf("cc rejected clarusc-emitted C: %v\n%s\n--- emitted C ---\n%s", err, ccOut, string(cBytes))
	}
	return bin, nil
}

// compileC writes cBytes alongside the embedded host runtime into a temp dir
// and compiles them, returning the built binary's path.
func compileC(t *testing.T, cBytes []byte) string {
	t.Helper()
	bin, err := compileCDir(cBytes, t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	return bin
}

// emitBuildDir composes emitCDir + compileCDir in a single directory: it
// runs `clarusc emit -o <dir>/main.c claPath`, then compiles that alongside
// the embedded host runtime. See emitCDir for the memoization rationale for
// taking dir instead of using t.TempDir() internally.
func emitBuildDir(exe, claPath, dir string) (string, error) {
	c, err := emitCDir(exe, claPath, dir)
	if err != nil {
		return "", err
	}
	return compileCDir(c, dir)
}

// emitBuild runs `clarusc emit -o <dir>/main.c claPath`, reads the written
// main.c as the emitted C translation unit, writes it alongside the embedded
// host runtime (rt.h/rt.c from internal/build) into a temp dir, and compiles
// them with the same toolchain and flags internal/build uses. It returns the
// built binary's path.
func emitBuild(t *testing.T, exe, claPath string) string {
	t.Helper()
	bin, err := emitBuildDir(exe, claPath, t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	return bin
}

// TestEmitDifferential is the whole-corpus parity gate: for EVERY
// testdata/run/*.cla golden, clarusc emits C, that C compiles and links
// against the host runtime, and the resulting binary's stdout + exit code
// match the SAME .out/.args/.exit/.log oracle internal/build's run goldens
// match (golden_test.go's TestRunGoldens). A golden exercising a construct
// the emit path can't yet handle fails loudly (lowUnsupported aborts clarusc
// emit), never silently — so this glob is the enforcement that the emit path
// now covers the full host-subset corpus.
func TestEmitDifferential(t *testing.T) {
	exe, err := buildClarusc()
	if err != nil {
		t.Fatalf("build clarusc: %v", err)
	}

	files, _ := filepath.Glob("../../testdata/run/*.cla")
	if len(files) == 0 {
		t.Fatal("no run goldens")
	}
	for _, seed := range files {
		seed := seed
		t.Run(filepath.Base(seed), func(t *testing.T) {
			base := strings.TrimSuffix(seed, ".cla")
			want, err := os.ReadFile(base + ".out")
			if err != nil {
				t.Fatal(err)
			}

			bin := emitBuild(t, exe, seed)

			var argv []string
			if b, err := os.ReadFile(base + ".args"); err == nil {
				argv = strings.Fields(string(b))
			}
			wantExit := 0
			if b, err := os.ReadFile(base + ".exit"); err == nil {
				wantExit, err = strconv.Atoi(strings.TrimSpace(string(b)))
				if err != nil {
					t.Fatalf("bad .exit: %v", err)
				}
			}

			cmd := exec.Command(bin, argv...)
			cmd.Dir = t.TempDir()
			var stdout, stderr bytes.Buffer
			cmd.Stdout = &stdout
			cmd.Stderr = &stderr
			runErr := cmd.Run()

			gotExit := 0
			if runErr != nil {
				ee, ok := runErr.(*exec.ExitError)
				if !ok {
					t.Fatalf("run emitted binary: %v", runErr)
				}
				gotExit = ee.ExitCode()
			}
			if gotExit != wantExit {
				t.Fatalf("exit code: got %d want %d (stderr: %s)", gotExit, wantExit, stderr.String())
			}
			if stdout.String() != string(want) {
				t.Errorf("stdout:\n got: %q\nwant: %q", stdout.String(), string(want))
			}
			if b, err := os.ReadFile(base + ".log"); err == nil && stderr.String() != string(b) {
				t.Errorf("stderr:\n got: %q\nwant: %q", stderr.String(), string(b))
			}
		})
	}
}

// selfBuiltClarusc memoizes emitBuild(mainClaruscExe, "../../clarusc/main.cla")
// -- i.e. it self-emits clarusc's own ~10-file source through clarusc-emit,
// compiles the result with cc + rt.c, and returns the resulting binary's
// path. This is the "stage1 emits stage2" step: proof that the emit path
// covers everything clarusc's own source uses. Memoized because self-emit +
// cc takes real time and every subtest below wants the same binary.
//
// selfC is the emitted C itself (Task 11 calls this "c2": stage1's emission
// of clarusc's own source). It's retained alongside the binary so
// TestBootstrapFixedPoint can diff it against stage2's own emission (c3)
// without re-running the stage1 emit.
var (
	selfExeOnce sync.Once
	selfC       []byte
	selfExe     string
	selfExeErr  error
)

func selfBuiltClarusc(t *testing.T) string {
	t.Helper()
	selfBuiltClaruscC(t)
	return selfExe
}

// selfBuiltClaruscC returns c2 -- the C that stage1 (the Go-built clarusc)
// emits for clarusc's own source -- triggering the same memoized build
// selfBuiltClarusc uses.
func selfBuiltClaruscC(t *testing.T) []byte {
	t.Helper()
	selfExeOnce.Do(func() {
		exe, err := buildClarusc()
		if err != nil {
			selfExeErr = fmt.Errorf("build clarusc (Go): %w", err)
			return
		}
		// A plain os.MkdirTemp, not t.TempDir(): this build is memoized
		// across multiple top-level tests, and t.TempDir()'s cleanup fires
		// as soon as the first such test completes -- which would delete
		// the binary out from under the others.
		dir, err := os.MkdirTemp("", "clarusc-self-*")
		if err != nil {
			selfExeErr = err
			return
		}
		selfC, selfExeErr = emitCDir(exe, "../../clarusc/main.cla", dir)
		if selfExeErr != nil {
			return
		}
		selfExe, selfExeErr = compileCDir(selfC, dir)
	})
	if selfExeErr != nil {
		t.Fatal(selfExeErr)
	}
	return selfC
}

// TestEmitSelfCompiles proves self-emission: clarusc emits C for its OWN
// source (the include graph rooted at clarusc/main.cla pulls in every
// clarusc module), that C compiles clean against the host runtime, and the
// resulting binary is a correct clarusc -- both as a checker (front end
// parity against the v1 Go oracle) and as an emitter (it can itself run
// `emit` and produce a working program).
func TestEmitSelfCompiles(t *testing.T) {
	bin := selfBuiltClarusc(t)
	info, err := os.Stat(bin)
	if err != nil || info.Size() == 0 {
		t.Fatalf("self-built clarusc binary missing or empty: %v", err)
	}
	t.Logf("self-built clarusc binary: %s (%d bytes)", bin, info.Size())
}

// TestEmitSelfChecks runs the self-built clarusc (stage1-emitted, cc-compiled)
// as a checker over a handful of testdata/diag/*.cla files with known
// diagnostics, plus one clean valid file, and asserts its stdout + exit code
// match the v1 Go oracle (goCheck) exactly -- the same comparison diffOne
// does, but against the self-built binary instead of the Go-built one. This
// proves the emitted compiler's front end behaves identically, not merely
// that it compiles.
func TestEmitSelfChecks(t *testing.T) {
	bin := selfBuiltClarusc(t)

	files := []string{
		"../../testdata/diag/chk_undefined.cla",
		"../../testdata/diag/chk_typemismatch.cla",
		"../../testdata/diag/chk_wrongargs.cla",
		"../../testdata/diag/lex_unexpected.cla",
		"../../testdata/diag/chk_missingret.cla",
		"../../testdata/valid/bookmarks.cla",
	}
	for _, f := range files {
		f := f
		t.Run(filepath.Base(f), func(t *testing.T) {
			wantOut, wantCode := goCheck(f)
			gotOut, gotCode := runClarusc(t, bin, f)
			if gotOut != wantOut || gotCode != wantCode {
				t.Errorf("divergence on %s\n  go        (exit %d): %q\n  self-built(exit %d): %q",
					f, wantCode, wantOut, gotCode, gotOut)
			}
		})
	}
}

// TestEmitSelfEmits is the mini pre-flight for Task 11's bootstrap: the
// self-built clarusc must itself be able to run `emit`, not just `check`.
// It emits testdata/run/emit_hello.cla, that C compiles + links against the
// host runtime, and running it reproduces the golden .out exactly.
func TestEmitSelfEmits(t *testing.T) {
	bin := selfBuiltClarusc(t)

	prog := emitBuild(t, bin, "../../testdata/run/emit_hello.cla")
	want, err := os.ReadFile("../../testdata/run/emit_hello.out")
	if err != nil {
		t.Fatal(err)
	}

	cmd := exec.Command(prog)
	cmd.Dir = t.TempDir()
	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	if err := cmd.Run(); err != nil {
		t.Fatalf("run self-built-clarusc-emitted binary: %v (stderr: %s)", err, stderr.String())
	}
	if stdout.String() != string(want) {
		t.Errorf("stdout: got %q want %q", stdout.String(), string(want))
	}
}

// TestEmitRunErr is the runtime-error half of the whole-corpus gate: every
// testdata/runerr/*.cla golden, emitted through clarusc and run, must abort
// with exit 3 and a stderr containing the golden's .err substring — the same
// oracle golden_test.go's TestRunErrGoldens holds the Go build to.
func TestEmitRunErr(t *testing.T) {
	exe, err := buildClarusc()
	if err != nil {
		t.Fatalf("build clarusc: %v", err)
	}

	files, _ := filepath.Glob("../../testdata/runerr/*.cla")
	if len(files) == 0 {
		t.Fatal("no runerr goldens")
	}
	for _, seed := range files {
		seed := seed
		t.Run(filepath.Base(seed), func(t *testing.T) {
			want, err := os.ReadFile(strings.TrimSuffix(seed, ".cla") + ".err")
			if err != nil {
				t.Fatal(err)
			}

			bin := emitBuild(t, exe, seed)
			cmd := exec.Command(bin)
			cmd.Dir = t.TempDir()
			var stderr bytes.Buffer
			cmd.Stderr = &stderr
			runErr := cmd.Run()

			ee, ok := runErr.(*exec.ExitError)
			if !ok || ee.ExitCode() != 3 {
				t.Fatalf("want exit 3, got %v (stderr: %s)", runErr, stderr.String())
			}
			if !strings.Contains(stderr.String(), strings.TrimSpace(string(want))) {
				t.Errorf("stderr %q missing %q", stderr.String(), want)
			}
		})
	}
}
