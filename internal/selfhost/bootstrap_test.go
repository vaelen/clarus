package selfhost

import (
	"bytes"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

// diffFirstDivergence returns a human-readable report of the first line at
// which a and b differ: the 1-based line number plus a few lines of context
// from each side. It exists so a bootstrap-fixed-point failure is
// debuggable ("here's what changed") rather than just "bytes differ".
func diffFirstDivergence(a, b []byte) string {
	linesA := bytes.Split(a, []byte("\n"))
	linesB := bytes.Split(b, []byte("\n"))
	n := len(linesA)
	if len(linesB) < n {
		n = len(linesB)
	}
	i := 0
	for i < n && bytes.Equal(linesA[i], linesB[i]) {
		i++
	}

	ctx := func(lines [][]byte, at int) string {
		lo, hi := at-2, at+3
		if lo < 0 {
			lo = 0
		}
		if hi > len(lines) {
			hi = len(lines)
		}
		var b strings.Builder
		for j := lo; j < hi; j++ {
			marker := "    "
			if j == at {
				marker = ">>> "
			}
			fmt.Fprintf(&b, "%s%5d: %s\n", marker, j+1, lines[j])
		}
		return b.String()
	}

	if i >= len(linesA) || i >= len(linesB) {
		return fmt.Sprintf("first divergence at line %d: one side ends early (c2 has %d lines, c3 has %d lines)\n--- c2 ---\n%s--- c3 ---\n%s",
			i+1, len(linesA), len(linesB), ctx(linesA, i), ctx(linesB, i))
	}
	return fmt.Sprintf("first divergence at line %d:\n--- c2 ---\n%s--- c3 ---\n%s",
		i+1, ctx(linesA, i), ctx(linesB, i))
}

// TestBootstrapFixedPoint is the crown of self-hosting: the three-stage
// bootstrap.
//
//	stage1 = clarusc built by the Go compiler (buildClarusc).
//	c2     = stage1's emitted C for clarusc's OWN source; stage2 = cc(c2 + rt.c).
//	c3     = stage2's emitted C for clarusc's OWN source; stage3 = cc(c3 + rt.c).
//
// stage1.c (were we to compute it) may legitimately differ from c2 -- c2 is
// already "stage1 emits stage2", memoized by selfBuiltClarusc/selfBuiltClaruscC
// (Task 10). The canonical assertion here is the NEXT step: c2 == c3
// byte-identical. Both c2 and c3 are produced by running the SAME emit path
// (clarusc emit) over the SAME source, once from a Go-built clarusc and once
// from a clarusc-built clarusc; if they match, the compiler has reached a
// fixed point under self-compilation. If they diverge, something real
// differs between the Go-built and self-built clarusc's emitted-code
// behavior, and this test reports the first differing line rather than
// papering over it.
func TestBootstrapFixedPoint(t *testing.T) {
	// stage1 -> c2 -> stage2 (memoized: this is exactly Task 10's self-build).
	stage2 := selfBuiltClarusc(t)
	c2 := selfBuiltClaruscC(t)

	// stage2 -> c3 -> stage3.
	c3 := emitC(t, stage2, "../../clarusc/main.cla")
	stage3 := compileC(t, c3) // built (not just emitted) to prove c3 compiles clean.

	if info, err := os.Stat(stage3); err != nil || info.Size() == 0 {
		t.Fatalf("stage3 binary missing or empty: %v", err)
	}

	if !bytes.Equal(c2, c3) {
		dir := t.TempDir()
		c2Path := filepath.Join(dir, "stage2.c")
		c3Path := filepath.Join(dir, "stage3.c")
		if err := os.WriteFile(c2Path, c2, 0o644); err != nil {
			t.Logf("write %s: %v", c2Path, err)
		}
		if err := os.WriteFile(c3Path, c3, 0o644); err != nil {
			t.Logf("write %s: %v", c3Path, err)
		}
		t.Fatalf("bootstrap fixed point FAILED: stage2.c (%d bytes, written to %s) != stage3.c (%d bytes, written to %s)\n%s",
			len(c2), c2Path, len(c3), c3Path, diffFirstDivergence(c2, c3))
	}

	t.Logf("bootstrap fixed point reached: c2 == c3 (%d bytes)", len(c2))
}

// TestSelfBuiltDifferential runs the full v1 diagnostic differential (the
// same corpus walk as TestDifferential in differential_test.go) against the
// SELF-BUILT (stage2) clarusc binary instead of the Go-built one. It proves
// the self-built clarusc is byte-exact over the whole corpus, not just the
// handful of files TestEmitSelfChecks spot-checks. The stage2 build is
// memoized (selfBuiltClarusc), so this is nearly free once any other test in
// the package has already triggered it. Gated behind -short since it's the
// full ~220-case corpus.
func TestSelfBuiltDifferential(t *testing.T) {
	if testing.Short() {
		t.Skip("full corpus differential against self-built clarusc; skipped in -short mode")
	}
	exe := selfBuiltClarusc(t)

	for _, f := range corpusFiles(t) {
		f := f
		t.Run(filepath.Base(f), func(t *testing.T) { diffOne(t, exe, f) })
	}
}
