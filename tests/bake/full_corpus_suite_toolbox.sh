#!/bin/sh
# Port of internal/bake/bakeidentity_test.go's
# TestBakeFullCorpusSuiteToolbox (fix round 2, corrected in fix round 3,
# FLIPPED by fallback-trigger-narrowing Task 2): the toolbox suite's
# --testapi gui.cla composition directly names toolbox/files.cla,
# toolbox/standardfile.cla and toolbox/appleevents.cla, each ALSO a
# transitive nested include of one of the thirteen early-spliced modules.
# The bake's own manifest fallback USED to treat that as an unconditional
# collision and recompile the WHOLE composition from source, so this test
# USED to assert the explicit fallback-class shape. Task 2's drift-hash +
# check-only-include mechanism narrows that: those files are unmodified on
# disk and their symbols ARE inside the testapi preload boundary, so case
# (b) applies -- dedup fully, matching from-source's post-dedup state.
#
# The current Go test therefore asserts wantFallback=FALSE: the real bake
# path (no "falling back" note at all) plus byte-identity, exactly like
# full_corpus_suite_core.sh. This port follows the Go source, which is the
# normative assertion list; the Task 9 brief's own "asserts the documented
# fallback-class shape" line describes the PRE-Task-2 test and is stale
# (flagged in task-9-report.md).
#
# The file list is bakeidentity_test.go's own toolboxSuiteGUIFiles,
# verbatim and in order.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"
require_env CLARUS_BAKE_FULL

BAKE=$WORK/rt68k.clir
bake_ir 68k "$BAKE"

PAIRFLAGS=--testapi
if detail=$(emit68k_pair toolbox \
        testsuite/kit.cla \
        toolbox/memory.cla \
        toolbox/events.cla \
        toolbox/osutils.cla \
        toolbox/scrap.cla \
        toolbox/files.cla \
        toolbox/resources.cla \
        toolbox/devices.cla \
        toolbox/serial.cla \
        testsuite/toolbox/runner.cla \
        testsuite/toolbox/cases_events.cla \
        testsuite/toolbox/cases_draw.cla \
        testsuite/toolbox/cases_a5.cla \
        testsuite/toolbox/cases_gestalt.cla \
        testsuite/toolbox/cases_event.cla \
        testsuite/toolbox/harness.cla \
        testsuite/toolbox/cases_uitest.cla \
        testsuite/toolbox/cases_pattern.cla \
        testsuite/toolbox/cases_buttons.cla \
        testsuite/toolbox/cases_winvar.cla \
        testsuite/toolbox/cases_textwidgets.cla \
        testsuite/toolbox/cases_menus.cla \
        testsuite/toolbox/cases_editmenu.cla \
        testsuite/toolbox/cases_canvas.cla \
        testsuite/toolbox/cases_canvasidle.cla \
        testsuite/toolbox/cases_zoomwin.cla \
        testsuite/toolbox/cases_hscroll.cla \
        testsuite/toolbox/cases_popuptable.cla \
        testsuite/toolbox/cases_dialogs.cla \
        testsuite/toolbox/cases_hdim.cla \
        testsuite/toolbox/cases_formedit.cla \
        testsuite/toolbox/cases_bigtext.cla \
        testsuite/toolbox/cases_catalog.cla \
        testsuite/toolbox/cases_finfo.cla \
        testsuite/toolbox/cases_resources.cla \
        testsuite/toolbox/cases_datetime.cla \
        testsuite/toolbox/cases_serial.cla \
        testsuite/toolbox/cases_narrowpopup.cla \
        testsuite/toolbox/cases_leak.cla \
        testsuite/toolbox/cases_scrollend.cla \
        testsuite/toolbox/cases_clearwarm.cla \
        testsuite/toolbox/cases_casestable.cla \
        testsuite/toolbox/cases_winmenus.cla \
        testsuite/toolbox/gui.cla); then
    t_pass toolbox_suite
else
    t_fail toolbox_suite "$detail"
fi
t_done
