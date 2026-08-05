# UI Scenario Retirement Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Migrate the 13 widget/window scenarios of the legacy scripted UI golden lane into the toolbox suite (one boot per lane) and delete each retired scenario, ending with the scripted lane at the 10 app-level scenarios.

**Architecture:** A behavior-preserving dispatcher extraction in `uiscript.cla` (Task 1) enables a new `runtime/clarus/uitest.cla` test-driver module, made visible to suite code by the new opt-in `clarusc --testapi` early-splice flag (Task 2, the phase's one compiler change, with snapshot regen). Tasks 3+ grow the toolbox suite case by case, deleting each subsumed scenario in the same task, per the spec's assertion-mapping discipline.

**Tech Stack:** Clarus (runtime modules + testsuite), clarusc (`main.cla` flag + manifest), Go test harnesses (mactest/coresuite), Mini vMac gated lanes.

**Spec:** `docs/superpowers/specs/2026-08-05-ui-scenario-retirement-design.md` — its scenario-disposition table and Component 1b are normative.

## Global Constraints

- Feature branch `ui-scenario-retirement`; merge only on request.
- Without `--testapi`, emitted output is byte-identical to today: the emitui `.c.golden`s, the 10 surviving scenarios' traces/PBMs, and `TestSnapshotFixedPoint` are the proof — none may change except where a task explicitly regenerates the snapshot (Task 2).
- `.cla` files may contain MacRoman bytes: transcribe fixture content with byte-safe tools (`cp` + `LC_ALL=C sed`) or ASCII `\xHH` escapes — never let an editor re-encode. New suite files should be pure ASCII with `\xHH` escapes where needed.
- Suite case-code conventions (from the existing toolbox suite, binding): piecewise string building (cg68k per-statement temp budget); checksum regions byte-aligned by layout construction; a case closes every window it opens on ALL paths before returning; cases never `quit`.
- Per-task gates: T1 (`scripts/test-task.sh`) green, and for every task that touches `runtime/`, `clarusc/`, or `testsuite/`: the two `--smoke` native boots PLUS the four gated suite boots (`CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestCoreSuiteGUI|TestToolboxSuite' -count=1 -timeout 30m`). Full T2 only at Task 10.
- Retirement discipline (spec Component 4): a scenario's deletion lands in the SAME commit as its replacement case(s); the task report contains the assertion-mapping table (every fixture/events/trace/check-helper assertion ↔ the case assertion subsuming it). An assertion the case cannot express blocks that scenario's retirement — escalate, never drop silently.
- `internal/mactest/ui_test.go` helpers: delete a `check*Snaps` helper only with its scenario; NEVER touch shared machinery (`runUIScenario*`, `checkUIGoldens`, `parseUIOutput`, `uiSnap`, `blessUI`) — the 10 survivors use it.
- Checksum constants are recorded via the documented FAIL-then-copy procedure (build with a wrong constant, boot, copy the reported value) — never computed by hand.

## Scenario → task map (all 13, spec disposition table)

| Task | Scenarios migrated & deleted |
|---|---|
| 4 (pilot) | pattern |
| 5 | buttons, winvar, textwidgets |
| 6 | menus, editmenu |
| 7 | canvas, zoomwin, hscroll |
| 8 | popuptable, formedit |
| 9 | dialogs, hdim |

Kept forever (do not touch): about (UIAbout), smoke_bounce, smoke_menudemo, smoke_mandel, opendoc, opendoc_empty, texteditor, texteditor_quit, texteditor_bigfile, bookmarks.

---

### Task 1: uiscript dispatcher extraction (behavior-preserving)

**Files:**
- Modify: `runtime/clarus/uiscript.cla` (`rtUiRunScripted`, ~lines 1249-1322)

**Interfaces:**
- Produces: `func rtUiScriptDispatchLine(): bool` — dispatches the ALREADY-TOKENIZED verb buffers (`rtUiVerbBuf`/`rtUiArg1Buf`/`rtUiArg2Buf` + rest-of-line reads); returns `false` for an unknown verb, `true` otherwise (including blank lines and the `launchdoc` no-op). It performs NO line-reading, NO pumping, NO quit-on-unknown — those stay in the caller.

- [ ] **Step 1: Read the current loop**

Read `rtUiRunScripted` in full, plus `rtUiScriptTokenize` (~line 842) and `rtUiScriptRestOfLine` (~line 980) to see how the line buffer feeds tokenization and rest-of-line verbs (`type`, `answer-open`, `answer-save`).

- [ ] **Step 2: Extract**

Move the entire verb if/else chain (from `if rtUiStrEq(rtUiVerbBuf, UiStrAddr("click"))` through the `answer-cancel` arm and the blank-line arm) into `rtUiScriptDispatchLine(): bool` verbatim. The `quit` and `launchdoc` arms move too (dispatch = the whole verb table). The final `else` arm becomes `return false` (the `log`+`quit 1` moves to the caller). All other arms fall through to `return true`. `rtUiRunScripted` becomes:

```
func rtUiRunScripted() {
    rtUiScripted = true
    UiHideCursor()
    while true {
        if not rtUiScriptNextLine() {
            rtUiQuit()
            return
        }
        rtUiScriptTokenize()
        if not rtUiScriptDispatchLine() {
            log("uiport: unknown or unsupported scripted verb")
            quit 1
        }
        rtUiPumpPassive()
    }
}
```

(Comments on the moved arms move with them; keep the file's comment density.)

- [ ] **Step 3: Verify — behavior-preserving means byte-identical goldens**

Run: `scripts/test-task.sh --smoke`
Expected: PASS — including the two native smoke boots against frozen goldens. Runtime `.cla` changed, so also run the four gated suite boots:
`CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestCoreSuiteGUI|TestToolboxSuite' -count=1 -timeout 30m` — expected PASS. No snapshot regen (compiler untouched).

- [ ] **Step 4: Commit**

```bash
git checkout -b ui-scenario-retirement   # first task creates the branch
git add runtime/clarus/uiscript.cla
git commit -m "refactor(runtime): extract rtUiScriptDispatchLine from the scripted loop"
```

---

### Task 2: `uitest.cla` + `clarusc --testapi` + snapshot regen

**Files:**
- Create: `runtime/clarus/uitest.cla`
- Modify: `clarusc/main.cla` (flag parse ~lines 311-395; manifest block ~lines 496-700; usage strings)
- Modify: `clarusc/clarusc.c` (regenerated, not hand-edited)
- Test: extend `internal/lowlevel/rtinc_test.go` (the inclusion-machinery home) with `TestTestApiFlag`

**Interfaces:**
- Produces (all in `uitest.cla`, exact signatures — later tasks call these):
  - `func UiTestVerb(line: string): bool` — copy `line` into the script line buffer, `rtUiScriptTokenize()`, `rtUiScriptDispatchLine()`; on `true`, `rtUiPumpPassive()`; returns the dispatch result. Rejects (returns `false`, no dispatch) when the verb token is `quit`, `launchdoc`, or `snap` — control verbs are not for case code. Read `rtUiScriptNextLine` first to learn the line-buffer variable and termination convention; add a small `rtUiScriptSetLine`-style setter in `uiscript.cla` if the buffer is not directly reachable, keeping tokenize/rest-of-line reads working on the injected line.
  - Wrappers (each builds the verb line piecewise, then `return UiTestVerb(s)`): `UiTestClick(x: int, y: int): bool`, `UiTestDblClick(x: int, y: int): bool`, `UiTestKey(k: string): bool`, `UiTestType(s: string): bool`, `UiTestMenu(m: int, i: int): bool`, `UiTestClose(): bool`, `UiTestResize(w: int, h: int): bool`, `UiTestZoom(): bool`, `UiTestTick(n: int): bool`, `UiTestAnswerOpen(path: string): bool`, `UiTestAnswerSave(path: string): bool`, `UiTestAnswerChanges(choice: string): bool`, `UiTestAnswerCancel(): bool`, `UiTestAnswerPopup(n: int): bool`. (`UiTestAnswerChanges` forwards `answer-changes <choice>` — read `rtUiScriptAnswerChanges` for the argument convention before writing it.)
  - `func UiTestChecksum(x: int, y: int, w: int, h: int): int` — generalized CanvasChecksum: `base = ptr(peekl(ptr(0x824)))` (ScrnBase), row stride 64, sum `peekb` over rows `y..y+h`, bytes `x/8 .. (x+w)/8`. Contract: `x` and `w` multiples of 8; on violation return `-1` (documented; `-1` is unreachable as a real sum only if callers keep regions small — cap summed bytes at 8192 by contract, noted in the doc comment).
  - `UiTestTick(n)`: if `rtUiScripted` (CI boots) forward to the `tick` verb (virtual ticks); else loop `n` times over real pump-with-TickCount-wait — read `rtUiScriptTick` and `rtUiScriptEveryPump` first and reuse their internals rather than duplicating.
- Produces (clarusc): `--testapi` accepted by `emit`/`emit68k`; when set AND `isUiProg`: splice `uidesc.cla, ui.cla, uiwidgets.cla, uitext.cla, uitable.cla, uiscript.cla, uidialogs.cla, uitest.cla` BEFORE `checkProgram`, check the combined program ONCE, and skip the ordinary post-check UI-set splice (no double-add; the ser.cla usage-flag flow is untouched). When set on a non-UI program: no-op. `isUiProg` needs computing from the PARSED decl list before check in this mode — it is already parse-level logic (main.cla:513-521); hoist or duplicate it for the testapi path.

- [ ] **Step 1: Write the failing tests**

In `internal/lowlevel/rtinc_test.go`, add `TestTestApiFlag` with three subtests, following the file's existing emit-invocation helpers:
- `WithFlagResolves`: a temp UI program (window + button + a handler calling `UiTestClick(10, 10)` and `UiTestChecksum(0, 0, 8, 8)`) emits successfully with `emit --testapi --rtdir <root>/runtime/clarus/`, and the emitted C contains `clar_fn_UiTestVerb` (the spliced module's emission).
- `WithoutFlagRejected`: the same program without `--testapi` fails, stderr/stdout containing `UiTestClick` (the unknown-name diagnostic).
- `NonUiNoop`: a windowless program with `--testapi` emits successfully and the emitted C does NOT contain `clar_fn_UiTestVerb`.

- [ ] **Step 2: Run to verify failure**

Run: `go test ./internal/lowlevel -run TestTestApiFlag -count=1`
Expected: FAIL (flag unknown → usage error).

- [ ] **Step 3: Write `runtime/clarus/uitest.cla`**

Per the Produces block above. Header comment: what it is, `--testapi`-only inclusion, the control-verb rejection rule, the checksum alignment/size contract, the scripted-vs-real `UiTestTick` split. Follow the other `ui*.cla` modules' comment style and the piecewise-string rule.

- [ ] **Step 4: Implement `--testapi` in `clarusc/main.cla`**

Flag parse alongside `--rtdir`/`--listing`; usage strings updated. The early-splice branch mirrors the existing manifest splice mechanics (same `neededMods`/expand/`setDeclFile` path — read the existing block at ~560-700 and reuse its machinery, relocated ahead of the check for this mode; set the same `cp*` flags the ordinary UI splice sets). Ensure the post-check manifest block skips the UI set when the testapi splice already ran.

- [ ] **Step 5: Regenerate the snapshot**

```bash
cc -O1 -I runtime/host -o /tmp/boot clarusc/clarusc.c runtime/host/rt.c
/tmp/boot emit --rtdir runtime/clarus/ -o /tmp/cur.c clarusc/main.cla
cc -O1 -I runtime/host -o /tmp/cur /tmp/cur.c runtime/host/rt.c
/tmp/cur emit --rtdir runtime/clarus/ -o clarusc/clarusc.c clarusc/main.cla
```

- [ ] **Step 6: Verify**

Run: `go test ./internal/lowlevel -run TestTestApiFlag -count=1` — PASS.
Run: `go test ./internal/selfhost -count=1 -timeout 30m` — PASS (fixed point green on the regenerated snapshot; behavior goldens unchanged).
Run: `scripts/test-task.sh --smoke` — PASS (no-flag byte-identity: emitui goldens + smoke boots unchanged).

- [ ] **Step 7: Commit**

```bash
git add runtime/clarus/uitest.cla clarusc/main.cla clarusc/clarusc.c internal/lowlevel/rtinc_test.go
git commit -m "feat(clarusc,runtime): --testapi opt-in early splice + uitest.cla test driver"
```

---

### Task 3: suite plumbing — harness file, smoke case, PostEvent sentinel, build flags

**Files:**
- Create: `testsuite/toolbox/harness.cla` (initially: one probe window)
- Create: `testsuite/toolbox/cases_uitest.cla`
- Modify: `testsuite/toolbox/runner.cla` (enum + dispatch + `tbAllCases` + `nTbCases` arithmetic)
- Modify: `testsuite/toolbox/gui.cla` only if the new file list needs it (case table populates from `tbAllCases()` — expect no edit)
- Modify: every toolbox-suite build call site to add `--testapi` and the two new files: `internal/mactest/coresuite_test.go`'s toolbox file lists / build calls (grep `toolboxFiles`), and any script recipe that builds the toolbox suite (grep `testsuite/toolbox` in `scripts/` and CLAUDE.md — CLAUDE.md's compose recipe is Task 10's docs pass; scripts only here).

**Interfaces:**
- Consumes: `UiTest*` (Task 2), `tkPass/tkFail/tkReport` (kit.cla), `rtUiScripted` semantics.
- Produces: `window UiProbe` in harness.cla — `title: "UiProbe"; size: 300, 120; button Poke "Poke"; var pokes: int = 0` with `on Poke.click { window.pokes = window.pokes + 1 }` (exact geometry chosen by the implementer so Poke's screen-global center is derivable the way `toolboxsuite.events` derives RunAll's — document the arithmetic in a comment). Two new `ToolboxTest` cases: `UiTestVerbSmoke`, `PostEventClick`.

- [ ] **Step 1: harness.cla + cases_uitest.cla**

`caseUiTestVerbSmoke`: `w = open UiProbe`; `UiTestClick(px, py)` at Poke's derived coordinates; pass iff the click returned true AND `w.pokes == 1`; also assert `UiTestVerb("bogusverb") == false` (the false-not-quit contract); close w on every path.

`casePostEventClick` (spec Component 3): local externs in this file per the suite's proven pattern — `PostEvent = trap 0xA02F` with the OS/register clause (bit 11 clear; consult Ch13's named-register clause syntax and the bit-11 rule in ROADMAP; IM Event Manager: A0 = event number 1 = mouseDown, D0 = message; result D0). Poke the mouse-position low-mem globals before posting (`MTemp` 0x828, `RawMouse` 0x82C, both Points; set `CrsrNew` byte 0x8CE to 1) so the click lands on Poke's coordinates; post mouseDown then mouseUp (event 2); pump via `UiTestTick(1)`; pass iff `w.pokes` incremented. If real-queue delivery proves flaky under the scripted boot, the case may drive the REAL loop path explicitly — record what was needed in the report; do NOT silently weaken the assertion.

- [ ] **Step 2: Register**

Enum: `..., EventXRec, UiTestVerbSmoke, PostEventClick, SelfCheck`; dispatch arms; `tbAllCases()` grows; `nTbCases` arithmetic and the SelfCheck `casesRun == nTbCases - 1` contract update in the same commit.

- [ ] **Step 3: Build-site flags**

Add `--testapi` + the two new positional files to the toolbox suite's build invocations (grep for the existing file list; core suite untouched).

- [ ] **Step 4: Verify**

`go build ./... && scripts/test-task.sh` — PASS.
`CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestToolboxSuite' -count=1 -timeout 30m` — PASS both lanes, now 9 result lines (8 real + SelfCheck).

- [ ] **Step 5: Commit**

```bash
git add testsuite/toolbox/ internal/mactest/
git commit -m "feat(testsuite): uitest smoke + PostEvent sentinel; toolbox builds pass --testapi"
```

---

### Task 4: pilot migration — `pattern`

**Files:**
- Modify: `testsuite/toolbox/harness.cla` (add the pattern harness window, transcribed from `testdata/ui/pattern.cla` — byte-safe copy)
- Create: `testsuite/toolbox/cases_pattern.cla`
- Modify: `testsuite/toolbox/runner.cla` (register per Task 3 Step 2's recipe: enum arm before SelfCheck, dispatch, tbAllCases, nTbCases)
- Delete: `testdata/ui/pattern.cla`, `testdata/ui/pattern.events`, `testdata/ui/pattern.trace`, `testdata/uisnaps/pattern.*.pbm`
- Modify: `internal/mactest/ui_test.go` (delete `TestPatternUIScenario`), `internal/mactest/native_test.go` (delete pattern's `uiScenarios68k` entry)

**Interfaces:**
- Consumes: `UiTestTick`, `UiTestChecksum` (Task 2 signatures).

- [ ] **Step 1: Read the retiring scenario completely**

`testdata/ui/pattern.cla` (the fixture app: 9-level dither ramp, clamp cases, FillOval, frame op), `pattern.events` (`tick 1`, `snap S1`, `quit`), and confirm from `ui_test.go` that pattern has NO extra Go-side invariant (golden-PBM-is-the-assertion).

- [ ] **Step 2: Build the case**

Harness window transcribes the fixture's canvas + drawing (adjust geometry so each checksummed region is byte-aligned — the CanvasChecksum `at:` precedent). `casePattern`: open harness, `UiTestTick(1)`, checksum each distinct drawn region (one region per assertion-worthy feature: the ramp band(s), the clamp cells, the oval, the frame) against pinned constants recorded by the FAIL-then-copy procedure; close; pass iff all match. One case is fine; split only if the report's mapping table reads better that way.

- [ ] **Step 3: The assertion-mapping table**

In the task report: every visual feature the golden PBM pinned ↔ the checksum region + constant now covering it. This is the reviewer's subsumption checklist (spec Component 4).

- [ ] **Step 4: Delete the scenario** (files + both harness entries, same commit).

- [ ] **Step 5: Verify**

`scripts/test-task.sh` PASS; `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestToolboxSuite|TestUiScenariosOn68k' -count=1 -timeout 30m` PASS (suite green with the new case both lanes; native scenario table no longer contains pattern).

- [ ] **Step 6: Commit**

```bash
git add -A
git commit -m "feat(testsuite): migrate pattern scenario to toolbox case; retire the scenario"
```

---

### Tasks 5-9: batch migrations

Each batch task follows EXACTLY the pilot's six steps per scenario — read the retiring fixture + events + trace + its `check*Snaps` helper; transcribe the harness window; write the case(s); produce the assertion-mapping table; delete the scenario's files and both harness entries in the same commit; run the Task-4 verification pair. Batch specifics (assertion translation per spec Component 2):

**Task 5 — buttons, winvar, textwidgets.**
- buttons (trace-only): harness counters for click/key/resize/close dispatch; drive with `UiTestClick`/`UiTestKey`/`UiTestResize`/`UiTestClose`; assert counter sequence. The close-box dispatch assert must survive the window actually closing (case re-opens if needed).
- winvar (snap-is-assertion): two `UiTestClick`s on Add; checksum the Body region against a pinned constant (uninitialized window-var construction regression).
- textwidgets (S-pair): set `.text` at 32,000 and 32,001 bytes programmatically (fixture shows the construction); assert lengths/clamp via widget reads AND checksum(region-A) != checksum(region-B) mirroring the ok/trunc snap-inequality.

**Task 6 — menus, editmenu.**
- menus (trace-only): `UiTestMenu` sequences across app-scope + window-scoped items; harness counters assert dispatch and the case asserts dim/undim transitions by attempting the dimmed selection (counter must NOT advance) around open/close of the scoped window.
- editmenu: two textviews; `UiTestType`/`UiTestMenu`(Cut/Copy/Paste/Clear/Undo); assert text moved via widget `.text` reads (stronger than the old snap), the Copy no-change-event pin via a change-counter, dim transitions as in menus.

**Task 7 — canvas, zoomwin, hscroll.**
- canvas: every-block animation harness; checksum(region) at t0, `UiTestTick(2)`, checksum again; assert difference (S1≠S2 translation).
- zoomwin: checksum c1, `UiTestZoom()`, c2, `UiTestZoom()`, c3; assert c1 != c2 and c1 == c3.
- hscroll: transcribe the no-wrap TE harness; page-right click → checksum pair differs; caret-arrow `UiTestKey("right")` repetitions → autoscroll checksum pair differs; thumbless-when-fits via a second short-content window checksum equality before/after page attempt.

**Task 8 — popuptable, formedit.**
- popuptable: `rows:`-bound table; Add/Remove clicks → checksum row-region pair differs; select via `UiTestClick` on a row and assert Result text via widget read; `UiTestDblClick` fires select-then-doubleClick (counters); `UiTestAnswerPopup(n)` + click drives the popup path.
- formedit: form open → `UiTestType` into fields, `UiTestAnswerPopup` for the enum popup, `UiTestClick`(OK/Cancel); assert accepted/cancelled handler fire + bound-record values by direct reads; the S3==S4 escape-cancel invariant becomes checksum equality around a cancelled edit.

**Task 9 — dialogs, hdim.**
- dialogs: `UiTestAnswerSave(path)` + menu-driven Save → REAL `file.writeText` on the boot volume; clear; `UiTestAnswerOpen(path)` + Open → widget `.text` equals the saved content (the roundtrip snap's meaning, now a direct equality); Cancel paths via `UiTestAnswerCancel`; all three `UiTestAnswerChanges` choices; window-title assert via title read if surfaced, else checksum.
- hdim (snap-is-assertion): empty-content window; checksum the two scrollbar lanes against pinned constants (thumbless rendering).

Each of Tasks 5-9 commits as `feat(testsuite): migrate <scenarios> to toolbox cases; retire the scenarios`.

---

### Task 10: wrap — docs, timing, full T2

**Files:**
- Modify: `CLAUDE.md` (scenario counts 23→10 wherever stated; the `--testapi` flag documented next to the emit recipes; toolbox suite case count updated)
- Modify: `docs/ROADMAP.md` (phase outcome entry; the launch-app-from-Clarus follow-up recorded per spec Out-of-scope 1; the 2b review remains next)
- Modify: `docs/superpowers/specs/2026-08-05-ui-scenario-retirement-design.md` (append an Outcome section: what migrated, case counts, boot counts, timing delta)

- [ ] **Step 1: Docs per the Files list.** Grep CLAUDE.md and ROADMAP for `23` scenario references and the scripted-lane descriptions; every touched sentence re-read for truth.

- [ ] **Step 2: Full T2**

Run: `scripts/test-merge.sh` (background, ~10+ min — expect gated mactest well under the pre-phase 534s; record the number).
Expected: PASS.

- [ ] **Step 3: Verify the survivors are untouched**

`git diff main -- testdata/uisnaps testdata/ui | grep -c .` scoped to the 10 surviving scenarios' files → zero changed lines (deletions of retired scenarios are expected; survivors byte-identical).

- [ ] **Step 4: Commit**

```bash
git add CLAUDE.md docs/
git commit -m "docs: ui-scenario-retirement wrap (counts, --testapi, ROADMAP outcome + timing)"
```

---

## Self-review notes (spec → plan)

- Component 1 (uitest API incl. verb rejection, checksum contract, tick split) → Task 2; the spec's "wrapper set may shrink" is resolved: the full set is specified because Tasks 5-9 use all of it except none — every wrapper listed has a consuming scenario (`UiTestDrag` deliberately absent: no migrating scenario uses `drag`).
- Component 1b (`--testapi`, snapshot regen, no-flag byte-identity, non-UI no-op, check-only untouched) → Task 2 (tests cover flag on/off/non-UI; selfhost + smoke prove identity).
- Component 2 (harness file, case conventions, enum/SelfCheck growth, coresuite parsing unchanged) → Tasks 3-9.
- Component 3 (PostEvent sentinel) → Task 3.
- Component 4 (retirement mechanics, mapping table, same-commit deletion) → Tasks 4-9 + Global Constraints.
- Verification section (both-lane suite boots per task, phase-boundary T2 + timing, survivors byte-identical, machinery smoke before migrations) → per-task gates + Task 10.
- Error handling (false-not-quit, checksum misalignment `-1`, close-on-every-path) → Tasks 2-3 + Global Constraints.
- Out of scope: launch-app recorded in Task 10's ROADMAP step; no other compiler change anywhere (Task 2 is the only clarusc-touching task).
