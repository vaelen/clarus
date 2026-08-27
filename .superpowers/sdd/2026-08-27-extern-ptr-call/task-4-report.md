# Task 4 report: core suite `PtrCall` case -- hardware proof on both lanes

## What was implemented

- `testsuite/core/cases_ptrcall.cla` (new): `casePtrCall(): TestResult`.
  - `external func NewPtr(size: int): ptr = trap 0xA11E reg` /
    `DisposePtr(p: ptr) = trap 0xA01F reg` -- declared locally rather than
    the brief's `Pc`-prefixed duplicates. Reason (found during host
    verification, see "Deviation" below): the core suite doesn't compose
    `toolbox/memory.cla`, and `Pc*`-named trap externs have no
    `rt_ext_Pc*` glue in `runtime/host/rt_ext_host.inc` -> host link
    failure. Reusing the exact name/signature/clause `toolbox/memory.cla`
    already uses picks up the existing `rt_ext_NewPtr`/`rt_ext_DisposePtr`
    host glue for free (language reference's "identical repeat extern
    declaration" accommodation), and needs nothing extra on the native
    lane (trap externs compile to inline TRAP instructions, no rt_ext_
    involved there).
  - `external func PtrCallRound(entry: ptr, w: word, flag: bool, out: ptr, n: int): word = ptr`
    (brief's original) + `callback func pcMixed(...): word` -- unchanged
    from the brief.
  - `external func PtrCallFlag(entry: ptr, x: int): bool = ptr` +
    `callback func pcIsPositive(x: int): bool { return x > 0 }`
    (controller amendment) -- exercises the native bool/char RESULT-
    readback arm the word-returning call alone doesn't reach.
  - `casePtrCall()` checks, in order: `PtrCallRound(pcMixed, 7, true, scratch, 21) == -93`
    (signed word round trip), `peekl(scratch) == 28` (ptr+int arrived),
    `PtrCallRound(pcMixed, 7, false, scratch, 21) == 7` (bool steers),
    `PtrCallFlag(pcIsPositive, 5) == true`, `PtrCallFlag(pcIsPositive, -5) == false`
    -- each with its own `tkFail` detail, `tkPass("PtrCall")` at the end.
- `testsuite/core/runner.cla`: `PtrCall` enum member (after `DirOps`,
  before `SelfCheck`), `coreCaseName` arm, `coreAllCases` entry, dispatch
  arm calling `casePtrCall()`, `nCoreCases` 79 -> 80, doc comment updated
  (79th real case).
- Four Go core-suite file lists, each gets `cases_ptrcall.cla` with the
  comment `// extern-ptr-call phase: runner.cla unconditionally calls
  casePtrCall().`:
  - `internal/mactest/suite_host_test.go` (`coreCLIFiles`)
  - `internal/testsuite/core_cli_test.go` (`buildCoreCLI`'s `files`)
  - `internal/cg68k/segment_test.go` (`segmentationFixture`)
  - `internal/bake/bakeidentity_test.go` (`coreSuiteGUIFiles`)
- Two Go-side hardcoded case-count/name expectations that the new case
  makes stale, not named in the brief's file list but required for the
  suites to pass:
  - `internal/testsuite/core_cli_test.go`: `wantCases` gains `"PtrCall"`
    before `"SelfCheck"`.
  - `internal/mactest/coresuite_test.go`: `wantCoreSuiteCases` 79 -> 80,
    doc comment extended with the PtrCall entry.

## Host test evidence

```
go test -count=1 -run TestCoreSuiteCLI -v ./internal/testsuite
```
```
=== RUN   TestCoreSuiteCLI
=== RUN   TestCoreSuiteCLI/all
=== RUN   TestCoreSuiteCLI/single_case
=== RUN   TestCoreSuiteCLI/unknown_case
--- PASS: TestCoreSuiteCLI (1.12s)
    --- PASS: TestCoreSuiteCLI/all (0.19s)
    --- PASS: TestCoreSuiteCLI/single_case (0.00s)
    --- PASS: TestCoreSuiteCLI/unknown_case (0.00s)
PASS
ok  	clarus/internal/testsuite	1.494s
```

Also ran `go test -count=1 ./internal/cg68k ./internal/bake` (both build
the suite composition, no boot) -- both `ok`.

## Native hardware evidence (load-bearing)

```
CLARUS_MAC_TESTS=1 go test -count=1 -run TestCoreSuiteGUIOn68k -v ./internal/mactest
```
```
--- PASS: TestCoreSuiteGUIOn68k (4.01s)
PASS
ok  	clarus/internal/mactest	4.386s
```

Per-case capture from the run immediately prior (before the
`wantCoreSuiteCases` bump; content identical, that run just still failed
its own stale count assertion) -- the tail of the captured suite log:

```
PASS IntToStr
PASS FileHandleRW
PASS DirOps
PASS PtrCall
PASS SelfCheck
TOTAL 80 PASS 80 FAIL 0
```

Confirms real pascal-convention 68k glue called through a runtime
pointer on actual emulated hardware, both the word-returning and
bool-returning `= ptr` externs.

## T1 gate

```
scripts/test-task.sh
```
`test-task.sh: PASS in 26s (smoke=0)` -- all packages `ok`. T1 does not
set `CLARUS_MAC_TESTS=1` (no `--smoke` flag passed), so this run does not
include the emulator boot; that hardware evidence was gathered
separately above per the brief's own Step 5.

## Files changed

- `testsuite/core/cases_ptrcall.cla` (new)
- `testsuite/core/runner.cla`
- `internal/mactest/suite_host_test.go`
- `internal/testsuite/core_cli_test.go`
- `internal/cg68k/segment_test.go`
- `internal/bake/bakeidentity_test.go`
- `internal/mactest/coresuite_test.go` (not in the brief's list --
  required fix, see below)

Commit: `8fa24f7 test: core suite PtrCall case -- '= ptr' round trip via
callback glue (80 cases)`.

## Deviations from the brief (both discovered during verification, both
   necessary)

1. **`NewPtr`/`DisposePtr` instead of `PcNewPtr`/`PcDisposePtr`.** The
   brief's own Step 1 NOTE anticipated this: "check first ... whether
   NewPtr/DisposePtr externs are already declared in a file the core
   suite composes -- if so, reuse those and drop the Pc* duplicates."
   They aren't already composed (`toolbox/memory.cla` isn't in the core
   suite's file lists), but declaring `Pc*`-named trap externs produced a
   host link failure (`Undefined symbols ... rt_ext_PcNewPtr`) since only
   the ordinary names have host glue in `runtime/host/rt_ext_host.inc`.
   Declaring the SAME name/signature/clause `toolbox/memory.cla` uses
   (not composed, so no collision) resolves this for free on both lanes.
2. **Two Go-side count/list assertions not named in the brief's file
   list** (`internal/testsuite/core_cli_test.go`'s `wantCases` array,
   `internal/mactest/coresuite_test.go`'s `wantCoreSuiteCases` const)
   needed bumping -- both are exactly the same category of "hardcoded
   count grows with the suite" maintenance `runner.cla`'s own doc comment
   describes previous tasks performing (e.g. "Task 2 bumped runner.cla's
   nCoreCases and internal/testsuite's own wantCases"). Without these,
   `TestCoreSuiteCLI` and `TestCoreSuiteGUIOn68k` fail on a stale expected
   count even though the suite itself is fully green (confirmed: first
   run showed `PASS PtrCall` and `TOTAL 80 PASS 80 FAIL 0` inside the
   FAIL output, before the const bump).

## Self-review findings

- Case code matches the brief's three original checks verbatim plus the
  controller amendment's two bool checks verbatim (values, tkFail detail
  shape).
- `runner.cla`: enum member, dispatch arm, `coreCaseName`/`coreAllCases`
  entries, `nCoreCases` 79->80, and its doc comment (79th real case) are
  all consistent and match sibling wiring exactly (`git diff` reviewed).
- All four Go file lists carry the phase-tagged comment
  `// extern-ptr-call phase: runner.cla unconditionally calls casePtrCall().`
- No golden or snapshot files touched (`git status` shows only the 7
  files above; no `testdata/uisnaps`, no `.out` files).

## Concerns

None. Both deviations above were necessary corrections surfaced by
running the actual verification commands (not skipped), not scope creep;
each is documented in-file (`cases_ptrcall.cla`'s own header comment
explains the `NewPtr`/`DisposePtr` naming choice).
