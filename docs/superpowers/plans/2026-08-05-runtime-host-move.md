# Runtime-Host Move Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Move the host C runtime from `internal/build/rt/` to `runtime/host/`, dissolve `internal/build` (C tests → new `internal/hostrt`, `CCPath` → `claruscboot`, embeds → disk reads), and update every path reference.

**Architecture:** `runtime/` becomes the complete runtime tree: `clarus/` (Clarus modules), `mac/` (Mac C shims), `host/` (host C runtime). Go shrinks to harnesses only: `internal/build` is deleted; its four C-runtime test harnesses become `internal/hostrt`; `CCPath()` moves to `internal/claruscboot`; `internal/selfhost`'s hermetic snapshot compile copies rt sources from disk instead of `//go:embed` (embed cannot reach outside its package dir, so the move forces this anyway).

**Tech Stack:** git mv, Go test harnesses, shell scripts, `LC_ALL=C sed` for MacRoman `.cla` comment edits.

**Decided by Andrew (2026-08-05):** package name `internal/hostrt`; NO emulator/gated tests needed for verification (pure path move — the native lane compiles the same bytes from a new directory; T1 + selfhost cover it).

## Global Constraints

- Feature branch `runtime-host-move`; merge only on request.
- `.cla` and MacRoman-adjacent files (`clarusc/main.cla`, `runtime/clarus/*.cla`, `testdata/**/*.cla`, `testsuite/**/*.cla`) are edited ONLY with `LC_ALL=C sed -i ''` — never the Edit tool — and verified by `git diff` showing only the intended lines (MacRoman corruption rule, see repo memory).
- The emitted C, the snapshot, and all goldens must be byte-unaffected: `clarusc/clarusc.c` untouched; comment-only `.cla` edits (comments never reach emission — `TestSnapshotFixedPoint` stays green without regeneration).
- Verification = `scripts/test-task.sh` + `go test ./internal/selfhost -count=1 -timeout 30m`. No `CLARUS_MAC_TESTS` runs.
- End-state grep: `grep -rn "internal/build" --include='*.go' .` → zero; repo-wide non-historical references (scripts, CLAUDE.md, README, CMakeLists, live comments) → zero. `docs/ROADMAP.md` + `docs/superpowers/**` historical text stays untouched.

---

### Task 1: The move — rt → runtime/host, internal/build dissolved

**Files:**
- Move: `internal/build/rt/*` (11 files) → `runtime/host/`
- Move: `internal/build/{rtsmoke,memtest_c,rctest_c,sertest_c}_test.go` → `internal/hostrt/` (package `hostrt`)
- Delete: `internal/build/cc.go`, `internal/build/embed.go`, `internal/build/runtime.go` (then the empty dir)
- Modify: `internal/claruscboot/claruscboot.go` (gains `CCPath`; own rt paths)
- Modify: every Go file matching `grep -rln 'internal/build' --include='*.go'` (path strings + imports)
- Modify: `internal/selfhost/snapshot_test.go` (`compileCDir`: embeds → disk copies)

**Interfaces:**
- Produces: `claruscboot.CCPath() string` — the $CC lookup, moved verbatim from `internal/build/cc.go`:

```go
// CCPath returns the C compiler to invoke for host builds: $CC if set,
// otherwise "cc". (Moved from the dissolved internal/build package.)
func CCPath() string {
	if c := os.Getenv("CC"); c != "" {
		return c
	}
	return "cc"
}
```

- [ ] **Step 1: Branch + git mv**

```bash
git checkout -b runtime-host-move
git mv internal/build/rt runtime/host
mkdir -p internal/hostrt
git mv internal/build/rtsmoke_test.go internal/build/memtest_c_test.go \
       internal/build/rctest_c_test.go internal/build/sertest_c_test.go internal/hostrt/
```

- [ ] **Step 2: internal/hostrt package fixes**

In the four moved files: `package build` → `package hostrt`; read each file's path construction first — they located rt sources relative to the old package dir (e.g. `rt/rt.c` or via repo-root helpers) and must now resolve `<repo-root>/runtime/host/...` (the package dir is `internal/hostrt`, so a relative form is `../../runtime/host`); `rtsmoke_test.go`'s `func cc() string { return CCPath() }` → `return claruscboot.CCPath()` (import `clarus/internal/claruscboot`); any other bare `CCPath()` uses likewise.

- [ ] **Step 3: claruscboot changes**

Add `CCPath` (code above) to `claruscboot.go`; replace its own `build.CCPath()` calls with `CCPath()`; drop the `clarus/internal/build` import; update its rt path constructions (`"internal", "build", "rt"` → `"runtime", "host"`) in `snapshotInputs`, `ccSnapshot`, and anywhere else.

- [ ] **Step 4: selfhost's hermetic compile reads from disk**

In `snapshot_test.go`, `compileCDir` currently writes the seven embedded `build.Runtime*` byte-slices into its temp dir. Replace with: copy every non-`*_test.c` file from `<repo-root>/runtime/host/` into the temp dir (read the current function first; preserve its behavior — same temp-dir hermetic compile, same cc invocation, same error reporting). Drop the `clarus/internal/build` import.

- [ ] **Step 5: sweep the remaining Go references**

`grep -rln 'internal/build' --include='*.go' .` and fix every hit: `-I` path strings and `filepath.Join(..., "internal", "build", "rt")` → `runtime/host`; `build.CCPath()` → `claruscboot.CCPath()` (import already present in those files via the buildClarusc shims — verify per file); comment mentions of `internal/build/rt` → `runtime/host`. Then delete `internal/build/cc.go`, `embed.go`, `runtime.go` (`git rm`) — the directory must be gone.

- [ ] **Step 6: Build + test**

Run: `go build ./... && go vet ./... && gofmt -l internal/ | grep -v lowlevel_test; go test ./internal/hostrt ./internal/claruscboot -count=1`
Expected: clean builds; hostrt's four C harnesses + claruscboot PASS (cache rebuilds once — stamp paths changed).
Run: `go test ./internal/selfhost -count=1 -timeout 30m`
Expected: PASS (fixed point green WITHOUT snapshot regen — nothing but paths moved).
Run: `scripts/test-task.sh` — expected FAIL or PASS? The scripts still point at the old path, but T1 only invokes `go test`; expected PASS. (Scripts are Task 2.)

- [ ] **Step 7: Commit**

```bash
git add -A
git commit -m "refactor: move host C runtime to runtime/host; dissolve internal/build (hostrt tests, claruscboot.CCPath, disk-read rt sources)"
```

---

### Task 2: Scripts, docs, and comment pointers

**Files:**
- Modify: `scripts/clarus-run.sh` (lines ~9, 32-33, 43), `scripts/build-mac.sh` (~46-47, 250), `scripts/build-68k.sh` (~46-47)
- Modify: `internal/mactest/uiprobe/CMakeLists.txt` (line 4)
- Modify: `README.md` (~line 60 bootstrap one-liner), `CLAUDE.md` (bootstrap one-liner, clarus-run description, testsuite compose recipe, any other `internal/build/rt` mention)
- Modify (sed only): comment pointers in `clarusc/main.cla` (~705), `runtime/clarus/{core,ser,str,text,list,map,ui}.cla`, `runtime/mac/{rt_ext_mac.inc,rt_mac.c,rt_ui.c,rt_ui.h}`, `testdata/lowlevel/{callback_host,externdedup}.cla`, `testdata/run/lib/arc_global_alias.cla`, `testsuite/core/cases_xrec.cla`
- Modify: `docs/ROADMAP.md` — ONE new Done line recording the move (runtime/host + hostrt + claruscboot.CCPath); historical text untouched

- [ ] **Step 1: Scripts + CMakeLists**

Replace every `internal/build/rt` with `runtime/host` (path segments in `-I`, link lines, and prose comments). No other script logic changes.

- [ ] **Step 2: README + CLAUDE.md**

Same substitution; read each surrounding sentence and keep it true (e.g. CLAUDE.md's "on-disk host runtime (`internal/build/rt`)" → `runtime/host`).

- [ ] **Step 3: .cla / MacRoman-adjacent comment pointers**

For each file in the sed list: `LC_ALL=C sed -i '' 's|internal/build/rt|runtime/host|g' FILE`, then `git diff FILE` and confirm ONLY the intended comment lines changed (byte-level: no other hunks). These are comments; emission is unaffected.

- [ ] **Step 4: ROADMAP Done line**

One bullet appended to the Go-compiler-deletion Done entry (or adjacent): host C runtime moved `internal/build/rt` → `runtime/host`; `internal/build` dissolved (C tests → `internal/hostrt`, `CCPath` → `claruscboot`, selfhost reads rt from disk), 2026-08-05.

- [ ] **Step 5: End-state greps + full verification**

```bash
grep -rn "internal/build" --include='*.go' .                              # zero
grep -rn "internal/build" scripts/ CLAUDE.md README.md internal/ runtime/ testdata/ testsuite/ clarusc/  # zero
scripts/clarus-run.sh testdata/run/enums.cla                              # runs, exit 0
scripts/test-task.sh                                                      # PASS
go test ./internal/selfhost -count=1 -timeout 30m                         # PASS
```

(`docs/` hits are historical and expected; do not edit them beyond Step 4's addition.)

- [ ] **Step 6: Commit**

```bash
git add -A
git commit -m "refactor: repoint scripts/docs/comments at runtime/host"
```

---

## Self-review notes

- Embed constraint is the forcing function for Step 4 of Task 1 (`//go:embed` cannot reference `../../runtime/host`); disk copies preserve the hermetic compile.
- No snapshot regen: `.cla` edits are comment-only; `clarusc/clarusc.c` untouched; fixed point proves it in Task 1 Step 6.
- Emulated lanes deliberately NOT run (Andrew, 2026-08-05): the native/Retro68 lanes consume the same C bytes via the updated `-I`/CMake paths; T1 + selfhost + the clarus-run smoke cover the moved plumbing.
