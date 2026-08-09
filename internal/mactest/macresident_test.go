// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// macresident_test.go: Task 11 (mac-resident-clarusc phase, final task) --
// the phase's own acceptance evidence. ClarusC.APPL (clarusc/macgui.cla,
// scripts/build-clarusc-mac.sh) is a real Mac application that compiles
// OTHER Clarus programs ON the emulated Mac, using the same drive.cla
// pipeline the host CLI uses. TestMacResidentClaruscOnSnow proves two
// on-Mac compiles (tickprobe.cla, then catprobe.cla) each produce a
// native .APPL byte-identical to the host compiler's own output for the
// same source -- the strongest oracle available: any word-size,
// endianness, or path-resolution bug in the self-hosted compiler that
// only bites on real hardware would show up here as a fork mismatch.
//
// catprobe.cla (testdata/mac-resident/catprobe.cla) exists to prove a
// SECOND thing at the same time: an `include` of a toolbox/ catalog file
// resolves via the baked 'CLFS' resource fallback (Task 8's
// driveKeyResolve + macgui.cla's own feReadSource) when there is no disk
// copy of toolbox/osutils.cla on the Snow acceptance volume at all --
// deliberately never staged there.
//
// A real bug was found and fixed by this task before either compile
// could succeed even once: driveManifestSplice/driveEarlySplice (both in
// drive.cla) read every runtime-module file (core.cla, ui.cla, ...) via
// the low-level file.readText directly, bypassing the feReadSource seam
// expand() already used for ordinary `include`s. On the Mac, with no
// runtime/clarus/ directory on disk (by design -- the whole point of
// `--bake` is to avoid needing one), every runtime-module read failed
// outright ("runtime module core.cla not found ... use --rtdir"), and
// macgui.cla's own on-Mac compile of ANY UI program (tickprobe.cla,
// catprobe.cla, and even ClarusC's own future self-compile) was
// unreachable code until this fix. See drive.cla's own rtModuleKey doc
// comment for the fix.
package mactest

import (
	"bytes"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"clarus/internal/claruscboot"
)

// buildHostOracleFork builds fixture (an absolute .cla path) with the
// CURRENT-source host clarusc (claruscboot.CurrentExe -- NOT build-run's
// possibly-stale snapshot-only cache; see the package doc's "two-stage
// bootstrap is mandatory" note) via plain `emit68k` (no --bake,
// --events, or --partition -- the same flags the on-Mac compile itself
// never sets either), and returns the sliced resource fork
// (readForkFromMacBinary, bake_test.go) -- the byte-identity oracle for
// whatever the SAME fixture produces when ClarusC.APPL compiles it on
// real hardware.
func buildHostOracleFork(t *testing.T, fixture string) []byte {
	t.Helper()
	exe := claruscboot.CurrentExe(t)
	root := repoRoot(t)
	bin := filepath.Join(t.TempDir(), "oracle.bin")
	cmd := exec.Command(exe, "emit68k", "--rtdir", filepath.Join(root, "runtime", "clarus"), "-o", bin, fixture)
	if out, err := cmd.CombinedOutput(); err != nil {
		t.Fatalf("clarusc emit68k -o %s %s: %v\n%s", bin, fixture, err, out)
	}
	return readForkFromMacBinary(t, bin)
}

// macResidentCompileSettle is how long TestMacResidentClaruscOnSnow lets
// Snow sit after boot, before quitting, to let ClarusC.APPL run its
// baked --events script to completion: TWO on-Mac compiles, each
// compiling a real UI program (window/every) through the full
// lex/parse/check/lower/shake/asm68k/peep68k/cg68k pipeline PLUS the
// runtime-module splice (core/str/text/list/map/ui*, ~12,000 lines of
// Clarus source total) -- all running AS CLARUS SOURCE INTERPRETED BY
// THE SAME SELF-HOSTED PIPELINE, executing on emulated 68k hardware.
// Manual probe (this task, real-time/no fast-forward, same 48MB
// partition and ROM as the acceptance machine): the FIRST compile alone
// was still running at the 18-minute mark (steady ~25% host CPU the
// whole time -- real ongoing work, not a hang; ClarusC.APPL's own Log
// window stays blank until a compile finishes, by design, so "no visible
// output yet" is expected, not a failure signal). Consistent with
// peephole68k's own bench finding that lexing just lib.cla+tok.cla+
// lex.cla alone took ~264s of Mac-tick time; a full lex/parse/check/
// lower/shake/codegen/peephole pass over ~12x that much source is
// plausibly tens of minutes. Fast-forward (init_args.start_fastforward)
// was tried first and NOT adopted: enabling it produced a boot that sat
// for minutes with no launch at all (CPU usage low and flat, no ClarusC
// window ever appearing within 3+ minutes of guest time it should not
// have needed even at 1x) -- an apparent bad interaction between
// fast-forward and something latency- or timing-sensitive in this
// specific boot path, not investigated further since real-time already
// completes inside a (generous) practical test timeout.
//
// First automated run (50-minute settle) came back inconclusive on
// timing: the trace showed BOTH "T FIRE File.Compile.select"/"T ASKOPEN"
// pairs (proving compile 1, tickprobe.cla, finished and returned control
// -- Mac OS's classic cooperative single-threading means the SECOND
// menu dispatch is structurally impossible while the FIRST gcCompile
// call is still on the stack), but NO "##CLARUS-EXIT##" trailer at all
// -- meaning compile 2 (catprobe.cla) was still running when the 50
// minutes ran out. So one compile alone can take close to the full 50
// minutes. Raised to 110 minutes for real headroom on TWO sequential
// compiles (runSnow's own timeout raised to 130 minutes accordingly).
const macResidentCompileSettle = 110 * time.Minute

// macResidentSettle returns macResidentCompileSettle, or
// CLARUS_MACRESIDENT_SETTLE's own parsed value when set (a Go duration
// string, e.g. "12m") -- added by Task 11 fix round 1 so a controller
// re-verifying a specific fix can budget a much shorter live run than the
// conservative 110-minute default (sized for the WORST observed single
// compile, not the common case) without editing this file. Honest
// tradeoff: a short override risks a false FAIL if this particular run's
// compile is slower than usual (real Snow-hardware wall clock is not
// perfectly reproducible run to run) -- it never risks a false PASS, since
// the assertions below are unchanged either way. Unset (the default) keeps
// today's conservative behavior exactly.
func macResidentSettle(t *testing.T) time.Duration {
	t.Helper()
	v := os.Getenv("CLARUS_MACRESIDENT_SETTLE")
	if v == "" {
		return macResidentCompileSettle
	}
	d, err := time.ParseDuration(v)
	if err != nil {
		t.Fatalf("CLARUS_MACRESIDENT_SETTLE=%q: %v", v, err)
	}
	return d
}

// macResidentLaunchSettle is TestMacResidentClaruscOnSnow's own second
// sub-test (Step 6, launchable-app proof): TickProbe.bin, extracted from
// the first sub-test's own byte-identity check, booted standalone with
// NO --events (the real, non-scripted rtUiRun/UiTickCount event loop --
// same lane TestRealEventLoopTickOn68k already proves on the Mini
// vMac/Retro68 lane). It counts 60 real ticks and quits; a generous
// multiple of that (a handful of seconds at most on real hardware).
const macResidentLaunchSettle = 30 * time.Second

// TestMacResidentClaruscOnSnow is Task 11's own acceptance test (gated
// CLARUS_SNOW_TESTS=1; foreground only -- Snow has no headless mode, see
// snow_test.go's own file header): builds ClarusC.APPL with its
// clarusc.events script baked in (answer-open tickprobe.cla, Compile,
// answer-open catprobe.cla, Compile, quit), boots it on Snow with
// tickprobe.cla/catprobe.cla staged at the volume root (deliberately NOT
// staging toolbox/osutils.cla -- catprobe.cla's own include must resolve
// via the baked resource fallback, or not at all), and requires:
//
//  1. The captured `out` trace shows both scripted compiles were
//     DISPATCHED (two "T FIRE File.Compile.select" / "T ASKOPEN" pairs)
//     and NO alert() text appears anywhere in the trace -- gcCompile's
//     every error path (`cannot open entry file`, a diag, `emit68k
//     failed`, `write failed`) calls alert(), and alert() (unlike
//     gcCompile's own gcLog, which only ever reaches the ON-SCREEN Log
//     textview -- confirmed by reading its source: it assigns
//     `w.Output.text` and calls nothing else) writes live into this
//     SAME captured stream (native.cla's natAlert doc comment: "written
//     immediately and flushed"). So an alert-free trace is real
//     evidence neither compile hit an error path -- discovered THIS
//     task, when a first automated run's "assert BUILT " check (the
//     brief's own Step 4 wording) turned out structurally unsatisfiable
//     since gcLog's own output is never trace-visible at all.
//  2. TickProbe/CatProbe, extracted from the boot disk, are
//     byte-identical (resource fork only, MacBinary header stripped) to
//     the SAME fixtures compiled by the current-source HOST compiler --
//     THE core assertion (the brief's own Step 5 wording): a missing or
//     truncated file here fails loudly (hcopy error / length mismatch),
//     which is the real, unambiguous success/failure signal this test
//     relies on, not the trace log.
//  3. TickProbe, the on-Mac-produced app, actually launches and runs its
//     real event loop standalone (a second, independent Snow boot) --
//     proof the byte-identity check isn't merely comparing two equally
//     broken outputs.
func TestMacResidentClaruscOnSnow(t *testing.T) {
	requireSnow(t)

	root := repoRoot(t)
	tickFixture := filepath.Join(root, "testdata", "cg68k", "tickprobe.cla")
	catFixture := filepath.Join(root, "testdata", "mac-resident", "catprobe.cla")
	events := filepath.Join(root, "testdata", "mac-resident", "clarusc.events")

	// Host oracles first (current-source two-stage compiler, no flags).
	tickOracle := buildHostOracleFork(t, tickFixture)
	catOracle := buildHostOracleFork(t, catFixture)

	// Build ClarusC.APPL with the baked compile script.
	buildCmd := exec.Command(filepath.Join(root, "scripts", "build-clarusc-mac.sh"), "--events", events)
	buildCmd.Dir = root
	buildStart := time.Now()
	if out, err := buildCmd.CombinedOutput(); err != nil {
		t.Fatalf("build-clarusc-mac.sh --events %s: %v\n%s", events, err, out)
	}
	t.Logf("ClarusC.APPL build: %s", time.Since(buildStart))
	clarusCBin := filepath.Join(root, "build-68k", "ClarusC", "ClarusC.bin")

	d := newSnowDisk(t)
	d.putMacBinary(t, clarusCBin, "ClarusC")
	d.putText(t, "tickprobe.cla", mustReadFile(t, tickFixture))
	d.putText(t, "catprobe.cla", mustReadFile(t, catFixture))

	settle := macResidentSettle(t)
	// 20-minute headroom above the settle window, same margin the
	// original 110min/130min const pair used -- runSnow's own timeout is
	// a hard kill, settle is when this test's own poll loop decides to
	// quit Snow, so the two must never be equal.
	runSnowTimeout := settle + 20*time.Minute
	bootStart := time.Now()
	runSnow(t, d, runSnowTimeout, func() bool { return time.Since(bootStart) >= settle })
	t.Logf("on-Mac double-compile boot: %s wall clock (settle=%s)", time.Since(bootStart), settle)

	appOut := string(d.get(t, ":System Folder:Startup Items:out"))
	fireCount := strings.Count(appOut, "T FIRE File.Compile.select")
	askOpenCount := strings.Count(appOut, "T ASKOPEN :::")
	if fireCount != 2 || askOpenCount != 2 {
		t.Fatalf("want 2 Compile.select dispatches + 2 real askOpen answers, got %d/%d:\n%s", fireCount, askOpenCount, appOut)
	}
	// Every gcCompile error path calls alert(), which (unlike gcLog)
	// writes live into this trace -- see the doc comment above. A quoted
	// alert-looking line here is a real compiler-error signal, not noise.
	for _, bad := range []string{"cannot open entry file", "emit68k failed", "write failed", "error:", "warning:"} {
		if strings.Contains(appOut, bad) {
			t.Errorf("app out contains a compile-error signal (%q):\n%s", bad, appOut)
		}
	}
	if !strings.Contains(appOut, "##CLARUS-EXIT## 0") {
		t.Errorf("app out missing clean exit trailer (both compiles may not have finished within the settle window -- see wall-clock log above):\n%s", appOut)
	}

	// gcCompile writes the compiled app via file.writeRes(appName, ...)
	// with a BARE name (ioVRefNum=0, "current default volume/directory"),
	// and the scripted askOpen path never calls PBSetVolSync (Task 10's
	// own SetVol finding: only the REAL, non-scripted Standard File path
	// does) -- so the default directory never moves off wherever ClarusC
	// itself launched from, :System Folder:Startup Items:. Both compiled
	// apps land there, NOT at the volume root where the .cla sources are.
	tickBin := d.getMacBinary(t, ":System Folder:Startup Items:TickProbe")
	catBin := d.getMacBinary(t, ":System Folder:Startup Items:CatProbe")
	tickFork := readForkFromMacBinaryBytes(t, tickBin)
	catFork := readForkFromMacBinaryBytes(t, catBin)

	if !bytes.Equal(tickFork, tickOracle) {
		dumpForkMismatch(t, "TickProbe", tickFork, tickOracle)
	}
	if !bytes.Equal(catFork, catOracle) {
		dumpForkMismatch(t, "CatProbe", catFork, catOracle)
	}

	// Step 6: launchable-app proof -- TickProbe, extracted above, booted
	// standalone with no --events (the real, non-scripted event loop).
	d2 := newSnowDisk(t)
	tickBinPath := filepath.Join(t.TempDir(), "TickProbe.bin")
	if err := os.WriteFile(tickBinPath, tickBin, 0o644); err != nil {
		t.Fatalf("stage extracted TickProbe: %v", err)
	}
	d2.putMacBinary(t, tickBinPath, "TickProbe")
	start2 := time.Now()
	runSnow(t, d2, 3*time.Minute, func() bool { return time.Since(start2) >= macResidentLaunchSettle })
	tickOut := string(d2.get(t, ":System Folder:Startup Items:out"))
	if !strings.Contains(tickOut, "T OPEN") {
		t.Errorf("TickProbe out missing window-open trace:\n%s", tickOut)
	}
	if !strings.Contains(tickOut, "T FRONT") {
		t.Errorf("TickProbe out missing window-front trace:\n%s", tickOut)
	}
	everyFireCount := strings.Count(tickOut, "T FIRE every.")
	if everyFireCount < 60 {
		t.Errorf("TickProbe out has only %d \"T FIRE every.\" lines, want >= 60 (real-tick event loop):\n%s", everyFireCount, tickOut)
	}
}

// mustReadFile reads path or fails the test.
func mustReadFile(t *testing.T, path string) []byte {
	t.Helper()
	b, err := os.ReadFile(path)
	if err != nil {
		t.Fatalf("read %s: %v", path, err)
	}
	return b
}

// readForkFromMacBinaryBytes is readForkFromMacBinary's byte-slice
// twin (bake_test.go's own helper takes a file path; snowDisk.getMacBinary
// already hands back raw bytes) -- same 128-byte-header/fork-length
// parsing, applied in memory instead of via a temp-file round trip.
func readForkFromMacBinaryBytes(t *testing.T, img []byte) []byte {
	t.Helper()
	tmp := filepath.Join(t.TempDir(), "extracted.bin")
	if err := os.WriteFile(tmp, img, 0o644); err != nil {
		t.Fatalf("stage extracted MacBinary: %v", err)
	}
	return readForkFromMacBinary(t, tmp)
}

// dumpForkMismatch writes both sides of a failed fork comparison to
// t.TempDir() and fails the test with their paths plus the first
// divergent byte offset -- per the brief: "dump both forks to files and
// xxd-diff the first divergence... report it, don't paper over it."
func dumpForkMismatch(t *testing.T, name string, gotMac, wantHost []byte) {
	t.Helper()
	dir := t.TempDir()
	macPath := filepath.Join(dir, name+"-mac.fork")
	hostPath := filepath.Join(dir, name+"-host.fork")
	os.WriteFile(macPath, gotMac, 0o644)
	os.WriteFile(hostPath, wantHost, 0o644)

	n := len(gotMac)
	if len(wantHost) < n {
		n = len(wantHost)
	}
	div := -1
	for i := 0; i < n; i++ {
		if gotMac[i] != wantHost[i] {
			div = i
			break
		}
	}
	t.Fatalf("%s fork mismatch: on-Mac %d bytes vs host oracle %d bytes; first divergence at byte %d\non-Mac fork:   %s\nhost fork:     %s\nxxd -s %d -l 64 <file> to inspect",
		name, len(gotMac), len(wantHost), div, macPath, hostPath, maxInt(div-16, 0))
}

func maxInt(a, b int) int {
	if a > b {
		return a
	}
	return b
}
