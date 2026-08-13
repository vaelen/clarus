# Fallback-Trigger Narrowing Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** A user `include` of a bake-carried file no longer abandons the bake — the included copy is parsed for check#1 visibility only and dropped at lowering, with a per-module source hash scoping the from-source fallback to genuine drift.

**Architecture:** Mirror from-source's hoist-dedup semantics on the bake path: check the user's copy in user position, lower nothing (the baked IR already holds the module at runtime position) — byte-identity by construction. CLIR format v4→v5 adds per-module source hashes; collisions hash the disk file and fall back only on mismatch. Spec (normative, read first): `docs/superpowers/specs/2026-08-13-fallback-trigger-narrowing-design.md`.

**Tech Stack:** Clarus self-hosted compiler (`clarusc/*.cla`), host C runtime, Go test harness (`internal/bake`, `internal/mactest`), Mini vMac/Snow emulator lanes.

## Global Constraints

- Branch: `fallback-trigger-narrowing` (exists, created from main `b16e8f0`; spec committed at `9b25bcd`).
- MacRoman discipline: before every Edit to an existing `.cla`, verify target lines are pure ASCII (`sed -n 'X,Yp' FILE | LC_ALL=C grep -n '[^\x00-\x7f]'` empty), else `LC_ALL=C sed`; pre-commit `git diff | LC_ALL=C grep -c $'\xef\xbf\xbd'` must be 0. `drive.cla`, `check.cla`, `macgui.cla`, `cg68k.cla` contain MacRoman comment bytes.
- Byte-identity remains the oracle: `--rtbake` output ≡ from-source output byte-for-byte, full corpus, both lanes. Divergence = STOP-and-investigate, never re-bless. From-source output must be byte-untouched by this phase EXCEPT where the cg68k housekeeping removal (Task 4) proves zero-churn via goldens.
- T1 (`scripts/test-task.sh`) after every task; `--smoke` when `clarusc/` or `runtime/` change. Snapshot regen ONCE, in Task 4. Full T2 (`scripts/test-merge.sh`) in Task 4.
- Standing rule (ROADMAP): `bake.cla`/`macgui.cla` change ⇒ manual `CLARUS_SNOW_TESTS=1` run of `TestClarusCBakePathOnSnow` before merge (Task 4; ~55min settle harness, controller may run it).
- CLIR format version constant `bkFormatVersion` (bake.cla:60) bumps 4→5 exactly once (Task 2). Artifacts are never committed; no compat shim; loader refuses non-5 via the existing message path.
- Log each subagent's model at dispatch (standing request).
- Line numbers below verified at `b16e8f0` (only a docs commit sits on top); Task 1 re-verifies the load-bearing ones.

---

### Task 1: Probe wave — verify the two load-bearing assumptions

**Files:**
- Create: nothing committed; probes live in the SDD workspace. Report: `<workspace>/task-1-report.md`.
- Test: T1 green after probe revert proves the tree untouched.

**Interfaces:**
- Produces: PASS/FAIL per assumption with evidence; the drop-point decision for Task 2 (where in expand/lower the check-only subtree is severed); amendments to Tasks 2-3 if an assumption fails.

- [ ] **Step 1: Re-verify citations at HEAD.** Confirm: manifest-collision check in `driveExpandInclude`-family at drive.cla:848-852 (`if haveRtbake and bkManifestPaths.has(path) { bkManifestHoistHit = true ... }`); fallback consumption at drive.cla:1690-1705 (`log("clarusc --rtbake: user include collides..."` + `fallbackOk = driveCompile(entries, testapi)`); `bkComputeManifestPaths` at bake.cla:2623-2631; `bkFormatVersion = 4` at bake.cla:60; from-source hoist machinery `dedupHits`/`hoistDedups` at drive.cla:105-113, 946-960. Record drift.
- [ ] **Step 2: Checker-state parity probe.** Locally hack the collision branch to parse the colliding file anyway (skip the `bkManifestHoistHit` return; let the include proceed) and record the subtree's decl range (first/last decl index). Build via two-stage boot (`cc -O1 -I runtime/host -o build-run/clarusc clarusc/clarusc.c runtime/host/rt.c`, then `build-run/clarusc emit --rtdir runtime/clarus/ -o /tmp/s2.c clarusc/main.cla && cc -O1 -I runtime/host -o /tmp/c2 /tmp/s2.c runtime/host/rt.c`). Compile the toolbox suite composition (file list: `internal/mactest` grep for toolbox `gui.cla`; `--testapi`) and a minimal NON-testapi fixture that includes `toolbox/files.cla` and calls one of its externs. Question: does check#1 populate extern/type tables from the user-position copy such that user code calling those externs lowers identically to from-source? Compare the from-source build's emitted bytes for the same fixture (from-source handles this via hoist-dedup today).
- [ ] **Step 3: Exact-drop probe.** Extend the hack: after check#1, sever the recorded decl range before `lowerProgram` (find the mechanic — decl-chain surgery like `driveEarlySplice`'s `asmTails` idiom, or an AST-walk skip flag; REPORT which is cleaner, this becomes Task 2's design). Then `emit68k --rtbake` the non-testapi include fixture and byte-compare against from-source. Identical = both assumptions PASS. Divergent = characterize (stray IR? extern-arena entries? strLits?) and amend Task 2.
- [ ] **Step 4: testapi double-declare confirmation.** With the hack active and `--testapi`, confirm the preload + parsed-copy collision produces redeclaration diagnostics (expected), justifying the spec's full-dedup-under-testapi rule. Record the exact diagnostic for Task 3's parity test.
- [ ] **Step 5: Report, revert (`git checkout -- .`), T1 green.**

---

### Task 2: Mechanism — check-only include + drift guard + format v5

**Files:**
- Modify: `clarusc/bake.cla` (per-module source hashes in the manifest section, `bkFormatVersion` 5, disk-hash helper), `clarusc/drive.cla` (collision branch: hash-compare → check-only include or drift fallback; check-only subtree drop before lowering, per Task 1's chosen mechanic), `clarusc/main.cla` (only if flag plumbing needed — expected none).
- Test: `internal/bake/bake_test.go` (header sanity 4→5), new drift + collision cases in Task 3 (this task lands the mechanism with the existing corpus green).

**Interfaces:**
- Consumes: Task 1's drop-point decision and probe evidence.
- Produces: `bkManifestSourceHash(path) : int` lookup (baked per-module hash); collision behavior: hash-equal → check-only include (subtree checked, dropped at lowering), hash-differ → existing fallback with new log line `"clarusc --rtbake: <path> differs from the baked copy; falling back to a from-source compile"`; testapi + preloaded-visible + hash-equal → full dedup (no parse). `bkManifestHoistHit` renamed/retained ONLY for the drift case.

- [ ] **Step 1: Serializer: per-module hash.** In the `--bake-ir` manifest writer, alongside each module key write `bkHashText(moduleSource)` (4 bytes BE). Bump `bkFormatVersion` to 5. Update the loader's manifest reader to store hashes beside `bkManifestPaths` (e.g. parallel map `bkManifestHashes`).
- [ ] **Step 2: Collision branch rewrite** in drive.cla per Interfaces above. Read the disk file once (the include machinery already has the bytes — reuse, don't re-read), hash, compare.
- [ ] **Step 3: Check-only drop** per Task 1's mechanic; wire the drop between check#1 and the `lowerProgram` call on the bake path only.
- [ ] **Step 4: Gates.** `go test ./internal/bake/... -count=1` (update version constants in `bake_test.go`); `CLARUS_BAKE_FULL=1 go test ./internal/bake -run TestBakeFullCorpus -count=1` (existing corpus must stay green — the toolbox suite test still expects fallback until Task 3 flips it: NOTE the drift-hash of unmodified files matches, so the toolbox composition now takes the bake path and that test FAILS its wantFallback=true assertion — flip that assertion in THIS task if so, leaving the byte-identity flip to Task 3, and say so in the report); leak gate (`go test ./internal/mactest -run TestLeakGate -count=1`); `scripts/test-task.sh --smoke`.
- [ ] **Step 5: Commit** "feat: check-only include + per-module drift hash (fallback-trigger-narrowing Task 2)".

---

### Task 3: Oracles — toolbox flip, drift fixture, testapi parity

**Files:**
- Modify: `internal/bake/bakeidentity_test.go` (toolbox suite test → byte-identity + no-fallback; new `TestRtbakeIncludeCheckOnly` non-testapi fixture; new `TestRtbakeDriftFallback`; new `TestRtbakeTestapiIncludeParity`), fixtures under `testdata/` as needed (a minimal `.cla` including `toolbox/files.cla` and calling one extern).
- Test: this task IS tests.

**Interfaces:**
- Consumes: Task 2's behaviors; Task 1's recorded testapi redeclaration diagnostic.
- Produces: the full-corpus gate asserts bake-path-taken + byte-identity for collision compositions; drift and parity covered.

- [ ] **Step 1: Flip `TestBakeFullCorpusSuiteToolbox`** to the byte-identity + no-"falling back" shape of `TestBakeFullCorpusSuiteCore` (its own failure message has requested this since runtime-ir-bake Task 5).
- [ ] **Step 2: `TestRtbakeIncludeCheckOnly`:** non-testapi fixture including `toolbox/files.cla`, `emit68k --rtbake` vs from-source byte-compare + no-fallback assertion + a negative twin (fixture calling an extern NOT in the included file still errors identically both paths).
- [ ] **Step 3: `TestRtbakeDriftFallback`:** copy the rtdir to a temp dir, bake from it, append a comment byte to the temp `toolbox/files.cla`, compile the include fixture with `--rtbake` against the modified rtdir: assert the drifted-file log line fires and output equals a plain from-source compile of the same tree.
- [ ] **Step 4: `TestRtbakeTestapiIncludeParity`:** testapi program including a collided catalog file — identical diagnostics (or identical clean compile + bytes) both paths.
- [ ] **Step 5: Gates + commit** (`internal/bake` full incl. `CLARUS_BAKE_FULL=1`, T1) "test: collision/drift/parity oracles (fallback-trigger-narrowing Task 3)".

---

### Task 4: Housekeeping + close-out

**Files:**
- Modify: `clarusc/macgui.cla` (~485: fallback-reason string enumerates format/version/lane/stamp/body-hash; drift reason line if macgui surfaces it), `clarusc/cg68k.cla` (~6320-6410: remove the dead tight-to-tight scratch indirection `cgFillTightScratchFromPaddedArr`/`cgDrainTightScratchToPaddedArr` or rename honestly — goldens must show ZERO churn, any churn is stop-and-investigate), `clarusc/clarusc.c` (regen), `STATUS.md`, `docs/ROADMAP.md` (phase entry; debt ledger: mark the fallback-narrowing item resolved, keep stamp-proxy-global open).
- Test: full gates.

- [ ] **Step 1: macgui string + cg68k cleanup** (separate commits fine). Goldens check for the cg68k change: `go test ./internal/cg68k/... ./internal/emitui/... -count=1` — zero churn expected.
- [ ] **Step 2: Snapshot regen to fixed point** (cc → emit → cc → emit → cmp); `go test ./internal/selfhost -count=1 -timeout 30m` green.
- [ ] **Step 3: Docs:** ROADMAP phase entry (template: runtime-ir-bake's), STATUS.md close-out, debt-ledger updates.
- [ ] **Step 4: Full T2** (`scripts/test-merge.sh`, foreground, output to file) at tip. Then the Snow standing rule: `CLARUS_SNOW_TESTS=1 CLARUS_MACRESIDENT_SETTLE=55m go test ./internal/mactest -run TestClarusCBakePathOnSnow -count=1 -timeout 90m` (controller may run this; ~1h wall).
- [ ] **Step 5: Final commit.**

---

## Verification summary

| Oracle | Task | Proves |
|---|---|---|
| Probe report | 1 | assumptions verified before code |
| Full corpus + toolbox flip | 2-3 | collision compositions take the bake, byte-identical |
| Drift fixture | 3 | fallback scoped to genuine drift, logged |
| testapi parity | 3 | visibility semantics preserved |
| Zero golden churn on cg68k cleanup | 4 | housekeeping is behavior-free |
| T2 + Snow rerun | 4 | merge-readiness + Mac default path proof |
