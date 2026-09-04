#!/bin/sh
# timeout: 20m
# mactest/tick -- port of internal/mactest/native_test.go's
# TestRealEventLoopTickOn68k: boots testdata/cg68k/tickprobe.cla with NO
# --events script, the only test that exercises rtUiRun's real
# WaitNextEvent loop and rtUiEveryPump's real UiTickCount scheduling. The
# fixture's `every 1 ticks` block counts to 60 and quits, so a regressed
# timer path never fires and the boot deadline IS the failure signal.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_mac.sh" || die "helper lib failed to load"
require_env CLARUS_MAC_TESTS

emit68k -o "$WORK/tickprobe.bin" testdata/cg68k/tickprobe.cla \
    > "$WORK/emit.log" 2>&1 \
    || die "clarusc emit68k tickprobe: $(tail -10 "$WORK/emit.log")"

run_mac "$WORK/tickprobe.bin" 180
if [ "$MAC_EXIT" != 0 ]; then
    t_fail tick "tickprobe exit code $MAC_EXIT, want 0"
else
    t_pass tick
fi
t_done
