# Session status — 2026-08-18 (correctness-cleanup: MERGED to main and pushed)

Handoff summary. **The `correctness-cleanup` phase is COMPLETE and
MERGED — all 12 tasks landed, T1 (`--smoke` where applicable) green
throughout, the bootstrap snapshot regenerated and re-verified (fixed
point reached), and full T2 (`scripts/test-merge.sh`) PASS end-to-end
at the tip, including the new `TestToolboxSuiteJiggleOn68k` gated
native boot. Merged to `main` (ff `48a4696..3a4c054`) and pushed to
origin 2026-08-18 01:15 JST on Andrew's request; `main == origin/main
== 3a4c054`.**

## 0. START HERE next session

The phase is fully closed on the branch — nothing remains from it.

**What this phase fixed** (12 tasks, one commit each plus the snapshot
regen — full detail in `.superpowers/sdd/2026-08-17-correctness-cleanup/`):

1. **About box** — Apple-menu item 1 now shows the real ALRT 129
   (name/version/author/about) in unscripted runs instead of always
   tracing; scripted runs unaffected.
2. **Popup label-lane width fix** — a labeled `popup` with a narrow
   declared `width:` no longer collapses to a zero/negative-width box;
   `NarrowPopup` toolbox-suite case added (31st real case).
3. **Heap-jiggle stress mode** — new `jiggle on|off` scripted verb forces
   a full-heap `CompactMem` at every scripted dispatch and every
   `UiNewPtr` call, turning the stale-master-pointer bug class from
   heap-layout luck into a deterministic failure; `TestToolboxSuiteJiggleOn68k`
   gated native boot added. Limitation recorded in `docs/TODO.md`: only
   the `UiNewPtr` waist is jiggled (core text/list allocs and
   Toolbox-internal moves are not).
4. **Stale-master-pointer audit** — 20 functions across `uitable.cla`/
   `ui.cla`/`uiwidgets.cla`/`uitext.cla` traced against Inside Macintosh's
   memory-moving-routines list; 3 real bugs fixed (`rtUiTeWidestLine`,
   `rtUiTeClamp`, `rtUiTeScrollSync`), 4 already-correct from prior
   phases, 13 verified safe. `TestToolboxSuiteJiggleOn68k` green
   throughout (32/32 both before and after — this script path never hit
   the class, but the audit fixed 3 real reachable-elsewhere bugs anyway).
5. **Div/mod by zero** — now a runtime error (`division by zero`, exit 3)
   on both lanes, not UB; INT_MIN/-1 pinned to INT_MIN (quotient) / 0
   (remainder), matching the 68k restoring-division glue, verified on
   real hardware before blessing. Reference (Ch3/Ch4) updated.
6. **`func f(): error` — KErr hidden-return ABI** — a function returning
   `error` now routes through the hidden-pointer return convention on
   the native lane (previously failed loud at codegen time,
   `cg68k: cgExpr: EVarRef non-scalar`); `ErrReturn` core-suite case
   added.
7. **`get(k, dv)` evaluation order** — native now evaluates map/sortedmap/
   intmap `get`'s arguments left to right (m, k, dv), matching the host
   lane; previously diverged (m, dv, k) on native. `EvalOrder` core case
   added; reference pinned.
8. **Memory-bug pair** — `list.pop()`/`list.shift()` results passed
   directly as call arguments now get their scheduled release on both
   lanes (previously leaked); `rt_ext_ConnHOpen` now closes an
   already-open slot's fd before overwriting it (defensive — currently
   unreachable given the caller-side gate).
9. **Checker guards** — a widget property (e.g. `d.Body.text`) used as a
   fill-in-place out-arg to `file.readText`/`file.readResource` is now a
   loud compile-time error instead of silently filling a discarded
   temporary (this also uncovered and fixed the same live bug in the
   language reference's own Appendix C Text Editor fence); `toBytes`'s
   mutation guard now keys on receiver kind, not method name alone;
   `irXRecFieldSize`'s nested-xrec forward-reference panic is now
   guarded with a diagnostic + safe fallback (proven unreachable via
   today's check-phase ordering constraints — no fixture reaches it, but
   the guard is real defensive hardening).
10. **PBM icon parser** — `app68BuildIcnFamily`'s P1 parser now accepts
    CR/CRLF line endings (previously LF-only, so files staged via
    `hcopy -t` or authored on a Mac fell back to no-icon with a warning).
11. **Appendix C erratum** — the Bookmark Manager's `Remove.click` now
    guards `Marks.selected == -1` in both the reference and
    `examples/bookmarks.cla` (kept identical, as required).
12. **Phase close** — this task: snapshot regen (fixed point reached,
    the four previously-known-red fixtures divzero/modzero/divedge/
    popargleak now PASS on both `TestBehaviorGoldens` and
    `TestCrossGenDifferential`), full T2 green, docs pruned/updated.

Next roadmap item when Andrew wants it picked up: AppleTalk
(`docs/ROADMAP.md`'s "Next: language usability" list, item 3 — serial is
marked done, this cleanup phase was an interleaved detour). Design-first
per convention: spec before plan before code.

## 1. Gate results (this phase, branch tip)

- **T1 `--smoke`** after every task touching `runtime/`/`clarusc/`
  (Tasks 1-10): green throughout, per-task reports in
  `.superpowers/sdd/2026-08-17-correctness-cleanup/task-N-report.md`.
  Golden reblesses (emitui + cg68k `.s`) inspected by hand each time the
  new code shifted emitted bytes (About-box strings, jiggle
  globals/externs, div/mod guard glue, KErr return glue, checker
  diagnostics) — every diff traced to the expected cause, nothing
  unrelated moved.
- **Snapshot regen** (`clarusc/clarusc.c`, Go-free per
  `internal/selfhost/fixedpoint_test.go`'s own instructions): fixed
  point reached (gen1 == gen2, 4,756,150 bytes) and matches the
  committed snapshot. The four fixtures known-red against the STALE
  snapshot (Tasks 5-9's div/mod guard, KErr ABI, get() eval order, and
  leak-release changes weren't yet visible to a snapshot built before
  those tasks landed) now PASS on both oracle tests:
  - `TestBehaviorGoldens`: `run/divedge.cla`, `run/popargleak.cla`,
    `runerr/divzero.cla`, `runerr/modzero.cla` all PASS.
  - `TestCrossGenDifferential`: same four, all PASS.
  - Zero FAILs anywhere in either test's full run (`go test
    ./internal/selfhost -run 'TestBehaviorGoldens|TestCrossGenDifferential'
    -timeout 30m`, 108.99s total).
  Commit `d3887f0`.
- **`scripts/test-merge.sh` (T2)**: PASS at tip. T1 body, `internal/selfhost`
  (fixed point + full behavior/differential/error-golden suites), the
  gated native `internal/mactest` lane (`CLARUS_MAC_TESTS=1`, no `-run`
  filter — every frozen scenario, codegen test, the real-event-loop tick
  test, and both suites' native GUI boots including the NEW
  `TestToolboxSuiteJiggleOn68k`), and the `internal/bake` full-corpus
  byte-identity gate (`CLARUS_BAKE_FULL=1`) all green. See §2 for timing.
  Full log kept at `.superpowers/sdd/2026-08-17-correctness-cleanup/
  task-12-report.md`.

## 2. T2 timing

`scripts/test-merge.sh`: **PASS in 311s** total, zero FAILs:

- T1 body (every package except `internal/selfhost`): 26s.
- `internal/selfhost` (fixed point + behavior/differential/error
  goldens, `-timeout 30m` budget): 96s.
- `internal/mactest` gated native lane (`CLARUS_MAC_TESTS=1`, no `-run`
  filter — 4 frozen scenarios, codegen tests, event-loop tick test, both
  suites' native GUI boots including `TestToolboxSuiteJiggleOn68k`,
  `-timeout 90m` budget): 183s. `TestToolboxSuiteJiggleOn68k` re-run in
  isolation for confirmation: PASS, 44.78s, all 32 subtests green
  (31 real cases + `SelfCheck`).
- `internal/bake` full-corpus byte-identity gate (`CLARUS_BAKE_FULL=1`):
  6s.

Full log: `.superpowers/sdd/2026-08-17-correctness-cleanup/
task-12-report.md`.

## 3. Prior phases (all merged; recap pointers only)

- **serial-connection** (fenced `connection` type, serial as first
  transport, both lanes, Snow-hardware-proved) — merged 2026-08-16
  (`f8c15a1` → `main` at `1d8b703`, then pushed to `origin/main`). Full
  detail: HISTORY's `serial-connection` entry.
- **clir-load-perf** (CLIR load-path perf: header re-verify skip, once-
  per-session parse memo, bulk `text` range-read methods) — merged
  2026-08-15/16. Both Snow gates PASSED. Full detail: HISTORY's
  `clir-load-perf` entry.
- **attempt-abort** (`attempt { } aborted msg { }` + `abort(msg)`,
  cooperative unwinding, both lanes) — merged 2026-08-15. Full detail:
  HISTORY's `attempt-abort` entry.
- **object-code-linker** (stage 3.5, CLIR v6 baked object code) — merged
  2026-08-14.
- **fallback-trigger-narrowing / runtime-ir-bake / param-abi /
  memory-leak-fix / layer1-compiler-perf / datetime-instrumentation /
  map-hashtable / mac-resident-clarusc** — the 2026-08-12/13 stack, all
  merged. Recap pointers only; see HISTORY.

**Standing rules (unchanged):** re-run `TestClarusCBakePathOnSnow`
(`CLARUS_SNOW_TESTS=1`) after ANY change to `clarusc/bake.cla`,
`clarusc/macgui.cla`, OR the native runtime source manifest — this
phase touched neither (all runtime/compiler changes are pre-existing
modules edited in place, no new module added to the manifest), so the
standing rule does NOT fire this phase; `TestClarusCBakePathOnSnow`'s
last known-PASS (serial-connection phase tip) still stands.
`internal/selfhost` always gets `-count=1 -timeout 30m`. Merge only on
Andrew's request; main stays green.
