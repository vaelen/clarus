# UI Scenario Retirement — Design

Date: 2026-08-05
Status: Approved (Andrew, 2026-08-05)
Prerequisite context: test-suite-review design
(`2026-08-03-test-suite-review-design.md`), whose "Migration strategy for
the 23 UI golden scenarios" section this phase executes: scenarios retire
one by one when a toolbox case demonstrably subsumes them.

## Goal

Migrate the 13 widget/window-behavior scenarios of the legacy 23-scenario
scripted UI golden lane into the Clarus-native toolbox suite (one boot per
lane, self-reporting PASS/FAIL), and delete each retired scenario's
fixtures/goldens/harness entries. End state: the scripted lane keeps only
the 10 app-level scenarios; gated mactest drops ~26 emulator boots.

## Why

- **The classic-Mac end goal (Andrew, 2026-08-05):** the test suite must
  eventually run FROM a classic Mac. The toolbox suite framework
  (in-process cases, tkReport log, self-contained checksums) is the only
  vehicle that exists in that world — no Go harness, no LaunchAPPL, no
  host filesystem for PBM goldens. Every scenario migrated is coverage
  that survives on real hardware.
- T2 cost: the scenario lane is ~46 of gated mactest's ~60 boots
  (23 scenarios × 2 lanes); migrating 13 removes ~26 boots.
- The migration strategy was recorded in the test-suite-review design and
  deliberately left for a later phase. This is that phase.

## Scenario disposition (all 23, explicit)

**Migrate (13):** buttons, menus, textwidgets, canvas, zoomwin, hscroll,
pattern, hdim, winvar, editmenu, dialogs, popuptable, formedit.

**Keep in the scripted lane (10, app-level — whole-app properties the
suite cannot express as callable cases, per the test-suite-review
design's "What stays OUTSIDE the two suites"):** UIAbout (about),
smoke_bounce, smoke_menudemo, smoke_mandel, opendoc, opendoc_empty,
texteditor, texteditor_quit, texteditor_bigfile, bookmarks. These retain
their trace + full-frame PBM goldens and remain the pixel-fidelity and
whole-app backstop. The real-event-loop tick test
(`TestRealEventLoopTickOn68k`) also stays untouched.

## Component 1: `runtime/clarus/uitest.cla` (new runtime module)

A public test-driver API in pure runtime Clarus (identical behavior on
the Retro68/cprint lane, the native cg68k lane, and real hardware),
routing through the existing `uiscript.cla` verb dispatcher:

- `UiTestVerb(line: string): bool` — execute one script-verb line
  synchronously, then pump passive events (the engine's per-line
  `rtUiPumpPassive` behavior). Returns false on unknown verb or dispatch
  failure so cases can `tkFail` — never the script engine's `quit 1`
  (case code must not kill the suite boot).
- Convenience wrappers over the same path: `UiTestClick(x, y)`,
  `UiTestDblClick(x, y)`, `UiTestKey(k)`, `UiTestType(s)`,
  `UiTestMenu(m, i)`, `UiTestClose()`, `UiTestResize(w, h)`,
  `UiTestZoom()`, `UiTestTick(n)`, `UiTestAnswerOpen(path)`,
  `UiTestAnswerSave(path)`, `UiTestAnswerChanges()`,
  `UiTestAnswerCancel()`, `UiTestAnswerPopup(n)`. Exact wrapper set may
  shrink at plan time to the verbs the 13 migrations actually use
  (YAGNI); `UiTestVerb` is the escape hatch.
- `UiTestChecksum(x, y, w, h): int` — screen-region checksum via the
  proven CanvasChecksum mechanism (`ScrnBase` low-memory read + `peekb`
  sum), generalized. Byte-aligned x/w only (the determinism rule that
  makes checksums exact); the plan defines the alignment contract
  (documented requirement + debug-friendly failure, decided at plan
  time).
- `UiTestTick(n)`: advances virtual ticks when the app runs in scripted
  mode (CI boots driven by `--events`), pumps the real event loop with
  real TickCount waits otherwise (a human running the suite on real
  hardware) — cases behave identically in both worlds.
- Ships via the implicit-inclusion manifest (`--rtdir` machinery) keyed
  on usage, like every runtime module — programs that never call
  `UiTest*` never link it.

Fidelity statement (recorded, honest): `UiTestVerb` drives the same
dispatch layer the retiring scenarios drove (`uiscript.cla`); migrated
cases therefore assert exactly what the goldens proved, no more. Events
do not transit the real `GetNextEvent` queue — that fidelity is covered
separately by Component 3 and the existing real-event-loop test.

## Component 2: suite growth — 13 scenarios become toolbox cases

- Harness `window` types live in a new `testsuite/toolbox/harness.cla`
  (transcribed from the retiring `testdata/ui/*.cla` fixtures); cases in
  new `testsuite/toolbox/cases_*.cla` family files. A case opens its
  harness window, drives it via `UiTest*`, asserts, closes it — one
  suite boot hosts all of them (open/close of many window instances in
  one run is established language surface, Ch5/Ch8).
- Assertion translation rules (the "demonstrably subsumes" mapping):
  - Trace-line assertions (handler fired / fired in order / did NOT
    fire) → harness-window state: counter/log `var`s mutated by the
    handlers, asserted by the case.
  - Snap-pair assertions (S1≠S2 moved, S1==S3 restored, row added…) →
    `UiTestChecksum` values compared to each other.
  - Golden-PBM-is-the-assertion scenarios (pattern, hdim, winvar) →
    pinned checksum constants, recorded via CanvasChecksum's documented
    FAIL-then-copy procedure.
  - dialogs' real file round-trip stays a real round-trip (boot volume,
    like TestLog.txt).
- `ToolboxTest` enum grows accordingly (~20+ real cases); `SelfCheck`'s
  `nTbCases` arithmetic updates in the same commit as each case batch;
  the GUI table lists everything; `toolboxsuite.events` stays a
  click-RunAll-quit script (re-derive the click coordinate only if the
  window layout changes).
- Case-code conventions carried from the existing suite: piecewise
  string building (cg68k temp-slot budget), each case declaring its own
  local externs where it needs traps directly, checksum regions byte-
  aligned by layout construction.
- `internal/mactest/coresuite_test.go` needs no structural change — it
  parses the log and fans per-case subtests automatically.

## Component 3: PostEvent fidelity sentinel (one new case)

`PostEventClick`: local externs per the suite's proven pattern —
`PostEvent` (`trap 0xA02F`, OS/register convention, bit 11 clear; exact
clause per the bit-11 rule recorded in ROADMAP) plus pokes to the
low-memory mouse globals (`MTemp` 0x828, `RawMouse` 0x82C, `CrsrNew`) to
position the cursor — posts a real mouse-down/up pair through the system
event queue and lets the REAL event loop deliver it to a harness button;
asserts the handler fired. This is real-queue coverage the scripted lane
never had. It complements the real-event-loop tick test; it does not
replace anything, and no migration depends on it.

## Component 4: retirement mechanics

In the SAME task that lands a scenario's replacement case(s):

- Delete: its `testdata/ui/<s>.cla` fixture (where fixture-based — the
  13 all are), `<s>.events`, `<s>.trace`, `testdata/uisnaps/<s>.*.pbm`,
  its `ui_test.go` test function + helpers no other scenario shares, and
  its `native_test.go` `uiScenarios68k` table entry.
- The task report enumerates the retired scenario's assertions (from its
  fixture, events script, and check helper) beside the case assertion
  that subsumes each — the reviewer's checklist. A scenario with an
  assertion the case cannot express does NOT retire until it can
  (escalate, don't drop coverage silently).
- Retirement is per-scenario and immediate (Andrew, 2026-08-05: no soak
  period, no extra widget sentinels — the 10 app-level survivors are the
  pixel backstop).

## Verification and gates

- Per task: toolbox suite boots green on BOTH lanes
  (`TestToolboxSuiteOn68k`/`OnMac`, gated) with the new cases; T1 green.
- Phase boundaries: full T2; record before/after gated-mactest
  wall-clock (expected drop ~26 boots' worth).
- The migration must not change any surviving golden: the 10 app-level
  scenarios' traces/PBMs stay byte-identical throughout.
- `uitest.cla`'s own coverage: a `UiTestVerbSmoke`-class case (drive a
  harness button via `UiTestClick`, assert the counter) lands with the
  machinery, before any migration depends on it.

## Error handling

- `UiTestVerb` returns false (case fails via `tkFail`) instead of the
  engine's `quit 1` on unknown verbs.
- `UiTestChecksum` on a misaligned region: defined failure per the plan's
  alignment contract — never a silent wrong sum.
- A case that opens a harness window must close it on every path
  (including failure paths) so later cases start from a clean screen; the
  plan pins the idiom.

## Out of scope (recorded follow-ups)

1. **Launch-an-application-from-Clarus** (Andrew, 2026-08-05): a function
   to launch another app from inside Clarus so the on-Mac suite can
   exercise the example apps (mandelbrot, texteditor, …) directly.
   Honest platform note: System 6's `_Launch` REPLACES the running
   application (no MultiFinder supervision), so suite-launches-app needs
   its own design (sub-launch conventions, result handoff via file,
   relaunch-the-suite chaining, or System 7/MultiFinder gating).
   Sequenced after this phase, once the migrations have landed.
2. The 10 app-level scenarios' eventual fate rides on (1) — not this
   phase.
3. The 2b character/byte-type surface review remains queued after this
   work (roadmap order amended by Andrew's request to run this phase
   now).
4. No `clarusc` compiler changes are expected. If a migration surfaces a
   compiler gap, it escalates per the standing freeze-era convention
   (Andrew authorizes explicitly; this phase does not amend the compiler
   silently).
