#!/bin/sh
# timeout: 20m
# mactest/toolbox_mac -- port of internal/mactest/coresuite_test.go's
# TestToolboxSuiteOnMac: TestToolboxSuiteOn68k's Retro68/cprint-lane twin.
# Same toolbox_files.txt composition, same toolboxsuite.events script, same
# per-case result contract -- built via scripts/build-mac.sh instead of
# `clarusc emit68k`.
#
# No --bake on this lane (build-mac.sh has no such flag; the Go twin passes
# none either), so cases_resources.cla's baked-resource lookup has nothing
# to find here.
#
# THIS SCRIPT DOES NOT COMPILE AS OF THE MacTCP PHASE (debt 3, 2026-09-08),
# and it fails in build_mac, not on a suite case. AdspLeak's section 4
# (testsuite/toolbox/cases_atalk.cla, see its own header) names the NATIVE
# AppleTalk waist -- rtAt68DspInitEnd/rtAdspDevClose -- which only
# `clarusc emit68k --testapi` makes visible: drive.cla's driveEarlySplice
# gates that widening on want68k, and rtAt68DspInitEnd has no counterpart
# in runtime/clarus/atalk_c.cla at all. build-mac.sh goes through
# `clarusc emit` (want68k false), so this suite no longer checks on this
# lane. Left in place rather than deleted: the whole cprint lane is an
# opt-in cross-lane diagnostic mactest/toolbox_68k already covers case for
# case, and it is slated for deletion in the 5f Retro68-retirement phase.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_mac.sh" || die "helper lib failed to load"
require_env CLARUS_CPRINT_MAC_TESTS

# Word splitting is the point: the list has no spaces in it.
# shellcheck disable=SC2046
bin=$(build_mac toolboxsuite_gui_mac \
    $(cat "$ROOT/tests/mactest/toolbox_files.txt") \
    --test --events testdata/ui/toolboxsuite.events --testapi) || exit 1

# 420 for the same reason toolbox_68k.sh's own settle was raised: the
# suite's AtalkSelf case spends ~6.5 s in real NBP retries.
run_mac "$bin" 420
[ "$MAC_EXIT" = 0 ] || die "toolbox suite (Retro68) exit code $MAC_EXIT, want 0
capture:
$(cat "$WORK/cap.out")"
suite_report_check "$WORK/cap.out" 40
t_done
