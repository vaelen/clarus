# `= ptr` Extern Clause Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `external func Name(entry: ptr, ...) [: ret] = ptr` — a pascal-convention call through a runtime `ptr` value (first parameter = jump target), on both lanes.

**Architecture:** A new extern calling-convention flag (conv 10) flows through the existing parse → check → lower → cg68k/cprint pipeline. Native lane marshals exactly like a pascal trap but ends in `JSR (A0)` through the saved target instead of an A-line word. Host lane emits a cast to the C function-pointer type derived from the signature (callback-glue wire types) and calls through it — a decayed `callback func` is a conforming target on both lanes, which is what the tests use.

**Tech Stack:** Clarus self-hosted compiler (`clarusc/*.cla`), 68k asm layer (`asm68k.cla`), host C printer (`cprint.cla`), Go test harnesses (`internal/lowlevel`, `internal/mactest`).

**Spec:** `docs/superpowers/specs/2026-08-27-extern-ptr-call-design.md`

## Global Constraints

- Branch: `extern-ptr-call` off main. Merge only on explicit request.
- Implementation subagents: `model: sonnet` (haiku for mechanical batch edits); the top-level session reviews and integrates.
- conv flag value for `= ptr` is **10** everywhere (0=none, 1=pascal trap, 2/6/7/8=reg forms, 3/4/5=inline, 9=seld0 — see `ast.cla` `externFuncConv`).
- `= ptr` takes NO suffixes: `sel`/`seld0`/`reg`/`memerr`/`ret` after `ptr` are simply not matched by the parser — trailing tokens fail as ordinary top-level parse errors (same mechanism that already rejects `= trap 0xA000 bogus`). No new checker rule needed for exclusivity.
- Marshalling of non-target params/return is byte-identical to conv 1 (pascal trap): bool/char high-byte-in-word, word 16-bit sign-extended result, str = Str255 address, text = box pointer.
- `-count=1` on all `go test` runs. `internal/selfhost` needs `-timeout 30m`.
- Doc files touched are UTF-8 (verified) — normal Edit is fine. `.cla` fixtures are ASCII-only here; do not introduce high bytes.

---

### Task 1: Front end — parse `= ptr`, check it, fixture it

**Files:**
- Modify: `clarusc/parse.cla` (~line 121 cw-interns; ~line 1748 clause parse; doc comment ~1675)
- Modify: `clarusc/ast.cla` (`externFuncConv` doc comment, ~1715)
- Modify: `clarusc/check.cla` (`checkExternFunc`, ~2969; its doc comment ~2952)
- Modify: `clarusc/test/check_test.cla` + regenerate `clarusc/test/check_test.out`

**Interfaces:**
- Produces: parsed `external func` decls with `externFuncConv(d) == 10`, `externFuncTrap(d) == -1`, `externFuncSel(d) == -1`, no reg binds, retReg -1. Checker guarantees: ≥1 param, param 0 is `ptr`, rest of signature already validated by the existing shared rules. Tasks 2–4 rely on conv 10 meaning exactly this.

- [ ] **Step 1: Add failing checker fixtures**

In `clarusc/test/check_test.cla`, append a new case block at the end of `App.startEmpty` (follow the file's existing `runCase`/`ln` idiom exactly):

```rust
    // extern-ptr-call phase: `= ptr` clause (conv 10).
    src = ""
    ln(src, "external func PluginMain(entry: ptr, verb: int): int = ptr")
    ln(src, "external func PluginMain(entry: ptr, verb: int): int = ptr")
    ln(src, "func go(p: ptr): int { return PluginMain(p, 1) }")
    runCase("extern ptr clean + merge", src)

    src = ""
    ln(src, "external func Bad1(): int = ptr")
    runCase("extern ptr no params", src)

    src = ""
    ln(src, "external func Bad2(verb: int, entry: ptr): int = ptr")
    runCase("extern ptr first param not ptr", src)

    src = ""
    ln(src, "external func Bad3(entry: ptr): int = ptr")
    ln(src, "external func Bad3(entry: ptr): int = trap 0xA975")
    runCase("extern ptr redecl mismatch", src)

    src = ""
    ln(src, "external func Bad4(entry: ptr): int = ptr reg")
    runCase("extern ptr rejects reg", src)

    src = ""
    ln(src, "external func Bad5(entry: ptr): int = ptr sel 1")
    runCase("extern ptr rejects sel", src)

    src = ""
    ln(src, "external func Bad6(entry: ptr): int = ptr ret d0")
    runCase("extern ptr rejects ret", src)
```

Before writing the expected `.out` lines, READ the tail of `checkExternFunc` (the `mergeCandidate` comparison, after line ~3120) to confirm what the mismatch diagnostic text is, and confirm the identity comparison covers `externFuncConv` + the packed `c` slot (it must, for `= ptr` vs `= trap` to conflict; conv 10 adds no new clause data, so no comparison change should be needed — if it only compares trap/sel and NOT conv, extend it to compare conv too).

- [ ] **Step 2: Run the fixture to verify it fails**

```sh
scripts/clarus-run.sh clarusc/test/check_test.cla > /tmp/check_test_new.out 2>&1; tail -20 /tmp/check_test_new.out
```

Expected: the new "extern ptr clean + merge" case reports a parse diagnostic (`expected "trap" or "inline"`), since `ptr` isn't accepted yet.

- [ ] **Step 3: Parser — accept `= ptr`**

In `clarusc/parse.cla`:
1. Alongside the other cw-interns (~line 80 declarations, ~line 116 assignments): `var cwPtr: int` / `cwPtr = intern("ptr")`. (`ptr` in clause position lexes as an ordinary identifier, same as `trap`/`inline` — contextual, no new token.)
2. In `parseExternFuncDecl`, add a third clause arm between the `cwInline` arm and the trailing `else` error:

```rust
        } else if curIsIdentIdx(cwPtr) {
            // extern-ptr-call phase: `= ptr` -- pascal-convention call
            // through a runtime pointer. The FIRST declared parameter
            // (checkExternFunc enforces it exists and is `ptr`) is the
            // jump target, consumed by the call, never pushed; every
            // remaining param/return marshals exactly like conv 1's
            // pascal trap. No suffixes: no trap word, no sel/reg/ret.
            advance()
            convFlag = 10
        } else {
```
3. Update the final `else` diagnostic to `"expected \"trap\", \"inline\", or \"ptr\", found "` and the grammar doc comment above `parseExternFuncDecl` (and the ~1675 grammar line) to include `| "ptr"`.

- [ ] **Step 4: AST doc comment**

In `clarusc/ast.cla`, extend `externFuncConv`'s doc comment list with `, 10=pascal call through a runtime pointer (\`= ptr\`, extern-ptr-call phase -- first param is the jump target)`.

- [ ] **Step 5: Checker — conv 10 rule**

In `clarusc/check.cla` `checkExternFunc`, after the conv 5 rule (the `inline a5` check), add:

```rust
    if conv == 10 and (i == 0 or typeKind(funcSigParam(sigIdx, 0)) != TyPtr) {
        emitDiag(declLine(d), declCol(d), "= ptr requires a first parameter of type ptr")
    }
```

(`i` is the param count after the existing param walk; `funcSigParam(sigIdx, 0)` is safe to read only when `i > 0`, hence the short-circuit order.) Note conv 10 deliberately reuses ALL existing shared rules unchanged: param palette (int/ptr/bool/char/word/str/text), return palette, and the trap-range check does not apply (conv 10 is not in its conv list). Update `checkExternFunc`'s doc comment (~2952) with the conv 10 sentence.

- [ ] **Step 6: Run fixture, bless the .out**

```sh
scripts/clarus-run.sh clarusc/test/check_test.cla > /tmp/check_test_new.out 2>&1
diff /tmp/check_test_new.out clarusc/test/check_test.out
```

Expected diffs ONLY in the seven new cases: "clean" for the merge case, the new diagnostic for the two bad-shape cases, the redecl-mismatch diagnostic for the fourth, and ordinary parse diagnostics for the last three (`reg`/`sel`/`ret` after the clause are stray top-level tokens -- this is the grammar-level suffix rejection the Global Constraints describe). Anything else changed = a regression, stop and investigate. Then:

```sh
cp /tmp/check_test_new.out clarusc/test/check_test.out
```

- [ ] **Step 7: T1**

Run: `scripts/test-task.sh` — expected PASS (compiler untouched beyond front end; no emit changes yet).

- [ ] **Step 8: Commit**

```sh
git add clarusc/parse.cla clarusc/ast.cla clarusc/check.cla clarusc/test/check_test.cla clarusc/test/check_test.out
git commit -m "feat: parse + check '= ptr' extern clause (conv 10)"
```

---

### Task 2: Host lane — cprint cast-and-call

**Files:**
- Modify: `clarusc/cprint.cla` (`fpCallExt` ~1596, `cpEmitExternProtos` ~5842)
- Create: `testdata/lowlevel/ptrcall_host.cla`

**Interfaces:**
- Consumes: conv 10 from Task 1 (`irExternConv(xi) == 10` — lower.cla copies decl conv into the IR extern table already; verify by reading `irExternConv`, no lower.cla change expected).
- Produces: host C of the form `((RET (*)(P1, ...))(TARGET))(a2, ...)` — scalar param/ret types from `cpCbWireType`/`cpCbRetWireType`, `const uint8_t *` for KStr, `cpCType` for KText, `void` return when the extern is void.

- [ ] **Step 1: Write the failing fixture**

`testdata/lowlevel/ptrcall_host.cla` (modeled directly on `testdata/lowlevel/callback_host.cla` — read it and `internal/lowlevel/lowlevel_test.go`'s TestLowlevel first to match the harness's alert-output convention):

```rust
// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

// ptrcall_host.cla: `= ptr` extern (conv 10) host-lane proof
// (extern-ptr-call phase). The target is a `callback func`'s decayed
// glue address -- fpCallExt's cast uses the same cpCbWireType wire
// types the glue itself is declared with, so this call is a strictly
// conforming C function-pointer call, the per-signature generalization
// of callback_host.cla's fixed-shape CbInvoke seam.
external func NewPtr(size: int): ptr
external func DisposePtr(p: ptr)
external func PtrCallMixed(entry: ptr, w: word, flag: bool, out: ptr, n: int): int = ptr

callback func mixed(w: word, flag: bool, out: ptr, n: int): int {
    pokel(out, n + w)
    if flag {
        return n * 2
    }
    return n
}

on App.startCLI(args: list of string) {
    var scratch: ptr
    var r: int

    scratch = NewPtr(4)
    r = PtrCallMixed(mixed, 7, true, scratch, 21)
    if r == 42 {
        alert("ptrcall-ret-ok")
    } else {
        alert("ptrcall-ret-FAIL")
    }
    if peekl(scratch) == 28 {
        alert("ptrcall-write-ok")
    } else {
        alert("ptrcall-write-FAIL")
    }
    DisposePtr(scratch)
}
```

- [ ] **Step 2: Run to verify it fails**

Run: `go test -count=1 -run TestLowlevel ./internal/lowlevel`
Expected: FAIL on ptrcall_host — the emitted C calls an undefined `rt_ext_PtrCallMixed` (or the cc compile of it fails).

- [ ] **Step 3: Implement**

In `clarusc/cprint.cla`:

1. Add an extern-index lookup (mirror of cg68k.cla's `cgExternIdxByName`, placed near `fpCallExt`):

```rust
// fpExternIdxByName finds the IR extern table entry for an ECallExt's
// callee name, or -1 (extern-ptr-call phase -- fpCallExt needs the
// conv flag; mirrors cg68k.cla's cgExternIdxByName).
func fpExternIdxByName(nameIdx: int): int {
    var i: int

    i = 0
    while i < irExternCount() {
        if irExternName(i) == nameIdx {
            return i
        }
        i = i + 1
    }
    return -1
}
```

2. In `fpCallExt`, look up `xi = fpExternIdxByName(irCallExtName(e))` before the arg loop. When `xi != -1 and irExternConv(xi) == 10`: render the FIRST arg separately via `fpExpr` as the target, build `args` from the REMAINING args with the existing loop body (KStr → `fpStrAddr`, no synth wrapping — a conv-10 extern is never a UI synth), and build the call as:

```
call = "((" + castRet + " (*)(" + castParams + "))(" + targetText + "))(" + args + ")"
```

where `castRet` = `cpCbRetWireType(irExternRet(xi))` and `castParams` joins, for each declared param AFTER the first: KStr → `"const uint8_t *"`, KText → `cpCType`, else `cpCbWireType`; zero remaining params → `"void"`. Every other conv falls through to the existing `rt_ext_`/synth logic untouched.

3. In `cpEmitExternProtos`, extend the `skip` condition: `or irExternConv(i) == 10` — a conv-10 extern has no `rt_ext_` host symbol; emitting the prototype would declare a name nothing defines. Note in the comment.

- [ ] **Step 4: Run to verify it passes**

Run: `go test -count=1 -run TestLowlevel ./internal/lowlevel`
Expected: PASS (ptrcall_host and every pre-existing fixture).

- [ ] **Step 5: T1 + commit**

```sh
scripts/test-task.sh
git add clarusc/cprint.cla testdata/lowlevel/ptrcall_host.cla
git commit -m "feat: host-lane '= ptr' extern call (cast through cpCbWireType signature)"
```

---

### Task 3: Native lane — cg68k JSR-through-pointer

**Files:**
- Modify: `clarusc/cg68k.cla` (`cgCallExtPascal` ~10335, `cgCallExt` dispatch ~10559)

**Interfaces:**
- Consumes: conv 10 externs from Task 1; the fixture from Task 2 (reused as an emit68k smoke input).
- Produces: `cgCallExtPtr(e, xi)` emitting: push target long → result slot → pascal args → `MOVEA.L (off,A7),A0` → `JSR (A0)` → result readback → `ADDQ.L #4,A7`.

- [ ] **Step 1: Verify current failure mode**

Run: `scripts/build-68k.sh PtrCallHost testdata/lowlevel/ptrcall_host.cla`
Expected: FAIL — conv 10 falls into `cgCallExtNatFallback`, which aborts on a `nat_PtrCallMixed` that doesn't exist (whatever the exact message: record it in the task report). This confirms the dispatch hole.

- [ ] **Step 2: Extract the shared pascal arg-push loop**

In `cgCallExtPascal`, the `while a != -1` arg loop (the four-way KStr/KText / KBool/KChar / KWord / default push) moves verbatim into a helper both conveys call:

```rust
// cgPushPascalArgs pushes pascal-convention args starting at arg node
// `a` with param index `j0` (extern-ptr-call phase: factored out of
// cgCallExtPascal so cgCallExtPtr can push args 1.. against params 1..,
// its arg 0 being the jump target, never pushed). Byte-identical
// emission for conv 1/9 callers (j0 = 0, a = args head). Returns the
// total bytes pushed (2 per bool/char/word slot, 4 otherwise), which
// cgCallExtPtr needs to address the saved target below the args.
func cgPushPascalArgs(a: int, xi: int, j0: int): int {
    ...existing loop body, plus a `bytes` accumulator...
}
```

`cgCallExtPascal` becomes: result-slot push, `cgPushPascalArgs(irCallExtArgsHead(e), xi, 0)` (return value ignored), then the existing sel/seld0/trap/readback tail — no emission change.

- [ ] **Step 3: Implement cgCallExtPtr**

```rust
// cgCallExtPtr implements `= ptr` (conv 10, extern-ptr-call phase):
// pascal-convention call through a runtime pointer. Arg 0 is the jump
// target: evaluated FIRST (declaration order), pushed as a saved long
// BELOW the result slot -- never between the result slot and the args,
// where it would break the pascal callee's result-write offset -- then
// re-read into A0 at call time and discarded (ADDQ) after the callee
// (which pops only its own declared args, pascal discipline) returns.
// Marshalling of args 1.. and the result readback are cgCallExtPascal's
// own, byte for byte (cgPushPascalArgs + the same retIsShortSlot/
// retIsSigned readback arms).
func cgCallExtPtr(e: int, xi: int) {
    var retTy: int
    var retIsShortSlot: bool
    var retIsSigned: bool
    var argBytes: int
    var slotBytes: int

    retTy = irExternRet(xi)
    retIsSigned = irtKind(retTy) == KWord
    retIsShortSlot = irtKind(retTy) == KBool or irtKind(retTy) == KChar or retIsSigned
    // 1. target: evaluate arg 0, save it on the stack
    cgExpr(irCallExtArgsHead(e))
    a68Emit(OpMove, 4, AmDn, 0, 0, AmPreDec, 7, 0)
    // 2. result slot (same shapes as cgCallExtPascal)
    slotBytes = 0
    if irtKind(retTy) != KVoid {
        if retIsShortSlot {
            a68Emit(OpClr, 2, AmNone, 0, 0, AmPreDec, 7, 0)
            slotBytes = 2
        } else {
            a68Emit(OpClr, 4, AmNone, 0, 0, AmPreDec, 7, 0)
            slotBytes = 4
        }
    }
    // 3. args 1.. against params 1..
    argBytes = cgPushPascalArgs(irExprNext(irCallExtArgsHead(e)), xi, 1)
    // 4. fetch saved target, call through it
    a68Emit(OpMovea, 4, AmDisp16, 7, argBytes + slotBytes, AmAn, 0, 0)
    a68Emit(OpJsr, 0, AmNone, 0, 0, AmInd, 0, 0)
    // 5. result readback (same three arms as cgCallExtPascal's tail)
    if irtKind(retTy) != KVoid {
        if retIsSigned {
            a68Emit(OpMove, 2, AmPostInc, 7, 0, AmDn, 0, 0)
            a68Emit(OpExt, 4, AmNone, 0, 0, AmDn, 0, 0)
        } else if retIsShortSlot {
            a68Emit(OpClr, 4, AmNone, 0, 0, AmDn, 0, 0)
            a68Emit(OpMove, 2, AmPostInc, 7, 0, AmDn, 0, 0)
            a68Emit(OpLsr, 4, AmImm, 0, 8, AmDn, 0, 0)
        } else {
            a68Emit(OpMove, 4, AmPostInc, 7, 0, AmDn, 0, 0)
        }
    }
    // 6. discard the saved target
    a68Emit(OpAddq, 4, AmImm, 0, 4, AmAn, 7, 0)
}
```

Wire the dispatch in `cgCallExt`: add `} else if conv == 10 { cgCallExtPtr(e, xi) }` before the `cgCallExtNatFallback` else. VERIFY (read `asm68k.cla`'s encoder) that `OpMovea` accepts an `AmDisp16` SOURCE with register 7 (A7-relative displacement) and `OpJsr` accepts an `AmInd` destination — `JSR (A0)` encodes as 0x4E90. If either mode/op pairing is missing from the encoder, add it there (with its own encode test in `clarusc/test/asm68k_test.cla` + `.out` rebless, same drill as check_test). Also confirm the exact `AmAn`-destination spelling for `ADDQ` to A7 against an existing `ADDQ`-to-SP site in cg68k.cla (grep `OpAddq`) and copy its operand form.

- [ ] **Step 4: Verify emit68k builds it**

Run: `scripts/build-68k.sh PtrCallHost testdata/lowlevel/ptrcall_host.cla`
Expected: builds clean to `build-68k/` — but startCLI doesn't boot natively (see `testsuite/core/cli_mac.cla`'s doc comment), so this step proves codegen/assembly only. The on-hardware proof is Task 4's suite boot.

- [ ] **Step 5: T1 with smoke + commit**

```sh
scripts/test-task.sh --smoke
git add clarusc/cg68k.cla clarusc/asm68k.cla clarusc/test/asm68k_test.cla clarusc/test/asm68k_test.out
git commit -m "feat: native-lane '= ptr' extern call (pascal marshal + JSR through saved target)"
```

(Drop the asm68k paths from the add if Step 3 needed no encoder change.)

---

### Task 4: Core suite `PtrCall` case — hardware proof on both lanes

**Files:**
- Create: `testsuite/core/cases_ptrcall.cla`
- Modify: `testsuite/core/runner.cla` (enum + dispatch + `nCoreCases` 79→80)
- Modify: `internal/mactest/suite_host_test.go` (`coreCLIFiles`), `internal/testsuite/core_cli_test.go`, `internal/cg68k/segment_test.go`, `internal/bake/bakeidentity_test.go` (each holds its own copy of the core file list — grep `cases_evalorder.cla` in each to find the exact spot and add `cases_ptrcall.cla` alongside)

**Interfaces:**
- Consumes: conv 10 end-to-end from Tasks 1–3.
- Produces: `CoreTest` member `PtrCall`, case function `casePtrCall(): TestResult` (built with `tkPass`/`tkFail` from `testsuite/kit.cla`, like every sibling) in `cases_ptrcall.cla`, wired into `runner.cla`'s dispatch like every neighboring case (read `cases_evalorder.cla` + its runner wiring as the template).

- [ ] **Step 1: Write the case**

`testsuite/core/cases_ptrcall.cla` — same header/reporting idiom as `cases_evalorder.cla` (read it first; use `tkExpectInt`-style kit helpers if that's what siblings use, otherwise plain compare-and-report):

```rust
// casePtrCall: `= ptr` extern (conv 10) round trip through a
// callback's decayed glue address (extern-ptr-call phase). On the
// native lane the glue is real pascal-convention 68k code, so this
// hardware-proves the marshalling -- word sign, bool high-byte-in-word,
// ptr, int, and a signed word RESULT -- against the compiler's own
// glue. On host it proves fpCallExt's cast-and-call.
external func PcNewPtr(size: int): ptr = trap 0xA11E reg
external func PcDisposePtr(p: ptr) = trap 0xA01F reg
external func PtrCallRound(entry: ptr, w: word, flag: bool, out: ptr, n: int): word = ptr

callback func pcMixed(w: word, flag: bool, out: ptr, n: int): word {
    pokel(out, n + w)
    if flag {
        return w - 100
    }
    return w
}
```

plus a `casePtrCall(): bool` that allocates a 4-byte scratch, calls `PtrCallRound(pcMixed, 7, true, scratch, 21)`, and checks: result == -93 (proves signed word round trip both directions), `peekl(scratch) == 28` (proves ptr + int arrived), plus a `flag == false` second call proving the bool actually steers (result == 7). NOTE: check first (grep `toolbox/memory.cla` and sibling core cases) whether NewPtr/DisposePtr externs are already declared in a file the core suite composes — if so, reuse those and drop the `Pc*` duplicates; if core has its own allocator idiom (some cases use text/list instead of raw ptr), match it. `pokel`/`peekl` are language intrinsics (see `callback_host.cla`), fine on both lanes.

- [ ] **Step 2: Wire the runner**

In `testsuite/core/runner.cla`: add `PtrCall` to the `CoreTest` enum, add the dispatch arm calling `casePtrCall()` (copy the neighboring arm's exact reporting shape), bump `const nCoreCases: int = 79` → `80`, and update its doc comment ("the 79 real cases plus...").

- [ ] **Step 3: Add the file to all four Go file lists**

Grep `cases_evalorder.cla` under `internal/` — add `cases_ptrcall.cla` entries in `internal/mactest/suite_host_test.go`, `internal/testsuite/core_cli_test.go`, `internal/cg68k/segment_test.go`, `internal/bake/bakeidentity_test.go`, each with a one-line comment (`// extern-ptr-call phase: runner.cla unconditionally calls casePtrCall().`).

- [ ] **Step 4: Host CLI run**

```sh
cc -O1 -I runtime/host -o build-run/clarusc clarusc/clarusc.c runtime/host/rt.c 2>/dev/null || true
scripts/clarus-run.sh --help >/dev/null 2>&1 || true   # ensure bootstrap cache
build-run/clarusc emit --rtdir runtime/clarus/ -o /tmp/core_cli.c \
    testsuite/kit.cla testsuite/core/runner.cla testsuite/core/cases_*.cla testsuite/core/cli.cla
cc -O1 -I runtime/host -o /tmp/core_cli /tmp/core_cli.c runtime/host/rt.c
/tmp/core_cli PtrCall
```

CAUTION: `clarusc/clarusc.c` is the COMMITTED snapshot — it predates Task 1, so the `cc` bootstrap above cannot compile the new syntax. Build the CURRENT compiler instead the way `scripts/clarus-run.sh` does (it bootstraps from the snapshot, then the snapshot compiler compiles current source — read the script and reuse its cached current-source clarusc), or emit via `go test`-side harnesses which already do this. Simplest reliable form: run the whole host suite through the existing gate — `go test -count=1 -run 'TestCoreCLI' ./internal/testsuite` (check the exact test name in `core_cli_test.go`).
Expected: PtrCall PASS (and `all` stays green).

- [ ] **Step 5: Native boot — the hardware proof**

Run: `CLARUS_MAC_TESTS=1 go test -count=1 -run TestCoreSuiteGUIOn68k ./internal/mactest`
Expected: PASS with a `PtrCall` subtest green. This is the phase's load-bearing evidence: real pascal glue called through a runtime pointer on the 68k lane.

- [ ] **Step 6: T1 + commit**

```sh
scripts/test-task.sh
git add testsuite/core/cases_ptrcall.cla testsuite/core/runner.cla internal/mactest/suite_host_test.go internal/testsuite/core_cli_test.go internal/cg68k/segment_test.go internal/bake/bakeidentity_test.go
git commit -m "test: core suite PtrCall case -- '= ptr' round trip via callback glue (80 cases)"
```

---

### Task 5: Documentation

**Files:**
- Modify: `docs/clarus-language-reference.md` (grammar production ~line 1774; new subsection inserted immediately before `### The \`word\` Extern Type`, line ~1849)
- Modify: `docs/clarus-toolbox-cookbook.md` (new recipe section)

**Interfaces:**
- Consumes: the approved spec (`docs/superpowers/specs/2026-08-27-extern-ptr-call-design.md`) — the reference subsection is the spec's "Language surface" + "Rules" made normative, in the reference's own voice.

- [ ] **Step 1: Reference — grammar + subsection**

1. In the `externDecl` grammar block (~1774), extend the clause alternatives: `[ "=" ( "trap" ... | "inline" ( "deref" | "nop" | "a5" ) | "ptr" ) ]`.
2. Insert a `### The \`ptr\` Clause` subsection before `### The \`word\` Extern Type`, covering (in the reference's normative style, with worked code): first-param-is-target rule (must exist, must be `ptr`, consumed not pushed); remaining params/return marshal identically to the plain pascal `trap` clause (cross-reference the high-byte bool/char paragraph rather than restating it); no suffixes (`sel`/`reg`/etc. do not compose); redeclaration-merge rule applies unchanged; a `callback func` name is a valid target argument (it is an extern `ptr` parameter — the decay rule needs no new case); nil/garbage target is undefined behavior, the caller's contract; interrupt-time entry points are out of scope, mirroring `callback func`'s own paragraph. Worked example: the spec's GetResource → HLock → HandleToPtr → `PluginMain(code, 1, pb)` sequence, plus the "a calling contract, not a binding — same declaration, different pointer" sentence.

- [ ] **Step 2: Cookbook recipe**

Add a "Calling loaded code" section to `docs/clarus-toolbox-cookbook.md`: when to reach for `= ptr` (code resources, ProcPtrs you hold), the same worked example, and the two footguns (lock the handle for the lifetime of every call into it; declare one extern per distinct entry-point shape).

- [ ] **Step 3: Verify + commit**

Re-read both diffs against the spec's Rules list — every numbered rule must appear in the reference text.

```sh
git add docs/clarus-language-reference.md docs/clarus-toolbox-cookbook.md
git commit -m "docs: '= ptr' extern clause -- reference subsection + cookbook recipe"
```

---

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
