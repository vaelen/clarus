# Session status — 2026-09-05 (compiler-cleanup: COMPLETE on branch, full T2 green, NOT merged)

See §0 below for the current phase. The `string-perf` summary that
follows is kept as the prior phase's handoff; `go-retirement` (also
COMPLETE, not merged) is recorded in `docs/HISTORY.md` and
`docs/ROADMAP.md` rather than here.

Handoff summary. **The `string-perf` phase (branch `string-perf`, based
on `main` at `54292df` = `061dbd5` + this phase's spec/plan docs;
`textview-scroll-to-end` and everything before it are already merged to
local `main`, NOT pushed) removes the two dominant measured string
costs on the native 68k lane and adds `text.clear()`/`text.reserve(n)`.**
Origin: 68kbbs's Snow bench doc (temporary, their repo) blamed ~200
ms/row table draws on string ops with a guessed mechanism; three code
traces + a new calibration bench (`testdata/bench/strbench.cla`,
`TestStrBench68k`, gated `CLARUS_BENCH68K=1`) replaced the model: the
real costs were the full-capacity zero loop per string local per call
(~0.48 ms/local, `cgEmitFunc`) and out-of-line `rtStrIndex`/`rtStrLen`
calls per `s[i]`/`s.length` (~30 instructions each). `string` returns
were already one BlockMove — the doc's per-char-return model was wrong.

Landed (5 commits over `54292df`): length-byte-only string-local init
(`cgDefaultInitStrLenOnlyAt`, gated on the ledger's zeroed-tail probe —
all consumers length-bounded on both lanes); inline `IStrLen`/
`IStrIndex` (cold path delegates to `rtStrIndex` to avoid a second
`cgRelClsPanicMsg` identity in the object/bake format); `clear()`/
`reserve(n)` end to end (check/ir/lower/cg68k/cprint/shake/text.cla +
reference; cprint arms in `fpIntrCall13` — `fpIntrCall3` trips the 32KB
segment limit); suite pins `StrPerf` (core, now 81) and `ClearWarm`
(toolbox, now 35 — FreeMem EXACTLY flat across 200 clear+refill
cycles, hardware); snapshot regenerated to fixed point in one pass.
After-bench: `mklocal4` 10549→1268 ticks (8.3x), `strindex` ~71→~24
us/index; `echo*` unchanged (proven instruction-identical; Mini vMac
bench rows are bimodal across runs — see ledger Task 7 and TODO.md).

Deviations/discoveries are in the ledger
(`.superpowers/sdd/2026-09-02-string-perf/progress.md`). Next after
merge: 68kbbs re-pins its toolchain and re-measures on Snow; then
AppleTalk -> MacTCP per `docs/ROADMAP.md`.

## 0. START HERE next session

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
