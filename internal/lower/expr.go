package lower

import (
	"fmt"

	"clarus/internal/ast"
	"clarus/internal/ir"
	"clarus/internal/types"
)

// lowerExpr lowers one checked expression per the task brief's lowering
// rules. info.Types[e] is authoritative for e's type; mustType panics (with
// position) if it's missing, since that would be a check.Info coverage bug,
// not something to guess at.
//
// NilLit, WindowSelf, and OpenExpr are unreachable in a host build: nil is
// only valid compared against window/resource values, `window` only resolves
// inside a window-scoped handler body, and `open W` only type-checks against
// a declared window type — all three require a construct lowerDecl already
// flagged host-unsupported before lowerExpr could ever be reached on them.
// These three fall to the panicking default case.
//
// *ast.NewExpr lowers to ir.NewRec below wherever it appears — as a whole
// global initializer or nested inside a larger expression (FieldRef/args
// compose over it naturally, since NewRec is just another ir.Expr).
func (l *lowerer) lowerExpr(e ast.Expr) ir.Expr {
	switch e := e.(type) {
	case *ast.IntLit:
		return &ir.IntConst{V: e.Val, Ty: ir.Type{K: ir.Int}}
	case *ast.FixedLit:
		return &ir.IntConst{V: int64(e.Raw), Ty: ir.Type{K: ir.Fixed}}
	case *ast.CharLit:
		return &ir.IntConst{V: int64(e.Val), Ty: ir.Type{K: ir.Char}}
	case *ast.BoolLit:
		v := int64(0)
		if e.Val {
			v = 1
		}
		return &ir.IntConst{V: v, Ty: ir.Type{K: ir.Bool}}
	case *ast.StringLit:
		return &ir.StrConst{Idx: l.internStr(e.Val), Ty: ir.Type{K: ir.Str, N: 255}}
	case *ast.Ident:
		return l.lowerIdent(e)
	case *ast.Unary:
		return &ir.Un{Op: e.Op, X: l.lowerExpr(e.X), Ty: lowerType(l.mustType(e))}
	case *ast.Binary:
		return l.lowerBinary(e)
	case *ast.Call:
		return l.lowerCall(e)
	case *ast.Index:
		return l.lowerIndex(e)
	case *ast.Select:
		return l.lowerSelect(e)
	case *ast.NewExpr:
		return &ir.NewRec{RecName: e.Type, Ty: lowerType(l.mustType(e))}
	default:
		panic(fmt.Sprintf("lower: unhandled expression %T at %v", e, e.Pos()))
	}
}

// mustType returns e's checker-recorded type, panicking if it's missing —
// see the lowerExpr doc comment.
func (l *lowerer) mustType(e ast.Expr) *types.Type {
	t, ok := l.info.Types[e]
	if !ok || t == nil {
		panic(fmt.Sprintf("lower: missing checker type info for %T at %v", e, e.Pos()))
	}
	return t
}

// internStr interns s into Program.StrLits, returning its index — identical
// literals share one slot.
func (l *lowerer) internStr(s string) int {
	if idx, ok := l.strIdx[s]; ok {
		return idx
	}
	idx := len(l.prog.StrLits)
	l.prog.StrLits = append(l.prog.StrLits, s)
	l.strIdx[s] = idx
	return idx
}

// placeholder stands in for an expression lowerExpr couldn't build because
// it's host-unsupported (a diagnostic was already recorded); its value is
// never used since a build with diagnostics never reaches the printer.
func (l *lowerer) placeholder(ty ir.Type) ir.Expr {
	return &ir.IntConst{Ty: ty}
}

func (l *lowerer) lowerArgs(args []ast.Expr) []ir.Expr {
	out := make([]ir.Expr, len(args))
	for i, a := range args {
		out[i] = l.lowerExpr(a)
	}
	return out
}

// lowerIdent lowers a resolved variable reference or a bare enum-member
// constant (info.EnumConsts records which — checker.checkIdent populates it
// only when the Ident didn't resolve in scope). Outside any function/handler
// body (top-level var initializers) l.localScopes is empty, so isLocal is
// always false and every Ident is a global, as before Task 7 introduced
// locals.
func (l *lowerer) lowerIdent(e *ast.Ident) ir.Expr {
	ty := lowerType(l.mustType(e))
	if v, ok := l.info.EnumConsts[e]; ok {
		return &ir.IntConst{V: int64(v), Ty: ty}
	}
	return &ir.VarRef{Name: e.Name, Global: !l.isLocal(e.Name), Ty: ty}
}

func (l *lowerer) bin(op string, ty ir.Type, x, y ast.Expr) ir.Expr {
	return &ir.Bin{Op: op, X: l.lowerExpr(x), Y: l.lowerExpr(y), Ty: ty}
}

func (l *lowerer) intr(name string, ty ir.Type, args ...ast.Expr) ir.Expr {
	return &ir.Intr{Name: name, Args: l.lowerArgs(args), Ty: ty}
}

// lowerBinary dispatches `+` (int/fixed stay Bin; string/text concat and
// fixed *//div lower to intrinsics), comparisons, and everything else
// (arith, bitwise, and/or) which all stay Bin — the C printer maps the
// operator string (including "mod", "and", "or") to C.
func (l *lowerer) lowerBinary(e *ast.Binary) ir.Expr {
	ty := lowerType(l.mustType(e))
	switch e.Op {
	case "+":
		lt, rt := l.mustType(e.X), l.mustType(e.Y)
		switch {
		case lt.Kind == types.String && rt.Kind == types.String:
			return l.intr(ir.IStrConcat, ty, e.X, e.Y)
		case lt.Kind == types.String && rt.Kind == types.Char:
			return l.intr(ir.IStrConcatChar, ty, e.X, e.Y)
		case lt.Kind == types.Text && (rt.Kind == types.Text || rt.Kind == types.String):
			return l.intr(ir.ITextConcat, ty, e.X, e.Y)
		default:
			return l.bin(e.Op, ty, e.X, e.Y)
		}
	case "*", "/":
		if l.mustType(e.X).Kind == types.Fixed {
			name := ir.IFixMul
			if e.Op == "/" {
				name = ir.IFixDiv
			}
			return l.intr(name, ty, e.X, e.Y)
		}
		return l.bin(e.Op, ty, e.X, e.Y)
	case "==", "!=", "<", "<=", ">", ">=":
		return l.lowerComparison(e)
	default: // "-", "mod", "&", "|", "^", "<<", ">>", "and", "or"
		return l.bin(e.Op, ty, e.X, e.Y)
	}
}

// lowerComparison lowers `== != < <= > >=`. String/text operands (either
// side) compare via the byte-wise cmp intrinsics, `<op> 0`; text wins over
// string when mixed, since IStrCmp only knows fixed-capacity strings.
// Everything else (int/fixed/char/bool/enum) stays a plain Bin comparison.
func (l *lowerer) lowerComparison(e *ast.Binary) ir.Expr {
	lt, rt := l.mustType(e.X), l.mustType(e.Y)
	textish := func(t *types.Type) bool { return t.Kind == types.String || t.Kind == types.Text }
	if textish(lt) || textish(rt) {
		name := ir.IStrCmp
		if lt.Kind == types.Text || rt.Kind == types.Text {
			name = ir.ITextCmp
		}
		cmp := l.intr(name, ir.Type{K: ir.Int}, e.X, e.Y)
		zero := &ir.IntConst{Ty: ir.Type{K: ir.Int}}
		return &ir.Bin{Op: e.Op, X: cmp, Y: zero, Ty: ir.Type{K: ir.Bool}}
	}
	return &ir.Bin{Op: e.Op, X: l.lowerExpr(e.X), Y: l.lowerExpr(e.Y), Ty: ir.Type{K: ir.Bool}}
}

// lowerCall dispatches a bare-name call (conversion, alert, an unsupported
// dialog, or a user function) versus a method call (`x.name(args)`).
func (l *lowerer) lowerCall(e *ast.Call) ir.Expr {
	switch fn := e.Fn.(type) {
	case *ast.Ident:
		return l.lowerIdentCall(e, fn)
	case *ast.Select:
		return l.lowerMethodCall(e, fn)
	default:
		panic(fmt.Sprintf("lower: unsupported call target %T at %v", e.Fn, e.P))
	}
}

func (l *lowerer) lowerIdentCall(e *ast.Call, fn *ast.Ident) ir.Expr {
	ty := lowerType(l.mustType(e))
	switch fn.Name {
	case "int":
		return l.lowerIntConv(e, ty)
	case "fixed":
		return &ir.Conv{Op: ir.IntToFixed, X: l.lowerExpr(e.Args[0]), Ty: ty}
	case "char":
		return &ir.Conv{Op: ir.IntToChar, X: l.lowerExpr(e.Args[0]), Ty: ty}
	case "alert":
		return &ir.Intr{Name: ir.IAlert, Args: l.lowerArgs(e.Args), Ty: ty}
	case "askOpen", "askSave", "askSaveChanges":
		l.unsupported(e.P, fn.Name)
		return l.placeholder(ty)
	}
	if et, ok := l.declTypes[fn.Name]; ok && et.Kind == types.Enum {
		return &ir.Conv{Op: ir.IntToEnum, X: l.lowerExpr(e.Args[0]), EnumName: fn.Name, Ty: ty}
	}
	return &ir.CallFn{Name: fn.Name, Args: l.lowerArgs(e.Args), Ty: ty}
}

// lowerIntConv lowers `int(x)`, whose ConvOp depends on x's source kind
// (Ch3: Numeric Conversions, Enums).
func (l *lowerer) lowerIntConv(e *ast.Call, ty ir.Type) ir.Expr {
	switch l.mustType(e.Args[0]).Kind {
	case types.Fixed:
		return &ir.Conv{Op: ir.FixedToInt, X: l.lowerExpr(e.Args[0]), Ty: ty}
	case types.Char:
		return &ir.Conv{Op: ir.CharToInt, X: l.lowerExpr(e.Args[0]), Ty: ty}
	case types.Enum:
		return &ir.Conv{Op: ir.EnumToInt, X: l.lowerExpr(e.Args[0]), Ty: ty}
	default:
		panic(fmt.Sprintf("lower: int(...) from unsupported source kind at %v", e.P))
	}
}

// lowerMethodCall dispatches `x.name(args)` by the receiver's kind, mirroring
// checker.checkMethodCall. connection/listener/serviceBrowser/canvas
// receivers are unreachable in a host build: their value's declaration
// already triggered a host-unsupported diagnostic (resource-typed vars;
// canvas only exists on a widget, which requires a window), so their method
// tables aren't implemented here — reaching the default case is a lowerer
// bug, not a user error.
func (l *lowerer) lowerMethodCall(e *ast.Call, sel *ast.Select) ir.Expr {
	ty := lowerType(l.mustType(e))
	if id, ok := sel.X.(*ast.Ident); ok && id.Name == "file" {
		return l.lowerFileCall(e, sel, ty)
	}
	xt := l.mustType(sel.X)
	recv := l.lowerExpr(sel.X)
	switch xt.Kind {
	case types.List:
		return l.lowerListMethod(recv, sel, e.Args, ty)
	case types.Map:
		return l.lowerMapMethod(recv, sel, e.Args, ty)
	case types.String, types.Text:
		return l.lowerStringTextMethod(recv, xt.Kind == types.Text, sel, e.Args, ty)
	default:
		panic(fmt.Sprintf("lower: unhandled method receiver kind %v for .%s at %v", xt.Kind, sel.Name, sel.P))
	}
}

// lowerFileCall lowers `file.fn(args)` (Ch12: Files). save/load aren't
// host-supported (Global Constraints); readText/writeText/name are.
func (l *lowerer) lowerFileCall(e *ast.Call, sel *ast.Select, ty ir.Type) ir.Expr {
	switch sel.Name {
	case "readText":
		return &ir.Intr{Name: ir.IFileReadText, Args: l.lowerArgs(e.Args), Ty: ty}
	case "writeText":
		return &ir.Intr{Name: ir.IFileWriteText, Args: l.lowerArgs(e.Args), Ty: ty}
	case "name":
		return &ir.Intr{Name: ir.IFileName, Args: l.lowerArgs(e.Args), Ty: ty}
	case "save", "load":
		l.unsupported(sel.P, "file."+sel.Name)
		return l.placeholder(ty)
	default:
		panic(fmt.Sprintf("lower: unknown file method %s at %v", sel.Name, sel.P))
	}
}

func (l *lowerer) lowerListMethod(recv ir.Expr, sel *ast.Select, args []ast.Expr, ty ir.Type) ir.Expr {
	one := func(name string) ir.Expr {
		return &ir.Intr{Name: name, Args: []ir.Expr{recv, l.lowerExpr(args[0])}, Ty: ty}
	}
	zero := func(name string) ir.Expr {
		return &ir.Intr{Name: name, Args: []ir.Expr{recv}, Ty: ty}
	}
	switch sel.Name {
	case "add", "push":
		return one(ir.IListPush)
	case "unshift":
		return one(ir.IListUnshift)
	case "pop":
		return zero(ir.IListPop)
	case "shift":
		return zero(ir.IListShift)
	case "first":
		return zero(ir.IListFirst)
	case "last":
		return zero(ir.IListLast)
	case "remove":
		return one(ir.IListRemove)
	case "count":
		return zero(ir.IListCount)
	default:
		panic(fmt.Sprintf("lower: unknown list method %s at %v", sel.Name, sel.P))
	}
}

func (l *lowerer) lowerMapMethod(recv ir.Expr, sel *ast.Select, args []ast.Expr, ty ir.Type) ir.Expr {
	switch sel.Name {
	case "get":
		return &ir.Intr{Name: ir.IMapGetDv, Args: []ir.Expr{recv, l.lowerExpr(args[0]), l.lowerExpr(args[1])}, Ty: ty}
	case "has":
		return &ir.Intr{Name: ir.IMapHas, Args: []ir.Expr{recv, l.lowerExpr(args[0])}, Ty: ty}
	case "remove":
		return &ir.Intr{Name: ir.IMapRemove, Args: []ir.Expr{recv, l.lowerExpr(args[0])}, Ty: ty}
	case "count":
		return &ir.Intr{Name: ir.IMapCount, Args: []ir.Expr{recv}, Ty: ty}
	default:
		panic(fmt.Sprintf("lower: unknown map method %s at %v", sel.Name, sel.P))
	}
}

func (l *lowerer) lowerStringTextMethod(recv ir.Expr, isText bool, sel *ast.Select, args []ast.Expr, ty ir.Type) ir.Expr {
	switch sel.Name {
	case "fromBytes":
		name := ir.IStrFromBytes
		if isText {
			name = ir.ITextFromBytes
		}
		return &ir.Intr{Name: name, Args: []ir.Expr{recv, l.lowerExpr(args[0]), l.lowerExpr(args[1])}, Ty: ty}
	case "toBytes":
		name := ir.IStrToBytes
		if isText {
			name = ir.ITextToBytes
		}
		return &ir.Intr{Name: name, Args: []ir.Expr{recv, l.lowerExpr(args[0])}, Ty: ty}
	default:
		panic(fmt.Sprintf("lower: unknown string/text method %s at %v", sel.Name, sel.P))
	}
}

// lowerIndex lowers `a[i]`. Array and list share IndexRef — see the doc
// comment on ir.IndexRef for the printer contract this relies on for lists
// (C printer, Task 8: a List-typed IndexRef.X emits *(T*)rt_list_at(l, i)
// instead of a real array-element access). String/text/map indexing lower to
// intrinsics instead.
func (l *lowerer) lowerIndex(e *ast.Index) ir.Expr {
	ty := lowerType(l.mustType(e))
	xt := l.mustType(e.X)
	x, i := l.lowerExpr(e.X), l.lowerExpr(e.I)
	switch xt.Kind {
	case types.Array, types.List:
		return &ir.IndexRef{X: x, I: i, Ty: ty}
	case types.String:
		return &ir.Intr{Name: ir.IStrIndex, Args: []ir.Expr{x, i}, Ty: ty}
	case types.Text:
		return &ir.Intr{Name: ir.ITextIndex, Args: []ir.Expr{x, i}, Ty: ty}
	case types.Map:
		return &ir.Intr{Name: ir.IMapGet, Args: []ir.Expr{x, i}, Ty: ty}
	default:
		panic(fmt.Sprintf("lower: cannot index %v at %v", xt.Kind, e.P))
	}
}

// lowerSelect lowers a bare `a.b` — a record field, or a no-argument
// property (.length/.count, lastError's .code/.message). Method calls go
// through lowerMethodCall instead, since only a Call carries argument
// expressions (mirrors checker.checkSelect/checkMethodCall's split).
func (l *lowerer) lowerSelect(e *ast.Select) ir.Expr {
	ty := lowerType(l.mustType(e))
	xt := l.mustType(e.X)
	switch xt.Kind {
	case types.Record:
		return &ir.FieldRef{X: l.lowerExpr(e.X), Name: e.Name, Ty: ty}
	case types.ErrorType:
		switch e.Name {
		case "code":
			return &ir.Intr{Name: ir.ILastErrCode, Ty: ty}
		case "message":
			return &ir.Intr{Name: ir.ILastErrMsg, Ty: ty}
		}
	case types.String, types.Text:
		if e.Name == "length" {
			name := ir.IStrLen
			if xt.Kind == types.Text {
				name = ir.ITextLen
			}
			return &ir.Intr{Name: name, Args: []ir.Expr{l.lowerExpr(e.X)}, Ty: ty}
		}
	case types.List:
		if e.Name == "count" {
			return &ir.Intr{Name: ir.IListCount, Args: []ir.Expr{l.lowerExpr(e.X)}, Ty: ty}
		}
	case types.Map:
		if e.Name == "count" {
			return &ir.Intr{Name: ir.IMapCount, Args: []ir.Expr{l.lowerExpr(e.X)}, Ty: ty}
		}
	}
	panic(fmt.Sprintf("lower: unhandled select .%s on %v at %v", e.Name, xt.Kind, e.P))
}
