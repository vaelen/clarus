// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// native_test.go: native-5d Task 11's walking-skeleton milestone --
// TestHelloOn68k is the FIRST program ever booted on real (emulated) 68k
// hardware through `clarusc emit68k`, no C/Retro68/cmake step at all
// (unlike mac_test.go's TestSuiteOnMac/etc, which build via
// scripts/build-mac.sh's Retro68 pipeline over clarusc's own C emit).
// clarusc is built via the memoized buildClarusc() pattern (mirrors
// internal/cg68k/golden_test.go's own buildClarusc, itself mirroring
// internal/selfhost/differential_test.go's), then invoked directly with
// `emit68k -o hello.bin testdata/cg68k/hello.cla`, and the resulting
// .bin is run the same way mac_test.go's own RunMac/parseCapture already
// do for the Retro68 path -- the capture protocol (runtime/clarus/
// native.cla, ported from runtime/mac/rt_mac.c:83-253) is byte-identical
// either way.
package mactest

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
	"sync"
	"testing"
	"time"

	"clarus/internal/build"
)

var (
	nativeClaruscOnce sync.Once
	nativeClaruscExe  string
	nativeClaruscErr  error
)

// buildNativeClarusc builds clarusc once per `go test` invocation (same
// memoization discipline as cg68k.golden_test.go's own buildClarusc --
// duplicated locally rather than exported cross-package for one caller,
// same call this repo's other near-duplicate helpers already made).
func buildNativeClarusc(t *testing.T) string {
	t.Helper()
	nativeClaruscOnce.Do(func() {
		dir, err := os.MkdirTemp("", "clarusc-native-*")
		if err != nil {
			nativeClaruscErr = err
			return
		}
		exe := filepath.Join(dir, "clarusc")
		diags, err := build.Build([]string{filepath.Join(repoRoot(t), "clarusc", "main.cla")}, exe)
		if err != nil {
			nativeClaruscErr = err
			return
		}
		if len(diags) > 0 {
			var b strings.Builder
			b.WriteString("clarusc build produced diagnostics:")
			for _, d := range diags {
				b.WriteString("\n  ")
				b.WriteString(d.String())
			}
			nativeClaruscErr = errString(b.String())
			return
		}
		nativeClaruscExe = exe
	})
	if nativeClaruscErr != nil {
		t.Fatal(nativeClaruscErr)
	}
	return nativeClaruscExe
}

type errString string

func (e errString) Error() string { return string(e) }

// TestHelloOn68k builds testdata/cg68k/hello.cla with `clarusc emit68k`
// and boots the result in the emulator -- the walking-skeleton milestone
// for native-5d's codegen68k wave. Asserts exit 0 and `out` == the
// natAlert-rendered "hello, 68k\n" (CR->LF + trailing LF over a message
// with no CR, so just the literal text plus one LF).
func TestHelloOn68k(t *testing.T) {
	requireMac(t)
	exe := buildNativeClarusc(t)

	runDir := t.TempDir()
	bin := filepath.Join(runDir, "hello.bin")
	fixture := filepath.Join(repoRoot(t), "testdata", "cg68k", "hello.cla")
	cmd := exec.Command(exe, "emit68k", "-o", bin, fixture)
	out, err := cmd.CombinedOutput()
	if err != nil {
		t.Fatalf("clarusc emit68k -o %s %s: %v\n%s", bin, fixture, err, out)
	}

	got, _, exitCode := RunMac(t, bin, 5*time.Minute)
	if exitCode != 0 {
		t.Fatalf("hello.cla exit code %d, want 0", exitCode)
	}
	want := "hello, 68k\n"
	if got != want {
		t.Fatalf("hello.cla output mismatch:%s", firstDiff(want, got))
	}
}

// TestNativeSmoke is native-5d Task 12's first native boot test to cover
// records/enums: builds testdata/cg68k/smoke.cla BOTH ways -- the host
// expectation via the snapshot-bootstrapped clarusc (buildHostFromFixture,
// same as suite_host_test.go's BuildSuiteHost -- smoke.cla is deliberately
// Go-compiler-compatible Clarus, no Ch13 surface, precisely so this
// comparison is possible), and the native image via `clarusc emit68k` --
// then requires the emulator's captured `out` to be byte-identical to the
// host's stdout, and both exit codes to be 0.
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

// TestNativeFixedOps is native-5d Task 14.7 review round 2's boot test
// for fix_mul/fix_div (unimplemented pre-review, silently returning 0) --
// testdata/cg68k/fixedops.cla, its own file rather than a smoke.cla
// section because rtFixMul/rtFixDiv (large, 16-bit-half-decomposition
// functions) overflow smoke.cla's own single-segment displacement
// ceiling the moment they become reachable (see the fixture's own header
// comment).
func TestNativeFixedOps(t *testing.T) {
	runNativeHostCompare(t, "fixedops.cla")
}

// TestNativeArrWholeAssign is native-5e Task 2's (5d final-review C1) boot
// test for whole-fixed-array assignment (`b = a` / `r.field = arrVar` /
// `lst[i] = row` for `arr N of T`) -- testdata/cg68k/arr_whole_assign.cla,
// the same regression matrix as testdata/lowlevel/arr_whole_assign.cla
// (that copy is the host-lane cprint-vs-host-cc oracle under
// internal/lowlevel; this one is the Go-compiler-vs-native-boot oracle).
func TestNativeArrWholeAssign(t *testing.T) {
	runNativeHostCompare(t, "arr_whole_assign.cla")
}

// TestNativeSmokeForcedMultiSegment is native-5d Task 15's forced-
// multi-segment boot proof: the SAME known-good smoke.cla TestNativeSmoke
// already boots successfully with the default (real, 32760-byte)
// per-segment budget -- but under that budget smoke.cla still fits in a
// single CODE segment, so a normal boot alone never exercises a
// cross-segment BSR/JSR-through-the-jump-table call on real hardware.
// `--seglimit` (main.cla's undocumented test-only flag, wired straight
// to cg68Program's own segLimit parameter) forces a small budget instead,
// splitting smoke.cla into several real segments -- this proves cross-
// segment calls + the Segment Loader's _LoadSeg path work on real 68k
// hardware BEFORE Task 16 stakes the whole suite app on it.
func TestNativeSmokeForcedMultiSegment(t *testing.T) {
	runNativeHostCompareSeglimit(t, "smoke.cla", 6000)
}

// runNativeHostCompare builds testdata/cg68k/<fixture> BOTH ways -- the
// host expectation via the snapshot-bootstrapped clarusc
// (buildHostFromFixture, same as suite_host_test.go's BuildSuiteHost --
// these fixtures are deliberately Go-compiler-compatible Clarus, no Ch13
// surface, precisely so this comparison is possible), and the native image
// via `clarusc emit68k` -- then requires the emulator's captured `out` to
// be byte-identical to the host's stdout, and both exit codes to be 0.
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
// builds clarusc through the host Go toolchain via build.Build, then this
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

// buildNative68kMulti is buildNative68k generalized to a multi-file
// composition (`clarusc emit68k -o bin FILE...`) -- test-suite-review
// Task 9's core-CLI Mac-gate swap (TestSuiteOn68k below) needs this;
// buildNative68k itself stays single-file since every other caller passes
// exactly one fixture.
func buildNative68kMulti(t *testing.T, binName string, fixtures ...string) string {
	t.Helper()
	exe := buildNativeClarusc(t)
	bin := filepath.Join(t.TempDir(), binName+".bin")
	args := append([]string{"emit68k", "-o", bin}, fixtures...)
	cmd := exec.Command(exe, args...)
	out, err := cmd.CombinedOutput()
	if err != nil {
		t.Fatalf("clarusc %s: %v\n%s", strings.Join(args, " "), err, out)
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
// TE/tables/dialogs/AE -- the smallest of the 23 UI golden scenarios),
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

// TestAboutOn68k is Task 13's (native-5e resource parity) own spot-boot:
// the `about` scenario natively -- an `app` section with all four
// About-relevant properties set (testdata/ui/about.cla), no icon. This is
// the first native boot to exercise the Apple-menu build
// (rtUiBuildAppleMenu, runtime/clarus/ui.cla) and its About item dispatch
// (rtUiAppleSelect -> rtUiTraceAbout) on real hardware. Note: the ported
// runtime's rtUiAppleSelect ALWAYS traces the About fields instead of
// drawing the real ParamText+Alert(129) dialog (ui.cla's own doc comment
// on rtUiAppleSelect -- a deliberate, pre-existing simplification, not
// something this task changed) -- so this boot does NOT actually exercise
// Alert(129)/the ALRT 129 resource's Toolbox draw path; it exercises the
// Apple-menu build/dispatch plumbing and confirms TestApp68kResourceParity's
// ALRT/DITL 129 bytes sit in a resource fork that boots and runs cleanly
// either way.
func TestAboutOn68k(t *testing.T) {
	requireMac(t)
	eventsRel := filepath.Join("..", "..", "testdata", "ui", "about.events")
	claRel := filepath.Join("..", "..", "testdata", "ui", "about.cla")
	bin := buildNative68kUI(t, "about", eventsRel, claRel)
	out, _, exitCode := RunMac(t, bin, 3*time.Minute)
	checkUIGoldens(t, "about", out, exitCode, 0)
}

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

// uiScenarios68k is the SAME 23 scenarios/sources/events as ui_test.go's
// Retro68-ported lane, minus smoke_bounce and about (each already has its
// own standalone Test*On68k, predating this table -- Task 12/13; kept
// standalone rather than folded in, recorded here per the brief's "your
// call").
var uiScenarios68k = []uiScenario68k{
	{name: "buttons", claRel: []string{filepath.Join("..", "..", "testdata", "ui", "buttons.cla")}, eventsRel: filepath.Join("..", "..", "testdata", "ui", "buttons.events")},
	{name: "menus", claRel: []string{filepath.Join("..", "..", "testdata", "ui", "menus.cla")}, eventsRel: filepath.Join("..", "..", "testdata", "ui", "menus.events")},
	{name: "winvar", claRel: []string{filepath.Join("..", "..", "testdata", "ui", "winvar.cla")}, eventsRel: filepath.Join("..", "..", "testdata", "ui", "winvar.events")},
	{name: "zoomwin", claRel: []string{filepath.Join("..", "..", "testdata", "ui", "zoomwin.cla")}, eventsRel: filepath.Join("..", "..", "testdata", "ui", "zoomwin.events"), check: checkZoomwinSnaps},
	{name: "canvas", claRel: []string{filepath.Join("..", "..", "testdata", "ui", "canvas.cla")}, eventsRel: filepath.Join("..", "..", "testdata", "ui", "canvas.events"), check: checkCanvasSnaps},
	{name: "pattern", claRel: []string{filepath.Join("..", "..", "testdata", "ui", "pattern.cla")}, eventsRel: filepath.Join("..", "..", "testdata", "ui", "pattern.events")},
	{name: "hdim", claRel: []string{filepath.Join("..", "..", "testdata", "ui", "hdim.cla")}, eventsRel: filepath.Join("..", "..", "testdata", "ui", "hdim.events")},
	{name: "smoke_menudemo", claRel: []string{filepath.Join("..", "..", "examples", "menu-demo.cla")}, eventsRel: filepath.Join("..", "..", "testdata", "ui", "smoke_menudemo.events")},
	{name: "smoke_mandel", claRel: []string{filepath.Join("..", "..", "examples", "mandelbrot.cla")}, eventsRel: filepath.Join("..", "..", "testdata", "ui", "smoke_mandel.events"), check: checkSmokeMandelSnaps},
	{name: "textwidgets", claRel: []string{filepath.Join("..", "..", "testdata", "ui", "textwidgets.cla")}, eventsRel: filepath.Join("..", "..", "testdata", "ui", "textwidgets.events"), check: checkTextwidgetsSnaps},
	{name: "editmenu", claRel: []string{filepath.Join("..", "..", "testdata", "ui", "editmenu.cla")}, eventsRel: filepath.Join("..", "..", "testdata", "ui", "editmenu.events")},
	{name: "hscroll", claRel: []string{filepath.Join("..", "..", "testdata", "ui", "hscroll.cla")}, eventsRel: filepath.Join("..", "..", "testdata", "ui", "hscroll.events"), check: checkHscrollSnaps},
	{name: "opendoc", claRel: []string{filepath.Join("..", "..", "testdata", "ui", "opendoc.cla")}, eventsRel: filepath.Join("..", "..", "testdata", "ui", "opendoc.events")},
	{name: "opendoc_empty", claRel: []string{filepath.Join("..", "..", "testdata", "ui", "opendoc.cla")}, eventsRel: filepath.Join("..", "..", "testdata", "ui", "opendoc_empty.events")},
	{name: "popuptable", claRel: []string{filepath.Join("..", "..", "testdata", "ui", "popuptable.cla")}, eventsRel: filepath.Join("..", "..", "testdata", "ui", "popuptable.events"), check: checkPopuptableSnaps},
	{name: "dialogs", claRel: []string{filepath.Join("..", "..", "testdata", "ui", "dialogs.cla")}, eventsRel: filepath.Join("..", "..", "testdata", "ui", "dialogs.events")},
	{name: "formedit", claRel: []string{filepath.Join("..", "..", "testdata", "ui", "formedit.cla")}, eventsRel: filepath.Join("..", "..", "testdata", "ui", "formedit.events"), check: checkFormeditSnaps},
	{name: "texteditor", claRel: []string{filepath.Join("..", "..", "examples", "texteditor.cla")}, eventsRel: filepath.Join("..", "..", "testdata", "ui", "texteditor.events")},
	{name: "texteditor_quit", claRel: []string{filepath.Join("..", "..", "examples", "texteditor.cla")}, eventsRel: filepath.Join("..", "..", "testdata", "ui", "texteditor_quit.events")},
	{name: "bookmarks", claRel: []string{filepath.Join("..", "..", "examples", "bookmarks.cla")}, eventsRel: filepath.Join("..", "..", "testdata", "ui", "bookmarks.events"), check: checkBookmarksSnaps},
}

// TestUiScenariosOn68k is Task 14's own end gate (native-5e): the SAME 23
// UI scenarios/events/goldens ui_test.go's Retro68-ported lane already
// passes, this time built with `clarusc emit68k` (no Retro68/cmake/C) and
// booted the same way TestSmokeBounceOn68k/TestAboutOn68k already are.
// texteditor_bigfile is handled by its own subtest below (its host
// counterpart, TestTexteditorBigfileUIScenario, bypasses checkUIGoldens
// entirely to strip an alert() line out of the capture first -- not a
// table row). smoke_bounce and about are NOT repeated here: each already
// has its own standalone Test*On68k (Task 12/13), and folding them into
// this table would just rename an existing green test for no benefit.
//
// Native NEVER blesses: CLARUS_MAC_BLESS=1 is a hard failure here, even
// though checkUIGoldens itself would happily rewrite goldens under it (the
// Retro68 lane's only blessing path) -- this codegen is the one under
// test; the goldens it must match are frozen, and no native run may ever
// write them.
func TestUiScenariosOn68k(t *testing.T) {
	requireMac(t)
	if blessUI() {
		t.Fatal("native UI lane never blesses (CLARUS_MAC_BLESS is set) -- goldens are frozen; bless only via the Retro68 lane (ui_test.go)")
	}
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

// TestTexteditorBigfileOn68k is TestTexteditorBigfileUIScenario's native
// counterpart: same two-source build (examples/texteditor.cla +
// testdata/ui/texteditor_bigfile_setup.cla), same alert-message-stripping
// capture handling (alert() text isn't part of the RT_MAC_TEST trace/snap
// vocabulary -- see the host test's own comment), reused here verbatim
// rather than hand-copied a second time by delegating the shared tail to
// checkTexteditorBigfileCapture.
func TestTexteditorBigfileOn68k(t *testing.T) {
	requireMac(t)
	if blessUI() {
		t.Fatal("native UI lane never blesses (CLARUS_MAC_BLESS is set) -- goldens are frozen; bless only via the Retro68 lane (ui_test.go)")
	}
	eventsRel := filepath.Join("..", "..", "testdata", "ui", "texteditor_bigfile.events")
	claRel := []string{
		filepath.Join("..", "..", "examples", "texteditor.cla"),
		filepath.Join("..", "..", "testdata", "ui", "texteditor_bigfile_setup.cla"),
	}
	bin := buildNative68kUI(t, "texteditor_bigfile", eventsRel, claRel...)
	out, _, exitCode := RunMac(t, bin, 10*time.Minute)
	checkTexteditorBigfileCapture(t, out, exitCode)
}

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

// TestSuiteOn68k is native-5d Task 16's end gate, rebased by test-suite-
// review Task 9 onto the core suite's CLI composition (coreCLIMacFiles,
// the same files TestSuiteOnMac boots -- cli_mac.cla's own doc comment
// has the full story on why the Mac/native lanes need a different front
// end than the host's core/cli.cla): built via `clarusc emit68k` (no C,
// no cmake, no Retro68) and booted on the same emulator harness. Host
// expectation comes from RunCoreCLIHost/BuildCoreCLIHost (suite_host_
// test.go, the Go-compiler-free snapshot-clarusc host oracle, built with
// coreCLIHostFiles/cli.cla instead) -- identical expectation to
// TestSuiteOnMac's.
func TestSuiteOn68k(t *testing.T) {
	requireMac(t)
	expected := RunCoreCLIHost(t, BuildCoreCLIHost(t), "all")
	bin := buildNative68kMulti(t, "suite", absFiles(t, coreCLIMacFiles)...)
	got, _, exitCode := RunMac(t, bin, 15*time.Minute)
	if exitCode != 0 {
		t.Fatalf("suite exit code %d, want 0", exitCode)
	}
	if got != expected {
		t.Fatalf("native/host divergence:%s", firstDiff(expected, got))
	}
}

// TestRunErrOn68k mirrors TestRunErrOnMac (mac_test.go): each of the 6
// testdata/runerr/*.cla fixtures deliberately raises a runtime error
// (rt_panic, exit 3); the captured log must contain the matching .err
// golden's message.
func TestRunErrOn68k(t *testing.T) {
	requireMac(t)
	files, err := filepath.Glob(filepath.Join(repoRoot(t), "testdata", "runerr", "*.cla"))
	if err != nil || len(files) == 0 {
		t.Fatalf("no runerr corpus: %v", err)
	}
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

// TestAbortOn68k mirrors TestAbortAppsOnMac (mac_test.go): the two suite-
// excluded, abort-by-design run goldens (emit_array, emit_enum), each
// checked standalone against its pre-abort .out/.exit goldens.
func TestAbortOn68k(t *testing.T) {
	requireMac(t)
	for _, name := range []string{"emit_array", "emit_enum"} {
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
