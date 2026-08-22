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
// a Mac one. Used by runNativeHostCompareSeglimit's host half in
// native_test.go (via the single-file buildHostFromFixture wrapper);
// formerly also by BuildCoreCLIHost here, deleted by test-consolidation
// Task 7 alongside TestSuiteOnMac (audit row R12, DELETE).
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
// prefix; `coreGUIFiles` (coresuite_test.go) appends the surviving GUI
// front end. (Its host and Mac/native siblings, `coreCLIHostFiles`/
// `coreCLIMacFiles`, were deleted by test-consolidation Task 7 alongside
// their last caller, TestSuiteOnMac -- audit row R12, DELETE; core/
// cli.cla and core/cli_mac.cla themselves stay, still depended on by
// internal/testsuite/core_cli_test.go and internal/cg68k/segment_test.go
// respectively.) Paths are repo-root-relative; callers join against
// repoRoot(t).
var coreCLIFiles = []string{
	filepath.Join("testsuite", "kit.cla"),
	filepath.Join("testsuite", "core", "runner.cla"),
	filepath.Join("testsuite", "core", "cases_str.cla"),
	filepath.Join("testsuite", "core", "cases_text.cla"),
	filepath.Join("testsuite", "core", "cases_list.cla"),
	filepath.Join("testsuite", "core", "cases_map.cla"),
	filepath.Join("testsuite", "core", "cases_sortedmap.cla"),
	filepath.Join("testsuite", "core", "cases_intmap.cla"),
	filepath.Join("testsuite", "core", "cases_rec.cla"),
	filepath.Join("testsuite", "core", "cases_arr.cla"),
	filepath.Join("testsuite", "core", "cases_enumfix.cla"),
	filepath.Join("testsuite", "core", "cases_ser.cla"),
	filepath.Join("testsuite", "core", "cases_misc.cla"),
	filepath.Join("testsuite", "core", "cases_xrec.cla"),
	filepath.Join("testsuite", "core", "cases_datetime.cla"),
	filepath.Join("testsuite", "core", "cases_param.cla"),
	filepath.Join("testsuite", "core", "cases_abort.cla"),
	// clir-load-perf Task 2 (design C): cases_textrange.cla MUST be here --
	// runner.cla (above) unconditionally calls caseTextRange(). This list
	// also feeds coreGUIFiles' native emit68k lane (TestCoreSuiteGUIOn68k/
	// OnMac, coresuite_test.go); cg68k.cla has no arms yet for the new
	// bulk-range-read intrinsics (clir-load-perf Task 3's job, out of this
	// task's scope), so those two gated (CLARUS_MAC_TESTS=1) native-boot
	// tests fail until Task 3 lands. Accepted/expected -- and, unlike a
	// missing-file "undefined: caseTextRange" checker error, at least
	// fails with the real, specific gap ("unsupported UI intrinsic
	// text_int_at" -- text_u32_at before the post-review u32At->intAt
	// rename). Same story in internal/cg68k/segment_test.go and
	// internal/bake/bakeidentity_test.go's own core-suite file lists.
	filepath.Join("testsuite", "core", "cases_textrange.cla"),
	// correctness-cleanup Task 6: cases_errret.cla MUST be here -- runner.cla
	// (above) unconditionally calls caseErrReturn().
	filepath.Join("testsuite", "core", "cases_errret.cla"),
	// correctness-cleanup Task 7: cases_evalorder.cla MUST be here --
	// runner.cla unconditionally calls caseEvalOrder().
	filepath.Join("testsuite", "core", "cases_evalorder.cla"),
	// binary-files phase Task 3: cases_textbinary.cla MUST be here --
	// runner.cla unconditionally calls caseTextBinary()/caseCrc16()/
	// caseIntToStr().
	filepath.Join("testsuite", "core", "cases_textbinary.cla"),
	// binary-files phase Task 5: cases_fileh.cla MUST be here -- runner.cla
	// unconditionally calls caseFileHandleRW().
	filepath.Join("testsuite", "core", "cases_fileh.cla"),
}

// coreCLIHostFiles/absFiles/BuildCoreCLIHost/RunCoreCLIHost (coreCLIFiles +
// core/cli.cla, the host-oracle build/run pair for TestSuiteOnMac's
// mac/host byte-exact comparison) were deleted by test-consolidation
// Task 7 alongside their sole caller, TestSuiteOnMac (mac_test.go, audit
// row R12, DELETE) -- provably reference-free (`command grep -rn
// 'coreCLIHostFiles\|absFiles(\|BuildCoreCLIHost\|RunCoreCLIHost'
// internal/ testsuite/ scripts/` after this deletion finds only this
// comment).

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
