# Memory-Leak Fix Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Eliminate clarusc's ~42k-blocks-per-compile memory leaks (synthetic store-temp prologue births, `.clear()` dropping reference elements) and retire the never-reset table family, so a long-lived ClarusC.APPL has bounded memory and compile #2 runs at compile-#1 speed.

**Architecture:** Three independent fix strands over the shared IR/lowering layer and both backends (cprint host lane, cg68k native lane), each pinned by leak-count tests using the host runtime's `CLARUS_MEM_STRICT` ledger; a permanent double-compile leak gate + byte-identity oracle lands first (skipped) and flips on last.

**Tech Stack:** Clarus (clarusc/*.cla), host C runtime (runtime/host), Go test harnesses (internal/), snapshot-bootstrap builds (`cc` + `clarusc/clarusc.c`).

**Reference docs:** `docs/superpowers/specs/2026-08-12-memory-leak-fix-design.md` (the spec), `docs/superpowers/specs/2026-08-12-cross-compile-degradation-findings.md` (evidence + numbers).

## Global Constraints

- Branch: `memory-leak-fix`, created from `worktree-native-perf-findings` (stacked; do NOT branch from main).
- T1 after every task: `scripts/test-task.sh` — add `--smoke` on tasks touching `runtime/` or `clarusc/` (all of them here).
- cg68k goldens re-bless: `CLARUS_CG68K_BLESS=1 go test ./internal/cg68k -count=1`; emitui goldens: see `internal/emitui`'s own test file for its regen flag (read it, don't guess).
- `internal/selfhost` needs `-timeout 30m` and is NOT in T1 — run it only where a task's gate says so.
- MacRoman warning: none of the files this plan touches carry MacRoman bytes, but if an implementer must edit a `.cla` with high-bit bytes, use `LC_ALL=C sed` + byte-diff (standing project rule).
- Snapshot bootstrap for harness builds (Go-free): `cc -O1 -I runtime/host -o build-run/clarusc clarusc/clarusc.c runtime/host/rt.c` (idempotent; reuse `build-run/clarusc` if present).
- Never run bare `git stash` (shared stash stack; use WIP commits).
- Commit after every task; main stays green — the `worktree-native-perf-findings` branch is the base and must also stay green.

---

### Task 1: Leak-gate harness + skipped Go test (RED infrastructure)

**Files:**
- Create: `testdata/leakgate/stemp.cla` (store-temp class fixture)
- Create: `testdata/leakgate/clearprobe.cla` (`.clear()` class fixture)
- Create: `clarusc/test/dblcompile.cla` (double-compile harness — promote the investigation probe, adding fork write-out; the uncommitted probe from the investigation session may already exist in the worktree — replace it with this task's version)
- Create: `internal/mactest/leakgate_test.go`

**Interfaces:**
- Produces: `TestLeakGate` with subtests `StoreTemps` (host stemp run, live==0), `ClearRefElems` (host clearprobe run, live==0), `DoubleCompile` (N=1 vs N=3 live-block growth ≈ 0 + fork byte-identity). ALL THREE skipped in this task (`t.Skip("memory-leak-fix plan: flipped on by later tasks")`); later tasks remove individual skips.
- Produces: harness contract — `dblcompile` argv = entry `.cla` paths, one compile each; per compile logs `COMPILE <i> <path> ticks=<n> fork=<len>` to stderr and writes the fork bytes to `leakfork_<i>.bin` in the cwd; exit 0 on success.

- [ ] **Step 1: Write the fixtures.** `testdata/leakgate/stemp.cla` — two-arm void function, each arm with its own counted store; taking arm A leaks arm B's prologue-birthed `__store` temp pre-fix:

```
// stemp.cla: leak-gate fixture -- synthetic __store temp prologue births
// must not leak on paths that skip their store site (findings doc
// root-cause 1). Expect zero live blocks at exit under CLARUS_MEM_STRICT.
var sink: int

func freshList(): list of int {
    var l: list of int
    return l
}

func twoArm(x: int) {
    var args: list of int

    if x >= 0 {
        args = freshList()
        args.add(x)
        sink = sink + args.count
        return
    }
    args = freshList()
    args.add(0 - x)
    sink = sink - args.count
}

on App.startCLI(args: list of string) {
    var i: int

    i = 0
    while i < 1000 {
        twoArm(i)
        i = i + 1
    }
    quit 0
}
```

`testdata/leakgate/clearprobe.cla` — `.clear()` on ref-element containers must release the elements:

```
// clearprobe.cla: leak-gate fixture -- .clear() on containers whose
// elements own heap references must release those elements (findings doc
// root-cause 2). Expect zero live blocks at exit under CLARUS_MEM_STRICT.
record Sig {
    params: list of int
}

var outer: list of list of int
var recs: list of Sig
var texts: list of text
var im: intmap of text

func freshInner(): list of int {
    var l: list of int
    return l
}

// The work happens in run(), NOT in App.startCLI: `quit` deliberately
// skips the quitting handler's own scope-exit frees (lowAppendTrailingFrees'
// documented "quit mid-handler: no frees" behavior), so ref-bearing locals
// must live in a function that RETURNS for this fixture to reach zero.
func run() {
    var i: int
    var s: Sig
    var t: text

    i = 0
    while i < 200 {
        outer.add(freshInner())
        s.params = freshInner()
        s.params.add(i)
        recs.add(s)
        t = "x"
        texts.add(t)
        im[i] = t
        i = i + 1
    }
    outer.clear()
    recs.clear()
    texts.clear()
    im.clear()
}

on App.startCLI(args: list of string) {
    run()
    quit 0
}
```

`clarusc/test/dblcompile.cla` — the investigation harness (findings doc §evidence) with fork write-out added. Same include list and seam functions as the investigation version (includes `../lib.cla` … `../drive.cla`, main.cla-style `feReadSource`/`feHasKey`/`feProgress`/`feProgressStep`/`feProgressTick`), and this `App.startCLI`:

```
on App.startCLI(args: list of string) {
    var i: int
    var entries: list of string
    var ok: bool
    var built: bool
    var t0: int
    var t1: int
    var fork: text
    var wrote: bool

    hostPaths = true
    rtDir = ""
    haveRtDir = false

    i = 0
    while i < args.count {
        t0 = TickCount()
        driveReset()
        resetDiags()
        astReset()
        wantEmit = true
        want68k = true
        entries = cgFreshStringList()
        entries.add(args[i])
        ok = driveCompile(entries, false)
        if entryFailed {
            log("dblcompile: cannot open entry file: " + args[i])
            quit 2
        }
        if not ok {
            log("dblcompile: compile FAILED: " + args[i])
            quit 1
        }
        built = driveEmit68kFork("", false, 0, false)
        if not built {
            log("dblcompile: emit68k failed: " + args[i])
            quit 1
        }
        fork = driveLastFork()
        wrote = file.writeText("leakfork_" + numToStr(i) + ".bin", fork)
        if not wrote {
            log("dblcompile: fork write failed")
            quit 1
        }
        t1 = TickCount()
        log("COMPILE " + numToStr(i) + " " + args[i] + " ticks=" + numToStr(t1 - t0) + " fork=" + numToStr(fork.length))
        i = i + 1
    }
    quit 0
}
```

- [ ] **Step 2: Write `internal/mactest/leakgate_test.go`.** Model the build helpers on `suite_host_test.go`'s existing snapshot-bootstrap pattern (read that file first; reuse its helpers if exported, otherwise mirror). Shape:

```go
package mactest

// TestLeakGate pins the memory-leak-fix phase (docs/superpowers/plans/
// 2026-08-12-memory-leak-fix.md): the compiler must not retain heap
// blocks across compiles in one process, and .clear()/store-temp
// machinery must not leak. Host-lane only (uses runtime/host's
// CLARUS_MEM_STRICT ledger); the native lane is covered by parity
// goldens + the gated suite boots.
func TestLeakGate(t *testing.T) {
    t.Run("StoreTemps", func(t *testing.T) {
        t.Skip("memory-leak-fix Task 2 flips this on")
        runLeakFixture(t, "../../testdata/leakgate/stemp.cla")
    })
    t.Run("ClearRefElems", func(t *testing.T) {
        t.Skip("memory-leak-fix Task 4 flips this on")
        runLeakFixture(t, "../../testdata/leakgate/clearprobe.cla")
    })
    t.Run("DoubleCompile", func(t *testing.T) {
        t.Skip("memory-leak-fix Task 8 flips this on")
        runDoubleCompileGate(t)
    })
}
```

`runLeakFixture`: snapshot-bootstrap `build-run/clarusc` (once, shared helper), `emit --rtdir runtime/clarus/` the fixture to a temp dir, `cc -O1 -I runtime/host` against `runtime/host/rt.c`, run with `CLARUS_MEM_STRICT=1` and `CLARUS_MEM_REPORT=<tmp>/report.txt`, parse the `##CLARUS-MEM## live=N` line, assert `N == 0` (fatal with the first 20 `rt_mem: leak` lines on failure).

`runDoubleCompileGate`: build `clarusc/test/dblcompile.cla` the same way (it is self-contained via its own includes — emit takes just the one file), run twice in a temp cwd: once with argv `[tickprobe]`, once with `[tickprobe, tickprobe, tickprobe]` (use `testdata/cg68k/tickprobe.cla` via absolute path), each with `CLARUS_MEM_STRICT=1`/`CLARUS_MEM_REPORT`. Parse both `live=` totals; assert `(live3 - live1) / 2 <= 64` (allowance for genuinely process-lifetime noted blocks). Then compare `leakfork_0.bin` vs `leakfork_2.bin` from the 3-compile run byte-for-byte (the stale-intern-index oracle).

- [ ] **Step 3: Verify the skipped test compiles and the harness actually works.** Run: `go test ./internal/mactest -run TestLeakGate -count=1 -v` → all three subtests SKIP. Then manually exercise the machinery once (temporarily comment the skips or run the helper bodies via a temp test) to confirm: stemp reports `live=2000`, clearprobe reports a four-figure live count, DoubleCompile measures growth ≈ 42,845/compile. Record the observed numbers in the task report — they are the RED baseline. Restore the skips.
- [ ] **Step 4: T1.** Run: `scripts/test-task.sh --smoke` → green.
- [ ] **Step 5: Commit.** `git add testdata/leakgate clarusc/test/dblcompile.cla internal/mactest/leakgate_test.go && git commit -m "test: leak-gate harness + skipped RED gates (memory-leak-fix Task 1)"`

---

### Task 2: No-birth flag for synthetic store temps — IR + lowering + host backend

**Files:**
- Modify: `clarusc/ir.cla` (IRLocal record ~:321, `newIRLocal` ~:1788, accessors ~:1798)
- Modify: `clarusc/lower.cla` (store-temp mint sites :2382-2383 and :2540-2541)
- Modify: `clarusc/cprint.cla` (the function-prologue local default-init site — find `cpDefaultInit`'s caller in `cpEmitFunc`; the lowReturn doc comment cites cprint.cla:3636 as the unconditional per-local call)
- Modify: `internal/mactest/leakgate_test.go` (remove `StoreTemps` skip)

**Interfaces:**
- Produces: `IRLocal.nobirth: bool`; `irLocalMarkNoBirth(i: int)` setter; `irLocalNoBirth(i: int): bool` accessor — Task 3 (cg68k) consumes these exact names.
- Contract: a no-birth local's prologue init is NULL/zero, never a container/record construction. Only lowering's `__store` temps set the flag (both mint sites); `lowNewReturnTemp` temps do NOT.

- [ ] **Step 1: IR flag.** `IRLocal` gains `nobirth: bool` (scalar field — the AST/IR arenas are deliberately scalar-only; a bool keeps that invariant). `newIRLocal` initializes it `false`. Add, next to the existing accessors:

```
func irLocalMarkNoBirth(i: int) {
    var l: IRLocal
    l = irLocals[i]
    l.nobirth = true
    irLocals[i] = l
}
func irLocalNoBirth(i: int): bool {
    return irLocals[i].nobirth
}
```

(Match the surrounding accessors' actual field-update idiom — if siblings mutate via a set-helper pattern, mirror it.)

- [ ] **Step 2: Mark the temps.** At BOTH mint sites (`lowCountedStoreRecVal` lower.cla:2382-2383, and the counted-store site :2540-2541), capture `lowAddLocal`'s return and mark it:

```
tmpNameIdx = lowNewStoreTemp()
irLocalMarkNoBirth(lowAddLocal(tmpNameIdx, t))
```

Add one comment at each site: `// no prologue birth: this temp's own store site releases-then-overwrites it (NULL-safe), and nulls it after transfer -- memory-leak-fix Task 2, findings root-cause 1.`

- [ ] **Step 3: Host backend honors the flag.** In `cpEmitFunc`'s per-local loop, the local index is in hand when `cpDefaultInit` is called; for `irLocalNoBirth(loc)` locals emit a zero init instead: containers/text → `cv_<name> = NULL;` (typed NULL cast matching the decl), KRec → `memset(&cv_<name>, 0, sizeof(cv_<name>));` (or the `(T){0}` assignment form if that's the file's existing idiom — read `cpDefaultInit`'s KStr arm and mirror). Do NOT touch `cpDefaultInit` itself (it serves globals/fields too); branch at the local-loop call site.
- [ ] **Step 4: RED→GREEN.** Remove the `StoreTemps` skip in `leakgate_test.go`. Run: `go test ./internal/mactest -run 'TestLeakGate/StoreTemps' -count=1 -v` → PASS (live=0). Also re-run the harness manually on `tickprobe` (Task 1 Step 3 procedure) and record the new DoubleCompile growth number in the task report — expect it to drop from ~42.8k to roughly the `.clear()`+class-3 residue (~5-7k/compile).
- [ ] **Step 5: Goldens + T1.** emitui goldens: regenerate per `internal/emitui`'s documented mechanism if diffs appear (prologue `= NULL` lines for `__store` temps are the expected uniform diff). Run: `scripts/test-task.sh --smoke` → green. `internal/selfhost` NOT required this task (Task 7 runs it).
- [ ] **Step 6: Commit.** `git commit -m "fix: no prologue birth for synthetic __store temps (host lane) -- memory-leak-fix Task 2"`

---

### Task 3: cg68k honors the no-birth flag

**Files:**
- Modify: `clarusc/cg68k.cla` (`cgEmitFunc`'s local walk ~:4650-4712 building `recLocalOffsets`/`recLocalTypes`, and the prologue init loop :4770-4774)
- Test: `internal/cg68k` goldens (re-bless)

**Interfaces:**
- Consumes: `irLocalNoBirth(i: int): bool` (Task 2).
- Produces: flagged locals' slots are zero-filled (CLR), never birthed, in native prologues.

- [ ] **Step 1: Track the flag through the walk.** Alongside `recLocalOffsets`/`recLocalTypes`, add `recLocalNoBirth: list of bool` (fresh via the file's `cgFreshBoolList()` idiom), filled from `irLocalNoBirth(loc)` in the same walk.
- [ ] **Step 2: Zero-init arm.** Add `cgZeroInitAt(reg: int, off: int, t: int)`: zero `cgSizeOf(t)` bytes at `off(reg)` — emit `CLR.L off(reg)` per 4 bytes, `CLR.W` for a trailing 2, `CLR.B` for a trailing 1 (use the file's `a68Emit(OpClr, ...)` form; read a neighboring emitter such as `cgStoreImmAt` :2982 for the exact addressing-mode arguments). In the prologue loop:

```
while i < recLocalOffsets.count {
    if recLocalNoBirth[i] {
        cgZeroInitAt(6, recLocalOffsets[i], recLocalTypes[i])
    } else {
        cgDefaultInitAt(6, recLocalOffsets[i], recLocalTypes[i], 0, -1)
    }
    i = i + 1
}
```

If no `OpClr` opcode exists in asm68k.cla, use `MOVE.L #0` via the existing immediate-store path instead — do not add a new opcode for this.

- [ ] **Step 3: Native parity check.** Re-bless: `CLARUS_CG68K_BLESS=1 go test ./internal/cg68k -count=1`. Inspect the diff on one golden with store temps (e.g. tickprobe segments): expect birth JSR sequences replaced by CLR/zero stores ONLY for `__store*` frame slots — any other diff is a bug, stop and investigate.
- [ ] **Step 4: T1 + smoke.** Run: `scripts/test-task.sh --smoke` → green (the two 68k emulator smokes are the native behavioral check).
- [ ] **Step 5: Commit.** `git commit -m "fix: no prologue birth for __store temps on the native lane -- memory-leak-fix Task 3"`

---

### Task 4: Element-aware `.clear()` — intrinsics, lowering dispatch, host arms

**Files:**
- Modify: `clarusc/ir.cla` (new intrinsic name constants beside the Clear quartet :3247-:3461)
- Modify: `clarusc/lower.cla` (`.clear()` lowering :1334 for list, :1360-1380 for map/intmap/sortedmap)
- Modify: `clarusc/cprint.cla` (clear arms :2635, :2912, :3402, :3582)
- Modify: `docs/clarus-language-reference.md` (`.clear()` entry)
- Modify: `internal/mactest/leakgate_test.go` (remove `ClearRefElems` skip)

**Interfaces:**
- Produces: intrinsic constants `IListClearDeep()`, `IMapClearDeep()`, `IIntMapClearDeep()`, `ISortedMapClearDeep()` (memoized interned-int helpers, byte-parallel to the existing Clear quartet). Task 5 consumes these exact names in cg68k.
- Contract: lowering emits the Deep variant iff the ELEMENT type (list) / VALUE type (maps — keys are inline strings, never released) satisfies `lowEscapeTrackableKind(irtKind(et)) or lowIsRecBearing(et) or lowArrHeapScalarBearing(et)` — the same predicate trio the container-release walk uses. Scalar elements keep the O(1) hard reset unchanged.

- [ ] **Step 1: Intrinsics.** Add the four `I*ClearDeep()` helpers in ir.cla next to their Clear siblings, same memoized-intern idiom, each with a one-line doc comment pointing at this plan.
- [ ] **Step 2: Lowering dispatch.** At lower.cla:1334 (list) and the :1360-1380 map family switch, resolve the element/value IR type (the lowering site already has the container's type; use the file's existing element-type accessor — read how `lowFor`'s container branches get element types and mirror) and pick Deep vs plain by the predicate trio above.
- [ ] **Step 3: Host Deep arms.** In cprint's intrinsic printer, add the four Deep arms beside their plain siblings. Each emits: an index loop releasing every element/value (reuse the exact per-element release emission `cpEmitRelease` uses for container teardown — factor a helper if the walk isn't already reusable; for maps iterate values via the same accessors `cpEmitRelease`'s map walk uses), THEN the plain clear call the non-Deep arm emits. Elements that are themselves containers recurse through the existing deep-release machinery — do not write a new recursion.
- [ ] **Step 4: RED→GREEN.** Remove the `ClearRefElems` skip. Run: `go test ./internal/mactest -run 'TestLeakGate/ClearRefElems' -count=1 -v` → PASS (live=0). Note: this fixture exercises host codegen only; it goes green here regardless of Task 5's native arms — natively, `.clear()`-on-ref-elements sites still leak until Task 5.
- [ ] **Step 5: Reference doc.** `.clear()` entry gains: "`.clear()` releases the elements it discards. It is O(1) for scalar element types and O(n) for reference-bearing element types (the elements are released first)."
- [ ] **Step 6: T1 + goldens.** `scripts/test-task.sh --smoke`; regenerate emitui goldens if any corpus program uses `.clear()` on ref-bearing elements. NOTE: cg68k does not yet implement the Deep intrinsics — if any cg68k golden corpus program hits a Deep arm, cg68k will fail on the unknown intrinsic; in that case swap Task 5 forward (do it before this task's golden run) rather than papering over.
- [ ] **Step 7: Commit.** `git commit -m "feat: element-aware .clear() -- deep intrinsics, lowering dispatch, host arms -- memory-leak-fix Task 4"`

---

### Task 5: Element-aware `.clear()` — native (cg68k) arms

**Files:**
- Modify: `clarusc/cg68k.cla` (clear arms :7555, :7596, :7639, :7691; element-walk machinery `cgDeepReleaseContainer` ~:3974-4069)
- Test: `internal/cg68k` goldens (re-bless)

**Interfaces:**
- Consumes: `I*ClearDeep()` intrinsic constants (Task 4).
- Produces: native `.clear()` on ref-bearing elements releases elements then hard-resets, byte-parallel semantics to the host arms.

- [ ] **Step 1: Factor the element walk.** `cgDeepReleaseContainer` runs lastref-gate → element loop → container-handle release. Extract the element loop into `cgReleaseContainerElems(...)` (same params the loop already needs) and call it from both `cgDeepReleaseContainer` and the new Deep clear arms. Byte-identical output for existing goldens is the check that the factoring is faithful — bless nothing until Step 3 confirms only Deep-arm diffs appear.
- [ ] **Step 2: Deep arms.** Beside each plain clear arm (:7555-:7691), add the Deep sibling: `cgReleaseContainerElems(...)` on the receiver, then the same runtime clear JSR the plain arm emits. Maps release VALUES only (keys are inline pool bytes reclaimed by `rtMapClear`'s `poolused=0`).
- [ ] **Step 3: Goldens + parity.** `CLARUS_CG68K_BLESS=1 go test ./internal/cg68k -count=1`; verify diffs are confined to programs using `.clear()` on ref-bearing elements (plus nothing at all if the corpus has none — then add `testdata/cg68k/` coverage: a small fixture exercising `list of text` clear, with golden, following the corpus's existing fixture+golden pattern).
- [ ] **Step 4: T1 + smoke.** `scripts/test-task.sh --smoke` → green.
- [ ] **Step 5: Commit.** `git commit -m "feat: element-aware .clear() on the native lane -- memory-leak-fix Task 5"`

---

### Task 6: Pool-index consumer audit (gate for Task 7)

**Files:**
- Create: audit table in the task report (SDD workspace), no source changes expected; any uncovered consumer found becomes a fix IN THIS TASK.

**Interfaces:**
- Produces: the verified claim "every global that stores intern-pool indices or is keyed by them is reset by the per-compile battery or provably per-call" — Task 7 depends on it.

- [ ] **Step 1: Enumerate.** Grep every `clarusc/*.cla` for module globals that (a) are `intmap of` anything (pool-index-keyed by convention), (b) store results of `intern(`, or (c) hold values later passed to `poolGet(`. For each: file:line, what resets it (function + when it runs relative to `driveReset`), or why it's per-call state (rebuilt-before-read every compile).
- [ ] **Step 2: Classify against the reset battery.** The battery after Task 7 will be: `driveReset` (incl. `libReset`), `resetDiags`, `astReset`, `checkReset` (in `checkProgram`), `irReset` (in `driveCompile`), `cgResetCodegenState`, per-run backend resets (`a68Reset`, `cpResetBuffers`, `fpReset`, `uibReset`, shake's fresh-reassigns). Anything holding pool indices ACROSS `driveReset` that is not in this battery is a finding. Known-expected findings to confirm and hand to Task 7: `shakeFuncIdxByName`, `irRcWalkNeededByName`, `irLayoutNeededByName`, `irColumnDescs`, check.cla's `windowIsForm`/`windowFormRecType`/`windowVarsHead`/`windowWidgetsHead`/`funcScopeByDecl`/`funcRetByDecl`/`funcSigByDecl`/`xrecSizeByName`/`xrecFirstDeclByName`/`menuItems`/`externFirstDeclByName`, and `rn*` interned runtime-name globals (`rnInit`-filled — check WHEN rnInit runs; if process-once, it must re-run after `libReset` or its indices go stale — this is exactly the class of bug the audit exists to catch).
- [ ] **Step 3: Front-end sweep.** Confirm neither front end interns before its reset battery runs per compile (macgui `gcCompile` :406-408 order; main.cla single-shot). Check `drvEntryName`, `driveLastAppName`/`Creator` validity windows, and macgui globals (`gcBaseLog` etc.) for pool indices held across compiles.
- [ ] **Step 4: Deliver.** Write the table + verdict into the task report. Fix any consumer with no reset story (add it to the appropriate reset function, same task, with T1 re-run).
- [ ] **Step 5: Commit** (if fixes were made): `git commit -m "fix: pool-index audit stragglers -- memory-leak-fix Task 6"`

---

### Task 7: Full per-compile reset — libReset + dependents + progGen removal

**Files:**
- Modify: `clarusc/lib.cla` (new `libReset()`; `strPool`/`strIndex` :7-8)
- Modify: `clarusc/drive.cla` (`driveReset` :463 calls `libReset()`; flip the :447-454 doc-comment exemption; re-intern/re-init anything Task 6 flagged, e.g. re-run `rnInit()` if its indices are pool-dependent — follow the audit table)
- Modify: `clarusc/shake.cla` (`shakeFuncIdxByName` — replace overwrite-not-cleared convention with a per-compile reset; update the :95-105 comment)
- Modify: `clarusc/ir.cla` (`irReset` :1023 gains `irRcWalkNeededByName`, `irLayoutNeededByName`, `irColumnDescs`; update the :756-784 comments)
- Modify: `clarusc/check.cla` (`checkReset` :5215 gains the never-reset maps listed in Task 6 Step 2; `menuItems`/`externFirstDeclByName` drop `progGen` namespacing — plain name keys; delete `progGen` and its keying concat :751-752 if no other consumer remains)
- Modify: `internal/mactest/leakgate_test.go` — no skip change here (DoubleCompile flips in Task 8), but run its helper manually (Step 3).

**Interfaces:**
- Consumes: Task 6's audit table (authoritative list of what resets where).
- Produces: `libReset()` — resets `strPool`/`strIndex` via fresh-reassign (the `driveFreshIntMap`-style local-var idiom; `.clear()` also acceptable now that Task 4 made it element-honest — but fresh-reassign is the sibling resets' existing idiom, prefer it).

- [ ] **Step 1: `libReset()` + battery wiring.** Implementation sketch:

```
// libReset (memory-leak-fix Task 7): per-compile intern-pool reset.
// Flips the historical "unbounded-growth-but-harmless" exemption
// (driveReset's doc comment) -- every table that leaned on pool-index
// stability across compiles now resets in the same battery (see the
// audit table, .superpowers/sdd/2026-08-12-memory-leak-fix/).
func libReset() {
    var p: list of string
    var ix: map of int
    strPool = p
    strIndex = ix
}
```

Call it FIRST in `driveReset()`. Apply every re-init the audit table requires (e.g. `rnInit()` re-run if flagged).

- [ ] **Step 2: Dependent resets.** shake/ir/check changes per the file list above, each with its doc comment updated to name this plan instead of the never-reset invariant. `menuItems`/`externFirstDeclByName`: plain-name keys, reset in `checkReset`; delete `progGen` outright if unreferenced afterward.
- [ ] **Step 3: The two hard gates.** (a) `go test ./internal/selfhost -count=1 -timeout 30m` → green (the differential/bootstrap suite is the stale-index detector). (b) Manually run the DoubleCompile helper procedure (Task 1 Step 3): growth per compile should now be ≤ 64 blocks AND `leakfork_0.bin` == `leakfork_2.bin` byte-identical. Record both numbers in the task report. If forks differ: STOP — that is a stale-pool-index bug; bisect via the audit table before proceeding.
- [ ] **Step 4: T1 + smoke.** `scripts/test-task.sh --smoke` → green.
- [ ] **Step 5: Commit.** `git commit -m "feat: per-compile intern-pool reset + dependent-table retirement -- memory-leak-fix Task 7"`

---

### Task 8: Flip the gate, close the phase

**Files:**
- Modify: `internal/mactest/leakgate_test.go` (remove the `DoubleCompile` skip)
- Modify: `docs/ROADMAP.md` (phase entry), `STATUS.md` (step-0 outcome), `docs/superpowers/specs/2026-08-12-cross-compile-degradation-findings.md` (per-item `[FIXED]` annotations, matching the layer1 findings-doc convention)

**Interfaces:**
- Consumes: everything above.

- [ ] **Step 1: Flip.** Remove the `DoubleCompile` `t.Skip`. Run: `go test ./internal/mactest -run TestLeakGate -count=1 -v` → all three subtests PASS.
- [ ] **Step 2: Full gates.** `scripts/test-task.sh --smoke` → green. Confirm goldens are all blessed and committed.
- [ ] **Step 3: Docs.** ROADMAP phase entry (memory-leak-fix: root causes, fix shape, measured before/after block counts from the task reports); STATUS.md updates step 0 as RESOLVED pending Snow validation; findings doc gets `[FIXED]`/`[DEFERRED]` per item (class-3 leftovers, if any, explicitly recorded).
- [ ] **Step 4: Commit.** `git commit -m "test+docs: flip leak gate green, close memory-leak-fix phase -- Task 8"`
- [ ] **Step 5: Report.** Final summary for Andrew: measured per-compile growth before/after, what Snow validation remains (STATUS steps 0-1: two-compile rerun, then the formal acceptance PASS — Andrew-gated, not run in this phase).

---

## Deferred / explicitly out of scope

- Snow hardware rerun (needs the emulator + ≥2h settle; STATUS.md step 1 procedure) — validation, Andrew schedules it.
- T2 (`scripts/test-merge.sh`) — standing pre-merge debt across all stacked phases, run before any merge, not per-task here.
- `sortedmap`'s O(n) insert/remove and the other Layer-2 items — unchanged, findings doc §Layer-2.
