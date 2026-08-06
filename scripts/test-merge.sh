#!/bin/bash
# test-merge.sh
# T2 gate (per-merge, docs/superpowers/specs/2026-08-03-test-suite-review-
# design.md "Gate tiers"): T1's body (see test-task.sh) plus the packages
# T1 excludes/gates -- internal/selfhost (30m-timeout bootstrap fixed-
# point + snapshot + cross-generation-differential suite) and the FULL
# gated mactest package (needs the Retro68 toolchain + Mini vMac;
# CLARUS_MAC_TESTS=1). No `-run` filter on mactest, so this is
# unconditionally all 16 gated boots (test-consolidation re-baseline,
# 2026-08-06): native lane -- 4 frozen golden scenarios (smoke_bounce
# standalone + smoke_mandel/texteditor/bookmarks table rows), 3 native
# codegen tests (NativeSmoke/StrContainers/ArrWholeAssign), the real-
# event-loop tick test, 1 runerr (oob) + 1 abort (emit_array), and the
# core+toolbox suite GUI boots; Retro68/cprint lane -- the same core+
# toolbox suite GUI boots plus 1 runerr (oob) + 1 abort (emit_array).
# core suite = 42 CoreTest cases (41 real + SelfCheck); toolbox suite =
# 23 ToolboxTest cases (22 real + SelfCheck). Slow (~15m+, dominated by
# mactest) -- run before merging to main, not per-task.
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
echo "test-merge.sh: internal/mactest (gated, both lanes) PASS in $(($(date +%s) - T2B_START))s"

END=$(date +%s)
echo "test-merge.sh: PASS in $((END - START))s"
