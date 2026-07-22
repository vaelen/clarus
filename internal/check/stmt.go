// Statement forms added by Task 11 (cancel, open, close, edit) and by the
// CLI/self-hosting features plan (quit code, break, continue, switch — Ch5).
package check

import (
	"fmt"

	"clarus/internal/ast"
	"clarus/internal/types"
)

// checkQuitStmt checks `quit [code]` (Ch5: Quit) — the optional exit code
// must be int; bare `quit` needs no checking.
func (c *checker) checkQuitStmt(s *ast.QuitStmt) {
	if s.Code == nil {
		return
	}
	t := c.checkExpr(s.Code, types.IntT)
	if t != types.InvalidT && t.Kind != types.Int {
		c.errorf(s.Code.Pos(), "quit code must be int")
	}
}

// checkBreakStmt and checkContinueStmt check `break`/`continue` (Ch5: Break
// and Continue) — valid only inside a loop body (c.loopDepth, incremented
// only by checkLoopBody; a switch case body does not increment it, so a
// break there still binds the enclosing loop, if any — see checkSwitchStmt).
func (c *checker) checkBreakStmt(s *ast.BreakStmt) {
	if c.loopDepth == 0 {
		c.errorf(s.P, "break is only valid inside a loop")
	}
}

func (c *checker) checkContinueStmt(s *ast.ContinueStmt) {
	if c.loopDepth == 0 {
		c.errorf(s.P, "continue is only valid inside a loop")
	}
}

// checkSwitchStmt checks `switch subject { case ... } [else]` (Ch5: Switch).
// The subject's type must be int, char, enum, or string (text is explicitly
// excluded — Ch3 lists only string among the text-like types); each case
// label is checked against that type, must resolve to a constant value
// (literal, enum member, or `const`), and duplicate values (after
// const/enum-member resolution) are rejected. Case bodies are ordinary
// nested blocks — checkBlock, not checkLoopBody, so switch itself never
// changes loopDepth.
func (c *checker) checkSwitchStmt(s *ast.SwitchStmt) {
	subjT := c.checkExpr(s.Subject, nil)
	validSubject := subjT != types.InvalidT
	if validSubject {
		switch subjT.Kind {
		case types.Int, types.Char, types.Enum, types.String:
		default:
			c.errorf(s.Subject.Pos(), "switch operand must be int, char, enum, or string")
			validSubject = false
		}
	}

	seen := make(map[string]bool)
	for _, cs := range s.Cases {
		for _, lbl := range cs.Labels {
			var expected *types.Type
			if validSubject {
				expected = subjT
			}
			lt := c.checkCaseLabel(lbl, expected)
			if lt == types.InvalidT {
				continue
			}
			if validSubject && !compatible(lt, subjT) {
				c.errorf(lbl.Pos(), "cannot use %s where %s is expected", typeName(lt), typeName(subjT))
				continue
			}
			if key, ok := c.caseLabelKey(lbl); ok {
				if seen[key] {
					c.errorf(lbl.Pos(), "duplicate case label")
				}
				seen[key] = true
			}
		}
		c.checkBlock(cs.Body)
	}
	if s.Else != nil {
		c.checkBlock(s.Else)
	}
}

// checkCaseLabel checks one switch case label against the subject's type (or
// nil, when the subject itself already errored). A label is always one of
// literal/Ident (the parser's parseLiteralOrIdent, same restriction as a
// const initializer — see checkConstDecl); checkExpr already handles literal
// typing and the bare-enum-member fallback via checkIdent, so the only rule
// left here is: an Ident that resolves to a plain (non-const) symbol is not
// a constant.
func (c *checker) checkCaseLabel(lbl ast.Expr, expected *types.Type) *types.Type {
	lt := c.checkExpr(lbl, expected)
	if lt == types.InvalidT {
		return lt
	}
	if id, ok := lbl.(*ast.Ident); ok {
		if sym, found := c.scope.Lookup(id.Name); found && !sym.IsConst {
			c.errorf(id.P, "case label must be a constant")
			return types.InvalidT
		}
	}
	return lt
}

// caseLabelKey renders a checked case label's resolved value as a
// duplicate-detection key: literals read straight off the AST node; a bare
// enum member or const Ident reads its resolved value from c.info
// (EnumConsts/Consts — populated by checkExpr/checkIdent above). Returns
// false for anything else (already diagnosed, so never reached for a clean
// program).
func (c *checker) caseLabelKey(lbl ast.Expr) (string, bool) {
	switch v := lbl.(type) {
	case *ast.IntLit:
		return fmt.Sprintf("i%d", v.Val), true
	case *ast.CharLit:
		return fmt.Sprintf("i%d", v.Val), true
	case *ast.StringLit:
		return "s" + v.Val, true
	case *ast.Ident:
		if cv, ok := c.info.Consts[v]; ok {
			if cv.IsStr {
				return "s" + cv.Str, true
			}
			return fmt.Sprintf("i%d", cv.Int), true
		}
		if val, ok := c.info.EnumConsts[v]; ok {
			return fmt.Sprintf("i%d", val), true
		}
	}
	return "", false
}

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
