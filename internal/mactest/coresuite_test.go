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
// capture for all 40 real CoreTest cases (39 + SelfCheck, runner.cla's
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
	if passes != 40 {
		t.Errorf("PASS lines: got %d, want 40\ncapture:\n%s", passes, out)
	}
	if fails != 0 {
		t.Errorf("FAIL lines: got %d, want 0", fails)
	}
	if want := "TOTAL 40 PASS 40 FAIL 0"; total != want {
		t.Errorf("TOTAL line: got %q, want %q\ncapture:\n%s", total, want, out)
	}
}

// toolboxFiles is the toolbox suite's Mac build composition
// (test-suite-review Task 11): testsuite/kit.cla (shared TestResult/
// tkPass/tkFail/tkReport contract, reused as-is from the core suite) +
// testsuite/toolbox/runner.cla + cases_events.cla + cases_draw.cla +
// gui.cla. Unlike the core suite, gui.cla is this suite's ONLY front
// end -- there is no toolbox CLI (MenuKeyMatches needs the GUI's own
// installed File menu, CanvasChecksum needs the GUI's own Board canvas),
// so there is no toolboxCLIFiles/toolboxCLIMacFiles pair to mirror.
var toolboxFiles = []string{
	filepath.Join("testsuite", "kit.cla"),
	filepath.Join("testsuite", "toolbox", "runner.cla"),
	filepath.Join("testsuite", "toolbox", "cases_events.cla"),
	filepath.Join("testsuite", "toolbox", "cases_draw.cla"),
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
// this test also parses each of the 4 result lines (3 real cases +
// SelfCheck, runner.cla's own nTbCases) into its own `t.Run(caseName,
// ...)` subtest -- per-case CI reporting (goal 5), so a single
// regressed case shows up as its own named red subtest rather than only
// a generic aggregate failure.
func TestToolboxSuiteOn68k(t *testing.T) {
	requireMac(t)
	eventsRel := filepath.Join("..", "..", "testdata", "ui", "toolboxsuite.events")
	bin := buildNative68kUI(t, "toolboxsuite_gui", eventsRel, pkgRelFiles(toolboxFiles)...)
	out, _, exitCode := RunMac(t, bin, 5*time.Minute)
	if exitCode != 0 {
		t.Fatalf("toolbox suite exit code %d, want 0\ncapture:\n%s", exitCode, out)
	}

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

	if len(results) != 4 {
		t.Errorf("result lines: got %d, want 4\ncapture:\n%s", len(results), out)
	}
	for _, r := range results {
		r := r
		t.Run(r.name, func(t *testing.T) {
			if !r.passed {
				t.Errorf("FAIL: %s", r.detail)
			}
		})
	}
	if want := "TOTAL 4 PASS 4 FAIL 0"; total != want {
		t.Errorf("TOTAL line: got %q, want %q\ncapture:\n%s", total, want, out)
	}
}
