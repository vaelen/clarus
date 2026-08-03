# Test-Suite Review Phase Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Restructure testing around two Clarus-native suites (`core` host+native, `toolbox` native-only, one boot each), tier the gates (per-task ≤3 min vs per-merge full), demote the Go compiler to an env-gated parachute, and attribute (not fix) the 30x compiler-performance finding — per `docs/superpowers/specs/2026-08-03-test-suite-review-design.md` (read it first; it is the authoritative design and records all decided trade-offs).

**Architecture:** Phase A (Tasks 1–2): tier scripts + cache busting, perf tripwire. Phase B (Tasks 3–6): Go demotion — behavior goldens, cross-gen snapshot differential, mactest oracle swap, env gate + `clarus-run` wrapper. Phase C (Task 7): 30x profiling/attribution memo + follow-up spec. Phase D (Tasks 8–10): core suite — runner kit + CLI, test_suite migration, GUI front-end. Phase E (Tasks 11–12): toolbox suite + one-boot host orchestration. Phase F (Tasks 13–14): coverage audit, tier-script finalization + docs wrap.

**Tech Stack:** Clarus (`testsuite/*.cla`, UI runtime), Go test harnesses (`internal/selfhost`, `internal/mactest`), bash (`scripts/`), snapshot-bootstrapped clarusc, Mini vMac via LaunchAPPL.

**Session-cold context (executor: read before Task 1):**
- `CLAUDE.md` (conventions, Mac toolchain, emulator control, idle-lock caveat)
- `docs/superpowers/specs/2026-08-03-test-suite-review-design.md` (this plan's spec)
- `docs/ROADMAP.md` "Decided sequencing 2026-08-03" (phase context + Go-demotion scope)
- `docs/clarus-language-reference.md` Ch5 (enums), Ch7 (events), Ch8 (windows/widgets), Ch11 (canvas), Ch13 (lowlevel/extern)
- `testdata/suite/test_suite.cla` (the 39-case monolith being restructured)
- `internal/mactest/mac_test.go` (RunMac/parseCapture — the capture protocol), `internal/selfhost/differential_test.go`
- Branch: create `test-review` from main (`77cbe49` or later).

## Global Constraints

- **Frozen Go compiler source:** `internal/` GO COMPILER packages (lexer/parser/check/types/lower/cprint/build/ir/ast/token/source/driver) are never modified. Go TEST HARNESSES (`internal/selfhost`, `internal/mactest`, and new harness files) are maintainable — the standing 5e ruling.
- **No clarusc source changes anywhere in this plan** (no snapshot regeneration needed). If a task discovers one is unavoidable, STOP and escalate to Andrew — that is a plan defect.
- **New Clarus test code is clarusc-only surface** where it uses Ch13 (`external func`, peek/poke): it must live outside the six Go-swept corpus dirs (`testdata/valid|errors|run|runerr|include|diag`). The new `testsuite/` top-level directory is Go-invisible by construction.
- **`testdata/suite/test_suite.cla` behavior is the parity oracle for Task 9** — its 39 cases' semantics must survive the restructure byte-comparably (same checks, new packaging). The file itself is retired only at Task 9's end, after parity is proven.
- **Golden policy:** `testdata/ui/*.trace` + `testdata/uisnaps/*.pbm` NEVER re-blessed here (the legacy scenario lane is the fidelity backstop). `testdata/cg68k/*.s`, `testdata/emitui/*.c.golden` should not churn (no clarusc/runtime changes); if they do, STOP — something out of scope moved.
- **MacRoman:** any `.cla` carrying typographic chars (… “ ” —) is MacRoman-encoded; the Edit tool corrupts those bytes — use `LC_ALL=C sed` + byte-diff (project memory: macroman-cla-editing). New testsuite files should stay pure ASCII to avoid the issue entirely.
- **Gates:** until Task 13 lands the tier scripts as policy, every task ends green on `go test ./... -count=1 -timeout 30m` (note `-count=1`: the Go test cache is blind to `.cla` inputs — a cached PASS proves nothing after a `.cla` edit). Mac-gated runs: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run <pattern> -count=1 -timeout 60m`. LaunchAPPL blocks until app quit — run in background.
- **Emulator idle-lock:** the sandboxed display locks after <1 min without real HID input; long emulator waits need synthetic mouse-move nudges (CLAUDE.md).
- Commits end with the project's Co-Authored-By/Claude-Session trailers (copy from `git log -1 --format=%B`).

## Normative: the testsuite runner contract (Tasks 8–12 build to this)

Layout (new top-level dir, both suites + shared kit):

```
testsuite/
  kit.cla            # shared: TestResult record, log/report formatting helpers
  core/
    runner.cla       # enum CoreTest {All, ...}; runCoreTests(); caseName(); dispatch
    cases_str.cla    # test methods (and further cases_*.cla files per family)
    cases_list.cla   ...
    cli.cla          # host CLI wrapper (non-UI program: args -> run -> print -> quit N)
    gui.cla          # Mac GUI front-end (window, Run All, picker, status)
  toolbox/
    runner.cla       # enum ToolboxTest {All, ...}; runToolboxTests(); caseName(); dispatch
    cases_*.cla      # test methods
    gui.cla          # Mac GUI front-end (the only front-end; no CLI)
```

Builds compose files explicitly (both build scripts accept multiple `.cla`):
core CLI = `kit.cla core/runner.cla core/cases_*.cla core/cli.cla`; a GUI build
swaps `cli.cla` for `gui.cla`. There is no cross-file import mechanism —
inclusion by build-arg list IS the composition model (same as
`texteditor_bigfile`'s two-source build, `internal/mactest/native_test.go:438-442`).

Contract (decided, spec "runner library" — verbatim rules):
- `enum CoreTest { All, ... }` — `All` is the FIRST member. One enum per suite.
- Run entry: `func runCoreTests(sel: list of CoreTest): list of TestResult`.
  It first DEDUPES `sel` (order-preserving); if the deduped list contains
  `All`, the list becomes exactly `[All]`. Execution branches are
  `if wantAll or has(sel, CoreTest.X) { ... }` — i.e. the
  `test == All or test == ThisTestCase` shape.
- `record TestResult` (kit.cla): `name: string(63)`, `passed: bool`,
  `detail: string(255)`.
- Self-check: the runner's LAST result entry is a meta-case asserting
  `casesRun == enumMemberCount - 1` when `All` was selected (every
  non-`All` member has exactly one branch); a forgotten branch fails the
  suite, never silently shrinks it.
- Log format (kit.cla emits, host harness parses — treat as an API):
  one line per case `PASS <name>` or `FAIL <name>: <detail>`, then
  `TOTAL <n> PASS <p> FAIL <f>`. Lines go to `print()` (host stdout /
  Mac capture console — both lanes already route it) AND, on Mac GUI
  builds, to a `TestLog.txt` written via `file.writeText` (goal 4's
  on-disk artifact).
- CLI exit code: `quit 1` if any FAIL, else fall off main (exit 0) —
  `quit <int>` is host-lane-proven (clarusc's own CLI uses it).

## Phase A — hygiene + tripwire

### Task 1: tier scripts v1 + `.cla`-aware cache busting

**Files:**
- Create: `scripts/test-task.sh`, `scripts/test-merge.sh`
- Modify: `CLAUDE.md` (Build and test section: document the two tiers)

**Interfaces:**
- Produces: `scripts/test-task.sh` (T1 gate: ungated gauntlet, `-count=1`,
  fails loud on any package; takes optional `--smoke` to add the native
  emulator smoke) and `scripts/test-merge.sh` (T2 gate v1: T1 + full gated
  mactest + selfhost). Later tasks EDIT these in place (Task 6 gates Go
  lanes; Task 13 finalizes).

- [ ] **Step 1: Write `scripts/test-task.sh`** — `set -e`; `go test $(go list ./... | grep -v selfhost) -count=1 -timeout 30m` (every ungated package, cache-busted — closes the emitui silent-red hole); `--smoke` flag additionally runs `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestSmokeBounceOn68k|TestRealEventLoopTickOn68k' -count=1 -timeout 20m`. Echo a one-line wall-clock summary.
- [ ] **Step 2: Write `scripts/test-merge.sh`** — T1 body plus `go test ./internal/selfhost -count=1 -timeout 30m` plus `CLARUS_MAC_TESTS=1 go test ./internal/mactest -count=1 -timeout 90m`.
- [ ] **Step 3: Run `scripts/test-task.sh`** (no smoke) — green, record wall-clock in the task report (baseline: ~120s pre-demotion).
- [ ] **Step 4: Document both tiers in CLAUDE.md** (replace the bare `go test ./...` guidance: per-task = `test-task.sh` [+ `--smoke` when `runtime/` or `clarusc/` changed], per-merge = `test-merge.sh`; note the `-count=1` rationale).
- [ ] **Step 5: Commit** `"scripts: tiered test gates v1 -- test-task.sh / test-merge.sh, .cla-aware cache busting"`.

### Task 2: perf tripwire

**Files:**
- Create: `internal/perfgate/perfgate_test.go`, `internal/perfgate/baseline.txt`
- Modify: none

**Interfaces:**
- Consumes: the snapshot bootstrap (`cc -O1` on `clarusc/clarusc.c`, the exact `scripts/build-68k.sh:45-48` recipe, duplicated locally with `testing.T`-managed temp dir + `sync.Once` memoization — the `buildNativeClarusc` pattern, `internal/mactest/native_test.go:43-73`).
- Produces: `TestEmitPerfTripwire` — times `clarusc emit -o <tmp> testdata/emitui/every.cla` (median of 3), compares against `baseline.txt` (one float, seconds), FAILS only if median > 2x baseline. Ungated (runs in T1 via `./...`).

- [ ] **Step 1: Write the test** — build clarusc from snapshot (memoized), run the emit 3 times with `time.Since`, take the median, read `baseline.txt`, fail if `median > 2*baseline` with a message naming both numbers and the re-baseline procedure (edit `baseline.txt`, justify in the commit).
- [ ] **Step 2: Record the baseline** — run the timing on this machine, write the median (expected ~8-9s pre-fix) into `baseline.txt` with a comment line (`# seconds; median clarusc emit of testdata/emitui/every.cla; 2026-08-03`). The test must skip with a clear message if `cc` is unavailable.
- [ ] **Step 3: Run `go test ./internal/perfgate -count=1 -v`** — PASS; temporarily set baseline to 0.1 and verify it FAILS with the right message; restore.
- [ ] **Step 4: Commit** `"internal/perfgate: emit-time tripwire -- a future 30x cannot land silently"`.

## Phase B — Go-compiler demotion

### Task 3: behavior goldens for the differential corpus

**Files:**
- Create: `testdata/valid/*.out` goldens where missing (bulk-generated), `internal/selfhost/behavior_test.go`
- Modify: none yet (Task 6 gates the old sweep)

**Interfaces:**
- Consumes: the existing differential harness's corpus walk + run logic (`internal/selfhost/differential_test.go` — read it first; reuse its fixture enumeration and run-with-timeout helpers by extraction into a shared file if needed, or local duplication if extraction would touch frozen files — harnesses are maintainable, so extraction is fine).
- Produces: `TestBehaviorGoldens` — clarusc (snapshot-bootstrapped) builds and runs every runnable corpus fixture; stdout+exit must byte-match the committed `.out`/expected goldens. NO Go compiler involved. `CLARUS_BLESS_BEHAVIOR=1` regenerates.

- [ ] **Step 1: Inventory the corpus** — which `testdata/` fixtures the differential sweep RUNS (vs compile-only), and which already have committed expected outputs (`testdata/run/*.out` exist; `testdata/valid/` mostly relies on live agreement). Record counts in the task report.
- [ ] **Step 2: Write `TestBehaviorGoldens`** with the bless env; generation uses the SNAPSHOT-bootstrapped clarusc (not `build.Build` — the point is Go-independence) via the Task 2 build pattern.
- [ ] **Step 3: Bless once** (`CLARUS_BLESS_BEHAVIOR=1 go test ./internal/selfhost -run TestBehaviorGoldens`), eyeball-spot-check 5 goldens against the fixtures' obvious intent, commit the goldens.
- [ ] **Step 4: Verify the live sweep and the goldens agree** — run BOTH `TestBehaviorGoldens` and the existing Go differential; both green means the goldens faithfully snapshot today's agreed behavior.
- [ ] **Step 5: Commit** `"selfhost: behavior goldens over the corpus -- Go-free drift detection (bless: CLARUS_BLESS_BEHAVIOR=1)"`.

### Task 4: cross-generation snapshot differential

**Files:**
- Create: `internal/selfhost/crossgen_test.go`

**Interfaces:**
- Consumes: snapshot bootstrap (previous generation, from committed `clarusc/clarusc.c`) and current-source clarusc (built BY the snapshot compiler: snapshot-clarusc `emit -o cur.c clarusc/main.cla`, then `cc` — NOT via `build.Build`).
- Produces: `TestCrossGenDifferential` — both compilers emit C for every corpus fixture; emitted C must be byte-identical fixture-by-fixture EXCEPT where current clarusc source intentionally changed behavior since the snapshot (then the behavior goldens of Task 3 are the arbiter — the test compares RUN OUTPUT, not bytes, for those). Simplest correct v1: compare run outputs (stdout+exit) of snapshot-built vs current-built fixture binaries — same oracle strength as the old Go sweep, zero Go.

- [ ] **Step 1: Write the test** — build both compiler generations (memoized), for each runnable corpus fixture build+run under both, compare stdout+exit; report first divergence with fixture name and both outputs.
- [ ] **Step 2: Run it** — green (current tree has no intentional divergence from the snapshot).
- [ ] **Step 3: Document the arbiter rule** in the test's header comment: on INTENTIONAL divergence, Task 3's behavior goldens are re-blessed with justification and this test's expectation follows the goldens — the snapshot side is regenerated at the next release per the existing snapshot policy.
- [ ] **Step 4: Commit** `"selfhost: cross-generation differential -- snapshot-vs-current run-output agreement, no Go"`.

### Task 5: mactest host-oracle swap

**Files:**
- Modify: `internal/mactest/suite_host_test.go` (`BuildSuiteHost`), `internal/mactest/native_test.go` (`runNativeHostCompareSeglimit`'s host half, `:183-207`)

**Interfaces:**
- Consumes: snapshot bootstrap pattern (Task 2); existing `RunSuiteHost` signature stays.
- Produces: `BuildSuiteHost`/host-compare expectations built via snapshot-clarusc `emit` + `cc` (the `build-mac.sh` step-1 pipeline) instead of `build.Build`. Same function names/signatures — callers untouched.

- [ ] **Step 1: Swap `BuildSuiteHost`'s body** to snapshot-clarusc emit + `cc -O1 -I internal/build/rt` + `rt.c` (memoized compiler build; keep the diagnostics-on-failure shape of the current code).
- [ ] **Step 2: Swap the host half of `runNativeHostCompareSeglimit`** identically.
- [ ] **Step 3: Gated verification:** `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestSuiteOn68k|TestNativeSmoke$' -count=1 -timeout 30m` — green proves the swapped oracle agrees with the emulator byte-for-byte.
- [ ] **Step 4: Ungated + commit** `"mactest: host oracles via snapshot clarusc -- Go compiler out of the Mac gates"`.

### Task 6: env-gate the Go lanes + `clarus-run` wrapper

**Files:**
- Create: `scripts/clarus-run.sh`
- Modify: `internal/selfhost/differential_test.go`, `internal/selfhost/bootstrap_test.go`, `internal/selfhost/emit_test.go`, `internal/selfhost/coverage_test.go`, `internal/selfhost/driver_test.go` (gate additions only), Go-compiler unit-test packages' gating (one shared helper), `scripts/test-merge.sh`, `CLAUDE.md`
- NOT modified: `internal/selfhost/snapshot_test.go` (snapshot tests are Go-free contract tests — they STAY ungated)

**Interfaces:**
- Produces: `requireGoCompiler(t)` helper (skip unless `CLARUS_GO_DIFF=1`) applied to every test that builds or exercises the Go compiler: the Go differential sweep, the Go-stage bootstrap test, emit/coverage/driver tests, and the Go compiler unit-test packages (via a `TestMain` gate file per package — harness files, allowed). `scripts/clarus-run.sh FILE.cla [-- args]` = snapshot-clarusc emit → `cc` → exec (the day-to-day `clarus run` replacement).
- Note: `TestBootstrapFixedPoint` gains a Go-free variant in the same commit — snapshot→stage1→stage2 byte-compare (the Go stage0 leg goes behind the gate with the rest).

- [ ] **Step 1: Write `requireGoCompiler`** in a new `internal/selfhost/gogate_test.go`; apply to the Go-lane tests; add the Go-free fixed-point variant (`TestSnapshotFixedPoint`: snapshot-built clarusc emits clarusc → build that → emit again → byte-compare emissions).
- [ ] **Step 2: Gate the Go unit-test packages** — add a `gate_test.go` with a skipping `TestMain` under `CLARUS_GO_DIFF` to each of: lexer, parser, check, types, lower, cprint, build, driver, cmd/clarus. (`internal/build`'s rt C-runtime tests — `rtsmoke`, `memtest`, `rctest`, `sertest_c` — are NOT Go-compiler tests; split their gating so they stay ungated if they live in the same package: verify and record.)
- [ ] **Step 3: Write `scripts/clarus-run.sh`**; smoke it on `testdata/run/hello.cla`-class fixture and on args pass-through.
- [ ] **Step 4: Verify both directions** — default `go test ./... -count=1` runs NO Go-compiler build (confirm via wall-clock drop and `-v` skip messages); `CLARUS_GO_DIFF=1 go test ./internal/selfhost -count=1` still green. Update `test-merge.sh` to export `CLARUS_GO_DIFF=1`. Record new T1 wall-clock (target ≤3 min).
- [ ] **Step 5: Update CLAUDE.md** (build/run commands: `clarus-run.sh`; Go lanes gated) and **commit** `"selfhost+scripts: Go lanes behind CLARUS_GO_DIFF -- default gauntlet is Go-free; clarus-run.sh"`.

## Phase C — 30x attribution

### Task 7: profile, attribute, write the follow-up spec

**Files:**
- Create: `docs/superpowers/specs/2026-08-XX-compiler-performance-design.md` (dated at execution), attribution memo section inside it
- Modify: `docs/ROADMAP.md` (slot the compiler-performance phase before 5f)

**Interfaces:**
- Consumes: Task 2's harness for building both compiler flavors; `sample`/Instruments (`sample <pid> 5 -file out.txt` works headless on macOS) over `clarusc emit testdata/emitui/every.cla`.
- Produces: an evidence-backed attribution (which emission classes cost what fraction of the 30x) and the follow-up phase spec with a measured target.

- [ ] **Step 1: Reproduce + profile** — run the snapshot-built emit under `sample` (3 runs); bucket the hot frames (candidates: `rt_text_*`/`rt_str_*` retain/release traffic, `clar_str_255` by-value copies, `rt_list_at`/map access, allocator). Record the top-10 frame table in the memo.
- [ ] **Step 2: Differential experiment** — hand-patch ONE suspect class out of a COPY of the emitted C (e.g. no-op the rc retain/release calls via `#define`) and re-time: does the 30x collapse? Iterate over at most 3 suspects. This is scratch-dir work — nothing lands in the tree.
- [ ] **Step 3: Write the spec** — findings, attribution table, proposed fix direction (e.g. ARC elision for provably-dead pairs, str-copy elimination), measured success target (emit of `every.cla` within 3x of Go-built time), explicit non-goals. Slot it in ROADMAP before 5f.
- [ ] **Step 4: Commit** `"spec: compiler-performance phase -- 30x attributed (<one-line finding>), fix scoped pre-5f"`.

## Phase D — the core suite

### Task 8: kit + core runner + CLI, seeded

**Files:**
- Create: `testsuite/kit.cla`, `testsuite/core/runner.cla`, `testsuite/core/cases_str.cla`, `testsuite/core/cli.cla`
- Create: `internal/testsuite/core_cli_test.go` (host harness)

**Interfaces:**
- Consumes: `scripts/clarus-run.sh`-style build (snapshot clarusc emit + cc), multi-file: `clarusc emit -o out.c testsuite/kit.cla testsuite/core/runner.cla testsuite/core/cases_str.cla testsuite/core/cli.cla`.
- Produces (the normative runner contract above, worked): `record TestResult`; `enum CoreTest { All, StrConcatClamp, StrIndexing, SelfCheck }` (seed); `func runCoreTests(sel: list of CoreTest): list of TestResult`; `func coreCaseName(t: CoreTest): string`; kit helpers `func tkPass(name: string): TestResult`, `func tkFail(name: string, detail: string): TestResult`, `func tkReport(results: list of TestResult): int` (prints the PASS/FAIL lines + TOTAL, returns fail count). CLI: args = case names (or `all`, or empty = all), unknown name → `FAIL <name>: unknown test case` + nonzero.

- [ ] **Step 1: Write kit.cla** (record + the three helpers; pure ASCII).
- [ ] **Step 2: Write runner.cla** — dedupe (order-preserving nested-loop over `list of CoreTest`), the All-collapse rule, `wantAll` + per-case branches for two REAL seed cases lifted verbatim from `test_suite.cla`'s string section (concat clamp + indexing — copy the existing check bodies), and the SelfCheck meta-case (`casesRun == 3 - 1` … member count minus All, counted by a literal `nCoreCases` const the dispatch increments against).
- [ ] **Step 3: Write cli.cla** — parse args (the `rt_args` surface `test_suite`-era programs use; empty = All), map names via `coreCaseName` comparison, run, `tkReport`, `quit 1` on fails.
- [ ] **Step 4: Write the host harness** `TestCoreSuiteCLI` — builds the CLI via snapshot clarusc (memoized), runs `all`, parses the log lines, asserts every case PASS and the TOTAL line's arithmetic; second subtest runs a single named case and asserts exactly one case line. Run: `go test ./internal/testsuite -count=1 -v` — PASS.
- [ ] **Step 5: Negative check** — temporarily break a seed case's expected value, verify CLI exits nonzero and harness reports the FAIL line; restore.
- [ ] **Step 6: Commit** `"testsuite: kit + core runner/CLI seeded -- enum-All contract, dedupe, self-check"`.

### Task 9: migrate test_suite.cla's 39 cases

**Files:**
- Create: `testsuite/core/cases_*.cla` (one file per family: str, text, list, map, rec, arr, enumconv, fixed, ser, misc — final split at implementer's discretion, ≤200 lines each)
- Modify: `testsuite/core/runner.cla` (enum + branches grow to all 39 cases), `internal/testsuite/core_cli_test.go` (expected-case count)
- Delete (END of task): `testdata/suite/test_suite.cla` + its harness uses

**Interfaces:**
- Consumes: Task 8's contract exactly.
- Produces: every `test_suite.cla` check as a named enum case (39 + SelfCheck); `internal/mactest`'s suite tests (`TestSuiteOnMac`/`TestSuiteOn68k`) rebased onto the core CLI build (host expectation = core CLI output; Mac boot = same binary semantics via the GUI—NOT yet: Mac boots stay on test_suite.cla until Task 10 provides the GUI; this task keeps `TestSuiteOnMac`/`On68k` green by keeping test_suite.cla in place UNTIL the parity step, then swaps their fixture to the core CLI composition compiled as a print-only program: `kit.cla runner.cla cases_*.cla cli.cla` runs on Mac lanes too — it is a non-UI print program, exactly what test_suite.cla is).
- Parity oracle: old suite's output and new CLI `all` output are DIFFERENT formats — parity is per-check SEMANTICS: every old check has a case; migration table (old stdout line -> new case name) goes in the task report.

- [ ] **Step 1: Build the migration table** — read `test_suite.cla` end to end; one row per check.
- [ ] **Step 2: Migrate family by family** (str/text/list/map first, run CLI after each family — cheap local loop via `clarus-run.sh` on the composed file list).
- [ ] **Step 3: Grow the harness count assertion**; full `TestCoreSuiteCLI` green.
- [ ] **Step 4: Swap the Mac suite gates** — `TestSuiteOnMac`/`TestSuiteOn68k` build the core-CLI composition (host expectation via the SAME composition run on host); gated run: `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run 'TestSuiteOnMac|TestSuiteOn68k' -count=1 -timeout 30m` — green on both lanes.
- [ ] **Step 5: Delete `test_suite.cla`** + stale references (grep `test_suite` tree-wide); full T1 green.
- [ ] **Step 6: Commit** `"testsuite: core migration complete -- 39 cases enum-cased; test_suite.cla retired; Mac suite gates on core CLI"`.

### Task 10: core GUI front-end

**Files:**
- Create: `testsuite/core/gui.cla`, `testdata/ui/coresuite.events` (scripted drive)
- Create: `internal/mactest/coresuite_test.go`

**Interfaces:**
- Consumes: `runCoreTests`/`coreCaseName`/`tkReport` unchanged; UI runtime (window/button/table or list of case rows/textview status — Ch8 widgets).
- Produces: a Mac app: window listing every case name (table widget, rows = enum order minus All), buttons `Run All` and `Run Selected` (selected table row), status textview appended per result (`PASS <name>` lines), `TestLog.txt` written via `file.writeText` after each run; every result line ALSO `print()`ed (capture console) so scripted boots surface results. Scripted drive: `coresuite.events` = click Run All, quit.
- Gated test `TestCoreSuiteGUIOn68k`: builds `kit+runner+cases+gui` via `buildNative68kUI`-style emit with `--events coresuite.events`, ONE boot, parses capture for the PASS/TOTAL lines — every case green in one boot (success criterion 2's native half).

- [ ] **Step 1: Write gui.cla** (window + table of names + two buttons + status textview; on run: call `runCoreTests`, append lines, write TestLog.txt, print lines).
- [ ] **Step 2: Write the events script + gated test**; run it (ONE boot): `CLARUS_MAC_TESTS=1 go test ./internal/mactest -run TestCoreSuiteGUIOn68k -count=1 -timeout 30m` — all cases PASS in-boot.
- [ ] **Step 3: Interactive spot-check** (live emulator, no --events): boot via `build-68k.sh`, click a single case + Run Selected, verify status + TestLog.txt exists (screenshot in report).
- [ ] **Step 4: Commit** `"testsuite: core GUI front-end -- one-boot native core run, scripted + interactive"`.

## Phase E — the toolbox suite

### Task 11: toolbox runner + GUI, seeded with the audit's first cases

**Files:**
- Create: `testsuite/toolbox/runner.cla`, `testsuite/toolbox/cases_events.cla`, `testsuite/toolbox/cases_draw.cla`, `testsuite/toolbox/gui.cla`, `testdata/ui/toolboxsuite.events`

**Interfaces:**
- Consumes: kit.cla contract; Ch13 externs declared LOCALLY in case files (user-code externs are the proven pattern — tickprobe.cla declares its own traps).
- Produces: `enum ToolboxTest { All, TickCountAdvances, MenuKeyMatches, CanvasChecksum, SelfCheck }` + `runToolboxTests` under the identical contract; gui.cla mirrors core's gui (same widget layout, toolbox enum).
  Seed cases (all synchronous, in-process):
  - `TickCountAdvances`: `external func TbTickCount(): int = trap 0xA975` — read, spin a bounded loop (~50k iterations) re-reading; PASS iff it advanced by ≥1 and by <600 (sanity ceiling); the 5faaa6c `reg`-bug shape would freeze it.
  - `MenuKeyMatches`: `external func TbMenuKey(ch: word): int = trap 0xA93E` — with the GUI's own `menu File { item Quit "Quit" key "Q" }` installed, `TbMenuKey(int('Q'))` must return menuID<<16|item matching File/Quit (read the expected menuID from the result's own high word being nonzero + item == the Quit index — exact assert: result != 0 and low word == 2... verify Quit's item number against the gui.cla menu at implementation and hard-code with a comment). The 5faaa6c char-marshaling bug shape returns 0.
  - `CanvasChecksum`: gui.cla hosts a small canvas; the case draws a fixed pattern (`pattern(4); fillRect(0,0,32,32)`), then checksums the canvas's screen region via `ScrnBase` peeks (`external func` low-mem read: `peekl(ptr(0x824))` = ScrnBase, rowBytes from `screenBits` — mirror `nat_UiScreenBits`'s sources, `runtime/clarus/native.cla:937`) and compares against a constant recorded at first verified run (comment: re-record procedure). Window position must be fixed for determinism (declared `at:` position).
- Gated `TestToolboxSuiteOn68k` (same file as Task 10's harness): ONE boot, events-driven Run All, parse capture per-case into subtests (`t.Run(caseName, ...)`) — goal 5's per-case CI reporting.

- [ ] **Step 1: Write runner + the three cases + SelfCheck** (externs local to case files; canvas case coordinates with gui.cla's fixed layout).
- [ ] **Step 2: Write gui.cla + events script**; local iteration via `build-68k.sh` + live emulator until all three PASS in-boot.
- [ ] **Step 3: Write `TestToolboxSuiteOn68k`** (one boot, per-case subtests from capture); gated run green.
- [ ] **Step 4: Negative check** — sabotage `TickCountAdvances`' assert bound temporarily; verify the case FAILs, the suite reports it, the harness subtest goes red; restore.
- [ ] **Step 5: Commit** `"testsuite: toolbox runner/GUI seeded -- TickCount, MenuKey, canvas checksum; one-boot gated harness"`.

### Task 12: cprint-lane toolbox boot + harness consolidation

**Files:**
- Modify: `internal/mactest/coresuite_test.go` (add cprint-lane variants), `scripts/test-merge.sh`

**Interfaces:**
- Consumes: `BuildMac`/`runBuildMac` (`internal/mactest/mac_test.go:40-68`) with `--events`; the same testsuite sources build on the Retro68 lane unchanged.
- Produces: `TestCoreSuiteGUIOnMac` + `TestToolboxSuiteOnMac` (Retro68/cprint lane, one boot each — the both-lanes assurance the legacy 23-scenario lane provides today, now for the suites); `test-merge.sh` updated to the spec's T2 shape: suite boots (4: core/toolbox × 2 lanes) + legacy scenario lane + crash/app-level boots + bootstrap/snapshot + cross-gen + `CLARUS_GO_DIFF=1` lanes.
- Boot-count ledger in the task report: T2 emulator boots before (≈60) vs after this phase (suite 4 + legacy lane unchanged until retirement + crash 8 + app-level ~4) — the reduction realized so far and the end-state number when the legacy lane retires.

- [ ] **Step 1: Add the two cprint-lane suite tests** (mirror the native ones; `BuildMac` with `--test` + `--events`).
- [ ] **Step 2: Gated run of all four suite boots** — green, wall-clock recorded.
- [ ] **Step 3: Rewrite `test-merge.sh`** to the T2 shape above; run it END TO END once (this is the phase's own merge rehearsal); record total wall-clock.
- [ ] **Step 4: Commit** `"mactest: suite boots both lanes; test-merge.sh = spec T2"`.

## Phase F — audit + wrap

### Task 13: coverage-honesty audit

**Files:**
- Create: audit table in `docs/ROADMAP.md` ("Known-unexercised runtime surface" subsection under Plan 5)
- Possibly create: additional cheap `testsuite/toolbox/cases_*.cla` entries (audit's call)

**Interfaces:**
- Consumes: grep sweeps: `func nat_` (all fallback stubs), `peekb(UiTestScript()) != 0` / `== 0` (scripted-vs-real forks), `external func` declarations never reached by any test (cross-reference `testdata/` + `testsuite/` usage).
- Produces: a table — every unexercised branch/stub, disposition per row: `toolbox case landed <name>` / `known-unexercised, recorded` (with the reason: needs real input / needs real hardware / stubbed-by-design). Cheap closures (judgment: synchronous, in-process, no modal input) land as toolbox cases in the same task.

- [ ] **Step 1: Run the sweeps**, build the table (expect: SF dialog stubs [deferred by spec], TE scrap stubs, AE launch, real-mode branches now partially covered by tickprobe/toolbox, `rt_ui_ask_save_changes` real Alert path, cmd-key real dispatch [now covered by MenuKeyMatches], others found).
- [ ] **Step 2: Land the cheap closures** as toolbox cases (each: case + enum + branch + green one-boot run).
- [ ] **Step 3: Commit the ROADMAP table + cases** `"audit: known-unexercised runtime surface recorded; cheap toolbox closures landed"`.

### Task 14: docs wrap + phase gate

**Files:**
- Modify: `CLAUDE.md` (final tier commands, testsuite build/run one-liners), `docs/ROADMAP.md` (phase outcomes entry), spec's Outcomes section (`docs/superpowers/specs/2026-08-03-test-suite-review-design.md`)

- [ ] **Step 1: Run the full T2 (`scripts/test-merge.sh`)** — green end to end; record wall-clocks (T1 and T2) against the spec's success criteria (T1 ≤3 min).
- [ ] **Step 2: Walk the spec's 7 success criteria** — one-line evidence each in the Outcomes section (criterion → command/commit/number).
- [ ] **Step 3: Update CLAUDE.md + ROADMAP**, **commit** `"docs: test-review phase wrap -- outcomes, tiers, testsuite entry points"`.
- [ ] **Step 4: Request the final whole-branch review** (superpowers:requesting-code-review), then merge on Andrew's word (superpowers:finishing-a-development-branch).
