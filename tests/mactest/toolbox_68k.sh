#!/bin/sh
# timeout: 20m
# mactest/toolbox_68k -- port of internal/mactest/coresuite_test.go's
# TestToolboxSuiteOn68k: ONE native 68k boot of the toolbox suite's GUI
# (toolbox_files.txt, `--testapi` + `--bake`), driven by
# testdata/ui/toolboxsuite.events (one click on Run All, then quit). Every
# case here calls a REAL Toolbox trap or reads the REAL screen framebuffer
# in-process. Content-based gate, no trace/snap goldens; each of the 39
# result lines is re-emitted so the runner reports per case.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_mac.sh" || die "helper lib failed to load"
require_env CLARUS_MAC_TESTS

toolbox_emit68k "$WORK/toolboxsuite_gui.bin" testdata/ui/toolboxsuite.events
# 420, not 300: the suite's own wall clock on a Mac Plus was already
# 287 s of that 300 s budget before the AppleTalk phase, and AtalkSelf
# adds ~6.5 s of REAL AppleTalk time that cannot be shortened -- NBP
# runs its full retry budget on both registerName (verifyFlag on) and
# lookupName, ~3.2 s each at interval 8 / count 3 (task-1-report.md P2).
# The 13 s of headroom that left was going to bite the next case added
# here whatever it was. Still well inside the script's own 20m deadline.
run_mac "$WORK/toolboxsuite_gui.bin" 420
[ "$MAC_EXIT" = 0 ] || die "toolbox suite exit code $MAC_EXIT, want 0
capture:
$(cat "$WORK/cap.out")"
suite_report_check "$WORK/cap.out" 39
t_done
