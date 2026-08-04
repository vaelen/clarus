# Toolbox integration phase — design

Date: 2026-08-04. The middle phase of the 2026-08-03 decided sequencing
(ROADMAP: test-suite review → **this** → 5f), following the
compiler-performance phase (merged 2026-08-04, which the ROADMAP's
original ordering had placed after this one — reordered at Andrew's
direction). End state motivating the phase: a Clarus programmer opens
Inside Macintosh, writes one `external func` declaration from the IM page
and trap table, and calls it as ordinary Clarus code — no hand-written
wrapper layer. The plain-pascal-trap + `sel`-package subset already works
(proved in user code: TickProbe declared `= trap 0xA975` itself); this
phase closes the three ranked gaps.

## Scope

One phase, one plan, branch `toolbox-integration`. Three features, landed
in order, each reference-first (Ch13), then clarusc
(parser/checker/IR/lower), then both backends (cg68k + cprint), with
fixtures at each step and a native gate per feature:

- **A. Named-register trap clause** — pin specific args to specific
  registers; retires `cgCallExtGestalt`.
- **B. `extern record`** — Mac-packed-layout struct transcription;
  retires the EventRecord/ParamBlockRec peek/poke idiom.
- **C. `callback func`** — user-facing Toolbox callbacks; retires the
  hand-rolled LDEF/action-proc glue emitters.

Plus one cross-cutting rule decided here: **extern dedup**
(identical-signature merge), which unblocks user IM transcription over
runtime-declared traps and the future per-IM-manager `toolbox/` catalog.

The phase closes by migrating the runtime's own hand-rolled glue onto the
new features (Gestalt → named-reg clause; LDEF/scrollbar-action glue →
`callback func`) — simultaneously the cleanup and the acceptance proof.

All new syntax is clarusc-only (`ClaruscOnly` fences); the frozen Go
compiler never learns it. Coverage for new-syntax fixtures comes from the
Go-free lanes (behavior goldens, crossgen, snapshot self-consistency).
clarusc's own source stays in the conservative subset — it implements the
features but never uses them, so the snapshot bootstrap chain is
unaffected beyond ordinary regeneration.

## Feature A — named-register trap clause

### Surface

```rust
external func UiGestalt(selector: int, response: ptr): word
    = trap 0xA1AD reg(d0: selector, a1: response) ret d0
```

Grammar (Ch13 "Trap and Inline Clauses" amendment):

```
regClause = "reg" [ "(" regBind { "," regBind } ")" ] [ "memerr" ] [ "ret" REG ] ;
regBind   = REG ":" IDENT ;   // REG ∈ { d0, d1, d2, a0, a1 }
```

- Bare `reg` (no parenthesized list) keeps today's positional rule,
  untouched: ptrs → A0, A1 in declaration order; scalars → D0, D1 in
  declaration order; 2+2 limit; `memerr` as today. No churn in shipped
  declarations.
- `reg( ... )` is the named form: each `REG: paramName` binds that
  register to that parameter. Register names are contextual identifiers
  (like `reg` itself), lowercase only (`d0`…`d2`, `a0`, `a1`) —
  matching the listing printer's own lowercase register spelling; any
  other spelling is a parse error.
- The register set is a table (`d0 d1 d2 a0 a1`), trivially extensible;
  `a5`/`a6`/`a7` are never valid (globals base, frame, stack).
- `ret REG` optionally names the result register. Default when omitted:
  today's rule — A0 for a `ptr` result, D0 otherwise. `ret` with no
  declared return type is an error.
- `memerr` composes with the named form exactly as with bare `reg` (the
  declared result reads back from MemErr after the trap instead of from
  any register); `memerr` and `ret` are mutually exclusive.
- `sel` and any `reg` form remain mutually exclusive (unchanged).

### Checker rules

- Every declared parameter is bound exactly once; every bound name must
  be a declared parameter; no register bound twice. Diagnostics name the
  offending parameter/register.
- Parameter types: `int`, `bool`, `char`, `word`, `ptr` (same set as
  positional `reg`; `str`/`text` still rejected). NO count limit — the
  2+2 limit is the positional rule's, not the mechanism's; the named
  form is bounded only by the register table.
- Return types: the ordinary extern set (`int`, `ptr`, `bool`, `char`,
  `word`). The **declared return type** carries the type and width;
  `ret` carries only the location.

### Result-width rule (and a Ch13 correction)

Reading the result from the named (or defaulted) register:

- `int` / `ptr` — full 32 bits of the register.
- `word` — low 16 bits, **sign-extended** (Toolbox `INTEGER`/`OSErr`).
- `bool` / `char` — low byte, zero-extended.

This `word` rule is unified across BOTH `reg` forms. Ch13 currently says
a `word` result under `reg` "occupies a full D-register slot exactly like
`int`" — that sentence contradicts the one shipping user
(`UiGestalt`, `ui.cla:303`, whose `cgCallExtGestalt` special case
hand-emits the OSErr sign-extension). The corpus has no other bare-`reg`
`word` result (grepped 2026-08-04), so unifying is behavior-neutral
everywhere except making the written rule match the one real call site.
Ch13's sentence is corrected as part of this feature. (`word`
*parameters* under any `reg` form still occupy a full D-register like
`int` — unchanged.)

### Implementation shape

- AST/IR: per-param register codes + return-register code join the
  extern registry (new parallel arrays alongside
  `irExternNames`/`irExternConvs`/etc.; a new conv value distinguishes
  the named form). Exact encoding is the plan's call.
- cg68k: `cgRegPassArgsAndTrap` generalizes to table-driven assignment —
  same push-all-then-pop-in-reverse scheme (pops can't clobber pending
  `cgExpr` scratch), `MOVEA` for address registers. Result read per the
  width rule above. `cgCallExtGestalt` and its by-name dispatch hook are
  **deleted** once `UiGestalt`'s declaration carries the named clause.
  (The other by-name special cases — `UiProgDesc`/`UiTestScript`/
  `UiLdefEntry`/`UiActionEntry`/`UiStrAddr` — are glue-address/intrinsic
  cases, not register-convention cases; they stay.)
- cprint: unchanged. Clause data remains invisible on the C lane — every
  extern call renders as `rt_ext_<name>(args...)` and the C shim's
  compiler handles registers. (This is already true of `trap`/`sel`/
  positional `reg`.)

## Feature B — `extern record`

### Surface

```rust
extern record Point {
    v: word
    h: word
}

extern record EventRecord {
    what: word
    message: int
    when: int
    where: Point
    modifiers: word
}

extern record SFReply {
    good: bool
    copy: bool
    fType: int
    vRefNum: word
    version: word
    fName: str[63]
}

func waitClick() {
    var ev: EventRecord
    while UiWaitNextEvent(0xFFFF, ev, 10, nilPtr()) == 0 { }
    handleAt(ev.where.v, ev.where.h)
}
```

`extern` is already contextual before `func`; it becomes contextual
before `record` the same way (`overlay record` precedent).

### Semantics — a storage kind, not a value kind

- Declarable as a **local or global variable**: the compiler reserves
  the record's packed size in bytes, zero-initialized (like all Clarus
  locals/globals).
- **Field access** (`ev.what`, `ev.where.v`) reads/writes at packed
  offsets — ordinary scalar expressions/assignment targets.
- **No whole-record operations**: no assignment (`ev2 = ev`), no
  comparison, not a function parameter or return type, not an ordinary
  `record` field, not a container element, not `file.save`/`form for`
  subjects. (Any of these can be added later if a real IM use case
  demands it; none does today.)
- **Ptr decay at extern call sites only**: passing an extern-record
  variable — or a nested extern-record field lvalue (`ev.where`) — where
  an `external func` parameter is declared `ptr` passes its **address**.
  This is the only way to take an extern record's address; no general
  address-of operator enters the language.
- **Point-by-value coercion**: a 4-byte extern record (variable or
  field) may additionally pass where an extern parameter is declared
  `int` — the 4 bytes load as one long. This is the IM
  Point-by-value idiom (`FindWindow(where, ...)`). Any other size in an
  `int` position is an error.
- Extern records are all-scalar storage: structurally outside ARC
  (`irtNeedsCtor` exclusion, same as overlay records), no retain/release
  anywhere.

### Field palette (the IM working set)

| Clarus field type | bytes | alignment | notes |
|---|---|---|---|
| `bool` | 1 | 1 | Pascal `Boolean` |
| `byte` | 1 | 1 | new contextual field-type name, unsigned byte (`SignedByte`/`Byte`); reads/writes as `int`, zero-extended |
| `word` | 2 | 2 | `INTEGER`; reads back sign-extended (same as extern `word`) |
| `int` | 4 | 2 | `LONGINT`/`OSType`/`Fixed` — 68k packs longs at 2 |
| `ptr` | 4 | 2 | `Ptr`/`Handle`/`ProcPtr` fields |
| nested `extern record` | its size | 2 | `Point` in `EventRecord`; nesting depth unbounded |
| `str[N]` (1 ≤ N ≤ 255) | N+1 | 1 | Pascal string buffer (`Str63` = `str[63]`): length byte + N bytes. Reads as `str` (copy out), assigns from `str` (truncating at N, length byte updated) |
| `pad[N]` (N ≥ 1) | N | 1 | reserved/unused byte runs (`ParamBlockRec` filler); not readable or writable, occupies layout only, needs no field name — `pad[4]` alone is a complete field line |

Total record size rounds up to even. Field offsets are the classic MPW
68k packing rule exactly: each field aligned per the table, no other
padding inserted. `fixed`-typed fields: not in this phase (add on
demand — `Fixed` transcribes as `int` and converts via the existing
fixed conversions).

### Layout authority — one new, SHARED rule

Unlike the two deliberately-divergent internal record layouts (cg68k's
4-byte bool/char slots vs cprint's C-struct rule — which must never be
cross-used), the extern-record layout IS the Toolbox ABI, so **both
backends consume one shared offset/size computation**. IR: a third
record-kind flag alongside the overlay flag routes `cgFieldOffset` /
`cpCFieldOffset` (and any other layout consumer) to the new authority;
the two existing authorities are untouched.

Byte-order contract: field access is **native-byte-order** scalar access
at packed offsets — the exact contract `peekw`/`peekl`/`pokew`/`pokel`
have today. Big-endian on the 68k lane, host-endian on the host lane;
existing host shims that fake Toolbox structs keep working unchanged.

On the C lane, an extern record emits as a byte-array struct
(`typedef struct { uint8_t b[SIZE]; } clar_xrec_<Name>;`) with all field
access as offset arithmetic + `memcpy`-style scalar moves — the C
compiler's own struct layout/alignment never gets a vote, so the
compiler's offset table is the single authority on both lanes.

### What it replaces

`runtime/clarus/ui.cla`'s EventRecord magic offsets (`peekl(ev + 10)`)
and `native.cla`'s hand-named ParamBlockRec offset constants
(`natIoResult=16` …) are the motivating call sites. Migrating the
runtime itself is NOT required in this phase (the _Pack3 port and future
runtime work adopt extern records as they touch those files); the
native gate (below) proves the mechanism against a real trap instead.
`overlay record` is unchanged and remains the right tool for
address-view over memory the program does not own.

## Feature C — `callback func`

### Surface

```rust
callback func myAction(ctl: ptr, part: word) {
    rtUiScrollStep(ctl, part)
}

UiTrackControl(ctl, startPt, myAction)
```

`callback` is contextual immediately before `func` (the
`overlay record` / `external func` pattern); an ordinary identifier
everywhere else. Top-level declarations only.

### Semantics

- A `callback func` is an ordinary Clarus function body with a
  restricted signature: parameter and return types limited to `bool`,
  `char`, `word`, `int`, `ptr` — what pascal glue can marshal. (No
  `str`/`text`/records/containers; no defaults.)
- The Toolbox calls it via the **pascal calling convention**; the
  compiler auto-emits the glue that `cgEmitLdefGlue`/`cgEmitActionGlue`
  hand-roll today: pascal prologue reading each arg at its fixed A6
  offset (short → sign-extend, `bool`/`char` → the empirically-pinned
  high-byte-of-word rule, normative in Ch13), Clarus-convention call
  into the body, result written to the pascal result slot (same
  high-byte rule for `bool`/`char`), no-RTD callee-pop epilogue
  (UNLK; pop return address; clean pascal arg bytes; JMP).
- **Address-taking = name decay at extern call args**: the bare name of
  a `callback func` passed where an `external func` parameter is
  declared `ptr` passes the glue's address — the JT-entry address on the
  native lane (`LEA jtDisp(A5),A0` — segment-safe, the existing
  `cgCallExtUiGlueAddr` trick), a real function pointer on the C lane.
  A callback name anywhere else (ordinary call, variable, non-extern
  arg) is a checker error. A callback may also be CALLED directly as an
  ordinary Clarus call (the body is a normal function) — direct calls
  bypass the glue.
- **Tree-shake auto-rooting**: lowering an address-of-callback decay
  roots the glue and the body (`shakeAddRoot`), replacing today's
  hand-listed roots. A callback whose address is never taken and which
  is never called shakes away normally, glue and all.
- C lane: the callback body emits as an ordinary C function; the glue is
  a generated wrapper marked with Retro68's `pascal` qualifier on the
  Mac lane and plain on the host lane (host has no pascal convention),
  so host shims can genuinely invoke callbacks in tests. Decay emits the
  wrapper's address.
- Pascal-convention knowledge consolidates: `cgCallExtPascal`, the
  generated callback glue, and (until deleted) the two hand-rolled glue
  emitters share one marshaling helper rather than three hand-rolled
  copies.

### Runtime migration (in-phase)

The LDEF stub (`rtUiLdefDraw`) and the scrollbar action proc
(`rtUiScrollbarAction`) migrate to `callback func` declarations;
`cgEmitLdefGlue`, `cgEmitActionGlue`, their `shakeAddRoot` hand-listings,
and the corresponding by-name special cases (`UiLdefEntry`/
`UiActionEntry`) are **deleted**. The 23 frozen UI goldens must stay
byte-identical through the migration (the List Manager invokes the LDEF
for real on every scripted table boot — this is the feature's native
proof, at zero new-input cost). The `rt_ext_mac.inc` hand-written C
wrappers for the Mac lane migrate to the generated form the same way.

### Non-goals (unchanged from ROADMAP)

Interrupt-time completion routines (VBL tasks, async completion procs,
Time Manager tasks) — A5/allocation restrictions the language cannot
make safe. `procptr(f)`-style storable function values — add only when
a real IM use case (a stored dlgHook in a record) demands it.

## Extern dedup — identical-signature merge

Duplicate `external func` declarations are legal iff name, parameter
list (names may differ; types and order must match), return type, and
the ENTIRE clause (trap word, `sel` value, convention, register
bindings, `memerr`, `ret`) match exactly. The registry keeps one entry;
the checker skips re-registration on an exact match. Any mismatch is a
compile error citing both declaration sites. The same rule covers
duplicate `extern record` declarations (field-for-field: names, types,
order). `callback func`s never merge (they have bodies; ordinary
redeclaration error).

This is the C-header model: user code can re-declare a trap the runtime
already declares (transcribed independently from the same IM page), and
future `toolbox/` catalog files can overlap the runtime and each other
safely.

## Verification

Per feature:

- **Reference-first**: Ch13 gains normative sections/amendments (named
  `reg` clause + result-width correction; `extern record` incl. the
  packing table; `callback func` incl. the marshaling rules; the dedup
  rule in the `external func` section). The IM→Clarus cookbook table is
  explicitly OUT of this phase (ROADMAP phase 3, after the features).
- **clarusc fixtures**: parser/checker error fixtures (bad register,
  unbound/double-bound param, `ret` without return type, palette
  violations, decay misuse, whole-record assignment, callback-name
  misuse, dedup mismatches) and positive fixtures per feature; cg68k
  listing goldens (named-reg call incl. word sign-extension, packed
  field access at every field type, callback glue + decay); emitui/
  behavior goldens over the new fixtures (Go-free lanes). Dedup-merge
  fixture: a program re-declaring a runtime trap identically, building
  clean.
- **Native gates** (`testsuite/toolbox`, one boot, both lanes):
  - A: real Gestalt through the named clause (e.g. `gestaltQuickdrawVersion`),
    response cross-checked sane — the retired special case proving its
    replacement.
  - B: an `extern record EventRecord` filled by a real
    `OSEventAvail`/`GetNextEvent` trap; fields cross-checked against
    manual `peekl`/`peekw` at the same address (the two access paths
    must agree byte-for-byte).
  - C: the migrated LDEF exercised by the existing frozen table
    goldens — byte-identical snaps are the pass criterion.
- **Gates**: T1 `--smoke` per task (runtime/ and clarusc/ both change);
  snapshot regen + `TestSnapshotFixedPoint` at each feature boundary;
  full T2 before merge; the 23 UI goldens stay frozen and byte-identical
  throughout.

## Sequencing within the plan

A (clause) → B (extern record) → C (callbacks incl. LDEF/action
migration + special-case deletions) → dedup (can land with A if
convenient — it touches only the checker/registry) → Ch13 wrap + ROADMAP
outcome. Go deletion + the six `build.Build` harness swaps are a
SEPARATE follow-up plan after this phase merges (decided 2026-08-04):
the phase's own tasks soak the Go-free machinery; the parachute outlives
the riskiest new-syntax work.

## Non-goals

- The IM→Clarus docs cookbook and the curated `toolbox/` extern catalog
  (ROADMAP phase 3; the dedup rule here is its prerequisite, the catalog
  itself is not).
- The _Pack3 Standard File port (separate committed spec; revise it
  against these features at its own implementation time).
- Runtime-wide migration of existing peek/poke sites to extern records
  (adopt opportunistically as files are touched; the EventRecord and
  ParamBlockRec sites are the eventual candidates).
- Interrupt-time callbacks; storable function values (`procptr`).
- Any Go-compiler change (frozen; new syntax is clarusc-only).
- Go deletion / harness swaps (separate follow-up plan).

## Outcome (2026-08-04)

All three features plus extern dedup landed as designed, 9 tasks, each
review clean after at most one fix round. As-built deviations from this
spec, task by task, with a one-line why each:

- **Task 1 (checker groundwork):** the self-hosted checker's own fixture
  corpus lives at `clarusc/test/check_test.cla`/`.out` (Cases 66-72), NOT
  `testdata/diag` (the Go-shared location) — `clarusc/test/` is
  genuinely clarusc-only, matching this phase's `ClaruscOnly`-fence
  intent even though its driver name doesn't match the `*_test.cla`
  sweep pattern.
- **Task 2 (Feature A):** `UiGestalt`'s migration to the named clause and
  `cgCallExtGestalt`'s deletion landed clean; deferred a stale header
  comment in `ui.cla` (still named the deleted special case) to Task 9's
  own touch of that file, per the ledger's forward note.
- **Task 6 (Feature B native gate) — real trap-convention bug found and
  fixed:** the gate's own `TbOSEventAvail` declaration used the WRONG
  calling convention. `OSEventAvail` (`0xA030`) is bit-11-CLEAR
  (OS-dispatch/register convention), but was declared plain Pascal —
  the same bug shape as the pre-existing `5faaa6c` MenuKey/TickCount
  lesson, this time caught before merge instead of after. Fixed by
  switching to the real Pascal sibling `_EventAvail` (`0xA971`, bit 11
  SET) instead, with the gate's assertion loosened to
  `got == (ev.what != 0)` — a documented assertion-limit (crash-class
  convention bugs are still caught; a coincidental-pass on the exact
  boolean value is not claimed as fully eliminated by construction).
  Same task fixed `cgSlotSizeOf`'s even-rounding for packed bool/char
  byte arrays — an allocation-only fix; Mini vMac does not model 68000
  address errors, so this was caught by eyeballing goldens for odd
  `.W`/`.L` bases, not by a native-gate failure (see the ROADMAP's own
  filed lesson).
- **Task 5 (Feature B, `str[N]` field storage):** the field's C-lane
  storage rides the EXISTING `clar_arr_char_N` typedef/array-of-char
  emission (`cpCTypeName`'s `KArr` case) rather than a new dedicated
  typedef — a second typedef would duplicate the size/zero-init/
  stable-address guarantees the array emission already provides for
  free; an authorized escape hatch from the original one-new-typedef
  framing, evidenced by a committed `xrec_str_host.cla` SFReply/fName
  runtime fixture (including 70→63 truncation).
- **Task 7 (Feature C prep, callback registry) — `CLAR_PASCAL` gate
  widened:** the pascal-qualifier macro that marks generated callback
  glue was initially gated `__m68k__`-only; fixed to the codebase's own
  established dual-macro idiom (`__m68k__ || macintosh`) — inert on
  today's single target, but would silently break a future PPC lane
  otherwise.
- **Task 8 (Feature C glue emission) — `KWord` `cgSizeOf` root fix:** a
  `word`-typed callback parameter's frame-slot size computation
  (`cgSizeOf`'s `KWord` case) returned 2, not 4 — provably unreachable
  for every EXISTING `cgSizeOf` caller (a `word` local/param always
  resolves through `KInt` in practice) but a real latent bug for the
  callback glue's own reservation math; fixed at the `cgSizeOf` root
  rather than patched around at the one new call site, since any future
  caller would have hit the same wrong answer.
- **Task 9 (Feature C runtime migration):**
  - **`UiCbAddr` identity-extern bridge, not named in this spec's own
    surface:** the checker's decay rule requires an extern-call `ptr`
    argument site; the LDEF installation call (`SetListDefProc`-style,
    via `pokel`) has no such site for a bare callback name to decay
    through. Bridged with a new clause-less extern,
    `external func UiCbAddr(cb: ptr): ptr`, whose host/Mac-lane bodies
    are a one-line identity (`return cb`) — the existing `UiStrAddr`
    precedent (an identity bridge for a different address-taking
    shape), not a new by-name special case.
  - **`cprint.cla` string→text accumulator fix, a real bug in
    already-landed Task 7/8 code:** `cpCbSignature`/`cpCbGlueProto`/
    `cpCbGlueWrapper`'s text-accumulator locals used `string` (an
    implicit, 255-byte-BOUNDED `str 255`) instead of `text`
    (unbounded) — every other text-accumulation helper in `cprint.cla`
    already uses `text` for this reason. `rtUiLdefDraw`'s 7-parameter
    glue body was the first callback signature large enough to hit the
    255-byte cap, silently truncating mid-identifier
    (`cv_dataOffset`→`cv_d`) and producing malformed C. Root-caused and
    fixed (retyped to `text` throughout, matching the file's own
    convention) rather than worked around, since Task 9's migration was
    exactly the trigger that would keep re-tripping it.
  - Generated glue verified instruction-identical to the deleted hand
    glue at the listing level; the 23 frozen UI goldens
    (`testdata/uisnaps`) stayed byte-identical (zero diffs) through the
    migration — the feature's own acceptance proof.

Deferred minors (recorded, not fixed — each independently low-risk):
`clarusc/cprint.cla`'s `cpCbWireType`/`cpCbRetWireType` remain
string-typed rather than a proper enum (bounded, safe in practice);
stale-but-harmless `cpFuncProto` allowlist entries left over from the
functions Task 9 migrated to `callback func`; `cgEmitFunc` calls
`cgCbGlueBodyFor` twice per callback (negligible, double work not double
output). The one deferred item this spec's own drafting had flagged —
Ch13's dedup prose not naming `memerr` explicitly among the clause
fields that must match for a duplicate extern to merge — was fixed at
phase wrap (Task 10), not left deferred.

Evidence: `testsuite/toolbox` 7/7 both lanes (native gates:
`GestaltNamed` for Feature A, `EventXRec` for Feature B — a real
`OSEventAvail`-sibling trap filling an `extern record EventRecord`,
cross-checked byte-for-byte against manual `peek`; Feature C's gate is
the existing frozen UI goldens, exercised for real on every scripted
table boot); `testsuite/core` 41/41; snapshot green at HEAD; deleted
machinery (`cgCallExtGestalt`, `cgEmitLdefGlue`/`cgEmitActionGlue`,
`UiLdefEntry`/`UiActionEntry` specials, all hand-listed `shakeAddRoot`
calls for them) — zero grep hits left in `clarusc/`. Full task-by-task
detail: `.superpowers/sdd/2026-08-04-toolbox-integration/task-{1..9}-
report.md`; ledger: same directory's `progress.md`.
