package parser

import (
	"clarus/internal/ast"
	"clarus/internal/token"
)

// parseExpr is the entry point of the precedence-climbing chain (Appendix A):
// parseExpr(or) -> parseAnd(and) -> parseCmp(non-chaining cmpOp) ->
// parseAdd(+ - | ^) -> parseMul(* / mod << >> &) -> parseUnary(- not ~) ->
// parsePostfix(. [ (]) -> parsePrimary.
func (p *parser) parseExpr() ast.Expr {
	x := p.parseAnd()
	for p.tok.Kind == token.KwOr {
		pos := p.tok.Pos
		p.next()
		y := p.parseAnd()
		x = &ast.Binary{P: pos, Op: "or", X: x, Y: y}
	}
	return x
}

func (p *parser) parseAnd() ast.Expr {
	x := p.parseCmp()
	for p.tok.Kind == token.KwAnd {
		pos := p.tok.Pos
		p.next()
		y := p.parseCmp()
		x = &ast.Binary{P: pos, Op: "and", X: x, Y: y}
	}
	return x
}

// cmpOps maps comparison token kinds to their AST operator string.
var cmpOps = map[token.Kind]string{
	token.EQ: "==", token.NE: "!=",
	token.LT: "<", token.LE: "<=",
	token.GT: ">", token.GE: ">=",
}

// parseCmp parses at most one comparison — comparisons do not chain.
func (p *parser) parseCmp() ast.Expr {
	x := p.parseAdd()
	op, ok := cmpOps[p.tok.Kind]
	if !ok {
		return x
	}
	pos := p.tok.Pos
	p.next()
	y := p.parseAdd()
	x = &ast.Binary{P: pos, Op: op, X: x, Y: y}
	if _, ok := cmpOps[p.tok.Kind]; ok {
		p.errorf(p.tok.Pos, "comparisons do not chain")
	}
	return x
}

// addOps maps additive-level token kinds to their AST operator string.
var addOps = map[token.Kind]string{
	token.PLUS: "+", token.MINUS: "-",
	token.PIPE: "|", token.CARET: "^",
}

func (p *parser) parseAdd() ast.Expr {
	x := p.parseMul()
	for {
		op, ok := addOps[p.tok.Kind]
		if !ok {
			return x
		}
		pos := p.tok.Pos
		p.next()
		y := p.parseMul()
		x = &ast.Binary{P: pos, Op: op, X: x, Y: y}
	}
}

// mulOps maps multiplicative-level token kinds to their AST operator string.
// "mod" is not a token kind of its own — it is an IDENT recognized by text
// when it appears in infix (operator) position; see parseMul.
var mulOps = map[token.Kind]string{
	token.STAR: "*", token.SLASH: "/",
	token.SHL: "<<", token.SHR: ">>", token.AMP: "&",
}

func (p *parser) parseMul() ast.Expr {
	x := p.parseUnary()
	for {
		if p.tok.Kind == token.IDENT && p.tok.Text == "mod" {
			pos := p.tok.Pos
			p.next()
			y := p.parseUnary()
			x = &ast.Binary{P: pos, Op: "mod", X: x, Y: y}
			continue
		}
		op, ok := mulOps[p.tok.Kind]
		if !ok {
			return x
		}
		pos := p.tok.Pos
		p.next()
		y := p.parseUnary()
		x = &ast.Binary{P: pos, Op: op, X: x, Y: y}
	}
}

// unaryOps maps unary-operator token kinds to their AST operator string.
var unaryOps = map[token.Kind]string{
	token.MINUS: "-", token.KwNot: "not", token.TILDE: "~",
}

func (p *parser) parseUnary() ast.Expr {
	if op, ok := unaryOps[p.tok.Kind]; ok {
		pos := p.tok.Pos
		p.next()
		return &ast.Unary{P: pos, Op: op, X: p.parseUnary()}
	}
	return p.parsePostfix()
}

// parsePostfix parses a primary followed by any run of `.memberName`,
// `[expr]`, or `(args)` postfix operators.
func (p *parser) parsePostfix() ast.Expr {
	x := p.parsePrimary()
	for {
		switch p.tok.Kind {
		case token.DOT:
			pos := p.tok.Pos
			p.next()
			name := p.parseMemberName()
			x = &ast.Select{P: pos, X: x, Name: name}
		case token.LBRACKET:
			pos := p.tok.Pos
			p.next()
			idx := p.parseExpr()
			if p.tok.Kind == token.COMMA {
				p.next()
				length := p.parseExpr()
				p.expect(token.RBRACKET)
				x = &ast.SliceExpr{P: pos, X: x, Start: idx, Len: length}
			} else {
				p.expect(token.RBRACKET)
				x = &ast.Index{P: pos, X: x, I: idx}
			}
		case token.LPAREN:
			pos := p.tok.Pos
			p.next()
			args, appleTalk := p.parseArgs()
			x = &ast.Call{P: pos, Fn: x, Args: args, AppleTalk: appleTalk}
		default:
			return x
		}
	}
}

// parseMemberName parses the identifier after `.`: an IDENT, or one of the
// hard keywords `open`/`close`, which are permitted as member names
// (Appendix A: `memberName = IDENT | "open" | "close"`).
func (p *parser) parseMemberName() string {
	switch p.tok.Kind {
	case token.IDENT:
		name := p.tok.Text
		p.next()
		return name
	case token.KwOpen:
		p.next()
		return "open"
	case token.KwClose:
		p.next()
		return "close"
	default:
		p.errorf(p.tok.Pos, "expected member name, found %s", p.tok.Kind)
		panic(parseAbort{}) // unreachable: errorf already panics
	}
}

// isPrimaryStart reports whether k can begin a primary expression
// (Appendix A: literals, `window`, an identifier, `new`, or `open`). Two
// primary-starts never appear back to back in valid expression syntax
// otherwise, which is what makes the `appletalk` prefix unambiguous: see
// parseArgs.
func isPrimaryStart(k token.Kind) bool {
	switch k {
	case token.IDENT, token.INT, token.FIXEDLIT, token.CHARLIT, token.STRINGLIT,
		token.KwTrue, token.KwFalse, token.KwNil, token.KwWindow, token.KwNew, token.KwOpen:
		return true
	default:
		return false
	}
}

// parseArgs parses `[args]` up to and including the closing `)` (the `(`
// has already been consumed by the caller). It recognizes the contextual
// `appletalk` prefix before a call's first argument, reporting whether it
// was present.
//
// `appletalk` is the prefix only when the token that follows it can start a
// primary expression — e.g. `appletalk "Mac:Srv"` or `appletalk name`.
// Otherwise (`,` `)` an operator `(` `[` `.` etc.) it is an ordinary
// identifier and is left for parseExpr to parse normally: `appletalk` alone,
// `appletalk + 1`, and `appletalk(x)` (a call to a function named
// appletalk) all fall in this branch.
func (p *parser) parseArgs() ([]ast.Expr, bool) {
	if p.tok.Kind == token.RPAREN {
		p.next()
		return nil, false
	}

	appleTalk := false
	if p.tok.Kind == token.IDENT && p.tok.Text == "appletalk" && isPrimaryStart(p.peek().Kind) {
		p.next()
		appleTalk = true
	}

	var args []ast.Expr
	args = append(args, p.parseExpr())
	for p.tok.Kind == token.COMMA {
		p.next()
		args = append(args, p.parseExpr())
	}
	p.expect(token.RPAREN)
	return args, appleTalk
}

// parsePrimary parses a primary expression: literals, `window`, an
// identifier, `new IDENT`, `open IDENT`, or a parenthesized expression.
func (p *parser) parsePrimary() ast.Expr {
	tok := p.tok
	switch tok.Kind {
	case token.INT:
		p.next()
		return &ast.IntLit{P: tok.Pos, Val: tok.IntVal}
	case token.FIXEDLIT:
		p.next()
		return &ast.FixedLit{P: tok.Pos, Raw: tok.FixVal}
	case token.CHARLIT:
		p.next()
		return &ast.CharLit{P: tok.Pos, Val: byte(tok.IntVal)}
	case token.STRINGLIT:
		p.next()
		return &ast.StringLit{P: tok.Pos, Val: tok.Text}
	case token.KwTrue:
		p.next()
		return &ast.BoolLit{P: tok.Pos, Val: true}
	case token.KwFalse:
		p.next()
		return &ast.BoolLit{P: tok.Pos, Val: false}
	case token.KwNil:
		p.next()
		return &ast.NilLit{P: tok.Pos}
	case token.KwWindow:
		p.next()
		return &ast.WindowSelf{P: tok.Pos}
	case token.IDENT:
		p.next()
		return &ast.Ident{P: tok.Pos, Name: tok.Text}
	case token.KwNew:
		p.next()
		name := p.expect(token.IDENT)
		return &ast.NewExpr{P: tok.Pos, Type: name.Text}
	case token.KwOpen:
		p.next()
		name := p.expect(token.IDENT)
		return &ast.OpenExpr{P: tok.Pos, Window: name.Text}
	case token.LPAREN:
		p.next()
		x := p.parseExpr()
		p.expect(token.RPAREN)
		return x
	default:
		p.errorf(tok.Pos, "expected expression, found %s", tok.Kind)
		panic(parseAbort{}) // unreachable: errorf already panics
	}
}
