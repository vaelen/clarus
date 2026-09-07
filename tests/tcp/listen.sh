#!/bin/sh
# tests/tcp/listen.sh (MacTCP phase, Task 6, spec %4.2) -- the host
# end-to-end SERVER case: `l.listen(tcp port)`, `accepted(c)` handing over
# an already-open connection with no `opened`, a byte-exact echo, and the
# peer's own close driving `closed` + `stop()` + self-exit.
#
# pick-port's probe-close-then-bind gap is a real race under `make -j`
# (another test can grab the port between the pick and the bind), so the
# whole pick + spawn + dial sequence is retried up to 5 times on a DIAL
# failure (tcpdrive exit 2). A divergence (exit 1) is never retried -- it
# is a real red, and retrying would only hide it. Copied from
# tests/conntest/listen.sh, which has the identical race.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_tcp.sh" || die "helper lib failed to load"

require_tool "$TOOLS/tcpdrive"

tcp_build echo_server || { t_fail build "$(cat "$WORK/echo_server.build")"; t_done; }
t_pass build

tcp_sweep "$WORK/sweep"
printf 'QQQ' > "$WORK/qqq"

cat > "$WORK/client.script" <<PEER
expect-sub "READY\r" 64
send $WORK/sweep
expect $WORK/sweep
send $WORK/qqq
expect $WORK/qqq
close
await-close 5
PEER

attempt=0
rc=2
prog=
while [ $attempt -lt 5 ]; do
    attempt=$((attempt + 1))
    port=$("$TOOLS/tcpdrive" pick-port) || { t_fail listen "pick-port failed"; t_done; }
    "$WORK/echo_server" "$port" > "$WORK/prog.out" 2>&1 &
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
    t_fail listen "dial 127.0.0.1:$port exhausted retries: $(cat "$WORK/client.out")"
    t_done
fi
if [ $rc -eq 0 ]; then
    t_pass exchange
else
    t_fail exchange "tcpdrive exit $rc: $(cat "$WORK/client.out")"
fi

tcp_wait_self_exit "$prog" lifetime || echo "prog output: $(cat "$WORK/prog.out")"

for want in listening accepted closed; do
    if grep -q "^$want\$" "$WORK/prog.out"; then
        t_pass "log_$want"
    else
        t_fail "log_$want" "no '$want' line: $(tr '\n' '|' < "$WORK/prog.out")"
    fi
done
t_done
