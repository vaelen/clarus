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

// runUIScenarioSrc builds claRel (a package-dir-relative source path) with
// scenario's own .events script (scripts/build-mac.sh --test --events),
// runs it via the 4a LaunchAPPL plumbing, and checks the trace against
// testdata/ui/<scenario>.trace and every snap against testdata/uisnaps/
// <scenario>.<name>.pbm -- byte-exact, unless CLARUS_MAC_BLESS=1, in which
// case both are (re)written instead (snap size and exit code are still
// asserted even while blessing). Its own default-path convenience wrapper,
// runUIScenario (testdata/ui/<scenario>.cla), was retired by test-
// consolidation Task 5 alongside its last caller (`about`) -- every
// remaining scenario builds an example/testdata fixture under its own,
// non-default path instead (Task 7's own precedent, mac-target-4b).
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

// TestSmokeMandelUIScenario builds examples/mandelbrot.cla ITSELF (the
// canvas-pattern acceptance app) and scripts its progressive render: S1
// after 10 ticks (a rough 16px band), S2 after 40 (first pass complete,
// second underway) -- must differ (refinement actually progressed); then
// File > New resets, S3 after 3 more ticks must differ from S2 (the New
// clear + fresh coarse samples). test-consolidation Task 5 (audit row N8,
// MERGE->N10) then folds in the retired `about` scenario's own coverage:
// right after S3, `menu 1 1` (Apple menu, item 1 -- About Mandelbrot...)
// emits the ABOUT trace line against examples/mandelbrot.cla's own `app`
// section (name/version/author/about all populated, unlike about.cla's
// values but the same four-field shape), and File > Quit exits 0.
// Fixed-point math plus the constant per-tick budget makes all three
// snaps deterministic.
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

// TestTexteditorUIScenario (Task 6, mac-target-4c) drives examples/
// texteditor.cla PLUS a test-consolidation-Task-5-added companion source,
// testdata/ui/texteditor_opendoc_setup.cla (`on App.launch`, writes two
// small real fixture files -- see that file's own header comment for why
// launch, not startEmpty) -- through texteditor.events' now-merged script:
//
//  1. `launchdoc Report.txt` / `launchdoc My Notes.txt` (the second path
//     containing a space) dispatch two real App.openDocument calls before
//     the ordinary script begins -- rt_ui_launch's pre-scan trace (`T
//     OPENDOC <path>`) plus a "docs" snap of the frontmost (second,
//     space-containing) document prove both documents arrived intact and
//     were actually read (examples/texteditor.cla's openPath, a REAL
//     file.readText -- stronger than the retired opendoc.cla's simplified
//     echo). Audit row N11, MERGE->N14. Both launched windows are then
//     closed, returning to zero open Docs.
//  2. File > New opens a fresh Doc; the ORIGINAL 4c round-trip proof
//     follows unchanged: type, File > Save (askSave fills the path,
//     file.writeText writes it for real), a clean `close` (not dirty, no
//     askSaveChanges prompt), then File > Open the SAME path (askOpen
//     fills it again, file.readText reads the real bytes back) and a
//     snap proving the reopened window shows the same content.
//  3. The retired texteditor_quit scenario's own multi-window quit-cascade
//     proof (audit row N15, MERGE->N14) folds onto the tail: the just-
//     reopened doc gets a further edit (dirty), a second File > New doc
//     gets its own edit (dirty, frontmost). The first `quit` cascades
//     front-to-back (rt_ui_quit, runtime/mac/rt_ui.c): the frontmost doc
//     answers Save (+ askSave's own path prompt) and closes for real; the
//     other answers Cancel, aborting the WHOLE quit where it stands --
//     already-closed stays closed, not-yet-visited stays open. The second
//     `quit` then finds only that one doc still open and discards it
//     (answer-changes discard), exiting 0.
//
// See texteditor.events for the exact merged script.
func TestTexteditorUIScenario(t *testing.T) {
	requireMac(t)
	bin := runBuildMac(t, "UITexteditor",
		filepath.Join("..", "..", "examples", "texteditor.cla"),
		filepath.Join("..", "..", "testdata", "ui", "texteditor_opendoc_setup.cla"),
		"--test", "--events", filepath.Join("..", "..", "testdata", "ui", "texteditor.events"))
	out, _, exitCode := RunMac(t, bin, 3*time.Minute)
	checkUIGoldens(t, "texteditor", out, exitCode, 0)
}

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
