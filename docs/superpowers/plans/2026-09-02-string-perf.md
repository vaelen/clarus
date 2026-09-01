# String Performance (native 68k) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Remove the two dominant measured string costs on the native 68k lane (full-capacity string-local zero-init; out-of-line `s[i]`/`s.len` calls) and add `text.clear()`/`text.reserve(n)` for warm-buffer reuse.

**Architecture:** Two surgical cg68k codegen changes (native lane only, behavior-preserving), one new pair of text methods plumbed through the standard intrinsic path (check → lower → ir → cg68k/cprint/shake → text.cla, both lanes), all pinned by suite cases, reblessed listings goldens, and a promoted calibration bench.

**Tech Stack:** Clarus self-hosted compiler (`clarusc/*.cla`), Clarus runtime (`runtime/clarus/*.cla`), Go test harness (`internal/`), Mini vMac native lane.

**Spec:** `docs/superpowers/specs/2026-09-02-string-perf-design.md`

## Global Constraints

- Branch: `string-perf` off main `061dbd5`. Merge only on explicit request.
- Gate per task: `scripts/test-task.sh --smoke` (every task here touches `runtime/` or `clarusc/`). Full `scripts/test-merge.sh` only in Task 7.
- Task 3 MUST NOT start until Task 1's verdict is recorded and is "safe" (or reshaped per its findings).
- `docs/clarus-language-reference.md` contains MacRoman bytes: NEVER use the Edit/Write tools on it. Use `LC_ALL=C sed` (or a byte-appending script) and verify with a byte-level diff that only the intended region changed (see the project memory "MacRoman .cla editing"). `runtime/clarus/*.cla` and `clarusc/*.cla` are ASCII; normal Edit is fine there.
- The committed `clarusc/clarusc.c` snapshot goes stale during this branch (compiler sources change). That is expected mid-branch; it is regenerated once in Task 7. Do not regenerate per task.
- Bench/timing numbers are measurements, never pass/fail assertions.
- Commit after every task with the repo's conventional style (`feat(...)`, `fix(runtime)`, `test:`, `docs:`).

---

### Task 1: Zeroed-tail probe (read-only; verdict gates Task 3)

**Files:**
- Read only. Deliverable is a written verdict appended to this plan's progress ledger (`.superpowers/sdd/.../progress.md`) AND summarized in the Task 1 commit-less report to the dispatcher.

**Question:** After Task 3, a plain `string` local's bytes past the length byte will contain stale stack garbage instead of zeros (len byte still 0). Find every consumer, on BOTH lanes, that could observe those tail bytes. `cgDefaultInitStrAt`'s own comment (`clarusc/cg68k.cla:3400-3405`) says the full zero exists "so a stale stack/heap byte can never leak into an unused tail" — this probe decides whether that defense protects anything real.

- [ ] **Step 1: Enumerate the read paths.** For each, record file:line and whether access is bounded by the length byte:
  - String equality / comparison / ordering: `rtStrCmp` and any `rtStrEq`-family function (`runtime/clarus/str.cla`), plus the host-lane C twins (`runtime/host/rt.c` / `rt_core.inc` — search `rt_str_`).
  - String hashing: map/sortedmap/intmap keying on strings (`runtime/clarus/map.cla`, `sortedmap.cla` — find the hash function and confirm it stops at `len`), both lanes.
  - `rtStrStore` (`str.cla:50-67`) and `rtStrConcat`/slice/coerce: confirm every copy is `min(srclen, cap)`-bounded reads of the SOURCE.
  - `IStrToBytes`/`fromBytes` (`clarusc/cg68k.cla:8339-8346`, runtime impls): does `toBytes` copy `len` bytes or capacity?
  - Whole-slot block copies: record copies containing string fields, string assignment (`cgEmitStoreStr`, `cg68k.cla:11054+`), argument marshaling — stale tail bytes being *copied* is harmless UNLESS the destination is later exposed byte-wise; flag any path where a whole `string` slot (not `len` bytes) is written to a file, resource, checksum (`UiTestChecksum`, `--testapi`), CRC, or network buffer.
- [ ] **Step 2: Check lane divergence.** Task 3 changes only cg68k; the host lane keeps full zeroing. Flag anything where host and native could now produce *different observable output* for the same program (goldens, suite oracles, checksums). If all reads are len-bounded, divergence is impossible — say so explicitly.
- [ ] **Step 3: Record the verdict** — one of: (a) SAFE: every consumer is len-bounded, Task 3 proceeds as planned; (b) SAFE-WITH-FIX: name the specific consumer(s) to fix first and add the fix to Task 3; (c) UNSAFE: full zeroing is load-bearing (explain), Task 3 is dropped and the spec's §1 is annotated. Cite file:line evidence for every claim.

---

### Task 2: Promote the calibration bench

**Files:**
- Create: `testdata/bench/strbench.cla` (from `/private/tmp/claude-501/-Users-andrew-repos-clarus/0b2dfe86-585e-4ec7-a295-363efa51ebc3/scratchpad/strbench.cla`; if the scratchpad copy is gone, reconstruct from the variant list in the spec §Motivation table — 14 variants + `BENCH done` sentinel)
- Modify: `internal/mactest/bench_test.go`
- Test: `internal/mactest/bench_test.go` (the new test IS the deliverable)

**Interfaces:**
- Produces: `TestStrBench68k` (gated `CLARUS_MAC_TESTS=1 CLARUS_BENCH68K=1`), a measurement instrument like `TestParseBench68k` — fails only on build/boot/protocol errors, never on timing values.

- [ ] **Step 1: Copy the bench source** into `testdata/bench/strbench.cla`. Add a header comment in `parsebench.cla`'s style: what it measures, the 2026-09-01 baseline table (from the spec), the build line (`scripts/build-68k.sh StrBench toolbox/events.cla testdata/bench/strbench.cla`), and that output is `BENCH <name> iters=<n> ticks=<t>` lines via `alert()` ending with `BENCH done`.
- [ ] **Step 2: Add `TestStrBench68k`** to `internal/mactest/bench_test.go`, cloning `TestParseBench68k`'s shape (`bench_test.go:57-84`): file list `toolbox/events.cla` + `testdata/bench/strbench.cla`, build via the memoized `buildNativeClarusc(t)` + `emit68k`, `RunMac(t, bin, 12*time.Minute)`, then require the `BENCH done` sentinel and `t.Logf` every `BENCH ` line. New regexp; do not reuse `benchLineRe`.
- [ ] **Step 3: Run it once** (`CLARUS_MAC_TESTS=1 CLARUS_BENCH68K=1 go test ./internal/mactest -run TestStrBench68k -count=1 -v`) and record the logged table in the progress ledger as the pre-change baseline. Expected: numbers within noise of the spec's table.
- [ ] **Step 4: Run `scripts/test-task.sh --smoke`.** Expected: green (new test is env-gated, so T1 semantics unchanged).
- [ ] **Step 5: Commit** — `test: promote string calibration bench (strbench.cla + TestStrBench68k)`.

---

### Task 3: String-local default-init = length byte only (cg68k) — GATED ON TASK 1

**Files:**
- Modify: `clarusc/cg68k.cla` (new helper near `cgDefaultInitStrAt` at `:3400`; call-site change in `cgEmitFunc`'s prologue local-init dispatch)
- Modify: `testdata/cg68k/*.s` goldens (rebless)

**Interfaces:**
- Consumes: Task 1's SAFE verdict (or its named fixes, folded in here first).
- Produces: no API change; emitted-code change only.

- [ ] **Step 1: Locate the prologue call path.** Find where `cgEmitFunc`'s entry-init loop (the `recLocalOffsets`/`recLocalTypes` walk after `cg68k.cla:5177-5216`) dispatches a `KStr` local — expected via a `cgDefaultInitAt`-style kind switch that reaches `cgDefaultInitStrAt(reg, off, t, strDefaultIdx)`. Confirm which OTHER callers `cgDefaultInitStrAt` has (globals init, record ctor fields) — those keep current behavior.
- [ ] **Step 2: Add the helper** next to `cgDefaultInitStrAt`:

```
// cgDefaultInitStrLenOnlyAt (string-perf Task 3): a LOCAL string's
// default-init -- clear the Pascal length byte only, not the full
// capacity. The zero value "empty string" is fully represented by
// len=0; the string-perf probe (plan Task 1) verified every consumer
// on both lanes is length-bounded, so the stale tail is unobservable.
// Globals and record fields keep cgDefaultInitStrAt's whole-slot zero
// (spec: records out of scope; globals init once, cost irrelevant).
func cgDefaultInitStrLenOnlyAt(reg: int, off: int) {
    a68Emit(OpLea, 0, AmDisp16, reg, off, AmAn, 0, 0)
    a68Emit(OpClr, 1, AmNone, 0, 0, AmInd, 0, 0)
}
```

If `a68Emit`/`asm68k.cla` cannot encode `CLR.B (A0)` (check `OpClr` size-1 support in `asm68k.cla` first), either add the byte encoding there (CLR is a standard size-encoded op) or fall back to `MOVEQ #0,D0` + `MOVE.B D0,(A0)` — two instructions is still fine.
- [ ] **Step 3: Route the local-init dispatch** for `KStr` locals with no explicit default (`strDefaultIdx == -1`) to the new helper. Locals WITH explicit defaults keep the `rtStrStore` path unchanged. Do not touch the globals or record-field call sites.
- [ ] **Step 4: Run the golden gate to see the expected failure:** `go test ./internal/cg68k -count=1`. Expected: FAIL with listing diffs showing `CLR.W (A0)+`/`DBRA` zero loops replaced by the single byte clear in functions with string locals, and NOTHING else.
- [ ] **Step 5: Rebless and review:** `CLARUS_CG68K_BLESS=1 go test ./internal/cg68k -count=1`, then `git diff testdata/cg68k/` and verify every hunk is exactly the expected shape (zero-loop removal; frame sizes/`LINK` unchanged). Any other drift = stop and investigate.
- [ ] **Step 6: Run `scripts/test-task.sh --smoke`.** Expected: green, including both emulator smoke tests (real hardware executing the new prologue).
- [ ] **Step 7: Commit** — `feat(cg68k): string-local default-init clears length byte only (was full-capacity zero loop)` with the Task 1 verdict reference in the body.

---

### Task 4: Inline `IStrLen` / `IStrIndex` (cg68k)

**Files:**
- Modify: `clarusc/cg68k.cla` (replace the two arms at `:8319-8326`; new `cgIntrStrLenInline`/`cgIntrStrIndexInline` helpers near `cgIntrPeek` at `:6710`)
- Modify: `testdata/cg68k/*.s` goldens (rebless)

**Interfaces:**
- Consumes: `cgExprAddr(e)` leaves the operand's address in A0 (as `cgCallRuntime`'s `cg68k.cla:10047` usage proves); `cgEmitPanic(msgLitIdx)` (`cg68k.cla:4085`) emits the never-returns panic sequence.
- Produces: no API change. `rtStrLen`/`rtStrIndex` stay in `str.cla` (host lane + `shake.cla` arms untouched; a few dead bytes in native binaries is accepted — note it in the commit body).

- [ ] **Step 1: Write `cgIntrStrLenInline`:**

```
// cgIntrStrLenInline (string-perf Task 4): s.len as an inline
// unsigned byte load -- the shape rtStrCmp already uses internally
// (peekb(s)) -- instead of a BSR to rtStrLen's LINK/UNLK frame.
func cgIntrStrLenInline(e: int) {
    cgExprAddr(irIntrArgsHead(e))
    a68Emit(OpClr, 4, AmNone, 0, 0, AmDn, 0, 0)
    a68Emit(OpMove, 1, AmInd, 0, 0, AmDn, 0, 0)
}
```

- [ ] **Step 2: Write `cgIntrStrIndexInline`.** Contract to preserve exactly: panics `"string index out of range"` for `i < 0` or `i >= len` (`rtStrIndex`, `runtime/clarus/str.cla:198-206`); result is the unsigned byte `s[1+i]` zero-extended in D0. Shape (adapt to available `asm68k.cla` ops — verify `OpCmp`, `OpAdda`, and an unsigned branch-carry-clear/set exist; if there is no BCS/BCC conditional, emit the two signed compares inline instead — still no call, no frame, single pointer derivation):

```
func cgIntrStrIndexInline(e: int) {
    var a0e: int
    var a1e: int
    var okLbl: int

    a0e = irIntrArgsHead(e)
    a1e = irExprNext(a0e)
    cgExpr(a1e)
    a68Emit(OpMove, 4, AmDn, 0, 0, AmPreDec, 7, 0)
    cgExprAddr(a0e)
    a68Emit(OpMove, 4, AmPostInc, 7, 0, AmDn, 1, 0)
    a68Emit(OpClr, 4, AmNone, 0, 0, AmDn, 0, 0)
    a68Emit(OpMove, 1, AmInd, 0, 0, AmDn, 0, 0)
    a68Emit(OpCmp, 4, AmDn, 0, 0, AmDn, 1, 0)
    okLbl = a68NewLabel()
    a68Emit(OpBcs, 0, AmNone, 0, 0, AmPCLabel, 0, okLbl)
    cgEmitPanic(cgStrIndexPanicIdx)
    a68Bind(okLbl)
    a68Emit(OpAdda, 4, AmDn, 1, 0, AmAn, 0, 0)
    a68Emit(OpClr, 4, AmNone, 0, 0, AmDn, 0, 0)
    a68Emit(OpMove, 1, AmDisp16, 0, 1, AmDn, 0, 0)
}
```

The i-spill across `cgExprAddr` copies `cgIntrPoke`'s documented discipline (`cg68k.cla:6724-6734`): A0 is universal scratch, never carry it across a `cgExpr*`. The single unsigned `CMP`+`BCS` covers `i < 0` because a negative i is a huge unsigned value. `cgStrIndexPanicIdx`: intern/pool the literal `"string index out of range"` the same way existing `cgEmitPanic` call sites obtain their message index (grep `cgEmitPanic(` callers for the pool-add helper and mirror it; the literal must be pooled unconditionally when any `IStrIndex` is emitted, since `rtStrIndex`'s own copy may be tree-shaken).
- [ ] **Step 3: Replace the dispatch arms** at `cg68k.cla:8319-8326` to call the two new helpers (drop the `cgIntr1(e, rnStrLen, true)` / `cgIntr2(e, rnStrIndex, true, false)` calls). Grep first: these must be the ONLY native emission sites for `IStrLen()`/`IStrIndex()` (`IStrSetIndex` and everything else stays).
- [ ] **Step 4: Golden gate, expected FAIL with only the two shapes:** `go test ./internal/cg68k -count=1` — `BSR` + arg pushes to `rtStrLen`/`rtStrIndex` replaced by the inline sequences (e.g. the `strs.s:10304-10331` copy-loop call site).
- [ ] **Step 5: Rebless (`CLARUS_CG68K_BLESS=1 go test ./internal/cg68k -count=1`), review `git diff testdata/cg68k/` hunk-by-hunk.**
- [ ] **Step 6: Verify the panic path still fires on hardware.** The existing suites cover in-range indexing heavily; check whether any existing core-suite case pins the out-of-range panic (grep `testsuite/core/cases_*.cla` for `index out of range` / `lastError`-style pins on indexing). If none does, add a minimal one to the most fitting existing `cases_*.cla` file (an `attempt`-guarded `s[i]` with `i == s.len`, expecting the panic/abort contract the reference specifies) — do NOT add a new enum case for it if an existing case function can absorb the assertion; otherwise wire a new case per Task 6's checklist shape.
- [ ] **Step 7: Run `scripts/test-task.sh --smoke`.** Expected: green.
- [ ] **Step 8: Commit** — `feat(cg68k): inline s[i]/s.len at call sites (was out-of-line rtStrIndex/rtStrLen calls)`.

---

### Task 5: `text.clear()` and `text.reserve(n)`

**Files:**
- Modify: `runtime/clarus/text.cla` (two new runtime funcs)
- Modify: `clarusc/check.cla` (`buildMethodTables`, `textOnlyMethods` block at `:1520-1560`)
- Modify: `clarusc/ir.cla` (two intrinsic ids, clone `ITextAppendChar` at `:3503`)
- Modify: `clarusc/lower.cla` (two arms in the string/text method lowering, the `isText` region at `:2100-2166`)
- Modify: `clarusc/cg68k.cla` (two `rn*` vars + interns + two dispatch arms in the text family at `:8348+`)
- Modify: `clarusc/cprint.cla` (two arms next to `ITextAppendChar`'s at `:2862`)
- Modify: `clarusc/shake.cla` (two arms next to `ITextAppendChar`'s at `:618`)
- Modify: `docs/clarus-language-reference.md` (MacRoman — sed only, see Global Constraints)

**Interfaces:**
- Produces: `t.clear()` — void, sets `len = 0`, capacity/handle untouched, no traps, no-op on empty; `t.reserve(n: int)` — void, grows capacity to ≥ n via one `SetHandleSize` at most, no-op when satisfied, never shrinks, panics `"out of memory"` on failure. Runtime funcs `rtTextClear(t: ptr)` / `rtTextReserve(t: ptr, n: int)`; intrinsics `ITextClear`/`ITextReserve`. Task 6 tests these exact semantics.

- [ ] **Step 1: Runtime** (`runtime/clarus/text.cla`, next to `rtTextAppendChar` at `:1100`):

```
// rtTextClear (string-perf phase, text.clear()): len = 0; capacity and
// handle untouched -- no traps, so a warm reused buffer resets for
// free. The bytes beyond len are dead by the same length-bounded
// contract every text read path already honors.
func rtTextClear(t: ptr) {
    var rt: RtText

    rt = RtText(t)
    rt.len = 0
}

// rtTextReserve (string-perf phase, text.reserve(n)): pre-grow to at
// least n -- at most one SetHandleSize trap, vs. one per doubling
// boundary when a per-char producer grows implicitly. No-op when
// capacity already suffices; never shrinks; panics "out of memory" on
// failure exactly like implicit growth (rtTextGrow above).
func rtTextReserve(t: ptr, n: int) {
    if n > 0 {
        rtTextGrow(t, n)
    }
}
```

- [ ] **Step 2: check.cla** — in `buildMethodTables` after the `textOnlyMethods["append"]` entry (`:1536`):

```
sigStart()
textOnlyMethods["clear"] = sigEnd(-1)

sigStart()
sigAdd(psPlain(IntT))
textOnlyMethods["reserve"] = sigEnd(-1)
```

(`canvasMethods["clear"] = sigEnd(-1)` at `:1803` is the zero-arg-void precedent; text and canvas method namespaces are disjoint tables, no clash.)
- [ ] **Step 3: ir.cla** — clone `ITextAppendChar()` (`:3503`) as `ITextClear()` / `ITextReserve()` following whatever id/intern scheme the neighbors use.
- [ ] **Step 4: lower.cla** — in the text-method arm chain (`:2118+`, where `append`/`hashStep` live):

```
} else if nm == "clear" {
    return newIRIntr(ITextClear(), recv, ty)
} else if nm == "reserve" {
    return newIRIntr(ITextReserve(), lowMethodArgs2(recv, arg0), ty)
```

(recv-only intrinsic shape precedent: map `count` at `:2035`.) Confirm this arm chain is text-only (it is guarded by `textOnlyMethods` per the `append` arm's own comment) — `string` receivers must NOT accept `clear`/`reserve`; add a negative check-test if the frontend test suite has a natural home for one (grep `internal/` for existing check-error fixtures on unknown text methods and clone one).
- [ ] **Step 5: cg68k.cla** — `rn` vars + interns next to `rnTextAppendChar` (`:297`, `:439-441` region), then dispatch arms next to `ITextAppendChar()`'s (`:8377`):

```
if nm == ITextClear() {
    cgIntr1(e, rnTextClear, false)
    return
}
if nm == ITextReserve() {
    cgIntr2(e, rnTextReserve, false, false)
    return
}
```

- [ ] **Step 6: cprint.cla** — arms next to `ITextAppendChar()`'s (`:2862`), matching neighbors' `cpTextPorted` convention:

```
} else if nm == ITextClear() {
    fpEmit("clar_fn_rtTextClear((void*)" + fpExpr(a0) + ");")
    return toText("")
} else if nm == ITextReserve() {
    fpEmit("clar_fn_rtTextReserve((void*)" + fpExpr(a0) + ", " + fpExpr(a1) + ");")
    return toText("")
```

(`cpTextPorted` is unconditionally true per `cprint.cla:100-105`; if the neighboring arms carry a dead non-ported else-branch for convention, mirror it with `rt_text_clear`/`rt_text_reserve` shims named consistently — but do NOT add C shims to `runtime/host`: the ported branch is the only live one.)
- [ ] **Step 7: shake.cla** — arms next to `ITextAppendChar()`'s (`:618`): `shakeMarkAndEnqueue(intern("rtTextClear"))` / `...("rtTextReserve")`.
- [ ] **Step 8: Smoke the host lane end to end** with a scratch program (scratchpad, not committed): build via `scripts/clarus-run.sh` — `var t: text` … `t.reserve(100)`, append 80 chars, `t.clear()`, append `"abc"`, assert `t.len() == 3` — expect clean run, correct output.
- [ ] **Step 9: Language reference** — add `clear()`/`reserve(n)` entries to the text-methods section via `LC_ALL=C sed` insertion; wording must pin: clear keeps capacity, no allocation; reserve never shrinks, at most one grow, panics "out of memory" on failure. Byte-diff the file (`git diff --stat` + `LC_ALL=C sed -n` spot-check around the insertion) to prove only the intended lines changed.
- [ ] **Step 10: Run `scripts/test-task.sh --smoke`.** Expected: green.
- [ ] **Step 11: Commit** — `feat(text): clear() and reserve(n) methods (warm-buffer reuse, both lanes)`.

---

### Task 6: Suite cases

**Files:**
- Modify: `testsuite/core/` — one new case in the most fitting existing `cases_*.cla` family (or a new `cases_strperf.cla` if none fits), plus `runner.cla` enum/dispatch, plus `cli.cla`'s `SelfCheck` count expectation (`casesRun == nCoreCases - 1` — find the constant and bump it)
- Modify: `testsuite/toolbox/` — one new case + `runner.cla` enum/dispatch
- Test: the suites themselves (host CLI run + the gated suite-boot tests)

**Interfaces:**
- Consumes: Task 5's `clear()`/`reserve()` exactly as specified there.
- Produces: `CoreTest` case `StrPerf`; `ToolboxTest` case `ClearWarm`.

- [ ] **Step 1: Core case `StrPerf`** (runs on host AND native — keep it Toolbox-free). Assertions, following the suite's existing tkAssert/return-bool idiom (read a neighboring case first and mirror its exact reporting shape):
  - `var s: string` read before any assignment: `s.len() == 0`, `s == ""`, and `"" + s == ""` (pins Task 3's semantics).
  - `var t: text` … `t = "hello"`, `t.clear()`, `t.len() == 0`; `t.append("abc")`, `t == "abc"` (clear resets content, buffer reusable).
  - `t.reserve(1)` then `t.reserve(2000)` then appends still correct (`reserve` is semantically invisible).
  - `s[i]` in-range values across a loop equal to per-char expectations (pins Task 4's inline path against the old call path's results — e.g. sum of `"AZaz"[i]` codes).
- [ ] **Step 2: Wire the enum/dispatch/count** exactly as the last-added core case did (`git log --oneline -- testsuite/core/` and copy the `PtrCall` or `DirOps` wiring commit's shape). Update `SelfCheck`'s expected count.
- [ ] **Step 3: Run the core suite on host** via the compose recipe in CLAUDE.md (`build-run/clarusc emit … testsuite/core/… cli.cla`; run `all`). Expected: all PASS including the new case.
- [ ] **Step 4: Toolbox case `ClearWarm`** (native/hardware only): mirror `LeakCheck`'s FreeMem discipline (read `testsuite/toolbox/cases_leakcheck.cla` first and reuse its `TbFreeMem` extern/pattern): `var t: text`, `t.reserve(128)`, snapshot FreeMem, then 200 iterations of `t.clear()` + append 80 chars, snapshot FreeMem again — assert byte-identical FreeMem (clear+warm-append performs zero Memory Manager traffic). Wire enum/dispatch as `LeakCheck` is wired (both the native file list and the cprint twin list, matching `ScrollToEnd`'s precedent — the OnMac twin stays blocked by the pre-existing `TbFreeMem` shim gap, `docs/TODO.md`; do not fix that here).
- [ ] **Step 5: Run the two native suite boots:** `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestCoreSuiteGUIOn68k|TestToolboxSuiteOn68k' -count=1`. Expected: PASS with the new per-case subtests green.
- [ ] **Step 6: Run `scripts/test-task.sh --smoke`.** Expected: green.
- [ ] **Step 7: Commit** — `test: StrPerf core case + ClearWarm toolbox case (string-perf pins)`.

---

### Task 7: Close-out — snapshot, after-bench, docs, T2

**Files:**
- Modify: `clarusc/clarusc.c` (regenerated snapshot)
- Modify: `docs/TODO.md`, `docs/ROADMAP.md`, `STATUS.md`, `CLAUDE.md` (suite counts + feature mentions)
- The plan progress ledger (after-bench table)

- [ ] **Step 1: Regenerate the bootstrap snapshot.** Run `go test ./internal/selfhost -run TestSnapshotFixedPoint -timeout 30m -count=1`; if it fails it prints the Go-free regeneration instructions — follow them exactly, regenerate `clarusc/clarusc.c`, re-run to green.
- [ ] **Step 2: After-bench.** Re-run `TestStrBench68k` (Task 2's command); record the table beside the baseline in the progress ledger. Expected: `mklocal`/`mklocal4`/`mk7` collapse toward bare-call cost; `strindex` drops to the ~10 µs class; `echo80`/`echo7`, `concat`, `appendchar_warm` unchanged within noise. If a number moved the WRONG way, stop and investigate before proceeding.
- [ ] **Step 3: Docs.** `docs/TODO.md`: add the spec's out-of-scope list (record-local init elision; concat/return-path inlining; loop-invariant `&s` hoisting) as recorded follow-ups. `CLAUDE.md`: update the core/toolbox case counts and the phase summary line, following the existing phase-append style. `docs/ROADMAP.md`/`STATUS.md`: phase entry per house style (read the last phase's close-out commit `c2f90a8`/`061dbd5` diffs and mirror).
- [ ] **Step 4: Full merge gate:** `scripts/test-merge.sh`. Expected: green (selfhost included).
- [ ] **Step 5: Commit** — `docs+snapshot: string-perf close-out`; then request final whole-branch review per the SDD flow (opus reviewer), do NOT merge — merge happens only on Andrew's explicit request.

---

## Self-review notes (writing-plans checklist)

- Spec coverage: §1→Task 3, §2→Task 4, §3→Task 5, §4a→Task 1, §4b→Tasks 2+7, §4c→Tasks 3/4 rebless steps, §4d→Task 6, §4e→per-task T1 + Task 7 T2, §5→Global Constraints; out-of-scope list→Task 7 Step 3.
- The `OpBcs`/`OpClr`-size-1 encodings and the exact prologue dispatch shape are verify-then-adapt points, called out inline where they occur, each with a stated fallback — not placeholders.
- Names used across tasks are consistent: `rtTextClear`/`rtTextReserve`, `ITextClear`/`ITextReserve`, `cgDefaultInitStrLenOnlyAt`, `cgIntrStrLenInline`/`cgIntrStrIndexInline`, `TestStrBench68k`, cases `StrPerf`/`ClearWarm`.
