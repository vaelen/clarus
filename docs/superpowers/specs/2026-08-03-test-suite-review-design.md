# Test-suite review phase — design

Date: 2026-08-03. The first of the three pre-5f phases (ROADMAP, "Decided
sequencing 2026-08-03"). Restructures testing around two Clarus-native
test suites (`core` and `toolbox`), executes the Go-compiler demotion the
ROADMAP already scopes, attributes (does not fix) the 30x compiler-
performance finding, and tiers the gates so an SDD task's inner loop
stops paying for a merge gate's assurance.

## Motivating findings (measured 2026-08-03)

- **The ungated gauntlet is bimodal**: `go test ./...` = 19 packages
  green in ~570s, of which `internal/selfhost` alone is 450s (Go
  differential + bootstrap stages executing 30x-slow self-hosted
  binaries) and everything else combined is ~120s.
- **The full gated mactest is ~60 emulator boots** (23 UI scenarios x 2
  lanes + suite + 6 runerr + 2 abort + hello + native extras; 777.6s
  double-lane) — every boot a fresh stripped disk image + Mini vMac
  launch. 5f makes this untenable: when the compiler frontend runs ON
  the Mac, tests cannot cost one boot each.
- **Silent red is structurally possible**: `5faaa6c` changed
  `runtime/clarus/ui.cla`, its verification (deliberately, for velocity)
  ran only the targeted cg68k package, and `internal/emitui`'s goldens
  sat red on main for two days until this phase's inventory tripped over
  them (repaired in `998a882`). There is no cheap tier that still sweeps
  every ungated package.
- **The 30x finding**: clarusc-emitted C runs ~30x slower than
  Go-compiler-emitted C on compiler workloads (0.27s vs 8-9s for one
  `emit` of a UI fixture; identical output bytes; reproduced with a
  fresh self-emission, so it is the post-freeze cprint lineage — naive
  ARC counted stores are the prime suspect — not snapshot staleness).
  It dominates selfhost, every `build-68k.sh`/`build-mac.sh` emit, and
  would sink 5f's Mac-resident compiler outright. Decided (Andrew):
  ATTRIBUTE in this phase, FIX in its own follow-up phase before 5f.
- **Go's test cache is blind to `.cla` inputs** (they are not Go build
  inputs), so a cached PASS of emitui/mactest/selfhost after a runtime
  edit proves nothing. Harness scripts must bust the cache for
  `.cla`-dependent packages.
- **Existing seed**: `testdata/suite/test_suite.cla` already proves the
  monolithic in-process model — 39 tests, one boot, one output compare.

## The two suites (decided: Andrew, 2026-08-03)

Two Clarus-native test suites, `core` and `toolbox`. `core` tests
everything provable WITHOUT a classic Mac (or emulator) when compiled
against the C-printer backend; it also compiles natively so core runs on
a real Mac. `toolbox` tests everything needing the real Toolbox/hardware
(or emulator); Mac-only by nature. Each suite has:

1. **Test methods** spread across multiple `.cla` files
   (`testsuite/core/*.cla`, `testsuite/toolbox/*.cla` — final layout is
   the plan's call; they are ordinary Clarus functions returning
   pass/fail + a detail message).
2. **A runner library** — includes the suite's test files, defines
   `enum TestCase` (the registry of every case), and exposes a run
   entry point taking a `list of` enum values (one, several, or all)
   and executing exactly those, accumulating results. The enum -> call
   mapping is ONE hand-maintained dispatch function; a runner self-check
   asserts the enum member count equals the dispatch arm count, so a
   forgotten registration is a test FAILURE, not silence.
3. **A scriptable GUI front-end** — a Clarus app (dogfooding the UI
   runtime): "Run All", a test picker (select one/some, run), live
   per-test status, failure summary. Scriptable via the existing
   `--events` machinery, so automation drives the same app a human
   uses. On a real Mac this is the interactive runner (and, at 5f, the
   self-hosting acceptance environment: Mac-resident compiler + this
   app, no host in the loop).
4. **(core only) a CLI wrapper** for host use: run one/some/all cases by
   name, print per-case results, exit nonzero on any failure.

**Goals these serve (verbatim from the decision):** core still runs on
host; ALL tests run natively on one classic Mac boot without reboots or
many tiny apps; run a single test, all tests, or any combination; log
results for after-the-fact analysis; report overall status + failing
tests immediately in the UI/CLI.

**Logging/reporting:** the runner writes a structured result log (one
line per case: name, pass/fail, detail) via existing file I/O, and
mirrors it through the capture protocol so emulator runs surface
results without screen-scraping. The host `go test` harness stays the
orchestrator: it invokes the core CLI directly; for toolbox it boots the
emulator ONCE, drives "run all" via events, reads the log, and reports
each case as a Go subtest (per-case red/green in CI output).

**Drawing verification inside toolbox:** in-app framebuffer checks —
read the screen via `ScrnBase` (the 5d demo already poked it; reading
is the same waist) and checksum a region against an expected value.
Self-verifying, no host-side PBM compare needed for new tests.

## What stays OUTSIDE the two suites

- **Compiler-tooling tests** (host `go test`, unchanged in kind):
  bootstrap/snapshot, cg68k listing goldens + vasm round-trip +
  determinism, emitui C goldens, the behavior-golden corpus (below),
  reftest, unit tests.
- **Crash tests** (runerr/abort fixtures): each deliberately panics and
  exits — structurally cannot share a process. They stay as separate
  fast boots (~3s each) at the merge tier.
- **App-level scenarios**: About box, `App.openDocument`/launch
  handling, icon/resource parity are whole-app properties, not callable
  cases. The existing scripted-scenario lane keeps covering them.

## Migration strategy for the 23 UI golden scenarios

No big bang. Toolbox v1 covers what is programmatically assertable
in-process (widget state queries, event dispatch, timers, checksummed
drawing). The existing trace+PBM scripted lane keeps running at the
merge tier as the fidelity backstop; scenarios retire one by one as
toolbox cases demonstrably subsume them. End state: merge tier = 1 core
boot + 1 toolbox boot per lane + the crash/app-level boots — a handful,
not ~60. The coverage-honesty audit (below) seeds toolbox's case list.

## Gate tiers (decided: Andrew, 2026-08-03 — "smoke per-task, full per-merge")

- **T0 (inner loop):** targeted package/test, developer's discretion.
- **T1 (per-task gate, `scripts/test-task.sh`):** full ungated host
  gauntlet minus demoted Go lanes (every ungated package swept — the
  emitui failure mode is structurally closed), `.cla`-aware cache
  busting built in, core CLI run, the perf tripwire; PLUS, only when
  `runtime/` or `clarusc/` changed: one native emulator smoke boot
  (bounce + tickprobe class — one scripted, one real-mode). Target:
  <= 3 minutes wall-clock.
- **T2 (merge/review gate, `scripts/test-merge.sh`):** full double-lane
  gated mactest (including the legacy scenario lane while it survives),
  toolbox suite boot(s), bootstrap fixed point + snapshot tests,
  cross-generation snapshot differential, Go lanes via `CLARUS_GO_DIFF=1`
  (until deletion at end of the Toolbox phase). Paid once per branch.

## Go-compiler demotion (scope imported from the ROADMAP entry)

Executed in this phase: (a) Mac-gate host oracles swap from
`build.Build` to snapshot-bootstrapped clarusc -> cprint -> cc (the
`build-mac.sh` step-1 pipeline); (b) corpus agreement converts to
committed behavior goldens (drift becomes a reviewable git diff);
(c) a cross-generation differential against the committed snapshot
replaces the live Go-vs-clarusc sweep (caveat recorded: same lineage —
the reference + goldens is the truth anchor, and cprint-vs-emit68k
byte-compare already catches what a second frontend cannot);
(d) Go lanes behind an env gate, run at T2 only; (e) a `clarusc run`
wrapper (emit -> cc -> exec) replaces day-to-day `clarus run`.
Deletion of `cmd/clarus` + the Go frontend stays a deliberate commit at
the END of the Toolbox phase if the parachute went unused. Never
deleted: `internal/build/rt` and `clarusc/clarusc.c` + snapshot tests.

## 30x attribution (not fix)

Profile clarusc compiling a fixed workload (itself + one UI fixture);
attribute the slowdown to specific emission classes (ARC counted
stores vs `clar_str_255` by-value copies vs container access — evidence,
not suspicion); write the findings into a follow-up
compiler-performance phase spec slotted before 5f. Land a **perf
tripwire** in T1: a timed emit of a fixed fixture failing only on >2x
regression from a recorded baseline — a future 30x cannot land silently.

## Coverage-honesty audit

Enumerate every runtime branch no test executes (grep-driven: `nat_`
stubs, `peekb(UiTestScript()) == 0` real-mode branches, unexercised
externs). Each becomes either (a) a toolbox test case now (cheap,
TickProbe-class — the timer test is toolbox case #1), or (b) a recorded
known-unexercised entry in the ROADMAP, so green stops implying covered.

## Non-goals

- The 30x fix itself (follow-up phase; this phase only attributes).
- The compilation cache (parked; 5f-adjacent).
- Emulator boot parallelization (recorded as a candidate only).
- Go-compiler deletion (end of Toolbox phase).
- Migrating all 23 golden scenarios into toolbox (incremental, above).

## Success criteria

1. T1 <= 3 minutes, sweeps every ungated package, busts the `.cla`
   cache, and is the documented per-task gate.
2. `core` suite: same coverage as today's `test_suite.cla` (39 cases)
   restructured into methods + runner + CLI + GUI; green on host CLI
   AND in one native boot.
3. `toolbox` suite v1: runner + GUI + logging working end to end in ONE
   emulator boot, seeded with the audit's cheap cases (>= the timer,
   menu-key, and one checksummed-drawing case), each runnable singly,
   in combination, and via Run All — scripted and interactive.
4. Result log produced and parsed by the host harness; per-case results
   visible as Go subtests; failures reported in GUI/CLI immediately.
5. Go lanes demoted behind the env gate; oracles swapped; behavior
   goldens + cross-gen differential green; default gauntlet no longer
   builds or runs the Go compiler.
6. Attribution memo + follow-up phase spec committed; perf tripwire
   armed with a recorded baseline.
7. T2 documented and green on this phase's own merge.
