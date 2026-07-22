package check

import (
	"strings"

	"clarus/internal/ast"
	"clarus/internal/source"
	"clarus/internal/types"
)

// checkExpr type-checks e and returns its type. expected resolves bare enum
// members and `nil` (WindowRef/resource) — it is a hint, not an obligation;
// concrete-typed expressions (literals, resolved idents) ignore it. On any
// error, checkExpr reports exactly one diagnostic and returns types.InvalidT,
// which compatible() treats as compatible with everything so a single
// mistake never cascades into unrelated follow-on errors.
func (c *checker) checkExpr(e ast.Expr, expected *types.Type) *types.Type {
	switch e := e.(type) {
	case *ast.IntLit:
		return types.IntT
	case *ast.FixedLit:
		return types.FixedT
	case *ast.CharLit:
		return types.CharT
	case *ast.StringLit:
		return types.StringT(255)
	case *ast.BoolLit:
		return types.BoolT
	case *ast.NilLit:
		return c.checkNil(e, expected)
	case *ast.WindowSelf:
		if c.curWindow != nil {
			return &types.Type{Kind: types.WindowRef, Window: c.curWindow}
		}
		c.errorf(e.P, "window is only valid inside a window-scoped handler")
		return types.InvalidT
	case *ast.Ident:
		return c.checkIdent(e, expected)
	case *ast.Unary:
		return c.checkUnary(e)
	case *ast.Binary:
		return c.checkBinary(e)
	case *ast.Call:
		return c.checkCall(e, expected)
	case *ast.Index:
		return c.checkIndex(e)
	case *ast.Select:
		return c.checkSelect(e)
	case *ast.NewExpr:
		return c.checkNewExpr(e)
	case *ast.OpenExpr:
		return c.checkOpenExpr(e)
	default:
		c.errorf(e.Pos(), "internal: unhandled expression type")
		return types.InvalidT
	}
}

// compatible is the checker's own assignability wrapper around
// types.AssignableTo, which already treats types.InvalidT (on either side) as
// compatible with anything, so a diagnostic already reported for one
// sub-expression never triggers a second, misleading diagnostic downstream
// (the "no cascade" rule).
func compatible(src, dst *types.Type) bool {
	return types.AssignableTo(src, dst)
}

// typeName renders t for diagnostics.
func typeName(t *types.Type) string {
	if t == nil {
		return "<nil>"
	}
	switch t.Kind {
	case types.Int:
		return "int"
	case types.Bool:
		return "bool"
	case types.Fixed:
		return "fixed"
	case types.Char:
		return "char"
	case types.String:
		return "string"
	case types.Text:
		return "text"
	case types.Void:
		return "void"
	case types.Address:
		return "address"
	case types.ErrorType:
		return "error"
	case types.Connection:
		return "connection"
	case types.Listener:
		return "listener"
	case types.ServiceBrowser:
		return "serviceBrowser"
	case types.Enum:
		if t.Enum != nil {
			return t.Enum.Name
		}
		return "enum"
	case types.Record:
		if t.Record != nil {
			return t.Record.Name
		}
		return "record"
	case types.WindowRef:
		if t.Window != nil {
			return t.Window.Name
		}
		return "window"
	case types.Array:
		return typeName(t.Elem) + "[]"
	case types.List:
		return "list of " + typeName(t.Elem)
	case types.Map:
		return "map of " + typeName(t.Elem)
	default:
		return "?"
	}
}

// kindsList renders a OneOfKinds paramSpec's allowed kinds for a diagnostic,
// e.g. "string or address" / "a, b, or c".
func kindsList(kinds []types.Kind) string {
	names := make([]string, len(kinds))
	for i, k := range kinds {
		names[i] = typeName(&types.Type{Kind: k})
	}
	switch len(names) {
	case 1:
		return names[0]
	case 2:
		return names[0] + " or " + names[1]
	default:
		return strings.Join(names[:len(names)-1], ", ") + ", or " + names[len(names)-1]
	}
}

// isResourceKind reports whether k is a window ref or one of the network
// resource kinds — the only kinds `nil` is valid for.
func isResourceKind(k types.Kind) bool {
	switch k {
	case types.WindowRef, types.Connection, types.Listener, types.ServiceBrowser:
		return true
	default:
		return false
	}
}

func (c *checker) checkNil(e *ast.NilLit, expected *types.Type) *types.Type {
	if expected != nil && isResourceKind(expected.Kind) {
		return expected
	}
	c.errorf(e.P, "nil is only valid for window and resource references")
	return types.InvalidT
}

// isBareIdentCandidate reports whether e is an Ident not resolvable in the
// current scope — a candidate for enum-member resolution via the other
// operand's type. Used by checkComparison to decide which side to check
// first, so a bare enum member on either side of == / != can be rescued
// without ever double-reporting an "undefined" diagnostic.
func (c *checker) isBareIdentCandidate(e ast.Expr) bool {
	id, ok := e.(*ast.Ident)
	if !ok {
		return false
	}
	_, found := c.scope.Lookup(id.Name)
	return !found
}

func (c *checker) checkIdent(e *ast.Ident, expected *types.Type) *types.Type {
	if sym, ok := c.scope.Lookup(e.Name); ok {
		if sym.IsFunc {
			c.errorf(e.P, "cannot use function %s as a value", e.Name)
			return types.InvalidT
		}
		if sym.IsType {
			c.errorf(e.P, "cannot use type %s as a value", e.Name)
			return types.InvalidT
		}
		if sym.IsMenu {
			c.errorf(e.P, "%s is a menu, not a value", e.Name)
			return types.InvalidT
		}
		return sym.Type
	}
	if expected != nil && expected.Kind == types.Enum {
		for _, m := range expected.Enum.Members {
			if m.Name == e.Name {
				return expected
			}
		}
	}
	c.errorf(e.P, "undefined: %s", e.Name)
	return types.InvalidT
}

func (c *checker) checkUnary(e *ast.Unary) *types.Type {
	switch e.Op {
	case "-":
		t := c.checkExpr(e.X, nil)
		if t == types.InvalidT {
			return types.InvalidT
		}
		if t.Kind != types.Int && t.Kind != types.Fixed {
			c.errorf(e.P, "cannot negate %s", typeName(t))
			return types.InvalidT
		}
		return t
	case "not":
		t := c.checkExpr(e.X, types.BoolT)
		if t == types.InvalidT {
			return types.InvalidT
		}
		if t.Kind != types.Bool {
			c.errorf(e.P, "condition must be bool")
			return types.InvalidT
		}
		return types.BoolT
	case "~":
		t := c.checkExpr(e.X, types.IntT)
		if t == types.InvalidT {
			return types.InvalidT
		}
		if t.Kind != types.Int {
			c.errorf(e.P, "bitwise operator requires int operands")
			return types.InvalidT
		}
		return types.IntT
	default:
		c.errorf(e.P, "internal: unhandled unary operator %s", e.Op)
		return types.InvalidT
	}
}

func (c *checker) checkBinary(e *ast.Binary) *types.Type {
	switch e.Op {
	case "+", "-", "*", "/", "mod":
		return c.checkArith(e)
	case "&", "|", "^", "<<", ">>":
		return c.checkBitwise(e)
	case "==", "!=":
		return c.checkComparison(e, true)
	case "<", "<=", ">", ">=":
		return c.checkComparison(e, false)
	case "and", "or":
		return c.checkBoolOp(e)
	default:
		c.errorf(e.P, "internal: unhandled binary operator %s", e.Op)
		return types.InvalidT
	}
}

// checkArith checks `+ - * / mod` (Ch4: Mixed Numeric Arithmetic, String
// Concatenation and Truncation).
func (c *checker) checkArith(e *ast.Binary) *types.Type {
	lt := c.checkExpr(e.X, nil)
	rt := c.checkExpr(e.Y, nil)
	if lt == types.InvalidT || rt == types.InvalidT {
		return types.InvalidT
	}
	if e.Op == "+" {
		if lt.Kind == types.String && rt.Kind == types.String {
			return types.StringT(255)
		}
		if lt.Kind == types.String && rt.Kind == types.Char {
			return types.StringT(255)
		}
		if lt.Kind == types.Text && (rt.Kind == types.Text || rt.Kind == types.String) {
			return types.TextT
		}
	}
	if lt.Kind == types.Int && rt.Kind == types.Int {
		return types.IntT
	}
	if lt.Kind == types.Fixed && rt.Kind == types.Fixed {
		if e.Op == "mod" {
			c.errorf(e.P, "operator mod requires int operands")
			return types.InvalidT
		}
		return types.FixedT
	}
	if (lt.Kind == types.Int && rt.Kind == types.Fixed) || (lt.Kind == types.Fixed && rt.Kind == types.Int) {
		c.errorf(e.P, "mixed int/fixed arithmetic; convert explicitly")
		return types.InvalidT
	}
	c.errorf(e.P, "invalid operands to %s: %s and %s", e.Op, typeName(lt), typeName(rt))
	return types.InvalidT
}

// checkBitwise checks `& | ^ << >>` — int only (Ch4: Bitwise Operators).
func (c *checker) checkBitwise(e *ast.Binary) *types.Type {
	lt := c.checkExpr(e.X, nil)
	rt := c.checkExpr(e.Y, nil)
	if lt == types.InvalidT || rt == types.InvalidT {
		return types.InvalidT
	}
	if lt.Kind != types.Int || rt.Kind != types.Int {
		c.errorf(e.P, "bitwise operator requires int operands")
		return types.InvalidT
	}
	return types.IntT
}

// isNilLit reports whether e is the literal `nil`.
func isNilLit(e ast.Expr) bool {
	_, ok := e.(*ast.NilLit)
	return ok
}

// checkComparison checks `== != < <= > >=`. allowEnum is true for ==/!=;
// enums support only those two (Ch3: Enums, Operations), and so does nil
// (Ch3: nil is only valid for window/resource references).
//
// nil is resolved the same way a bare enum member is: check the OTHER
// operand first and feed its type back in as `expected` for the nil side,
// so `w != nil` (any resource-typed operand) type-checks instead of
// reporting nil's own "only valid for ..." error against a nil `expected`.
func (c *checker) checkComparison(e *ast.Binary, allowEnum bool) *types.Type {
	var lt, rt *types.Type
	switch {
	case isNilLit(e.X) && isNilLit(e.Y):
		c.errorf(e.P, "nil is only valid for window and resource references")
		return types.InvalidT
	case isNilLit(e.X):
		rt = c.checkExpr(e.Y, nil)
		lt = c.checkExpr(e.X, rt)
	case isNilLit(e.Y):
		lt = c.checkExpr(e.X, nil)
		rt = c.checkExpr(e.Y, lt)
	case c.isBareIdentCandidate(e.X):
		rt = c.checkExpr(e.Y, nil)
		if rt != types.InvalidT && rt.Kind == types.Enum {
			lt = c.checkExpr(e.X, rt)
		} else {
			lt = c.checkExpr(e.X, nil)
		}
	default:
		lt = c.checkExpr(e.X, nil)
		if lt != types.InvalidT && lt.Kind == types.Enum {
			rt = c.checkExpr(e.Y, lt)
		} else {
			rt = c.checkExpr(e.Y, nil)
		}
	}
	if lt == types.InvalidT || rt == types.InvalidT {
		return types.InvalidT
	}
	if !allowEnum {
		if lt.Kind == types.Enum || rt.Kind == types.Enum {
			c.errorf(e.P, "enums are not ordered")
			return types.InvalidT
		}
		if isNilLit(e.X) || isNilLit(e.Y) {
			c.errorf(e.P, "nil is only valid with == or !=")
			return types.InvalidT
		}
	}
	// String and text compare byte-wise, in either direction, at every
	// comparison operator (Ch3: Strings, Text; Ch4 level 5).
	textish := func(t *types.Type) bool { return t.Kind == types.String || t.Kind == types.Text }
	if textish(lt) && textish(rt) {
		return types.BoolT
	}
	// Structural equality is undefined for aggregates (Ch3 defines
	// comparison only for scalars/strings/text/chars/enums/refs); reject
	// rather than silently compare by identity. A future release may define
	// structural comparison for these.
	if lt.Kind == rt.Kind {
		switch lt.Kind {
		case types.Record:
			c.errorf(e.P, "records cannot be compared")
			return types.InvalidT
		case types.List:
			c.errorf(e.P, "lists cannot be compared")
			return types.InvalidT
		case types.Map:
			c.errorf(e.P, "maps cannot be compared")
			return types.InvalidT
		}
	}
	if !compatible(lt, rt) && !compatible(rt, lt) {
		c.errorf(e.P, "type mismatch: %s and %s", typeName(lt), typeName(rt))
		return types.InvalidT
	}
	return types.BoolT
}

// checkBoolOp checks `and`/`or` — bool operands only (Ch4 precedence table).
func (c *checker) checkBoolOp(e *ast.Binary) *types.Type {
	lt := c.checkExpr(e.X, types.BoolT)
	rt := c.checkExpr(e.Y, types.BoolT)
	if lt == types.InvalidT || rt == types.InvalidT {
		return types.InvalidT
	}
	if lt.Kind != types.Bool || rt.Kind != types.Bool {
		c.errorf(e.P, "condition must be bool")
		return types.InvalidT
	}
	return types.BoolT
}

// checkIndex checks `a[i]` — string/text -> char, array/list -> elem, map
// -> value (Ch3: Strings, Lists, Maps, Text; Ch4 precedence level 1).
func (c *checker) checkIndex(e *ast.Index) *types.Type {
	xt := c.checkExpr(e.X, nil)
	if xt == types.InvalidT {
		return types.InvalidT
	}
	switch xt.Kind {
	case types.String, types.Text:
		it := c.checkExpr(e.I, types.IntT)
		if it != types.InvalidT && it.Kind != types.Int {
			c.errorf(e.I.Pos(), "index must be int")
		}
		return types.CharT
	case types.Array, types.List:
		it := c.checkExpr(e.I, types.IntT)
		if it != types.InvalidT && it.Kind != types.Int {
			c.errorf(e.I.Pos(), "index must be int")
		}
		return xt.Elem
	case types.Map:
		it := c.checkExpr(e.I, types.StringT(255))
		if it != types.InvalidT && it.Kind != types.String {
			c.errorf(e.I.Pos(), "map index must be string")
		}
		return xt.Elem
	default:
		c.errorf(e.P, "cannot index %s", typeName(xt))
		return types.InvalidT
	}
}

// checkSelect checks a bare `a.b` (field, or a no-argument property like
// .length/.count) — method calls are handled in checkCall/checkMethodCall
// since only a Call carries argument expressions.
//
// Two bases need special-casing before the generic checkExpr(e.X, nil)
// below, because they aren't ordinary values: a window TYPE name used in
// expression position (only `.front` is valid: `Doc.front`, Ch8) and a menu
// name (only `.ItemName` is valid, en route to `.enabled`, Ch9).
func (c *checker) checkSelect(e *ast.Select) *types.Type {
	if id, ok := e.X.(*ast.Ident); ok {
		if id.Name == "file" {
			c.errorf(e.P, "file.%s must be called", e.Name)
			return types.InvalidT
		}
		if sym, ok := c.scope.Lookup(id.Name); ok {
			if sym.IsMenu {
				return c.checkMenuItemName(e, sym)
			}
			if sym.IsType && sym.Type.Kind == types.WindowRef && e.Name == "front" {
				return sym.Type
			}
		}
	}
	xt := c.checkExpr(e.X, nil)
	if xt == types.InvalidT {
		return types.InvalidT
	}
	switch xt.Kind {
	case types.Record:
		for _, f := range xt.Record.Fields {
			if f.Name == e.Name {
				return f.Type
			}
		}
		// ponytail: `isNew` is only meaningful on a record delivered by an
		// `accepted` handler (Ch10) — tracking that provenance through every
		// expression form a record value can flow through is more machinery
		// than this task needs, so it's allowed as a bool pseudo-field on
		// ANY record expression. Deliberately permissive; a later pass can
		// narrow it if that ever matters.
		if e.Name == "isNew" {
			return types.BoolT
		}
	case types.ErrorType:
		// Ch3: error is `{ code: int, message: string }`.
		switch e.Name {
		case "code":
			return types.IntT
		case "message":
			return types.StringT(255)
		}
	case types.String, types.Text:
		if e.Name == "length" {
			return types.IntT
		}
	case types.List, types.Map:
		if e.Name == "count" {
			return types.IntT
		}
	case types.WindowRef:
		return c.checkWindowRefSelect(e, xt)
	case types.Widget:
		return c.checkWidgetSelect(e, xt)
	case types.MenuItem:
		if e.Name == "enabled" {
			return types.BoolT
		}
	}
	c.errorf(e.P, "undefined: %s", e.Name)
	return types.InvalidT
}

func (c *checker) checkNewExpr(e *ast.NewExpr) *types.Type {
	sym, ok := c.scope.Lookup(e.Type)
	if !ok {
		c.errorf(e.P, "undefined: %s", e.Type)
		return types.InvalidT
	}
	if !sym.IsType || sym.Type.Kind != types.Record {
		c.errorf(e.P, "cannot use new with non-record type %s", e.Type)
		return types.InvalidT
	}
	return sym.Type
}

// checkOpenExpr checks `open W` (an expression: keeps the reference). Window
// symbols are not registered until Task 11 (windows are skipped entirely by
// this task's declaration pass), so this always reports "undefined" for
// now, exactly like any other unresolved name.
func (c *checker) checkOpenExpr(e *ast.OpenExpr) *types.Type {
	sym, ok := c.scope.Lookup(e.Window)
	if !ok {
		c.errorf(e.P, "undefined: %s", e.Window)
		return types.InvalidT
	}
	if !sym.IsType || sym.Type.Kind != types.WindowRef {
		c.errorf(e.P, "cannot open non-window type %s", e.Window)
		return types.InvalidT
	}
	return sym.Type
}

// ---- calls: conversions, function calls, method calls ----

func (c *checker) checkCall(e *ast.Call, expected *types.Type) *types.Type {
	switch fn := e.Fn.(type) {
	case *ast.Ident:
		return c.checkIdentCall(e, fn)
	case *ast.Select:
		return c.checkMethodCall(fn, e.Args)
	default:
		c.errorf(e.P, "cannot call this expression")
		return types.InvalidT
	}
}

// checkIdentCall handles `name(args)` where name is a bare identifier:
// either a numeric/enum conversion (Ch3: Numeric Conversions, Enums) or a
// call to a user-declared function.
func (c *checker) checkIdentCall(e *ast.Call, fn *ast.Ident) *types.Type {
	switch fn.Name {
	case "int":
		return c.checkConversion(e, types.IntT, "int")
	case "fixed":
		return c.checkConversion(e, types.FixedT, "fixed")
	case "char":
		return c.checkConversion(e, types.CharT, "char")
	}
	sym, ok := c.scope.Lookup(fn.Name)
	if !ok {
		c.errorf(e.P, "undefined: %s", fn.Name)
		return types.InvalidT
	}
	if sym.IsType {
		if sym.Type.Kind == types.Enum {
			return c.checkConversion(e, sym.Type, fn.Name)
		}
		c.errorf(e.P, "cannot convert to %s", fn.Name)
		return types.InvalidT
	}
	if sym.IsFunc {
		return c.checkArgs(e.P, e.Args, sym.Func.Params, sym.Func.Ret)
	}
	c.errorf(e.P, "%s is not callable", fn.Name)
	return types.InvalidT
}

// checkConversion checks a single-argument conversion call against target:
// int(fixed|char|enum), fixed(int), char(int), EnumName(int).
func (c *checker) checkConversion(e *ast.Call, target *types.Type, name string) *types.Type {
	if len(e.Args) != 1 {
		c.errorf(e.P, "conversion %s takes exactly one argument", name)
		return types.InvalidT
	}
	at := c.checkExpr(e.Args[0], nil)
	if at == types.InvalidT {
		return types.InvalidT
	}
	ok := false
	switch {
	case target == types.IntT:
		ok = at.Kind == types.Fixed || at.Kind == types.Char || at.Kind == types.Enum
	case target == types.FixedT:
		ok = at.Kind == types.Int
	case target == types.CharT:
		ok = at.Kind == types.Int
	case target.Kind == types.Enum:
		ok = at.Kind == types.Int
	}
	if !ok {
		c.errorf(e.P, "cannot convert %s to %s", typeName(at), name)
		return types.InvalidT
	}
	return target
}

// checkArgs type-checks a fixed-arity call's arguments against params
// (bidirectionally, so bare enum members and nil resolve) and returns ret,
// or types.VoidT for a procedure (ret == nil).
func (c *checker) checkArgs(pos source.Pos, args []ast.Expr, params []*types.Type, ret *types.Type) *types.Type {
	if len(args) != len(params) {
		c.errorf(pos, "wrong number of arguments")
	} else {
		for i, pt := range params {
			at := c.checkExpr(args[i], pt)
			if at != types.InvalidT && !compatible(at, pt) {
				c.errorf(args[i].Pos(), "cannot use %s where %s is expected", typeName(at), typeName(pt))
			}
		}
	}
	if ret == nil {
		return types.VoidT
	}
	return ret
}

// checkParamArg checks one built-in method/function argument against a
// paramSpec (see builtins.go), which may allow more than one concrete type.
func (c *checker) checkParamArg(arg ast.Expr, p paramSpec) {
	switch {
	case p.AnyCharArray:
		t := c.checkExpr(arg, nil)
		if t == types.InvalidT {
			return
		}
		if !(t.Kind == types.Array && t.Elem != nil && t.Elem.Kind == types.Char) {
			c.errorf(arg.Pos(), "cannot use %s where a char array is expected", typeName(t))
		}
	case p.AnyRecordish:
		t := c.checkExpr(arg, nil)
		if t == types.InvalidT {
			return
		}
		ok := t.Kind == types.Record || ((t.Kind == types.List || t.Kind == types.Map) && t.Elem != nil && t.Elem.Kind == types.Record)
		if !ok {
			c.errorf(arg.Pos(), "cannot use %s where a record is expected", typeName(t))
		}
	case len(p.OneOfKinds) > 0:
		t := c.checkExpr(arg, nil)
		if t == types.InvalidT {
			return
		}
		for _, k := range p.OneOfKinds {
			if t.Kind == k {
				return
			}
		}
		c.errorf(arg.Pos(), "cannot use %s here (expected %s)", typeName(t), kindsList(p.OneOfKinds))
	default:
		t := c.checkExpr(arg, p.T)
		if t != types.InvalidT && !compatible(t, p.T) {
			c.errorf(arg.Pos(), "cannot use %s where %s is expected", typeName(t), typeName(p.T))
		}
	}
}

// checkTableMethod checks a call against a fixed methodSig table (string,
// text, connection, listener, serviceBrowser, and the `file` namespace).
func (c *checker) checkTableMethod(table map[string]methodSig, sel *ast.Select, args []ast.Expr) *types.Type {
	sig, ok := table[sel.Name]
	if !ok {
		c.errorf(sel.P, "undefined: %s", sel.Name)
		return types.InvalidT
	}
	if len(args) != len(sig.Params) {
		c.errorf(sel.P, "wrong number of arguments to %s", sel.Name)
	} else {
		for i, p := range sig.Params {
			c.checkParamArg(args[i], p)
		}
	}
	if sig.Ret == nil {
		return types.VoidT
	}
	return sig.Ret
}

// checkListMethod checks `list of T` operations (Ch3: Lists); the element
// type is per-declaration, so this isn't table-driven like the fixed
// signatures in builtins.go.
func (c *checker) checkListMethod(lt *types.Type, sel *ast.Select, args []ast.Expr) *types.Type {
	elem := lt.Elem
	switch sel.Name {
	case "add", "push", "unshift":
		if len(args) != 1 {
			c.errorf(sel.P, "wrong number of arguments to %s", sel.Name)
			return types.VoidT
		}
		c.checkParamArg(args[0], paramSpec{T: elem})
		return types.VoidT
	case "pop", "shift", "first", "last":
		if len(args) != 0 {
			c.errorf(sel.P, "wrong number of arguments to %s", sel.Name)
		}
		return elem
	case "remove":
		if len(args) != 1 {
			c.errorf(sel.P, "wrong number of arguments to %s", sel.Name)
			return types.VoidT
		}
		c.checkParamArg(args[0], paramSpec{T: types.IntT})
		return types.VoidT
	case "count":
		if len(args) != 0 {
			c.errorf(sel.P, "count takes no arguments")
		}
		return types.IntT
	default:
		c.errorf(sel.P, "undefined: %s", sel.Name)
		return types.InvalidT
	}
}

// checkMapMethod checks `map of T` operations (Ch3: Maps).
func (c *checker) checkMapMethod(mt *types.Type, sel *ast.Select, args []ast.Expr) *types.Type {
	elem := mt.Elem
	switch sel.Name {
	case "get":
		if len(args) != 2 {
			c.errorf(sel.P, "wrong number of arguments to %s", sel.Name)
			return elem
		}
		c.checkParamArg(args[0], paramSpec{T: types.StringT(255)})
		c.checkParamArg(args[1], paramSpec{T: elem})
		return elem
	case "has":
		if len(args) != 1 {
			c.errorf(sel.P, "wrong number of arguments to %s", sel.Name)
			return types.BoolT
		}
		c.checkParamArg(args[0], paramSpec{T: types.StringT(255)})
		return types.BoolT
	case "remove":
		if len(args) != 1 {
			c.errorf(sel.P, "wrong number of arguments to %s", sel.Name)
			return types.VoidT
		}
		c.checkParamArg(args[0], paramSpec{T: types.StringT(255)})
		return types.VoidT
	case "count":
		if len(args) != 0 {
			c.errorf(sel.P, "count takes no arguments")
		}
		return types.IntT
	default:
		c.errorf(sel.P, "undefined: %s", sel.Name)
		return types.InvalidT
	}
}

// checkFileCall dispatches `file.fn(args)` — the `file` namespace has no
// value or type of its own (Ch12: Files); it's recognized syntactically by
// name, like the `window` keyword.
func (c *checker) checkFileCall(sel *ast.Select, args []ast.Expr) *types.Type {
	return c.checkTableMethod(fileFuncs, sel, args)
}

// checkMethodCall dispatches `x.name(args)` by the receiver's kind.
func (c *checker) checkMethodCall(sel *ast.Select, args []ast.Expr) *types.Type {
	if id, ok := sel.X.(*ast.Ident); ok && id.Name == "file" {
		return c.checkFileCall(sel, args)
	}
	xt := c.checkExpr(sel.X, nil)
	if xt == types.InvalidT {
		return types.InvalidT
	}
	switch xt.Kind {
	case types.List:
		return c.checkListMethod(xt, sel, args)
	case types.Map:
		return c.checkMapMethod(xt, sel, args)
	case types.String, types.Text:
		return c.checkTableMethod(stringTextMethods, sel, args)
	case types.Connection:
		return c.checkTableMethod(connectionMethods, sel, args)
	case types.Listener:
		return c.checkTableMethod(listenerMethods, sel, args)
	case types.ServiceBrowser:
		return c.checkTableMethod(serviceBrowserMethods, sel, args)
	case types.Widget:
		if xt.WidgetKind == "canvas" {
			return c.checkTableMethod(canvasMethods, sel, args)
		}
		c.errorf(sel.P, "undefined: %s", sel.Name)
		return types.InvalidT
	default:
		c.errorf(sel.P, "undefined: %s", sel.Name)
		return types.InvalidT
	}
}
