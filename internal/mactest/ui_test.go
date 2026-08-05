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
	return runUIScenarioBuild(t, scenario, claRel, wantExit)
}

// runUIScenarioBuild is runUIScenarioSrc with the build step factored out:
// builds claRel against the ported UI runtime (runtime/clarus/ui*.cla --
// scripts/build-mac.sh's only path now, rt_ui.c is never linked), then
// RunMac + trace/snap comparison against testdata/ui/testdata/uisnaps.
func runUIScenarioBuild(t *testing.T, scenario string, claRel string, wantExit int) []uiSnap {
	t.Helper()
	requireMac(t)
	eventsRel := filepath.Join("..", "..", "testdata", "ui", scenario+".events")
	name := "UI" + strings.ToUpper(scenario[:1]) + scenario[1:]

	bin := runBuildMac(t, name, claRel, "--test", "--events", eventsRel)
	out, _, exitCode := RunMac(t, bin, 3*time.Minute)
	return checkUIGoldens(t, scenario, out, exitCode, wantExit)
}

// checkUIGoldens is runUIScenarioBuild's own golden-compare tail, factored
// out (Task 12, native-5e) so a native (`clarusc emit68k`) boot lane can
// share the EXACT same trace/snap comparison the Retro68-ported lane
// already uses, rather than a second hand-copied implementation drifting
// out of sync with this one -- parses `out` (parseUIOutput), compares the
// trace against testdata/ui/<scenario>.trace and every snap against
// testdata/uisnaps/<scenario>.<name>.pbm byte-exact (or rewrites both
// under CLARUS_MAC_BLESS=1), and asserts exitCode == wantExit. Returns the
// decoded snaps (same contract runUIScenarioBuild's own callers already
// rely on for their own extra per-scenario snap assertions).
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
//
// NOT retired by ui-scenario-retirement Task 8 (unlike popuptable, its own
// batch-mate): the migration attempt (testsuite/toolbox/cases_formedit.cla,
// investigated then reverted) uncovered a real, previously-undetected
// native-68k (cg68k) codegen bug -- a form's `accepted(rec: T)` event
// marshals `rec`'s bound `bool` field back as `false` even when the live
// checkbox control reads `true` at every point up to and including inside
// the accepted handler itself (confirmed via temporary runtime
// instrumentation: the buffer byte at the bool field's own offset is
// correctly `1` immediately before `UiFireWinEvent` fires; the handler's
// own `b.favorite` parameter is `false` moments later, in the same
// synchronous call). This retired golden's own snap-diff assertions never
// exercised `favorite`'s value at all (S1..S4 are pure screen-pixel
// diffs), so the bug was invisible to it -- kept here, UNRETIRED, until
// the underlying compiler bug is fixed and a case-based replacement can
// honestly assert the bound value. See ui-scenario-retirement's
// task-8-report.md for the full investigation.
func TestFormeditUIScenario(t *testing.T) {
	checkFormeditSnaps(t, runUIScenario(t, "formedit", 0))
}

// checkFormeditSnaps is TestFormeditUIScenario's own snap assertion,
// factored out (Task 14, native-5e) for reuse by the native lane.
func checkFormeditSnaps(t *testing.T, snaps []uiSnap) {
	t.Helper()
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
// the same non-accidental-golden guard testsuite/toolbox/cases_canvas.cla's
// own Canvas case uses now that the retired canvas UI scenario has been
// migrated there (ui-scenario-retirement Task 7).
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
	checkSmokeMandelSnaps(t, runUIScenarioSrc(t, "smoke_mandel", filepath.Join("..", "..", "examples", "mandelbrot.cla"), 0))
}

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
	bin := runBuildMac(t, "UITexteditorBigfile",
		filepath.Join("..", "..", "examples", "texteditor.cla"),
		filepath.Join("..", "..", "testdata", "ui", "texteditor_bigfile_setup.cla"),
		"--test", "--events", filepath.Join("..", "..", "testdata", "ui", "texteditor_bigfile.events"))
	out, _, exitCode := RunMac(t, bin, 3*time.Minute)
	checkTexteditorBigfileCapture(t, out, exitCode)
}

// checkTexteditorBigfileCapture is TestTexteditorBigfileUIScenario's own
// capture handling, factored out (Task 14, native-5e) so the native lane's
// TestTexteditorBigfileOn68k can reuse it verbatim instead of a hand-copied
// duplicate. alert() text is NOT part of the RT_MAC_TEST trace/snap
// vocabulary (see the caller's own header comment for why): asserts the
// alert text is present verbatim, strips that one line out, and only then
// feeds the remainder through the normal trace-golden compare.
func checkTexteditorBigfileCapture(t *testing.T, out string, exitCode int) {
	t.Helper()
	root := repoRoot(t)
	scenario := "texteditor_bigfile"

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
	checkBookmarksSnaps(t, runUIScenarioSrc(t, "bookmarks", filepath.Join("..", "..", "examples", "bookmarks.cla"), 0))
}

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
