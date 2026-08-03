package selfhost

import (
	"bufio"
	"os"
	"path/filepath"
	"regexp"
	"strings"
	"testing"

	"clarus/internal/reftest"
)

// inventoryMessages returns every diagnostic-message template listed as a
// `- ` + "`msg`" + ` bullet in inventory.md.
func inventoryMessages(t *testing.T) []string {
	t.Helper()
	f, err := os.Open("inventory.md")
	if err != nil {
		t.Fatal(err)
	}
	defer f.Close()
	var msgs []string
	sc := bufio.NewScanner(f)
	re := regexp.MustCompile("^- `([^`]+)`")
	for sc.Scan() {
		if m := re.FindStringSubmatch(sc.Text()); m != nil {
			msg := m[1]
			// Skip the pass-through wrapper entry and internal placeholders.
			if msg == "%s" {
				continue
			}
			msgs = append(msgs, msg)
		}
	}
	return msgs
}

// patternToRegexp turns an inventory template with Go verbs into a regexp that
// matches a concrete produced message.
func patternToRegexp(tmpl string) *regexp.Regexp {
	// Split on the verbs, quoting the literal spans between them.
	verb := regexp.MustCompile(`%[sdq]`)
	var b strings.Builder
	b.WriteString("^")
	last := 0
	for _, loc := range verb.FindAllStringIndex(tmpl, -1) {
		b.WriteString(regexp.QuoteMeta(tmpl[last:loc[0]]))
		b.WriteString(".+")
		last = loc[1]
	}
	b.WriteString(regexp.QuoteMeta(tmpl[last:]))
	b.WriteString("$")
	return regexp.MustCompile(b.String())
}

// producedMessages runs the Go front end over the whole differential corpus
// (every file the differential diffs, plus every reference fence) and returns
// the set of distinct diagnostic messages, stripped of the path:line:col
// prefix. Because the differential proves clarusc reproduces each byte-for-byte,
// a message covered here is a message clarusc reproduces.
func producedMessages(t *testing.T) map[string]bool {
	t.Helper()
	msgs := map[string]bool{}
	record := func(path string) {
		out, _ := goCheck(path)
		for _, line := range strings.Split(out, "\n") {
			if line == "" {
				continue
			}
			// Strip "path:line:col: " prefix: the message is after the
			// third colon-space. Positions never contain ": ".
			if i := strings.Index(line, ": "); i >= 0 {
				msgs[line[i+2:]] = true
			}
		}
	}
	var files []string
	for _, g := range []string{
		"../../testdata/valid/*.cla",
		"../../testdata/errors/*.cla",
		"../../testdata/run/*.cla",
		"../../testdata/runerr/*.cla",
		"../../testdata/include/*.cla",
		"../../testdata/diag/*.cla",
	} {
		m, _ := filepath.Glob(g)
		files = append(files, m...)
	}
	files = append(files, "../../clarusc/main.cla")
	for _, f := range files {
		record(f)
	}
	// Reference fences.
	fences, err := reftest.ExtractFences("../../docs/clarus-language-reference.md")
	if err != nil {
		t.Fatal(err)
	}
	dir := t.TempDir()
	for _, fe := range fences {
		p := filepath.Join(dir, "fence.cla")
		if err := os.WriteFile(p, []byte(fe.Code), 0o644); err != nil {
			t.Fatal(err)
		}
		record(p)
	}
	return msgs
}

// TestInventoryCoverage asserts every diagnostic message in inventory.md is
// exercised by at least one corpus file (and therefore, via the differential,
// reproduced by clarusc). Internal-only messages that cannot fire on any input
// are exempted explicitly.
func TestInventoryCoverage(t *testing.T) {
	requireGoCompiler(t)
	// Messages that cannot be provoked from source: the checker's
	// "internal:" guards fire only on a malformed AST the parser never
	// produces. Documented as out-of-reach in inventory.md.
	exempt := map[string]bool{
		"internal: unhandled binary operator %s": true,
		"internal: unhandled unary operator %s":  true,
		"internal: unhandled expression type":    true,
	}

	produced := producedMessages(t)
	var producedList []string
	for m := range produced {
		producedList = append(producedList, m)
	}

	var uncovered []string
	for _, tmpl := range inventoryMessages(t) {
		if exempt[tmpl] {
			continue
		}
		re := patternToRegexp(tmpl)
		hit := false
		for _, m := range producedList {
			if re.MatchString(m) {
				hit = true
				break
			}
		}
		if !hit {
			uncovered = append(uncovered, tmpl)
		}
	}
	if len(uncovered) > 0 {
		t.Errorf("%d inventory message(s) not exercised by the corpus:", len(uncovered))
		for _, u := range uncovered {
			t.Errorf("  UNCOVERED: %s", u)
		}
	}
}
