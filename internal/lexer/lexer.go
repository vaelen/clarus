// Package lexer converts Clarus source text into a stream of tokens.
package lexer

import (
	"clarus/internal/source"
	"clarus/internal/token"
	"fmt"
)

// Lexer scans a source.File and produces tokens on demand.
type Lexer struct {
	f   *source.File
	off int

	prev     token.Kind
	havePrev bool

	diags []source.Diag
}

// New creates a Lexer over f.
func New(f *source.File) *Lexer {
	return &Lexer{f: f}
}

// Diags returns diagnostics accumulated so far.
func (l *Lexer) Diags() []source.Diag {
	return l.diags
}

func (l *Lexer) errorf(pos source.Pos, format string, args ...interface{}) {
	l.diags = append(l.diags, source.Diag{File: l.f, Pos: pos, Msg: fmt.Sprintf(format, args...)})
}

// isOperatorKind reports whether k is one of the tokens after which a
// trailing newline is a continuation rather than a statement end.
func isOperatorKind(k token.Kind) bool {
	if k >= token.ASSIGN && k <= token.TILDE {
		return true
	}
	switch k {
	case token.COMMA, token.LPAREN, token.LBRACKET, token.LBRACE, token.COLON:
		return true
	}
	return false
}

func isSpace(b byte) bool { return b == ' ' || b == '\t' || b == '\r' }

func isDigit(b byte) bool { return b >= '0' && b <= '9' }

func isLetter(b byte) bool {
	return b == '_' || (b >= 'a' && b <= 'z') || (b >= 'A' && b <= 'Z')
}

// isIdentStart reports whether b may begin an identifier. Unlike isLetter,
// '_' is excluded: per the language reference, identifiers begin with a
// letter — '_' is valid only as a continuation character.
func isIdentStart(b byte) bool {
	return (b >= 'a' && b <= 'z') || (b >= 'A' && b <= 'Z')
}

func isAlnum(b byte) bool { return isLetter(b) || isDigit(b) }

func isHex(b byte) bool {
	return isDigit(b) || (b >= 'a' && b <= 'f') || (b >= 'A' && b <= 'F')
}

// Next returns the next token. At end of input it returns EOF forever.
func (l *Lexer) Next() token.Token {
	for {
		// Skip whitespace (not newline) and comments.
		for l.off < len(l.f.Content) {
			b := l.f.Content[l.off]
			if isSpace(b) {
				l.off++
				continue
			}
			if b == '/' && l.off+1 < len(l.f.Content) && l.f.Content[l.off+1] == '/' {
				for l.off < len(l.f.Content) && l.f.Content[l.off] != '\n' {
					l.off++
				}
				continue
			}
			break
		}

		if l.off >= len(l.f.Content) {
			// Emit synthetic NEWLINE at EOF to end incomplete statements (e.g., "x = 1 +"
			// without trailing newline). The synthetic NEWLINE deliberately bypasses the
			// operator-continuation suppression: at true EOF there is no next line, so files
			// ending mid-expression get a NEWLINE and surface a parse error instead of silent truncation.
			if l.havePrev && l.prev != token.NEWLINE && l.prev != token.SEMI && l.prev != token.EOF {
				return l.emit(token.NEWLINE, source.Pos{Offset: l.off}, "\n")
			}
			return l.emit(token.EOF, source.Pos{Offset: l.off}, "")
		}

		pos := source.Pos{Offset: l.off}
		b := l.f.Content[l.off]

		if b == '\n' {
			l.off++
			if !l.havePrev || isOperatorKind(l.prev) || l.prev == token.NEWLINE || l.prev == token.SEMI {
				continue
			}
			return l.emit(token.NEWLINE, pos, "\n")
		}

		if isDigit(b) {
			return l.lexNumber(pos)
		}

		if isIdentStart(b) {
			return l.lexIdent(pos)
		}

		switch b {
		case '\'':
			return l.lexChar(pos)
		case '"':
			return l.lexString(pos)
		}

		if kind, text, ok := l.lexOperator(); ok {
			return l.emit(kind, pos, text)
		}

		// Unknown byte.
		l.off++
		l.errorf(pos, "unexpected character %q", rune(b))
		continue
	}
}

// emit records tok as the previously-significant token and returns it.
func (l *Lexer) emit(kind token.Kind, pos source.Pos, text string) token.Token {
	l.prev = kind
	l.havePrev = true
	return token.Token{Kind: kind, Pos: pos, Text: text}
}

func (l *Lexer) lexNumber(pos source.Pos) token.Token {
	start := l.off
	if l.f.Content[l.off] == '0' && l.off+1 < len(l.f.Content) &&
		(l.f.Content[l.off+1] == 'x' || l.f.Content[l.off+1] == 'X') {
		l.off += 2
		hexStart := l.off
		for l.off < len(l.f.Content) && isHex(l.f.Content[l.off]) {
			l.off++
		}
		if l.off == hexStart {
			l.errorf(pos, "hex literal has no digits")
			return l.emit(token.INT, pos, string(l.f.Content[start:l.off]))
		}
		text := string(l.f.Content[start:l.off])
		var v int64
		for _, c := range l.f.Content[hexStart:l.off] {
			v = v*16 + int64(hexDigit(c))
		}
		tok := l.emit(token.INT, pos, text)
		tok.IntVal = v
		return tok
	}

	for l.off < len(l.f.Content) && isDigit(l.f.Content[l.off]) {
		l.off++
	}

	if l.off+1 < len(l.f.Content) && l.f.Content[l.off] == '.' && isDigit(l.f.Content[l.off+1]) {
		intPart := string(l.f.Content[start:l.off])
		l.off++ // consume '.'
		fracStart := l.off
		for l.off < len(l.f.Content) && isDigit(l.f.Content[l.off]) {
			l.off++
		}
		fracDigits := string(l.f.Content[fracStart:l.off])
		text := string(l.f.Content[start:l.off])

		var whole int64
		for _, c := range intPart {
			whole = whole*10 + int64(c-'0')
		}
		// Scale the fractional digits to 16.16 fixed point without
		// floating point: frac/10^n * 65536, rounded to nearest.
		var fracNum int64 = 0
		var fracDen int64 = 1
		for _, c := range fracDigits {
			fracNum = fracNum*10 + int64(c-'0')
			fracDen *= 10
		}
		fracScaled := (fracNum*65536*2 + fracDen) / (fracDen * 2) // round to nearest
		fixVal := int32(whole*65536 + fracScaled)

		tok := l.emit(token.FIXEDLIT, pos, text)
		tok.FixVal = fixVal
		return tok
	}

	text := string(l.f.Content[start:l.off])
	var v int64
	for _, c := range text {
		v = v*10 + int64(c-'0')
	}
	tok := l.emit(token.INT, pos, text)
	tok.IntVal = v
	return tok
}

func hexDigit(c byte) int {
	switch {
	case c >= '0' && c <= '9':
		return int(c - '0')
	case c >= 'a' && c <= 'f':
		return int(c-'a') + 10
	default:
		return int(c-'A') + 10
	}
}

func (l *Lexer) lexIdent(pos source.Pos) token.Token {
	start := l.off
	for l.off < len(l.f.Content) && isAlnum(l.f.Content[l.off]) {
		l.off++
	}
	text := string(l.f.Content[start:l.off])
	if kind, ok := token.Keywords[text]; ok {
		return l.emit(kind, pos, text)
	}
	if len(text) > 255 {
		l.errorf(pos, "identifier too long (max 255 bytes)")
	}
	return l.emit(token.IDENT, pos, text)
}

// decodeEscape decodes the escape sequence starting at l.off (which must
// point just past the backslash). It returns the decoded byte and whether
// the escape was recognized.
func (l *Lexer) decodeEscape(quote byte) (byte, bool) {
	if l.off >= len(l.f.Content) {
		return 0, false
	}
	c := l.f.Content[l.off]
	l.off++
	switch c {
	case '"':
		return '"', true
	case '\\':
		return '\\', true
	case 'n':
		return 13, true // CR, the Mac newline
	case 't':
		return 9, true
	case '\'':
		if quote == '\'' {
			return '\'', true
		}
	}
	return 0, false
}

func (l *Lexer) lexChar(pos source.Pos) token.Token {
	l.off++ // consume opening '
	if l.off >= len(l.f.Content) || l.f.Content[l.off] == '\n' {
		l.errorf(pos, "unterminated character literal")
		return l.emit(token.CHARLIT, pos, "")
	}

	var v byte
	if l.f.Content[l.off] == '\\' {
		l.off++
		b, ok := l.decodeEscape('\'')
		if !ok {
			l.errorf(pos, "invalid escape sequence")
			l.resyncCharLit()
			return l.emit(token.CHARLIT, pos, "")
		}
		v = b
	} else {
		v = l.f.Content[l.off]
		l.off++
	}

	if l.off >= len(l.f.Content) || l.f.Content[l.off] == '\n' {
		l.errorf(pos, "unterminated character literal")
		return l.emit(token.CHARLIT, pos, "")
	}
	if l.f.Content[l.off] != '\'' {
		l.errorf(pos, "character literal must contain exactly one character")
		l.resyncCharLit()
		return l.emit(token.CHARLIT, pos, "")
	}
	l.off++ // consume closing '

	tok := l.emit(token.CHARLIT, pos, string(v))
	tok.IntVal = int64(v)
	return tok
}

// resyncCharLit advances past a malformed character literal's closing quote
// on the current line — or to end of line if there is none — so a bad
// literal ('ab', '\q) never leaves stray tokens for the parser to trip over.
func (l *Lexer) resyncCharLit() {
	for l.off < len(l.f.Content) && l.f.Content[l.off] != '\n' {
		if l.f.Content[l.off] == '\'' {
			l.off++
			return
		}
		l.off++
	}
}

func (l *Lexer) lexString(pos source.Pos) token.Token {
	l.off++ // consume opening "
	var out []byte
	for {
		if l.off >= len(l.f.Content) || l.f.Content[l.off] == '\n' {
			l.errorf(pos, "unterminated string literal")
			break
		}
		c := l.f.Content[l.off]
		if c == '"' {
			l.off++
			break
		}
		if c == '\\' {
			l.off++
			b, ok := l.decodeEscape('"')
			if !ok {
				l.errorf(pos, "unterminated string literal")
				break
			}
			out = append(out, b)
			continue
		}
		out = append(out, c)
		l.off++
	}
	if len(out) > 255 {
		l.errorf(pos, "string literal too long (max 255 bytes)")
	}
	tok := l.emit(token.STRINGLIT, pos, string(out))
	return tok
}

// twoByteOps must be checked before single-byte ops (longest match first).
var twoByteOps = map[string]token.Kind{
	"<<": token.SHL,
	">>": token.SHR,
	"<=": token.LE,
	">=": token.GE,
	"==": token.EQ,
	"!=": token.NE,
}

var oneByteOps = map[byte]token.Kind{
	'(': token.LPAREN,
	')': token.RPAREN,
	'{': token.LBRACE,
	'}': token.RBRACE,
	'[': token.LBRACKET,
	']': token.RBRACKET,
	',': token.COMMA,
	':': token.COLON,
	'.': token.DOT,
	'=': token.ASSIGN,
	'<': token.LT,
	'>': token.GT,
	'+': token.PLUS,
	'-': token.MINUS,
	'*': token.STAR,
	'/': token.SLASH,
	'&': token.AMP,
	'|': token.PIPE,
	'^': token.CARET,
	'~': token.TILDE,
	';': token.SEMI,
}

// lexOperator attempts to match an operator/punctuation token at l.off,
// advancing l.off past it on success (longest match first). A bare '!'
// (there is no '!' operator; "not" is the negation) and any other
// unrecognized byte are left untouched for the caller's unknown-byte
// diagnostic.
func (l *Lexer) lexOperator() (token.Kind, string, bool) {
	content := l.f.Content
	if l.off+1 < len(content) {
		two := string(content[l.off : l.off+2])
		if kind, ok := twoByteOps[two]; ok {
			l.off += 2
			return kind, two, true
		}
	}
	b := content[l.off]
	if kind, ok := oneByteOps[b]; ok {
		l.off++
		return kind, string(b), true
	}
	return 0, "", false
}
