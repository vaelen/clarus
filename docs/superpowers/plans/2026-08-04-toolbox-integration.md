# Toolbox Integration Phase Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Land the three Toolbox-integration features — named-register
trap clause, `extern record` (Mac packed layout), `callback func` — plus
the identical-signature extern-dedup rule, each reference-first, then
clarusc, then both backends, with a native gate per feature; close by
migrating the runtime's own hand-rolled glue (Gestalt special case,
LDEF/action-proc emitters) onto the new features.

**Architecture:** All three features extend the existing extern
machinery: parser clauses in `parseExternFuncDecl`, the flat parallel-
array extern registry in `ir.cla`, call emission in `cg68k.cla`, the
`rt_ext_<name>` seam in `cprint.cla`. Extern-record layout lives in ONE
new shared authority consulted at lowering time — field access lowers to
the existing peek/poke IR ops with literal offsets, so both backends
inherit the layout for free and only need storage, zero-init, and
address-decay. Callbacks generalize `cgEmitLdefGlue` into a signature-
driven glue emitter; reachability becomes an IR edge (a new address-of
expression marked by tree-shake) instead of hand-listed roots.

**Tech Stack:** Clarus (clarusc/*.cla — the self-hosted compiler),
Clarus runtime (runtime/clarus/*.cla), C shims
(internal/build/rt/rt_ext_host.inc, runtime/mac/rt_ext_mac.inc), Go test
harnesses (maintainable per the standing ruling; the frozen Go COMPILER
is untouched).

## Global Constraints

- Spec: `docs/superpowers/specs/2026-08-04-toolbox-integration-design.md`
  — normative for all semantics; where this plan and the spec disagree,
  the spec wins.
- Branch: `toolbox-integration` off `main`. Merge only on Andrew's
  request, after full T2.
- **Frozen Go compiler untouched** (`cmd/clarus`, `internal/lexer`,
  `parser`, `check`, `types`, `lower`, `cprint`, `driver`). All new
  syntax is clarusc-only; new-syntax fixtures in reference fences use
  `ClaruscOnly` markers; new `.cla` fixtures live in clarusc-only swept
  dirs (`testdata/cg68k/`, `testdata/lowlevel/`, `testsuite/`).
- clarusc's OWN source (`clarusc/*.cla`, `runtime/clarus/*.cla` up to
  Task 9's migration) stays in the conservative subset — it implements
  the features; only Task 9's runtime migration and fixtures USE them.
- **MacRoman discipline**: `.cla` files are MacRoman-encoded. All new
  fixtures in this plan are pure ASCII (verified with
  `LC_ALL=C grep -n '[^ -~]' FILE` → no output). Never edit existing
  `.cla` files containing high bytes with the Edit tool — use
  `LC_ALL=C sed` and verify with a byte-diff (see the memory note this
  repeats: Edit corrupts MacRoman).
- **Gates**: `scripts/test-task.sh --smoke` after every task (runtime/
  and clarusc/ change in this phase). Snapshot regeneration at each
  feature boundary (Tasks 2, 6, 9): rebuild per `TestSnapshotCurrent`'s
  own printed instructions, then
  `go test -count=1 ./internal/selfhost -run 'TestSnapshot' -timeout 30m`
  must pass (builds + fixed point). The 23 frozen UI goldens
  (`testdata/uisnaps`) are never re-blessed; any diff is a bug.
- New behavior fixtures get `.behavior` goldens per
  `internal/selfhost/behavior_test.go`'s own bless mechanism (read its
  header for the bless env var); listing goldens per
  `internal/cg68k/golden_test.go`'s.
- Exact diagnostic strings specified per task are normative for the
  error fixtures — checker messages must match them.
- Register-code encoding (Tasks 1-2): `d0..d2` = 0..2, `a0` = 8,
  `a1` = 9 (bit 3 = address-register flag), `-1` = none. Conv-flag
  values: existing 0-6 unchanged; `7` = named reg, `8` = named reg +
  memerr.

## File Structure

- Modify: `docs/clarus-language-reference.md` — Ch13 amendments (Tasks
  1, 3, 4, 7; final read-through Task 10).
- Modify: `clarusc/parse.cla` (clause grammar, `extern record`,
  `callback func`), `clarusc/ast.cla` (side arrays), `clarusc/check.cla`
  (all new rules + dedup), `clarusc/ir.cla` (registry arrays, xrec
  layout authority, new expr kinds), `clarusc/lower.cla` (field-access
  rewrite, decays, callback edge), `clarusc/shake.cla` (callback arm),
  `clarusc/cg68k.cla` (named-reg call, xrec storage/decay, glue
  generalization, special-case deletions), `clarusc/cprint.cla` (xrec
  storage/decay, callback wrapper).
- Modify: `runtime/clarus/ui.cla` (UiGestalt clause, Task 2), `ui.cla` +
  `uitable.cla` (callback migration, Task 9).
- Modify: `runtime/mac/rt_ext_mac.inc` (delete migrated hand-written
  pascal wrappers, Task 9), `internal/build/rt/rt_ext_host.inc` (two
  tiny test shims, Tasks 5, 7).
- Create: fixtures under `testdata/cg68k/`, `testdata/lowlevel/`,
  checker-error fixtures wherever `internal/testsuite`'s error corpus
  lives (Task 1 confirms the exact dir), `testsuite/toolbox/cases_*.cla`
  (native gates, Tasks 2, 6).
- Modify: `docs/ROADMAP.md` (Task 10 outcome entry).

---

### Task 1: Named-reg clause — Ch13 + parser + AST/IR + checker

**Files:**
- Modify: `docs/clarus-language-reference.md` (Trap and Inline Clauses,
  ~line 1394; The `word` Extern Type, ~line 1448)
- Modify: `clarusc/parse.cla:1364-1478` (`parseExternFuncDecl`),
  `clarusc/ast.cla` (~137-149 DkExternFunc doc + side arrays),
  `clarusc/ir.cla:682-699` (`irRegisterExtern` + new arrays),
  `clarusc/check.cla:1797-1853` (`checkExternFunc`)
- Test: checker error fixtures + one accept fixture (this task's Step 1
  locates the error-fixture corpus dir by finding where an existing
  extern-clause error fixture lives — e.g. grep for the current
  "third parameter" reg-limit diagnostic in testdata/)

**Interfaces:**
- Consumes: existing extern registry parallel arrays, convFlag 0-6.
- Produces (Tasks 2+ rely on these): conv values `7`/`8`; AST side
  arrays `astExternRegBind(declIdx, paramIdx) -> regCode` and
  `astExternRetReg(declIdx) -> regCode` (exact storage shape is the
  implementer's, but these lookups must exist); IR arrays
  `irExternParamRegs` (flat, parallel to `irExternParamTys`) and
  `irExternRetRegs` (per extern, `-1` = default rule); register codes
  per Global Constraints.

- [ ] **Step 1: Ch13 amendment.** Extend the clause grammar block
  (reference ~1398-1402) with:

  ```
  regClause = "reg" [ "(" regBind { "," regBind } ")" ] [ "memerr" ] [ "ret" REG ] ;
  regBind   = REG ":" IDENT ;   // REG in { d0, d1, d2, a0, a1 }, lowercase
  ```

  plus normative prose per the spec's Feature A section: named-form
  binding rules, no count limit, `ret` default (A0 ptr / D0 else),
  `memerr`/`ret` mutual exclusion, and the result-width rule (int/ptr =
  32 bits; word = low 16 sign-extended; bool/char = low byte
  zero-extended). CORRECT the existing `word`-under-`reg` sentence
  (~1470): a `word` RESULT under any `reg` form reads the low 16 bits of
  the result register sign-extended; `word` parameters still occupy a
  full D-register like `int`. Fences with named-clause examples are
  `ClaruscOnly`. Use the spec's `UiGestalt` declaration as the worked
  example.

- [ ] **Step 2: Write the failing fixtures.** Accept fixture (name it
  `regnamed_decl.cla`, in the clause-fixture dir found in this step):

  ```rust
  external func TbGestalt(selector: int, response: ptr): word
      = trap 0xA1AD reg(d0: selector, a1: response) ret d0

  func App.startCLI(args: list of string) {
      // declaration-only fixture: named-clause externs parse and check;
      // calls land in Task 2's goldens
      print("ok")
  }
  ```

  Error fixtures, one per diagnostic (exact strings normative):
  - bind unknown param → `reg binding names unknown parameter 'x'`
  - same register twice → `register d0 bound twice`
  - param left unbound → `parameter 'response' has no register binding`
  - `ret` on a void extern → `ret clause requires a return type`
  - `ret` together with `memerr` → `memerr and ret are mutually exclusive`
  - bad register name (`d3`, `a5`) → `unknown register 'a5' in reg clause`
  - `str` param under named reg → same diagnostic positional reg gives today

- [ ] **Step 3: Run to verify failure.** The accept fixture must fail to
  parse with today's compiler (bare `reg` followed by `(`):
  `scripts/clarus-run.sh` on it, or the fixture harness's check runner.
  Expected: parse error at `(`.

- [ ] **Step 4: Implement.** Parser: after `reg` matches
  (`parse.cla` ~1468), accept optional `(` regBind-list `)`, optional
  `memerr`, optional `ret` REG; contextual lowercase register names via
  the `curIsIdentText` idiom; conv 7/8 selection; bindings + ret into
  the new AST side arrays. IR: `irRegisterExtern` grows the two new
  arrays (default `-1`s for conv != 7/8). Checker (`checkExternFunc`):
  for conv 7/8 — every param bound exactly once, no dup register, known
  registers only, `str`/`text` rejected as today, NO count limit, `ret`
  rules; conv 2/6 path untouched.

- [ ] **Step 5: Run fixtures — accept passes check, each error fixture
  produces exactly its diagnostic.** Also
  `go test -count=1 ./internal/testsuite` (or the harness dir found in
  Step 1) green.

- [ ] **Step 6: T1.** `scripts/test-task.sh --smoke` → PASS. (clarusc
  changed; snapshot regen waits for the Task-2 feature boundary — the
  snapshot tests compare committed-snapshot behavior, which is unchanged
  by accept-only parsing until something calls the new clause.)
  If `TestSnapshotCurrent`-adjacent lanes complain earlier than
  expected, regenerate at this task instead and note it in the report.

- [ ] **Step 7: Commit** `feat(clarusc): named-register trap clause — parse/check/registry`.

---

### Task 2: Named-reg clause — cg68k emission, Gestalt retirement, native gate

**Files:**
- Modify: `clarusc/cg68k.cla:6602-6679` (`cgRegPassArgsAndTrap`,
  `cgCallExtReg`), delete `cgCallExtGestalt` (7101-7125) + its dispatch
  hook (7009-7012) + its doc block (7068-7100)
- Modify: `runtime/clarus/ui.cla:303` (UiGestalt declaration — LC_ALL=C
  sed, this file has MacRoman bytes)
- Test: `testdata/cg68k/regnamed.cla` listing golden;
  `testsuite/toolbox/cases_gestalt.cla` (new native-gate case);
  `testsuite/toolbox/runner.cla` (enum + dispatch row)

**Interfaces:**
- Consumes: Task 1's conv 7/8, `irExternParamRegs`, `irExternRetRegs`,
  register codes.
- Produces: generalized `cgRegPassArgsAndTrap(xi)` handling conv
  2/6/7/8 from one table-driven path; `word`-result sign-extension
  applied for ALL reg forms (the unification).

- [ ] **Step 1: Listing golden fixture** `testdata/cg68k/regnamed.cla`:

  ```rust
  external func TbGestalt(selector: int, response: ptr): word
      = trap 0xA1AD reg(d0: selector, a1: response) ret d0
  external func TbSwapD2(v: int): int
      = trap 0xA123 reg(d2: v) ret d2

  func probe(): int {
      var resp: int = 0
      var err: int = TbGestalt(0x71642020, ptrOf(resp))
      return err + TbSwapD2(7)
  }
  ```

  (If `ptrOf` doesn't exist, use the fixture idiom existing cg68k
  fixtures use to produce a ptr — copy from a neighboring fixture; the
  golden's subject is the call sequence, not the pointer source.)
  Bless the golden per `internal/cg68k/golden_test.go`; eyeball the
  blessed listing for: push-all args, pops in reverse into D0/A1 (MOVEA
  for A1), trap word, `EXT.L D0`-equivalent sign-extension of the word
  result from D0, and D2 marshaling for the second extern.

- [ ] **Step 2: Failing state.** Before implementation the fixture
  aborts codegen (unknown conv 7) — capture that error as the RED.

- [ ] **Step 3: Implement.** Generalize: build a per-call assignment
  list — conv 2/6 from the positional rule (unchanged behavior), conv
  7/8 from `irExternParamRegs` — then one shared push/pop/trap/result
  path. `MOVEA.L` for A-register targets. Result: from
  `irExternRetRegs` (or default), width per declared return type —
  including the `word` sign-extension now applied to conv 2 as well
  (spec's unification; UiGestalt is the only extant user and its special
  case did exactly this). Delete `cgCallExtGestalt` + dispatch hook.
  Re-clause `UiGestalt` (ui.cla:303) to the named form via LC_ALL=C sed:

  ```
  external func UiGestalt(selector: int, response: ptr): word = trap 0xA1AD reg(d0: selector, a1: response) ret d0
  ```

- [ ] **Step 4: Goldens + UI scenarios green.**
  `go test -count=1 ./internal/cg68k ./internal/emitui` — the 23 UI
  goldens must be byte-identical (Gestalt's call sites emit the same
  bytes through the general path; if they don't, that's a bug to fix,
  not a re-bless).

- [ ] **Step 5: Native gate case.** `testsuite/toolbox/cases_gestalt.cla`
  — new `ToolboxTest` case `GestaltNamed` following `cases_a5.cla`'s
  local-extern precedent: declare `TbGestalt` with the named clause,
  call with selector `'qd  '` (0x71642020, gestaltQuickdrawVersion),
  pass: err == 0 and response != 0 wired through the case's pass/fail
  return. Add the enum row + dispatch in `testsuite/toolbox/runner.cla`.
  Run both gated lanes:
  `CLARUS_MAC_TESTS=1 go test -count=1 ./internal/mactest -run 'TestToolboxSuite' -timeout 30m`
  → 6/6 cases green on both.

- [ ] **Step 6: Snapshot regen (feature boundary).** Regenerate
  `clarusc/clarusc.c` per `TestSnapshotCurrent`'s printed instructions;
  `go test -count=1 ./internal/selfhost -run 'TestSnapshot' -timeout 30m`
  → PASS. Then full `scripts/test-task.sh --smoke` → PASS.

- [ ] **Step 7: Commit** `feat(cg68k): named-register trap emission; retire cgCallExtGestalt; toolbox GestaltNamed gate`.

---

### Task 3: Extern dedup — identical-signature merge

**Files:**
- Modify: `clarusc/check.cla` (~1734 `checkFuncSig` redeclaration path,
  ~1797 `checkExternFunc`), `clarusc/ir.cla` (registry lookup-before-
  append), `docs/clarus-language-reference.md` (`external func` section
  ~1342 gains the dedup paragraph)
- Test: accept fixture (identical re-declaration builds + runs), two
  error fixtures

**Interfaces:**
- Consumes: extern registry incl. Task 1's new arrays.
- Produces: `irExternLookup(name) -> idx or -1` (or equivalent) used by
  the merge; the rule later reused for `extern record` (Task 4) — the
  comparison must cover param types+order, return type, conv, trap, sel,
  reg bindings, ret reg (param NAMES exempt).

- [ ] **Step 1: Fixtures.** Accept (`testdata/lowlevel/externdedup.cla`
  or the dir Task 1 confirmed): a program declaring
  `external func UiTickCount(): int = trap 0xA975` (identical to the
  runtime's own declaration — verify the runtime's exact clause first
  and copy it byte-for-byte), calling it, printing a sanity line.
  Error fixtures: same name, different trap word → diagnostic
  `conflicting extern declaration for 'UiTickCount'` (message must name
  both source positions); same name+trap, different param type → same
  diagnostic.

- [ ] **Step 2: RED.** Accept fixture today fails with the generic
  `redeclaration of UiTickCount`.

- [ ] **Step 3: Implement.** In the extern path of `checkFuncSig`'s
  redeclare handling (or immediately before `scopeDeclare`): if the
  existing symbol is an extern and the new declaration is
  signature+clause-identical, skip re-declare and re-register (call
  sites resolve to the one entry); mismatch → the new diagnostic with
  both positions. `callback func` (Task 7) and ordinary funcs keep the
  generic redeclaration error.

- [ ] **Step 4: GREEN** — fixtures + the harness package green;
  `.behavior` golden for the accept fixture.

- [ ] **Step 5: Ch13 paragraph** (in `external func`): duplicate extern
  declarations legal iff identical (spec's wording); one `ClaruscOnly`
  fence example.

- [ ] **Step 6: T1** `scripts/test-task.sh --smoke` → PASS. **Commit**
  `feat(clarusc): identical-signature extern dedup`.

---

### Task 4: extern record — Ch13 + parser + checker + layout authority + lowering

**Files:**
- Modify: `docs/clarus-language-reference.md` (new `extern record`
  section after Overlay Records ~1359, incl. the packing table from the
  spec)
- Modify: `clarusc/parse.cla` (extern-before-record; field palette
  grammar incl. `str[N]`, `pad[N]`, `byte`, nested names),
  `clarusc/ast.cla`, `clarusc/check.cla`, `clarusc/ir.cla` (record-kind
  flag `irRecordLayoutIsXRec` + layout authority + one new expr kind),
  `clarusc/lower.cla` (field access → peek/poke rewrite, decay, int
  coercion)
- Test: checker error fixtures; layout assertions inside the Task 5
  behavior fixture (offsets are proven by cross-checked access, not by a
  unit test on the pure function)

**Interfaces:**
- Consumes: `irRecords`/`irFieldSlots` arenas, overlay-record flag
  precedent, peek/poke IR ops, Task 3's dedup comparison.
- Produces (Tasks 5-6 rely on): record-kind flag
  `irRecordLayoutIsXRec(recIdx)`; layout authority
  `irXRecFieldOffset(recIdx, fieldIdx) -> int` and
  `irXRecSize(recIdx) -> int` implementing the spec's packing table
  (bool/byte 1@1, word 2@2, int/ptr 4@2, nested xrec size@2, str[N]
  N+1@1, pad[N] N@1, total rounded to even) — THE only layout authority,
  consulted by lower only; new IR expr `EXRecAddr(varRef, byteOffset)`
  yielding the address of an xrec variable/field (both backends
  implement it in Tasks 5-6); field reads/writes lowered to existing
  peek/poke ops on `EXRecAddr` + literal offsets, with explicit
  sign/zero-extension ops where the palette requires (word: sign-extend
  16; byte: zero-extend 8; bool: zero-extend 8, nonzero→1 on read;
  str[N]: lowers to the runtime Str255 copy helpers — pick the existing
  rtStr* helpers at implementation time and record which in the report).
- Decay/coercion (checker+lower): xrec var or nested-xrec field where an
  extern param is `ptr` → `EXRecAddr`; 4-byte xrec where extern param is
  `int` → peekl of its address; anywhere else → errors below.

- [ ] **Step 1: Ch13 section.** New `### extern record` after Overlay
  Records: the spec's semantics (storage kind, field access, no
  whole-record ops, decay at extern args only, Point-int coercion,
  native-byte-order contract, ARC-exempt) + the packing table verbatim +
  the spec's Point/EventRecord/SFReply fences (`ClaruscOnly`). State
  explicitly how it differs from `overlay record` (storage + packed
  layout vs address view).

- [ ] **Step 2: Error fixtures** (exact strings normative):
  - bad field type (`x: text`) → `extern record field type must be bool, byte, word, int, ptr, str[N], pad[N], or an extern record`
  - whole assign (`a = b`) → `extern records cannot be assigned`
  - xrec as ordinary-record field → `extern records cannot be record fields`
  - xrec as container element → `extern records cannot be container elements`
  - xrec as func param/return → `extern records cannot be function parameters or results`
  - decay outside extern args (passing to a Clarus func's ptr param) → `extern record address can only be passed to an external function`
  - non-4-byte xrec in extern `int` position → `only a 4-byte extern record can pass as int`
  - `str[0]` / `str[256]` → `str field length must be 1..255`
  - reading `pad` (grammar forbids naming it; a named `pad` field parses
    as a nested-record reference to unknown type `pad` → ordinary
    unknown-type diagnostic; note this in the fixture comment)

- [ ] **Step 3: RED** — every fixture fails to parse today (`extern
  record` is a parse error); capture, then implement parse first so the
  error fixtures exercise the CHECKER paths (parse must accept all of
  them syntactically except where noted).

- [ ] **Step 4: Implement** parser (extern contextual before `record`,
  palette grammar), checker (palette + usage bans + decay/coercion
  typing + dedup for xrecs field-for-field via Task 3's rule), IR (flag
  + layout authority + `EXRecAddr`), lower (storage declaration paths
  for locals/globals — reuse the fixed-array frame/global storage shape;
  zero-init; field access rewrite; decay; coercion). Layout sanity: the
  authority MUST yield EventRecord.where at offset 10 and
  size 16, SFReply.fName at offset 10 and size 74 — assert both in a
  temporary scratch check during development (not committed).

- [ ] **Step 5: Fixtures GREEN** (checker errors exact; accept fixtures
  compile). T1 `scripts/test-task.sh --smoke` → PASS. **Commit**
  `feat(clarusc): extern record — parse/check/layout/lowering`.

---

### Task 5: extern record — cprint lane + host behavior proof

**Files:**
- Modify: `clarusc/cprint.cla` (xrec storage typedef/decl, `EXRecAddr`,
  zero-init)
- Modify: `internal/build/rt/rt_ext_host.inc` (one test shim)
- Test: `testdata/lowlevel/xrec_host.cla` behavior fixture + `.behavior`
  golden

**Interfaces:**
- Consumes: Task 4's lowered form (peek/poke + `EXRecAddr` + literal
  offsets).
- Produces: cprint emits `typedef struct { uint8_t b[SIZE]; } clar_xrec_<Name>;`
  per xrec; locals/globals declared as that type, zero-initialized;
  `EXRecAddr` renders as `((void*)((uint8_t*)&var + OFFSET))`. Host test
  shim (exact code):

  ```c
  /* identity: lets a fixture recover the address an extern-record decay
     produced, so pure-Clarus peek can cross-check packed offsets */
  static void *rt_ext_XRecAddr(void *p) { return p; }
  ```

  (match the file's existing shim declaration idiom; wire into whatever
  registration the file uses for the lowlevel fixtures' externs.)

- [ ] **Step 1: Behavior fixture** `testdata/lowlevel/xrec_host.cla`:

  ```rust
  extern record Point { v: word  h: word }
  extern record EventRecord {
      what: word
      message: int
      when: int
      where: Point
      modifiers: word
  }
  external func XRecAddr(p: ptr): ptr

  func App.startCLI(args: list of string) {
      var ev: EventRecord
      ev.what = -2
      ev.message = 0x01020304
      ev.when = 99
      ev.where.v = -300
      ev.where.h = 40
      ev.modifiers = 0x0180
      var base: ptr = XRecAddr(ev)
      // packed offsets, cross-checked against the layout table:
      print(int(peekw(base + 0)))    // what: -2 (sign-extended word)
      print(peekl(base + 2))         // message
      print(peekl(base + 6))         // when
      print(int(peekw(base + 10)))   // where.v
      print(int(peekw(base + 12)))   // where.h
      print(peekl(XRecAddr(ev.where)))  // nested-field decay = base+10 contents
      print(ev.what)                 // field read round-trip: -2
      print(ev.where.v)              // -300
  }
  ```

  (Adjust `peekw` result handling to its actual signature — if `peekw`
  already returns int natively-widened, drop the `int(...)`; Task 4's
  implementer recorded the extension ops. The COMMITTED golden is the
  authority once blessed and hand-verified: `-2`, `16909060`, `99`,
  `-300`, `40`, then the base+10 long, then `-2`, `-300`.)

- [ ] **Step 2: RED** — fixture fails (cprint hits `EXRecAddr`/xrec
  storage unimplemented).

- [ ] **Step 3: Implement** cprint per Interfaces; add the shim.

- [ ] **Step 4: GREEN** — run via `scripts/clarus-run.sh`, hand-verify
  every printed value against the packing table BEFORE blessing the
  `.behavior` golden. `go test -count=1 ./internal/lowlevel ./internal/build`
  green.

- [ ] **Step 5: T1** `--smoke` → PASS. **Commit**
  `feat(cprint): extern record storage/decay; xrec host behavior fixture`.

---

### Task 6: extern record — cg68k lane + native gate

**Files:**
- Modify: `clarusc/cg68k.cla` (xrec frame/global storage — the fixed-
  array T[n] contiguous-storage path is the model; zero-init;
  `EXRecAddr` = `LEA off(A6)/global` + literal field offset; decay/int-
  coercion already arrive lowered)
- Test: `testdata/cg68k/xrec.cla` listing golden;
  `testsuite/toolbox/cases_event.cla` native gate + runner row

**Interfaces:**
- Consumes: Task 4's lowered form; Task 5's fixture (shared — the same
  xrec_host.cla also runs under the native suite harness if the harness
  sweeps testdata/lowlevel natively; if not, the toolbox case is the
  native proof).
- Produces: native storage + `EXRecAddr`; `nat_XRecAddr` fallback (a
  Clarus `func nat_XRecAddr(p: ptr): ptr { return p }` in the fixture,
  per the clause-less-extern native fallback convention).

- [ ] **Step 1: Listing golden** `testdata/cg68k/xrec.cla` — a trimmed
  version of the Task 5 fixture (EventRecord + field writes/reads +
  one decay call); bless per golden_test.go; eyeball: frame reservation
  of 16 bytes, `MOVE.W`/`MOVE.L` at literal offsets, `LEA` for decay,
  `EXT.L` after word-field reads.

- [ ] **Step 2: Native gate** `testsuite/toolbox/cases_event.cla`, case
  `EventXRec`: declare `EventRecord` + local extern
  `external func TbOSEventAvail(mask: word, ev: ptr): word = trap 0xA030 reg(d0: mask, a0: ev) ret d0`
  — NOTE: verify OSEventAvail's real convention in Inside Macintosh
  before trusting this line; if it is pascal-convention on this ROM, use
  `= trap 0xA030` plain and adjust. The case: fill `ev` with sentinel
  bytes, call the trap, then pass: `ev.what == 0` (null event) AND the
  peek cross-check agrees (`peekw(TbXRecAddr(ev) + 0) == ev.what`,
  offsets 0/2/6/10 spot-checked). Add runner enum row. Both lanes:
  `CLARUS_MAC_TESTS=1 go test -count=1 ./internal/mactest -run 'TestToolboxSuite' -timeout 30m`
  → 7/7 both lanes.

- [ ] **Step 3: Snapshot regen (feature boundary)** + selfhost snapshot
  tests PASS + T1 `--smoke` PASS.

- [ ] **Step 4: Commit** `feat(cg68k): extern record native storage; EventXRec toolbox gate`.

---

### Task 7: callback func — Ch13 + parser + checker + IR/shake + cprint + host proof

**Files:**
- Modify: `docs/clarus-language-reference.md` (new `### callback func`
  section in Ch13, after the extern-record section)
- Modify: `clarusc/parse.cla` (callback contextual before func),
  `clarusc/ast.cla`, `clarusc/check.cla` (signature palette, name-use
  rule), `clarusc/ir.cla` (new expr `ECbAddr(fnIdx)`),
  `clarusc/lower.cla` (decay at extern ptr args → `ECbAddr`),
  `clarusc/shake.cla:372` area (new arm: `ECbAddr` marks fnIdx reachable
  — the edge that replaces hand-rooting), `clarusc/cprint.cla` (glue
  wrapper emission + `ECbAddr` rendering)
- Modify: `internal/build/rt/rt_ext_host.inc` (invoke-test shim)
- Test: checker error fixtures; `testdata/lowlevel/callback_host.cla` +
  `.behavior` golden

**Interfaces:**
- Consumes: extern registry; pascal-convention normative rules (Ch13
  high-byte); Task 4's decay checker shape (parallel rule).
- Produces: `callback func` decl kind; checker palette (params/ret in
  bool/char/word/int/ptr, no defaults, top-level only); decay rule (name
  at extern ptr arg → `ECbAddr`; name anywhere else → error
  `callback function name can only be passed to an external function ptr parameter`;
  direct CALLS of the callback are ordinary calls, allowed); cprint
  emits per callback:

  ```c
  static pascal RET clar_cb_<name>(P1 a1, ...) { return clar_fn_<name>(a1, ...); }
  ```

  with `pascal` spelled via the existing lane macro (empty on host,
  Retro68 keyword on Mac — find the file's existing `#if` lane idiom in
  the emitted preamble and follow it), and `ECbAddr` rendering as
  `((void*)&clar_cb_<name>)`. Host shim (exact code, matching the file's
  idiom):

  ```c
  /* invokes a (host-convention) callback taking (long, void*) returning
     long -- the host-lane test seam for callback decay */
  static long rt_ext_CbInvoke(void *fn, long a, void *b) {
      return ((long (*)(long, void *))fn)(a, b);
  }
  ```

- [ ] **Step 1: Ch13 section** per the spec's Feature C: declaration
  form, signature palette, pascal-convention marshaling (cite the
  existing normative high-byte paragraph rather than restating it),
  decay rule, direct-call allowance, tree-shake note (a never-referenced
  callback shakes away), interrupt-time non-goal. `ClaruscOnly` fences.

- [ ] **Step 2: Fixtures.** Errors: callback with a `text` param →
  `callback parameter and return types must be bool, char, word, int, or ptr`;
  name used as a variable initializer → the decay-misuse diagnostic
  above; nested (non-top-level) callback → parse error. Accept/behavior
  `testdata/lowlevel/callback_host.cla`:

  ```rust
  external func CbInvoke(fn: ptr, a: int, b: ptr): int

  callback func double_it(a: int, b: ptr): int {
      pokel(b, a)
      return a * 2
  }

  func App.startCLI(args: list of string) {
      var out: int = 0
      var r: int = CbInvoke(double_it, 21, ptrOf(out))
      print(r)    // 42
      print(out)  // 21  (callback really ran and wrote through b)
  }
  ```

  (Same `ptrOf` caveat as Task 2 — use the established fixture idiom for
  a scratch ptr; `pokel` through it.)

- [ ] **Step 3: RED** (parse error at `callback`), implement, **GREEN**:
  behavior golden `42` / `21` hand-verified then blessed;
  `go test -count=1 ./internal/lowlevel ./internal/build` green.
  Shake proof: a second fixture variant declaring `double_it` but never
  referencing it must emit NO `clar_cb_double_it` in the generated C
  (assert by grepping the emitted C in the fixture harness — follow
  however lowlevel_test.go inspects emitted output; if it has no such
  hook, note it and cover shake in Task 8's listing golden instead).

- [ ] **Step 4: T1** `--smoke` PASS. **Commit**
  `feat(clarusc): callback func — parse/check/shake edge/cprint glue; host invoke proof`.

---

### Task 8: callback func — cg68k glue generation

**Files:**
- Modify: `clarusc/cg68k.cla` — new signature-driven glue emitter
  (generalizing `cgEmitLdefGlue`'s marshaling loop, 3127-3196) emitting
  one glue per `ECbAddr`-referenced callback; `ECbAddr` renders as the
  glue's JT-entry address (`LEA jtDisp(A5),A0; MOVE.L A0,D0` — the
  `cgCallExtUiGlueAddr` shape, 7132-7148); glue functions get ordinary
  JT slots
- Test: `testdata/cg68k/callback.cla` listing golden

**Interfaces:**
- Consumes: Task 7's `ECbAddr` + checker-restricted signatures; the
  normative marshaling rules (short → sign-extend; bool/char → high
  byte of the word slot, both directions; no-RTD epilogue: UNLK, pop
  return addr, clean pascal bytes, JMP).
- Produces: table-driven `cgEmitCallbackGlue(fnIdx)`; the two
  hand-rolled emitters remain in place until Task 9 (they still back the
  runtime's LDEF/action path) — do NOT delete them here.

- [ ] **Step 1: Listing golden** `testdata/cg68k/callback.cla` — the
  Task 7 behavior fixture trimmed to one callback + one decay; bless;
  eyeball the glue: LINK, per-arg A6-offset reads with correct
  widths/extensions (include a `bool` and a `word` param in the fixture
  specifically to pin the high-byte and sign-extend paths), Clarus-
  convention call, result to pascal slot, UNLK/pop/clean/JMP epilogue,
  and the `LEA (A5)`-based decay at the call site.

- [ ] **Step 2: RED** (cg68k hits `ECbAddr` unimplemented) → implement →
  golden blessed after eyeball. `go test -count=1 ./internal/cg68k
  ./internal/emitui` — 23 UI goldens still byte-identical (nothing
  routes through the new emitter yet).

- [ ] **Step 3: T1** `--smoke` PASS. **Commit**
  `feat(cg68k): callback glue emission + JT-address decay`.

---

### Task 9: Runtime migration — LDEF/action onto callback func; delete hand-rolled glue

**Files:**
- Modify: `runtime/clarus/uitable.cla` (rtUiLdefDraw → callback),
  `runtime/clarus/ui.cla` (rtUiScrollbarAction → callback; the call
  sites that pass glue addresses switch from the `UiLdefEntry`/
  `UiActionEntry` specials to plain decay)
- Modify: `clarusc/cg68k.cla` — DELETE `cgEmitLdefGlue` (3127-3196),
  `cgEmitActionGlue` (3204-3231), their doc block (3060-3113), the
  `UiLdefEntry`/`UiActionEntry` by-name specials (within 6983-7008), and
  the hand roots at 702/704; `clarusc/lower.cla:5544` hand root removed
- Modify: `runtime/mac/rt_ext_mac.inc` — the hand-written pascal
  wrappers backing the OLD path (e.g. `rt_ext_ui_scrollbar_action`'s C
  counterpart) removed once cprint emits the generated wrappers
- Test: existing frozen goldens ARE the test (23 UI scenarios + table
  scenarios byte-identical, both lanes)

**Interfaces:**
- Consumes: Tasks 7-8 complete; the existing `rtUiLdefDraw`/
  `rtUiScrollbarAction` signatures (read them first — the callback
  declarations must marshal identically to the hand-rolled glue:
  same param order, widths, and extensions, or the goldens WILL diff).
- Produces: zero hand-rolled callback glue left in the tree; the
  toolbox-suite gate C is the frozen goldens themselves.

- [ ] **Step 1: Read before writing.** Read `cgEmitLdefGlue`/
  `cgEmitActionGlue`'s exact marshaling (widths, extensions, arg order)
  and the two runtime functions' declared signatures; write the
  `callback func` forms so the generated glue is instruction-equivalent.
  MacRoman: both runtime files have high bytes — LC_ALL=C sed only.

- [ ] **Step 2: Migrate + delete** per Files. The runtime's own use of
  decay is the first in-tree consumer of the feature (fixtures aside).

- [ ] **Step 3: The gate.** `go test -count=1 ./internal/emitui
  ./internal/cg68k` byte-identical; then BOTH gated lanes full:
  `CLARUS_MAC_TESTS=1 go test -count=1 ./internal/mactest -timeout 60m`
  — all UI scenarios + table scenarios + toolbox suite green,
  zero golden diffs. If a golden diffs: the migration changed marshaling
  — fix the callback declaration/glue, never re-bless.

- [ ] **Step 4: Snapshot regen (feature boundary)** + selfhost snapshot
  tests + T1 `--smoke` PASS.

- [ ] **Step 5: Commit**
  `feat(runtime): LDEF/scrollbar-action migrate to callback func; delete hand-rolled glue emitters`.

---

### Task 10: Phase wrap — Ch13 read-through, ROADMAP, docs

**Files:**
- Modify: `docs/clarus-language-reference.md` (consistency read-through
  of every section this phase touched — one pass, fixing cross-
  references and any contradiction with as-built behavior),
  `docs/ROADMAP.md` (Toolbox integration phase outcome entry in the
  decided-sequencing block: what landed, gate evidence, the retired
  special cases/glue, pointer to spec + this plan; note the byte/char/
  bool/text review item 2b is next-but-one, after Go deletion),
  `docs/superpowers/specs/2026-08-04-toolbox-integration-design.md`
  (Outcome section: as-built deviations, if any, task by task)
- Test: full T1 + the Go-free selfhost lanes

**Interfaces:** none downstream — closes the phase.

- [ ] **Step 1: Ch13 read-through** against as-built behavior (the four
  new/amended sections + the corrected word-result sentence). Fix
  inline.
- [ ] **Step 2: ROADMAP + spec Outcome** entries with real evidence
  (case counts, golden status, deleted-code list).
- [ ] **Step 3: Verification sweep.** `scripts/test-task.sh --smoke` and
  `go test -count=1 -timeout 30m ./internal/selfhost` → PASS.
  (Full T2 runs at merge time, on Andrew's request, per convention.)
- [ ] **Step 4: Commit** `docs: Toolbox integration phase wrap`.

---

## Self-Review (done at plan time)

- Spec coverage: A (Tasks 1-2 incl. word unification + Ch13 correction +
  Gestalt retirement + native gate), dedup (Task 3, reused for xrecs in
  Task 4), B (Tasks 4-6 incl. packing table, decay, int coercion, shared
  authority, byte-array C emission, native gate), C (Tasks 7-9 incl.
  decay-as-edge shake, host-invocable proof, glue generalization,
  runtime migration as gate C, specials/roots deletion), docs (each
  feature's Ch13 task-step + Task 10), non-goals respected (no cookbook,
  no _Pack3, no runtime-wide peek/poke migration beyond the named
  EventRecord... — note: the runtime's EventRecord peek sites are NOT
  migrated, matching the spec's "adopt opportunistically" non-goal).
- Placeholders: none — fixture code verbatim; compiler-edit steps
  anchored to file:line with decided encodings; the two open
  verification points are flagged as explicit in-task actions
  (OSEventAvail's real convention; ptrOf fixture idiom), not silent
  gaps.
- Type consistency: conv 7/8, register codes, `EXRecAddr`, `ECbAddr`,
  `irXRecFieldOffset`/`irXRecSize`, `clar_xrec_<Name>`,
  `clar_cb_<name>`, diagnostic strings — each defined once and reused
  by name across tasks.
