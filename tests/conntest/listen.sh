#!/bin/sh
# tests/conntest/listen.sh -- port of internal/conntest's TestListenMode:
# the listen: transport path (bind, deferred accept, byte-exact echo, the
# same close-driven lifetime rule) using the SAME echo.cla fixture
# connect.sh does, only CLARUS_SERIAL_MODEM=listen:PORT.
#
# Two things this has to cope with, both copied from the Go test:
#
#  1. pick-port's probe-close-then-bind gap is a real race under a parallel
#     run (another test can grab the very port we picked), so the whole
#     pick-port + spawn + dial sequence is retried up to 5 times on a DIAL
#     failure (tcpdrive exit 2). A divergence (exit 1) is never retried --
#     it is a real red, and retrying would only hide it.
#  2. echo.cla's `on conn.opened { conn.send("READY\n") }` greeting may or
#     may not survive: rt_ext_ConnHWrite DISCARDS a write to a
#     still-listening slot (an unattached serial line sends bytes nowhere),
#     so the greeting only reaches us if a peer happened to be accepted
#     already when `opened` fired. Rather than a fixed sleep to force one
#     outcome (a flake surface either way), the script re-synchronises
#     data-driven: it first sends a one-byte probe ("!", a byte that appears
#     neither in "READY\r" nor in the QQQ terminator) and consumes through
#     the probe's own echo with `expect-sub`, whose leading bytes are
#     discarded. The greeting, if it ever arrives at all, is strictly
#     earlier than that echo (rtConnPump drains `opened` before `received`,
#     and the probe cannot be received before the accept), so after this
#     step the stream is byte-aligned either way and the sweep comparison
#     below stays exact. The window is capped at 8 bytes, not left wide:
#     the only legitimate shapes are 1 byte (no greeting) and 7 bytes
#     (greeting + echo), so this tolerates no more arbitrary leading
#     garbage than Go's own two-byte-exact-shapes peek did.
. "$(dirname "$0")/../lib.sh"
. "$(dirname "$0")/../lib_conntest.sh"

conn_build echo || { t_fail build "$(cat "$WORK/echo.build")"; t_done; }
t_pass build

conn_sweep "$WORK/sweep"
printf '!' > "$WORK/probe"
printf 'QQQ' > "$WORK/qqq"

cat > "$WORK/client.script" <<EOF
send $WORK/probe
expect-sub "!" 8
send $WORK/sweep
expect $WORK/sweep
send $WORK/qqq
expect $WORK/qqq
await-close 5
EOF

attempt=0
rc=2
prog=
while [ $attempt -lt 5 ]; do
    attempt=$((attempt + 1))
    port=$("$TOOLS/tcpdrive" pick-port) || { t_fail listen "pick-port failed"; t_done; }
    CLARUS_SERIAL_MODEM="listen:$port" "$WORK/echo" > "$WORK/prog.out" 2>&1 &
    prog=$!
    "$TOOLS/tcpdrive" connect "127.0.0.1:$port" --retry 5 "$WORK/client.script" \
        > "$WORK/client.out" 2>&1
    rc=$?
    [ $rc -eq 2 ] || break      # 0 = exchange OK, 1 = real divergence
    kill "$prog" 2>/dev/null
    wait "$prog" 2>/dev/null
    prog=
done

if [ $rc -eq 2 ]; then
    t_fail listen "dial listen:$port exhausted retries: $(cat "$WORK/client.out")"
    t_done
fi
if [ $rc -eq 0 ]; then
    t_pass exchange
else
    t_fail exchange "tcpdrive exit $rc: $(cat "$WORK/client.out")"
fi

conn_wait_self_exit "$prog" lifetime || echo "prog output: $(cat "$WORK/prog.out")"
t_done
