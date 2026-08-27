# Task 6 report: snapshot regen, gates, close-out

## Summary

Regenerated the stale bootstrap snapshot, ran full T1/T2, found and
fixed a real `internal/reftest` gate break introduced by Task 5's
reference doc edit (not a compiler defect), re-ran gates green, and
closed out all five standing docs (CLAUDE.md, STATUS.md, ROADMAP.md,
HISTORY.md, TODO.md).

## Step 1: Snapshot regen

`go test -count=1 -timeout 30m -run TestSnapshotFixedPoint
./internal/selfhost` FAILed first: committed `clarusc/clarusc.c`
(4923665 bytes) != fresh emission (4938191 bytes), first divergence at
line 539 (new string literals for the `deref`/`ptr` contextual
keywords). Followed the printed Go-free regen recipe verbatim:

```sh
cc -O1 -I runtime/host -o /tmp/boot clarusc/clarusc.c runtime/host/rt.c
/tmp/boot emit --rtdir runtime/clarus/ -o /tmp/cur.c clarusc/main.cla
cc -O1 -I runtime/host -o /tmp/cur /tmp/cur.c runtime/host/rt.c
/tmp/cur emit --rtdir runtime/clarus/ -o clarusc/clarusc.c clarusc/main.cla
```

Re-run: `ok clarus/internal/selfhost 13.111s` — PASS ("snapshot fixed
point reached"). Re-verified at the very end of the task (after all doc
edits, which don't touch `clarusc/*.cla`): `ok clarus/internal/selfhost
1.343s` — still PASS, no second regen needed.

## Step 2: Full gates

### First T1 run: RED (pre-existing doc bug surfaced by Task 5)

`scripts/test-task.sh --smoke` failed in `internal/reftest`:

```
--- FAIL: TestCheckCleanFences (0.09s)
    fence 85 (md line 1872): clarusc check not clean (err=exit status 1):
    fence.cla:6:1: expected declaration, found identifier
--- FAIL: TestRequiredProgramsInManifest (0.00s)
    required program "Appendix C bookmark manager" (index 87) not in CheckClean
    required program "Appendix C text editor" (index 88) not in CheckClean
```

Root cause: Task 5's reference edit added a new "The `ptr` Clause"
subsection with two new fenced code blocks. The closing worked example
(originally: `HLock(h)` / `var code: ptr = HandleToPtr(h)` / `var
result: int = PluginMain(code, 1, pb)` as bare top-level statements)
had two independent problems:

1. Bare statements at top level — only declarations (`record`/`enum`/
   `const`/`var`/`func`/`window`/`menu`/`extend`/`on`/`every`) are legal
   at Clarus top level; a call statement or `var` outside a function
   body is a parse error.
2. `pb` was referenced with no declaration anywhere in the fence.

Fixed by wrapping the example in a function:

```rust
func callPlugin(h: ptr, pb: ptr): int {
    var code: ptr
    HLock(h)                            // pin it: it can't move or be purged while code runs
    code = HandleToPtr(h)               // master pointer -> the code's own address
    return PluginMain(code, 1, pb)
}
```

Note `var code: ptr` is declared (uninitialized) BEFORE the `HLock`/
assignment/`return` statements — Clarus requires every local var
declaration at the top of a function body before any statement
(verified: initially wrote `HLock(h)` then `var code: ptr =
HandleToPtr(h)`, which failed with `variable declarations must appear
at the top of the body`). Mirrored the identical fix into
`docs/clarus-toolbox-cookbook.md`'s own copy of the same example (§13,
not gate-checked but kept consistent — this doc's example was flagged
as a "minor deferred" cleanup in Task 5's own ledger entry for the
undeclared `pb`).

This changed the fence extraction: the new "= ptr" declaration fence
(index 84, line 1854) and the fixed closing-example fence (index 85,
line 1872) both now check clean standalone (verified individually with
the current-source-built compiler), shifting every fence at or after
the old "word extern type" fence (old index 84) by +2: word extern type
84→86, Appendix C bookmark manager 85→87, Appendix C text editor
86→88. Updated `internal/reftest/manifest.go`'s `CheckClean` list (added
84, 85; renumbered 85/86→87/88) and its header comment block
documenting the shift, following the file's existing convention (each
prior insertion — binary-files' Task 10 — documented the same way).
Full re-verification: ran the current-source compiler in check mode
over ALL 89 extracted fences and confirmed the OK/FAIL classification
matches `CheckClean` exactly (same excluded-fragment set as before,
plus the two new OK entries).

`go test -count=1 ./internal/reftest/...` → `ok` after the fix.

### T1 (green, final)

```
scripts/test-task.sh --smoke
```
`test-task.sh: PASS in 28s (smoke=1)` (all 13 packages `ok`, including
`internal/reftest`). Re-confirmed once more after all doc edits: `PASS
in 35s` (no code changed in between, doc-only edits don't affect this
gate).

### T2 (green)

```
scripts/test-merge.sh
```
Ran in the foreground (via a backgrounded shell that was then waited on
in the foreground, per controller correction — the harness's
notification for a subagent's own `run_in_background` call is not
reliable, so the run was reconciled by polling the log file directly in
a foreground call until `T2_EXIT=` appeared).

```
test-merge.sh: T1 body PASS in 18s
ok  	clarus/internal/selfhost	133.174s
test-merge.sh: internal/selfhost PASS in 133s
ok  	clarus/internal/mactest	187.254s
test-merge.sh: internal/mactest (gated, native lane; cprint-Mac lane opt-in via CLARUS_CPRINT_MAC_TESTS=1) PASS in 187s
ok  	clarus/internal/bake	6.648s
test-merge.sh: internal/bake full-corpus gate (CLARUS_BAKE_FULL=1) PASS in 7s
test-merge.sh: PASS in 345s
T2_EXIT=0
```

345s total (T1 body 18s + selfhost 133s + native mactest lane 187s +
bake full-corpus 7s). No `TestClarusCBakePathOnSnow` — not part of T2,
and this phase has no runtime-module changes that would need it (no new
native globals, `fileh_68k.cla`/`prelude.cla` untouched).

## Step 3: Close-out docs

- **`CLAUDE.md`**: core-suite sentence updated 79→80 cases (78→79 real +
  `SelfCheck`), with a new clause crediting the extern-ptr-call phase's
  `PtrCall` case (word- and bool-returning round trips). Also corrected
  a pre-existing stale "77 other cases" reference in the
  `SelfCheck`-alone-always-FAILs paragraph to 79 (was already wrong
  before this phase — `nCoreCases - 1` should have been 78 pre-phase,
  not 77 — now correct at 79 post-phase). Added one tight sentence to
  the binary-files/filesystem-api-style phase-note paragraph crediting
  `= ptr` (right after the filesystem-api sentence, before "See the
  reference for the full method lists").
- **`STATUS.md`** (repo root, not `docs/` — the brief's path was
  approximate; verified this is the actual location referenced by
  `docs/ROADMAP.md`'s own `STATUS.md` cross-references): fully rewritten
  §0 (and the whole file) as the extern-ptr-call phase's session
  handoff, following filesystem-api's own STATUS.md structure exactly
  (title/handoff paragraph, §0 START HERE with pre-merge obligations —
  none owed this phase, unlike filesystem-api's Snow gap — the fence-fix
  writeup, per-task build summary, deferred follow-ups, §1 gate results,
  §2 prior-phases recap).
- **`docs/ROADMAP.md`**: new "Where we are" paragraph for
  `extern-ptr-call`, appended immediately after the filesystem-api
  paragraph, same style/detail level, ending with the standard "NOT YET
  merged (merge only on Andrew's request)" wording.
- **`docs/HISTORY.md`**: new phase entry appended right before the "##
  Resolved 'Small open items'" heading (immediately after
  filesystem-api's own entry, in the same "Native 68k toolchain (Plan
  5)" section every recent phase entry lives under) — one top-level
  bullet plus six task sub-bullets (parser/checker, host lane, native
  lane, core suite, docs, close-out), matching the filesystem-api
  entry's own level of per-task detail.
- **`docs/TODO.md`**: new "### extern-ptr-call phase (2026-08-27)"
  subsection under "## Language features (candidates)", placed after
  filesystem-api's own subsection (chronological order — my first
  attempt placed it before Serial/connection by mistake and was
  corrected). Two items: named-target `= ptr(name)` form,
  register-convention `= ptr` targets — both cited as the design spec's
  own out-of-scope section, not re-litigated.

## Self-review

- Snapshot fixed-point PASSES, confirmed twice (once right after regen,
  once at the very end after all doc edits — clean, since docs don't
  touch `clarusc/*.cla`).
- T1 and T2 both green at the FINAL tree: no code (`.go`/`.cla`) or
  snapshot file changed after the last full green run of each — the
  `internal/reftest/manifest.go` and reference/cookbook doc fix were
  made and gate-verified BEFORE the final T1/T2 confirmation runs, and
  nothing code-shaped changed afterward (only the five prose-only
  close-out docs, which no gate reads).
- Doc conventions followed: CLAUDE.md's per-phase one-liner pattern,
  STATUS.md's filesystem-api-shaped session-handoff structure,
  ROADMAP.md's "Where we are" paragraph-per-phase pattern (verified the
  top "Updated 2026-08-15" date is deliberately NOT bumped per phase —
  confirmed via `git log -p` that prior phases left it alone too),
  HISTORY.md's bullet-plus-sub-bullets phase-entry pattern, TODO.md's
  dated-subsection-under-category pattern.
- Counts consistent everywhere: 80 = 79 real + `SelfCheck` in CLAUDE.md,
  STATUS.md, HISTORY.md (cross-checked against the ground truth,
  `testsuite/core/runner.cla`'s `const nCoreCases: int = 80`).

## Concerns / notes for Andrew

- The reference/cookbook fence fix and the `internal/reftest/
  manifest.go` update were NOT in the brief's "Modify" file list, but
  were necessary to get T1 green — Task 5's own doc example had a real
  bug (not just the "minor deferred" `pb`-undeclared note in its ledger
  entry; the top-level-statement shape was a second, more fundamental
  problem that only surfaced as a hard gate failure once the manifest
  was checked). Included in this task's commit since it's inseparable
  from getting the gates green.
- Per STATUS.md's own recap: `filesystem-api`'s System 7 (Snow)
  verification remains UNVERIFIED and is still owed before ANY of this
  stacked local-main work (binary-files/transfer-crcs/filesystem-api/
  extern-ptr-call) gets pushed to origin — not this phase's job to
  resolve, just flagging it stays open underneath this branch.
- No goldens reblessed this phase (confirmed: `git status` shows no
  `testdata/emitui/*.c.golden` or `testdata/cg68k/*.s` changes), no new
  native globals (confirmed against Task 3/5's own reports and STATUS.md
  facts given).

## Final-review fix wave

Final whole-branch review returned READY WITH FIXES. All six fixes
applied, one commit, all gates re-run green.

### Fix 1 (load-bearing): host cast must be CLAR_PASCAL

`fpCallExt`'s conv-10 call rendering (cprint.cla) now emits
`((CLAR_PASCAL RET (*)(PARAMS))(target))(args)` instead of a plain
C-convention cast. Wrinkle handled: `cpEmitCallbackGlueProtos`'s
`#define CLAR_PASCAL` early-returned when `irCbGlueNeededCount() == 0`,
which would leave the macro undefined for a callback-free `= ptr`
program. Added `cpAnyPtrCallExtern()` (scans `irExternCount()`/
`irExternConv` for conv 10) and changed the guard to
`if irCbGlueNeededCount() == 0 and not cpAnyPtrCallExtern() { return }`
— simpler than a second `#ifndef`-guarded emission site since the
macro is a top-level `#define`, cheap to check for unconditionally, and
harmless if unused.

Proof (no-callback path): built `/tmp/boot` from the (still-unregenerated
at that point) committed snapshot, emitted+compiled `clarusc/main.cla`
against it to get `/tmp/cur` (current source, Fix 1+2 applied), then fed
it a throwaway `/private/tmp/claude-501/.../scratchpad/ptrcall_nocb.cla`
— a `= ptr` extern called through a plain `ptr` variable, ZERO
`callback func` in the program. Emitted C, `cc -fsyntax-only -I
runtime/host` clean. The emitted cast line:

```c
cv_r = ((CLAR_PASCAL int32_t (*)(void *))(cv_target))(cv_scratch);
```

with `#define CLAR_PASCAL pascal` / `#define CLAR_PASCAL` (host) both
present in the output despite no callback anywhere in the program —
confirms the macro-emission fix.

### Fix 2: cg68k.cla doc-block split

Split the fused doc block (cg68k.cla, was ~10277-10341 sitting entirely
above `cgPushPascalArgs`, with `cgCallExtPascal` doc-less below it).
`cgPushPascalArgs` now keeps: its own function-purpose paragraph (with
"arg node `a`" corrected to "`a0`", the real parameter name), the
bool/char high-byte-push REVISED paragraph, and the word-param
declared-type paragraph. `cgCallExtPascal` gets its own new doc block:
the top-level PASCAL-rule overview, the bool-RETURN pop paragraph plus
the word-RESULT sign-extension sentence, and the "trap dispatcher pops
its own args, no post-trap ADDA/ADDQ" paragraph — now with an explicit
exception noting `cgCallExtPtr` (conv 10) DOES emit a post-call
`ADDQ.L #4,A7` (verified against `cgCallExtPtr`'s own step 6,
`a68Emit(OpAddq, 4, AmImm, 0, 4, AmAn, 7, 0)`) to discard its saved
call target — unlike a trap dispatcher's own glue, a JSR through a
saved target pops nothing on its own. Blank line preserved between the
two blocks (comment-only change, no `.c` emission diff expected from
this fix alone).

### Fix 3: void-return / zero-remaining-param native arm

Confirmed via `docs/clarus-language-reference.md`'s own `callback func`
section (`myAction` example has no return type) that a void-return
callback is legal — no BLOCKED needed. Added `external func
PtrCallVoid(entry: ptr, out: ptr) = ptr` and `callback func
pcStamp(out: ptr) { pokel(out, 4242) }` to
`testsuite/core/cases_ptrcall.cla`; `casePtrCall` now also calls
`PtrCallVoid(pcStamp, scratch)` and asserts `peekl(scratch) == 4242`
with its own `tkFail` detail. Case count unchanged (80 total = 79 real
+ SelfCheck) — same case, more checks.

### Fix 4: wording — dropped the "strictly conforming" overclaim

`testdata/lowlevel/ptrcall_host.cla`'s header comment and the spec
(`docs/superpowers/specs/2026-08-27-extern-ptr-call-design.md`, Host
lane section) both reworded: "strictly conforming C function-pointer
call" / "no undefined behavior" replaced with "the cast signature
matches the glue's actual C signature" (the load-bearing property) plus
"well-defined on every platform this compiler targets (the void*/
function-pointer round trip is POSIX-guaranteed, not strictly
conforming ISO C)". The spec's example cast line and surrounding prose
also updated to show `CLAR_PASCAL` (Fix 1) and explain why.

### Fix 5: scratch-leak hygiene

`cases_ptrcall.cla`: every early `tkFail` return in `casePtrCall` now
calls `DisposePtr(scratch)` before returning — previously every failure
path skipped it (only the final `tkPass` path disposed). Uniform now
across all 6 return paths.

### Fix 6: TODO.md line

Added one line to the extern-ptr-call deferred section: converge the
three byte-identical extern-index scans (`irExternLookup` ir.cla:1036,
`cgExternIdxByName` cg68k.cla, `fpExternIdxByName` cprint.cla) onto
`irExternLookup`; pure deletion, deferred because it forces snapshot
regen + T2 for zero behavior change.

## Gate evidence (final tree, after all six fixes)

1. **Snapshot regen** — `TestSnapshotFixedPoint` FAILed as expected
   after Fix 1/2 changed `clarusc/*.cla` (committed snapshot 4938191
   bytes != fresh emission 4938697 bytes, first divergence exactly at
   the new `"((CLAR_PASCAL "` literal). Regenerated via the printed
   Go-free recipe (`/tmp/boot` from old snapshot -> emit main.cla ->
   `/tmp/cur` -> emit main.cla -> `clarusc/clarusc.c`). Re-run:
   ```
   ok  	clarus/internal/selfhost	12.902s
   ```
   PASS.

2. **`scripts/test-task.sh --smoke`**:
   ```
   ok  	clarus/internal/mactest	24.702s
   ...
   ok  	clarus/internal/mactest	10.383s
   test-task.sh: PASS in 36s (smoke=1)
   ```
   PASS.

3. **`CLARUS_MAC_TESTS=1 go test -count=1 -run TestCoreSuiteGUIOn68k
   ./internal/mactest`**:
   ```
   --- PASS: TestCoreSuiteGUIOn68k (3.95s)
   PASS
   ```
   `checkCoreSuiteCapture` requires all `wantCoreSuiteCases` (80) PASS
   lines + matching TOTAL line — confirmed via host-lane `core_cli all`
   run first (`TOTAL 80 PASS 80 FAIL 0`, PtrCall included) before the
   native boot. PASS, PtrCall green with the grown case.

4. **Fix-1 proof lane**: `CLARUS_CPRINT_MAC_TESTS=1 CLARUS_MAC_TESTS=1
   go test -count=1 -run TestCoreSuiteGUIOnMac -timeout 20m
   ./internal/mactest` — **FAILED**, but proven NOT conv-10-related:
   the Retro68/cmake build broke compiling `runtime/mac/rt_ext_mac.inc`
   (a file this fix wave never touched — `git diff --stat -- runtime/
   mac/rt_ext_mac.inc` is empty), root cause a pre-existing `*/` inside
   a `/* ... */` block comment ("Matching the ConnH*/PB* forward-
   proofing precedent...") that closes the comment early, from commit
   `ae662a3` (binary-files phase, 2026-08-22 — five days before this
   phase even started). Confirmed the actually-relevant emitted C
   (`build-mac/coresuite_gui_mac/coresuite_gui_mac.c`, generated before
   the separate `rt_mac.c` compile failed) is fully correct, CLAR_PASCAL
   and all, including the new void-return case:
   ```
   1545:#define CLAR_PASCAL pascal
   1547:#define CLAR_PASCAL
   19435: cv_r = ((CLAR_PASCAL short (*)(short, uint8_t, void *, int32_t))(((void*)&clar_cb_pcMixed)))(7, 1, cv_scratch, 21);
   19461: cv_b = ((CLAR_PASCAL uint8_t (*)(int32_t))(((void*)&clar_cb_pcIsPositive)))(5);
   19471: ((CLAR_PASCAL void (*)(void *))(((void*)&clar_cb_pcStamp)))(cv_scratch);
   19743:static CLAR_PASCAL void clar_cb_pcStamp(void * cv_out) { clar_fn_pcStamp(cv_out); }
   ```
   Per the brief's own contingency instruction, reporting
   DONE_WITH_CONCERNS for this one gate rather than fixing the unrelated
   pre-existing bug (out of this fix wave's scope) or claiming false
   PASS.

5. **`scripts/test-merge.sh`** (full T2, run AFTER Fix 1-6 were all in
   place and the snapshot was regenerated):
   ```
   test-merge.sh: T1 body PASS in 18s
   ok  	clarus/internal/selfhost	131.909s
   test-merge.sh: internal/selfhost PASS in 132s
   ok  	clarus/internal/mactest	188.971s
   test-merge.sh: internal/mactest (gated, native lane; cprint-Mac lane opt-in via CLARUS_CPRINT_MAC_TESTS=1) PASS in 189s
   ok  	clarus/internal/bake	6.701s
   test-merge.sh: internal/bake full-corpus gate (CLARUS_BAKE_FULL=1) PASS in 7s
   test-merge.sh: PASS in 346s
   ```
   PASS. (Note: T2 by design does NOT run the cprint-Mac lane — the
   demoted diagnostic from gate 4 above stays outside T2's own scope,
   consistent with CLAUDE.md's documented gate composition.)

No goldens reblessed. No `testdata/emitui/*.c.golden` or
`testdata/cg68k/*.s` diffs (unrelated to this fix wave's files, and
`git status` confirms no such paths touched).
