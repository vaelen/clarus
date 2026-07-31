# Native 5e — UI Runtime Port Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Port `runtime/mac/rt_ui.c` (5,723 lines) to Clarus (`runtime/clarus/ui*.cla`) so UI apps build and boot on the native cg68k backend, gated on the existing 23 UI scenario goldens — one golden set, strict, per `docs/superpowers/specs/2026-08-01-native-5e-ui-runtime-design.md` (read it first; it is the authoritative design).

**Architecture:** Stage 0 (Tasks 1–4): carried 5d compiler fixes + the `word` extern apparatus. Machinery (Tasks 5–6): flat pointer-free UI descriptor blob + synthesized dispatcher functions, behind a temporary `--uiport` emit flag. Port (Tasks 7–10): rt_ui.c ported in four slices, each verified scenario-graded on the Retro68 lane under `--uiport` against untouched goldens. Flip (Task 11): ported UI becomes cprint's only path; flag deleted; all 23 goldens byte-identical. Native (Tasks 12–14): cg68k UI wiring + pascal glue, app68k resource parity, native gate. Wrap (Task 15).

**Tech Stack:** Clarus (clarusc/*.cla compiler + runtime/clarus/*.cla), C99 shims (`runtime/mac/rt_ext_mac.inc`), Go test harnesses (`internal/mactest`), Mini vMac via LaunchAPPL.

**Session-cold context (executor: read before Task 1):**
- `CLAUDE.md` (conventions, Mac toolchain, idle-lock caveat)
- `docs/superpowers/specs/2026-08-01-native-5e-ui-runtime-design.md` (this plan's spec, incl. its "Plan-time adjudications" section)
- `docs/superpowers/specs/2026-07-30-native-5d-codegen68k-design.md` "Outcomes" (trap clauses, segmentation, fail-closed rule)
- `docs/clarus-language-reference.md` Ch7–13
- The four inventory reports summarized in this plan's task bodies came from direct reads of `runtime/mac/rt_ui.c`/`rt_ui.h`, `clarusc/cprint.cla`/`ir.cla`/`cg68k.cla`/`app68k.cla`, `internal/mactest/*` — cited `file:line` throughout; re-verify against the tree, line numbers drift.
- Branch: create `native-5e` from main (main at `e6fd034` or later).

## Global Constraints

- **Frozen Go compiler:** `internal/` is never modified. UI surface is clarusc-only already (the Go compiler has zero rt_ui emission); no new-syntax fixture may enter any Go-lane corpus directory (`testdata/valid|errors|run|runerr|include|diag|suite`). New-syntax homes: `clarusc/test/check_test.cla` string cases, `testdata/lowlevel/`, `testdata/emitui/`.
- **Every commit touching `clarusc/*.cla` regenerates the snapshot in the same commit:**
  ```sh
  go run ./cmd/clarus build -o /tmp/clarusc clarusc/main.cla
  /tmp/clarusc emit -o clarusc/clarusc.c clarusc/main.cla
  ```
  plus re-emitting any changed `testdata/emitui/*.c.golden` with `/tmp/clarusc emit -o <golden> <fixture>`.
- **Snapshot-first ordering:** new syntax (Task 4's `word`) must be committed with the snapshot regenerated BEFORE any runtime module using it is committed (the snapshot-built compiler must parse `runtime/clarus/ui*.cla`).
- **Bootstrap one-liner preserved:** `cc -I internal/build/rt -o clarusc clarusc/clarusc.c internal/build/rt/rt.c`. New Mac-side C goes in `runtime/mac/rt_ext_mac.inc` (included from `rt_mac.c:414`) — never a new `.c` TU.
- **clarusc's own compiler source must not USE new language features** (conservative subset).
- **No new tokens.** `word` is contextual, extern-decl-only (Task 4), the `curIsIdentText` pattern (`clarusc/parse.cla:103`).
- **MacRoman bytes:** `rt_ui.c` traces/labels contain raw MacRoman (0xC3 checkmark `rt_ui.c:1102`, 0xC9 ellipsis `:2272`, curly quotes). The Edit tool corrupts MacRoman in `.cla` files — use `LC_ALL=C sed` + byte-diff verification for any `.cla` content carrying those bytes (project memory: macroman-cla-editing).
- **Golden policy (ratified):** one golden set, strict. `testdata/ui/*.trace` and `testdata/uisnaps/*.pbm` are NEVER re-blessed in this plan. Any divergence = bug. The only blessed-artifact churn allowed: `clarusc/clarusc.c` snapshot and `testdata/emitui/*.c.golden` (mechanical, emitted-C shape).
- **Fail-closed rule (5d):** every new cg68k arm and every ported ui.cla dispatch arm handles unknown shapes with a named log+quit, never a silent zero/no-op/skip.
- **Port discipline contracts preserved verbatim:** the PORT DISCIPLINE RULE (`rt_ui.h:271-284` — GetPort/SetPort self-assert + restore in every entry point that draws), RTUI_TE_MAX=32000 clamp + lasterr (`rt_ui.h:126-131`), table `rows` double-indirection re-read (`rt_ui.h:250-267`), trace vocabulary byte-exact (`rt_ui.c:373-382`). Each stage's review checks rt_ui.c's contract comments (inventoried per task below) survived as comments/checks in the port.
- **Gates:** `go test ./... -timeout 30m` green before every commit. Mac-gated runs: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run <pattern> -timeout 60m`. LaunchAPPL runs in background (blocks until app quits).
- Commits end with the project's Co-Authored-By/Claude-Session trailers (copy from `git log -1 --format=%B`).

## The UI descriptor blob (normative for Tasks 5, 7–10, 12)

One flat, pointer-free byte blob per program, built by a single backend-neutral builder module (`clarusc/uiblob.cla`) from the IR descs (`ir.cla:287-584`), so both backends emit identical bytes by construction. cprint prints it as `static const unsigned char clar_ui_blob[]`; cg68k pours the same bytes into the constant pool (`cg68k.cla:6549-6567`, the reserved third-family slot). All integer fields are **big-endian int32 at 4-byte-aligned offsets**; strings are Str255 (len byte + bytes) in a trailing string-pool section, referenced by byte offset from blob start; `-1` = absent. ui.cla reads it exclusively through `uidesc.cla` accessor functions (`peekl`/`peekb` over blob base + offset).

Sections (header carries counts + section offsets):

- **Header** (11 int32): magic `0x434C5549` ('CLUI'), version 1, nWins, winsOff, nMenus, menusOff, nMenuHandlers, mhOff, nEvery, everyOff, appOff.
- **Window** (12 int32 each): nameOff, titleOff, w, h, resizable, minW, minH, nWidgets, widgetsOff, stateSize, handlerMask (bit i = RTUI_EV_i handler present; bit 8 = releaseVars needed), formOff.
- **Widget** (13 int32): kind (RTUI_* numeric), nameOff, captionOff (caption-fallback rule from `cprint.cla:4508-4524` applied at build time), atKind, x, yIsBottom, y, widthIsFill, width, fillBoth, flags (default|cancel|buffered|scrollV|scrollH bits 0–4), eventMask (bit i = RTUI_WEV_i handler present), tableOff.
- **Menu** (5): nameOff, titleOff, nItems, itemsOff, isStandardEdit. **Item** (4): nameOff, labelOff, key, separator.
- **MenuHandler** (6): menuIdx, itemIdx, handlerIdx (flat dispatch index), scopeWinIdx, menuNameOff, itemNameOff (trace needs the names, `rt_ui.c:419-424`).
- **Every** (1): ticks. (Fire index = array position.)
- **App** (4): nameOff, versionOff, authorOff, aboutOff.
- **Form** (3): layoutOff, nBinds, bindsOff. **Bind** (2): widgetIndex, fieldIndex.
- **Layout** (2 + n×6): recSize, nFields; per field: ftype, offset, strCap, enumCount, enumLabelsOff (contiguous int32 offsets to Str255s), enumValuesOff (contiguous int32s).
- **Table** (4): rowsIdx (argument for the `UiTableRows` extern below), layoutOff, nCols, colsOff. **Col** (4): headerOff, widthPx, widthFill, fieldIndex.
- **String pool**: Str255s, byte-packed, blob padded to 4-byte multiple.

`stateSize` is now **compiler-computed** (cg68k record layout rules — 2-byte element padding, the 5d LAYOUT AUTHORITY). On the cprint lane the emitted `clar_uistate_<Win>` C struct must agree with it: cprint emits a compile-time assert per window under `--uiport`:
`typedef char clar_ui_szassert_<Win>[(sizeof(clar_uistate_<Win>) == <N>) ? 1 : -1];`

## The reverse waist (normative for Tasks 6, 7–10, 12)

ui*.cla declares these `external func`s; they are **program-emitted** — clarusc synthesizes their bodies per program at the IR level (`lower.cla`), so both backends compile them as ordinary functions (no per-backend dispatcher emission). Resolution is by name at codegen/emission time (the `nat_` fallback precedent, `cg68k.cla:5252`):

- `UiProgDesc(): ptr` — blob base address (cprint: `&clar_ui_blob[0]`; cg68k: `LEA pool-label`).
- `UiFireWinEvent(winIdx: int, inst: ptr, ev: int, a: int, b: int)` — switch (winIdx, ev) → handler IRFunc, arg shapes per `cprint.cla:5084-5125` (closeRequest passes `a` as the cancel-flag address; accepted passes `a` as the scratch-record address; key passes the char in `a`).
- `UiFireWidget(winIdx: int, inst: ptr, widgetIdx: int, ev: int, a: int, b: int)` — switch per `cprint.cla:5126-5182` (canvas gets (x,y), table gets (row), others zero-arg).
- `UiFireMenu(handlerIdx: int, frontInstOrNil: ptr)`, `UiFireEvery(idx: int)`, `UiReleaseVars(winIdx: int, inst: ptr)`, `UiFireLaunchDoc(path: ptr)`, `UiFireStartEmpty()`, `UiFireAppLaunch()`.
- `UiTableRows(rowsIdx: int): ptr` — address of the program's `rt_list*`-holding global for table rowsIdx (double indirection preserved: ui.cla re-reads through it every draw).
- `UiStateDefaults(winIdx: int, inst: ptr)` — per-window state-field construction (existing IUiStateDefaults semantics, `cprint.cla:2458-2470`).

Per-backend glue externs (NOT synthesized; resolved per backend):
- `UiLdefEntry(): ptr`, `UiAeEntry(which: int): ptr` (which = 0 oapp / 1 odoc / 2 pdoc / 3 quit), `UiActionEntry(): ptr` — pascal-convention code addresses the Toolbox calls back into. cprint: C `pascal` wrappers in `rt_ext_mac.inc` calling the ported ui.cla functions. cg68k: emitted pascal-entry glue stubs, each with a JT slot; the extern emits `LEA <jtDisp(slot)>(A5),A0` — the jump-table entry (at +2) is the callable address, valid from any segment (Task 12).
- `UiCurrentA5(): ptr` — cg68k: `= inline a5` (new tiny inline form, Task 12); cprint shim: `(void *)SetCurrentA5()` equivalent. Needed for qd-globals access (snap reads `qd.screenBits`, `rt_ui.c:4326-4344`).
- `UiTestEmit(s: str)` — capture-line hook; cprint shim → `rt_test_emit` (`rt_mac.c:160`), no-op unless `RT_MAC_TEST`; native → `natWriteBytes`+newline.
- `UiTestScript(): ptr` — event-script bytes; cprint shim returns `rt_ui_test_script` (weak/strong link trick unchanged, `rt_ui.c:4043`); native returns the `--events`-embedded pool blob (Task 12), empty string when absent.

---

### Task 1: cg68k — discarded handle-returning call-statement leak (5d final-review T13)

**Files:**
- Modify: `clarusc/cg68k.cla` (`cgCallFnScalar` ~:4969-4987; `cgStmt` SExprStmt arm ~:6255-6258; the `cgDiscardExprIdx` mechanism doc ~:479-487)
- Test: `testdata/lowlevel/` new fixture `arc_discard_call.cla`; `internal/mactest/native_test.go` (existing host-compare pattern ~:162)
- Regenerate: `clarusc/clarusc.c`

**Interfaces:**
- Consumes: `cgDiscardExprIdx` (`cg68k.cla:488`), `cgNewTrackedTmp` (`:1892`), `cgNeedsRelease`, `cgFreeStmtTmps` (`:1923`), `cgRetNeedsHidden` (`:2678`).
- Produces: no new names — a bare `ECallFn` statement whose return `cgNeedsRelease` now stores D0 into a tracked temp so the end-of-statement flush releases it.

- [ ] **Step 1: Write the failing fixture** `testdata/lowlevel/arc_discard_call.cla`: a function returning a fresh `text` (and one returning `list of int`), called as bare statements in a loop (≥3 iterations), then print a sentinel. Host lane leak gate (`internal/lowlevel`, strict ledger) must show the leak is real BEFORE the fix: run `CLARUS_MEM_STRICT=1 CLARUS_MEM_PARANOID=1 go test ./internal/lowlevel -run <fixture>` — expected: PASS on host (cprint already releases via its own statement-temp machinery). The failing signal is native: this is a native-only leak, so the pre-fix evidence is by inspection of the listing — build with `emit68k --listing` and confirm no `cg_release_` call follows the `BSR` for the discarded call.
- [ ] **Step 2: Implement.** In `cgCallFnScalar`, when the call expression `e == cgDiscardExprIdx and cgNeedsRelease(retType)`: allocate `off = cgNewTrackedTmp(retType)` and store D0 there after the call (mirror `cgIntrListPopLike`'s shape at `:3955`). The statement-level `cgFreeStmtTmps` flush then releases it — no other changes.
- [ ] **Step 3: Verify in the listing:** rebuild the fixture with `--listing`; confirm the discarded call's result is stored to a frame slot and a `cg_release_text`/`_list` JSR appears before the statement boundary.
- [ ] **Step 4: Full suite:** `go test ./... -timeout 30m` green (host lanes unchanged); if the Mac toolchain is available, boot the fixture: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestNativeStrContainers -timeout 60m` still green.
- [ ] **Step 5: Snapshot + commit** `"cg68k: release discarded handle-returning call-statement results (T13)"`.

---

### Task 2: cg68k — whole-fixed-array assignment block-copy (5d final-review C1)

**Files:**
- Modify: `clarusc/cg68k.cla` (`cgStmt` SAssign catch-all `:6285-6299`; uses `cgExprAddr` `:2736`, `cgBlockCopy` `:4737`)
- Test: `testdata/lowlevel/arr_whole_assign.cla` (new — no corpus file exercises the shape today; the fixture is part of the fix)
- Regenerate: `clarusc/clarusc.c`

**Interfaces:**
- Consumes: `cgExprAddr` (EVarRef/EFieldRef/EIndexRef + materialize fallback), `cgBlockCopy`, `cgSlotSizeOf`, the KArr element-padding layout (2-byte padded elements — both sides of the copy share it, so a raw byte copy is correct).
- Produces: SAssign handles `dstKind == KArr` for `EVarRef`/`EFieldRef`/`EIndexRef` destinations via address+block-copy of the array's full padded size. The catch-all log+quit REMAINS for any other shape (fail-closed rule).

- [ ] **Step 1: Write the failing fixture** `arr_whole_assign.cla`: `arr 4 of int` and `arr 3 of char` — whole-array `b = a`, `r.field = arrVar`, mutate `a` after, assert `b` kept the copy (Ch3 copy-by-value). Include an array-of-record if `arr N of Rec` is legal per the reference; if not, note it in the fixture comment.
- [ ] **Step 2: Verify current fail-closed behavior:** `emit68k` the fixture — expected: build fails with the named `"whole fixed-array assignment unsupported natively"` message (`cg68k.cla:6298`). Host lane: `go test ./internal/lowlevel -run arr_whole_assign` PASSES (cprint already copies).
- [ ] **Step 3: Implement** the `KArr` arm ahead of the catch-all: `cgExprAddr(src)` → stash, `cgExprAddr(dst)`, `cgBlockCopy` of the array's padded byte size. Watch the A0/A1-across-call clobber lesson (ROADMAP 5d "hard-won lessons") — both addresses must be materialized without an intervening JSR.
- [ ] **Step 4: Native boot compare:** `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestNativeSmoke -timeout 60m` green; add the fixture to the host-compare list in `native_test.go` (pattern at `:115-136`) and run it.
- [ ] **Step 5: Full suite, snapshot, commit** `"cg68k: whole fixed-array assignment via block copy (C1) + fixture"`.

---

### Task 3: fpUiEditStmt kind==2/3 — redirect to ported list/map

**Files:**
- Modify: `clarusc/cprint.cla` (`fpUiEditStmt` `:2636-2661`)
- Test: existing `testdata/emitui/*.c.golden` (mechanical churn expected), `internal/selfhost` snapshot test
- Regenerate: `clarusc/clarusc.c`, changed emitui goldens

**Interfaces:**
- Consumes: `cpListPorted`/`cpMapPorted` (unconditional since 5b, `cprint.cla:112/119`), ported `clar_fn_rtListAt`, and the map arm's existing `cpStrPorted` conditional (`:2654`).
- Produces: kind==2 emits `clar_fn_rtListAt(lst, idx)` instead of `rt_list_at(...)`; kind==3 emits the ported map get-with-default composition instead of `rt_map_get_dv(...)` — check `runtime/clarus/map.cla` for the exact ported name (`rtMapGetDv` if it exists; if only compositional pieces exist, compose get+default exactly as `rt_map_get_dv`'s C body does — read `internal/build/rt/rt_core.inc`'s definition first and mirror it).

- [ ] **Step 1: Locate the ported equivalents** in `runtime/clarus/list.cla`/`map.cla` (`rtListAt` exists — 5c′ ported it; map-side get-dv needs verification). Record exact names/signatures in the task report.
- [ ] **Step 2: Redirect both arms**, preserving the documented single-evaluation invariant for idx/key (`cprint.cla:2605-2610`) — the temp discipline must not change.
- [ ] **Step 3: Re-emit goldens + snapshot;** diff `testdata/emitui/*.c.golden` — churn must be exactly the two call-site spellings, nothing else.
- [ ] **Step 4: Retro68 spot-check:** `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestFormeditUIScenario|TestBookmarksUIScenario' -timeout 60m` — goldens byte-identical (these two scenarios exercise edit-into-list/map).
- [ ] **Step 5: Full suite, commit** `"cprint: fpUiEditStmt kind 2/3 arms redirect to ported list/map"`.

---

### Task 4: `word` extern param/return type — 16-bit pascal marshaling

The Toolbox UI surface is pascal-stack with INTEGER (16-bit) args everywhere; today `cgCallExtPascal` (`cg68k.cla:5163-5211`) pushes every int as `.L` and has no word form. This task adds the apparatus; the first real trap using it lands in Task 7.

**Files:**
- Modify: `clarusc/parse.cla` (`parseExternFuncDecl` `:1310-1385`), `clarusc/ast.cla` (extern param schema), `clarusc/check.cla` (`checkExternFunc` `:1780-1841`), `clarusc/cprint.cla` (extern shim prototypes/calls — `word` params emit C `short`), `clarusc/cg68k.cla` (`cgCallExtPascal`; `cgCallExtReg`/`cgCallExtNatFallback` treat `word` as int)
- Modify: `docs/clarus-language-reference.md` Ch13 (extern grammar: `word` in extern params/returns; semantics: int-compatible, 16-bit at the trap boundary, results sign-extended)
- Test: `clarusc/test/check_test.cla` cases; `internal/asm68k` listing-level encodings for the new push/pop shapes
- Regenerate: `clarusc/clarusc.c`

**Interfaces:**
- Consumes: contextual-identifier pattern, conv encoding (0–4), the existing bool/char `.W` push (`cg68k.cla:5183-5186`) and byte-result pop (`:5203-5208`).
- Produces: `word` accepted ONLY in `external func` param/return type position (contextual; elsewhere `word` stays an ordinary identifier). Checker treats it as int (callers pass int exprs; a `word` return reads as int). Marshaling: pascal push `MOVE.W D0,-(A7)`; pascal result reserve `CLR.W -(A7)`, pop `MOVE.W (A7)+,D0; EXT.L D0` (INTEGER is signed — e.g. `LAddRow`'s row number); reg/nat conventions treat it exactly as int. cprint shims declare the param/return as C `short`.

- [ ] **Step 1: Failing checker cases** in `check_test.cla`: clean decl `external func UiMoveTo(h: word, v: word) = trap 0xA893`; clean `external func UiFindWindow(pt: int, wpOut: ptr): word = trap 0xA92C`; error case `var x: word` → ordinary "undefined" (word means nothing outside externs); error `word` param on a non-extern func → parse/check error. Run to verify FAIL.
- [ ] **Step 2: Implement parse/ast/check** per Produces. Run checker cases to PASS.
- [ ] **Step 3: cg68k marshaling + asm68k oracle:** implement the pascal `.W` push and word-result pop; add `internal/asm68k` cases asserting the exact encodings of the new sequences (vasm round-trip already covers the opcodes; the new tests pin the SHAPES). Also assert in a listing-level test that a `word` arg emits `MOVE.W` not `MOVE.L`.
- [ ] **Step 4: cprint shim shape:** a `word` extern param prototypes as `short` in the emitted `rt_ext_` call and declaration. Emit a `testdata/emitui/`-style fixture golden if extern decls appear in any existing golden path; otherwise the check_test cases suffice.
- [ ] **Step 5: Reference Ch13 section, full suite, snapshot, commit** `"clarusc: word extern type — 16-bit pascal trap marshaling"`.

---

### Task 5: UI descriptor blob — shared builder + cprint `--uiport` emission

**Files:**
- Create: `clarusc/uiblob.cla` (backend-neutral builder: IR descs → `list of int` byte stream, exactly the format in this plan's blob section)
- Modify: `clarusc/main.cla` (new `--uiport` flag on `emit`, threaded to cprint; flag parse beside `--rtdir` `:326-340`), `clarusc/cprint.cla` (under `--uiport`: emit `clar_ui_blob[]` + per-window `sizeof` asserts; old descriptor emission unchanged when flag off)
- Test: `testdata/emitui/uiblob_probe.cla` (new fixture: 2 windows — one with widgets of every kind, one form window — 2 menus incl. standard edit, 1 every, app section, table+form binds) + `uiblob_probe.blob.golden` (raw blob bytes) + a Go-side decode test `internal/emitui` (or the existing emitui harness location) that parses the golden against the format spec
- Regenerate: `clarusc/clarusc.c`

**Interfaces:**
- Consumes: `IRWindowDesc`/`IRWidgetDesc`/`IRMenuDesc`/`IRMenuItemDesc`/`IRMenuHandlerEntry`/`IREveryEntry`/form/table/col IR (`ir.cla:287-584`), caption-fallback rule (`cprint.cla:4508-4524`), cg68k record-layout sizing for stateSize.
- Produces: `uibBuild(): list of int` (byte values 0-255) + `uibStateSize(winIdx): int`; cprint's `cpEmitUiBlob()` prints the bytes; index conventions (winIdx = window section order; handlerIdx = MenuHandler section order; every fire index = Every section order) — Tasks 6/7/12 consume these exact conventions.

- [ ] **Step 1: Write the fixture + a hand-computed golden header** (first 44 bytes: magic/version/counts/offsets) as the failing test; run to verify FAIL (no builder yet).
- [ ] **Step 2: Implement `uiblob.cla`** per the normative format. stateSize via cg68k's layout rules (2-byte element padding) — factor the sizing walk so cg68k and uiblob share one function if trivially possible; otherwise mirror with a comment cross-linking both sites.
- [ ] **Step 3: Bless the full blob golden; write the Go decode test** that walks every section/offset of the golden and re-derives the string-pool references (structural validation, not just byte-compare).
- [ ] **Step 4: cprint emission under `--uiport`:** `clar_ui_blob[]` + `sizeof` asserts; verify a `--uiport` emit of the fixture compiles under Retro68 gcc (compile-check only, the emitui pattern). Default-flag emits byte-identical to before (goldens untouched).
- [ ] **Step 5: Full suite, snapshot, commit** `"clarusc: UI descriptor blob builder + --uiport emission"`.

---

### Task 6: Synthesized dispatchers + reverse-waist externs (cprint side)

**Files:**
- Modify: `clarusc/lower.cla` (synthesize the dispatcher IRFuncs from the IR desc/handler tables when `--uiport`; near the existing handler lowering `lower.cla:4190-4520`), `clarusc/main.cla` (flag threading), `clarusc/cprint.cla` (resolve the synthesized names + `UiProgDesc` under `--uiport`; suppress old `clar_ui_winevent_*`/`clar_ui_widget_*`/handler-array/desc-table emission under the flag)
- Modify: `runtime/mac/rt_ext_mac.inc` (shim stubs for `UiTestEmit`/`UiTestScript`/`UiCurrentA5` — the glue-entry shims land with their stages)
- Test: extend `testdata/emitui/uiblob_probe.cla` golden family with a `--uiport` emitted-C golden (`uiblob_probe.uiport.c.golden`) pinning the synthesized dispatcher shapes
- Regenerate: `clarusc/clarusc.c`

**Interfaces:**
- Consumes: blob index conventions (Task 5), handler IRFunc names (`ui_<Win>_<event>`, `ui_every_<N>`, `lower.cla:4372/4417/4520`), dispatch arg shapes (`cprint.cla:5084-5182`).
- Produces: synthesized IRFuncs named `clar_ui_fire_winevent`/`_widget`/`_menu`/`_every`/`_releasevars`/`_launchdoc`/`_startempty`/`_applaunch`/`_staterows`/`_statedefaults` (exact spellings recorded here; ui.cla's externs `UiFireWinEvent` etc. resolve to them by a name-mapping table in one place in lower.cla). Empty-body synthesis when a program has no handler of a class. `UiTableRows` synthesized returning `&<global>` per table (address-of-global IR shape — verify `EVarRef`-address lowering exists for globals; it does for cg68k via `LEA d16(A5)` and for cprint via `&cv_<name>`).

- [ ] **Step 1: Failing golden:** hand-write the expected dispatcher C for the probe fixture's window 0 (switch shape, arg casts per the shapes above); run `--uiport` emit; FAIL (not emitted yet).
- [ ] **Step 2: Implement synthesis in lower.cla** (ordinary IRFuncs — both backends compile them with zero backend-specific dispatcher code). Fail-closed: an index out of range in any synthesized switch calls the panic path, not fall-through.
- [ ] **Step 3: Wire cprint resolution + suppression** of the legacy descriptor/dispatcher emission under the flag (legacy path byte-identical when flag off — assert via untouched emitui goldens).
- [ ] **Step 4: Bless the uiport golden; full suite, snapshot, commit** `"clarusc: synthesized UI dispatchers + reverse-waist externs (--uiport)"`.

---

### Task 7: Port slice A — core: event loop, windows, menus, every, launch, basic widgets, trace/scripted/snap

The largest task; it produces the first bootable ported UI program. Port target: rt_ui.c Stage-1 + Stage-2 function inventory (event loop/windows/menus/every/AE-launch: `rt_ui.c:334-799, 2198-2384, 2483-2537, 2623-2656, 2760-3096, 3421-3751, 3806-4029, 4467-5337`; buttons/checks/labels/canvas + layout: `:725-926, 1175-1213, 2122-2196, 2678-2758, 3099-3141, 5339-5723` — canvas ops, gray patterns, fire_widget; trace + scripted interpreter + snap: `:373-673, 4043-4464`). The C stays untouched in-tree.

**Files:**
- Create: `runtime/clarus/ui.cla` (core: startup/run/event dispatch/windows/menus/every/quit/launch + winst instance management), `runtime/clarus/uiwidgets.cla` (layout engine + button/check/label/canvas + property get/set surface), `runtime/clarus/uidesc.cla` (blob accessors + winst field-offset constants), `runtime/clarus/uiscript.cla` (trace helpers + scripted-event interpreter + snap)
- Modify: `clarusc/main.cla` (`--uiport` splices the ui modules + sets `cpUiPorted`; manifest block `:479-585` — ui modules AFTER map.cla, before ser.cla is fine; record actual order chosen), `clarusc/cprint.cla` (under `--uiport`: UI intrinsic arms (`:2433-2660`) redirect `rt_ui_*` → ported `clar_fn_rtUi*` names; `cpEmitUiMain` calls ported startup/launch/run), `runtime/mac/rt_ext_mac.inc` (Toolbox wrapper shims for every extern this slice declares; AE pascal wrappers; `UiAeEntry` cprint-side)
- Modify: `scripts/build-mac.sh` (when `CLARUS_UIPORT=1` env: pass `--uiport` to emit, drop `rt_ui.c` from the generated CMake source list — `alert.r`/`rt_mac.c`/events.c unchanged)
- Test: `internal/mactest/ui_test.go` — factor `runUIScenarioSrc` (`:102-153`) so the build step is a parameter; add a ported-lane runner gated on `CLARUS_UIPORT=1` reusing lines 111–152 verbatim
- Regenerate: `clarusc/clarusc.c`

**Interfaces:**
- Consumes: blob accessors (Task 5 conventions), reverse-waist externs (Task 6 names), `word` externs (Task 4), overlay records (5b) for EventRecord/Rect/Point/WindowRecord-fields access, `UiCurrentA5` (cprint shim only this task).
- Produces: ported public entry points named `rtUiStartup`, `rtUiRun`, `rtUiLaunch`, `rtUiOpen(winIdx): ptr`, `rtUiClose(inst)`, `rtUiQuit`, `rtUiFront(winIdx): ptr`, `rtUiState(inst): ptr`, `rtUiSetTitle`/`rtUiGetTitle`, `rtUiWidgetSetStr/GetStr/SetBool/GetBool/SetInt/GetInt/SetText/GetText`, `rtUiMenuEnable`, canvas ops `rtUiCanvas*` — one ported function per `rt_ui.h` entry the cprint intrinsic arms call (`cprint.cla:2433-2584` table). Tasks 8–10 add their families to these same modules. The winst layout (uidesc.cla constants) mirrors `rt_ui.c:281-327` field-for-field.
- Widget kinds NOT ported this slice (field/textview/popup/table) hit a named log+quit arm in make-widgets/update/click dispatch (fail-closed; removed as Tasks 8–9 land).

**Porting rules (apply to Tasks 7–10, stated once):**
- Every rt_ui.c contract comment inventoried for the slice lands as a comment or check in the port (reviewer gate). Trace strings byte-exact — build via str concat + `numToStr`; MacRoman bytes via the sed discipline.
- Str255 buffers: Clarus `str` IS Str255-layout — pass addresses via existing extern str marshalling.
- 4-byte Toolbox by-value structs (Point/Cell) are `int` extern params (packed v/h); Rect/EventRecord/SFReply by `ptr` + overlay.
- Toolbox record pokes (`windowKind`, `contrlRfCon`, TERec fields…) via overlay records at Inside-Mac-documented offsets; each offset cited to the rt_ui.c line it mirrors.
- The `(long)(now - due) < 0` tick-wraparound comparison (`rt_ui.c:3708`) ports as-is (int arithmetic wraps identically).
- No function pointers anywhere: every dispatch through blob indices + reverse-waist externs.

- [ ] **Step 1: Toolbox extern block** in ui.cla/uiwidgets.cla for this slice's routines (Stage-1+2 Toolbox inventory: Window/Menu/Event/QuickDraw/Control-basics/AE/Gestalt/etc.), each with its trap word from Inside Macintosh (pascal unless the routine is a register-based OS trap), `word` params where INTEGER. Add the matching `rt_ext_` one-liner wrappers to `rt_ext_mac.inc`. Compile-check: `--uiport` emit of `uiblob_probe.cla` compiles under Retro68 gcc.
- [ ] **Step 2: Port uidesc.cla + winst management + rtUiStartup/rtUiOpen/layout + basic widget creation**; then rtUiRun's real event loop + update/activate/mouse/key dispatch; menus + every + quit cascade; launch (AE path via `UiAeEntry` glue with C pascal wrappers this lane). Port slice's contract comments carried over.
- [ ] **Step 3: Port uiscript.cla** (trace vocabulary `:373-673`; interpreter verbs `:4367-4464`; snap via `UiCurrentA5`→qd walk, rowBytes==64 assert, 21,888-byte hex dump; virtual ticks; answer queue SHELL only — dialog answers arrive in Task 10, popup answers Task 9; unknown verb = log+quit).
- [ ] **Step 4: First ported boot:** `CLARUS_UIPORT=1 CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestButtonsUIScenario -timeout 60m` — trace byte-identical to `testdata/ui/buttons.trace`. Debug loop: divergent trace lines name the divergent code path; the C oracle is `rt_ui.c` at the cited lines.
- [ ] **Step 5: Slice-A scenario subset green (ported lane):** expected set — `buttons`, `menus`, `winvar`, `zoomwin`, `canvas`, `pattern`, `hdim`, `about`, `smoke_bounce`, `smoke_menudemo`, `smoke_mandel` (+ `appres` if its surface is slice-A-only — verify its .cla). Every scenario in the set: trace AND pbm byte-identical. Any expected-set scenario needing later-slice surface: move it forward explicitly in the task report, don't skip silently.
- [ ] **Step 6: Default-lane regression:** WITHOUT the env flag, the full Retro68 UI gate is untouched (old path byte-identical): `CLARUS_MAC_TESTS=1 go test ./internal/mactest -timeout 60m` green.
- [ ] **Step 7: Full suite, snapshot, commit** (multiple commits during the task are fine — each green; final commit `"runtime: ui port slice A — core/event loop/windows/menus/canvas (+scripted harness)"`).

---

### Task 8: Port slice B — TextEdit widgets (field/textview, scrap/edit menu, scrolling, clamp)

Port target: `rt_ui.c:1211-1247, 1634-2114, 2320-2343, 2504-2520, 2560-2619, 2791-2821, 2951-2961, 3274-3283, 3355-3373, 3528-3555 (form filter excluded — Task 10), 3573-3658, 5364-5454`.

**Files:**
- Create: `runtime/clarus/uitext.cla` (TE widgets; or fold into uiwidgets.cla if under ~1,200 lines — implementer's call, record it)
- Modify: `runtime/clarus/ui.cla`/`uiwidgets.cla` (remove slice-B fail-closed arms; key-dispatch TE chain; std-edit menu dispatch; activate/update TE branches), `runtime/mac/rt_ext_mac.inc` (TE/Scrap/scrollbar trap wrappers + `UiActionEntry` C pascal wrapper)
- Regenerate: `clarusc/clarusc.c` (if clarusc/*.cla touched — main.cla manifest gains uitext.cla)

**Interfaces:**
- Consumes: slice-A winst layout (`tes/hbars/focusIdx` fields), `word` externs, `UiActionEntry` glue (scrollbar action proc — cprint C wrapper this task; native glue Task 12).
- Produces: TE creation/relayout/focus/idle/mutation-funnel/clamp (`rtUiTe*` internal names), `rtUiWidgetGetText`/`SetText` full implementations, std-edit dispatch. Contracts pinned: one mutation funnel + userEdit split (`rt_ui.c:1634-1652`), paste-overflow long math (`:2589-2601`), arrows-go-to-TEKey (`:3597-3608`), key-ordering contract (`:3573-3585`), TextWidth chunking (`:1694-1709`), clamp-drops-END disclosure (`:1772-1786`).

- [ ] **Step 1: TE/Scrap/scrollbar extern block + shims; compile-check.**
- [ ] **Step 2: Port creation/layout/focus/draw/activate/idle; then the mutation funnel + clamp + lasterr** (via existing `CoreSetLastErr` waist); then scrollbars (action proc through `UiActionEntry`); then std-edit + scrap.
- [ ] **Step 3: Slice-B scenarios green (ported lane):** `textwidgets` (incl. the 32000/32001 clamp snaps), `editmenu`, `hscroll`, `texteditor`, `texteditor_quit`, `texteditor_bigfile`, `opendoc`, `opendoc_empty` — byte-identical. The clamp scenarios are the empirical check on lasterr plumbing.
- [ ] **Step 4: Slice-A subset re-run green; default-lane spot-check** (`TestTextwidgetsUIScenario` without env flag) green; full suite, snapshot, commit `"runtime: ui port slice B — TextEdit widgets"`.

---

### Task 9: Port slice C — tables, popups, LDEF

Port target: `rt_ui.c:759-773, 928-1173, 1248-1632, 2822-2911, 3143-3323, 3374-3418, 4747-4791, 4816-4827, 5505-5539, 5569-5579`. The LDEF stub (`:1155-1173`) is built by ui.cla itself: `NewHandleClear(6)` + pokes `0x4EF9` + the 4-byte target from `UiLdefEntry()` — portable on both lanes.

**Files:**
- Create: `runtime/clarus/uitable.cla`
- Modify: `runtime/clarus/ui.cla`/`uiwidgets.cla` (remove slice-C fail-closed arms; teardown ordering; update/click table+popup lanes), `runtime/mac/rt_ext_mac.inc` (List Manager/popup-menu trap wrappers + `UiLdefEntry` C pascal LDEF wrapper), `clarusc/main.cla` (manifest)
- Regenerate: `clarusc/clarusc.c`

**Interfaces:**
- Consumes: `UiLdefEntry` (pascal LDEF with by-value Cell — the cprint wrapper unpacks and calls ported `rtUiLdefDraw(msg, select, rectPtr, cellPacked, dataOffset, dataLen, lh)`), `UiTableRows(rowsIdx)` (Task 6), ported list accessors (rows re-derived per draw — never cached, `rt_ui.c:1001-1011`).
- Produces: table create/relayout/sync/select/click/draw + popup manual lane + LDEF stub management. Contracts pinned: cellSize.h ≠ 0 (`:1370-1378`), LSetDrawingMode gotcha (`:1380-1395`), per-cell LGetSelect scan (`:1466-1477`), sync-at-end limitation (`:1584-1593`), popup-alive assert (`:3172-3183`), BOOL-is-int32 field read (`:1100`), CDEF branch stays PARKED (`:242-268` — port the gate, not the branch).

- [ ] **Step 1: LM/popup extern block + shims + `UiLdefEntry` wrapper; compile-check.**
- [ ] **Step 2: Port tables (LDEF stub + draw-field + relayout + sync + click) then popups (manual lane + answer-popup queue arm).**
- [ ] **Step 3: `popuptable` green (ported lane), byte-identical (all 3 snaps).**
- [ ] **Step 4: Slices A+B re-run green; full suite, snapshot, commit** `"runtime: ui port slice C — ListManager tables/popups/LDEF"`.

---

### Task 10: Port slice D — dialogs, StandardFile, modal forms

Port target: `rt_ui.c:344-371, 586-673, 1803-1842, 2386-2475, 2658-2746 (form intercept), 3429-3458, 3513-3555, 3611-3629, 4658-4661, 4844-4933, 4935-5273`.

**Files:**
- Create: `runtime/clarus/uidialogs.cla` (alerts/About/SF asks + gModal + fill/validate/writeback walker + parse_int/parse_fixed)
- Modify: `runtime/clarus/ui.cla`/`uiwidgets.cla` (fire_widget form intercept; close_internal carve-out; modality filter; key filter), `clarusc/cprint.cla` (`fpUiEditStmt` under `--uiport` targets ported `rtUiEdit`; `rt_ui_ask_*`/`form_is_new` intrinsic arms redirect), `runtime/mac/rt_ext_mac.inc` (SF/ParamText/Alert wrappers), `clarusc/main.cla` (manifest)
- Regenerate: `clarusc/clarusc.c`

**Interfaces:**
- Consumes: blob Form/Layout/Bind sections, slice A–C surface, `rtUiEdit(winIdx, srcPtr, isNew, wbKind, addr, lst, idx, mp, key255Ptr)` signature mirroring `rt_ui_edit` (`rt_ui.h:310-346`).
- Produces: the full modal-form lifecycle. Contracts pinned: gModal scratch-copy semantics + one-modal panic (`rt_ui.c:344-357, 5218-5226`), close-box-is-CANCEL centralized (`:3449-3458, 4844-4873` — the dangling-gModal root-cause writeup ports as a comment), typing-filter rules (`:3513-3527`), parse_fixed reverse-Horner + its Fix-round-1 bug note (`:4968-4993`), validation-failure UX (`:5027-5035`), LIST idx-out-of-range silent-skip (`:5200-5202`), answer-queue ring + overflow panic (`:586-606`).

- [ ] **Step 1: SF/dialog extern block + shims; compile-check.**
- [ ] **Step 2: Port asks (scripted answer arms + real SF path) → gModal + edit lifecycle → walker fill/validate/writeback → filters/intercepts.**
- [ ] **Step 3: Slice-D scenarios green (ported lane):** `dialogs`, `formedit`, `bookmarks` (all snaps) — byte-identical.
- [ ] **Step 4: FULL ported-lane sweep — all 23 scenarios green byte-identical:** `CLARUS_UIPORT=1 CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'UIScenario|TestUIAbout' -timeout 60m`.
- [ ] **Step 5: Full suite, snapshot, commit** `"runtime: ui port slice D — dialogs/StandardFile/forms; all 23 scenarios green on ported lane"`.

---

### Task 11: The flip — ported UI becomes cprint's only path

**Files:**
- Modify: `clarusc/main.cla` (delete `--uiport`; ui modules splice + `cpUiPorted` unconditional for UI programs), `clarusc/cprint.cla` (delete the legacy rt_ui descriptor/dispatcher/main emission arms — `cpEmitUiDescs`/`cpEmitWinHandlersFwd`/`cpEmitOneWinEventDispatcher`/`cpEmitOneWidgetDispatcher`/`cpEmitMenuHandlerArray`/`cpEmitEveryArray`/legacy `cpEmitUiMain` wiring, `cprint.cla:4298-5537` legacy halves; the intrinsic arms keep only the ported spellings), `scripts/build-mac.sh` (drop `rt_ui.c` from the link unconditionally; remove the env-flag branch)
- Test: `internal/mactest/ui_test.go` (remove the two-lane runner split — one lane again)
- Regenerate: `clarusc/clarusc.c`, `testdata/emitui/*.c.golden` (mechanical re-bless — emitted C shape changes wholesale for UI fixtures)

**Interfaces:** none new — deletion + default-flip only. `rt_ui.c`/`rt_ui.h`/`uiprobe` remain in-tree, frozen, referenced by nothing in the build (spec decision 5).

- [ ] **Step 1: Flip + delete; emitui goldens re-blessed in a dedicated commit.**
- [ ] **Step 2: THE RETRO68 GATE, one run, no env flags:** `CLARUS_MAC_TESTS=1 go test ./internal/mactest -timeout 60m` — all UI scenarios + suite/runerr/abort green; `testdata/ui`/`testdata/uisnaps` goldens byte-identical and UNTOUCHED by this branch (verify `git status` on those dirs is clean).
- [ ] **Step 3: Full suite, snapshot, commit** `"clarusc: ported Clarus UI runtime is the only cprint path; rt_ui.c retired from the app link"`.

---

### Task 12: cg68k UI — blob pool, startup wiring, pascal glue, `--events`

**Files:**
- Modify: `clarusc/cg68k.cla` (UI-program detection → emit blob into constant pool (the `:6566` reserved slot) via uiblob.cla bytes; `UiProgDesc`/`UiTestScript`/glue-entry extern resolution by name; pascal-entry glue stubs for LDEF/AE×4/action with JT slots; `= inline a5` clause form (conv 5); startup calls `rtUiStartup`/`rtUiLaunch`/`rtUiRun` for UI programs — extend `cgEmitStartup` `:1080` + `cgEmitStartupCallIfPresent` `:1041`; `cgDefaultInitAt`'s KUiState TODO arm (`:1405-1414`) implemented as NULL-init), `clarusc/main.cla` (`emit68k --events FILE` flag: read file, pass bytes to cg68k for pool embedding; `native.cla` splice-order note), `clarusc/parse.cla`+`check.cla` (`inline a5`: zero-arg, `ptr` return), `runtime/clarus/native.cla` (`nat_UiTestEmit` over `natWriteBytes`)
- Modify: `scripts/build-68k.sh` (`--events` pass-through; NAME via `clarusc appinfo` like build-mac.sh `:51-61`)
- Test: `internal/asm68k` glue-stub encoding cases; `internal/mactest/native_test.go` — `buildNative68kUI(t, name, eventsRel, claRel...)` beside `buildNativeClarusc` (`:43-73`)
- Regenerate: `clarusc/clarusc.c`

**Interfaces:**
- Consumes: uiblob bytes (identical to cprint's by construction), JT mechanics (`cgJtDisp = 32 + slot*8 + 2`, `cg68k.cla:965-983`), `a68DcB`/`a68DcBytes` pool emission, reverse-waist synthesized IRFuncs (Task 6 — compiled by cg68k as ordinary functions, zero new dispatcher code).
- Produces: **Pascal glue stubs** (the pascal byte-arg question settles HERE, empirically): each glue is an emitted function with a JT slot; entry unwinds the pascal frame per the documented layouts — LDEF `(short lMessage, Boolean lSelect, Rect *lRect, Cell lCell, short lDataOffset, short lDataLen, ListHandle lHandle)` with Boolean as a WORD whose LOW byte holds the value (verify empirically; if the high-byte placement turns out true instead, fix the push side in `cgCallExtPascal` too and record it in Ch13 — the listing + a popuptable native boot is the oracle); AE `(const AppleEvent*, AppleEvent*, long): OSErr pascal` — result word written to the callee-result slot, callee pops args (68000: pop return addr to scratch, ADDQ the arg bytes, push return addr back, RTS); action `(ControlHandle, short part)`. Each glue JSRs the ported ui.cla function through the normal call path, then returns pascal-style. Glue-entry externs resolve to `LEA <jtDisp>(A5),A0; MOVE.L A0,D0`.
- `--events`: script bytes as a NUL-terminated pool blob; `UiTestScript()` returns its address (empty blob when flag absent — scripted mode gates on first byte, mirroring `rt_ui.c:4471`).

- [ ] **Step 1: `inline a5` + glue-stub emission + asm68k listing cases** (pin the exact prologue/epilogue byte sequences; vasm round-trip green).
- [ ] **Step 2: Blob pool + extern resolutions + startup wiring + `--events`;** emit68k of `uiblob_probe.cla` produces a listing whose pool section byte-matches the cprint blob golden.
- [ ] **Step 3: First native UI boot:** `smoke_bounce` (canvas + every + close — no TE/tables/dialogs/AE) via `buildNative68kUI`; trace + both PBMs byte-identical to the existing goldens. This is the plan's highest-risk single step; budget debugging time; the Retro68-ported lane is the known-good comparator (same Clarus runtime, gcc codegen).
- [ ] **Step 4: Full suite, snapshot, commit** `"cg68k: native UI — blob pool, pascal glue, startup wiring, --events; first native UI boot green"`.

---

### Task 13: app68k resource parity

**Files:**
- Modify: `clarusc/app68k.cla` (generalize `app68BuildResourceFork` `:270-341` from hardcoded CODE+SIZE to a (type, id, data) list; new builders: ALRT/DITL 128+130 (byte-for-byte what Rez produces from `runtime/mac/alert.r` — capture once via `DeRez`/hex-dump of an existing Retro68 build and pin as goldens), ALRT/DITL 129 About (when app section), SIZE(-1) with `isHighLevelEventAware` (mirror `build-mac.sh:108-139`), `vers`, signature/`ICN#`/`BNDL`/`FREF` + doc icon (mirror `build-mac.sh:150-215`; app icon from the declared PBM — port `scripts/pbm2icn.c`'s conversion into app68k), creator code threading (`cg68WriteImage` `cg68k.cla:6652-6655` passes the real creator instead of literal `"????"`; MacBinary header field `app68k.cla:170`)), `clarusc/cg68k.cla` (hand app68k the extra-resources list; UI programs get alerts unconditionally, About/icons per app section — same rules as `build-mac.sh:81-232`)
- Test: Go byte-compare test: resources produced by app68k vs the same resources extracted from a Retro68-built `.bin` for the probe fixture (new `internal/mactest` unit test, no emulator needed)
- Regenerate: `clarusc/clarusc.c`

**Interfaces:**
- Consumes: `irHasApp`/`irApp*` (`ir.cla:562-584`), `appinfo` fields, MacBinary/fork layout already in app68k.
- Produces: `app68Build` signature gains `extraRes: list of <(type,id,data)>` — record the exact Clarus shape chosen; `TestApp68kResourceParity` golden test.

- [ ] **Step 1: Extract + pin the Rez-output resource goldens** (hex from an existing built scenario app's resource fork).
- [ ] **Step 2: Generalize the fork writer + implement the builders; golden test green.**
- [ ] **Step 3: Native boots of `about` and `dialogs`-dependent alerts now possible — spot-boot `about` natively, trace byte-identical.**
- [ ] **Step 4: Full suite, snapshot, commit** `"app68k: ALRT/DITL/SIZE/vers/icon/BNDL/FREF resource parity + real creator"`.

---

### Task 14: The native gate — all 23 scenarios on 68k

**Files:**
- Modify: `internal/mactest/native_test.go` (`TestUiScenariosOn68k` — per-scenario subtests reusing the factored golden plumbing from Task 7's harness split; same expected traces/snaps, same bless refusal: native NEVER blesses), `internal/mactest/ui_test.go` (shared helpers exported as needed)
- No compiler changes expected; fixes discovered here are bugs in Tasks 4–13's output and go back to the responsible file.

**Interfaces:**
- Consumes: `buildNative68kUI` (Task 12), the memoized `buildNativeClarusc`, `RunMac`/`parseCapture`/`parseUIOutput`/`pbmBytes` unchanged.
- Produces: the 5e end gate.

- [ ] **Step 1: Bring-up order** (smallest surface first): `smoke_bounce` (done, T12) → `buttons` → `menus` → `winvar` → `zoomwin` → `canvas` → `pattern` → `hdim` → `smoke_menudemo` → `smoke_mandel` → `about` → `appres` → `textwidgets` → `editmenu` → `hscroll` → `texteditor` → `texteditor_quit` → `texteditor_bigfile` → `opendoc` → `opendoc_empty` → `popuptable` → `dialogs` → `formedit` → `bookmarks`. Each: trace + all PBMs byte-identical. Timeout: start at 5 min/scenario (naive codegen; raise per-scenario only with a recorded reason).
- [ ] **Step 2: Record timing** per scenario (build+boot and boot-only where cheap) into the task report — the peephole/regalloc buy-back baseline, 5d's framing.
- [ ] **Step 3: THE FULL GATE, one run:** `CLARUS_MAC_TESTS=1 go test ./internal/mactest -timeout 60m` — every Retro68 test AND every native test (now incl. the 23 native UI boots) green in one run.
- [ ] **Step 4: Commit** `"mactest: native UI gate — 23/23 scenarios byte-identical on cg68k (TestUiScenariosOn68k)"`.

---

### Task 15: Wrap — docs + final review artifacts

**Files:**
- Modify: `docs/ROADMAP.md` (5e entry: outcomes, gate numbers, timing, honest limits), `docs/superpowers/specs/2026-08-01-native-5e-ui-runtime-design.md` ("Outcomes" section: as-built decisions incl. the pascal byte-order empirical result, blob format version, glue mechanism, anything adjudicated mid-flight), `docs/clarus-language-reference.md` (Ch13: `word`, `inline a5`, pascal byte-arg placement as verified — normative)
- Optional: `CLAUDE.md` build notes if build-68k.sh usage changed

- [ ] **Step 1: Write the ROADMAP 5e entry + spec Outcomes** (include per-scenario native timing table; recorded honest limits — e.g. anything still cprint-lane-only, the uiprobe/rt_ui.c frozen status).
- [ ] **Step 2: Full `go test ./... -timeout 30m` + full gated mactest run, both green, evidence in the report.**
- [ ] **Step 3: Commit** `"docs: 5e landed — native UI runtime; ROADMAP + spec Outcomes"`. Request final whole-branch review (superpowers:requesting-code-review); merge only on Andrew's request.

---

## Self-review record (run at authoring time)

- **Spec coverage:** goal/gate → T14; ratified 1 (carried items) → T1–T4; ratified 2 (two-lane) → T5–T11 with the per-scenario-flip adjudication (see spec amendment); ratified 3 (dispatcher externs) → T5–T6; ratified 4 (glue) → T12; ratified 5 (rt_ui.c frozen) → T11; resource parity → T13; module split → T7–T10; fail-closed → global constraint; timing baseline → T14; non-goals respected (no new features, no peephole, no cache, no 5f).
- **Known deltas from the spec, adjudicated at plan time (spec amended in the same commit):** (1) the cprint redirect flips per-SCENARIO via a temporary `--uiport` flag rather than per-family — the UI runtime is one interconnected event loop, not independent families; the two-lane property (Retro68-proven before native) is preserved exactly. (2) `word` extern type added — the Toolbox INTEGER surface was unrepresentable in 5d's pascal marshaling. (3) Glue entry addresses are jump-table entry addresses (segment-safe), not raw code labels. (4) Native events injection is an `emit68k --events` pool blob, since the C weak-symbol trick has no native analogue.
- **Placeholder scan:** clean — every step names its files, functions, oracle command, and expected outcome; port tasks cite the exact rt_ui.c line ranges as the porting oracle plus the per-slice contract-comment checklists.
- **Type consistency:** blob field lists (T5) match uidesc accessors (T7) and cg68k pool emission (T12); dispatcher names/signatures identical in T6 (producer) and T7/T12 (consumers); `rtUiEdit` signature identical in T10 producer and cprint consumer; `buildNative68kUI` identical in T12 (producer) and T14 (consumer).
