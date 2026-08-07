# Native/Runtime Gaps Cleanup Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Document type/creator control (mandatory args + app.doctype/app.id constants + askOpen filter), app-block/heuristic stack reserve, and four mechanical fixes (label.text read, every-seeding, PostEvent clobber verification, lowering panic → diagnostic).

**Architecture:** Spec: `docs/superpowers/specs/2026-08-07-native-gaps-cleanup-design.md`. Front-end work is clarusc-only; type/creator/filter args are MANDATORY (no optional-arg machinery -- Andrew, spec revision 2); `app.doctype`/`app.id` + fileType* universe consts make providing them one token, resolved to string literals at compile time. All lanes stamp exactly what the call provides.

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

### Task 1: front end — `doctype:` field, `app.*` expressions, file-type constants

> **REVISED per spec revision 2 (mandatory args — no optional-arg machinery anywhere).**

**Files:**
- Modify: `clarusc/check.cla` (appProps ~692-704 gains "doctype"; new checkAppDoctype beside checkAppId ~2775: 1..4 printable chars, no quotes, NO all-lowercase rule, diagnostic `app doctype must be 1 to 4 printable characters`; universe scope gains four predeclared string consts — model on how existing universe symbols are declared near the builtin sigs ~1179)
- Modify: `clarusc/parse.cla` (expression-position `app` `.` IDENT → new EAppConst expr node; `app` is contextual at decl position :1801 — expression position is new; FIRST grep the repo for `app` used as an ordinary identifier in expression position and record the result; the two-token lookahead `app` `.` keeps any such use working)
- Modify: `clarusc/ast.cla` (EAppConst node), `clarusc/ir.cla` (`irAppDoctype` global + reset ~1072), `clarusc/lower.cla` (lowAppDecl stores doctype ~4984; EAppConst lowers to a STRING LITERAL: `app.doctype` → space-padded doctype-or-"TEXT", `app.id` → padded id-or-"????" — after lowering no backend knows the feature exists, zero emission work)
- Modify: `docs/clarus-language-reference.md` (app-section field table gains `doctype`; new "App constants" subsection for app.doctype/app.id; the four fileType* constants + a common-types table, usage-neutral per the spec)
- Test: `testdata/errors/doctype_long.cla` + `.expect` (app section with `doctype: "TOOLONG"`)
- Modify: `clarusc/clarusc.c` (snapshot regen)

**Interfaces:**
- Produces (Task 2 depends on exactly these): `app.doctype` / `app.id` valid anywhere a string expression is (they ARE string literals after lowering); universe consts `fileTypeText` = "TEXT", `fileTypeData` = "CLRD", `fileTypePicture` = "PICT", `fileTypeApplication` = "APPL" (const … : string — reference:375 precedent); `doctype:` app field validated and stored as `irAppDoctype` (-1 when absent).

- [ ] **Step 1: failing fixtures/probes.** Write `testdata/errors/doctype_long.cla` (position pinned after impl). Baseline probes with the current compiler: `app.doctype` in expression position = parse/check error today; `fileTypeText` = `undefined` today. Run the `app`-as-identifier grep and record it.
- [ ] **Step 2: implement** per Files.
- [ ] **Step 3: snapshot regen (Global Constraints commands) + pin the errors-fixture position into its `.expect`.**
- [ ] **Step 4: gates.** `go test ./internal/selfhost -run 'TestSnapshotFixedPoint|TestSnapshotBuilds|TestErrorGoldens|TestBehaviorGoldens' -count=1 -timeout 30m` + T1. Expected: NO golden churn (nothing in the corpus uses the new surface yet).
- [ ] **Step 5: commit** (`feat(clarusc): doctype field, app.doctype/app.id constants, fileType* consts`).

### Task 2: mandatory type/creator/filter args — signatures, emission, runtime, corpus migration (atomic)

**Files:**
- Modify: `clarusc/check.cla` (builtin sigs ~1179-1180: askOpen becomes 2-arg (path, types — both strT(255)); file-table sigs ~1243-1263: writeText/save become 4-arg; the exact-count arity rule is UNTOUCHED — that is the point of this design)
- Modify: `clarusc/lower.cla` (askOpen arm ~787 lowers 2 args; lowFileCall ~963-995 lowers 4; literal-argument validation: a LITERAL type/creator longer than 4 chars, or a literal filter string with more than 4 comma-separated codes, is a check/lower diagnostic — dynamic strings validate at runtime)
- Modify: `clarusc/cprint.cla` (IFileWriteText ~2720 / IFileSave ~2727 / IUiAskOpen ~2899 emission carries the new args; cpEmitAppInfo ~5266: grep every consumer of `rt_app_creator` — if file stamping was its only job, retire the emission + the weak global; if the About-box/resource path reads it, leave it and say so in the report)
- Modify: `clarusc/cg68k.cla` (the same three intrinsics' native emission arms)
- Modify: `runtime/host/rt.c` (:140 rt_file_write_text / :172 rt_file_write_data — accept and IGNORE type/creator, comment per :170 precedent), `runtime/mac/rt_mac.c` (:332/:340 and :387/:392 — Create() from the padded/validated args; static 4CC helper), `runtime/clarus/core.cla` (new `rtFourCC(s: string): int` — space-pad short, -1 on >4; callers map -1 to lastError + failed op), `runtime/clarus/native.cla` (natFileWriteText ~567 gains type/creator params, stamp block ~616-621 uses them, consts natFileTypeText/natFileCreatorMPS ~83-93 DELETED; nat_SerFileWriteData ~850 threads through), `runtime/clarus/ser.cla` (:76 extern + :286 call thread type/creator), `runtime/clarus/uidialogs.cla` (waist externs :89-90 gain the filter param; nat_UiSFGetFile parses the filter: split on comma, pad each code, max 4 → SFTypeList var; "*" → numTypes -1; a 5th code or >4-char code → lastError + return false WITHOUT opening the dialog; scripted halves ~755-799: filter is ignored, script answers stay authoritative), `runtime/mac/rt_ext_mac.inc` (rt_ext_UiSFGetFile ~625: same filter semantics in C)
- Modify (corpus migration — every existing call site gains the new args; canonical spelling `app.doctype, app.id` except where a fixture deliberately tests literals): `examples/texteditor.cla`, `examples/bookmarks.cla`, everything `grep -rln 'file.writeText\|file.save\|askOpen' testsuite/ testdata/ docs/` finds (reference + cookbook fences included)
- Re-bless: emitui `.c.golden` regenerate + cg68k listings re-bless. NOT allowed to change: `.behavior` goldens (runtime output identical), `testdata/ui` traces + `testdata/uisnaps` PBMs (frozen scenarios; `askOpen(p, app.doctype)` in a no-app-section fixture ≡ old TEXT filter).

**Interfaces:**
- Consumes: Task 1's expressions and consts.
- Produces: the runtime rule all lanes implement identically — pad short codes; dynamic >4-char code or >4 filter entries ⇒ lastError + failed operation; "*" ⇒ all files. No defaults, no sentinels: the runtime stamps exactly what arrives.

- [ ] **Step 1: inverted-TDD arity fixtures.** `testdata/errors/askopen_arity.cla` (the OLD 1-arg spelling) and `testdata/errors/writetext_arity.cla` (old 2-arg): confirm both CHECK CLEAN today, then after the sig change they must produce `wrong number of arguments` — write `.expect` files at flip time.
- [ ] **Step 2: sigs + lowering + emission + runtime, all lanes.** Nothing compiles green until every layer lands — this task is atomic BY DESIGN; do not attempt a passing intermediate commit.
- [ ] **Step 3: corpus migration sweep** (grep-driven; canonical `app.doctype, app.id` spelling; fences included; count the sites in the report).
- [ ] **Step 4: goldens.** Regenerate emitui, re-bless cg68k. EYEBALL: each migrated call site carries exactly the new argument pushes and nothing else; `git diff testdata/ui testdata/uisnaps` EMPTY; `.behavior` byte-identical.
- [ ] **Step 5: gates.** Snapshot regen + selfhost subset (TestErrorGoldens sees the flipped fixtures) + T1 --smoke + both native suite gates.
- [ ] **Step 6: commit** (`feat!(lang): mandatory type/creator/filter args on file.writeText/file.save/askOpen`).

### Task 3: FInfoStamp hardware-proof case

**Files:**
- Create: `testsuite/toolbox/cases_finfo.cla`
- Modify: `testsuite/toolbox/runner.cla` (enum ~90-116 before SelfCheck; `nTbCases` :123 24→25; name arm ~193; tbAllCases ~233; dispatch ~354)
- Modify: `internal/mactest/coresuite_test.go` (toolboxFiles ~183-213: add cases_finfo.cla after the other case files, before harness.cla; per-case count comment ~231-236)

**Interfaces:**
- Consumes: Task 2's stamp rule; toolbox catalog's `PBGetFInfoSync` + `FileParam` (already shipped, toolbox/files.cla); `tkReport`/`tkFail` kit conventions (see cases_catalog.cla:36 for the TestResult shape).
- Produces: `caseFInfoStamp(): TestResult`, enum member `FInfoStamp`.

- [ ] **Step 1: write the case.** Body: (a) `file.writeText("stamp1", t, app.doctype, app.id)` -> `PBGetFInfoSync` on a `FileParam` var (ioNamePtr->"stamp1" Pascal str via `UiStrAddr`, ioVRefNum 0, ioFDirIndex 0) -> assert fdType/fdCreator equal the COMPILE-TIME values app.doctype/app.id resolve to in this composition (check testsuite/toolbox/gui.cla for an app section; absent => "TEXT"/"????" per the spec rule -- assert those and comment why); (b) `file.writeText("stamp2", t, fileTypePicture, "RDIT")` -> assert 0x50494354/0x52444954 (also proves a universe const flows through); (c) cleanup: delete both files if a delete primitive exists, else leave (boot disks are throwaway — note it).
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
- Type consistency: `irAppDoctype`/`irAppStack` (Tasks 1/4), `IUiGetLabelText` (Task 5), `rtFourCC` (Task 2), `EAppConst`/`fileType*` (Tasks 1/2/3) — names match across tasks.
- REVISED per spec revision 2 (Andrew): NO optional arguments anywhere -- mandatory args + app.doctype/app.id + fileType* consts; Tasks 1/2 re-cut (Task 2 deliberately atomic: sigs, emission, runtime, whole-corpus call-site migration cannot land separately). Still-standing plan-time corrections: the checker-panic is actually a LOWERING panic (lower.cla:247) -- Task 8 targets the true site; the const-pool "stale duplicates" suspicion may be the documented whole-pool policy -- Task 6 adjudicates.
