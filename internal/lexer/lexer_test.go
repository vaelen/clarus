// internal/lexer/lexer_test.go
package lexer

import (
	"clarus/internal/source"
	"clarus/internal/token"
	"testing"
)

func kinds(src string) []token.Kind {
	l := New(&source.File{Name: "t.cla", Content: []byte(src)})
	var out []token.Kind
	for {
		tk := l.Next()
		out = append(out, tk.Kind)
		if tk.Kind == token.EOF {
			return out
		}
	}
}

func TestNewlineRule(t *testing.T) {
	cases := []struct {
		src  string
		want []token.Kind
	}{
		{"x = 1\ny = 2\n", []token.Kind{token.IDENT, token.ASSIGN, token.INT, token.NEWLINE,
			token.IDENT, token.ASSIGN, token.INT, token.NEWLINE, token.EOF}},
		// line ends in operator → continuation, no NEWLINE
		{"x = 1 +\n2\n", []token.Kind{token.IDENT, token.ASSIGN, token.INT, token.PLUS,
			token.INT, token.NEWLINE, token.EOF}},
		// comma and open bracket continue
		{"f(a,\nb)\n", []token.Kind{token.IDENT, token.LPAREN, token.IDENT, token.COMMA,
			token.IDENT, token.RPAREN, token.NEWLINE, token.EOF}},
		// blank lines collapse
		{"x\n\n\ny\n", []token.Kind{token.IDENT, token.NEWLINE, token.IDENT, token.NEWLINE, token.EOF}},
		// comment stripped, newline still applies
		{"x // hi\ny\n", []token.Kind{token.IDENT, token.NEWLINE, token.IDENT, token.NEWLINE, token.EOF}},
	}
	for _, c := range cases {
		got := kinds(c.src)
		if len(got) != len(c.want) {
			t.Errorf("%q: got %v want %v", c.src, got, c.want)
			continue
		}
		for i := range got {
			if got[i] != c.want[i] {
				t.Errorf("%q: token %d got %v want %v", c.src, i, got[i], c.want[i])
			}
		}
	}
}

func TestLiterals(t *testing.T) {
	l := New(&source.File{Name: "t.cla", Content: []byte(`x = 0x1F` + "\n" + `f = 1.5` + "\n" + `c = '\n'` + "\n" + `s = "a\tb"` + "\n")})
	var toks []token.Token
	for {
		tk := l.Next()
		toks = append(toks, tk)
		if tk.Kind == token.EOF {
			break
		}
	}
	// x = 0x1F
	if toks[2].Kind != token.INT || toks[2].IntVal != 31 {
		t.Errorf("hex: got %v %d", toks[2].Kind, toks[2].IntVal)
	}
	// f = 1.5 → 1.5 * 65536 = 98304
	if toks[6].Kind != token.FIXEDLIT || toks[6].FixVal != 98304 {
		t.Errorf("fixed: got %v %d", toks[6].Kind, toks[6].FixVal)
	}
	// c = '\n' → CR = 13
	if toks[10].Kind != token.CHARLIT || toks[10].IntVal != 13 {
		t.Errorf("char: got %v %d", toks[10].Kind, toks[10].IntVal)
	}
	// s = "a\tb" → decoded bytes a, 9, b
	if toks[14].Kind != token.STRINGLIT || toks[14].Text != "a\tb" {
		t.Errorf("string: got %v %q", toks[14].Kind, toks[14].Text)
	}
}

func TestOperatorsLongestMatch(t *testing.T) {
	want := []token.Kind{token.IDENT, token.SHL, token.INT, token.PIPE, token.INT,
		token.NEWLINE, token.EOF}
	got := kinds("x << 8 | 4\n")
	for i := range want {
		if got[i] != want[i] {
			t.Fatalf("token %d: got %v want %v", i, got[i], want[i])
		}
	}
}

func TestKeywordVsIdent(t *testing.T) {
	got := kinds("var mod: int\n") // mod and int are NOT hard keywords
	want := []token.Kind{token.KwVar, token.IDENT, token.COLON, token.IDENT, token.NEWLINE, token.EOF}
	for i := range want {
		if got[i] != want[i] {
			t.Fatalf("token %d: got %v want %v", i, got[i], want[i])
		}
	}
}
