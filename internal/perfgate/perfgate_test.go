// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// Package perfgate is an emit-time tripwire (test-suite-review Task 2): it
// bootstraps clarusc from the committed C snapshot -- the exact
// scripts/build-68k.sh:45-48 recipe (`cc -O1` on clarusc/clarusc.c +
// internal/build/rt/rt.c), duplicated locally rather than run via
// internal/build's Go-native build.Build, because the whole point is to
// time the ACTUAL bootstrap path a Go-less contributor would use -- then
// times `clarusc emit` of testdata/emitui/every.cla (median of 3 runs) and
// fails if that median exceeds 2x the recorded baseline.txt. Ungated: runs
// in every `go test ./...` sweep (Task 1's T1), so a future 30x emit-time
// regression (the kind this package exists to catch) cannot land silently.
package perfgate

import (
	"os"
	"os/exec"
	"path/filepath"
	"sort"
	"strconv"
	"strings"
	"sync"
	"testing"
	"time"
)

var (
	claruscOnce sync.Once
	claruscExe  string
	claruscErr  error
	claruscSkip string
)

// repoRoot returns the repo root, computed from the package directory (go
// test always runs with cwd == the package dir) -- duplicated from
// internal/mactest/mac_test.go's own repoRoot rather than imported, since
// this package must not depend on mactest.
func repoRoot(t *testing.T) string {
	t.Helper()
	wd, err := os.Getwd()
	if err != nil {
		t.Fatalf("getwd: %v", err)
	}
	return filepath.Join(wd, "..", "..")
}

// buildClarusc bootstraps clarusc from the committed C snapshot. Memoized
// with sync.Once (one build per `go test` invocation, mirrors
// internal/mactest/native_test.go's buildNativeClarusc) using a
// testing.T-managed temp dir -- fine since this package has a single test.
func buildClarusc(t *testing.T) string {
	t.Helper()
	claruscOnce.Do(func() {
		if _, err := exec.LookPath("cc"); err != nil {
			claruscSkip = "cc not found on PATH, skipping emit-time tripwire"
			return
		}
		root := repoRoot(t)
		exe := filepath.Join(t.TempDir(), "clarusc")
		cmd := exec.Command("cc", "-O1", "-I", filepath.Join(root, "internal", "build", "rt"),
			"-o", exe,
			filepath.Join(root, "clarusc", "clarusc.c"),
			filepath.Join(root, "internal", "build", "rt", "rt.c"))
		if out, err := cmd.CombinedOutput(); err != nil {
			claruscErr = errString(err.Error() + "\n" + strings.TrimSpace(string(out)))
			return
		}
		claruscExe = exe
	})
	if claruscSkip != "" {
		t.Skip(claruscSkip)
	}
	if claruscErr != nil {
		t.Fatal(claruscErr)
	}
	return claruscExe
}

type errString string

func (e errString) Error() string { return string(e) }

// readBaseline parses baseline.txt: leading `#`-comment lines are skipped,
// the first non-comment, non-blank line is the baseline in seconds.
func readBaseline(t *testing.T, path string) float64 {
	t.Helper()
	data, err := os.ReadFile(path)
	if err != nil {
		t.Fatalf("read baseline: %v", err)
	}
	for _, line := range strings.Split(string(data), "\n") {
		line = strings.TrimSpace(line)
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		v, err := strconv.ParseFloat(line, 64)
		if err != nil {
			t.Fatalf("parse baseline value %q: %v", line, err)
		}
		return v
	}
	t.Fatalf("%s: no baseline value line found", path)
	return 0
}

// TestEmitPerfTripwire times `clarusc emit` of testdata/emitui/every.cla
// three times, takes the median, and fails if it exceeds 2x baseline.txt.
// This is a tripwire against a silent 30x-style emit-time regression, NOT
// a benchmark -- it does not fail on being merely slow, only on being more
// than 2x the recorded baseline.
func TestEmitPerfTripwire(t *testing.T) {
	exe := buildClarusc(t)
	root := repoRoot(t)
	fixture := filepath.Join(root, "testdata", "emitui", "every.cla")
	rtDir := filepath.Join(root, "runtime", "clarus")
	outFile := filepath.Join(t.TempDir(), "every.c")

	const runs = 3
	durs := make([]time.Duration, runs)
	for i := 0; i < runs; i++ {
		start := time.Now()
		cmd := exec.Command(exe, "emit", "--rtdir", rtDir, "-o", outFile, fixture)
		out, err := cmd.CombinedOutput()
		durs[i] = time.Since(start)
		if err != nil {
			t.Fatalf("clarusc emit run %d failed: %v\n%s", i, err, out)
		}
	}
	sort.Slice(durs, func(i, j int) bool { return durs[i] < durs[j] })
	median := durs[runs/2]

	baseline := readBaseline(t, "baseline.txt")
	limit := 2 * baseline
	t.Logf("emit runs: %v, median: %.3fs, baseline: %.3fs, limit (2x): %.3fs",
		durs, median.Seconds(), baseline, limit)
	if median.Seconds() > limit {
		t.Fatalf("emit-time tripwire: median %.3fs exceeds 2x baseline %.3fs (limit %.3fs) -- "+
			"either a real regression, or the baseline is stale: re-baseline by editing "+
			"internal/perfgate/baseline.txt to the new median and justifying the change in "+
			"the commit message",
			median.Seconds(), baseline, limit)
	}
}
