package selfhost

import (
	"bytes"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"testing"

	"clarus/internal/build"
	"clarus/internal/claruscboot"
)

// snapshotPath is the committed ground-floor bootstrap artifact: the C that
// clarusc emits for its own source (clarusc/main.cla), checked into the repo
// so clarusc can be rebuilt by `cc` alone -- no Go, no prior Clarus binary.
const snapshotPath = "../../clarusc/clarusc.c"

// readSnapshot reads the committed clarusc/clarusc.c.
func readSnapshot(t *testing.T) []byte {
	t.Helper()
	b, err := os.ReadFile(snapshotPath)
	if err != nil {
		t.Fatalf("read committed snapshot %s: %v", snapshotPath, err)
	}
	return b
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
	if err := os.WriteFile(filepath.Join(dir, "rt_ser.inc"), build.RuntimeSerInc(), 0o644); err != nil {
		return "", err
	}
	if err := os.WriteFile(filepath.Join(dir, "rt_mem.h"), build.RuntimeMemH(), 0o644); err != nil {
		return "", err
	}
	if err := os.WriteFile(filepath.Join(dir, "rt_mem_host.inc"), build.RuntimeMemHostInc(), 0o644); err != nil {
		return "", err
	}
	if err := os.WriteFile(filepath.Join(dir, "rt_core.inc"), build.RuntimeCoreInc(), 0o644); err != nil {
		return "", err
	}
	if err := os.WriteFile(filepath.Join(dir, "rt_ext_host.inc"), build.RuntimeExtHostInc(), 0o644); err != nil {
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

// runClarusc runs the built clarusc on path (relative to this package's
// directory) and returns its stdout and exit code.
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

// TestSnapshotBuilds proves the committed clarusc/clarusc.c ALONE reproduces
// a working clarusc: compile it (as committed, not a fresh emission) with cc
// + rt.c, then run the resulting binary as a checker over a small sample of
// the corpus and assert its stdout + exit code match the current-source
// clarusc exactly (whose own correctness the behavior goldens and crossgen
// differential pin). No Go compiler and no prior Clarus binary are used.
func TestSnapshotBuilds(t *testing.T) {
	snapshot := readSnapshot(t)
	bin := compileC(t, snapshot)
	curExe := claruscboot.CurrentExe(t)

	files := []string{
		"../../testdata/diag/chk_undefined.cla",
		"../../testdata/diag/chk_typemismatch.cla",
		"../../testdata/valid/bookmarks.cla",
	}
	for _, f := range files {
		f := f
		t.Run(f, func(t *testing.T) {
			wantOut, wantCode := runClarusc(t, curExe, f)
			gotOut, gotCode := runClarusc(t, bin, f)
			if gotOut != wantOut || gotCode != wantCode {
				t.Errorf("divergence on %s\n  current-source    (exit %d): %q\n  snapshot-built cc (exit %d): %q",
					f, wantCode, wantOut, gotCode, gotOut)
			}
		})
	}
}
