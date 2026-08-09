// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// clarusc_boot_test.go: Task 10 (mac-resident-clarusc phase) -- the
// native boot smoke for ClarusC.APPL, the Mac-resident compiler's GUI
// front end (clarusc/macgui.cla). Uses the Task 4 Snow harness
// (snow_test.go), not LaunchAPPL/Mini vMac: ClarusC.APPL is a
// System-7-targeted app with a SIZE(-1) partition (scripts/
// build-clarusc-mac.sh's own --partition flag) -- Mini vMac's 4MB Mac
// Plus cannot host it even at Task 10's original reduced size (no
// headroom left for the app itself), so this always needed Snow.
// History: Task 10 landed on a 4MB partition (double the ordinary 2MB
// default), not the plan's original 48-64MB target, because the then-
// current snow/Clarus.snoww workspace booted with no 32-bit addressing
// (init_args.pmmu_enabled=false), which capped Process-Manager-
// allocatable RAM at ~6.8MB regardless of the workspace's 128MB physical
// ram_size -- found by a REAL Finder alert requesting the original 64MB
// target: "There is not enough memory to open ClarusC (65,536K needed,
// 6,968K available)". As of 2026-08-09 the Snow machine runs a 32-bit-
// clean ROM (snow/rominator.rom) with 32-bit addressing enabled (Largest
// Unused Block 129,868K verified), removing that ceiling --
// build-clarusc-mac.sh now passes 48MB (Task 11); TestClarusCBootOnSnow
// itself needed no change, it only asserts the boot/quit trace shape.
package mactest

import (
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
	"time"
)

// clarusCBootSettle is how long TestClarusCBootOnSnow lets Snow sit after
// boot before quitting it -- the app's own work (App.startEmpty opens the
// Log window, then the baked --events script fires a single "quit") is
// near-instant once Finder runs Startup Items; this is a generous
// multiple of that, not a measured minimum (same reasoning as
// snow_test.go's own snowRoundTripSettle). Raised from 20s to 45s (Task
// 11, 32-bit-addressing/48MB-partition machine): 20s was found to
// intermittently race a still-launching app -- a bigger SIZE(-1)
// partition takes the Process Manager measurably longer to zone/launch
// than the original 4MB build did, and `done` is a pure elapsed-time
// heuristic with no actual completion signal (see runSnow's own doc
// comment), so a too-tight settle quits Snow before the app finishes.
const clarusCBootSettle = 45 * time.Second

// TestClarusCBootOnSnow builds ClarusC.APPL (scripts/build-clarusc-mac.sh,
// baked with the whole runtime/clarus + toolbox catalog, --events a
// single scripted "quit" so the app exits with no real input), installs
// it into Startup Items, boots Snow, and checks the captured "out" trace
// for a window-open line and a clean exit -- proof the app launches,
// opens its one window (App.startEmpty), and quits cleanly under its own
// enlarged SIZE partition.
func TestClarusCBootOnSnow(t *testing.T) {
	requireSnow(t)

	root := repoRoot(t)
	bin := filepath.Join(root, "build-68k", "ClarusC", "ClarusC.bin")
	events := filepath.Join(root, "testdata", "mac-resident", "clarusc-boot.events")
	buildCmd := exec.Command(filepath.Join(root, "scripts", "build-clarusc-mac.sh"), "--events", events)
	buildCmd.Dir = root
	if out, err := buildCmd.CombinedOutput(); err != nil {
		t.Fatalf("build-clarusc-mac.sh --events %s: %v\n%s", events, err, out)
	}

	d := newSnowDisk(t)
	d.putMacBinary(t, bin, "ClarusC")

	start := time.Now()
	runSnow(t, d, 3*time.Minute, func() bool { return time.Since(start) >= clarusCBootSettle })

	appOut := string(d.get(t, ":System Folder:Startup Items:out"))
	if !strings.Contains(appOut, "T OPEN Log") {
		t.Errorf("app out missing window-open trace (\"T OPEN Log\"):\n%s", appOut)
	}
	if !strings.Contains(appOut, "##CLARUS-EXIT## 0") {
		t.Errorf("app out missing clean exit trailer:\n%s", appOut)
	}
}
