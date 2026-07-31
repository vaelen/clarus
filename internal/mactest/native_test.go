// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// native_test.go: native-5d Task 11's walking-skeleton milestone --
// TestHelloOn68k is the FIRST program ever booted on real (emulated) 68k
// hardware through `clarusc emit68k`, no C/Retro68/cmake step at all
// (unlike mac_test.go's TestSuiteOnMac/etc, which build via
// scripts/build-mac.sh's Retro68 pipeline over clarusc's own C emit).
// clarusc is built via the memoized buildClarusc() pattern (mirrors
// internal/cg68k/golden_test.go's own buildClarusc, itself mirroring
// internal/selfhost/differential_test.go's), then invoked directly with
// `emit68k -o hello.bin testdata/cg68k/hello.cla`, and the resulting
// .bin is run the same way mac_test.go's own RunMac/parseCapture already
// do for the Retro68 path -- the capture protocol (runtime/clarus/
// native.cla, ported from runtime/mac/rt_mac.c:83-253) is byte-identical
// either way.
package mactest

import (
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"sync"
	"testing"
	"time"

	"clarus/internal/build"
)

var (
	nativeClaruscOnce sync.Once
	nativeClaruscExe  string
	nativeClaruscErr  error
)

// buildNativeClarusc builds clarusc once per `go test` invocation (same
// memoization discipline as cg68k.golden_test.go's own buildClarusc --
// duplicated locally rather than exported cross-package for one caller,
// same call this repo's other near-duplicate helpers already made).
func buildNativeClarusc(t *testing.T) string {
	t.Helper()
	nativeClaruscOnce.Do(func() {
		dir, err := os.MkdirTemp("", "clarusc-native-*")
		if err != nil {
			nativeClaruscErr = err
			return
		}
		exe := filepath.Join(dir, "clarusc")
		diags, err := build.Build([]string{filepath.Join(repoRoot(t), "clarusc", "main.cla")}, exe)
		if err != nil {
			nativeClaruscErr = err
			return
		}
		if len(diags) > 0 {
			var b strings.Builder
			b.WriteString("clarusc build produced diagnostics:")
			for _, d := range diags {
				b.WriteString("\n  ")
				b.WriteString(d.String())
			}
			nativeClaruscErr = errString(b.String())
			return
		}
		nativeClaruscExe = exe
	})
	if nativeClaruscErr != nil {
		t.Fatal(nativeClaruscErr)
	}
	return nativeClaruscExe
}

type errString string

func (e errString) Error() string { return string(e) }

// TestHelloOn68k builds testdata/cg68k/hello.cla with `clarusc emit68k`
// and boots the result in the emulator -- the walking-skeleton milestone
// for native-5d's codegen68k wave. Asserts exit 0 and `out` == the
// natAlert-rendered "hello, 68k\n" (CR->LF + trailing LF over a message
// with no CR, so just the literal text plus one LF).
func TestHelloOn68k(t *testing.T) {
	requireMac(t)
	exe := buildNativeClarusc(t)

	runDir := t.TempDir()
	bin := filepath.Join(runDir, "hello.bin")
	fixture := filepath.Join(repoRoot(t), "testdata", "cg68k", "hello.cla")
	cmd := exec.Command(exe, "emit68k", "-o", bin, fixture)
	out, err := cmd.CombinedOutput()
	if err != nil {
		t.Fatalf("clarusc emit68k -o %s %s: %v\n%s", bin, fixture, err, out)
	}

	got, _, exitCode := RunMac(t, bin, 5*time.Minute)
	if exitCode != 0 {
		t.Fatalf("hello.cla exit code %d, want 0", exitCode)
	}
	want := "hello, 68k\n"
	if got != want {
		t.Fatalf("hello.cla output mismatch:%s", firstDiff(want, got))
	}
}

// TestNativeSmoke is native-5d Task 12's first native boot test to cover
// records/enums: builds testdata/cg68k/smoke.cla BOTH ways -- the host
// expectation via build.Build (the Go compiler, same as
// suite_host_test.go's BuildSuiteHost/RunSuiteHost -- smoke.cla is
// deliberately Go-compiler-compatible Clarus, no Ch13 surface, precisely
// so this comparison is possible), and the native image via `clarusc
// emit68k` -- then requires the emulator's captured `out` to be
// byte-identical to the host's stdout, and both exit codes to be 0.
func TestNativeSmoke(t *testing.T) {
	runNativeHostCompare(t, "smoke.cla")
}

// TestNativeStrContainers is native-5d Task 14.7's boot test for the
// gap-closure codegen classes (str-element containers, expression-position
// slice, materialized map key) -- testdata/cg68k/strcontainers.cla, its
// own file rather than a smoke.cla section because smoke.cla is at its
// single-segment PC-relative displacement ceiling (see the fixture's own
// header comment; Task 15's segmentation is the real fix).
func TestNativeStrContainers(t *testing.T) {
	runNativeHostCompare(t, "strcontainers.cla")
}

// runNativeHostCompare builds testdata/cg68k/<fixture> BOTH ways -- the
// host expectation via build.Build (the Go compiler, same as
// suite_host_test.go's BuildSuiteHost/RunSuiteHost -- these fixtures are
// deliberately Go-compiler-compatible Clarus, no Ch13 surface, precisely
// so this comparison is possible), and the native image via `clarusc
// emit68k` -- then requires the emulator's captured `out` to be
// byte-identical to the host's stdout, and both exit codes to be 0.
func runNativeHostCompare(t *testing.T, fixtureName string) {
	requireMac(t)
	fixture := filepath.Join(repoRoot(t), "testdata", "cg68k", fixtureName)

	hostExe := filepath.Join(t.TempDir(), "host")
	diags, err := build.Build([]string{fixture}, hostExe)
	if err != nil {
		t.Fatalf("build host %s: %v", fixtureName, err)
	}
	if len(diags) > 0 {
		var b strings.Builder
		b.WriteString("host build produced diagnostics:")
		for _, d := range diags {
			b.WriteString("\n  ")
			b.WriteString(d.String())
		}
		t.Fatal(b.String())
	}
	hostCmd := exec.Command(hostExe)
	hostCmd.Dir = t.TempDir()
	hostOut, err := hostCmd.Output()
	if err != nil {
		t.Fatalf("run host %s: %v", fixtureName, err)
	}
	want := string(hostOut)

	exe := buildNativeClarusc(t)
	runDir := t.TempDir()
	bin := filepath.Join(runDir, "native.bin")
	cmd := exec.Command(exe, "emit68k", "-o", bin, fixture)
	out, err := cmd.CombinedOutput()
	if err != nil {
		t.Fatalf("clarusc emit68k -o %s %s: %v\n%s", bin, fixture, err, out)
	}

	got, _, exitCode := RunMac(t, bin, 5*time.Minute)
	if exitCode != 0 {
		t.Fatalf("%s exit code %d, want 0", fixtureName, exitCode)
	}
	if got != want {
		t.Fatalf("%s output mismatch (native vs host):%s", fixtureName, firstDiff(want, got))
	}
}
