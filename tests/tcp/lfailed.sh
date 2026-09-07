#!/bin/sh
# tests/tcp/lfailed.sh (MacTCP phase, Task 6, fix round 1) -- `l.failed`
# must actually fire for a TCP listener. Its staged event is drained by
# rtAtalkPump, whose `rtAtUp` guard no TCP path ever satisfies (only
# rtAtEnsureUp sets it, and rtLsnListen brings TCP up through
# rtTcpEnsureUp), so the whole of spec %4.2's failure surface was
# silently discarded until that drain was hoisted above the guard.
# Nothing else in tests/tcp/ can see it: every other script's listener
# starts cleanly.
#
# The provocation is the cheapest real one -- two servers on one port.
# A tcpdrive peer would NOT do: it binds 127.0.0.1 while the runtime
# binds INADDR_ANY, and SO_REUSEADDR lets those coexist on BSD. Two
# identical wildcard listeners is the case SO_REUSEADDR does not cover,
# so the second gets EADDRINUSE -> "port in use".
#
# echo_server.cla's own `on lsn.failed` logs the code and message and
# `quit 1`s, so the handler running IS the assertion: exit 124 here means
# the event never fired at all.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_tcp.sh" || die "helper lib failed to load"

require_tool "$TOOLS/tcpdrive"

tcp_build echo_server || { t_fail build "$(cat "$WORK/echo_server.build")"; t_done; }
t_pass build

port=$("$TOOLS/tcpdrive" pick-port) || { t_fail listen "pick-port failed"; t_done; }

# The holder is a first echo_server: it stays alive on the port (a live
# listener holds a CLI program open) until this script kills it.
"$WORK/echo_server" "$port" > "$WORK/hold.out" 2>&1 &
hold=$!
i=0
while [ $i -lt 10 ]; do
    grep -q '^listening$' "$WORK/hold.out" 2>/dev/null && break
    sleep 1
    i=$((i + 1))
done
if grep -q '^lfailed' "$WORK/hold.out" 2>/dev/null; then
    kill "$hold" 2>/dev/null; wait "$hold" 2>/dev/null
    t_fail listen "the FIRST server could not take port $port: $(tr '\n' '|' < "$WORK/hold.out")"
    t_done
fi

"$TOOLS/timeout" 20 "$WORK/echo_server" "$port" > "$WORK/out" 2>&1
rc=$?
kill "$hold" 2>/dev/null
wait "$hold" 2>/dev/null

[ $rc -eq 1 ] && t_pass exit1 \
    || t_fail exit1 "exit $rc, want 1 from the handler's own quit (124 = the failed event never fired at all): $(tr '\n' '|' < "$WORK/out")"

if grep -Eq '^lfailed [0-9]+ port in use$' "$WORK/out"; then
    t_pass lfailed_line
else
    t_fail lfailed_line "no 'lfailed <code> port in use' line: $(tr '\n' '|' < "$WORK/out")"
fi
t_done
