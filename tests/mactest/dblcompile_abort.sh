#!/bin/sh
# dblcompile_abort: TestLeakGate/DoubleCompileAbortRecovery
# (internal/mactest/leakgate_test.go's runDoubleCompileAbortGate) -- an
# abort() firing INSIDE one compile must leave no abort-state global stale
# for the NEXT compile in the same process. [tickprobe, badabort,
# tickprobe]: the harness must exit 0 (the abort was caught, not left
# uncaught), badabort's expected ABORTED line must reach the log, and
# leakfork_0.bin (tickprobe #1) must be byte-identical to leakfork_2.bin
# (tickprobe #2, compiled right after the aborted compile).
. "$(dirname "$0")/../lib.sh" || exit 2
. "$ROOT/tests/lib_mactest_host.sh" || die "helper lib failed to load"

scratch_under_br mactest-dblcompile-abort

if ! host_build "$WORK/dblcompile" clarusc/test/dblcompile.cla > "$WORK/build.log" 2>&1; then
    die "build clarusc/test/dblcompile.cla failed: $(tail -5 "$WORK/build.log")"
fi

if ! leak_run "$SCRATCH/abort" "$WORK/dblcompile" \
        "$ROOT/testdata/cg68k/tickprobe.cla" \
        "$ROOT/testdata/mac-resident/badabort.cla" \
        "$ROOT/testdata/cg68k/tickprobe.cla"; then
    t_fail DoubleCompileAbortRecovery "$ERR"
    t_done
fi

want="ABORTED: cg68k: attempt nesting exceeds cgBailTargets' fixed depth (32)"
if ! grep -qF "$want" "$ERRLOG"; then
    t_fail DoubleCompileAbortRecovery "expected badabort's caught-abort line in dblcompile's log output, got: $(tail -3 "$ERRLOG" | tr '\n' ' ')"
    t_done
fi

fork_identity DoubleCompileAbortRecovery "$SCRATCH/abort" \
    "abort-state leaked into the post-abort compile" \
    && t_pass DoubleCompileAbortRecovery

t_done
