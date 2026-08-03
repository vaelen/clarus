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
# Retro68/cprint lanes, test-suite-review Tasks 10-12), the legacy
# 23-scenario scripted trace+PBM lane x2 lanes (fidelity backstop until
# scenarios retire one by one into toolbox, per the design doc's
# migration strategy -- NOT yet retired), the crash-fixture boots
# (6 runerr + 2 abort, each lane), and the native-lane host-compare/
# regression boots. Slow (~15m+, dominated by mactest) -- run before
# merging to main, not per-task.
#
# CLARUS_GO_DIFF=1 (test-suite-review Task 6): the default `go test ./...`
# gauntlet gates every test that builds or exercises the frozen Go
# compiler (see CLAUDE.md) behind this var, so a merge run needs it to
# reinstate the Go differential/bootstrap/coverage lanes on top of the
# Go-free oracles (behavior/crossgen/snapshot/fixed-point) that already
# run unconditionally. Exported before BOTH the T1 body (line below) and
# the internal/selfhost run, since Go-diff-gated tests live in both
# (several packages' own gate_test.go plus selfhost/gogate_test.go).
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

export CLARUS_GO_DIFF=1

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
