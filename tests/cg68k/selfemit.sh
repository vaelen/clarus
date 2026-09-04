#!/bin/sh
# timeout: 30m
# cg68k/selfemit -- port of internal/cg68k/selfemit_test.go's
# TestSelfEmit68k: clarusc emitting ITSELF (clarusc/main.cla) via emit68k
# must succeed outright at the DEFAULT segment limit (no --seglimit).
. "$(dirname "$0")/../lib.sh" || exit 2

run=$WORK/selfemit
mkdir -p "$run" || die "mkdir $run"
out=$(emit68k -o "$run/clarusc68k.bin" --listing "$ROOT/clarusc/main.cla" 2>&1)
rc=$?
if [ $rc -ne 0 ]; then
    t_fail selfemit68k "clarusc emit68k --rtdir $RTDIR -o $run/clarusc68k.bin --listing $ROOT/clarusc/main.cla failed (want success -- fpIntrCall split should have closed the last self-emit blocker)"
    echo "$out"
else
    n=0
    while [ -f "$run/clarusc68k.seg$((n + 1)).s" ]; do n=$((n + 1)); done
    echo "clarusc self-emit succeeded, packed into $n CODE segment(s)"
    t_pass selfemit68k
fi
t_done
