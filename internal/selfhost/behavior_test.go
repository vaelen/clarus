// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// behavior_test.go: test-suite-review Task 3's Go-free behavior oracle.
// TestBehaviorGoldens bootstraps clarusc from the committed C snapshot
// (clarusc/clarusc.c, compiled with `cc` alone -- the exact recipe
// internal/perfgate/perfgate_test.go's buildClarusc and
// scripts/build-68k.sh:45-48 already use, duplicated locally per this
// repo's cross-package-helper convention rather than imported), then for
// every fixture in the runnable corpus (testdata/run, testdata/runerr --
// the two directories that are actually EXECUTED, as opposed to
// testdata/{valid,errors,include,diag}, which internal/selfhost's own
// TestDifferential/TestDifferentialFences only check/diagnose) emits C via
// `clarusc emit`, compiles it with `cc` against the on-disk runtime
// sources, and runs the result. No package under internal/ that implements
// the Clarus front end (lexer/parser/check/types/lower/cprint/build/...)
// is imported or invoked anywhere in this file.
//
// Each fixture's captured (exit, stdout, stderr) is compared against a
// committed <fixture-base>.behavior golden -- a parallel, clarusc-owned
// record, distinct from the Go-compiler-owned testdata/run/*.out (and
// friends) goldens internal/build/golden_test.go's TestRunGoldens and
// internal/selfhost/emit_test.go's TestEmitDifferential already hold the
// Go-built pipeline to. Where a fixture already has a .out/.exit/.log/.err
// golden, this test ALSO asserts the snapshot-built run agrees with it (a
// free consistency check between the two independently-built compilers).
// CLARUS_BLESS_BEHAVIOR=1 (re)writes the .behavior goldens instead of
// comparing against them.
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
)

var (
	snapshotClaruscOnce sync.Once
	snapshotClaruscExe  string
	snapshotClaruscErr  error
	snapshotClaruscSkip string
)

// repoRootBehavior returns the repo root computed from this package's
// directory (go test's cwd is always the package dir) -- duplicated from
// internal/perfgate/perfgate_test.go's own repoRoot per this file's header
// comment; named to avoid colliding with a future package-level repoRoot.
func repoRootBehavior(t *testing.T) string {
	t.Helper()
	wd, err := os.Getwd()
	if err != nil {
		t.Fatalf("getwd: %v", err)
	}
	return filepath.Join(wd, "..", "..")
}

// bootstrapSnapshotClarusc compiles the committed clarusc/clarusc.c
// snapshot straight to a binary with `cc` alone -- no Go, no
// build.RuntimeC()-style embedded copies, no prior Clarus binary. Mirrors
// perfgate's buildClarusc (including its LookPath("cc") skip), memoized
// with sync.Once since every fixture in the corpus reuses the same exe.
func bootstrapSnapshotClarusc(t *testing.T) string {
	t.Helper()
	snapshotClaruscOnce.Do(func() {
		if _, err := exec.LookPath("cc"); err != nil {
			snapshotClaruscSkip = "cc not found on PATH, skipping Go-free behavior goldens"
			return
		}
		root := repoRootBehavior(t)
		dir, err := os.MkdirTemp("", "clarusc-snapshot-*")
		if err != nil {
			snapshotClaruscErr = err
			return
		}
		exe := filepath.Join(dir, "clarusc")
		cmd := exec.Command("cc", "-O1", "-I", filepath.Join(root, "internal", "build", "rt"),
			"-o", exe,
			filepath.Join(root, "clarusc", "clarusc.c"),
			filepath.Join(root, "internal", "build", "rt", "rt.c"))
		if out, err := cmd.CombinedOutput(); err != nil {
			snapshotClaruscErr = fmt.Errorf("bootstrap clarusc from snapshot: %v\n%s", err, out)
			return
		}
		snapshotClaruscExe = exe
	})
	if snapshotClaruscSkip != "" {
		t.Skip(snapshotClaruscSkip)
	}
	if snapshotClaruscErr != nil {
		t.Fatal(snapshotClaruscErr)
	}
	return snapshotClaruscExe
}

// runBehaviorFixture emits claPath's C with the snapshot-bootstrapped
// clarusc, compiles it with `cc` against the on-disk runtime sources
// (internal/build/rt/rt.c -- not the Go-embedded build.RuntimeC() copies),
// and runs the resulting binary with argv. cwd is a fresh temp dir per run
// (fixtures like files.cla touch the filesystem and must not race or
// litter the source tree, same discipline internal/build/golden_test.go's
// TestRunGoldens already follows).
func runBehaviorFixture(t *testing.T, claruscExe, root, claPath string, argv []string) (exit int, stdout, stderr []byte) {
	t.Helper()
	work := t.TempDir()
	outC := filepath.Join(work, "out.c")
	rtDir := filepath.Join(root, "runtime", "clarus") + string(filepath.Separator)

	emit := exec.Command(claruscExe, "emit", "--rtdir", rtDir, "-o", outC, claPath)
	if out, err := emit.CombinedOutput(); err != nil {
		t.Fatalf("clarusc emit %s: %v\n%s", claPath, err, out)
	}

	bin := filepath.Join(work, "prog")
	cc := exec.Command("cc", "-O1", "-I", filepath.Join(root, "internal", "build", "rt"),
		outC, filepath.Join(root, "internal", "build", "rt", "rt.c"), "-o", bin)
	if out, err := cc.CombinedOutput(); err != nil {
		t.Fatalf("cc compile emitted C for %s: %v\n%s", claPath, err, out)
	}

	run := exec.Command(bin, argv...)
	run.Dir = t.TempDir()
	var outBuf, errBuf bytes.Buffer
	run.Stdout = &outBuf
	run.Stderr = &errBuf
	runErr := run.Run()
	if runErr != nil {
		ee, ok := runErr.(*exec.ExitError)
		if !ok {
			t.Fatalf("run emitted binary for %s: %v", claPath, runErr)
		}
		exit = ee.ExitCode()
	}
	return exit, outBuf.Bytes(), errBuf.Bytes()
}

// behaviorBlob composes the single-file .behavior golden format: an exit
// line followed by delimited raw stdout/stderr. No corpus fixture's own
// output contains the delimiter lines, so a plain byte-compare (no
// parsing) suffices both to write and to check the golden.
func behaviorBlob(exit int, stdout, stderr []byte) []byte {
	var b bytes.Buffer
	fmt.Fprintf(&b, "exit=%d\n--- stdout ---\n", exit)
	b.Write(stdout)
	b.WriteString("--- stderr ---\n")
	b.Write(stderr)
	return b.Bytes()
}

// checkBehaviorGolden compares (or, under bless, writes) path against the
// captured (exit, stdout, stderr) as a behaviorBlob.
func checkBehaviorGolden(t *testing.T, path string, bless bool, exit int, stdout, stderr []byte) {
	t.Helper()
	got := behaviorBlob(exit, stdout, stderr)
	if bless {
		if err := os.WriteFile(path, got, 0o644); err != nil {
			t.Fatalf("write behavior golden %s: %v", path, err)
		}
		return
	}
	want, err := os.ReadFile(path)
	if err != nil {
		t.Fatalf("read behavior golden %s (run CLARUS_BLESS_BEHAVIOR=1 to create it): %v", path, err)
	}
	if !bytes.Equal(got, want) {
		t.Errorf("behavior golden %s mismatch:\n got: %q\nwant: %q", path, got, want)
	}
}

// runnableFixtures globs the runnable corpus (testdata/run, testdata/runerr
// -- the two directories actually EXECUTED, as opposed to
// testdata/{valid,errors,include,diag}). Factored out of
// TestBehaviorGoldens so crossgen_test.go's TestCrossGenDifferential
// (test-suite-review Task 4) can reuse the same enumeration.
func runnableFixtures(t *testing.T) (runFiles, runerrFiles []string) {
	t.Helper()
	runFiles, _ = filepath.Glob("../../testdata/run/*.cla")
	runerrFiles, _ = filepath.Glob("../../testdata/runerr/*.cla")
	if len(runFiles) == 0 {
		t.Fatal("no testdata/run fixtures found")
	}
	if len(runerrFiles) == 0 {
		t.Fatal("no testdata/runerr fixtures found")
	}
	return runFiles, runerrFiles
}

// TestBehaviorGoldens is the Go-free drift arbiter: for every fixture in
// the runnable corpus (testdata/run, testdata/runerr), the snapshot-
// bootstrapped clarusc emits + compiles + runs it, and the captured
// behavior is checked against a committed <base>.behavior golden (or, with
// CLARUS_BLESS_BEHAVIOR=1, written). Where the fixture already carries a
// .out/.exit/.log (testdata/run) or .err (testdata/runerr) golden owned by
// the Go-compiler test suites, this also cross-checks against those as a
// free consistency check between the two independently-built compilers --
// even while blessing, since that check is independent of the new golden.
func TestBehaviorGoldens(t *testing.T) {
	exe := bootstrapSnapshotClarusc(t)
	root := repoRootBehavior(t)
	bless := os.Getenv("CLARUS_BLESS_BEHAVIOR") == "1"

	runFiles, runerrFiles := runnableFixtures(t)

	for _, f := range runFiles {
		f := f
		t.Run("run/"+filepath.Base(f), func(t *testing.T) {
			base := strings.TrimSuffix(f, ".cla")

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

			exit, stdout, stderr := runBehaviorFixture(t, exe, root, f, argv)

			if exit != wantExit {
				t.Errorf("exit: got %d want %d (stderr: %s)", exit, wantExit, stderr)
			}
			if wantOut, err := os.ReadFile(base + ".out"); err == nil && string(stdout) != string(wantOut) {
				t.Errorf("stdout vs %s.out golden mismatch:\n got: %q\nwant: %q", base, stdout, wantOut)
			}
			if wantLog, err := os.ReadFile(base + ".log"); err == nil && string(stderr) != string(wantLog) {
				t.Errorf("stderr vs %s.log golden mismatch:\n got: %q\nwant: %q", base, stderr, wantLog)
			}

			checkBehaviorGolden(t, base+".behavior", bless, exit, stdout, stderr)
		})
	}

	for _, f := range runerrFiles {
		f := f
		t.Run("runerr/"+filepath.Base(f), func(t *testing.T) {
			base := strings.TrimSuffix(f, ".cla")
			wantErr, err := os.ReadFile(base + ".err")
			if err != nil {
				t.Fatal(err)
			}

			exit, stdout, stderr := runBehaviorFixture(t, exe, root, f, nil)

			if exit != 3 {
				t.Errorf("exit: got %d want 3 (stderr: %s)", exit, stderr)
			}
			if !strings.Contains(string(stderr), strings.TrimSpace(string(wantErr))) {
				t.Errorf("stderr %q missing %q", stderr, wantErr)
			}

			checkBehaviorGolden(t, base+".behavior", bless, exit, stdout, stderr)
		})
	}
}
