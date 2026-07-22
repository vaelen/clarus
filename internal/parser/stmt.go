package parser

import (
	"clarus/internal/ast"
	"clarus/internal/token"
)

// parseBlock parses `"{" { stmt } "}"` (Appendix A) for a nested block
// (if/else/while/for body), where var declarations are not permitted: the
// reference restricts `var` to the top of a function or handler body, not
// every block. See parseBodyBlock for that outermost form.
func (p *parser) parseBlock() *ast.Block {
	return p.parseBlockVars(false)
}

// parseBodyBlock parses the outermost body of a func, handler (`on`), or
// `every` declaration, where var declarations are allowed at the top
// (Ch5 of the reference; an `every` block is a handler body, so its vars
// are legitimate too — Ch7).
func (p *parser) parseBodyBlock() *ast.Block {
	return p.parseBlockVars(true)
}

// parseBlockVars parses `"{" { stmt } "}"`, where stmt also includes
// varDecl when allowVars is true. All var declarations must appear before
// any other statement; a var seen afterward is a diagnostic, not a silent
// reorder. When allowVars is false, any var declaration is a diagnostic
// regardless of position.
func (p *parser) parseBlockVars(allowVars bool) *ast.Block {
	lb := p.expect(token.LBRACE)
	b := &ast.Block{P: lb.Pos}
	p.skipNewlines()
	seenStmt := false
	for p.tok.Kind != token.RBRACE {
		if p.tok.Kind == token.KwVar {
			if !allowVars {
				p.errorf(p.tok.Pos, "variable declarations are only allowed at the top of a function or handler body")
			} else if seenStmt {
				p.errorf(p.tok.Pos, "variable declarations must appear at the top of the body")
			}
			b.Vars = append(b.Vars, p.parseVarDecl())
		} else {
			b.Stmts = append(b.Stmts, p.parseStmt())
			seenStmt = true
		}
		p.skipNewlines()
	}
	p.next() // consume '}'
	return b
}

// parseStmt parses one statement (Appendix A: stmt), dispatching on the
// leading token. Expression-leading statements (assignment and call) fall
// through to parseSimpleStmt.
func (p *parser) parseStmt() ast.Stmt {
	switch p.tok.Kind {
	case token.KwIf:
		return p.parseIfStmt()
	case token.KwWhile:
		return p.parseWhileStmt()
	case token.KwFor:
		return p.parseForStmt()
	case token.KwReturn:
		return p.parseReturnStmt()
	case token.KwQuit:
		return p.parseQuitStmt()
	case token.KwCancel:
		pos := p.tok.Pos
		p.next()
		return &ast.CancelStmt{P: pos}
	case token.KwBreak:
		pos := p.tok.Pos
		p.next()
		return &ast.BreakStmt{P: pos}
	case token.KwContinue:
		pos := p.tok.Pos
		p.next()
		return &ast.ContinueStmt{P: pos}
	case token.KwSwitch:
		return p.parseSwitchStmt()
	case token.KwOpen:
		return p.parseOpenStmt()
	case token.KwClose:
		return p.parseCloseStmt()
	case token.KwEdit:
		return p.parseEditStmt()
	default:
		return p.parseSimpleStmt()
	}
}

// parseSimpleStmt parses an expression-leading statement: `lvalue = expr`
// (assignment) or a bare call. Anything else is neither, and is rejected.
func (p *parser) parseSimpleStmt() ast.Stmt {
	pos := p.tok.Pos
	x := p.parseExpr()
	if p.tok.Kind == token.ASSIGN {
		if _, ok := x.(*ast.SliceExpr); ok {
			p.errorf(pos, "slices are not assignable")
		}
		if !isLvalue(x) {
			p.errorf(pos, "cannot assign to this expression")
		}
		p.next()
		rhs := p.parseExpr()
		return &ast.AssignStmt{P: pos, LHS: x, RHS: rhs}
	}
	if call, ok := x.(*ast.Call); ok {
		return &ast.ExprStmt{P: pos, X: call}
	}
	p.errorf(pos, "expression is not a statement")
	panic(parseAbort{}) // unreachable: errorf already panics
}

// isLvalue reports whether e has the shape `IDENT { "." memberName | "[" expr "]" }`
// (Appendix A: lvalue) — an Ident base with any chain of Select/Index on top.
func isLvalue(e ast.Expr) bool {
	switch v := e.(type) {
	case *ast.Ident:
		return true
	case *ast.Select:
		return isLvalue(v.X)
	case *ast.Index:
		return isLvalue(v.X)
	default:
		return false
	}
}

// parseIfStmt parses `"if" expr block [ "else" ( ifStmt | block ) ]`.
func (p *parser) parseIfStmt() *ast.IfStmt {
	pos := p.tok.Pos
	p.next() // 'if'
	cond := p.parseExpr()
	then := p.parseBlock()
	s := &ast.IfStmt{P: pos, Cond: cond, Then: then}
	if p.tok.Kind == token.KwElse {
		p.next()
		if p.tok.Kind == token.KwIf {
			s.Else = p.parseIfStmt()
		} else {
			s.Else = p.parseBlock()
		}
	}
	return s
}

// parseWhileStmt parses `"while" expr block`.
func (p *parser) parseWhileStmt() *ast.WhileStmt {
	pos := p.tok.Pos
	p.next() // 'while'
	cond := p.parseExpr()
	body := p.parseBlock()
	return &ast.WhileStmt{P: pos, Cond: cond, Body: body}
}

// parseForStmt parses `"for" IDENT [ "," IDENT ] "in" forRange block`, where
// forRange = expr [ "to" expr ]. All three forms (list, map, range) share
// this one grammar; which is valid is a checker concern, not the parser's.
func (p *parser) parseForStmt() *ast.ForStmt {
	pos := p.tok.Pos
	p.next() // 'for'
	v1 := p.expect(token.IDENT)
	f := &ast.ForStmt{P: pos, V1: v1.Text}
	if p.tok.Kind == token.COMMA {
		p.next()
		v2 := p.expect(token.IDENT)
		f.V2 = v2.Text
	}
	p.expect(token.KwIn)
	f.Seq = p.parseExpr()
	if p.tok.Kind == token.KwTo {
		p.next()
		f.ToExpr = p.parseExpr()
	}
	f.Body = p.parseBlock()
	return f
}

// parseReturnStmt parses `"return" [ expr ]`. A return with no value is
// followed directly by the statement-ending NEWLINE or the block's `}`.
func (p *parser) parseReturnStmt() *ast.ReturnStmt {
	pos := p.tok.Pos
	p.next() // 'return'
	r := &ast.ReturnStmt{P: pos}
	if p.tok.Kind != token.NEWLINE && p.tok.Kind != token.RBRACE {
		r.X = p.parseExpr()
	}
	return r
}

// parseQuitStmt parses `"quit" [ expr ]` (Appendix A; Ch5: Quit). The
// expression is present only when it starts on the same line as `quit` — a
// NEWLINE or the block's closing `}` ends the statement with no code, same
// as parseReturnStmt.
func (p *parser) parseQuitStmt() *ast.QuitStmt {
	pos := p.tok.Pos
	p.next() // 'quit'
	q := &ast.QuitStmt{P: pos}
	if p.tok.Kind != token.NEWLINE && p.tok.Kind != token.RBRACE {
		q.Code = p.parseExpr()
	}
	return q
}

// parseSwitchStmt parses `"switch" expr "{" { caseClause } [ "else" block ] "}"`
// (Appendix A; Ch5: Switch). Case bodies are nested blocks (parseBlock: no
// top-of-body vars, since a case body is not a function or handler body). A
// `case` clause after `else` is not a distinct diagnostic: `else` must be
// last, so the trailing `p.expect(token.RBRACE)` reports "expected '}', found
// 'case'" on its own.
func (p *parser) parseSwitchStmt() *ast.SwitchStmt {
	pos := p.tok.Pos
	p.next() // 'switch'
	subject := p.parseExpr()
	p.expect(token.LBRACE)
	s := &ast.SwitchStmt{P: pos, Subject: subject}
	p.skipNewlines()
	for p.tok.Kind == token.KwCase {
		s.Cases = append(s.Cases, p.parseSwitchCase())
		p.skipNewlines()
	}
	if p.tok.Kind == token.KwElse {
		p.next()
		s.Else = p.parseBlock()
		p.skipNewlines()
	}
	p.expect(token.RBRACE)
	return s
}

// parseSwitchCase parses `"case" caseLabel { "," caseLabel } block`, where
// caseLabel = literal | IDENT (an enum member or declared constant).
func (p *parser) parseSwitchCase() ast.SwitchCase {
	pos := p.tok.Pos
	p.next() // 'case'
	c := ast.SwitchCase{P: pos}
	c.Labels = append(c.Labels, p.parseLiteralOrIdent())
	for p.tok.Kind == token.COMMA {
		p.next()
		c.Labels = append(c.Labels, p.parseLiteralOrIdent())
	}
	c.Body = p.parseBlock()
	return c
}

// parseOpenStmt parses the statement form `"open" IDENT` (distinct from the
// `open IDENT` primary expression, which keeps the opened window's reference).
func (p *parser) parseOpenStmt() *ast.OpenStmt {
	pos := p.tok.Pos
	p.next() // 'open'
	name := p.expect(token.IDENT)
	return &ast.OpenStmt{P: pos, Window: name.Text}
}

// parseCloseStmt parses `"close" expr`.
func (p *parser) parseCloseStmt() *ast.CloseStmt {
	pos := p.tok.Pos
	p.next() // 'close'
	x := p.parseExpr()
	return &ast.CloseStmt{P: pos, X: x}
}

// parseEditStmt parses `"edit" IDENT "," ( lvalue | "new" IDENT )`.
func (p *parser) parseEditStmt() *ast.EditStmt {
	pos := p.tok.Pos
	p.next() // 'edit'
	form := p.expect(token.IDENT)
	p.expect(token.COMMA)
	e := &ast.EditStmt{P: pos, Form: form.Text}
	if p.tok.Kind == token.KwNew {
		p.next()
		typ := p.expect(token.IDENT)
		e.IsNew = true
		e.NewType = typ.Text
	} else {
		e.Target = p.parseExpr()
	}
	return e
}
