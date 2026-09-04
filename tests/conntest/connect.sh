#!/bin/sh
# tests/conntest/connect.sh -- port of internal/conntest's TestConnectMode:
# the design spec's "Host end-to-end echo" case (§5). echo.cla dials this
# script's tcpdrive peer (CLARUS_SERIAL_MODEM=connect:...), greets with
# "READY\r" (a Clarus "\n" literal is CR on the wire on BOTH lanes), echoes
# a 0-255 sweep byte-exactly, echoes a SECOND write too (proving `received`
# fires more than once), then closes itself on "QQQ" -- after which the
# process must exit on its own, unkilled (the lifetime rule).
. "$(dirname "$0")/../lib.sh"
. "$(dirname "$0")/../lib_conntest.sh"

conn_build echo || { t_fail build "$(cat "$WORK/echo.build")"; t_done; }
t_pass build

conn_sweep "$WORK/sweep"
printf 'a second write, after the sweep' > "$WORK/second"
printf 'QQQ' > "$WORK/qqq"

# The peer script. `expect-sub "READY\r" 64` rather than a bare 6-byte
# `expect`: leading garbage before the greeting is tolerated (Task 14's
# Snow bridge emits a noise byte). The second exchange sends a DIFFERENT
# payload from the sweep on purpose -- a duplicated first echo could
# otherwise masquerade as a second `received` firing.
cat > "$WORK/peer.script" <<EOF
expect-sub "READY\r" 64
send $WORK/sweep
expect $WORK/sweep
send $WORK/second
expect $WORK/second
send $WORK/qqq
expect $WORK/qqq
await-close 5
EOF

# `listen 0` binds an ephemeral port and prints it, so there is no
# pick-port-then-bind window another process can steal (the flake
# TestListenMode's own retry loop exists for).
"$TOOLS/tcpdrive" listen 0 "$WORK/peer.script" > "$WORK/peer.out" 2>&1 &
peer=$!
port=
i=0
while [ $i -lt 10 ]; do
    port=$(sed -n "s/^port //p" "$WORK/peer.out" 2>/dev/null)
    [ -n "$port" ] && break
    sleep 1
    i=$((i + 1))
done
if [ -z "$port" ]; then
    kill "$peer" 2>/dev/null
    wait "$peer" 2>/dev/null
    t_fail listen "tcpdrive never reported a bound port: $(cat "$WORK/peer.out")"
    t_done
fi

CLARUS_SERIAL_MODEM="connect:127.0.0.1:$port" "$WORK/echo" > "$WORK/prog.out" 2>&1 &
prog=$!

wait "$peer"
prc=$?
if [ $prc -eq 0 ]; then
    t_pass exchange
else
    t_fail exchange "tcpdrive exit $prc: $(cat "$WORK/peer.out")"
fi

conn_wait_self_exit "$prog" lifetime || echo "prog output: $(cat "$WORK/prog.out")"
t_done
