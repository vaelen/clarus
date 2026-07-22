// Statement, function, and top-level App-handler lowering (Task 7). See the
// lower package doc comment (lower.go) for the host-build-scope contract
// this file also enforces: `open`/`close`/`edit`/`cancel` statements and any
// `on App.*` event other than launch/startEmpty are host-unsupported, same
// as window/menu/extend/every declarations (lower.go's lowerDecl).
package lower

import (
	"fmt"

	"clarus/internal/ast"
	"clarus/internal/ir"
	"clarus/internal/types"
)

// lowerFuncDecl lowers a user function declaration into an ir.Func.
func (l *lowerer) lowerFuncDecl(d *ast.FuncDecl) *ir.Func {
	ret := ir.Type{K: ir.Void}
	if d.Ret != nil {
		t := l.resolveType(d.Ret)
		if what, bad := unsupportedKind(t.Kind); bad {
			l.unsupported(d.P, what)
		} else {
			ret = lowerType(t)
		}
	}
	return l.lowerFuncBody(d.Name, d.Params, ret, d.Body)
}

// lowerTopHandlerDecl lowers a top-level `on App.launch`/`on App.startEmpty`/
// `on App.startCLI` handler into an ir.Func named
// "handler_App_launch"/"handler_App_startEmpty"/"handler_App_startCLI" plus
// the matching Program flag (Ch7: Application Entry Points; the CLI/
// self-hosting features plan adds startCLI, whose single `args: list of
// string` param lowers through the ordinary lowerFuncBody param path —
// nothing startCLI-specific needed there). Any other `on App.*` event
// (openDocument) is host-unsupported. A handler on a resource variable (`on
// someConn.opened`) needs nothing here: check.Files already required the
// variable to exist, and its declaration already flagged the resource type
// itself host-unsupported (unsupportedKind in lower.go) — the handler body
// was never going to be reachable code.
func (l *lowerer) lowerTopHandlerDecl(d *ast.HandlerDecl) {
	if len(d.Path) != 2 || d.Path[0] != "App" {
		return
	}
	switch d.Path[1] {
	case "launch":
		l.prog.Funcs = append(l.prog.Funcs, l.lowerFuncBody("handler_App_launch", nil, ir.Type{K: ir.Void}, d.Body))
		l.prog.HasLaunch = true
	case "startEmpty":
		l.prog.Funcs = append(l.prog.Funcs, l.lowerFuncBody("handler_App_startEmpty", nil, ir.Type{K: ir.Void}, d.Body))
		l.prog.HasStartEmpty = true
	case "startCLI":
		l.prog.Funcs = append(l.prog.Funcs, l.lowerFuncBody("handler_App_startCLI", d.Params, ir.Type{K: ir.Void}, d.Body))
		l.prog.HasStartCLI = true
	default: // openDocument
		l.unsupported(d.P, "on App."+d.Path[1])
	}
}

// lowerFuncBody lowers params and a body into a *ir.Func, opening the
// function-level local scope that lowerIdent (expr.go) consults. The
// signature is registered into l.funcParams/l.funcRet (and l.curFuncRet is
// set) BEFORE the body is lowered — mirroring checker.checkFuncDecl's own
// declare-signature-before-check-body order — so a self-recursive call or a
// `return` inside this very body already sees it, for lowerIdentCall's and
// the Return case's string-capacity coercion (expr.go, this file).
func (l *lowerer) lowerFuncBody(name string, params []ast.Param, ret ir.Type, body *ast.Block) *ir.Func {
	f := &ir.Func{Name: name, Ret: ret}
	l.pushScope()
	defer l.popScope()
	var paramTypes []ir.Type
	for _, p := range params {
		t := l.resolveType(p.Type)
		if what, bad := unsupportedKind(t.Kind); bad {
			l.unsupported(p.P, what)
			continue
		}
		pt := lowerType(t)
		f.Params = append(f.Params, ir.Local{Name: p.Name, T: pt})
		paramTypes = append(paramTypes, pt)
		l.declareLocal(p.Name)
	}
	l.funcParams[name] = paramTypes
	l.funcRet[name] = ret

	savedRet := l.curFuncRet
	l.curFuncRet = ret
	f.Body = l.lowerBlock(body, f)
	l.curFuncRet = savedRet
	return f
}

// lowerBlock lowers one *ast.Block's local vars (declared into f.Locals —
// every nested block's vars flatten into the same function-level list,
// which is what the C printer expects to declare at function scope) then its
// statements, in a scope nested under the caller's (mirrors
// checker.checkBlock). A var with an initializer emits an explicit
// Assign/StoreStr in place of the declaration; a var with none is left at
// the printer's zero value.
func (l *lowerer) lowerBlock(b *ast.Block, f *ir.Func) []ir.Stmt {
	l.pushScope()
	defer l.popScope()
	var out []ir.Stmt
	for _, v := range b.Vars {
		t := l.resolveType(v.Type)
		if what, bad := unsupportedKind(t.Kind); bad {
			l.unsupported(v.P, what)
			continue
		}
		ty := lowerType(t)
		f.Locals = append(f.Locals, ir.Local{Name: v.Name, T: ty})
		l.declareLocal(v.Name)
		if v.Init != nil {
			dst := &ir.VarRef{Name: v.Name, Ty: ty}
			out = append(out, l.storeStmt(dst, l.lowerExpr(v.Init), ty))
		}
	}
	for _, s := range b.Stmts {
		out = append(out, l.lowerStmt(s, f)...)
	}
	return out
}

// storeStmt builds the store form the task brief's Assign rule requires: a
// Str-typed destination clamps through StoreStr; a Text destination fed by a
// Str source (the checker's String -> Text assignability, Ch3) goes through
// the text_store intrinsic since a Text handle and a Str value have no
// common C representation to plain-assign between; everything else
// (Text=Text reference copy, records/arrays copy by value) is a plain
// Assign.
func (l *lowerer) storeStmt(dst, src ir.Expr, ty ir.Type) ir.Stmt {
	switch {
	case ty.K == ir.Str:
		return &ir.StoreStr{Dst: dst, Src: src}
	case ty.K == ir.Text && src.Type().K == ir.Str:
		return &ir.ExprStmt{X: &ir.Intr{Name: ir.ITextStore, Args: []ir.Expr{dst, src}, Ty: ir.Type{K: ir.Void}}}
	default:
		return &ir.Assign{Dst: dst, Src: src}
	}
}

// lowerStmt lowers one statement. It returns a slice (rather than a single
// ir.Stmt) so a host-unsupported statement (open/close/edit/cancel) can
// contribute nothing to the body instead of forcing a placeholder node.
func (l *lowerer) lowerStmt(s ast.Stmt, f *ir.Func) []ir.Stmt {
	switch s := s.(type) {
	case *ast.AssignStmt:
		return []ir.Stmt{l.lowerAssign(s)}
	case *ast.ExprStmt:
		return []ir.Stmt{&ir.ExprStmt{X: l.lowerExpr(s.X)}}
	case *ast.IfStmt:
		return []ir.Stmt{l.lowerIf(s, f)}
	case *ast.WhileStmt:
		return []ir.Stmt{&ir.While{Cond: l.lowerExpr(s.Cond), Body: l.lowerBlock(s.Body, f)}}
	case *ast.ForStmt:
		return []ir.Stmt{l.lowerFor(s, f)}
	case *ast.ReturnStmt:
		var x ir.Expr
		if s.X != nil {
			x = l.coerceStr(l.curFuncRet, l.lowerExpr(s.X))
		}
		return []ir.Stmt{&ir.Return{X: x}}
	case *ast.QuitStmt:
		return []ir.Stmt{l.lowerQuit(s)}
	case *ast.BreakStmt:
		return []ir.Stmt{&ir.Break{}}
	case *ast.ContinueStmt:
		return []ir.Stmt{&ir.Continue{}}
	case *ast.SwitchStmt:
		return l.lowerSwitch(s, f)
	case *ast.CancelStmt:
		l.unsupported(s.P, "cancel")
		return nil
	case *ast.OpenStmt:
		l.unsupported(s.P, "open")
		return nil
	case *ast.CloseStmt:
		l.unsupported(s.P, "close")
		return nil
	case *ast.EditStmt:
		l.unsupported(s.P, "edit")
		return nil
	default:
		panic(fmt.Sprintf("lower: unhandled statement %T", s))
	}
}

// lowerAssign lowers `lvalue = expr`. `l[i] = v` (list/array element write)
// and string/text/map index writes get their own shapes per the task
// brief's printer contract; everything else (a plain variable or a record
// field) is a normal store through storeStmt.
func (l *lowerer) lowerAssign(s *ast.AssignStmt) ir.Stmt {
	if idx, ok := s.LHS.(*ast.Index); ok {
		return l.lowerIndexAssign(idx, s.RHS)
	}
	ty := lowerType(l.mustType(s.LHS))
	return l.storeStmt(l.lowerExpr(s.LHS), l.lowerExpr(s.RHS), ty)
}

// lowerIndexAssign lowers `x[i] = rhs`. Array/list element writes reuse
// IndexRef as an lvalue (same printer contract as reads — see ir.IndexRef's
// doc comment); string/text/map writes have no lvalue form and lower to
// their set intrinsic as an ExprStmt instead.
func (l *lowerer) lowerIndexAssign(lhs *ast.Index, rhsExpr ast.Expr) ir.Stmt {
	xt := l.mustType(lhs.X)
	x, i, rhs := l.lowerExpr(lhs.X), l.lowerExpr(lhs.I), l.lowerExpr(rhsExpr)
	switch xt.Kind {
	case types.Array, types.List:
		elemTy := lowerType(l.mustType(lhs))
		return l.storeStmt(&ir.IndexRef{X: x, I: i, Ty: elemTy}, rhs, elemTy)
	case types.String:
		return &ir.ExprStmt{X: &ir.Intr{Name: ir.IStrSetIndex, Args: []ir.Expr{x, i, rhs}, Ty: ir.Type{K: ir.Void}}}
	case types.Text:
		return &ir.ExprStmt{X: &ir.Intr{Name: ir.ITextSetIndex, Args: []ir.Expr{x, i, rhs}, Ty: ir.Type{K: ir.Void}}}
	case types.Map:
		// rhs goes through coerceStr, not raw: intrCall's IMapSet copies rhs
		// into a temp of rhs's OWN type before taking its address (see
		// copyToTemp's doc comment on why it can't just addrable the value
		// argument here) — a rhs Str capacity that differs from the map's
		// declared value type would otherwise mismatch the struct size
		// rt_map_set's memmove actually moves (Critical 2's class of bug).
		rhs = l.coerceStr(*x.Type().Elem, rhs)
		return &ir.ExprStmt{X: &ir.Intr{Name: ir.IMapSet, Args: []ir.Expr{x, i, rhs}, Ty: ir.Type{K: ir.Void}}}
	default:
		panic(fmt.Sprintf("lower: cannot assign into index of %v at %v", xt.Kind, lhs.P))
	}
}

// lowerIf lowers `if cond block [else (ifStmt|block)]`.
func (l *lowerer) lowerIf(s *ast.IfStmt, f *ir.Func) ir.Stmt {
	n := &ir.If{Cond: l.lowerExpr(s.Cond), Then: l.lowerBlock(s.Then, f)}
	switch e := s.Else.(type) {
	case nil:
	case *ast.Block:
		n.Else = l.lowerBlock(e, f)
	case *ast.IfStmt:
		n.Else = []ir.Stmt{l.lowerIf(e, f)}
	default:
		panic(fmt.Sprintf("lower: unhandled if-else shape %T at %v", e, s.P))
	}
	return n
}

// lowerFor lowers all three `for` forms (Ch5: For) that checkForStmt
// validates: an inclusive int range (ToExpr set), list iteration (one
// element var), and map iteration (key + value vars). Seq/ToExpr are lowered
// in the enclosing scope before the loop variable(s) are declared, matching
// checker.checkForStmt's own scope nesting.
func (l *lowerer) lowerFor(s *ast.ForStmt, f *ir.Func) ir.Stmt {
	seq := l.lowerExpr(s.Seq)
	if s.ToExpr != nil {
		to := l.lowerExpr(s.ToExpr)
		l.pushScope()
		defer l.popScope()
		f.Locals = append(f.Locals, ir.Local{Name: s.V1, T: ir.Type{K: ir.Int}})
		l.declareLocal(s.V1)
		return &ir.ForRange{V: s.V1, From: seq, To: to, Body: l.lowerBlock(s.Body, f)}
	}

	seqT := l.mustType(s.Seq)
	switch seqT.Kind {
	case types.List:
		l.pushScope()
		defer l.popScope()
		f.Locals = append(f.Locals, ir.Local{Name: s.V1, T: lowerType(seqT.Elem)})
		l.declareLocal(s.V1)
		return &ir.ForList{V: s.V1, ListV: seq, Body: l.lowerBlock(s.Body, f)}
	case types.Map:
		l.pushScope()
		defer l.popScope()
		f.Locals = append(f.Locals, ir.Local{Name: s.V1, T: ir.Type{K: ir.Str, N: 255}})
		l.declareLocal(s.V1)
		if s.V2 != "" {
			f.Locals = append(f.Locals, ir.Local{Name: s.V2, T: lowerType(seqT.Elem)})
			l.declareLocal(s.V2)
		}
		return &ir.ForMap{K: s.V1, V: s.V2, MapV: seq, Body: l.lowerBlock(s.Body, f)}
	default:
		panic(fmt.Sprintf("lower: cannot iterate %v at %v", seqT.Kind, s.P))
	}
}

// lowerQuit lowers `quit [code]` (Ch5: Quit) to the IQuit intrinsic, which
// always carries exactly one int argument on the IR side — bare `quit`
// supplies the default IntConst 0 itself, matching rt_quit(int32_t code)'s
// single required argument (host runtime, Task 4).
func (l *lowerer) lowerQuit(s *ast.QuitStmt) ir.Stmt {
	code := ir.Expr(&ir.IntConst{Ty: ir.Type{K: ir.Int}}) // V defaults to 0
	if s.Code != nil {
		code = l.lowerExpr(s.Code)
	}
	return &ir.ExprStmt{X: &ir.Intr{Name: ir.IQuit, Args: []ir.Expr{code}, Ty: ir.Type{K: ir.Void}}}
}

// lowerSwitch desugars `switch subject { case labels {body} ... [else
// {body}] }` (Ch5: Switch) into: the subject expression evaluated exactly
// ONCE into a synthesized function-local temp (so a subject with side
// effects, e.g. a function call, never re-runs per case), followed by an
// if/else-if/.../else chain comparing that temp against each case's
// label(s) — multi-label cases OR their comparisons together. int/char/enum
// subjects compare with a plain `==`; string subjects go through IStrCmp==0
// (text subjects are rejected by the checker — Ch3 lists only string among
// the text-like types switch accepts).
//
// The desugared chain is pure ir.If — no C loop or switch construct is ever
// emitted for it (see ir.Break/Continue's doc comment) — so a `break`
// lowered from inside a case body automatically binds whatever LOOP
// lexically encloses the switch, never the switch itself, exactly matching
// Ch5's rule with no special-casing required here.
func (l *lowerer) lowerSwitch(s *ast.SwitchStmt, f *ir.Func) []ir.Stmt {
	subjT := l.mustType(s.Subject)
	ty := lowerType(subjT)
	tmp := l.newSwitchTemp()
	f.Locals = append(f.Locals, ir.Local{Name: tmp, T: ty})
	store := l.storeStmt(&ir.VarRef{Name: tmp, Ty: ty}, l.lowerExpr(s.Subject), ty)

	var tail []ir.Stmt
	if s.Else != nil {
		tail = l.lowerBlock(s.Else, f)
	}
	for i := len(s.Cases) - 1; i >= 0; i-- {
		cs := s.Cases[i]
		cond := l.caseCond(subjT, ty, tmp, cs.Labels)
		body := l.lowerBlock(cs.Body, f)
		tail = []ir.Stmt{&ir.If{Cond: cond, Then: body, Else: tail}}
	}
	return append([]ir.Stmt{store}, tail...)
}

// newSwitchTemp names one switch desugar's subject temp. The "__switch"
// prefix keeps it out of the way of any user-declared local — Clarus source
// identifiers are never expected to start with a double underscore — and the
// counter is program-wide (never reset per function) so nested/sibling
// switches never collide even when several land in the same function body.
func (l *lowerer) newSwitchTemp() string {
	l.switchN++
	return fmt.Sprintf("__switch%d", l.switchN)
}

// caseCond builds one case's condition: its label(s), OR'd together when
// there's more than one (`case 2, 3`).
func (l *lowerer) caseCond(subjT *types.Type, ty ir.Type, tmp string, labels []ast.Expr) ir.Expr {
	var cond ir.Expr
	for _, lbl := range labels {
		eq := l.labelEq(subjT, ty, tmp, lbl)
		if cond == nil {
			cond = eq
			continue
		}
		cond = &ir.Bin{Op: "or", X: cond, Y: eq, Ty: ir.Type{K: ir.Bool}}
	}
	return cond
}

// labelEq builds `tmp == label`: a plain int/char/enum comparison, or
// `str_cmp(tmp, label) == 0` for a string subject (label is a literal,
// bare enum member, or const Ident — lowerExpr/lowerIdent already resolve
// all three to a plain constant, per checkCaseLabel's "must be a constant"
// rule).
func (l *lowerer) labelEq(subjT *types.Type, ty ir.Type, tmp string, lbl ast.Expr) ir.Expr {
	ref := &ir.VarRef{Name: tmp, Ty: ty}
	lblExpr := l.lowerExpr(lbl)
	if subjT.Kind == types.String {
		cmp := &ir.Intr{Name: ir.IStrCmp, Args: []ir.Expr{ref, lblExpr}, Ty: ir.Type{K: ir.Int}}
		zero := &ir.IntConst{Ty: ir.Type{K: ir.Int}}
		return &ir.Bin{Op: "==", X: cmp, Y: zero, Ty: ir.Type{K: ir.Bool}}
	}
	return &ir.Bin{Op: "==", X: ref, Y: lblExpr, Ty: ir.Type{K: ir.Bool}}
}
