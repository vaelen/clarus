package driver

import (
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestValidProgramsCheckClean(t *testing.T) {
	files, _ := filepath.Glob("../../testdata/valid/*.cla")
	if len(files) < 2 {
		t.Fatal("expected at least the two worked-example fixtures")
	}
	for _, f := range files {
		diags, err := Check([]string{f})
		if err != nil {
			t.Fatalf("%s: %v", f, err)
		}
		if len(diags) != 0 {
			t.Errorf("%s: want clean, got %v", f, diags[0])
		}
	}
}

func TestErrorGoldens(t *testing.T) {
	files, _ := filepath.Glob("../../testdata/errors/*.cla")
	for _, f := range files {
		want, err := os.ReadFile(strings.TrimSuffix(f, ".cla") + ".expect")
		if err != nil {
			t.Fatalf("%s: missing .expect", f)
		}
		diags, _ := Check([]string{f})
		var got strings.Builder
		for _, d := range diags {
			got.WriteString(d.String() + "\n")
		}
		if got.String() != string(want) {
			t.Errorf("%s:\ngot:  %q\nwant: %q", f, got.String(), string(want))
		}
	}
}
