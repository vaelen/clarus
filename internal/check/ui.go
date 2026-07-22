// Windows and menus: building their declaration-time WindowInfo/MenuInfo
// (Ch8, Ch9, Ch10) and the Select dispatch for their runtime surface
// (WindowRef instance access, widget runtime properties, `Menu.Item.enabled`).
package check

import (
	"clarus/internal/ast"
	"clarus/internal/types"
)

// MenuInfo is the named-type identity for a menu declaration — the checker's
// own (not internal/types') payload for a menu Symbol, since a menu is never
// a value; it's only ever the base of `MenuName.ItemName` (Ch9).
type MenuInfo struct {
	Name  string
	Items map[string]bool
}

// windowTopProps: the window-body properties from Ch8's declaration table
// (title/size/resizable). `form for` is its own WindowItem node, not a
// Property, so it isn't listed here.
var windowTopProps = map[string]bool{"title": true, "size": true, "resizable": true}

// widgetDeclProps is Ch8's widget property table (declaration-time
// properties column), transcribed per widget kind.
var widgetDeclProps = map[string]map[string]bool{
	"button":   {"caption": true, "at": true, "width": true, "default": true, "cancel": true},
	"field":    {"label": true, "at": true, "width": true, "binds": true},
	"textview": {"at": true, "fill": true, "scrollbar": true},
	"check":    {"caption": true, "at": true, "binds": true},
	"popup":    {"label": true, "at": true, "binds": true},
	"table":    {"rows": true, "at": true, "fill": true},
	"canvas":   {"at": true, "fill": true, "buffered": true},
	"label":    {"text": true, "at": true},
}

// widgetRuntimeProps is Ch8's widget property table (runtime properties
// column): the types a `Widget.property` Select yields inside a handler.
// canvas reuses canvasProperties (builtins.go) — the same data Task 10 left
// unwired, now dispatched from checkSelect.
var widgetRuntimeProps = map[string]map[string]*types.Type{
	"button":   {"caption": types.StringT(255), "enabled": types.BoolT},
	"field":    {"text": types.StringT(255), "enabled": types.BoolT},
	"textview": {"text": types.TextT},
	"check":    {"checked": types.BoolT},
	"popup":    {"selected": types.IntT},
	"table":    {"selected": types.IntT},
	"canvas":   canvasProperties,
	"label":    {"text": types.StringT(255)},
}

// checkWindowDecl builds a WindowInfo (Ch8: Window Declaration, Window Body;
// Ch10: Form Windows) and declares the window's name as a type Symbol whose
// Type is a WindowRef naming this WindowInfo.
func (c *checker) checkWindowDecl(d *ast.WindowDecl) {
	info := &types.WindowInfo{Name: d.Name}

	// First pass: resolve `form for` before widgets, since `binds:`
	// validation (below) needs FormRecord regardless of where in the body
	// `form for` appears.
	for _, item := range d.Items {
		ff, ok := item.(*ast.FormFor)
		if !ok {
			continue
		}
		sym, ok := c.scope.Lookup(ff.Record)
		if !ok || !sym.IsType || sym.Type.Kind != types.Record {
			c.errorf(ff.P, "form for names an undefined record: %s", ff.Record)
			continue
		}
		info.IsForm = true
		info.FormRecord = sym.Type.Record
	}

	// Track declared names to detect collisions: title (reserved), widget names, var names
	declaredNames := map[string]bool{"title": true}

	for _, item := range d.Items {
		switch it := item.(type) {
		case *ast.FormFor:
			// handled above
		case *ast.Property:
			if !windowTopProps[it.Name] {
				c.errorf(it.P, "unknown property %s for window", it.Name)
			}
		case *ast.Column:
			c.errorf(it.P, "unknown property column for window")
		case *ast.VarDecl:
			if declaredNames[it.Name] {
				c.errorf(it.P, "redeclaration of %s", it.Name)
			} else {
				declaredNames[it.Name] = true
			}
			info.Vars = append(info.Vars, c.checkWindowVar(it))
		case *ast.Widget:
			if declaredNames[it.Name] {
				c.errorf(it.P, "redeclaration of %s", it.Name)
			} else {
				declaredNames[it.Name] = true
			}
			info.Widgets = append(info.Widgets, c.checkWidget(it, info))
		}
	}

	sym := Symbol{Name: d.Name, IsType: true, Type: &types.Type{Kind: types.WindowRef, Window: info}}
	if err := c.scope.Declare(sym); err != nil {
		c.errorf(d.P, "%s", err.Error())
	}
}

// checkWindowVar checks one per-instance `var` declared in a window body
// (Ch8: Window Body) — same shape as a top-level var, but recorded into the
// WindowInfo rather than declared into the global scope.
func (c *checker) checkWindowVar(v *ast.VarDecl) types.FieldInfo {
	t := c.resolveType(v.Type)
	if v.Init != nil {
		it := c.checkExpr(v.Init, t)
		if it != types.InvalidT && !compatible(it, t) {
			c.errorf(v.P, "cannot assign %s to %s", typeName(it), typeName(t))
		}
	}
	return types.FieldInfo{Name: v.Name, Type: t}
}

// checkWidget validates one widget declaration's properties against Ch8's
// per-kind property table and, for a table widget, its columns against
// Ch10's table-column rules.
func (c *checker) checkWidget(w *ast.Widget, info *types.WindowInfo) types.WidgetInfo {
	allowed := widgetDeclProps[w.Kind]

	var rowRecord *types.RecordInfo
	if w.Kind == "table" {
		for _, p := range w.Props {
			if prop, ok := p.(*ast.Property); ok && prop.Name == "rows" {
				rowRecord = c.checkRowsProperty(prop)
			}
		}
	}

	binds := ""
	for _, p := range w.Props {
		switch it := p.(type) {
		case *ast.Property:
			if !allowed[it.Name] {
				c.errorf(it.P, "unknown property %s for %s", it.Name, w.Kind)
				continue
			}
			// ponytail: property VALUES (e.g. `fill: both`, `at: 10,
			// bottom`) aren't resolved against a vocabulary here — only
			// `binds` needs a value check to validate the form binding.
			// Plan 4's resource emitter validates the rest against the real
			// widget-property vocabulary.
			if it.Name == "binds" {
				binds = c.checkBindsProperty(it, w.Kind, info)
			}
		case *ast.Column:
			if w.Kind != "table" {
				c.errorf(it.P, "unknown property column for %s", w.Kind)
				continue
			}
			c.checkColumn(it, rowRecord)
		}
	}
	return types.WidgetInfo{Name: w.Name, Kind: w.Kind, Binds: binds}
}

// checkRowsProperty checks a table widget's `rows: expr` (Ch10: Table
// Binding) — expr must be a `list of` record, and that record becomes the
// row type against which `column ... shows` is resolved.
func (c *checker) checkRowsProperty(prop *ast.Property) *types.RecordInfo {
	if len(prop.Values) != 1 {
		c.errorf(prop.P, "rows: takes one list expression")
		return nil
	}
	t := c.checkExpr(prop.Values[0], nil)
	if t == types.InvalidT {
		return nil
	}
	if t.Kind != types.List || t.Elem == nil || t.Elem.Kind != types.Record {
		c.errorf(prop.P, "rows: must be a list of record")
		return nil
	}
	return t.Elem.Record
}

// checkColumn checks `column "Header" shows fieldName width N` (Ch10: Table
// Columns) — fieldName must be a field of the table's row record. rowRecord
// is nil when `rows:` was missing or already misdiagnosed; skip silently to
// avoid a cascading second error for the same root cause.
func (c *checker) checkColumn(col *ast.Column, rowRecord *types.RecordInfo) {
	if rowRecord == nil {
		return
	}
	for _, f := range rowRecord.Fields {
		if f.Name == col.Shows {
			return
		}
	}
	c.errorf(col.P, "no field %s on %s", col.Shows, rowRecord.Name)
}

// checkBindsProperty checks `binds: name` on a field/check/popup widget
// (Ch10: Form Windows, Type-Driven Widget Behavior). The value arrives as a
// bare Ident (never a dotted path — the form record's fields are the
// innermost scope), so it's read directly rather than type-checked as an
// expression, and resolved against the window's FormRecord.
func (c *checker) checkBindsProperty(prop *ast.Property, kind string, info *types.WindowInfo) string {
	if len(prop.Values) != 1 {
		c.errorf(prop.P, "binds: takes one field name")
		return ""
	}
	id, ok := prop.Values[0].(*ast.Ident)
	if !ok {
		c.errorf(prop.P, "binds: expects a bare field name")
		return ""
	}
	if info.FormRecord == nil {
		c.errorf(prop.P, "binds: requires the window to declare form for")
		return ""
	}
	var field *types.FieldInfo
	for i := range info.FormRecord.Fields {
		if info.FormRecord.Fields[i].Name == id.Name {
			field = &info.FormRecord.Fields[i]
			break
		}
	}
	if field == nil {
		c.errorf(prop.P, "no field %s on %s", id.Name, info.FormRecord.Name)
		return ""
	}
	compat := false
	switch kind {
	case "field":
		compat = field.Type.Kind == types.String || field.Type.Kind == types.Int || field.Type.Kind == types.Fixed
	case "check":
		compat = field.Type.Kind == types.Bool
	case "popup":
		compat = field.Type.Kind == types.Enum
	}
	if !compat {
		c.errorf(prop.P, "field %s (%s) is not compatible with %s", id.Name, typeName(field.Type), kind)
	}
	return id.Name
}

// checkMenuDecl builds a MenuInfo (Ch9: Menu Declaration) and declares the
// menu's name as a menu Symbol — entry shape (item/separator/standard edit)
// is already validated by the parser; only duplicate item names are a
// checker concern.
func (c *checker) checkMenuDecl(d *ast.MenuDecl) {
	info := &MenuInfo{Name: d.Name, Items: map[string]bool{}}
	for _, e := range d.Entries {
		if !e.IsItem {
			continue
		}
		if info.Items[e.Name] {
			c.errorf(e.P, "duplicate menu item %s", e.Name)
			continue
		}
		info.Items[e.Name] = true
	}
	if err := c.scope.Declare(Symbol{Name: d.Name, IsMenu: true, Menu: info}); err != nil {
		c.errorf(d.P, "%s", err.Error())
	}
}

// checkMenuItemName checks `MenuName.ItemName` — the base of the
// `MenuName.ItemName.enabled` runtime property (Ch9) and of an `on
// Item.select` handler path inside `extend MenuName`.
func (c *checker) checkMenuItemName(e *ast.Select, sym Symbol) *types.Type {
	if !sym.Menu.Items[e.Name] {
		c.errorf(e.P, "undefined: %s", e.Name)
		return types.InvalidT
	}
	return &types.Type{Kind: types.MenuItem}
}

// checkWindowRefSelect checks a WindowRef value's Select (Ch8: Window
// Instances): its per-instance vars, its widgets (yielding a widget
// pseudo-type), and the `title: string` property.
func (c *checker) checkWindowRefSelect(e *ast.Select, xt *types.Type) *types.Type {
	w := xt.Window
	if e.Name == "title" {
		return types.StringT(255)
	}
	for _, v := range w.Vars {
		if v.Name == e.Name {
			return v.Type
		}
	}
	for _, wi := range w.Widgets {
		if wi.Name == e.Name {
			return &types.Type{Kind: types.Widget, WidgetKind: wi.Kind}
		}
	}
	c.errorf(e.P, "undefined: %s", e.Name)
	return types.InvalidT
}

// checkWidgetSelect checks a widget pseudo-value's Select — Ch8's runtime
// properties column, keyed by widget kind (widgetRuntimeProps above).
func (c *checker) checkWidgetSelect(e *ast.Select, xt *types.Type) *types.Type {
	if t, ok := widgetRuntimeProps[xt.WidgetKind][e.Name]; ok {
		return t
	}
	c.errorf(e.P, "undefined: %s", e.Name)
	return types.InvalidT
}
