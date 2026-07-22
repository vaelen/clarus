package cprint

import (
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"

	"clarus/internal/ast"
	"clarus/internal/build"
	"clarus/internal/check"
	"clarus/internal/ir"
	"clarus/internal/lower"
	"clarus/internal/parser"
	"clarus/internal/source"
)

// lowerSrc parses, checks, and lowers src, failing the test on any error —
// the same pipeline internal/lower's own tests use, reimplemented here
// since that helper is unexported in a different package.
func lowerSrc(t *testing.T, src string) *ir.Program {
	t.Helper()
	f := &source.File{Name: "t.cla", Content: []byte(src)}
	tree, pd := parser.Parse(f)
	if len(pd) > 0 {
		t.Fatal(pd[0])
	}
	diags, info := check.Files([]*source.File{f}, []*ast.File{tree})
	if len(diags) > 0 {
		t.Fatal(diags[0])
	}
	p, ld := lower.Program([]*source.File{f}, []*ast.File{tree}, info)
	if len(ld) > 0 {
		t.Fatal(ld[0])
	}
	return p
}

// buildAndRun writes src's emitted C plus the host runtime to a temp dir,
// compiles with -std=c99 -Wall -Werror, runs the result, and returns its
// stdout.
func buildAndRun(t *testing.T, src string) string {
	t.Helper()
	p := lowerSrc(t, src)
	c := Emit(p)

	dir := t.TempDir()
	main := filepath.Join(dir, "main.c")
	if err := os.WriteFile(main, c, 0o644); err != nil {
		t.Fatal(err)
	}
	rtH, err := os.ReadFile("../../runtime/host/rt.h")
	if err != nil {
		t.Fatal(err)
	}
	rtC, err := os.ReadFile("../../runtime/host/rt.c")
	if err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(filepath.Join(dir, "rt.h"), rtH, 0o644); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(filepath.Join(dir, "rt.c"), rtC, 0o644); err != nil {
		t.Fatal(err)
	}
	exe := filepath.Join(dir, "prog")
	cmd := exec.Command(build.CCPath(), "-std=c99", "-Wall", "-Werror", main, filepath.Join(dir, "rt.c"), "-o", exe)
	if out, err := cmd.CombinedOutput(); err != nil {
		t.Fatalf("cc: %v\n%s\n--- emitted C ---\n%s", err, out, c)
	}
	out, err := exec.Command(exe).CombinedOutput()
	if err != nil {
		t.Fatalf("run: %v\n%s", err, out)
	}
	return string(out)
}

// TestEmitStructure covers the plan's Step 1 structural assertions before
// ever invoking cc.
func TestEmitStructure(t *testing.T) {
	p := lowerSrc(t, `var x: int = 2 + 3

func addOne(n: int): int {
    return n + 1
}

on App.launch {
    alert("hi")
}
`)
	c := string(Emit(p))
	for _, want := range []string{"clar_init_globals", "int main(void)", "rt_alert", "clar_fn_addOne", "clar_fn_handler_App_launch"} {
		if !strings.Contains(c, want) {
			t.Errorf("emitted C missing %q:\n%s", want, c)
		}
	}
}

// TestEmitRunHello is the plan's Step 1 compile-and-run check: a tiny
// App.launch alert program's C output must build clean and print "hi\n".
func TestEmitRunHello(t *testing.T) {
	out := buildAndRun(t, `on App.launch {
    alert("hi")
}
`)
	if out != "hi\n" {
		t.Fatalf("stdout = %q, want %q", out, "hi\n")
	}
}

// TestEmitRunRecordConcatForList exercises three of Task 10's future golden
// ingredients together — a record global with field defaults (including a
// nested enum default), a string built via concatenation, and a `for x in
// list` loop — as a single compile-and-run check, pre-flighting that they
// interoperate correctly in one program before any golden harness exists.
func TestEmitRunRecordConcatForList(t *testing.T) {
	out := buildAndRun(t, `enum Status { Open, Closed }

record Bookmark {
    title: string(40) = "untitled"
    visits: int = 1
    status: Status
}

var b: Bookmark

func greeting(name: string): string {
    return "hi " + name
}

on App.launch {
    var names: list of string
    var total: string = ""

    names.push("ada")
    names.push("grace")

    alert(b.title)
    b.visits = b.visits + 1
    if b.visits == 2 {
        alert("visits ok")
    }
    if b.status == Open {
        alert("open")
    }

    for n in names {
        total = total + greeting(n) + " "
    }
    alert(total)
}
`)
	want := "untitled\nvisits ok\nopen\nhi ada hi grace \n"
	if out != want {
		t.Fatalf("stdout = %q, want %q", out, want)
	}
}
