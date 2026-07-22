// internal/token/token_test.go
package token

import "testing"

func TestKeywords(t *testing.T) {
	hard := []string{"var", "func", "record", "enum", "const", "window", "menu", "extend",
		"on", "every", "if", "else", "while", "for", "in", "to", "return",
		"and", "or", "not", "true", "false", "nil",
		"open", "close", "edit", "new", "quit", "cancel",
		"switch", "case", "break", "continue"}
	if len(Keywords) != len(hard) {
		t.Fatalf("Keywords has %d entries, want %d", len(Keywords), len(hard))
	}
	for _, w := range hard {
		if _, ok := Keywords[w]; !ok {
			t.Errorf("missing hard keyword %q", w)
		}
	}
	// contextual words must NOT be keywords
	for _, w := range []string{"mod", "string", "int", "list", "map", "of", "ticks", "form", "item", "standard"} {
		if _, ok := Keywords[w]; ok {
			t.Errorf("%q must not be a hard keyword", w)
		}
	}
}
