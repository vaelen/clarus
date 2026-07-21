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
