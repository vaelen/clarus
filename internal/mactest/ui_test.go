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
	"time"
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

// runUIScenario builds testdata/ui/<scenario>.cla with its .events script
// (scripts/build-mac.sh --test --events), runs it via the 4a LaunchAPPL
// plumbing, and checks the trace against testdata/ui/<scenario>.trace and
// every snap against testdata/uisnaps/<scenario>.<name>.pbm -- byte-exact,
// unless CLARUS_MAC_BLESS=1, in which case both are (re)written instead
// (snap size and exit code are still asserted even while blessing).
func runUIScenario(t *testing.T, scenario string, wantExit int) []uiSnap {
	t.Helper()
	return runUIScenarioSrc(t, scenario, filepath.Join("..", "..", "testdata", "ui", scenario+".cla"), wantExit)
}

// runUIScenarioSrc is runUIScenario with an explicit source .cla path
// (package-dir-relative) instead of the default testdata/ui/<scenario>.cla
// convention -- Task 7 (mac-target-4b)'s acceptance-example smokes build
// the EXAMPLES THEMSELVES (testdata/valid/bounce.cla, examples/menu-demo.cla)
// directly, with only the .events script (and the trace/snap goldens) living
// under testdata/ui/ per the usual convention.
func runUIScenarioSrc(t *testing.T, scenario string, claRel string, wantExit int) []uiSnap {
	t.Helper()
	requireMac(t)
	root := repoRoot(t)
	eventsRel := filepath.Join("..", "..", "testdata", "ui", scenario+".events")
	name := "UI" + strings.ToUpper(scenario[:1]) + scenario[1:]

	bin := runBuildMac(t, name, claRel, "--test", "--events", eventsRel)
	out, _, exitCode := RunMac(t, bin, 3*time.Minute)
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

// TestButtonsUIScenario: window with button/check/label, no menus, no
// canvas -- click/key/resize/close-box dispatch, no snaps.
func TestButtonsUIScenario(t *testing.T) {
	runUIScenario(t, "buttons", 0)
}

// TestMenusUIScenario: two window types, app-scope + window-scoped menu
// items, dimming transitions on open/close of the scoped window.
func TestMenusUIScenario(t *testing.T) {
	runUIScenario(t, "menus", 0)
}

// TestTextwidgetsUIScenario (mac-target-4c Task 2): field/textview widgets
// end to end -- field.change/enter and textview.change dispatch, field.text/
// textview.text read+write, and the CARRIED review requirement from Task 1:
// the RTUI_TE_MAX (32,000-byte) clamp boundary on textview.text set, BOTH
// sides independently snapped (exactly at the clamp: no truncation, no
// lastError, snap "ok32000"; one byte over: truncated to 32,000 + lastError
// set, snap "trunc32001") so an off-by-one clamp regression in either
// direction fails a specific golden rather than being masked by the other
// click's title/content overwrite -- each outcome is round-tripped into the
// window title and verified via its own snap's title bar (rt_ui_set_title
// has no RT_MAC_TEST trace line of its own). The two snaps asserted
// different here guards against both being blessed identical by accident
// (same non-accidental-golden guard TestCanvasUIScenario uses). See
// testdata/ui/textwidgets.cla's own header comment for the full scripted
// walkthrough and why the .events file uses `key 13` rather than an
// embedded raw CR byte.
func TestTextwidgetsUIScenario(t *testing.T) {
	snaps := runUIScenario(t, "textwidgets", 0)
	var ok, trunc []byte
	for _, s := range snaps {
		switch s.name {
		case "ok32000":
			ok = s.bytes
		case "trunc32001":
			trunc = s.bytes
		}
	}
	if ok == nil || trunc == nil {
		t.Fatalf("textwidgets: expected snaps ok32000 and trunc32001, got %d snap(s)", len(snaps))
	}
	if bytes.Equal(ok, trunc) {
		t.Fatalf("textwidgets: snap ok32000 == trunc32001 -- the clamp/lastError outcome did not actually change the title between the two clicks")
	}
}

// TestCanvasUIScenario: buffered canvas animated by an every-block; two
// snaps (S1, S2) taken after different amounts of virtual-tick animation
// must differ (the moving square's position proves it) -- checked here
// directly, in addition to each snap's own byte-exact PBM golden compare,
// so a golden pair blessed identical by accident (e.g. no actual motion)
// fails loudly rather than silently passing forever after.
func TestCanvasUIScenario(t *testing.T) {
	snaps := runUIScenario(t, "canvas", 0)
	var s1, s2 []byte
	for _, s := range snaps {
		switch s.name {
		case "S1":
			s1 = s.bytes
		case "S2":
			s2 = s.bytes
		}
	}
	if s1 == nil || s2 == nil {
		t.Fatalf("canvas: expected snaps S1 and S2, got %d snap(s)", len(snaps))
	}
	if bytes.Equal(s1, s2) {
		t.Fatalf("canvas: snap S1 == S2 -- animation did not move the square between snaps")
	}
}

// TestPatternUIScenario: the canvas `pattern` method (Ch11) -- one snap
// showing the 9-level dither ramp, clamped out-of-range levels, the
// FillOval path, and a frame op unaffected by the fill pattern.
func TestPatternUIScenario(t *testing.T) {
	runUIScenario(t, "pattern", 0)
}

// TestEditMenuUIScenario (Task 3, mac-target-4c): `menu Edit { standard
// edit }` end to end -- cut from textview A, paste into B (the snap proves
// the text moved), Copy's no-change-event pin, Undo's unreachable dispatch
// (asserted by the golden trace having no line for it at all), and the
// Cut/Copy/Paste/Clear dim transitions on focus-gain and on the window
// closing again. See testdata/ui/editmenu.cla's own header comment for the
// full scripted walkthrough.
func TestEditMenuUIScenario(t *testing.T) {
	runUIScenario(t, "editmenu", 0)
}

// TestDialogsUIScenario (Task 4, mac-target-4c): askOpen/askSave/
// askSaveChanges end to end via the RT_MAC_TEST answer queue -- both
// dialogs' fill+true path, both dialogs' Cancel (false, path untouched)
// path, and all three saveChoice branches -- plus a REAL file round-trip
// through the boot volume (askSave writes DialogsTest.txt, the textview is
// cleared, then askOpen the SAME path + file.readText refill it), proven
// by the "roundtrip" snap showing the content came back from disk rather
// than surviving in memory. See testdata/ui/dialogs.cla's own header
// comment for the full scripted walkthrough.
func TestDialogsUIScenario(t *testing.T) {
	runUIScenario(t, "dialogs", 0)
}

// TestUIAbout: an `app` section with all four About-relevant properties set
// -- the Apple menu's About item becomes "About AboutProbe..." and selecting
// it (menu 1 1: Apple is always bar position/native ID 1) emits the ABOUT
// trace line (rt_ui_trace_about) instead of the name-only NoteAlert path a
// program with no `app` section takes. No snaps.
func TestUIAbout(t *testing.T) { runUIScenario(t, "about", 0) }

// TestSmokeBounceUIScenario is the gated-forever counterpart to Task 7's
// real-input verification of the Ch11 bounce acceptance example: builds
// testdata/valid/bounce.cla ITSELF (not a copy under testdata/ui/), scripts
// its `every 1 ticks` bounce with smoke_bounce.events, and asserts the two
// snaps taken after different amounts of ticking differ -- the ball moved,
// same non-accidental-golden guard TestCanvasUIScenario uses.
func TestSmokeBounceUIScenario(t *testing.T) {
	snaps := runUIScenarioSrc(t, "smoke_bounce", filepath.Join("..", "..", "testdata", "valid", "bounce.cla"), 0)
	var s1, s2 []byte
	for _, s := range snaps {
		switch s.name {
		case "S1":
			s1 = s.bytes
		case "S2":
			s2 = s.bytes
		}
	}
	if s1 == nil || s2 == nil {
		t.Fatalf("smoke_bounce: expected snaps S1 and S2, got %d snap(s)", len(snaps))
	}
	if bytes.Equal(s1, s2) {
		t.Fatalf("smoke_bounce: snap S1 == S2 -- the ball did not move between snaps")
	}
}

// TestSmokeMenuDemoUIScenario is the gated-forever counterpart to Task 7's
// real-input verification of the menu-demo acceptance example: builds
// examples/menu-demo.cla ITSELF, scripts a menu selection (Toggle),
// opening the scoped window (New Aux, undimming Aux Only), selecting the
// now-enabled window-scoped item, closing it again (re-dimming), and a
// snap, then quits via the menu -- covering menu select, the dim/undim
// transition pair, and a snap in one gated scenario.
func TestSmokeMenuDemoUIScenario(t *testing.T) {
	runUIScenarioSrc(t, "smoke_menudemo", filepath.Join("..", "..", "examples", "menu-demo.cla"), 0)
}

// TestSmokeMandelUIScenario builds examples/mandelbrot.cla ITSELF (the
// canvas-pattern acceptance app) and scripts its progressive render: S1
// after 10 ticks (a rough 16px band), S2 after 40 (first pass complete,
// second underway) -- must differ (refinement actually progressed); then
// File > New resets, S3 after 3 more ticks must differ from S2 (the New
// clear + fresh coarse samples), and File > Quit exits 0. Fixed-point
// math plus the constant per-tick budget makes all three snaps
// deterministic.
func TestSmokeMandelUIScenario(t *testing.T) {
	snaps := runUIScenarioSrc(t, "smoke_mandel", filepath.Join("..", "..", "examples", "mandelbrot.cla"), 0)
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

// TestOpenDocUIScenario (mac-target-4c Task 5) drives testdata/ui/
// opendoc.cla under the "opendoc" scenario name -- its own opendoc.events
// lists two `launchdoc` lines (the second path containing a space),
// consumed by rt_ui_launch's pre-scan (runtime/mac/rt_ui.c) before
// rt_ui_run's per-event loop starts. Each line opens its own Reader
// window and labels it with the exact path received; the trace's two `T
// OPENDOC <path>` lines plus the "docs" snap of the frontmost (second,
// space-containing) document's window are the two independent proofs
// both documents arrived intact.
func TestOpenDocUIScenario(t *testing.T) {
	runUIScenarioSrc(t, "opendoc", filepath.Join("..", "..", "testdata", "ui", "opendoc.cla"), 0)
}

// TestOpenDocEmptyUIScenario (mac-target-4c Task 5) drives the SAME
// testdata/ui/opendoc.cla under the "opendoc_empty" scenario name --
// opendoc_empty.events names no `launchdoc` line at all, so rt_ui_launch's
// pre-scan finds nothing and falls back to App.startEmpty, same as a real
// System 6/7 launch with zero documents (CountAppFiles/AppleEvents alike).
func TestOpenDocEmptyUIScenario(t *testing.T) {
	runUIScenarioSrc(t, "opendoc_empty", filepath.Join("..", "..", "testdata", "ui", "opendoc.cla"), 0)
}
