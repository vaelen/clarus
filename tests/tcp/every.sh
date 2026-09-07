#!/bin/sh
# tests/tcp/every.sh (MacTCP phase, Task 6, spec %4.3) -- the CLI lifetime
# rule with a live TCP listener and no client at all: the program stays
# alive (a listener holds it open) and its `every` timer keeps firing, so
# the only thing that ends it is its own `quit 0` at beat 20.
#
# The FLOOR is the load-bearing half. The transcript alone proves nothing:
# a timer that fires on every pump pass prints the same "beats 20" and
# exits 0. Only elapsed wall clock separates the two -- 20 fires of a
# 6-tick (100 ms) timer cannot physically happen in under ~2 s, so a floor
# of 1 s (allowing for `date +%s`'s whole-second truncation) fails
# instantly against a free-running timer, while contention can only push
# real elapsed time UP. The ceiling catches a timer that arms but never
# comes due.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_tcp.sh" || die "helper lib failed to load"

require_tool "$TOOLS/tcpdrive"

tcp_build every_server || { t_fail build "$(cat "$WORK/every_server.build")"; t_done; }
t_pass build

port=$("$TOOLS/tcpdrive" pick-port) || { t_fail listen "pick-port failed"; t_done; }

t0=$(date +%s)
"$TOOLS/timeout" 30 "$WORK/every_server" "$port" > "$WORK/out" 2>&1
rc=$?
elapsed=$(( $(date +%s) - t0 ))

[ $rc -eq 0 ] && t_pass exit0 \
    || t_fail exit0 "exit $rc, want 0 (124 = never quit within 30s): $(tr '\n' '|' < "$WORK/out")"

printf 'listening\nbeats 20\n' > "$WORK/want"
if cmp -s "$WORK/out" "$WORK/want"; then
    t_pass output
else
    t_fail output "stdout mismatch: $(first_diff "$WORK/want" "$WORK/out" | tr '\n' ' ')"
fi

if [ "$elapsed" -lt 1 ]; then
    t_fail timing_floor "finished in ${elapsed}s; 20 fires of a 6-tick (100ms) timer cannot take under ~2s -- the timer is firing on every pump pass, not on its period"
else
    t_pass timing_floor
fi

[ "$elapsed" -le 15 ] && t_pass timing_ceiling \
    || t_fail timing_ceiling "took ${elapsed}s, want <= 15s for 20 fires of a 6-tick (100ms) timer"
t_done
