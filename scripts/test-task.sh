#!/bin/bash
# test-task.sh [--smoke]
# T1 gate (per-task): the ungated test gauntlet -- every package except
# internal/selfhost (which alone needs the 30m timeout headroom, and is
# reserved for the T2/merge gate; see test-merge.sh) -- run with
# `-count=1` to bust the Go test cache. Plain `go test` caches a package's
# result keyed on its .go inputs; it does NOT know about .cla fixtures a
# test reads at runtime (e.g. emitui-style golden/snapshot tests), so an
# edited .cla with unchanged .go can silently replay a stale PASS.
# `-count=1` forces a real re-run every time, closing that silent-red hole.
#
# --smoke: additionally runs the two native-68k emulator smoke tests
# (gated behind CLARUS_MAC_TESTS=1, needs the Retro68 toolchain + Mini
# vMac). Opt-in because it's slow relative to the T1 body; pass it
# whenever a task touches runtime/ or clarusc/.
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

SMOKE=0
for arg in "$@"; do
    case "$arg" in
        --smoke) SMOKE=1 ;;
    esac
done

START=$(date +%s)
go test $(go list ./... | grep -v /internal/selfhost) -count=1 -timeout 30m
if [ "$SMOKE" = "1" ]; then
    CLARUS_MAC_TESTS=1 go test ./internal/mactest \
        -run 'TestSmokeBounceOn68k|TestRealEventLoopTickOn68k' \
        -count=1 -timeout 20m
fi
END=$(date +%s)
echo "test-task.sh: PASS in $((END - START))s (smoke=$SMOKE)"
