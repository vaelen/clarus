// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// bakeidentity_test.go (runtime-ir-bake Task 4, widened Task 5): the
// loader's own T1 byte-identity gate -- `emit68k --rtbake` against a
// from-source `emit68k`, over a representative fixture slice, must
// produce byte-identical forks. Host-only (no emulator needed): both
// sides run entirely via claruscboot.CurrentExe's host binary.
//
// Fixture slice: tickprobe.cla + bounce.cla (the two window-declaring
// cg68k goldens named by the brief) plus arc.cla/clear_deep.cla/
// smoke.cla/strcontainers.cla (four more multi-segment cg68k fixtures)
// plus a self-compile (emit68k of clarusc/main.cla, comfortably multi-
// segment). This T1-tier slice predates Task 5's own inherited-problem
// fix (bake.cla's base/uitest lowering split + lower.cla's
// lowSkipUiDispatchers, task-5-report.md's fix rounds 1/2) and was
// chosen back when only multi-segment fixtures were known to match --
// that gap is closed now (TestBakeFullCorpusCg68k, gated behind
// CLARUS_BAKE_FULL=1, asserts pure identity across the FULL corpus,
// single-segment fixtures included, no allowlist), but this slice stays
// small/representative for T1's own runtime budget rather than growing
// to the full corpus by default.
package bake

import (
	"bytes"
	"os"
	"os/exec"
	"path/filepath"
	"testing"

	"clarus/internal/claruscboot"
)

// cg68kFixtures relative to the repo root (testdata/cg68k/), each
// verified (this task's own manual smoke pass) to need 2+ code segments
// -- see this file's own doc comment.
var cg68kFixtures = []string{
	"tickprobe.cla",
	"bounce.cla",
	"arc.cla",
	"clear_deep.cla",
	"smoke.cla",
	"strcontainers.cla",
}

// runEmit68k runs `clarusc emit68k -o outPath [--rtbake bakePath] entry`
// with cmd.Dir at the repo root (so the default --rtdir upward search
// finds runtime/clarus/, exactly like RunBakeIR does) and returns the
// written bytes.
func runEmit68k(t *testing.T, exe, entry, outPath, bakePath string) []byte {
	t.Helper()
	args := []string{"emit68k", "-o", outPath}
	if bakePath != "" {
		args = append(args, "--rtbake", bakePath)
	}
	args = append(args, entry)
	cmd := exec.Command(exe, args...)
	cmd.Dir = RepoRoot(t)
	out, err := cmd.CombinedOutput()
	if err != nil {
		t.Fatalf("clarusc %v: %v\n%s", args, err, out)
	}
	// runtime-ir-bake Task 5, fix round 3 (IMPORTANT 2): every fixture
	// reached through this helper is expected to take the REAL bake
	// path, not deliverable (b)'s own from-source fallback -- a silent
	// fallback would make the byte-identity assertion that follows this
	// call PASS VACUOUSLY (comparing from-source against a from-source
	// recompile, proving nothing about --rtbake itself). Fixtures that
	// deliberately trigger the fallback (the toolbox suite composition)
	// go through runSuiteEmit68k's own wantFallback parameter instead.
	if bakePath != "" && bytes.Contains(out, []byte("falling back")) {
		t.Fatalf("clarusc %v: unexpectedly fell back to from-source (deliverable (b)'s own fallback note) -- expected the real bake path:\n%s", args, out)
	}
	data, err := os.ReadFile(outPath)
	if err != nil {
		t.Fatalf("read %s: %v", outPath, err)
	}
	return data
}

// TestBakePathByteIdentity is the required gate: for every fixture in
// cg68kFixtures plus a self-compile, `emit68k --rtbake` must produce a
// byte-identical fork to plain from-source `emit68k`.
func TestBakePathByteIdentity(t *testing.T) {
	exe := claruscboot.CurrentExe(t)
	root := RepoRoot(t)
	dir := t.TempDir()
	bakePath := filepath.Join(dir, "rt68k.clir")
	RunBakeIR(t, exe, "68k", bakePath)

	entries := map[string]string{}
	for _, f := range cg68kFixtures {
		entries[f] = filepath.Join(root, "testdata", "cg68k", f)
	}
	entries["self-compile (main.cla)"] = "clarusc/main.cla"

	for name, entry := range entries {
		name, entry := name, entry
		t.Run(name, func(t *testing.T) {
			// Same basename in separate subdirectories, not distinct
			// basenames in one dir: the MacBinary wrap embeds the OUTPUT
			// FILENAME in its header (cg68WriteImageWrap), so two
			// differently-NAMED forks of identical code still differ
			// byte-for-byte in that field alone -- the exact false alarm
			// Task 2's own report already flagged and worked around the
			// same way.
			base := filepath.Base(entry)
			srcDir := filepath.Join(dir, "src-"+base)
			bakeDir := filepath.Join(dir, "bake-"+base)
			if err := os.MkdirAll(srcDir, 0o755); err != nil {
				t.Fatal(err)
			}
			if err := os.MkdirAll(bakeDir, 0o755); err != nil {
				t.Fatal(err)
			}
			srcOut := filepath.Join(srcDir, base+".bin")
			bakeOut := filepath.Join(bakeDir, base+".bin")
			srcData := runEmit68k(t, exe, entry, srcOut, "")
			bakeData := runEmit68k(t, exe, entry, bakeOut, bakePath)
			if !bytes.Equal(srcData, bakeData) {
				t.Fatalf("%s: --rtbake fork (%d bytes) != from-source fork (%d bytes)", entry, len(bakeData), len(srcData))
			}
		})
	}
}

// TestRtbakeConnFilehByteIdentity (binary-files phase, Task 9c) is the
// T1-speed regression for the bug Task 10's own T2 run found:
// `emit68k --rtbake` crashed clarusc (`runtime error: list index out of
// range`) for ANY program calling a `connection` or `filehandle` method,
// because `lower.cla`'s old `lowRtCoerceArg` looked up the target
// runtime function's param type by NAME through the checker's symbol
// table at lowering time -- a table `--rtbake` never populates for baked
// runtime functions (it skips their parse+check for performance). Fixed
// by `lowCoerceTo`, which takes the statically-known target IR type
// directly instead of looking anything up. This fixture exercises BOTH
// types and, between them, every one of lowConnMethod's/
// lowFileHandleMethod's seven lowCoerceTo call sites (open with a string
// spec; send with a string arg and a text arg; writeAt with a text arg
// and a string arg; append with a text arg and a string arg) -- unlike
// TestBakePathByteIdentity's own cg68kFixtures slice, none of which
// declares a `connection` or `filehandle`. Runs under plain `go test
// ./internal/bake` (NOT behind CLARUS_BAKE_FULL), so T1 catches this
// class next time, per the controller ruling on this bug.
func TestRtbakeConnFilehByteIdentity(t *testing.T) {
	exe := claruscboot.CurrentExe(t)
	dir := t.TempDir()
	bakePath := filepath.Join(dir, "rt68k.clir")
	RunBakeIR(t, exe, "68k", bakePath)

	fixturePath := filepath.Join(dir, "connfileh.cla")
	src := `var conn: connection

on App.startCLI(args: list of string) {
    var fh: filehandle
    var t: text

    conn.open(serial "modem:9600")
    conn.send("str payload")
    t = "text payload"
    conn.send(t)
    conn.close()

    fh = file.create("scratch.dat", "TEXT", "CLAR")
    fh.writeAt(0, "str payload")
    fh.writeAt(20, t)
    fh.append("str tail")
    fh.append(t)
    fh.close()
    quit 0
}
`
	if err := os.WriteFile(fixturePath, []byte(src), 0o644); err != nil {
		t.Fatal(err)
	}

	srcDir := filepath.Join(dir, "src-out")
	bakeDir := filepath.Join(dir, "bake-out")
	if err := os.MkdirAll(srcDir, 0o755); err != nil {
		t.Fatal(err)
	}
	if err := os.MkdirAll(bakeDir, 0o755); err != nil {
		t.Fatal(err)
	}
	srcOut := filepath.Join(srcDir, "connfileh.bin")
	bakeOut := filepath.Join(bakeDir, "connfileh.bin")
	srcData := runEmit68k(t, exe, fixturePath, srcOut, "")
	bakeData := runEmit68k(t, exe, fixturePath, bakeOut, bakePath)
	if !bytes.Equal(srcData, bakeData) {
		t.Fatalf("connfileh.cla: --rtbake fork (%d bytes) != from-source fork (%d bytes)", len(bakeData), len(srcData))
	}
}

// TestRtbakeCorruptStampRefused proves the loader refuses a bake whose
// stamp doesn't match the loading compiler's own recomputed hash: clear
// diagnostic, nonzero exit -- this task's open question (a)'s refusal
// contract.
func TestRtbakeCorruptStampRefused(t *testing.T) {
	exe := claruscboot.CurrentExe(t)
	dir := t.TempDir()
	corruptPath := CorruptStampFixture(t, exe, "68k", dir)

	cmd := exec.Command(exe, "emit68k", "--rtbake", corruptPath, "-o", filepath.Join(dir, "out.bin"), filepath.Join(RepoRoot(t), "testdata", "cg68k", "arith.cla"))
	cmd.Dir = RepoRoot(t)
	out, err := cmd.CombinedOutput()
	if err == nil {
		t.Fatalf("clarusc emit68k --rtbake <corrupt-stamp>: expected nonzero exit, got success\n%s", out)
	}
	if !bytes.Contains(out, []byte("stamp mismatch")) {
		t.Fatalf("expected a clear stamp-mismatch diagnostic, got:\n%s", out)
	}
}

// TestRtbakeCorruptBodyRefused proves the loader refuses a bake whose
// BODY (past the header -- module manifest or any IR section) was
// corrupted, via the format-v4 bodyHash check (final-review fix wave):
// clear diagnostic, nonzero exit. The header fields (magic/version/lane/
// stamp) all still match here -- only a body byte changed -- so this
// proves the new check catches a corruption class the pre-v4 header
// check couldn't. The CLI (host lane) is what this test exercises
// directly; on the Mac lane, the SAME bkCheckRtbakeHeader call is what
// macgui.cla's gcResolveBakePath runs before ever setting haveRtbake, so
// the same corrupted body there is classified as an ordinary logged
// fallback (structural via bkCheckRtbakeHeader), not a hard compile
// failure -- not independently exercised by this Go-side test, which has
// no Mac lane to boot.
func TestRtbakeCorruptBodyRefused(t *testing.T) {
	exe := claruscboot.CurrentExe(t)
	dir := t.TempDir()
	corruptPath := CorruptBodyFixture(t, exe, "68k", dir)

	cmd := exec.Command(exe, "emit68k", "--rtbake", corruptPath, "-o", filepath.Join(dir, "out.bin"), filepath.Join(RepoRoot(t), "testdata", "cg68k", "arith.cla"))
	cmd.Dir = RepoRoot(t)
	out, err := cmd.CombinedOutput()
	if err == nil {
		t.Fatalf("clarusc emit68k --rtbake <corrupt-body>: expected nonzero exit, got success\n%s", out)
	}
	if !bytes.Contains(out, []byte("body hash mismatch")) {
		t.Fatalf("expected a clear body-hash-mismatch diagnostic, got:\n%s", out)
	}
}

// TestRtbakeCorruptObjCodeRefused proves the loader refuses a
// STRUCTURALLY-VALID bake whose object-code section (bkSecObjCode,
// object-code-linker Task 2) carries an out-of-range reloc symbol: clear
// diagnostic, nonzero exit -- Task 2's own new bkObjRelocSymValid check,
// not the pre-existing v4 body-hash check (CorruptObjCodeFixture
// recomputes the body hash after corrupting, deliberately, so this test
// cannot pass vacuously via TestRtbakeCorruptBodyRefused's own generic
// mismatch path).
func TestRtbakeCorruptObjCodeRefused(t *testing.T) {
	exe := claruscboot.CurrentExe(t)
	dir := t.TempDir()
	corruptPath := CorruptObjCodeFixture(t, exe, dir)

	cmd := exec.Command(exe, "emit68k", "--rtbake", corruptPath, "-o", filepath.Join(dir, "out.bin"), filepath.Join(RepoRoot(t), "testdata", "cg68k", "arith.cla"))
	cmd.Dir = RepoRoot(t)
	out, err := cmd.CombinedOutput()
	if err == nil {
		t.Fatalf("clarusc emit68k --rtbake <corrupt-objcode>: expected nonzero exit, got success\n%s", out)
	}
	if bytes.Contains(out, []byte("body hash mismatch")) {
		t.Fatalf("refused via the generic body-hash check, not the reloc-symbol check -- CorruptObjCodeFixture's own hash recompute did not take effect:\n%s", out)
	}
	if !bytes.Contains(out, []byte("object-code section")) || !bytes.Contains(out, []byte("out of range")) {
		t.Fatalf("expected a clear object-code reloc-symbol-out-of-range diagnostic, got:\n%s", out)
	}
}

// TestRtbakeLaneMismatchRefused proves the loader refuses a bake built
// for the wrong lane (a c-lane bake fed to emit68k) -- the controller's
// own resolution ("wrong lane = refused-stamp-class error with a clear
// message").
func TestRtbakeLaneMismatchRefused(t *testing.T) {
	exe := claruscboot.CurrentExe(t)
	dir := t.TempDir()
	cBakePath := filepath.Join(dir, "rtc.clir")
	RunBakeIR(t, exe, "c", cBakePath)

	cmd := exec.Command(exe, "emit68k", "--rtbake", cBakePath, "-o", filepath.Join(dir, "out.bin"), filepath.Join(RepoRoot(t), "testdata", "cg68k", "arith.cla"))
	cmd.Dir = RepoRoot(t)
	out, err := cmd.CombinedOutput()
	if err == nil {
		t.Fatalf("clarusc emit68k --rtbake <c-lane bake>: expected nonzero exit, got success\n%s", out)
	}
	if !bytes.Contains(out, []byte("lane mismatch")) {
		t.Fatalf("expected a clear lane-mismatch diagnostic, got:\n%s", out)
	}
}

// testapiFixture (runtime-ir-bake Task 5, deliverable (a)): a small UI
// program that both declares a window (driveEarlySplice's own
// isUiProgram gate, from-source) and actually CALLS a UiTest* function --
// tickprobe.cla (Task 4's own required fixture) declares a window but
// never calls UiTest*, which is why it never exercised the checker-symbol
// preload's own FuncSig/type-index handling (found the hard way: a
// baked-but-uninstalled `string`-typed param crashed the checker with an
// out-of-range typeArena index until bkInstallTypeArenaPrefix was added).
const testapiFixtureSrc = `app TestapiFixture {
    name: "TestapiFixture"
    version: "1.0"
    author: "Andrew C. Young <andrew@vaelen.org>"
    about: "runtime-ir-bake Task 5 testapi fixture."
    id: "TAPI"
}

window Probe {
    title: "TestapiFixture"
    size: 300, 120
}

on App.launch {
    open Probe
}

extend Probe {
    on opened {
        UiTestVerb("click Foo")
    }
}
`

func writeTestapiFixture(t *testing.T, dir string) string {
	t.Helper()
	path := filepath.Join(dir, "testapi_fixture.cla")
	if err := os.WriteFile(path, []byte(testapiFixtureSrc), 0o644); err != nil {
		t.Fatalf("write %s: %v", path, err)
	}
	return path
}

// TestRtbakeTestapiPositive proves --rtbake + --testapi compiles a
// program that legitimately names UiTest* (runtime-ir-bake Task 5,
// deliverable (a) -- Task 4's own refusal is gone). Functional-only here
// (compiles cleanly, exit 0, non-trivial output) -- TestBakeFullCorpus
// Testapi (CLARUS_BAKE_FULL=1) is the byte-identity counterpart, fix
// round 2's own gate.
func TestRtbakeTestapiPositive(t *testing.T) {
	exe := claruscboot.CurrentExe(t)
	dir := t.TempDir()
	bakePath := filepath.Join(dir, "rt68k.clir")
	RunBakeIR(t, exe, "68k", bakePath)
	fixture := writeTestapiFixture(t, dir)

	outPath := filepath.Join(dir, "out.bin")
	cmd := exec.Command(exe, "emit68k", "--rtbake", bakePath, "--testapi", "-o", outPath, fixture)
	cmd.Dir = RepoRoot(t)
	out, err := cmd.CombinedOutput()
	if err != nil {
		t.Fatalf("clarusc emit68k --rtbake --testapi: unexpected failure: %v\n%s", err, out)
	}
	data, err := os.ReadFile(outPath)
	if err != nil {
		t.Fatalf("read %s: %v", outPath, err)
	}
	if len(data) < 1024 {
		t.Fatalf("--rtbake --testapi output suspiciously small: %d bytes", len(data))
	}
}

// TestRtbakeTestapiNegative proves the OTHER half of deliverable (a): a
// NON-testapi compile naming a UiTest* runtime symbol errors EXACTLY like
// a from-source non-testapi compile does (undefined name, check#1 -- no
// runtime symbol is ever visible without --testapi, on EITHER path) --
// the "and ONLY testapi does" half of the brief's own framing.
func TestRtbakeTestapiNegative(t *testing.T) {
	exe := claruscboot.CurrentExe(t)
	dir := t.TempDir()
	bakePath := filepath.Join(dir, "rt68k.clir")
	RunBakeIR(t, exe, "68k", bakePath)

	src := "func main() {\n    UiTestVerb(\"click Foo\")\n}\n"
	fixture := filepath.Join(dir, "neg.cla")
	if err := os.WriteFile(fixture, []byte(src), 0o644); err != nil {
		t.Fatal(err)
	}

	srcCmd := exec.Command(exe, "emit68k", "-o", filepath.Join(dir, "src.bin"), fixture)
	srcCmd.Dir = RepoRoot(t)
	srcOut, srcErr := srcCmd.CombinedOutput()
	if srcErr == nil {
		t.Fatalf("from-source non-testapi naming UiTestVerb: expected failure, got success\n%s", srcOut)
	}

	bakeCmd := exec.Command(exe, "emit68k", "--rtbake", bakePath, "-o", filepath.Join(dir, "bake.bin"), fixture)
	bakeCmd.Dir = RepoRoot(t)
	bakeOut, bakeErr := bakeCmd.CombinedOutput()
	if bakeErr == nil {
		t.Fatalf("--rtbake non-testapi naming UiTestVerb: expected failure, got success\n%s", bakeOut)
	}

	const want = "undefined: UiTestVerb"
	if !bytes.Contains(srcOut, []byte(want)) {
		t.Fatalf("from-source diagnostic missing %q:\n%s", want, srcOut)
	}
	if !bytes.Contains(bakeOut, []byte(want)) {
		t.Fatalf("--rtbake diagnostic missing %q:\n%s", want, bakeOut)
	}
}

// TestRtbakeTestapiManifestOnlyNegative (fix round 2's own required
// negative test): a --testapi program naming a MANIFEST-ONLY module's
// own internal (sortedmapKeySlot, runtime/clarus/sortedmap.cla -- one of
// the four modules driveManifestSplice only ever splices for check#2,
// retired on the bake path, never for check#1) must error identically
// under --rtbake and from-source, EVEN THOUGH testapi's own preload now
// covers the full thirteen early-spliced modules (fix round 2's own
// widening) -- proving that widening stayed correctly scoped: the four
// manifest-only modules stay invisible to check#1 on BOTH paths, exactly
// like a from-source --testapi compile (whose own check#1 never splices
// them either).
func TestRtbakeTestapiManifestOnlyNegative(t *testing.T) {
	exe := claruscboot.CurrentExe(t)
	dir := t.TempDir()
	bakePath := filepath.Join(dir, "rt68k.clir")
	RunBakeIR(t, exe, "68k", bakePath)

	src := `app ManifestInternalTest {
    name: "ManifestInternalTest"
    version: "1.0"
    author: "Andrew C. Young <andrew@vaelen.org>"
    about: "testapi manifest-only-internal negative fixture."
    id: "MFIT"
}

window Probe {
    title: "ManifestInternalTest"
    size: 300, 120
}

on App.launch {
    open Probe
}

extend Probe {
    on opened {
        sortedmapKeySlot(0, 0)
    }
}
`
	fixture := filepath.Join(dir, "manifest_internal.cla")
	if err := os.WriteFile(fixture, []byte(src), 0o644); err != nil {
		t.Fatal(err)
	}

	srcCmd := exec.Command(exe, "emit68k", "--testapi", "-o", filepath.Join(dir, "src.bin"), fixture)
	srcCmd.Dir = RepoRoot(t)
	srcOut, srcErr := srcCmd.CombinedOutput()
	if srcErr == nil {
		t.Fatalf("from-source --testapi naming sortedmapKeySlot: expected failure, got success\n%s", srcOut)
	}

	bakeCmd := exec.Command(exe, "emit68k", "--rtbake", bakePath, "--testapi", "-o", filepath.Join(dir, "bake.bin"), fixture)
	bakeCmd.Dir = RepoRoot(t)
	bakeOut, bakeErr := bakeCmd.CombinedOutput()
	if bakeErr == nil {
		t.Fatalf("--rtbake --testapi naming sortedmapKeySlot: expected failure, got success\n%s", bakeOut)
	}

	const want = "undefined: sortedmapKeySlot"
	if !bytes.Contains(srcOut, []byte(want)) {
		t.Fatalf("from-source diagnostic missing %q:\n%s", want, srcOut)
	}
	if !bytes.Contains(bakeOut, []byte(want)) {
		t.Fatalf("--rtbake diagnostic missing %q:\n%s", want, bakeOut)
	}
}

// TestRtbakeTestapiNonUiNegative (fix round 3, CRITICAL 1's own required
// negative test): a NON-UI --testapi program naming UiTestVerb must
// error identically under --rtbake and from-source -- from-source only
// ever splices the early runtime (uitest.cla included) for a UI program
// (driveEarlySplice's own isUiProgram gate), so a non-UI --testapi
// program naming UiTestVerb is `undefined` there regardless of testapi;
// the bake path's own testapi branch used to install checker visibility
// unconditionally on `testapi` alone (driveIsUiProgram, drive.cla, now
// gates it identically on both paths).
func TestRtbakeTestapiNonUiNegative(t *testing.T) {
	exe := claruscboot.CurrentExe(t)
	dir := t.TempDir()
	bakePath := filepath.Join(dir, "rt68k.clir")
	RunBakeIR(t, exe, "68k", bakePath)

	src := "func main() {\n    UiTestVerb(\"click Foo\")\n}\n"
	fixture := filepath.Join(dir, "nonui.cla")
	if err := os.WriteFile(fixture, []byte(src), 0o644); err != nil {
		t.Fatal(err)
	}

	srcCmd := exec.Command(exe, "emit68k", "--testapi", "-o", filepath.Join(dir, "src.bin"), fixture)
	srcCmd.Dir = RepoRoot(t)
	srcOut, srcErr := srcCmd.CombinedOutput()
	if srcErr == nil {
		t.Fatalf("from-source --testapi (non-UI) naming UiTestVerb: expected failure, got success\n%s", srcOut)
	}

	bakeCmd := exec.Command(exe, "emit68k", "--rtbake", bakePath, "--testapi", "-o", filepath.Join(dir, "bake.bin"), fixture)
	bakeCmd.Dir = RepoRoot(t)
	bakeOut, bakeErr := bakeCmd.CombinedOutput()
	if bakeErr == nil {
		t.Fatalf("--rtbake --testapi (non-UI) naming UiTestVerb: expected failure, got success\n%s", bakeOut)
	}

	const want = "undefined: UiTestVerb"
	if !bytes.Contains(srcOut, []byte(want)) {
		t.Fatalf("from-source diagnostic missing %q:\n%s", want, srcOut)
	}
	if !bytes.Contains(bakeOut, []byte(want)) {
		t.Fatalf("--rtbake diagnostic missing %q:\n%s", want, bakeOut)
	}
}

// TestRtbakeTestapiCollisionParity (deliverable (c), corrected in fix
// round 2): a --testapi program that itself DECLARES a top-level
// `UiTestVerb` collides with the preloaded checker symbol -- round 1's
// own version of this test asserted the resulting diagnostic names
// uitest.cla (the baked runtime file); that assumption was WRONG,
// verified by direct comparison against from-source's own real output
// for the identical fixture: from-source's own check#1 declares the
// early-spliced modules FIRST (driveEarlySplice) and user code SECOND,
// so scopeDeclare's own "first declared, in this scope, keeps it" rule
// attributes the "redeclaration of X" diagnostic to the USER's file, at
// the user's own collision line -- NEVER to the runtime file, for this
// specific collision direction, on EITHER path. Fix round 2's own
// bkInstallCheckerSymbolsForTestapi (bake.cla) runs its preload BEFORE
// the user's own checkPhase1 too, so the bake path now produces the
// EXACT SAME "redeclaration of X" diagnostic, at the exact same user
// file:line, as from-source -- this test asserts that parity directly
// (byte-identical diagnostic text) rather than a hardcoded (and, it
// turns out, incorrect) assumption about which file gets named.
//
// (Deliverable (c)'s own broader claim -- SOME diagnostic naming a baked
// runtime file, proving the retained declFileTab table has a real
// consumer -- has no organically-reachable trigger on the bake path
// after this correction: check#1 never walks a baked runtime decl node
// at all, only the user's own chain, so curPathIdx never naturally
// becomes a runtime path during a --testapi compile. See task-5-
// report.md's fix round 2 section.)
func TestRtbakeTestapiCollisionParity(t *testing.T) {
	exe := claruscboot.CurrentExe(t)
	dir := t.TempDir()
	bakePath := filepath.Join(dir, "rt68k.clir")
	RunBakeIR(t, exe, "68k", bakePath)

	src := `app CollideTest {
    name: "CollideTest"
    version: "1.0"
    author: "Andrew C. Young <andrew@vaelen.org>"
    about: "forced redeclaration fixture."
    id: "CLTS"
}

window Probe {
    title: "CollideTest"
    size: 300, 120
}

on App.launch {
    open Probe
}

func UiTestVerb(x: int): bool {
    return true
}
`
	fixture := filepath.Join(dir, "collide.cla")
	if err := os.WriteFile(fixture, []byte(src), 0o644); err != nil {
		t.Fatal(err)
	}

	srcCmd := exec.Command(exe, "emit68k", "--testapi", "-o", filepath.Join(dir, "src.bin"), fixture)
	srcCmd.Dir = RepoRoot(t)
	srcOut, srcErr := srcCmd.CombinedOutput()
	if srcErr == nil {
		t.Fatalf("from-source: expected the redeclaration to fail the compile, got success\n%s", srcOut)
	}

	bakeCmd := exec.Command(exe, "emit68k", "--rtbake", bakePath, "--testapi", "-o", filepath.Join(dir, "bake.bin"), fixture)
	bakeCmd.Dir = RepoRoot(t)
	bakeOut, bakeErr := bakeCmd.CombinedOutput()
	if bakeErr == nil {
		t.Fatalf("--rtbake: expected the redeclaration to fail the compile, got success\n%s", bakeOut)
	}

	const want = "collide.cla:18:1: redeclaration of UiTestVerb"
	if !bytes.Contains(srcOut, []byte(want)) {
		t.Fatalf("from-source diagnostic missing %q:\n%s", want, srcOut)
	}
	if !bytes.Contains(bakeOut, []byte(want)) {
		t.Fatalf("--rtbake diagnostic missing %q:\n%s", want, bakeOut)
	}
}

// TestRtbakeIncludeCheckOnly (was TestRtbakeIncludeDedupFallback,
// deliverable (b); renamed by fallback-trigger-narrowing Task 2): a user
// file that directly `include`s a baked runtime module (a bare
// "runtime/clarus/core.cla" path, matching the bake's own module-key
// manifest -- bkComputeManifestPaths, bake.cla) USED to trigger an
// unconditional from-source fallback for the whole compile
// (bkManifestHoistHit). Task 2's drift guard narrows that: the on-disk
// file is unmodified, so its hash matches the baked copy's own
// (bkManifestHashes), and non-testapi has no preloaded checker symbols
// to collide with -- the compile now takes the real check-only-include
// bake path (no "falling back" note at all) and stays byte-identical to
// a plain from-source compile of the same fixture, same as before, just
// without the extra recompile.
//
// Two subtests (fallback-trigger-narrowing Task 3, Step 2): "CoreCla" is
// the original fixture, a top-level runtime module with real
// funcs/globals/strlits. "ToolboxFiles" is a nested-include catalog file
// (toolbox/files.cla, reached only via runtime/clarus/uidialogs.cla's own
// `include`) -- Task 1's own probe fixture (task-1-report.md Step 1),
// calling PBGetFInfoSync. toolbox/files.cla is pure extern/record
// declarations (no func/var bodies), so this exercises a check-only
// include shape CoreCla's own funcs/globals/strlits don't: a collision
// target with a real call site but zero lowered bodies of its own. Both
// subtests must stay byte-identical to from-source with no fallback note.
var rtbakeIncludeCheckOnlyFixtures = []struct {
	name string
	file string
	src  string
}{
	{
		name: "CoreCla",
		file: "checkonly_fixture_core.cla",
		src:  "include \"runtime/clarus/core.cla\"\n\nfunc main() {\n    log(\"hello from the dedup fallback fixture\")\n}\n",
	},
	{
		name: "ToolboxFiles",
		file: "checkonly_fixture_toolbox_files.cla",
		src:  "include \"toolbox/files.cla\"\n\nfunc main() {\n    var pb: ptr\n    var r: int\n    r = PBGetFInfoSync(pb)\n}\n",
	},
}

func TestRtbakeIncludeCheckOnly(t *testing.T) {
	exe := claruscboot.CurrentExe(t)
	root := RepoRoot(t)
	dir := t.TempDir()
	bakePath := filepath.Join(dir, "rt68k.clir")
	RunBakeIR(t, exe, "68k", bakePath)

	for _, fx := range rtbakeIncludeCheckOnlyFixtures {
		fx := fx
		t.Run(fx.name, func(t *testing.T) {
			// The include path is repo-root-relative (cmd.Dir = root,
			// matching every other fixture in this file), so the fixture
			// itself must also live at the repo root for the relative
			// include to resolve exactly the way an ordinary user file's
			// own would.
			fixturePath := filepath.Join(root, fx.file)
			if err := os.WriteFile(fixturePath, []byte(fx.src), 0o644); err != nil {
				t.Fatal(err)
			}
			t.Cleanup(func() { os.Remove(fixturePath) })

			// Same basename in separate subdirectories -- NOT distinct
			// basenames in one dir: the MacBinary wrap embeds the OUTPUT
			// FILENAME in its header, so two differently-named forks of
			// identical code differ byte-for-byte in that field alone
			// (TestBakePathByteIdentity's own doc comment already flags
			// this exact false alarm).
			srcDir := filepath.Join(dir, "src-"+fx.name)
			bakeDir := filepath.Join(dir, "bake-"+fx.name)
			if err := os.MkdirAll(srcDir, 0o755); err != nil {
				t.Fatal(err)
			}
			if err := os.MkdirAll(bakeDir, 0o755); err != nil {
				t.Fatal(err)
			}
			srcOut := filepath.Join(srcDir, "dedup.bin")
			bakeOut := filepath.Join(bakeDir, "dedup.bin")

			srcCmd := exec.Command(exe, "emit68k", "-o", srcOut, fx.file)
			srcCmd.Dir = root
			if out, err := srcCmd.CombinedOutput(); err != nil {
				t.Fatalf("from-source compile of %s failed: %v\n%s", fx.file, err, out)
			}

			bakeCmd := exec.Command(exe, "emit68k", "--rtbake", bakePath, "-o", bakeOut, fx.file)
			bakeCmd.Dir = root
			bakeOutput, err := bakeCmd.CombinedOutput()
			if err != nil {
				t.Fatalf("--rtbake compile of %s failed: %v\n%s", fx.file, err, bakeOutput)
			}
			if bytes.Contains(bakeOutput, []byte("falling back")) {
				t.Fatalf("--rtbake compile of %s: unexpectedly fell back to from-source (Task 2's check-only include should have kept the real bake path):\n%s", fx.file, bakeOutput)
			}

			srcData, err := os.ReadFile(srcOut)
			if err != nil {
				t.Fatal(err)
			}
			bakeData, err := os.ReadFile(bakeOut)
			if err != nil {
				t.Fatal(err)
			}
			if !bytes.Equal(srcData, bakeData) {
				t.Fatalf("--rtbake compile (%d bytes) != from-source compile (%d bytes) of %s", len(bakeData), len(srcData), fx.file)
			}
		})
	}
}

// TestRtbakeIncludeCheckOnlyUndefinedExternNegative (fallback-trigger-
// narrowing Task 3, Step 2's own negative twin; symbols swapped in fix
// round 1, review Important #1): a fixture that includes toolbox/
// files.cla (a real manifest collision, hash-equal, check-only include)
// but references SFGetFile/SFReply -- both declared in toolbox/
// standardfile.cla, a DIFFERENT nested include reached via the SAME
// early-spliced module (runtime/clarus/uidialogs.cla `include`s both
// toolbox/standardfile.cla and toolbox/files.cla, uidialogs.cla:10-11) --
// must still error identically on both paths. round 1's own original
// version referenced a name (PBFakeSyncNotInCatalog) declared nowhere in
// the bake at all, so it could only fail if the compiler stopped
// reporting undefined names outright; it could never have caught a bake
// bug that leaked toolbox/standardfile.cla's OWN baked visibility into a
// files.cla-only compile. SFGetFile IS in the bake (nested include, same
// as toolbox/files.cla) but NOT in toolbox/files.cla, so a check-only
// include that accidentally widened visibility to its own SIBLING
// manifest module would compile this where from-source errors. SFReply
// (an extern record, referenced here as a var's type) is the sharper
// half aimed at the field-info visibility gap Task 2's own review
// flagged as a deferred minor (bkInstallFieldInfo installs
// recFieldsHeadByName for every baked record, standardfile.cla's SFReply
// included, with no visibility gate) -- record types/fields are exactly
// what that install touches.
func TestRtbakeIncludeCheckOnlyUndefinedExternNegative(t *testing.T) {
	exe := claruscboot.CurrentExe(t)
	root := RepoRoot(t)
	dir := t.TempDir()
	bakePath := filepath.Join(dir, "rt68k.clir")
	RunBakeIR(t, exe, "68k", bakePath)

	fixtureName := "checkonly_undefined_extern_fixture.cla"
	fixturePath := filepath.Join(root, fixtureName)
	src := "include \"toolbox/files.cla\"\n\nfunc main() {\n    var pb: ptr\n    var r: int\n    var reply: SFReply\n    r = PBGetFInfoSync(pb)\n    SFGetFile(pb)\n}\n"
	if err := os.WriteFile(fixturePath, []byte(src), 0o644); err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { os.Remove(fixturePath) })

	srcCmd := exec.Command(exe, "emit68k", "-o", filepath.Join(dir, "src.bin"), fixtureName)
	srcCmd.Dir = root
	srcOut, srcErr := srcCmd.CombinedOutput()
	if srcErr == nil {
		t.Fatalf("from-source: referencing SFReply/SFGetFile (declared only in toolbox/standardfile.cla, not toolbox/files.cla): expected failure, got success\n%s", srcOut)
	}

	bakeCmd := exec.Command(exe, "emit68k", "--rtbake", bakePath, "-o", filepath.Join(dir, "bake.bin"), fixtureName)
	bakeCmd.Dir = root
	bakeOut, bakeErr := bakeCmd.CombinedOutput()
	if bakeErr == nil {
		t.Fatalf("--rtbake: referencing SFReply/SFGetFile (declared only in toolbox/standardfile.cla, not toolbox/files.cla): expected failure, got success\n%s", bakeOut)
	}

	wants := []string{"undefined: SFReply", "undefined: SFGetFile"}
	for _, want := range wants {
		if !bytes.Contains(srcOut, []byte(want)) {
			t.Fatalf("from-source diagnostic missing %q:\n%s", want, srcOut)
		}
		if !bytes.Contains(bakeOut, []byte(want)) {
			t.Fatalf("--rtbake diagnostic missing %q:\n%s", want, bakeOut)
		}
	}
}

// copyTree recursively copies src (a directory) to dst, creating dst and
// any needed subdirectories -- used by TestRtbakeDriftFallback to build a
// private, mutable copy of runtime/clarus + toolbox so its drift mutation
// never touches anything git tracks.
func copyTree(t *testing.T, src, dst string) {
	t.Helper()
	err := filepath.Walk(src, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		rel, err := filepath.Rel(src, path)
		if err != nil {
			return err
		}
		target := filepath.Join(dst, rel)
		if info.IsDir() {
			return os.MkdirAll(target, 0o755)
		}
		data, err := os.ReadFile(path)
		if err != nil {
			return err
		}
		return os.WriteFile(target, data, 0o644)
	})
	if err != nil {
		t.Fatalf("copyTree(%s, %s): %v", src, dst, err)
	}
}

// TestRtbakeDriftFallback (fallback-trigger-narrowing Task 3, Step 3):
// proves the drift guard itself -- when the on-disk copy of a manifest
// path no longer matches the hash baked into the CLIR artifact, --rtbake
// falls back to a from-source compile for that ONE compile, naming the
// drifted file in its own log line (drive.cla's haveRtbake branch; design
// doc's "Drift guard" section). Bakes from a PRIVATE temp copy of
// runtime/clarus/ + toolbox/ (via --rtdir at bake time) so the mutation
// never touches anything git tracks. No --rtdir override is needed at
// COMPILE time: toolbox/files.cla is a NESTED include (reached only via
// runtime/clarus/uidialogs.cla's own `include`), so its manifest-path
// identity comes from the baked declFileTab's own VERBATIM bake-time
// string (bkComputeManifestPaths' second loop, bake.cla) -- not a
// compile-time rtDir recomputation -- and the drift fixture's own
// `include "toolbox/files.cla"` resolves to that exact same string
// because the fixture itself is placed at the SAME tmpRoot the bake's own
// --rtdir pointed into.
func TestRtbakeDriftFallback(t *testing.T) {
	exe := claruscboot.CurrentExe(t)
	root := RepoRoot(t)
	tmpRoot := t.TempDir()

	copyTree(t, filepath.Join(root, "runtime", "clarus"), filepath.Join(tmpRoot, "runtime", "clarus"))
	copyTree(t, filepath.Join(root, "toolbox"), filepath.Join(tmpRoot, "toolbox"))

	rtDir := filepath.Join(tmpRoot, "runtime", "clarus")
	bakePath := filepath.Join(tmpRoot, "rt68k.clir")
	bakeIrCmd := exec.Command(exe, "--bake-ir", "--lane", "68k", "-o", bakePath, "--rtdir", rtDir)
	bakeIrCmd.Dir = root
	if out, err := bakeIrCmd.CombinedOutput(); err != nil {
		t.Fatalf("--bake-ir --rtdir %s: %v\n%s", rtDir, err, out)
	}

	// Append a comment byte AFTER baking -- the baked hash reflects the
	// pre-mutation bytes, so this is genuine drift.
	toolboxFilesPath := filepath.Join(tmpRoot, "toolbox", "files.cla")
	f, err := os.OpenFile(toolboxFilesPath, os.O_APPEND|os.O_WRONLY, 0o644)
	if err != nil {
		t.Fatal(err)
	}
	if _, err := f.WriteString("// drift marker (Task 3 fixture)\n"); err != nil {
		f.Close()
		t.Fatal(err)
	}
	if err := f.Close(); err != nil {
		t.Fatal(err)
	}

	fixturePath := filepath.Join(tmpRoot, "drift_fixture.cla")
	src := "include \"toolbox/files.cla\"\n\nfunc main() {\n    var pb: ptr\n    var r: int\n    r = PBGetFInfoSync(pb)\n}\n"
	if err := os.WriteFile(fixturePath, []byte(src), 0o644); err != nil {
		t.Fatal(err)
	}

	wantLog := "clarusc --rtbake: " + toolboxFilesPath + " differs from the baked copy; falling back to a from-source compile"

	bakeDir := filepath.Join(tmpRoot, "bake-out")
	srcOutDir := filepath.Join(tmpRoot, "src-out")
	if err := os.MkdirAll(bakeDir, 0o755); err != nil {
		t.Fatal(err)
	}
	if err := os.MkdirAll(srcOutDir, 0o755); err != nil {
		t.Fatal(err)
	}
	bakeOut := filepath.Join(bakeDir, "drift.bin")
	srcOut := filepath.Join(srcOutDir, "drift.bin")

	bakeCmd := exec.Command(exe, "emit68k", "--rtbake", bakePath, "-o", bakeOut, fixturePath)
	bakeCmd.Dir = root
	bakeOutput, err := bakeCmd.CombinedOutput()
	if err != nil {
		t.Fatalf("--rtbake compile of the drifted fixture failed: %v\n%s", err, bakeOutput)
	}
	if !bytes.Contains(bakeOutput, []byte(wantLog)) {
		t.Fatalf("expected the drift log line\n  %s\ngot:\n%s", wantLog, bakeOutput)
	}

	srcCmd := exec.Command(exe, "emit68k", "-o", srcOut, fixturePath)
	srcCmd.Dir = root
	if out, err := srcCmd.CombinedOutput(); err != nil {
		t.Fatalf("plain from-source compile of the drifted tree failed: %v\n%s", err, out)
	}

	bakeData, err := os.ReadFile(bakeOut)
	if err != nil {
		t.Fatal(err)
	}
	srcData, err := os.ReadFile(srcOut)
	if err != nil {
		t.Fatal(err)
	}
	if !bytes.Equal(bakeData, srcData) {
		t.Fatalf("--rtbake fallback compile (%d bytes) != plain from-source compile (%d bytes) of the same drifted tree", len(bakeData), len(srcData))
	}
}

// testapiIncludeParityFixtureSrc (fallback-trigger-narrowing Task 3, Step
// 4): a --testapi UI program that directly `include`s toolbox/files.cla --
// early-visible for EVERY testapi UI build (uidialogs.cla, one of the 13
// early-spliced modules, itself `include`s toolbox/files.cla -- see
// bake.cla's own bkComputeManifestPaths doc comment) -- and calls one of
// its externs. Under Task 2's mechanism this is case (b): hash-equal +
// early-visible -> full dedup, matching from-source's own post-dedup
// state, so this must compile clean and byte-identical on both paths, NOT
// produce Task 1's own verbatim "redeclaration of ..." diagnostic block
// (task-1-report.md Step 4). That block is what an UNFIXED testapi build
// would have shown (Task 1's own probe hack disabled the real dedup to
// prove it was necessary); with Task 2's fix in place, a hash-matched +
// early-visible collision is structurally routed around checkPhase1
// entirely (drive.cla's earlySkip / driveRebuildChainSkipping), so there
// is no organically-reachable trigger for that diagnostic here -- the
// same conclusion TestRtbakeTestapiCollisionParity's own doc comment
// already reached for the analogous uitest.cla case.
const testapiIncludeParityFixtureSrc = `include "toolbox/files.cla"

app TestapiIncludeParity {
    name: "TestapiIncludeParity"
    version: "1.0"
    author: "Andrew C. Young <andrew@vaelen.org>"
    about: "fallback-trigger-narrowing Task 3 testapi include-collision parity fixture."
    id: "TIPF"
}

window Probe {
    title: "TestapiIncludeParity"
    size: 300, 120
}

on App.launch {
    open Probe
}

extend Probe {
    on opened {
        var pb: ptr
        var r: int
        r = PBGetFInfoSync(pb)
    }
}
`

func TestRtbakeTestapiIncludeParity(t *testing.T) {
	exe := claruscboot.CurrentExe(t)
	root := RepoRoot(t)
	dir := t.TempDir()
	bakePath := filepath.Join(dir, "rt68k.clir")
	RunBakeIR(t, exe, "68k", bakePath)

	// Repo-root-relative `include "toolbox/files.cla"` -- the fixture
	// itself must live at the repo root for that relative include to
	// resolve, same reasoning as TestRtbakeIncludeCheckOnly's own
	// fixtures above (dir+incName joins against the FIXTURE's own
	// location, not cmd.Dir).
	fixtureName := "testapi_include_parity_fixture.cla"
	fixture := filepath.Join(root, fixtureName)
	if err := os.WriteFile(fixture, []byte(testapiIncludeParityFixtureSrc), 0o644); err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { os.Remove(fixture) })

	srcDir := filepath.Join(dir, "src")
	bakeDir := filepath.Join(dir, "bake")
	if err := os.MkdirAll(srcDir, 0o755); err != nil {
		t.Fatal(err)
	}
	if err := os.MkdirAll(bakeDir, 0o755); err != nil {
		t.Fatal(err)
	}
	srcOut := filepath.Join(srcDir, "parity.bin")
	bakeOut := filepath.Join(bakeDir, "parity.bin")

	srcCmd := exec.Command(exe, "emit68k", "--testapi", "-o", srcOut, fixtureName)
	srcCmd.Dir = root
	srcOutput, err := srcCmd.CombinedOutput()
	if err != nil {
		t.Fatalf("from-source --testapi build of the include-collision fixture failed: %v\n%s", err, srcOutput)
	}

	bakeCmd := exec.Command(exe, "emit68k", "--testapi", "--rtbake", bakePath, "-o", bakeOut, fixtureName)
	bakeCmd.Dir = root
	bakeOutput, err := bakeCmd.CombinedOutput()
	if err != nil {
		t.Fatalf("--rtbake --testapi build of the include-collision fixture failed: %v\n%s", err, bakeOutput)
	}
	if bytes.Contains(bakeOutput, []byte("falling back")) {
		t.Fatalf("--rtbake --testapi include-collision fixture: unexpectedly fell back to from-source (case (b) full dedup should have kept the real bake path):\n%s", bakeOutput)
	}

	srcData, err := os.ReadFile(srcOut)
	if err != nil {
		t.Fatal(err)
	}
	bakeData, err := os.ReadFile(bakeOut)
	if err != nil {
		t.Fatal(err)
	}
	if !bytes.Equal(srcData, bakeData) {
		t.Fatalf("--rtbake --testapi include-collision fork (%d bytes) != from-source fork (%d bytes)", len(bakeData), len(srcData))
	}
}

// testapiManifestOnlyParityFixtureSrc (deferred minor from Task 2's own
// review, added per the fallback-trigger-narrowing Task 3 brief's ledger
// note): a --testapi UI program that directly `include`s a MANIFEST-ONLY
// module (runtime/clarus/sortedmap.cla -- one of the four modules
// driveManifestSplice only ever splices for check#2, never for check#1's
// own testapi preload; see TestRtbakeTestapiManifestOnlyNegative above)
// is a genuinely new combination: every OTHER manifest-collision fixture
// in this file either collides on an EARLY-VISIBLE path (case (b), full
// dedup -- TestBakeFullCorpusSuiteToolbox, TestRtbakeTestapiIncludeParity
// above) or is non-testapi (case (a), check-only include --
// TestRtbakeIncludeCheckOnly above). This is case (a) UNDER testapi:
// bkManifestEarlyVisible["runtime/clarus/sortedmap.cla"] is false (past
// bkGenEarlyVisibleAsmHeadsBoundary), so the collision stays check-only
// regardless of --testapi -- which exercises, for the first time, the
// field-info install boundary Task 2's own report flagged as a deferred
// minor (bkInstallFieldInfo installs recFieldsHeadByName for ALL baked
// records, manifest-only ones included, with no visibility gate):
// sortedmap.cla declares its own record (RtSortedMap) whose fields get
// installed wholesale BEFORE checkPhase1 runs, then the user's own
// check-only copy declares the SAME record again during checkPhase1. Must
// stay clean and byte-identical to from-source on both paths, same as any
// other case-(a) collision.
const testapiManifestOnlyParityFixtureSrc = `include "runtime/clarus/sortedmap.cla"

app ManifestIncludeParity {
    name: "ManifestIncludeParity"
    version: "1.0"
    author: "Andrew C. Young <andrew@vaelen.org>"
    about: "fallback-trigger-narrowing Task 3 testapi manifest-only include parity fixture."
    id: "MIPF"
}

window Probe {
    title: "ManifestIncludeParity"
    size: 300, 120
}

on App.launch {
    open Probe
}

extend Probe {
    on opened {
        var m: ptr
        sortedmapKeySlot(m, 0)
    }
}
`

func TestRtbakeTestapiManifestOnlyIncludeParity(t *testing.T) {
	exe := claruscboot.CurrentExe(t)
	root := RepoRoot(t)
	dir := t.TempDir()
	bakePath := filepath.Join(dir, "rt68k.clir")
	RunBakeIR(t, exe, "68k", bakePath)

	// Repo-root-relative `include "runtime/clarus/sortedmap.cla"` -- same
	// repo-root placement requirement as TestRtbakeTestapiIncludeParity
	// above.
	fixtureName := "manifest_include_parity_fixture.cla"
	fixture := filepath.Join(root, fixtureName)
	if err := os.WriteFile(fixture, []byte(testapiManifestOnlyParityFixtureSrc), 0o644); err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { os.Remove(fixture) })

	srcDir := filepath.Join(dir, "src")
	bakeDir := filepath.Join(dir, "bake")
	if err := os.MkdirAll(srcDir, 0o755); err != nil {
		t.Fatal(err)
	}
	if err := os.MkdirAll(bakeDir, 0o755); err != nil {
		t.Fatal(err)
	}
	srcOut := filepath.Join(srcDir, "parity.bin")
	bakeOut := filepath.Join(bakeDir, "parity.bin")

	srcCmd := exec.Command(exe, "emit68k", "--testapi", "-o", srcOut, fixtureName)
	srcCmd.Dir = root
	srcOutput, err := srcCmd.CombinedOutput()
	if err != nil {
		t.Fatalf("from-source --testapi build of the manifest-only include fixture failed: %v\n%s", err, srcOutput)
	}

	bakeCmd := exec.Command(exe, "emit68k", "--testapi", "--rtbake", bakePath, "-o", bakeOut, fixtureName)
	bakeCmd.Dir = root
	bakeOutput, err := bakeCmd.CombinedOutput()
	if err != nil {
		t.Fatalf("--rtbake --testapi build of the manifest-only include fixture failed: %v\n%s", err, bakeOutput)
	}
	if bytes.Contains(bakeOutput, []byte("falling back")) {
		t.Fatalf("--rtbake --testapi manifest-only include fixture: unexpectedly fell back to from-source (case (a) check-only include should have kept the real bake path):\n%s", bakeOutput)
	}

	srcData, err := os.ReadFile(srcOut)
	if err != nil {
		t.Fatal(err)
	}
	bakeData, err := os.ReadFile(bakeOut)
	if err != nil {
		t.Fatal(err)
	}
	if !bytes.Equal(srcData, bakeData) {
		t.Fatalf("--rtbake --testapi manifest-only include fork (%d bytes) != from-source fork (%d bytes)", len(bakeData), len(srcData))
	}
}

// ================================================================
// Full-corpus gate (runtime-ir-bake Task 5, deliverable (e)). The T1-tier
// default above (cg68kFixtures, 6 multi-segment fixtures + self-compile)
// stays small/representative; the FULL sweep below runs only under
// CLARUS_BAKE_FULL=1 (wired into scripts/test-merge.sh's own T2
// environment -- see that script's own comment block).
//
// Fix round 1 (dispatcher panic-string position) and fix round 2 (testapi
// splice ordering) together closed BOTH divergence classes this gate
// originally found and had to allowlist around -- see task-5-report.md's
// own "fix round" section for the root causes and the two structural
// fixes (bake.cla's lowSkipUiDispatchers gate; drive.cla's
// driveManifestSplice reassembling combined2 from three separately-
// tracked chains for testapi instead of driveEarlySplice's own check#1-
// oriented order). There is no allowlist any more: every fixture below
// is asserted to match, full stop -- a clean oracle needs no exceptions.
var cg68kAllFixtures = []string{
	"abort_bake.cla", "arc.cla", "argmat_intr.cla", "argmat_nested.cla", "arith.cla", "arr_whole_assign.cla",
	"bigtmp16.cla", "bounce.cla", "callback.cla", "calls.cla", "clear_deep.cla",
	"control.cla", "enums.cla", "gapclose3.cla", "globals.cla", "inline_a5.cla", "mutrec.cla",
	"peep_clr.cla", "peep_pushpop.cla", "peep_quick.cla", "peep_shuffle.cla", "recs.cla",
	"regnamed.cla", "smalltmp_ceiling.cla", "smoke.cla", "strcontainers.cla", "strs.cla",
	"tickprobe.cla", "traps.cla", "xrec.cla",
}

func requireBakeFull(t *testing.T) {
	t.Helper()
	if os.Getenv("CLARUS_BAKE_FULL") != "1" {
		t.Skip("set CLARUS_BAKE_FULL=1 to run the exhaustive full-corpus gate (runtime-ir-bake Task 5, deliverable (e)); the T1-tier default (TestBakePathByteIdentity) already covers a representative slice")
	}
}

// TestBakeFullCorpusCg68k is the exhaustive counterpart of
// TestBakePathByteIdentity: every testdata/cg68k/*.cla fixture, single-
// or multi-segment, must be byte-identical -- no allowlist.
func TestBakeFullCorpusCg68k(t *testing.T) {
	requireBakeFull(t)
	exe := claruscboot.CurrentExe(t)
	root := RepoRoot(t)
	dir := t.TempDir()
	bakePath := filepath.Join(dir, "rt68k.clir")
	RunBakeIR(t, exe, "68k", bakePath)

	for _, base := range cg68kAllFixtures {
		base := base
		t.Run(base, func(t *testing.T) {
			entry := filepath.Join(root, "testdata", "cg68k", base)
			srcDir := filepath.Join(dir, "src-"+base)
			bakeDir := filepath.Join(dir, "bake-"+base)
			os.MkdirAll(srcDir, 0o755)
			os.MkdirAll(bakeDir, 0o755)
			srcOut := filepath.Join(srcDir, base+".bin")
			bakeOut := filepath.Join(bakeDir, base+".bin")
			srcData := runEmit68k(t, exe, entry, srcOut, "")
			bakeData := runEmit68k(t, exe, entry, bakeOut, bakePath)
			if !bytes.Equal(srcData, bakeData) {
				t.Fatalf("%s: --rtbake fork (%d bytes) != from-source fork (%d bytes)", base, len(bakeData), len(srcData))
			}
		})
	}
}

// TestBakeFullCorpusSelfCompile exhaustively re-proves self-compile
// identity (already in the T1 slice, kept here too for a single
// "CLARUS_BAKE_FULL=1 covers everything" entry point).
func TestBakeFullCorpusSelfCompile(t *testing.T) {
	requireBakeFull(t)
	exe := claruscboot.CurrentExe(t)
	dir := t.TempDir()
	bakePath := filepath.Join(dir, "rt68k.clir")
	RunBakeIR(t, exe, "68k", bakePath)

	srcDir := filepath.Join(dir, "src")
	bakeDir := filepath.Join(dir, "bake")
	os.MkdirAll(srcDir, 0o755)
	os.MkdirAll(bakeDir, 0o755)
	srcOut := filepath.Join(srcDir, "main.bin")
	bakeOut := filepath.Join(bakeDir, "main.bin")
	srcData := runEmit68k(t, exe, "clarusc/main.cla", srcOut, "")
	bakeData := runEmit68k(t, exe, "clarusc/main.cla", bakeOut, bakePath)
	if !bytes.Equal(srcData, bakeData) {
		t.Fatalf("self-compile: --rtbake fork (%d bytes) != from-source fork (%d bytes)", len(bakeData), len(srcData))
	}
}

// TestBakeFullCorpusEmitui is deliverable (d)'s own gate: `emit --rtbake`
// (C lane, --bake-ir --lane c) against from-source `emit`, over the
// FULL emitui corpus -- no allowlist (fix rounds 1/2 closed both
// divergence classes this gate originally found). Fixtures that error
// identically on both sides (a parse/check-diagnostic fixture, e.g.
// err_const_at.cla) are skipped -- there is no COMPILED OUTPUT to
// compare for those; both sides already share internal/emitui's own
// diagnostic-text golden coverage.
func TestBakeFullCorpusEmitui(t *testing.T) {
	requireBakeFull(t)
	exe := claruscboot.CurrentExe(t)
	root := RepoRoot(t)
	dir := t.TempDir()
	bakePath := filepath.Join(dir, "rtc.clir")
	RunBakeIR(t, exe, "c", bakePath)

	fixtures, err := filepath.Glob(filepath.Join(root, "testdata", "emitui", "*.cla"))
	if err != nil || len(fixtures) == 0 {
		t.Fatalf("glob testdata/emitui/*.cla: %v (%d matches)", err, len(fixtures))
	}

	for _, entry := range fixtures {
		base := filepath.Base(entry)
		t.Run(base, func(t *testing.T) {
			srcOutPath := filepath.Join(dir, "src-"+base+".c")
			bakeOutPath := filepath.Join(dir, "bake-"+base+".c")
			srcCmd := exec.Command(exe, "emit", "--rtdir", "runtime/clarus/", "-o", srcOutPath, entry)
			srcCmd.Dir = root
			_, srcErr := srcCmd.CombinedOutput()
			bakeCmd := exec.Command(exe, "emit", "--rtdir", "runtime/clarus/", "--rtbake", bakePath, "-o", bakeOutPath, entry)
			bakeCmd.Dir = root
			_, bakeErr := bakeCmd.CombinedOutput()
			if (srcErr == nil) != (bakeErr == nil) {
				t.Fatalf("%s: exit mismatch (from-source err=%v, bake err=%v)", base, srcErr, bakeErr)
			}
			if srcErr != nil {
				t.Skip("fixture errors identically on both sides -- no compiled output to compare")
			}
			srcData, err1 := os.ReadFile(srcOutPath)
			bakeData, err2 := os.ReadFile(bakeOutPath)
			if err1 != nil || err2 != nil {
				t.Fatalf("%s: read output: %v / %v", base, err1, err2)
			}
			if !bytes.Equal(srcData, bakeData) {
				t.Fatalf("%s: --rtbake fork (%d bytes) != from-source fork (%d bytes)", base, len(bakeData), len(srcData))
			}
		})
	}
}

// TestBakeFullCorpusTestapi (deliverable (a), fix round 2): a --testapi
// program's `emit68k --rtbake` output must now be byte-identical to
// from-source --testapi -- fix round 2 (driveManifestSplice reassembling
// combined2 from three separately-tracked chains: the early runtime
// modules, the manifest-splice remainder, and uitest.cla, in exactly the
// bake's own fixed order) closed the ordering gap deliverable (a)'s own
// first-round report flagged as unresolved.
func TestBakeFullCorpusTestapi(t *testing.T) {
	requireBakeFull(t)
	exe := claruscboot.CurrentExe(t)
	dir := t.TempDir()
	bakePath := filepath.Join(dir, "rt68k.clir")
	RunBakeIR(t, exe, "68k", bakePath)
	fixture := writeTestapiFixture(t, dir)

	srcDir := filepath.Join(dir, "src")
	bakeDir := filepath.Join(dir, "bake")
	os.MkdirAll(srcDir, 0o755)
	os.MkdirAll(bakeDir, 0o755)
	srcOut := filepath.Join(srcDir, "testapi.bin")
	bakeOut := filepath.Join(bakeDir, "testapi.bin")

	srcCmd := exec.Command(exe, "emit68k", "--rtdir", "runtime/clarus/", "--testapi", "-o", srcOut, fixture)
	srcCmd.Dir = RepoRoot(t)
	if out, err := srcCmd.CombinedOutput(); err != nil {
		t.Fatalf("from-source --testapi build failed: %v\n%s", err, out)
	}
	bakeCmd := exec.Command(exe, "emit68k", "--rtdir", "runtime/clarus/", "--testapi", "--rtbake", bakePath, "-o", bakeOut, fixture)
	bakeCmd.Dir = RepoRoot(t)
	if out, err := bakeCmd.CombinedOutput(); err != nil {
		t.Fatalf("--rtbake --testapi build failed: %v\n%s", err, out)
	}

	srcData, err := os.ReadFile(srcOut)
	if err != nil {
		t.Fatal(err)
	}
	bakeData, err := os.ReadFile(bakeOut)
	if err != nil {
		t.Fatal(err)
	}
	if !bytes.Equal(srcData, bakeData) {
		t.Fatalf("--rtbake --testapi fork (%d bytes) != from-source --testapi fork (%d bytes)", len(bakeData), len(srcData))
	}
}

// TestBakeFullCorpusTestapiNonUI (fix round 3, CRITICAL 1): the sibling
// of TestBakeFullCorpusTestapi (which uses a window-declaring fixture)
// for a NON-UI --testapi program -- reviewer-reproduced divergence:
// from-source only ever makes testapi's early-spliced runtime visible to
// a UI program (driveEarlySplice's own isUiProgram gate), but the bake
// path's own testapi branch used to install checker/IR testapi
// visibility unconditionally on `testapi` alone, so a non-UI --testapi
// build (arith.cla, an ordinary testdata/cg68k fixture -- no window/
// menu/every) diverged: 486 bytes differing, 33152 vs 33024. Fixed by
// driveIsUiProgram (drive.cla, hoisted out of driveEarlySplice's own
// inline scan) gating both bkInstallTypeArenaPrefix/bkInstallChecker
// SymbolsForTestapi (the check-time install) and bkInstallArenas' own
// testapi argument (the IR-truncation install) on `testapi and
// isUiProg`, not `testapi` alone.
func TestBakeFullCorpusTestapiNonUI(t *testing.T) {
	requireBakeFull(t)
	exe := claruscboot.CurrentExe(t)
	root := RepoRoot(t)
	dir := t.TempDir()
	bakePath := filepath.Join(dir, "rt68k.clir")
	RunBakeIR(t, exe, "68k", bakePath)

	entry := filepath.Join(root, "testdata", "cg68k", "arith.cla")
	srcDir := filepath.Join(dir, "src")
	bakeDir := filepath.Join(dir, "bake")
	os.MkdirAll(srcDir, 0o755)
	os.MkdirAll(bakeDir, 0o755)
	srcOut := filepath.Join(srcDir, "arith.bin")
	bakeOut := filepath.Join(bakeDir, "arith.bin")

	srcCmd := exec.Command(exe, "emit68k", "--testapi", "-o", srcOut, entry)
	srcCmd.Dir = root
	if out, err := srcCmd.CombinedOutput(); err != nil {
		t.Fatalf("from-source --testapi build (non-UI) failed: %v\n%s", err, out)
	}
	bakeCmd := exec.Command(exe, "emit68k", "--testapi", "--rtbake", bakePath, "-o", bakeOut, entry)
	bakeCmd.Dir = root
	bakeOutput, err := bakeCmd.CombinedOutput()
	if err != nil {
		t.Fatalf("--rtbake --testapi build (non-UI) failed: %v\n%s", err, bakeOutput)
	}
	if bytes.Contains(bakeOutput, []byte("falling back")) {
		t.Fatalf("--rtbake --testapi (non-UI): unexpectedly fell back to from-source:\n%s", bakeOutput)
	}

	srcData, err := os.ReadFile(srcOut)
	if err != nil {
		t.Fatal(err)
	}
	bakeData, err := os.ReadFile(bakeOut)
	if err != nil {
		t.Fatal(err)
	}
	if !bytes.Equal(srcData, bakeData) {
		t.Fatalf("--rtbake --testapi (non-UI) fork (%d bytes) != from-source --testapi (non-UI) fork (%d bytes)", len(bakeData), len(srcData))
	}
}

// suiteFiles mirror internal/mactest's own coreCLIFiles/toolboxFiles +
// their own gui.cla front end (coreGUIFiles/toolboxFiles there) --
// duplicated here rather than imported (internal/mactest doesn't export
// them, and pulling a test-only package as a real import would be an
// odd dependency direction) since both suites' --testapi gui.cla builds
// are exactly the byte-identity gate deliverable (e) asks for (host
// emit68k, no emulator boot needed). Keep in sync with internal/mactest/
// suite_host_test.go's coreCLIFiles and coresuite_test.go's
// toolboxFiles if either changes.
var coreSuiteGUIFiles = []string{
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
	// runner.cla (above) unconditionally calls caseTextRange(), so any
	// composition that includes runner.cla but omits this file fails to
	// CHECK at all. Known consequence: this list drives a native emit68k
	// build (runSuiteEmit68k below), and cg68k.cla has no arms yet for the
	// new bulk-range-read intrinsics -- clir-load-perf Task 3's job,
	// deliberately out of THIS task's scope. Accepted/expected until Task
	// 3 lands cg68k support.
	filepath.Join("testsuite", "core", "cases_textrange.cla"),
	// correctness-cleanup Task 6: cases_errret.cla MUST be here -- runner.cla
	// (above) unconditionally calls caseErrReturn().
	filepath.Join("testsuite", "core", "cases_errret.cla"),
	// correctness-cleanup Task 7: cases_evalorder.cla MUST be here --
	// runner.cla (above) unconditionally calls caseEvalOrder().
	filepath.Join("testsuite", "core", "cases_evalorder.cla"),
	// binary-files phase Task 3: cases_textbinary.cla MUST be here --
	// runner.cla (above) unconditionally calls caseTextBinary()/
	// caseCrc16()/caseIntToStr().
	filepath.Join("testsuite", "core", "cases_textbinary.cla"),
	// binary-files phase Task 5: cases_fileh.cla MUST be here -- runner.cla
	// (above) unconditionally calls caseFileHandleRW(). Known consequence,
	// same shape as cases_textrange.cla's own comment above: `filehandle`'s
	// runtime is host-lane-only until Task 6 lands fileh_68k.cla (drive.cla
	// gates fileh.cla/fileh_c.cla on `not want68k`, by design -- see
	// runtime/clarus/fileh.cla's header comment), so a NATIVE emit68k
	// composition that reaches caseFileHandleRW()'s rtFh* calls has no
	// runtime to resolve them against yet. This list itself is only
	// exercised by CLARUS_BAKE_FULL=1 (requireBakeFull, skipped by
	// default) and CLARUS_MAC_TESTS=1 (TestCoreSuiteGUIOn68k/OnMac,
	// coresuite_test.go's own coreGUIFiles, derived from coreCLIFiles) --
	// both opt-in, neither part of T1 (scripts/test-task.sh) -- so this is
	// accepted/expected until Task 6, not a T1 regression.
	filepath.Join("testsuite", "core", "cases_fileh.cla"),
	filepath.Join("testsuite", "core", "gui.cla"),
}

var toolboxSuiteGUIFiles = []string{
	filepath.Join("testsuite", "kit.cla"),
	filepath.Join("toolbox", "memory.cla"),
	filepath.Join("toolbox", "events.cla"),
	filepath.Join("toolbox", "osutils.cla"),
	filepath.Join("toolbox", "scrap.cla"),
	filepath.Join("toolbox", "files.cla"),
	filepath.Join("toolbox", "resources.cla"),
	filepath.Join("toolbox", "devices.cla"),
	filepath.Join("toolbox", "serial.cla"),
	filepath.Join("testsuite", "toolbox", "runner.cla"),
	filepath.Join("testsuite", "toolbox", "cases_events.cla"),
	filepath.Join("testsuite", "toolbox", "cases_draw.cla"),
	filepath.Join("testsuite", "toolbox", "cases_a5.cla"),
	filepath.Join("testsuite", "toolbox", "cases_gestalt.cla"),
	filepath.Join("testsuite", "toolbox", "cases_event.cla"),
	filepath.Join("testsuite", "toolbox", "harness.cla"),
	filepath.Join("testsuite", "toolbox", "cases_uitest.cla"),
	filepath.Join("testsuite", "toolbox", "cases_pattern.cla"),
	filepath.Join("testsuite", "toolbox", "cases_buttons.cla"),
	filepath.Join("testsuite", "toolbox", "cases_winvar.cla"),
	filepath.Join("testsuite", "toolbox", "cases_textwidgets.cla"),
	filepath.Join("testsuite", "toolbox", "cases_menus.cla"),
	filepath.Join("testsuite", "toolbox", "cases_editmenu.cla"),
	filepath.Join("testsuite", "toolbox", "cases_canvas.cla"),
	filepath.Join("testsuite", "toolbox", "cases_zoomwin.cla"),
	filepath.Join("testsuite", "toolbox", "cases_hscroll.cla"),
	filepath.Join("testsuite", "toolbox", "cases_popuptable.cla"),
	filepath.Join("testsuite", "toolbox", "cases_dialogs.cla"),
	filepath.Join("testsuite", "toolbox", "cases_hdim.cla"),
	filepath.Join("testsuite", "toolbox", "cases_formedit.cla"),
	filepath.Join("testsuite", "toolbox", "cases_bigtext.cla"),
	filepath.Join("testsuite", "toolbox", "cases_catalog.cla"),
	filepath.Join("testsuite", "toolbox", "cases_finfo.cla"),
	filepath.Join("testsuite", "toolbox", "cases_resources.cla"),
	filepath.Join("testsuite", "toolbox", "cases_datetime.cla"),
	filepath.Join("testsuite", "toolbox", "cases_serial.cla"),
	filepath.Join("testsuite", "toolbox", "cases_narrowpopup.cla"),
	filepath.Join("testsuite", "toolbox", "gui.cla"),
}

// runSuiteEmit68k runs `clarusc emit68k --testapi [--rtbake bakePath] -o
// outPath FILES...` (both suites' gui.cla need --testapi, UiTest*) with
// cmd.Dir at the repo root, and returns the written bytes.
// wantFallback (IMPORTANT 2): asserts on the presence/absence of
// deliverable (b)'s own "falling back" note, so a caller expecting the
// REAL bake path can't pass vacuously (comparing from-source against a
// silently-fallen-back from-source recompile) and a caller that
// deliberately exercises the fallback (the toolbox suite) documents that
// expectation instead of just happening not to fail. Never checked for
// bakePath == "" (the from-source half of a comparison, which never
// takes the bake path or its own fallback note at all).
func runSuiteEmit68k(t *testing.T, exe string, files []string, outPath, bakePath string, wantFallback bool) []byte {
	t.Helper()
	args := []string{"emit68k", "--testapi", "-o", outPath}
	if bakePath != "" {
		args = append(args, "--rtbake", bakePath)
	}
	args = append(args, files...)
	cmd := exec.Command(exe, args...)
	cmd.Dir = RepoRoot(t)
	out, err := cmd.CombinedOutput()
	if err != nil {
		t.Fatalf("clarusc %v: %v\n%s", args, err, out)
	}
	if bakePath != "" {
		fellBack := bytes.Contains(out, []byte("falling back"))
		if wantFallback && !fellBack {
			t.Fatalf("clarusc %v: expected the documented from-source fallback (deliverable (b)), got none:\n%s", args, out)
		}
		if !wantFallback && fellBack {
			t.Fatalf("clarusc %v: unexpectedly fell back to from-source -- expected the real bake path:\n%s", args, out)
		}
	}
	data, err := os.ReadFile(outPath)
	if err != nil {
		t.Fatalf("read %s: %v", outPath, err)
	}
	return data
}

// TestBakeFullCorpusSuiteCore (deliverable (e)'s own suite-build
// addendum): the core suite's --testapi gui.cla composition, host
// emit68k (no emulator boot needed for byte-identity), must be byte-
// identical via --rtbake.
func TestBakeFullCorpusSuiteCore(t *testing.T) {
	requireBakeFull(t)
	exe := claruscboot.CurrentExe(t)
	dir := t.TempDir()
	bakePath := filepath.Join(dir, "rt68k.clir")
	RunBakeIR(t, exe, "68k", bakePath)

	srcDir := filepath.Join(dir, "core-src")
	bakeDir := filepath.Join(dir, "core-bake")
	os.MkdirAll(srcDir, 0o755)
	os.MkdirAll(bakeDir, 0o755)
	srcOut := filepath.Join(srcDir, "core.bin")
	bakeOut := filepath.Join(bakeDir, "core.bin")
	srcData := runSuiteEmit68k(t, exe, coreSuiteGUIFiles, srcOut, "", false)
	bakeData := runSuiteEmit68k(t, exe, coreSuiteGUIFiles, bakeOut, bakePath, false)
	if !bytes.Equal(srcData, bakeData) {
		t.Fatalf("core suite: --rtbake fork (%d bytes) != from-source fork (%d bytes)", len(bakeData), len(srcData))
	}
}

// TestBakeFullCorpusSuiteToolbox (fix round 2, corrected in fix round 3
// -- IMPORTANT 2; flipped by fallback-trigger-narrowing Task 2): the
// checker-symbol-scope gap round 1 found (testsuite/toolbox/
// cases_uitest.cla, cases_finfo.cla, and cases_resources.cla name RAW
// runtime internals -- UiNewPtr, UiStrAddr, ...) is closed --
// bkInstallCheckerSymbolsForTestapi installs full checker-symbol
// visibility for all THIRTEEN early-spliced modules, not just
// uitest.cla's 16 UiTest* wrapper names (see its own doc comment,
// bake.cla). The toolbox suite's own gui.cla composition directly names
// toolbox/files.cla, toolbox/standardfile.cla, and toolbox/
// appleevents.cla, each ALSO a transitive nested include of one of the
// thirteen early-spliced modules (uidialogs.cla:10-11, ui.cla:179) --
// runtime-ir-bake's own fallback (bkComputeManifestPaths, widened in fix
// round 2 to cover every file the bake transitively touched) used to
// treat this as an unconditional collision and fall back to a full
// from-source recompile for the WHOLE composition, so THIS test used to
// assert the EXPLICIT fallback-class shape instead of proving anything
// about the bake path itself. Task 2's drift-hash + check-only-include
// mechanism narrows that: these three files are unmodified on disk (hash
// matches the baked copy), and their symbols ARE part of the testapi
// preload boundary (early-visible), so expand()'s own case (b) applies
// -- dedup fully, no check-only parse, matching from-source's own
// post-dedup state (drive.cla). The composition now takes the REAL bake
// path (no "falling back" note at all) and must be byte-identical to
// from-source -- the genuine bake-path assertion this test's own history
// above wanted all along.
func TestBakeFullCorpusSuiteToolbox(t *testing.T) {
	requireBakeFull(t)
	exe := claruscboot.CurrentExe(t)
	dir := t.TempDir()
	bakePath := filepath.Join(dir, "rt68k.clir")
	RunBakeIR(t, exe, "68k", bakePath)

	srcDir := filepath.Join(dir, "toolbox-src")
	bakeDir := filepath.Join(dir, "toolbox-bake")
	os.MkdirAll(srcDir, 0o755)
	os.MkdirAll(bakeDir, 0o755)
	srcOut := filepath.Join(srcDir, "toolbox.bin")
	bakeOut := filepath.Join(bakeDir, "toolbox.bin")
	srcData := runSuiteEmit68k(t, exe, toolboxSuiteGUIFiles, srcOut, "", false)
	bakeData := runSuiteEmit68k(t, exe, toolboxSuiteGUIFiles, bakeOut, bakePath, false)
	if !bytes.Equal(srcData, bakeData) {
		t.Fatalf("toolbox suite: --rtbake fork (%d bytes) != from-source fork (%d bytes)", len(bakeData), len(srcData))
	}
}
