# clarusc UI Gaps Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fix widget-set Str coercion (`Body.text = "lit"` build failure) and window-scope handle-backed var construction (NULL-handle crash), per `docs/superpowers/specs/2026-07-26-clarusc-ui-gaps-design.md`.

**Architecture:** Both fixes live entirely in clarusc (`clarusc/lower.cla`, `clarusc/cprint.cla`). Gap 1 is one missing `lowCoerceStr` at the widget-set funnel. Gap 2 rides the existing `WinVarDefault`/synthesized-`opened` glue: a new intrinsic whose printer emits `cpDefaultInit`-style construction for handle-backed state fields. Zero runtime or Go-compiler changes.

**Tech Stack:** Clarus (clarusc is self-hosted — written in .cla), C bootstrap snapshot, Go test harnesses.

## Global Constraints

- The Go compiler (`cmd/clarus`, `internal/` except `internal/mactest` and — only if a harness tweak proves necessary — `internal/emitui`'s test file) is FROZEN. The fixes are clarusc-only.
- `clarusc/clarusc.c` is the committed bootstrap snapshot. After ANY clarusc/*.cla change, `TestSnapshotCurrent` fails and prints the regeneration procedure — follow it exactly, and verify the bootstrap fixed point it describes. The snapshot regen is part of the same commit as the .cla change that caused it.
- `.cla` files are MacRoman-encoded. Never use the Edit tool on files containing non-ASCII bytes (`testdata/ui/dialogs.cla` and `hscroll.cla` headers may contain typographic chars — check with `grep -P '[\x80-\xff]'` via /usr/bin/grep or python3, and use LC_ALL=C sed for byte-exact edits if so). New content must be pure ASCII.
- Host suite: `go build -o clarus ./cmd/clarus && go test ./...` (then `rm -f clarus`). Gated Mac suite: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -v` (toolchain/, macplus/ symlinks exist; LaunchAPPL blocks minutes; full suite ~3 min).
- In Task 3, NO golden may change (traces or PBMs) — byte-identical outcomes are the acceptance criterion. In Tasks 1-2 only `testdata/emitui/textwidgets.{cla,c.golden}` (and the snapshot) change.
- Commit at the end of every task with the trailers given in the dispatch.

## Investigation facts (verified 2026-07-26 — cite these, don't re-derive)

- Widget-set funnel: `lowWidgetSetAssign` at clarusc/lower.cla:1536, the raw `lowExpr(rhsAst)` at :1571; `lowAssign` routes widget LHS there at :1594-1596 BEFORE the `lowStoreStmt` that would have widened. `lowCoerceStr` (lower.cla:1233-1243) emits `ITextOfStr` (Str→Text: printer at cprint.cla:791-802 emits `rt_text_new()` + `rt_text_store`) or `IStrCoerce` (capacity clamp). Property IR types come from the same table the checker uses (`widgetRuntimeProps`, check.cla:481-491: textview.text=TextT, others strT(255)/BoolT/IntT).
- Stale comment: cprint.cla:959-964 (`IUiSetTextviewText` printer).
- Window state: `cpEmitUiStateStruct` cprint.cla:1707-1723 (decl-only, no init body — its header comment explains the zeroing premise). `cpDefaultInit` cprint.cla:1297-1338 (KText→`rt_text_new()`, KList→`rt_list_new(sizeof)`, KMap→`rt_map_new(sizeof)`, KRec→`clar_new_NAME()`; inline types get zero-init). Its three existing call sites: locals (cpEmitFunc :1390-1391), record ctors (:1470), globals (:2235).
- Defaults glue: `WinVarDefault` lower.cla:107-153; `lowPrependWinVarDefaults` :2528-2552 (explicit `on opened`); `lowSynthesizeMissingOpenedHandlers` :2786-2821 (fabricates `ui_NAME_opened`); both gated on `varDeclInit(item) != -1` today (lower.cla:2280). Defaults apply via `lowStoreStmt` (store-in-place — hence "even `var t: text = \"hi\"` crashes" pre-fix).
- Window var lowering: `DkVar` branch lower.cla:2270-2284 → `IRFieldSlot` state chain.
- State alloc: rt_ui_open `NewHandleClear` (rt_ui.c:3187-3192); OPENED event dispatch + handler-table slot already exist — no runtime change needed.
- emitui harness: `internal/emitui/emitui_test.go:102-125` — clarusc-only; emits each `testdata/emitui/*.cla` with a committed `.c.golden`, byte-compares, AND m68k-compile-checks the emission against rt_ui.h (this is the gate that would have caught gap 1). Read the test file for its golden-regeneration mechanism before assuming one.
- Existing golden reference points: `testdata/emitui/textwidgets.cla:33,38` (`Name.text = nameStr`, `Body.text = bodyText`), golden lines ~57/66 (`rt_ui_widget_set_str` / `rt_ui_widget_set_text` calls); state struct in golden shows `rt_text * cv_bodyText;` with NO construction anywhere today.
- Workarounds to unwind in Task 3: `testdata/ui/hscroll.cla` (header documents both gaps; handler-local `var body: text` + assignment from local) and `testdata/ui/dialogs.cla:110-112` (`var e: text` / `Body.text = e` standing in for the intended `Body.text = ""`, per its :37 comment).
- ROADMAP entry to update in Task 3: "Two clarusc gaps found during window-zoom-hscroll" under "Small open items".

---

### Task 1: Widget-set Str coercion

**Files:**
- Modify: `clarusc/lower.cla` (:1571 funnel), `clarusc/cprint.cla` (:959-964 comment)
- Modify: `testdata/emitui/textwidgets.cla` + regenerate `testdata/emitui/textwidgets.c.golden`
- Regenerate: `clarusc/clarusc.c` (snapshot)

**Interfaces:**
- Consumes: `lowCoerceStr(target, x)` (lower.cla:1233), the property IR type for the widget property being set (the lowering already resolves it — find where `lowWidgetSetAssign` learns the property/intrinsic to pick, and obtain the same type the checker's `widgetRuntimeProps` table assigns).
- Produces: widget-set RHS always passes through `lowCoerceStr`; Task 2 does not depend on this but touches the same files — Task 2's implementer must rebase on this task's commit.

- [ ] **Step 1: Write the failing fixture.** In `testdata/emitui/textwidgets.cla`, add to an existing handler (or a new one) a direct literal assignment: `Body.text = "from literal"`. Do NOT touch the golden yet.
- [ ] **Step 2: Run to verify it fails.** `go test ./internal/emitui -run TestEmitUI -v` (adjust -run to the actual test name after reading emitui_test.go). Expected: golden mismatch AND/OR the m68k compile-check rejecting `rt_ui_widget_set_text(..., clar_lit_N)` — capture the exact error.
- [ ] **Step 3: Fix.** In `lowWidgetSetAssign`, coerce the RHS against the property's IR type via `lowCoerceStr` before appending it to the intrinsic's arg list (the one-line shape: `tail = irExprListAppend(tail, lowCoerceStr(propType, lowExpr(rhsAst)))`). Ensure `propType` is the property's declared IR type (TextT for textview.text; strT(255) for caption/label/field/title paths) — reuse however the lowering already knows which property it is; do not hardcode a parallel table if one already exists. Rewrite the cprint.cla:959-964 comment to state the real invariant: lowering coerces Str RHS via ITextOfStr at the widget-set funnel, so a2 is always an rt_text* by construction.
- [ ] **Step 4: Regenerate the emitui golden** per the harness's mechanism; eyeball the golden diff — the new lines must be exactly the ITextOfStr pattern (`tmp = rt_text_new(); rt_text_store(tmp, ...); rt_ui_widget_set_text(..., tmp);`) and NOTHING else may change in the golden.
- [ ] **Step 5: Snapshot + fixed point.** Run `go test ./...` — `TestSnapshotCurrent` fails and prints regeneration instructions; follow them, verify the fixed point, re-run `go test ./...` to full green.
- [ ] **Step 6: Commit** (`clarusc: coerce widget-set RHS through lowCoerceStr -- Body.text = "lit" builds`).

### Task 2: Window-var construction

**Files:**
- Modify: `clarusc/lower.cla` (WinVarDefault gating, synthesis condition, glue ordering), `clarusc/cprint.cla` (new intrinsic printer), `clarusc/ir.cla` if intrinsic names are registered there (check how existing intrinsics like ITextOfStr are declared)
- Modify: `testdata/emitui/textwidgets.cla` + regenerate golden
- Regenerate: `clarusc/clarusc.c`

**Interfaces:**
- Consumes: Task 1's committed state of lower.cla/cprint.cla; `cpDefaultInit(dst, type, ...)` (cprint.cla:1297); the state-field chain (`IRFieldSlot` via lower.cla:2270-2284) and window desc metadata available to cprint (it already emits the state struct from it).
- Produces: every window with a handle-backed var gets construction as the first statements of its `opened` glue, before declared defaults, before user statements.

- [ ] **Step 1: Write the failing fixture.** In `testdata/emitui/textwidgets.cla`, add a bare handle-backed window var (`var log: text` — no initializer) and an in-place mutation in a handler (`log.append("x")`), plus a declared-default text var (`var note: text = "hi"`) to lock the construction-before-default ordering. Do not regen the golden yet.
- [ ] **Step 2: Run to verify it fails.** The emitui golden mismatch will show today's output: state fields declared, `clar_init_globals` empty, NO construction — and `rt_text_append`/`rt_text_store` against the never-constructed field. (This fixture "fails" as a golden mismatch; the crash itself is a runtime property the gated suite covers in Task 3.)
- [ ] **Step 3: Implement.** (a) New intrinsic (suggested `IUiStateDefaults`), registered wherever intrinsic names live, carrying the window instance expr; its cprint printer looks up the window's state fields and calls `cpDefaultInit` against `((clar_uistate_NAME*)rt_ui_state(inst))->cv_<name>` for each field whose type takes construction (text/list/map/rec — i.e. exactly when cpDefaultInit emits a call; inline types emit nothing). (b) In lowering: windows whose state has ANY handle-backed var get `opened` glue (widen `lowSynthesizeMissingOpenedHandlers`' condition), and both glue paths insert the intrinsic statement FIRST — before WinVarDefault assignments, which stay before user statements. Follow the existing WinVarDefault code shape; do not invent a second mechanism.
- [ ] **Step 4: Regenerate the golden**; eyeball: synthesized/prepended opened glue now opens with `... = rt_text_new();` for `log` and `note`, then `rt_text_store(...note..., "hi")`, in that order; the Task-1 golden lines unchanged.
- [ ] **Step 5: Snapshot + fixed point + full host suite green** (same procedure as Task 1 Step 5).
- [ ] **Step 6: Commit** (`clarusc: construct handle-backed window vars in opened glue -- NULL-handle crash fixed`).

### Task 3: Unwind workarounds + ROADMAP

**Files:**
- Modify: `testdata/ui/hscroll.cla` (direct window text var + literal assignment; header comment rewrite), `testdata/ui/dialogs.cla` (`Body.text = ""`; comment updates)
- Modify: `docs/ROADMAP.md`

**Interfaces:**
- Consumes: Tasks 1-2 merged behavior.
- Produces: shipped gated scenarios exercising both fixed shapes; ROADMAP current.

- [ ] **Step 1: MacRoman check** both .cla files (`/usr/bin/grep -P '[\x80-\xff]'`); use byte-safe editing if hits.
- [ ] **Step 2: Unwind.** hscroll.cla: restore a window-scope `var body: text`-style shape and assign the long literal directly to `Body.text` in `opened` (keep the SAME literal text byte-for-byte so rendering is unchanged); rewrite the header paragraphs that document the two workarounds to instead document that these shapes are exercised deliberately (they regression-cover the clarusc-ui-gaps fixes). dialogs.cla: replace the `var e: text` + `Body.text = e` block with the intended `Body.text = ""`, update its comments.
- [ ] **Step 3: Run the affected gated scenarios first** (`-run 'TestHscroll|TestDialogs'`), then the FULL gated suite, then the host suite. Acceptance: every trace and PBM golden byte-identical (`git status` clean of testdata/). Any golden diff = regression; investigate, do not rebless.
- [ ] **Step 4: ROADMAP.** Replace the "Two clarusc gaps found during window-zoom-hscroll" item with a short DONE note (fixed on clarusc-ui-gaps, date), and add under Small open items: "Handle-backed window vars are constructed at open but never freed at close (runtime-wide leak-by-design, rt_mac.c:479-484); per-instance and unbounded across open/close cycles — revisit if real apps cycle document windows heavily."
- [ ] **Step 5: Commit** (`tests+roadmap: exercise fixed widget-set/window-var shapes directly; record close-leak deferral`).

### Task 4: Final review (main session)

- [ ] Full host + gated suites green at HEAD.
- [ ] Whole-branch review (most capable model), fix wave if needed.
- [ ] Hold for Andrew's merge decision.
