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
	"encoding/hex"
	"fmt"
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
//
// EVERY timing above was measured against a compiler that was silently
// compiling NOTHING. Fix round 4 found that the .cla sources staged here
// (putText, i.e. hcopy -t, i.e. CR line endings) were swallowed whole by
// an LF-only lexer, so each "compile" was really a compile of an empty
// program: no runtime splice, a 12,072-byte output. With that fixed, each
// compile does roughly 9x the work -- the host self-hosted compiler takes
// 0.37s on tickprobe.cla vs 0.04s on an empty file, and the on-Mac cost
// tracks that ratio. Observed directly: a 4-hour boot at 6.8x fast-forward
// did not finish the FIRST compile (clean trace, no error, Snow pegged at
// 100% host CPU the whole time -- real work, not a hang). Budget scales
// off the old 110-minute figure by that same ~9x: on the order of TEN
// HOURS of wall clock for both compiles at ~7x fast-forward, more without
// fast-forward. Left at 110 minutes rather than raised to a number nobody
// would wait out by accident: this test is opt-in (CLARUS_SNOW_TESTS=1)
// and every real run of it already sets CLARUS_MACRESIDENT_SETTLE
// explicitly. Set it to 12h (with a -timeout above that) for a run
// actually meant to reach the byte-compare.
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
//     SAME captured stream. ClarusC.APPL (macgui.cla) is a UI program,
//     so its alert() calls route through rtUiAlertMsg (attempt-abort
//     phase Task 4, A4; runtime/clarus/uidialogs.cla), which writes and
//     flushes IMMEDIATELY via UiTestEmit/nat_UiTestEmit -- the same
//     "survives a mid-run crash" guarantee native.cla's own natAlert
//     doc comment describes ("written immediately and flushed"), just
//     reached through rtUiAlertMsg now rather than a direct natAlert
//     call (fix round 1, review C1: an earlier rtUiAlertMsg routed
//     through the BUFFERED natLog path instead, which would have made
//     this comment's own assertion false for a still-running session --
//     fixed before merge). So an alert-free trace is real
//     evidence neither compile hit an error path -- discovered THIS
//     task, when a first automated run's "assert BUILT " check (the
//     brief's own Step 4 wording) turned out structurally unsatisfiable
//     since gcLog's own output is never trace-visible at all. Fix round
//     2 re-checked this (re-read gcLog itself: still, and structurally
//     always will be, `w.Output.text = buf` and nothing else) before
//     accepting a request to "require two BUILT lines" here -- literally
//     impossible without changing gcLog's own behavior (out of this
//     test's scope), so extraction success (point 2) is, and must remain,
//     this test's own real "did compile 2 actually finish" signal.
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
	// settle is an UPPER bound, not a fixed wait. CLARUS_MACRESIDENT_DONE,
	// when set, names a host file an operator watching the emulator can
	// create the moment ClarusC's scripted `quit` visibly lands -- ending
	// the wait immediately instead of burning the rest of a deliberately
	// generous budget. It can never cause a false PASS: tripping it early
	// just means the extraction/byte-compare assertions below run against a
	// half-finished disk and FAIL, exactly as a too-short settle already
	// does (fix round 1's own CLARUS_MACRESIDENT_SETTLE tradeoff note).
	doneMarker := os.Getenv("CLARUS_MACRESIDENT_DONE")
	runSnow(t, d, runSnowTimeout, func() bool {
		if time.Since(bootStart) >= settle {
			return true
		}
		if doneMarker == "" {
			return false
		}
		_, err := os.Stat(doneMarker)
		return err == nil
	})
	t.Logf("on-Mac double-compile boot: %s wall clock (settle=%s)", time.Since(bootStart), settle)

	appOut := string(d.get(t, ":System Folder:Startup Items:out"))
	// Fix round 2 diagnosability: ALWAYS log the full trace, pass or fail --
	// round 1's log never captured this (only the two failing assertions'
	// own truncated dumps), so a "did compile 2 even reach the write step"
	// question was unanswerable after the fact. Cheap (a few KB) and
	// t.Logf only surfaces under -v or on failure, so this costs nothing on
	// a quiet PASS.
	t.Logf("app out (%d bytes):\n%s", len(appOut), appOut)
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
	// with a BARE name -- natWriteRes (native.cla) pokes ioVRefNum=0 and
	// never touches an ioDirID field at all (NatCreate/NatOpenRF are trap
	// 0xA008/0xA00A, the PLAIN pre-HFS File Manager calls, which have no
	// ioDirID field to set), so the write lands wherever the single global
	// "default directory" points -- normally wherever ClarusC itself
	// launched from (:System Folder:Startup Items:, Task 10's own SetVol
	// finding: only the REAL Standard File path calls SetVol; the scripted
	// askOpen lane never does), but round 2 found this untrustworthy
	// without direct proof -- macResidentExtractApp (below) tries BOTH the
	// volume root and Startup Items, and dumps both directories' listings
	// if neither has the file, instead of guessing.
	tickBin := macResidentExtractApp(t, d, "TickProbe")
	catBin := macResidentExtractApp(t, d, "CatProbe")
	tickFork := readForkFromMacBinaryBytes(t, tickBin)
	catFork := readForkFromMacBinaryBytes(t, catBin)

	// normalizeForkReserved (below): a real Mac's own Resource/File
	// Manager can scribble filename/type/creator bookkeeping into the
	// Inside-Macintosh-reserved span (bytes 16-255) the instant a fresh
	// file sits on a live, booted HFS volume -- structurally never
	// resource data on either side, so it's excluded before comparing,
	// not compared away by accident.
	if !bytes.Equal(normalizeForkReserved(tickFork), normalizeForkReserved(tickOracle)) {
		dumpForkMismatch(t, "TickProbe", tickFork, tickOracle)
	}
	if !bytes.Equal(normalizeForkReserved(catFork), normalizeForkReserved(catOracle)) {
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

// macResidentExtractApp extracts name (a bare app name written by
// file.writeRes -- see the doc comment at its call site for why the
// landing directory is not a sure thing) trying, in order, the volume
// root and :System Folder:Startup Items:. Returns the first hit's raw
// MacBinary bytes; on a miss at BOTH, fails with an `hls -l` listing of
// both directories, so a future miss is self-explaining (candidate name
// wrong? not written at all? written under a different name entirely?)
// instead of a bare "no such file or directory" -- fix round 2's own
// diagnosability gap.
func macResidentExtractApp(t *testing.T, d *snowDisk, name string) []byte {
	t.Helper()
	candidates := []string{hfsPath(name), ":System Folder:Startup Items:" + name}
	var misses []string
	for _, c := range candidates {
		tmp := filepath.Join(t.TempDir(), "get-bin")
		unmount := d.mount(t)
		cmd := exec.Command(hfsutilsBin(t, "hcopy"), "-m", c, tmp)
		cmd.Env = append(os.Environ(), "HOME="+d.dir)
		out, err := cmd.CombinedOutput()
		unmount()
		if err == nil {
			b, rerr := os.ReadFile(tmp)
			if rerr != nil {
				t.Fatalf("read extracted %s (found at %s): %v", name, c, rerr)
			}
			t.Logf("%s extracted from %s (%d bytes)", name, c, len(b))
			return b
		}
		misses = append(misses, fmt.Sprintf("%s: %v\n%s", c, err, out))
	}
	// runtime-ir-bake Task 6 fix round 2: the loop above always unmounts
	// after its OWN last attempt (each iteration's unmount() runs
	// unconditionally), so hfsutils' single global "current volume"
	// pointer is unmounted by the time execution reaches here -- calling
	// hls directly used to surface a bare, confusing "No volume is
	// current; use `hmount' or `hvol'" instead of ever reaching this
	// function's own richer listing-based diagnostic (found live: a
	// settle-expired run's own extraction failure showed exactly that
	// raw hfsutils error, not this message). Re-mount first.
	unmount := d.mount(t)
	rootListing := d.runHfs(t, "hls", "-l", ":")
	startupListing := d.runHfs(t, "hls", "-l", ":System Folder:Startup Items:")
	unmount()
	t.Fatalf("%s not found at any candidate location -- if both listings below look like an untouched/empty boot disk, the settle window most likely expired BEFORE the on-Mac compile finished writing %s at all (raise CLARUS_MACRESIDENT_SETTLE and re-run) rather than %s having landed somewhere unexpected:\n%s\nvolume root listing:\n%s\nStartup Items listing:\n%s",
		name, name, name, strings.Join(misses, "\n"), rootListing, startupListing)
	return nil
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

// resourceForkHeaderLen/resourceForkReservedEnd document Inside
// Macintosh's own resource-fork header layout -- Volume I, "The Resource
// Manager" (p. I-128, Figure 9 and the field table right after it):
//
//	16 bytes  data offset(4) + map offset(4) + data length(4) + map length(4)
//	112 bytes "Reserved for system use"
//	128 bytes "Available for application data" (16+112+128 = 256)
//
// -- confirmed against the PDF text directly (pdftotext extraction; the
// file itself exceeds this tool's 100MB direct-read cap), and matching
// this repo's own writer (clarusc/app68k.cla's app68BuildResourceFork:
// "256-byte header (16 real bytes + 240 reserved)"). A REAL Mac's
// Resource/File Manager can -- and empirically does -- scribble into
// that 240-byte span (filename/type/creator bookkeeping) the instant a
// file is created or touched on a live, booted HFS volume; the host
// oracle (cg68BuildFork's own raw bytes, written once, never opened by a
// live Resource Manager) always leaves it zeroed. resourceForkDataStart
// (256) is also literally the fork's own data-offset header field on
// every fork this package builds, so bytes before it are NEVER resource
// data by construction, on either side of a comparison.
//
// Found (runtime-ir-bake Task 6 fix round 2): a real on-Mac
// TestClarusCBakePathOnSnow run's own TickProbe fork carried
// `09 'TickProbe' 02 00 00 00 'AP...'` at offset 0x30 (49) where the
// host oracle had zeros -- structurally within the reserved span either
// way, not a compile divergence.
const resourceForkHeaderLen = 16
const resourceForkDataStart = 256

// normalizeForkReserved returns a copy of fork with bytes
// [resourceForkHeaderLen, resourceForkDataStart) zeroed -- see the
// consts' own doc comment. Both TestMacResidentClaruscOnSnow and
// TestClarusCBakePathOnSnow compare THIS, not the raw bytes, so a real
// Mac's own reserved-area bookkeeping never fails either test.
func normalizeForkReserved(fork []byte) []byte {
	out := append([]byte(nil), fork...)
	end := resourceForkDataStart
	if end > len(out) {
		end = len(out)
	}
	for i := resourceForkHeaderLen; i < end; i++ {
		out[i] = 0
	}
	return out
}

// dumpForkMismatch writes both sides of a failed fork comparison to
// t.TempDir() and fails the test with their paths plus the first
// divergent byte offset -- per the brief: "dump both forks to files and
// xxd-diff the first divergence... report it, don't paper over it."
// Callers pass the RAW (un-normalized) bytes here even though the
// pass/fail decision itself compares normalizeForkReserved's output --
// this dump labels whether the first raw divergence falls inside the
// Inside-Macintosh-reserved span (< resourceForkDataStart -- should be
// unreachable, since that's exactly what normalization already
// excluded; a defensive/diagnostic label, not a masking mechanism) or a
// REAL divergence at or past resourceForkDataStart, which is the only
// way this function is ever actually reached today.
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
	region := "REAL divergence (at or past the resource-data offset, resourceForkDataStart=256 -- NOT the reserved span)"
	if div >= 0 && div < resourceForkDataStart {
		region = "inside the Inside-Macintosh-reserved span (<256) -- unexpected, since normalizeForkReserved should already have excluded this"
	}
	// Fix round 3: t.TempDir()'s own dump files don't survive past the test
	// process's exit, and round 2's own failure needed a live re-run just to
	// see what the mismatched bytes actually were -- log the first 64 bytes
	// of EACH fork directly (hex.Dump, stdlib) so the run's own -v output is
	// self-sufficient even after TempDir cleanup.
	t.Logf("%s on-Mac fork, first 64 bytes:\n%s", name, hex.Dump(head(gotMac, 64)))
	t.Logf("%s host oracle fork, first 64 bytes:\n%s", name, hex.Dump(head(wantHost, 64)))
	t.Fatalf("%s fork mismatch: on-Mac %d bytes vs host oracle %d bytes; first divergence at byte %d (%s)\non-Mac fork:   %s\nhost fork:     %s\nxxd -s %d -l 64 <file> to inspect",
		name, len(gotMac), len(wantHost), div, region, macPath, hostPath, maxInt(div-16, 0))
}

// head returns b's first n bytes, or all of b if shorter.
func head(b []byte, n int) []byte {
	if len(b) < n {
		return b
	}
	return b[:n]
}

func maxInt(a, b int) int {
	if a > b {
		return a
	}
	return b
}
