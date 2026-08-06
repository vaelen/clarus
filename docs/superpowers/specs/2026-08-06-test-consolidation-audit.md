# Test-consolidation audit table

**Task:** 1 of 8, test-consolidation phase. **Status:** committed evidence
base — nothing deleted by this document. Every later task's deletion/
migration/merge commit must cite the row IDs below (`[N6]`, `[R2]`, ...).

Modeled on ui-scenario-retirement's 15-row audit
(`docs/ROADMAP.md`, search "known-unexercised"). Inventory verified
against `internal/mactest/{native_test.go,mac_test.go,ui_test.go,
coresuite_test.go}` on 2026-08-06: **29 native (`emit68k`) lane boots +
22 Retro68/cprint lane boots = 51 total**, matching
`docs/superpowers/specs/2026-08-06-test-consolidation-design.md`'s count.

IDs: `N1`-`N29` = native lane, in `native_test.go`'s own top-to-bottom
order (loop/table tests get one row per sub-case, e.g. `N20`-`N25` are
`TestRunErrOn68k`'s 6 `t.Run` fixtures). `R1`-`R22` = Retro68 lane
(`ui_test.go`'s 11 scenarios, then `mac_test.go`'s CLI/runerr/abort rows,
then `coresuite_test.go`'s two Mac-lane suite gates).

## The 8 claims — verification method and evidence

1. **Is the composed toolbox/core suite app naturally multi-segment?**
   Built both compositions with the current-source clarusc
   (`build-68k/clarusc`, snapshot-bootstrapped) via
   `clarusc emit68k -o ... --listing <files...>` at clarusc's **real,
   undecorated default 32760-byte per-segment budget** (no `--seglimit`
   — the same budget `buildNative68kUI` always uses, since it has no
   segLimit parameter) — i.e. the exact composition
   `TestToolboxSuiteOn68k`/`TestCoreSuiteGUIOn68k` already boot.
   - Toolbox composition (`toolboxFiles`, `--testapi` +
     `testsuite/toolbox/*.cla` + `gui.cla`): **8** `.seg1.s`...`.seg8.s`
     files produced.
   - Core composition (`coreGUIFiles`, `testsuite/core/cases_*.cla` +
     `gui.cla`): **3** `.seg1.s`...`.seg3.s` files produced.
   - **Verdict: TRUE, both compositions are naturally multi-segment at
     the real budget.** `TestNativeSmokeForcedMultiSegment` [N6] is
     redundant — `N28`/`N29` already exercise cross-segment BSR/JSR +
     the Segment Loader `_LoadSeg` path on every ordinary run, no forced
     `--seglimit` needed. **DELETE** [N6], contradicting nothing in the
     spec (this was the spec's own stated "if ≥2 segments, DELETE"
     branch).

2. **Bring-up test unique assertions** (Hello/NativeSmoke/StrContainers/
   FixedOps/ArrWholeAssign vs `testsuite/core/cases_*.cla`):
   - `TestHelloOn68k` [N1]: single `alert("hello, 68k")`, pure
     capture-protocol/walking-skeleton proof. The capture protocol
     (`##CLARUS-EXIT##`/`##CLARUS-LOG##`) is exercised by every other
     native boot including [N28]/[N29]. **DELETE.**
   - `TestNativeFixedOps` [N4]: `fix_mul`/`fix_div` native codegen.
     Byte-identical operations (`1.5*2.0==3`, `9.0/2.0`, `fixed(3)+0.25`,
     same truncation convention) are in
     `testsuite/core/cases_enumfix.cla:39` (`caseFixedMathOps`), which
     runs on native 68k via [N28]. **DELETE**, cite
     `cases_enumfix.cla:39`.
   - `TestNativeStrContainers` [N3]: **NOT subsumed — contradicts the
     spec's tentative deletion list.** Three gap-closure codegen classes,
     verified absent from every `testsuite/core/cases_*.cla`:
     (a) `list of string(8)` (>4-byte inline element) push/index-read/
     index-write/for-list/remove — `grep -rn "list of string(" testsuite/`
     returns **nothing**; `cases_list.cla` only has `list of int`
     (4-byte) and `list of text` (handle). (b) a string **literal**
     sliced directly in expression position
     (`"hello world"[6, 5]`, never bound to a local) — the only
     `[N, N]` slice in `testsuite/core/` is `cases_text.cla:118`
     (`s[6, 5]`), but `s` there is an already-bound local `var`, a
     different codegen path (`cgExprAddr`'s addressable-local arm, not
     the non-addressable-expression `cgMaterializeToTemp` fallback).
     (c) a map key built from a computed expression
     (`sm[ka + kb] = 42`) — `grep -n '\[.*+.*\]\s*=' testsuite/core/*.cla`
     returns nothing; every `cases_map.cla` key is a string literal.
     **KEEP.**
   - `TestNativeArrWholeAssign` [N5]: **NOT subsumed — contradicts the
     spec's tentative deletion list.** Fixture covers whole-array
     assignment (`b = a` for `int[4]`/`char[3]`), record-field whole-array
     assign (`r.ints = b`), array-of-record whole assign (`pb = pa`),
     and nested fixed-array-element whole assign (`m[1] = row`) — all
     with post-assign source mutation to prove copy independence.
     `testsuite/core/cases_arr.cla` has exactly one case
     (`caseArrHolderElementStore`), and it covers a **single-element
     store** into an array-of-record field, never a **whole-array**
     assignment. No other `cases_*.cla` file assigns a fixed array by
     value. **KEEP.**
   - `TestNativeSmoke` [N2]: **partially NOT subsumed — contradicts the
     spec's tentative deletion list.** Records/enums/containers/text
     basics (ctor defaults, nested-field copy independence, enum round
     trip, list/map/text ops) look subsumed by
     `cases_rec.cla`/`cases_enumfix.cla`/`cases_list.cla`/`cases_map.cla`/
     `cases_str.cla`/`cases_text.cla` collectively (not exhaustively
     assert-by-assert verified — flagged below). But `smoke.cla`'s Task
     14 file section has THREE assertions absent from
     `testsuite/core/cases_ser.cla` (checked its full 3-case content):
     the >32768-byte chunked-read boundary (`natFileReadCap`,
     `smokeFilesBig`, spot-checks at byte 32767/32768), the
     read-missing-file → `false` + `lastError.code==2`/
     `"could not open file"` path, and the `e = lastError` local-copy
     codegen (`cgEmitStoreErr`). `cases_ser.cla`'s 4 cases
     (`SerBinRoundtrip`/`SerFileRoundtrip`/`SerFileNameRoundtrip`/
     `SerMixedScalarRec`) never write a file that fails to open and
     never exceed a few dozen bytes. **KEEP, pending a task-5-style
     option to migrate exactly those 3 assertions into `cases_ser.cla`
     and re-audit** — unverified in full: the records/enums/container
     baseline overlap with `cases_rec.cla` etc. was read at the section
     level, not diffed assertion-by-assertion; "unverified in full,
     verify precisely if a future task still wants to delete this row."

3. **`smoke_menudemo`:** does the toolbox suite cover custom app menus
   (items, dimming, shortcuts) beyond `cases_editmenu.cla`'s "standard
   edit"? **Yes — contradicts the spec's framing (which offered only
   MIGRATE-if-missing or KEEP, not "already covered, just delete").**
   `testsuite/toolbox/cases_menus.cla`'s `caseMenus` (migrated from the
   already-retired `testdata/ui/menus.cla`) drives the SAME shape
   `menu-demo.cla` does: an app-scope always-enabled item (`Toggle`), an
   app-scope item that opens a second window (`NewAux`), and a
   window-scoped item whose dispatch is gated on that window being
   frontmost (`Scoped`, open/close/re-check three times) — functionally
   equivalent dim/undim coverage to `smoke_menudemo`'s own `T DIM
   View.AuxOnly 1`/`0` trace lines (verified via
   `testdata/ui/smoke_menudemo.trace`), via counters instead of a raw
   trace event. Keyboard-shortcut dispatch (real `MenuKey` trap) is
   separately covered by `testsuite/toolbox/cases_events.cla:87`
   (`caseMenuKeyMatches`, `TbMenuKey(int('Q'))` against `gui.cla`'s own
   File/Quit). Note: `smoke_menudemo.events` itself never actually
   presses a key — it only issues `menu` verb lines — so this scenario
   never tested keyboard shortcuts in the first place. **DELETE** [N9]/
   [R4], cite `cases_menus.cla` (app-scope + window-scoped items,
   dim/undim) + `cases_events.cla:87` (shortcut dispatch mechanism).

4. **`about`:** `testdata/ui/about.cla`'s `app` section sets all four
   About-relevant properties (`name`/`version`/`author`/`about`); its
   `.trace` shows `T ABOUT AboutProbe|9.9|Probe Author|Probe about text.`
   after `menu 1 1`. `examples/mandelbrot.cla:28-32` has an `app Mandelbrot`
   section with the same four properties populated
   (`name`/`version`/`author`/`about`). **Confirmed: `MERGE→smoke_mandel`
   is viable** — a `menu 1 1` line + an `ABOUT` trace assertion added to
   `smoke_mandel`'s events script (native [N10]) would exercise the exact
   same Apple-menu About-item dispatch path. This is a native-lane-only
   merge (Decision 2); see claim 8 for why no Retro68-lane equivalent
   survives.

5. **`opendoc`/`opendoc_empty`:** `examples/texteditor.cla:81-83` has
   `on App.openDocument(p: string) { openPath(p) }`, which does a REAL
   `file.readText` (stronger than `opendoc.cla`'s simplified Reader
   window, which only echoes the path string). A `launchdoc <path>` line
   added to `texteditor.events` would exercise the identical
   `GetAppFiles`-launch dispatch `opendoc`'s own `T OPENDOC <path>` trace
   proves, with a real file read on top. `opendoc_empty`'s coverage (the
   `App.startEmpty` fallback when no doc is named) is **already**
   exercised by `texteditor.events` today with no change needed —
   `texteditor.cla:77-79`'s `on App.startEmpty { open Doc }` is exactly
   what an ordinary (no-`launchdoc`) `texteditor` boot already triggers.
   **Confirmed MERGE→texteditor** for both (native lane [N14] only,
   Decision 2 — no Retro68-lane doc-launch replacement, see claim 8).

6. **runerr representative + abort apps:**
   - All 6 `testdata/runerr/*.cla` fixtures have a matching `.behavior`
     golden (`badenum`/`emptypop`/`mapmiss`/`oob`/`slicerange`/
     `strindex`, all present), consumed by
     `internal/selfhost/behavior_test.go` (T1, host-side, ungated) —
     confirmed this asserts `exit=3` + the exact stderr message per
     fixture. Semantic coverage is host-pinned and lane-independent, so
     cutting 5 of 6 per-lane boots loses no semantic signal. Picked
     **`oob`** (plain bounds panic) as the representative, per the
     brief's own suggestion — simplest real-mode trap shape.
   - **Abort apps are NOT fully absorbable by the runerr representative
     as the spec assumes — a real, evidenced gap.** The spec's target
     end-state says the one panic-machinery boot per lane should be
     "absorbing the abort apps' abort-partway/byte-exact-capture
     coverage." But `testdata/run/emit_array.cla`/`emit_enum.cla` each
     print several real `alert()` lines (6 and 4 respectively — verified
     via their `.out` goldens) BEFORE panicking, proving the capture
     buffer correctly preserves multi-line output up to an abort — while
     **all 6 runerr fixtures panic with ZERO prior output** (verified by
     reading each `.cla`: none call `alert()` before their
     panic-triggering statement). No swap of runerr representative fixes
     this — none of the 6 have the needed shape. Absorption would require
     editing a fixture to add pre-panic `alert()` lines, which is an
     implementation change out of this audit task's scope (no fixture
     edits here). **Recommendation for a later task: either (a) add 2-3
     `alert()` lines to `oob.cla` before its panic and re-audit, achieving
     genuine one-boot absorption, or (b) accept a 2-boot panic budget per
     lane.** Absent that edit, the honest verdict today is: **KEEP one
     abort app per lane** (`emit_array` — 6 pre-panic lines vs
     `emit_enum`'s 4, the stronger proof; its own semantic coverage,
     enum-conversion panic, is separately pinned host-side by
     `badenum.behavior`) alongside the runerr representative. This bumps
     the ~13-boot target by +2 (one extra boot per lane) unless a later
     task does the fixture edit above.

7. **`cli_mac.cla` retirement:** `grep -rln "cli_mac"` across
   `*.go`/`*.cla`/`*.sh`/`*.md` found a real, non-comment usage OUTSIDE
   `TestSuiteOnMac`/`TestSuiteOn68k`:
   **`internal/cg68k/segment_test.go:72`** (`segmentationFixture`,
   consumed by `TestSegmentationMultiSegment`) builds the exact same
   `coreCLIMacFiles`-shaped composition (kit.cla + core/runner.cla + all
   `cases_*.cla` + `core/cli_mac.cla`) to verify real multi-segment CODE
   packing — **host-side, ungated, part of T1, out of this phase's scope**
   ("Out of scope: Host-side (non-boot) test surface ... untouched," per
   the spec). **Contradicts the spec's framing** ("The audit decides
   whether `cli_mac.cla` ... retires with them" implied it might retire
   alongside [N19]/[R12]). **Verdict: `cli_mac.cla` does NOT retire** —
   `internal/cg68k/segment_test.go` depends on it independently of
   [N19]/[R12]'s fate.

8. **Retro68 scenario rows — coverage after Tasks 3-5:** (Decision 2:
   example-app acceptance boots are native-lane-only; the Retro68 lane
   keeps only real-Toolbox coverage of the ported runtime via its two
   suite boots, [R21]/[R22].)

   | Scenario | Retro68 coverage after this phase |
   |---|---|
   | `formedit` [R1] | pending Task 2's `accepted(rec)` codegen fix; once fixed, MIGRATE→toolbox case, carried by [R22] (shared `toolboxFiles` composition, both lanes) |
   | `about` [R2] | **gap, accepted per Decision 2**: no suite GUI (`core/gui.cla`, `toolbox/gui.cla`) declares an `app` section or clicks the Apple menu (verified: neither file has an `app` block; neither `coresuite.events`/`toolboxsuite.events` has a `menu 1 ...` line) — About-item dispatch becomes native-lane-only, via [N10]'s merge (claim 4) |
   | `smoke_bounce` [R3] | `cases_canvas.cla` (real-Toolbox canvas draw/animate, via [R22]); example-specific ball-bounce proof stays native-only ([N7]) |
   | `smoke_menudemo` [R4] | `cases_menus.cla` + `cases_events.cla:87` (claim 3), via [R22] |
   | `smoke_mandel` [R5] | `cases_canvas.cla` generic canvas Toolbox path (via [R22]); Mandelbrot-specific fixed-point render progression stays native-only ([N10]) |
   | `opendoc`/`opendoc_empty` [R6]/[R7] | **gap, accepted per Decision 2**: no suite case exercises `App.openDocument`/`GetAppFiles` (verified: `grep -rln "openDocument\|GetAppFiles\|AppleEvent\|launchdoc" testsuite/` hits only doc-comment mentions, no real case) — doc-launch coverage becomes native-lane-only, via [N14]'s merge (claim 5) |
   | `texteditor`/`texteditor_quit`/`texteditor_bigfile` [R8]/[R9]/[R10] | `cases_textwidgets.cla` (field/textview + 32000-byte clamp) + `cases_dialogs.cla` (askOpen/askSave/askSaveChanges + real file round trip) generic Toolbox paths, via [R22]; texteditor-specific quit-cascade/oversize-guard stay native-only |
   | `bookmarks` [R11] | `cases_dialogs.cla` (real file I/O) + `cases_popuptable.cla`/form-pattern cases generic Toolbox paths, via [R22]; bookmarks-specific persistence-wiring proof stays native-only ([N16]) |

## Row table

| ID | Test (boot) | Lane | What it uniquely executes | Where else covered | Verdict | Acted on in |
|---|---|---|---|---|---|---|
| N1 | `TestHelloOn68k` | native | Walking-skeleton milestone; `alert()` + exit-trailer capture protocol | Capture protocol exercised by every other native boot, e.g. `N28` | DELETE | claim 2 |
| N2 | `TestNativeSmoke` | native | Records/enums/containers/text baseline + file-section edge cases (>32KB chunked read, missing-file `lastError`, `e = lastError` local-copy codegen) | Baseline overlaps `cases_rec.cla`/`cases_enumfix.cla`/`cases_list.cla`/`cases_map.cla`/`cases_str.cla`/`cases_text.cla` (not assertion-diffed); file-edge-cases absent from `cases_ser.cla` | KEEP (contradicts spec) | — |
| N3 | `TestNativeStrContainers` | native | `list of string(N)` (>4-byte element) container ops; string-literal slice in expr position; map key from computed expr | None — verified absent from every `testsuite/core/cases_*.cla` | KEEP (contradicts spec) | — |
| N4 | `TestNativeFixedOps` | native | `fix_mul`/`fix_div` native codegen | `testsuite/core/cases_enumfix.cla:39` `caseFixedMathOps`, native via N28 | DELETE | claim 2 |
| N5 | `TestNativeArrWholeAssign` | native | Whole fixed-array/record-field-array/array-of-record/nested-array-element assignment (copy independence) | None — `cases_arr.cla` only covers single-element store, never whole-array assign | KEEP (contradicts spec) | — |
| N6 | `TestNativeSmokeForcedMultiSegment` | native | Forced `--seglimit` cross-segment BSR/JSR + `_LoadSeg` proof | N28/N29 already naturally multi-segment (8 and 3 segments) at the real default budget — verified by build | DELETE | claim 1 |
| N7 | `TestSmokeBounceOn68k` | native | `bounce.cla` acceptance boot; T1 `--smoke` canary | — (untouchable, target end-state + T1 canary) | KEEP | — |
| N8 | `TestAboutOn68k` | native | Apple-menu About-item dispatch (populated app-info) | `smoke_mandel`'s own app section has all 4 properties (claim 4) — merge target confirmed | MERGE→N10 | task 2/3 |
| N9 | `TestUiScenariosOn68k/smoke_menudemo` | native | Custom app-scope + window-scoped menu items, dim/undim | `cases_menus.cla` + `cases_events.cla:87` (claim 3) | DELETE | claim 3 |
| N10 | `TestUiScenariosOn68k/smoke_mandel` | native | Mandelbrot acceptance boot (fixed-point canvas render); absorbs N8's About coverage | — (target end-state) | KEEP (+ absorbs N8) | task 2/3 |
| N11 | `TestUiScenariosOn68k/opendoc` | native | `GetAppFiles`-launch dispatch, 2 docs incl. space-containing path | `texteditor.cla`'s real `App.openDocument` (claim 5) — merge target confirmed | MERGE→N14 | task 3 |
| N12 | `TestUiScenariosOn68k/opendoc_empty` | native | `App.startEmpty` fallback (no launchdoc) | Already exercised by `texteditor.events` unchanged (claim 5) | DELETE (redundant, no merge needed) | task 3 |
| N13 | `TestUiScenariosOn68k/formedit` | native | Form windows/binds/`accepted(rec)` round trip; currently pins the still-open `accepted(rec)` trailing-bool codegen bug | None until Task 2's codegen fix lands | KEEP until fixed, then MIGRATE→toolbox | task 2 |
| N14 | `TestUiScenariosOn68k/texteditor` | native | Texteditor acceptance boot (save/reopen round trip); absorbs N11/N12 | — (target end-state) | KEEP (+ absorbs N11/N12) | task 3 |
| N15 | `TestUiScenariosOn68k/texteditor_quit` | native | Multi-window quit-cascade (save-then-close, cancel-aborts-whole-quit) | Planned merge into N14's own events script (needs real script work, not automatic) | MERGE→N14 | task 3 |
| N16 | `TestUiScenariosOn68k/bookmarks` | native | Bookmarks acceptance boot (form add/edit/remove + persistence wiring) | — (target end-state) | KEEP | — |
| N17 | `TestTexteditorBigfileOn68k` | native | >32000-byte open guard (alert + close, no truncation) | Migration target: new toolbox suite case, contingent on the 128KB-stack-reserve headroom check (spec's suite-growth guardrail) | MIGRATE→toolbox (contingent on headroom) | task 5 |
| N18 | `TestRealEventLoopTickOn68k` | native | Real `WaitNextEvent` loop + real `UiTickCount` scheduling (only test in either lane not on `gVirtualTicks`) | — (untouchable, no scripted-lane equivalent possible by construction) | KEEP | — |
| N19 | `TestSuiteOn68k` | native | Byte-exact core-CLI stdout log vs host, native `App.launch` front end | 41 CoreTest cases run natively via N28; only lost signal is log-formatting parity (Decision 3) | DELETE | — |
| N20 | `TestRunErrOn68k/badenum` | native | `Protocol(0x99)` bad-enum-value panic | `testdata/runerr/badenum.behavior`, host T1 | DELETE | claim 6 |
| N21 | `TestRunErrOn68k/emptypop` | native | Pop-on-empty-list panic | `testdata/runerr/emptypop.behavior`, host T1 | DELETE | claim 6 |
| N22 | `TestRunErrOn68k/mapmiss` | native | Map-key-not-found panic | `testdata/runerr/mapmiss.behavior`, host T1 | DELETE | claim 6 |
| N23 | `TestRunErrOn68k/oob` | native | Array-bounds panic — chosen panic-machinery representative | — (kept as the representative) | KEEP | — |
| N24 | `TestRunErrOn68k/slicerange` | native | String-slice-out-of-range panic | `testdata/runerr/slicerange.behavior`, host T1 | DELETE | claim 6 |
| N25 | `TestRunErrOn68k/strindex` | native | String-index-out-of-range panic | `testdata/runerr/strindex.behavior`, host T1 | DELETE | claim 6 |
| N26 | `TestAbortOn68k/emit_array` | native | Byte-exact multi-line (6-line) pre-panic capture, abort-partway | None of N20-N25/oob has any pre-panic output (claim 6 gap) | KEEP (contradicts spec's "absorbed" framing) | — |
| N27 | `TestAbortOn68k/emit_enum` | native | Byte-exact multi-line (4-line) pre-panic capture + bad-enum-conversion panic | N26 proves the same capture-fidelity shape more strongly (6 lines vs 4); semantic enum-panic coverage is `testdata/runerr/badenum.behavior`, host T1 | DELETE | claim 6 |
| N28 | `TestCoreSuiteGUIOn68k` | native | One-boot native gate for all 42 CoreTest cases | — (untouchable, target end-state) | KEEP | — |
| N29 | `TestToolboxSuiteOn68k` | native | One-boot native gate for all 21 ToolboxTest cases (real Toolbox traps) | — (untouchable, target end-state; grows via N13/N17 migrations) | KEEP | — |
| R1 | `TestFormeditUIScenario` | Retro68 | Form windows/binds/`accepted(rec)` round trip (Retro68/cprint lane) | Pending Task 2 fix, then carried by R22's shared `toolboxFiles` composition | KEEP until fixed, then MIGRATE→R22 | task 2 |
| R2 | `TestUIAbout` | Retro68 | Apple-menu About-item dispatch (Retro68/cprint lane) | **Gap, accepted per Decision 2** — no suite GUI has an app section or clicks the Apple menu (claim 8) | DELETE (gap accepted) | — |
| R3 | `TestSmokeBounceUIScenario` | Retro68 | Bounce acceptance boot (Retro68/cprint lane) | `cases_canvas.cla` generic canvas Toolbox path, via R22 (claim 8); example-specific proof stays native-only (N7) | DELETE | — |
| R4 | `TestSmokeMenuDemoUIScenario` | Retro68 | Menu items/dim-undim (Retro68/cprint lane) | `cases_menus.cla` + `cases_events.cla:87`, via R22 (claim 3/8) | DELETE | claim 3 |
| R5 | `TestSmokeMandelUIScenario` | Retro68 | Mandelbrot canvas render (Retro68/cprint lane) | `cases_canvas.cla` generic path, via R22; example-specific render progression stays native-only (N10) | DELETE | — |
| R6 | `TestOpenDocUIScenario` | Retro68 | `GetAppFiles`-launch dispatch (Retro68/cprint lane) | **Gap, accepted per Decision 2** — no suite case exercises doc-launch (claim 8); coverage moves to native-only via N14 | DELETE (gap accepted) | — |
| R7 | `TestOpenDocEmptyUIScenario` | Retro68 | `App.startEmpty` fallback (Retro68/cprint lane) | Same gap as R6 — moves to native-only via N14 | DELETE (gap accepted) | — |
| R8 | `TestTexteditorUIScenario` | Retro68 | Texteditor save/reopen round trip (Retro68/cprint lane) | `cases_textwidgets.cla` + `cases_dialogs.cla` generic Toolbox paths, via R22 | DELETE | — |
| R9 | `TestTexteditorQuitUIScenario` | Retro68 | Multi-window quit-cascade (Retro68/cprint lane) | Same as R8; example-specific cascade stays native-only (N14/N15) | DELETE | — |
| R10 | `TestTexteditorBigfileUIScenario` | Retro68 | >32000-byte open guard (Retro68/cprint lane) | Same as R8; if migrated to a toolbox case (N17), carried by R22 automatically (shared composition) | DELETE (or absorbed by R22 if N17 migrates) | task 5 |
| R11 | `TestBookmarksUIScenario` | Retro68 | Bookmarks form/persistence (Retro68/cprint lane) | `cases_dialogs.cla` (real file I/O) + form-pattern cases, via R22; example-specific wiring proof stays native-only (N16) | DELETE | — |
| R12 | `TestSuiteOnMac` | Retro68 | Byte-exact core-CLI stdout log vs host (Retro68/cprint lane) | 41 CoreTest cases run via R21; log-format-only loss (Decision 3) | DELETE | — |
| R13 | `TestRunErrOnMac/badenum` | Retro68 | Bad-enum-value panic (Retro68/cprint lane) | `testdata/runerr/badenum.behavior`, host T1 | DELETE | claim 6 |
| R14 | `TestRunErrOnMac/emptypop` | Retro68 | Pop-on-empty-list panic (Retro68/cprint lane) | `testdata/runerr/emptypop.behavior`, host T1 | DELETE | claim 6 |
| R15 | `TestRunErrOnMac/mapmiss` | Retro68 | Map-key-not-found panic (Retro68/cprint lane) | `testdata/runerr/mapmiss.behavior`, host T1 | DELETE | claim 6 |
| R16 | `TestRunErrOnMac/oob` | Retro68 | Array-bounds panic — chosen panic-machinery representative | — (kept as the representative) | KEEP | — |
| R17 | `TestRunErrOnMac/slicerange` | Retro68 | String-slice-out-of-range panic (Retro68/cprint lane) | `testdata/runerr/slicerange.behavior`, host T1 | DELETE | claim 6 |
| R18 | `TestRunErrOnMac/strindex` | Retro68 | String-index-out-of-range panic (Retro68/cprint lane) | `testdata/runerr/strindex.behavior`, host T1 | DELETE | claim 6 |
| R19 | `TestAbortAppsOnMac/emit_array` | Retro68 | Byte-exact multi-line (6-line) pre-panic capture (Retro68/cprint lane) | None of R13-R18/oob has pre-panic output (claim 6 gap) | KEEP (contradicts spec's "absorbed" framing) | — |
| R20 | `TestAbortAppsOnMac/emit_enum` | Retro68 | Byte-exact multi-line (4-line) pre-panic capture (Retro68/cprint lane) | R19 proves the same shape more strongly; semantic coverage is `badenum.behavior`, host T1 | DELETE | claim 6 |
| R21 | `TestCoreSuiteGUIOnMac` | Retro68 | One-boot Retro68/cprint gate for all 42 CoreTest cases | — (untouchable, target end-state) | KEEP | — |
| R22 | `TestToolboxSuiteOnMac` | Retro68 | One-boot Retro68/cprint gate for all 21 ToolboxTest cases (real Toolbox traps) | — (untouchable, target end-state; grows via R1/R10 migrations) | KEEP | — |

## Tally

- **KEEP:** 16 — N2, N3, N5, N7, N10, N13(until fixed), N14, N16, N18,
  N23, N26, N28, N29, R1(until fixed), R16, R19, R21, R22 (18 counting
  both "KEEP until fixed" rows as KEEP; see note below)
- **DELETE:** 26 — N1, N4, N6, N9, N12, N15(as standalone, see MERGE),
  N19, N20, N21, N22, N24, N25, N27, R2, R3, R4, R5, R6, R7, R8, R9, R11,
  R12, R13, R14, R15, R17, R18, R20
- **MERGE→<target>:** 4 — N8→N10, N11→N14, N15→N14, R10→R22 (contingent)
- **MIGRATE→<suite case>:** 2 (contingent) — N13/R1→toolbox `formedit`
  case (Task 2), N17/R10→toolbox `texteditor_bigfile` case (Task 5,
  headroom-contingent)

(N13/R1 are counted once each as "KEEP until fixed, then MIGRATE" —
listed under both KEEP and MIGRATE above since their fate is
conditional on Task 2's codegen fix landing; treat them as MIGRATE for
planning purposes, KEEP for right now.)

**Net effect if every non-contingent verdict lands:** native lane
29 → 29 - (N1,N4,N6,N9,N12,N15,N19,N20,N21,N22,N24,N25,N27 = 13 dropped,
N8/N11 merged away = 2 more) = **14** (not the spec's ~8-10, because
[N2]/[N3]/[N5] survive and [N26] survives alongside [N23]/[N29] — see
contradictions below); Retro68 lane 22 → 22 - 19 dropped (all but R1,
R16, R19, R21, R22) = **5** (not the spec's target 3, because R1 stays
open pending Task 2 and R19 survives per claim 6). Both lane totals will
shrink further once Task 2 lands (R1/N13 migrate away) and if a later
task edits a runerr fixture to genuinely absorb N26/R19 per claim 6's
recommendation.

## Verdicts that contradict the spec's target list

1. **[N2] `TestNativeSmoke`, [N3] `TestNativeStrContainers`, [N5]
   `TestNativeArrWholeAssign`** — spec listed all three as pending
   deletion; audit found genuine unique native-codegen coverage in each
   (file-section edge cases; >4-byte list-element container ops + expr-
   position slice + computed map key; whole-fixed-array/record-field/
   array-of-record/nested-array assignment) with zero `testsuite/core`
   equivalent. **KEEP all three**, or open a follow-up migration task to
   port the specific missing assertions into `cases_ser.cla`/
   `cases_list.cla`/`cases_map.cla`/`cases_arr.cla` before revisiting
   deletion.
2. **[N9]/[R4] `smoke_menudemo`** — spec offered only "MIGRATE if not
   covered" or "KEEP, not DELETE"; audit found it IS already covered
   (`cases_menus.cla` + `cases_events.cla`'s `MenuKeyMatches`), so the
   correct verdict is a plain **DELETE**, not a migration.
2b. Note also that `smoke_menudemo.events` never actually presses a
   keyboard shortcut (only `menu` verb lines) — the scenario's own name
   overclaims shortcut coverage it never tested.
3. **`cli_mac.cla`** — spec implied it might retire alongside
   [N19]/[R12]; audit found `internal/cg68k/segment_test.go:72`
   (host-side, T1, out of phase scope) depends on it independently.
   **`cli_mac.cla` must NOT be deleted** by this phase.
4. **Abort apps ([N26]/[R19] `emit_array`, [N27]/[R20] `emit_enum`)** —
   spec's target end-state assumed the single panic-machinery boot per
   lane would absorb the abort apps' byte-exact-capture coverage; audit
   found none of the 6 runerr fixtures has any pre-panic output, so no
   choice of representative achieves that absorption as fixtures stand
   today. **One abort app per lane (`emit_array`) survives** unless a
   later task edits a runerr fixture to add pre-panic `alert()` lines.
5. **[R2] `about`, [R6]/[R7] `opendoc`/`opendoc_empty`** — not
   contradictions of the spec's explicit decisions (Decision 2 already
   anticipated Retro68-lane coverage loss for example-specific behavior),
   but the audit makes the resulting gaps explicit and named rather than
   implicit: after this phase, About-item dispatch and `GetAppFiles`
   doc-launch have **zero Retro68/real-Toolbox boot coverage**, native-
   lane-only. Recorded here so it's a documented trade-off, not a silent
   regression.
