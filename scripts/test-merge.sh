#!/bin/bash
# test-merge.sh
# T2 gate (per-merge): T1's body (see test-task.sh) plus the packages T1
# excludes/gates -- internal/selfhost (30m-timeout bootstrap suite) and
# the FULL gated native-68k mactest package (needs the Retro68 toolchain
# + Mini vMac; CLARUS_MAC_TESTS=1). Slow (~15m+, dominated by mactest) --
# run before merging to main, not per-task.
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

START=$(date +%s)

# T1 body
go test $(go list ./... | grep -v /internal/selfhost) -count=1 -timeout 30m

# T2 additions
go test ./internal/selfhost -count=1 -timeout 30m
CLARUS_MAC_TESTS=1 go test ./internal/mactest -count=1 -timeout 90m

END=$(date +%s)
echo "test-merge.sh: PASS in $((END - START))s"
