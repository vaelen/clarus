#!/bin/sh
# dblcompile: TestLeakGate/DoubleCompile (internal/mactest/leakgate_test.go's
# runDoubleCompileGate) -- the compiler must not retain heap blocks across
# repeated in-process compiles, and no state may survive a compile into the
# next one. Two 3-compile runs: the same entry three times, and the strictly
# stronger alternating [tickprobe, catprobe, tickprobe], each compared
# against a 1-compile baseline and each fork-byte-identity checked.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$ROOT/tests/lib_mactest_host.sh" || die "helper lib failed to load"

GROWTH_LIMIT=64

scratch_under_br mactest-dblcompile

tickprobe=$ROOT/testdata/cg68k/tickprobe.cla
catprobe=$ROOT/testdata/mac-resident/catprobe.cla

if ! host_build "$WORK/dblcompile" clarusc/test/dblcompile.cla > "$WORK/build.log" 2>&1; then
    die "build clarusc/test/dblcompile.cla failed: $(tail -5 "$WORK/build.log")"
fi

if ! leak_run "$SCRATCH/1x" "$WORK/dblcompile" "$tickprobe"; then
    t_fail DoubleCompile "$ERR"
    t_done
fi
live1=$LIVE

if leak_run "$SCRATCH/3x" "$WORK/dblcompile" "$tickprobe" "$tickprobe" "$tickprobe"; then
    growth_ok DoubleCompile "$live1" "$LIVE" "" && fork_identity DoubleCompile "$SCRATCH/3x" \
        && t_pass DoubleCompile
else
    t_fail DoubleCompile "$ERR"
fi

if leak_run "$SCRATCH/3x-alt" "$WORK/dblcompile" "$tickprobe" "$catprobe" "$tickprobe"; then
    growth_ok DoubleCompileAlternating "$live1" "$LIVE" "alternating-fixture " \
        && fork_identity DoubleCompileAlternating "$SCRATCH/3x-alt" \
            "stale state leaked across a different-fixture compile" \
        && t_pass DoubleCompileAlternating
else
    t_fail DoubleCompileAlternating "$ERR"
fi

t_done
