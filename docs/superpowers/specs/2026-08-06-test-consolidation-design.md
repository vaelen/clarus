# Test-consolidation phase (emulator-boot audit and reduction)

**Date:** 2026-08-06
**Status:** approved (Andrew, 2026-08-06)
**Sequel to:** ui-scenario-retirement (2026-08-05) — same audit-first
discipline, now applied to the whole gated boot inventory.

## Problem

The gated `internal/mactest` suite performs **51 full Mini vMac boots**
(29 native `emit68k` lane, 22 Retro68/cprint lane; ~381s in the last T2).
The set accreted phase by phase: 5d bring-up rungs (Hello, NativeSmoke,
StrContainers, FixedOps, ArrWholeAssign), per-fixture panic apps (6 runerr
+ 2 abort, per lane), scripted UI scenarios that predate the suites, and
the core suite booting four separate ways (CLI and GUI front ends × two
lanes). Most of these now duplicate coverage the two in-process suites
(`testsuite/core`, 41 cases; `testsuite/toolbox`, 20 cases) provide in one
boot each per lane. The standing project lesson cuts both ways: boots are
the only test kind that has caught real-mode trap-convention and
heap-corruption bugs — so deletions need per-boot audit evidence, not
vibes; but boots whose unique coverage is provably elsewhere are pure cost.

## Decisions (Andrew, 2026-08-06)

1. **`accepted(rec)` trailing-`bool` native codegen fix is IN SCOPE.** The
   bug (a form's `accepted(rec)` event silently reverts a bound trailing
   `bool` field to `false` on native 68k — ROADMAP open item, found
   2026-08-05) is the only reason `formedit` is still a scripted scenario.
   Fix it, pin it, migrate formedit.
2. **Example-app acceptance boots run on the native lane only.** Native
   (`emit68k`) is the shipping toolchain; acceptance means "the apps work
   as we ship them." The Retro68 lane keeps real-Toolbox coverage of the
   same ported runtime via its suite boots.
3. **Mac-lane CLI boots are dropped entirely** (`TestSuiteOnMac`,
   `TestSuiteOn68k`). The CLI exists to make the compiler and tools run
   well on HOST systems; 68k headless apps are a by-product, not a goal.
   Both boots run the same 41 core cases the GUI suite boots already run
   per lane — the only lost signal is byte-exact stdout parity of the test
   log (formatting, not semantics; every case asserts its own values via
   `tkReport`). The host CLI (`cli.cla`, T1's `suite_host_test.go` oracle)
   is untouched and remains the CLI story. The audit decides whether
   `cli_mac.cla` (the Mac wrapper that exists only because `cli.cla`
   cannot boot natively) retires with them. The ROADMAP's known-broken
   native `App.startCLI` row stays open but is explicitly de-prioritized,
   with this rationale recorded.

## Target end state (~13 boots; the audit can veto any line)

**Native lane (~8-10):**
- Core suite GUI (1) and toolbox suite GUI (1) — the toolbox suite grown
  by the migrated `formedit` case and a new `texteditor_bigfile` case.
- Example-app acceptance boots (4-5): `smoke_bounce`, `smoke_mandel`
  (mandelbrot), `texteditor` (with `texteditor_quit` and the
  `opendoc`/`opendoc_empty` doc-launch coverage merged into its event
  script), `bookmarks`, and `about` folded into an app-sectioned example's
  script if the audit confirms coverage matches (else kept standalone).
- `TestRealEventLoopTickOn68k` (1) — untouchable: the only test in either
  lane exercising the real `WaitNextEvent` loop and real tick scheduling.
- One panic-machinery boot (1): a representative runerr fixture proving
  trap → capture-log message → exit-code-3 plumbing, absorbing the abort
  apps' abort-partway/byte-exact-capture coverage. Fixture chosen in the
  audit.
- `TestNativeSmokeForcedMultiSegment` (0-1): deleted only if the audit
  confirms the composed suite app is already naturally multi-segment
  (JT/segmentation codegen must stay exercised somewhere).

**Retro68/cprint lane (3):**
- Core suite GUI (1), toolbox suite GUI (1), one panic-machinery boot (1).

**T1 `--smoke` unchanged:** `TestSmokeBounceOn68k` +
`TestRealEventLoopTickOn68k` stay the fast canaries (same fixtures as
above, no extra maintenance surface).

## Deletions (each contingent on its audit row)

Native: `TestHelloOn68k`, `TestNativeSmoke`, `TestNativeStrContainers`,
`TestNativeFixedOps`, `TestNativeArrWholeAssign` (each pending a
unique-assertion check — some pin capture-protocol details),
`TestSuiteOn68k`, 5 of 6 runerr boots, both abort boots,
`smoke_menudemo` (menus must be confirmed toolbox-suite-covered),
`opendoc`/`opendoc_empty`/`texteditor_quit`/`texteditor_bigfile` as
standalone boots (merged or migrated), `TestAboutOn68k` if folded.

Retro68: all 11 `ui_test.go` scenario boots (suites + native examples
carry their coverage), `TestSuiteOnMac`, 5 of 6 runerr boots, both abort
boots.

Fixture hygiene follows ui-scenario-retirement precedent: a deleted
scenario's `.events`/trace/PBM goldens and any orphaned fixtures
(`opendoc.cla`, possibly `cli_mac.cla`, retired runerr/abort wrappers'
Mac-lane artifacts) are deleted in the same commit as the test that used
them. Host-side `.behavior` goldens for runerr semantics stay — they are
what licenses cutting the per-fixture panic boots.

## The audit (phase backbone, first task)

A committed per-boot table — one row per current boot: **what it uniquely
executes** (including real-mode trap paths and codegen shapes, not just
feature semantics) / **where else that is covered** / **verdict**
(delete / merge-into-X / migrate / keep, with citation). Modeled on
ui-scenario-retirement's 15-row audit. The audit verdict overrides this
spec's target list — nothing is deleted on the strength of this spec
alone. Rows that flip a target-list line (e.g. ForcedMultiSegment must
stay; menudemo menus not actually suite-covered) are decisions recorded
in the table, not silent deviations.

## Codegen fix task (`accepted(rec)` trailing bool)

Systematic-debugging task against cg68k's form-writeback path (the uiblob
Layout is lane-correct — small-scalar-width and strn-field-alignment both
audited it — so the suspect is the native accept/writeback codegen, e.g.
a stale width assumption in the poke path). Deliverables: root cause, fix,
and a toolbox-suite `formedit` case that FAILS under the re-introduced bug
(tickprobe precedent) before the scripted `formedit` scenario and its
fixtures are deleted.

## Suite-growth guardrail (`texteditor_bigfile`)

The composed toolbox suite already needed the 128KB
`cgStartupStackReserve`; a 32k text fixture adds real heap pressure. The
migration task measures memory headroom on the 4MB-Plus boot before
committing; if it does not fit comfortably, `texteditor_bigfile` stays a
standalone native boot and the audit table records why.

## Sequencing within the phase

1. Audit table (committed first — the evidence base).
2. Codegen fix + formedit migration; `texteditor_bigfile` migration (with
   headroom check); any other audit-mandated coverage lands (e.g. a menu
   case if menudemo's coverage is not already in the toolbox suite).
3. Deletions, each commit citing its audit rows; fixtures retire
   same-commit.
4. Re-baseline: T2 timing note, ROADMAP Done entry, CLAUDE.md test-suite
   section updated to the new inventory (per-test docs live in the test
   files themselves).

## Success criteria

- Gated boot count ~51 → ~13, each survivor with a one-line stated purpose
  in the audit table.
- T2 green pre-merge at the new baseline (expect roughly half the current
  381s gated-mactest wall clock; record actual).
- No coverage regression by construction: every deletion commit cites the
  audit row naming where its unique coverage now lives.
- `formedit` codegen bug fixed and suite-pinned; scripted lane shrinks to
  the example-app acceptance set only.

## Out of scope

- Host-side (non-boot) test surface (suite_host, hostrt, sertest, emitui,
  cg68k listings, selfhost) — untouched.
- The launch-an-application-from-Clarus design (ROADMAP open item) — the
  example-app boots keep using per-app LaunchAPPL boots until that exists.
- Native `App.startCLI` stub repair (de-prioritized per Decision 3).

## Outcome (2026-08-06)

Gated `internal/mactest` boot inventory: **51 → 16** (native `emit68k`
lane 29 → 12, Retro68/cprint lane 22 → 4) — better than this spec's own
~13 target, because both contingent migrations (`formedit`,
`texteditor_bigfile`) landed, collapsing the audit's own worst-case
projection of 14 native / 5 Retro68 down by one boot each. Evidence base
for every row: `docs/superpowers/specs/2026-08-06-test-consolidation-
audit.md` (29 native + 22 Retro68 rows, `N1`-`N29`/`R1`-`R22`).

T2 gated-`internal/mactest` wall clock: 380.7s pre-phase → 246s
mid-phase (Task 6) → **171s final** (both lanes, 16 boots, all green) —
roughly 55% faster than the pre-phase baseline despite the toolbox suite
itself growing by two cases (`FormEdit`, `BigText`).

### Final boot table

**Native (`emit68k`) lane — 12:**

| Test | Audit row | Purpose |
|---|---|---|
| `TestNativeSmoke` | N2 | Records/enums/containers/text baseline + file-section edge cases (>32KB chunked read, missing-file `lastError`, `e = lastError` local-copy codegen) — KEEP, contradicts spec |
| `TestNativeStrContainers` | N3 | `list of string(N)` (>4-byte element) container ops; string-literal slice in expression position; map key from a computed expression — KEEP, contradicts spec |
| `TestNativeArrWholeAssign` | N5 | Whole fixed-array / record-field-array / array-of-record / nested-array-element assignment, copy independence — KEEP, contradicts spec |
| `TestSmokeBounceOn68k` | N7 | `bounce.cla` acceptance boot; T1 `--smoke` canary |
| `TestRealEventLoopTickOn68k` | N18 | Real `WaitNextEvent` loop + real `UiTickCount` scheduling — the only test in either lane not on `gVirtualTicks` |
| `TestRunErrOn68k/oob` | N23 | Array-bounds panic — the chosen panic-machinery representative |
| `TestAbortOn68k/emit_array` | N26 | Byte-exact multi-line (7-line) pre-panic capture, abort-partway — KEEP, contradicts spec's "absorbed" framing |
| `TestCoreSuiteGUIOn68k` | N28 | One-boot native gate for all 42 `CoreTest` cases |
| `TestToolboxSuiteOn68k` | N29 | One-boot native gate for all 23 `ToolboxTest` cases (real Toolbox traps), grown via the `formedit`/`texteditor_bigfile` migrations |
| `TestUiScenariosOn68k/smoke_mandel` | N10 | Mandelbrot acceptance boot (fixed-point canvas render); absorbs N8's About-item-dispatch coverage |
| `TestUiScenariosOn68k/texteditor` | N14 | Texteditor acceptance boot (save/reopen round trip); absorbs N11/N12/N15 (`opendoc`/`opendoc_empty`/`texteditor_quit`) |
| `TestUiScenariosOn68k/bookmarks` | N16 | Bookmarks acceptance boot (form add/edit/remove + persistence wiring) |

**Retro68/cprint lane — 4:**

| Test | Audit row | Purpose |
|---|---|---|
| `TestRunErrOnMac/oob` | R16 | Array-bounds panic — the chosen panic-machinery representative (Retro68/cprint lane) |
| `TestAbortAppsOnMac/emit_array` | R19 | Byte-exact multi-line (7-line) pre-panic capture (Retro68/cprint lane) — KEEP, contradicts spec's "absorbed" framing |
| `TestCoreSuiteGUIOnMac` | R21 | One-boot Retro68/cprint gate for all 42 `CoreTest` cases |
| `TestToolboxSuiteOnMac` | R22 | One-boot Retro68/cprint gate for all 23 `ToolboxTest` cases (real Toolbox traps), grown via the `formedit`/`texteditor_bigfile` migrations |

### Deviations from the target list (each an audit override, not a silent call)

1. **KEEP `TestNativeSmoke`/`TestNativeStrContainers`/`TestNativeArrWholeAssign`** (audit rows N2/N3/N5, claim 2) — the spec's target list tentatively marked all three for deletion; the audit found genuine native-codegen coverage with zero `testsuite/core/cases_*.cla` equivalent in each, so all three survive.
2. **One abort app per lane kept** (audit rows N26/R19, claim 6) rather than fully absorbed into the single runerr representative as the spec's target end-state assumed — none of the 6 runerr fixtures has any pre-panic output, so `emit_array`'s byte-exact multi-line pre-panic capture has no other home without a fixture edit out of this phase's scope.
3. **`smoke_menudemo` plain DELETE, not a migration** (audit rows N9/R4, claim 3) — the spec offered only "MIGRATE if not covered" or "KEEP"; the audit found it already fully covered by `cases_menus.cla` + `cases_events.cla`'s `MenuKeyMatches`, so the correct verdict was a plain delete.
4. **`cli_mac.cla` (the file) retained** (audit claim 7) even though its own boots (`TestSuiteOn68k`/`TestSuiteOnMac`, audit rows N19/R12) were deleted — `internal/cg68k/segment_test.go` depends on it independently, host-side, out of this phase's scope.
5. **`about` and `opendoc`/`opendoc_empty` Retro68-lane coverage gaps made explicit** (audit rows R2/R6/R7, claim 8) — not a contradiction of Decision 2 (which already anticipated this loss), but the audit names the resulting gaps rather than leaving them implicit: About-item dispatch and `GetAppFiles` doc-launch have zero Retro68/real-Toolbox boot coverage after this phase, native-lane-only. `testdata/ui/about.cla` (the file) is separately retained regardless, since `internal/mactest/resparity_test.go`'s `about_noicon` case depends on it independently of the scenario's own retirement.
