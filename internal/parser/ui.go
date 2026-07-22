package parser

import (
	"clarus/internal/ast"
	"clarus/internal/token"
)

// widgetKinds is the set of contextual IDENT words that begin a widgetDecl
// inside a window body (Appendix A: widgetKind). Unlike `var`/`form`, these
// are plain identifiers, not keywords — dispatched purely by text.
var widgetKinds = map[string]bool{
	"button": true, "field": true, "textview": true, "check": true,
	"popup": true, "table": true, "canvas": true, "label": true,
}

// skipItemSeps consumes a run of NEWLINE and/or SEMI tokens — the
// insignificant separators between entries in a window/widget/menu/extend
// declaration block (Appendix A: propertyList uses ";"; multi-line bodies
// rely on the lexer's NEWLINE; both are accepted interchangeably here).
func (p *parser) skipItemSeps() {
	for p.tok.Kind == token.NEWLINE || p.tok.Kind == token.SEMI {
		p.next()
	}
}

// parseWindowDecl parses `"window" IDENT "{" { windowItem } "}"`.
func (p *parser) parseWindowDecl() *ast.WindowDecl {
	pos := p.tok.Pos
	p.next() // 'window'
	name := p.expect(token.IDENT)
	p.expect(token.LBRACE)
	w := &ast.WindowDecl{P: pos, Name: name.Text}
	p.skipItemSeps()
	for p.tok.Kind != token.RBRACE {
		w.Items = append(w.Items, p.parseWindowItem())
		p.skipItemSeps()
	}
	p.next() // consume '}'
	return w
}

// parseWindowItem parses one `windowItem` (Appendix A): a `var` declaration,
// `form for IDENT`, a widget declaration (dispatched by widgetKinds), or a
// generic property.
func (p *parser) parseWindowItem() ast.WindowItem {
	switch {
	case p.tok.Kind == token.KwVar:
		return p.parseVarDecl()
	case p.tok.Kind == token.IDENT && p.tok.Text == "form":
		return p.parseFormFor()
	case p.tok.Kind == token.IDENT && widgetKinds[p.tok.Text]:
		return p.parseWidgetDecl()
	default:
		return p.parseProperty()
	}
}

// parseFormFor parses `"form" "for" IDENT` (the leading `form` IDENT has not
// yet been consumed; `for` is the hard keyword KwFor here, not contextual).
func (p *parser) parseFormFor() *ast.FormFor {
	pos := p.tok.Pos
	p.next() // 'form'
	p.expect(token.KwFor)
	rec := p.expect(token.IDENT)
	return &ast.FormFor{P: pos, Record: rec.Text}
}

// parseWidgetDecl parses `widgetKind IDENT [ "{" propertyList "}" ]`. The
// leading widgetKind word has been recognized by parseWindowItem but not yet
// consumed.
func (p *parser) parseWidgetDecl() *ast.Widget {
	pos := p.tok.Pos
	kind := p.tok.Text
	p.next() // widget kind
	name := p.expect(token.IDENT)
	w := &ast.Widget{P: pos, Kind: kind, Name: name.Text}
	if p.tok.Kind == token.LBRACE {
		p.next()
		p.skipItemSeps()
		for p.tok.Kind != token.RBRACE {
			w.Props = append(w.Props, p.parseProperty())
			p.skipItemSeps()
		}
		p.next() // consume '}'
	}
	return w
}

// parseProperty parses one `property` (Appendix A): bare `cancel` (a hard
// keyword, hence its own alternative in the grammar), a `column` clause
// (contextual IDENT text, valid anywhere in a widget body though only
// meaningful inside `table`), or a generic `IDENT [ ":" value { "," value } ]`
// where each value is a full expr — so `min(300, 200)` arrives as a Call and
// `fill`/`both`/`bottom` arrive as Ident.
func (p *parser) parseProperty() ast.WindowItem {
	pos := p.tok.Pos
	switch {
	case p.tok.Kind == token.KwCancel:
		p.next()
		return &ast.Property{P: pos, Name: "cancel"}
	case p.tok.Kind == token.IDENT && p.tok.Text == "column":
		return p.parseColumn()
	case p.tok.Kind == token.IDENT:
		name := p.tok.Text
		p.next()
		prop := &ast.Property{P: pos, Name: name}
		if p.tok.Kind == token.COLON {
			p.next()
			prop.Values = append(prop.Values, p.parseExpr())
			for p.tok.Kind == token.COMMA {
				p.next()
				prop.Values = append(prop.Values, p.parseExpr())
			}
		}
		return prop
	default:
		p.errorf(pos, "expected property, found %s", p.tok.Kind)
		panic(parseAbort{}) // unreachable: errorf already panics
	}
}

// parseColumn parses `"column" STRING "shows" IDENT "width" ( INT | "fill" )`.
// The leading `column` IDENT has not yet been consumed.
func (p *parser) parseColumn() *ast.Column {
	pos := p.tok.Pos
	p.next() // 'column'
	header := p.expect(token.STRINGLIT)
	p.expectIdentText("shows")
	shows := p.expect(token.IDENT)
	p.expectIdentText("width")
	col := &ast.Column{P: pos, Header: header.Text, Shows: shows.Text}
	switch {
	case p.tok.Kind == token.INT:
		col.WidthPx = int(p.tok.IntVal)
		p.next()
	case p.tok.Kind == token.IDENT && p.tok.Text == "fill":
		col.WidthFill = true
		p.next()
	default:
		p.errorf(p.tok.Pos, "expected column width (INT or 'fill'), found %s", p.tok.Kind)
	}
	return col
}

// parseMenuDecl parses `"menu" IDENT "{" { menuEntry } "}"`.
func (p *parser) parseMenuDecl() *ast.MenuDecl {
	pos := p.tok.Pos
	p.next() // 'menu'
	name := p.expect(token.IDENT)
	p.expect(token.LBRACE)
	m := &ast.MenuDecl{P: pos, Name: name.Text}
	p.skipItemSeps()
	for p.tok.Kind != token.RBRACE {
		m.Entries = append(m.Entries, p.parseMenuEntry())
		p.skipItemSeps()
	}
	p.next() // consume '}'
	return m
}

// parseMenuEntry parses one `menuEntry` (Appendix A): `item IDENT STRING
// [ "key" STRING ]`, bare `separator`, or `standard "edit"` — `edit` here is
// the hard keyword KwEdit, not a contextual word.
func (p *parser) parseMenuEntry() ast.MenuEntry {
	pos := p.tok.Pos
	if p.tok.Kind != token.IDENT {
		p.errorf(pos, "expected menu entry, found %s", p.tok.Kind)
	}
	switch p.tok.Text {
	case "item":
		p.next()
		name := p.expect(token.IDENT)
		caption := p.expect(token.STRINGLIT)
		e := ast.MenuEntry{P: pos, IsItem: true, Name: name.Text, Caption: caption.Text}
		if p.tok.Kind == token.IDENT && p.tok.Text == "key" {
			p.next()
			key := p.expect(token.STRINGLIT)
			e.Key = key.Text
		}
		return e
	case "separator":
		p.next()
		return ast.MenuEntry{P: pos, IsSeparator: true}
	case "standard":
		p.next()
		p.expect(token.KwEdit)
		return ast.MenuEntry{P: pos, IsStandardEdit: true}
	default:
		p.errorf(pos, "expected 'item', 'separator', or 'standard', found %s", p.tok.Kind)
		panic(parseAbort{}) // unreachable: errorf already panics
	}
}

// parseExtendDecl parses `"extend" IDENT "{" { handlerDecl | extendDecl } "}"`.
func (p *parser) parseExtendDecl() *ast.ExtendDecl {
	pos := p.tok.Pos
	p.next() // 'extend'
	target := p.expect(token.IDENT)
	p.expect(token.LBRACE)
	e := &ast.ExtendDecl{P: pos, Target: target.Text}
	p.skipItemSeps()
	for p.tok.Kind != token.RBRACE {
		switch p.tok.Kind {
		case token.KwOn:
			e.Handlers = append(e.Handlers, p.parseHandlerDecl())
		case token.KwExtend:
			e.Nested = append(e.Nested, p.parseExtendDecl())
		default:
			p.errorf(p.tok.Pos, "expected 'on' or 'extend', found %s", p.tok.Kind)
		}
		p.skipItemSeps()
	}
	p.next() // consume '}'
	return e
}

// parseHandlerDecl parses `"on" eventPath [ "(" params ")" ] block`, where
// eventPath = IDENT { "." IDENT }. Used both at the top level and nested
// inside extendDecl.
func (p *parser) parseHandlerDecl() *ast.HandlerDecl {
	pos := p.tok.Pos
	p.next() // 'on'
	first := p.expect(token.IDENT)
	h := &ast.HandlerDecl{P: pos, Path: []string{first.Text}}
	for p.tok.Kind == token.DOT {
		p.next()
		seg := p.expect(token.IDENT)
		h.Path = append(h.Path, seg.Text)
	}
	if p.tok.Kind == token.LPAREN {
		p.next()
		if p.tok.Kind != token.RPAREN {
			h.Params = append(h.Params, p.parseParam())
			for p.tok.Kind == token.COMMA {
				p.next()
				h.Params = append(h.Params, p.parseParam())
			}
		}
		p.expect(token.RPAREN)
	}
	h.Body = p.parseBodyBlock()
	return h
}

// parseEveryDecl parses `"every" INT "ticks" block`.
func (p *parser) parseEveryDecl() *ast.EveryDecl {
	pos := p.tok.Pos
	p.next() // 'every'
	n := p.expect(token.INT)
	p.expectIdentText("ticks")
	body := p.parseBodyBlock()
	return &ast.EveryDecl{P: pos, Ticks: n.IntVal, Body: body}
}
