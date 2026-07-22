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

// TestLowerSwitchDesugar covers the switch desugar shape (Task 3 plan): the
// subject materializes ONCE into a synthesized temp (an Assign/StoreStr as
// the first lowered statement, never re-lowered per case), followed by an
// if/else-if/else chain — one *ir.If per case, multi-label cases OR'd
// together, terminated by the `else` block.
func TestLowerSwitchDesugar(t *testing.T) {
	p := lowerSrc(t, `var calls: int = 0
func subject(): int {
    calls = calls + 1
    return 2
}
func f() {
    switch subject() {
    case 1 {
    }
    case 2, 3 {
    }
    else {
    }
    }
}
`)
	var fn *ir.Func
	for _, fd := range p.Funcs {
		if fd.Name == "f" {
			fn = fd
		}
	}
	if fn == nil {
		t.Fatalf("func f not found in %+v", p.Funcs)
	}
	if len(fn.Body) != 2 {
		t.Fatalf("want 2 top-level statements (subject store + if-chain), got %d: %+v", len(fn.Body), fn.Body)
	}
	// subject-once: the subject call must appear only in the store, never
	// duplicated into any of the case conditions below.
	store, ok := fn.Body[0].(*ir.Assign)
	if !ok {
		t.Fatalf("body[0] not *ir.Assign (subject store), got %T", fn.Body[0])
	}
	if _, ok := store.Src.(*ir.CallFn); !ok {
		t.Fatalf("subject store Src not a CallFn (subject not materialized once), got %+v", store.Src)
	}
	tmpName := store.Dst.(*ir.VarRef).Name

	case1, ok := fn.Body[1].(*ir.If)
	if !ok {
		t.Fatalf("body[1] not *ir.If, got %T", fn.Body[1])
	}
	cond1, ok := case1.Cond.(*ir.Bin)
	if !ok || cond1.Op != "==" {
		t.Fatalf("case 1 cond not a plain == comparison, got %+v", case1.Cond)
	}
	ref, ok := cond1.X.(*ir.VarRef)
	if !ok || ref.Name != tmpName {
		t.Fatalf("case 1 cond doesn't compare the subject temp %q, got %+v", tmpName, cond1.X)
	}

	// case 2, 3 is the else-branch of case 1, and its Cond is an OR of two
	// equality comparisons against the SAME subject temp.
	if len(case1.Else) != 1 {
		t.Fatalf("case1.Else want 1 stmt (case 2,3's If), got %d: %+v", len(case1.Else), case1.Else)
	}
	case23, ok := case1.Else[0].(*ir.If)
	if !ok {
		t.Fatalf("case1.Else[0] not *ir.If, got %T", case1.Else[0])
	}
	orCond, ok := case23.Cond.(*ir.Bin)
	if !ok || orCond.Op != "or" {
		t.Fatalf("case 2,3 cond not OR'd, got %+v", case23.Cond)
	}

	// the else block is case23's Else, with no further If nesting.
	if len(case23.Else) != 0 {
		t.Fatalf("case23.Else (the switch's `else` block) want empty body, got %+v", case23.Else)
	}
}

// TestLowerSwitchStringSubject covers string-subject case labels comparing
// via IStrCmp == 0 (Ch5: Switch — string is one of the four valid subject
// kinds; text is checker-rejected, so no ITextCmp path is reachable here).
func TestLowerSwitchStringSubject(t *testing.T) {
	p := lowerSrc(t, `func f(s: string) {
    switch s {
    case "a" {
    }
    }
}
`)
	var fn *ir.Func
	for _, fd := range p.Funcs {
		if fd.Name == "f" {
			fn = fd
		}
	}
	ifs := fn.Body[1].(*ir.If)
	eq, ok := ifs.Cond.(*ir.Bin)
	if !ok || eq.Op != "==" {
		t.Fatalf("want a top-level == comparing str_cmp to 0, got %+v", ifs.Cond)
	}
	cmp, ok := eq.X.(*ir.Intr)
	if !ok || cmp.Name != ir.IStrCmp {
		t.Fatalf("want IStrCmp on the LHS, got %+v", eq.X)
	}
	zero, ok := eq.Y.(*ir.IntConst)
	if !ok || zero.V != 0 {
		t.Fatalf("want comparison against IntConst 0, got %+v", eq.Y)
	}
}

// TestLowerBreakContinueNodes covers break/continue lowering to plain
// ir.Break/ir.Continue nodes inside a while body.
func TestLowerBreakContinueNodes(t *testing.T) {
	p := lowerSrc(t, `func f() {
    while true {
        break
        continue
    }
}
`)
	w := p.Funcs[0].Body[0].(*ir.While)
	if _, ok := w.Body[0].(*ir.Break); !ok {
		t.Fatalf("want *ir.Break, got %T", w.Body[0])
	}
	if _, ok := w.Body[1].(*ir.Continue); !ok {
		t.Fatalf("want *ir.Continue, got %T", w.Body[1])
	}
}

// TestLowerSwitchBreakBindsEnclosingLoop is the lowering-side half of Ch5's
// "a break inside a case body belongs to the enclosing loop, if any" rule: a
// break inside a switch case, itself inside a while loop, must lower to a
// plain *ir.Break sitting directly in the case's (desugared If.Then) body —
// no extra wrapper the printer might mistake for binding to the switch
// itself, since the switch desugar emits no loop/switch construct at all.
func TestLowerSwitchBreakBindsEnclosingLoop(t *testing.T) {
	p := lowerSrc(t, `func f() {
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
	w := p.Funcs[0].Body[1].(*ir.While)
	// w.Body[0] = subject store, w.Body[1] = the desugared If chain.
	ifs := w.Body[1].(*ir.If)
	if _, ok := ifs.Then[0].(*ir.Break); !ok {
		t.Fatalf("want the case body's break to lower to a bare *ir.Break, got %T", ifs.Then[0])
	}
}

// TestLowerConstInline covers const uses inlining to a literal (no IR decl
// for the const itself — Program.Globals must stay empty).
func TestLowerConstInline(t *testing.T) {
	p := lowerSrc(t, `const maxTokens: int = 4096
var x: int = maxTokens + 1
const tag: string = "clarusc"
var y: string = tag
`)
	if len(p.Globals) != 2 {
		t.Fatalf("want 2 globals (x, y only — no IR decl for either const), got %d: %+v", len(p.Globals), p.Globals)
	}
	add := p.Globals[0].Init.(*ir.Bin)
	lit, ok := add.X.(*ir.IntConst)
	if !ok || lit.V != 4096 {
		t.Fatalf("want maxTokens inlined to IntConst 4096, got %+v", add.X)
	}
	sc, ok := p.Globals[1].Init.(*ir.StrConst)
	if !ok {
		t.Fatalf("want tag inlined to a StrConst, got %+v", p.Globals[1].Init)
	}
	if p.StrLits[sc.Idx] != "clarusc" {
		t.Fatalf("want the interned literal to be %q, got %q", "clarusc", p.StrLits[sc.Idx])
	}
}

// TestLowerConstAsCaseLabel covers a const used as a switch case label
// (Ch5/Ch3): it must lower through the same const-inlining path as any other
// use, landing as a plain IntConst in the desugared comparison.
func TestLowerConstAsCaseLabel(t *testing.T) {
	p := lowerSrc(t, `const limit: int = 5
func f(x: int) {
    switch x {
    case limit {
    }
    }
}
`)
	ifs := p.Funcs[0].Body[1].(*ir.If)
	eq := ifs.Cond.(*ir.Bin)
	lbl, ok := eq.Y.(*ir.IntConst)
	if !ok || lbl.V != 5 {
		t.Fatalf("want case label inlined to IntConst 5, got %+v", eq.Y)
	}
}

// TestLowerSliceIntrinsic covers string/text slice selecting IStrSlice vs.
// ITextSlice.
func TestLowerSliceIntrinsic(t *testing.T) {
	p := lowerSrc(t, `var s: string = "hello world"
var w: string = s[6, 5]
`)
	in := p.Globals[1].Init.(*ir.Intr)
	if in.Name != ir.IStrSlice {
		t.Fatalf("want IStrSlice, got %+v", in)
	}

	p = lowerSrc(t, `var t: text
var w: string
func f() {
    w = t[0, 3]
}
`)
	store := p.Funcs[0].Body[0].(*ir.StoreStr)
	in = store.Src.(*ir.Intr)
	if in.Name != ir.ITextSlice {
		t.Fatalf("want ITextSlice, got %+v", in)
	}
}

// TestLowerIndexOfIntrinsic covers all four indexOf selections: string/text
// receiver x char/string needle.
func TestLowerIndexOfIntrinsic(t *testing.T) {
	p := lowerSrc(t, `var s: string = "hello"
func f() {
    var i: int = s.indexOf('l')
    var j: int = s.indexOf("lo")
}
`)
	fn := p.Funcs[0]
	if in := fn.Body[0].(*ir.Assign).Src.(*ir.Intr); in.Name != ir.IStrIndexOfChar {
		t.Fatalf("want IStrIndexOfChar, got %+v", in)
	}
	if in := fn.Body[1].(*ir.Assign).Src.(*ir.Intr); in.Name != ir.IStrIndexOfStr {
		t.Fatalf("want IStrIndexOfStr, got %+v", in)
	}

	p = lowerSrc(t, `var t: text
func f() {
    var i: int = t.indexOf('l')
    var j: int = t.indexOf("lo")
}
`)
	fn = p.Funcs[0]
	if in := fn.Body[0].(*ir.Assign).Src.(*ir.Intr); in.Name != ir.ITextIndexOfChar {
		t.Fatalf("want ITextIndexOfChar, got %+v", in)
	}
	if in := fn.Body[1].(*ir.Assign).Src.(*ir.Intr); in.Name != ir.ITextIndexOfStr {
		t.Fatalf("want ITextIndexOfStr, got %+v", in)
	}
}

// TestLowerAppendIntrinsic covers text.append's three argument-kind
// selections: string, char, text.
func TestLowerAppendIntrinsic(t *testing.T) {
	p := lowerSrc(t, `var t: text
var s: string = "x"
func f() {
    t.append("world")
    t.append('!')
    t.append(t)
    t.append(s)
}
`)
	fn := p.Funcs[0]
	want := []string{ir.ITextAppendStr, ir.ITextAppendChar, ir.ITextAppendText, ir.ITextAppendStr}
	for i, w := range want {
		in := fn.Body[i].(*ir.ExprStmt).X.(*ir.Intr)
		if in.Name != w {
			t.Fatalf("append[%d]: want %s, got %s", i, w, in.Name)
		}
	}
}

// TestLowerStartCLI covers `on App.startCLI(args: list of string)` lowering
// to handler_App_startCLI with one List-of-Str param, plus HasStartCLI.
func TestLowerStartCLI(t *testing.T) {
	p := lowerSrc(t, "on App.startCLI(args: list of string) {\n}\n")
	if !p.HasStartCLI {
		t.Fatal("want HasStartCLI")
	}
	var fn *ir.Func
	for _, f := range p.Funcs {
		if f.Name == "handler_App_startCLI" {
			fn = f
		}
	}
	if fn == nil {
		t.Fatalf("handler_App_startCLI not found in %+v", p.Funcs)
	}
	if len(fn.Params) != 1 || fn.Params[0].T.K != ir.List || fn.Params[0].T.Elem.K != ir.Str {
		t.Fatalf("want one List-of-Str param, got %+v", fn.Params)
	}
}

// TestLowerQuitCode covers bare quit defaulting to IntConst 0, and an
// explicit quit code lowering to that same expression.
func TestLowerQuitCode(t *testing.T) {
	p := lowerSrc(t, "func f() {\n    quit\n}\n")
	in := p.Funcs[0].Body[0].(*ir.ExprStmt).X.(*ir.Intr)
	if in.Name != ir.IQuit || len(in.Args) != 1 {
		t.Fatalf("want IQuit with 1 arg, got %+v", in)
	}
	if c, ok := in.Args[0].(*ir.IntConst); !ok || c.V != 0 {
		t.Fatalf("want bare quit's code to be IntConst 0, got %+v", in.Args[0])
	}

	p = lowerSrc(t, "func f() {\n    quit 4\n}\n")
	in = p.Funcs[0].Body[0].(*ir.ExprStmt).X.(*ir.Intr)
	if c, ok := in.Args[0].(*ir.IntConst); !ok || c.V != 4 {
		t.Fatalf("want quit 4's code to be IntConst 4, got %+v", in.Args[0])
	}
}

// TestLowerLogIntrinsic covers `log(...)` lowering to the ILog intrinsic.
func TestLowerLogIntrinsic(t *testing.T) {
	p := lowerSrc(t, "func f() {\n    log(\"hi\")\n}\n")
	in := p.Funcs[0].Body[0].(*ir.ExprStmt).X.(*ir.Intr)
	if in.Name != ir.ILog {
		t.Fatalf("want ILog, got %+v", in)
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
