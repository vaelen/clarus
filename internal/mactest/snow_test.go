// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// snow_test.go: Task 4 (mac-resident-clarusc phase) -- the Snow-emulator
// file round-trip harness. Snow (snow/Snow, a real macOS GUI app, no
// headless mode) is the acceptance emulator for the phase's later tasks
// (10/11/12), which run the Clarus compiler ITSELF inside it; this file
// turns the manually-proven boot recipe (docs/superpowers/plans/
// 2026-08-08-mac-resident-clarusc.md's "Snow facts") into reliable Go
// helpers: put files onto a scratch copy of the boot disk, boot Snow,
// wait for the app under test to finish, quit Snow, pull files back out.
//
// Gated on CLARUS_SNOW_TESTS=1, separately from CLARUS_MAC_TESTS -- Snow
// steals the screen for the whole run (no way to run it off-screen), so
// it must never fire as a side effect of the ordinary Mini-vMac/Retro68
// gate.
//
// Empirically probed findings (full writeup: task-4-report.md, gitignored
// phase-workspace memo):
//
//   - Launch: dropping the app-under-test's MacBinary .bin into
//     ":System Folder:Startup Items:" (hcopy -m, disk not mounted) is a
//     working no-click auto-launch mechanism on this System 7.1 image --
//     confirmed by Finder running it at boot with no synthetic input.
//     BUT Finder auto-OPENS every item in Startup Items, not just
//     applications -- a plain data file dropped there too throws a
//     blocking "could not be opened" dialog before the real app gets a
//     turn. So only the app-under-test's binary goes in Startup Items;
//     every other file (put/get) lives at the volume root instead.
//   - Path convention: an app auto-launched from Startup Items has its
//     OWN folder as its default directory (two levels below the volume
//     root: root -> System Folder -> Startup Items), so a bare relative
//     filename resolves there, not at the root where put/get place
//     things. The fixture app (testdata/snow/roundtrip.cla) reaches the
//     root with the HFS up-level idiom ":::NAME" (each extra leading
//     colon means one directory up) -- volume-name-qualified full
//     pathnames ("System:NAME") were tried first and did NOT work here.
//   - Completion detection: the disk image is NOT written through to the
//     host file while Snow is running -- confirmed by polling the scratch
//     image's mtime/size for 100+ seconds mid-run with no change at all.
//     Only unmounting (i.e. Snow's process exiting) flushes guest writes
//     to the host-visible file. This rules out any "poll the host file
//     for a sentinel" approach; runSnow instead polls the caller's own
//     `done` (best-effort, e.g. elapsed-time based) and unconditionally
//     quits Snow once it returns true or the timeout elapses.
//   - Quit/shutdown: `osascript -e 'quit app "Snow"'` reliably and
//     promptly exits Snow's process after the guest app has returned to
//     an idle Finder -- every probe boot (and every TestSnowRoundTrip
//     run below) quit cleanly this way, with the resulting disk image
//     always mountable afterward and byte-exact on the round-tripped
//     file; no drag.swift-driven Shut Down was ever needed.
//   - shared_dir (~30 min budget, per the brief): tried once (set to a
//     scratch host folder, booted, screenshotted the desktop) -- no
//     volume appeared, and it left a stray Finder-info file that broke a
//     later Startup Items boot on the same image. Not adopted: the
//     hfsutils-on-the-image-file recipe already solves the whole
//     file-transfer requirement with zero guest-side setup.
package mactest

import (
	"encoding/json"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
	"time"
)

// requireSnow gates every Snow-emulator test. Deliberately its own env
// var, never folded into requireMac's CLARUS_MAC_TESTS: Snow is a real
// GUI app with no headless mode, so a boot occupies the whole screen for
// its entire run, unlike the Mini vMac/LaunchAPPL lane.
func requireSnow(t *testing.T) {
	if os.Getenv("CLARUS_SNOW_TESTS") == "" {
		t.Skip("set CLARUS_SNOW_TESTS=1 (boots Snow on screen; needs the Snow emulator + display)")
	}
}

// hfsutilsBin returns the path to one of toolchain/bin's hfsutils
// programs (hmount, hcopy, humount, ...) -- the same tools
// docs/superpowers/plans/2026-08-08-mac-resident-clarusc.md's Snow facts
// block already documents for direct disk-image editing while Snow isn't
// running.
func hfsutilsBin(t *testing.T, name string) string {
	t.Helper()
	return filepath.Join(repoRoot(t), "toolchain", "bin", name)
}

// runHfs runs an hfsutils tool (args[0] is the program name, e.g.
// "hcopy") against d's disk and fails the test on any error. HOME is
// overridden to d.dir (this snowDisk's own scratch dir): hfsutils tools
// keep the "currently mounted volume" pointer in $HOME/.hcwd, a real
// piece of cross-process shared state (confirmed via `strings` on the
// hmount binary) -- without isolating HOME per snowDisk, two snowDisks
// mounting different images from concurrent test processes could race on
// that shared file. Each snowDisk gets its own t.TempDir(), so this also
// isolates .hcwd per snowDisk for free.
func (d *snowDisk) runHfs(t *testing.T, args ...string) string {
	t.Helper()
	cmd := exec.Command(hfsutilsBin(t, args[0]), args[1:]...)
	cmd.Env = append(os.Environ(), "HOME="+d.dir)
	out, err := cmd.CombinedOutput()
	if err != nil {
		t.Fatalf("%s: %v\n%s", strings.Join(args, " "), err, out)
	}
	return string(out)
}

// copyFile copies src to dst byte-for-byte.
func copyFile(t *testing.T, src, dst string) {
	t.Helper()
	data, err := os.ReadFile(src)
	if err != nil {
		t.Fatalf("read %s: %v", src, err)
	}
	if err := os.WriteFile(dst, data, 0o644); err != nil {
		t.Fatalf("write %s: %v", dst, err)
	}
}

// snowDisk is a scratch boot disk for one Snow test: a private copy of
// the disk image snow/Clarus.snoww's own scsi_targets[0].Disk names (the
// proven, already-set-up System 7.1 image -- see the Snow facts block)
// plus a scratch workspace (.snoww) and PRAM file pointing at it, so the
// pristine snow/ originals and the shared ROMs are never touched.
type snowDisk struct {
	dir       string // t.TempDir(): img, pram, and workspace all live here
	img       string // scratch copy of Clarus.snoww's scsi_targets[0].Disk
	workspace string // scratch .snoww naming img/pram, ROM paths absolute
}

// snowAbsPath absolutizes a workspace-relative ROM path from
// snow/Clarus.snoww (stored as a bare filename, e.g. "rominator.rom") by
// joining it against snow/; an already-absolute path (or an unexpected
// non-string/missing value) passes through unchanged.
func snowAbsPath(root string, v any) string {
	p, ok := v.(string)
	if !ok || p == "" || filepath.IsAbs(p) {
		return p
	}
	return filepath.Join(root, "snow", p)
}

// newSnowDisk clones Clarus.snoww's own disk image + snow/clarus.pram into a fresh
// t.TempDir() and writes a scratch workspace JSON (cloned from
// snow/Clarus.snoww) pointing rom_path/display_card_rom_path/pram_path/
// scsi_targets[0].Disk at that scratch copy -- the same "workspace JSON
// cloning" recipe the Snow facts block records, done fresh per test so
// runs never see another test's (or a previous crashed run's) leftover
// Startup Items debris.
func newSnowDisk(t *testing.T) *snowDisk {
	t.Helper()
	root := repoRoot(t)
	dir := t.TempDir()

	raw, err := os.ReadFile(filepath.Join(root, "snow", "Clarus.snoww"))
	if err != nil {
		t.Fatalf("read snow/Clarus.snoww: %v", err)
	}
	var ws map[string]any
	if err := json.Unmarshal(raw, &ws); err != nil {
		t.Fatalf("parse snow/Clarus.snoww: %v", err)
	}

	// Disk image: read the source filename from the template's own
	// scsi_targets[0].Disk (e.g. "hdd0.img") instead of hardcoding it --
	// the same reasoning as rom_path below. A stale hardcoded name here
	// previously pointed at snow/hdd0-clarus.img, which no longer exists
	// after the controller's 2026-08-09 resync renamed it to hdd0.img.
	targets, ok := ws["scsi_targets"].([]any)
	if !ok || len(targets) == 0 {
		t.Fatalf("snow/Clarus.snoww: scsi_targets missing or empty")
	}
	target0, ok := targets[0].(map[string]any)
	if !ok {
		t.Fatalf("snow/Clarus.snoww: scsi_targets[0] is not an object")
	}
	diskName, ok := target0["Disk"].(string)
	if !ok || diskName == "" {
		t.Fatalf("snow/Clarus.snoww: scsi_targets[0].Disk missing or empty")
	}

	img := filepath.Join(dir, "hdd0.img")
	copyFile(t, snowAbsPath(root, diskName), img)

	pram := filepath.Join(dir, "clarus.pram")
	copyFile(t, filepath.Join(root, "snow", "clarus.pram"), pram)

	// rom_path/display_card_rom_path: absolutize whatever snow/Clarus.snoww
	// itself names (relative to snow/), instead of hardcoding a specific ROM
	// filename here. As of 2026-08-09 the checked-in workspace names
	// snow/rominator.rom (a 32-bit-clean ROM, replacing the earlier
	// MacIIFDHD-IIx-IIcx.rom) -- hardcoding the old name would silently pin
	// every Snow test back to the pre-32-bit-addressing ROM even after the
	// controller re-synced the workspace.
	ws["rom_path"] = snowAbsPath(root, ws["rom_path"])
	ws["display_card_rom_path"] = snowAbsPath(root, ws["display_card_rom_path"])
	ws["pram_path"] = pram
	targets[0] = map[string]any{"Disk": img}
	ws["scsi_targets"] = targets

	out, err := json.MarshalIndent(ws, "", "  ")
	if err != nil {
		t.Fatalf("marshal scratch workspace: %v", err)
	}
	workspace := filepath.Join(dir, "scratch.snoww")
	if err := os.WriteFile(workspace, out, 0o644); err != nil {
		t.Fatalf("write scratch workspace: %v", err)
	}

	return &snowDisk{dir: dir, img: img, workspace: workspace}
}

// mount hmounts d's image (hfsutils' single global "current volume" --
// callers must not overlap two mounted snowDisks) and returns a function
// that humounts it; always call it, even on a later t.Fatalf (which runs
// deferred functions via runtime.Goexit).
func (d *snowDisk) mount(t *testing.T) func() {
	t.Helper()
	d.runHfs(t, "hmount", d.img)
	return func() {
		cmd := exec.Command(hfsutilsBin(t, "humount"))
		cmd.Env = append(os.Environ(), "HOME="+d.dir)
		cmd.Run()
	}
}

// hfsPath turns a bare filename into a volume-root HFS path (":NAME"),
// or passes an already-colon-prefixed path (e.g. a Startup Items path)
// through unchanged -- callers can reach anywhere on the volume this way
// without a separate directory parameter.
func hfsPath(name string) string {
	if strings.HasPrefix(name, ":") {
		return name
	}
	return ":" + name
}

// putText writes data as a text-mode file at the volume root, named
// name. Text mode (hcopy -t): CR/LF translation is Mac-native (the
// language reference's writeText/readText are already byte-verbatim on
// the Clarus side; this is purely how hfsutils stages the host file).
func (d *snowDisk) putText(t *testing.T, name string, data []byte) {
	t.Helper()
	tmp := filepath.Join(t.TempDir(), filepath.Base(name))
	if err := os.WriteFile(tmp, data, 0o644); err != nil {
		t.Fatalf("stage %s: %v", name, err)
	}
	unmount := d.mount(t)
	defer unmount()
	d.runHfs(t, "hcopy", "-t", tmp, hfsPath(name))
}

// putMacBinary installs a MacBinary-encoded native build (forks
// preserved -- exactly what scripts/build-68k.sh's emit68k .bin already
// is) as name INTO ":System Folder:Startup Items:", the harness's proven
// no-click auto-launch mechanism. This is the only file put/get ever
// places there; every other file lives at the volume root (see the file
// header's Startup-Items-auto-opens-everything finding).
func (d *snowDisk) putMacBinary(t *testing.T, binPath, name string) {
	t.Helper()
	unmount := d.mount(t)
	defer unmount()
	d.runHfs(t, "hcopy", "-m", binPath, ":System Folder:Startup Items:"+name)
}

// get extracts name (bare = volume root, or an explicit colon path, e.g.
// ":System Folder:Startup Items:out") in text mode.
func (d *snowDisk) get(t *testing.T, name string) []byte {
	t.Helper()
	tmp := filepath.Join(t.TempDir(), "get-text")
	unmount := d.mount(t)
	d.runHfs(t, "hcopy", "-t", hfsPath(name), tmp)
	unmount()
	b, err := os.ReadFile(tmp)
	if err != nil {
		t.Fatalf("read extracted %s: %v", name, err)
	}
	return b
}

// getMacBinary extracts name (same path rule as get) in MacBinary mode
// (forks preserved).
func (d *snowDisk) getMacBinary(t *testing.T, name string) []byte {
	t.Helper()
	tmp := filepath.Join(t.TempDir(), "get-bin")
	unmount := d.mount(t)
	d.runHfs(t, "hcopy", "-m", hfsPath(name), tmp)
	unmount()
	b, err := os.ReadFile(tmp)
	if err != nil {
		t.Fatalf("read extracted %s: %v", name, err)
	}
	return b
}

// snowPollInterval is how often runSnow polls the caller's done() while
// Snow is up.
const snowPollInterval = 2 * time.Second

// snowQuitGrace bounds how long runSnow waits for Snow's process to exit
// after asking it to quit, before falling back to killing it directly.
const snowQuitGrace = 20 * time.Second

// runSnow boots d's workspace in Snow (a real, on-screen GUI app -- the
// caller's Bash/exec environment must run with its sandbox disabled, same
// as any CGEvent/screencapture call per the plan's own note), polls
// done() every snowPollInterval up to timeout, then asks Snow to quit
// gracefully (osascript, proven reliable -- see the file header) and
// waits up to snowQuitGrace for its process to actually exit, force-
// killing it BY THE PID RECORDED AT LAUNCH (never by name) only if that
// hangs.
//
// done has no host-observable disk state to poll (writes aren't flushed
// until Snow's process exits -- see the file header), so it is
// necessarily a best-effort/proxy signal (e.g. elapsed wall-clock time);
// runSnow itself makes no assumption about what done checks.
//
// Two failure paths that DON'T fall through to the caller's extraction
// code (fixing task-4-review.md's Critical/Important findings):
//
//   - Snow's process dying during the poll loop (crash, bad workspace
//     JSON, missing ROM, ...) is detected within one poll tick and fails
//     the test immediately, instead of burning the whole timeout and
//     then failing confusingly at hfsutils extraction.
//   - A quit that isn't graceful (snowQuitGrace elapses, so the harness
//     falls back to killing the process by PID) fails the test loudly.
//     The disk image is untrustworthy after a forced kill -- guest HFS
//     writes only flush to the host-visible file on a clean Snow process
//     exit (see the file header) -- so proceeding to extract from it
//     would silently assert against a possibly-corrupt image.
// extraArgs (serial-connection Task 7) is a variadic tail appended to the
// launch argv after the workspace path -- e.g. "--serial-bridge-a",
// "tcp:PORT" to enable the SCC channel A TCP bridge, per `snow/Snow
// --help`. Every existing caller passes none, so this is source-compatible
// with every call site that predates it.
func runSnow(t *testing.T, d *snowDisk, timeout time.Duration, done func() bool, extraArgs ...string) {
	t.Helper()
	start := time.Now()
	snowBin := filepath.Join(repoRoot(t), "snow", "Snow")
	args := append([]string{d.workspace}, extraArgs...)
	cmd := exec.Command(snowBin, args...)
	if err := cmd.Start(); err != nil {
		t.Fatalf("launch Snow: %v", err)
	}

	exited := make(chan error, 1)
	go func() { exited <- cmd.Wait() }()

	// Safety net: if the caller's done() (or something else in the test)
	// unwinds this goroutine early via t.Fatalf/FailNow without runSnow
	// reaching its own quit/kill logic below, don't leak Snow on screen.
	reaped := false
	t.Cleanup(func() {
		if !reaped {
			cmd.Process.Kill()
		}
	})

	deadline := time.Now().Add(timeout)
	for time.Now().Before(deadline) && !done() {
		select {
		case werr := <-exited:
			reaped = true
			t.Fatalf("Snow exited early (state %v) after %s", werr, time.Since(start))
		case <-time.After(snowPollInterval):
		}
	}

	quitErr := exec.Command("osascript", "-e", `quit app "Snow"`).Run()

	select {
	case werr := <-exited:
		reaped = true
		if werr != nil {
			t.Logf("Snow process exited with error after quit request: %v", werr)
		}
	case <-time.After(snowQuitGrace):
		reaped = true
		killErr := cmd.Process.Kill()
		<-exited // Kill() forces the exit; bound the wait so we don't hang.
		t.Fatalf("Snow did not quit gracefully within %s (quit app error: %v); force-killed pid %d (kill error: %v) -- disk image is untrustworthy after a forced kill, failing instead of extracting from it", snowQuitGrace, quitErr, cmd.Process.Pid, killErr)
	}
}

// snowRoundTripSettle is how long TestSnowRoundTrip lets Snow sit after
// boot before quitting it -- the fixture app's own work (open a window,
// two file ops, quit) finishes within a couple of seconds of Finder
// running Startup Items in every manual probe run (task-4-report.md);
// this is a generous multiple of that, not a measured minimum.
const snowRoundTripSettle = 30 * time.Second

// TestSnowRoundTrip is Task 4's own foundation self-test: plant a marker
// file at the volume root, install the roundtrip fixture (rebuilt fresh
// via scripts/build-68k.sh, matching testsuite convention) into Startup
// Items, boot, let it self-launch/read/write/quit, quit Snow, and check
// everything that came back out -- the copy is byte-identical to the
// marker, the fixture's own alert()-logged status lines both say "ok",
// and its out capture file round-trips too. Must be rock solid: the plan
// wants 3 consecutive green runs.
func TestSnowRoundTrip(t *testing.T) {
	requireSnow(t)

	root := repoRoot(t)
	bin := filepath.Join(root, "build-68k", "SnowRoundTrip", "SnowRoundTrip.bin")
	buildCmd := exec.Command(filepath.Join(root, "scripts", "build-68k.sh"), "testdata/snow/roundtrip.cla")
	buildCmd.Dir = root
	if out, err := buildCmd.CombinedOutput(); err != nil {
		t.Fatalf("build-68k.sh testdata/snow/roundtrip.cla: %v\n%s", err, out)
	}

	marker := []byte("Snow round-trip marker: " + time.Now().Format(time.RFC3339Nano) + "\n")

	d := newSnowDisk(t)
	d.putText(t, "Marker.txt", marker)
	d.putMacBinary(t, bin, "SnowRoundTrip")

	start := time.Now()
	runSnow(t, d, 3*time.Minute, func() bool { return time.Since(start) >= snowRoundTripSettle })

	copyBytes := d.get(t, "Copy.txt")
	if string(copyBytes) != string(marker) {
		t.Errorf("Copy.txt mismatch:\n want %q\n got  %q", marker, copyBytes)
	}

	appOut := string(d.get(t, ":System Folder:Startup Items:out"))
	if !strings.Contains(appOut, "read ok") {
		t.Errorf("app out missing \"read ok\":\n%s", appOut)
	}
	if !strings.Contains(appOut, "write ok") {
		t.Errorf("app out missing \"write ok\":\n%s", appOut)
	}
	if !strings.Contains(appOut, "##CLARUS-EXIT## 0") {
		t.Errorf("app out missing clean exit trailer:\n%s", appOut)
	}
}
