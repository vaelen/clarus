#!/bin/sh
# tests/conntest/every.sh -- AppleTalk phase Task 5: `every` timers on the
# HOST lane. A non-UI program (no window, no menu) that declares an `every`
# block used to lower as a UI program: #include "rt_ui.h", cpEmitUiMain, and
# no way to build against runtime/host at all. It now gets lowering's
# synthesized clar_every_pump() driven from cpEmitMain's own pump loop.
#
# testdata/emitui/every_cli.cla is the fixture (shared with the emitui
# golden, so the emitted C and the RUNNING program are pinned by the same
# file): it logs "start" from App.startCLI, then `every 6 ticks` counts to 3
# and quits 0.
#
# Timing is asserted from BOTH sides, and the FLOOR is the load-bearing one.
# The transcript alone proves nothing about periodicity: an rt_ext_EveryDue
# stubbed to return 1 unconditionally -- period ignored, arming ignored --
# prints exactly the same "start/tick 1/tick 2/tick 3" and exits 0. Only
# elapsed wall clock separates the two. The fixture's period is therefore 60
# ticks (one second), so three fires cannot physically happen in under ~3 s,
# and a floor of 2 s (allowing for `date +%s`'s whole-second truncation)
# fails instantly against a free-running timer while contention can only
# ever push real elapsed time UP, never below the floor.
#
# The ceiling is the other half: it catches a timer that arms but never
# comes due, or one whose deadline arithmetic runs away. 10 s against a ~3 s
# nominal run, because wall clock under `make -j t1` is not the same budget
# as wall clock alone -- exactly the reason abort.sh's own header records
# for its own 2 s -> 10 s raise. $TOOLS/timeout 20 is the outer net, kept
# clear of the ceiling so a real overrun is reported as a timing FAIL with
# its measured seconds rather than as an opaque exit 124.
. "$(dirname "$0")/../lib.sh" || exit 2

host_build "$WORK/every_cli" testdata/emitui/every_cli.cla > "$WORK/build.log" 2>&1 \
    || { t_fail build "$(cat "$WORK/build.log")"; t_done; }
t_pass build

t0=$(date +%s)
"$TOOLS/timeout" 20 "$WORK/every_cli" > "$WORK/out" 2>&1
rc=$?
t1=$(date +%s)
elapsed=$((t1 - t0))

[ $rc -eq 0 ] && t_pass exit0 \
    || t_fail exit0 "exit $rc, want 0 (124 = never quit within 20s): $(cat "$WORK/out")"

printf 'start\ntick 1\ntick 2\ntick 3\n' > "$WORK/want"
if cmp -s "$WORK/out" "$WORK/want"; then
    t_pass output
else
    t_fail output "stdout mismatch: $(first_diff "$WORK/want" "$WORK/out" | tr '\n' ' ')"
fi

if [ "$elapsed" -lt 2 ]; then
    t_fail timing_floor "finished in ${elapsed}s; 3 fires of a 60-tick (1s) timer cannot take under ~3s -- the timer is not arming, it is firing on every pass"
else
    t_pass timing_floor
fi

[ "$elapsed" -le 10 ] && t_pass timing_ceiling \
    || t_fail timing_ceiling "took ${elapsed}s, want <= 10s for 3 fires of a 60-tick (1s) timer"

# The UI path is unchanged: every.cla declares the SAME `every` construct but
# HAS a window, so it must still emit byte-for-byte its committed golden.
# tests/emitui/goldens.sh compares it too, but that whole script SKIPs
# without the m68k cross-compiler -- this check does not.
if "$CLARUSC" emit --rtdir "$RTDIR" -o "$WORK/every.c" testdata/emitui/every.cla \
        > "$WORK/emit.log" 2>&1 && cmp -s "$WORK/every.c" testdata/emitui/every.c.golden; then
    t_pass ui_golden_unchanged
else
    t_fail ui_golden_unchanged "every.cla no longer matches its golden: $(first_diff testdata/emitui/every.c.golden "$WORK/every.c" | tr '\n' ' ')$(head -3 "$WORK/emit.log")"
fi
t_done
