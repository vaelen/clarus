# Session status — 2026-09-06 (language-runtime-cleanup: COMPLETE on branch, NOT merged)

See §0 below for the current phase. The `compiler-cleanup` summary that
follows §0 is kept as the prior phase's handoff; `go-retirement` and
`string-perf` (also COMPLETE, not merged) are recorded in
`docs/HISTORY.md` and `docs/ROADMAP.md` rather than here.

## 0. START HERE next session

**Current branch: `language-runtime-cleanup` (2026-09-06, based on
`main` at `7c9d5f8` = `compiler-cleanup`'s tip + this phase's own
spec/plan docs). COMPLETE — NOT merged (merge only on Andrew's
request).** It cleared FOUR whole `docs/TODO.md` sections — "Language
features (needed)", "Compiler correctness / cleanup", "ABI /
performance", "Runtime / Toolbox robustness" — **24 entries** accumulated
across nine phases, disposed of as **23 fixed / 1 excluded by design**
(the `rtUiTableClick` tripwire, whose note moved verbatim into
`docs/ROADMAP.md`'s Standing rules). Two waves, sixteen tasks, two golden
blesses, one snapshot regeneration, and one Snow gate still owed.

**Three user-visible features landed**: array-literal initializers
(`const t: int[256] = [...]` in a dedicated constant-pool class),
window-owned menu sets (the `menus:` window property), and `file.openRF`
(a resource fork as an ordinary `filehandle`). Suites: core 82 (new
`OpenRF`), toolbox 38 (new `CanvasIdle`, `WindowMenus`).

**Two compiler-correctness bugs were found that nobody had asked for**,
both native-lane:

1. **The statement-temp aliasing bug (Task 12b)** — `cgStmt` reset the
   statement-temp bump allocators per statement, so a compound
   statement's own tracked temp aliased its body's first temp and the
   end-of-statement release freed a wrong pointer. **Any native program
   with `for x in f() { … }` (or `if f() { … }`) where `f` returns a
   text/list/map was affected.** Pinned by
   `tests/cg68k/nested_tmp_alias.sh`.
2. **The `EArrLit` addressable-argument seam (Task 7b)** — accepting
   `EArrLit` in `cgIsAddressableArgShape` is required for EVERY native
   `var x: T[n] = [...]` initializer, which the base commit aborted.

Full detail: `docs/HISTORY.md`'s "language-runtime-cleanup phase
(2026-09-06)" entry, the spec's §10 (as-built notes),
`docs/ROADMAP.md`'s "Where we are", and
`.superpowers/sdd/2026-09-06-language-runtime-cleanup/` (per-task briefs,
reports, reviews, and `progress.md`'s `Ruling:` lines).

**Obligations this phase leaves.**

- **`CanvasIdle` was red at close-out and is FIXED** (`ecbef8a`). The
  case sampled `FreeMem` before a window's first-open Toolbox allocation
  transient had settled; per-pass instrumentation showed the same
  transient at `63e2429`, where it happened to settle one pass earlier
  and both samples landed on the settled value — so the case had been
  green on heap-layout luck. Reverting the semantic half of the commit
  the bisect named (`9fa5134`) leaves the failure byte-identical, so the
  trigger was that commit's code-size ripple, not its menu logic. The
  case now warms up 12 event-loop passes before sampling, with the
  measurements in its comment; `toolbox_68k` and `toolbox_jiggle` are
  38/38 with `PASS CanvasIdle` on both lanes. It is the only
  exact-FreeMem case in the suite that brackets a window open.
- **The Snow `clarusc_bake` gate is OWED and has not passed.**
  `clarusc/bake.cla` changed this phase (`bkFormatVersion` 7 → 8, two
  additive sections), so the ~55-minute standing rule fires. No run has
  completed: see the Task 15 report for the two attempts and their
  disposition. Do not treat this phase as gate-complete until that
  result line exists.
- **New debt filed** in `docs/TODO.md` under this phase's own
  sub-headings: array RETURNS still abort on `emit68k`
  (`cgRetNeedsHidden` lacks `KArr`); `cpParamByRef` omits `KErr` where
  `cgParamByRef` has it; **clarusc's native self-compile sits near the
  32 KB per-function ceiling** (`cg_free_globals` scales with
  `irGlobals.count`, so any new compiler global shrinks every segment —
  Task 7 had to split `fpIntrCall3` to recover ~10 KB); `abort()` inside
  a global initializer does not propagate on either lane;
  `cg_init_globals`' frame is invisible to `cgStackHeuristic`; three
  `rt_fileh.inc` minors; the AppleDouble sidecar minors.
- **Suite case counts are hand-maintained in FIVE places each** — now
  written into `CLAUDE.md`. Two tasks shipped one site short and were
  caught only in review.
- **Carried over, unchanged, from earlier phases** (nothing here is
  discharged by this phase): the `macresident` /
  `macresident_failed_compile` Snow scripts are ported but not
  live-validated; the System 7 spot check filesystem-api owed; 68kbbs
  needs to re-pin its toolchain and re-measure on Snow after
  `string-perf`.
- **Next on the roadmap after merge:** AppleTalk → MacTCP.

## 0b. Prior phase — compiler-cleanup (2026-09-05, COMPLETE, NOT merged)

**Current branch: `compiler-cleanup` (2026-09-05, based on `main` at
`311af68` = `a1f9899` + this phase's own spec/plan/TODO docs).
COMPLETE — full T2 green, NOT merged (merge only on Andrew's
request).** It cleared `docs/TODO.md`'s whole "Compiler correctness /
diagnostics" section: 29 open entries accumulated across seven phases,
disposed of in one phase as **26 fixed / 1 already fixed / 1 obsolete /
1 closed with evidence**. Two waves, two golden blesses (wave 1: 77
files, a pure runtime-edit ripple proved by a differential oracle; wave
2: 64 files, 18 of them stale `*.seg2.s` DELETED), one snapshot
regeneration. The `.s` corpus went **501,110 → 478,983 lines (−4.42%)**,
of which −4.30% is the synthesized `clar_conn_pump()` stub keeping the
conn runtime out of conn-less native builds. Suites: toolbox 36 (new
`CasesTable`), core 81. Full detail: `docs/HISTORY.md`'s
"compiler-cleanup phase (2026-09-05)" entry, `docs/ROADMAP.md`'s
"Where we are", and `.superpowers/sdd/2026-09-05-compiler-cleanup/`.

**Obligations this phase leaves.**

- **No Snow gate was run, deliberately.** `clarusc/bake.cla` is
  untouched (its diff against `main` is empty), so the 55-minute
  `CLARUS_SNOW_TESTS=1 make test T=mactest/snow/clarusc_bake` standing
  rule does not fire.
- **The four stale-master-pointer fixes have no red-to-green test**, and
  none was manufactured — the master pointer is passed INTO an
  allocating trap, so the jiggle harness's `UiNewPtr` waist cannot see
  it. Proof is the green native suite plus per-site review. Recorded as
  a limit of the evidence, not as a passing test.
- **Three new follow-ups filed** in `docs/TODO.md`. (1) `lst.pop().field`
  on a handle-bearing record element leaks on the NATIVE lane only, a
  deliberate consequence of gating the native always-track on
  `cgIsHandleKind` rather than `cgNeedsRelease`. (2) **`--rtbake --lane c`
  silently drops the `connection`/`filehandle` runtime** — a HOST program
  using either type bakes to C that calls `rtConnOpen`/`rtFhOpen` without
  defining them. PRE-EXISTING on `main` (reproduced with
  `tests/conntest/testdata/echo.cla`), found by this phase's close-out
  T2, NOT fixed: one candidate fix needs `clarusc/bake.cla` (Snow gate),
  the other changes `--rtbake` fallback behavior; both are written up in
  the TODO entry. The C-lane bake sweep SKIPs the shape with an explicit
  reason that retires itself when the gap closes. (3) — no separate
  entry, but worth knowing — `tests/bake/full_corpus_suite_toolbox.sh`'s
  hand-maintained file list had drifted (missing `cases_casestable.cla`);
  fixed in place, and it is now `diff`-identical to
  `tests/mactest/toolbox_files.txt`. Automating that comparison is the
  obvious next hardening.
- **Carried over, unchanged, from earlier phases** (nothing here is
  discharged by this phase): the `macresident` /
  `macresident_failed_compile` Snow scripts are ported but not
  live-validated; the System 7 spot check filesystem-api owed; 68kbbs
  needs to re-pin its toolchain and re-measure on Snow after
  `string-perf`.
- **Next on the roadmap after merge:** AppleTalk → MacTCP.

## 1. Prior phases (all merged; recap pointers only)

- **68k-call-result-release** (`emit68k` handle-result release fix,
  `cgCallFnScalar`/`IUiGetTextviewText` producer-side tracking, plus a
  pre-existing `rtUiLdefDraw` stale-master-pointer bug and an
  `cgAndOr` short-circuit release Critical, both found and fixed
  in-phase) — merged to local `main` 2026-08-29 (this branch's own base,
  `36b76ab`). NOT pushed.
- **extern-ptr-call** (`= ptr`, pascal-convention call through a runtime
  pointer) — merged to local `main` 2026-08-28. NOT pushed (local main is
  ahead of `origin/main` = `9b2eea8`).
- **filesystem-api** (`file.makeDir/delete/list/exists/info/setInfo/
  rename/move`, both lanes) — merged AND pushed. System 7 (Snow)
  verification for that phase remains UNVERIFIED — still owed; see that
  phase's own `docs/HISTORY.md` entry.
- **transfer-crcs** (`text.crc16x`/`text.crc32`) — merged to local `main`
  2026-08-25 (part of this branch's own base).
- **binary-files** (`filehandle`, `connection` as a value, `text` binary
  accessors + `crc16`, `string(n)`, the `toolbox/` include fallback,
  emit68k's per-function big-temp pool) — merged to local `main`
  2026-08-23 (part of this branch's own base).
- **correctness-cleanup** — merged to `main` (ff `48a4696..3a4c054`),
  pushed 2026-08-18.
- **serial-connection** (fenced `connection` type, serial as first
  transport, both lanes, Snow-hardware-proved) — merged 2026-08-16.
- **clir-load-perf** — merged 2026-08-15/16. Both Snow gates PASSED.
- **attempt-abort** — merged 2026-08-15.
- **object-code-linker** — merged 2026-08-14.
- **fallback-trigger-narrowing / runtime-ir-bake / param-abi /
  memory-leak-fix / layer1-compiler-perf / datetime-instrumentation /
  map-hashtable / mac-resident-clarusc** — the 2026-08-12/13 stack, all
  merged. Recap pointers only; see HISTORY.

**Doc-hygiene note (pre-existing, not this task's job):** `attempt-abort`,
`serial-connection`, and `correctness-cleanup` are all merged to `main`
but none has its full write-up archived into `docs/HISTORY.md` yet
(HISTORY jumps from `clir-load-perf` straight to `binary-files`, with a
note explaining the gap) — a future docs pass should catch HISTORY up
through all three.

**Standing rules:** the test harness is Make + shell (`scripts/test-task.sh`,
`scripts/test-merge.sh`; `make test T='<group>/'` for a slice) — no result
cache, and each script carries its own `# timeout:` header, so there are no
cache-busting or timeout flags to remember. Merge only on Andrew's request;
main stays green (this branch does NOT touch main).
