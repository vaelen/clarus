// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

package mactest

import (
	"bufio"
	"bytes"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
	"testing"
)

// TestLeakGate pins the memory-leak-fix phase (docs/superpowers/plans/
// 2026-08-12-memory-leak-fix.md): the compiler must not retain heap
// blocks across compiles in one process, and .clear()/store-temp
// machinery must not leak. Host-lane only (uses runtime/host's
// CLARUS_MEM_STRICT ledger); the native lane is covered by parity
// goldens + the gated suite boots.
func TestLeakGate(t *testing.T) {
	t.Run("StoreTemps", func(t *testing.T) {
		runLeakFixture(t, "../../testdata/leakgate/stemp.cla")
	})
	t.Run("ArrStore", func(t *testing.T) {
		// fix-round-1 regression: a rec-bearing KArr __store temp (whole
		// fixed-array assignment of handle-bearing record elements) --
		// see testdata/leakgate/arrstore.cla's own doc comment. Must cc
		// build clean (the miscompile this pins was a build-time cc
		// error, not a runtime leak) and report zero live blocks.
		runLeakFixture(t, "../../testdata/leakgate/arrstore.cla")
	})
	t.Run("ClearRefElems", func(t *testing.T) {
		runLeakFixture(t, "../../testdata/leakgate/clearprobe.cla")
	})
	t.Run("ArrElem", func(t *testing.T) {
		// fix-round-1 regression: cgContainerElemNeedsWalk/
		// cgContainerElemRelease (native) and cpEmitRelease/
		// cpEmitElemReleaseWalk's per-kind branches (host) had no KArr
		// arm -- a `list of Item[3]` (or the map/sortedmap/intmap
		// value-type equivalent) silently skipped releasing the
		// record-held text handles packed inside each array-typed
		// slot/value, on both the `.clear()` Deep walk and the
		// pre-existing scope-exit teardown walk. See
		// testdata/leakgate/arrelem.cla's own doc comment for why it
		// uses Item[3] (array-of-record) rather than text[3]
		// (array-of-text): the latter hits a separate, pre-existing,
		// out-of-this-fix-round's-scope push/set-retain gap.
		runLeakFixture(t, "../../testdata/leakgate/arrelem.cla")
	})
	t.Run("DoubleCompile", func(t *testing.T) {
		runDoubleCompileGate(t)
	})
	t.Run("DoubleCompileBake", func(t *testing.T) {
		runDoubleCompileGateBake(t)
	})
	t.Run("DoubleCompileAbortRecovery", func(t *testing.T) {
		runDoubleCompileAbortGate(t)
	})
}

// TestAbortLeakBaseline pins the attempt-abort phase's own leak
// guarantee (design doc %7's "Leak proof": no runtime mark stack, no
// setjmp -- release happens via ordinary ARC as the abort propagates
// frame by frame, so it must be exactly as leak-free as a normal
// return). testdata/leakgate/abortbaseline.cla loops three shapes 500
// times each: the brief's own "AbortRelease" shape (a retained `text`
// local in a middle frame the abort unwinds through), plus the two
// leak-gap classes task-1-report's P5 probe specifically flagged and
// this task's own probing confirmed as REAL (task-5-report.md):
//
//   - probe (a): a heap-typed function return whose synthetic return
//     temp (lowNewReturnTemp's __retN) is prologue-birthed but never
//     released when the function aborts before its own `return`
//     executes -- was live=4000 for 2000 iters before the fix
//     (lower.cla's lowFuncBody/lowBuildAbortBailBlock), live=0 after.
//   - probe (b): a mid-statement transient temp (e.g. `x = makeText() +
//     f()`, `f` aborts) that the abort check's `goto` abandons before
//     the ordinary end-of-statement flush ever runs -- fixed in both
//     backends' abort-check emission (cg68k.cla's cgEmitAbortCheck,
//     cprint.cla's fpEmitAbortCheck).
//
// Host-lane only (CLARUS_MEM_STRICT), same as every other TestLeakGate
// case -- the native lane's own leak behavior is covered by the
// (emulator-gated, deferred per this task's brief) suite boots.
func TestAbortLeakBaseline(t *testing.T) {
	runLeakFixture(t, "../../testdata/leakgate/abortbaseline.cla")
}

// parseLiveCount reads a CLARUS_MEM_REPORT file and returns the
// "##CLARUS-MEM## live=N" total, plus up to the first 20 "rt_mem: leak"
// lines (for a failing assertion's diagnostic dump).
func parseLiveCount(t *testing.T, reportPath string) (int, []string) {
	t.Helper()
	f, err := os.Open(reportPath)
	if err != nil {
		t.Fatalf("open mem report %s: %v", reportPath, err)
	}
	defer f.Close()

	live := -1
	var leaks []string
	sc := bufio.NewScanner(f)
	for sc.Scan() {
		line := sc.Text()
		if n, ok := strings.CutPrefix(line, "##CLARUS-MEM## live="); ok {
			v, err := strconv.Atoi(n)
			if err != nil {
				t.Fatalf("parse live count %q: %v", line, err)
			}
			live = v
			continue
		}
		if strings.HasPrefix(line, "rt_mem: leak") && len(leaks) < 20 {
			leaks = append(leaks, line)
		}
	}
	if err := sc.Err(); err != nil {
		t.Fatalf("scan mem report %s: %v", reportPath, err)
	}
	if live < 0 {
		t.Fatalf("mem report %s has no ##CLARUS-MEM## line", reportPath)
	}
	return live, leaks
}

// runLeakFixture builds claPath (single-file, host oracle; package-dir-
// relative, e.g. "../../testdata/leakgate/stemp.cla" -- go test always
// runs with cwd == the package dir, so this resolves without joining
// against repoRoot) and runs it under CLARUS_MEM_STRICT, asserting zero
// live blocks at exit.
func runLeakFixture(t *testing.T, claPath string) {
	t.Helper()
	exe := buildHostFromFixture(t, claPath, "leakfixture")

	work := t.TempDir()
	reportPath := filepath.Join(work, "report.txt")
	cmd := exec.Command(exe)
	cmd.Dir = work
	cmd.Env = append(os.Environ(),
		"CLARUS_MEM_STRICT=1",
		"CLARUS_MEM_REPORT="+reportPath)
	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	if err := cmd.Run(); err != nil {
		t.Fatalf("run %s: %v\nstdout: %s\nstderr: %s", claPath, err, stdout.String(), stderr.String())
	}

	live, leaks := parseLiveCount(t, reportPath)
	if live != 0 {
		t.Fatalf("%s: live=%d blocks at exit, want 0\n%s", claPath, live, strings.Join(leaks, "\n"))
	}
}

// buildDblcompile builds clarusc/test/dblcompile.cla (self-contained via
// its own includes) and returns the exe path.
func buildDblcompile(t *testing.T) string {
	t.Helper()
	root := repoRoot(t)
	return buildHostFromFixture(t, filepath.Join(root, "clarusc", "test", "dblcompile.cla"), "dblcompile")
}

// runDblcompileOnce runs exe with the given argv (entry .cla paths) in
// workDir, under CLARUS_MEM_STRICT, and returns the parsed live count.
// workDir must sit close enough under the repo root for dblcompile's own
// nested clarusc.findRtDir walk-up ("../" up to 10 times) to locate
// runtime/clarus/ at run time -- this is a SECOND, runtime-only runtime
// lookup, distinct from the --rtdir baked into the harness binary itself
// at build time (that one only serves the harness program's OWN runtime
// needs, not the nested compiles it drives).
func runDblcompileOnce(t *testing.T, exe, workDir string, argv []string) int {
	t.Helper()
	reportPath := filepath.Join(workDir, "report.txt")
	cmd := exec.Command(exe, argv...)
	cmd.Dir = workDir
	cmd.Env = append(os.Environ(),
		"CLARUS_MEM_STRICT=1",
		"CLARUS_MEM_REPORT="+reportPath)
	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	if err := cmd.Run(); err != nil {
		t.Fatalf("run dblcompile %v: %v\nstdout: %s\nstderr: %s", argv, err, stdout.String(), stderr.String())
	}
	live, _ := parseLiveCount(t, reportPath)
	return live
}

// runDoubleCompileGate proves the compiler doesn't retain heap blocks
// across repeated in-process compiles: compile the same entry once, then
// three times, and require the live-block growth per extra compile to
// stay near zero (a small allowance for genuinely process-lifetime
// state). Also byte-compares the first and third fork of the 3-compile
// run -- the stale-intern-index oracle.
func runDoubleCompileGate(t *testing.T) {
	t.Helper()
	root := repoRoot(t)
	exe := buildDblcompile(t)
	tickprobe := filepath.Join(root, "testdata", "cg68k", "tickprobe.cla")

	// workDir must live under the repo tree (not the system tempdir) so
	// dblcompile's runtime-side findRtDir walk-up can find runtime/clarus/.
	scratchRoot := filepath.Join(root, "build-run")
	if err := os.MkdirAll(scratchRoot, 0o755); err != nil {
		t.Fatalf("mkdir %s: %v", scratchRoot, err)
	}

	work1, err := os.MkdirTemp(scratchRoot, "leakgate-1x-")
	if err != nil {
		t.Fatalf("mkdtemp: %v", err)
	}
	defer os.RemoveAll(work1)
	live1 := runDblcompileOnce(t, exe, work1, []string{tickprobe})

	work3, err := os.MkdirTemp(scratchRoot, "leakgate-3x-")
	if err != nil {
		t.Fatalf("mkdtemp: %v", err)
	}
	defer os.RemoveAll(work3)
	live3 := runDblcompileOnce(t, exe, work3, []string{tickprobe, tickprobe, tickprobe})

	growthPerCompile := (live3 - live1) / 2
	if growthPerCompile > 64 {
		t.Fatalf("live-block growth per extra compile = %d (live1=%d live3=%d), want <= 64", growthPerCompile, live1, live3)
	}

	fork0, err := os.ReadFile(filepath.Join(work3, "leakfork_0.bin"))
	if err != nil {
		t.Fatalf("read leakfork_0.bin: %v", err)
	}
	fork2, err := os.ReadFile(filepath.Join(work3, "leakfork_2.bin"))
	if err != nil {
		t.Fatalf("read leakfork_2.bin: %v", err)
	}
	if !bytes.Equal(fork0, fork2) {
		t.Fatalf("leakfork_0.bin (%d bytes) != leakfork_2.bin (%d bytes): stale state leaked into the 3rd compile's fork", len(fork0), len(fork2))
	}

	// Strictly stronger oracle: alternate a DIFFERENT fixture into the
	// middle slot (tickprobe, catprobe, tickprobe) so the byte-identity
	// check can't be satisfied by trivially re-running the exact same
	// compile three times -- it proves no state survives a compile of a
	// DIFFERENT entry, not just repeats of the same one.
	catprobe := filepath.Join(root, "testdata", "mac-resident", "catprobe.cla")
	workAlt, err := os.MkdirTemp(scratchRoot, "leakgate-3x-alt-")
	if err != nil {
		t.Fatalf("mkdtemp: %v", err)
	}
	defer os.RemoveAll(workAlt)
	liveAlt := runDblcompileOnce(t, exe, workAlt, []string{tickprobe, catprobe, tickprobe})

	growthPerCompileAlt := (liveAlt - live1) / 2
	if growthPerCompileAlt > 64 {
		t.Fatalf("alternating-fixture live-block growth per extra compile = %d (live1=%d liveAlt=%d), want <= 64", growthPerCompileAlt, live1, liveAlt)
	}

	forkAlt0, err := os.ReadFile(filepath.Join(workAlt, "leakfork_0.bin"))
	if err != nil {
		t.Fatalf("read leakfork_0.bin (alt): %v", err)
	}
	forkAlt2, err := os.ReadFile(filepath.Join(workAlt, "leakfork_2.bin"))
	if err != nil {
		t.Fatalf("read leakfork_2.bin (alt): %v", err)
	}
	if !bytes.Equal(forkAlt0, forkAlt2) {
		t.Fatalf("alternating run: leakfork_0.bin (%d bytes) != leakfork_2.bin (%d bytes): stale state leaked across a different-fixture compile", len(forkAlt0), len(forkAlt2))
	}
}

// runDoubleCompileAbortGate is final-review I3's own oracle: proves an
// abort() firing INSIDE one compile leaves no abort-state global stale
// for the NEXT compile in the same process -- the host-side, seconds-
// not-hours twin of the deferred TestMacResidentFailedCompileStaysAliveOnSnow.
// dblcompile.cla now wraps its own per-entry driveCompile/driveEmit68kFork
// call in `attempt`/`aborted` (mirroring macgui.cla's real gcCompile),
// so [tickprobe, badabort, tickprobe] compiles tickprobe, then hits
// badabort's deterministic "attempt nesting exceeds cgBailTargets' fixed
// depth (32)" abort (cg68k.cla, during driveEmit68kFork's own codegen),
// catches it, logs, and moves on to the third entry instead of quitting
// the whole harness. Asserts the harness exits 0 (the abort was caught,
// not left uncaught to hit dblcompile's own top-level default), the
// expected ABORTED line reached stdout, and leakfork_0.bin (tickprobe
// #1) is byte-identical to leakfork_2.bin (tickprobe #2, compiled
// immediately after the aborted compile).
func runDoubleCompileAbortGate(t *testing.T) {
	t.Helper()
	root := repoRoot(t)
	exe := buildDblcompile(t)
	tickprobe := filepath.Join(root, "testdata", "cg68k", "tickprobe.cla")
	badabort := filepath.Join(root, "testdata", "mac-resident", "badabort.cla")

	scratchRoot := filepath.Join(root, "build-run")
	if err := os.MkdirAll(scratchRoot, 0o755); err != nil {
		t.Fatalf("mkdir %s: %v", scratchRoot, err)
	}
	work, err := os.MkdirTemp(scratchRoot, "leakgate-abort-")
	if err != nil {
		t.Fatalf("mkdtemp: %v", err)
	}
	defer os.RemoveAll(work)

	reportPath := filepath.Join(work, "report.txt")
	cmd := exec.Command(exe, tickprobe, badabort, tickprobe)
	cmd.Dir = work
	cmd.Env = append(os.Environ(),
		"CLARUS_MEM_STRICT=1",
		"CLARUS_MEM_REPORT="+reportPath)
	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	if err := cmd.Run(); err != nil {
		t.Fatalf("run dblcompile [tickprobe, badabort, tickprobe]: %v\nstdout: %s\nstderr: %s", err, stdout.String(), stderr.String())
	}

	const wantMsg = "ABORTED: cg68k: attempt nesting exceeds cgBailTargets' fixed depth (32)"
	if !strings.Contains(stderr.String(), wantMsg) {
		t.Fatalf("expected badabort's caught-abort line in dblcompile's log output, got:\n%s", stderr.String())
	}

	fork0, err := os.ReadFile(filepath.Join(work, "leakfork_0.bin"))
	if err != nil {
		t.Fatalf("read leakfork_0.bin: %v", err)
	}
	fork2, err := os.ReadFile(filepath.Join(work, "leakfork_2.bin"))
	if err != nil {
		t.Fatalf("read leakfork_2.bin: %v", err)
	}
	if !bytes.Equal(fork0, fork2) {
		t.Fatalf("leakfork_0.bin (%d bytes) != leakfork_2.bin (%d bytes): abort-state leaked into the post-abort compile", len(fork0), len(fork2))
	}
}

// buildDblcompileBake builds clarusc/test/dblcompile_bake.cla (the
// --rtbake twin of dblcompile.cla, runtime-ir-bake Task 4) and returns
// the exe path.
func buildDblcompileBake(t *testing.T) string {
	t.Helper()
	root := repoRoot(t)
	return buildHostFromFixture(t, filepath.Join(root, "clarusc", "test", "dblcompile_bake.cla"), "dblcompile_bake")
}

// bakeRt68k runs `clarusc --bake-ir --lane 68k -o outPath` (the same
// current-source oracle exe every other bake test in this repo uses)
// and returns outPath.
func bakeRt68k(t *testing.T, outPath string) string {
	t.Helper()
	exe := hostOracleClarusc(t)
	cmd := exec.Command(exe, "--bake-ir", "--lane", "68k", "-o", outPath)
	cmd.Dir = repoRoot(t)
	if out, err := cmd.CombinedOutput(); err != nil {
		t.Fatalf("clarusc --bake-ir --lane 68k: %v\n%s", err, out)
	}
	return outPath
}

// runDblcompileBakeOnce runs exe with [bakePath, entry...] in workDir,
// under CLARUS_MEM_STRICT, and returns the parsed live count -- the
// --rtbake twin of runDblcompileOnce. workDir must sit under the repo
// root for two independent reasons: dblcompile_bake's own nested
// findRtDir walk-up (same as runDblcompileOnce's own doc comment) AND
// bake.cla's bkFindClarusC walk-up (the stamp-recompute half of the
// loader's refusal check, clarusc/bake.cla), which searches for
// clarusc/clarusc.c the same "up to 10 parent levels" way.
func runDblcompileBakeOnce(t *testing.T, exe, bakePath, workDir string, entries []string) int {
	t.Helper()
	live, _ := runDblcompileBakeOnceState(t, exe, bakePath, workDir, entries)
	return live
}

// bakeState is one BAKESTATE line from dblcompile_bake.cla -- the
// design-B (clir-load-perf Task 7) observables for one compile.
type bakeState struct {
	parsedBefore int // 1 iff the CLIR parse was already memoized when this compile started
	objValid     int // bkLdObjValid.count -- the PENDING object staging, which must stay full-length
	boundary     int // bkRuntimeFuncBoundary -- this compile's own installed runtime function count
	eligible     int // functions cgObjPasteEligible accepts, i.e. object-code paste actually armed
}

// runDblcompileBakeOnceState is runDblcompileBakeOnce plus the parsed
// BAKESTATE lines, one per compile, in order.
func runDblcompileBakeOnceState(t *testing.T, exe, bakePath, workDir string, entries []string) (int, []bakeState) {
	t.Helper()
	reportPath := filepath.Join(workDir, "report.txt")
	argv := append([]string{bakePath}, entries...)
	cmd := exec.Command(exe, argv...)
	cmd.Dir = workDir
	cmd.Env = append(os.Environ(),
		"CLARUS_MEM_STRICT=1",
		"CLARUS_MEM_REPORT="+reportPath)
	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	if err := cmd.Run(); err != nil {
		t.Fatalf("run dblcompile_bake %v: %v\nstdout: %s\nstderr: %s", argv, err, stdout.String(), stderr.String())
	}
	live, _ := parseLiveCount(t, reportPath)
	return live, parseBakeStates(t, stderr.String(), len(entries))
}

// parseBakeStates pulls the "BAKESTATE <i> k=v ..." lines out of the
// harness's log stream (feProgress -> log() -> stderr on the host lane).
func parseBakeStates(t *testing.T, out string, want int) []bakeState {
	t.Helper()
	var states []bakeState
	for _, line := range strings.Split(out, "\n") {
		fields := strings.Fields(strings.TrimSpace(line))
		if len(fields) == 0 || fields[0] != "BAKESTATE" {
			continue
		}
		var st bakeState
		for _, f := range fields[2:] {
			k, v, ok := strings.Cut(f, "=")
			if !ok {
				t.Fatalf("malformed BAKESTATE field %q in line %q", f, line)
			}
			n, err := strconv.Atoi(v)
			if err != nil {
				t.Fatalf("malformed BAKESTATE value %q in line %q: %v", f, line, err)
			}
			switch k {
			case "parsedBefore":
				st.parsedBefore = n
			case "objvalid":
				st.objValid = n
			case "boundary":
				st.boundary = n
			case "eligible":
				st.eligible = n
			default:
				t.Fatalf("unknown BAKESTATE key %q in line %q", k, line)
			}
		}
		states = append(states, st)
	}
	if len(states) != want {
		t.Fatalf("got %d BAKESTATE lines, want %d\n%s", len(states), want, out)
	}
	return states
}

// checkDesignBStates asserts the clir-load-perf Task 7 (design B)
// contract over one harness run's BAKESTATE lines:
//
//	(ii) the CLIR is parsed ONCE per process -- compile #1 arrives with
//	     no memo, every later compile arrives with one. (The harness
//	     also frees rtbakeBytes after the first compile, exactly as
//	     macgui.cla does, so a re-parse would fail the run outright
//	     rather than merely fail this assertion.)
//	(iii) the object-code paste stays armed on EVERY compile -- audit
//	     finding F1's regression: driveReset() used to empty
//	     bkLdObjValid every compile, which under memoization (nothing
//	     re-parses it) would silently disable stage 3.5's -41% emit68k
//	     win from compile #2 onward with byte-identical output and no
//	     test going red. Pending state must also stay FULL-LENGTH
//	     (objValid >= boundary): finding F2's in-place truncation is
//	     gone, so a shrinking count means someone reintroduced it.
func checkDesignBStates(t *testing.T, states []bakeState) {
	t.Helper()
	for i, st := range states {
		want := 1
		if i == 0 {
			want = 0
		}
		if st.parsedBefore != want {
			t.Fatalf("compile #%d: parsedBefore=%d, want %d (design B parses the CLIR exactly once per process)", i, st.parsedBefore, want)
		}
		if st.boundary <= 0 {
			t.Fatalf("compile #%d: bkRuntimeFuncBoundary=%d, want > 0 (no baked runtime installed?)", i, st.boundary)
		}
		if st.eligible <= 0 {
			t.Fatalf("compile #%d: %d paste-eligible functions, want > 0 -- the object-code paste is silently off (audit finding F1)", i, st.eligible)
		}
		if st.objValid < st.boundary {
			t.Fatalf("compile #%d: pending bkLdObjValid.count=%d < boundary=%d -- pending object staging was truncated in place (audit finding F2)", i, st.objValid, st.boundary)
		}
		if st.eligible != states[0].eligible || st.boundary != states[0].boundary || st.objValid != states[0].objValid {
			t.Fatalf("compile #%d state %+v differs from compile #0 %+v -- the install is not reproducing the same baked runtime every compile", i, st, states[0])
		}
	}
}

// runDoubleCompileGateBake is runDoubleCompileGate's own --rtbake twin:
// proves the bake-path install (clarusc/bake.cla's bkLoadRtbake/
// bkInstallPool/bkInstallArenas, runtime-ir-bake Task 4) doesn't retain
// heap blocks across repeated in-process compiles either, and that
// re-installing the SAME baked image every compile doesn't leak stale
// state into a later, DIFFERENT entry's compile (the same
// alternating-fixture byte-identity oracle runDoubleCompileGate itself
// uses, here over the --rtbake fork instead of the from-source one).
//
// clir-load-perf Task 7 (design B) promoted this from a leak gate to the
// phase's primary behavioral proof, since it is the only host front end
// that compiles twice in one process. The three design-B claims and
// where each is asserted:
//
//	(i)   compile #2+ produces byte-identical output to compile #1 for
//	      the same input -- the fork0/fork2 comparisons below, which now
//	      prove copy-on-install (a compile whose live arenas aliased the
//	      memoized parse would install its predecessor's user IR).
//	(ii)  compile #2+ does not re-parse the CLIR, and
//	(iii) the object-code paste stays eligible on compile #2+
//	      -- both via checkDesignBStates over the harness's BAKESTATE
//	      lines; see its own doc comment.
//
// The pre-existing live-block growth assertions keep their old meaning
// AND acquire a new one: copy-on-install allocates a fresh copy of every
// baked arena per compile, so a copy that outlives its compile shows up
// here as growth.
func runDoubleCompileGateBake(t *testing.T) {
	t.Helper()
	root := repoRoot(t)
	exe := buildDblcompileBake(t)
	tickprobe := filepath.Join(root, "testdata", "cg68k", "tickprobe.cla")
	catprobe := filepath.Join(root, "testdata", "mac-resident", "catprobe.cla")

	scratchRoot := filepath.Join(root, "build-run")
	if err := os.MkdirAll(scratchRoot, 0o755); err != nil {
		t.Fatalf("mkdir %s: %v", scratchRoot, err)
	}
	bakeDir, err := os.MkdirTemp(scratchRoot, "leakgate-bake-clir-")
	if err != nil {
		t.Fatalf("mkdtemp: %v", err)
	}
	defer os.RemoveAll(bakeDir)
	bakePath := bakeRt68k(t, filepath.Join(bakeDir, "rt68k.clir"))

	work1, err := os.MkdirTemp(scratchRoot, "leakgate-bake-1x-")
	if err != nil {
		t.Fatalf("mkdtemp: %v", err)
	}
	defer os.RemoveAll(work1)
	live1, states1 := runDblcompileBakeOnceState(t, exe, bakePath, work1, []string{tickprobe})
	checkDesignBStates(t, states1)

	work3, err := os.MkdirTemp(scratchRoot, "leakgate-bake-3x-")
	if err != nil {
		t.Fatalf("mkdtemp: %v", err)
	}
	defer os.RemoveAll(work3)
	live3, states3 := runDblcompileBakeOnceState(t, exe, bakePath, work3, []string{tickprobe, tickprobe, tickprobe})
	checkDesignBStates(t, states3)

	growthPerCompile := (live3 - live1) / 2
	if growthPerCompile > 64 {
		t.Fatalf("bake-path live-block growth per extra compile = %d (live1=%d live3=%d), want <= 64", growthPerCompile, live1, live3)
	}

	fork0, err := os.ReadFile(filepath.Join(work3, "leakfork_0.bin"))
	if err != nil {
		t.Fatalf("read leakfork_0.bin: %v", err)
	}
	fork2, err := os.ReadFile(filepath.Join(work3, "leakfork_2.bin"))
	if err != nil {
		t.Fatalf("read leakfork_2.bin: %v", err)
	}
	if !bytes.Equal(fork0, fork2) {
		t.Fatalf("bake-path leakfork_0.bin (%d bytes) != leakfork_2.bin (%d bytes): stale state leaked into the 3rd compile's fork", len(fork0), len(fork2))
	}

	// Alternating-fixture oracle: tickprobe, catprobe, tickprobe -- a
	// DIFFERENT entry in the middle slot, same reasoning as
	// runDoubleCompileGate's own alternating run.
	workAlt, err := os.MkdirTemp(scratchRoot, "leakgate-bake-3x-alt-")
	if err != nil {
		t.Fatalf("mkdtemp: %v", err)
	}
	defer os.RemoveAll(workAlt)
	liveAlt, statesAlt := runDblcompileBakeOnceState(t, exe, bakePath, workAlt, []string{tickprobe, catprobe, tickprobe})
	checkDesignBStates(t, statesAlt)

	growthPerCompileAlt := (liveAlt - live1) / 2
	if growthPerCompileAlt > 64 {
		t.Fatalf("bake-path alternating-fixture live-block growth per extra compile = %d (live1=%d liveAlt=%d), want <= 64", growthPerCompileAlt, live1, liveAlt)
	}

	forkAlt0, err := os.ReadFile(filepath.Join(workAlt, "leakfork_0.bin"))
	if err != nil {
		t.Fatalf("read leakfork_0.bin (alt): %v", err)
	}
	forkAlt2, err := os.ReadFile(filepath.Join(workAlt, "leakfork_2.bin"))
	if err != nil {
		t.Fatalf("read leakfork_2.bin (alt): %v", err)
	}
	if !bytes.Equal(forkAlt0, forkAlt2) {
		t.Fatalf("bake-path alternating run: leakfork_0.bin (%d bytes) != leakfork_2.bin (%d bytes): stale state leaked across a different-fixture compile", len(forkAlt0), len(forkAlt2))
	}
}
