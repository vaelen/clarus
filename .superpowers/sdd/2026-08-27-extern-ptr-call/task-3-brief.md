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

