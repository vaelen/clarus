#!/bin/sh
# timeout: 20m
# mactest/toolbox_jiggle -- port of internal/mactest/coresuite_test.go's
# TestToolboxSuiteJiggleOn68k: TestToolboxSuiteOn68k's stress-mode twin.
# Identical build; driven by testdata/ui/toolboxsuite_jiggle.events, which
# prepends `jiggle on` before the same click/quit script. With jiggle on,
# uiscript.cla's rtUiJiggleTick forces a full CompactMem before every
# scripted dispatch AND at ui.cla's UiNewPtr allocation waist, so every
# unlocked relocatable block that CAN move DOES -- turning the
# stale-master-pointer-across-compaction bug class from luck into
# determinism.
#
# A per-case FAIL here with toolbox_68k green is exactly the target signal:
# a real stale-master-pointer bug. A FAIL in the exit code or capture
# format itself means something more basic broke.
#
# 15m boot budget (vs the plain suite's 5m): CompactMem before every
# dispatch and every UiNewPtr call is a lot more heap walking.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_mac.sh" || die "helper lib failed to load"
require_env CLARUS_MAC_TESTS

toolbox_emit68k "$WORK/toolboxsuite_jiggle_gui.bin" testdata/ui/toolboxsuite_jiggle.events
run_mac "$WORK/toolboxsuite_jiggle_gui.bin" 900
[ "$MAC_EXIT" = 0 ] || die "toolbox suite (jiggle) exit code $MAC_EXIT, want 0
capture:
$(cat "$WORK/cap.out")"
suite_report_check "$WORK/cap.out" 38
t_done
