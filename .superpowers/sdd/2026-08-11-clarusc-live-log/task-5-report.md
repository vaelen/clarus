# Task 5 report: frozen-scenario golden verification + docs

## Status

Complete.

## Commit hash(es)

- `d77bf01` — docs: live-log phase record (ROADMAP entry, spec status, STATUS)

(No golden-regen commit — see below.)

## Test summary

Frozen-scenario native-lane goldens: **PASS, no churn.**

Actual test names verified from `internal/mactest/native_test.go` (the
brief's guessed names were wrong — there is no per-scenario
`Test*On68k` for mandel/texteditor/bookmarks; they're subtests of one
table-driven test):

```
CLARUS_MAC_TESTS=1 go test ./internal/mactest \
  -run 'TestSmokeBounceOn68k|TestUiScenariosOn68k|TestRealEventLoopTickOn68k' \
  -count=1 -timeout 40m -v
```

Result: `ok clarus/internal/mactest 43.173s`, all PASS —
`TestSmokeBounceOn68k`, `TestUiScenariosOn68k` (`smoke_mandel`,
`texteditor`, `bookmarks` subtests), `TestRealEventLoopTickOn68k`. No
PBM/trace golden mismatch, so Step 2 (re-bless + eyeball) was skipped —
none of the four frozen scenarios captures a mid-compile Log-window
frame, so the runtime sync-paint change is a no-op for these goldens.

T1 final gate: `scripts/test-task.sh --smoke` → PASS in 25s (12
packages including both `mactest` smoke boots).

## Docs updated

- `docs/ROADMAP.md`: new `clarusc-live-log` phase entry (inserted after
  `layer1-compiler-perf`, before "Small open items"), matching recent
  entries' style — the three components (runtime sync paint + LivePaint
  case + suite count 29→30; `feProgressStep`/`feProgressTick` seam
  reshaped by §3b into 10 fixed stages + per-segment steps + throttled
  spinner; macgui 16-line ticker + 20-char bar Status label + flush
  restructure incl. the emit68k-failed ordering fix), the golden-check
  outcome (no churn), the two deferred minors, the open item (second
  scripted compile unproven, deferred to Snow rerun), the future
  host-CLI-progress follow-up (unscheduled), and the Snow rerun
  procedure note (boot at 1x, fast-forward only after `ClarusC.APPL` is
  up — `macresident_test.go:79`'s boot-hang history).
- `docs/superpowers/specs/2026-08-10-clarusc-mac-live-log-design.md`:
  Status line flipped to `implemented 2026-08-11 (this branch)`.
- `STATUS.md`: recommended-next-step 3 marked DONE, pointing at the
  ROADMAP entry.

## Concerns

None blocking. Carried forward into the ROADMAP entry (not resolved by
this task, per the brief):

- No automated test exercises the 10-stage sequence itself (order,
  count, `total` growth at Packing) — coverage is only indirect, via a
  real compile boot.
- The "Checking Whole Program" stage placement comment (documenting its
  dependency on the unconditional `native.cla` splice) was never added
  at the `driveManifestSplice` call site.
- Second scripted compile's completion is still unproven in-branch;
  proof is deferred to the Snow acceptance rerun.
- T2 (`scripts/test-merge.sh`) remains owed before any merge to main —
  not run this task (matches standing debt noted by prior phases).

## Final-review fix wave

Commit `3dd7df9`: addressed two documentation gaps:

1. **ROADMAP.md §live-log**: corrected toolbox-suite case count from
   "29 → 30 real cases" to "28 → 29 real cases; nTbCases (which includes
   SelfCheck) grew 29 → 30", and fixed filename reference from
   `runtime.cla` to `testsuite/toolbox/runner.cla` (where `nTbCases` is
   defined).
2. **clarusc/drive.cla driveManifestSplice**: added placement-invariant
   comment above `driveProgressStage("Checking Whole Program")` at line
   1312, documenting its reach-on-every-68k-compile guarantee despite
   living inside the `neededMods.count > 0` block (rooted in the
   unconditional `native.cla` splice under `want68k`).

Gate outputs: macgui.cla still compiles (exit 0 silent); TestSnapshotFixedPoint
PASS in 8.6s (comment-only change produces identical compiler output, no regen
needed).
