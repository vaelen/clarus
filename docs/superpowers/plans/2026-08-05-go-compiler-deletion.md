# Go Compiler Deletion Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Swap every remaining frozen-Go-compiler consumer onto the snapshot-bootstrapped clarusc pipeline, then delete `cmd/clarus` + the Go frontend/IR/printer packages + the Go differential lanes.

**Architecture:** Stage 1 introduces `internal/claruscboot` (shared, disk-cached, flock-serialized Go-free clarusc builds) and swaps seven consumers + three duplicated bootstrap helpers onto it, verified by a final full T2 with `CLARUS_GO_DIFF=1`, tagged `go-compiler-final`. Stage 2 deletes the Go compiler and its gate machinery, rehomes the few shared selfhost helpers, and updates docs.

**Tech Stack:** Go test harnesses, `cc`, the committed `clarusc/clarusc.c` snapshot, `internal/build/rt`.

**Spec:** `docs/superpowers/specs/2026-08-04-go-compiler-deletion-design.md`

## Global Constraints

- Work on feature branch `go-deletion` (created in Task 1). Merge only on request.
- NO changes to `clarusc/*.cla` compiler sources or `clarusc/clarusc.c` anywhere in this plan.
- Permanent keepers, never touched by deletions: `internal/build/rt/` (whole dir), `internal/build/cc.go` (`CCPath` — used by the rt C tests, lowlevel, sertest, asm68k after this plan), `clarusc/clarusc.c`, all harness packages.
- All test commands run from the repo root with `-count=1`. `internal/selfhost` always gets `-timeout 30m`.
- `go test` harness code style: mirror the existing helpers you're replacing (memoization comments, skip-not-fail on missing tools).
- Harness tests use `claruscboot.CurrentExe` (tests must exercise just-edited `clarusc/*.cla` — the snapshot-freshness gate lives in `internal/selfhost`, which T1 excludes). `SnapshotExe` is ONLY for selfhost's generation-comparison tests.
- T1 = `scripts/test-task.sh`; T2 = `scripts/test-merge.sh`. Tasks below say which to run.

---

### Task 1: Feature branch + `internal/claruscboot`

**Files:**
- Create: `internal/claruscboot/claruscboot.go`
- Create: `internal/claruscboot/claruscboot_test.go`

**Interfaces:**
- Produces: `claruscboot.SnapshotExe(t *testing.T) string` and `claruscboot.CurrentExe(t *testing.T) string` — every later task consumes these. Both skip (not fail) when `cc` is missing; both memoize per-process and cache on disk under `<repo>/build-run/`.

- [ ] **Step 1: Create the branch**

```bash
git checkout -b go-deletion
```

- [ ] **Step 2: Write the failing test**

`internal/claruscboot/claruscboot_test.go`:

```go
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
```

- [ ] **Step 3: Run test to verify it fails**

Run: `go test ./internal/claruscboot -count=1`
Expected: FAIL (compile error — `CurrentExe`, `repoRoot`, `ensureCurrent` undefined)

- [ ] **Step 4: Write the implementation**

`internal/claruscboot/claruscboot.go`:

```go
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

	"clarus/internal/build"
)

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
	if _, err := exec.LookPath(build.CCPath()); err != nil {
		t.Skipf("%s not found on PATH, skipping clarusc bootstrap: %v", build.CCPath(), err)
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
	rtFiles, err := filepath.Glob(filepath.Join(root, "internal", "build", "rt", "*"))
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

// stampFor renders the cache key: one "path mtime_ns size" line per input,
// sorted, so any content or set change misses the cache.
func stampFor(inputs []string) (string, error) {
	sorted := append([]string(nil), inputs...)
	sort.Strings(sorted)
	var b strings.Builder
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
	rtDir := filepath.Join(root, "internal", "build", "rt")
	cmd := exec.Command(build.CCPath(), "-O1", "-I", rtDir, "-o", outExe,
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
```

Note the nested-flock subtlety: `ensureCurrent` calls `ensureSnapshot` BEFORE its own `ensure`, so the two flock acquisitions are sequential, never nested — no deadlock. (`syscall.Flock` on the same fd path from the same process would be re-entrant anyway on darwin/linux, but sequential is simpler to reason about.)

- [ ] **Step 5: Run the tests**

Run: `go test ./internal/claruscboot -count=1 -v`
Expected: both tests PASS (first run pays one snapshot `cc` + one emit + one current `cc`; `build-run/clarusc-snapshot`, `build-run/clarusc-current` + `.stamp` files appear). Run it a second time — expected near-instant PASS (warm cache).

- [ ] **Step 6: Sanity-check no interference with `scripts/clarus-run.sh`**

Run: `scripts/clarus-run.sh testdata/valid/bookmarks.cla 2>/dev/null || true; ls build-run/`
Expected: clarus-run.sh's own artifacts and claruscboot's coexist (distinct names).

- [ ] **Step 7: Commit**

```bash
git add internal/claruscboot
git commit -m "feat(claruscboot): shared Go-free clarusc bootstrap for test harnesses"
```

---

### Task 2: Swap emitui, cg68k, lowlevel, sertest, perfgate

**Files:**
- Modify: `internal/emitui/emitui_test.go` (buildClarusc ~lines 50-95)
- Modify: `internal/cg68k/golden_test.go` (buildClarusc ~lines 38-85)
- Modify: `internal/lowlevel/lowlevel_test.go` (diagError ~line 50, buildClarusc ~line 62)
- Modify: `internal/sertest/sertest_test.go` (buildClarusc ~line 49, diagError ~line 75)
- Modify: `internal/perfgate/perfgate_test.go` (buildClarusc ~line 52)

**Interfaces:**
- Consumes: `claruscboot.CurrentExe(t *testing.T) string` (Task 1).
- Produces: each package keeps its local `buildClarusc(t *testing.T) string` name as a one-line shim, so zero call sites change (`cg68k` alone has 3+ callers across 4 test files; `sertest`'s `clrdcompare_test.go` calls it too).

- [ ] **Step 1: emitui — replace the builder with a shim**

In `internal/emitui/emitui_test.go`: delete the `claruscOnce/claruscExe/claruscErr` var block, the old `buildClarusc` body, and the `diagError` type. Replace with:

```go
// buildClarusc returns the current-source clarusc via the shared Go-free
// bootstrap (Go-compiler-deletion phase; was build.Build on
// clarusc/main.cla). Kept as a local name so fixture call sites are
// untouched.
func buildClarusc(t *testing.T) string {
	t.Helper()
	return claruscboot.CurrentExe(t)
}
```

Remove the now-unused imports: `clarus/internal/build`, `clarus/internal/source`, `sync`, and `strings` if nothing else uses them (check each — `strings` is used elsewhere in some of these files; the compiler will tell you). Add `clarus/internal/claruscboot`.

- [ ] **Step 2: Run emitui tests**

Run: `go test ./internal/emitui -count=1`
Expected: PASS (byte-identical goldens — the current-source clarusc must emit exactly what the Go-built clarusc emitted; any diff here is a real finding, stop and report it)

- [ ] **Step 3: cg68k — same shim**

Same recipe in `internal/cg68k/golden_test.go`: delete var block + old `buildClarusc` + `diagError`, add the same 5-line shim (same comment), fix imports (drop `build`, `source`, `sync` if unused; add `claruscboot`).

Run: `go test ./internal/cg68k -count=1`
Expected: PASS

- [ ] **Step 4: lowlevel — same shim**

Same recipe in `internal/lowlevel/lowlevel_test.go` (its `diagError` sits ~line 50, builder ~line 62). Keep its `build.CCPath()` usage at ~line 153 — the `build` import STAYS here.

Run: `go test ./internal/lowlevel -count=1`
Expected: PASS

- [ ] **Step 5: sertest — same shim**

Same recipe in `internal/sertest/sertest_test.go`. Keep `build.CCPath()` usages (sertest_test.go ~line 117, clrdcompare_test.go ~line 71) — the `build` import STAYS in both files that use it. `clrdcompare_test.go` needs no edit beyond its file-header comment if it mentions `build.Build` (it does, lines 9 and 33 — update the wording to "the shared Go-free bootstrap (claruscboot)" while preserving the "do not 'fix' this back" warning's intent).

Run: `go test ./internal/sertest -count=1`
Expected: PASS

- [ ] **Step 6: perfgate — same shim**

In `internal/perfgate/perfgate_test.go`: delete its `claruscOnce/claruscExe/claruscErr/claruscSkip` vars, `buildClarusc` body, and `errString` type; add the same shim (it was already snapshot-based; moving to `CurrentExe` follows the spec's uniformity rule — the tripwire should time CURRENT emit code). Update the file-header comment (~line 8) that says it deliberately avoids `build.Build` — now it deliberately uses `claruscboot.CurrentExe`. No baseline change: the 2x-margin tripwire times `clarusc emit`, not the bootstrap, and build time is excluded from the timed section.

Run: `go test ./internal/perfgate -count=1`
Expected: PASS (well under 2x baseline)

- [ ] **Step 7: Commit**

```bash
git add internal/emitui internal/cg68k internal/lowlevel internal/sertest internal/perfgate
git commit -m "refactor(test): emitui/cg68k/lowlevel/sertest/perfgate build clarusc via claruscboot"
```

---

### Task 3: Swap asm68k and reftest

**Files:**
- Modify: `internal/asm68k/vasm_test.go` (~lines 114-125, the `build.Build` fixture build; file-header comment ~line 105)
- Modify: `internal/reftest/reftest_test.go` (`TestCheckCleanFences`, ~lines 21-44)

**Interfaces:**
- Consumes: `claruscboot.CurrentExe(t)` (Task 1); `build.CCPath()` (surviving `internal/build/cc.go`).

- [ ] **Step 1: asm68k — build exercise.cla via emit+cc**

In `TestVasmRoundTrip`, replace:

```go
	exe := filepath.Join(runDir, "exercise")
	diags, err := build.Build([]string{filepath.Join(root, "internal", "asm68k", "exercise.cla")}, exe)
	if err != nil || len(diags) > 0 {
		t.Fatalf("build exercise.cla: err=%v diags=%v", err, diags)
	}
```

with:

```go
	exe := filepath.Join(runDir, "exercise")
	clarusc := claruscboot.CurrentExe(t)
	exerC := filepath.Join(runDir, "exercise.c")
	rtdir := filepath.Join(root, "runtime", "clarus") + string(filepath.Separator)
	emit := exec.Command(clarusc, "emit", "--rtdir", rtdir, "-o", exerC,
		filepath.Join(root, "internal", "asm68k", "exercise.cla"))
	if out, err := emit.CombinedOutput(); err != nil {
		t.Fatalf("clarusc emit exercise.cla: %v\n%s", err, out)
	}
	rtInc := filepath.Join(root, "internal", "build", "rt")
	ccCmd := exec.Command(build.CCPath(), "-O1", "-I", rtInc, "-o", exe,
		exerC, filepath.Join(rtInc, "rt.c"))
	if out, err := ccCmd.CombinedOutput(); err != nil {
		t.Fatalf("cc exercise.c: %v\n%s", err, out)
	}
```

Keep the `build` import (`CCPath`), add `claruscboot`. Update the TestVasmRoundTrip doc comment's "with the frozen Go compiler" wording to "with the current-source clarusc (claruscboot)".

- [ ] **Step 2: Run asm68k**

Run: `go test ./internal/asm68k -count=1`
Expected: PASS (or SKIP if the local vasm binary is absent — the clarusc-side change still compiles; if skipped, note it in the report)

- [ ] **Step 3: reftest — check fences via subprocess**

Replace `TestCheckCleanFences`'s loop body's check:

```go
		diags, err := driver.Check([]string{p})
		if err != nil {
			t.Fatal(err)
		}
		if len(diags) != 0 {
			t.Errorf("fence %d (md line %d): %v", idx, fences[idx].Line, diags[0])
		}
```

with (hoist `exe := claruscboot.CurrentExe(t)` above the loop):

```go
		out, err := exec.Command(exe, p).CombinedOutput()
		if err != nil || len(bytes.TrimSpace(out)) != 0 {
			t.Errorf("fence %d (md line %d): clarusc check not clean (err=%v):\n%s",
				idx, fences[idx].Line, err, out)
		}
```

Drop the `clarus/internal/driver` import; add `bytes`, `os/exec`, `clarus/internal/claruscboot`. Update the test's doc comment ("must pass `clarus check`" → "must check clean under clarusc"). clarusc's default (no-subcommand) mode checks and prints diagnostics, exiting non-zero when any exist — the differential suite proved its diagnostics equivalent to the Go checker's, so exit-0-and-silent is the same assertion `len(diags) == 0` was.

- [ ] **Step 4: Run reftest**

Run: `go test ./internal/reftest -count=1`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add internal/asm68k internal/reftest
git commit -m "refactor(test): asm68k fixture + reftest fence-check go through claruscboot"
```

---

### Task 4: Swap mactest (native lane + host-oracle consolidation)

**Files:**
- Modify: `internal/mactest/native_test.go` (`buildNativeClarusc` ~lines 39-70 and its doc comments ~lines 9-12, ~line 236)
- Modify: `internal/mactest/suite_host_test.go` (`bootstrapSnapshotClarusc` ~lines 15-65 + its callers in this file and `native_test.go`)

**Interfaces:**
- Consumes: `claruscboot.CurrentExe(t)`.
- Produces: `hostOracleClarusc(t *testing.T) string` in suite_host_test.go (renamed from `bootstrapSnapshotClarusc` — it no longer builds from the raw snapshot); `buildNativeClarusc(t *testing.T) string` kept as a shim name in native_test.go.

- [ ] **Step 1: native_test.go — shim buildNativeClarusc**

Delete its memoization vars and `build.Build` body; replace with:

```go
// buildNativeClarusc returns the current-source clarusc used to emit68k
// every native-lane build (Go-compiler-deletion phase; was build.Build).
func buildNativeClarusc(t *testing.T) string {
	t.Helper()
	return claruscboot.CurrentExe(t)
}
```

Fix imports (drop `clarus/internal/build` if `CCPath` is unused in this file — check; add `claruscboot`). Update the ~line 9-12 and ~line 236 comments that describe the Go-toolchain build.

- [ ] **Step 2: suite_host_test.go — consolidate the host oracle**

Delete the `snapshotClarusc*` var block and `bootstrapSnapshotClarusc`'s body; replace with:

```go
// hostOracleClarusc returns the compiler the HOST-oracle builds use.
// Formerly bootstrapSnapshotClarusc (raw committed snapshot); now the
// shared current-source bootstrap, so host oracles exercise just-edited
// compiler code even when the snapshot is stale (spec: mactest host
// oracles mirror build-mac.sh's pipeline shape but exist to test current
// code).
func hostOracleClarusc(t *testing.T) string {
	t.Helper()
	return claruscboot.CurrentExe(t)
}
```

Rename every caller (`buildHostFromFixtures` here, plus any in `native_test.go` — grep `bootstrapSnapshotClarusc` within `internal/mactest/`). Fix imports.

- [ ] **Step 3: Run the ungated mactest tests + the T1-visible consumer**

Run: `go test ./internal/mactest ./internal/testsuite -count=1`
Expected: PASS (`internal/testsuite`'s core-CLI host build goes through `BuildCoreCLIHost` → `hostOracleClarusc`)

- [ ] **Step 4: Run the gated native smoke pair**

Run: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestSmokeBounceOn68k|TestRealEventLoopTickOn68k' -count=1 -timeout 20m`
Expected: PASS (2 emulator boots; needs the Retro68 toolchain + Mini vMac per CLAUDE.md — if absent, STOP and report, don't mark the task done on a skip)

- [ ] **Step 5: Commit**

```bash
git add internal/mactest
git commit -m "refactor(test): mactest native + host-oracle clarusc builds via claruscboot"
```

---

### Task 5: Swap selfhost onto claruscboot

**Files:**
- Modify: `internal/selfhost/behavior_test.go` (`bootstrapSnapshotClarusc` ~lines 60-100)
- Modify: `internal/selfhost/crossgen_test.go` (`bootstrapCurrentClarusc` ~lines 44-87 + callers)
- Modify: `internal/selfhost/gogate_test.go` (`TestSnapshotFixedPoint`'s two bootstrap calls, ~lines 48-49, 68)

**Interfaces:**
- Consumes: `claruscboot.SnapshotExe(t)` AND `claruscboot.CurrentExe(t)` — this is the ONE package that uses `SnapshotExe` (generation-comparison semantics).
- Produces: `bootstrapSnapshotClarusc(t) string` kept as a shim; `bootstrapCurrentClarusc` shrinks to `(t *testing.T) string` (drops the `snapExe, root` params).

- [ ] **Step 1: behavior_test.go — shim the snapshot bootstrap**

Delete the memoization vars and body; replace with:

```go
// bootstrapSnapshotClarusc returns the snapshot-lineage clarusc (stage 1
// of the shared bootstrap). Behavior goldens and the crossgen/fixed-point
// comparisons are ABOUT the snapshot lineage, so this is deliberately NOT
// CurrentExe -- the one place in the tree that wants SnapshotExe.
func bootstrapSnapshotClarusc(t *testing.T) string {
	t.Helper()
	return claruscboot.SnapshotExe(t)
}
```

- [ ] **Step 2: crossgen_test.go — shim the current bootstrap**

Delete `currentClarusc*` vars and the old body; replace with:

```go
// bootstrapCurrentClarusc returns current-source clarusc (generation N+1,
// built BY the snapshot generation) via the shared bootstrap.
func bootstrapCurrentClarusc(t *testing.T) string {
	t.Helper()
	return claruscboot.CurrentExe(t)
}
```

Update its two callers to the new signature: `TestCrossGenDifferential` (~line 96: `curExe := bootstrapCurrentClarusc(t)`) and `TestSnapshotFixedPoint` in gogate_test.go (~line 68: `curExe := bootstrapCurrentClarusc(t)`). Fix imports in all three files (drop `sync`/`fmt`/`os/exec` where now unused; add `claruscboot`).

- [ ] **Step 3: Run the default (Go-free) selfhost lanes**

Run: `go test ./internal/selfhost -count=1 -timeout 30m`
Expected: PASS (behavior goldens, crossgen, snapshot builds, fixed point; Go lanes SKIP)

- [ ] **Step 4: Run the Go-diff lanes too (both worlds still alive)**

Run: `CLARUS_GO_DIFF=1 go test ./internal/selfhost -count=1 -timeout 30m`
Expected: PASS (differential/bootstrap/coverage lanes still green against the untouched Go compiler)

- [ ] **Step 5: Commit**

```bash
git add internal/selfhost
git commit -m "refactor(test): selfhost generation builds via claruscboot"
```

---

### Task 6: Stage-1 gate — final parachute T2 + tag

**Files:** none (verification + tag only)

- [ ] **Step 1: Confirm zero remaining build.Build/driver.Check consumers outside the deletion set**

Run: `grep -rn "build\.Build\|driver\.Check" --include='*.go' internal cmd | grep -v '^internal/selfhost/' | grep -v '^internal/build/' | grep -v '^cmd/clarus/' | grep -v '^internal/driver/'`
Expected: no output. (Remaining hits live only in files Stage 2 deletes.)

- [ ] **Step 2: Run the full T2 with the Go lanes reinstated**

Run (background; ~40 min — test-merge.sh already exports `CLARUS_GO_DIFF=1`): `scripts/test-merge.sh`
Expected: PASS end-to-end — the final run in history where the Go compiler and the swapped harnesses are both alive and agree.

- [ ] **Step 3: Tag the last Go-compiler commit**

```bash
git tag go-compiler-final
```

(Lightweight tag on the stage-1 HEAD, per Andrew's 2026-08-04 decision. Do NOT push; pushing happens with the eventual merge, on request.)

---

### Task 7: Delete selfhost's Go lanes, rehome shared helpers

**Files:**
- Delete: `internal/selfhost/differential_test.go`, `driver_test.go`, `emit_test.go`, `bootstrap_test.go`, `coverage_test.go`
- Modify: `internal/selfhost/snapshot_test.go` (delete `TestSnapshotCurrent`; rehome `compileC`/`compileCDir`/`runClarusc`; re-oracle `TestSnapshotBuilds`)
- Rename+Modify: `internal/selfhost/gogate_test.go` → `internal/selfhost/fixedpoint_test.go` (delete `requireGoCompiler`; rehome `emitC`/`emitCDir`/`diffFirstDivergence`; Go-free regen message)

**Interfaces:**
- Consumes: `claruscboot.CurrentExe(t)` (new oracle for `TestSnapshotBuilds`).
- Produces: surviving helpers, now homed as follows — `compileC`, `compileCDir`, `runClarusc` in snapshot_test.go; `emitC`, `emitCDir`, `diffFirstDivergence` in fixedpoint_test.go. (`runBehaviorFixture`/`behaviorBlob`/`runnableFixtures`/`repoRootBehavior` already live in behavior_test.go — untouched.)

- [ ] **Step 1: Rehome the helpers the keepers use**

Before deleting files, move these functions VERBATIM (cut+paste, keep doc comments):
- `compileCDir` (emit_test.go:56) and `compileC` (emit_test.go:94) → snapshot_test.go
- `runClarusc` (differential_test.go:76) → snapshot_test.go
- `emitCDir` (emit_test.go:23) and `emitC` (emit_test.go:42) → gogate_test.go
- `diffFirstDivergence` (bootstrap_test.go:16) → gogate_test.go

Do NOT move `goCheck` (differential_test.go:54) or `selfBuiltClaruscC` (emit_test.go:262) — they die with their files.

- [ ] **Step 2: Delete the Go-lane files**

```bash
git rm internal/selfhost/differential_test.go internal/selfhost/driver_test.go \
       internal/selfhost/emit_test.go internal/selfhost/bootstrap_test.go \
       internal/selfhost/coverage_test.go
```

- [ ] **Step 3: Re-oracle TestSnapshotBuilds**

In snapshot_test.go, delete `TestSnapshotCurrent` entirely, and change `TestSnapshotBuilds`'s oracle from `goCheck` to the current-source clarusc:

```go
// TestSnapshotBuilds proves the committed clarusc/clarusc.c ALONE reproduces
// a working clarusc: compile it (as committed, not a fresh emission) with cc
// + rt.c, then run the resulting binary as a checker over a small sample of
// the corpus and assert its stdout + exit code match the current-source
// clarusc exactly (whose own correctness the behavior goldens and crossgen
// differential pin). No Go compiler and no prior Clarus binary are used.
func TestSnapshotBuilds(t *testing.T) {
	snapshot := readSnapshot(t)
	bin := compileC(t, snapshot)
	curExe := claruscboot.CurrentExe(t)

	files := []string{
		"../../testdata/diag/chk_undefined.cla",
		"../../testdata/diag/chk_typemismatch.cla",
		"../../testdata/valid/bookmarks.cla",
	}
	for _, f := range files {
		f := f
		t.Run(f, func(t *testing.T) {
			wantOut, wantCode := runClarusc(t, curExe, f)
			gotOut, gotCode := runClarusc(t, bin, f)
			if gotOut != wantOut || gotCode != wantCode {
				t.Errorf("divergence on %s\n  current-source    (exit %d): %q\n  snapshot-built cc (exit %d): %q",
					f, wantCode, wantOut, gotCode, gotOut)
			}
		})
	}
}
```

- [ ] **Step 4: fixedpoint_test.go — degate and fix the regen recipe**

`git mv internal/selfhost/gogate_test.go internal/selfhost/fixedpoint_test.go`. In it: delete `requireGoCompiler`; rewrite the file-header comment (it's no longer a gate file — it is the snapshot fixed-point + freshness oracle); replace BOTH occurrences of the stale regen instructions (the `TestSnapshotFixedPoint` failure message here — the other copy died with `TestSnapshotCurrent`) with the Go-free recipe:

```
The committed snapshot must always match what clarusc currently emits for
its own source. To regenerate it (Go-free, from the old snapshot):

  cc -O1 -I internal/build/rt -o /tmp/boot clarusc/clarusc.c internal/build/rt/rt.c
  /tmp/boot emit --rtdir runtime/clarus/ -o /tmp/cur.c clarusc/main.cla
  cc -O1 -I internal/build/rt -o /tmp/cur /tmp/cur.c internal/build/rt/rt.c
  /tmp/cur emit --rtdir runtime/clarus/ -o clarusc/clarusc.c clarusc/main.cla

Then commit the updated clarusc/clarusc.c.
```

(Four lines, not two: the regenerated snapshot must be the CURRENT compiler's emission of itself, so you must build the current compiler first — emitting with the old snapshot-built binary would just reproduce the stale snapshot.)

- [ ] **Step 5: Run selfhost**

Run: `go test ./internal/selfhost -count=1 -timeout 30m`
Expected: PASS, and `-v` shows NO skipped Go-lane tests remain in this package (grep the output for "CLARUS_GO_DIFF": zero hits)

- [ ] **Step 6: Commit**

```bash
git add internal/selfhost
git commit -m "refactor(selfhost): delete Go differential/bootstrap lanes; Go-free snapshot oracles remain"
```

---

### Task 8: Delete the Go compiler

**Files:**
- Delete (whole dirs): `cmd/clarus/`, `internal/lexer/`, `internal/parser/`, `internal/check/`, `internal/types/`, `internal/lower/`, `internal/cprint/`, `internal/driver/`, `internal/ir/`, `internal/ast/`, `internal/token/`, `internal/source/`
- Delete: `internal/build/build.go`, `embed.go`, `runtime.go`, `build_test.go`, `golden_test.go`, `unsupported_test.go`, `gate_test.go`
- Keep: `internal/build/cc.go`, the four rt C-test files (`rtsmoke_test.go`, `memtest_c_test.go`, `rctest_c_test.go`, `sertest_c_test.go`), `internal/build/rt/` (everything)
- Modify: `scripts/test-merge.sh` (drop the `CLARUS_GO_DIFF=1` export + its comment paragraph)
- Modify: `go.mod` via `go mod tidy` (no-op expected; run it anyway)

- [ ] **Step 1: Delete**

```bash
git rm -r cmd/clarus internal/lexer internal/parser internal/check internal/types \
          internal/lower internal/cprint internal/driver internal/ir internal/ast \
          internal/token internal/source
git rm internal/build/build.go internal/build/embed.go internal/build/runtime.go \
       internal/build/build_test.go internal/build/golden_test.go \
       internal/build/unsupported_test.go internal/build/gate_test.go
```

Before running the second `git rm`, confirm `internal/build/runtime.go` has no surviving consumer: `grep -rn "build\.Runtime\|runtime\.go's" --include='*.go' internal/` (expected: nothing outside the deleted files; if something surfaces, keep the used symbol and report).

- [ ] **Step 2: Update internal/build's package doc**

`cc.go`'s package comment says the package "will host the `clarus build`/`clarus run` pipeline" — false since forever, now doubly so. Replace with:

```go
// Package build is the home of the shared C runtime (rt/) and the C
// compiler lookup its tests and other packages' harnesses use. The Go
// compiler that used to live here was deleted in the Go-compiler-deletion
// phase (tag go-compiler-final marks its last commit).
package build
```

- [ ] **Step 3: test-merge.sh — drop the Go-diff export**

Remove the `export CLARUS_GO_DIFF=1` line and its whole explanatory comment paragraph (the block starting "# CLARUS_GO_DIFF=1 (test-suite-review Task 6):").

- [ ] **Step 4: Check for orphaned testdata**

The deleted `internal/build/golden_test.go` compared against committed goldens. Find its fixture dir(s): `grep -o 'testdata/[a-z0-9_]*' <(git show HEAD:internal/build/golden_test.go) | sort -u`, then for each dir check for remaining references: `grep -rn "testdata/<name>" --include='*.go' internal/ scripts/`. `git rm -r` only dirs with ZERO remaining references, and list what was removed in the task report. Do NOT touch `testdata/run`, `testdata/runerr`, `testdata/valid`, `testdata/diag`, `testdata/ui`, `testdata/uisnaps`, `testdata/emitui`, `testdata/cg68k` (all have surviving consumers).

- [ ] **Step 5: Build + tidy + T1**

Run: `go build ./... && go vet ./... && go mod tidy && git diff --exit-code go.mod`
Expected: clean (module has no external deps to drop)

Run: `scripts/test-task.sh`
Expected: PASS (~T1 wall-clock; note the number — the spec asks for a warm-cache timing sanity check vs. the pre-phase T1)

- [ ] **Step 6: Commit**

```bash
git add -A
git commit -m "feat!: delete the frozen Go compiler (cmd/clarus + frontend/IR/printer packages)

The self-hosted clarusc (bootstrapped from the committed clarusc/clarusc.c
snapshot) is now the only compiler. Tag go-compiler-final marks the last
commit where the Go compiler was alive."
```

---

### Task 9: Docs — CLAUDE.md, ROADMAP, script comments

**Files:**
- Modify: `CLAUDE.md`
- Modify: `docs/ROADMAP.md`
- Modify: `scripts/clarus-run.sh` (line 11's comment referencing "CLAUDE.md's CLARUS_GO_DIFF")
- Modify: `scripts/test-task.sh` (header comment: the "--smoke" paragraph is fine; check the body comment for stale Go-compiler mentions)

- [ ] **Step 1: CLAUDE.md**

Precise edits (preserve everything not listed):
- "Build and test" opening block: delete the `go build -o clarus ./cmd/clarus` line; `scripts/clarus-run.sh` is now the first entry.
- T1 bullet: delete everything from "T1 no longer builds or links the Go compiler" through "...keep running unconditionally" and replace with one sentence: "The Go compiler was deleted in the Go-compiler-deletion phase (tag `go-compiler-final`); the gauntlet is all-harness, no compiler-unit packages remain."
- T2 bullet: drop "run with `CLARUS_GO_DIFF=1` so the Go lanes below are included".
- Delete the entire `### CLARUS_GO_DIFF` section including the "**Caveat: the default gauntlet is NOT fully Go-free.**" block.
- Replace the "The Go compiler (`cmd/clarus`, `internal/`) is FROZEN..." bullet with: "The Go compiler is DELETED (tag `go-compiler-final`). clarusc (`clarusc/*.cla`) is the only compiler; new language features land in the reference + clarusc."
- Replace the `TestSnapshotCurrent` bullet with: "`clarusc/clarusc.c` is the committed bootstrap snapshot. If `TestSnapshotFixedPoint` (`internal/selfhost`) fails, it prints the Go-free regeneration instructions." Keep the `cc` bootstrap one-liner that follows.

- [ ] **Step 2: ROADMAP.md**

- Add a Done entry for this phase (follow the existing Done-item style): swap of the seven consumers (note the seventh, `internal/reftest`, found during design), `internal/claruscboot` (CurrentExe/SnapshotExe + disk cache), final parachute T2, tag `go-compiler-final`, deletion inventory, T1/T2 both green after.
- In the test-suite-review section's "Six `build.Build` call sites" escalation block (~line 1245): mark it resolved by this phase (one line, keep the historical text).
- Item 1's "demote-now-delete-deliberately" paragraph (~line 976): append "(deletion executed 2026-08-05, see the Go-compiler-deletion phase entry)".

- [ ] **Step 3: Script comments**

`scripts/clarus-run.sh` line 11: the comment "-- see CLAUDE.md's CLARUS_GO_DIFF" → "-- the Go compiler is deleted; clarusc is the only compiler". Check `scripts/test-task.sh`'s header for stale Go-compiler wording and fix in the same spirit.

- [ ] **Step 4: Verify docs contain no stale references**

Run: `grep -rn "CLARUS_GO_DIFF\|cmd/clarus\|build\.Build" CLAUDE.md scripts/`
Expected: zero hits.
Run: `grep -rn "go run ./cmd/clarus" --include='*.go' internal/`
Expected: zero hits (Task 7 fixed the regen messages).

- [ ] **Step 5: Commit**

```bash
git add CLAUDE.md docs/ROADMAP.md scripts/
git commit -m "docs: Go-compiler-deletion phase wrap (CLAUDE.md, ROADMAP, script comments)"
```

---

### Task 10: Final gate — Go-free T2 + grep gates

**Files:** none (verification only)

- [ ] **Step 1: Grep gates**

```bash
grep -rn 'clarus/internal/\(lexer\|parser\|check\|types\|lower\|cprint\|driver\|ir\|ast\|token\|source\)' --include='*.go' . ; \
grep -rn 'CLARUS_GO_DIFF' --include='*.go' --include='*.sh' . ; \
grep -rn 'build\.Build\b' --include='*.go' .
```
Expected: every command returns nothing (exit 1). Historical mentions in `docs/` and `.superpowers/` are fine and excluded by the filters above.

- [ ] **Step 2: Full T2, Go-free**

Run (background; ~30-40 min): `scripts/test-merge.sh`
Expected: PASS end-to-end — first fully Go-free merge gate. Record the wall-clock in the task report next to the pre-phase 2428s rehearsal number.

- [ ] **Step 3: Confirm the scripts still work**

Run: `scripts/clarus-run.sh testdata/valid/bookmarks.cla -- >/dev/null; echo "clarus-run OK $?"`
Expected: exit 0 (they never used Go; this is belt-and-braces).

- [ ] **Step 4: Report**

Branch `go-deletion` complete: do NOT merge — per project convention, merging to main happens only on Andrew's request (superpowers:finishing-a-development-branch).

---

## Self-review notes (spec → plan coverage)

- Spec Component 1 (`claruscboot`, CurrentExe semantics, cache, flock, skip-on-no-cc) → Task 1.
- Spec Component 2 (seven swaps + three consolidations) → Tasks 2-5 (sites 2-6 + perfgate in Task 2; site 2's fixture build + site 7 in Task 3; site 1 + mactest consolidation in Task 4; selfhost consolidation in Task 5).
- Spec Component 3 (deletion inventory; cc.go survives — its `CCPath` has surviving consumers) → Tasks 7-8.
- Spec Component 4 (docs, Go-free regen recipe) → Task 7 Step 4 (in-test messages) + Task 9 (CLAUDE.md/ROADMAP/scripts).
- Spec sequencing (parachute T2 + tag between stages; timing sanity check) → Task 6; Task 8 Step 5 + Task 10 Step 2 record timings.
- Out-of-scope list respected: no `clarusc run` subcommand, no `clarusc/*.cla` edits, no UI-golden-lane changes.
