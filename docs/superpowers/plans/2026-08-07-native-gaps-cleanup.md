# Native/Runtime Gaps Cleanup Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Document type/creator control (app-block `doctype` + per-call overrides + askOpen filter), app-block/heuristic stack reserve, and four mechanical fixes (label.text read, every-seeding, PostEvent clobber verification, lowering panic → diagnostic).

**Architecture:** Spec: `docs/superpowers/specs/2026-08-07-native-gaps-cleanup-design.md`. Front-end work is clarusc-only (app fields, optional trailing args, new intrinsic arities); stamping defaults are runtime globals (`rt_app_creator` exists, `rt_app_doctype` joins it; native lane gets startup-poked equivalents) so dynamic `""` args can fall back at runtime. All lanes implement ONE stamp rule (spec's table).

**Tech Stack:** Clarus (clarusc self-hosted), Go test harnesses, Mini vMac (gated), Apple Universal Interfaces for citations.

## Global Constraints

- Branch: `native-gaps-cleanup` off main; merge only on explicit request.
- Clarus syntax: ALL `var` declarations at top of a function body; `include` lines must lead a file.
- `.cla` files are MacRoman — never let the Edit tool touch bytes ≥0x80; use `LC_ALL=C sed` for such lines (none expected this phase, but the rule stands).
- Every clarusc/*.cla edit ⇒ snapshot regeneration before Go tests can see it (Step block in Task 1 gives the 4 commands; repeat per clarusc-touching task) and `go test ./internal/selfhost -run 'TestSnapshotFixedPoint|TestSnapshotBuilds|TestErrorGoldens|TestBehaviorGoldens' -count=1 -timeout 30m` green.
- Golden discipline: `runtime/clarus/*.cla` or emission changes churn `internal/cg68k` listings (re-bless `CLARUS_CG68K_BLESS=1 go test ./internal/cg68k -count=1`, then EYEBALL the diff for exactly the intended shapes) and `internal/emitui` `.c.golden`s (regenerate: `for f in testdata/emitui/*.cla; do g="${f%.cla}.c.golden"; [ -f "$g" ] && build-run/clarusc emit -o "$g" "$f"; done`, then `go test ./internal/emitui -count=1` must pass INCLUDING its m68k-gcc compile-check). Any failure outside the expected golden packages = real regression, stop.
- The 4 frozen UI scenarios (`smoke_bounce`, `smoke_mandel`, `texteditor`, `bookmarks`) are NEVER re-blessed — they must stay byte-identical (spec Verification 5 leans on this).
- T1 = `scripts/test-task.sh` after every task (add `--smoke` when runtime/ or clarusc/ changed). Suite gates: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestToolboxSuiteOn68k|TestCoreSuiteGUIOn68k' -count=1 -timeout 30m`. Run emulator tests FOREGROUND, one at a time.
- clarusc bootstrap for manual commands: `cc -O1 -I runtime/host -o build-run/clarusc clarusc/clarusc.c runtime/host/rt.c`
- Commit messages end with:

```
Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01XSg1sXXgVkJ4vMAHuTrpzZ
```

- 4CC packing convention used throughout: `'TEXT'` = 0x54455854 (big-endian byte order of the MacRoman chars); space-pad short codes right (`"TX"` → `'TX  '` = 0x54582020).

---

### Task 1: front end — `doctype:` app field, optional trailing args, new intrinsic arities

**Files:**
- Modify: `clarusc/check.cla` (appProps ~692-704; checkAppDecl ~2715-2767; new checkAppDoctype beside checkAppId ~2775; builtin sigs ~1179-1180 and file-table sigs ~1243-1263; checkArgsCall ~4586-4606 and checkTableMethod ~1376-1399 arity arms)
- Modify: `clarusc/lower.cla` (lowAppDecl ~4984-5001; askOpen arm ~787; lowFileCall ~963-995)
- Modify: `clarusc/ir.cla` (irApp globals ~702-707 + reset ~1072-1077: add `irAppDoctype`)
- Modify: `docs/clarus-language-reference.md` (app-section field table; file.writeText/file.save/askOpen signatures)
- Test: `testdata/errors/` new fixtures + existing emitui fixtures (Task 2 re-blesses)
- Modify: `clarusc/clarusc.c` (snapshot regen)

**Interfaces:**
- Consumes: nothing new.
- Produces (Tasks 2-3 rely on these exactly):
  - App field `doctype: "XXXX"` — string literal, 1..4 printable chars (space-padded to 4 by the CHECKER's canonicalization at lower time; >4 chars = diagnostic `app doctype must be at most 4 printable characters`). Stored as `irAppDoctype` (pool idx, -1 when absent).
  - `askOpen(path)` AND `askOpen(path, types: string)` both check; lowering emits `IUiAskOpen` with 2 args always (2nd = the filter string expr, or a synthesized literal from the app default when omitted — see Step 4).
  - `file.writeText(path, text)` / `(…, type)` / `(…, type, creator)`; `file.save` same. Lowering emits `IFileWriteText`/`IFileSave` with 4/and-existing args always: omitted type/creator become synthesized STRING literal args (`""` = use-default sentinel is NOT used for omitted args — omitted args synthesize the RESOLVED default literal at compile time when the default is knowable (doctype/id are app-section constants), else `""`; explicit `""` literals pass through for runtime fallback).
  - Arity mechanism: per-builtin min/max arms (NO general optional-param machinery — three call sites get explicit `haveCount < min or haveCount > max` checks with the existing "wrong number of arguments" diagnostic).

- [ ] **Step 1: failing checker fixtures.** Create `testdata/errors/doctype_long.cla` (+ `.expect`) — app section with `doctype: "TOOLONG"`, expect `../../testdata/errors/doctype_long.cla:<L>:<C>: app doctype must be at most 4 printable characters`; `testdata/errors/askopen_arity.cla` — `askOpen(p, "TEXT", "X")` expect `wrong number of arguments`; `testdata/errors/writetext_arity.cla` — 5 args, same. Copy the exact two-line copyright header every `testdata/errors/*.cla` carries (see `mixed.cla`). Determine `<L>:<C>` after implementation (Step 6 pins them); write placeholder positions now.
- [ ] **Step 2: verify current compiler REJECTS the new syntax** (baseline): `build-run/clarusc <tmp>/doctype_ok.cla` where that file has `app T { name: "T" id: "TSTA" doctype: "PICT" }` — expect `unknown app property` diagnostic today. And a 3-arg `file.writeText` call — expect `wrong number of arguments to writeText`.
- [ ] **Step 3: implement the app field.** `check.cla`: add `appProps["doctype"] = 1`; add `checkAppDoctype` (length 1..4, printable ASCII 0x20..0x7E, no quotes — model on `checkAppId` at check.cla:2775-2803 but WITHOUT the all-lowercase rule and WITH the ≤4 rule); call it from checkAppDecl where id's hook lives. `ir.cla`: `irAppDoctype` global + reset. `lower.cla` lowAppDecl: store pool idx like id.
- [ ] **Step 4: implement arities + arg synthesis.** `check.cla`: askOpen accepts 1-2 args (2nd `string`); writeText/save accept base..base+2 (extras `string`). `lower.cla`: askOpen omitted-filter synthesizes a string literal from `irAppDoctype` (pool "TEXT" when -1); writeText omitted type ⇒ doctype-or-"TEXT" literal, omitted creator ⇒ app-id-or-"????" literal (via `irAppId`); file.save omitted type ⇒ "CLRD". All spellings 4-char space-padded AT SYNTHESIS. Explicit args pass through unresolved (runtime resolves, Task 2). Intrinsic arg counts grow accordingly — both backends will hard-fail unhandled arity (established convention) until Task 2 lands, so DO NOT run the emitui/cg68k suites between Steps 4 and Task 2's emission work if you split commits; this task ends check-only-green.
- [ ] **Step 5: reference updates.** App-section table gains `doctype` (default TEXT, document the stamp-rule table from the spec verbatim); file.writeText/file.save/askOpen signatures with optional args, padding rule, `"*"` filter, max-4-types rule, empty-string-means-default.
- [ ] **Step 6: snapshot regen + pin fixture positions.**
```sh
cc -O1 -I runtime/host -o /tmp/boot clarusc/clarusc.c runtime/host/rt.c
/tmp/boot emit --rtdir runtime/clarus/ -o /tmp/cur.c clarusc/main.cla
cc -O1 -I runtime/host -o /tmp/cur /tmp/cur.c runtime/host/rt.c
/tmp/cur emit --rtdir runtime/clarus/ -o clarusc/clarusc.c clarusc/main.cla
```
Run each new errors fixture through the built compiler, paste the exact diagnostic into its `.expect`.
- [ ] **Step 7: gates.** `go test ./internal/selfhost -run 'TestSnapshotFixedPoint|TestSnapshotBuilds|TestErrorGoldens|TestBehaviorGoldens' -count=1 -timeout 30m` — expected: PASS (the new intrinsic arities aren't emitted by any existing fixture, so no golden churn yet; if churn appears, STOP — synthesis must only fire for programs that CALL the builtins, and existing fixtures do call askOpen/writeText: their synthesized-literal args WILL change emitted C. In that case emitui/cg68k churn belongs to THIS task: run Task 2's re-bless procedure early and eyeball that only the new trailing args appear).
- [ ] **Step 8: T1 + commit** (`feat(clarusc): doctype app field + per-call type/creator/filter arities`).

### Task 2: runtime plumbing — stamps and filters on all lanes

**Files:**
- Modify: `clarusc/cprint.cla` (IFileWriteText ~2720; IFileSave ~2727; IUiAskOpen ~2899)
- Modify: `clarusc/cg68k.cla` (same intrinsics' native arms; startup app-globals poke in cgEmitStartup ~1414)
- Modify: `runtime/host/rt.c` (rt_file_write_text ~140, rt_file_write_data ~172 — accept+ignore type/creator)
- Modify: `runtime/mac/rt_mac.c` (rt_file_write_text ~332/Create :340; rt_file_write_data ~387/Create :392; new `rt_app_doctype` weak global beside rt_app_creator :379)
- Modify: `clarusc/cprint.cla` cpEmitAppInfo ~5266-5302 (emit strong `rt_app_doctype` like rt_app_creator)
- Modify: `runtime/clarus/native.cla` (natFileWriteText ~567 + stamp block ~616-621; nat_SerFileWriteData ~850; new natAppDoctype/natAppCreator globals replacing natFileTypeText/natFileCreatorMPS consts ~83-93)
- Modify: `runtime/clarus/ser.cla` (:76 extern + :286 call — thread type/creator)
- Modify: `runtime/clarus/uidialogs.cla` (waist externs :89-90 grow filter params; nat_UiSFGetFile builds SFTypeList from the filter string; scripted halves in rtUiAskOpen/rtUiAskSave ~755-799 pass-through unchanged)
- Modify: `runtime/mac/rt_ext_mac.inc` (rt_ext_UiSFGetFile ~625 takes filter; parse codes; numTypes=-1 for "*")
- Re-bless: emitui + cg68k goldens.

**Interfaces:**
- Consumes: Task 1's always-4-arg intrinsics and synthesized-literal defaults.
- Produces: runtime resolution rule every lane implements identically: a type/creator arg that is `""` (or all spaces) resolves to the corresponding app global (`rt_app_doctype`/`rt_app_creator`, native `natAppDoctype`/`natAppCreator`); any other value is space-padded to 4 bytes and used; >4 bytes ⇒ `lastError` set, operation returns false/cancel (write does NOT proceed). askOpen filter string: split on `,`, each code padded, max 4 codes (5th ⇒ lastError + return false), `"*"` ⇒ numTypes -1.
- Native app globals: `var natAppDoctype: int` / `natAppCreator: int` in native.cla, default `0x54455854`/`0x3F3F3F3F` ('????'); when `irHasApp`, cgEmitStartup pokes the app values (two `MOVE.L #imm, (abs)` against the globals' A5-world addresses — follow how cgEmitStartup addresses existing runtime globals; if runtime globals aren't directly addressable from startup, the alternative is a `nat_` init function called from startup — implementer picks whichever cgEmitStartup already has precedent for, states which in the report).

- [ ] **Step 1: write the 4CC helper once per lane that needs it** (string→packed int with space padding + length guard): Clarus-side `rtFourCC(s: string): int` in `runtime/clarus/core.cla` (returns -1 on >4 — callers map that to lastError), C-side static helper in rt_mac.c. Host rt.c ignores stamps entirely (comment: no type/creator concept on host — existing :170 comment pattern).
- [ ] **Step 2: thread the args end to end, lane by lane,** per the Files list (cprint emission adds the two string args to rt_file_write_text/_data calls; rt_mac.c Create() uses resolved values; native natFileWriteText gains type/creator params, stamp block uses them; ser.cla threads through SerFileWriteData; askOpen filter reaches SFGetFile's typeList on both lanes). The C prototypes live in `runtime/mac/rt_ui.h`/rt headers — update them wherever the old signatures are declared (grep `rt_file_write_text` across runtime/).
- [ ] **Step 3: goldens.** Expected churn: emitui `.c.golden`s (new args + rt_app_doctype emission) and cg68k listings. Re-bless per Global Constraints; eyeball: writeText call sites carry two extra pushes; startup carries the two pokes only for app-bearing fixtures.
- [ ] **Step 4: gates.** T1 --smoke; both native suite gates; selfhost subset (snapshot unchanged this task unless cprint.cla/cg68k.cla edits — they ARE edited: regen + fixed-point again).
- [ ] **Step 5: commit** (`feat(runtime): one stamp rule — doctype/creator defaults + per-call overrides + askOpen filter`).

### Task 3: FInfoStamp hardware-proof case

**Files:**
- Create: `testsuite/toolbox/cases_finfo.cla`
- Modify: `testsuite/toolbox/runner.cla` (enum ~90-116 before SelfCheck; `nTbCases` :123 24→25; name arm ~193; tbAllCases ~233; dispatch ~354)
- Modify: `internal/mactest/coresuite_test.go` (toolboxFiles ~183-213: add cases_finfo.cla after the other case files, before harness.cla; per-case count comment ~231-236)

**Interfaces:**
- Consumes: Task 2's stamp rule; toolbox catalog's `PBGetFInfoSync` + `FileParam` (already shipped, toolbox/files.cla); `tkReport`/`tkFail` kit conventions (see cases_catalog.cla:36 for the TestResult shape).
- Produces: `caseFInfoStamp(): TestResult`, enum member `FInfoStamp`.

- [ ] **Step 1: write the case.** Body: (a) `file.writeText("stamp1", t)` with default stamps → `PBGetFInfoSync` on a `FileParam` var (ioNamePtr→"stamp1" Pascal str via `UiStrAddr`, ioVRefNum 0, ioFDirIndex 0) → assert fdType==natAppDoctype-resolved value and fdCreator matches the suite's own app id (the suite gui has an app section? CHECK testsuite/toolbox/gui.cla — if it has no app section the expected creator is 0x3F3F3F3F '????'; assert whichever the composition actually declares and comment WHY); (b) `file.writeText("stamp2", t, "PICT", "RDIT")` → assert 0x50494354/0x52444954; (c) cleanup: delete both files if a delete primitive exists, else leave (boot disks are throwaway — note it).
- [ ] **Step 2: register** (the 5 runner edits + Go file list + count comment).
- [ ] **Step 3: run the gate**: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestToolboxSuiteOn68k -count=1 -timeout 30m` → 25/25; then the cprint twin via `CLARUS_CPRINT_MAC_TESTS=1 go test ./internal/mactest -run TestToolboxSuiteOnMac -count=1 -timeout 60m` → 25/25 (this is the C-lane's stamp-rule proof — the diagnostic lane run is DELIBERATE this phase, both lanes implement new behavior).
- [ ] **Step 4: T1 + commit** (`test(toolbox): FInfoStamp case hardware-proves the stamp rule, both lanes`).

### Task 4: stack reserve — `stack:` field + deepest-chain heuristic

**Files:**
- Modify: `clarusc/check.cla` (appProps + a checkAppStack: INT literal — note checkAppDecl currently requires STRING literals for every property (~2715-2767 "app property X requires a string literal"); `stack` needs an int-literal carve-out; range 4096..1048576 diagnostic `app stack must be between 4096 and 1048576`)
- Modify: `clarusc/lower.cla` lowAppDecl + `clarusc/ir.cla` (`irAppStack`, -1 when absent)
- Modify: `clarusc/shake.cla` (record caller→callee edges during the existing mark walk: `shakeEdges: list of int` pairs or per-func adjacency — the walk at shakeWalkStmt/:271 + shakeWalkExpr/:341 visits every call; add edge (curFunc, callee) capture — shakeProgram :134 sets the current function as it dequeues)
- Modify: `clarusc/cg68k.cla` (new `cgFuncFrameSizes: list of int` parallel to cgFuncSize :390, recorded in cgEmitFunc where frameSize is computed :3176; heuristic function `cgStackHeuristic(): int` — longest path over shake edges with per-node weight = frameSize+2128-floor guard… NO: frameSize already includes the 2128; weight = frameSize + call overhead constant 8 (RTS addr + saved A6); DAG longest-path via memoized DFS, cycle detection marks participants (their SCC contributes each member once); result + `cgToolboxHeadroom` const 8192, even-rounded; reserve = irAppStack when set, else max(32768, heuristic); cgStartupStackReserve const DELETED, cgEmitStartup :1456-1461 ADDA immediate takes the computed value)
- Modify: `docs/clarus-language-reference.md` (app-section `stack:` — native-lane semantics, checks-clean-everywhere)
- Re-bless: cg68k listings (every fixture's startup ADDA changes), emitui unaffected (host lane ignores).
- Test: `testdata/cg68k/` — pick one existing fixture listing and verify the ADDA immediate equals the value the heuristic prints (add `--listing` debug line? NO — assert via the listing bytes; the implementer computes the expected value by hand for ONE small fixture (e.g. arith.cla: main→few leaf calls) and documents the arithmetic in the report).

**Interfaces:**
- Consumes: nothing from Tasks 1-3 (independent; do NOT reorder before Task 1 though — snapshot serialization).
- Produces: `irAppStack`; heuristic behavior other tasks don't consume.

- [ ] **Step 1: failing fixture** `testdata/errors/stack_range.cla` (`stack: 100`) → expect range diagnostic (pin position post-impl).
- [ ] **Step 2: implement** per Files (checker int-literal arm FIRST — it's the only property needing one; keep the string-literal rule for all others).
- [ ] **Step 3: verify the heuristic on the toolbox suite composition** — build it exactly as coresuite_test.go does (`--testapi`, the toolboxFiles list) with `--listing`, find the startup ADDA immediate, confirm ≥ the composition's real need: then run `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestToolboxSuiteOn68k -count=1 -timeout 30m` — a boot crash/hang here means the heuristic undershot: STOP and fix the heuristic (spec: undershoot is a heuristic bug, re-hardcoding is not an option).
- [ ] **Step 4: snapshot regen + selfhost subset + full re-bless + T1 --smoke + both suite gates.**
- [ ] **Step 5: commit** (`feat(cg68k): app stack field + deepest-chain stack-reserve heuristic`).

### Task 5: `label.text` read

**Files:**
- Modify: `clarusc/lower.cla` lowWidgetPropGet ~1593-1630 (arm: `widgetKind == "label" and propName == "text"` → new `IUiGetLabelText`)
- Modify: `clarusc/ir.cla` (intrinsic name), `clarusc/cprint.cla` + `clarusc/cg68k.cla` (emission — copy the IUiGetFieldText arms exactly; they are the str-return template)
- Modify: `runtime/clarus/uiwidgets.cla` or wherever field/textview getters live (grep `rtUiGetFieldText` — the label caption lives in the uidesc widget record; the getter reads the DESC caption, not a TE handle: labels have no editable storage, their text after a SET is stored where rtUiSetLabelText (or equivalent set path) puts it — find the SET path first and read from the same place)
- Modify: `testsuite/toolbox/harness.cla` :130-135 (Status label read directly, drop the checksum-inequality workaround) and `testsuite/toolbox/cases_popuptable.cla` :6-9 + :132 (Result back to `label`, read it directly)
- Re-bless: emitui/cg68k fallout; suite gates.

**Interfaces:** Consumes nothing; produces `IUiGetLabelText` (internal only).

- [ ] **Step 1: failing probe** — tiny UI program reading `SomeLabel.text` compiles today to `read of label.text (not yet implemented)`; keep as a scratch check (the real fixtures are the un-workarounded suite cases).
- [ ] **Step 2: implement** (find the label-text SET path first; the GET mirrors its storage).
- [ ] **Step 3: un-workaround the two cases**, run both suite gates (25/25 with the reads exercising the real path), snapshot regen + re-bless + T1 --smoke.
- [ ] **Step 4: commit** (`feat(ui): label.text read (IUiGetLabelText) + un-workaround suite cases`).

### Task 6: every-seeding + const-pool rider

**Files:**
- Modify: `runtime/clarus/ui.cla` rtUiBuildEvery ~1322-1344 (the `peekb(UiTestScript()) != 0` branch EXISTS but misfires in composed builds — cases_canvas.cla:36-42's measured evidence: the flag reads 0 at startup even though the run is scripted. ROOT-CAUSE FIRST: find when UiTestScript's backing store becomes nonzero vs when rtUiBuildEvery runs; the fix is likely ordering (seed later / re-seed when script mode arms) or an earlier flag init — NOT a blind branch change. State the mechanism in the report before editing.)
- Modify: `testsuite/toolbox/cases_canvas.cla` :29-80 (delete tbCanvasWarmupTicks + warm-up block once the fix makes initial due = declared ticks under script)
- Investigate: `clarusc/cg68k.cla` :372-399 (the ROADMAP rider) — the policy comment says whole-pool-per-segment duplication is deliberate; determine whether ADDITIONAL stale duplicates exist beyond the documented policy (compare pool entry counts per segment against irStrLits for one multi-segment fixture, e.g. bounce). If it's just the documented policy: record "rider resolved — policy, not a bug" in the report + ROADMAP note; only fix if genuine duplicates beyond the policy exist.

- [ ] **Step 1: root-cause + fix seeding; delete workaround; suite gate green (Canvas case asserts the un-warmed schedule).**
- [ ] **Step 2: rider investigation, documented either way.**
- [ ] **Step 3: goldens (4 frozen scenarios MUST stay byte-identical — seeding change affects only composed --testapi builds; if a frozen golden churns, the fix leaked into the real path: STOP), T1 --smoke, commit** (`fix(ui): seed scripted every-blocks from virtual tick 0`).

### Task 7: PostEvent clobber verification

**Files:**
- Modify: `runtime/mac/rt_ext_mac.inc` :828-860 (comment, and the clobber list ONLY if evidence demands)

- [ ] **Step 1: decode.** `LC_ALL=C tr '\r' '\n' < Retro68/InterfacesAndLibraries/Interfaces/CIncludes/Events.h | grep -n -A3 PPostEvent` — PPostEvent is `TWOWORDINLINE(0xA12F, 0x2288)` (glue MOVE.L A0,(A1): the trap RETURNS a queue-element pointer in A0!). PostEvent proper: check its pragma/inline; check AIncludes/Events.a `_PostEvent` register comments; IM II's OS Event Manager trap notes. The question: does 0xA02F clobber A1/D1? Apple's own glue for PPostEvent reads A0 AFTER the trap — evidence A0 is a RESULT (qElPtr), which the current glue omits from outputs entirely (it's declared input-only "r"(a0) — if the trap writes A0, that IS a latent bug: gcc may assume a0 unchanged). Judge and fix: likely `"+r"(a0)` + keep conservative d1/a1.
- [ ] **Step 2: rewrite the comment with the cited evidence (file:line + decoded words), adjust constraints if Step 1 found the A0-result issue, `go test ./internal/emitui -count=1` (compile-check of the glue via goldens is not affected — the .inc is compiled by the suite cprint lane only; if changed, run `CLARUS_CPRINT_MAC_TESTS=1 ... TestToolboxSuiteOnMac` once as the PostEventClick case's proof), T1, commit** (`docs(runtime): PostEvent clobber list verified by decode`).

### Task 8: lowering panic → diagnostic

**Files:**
- Modify: `clarusc/lower.cla` :247 (TyXRec arm: `irFindRecordLayoutByName` -1 guard → `emitDiag(…, "extern record " + name + " is not declared before this use")` — position from the type node; return a safe dummy (irCharT array size 0) so lowering can continue to collect further diagnostics) and the sibling consumer `ir.cla:2093` path (guard at the LOWER call sites that can pass -1, not inside ir.cla accessors)
- Create: `testdata/errors/xrec_order.cla` + `.expect` — a file whose func body declares `var r: SomeXRec` with `extern record SomeXRec { v: word }` AFTER the func (checker passes — two-phase; lowering used to panic; now diagnoses)
- Create: `internal/lowlevel/xrecorder_test.go` — T1-visible twin (errors lane is T2-only selfhost): rtinc_test.go-pattern, run `clarusc emit` on the fixture, assert nonzero exit AND stderr/stdout contains the diagnostic substring, NOT `list index out of range` (spec Verification 4's placement decision: BOTH lanes, reasoning = the panic class regressing would otherwise be invisible until T2)

- [ ] **Step 1: fixture first, verify it PANICS today** (`runtime error: list index out of range`, exit 3).
- [ ] **Step 2: guard + diagnostic; verify fixture now produces the diag with exit 1; pin `.expect`.**
- [ ] **Step 3: also re-run pack3's `TestCatalogComposesWithUIRuntime`** (guards the hoist path still; and `go test ./internal/lowlevel ./internal/testsuite -count=1`).
- [ ] **Step 4: snapshot regen + selfhost subset + T1 + commit** (`fix(clarusc): unresolved extern-record layout diagnoses instead of panicking`).

### Task 9: T2 + phase records

- [ ] **Step 1:** `scripts/test-merge.sh` end-to-end green (background it; ~4-5 min).
- [ ] **Step 2:** ROADMAP: strike/annotate the five closed small-open items (+ rider verdict from Task 6, + PostEvent verdict from Task 7); spec Outcome section (deltas, measured heuristic values, both-lane FInfo proof); CLAUDE.md only if a workflow fact changed (suite case count 24→25 appears in CLAUDE.md — update it).
- [ ] **Step 3:** commit (`docs: native-gaps-cleanup phase records`).

---

## Self-Review Notes (done at write time)

- Spec coverage: Part A → Tasks 1-3; Part B → Task 4; Part C items 1-4 → Tasks 5,6,7,8; Verification 1-6 → distributed (V2 Tasks 2/4/5, V3 Task 3, V4 Task 8's twin-test reasoning recorded, V5 Task 6 Step 3, V6 Task 9).
- Known judgment points left to implementers ON PURPOSE, each with a stop-and-report rule: Task 2's native app-globals poke mechanism (two candidates named); Task 5's label storage location (find SET path first); Task 6's root-cause-before-edit; Task 4 Step 3's undershoot rule.
- Type consistency: `irAppDoctype`/`irAppStack` (Tasks 1/4), `IUiGetLabelText` (Task 5), `rtFourCC` (Task 2), `natAppDoctype`/`natAppCreator` (Tasks 2/3) — names match across tasks.
- Corrections vs spec discovered at planning time (spec stands, plan notes them): check.cla has NO optional-arg machinery (askSave is strictly 2-arg — the spec's "precedent" was a design intent, not fact; Task 1 builds per-builtin arms); the checker-panic is actually a LOWERING panic (lower.cla:247) — Task 8 targets the true site; the ROADMAP's const-pool "stale duplicates" suspicion may be the documented whole-pool policy — Task 6 adjudicates.
