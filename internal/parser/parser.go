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
	f       *source.File
	lex     *lexer.Lexer
	tok     token.Token
	peekTok token.Token
	hasPeek bool
	diags   []source.Diag
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

// parseTopDecl parses one top-level declaration. For this task, only `var`
// is wired up; the remaining top-level forms (record, func, window, menu,
// extend, on, every) are wired in later tasks.
func (p *parser) parseTopDecl() ast.Decl {
	switch p.tok.Kind {
	case token.KwVar:
		return p.parseVarDecl()
	default:
		p.errorf(p.tok.Pos, "expected declaration, found %s", p.tok.Kind)
		panic(parseAbort{}) // unreachable: errorf already panics
	}
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

// parseType parses a type as written in source. Full type parsing (list of,
// map of, array suffix, user records/enums) arrives in Task 7; this handles
// only what the Task 5 test harness needs: a bare IDENT (including the
// built-in names int/bool/fixed/char/text, which lex as identifiers) and the
// `string` / `string(N)` forms.
func (p *parser) parseType() ast.TypeExpr {
	pos := p.tok.Pos
	name := p.expect(token.IDENT)
	if name.Text == "string" && p.tok.Kind == token.LPAREN {
		p.next()
		n := p.expect(token.INT)
		p.expect(token.RPAREN)
		return &ast.StringType{P: pos, N: int(n.IntVal)}
	}
	if name.Text == "string" {
		return &ast.StringType{P: pos, N: 255}
	}
	return &ast.NamedType{P: pos, Name: name.Text}
}
