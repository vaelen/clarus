// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// callresult_release_test.go: regression pin for the 68k call-result leak
// (../68kbbs/docs/memory-leak.md, 2026-08-29): a user function's
// handle-typed result consumed directly (argument / operand / receiver)
// must be spilled to a tracked temp and released by the end-of-statement
// flush. The host lane (cprint fpCallFn) always balanced these; emit68k
// only balanced the assignment/return/discard shapes.
//
// This fixture pulls in the full runtime (--rtdir), so it packs into
// MULTIPLE segments (cgPackProgram) -- rtTextRelease and this fixture's
// own functions do not land in the same segment. A call from one segment
// to a function in another cannot use a same-segment BSR.W/JSR-to-label
// (cgCallFunc's own doc comment: only valid when caller and callee share
// a CODE resource); it goes through the A5-relative jump table instead
// (`JSR d16(A5)`, d16 = cgJtDisp(slot) = 32 + slot*8 + 2). So counting
// calls to rtTextRelease has to check BOTH forms: same-segment label
// matches (only meaningful within rtTextRelease's own segment -- a68
// label numbers restart at 0 per segment, so a label match is NOT
// segment-independent) and cross-segment JT-slot-displacement matches
// (global, computed from the "(JT slot N)" listing comment).
package cg68k

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"sort"
	"strconv"
	"strings"
	"testing"
)

const callResultFixture = `func g(): text {
    var t: text
    t.append("hello")
    return t
}

func f(t: text): int {
    return t.length
}

func direct(): int {
    return f(g())
}

func viaLocal(): int {
    var x: text
    x = g()
    return f(x)
}

func recv(): int {
    return g().length
}

func opnd(): int {
    var n: int
    n = (g() + g()).length
    return n
}

on App.launch {
    log(string(direct() + viaLocal() + recv() + opnd()))
}
`

// readSegments loads every out.segN.s emit68k wrote to dir, ordered by
// segment number.
func readSegments(t *testing.T, dir string) []string {
	t.Helper()
	matches, err := filepath.Glob(filepath.Join(dir, "out.seg*.s"))
	if err != nil {
		t.Fatal(err)
	}
	if len(matches) == 0 {
		t.Fatal("no out.seg*.s listings found")
	}
	numRe := regexp.MustCompile(`seg(\d+)\.s$`)
	segNum := func(p string) int {
		m := numRe.FindStringSubmatch(p)
		if m == nil {
			return 0
		}
		n, _ := strconv.Atoi(m[1])
		return n
	}
	sort.Slice(matches, func(i, j int) bool { return segNum(matches[i]) < segNum(matches[j]) })
	segs := make([]string, len(matches))
	for i, m := range matches {
		b, err := os.ReadFile(m)
		if err != nil {
			t.Fatal(err)
		}
		segs[i] = string(b)
	}
	return segs
}

// findFuncInSeg returns the listing lines between "; func name" and the
// next "; func" marker within a single segment's text, or ok=false if
// that segment does not define name.
func findFuncInSeg(seg, name string) (body string, ok bool) {
	marker := "; func " + name + " "
	i := strings.Index(seg, marker)
	if i < 0 {
		return "", false
	}
	rest := seg[i+len(marker):]
	j := strings.Index(rest, "; func ")
	if j < 0 {
		j = len(rest)
	}
	return rest[:j], true
}

// releaseInfo is where and how to spot a call to rtTextRelease across
// segments.
type releaseInfo struct {
	segIdx int    // index into the segs slice where rtTextRelease is DEFINED
	label  string // its LBL_n -- only valid for calls from segIdx itself
	disp   string // e.g. "162(A5)" -- valid for calls from any OTHER segment
}

// findReleaseInfo locates rtTextRelease's own definition and derives both
// the same-segment label form and the cross-segment jump-table
// displacement form of a call to it (cgJtDisp: 32 + slot*8 + 2).
func findReleaseInfo(t *testing.T, segs []string) releaseInfo {
	t.Helper()
	markerRe := regexp.MustCompile(`; func rtTextRelease\s+\(JT slot (\d+)\)`)
	labelRe := regexp.MustCompile(`(LBL_\d+):`)
	for i, seg := range segs {
		loc := markerRe.FindStringSubmatchIndex(seg)
		if loc == nil {
			continue
		}
		slot, err := strconv.Atoi(seg[loc[2]:loc[3]])
		if err != nil {
			t.Fatalf("bad JT slot in rtTextRelease marker: %v", err)
		}
		disp := 32 + slot*8 + 2
		m := labelRe.FindStringSubmatch(seg[loc[1]:])
		if m == nil {
			t.Fatalf("no label after rtTextRelease marker in segment %d", i)
		}
		return releaseInfo{segIdx: i, label: m[1], disp: fmt.Sprintf("%d(A5)", disp)}
	}
	t.Fatal("no segment defines rtTextRelease")
	return releaseInfo{}
}

// countReleaseCalls counts calls to rtTextRelease inside body, which was
// emitted into segs[segIdx]: same-segment calls as BSR.W/JSR to rel's
// label, cross-segment calls as JSR to rel's jump-table displacement.
func countReleaseCalls(segIdx int, body string, rel releaseInfo) int {
	n := 0
	if segIdx == rel.segIdx {
		re := regexp.MustCompile(`(BSR\.W|JSR)\s+` + rel.label + `\b`)
		n += len(re.FindAllString(body, -1))
	}
	// No trailing \b: rel.disp already ends in ")" (a non-word char), so a
	// \b assertion there would never match (both sides of ")" followed by
	// whitespace/EOL are non-word) -- the literal match is unambiguous on
	// its own.
	re2 := regexp.MustCompile(`JSR\s+` + regexp.QuoteMeta(rel.disp))
	n += len(re2.FindAllString(body, -1))
	return n
}

func TestCallResultRelease(t *testing.T) {
	exe := buildClarusc(t)
	dir := t.TempDir()
	src := filepath.Join(dir, "callresult.cla")
	if err := os.WriteFile(src, []byte(callResultFixture), 0o644); err != nil {
		t.Fatal(err)
	}
	outBin := filepath.Join(dir, "out.bin")
	cmd := exec.Command(exe, "emit68k", "-o", outBin, "--listing",
		"--rtdir", filepath.Join(repoRoot(t), "runtime", "clarus")+string(os.PathSeparator), src)
	out, err := cmd.CombinedOutput()
	if err != nil {
		t.Fatalf("emit68k: %v\n%s", err, out)
	}

	segs := readSegments(t, dir)
	rel := findReleaseInfo(t, segs)

	cases := []struct {
		fn   string
		want int
	}{
		// direct: g()'s tracked result, released once after f returns.
		{"direct", 1},
		// viaLocal: unchanged from the pre-fix listing -- release of x's
		// old value at init-store, at the g() store, and at scope exit.
		// Pins "no double release on the assignment/handoff path".
		{"viaLocal", 3},
		// recv: g()'s tracked result, released once after .length.
		{"recv", 1},
		// opnd: two g() temps + the concat destination temp (handed off
		// into n? no -- n is int; the concat temp is a receiver of
		// .length, so all three release at statement end).
		{"opnd", 3},
	}
	for _, c := range cases {
		var body string
		var segIdx int
		found := false
		for i, seg := range segs {
			b, ok := findFuncInSeg(seg, c.fn)
			if ok {
				body, segIdx, found = b, i, true
				break
			}
		}
		if !found {
			t.Fatalf("no segment defines func %s", c.fn)
		}
		if got := countReleaseCalls(segIdx, body, rel); got != c.want {
			t.Errorf("%s: %d rtTextRelease calls, want %d\n%s", c.fn, got, c.want, body)
		}
	}
}
