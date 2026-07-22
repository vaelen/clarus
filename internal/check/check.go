// Package check implements the Clarus type checker: declaration building
// (Ch3-Ch4 authoritative on semantics) and expression/statement checking.
package check

import (
	"fmt"

	"clarus/internal/ast"
	"clarus/internal/source"
	"clarus/internal/types"
)

// checker holds the state of one File() call: the source file (for
// diagnostics), the accumulated diagnostics, and the current scope, which
// grows as top-level declarations are processed (declare-before-use) and is
// swapped out (saved/restored) as function bodies and nested blocks are
// entered.
type checker struct {
	f     *source.File
	diags []source.Diag
	scope *Scope

	// curFuncRet is the enclosing function's return type, or nil when
	// checking a procedure body (bare `return` only) or outside any
	// function (top-level var initializers).
	curFuncRet *types.Type

	// curWindow is the WindowInfo of the enclosing window-scoped handler
	// body (extend W { on ... }), or nil outside one. It resolves the
	// `window` keyword (ast.WindowSelf) to that instance's WindowRef type.
	curWindow *types.WindowInfo

	// inCloseRequest is true while checking a closeRequest handler's body
	// (a window's own, never a widget's or menu item's) — the only place
	// `cancel` is valid (Ch5: Cancel).
	inCloseRequest bool

	// loopDepth counts enclosing while/for loop bodies (checkLoopBody
	// increments/decrements it); it does NOT count switch case/else bodies,
	// so break/continue inside a case body binds the enclosing LOOP, not the
	// switch (Ch5: Break and Continue, Switch). Zero outside any loop.
	loopDepth int

	// info accumulates the type information the lowering pass consumes:
	// every expression's checked type, resolved enum-member values, and
	// top-level var declaration order. Always allocated (see Files) so
	// checkExpr and checkIdent can record into it unconditionally.
	info *Info
}

// Info is the type information the checker exports for the lowering pass:
// every checked expression's type, resolved values for bare enum-member
// Idents (including field defaults), and top-level var declaration order.
type Info struct {
	Types       map[ast.Expr]*types.Type // type of every successfully checked expression
	EnumConsts  map[ast.Expr]int         // resolved VALUE for bare enum-member Idents and enum-typed defaults
	Consts      map[*ast.Ident]ConstVal  // resolved VALUE for every use of a `const`-declared name
	GlobalOrder []string                 // declaration order of globals (init order for lowering)
}

// ConstVal is a `const` declaration's compile-time value (Ch3: Constants),
// recorded per use-site in Info.Consts (mirroring the EnumConsts precedent:
// EnumConsts already records a resolved value per bare-enum-member Ident
// use, not per declaration; Consts does the same for const names, including
// where a const's value flows into another const's initializer). Exactly one
// of Int/Str holds the value, per IsStr — the same "one string field, one
// int64 field, no interface{}" shape as an EnumMemberInfo.Value, since a
// const's declared type is always int, fixed, char, bool, enum (all
// int64-representable), or string.
type ConstVal struct {
	IsStr bool
	Int   int64
	Str   string
}

func newInfo() *Info {
	return &Info{
		Types:      make(map[ast.Expr]*types.Type),
		EnumConsts: make(map[ast.Expr]int),
		Consts:     make(map[*ast.Ident]ConstVal),
	}
}

// File type-checks tree and returns all diagnostics found. Declarations are
// processed in source order in a single pass: each is checked against
// symbols declared so far, then declared itself (declare-before-use).
// Window/menu/extend/handler/every declarations are skipped entirely —
// Task 11 wires them up.
func File(f *source.File, tree *ast.File) []source.Diag {
	diags, _ := Files([]*source.File{f}, []*ast.File{tree})
	return diags
}

// Files type-checks multiple files as a single program (the driver's
// multi-file mode): top-level declarations from all trees are checked in a
// single pass, in argument order, so declare-before-use holds across the
// whole sequence exactly as it does for one file. Each diagnostic still
// carries the source.File its declaration came from, since c.f is switched
// to files[i] before that file's declarations are checked. The returned
// *Info is the type information the lowering pass consumes; it's still
// populated (though possibly incomplete) even when diagnostics are reported.
func Files(files []*source.File, trees []*ast.File) ([]source.Diag, *Info) {
	c := &checker{info: newInfo()}
	universe := NewScope(nil)
	registerBuiltins(universe)
	c.scope = NewScope(universe)

	for i, tree := range trees {
		c.f = files[i]
		for _, d := range tree.Decls {
			c.checkDecl(d)
		}
	}
	return c.diags, c.info
}

func (c *checker) errorf(pos source.Pos, format string, args ...interface{}) {
	c.diags = append(c.diags, source.Diag{File: c.f, Pos: pos, Msg: fmt.Sprintf(format, args...)})
}

func (c *checker) checkDecl(d ast.Decl) {
	switch d := d.(type) {
	case *ast.RecordDecl:
		c.checkRecordDecl(d)
	case *ast.EnumDecl:
		c.checkEnumDecl(d)
	case *ast.VarDecl:
		c.checkVarDecl(d)
		c.info.GlobalOrder = append(c.info.GlobalOrder, d.Name)
	case *ast.ConstDecl:
		c.checkConstDecl(d)
	case *ast.FuncDecl:
		c.checkFuncDecl(d)
	case *ast.WindowDecl:
		c.checkWindowDecl(d)
	case *ast.MenuDecl:
		c.checkMenuDecl(d)
	case *ast.ExtendDecl:
		c.checkExtendDecl(d)
	case *ast.HandlerDecl:
		c.checkTopHandlerDecl(d)
	case *ast.EveryDecl:
		c.checkEveryDecl(d)
	}
}

// resolveType maps a TypeExpr as written in source to a *types.Type,
// reporting "undefined: X" for an unresolvable name and returning
// types.InvalidT — never re-diagnosed by a caller (see compatible()).
func (c *checker) resolveType(te ast.TypeExpr) *types.Type {
	switch t := te.(type) {
	case *ast.NamedType:
		switch t.Name {
		case "int":
			return types.IntT
		case "bool":
			return types.BoolT
		case "fixed":
			return types.FixedT
		case "char":
			return types.CharT
		case "text":
			return types.TextT
		}
		sym, ok := c.scope.Lookup(t.Name)
		if !ok || !sym.IsType {
			c.errorf(t.P, "undefined: %s", t.Name)
			return types.InvalidT
		}
		return sym.Type
	case *ast.StringType:
		return types.StringT(t.N)
	case *ast.ListType:
		return types.ListT(c.resolveType(t.Elem))
	case *ast.MapType:
		return types.MapT(c.resolveType(t.Val))
	case *ast.ArrayType:
		return types.ArrayT(c.resolveType(t.Elem), t.N)
	default:
		return types.InvalidT
	}
}

// checkRecordDecl builds a RecordInfo (Ch3: Records and Defaults): field
// types are resolved first, then defaults are type-checked against them
// (an enum-typed field's bare-identifier default resolves against that
// field's own enum, via the expected-type parameter).
func (c *checker) checkRecordDecl(d *ast.RecordDecl) {
	info := &types.RecordInfo{Name: d.Name}
	fields := make([]types.FieldInfo, len(d.Fields))
	for i, f := range d.Fields {
		fields[i] = types.FieldInfo{Name: f.Name, Type: c.resolveType(f.Type)}
	}
	info.Fields = fields
	for i, f := range d.Fields {
		if f.Default == nil {
			continue
		}
		dt := c.checkExpr(f.Default, fields[i].Type)
		if dt != types.InvalidT && !compatible(dt, fields[i].Type) {
			c.errorf(f.P, "cannot assign %s to field %s of type %s", typeName(dt), f.Name, typeName(fields[i].Type))
		}
	}
	sym := Symbol{Name: d.Name, IsType: true, Type: &types.Type{Kind: types.Record, Record: info}}
	if err := c.scope.Declare(sym); err != nil {
		c.errorf(d.P, "%s", err.Error())
	}
}

// checkEnumDecl builds an EnumInfo (Ch3: Enums): members auto-number from 0
// or the previous value + 1; explicit values must fit 0-65535 and be unique
// within the enum; member names must be unique (reuses Scope.Declare's
// "redeclaration of X" via a throwaway scope, matching the language's own
// redeclaration wording).
func (c *checker) checkEnumDecl(d *ast.EnumDecl) {
	info := &types.EnumInfo{Name: d.Name}
	names := NewScope(nil)
	seenValues := make(map[int]bool)
	next := 0
	for _, m := range d.Members {
		val := next
		if m.HasValue {
			val = int(m.Value)
			if val < 0 || val > 65535 {
				c.errorf(m.P, "enum value out of range: %d", val)
			}
		}
		if seenValues[val] {
			c.errorf(m.P, "duplicate enum value %d", val)
		}
		seenValues[val] = true
		if err := names.Declare(Symbol{Name: m.Name}); err != nil {
			c.errorf(m.P, "%s", err.Error())
		}
		label := m.Label
		if label == "" {
			label = m.Name
		}
		info.Members = append(info.Members, types.EnumMemberInfo{Name: m.Name, Value: val, Label: label})
		next = val + 1
	}
	sym := Symbol{Name: d.Name, IsType: true, Type: &types.Type{Kind: types.Enum, Enum: info}}
	if err := c.scope.Declare(sym); err != nil {
		c.errorf(d.P, "%s", err.Error())
	}
}

// checkVarDecl checks a `var` declaration — global or local; both shapes
// (top-level Decl, and a Block's Vars) are the same *ast.VarDecl node, and
// both declare into whatever c.scope currently is.
func (c *checker) checkVarDecl(d *ast.VarDecl) {
	t := c.resolveType(d.Type)
	if d.Init != nil {
		it := c.checkExpr(d.Init, t)
		if it != types.InvalidT && !compatible(it, t) {
			c.errorf(d.P, "cannot assign %s to %s", typeName(it), typeName(t))
		}
	}
	if err := c.scope.Declare(Symbol{Name: d.Name, Type: t}); err != nil {
		c.errorf(d.P, "%s", err.Error())
	}
}

// checkConstDecl checks a `const` declaration (Ch3: Constants): the
// initializer must be a literal, an enum member, or a previously declared
// constant — never an arbitrary expression (the parser only ever hands
// ConstDecl.Value one of those shapes, via parseLiteralOrIdent) — and the
// const is then usable, via its recorded ConstVal, anywhere its type's value
// is: as a switch case label (checkCaseLabel) or inlined into another
// expression at lowering time (Info.Consts, populated per use-site by
// checkIdent).
func (c *checker) checkConstDecl(d *ast.ConstDecl) {
	t := c.resolveType(d.Type)
	// Const types are restricted to those representable at compile time.
	if t.Kind != types.Int && t.Kind != types.Fixed && t.Kind != types.Char && t.Kind != types.Bool && t.Kind != types.Enum && t.Kind != types.String {
		c.errorf(d.P, "const type must be int, fixed, char, bool, enum, or string")
		return
	}
	cv := c.constValue(d.Value, t)
	if err := c.scope.Declare(Symbol{Name: d.Name, Type: t, IsConst: true, ConstVal: cv}); err != nil {
		c.errorf(d.P, "%s", err.Error())
	}
}

// constValue type-checks a const initializer against its declared type t and
// returns its compile-time value. It defers to checkExpr/checkIdent for the
// ordinary type-checking work (literal typing, enum-member fallback,
// undefined-name/kind diagnostics), then adds the one rule generic
// expression-checking doesn't know: an Ident initializer must name another
// constant, not a plain variable.
func (c *checker) constValue(val ast.Expr, t *types.Type) ConstVal {
	id, isIdent := val.(*ast.Ident)
	vt := c.checkExpr(val, t)
	if vt == types.InvalidT {
		return ConstVal{}
	}
	if isIdent {
		if sym, found := c.scope.Lookup(id.Name); found {
			if !sym.IsConst {
				c.errorf(id.P, "constant initializer must be a literal, enum member, or constant")
				return ConstVal{}
			}
			if !compatible(sym.Type, t) {
				c.errorf(id.P, "cannot assign %s to %s", typeName(sym.Type), typeName(t))
			}
			return sym.ConstVal
		}
		// Not in scope: checkExpr succeeding means checkIdent resolved id as
		// a bare enum member against t (the only other way it returns
		// non-Invalid for an unresolved name), recording its value here.
		return ConstVal{Int: int64(c.info.EnumConsts[id])}
	}
	if !compatible(vt, t) {
		c.errorf(val.Pos(), "cannot assign %s to %s", typeName(vt), typeName(t))
	}
	return literalConstVal(val)
}

// literalConstVal extracts a ConstVal from one of the five literal AST
// nodes parseLiteralOrIdent can produce (see constValue).
func literalConstVal(e ast.Expr) ConstVal {
	switch v := e.(type) {
	case *ast.IntLit:
		return ConstVal{Int: v.Val}
	case *ast.FixedLit:
		return ConstVal{Int: int64(v.Raw)}
	case *ast.CharLit:
		return ConstVal{Int: int64(v.Val)}
	case *ast.StringLit:
		return ConstVal{IsStr: true, Str: v.Val}
	case *ast.BoolLit:
		if v.Val {
			return ConstVal{Int: 1}
		}
		return ConstVal{}
	default:
		return ConstVal{}
	}
}

// checkFuncDecl declares the function's signature before checking its body,
// so recursive calls resolve (Ch6: Recursion) — the one deliberate
// exception to "checked then declared".
func (c *checker) checkFuncDecl(d *ast.FuncDecl) {
	params := make([]*types.Type, len(d.Params))
	for i, p := range d.Params {
		params[i] = c.resolveType(p.Type)
	}
	var ret *types.Type
	if d.Ret != nil {
		ret = c.resolveType(d.Ret)
	}
	sig := &FuncSig{Params: params, Ret: ret}
	if err := c.scope.Declare(Symbol{Name: d.Name, IsFunc: true, Func: sig}); err != nil {
		c.errorf(d.P, "%s", err.Error())
	}

	fnScope := NewScope(c.scope)
	for i, p := range d.Params {
		if err := fnScope.Declare(Symbol{Name: p.Name, Type: params[i]}); err != nil {
			c.errorf(p.P, "%s", err.Error())
		}
	}

	savedScope, savedRet := c.scope, c.curFuncRet
	c.scope, c.curFuncRet = fnScope, ret
	c.checkBlock(d.Body)
	c.scope, c.curFuncRet = savedScope, savedRet
}

// checkBlock checks a block's local vars then its statements, in a scope
// nested under whatever c.scope currently is (so the block's own locals
// don't leak into the enclosing scope). Grown in Task 11 for UI/handler
// statement contexts.
func (c *checker) checkBlock(b *ast.Block) {
	saved := c.scope
	c.scope = NewScope(saved)
	for _, v := range b.Vars {
		c.checkVarDecl(v)
	}
	for _, s := range b.Stmts {
		c.checkStmt(s)
	}
	c.scope = saved
}

// checkStmt checks one statement (var decls, assignment, expression
// statements, while/if conditions, for loops, return, and — Task 11 —
// quit/cancel/open/close/edit).
func (c *checker) checkStmt(s ast.Stmt) {
	switch s := s.(type) {
	case *ast.AssignStmt:
		c.checkAssignStmt(s)
	case *ast.ExprStmt:
		c.checkExpr(s.X, nil)
	case *ast.IfStmt:
		c.checkIfStmt(s)
	case *ast.WhileStmt:
		c.checkWhileStmt(s)
	case *ast.ForStmt:
		c.checkForStmt(s)
	case *ast.ReturnStmt:
		c.checkReturnStmt(s)
	case *ast.QuitStmt:
		c.checkQuitStmt(s)
	case *ast.CancelStmt:
		c.checkCancelStmt(s)
	case *ast.BreakStmt:
		c.checkBreakStmt(s)
	case *ast.ContinueStmt:
		c.checkContinueStmt(s)
	case *ast.SwitchStmt:
		c.checkSwitchStmt(s)
	case *ast.OpenStmt:
		c.checkOpenStmt(s)
	case *ast.CloseStmt:
		c.checkCloseStmt(s)
	case *ast.EditStmt:
		c.checkEditStmt(s)
	}
}

func (c *checker) checkAssignStmt(s *ast.AssignStmt) {
	lt := c.checkExpr(s.LHS, nil)
	rt := c.checkExpr(s.RHS, lt)
	if id, ok := lvalueRootIdent(s.LHS); ok {
		if sym, found := c.scope.Lookup(id.Name); found && sym.IsConst {
			c.errorf(s.P, "cannot assign to constant %s", id.Name)
			return
		}
	}
	if lt == types.InvalidT || rt == types.InvalidT {
		return
	}
	if sel, ok := s.LHS.(*ast.Select); ok {
		if name, ok := c.readOnlyPropName(sel); ok {
			c.errorf(s.P, "cannot assign to read-only property %s", name)
			return
		}
	}
	if !compatible(rt, lt) {
		c.errorf(s.P, "cannot assign %s to %s", typeName(rt), typeName(lt))
	}
}

// readOnlyPropName reports whether sel is one of the read-only
// pseudo-properties (Ch3/Ch8: `front`, `count`, `length`, `isNew`, and the
// error type's `code`/`message`) and, if so, its name for the diagnostic.
// Widget runtime properties (text/caption/checked/selected/enabled/title)
// aren't pseudo-properties — they're real per-instance state — so they fall
// through unrecognized here and stay assignable.
//
// sel.X is re-checked to classify its kind; this is safe (no duplicate
// diagnostics) because the caller only reaches here once s.LHS as a whole
// has already checked clean, which requires sel.X to have checked clean too.
func (c *checker) readOnlyPropName(sel *ast.Select) (string, bool) {
	if sel.Name == "front" {
		if id, ok := sel.X.(*ast.Ident); ok {
			if sym, ok := c.scope.Lookup(id.Name); ok && sym.IsType && sym.Type.Kind == types.WindowRef {
				return "front", true
			}
		}
	}
	xt := c.checkExpr(sel.X, nil)
	switch xt.Kind {
	case types.List, types.Map:
		if sel.Name == "count" {
			return "count", true
		}
	case types.String, types.Text:
		if sel.Name == "length" {
			return "length", true
		}
	case types.Record:
		if sel.Name != "isNew" {
			return "", false
		}
		for _, f := range xt.Record.Fields {
			if f.Name == "isNew" {
				return "", false // a genuine field shadows the pseudo-field
			}
		}
		return "isNew", true
	case types.ErrorType:
		if sel.Name == "code" || sel.Name == "message" {
			return sel.Name, true
		}
	}
	return "", false
}

// lvalueRootIdent returns the Ident at the root of an lvalue chain — an
// Ident under any run of Select/Index (mirrors the parser's own isLvalue) —
// so checkAssignStmt can reject assigning through a const's field/index just
// as readily as assigning to the const name directly (Ch3: Constants,
// "Assigning to a constant is a compile error").
func lvalueRootIdent(e ast.Expr) (*ast.Ident, bool) {
	switch v := e.(type) {
	case *ast.Ident:
		return v, true
	case *ast.Select:
		return lvalueRootIdent(v.X)
	case *ast.Index:
		return lvalueRootIdent(v.X)
	default:
		return nil, false
	}
}

func (c *checker) checkCond(cond ast.Expr) {
	ct := c.checkExpr(cond, types.BoolT)
	if ct != types.InvalidT && ct.Kind != types.Bool {
		c.errorf(cond.Pos(), "condition must be bool")
	}
}

func (c *checker) checkIfStmt(s *ast.IfStmt) {
	c.checkCond(s.Cond)
	c.checkBlock(s.Then)
	switch e := s.Else.(type) {
	case *ast.Block:
		c.checkBlock(e)
	case *ast.IfStmt:
		c.checkIfStmt(e)
	}
}

func (c *checker) checkWhileStmt(s *ast.WhileStmt) {
	c.checkCond(s.Cond)
	c.checkLoopBody(s.Body)
}

// checkLoopBody checks a while/for loop's body with loopDepth incremented
// (Ch5: Break and Continue) — the sole place loopDepth changes; switch case
// bodies check with checkBlock directly, so a break inside one still binds
// whatever loop, if any, encloses the switch.
func (c *checker) checkLoopBody(b *ast.Block) {
	c.loopDepth++
	c.checkBlock(b)
	c.loopDepth--
}

// checkForStmt checks all three forms (Ch5: For): list iteration, map
// iteration (key + value), and an inclusive integer range.
func (c *checker) checkForStmt(s *ast.ForStmt) {
	seqT := c.checkExpr(s.Seq, nil)
	saved := c.scope
	c.scope = NewScope(saved)
	defer func() { c.scope = saved }()

	if s.ToExpr != nil {
		toT := c.checkExpr(s.ToExpr, nil)
		if seqT != types.InvalidT && seqT.Kind != types.Int {
			c.errorf(s.Seq.Pos(), "range bounds must be int")
		}
		if toT != types.InvalidT && toT.Kind != types.Int {
			c.errorf(s.ToExpr.Pos(), "range bounds must be int")
		}
		if s.V2 != "" {
			c.errorf(s.P, "range for takes one variable")
		}
		c.declareForVar(s.V1, types.IntT)
		c.checkLoopBody(s.Body)
		return
	}

	switch {
	case seqT == types.InvalidT:
		c.declareForVar(s.V1, types.InvalidT)
		if s.V2 != "" {
			c.declareForVar(s.V2, types.InvalidT)
		}
	case seqT.Kind == types.List:
		if s.V2 != "" {
			c.errorf(s.P, "list iteration takes one variable")
		}
		c.declareForVar(s.V1, seqT.Elem)
	case seqT.Kind == types.Map:
		if s.V2 == "" {
			c.errorf(s.P, "map iteration requires key and value variables")
		}
		c.declareForVar(s.V1, types.StringT(255))
		if s.V2 != "" {
			c.declareForVar(s.V2, seqT.Elem)
		}
	default:
		c.errorf(s.Seq.Pos(), "cannot iterate over %s", typeName(seqT))
	}
	c.checkLoopBody(s.Body)
}

func (c *checker) declareForVar(name string, t *types.Type) {
	if name == "" {
		return
	}
	_ = c.scope.Declare(Symbol{Name: name, Type: t})
}

// checkReturnStmt checks `return` / `return expr` (Ch5: Return). No
// return-path flow analysis is performed here — a function falling off the
// end without returning a value is a runtime concern in this design, not a
// compile error.
func (c *checker) checkReturnStmt(s *ast.ReturnStmt) {
	if s.X == nil {
		if c.curFuncRet != nil {
			c.errorf(s.P, "missing return value")
		}
		return
	}
	rt := c.checkExpr(s.X, c.curFuncRet)
	if c.curFuncRet == nil {
		c.errorf(s.P, "unexpected return value in a procedure")
		return
	}
	if rt != types.InvalidT && !compatible(rt, c.curFuncRet) {
		c.errorf(s.P, "cannot return %s as %s", typeName(rt), typeName(c.curFuncRet))
	}
}
