package build

import (
	"os"
	"path/filepath"
	"strings"
	"testing"
)

// TestBuildUnsupportedConstructs is a table of every construct Global
// Constraints (docs/superpowers/plans/2026-07-22-clarus-backend-host.md)
// marks host-unsupported. Each program type-checks clean (check.Files has
// no opinion on these — they're valid Clarus, just not host-buildable) and
// must fail Build with a diag naming the construct, never a built exe.
func TestBuildUnsupportedConstructs(t *testing.T) {
	cases := []struct {
		name string
		src  string
		want string // substring the offending diag's Msg must contain
	}{
		{
			name: "window",
			src:  "window W {\n    title: \"x\"\n}\n",
			want: "window",
		},
		{
			name: "menu",
			src:  "menu Edit { standard edit }\n",
			want: "menu",
		},
		{
			name: "every",
			src:  "every 1 ticks {\n}\n",
			want: "every",
		},
		{
			name: "connection var",
			src:  "var c: connection\n",
			want: "connection",
		},
		{
			name: "askOpen",
			src:  "on App.launch {\n    var p: string\n    askOpen(p)\n}\n",
			want: "askOpen",
		},
		{
			name: "file.save",
			src: "record R {\n    x: int\n}\n" +
				"on App.launch {\n    var p: string\n    var r: R\n    file.save(p, r)\n}\n",
			want: "file.save",
		},
		{
			name: "isNew",
			src: "record Person {\n    age: int\n}\n" +
				"on App.launch {\n    var p: Person = new Person\n    if p.isNew {\n    }\n}\n",
			want: "isNew",
		},
	}

	for _, tc := range cases {
		tc := tc
		t.Run(tc.name, func(t *testing.T) {
			dir := t.TempDir()
			src := writeFile(t, dir, "prog.cla", tc.src)
			exe := filepath.Join(dir, "prog")

			diags, err := Build([]string{src}, exe)
			if err != nil {
				t.Fatalf("Build: %v", err)
			}
			if len(diags) == 0 {
				t.Fatal("want unsupported-construct diag")
			}
			found := false
			for _, d := range diags {
				if strings.Contains(d.Msg, "host build does not support") && strings.Contains(d.Msg, tc.want) {
					found = true
				}
			}
			if !found {
				t.Fatalf("want a diag naming %q, got %v", tc.want, diags)
			}
			if _, statErr := os.Stat(exe); statErr == nil {
				t.Fatalf("want no output file at %s", exe)
			}
		})
	}
}
