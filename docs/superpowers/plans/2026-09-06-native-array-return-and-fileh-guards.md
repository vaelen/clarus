# native-array-return-and-fileh-guards Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Close the five remaining entries in `docs/TODO.md`'s "Compiler correctness / cleanup" and "Runtime / Toolbox robustness" sections: native (`emit68k`) returns of scalar-element fixed arrays, named diagnostics for handle-bearing arrays, no-op stores for zero-valued explicit global initializers, a `file.rename("", x)` guard, and the host AppleDouble sidecar minors.

**Architecture:** Three compiler tasks edit `clarusc/cg68k.cla` only (the host C lane already handles every shape); the array-return work rides on the existing hidden-result-pointer convention by adding `KArr` to its one kind predicate and giving the whole-array copy helper the same call fast path the record helper has. Two runtime tasks touch the shared `runtime/clarus/fileh.cla` (both lanes) and the host-only `runtime/host/rt_fileh.inc`. Each task carries its own test: a cg68k `.s` golden, fail-closed emit cases, a core-suite case run on both lanes, or the host C harness.

**Tech Stack:** Clarus (clarusc is self-hosted: `clarusc/*.cla`), 68000 assembly emitted by `cg68k.cla`, C99 host runtime, POSIX-sh test harness (`tests/`, `make test T=...`).

**Spec:** `docs/superpowers/specs/2026-09-06-native-array-return-and-fileh-guards-design.md`

## Global Constraints

- Branch `native-array-return-and-fileh-guards` off `main`; `main` stays green; merge only on Andrew's request.
- Never edit `clarusc/bake.cla` or `clarusc/macgui.cla` (either fires the 30-minute Snow `clarusc_bake` gate; the spec keeps both out of scope).
- Handle-bearing element arrays (a `text`/`list`/`map` anywhere inside the element, recursively) stay unsupported as native returns and by-value copies. They get diagnostics, not codegen.
- `close()` stays void on both lanes (spec §6).
- All `.cla` files here are pure ASCII (checked 2026-09-06), so the Edit tool is safe; if a task touches any other `.cla`, run `LC_ALL=C grep -c $'[\x80-\xff]' FILE` first and use `sed` if it is non-zero (MacRoman bytes).
- Case counts for the core suite are hand-maintained in FIVE places (CLAUDE.md "core/toolbox test suites"): `testsuite/core/runner.cla`'s `nCoreCases`, `tests/mactest/coresuite_68k.sh` and `coresuite_mac.sh`'s `suite_report_check` literals, `tests/testsuite/core_cases.txt`, and CLAUDE.md itself. Task 3 bumps all five.
- Golden blessing is `CLARUS_CG68K_BLESS=1` set to exactly `1`. Review every bless diff hunk by hunk before committing it.
- Per-task gate: `scripts/test-task.sh --smoke` (T1 plus the two emulator boots; every task here touches `clarusc/` or `runtime/`). Before merge: `scripts/test-merge.sh` (T2).
- Compiler bootstrap for ad-hoc runs: `make -j tools bootstrap` builds `build-run/clarusc-current`; `scripts/clarus-run.sh FILE.cla` runs a program on the host lane.
- Commit subjects follow the repo's `area: summary` style (`cg68k: ...`, `test(cg68k): ...`, `runtime(fileh): ...`, `docs: ...`). Every commit ends with the two trailer lines the session's attribution block requires.

---

### Task 0: Branch

**Files:** none.

- [ ] **Step 1: Create the branch**

```bash
cd /Users/andrew/repos/clarus
git checkout -b native-array-return-and-fileh-guards main
make -j tools bootstrap
```

Expected: `build-run/clarusc-current` and `build-run/clarusc-snapshot` exist and `git status` is clean apart from the already-committed triage edits.

---

### Task 1: Native array returns, scalar elements (spec §2)

**Files:**
- Modify: `clarusc/cg68k.cla` — `cgRetNeedsHidden` (~line 6141), `cgEmitReturnErr`'s neighbourhood (~line 6912, add `cgEmitReturnArr` after it), `cgEmitStoreArr` (~line 6854), `cgReturnStmt` (~line 12720), `cgCallFnScalar`'s discard arm (~line 10615)
- Create: `testdata/cg68k/karr_return.cla`
- Test: `tests/cg68k/goldens.sh` (existing driver, picks the new fixture up automatically), `tests/cg68k/vasm.sh` (existing, round-trips every fixture)

**Interfaces:**
- Consumes: `cgNeedsRelease(t: int): bool`, `cgCallFnInto(e: int, dst: int)`, `cgBlockCopy(sz: int)`, `cgExprAddr(e: int)`, `cgCurRetType: int`, `cgSizeOf(t: int): int`, `irExprKind(e: int): IRExprKind`, `irtKind(t: int): IRKind`, all already in `cg68k.cla`/`ir.cla`.
- Produces: `cgRetNeedsHidden` true for a handle-free `KArr`; `func cgEmitReturnArr(src: int)`; `cgEmitStoreArr` accepting an `ECallFn` source. Task 2 relies on `cgRetNeedsHidden` being false for a handle-bearing `KArr` return.

- [ ] **Step 1: Write the golden fixture (the failing test)**

Create `testdata/cg68k/karr_return.cla`:

```
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// karr_return.cla (native-array-return-and-fileh-guards, spec %2): the
// KArr RETURN ABI's own `.s` golden, karr_param.cla's sibling. A
// scalar-element fixed array returns through the same hidden result
// pointer a record does (cgRetNeedsHidden), block-copied by
// cgEmitReturnArr; every consumer shape funnels into cgEmitStoreArr's
// ECallFn arm and from there into cgCallFnInto:
//   - `mk()` bare        : a discarded call -- cgCallFnScalar's discard
//                          arm parks the result in a tracked big-pool temp.
//   - `b = mk()`         : SAssign's KArr arm.
//   - `sum4(mk())`       : cgPushArgs -> cgMaterializeToTemp.
//   - `return mk()`      : cgEmitReturnArr -> cgExprAddr's materialize
//                          fallback (fwd below).

func mk(): int[4] {
    var a: int[4]

    a[0] = 1
    a[1] = 2
    a[2] = 3
    a[3] = 4
    return a
}

func sum4(a: int[4]): int {
    return a[0] + a[1] + a[2] + a[3]
}

func fwd(): int[4] {
    return mk()
}

func runKarrReturn(): int {
    var b: int[4]

    mk()
    b = mk()
    return sum4(b) + sum4(mk()) + sum4(fwd())
}

on App.launch {
    if runKarrReturn() == 0 {
        return
    }
}
```

- [ ] **Step 2: Confirm the fixture is a valid program on the host lane, and that the native lane rejects it today**

```bash
scripts/clarus-run.sh testdata/cg68k/karr_return.cla; echo "host exit $?"
build-run/clarusc-current emit68k --rtdir runtime/clarus/ -o /tmp/kr.bin testdata/cg68k/karr_return.cla 2>&1 | grep -v '^\['
```

Expected: host exit 0 (the program logs nothing, it only computes); native prints `cg68k: cgExpr: EVarRef non-scalar (str/rec/arr) reached in value context ...` or the `has no address on this backend` guard message. Either is the failing state.

- [ ] **Step 3: Widen `cgRetNeedsHidden`**

In `clarusc/cg68k.cla`, replace the function body and extend its doc comment's last sentence:

```
// ...return side). native-array-return-and-fileh-guards (spec %2): KArr
// joins the set when its element carries no handle -- the same boundary
// cgParamByRef draws for the parameter ABI, so an array that can be
// passed by address can also be returned through the hidden pointer,
// and a handle-bearing one can do neither (cgEmitFunc names it).
func cgRetNeedsHidden(retTy: int): bool {
    var k: IRKind

    k = irtKind(retTy)
    if k == KStr or k == KRec or k == KErr {
        return true
    }
    return k == KArr and not cgNeedsRelease(retTy)
}
```

Also delete the parenthetical `(cgRetNeedsHidden is KStr/KRec/KErr)` and the sentence "because a function CANNOT return an array through the hidden result pointer on this backend" from `cgEmitStoreArr`'s doc comment; replace that sentence with: "an ECallFn source routes to cgCallFnInto below (native-array-return-and-fileh-guards, spec %2), the same fast path cgEmitStoreRec has".

- [ ] **Step 4: Add `cgEmitReturnArr` directly after `cgEmitReturnErr`**

```
// cgEmitReturnArr (native-array-return-and-fileh-guards, spec %2) is
// cgEmitReturnErr's body for a `return <array expr>` inside a function
// whose return needs a hidden pointer (a handle-free KArr -- see
// cgRetNeedsHidden). No constructor arm: the IR has no array constructor
// expression. src's address (a local/global/field/element resolves
// directly; an ECallFn falls to cgExprAddr's materialize fallback, whose
// KArr arm is cgEmitStoreArr, ECallFn-aware) is stashed on the stack
// across the 8(A6) hidden-pointer read, then block-copied.
func cgEmitReturnArr(src: int) {
    var sz: int

    sz = cgSizeOf(cgCurRetType)
    cgExprAddr(src)
    a68Emit(OpMove, 4, AmAn, 0, 0, AmPreDec, 7, 0)
    a68Emit(OpMovea, 4, AmDisp16, 6, 8, AmAn, 1, 0)
    a68Emit(OpMovea, 4, AmPostInc, 7, 0, AmAn, 0, 0)
    cgBlockCopy(sz)
}
```

- [ ] **Step 5: Dispatch to it from `cgReturnStmt`**

Change the hidden-offset branch to:

```
    if cgCurHiddenOffset != -1 {
        if irtKind(cgCurRetType) == KRec {
            cgEmitReturnRec(x)
        } else if irtKind(cgCurRetType) == KErr {
            cgEmitReturnErr(x)
        } else if irtKind(cgCurRetType) == KArr {
            cgEmitReturnArr(x)
        } else {
            cgEmitReturnStr(x)
        }
    } else {
```

- [ ] **Step 6: Give `cgEmitStoreArr` the `ECallFn` fast path**

Insert at the top of the function body, before the addressability guard:

```
func cgEmitStoreArr(dst: int, src: int) {
    var sz: int

    if irExprKind(src) == ECallFn {
        // spec %2: build the returned array straight into dst through the
        // hidden result pointer -- cgEmitStoreRec's own ECallFn arm. This
        // single arm serves `b = mk()` (SAssign), `sum4(mk())` (cgPushArgs
        // -> cgMaterializeToTemp) and `return mk()` (cgEmitReturnArr ->
        // cgExprAddr), all of which route here.
        cgCallFnInto(src, dst)
        return
    }
    if not cgIsAddressableArgShape(src, KArr) {
```

Reword the guard's abort message to:

```
        abort("cg68k: an array-valued expression result has no address on this backend -- a fixed array can only be assigned or passed from a variable, field, element, or a function call")
```

- [ ] **Step 7: Add the `KArr` case to `cgCallFnScalar`'s discard arm**

Inside `if e == cgDiscardExprIdx { ... }`, extend the kind dispatch:

```
            if irtKind(retType) == KRec {
                cgEmitStoreRec(dst, e)
            } else if irtKind(retType) == KErr {
                cgEmitStoreErr(dst, e)
            } else if irtKind(retType) == KArr {
                // spec %2: a bare, discarded call to an array-returning
                // function. cgNewTrackedTmp above already sized the slot
                // from retType (cgAllocTmpOff picks the big pool for any
                // type wider than 4 bytes), and a scalar array owes no
                // release, so the end-of-statement flush is a no-op on it.
                cgEmitStoreArr(dst, e)
            } else {
                cgEmitStoreStr(dst, e)
            }
```

(Keep the existing `KErr` arm's comment; only the new `KArr` arm is added.) Also update the abort message that follows the discard block from `str/rec/err-return function` to `str/rec/err/arr-return function`.

- [ ] **Step 8: Rebuild and run the fixture natively**

```bash
make -j tools bootstrap
build-run/clarusc-current emit68k --rtdir runtime/clarus/ -o /tmp/kr.bin --listing testdata/cg68k/karr_return.cla 2>&1 | grep -v '^\['; echo "exit $?"
grep -n 'hidden result ptr' /tmp/kr.seg1.s
```

Expected: exit 0, and the listing shows `hidden result ptr : 8(A6)  size 4` for `mk` and `fwd` (two occurrences).

- [ ] **Step 9: Bless the new golden and check that nothing else moved**

```bash
CLARUS_CG68K_BLESS=1 make test T=cg68k/goldens
git status --short testdata/cg68k/
```

Expected: `PASS cg68k/goldens`; `git status` shows exactly one new file, `testdata/cg68k/karr_return.s`, and no modified `.s` files. If any existing golden is modified, stop: the change is not confined to the new shapes and must be understood before continuing.

- [ ] **Step 10: Run the whole cg68k group (round-trip included)**

```bash
make -j test T=cg68k/
```

Expected: every `cg68k/*` line PASS (or SKIP for the vasm-gated scripts if `vasm/` is absent).

- [ ] **Step 11: Commit**

```bash
git add clarusc/cg68k.cla testdata/cg68k/karr_return.cla testdata/cg68k/karr_return.s
git commit -m "cg68k: return scalar-element fixed arrays through the hidden result pointer

cgRetNeedsHidden admits a handle-free KArr (cgParamByRef's own boundary);
cgEmitReturnArr block-copies like cgEmitReturnErr; cgEmitStoreArr gains
the ECallFn -> cgCallFnInto fast path cgEmitStoreRec has, which serves
assignment, argument and return-forwarding shapes alike; the discard arm
parks a bare call's result in its tracked temp. karr_return.cla golden."
```

---

### Task 2: Named diagnostics for handle-bearing arrays (spec §3)

**Files:**
- Modify: `clarusc/cg68k.cla` — `cgPushArgs`' by-value `else` arm (~line 10450), `cgEmitFunc` right after `needsHidden = cgRetNeedsHidden(irFuncRet(f))` (~line 5504), plus a new helper `cgArrElemDesc` placed directly before `cgParamByRef`
- Test: `tests/cg68k/array_assign.sh` (two new fail-closed subcases before its `require_vasm`)

**Interfaces:**
- Consumes: `cgRetNeedsHidden` from Task 1 (false for a handle-bearing `KArr`), `irtElem`, `irtName`, `poolGet`, `irFuncName(f)`, `irFuncRet(f)`.
- Produces: `func cgArrElemDesc(t: int): string`; two abort messages whose fixed substrings the test greps: `cannot be passed by value natively` and `cannot be returned natively`.

- [ ] **Step 1: Add the two fail-closed subcases to `tests/cg68k/array_assign.sh`**

Insert after the existing `handle_elem_no_bin` block and BEFORE the line `[ "$STATUS" -eq 0 ] || t_done`:

```sh
# --- handle-bearing array PARAMETER by value: named diagnostic ---------
# (native-array-return-and-fileh-guards, spec %3). cgParamByRef routes
# every handle-free array by address, so a KArr reaching cgPushArgs' by-
# value arm is handle-bearing by construction and must fail closed with
# a message that names the element, not the generic value-context abort.
dir=$WORK/hparam
mkdir -p "$dir" || die "mkdir $dir"
cat > "$dir/hparam.cla" <<'EOF'
record Named {
    label: text
}

func f(a: Named[2]): int {
    return 1
}

on App.launch {
    var n: Named[2]
    if f(n) == 0 {
        return
    }
}
EOF
if out=$("$CLARUSC" emit68k -o "$dir/out.bin" "$dir/hparam.cla" 2>&1); then
    t_fail handle_param_named_error "emit68k unexpectedly succeeded on a handle-bearing array parameter"
    echo "$out"
elif ! printf '%s\n' "$out" | grep -q 'cannot be passed by value natively'; then
    t_fail handle_param_named_error "expected the named handle-bearing-parameter error, got: $out"
elif ! printf '%s\n' "$out" | grep -q 'record Named'; then
    t_fail handle_param_named_error "diagnostic does not name the element record: $out"
else
    t_pass handle_param_named_error
fi

# --- handle-bearing array RETURN: named diagnostic ---------------------
# g is defined FIRST so cgEmitFunc(g) runs before the handler that calls
# it -- the diagnostic fires at g's own frame layout, before any caller.
dir=$WORK/hret
mkdir -p "$dir" || die "mkdir $dir"
cat > "$dir/hret.cla" <<'EOF'
func g(): text[2] {
    var t: text[2]
    return t
}

on App.launch {
    g()
}
EOF
if out=$("$CLARUSC" emit68k -o "$dir/out.bin" "$dir/hret.cla" 2>&1); then
    t_fail handle_return_named_error "emit68k unexpectedly succeeded on a handle-bearing array return"
    echo "$out"
elif ! printf '%s\n' "$out" | grep -q 'cannot be returned natively'; then
    t_fail handle_return_named_error "expected the named handle-bearing-return error, got: $out"
elif ! printf '%s\n' "$out" | grep -q 'function g '; then
    t_fail handle_return_named_error "diagnostic does not name the function: $out"
else
    t_pass handle_return_named_error
fi
```

- [ ] **Step 2: Run the script and watch the two new subcases fail**

```bash
make test T=cg68k/array_assign
tail -20 build-run/tests/cg68k/array_assign.log
```

Expected: `FAIL handle_param_named_error: expected the named ...` and `FAIL handle_return_named_error: expected the named ...` (both programs abort today with the generic `EVarRef non-scalar` message).

- [ ] **Step 3: Add `cgArrElemDesc` before `cgParamByRef`**

```
// cgArrElemDesc (native-array-return-and-fileh-guards, spec %3) spells a
// fixed array's element type for the two handle-bearing-array
// diagnostics: the record's own name for a KRec element (the common
// case -- a record with a text field), the kind's name otherwise.
func cgArrElemDesc(t: int): string {
    var et: int
    var k: IRKind

    et = irtElem(t)
    k = irtKind(et)
    if k == KRec {
        return "record " + poolGet(irtName(et))
    }
    if k == KText {
        return "text"
    }
    if k == KList {
        return "list"
    }
    if k == KMap or k == KSortedMap or k == KIntMap {
        return "map"
    }
    if k == KArr {
        return "array of " + cgArrElemDesc(et)
    }
    return "element"
}
```

- [ ] **Step 4: The parameter diagnostic in `cgPushArgs`**

At the top of the by-value arm (`} else {` after the `if cgParamByRef(t) { ... }` block), before `sz = cgSlotSizeOf(t)`:

```
        } else {
            if irtKind(t) == KArr {
                // spec %3: cgParamByRef passes every handle-free array by
                // address, so a KArr here is handle-bearing by
                // construction -- and its copy path would owe a retain
                // walk this backend does not have. Name it, instead of
                // falling into cgExpr's generic value-context abort.
                abort("cg68k: a fixed array whose elements carry a text/list/map (" + cgArrElemDesc(t) + ") cannot be passed by value natively -- pass a `list`, or put the array in a record and pass the record")
            }
            sz = cgSlotSizeOf(t)
```

- [ ] **Step 5: The return diagnostic in `cgEmitFunc`**

Directly after `needsHidden = cgRetNeedsHidden(irFuncRet(f))`:

```
    needsHidden = cgRetNeedsHidden(irFuncRet(f))
    if irtKind(irFuncRet(f)) == KArr and not needsHidden {
        // spec %3: a handle-bearing array return has no hidden slot
        // (cgRetNeedsHidden) and no retain walk; fail at the callee's own
        // frame layout, once, naming the function.
        abort("cg68k: function " + poolGet(irFuncName(f)) + " returns a fixed array whose elements carry a text/list/map (" + cgArrElemDesc(irFuncRet(f)) + ") -- cannot be returned natively; return a `list` instead")
    }
```

- [ ] **Step 6: Rebuild, re-run the script, run the group**

```bash
make -j tools bootstrap
make test T=cg68k/array_assign
make -j test T=cg68k/
```

Expected: `PASS handle_param_named_error`, `PASS handle_return_named_error`, and every `cg68k/*` result PASS/SKIP. Goldens must be untouched (`git status --short testdata/` empty): the diagnostics add no emitted bytes.

- [ ] **Step 7: Commit**

```bash
git add clarusc/cg68k.cla tests/cg68k/array_assign.sh
git commit -m "cg68k: name handle-bearing fixed arrays in the by-value and return diagnostics

Replaces the generic 'EVarRef non-scalar reached in value context' abort
for a text/list/map-bearing array passed by value (cgPushArgs) or
returned (cgEmitFunc) with messages naming the element and the function."
```

---

### Task 3: Core-suite `ArrReturn` case, both lanes, plus the reference (spec §2.4, §2.5)

**Files:**
- Modify: `testsuite/core/cases_arr.cla` (append the case), `testsuite/core/runner.cla` (enum member after `ArrHolderElementStore`, name switch, `l.add`, dispatch branch, `nCoreCases` 82 → 83), `tests/testsuite/core_cases.txt` (add `ArrReturn` after `ArrHolderElementStore`), `tests/mactest/coresuite_68k.sh:29` and `tests/mactest/coresuite_mac.sh:22` (`82` → `83`), `CLAUDE.md` (the count sentences), `docs/TODO.md:143` (`82` → `83` in the "Suite bookkeeping minors" entry), `docs/clarus-language-reference.md` (Chapter 6, the paragraph at line ~857)
- Test: `tests/testsuite/core_cli.sh` (host CLI runs every case), `tests/mactest/coresuite_68k.sh` (native boot; T2)

**Interfaces:**
- Consumes: Task 1's codegen; `TestResult`, `tkPass(name)`, `tkFail(name, detail)` from `testsuite/kit.cla`; `string(n)` int-to-string.
- Produces: `CoreTest.ArrReturn`, `func caseArrReturn(): TestResult`.

- [ ] **Step 1: Append the case to `testsuite/core/cases_arr.cla`**

Also add one line to the file's header comment list: `//   ArrReturn <- native-array-return-and-fileh-guards, spec %2: a scalar-element fixed array returned by value, consumed assigned / as an argument / forwarded / discarded; the returned copy is independent.`

```
// caseArrMk4/caseArrSum4/caseArrFwd4 are ArrReturn's fixtures: an array
// RETURN (hidden result pointer on the native lane, cgRetNeedsHidden), a
// borrowed array PARAMETER (cgParamByRef), and a return forwarded through
// a second call.
func caseArrMk4(): int[4] {
    var a: int[4]

    a[0] = 1
    a[1] = 2
    a[2] = 3
    a[3] = 4
    return a
}

func caseArrSum4(a: int[4]): int {
    return a[0] + a[1] + a[2] + a[3]
}

func caseArrFwd4(): int[4] {
    return caseArrMk4()
}

func caseArrReturn(): TestResult {
    var b: int[4]
    var s: int

    // A bare, discarded call must compile and run (cgCallFnScalar's
    // discard arm parks the result in a tracked temp).
    caseArrMk4()

    b = caseArrMk4()
    s = caseArrSum4(b)
    if s != 10 {
        return tkFail("ArrReturn", "assigned return sum " + string(s) + " want 10")
    }
    // Mutating the copy must not reach the callee's local or any later
    // return: the next two calls must still sum to 10.
    b[0] = 100
    s = caseArrSum4(caseArrMk4())
    if s != 10 {
        return tkFail("ArrReturn", "direct-argument return sum " + string(s) + " want 10")
    }
    s = caseArrSum4(caseArrFwd4())
    if s != 10 {
        return tkFail("ArrReturn", "forwarded return sum " + string(s) + " want 10")
    }
    if b[0] != 100 or b[1] != 2 or b[3] != 4 {
        return tkFail("ArrReturn", "assigned copy not independent")
    }
    return tkPass("ArrReturn")
}
```

- [ ] **Step 2: Wire the case into `testsuite/core/runner.cla`**

Four edits, each next to the existing `ArrHolderElementStore` line of the same shape:

1. In `enum CoreTest`, after `ArrHolderElementStore`, add a line `ArrReturn`.
2. In the name switch, after the `case ArrHolderElementStore { return "ArrHolderElementStore" }` block, add:
   ```
       case ArrReturn {
           return "ArrReturn"
       }
   ```
3. In the all-cases list builder, after `l.add(ArrHolderElementStore)`, add `l.add(ArrReturn)`.
4. In the dispatch loop, after the `ArrHolderElementStore` branch, add:
   ```
       if wantAll or coreHas(deduped, ArrReturn) {
           results.add(caseArrReturn())
           casesRun = casesRun + 1
       }
   ```
5. Change `const nCoreCases: int = 82` to `83`, and in its doc comment "the 81 real cases" to "the 82 real cases".

- [ ] **Step 3: The other four count sites**

- `tests/testsuite/core_cases.txt`: insert a line `ArrReturn` directly after `ArrHolderElementStore`.
- `tests/mactest/coresuite_68k.sh` line 29: `suite_report_check "$WORK/cap.out" 83`. If the script's header comment mentions 82, change it too.
- `tests/mactest/coresuite_mac.sh` line 22: same, `83`.
- `CLAUDE.md`: in the `testsuite/core/` bullet change `82 \`CoreTest\` cases: 81 real + \`SelfCheck\`` to `83 ... 82 real`, and after the clause ending `hardware-proves \`file.openRF\` (a resource fork opened as an ordinary \`filehandle\`) on both lanes)` insert ` -- then to 82 real by the native-array-return-and-fileh-guards phase's \`ArrReturn\` case, which hardware-proves scalar-element fixed-array RETURNS (hidden-result-pointer block copy) on both lanes`. In the `SelfCheck` paragraph change `all 81 other cases` to `all 82 other cases`.
- `docs/TODO.md` line 143: the `suite_report_check "$WORK/cap.out" 82` literal in the "Suite bookkeeping minors" entry becomes `83`.

- [ ] **Step 4: Reference**

In `docs/clarus-language-reference.md`, Chapter 6, append to the paragraph that begins `Parameters are immutable bindings:` (line ~859), after its last sentence:

```
A fixed array is also a legal **return** type: the callee's array is copied to the caller by value, on both lanes, so `b = mk()`, `sum4(mk())` and `return mk()` all work. Both rules stop at handle-bearing elements: a fixed array whose element type contains a `text`, `list`, or `map` anywhere (directly, or inside a record) can be neither passed by value nor returned on the native lane — the build fails with a message naming the element type; use a `list`, or keep such an array inside a record and pass or return the record.
```

- [ ] **Step 5: Run the host CLI suite**

```bash
make test T=testsuite/core_cli
grep -n 'ArrReturn\|TOTAL' build-run/tests/testsuite/core_cli.log | head
```

Expected: `PASS testsuite/core_cli`; the log shows `ArrReturn` PASS and `TOTAL 83 PASS 83 FAIL 0`. `core_cli.sh` reads `tests/testsuite/core_cases.txt` as the expected case list for `all`, in order, so a forgotten runner branch or a missing `core_cases.txt` line fails right here.

- [ ] **Step 6: Native boot of the core suite**

```bash
CLARUS_MAC_TESTS=1 make test T=mactest/coresuite_68k
grep -n 'ArrReturn\|TOTAL' build-run/tests/mactest/coresuite_68k.log
```

Expected: `PASS mactest/coresuite_68k` with `PASS ArrReturn` and `TOTAL 83 PASS 83 FAIL 0`. Needs the emulator (`macplus/`); if it is absent the script SKIPs, and T2 must run it before merge.

- [ ] **Step 7: Commit**

```bash
git add testsuite/core/cases_arr.cla testsuite/core/runner.cla tests/testsuite/core_cases.txt tests/mactest/coresuite_68k.sh tests/mactest/coresuite_mac.sh CLAUDE.md docs/TODO.md docs/clarus-language-reference.md
git commit -m "testsuite(core): ArrReturn hardware-proves scalar-element array returns; reference names the rule

82 -> 83 CoreTest cases in all five count sites."
```

---

### Task 4: Skip zero-valued explicit global initializers (spec §4)

**Files:**
- Modify: `clarusc/cg68k.cla` — new helper `cgInitIsZeroConst` placed directly before `cgEmitInitGlobalsStub`; the per-global loop inside `cgEmitInitGlobalsStub` (~line 5350)
- Create: `testdata/cg68k/globals_zero_init.cla`
- Test: `tests/cg68k/goldens.sh`

**Interfaces:**
- Consumes: `irExprKind`, `irIntConstV(e: int): int`, `irConvOp(e: int): IRConvOp`, `irConvX(e: int): int`, `CvIntToPtr`, `cgDefaultIsAllZero(t, scalarDefault, strDefaultIdx)`.
- Produces: `func cgInitIsZeroConst(e: int): bool`.

- [ ] **Step 1: Write the fixture and prove it runs on the host**

Create `testdata/cg68k/globals_zero_init.cla`:

```
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// globals_zero_init.cla (native-array-return-and-fileh-guards, spec %4):
// a zero-valued EXPLICIT global initializer of an all-zero type must
// cost nothing in cg_init_globals -- the startup sweep already zeroed
// the slot. Five zero spellings (lowering folds every one to
// EIntConst 0, or CvIntToPtr of one for ptr(0)) and one non-zero
// control that must keep its store. The listing's cg_init_globals
// block therefore holds exactly ONE `MOVE.L #1,D0` store pair.

enum Mode {
    Off
    On
}

var gi: int = 0
var gb: bool = false
var gp: ptr = ptr(0)
var gf: fixed = 0.0
var gm: Mode = Off
var gk: int = 1

on App.launch {
    if gi != 0 or gb or gp != ptr(0) or gf != 0.0 or gm != Off or gk != 1 {
        return
    }
}
```

```bash
scripts/clarus-run.sh testdata/cg68k/globals_zero_init.cla; echo "host exit $?"
```

Expected: exit 0. If the checker rejects any spelling (for example `0.0`), change that one initializer to another zero form the reference admits and keep going; the point is five zero-valued initializers of five kinds.

- [ ] **Step 2: Observe the stores that exist today**

```bash
build-run/clarusc-current emit68k --rtdir runtime/clarus/ -o /tmp/gz.bin --listing testdata/cg68k/globals_zero_init.cla > /dev/null 2>&1
awk '/; cg_init_globals/{on=1} on && /; cg_free_globals/{exit} on' /tmp/gz.seg1.s | grep -c 'MOVE.L D0,-[0-9]*(A5)'
```

Expected: `6` (one store per global, zero-valued or not). This is the failing state; after the change it must be `1`.

- [ ] **Step 3: Add `cgInitIsZeroConst` before `cgEmitInitGlobalsStub`**

```
// cgInitIsZeroConst (native-array-return-and-fileh-guards, spec %4): true
// when a global's EXPLICIT initializer is a constant zero -- an EIntConst
// of 0 (`= 0`, `= false`, `= 0.0`, a zero-valued enum member; lowering
// folds every one of those to EIntConst 0) or a CvIntToPtr conversion of
// one (`= ptr(0)`). cgEmitInitGlobalsStub skips the store for such an
// initializer when the global's type is all-zero by default
// (cgDefaultIsAllZero): the startup sweep already zeroed the slot, so
// the store was a `MOVE.L #0,D0` / `MOVE.L D0,-N(A5)` pair buying
// nothing. A `KStr` `= ""` never reaches this (cgDefaultIsAllZero is
// false for it) and keeps its cgEmitStoreStr path.
func cgInitIsZeroConst(e: int): bool {
    var k: IRExprKind

    k = irExprKind(e)
    if k == EIntConst {
        return irIntConstV(e) == 0
    }
    if k == EConv and irConvOp(e) == CvIntToPtr {
        return cgInitIsZeroConst(irConvX(e))
    }
    return false
}
```

- [ ] **Step 4: Apply it in the per-global loop**

In `cgEmitInitGlobalsStub`, change

```
        if initE != -1 {
            cgEmitGlobalInitExpr(i, gt, initE)
        }
```

to

```
        if initE != -1 and not (cgInitIsZeroConst(initE) and cgDefaultIsAllZero(gt, 0, -1)) {
            cgEmitGlobalInitExpr(i, gt, initE)
        }
```

and extend the loop's leading comment with one sentence: "A zero-valued constant initializer of an all-zero type is skipped outright (cgInitIsZeroConst) -- the sweep already produced that value."

- [ ] **Step 5: Rebuild, re-measure, bless, and inspect the diff**

```bash
make -j tools bootstrap
build-run/clarusc-current emit68k --rtdir runtime/clarus/ -o /tmp/gz.bin --listing testdata/cg68k/globals_zero_init.cla > /dev/null 2>&1
awk '/; cg_init_globals/{on=1} on && /; cg_free_globals/{exit} on' /tmp/gz.seg1.s | grep -c 'MOVE.L D0,-[0-9]*(A5)'
CLARUS_CG68K_BLESS=1 make test T=cg68k/goldens
git status --short testdata/cg68k/
git diff --stat testdata/cg68k/
```

Expected: the count is `1`; `git status` shows the new `globals_zero_init.s` and, for any OTHER golden that changed, `git diff testdata/cg68k/<file>.s` must show only removed lines inside its `cg_init_globals` block (a `MOVE.L #0,D0`/`MOVE.L D0,-N(A5)` pair per removed hunk, and the LINK/frame lines unchanged). Any added line, or a change outside that block, is a stop-and-investigate.

- [ ] **Step 6: Run the cg68k group and the emitui goldens**

```bash
make -j test T='cg68k/ emitui/'
```

Expected: all PASS/SKIP. The host C lane is untouched by this task, so no `emit` golden may change; if `emitui/` reports a mismatch, the change leaked into the wrong lane.

- [ ] **Step 7: Commit**

```bash
git add clarusc/cg68k.cla testdata/cg68k/globals_zero_init.cla testdata/cg68k/globals_zero_init.s
git add -u testdata/cg68k/
git commit -m "cg68k: skip the store for a zero-valued explicit global initializer

= 0 / = false / = ptr(0) / = 0.0 / a zero enum member of an all-zero type
already hold that value after the startup sweep; cgInitIsZeroConst plus
one predicate in cgEmitInitGlobalsStub drops the MOVE.L pair. New
globals_zero_init.cla golden pins one surviving store for the control."
```

---

### Task 5: `file.rename("", x)` guard (spec §5)

**Files:**
- Modify: `runtime/clarus/fileh.cla` — `rtFhRename` (~line 364), `testsuite/core/cases_dirops.cla` (~line 118, after the `rename with path succeeded` check), `docs/clarus-language-reference.md` line ~1478 (the `rename` row)
- Test: `tests/testsuite/core_cli.sh` (host), `tests/mactest/coresuite_68k.sh` (native, T2)

**Interfaces:**
- Consumes: `rtSetLastErr(code: int, msg: string)`, `lastError.code` in suite code, `tkIntToStr(n: int): string`.
- Produces: nothing new; `file.rename("", anything)` returns `false` with `lastError.code == -37` on both lanes.

- [ ] **Step 1: Add the assertion to the `DirOps` case**

In `testsuite/core/cases_dirops.cla`, directly after the block ending `return tkFail("DirOps", "rename with path succeeded")` and its closing brace, insert:

```
    // native-array-return-and-fileh-guards, spec %5: an EMPTY path must be
    // refused before any trap. On the native lane rtFhDevStat("") is the
    // "program's own folder" convention and reports parent DirID 0, so
    // without the guard PBHRenameSync would be issued with an empty leaf
    // name and ioDirID 0 -- a VOLUME rename in Inside Macintosh's terms.
    if file.rename("", "x") {
        return tkFail("DirOps", "rename of empty path succeeded")
    }
    if lastError.code != -37 {
        return tkFail("DirOps", "rename of empty path code " + tkIntToStr(lastError.code) + " want -37")
    }
```

- [ ] **Step 2: Run the host CLI and watch `DirOps` fail**

```bash
make test T=testsuite/core_cli
grep -n 'DirOps' build-run/tests/testsuite/core_cli.log | head -3
```

Expected: `FAIL DirOps rename of empty path code <errno-derived code> want -37` (the host device layer's `rename("")` fails with a POSIX error, not `-37`).

- [ ] **Step 3: The guard in `rtFhRename`**

Change the top of `rtFhRename` in `runtime/clarus/fileh.cla` to:

```
func rtFhRename(path: string, newName: string): bool {
    var i: int

    // native-array-return-and-fileh-guards, spec %5: an empty path is
    // refused here, on both lanes, before the device layer. rtFhDevStat's
    // empty-path convention ("the program's own folder", which exists/
    // info/list rely on) would otherwise hand rtFhDevRename a parent
    // DirID of 0 and an empty leaf name -- the shape PBHRenameSync reads
    // as "rename the volume".
    if path == "" or newName == "" {
        rtSetLastErr(-37, "rename failed")
        return false
    }
```

(The old `if newName == "" { ... }` block is replaced by this combined check; the colon loop below it is unchanged.)

- [ ] **Step 4: Re-run the host CLI**

```bash
make test T=testsuite/core_cli
```

Expected: `PASS testsuite/core_cli`, `DirOps` PASS. `fileh.cla` is shared by both lanes, so no separate native edit exists; the native proof is the `coresuite_68k` boot in Step 6 / T2.

- [ ] **Step 5: Reference row**

In `docs/clarus-language-reference.md`, change the `rename` row's last cell to:

```
renames in place; `newName` is a leaf name, not a path -- a `newName` containing `:` fails, and so does an empty `path` or an empty `newName` (both `-37`)
```

- [ ] **Step 6: Native boot (if the emulator is present)**

```bash
CLARUS_MAC_TESTS=1 make test T=mactest/coresuite_68k
```

Expected: `PASS DirOps` in the log and the suite total still all-pass.

- [ ] **Step 7: Commit**

```bash
git add runtime/clarus/fileh.cla testsuite/core/cases_dirops.cla docs/clarus-language-reference.md
git commit -m "runtime(fileh): file.rename refuses an empty path before the trap

rtFhDevStat(\"\") reports parent DirID 0 (the own-folder convention), so an
empty path reached PBHRenameSync as an empty leaf name in directory 0 --
a volume rename. One shared guard, both lanes; DirOps pins it."
```

---

### Task 6: Host AppleDouble sidecar minors (spec §6)

**Files:**
- Modify: `runtime/host/rt_fileh.inc` — `rt_fh_sidecar_store` (~line 124), `rt_ext_FhHOpenRF` (~line 150), `rt_ext_FhHClose` (~line 314); `runtime/host/rt_fileh_test.c` — `test_openrf` (~line 436); `docs/clarus-language-reference.md` line ~1513 (the `close` row)
- Test: `tests/hostrt/fileh.sh` (compiles and runs `rt_fileh_test.c` with `-std=c99 -Wall -Werror`)

**Interfaces:**
- Consumes: `rt_fh_errno`, `rt_ext_FhHErrno()`, `CHECK(cond, msg)`, `mkpath(out, s)` in the test file.
- Produces: no new symbols. Behavioral: temp file under `$TMPDIR`; sidecar fsynced by `flush`; a failed write-back at close leaves its errno in `rt_fh_errno`.

- [ ] **Step 1: Add the two checks to `test_openrf` (failing first)**

In `runtime/host/rt_fileh_test.c`, inside `test_openrf`, after the existing `"AppleDouble magic"` block's closing `}` and BEFORE `unsetenv("CLARUS_FORCE_APPLEDOUBLE");`, insert:

```c
    /* spec %6 (native-array-return-and-fileh-guards): TMPDIR is honoured
     * for the unlinked temp that backs a sidecar fork. The temp is
     * unlinked the moment it is created, so its location is observable
     * only through the failure a missing directory causes. */
    { const char *old = getenv("TMPDIR"); char saved[1024]; int hadOld = old != NULL;
      uint8_t path[256]; int32_t h; FILE *f; unsigned char m[4]; long sz;
      if (hadOld) { strncpy(saved, old, sizeof saved - 1); saved[sizeof saved - 1] = 0; }
      mkpath(path, "fileh_test_rf.dat"); h = rt_ext_FhHCreate(path); rt_ext_FhHClose(h);
      setenv("TMPDIR", "./no-such-tmpdir-for-clarus", 1);
      h = rt_ext_FhHOpenRF(path);
      CHECK(h == 0 && rt_ext_FhHErrno() == ENOENT, "TMPDIR honoured: missing dir fails with ENOENT");
      if (h) rt_ext_FhHClose(h);
      setenv("TMPDIR", ".", 1);
      h = rt_ext_FhHOpenRF(path);
      CHECK(h != 0, "TMPDIR honoured: cwd works");
      /* flush is the durability barrier: the sidecar is complete on disk
       * BEFORE close, and its size is header (82) + fork (4). */
      CHECK(rt_ext_FhHWriteAt(h, 0, (void *)"FLSH", 4) == 0, "flush barrier: write");
      CHECK(rt_ext_FhHFlush(h) == 0, "flush barrier: flush");
      f = fopen("._fileh_test_rf.dat", "rb");
      CHECK(f != NULL, "flush barrier: sidecar exists before close");
      if (f) { fseek(f, 0, SEEK_END); sz = ftell(f); fseek(f, 0, SEEK_SET);
               CHECK(sz == 86, "flush barrier: sidecar size 82+4 before close");
               CHECK(fread(m, 1, 4, f) == 4 && m[0] == 0 && m[1] == 5 && m[2] == 0x16 && m[3] == 7, "flush barrier: AppleDouble magic before close");
               fclose(f); }
      rt_ext_FhHClose(h);
      if (hadOld) setenv("TMPDIR", saved, 1); else unsetenv("TMPDIR");
      unlink("fileh_test_rf.dat"); unlink("._fileh_test_rf.dat"); }
```

Make sure the file includes `<errno.h>` and `<string.h>` (add them beside the existing includes if missing).

- [ ] **Step 2: Run the host harness and watch the TMPDIR check fail**

```bash
make test T=hostrt/fileh
grep -n 'FAIL' build-run/tests/hostrt/fileh.log
```

Expected: `FAIL: TMPDIR honoured: missing dir fails with ENOENT` (the template is a hardcoded `/tmp`, so the open succeeds). The flush-barrier checks may already pass (the store already runs on flush); that is fine, they pin the fsync that Step 4 adds.

- [ ] **Step 3: Honour `TMPDIR` in `rt_ext_FhHOpenRF`**

Change the declaration line and the template:

```c
int32_t rt_ext_FhHOpenRF(const uint8_t *path) {
    char cpath[256], tmpl[1100], dirbuf[256], basebuf[256];
    const char *tdir;
    struct stat st; int fd, slot, i;
```

and replace `strcpy(tmpl, "/tmp/clarus-rf-XXXXXX");` with:

```c
    /* spec %6: the unlinked temp that backs the fork lives under $TMPDIR
     * when set and non-empty, else /tmp -- the ordinary POSIX rule. */
    tdir = getenv("TMPDIR");
    if (!tdir || !*tdir) tdir = "/tmp";
    if (snprintf(tmpl, sizeof tmpl, "%s/clarus-rf-XXXXXX", tdir) >= (int)sizeof tmpl) { rt_fh_errno = ENAMETOOLONG; return 0; }
```

- [ ] **Step 4: fsync the sidecar in `rt_fh_sidecar_store`**

Replace the function's last line `return fclose(f) == 0 ? 0 : -1;` with:

```c
    /* spec %6: flush's durability barrier covers the SIDECAR, not just the
     * unlinked temp -- push the stdio buffer and fsync before closing. */
    if (fflush(f) != 0 || fsync(fileno(f)) != 0) { fclose(f); return -1; }
    return fclose(f) == 0 ? 0 : -1;
```

- [ ] **Step 5: Record a failed write-back at close**

In `rt_ext_FhHClose`, change

```c
    if (slot >= 0) {
        rt_fh_sidecar_store(slot, fd);
        rt_fh_rf[slot].fd = 0;
    }
```

to

```c
    if (slot >= 0) {
        /* close() is void on every lane (reference: "idempotent"), so a
         * failed write-back cannot be returned; it is recorded in
         * rt_fh_errno for FhHErrno, and the reference tells programs that
         * flush() is the call that reports it (spec %6). */
        if (rt_fh_sidecar_store(slot, fd) != 0) rt_fh_errno = errno;
        rt_fh_rf[slot].fd = 0;
    }
```

- [ ] **Step 6: Run the harness and the whole hostrt group**

```bash
make test T=hostrt/fileh
make -j test T=hostrt/
```

Expected: `PASS hostrt/fileh` with no `FAIL:` lines in the log; every `hostrt/*` PASS. The `-Wall -Werror` build must stay clean (an unused variable or an implicit declaration fails the compile).

- [ ] **Step 7: Reference row**

In `docs/clarus-language-reference.md`, change the `close` row's last cell from `idempotent` to:

```
idempotent; on a host build's AppleDouble sidecar path (a non-Apple host, or `CLARUS_FORCE_APPLEDOUBLE=1`) the resource-fork write-back at close is best-effort -- call `flush()` first when a failure must be observed
```

- [ ] **Step 8: Commit**

```bash
git add runtime/host/rt_fileh.inc runtime/host/rt_fileh_test.c docs/clarus-language-reference.md
git commit -m "runtime(host): AppleDouble sidecar honours TMPDIR, is fsynced by flush, records a failed close write-back

The sidecar path binds only off macOS or under CLARUS_FORCE_APPLEDOUBLE=1;
the forced block in rt_fileh_test.c pins TMPDIR and the flush barrier."
```

---

### Task 7: Close-out docs and the merge gate

**Files:**
- Modify: `docs/TODO.md` (delete the now-empty "Compiler correctness / cleanup" and "Runtime / Toolbox robustness" sections, headings included), `docs/HISTORY.md` (append the phase entry), `docs/ROADMAP.md` ("Where we are" paragraph)
- Test: `scripts/test-task.sh --smoke`, then `scripts/test-merge.sh`

- [ ] **Step 1: TODO.md**

Delete the `## Compiler correctness / cleanup` section (its `### language-runtime-cleanup phase (2026-09-06)` sub-heading and the single remaining `cg_init_globals still emits explicit stores` entry) and the `## Runtime / Toolbox robustness` section (its sub-heading and both entries: `file.rename("", x)` and `Sidecar filehandle minors`). Nothing else in the file changes.

- [ ] **Step 2: HISTORY.md**

Append, after the `## language-runtime-cleanup phase (2026-09-06, ...)` entry and before `## Archived from ROADMAP, 2026-09-05 (verbatim)`, a `## native-array-return-and-fileh-guards phase (2026-09-06, branch \`native-array-return-and-fileh-guards\`)` entry containing: the spec and plan paths; a one-paragraph summary of each of Tasks 1–6 (what changed, where, and which test pins it); the count change (core suite 82 → 83, `ArrReturn`); the two new cg68k goldens (`karr_return.s`, `globals_zero_init.s`) and any existing golden the Task 4 bless touched; the two new emit diagnostics' fixed substrings; and the spec's out-of-scope list (handle-bearing array returns/copies, the C-lane `KErr` asymmetry, `close()` status, the on-hold `cg_free_globals` duplication).

- [ ] **Step 3: ROADMAP.md**

In `## Where we are (2026-09-06)`, add a paragraph stating that `native-array-return-and-fileh-guards` is COMPLETE on its branch and NOT YET MERGED (merge is Andrew's call), that it emptied TODO.md's Compiler and Runtime sections, and that TODO.md now holds only the Serial/connection group, the test-coverage gaps, and the on-hold Compiler-on-Mac section.

- [ ] **Step 4: Per-task gate on the final tree**

```bash
scripts/test-task.sh --smoke
```

Expected: every stage PASS (T1, perfgate alone, the two smoke boots).

- [ ] **Step 5: Merge gate**

```bash
scripts/test-merge.sh
```

Expected: each `test-merge.sh: <stage> PASS in Ns` line, including `selfhost/` (the bootstrap fixed point — if `fixedpoint.sh` reports `snapshot_fresh`, follow the regeneration recipe it prints, commit the new `clarusc/clarusc.c`, and re-run), the gated `mactest/` group at `-j1` (which is where `coresuite_68k` proves `ArrReturn` and the `DirOps` guard on hardware), and the `bake/` full-corpus sweep.

- [ ] **Step 6: Commit**

```bash
git add docs/TODO.md docs/HISTORY.md docs/ROADMAP.md
git commit -m "docs: native-array-return-and-fileh-guards close-out -- TODO sections emptied, HISTORY entry, ROADMAP status"
```

Then report to Andrew: branch tip, T2 result lines, and that merge awaits his request.
