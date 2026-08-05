package selfhost

import (
	"bytes"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"

	"clarus/internal/claruscboot"
)

// hostRTDir is the repo-relative on-disk host C runtime this package
// copies from for its hermetic compiles (rt.c #includes the other
// non-test files here as siblings, so a dir-list copy preserves that
// layout without hand-naming each one -- //go:embed can't reach outside
// its own package dir, which is why this package reads runtime/host/
// from disk instead of embedding it).
const hostRTDir = "../../runtime/host"

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

// compileCDir is the dir-taking core of compileC: it writes cBytes plus a
// copy of the on-disk host runtime (runtime/host/*, minus its *_test.c
// harness sources) into dir and compiles them with the same toolchain and
// flags claruscboot uses. It returns the built binary's path, or an error
// (never t.Fatalf) -- same memoization rationale as emitCDir.
func compileCDir(cBytes []byte, dir string) (string, error) {
	mainC := filepath.Join(dir, "main.c")
	if err := os.WriteFile(mainC, cBytes, 0o644); err != nil {
		return "", err
	}
	entries, err := os.ReadDir(hostRTDir)
	if err != nil {
		return "", err
	}
	for _, e := range entries {
		name := e.Name()
		if e.IsDir() || strings.HasSuffix(name, "_test.c") {
			continue
		}
		b, err := os.ReadFile(filepath.Join(hostRTDir, name))
		if err != nil {
			return "", err
		}
		if err := os.WriteFile(filepath.Join(dir, name), b, 0o644); err != nil {
			return "", err
		}
	}

	rtC := filepath.Join(dir, "rt.c")
	bin := filepath.Join(dir, "prog")
	cc := exec.Command(claruscboot.CCPath(), "-std=c99", "-O1", mainC, rtC, "-o", bin)
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
