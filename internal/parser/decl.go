package parser

import (
	"clarus/internal/ast"
	"clarus/internal/token"
)

// parseRecordDecl parses `"record" IDENT "{" { fieldDecl } "}"` (Appendix A),
// where fields are newline-separated (Ch3: Records and Defaults).
func (p *parser) parseRecordDecl() *ast.RecordDecl {
	pos := p.tok.Pos
	p.next() // 'record'
	name := p.expect(token.IDENT)
	p.expect(token.LBRACE)
	r := &ast.RecordDecl{P: pos, Name: name.Text}
	p.skipNewlines()
	for p.tok.Kind != token.RBRACE {
		r.Fields = append(r.Fields, p.parseFieldDecl())
		p.skipNewlines()
	}
	p.next() // consume '}'
	return r
}

// parseFieldDecl parses `IDENT ":" type [ "=" ( literal | IDENT ) ]`.
func (p *parser) parseFieldDecl() ast.Field {
	pos := p.tok.Pos
	name := p.expect(token.IDENT)
	p.expect(token.COLON)
	typ := p.parseType()
	f := ast.Field{P: pos, Name: name.Text, Type: typ}
	if p.tok.Kind == token.ASSIGN {
		p.next()
		f.Default = p.parseFieldDefault()
	}
	return f
}

// parseFieldDefault parses a field default: a literal or a bare IDENT (an
// enum member, resolved by the checker). The literal table (Ch3: Literals)
// shows `-7` as an integer literal form; the lexer has no negative-literal
// token, so a leading `-` is accepted here in front of an INT or FIXEDLIT.
func (p *parser) parseFieldDefault() ast.Expr {
	if p.tok.Kind == token.MINUS {
		pos := p.tok.Pos
		p.next()
		switch p.tok.Kind {
		case token.INT:
			v := -p.tok.IntVal
			p.next()
			return &ast.IntLit{P: pos, Val: v}
		case token.FIXEDLIT:
			v := -p.tok.FixVal
			p.next()
			return &ast.FixedLit{P: pos, Raw: v}
		default:
			p.errorf(pos, "expected integer or fixed literal after '-', found %s", p.tok.Kind)
			panic(parseAbort{}) // unreachable: errorf already panics
		}
	}
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
	case token.IDENT:
		p.next()
		return &ast.Ident{P: tok.Pos, Name: tok.Text}
	default:
		p.errorf(tok.Pos, "expected default value, found %s", tok.Kind)
		panic(parseAbort{}) // unreachable: errorf already panics
	}
}

// parseEnumDecl parses `"enum" IDENT "{" enumMember { [ "," ] enumMember } "}"`
// (Appendix A). Members may be separated by commas, newlines, or both mixed.
func (p *parser) parseEnumDecl() *ast.EnumDecl {
	pos := p.tok.Pos
	p.next() // 'enum'
	name := p.expect(token.IDENT)
	p.expect(token.LBRACE)
	e := &ast.EnumDecl{P: pos, Name: name.Text}
	p.skipNewlines()
	for p.tok.Kind != token.RBRACE {
		e.Members = append(e.Members, p.parseEnumMember())
		if p.tok.Kind == token.COMMA {
			p.next()
		}
		p.skipNewlines()
	}
	p.next() // consume '}'
	return e
}

// parseEnumMember parses `IDENT [ INT | HEXINT ] [ STRING ]`. Hex and decimal
// integers both lex as an INT token (the lexer resolves the value); the
// parser does not check the value range or reject duplicates — that's the
// checker's job (Task 10).
func (p *parser) parseEnumMember() ast.EnumMember {
	pos := p.tok.Pos
	name := p.expect(token.IDENT)
	m := ast.EnumMember{P: pos, Name: name.Text}
	if p.tok.Kind == token.INT {
		m.HasValue = true
		m.Value = p.tok.IntVal
		p.next()
	}
	if p.tok.Kind == token.STRINGLIT {
		m.Label = p.tok.Text
		p.next()
	}
	return m
}
