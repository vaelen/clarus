# Clarus CLI / Self-Hosting Language Features Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement the ten reference-approved features that make Clarus capable of hosting its own compiler: `break`/`continue`, `switch`, `const`, slices, `indexOf`, `text.append`, `App.startCLI`, `log`, `quit` exit codes, and the binary-faithful file I/O guarantee — through the whole pipeline (lexer → parser → checker → lower → cprint → runtime) with goldens.

**Architecture:** The reference (commit 1ec7504) is already updated and is the normative spec for every feature — implementers read it first. `switch` desugars in LOWERING to if/else chains (no new IR statement; C `break` therefore can never mis-bind to a switch, and string switches fall out of the existing `str_cmp` path). `break`/`continue` are two new IR statements mapping to C `break`/`continue` — correct against the existing loop-printing shapes (the `while(1){cond;…}` form makes `continue` re-evaluate the condition, which is exactly the spec'd semantics). Constants lower to inline literal values at use sites — no IR declaration form. Everything else is intrinsics + runtime.

**Tech Stack:** Existing Go compiler + C99 host runtime; no new dependencies.

## Global Constraints

- **Normative spec:** `docs/clarus-language-reference.md` as amended on this branch (Ch2 keywords, Ch3 slices/indexOf/append/const, Ch5 break/continue/switch/quit, Ch7 App.startCLI event + launch-order fallback rules, Ch12 log/binary-faithfulness, Appendix A grammar, Appendix B startCLI row). Where this plan and the reference disagree, the reference wins; flag conflicts.
- Hard keywords now number 33: the 28 existing plus `const`, `switch`, `case`, `break`, `continue`.
- Diagnostic texts introduced here (exact): `break is only valid inside a loop`, `continue is only valid inside a loop`, `cannot assign to constant X`, `case label must be a constant`, `duplicate case label`, `switch operand must be int, char, enum, or string`, `slice out of range` (runtime), `slices are not assignable`.
- All existing tests, goldens, and fixtures must stay green; `internal/reftest`'s manifest is REGENERATED in Task 6 (fence indices shifted; new fences must pass once features exist — this plan is not done while reftest is red).
- gofmt/vet clean; `-std=c99 -Wall -Werror` clean; goldens deterministic.

---

### Task 1: Keywords, parser, AST for all new syntax

**Files:**
- Modify: `internal/token/token.go` (+5 Kw constants + Keywords entries + names), `internal/token/token_test.go` (33-keyword list; contextual list unchanged)
- Modify: `internal/ast/ast.go`, `internal/parser/stmt.go`, `internal/parser/decl.go`, `internal/parser/expr.go`
- Test: extend `internal/parser/stmt_test.go`, `internal/parser/decl_test.go`, `internal/parser/expr_test.go`

**Interfaces (AST additions — exact):**

```go
type ConstDecl struct { P source.Pos; Name string; Type TypeExpr; Value Expr } // Value: literal or Ident (Decl)
type BreakStmt struct{ P source.Pos }
type ContinueStmt struct{ P source.Pos }
type SwitchCase struct { P source.Pos; Labels []Expr; Body *Block } // Labels: literal or Ident exprs
type SwitchStmt struct { P source.Pos; Subject Expr; Cases []SwitchCase; Else *Block } // Else may be nil
type SliceExpr struct { P source.Pos; X, Start, Len Expr }          // Expr; s[start, len]
// QuitStmt gains: Code Expr  // nil for bare quit
```

Parsing rules (per Appendix A):
- `constDecl` wired into parseTopDecl.
- `quit [expr]`: expr only if the next token is on the same line (i.e. not NEWLINE/RBRACE — the lexer's NEWLINE token makes this trivial).
- `break`/`continue`: bare statements (validity checked by the checker, not the parser).
- `switch expr { case … }`: case bodies are nested blocks (`parseBlock`, vars disallowed — they're not function bodies); `else block` optional, must be last; zero cases with an else is legal (`switch x { else { } }` — degenerate but harmless); `case` after `else` is a parse error `expected '}'`.
- Slice: in `parsePostfix`'s `[` branch, after the first expr, an optional `, expr` produces SliceExpr instead of Index. `parseIndexAssign`/lvalue paths must NOT accept SliceExpr (`slices are not assignable` when a slice appears as assign LHS — parser or checker, implementer's choice; test it either way).

- [ ] **Step 1: failing tests.** Token test: 33 keywords. Parser tests (table style, in the existing files' idiom): const decl parses with literal + Ident values; `quit 2` vs bare `quit` (Code nil) vs `quit` at end-of-block; break/continue parse in loop bodies; switch with 2 cases (one multi-label) + else asserting shapes; slice `s[1, 3]` yields SliceExpr, `s[1]` still Index; `s[1, 2] = x` errors.
- [ ] **Step 2: RED. Step 3: implement. Step 4: GREEN**, full suite (checker will not know the new nodes yet — parser tests only exercise Parse; confirm `go build ./...` still compiles by giving checker/lower placeholder panics ONLY if required to compile — prefer exhaustive-switch default cases that already exist).
- [ ] **Step 5: Commit** — `feat: parse const, switch, break/continue, slices, quit codes`

---

### Task 2: Checker for all new semantics

**Files:**
- Modify: `internal/check/check.go` (ConstDecl), `internal/check/stmt.go` (break/continue/switch/quit-code), `internal/check/expr.go` (SliceExpr, indexOf/append method entries), `internal/check/scope.go` (Symbol gains `IsConst bool; ConstVal int64; ConstStr string; ConstIsStr bool` — or a small ConstInfo struct), `internal/check/builtins.go` (`log(string)`)
- Test: extend `internal/check/check_test.go` + `internal/check/ui_test.go` style negatives

Rules (reference chapters govern; highlights):
- **const:** initializer literal/enum-member/prior-const with type agreement; global scope only (parser already restricts position); redeclaration via existing scope error; assignment target that resolves to a const → `cannot assign to constant X`; const usable wherever its type's value is (checkIdent returns its type; record the VALUE in `check.Info` — extend Info with `Consts map[*ast.Ident]ConstVal` or reuse EnumConsts pattern; document choice).
- **break/continue:** loop-depth counter threaded through checkBlock (loops increment; switch does NOT — a break in a case body binds the enclosing loop per Ch5); outside a loop → the exact diagnostics.
- **switch:** subject type ∈ {int, char, enum, string} else `switch operand must be int, char, enum, or string`; labels checked WITH the subject's type as expected (enum members resolve); label must be literal/enum-member/const → `case label must be a constant`; label type assignable to subject; duplicate values (after const/enum resolution) → `duplicate case label`; case bodies are nested blocks (vars-at-top rule already excludes vars there).
- **quit code:** expr must be int.
- **slices:** X is string/text; Start/Len int; result `string(255)`; SliceExpr in lvalue position → `slices are not assignable` (if the parser didn't already reject).
- **indexOf:** on string/text; one arg, string or char; returns int.
- **append:** on text; one arg, string/char/text; void.
- **App.startCLI:** new events-table row: `(app, startCLI)` takes `(args: list of string)` — exactly one param of that type, validated like every other handler signature (`takes` diagnostics). There is NO App.args property; `App.args` anywhere is an `unknown event`/undefined-style error via the existing App-select path.
- **log:** builtin `log(msg: string)`.

- [ ] **Step 1: failing tests** covering every rule above, positive and negative (match the existing expectClean/expectError idiom; every exact diagnostic string from Global Constraints appears in at least one expectError).
- [ ] **Step 2: RED. Step 3: implement. Step 4: GREEN**, full suite. **Step 5: Commit** — `feat: check const, switch, break/continue, slices, CLI surface`

---

### Task 3: IR, lowering, and C printer

**Files:**
- Modify: `internal/ir/ir.go` (+`Break`/`Continue` stmts), `internal/ir/intrinsics.go` (+`IStrSlice "str_slice"`, `ITextSlice "text_slice"`, `IStrIndexOfStr "str_index_of_str"`, `IStrIndexOfChar "str_index_of_char"`, `ITextIndexOfStr "text_index_of_str"`, `ITextIndexOfChar "text_index_of_char"`, `ITextAppendStr "text_append_str"`, `ITextAppendChar "text_append_char"`, `ITextAppendText "text_append_text"`, `IArgsCount "args_count"`, `IArgsAt "args_at"`, `ILog "log"`; `IQuit` now takes one int arg)
- Modify: `internal/lower/stmt.go`, `internal/lower/expr.go`, `internal/lower/lower.go`
- Modify: `internal/cprint/funcprint.go`, `internal/cprint/intr.go`, `internal/cprint/cprint.go`
- Test: extend `internal/lower/stmt_test.go` + `internal/cprint/cprint_test.go`

Lowering rules:
- **switch → if/else chain** on a once-materialized subject temp (subject evaluated exactly once — use the existing statement-temp machinery; string subjects compare via `IStrCmp`/text via `ITextCmp` == 0; multi-label cases OR the comparisons). Document the desugar in a comment; `Break` inside a case body must still bind the enclosing LOOP after desugaring (if-chains emit no C loop/switch construct — automatic, but assert it with a test).
- **break/continue → ir.Break/ir.Continue**; printer emits `break;`/`continue;`. VERIFY against each loop shape: While (`while(1){cond-check…}` — continue re-tests condition ✓), ForRange/ForList/ForMap (C `for` — continue hits the increment ✓). Write one cprint test per loop shape asserting the emitted structure keeps this true.
- **const:** no IR decl; uses lower to IntConst/StrConst via check.Info values.
- **slices/indexOf/append:** method/expr → the new intrinsics (slice result materializes into a str255 temp like other string intrinsics).
- **App.startCLI:** lowers to Func `handler_App_startCLI` with one List-of-Str param; Program gains `HasStartCLI bool`. main() sequence becomes: `clar_init_globals(); rt_args_init(argc, argv);` then `handler_App_launch` if present; then `handler_App_startCLI(rt_args_list())` if HasStartCLI, ELSE `handler_App_startEmpty` if present (the reference's fallback rule). `rt_args_list()` returns the runtime-built `rt_list` of str255 args.
- **quit code:** `IQuit` with the int arg (default IntConst 0); host `rt_quit(int32_t)`.
- **log:** `ILog` intrinsic.

- [ ] **Step 1: failing tests** (lower: switch desugar shape incl. subject-once; break/continue nodes; slice intrinsic selection; cprint: per-loop-shape break/continue structure tests + one compile-and-run of a switch/break/const program asserting stdout).
- [ ] **Step 2: RED. Step 3: implement** (incl. `rt_quit` signature change and main() arg plumbing stubs — full runtime lands in Task 4; keep cprint emitting `rt_args_init(argc, argv)` in main and declaring the extern). **Step 4: GREEN** for everything not needing the new runtime symbols; if link failures force it, fold minimal rt stubs here and note it. **Step 5: Commit** — `feat: lower and print switch, break/continue, slices, CLI intrinsics`

---

### Task 4: Host runtime additions

**Files:**
- Modify: `internal/build/rt/rt.h`, `internal/build/rt/rt.c`, `internal/build/rtsmoke_test.go`

Additions (exact signatures; C ABI for the Task-3 printer — reconcile with what cprint actually emitted, cprint wins):

```c
void rt_str_slice(uint8_t *out255, const uint8_t *src, int32_t start, int32_t len);   /* strict bounds; panics "slice out of range" (len>255 or OOB) */
void rt_text_slice(uint8_t *out255, const rt_text *t, int32_t start, int32_t len);
int32_t rt_str_index_of_str(const uint8_t *s, const uint8_t *needle);   /* -1 if absent; empty needle -> 0 */
int32_t rt_str_index_of_char(const uint8_t *s, uint8_t c);
int32_t rt_text_index_of_str(const rt_text *t, const uint8_t *needle);
int32_t rt_text_index_of_char(const rt_text *t, uint8_t c);
void rt_text_append_str(rt_text *t, const uint8_t *s);    /* amortized growth */
void rt_text_append_char(rt_text *t, uint8_t c);
void rt_text_append_text(rt_text *t, const rt_text *src); /* src may alias t (self-append doubles) */
void rt_quit(int32_t code);                               /* replaces void version */
void rt_log(const uint8_t *s);                            /* stderr + '\n'; CR rendered as LF */
void rt_args_init(int argc, char **argv);                 /* stores argv[1..] as str255 values */
rt_list *rt_args_list(void);                              /* the stored args as a list (built once) */
```

- [ ] **Step 1:** extend the smoke test C program: slice happy/edge (start+len == length), index_of hit/miss/char, append loop (1000 appends, assert length — the amortization proof is timing-free: it must complete instantly), self-append text, args_init from a fake argv. RED (missing symbols).
- [ ] **Step 2: implement; GREEN** incl. every earlier smoke test; `-Wall -Werror` clean. One ASan/UBSan pass over the new smoke, note result.
- [ ] **Step 3: Commit** — `feat: host runtime — slices, indexOf, append, args, log, exit codes`

---

### Task 5: Goldens for every feature

**Files:**
- Create: `testdata/run/switch.cla`+`.out` (int, enum, string subjects; multi-label; else; no-match-no-else; break-inside-case-binds-loop proof), `testdata/run/breakcont.cla`+`.out` (break and continue in while + all three for forms), `testdata/run/constants.cla`+`.out` (const usage incl. as case label and in expressions), `testdata/run/slices.cla`+`.out` (string+text slices, indexOf hit/miss, building a parser-ish token scan), `testdata/run/appendperf.cla`+`.out` (append loop building a large text, length verified), `testdata/run/cli.cla`+`.out`+`.args`+`.log`+`.exit` (declares startCLI(args); echoes each arg via alert, logs a line, quits with code 4), `testdata/run/binroundtrip.cla`+`.out` (writes a text containing bytes 0, 13, 255 via writeText, reads back, verifies byte-for-byte via indexing — pins the binary-faithfulness guarantee)
- Create: `testdata/run/clifallback.cla`+`.out` (declares launch + startEmpty but NOT startCLI; run with `.args` present — proves the startEmpty fallback fires and args are ignored)
- Create: `testdata/runerr/slicerange.cla`+`.err` (`slice out of range`)
- Modify: `internal/build/golden_test.go` — harness extensions: optional `NAME.args` (whitespace-split argv), optional `NAME.log` (exact stderr), optional `NAME.exit` (expected exit code, default 0; a nonzero expected code means the harness accepts that code instead of requiring success)

- [ ] **Steps:** harness extensions first (RED via cli.cla) → fixtures with HAND-COMPUTED outputs → reconcile (semantics bug = own fix commit + report entry) → GREEN; full suite. **Commit** — `test: goldens for switch, break/continue, const, slices, append, CLI surface`

---

### Task 6: Reftest manifest regeneration + final gate

**Files:**
- Modify: `internal/reftest/manifest.go` (regenerate per the Task-1-of-backend-plan procedure: dump all fences, run driver.Check on each, rebuild CheckClean + exclusion comments)
- Modify: anything the gate surfaces.

- [ ] **Step 1:** regenerate the manifest (61 fences now). Every NEW fence from the feature sections (slices, indexOf, const, break, switch, quit-code, startCLI examples) must be evaluated: complete programs go IN CheckClean; fragments get reason comments. The four pinned programs must still pass (`TestRequiredProgramsInManifest` guards them).
- [ ] **Step 2:** full gate: `go test -count=1 ./...`, `go vet ./...`, `gofmt -l .` empty; run goldens twice (determinism); `clarus check` on testdata/valid/*.cla.
- [ ] **Step 3: Commit** — `test: regenerate reference-fence manifest for feature sections`

## Self-review notes

- `switch` on `text` subjects: the reference lists int/char/enum/**string** — a `text` subject is NOT in the list; the checker must reject it (the diagnostic already names the four). If an implementer finds the reference ambiguous here, flag it rather than widening.
- The Ch5 quit-code example uses `App.startCLI(args)` and `log(...)` — that fence becomes a CheckClean candidate in Task 6 and is the natural cross-feature smoke.
- `IQuit`'s signature change (void → int arg) touches the Task-7-era lowering of bare `quit` — bare quit lowers with IntConst 0; grep for existing IQuit uses.
