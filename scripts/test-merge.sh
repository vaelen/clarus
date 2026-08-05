#!/bin/bash
# test-merge.sh
# T2 gate (per-merge, docs/superpowers/specs/2026-08-03-test-suite-review-
# design.md "Gate tiers"): T1's body (see test-task.sh) plus the packages
# T1 excludes/gates -- internal/selfhost (30m-timeout bootstrap fixed-
# point + snapshot + cross-generation-differential suite) and the FULL
# gated mactest package (needs the Retro68 toolchain + Mini vMac;
# CLARUS_MAC_TESTS=1). No `-run` filter on mactest, so this is
# unconditionally BOTH lanes' worth of everything the package contains:
# the 4 suite boots (core+toolbox GUI result-log suites x native-68k +
# Retro68/cprint lanes, test-suite-review Tasks 10-12; toolbox grew
# 7->21 ToolboxTest cases in the ui-scenario-retirement phase, 2026-08-05,
# which migrated 12 of the 23 legacy scenarios in as cases), the
# 11-scenario scripted trace+PBM lane x2 lanes (fidelity backstop for the
# scenarios still not retired -- about, smoke_bounce, smoke_menudemo,
# smoke_mandel, opendoc, opendoc_empty, texteditor, texteditor_quit,
# texteditor_bigfile, bookmarks, formedit; the other 12 widget scenarios
# now live as toolbox-suite cases instead), the crash-fixture boots
# (6 runerr + 2 abort, each lane), and the native-lane host-compare/
# regression boots. Slow (~15m+, dominated by mactest) -- run before
# merging to main, not per-task.
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
