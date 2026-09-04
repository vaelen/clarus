#!/bin/sh
# cg68k/determinism -- port of internal/cg68k/golden_test.go's
# TestCg68kDeterminism: run emit68k twice on control.cla (the control-flow
# fixture, the one most likely to expose non-deterministic label numbering
# or map-iteration-order dependence) and require the two out.seg1.dat byte
# streams to be identical.
. "$(dirname "$0")/../lib.sh"

fixture=$ROOT/testdata/cg68k/control.cla
[ -f "$fixture" ] || die "missing fixture $fixture"

run() {
    mkdir -p "$1" || die "mkdir $1"
    if ! out=$("$CLARUSC" emit68k -o "$1/out.bin" --listing "$fixture" 2>&1); then
        echo "$out"
        die "clarusc emit68k -o $1/out.bin --listing $fixture failed"
    fi
    [ -f "$1/out.seg1.dat" ] || die "no $1/out.seg1.dat"
}

run "$WORK/d1"
run "$WORK/d2"

if cmp -s "$WORK/d1/out.seg1.dat" "$WORK/d2/out.seg1.dat"; then
    t_pass control.cla
else
    t_fail control.cla "emit68k is non-deterministic: control.cla's out.seg1.dat differs across two runs ($(wc -c < "$WORK/d1/out.seg1.dat" | tr -d ' ') vs $(wc -c < "$WORK/d2/out.seg1.dat" | tr -d ' ') bytes)"
fi
t_done
