# Test-Consolidation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reduce the gated `internal/mactest` emulator-boot inventory from 51 boots to ~13 purpose-audited boots, fixing the `accepted(rec)` trailing-bool native codegen bug and migrating formedit + texteditor_bigfile into the toolbox suite along the way.

**Architecture:** Audit-first (Task 1 produces the committed evidence table; later tasks cite its rows), then coverage lands (Tasks 2-5: codegen fix, suite migrations, event-script merges), then deletions (Tasks 6-7, each commit citing audit rows), then re-baseline (Task 8). Spec: `docs/superpowers/specs/2026-08-06-test-consolidation-design.md`.

**Tech Stack:** Go test harnesses (`internal/mactest`), Clarus test suites (`testsuite/core`, `testsuite/toolbox`), Mini vMac via LaunchAPPL, clarusc emit68k / Retro68 lanes.

## Global Constraints

- Feature branch: `test-consolidation` off `main` (create in Task 1; merge only on request).
- **The audit table overrides this plan's target list.** If an audit row contradicts a deletion or fold listed here, follow the audit and record the deviation in the SDD ledger — never delete against an audit KEEP verdict.
- Emulator tests need `CLARUS_MAC_TESTS=1` and the local toolchain/emulator (present on this machine). Full gated run: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -count=1 -timeout 30m`. Single test: append `-run '^TestName$'`.
- `.cla` files may contain MacRoman bytes the Edit tool corrupts. Before editing any `.cla` or `.events` region, run `LC_ALL=C grep -n '[^[:print:][:space:]]' <file>` on the lines you will touch; if non-ASCII appears, use `LC_ALL=C sed` byte-safe editing and verify with `cmp`/byte-diff.
- T1 gate after every task: `scripts/test-task.sh` (add `--smoke` for Tasks 2-3, which touch `clarusc/`/`runtime/`). Tasks that modify or delete gated tests additionally run the affected gated tests (commands given per task).
- UI goldens: while the Retro68 scenario lane exists (through Task 6), bless ONLY via that lane (`CLARUS_MAC_BLESS=1`, `ui_test.go`); the native lane hard-fails on bless by design. Task 7 flips bless ownership to the native lane in the same commit that retires the Retro68 scenario lane.
- `scripts/test-task.sh --smoke`'s two canaries (`TestSmokeBounceOn68k`, `TestRealEventLoopTickOn68k`) must exist and pass after every task — they are explicitly out of deletion scope.

---

### Task 1: The audit table

**Files:**
- Create: `docs/superpowers/specs/2026-08-06-test-consolidation-audit.md`

**Interfaces:**
- Produces: the committed audit table every later task cites by row ID (e.g. `[A17]`). Rows carry verdicts: `KEEP` / `DELETE` / `MERGE→<target>` / `MIGRATE→<suite case>`, each with a "unique coverage" and "covered elsewhere" citation (file:line or test name).

- [ ] **Step 1: Create the branch**

```bash
git checkout -b test-consolidation
```

- [ ] **Step 2: Enumerate every boot**

Read `internal/mactest/{native_test.go,mac_test.go,ui_test.go,coresuite_test.go}`. Build the row list — one row per boot (loop tests get one row per iteration source, e.g. each runerr fixture). Expected inventory (verify, don't trust): native lane 29 boots (Hello; NativeSmoke; NativeStrContainers; NativeFixedOps; NativeArrWholeAssign; NativeSmokeForcedMultiSegment; SmokeBounceOn68k; AboutOn68k; 8 `uiScenarios68k` rows; TexteditorBigfileOn68k; RealEventLoopTickOn68k; SuiteOn68k; 6 RunErrOn68k; 2 AbortOn68k; CoreSuiteGUIOn68k; ToolboxSuiteOn68k), Retro68 lane 22 boots (11 `ui_test.go` scenarios; SuiteOnMac; 6 RunErrOnMac; 2 AbortAppsOnMac; CoreSuiteGUIOnMac; ToolboxSuiteOnMac).

- [ ] **Step 3: Fill the columns with verified facts**

Table schema (one markdown table, ID-prefixed rows):

```
| ID | Test (boot) | Lane | What it uniquely executes | Where else covered | Verdict | Acted on in |
```

Specific claims that MUST be verified by reading code/goldens, not assumed
(each becomes evidence in its row):

1. **Is the composed toolbox/core suite app naturally multi-segment?** Build both native GUIs (`scripts/build-68k.sh` over the coresuite/toolbox compositions per `coresuite_test.go`'s file lists) and inspect segment count (the build log/listing prints segments; alternatively `grep`-count `SEG` entries via the emitted listing). If ≥2 segments, `NativeSmokeForcedMultiSegment` → DELETE citing this; else KEEP.
2. **Bring-up test unique assertions:** read each of Hello/NativeSmoke/StrContainers/FixedOps/ArrWholeAssign for assertions not subsumed by `CoreTest` cases (capture-protocol details, exit-code paths). Cite the covering `testsuite/core/cases_*.cla` case per deleted test.
3. **smoke_menudemo:** does the toolbox suite cover custom app menus (items, dimming, shortcuts) beyond `cases_editmenu.cla`'s `standard edit`? If not, verdict is `MIGRATE→toolbox case Menus` (gap-fill lands in Task 5) or KEEP — not DELETE.
4. **about:** what does the `about` scenario assert (About-box ALRT/DITL, app-section plumbing) and does any surviving example's script cover it? Default: `MERGE→smoke_mandel` (mandelbrot has an app section + About item); verify mandelbrot's events can host it.
5. **opendoc/opendoc_empty:** confirm `examples/texteditor.cla` + a `launchdoc` line in its events covers GetAppFiles doc-launch (incl. the empty-doc edge); pick MERGE targets.
6. **runerr representative:** pick ONE fixture per lane as the panic-machinery boot (prefer `oob` — plain bounds panic). Verify all 6 fixtures' semantics have host `.behavior` coverage (T1) — cite file paths. Verify the abort apps' unique value (byte-exact `.out` capture of abort-partway) is subsumed by the runerr representative's log+exit assertions; if a genuinely unique capture path exists, KEEP one abort app and say why.
7. **cli_mac.cla retirement:** confirm nothing outside `TestSuiteOnMac`/`TestSuiteOn68k` references `testsuite/core/cli_mac.cla` (grep). Verdict for the wrapper rides with those two rows.
8. **Retro68 scenario rows:** for each of the 11, cite the suite case or native example boot that carries its coverage after Tasks 3-5.

- [ ] **Step 4: Commit**

```bash
git add docs/superpowers/specs/2026-08-06-test-consolidation-audit.md
git commit -m "docs: test-consolidation audit table (per-boot coverage evidence)"
```

### Task 2: `accepted(rec)` trailing-bool — reproduce, root-cause, fix

**Files:**
- Create: `/tmp` scratch fixtures only (repro artifacts are not committed)
- Modify (only if bug is live): the root-cause site — suspects in order: `clarusc/cg68k.cla` form-accept/writeback lowering, `runtime/clarus/ui.cla` `rtUiFormAccept` writeback walk, `clarusc/uiblob.cla` native-lane Layout emission
- Test: pinned in Task 3's suite case (this task's exit criterion is a verified root cause + fix, or a verified already-fixed finding)

**Interfaces:**
- Consumes: audit row for formedit `[A-formedit]`.
- Produces: either (a) a commit fixing the bug, or (b) a ledger + ROADMAP-ready finding that small-scalar-width already fixed it (with the exact commit named). Task 3 depends on this outcome.

- [ ] **Step 1: REPRODUCE FIRST — the bug may already be dead**

The bug was filed 2026-08-05 during ui-scenario-retirement, BEFORE the small-scalar-width phase (merged 2026-08-06 morning) unified bool widths to 1 byte across all aggregates and descriptor arms — the exact mismatch family this smells like. Build the minimal repro:

Write `/tmp/tbool.cla`:

```
record Prefs {
    name:     string(15)
    autosave: bool
}

window Main "TBool" {
    size: 300, 100
    form Editor for Prefs {
        field Name for name
        check Auto for autosave
    }
    on accepted(rec: Prefs) {
        if rec.autosave {
            log("autosave TRUE")
        } else {
            log("autosave FALSE")
        }
    }
}

on App.launch {
    var p: Prefs
    p.name = "x"
    p.autosave = true
    Main.Editor.edit(p)
}
```

(Adjust syntax against `testdata/ui/formedit.cla` — it is the canonical form fixture; the essential shape is: bound record whose LAST field is `bool`, pre-set `true`, form opened and accepted unchanged.) Write `/tmp/tbool.events` modeled on `testdata/ui/formedit.events`' accept sequence (open form → click OK). Build and boot native:

```bash
scripts/build-68k.sh TBool /tmp/tbool.cla --events /tmp/tbool.events
toolchain/bin/LaunchAPPL -e minivmac build-68k/TBool.bin   # run in background, blocks until quit
```

Bug live = capture log shows `autosave FALSE`. Bug dead = `autosave TRUE`.

- [ ] **Step 2a (bug dead): verify it was the small-scalar-width fix**

Rebuild the same repro at the pre-small-scalar-width commit (`git worktree add /tmp/pre-ssw fc8c3dd~1` — the phase's first commit's parent; build clarusc there and repeat). Confirm FALSE there, TRUE now. Record in the ledger: root cause = the retired 2B/4B bool-width descriptor mismatch, fixed by small-scalar-width (name the commit). Skip Step 2b; Task 3 pins it.

- [ ] **Step 2b (bug live): systematic debugging**

Follow superpowers:systematic-debugging. Instrument, in order: (1) does the native uiblob Layout carry the right offset/ftype for the trailing bool (`clarusc/uiblob.cla`, `uibNativeLane` branch — dump the blob ints for `Prefs`)? (2) does `rtUiFormFill` read `true` INTO the form (is the check-box checked on screen — eyeball via a snap)? (3) does `rtUiFormAccept`'s writeback poke the right width at the right offset (`runtime/clarus/ui.cla` — trace the poke)? The failure "reverts to false" with a TRAILING bool points at a width/offset overrun from the preceding field's writeback, or a 2/4-byte write over a 1-byte slot zeroing past the end. Fix at the root (shared walk, not a formedit special case). Snapshot regen required if `clarusc/*.cla` changed (fixedpoint recipe: `cc -O1 -I runtime/host -o /tmp/boot clarusc/clarusc.c runtime/host/rt.c && /tmp/boot emit --rtdir runtime/clarus/ -o /tmp/cur.c clarusc/main.cla && cc -O1 -I runtime/host -o /tmp/cur /tmp/cur.c runtime/host/rt.c && /tmp/cur emit --rtdir runtime/clarus/ -o clarusc/clarusc.c clarusc/main.cla`).

- [ ] **Step 3: Verify + gates**

Repro now prints `autosave TRUE`. Run `scripts/test-task.sh --smoke`. If code changed, also run the formedit scenario both lanes:

```bash
CLARUS_MAC_TESTS=1 go test ./internal/mactest -count=1 -run 'TestFormeditUIScenario|TestUiScenariosOn68k/formedit' -timeout 20m
```

- [ ] **Step 4: Commit** (only if code changed)

```bash
git add -A clarusc/ runtime/ && git commit -m "fix(cg68k): accepted(rec) no longer reverts a bound trailing bool field"
```

### Task 3: formedit → toolbox suite case; retire the scripted scenario

**Files:**
- Create: `testsuite/toolbox/cases_formedit.cla`
- Modify: `testsuite/toolbox/runner.cla` (enum + dispatch — follow the exact pattern of the 12 ui-scenario-retirement migrations, e.g. `cases_editmenu.cla`'s registration), `internal/mactest/native_test.go` (remove formedit row from `uiScenarios68k`), `internal/mactest/ui_test.go` (delete `TestFormeditUIScenario`)
- Delete: `testdata/ui/formedit.cla`, `testdata/ui/formedit.events`, `testdata/uisnaps/formedit*` (glob-check for trace goldens too)

**Interfaces:**
- Consumes: Task 2's outcome; audit row `[A-formedit]`; the `UiTestVerb`/wrapper machinery (`runtime/clarus/uitest.cla`) the existing migrated cases use.
- Produces: `ToolboxTest` case `FormEdit` (name it consistently with sibling case names in `runner.cla`).

- [ ] **Step 1: Write the case (failing-under-bug by construction)**

Port `testdata/ui/formedit.cla`'s form (field/popup/check incl. the `favorite: bool` trailing field) into a case following `cases_editmenu.cla`'s structure: drive the form via `UiTest*` wrappers (open → edit a field → accept), then assert the accepted record's every field INCLUDING `favorite == true` — the assertion that fails under the Task-2 bug (tickprobe precedent: verify by temporarily re-introducing the bug ONLY if Task 2 changed code; if Task 2 found it already-fixed, verify against the pre-ssw worktree build instead, then discard the worktree).

- [ ] **Step 2: Run the toolbox suite both lanes**

```bash
CLARUS_MAC_TESTS=1 go test ./internal/mactest -count=1 -run 'TestToolboxSuite' -timeout 20m
```

Expected: PASS with the new `FormEdit` subtest green on both lanes.

- [ ] **Step 3: Delete the scripted scenario (both lanes) + fixtures; re-run**

Remove the formedit row/test/fixtures listed above, then:

```bash
CLARUS_MAC_TESTS=1 go test ./internal/mactest -count=1 -run 'TestUiScenariosOn68k|TestToolboxSuite' -timeout 30m
scripts/test-task.sh --smoke
```

- [ ] **Step 4: Commit**

```bash
git add -A testsuite/ internal/mactest/ testdata/
git commit -m "test(toolbox): migrate formedit to suite case FormEdit; retire scripted scenario [cites audit rows]"
```

### Task 4: texteditor_bigfile → toolbox suite case (with memory-headroom check)

**Files:**
- Create: `testsuite/toolbox/cases_bigtext.cla`
- Modify: `testsuite/toolbox/runner.cla`; `internal/mactest/native_test.go` (delete `TestTexteditorBigfileOn68k`), `internal/mactest/ui_test.go` (delete `TestTexteditorBigfileUIScenario`)
- Delete: `testdata/ui/texteditor_bigfile_setup.cla`, `testdata/ui/texteditor_bigfile.events`, its uisnaps/trace goldens

**Interfaces:**
- Consumes: audit row `[A-bigfile]`; `testdata/ui/texteditor_bigfile_setup.cla` (the 32k-fixture generator — port its content-generation into the case).
- Produces: `ToolboxTest` case `BigText` (32k clamp + `lastError` + TE behavior on a textview window).

- [ ] **Step 1: Headroom check FIRST**

Add the case (Step 2) provisionally, build the composed native toolbox GUI, and boot it watching for the ui-scenario-retirement failure signature (crash through ApplLimit masquerading as "coprocessor not installed"/hang). Also print/inspect free heap around the case (`UiTest` checksum boots already log; a `FreeMem` probe via an existing `Tb*` extern is acceptable if one exists — do not add new externs for this). If the boot is unstable or headroom is marginal (<256KB free during the case), STOP: revert the case, record `KEEP standalone` in the ledger + audit table, keep `TestTexteditorBigfileOn68k` (native only — still delete the Retro68 twin in Task 7 per audit), and skip to Step 4's reduced commit.

- [ ] **Step 2: Write the case**

Port the bigfile scenario's assertions (build a >32,000-byte text programmatically like `texteditor_bigfile_setup.cla` does, set it into a textview, assert the 32,000 clamp + `lastError` fires + tail content correct). The case needs a textview window in the toolbox GUI composition — reuse the suite's existing window if one has a textview; else add one to `testsuite/toolbox/gui.cla` following its existing window declarations.

- [ ] **Step 3: Run + delete standalone boots**

```bash
CLARUS_MAC_TESTS=1 go test ./internal/mactest -count=1 -run 'TestToolboxSuite' -timeout 20m
```

PASS both lanes → delete the two standalone bigfile tests + fixtures, re-run the same command plus `scripts/test-task.sh`.

- [ ] **Step 4: Commit**

```bash
git add -A testsuite/ internal/mactest/ testdata/
git commit -m "test(toolbox): migrate texteditor_bigfile to suite case BigText [cites audit rows]"
```

(or, on the headroom bail-out: commit just the audit-table/ledger update recording KEEP-standalone.)

### Task 5: Native example-lane script merges (texteditor absorbs quit+opendoc; about folds; menu gap-fill if audited)

**Files:**
- Modify: `testdata/ui/texteditor.events` (append quit-path coverage from `texteditor_quit.events` and doc-launch lines from `opendoc.events`/`opendoc_empty.events`), `testdata/ui/smoke_mandel.events` (absorb `about.events`' About-box open/close if audit row `[A-about]` says MERGE), `internal/mactest/native_test.go` (`uiScenarios68k` rows for texteditor/opendoc/about adjusted)
- Create (only if audit row `[A-menudemo]` says MIGRATE): `testsuite/toolbox/cases_menus.cla` + runner registration
- Delete: `testdata/ui/{texteditor_quit,opendoc,opendoc_empty,about}.events`, `testdata/ui/opendoc.cla`, `testdata/ui/about.cla` (if folded), their uisnaps/trace goldens; `internal/mactest/ui_test.go` tests for the merged scenarios; `TestAboutOn68k` if folded
- Bless: merged scripts produce NEW goldens — bless via the Retro68 lane (still alive until Task 7): `CLARUS_MAC_BLESS=1 CLARUS_MAC_TESTS=1 go test ./internal/mactest -count=1 -run 'TestTexteditorUIScenario|TestSmokeMandelUIScenario' -timeout 20m`, then EYEBALL every re-blessed PBM snap (they are viewable images — Read them) before freezing; native lane must then pass byte-identical.

**Interfaces:**
- Consumes: audit rows `[A-texteditor-quit]`, `[A-opendoc]`, `[A-opendoc-empty]`, `[A-about]`, `[A-menudemo]`.
- Produces: the final native example scenario set (bounce, mandel, texteditor, bookmarks — plus about standalone only if the audit kept it).

- [ ] **Step 1: Merge scripts per audit rows** (event verbs are line-oriented — study `testdata/ui/texteditor.events` + the retired scripts before splicing; doc-launch uses the `launchdoc` verb, which must appear before the app-launch tick it gates)
- [ ] **Step 2: Bless via Retro68 lane; eyeball snaps; verify native byte-identical**

```bash
CLARUS_MAC_TESTS=1 go test ./internal/mactest -count=1 -run 'TestUiScenariosOn68k' -timeout 30m
```

- [ ] **Step 3: Delete merged-away scenarios' tests + fixtures both lanes; re-run the same + `scripts/test-task.sh`**
- [ ] **Step 4: Commit** — `test(ui): merge quit/opendoc/about coverage into surviving example scripts [cites audit rows]`

### Task 6: Native-lane deletions

**Files:**
- Modify: `internal/mactest/native_test.go` — delete `TestHelloOn68k`, `TestNativeSmoke`, `TestNativeStrContainers`, `TestNativeFixedOps`, `TestNativeArrWholeAssign`, `TestNativeSmokeForcedMultiSegment` (audit-gated), `TestSuiteOn68k`, `TestAbortOn68k`; reduce `TestRunErrOn68k` to the audit's representative fixture (keep the loop structure, glob → single file, or a one-fixture list — smallest diff wins)
- Delete: any fixtures orphaned ONLY by these tests (check references first — runerr `.cla`/`.err`/`.behavior` files stay, host tests use them; the native runerr/abort wrappers had no dedicated fixtures)

**Interfaces:**
- Consumes: audit rows for every deleted test (the commit message cites them).

- [ ] **Step 1: Delete per audit rows; keep `TestSmokeBounceOn68k` + `TestRealEventLoopTickOn68k` untouched**
- [ ] **Step 2: Full gated run + T1**

```bash
CLARUS_MAC_TESTS=1 go test ./internal/mactest -count=1 -timeout 30m
scripts/test-task.sh --smoke
```

- [ ] **Step 3: Commit** — `test(mactest): retire native bring-up/CLI/panic-duplicate boots [cites audit rows]`

### Task 7: Retro68 scenario-lane retirement + bless-ownership flip

**Files:**
- Modify: `internal/mactest/ui_test.go` — delete the remaining scenario tests (about/bounce/menudemo/mandel/texteditor/bookmarks Retro68 boots) and `TestSuiteOnMac`, `TestAbortAppsOnMac`; reduce `TestRunErrOnMac` to the representative fixture; KEEP the shared helpers `checkUIGoldens`/bless machinery that the native lane uses
- Modify: `internal/mactest/native_test.go` — REMOVE the two "native UI lane never blesses" hard-fail guards (`native_test.go:355-395` area); blessing now runs on the native lane (it is the only scenario lane left). Update the guard comments accordingly.
- Modify: `CLAUDE.md` — the `CLARUS_MAC_BLESS` sentence now names the native lane as the bless path.
- Delete: `testsuite/core/cli_mac.cla` (audit-gated — grep for references first), `smoke_menudemo` fixtures if audit migrated/deleted it, any `.events`/goldens now referenced by nothing (verify with grep before each deletion)

**Interfaces:**
- Consumes: audit rows for all 11 Retro68 scenario boots + `[A-cli-mac]`.
- Produces: final boot inventory; native lane owns blessing.

- [ ] **Step 1: Delete per audit rows; flip bless ownership (guards out, comments + CLAUDE.md updated)**
- [ ] **Step 2: Prove bless works on the native lane** — pick one surviving scenario, run `CLARUS_MAC_BLESS=1 CLARUS_MAC_TESTS=1 go test ./internal/mactest -count=1 -run 'TestUiScenariosOn68k/smoke_bounce' -timeout 10m`... note `smoke_bounce` is a standalone test, not a table row: use a table scenario (e.g. `bookmarks`), confirm goldens rewrite byte-identical on an unchanged tree (`git diff --exit-code testdata/uisnaps testdata/ui`), which proves the bless path without changing anything
- [ ] **Step 3: Full gated run + T1**

```bash
CLARUS_MAC_TESTS=1 go test ./internal/mactest -count=1 -timeout 30m
scripts/test-task.sh --smoke
```

- [ ] **Step 4: Commit** — `test(mactest): retire Retro68 scenario lane; bless moves to native lane [cites audit rows]`

### Task 8: Re-baseline and docs

**Files:**
- Modify: `docs/ROADMAP.md` — new Done entry (boot counts before/after, T2 timing before/after, audit table path, the CLI-is-host-only rationale recorded on the known-broken native `App.startCLI` open item; close/update the launch-from-Clarus item's "11 survivors" wording to the new example set)
- Modify: `CLAUDE.md` — test-suite sections: new boot inventory summary, updated scenario list, `--testapi`/suite wording checked against reality, bless-lane sentence (if not already done in Task 7)
- Modify: `docs/superpowers/specs/2026-08-06-test-consolidation-design.md` — a short "Outcome" section: final boot table, deviations from target (each citing its audit row)

**Interfaces:**
- Consumes: everything prior; the final full-gate timings.

- [ ] **Step 1: Time the new baseline** — run T2 end-to-end and record the gated-mactest wall clock from its output:

```bash
scripts/test-merge.sh
```

Expected: PASS; gated mactest segment substantially below the 381s pre-phase baseline. Record actual numbers in the ROADMAP entry.

- [ ] **Step 2: Write the three doc updates** (numbers from Step 1; audit-table cross-references)
- [ ] **Step 3: T1 sanity + commit**

```bash
scripts/test-task.sh
git add -A docs/ CLAUDE.md && git commit -m "docs: test-consolidation re-baseline (boot inventory, timings, ROADMAP/CLAUDE.md)"
```

---

## Post-plan gates (top-level session)

- Whole-branch final review (most capable model), pointed at the audit table + ledger deferred/parked lines.
- T2 already ran in Task 8; re-run only if the final-review fix wave changes code.
- Merge only on Andrew's request. Do NOT delete the SDD workspace — phase records are kept in this project.
