package reftest

import (
	"clarus/internal/driver"
	"os"
	"path/filepath"
	"testing"
)

func TestFencesExtract(t *testing.T) {
	fences, err := ExtractFences("../../docs/clarus-language-reference.md")
	if err != nil {
		t.Fatal(err)
	}
	if len(fences) < 20 {
		t.Fatalf("expected at least 20 rust fences, got %d", len(fences))
	}
}

// Every fence listed in CheckClean must pass `clarus check` standalone.
func TestCheckCleanFences(t *testing.T) {
	fences, err := ExtractFences("../../docs/clarus-language-reference.md")
	if err != nil {
		t.Fatal(err)
	}
	dir := t.TempDir()
	for _, idx := range CheckClean {
		if idx >= len(fences) {
			t.Fatalf("manifest index %d out of range (%d fences)", idx, len(fences))
		}
		p := filepath.Join(dir, "fence.cla")
		if err := os.WriteFile(p, []byte(fences[idx].Code), 0o644); err != nil {
			t.Fatal(err)
		}
		diags, err := driver.Check([]string{p})
		if err != nil {
			t.Fatal(err)
		}
		if len(diags) != 0 {
			t.Errorf("fence %d (md line %d): %v", idx, fences[idx].Line, diags[0])
		}
	}
}
