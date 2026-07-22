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

// TestAppleTalkPrefix covers disambiguation of the contextual `appletalk`
// prefix: it is the prefix only when the following token can start a
// primary expression (two adjacent primary-starts are otherwise invalid),
// so `appletalk + 1` and `appletalk(x)` must parse `appletalk` as an
// ordinary identifier, not the prefix.
func TestAppleTalkPrefix(t *testing.T) {
	// f(appletalk "Mac:Srv") -> prefix, one StringLit arg
	e := parseInit(t, `f(appletalk "Mac:Srv")`)
	c := e.(*ast.Call)
	if !c.AppleTalk {
		t.Fatal("expected AppleTalk true")
	}
	if len(c.Args) != 1 {
		t.Fatalf("expected 1 arg, got %d", len(c.Args))
	}
	if _, ok := c.Args[0].(*ast.StringLit); !ok {
		t.Fatalf("expected StringLit arg, got %#v", c.Args[0])
	}

	// f(appletalk) -> not a prefix (nothing follows), plain Ident arg
	e = parseInit(t, "f(appletalk)")
	c = e.(*ast.Call)
	if c.AppleTalk {
		t.Fatal("expected AppleTalk false")
	}
	if len(c.Args) != 1 {
		t.Fatalf("expected 1 arg, got %d", len(c.Args))
	}
	if id, ok := c.Args[0].(*ast.Ident); !ok || id.Name != "appletalk" {
		t.Fatalf("expected Ident appletalk, got %#v", c.Args[0])
	}

	// f(appletalk + 1) -> "+" cannot start a primary, so appletalk is an
	// ordinary identifier and this is a Binary expression.
	e = parseInit(t, "f(appletalk + 1)")
	c = e.(*ast.Call)
	if c.AppleTalk {
		t.Fatal("expected AppleTalk false")
	}
	if len(c.Args) != 1 {
		t.Fatalf("expected 1 arg, got %d", len(c.Args))
	}
	bin, ok := c.Args[0].(*ast.Binary)
	if !ok {
		t.Fatalf("expected Binary arg, got %#v", c.Args[0])
	}
	if id, ok := bin.X.(*ast.Ident); !ok || id.Name != "appletalk" {
		t.Fatalf("expected Binary.X to be Ident appletalk, got %#v", bin.X)
	}

	// f(appletalk(x)) -> "(" cannot start a primary either (it's a call of
	// a function literally named appletalk).
	e = parseInit(t, "f(appletalk(x))")
	c = e.(*ast.Call)
	if c.AppleTalk {
		t.Fatal("expected AppleTalk false")
	}
	if len(c.Args) != 1 {
		t.Fatalf("expected 1 arg, got %d", len(c.Args))
	}
	inner, ok := c.Args[0].(*ast.Call)
	if !ok {
		t.Fatalf("expected Call arg, got %#v", c.Args[0])
	}
	if id, ok := inner.Fn.(*ast.Ident); !ok || id.Name != "appletalk" {
		t.Fatalf("expected inner call Fn to be Ident appletalk, got %#v", inner.Fn)
	}

	// f(appletalk name) -> IDENT can start a primary, so appletalk is the
	// prefix and "name" is the (Ident) argument expression.
	e = parseInit(t, "f(appletalk name)")
	c = e.(*ast.Call)
	if !c.AppleTalk {
		t.Fatal("expected AppleTalk true")
	}
	if len(c.Args) != 1 {
		t.Fatalf("expected 1 arg, got %d", len(c.Args))
	}
	if id, ok := c.Args[0].(*ast.Ident); !ok || id.Name != "name" {
		t.Fatalf("expected Ident name, got %#v", c.Args[0])
	}
}

// TestUnaryStacks covers Finding 2: unary operators may stack (`not not b`),
// matching the corrected grammar `unaryExpr = { "-" | "not" | "~" } postfix`.
func TestUnaryStacks(t *testing.T) {
	e := parseInit(t, "not not b")
	outer, ok := e.(*ast.Unary)
	if !ok || outer.Op != "not" {
		t.Fatalf("expected outer Unary(not), got %#v", e)
	}
	inner, ok := outer.X.(*ast.Unary)
	if !ok || inner.Op != "not" {
		t.Fatalf("expected inner Unary(not), got %#v", outer.X)
	}
	if id, ok := inner.X.(*ast.Ident); !ok || id.Name != "b" {
		t.Fatalf("expected Ident b, got %#v", inner.X)
	}
}
