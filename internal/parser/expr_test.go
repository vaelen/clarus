// internal/parser/expr_test.go
package parser

import (
	"clarus/internal/ast"
	"clarus/internal/source"
	"testing"
)

// parse a whole file consisting of one global: var x: int = <expr>
func parseInit(t *testing.T, expr string) ast.Expr {
	t.Helper()
	src := "var x: int = " + expr + "\n"
	f, diags := Parse(&source.File{Name: "t.cla", Content: []byte(src)})
	if len(diags) > 0 {
		t.Fatalf("%s: unexpected diags: %v", expr, diags[0])
	}
	return f.Decls[0].(*ast.VarDecl).Init
}

func TestPrecedence(t *testing.T) {
	// (flags & 0x08) != 0 — & binds tighter than !=
	e := parseInit(t, "flags & 0x08 != 0")
	b, ok := e.(*ast.Binary)
	if !ok || b.Op != "!=" {
		t.Fatalf("root should be !=, got %#v", e)
	}
	if inner, ok := b.X.(*ast.Binary); !ok || inner.Op != "&" {
		t.Fatalf("left of != should be &, got %#v", b.X)
	}
	// (3 << 8) | 42
	e = parseInit(t, "3 << 8 | 42")
	b = e.(*ast.Binary)
	if b.Op != "|" {
		t.Fatalf("root should be |, got %q", b.Op)
	}
	// a + b * c — * tighter
	e = parseInit(t, "a + b * c")
	if b = e.(*ast.Binary); b.Op != "+" {
		t.Fatalf("root should be +")
	}
	// mod as operator
	e = parseInit(t, "a mod 3")
	if b = e.(*ast.Binary); b.Op != "mod" {
		t.Fatalf("mod: got %q", b.Op)
	}
}

func TestComparisonNoChain(t *testing.T) {
	src := "var x: bool = a < b < c\n"
	_, diags := Parse(&source.File{Name: "t.cla", Content: []byte(src)})
	if len(diags) == 0 {
		t.Fatal("a < b < c must be a syntax error (comparisons do not chain)")
	}
}

func TestPostfixAndPrimary(t *testing.T) {
	e := parseInit(t, "conn.open(addr)") // open allowed as member name
	c := e.(*ast.Call)
	sel := c.Fn.(*ast.Select)
	if sel.Name != "open" {
		t.Fatalf("member: got %q", sel.Name)
	}
	e = parseInit(t, "bookmarks[i].url")
	if s, ok := e.(*ast.Select); !ok || s.Name != "url" {
		t.Fatalf("index-then-select: %#v", e)
	}
	e = parseInit(t, "not save(window)")
	u := e.(*ast.Unary)
	if u.Op != "not" {
		t.Fatal("unary not")
	}
	if _, ok := u.X.(*ast.Call).Args[0].(*ast.WindowSelf); !ok {
		t.Fatal("window keyword as argument")
	}
	e = parseInit(t, `c.open(appletalk "Mac:Srv")`)
	if !e.(*ast.Call).AppleTalk {
		t.Fatal("appletalk prefix flag")
	}
	e = parseInit(t, "new Bookmark")
	if e.(*ast.NewExpr).Type != "Bookmark" {
		t.Fatal("new expr")
	}
	e = parseInit(t, "open Doc")
	if e.(*ast.OpenExpr).Window != "Doc" {
		t.Fatal("open expr")
	}
}
