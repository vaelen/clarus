package reftest

import (
	"bytes"
	"clarus/internal/claruscboot"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
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

// Every fence listed in CheckClean must check clean under clarusc standalone.
func TestCheckCleanFences(t *testing.T) {
	fences, err := ExtractFences("../../docs/clarus-language-reference.md")
	if err != nil {
		t.Fatal(err)
	}
	dir := t.TempDir()
	exe := claruscboot.CurrentExe(t)
	for _, idx := range CheckClean {
		if idx >= len(fences) {
			t.Fatalf("manifest index %d out of range (%d fences)", idx, len(fences))
		}
		p := filepath.Join(dir, "fence.cla")
		if err := os.WriteFile(p, []byte(fences[idx].Code), 0o644); err != nil {
			t.Fatal(err)
		}
		out, err := exec.Command(exe, p).CombinedOutput()
		if err != nil || len(bytes.TrimSpace(out)) != 0 {
			t.Errorf("fence %d (md line %d): clarusc check not clean (err=%v):\n%s",
				idx, fences[idx].Line, err, out)
		}
	}
}

// TestRequiredProgramsInManifest verifies that CheckClean includes all four
// required full example programs, even if document line numbers shift later.
// Each program is located by distinctive content substrings (robust to index
// shifts from future doc edits).
func TestRequiredProgramsInManifest(t *testing.T) {
	fences, err := ExtractFences("../../docs/clarus-language-reference.md")
	if err != nil {
		t.Fatal(err)
	}

	// Define required programs by their distinctive content substrings.
	// All substrings in a program must be present in Code to match.
	requiredPrograms := []struct {
		name       string
		substrings []string
	}{
		{"Ch1 example", []string{"record Person {"}},
		{"Ch11 bounce", []string{`title: "Bounce"`}},
		{"Appendix C bookmark manager", []string{"window EditForm {", "enum Protocol"}},
		{"Appendix C text editor", []string{"menu Edit { standard edit }", "func openPath"}},
	}

	for _, prog := range requiredPrograms {
		var foundIndex int
		found := false
		for i, fence := range fences {
			allMatch := true
			for _, substr := range prog.substrings {
				if !strings.Contains(fence.Code, substr) {
					allMatch = false
					break
				}
			}
			if allMatch {
				foundIndex = i
				found = true
				break
			}
		}

		if !found {
			t.Errorf("required program %q not found", prog.name)
			continue
		}

		// Check that this index is in CheckClean.
		inCheckClean := false
		for _, idx := range CheckClean {
			if idx == foundIndex {
				inCheckClean = true
				break
			}
		}
		if !inCheckClean {
			t.Errorf("required program %q (index %d) not in CheckClean", prog.name, foundIndex)
		}
	}
}

// TestClaruscOnlyDisjoint guards the clarusc-only fence mechanism: every
// index in ClaruscOnly must be in range and must not also appear in
// CheckClean (a fence can't be both "the frozen Go compiler can't parse
// this" and "the frozen Go compiler checks this clean").
func TestClaruscOnlyDisjoint(t *testing.T) {
	fences, err := ExtractFences("../../docs/clarus-language-reference.md")
	if err != nil {
		t.Fatal(err)
	}
	if len(ClaruscOnly) == 0 {
		t.Fatal("expected at least one clarusc-only fence (Chapter 13)")
	}
	clean := map[int]bool{}
	for _, i := range CheckClean {
		clean[i] = true
	}
	for _, i := range ClaruscOnly {
		if i < 0 || i >= len(fences) {
			t.Errorf("ClaruscOnly index %d out of range (%d fences)", i, len(fences))
		}
		if clean[i] {
			t.Errorf("fence %d is in both CheckClean and ClaruscOnly", i)
		}
	}
}
