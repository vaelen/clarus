#!/bin/bash
# test-merge.sh
# T2 gate (per-merge, docs/superpowers/specs/2026-08-03-test-suite-review-
# design.md "Gate tiers"): T1's body (see test-task.sh) plus the packages
# T1 excludes/gates -- internal/selfhost (30m-timeout bootstrap fixed-
# point + snapshot + cross-generation-differential suite) and the gated
# mactest package (needs the Retro68 toolchain + Mini vMac;
# CLARUS_MAC_TESTS=1). No `-run` filter on mactest, so this runs every
# native-lane (emit68k) boot (test-consolidation re-baseline, 2026-08-06):
# 4 frozen golden scenarios (smoke_bounce standalone + smoke_mandel/
# texteditor/bookmarks table rows), 3 native codegen tests (NativeSmoke/
# StrContainers/ArrWholeAssign), the real-event-loop tick test, 1 runerr
# (oob) + 1 abort (emit_array), and the core+toolbox suite GUI boots.
# core suite = 42 CoreTest cases (41 real + SelfCheck); toolbox suite =
# 23 ToolboxTest cases (22 real + SelfCheck). The Retro68/cprint-gcc lane
# (same core+toolbox suite GUI boots plus 1 runerr + 1 abort, built
# through scripts/build-mac.sh instead of emit68k) is DEMOTED off this
# gate (pack3-standardfile phase, 2026-08-07): it SKIPs here by design,
# since the native lane already covers every case it checks. Set
# CLARUS_CPRINT_MAC_TESTS=1 (alongside CLARUS_MAC_TESTS=1) to re-enable
# it as an on-demand diagnostic oracle for cross-lane localization; lane
# deletion is deferred to 5f Retro68-retirement. Slow (~15m+, dominated
# by mactest) -- run before merging to main, not per-task.
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

START=$(date +%s)

# T1 body
T1_START=$(date +%s)
go test $(go list ./... | grep -v /internal/selfhost) -count=1 -timeout 30m
echo "test-merge.sh: T1 body PASS in $(($(date +%s) - T1_START))s"

# T2 additions
T2A_START=$(date +%s)
go test ./internal/selfhost -count=1 -timeout 30m
echo "test-merge.sh: internal/selfhost PASS in $(($(date +%s) - T2A_START))s"

T2B_START=$(date +%s)
CLARUS_MAC_TESTS=1 go test ./internal/mactest -count=1 -timeout 90m
echo "test-merge.sh: internal/mactest (gated, native lane; cprint-Mac lane opt-in via CLARUS_CPRINT_MAC_TESTS=1) PASS in $(($(date +%s) - T2B_START))s"

# runtime-ir-bake Task 5: the bake package's own exhaustive full-corpus
# byte-identity gate (every testdata/cg68k fixture, self-compile, the
# emitui corpus via the C lane) -- gated behind CLARUS_BAKE_FULL=1, off
# by the T1 body's own default run just above (which only exercises the
# small representative slice, TestBakePathByteIdentity). See
# internal/bake/bakeidentity_test.go's own doc comments for the
# documented-divergent fixture lists this asserts STAY divergent (a
# narrower, precisely-bounded residual of Task 4's original inherited
# problem -- task-5-report.md).
T2C_START=$(date +%s)
CLARUS_BAKE_FULL=1 go test ./internal/bake -count=1 -timeout 10m
echo "test-merge.sh: internal/bake full-corpus gate (CLARUS_BAKE_FULL=1) PASS in $(($(date +%s) - T2C_START))s"

END=$(date +%s)
echo "test-merge.sh: PASS in $((END - START))s"
