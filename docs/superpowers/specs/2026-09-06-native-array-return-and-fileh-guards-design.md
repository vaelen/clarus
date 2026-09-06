# native-array-return-and-fileh-guards — design

Date: 2026-09-06. Branch: `native-array-return-and-fileh-guards`, off
`main`. Status: design approved in discussion (Andrew, 2026-09-06); spec
for review before planning.

Clears the five entries left in `docs/TODO.md`'s "Compiler correctness /
cleanup" and "Runtime / Toolbox robustness" sections after the
2026-09-06 triage. That triage (same day, same session) moved the
`cg_free_globals` segment-budget entry to the on-hold Compiler-on-Mac
section with measurements, and closed three entries as code comments
rather than work: the C-lane `KErr` by-value asymmetry (`cgParamByRef`'s
doc), abort-inside-a-global-initializer (`cgEmitInitGlobalsStub` and
`cpEmitUiMain`), and the `cg_init_globals` frame imprecisions (the
`frameSize` guard's doc). Those three are not in this phase.

## 1. Entry dispositions

Entries as they read in `docs/TODO.md` at the start of this phase.

| # | Entry | Section |
|---|---|---|
| 1 | Array RETURNS still abort on `emit68k` | §2 |
| 2 | Handle-bearing fixed-array PARAMETERS abort with the generic message | §3 |
| 3 | `cg_init_globals` emits stores for zero-valued explicit initializers | §4 |
| 4 | `file.rename("", x)` reaches `PBHRenameSync` with an empty name | §5 |
| 5 | Sidecar `filehandle` minors (flush target, close status, `/tmp`) | §6 |

After this phase both TODO.md sections are empty and are deleted.

## 2. Native array returns, scalar elements only (entry 1)

### 2.1 What exists

`func mk(): int[4]` checks clean and runs on the host lane (verified
2026-09-06 with a probe: `b = mk()` and `sum4(mk())` both print the
right sum). On `emit68k` the same program aborts with the generic
`cgExpr: EVarRef non-scalar (str/rec/arr) reached in value context`
message, because `cgRetNeedsHidden` (`clarusc/cg68k.cla`) is a
three-kind test (`KStr`/`KRec`/`KErr`) and an array result never gets a
hidden-result slot. Everything downstream of that predicate is already
generic: `cgCallFnInto` pushes args then the destination address;
`cgEmitReturnErr`/`cgEmitReturnRec` block-copy through the pointer at
8(A6); `cgEmitStoreArr` is the single whole-array copy helper both
`cgMaterializeToTemp`'s `KArr` arm and `cgStmt`'s `SAssign` arm route
through, and its Task 9 guard is what turns the reachable half into a
diagnostic today.

### 2.2 Scope

Arrays whose element type does not `cgNeedsRelease`: `int`, `fixed`,
`char`, `bool`, enums, `ptr`, nested arrays of those, and records made
only of those. This is exactly the set `cgParamByRef` already passes by
address, so the return ABI and the parameter ABI share one boundary.
Handle-bearing element arrays (a `text`/`list`/`map` anywhere inside)
stay unsupported as returns; §3 gives them a named diagnostic.

### 2.3 Design

Five edits in `clarusc/cg68k.cla`, no IR or checker change (the checker
and the host lane already accept the shape).

1. **`cgRetNeedsHidden`** adds `irtKind(retTy) == KArr and not
   cgNeedsRelease(retTy)`. Its doc comment gains the KArr sentence and
   the "shares `cgParamByRef`'s boundary" note. Every existing caller
   (callee frame layout in `cgEmitFunc`, the discard gate in
   `cgCallFnScalar`, `cgCallFnInto`'s callers) picks the new kind up
   from this one predicate.
2. **`cgEmitReturnArr(src)`**: `cgEmitReturnErr`'s body verbatim
   (size from `cgCurRetType`, `cgExprAddr(src)` stashed across the 8(A6)
   read, `cgBlockCopy`). There is no array constructor expression, so no
   `ENewRec`-style fast arm. `cgReturnStmt` dispatches to it on
   `irtKind(cgCurRetType) == KArr`.
3. **`cgEmitStoreArr`** gains the `ECallFn` fast path `cgEmitStoreRec`
   already has: `if irExprKind(src) == ECallFn { cgCallFnInto(src,
   dst); return }` ahead of the addressability guard. This one arm
   covers all three consumer shapes, because all three funnel into this
   function: `b = mk()` (SAssign), `sum4(mk())` (`cgPushArgs` →
   `cgMaterializeToTemp`), and `return mk()` (`cgEmitReturnArr` →
   `cgExprAddr`'s materialize fallback). The guard's message is
   reworded: it now fires only for a non-call, non-addressable source
   (in practice a handle-bearing shape §3 catches first), so the
   "return a `list` instead" advice moves to §3's diagnostics.
4. **`cgCallFnScalar`'s discard arm** (a bare `mk()` statement) adds a
   `KArr` case beside its `KRec`/`KErr`/`KStr` dispatch, calling
   `cgEmitStoreArr(dst, e)` (whose new `ECallFn` arm routes to
   `cgCallFnInto`). The temp comes from the arm's existing
   `cgNewTrackedTmp(retType)` call; `cgAllocTmpOff` already picks the
   big pool for any type wider than 4 bytes, so no allocation change is
   needed. A scalar array owes no release, so the end-of-statement flush
   is a no-op on the slot, but tracking keeps it inside the existing
   pool discipline.
5. **`cgEmitStoreArr`'s doc comment** drops the sentence "a function
   CANNOT return an array through the hidden result pointer on this
   backend" and the matching clause in `cgRetNeedsHidden`'s doc.

`cgArgSlotSize`, `cgParamByRef` and the frame ref bit are untouched: a
returned array is written by the callee through the hidden pointer, it
is not a parameter.

### 2.4 Tests

- `testdata/cg68k/karr_return.cla`, a new `.s` golden picked up by
  `tests/cg68k/goldens.sh`, modeled on `karr_param.cla`: `mk()` returning
  a filled `int[4]`, consumed as `b = mk()`, `sum4(mk())`, `return mk()`
  from a forwarding function, and a bare discarded `mk()`. The listing
  shows the hidden-pointer push and the block copy. `tests/cg68k/vasm.sh`
  already round-trips every fixture under `testdata/cg68k/`, so the new
  fixture is encoder-checked with no further script change.
- A core-suite case `ArrReturn` in `testsuite/core/cases_arr.cla`
  asserting the four consumer shapes produce the right values, run on
  both lanes. Bumps the five hand-maintained count sites: `nCoreCases`,
  `tests/mactest/coresuite_68k.sh` and `coresuite_mac.sh`'s
  `suite_report_check` literals, `tests/testsuite/core_cases.txt`, and
  CLAUDE.md.
- `tests/bake/` needs no new twin: no runtime module is added.

### 2.5 Reference

`docs/clarus-language-reference.md`'s function/array chapter states
that a fixed array is a legal return type, copied to the caller by
value, on both lanes, and that an array whose elements carry a `text`,
`list` or `map` cannot be returned or passed by value natively (use a
`list`, or pass the array by reference through a record field).

## 3. Named diagnostics for handle-bearing arrays (entry 2)

Two sites, each a kind test followed by `abort` with a message that
names the offending element type and the alternative. Both replace
paths that today reach `cgExpr`'s generic `EVarRef non-scalar` abort.

- **Parameter**: the top of `cgPushArgs`' by-value arm (the `else` of
  `if cgParamByRef(t)`): `if irtKind(t) == KArr { abort("cg68k: a
  fixed array whose elements carry a text/list/map (<elem type>) cannot
  be passed by value natively -- pass a `list`, or put the array in a
  record and pass that") }`. `cgParamByRef` already routes every
  handle-free array by address, so anything reaching this arm as `KArr`
  is handle-bearing by construction.
- **Return**: in `cgEmitFunc`, right after `needsHidden` is computed:
  `if irtKind(irFuncRet(f)) == KArr and not needsHidden { abort(...) }`
  with the matching "cannot be returned natively" wording. This fires
  once per function at emit time, before any body is emitted, so the
  message names the function.

Element type text comes from the existing IR type printer used by other
`cg68k:` diagnostics. Tests: two fail-closed subcases in
`tests/cg68k/array_assign.sh`, in the same shape as its existing
`handle_elem_fails_closed` case (emit must fail, the named message must
appear, no `.bin` left behind), one for `func f(a: Named[2])` where
`Named` has a `text` field, one for `func g(): text[2]`.

## 4. Skip zero-valued explicit initializers (entry 3)

`cgEmitInitGlobalsStub`'s skip predicate today is `not fullReplace and
not cgDefaultIsAllZero(gt, 0, -1)` for the default-init half and
unconditional for the `initE != -1` half. The change is one more
predicate on the second half: skip `cgEmitGlobalInitExpr` when
`cgInitIsZeroConst(initE)` and `cgDefaultIsAllZero(gt, 0, -1)`.

`cgInitIsZeroConst(e)` is true for an `EIntConst` whose value is 0, or
an `EConv` of op `CvIntToPtr` wrapping one. Lowering already turns
`false`, `nil`, `'\0'`, `0.0` (fixed raw 0) and a zero-valued enum
member into `EIntConst 0`, and `ptr(0)` into `CvIntToPtr(EIntConst 0)`,
so the one predicate covers every spelling the reference admits. A
`KStr` global with `= ""` is not in scope: `cgDefaultIsAllZero` is
already false for it (the length byte is explicit) and it takes the
`cgEmitStoreStr` path.

Correctness rests on the same fact §3.5 of the language-runtime-cleanup
spec relied on: `cgEmitStartup`'s below-A5 sweep has already zeroed
every global before `cg_init_globals` runs, so a zero store is a no-op.
The host lane is untouched (C static storage is zero by definition and
`cpEmitGlobalsInit` prints the initializer as source text).

Tests: no existing `testdata/cg68k` fixture has a zero-valued explicit
global initializer (checked 2026-09-06), so a new
`testdata/cg68k/globals_zero_init.cla` pins the shape: `= 0`, `= false`,
`= ptr(0)`, `= nil` (a window ref) and a zero enum member, each read
back in `App.launch` so shaking keeps them, plus one `= 1` control that
must keep its store. Its blessed `.s` has no `cg_init_globals` store
for the zero-valued five and exactly one for the control. A grep of the
existing fixtures found no zero-valued explicit global initializer, but
the bless diff is the proof, not the grep: `CLARUS_CG68K_BLESS=1` must
add the new file, and any other golden it touches must show only
removed `cg_init_globals` store pairs.

## 5. `file.rename("", x)` guard (entry 4)

`rtFhRename` (`runtime/clarus/fileh.cla`) validates `newName` (non-empty,
no `:`) and nothing about `path`. On the native lane `rtFhDevRename("")`
reuses `rtFhDevStat("")`, whose empty-path branch (the "program's own
folder" convention `exists("")`/`info("")` rely on) returns true with
parent DirID 0, so `PBHRenameSync` is issued with an empty leaf name
and `ioDirID = 0`. Inside Macintosh's rename semantics for that shape
are a volume rename, not a file rename. The guard is one check at the
top of `rtFhRename`, before the `newName` checks:

```
if path == "" {
    rtSetLastErr(-37, "rename failed")
    return false
}
```

Shared function, both lanes, same error code as the empty-`newName`
branch. `rtFhDevStat`'s empty-path convention is unchanged; only
`rename` refuses it, since "rename the program's own folder" has no
sensible meaning through a leaf-name API.

Tests: one assertion in the existing `DirOps` core case
(`testsuite/core/cases_dirops.cla`), `file.rename("", "x")` returns
false with `lastError.code == -37`, so it is hardware-proved on both
lanes without a new case. The reference's `rename` row gains "an empty
`path` fails".

## 6. Sidecar `filehandle` minors (entry 5)

All in `runtime/host/rt_fileh.inc`, all binding only on the AppleDouble
path (non-Apple host, or `CLARUS_FORCE_APPLEDOUBLE=1`).

- **Temp path**: the `mkstemp` template honours `TMPDIR` when set and
  non-empty, else `/tmp`; the buffer grows to hold it (`PATH_MAX`).
- **Flush target**: `rt_fh_sidecar_store` calls `fflush` and
  `fsync(fileno(f))` before `fclose`, and returns non-zero if either
  fails. `rt_ext_FhHFlush` then already does the right thing: it stores
  the sidecar (now durable) and fsyncs the temp. The temp fsync stays;
  it is harmless and keeps the native-fork branch's code path identical.
- **Close status**: `close()` is void by contract (reference: "idempotent")
  on both lanes and every lane's device layer, so a failed write-back at
  close is not made observable through `close`. Instead
  `rt_ext_FhHClose` records the store's failure in `rt_fh_errno` (it
  already ignores the return today), and the reference's `close` row
  states that on the AppleDouble path the write-back is best-effort at
  close and `flush()` is the call that reports failure. That is the same
  promise the native lane makes: `PBCloseSync` failures are dropped too.

Tests: the forced-AppleDouble block in `runtime/host/rt_fileh_test.c`
(run by `tests/hostrt/fileh.sh`) gains two checks. (1) `TMPDIR` is
honoured: with `TMPDIR` pointing at a directory that does not exist,
`rt_ext_FhHOpenRF` fails and `rt_ext_FhHErrno()` is `ENOENT`; with
`TMPDIR` pointing at the test's own scratch directory it succeeds. The
temp is unlinked the moment it is created, so its location can only be
observed through that failure. (2) Flush is the durability barrier:
after `WriteAt` + `Flush` and BEFORE `Close`, the `._` sidecar file read
directly from disk already holds the written bytes, and its size and
AppleDouble magic are right.

## 7. Out of scope

- Handle-bearing array returns and by-value copies (the retain walk).
- The C-lane `KErr` by-value asymmetry (documented, deliberate).
- Making `close()` return a status on either lane.
- Everything in TODO.md's on-hold Compiler-on-Mac section, including
  the `cg_free_globals` glue duplication measured during triage.

## 8. Gates

T1 after each task (`scripts/test-task.sh --smoke`, since `clarusc/`
and `runtime/` are both touched). T2 before merge. The `.s` goldens
bless once, at the end of §2–§4's compiler work, and the diff is
reviewed hunk by hunk: §2 adds hunks only to the new fixture, §3 adds
none, §4 removes `cg_init_globals` lines only. No runtime module is
added, so no `tests/bake/` twin and no Snow `clarusc_bake` run is owed;
`clarusc/bake.cla` and `macgui.cla` are not edited.
