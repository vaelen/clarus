#!/bin/sh
# stackguard: drive.cla's drvStackGuard (SE wave 5), the native-only
# depth guard at the top of every recursive parse/check/lower/codegen
# walker.
#   examples: on the host DrvStackPtr is 0, so the guard is a no-op --
#             `clarusc build68k` of every examples/*.cla still succeeds.
#   abort_*:  a guard abort inside one resident compile (the TESTONLY
#             CLARUS_STACKGUARD_FORCE=N fires it on the Nth guard call in
#             the process, through the same abort -> attempt path a real
#             overflow takes) leaves no half-built state: the NEXT compile
#             in the same process (clarusc/test/dblcompile.cla, the
#             macgui.cla per-compile sequence) is byte-identical to a
#             fresh one. N = 1 fires in the parser, N = half and last-1 of
#             the per-compile call count (found by bisection) land later,
#             last-1 in codegen, the final phase that calls the guard.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$ROOT/tests/lib_mactest_host.sh" || die "helper lib failed to load"

for f in "$ROOT"/examples/*.cla; do
    b=$(basename "$f" .cla)
    if build68k -o "$WORK/$b.bin" "$f" > "$WORK/$b.log" 2>&1; then
        t_pass "examples_$b"
    else
        t_fail "examples_$b" "build68k failed: $(tail -3 "$WORK/$b.log" | tr '\n' ' ')"
    fi
done

# The harness's compiles walk up from their cwd for runtime/clarus/, so
# they run under build-run/.
scratch_under_br bake-stackguard
ENTRY=$ROOT/testdata/cg68k/tickprobe.cla
host_build "$WORK/dblcompile" clarusc/test/dblcompile.cla > "$WORK/build.log" 2>&1 \
    || die "build clarusc/test/dblcompile.cla failed: $(tail -5 "$WORK/build.log")"

# run NAME N ENTRY... : dblcompile in $SCRATCH/NAME with FORCE=N (0 = off).
run() {
    _d=$SCRATCH/$1
    _n=$2
    shift 2
    rm -rf "$_d"
    mkdir -p "$_d"
    (cd "$_d" && CLARUS_STACKGUARD_FORCE=$_n "$WORK/dblcompile" "$@") > "$_d/log" 2>&1
}
# aborts N : does a one-entry compile abort with FORCE=N?
aborts() {
    run probe "$1" "$ENTRY" && grep -q 'ABORTED: source too deeply nested' "$SCRATCH/probe/log"
}

run fresh 0 "$ENTRY" || die "fresh compile failed: $(tail -5 "$SCRATCH/fresh/log")"
[ -f "$SCRATCH/fresh/leakfork_0.bin" ] || die "fresh compile wrote no fork"

# Bisect the per-compile guard call count: the largest N that aborts.
lo=1
hi=1024
while aborts "$hi"; do
    lo=$hi
    hi=$((hi * 2))
    [ "$hi" -le 268435456 ] || die "the guard fired at every N up to $hi"
done
aborts "$lo" || die "FORCE=1 did not abort the compile: $(tail -3 "$SCRATCH/probe/log")"
while [ $((hi - lo)) -gt 1 ]; do
    mid=$(((lo + hi) / 2))
    if aborts "$mid"; then lo=$mid; else hi=$mid; fi
done
calls=$lo

for c in "parse 1" "mid $((calls / 2))" "codegen $((calls - 1))"; do
    name=abort_${c% *}
    n=${c#* }
    if ! run "$name" "$n" "$ENTRY" "$ENTRY"; then
        t_fail "$name" "harness failed: $(tail -3 "$SCRATCH/$name/log" | tr '\n' ' ')"
    elif ! grep -q 'COMPILE 0 .* ABORTED: source too deeply nested$' "$SCRATCH/$name/log"; then
        t_fail "$name" "first compile did not abort: $(head -3 "$SCRATCH/$name/log" | tr '\n' ' ')"
    elif ! cmp -s "$SCRATCH/fresh/leakfork_0.bin" "$SCRATCH/$name/leakfork_1.bin"; then
        t_fail "$name" "the compile after the abort differs from a fresh one"
    else
        t_pass "$name"
        echo "  ($name: N=$n of $calls guard calls)"
    fi
done
t_done
