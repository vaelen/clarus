#!/bin/sh
# timeout: 20m
# mactest/coresuite_mac -- port of internal/mactest/coresuite_test.go's
# TestCoreSuiteGUIOnMac: TestCoreSuiteGUIOn68k's Retro68/cprint-lane twin.
# Same coreGUIFiles composition, same coresuite.events script, same
# PASS/FAIL/TOTAL contract -- built through scripts/build-mac.sh's
# Retro68/cmake/gcc pipeline instead of `clarusc emit68k`.
. "$(dirname "$0")/../lib.sh"
. "$(dirname "$0")/../lib_mac.sh"
require_env CLARUS_CPRINT_MAC_TESTS

# Word splitting is the point: the list has no spaces in it.
# shellcheck disable=SC2046
bin=$(build_mac coresuite_gui_mac \
    $(cat "$ROOT/tests/mactest/coregui_files.txt") \
    --test --events testdata/ui/coresuite.events) || exit 1

run_mac "$bin" 300
[ "$MAC_EXIT" = 0 ] || die "coresuite GUI (Retro68) exit code $MAC_EXIT, want 0
capture:
$(cat "$WORK/cap.out")"
suite_report_check "$WORK/cap.out" 81
t_done
