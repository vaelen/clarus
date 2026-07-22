// internal/parser/stmt_test.go
package parser

import (
	"clarus/internal/ast"
	"clarus/internal/source"
	"strings"
	"testing"
)

func parseFunc(t *testing.T, body string) *ast.Block {
	t.Helper()
	src := "func f() {\n" + body + "\n}\n"
	f, diags := Parse(&source.File{Name: "t.cla", Content: []byte(src)})
	if len(diags) > 0 {
		t.Fatalf("unexpected diags: %v", diags[0])
	}
	return f.Decls[0].(*ast.FuncDecl).Body
}

func TestStatements(t *testing.T) {
	b := parseFunc(t, `
var i: int = 0
var done: bool

while i < 10 and not done {
    i = i + 1
}
if i == 10 {
    done = true
} else if i > 3 {
    done = false
} else {
    quit
}
for x in items {
    total = total + x
}
for k, v in scores {
    sum = sum + v
}
for j in 0 to 9 {
    sum = sum + j
}
return i`)
	if len(b.Vars) != 2 {
		t.Fatalf("want 2 vars, got %d", len(b.Vars))
	}
	if len(b.Stmts) != 6 {
		t.Fatalf("want 6 statements, got %d", len(b.Stmts))
	}
	fr := b.Stmts[4].(*ast.ForStmt)
	if fr.ToExpr == nil || fr.V1 != "j" {
		t.Fatal("range for")
	}
	fm := b.Stmts[3].(*ast.ForStmt)
	if fm.V2 != "v" {
		t.Fatal("map for")
	}
}

func TestVarAfterStmtRejected(t *testing.T) {
	src := "func f() {\nquit\nvar x: int\n}\n"
	_, diags := Parse(&source.File{Name: "t.cla", Content: []byte(src)})
	if len(diags) == 0 || !strings.Contains(diags[0].Msg, "top of the body") {
		t.Fatalf("want var-at-top error, got %v", diags)
	}
}

func TestVarInNestedBlockRejected(t *testing.T) {
	src := "func demo(): int {\n" +
		"    if true { var x: int = 1\n" +
		"        return x }\n" +
		"    return 0\n" +
		"}\n"
	_, diags := Parse(&source.File{Name: "t.cla", Content: []byte(src)})
	if len(diags) == 0 || !strings.Contains(diags[0].Msg, "only allowed at the top of a function or handler body") {
		t.Fatalf("want nested-var error, got %v", diags)
	}
}

func TestVarsAtTopWithNestedIfNoVars(t *testing.T) {
	b := parseFunc(t, `
var x: int = 1
if x > 0 {
    x = x + 1
}
return x`)
	if len(b.Vars) != 1 {
		t.Fatalf("want 1 var, got %d", len(b.Vars))
	}
}

func TestEveryBlockAllowsTopVars(t *testing.T) {
	src := "func f() {\n}\nevery 1 ticks {\n    var t: int = 0\n    t = t + 1\n}\n"
	f, diags := Parse(&source.File{Name: "t.cla", Content: []byte(src)})
	if len(diags) > 0 {
		t.Fatalf("unexpected diags: %v", diags[0])
	}
	ev := f.Decls[1].(*ast.EveryDecl)
	if len(ev.Body.Vars) != 1 {
		t.Fatalf("want 1 var in every block, got %d", len(ev.Body.Vars))
	}
}

func TestElseOnOwnLineRejected(t *testing.T) {
	src := "func f() {\nif true {\n}\nelse {\n}\n}\n"
	_, diags := Parse(&source.File{Name: "t.cla", Content: []byte(src)})
	if len(diags) == 0 || !strings.Contains(diags[0].Msg, "expected expression, found 'else'") {
		t.Fatalf("want else-on-own-line error, got %v", diags)
	}
}

func TestFuncDeclForms(t *testing.T) {
	src := "func add(a: int, b: int): int {\n    return a + b\n}\nfunc log(msg: string) {\n    quit\n}\n"
	f, diags := Parse(&source.File{Name: "t.cla", Content: []byte(src)})
	if len(diags) > 0 {
		t.Fatalf("unexpected diags: %v", diags[0])
	}

	fn := f.Decls[0].(*ast.FuncDecl)
	if len(fn.Params) != 2 || fn.Params[0].Name != "a" || fn.Params[1].Name != "b" {
		t.Fatalf("want 2 params a, b; got %+v", fn.Params)
	}
	nt, ok := fn.Ret.(*ast.NamedType)
	if !ok || nt.Name != "int" {
		t.Fatalf("want return type int, got %#v", fn.Ret)
	}

	proc := f.Decls[1].(*ast.FuncDecl)
	if len(proc.Params) != 1 || proc.Params[0].Name != "msg" {
		t.Fatalf("want 1 param msg; got %+v", proc.Params)
	}
	if proc.Ret != nil {
		t.Fatalf("want no return type for a procedure, got %#v", proc.Ret)
	}
}

func TestQuitCode(t *testing.T) {
	b := parseFunc(t, "quit 2")
	q := b.Stmts[0].(*ast.QuitStmt)
	lit, ok := q.Code.(*ast.IntLit)
	if !ok || lit.Val != 2 {
		t.Fatalf("quit 2: want IntLit(2), got %#v", q.Code)
	}

	b = parseFunc(t, "quit\nreturn")
	bare := b.Stmts[0].(*ast.QuitStmt)
	if bare.Code != nil {
		t.Fatalf("bare quit: want nil Code, got %#v", bare.Code)
	}

	// quit as the last statement in a block: the closing '}' ends it, same
	// as a NEWLINE would.
	src := "func f() {\nif true {\n    quit\n}\n}\n"
	f, diags := Parse(&source.File{Name: "t.cla", Content: []byte(src)})
	if len(diags) > 0 {
		t.Fatalf("unexpected diags: %v", diags[0])
	}
	inner := f.Decls[0].(*ast.FuncDecl).Body.Stmts[0].(*ast.IfStmt).Then
	end := inner.Stmts[0].(*ast.QuitStmt)
	if end.Code != nil {
		t.Fatalf("quit at end-of-block: want nil Code, got %#v", end.Code)
	}
}

func TestBreakContinue(t *testing.T) {
	b := parseFunc(t, `
while true {
    if x == 1 { break }
    if x == 2 { continue }
}`)
	w := b.Stmts[0].(*ast.WhileStmt)
	brk := w.Body.Stmts[0].(*ast.IfStmt).Then.Stmts[0]
	if _, ok := brk.(*ast.BreakStmt); !ok {
		t.Fatalf("want BreakStmt, got %#v", brk)
	}
	cont := w.Body.Stmts[1].(*ast.IfStmt).Then.Stmts[0]
	if _, ok := cont.(*ast.ContinueStmt); !ok {
		t.Fatalf("want ContinueStmt, got %#v", cont)
	}
}

func TestSwitchStmt(t *testing.T) {
	b := parseFunc(t, `
switch tok {
case KwIf {
    parseIf()
}
case KwWhile, KwFor {
    parseLoop()
}
else {
    syntaxError()
}
}`)
	sw := b.Stmts[0].(*ast.SwitchStmt)
	if _, ok := sw.Subject.(*ast.Ident); !ok {
		t.Fatalf("subject: %#v", sw.Subject)
	}
	if len(sw.Cases) != 2 {
		t.Fatalf("want 2 cases, got %d", len(sw.Cases))
	}
	if len(sw.Cases[0].Labels) != 1 {
		t.Fatalf("first case: want 1 label, got %d", len(sw.Cases[0].Labels))
	}
	if len(sw.Cases[1].Labels) != 2 {
		t.Fatalf("second case: want 2 labels (multi-label), got %d", len(sw.Cases[1].Labels))
	}
	if len(sw.Cases[1].Body.Stmts) != 1 {
		t.Fatalf("second case body: %d stmts", len(sw.Cases[1].Body.Stmts))
	}
	if sw.Else == nil || len(sw.Else.Stmts) != 1 {
		t.Fatalf("else: %#v", sw.Else)
	}
}

func TestSwitchCaseAfterElseRejected(t *testing.T) {
	src := "func f() {\nswitch x {\nelse {\n}\ncase Y {\n}\n}\n}\n"
	_, diags := Parse(&source.File{Name: "t.cla", Content: []byte(src)})
	if len(diags) == 0 || !strings.Contains(diags[0].Msg, "expected '}'") {
		t.Fatalf("want expected '}' error, got %v", diags)
	}
}

func TestSwitchZeroCasesWithElse(t *testing.T) {
	b := parseFunc(t, "switch x {\nelse {\n}\n}")
	sw := b.Stmts[0].(*ast.SwitchStmt)
	if len(sw.Cases) != 0 || sw.Else == nil {
		t.Fatalf("want 0 cases with else, got %#v", sw)
	}
}

func TestOpenCloseEdit(t *testing.T) {
	b := parseFunc(t, "open Doc\nclose d\nedit EditForm, bookmarks[i]\nedit EditForm, new Bookmark")
	if b.Stmts[0].(*ast.OpenStmt).Window != "Doc" {
		t.Fatal("open stmt")
	}
	e := b.Stmts[3].(*ast.EditStmt)
	if !e.IsNew || e.NewType != "Bookmark" {
		t.Fatal("edit new form")
	}
}
