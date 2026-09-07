#!/bin/sh
# tests/tcp/connect.sh (MacTCP phase, Task 6) -- the host end-to-end
# CLIENT case. echo_client.cla dials this script's tcpdrive peer over real
# TCP, greets with "READY\r" (a Clarus "\n" literal is CR on the wire on
# BOTH lanes), echoes a 0-255 sweep byte-exactly, echoes a SECOND write
# too (proving `received` fires more than once), then closes itself on
# "QQQ" -- after which the process must exit on its own, unkilled.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_tcp.sh" || die "helper lib failed to load"

require_tool "$TOOLS/tcpdrive"

tcp_build echo_client || { t_fail build "$(cat "$WORK/echo_client.build")"; t_done; }
t_pass build

tcp_sweep "$WORK/sweep"
printf 'a second write, after the sweep' > "$WORK/second"
printf 'QQQ' > "$WORK/qqq"

# The second exchange sends a DIFFERENT payload from the sweep on purpose
# -- a duplicated first echo could otherwise masquerade as a second
# `received` firing.
cat > "$WORK/peer.script" <<PEER
expect-sub "READY\r" 64
send $WORK/sweep
expect $WORK/sweep
send $WORK/second
expect $WORK/second
send $WORK/qqq
expect $WORK/qqq
await-close 5
PEER

# `listen 0` binds an ephemeral port and prints it, so there is no
# pick-port-then-bind window another process can steal.
"$TOOLS/tcpdrive" listen 0 "$WORK/peer.script" > "$WORK/peer.out" 2>&1 &
peer=$!
port=$(tcp_wait_port "$WORK/peer.out" "$peer")
if [ -z "$port" ]; then
    kill "$peer" 2>/dev/null
    wait "$peer" 2>/dev/null
    t_fail listen "tcpdrive never reported a bound port: $(cat "$WORK/peer.out")"
    t_done
fi

"$WORK/echo_client" "127.0.0.1:$port" > "$WORK/prog.out" 2>&1 &
prog=$!

wait "$peer"
prc=$?
if [ $prc -eq 0 ]; then
    t_pass exchange
else
    t_fail exchange "tcpdrive exit $prc: $(cat "$WORK/peer.out")"
fi

tcp_wait_self_exit "$prog" lifetime || echo "prog output: $(cat "$WORK/prog.out")"

# A local close never fires `closed` (spec %4.1), on any transport.
if grep -q '^closed$' "$WORK/prog.out"; then
    t_fail no_closed_on_local_close "closed fired for a local close(): $(cat "$WORK/prog.out")"
else
    t_pass no_closed_on_local_close
fi

# The splice actually happened: tcp.cla's own globals reached the C.
if grep -q cv_rtTcpPhase "$WORK/echo_client.c" 2>/dev/null; then
    t_pass spliced
else
    t_fail spliced "emitted C never mentions cv_rtTcpPhase: tcp.cla was not spliced"
fi
t_done
