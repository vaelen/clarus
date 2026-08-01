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
	return runUIScenarioBuild(t, scenario, claRel, wantExit, false)
}

// runUIScenarioBuild is runUIScenarioSrc with the build step factored out
// as a parameter (native-5e Task 7): uiport=false is the existing frozen
// Retro68 UI runtime lane (runtime/mac/rt_ui.c, byte-identical to every
// prior task); uiport=true builds against the PORTED runtime instead
// (runtime/clarus/ui*.cla, via build-mac.sh's own CLARUS_UIPORT=1 check) --
// everything AFTER the build step (RunMac, trace/snap comparison against
// the SAME testdata/ui/testdata/uisnaps goldens) is verbatim identical
// either way: the whole point of this port is that both lanes produce
// byte-identical trace/snap output from the SAME golden set (Global
// Constraints: "one golden set, strict").
func runUIScenarioBuild(t *testing.T, scenario string, claRel string, wantExit int, uiport bool) []uiSnap {
	t.Helper()
	requireMac(t)
	root := repoRoot(t)
	eventsRel := filepath.Join("..", "..", "testdata", "ui", scenario+".events")
	name := "UI" + strings.ToUpper(scenario[:1]) + scenario[1:]

	var extraEnv []string
	if uiport {
		name += "Ported"
		extraEnv = []string{"CLARUS_UIPORT=1"}
	}
	bin := runBuildMacEnv(t, name, extraEnv, claRel, "--test", "--events", eventsRel)
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

// TestZoomwinUIScenario (window-zoom-hscroll Task 1): the zoom box end to
// end -- zoom out must change the screen (S1 != S2) and zoom back in must
// restore the exact original geometry (S1 == S3), on top of the golden
// trace/snap compares (two `resized` fires).
func TestZoomwinUIScenario(t *testing.T) {
	snaps := runUIScenario(t, "zoomwin", 0)
	var s1, s2, s3 []byte
	for _, s := range snaps {
		switch s.name {
		case "S1":
			s1 = s.bytes
		case "S2":
			s2 = s.bytes
		case "S3":
			s3 = s.bytes
		}
	}
	if s1 == nil || s2 == nil || s3 == nil {
		t.Fatalf("zoomwin: expected snaps S1, S2, S3; got %d snap(s)", len(snaps))
	}
	if bytes.Equal(s1, s2) {
		t.Fatalf("zoom out changed nothing (S1 == S2)")
	}
	if !bytes.Equal(s1, s3) {
		t.Fatalf("zoom in did not restore the original geometry (S1 != S3)")
	}
}

// TestHscrollUIScenario (window-zoom-hscroll Task 2; fix-hbar): `scrollbar:
// both` on a textview end to end -- no word wrap (a click below page-rights
// the unwrapped long line, S1 != S2), a grow through the same relayout
// funnel with both bars present (S3), and (fix-hbar) a click into the text
// followed by a run of right-arrow keys that pushes the caret past the
// view's right edge -- TEAutoView must scroll the view to keep it visible
// (S4 != S3), on top of the golden trace/snap compares.
func TestHscrollUIScenario(t *testing.T) {
	snaps := runUIScenario(t, "hscroll", 0)
	var s1, s2, s3, s4 []byte
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
		}
	}
	if s1 == nil || s2 == nil || s3 == nil || s4 == nil {
		t.Fatalf("hscroll: expected snaps S1, S2, S3, S4; got %d snap(s)", len(snaps))
	}
	if bytes.Equal(s1, s2) {
		t.Fatalf("horizontal page-right changed nothing (S1 == S2)")
	}
	if bytes.Equal(s3, s4) {
		t.Fatalf("caret autoscroll changed nothing (S3 == S4)")
	}
}

// TestPatternUIScenario: the canvas `pattern` method (Ch11) -- one snap
// showing the 9-level dither ramp, clamped out-of-range levels, the
// FillOval path, and a frame op unaffected by the fill pattern.
func TestPatternUIScenario(t *testing.T) {
	runUIScenario(t, "pattern", 0)
}

// TestHdimUIScenario (fix-hbar): an empty `scrollbar: both` textview --
// both bars must render thumbless ("dimmed when not needed"). The V bar's
// maxScroll has always been 0 for empty content; this scenario is the H
// bar's own regression guard now that its range tracks content instead of
// a fixed no-wrap width. One snap; the golden PBM itself is the assertion
// (both bars' thumbless rendering), same as TestPatternUIScenario's dither
// ramp above.
func TestHdimUIScenario(t *testing.T) {
	runUIScenario(t, "hdim", 0)
}

// TestWinvarUIScenario (clarusc-ui-gaps Task 3b): execution-level proof for
// the window-var construction fix -- LogWin's window-scope `var log: text`
// has no initializer and LogWin declares no `on opened` handler at all, so
// the handle is constructed solely by clarusc's fabricated opened glue.
// Pre-fix, that glue never constructed it, and Add.click's in-place
// `log.append(...)` dereferenced a NULL rt_text*. Two clicks before the
// single snap: the golden PBM showing "clickedclicked" in Body is the
// assertion (rt_ui_widget_set_text has no RT_MAC_TEST trace line of its
// own, so there is nothing for the trace golden to add beyond the two
// Add.click fires -- see winvar.cla's own header comment).
func TestWinvarUIScenario(t *testing.T) {
	runUIScenario(t, "winvar", 0)
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

// TestPopuptableUIScenario (mac-target-4d Task 5): the table widget end to
// end -- `rows:` bound to a global list, real click resolving to the
// correct row (Result.text proves the row index, not just that select
// fired), scripted `dblclick` firing select THEN doubleClick for the SAME
// row, `Add`'s handler pushing a 4th record with no table-specific call
// (S1: 4 rows), a subsequent click resolving to that new tail row followed
// by `Remove` (S2: back to 3 rows), and both directions of `selected` --
// `SetSel` writes it programmatically (asserted by the golden trace's `T
// SET` line, no change event) and `ReadSel` reads it back into the title
// (S3, since title has no trace line of its own). See
// testdata/ui/popuptable.cla's own header comment for the full scripted
// walkthrough and coordinate derivation.
func TestPopuptableUIScenario(t *testing.T) {
	snaps := runUIScenario(t, "popuptable", 0)
	var s1, s2, s3 []byte
	for _, s := range snaps {
		switch s.name {
		case "S1":
			s1 = s.bytes
		case "S2":
			s2 = s.bytes
		case "S3":
			s3 = s.bytes
		}
	}
	if s1 == nil || s2 == nil || s3 == nil {
		t.Fatalf("popuptable: expected snaps S1, S2, and S3, got %d snap(s)", len(snaps))
	}
	if bytes.Equal(s1, s2) {
		t.Fatalf("popuptable: snap S1 == S2 -- Add/Remove did not actually change the table's row count")
	}
	if bytes.Equal(s2, s3) {
		t.Fatalf("popuptable: snap S2 == S3 -- ReadSel's title write did not change the window between snaps")
	}
}

// TestFormeditUIScenario (mac-target-4d Task 7): form windows/binds/edit/
// accepted/cancelled end to end -- Add opens EditForm on `new Bookmark`
// (all four bound widget kinds: field(str)/field(int)/popup(enum)/
// check(bool)), an overflowing Port value beeps and re-focuses (S1), a fix
// + OK fires `accepted` and adds the row (S2: table shows it), a
// dblclick-edit round renames it and re-accepts, writing back (S3: table
// redraws), and a second edit on the same row is cancelled via Escape (S4:
// byte-identical to S3 -- cancelling truly changed nothing). See
// testdata/ui/formedit.cla's own header comment for the coordinate
// derivation.
func TestFormeditUIScenario(t *testing.T) {
	snaps := runUIScenario(t, "formedit", 0)
	var s1, s2, s3, s4 []byte
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
		}
	}
	if s1 == nil || s2 == nil || s3 == nil || s4 == nil {
		t.Fatalf("formedit: expected snaps S1, S2, S3, and S4, got %d snap(s)", len(snaps))
	}
	if bytes.Equal(s1, s2) {
		t.Fatalf("formedit: snap S1 == S2 -- accepting the new bookmark did not add a row to the table")
	}
	if bytes.Equal(s2, s3) {
		t.Fatalf("formedit: snap S2 == S3 -- the lvalue-edit round did not change the table's row")
	}
	if !bytes.Equal(s3, s4) {
		t.Fatalf("formedit: snap S3 != S4 -- cancelling the second edit changed the table anyway")
	}
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

// TestTexteditorUIScenario (Task 6, mac-target-4c) drives examples/
// texteditor.cla ITSELF -- the 4c acceptance app -- through a real save/
// reopen round trip: type into the startEmpty document, File > Save
// (askSave fills the path, file.writeText writes it for real), a clean
// `close` (dirty was reset by the successful save, so no askSaveChanges
// prompt), then File > Open the SAME path (askOpen fills it again,
// file.readText reads the real bytes back via openPath -- the identical
// function App.openDocument would call) and a snap proving the reopened
// window shows the same content. See texteditor.events for the full
// script.
func TestTexteditorUIScenario(t *testing.T) {
	runUIScenarioSrc(t, "texteditor", filepath.Join("..", "..", "examples", "texteditor.cla"), 0)
}

// TestTexteditorQuitUIScenario (Task 6, mac-target-4c) is the 4b
// carry-over multi-window quit-cascade fixture: two dirty documents (Doc1
// from App.startEmpty, Doc2 from File > New, frontmost). The first `quit`
// cascades front-to-back (rt_ui_quit, runtime/mac/rt_ui.c): Doc2 answers
// Save (+ askSave's own path prompt) and closes for real; Doc1 answers
// Cancel, aborting the WHOLE quit where it stands. Per the quit-cascade
// contract (Ch7 "Quit Semantics"), Doc2 -- already closed before the
// cancel -- stays closed, and Doc1 -- not yet visited -- stays open; the
// trace must show exactly one CLOSE before the abort and none after. The
// second `quit` then finds only Doc1 still open and discards it, exiting
// 0.
func TestTexteditorQuitUIScenario(t *testing.T) {
	runUIScenarioSrc(t, "texteditor_quit", filepath.Join("..", "..", "examples", "texteditor.cla"), 0)
}

// texteditorBigfileAlertMsg is the exact string examples/texteditor.cla's
// openPath guard passes to alert() when a document exceeds the textview's
// 32,000-byte cap -- kept in sync with that literal by eye (there is no
// shared constant across a .cla file and a Go test).
const texteditorBigfileAlertMsg = "That file is too large to open (over 32,000 bytes)."

// TestTexteditorBigfileUIScenario (Task 6, mac-target-4c) exercises the
// too-large guard added to examples/texteditor.cla's openPath: a real
// file over 32,000 bytes, opened via `launchdoc`, must be rejected (alert
// + close) rather than silently truncated by the textview's own clamp.
//
// The fixture is entirely self-written, in the SAME boot the guard is
// tested in -- there is no mechanism in this harness to pre-stage a file
// onto the ephemeral disk LaunchAPPL builds per run (it boots from the
// .bin alone; any earlier RunMac's disk is gone with its temp dir), so a
// genuinely separate "write it in one launch, open it in a later one" is
// not possible here. testdata/ui/texteditor_bigfile_setup.cla -- compiled
// alongside examples/texteditor.cla as a second source file for this
// scenario only -- writes a real 36,000-byte file via `on App.launch`
// (see that file's own comment for why `launch`, not `startEmpty`);
// texteditor_bigfile.events then `launchdoc`s that same path, all within
// one continuous run.
//
// alert() text is NOT part of the RT_MAC_TEST trace/snap vocabulary --
// runtime/mac/rt_mac.c's RT_MAC_TEST rt_alert appends the message as a
// bare CRLF-translated line straight into the SAME capture stream
// parseUIOutput reads, and parseUIOutput treats any line that isn't a "T "
// trace line, a snap block, or blank as a FATAL parse error (by design,
// to catch capture corruption). Rather than reusing runUIScenarioSrc
// (which would abort on that line), this test reads the raw capture
// itself: asserts the alert text is present verbatim, strips that one
// line out, and only THEN feeds the remainder through the normal
// trace-golden compare -- so the alert's occurrence is checked (the guard
// really did fire) even though its literal text isn't part of the trace
// golden. The trace itself proves the rest of the guard's contract: the
// document opens (T OPEN) and then closes cleanly (T FIRE closeRequest/
// closed, T CLOSE) with no Body.change in between -- it was never shown
// truncated content, per the guard running before any assignment to
// Body.text.
func TestTexteditorBigfileUIScenario(t *testing.T) {
	requireMac(t)
	root := repoRoot(t)
	scenario := "texteditor_bigfile"

	bin := runBuildMac(t, "UITexteditorBigfile",
		filepath.Join("..", "..", "examples", "texteditor.cla"),
		filepath.Join("..", "..", "testdata", "ui", "texteditor_bigfile_setup.cla"),
		"--test", "--events", filepath.Join("..", "..", "testdata", "ui", scenario+".events"))
	out, _, exitCode := RunMac(t, bin, 3*time.Minute)

	if !strings.Contains(out, texteditorBigfileAlertMsg) {
		t.Fatalf("%s: expected alert message %q in capture, got: %q", scenario, texteditorBigfileAlertMsg, out)
	}
	filtered := strings.Replace(out, texteditorBigfileAlertMsg+"\n", "", 1)
	trace, _ := parseUIOutput(t, filtered)

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

	if exitCode != 0 {
		t.Errorf("%s: exit code: got %d, want 0", scenario, exitCode)
	}
}

// TestBookmarksUIScenario (mac-target-4d Task 9) drives examples/
// bookmarks.cla ITSELF -- the 4d acceptance app, Appendix C's Bookmark
// Manager verbatim plus an `app` section and file.load/file.save
// persistence -- through a real add/edit/remove pass: startEmpty loads
// "Bookmarks Data" (no such file exists yet on a fresh boot disk, so
// file.load returns false and is silently ignored, per Ch12); Add opens
// EditForm on `new Bookmark` -- itself a real exercise of this task's own
// layout-default fix, since neither EditForm's window nor any of its
// seven widgets declare a `size:`/`at:` at all, unlike every other form
// fixture in this codebase. First bookmark: Name/URL typed, Telnet picked
// via `answer-popup`, Favorite checked, and an overflowing Port value
// (11 digits, blows past int32) beeps and re-selects the field (S1) before
// a fix + OK fires `accepted`, adds the row, and saves (S2). Second
// bookmark: Name/URL typed, HTTP picked, OK accepted with Port left at its
// default 80 (still valid -- the brief's "port-validation failure
// exercised once" is deliberately a ONE-time thing, not repeated) --
// table now shows two rows (S3). A dblclick-edit round renames the first
// row and re-accepts (writeback, S4), then Remove deletes it, leaving only
// the second (S5).
//
// Persistence coverage (why this scenario does NOT also prove a real
// cross-run reload): LaunchAPPL boots a fresh, disposable disk image every
// single run (this harness's own plumbing), so there is no way to quit and
// relaunch the SAME app instance against a data file it just wrote --
// "relaunch, see the data survive" is not scriptable inside this gated
// suite at all, by construction, regardless of what the .cla program does.
// What IS provable here, and is exactly what this scenario proves: the
// save/load WIRING fires at the right moments (Remove.click and
// EditForm.accepted both call saveAll(), which calls file.save -- the
// trace and the table snaps above are the observable proof those handlers
// ran to completion without panicking on the real Toolbox file calls).
// The on-disk byte FORMAT file.save/file.load produce is already pinned
// byte-for-byte by Task 2's own host round-trip test
// (internal/sertest/roundtrip.cla, gated by nothing -- runs in the normal
// host suite). The one thing neither of those covers -- an actual
// quit-then-relaunch on the SAME disk restoring the SAME rows -- is a real
// LaunchAPPL/Finder check, done live in Final Validation step 1, not
// invented as a test-only reload button in the app itself.
func TestBookmarksUIScenario(t *testing.T) {
	snaps := runUIScenarioSrc(t, "bookmarks", filepath.Join("..", "..", "examples", "bookmarks.cla"), 0)
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

// ================================================================
// Ported-lane runners (native-5e Task 7): the SAME scenario set above,
// built against the PORTED UI runtime (runtime/clarus/ui*.cla) instead
// of the frozen runtime/mac/rt_ui.c, via runUIScenarioBuild's uiport=true
// -- verbatim identical trace/snap comparison against the SAME goldens
// (Global Constraints: "one golden set, strict... NEVER re-blessed").
// Each individually skips unless CLARUS_UIPORT=1 is set (requireUiPort),
// so a plain `go test ./internal/mactest` (no env override) exercises
// ONLY the default lane, unchanged -- these only run under an explicit
// `CLARUS_UIPORT=1 CLARUS_MAC_TESTS=1 go test ./internal/mactest -run
// <name>Ported`.
// ================================================================

func requireUiPort(t *testing.T) {
	t.Helper()
	if os.Getenv("CLARUS_UIPORT") == "" {
		t.Skip("set CLARUS_UIPORT=1 (also needs CLARUS_MAC_TESTS=1) to run the ported-UI-runtime lane")
	}
}

func TestButtonsUIScenarioPorted(t *testing.T) {
	requireUiPort(t)
	runUIScenarioBuild(t, "buttons", filepath.Join("..", "..", "testdata", "ui", "buttons.cla"), 0, true)
}

func TestMenusUIScenarioPorted(t *testing.T) {
	requireUiPort(t)
	runUIScenarioBuild(t, "menus", filepath.Join("..", "..", "testdata", "ui", "menus.cla"), 0, true)
}

func TestWinvarUIScenarioPorted(t *testing.T) {
	requireUiPort(t)
	runUIScenarioBuild(t, "winvar", filepath.Join("..", "..", "testdata", "ui", "winvar.cla"), 0, true)
}

func TestZoomwinUIScenarioPorted(t *testing.T) {
	requireUiPort(t)
	runUIScenarioBuild(t, "zoomwin", filepath.Join("..", "..", "testdata", "ui", "zoomwin.cla"), 0, true)
}

func TestCanvasUIScenarioPorted(t *testing.T) {
	requireUiPort(t)
	runUIScenarioBuild(t, "canvas", filepath.Join("..", "..", "testdata", "ui", "canvas.cla"), 0, true)
}

func TestPatternUIScenarioPorted(t *testing.T) {
	requireUiPort(t)
	runUIScenarioBuild(t, "pattern", filepath.Join("..", "..", "testdata", "ui", "pattern.cla"), 0, true)
}

func TestHdimUIScenarioPorted(t *testing.T) {
	requireUiPort(t)
	runUIScenarioBuild(t, "hdim", filepath.Join("..", "..", "testdata", "ui", "hdim.cla"), 0, true)
}

func TestUIAboutPorted(t *testing.T) {
	requireUiPort(t)
	runUIScenarioBuild(t, "about", filepath.Join("..", "..", "testdata", "ui", "about.cla"), 0, true)
}

func TestSmokeBounceUIScenarioPorted(t *testing.T) {
	requireUiPort(t)
	runUIScenarioBuild(t, "smoke_bounce", filepath.Join("..", "..", "testdata", "valid", "bounce.cla"), 0, true)
}

func TestSmokeMenuDemoUIScenarioPorted(t *testing.T) {
	requireUiPort(t)
	runUIScenarioBuild(t, "smoke_menudemo", filepath.Join("..", "..", "examples", "menu-demo.cla"), 0, true)
}

func TestSmokeMandelUIScenarioPorted(t *testing.T) {
	requireUiPort(t)
	runUIScenarioBuild(t, "smoke_mandel", filepath.Join("..", "..", "examples", "mandelbrot.cla"), 0, true)
}

// ==================== native-5e Task 8 (slice B): TextEdit widgets ====================
//
// texteditor/texteditor_quit are NOT in this set: examples/texteditor.cla's
// own .events scripts (testdata/ui/texteditor.events, texteditor_quit.events)
// use the `answer-save`/`answer-open`/`answer-changes` scripted dialog-
// answer verbs, which route through askOpen/askSave/askSaveChanges -- Task
// 10 (slice D) surface, not yet ported (uiscript.cla's scripted interpreter
// has no `answer-*` verb at all yet; ui.cla's askOpen/askSave/
// askSaveChanges still hit rtUiDialogsUnported's fail-closed stub). Moved
// forward to Task 10's own scenario sweep -- see task-8-report.md.
// texteditor_bigfile IS in this set: its own .events (`launchdoc` + `quit`
// only) never reaches openPath's askSave/askOpen calls at all (the file is
// rejected by the too-large guard before either dialog is ever touched),
// so it only exercises Task 7 (App.openDocument) + the base-runtime
// `alert()` primitive (rt_alert, unrelated to the UI dialog surface) --
// confirmed to compile+run without ever calling rtUiDialogsUnported.

func TestTextwidgetsUIScenarioPorted(t *testing.T) {
	requireUiPort(t)
	runUIScenarioBuild(t, "textwidgets", filepath.Join("..", "..", "testdata", "ui", "textwidgets.cla"), 0, true)
}

func TestEditMenuUIScenarioPorted(t *testing.T) {
	requireUiPort(t)
	runUIScenarioBuild(t, "editmenu", filepath.Join("..", "..", "testdata", "ui", "editmenu.cla"), 0, true)
}

func TestHscrollUIScenarioPorted(t *testing.T) {
	requireUiPort(t)
	runUIScenarioBuild(t, "hscroll", filepath.Join("..", "..", "testdata", "ui", "hscroll.cla"), 0, true)
}

func TestOpendocUIScenarioPorted(t *testing.T) {
	requireUiPort(t)
	runUIScenarioBuild(t, "opendoc", filepath.Join("..", "..", "testdata", "ui", "opendoc.cla"), 0, true)
}

func TestOpendocEmptyUIScenarioPorted(t *testing.T) {
	requireUiPort(t)
	runUIScenarioBuild(t, "opendoc_empty", filepath.Join("..", "..", "testdata", "ui", "opendoc.cla"), 0, true)
}

// TestTexteditorBigfileUIScenarioPorted mirrors TestTexteditorBigfileUIScenario
// (above) against the ported lane -- same two-source build (examples/
// texteditor.cla + testdata/ui/texteditor_bigfile_setup.cla), same
// alert-text-then-trace comparison, CLARUS_UIPORT=1 threaded through.
func TestTexteditorBigfileUIScenarioPorted(t *testing.T) {
	requireUiPort(t)
	root := repoRoot(t)
	scenario := "texteditor_bigfile"

	bin := runBuildMacEnv(t, "UITexteditorBigfilePorted", []string{"CLARUS_UIPORT=1"},
		filepath.Join("..", "..", "examples", "texteditor.cla"),
		filepath.Join("..", "..", "testdata", "ui", "texteditor_bigfile_setup.cla"),
		"--test", "--events", filepath.Join("..", "..", "testdata", "ui", scenario+".events"))
	out, _, exitCode := RunMac(t, bin, 3*time.Minute)

	if !strings.Contains(out, texteditorBigfileAlertMsg) {
		t.Fatalf("%s: expected alert message %q in capture, got: %q", scenario, texteditorBigfileAlertMsg, out)
	}
	filtered := strings.Replace(out, texteditorBigfileAlertMsg+"\n", "", 1)
	trace, _ := parseUIOutput(t, filtered)

	traceGolden := filepath.Join(root, "testdata", "ui", scenario+".trace")
	want, err := os.ReadFile(traceGolden)
	if err != nil {
		t.Fatalf("reading trace golden %s: %v", traceGolden, err)
	}
	if trace != string(want) {
		t.Fatalf("%s: trace mismatch:%s", scenario, firstDiff(string(want), trace))
	}
	if exitCode != 0 {
		t.Errorf("%s: exit code: got %d, want 0", scenario, exitCode)
	}
}

// ==================== native-5e Task 9 (slice C): ListManager tables, popups, LDEF ====================
//
// popuptable is the ONLY scenario gate this task requires (task-9-brief.md
// -- popup itself has no golden coverage yet, see popuptable.cla's own
// header comment: "a form window still aborts" at the time that scenario
// was authored; popup's real exercise lands with Task 10's formedit/
// bookmarks scenarios, which need the `edit` intrinsic this port doesn't
// have yet). Same byte-identical-golden-compare-only shape as every other
// Ported wrapper above (no re-assertion of TestPopuptableUIScenario's own
// per-snap semantic checks -- those already proved the BEHAVIOR once
// against the default lane; this test proves the PORTED lane produces the
// identical bytes).

func TestPopuptableUIScenarioPorted(t *testing.T) {
	requireUiPort(t)
	runUIScenarioBuild(t, "popuptable", filepath.Join("..", "..", "testdata", "ui", "popuptable.cla"), 0, true)
}

// ==================== native-5e Task 10 (slice D): dialogs, StandardFile,
// modal forms ====================
//
// dialogs/formedit/texteditor/texteditor_quit/bookmarks -- the scenario
// set this task's own brief names, plus the two texteditor scenarios Task
// 8 moved forward (their .events use answer-save/answer-open/
// answer-changes, which need askOpen/askSave/askSaveChanges, ported this
// task). Same byte-identical-golden-compare-only shape as every other
// Ported wrapper above (no re-assertion of the non-ported tests' own
// per-snap semantic checks -- those already proved the BEHAVIOR once
// against the default lane; these prove the PORTED lane produces the
// identical bytes).

func TestDialogsUIScenarioPorted(t *testing.T) {
	requireUiPort(t)
	runUIScenarioBuild(t, "dialogs", filepath.Join("..", "..", "testdata", "ui", "dialogs.cla"), 0, true)
}

func TestFormeditUIScenarioPorted(t *testing.T) {
	requireUiPort(t)
	runUIScenarioBuild(t, "formedit", filepath.Join("..", "..", "testdata", "ui", "formedit.cla"), 0, true)
}

func TestTexteditorUIScenarioPorted(t *testing.T) {
	requireUiPort(t)
	runUIScenarioBuild(t, "texteditor", filepath.Join("..", "..", "examples", "texteditor.cla"), 0, true)
}

func TestTexteditorQuitUIScenarioPorted(t *testing.T) {
	requireUiPort(t)
	runUIScenarioBuild(t, "texteditor_quit", filepath.Join("..", "..", "examples", "texteditor.cla"), 0, true)
}

func TestBookmarksUIScenarioPorted(t *testing.T) {
	requireUiPort(t)
	runUIScenarioBuild(t, "bookmarks", filepath.Join("..", "..", "examples", "bookmarks.cla"), 0, true)
}
