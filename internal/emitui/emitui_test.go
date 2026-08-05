// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// Package emitui holds the ungated lowering-goldens gate for Tasks 4-5 of
// the 2026-07-24 mac-target-4b plan: clarusc's window/menu descriptor + UI
// intrinsic lowering (Task 4), then `extend`/`every` handler/dispatch
// lowering (Task 5). For each testdata/emitui/<fixture>.cla, it builds
// clarusc via the shared Go-free bootstrap (claruscboot.CurrentExe --
// Go-compiler-deletion phase; current-source two-stage bootstrap, cached
// to disk under build-run/), then runs that exe's own `emit` subcommand,
// compares the emitted C to a committed <fixture>.c.golden
// byte-for-byte, then compile-checks the GOLDEN against rt_ui.h with the
// m68k toolchain (compile only, no link -- this package verifies LOWERING,
// fixture by fixture; the full compile-AND-LINK gate is a real program,
// testdata/valid/bounce.cla, built end to end via scripts/build-mac.sh,
// which every emitui fixture's handler/dispatch C shape is hand-verified
// against).
package emitui

import (
	"bytes"
	"encoding/binary"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strconv"
	"strings"
	"testing"

	"clarus/internal/claruscboot"
)

// repoRoot returns the repo root, computed from the package directory (go
// test always runs with cwd == the package dir) -- same convention
// internal/mactest's own repoRoot uses.
func repoRoot(t *testing.T) string {
	t.Helper()
	wd, err := os.Getwd()
	if err != nil {
		t.Fatalf("getwd: %v", err)
	}
	return filepath.Join(wd, "..", "..")
}

// buildClarusc returns the current-source clarusc via the shared Go-free
// bootstrap (Go-compiler-deletion phase; was build.Build on
// clarusc/main.cla). Kept as a local name so fixture call sites are
// untouched.
func buildClarusc(t *testing.T) string {
	t.Helper()
	return claruscboot.CurrentExe(t)
}

// m68kGCC returns the Retro68 m68k cross-compiler's path, per CLAUDE.md's
// toolchain layout.
func m68kGCC(t *testing.T) string {
	t.Helper()
	p := filepath.Join(repoRoot(t), "toolchain", "bin", "m68k-apple-macos-gcc")
	if _, err := os.Stat(p); err != nil {
		t.Skipf("m68k toolchain not found at %s (build it per CLAUDE.md first): %v", p, err)
	}
	return p
}

// TestEmitUiGoldens runs `clarusc emit` on every testdata/emitui/*.cla
// fixture, compares the emitted C to its committed .c.golden byte-for-byte,
// then m68k compile-checks the golden against rt_ui.h (compile only, no
// link -- see the package doc comment).
func TestEmitUiGoldens(t *testing.T) {
	root := repoRoot(t)
	exe := buildClarusc(t)
	gcc := m68kGCC(t)

	allFixtures, err := filepath.Glob(filepath.Join(root, "testdata", "emitui", "*.cla"))
	if err != nil {
		t.Fatal(err)
	}
	// Only fixtures with a committed .c.golden run this loop -- an error
	// fixture (e.g. err_const_at.cla) has none by design (see
	// TestEmitUiErrConstAt) and never successfully emits.
	var fixtures []string
	for _, f := range allFixtures {
		if _, err := os.Stat(strings.TrimSuffix(f, ".cla") + ".c.golden"); err == nil {
			fixtures = append(fixtures, f)
		}
	}
	if len(fixtures) == 0 {
		t.Fatal("no testdata/emitui/*.cla fixtures with a .c.golden found")
	}

	for _, fixture := range fixtures {
		fixture := fixture
		t.Run(filepath.Base(fixture), func(t *testing.T) {
			golden := strings.TrimSuffix(fixture, ".cla") + ".c.golden"
			want, err := os.ReadFile(golden)
			if err != nil {
				t.Fatalf("read golden %s: %v", golden, err)
			}

			outC := filepath.Join(t.TempDir(), "out.c")
			cmd := exec.Command(exe, "emit", "-o", outC, fixture)
			var stdout, stderr bytes.Buffer
			cmd.Stdout = &stdout
			cmd.Stderr = &stderr
			if err := cmd.Run(); err != nil {
				t.Fatalf("clarusc emit -o %s %s: %v\nstdout: %s\nstderr: %s", outC, fixture, err, stdout.String(), stderr.String())
			}
			got, err := os.ReadFile(outC)
			if err != nil {
				t.Fatalf("read emitted %s: %v", outC, err)
			}
			if !bytes.Equal(got, want) {
				t.Errorf("%s: emitted C does not match %s\n--- got ---\n%s\n--- want ---\n%s", fixture, golden, got, want)
			}

			// Compile-check the GOLDEN (the committed contract), not the
			// freshly emitted bytes -- so a mismatch above is reported as a
			// golden-mismatch failure, and this step still exercises the
			// pinned contract even if emission has drifted. `-x c` is
			// REQUIRED: gcc picks a source language purely from the file
			// extension, ".c.golden" isn't in its table, and -- without -x --
			// it silently treats the file as an unrecognized/link-only input,
			// warns, and exits 0 with NO object emitted at all (found
			// verifying this exact check while adding Task 5's fixtures: the
			// step had never actually compiled anything since Task 4).
			obj := filepath.Join(t.TempDir(), "out.o")
			ccCmd := exec.Command(gcc, "-x", "c", "-c",
				"-I"+filepath.Join(root, "runtime", "host"),
				"-I"+filepath.Join(root, "runtime", "mac"),
				golden, "-o", obj)
			var ccOut bytes.Buffer
			ccCmd.Stdout = &ccOut
			ccCmd.Stderr = &ccOut
			if err := ccCmd.Run(); err != nil {
				t.Fatalf("m68k-apple-macos-gcc -c %s: %v\n%s", golden, err, ccOut.String())
			}
			if fi, statErr := os.Stat(obj); statErr != nil || fi.Size() == 0 {
				t.Fatalf("m68k-apple-macos-gcc -c %s: no object file produced (stat: %v)\n%s", golden, statErr, ccOut.String())
			}
		})
	}
}

// TestEmitUiErrConstAt asserts that a window property whose geometry value
// is a named int constant rather than a literal (legal syntax -- checkWidget
// validates only the property NAME, not this value's shape) fails clarusc
// emit loudly (lower.cla's lowRequireIntLit) instead of silently reading a
// wrong value: nonzero exit, and the diagnostic on stderr.
func TestEmitUiErrConstAt(t *testing.T) {
	root := repoRoot(t)
	exe := buildClarusc(t)
	fixture := filepath.Join(root, "testdata", "emitui", "err_const_at.cla")

	cmd := exec.Command(exe, "emit", "-o", filepath.Join(t.TempDir(), "out.c"), fixture)
	var stderr bytes.Buffer
	cmd.Stderr = &stderr
	err := cmd.Run()
	if err == nil {
		t.Fatalf("clarusc emit %s: want nonzero exit, got success (stderr: %s)", fixture, stderr.String())
	}
	const want = "window property requires an integer literal"
	if !strings.Contains(stderr.String(), want) {
		t.Errorf("stderr %q missing %q", stderr.String(), want)
	}
}

// TestEmitUiTablePopupGuards asserts clarusc's mac-target-4d Task 5
// popup/table lowering guards: each fixture below is checker-clean syntax
// (or, for popup_nonform.cla, syntax the checker itself already rejects --
// see that fixture's own doc comment on why) that clarusc emit must still
// reject loudly with a nonzero exit and a matching stderr message. No
// golden for any of them: none ever successfully emits.
func TestEmitUiTablePopupGuards(t *testing.T) {
	root := repoRoot(t)
	exe := buildClarusc(t)

	cases := []struct {
		fixture string
		want    string
	}{
		// lower.cla's lowWidgetDesc popup guard (lowUnsupported -> log ->
		// stderr): no `binds:` at all.
		{"popup_unbound.cla", "popup requires binds inside a form window"},
		// check.cla's checkBindsProperty: binds given, but the window
		// isn't a form -- caught by the CHECKER before lowering runs (see
		// the fixture's own doc comment). Checker diagnostics print via
		// `alert` (main.cla), which is stdout, not stderr -- unlike the
		// two lowUnsupported-driven cases here.
		{"popup_nonform.cla", "binds: requires the window to declare form for"},
		// lower.cla's lowWidgetDesc table guard: `rows:` is a call
		// expression, not a bare identifier.
		{"table_rows_expr.cla", "table rows must be a global list variable"},
		// Checker-level rejection (stdout, see popup_nonform.cla's note
		// above): `rows:` names a window-local var, invisible to
		// widget-declaration-time property checking (see the fixture's
		// own doc comment).
		{"table_rows_local.cla", "undefined: localRows"},
		// mac-target-4d Task 7: a zero-column table (deferred minor from
		// Task 5) -- lower.cla's lowWidgetDesc table branch.
		{"table_zero_cols.cla", "table must have at least one column"},
		// Task 7: `isNew` read on a record that isn't the accepted
		// handler's own parameter -- lower.cla's lowSelect TyRec case.
		{"isnew_wrong.cla", "isNew is only defined on the accepted handler's parameter"},
		// Task 7: an edit target shape lower.cla's lowEditStmt doesn't
		// support (a nested field of a list element).
		{"edit_bad_target.cla", "edit target must be a variable, list element, or map element"},
		// ARC fix-wave Task 3 (Important 7): check.cla's checkWindowDecl
		// now enforces "every field of a form's record must be a
		// by-value type" (docs/clarus-language-reference.md ~line 1008)
		// itself, at `form for` resolution -- caught by the CHECKER
		// (stdout, see popup_nonform.cla's note above), before lower.cla's
		// own pre-existing (shallower, one-level, lowUnsupported-driven)
		// lowCheckSerializableFields guard ever gets a chance to fire for
		// this shape.
		{"form_for_handle_field.cla", "form for NoteRec: field body must be a by-value type"},
	}

	for _, c := range cases {
		c := c
		t.Run(c.fixture, func(t *testing.T) {
			fixture := filepath.Join(root, "testdata", "emitui", c.fixture)
			cmd := exec.Command(exe, "emit", "-o", filepath.Join(t.TempDir(), "out.c"), fixture)
			var out bytes.Buffer
			cmd.Stdout = &out
			cmd.Stderr = &out
			err := cmd.Run()
			if err == nil {
				t.Fatalf("clarusc emit %s: want nonzero exit, got success (output: %s)", fixture, out.String())
			}
			if !strings.Contains(out.String(), c.want) {
				t.Errorf("output %q missing %q", out.String(), c.want)
			}
		})
	}
}

// uiBlobArrayRe/uiBlobIntRe extract clar_ui_blob's byte VALUES out of an
// emit's C source -- the blob's own byte identity is the only normative
// contract (uiblob.cla's own doc comment); the surrounding C array-literal
// spelling (line wrapping, indentation) is cprint.cla's own business and is
// pinned separately, via TestEmitUiGoldens' uiblob_probe.c.golden.
var uiBlobArrayRe = regexp.MustCompile(`(?s)clar_ui_blob\[\] = \{(.*?)\};`)
var uiBlobIntRe = regexp.MustCompile(`-?\d+`)

func extractUiBlob(src string) ([]byte, error) {
	m := uiBlobArrayRe.FindStringSubmatch(src)
	if m == nil {
		return nil, fmt.Errorf("clar_ui_blob[] array literal not found")
	}
	nums := uiBlobIntRe.FindAllString(m[1], -1)
	out := make([]byte, len(nums))
	for i, s := range nums {
		n, err := strconv.Atoi(s)
		if err != nil {
			return nil, fmt.Errorf("parse byte %q: %w", s, err)
		}
		if n < 0 || n > 255 {
			return nil, fmt.Errorf("byte value %d out of 0-255 range at index %d", n, i)
		}
		out[i] = byte(n)
	}
	return out, nil
}

// TestUiBlobGolden pins uiblob.cla's uibBuild() byte output for
// testdata/emitui/uiblob_probe.cla against
// testdata/emitui/uiblob_probe.blob.golden -- the plan's normative UI
// descriptor blob format ("The UI descriptor blob" section,
// docs/superpowers/plans/2026-08-01-native-5e-ui-runtime.md) -- then
// structurally decodes the GOLDEN (header -> windows -> widgets/menus/
// menu handlers/every/app, re-deriving every string-pool reference)
// rather than trusting the raw byte-compare alone, so a future change
// that reorders fields but happens to preserve the total byte count
// doesn't slip through undetected. The whole-emit C shape (synthesized
// clar_ui_fire_* dispatchers, etc.) is pinned separately, by
// TestEmitUiGoldens' own uiblob_probe.c.golden -- this test only needs a
// fresh emit to extract the blob bytes from.
//
// To regenerate the golden after an intentional uiblob.cla format change:
// run `clarusc emit -o /tmp/out.c testdata/emitui/uiblob_probe.cla`,
// extract the clar_ui_blob[] array's byte values (extractUiBlob above does
// exactly this), and write them as raw bytes to
// testdata/emitui/uiblob_probe.blob.golden.
func TestUiBlobGolden(t *testing.T) {
	root := repoRoot(t)
	exe := buildClarusc(t)
	fixture := filepath.Join(root, "testdata", "emitui", "uiblob_probe.cla")

	outC := filepath.Join(t.TempDir(), "out.c")
	cmd := exec.Command(exe, "emit", "-o", outC, fixture)
	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	if err := cmd.Run(); err != nil {
		t.Fatalf("clarusc emit -o %s %s: %v\nstdout: %s\nstderr: %s", outC, fixture, err, stdout.String(), stderr.String())
	}
	src, err := os.ReadFile(outC)
	if err != nil {
		t.Fatalf("read emitted %s: %v", outC, err)
	}

	got, err := extractUiBlob(string(src))
	if err != nil {
		t.Fatalf("extract clar_ui_blob[] from %s: %v", outC, err)
	}

	goldenPath := filepath.Join(root, "testdata", "emitui", "uiblob_probe.blob.golden")
	want, err := os.ReadFile(goldenPath)
	if err != nil {
		t.Fatalf("read golden %s: %v", goldenPath, err)
	}
	if !bytes.Equal(got, want) {
		t.Errorf("%s: decoded clar_ui_blob bytes do not match %s (%d vs %d bytes) -- see this test's own doc comment for how to regenerate", fixture, goldenPath, len(got), len(want))
	}

	// Structural decode against the COMMITTED golden (Step 3 of the task
	// brief) -- walks every section by its own header-declared offset/
	// count, re-deriving string-pool references.
	d := &uiBlobDecoder{t: t, b: want}
	d.checkHeader()
	d.checkWindows()
	d.checkMenus()
	d.checkMenuHandlers()
	d.checkEvery()
	d.checkApp()

	gcc := m68kGCC(t)
	obj := filepath.Join(t.TempDir(), "out.o")
	ccCmd := exec.Command(gcc, "-x", "c", "-c",
		"-I"+filepath.Join(root, "runtime", "host"),
		"-I"+filepath.Join(root, "runtime", "mac"),
		outC, "-o", obj)
	var ccOut bytes.Buffer
	ccCmd.Stdout = &ccOut
	ccCmd.Stderr = &ccOut
	if err := ccCmd.Run(); err != nil {
		t.Fatalf("m68k-apple-macos-gcc -c %s (--uiport emit of %s): %v\n%s", outC, fixture, err, ccOut.String())
	}
	if fi, statErr := os.Stat(obj); statErr != nil || fi.Size() == 0 {
		t.Fatalf("m68k-apple-macos-gcc -c %s: no object file produced (stat: %v)\n%s", outC, statErr, ccOut.String())
	}
}

// uiBlobDecoder is a minimal reader over a raw UI descriptor blob --
// every integer field is a big-endian int32 at a 4-byte-aligned offset,
// blob-absolute (never section-relative); a Str255 is a length byte plus
// raw bytes, referenced the same way, -1 marking "absent" (see
// uiblob.cla's own doc comment, which this mirrors).
type uiBlobDecoder struct {
	t *testing.T
	b []byte

	nWins, winsOff       int
	nMenus, menusOff     int
	nMenuHandlers, mhOff int
	nEvery, everyOff     int
	appOff               int
}

func (d *uiBlobDecoder) i32(off int) int {
	d.t.Helper()
	if off < 0 || off+4 > len(d.b) {
		d.t.Fatalf("uiblob: i32 offset %d out of range (blob is %d bytes)", off, len(d.b))
	}
	return int(int32(binary.BigEndian.Uint32(d.b[off : off+4])))
}

// str reads a Str255 at a blob-absolute offset, or ("", false) for the -1
// "absent" sentinel.
func (d *uiBlobDecoder) str(off int) (string, bool) {
	d.t.Helper()
	if off == -1 {
		return "", false
	}
	if off < 0 || off >= len(d.b) {
		d.t.Fatalf("uiblob: str offset %d out of range (blob is %d bytes)", off, len(d.b))
	}
	n := int(d.b[off])
	end := off + 1 + n
	if end > len(d.b) {
		d.t.Fatalf("uiblob: str at %d (len %d) runs past blob end (%d bytes)", off, n, len(d.b))
	}
	return string(d.b[off+1 : end]), true
}

// checkHeader decodes the 11-int32 header and asserts the fixture's own
// known shape (uiblob_probe.cla's doc comment: 2 windows, 2 menus, 2 menu
// handlers, 1 every block, 1 app section).
func (d *uiBlobDecoder) checkHeader() {
	d.t.Helper()
	if magic := d.i32(0); magic != 0x434C5549 {
		d.t.Fatalf("uiblob: magic = %#x, want 'CLUI' (0x434C5549)", magic)
	}
	if v := d.i32(4); v != 1 {
		d.t.Fatalf("uiblob: version = %d, want 1", v)
	}
	d.nWins = d.i32(8)
	d.winsOff = d.i32(12)
	d.nMenus = d.i32(16)
	d.menusOff = d.i32(20)
	d.nMenuHandlers = d.i32(24)
	d.mhOff = d.i32(28)
	d.nEvery = d.i32(32)
	d.everyOff = d.i32(36)
	d.appOff = d.i32(40)

	if d.winsOff != 44 {
		d.t.Errorf("uiblob: winsOff = %d, want 44 (header is fixed at 11 int32 = 44 bytes)", d.winsOff)
	}
	if d.nWins != 2 {
		d.t.Errorf("uiblob: nWins = %d, want 2", d.nWins)
	}
	if d.nMenus != 2 {
		d.t.Errorf("uiblob: nMenus = %d, want 2", d.nMenus)
	}
	if d.nMenuHandlers != 2 {
		d.t.Errorf("uiblob: nMenuHandlers = %d, want 2", d.nMenuHandlers)
	}
	if d.nEvery != 1 {
		d.t.Errorf("uiblob: nEvery = %d, want 1", d.nEvery)
	}
	if d.appOff == -1 {
		d.t.Errorf("uiblob: appOff = -1, want a real offset (fixture declares an `app` section)")
	}
}

// checkWindows decodes both windows (Main: every non-popup widget kind
// plus a table; EditForm: `form for`, incl. a popup) and follows their
// nested Widget/Table/Col/Form/Bind/Layout/EnumArrays references.
func (d *uiBlobDecoder) checkWindows() {
	d.t.Helper()
	if d.nWins != 2 {
		return // checkHeader already reported this
	}

	type wantWin struct {
		name        string
		nWidgets    int
		kinds       []int // RTUI_* numeric kind, declared order
		stateSize   int
		handlerMask int
		isForm      bool
	}
	// kind numbers: button 0, check 1, canvas 2, label 3, field 4,
	// textview 5, popup 6, table 7 (rt_ui.h:53-60).
	wants := []wantWin{
		{name: "Main", nWidgets: 7, kinds: []int{0, 1, 2, 3, 4, 5, 7}, stateSize: 8, handlerMask: 287, isForm: false},
		{name: "EditForm", nWidgets: 5, kinds: []int{4, 6, 1, 0, 0}, stateSize: 0, handlerMask: 96, isForm: true},
	}

	for wi, want := range wants {
		base := d.winsOff + wi*48
		name, ok := d.str(d.i32(base))
		if !ok || name != want.name {
			d.t.Errorf("uiblob: window %d name = %q (ok=%v), want %q", wi, name, ok, want.name)
		}
		if _, ok := d.str(d.i32(base + 4)); !ok {
			d.t.Errorf("uiblob: window %d (%s) titleOff = -1, want a real title", wi, want.name)
		}
		nWidgets := d.i32(base + 28)
		widgetsOff := d.i32(base + 32)
		stateSize := d.i32(base + 36)
		handlerMask := d.i32(base + 40)
		formOff := d.i32(base + 44)

		if nWidgets != want.nWidgets {
			d.t.Errorf("uiblob: window %d (%s) nWidgets = %d, want %d", wi, want.name, nWidgets, want.nWidgets)
		}
		if stateSize != want.stateSize {
			d.t.Errorf("uiblob: window %d (%s) stateSize = %d, want %d", wi, want.name, stateSize, want.stateSize)
		}
		if handlerMask != want.handlerMask {
			d.t.Errorf("uiblob: window %d (%s) handlerMask = %d, want %d", wi, want.name, handlerMask, want.handlerMask)
		}
		if want.isForm && formOff == -1 {
			d.t.Errorf("uiblob: window %d (%s) formOff = -1, want a real form desc", wi, want.name)
		}
		if !want.isForm && formOff != -1 {
			d.t.Errorf("uiblob: window %d (%s) formOff = %d, want -1 (not a form window)", wi, want.name, formOff)
		}

		for kwi, wantKind := range want.kinds {
			if kwi >= nWidgets {
				break
			}
			wb := widgetsOff + kwi*52
			if kind := d.i32(wb); kind != wantKind {
				d.t.Errorf("uiblob: window %d (%s) widget %d kind = %d, want %d", wi, want.name, kwi, kind, wantKind)
			}
			if wname, ok := d.str(d.i32(wb + 4)); !ok || wname == "" {
				d.t.Errorf("uiblob: window %d (%s) widget %d name = %q (ok=%v), want a non-empty name", wi, want.name, kwi, wname, ok)
			}
		}
	}

	// Main.Flag (widget index 1) declares no `caption:` at all -- the
	// caption-fallback rule (uibWidgetCaptionIdx, applied at blob build
	// time) must resolve captionOff to its own name, "Flag".
	mainBase := d.winsOff
	mainWidgetsOff := d.i32(mainBase + 32)
	flagCapOff := d.i32(mainWidgetsOff + 1*52 + 8)
	if cap, ok := d.str(flagCapOff); !ok || cap != "Flag" {
		d.t.Errorf("uiblob: Main.Flag captionOff = %q (ok=%v), want \"Flag\" (caption-fallback rule)", cap, ok)
	}

	// Main.Rows (widget index 6, a table): rowsIdx/layout/2 columns.
	rowsWidgetBase := mainWidgetsOff + 6*52
	tableOff := d.i32(rowsWidgetBase + 48)
	if tableOff == -1 {
		d.t.Fatalf("uiblob: Main.Rows tableOff = -1, want a real table desc")
	}
	nCols := d.i32(tableOff + 8)
	colsOff := d.i32(tableOff + 12)
	if nCols != 2 {
		d.t.Errorf("uiblob: Main.Rows nCols = %d, want 2", nCols)
	}
	wantCols := []struct {
		header    string
		widthFill int
	}{{"Name", 0}, {"Count", 1}}
	for ci, want := range wantCols {
		if ci >= nCols {
			break
		}
		cb := colsOff + ci*16
		if header, ok := d.str(d.i32(cb)); !ok || header != want.header {
			d.t.Errorf("uiblob: Main.Rows col %d header = %q (ok=%v), want %q", ci, header, ok, want.header)
		}
		if widthFill := d.i32(cb + 8); widthFill != want.widthFill {
			d.t.Errorf("uiblob: Main.Rows col %d widthFill = %d, want %d", ci, widthFill, want.widthFill)
		}
	}

	// EditForm's Form entry: 3 binds (FLabel->label idx 0, FStatus->status
	// idx 2, FFlag->flag idx 3 -- record FormRec{label,qty,status,flag}),
	// and its Layout's status field (index 2) is the ENUM one with 3
	// members matching `enum Status { Open Closed Pending }`.
	editBase := d.winsOff + 48
	formOff := d.i32(editBase + 44)
	layoutOff := d.i32(formOff)
	nBinds := d.i32(formOff + 4)
	bindsOff := d.i32(formOff + 8)
	if nBinds != 3 {
		d.t.Errorf("uiblob: EditForm nBinds = %d, want 3", nBinds)
	}
	wantBinds := [][2]int{{0, 0}, {1, 2}, {2, 3}}
	for bi, want := range wantBinds {
		if bi >= nBinds {
			break
		}
		bb := bindsOff + bi*8
		widgetIndex := d.i32(bb)
		fieldIndex := d.i32(bb + 4)
		if widgetIndex != want[0] || fieldIndex != want[1] {
			d.t.Errorf("uiblob: EditForm bind %d = (widgetIndex %d, fieldIndex %d), want (%d, %d)", bi, widgetIndex, fieldIndex, want[0], want[1])
		}
	}
	nFields := d.i32(layoutOff + 4)
	if nFields != 4 {
		d.t.Errorf("uiblob: EditForm form Layout nFields = %d, want 4", nFields)
		return
	}
	statusFieldBase := layoutOff + 8 + 2*24
	if ftype := d.i32(statusFieldBase); ftype != 5 {
		d.t.Errorf("uiblob: EditForm form Layout field 2 (status) ftype = %d, want 5 (RT_FT_ENUM)", ftype)
	}
	enumCount := d.i32(statusFieldBase + 12)
	enumLabelsOff := d.i32(statusFieldBase + 16)
	enumValuesOff := d.i32(statusFieldBase + 20)
	if enumCount != 3 {
		d.t.Errorf("uiblob: EditForm form Layout field 2 (status) enumCount = %d, want 3", enumCount)
		return
	}
	wantLabels := []string{"Open", "Closed", "Pending"}
	for ei, wantLabel := range wantLabels {
		labOff := d.i32(enumLabelsOff + ei*4)
		val := d.i32(enumValuesOff + ei*4)
		if lab, ok := d.str(labOff); !ok || lab != wantLabel {
			d.t.Errorf("uiblob: EditForm status enum member %d label = %q (ok=%v), want %q", ei, lab, ok, wantLabel)
		}
		if val != ei {
			d.t.Errorf("uiblob: EditForm status enum member %d value = %d, want %d", ei, val, ei)
		}
	}
}

// checkMenus decodes File (3 items: an item, a separator, an item) and
// Edit (`standard edit`, nItems 0).
func (d *uiBlobDecoder) checkMenus() {
	d.t.Helper()
	if d.nMenus != 2 {
		return
	}

	fileBase := d.menusOff
	if name, ok := d.str(d.i32(fileBase)); !ok || name != "File" {
		d.t.Errorf("uiblob: menu 0 name = %q (ok=%v), want \"File\"", name, ok)
	}
	nItems := d.i32(fileBase + 8)
	itemsOff := d.i32(fileBase + 12)
	if isStd := d.i32(fileBase + 16); nItems != 3 || isStd != 0 {
		d.t.Errorf("uiblob: menu File nItems=%d isStd=%d, want 3/0", nItems, isStd)
	}
	if nItems == 3 {
		sepBase := itemsOff + 1*16
		if name, ok := d.str(d.i32(sepBase)); ok {
			d.t.Errorf("uiblob: menu File item 1 nameOff resolves to %q, want -1 (a bare `separator`)", name)
		}
		if sep := d.i32(sepBase + 12); sep != 1 {
			d.t.Errorf("uiblob: menu File item 1 separator = %d, want 1", sep)
		}
	}

	editBase := d.menusOff + 20
	if name, ok := d.str(d.i32(editBase)); !ok || name != "Edit" {
		d.t.Errorf("uiblob: menu 1 name = %q (ok=%v), want \"Edit\"", name, ok)
	}
	nItems = d.i32(editBase + 8)
	itemsOff = d.i32(editBase + 12)
	isStd := d.i32(editBase + 16)
	if nItems != 0 || itemsOff != -1 || isStd != 1 {
		d.t.Errorf("uiblob: menu Edit nItems=%d itemsOff=%d isStd=%d, want 0/-1/1", nItems, itemsOff, isStd)
	}
}

// checkMenuHandlers decodes File.New (window-scoped, `extend Main {
// extend File { on New.select ... } }`) and File.Quit (app-scope,
// top-level `extend File { on Quit.select ... }`).
func (d *uiBlobDecoder) checkMenuHandlers() {
	d.t.Helper()
	if d.nMenuHandlers != 2 {
		return
	}

	h0 := d.mhOff
	if itemName, ok := d.str(d.i32(h0 + 20)); !ok || itemName != "New" {
		d.t.Errorf("uiblob: menuHandler 0 itemName = %q (ok=%v), want \"New\"", itemName, ok)
	}
	if scope := d.i32(h0 + 12); scope != 0 {
		d.t.Errorf("uiblob: menuHandler 0 (File.New) scopeWinIdx = %d, want 0 (Main)", scope)
	}
	if hIdx := d.i32(h0 + 8); hIdx != 0 {
		d.t.Errorf("uiblob: menuHandler 0 handlerIdx = %d, want 0 (its own section position)", hIdx)
	}

	h1 := d.mhOff + 24
	if itemName, ok := d.str(d.i32(h1 + 20)); !ok || itemName != "Quit" {
		d.t.Errorf("uiblob: menuHandler 1 itemName = %q (ok=%v), want \"Quit\"", itemName, ok)
	}
	if scope := d.i32(h1 + 12); scope != -1 {
		d.t.Errorf("uiblob: menuHandler 1 (File.Quit) scopeWinIdx = %d, want -1 (app-scope)", scope)
	}
	if hIdx := d.i32(h1 + 8); hIdx != 1 {
		d.t.Errorf("uiblob: menuHandler 1 handlerIdx = %d, want 1", hIdx)
	}
}

// checkEvery decodes the fixture's one `every 5 ticks { }` block.
func (d *uiBlobDecoder) checkEvery() {
	d.t.Helper()
	if d.nEvery != 1 {
		return
	}
	if ticks := d.i32(d.everyOff); ticks != 5 {
		d.t.Errorf("uiblob: every[0].ticks = %d, want 5", ticks)
	}
}

// checkApp decodes the fixture's `app Probe { ... }` section.
func (d *uiBlobDecoder) checkApp() {
	d.t.Helper()
	if d.appOff == -1 {
		return
	}
	wants := []struct {
		field string
		off   int
		want  string
	}{
		{"name", 0, "Probe"},
		{"version", 4, "1.0"},
		{"author", 8, "Test"},
		{"about", 12, "UI blob probe fixture"},
	}
	for _, w := range wants {
		v, ok := d.str(d.i32(d.appOff + w.off))
		if !ok || v != w.want {
			d.t.Errorf("uiblob: app.%s = %q (ok=%v), want %q", w.field, v, ok, w.want)
		}
	}
}
