package driver

import (
	"strings"
	"testing"
)

func TestIncludeExpansionClean(t *testing.T) {
	diags, err := Check([]string{"../../testdata/include/main.cla"})
	if err != nil {
		t.Fatal(err)
	}
	if len(diags) != 0 {
		t.Fatalf("want clean, got %v", diags[0])
	}
}

func TestIncludeDiamondProcessedOnce(t *testing.T) {
	diags, err := Check([]string{"../../testdata/include/diamond_main.cla"})
	if err != nil {
		t.Fatal(err)
	}
	if len(diags) != 0 {
		t.Fatalf("want clean (c.cla included once via a and b), got %v", diags[0])
	}
}

// TestIncludeCycleHarmless guards the include-once identity check: A
// includes B includes A must not infinite-loop or double-declare, and
// should check clean (each file's functions are visible whole-program,
// per Chapter 1's declare-before-use rules).
func TestIncludeCycleHarmless(t *testing.T) {
	diags, err := Check([]string{"../../testdata/include/cycle_a.cla"})
	if err != nil {
		t.Fatal(err)
	}
	if len(diags) != 0 {
		t.Fatalf("want clean cycle, got %v", diags[0])
	}
}

func TestIncludeMissing(t *testing.T) {
	diags, _ := Check([]string{"../../testdata/include/missing_main.cla"}) // includes "nope.cla"
	found := false
	for _, d := range diags {
		if strings.Contains(d.Msg, "cannot open included file") {
			found = true
		}
	}
	if !found {
		t.Fatalf("want cannot-open diagnostic, got %v", diags)
	}
}
