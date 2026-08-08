// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

package mactest

import (
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"
	"testing"
	"time"
)

// parseBenchFiles is the compiler-shaped native benchmark's composition
// (peephole68k Task 2) -- clarusc's own lexer (lib/tok/lex; NOT
// ast/parse, see testdata/bench/parsebench.cla's own header comment for
// why the composition stops at the lexer) + toolbox/events.cla (for
// TickCount) + the bench app itself.
var parseBenchFiles = []string{
	filepath.Join("clarusc", "lib.cla"),
	filepath.Join("clarusc", "tok.cla"),
	filepath.Join("clarusc", "lex.cla"),
	filepath.Join("toolbox", "events.cla"),
	filepath.Join("testdata", "bench", "parsebench.cla"),
}

// buildParseBench68k builds testdata/bench/parsebench.cla's composition
// via `clarusc emit68k` directly (buildNativeClarusc's memoized
// current-source clarusc, the same in-test emit pattern native_test.go's
// buildNative68kUI uses) -- no Retro68/cmake/C, no --events (this is a
// non-UI App.launch boot, not a scripted-UI one).
func buildParseBench68k(t *testing.T) string {
	t.Helper()
	exe := buildNativeClarusc(t)
	bin := filepath.Join(t.TempDir(), "parsebench.bin")
	args := []string{"emit68k", "-o", bin}
	args = append(args, pkgRelFiles(parseBenchFiles)...)
	cmd := exec.Command(exe, args...)
	out, err := cmd.CombinedOutput()
	if err != nil {
		t.Fatalf("clarusc %s: %v\n%s", strings.Join(args, " "), err, out)
	}
	return bin
}

var benchLineRe = regexp.MustCompile(`BENCH (?:parse|lex) iters=\d+ ticks=(\d+)`)

// TestParseBench68k boots the compiler-shaped parse/lex benchmark
// (testdata/bench/parsebench.cla) on the native lane and LOGS the tick
// count. It is a measurement instrument, not a gate: it only fails on
// build/boot/protocol errors, never on the timing value. Run:
//
//	CLARUS_MAC_TESTS=1 CLARUS_BENCH68K=1 go test ./internal/mactest -run TestParseBench68k -count=1 -v
func TestParseBench68k(t *testing.T) {
	if os.Getenv("CLARUS_BENCH68K") == "" {
		t.Skip("set CLARUS_BENCH68K=1 (with CLARUS_MAC_TESTS=1) to run the parse benchmark")
	}
	requireMac(t)
	bin := buildParseBench68k(t)
	// 8 minutes, not the usual 5: measured directly (see
	// testdata/bench/parsebench.cla's own header comment), 10 lexAll
	// passes over benchSource() cost ~17175 ticks (~286s) in one boot --
	// close enough to a bare 5-minute budget, combined with the run-to-run
	// variance already observed on this hardware/emulator combination,
	// that a tighter timeout risked a spurious kill. This is a
	// measurement, not a pass/fail gate, so the extra headroom costs
	// nothing but wall-clock time on an already-gated (CLARUS_MAC_TESTS=1
	// CLARUS_BENCH68K=1), rarely-run test.
	out, _, exit := RunMac(t, bin, 8*time.Minute)
	if exit != 0 {
		t.Fatalf("bench app exited %d\n%s", exit, out)
	}
	m := benchLineRe.FindStringSubmatch(out)
	if m == nil {
		t.Fatalf("no BENCH line in output:\n%s", out)
	}
	t.Logf("parse benchmark: %s ticks", m[1])
}
