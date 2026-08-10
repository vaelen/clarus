# Session status — 2026-08-11 (datetime + compiler instrumentation)

Handoff summary for the next session. Branch: `worktree-native-perf-findings`
(stacked on unmerged `mac-resident-clarusc` → `map-hashtable`, pushed to
origin, **not merged** — merge is Andrew's call).

## Why this session happened

`ClarusC.APPL` compiles take hours with zero feedback — a user can't tell a
working compile from a hang. This session (1) gave clarusc a way to read the
clock (the language had none) and (2) wired always-on progress + per-phase
`TickCount()` instrumentation through that new capability, the "instrument
first" step the native-compiler performance findings doc calls for.

## 1. datetime-instrumentation phase (IMPLEMENTED, this branch)

Spec: `docs/superpowers/specs/2026-08-10-datetime-instrumentation-design.md`;
ledger: `.superpowers/sdd/2026-08-10-datetime-instrumentation/progress.md`
(12 tasks, all review-clean; commits `8ee003f..c00188f`). Full detail in the
ROADMAP phase entry — summary here:

- **Three new builtins, no new type:** `now(): int`, `dateTimeStr(t: int):
  string`, `durationStr(secs: int): string`. A datetime is a plain `int` —
  unsigned Mac-epoch local seconds, landing as a negative signed value for
  every realistic clock reading (documented, safe: subtraction and ordering
  are correct within the 1972-2040 half-range; all calendar decomposition
  happens in ROM/C glue, never in Clarus arithmetic).
- **Toolbox catalog** (`toolbox/osutils.cla`): Date-Time Utilities added
  (`DateTimeRec`, `ReadDateTime`, `SecondsToDate`, `DateToSeconds`;
  `SetDateTime` deliberately absent) with the bit-11 `GetDateTime`-is-inline-
  glue exception documented in both the reference and provenance comments.
- **Runtime module** `datetime.cla` + lane variants: native reads the
  low-memory `Time` global directly (`peekl(0x020C)`, zero-cost); both C
  lanes call `rt_ext` glue. `dateTimeStr` lane-identity pinned by shared
  test vectors across the unsigned range.
- **Instrumentation:** new `feProgress` seam (`main.cla` → stderr;
  `macgui.cla` → buffered Log-textview flush on every `gcCompile` exit),
  driving `Starting`/`Compiling`/`Included` (heartbeat through all ~17
  spliced runtime modules)/`Loading runtime`/9 phase-completion
  lines/`Compiled`/`Finished`. **Gated on `want68k` ONLY** — every Class-A
  byte-golden (`TestErrorGoldens`, `reftest`, `claruscboot`, `emitui`,
  `perfgate`) stayed green throughout; fork bytes proven byte-identical
  (matched-basename methodology).
- **Two snapshot regenerations** (Stage A `c980554`, Stage B `c00188f`),
  fixed point held both times.
- **Suite growth:** core 54 → 57 (`DurationStrShapes`/`DateTimeStrVectors`/
  `NowSanity`); toolbox 28 → 29 (`DateTimeRoundTrip`). Emulator:
  `TestCoreSuiteGUIOn68k` + `TestToolboxSuiteOn68k` both PASS first attempt
  (40.6s total) — the phase's ONLY emulator runs, by explicit narrow-scope
  decision.

### Debt / deferrals (all recorded in the ROADMAP entry)

- Live Mac Log-window painting mid-compile → deferred spec
  `docs/superpowers/specs/2026-08-10-clarusc-mac-live-log-design.md`,
  scheduled after more Layer-1 perf work.
- Instrumented on-Mac compile timing capture (the measurement run that
  converts the perf findings doc's memory-proxy ranking into real 68k
  ticks) still pending.
- Host `rt_ext` glue for the catalog's Date-Time names unadded (nothing
  host-side calls them yet).
- `rt_ext_mac.inc` Date-Time glue header-verified, not Retro68-compiled
  (opt-in cprint lane not run this phase).
- `TestToolboxSuiteOn68k`'s pre-existing stale "25 result lines" doc
  comment (`internal/mactest/coresuite_test.go:260`) — predates this
  phase, now doubly stale at 29; not fixed (out of this phase's docs-sweep
  scope).
- **T2 (`scripts/test-merge.sh`) still owed before any merge** — standing
  debt from the map-hashtable phase, now covering this phase too.

## 2. Prior phase context (still true, unchanged this session)

- **map/sortedmap/intmap** (map-hashtable phase, done 2026-08-10): `map of
  T` is a real hashtable on both lanes; `sortedmap of T` preserves the old
  ascending-order contract; `intmap of T` replaced the compiler's own
  `numToStr`-keyed internal tables. Host emit perf tripwire regression
  fixed (~1.1-1.5s → 0.205s median). Full detail: ROADMAP's map-hashtable
  entry.
- **Snow acceptance run (mac-resident-clarusc):** last run FAILED with a
  milestone — compile #1 succeeded on real Mac hardware (full-size fork,
  not a husk); compile #2 died OOM in a 48MB partition. That run used the
  PRE-hashtable runtime; rebuilding `ClarusC.APPL` from this branch (which
  now includes both the hashtable fix AND the new instrumentation) and
  rerunning is still the next decisive experiment — the instrumentation
  built this session means a rerun will, for the first time, show visible
  progress instead of an opaque hang.

## Recommended next steps (in order)

1. **Rebuild `ClarusC.APPL` from THIS branch and rerun the Snow
   acceptance.** Now carries both the map-hashtable fix and the progress
   instrumentation — the rerun should show live stderr/log progress lines
   even before addressing the OOM.
2. Use the new instrumentation for its intended purpose: capture real
   on-Mac per-phase `TickCount()` timings, converting the performance
   findings doc's memory-derived ranking into fact.
3. Next perf targets from the findings doc (Layer 1): `keywordKind`
   pre-interned constants (~10× lexing), `cgHeurOnCycle` adjacency+SCC,
   codegen lookup maps + `cgSizeOf` memo, `a68Comment` gating, single
   codegen pass.
4. Land the deferred live-log-window spec
   (`2026-08-10-clarusc-mac-live-log-design.md`) once scheduled.
5. Run T2 (`scripts/test-merge.sh`) before any merge to main; expect
   possible module-golden churn (standing debt, both phases).
6. Merge decisions (Andrew's): `mac-resident-clarusc` still gated on a
   Snow acceptance PASS; `map-hashtable` and `datetime-instrumentation`
   are both review-approved and stacked on top of it.
