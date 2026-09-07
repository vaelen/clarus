#!/bin/sh
# tests/tcp/bigsend.sh (MacTCP phase, final-review fix wave) -- ONE
# conn.send() of 5000 bytes, through the language. Everything else in the
# corpus sends at most 257 bytes, so nothing but this exercises tcp.cla's
# chunk loop: rtTcpKick sends the first rtTcpChunk (4096), rtTcpDropFront
# requeues the 904-byte tail, and the rtTcpEvSent -> rtTcpKick re-kick
# sends it. (rt_tcp_test.c's 5000-byte case drives rt_ext_TcpHSend by
# hand and never touches tcp.cla at all.)
#
# Two independent verdicts on the same blob, because they fail
# differently: the PEER's `expect` byte-compares the outbound direction
# (a drop stalls it into its read deadline, a duplicate diverges at a
# named byte offset), and the PROGRAM re-compares the echo against the
# pattern it generated, logging `big ok` or `big bad N`. The pattern --
# byte i = (i*7 + i/4096) mod 256 -- is non-periodic at 4096 on purpose:
# with a periodic one, a whole-chunk duplicate or drop would echo back
# byte-identical and both verdicts would pass.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_tcp.sh" || die "helper lib failed to load"

require_tool "$TOOLS/tcpdrive"

tcp_build bigsend || { t_fail build "$(cat "$WORK/bigsend.build")"; t_done; }
t_pass build

# Same generator as bigsend.cla's, independently written: hex through
# xxd is the byte-safe route (awk's %c goes via the locale's charset, so
# NUL and high bytes do not survive) -- lib_tcp.sh's tcp_sweep idiom.
awk 'BEGIN{for(i=0;i<5000;i++) printf "%02x", (i*7 + int(i/4096)) % 256}' \
    | xxd -r -p > "$WORK/big"
[ "$(wc -c < "$WORK/big")" -eq 5000 ] || die "pattern is not 5000 bytes"

cat > "$WORK/peer.script" <<PEER
expect $WORK/big
send $WORK/big
await-close 5
PEER

"$TOOLS/tcpdrive" listen 0 "$WORK/peer.script" > "$WORK/peer.out" 2>&1 &
peer=$!
port=$(tcp_wait_port "$WORK/peer.out" "$peer")
if [ -z "$port" ]; then
    kill "$peer" 2>/dev/null
    wait "$peer" 2>/dev/null
    t_fail listen "tcpdrive never reported a bound port: $(cat "$WORK/peer.out")"
    t_done
fi

"$WORK/bigsend" "127.0.0.1:$port" > "$WORK/prog.out" 2>&1 &
prog=$!

wait "$peer"
prc=$?
if [ $prc -eq 0 ]; then
    t_pass outbound
else
    t_fail outbound "peer never saw the 5000 bytes intact: tcpdrive exit $prc: $(cat "$WORK/peer.out")"
fi

tcp_wait_self_exit "$prog" lifetime || echo "prog output: $(cat "$WORK/prog.out")"

if grep -q '^big ok$' "$WORK/prog.out"; then
    t_pass roundtrip
else
    t_fail roundtrip "want 'big ok', got: $(tr '\n' '|' < "$WORK/prog.out")"
fi
t_done
