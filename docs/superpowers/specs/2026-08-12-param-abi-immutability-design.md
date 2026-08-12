# Immutable parameters + by-reference string/record param ABI (2026-08-12)

Status: **design approved in discussion (Andrew, 2026-08-12), pre-plan.**
Implements the 2026-08-10 performance findings doc's §2.1 in its agreed
"smaller cut" form, widened to records and to an immutable-parameters
language change during brainstorming. Sequencing rationale — do this ABI
rewrite BEFORE the precompiled-artifacts work freezes the ABI — is
recorded in `2026-08-12-precompiled-artifacts-design-notes.md`.

## Problem

Every call passing a `string` copies 256 bytes onto the stack regardless
of content (`cgPushArgs`, cg68k.cla:8775: address the source, drop SP by
the slot size, `cgBlockCopy`); records likewise copy their full size, and
handle-bearing record params additionally pay a retain-walk at callee
entry plus a release-walk at every exit (`lowRetainRecParams`,
lower.cla:4040). A one-string-arg call is ~140 instructions before the
callee runs. clarusc itself is a Clarus program whose hot paths are
string-parameter-dense, so this tax compounds through every compiler
phase — and §2.1 is the only remaining findings item that rewrites the
ABI surface the future precompiled-artifacts phases will freeze.

## Design summary

Three coupled changes, one phase:

1. **Language: parameters are immutable** (all types). Rebinding a
   parameter, or storing through a value-typed parameter, is a build
   error.
2. **ABI: `string` and record parameters pass by address** (4-byte
   pointer instead of a full-slot stack copy). Kind-based rule — every
   KStr/KRec param regardless of size, matching `cgRetNeedsHidden`'s
   kind-not-size lesson (cg68k.cla:5215).
3. **Call sites classify each string/record argument as BORROW or
   COPY-TO-TEMP** (table below), preserving by-value semantics against
   aliasing. The classification is implemented ONCE, in lowering; both
   backends follow the resulting IR blindly.

Storage is explicitly unchanged: `cgSizeOf(KStr)` stays 256; records,
fixed arrays, list/map slots, globals, and locals keep their inline
layouts. Returns are unchanged (KStr/KRec already use the
hidden-result-pointer convention — `cgRetNeedsHidden`). Externs are
unchanged (`str`/`text` extern params are already documented borrows,
reference:1426). Scalars are unchanged at the ABI level (immutability is
checker-only for them).

## 1. Language change: immutable parameters

**Rule:** a function/handler parameter is not assignable. Specifically,
a parameter may not appear as:

- the target of an assignment (`p = ...`) — any parameter type,
  including reference types (`text`, `list`, `map`, window refs);
- the base of a field assignment (`p.f = ...`) or index assignment
  (`p[i] = ...`) **when the parameter is a value type** (record, fixed
  array, or `string` — string element assignment `p[i] = ch` is legal
  Clarus today, core suite `StrIndexing`, and must be rejected on a
  param);
- an `edit` statement's target (checkEditStmt requires a record — a
  value type — so this follows from the previous bullet; called out
  explicitly because `edit` is not spelled `=`);
- a fill-target argument of a runtime routine documented to fill what
  you pass (`askOpen`'s path, `askSave`'s path) when the argument is a
  bare parameter.

**Still legal** (referent mutation, not binding mutation): storing
through a *reference-typed* parameter — `t[i] = ch` on a `text` param,
`l.add(x)` / `l[i] = v` on a `list` param, `w.Status.text = s` on a
window-ref param, `file.readText(path, t)` filling a `text` param. This
is the language's documented out-parameter pattern (reference:757) and
is untouched.

**Enforcement:** the checker already rejects assignment to constants and
read-only properties (check.cla:3887/3907 family); parameters join that
family. One new diagnostic: `cannot assign to parameter <name>`.

**Why this is safe to impose:** the reference already says user
functions cannot fill fixed-size out-parameters (757) — assigning to a
value param today mutates only the callee's private copy, so the idiom
is pure local scratch, never observable by the caller. Measured blast
radius across clarusc + runtime + testsuite + toolbox + examples
(heuristic line scan, 2026-08-12): **13 rebinding sites** (11 `int` loop
cursors, 2 `string`), **zero** field/index stores through value-typed
params (every field-assign found was through a window ref — legal). The
migration is mechanical (introduce a local, as below); the checker
produces the authoritative site list the moment the rule lands.

```
// before                          // after
func add(x: int, y: int): int {    func add(x: int, y: int): int {
    x = x + y                          var z: int
    return x                           z = x + y
}                                      return z
                                   }
```

**Bonus — a silent bug class becomes a diagnostic.** Today this
compiles and silently does nothing:

```
func rename(d: Doc, title: string) {
    d.title = title      // mutates the callee's COPY; caller unchanged
}
```

Under the rule it is a build error at exactly the line where the
misunderstanding lives. The correct forms are unchanged from today:
return the updated record (`gDoc = renamed(gDoc, title)`), or use a
reference type (window refs / `text` / `list` / `map`) when callees
should mutate in place.

## 2. ABI change: KStr/KRec parameters by address

- **Call site:** for a borrowable argument, push its 4-byte address
  (LEA + MOVE.L) instead of copying the slot. For a copy-to-temp
  argument, copy into a caller scratch slot (existing
  `cgAllocTmpOff`/`cgMaterializeToTemp` big-pool machinery), then push
  the temp's address.
- **Callee:** the param's frame slot holds a pointer. Reads indirect
  through it (`MOVEA.L off(A6),A0` where today it is `LEA off(A6),A0`);
  the frame tables carry a per-param by-ref bit so `cgVarOff`/
  `cgExprAddr`/`cgVarRefAt` resolution stays uniform. Because params
  are immutable, no prologue copy ever exists.
- **RC:** borrowed params get NO entry retain and NO exit release —
  `lowRetainRecParams`'s walk pair is deleted for params (its
  heap-scalar-array arm too; fixed arrays are value types and follow
  the record rule throughout this doc). Soundness: the caller's
  argument keeps every reachable handle alive for the call's duration
  (the caller's frame is suspended), and any store of a borrowed value
  into persistent storage retains at the store site — the existing
  counted-store invariant (lower.cla:2975 block). Clarus cannot leak
  the borrow itself: no address-of operator, and storing the record
  anywhere is a by-value copy that retains.
- **cprint mirrors the ABI**: emitted C takes `const Str255 *` /
  `const RecT *` params, with the same lowering-inserted call-site
  temps. Both lanes keep identical aliasing behavior, so the leak gate
  and differential harness remain meaningful oracles for this change.

## 3. Call-site classification (the correctness core)

Implemented in lowering, once, on the IR arg shapes `cgPushArgs`
already dispatches on. "Local" below means a **value-typed local**
(record/array/string in the caller's stack frame) — a local `list of T`
variable is heap storage reachable through other names and does NOT
qualify.

| Arg shape | Treatment |
|---|---|
| `EVarRef` local (incl. a borrowed param passed onward) | borrow |
| `EStrConst` literal | borrow (constant pool is read-only) |
| Rvalue temp (call result, concat, coercion, ...) | borrow the temp |
| `EVarRef` global | copy to temp |
| `EFieldRef`/`EIndexRef`, base is a value-typed local | borrow |
| `EFieldRef`/`EIndexRef`, base global or heap (container element) | copy to temp |
| Record copy-to-temps (handle-bearing) | retain-walk before the call, release-walk after |

Worked examples (given `record Doc { title: string  body: text }`,
globals `gName: string`, `gDoc: Doc`, `gDocs: list of Doc`):

```
func caller() {
    var d: Doc
    var s: string

    show(d, s)                 // row 1: &d, &s — zero copies
    show(d, "Untitled")        // row 2: literal's pool address
    show(d, s + ".cla")        // row 3: concat temp materialized once,
                               //        its address passed (no re-copy)
    show(gDoc, gName)          // row 4: BOTH copied to temps first —
                               //        callee may reassign the globals
    log2(d.title)              // row 5a: &d.title — offset into caller's
                               //         own frame, borrow
    log2(gDoc.title)           // row 5b: copy — field of a mutable global
    show2(gDocs[0])            // row 5b: copy — heap element; callee
                               //         could pop/reassign the list
}
```

Row 6, the RC bracket on record copy-temps:

```
rename(gDoc, "B")
// lowers as:
//   copy gDoc -> __tmp          (block copy, as today's push-copy)
//   retain-walk __tmp           (cg_retain_Doc: bump body's handle rc)
//   rename(&__tmp, &lit)
//   release-walk __tmp          (cg_release_Doc)
```

Why: `__tmp.body` aliases `gDoc.body`'s handle. If the callee reassigns
`gDoc`, the global's release-walk drops that handle; without the temp's
own retain it could hit rc=0 and be freed while the callee still reads
it through the borrow. This is the same retain/release pair every
record param pays today — after this phase it is paid only by
global/field/element arguments, at the call site instead of the callee
prologue. Strings never need the bracket (no handles inside a Str255).

**Hazard being defended against** (row 4/5b/6): a borrowed argument
aliasing storage the callee can reach and mutate by another name.
Records live inline in globals, so `gDoc = ...` inside the callee
overwrites the borrowed storage in place AND release-walks the old
handle fields — a stale-handle read, i.e. a crash, not just a stale
value. The conservative copy rule restores exactly today's semantics
for these shapes at exactly today's cost.

## 4. What is deliberately unchanged

- String/record **returns** (hidden result pointer — already optimal).
- **Extern/trap boundary** (Chapter 13 marshaling; already borrows).
- **Storage layout everywhere** (256-byte Str255 slots, inline records;
  variable-length strings remain a separate future decision).
- Scalars' ABI; `text`/`list`/`map`/window-ref passing (already
  reference-typed box pointers).
- Window handler synthetic params (KWinRef — reference-typed).
- Peephole/assembler (no new instruction shapes beyond existing ones).
- **Fixed-array (`KArr`) parameter ABI** — out of scope (research
  2026-08-12): a `KArr`-typed call argument is a hard compile error on
  the 68k lane today (`cgExpr` EVarRef non-scalar guard; no committed
  fixture passes one), and the host lane uses C's own struct-by-value.
  Both stay as they are; immutability still applies to array params at
  the checker level. Building 68k `KArr` argument passing remains the
  separate deferred item from the cross-compile findings doc.

## 5. Migration (opening task of the plan)

The 13 known rebinding sites (heuristic scan; the checker's diagnostics
are the authoritative list once the rule lands):
`clarusc/res68k.cla` (2), `clarusc/cg68k.cla` (2 whole + its
`segBits[idx]` hit is a `list of bool` — legal, not migrated),
`clarusc/lower.cla` (4), `clarusc/lib.cla` (1), `clarusc/drive.cla`
(2 string), `runtime/clarus/native.cla` (2), `examples/mandelbrot.cla`
(0 — all its hits are window-ref field stores, legal). Each migrates by
introducing a local (`var z` pattern above). Checker rule + migration
land together, before any ABI change, so the tree is never
rule-violating.

## 6. Validation

The fork byte-identity oracle is **deliberately broken once** by this
phase (codegen changes on both lanes); goldens re-bless after review,
per the established procedure. Gates:

- **T1 + `--smoke`** green; cg68k + emitui goldens re-blessed.
- **Leak gate** (`TestLeakGate/DoubleCompile`) stays at 0
  blocks/compile — the strongest oracle for the RC changes (deleted
  param walks, new call-site brackets).
- **New checker tests**: params rejected in every mutating position
  (rebind, field, index, `edit`, fill-target builtins); referent
  mutation through reference-typed params still accepted.
- **New suite cases** (core suite, host+native): observable by-value
  semantics under aliasing — the row-4 shape (callee reassigns a global
  passed as an arg; param must retain the old value), the row-6 shape
  (handle survives the call), and a borrow-chain case (param passed
  onward through two levels).
- **Self-host**: `internal/selfhost` green; bootstrap snapshot
  (`clarusc/clarusc.c`) regenerated to fixed point (mandatory — the
  snapshot embeds the old ABI's codegen otherwise).
- **Perf evidence** (10-pair interleaved medians, per layer1
  procedure): host self-compile, `emit68k tickprobe`, frozen-fixture
  `emit68k macgui` macro, peak RSS — before/after this phase.
- Reference + any affected docs updated (Parameter Passing §, the
  assignment/constants §, `.clear()`-era docs unaffected).

## 7. Risks

- **Classification completeness** is the correctness core, but it now
  lives in one lowering function and fails CONSERVATIVE (an arg
  misjudged "unsafe" merely copies — today's behavior). Only a
  wrong-direction judgment (borrowing a mutable-reachable arg) is
  dangerous; the suite's aliasing cases target exactly that.
- **Callee param-access indirection** touches every KStr/KRec VarRef
  resolution path in both backends — mechanical but wide; the re-bless
  diff review and the suites cover it.
- **32KB segment pressure**: call sites shrink (no inline block-copy
  loops), callee prologues shrink (no retain walks) — pressure should
  DROP; `cgPackProgram` will confirm.
- Immutability is a breaking language change; the reference must land
  the same phase so spec and compiler never disagree.
