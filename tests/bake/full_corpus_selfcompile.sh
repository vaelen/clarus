#!/bin/sh
# Port of internal/bake/bakeidentity_test.go's
# TestBakeFullCorpusSelfCompile: exhaustively re-proves self-compile
# identity (already in identity.sh's own T1 slice, kept here too for a
# single "CLARUS_BAKE_FULL=1 covers everything" entry point).
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"
require_env CLARUS_BAKE_FULL

BAKE=$WORK/rt68k.clir
bake_ir 68k "$BAKE"

if detail=$(emit68k_pair self-compile clarusc/main.cla); then
    t_pass self-compile
else
    t_fail self-compile "$detail"
fi
t_done
