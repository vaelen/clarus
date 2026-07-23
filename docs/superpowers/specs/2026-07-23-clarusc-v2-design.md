# clarusc v2 Design — C Emission + Self-Hosting Bootstrap

**Date:** 2026-07-23
**Status:** Approved design, pre-implementation
**Context:** Second step of the self-hosting track (docs/ROADMAP.md). clarusc v1
(merged) is the check-only front end — lexer, parser, checker in Clarus,
byte-identical diagnostics to `clarus check`. v2 adds the back end so clarusc
becomes a full compiler that emits C, compiles real programs, and bootstraps
itself.

## 1. Identity and scope

clarusc v2 makes clarusc emit **C (host target)** for the entire
**host-supported** language — exactly the subset `clarus build` / `clarus run`
supports today: scalars (`int`, `bool`, `fixed`, `char`), `string(n)`, `text`,
`list`, `map`, `record`, `enum`, functions, host events (`App.startCLI` /
`App.launch`), file I/O, and the `log` / `alert` / `quit` intrinsics. clarusc
self-compiles to a working binary, and the three-stage bootstrap reaches a
byte-identical fixed point with a committed `clarusc.c` snapshot buildable by a
C compiler alone.

**Verification contract (decided):** behavior parity + bootstrap fixed point.
- For every `testdata/run` golden, the binary produced from clarusc-emitted C
  (compiled with `cc` + `rt.c`) produces output identical to the Go-built
  binary. This is the primary gate.
- Bootstrap fixed point: `stage2.c` and `stage3.c` are byte-identical.
- clarusc's emitted C text is **not** required to match Go's `cprint` output
  byte-for-byte — C is validated by compiling and running, and the fixed point
  already pins clarusc's determinism.

**Out of scope for v2:**
- The 68k printer (a second `cprint` target) — deferred until after the Mac
  runtime exists (ROADMAP Plan 4). v2 keeps the IR seam so that printer can be
  added later without re-splitting.
- GUI emission (windows, menus, forms, canvas) — those intrinsics are
  Mac-only; the host backend does not support them and neither does v2.
- Any new language features. clarusc's source stays on the current feature set
  (conservative-subset rule).

## 2. Architecture — port the IR seam faithfully

The Go back end (`internal/ir`, `internal/lower`, `internal/cprint`, ~2,900
non-test LOC) is the reference. v2 mirrors it as three new clarusc modules in
the established arena idiom (`list of Node` + `int` indices, `-1` nil, thin
accessors — the same style as `ast.cla`), reusing the existing C runtime
unchanged.

```
clarusc/ir.cla      — arena IR mirroring internal/ir/ir.go + intrinsics.go:
                      Program / Func / Global / RecordLayout / EnumLayout /
                      Type, the ~11 Stmt kinds (Assign, StoreStr, ExprStmt,
                      If, While, ForRange, ForList, ForMap, Return, Break,
                      Continue) and ~12 Expr kinds (IntConst, StrConst,
                      VarRef, FieldRef, IndexRef, Bin, Un, Conv, CallFn,
                      Intr, NewRec), plus the 53 intrinsic-name constants.
clarusc/lower.cla   — AST → IR, mirroring internal/lower: switch-desugar to
                      if-chains, const inline, fixed-point mul/div → IFixMul/
                      IFixDiv, string-concat temps, the `+` / comparison
                      lowering (incl. the char+string / string+text rules).
clarusc/cprint.cla  — IR → C, mirroring internal/cprint: the C prologue and
                      #includes, function printing, type printing, defaults,
                      and intrinsic emission — the SAME rt_* ABI calls the Go
                      printer emits, so the program links against the existing
                      runtime and behaves identically by construction.
```

`main.cla` gains an **emit path**: a `clarusc emit FILE...` subcommand (the
existing include-expand + lex + parse + check pipeline, then lower + cprint)
that writes C to stdout. Check errors abort emission with the same
diagnostics + exit code as `clarusc check` (a program that fails checking is
never emitted, matching `clarus build`).

**Runtime and C-compile orchestration are reused, not rebuilt.** clarusc emits
`main.c`; the harness pairs it with the unchanged `internal/build/rt/rt.{c,h}`
and invokes the same compile step `clarus build` uses today
(`cc -std=c99 -O1 main.c rt.c -o out`, via `build.CCPath()`). clarusc does not
orchestrate cc itself in v2 — a Go-side harness (or a thin script) drives
emit → compile → run for testing, exactly paralleling `build.Build`.

## 3. Data flow

```
.cla source ──[v1: include-expand → lex → parse → check]──> checked AST
            ──[lower.cla]──> IR arena
            ──[cprint.cla]──> C text (main.c)
            ──[cc + rt.c]──> native binary ──> program output
```

The first three stages already exist (v1). v2 adds `lower.cla` and
`cprint.cla`; `cc + rt.c` is the existing host toolchain.

## 4. Verification — walking skeleton, then coverage slices

The ~2,900-LOC port is kept testable from day one rather than big-bang:

1. **Walking skeleton:** the `clarusc emit` CLI, the Go-side behavior-parity
   harness, and the minimal IR/lower/cprint needed to emit ONE trivial program
   (e.g. `quit`, a `log` of a literal) that compiles and runs. This proves the
   whole seam end to end before any coverage work.
2. **Coverage slices:** grow lower + cprint one family at a time — types →
   integer/bool/fixed expressions → strings/char/text → lists/maps/records/
   enums → control flow → the intrinsic families → events/file I/O. Each slice
   is pinned by the behavior-parity differential expanding to cover it.
3. **Behavior-parity differential** (`internal/selfhost`, extending the v1
   harness): for each `testdata/run` golden, build once with Go and once via
   clarusc-emit + cc + rt.c; diff stdout and exit code. The current corpus is
   small (13 run + 3 runerr goldens); the plan adds run-goldens per slice for
   intrinsic families the existing corpus does not exercise, so the differential
   actually covers what each slice emits. **clarusc compiling its own source**
   is itself a large coverage driver and becomes a corpus entry once emission
   is complete.

## 5. Bootstrap chain

Once emission covers the whole host subset (clarusc can emit working C for its
own source):

```
Go `clarus build clarusc/main.cla`        ──> clarusc-stage1   (built by Go)
stage1 `emit clarusc/main.cla` → cc       ──> clarusc-stage2   (built by clarusc)
stage2 `emit clarusc/main.cla` → cc       ──> clarusc-stage3   (built by clarusc)
assert  stage2.c == stage3.c              ──> fixed point reached
commit  stage2.c as clarusc/clarusc.c     ──> the C snapshot (cc-only bootstrap)
```

A CI-able target runs the chain and asserts the fixed point. `stage2.c` is
committed as the ground-floor interlingua: any machine with a C compiler can
build clarusc from it, with no Go and no prior Clarus binary. After the fixed
point holds, the **Go compiler freezes** at the bootstrap-subset level — kept
only as the differential reference, no longer tracking new language work.

## 6. Conservative-subset discipline

clarusc's own source avoids newly-added language features for at least one
release cycle, keeping the bootstrap chain wide. This is automatically
satisfied for the current feature set, because host emission must already
cover everything clarusc's source uses in order to self-compile. The rule
binds future changes: a new language feature lands in the Go compiler and the
reference first, and clarusc adopts it only after a release.

## 7. Risks / accepted costs

- **Second back end to keep in sync** with the Go backend until the Go
  compiler freezes. Mitigated by the faithful port (same IR, same intrinsics,
  same ABI) and the behavior-parity differential — the sync mechanism is the
  same discipline v1 used for the front end.
- **Small run-golden corpus.** Behavior parity is only as strong as the
  corpus; the plan must add goldens per slice, and self-compilation is the
  backstop that exercises the long tail.
- **Bootstrap non-determinism would break the fixed point.** clarusc's
  emission must be deterministic (no map iteration in nondeterministic order,
  no address-dependent output). The arena idiom + sorted-by-key map iteration
  (already the language contract) make this tractable; the fixed-point test is
  the guard.
- **cc dependency for host testing** — already true for `clarus build`; v2
  adds no new external dependency.
