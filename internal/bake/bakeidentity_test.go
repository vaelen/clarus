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
func TestRtbakeIncludeCheckOnly(t *testing.T) {
	exe := claruscboot.CurrentExe(t)
	root := RepoRoot(t)
	dir := t.TempDir()
	bakePath := filepath.Join(dir, "rt68k.clir")
	RunBakeIR(t, exe, "68k", bakePath)

	// The include path is repo-root-relative (cmd.Dir = root, matching
	// every other fixture in this file), so the fixture itself must also
	// live at the repo root for the relative include to resolve exactly
	// the way an ordinary user file's own would.
	fixtureName := "dedup_fallback_fixture_task5.cla"
	fixturePath := filepath.Join(root, fixtureName)
	src := "include \"runtime/clarus/core.cla\"\n\nfunc main() {\n    log(\"hello from the dedup fallback fixture\")\n}\n"
	if err := os.WriteFile(fixturePath, []byte(src), 0o644); err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { os.Remove(fixturePath) })

	// Same basename in separate subdirectories -- NOT distinct basenames
	// in one dir: the MacBinary wrap embeds the OUTPUT FILENAME in its
	// header, so two differently-named forks of identical code differ
	// byte-for-byte in that field alone (TestBakePathByteIdentity's own
	// doc comment already flags this exact false alarm).
	srcDir := filepath.Join(dir, "src")
	bakeDir := filepath.Join(dir, "bake")
	if err := os.MkdirAll(srcDir, 0o755); err != nil {
		t.Fatal(err)
	}
	if err := os.MkdirAll(bakeDir, 0o755); err != nil {
		t.Fatal(err)
	}
	srcOut := filepath.Join(srcDir, "dedup.bin")
	bakeOut := filepath.Join(bakeDir, "dedup.bin")

	srcCmd := exec.Command(exe, "emit68k", "-o", srcOut, fixtureName)
	srcCmd.Dir = root
	if out, err := srcCmd.CombinedOutput(); err != nil {
		t.Fatalf("from-source compile of the dedup fixture failed: %v\n%s", err, out)
	}

	bakeCmd := exec.Command(exe, "emit68k", "--rtbake", bakePath, "-o", bakeOut, fixtureName)
	bakeCmd.Dir = root
	bakeOutput, err := bakeCmd.CombinedOutput()
	if err != nil {
		t.Fatalf("--rtbake compile of the dedup fixture failed: %v\n%s", err, bakeOutput)
	}
	if bytes.Contains(bakeOutput, []byte("falling back")) {
		t.Fatalf("--rtbake compile of the dedup fixture: unexpectedly fell back to from-source (Task 2's check-only include should have kept the real bake path):\n%s", bakeOutput)
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
		t.Fatalf("--rtbake compile (%d bytes) != from-source compile (%d bytes) of the same fixture", len(bakeData), len(srcData))
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
	"arc.cla", "argmat_intr.cla", "argmat_nested.cla", "arith.cla", "arr_whole_assign.cla",
	"bigtmp_ceiling.cla", "bounce.cla", "callback.cla", "calls.cla", "clear_deep.cla",
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
