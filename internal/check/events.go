// Handlers, extend blocks, and timers: the Appendix B event-signature table
// and the checking of every place an `on` handler or `every` block can
// appear (Ch7 app events, Ch8 window/widget events, Ch9 menu-item events,
// Ch10 form events, Ch12 resource events).
package check

import (
	"strings"

	"clarus/internal/ast"
	"clarus/internal/source"
	"clarus/internal/types"
)

// paramDesc is one parameter of an event's fixed signature: a name (for
// diagnostics only — Appendix B's own column names) and a required type.
type paramDesc struct {
	Name string
	Type *types.Type
}

// eventSpec is one event's required handler signature.
type eventSpec struct {
	Params []paramDesc
}

// events is Appendix B transcribed whole: every (context, event) pair in the
// reference's Event Handler Quick Reference table, both directions (no
// event in the table is missing here, and nothing here isn't in the table).
// "formWindow"/"accepted" is deliberately absent — its param type is the
// form's own record type, resolved per-window in checkWindowHandler rather
// than fixed here.
var events = map[string]map[string]eventSpec{
	"app": {
		"launch":       {},
		"startEmpty":   {},
		"openDocument": {Params: []paramDesc{{"path", types.StringT(255)}}},
		"startCLI":     {Params: []paramDesc{{"args", types.ListT(types.StringT(255))}}},
	},
	"window": {
		"opened":       {},
		"closeRequest": {},
		"closed":       {},
		"resized":      {},
		"key":          {Params: []paramDesc{{"k", types.CharT}}},
	},
	"formWindow": {
		"cancelled": {},
	},
	"button":   {"click": {}},
	"field":    {"change": {}, "enter": {}},
	"textview": {"change": {}},
	"check":    {"change": {}},
	"popup":    {"change": {}},
	"table": {
		"select":      {Params: []paramDesc{{"i", types.IntT}}},
		"doubleClick": {Params: []paramDesc{{"i", types.IntT}}},
	},
	"canvas": {
		"click": {Params: []paramDesc{{"x", types.IntT}, {"y", types.IntT}}},
		"drag":  {Params: []paramDesc{{"x", types.IntT}, {"y", types.IntT}}},
	},
	"menuItem": {"select": {}},
	"connection": {
		"opened":   {},
		"received": {Params: []paramDesc{{"data", types.TextT}}},
		"closed":   {},
		"failed":   {Params: []paramDesc{{"err", types.ErrT}}},
	},
	"listener": {
		"accepted": {Params: []paramDesc{{"c", connectionT}}},
		"failed":   {Params: []paramDesc{{"err", types.ErrT}}},
	},
	"serviceBrowser": {
		"found":  {Params: []paramDesc{{"name", types.StringT(255)}, {"addr", types.AddressT}}},
		"failed": {Params: []paramDesc{{"err", types.ErrT}}},
	},
}

// formatParams renders an eventSpec's params for a "takes (...)" diagnostic.
func formatParams(params []paramDesc) string {
	parts := make([]string, len(params))
	for i, p := range params {
		parts[i] = p.Name + ": " + typeName(p.Type)
	}
	return strings.Join(parts, ", ")
}

// checkTopHandlerDecl checks a top-level `on App.event` or `on
// resourceVar.event` handler (Ch7: Application Entry Points; Ch12:
// Connections/Listeners/Service Discovery) — the two shapes the grammar's
// top-level handlerDecl actually means, since only App and resource
// variables fire events outside a window/menu `extend`.
func (c *checker) checkTopHandlerDecl(d *ast.HandlerDecl) {
	if len(d.Path) != 2 {
		c.errorf(d.P, "unknown event")
		return
	}
	root, event := d.Path[0], d.Path[1]

	var ctx string
	if root == "App" {
		ctx = "app"
	} else {
		sym, ok := c.scope.Lookup(root)
		if !ok || sym.Type == nil {
			c.errorf(d.P, "undefined: %s", root)
			return
		}
		switch sym.Type.Kind {
		case types.Connection:
			ctx = "connection"
		case types.Listener:
			ctx = "listener"
		case types.ServiceBrowser:
			ctx = "serviceBrowser"
		default:
			c.errorf(d.P, "undefined: %s", root)
			return
		}
	}

	spec, ok := events[ctx][event]
	if !ok {
		c.errorf(d.P, "unknown event")
		return
	}
	c.checkHandlerBody(strings.Join(d.Path, "."), d.Params, spec, d.Body, nil, false, d.P)
}

// checkExtendDecl checks a top-level `extend` block (Ch8: Window Events,
// Widgets; Ch9: Item Events, Window-Scoped Commands) — Target names either a
// window type or a menu.
func (c *checker) checkExtendDecl(d *ast.ExtendDecl) {
	sym, ok := c.scope.Lookup(d.Target)
	if !ok {
		c.errorf(d.P, "undefined: %s", d.Target)
		return
	}
	switch {
	case sym.IsType && sym.Type.Kind == types.WindowRef:
		c.checkWindowExtend(sym.Type.Window, d)
	case sym.IsMenu:
		c.checkMenuExtend(sym.Menu, d, nil)
	default:
		c.errorf(d.P, "cannot extend %s", d.Target)
	}
}

// checkWindowExtend checks `extend W { ... }`'s handlers (bare window
// events, or Widget.event) and nested `extend Menu { ... }` blocks scoped to
// W (Ch9: Window-Scoped Commands).
func (c *checker) checkWindowExtend(w *types.WindowInfo, d *ast.ExtendDecl) {
	for _, h := range d.Handlers {
		c.checkWindowHandler(w, h)
	}
	for _, nested := range d.Nested {
		sym, ok := c.scope.Lookup(nested.Target)
		if !ok || !sym.IsMenu {
			c.errorf(nested.P, "undefined: %s", nested.Target)
			continue
		}
		c.checkMenuExtend(sym.Menu, nested, w)
	}
}

// checkWindowHandler checks one handler inside `extend W`: a bare window
// event (Ch8: Window Events), a bare form event when W is a form window
// (Ch10: Form Events — `accepted`'s param type is W's own record), or
// `Widget.event` dispatched by that widget's kind (Ch8's Events column).
func (c *checker) checkWindowHandler(w *types.WindowInfo, h *ast.HandlerDecl) {
	displayName := strings.Join(h.Path, ".")
	switch len(h.Path) {
	case 1:
		event := h.Path[0]
		if spec, ok := events["window"][event]; ok {
			c.checkHandlerBody(displayName, h.Params, spec, h.Body, w, event == "closeRequest", h.P)
			return
		}
		if w.IsForm {
			if event == "accepted" {
				spec := eventSpec{Params: []paramDesc{{"rec", &types.Type{Kind: types.Record, Record: w.FormRecord}}}}
				c.checkHandlerBody(displayName, h.Params, spec, h.Body, w, false, h.P)
				return
			}
			if spec, ok := events["formWindow"][event]; ok {
				c.checkHandlerBody(displayName, h.Params, spec, h.Body, w, false, h.P)
				return
			}
		}
		c.errorf(h.P, "unknown event")
	case 2:
		widgetName, event := h.Path[0], h.Path[1]
		var widget *types.WidgetInfo
		for i := range w.Widgets {
			if w.Widgets[i].Name == widgetName {
				widget = &w.Widgets[i]
				break
			}
		}
		if widget == nil {
			c.errorf(h.P, "undefined: %s", widgetName)
			return
		}
		spec, ok := events[widget.Kind][event]
		if !ok {
			c.errorf(h.P, "unknown event")
			return
		}
		c.checkHandlerBody(displayName, h.Params, spec, h.Body, w, false, h.P)
	default:
		c.errorf(h.P, "unknown event")
	}
}

// checkMenuExtend checks `extend MenuName { on Item.select { } }` (Ch9: Item
// Events), either at the top level (win == nil: app-level commands, always
// enabled) or nested inside `extend W` (win != nil: window-scoped commands,
// automatically dimmed outside a W — Ch9: Window-Scoped Commands).
func (c *checker) checkMenuExtend(m *MenuInfo, d *ast.ExtendDecl, win *types.WindowInfo) {
	for _, h := range d.Handlers {
		if len(h.Path) != 2 {
			c.errorf(h.P, "unknown event")
			continue
		}
		item, event := h.Path[0], h.Path[1]
		if !m.Items[item] {
			c.errorf(h.P, "undefined: %s", item)
			continue
		}
		spec, ok := events["menuItem"][event]
		if !ok {
			c.errorf(h.P, "unknown event")
			continue
		}
		c.checkHandlerBody(strings.Join(h.Path, "."), h.Params, spec, h.Body, win, false, h.P)
	}
	for _, nested := range d.Nested {
		c.errorf(nested.P, "cannot extend inside a menu extend")
	}
}

// checkHandlerBody checks one handler's declared params against spec
// (reporting a "handler NAME takes (...)" mismatch — counts or types), then
// checks its body in a scope holding those params and, for a window-scoped
// handler (win != nil), the instance's widgets/vars/title beneath them
// (Ch8: "bare names ... resolve first against the firing instance's
// properties, fields, and widgets, then against globals"). isCloseRequest
// gates `cancel` (Ch5) for the one handler it's valid in.
func (c *checker) checkHandlerBody(displayName string, declared []ast.Param, spec eventSpec, body *ast.Block, win *types.WindowInfo, isCloseRequest bool, pos source.Pos) {
	paramTypes := make([]*types.Type, len(declared))
	for i, p := range declared {
		paramTypes[i] = c.resolveType(p.Type)
	}

	mismatch := len(declared) != len(spec.Params)
	if !mismatch {
		for i, want := range spec.Params {
			if paramTypes[i] != types.InvalidT && !types.Equal(paramTypes[i], want.Type) {
				mismatch = true
				break
			}
		}
	}
	if mismatch {
		c.errorf(pos, "handler %s takes (%s)", displayName, formatParams(spec.Params))
	}

	base := c.scope
	if win != nil {
		base = c.windowScope(base, win)
	}
	fnScope := NewScope(base)
	for i, p := range declared {
		if err := fnScope.Declare(Symbol{Name: p.Name, Type: paramTypes[i]}); err != nil {
			c.errorf(p.P, "%s", err.Error())
		}
	}

	savedScope, savedRet, savedWin, savedCR := c.scope, c.curFuncRet, c.curWindow, c.inCloseRequest
	c.scope, c.curFuncRet, c.curWindow, c.inCloseRequest = fnScope, nil, win, isCloseRequest
	c.checkBlock(body)
	c.scope, c.curFuncRet, c.curWindow, c.inCloseRequest = savedScope, savedRet, savedWin, savedCR
}

// windowScope builds the scope a window-scoped handler's body sees beneath
// its own params: the instance's `title`, its per-instance vars, and its
// widgets (as widget pseudo-values) — Ch8: Widgets, Window Instances.
func (c *checker) windowScope(parent *Scope, w *types.WindowInfo) *Scope {
	s := NewScope(parent)
	_ = s.Declare(Symbol{Name: "title", Type: types.StringT(255)})
	for _, v := range w.Vars {
		_ = s.Declare(Symbol{Name: v.Name, Type: v.Type})
	}
	for _, wi := range w.Widgets {
		_ = s.Declare(Symbol{Name: wi.Name, Type: &types.Type{Kind: types.Widget, WidgetKind: wi.Kind}})
	}
	return s
}

// checkEveryDecl checks a top-level `every N ticks { }` timer block (Ch7:
// Timers).
func (c *checker) checkEveryDecl(d *ast.EveryDecl) {
	if d.Ticks < 1 {
		c.errorf(d.P, "tick count must be at least 1")
	}
	c.checkBlock(d.Body)
}
