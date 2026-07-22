// Package parser builds an *ast.File from Clarus source via recursive descent.
package parser

import (
	"fmt"

	"clarus/internal/ast"
	"clarus/internal/lexer"
	"clarus/internal/source"
	"clarus/internal/token"
)

// parseAbort is panicked after the first syntax error is recorded, and
// recovered at the top of Parse — parsing is fail-fast, single-pass honest.
type parseAbort struct{}

type parser struct {
	f             *source.File
	lex           *lexer.Lexer
	tok           token.Token
	peekTok       token.Token
	hasPeek       bool
	diags         []source.Diag
	sawNonInclude bool // set once a non-include top decl has been parsed
}

// Parse lexes and parses f into an *ast.File. Any lexer diagnostics are
// included in the returned diags; a syntax error stops parsing after
// recording exactly one additional diagnostic.
func Parse(f *source.File) (file *ast.File, diags []source.Diag) {
	p := &parser{f: f, lex: lexer.New(f)}
	p.next()

	defer func() {
		if r := recover(); r != nil {
			if _, ok := r.(parseAbort); !ok {
				panic(r)
			}
		}
		diags = append(p.lex.Diags(), p.diags...)
	}()

	file = &ast.File{}
	p.skipNewlines()
	for p.tok.Kind != token.EOF {
		file.Decls = append(file.Decls, p.parseTopDecl())
		p.skipNewlines()
	}
	return file, nil
}

// next advances p.tok to the next token from the lexer.
func (p *parser) next() {
	if p.hasPeek {
		p.tok = p.peekTok
		p.hasPeek = false
		return
	}
	p.tok = p.lex.Next()
}

// peek returns the token following p.tok without consuming it, caching it
// so the next call to next() returns it in turn.
func (p *parser) peek() token.Token {
	if !p.hasPeek {
		p.peekTok = p.lex.Next()
		p.hasPeek = true
	}
	return p.peekTok
}

// errorf records a single diagnostic at pos and aborts parsing via panic,
// recovered at the top of Parse.
func (p *parser) errorf(pos source.Pos, format string, args ...interface{}) {
	p.diags = append(p.diags, source.Diag{File: p.f, Pos: pos, Msg: fmt.Sprintf(format, args...)})
	panic(parseAbort{})
}

// expect consumes the current token if it has kind k, else records a syntax
// error and aborts. Returns the consumed token.
func (p *parser) expect(k token.Kind) token.Token {
	if p.tok.Kind != k {
		p.errorf(p.tok.Pos, "expected %s, found %s", k, p.tok.Kind)
	}
	t := p.tok
	p.next()
	return t
}

// skipNewlines consumes any run of NEWLINE tokens (used between top-level
// declarations, where blank lines are insignificant).
func (p *parser) skipNewlines() {
	for p.tok.Kind == token.NEWLINE {
		p.next()
	}
}

// parseTopDecl parses one top-level declaration (Appendix A: topDecl).
func (p *parser) parseTopDecl() ast.Decl {
	if p.tok.Kind == token.IDENT && p.tok.Text == "include" && p.peek().Kind == token.STRINGLIT {
		if p.sawNonInclude {
			p.errorf(p.tok.Pos, "include must precede other declarations")
		}
		return p.parseIncludeDecl()
	}
	p.sawNonInclude = true
	switch p.tok.Kind {
	case token.KwVar:
		return p.parseVarDecl()
	case token.KwFunc:
		return p.parseFuncDecl()
	case token.KwRecord:
		return p.parseRecordDecl()
	case token.KwEnum:
		return p.parseEnumDecl()
	case token.KwConst:
		return p.parseConstDecl()
	case token.KwWindow:
		return p.parseWindowDecl()
	case token.KwMenu:
		return p.parseMenuDecl()
	case token.KwExtend:
		return p.parseExtendDecl()
	case token.KwOn:
		return p.parseHandlerDecl()
	case token.KwEvery:
		return p.parseEveryDecl()
	default:
		p.errorf(p.tok.Pos, "expected declaration, found %s", p.tok.Kind)
		panic(parseAbort{}) // unreachable: errorf already panics
	}
}

// parseIncludeDecl parses `"include" STRING` (contextual: "include" is an
// IDENT recognized by text at top-level statement start, mirroring "mod"/
// "of"/"ticks"). Must be the leading top-level declaration in the file;
// parseTopDecl enforces that before calling this.
func (p *parser) parseIncludeDecl() *ast.Include {
	pos := p.tok.Pos
	p.next() // 'include'
	path := p.expect(token.STRINGLIT)
	return &ast.Include{P: pos, Path: path.Text}
}

// parseFuncDecl parses `"func" IDENT "(" [ params ] ")" [ ":" type ] block`.
func (p *parser) parseFuncDecl() *ast.FuncDecl {
	pos := p.tok.Pos
	p.next() // 'func'
	name := p.expect(token.IDENT)
	p.expect(token.LPAREN)
	var params []ast.Param
	if p.tok.Kind != token.RPAREN {
		params = append(params, p.parseParam())
		for p.tok.Kind == token.COMMA {
			p.next()
			params = append(params, p.parseParam())
		}
	}
	p.expect(token.RPAREN)
	var ret ast.TypeExpr
	if p.tok.Kind == token.COLON {
		p.next()
		ret = p.parseType()
	}
	body := p.parseBodyBlock()
	return &ast.FuncDecl{P: pos, Name: name.Text, Params: params, Ret: ret, Body: body}
}

// parseParam parses `IDENT ":" type`.
func (p *parser) parseParam() ast.Param {
	pos := p.tok.Pos
	name := p.expect(token.IDENT)
	p.expect(token.COLON)
	typ := p.parseType()
	return ast.Param{P: pos, Name: name.Text, Type: typ}
}

// parseVarDecl parses `var IDENT ":" type [ "=" expr ]`.
func (p *parser) parseVarDecl() *ast.VarDecl {
	pos := p.tok.Pos
	p.next() // consume 'var'
	name := p.expect(token.IDENT)
	p.expect(token.COLON)
	typ := p.parseType()
	d := &ast.VarDecl{P: pos, Name: name.Text, Type: typ}
	if p.tok.Kind == token.ASSIGN {
		p.next()
		d.Init = p.parseExpr()
	}
	return d
}

// parseType parses a type as written in source (Appendix A: type). The
// built-in names int/bool/fixed/char/text and any user record/enum/window
// name all lex as a plain IDENT and become a NamedType; `string`, `list of`,
// and `map of` are contextual on that IDENT's text (like `mod` in
// expressions). Any type may be followed by one or more `[N]` suffixes,
// each wrapping the type built so far in an ArrayType.
func (p *parser) parseType() ast.TypeExpr {
	pos := p.tok.Pos
	name := p.expect(token.IDENT)
	var t ast.TypeExpr
	switch {
	case name.Text == "string" && p.tok.Kind == token.LPAREN:
		p.next()
		n := p.expect(token.INT)
		p.expect(token.RPAREN)
		t = &ast.StringType{P: pos, N: int(n.IntVal)}
	case name.Text == "string":
		t = &ast.StringType{P: pos, N: 255}
	case name.Text == "list":
		p.expectIdentText("of")
		t = &ast.ListType{P: pos, Elem: p.parseType()}
	case name.Text == "map":
		p.expectIdentText("of")
		t = &ast.MapType{P: pos, Val: p.parseType()}
	default:
		t = &ast.NamedType{P: pos, Name: name.Text}
	}
	for p.tok.Kind == token.LBRACKET {
		bpos := p.tok.Pos
		p.next()
		n := p.expect(token.INT)
		p.expect(token.RBRACKET)
		t = &ast.ArrayType{P: bpos, Elem: t, N: int(n.IntVal)}
	}
	return t
}

// expectIdentText consumes the current token if it is an IDENT with the
// given text (used for the contextual keyword `of` in `list of`/`map of`),
// else records a syntax error and aborts.
func (p *parser) expectIdentText(text string) {
	if p.tok.Kind != token.IDENT || p.tok.Text != text {
		p.errorf(p.tok.Pos, "expected %q, found %s", text, p.tok.Kind)
	}
	p.next()
}
