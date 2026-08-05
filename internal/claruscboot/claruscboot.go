// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// Package claruscboot builds the self-hosted clarusc compiler for Go test
// harnesses without the Go compiler (Go-compiler-deletion phase, spec
// docs/superpowers/specs/2026-08-04-go-compiler-deletion-design.md):
// stage 1 compiles the committed clarusc/clarusc.c snapshot with cc alone;
// stage 2 uses that binary to emit C for the CURRENT clarusc/*.cla source
// and cc-compiles the emission (crossgen's bootstrapCurrentClarusc shape,
// promoted to shared code).
//
// Harness tests use CurrentExe so they always exercise just-edited
// compiler source: the raw snapshot equals current source only after
// regeneration, and the freshness gate (TestSnapshotFixedPoint) lives in
// internal/selfhost, which T1 excludes. SnapshotExe exists solely for
// selfhost's generation-comparison tests (behavior/crossgen/fixed-point),
// whose semantics are specifically about the snapshot lineage.
//
// Artifacts land in <repo>/build-run/ (the directory scripts/clarus-run.sh
// already uses; distinct artifact names, so the two caches coexist), keyed
// on input mtimes+sizes in a stamp file, built under an exclusive flock so
// concurrently starting `go test` packages share one build, and renamed
// into place atomically. An unchanged tree pays zero rebuild cost.
package claruscboot

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"sort"
	"strings"
	"sync"
	"syscall"
	"testing"
)

// CCPath returns the C compiler to invoke for host builds: $CC if set,
// otherwise "cc". (Moved from the dissolved internal/build package.)
func CCPath() string {
	if c := os.Getenv("CC"); c != "" {
		return c
	}
	return "cc"
}

var (
	snapOnce sync.Once
	snapExe  string
	snapErr  error

	curOnce sync.Once
	curExe  string
	curErr  error
)

// SnapshotExe returns a clarusc built from the committed
// clarusc/clarusc.c snapshot (stage 1 only). Selfhost
// generation-comparison tests only; everything else wants CurrentExe.
func SnapshotExe(t *testing.T) string {
	t.Helper()
	requireCC(t)
	snapOnce.Do(func() { snapExe, snapErr = ensureSnapshot() })
	if snapErr != nil {
		t.Fatal(snapErr)
	}
	return snapExe
}

// CurrentExe returns a clarusc built from the CURRENT clarusc/*.cla
// source (stage 2: snapshot-built clarusc emits current source, cc
// compiles the emission).
func CurrentExe(t *testing.T) string {
	t.Helper()
	requireCC(t)
	curOnce.Do(func() { curExe, curErr = ensureCurrent() })
	if curErr != nil {
		t.Fatal(curErr)
	}
	return curExe
}

func requireCC(t *testing.T) {
	t.Helper()
	if _, err := exec.LookPath(CCPath()); err != nil {
		t.Skipf("%s not found on PATH, skipping clarusc bootstrap: %v", CCPath(), err)
	}
}

// repoRoot walks up from the CWD to the directory containing go.mod.
func repoRoot() (string, error) {
	dir, err := os.Getwd()
	if err != nil {
		return "", err
	}
	for {
		if _, err := os.Stat(filepath.Join(dir, "go.mod")); err == nil {
			return dir, nil
		}
		parent := filepath.Dir(dir)
		if parent == dir {
			return "", fmt.Errorf("claruscboot: go.mod not found above CWD")
		}
		dir = parent
	}
}

// snapshotInputs is every file stage 1 depends on: the committed snapshot
// plus the whole C runtime directory (rt.c #includes the .inc files).
func snapshotInputs(root string) ([]string, error) {
	inputs := []string{filepath.Join(root, "clarusc", "clarusc.c")}
	rtFiles, err := filepath.Glob(filepath.Join(root, "runtime", "host", "*"))
	if err != nil {
		return nil, err
	}
	return append(inputs, rtFiles...), nil
}

// currentInputs adds stage 2's inputs: every clarusc/*.cla and every
// runtime/clarus/*.cla (the emit of main.cla pulls runtime modules via
// --rtdir).
func currentInputs(root string) ([]string, error) {
	inputs, err := snapshotInputs(root)
	if err != nil {
		return nil, err
	}
	for _, pat := range []string{
		filepath.Join(root, "clarusc", "*.cla"),
		filepath.Join(root, "runtime", "clarus", "*.cla"),
	} {
		files, err := filepath.Glob(pat)
		if err != nil {
			return nil, err
		}
		inputs = append(inputs, files...)
	}
	return inputs, nil
}

// stampFor renders the cache key: a leading "cc <CCPath()>" line (so
// changing $CC invalidates the cache instead of silently reusing a binary
// built by a different compiler) followed by one "path mtime_ns size" line
// per input, sorted, so any content or set change misses the cache.
func stampFor(inputs []string) (string, error) {
	sorted := append([]string(nil), inputs...)
	sort.Strings(sorted)
	var b strings.Builder
	fmt.Fprintf(&b, "cc %s\n", CCPath())
	for _, p := range sorted {
		fi, err := os.Stat(p)
		if err != nil {
			return "", fmt.Errorf("claruscboot: stat input %s: %v", p, err)
		}
		fmt.Fprintf(&b, "%s %d %d\n", p, fi.ModTime().UnixNano(), fi.Size())
	}
	return b.String(), nil
}

// ensure builds build-run/<name> under an exclusive flock if its stamp is
// stale, writing the artifact via temp-file + atomic rename. buildFn gets
// the final artifact path to produce (it may write a temp next to it and
// rename, or write directly -- ensure renames only the stamp last, so a
// crashed build re-runs).
func ensure(name string, inputsFn func(root string) ([]string, error),
	buildFn func(root, exe string) error) (string, error) {
	root, err := repoRoot()
	if err != nil {
		return "", err
	}
	dir := filepath.Join(root, "build-run")
	if err := os.MkdirAll(dir, 0o755); err != nil {
		return "", err
	}

	lockPath := filepath.Join(dir, "claruscboot.lock")
	lock, err := os.OpenFile(lockPath, os.O_CREATE|os.O_RDWR, 0o644)
	if err != nil {
		return "", err
	}
	defer lock.Close()
	if err := syscall.Flock(int(lock.Fd()), syscall.LOCK_EX); err != nil {
		return "", fmt.Errorf("claruscboot: flock %s: %v", lockPath, err)
	}
	defer syscall.Flock(int(lock.Fd()), syscall.LOCK_UN)

	exe := filepath.Join(dir, name)
	stampPath := exe + ".stamp"
	inputs, err := inputsFn(root)
	if err != nil {
		return "", err
	}
	want, err := stampFor(inputs)
	if err != nil {
		return "", err
	}
	if have, err := os.ReadFile(stampPath); err == nil && string(have) == want {
		if _, err := os.Stat(exe); err == nil {
			return exe, nil
		}
	}

	tmp := exe + ".tmp"
	if err := buildFn(root, tmp); err != nil {
		os.Remove(tmp)
		return "", err
	}
	if err := os.Rename(tmp, exe); err != nil {
		return "", err
	}
	if err := os.WriteFile(stampPath, []byte(want), 0o644); err != nil {
		return "", err
	}
	return exe, nil
}

func ccSnapshot(root, outExe, cPath string) error {
	rtDir := filepath.Join(root, "runtime", "host")
	cmd := exec.Command(CCPath(), "-O1", "-I", rtDir, "-o", outExe,
		cPath, filepath.Join(rtDir, "rt.c"))
	if out, err := cmd.CombinedOutput(); err != nil {
		return fmt.Errorf("claruscboot: cc %s: %v\n%s", cPath, err, out)
	}
	return nil
}

func ensureSnapshot() (string, error) {
	return ensure("clarusc-snapshot", snapshotInputs, func(root, exe string) error {
		return ccSnapshot(root, exe, filepath.Join(root, "clarusc", "clarusc.c"))
	})
}

func ensureCurrent() (string, error) {
	snap, err := ensureSnapshot()
	if err != nil {
		return "", err
	}
	return ensure("clarusc-current", currentInputs, func(root, exe string) error {
		work, err := os.MkdirTemp("", "claruscboot-current-*")
		if err != nil {
			return err
		}
		defer os.RemoveAll(work)
		curC := filepath.Join(work, "cur.c")
		rtdir := filepath.Join(root, "runtime", "clarus") + string(filepath.Separator)
		emit := exec.Command(snap, "emit", "--rtdir", rtdir, "-o", curC,
			filepath.Join(root, "clarusc", "main.cla"))
		if out, err := emit.CombinedOutput(); err != nil {
			return fmt.Errorf("claruscboot: snapshot clarusc emit current source: %v\n%s", err, out)
		}
		return ccSnapshot(root, exe, curC)
	})
}
