#!/bin/sh
# Port of internal/bake/bakeidentity_test.go's TestBakeFullCorpusTestapi
# (deliverable (a), fix round 2): a --testapi program's `emit68k --rtbake`
# output must be byte-identical to from-source --testapi -- fix round 2
# (driveManifestSplice reassembling combined2 from three separately-tracked
# chains, in exactly the bake's own fixed order) closed the ordering gap
# deliverable (a)'s first-round report flagged as unresolved.
#
# PAIRFB=ignore because the Go original makes no "falling back" assertion
# here (unlike runEmit68k's own callers); the flags are its own verbatim
# `--rtdir runtime/clarus/ --testapi`.
. "$(dirname "$0")/../lib.sh"
. "$(dirname "$0")/../lib_bake.sh"
require_env CLARUS_BAKE_FULL

BAKE=$WORK/rt68k.clir
bake_ir 68k "$BAKE"
write_testapi_fixture "$WORK/testapi_fixture.cla"

PAIRFLAGS="--rtdir runtime/clarus/ --testapi"
PAIRFB=ignore
if detail=$(emit68k_pair testapi "$WORK/testapi_fixture.cla"); then
    t_pass testapi
else
    t_fail testapi "$detail"
fi
t_done
