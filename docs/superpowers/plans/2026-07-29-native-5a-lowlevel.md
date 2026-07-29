# Plan 5a: Low-Level Language Corner + Toolbox-Externals Waist — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add the `ptr` type, `peekb/peekw/peekl` + `pokeb/pokew/pokel` builtins, and bodiless `external func` declarations to clarusc, lowered by cprint to calls into a new host Toolbox shim (`rt_ext_host.inc`) — the narrow-waist seam from the Plan 5 design spec (`docs/superpowers/specs/2026-07-29-native-68k-toolchain-design.md`).

**Architecture:** New scalar type kind `TyPtr`/`KPtr` threaded through types→check→ir→lower→cprint following the `TyAddress` precedent; peek/poke as universe builtins lowering to new IR intrinsics emitted as `rt_peek*/rt_poke*` static-inline helpers in `rt.h`; `external func` as a new contextual top-level decl (`DkExternFunc`) whose calls lower to a new `ECallExt` IR node emitted as `rt_ext_<name>(...)` with `extern` prototypes. Host shim delegates to the existing host Memory Manager shim so the strict-ledger instrumentation covers the seam.

**Tech Stack:** Clarus (clarusc/*.cla), C99 (internal/build/rt), Go test harnesses.

**Scope decisions locked with Andrew (2026-07-29):** trap-number clauses on external decls are DEFERRED to 5d/5e (nothing consumes them until codegen68k); builtin names are `peekb/peekw/peekl/pokeb/pokew/pokel`.

## Global Constraints

- **The Go compiler is FROZEN.** New-syntax fixtures must NEVER be placed in `testdata/valid`, `testdata/errors`, `testdata/run`, `testdata/run/lib`, `testdata/runerr`, `testdata/include`, `testdata/diag`, `testdata/suite`, or as driver-level syntax in `clarusc/test/*_test.cla` — all are compiled by the frozen Go compiler. Safe homes: `testdata/emitui/` (clarusc-only emit/fence), new `testdata/lowlevel/` (created in Task 3), and *string-embedded* source inside `clarusc/test/check_test.cla` cases.
- **clarusc's own source must not USE the new features** (conservative-subset rule, `docs/ROADMAP.md`): the bootstrap snapshot must keep compiling clarusc source.
- **Every commit that touches `clarusc/*.cla` must regenerate the snapshot in the same commit:**
  ```sh
  go run ./cmd/clarus build -o /tmp/clarusc clarusc/main.cla
  /tmp/clarusc emit -o clarusc/clarusc.c clarusc/main.cla
  ```
  and, if emitted-C shape changed, re-emit every `testdata/emitui/*.c.golden` with the same `/tmp/clarusc emit -o <golden> <fixture>`.
- **The bootstrap one-liner must keep working:** `cc -I internal/build/rt -o clarusc clarusc/clarusc.c internal/build/rt/rt.c`. Therefore ALL new host runtime C is `#include`d into `rt.c` as a `.inc` — never a new `.c` translation unit (`docs/superpowers/plans/2026-07-28-memory-audit-4e.md:18`).
- Host cc invocation everywhere is `cc -std=c99 -O1` (`internal/build/build.go:89`, `internal/selfhost/emit_test.go:82`).
- New reference-doc fences using new syntax must be registered clarusc-only (Task 1) or `TestDifferentialFences` fails.
- Work on branch `native-5a`. Run `go test ./...` before every commit claim; no commit with red tests.
- `TokKind` order is load-bearing (`clarusc/tok.cla:6-12`); do NOT add tokens. `external` stays a contextual identifier. `TypeKind`/`DeclKind` order is not load-bearing; append new members last.

---

### Task 1: Clarusc-only fence mechanism + language-reference chapter

**Files:**
- Modify: `docs/clarus-language-reference.md` (new "Chapter 13: Low-Level Memory Access" before Appendix A; Appendix A grammar additions)
- Modify: `internal/reftest/manifest.go` (new `ClaruscOnly` index list)
- Modify: `internal/selfhost/differential_test.go:150-173` (`TestDifferentialFences` skips ClaruscOnly fences)
- Modify: `internal/reftest/reftest_test.go` (guard: ClaruscOnly fences must exist and must NOT be in `CheckClean`)

**Interfaces:**
- Produces: `reftest.ClaruscOnly []int` — fence indices (same numbering as `CheckClean`) that the frozen Go compiler cannot parse; every Go-side fence sweep must skip them.

- [ ] **Step 1: Write the failing guard test.** In `internal/reftest/reftest_test.go`, add:

```go
func TestClaruscOnlyDisjoint(t *testing.T) {
	fences, err := ExtractFences("../../docs/clarus-language-reference.md")
	if err != nil {
		t.Fatal(err)
	}
	if len(ClaruscOnly) == 0 {
		t.Fatal("expected at least one clarusc-only fence (Chapter 13)")
	}
	clean := map[int]bool{}
	for _, i := range CheckClean {
		clean[i] = true
	}
	for _, i := range ClaruscOnly {
		if i < 0 || i >= len(fences) {
			t.Errorf("ClaruscOnly index %d out of range (%d fences)", i, len(fences))
		}
		if clean[i] {
			t.Errorf("fence %d is in both CheckClean and ClaruscOnly", i)
		}
	}
}
```

- [ ] **Step 2: Run it — expect FAIL** (`ClaruscOnly` undefined): `go test ./internal/reftest -run ClaruscOnly`

- [ ] **Step 3: Write the reference chapter.** Add "Chapter 13: Low-Level Memory Access" to `docs/clarus-language-reference.md` (renumber nothing — insert after Chapter 12, before Appendix A). Content it must cover, in normative prose with ```rust fences:
  - **`ptr`**: an untyped 32-bit machine address (host builds may use a wider native representation; programs must not assume size). Zero value is the null address. Obtained from `external` functions or `ptr(intExpr)`; `int(ptrExpr)` converts back (explicit both ways). `p + n` / `p - n` (int offset, byte-granular) yield `ptr`; `==`/`!=`/orderings compare addresses. `ptr` may be a variable, parameter, return, or record-field type, but NOT a container element (`list of ptr`, `map of ptr`, `T[n]` of ptr are errors) and never participates in ARC.
  - **peek/poke**: `peekb(p)`, `peekw(p)`, `peekl(p)` read 1/2/4 bytes at `p` returning int (b/w zero-extended); `pokeb(p, v)`, `pokew(p, v)`, `pokel(p, v)` write the low 1/2/4 bytes of `v`. Byte order is the machine's NATIVE order; any byte layout that leaves the process must be built with explicit byte writes, never `pokew`/`pokel` (the endianness rule from the Plan 5 spec). Out-of-bounds access is undefined — this is the language's unsafe corner.
  - **`external func`**: `external func Name(params): ret` — a leading-position-free top-level declaration (may appear anywhere among top decls) declaring a function implemented by the platform runtime, with no body. Parameter and return types are restricted to `int`, `ptr`, `bool`, `char` (return may be omitted). Call sites are ordinary calls. Trap annotations are reserved for a future revision (deliberate deferral).
  - Appendix A: add `externDecl = "external" "func" IDENT "(" [params] ")" [":" type] ;` to `topDecl`, note `external` is contextual (recognized only when followed by `func`), and add `ptr` to the type grammar note.
  - Mark every new fence's index in `ClaruscOnly` (count fences before yours to get indices; `TestFencesExtract` and the manifest comments in `internal/reftest/manifest.go:17-63` show the numbering discipline — document each new index with a one-line reason, matching house style).

- [ ] **Step 4: Implement `ClaruscOnly`** in `internal/reftest/manifest.go` (alongside `CheckClean` at `manifest.go:64-73`) and make `TestDifferentialFences` (`internal/selfhost/differential_test.go:150-173`) skip those indices with a `t.Logf("fence %d: clarusc-only, skipped", i)`.

- [ ] **Step 5: Run to verify PASS:** `go test ./internal/reftest ./internal/selfhost -run 'Fences|ClaruscOnly'` — all green (the new fences are skipped by differential, absent from CheckClean, present in ClaruscOnly).

- [ ] **Step 6: Commit** — `git commit -m "docs+reftest: Chapter 13 (ptr/peek-poke/external) + clarusc-only fence mechanism"`

---

### Task 2: `ptr` type end-to-end (check + C emission)

**Files:**
- Modify: `clarusc/types.cla` (TyPtr kind, PtrT singleton)
- Modify: `clarusc/check.cla` (resolveType, typeName, checkArith, checkConversion + dispatch, container-element guard)
- Modify: `clarusc/ir.cla` (KPtr, irPtrT)
- Modify: `clarusc/lower.cla` (lowType, lowResolveType, conversion lowering)
- Modify: `clarusc/cprint.cla` (cpCTypeName, ptr arithmetic emission, conversion emission)
- Modify: `clarusc/test/check_test.cla` + `clarusc/test/check_test.out`
- Regenerate: `clarusc/clarusc.c`

**Interfaces:**
- Produces: checker type `PtrT` (types.cla singleton, kind `TyPtr`, rendered `"ptr"`); IR type `irPtrT` (kind `KPtr`, C type `void *`); conversions `ptr(int)`/`int(ptr)`; `ptr ± int → ptr`. Tasks 3-4 rely on `PtrT` and `irPtrT` by these exact names.

- [ ] **Step 1: Write failing checker cases.** Append to `clarusc/test/check_test.cla`, following the file's existing `runCase(label, src)` idiom exactly (source assembled line-by-line with `ln(src, "...")` so the Go-built driver never sees the new syntax as driver syntax). Cases and the diagnostics to append to `check_test.out` (hand-compute line/col to match the existing golden format):
  - `ptr` var decl + `p + 4` + `p - 2` + `p == q` + `p < q` + `int(p)` + `ptr(0)` — checks clean, no diags.
  - `p + p` — expect `invalid operands to +: ptr and ptr`.
  - `p + 1.5` (fixed) — expect invalid-operands diag.
  - `var xs: list of ptr` — expect `ptr cannot be a container element`.
  - `ptr("x")` — expect `cannot convert string(255) to ptr`.

- [ ] **Step 2: Run to verify FAIL:** `go test ./internal/selfhost -run TestClarusModules` — check_test diverges from golden (diags like `unknown type ptr`).

- [ ] **Step 3: Implement `ptr` through the front end.** Exact edits, each mirroring the `TyAddress` precedent:
  - `clarusc/types.cla:34-62`: append `TyPtr` to `enum TypeKind` (after `TyMenuItem`; order not load-bearing).
  - `clarusc/types.cla:112` region: add `var PtrT: int` beside `AddressT`; seed in `typesInit()` beside `types.cla:290`: `PtrT = pushSimple(TyPtr)`.
  - `clarusc/check.cla:1301-1315` (`resolveType`): add `if name == "ptr" { return PtrT }` in the primitive-name chain.
  - `clarusc/check.cla:654-703` (`typeName`): add `case TyPtr { return "ptr" }`.
  - `clarusc/check.cla:3230-3275` (`checkArith`): after the int/int arm (`typeKind(lt) == TyInt and typeKind(rt) == TyInt`), add:
    ```
    if typeKind(lt) == TyPtr and typeKind(rt) == TyInt and (op == OpAdd or op == OpSub) {
        return PtrT
    }
    ```
    (ptr+ptr etc. falls through to the existing invalid-operands diag — no new code.)
  - `checkComparison` (`check.cla:3309+`): verify the same-kind fallthrough returns BoolT for `TyPtr` for both `==` and `<` families; if `TyRec`-style special cases block it, add a `TyPtr` same-kind arm returning `BoolT`.
  - Conversions: in `checkIdentCall`'s conversion dispatch (`check.cla:3679-3688`), add `ptr` → `checkConversion(e, PtrT, "ptr")`. In `checkConversion` (`check.cla:3607-3635`): add `else if target == PtrT { ok = typeKind(at) == TyInt }` and extend the `target == IntT` arm with `or typeKind(at) == TyPtr`.
  - Container-element guard: where list/map/array element types are resolved (follow `resolveType`'s callers for `list of`/`map of`/array decls), emit `ptr cannot be a container element` when the element kind is `TyPtr`. (Record fields of type ptr are ALLOWED — scalars don't participate in ARC walks; verify a record with a ptr field checks clean and add that to the clean runCase.)

- [ ] **Step 4: Run to verify checker cases PASS:** `go test ./internal/selfhost -run TestClarusModules` (update `check_test.out` to the now-correct expected output if you computed any diag position wrong — golden is hand-maintained).

- [ ] **Step 5: Implement `ptr` through the back end.**
  - `clarusc/ir.cla:88-113`: append `KPtr` to `enum IRKind`; add singleton `var irPtrT: int` beside `irVoidT…irErrT` (`ir.cla:625-632`), seeded in `irReset()` (`ir.cla:716-722`) via `irPtrT = irSimpleType(KPtr)`.
  - `clarusc/lower.cla:222-241` (`lowType`): `case TyPtr { return irPtrT }`. `lower.cla:257-297` (`lowResolveType`): add `"ptr"` to the name chain at `:268-278` → `irPtrT`.
  - Conversion lowering: in `lowCall` (`lower.cla:694-733`), find the existing `int(`/`fixed(`/`char(` conversion arm (near `:720-722`) and mirror it for `ptr(x)` / `int(ptrExpr)`: if the existing pattern is a cast intrinsic, add names `IPtrFromInt`/`IIntFromPtr` in ir.cla beside `IStrLen` (`ir.cla:2154-2166`) and emit them; if it is a typed passthrough, pass through with result type `irPtrT`/`irIntT`. Match the existing mechanism — do not invent a third.
  - `clarusc/cprint.cla:543-561` (`cpCTypeName`): `case KPtr { return "void *" }` (exactly like `KWinRef` at `:558`). Do NOT add a `cpElemKey` arm (containers reject ptr).
  - Ptr arithmetic emission: in `fpBin` (`cprint.cla:839+`), when the node's IR type is `irPtrT` and op is add/sub, emit `"(void *)((char *)(" + L + ") " + opStr + " (" + R + "))"` instead of the plain infix form. Conversion emission (if intrinsic route): `IPtrFromInt` → `"(void *)(intptr_t)(" + arg + ")"`, `IIntFromPtr` → `"(int32_t)(intptr_t)(" + arg + ")"` in `fpIntrCall` (`cprint.cla:1172+`, expression-valued shape like `IStrLen` at `:1313-1314`). Ensure emitted C's `#include <stddef.h>` preamble (`cprint.cla:4547-4563`) is joined by `<stdint.h>` if not already present via rt.h.

- [ ] **Step 6: Regenerate snapshot + full test:**
  ```sh
  go run ./cmd/clarus build -o /tmp/clarusc clarusc/main.cla
  /tmp/clarusc emit -o clarusc/clarusc.c clarusc/main.cla
  go test ./...
  ```
  Expected: all green (no emitted-C shape change for existing programs — no emitui golden churn).

- [ ] **Step 7: Commit** — `git commit -m "clarusc: ptr scalar type (TyPtr/KPtr), ptr(x)/int(p) conversions, ptr±int"`

---

### Task 3: `external func` decls + host shim + run harness

**Files:**
- Modify: `clarusc/parse.cla`, `clarusc/ast.cla`, `clarusc/check.cla`, `clarusc/lower.cla`, `clarusc/ir.cla`, `clarusc/cprint.cla`
- Create: `internal/build/rt/rt_ext_host.inc`
- Modify: `internal/build/rt/rt.c` (include), `internal/build/embed.go`, `internal/build/runtime.go`, `internal/build/build.go:56-82`, `internal/selfhost/emit_test.go:56-79` (both copy sites)
- Create: `internal/lowlevel/lowlevel_test.go`, `testdata/lowlevel/extmem.cla`, `testdata/lowlevel/extmem.out`
- Modify: `clarusc/test/check_test.cla` + `.out`
- Regenerate: `clarusc/clarusc.c`

**Interfaces:**
- Consumes: `PtrT`, `irPtrT` from Task 2.
- Produces: AST `DkExternFunc` + `newExternFuncDecl(nameIdx, paramsHead, retType, line, col)`; IR `ECallExt` node + an extern registry (name → ret + param IR types) cprint uses for prototypes; C convention `rt_ext_<name>` for every external's host symbol; `testdata/lowlevel/` + `internal/lowlevel` glob harness (Task 4 adds fixtures to it).

- [ ] **Step 1: Write failing checker cases** (string-embedded in `clarusc/test/check_test.cla`, golden updated):
  - `external func NewHandle(size: int): ptr` + a call `h = NewHandle(16)` with `h: ptr` — clean.
  - `external func F(s: string)` — expect `external functions may only use int, ptr, bool, or char`.
  - `external func F(n: int) { }` — expect a parse diagnostic (body not allowed; whatever exact message your parser produces for the stray `{`, computed by running).
  - Call arity error `NewHandle()` — expect the standard wrong-arg-count diag (generic `checkArgsCall` path — proves externals check like normal functions).

- [ ] **Step 2: Run to verify FAIL:** `go test ./internal/selfhost -run TestClarusModules`

- [ ] **Step 3: Implement parse + AST.**
  - `clarusc/ast.cla:183-204`: append `DkExternFunc` to `enum DeclKind`. Add `newExternFuncDecl` + accessors modeled byte-for-byte on `newAppDecl` (`ast.cla:1280-1304`) but with `DkFunc`'s slot layout (`a=paramsHead, b=retType, c=-1`) so `funcDeclName/ParamsHead/RetType/Body` accessors (`ast.cla:1264-1278`) also work on it. Document the slot schema in the kind comment block like the others (`ast.cla:100+`).
  - `clarusc/parse.cla:1314-1337` (`parseTopDecl`): after the `parseSawNonInclude = true` line (`:1321`), add the contextual dispatch:
    ```
    if curIsIdentText("external") and peekKind() == TkFunc {
        return parseExternFuncDecl()
    }
    ```
    `parseExternFuncDecl` is `parseFuncDecl` (`parse.cla:1261-1296`) minus the `parseBodyBlock()` line: consume the `external` ident, expect `TkFunc`, name, params (`parseParam` loop), optional `: type`, then `return newExternFuncDecl(...)`. Statement termination: the decl ends at end of line like other bodiless decls — a following `{` becomes an ordinary parse error at top level (that's the diagnostic Step 1's body case pins).

- [ ] **Step 4: Implement check.**
  - `clarusc/check.cla:3869-3894` (`checkTopDeclPhase1`): add `case DkExternFunc` calling a new `checkExternFunc(d)` which (a) calls `checkFuncSig(d)` (`check.cla:1613-1674` — works unchanged because the slot layout matches), then (b) walks the params and return: every type's kind must be `TyInt`, `TyPtr`, `TyBool`, or `TyChar` (return may also be absent/void), else `emitDiag(..., "external functions may only use int, ptr, bool, or char")`. Phase 2 (`check.cla:3935`) filters on `DkFunc`, so no body check runs — verify, don't modify.

- [ ] **Step 5: Implement lower + IR + cprint.**
  - `clarusc/ir.cla`: add expr kind `ECallExt` beside `ECallFn` (schema comment at `ir.cla:76-78`), `newIRCallExt(name, argsHead, ty)` + `irCallExtName` mirroring `newIRCallFn` (`ir.cla:1252-1262` region). Add an extern registry in arena style (follow the `irMarkLayoutNeeded`/`irLayoutNeeded` registry pattern, `ir.cla:547-564`): `irRegisterExtern(nameIdx, retTy, paramTysFlatHead/count)` storing name, ret IR type, and param IR types (parallel lists + a flat param-type list with per-extern start/count — no nested lists); lookups `irExternCount()`, `irExternName(i)`, `irExternRet(i)`, `irExternParam(i, j)`/`irExternParamCount(i)`, and `irIsExtern(nameIdx): bool`.
  - `clarusc/lower.cla:4493-4524` (`lowDecl`): add `else if k == DkExternFunc { lowExternDecl(d) }` — resolves param/ret AST types via `lowResolveType` and calls `irRegisterExtern`; emits no other IR (precedent: the `DkInclude`/`DkConst` no-IR arm at `:4498-4501`).
  - `lowCall` (`lower.cla:694-733`): before the user-function fallback at `:723-725`, add `if irIsExtern(identName(fn)) { return newIRCallExt(identName(fn), lowCallArgs(callArgsHead(e), ...), ty) }` (argument lowering identical to the `ECallFn` path).
  - `clarusc/cprint.cla`: in `fpExpr`'s kind dispatch (case table near `:678`), add `case ECallExt { return fpCallExt(e) }`; `fpCallExt` mirrors `fpCallFn` (`cprint.cla:761-796`) but prints `"rt_ext_" + poolGet(irCallExtName(e)) + "(" + args + ")"`. Add `cpEmitExternProtos()` writing one line per registered extern into `cpTypeBuf`: `extern <cpCType(ret)> rt_ext_<name>(<param C types, or void>);` — called from `emitProgram` (`cprint.cla:4519-4580`) before `cpEmitFuncs`. Externals get NO `clar_fn_` proto and no body — verify `cpEmitFuncs` (`:2872-2885`) only iterates lowered functions (externals never entered that list).

- [ ] **Step 6: Write the host shim + wiring.** Create `internal/build/rt/rt_ext_host.inc`:

```c
/* rt_ext_host.inc: host implementations of `external func` symbols
   (the narrow-waist seam, Plan 5a). Each rt_ext_* delegates to the host
   Memory Manager shim (rt_mem_host.inc) so the strict-ledger/leak-gate
   instrumentation covers external allocations exactly like internal ones. */

void *rt_ext_NewHandle(int32_t size) { return (void *)NewHandle((Size)size); }
void rt_ext_DisposeHandle(void *h) { DisposeHandle((Handle)h); }
int32_t rt_ext_GetHandleSize(void *h) { return (int32_t)GetHandleSize((Handle)h); }
int32_t rt_ext_SetHandleSize(void *h, int32_t n) { SetHandleSize((Handle)h, (Size)n); return (int32_t)MemError(); }
void rt_ext_BlockMoveData(void *src, void *dst, int32_t n) { BlockMoveData((Ptr)src, (Ptr)dst, (Size)n); }
void *rt_ext_NewPtr(int32_t size) { return (void *)NewPtr((Size)size); }
void rt_ext_DisposePtr(void *p) { DisposePtr((Ptr)p); }
```

  FIRST verify each delegate (`NewHandle`, `DisposeHandle`, `GetHandleSize`, `SetHandleSize`, `MemError`, `BlockMoveData`, `NewPtr`, `DisposePtr`) exists in the host shim — read `internal/build/rt/rt_mem.h` (the `#else` host branch) and `rt_mem_host.inc`. If `NewPtr`/`DisposePtr` are absent from the host shim, implement `rt_ext_NewPtr`/`rt_ext_DisposePtr` on top of `NewHandle` + a locked master pointer (stash the Handle in a header word before the returned block) so the allocation stays ledgered — do NOT use bare malloc, the leak gate must see it. Adjust the C above to whatever the header actually declares (names/types), keeping the `rt_ext_` symbols exactly as written.
  Wiring (all five touchpoints, per `internal/build/runtime.go:7-10`'s warning):
  - `internal/build/rt/rt.c`: `#include "rt_ext_host.inc"` after the `rt_core.inc` include (`rt.c:47`).
  - `internal/build/embed.go`: `//go:embed rt/rt_ext_host.inc` + var.
  - `internal/build/runtime.go`: accessor.
  - `internal/build/build.go:56-82`: write the file into the workdir.
  - `internal/selfhost/emit_test.go:56-79`: same.

- [ ] **Step 7: Create the run harness + first fixture.** Create `internal/lowlevel/lowlevel_test.go`, modeled on `internal/sertest/sertest_test.go:87-152` (reuse its emit-fixture + cc + run mechanics; adapt helper names to what that file actually defines). Behavior: glob `../../testdata/lowlevel/*.cla`; for each: clarusc `emit` the fixture to `main.c` in a temp dir, compile `cc -std=c99 -O1 -I <repo>/internal/build/rt main.c <repo>/internal/build/rt/rt.c -o prog`, run with env `CLARUS_MEM_STRICT=1 CLARUS_MEM_PARANOID=1 CLARUS_MEM_REPORT=<tmp>`, require exit 0, stdout byte-equal to the sibling `.out`, and a `live=0` mem report (parse like `internal/selfhost/emit_test.go:206-229`). Create `testdata/lowlevel/extmem.cla`:

```
// extmem.cla: external-func seam smoke test (Plan 5a Task 3).
// Allocates through the waist, proves sizes and resize round-trip, and
// releases -- the strict ledger (enforced by internal/lowlevel) proves
// DisposeHandle reached the instrumented host shim.

external func NewHandle(size: int): ptr
external func DisposeHandle(h: ptr)
external func GetHandleSize(h: ptr): int
external func SetHandleSize(h: ptr, size: int): int

on App.startCLI(args: list of string) {
    var h: ptr
    h = NewHandle(16)
    print GetHandleSize(h)
    print SetHandleSize(h, 64)
    print GetHandleSize(h)
    DisposeHandle(h)
}
```

  Match the fixture's entry-handler shape and `print` statement form to the corpus idiom (crib from any `testdata/run/*.cla`, which you may READ freely — you just may not add to it). `extmem.out` is the three printed lines (`16`, `0`, `64` — adjust to actual `SetHandleSize` result semantics after first run, then freeze the golden).

- [ ] **Step 8: Run everything:**
  ```sh
  go test ./internal/lowlevel -v
  go test ./internal/selfhost -run TestClarusModules
  ```
  Expected: extmem passes with zero leaks; checker cases green.

- [ ] **Step 9: Regenerate snapshot, full suite, commit:** snapshot commands from Global Constraints; `go test ./...`; `git commit -m "clarusc+rt: external func decls, rt_ext_ host shim seam, lowlevel run harness"`

---

### Task 4: peek/poke builtins end-to-end

**Files:**
- Modify: `clarusc/check.cla` (universe registration), `clarusc/ir.cla` (intrinsic names), `clarusc/lower.cla` (lowCall chain), `clarusc/cprint.cla` (fpIntrCall arms)
- Modify: `internal/build/rt/rt.h` (static-inline helpers)
- Create: `testdata/lowlevel/peekpoke.cla` + `.out`
- Create: `testdata/emitui/lowlevel_seam.cla` + `.c.golden`
- Modify: `clarusc/test/check_test.cla` + `.out`
- Regenerate: `clarusc/clarusc.c`

**Interfaces:**
- Consumes: `PtrT`/`irPtrT` (Task 2), `rt_ext_NewPtr`/`rt_ext_DisposePtr` + lowlevel harness (Task 3).
- Produces: builtins `peekb/peekw/peekl(p: ptr): int`, `pokeb/pokew/pokel(p: ptr, v: int)`; C helpers `rt_peekb/w/l`, `rt_pokeb/w/l` in `rt.h` (also used later by Mac-side builds — they are shared, not host-only).

- [ ] **Step 1: Failing checker cases** (check_test.cla strings + golden): `peekb(p)` result assigned to int — clean; `peekb(5)` — arg-type diag; `pokew(p)` — arity diag; `pokeb(p, c)` with `c: char` — arg-type diag (int required).

- [ ] **Step 2: Run to verify FAIL:** `go test ./internal/selfhost -run TestClarusModules`

- [ ] **Step 3: Implement.**
  - `clarusc/check.cla:902-918` (`registerUniverse`): register all six beside `alert`/`log` (`:910-914`), using the same ret-value convention the existing procedures use for "no return":
    ```
    declBuiltinFunc1(scope, "peekb", PtrT, IntT)
    declBuiltinFunc1(scope, "peekw", PtrT, IntT)
    declBuiltinFunc1(scope, "peekl", PtrT, IntT)
    declBuiltinFunc2(scope, "pokeb", PtrT, IntT, <procedure-ret>)
    declBuiltinFunc2(scope, "pokew", PtrT, IntT, <procedure-ret>)
    declBuiltinFunc2(scope, "pokel", PtrT, IntT, <procedure-ret>)
    ```
    (`<procedure-ret>` = whatever `alert`'s registration passes — read `check.cla:910` and copy it.)
  - `clarusc/ir.cla:2136-2520`: six intrinsic-name functions beside `IRetain` (`:2418`): `func IPeekB(): int { return intern("peekb") }` … `IPokeL`.
  - `clarusc/lower.cla:703-718` (`lowCall` name chain): six arms mirroring `alert` (`:705-706`): peeks → `newIRIntr(IPeekB(), lowArgs(callArgsHead(e)), irIntT)` etc.; pokes → same with void type (mirror how `alert`'s statement intrinsic types itself).
  - `clarusc/cprint.cla` `fpIntrCall` (`:1172+`): peeks are expression-valued (precedent `IStrLen` `:1313-1314`): `return toText("rt_peekb(" + fpExpr(fpArgAt(x, 0)) + ")")`; pokes are statement-valued (precedent `IStrSetIndex` `:1317-1321`): `fpEmit("rt_pokeb(" + a0 + ", " + a1 + ");")` + `return toText("")`.
  - `internal/build/rt/rt.h`: add (with `<stdint.h>`/`<string.h>` includes if rt.h lacks them):
    ```c
    /* Plan 5a: peek/poke helpers. memcpy keeps them alignment- and
       strict-aliasing-safe on host; native byte order by design (see
       language reference Ch13 endianness rule). Shared with Mac builds. */
    static inline int32_t rt_peekb(void *p) { unsigned char v; memcpy(&v, p, 1); return (int32_t)v; }
    static inline int32_t rt_peekw(void *p) { uint16_t v; memcpy(&v, p, 2); return (int32_t)v; }
    static inline int32_t rt_peekl(void *p) { uint32_t v; memcpy(&v, p, 4); return (int32_t)v; }
    static inline void rt_pokeb(void *p, int32_t x) { unsigned char v = (unsigned char)x; memcpy(p, &v, 1); }
    static inline void rt_pokew(void *p, int32_t x) { uint16_t v = (uint16_t)x; memcpy(p, &v, 2); }
    static inline void rt_pokel(void *p, int32_t x) { uint32_t v = (uint32_t)x; memcpy(p, &v, 4); }
    ```

- [ ] **Step 4: Run fixture.** `testdata/lowlevel/peekpoke.cla` (same entry-handler idiom as extmem): `NewPtr(8)` a buffer; `pokeb` 65 at `p`, `pokew` 4660 at `p + 2`, `pokel` 305419896 at `p + 4` (offsets 0, 2-3, 4-7 — non-overlapping), then `print peekb(p)`, `print peekw(p + 2)`, `print peekl(p + 4)`, roundtrip a copy with `BlockMoveData` into a second `NewPtr(8)` buffer and re-peek from the copy, `DisposePtr` both. `.out` = the printed values (byte-order-independent because every peek reads back exactly what the same-width poke wrote). Also print `int(ptr(12345))` (expect `12345`).

- [ ] **Step 5: Run to verify PASS:** `go test ./internal/lowlevel ./internal/selfhost -run 'Lowlevel|TestClarusModules' -v` (fill in the actual lowlevel test name).

- [ ] **Step 6: Emit-shape golden.** Create `testdata/emitui/lowlevel_seam.cla` — a minimal program using one external decl, `ptr` arithmetic, one peek and one poke — and its `.c.golden` (emit with `/tmp/clarusc`, inspect by hand once: extern proto present and correctly typed, `rt_peekb`/`rt_pokeb` calls, `(void *)((char *)...)` arithmetic, no `clar_fn_` for the external). The auto-glob (`internal/emitui/emitui_test.go:111`) picks it up and m68k-compile-checks the golden — this proves the emitted C and the rt.h helpers compile under Retro68 gcc too.

- [ ] **Step 7: Regenerate snapshot, full suite, commit:** `go test ./...`; `git commit -m "clarusc+rt: peekb/w/l + pokeb/w/l builtins over rt_ peek/poke helpers"`

---

### Task 5: Docs, ROADMAP, spec amendments, final gate

**Files:**
- Modify: `docs/ROADMAP.md` (Plan 5 section: 5a status + what landed)
- Modify: `docs/superpowers/specs/2026-07-29-native-68k-toolchain-design.md` (amendments)
- Test: full suite + gated Mac run

**Interfaces:** none — bookkeeping and verification.

- [ ] **Step 1: Spec amendments.** Record in the design spec (short "5a outcomes" notes under the relevant sections): trap clauses deferred to 5d/5e (decision 2026-07-29); builtin names peekb/w/l–pokeb/w/l; `ptr` banned as container element in v1; **the Handle-deref lesson: `peekl(handle)` is a 68k-only idiom (host pointers are 8 bytes) — the shared runtime needs a deref primitive at the waist (e.g. an external or builtin returning the master pointer), to be designed in 5b when the first ported module needs it.**

- [ ] **Step 2: ROADMAP.** Add the Plan 5 section entry for 5a (status, one-paragraph summary, pointer to spec + this plan), following the 4a–4e entry style.

- [ ] **Step 3: Full gate.**
  ```sh
  go test ./...                                   # everything incl. snapshot, bootstrap, differential
  CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestSuiteOnMac   # Mac path unaffected — prove it
  ```
  Expected: all green; the Mac suite run confirms zero regression in the Retro68 path (5a touches shared rt.h — the m68k compile-check in emitui covers compilation, this covers behavior).

- [ ] **Step 4: Commit** — `git commit -m "docs: 5a landed (ptr, peek/poke, external-func waist); spec amendments + ROADMAP"`

---

## Self-review notes (performed at write time)

- Spec coverage: 5a spec scope = `ptr` (Task 2), peek/poke (Task 4), declared externals + checker + cprint-to-shim (Task 3), shim skeleton with ledger at the seam (Task 3), reference/normative updates (Task 1, amendments Task 5). Trap clauses: descoped by explicit user decision, recorded Task 5.
- Known intentional gaps, deferred with reasons: no Mac-side `rt_ext_*` implementations (no Mac program uses externals until 5b); no `list of ptr` (rejected in checker, revisit when the runtime port needs it); no Handle-deref primitive (5b, noted in spec amendment).
- Type-consistency check: `PtrT`/`irPtrT`/`DkExternFunc`/`ECallExt`/`rt_ext_<name>`/`rt_peek*` naming is used identically across Tasks 2-4 interface blocks.
