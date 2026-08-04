// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

package claruscboot

import (
	"os"
	"os/exec"
	"path/filepath"
	"testing"
)

// TestCurrentExeChecksFixture proves CurrentExe yields a working
// current-source clarusc: run it in default check mode over a known-clean
// corpus fixture and require a clean exit with no output.
func TestCurrentExeChecksFixture(t *testing.T) {
	exe := CurrentExe(t)
	root, err := repoRoot()
	if err != nil {
		t.Fatal(err)
	}
	fixture := filepath.Join(root, "testdata", "valid", "bookmarks.cla")
	out, err := exec.Command(exe, fixture).CombinedOutput()
	if err != nil || len(out) != 0 {
		t.Fatalf("clarusc check %s not clean: err=%v\n%s", fixture, err, out)
	}
}

// TestCacheReuse proves the disk cache is warm after a build: a second
// ensure pass must not rebuild (artifact mtime unchanged).
func TestCacheReuse(t *testing.T) {
	exe := CurrentExe(t)
	before, err := os.Stat(exe)
	if err != nil {
		t.Fatal(err)
	}
	// Bypass the sync.Once memoization: call the ensure path directly.
	exe2, err := ensureCurrent()
	if err != nil {
		t.Fatal(err)
	}
	after, err := os.Stat(exe2)
	if err != nil {
		t.Fatal(err)
	}
	if exe2 != exe || !after.ModTime().Equal(before.ModTime()) {
		t.Fatalf("cache miss on warm tree: %s (mtime %v) vs %s (mtime %v)",
			exe, before.ModTime(), exe2, after.ModTime())
	}
}
