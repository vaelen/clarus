package selfhost

import (
	"bytes"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
	"testing"

	"clarus/internal/build"
)

// emitBuild runs `clarusc emit -o <dir>/main.c claPath`, reads the written
// main.c as the emitted C translation unit, writes it alongside the embedded
// host runtime (rt.h/rt.c from internal/build) into a temp dir, and compiles
// them with the same toolchain and flags internal/build uses. It returns the
// built binary's path.
func emitBuild(t *testing.T, exe, claPath string) string {
	t.Helper()

	dir := t.TempDir()
	mainC := filepath.Join(dir, "main.c")

	cmd := exec.Command(exe, "emit", "-o", mainC, claPath)
	var out, errb bytes.Buffer
	cmd.Stdout = &out
	cmd.Stderr = &errb
	if err := cmd.Run(); err != nil {
		t.Fatalf("clarusc emit -o %s %s: %v\nstderr: %s", mainC, claPath, err, errb.String())
	}

	emitted, err := os.ReadFile(mainC)
	if err != nil {
		t.Fatalf("read emitted C at %s: %v", mainC, err)
	}

	rtC := filepath.Join(dir, "rt.c")
	if err := os.WriteFile(filepath.Join(dir, "rt.h"), build.RuntimeH(), 0o644); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(rtC, build.RuntimeC(), 0o644); err != nil {
		t.Fatal(err)
	}

	bin := filepath.Join(dir, "prog")
	cc := exec.Command(build.CCPath(), "-std=c99", "-O1", mainC, rtC, "-o", bin)
	if ccOut, err := cc.CombinedOutput(); err != nil {
		t.Fatalf("cc rejected clarusc-emitted C: %v\n%s\n--- emitted C ---\n%s", err, ccOut, string(emitted))
	}
	return bin
}

// emitSeeds lists every testdata/run/*.cla golden clarusc's self-hosted
// emit path (lower.cla/cprint.cla) can currently handle end to end. Each
// entry gets its own subtest via TestEmitDifferential. Only seeds inside
// the emit path's current conservative feature subset belong here — see
// each task's brief for what that subset covers; a seed exercising an
// unimplemented construct fails loudly (lowUnsupported aborts clarusc
// emit), not silently.
//
// Task 4 (arithmetic/comparisons/conversions): none of the OTHER existing
// run goldens that touch arithmetic (arith.cla, fixedmath.cla) qualify yet
// -- both rely on a user-defined `func` and `while`/array indexing to
// render their result as text, none of which the emit path supports before
// Task 5+. emit_arith.cla is written from scratch against the exact
// current subset (handler body, `if`/`else`, `alert`, `quit`, and
// expression-only Bin/Un/Conv coverage) instead.
//
// Task 5 (strings/char/text): likewise, none of the OTHER existing
// string/text run goldens (strings.cla, strcap.cla, textassign.cla,
// concat_order.cla) qualify -- all rely on a user-defined `func` and/or
// `while` to render/accumulate their result, still unsupported before
// Task 6+. emit_strings.cla/emit_text.cla are written from scratch against
// the exact current subset (StAssign, string/text/char `+`, comparisons,
// slicing, indexing/set-indexing, fromBytes/toBytes/indexOf/append, and a
// fixed-size char[] array for the byte-buffer methods) instead.
var emitSeeds = []string{
	"../../testdata/run/emit_hello.cla",
	"../../testdata/run/emit_arith.cla",
	"../../testdata/run/emit_strings.cla",
	"../../testdata/run/emit_text.cla",
	"../../testdata/run/emit_control.cla",
	"../../testdata/run/emit_switch.cla",
	"../../testdata/run/emit_list.cla",
	"../../testdata/run/emit_map.cla",
}

// TestEmitDifferential is the walking-skeleton gate: for every seed in
// emitSeeds, clarusc emits C, that C compiles and links against the host
// runtime, and the resulting binary's stdout + exit code match the
// golden's .out/.exit (with .args/.exit handled exactly as internal/
// build's run goldens).
func TestEmitDifferential(t *testing.T) {
	exe, err := buildClarusc()
	if err != nil {
		t.Fatalf("build clarusc: %v", err)
	}

	for _, seed := range emitSeeds {
		seed := seed
		t.Run(filepath.Base(seed), func(t *testing.T) {
			base := strings.TrimSuffix(seed, ".cla")
			want, err := os.ReadFile(base + ".out")
			if err != nil {
				t.Fatal(err)
			}

			bin := emitBuild(t, exe, seed)

			var argv []string
			if b, err := os.ReadFile(base + ".args"); err == nil {
				argv = strings.Fields(string(b))
			}
			wantExit := 0
			if b, err := os.ReadFile(base + ".exit"); err == nil {
				wantExit, err = strconv.Atoi(strings.TrimSpace(string(b)))
				if err != nil {
					t.Fatalf("bad .exit: %v", err)
				}
			}

			cmd := exec.Command(bin, argv...)
			cmd.Dir = t.TempDir()
			var stdout, stderr bytes.Buffer
			cmd.Stdout = &stdout
			cmd.Stderr = &stderr
			runErr := cmd.Run()

			gotExit := 0
			if runErr != nil {
				ee, ok := runErr.(*exec.ExitError)
				if !ok {
					t.Fatalf("run emitted binary: %v", runErr)
				}
				gotExit = ee.ExitCode()
			}
			if gotExit != wantExit {
				t.Fatalf("exit code: got %d want %d (stderr: %s)", gotExit, wantExit, stderr.String())
			}
			if stdout.String() != string(want) {
				t.Errorf("stdout:\n got: %q\nwant: %q", stdout.String(), string(want))
			}
		})
	}
}
