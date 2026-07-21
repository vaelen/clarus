package check

import (
	"clarus/internal/parser"
	"clarus/internal/source"
	"strings"
	"testing"
)

func diagsFor(t *testing.T, src string) []string {
	t.Helper()
	f := &source.File{Name: "t.cla", Content: []byte(src)}
	tree, pd := parser.Parse(f)
	if len(pd) > 0 {
		t.Fatalf("parse: %v", pd[0])
	}
	var out []string
	for _, d := range File(f, tree) {
		out = append(out, d.Msg)
	}
	return out
}

func expectClean(t *testing.T, src string) {
	t.Helper()
	if ds := diagsFor(t, src); len(ds) != 0 {
		t.Fatalf("want clean, got: %v", ds)
	}
}

func expectError(t *testing.T, src, substr string) {
	t.Helper()
	ds := diagsFor(t, src)
	for _, d := range ds {
		if strings.Contains(d, substr) {
			return
		}
	}
	t.Fatalf("want error containing %q, got %v", substr, ds)
}

func TestExprRules(t *testing.T) {
	expectClean(t, "var a: int = 3 + 4 * 5\n")
	expectClean(t, "var f: fixed = 1.5 + 2.0\n")
	expectError(t, "var a: fixed = 1 + 1.5\n", "mixed int/fixed")
	expectError(t, "var a: int = 1.5 & 2.0\n", "bitwise operator requires int")
	expectClean(t, "var a: int = 3 << 8 | 42\n")
	expectClean(t, "var s: string = \"a\" + \"b\"\n")
	expectError(t, "var b: bool = 1 and true\n", "condition must be bool")
	expectClean(t, "var i: int = 42\nvar f: fixed = fixed(i)\n")
	expectClean(t, "var c: char = char(65)\nvar i: int = int(c)\n")
	expectError(t, "var f: fixed = fixed(1.5)\n", "cannot convert")
}

func TestEnumRules(t *testing.T) {
	expectClean(t, "enum E { A, B, C }\nvar e: E = B\nvar n: int = int(e)\nvar back: E = E(n)\n")
	expectError(t, "enum E { A, B }\nvar e: E = A\nvar bad: bool = e < B\n", "not ordered")
	expectError(t, "enum E { A 0x10, B 0x10 }\n", "duplicate enum value")
	expectError(t, "enum E { A 70000 }\n", "out of range")
	expectClean(t, "enum E { A, M 0x10 \"Dogcow\", N }\nvar e: E = N\n") // N = 0x11
	expectError(t, "enum E { A }\nenum F { A }\nvar e: E = A\nvar f: F = e\n", "cannot assign")
}

func TestDeclareBeforeUse(t *testing.T) {
	expectError(t, "var a: int = b\nvar b: int = 1\n", "undefined: b")
	expectError(t, "var a: int = 1\nvar a: int = 2\n", "redeclaration")
}

func TestCollections(t *testing.T) {
	expectClean(t, `var l: list of int
func f() {
    var x: int

    l.push(3)
    x = l.pop()
    x = l.first()
    l.unshift(x)
}
`)
	expectClean(t, "var m: map of int\nfunc f() {\n    var x: int\n\n    x = m.get(\"k\", 0)\n}\n")
	expectError(t, "var l: list of int\nfunc f() {\n    l.push(true)\n}\n", "cannot use bool")
	expectClean(t, `var t: text
func crc(data: text): int {
    var c: int = 0
    var i: int = 0

    while i < data.length {
        c = c ^ int(data[i])
        i = i + 1
    }
    return c
}
`)
}
