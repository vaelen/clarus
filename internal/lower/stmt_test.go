package lower

import (
	"clarus/internal/ir"
	"testing"
)

func TestLowerFuncLocalsWhile(t *testing.T) {
	p := lowerSrc(t, `func demo() {
    var i: int = 0
    var s: string
    while i < 3 {
        s = s + "x"
        i = i + 1
    }
}
`)
	fn := p.Funcs[0]
	if len(fn.Locals) != 2 {
		t.Fatalf("want 2 locals, got %d: %+v", len(fn.Locals), fn.Locals)
	}
	w, ok := fn.Body[1].(*ir.While)
	if !ok {
		t.Fatalf("body[1] not *ir.While: %T", fn.Body[1])
	}
	store, ok := w.Body[0].(*ir.StoreStr)
	if !ok {
		t.Fatalf("want StoreStr, got %T", w.Body[0])
	}
	in, ok := store.Src.(*ir.Intr)
	if !ok || in.Name != ir.IStrConcat {
		t.Fatalf("want str_concat Src, got %+v", store.Src)
	}
}

func TestLowerAppLaunch(t *testing.T) {
	p := lowerSrc(t, "on App.launch {\n    alert(\"hi\")\n}\n")
	if !p.HasLaunch {
		t.Fatal("want HasLaunch")
	}
	var fn *ir.Func
	for _, f := range p.Funcs {
		if f.Name == "handler_App_launch" {
			fn = f
		}
	}
	if fn == nil {
		t.Fatalf("handler_App_launch not found in %+v", p.Funcs)
	}
	es, ok := fn.Body[0].(*ir.ExprStmt)
	if !ok {
		t.Fatalf("body[0] not *ir.ExprStmt: %T", fn.Body[0])
	}
	in, ok := es.X.(*ir.Intr)
	if !ok || in.Name != ir.IAlert {
		t.Fatalf("want alert intrinsic, got %+v", es.X)
	}
}
