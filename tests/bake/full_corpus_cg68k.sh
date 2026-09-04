#!/bin/sh
# Port of internal/bake/bakeidentity_test.go's TestBakeFullCorpusCg68k
# (runtime-ir-bake Task 5, deliverable (e)): the exhaustive counterpart of
# identity.sh -- every testdata/cg68k fixture in cg68kAllFixtures, single-
# or multi-segment, must be byte-identical. No allowlist: fix rounds 1/2
# closed both divergence classes this gate originally found, and a clean
# oracle needs no exceptions.
#
# Gated behind CLARUS_BAKE_FULL=1 (requireBakeFull), wired into `make t2`.
. "$(dirname "$0")/../lib.sh"
. "$(dirname "$0")/../lib_bake.sh"
require_env CLARUS_BAKE_FULL

BAKE=$WORK/rt68k.clir
bake_ir 68k "$BAKE"

for base in abort_bake.cla arc.cla argmat_intr.cla argmat_nested.cla arith.cla arr_whole_assign.cla \
        bigtmp16.cla bounce.cla callback.cla calls.cla clear_deep.cla \
        control.cla enums.cla gapclose3.cla globals.cla inline_a5.cla mutrec.cla \
        peep_clr.cla peep_pushpop.cla peep_quick.cla peep_shuffle.cla recs.cla \
        regnamed.cla smalltmp_ceiling.cla smoke.cla strcontainers.cla strs.cla \
        tickprobe.cla traps.cla xrec.cla; do
    if detail=$(emit68k_pair "$base" "$ROOT/testdata/cg68k/$base"); then
        t_pass "$base"
    else
        t_fail "$base" "$detail"
    fi
done
t_done
