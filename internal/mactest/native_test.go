// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// native_test.go: native-5d Task 11's walking-skeleton milestone was
// TestHelloOn68k -- the FIRST program ever booted on real (emulated) 68k
// hardware through `clarusc emit68k`, no C/Retro68/cmake step at all
// (unlike mac_test.go's TestSuiteOnMac/etc, which build via
// scripts/build-mac.sh's Retro68 pipeline over clarusc's own C emit).
// clarusc comes from claruscboot.CurrentExe (Go-compiler-deletion phase --
// was the Go compiler's build.Build), then invoked directly with
// `emit68k -o hello.bin testdata/cg68k/hello.cla`, and the resulting
// .bin is run the same way mac_test.go's own RunMac/parseCapture already
// do for the Retro68 path -- the capture protocol (runtime/clarus/
// native.cla, ported from runtime/mac/rt_mac.c:83-253) is byte-identical
// either way. TestHelloOn68k itself was retired by test-consolidation
// Task 6 (audit row N1, DELETE): the capture protocol it alone proved is
// exercised by every other native boot below, e.g. TestCoreSuiteGUIOn68k
// (N28); testdata/cg68k/hello.cla/.s were deleted alongside it, having no
// other consumer.
package mactest

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
	"testing"
	"time"

	"clarus/internal/claruscboot"
)

// buildNativeClarusc returns the current-source clarusc used to emit68k
// every native-lane build (Go-compiler-deletion phase; was build.Build).
func buildNativeClarusc(t *testing.T) string {
	t.Helper()
	return claruscboot.CurrentExe(t)
}

// TestHelloOn68k (native-5d Task 11's walking-skeleton milestone) was
// retired by test-consolidation Task 6 -- audit row N1, DELETE: the
// capture protocol (`##CLARUS-EXIT##`/`##CLARUS-LOG##`) it alone proved
// is exercised by every other native boot in this file, e.g.
// TestCoreSuiteGUIOn68k (N28). testdata/cg68k/hello.cla and its committed
// hello.s listing had no other consumer and were deleted alongside it.

// TestNativeSmoke is native-5d Task 12's first native boot test to cover
// records/enums: builds testdata/cg68k/smoke.cla BOTH ways -- the host
// expectation via the current-source clarusc (claruscboot's shared
// Go-free bootstrap; buildHostFromFixture, same as suite_host_test.go's
// BuildSuiteHost -- smoke.cla is deliberately Go-compiler-compatible
// Clarus, no Ch13 surface, precisely so this comparison is possible), and
// the native image via `clarusc emit68k` -- then requires the emulator's
// captured `out` to be byte-identical to the host's stdout, and both exit
// codes to be 0.
func TestNativeSmoke(t *testing.T) {
	runNativeHostCompare(t, "smoke.cla")
}

// TestNativeStrContainers is native-5d Task 14.7's boot test for the
// gap-closure codegen classes (str-element containers, expression-position
// slice, materialized map key) -- testdata/cg68k/strcontainers.cla, its
// own file rather than a smoke.cla section because smoke.cla is at its
// single-segment PC-relative displacement ceiling (see the fixture's own
// header comment; Task 15's segmentation is the real fix).
func TestNativeStrContainers(t *testing.T) {
	runNativeHostCompare(t, "strcontainers.cla")
}

// TestNativeFixedOps (native-5d Task 14.7 review round 2's boot test for
// fix_mul/fix_div) was retired by test-consolidation Task 6 -- audit row
// N4, DELETE: the same byte-identical operations are covered by
// testsuite/core/cases_enumfix.cla:39 (caseFixedMathOps), which runs on
// native 68k via TestCoreSuiteGUIOn68k (N28). testdata/cg68k/fixedops.cla
// and its committed fixedops.s listing had no other consumer and were
// deleted alongside it.

// TestNativeArrWholeAssign is native-5e Task 2's (5d final-review C1) boot
// test for whole-fixed-array assignment (`b = a` / `r.field = arrVar` /
// `lst[i] = row` for `arr N of T`) -- testdata/cg68k/arr_whole_assign.cla,
// the same regression matrix as testdata/lowlevel/arr_whole_assign.cla
// (that copy is the host-lane cprint-vs-host-cc oracle under
// internal/lowlevel; this one is the Go-compiler-vs-native-boot oracle).
func TestNativeArrWholeAssign(t *testing.T) {
	runNativeHostCompare(t, "arr_whole_assign.cla")
}

// TestNativeSmokeForcedMultiSegment (native-5d Task 15's forced-multi-
// segment boot proof, forcing a small `--seglimit` to split smoke.cla
// into several real CODE segments and prove cross-segment BSR/JSR +
// the Segment Loader's _LoadSeg path) was retired by test-consolidation
// Task 6 -- audit row N6, DELETE: both suite compositions
// (TestCoreSuiteGUIOn68k/N28, TestToolboxSuiteOn68k/N29) are naturally
// multi-segment (8 CODE segments each) at clarusc's real, undecorated
// default per-segment budget, so every ordinary suite boot already
// exercises the same cross-segment call + _LoadSeg path a forced
// `--seglimit` proved standalone.

// runNativeHostCompare builds testdata/cg68k/<fixture> BOTH ways -- the
// host expectation via the current-source clarusc (claruscboot's shared
// Go-free bootstrap; buildHostFromFixture, same as suite_host_test.go's
// BuildSuiteHost -- these fixtures are deliberately Go-compiler-compatible
// Clarus, no Ch13 surface, precisely so this comparison is possible), and
// the native image via `clarusc emit68k` -- then requires the emulator's
// captured `out` to be byte-identical to the host's stdout, and both exit
// codes to be 0.
func runNativeHostCompare(t *testing.T, fixtureName string) {
	runNativeHostCompareSeglimit(t, fixtureName, 0)
}

// runNativeHostCompareSeglimit is runNativeHostCompare generalized with an
// optional forced per-segment budget (segLimit <= 0 uses the real,
// undecorated `clarusc emit68k` invocation -- cg68Program's own default
// 32760-byte budget; segLimit > 0 additionally passes `--seglimit N`).
// Logs how many CODE segments the build actually produced either way, so
// a forced-multi-segment run's own log line is visible evidence in test
// output that packing really did split the app.
func runNativeHostCompareSeglimit(t *testing.T, fixtureName string, segLimit int) {
	requireMac(t)
	fixture := filepath.Join(repoRoot(t), "testdata", "cg68k", fixtureName)

	hostExe := buildHostFromFixture(t, fixture, "host")
	hostCmd := exec.Command(hostExe)
	hostCmd.Dir = t.TempDir()
	hostOut, err := hostCmd.Output()
	if err != nil {
		t.Fatalf("run host %s: %v", fixtureName, err)
	}
	want := string(hostOut)

	exe := buildNativeClarusc(t)
	runDir := t.TempDir()
	bin := filepath.Join(runDir, "native.bin")
	args := []string{"emit68k", "-o", bin, "--listing"}
	if segLimit > 0 {
		args = append(args, "--seglimit", strconv.Itoa(segLimit))
	}
	args = append(args, fixture)
	cmd := exec.Command(exe, args...)
	out, err := cmd.CombinedOutput()
	if err != nil {
		t.Fatalf("clarusc %s: %v\n%s", strings.Join(args, " "), err, out)
	}

	base := strings.TrimSuffix(bin, ".bin")
	segCount := 0
	for {
		next := segCount + 1
		if _, statErr := os.Stat(fmt.Sprintf("%s.seg%d.s", base, next)); statErr != nil {
			break
		}
		segCount = next
	}
	t.Logf("%s packed into %d CODE segment(s) (seglimit=%d)", fixtureName, segCount, segLimit)
	if segLimit > 0 && segCount <= 1 {
		t.Fatalf("--seglimit %d did not force %s into more than one CODE segment (got %d) -- the forced-multi-segment boot proof needs a REAL split", segLimit, fixtureName, segCount)
	}

	got, _, exitCode := RunMac(t, bin, 5*time.Minute)
	if exitCode != 0 {
		t.Fatalf("%s exit code %d, want 0", fixtureName, exitCode)
	}
	if got != want {
		t.Fatalf("%s output mismatch (native vs host):%s", fixtureName, firstDiff(want, got))
	}
}

// buildNative68k invokes `clarusc emit68k -o <dir>/<binName>.bin fixture`
// via the memoized buildNativeClarusc(), the same in-test emit pattern
// every other native_test.go boot test already uses (buildNativeClarusc
// returns claruscboot.CurrentExe's current-source clarusc, then this
// runs the resulting exe directly -- no subprocess snapshot-bootstrap, no
// script indirection). scripts/build-68k.sh exists and works standalone
// (mirrors build-mac.sh's step-1 snapshot-bootstrap caching, then `emit68k
// --rtdir runtime/clarus/ -o ... FILES`) for manual/CI use outside this
// harness, but Task 16's gate tests below use this helper instead, for the
// same reason TestHelloOn68k/TestNativeSmoke/etc already do: the memoized
// buildNativeClarusc() amortizes clarusc's own build cost across all boots
// in one `go test` run, which script-per-boot subprocess bootstrapping
// would not.
func buildNative68k(t *testing.T, fixture, binName string) string {
	t.Helper()
	exe := buildNativeClarusc(t)
	bin := filepath.Join(t.TempDir(), binName+".bin")
	cmd := exec.Command(exe, "emit68k", "-o", bin, fixture)
	out, err := cmd.CombinedOutput()
	if err != nil {
		t.Fatalf("clarusc emit68k -o %s %s: %v\n%s", bin, fixture, err, out)
	}
	return bin
}

// buildNative68kUI (Task 12, native-5e) is buildNative68k plus `--events`:
// builds a UI program via `clarusc emit68k --events <eventsRel> <claRel...>`
// through the same memoized buildNativeClarusc() -- no Retro68/cmake, no
// C, unlike ui_test.go's own runUIScenarioBuild (which builds the SAME
// kind of scenario through scripts/build-mac.sh's Retro68 pipeline).
// eventsRel/claRel are package-dir-relative paths, the SAME convention
// ui_test.go's own runUIScenarioBuild/eventsRel already use (passed
// through to clarusc unmodified -- clarusc runs with this package's own
// working directory, so a relative path resolves the same way either
// way, and its own runtime-module upward search from cwd already finds
// runtime/clarus/ from here without an explicit --rtdir, the same
// precedent buildNative68k's own callers already rely on).
func buildNative68kUI(t *testing.T, name string, eventsRel string, claRel ...string) string {
	t.Helper()
	exe := buildNativeClarusc(t)
	bin := filepath.Join(t.TempDir(), name+".bin")
	args := []string{"emit68k", "-o", bin, "--events", eventsRel}
	args = append(args, claRel...)
	cmd := exec.Command(exe, args...)
	out, err := cmd.CombinedOutput()
	if err != nil {
		t.Fatalf("clarusc %s: %v\n%s", strings.Join(args, " "), err, out)
	}
	return bin
}

// TestSmokeBounceOn68k is Task 12's own end gate (native-5e): the FIRST
// native UI boot -- testdata/valid/bounce.cla (canvas + every + close, no
// TE/tables/dialogs/AE -- the smallest of the UI golden scenarios),
// built via `clarusc emit68k --events` (no Retro68/cmake/C at all) and
// booted on the same emulator harness TestHelloOn68k/etc already use.
// Reuses ui_test.go's own checkUIGoldens (the SAME trace/testdata/ui and
// snap/testdata/uisnaps comparison the Retro68-ported lane's
// TestSmokeBounceUIScenario already passes against) -- byte-identical
// trace + PBM snaps against the FROZEN goldens is the whole point: this
// is the same runtime (runtime/clarus/ui*.cla) and the same scripted
// event source, only the CODE GENERATOR differs (cg68k vs gcc), so any
// divergence here is native codegen/trap/glue/blob-lane, by construction
// (this task's own brief).
func TestSmokeBounceOn68k(t *testing.T) {
	requireMac(t)
	eventsRel := filepath.Join("..", "..", "testdata", "ui", "smoke_bounce.events")
	claRel := filepath.Join("..", "..", "testdata", "valid", "bounce.cla")
	bin := buildNative68kUI(t, "smoke_bounce", eventsRel, claRel)
	out, _, exitCode := RunMac(t, bin, 3*time.Minute)
	checkUIGoldens(t, "smoke_bounce", out, exitCode, 0)
}

// TestAboutOn68k (Task 13, native-5e resource parity) was retired by
// test-consolidation Task 5 -- audit row N8, MERGE->N10: the About-box
// open/verify/close sequence now lives inside smoke_mandel's own events
// script (a `menu 1 1` line appended just before the final Quit), since
// examples/mandelbrot.cla's own `app` section already populates all four
// About-relevant properties (name/version/author/about) -- a merge target
// the audit confirmed viable (docs/superpowers/specs/2026-08-06-test-
// consolidation-audit.md, claim 4). testdata/ui/about.cla itself is NOT
// deleted: internal/mactest/resparity_test.go's TestApp68kResourceParity
// depends on it independently (its own "no declared icon" probe fixture,
// unrelated to this UI-scenario coverage) -- only about.events/about.trace
// (this scenario's own event script + golden, with no other consumer)
// were retired alongside this test.

// uiScenario68k is one row of uiScenarios68k (Task 14, native-5e): the
// native-lane counterpart to ui_test.go's per-scenario Test functions,
// factored into a table (rather than 21 hand-copied Test funcs) since every
// row drives the exact same buildNative68kUI + RunMac + checkUIGoldens
// sequence, differing only in source files / events script / optional extra
// snap assertion (reusing the checkXxxSnaps helpers ui_test.go's own host
// lane already factored out for this purpose).
type uiScenario68k struct {
	name      string
	claRel    []string // package-dir-relative, in clarusc's own arg order
	eventsRel string
	wantExit  int
	check     func(t *testing.T, snaps []uiSnap)
}

// uiScenarios68k is the SAME scenarios/sources/events as ui_test.go's
// Retro68-ported lane, minus smoke_bounce and about (each already has its
// own standalone Test*On68k, predating this table -- Task 12/13; kept
// standalone rather than folded in, recorded here per the brief's "your
// call") -- and, as of ui-scenario-retirement, minus whichever scenarios
// have been migrated to testsuite/toolbox cases and retired (Task 4
// retired pattern; see that task's own report for the migration). Not a
// fixed count: this table shrinks task by task through that phase, so no
// scenario-count number is hard-coded here or in the comments below.
//
// test-consolidation Task 5 retired 3 more rows and merged 2 more into
// `texteditor`'s own row: smoke_menudemo (audit row N9, DELETE -- already
// covered by testsuite/toolbox/cases_menus.cla + cases_events.cla's
// MenuKeyMatches); opendoc/opendoc_empty (rows N11/N12, MERGE->N14/DELETE
// -- opendoc's GetAppFiles-launch dispatch, including the space-containing
// path, folded into texteditor.events via `launchdoc` lines against a new
// companion source, testdata/ui/texteditor_opendoc_setup.cla, which writes
// both real fixture files `on App.launch` so the real `file.readText`
// openPath performs actually succeeds -- opendoc_empty's own no-launchdoc
// startEmpty-fallback coverage needed no change, texteditor.events already
// exercised it); texteditor_quit (row N15, MERGE->N14 -- its multi-window
// quit-cascade, save-then-close then cancel-aborts-the-whole-quit, folded
// onto texteditor.events' own tail, reusing its post-roundtrip windows
// instead of two fresh ones).
var uiScenarios68k = []uiScenario68k{
	{name: "smoke_mandel", claRel: []string{filepath.Join("..", "..", "examples", "mandelbrot.cla")}, eventsRel: filepath.Join("..", "..", "testdata", "ui", "smoke_mandel.events"), check: checkSmokeMandelSnaps},
	{name: "texteditor", claRel: []string{filepath.Join("..", "..", "examples", "texteditor.cla"), filepath.Join("..", "..", "testdata", "ui", "texteditor_opendoc_setup.cla")}, eventsRel: filepath.Join("..", "..", "testdata", "ui", "texteditor.events")},
	{name: "bookmarks", claRel: []string{filepath.Join("..", "..", "examples", "bookmarks.cla")}, eventsRel: filepath.Join("..", "..", "testdata", "ui", "bookmarks.events"), check: checkBookmarksSnaps},
}

// TestUiScenariosOn68k is Task 14's own end gate (native-5e): the SAME
// UI scenarios/events/goldens ui_test.go's Retro68-ported lane already
// passes (see uiScenarios68k's own comment above for why no fixed count
// is quoted here), this time built with `clarusc emit68k` (no Retro68/cmake/C) and
// booted the same way TestSmokeBounceOn68k already is.
// smoke_bounce is NOT repeated here: it already has its own standalone
// Test*On68k (Task 12), and folding it into this table would just rename
// an existing green test for no benefit. about (Task 13's own former
// standalone Test*On68k) was retired outright by test-consolidation
// Task 5 -- its coverage now lives inside smoke_mandel's own row above
// (audit row N8, MERGE->N10; see TestAboutOn68k's own retirement comment
// further up this file).
//
// Bless ownership: test-consolidation Task 7 retired the Retro68/cprint
// scenario lane outright (ui_test.go's TestSmokeBounceUIScenario/
// TestSmokeMandelUIScenario/TestTexteditorUIScenario/TestBookmarksUIScenario
// -- audit rows R3/R5/R8/R11, all DELETE), so this native lane is now the
// ONLY place these scenarios boot, and the only place CLARUS_MAC_BLESS=1
// has any effect. There used to be a hard-fail guard here rejecting
// CLARUS_MAC_BLESS=1 ("native UI lane never blesses"), on the theory that
// the codegen under test shouldn't be trusted to write its own goldens
// while the Retro68 lane stayed the sole trusted writer; with that lane
// gone there is no other writer left, so the guard is removed --
// checkUIGoldens below already does the actual (re)write under
// CLARUS_MAC_BLESS=1, unchanged, and now runs unguarded.
func TestUiScenariosOn68k(t *testing.T) {
	requireMac(t)
	for _, sc := range uiScenarios68k {
		sc := sc
		t.Run(sc.name, func(t *testing.T) {
			start := time.Now()
			bin := buildNative68kUI(t, sc.name, sc.eventsRel, sc.claRel...)
			built := time.Now()
			out, dbgLog, exitCode := RunMac(t, bin, 3*time.Minute)
			booted := time.Now()
			t.Logf("%s: build %s, boot %s", sc.name, built.Sub(start), booted.Sub(built))
			if os.Getenv("CLARUS_DEBUG_UI") != "" {
				t.Logf("%s: exit=%d\n--- out ---\n%s\n--- log ---\n%s", sc.name, exitCode, out, dbgLog)
			}
			snaps := checkUIGoldens(t, sc.name, out, exitCode, sc.wantExit)
			if sc.check != nil {
				sc.check(t, snaps)
			}
		})
	}
}

// TestTexteditorBigfileOn68k (native counterpart of the retired
// TestTexteditorBigfileUIScenario) was retired by test-consolidation
// Task 4 -- see ui_test.go's own retirement comment at the same spot for
// where its coverage now lives (testsuite/toolbox/cases_bigtext.cla's
// `BigText` case).

// TestRealEventLoopTickOn68k boots testdata/cg68k/tickprobe.cla with NO
// --events script -- the ONLY test in either lane that exercises rtUiRun's
// real WaitNextEvent loop and rtUiEveryPump's real UiTickCount scheduling
// (every scripted scenario runs on gVirtualTicks via rtUiRunScripted
// instead; ui.cla's own rtUiRun comment has always flagged this path as
// otherwise unverified). Regression pin for the UiTickCount
// pascal-vs-reg convention bug (2026-08-03): the fixture's `every 1
// ticks` block counts to 60 and quits, so a working timer path exits 0
// within seconds, while a regressed one never fires the every block and
// the boot times out -- the timeout IS the failure signal (see the
// fixture's own header comment for the full story, including the sibling
// UiMenuKey CharParameter fix, which has no self-driving lane).
func TestRealEventLoopTickOn68k(t *testing.T) {
	requireMac(t)
	fixture := filepath.Join(repoRoot(t), "testdata", "cg68k", "tickprobe.cla")
	bin := buildNative68k(t, fixture, "tickprobe")
	_, _, exitCode := RunMac(t, bin, 3*time.Minute)
	if exitCode != 0 {
		t.Fatalf("tickprobe exit code %d, want 0", exitCode)
	}
}

// TestSuiteOn68k (native-5d Task 16's end gate, rebased by test-suite-
// review Task 9 onto the core suite's CLI composition, coreCLIMacFiles)
// was retired by test-consolidation Task 6 -- audit row N19, DELETE: all
// 41 CoreTest cases already run natively via TestCoreSuiteGUIOn68k (N28);
// the only signal lost is byte-exact core-CLI stdout log-formatting
// parity against the host (Decision 3, not semantic coverage).
// coreCLIMacFiles/cli_mac.cla are NOT deleted -- mac_test.go's own
// TestSuiteOnMac (a separate, still-KEEP row) and
// internal/cg68k/segment_test.go both depend on cli_mac.cla independently
// (audit claim 7).

// TestRunErrOn68k mirrors TestRunErrOnMac (mac_test.go): reduced by
// test-consolidation Task 6 to the single representative fixture, `oob`
// (audit row N23, KEEP -- plain array-bounds panic, the simplest real-mode
// trap shape) -- badenum/emptypop/mapmiss/slicerange/strindex (rows
// N20/N21/N22/N24/N25, all DELETE) are dropped as per-lane boots since
// their semantic panic coverage is pinned host-side, lane-independently,
// by internal/selfhost/behavior_test.go against each fixture's own
// testdata/runerr/*.behavior golden (T1, ungated). The .cla/.err/.behavior
// files for all 6 fixtures STAY -- the host test still consumes them.
func TestRunErrOn68k(t *testing.T) {
	requireMac(t)
	files := []string{filepath.Join(repoRoot(t), "testdata", "runerr", "oob.cla")}
	for _, f := range files {
		f := f
		base := strings.TrimSuffix(filepath.Base(f), ".cla")
		t.Run(base, func(t *testing.T) {
			want, err := os.ReadFile(strings.TrimSuffix(f, ".cla") + ".err")
			if err != nil {
				t.Fatal(err)
			}
			bin := buildNative68k(t, f, "err"+base)
			_, log, exitCode := RunMac(t, bin, 3*time.Minute)
			if exitCode != 3 {
				t.Errorf("exit: got %d want 3", exitCode)
			}
			if !strings.Contains(log, strings.TrimSpace(string(want))) {
				t.Errorf("log %q missing %q", log, strings.TrimSpace(string(want)))
			}
		})
	}
}

// TestAbortOn68k mirrors TestAbortAppsOnMac (mac_test.go): reduced by
// test-consolidation Task 6 to the single representative fixture,
// emit_array (audit row N26, KEEP) -- its 7-line pre-panic alert()
// capture proves the abort-capture shape more strongly than emit_enum's
// 5 (row N27, DELETE); emit_enum's own semantic coverage (bad-enum-
// conversion panic) is separately pinned host-side by
// testdata/runerr/badenum.behavior (T1, ungated). Neither runerr fixture
// has any pre-panic output, so this abort-app boot is NOT absorbable by
// TestRunErrOn68k's own representative (audit claim 6) -- both boots
// stay, per lane.
func TestAbortOn68k(t *testing.T) {
	requireMac(t)
	for _, name := range []string{"emit_array"} {
		name := name
		t.Run(name, func(t *testing.T) {
			wrapper := filepath.Join(repoRoot(t), "testdata", "run", name+".cla")
			wantOut, err := os.ReadFile(filepath.Join(repoRoot(t), "testdata", "run", name+".out"))
			if err != nil {
				t.Fatal(err)
			}
			wantExitBytes, err := os.ReadFile(filepath.Join(repoRoot(t), "testdata", "run", name+".exit"))
			if err != nil {
				t.Fatal(err)
			}
			wantExit, err := strconv.Atoi(strings.TrimSpace(string(wantExitBytes)))
			if err != nil {
				t.Fatalf("malformed golden exit code %q: %v", wantExitBytes, err)
			}
			bin := buildNative68k(t, wrapper, "abort"+name)
			out, _, exitCode := RunMac(t, bin, 3*time.Minute)
			if exitCode != wantExit {
				t.Errorf("exit: got %d want %d", exitCode, wantExit)
			}
			if out != string(wantOut) {
				t.Errorf("out mismatch:%s", firstDiff(string(wantOut), out))
			}
		})
	}
}
