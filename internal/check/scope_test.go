package check

import (
	"testing"

	"clarus/internal/types"
)

func TestScope(t *testing.T) {
	outer := NewScope(nil)
	if err := outer.Declare(Symbol{Name: "x", Type: types.IntT}); err != nil {
		t.Fatal(err)
	}
	if err := outer.Declare(Symbol{Name: "x", Type: types.BoolT}); err == nil {
		t.Fatal("expected redeclaration error")
	}

	inner := NewScope(outer)
	if err := inner.Declare(Symbol{Name: "x", Type: types.BoolT}); err != nil {
		t.Fatal("shadowing outer scope should be allowed:", err)
	}
	sym, ok := inner.Lookup("x")
	if !ok || sym.Type != types.BoolT {
		t.Fatal("inner lookup should see the shadowed bool")
	}

	if sym, ok := outer.Lookup("x"); !ok || sym.Type != types.IntT {
		t.Fatal("outer lookup unaffected by shadowing")
	}
	if _, ok := inner.Lookup("nope"); ok {
		t.Fatal("lookup of undeclared name should fail")
	}
}
