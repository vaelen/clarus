// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

package mactest

import (
	"path/filepath"
	"strings"
	"testing"
	"time"
)

// coreGUIFiles is coreCLIFiles (testsuite/kit.cla + core/runner.cla +
// every core/cases_*.cla) + core/gui.cla -- the Mac GUI build
// composition (test-suite-review Task 10), a sibling of Task 9's
// coreCLIMacFiles that swaps gui.cla in for cli_mac.cla. gui.cla
// declares a `window`, so cg68k's UI-program startup path (rtUiLaunch,
// runtime/clarus/ui.cla) dispatches App.startEmpty correctly -- unlike
// the non-UI entry path cli_mac.cla's own doc comment escalates (Task
// 9's report, native-compat gap #4), which a UI program never reaches.
var coreGUIFiles = append(append([]string{}, coreCLIFiles...), filepath.Join("testsuite", "core", "gui.cla"))

// TestCoreSuiteGUIOn68k is the core suite's Mac GUI front-end gate
// (test-suite-review Task 10): one native 68k boot (buildNative68kUI --
// clarusc emit68k directly, no Retro68/cmake/C, the same lane
// TestSmokeBounceOn68k pioneered for native UI), driven by
// testdata/ui/coresuite.events (one click on the Run All button --
// coordinate derived from gui.cla's own fixed `at:` widget positions
// plus rt_ui_open's screen-centering math; see gui.cla's header comment
// for the arithmetic -- then `quit`).
//
// Unlike every OTHER native UI gate in this package, this scenario is
// deliberately NOT one of the frozen 23 golden scenarios: there is no
// testdata/ui/coresuite.trace or testdata/uisnaps entry, and none should
// ever be added here -- the gate is content-based, not a golden
// trace/snap comparison. gui.cla's own guiRunAndReport funnels every
// result through kit.cla's tkReport, which alert()s a `PASS <name>` or
// `FAIL <name>: <detail>` line per case plus a final `TOTAL n PASS p
// FAIL f` line -- exactly the log RunMac's capture protocol already
// surfaces as `out` for any other native boot. This test parses that
// capture for all 41 real CoreTest cases (40 + SelfCheck, runner.cla's
// own nCoreCases) PASS in this ONE boot, plus the matching TOTAL line --
// success criterion 2's native/GUI half (the host/CLI half is
// internal/testsuite's TestCoreSuiteCLI; the Mac/native CLI half is
// TestSuiteOn68k in native_test.go).
func TestCoreSuiteGUIOn68k(t *testing.T) {
	requireMac(t)
	eventsRel := filepath.Join("..", "..", "testdata", "ui", "coresuite.events")
	bin := buildNative68kUI(t, "coresuite_gui", eventsRel, pkgRelFiles(coreGUIFiles)...)
	out, _, exitCode := RunMac(t, bin, 5*time.Minute)
	if exitCode != 0 {
		t.Fatalf("coresuite GUI exit code %d, want 0\ncapture:\n%s", exitCode, out)
	}
	checkCoreSuiteCapture(t, out)
}

// TestCoreSuiteGUIOnMac (Task 12) is TestCoreSuiteGUIOn68k's Retro68/cprint-
// lane twin: same coreGUIFiles composition, same coresuite.events script,
// same result-log contract (checkCoreSuiteCapture, factored out below so
// both lanes share one assertion body instead of two copies drifting
// apart) -- but built through scripts/build-mac.sh's Retro68/cmake/gcc
// pipeline (runBuildMac) rather than clarusc emit68k directly. This is the
// "both lanes" assurance the legacy 23-scenario lane already gives every
// OTHER UI fixture, now extended to the suites.
func TestCoreSuiteGUIOnMac(t *testing.T) {
	requireMac(t)
	eventsRel := filepath.Join("..", "..", "testdata", "ui", "coresuite.events")
	args := append(pkgRelFiles(coreGUIFiles), "--test", "--events", eventsRel)
	bin := runBuildMac(t, "coresuite_gui_mac", args...)
	out, _, exitCode := RunMac(t, bin, 5*time.Minute)
	if exitCode != 0 {
		t.Fatalf("coresuite GUI (Retro68) exit code %d, want 0\ncapture:\n%s", exitCode, out)
	}
	checkCoreSuiteCapture(t, out)
}

// checkCoreSuiteCapture is TestCoreSuiteGUIOn68k/TestCoreSuiteGUIOnMac's
// shared result-log assertion (Task 12 factor-out; case count bumped to
// 41 by task-6-review's own XRecFieldsRoundtrip addition): parses the
// PASS/FAIL/TOTAL lines kit.cla's tkReport funnels every case through,
// requiring all 41 real CoreTest cases (40 + SelfCheck) PASS and the
// matching TOTAL line, regardless of which lane produced the capture.
func checkCoreSuiteCapture(t *testing.T, out string) {
	t.Helper()
	var passes, fails int
	var total string
	for _, line := range strings.Split(out, "\n") {
		switch {
		case strings.HasPrefix(line, "PASS "):
			passes++
		case strings.HasPrefix(line, "FAIL "):
			fails++
			t.Errorf("case failed: %s", line)
		case strings.HasPrefix(line, "TOTAL "):
			total = line
		}
	}
	if passes != 41 {
		t.Errorf("PASS lines: got %d, want 41\ncapture:\n%s", passes, out)
	}
	if fails != 0 {
		t.Errorf("FAIL lines: got %d, want 0", fails)
	}
	if want := "TOTAL 41 PASS 41 FAIL 0"; total != want {
		t.Errorf("TOTAL line: got %q, want %q\ncapture:\n%s", total, want, out)
	}
}

// toolboxFiles is the toolbox suite's Mac build composition
// (test-suite-review Task 11): testsuite/kit.cla (shared TestResult/
// tkPass/tkFail/tkReport contract, reused as-is from the core suite) +
// testsuite/toolbox/runner.cla + cases_events.cla + cases_draw.cla +
// cases_a5.cla + cases_gestalt.cla + cases_event.cla + harness.cla +
// cases_uitest.cla + gui.cla.
// cases_a5.cla (A5Live) was added by Task 13's own coverage-honesty audit
// -- see that file's header comment. cases_gestalt.cla (GestaltNamed) was
// added by Task 2 (toolbox-integration) -- the generalized named-register
// trap clause's native gate. cases_event.cla (EventXRec) was added by
// Task 6 (toolbox-integration Feature B) -- `extern record` native
// storage/decay against a real OSEventAvail trap. harness.cla (the
// UiProbe window) + cases_uitest.cla (UiTestVerbSmoke/PostEventClick)
// were added by Task 3 (ui-scenario-retirement) -- the `UiTest*` driver
// surface (uitest.cla) end to end plus a real PostEvent-queued click;
// this build now needs `--testapi` (below) for UiTestClick/UiTestVerb to
// resolve at all (see runtime/clarus/uitest.cla's own header comment).
// cases_pattern.cla (Pattern) was added by Task 4 (ui-scenario-retirement
// pilot migration) -- the retired testdata/ui/pattern.cla golden UI
// scenario, migrated to five UiTestChecksum region assertions against
// harness.cla's PatBoard window (also added by Task 4). cases_buttons.cla/
// cases_winvar.cla/cases_textwidgets.cla (Buttons/Winvar/Textwidgets) were
// added by Task 5 (ui-scenario-retirement batch migration) -- the retired
// testdata/ui/buttons.cla, winvar.cla, and textwidgets.cla golden UI
// scenarios, migrated to the ButtonsPanel/LogWin/TextWin windows Task 5
// also added to harness.cla. cases_menus.cla/cases_editmenu.cla (Menus/
// Editmenu) were added by Task 6 (ui-scenario-retirement batch
// migration) -- the retired testdata/ui/menus.cla and editmenu.cla
// golden UI scenarios, migrated to the MenuMain/MenuAux/Ops and
// EditMain/Edit windows/menus Task 6 also added to harness.cla.
// cases_canvas.cla/cases_zoomwin.cla/cases_hscroll.cla (Canvas/Zoomwin/
// Hscroll) were added by Task 7 (ui-scenario-retirement batch migration)
// -- the retired testdata/ui/canvas.cla, zoomwin.cla, and hscroll.cla
// golden UI scenarios, migrated to the CanvasWin, ZoomWin, and
// HScrollWin/HFitWin windows Task 7 also added to harness.cla.
// Unlike the core suite, gui.cla is this suite's ONLY front end -- there
// is no toolbox CLI (MenuKeyMatches needs the GUI's own installed File
// menu, CanvasChecksum needs the GUI's own Board canvas), so there is no
// toolboxCLIFiles/toolboxCLIMacFiles pair to mirror.
var toolboxFiles = []string{
	filepath.Join("testsuite", "kit.cla"),
	filepath.Join("testsuite", "toolbox", "runner.cla"),
	filepath.Join("testsuite", "toolbox", "cases_events.cla"),
	filepath.Join("testsuite", "toolbox", "cases_draw.cla"),
	filepath.Join("testsuite", "toolbox", "cases_a5.cla"),
	filepath.Join("testsuite", "toolbox", "cases_gestalt.cla"),
	filepath.Join("testsuite", "toolbox", "cases_event.cla"),
	filepath.Join("testsuite", "toolbox", "harness.cla"),
	filepath.Join("testsuite", "toolbox", "cases_uitest.cla"),
	filepath.Join("testsuite", "toolbox", "cases_pattern.cla"),
	filepath.Join("testsuite", "toolbox", "cases_buttons.cla"),
	filepath.Join("testsuite", "toolbox", "cases_winvar.cla"),
	filepath.Join("testsuite", "toolbox", "cases_textwidgets.cla"),
	filepath.Join("testsuite", "toolbox", "cases_menus.cla"),
	filepath.Join("testsuite", "toolbox", "cases_editmenu.cla"),
	filepath.Join("testsuite", "toolbox", "cases_canvas.cla"),
	filepath.Join("testsuite", "toolbox", "cases_zoomwin.cla"),
	filepath.Join("testsuite", "toolbox", "cases_hscroll.cla"),
	filepath.Join("testsuite", "toolbox", "gui.cla"),
}

// TestToolboxSuiteOn68k is the toolbox suite's one-boot gate
// (test-suite-review Task 11): one native 68k boot (buildNative68kUI,
// same lane as TestCoreSuiteGUIOn68k above), driven by
// testdata/ui/toolboxsuite.events (one click on the Run All button --
// coordinate derived from testsuite/toolbox/gui.cla's own fixed `at:`
// widget positions plus rt_ui_open's screen-centering math; see that
// file's header comment for the arithmetic -- then `quit`). Unlike the
// core suite's cases (pure in-memory Clarus data-structure exercises),
// every one of this suite's cases calls a REAL Toolbox trap or reads the
// REAL screen framebuffer in-process -- the paths no scripted golden
// reaches (see testsuite/toolbox/cases_events.cla's header comment).
//
// Same "deliberately NOT one of the frozen 23 golden scenarios" note as
// TestCoreSuiteGUIOn68k above -- content-based gate, no
// testdata/ui/toolboxsuite.trace or testdata/uisnaps entry.
//
// Beyond the aggregate PASS/FAIL/TOTAL check TestCoreSuiteGUIOn68k does,
// this test also parses each of the 18 result lines (17 real cases +
// SelfCheck, runner.cla's own nTbCases) into its own `t.Run(caseName,
// ...)` subtest -- per-case CI reporting (goal 5), so a single
// regressed case shows up as its own named red subtest rather than only
// a generic aggregate failure.
//
// `--testapi` (Task 3, ui-scenario-retirement) is prepended to the
// positional file list rather than added as a fixed buildNative68kUI
// parameter: clarusc's own arg loop recognizes `--testapi` at ANY
// position among its args (main.cla's while loop scans every arg,
// diverting known flags out regardless of where they land), so this is
// the smallest diff that gets the flag to clarusc without touching
// buildNative68kUI's shared signature (every OTHER caller -- smoke/about/
// coresuite -- must stay byte-identical, per this phase's own byte-
// identity gate).
func TestToolboxSuiteOn68k(t *testing.T) {
	requireMac(t)
	eventsRel := filepath.Join("..", "..", "testdata", "ui", "toolboxsuite.events")
	toolboxArgs := append([]string{"--testapi"}, pkgRelFiles(toolboxFiles)...)
	bin := buildNative68kUI(t, "toolboxsuite_gui", eventsRel, toolboxArgs...)
	out, _, exitCode := RunMac(t, bin, 5*time.Minute)
	if exitCode != 0 {
		t.Fatalf("toolbox suite exit code %d, want 0\ncapture:\n%s", exitCode, out)
	}
	checkToolboxSuiteCapture(t, out)
}

// TestToolboxSuiteOnMac (Task 12) is TestToolboxSuiteOn68k's Retro68/
// cprint-lane twin -- same toolboxFiles composition, same
// toolboxsuite.events script, same per-case result assertion
// (checkToolboxSuiteCapture below), built via runBuildMac instead of
// buildNative68kUI. See TestCoreSuiteGUIOnMac's doc comment for why this
// pairing exists.
func TestToolboxSuiteOnMac(t *testing.T) {
	requireMac(t)
	eventsRel := filepath.Join("..", "..", "testdata", "ui", "toolboxsuite.events")
	// --testapi (Task 3, ui-scenario-retirement): build-mac.sh's own arg
	// loop needs a dedicated `--testapi` case (see that script) since,
	// unlike clarusc's own arg parser, its loop otherwise treats any
	// unrecognized flag as a positional .cla file -- which would then
	// also reach the script's `clarusc appinfo` call (wrong: appinfo mode
	// never parses --testapi and would try to open it as a file).
	args := append(pkgRelFiles(toolboxFiles), "--test", "--events", eventsRel, "--testapi")
	bin := runBuildMac(t, "toolboxsuite_gui_mac", args...)
	out, _, exitCode := RunMac(t, bin, 5*time.Minute)
	if exitCode != 0 {
		t.Fatalf("toolbox suite (Retro68) exit code %d, want 0\ncapture:\n%s", exitCode, out)
	}
	checkToolboxSuiteCapture(t, out)
}

// checkToolboxSuiteCapture is TestToolboxSuiteOn68k/TestToolboxSuiteOnMac's
// shared result-log assertion (Task 12 factor-out; case count bumped to 5
// by Task 13's A5Live addition, then to 6 by Task 2's (toolbox-
// integration) GestaltNamed addition, then to 7 by Task 6's (toolbox-
// integration Feature B) EventXRec addition, then to 9 by Task 3's
// (ui-scenario-retirement) UiTestVerbSmoke/PostEventClick addition, then
// to 10 by Task 4's (ui-scenario-retirement pilot migration) Pattern
// addition, then to 13 by Task 5's (ui-scenario-retirement batch
// migration) Buttons/Winvar/Textwidgets addition, then to 15 by Task 6's
// (ui-scenario-retirement batch migration) Menus/Editmenu addition, then
// to 18 by Task 7's (ui-scenario-retirement batch migration) Canvas/
// Zoomwin/Hscroll addition): parses each of the 18 result lines (17 real
// cases + SelfCheck) into its own t.Run subtest -- per-case CI
// reporting -- plus the aggregate TOTAL line, regardless of which lane
// produced the capture.
func checkToolboxSuiteCapture(t *testing.T, out string) {
	t.Helper()
	type caseResult struct {
		name   string
		passed bool
		detail string
	}
	var results []caseResult
	var total string
	for _, line := range strings.Split(out, "\n") {
		switch {
		case strings.HasPrefix(line, "PASS "):
			results = append(results, caseResult{name: strings.TrimPrefix(line, "PASS "), passed: true})
		case strings.HasPrefix(line, "FAIL "):
			rest := strings.TrimPrefix(line, "FAIL ")
			name, detail, _ := strings.Cut(rest, ": ")
			results = append(results, caseResult{name: name, passed: false, detail: detail})
		case strings.HasPrefix(line, "TOTAL "):
			total = line
		}
	}

	if len(results) != 18 {
		t.Errorf("result lines: got %d, want 18\ncapture:\n%s", len(results), out)
	}
	for _, r := range results {
		r := r
		t.Run(r.name, func(t *testing.T) {
			if !r.passed {
				t.Errorf("FAIL: %s", r.detail)
			}
		})
	}
	if want := "TOTAL 18 PASS 18 FAIL 0"; total != want {
		t.Errorf("TOTAL line: got %q, want %q\ncapture:\n%s", total, want, out)
	}
}
