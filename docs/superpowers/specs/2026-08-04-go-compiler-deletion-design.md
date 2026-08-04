# Go Compiler Deletion — Design

Date: 2026-08-04
Status: Approved (Andrew, 2026-08-04)
Roadmap context: test-suite-review's "demote-now-delete-deliberately"
decision (2026-08-03) scheduled deletion as a deliberate commit at the end
of the Toolbox phase if the parachute went unused. The Toolbox phase is
merged; the parachute went unused. This phase executes the deletion.

## Goal

Remove the frozen Go compiler (`cmd/clarus` + the frontend/IR/printer
packages) and the Go half of the differential harness from the repo,
after swapping every remaining consumer onto the snapshot-bootstrapped
clarusc pipeline. End state: the only compiler in the repo is clarusc
(self-hosted, bootstrapped from the committed C snapshot); the Go module
survives solely as the test-harness host.

## Why now

- The compiler-performance phase removed the 30x `DisposePtr` emit-time
  tax — the roadmap's explicit precondition for swapping the harness
  build vehicle ("swap all six together, post-compiler-perf-phase,
  immediately pre-Go-deletion").
- The Toolbox phase soaked the Go-free oracle machinery (behavior
  goldens, crossgen differential, snapshot fixed point) for a full
  feature phase without reaching for the Go parachute.
- The Go compiler is frozen at the bootstrap subset and cannot compile
  the Toolbox-phase language surface; keeping it alive means keeping the
  `ClaruscOnly` corpus-fork fences and freeze-exception ceremony growing
  with every future feature.

## Consumers to swap (seven, not six)

The roadmap's pre-deletion checklist names six `build.Build` call sites.
Exploration found a seventh consumer of the frozen compiler:
`internal/reftest/reftest_test.go` calls `driver.Check` directly.

1. `internal/mactest/native_test.go` — `buildNativeClarusc` (gated lane).
2. `internal/asm68k/vasm_test.go` — `buildClarusc` (+ builds
   `exercise.cla` via `build.Build`).
3. `internal/cg68k/golden_test.go` — `buildClarusc`.
4. `internal/emitui/emitui_test.go` — `buildClarusc`.
5. `internal/lowlevel/lowlevel_test.go` — `buildClarusc`.
6. `internal/sertest/sertest_test.go` (+ `clrdcompare_test.go`) —
   `buildClarusc`.
7. `internal/reftest/reftest_test.go` — `driver.Check` over the language
   reference's check-clean fences.

Additionally, three existing hand-rolled snapshot-bootstrap duplicates
consolidate onto the new shared helper (they are already Go-free, just
duplicated): `internal/mactest/suite_host_test.go`'s
`bootstrapSnapshotClarusc`, `internal/selfhost`'s copy
(behavior/crossgen/fixed-point), and `internal/perfgate`'s copy.

## Component 1: `internal/claruscboot` (new, non-test package)

One shared package exporting the Go-free clarusc build for all Go test
harnesses.

### Semantics: harnesses test the CURRENT compiler, not the snapshot

`build.Build` compiles `clarusc/*.cla` as it sits on disk, so harness
tests always exercise just-edited compiler code. The raw snapshot equals
current source only after regeneration, and the freshness gate
(`TestSnapshotFixedPoint`) lives in `internal/selfhost` — which **T1
excludes**. A raw-snapshot swap would let a T1 run on an
edited-but-not-regenerated `clarusc/` silently test stale compiler code
(the `5faaa6c` coverage-honesty failure mode). Therefore:

- `CurrentExe(t *testing.T) string` — two stages: `cc -O1` the committed
  `clarusc/clarusc.c` snapshot → that binary emits `clarusc/*.cla` →
  `cc -O1` the emission. This is `crossgen_test.go`'s existing
  `bootstrapCurrentClarusc` shape, promoted to shared code. **All seven
  swap sites use this.** (Constraint carried forward, not new: the
  committed snapshot must be able to compile current clarusc source —
  the bootstrap-compatibility rule crossgen already enforces.)
- `SnapshotExe(t *testing.T) string` — stage 1 only. Solely for the
  selfhost generation-comparison tests (behavior/crossgen/fixed-point),
  whose semantics are specifically about the snapshot lineage. Every
  other harness — including mactest's host oracles, which mirror
  build-mac.sh's pipeline shape but exist to test current code — uses
  `CurrentExe`.
- Both skip (`t.Skip`), not fail, when `cc` is not on PATH — same
  behavior as today's helpers.

### Caching

Builds land in `build-run/` (the directory `scripts/clarus-run.sh`
already uses for exactly this artifact), not per-process temp dirs:

- Cache key: input mtimes+sizes — the snapshot file for stage 1; the
  snapshot plus every `clarusc/*.cla` for stage 2. Stored in a stamp
  file next to the artifact.
- Concurrency: `flock` on a lock file around the build so the seven
  `go test` packages that start simultaneously share one build instead
  of racing seven `cc -O1` invocations; artifact written to a temp path
  and renamed into place atomically.
- Stale or missing stamp → rebuild. No cache-invalidation cleverness
  beyond the key.
- Memoized per-process on top (today's `sync.Once` pattern), so a
  package's many tests stat the cache once.

`scripts/clarus-run.sh`'s own shell cache is unchanged; the two caches
may share the directory but not the artifact name unless the plan finds
the keying identical.

## Component 2: the swaps

- Sites 1–6: replace `build.Build` + `source.Diag` plumbing with
  `claruscboot.CurrentExe(t)` and shelling out — `clarusc emit`/
  `emit68k` + `cc`, the same subprocess pattern
  `suite_host_test.go`'s `buildHostFromFixtures` already uses. Fixture
  builds that used `build.Build` directly (e.g. vasm's `exercise.cla`)
  go through the same emit+cc path.
- Site 7 (reftest): write each check-clean fence to a temp `.cla`, run
  `CurrentExe` in default check mode (no subcommand), assert clean exit
  and no diagnostics. Diagnostic-text assertions, if any, compare against
  clarusc's output (which the differential suite proved equivalent).
- Consolidation: mactest, selfhost, and perfgate's duplicated bootstrap
  helpers are replaced by `claruscboot` calls; their local memoization
  and `cc`-missing skip logic moves into the package.

## Component 3: deletion inventory (stage 2)

Whole directories:

- `cmd/clarus/`
- `internal/lexer/`, `internal/parser/`, `internal/check/`,
  `internal/types/`, `internal/lower/`, `internal/cprint/`,
  `internal/driver/`, `internal/ir/`, `internal/ast/`,
  `internal/token/`, `internal/source/`

`internal/build` (package survives as the home of `rt/` and the four
ungated C-runtime tests — `rtsmoke`, `memtest_c`, `rctest_c`,
`sertest_c`):

- Delete: `build.go`, `embed.go`, `runtime.go`, `build_test.go`,
  `golden_test.go`, `unsupported_test.go`, `gate_test.go`; `cc.go`
  deleted unless the rt C tests use its helpers (plan-level check — if
  they do, the used subset stays).

`internal/selfhost` — delete the Go lanes, keep the Go-free lanes:

- Delete: `differential_test.go`, `driver_test.go`, `emit_test.go`,
  `bootstrap_test.go`, `coverage_test.go`, `snapshot_test.go`'s
  `TestSnapshotCurrent`, `requireGoCompiler`, every `CLARUS_GO_DIFF`
  reference, and the `ClaruscOnly` corpus-fork machinery wherever it
  lives.
- Keep: `behavior_test.go`, `crossgen_test.go`, `TestSnapshotBuilds`,
  `TestSnapshotFixedPoint` (rehomed between files as needed — file
  layout is a plan detail).

Everywhere else:

- Per-package `gate_test.go` Go-diff gates die with their packages.
- `scripts/test-merge.sh`: remove the `CLARUS_GO_DIFF=1` export and its
  comment block.
- End-state grep gates: zero imports of the deleted package paths; zero
  `CLARUS_GO_DIFF` hits outside historical docs/reports; zero
  `build.Build` hits.

**Permanent keepers (never deletion targets):** `internal/build/rt/`
(the shared C runtime), `clarusc/clarusc.c` + its snapshot tests, all
harness packages (asm68k, cg68k, emitui, lowlevel, sertest, mactest,
perfgate, reftest, testsuite, selfhost's Go-free half), `go.mod` (the
repo remains a Go module for its harnesses).

## Component 4: docs and instructions

- CLAUDE.md: remove the `CLARUS_GO_DIFF` section, the "default gauntlet
  is NOT fully Go-free" caveat, and the six-call-site checklist; update
  the T1/T2 gate descriptions and the frozen-compiler paragraphs; the
  snapshot-regeneration recipe becomes Go-free.
- `TestSnapshotFixedPoint`'s failure message (and any other in-tree
  regen instructions) currently says `go run ./cmd/clarus build ...`;
  becomes: bootstrap from the committed snapshot with `cc`, then
  `clarusc emit -o clarusc/clarusc.c clarusc/main.cla` (or via
  `scripts/clarus-run.sh`'s cached bootstrap), commit the result.
- ROADMAP.md: phase outcome entry; retire the pre-deletion checklist.

## Sequencing and verification

- **Stage 1 (swap, one or more commits):** land `claruscboot`, all seven
  swaps, and the three consolidations. Run **full T2 with
  `CLARUS_GO_DIFF=1`** — the final parachute run, proving the swap
  changed nothing while both worlds are alive. Tag the green commit
  **`go-compiler-final`** (lightweight tag; Andrew's call, 2026-08-04).
- **Stage 2 (delete):** the deletion inventory + docs updates.
  Verification: `go build ./...` green; full T2 green (now Go-free by
  construction); the grep gates above; `scripts/clarus-run.sh`,
  `scripts/build-mac.sh`, `scripts/build-68k.sh` untouched and working
  (they never used Go).
- A T1 timing sanity check after stage 1: the cached two-stage bootstrap
  must not materially regress T1 wall-clock on a warm cache (the
  compiler-perf phase's win is the enabling condition; the cache makes
  the remaining `cc -O1` cost once-per-edit, not once-per-package).

## Error handling

- `cc` missing → skip (unchanged from today).
- Cache lock contention → wait on flock (builds are seconds-scale on a
  warm tree).
- Snapshot unable to compile current clarusc source → stage-2 build
  fails loudly with the compiler's own diagnostics; this is the existing
  bootstrap-compatibility contract, not a new failure mode.

## Out of scope

- No `clarusc run` subcommand — `scripts/clarus-run.sh` already covers
  roadmap item (d).
- No 2b character/byte-type surface review (explicitly sequenced after
  this phase).
- No changes to `clarusc/*.cla` compiler sources.
- No retirement of the legacy 23-scenario UI golden lane (separate,
  already-recorded migration strategy).
