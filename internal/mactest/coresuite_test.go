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
