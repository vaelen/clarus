// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// behavior_test.go: test-suite-review Task 3's Go-free behavior oracle.
// TestBehaviorGoldens bootstraps clarusc from the committed C snapshot via
// claruscboot.SnapshotExe (the shared Go-free bootstrap's stage 1 --
// Go-compiler-deletion phase; was a locally duplicated `cc -O1` snapshot
// build), then for every fixture in the runnable corpus (testdata/run,
// testdata/runerr -- the two directories that are actually EXECUTED, as
// opposed to testdata/{valid,errors,include,diag}, which this package's
// now-deleted Go-differential lanes used to check/diagnose) emits C via
// `clarusc emit`, compiles it with `cc` against the on-disk runtime
// sources, and runs the result. No package under internal/ that implements
// a Clarus front end is imported or invoked anywhere in this file --
// clarusc IS the front end now, there is no other one.
//
// Each fixture's captured (exit, stdout, stderr) is compared against a
// committed <fixture-base>.behavior golden. Where a fixture already has a
// .out/.exit/.log/.err golden (left over from the deleted Go-compiler
// suites but still meaningful as a second, independent expectation), this
// test ALSO asserts the snapshot-built run agrees with it. CLARUS_BLESS_
// BEHAVIOR=1 (re)writes the .behavior goldens instead of comparing against
// them.
package selfhost

import (
	"bytes"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
	"testing"

	"clarus/internal/claruscboot"
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

// bootstrapSnapshotClarusc returns the snapshot-lineage clarusc (stage 1
// of the shared bootstrap). Behavior goldens and the crossgen/fixed-point
// comparisons are ABOUT the snapshot lineage, so this is deliberately NOT
// CurrentExe -- the one place in the tree that wants SnapshotExe.
func bootstrapSnapshotClarusc(t *testing.T) string {
	t.Helper()
	return claruscboot.SnapshotExe(t)
}

// runBehaviorFixture emits claPath's C with the snapshot-bootstrapped
// clarusc, compiles it with `cc` against the on-disk runtime sources
// (runtime/host/rt.c -- not a Go-embedded copy),
// and runs the resulting binary with argv. cwd is a fresh temp dir per run
// (fixtures like files.cla touch the filesystem and must not race or
// litter the source tree, same discipline internal/build/golden_test.go's
// TestRunGoldens already follows).
//
// memCheck, when true, runs the binary under CLARUS_MEM_STRICT=1 +
// CLARUS_MEM_PARANOID=1 (the same paranoid-allocator combo the now-deleted
// emit_test.go's TestEmitDifferential used before it became a Go lane) and
// returns the report's path as memReportPath, for checkMemReport (below)
// to compare against a fixture's .leaks golden -- this is
// how the memory-safety pin (test-suite-review Task 5b's
// for_loop_var_alias.leaks) stays enforced in the default, Go-free
// gauntlet. Callers that don't need it (runerr fixtures abort via
// rt_panic's non-unwinding exit(3), so a leak count there would just
// measure call-stack depth at the panic site, not a real leak; and
// crossgen_test.go's generation comparison doesn't need it either) pass
// false and ignore the returned path.
func runBehaviorFixture(t *testing.T, claruscExe, root, claPath string, argv []string, memCheck bool) (exit int, stdout, stderr []byte, memReportPath string) {
	t.Helper()
	work := t.TempDir()
	outC := filepath.Join(work, "out.c")
	rtDir := filepath.Join(root, "runtime", "clarus") + string(filepath.Separator)

	emit := exec.Command(claruscExe, "emit", "--rtdir", rtDir, "-o", outC, claPath)
	if out, err := emit.CombinedOutput(); err != nil {
		t.Fatalf("clarusc emit %s: %v\n%s", claPath, err, out)
	}

	bin := filepath.Join(work, "prog")
	cc := exec.Command("cc", "-O1", "-I", filepath.Join(root, "runtime", "host"),
		outC, filepath.Join(root, "runtime", "host", "rt.c"), "-o", bin)
	if out, err := cc.CombinedOutput(); err != nil {
		t.Fatalf("cc compile emitted C for %s: %v\n%s", claPath, err, out)
	}

	run := exec.Command(bin, argv...)
	run.Dir = t.TempDir()
	if memCheck {
		memReportPath = filepath.Join(work, "mem.txt")
		run.Env = append(os.Environ(), "CLARUS_MEM_STRICT=1", "CLARUS_MEM_PARANOID=1", "CLARUS_MEM_REPORT="+memReportPath)
	}
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
	return exit, outBuf.Bytes(), errBuf.Bytes(), memReportPath
}

// checkMemReport reads the rt_mem strict-mode leak report written by the
// just-run binary (see rt_mem_host.inc's rt_mem_exit_check for the exact
// "##CLARUS-MEM## live=<N>" + per-block "rt_mem: leak <tag> (<size> bytes)"
// format) and compares the live count against leaksPath's expected integer
// (0 if leaksPath doesn't exist -- most programs should free everything).
// On mismatch it fails with the full report, whose per-block tag lines say
// exactly what leaked and where it was allocated.
func checkMemReport(t *testing.T, reportPath, leaksPath string) {
	t.Helper()
	report, err := os.ReadFile(reportPath)
	if err != nil {
		t.Fatalf("runtime wrote no mem report — is STRICT plumbed? (%v)", err)
	}

	wantLeaks := 0
	if s, err := os.ReadFile(leaksPath); err == nil {
		wantLeaks, err = strconv.Atoi(strings.TrimSpace(string(s)))
		if err != nil {
			t.Fatalf("bad .leaks: %v", err)
		}
	}

	firstLine, _, _ := strings.Cut(string(report), "\n")
	var gotLeaks int
	if _, err := fmt.Sscanf(firstLine, "##CLARUS-MEM## live=%d", &gotLeaks); err != nil {
		t.Fatalf("mem report missing ##CLARUS-MEM## header: %q", string(report))
	}
	if gotLeaks != wantLeaks {
		t.Errorf("live leaks: got %d want %d\n--- mem report ---\n%s", gotLeaks, wantLeaks, string(report))
	}
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

			exit, stdout, stderr, memReportPath := runBehaviorFixture(t, exe, root, f, argv, true)

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
			checkMemReport(t, memReportPath, base+".leaks")
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

			exit, stdout, stderr, _ := runBehaviorFixture(t, exe, root, f, nil, false)

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
