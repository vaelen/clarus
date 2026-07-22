package cprint

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"
	"testing"

	"clarus/internal/ast"
	"clarus/internal/check"
	"clarus/internal/ir"
	"clarus/internal/lower"
	"clarus/internal/parser"
	"clarus/internal/source"
)

// ccPath returns the C compiler to invoke, mirroring build.CCPath — this
// package can't import internal/build for it since build now imports
// cprint (Task 9 wires Build to Emit), which would be an import cycle in
// this test.
func ccPath() string {
	if c := os.Getenv("CC"); c != "" {
		return c
	}
	return "cc"
}

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
	rtH, err := os.ReadFile("../build/rt/rt.h")
	if err != nil {
		t.Fatal(err)
	}
	rtC, err := os.ReadFile("../build/rt/rt.c")
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
	cmd := exec.Command(ccPath(), "-std=c99", "-Wall", "-Werror", main, filepath.Join(dir, "rt.c"), "-o", exe)
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

// ---- Critical 1: list-mutation aliasing (l.push(l[0])) ----

// TestListPushSelfAliasStructural is the structural half of Critical 1's
// fix: `l.push(l[0])` must copy l[0] into its own temp before rt_list_push
// runs, never hand rt_list_push a live rt_list_at pointer into l's own
// storage directly — rt_list_push's internal realloc (rt.c's `grow`) can
// free that pointer's block before rt_list_push's own memmove reads it
// (ASan-confirmed use-after-free pre-fix).
func TestListPushSelfAliasStructural(t *testing.T) {
	p := lowerSrc(t, `on App.launch {
    var l: list of int
    l.push(1)
    l.push(l[0])
}
`)
	c := string(Emit(p))
	if strings.Contains(c, "rt_list_push(cv_l, &(*(int32_t*)rt_list_at") {
		t.Fatalf("emitted C pushes a live rt_list_at pointer straight into rt_list_push (UAF hazard):\n%s", c)
	}
	m := regexp.MustCompile(`(t\d+) = \(\*\(int32_t\*\)rt_list_at\(cv_l, \(int32_t\)\(0\)\)\);`).FindStringSubmatch(c)
	if m == nil {
		t.Fatalf("expected l[0] to be read into its own temp:\n%s", c)
	}
	want := fmt.Sprintf("rt_list_push(cv_l, &(%s));", m[1])
	if !strings.Contains(c, want) {
		t.Fatalf("expected %q (pushing the temp's address) in emitted C:\n%s", want, c)
	}
}

// TestListPushSelfAliasBehavioral is Critical 1's behavioral check: loop
// `l.push(l[0])` enough times (45) to force several rt_list backing-store
// reallocs (cap doubles 4->8->16->32->64), and confirm the list ends up the
// right size with every element intact. A live UAF would either crash
// under ASan or, even without ASan, risk corrupting an element via a freed
// read — this pins both.
func TestListPushSelfAliasBehavioral(t *testing.T) {
	out := buildAndRun(t, `on App.launch {
    var l: list of int
    var i: int
    l.push(1)
    for i in 1 to 45 {
        l.push(l[0])
    }
    if l.count == 46 {
        alert("count ok")
    }
    if l[0] == 1 {
        alert("first ok")
    }
    if l[45] == 1 {
        alert("last ok")
    }
}
`)
	want := "count ok\nfirst ok\nlast ok\n"
	if out != want {
		t.Fatalf("stdout = %q, want %q", out, want)
	}
}

// ---- Critical 2: and/or short-circuit with materialized temps ----

// TestShortCircuitOrSkipsRHS is the reviewer's repro: `left() == "aa" or
// right() == "bb"` with a true LHS must never call right() — pre-fix, the
// RHS's string-compare temp (materializing right()'s call result so its
// address can be taken) was emitted unconditionally before the `||`, so
// right() always ran.
func TestShortCircuitOrSkipsRHS(t *testing.T) {
	out := buildAndRun(t, `var leftCount: int = 0
var rightCount: int = 0

func left(): string {
    leftCount = leftCount + 1
    return "aa"
}
func right(): string {
    rightCount = rightCount + 1
    return "bb"
}

on App.launch {
    if left() == "aa" or right() == "bb" {
        alert("matched")
    }
    if leftCount == 1 {
        alert("left once")
    }
    if rightCount == 0 {
        alert("right never")
    }
}
`)
	want := "matched\nleft once\nright never\n"
	if out != want {
		t.Fatalf("stdout = %q, want %q", out, want)
	}
}

// TestShortCircuitAndSkipsRHS mirrors the above for `and`: a false LHS
// must never evaluate the RHS.
func TestShortCircuitAndSkipsRHS(t *testing.T) {
	out := buildAndRun(t, `var leftCount: int = 0
var rightCount: int = 0

func left(): string {
    leftCount = leftCount + 1
    return "zz"
}
func right(): string {
    rightCount = rightCount + 1
    return "bb"
}

on App.launch {
    if left() == "aa" and right() == "bb" {
        alert("matched")
    } else {
        alert("not matched")
    }
    if leftCount == 1 {
        alert("left once")
    }
    if rightCount == 0 {
        alert("right never")
    }
}
`)
	want := "not matched\nleft once\nright never\n"
	if out != want {
		t.Fatalf("stdout = %q, want %q", out, want)
	}
}

// TestPlainAndOrNoTempChurn is a structural guard against churn: when
// neither operand needs a statement-level temp (two plain bool locals),
// `and`/`or` must stay a single plain C &&/|| — no if-expansion.
func TestPlainAndOrNoTempChurn(t *testing.T) {
	p := lowerSrc(t, `on App.launch {
    var a: bool = true
    var b: bool = false
    if a and b {
        alert("yes")
    }
}
`)
	c := string(Emit(p))
	if !strings.Contains(c, "if (cv_a && cv_b) {") {
		t.Fatalf("expected a plain `if (cv_a && cv_b)` (no if-expansion churn) in emitted C:\n%s", c)
	}
}

// TestShortCircuitNestedChain covers a nested and/or chain composing
// correctly: `f() == "x" or g() == "y" or h() == "z"` with f matching must
// call only f, never g or h.
func TestShortCircuitNestedChain(t *testing.T) {
	out := buildAndRun(t, `var fCount: int = 0
var gCount: int = 0
var hCount: int = 0

func f(): string {
    fCount = fCount + 1
    return "x"
}
func g(): string {
    gCount = gCount + 1
    return "y"
}
func h(): string {
    hCount = hCount + 1
    return "z"
}

on App.launch {
    if f() == "x" or g() == "y" or h() == "z" {
        alert("matched")
    }
    if fCount == 1 {
        alert("f once")
    }
    if gCount == 0 {
        alert("g never")
    }
    if hCount == 0 {
        alert("h never")
    }
}
`)
	want := "matched\nf once\ng never\nh never\n"
	if out != want {
		t.Fatalf("stdout = %q, want %q", out, want)
	}
}
