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
// coreCLIMacFiles (since deleted by test-consolidation Task 7 alongside
// its last caller, TestSuiteOnMac -- see suite_host_test.go's
// coreCLIFiles comment) that swapped gui.cla in for cli_mac.cla. gui.cla
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
// capture for all 64 real CoreTest cases (63 + SelfCheck, runner.cla's
// own nCoreCases -- grown from 42 by the map-hashtable phase's
// sortedmap/hashtable-map/intmap case families, then 57 by the
// datetime-instrumentation phase's own case family, then 58 by the
// layer1-compiler-perf phase's own ClearBasics case, then 61 by the
// param-abi phase's ParamAliasGlobal/ParamAliasHandle/ParamBorrowChain
// cases, then 62 by that same phase's Task 5 fix round 1
// ParamNestedCallArg case, then 63 by that same phase's final-review fix
// wave ParamContainerElemArg case, then 64 by the Snow bake-path fix
// wave's own MiscArithWrap32 lane-parity regression case) PASS in this
// ONE boot, plus the matching TOTAL line --
// success criterion 2's native/GUI half (the host/CLI half is
// internal/testsuite's TestCoreSuiteCLI; the Mac/native CLI half, once
// TestSuiteOn68k in native_test.go, was retired by test-consolidation --
// see that file's own tombstone comment).
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
// pipeline (runBuildMac) rather than clarusc emit68k directly. This gave
// the suites the same "both lanes" assurance the legacy 23-scenario lane
// gave every other UI fixture -- that lane has since been retired down to
// the 4 frozen golden scenarios (test-consolidation, 2026-08-06).
func TestCoreSuiteGUIOnMac(t *testing.T) {
	requireCprintMac(t)
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
// shared result-log assertion (Task 12 factor-out; case count grown to
// 54 by the map-hashtable phase, 2026-08-10 -- 42 by the small-scalar-
// width phase's SerMixedScalarRec pin/task-6-review's own
// XRecFieldsRoundtrip, then 46/50/54 via that phase's sortedmap/
// hashtable-map/intmap case additions): parses the PASS/FAIL/TOTAL lines
// kit.cla's tkReport funnels every case through, requiring all 63 real
// CoreTest cases (62 + SelfCheck) PASS and the matching TOTAL line,
// regardless of which lane produced the capture.
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
	if passes != 64 {
		t.Errorf("PASS lines: got %d, want 64\ncapture:\n%s", passes, out)
	}
	if fails != 0 {
		t.Errorf("FAIL lines: got %d, want 0", fails)
	}
	if want := "TOTAL 64 PASS 64 FAIL 0"; total != want {
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
// cases_popuptable.cla (Popuptable) was added by Task 8 (ui-scenario-
// retirement batch migration) -- the retired testdata/ui/popuptable.cla
// golden UI scenario, migrated to the PopupTableWin window Task 8 also
// added to harness.cla. Task 8's own formedit batch-mate is NOT migrated
// here (a real native-68k `accepted(rec: T)` bool-field marshaling bug
// was found instead, see runner.cla's own doc comment and
// task-8-report.md) -- testdata/ui/formedit.cla stays an unretired golden
// scenario. cases_dialogs.cla/cases_hdim.cla (Dialogs/Hdim) were added by
// Task 9 (ui-scenario-retirement batch migration) -- the retired
// testdata/ui/dialogs.cla and hdim.cla golden UI scenarios, migrated to
// the DialogsWin and DimWin windows Task 9 also added to harness.cla.
// cases_formedit.cla (FormEdit) was added by test-consolidation Task 3,
// once the native-68k `accepted(rec: T)` trailing-bool marshaling bug
// blocking Task 8's own formedit migration was confirmed fixed (commit
// 8278ae7) -- the retired testdata/ui/formedit.cla golden UI scenario,
// migrated to the FormEditWin window Task 3 added to harness.cla (its own
// table-driving Main sibling deliberately not ported -- see harness.cla's
// FormEditWin comment). cases_bigtext.cla (BigText) was added by
// test-consolidation Task 4 -- migrates the retired native-only
// TestTexteditorBigfileOn68k/TestTexteditorBigfileUIScenario boots (audit
// rows N17/R10) into a >32,000-byte textview SET + clamp + lastError +
// tail-content-exact case against harness.cla's EXISTING TextWin window
// (Task 5's own addition, above) -- no harness.cla change needed; see
// cases_bigtext.cla's own header comment for the full assertion mapping.
// Unlike the core suite, gui.cla is this suite's ONLY front end -- there
// is no toolbox CLI (MenuKeyMatches needs the GUI's own installed File
// menu, CanvasChecksum needs the GUI's own Board canvas), so there is no
// toolboxCLIFiles/toolboxCLIMacFiles pair to mirror. toolbox/{memory,
// events,osutils,scrap}.cla + cases_catalog.cla (Catalog) were added by
// toolbox-cookbook Task 2 -- hardware-proves Task 1's shipped extern
// catalog against real ROM; the four toolbox/ files are grouped right
// after kit.cla (composition order is otherwise immaterial, a lowering
// pre-pass). cases_finfo.cla (FInfoStamp) was added by native-gaps-
// cleanup Task 3 -- hardware-proves Tasks 1-2's file.writeText stamp
// rule via a real PBGetFInfoSync readback, consuming toolbox/files.cla's
// FileParam/PBGetFInfoSync declarations (pack3-standardfile phase);
// toolbox/files.cla joins the other four toolbox/ catalog files in the
// same grouped block, right after kit.cla. toolbox/resources.cla +
// cases_resources.cla (ResourceBake/WriteResStamp) were added by Task 7
// (mac-resident-clarusc phase) -- hardware-proves the new
// `file.readResource`/`file.writeRes` intrinsics; toolbox/resources.cla
// joins the other five toolbox/ catalog files in the same grouped block,
// cases_resources.cla joins the other cases_*.cla files ahead of gui.cla.

// toolboxResourceBakeName MUST match testsuite/toolbox/cases_resources.cla's
// own tbResBakeName constant, character for character: Get1NamedResource
// keys a baked resource by exactly the string passed on the `--bake`
// command line (toolbox/resources.cla's own header comment; the design
// doc's "Key convention" section). "../../" is the walk from this
// suite's build cwd (this package's own directory) up to the repo root.
const toolboxResourceBakeName = "../../testdata/mac-resident/resbake.bin"

var toolboxFiles = []string{
	filepath.Join("testsuite", "kit.cla"),
	filepath.Join("toolbox", "memory.cla"),
	filepath.Join("toolbox", "events.cla"),
	filepath.Join("toolbox", "osutils.cla"),
	filepath.Join("toolbox", "scrap.cla"),
	filepath.Join("toolbox", "files.cla"),
	filepath.Join("toolbox", "resources.cla"),
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
	filepath.Join("testsuite", "toolbox", "cases_popuptable.cla"),
	filepath.Join("testsuite", "toolbox", "cases_dialogs.cla"),
	filepath.Join("testsuite", "toolbox", "cases_hdim.cla"),
	filepath.Join("testsuite", "toolbox", "cases_formedit.cla"),
	filepath.Join("testsuite", "toolbox", "cases_bigtext.cla"),
	filepath.Join("testsuite", "toolbox", "cases_catalog.cla"),
	filepath.Join("testsuite", "toolbox", "cases_finfo.cla"),
	filepath.Join("testsuite", "toolbox", "cases_resources.cla"),
	filepath.Join("testsuite", "toolbox", "cases_datetime.cla"),
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
// this test also parses each of the 25 result lines (24 real cases +
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
	toolboxArgs := append([]string{"--testapi", "--bake", toolboxResourceBakeName}, pkgRelFiles(toolboxFiles)...)
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
	requireCprintMac(t)
	eventsRel := filepath.Join("..", "..", "testdata", "ui", "toolboxsuite.events")
	// --testapi (Task 3, ui-scenario-retirement): build-mac.sh's own arg
	// loop needs a dedicated `--testapi` case (see that script) to handle
	// the flag explicitly, rather than relying on clarusc to parse it out
	// of the positional list (its loop treats unrecognized flags as .cla
	// files, which would be wrong). The dedicated case keeps the logic
	// clear in build-mac.sh itself.
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
// Zoomwin/Hscroll addition, then to 19 by Task 8's (ui-scenario-
// retirement batch migration) Popuptable addition -- Task 8's own
// formedit batch-mate is NOT included, see toolboxFiles' own doc comment
// above -- then to 21 by Task 9's (ui-scenario-retirement batch
// migration) Dialogs/Hdim addition, then to 22 by test-consolidation
// Task 3's own FormEdit addition (Task 8's formedit gap finally closed),
// then to 23 by test-consolidation Task 4's own BigText addition, then
// to 24 by toolbox-cookbook Task 2's own Catalog addition, then to 25 by
// native-gaps-cleanup Task 3's own FInfoStamp addition, then to 27 by
// Task 7's (mac-resident-clarusc) own ResourceBake/WriteResStamp
// addition, then to 28 by mac-resident-clarusc Task 15's own FieldCap
// addition (the language reference's live `string(n)` typing clamp, the
// pin for that task's cgStackHeuristic fix), then to 29 by
// datetime-instrumentation Task 7's own DateTimeRoundTrip addition, then
// to 30 by the live-log phase's own Task 1 LivePaint addition: parses
// each of the 30 result lines (29 real cases +
// SelfCheck) into its own t.Run subtest -- per-case CI reporting -- plus
// the aggregate TOTAL line, regardless of which lane produced the
// capture.
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

	if len(results) != 30 {
		t.Errorf("result lines: got %d, want 30\ncapture:\n%s", len(results), out)
	}
	for _, r := range results {
		r := r
		t.Run(r.name, func(t *testing.T) {
			if !r.passed {
				t.Errorf("FAIL: %s", r.detail)
			}
		})
	}
	if want := "TOTAL 30 PASS 30 FAIL 0"; total != want {
		t.Errorf("TOTAL line: got %q, want %q\ncapture:\n%s", total, want, out)
	}
}
