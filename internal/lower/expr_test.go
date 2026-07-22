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

func TestLowerNewNested(t *testing.T) {
	p := lowerSrc(t, "record Person {\n    age: int\n}\nvar ok: bool = new Person.age > 0\n")
	b := p.Globals[0].Init.(*ir.Bin)
	fr := b.X.(*ir.FieldRef)
	if fr.Name != "age" {
		t.Fatalf("field: %+v", fr)
	}
	nr := fr.X.(*ir.NewRec)
	if nr.RecName != "Person" {
		t.Fatalf("newrec: %+v", nr)
	}
}

func TestLowerNewWhole(t *testing.T) {
	p := lowerSrc(t, "record Person {\n    age: int\n}\nvar b: Person = new Person\n")
	nr := p.Globals[0].Init.(*ir.NewRec)
	if nr.RecName != "Person" || nr.Ty.K != ir.Rec || nr.Ty.Name != "Person" {
		t.Fatalf("%+v", nr)
	}
}

func TestLowerRecordEnumFieldDefault(t *testing.T) {
	p := lowerSrc(t, "enum Status { Active 5, Done 6 }\nrecord Job {\n    status: Status\n}\n")
	if p.Records[0].Fields[0].Default != 5 {
		t.Fatalf("want first-member default 5, got %+v", p.Records[0].Fields[0])
	}
}

// TestLowerIsNewGenuineFieldShadowsPseudo confirms a record that genuinely
// declares a field named isNew lowers as a normal FieldRef (no unsupported
// diagnostic) — only the Ch10 pseudo-field (no such declared field) is
// host-unsupported.
func TestLowerIsNewGenuineFieldShadowsPseudo(t *testing.T) {
	p := lowerSrc(t, "record R {\n    isNew: bool\n}\nvar b: bool = new R.isNew\n")
	fr, ok := p.Globals[0].Init.(*ir.FieldRef)
	if !ok || fr.Name != "isNew" {
		t.Fatalf("want FieldRef isNew, got %+v", p.Globals[0].Init)
	}
}

func TestLowerErrVarFieldRefNotLastErrIntrinsic(t *testing.T) {
	p := lowerSrc(t, "func f(): int {\n    var e: error\n    return e.code\n}\n")
	ret := p.Funcs[0].Body[0].(*ir.Return)
	fr, ok := ret.X.(*ir.FieldRef)
	if !ok || fr.Name != "code" {
		t.Fatalf("want FieldRef code (routed to e, not the global), got %+v", ret.X)
	}
}

func TestLowerLastErrorSelectIsIntrinsic(t *testing.T) {
	p := lowerSrc(t, "func f(): int {\n    return lastError.code\n}\n")
	ret := p.Funcs[0].Body[0].(*ir.Return)
	in, ok := ret.X.(*ir.Intr)
	if !ok || in.Name != ir.ILastErrCode {
		t.Fatalf("want lasterr_code intrinsic, got %+v", ret.X)
	}
}

func TestLowerBareLastErrorIsIntrinsic(t *testing.T) {
	p := lowerSrc(t, "func f() {\n    var e: error\n    e = lastError\n}\n")
	asn := p.Funcs[0].Body[0].(*ir.Assign)
	in, ok := asn.Src.(*ir.Intr)
	if !ok || in.Name != ir.ILastErr {
		t.Fatalf("want lasterr_value intrinsic, got %+v", asn.Src)
	}
}

func TestLowerCallArgStrCapacityCoerced(t *testing.T) {
	p := lowerSrc(t, "func f(s: string): string {\n    return s\n}\nvar y: string = f(\"hi\")\n")
	// The string literal "hi" is already string(255) (StringLit's lowered
	// Ty), same as f's declared param capacity, so no coercion is expected
	// here — this pins the no-op case; TestRunGoldens/strcap.cla is the
	// end-to-end proof for an actual capacity mismatch.
	call := p.Globals[0].Init.(*ir.CallFn)
	if _, ok := call.Args[0].(*ir.StrConst); !ok {
		t.Fatalf("want uncoerced StrConst arg (same capacity), got %+v", call.Args[0])
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
