// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

package mactest

import (
	"bytes"
	"encoding/hex"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

// blessUI reports whether CLARUS_MAC_BLESS=1 is set: golden files are
// (re)written instead of compared. Independent of CLARUS_MAC_TESTS
// (requireMac still gates whether this runs at all).
func blessUI() bool {
	return os.Getenv("CLARUS_MAC_BLESS") != ""
}

// uiSnap is one decoded ##CLARUS-SNAP##...##CLARUS-SNAP-END## block from
// the capture stream (docs/superpowers/plans/2026-07-24-mac-target-4b.md's
// pinned snap encoding).
type uiSnap struct {
	name  string
	bytes []byte // raw framebuffer bytes, always 21,888 for the pinned 512x342 1-bit screen
}

// parseUIOutput splits RunMac's `out` stream (already stripped of the 4a
// exit trailer and log by parseCapture) into the RT_MAC_TEST trace lines
// (every "T ..." line, in order) and any snap blocks, per the plan's
// contract: both are interleaved into the same stream, in the order the
// runtime emitted them (rt_ui.c's rt_test_emit is the single hook for all
// of it -- see that file's header comment).
func parseUIOutput(t *testing.T, out string) (trace string, snaps []uiSnap) {
	t.Helper()
	lines := strings.Split(out, "\n")
	var traceLines []string
	i := 0
	for i < len(lines) {
		line := lines[i]
		switch {
		case strings.HasPrefix(line, "T "):
			traceLines = append(traceLines, line)
			i++
		case strings.HasPrefix(line, "##CLARUS-SNAP## "):
			name := strings.TrimPrefix(line, "##CLARUS-SNAP## ")
			i++
			var hexBuf strings.Builder
			for i < len(lines) && lines[i] != "##CLARUS-SNAP-END##" {
				hexBuf.WriteString(lines[i])
				i++
			}
			if i >= len(lines) {
				t.Fatalf("unterminated snap block %q in capture", name)
			}
			i++ // skip the END marker
			raw, err := hex.DecodeString(hexBuf.String())
			if err != nil {
				t.Fatalf("snap %q: malformed hex: %v", name, err)
			}
			snaps = append(snaps, uiSnap{name: name, bytes: raw})
		case line == "":
			i++
		default:
			t.Fatalf("unexpected capture line outside trace/snap: %q", line)
		}
	}
	trace = strings.Join(traceLines, "\n")
	if trace != "" {
		trace += "\n"
	}
	return trace, snaps
}

// pbmBytes wraps a snap's raw 21,888 bytes in the pinned P4 (raw PBM)
// header: "P4\n512 342\n" + the bytes as-is (1 bit per pixel, MSB first,
// same bit order the Mac's own screenBits already uses).
func pbmBytes(raw []byte) []byte {
	return append([]byte("P4\n512 342\n"), raw...)
}

// runUIScenarioSrc/runUIScenarioBuild (the Retro68/cprint-lane build+run
// helpers for a single .events-scripted scenario) were retired by test-
// consolidation Task 7 alongside their last four callers -- audit rows
// R3/R5/R8/R11, all DELETE (see each retired test's own comment below).
// The native lane (native_test.go's buildNative68kUI + uiScenarios68k)
// covers the identical scenarios/fixtures now; only checkUIGoldens (its
// shared golden-compare tail) survives, reused by that lane.

// checkUIGoldens was originally factored out (Task 12, native-5e) so the
// native (`clarusc emit68k`) boot lane could share the EXACT same
// trace/snap comparison the Retro68-ported lane used, rather than a second
// hand-copied implementation drifting out of sync with this one -- now
// that test-consolidation Task 7 has retired the Retro68 lane outright
// (audit rows R3/R5/R8/R11/R12), this IS the only comparison: the native
// lane (native_test.go) is its sole caller, and CLARUS_MAC_BLESS=1 only
// ever fires from a native-lane boot. Parses `out` (parseUIOutput),
// compares the trace against testdata/ui/<scenario>.trace and every snap
// against testdata/uisnaps/<scenario>.<name>.pbm byte-exact (or rewrites
// both under CLARUS_MAC_BLESS=1), and asserts exitCode == wantExit.
// Returns the decoded snaps (callers use them for extra per-scenario snap
// assertions, e.g. checkSmokeMandelSnaps/checkBookmarksSnaps below).
func checkUIGoldens(t *testing.T, scenario string, out string, exitCode int, wantExit int) []uiSnap {
	t.Helper()
	root := repoRoot(t)
	trace, snaps := parseUIOutput(t, out)

	traceGolden := filepath.Join(root, "testdata", "ui", scenario+".trace")
	if blessUI() {
		if err := os.WriteFile(traceGolden, []byte(trace), 0o644); err != nil {
			t.Fatalf("writing trace golden: %v", err)
		}
	} else {
		want, err := os.ReadFile(traceGolden)
		if err != nil {
			t.Fatalf("reading trace golden %s: %v", traceGolden, err)
		}
		if trace != string(want) {
			t.Fatalf("%s: trace mismatch:%s", scenario, firstDiff(string(want), trace))
		}
	}

	for _, s := range snaps {
		if len(s.bytes) != 21888 {
			t.Fatalf("%s: snap %q decoded to %d bytes, want 21888", scenario, s.name, len(s.bytes))
		}
		pbmPath := filepath.Join(root, "testdata", "uisnaps", scenario+"."+s.name+".pbm")
		pbm := pbmBytes(s.bytes)
		if blessUI() {
			if err := os.WriteFile(pbmPath, pbm, 0o644); err != nil {
				t.Fatalf("writing snap golden %s: %v", pbmPath, err)
			}
			continue
		}
		want, err := os.ReadFile(pbmPath)
		if err != nil {
			t.Fatalf("reading snap golden %s: %v", pbmPath, err)
		}
		if !bytes.Equal(pbm, want) {
			t.Fatalf("%s: snap %q mismatch against %s (byte-exact PBM compare failed)", scenario, s.name, pbmPath)
		}
	}

	if exitCode != wantExit {
		t.Errorf("%s: exit code: got %d, want %d", scenario, exitCode, wantExit)
	}
	return snaps
}

// TestUIAbout was retired by test-consolidation Task 5 (audit row R2,
// DELETE -- gap accepted per the audit's Decision 2: no suite GUI declares
// an `app` section or clicks the Apple menu, so About-item dispatch has no
// Retro68/real-Toolbox replacement and becomes native-lane-only, via
// TestAboutOn68k's own retirement into smoke_mandel's row, audit row N8
// MERGE->N10). testdata/ui/about.cla itself is NOT deleted:
// TestApp68kResourceParity (resparity_test.go) depends on it independently
// as its own "no declared icon" probe fixture, unrelated to this UI-
// scenario coverage -- only about.events/about.trace (this scenario's own
// event script + golden) were retired alongside this test.

// TestSmokeBounceUIScenario (the Retro68/cprint-lane bounce boot) was
// retired by test-consolidation Task 7 -- audit row R3, DELETE: the
// ball-moved-between-snaps proof it gave is native-only now, via
// TestSmokeBounceOn68k (native_test.go), which drives the SAME
// testdata/valid/bounce.cla + smoke_bounce.events + testdata/uisnaps/
// smoke_bounce.*.pbm goldens (unchanged, still consumed by that lane); a
// generic real-Toolbox canvas draw/animate path is separately covered by
// testsuite/toolbox/cases_canvas.cla, via TestToolboxSuiteOnMac (R22).

// TestSmokeMenuDemoUIScenario was retired by test-consolidation Task 5
// (audit row R4, DELETE -- already covered by testsuite/toolbox/
// cases_menus.cla's app-scope + window-scoped menu items with dim/undim,
// plus cases_events.cla:87's MenuKeyMatches for shortcut dispatch; see
// audit claim 3 -- smoke_menudemo.events itself never actually pressed a
// keyboard shortcut, only `menu` verb lines, so its own name overclaimed
// coverage it never tested). examples/menu-demo.cla itself is untouched
// (still the toolbox suite's own GUI-menu vocabulary example); only
// smoke_menudemo.events/.trace and its testdata/uisnaps/smoke_menudemo.
// S1.pbm snap (this scenario's own fixtures, no other consumer) were
// retired alongside this test.

// TestSmokeMandelUIScenario (the Retro68/cprint-lane mandelbrot boot,
// which folded in the retired `about` scenario's own About-box coverage
// per test-consolidation Task 5, audit row N8 MERGE->N10) was itself
// retired by test-consolidation Task 7 -- audit row R5, DELETE: its
// progressive-render + About-item proof is native-only now, via
// TestUiScenariosOn68k's "smoke_mandel" row (native_test.go, still using
// this same checkSmokeMandelSnaps below against the SAME examples/
// mandelbrot.cla + smoke_mandel.events + testdata/uisnaps/smoke_mandel.*.pbm
// goldens, unchanged); a generic real-Toolbox canvas path is separately
// covered by testsuite/toolbox/cases_canvas.cla, via TestToolboxSuiteOnMac
// (R22).

// checkSmokeMandelSnaps is TestSmokeMandelUIScenario's own snap assertion,
// factored out (Task 14, native-5e) for reuse by the native lane.
func checkSmokeMandelSnaps(t *testing.T, snaps []uiSnap) {
	t.Helper()
	byName := map[string][]byte{}
	for _, s := range snaps {
		byName[s.name] = s.bytes
	}
	if byName["S1"] == nil || byName["S2"] == nil || byName["S3"] == nil {
		t.Fatalf("smoke_mandel: expected snaps S1, S2, S3; got %d snap(s)", len(snaps))
	}
	if bytes.Equal(byName["S1"], byName["S2"]) {
		t.Fatalf("smoke_mandel: S1 == S2 -- the render did not progress between snaps")
	}
	if bytes.Equal(byName["S2"], byName["S3"]) {
		t.Fatalf("smoke_mandel: S2 == S3 -- File > New did not restart the render")
	}
}

// TestOpenDocUIScenario/TestOpenDocEmptyUIScenario were retired by
// test-consolidation Task 5 (audit rows R6/R7, DELETE -- gap accepted per
// the audit's Decision 2: no suite GUI exercises App.openDocument/
// GetAppFiles, so doc-launch coverage has no Retro68/real-Toolbox
// replacement and becomes native-lane-only). Both scenarios' own unique
// proofs live on natively: opendoc's GetAppFiles-launch dispatch
// (including the space-containing path) folded into texteditor's own
// row, audit row N11 MERGE->N14 (see TestTexteditorUIScenario below);
// opendoc_empty's App.startEmpty fallback needed no fold at all --
// texteditor.events already exercises that path whenever no launchdoc
// line is queued ahead of it (audit row N12, DELETE, redundant).
// testdata/ui/opendoc.cla (shared by both retired scenarios, no other
// consumer) and both scenarios' own events/trace/snap goldens were
// deleted alongside these tests.

// TestTexteditorUIScenario (Task 6, mac-target-4c; grew a launchdoc/
// opendoc fold via test-consolidation Task 5, audit row N11 MERGE->N14,
// and a multi-window quit-cascade fold, audit row N15 MERGE->N14) was
// itself retired by test-consolidation Task 7 -- audit row R8, DELETE:
// its full round-trip/launch/quit-cascade proof is native-only now, via
// TestUiScenariosOn68k's "texteditor" row (native_test.go), which drives
// the SAME examples/texteditor.cla + testdata/ui/
// texteditor_opendoc_setup.cla + texteditor.events + testdata/uisnaps/
// texteditor.*.pbm goldens (unchanged, still consumed by that lane, still
// this file's checkUIGoldens for the compare); generic textview/dialog
// Toolbox paths are separately covered by testsuite/toolbox/
// cases_textwidgets.cla + cases_dialogs.cla, via TestToolboxSuiteOnMac
// (R22).

// TestTexteditorQuitUIScenario was retired by test-consolidation Task 5
// (audit row R9, DELETE -- its multi-window quit-cascade proof folded
// onto TestTexteditorUIScenario's own tail instead, audit row N15
// MERGE->N14; see that test's own header comment). texteditor_quit.events/
// .trace (this scenario's own fixtures, no other consumer) were deleted
// alongside this test.

// TestTexteditorBigfileUIScenario/checkTexteditorBigfileCapture (Task 6,
// mac-target-4c) were retired by test-consolidation Task 4: the
// >32,000-byte open guard's generic clamp/lastError/tail-content shape now
// lives in the toolbox suite's own `BigText` case
// (testsuite/toolbox/cases_bigtext.cla) -- see that file's header comment
// for the full assertion mapping and for what stays native-only (this
// guard's own alert-message/close-cascade business logic, still covered by
// examples/texteditor.cla staying in the `texteditor` acceptance boot,
// audit rows N14/N15 -- N15 (texteditor_quit) itself merged into that same
// boot's own tail by test-consolidation Task 5).

// TestBookmarksUIScenario (mac-target-4d Task 9's Retro68/cprint-lane
// bookmarks boot -- see git history for the full add/edit/remove/
// persistence-wiring narrative this test once carried) was retired by
// test-consolidation Task 7 -- audit row R11, DELETE: its full proof is
// native-only now, via TestUiScenariosOn68k's "bookmarks" row
// (native_test.go), which drives the SAME examples/bookmarks.cla +
// bookmarks.events + testdata/uisnaps/bookmarks.*.pbm goldens (unchanged,
// still consumed by that lane, still this file's checkBookmarksSnaps
// below for the extra per-scenario assertions); real file I/O and
// form-pattern Toolbox paths are separately covered by testsuite/toolbox/
// cases_dialogs.cla + cases_popuptable.cla, via TestToolboxSuiteOnMac
// (R22).

// checkBookmarksSnaps is TestBookmarksUIScenario's own snap assertion,
// factored out (Task 14, native-5e) for reuse by the native lane.
func checkBookmarksSnaps(t *testing.T, snaps []uiSnap) {
	t.Helper()
	var s1, s2, s3, s4, s5 []byte
	for _, s := range snaps {
		switch s.name {
		case "S1":
			s1 = s.bytes
		case "S2":
			s2 = s.bytes
		case "S3":
			s3 = s.bytes
		case "S4":
			s4 = s.bytes
		case "S5":
			s5 = s.bytes
		}
	}
	if s1 == nil || s2 == nil || s3 == nil || s4 == nil || s5 == nil {
		t.Fatalf("bookmarks: expected snaps S1-S5, got %d snap(s)", len(snaps))
	}
	if bytes.Equal(s1, s2) {
		t.Fatalf("bookmarks: snap S1 == S2 -- fixing the port and accepting did not add a row")
	}
	if bytes.Equal(s2, s3) {
		t.Fatalf("bookmarks: snap S2 == S3 -- adding the second bookmark did not add a row")
	}
	if bytes.Equal(s3, s4) {
		t.Fatalf("bookmarks: snap S3 == S4 -- the edit round did not change the table's row")
	}
	if bytes.Equal(s4, s5) {
		t.Fatalf("bookmarks: snap S4 == S5 -- Remove did not delete a row")
	}
}
