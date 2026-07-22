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

func diagsFor(src string) []source.Diag {
	l := New(&source.File{Name: "t.cla", Content: []byte(src)})
	for {
		tk := l.Next()
		if tk.Kind == token.EOF {
			return l.Diags()
		}
	}
}

func TestHexLiteralNoDigits(t *testing.T) {
	diags := diagsFor("x = 0x\n")
	if len(diags) != 1 || diags[0].Msg != "hex literal has no digits" {
		t.Fatalf("got diags %v, want one %q", diags, "hex literal has no digits")
	}
	if diags[0].Pos.Offset != 4 {
		t.Errorf("pos: got %d want 4 (offset of '0')", diags[0].Pos.Offset)
	}

	if diags := diagsFor("x = 0x1F\n"); len(diags) != 0 {
		t.Errorf("0x1F: got unexpected diags %v", diags)
	}
}

func TestIdentifierMustNotStartWithUnderscore(t *testing.T) {
	diags := diagsFor("_x = 1\n")
	found := false
	for _, d := range diags {
		if d.Msg == `unexpected character '_'` {
			found = true
		}
	}
	if !found {
		t.Fatalf("got diags %v, want one containing %q", diags, `unexpected character '_'`)
	}

	got := kinds("_x = 1\n")
	want := []token.Kind{token.IDENT, token.ASSIGN, token.INT, token.NEWLINE, token.EOF}
	if len(got) != len(want) {
		t.Fatalf("_x = 1: got %v want %v", got, want)
	}
	for i := range want {
		if got[i] != want[i] {
			t.Errorf("_x = 1: token %d got %v want %v", i, got[i], want[i])
		}
	}

	// underscore is still valid as a continuation character
	got2 := kinds("a_b\n")
	want2 := []token.Kind{token.IDENT, token.NEWLINE, token.EOF}
	if len(got2) != len(want2) {
		t.Fatalf("a_b: got %v want %v", got2, want2)
	}
	l := New(&source.File{Name: "t.cla", Content: []byte("a_b\n")})
	tok := l.Next()
	if tok.Kind != token.IDENT || tok.Text != "a_b" {
		t.Errorf("a_b: got %v %q, want IDENT %q", tok.Kind, tok.Text, "a_b")
	}
}

func TestNewlineSynthesizedAtEOF(t *testing.T) {
	got := kinds("x = 1")
	want := []token.Kind{token.IDENT, token.ASSIGN, token.INT, token.NEWLINE, token.EOF}
	if len(got) != len(want) {
		t.Fatalf("x = 1 (no trailing newline): got %v want %v", got, want)
	}
	for i := range want {
		if got[i] != want[i] {
			t.Errorf("token %d got %v want %v", i, got[i], want[i])
		}
	}

	// already ends in newline: no double NEWLINE
	got2 := kinds("x = 1\n")
	want2 := []token.Kind{token.IDENT, token.ASSIGN, token.INT, token.NEWLINE, token.EOF}
	if len(got2) != len(want2) {
		t.Fatalf("x = 1\\n: got %v want %v", got2, want2)
	}
	for i := range want2 {
		if got2[i] != want2[i] {
			t.Errorf("token %d got %v want %v", i, got2[i], want2[i])
		}
	}

	// empty input: just EOF
	got3 := kinds("")
	want3 := []token.Kind{token.EOF}
	if len(got3) != len(want3) || got3[0] != want3[0] {
		t.Fatalf("empty: got %v want %v", got3, want3)
	}

	// comment at EOF with no trailing newline
	got4 := kinds("x = 1 // c")
	want4 := []token.Kind{token.IDENT, token.ASSIGN, token.INT, token.NEWLINE, token.EOF}
	if len(got4) != len(want4) {
		t.Fatalf("x = 1 // c: got %v want %v", got4, want4)
	}
	for i := range want4 {
		if got4[i] != want4[i] {
			t.Errorf("token %d got %v want %v", i, got4[i], want4[i])
		}
	}
}

func TestEOFForever(t *testing.T) {
	l := New(&source.File{Name: "t.cla", Content: []byte("x = 1")})
	var toks []token.Token
	for i := 0; i < 7; i++ {
		toks = append(toks, l.Next())
	}
	// After the first EOF (at index 4), all subsequent tokens must be EOF
	if toks[4].Kind != token.EOF {
		t.Fatalf("token 4: got %v, want EOF", toks[4].Kind)
	}
	for i := 5; i < len(toks); i++ {
		if toks[i].Kind != token.EOF {
			t.Errorf("token %d: got %v, want EOF (EOF must continue forever)", i, toks[i].Kind)
		}
	}
}

func TestOverLongCharLiteralOneDiagnosticNoStrayTokens(t *testing.T) {
	diags := diagsFor("x = 'ab'\n")
	if len(diags) != 1 || diags[0].Msg != "character literal must contain exactly one character" {
		t.Fatalf("got diags %v, want exactly one %q", diags, "character literal must contain exactly one character")
	}
	got := kinds("x = 'ab'\n")
	want := []token.Kind{token.IDENT, token.ASSIGN, token.CHARLIT, token.NEWLINE, token.EOF}
	if len(got) != len(want) {
		t.Fatalf("'ab': got %v want %v (no stray IDENT)", got, want)
	}
	for i := range want {
		if got[i] != want[i] {
			t.Errorf("token %d got %v want %v", i, got[i], want[i])
		}
	}
}

func TestInvalidEscapeSequence(t *testing.T) {
	diags := diagsFor("x = '\\q'\n")
	if len(diags) != 1 || diags[0].Msg != "invalid escape sequence" {
		t.Fatalf("got diags %v, want exactly one %q", diags, "invalid escape sequence")
	}
}

func TestSyntheticNewlineAfterDanglingOperator(t *testing.T) {
	got := kinds("x = 1 +")
	want := []token.Kind{token.IDENT, token.ASSIGN, token.INT, token.PLUS, token.NEWLINE, token.EOF}
	if len(got) != len(want) {
		t.Fatalf("x = 1 +: got %v want %v", got, want)
	}
	for i := range want {
		if got[i] != want[i] {
			t.Errorf("token %d got %v want %v", i, got[i], want[i])
		}
	}
}
