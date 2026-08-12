// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// clarusc_bake_test.go: runtime-ir-bake Task 6 (Mac integration) -- the
// emulator verification the task's own brief asks for: build ClarusC.APPL
// with the baked 'CLIR'-carrying resource fork (the now-default build,
// scripts/build-clarusc-mac.sh), boot it, compile tickprobe.cla via the
// bake path, and byte-compare the produced fork against the host
// `--rtbake` oracle.
//
// Uses the Snow lane, NOT LaunchAPPL/Mini vMac: clarusc_boot_test.go's own
// header comment already documents why ClarusC.APPL cannot run there at
// all (its SIZE(-1) partition -- 48MB, scripts/build-clarusc-mac.sh's own
// --partition -- does not fit Mini vMac's 4MB Mac Plus configuration, "no
// headroom left for the app itself" even at Task 10's original reduced
// size). That is a pre-existing hardware constraint this task did not
// create and cannot work around; Snow (32-bit-clean ROM, 128MB RAM) is
// the ONLY lane that can boot ClarusC.APPL at all, as every existing
// ClarusC.APPL-boot test in this package (TestClarusCBootOnSnow,
// TestMacResidentClaruscOnSnow) already establishes. Gated
// CLARUS_SNOW_TESTS=1 accordingly, same as those two -- never
// CLARUS_MAC_TESTS=1, which this app structurally cannot satisfy.
//
// Deliberately lighter than TestMacResidentClaruscOnSnow (which this
// task's own brief calls out as "NOT this task -- that's phase-close"):
// ONE scripted compile (tickprobe.cla only, clarusc-bake-single.events),
// not two, and a much shorter default settle -- the bake path's whole
// point is removing the runtime's own phase-A/check/lower share of the
// compile, so a single from-cache compile should be substantially faster
// than the from-source timings TestMacResidentClaruscOnSnow's own header
// comment records (no bake-path Mac-hardware timing existed before this
// task to size against, so the default here is a conservative guess,
// overridable the same way via CLARUS_MACRESIDENT_SETTLE -- reusing that
// existing env var rather than inventing a second one, since both tests
// tune the exact same kind of wait).
package mactest

import (
	"bytes"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
	"time"
)

// clarusCBakeSettle is a conservative default for the single scripted
// compile this test drives -- half of macResidentCompileSettle's own
// 110-minute figure (that one sized for a from-source DOUBLE compile;
// this one is a single BAKE-path compile, expected faster on both
// counts), pending a real measurement. macResidentSettle (shared helper,
// macresident_test.go) already reads CLARUS_MACRESIDENT_SETTLE when set.
const clarusCBakeSettle = 55 * time.Minute

// clarusCBakeSettleDuration is macResidentSettle's own env-override
// pattern (CLARUS_MACRESIDENT_SETTLE, shared with
// TestMacResidentClaruscOnSnow -- both tests tune the same kind of wait,
// so reusing the one env var lets a single override apply to whichever
// is being re-run), but with THIS test's own lighter default
// (clarusCBakeSettle) instead of macResidentCompileSettle's 110-minute
// two-compile figure.
func clarusCBakeSettleDuration(t *testing.T) time.Duration {
	t.Helper()
	v := os.Getenv("CLARUS_MACRESIDENT_SETTLE")
	if v == "" {
		return clarusCBakeSettle
	}
	d, err := time.ParseDuration(v)
	if err != nil {
		t.Fatalf("CLARUS_MACRESIDENT_SETTLE=%q: %v", v, err)
	}
	return d
}

// TestClarusCBakePathOnSnow builds ClarusC.APPL with the CLIR resource
// baked in (scripts/build-clarusc-mac.sh's own default, no --no-bake-ir),
// boots it on Snow with a single scripted compile of tickprobe.cla, and
// requires:
//
//  1. The captured "out" trace names the BAKE path specifically --
//     gcResolveBakePath's own "clarusc: bake path (CLIR resource)" line
//     (macgui.cla), reaching this trace via the SAME log()/natLog
//     mechanism natQuit's own trailer flushes (parseCapture's
//     "##CLARUS-LOG##" section) -- proof the compile did NOT silently
//     fall back to CLFS-source, the exact failure mode a stamp/version/
//     lane mismatch (or a missing resource) would otherwise produce
//     invisibly.
//  2. The scripted compile actually dispatched (one "T FIRE
//     File.Compile.select" / "T ASKOPEN" pair) and no error-path marker
//     appears anywhere in the trace (same check macresident_test.go's
//     own TestMacResidentClaruscOnSnow uses, for the identical reason:
//     gcCompile's every error path calls alert(), which -- unlike gcLog
//     -- writes live into this captured stream).
//  3. TickProbe, extracted from the boot disk, is byte-identical
//     (resource fork only, MacBinary header stripped) to the SAME
//     fixture compiled by the current-source HOST compiler via
//     `emit68k --rtbake` (buildHostOracleFork below builds the from-
//     source oracle; TestBakePathByteIdentity/TestBakeFullCorpusCg68k,
//     internal/bake, already prove --rtbake == from-source on the host
//     side for this exact fixture -- this is the THIRD leg: the SAME
//     bake bytes, loaded from a REAL baked Mac resource fork by REAL
//     68k hardware, through gcResolveBakePath's own decision logic,
//     produce the SAME output too).
func TestClarusCBakePathOnSnow(t *testing.T) {
	requireSnow(t)

	root := repoRoot(t)
	tickFixture := filepath.Join(root, "testdata", "cg68k", "tickprobe.cla")
	events := filepath.Join(root, "testdata", "mac-resident", "clarusc-bake-single.events")

	tickOracle := buildHostOracleFork(t, tickFixture)

	buildCmd := exec.Command(filepath.Join(root, "scripts", "build-clarusc-mac.sh"), "--events", events)
	buildCmd.Dir = root
	buildStart := time.Now()
	if out, err := buildCmd.CombinedOutput(); err != nil {
		t.Fatalf("build-clarusc-mac.sh --events %s: %v\n%s", events, err, out)
	}
	t.Logf("ClarusC.APPL build (bake-by-default): %s", time.Since(buildStart))
	clarusCBin := filepath.Join(root, "build-68k", "ClarusC", "ClarusC.bin")

	d := newSnowDisk(t)
	d.putMacBinary(t, clarusCBin, "ClarusC")
	d.putText(t, "tickprobe.cla", mustReadFile(t, tickFixture))

	settle := clarusCBakeSettleDuration(t)
	runSnowTimeout := settle + 20*time.Minute
	bootStart := time.Now()
	runSnow(t, d, runSnowTimeout, func() bool { return time.Since(bootStart) >= settle })
	t.Logf("on-Mac bake-path compile boot: %s wall clock (settle=%s)", time.Since(bootStart), settle)

	appOut := string(d.get(t, ":System Folder:Startup Items:out"))
	t.Logf("app out (%d bytes):\n%s", len(appOut), appOut)

	if !strings.Contains(appOut, "clarusc: bake path (CLIR resource)") {
		t.Errorf("bake path not taken -- want the gcResolveBakePath log() line \"clarusc: bake path (CLIR resource)\" in the captured trace:\n%s", appOut)
	}
	if strings.Contains(appOut, "CLFS-source fallback") {
		t.Errorf("compile fell back to CLFS-source (want the bake path):\n%s", appOut)
	}

	fireCount := strings.Count(appOut, "T FIRE File.Compile.select")
	askOpenCount := strings.Count(appOut, "T ASKOPEN :::")
	if fireCount != 1 || askOpenCount != 1 {
		t.Fatalf("want 1 Compile.select dispatch + 1 real askOpen answer, got %d/%d:\n%s", fireCount, askOpenCount, appOut)
	}
	for _, bad := range []string{"cannot open entry file", "emit68k failed", "write failed", "error:", "warning:"} {
		if strings.Contains(appOut, bad) {
			t.Errorf("app out contains a compile-error signal (%q):\n%s", bad, appOut)
		}
	}
	if !strings.Contains(appOut, "##CLARUS-EXIT## 0") {
		t.Errorf("app out missing clean exit trailer (settle window may be too short -- see wall-clock log above):\n%s", appOut)
	}

	tickBin := macResidentExtractApp(t, d, "TickProbe")
	tickFork := readForkFromMacBinaryBytes(t, tickBin)
	if !bytes.Equal(tickFork, tickOracle) {
		dumpForkMismatch(t, "TickProbe", tickFork, tickOracle)
	}
}
