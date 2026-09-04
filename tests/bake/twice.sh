#!/bin/sh
# Port of internal/bake/bake_test.go's TestBakeTwiceIdentical: baking the
# same lane twice must be byte-identical (the runtime-ir-bake design
# spec's "Bake determinism gets its own check" success criterion).
. "$(dirname "$0")/../lib.sh"
. "$(dirname "$0")/../lib_bake.sh"

for lane in 68k c; do
    bake_ir "$lane" "$WORK/a-$lane.clir"
    bake_ir "$lane" "$WORK/b-$lane.clir"
    if cmp -s "$WORK/a-$lane.clir" "$WORK/b-$lane.clir"; then
        t_pass "$lane"
    else
        t_fail "$lane" "bake --lane $lane not deterministic: $(wc -c < "$WORK/a-$lane.clir") bytes vs $(wc -c < "$WORK/b-$lane.clir") bytes differ: $(cmp "$WORK/a-$lane.clir" "$WORK/b-$lane.clir" 2>&1 | head -1)"
    fi
done
t_done
