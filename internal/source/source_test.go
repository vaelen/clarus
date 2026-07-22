package source

import "testing"

func TestLineCol(t *testing.T) {
	f := &File{Name: "t.cla", Content: []byte("ab\ncd\n")}
	cases := []struct{ off, line, col int }{
		{0, 1, 1}, {1, 1, 2}, {2, 1, 3}, // newline itself is col 3 of line 1
		{3, 2, 1}, {5, 2, 3},
	}
	for _, c := range cases {
		l, co := f.LineCol(Pos{c.off})
		if l != c.line || co != c.col {
			t.Errorf("off %d: got %d:%d want %d:%d", c.off, l, co, c.line, c.col)
		}
	}
}

func TestDiagString(t *testing.T) {
	f := &File{Name: "t.cla", Content: []byte("x\n")}
	d := Diag{File: f, Pos: Pos{0}, Msg: "boom"}
	if got := d.String(); got != "t.cla:1:1: boom" {
		t.Errorf("got %q", got)
	}
}
