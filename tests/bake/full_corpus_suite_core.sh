#!/bin/sh
# Port of internal/bake/bakeidentity_test.go's TestBakeFullCorpusSuiteCore
# (deliverable (e)'s suite-build addendum): the core suite's --testapi
# gui.cla composition, host emit68k (no emulator boot needed for
# byte-identity), must be byte-identical via --rtbake.
#
# The file list is bakeidentity_test.go's own coreSuiteGUIFiles, verbatim
# and in order -- keep in sync with internal/mactest/suite_host_test.go's
# coreCLIFiles and coresuite_test.go's coreGUIFiles if either changes.
# runner.cla calls every cases_* family unconditionally, so a composition
# that drops one fails to CHECK at all.
. "$(dirname "$0")/../lib.sh"
. "$(dirname "$0")/../lib_bake.sh"
require_env CLARUS_BAKE_FULL

BAKE=$WORK/rt68k.clir
bake_ir 68k "$BAKE"

PAIRFLAGS=--testapi
if detail=$(emit68k_pair core \
        testsuite/kit.cla \
        testsuite/core/runner.cla \
        testsuite/core/cases_str.cla \
        testsuite/core/cases_text.cla \
        testsuite/core/cases_list.cla \
        testsuite/core/cases_map.cla \
        testsuite/core/cases_sortedmap.cla \
        testsuite/core/cases_intmap.cla \
        testsuite/core/cases_rec.cla \
        testsuite/core/cases_arr.cla \
        testsuite/core/cases_enumfix.cla \
        testsuite/core/cases_ser.cla \
        testsuite/core/cases_misc.cla \
        testsuite/core/cases_xrec.cla \
        testsuite/core/cases_datetime.cla \
        testsuite/core/cases_param.cla \
        testsuite/core/cases_abort.cla \
        testsuite/core/cases_textrange.cla \
        testsuite/core/cases_errret.cla \
        testsuite/core/cases_evalorder.cla \
        testsuite/core/cases_textbinary.cla \
        testsuite/core/cases_fileh.cla \
        testsuite/core/cases_dirops.cla \
        testsuite/core/cases_ptrcall.cla \
        testsuite/core/gui.cla); then
    t_pass core_suite
else
    t_fail core_suite "$detail"
fi
t_done
