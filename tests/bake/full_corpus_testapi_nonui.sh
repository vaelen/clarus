#!/bin/sh
# Port of internal/bake/bakeidentity_test.go's
# TestBakeFullCorpusTestapiNonUI (fix round 3, CRITICAL 1): the sibling of
# full_corpus_testapi.sh for a NON-UI --testapi program (arith.cla, an
# ordinary testdata/cg68k fixture -- no window/menu/every). From-source
# only ever makes testapi's early-spliced runtime visible to a UI program
# (driveEarlySplice's isUiProgram gate), but the bake path's own testapi
# branch used to install checker/IR testapi visibility unconditionally on
# `testapi` alone, so a non-UI --testapi build diverged (486 bytes
# differing, 33152 vs 33024). Fixed by driveIsUiProgram gating both the
# check-time and the IR-truncation installs on `testapi and isUiProg`.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"
require_env CLARUS_BAKE_FULL

BAKE=$WORK/rt68k.clir
bake_ir 68k "$BAKE"

PAIRFLAGS=--testapi
if detail=$(emit68k_pair arith "$ROOT/testdata/cg68k/arith.cla"); then
    t_pass testapi_nonui
else
    t_fail testapi_nonui "$detail"
fi
t_done
