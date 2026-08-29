# 68k Call-Result Release Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fix the emit68k leak where a +1-owning handle result (user-function call or `IUiGetTextviewText`) consumed directly — as argument, operand, or receiver — is never released.

**Architecture:** Producer-side tracking: the two untracked +1-in-D0 producers (`cgCallFnScalar`, `IUiGetTextviewText`) register their result via the existing `cgNewTrackedTmp`/`cgLastTrackedOff` machinery, exactly like intrinsic birth sites (`cgIntrTextConcat`, `cgIntrListFirstLast`) already do. Existing consumers do the rest: `SAssign`/`SReturn` hand off via their `cgLastTrackedOff` checks; every other context is released by the end-of-statement flush `cgFreeStmtTmps`, abort paths included.

**Tech Stack:** Clarus self-hosted compiler (`clarusc/cg68k.cla`), Go test harness (`internal/cg68k`, `internal/mactest`), Clarus toolbox test suite (`testsuite/toolbox`).

**Spec:** `docs/superpowers/specs/2026-08-29-68k-call-result-release-design.md` (read it first). Evidence record: `../68kbbs/docs/memory-leak.md`.

## Global Constraints

- Host lane untouched: no `cprint.cla`, `lower.cla`, `ir.cla`, or `runtime/` changes. Host output must stay byte-identical.
- After every task touching `clarusc/`: `scripts/test-task.sh --smoke` must pass (T1 + the two native emulator smoke tests).
- All `go test` runs use `-count=1` (the scripts already do).
- cg68k listing goldens: `CLARUS_CG68K_BLESS=1 go test ./internal/cg68k -count=1` regenerates `testdata/cg68k/*.s`; every rebless must come with a reviewed diff (each new instruction sequence must be a store-to-temp + later `rtTextRelease`-family call, nothing else).
- Before using the Edit tool on any `.cla` file, check for MacRoman high-bit bytes: `LC_ALL=C grep -c $'[\x80-\xff]' FILE`. If nonzero, use `LC_ALL=C sed` byte-level edits instead (Edit corrupts MacRoman).
- Do not merge to main; the branch is `68k-call-result-release`.
- Subagent models: Task 1 `opus`; Tasks 2–5 `sonnet`.

---

### Task 1: Probe wave — verify the design's five assumptions (report only, no code)

**Files:**
- Create: `.superpowers/sdd/2026-08-29-68k-call-result-release/task-1-report.md`
- Read: `clarusc/cg68k.cla` (all sites below), `clarusc/cprint.cla` (host parity), `clarusc/lower.cla` (`lowStoreIsBirth`, map/element-store lowering), `testdata/cg68k/smalltmp_ceiling.cla`

**Interfaces:**
- Consumes: the spec's "Probe task" section — this task answers its five items.
- Produces: a report with a PASS/FAIL verdict per item plus, for item 4, the required instruction ordering for Task 2. Tasks 2–3 read this report before writing code.

- [ ] **Step 1: Item 1 — handoff coverage.** Enumerate every consumer that takes ownership of a handle-typed (`cgIsHandleKind`) `ECallFn`/`EIntr` expression result, and confirm each reads `cgLastTrackedOff` immediately after the one `cgExpr` call that can set it:
  - `cgStmt`'s SAssign scalar arm (cg68k.cla ~:12090): the check runs AFTER `cgEmitStoreScalarAny(dst, src)` returns. Trace `cgEmitStoreScalarAny`'s internal evaluation order: if the dst address computation (EFieldRef/EIndexRef dst) runs after the src evaluation and can itself birth a tracked temp (e.g. a text-typed map key, a call inside an index), `cgLastTrackedOff` would name the WRONG temp at the check. Determine whether any such dst shape exists; if yes, spell out the fix (e.g. read/latch `cgLastTrackedOff` immediately after the src `cgExpr` inside `cgEmitStoreScalarAny`, or reset it before dst eval).
  - `cgReturnStmt` (~:11994): has the check plus the D0 save/reload around `cgFreeStmtTmps` — confirm it is sufficient once call results are tracked.
  - Element/property stores that are NOT SAssign at the IR level: find how `m[k] = g()`, `lst[i] = g()`, `w.field = g()` (widget setter), and `x.append(g())` lower (SExprStmt intrinsics?), and confirm for each that the runtime callee retains internally (host parity: cprint already releases the call-result temp after these — check `fpIntr`'s map_set/list_set/append arms), so an end-of-statement release of the tracked temp is balanced, not a double-release.
- [ ] **Step 2: Item 2 — no KRec sibling gap.** Confirm `cgCallFnInto` (>4-byte returns: KRec/KStr/KErr) results consumed as call arguments are balanced by `cgPushArgs`' KRec materialize branch + `cgPendingArgReleases` (~:9690–9715), in argument, assignment, and discard contexts. Report any hole as out-of-scope-but-documented (spec: verification only).
- [ ] **Step 3: Item 3 — pool headroom.** Record `cgTmpSlots`' current value (module-state block ~:1355) and the per-function pool sizing rules. Count worst-case concurrently-tracked temps for the deepest shapes in-repo and in the BBS evidence doc (`wrapText(stripKludges(postBody(id)), …)`, `pktClamp(pktReadZ(), n)` ×3 in one statement, `dbAppendJournal(db, dbJournalEntry(…))`). Verdict: does the ceiling need a bump? Note `testdata/cg68k/smalltmp_ceiling.cla` pins the ceiling behavior.
- [ ] **Step 4: Item 4 — D0 clobber ordering in `cgCallFnScalar`.** Confirm whether `cgFlushArgReleases` can emit JSRs (which clobber D0) — if so, today's discard-branch (which stores D0 AFTER the flush) stores garbage for a discarded handle-returning call that also had KRec args (latent bug — document it). Specify Task 2's required ordering: cleanup → abort-check → store D0 to tracked temp → flush arg releases → reload D0 from the temp. Also confirm `cgAbortCheckAfterCall`'s inline release walk snapshots `cgStmtTmpOffs` at emission time, so tracking AFTER the abort check keeps the not-yet-produced result off this call's own abort path while later abort checks in the same statement do release it.
- [ ] **Step 5: Item 5 — double-track audit.** List every existing site that already tracks a call/intrinsic result so Task 2/3 can't double-track: `cgCallFnScalar`'s discard branch (~:9848, folds into the new unconditional tracking), `cgPushArgs`' `lowIntrIsOwningContainerRead` scalar arm (~:9740 — pop/shift only, NOT ECallFn, so it stays), `cgIntrListPopLike`'s discard branch, `cgIntrListFirstLast`/text-intrinsic birth sites (already `cgLastTrackedOff`-correct). Confirm the pop/shift-as-operand/receiver shape's host behavior (if cprint leaks it too, it is out of scope; report only).
- [ ] **Step 6: Item 6 — golden blast radius.** Run `go test ./internal/cg68k -count=1` (should PASS on the unmodified tree), and list which `testdata/cg68k/*.s` fixtures contain user calls returning handle types consumed directly (grep the `.cla` fixtures), i.e. which goldens Tasks 2–3 should expect to rebless.
- [ ] **Step 7: Write the report** to `.superpowers/sdd/2026-08-29-68k-call-result-release/task-1-report.md` with one PASS/FAIL-verdict section per item and the Task 2 ordering spelled out as pseudo-Clarus. Commit:

```bash
git add .superpowers/sdd/2026-08-29-68k-call-result-release/task-1-report.md
git commit -m "docs: 68k call-result release Task 1 probe report"
```

---

### Task 2: `cgCallFnScalar` fix + listing regression test

**Files:**
- Modify: `clarusc/cg68k.cla` (`cgCallFnScalar` tail, currently ~:9843–9852)
- Create: `internal/cg68k/callresult_release_test.go`
- Rebless (expected): some `testdata/cg68k/*.s` (per Task 1 item 6 list)

**Interfaces:**
- Consumes: Task 1's report (ordering from item 4; SAssign latch fix from item 1 if one was required — if the report mandates a `cgEmitStoreScalarAny` latch change, implement it in this task exactly as the report specifies).
- Produces: user-call handle results are always tracked; `cgLastTrackedOff` set after `cgCallFnScalar` for handle returns. Task 3 mirrors this shape; Task 4's suite case relies on the behavior.

- [ ] **Step 1: Write the failing test.** `internal/cg68k/callresult_release_test.go` (reuses the package's existing `buildClarusc(t)` helper from `golden_test.go`/`array_assign_test.go`):

```go
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// callresult_release_test.go: regression pin for the 68k call-result leak
// (../68kbbs/docs/memory-leak.md, 2026-08-29): a user function's
// handle-typed result consumed directly (argument / operand / receiver)
// must be spilled to a tracked temp and released by the end-of-statement
// flush. The host lane (cprint fpCallFn) always balanced these; emit68k
// only balanced the assignment/return/discard shapes.
package cg68k

import (
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"
	"testing"
)

const callResultFixture = `func g(): text {
    var t: text
    t.append("hello")
    return t
}

func f(t: text): int {
    return t.length
}

func direct(): int {
    return f(g())
}

func viaLocal(): int {
    var x: text
    x = g()
    return f(x)
}

func recv(): int {
    return g().length
}

func opnd(): int {
    var n: int
    n = (g() + g()).length
    return n
}

on App.launch {
    log(string(direct() + viaLocal() + recv() + opnd()))
}
`

// listingFuncBody returns the listing lines between "; func NAME" and the
// next "; func" marker.
func listingFuncBody(t *testing.T, listing, name string) string {
	t.Helper()
	marker := "; func " + name + " "
	i := strings.Index(listing, marker)
	if i < 0 {
		t.Fatalf("listing has no marker %q", marker)
	}
	rest := listing[i+len(marker):]
	j := strings.Index(rest, "; func ")
	if j < 0 {
		j = len(rest)
	}
	return rest[:j]
}

// releaseLabel finds the LBL_n defined immediately after the
// "; func rtTextRelease" marker.
func releaseLabel(t *testing.T, listing string) string {
	t.Helper()
	body := listingFuncBody(t, listing, "rtTextRelease")
	m := regexp.MustCompile(`(LBL_\d+):`).FindStringSubmatch(body)
	if m == nil {
		t.Fatalf("no label after rtTextRelease marker")
	}
	return m[1]
}

func countCalls(body, label string) int {
	// Same-segment calls are BSR.W LBL_n; keep JSR in the net in case a
	// future fixture grows past one segment.
	re := regexp.MustCompile(`(BSR\.W|JSR)\s+` + label + `\b`)
	return len(re.FindAllString(body, -1))
}

func TestCallResultRelease(t *testing.T) {
	exe := buildClarusc(t)
	dir := t.TempDir()
	src := filepath.Join(dir, "callresult.cla")
	if err := os.WriteFile(src, []byte(callResultFixture), 0o644); err != nil {
		t.Fatal(err)
	}
	outBin := filepath.Join(dir, "out.bin")
	cmd := exec.Command(exe, "emit68k", "-o", outBin, "--listing",
		"--rtdir", filepath.Join(repoRoot(t), "runtime", "clarus")+string(os.PathSeparator), src)
	out, err := cmd.CombinedOutput()
	if err != nil {
		t.Fatalf("emit68k: %v\n%s", err, out)
	}
	segS, err := os.ReadFile(filepath.Join(dir, "out.seg1.s"))
	if err != nil {
		t.Fatal(err)
	}
	listing := string(segS)
	rel := releaseLabel(t, listing)

	cases := []struct {
		fn   string
		want int
	}{
		// direct: g()'s tracked result, released once after f returns.
		{"direct", 1},
		// viaLocal: unchanged from the pre-fix listing -- release of x's
		// old value at init-store, at the g() store, and at scope exit.
		// Pins "no double release on the assignment/handoff path".
		{"viaLocal", 3},
		// recv: g()'s tracked result, released once after .length.
		{"recv", 1},
		// opnd: two g() temps + the concat destination temp (handed off
		// into n? no -- n is int; the concat temp is a receiver of
		// .length, so all three release at statement end).
		{"opnd", 3},
	}
	for _, c := range cases {
		body := listingFuncBody(t, listing, c.fn)
		if got := countCalls(body, rel); got != c.want {
			t.Errorf("%s: %d rtTextRelease calls, want %d\n%s", c.fn, got, c.want, body)
		}
	}
}
```

If the package has no `repoRoot` helper, add the same one-liner the sibling tests use (walk up from `os.Getwd()` to the dir containing `go.mod`) — check `golden_test.go` first and reuse its helper verbatim if one exists.

- [ ] **Step 2: Run it, verify it fails the right way.**

Run: `go test ./internal/cg68k -run TestCallResultRelease -count=1 -v`
Expected: FAIL — `direct: 0 rtTextRelease calls, want 1`, `recv: 0 … want 1`, `opnd` short by two (concat dst is already tracked today). `viaLocal: 3` should already pass. If viaLocal's actual pre-fix count isn't 3, STOP and reconcile against the listing by hand before touching the constant (the count is the no-double-release pin).

- [ ] **Step 3: Implement.** In `cgCallFnScalar` (cg68k.cla, tail after `cgCallFunc`), restructure per Task 1 item 4's ordering. Current tail:

```clarus
    savedReleases = cgSaveArgReleases()
    total = cgPushArgs(irCallFnArgsHead(e))
    cgCallFunc(fi)
    cgCleanupStack(total)
    cgAbortCheckAfterCall(fi)
    cgFlushArgReleases(savedReleases)
    retType = irFuncRet(fi)
    if e == cgDiscardExprIdx and cgNeedsRelease(retType) {
        off = cgNewTrackedTmp(retType)
        cgStoreD0At(6, off, retType)
    }
```

New tail (exact shape; adjust only if the Task 1 report's item 4 section says otherwise):

```clarus
    savedReleases = cgSaveArgReleases()
    total = cgPushArgs(irCallFnArgsHead(e))
    cgCallFunc(fi)
    cgCleanupStack(total)
    cgAbortCheckAfterCall(fi)
    retType = irFuncRet(fi)
    off = -1
    if cgNeedsRelease(retType) {
        // Producer-side tracking (68k-call-result-release spec): a
        // handle-kind result is a +1 birth (lowStoreIsBirth's ExCall
        // contract) -- spill it to a tracked temp so a direct consumer
        // (argument/operand/receiver) is balanced by the end-of-statement
        // flush, and set cgLastTrackedOff so SAssign/SReturn hand off
        // instead. Store BEFORE cgFlushArgReleases (its release JSRs
        // clobber D0) and reload after. Tracking after the abort check
        // keeps the never-produced result off this call's own abort path.
        off = cgNewTrackedTmp(retType)
        cgStoreD0At(6, off, retType)
    }
    cgFlushArgReleases(savedReleases)
    if off != -1 {
        cgLoadD0At(6, off, retType)
        cgLastTrackedOff = off
    }
```

The old `e == cgDiscardExprIdx` discard branch is subsumed — delete it. Update `cgCallFnScalar`'s doc comment (the "discard-detection" paragraph) to describe the always-track discipline. Apply the SAssign latch fix from Task 1 item 1 in the same commit if the report required one.

- [ ] **Step 4: Run the test, verify it passes.**

Run: `go test ./internal/cg68k -run TestCallResultRelease -count=1 -v`
Expected: PASS on all four functions.

- [ ] **Step 5: Rebless affected listing goldens, review the diff.**

Run: `go test ./internal/cg68k -count=1` — expect golden mismatches on the fixtures Task 1 item 6 listed. Then `CLARUS_CG68K_BLESS=1 go test ./internal/cg68k -count=1` and `git diff testdata/cg68k/`. Every hunk must be: a `MOVE.L D0,-n(A6)` spill, a later release-family call, a D0 reload, or a frame-size/label-number shift caused by those. Any other change = STOP, do not bless, report.

- [ ] **Step 6: T1 gate.**

Run: `scripts/test-task.sh --smoke`
Expected: PASS (host lane byte-identical, so only cg68k-side tests move).

- [ ] **Step 7: Commit.**

```bash
git add clarusc/cg68k.cla internal/cg68k/callresult_release_test.go testdata/cg68k/
git commit -m "fix: emit68k releases user-call handle results consumed directly (arg/operand/receiver)"
```

---

### Task 3: `IUiGetTextviewText` fix + listing coverage

**Files:**
- Modify: `clarusc/cg68k.cla` (`cgIntr`'s `IUiGetTextviewText` arm, ~:9153–9183)
- Modify: `internal/cg68k/callresult_release_test.go` (add the getter fixture/test)
- Rebless (expected): UI-shaped `testdata/cg68k/*.s` fixtures that read `.text` off a textview, if any (Task 1 item 6 list)

**Interfaces:**
- Consumes: Task 2's producer-tracking pattern (`cgNewTrackedTmp` + `cgStoreD0At` + `cgLastTrackedOff`) and merged code.
- Produces: `w.SomeTextview.text` reads are tracked births; Task 4's getter loop relies on it.

- [ ] **Step 1: Write the failing test.** Append to `callresult_release_test.go`:

```go
const getterFixture = `window LogWin {
    title: "L"
    textview LogView {
        text: ""
    }
}

func appendish(m: LogWin, filtered: text): text {
    var t: text
    t = m.LogView.text + filtered
    return t
}

on App.launch {
    var w: LogWin
    var extra: text
    w = LogWin()
    w.show()
    log(appendish(w, extra).string)
}
`

func TestGetterResultRelease(t *testing.T) {
	exe := buildClarusc(t)
	dir := t.TempDir()
	src := filepath.Join(dir, "getter.cla")
	if err := os.WriteFile(src, []byte(getterFixture), 0o644); err != nil {
		t.Fatal(err)
	}
	outBin := filepath.Join(dir, "out.bin")
	cmd := exec.Command(exe, "emit68k", "-o", outBin, "--listing",
		"--rtdir", filepath.Join(repoRoot(t), "runtime", "clarus")+string(os.PathSeparator), src)
	out, err := cmd.CombinedOutput()
	if err != nil {
		t.Fatalf("emit68k: %v\n%s", err, out)
	}
	segS, err := os.ReadFile(filepath.Join(dir, "out.seg1.s"))
	if err != nil {
		t.Fatal(err)
	}
	listing := string(segS)
	rel := releaseLabel(t, listing)
	body := listingFuncBody(t, listing, "appendish")
	// The getter's fresh box (1) is a concat operand, released at
	// statement end; the concat destination (2) hands off into t; t (3)
	// hands off to the caller via return... so the statement-end flush in
	// appendish must release exactly the getter box, plus t's init-store
	// release pair. Pin the TOTAL release count in appendish: run once,
	// verify by hand against the listing that exactly ONE release beyond
	// the pre-fix count appeared and it targets the getter's spill slot,
	// then pin that number here.
	const want = -1 // set from the reviewed listing before commit
	if got := countCalls(body, rel); got != want {
		t.Errorf("appendish: %d rtTextRelease calls, want %d\n%s", got, rel, body)
	}
}
```

NOTE for the implementer: the `-1` placeholder is deliberate and MUST be resolved within this task, in two runs: (a) on the unmodified arm, record the pre-fix count N and confirm the leak (no release for the getter box); (b) after the fix, confirm the count is N+1, review the listing by eye to confirm the new release's spill slot is the getter's, then set `want` to N+1 and note both numbers in the task report. A UI fixture may pull the whole UI runtime into multiple segments — if `; func appendish` is not in `out.seg1.s`, search `out.seg*.s` for the marker and load that file instead (adjust `listingFuncBody` usage accordingly; the release call may then be `JSR` via jump table — `countCalls` already accepts JSR, but the label form differs cross-segment: in that case match on the jump-table `; func rtTextRelease (JT slot N)` slot's A5 offset `JSR 34+8*N-…` — simplest is to keep the fixture single-window/minimal so everything lands in seg1; if it doesn't, ask for review rather than inventing a matcher).

Run: `go test ./internal/cg68k -run TestGetterResultRelease -count=1 -v` — expect FAIL (want -1 forces it; record pre-fix N).

- [ ] **Step 2: Implement.** In the `IUiGetTextviewText` arm, after the final result pop (`a68Emit(OpMove, 4, AmPostInc, 7, 0, AmDn, 0, 0)`), add (declaring `var off: int` at `cgIntr`'s var block if not already present — check first; `cgIntr` may already have an `off`):

```clarus
        a68Emit(OpMove, 4, AmPostInc, 7, 0, AmDn, 0, 0)
        // Producer-side tracking (68k-call-result-release spec): the box
        // is a fresh rtTextNew birth (lowStoreIntrOwnsResult's
        // IUiGetTextviewText contract) -- track it so a direct consumer
        // (the appendLog `getter + x` shape) is balanced at statement
        // end, and let SAssign/SReturn hand it off.
        off = cgNewTrackedTmp(irTextT)
        cgStoreD0At(6, off, irTextT)
        cgLastTrackedOff = off
        return
```

- [ ] **Step 3: Resolve the pin, run, verify.** Set `want` per Step 1's NOTE. Run: `go test ./internal/cg68k -run 'TestCallResultRelease|TestGetterResultRelease' -count=1 -v` — both PASS.

- [ ] **Step 4: Rebless + review any golden diffs** (same discipline as Task 2 Step 5), then T1 gate: `scripts/test-task.sh --smoke` — PASS.

- [ ] **Step 5: Commit.**

```bash
git add clarusc/cg68k.cla internal/cg68k/callresult_release_test.go testdata/cg68k/
git commit -m "fix: emit68k releases textview-getter text boxes consumed directly"
```

---

### Task 4: Native heap proof — toolbox suite `LeakCheck` case

**Files:**
- Create: `testsuite/toolbox/cases_leak.cla`
- Modify: `testsuite/toolbox/runner.cla` (enum entry, `tbCaseName` arm, all-cases list, dispatch arm — follow `NarrowPopup`'s registration at :154/:263/:306/dispatch verbatim)
- Modify: `testsuite/toolbox/gui.cla` ONLY if case files are named there (check how `cases_*.cla` reach the build — the suite-boot test globs `cases_*.cla`; confirm in `internal/mactest/coresuite_test.go` and mirror whatever `cases_narrowpopup.cla` needed)

**Interfaces:**
- Consumes: Tasks 2–3 merged (the fix must be in, or the case FAILs by leaking).
- Produces: `ToolboxTest` case `LeakCheck`, function `caseLeakCheck(): bool`, wired into the runner. Toolbox suite real-case count becomes 32.

- [ ] **Step 1: Write the case.** `testsuite/toolbox/cases_leak.cla`:

```clarus
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// cases_leak.cla: LeakCheck (68k-call-result-release phase, 2026-08-29) --
// hardware-proves that a user function's text result consumed DIRECTLY
// (argument / operand / receiver -- the ../68kbbs/docs/memory-leak.md
// shapes) is released by the codegen. Pre-fix, each loop below leaked one
// text box+handle per iteration (~30+ bytes), so 1500 iterations leak
// tens of KB; FreeMem sampled before/after must stay flat to within an
// allocator-jitter slack. TbFreeMem is declared locally, same
// user-code-extern precedent as cases_gestalt.cla's TbGestaltErr (the
// curated twin lives in toolbox/memory.cla's FreeMem).

external func TbFreeMem(): int = trap 0xA01C reg

func tlkMake(): text {
    var t: text
    t.append("0123456789abcdef")
    return t
}

func tlkLen(t: text): int {
    return t.length
}

func caseLeakCheck(): bool {
    var before: int
    var after: int
    var i: int
    var n: int
    var acc: text

    before = TbFreeMem()
    i = 0
    while i < 1500 {
        // argument position: f(g())
        n = n + tlkLen(tlkMake())
        // receiver position: g().length
        n = n + tlkMake().length
        // operand position: g() + g() (concat receiver consumed too)
        n = n + (tlkMake() + tlkMake()).length
        // builtin-method argument: acc.append(g())
        acc.append(tlkMake())
        acc = ""
        i = i + 1
    }
    after = TbFreeMem()
    if n == 0 {
        // keep n observably live so nothing above can be shaken out
        return false
    }
    // Slack: Memory Manager fragmentation/rounding jitter, NOT leak
    // headroom -- pre-fix these loops leak >100KB, so 8KB cleanly
    // separates pass from fail.
    return after > before - 8192
}
```

Note: no `--testapi`/UiTest dependency; check how other cases log failures (`tkReport`? see `harness.cla`) and match the suite's pass/fail convention exactly — if cases report via a helper rather than bare bool, mirror `caseGestaltNamed`'s exact signature and reporting instead of the bare-bool shape above. The registration contract in `runner.cla` is authoritative; copy `NarrowPopup`'s wiring line-for-line with the new name.

- [ ] **Step 2: Register the case** in `testsuite/toolbox/runner.cla` (enum member `LeakCheck`, `tbCaseName` arm returning `"LeakCheck"`, the `l.add(LeakCheck)` all-cases line, and the dispatch `case LeakCheck { … caseLeakCheck() … }` arm — mirroring `NarrowPopup` exactly). Update `runner.cla`'s header-count comment if it names the case count.

- [ ] **Step 3: Run the suite natively.**

Run: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestToolboxSuiteOn68k -count=1 -v -timeout 20m`
Expected: PASS including the new `LeakCheck` subtest. If it fails on heap slack (not a leak — verify by the magnitude: a real regression is >100KB), tune iterations/slack with the measured numbers in the task report, not by guessing.

- [ ] **Step 4: Sanity-check the case actually catches the bug.** Temporarily revert the Task 2 hunk (`git stash` the cg68k.cla change is NOT possible mid-branch — instead: `git worktree` is overkill; do it by reverting the tracked-temp block to the discard-only condition in a scratch copy: `git show HEAD~2:clarusc/cg68k.cla > /tmp/cg68k_prefix.cla` and build a scratch clarusc with it, or simpler: check out the pre-Task-2 commit in a detached temp worktree and run only the LeakCheck boot there with the NEW testsuite files copied in). If that is more than ~15 minutes of work, skip with a note — the listing tests already pin the codegen — but if done, record the failing FreeMem delta in the report.

- [ ] **Step 5: T1 gate** (`scripts/test-task.sh --smoke`) — PASS — then commit.

```bash
git add testsuite/toolbox/cases_leak.cla testsuite/toolbox/runner.cla
git commit -m "test: toolbox-suite LeakCheck case -- FreeMem-flat proof for direct call-result consumption"
```

---

### Task 5: Close-out — snapshot regen, docs, T2

**Files:**
- Modify: `clarusc/clarusc.c` (regenerated snapshot)
- Modify: `docs/ROADMAP.md` (phase entry → completed), `docs/STATUS.md`, `CLAUDE.md` (toolbox suite case count 31→32 real, one-line phase mention in the suite paragraph), `docs/TODO.md` if the probe surfaced deferred items (e.g. pop/shift-as-operand host-parity note, the pre-fix discard/KRec-arg D0 latent bug if confirmed and out of scope)

**Interfaces:**
- Consumes: all prior tasks merged and green.
- Produces: a merge-ready branch (merge itself only on request).

- [ ] **Step 1: Regenerate the snapshot.** Follow `internal/selfhost`'s `TestSnapshotFixedPoint` regeneration instructions exactly (the test prints them on mismatch; run `go test ./internal/selfhost -run TestSnapshotFixedPoint -count=1 -timeout 30m` to get them, regenerate, re-run to green).
- [ ] **Step 2: Update docs** (ROADMAP phase entry, STATUS handoff section, CLAUDE.md counts/phase notes, TODO deferrals from the probe report).
- [ ] **Step 3: T2 gate.**

Run: `scripts/test-merge.sh`
Expected: GREEN (includes `internal/selfhost` and the native mactest lane; frozen UI scenario goldens must pass UNCHANGED — behavior-level, so no rebless; if a scenario golden fails, that is a real regression, STOP and debug, do not bless).

- [ ] **Step 4: Commit.**

```bash
git add clarusc/clarusc.c docs/ CLAUDE.md
git commit -m "docs: 68k call-result release close-out (snapshot regen, STATUS, ROADMAP, CLAUDE.md)"
```

---

## Self-review notes

- Spec coverage: producer-side fix (Tasks 2–3), probe items 1–5 (Task 1), listing pin (Task 2–3 tests), native FreeMem proof (Task 4), host-lane untouched (global constraint + T1/T2), snapshot regen + docs (Task 5). BBS acceptance explicitly out of scope per spec.
- The two hand-resolved pins (`viaLocal` count, getter `want`) are deliberate measure-then-pin steps with STOP conditions, not placeholders.
- Type consistency: `cgNewTrackedTmp(t) → off`, `cgStoreD0At(6, off, t)`, `cgLoadD0At(6, off, t)`, `cgLastTrackedOff = off` used identically in Tasks 2 and 3; `caseLeakCheck(): bool` named consistently in Task 4.
