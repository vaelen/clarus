package lower

import (
	"clarus/internal/ast"
	"clarus/internal/check"
	"clarus/internal/ir"
	"clarus/internal/parser"
	"clarus/internal/source"
	"testing"
)

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
	p, ld := Program([]*source.File{f}, []*ast.File{tree}, info)
	if len(ld) > 0 {
		t.Fatal(ld[0])
	}
	return p
}

func TestLowerArith(t *testing.T) {
	p := lowerSrc(t, "var x: int = 3 + 4 * 5\n")
	b := p.Globals[0].Init.(*ir.Bin)
	if b.Op != "+" || b.Ty.K != ir.Int {
		t.Fatalf("root: %+v", b)
	}
}

func TestLowerFixedMul(t *testing.T) {
	p := lowerSrc(t, "var f: fixed = 1.5 * 2.0\n")
	in := p.Globals[0].Init.(*ir.Intr)
	if in.Name != ir.IFixMul {
		t.Fatalf("want fix_mul, got %s", in.Name)
	}
	if c := in.Args[0].(*ir.IntConst); c.V != 98304 {
		t.Fatalf("raw 1.5: %d", c.V)
	}
}

func TestLowerStringConcat(t *testing.T) {
	p := lowerSrc(t, `var s: string = "a" + "b"`+"\n")
	in := p.Globals[0].Init.(*ir.Intr)
	if in.Name != ir.IStrConcat {
		t.Fatalf("want str_concat, got %s", in.Name)
	}
	if len(p.StrLits) != 2 {
		t.Fatalf("literal pool: %v", p.StrLits)
	}
}

func TestLowerEnumConst(t *testing.T) {
	p := lowerSrc(t, "enum E { A, M 0x10 }\nvar e: E = M\n")
	c := p.Globals[0].Init.(*ir.IntConst)
	if c.V != 0x10 || c.Ty.K != ir.Enum || c.Ty.Name != "E" {
		t.Fatalf("%+v", c)
	}
}

func TestUnsupportedWindow(t *testing.T) {
	f := &source.File{Name: "t.cla", Content: []byte("window W {\n    title: \"x\"\n}\n")}
	tree, _ := parser.Parse(f)
	_, info := check.Files([]*source.File{f}, []*ast.File{tree})
	_, ld := Program([]*source.File{f}, []*ast.File{tree}, info)
	if len(ld) == 0 {
		t.Fatal("want unsupported diagnostic for window")
	}
}
