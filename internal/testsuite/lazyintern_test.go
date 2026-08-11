// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// lazyintern_test.go (memory-leak-fix Task 7, fix round 1): a mechanical
// guard against reintroducing the stale-pool-index miscompile class Task
// 7's libReset() exists to close off. Before Task 7, lib.cla's intern
// pool never reset, so a "lazy-guard interning" helper -- either
// `var iFooIdx: int = -1` + `if iFooIdx == -1 { iFooIdx = intern(...) }`,
// or `var xInited: bool` + `if xInited { return }` -- was safe to leave
// un-reset forever. After libReset(), pool indices RECYCLE across
// compiles, so any such helper missing a per-compile reset silently
// resolves to a WRONG string on the second+ compile in one process (the
// exact bug class Task 7's own fix round found FOUR live instances of --
// rnInit/cnInit/cwInit/kwInit -- plus 163 more in ir.cla/lower.cla; see
// task-7-report.md). This test scans every clarusc/*.cla file (byte-safe:
// two of them are MacRoman-encoded, but the patterns here are pure ASCII,
// so no charmap decode is needed -- Go's regexp matches ASCII literals
// correctly against arbitrary bytes regardless of the surrounding file's
// text encoding) for both idioms and asserts each guarded global has a
// reset assignment SOMEWHERE in clarusc/*.cla. It doesn't care which
// function -- irReset/checkReset/driveReset/lexAll/lowerProgram/... are
// all valid homes, matching how the existing ~166 instances are spread
// across the codebase.
package testsuite

import (
	"bytes"
	"os"
	"path/filepath"
	"regexp"
	"testing"
)

// reSentinelGuard finds `if X == -1 { X = intern(` (X captured twice;
// callers verify both captures agree, since Go's RE2 has no
// backreferences).
var reSentinelGuard = regexp.MustCompile(`if (\w+) == -1 \{\s*(\w+) = intern\(`)

// reBoolGuardVar finds every `var X...Inited: bool` declaration -- the
// naming convention every existing lazy-guard-bool (rnInited/cnInited/
// cwInited/kwInited) follows.
var reBoolGuardVar = regexp.MustCompile(`var (\w*Inited): bool`)

// hasResetAssign reports whether name is assigned its reset value (-1 for
// a sentinel guard, false for a bool guard) as a bare statement anywhere
// in corpus, excluding name's own `var name: ... = -1` declaration line
// (which every sentinel guard has and which must not count as "a reset
// elsewhere").
func hasResetAssign(corpus []byte, name string, sentinel bool) bool {
	want := []byte(name + " = -1")
	if !sentinel {
		want = []byte(name + " = false")
	}
	declPrefix := []byte("var " + name + ":")
	for _, line := range bytes.Split(corpus, []byte("\n")) {
		trimmed := bytes.TrimSpace(line)
		if bytes.HasPrefix(trimmed, declPrefix) {
			continue // the declaration itself, not a per-compile reset
		}
		if bytes.Contains(trimmed, want) {
			return true
		}
	}
	return false
}

func TestLazyInternGuardsAreReset(t *testing.T) {
	root := repoRoot(t)
	files, err := filepath.Glob(filepath.Join(root, "clarusc", "*.cla"))
	if err != nil || len(files) == 0 {
		t.Fatalf("glob clarusc/*.cla: %v (matched %d files)", err, len(files))
	}

	// Strip pure-comment lines before scanning: this file's own doc
	// comments (and others like it, e.g. ir.cla's `IXxx()` family header)
	// quote the guard idiom as prose (`// ... if iXxxIdx == -1 {
	// iXxxIdx = intern(...) }`), which would otherwise false-positive as
	// a real accessor with a made-up name. A trailing comment on a real
	// code line (e.g. `foo.clear()   // ...`) is kept -- only a line
	// whose trimmed content STARTS with "//" is dropped.
	var corpus []byte
	for _, f := range files {
		b, err := os.ReadFile(f)
		if err != nil {
			t.Fatalf("read %s: %v", f, err)
		}
		for _, line := range bytes.Split(b, []byte("\n")) {
			if bytes.HasPrefix(bytes.TrimSpace(line), []byte("//")) {
				continue
			}
			corpus = append(corpus, line...)
			corpus = append(corpus, '\n')
		}
	}

	seen := map[string]bool{}

	for _, m := range reSentinelGuard.FindAllSubmatch(corpus, -1) {
		name, again := string(m[1]), string(m[2])
		if name != again || seen[name] {
			continue
		}
		seen[name] = true
		if !hasResetAssign(corpus, name, true) {
			t.Errorf("lazy-guard intern sentinel %q (idiom: `if %s == -1 { %s = intern(...) }`) "+
				"has no per-compile reset (`%s = -1`) anywhere in clarusc/*.cla -- add one to the "+
				"right reset function (irReset/checkReset/driveReset/lexAll/lowerProgram/...), or "+
				"this becomes the next stale-pool-index miscompile once libReset() recycles the pool",
				name, name, name, name)
		}
	}

	for _, m := range reBoolGuardVar.FindAllSubmatch(corpus, -1) {
		name := string(m[1])
		if seen[name] {
			continue
		}
		seen[name] = true
		if !hasResetAssign(corpus, name, false) {
			t.Errorf("lazy-guard-bool %q (a `var %s: bool` process-lifetime init guard) has no "+
				"per-compile reset (`%s = false`) anywhere in clarusc/*.cla -- same stale-pool-index "+
				"hazard class as rnInit/rnInited", name, name, name)
		}
	}

	if len(seen) == 0 {
		t.Fatal("found zero lazy-guard-interning globals across clarusc/*.cla -- the detection " +
			"regexes are probably broken (expected at least rnInit/cnInit/cwInit/kwInit plus the " +
			"~163 ir.cla/lower.cla sentinel accessors)")
	}
}
