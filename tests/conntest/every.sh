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
# Timing is an assertion here, as a CEILING. 6 ticks is 100 ms, so three
# fires is ~0.35 s of real waiting unloaded (measured); the budget catches a
# timer that arms but never comes due, or one whose deadline arithmetic runs
# away, without waiting out the outer $TOOLS/timeout 10 net (expiry there is
# exit 124, distinguishable from any real exit code the program can produce).
#
# 8 s, not the 2 s this task was drafted with, for exactly the reason
# abort.sh's own header records: wall clock under `make -j t1` is not the
# same budget as wall clock alone. This loop idles in 20 ms usleep()s, whose
# real duration stretches with CPU contention -- the drafted 2 s measured 4 s
# under a full parallel t1 on an otherwise idle machine. 8 s is still ~20x
# the unloaded run and ~20x short of a hang.
#
# The proof that the timer is PERIODIC rather than free-running is the
# fixture's own shape, not the clock: `every 6 ticks` counts n to 3 and
# quits, so the exact "tick 1/tick 2/tick 3" transcript below can only come
# from three separate due passes.
. "$(dirname "$0")/../lib.sh" || exit 2

host_build "$WORK/every_cli" testdata/emitui/every_cli.cla > "$WORK/build.log" 2>&1 \
    || { t_fail build "$(cat "$WORK/build.log")"; t_done; }
t_pass build

t0=$(date +%s)
"$TOOLS/timeout" 10 "$WORK/every_cli" > "$WORK/out" 2>&1
rc=$?
t1=$(date +%s)
elapsed=$((t1 - t0))

[ $rc -eq 0 ] && t_pass exit0 \
    || t_fail exit0 "exit $rc, want 0 (124 = never quit within 10s): $(cat "$WORK/out")"

printf 'start\ntick 1\ntick 2\ntick 3\n' > "$WORK/want"
if cmp -s "$WORK/out" "$WORK/want"; then
    t_pass output
else
    t_fail output "stdout mismatch: $(first_diff "$WORK/want" "$WORK/out" | tr '\n' ' ')"
fi

[ "$elapsed" -le 8 ] && t_pass timing \
    || t_fail timing "took ${elapsed}s, want <= 8s for 3 fires of a 6-tick (100ms) timer"

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
