// Statement forms added by Task 11: cancel, open, close, and edit (Ch5).
package check

import (
	"clarus/internal/ast"
	"clarus/internal/types"
)

// checkCancelStmt checks `cancel` (Ch5: Cancel) — valid only inside a
// closeRequest handler's body.
func (c *checker) checkCancelStmt(s *ast.CancelStmt) {
	if !c.inCloseRequest {
		c.errorf(s.P, "cancel is only valid inside a closeRequest handler")
	}
}

// checkOpenStmt checks the statement form `open WindowType` (Ch5: Open) —
// WindowType must name a window.
func (c *checker) checkOpenStmt(s *ast.OpenStmt) {
	sym, ok := c.scope.Lookup(s.Window)
	if !ok {
		c.errorf(s.P, "undefined: %s", s.Window)
		return
	}
	if !sym.IsType || sym.Type.Kind != types.WindowRef {
		c.errorf(s.P, "cannot open non-window type %s", s.Window)
	}
}

// checkCloseStmt checks `close windowRef` (Ch5: Close) — the operand must be
// a window reference.
func (c *checker) checkCloseStmt(s *ast.CloseStmt) {
	t := c.checkExpr(s.X, nil)
	if t != types.InvalidT && t.Kind != types.WindowRef {
		c.errorf(s.P, "cannot close %s", typeName(t))
	}
}

// checkEditStmt checks `edit FormWindow, target` (Ch5: Edit; Ch10: The Edit
// Statement) — FormWindow must be a form window, and target (an lvalue, or
// `new T`) must agree with its `form for` record type.
func (c *checker) checkEditStmt(s *ast.EditStmt) {
	sym, ok := c.scope.Lookup(s.Form)
	if !ok {
		c.errorf(s.P, "undefined: %s", s.Form)
		return
	}
	if !sym.IsType || sym.Type.Kind != types.WindowRef {
		c.errorf(s.P, "%s is not a window", s.Form)
		return
	}
	w := sym.Type.Window
	if !w.IsForm {
		c.errorf(s.P, "%s is not a form window", s.Form)
		return
	}
	formType := &types.Type{Kind: types.Record, Record: w.FormRecord}

	if s.IsNew {
		tsym, ok := c.scope.Lookup(s.NewType)
		if !ok || !tsym.IsType || tsym.Type.Kind != types.Record {
			c.errorf(s.P, "undefined: %s", s.NewType)
			return
		}
		if tsym.Type.Record != w.FormRecord {
			c.errorf(s.P, "cannot use %s where %s is expected", s.NewType, w.FormRecord.Name)
		}
		return
	}

	tt := c.checkExpr(s.Target, formType)
	if tt != types.InvalidT && !(tt.Kind == types.Record && tt.Record == w.FormRecord) {
		c.errorf(s.Target.Pos(), "cannot use %s where %s is expected", typeName(tt), w.FormRecord.Name)
	}
}
