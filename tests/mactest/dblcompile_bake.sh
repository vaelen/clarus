#!/bin/sh
# dblcompile_bake: TestLeakGate/DoubleCompileBake (internal/mactest/
# leakgate_test.go's runDoubleCompileGateBake) -- the --rtbake twin of
# dblcompile.sh, and clir-load-perf Task 7's primary behavioral proof of
# design B. Per run: the leak/growth gate, the fork byte-identity oracle
# (which under copy-on-install also proves compile #2+ emits the same
# bytes as #1), and checkDesignBStates over the harness's BAKESTATE lines
# -- the CLIR is parsed exactly once per process, the object-code paste
# stays armed on every compile, the pending object staging never shrinks
# below the runtime-function boundary, and the installed state is
# identical on every compile.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$ROOT/tests/lib_mactest_host.sh" || die "helper lib failed to load"

GROWTH_LIMIT=64

scratch_under_br mactest-dblcompile-bake

tickprobe=$ROOT/testdata/cg68k/tickprobe.cla
catprobe=$ROOT/testdata/mac-resident/catprobe.cla
bake=$SCRATCH/rt68k.clir

if ! "$CLARUSC" --bake-ir --lane 68k -o "$bake" > "$WORK/bakeir.log" 2>&1; then
    die "clarusc --bake-ir --lane 68k failed: $(tail -5 "$WORK/bakeir.log")"
fi
if ! host_build "$WORK/dblcompile_bake" clarusc/test/dblcompile_bake.cla > "$WORK/build.log" 2>&1; then
    die "build clarusc/test/dblcompile_bake.cla failed: $(tail -5 "$WORK/build.log")"
fi

# check_states NAME NCOMPILES : checkDesignBStates over $ERRLOG's
# "BAKESTATE <i> k=v ..." lines (feProgress -> log() -> stderr).
check_states() {
    _msg=$(awk -v want="$2" '
        function bad(m) { print m; failed = 1; exit 1 }
        $1 != "BAKESTATE" { next }
        {
            pb = 0; ov = 0; bd = 0; el = 0
            for (i = 3; i <= NF; i++) {
                if (split($i, kv, "=") != 2) bad("malformed BAKESTATE field " $i " in line " $0)
                if (kv[2] !~ /^-?[0-9]+$/) bad("malformed BAKESTATE value " $i " in line " $0)
                if (kv[1] == "parsedBefore")   pb = kv[2] + 0
                else if (kv[1] == "objvalid")  ov = kv[2] + 0
                else if (kv[1] == "boundary")  bd = kv[2] + 0
                else if (kv[1] == "eligible")  el = kv[2] + 0
                else bad("unknown BAKESTATE key " kv[1] " in line " $0)
            }
            wantpb = (n == 0) ? 0 : 1
            if (pb != wantpb) bad("compile #" n ": parsedBefore=" pb ", want " wantpb " (design B parses the CLIR exactly once per process)")
            if (bd <= 0) bad("compile #" n ": bkRuntimeFuncBoundary=" bd ", want > 0 (no baked runtime installed?)")
            if (el <= 0) bad("compile #" n ": " el " paste-eligible functions, want > 0 -- the object-code paste is silently off (audit finding F1)")
            if (ov < bd) bad("compile #" n ": pending bkLdObjValid.count=" ov " < boundary=" bd " -- pending object staging was truncated in place (audit finding F2)")
            if (n == 0) { el0 = el; bd0 = bd; ov0 = ov }
            else if (el != el0 || bd != bd0 || ov != ov0)
                bad("compile #" n " state {objvalid=" ov " boundary=" bd " eligible=" el "} differs from compile #0 {objvalid=" ov0 " boundary=" bd0 " eligible=" el0 "} -- the install is not reproducing the same baked runtime every compile")
            n++
        }
        END {
            if (failed) exit 1
            if (n != want) { print "got " (n + 0) " BAKESTATE lines, want " want; exit 1 }
        }
    ' "$ERRLOG") || { t_fail "$1" "$_msg"; return 1; }
    return 0
}

if ! leak_run "$SCRATCH/1x" "$WORK/dblcompile_bake" "$bake" "$tickprobe"; then
    t_fail DoubleCompileBake "$ERR"
    t_done
fi
live1=$LIVE
check_states DoubleCompileBake 1 || t_done

if leak_run "$SCRATCH/3x" "$WORK/dblcompile_bake" "$bake" "$tickprobe" "$tickprobe" "$tickprobe"; then
    check_states DoubleCompileBake 3 \
        && growth_ok DoubleCompileBake "$live1" "$LIVE" "bake-path " \
        && fork_identity DoubleCompileBake "$SCRATCH/3x" \
        && t_pass DoubleCompileBake
else
    t_fail DoubleCompileBake "$ERR"
fi

if leak_run "$SCRATCH/3x-alt" "$WORK/dblcompile_bake" "$bake" "$tickprobe" "$catprobe" "$tickprobe"; then
    check_states DoubleCompileBakeAlternating 3 \
        && growth_ok DoubleCompileBakeAlternating "$live1" "$LIVE" "bake-path alternating-fixture " \
        && fork_identity DoubleCompileBakeAlternating "$SCRATCH/3x-alt" \
            "stale state leaked across a different-fixture compile" \
        && t_pass DoubleCompileBakeAlternating
else
    t_fail DoubleCompileBakeAlternating "$ERR"
fi

t_done
