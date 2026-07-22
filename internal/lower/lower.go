// Package lower lowers a type-checked Clarus program (AST + check.Info) into
// the typed IR (internal/ir) that the C printer (Task 8) walks. It is the
// one place host-build support is enforced: window/menu/extend/every
// declarations, resource types (connection/listener/serviceBrowser,
// windows), dialogs beyond alert, and file.save/file.load all produce a
// "host build does not support X yet" diagnostic instead of IR.
//
// Program assumes its input already passed check.Files clean (declare-
// before-use, no type errors) — exactly as check.Files itself assumes a
// clean parse. A missing check.Info entry for an expression this package
// must lower is therefore a Task 2 coverage bug, not a case to guess at; see
// (*lowerer).mustType in expr.go.
package lower

import (
	"fmt"

	"clarus/internal/ast"
	"clarus/internal/check"
	"clarus/internal/ir"
	"clarus/internal/source"
	"clarus/internal/types"
)

// lowerer holds the state of one Program call.
type lowerer struct {
	f     *source.File
	diags []source.Diag
	info  *check.Info
	prog  *ir.Program

	// declTypes resolves named types (record/enum declarations, plus the
	// builtin resource/error/saveChoice type names) by name. check.Info
	// doesn't export the checker's own symbol table, so the lowerer rebuilds
	// just enough of it — declared in the same declare-before-use order the
	// checker required — to resolve the TypeExprs (VarDecl.Type, record
	// field types) that never went through checkExpr and so have no
	// check.Info.Types entry of their own.
	declTypes map[string]*types.Type

	strIdx map[string]int // interning cache into prog.StrLits, by literal value
}

// Program lowers files/trees (already type-checked by check.Files, whose
// Info is passed in) into an *ir.Program. Diagnostics are reported only for
// host-unsupported constructs — never for type errors, which check.Files
// already owns.
func Program(files []*source.File, trees []*ast.File, info *check.Info) (*ir.Program, []source.Diag) {
	l := &lowerer{
		info:      info,
		prog:      &ir.Program{},
		strIdx:    make(map[string]int),
		declTypes: builtinDeclTypes(),
	}
	for i, tree := range trees {
		l.f = files[i]
		for _, d := range tree.Decls {
			l.lowerDecl(d)
		}
	}
	return l.prog, l.diags
}

// builtinDeclTypes seeds declTypes with the checker's own builtin type names
// (registerBuiltins in internal/check/builtins.go) so resolveType can tell a
// genuinely undefined name from a resource type it must flag unsupported.
func builtinDeclTypes() map[string]*types.Type {
	return map[string]*types.Type{
		"connection":     {Kind: types.Connection},
		"listener":       {Kind: types.Listener},
		"serviceBrowser": {Kind: types.ServiceBrowser},
		"address":        types.AddressT,
		"error":          types.ErrT,
		"saveChoice":     types.SaveChoice,
	}
}

// unsupported records a "host build does not support X yet" diagnostic.
func (l *lowerer) unsupported(pos source.Pos, what string) {
	l.diags = append(l.diags, source.Diag{File: l.f, Pos: pos, Msg: fmt.Sprintf("host build does not support %s yet", what)})
}

// unsupportedKind reports the diagnostic name for a type Kind no
// host-buildable program may use as a variable or field's type (Global
// Constraints: windows and the network resource types), or ("", false) if k
// needs no such gating.
func unsupportedKind(k types.Kind) (string, bool) {
	switch k {
	case types.WindowRef:
		return "window", true
	case types.Connection:
		return "connection", true
	case types.Listener:
		return "listener", true
	case types.ServiceBrowser:
		return "serviceBrowser", true
	case types.Address:
		return "address", true
	default:
		return "", false
	}
}

// resolveType mirrors the checker's own resolveType (internal/check/check.go)
// against declTypes instead of a scope, since Program only needs top-level
// named-type resolution (no locals/params — Task 6 lowers globals only).
func (l *lowerer) resolveType(te ast.TypeExpr) *types.Type {
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
		if dt, ok := l.declTypes[t.Name]; ok {
			return dt
		}
		panic(fmt.Sprintf("lower: undefined type %s at %v (check.Files should have rejected this)", t.Name, t.P))
	case *ast.StringType:
		return types.StringT(t.N)
	case *ast.ListType:
		return types.ListT(l.resolveType(t.Elem))
	case *ast.MapType:
		return types.MapT(l.resolveType(t.Val))
	case *ast.ArrayType:
		return types.ArrayT(l.resolveType(t.Elem), t.N)
	default:
		panic(fmt.Sprintf("lower: unhandled TypeExpr %T", te))
	}
}

// lowerType maps a checked *types.Type to its IR representation. Str keeps
// its capacity (N); Rec/Enum carry their declaration name; Err is the
// error-record type. Kinds a host build never reaches here (WindowRef and
// the resource types, screened by unsupportedKind before lowerType is ever
// called on them) panic — reaching this function is a lowerer bug, not a
// user error.
func lowerType(t *types.Type) ir.Type {
	switch t.Kind {
	case types.Int:
		return ir.Type{K: ir.Int}
	case types.Bool:
		return ir.Type{K: ir.Bool}
	case types.Fixed:
		return ir.Type{K: ir.Fixed}
	case types.Char:
		return ir.Type{K: ir.Char}
	case types.String:
		return ir.Type{K: ir.Str, N: t.N}
	case types.Text:
		return ir.Type{K: ir.Text}
	case types.Void:
		return ir.Type{K: ir.Void}
	case types.ErrorType:
		return ir.Type{K: ir.Err}
	case types.Record:
		return ir.Type{K: ir.Rec, Name: t.Record.Name}
	case types.Enum:
		return ir.Type{K: ir.Enum, Name: t.Enum.Name}
	case types.Array:
		e := lowerType(t.Elem)
		return ir.Type{K: ir.Arr, N: t.N, Elem: &e}
	case types.List:
		e := lowerType(t.Elem)
		return ir.Type{K: ir.List, Elem: &e}
	case types.Map:
		e := lowerType(t.Elem)
		return ir.Type{K: ir.Map, Elem: &e}
	default:
		panic(fmt.Sprintf("lower: type kind %v has no host IR representation (host-unsupported check should have rejected it)", t.Kind))
	}
}

// lowerDecl dispatches one top-level declaration.
func (l *lowerer) lowerDecl(d ast.Decl) {
	switch d := d.(type) {
	case *ast.RecordDecl:
		l.lowerRecordDecl(d)
	case *ast.EnumDecl:
		l.lowerEnumDecl(d)
	case *ast.VarDecl:
		l.lowerGlobalVarDecl(d)
	case *ast.FuncDecl:
		// Task 7 lowers function bodies into ir.Func; nothing to build here.
	case *ast.WindowDecl:
		l.unsupported(d.P, "window")
		// Registered so a later `var w: W` (also unsupported, via
		// unsupportedKind) resolves instead of panicking as "undefined".
		l.declTypes[d.Name] = &types.Type{Kind: types.WindowRef}
	case *ast.MenuDecl:
		l.unsupported(d.P, "menu")
	case *ast.ExtendDecl:
		l.unsupported(d.P, "extend")
	case *ast.HandlerDecl:
		// Top-level `on App.launch`/`on App.startEmpty` detection lands in
		// Task 7 alongside the rest of handler-body lowering. Handlers on a
		// resource variable need nothing here: the variable itself is
		// already flagged host-unsupported at its own declaration.
	case *ast.EveryDecl:
		l.unsupported(d.P, "every")
	}
}

// lowerRecordDecl builds the record's RecordLayout (field slots with their
// lowered type and constant default) and registers its name in declTypes so
// later declarations can resolve it, mirroring checker.checkRecordDecl.
func (l *lowerer) lowerRecordDecl(d *ast.RecordDecl) {
	fieldTypes := make([]*types.Type, len(d.Fields))
	for i, f := range d.Fields {
		fieldTypes[i] = l.resolveType(f.Type)
	}
	info := &types.RecordInfo{Name: d.Name}
	info.Fields = make([]types.FieldInfo, len(d.Fields))
	for i, f := range d.Fields {
		info.Fields[i] = types.FieldInfo{Name: f.Name, Type: fieldTypes[i]}
	}
	l.declTypes[d.Name] = &types.Type{Kind: types.Record, Record: info}

	layout := &ir.RecordLayout{Name: d.Name}
	for i, f := range d.Fields {
		ft := fieldTypes[i]
		slot := ir.FieldSlot{Name: f.Name, DefaultStr: -1}
		if what, bad := unsupportedKind(ft.Kind); bad {
			l.unsupported(f.P, what)
			layout.Fields = append(layout.Fields, slot)
			continue
		}
		slot.T = lowerType(ft)
		if f.Default != nil {
			dv := l.lowerExpr(f.Default)
			if ft.Kind == types.String {
				slot.DefaultStr = dv.(*ir.StrConst).Idx
			} else {
				slot.Default = dv.(*ir.IntConst).V
			}
		}
		layout.Fields = append(layout.Fields, slot)
	}
	l.prog.Records = append(l.prog.Records, layout)
}

// lowerEnumDecl builds the enum's EnumLayout, replicating checker.
// checkEnumDecl's auto-numbering (member's own value, or previous+1) — that
// symbol-table state isn't exported via check.Info, so the lowerer rebuilds
// it from the AST, which check.Files already validated (unique names/values,
// range).
func (l *lowerer) lowerEnumDecl(d *ast.EnumDecl) {
	info := &types.EnumInfo{Name: d.Name}
	layout := &ir.EnumLayout{Name: d.Name}
	next := 0
	for _, m := range d.Members {
		val := next
		if m.HasValue {
			val = int(m.Value)
		}
		label := m.Label
		if label == "" {
			label = m.Name
		}
		info.Members = append(info.Members, types.EnumMemberInfo{Name: m.Name, Value: val, Label: label})
		layout.Members = append(layout.Members, m.Name)
		layout.Values = append(layout.Values, val)
		layout.Labels = append(layout.Labels, label)
		next = val + 1
	}
	l.declTypes[d.Name] = &types.Type{Kind: types.Enum, Enum: info}
	l.prog.Enums = append(l.prog.Enums, layout)
}

// lowerGlobalVarDecl lowers one top-level `var` into an ir.Global. Globals
// are appended in the same source-order traversal check.Files itself used to
// build info.GlobalOrder, so the resulting Program.Globals order matches it
// without needing a name lookup back into GlobalOrder.
func (l *lowerer) lowerGlobalVarDecl(d *ast.VarDecl) {
	t := l.resolveType(d.Type)
	if what, bad := unsupportedKind(t.Kind); bad {
		l.unsupported(d.P, what)
		return
	}
	g := &ir.Global{Name: d.Name, T: lowerType(t)}
	switch init := d.Init.(type) {
	case nil:
		// zero value
	case *ast.NewExpr:
		// `new T` constructs every field at its declared default (reference
		// Ch3: Records and Defaults) — precisely ir.Global's own "Init ==
		// nil -> zero value" contract, since RecordLayout already carries
		// those same defaults. No IR expression is needed at all; see
		// lowerExpr's default case for the (currently unreachable, Task
		// 6-scope) non-global-initializer use of `new`.
	default:
		g.Init = l.lowerExpr(init)
	}
	l.prog.Globals = append(l.prog.Globals, g)
}
