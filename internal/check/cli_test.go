// internal/check/cli_test.go: checker coverage for the CLI/self-hosting
// features plan — const, break/continue, switch, slices, indexOf, text
// append, App.startCLI, and log (Ch3/Ch5/Ch7/Ch12).
package check

import (
	"strings"
	"testing"

	"clarus/internal/parser"
	"clarus/internal/source"
)

func TestConstDecl(t *testing.T) {
	expectClean(t, "const maxTokens: int = 4096\nvar x: int = maxTokens + 1\n")
	expectClean(t, "const versionTag: string = \"clarusc 0.1\"\nvar s: string = versionTag\n")
	expectClean(t, "enum EventKind { Click, Drag, Release }\nconst startState: EventKind = Click\nvar e: EventKind = startState\n")
	expectClean(t, "const a: int = 1\nconst b: int = a\n") // prior-const initializer
	expectClean(t, "const c: char = 'x'\nconst f: fixed = 1.5\nconst b: bool = true\n")

	expectError(t, "const a: int = 1\nconst a: int = 2\n", "redeclaration")
	expectError(t, "var x: int = 1\nconst a: int = x\n", "constant initializer must be a literal, enum member, or constant")
	expectError(t, "const a: int = \"s\"\n", "cannot assign")
	expectError(t, "const a: int = 1\nconst b: string = a\n", "cannot assign")
	expectError(t, `const a: int = 1
func f() {
    a = 2
}
`, "cannot assign to constant a")
}

func TestBreakContinue(t *testing.T) {
	expectClean(t, `var i: int = 0
func f() {
    while i < 10 {
        if i == 5 { break }
        i = i + 1
        continue
    }
}
`)
	expectClean(t, `func f() {
    for i in 1 to 10 {
        if i == 5 { break }
        continue
    }
}
`)
	expectError(t, "func f() {\n    break\n}\n", "break is only valid inside a loop")
	expectError(t, "func f() {\n    continue\n}\n", "continue is only valid inside a loop")

	// A break inside a switch case body binds the enclosing LOOP, not the
	// switch (Ch5: Switch — "a break inside a case body belongs to the
	// enclosing loop, if any").
	expectClean(t, `func f() {
    var i: int = 0

    while i < 10 {
        switch i {
        case 5 {
            break
        }
        }
        i = i + 1
    }
}
`)
	expectError(t, `func f() {
    switch 1 {
    case 1 {
        break
    }
    }
}
`, "break is only valid inside a loop")
}

func TestSwitchStmt(t *testing.T) {
	expectClean(t, `func f(tok: int) {
    switch tok {
    case 1 {
    }
    case 2, 3 {
    }
    else {
    }
    }
}
`)
	expectClean(t, "enum E { A, B, C }\nfunc f(e: E) {\n    switch e {\n    case A {\n    }\n    case B, C {\n    }\n    }\n}\n")
	expectClean(t, "func f(s: string) {\n    switch s {\n    case \"a\" {\n    }\n    else {\n    }\n    }\n}\n")
	expectClean(t, "const limit: int = 5\nfunc f(x: int) {\n    switch x {\n    case limit {\n    }\n    }\n}\n") // const as case label

	expectError(t, "func f(b: bool) {\n    switch b {\n    case true {\n    }\n    }\n}\n", "switch operand must be int, char, enum, or string")
	expectError(t, "func f(t: text) {\n    switch t {\n    else {\n    }\n    }\n}\n", "switch operand must be int, char, enum, or string")
	expectError(t, `func f(x: int) {
    var y: int = 2
    switch x {
    case y {
    }
    }
}
`, "case label must be a constant")
	expectError(t, `func f(x: int) {
    switch x {
    case 1, 1 {
    }
    }
}
`, "duplicate case label")
	expectError(t, `const c: int = 1
func f(x: int) {
    switch x {
    case 1 {
    }
    case c {
    }
    }
}
`, "duplicate case label")
}

func TestSliceExpr(t *testing.T) {
	expectClean(t, "var s: string = \"hello world\"\nvar w: string = s[6, 5]\n")
	expectClean(t, "var t: text\nvar w: string\nfunc f() {\n    w = t[0, 3]\n}\n")

	expectError(t, "var i: int = 3\nvar w: string\nfunc f() {\n    w = i[0, 1]\n}\n", "cannot slice int")
	expectError(t, "var s: string = \"x\"\nvar w: string\nfunc f() {\n    w = s[true, 1]\n}\n", "slice start must be int")
	expectError(t, "var s: string = \"x\"\nvar w: string\nfunc f() {\n    w = s[0, true]\n}\n", "slice length must be int")
}

// TestSliceNotAssignable documents that "slices are not assignable" is a
// parser-level diagnostic (internal/parser/expr_test.go:TestSliceNotAssignable,
// Task 1): parsePrimary's `(` case is transparent (it returns the inner
// expression unwrapped rather than a Paren node), so even a parenthesized
// slice like `(s[1,2]) = x` still reaches parseSimpleStmt as a bare
// *ast.SliceExpr and is rejected there. No path reaches the checker with a
// SliceExpr in assignment-LHS position, so no checker-level guard exists.
func TestSliceNotAssignable(t *testing.T) {
	src := "func f() {\n    (s[1, 2]) = x\n}\n"
	_, diags := parser.Parse(&source.File{Name: "t.cla", Content: []byte(src)})
	found := false
	for _, d := range diags {
		if strings.Contains(d.Msg, "slices are not assignable") {
			found = true
		}
	}
	if !found {
		t.Fatalf("want a parse-time slices-are-not-assignable error, got %v", diags)
	}
}

func TestIndexOfAndAppend(t *testing.T) {
	expectClean(t, `var s: string = "hello"
func f() {
    var i: int = s.indexOf('l')
    var j: int = s.indexOf("lo")
}
`)
	expectClean(t, `var t: text
func f() {
    var i: int = t.indexOf('l')
    var j: int = t.indexOf("lo")
}
`)
	expectClean(t, `var t: text
var s: string = "x"
func f() {
    t.append("world")
    t.append('!')
    t.append(t)
    t.append(s)
}
`)
	expectError(t, "var s: string = \"hi\"\nfunc f() {\n    s.append(\"x\")\n}\n", "undefined: append")
	expectError(t, "var s: string = \"hi\"\nfunc f() {\n    s.indexOf(3)\n}\n", "cannot use int here (expected string or char)")
}

func TestStartCLIEvent(t *testing.T) {
	expectClean(t, "on App.startCLI(args: list of string) {\n}\n")
	expectError(t, "on App.startCLI(args: int) {\n}\n", "takes")
	expectError(t, "func f() {\n    var x: string = App.args\n}\n", "undefined: App")
}

func TestLogBuiltin(t *testing.T) {
	expectClean(t, "func f() {\n    log(\"hello\")\n}\n")
	expectError(t, "func f() {\n    log(3)\n}\n", "cannot use int")
}

func TestQuitCode(t *testing.T) {
	expectClean(t, "func f() {\n    quit\n}\n")
	expectClean(t, "func f() {\n    quit 2\n}\n")
	expectError(t, "func f() {\n    quit true\n}\n", "quit code must be int")
}
