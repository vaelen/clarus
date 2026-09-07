#!/bin/sh
# tests/tcp/runerr.sh (MacTCP phase, Task 6) -- the error-principle fence
# for TCP: a peer close RELEASES the slot before `closed` fires, so a
# `send` from inside that handler is a contract violation and stays the
# existing `connection not open` runtime error, not a `failed` event.
# Everything environmental is covered by failed.sh instead.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_tcp.sh" || die "helper lib failed to load"

require_tool "$TOOLS/tcpdrive"

tcp_build send_closed || { t_fail build "$(cat "$WORK/send_closed.build")"; t_done; }
t_pass build

# The peer closes the instant it is connected.
printf 'close\nsleep 200\n' > "$WORK/peer.script"
"$TOOLS/tcpdrive" listen 0 "$WORK/peer.script" > "$WORK/peer.out" 2>&1 &
peer=$!
port=$(tcp_wait_port "$WORK/peer.out" "$peer")
if [ -z "$port" ]; then
    kill "$peer" 2>/dev/null
    wait "$peer" 2>/dev/null
    t_fail listen "tcpdrive never reported a bound port: $(cat "$WORK/peer.out")"
    t_done
fi

"$TOOLS/timeout" 15 "$WORK/send_closed" "127.0.0.1:$port" > "$WORK/out" 2>&1
rc=$?
wait "$peer" 2>/dev/null

if [ $rc -eq 0 ]; then
    t_fail send_on_closed "exited 0; expected a runtime error"
elif grep -q 'runtime error: connection not open' "$WORK/out"; then
    t_pass send_on_closed
else
    t_fail send_on_closed "exit $rc, output [$(tr '\n' '|' < "$WORK/out")], want [runtime error: connection not open]"
fi
t_done
