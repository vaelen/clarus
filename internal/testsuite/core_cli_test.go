// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// Package testsuite hosts the Go test harnesses driving the Clarus-native
// testsuite/ suites (test-suite-review Phase D/E). core_cli_test.go builds
// the core suite's host CLI (testsuite/kit.cla + testsuite/core/runner.cla
// + testsuite/core/cases_*.cla, one file per family + testsuite/core/
// cli.cla) via the shared Go-free bootstrap (claruscboot.CurrentExe --
// current-source two-stage build, disk-cached under build-run/, the same
// helper internal/emitui/emitui_test.go and others use), then runs it and
// parses the PASS/FAIL/TOTAL log format the plan's "Normative: the
// testsuite runner contract" section specifies
// (docs/superpowers/plans/2026-08-03-test-suite-review.md).
package testsuite

import (
	"bytes"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
	"testing"

	"clarus/internal/claruscboot"
)

// repoRoot returns the repo root, computed from the package directory (go
// test always runs with cwd == the package dir).
func repoRoot(t *testing.T) string {
	t.Helper()
	wd, err := os.Getwd()
	if err != nil {
		t.Fatalf("getwd: %v", err)
	}
	return filepath.Join(wd, "..", "..")
}

// bootstrapClarusc returns the current-source clarusc via the shared
// Go-free bootstrap. Kept as a local name so call sites below are
// untouched.
func bootstrapClarusc(t *testing.T) string {
	t.Helper()
	return claruscboot.CurrentExe(t)
}

// buildCoreCLI composes and compiles the core suite's CLI binary: kit.cla
// + core/runner.cla + core/cases_*.cla (one per family) + core/cli.cla
// (kit first by convention; clarusc's lowering pre-pass makes cross-file
// declaration order otherwise immaterial -- the plan's normative build
// composition).
func buildCoreCLI(t *testing.T) string {
	t.Helper()
	exe := bootstrapClarusc(t)
	root := repoRoot(t)
	work := t.TempDir()
	outC := filepath.Join(work, "core_cli.c")
	rtDir := filepath.Join(root, "runtime", "clarus") + string(filepath.Separator)

	files := []string{
		filepath.Join(root, "testsuite", "kit.cla"),
		filepath.Join(root, "testsuite", "core", "runner.cla"),
		filepath.Join(root, "testsuite", "core", "cases_str.cla"),
		filepath.Join(root, "testsuite", "core", "cases_text.cla"),
		filepath.Join(root, "testsuite", "core", "cases_list.cla"),
		filepath.Join(root, "testsuite", "core", "cases_map.cla"),
		filepath.Join(root, "testsuite", "core", "cases_sortedmap.cla"),
		filepath.Join(root, "testsuite", "core", "cases_intmap.cla"),
		filepath.Join(root, "testsuite", "core", "cases_rec.cla"),
		filepath.Join(root, "testsuite", "core", "cases_arr.cla"),
		filepath.Join(root, "testsuite", "core", "cases_enumfix.cla"),
		filepath.Join(root, "testsuite", "core", "cases_ser.cla"),
		filepath.Join(root, "testsuite", "core", "cases_misc.cla"),
		filepath.Join(root, "testsuite", "core", "cases_xrec.cla"),
		filepath.Join(root, "testsuite", "core", "cases_datetime.cla"),
		filepath.Join(root, "testsuite", "core", "cases_param.cla"),
		filepath.Join(root, "testsuite", "core", "cases_abort.cla"),
		filepath.Join(root, "testsuite", "core", "cases_textrange.cla"),
		filepath.Join(root, "testsuite", "core", "cases_errret.cla"),
		filepath.Join(root, "testsuite", "core", "cases_evalorder.cla"),
		filepath.Join(root, "testsuite", "core", "cli.cla"),
	}
	args := append([]string{"emit", "--rtdir", rtDir, "-o", outC}, files...)
	emit := exec.Command(exe, args...)
	if out, err := emit.CombinedOutput(); err != nil {
		t.Fatalf("clarusc emit core CLI: %v\n%s", err, out)
	}

	bin := filepath.Join(work, "core_cli")
	cc := exec.Command("cc", "-O1", "-I", filepath.Join(root, "runtime", "host"),
		outC, filepath.Join(root, "runtime", "host", "rt.c"), "-o", bin)
	if out, err := cc.CombinedOutput(); err != nil {
		t.Fatalf("cc compile core CLI: %v\n%s", err, out)
	}
	return bin
}

// runCoreCLI runs the built binary with argv and returns its exit code
// and stdout (the PASS/FAIL/TOTAL log -- see kit.cla's tkReport). Runs in
// a fresh temp cwd: the ser family (cases_ser.cla) does real file I/O
// (file.writeText/readText), and a temp cwd keeps its scratch files out
// of the repo tree -- same convention test_suite.cla's own header comment
// documents for its file-touching lib fixtures.
func runCoreCLI(t *testing.T, bin string, argv ...string) (exit int, stdout string) {
	t.Helper()
	cmd := exec.Command(bin, argv...)
	cmd.Dir = t.TempDir()
	var outBuf, errBuf bytes.Buffer
	cmd.Stdout = &outBuf
	cmd.Stderr = &errBuf
	if err := cmd.Run(); err != nil {
		ee, ok := err.(*exec.ExitError)
		if !ok {
			t.Fatalf("run core CLI: %v (stderr: %s)", err, errBuf.String())
		}
		exit = ee.ExitCode()
	}
	return exit, outBuf.String()
}

// coreLogLine is one parsed PASS/FAIL line from the suite's stdout.
type coreLogLine struct {
	name   string
	passed bool
	detail string
}

// parseCoreLog parses tkReport's log format: `PASS <name>` or
// `FAIL <name>: <detail>` lines, then a `TOTAL <n> PASS <p> FAIL <f>`
// summary line -- treated as an API per the plan's normative contract, not
// a loose scrape.
func parseCoreLog(t *testing.T, stdout string) (lines []coreLogLine, total, pass, fail int) {
	t.Helper()
	trimmed := strings.TrimRight(stdout, "\n")
	if trimmed == "" {
		t.Fatalf("empty stdout, expected at least a TOTAL line")
	}
	for _, line := range strings.Split(trimmed, "\n") {
		switch {
		case strings.HasPrefix(line, "PASS "):
			lines = append(lines, coreLogLine{name: strings.TrimPrefix(line, "PASS "), passed: true})
		case strings.HasPrefix(line, "FAIL "):
			rest := strings.TrimPrefix(line, "FAIL ")
			name, detail, _ := strings.Cut(rest, ": ")
			lines = append(lines, coreLogLine{name: name, passed: false, detail: detail})
		case strings.HasPrefix(line, "TOTAL "):
			fields := strings.Fields(line)
			if len(fields) != 6 {
				t.Fatalf("malformed TOTAL line %q", line)
			}
			var err error
			if total, err = strconv.Atoi(fields[1]); err != nil {
				t.Fatalf("bad TOTAL count in %q: %v", line, err)
			}
			if pass, err = strconv.Atoi(fields[3]); err != nil {
				t.Fatalf("bad PASS count in %q: %v", line, err)
			}
			if fail, err = strconv.Atoi(fields[5]); err != nil {
				t.Fatalf("bad FAIL count in %q: %v", line, err)
			}
		default:
			t.Fatalf("unrecognized log line %q", line)
		}
	}
	return lines, total, pass, fail
}

// TestCoreSuiteCLI builds the core suite's CLI and drives it three ways:
// `all` (every seed case, all PASS, TOTAL arithmetic checked), a single
// named case (exactly one case line), and an unknown name (FAIL line +
// nonzero exit, per the CLI's documented contract).
func TestCoreSuiteCLI(t *testing.T) {
	bin := buildCoreCLI(t)

	t.Run("all", func(t *testing.T) {
		exit, stdout := runCoreCLI(t, bin, "all")
		lines, total, pass, fail := parseCoreLog(t, stdout)

		if exit != 0 {
			t.Fatalf("expected exit 0, got %d\nstdout:\n%s", exit, stdout)
		}
		if fail != 0 {
			t.Fatalf("expected 0 fails, got %d\nstdout:\n%s", fail, stdout)
		}
		if total != len(lines) {
			t.Fatalf("TOTAL %d does not match %d parsed case lines", total, len(lines))
		}
		if pass+fail != total {
			t.Fatalf("TOTAL arithmetic: pass %d + fail %d != total %d", pass, fail, total)
		}

		wantCases := []string{
			"StrConcatClamp", "StrIndexing", "StrCompare", "ErrVarIsolation",
			"TextAppendStr", "TextWidenAssignability", "TextRealiasLocal", "TextSlicesIndexOfMiss", "TextAssignCompare", "TextAppendPerf",
			"ListPushCountFirstLast", "ListReassignRelease", "ListGlobalAliasNested", "ListForLoopVarAlias",
			"MapSetCount", "MapHasRemove", "MapOfListUpsert",
			"RecCopyIndependence", "RecFieldGlobalAlias",
			"ArrHolderElementStore",
			"EnumIntRoundTrip", "EnumSaveChoiceValue", "FixedMathOps", "ConstCaseLabel", "SwitchIntRange", "SwitchIntMultiLabel",
			"SerBinRoundtrip", "SerFileRoundtrip", "SerFileNameRoundtrip", "SerMixedScalarRec",
			"MiscArithBasic", "MiscBreakContWhile", "MiscCrc8Smbus", "MiscEmitArithAddMul", "MiscArithWrap32", "MiscEmitControlForRange", "MiscEmitFuncRecursion", "MiscMutRecEvenOdd", "MiscWhileCondText", "MiscWideProtoSumBoxMetrics", "MiscLongCondChain",
			"XRecFieldsRoundtrip",
			"SortedMapSetCount", "SortedMapHasRemove", "SortedMapOfListUpsert", "SortedMapIterOrder",
			"MapGrowRehash", "MapRemoveSwap", "MapIterComplete", "MapLongKeys",
			"IntMapSetCount", "IntMapHasRemove", "IntMapOfListUpsert", "IntMapGrowIter",
			"DurationStrShapes", "DateTimeStrVectors", "NowSanity",
			"ClearBasics",
			"ParamAliasGlobal", "ParamAliasHandle", "ParamBorrowChain", "ParamNestedCallArg", "ParamContainerElemArg",
			"AbortCatch", "AbortDeep", "AbortNested", "AbortReabort", "AbortRelease",
			"TextRange",
			"ListClone",
			"OnLog",
			"ErrReturn",
			"EvalOrder",
			"SelfCheck",
		}
		if len(lines) != len(wantCases) {
			t.Fatalf("expected %d cases, got %d: %+v", len(wantCases), len(lines), lines)
		}
		for i, name := range wantCases {
			if lines[i].name != name {
				t.Errorf("case %d: got %q, want %q", i, lines[i].name, name)
			}
			if !lines[i].passed {
				t.Errorf("case %s: FAIL %s", lines[i].name, lines[i].detail)
			}
		}
	})

	t.Run("single case", func(t *testing.T) {
		exit, stdout := runCoreCLI(t, bin, "StrIndexing")
		lines, total, pass, fail := parseCoreLog(t, stdout)

		if exit != 0 {
			t.Fatalf("expected exit 0, got %d\nstdout:\n%s", exit, stdout)
		}
		if len(lines) != 1 {
			t.Fatalf("expected exactly 1 case line, got %d: %+v", len(lines), lines)
		}
		if lines[0].name != "StrIndexing" || !lines[0].passed {
			t.Fatalf("got %+v, want PASS StrIndexing", lines[0])
		}
		if total != 1 || pass != 1 || fail != 0 {
			t.Fatalf("TOTAL line: got total=%d pass=%d fail=%d, want 1/1/0", total, pass, fail)
		}
	})

	t.Run("unknown case", func(t *testing.T) {
		exit, stdout := runCoreCLI(t, bin, "NotACase")
		lines, _, _, fail := parseCoreLog(t, stdout)

		if exit == 0 {
			t.Fatalf("expected nonzero exit for an unknown case, got 0\nstdout:\n%s", stdout)
		}
		if fail != 1 || len(lines) != 1 {
			t.Fatalf("expected exactly 1 FAIL line, got %+v", lines)
		}
		if lines[0].name != "NotACase" || lines[0].passed || lines[0].detail != "unknown test case" {
			t.Fatalf("got %+v, want FAIL NotACase: unknown test case", lines[0])
		}
	})
}
