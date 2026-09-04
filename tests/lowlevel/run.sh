#!/bin/sh
# lowlevel/run.sh -- port of internal/lowlevel/lowlevel_test.go TestLowlevel:
# every testdata/lowlevel/*.cla fixture is emitted + host-compiled and RUN
# under the strict/paranoid leak gate; stdout must match the sibling .out
# byte-for-byte, exit must be 0, and the mem report must show live=0.
# (CLARUS_MEM_REPORT is left unset, so rt_mem_exit_check writes the
# "##CLARUS-MEM## live=N" header to stderr -- see rt_mem_host.inc.)
. "$(dirname "$0")/../lib.sh"
for f in testdata/lowlevel/*.cla; do
    n=$(basename "$f" .cla)
    if ! host_build "$WORK/$n" "$f" > "$WORK/$n.build" 2>&1; then
        t_fail "$n" "build: $(head -3 "$WORK/$n.build" | tr '\n' ' ')"; continue
    fi
    # Fresh cwd per fixture (Go's runDir := t.TempDir()): several fixtures do
    # real file I/O and would otherwise litter the repo root.
    mkdir -p "$WORK/run_$n"
    ( cd "$WORK/run_$n" && CLARUS_MEM_STRICT=1 CLARUS_MEM_PARANOID=1 "$WORK/$n" ) \
        > "$WORK/$n.out" 2> "$WORK/$n.err"
    rc=$?
    if [ $rc -ne 0 ]; then
        t_fail "$n" "exit $rc: $(head -3 "$WORK/$n.err" | tr '\n' ' ')"; continue
    fi
    if ! cmp -s "$WORK/$n.out" "testdata/lowlevel/$n.out"; then
        t_fail "$n" "stdout: $(first_diff "testdata/lowlevel/$n.out" "$WORK/$n.out" | tr '\n' ' ')"; continue
    fi
    live=$(mem_live "$WORK/$n.err")
    [ "$live" = 0 ] && t_pass "$n" || t_fail "$n" "live=$live"
done
t_done
