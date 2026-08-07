// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

package mactest

import (
	"bytes"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
	"sync"
	"testing"
)

// appResBuild caches the one build-mac.sh invocation shared by
// TestAppResNaming/Resources/BundleBit -- all three inspect different
// artifacts of the SAME build (naming, appres.r + CMakeLists.txt, and the
// stamped .dsk), so one build is enough.
type appResBuild struct {
	dir            string
	stdout, stderr string
	err            error
}

var (
	appResOnce   sync.Once
	appResResult appResBuild
)

// buildAppRes runs `scripts/build-mac.sh ../../testdata/ui/appres.cla
// --test` -- WITHOUT a leading NAME arg, exercising the new appinfo-driven
// naming path (runBuildMac in mac_test.go always prepends a NAME and can't
// be reused here).
func buildAppRes(t *testing.T) string {
	t.Helper()
	appResOnce.Do(func() {
		root := repoRoot(t)
		cmd := exec.Command(filepath.Join(root, "scripts", "build-mac.sh"), "../../testdata/ui/appres.cla", "--test")
		var stdout, stderr bytes.Buffer
		cmd.Stdout = &stdout
		cmd.Stderr = &stderr
		err := cmd.Run()
		appResResult = appResBuild{
			dir:    filepath.Join(root, "build-mac", "App-Res-Probe"),
			stdout: stdout.String(),
			stderr: stderr.String(),
			err:    err,
		}
	})
	if appResResult.err != nil {
		t.Fatalf("build-mac.sh appres.cla --test failed: %v\nstdout: %s\nstderr: %s",
			appResResult.err, appResResult.stdout, appResResult.stderr)
	}
	return appResResult.dir
}

// TestAppResNaming asserts that when NAME is omitted (first arg ends in
// .cla), build-mac.sh derives it from `clarusc appinfo`'s name= line,
// sanitized to [A-Za-z0-9_-].
func TestAppResNaming(t *testing.T) {
	requireCprintMac(t)
	dir := buildAppRes(t)
	bin := filepath.Join(dir, "App-Res-Probe.bin")
	if _, err := os.Stat(bin); err != nil {
		t.Fatalf("expected sanitized-name binary: %v", err)
	}
}

// TestAppResResources asserts the generated appres.r contains the about
// ALRT/DITL, vers, SIZE(-1) (mac-target-4c Task 5: isHighLevelEventAware,
// for every app-section program), and (since appres.cla declares an icon)
// BNDL/ICN#/FREF/id signature -- including the Task 5 document icon (FREF
// 129 + ICN#/ICON 129) and the BNDL arrays extended to list it -- and that
// the CMakeLists.txt passes the app's id as CREATOR.
func TestAppResResources(t *testing.T) {
	requireCprintMac(t)
	dir := buildAppRes(t)

	r, err := os.ReadFile(filepath.Join(dir, "appres.r"))
	if err != nil {
		t.Fatalf("appres.r: %v", err)
	}
	rs := string(r)
	for _, want := range []string{
		"resource 'ALRT' (129",
		"resource 'vers' (1",
		"resource 'SIZE' (-1",
		"isHighLevelEventAware",
		"resource 'BNDL' (128",
		"{ 'ICN#', { 0, 128, 1, 129 }, 'FREF', { 0, 128, 1, 129 } }",
		"'PRBR'",
		"resource 'ICN#' (128",
		"resource 'ICON' (128",
		"resource 'FREF' (129, purgeable) { 'TEXT', 1, \"\" };",
		"resource 'ICN#' (129",
		"resource 'ICON' (129",
	} {
		if !strings.Contains(rs, want) {
			t.Errorf("appres.r missing %q:\n%s", want, rs)
		}
	}

	cm, err := os.ReadFile(filepath.Join(dir, "CMakeLists.txt"))
	if err != nil {
		t.Fatalf("CMakeLists.txt: %v", err)
	}
	if !strings.Contains(string(cm), `CREATOR "PRBR"`) {
		t.Errorf("CMakeLists.txt missing CREATOR \"PRBR\":\n%s", cm)
	}
}

// buildSetbundle compiles scripts/setbundle.c against the Retro68-build
// libhfs, same compile-and-cache-in-t.TempDir() pattern as buildPbm2Icn in
// pbm2icn_test.go. Requires the Retro68 toolchain checkout (not the
// emulator), so it's only called from requireCprintMac(t)-gated tests.
func buildSetbundle(t *testing.T) string {
	t.Helper()
	root := repoRoot(t)
	libhfs := filepath.Join(root, "..", "Retro68-build", "hfsutils", "libhfs", "libhfs.a")
	if _, err := os.Stat(libhfs); err != nil {
		t.Fatalf("libhfs.a not found at %s (need a built Retro68-build tree): %v", libhfs, err)
	}
	bin := filepath.Join(t.TempDir(), "setbundle")
	cmd := exec.Command("cc", "-Wall",
		"-I", filepath.Join(root, "Retro68", "hfsutils", "libhfs"),
		"-o", bin,
		filepath.Join(root, "scripts", "setbundle.c"),
		libhfs)
	var stderr bytes.Buffer
	cmd.Stderr = &stderr
	if err := cmd.Run(); err != nil {
		t.Fatalf("cc scripts/setbundle.c: %v\n%s", err, stderr.String())
	}
	return bin
}

// TestAppResBundleBit asserts that build-mac.sh's post-build setbundle step
// stamped the bundle bit (0x2000) and cleared the "has been inited" bit
// (0x0100) on the file inside the built .dsk.
func TestAppResBundleBit(t *testing.T) {
	requireCprintMac(t)
	dir := buildAppRes(t)
	setbundle := buildSetbundle(t)

	dsk := filepath.Join(dir, "App-Res-Probe.dsk")
	if _, err := os.Stat(dsk); err != nil {
		t.Fatalf("expected .dsk: %v", err)
	}

	// Rez names the file inside the .dsk from the output stem (verified
	// via toolchain/bin/hls against existing builds) -- "App-Res-Probe".
	cmd := exec.Command(setbundle, "-q", dsk, "App-Res-Probe")
	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	if err := cmd.Run(); err != nil {
		t.Fatalf("setbundle -q: %v\nstdout: %s\nstderr: %s", err, stdout.String(), stderr.String())
	}
	flags, err := strconv.ParseInt(strings.TrimSpace(stdout.String()), 16, 32)
	if err != nil {
		t.Fatalf("malformed fdflags output %q: %v", stdout.String(), err)
	}
	if flags&0x2000 == 0 {
		t.Errorf("fdflags %04x: bundle bit (0x2000) not set", flags)
	}
	if flags&0x0100 != 0 {
		t.Errorf("fdflags %04x: hasBeenInited bit (0x0100) still set", flags)
	}
}
