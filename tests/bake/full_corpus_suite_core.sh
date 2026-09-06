#!/bin/sh
# Port of internal/bake/bakeidentity_test.go's TestBakeFullCorpusSuiteCore
# (deliverable (e)'s suite-build addendum): the core suite's --testapi
# gui.cla composition, host emit68k (no emulator boot needed for
# byte-identity), must be byte-identical via --rtbake.
#
# The file list is tests/mactest/coregui_files.txt, the same one the
# coresuite_68k boot composes (one path per line, no comments -- so the
# unquoted $(cat) word-split below is exactly right).
# runner.cla calls every cases_* family unconditionally, so a composition
# that drops one fails to CHECK at all.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"
require_env CLARUS_BAKE_FULL

BAKE=$WORK/rt68k.clir
bake_ir 68k "$BAKE"

PAIRFLAGS=--testapi
if detail=$(emit68k_pair core $(cat "$ROOT/tests/mactest/coregui_files.txt")); then
    t_pass core_suite
else
    t_fail core_suite "$detail"
fi
t_done
