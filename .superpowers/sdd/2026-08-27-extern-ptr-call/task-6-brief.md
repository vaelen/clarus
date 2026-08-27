### Task 6: Snapshot regen, gates, close-out

**Files:**
- Modify: `clarusc/clarusc.c` (regenerated snapshot), `CLAUDE.md` (CoreTest count 79→80 sentence), `docs/STATUS.md`, `docs/ROADMAP.md`, `docs/HISTORY.md`, `docs/TODO.md`
- Ledger: `.superpowers/sdd/2026-08-27-extern-ptr-call/progress.md` (never delete)

- [ ] **Step 1: Regenerate the bootstrap snapshot**

clarusc's own source changed (parse/check/cg68k/cprint), so the committed `clarusc/clarusc.c` is stale. Run `go test -count=1 -timeout 30m -run TestSnapshotFixedPoint ./internal/selfhost`; if it fails it prints the Go-free regeneration instructions — follow them, re-run, expect PASS.

- [ ] **Step 2: Full gates**

```sh
scripts/test-task.sh --smoke     # T1 + emulator smokes
scripts/test-merge.sh            # T2: selfhost + native mactest lane
```

Expected: all green. T2 failures stop the phase — fix before any close-out edit.

- [ ] **Step 3: Close-out docs**

- `CLAUDE.md`: update the core-suite sentence — 80 `CoreTest` cases (79 real + `SelfCheck`), grown by the extern-ptr-call phase's `PtrCall` case; add `= ptr` to the binary-files/filesystem-api-style one-line phase note if the file's pattern calls for it.
- `docs/STATUS.md` §0 handoff rewritten; `docs/ROADMAP.md` phase marked complete; completed-phase entry appended verbatim to `docs/HISTORY.md`; any deferred follow-ups (named-target `= ptr(name)` form, register-convention targets — both recorded in the spec's out-of-scope) into `docs/TODO.md`.

- [ ] **Step 4: Commit**

```sh
git add clarusc/clarusc.c CLAUDE.md docs/STATUS.md docs/ROADMAP.md docs/HISTORY.md docs/TODO.md .superpowers/sdd/2026-08-27-extern-ptr-call/
git commit -m "docs: extern-ptr-call close-out (snapshot regen, STATUS, ROADMAP, HISTORY, TODO, CLAUDE.md)"
```

Merge to main only on explicit request.
