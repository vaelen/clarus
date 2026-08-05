// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

package mactest

import (
	"os/exec"
	"path/filepath"
	"testing"

	"clarus/internal/claruscboot"
)

// hostOracleClarusc returns the compiler the HOST-oracle builds use.
// Formerly bootstrapSnapshotClarusc (raw committed snapshot); now the
// shared current-source bootstrap, so host oracles exercise just-edited
// compiler code even when the snapshot is stale (spec: mactest host
// oracles mirror build-mac.sh's pipeline shape but exist to test current
// code).
func hostOracleClarusc(t *testing.T) string {
	t.Helper()
	return claruscboot.CurrentExe(t)
}

// buildHostFromFixtures emits claPaths' C with the current-source clarusc
// (claruscboot's shared Go-free bootstrap; a multi-file composition, same
// as any clarusc emit invocation with several files -- kit first by
// convention, immaterial to the emitted C since clarusc's lowering
// pre-pass makes cross-file declaration order otherwise immaterial) and
// compiles it with `cc`
// against the on-disk runtime sources (runtime/host/rt.c) -- the
// build-mac.sh step-1 pipeline, run straight to a host binary instead of
// a Mac one. Shared by BuildCoreCLIHost here and
// runNativeHostCompareSeglimit's host half in native_test.go (via the
// single-file buildHostFromFixture wrapper).
func buildHostFromFixtures(t *testing.T, claPaths []string, binName string) string {
	t.Helper()
	root := repoRoot(t)
	claruscExe := hostOracleClarusc(t)
	work := t.TempDir()
	outC := filepath.Join(work, binName+".c")
	rtDir := filepath.Join(root, "runtime", "clarus") + string(filepath.Separator)

	args := append([]string{"emit", "--rtdir", rtDir, "-o", outC}, claPaths...)
	emit := exec.Command(claruscExe, args...)
	if out, err := emit.CombinedOutput(); err != nil {
		t.Fatalf("clarusc emit %v: %v\n%s", claPaths, err, out)
	}

	exe := filepath.Join(work, binName)
	cc := exec.Command("cc", "-O1", "-I", filepath.Join(root, "runtime", "host"),
		outC, filepath.Join(root, "runtime", "host", "rt.c"), "-o", exe)
	if out, err := cc.CombinedOutput(); err != nil {
		t.Fatalf("cc compile emitted C for %v: %v\n%s", claPaths, err, out)
	}
	return exe
}

// buildHostFromFixture is buildHostFromFixtures for a single file --
// native_test.go's runNativeHostCompareSeglimit's own single-fixture case.
func buildHostFromFixture(t *testing.T, claPath, binName string) string {
	t.Helper()
	return buildHostFromFixtures(t, []string{claPath}, binName)
}

// coreCLIFiles is the core suite's CLI composition -- kit.cla +
// core/runner.cla + one core/cases_*.cla per family + a front-end file,
// the same case-file list internal/testsuite/core_cli_test.go's
// buildCoreCLI builds host-side (test-suite-review Task 9's Mac-gate
// swap: the Mac boot lanes exercise this composition instead of the
// retired testdata/suite/test_suite.cla -- a non-UI print program either
// way, so the same `clarusc emit`/`emit68k` build path applies
// unchanged). The front-end file differs by platform -- see
// testsuite/core/cli_mac.cla's own doc comment for why `core/cli.cla`
// (host, `App.startCLI`) can't also boot on native: cg68k's non-UI
// startup stub calls every declared app-level handler unconditionally,
// including `App.startCLI` with a never-marshaled (garbage) `args` list,
// which hangs the whole boot. `coreCLIFiles` is the shared case-file
// prefix; `coreCLIHostFiles`/`coreCLIMacFiles` append the right front
// end. Paths are repo-root-relative; callers join against repoRoot(t).
var coreCLIFiles = []string{
	filepath.Join("testsuite", "kit.cla"),
	filepath.Join("testsuite", "core", "runner.cla"),
	filepath.Join("testsuite", "core", "cases_str.cla"),
	filepath.Join("testsuite", "core", "cases_text.cla"),
	filepath.Join("testsuite", "core", "cases_list.cla"),
	filepath.Join("testsuite", "core", "cases_map.cla"),
	filepath.Join("testsuite", "core", "cases_rec.cla"),
	filepath.Join("testsuite", "core", "cases_arr.cla"),
	filepath.Join("testsuite", "core", "cases_enumfix.cla"),
	filepath.Join("testsuite", "core", "cases_ser.cla"),
	filepath.Join("testsuite", "core", "cases_misc.cla"),
	filepath.Join("testsuite", "core", "cases_xrec.cla"),
}

// coreCLIHostFiles is coreCLIFiles + core/cli.cla (host front-end,
// `App.startCLI` with real argv).
var coreCLIHostFiles = append(append([]string{}, coreCLIFiles...), filepath.Join("testsuite", "core", "cli.cla"))

// coreCLIMacFiles is coreCLIFiles + core/cli_mac.cla (Mac/native front
// end, `App.launch`, always runs the full case list).
var coreCLIMacFiles = append(append([]string{}, coreCLIFiles...), filepath.Join("testsuite", "core", "cli_mac.cla"))

// absFiles resolves a repo-root-relative file list to absolute paths
// (the convention buildHostFromFixtures/buildNative68kMulti both expect).
func absFiles(t *testing.T, files []string) []string {
	t.Helper()
	root := repoRoot(t)
	abs := make([]string, len(files))
	for i, f := range files {
		abs[i] = filepath.Join(root, f)
	}
	return abs
}

// pkgRelFiles resolves a repo-root-relative file list to package-dir-
// relative paths (the "../../..." convention BuildMac/runBuildMac's
// scripts/build-mac.sh invocation expects -- same as BuildMac's own
// claFiles doc comment).
func pkgRelFiles(files []string) []string {
	rel := make([]string, len(files))
	for i, f := range files {
		rel[i] = filepath.Join("..", "..", f)
	}
	return rel
}

// BuildCoreCLIHost builds the core suite's HOST CLI composition
// (coreCLIHostFiles, `core/cli.cla` front end) with the current-source
// clarusc (claruscboot's shared Go-free bootstrap; emit + cc) and returns
// the executable path.
func BuildCoreCLIHost(t *testing.T) string {
	t.Helper()
	return buildHostFromFixtures(t, absFiles(t, coreCLIHostFiles), "core_cli")
}

// RunCoreCLIHost runs the host core-CLI binary with argv ("all" by
// convention for the Mac-gate parity comparison) and returns its stdout
// (the PASS/FAIL/TOTAL log -- kit.cla's tkReport). This output is the
// byte-exact expectation for the Mac/native runs (mac_test.go,
// native_test.go).
func RunCoreCLIHost(t *testing.T, exe string, argv ...string) string {
	t.Helper()
	cmd := exec.Command(exe, argv...)
	cmd.Dir = t.TempDir() // the ser family does real file I/O
	out, err := cmd.Output()
	if err != nil {
		t.Fatalf("run core CLI: %v", err)
	}
	return string(out)
}
