#!/bin/bash
# test-task.sh [--smoke]
# T1 gate (per-task): the Make runner's t1 body (every tests/ group except
# selfhost/ and perfgate/, in parallel), then perfgate alone (it flakes
# under contention), then with --smoke the two native emulator boots
# (CLARUS_MAC_TESTS=1, needs Retro68 + Mini vMac). No result cache: every
# invocation re-runs every selected script.
#
# --smoke is opt-in because it boots a whole emulated Mac; pass it whenever
# a task touches runtime/ or clarusc/.
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
J=$(sysctl -n hw.ncpu 2>/dev/null || nproc 2>/dev/null || echo 4)

make -j"$J" tools bootstrap
make -j"$J" t1
make test T=perfgate/
if [ "$SMOKE" = "1" ]; then make smoke; fi

echo "test-task.sh: PASS in $(( $(date +%s) - START ))s (smoke=$SMOKE)"
