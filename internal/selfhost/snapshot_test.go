package selfhost

import (
	"bytes"
	"os"
	"testing"
)

// snapshotPath is the committed ground-floor bootstrap artifact: the C that
// clarusc emits for its own source (clarusc/main.cla), checked into the repo
// so clarusc can be rebuilt by `cc` alone -- no Go, no prior Clarus binary.
const snapshotPath = "../../clarusc/clarusc.c"

// readSnapshot reads the committed clarusc/clarusc.c.
func readSnapshot(t *testing.T) []byte {
	t.Helper()
	b, err := os.ReadFile(snapshotPath)
	if err != nil {
		t.Fatalf("read committed snapshot %s: %v", snapshotPath, err)
	}
	return b
}

// TestSnapshotBuilds proves the committed clarusc/clarusc.c ALONE reproduces
// a working clarusc: compile it (as committed, not a fresh emission) with cc
// + rt.c, then run the resulting binary as a checker over a small sample of
// the corpus (a diagnostic-bearing file and a clean one) and assert its
// stdout + exit code match the Go oracle exactly. No Go compiler and no
// prior Clarus binary are used anywhere in this test.
func TestSnapshotBuilds(t *testing.T) {
	snapshot := readSnapshot(t)
	bin := compileC(t, snapshot)

	files := []string{
		"../../testdata/diag/chk_undefined.cla",
		"../../testdata/diag/chk_typemismatch.cla",
		"../../testdata/valid/bookmarks.cla",
	}
	for _, f := range files {
		f := f
		t.Run(f, func(t *testing.T) {
			wantOut, wantCode := goCheck(f)
			gotOut, gotCode := runClarusc(t, bin, f)
			if gotOut != wantOut || gotCode != wantCode {
				t.Errorf("divergence on %s\n  go                (exit %d): %q\n  snapshot-built cc (exit %d): %q",
					f, wantCode, wantOut, gotCode, gotOut)
			}
		})
	}
}

// TestSnapshotCurrent guards against the committed clarusc/clarusc.c silently
// drifting from clarusc's own source: it must be byte-identical to what the
// Go-built clarusc emits for clarusc/main.cla right now (c2, memoized by
// selfBuiltClaruscC -- the same emission TestBootstrapFixedPoint pins). If
// clarusc/main.cla (or any module it includes) has changed, this fails with
// instructions to regenerate.
func TestSnapshotCurrent(t *testing.T) {
	// Unlike TestSnapshotBuilds (cc + goCheck's in-process Go frontend
	// oracle only), this test's "fresh" side is selfBuiltClaruscC, which
	// transitively calls buildClarusc -> build.Build -- the Go compiler's
	// build path, forking cc to produce a Go-built clarusc binary. That
	// makes it a Go lane despite living in this otherwise Go-free file; see
	// test-suite-review Task 6.
	requireGoCompiler(t)
	committed := readSnapshot(t)
	fresh := selfBuiltClaruscC(t)

	if !bytes.Equal(committed, fresh) {
		t.Fatalf(`clarusc/clarusc.c is stale: committed snapshot (%d bytes) != fresh emission (%d bytes).

The committed snapshot must always match what clarusc currently emits for
its own source. To regenerate it:

  go run ./cmd/clarus build -o /tmp/clarusc clarusc/main.cla
  /tmp/clarusc emit -o clarusc/clarusc.c clarusc/main.cla

Then commit the updated clarusc/clarusc.c.
%s`, len(committed), len(fresh), diffFirstDivergence(committed, fresh))
	}
}
