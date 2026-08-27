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
external func NewPtr(size: int): ptr = trap 0xA11E reg
external func DisposePtr(p: ptr) = trap 0xA01F reg
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



## Controller ruling (preflight, binding)

Ruling 1: the fixture's NewPtr/DisposePtr declarations carry their real trap
clauses (shown above, verbatim from runtime/clarus/list.cla's proven family)
rather than callback_host.cla's clauseless forms. Host emission is unchanged
(a trap-clause extern still resolves to rt_ext_<name> on host); the clause
is required so Task 3 can reuse this same fixture under emit68k, where a
clauseless extern aborts ("no trap clause and no nat_ fallback").
