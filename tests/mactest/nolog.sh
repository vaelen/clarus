#!/bin/sh
# timeout: 10m
# mactest/nolog -- a production native build (emit68k WITHOUT --capture or
# --events) writes no `out` file at all. testdata/mactest/nolog.cla calls
# log("x") and quits 0; booted with run_mac's own LaunchAPPL invocation.
#
# Observed LaunchAPPL behavior with no `out` file (2026-09-29): it treats
# the missing file as an empty capture -- exit 0, nothing on stdout. So
# the assertion is exit 0 plus an empty capture (in particular, no
# ##CLARUS-EXIT## trailer). Before production mode existed this boot
# captured "##CLARUS-EXIT## 0 / ##CLARUS-LOG## / x" (35 bytes).
#
# Second subcase (initpanic): the opposite direction. A --capture build of
# testdata/mactest/initpanic.cla, whose GLOBAL INITIALIZER panics before
# any handler runs, must still write `out` with "##CLARUS-EXIT## 3" and
# the panic text in the log -- natSetCapture has to run before
# cg_init_globals, not after it.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_mac.sh" || die "helper lib failed to load"
require_env CLARUS_MAC_TESTS

emit68k -o "$WORK/nolog.bin" testdata/mactest/nolog.cla \
    > "$WORK/emit.log" 2>&1 \
    || die "clarusc emit68k nolog: $(tail -10 "$WORK/emit.log")"

# run_mac's LaunchAPPL call, minus capture_split (which dies on a missing
# trailer -- the whole point here).
mac_launch macplus
mkdir -p "$WORK/launch"
# shellcheck disable=SC2086
( cd "$WORK/launch" && "$TOOLS/timeout" 180 $MAC_LAUNCH "$WORK/nolog.bin" \
    > "$WORK/cap.raw" 2> "$WORK/cap.err" )
rc=$?
mac_kill_ours "$WORK/launch"
[ $rc -eq 124 ] && die "LaunchAPPL nolog.bin timed out (emulator killed): $(head -5 "$WORK/cap.err")"

if [ $rc -ne 0 ]; then
    t_fail launch "LaunchAPPL exit $rc, want 0: $(head -5 "$WORK/cap.err")"
elif [ -s "$WORK/cap.raw" ]; then
    t_fail empty "capture not empty ($(wc -c < "$WORK/cap.raw") bytes): $(head -5 "$WORK/cap.raw")"
else
    t_pass nolog
fi

emit68k --capture -o "$WORK/initpanic.bin" testdata/mactest/initpanic.cla \
    > "$WORK/emit2.log" 2>&1 \
    || die "clarusc emit68k initpanic: $(tail -10 "$WORK/emit2.log")"
run_mac "$WORK/initpanic.bin" 180
if [ "$MAC_EXIT" != 3 ]; then
    t_fail initpanic "exit code $MAC_EXIT, want 3"
elif ! grep -q 'runtime error' "$WORK/cap.log"; then
    t_fail initpanic "panic text missing from the captured log: $(head -3 "$WORK/cap.log")"
else
    t_pass initpanic
fi
t_done
