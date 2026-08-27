# `= ptr` Extern Clause: Calling Through a Function Pointer

**Date:** 2026-08-27
**Status:** Approved (design review with Andrew, 2026-08-27)
**Phase name:** extern-ptr-call

## Motivation

Clarus can call fixed Toolbox entry points (`= trap`), expand compiler
intrinsics (`= inline`), and hand the Toolbox a pointer to its own code
(`callback func`). It cannot call *through* a `ptr` value it holds — the
forward direction. The driving use case is loaded code resources:
GetResource a plugin/door module (68kbbs territory), HLock it, deref the
handle, and jump into it with arguments. Today that requires no language
at all — there is simply no way to do it.

## Language surface

A new alternative in the extern clause grammar:

```
externDecl = "external" "func" IDENT "(" [ params ] ")" [ ":" type ]
             [ "=" ( "trap" ... | "inline" ... | "ptr" ) ] ;
```

```rust
external func PluginMain(entry: ptr, verb: word, param: ptr): int = ptr

var code: ptr = HandleToPtr(h)      // h from GetResource + HLock
var result: int = PluginMain(code, 1, pb)
```

The declaration is a *calling contract*, not a binding: nothing ties it
to any one pointer. The target arrives fresh at every call site, as the
first argument.

### Rules

1. The declaration must have at least one parameter, and the first must
   be type `ptr`. That parameter is the call target: consumed as the
   jump address, never pushed.
2. Remaining parameters and the return type follow the plain pascal
   `trap` clause rules exactly — same type sets (`int`/`ptr`/`bool`/
   `char`/`word`/`str`/`text` params; `int`/`ptr`/`bool`/`char`/`word`
   or void returns), same marshalling (`bool`/`char` occupy a full word
   with the value in its HIGH byte; `str` passed as the Str255's
   address, `text` as the box pointer, both borrowed for the call).
   Zero parameters after the target is fine.
3. `ptr` is mutually exclusive with `reg`, `sel`, `seld0`, `ret`, and
   `memerr` — pascal convention only. Violations are compile errors
   naming the clause.
4. The same-name redeclaration merge rule applies unchanged: two
   declarations merge iff identical in full (including both being
   `= ptr`); any mismatch is a compile error naming both sites.
5. A nil (or garbage) target is the caller's problem — no runtime
   guard, the same contract as every other raw `ptr` use. Documented,
   not checked.
6. A `callback func`'s bare name is a valid argument for the target
   parameter — it is an `external func` `ptr` parameter, so the
   existing decay rule already covers it with no new special case.

## Native lane (emit68k)

Marshalling is byte-for-byte the plain pascal trap sequence — reserve
the result slot (if any), push arguments left to right with the
existing width/shift rules — except the dispatch: instead of emitting
the A-line trap word, load the target value into an address register
and `JSR (An)`. The target expression is evaluated in declaration order
with the other arguments (it is argument #1; it just lands in a
register instead of on the stack). Register choice and any
scratch-pressure interaction are the implementation plan's concern; the
observable contract is only "pascal call through the pointer".

## Host lane (cprint)

Not a stub — a real call. The call site casts the target to the C
function-pointer type derived from the declared signature and calls
through it:

```c
((int32_t (*)(int16_t, void *))e_target)(a_verb, a_param)
```

The cast's parameter and return types are the callback glue wire types
(`cpCbWireType`/`cpCbRetWireType`, cprint.cla) for the scalar kinds,
and the address types extern marshalling already uses for `str`/`text`.
Pinning scalars to the callback wire types is what makes a decayed
callback (`clar_cb_<name>`) a strictly conforming target on host — the
cast signature matches the glue's actual C signature, so the
callback_host.cla/CbInvoke pattern generalizes per-signature with no
undefined behavior. (`CbInvoke` itself stays: it is a fixed-signature
runtime seam; this feature emits the cast per declaration.)

## Testing

- **Core suite case `PtrCall`** (both lanes, one new `CoreTest` case):
  declare a `callback func` with a mixed signature (`word`, `bool`,
  `ptr`, `int`, plus a return value), pass its decayed name as the
  target of a matching `= ptr` extern, and assert every value
  round-trips and the result comes back. On native this hardware-proves
  the pascal marshalling against the compiler's own glue (high-byte
  bool/char rule included); on host it proves the cast-and-call. No
  code resource needed — the glue IS a pascal-convention entry point.
- **Checker fixtures** (`clarusc/test/check_test.cla`): `= ptr` with no
  parameters; first parameter not `ptr`; `= ptr` combined with `reg`,
  `sel`, and `ret`; same-name redeclaration mismatch (`= ptr` vs
  `= trap`).
- Suite bookkeeping (case counts in CLAUDE.md/runner) per the usual
  drill.

## Documentation

- **Language reference** (normative): new subsection under "Trap and
  Inline Clauses" (or a sibling, "The `ptr` Clause") — updated grammar
  production, the rules above, a worked code-resource example
  (GetResource → HLock → deref → call), the nil-target note, and an
  interrupt-time out-of-scope note mirroring `callback func`'s: only
  call application-level entry points this way, never interrupt-time
  code.
- **Toolbox cookbook**: a short "calling loaded code" recipe showing
  the code-resource pattern end to end.

## Out of scope (recorded, not planned)

- Named-target form `= ptr(name)` — first-param rule costs nothing
  today; the named form can be added compatibly later if a real
  signature demands the target elsewhere.
- Register-convention targets (`ptr reg(...)`) — no known caller;
  code-resource entry points are pascal.
- Any loader machinery (segment-style relocation, resource management
  helpers) — this feature is the call primitive only; loading stays
  ordinary GetResource/HLock code.
