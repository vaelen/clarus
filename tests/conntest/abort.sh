#!/bin/sh
# tests/conntest/abort.sh -- port of internal/conntest's TestAbortDuringPump:
# cpEmitMain's host pump loop must test `!clar_aborting`, not just
# rtConnAlive(). echo_abort.cla opens a connection then aborts uncaught in
# the same App.startCLI call; the process must exit 1 PROMPTLY on the abort
# alone, never waiting for the peer.
#
# The peer therefore accepts and then does NOTHING -- never reads, writes or
# closes -- for longer than the deadline we hold the program to (`sleep
# 4000` vs `timeout 2`), so an exit that only happened because this peer
# went away could not pass this test.
. "$(dirname "$0")/../lib.sh"
. "$(dirname "$0")/../lib_conntest.sh"

conn_build echo_abort || { t_fail build "$(cat "$WORK/echo_abort.build")"; t_done; }
t_pass build

echo 'sleep 4000' > "$WORK/peer.script"
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

# timeout 2 IS the promptness assertion: expiry is exit 124, not 1.
CLARUS_SERIAL_MODEM="connect:127.0.0.1:$port" "$TOOLS/timeout" 2 "$WORK/echo_abort" \
    > "$WORK/out" 2> "$WORK/err"
rc=$?
kill "$peer" 2>/dev/null
wait "$peer" 2>/dev/null

[ $rc -eq 1 ] && t_pass prompt_exit1 \
    || t_fail prompt_exit1 "exit $rc, want 1 (124 = still running after 2s, peer-dependent)"
grep -q 'boom' "$WORK/err" && t_pass abort_msg \
    || t_fail abort_msg "stderr missing \"boom\": $(cat "$WORK/err")"
t_done
