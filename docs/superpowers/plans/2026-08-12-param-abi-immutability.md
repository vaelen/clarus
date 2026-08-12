# Immutable Parameters + By-Reference String/Record Param ABI — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Parameters become immutable (language change); `string`/record parameters pass by 4-byte address instead of full-slot stack copy, with call-site borrow/copy classification preserving by-value semantics.

**Architecture:** Checker gains an `isParam` symbol tag and rejects every mutating use of a parameter. Lowering classifies each KStr/KRec call argument borrow-vs-copy via a new `IRExpr.argCopy` flag (single authority); each backend then implements the by-address convention mechanically. Record copy-temps get a call-site retain/release bracket; the callee-entry retain walks (`lowRetainRecParams`) are deleted last, once both backends are by-ref.

**Tech Stack:** Clarus self-hosted compiler (`clarusc/*.cla`), host C runtime (`runtime/host`), Retro68/Mini vMac for the native lane. Spec: `docs/superpowers/specs/2026-08-12-param-abi-immutability-design.md` (READ IT FIRST — the borrow/copy table and worked examples there are normative).

## Global Constraints

- Branch: create `param-abi` from the current `memory-leak-fix` HEAD before Task 1; all commits land there.
- `.cla` files may contain MacRoman bytes. Never bulk-edit with tools that reinterpret encoding; the Edit tool is safe ONLY when the old/new strings are pure ASCII and unique. For anything else use `LC_ALL=C sed` and verify with a byte-diff (`cmp`/`xxd`). (Established project rule.)
- T1 gate after every task: `scripts/test-task.sh` (add `--smoke` when the task touches `runtime/` or `clarusc/` codegen — Tasks 5, 6, 7). T1 excludes `internal/selfhost`, so the stale bootstrap snapshot (regenerated only in Task 8) does not fail intermediate tasks.
- cg68k listing goldens re-bless: `CLARUS_CG68K_BLESS=1 go test ./internal/cg68k/... -count=1`. emitui C goldens have NO bless flag — regenerate by running `clarusc emit` per fixture and overwriting `testdata/emitui/<name>.c.golden` (Task 5 shows the exact loop).
- The KArr (fixed-array) parameter ABI is OUT OF SCOPE (spec §4): arrays keep today's behavior on both lanes (68k: hard compile error when passed; host: C struct-by-value). Immutability still applies to them in the checker.
- Kind-based rule everywhere: EVERY KStr/KRec param is by-address regardless of size (`string(3)` too) — never a size test (the `cgRetNeedsHidden` lesson, cg68k.cla:5215).
- Log the model used for every subagent dispatch (Andrew's standing request).

---

### Task 1: Create branch; migrate the 13 param-rebinding sites

**Files:**
- Modify: `clarusc/res68k.cla:242,245`, `clarusc/cg68k.cla:10076,10295`, `clarusc/lower.cla:2348,2357,2372,2527`, `clarusc/lib.cla:155`, `clarusc/drive.cla:783,785`, `runtime/clarus/native.cla:301,311`
- Test: existing T1 (`scripts/test-task.sh --smoke`); goldens re-bless below

**Interfaces:**
- Produces: a tree with zero param-rebinding sites, so Task 2's checker rule lands on a clean tree.

- [ ] **Step 1: Create the branch**

```bash
git checkout -b param-abi
```

- [ ] **Step 2: Apply the migration pattern per site**

Line numbers above are pre-edit positions of the assignments found by the 2026-08-12 scan; re-locate each by content before editing. For each function containing a `param = ...` assignment, introduce a local that shadows the param's role and rename ALL uses inside that function (not just the assignment):

```
// BEFORE (lib.cla, numToStr's digit loop — representative)
func numToStr(n: int): string {
    ...
    n = n / 10          // param rebound
    ...
}

// AFTER
func numToStr(n: int): string {
    var cur: int
    cur = n
    ...
    cur = cur / 10
    ...
}
```

Name the local for its role (`cur`, `pos2`, `rest`, `key2` ...), keep the diff minimal, and do NOT change any behavior. The two `drive.cla` sites are `string`-typed (`key = ...`) — same pattern with `var key2: string`. The `lower.cla` sites rebind a threaded `tail`/`src` param — introduce `var t2: int` / `var s2: int` initialized from the param at function top.

Sites where the scan hit is legal and must NOT be migrated: `cg68k.cla:816` (`segBits[idx]` — `list of bool` param, referent mutation), all `examples/mandelbrot.cla` / `macgui.cla` / gui.cla field-assigns (window refs).

- [ ] **Step 3: Verify no sites remain**

Run the scanner (it lives at the session scratchpad as `param_mut_scan.py`; if absent, re-run the equivalent grep-per-function check) and confirm 0 `whole`-kind sites outside reference types. Also `cc`-build the compiler and self-emit:

```bash
cc -O1 -I runtime/host -o build-run/clarusc-t1 clarusc/clarusc.c runtime/host/rt.c
build-run/clarusc-t1 emit --rtdir runtime/clarus/ -o /tmp/self1.c clarusc/*.cla
```

Expected: emits cleanly (the snapshot-built compiler compiles the EDITED source — proving the edits are valid Clarus).

- [ ] **Step 4: Re-bless cg68k goldens (native.cla is spliced into fixtures)**

```bash
CLARUS_CG68K_BLESS=1 go test ./internal/cg68k/... -count=1
git diff --stat testdata/cg68k/   # expect churn ONLY in fixtures splicing native.cla
```

- [ ] **Step 5: Run T1 and commit**

```bash
scripts/test-task.sh --smoke
git add -A && git commit -m "refactor: migrate 13 param-rebinding sites ahead of immutable params (Task 1)"
```

---

### Task 2: Checker — immutable parameters + reference update

**Files:**
- Modify: `clarusc/types.cla` (Symbol record, ~line 603), `clarusc/check.cla` (param declare sites ~2429 and ~3548; `checkAssignStmt` ~3869; `checkEditStmt` ~4341; the `askOpen`/`askSave` builtin path), `clarusc/lower.cla:987` area only if the fill-target check lands lowering-side (prefer checker-side)
- Modify: `docs/clarus-language-reference.md` (Parameter Passing section, line ~755)
- Test: `clarusc/test/check_test.cla` + regenerate `clarusc/test/check_test.out`; new `testdata/errors/param_assign.cla` + `.expect`

**Interfaces:**
- Consumes: Task 1's migrated tree (otherwise the new rule breaks the build).
- Produces: `Symbol.isParam: bool` (types.cla), set `true` at both param-declare sites; diagnostic string exactly `cannot assign to parameter <name>`. Task 4's suite cases and Tasks 5-7 rely on the guarantee "no param is ever a mutation target."

- [ ] **Step 1: Write the failing tests first**

Append to `clarusc/test/check_test.cla` (follow the existing `// Case N` + `runCase` pattern, check_test.cla:1632 holds the last case). Cases to add — expected diagnostic in a comment beside each:

```clarus
// Case 130: param rebind (int) -> "cannot assign to parameter x"
src = ""
ln(src, "func f(x: int): int {")
ln(src, "    x = x + 1")
ln(src, "    return x")
ln(src, "}")
runCase("param-rebind-int", src)

// Case 131: param rebind (string) -> same diagnostic
// Case 132: field-assign through record param -> rejected
//   record R { n: int } ; func f(r: R) { r.n = 1 }
// Case 133: index-assign through string param: func f(s: string) { s[0] = 'H' } -> rejected
// Case 134: index-assign through fixed-array param: func f(a: int[3]) { a[0] = 1 } -> rejected
// Case 135: LEGAL: text param element write: func f(t: text) { t[0] = 'H' } -> clean
// Case 136: LEGAL: list param mutation: func f(l: list of int) { l.add(1) } -> clean
// Case 137: LEGAL: local record field assign inside func with a param of same type -> clean
// Case 138: edit-statement target is a param -> rejected (needs a window+form fixture;
//   follow an existing checkEditStmt-exercising case's boilerplate)
// Case 139: askSave(p, "x") where p is a bare string param -> rejected (fill-target)
// Case 140: "cannot assign to constant" (closes the zero-coverage gap found 2026-08-12)
//   const k: int = 1 inside a func file scope; k = 2 -> rejected
```

Write ALL cases as real source (the sketches above name the exact shapes; expand each into `ln(src, ...)` lines like Case 130).

- [ ] **Step 2: Run to verify current failure mode**

Build and run the module test driver the way `internal/selfhost/modules_test.go` does:

```bash
build-run/clarusc-t1 emit --rtdir runtime/clarus/ -o /tmp/check_test.c \
    clarusc/lib.cla clarusc/tok.cla clarusc/lex.cla clarusc/ast.cla clarusc/parse.cla \
    clarusc/types.cla clarusc/check.cla clarusc/test/check_test.cla
```

(If the exact file list differs, copy it from `modules_test.go`'s driver recipe.) Run it; expected: the new mutating cases print `clean` (rule absent) — i.e. the golden comparison would FAIL. Do not regenerate the golden yet.

- [ ] **Step 3: Implement**

(a) `types.cla` Symbol record — add the field after `isConst`:

```clarus
    isParam: bool
```

(b) Both param-declare loops (`checkFuncSig` ~check.cla:2429, `checkHandlerBody` ~3548) — where `psym.isConst = false` is set, add `psym.isParam = true`.

(c) `checkAssignStmt` (~3869), right after the existing isConst branch:

```clarus
    if symIdx != -1 and symbols[symIdx].isParam {
        // Rebinding (LHS root ident IS the target) is always banned.
        // Stores THROUGH the param (field/index) are banned only for
        // value-typed params; reference types keep referent mutation.
        if lhsIsBareIdent or symTypeIsValueKind(symbols[symIdx].typeIdx) {
            emitDiag(stmtLine(s), stmtCol(s), "cannot assign to parameter " + poolGet(identName(rootIdent)))
            return
        }
    }
```

`lhsIsBareIdent` = the LHS expression is the root identifier itself (no field/index wrapper); derive it from the same lvalue walk `lvalueRootIdent` performs. `symTypeIsValueKind(t)` = type resolves to a record, fixed array, or string (`TyRec`/`TyArr`/`TyStr` — confirm exact `types.cla` kind names before writing). Rebinding is banned for ALL param types including reference types.

(d) `checkEditStmt` (~4341): after the target is resolved, if the target's root ident resolves to a symbol with `isParam`, emit the same diagnostic.

(e) `askOpen`/`askSave` fill-targets: both are `declBuiltinFunc2` registrations (check.cla:1351-1352) flowing through the generic `checkArgsCall`. In `checkIdentCall`'s builtin dispatch (find where the callee name is known alongside the arg exprs), for these two names check arg 0 (`askOpen`)/arg 0 (`askSave` — the fill path is the FIRST arg for both; verify against reference:757's `askSave(path, suggested)` wording): if it is a bare identifier resolving to an `isParam` symbol, emit `cannot assign to parameter <name>`.

- [ ] **Step 4: Run tests, regenerate golden**

Re-run the Step 2 driver; verify every new mutating case now prints the diagnostic and every LEGAL case prints `clean`. Then capture stdout as the new golden:

```bash
/tmp/check_test_bin > clarusc/test/check_test.out
```

Add `testdata/errors/param_assign.cla` (a whole program with one param rebind) and hand-write `param_assign.expect` with the exact `path:line:col: cannot assign to parameter ...` line `clarusc emit` prints (run it once to capture the exact format).

- [ ] **Step 5: Update the language reference**

In the Parameter Passing section (reference:755): state that parameters are immutable bindings; rebinding or storing through a value-typed parameter is a build-time error; referent mutation through reference-typed parameters remains legal; note the diagnostic string. Keep it to one tight paragraph matching the spec's §1.

- [ ] **Step 6: T1 and commit**

```bash
scripts/test-task.sh
git add -A && git commit -m "feat: immutable parameters -- checker rule, tests, reference (Task 2)"
```

---

### Task 3: IR + lowering — per-arg borrow/copy classification (no behavior change)

**Files:**
- Modify: `clarusc/ir.cla` (IRExpr record ~306; accessors near `irLocalMarkNoBirth` ~2010)
- Modify: `clarusc/lower.cla` (`lowCallArgs` 893-940)
- Test: T1 unchanged-behavior gate (goldens must NOT churn this task)

**Interfaces:**
- Produces: `IRExpr.argCopy: bool` with accessors `irArgMarkCopy(i: int)` / `irArgNeedsCopy(i: int): bool` (the `IRLocal.nobirth` pattern, ir.cla:2010-2016). Set ONLY on KStr/KRec argument expressions in user-function call chains. Tasks 5 and 6 read it; backends ignore it this task.

- [ ] **Step 1: Add the field + accessors**

`IRExpr` (ir.cla:306) gains `argCopy: bool` (last field). Accessors modeled exactly on the nobirth pair:

```clarus
func irArgMarkCopy(i: int) { irExprs[i].argCopy = true }
func irArgNeedsCopy(i: int): bool { return irExprs[i].argCopy }
```

New-expr constructors need no change (Clarus record defaults zero/false the field).

- [ ] **Step 2: Classify in lowCallArgs**

In `lowCallArgs` (lower.cla:893-940), after each arg is lowered (post-`lowCoerceStr`, lower.cla:929), when the arg's IR type kind is KStr or KRec, apply the spec §3 table:

```clarus
// lowArgNeedsCopy: spec table, single authority. Walk field/index
// wrappers to the root; borrow only when every step stays in
// value-typed (KStr/KRec/KArr) storage rooted at a non-global VarRef.
func lowArgNeedsCopy(e: int): bool {
    var k: IRExprKind
    var cur: int

    cur = e
    k = irExprKind(cur)
    while k == EFieldRef or k == EIndexRef {
        if not lowIsValueKind(irExprType(irExprBase(cur))) {
            return true       // heap/container step (list element etc.)
        }
        cur = irExprBase(cur)
        k = irExprKind(cur)
    }
    if k == EVarRef {
        return irVarRefGlobal(cur)   // global -> copy; local/param -> borrow
    }
    return false                     // EStrConst, rvalue temps: borrow
}
```

`irExprBase` = the accessor for a field/index ref's base expression (confirm the real name in ir.cla — the EFieldRef/EIndexRef constructors show which slot holds the base). `lowIsValueKind(t)` = kind is KStr, KRec, or KArr. Call `irArgMarkCopy(le)` when true. Apply to user-function calls only (`lowCallArgs`) — NOT to extern calls (unchanged ABI) or intrinsic args.

- [ ] **Step 3: Prove no behavior change**

```bash
scripts/test-task.sh
go test ./internal/cg68k/... -count=1     # goldens must pass UNBLESSED
```

Expected: everything green with zero golden churn (flag is set but unread).

- [ ] **Step 4: Commit**

```bash
git add -A && git commit -m "feat: IR argCopy flag + lowering borrow/copy classification (Task 3)"
```

---

### Task 4: Core-suite aliasing guard cases (pass before AND after the flip)

**Files:**
- Create: `testsuite/core/cases_param.cla`
- Modify: `testsuite/core/runner.cla` (enum before `SelfCheck`, `coreCaseName` arm, dispatch branch, `nCoreCases` 58 → 61)
- Test: host core CLI run (compose recipe in CLAUDE.md)

**Interfaces:**
- Consumes: nothing new — cases are written against TODAY'S by-value semantics and must be behavior-invariant across Tasks 5-7.
- Produces: `CoreTest` members `ParamAliasGlobal`, `ParamAliasHandle`, `ParamBorrowChain`; case functions `caseParamAliasGlobal()`, `caseParamAliasHandle()`, `caseParamBorrowChain()` returning `TestResult` via `tkPass`/`tkFail`.

- [ ] **Step 1: Write the cases**

```clarus
// cases_param.cla -- by-value parameter semantics under aliasing.
// These cases guard the param-abi phase's borrow/copy classification:
// they must pass IDENTICALLY under the old (full-copy) and new
// (by-address + call-site copy) conventions.

record PDoc {
    title: string
    body: text
}

var pgName: string
var pgDoc: PDoc

func paramReadAfterGlobalWrite(s: string): string {
    var out: string
    pgName = "MUTATED"        // reassign the global mid-call
    out = s                   // param must still hold the OLD value
    return out
}

func caseParamAliasGlobal(): TestResult {
    pgName = "original"
    if paramReadAfterGlobalWrite(pgName) != "original" {
        return tkFail("ParamAliasGlobal", "param aliased global write")
    }
    return tkPass("ParamAliasGlobal")
}

func paramHandleAfterGlobalWrite(d: PDoc): string {
    var fresh: PDoc
    pgDoc = fresh             // releases the global's old handles
    return toString(d.body)   // param's handle must still be alive
}

func caseParamAliasHandle(): TestResult {
    pgDoc.title = "t"
    pgDoc.body.add("alive")
    if paramHandleAfterGlobalWrite(pgDoc) != "alive" {
        return tkFail("ParamAliasHandle", "handle died under aliasing")
    }
    return tkPass("ParamAliasHandle")
}

func chain2(s: string): string { return s }
func chain1(s: string): string { return chain2(s) }

func caseParamBorrowChain(): TestResult {
    var loc: string
    loc = "chained"
    if chain1(loc) != "chained" {
        return tkFail("ParamBorrowChain", "borrow chain corrupted value")
    }
    return tkPass("ParamBorrowChain")
}
```

Adjust helper names (`toString` on a `text` — use the suite's existing text-to-string idiom from `cases_text.cla`) and record-with-`text`-field construction to match real suite conventions before committing; the assertions above are the contract.

- [ ] **Step 2: Wire into the runner**

Follow the 5-step recipe: enum members before `SelfCheck`; `coreCaseName` arms returning the exact names; dispatch branches (`if wantAll or coreHas(deduped, ParamAliasGlobal) { results.add(caseParamAliasGlobal()) casesRun = casesRun + 1 }`); `nCoreCases` 58 → 61. Check `internal/mactest/coresuite_test.go`'s own count cross-check (comment near line 44) and update if it hardcodes 58.

- [ ] **Step 3: Run on host, then T1, commit**

```bash
cc -O1 -I runtime/host -o build-run/clarusc clarusc/clarusc.c runtime/host/rt.c
build-run/clarusc emit --rtdir runtime/clarus/ -o /tmp/core_cli.c \
    testsuite/kit.cla testsuite/core/runner.cla testsuite/core/cases_*.cla testsuite/core/cli.cla
cc -O1 -I runtime/host -o /tmp/core_cli /tmp/core_cli.c runtime/host/rt.c
/tmp/core_cli all
scripts/test-task.sh
git add -A && git commit -m "test: core-suite param aliasing guards ahead of ABI flip (Task 4)"
```

Expected: all 61 cases pass (semantics are unchanged so far).

---

### Task 5: cprint — by-reference KStr/KRec parameters (host lane flips)

**Files:**
- Modify: `clarusc/cprint.cla` — `cpFuncProto` (4205-4256), `cpEmitFunc` (4998+), `fpExpr` EVarRef case (1106-1108), `fpCallFn` (1205-1240), `fpStrAddr` (~1248), the EFieldRef/EIndexRef base builders
- Test: emitui goldens regenerated; leak gate; core CLI; T1 `--smoke`

**Interfaces:**
- Consumes: `irArgNeedsCopy(argExprIdx)` (Task 3); by-ref params identified by walking `irFuncParamsHead` and testing kind KStr/KRec.
- Produces: emitted C where KStr/KRec params are `const clar_str_N *` / `const clar_rec_X *`; every use site reads `(*cv_name)`. `lowRetainRecParams`'s entry retains still emit and stay balanced (retain-then-release through the pointer) — they are removed in Task 7, not here.

- [ ] **Step 1: Param declaration + a by-ref name set**

`cpFuncProto`: for a param whose IR type kind is KStr or KRec emit `"const " + cpCType(t) + " *cv_" + name`. `cpEmitFunc`: build a per-function set (map keyed by param name) of by-ref param names before emitting the body; clear it at function end.

- [ ] **Step 2: Use sites**

`fpExpr` EVarRef case: if the name is in the by-ref set, return `toText("(*cv_" + poolGet(irVarRefName(e)) + ")")` — always parenthesized so `(*cv_p).f` and `(*cv_p).b[i]` compose. Audit every OTHER site that constructs `"cv_" + name` (grep `"cv_"` in cprint.cla) — `fpStrAddr`, field/index base builders, retain/release emission — and route them through one shared helper so the deref logic exists once:

```clarus
func fpVarText(nameIdx: int): text {
    if cpByRefParams.has(poolGet(nameIdx)) {
        return toText("(*cv_" + poolGet(nameIdx) + ")")
    }
    return toText("cv_" + poolGet(nameIdx))
}
```

`&(*cv_p)` is legal C and correct — do not special-case address-of.

- [ ] **Step 3: Call sites**

`fpCallFn`: for each KStr/KRec arg:
- `irArgNeedsCopy(a)` false → emit `&` + the arg's addressable form (`&(*cv_p)` for by-ref params collapses via fpVarText; `&cv_local`; `&clar_lit_N` for EStrConst — host literals are full `clar_str_255`, safe to borrow; rvalue temps: materialize via the existing tracked-temp machinery — `fpNewTrackedTmp` family — then `&__tmp`).
- true → hoist a statement-level temp copy using the SAME tracked-temp machinery the call-result path uses (cprint.cla:1234-1238 and `fpStmtTmps`/`fpStmtTmpRel`): `clar_str_255 __pa_N = <src expr>;` then pass `&__pa_N`. For a handle-bearing record temp, emit the record's retain call after the copy and register the release via `fpStmtTmpRel` (mirroring how call-result temps are released today).

- [ ] **Step 4: Handler-invocation audit**

```bash
grep -n "clar_fn_" runtime/host/*.h runtime/host/*.inc runtime/host/*.c | grep -v "^Binary"
```

Verify no host C runtime code calls a generated `clar_fn_*` function with a str/rec argument directly (handlers are dispatched from Clarus-side ui*.cla code). If any site exists, it must be updated to pass an address — report it in the task summary either way.

- [ ] **Step 5: Regenerate emitui goldens, run gates**

```bash
cc -O1 -I runtime/host -o build-run/clarusc clarusc/clarusc.c runtime/host/rt.c
for f in testdata/emitui/*.cla; do
    build-run/clarusc emit --testapi --rtdir runtime/clarus/ -o "${f%.cla}.c.golden" "$f"
done
```

CAUTION: check `internal/emitui/emitui_test.go` first for the exact emit flags per fixture (some may not use `--testapi`) — the goldens must be regenerated with IDENTICAL flags to what the test uses. Then:

```bash
scripts/test-task.sh --smoke
CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestLeakGate -count=1
/tmp/core_cli all       # rebuilt with the new compiler, all 61 pass
```

Leak gate must report 0 growth/compile (entry retains still balanced; call-site brackets balanced).

- [ ] **Step 6: Commit**

```bash
git add -A && git commit -m "feat: cprint by-ref KStr/KRec params + call-site borrow/copy (Task 5)"
```

---

### Task 6: cg68k — by-reference KStr/KRec parameters (native lane flips)

**Files:**
- Modify: `clarusc/cg68k.cla` — `cgEmitFunc` param block (4727-4779, frame tables 4890-4892), `cgVarOff`/`cgVarReg`/`cgFindFrameOffset` area (5110-5160), `cgExprAddr` EVarRef arm (5290+), `cgPushArgs` (8775-8806), `cgPushArgMaterialized` (8860-8916), `cgCallFnScalar` (9017-9071) / `cgCallFnInto` (9077-9091), plus a new `cgArgSlotSize` helper beside `cgRetNeedsHidden` (5226)
- Test: cg68k goldens re-blessed; T1 `--smoke`; suite GUI boot via smoke

**Interfaces:**
- Consumes: `irArgNeedsCopy`; `cgEmitRecWalkCall(isRetain, reg, off, recNameIdx)` (3431); `cgAllocTmpOff`/`cgMaterializeToTemp` (5255+); `cgVarRefAt` (5245).
- Produces: the by-address native ABI. New single-authority helper:

```clarus
// cgArgSlotSize: bytes a call argument of type t occupies on the
// stack. KStr/KRec pass by ADDRESS (param-abi phase) -- 4 bytes --
// regardless of size (kind test, never size: the cgRetNeedsHidden
// lesson). Everything else keeps cgSlotSizeOf.
func cgArgSlotSize(t: int): int {
    if irtKind(t) == KStr or irtKind(t) == KRec {
        return 4
    }
    return cgSlotSizeOf(t)
}
```

- [ ] **Step 1: Callee side — param offsets + by-ref frame bit**

In `cgEmitFunc`'s param block, use `cgArgSlotSize` instead of `cgSlotSizeOf` for the reverse-order offset walk. Add a parallel `frameIsRef: list of bool` populated `true` for KStr/KRec params, `false` for every local and scalar param; assign to a new `cgCurFrameIsRef` beside the other three `cgCurFrame*` tables (5133 area and 4890-4892). `cgVarRefAt` (synthetic scratch refs) appends `false`.

- [ ] **Step 2: Callee side — dereference on access**

`cgExprAddr`'s EVarRef arm currently emits `LEA off(reg),A0`. Change to: if the frame entry's by-ref bit is set, emit `MOVEA.L off(A6),A0` instead (the slot HOLDS the address). All string/record reads, field refs, retain walks, and stores route through `cgExprAddr`/`cgFieldRefAddr`, so this single arm is the whole callee-side read path — verify by grepping cg68k.cla for other direct `cgVarOff`+`OpLea` pairs on KStr/KRec-typed VarRefs and route any stragglers through `cgExprAddr`.

- [ ] **Step 3: Caller side — cgPushArgs**

Rewrite the KStr/KRec branch:

```
if irtKind(t) == KStr or irtKind(t) == KRec {
    if cgIsAddressableArgShape(a, irtKind(t)) and not irArgNeedsCopy(a) {
        cgExprAddr(a)                                  // A0 = source
        a68Emit(OpMove, 4, AmAn, 0, 0, AmPreDec, 7, 0) // push A0
    } else {
        // copy/materialize into a big-pool temp, push ITS address
        tmpRef = cgMaterializeToTemp(a)                // existing helper
        if irtKind(t) == KRec and irRecHasHandleField(...) {
            cgEmitRecWalkCall(true, 6, cgVarOff(tmpRef), recNameIdx)  // retain
            <record (off, recNameIdx) in a per-call release list>
        }
        cgExprAddr(tmpRef)
        a68Emit(OpMove, 4, AmAn, 0, 0, AmPreDec, 7, 0)
    }
    total = total + 4
}
```

(Exact record-name plumbing: `irtKind`→`KRec` args carry their record's layout name via the IR type — reuse whatever `cgEmitStoreRec` uses to find `recNameIdx`.) `cgPushArgs` gains an out-param-style mechanism for the release list — a module-level `cgPendingArgReleases: list of int` (paired off/recNameIdx entries) reset per call, since user functions cannot fill out-params.

`cgPushArgMaterialized`'s reserve-final-stack-slot trick no longer applies to KStr/KRec (their stack slot is 4 bytes) — for those kinds route to `cgMaterializeToTemp` as above; keep the existing function for any remaining callers.

- [ ] **Step 4: Caller side — call emission + post-call releases**

`cgCallFnScalar` and `cgCallFnInto`: after `cgCallFunc(fi)` + `cgCleanupStack(total)`, walk `cgPendingArgReleases` and emit `cgEmitRecWalkCall(false, 6, off, recNameIdx)` per entry, then clear it. Verify nested-call safety: `cgMaterializeCallResult` re-enters the call path (8950+), so save/restore `cgPendingArgReleases` around inner calls (the cg68k.cla:1360-1372 doc comment describes exactly this reentrancy pattern for arg pushing — follow it).

- [ ] **Step 5: Literal-borrow safety verification**

68k pool literals are COMPACT (cg68k.cla:11274-11298). Borrowing `&literal` is safe only if no emitted code block-copies more than `len+1` bytes FROM a borrowed string source. Check `cgEmitStoreStr`'s copy mechanism (does it go through `rtStrStore`, which is length-aware — read `runtime/clarus/str.cla`'s `rtStrStore` — or a raw `cgBlockCopy` of capacity bytes?):
- If ALL string stores are length-aware: EStrConst borrow is safe; document the finding in a code comment at the `cgPushArgs` EStrConst path.
- If ANY capacity-sized copy from a string source exists: make cg68k treat `EStrConst` args as materialize-first (backend-local override — the IR flag stays lane-neutral), and note it in the task summary.

- [ ] **Step 6: Re-bless, gates, commit**

```bash
CLARUS_CG68K_BLESS=1 go test ./internal/cg68k/... -count=1
scripts/test-task.sh --smoke
git add -A && git commit -m "feat: cg68k by-ref KStr/KRec params -- by-address ABI (Task 6)"
```

Review the golden diff before committing: call sites should SHRINK (no block-copy loops); callee prologues grow a MOVEA per param access.

---

### Task 7: Delete callee-entry param retains (`lowRetainRecParams`)

**Files:**
- Modify: `clarusc/lower.cla` — remove `lowRetainRecParams` (4061-4094), its calls at 4147 (`lowFuncBody`) and 5080 (`lowHandlerFunc`), and `lowPrependStmts` if now unused
- Test: leak gate, both suites, T1 `--smoke`, goldens re-bless

**Interfaces:**
- Consumes: Tasks 5+6 (both backends by-ref — an entry retain through the pointer was balanced but wasteful; deleting it is only sound once NO backend copies params by value).
- Produces: borrowed params with zero RC traffic. `lowFreeNames` no longer contains params.

- [ ] **Step 1: Delete and re-wire**

Remove the function and both call sites (the `lowPrependStmts` splice of its return). If `lowPrependStmts` has no other caller, delete it too. The KArr arm (`lowArrHeapScalarBearing`) is also deleted: array params are still passed by C value-copy on the host lane, but immutability (Task 2) now forbids the slot-store mutation that made the unretained alias hazardous, and the callee's copy is never released (params are no longer in `lowFreeNames`) — ownership stays with the caller. State this reasoning in the commit message.

- [ ] **Step 2: Gates — the leak gate is the proof**

```bash
scripts/test-task.sh --smoke
CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestLeakGate -count=1
/tmp/core_cli all      # rebuilt; ParamAliasHandle is the live guard here
CLARUS_CG68K_BLESS=1 go test ./internal/cg68k/... -count=1
```

Leak gate: 0 growth/compile. If it reports NEGATIVE balance (over-release), the deleted retain was load-bearing somewhere — stop and investigate rather than re-blessing.

- [ ] **Step 3: Commit**

```bash
git add -A && git commit -m "perf: delete callee-entry param retain/release walks (Task 7)"
```

---

### Task 8: Close-out — snapshot regen, selfhost, perf evidence, docs

**Files:**
- Modify: `clarusc/clarusc.c` (regenerated), `docs/superpowers/specs/2026-08-10-native-compiler-performance-findings.md` (§2.1 annotation), `docs/ROADMAP.md` (phase entry), `STATUS.md`
- Test: `internal/selfhost` full run

**Interfaces:**
- Consumes: all prior tasks.
- Produces: a mergeable branch (pending T2 + Andrew's call).

- [ ] **Step 1: Regenerate the bootstrap snapshot to fixed point**

Follow `internal/selfhost/fixedpoint_test.go` / `TestSnapshotFixedPoint`'s printed regeneration instructions (Go-free recipe). Iterate until emit-of-self is byte-stable, then commit the new `clarusc/clarusc.c`.

- [ ] **Step 2: Full selfhost gate**

```bash
go test ./internal/selfhost -count=1 -timeout 30m
```

Expected: green, including `TestSnapshotFixedPoint`, `TestClarusModules` (check_test.out updated in Task 2), `TestErrorGoldens` (param_assign fixture).

- [ ] **Step 3: Perf evidence (10-pair interleaved medians, layer1 procedure)**

Benchmarks, old-vs-new binary pairs: host self-compile (`emit clarusc/main.cla`), `emit68k testdata/cg68k/tickprobe.cla`, frozen-fixture `emit68k` macro (`/tmp/l1src` procedure from the layer1 phase), peak RSS for the emit68k pair. Record the table in the ledger and STATUS.md.

- [ ] **Step 4: Docs + commit**

Annotate findings §2.1 `[FIXED — param ABI; storage unchanged, see spec]`; add the ROADMAP phase entry (design-first record: spec + plan paths, task ledger, measured results); update STATUS.md next-steps (artifacts phases unblocked). Commit.

---

## Verification summary (phase-level)

| Oracle | Task(s) | What it proves |
|---|---|---|
| check_test.cla golden + errors fixture | 2 | immutability enforced, legal referent mutation preserved |
| Core suite 61 cases (3 new aliasing guards) | 4-7 | by-value semantics survive the ABI flip |
| Leak gate `DoubleCompile` 0-growth | 5, 7 | RC balance after retain-walk deletion + call-site brackets |
| cg68k goldens (re-blessed, diff-reviewed) | 1, 6, 7 | intended codegen change only |
| emitui goldens (regenerated, diff-reviewed) | 5 | intended C ABI change only |
| Selfhost + snapshot fixed point | 8 | the compiler compiles itself under the new ABI |
| Perf table | 8 | the point of the phase |
