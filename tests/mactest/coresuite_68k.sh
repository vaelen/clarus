#!/bin/sh
# timeout: 20m
# mactest/coresuite_68k -- port of internal/mactest/coresuite_test.go's
# TestCoreSuiteGUIOn68k: ONE native 68k boot of the core suite's GUI front
# end (coreGUIFiles == tests/mactest/coregui_files.txt), driven by
# testdata/ui/coresuite.events (one click on Run All, then quit).
#
# Deliberately NOT a frozen golden scenario: there is no
# testdata/ui/coresuite.trace or testdata/uisnaps entry and none should
# ever be added. The gate is content-based -- kit.cla's tkReport alert()s a
# `PASS <name>` / `FAIL <name>: <detail>` line per case plus a final
# `TOTAL n PASS p FAIL f`, and every case line is re-emitted here so the
# runner reports per case (the Go test's per-case t.Run).
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_mac.sh" || die "helper lib failed to load"
require_env CLARUS_MAC_TESTS

# Word splitting is the point: the list has no spaces in it.
# shellcheck disable=SC2046
emit68k -o "$WORK/coresuite_gui.bin" \
    --events testdata/ui/coresuite.events \
    $(cat "$ROOT/tests/mactest/coregui_files.txt") > "$WORK/emit.log" 2>&1 \
    || die "clarusc emit68k coresuite GUI: $(tail -20 "$WORK/emit.log")"

run_mac "$WORK/coresuite_gui.bin" 300
[ "$MAC_EXIT" = 0 ] || die "coresuite GUI exit code $MAC_EXIT, want 0
capture:
$(cat "$WORK/cap.out")"
suite_report_check "$WORK/cap.out" 81
t_done
