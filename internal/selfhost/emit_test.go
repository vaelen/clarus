package selfhost

import (
	"bytes"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
	"testing"

	"clarus/internal/build"
)

// emitBuild runs `clarusc emit claPath`, captures its stdout as one C
// translation unit, writes it alongside the embedded host runtime (rt.h/rt.c
// from internal/build) into a temp dir, and compiles them with the same
// toolchain and flags internal/build uses. It returns the built binary's path.
func emitBuild(t *testing.T, exe, claPath string) string {
	t.Helper()

	cmd := exec.Command(exe, "emit", claPath)
	var out, errb bytes.Buffer
	cmd.Stdout = &out
	cmd.Stderr = &errb
	if err := cmd.Run(); err != nil {
		t.Fatalf("clarusc emit %s: %v\nstderr: %s", claPath, err, errb.String())
	}

	dir := t.TempDir()
	mainC := filepath.Join(dir, "main.c")
	rtC := filepath.Join(dir, "rt.c")
	if err := os.WriteFile(mainC, out.Bytes(), 0o644); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(filepath.Join(dir, "rt.h"), build.RuntimeH(), 0o644); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(rtC, build.RuntimeC(), 0o644); err != nil {
		t.Fatal(err)
	}

	bin := filepath.Join(dir, "prog")
	cc := exec.Command(build.CCPath(), "-std=c99", "-O1", mainC, rtC, "-o", bin)
	if ccOut, err := cc.CombinedOutput(); err != nil {
		t.Fatalf("cc rejected clarusc-emitted C: %v\n%s\n--- emitted C ---\n%s", err, ccOut, out.String())
	}
	return bin
}

// TestEmitDifferential is the walking-skeleton gate: clarusc emits C for a
// seed golden, that C compiles and links against the host runtime, and the
// resulting binary's stdout + exit code match the golden's .out/.exit (with
// .args/.exit handled exactly as internal/build's run goldens).
func TestEmitDifferential(t *testing.T) {
	exe, err := buildClarusc()
	if err != nil {
		t.Fatalf("build clarusc: %v", err)
	}

	const seed = "../../testdata/run/emit_hello.cla"
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
}
