#!/bin/sh
# atalkdrive/call -- an ATP transaction between two atalkdrive processes:
# one `serve`s a two-op script, the other `call`s it. Covers the multi-
# packet response path (4096 bytes = 8 ATP packets, the protocol maximum
# per transaction) byte-exactly, a nonzero response code, and a call to a
# name nobody registered.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_atalk.sh" || die "helper lib failed to load"
atalk_lock   # one LToUDP script on the group at a time

DRIVE=$TOOLS/atalkdrive
require_tool "$DRIVE"

OBJ=Serve-$$
TYPE=ClarusServe$$

# reply.bin: a 0..255 byte sweep repeated 16 times = 4096 bytes, i.e. the
# ATP maximum of 8 packets x 578 rounded down to something readable in a
# hex dump. Built with printf's octal escapes because POSIX sh cannot hold
# a NUL in a variable and awk's printf "%c" would emit UTF-8 above 127.
i=0
while [ $i -lt 256 ]; do
    printf "\\$(printf '%03o' $i)"
    i=$((i + 1))
done > "$WORK/sweep"
r=0
while [ $r -lt 16 ]; do cat "$WORK/sweep"; r=$((r + 1)); done > "$WORK/reply.bin"
[ "$(wc -c < "$WORK/reply.bin" | tr -d ' ')" = 4096 ] || die "reply.bin is not 4096 bytes"

printf '1 0 %s\n2 5 -\n' "$WORK/reply.bin" > "$WORK/script"

"$DRIVE" serve "$OBJ" "$TYPE" 25 "$WORK/script" > "$WORK/srv.out" 2> "$WORK/srv.err" &
srvpid=$!

i=0
while [ $i -lt 20 ]; do
    grep -q '^serving node=' "$WORK/srv.out" 2>/dev/null && break
    if ! kill -0 $srvpid 2>/dev/null; then break; fi
    sleep 1
    i=$((i + 1))
done

if grep -q '^SKIP: multicast unavailable' "$WORK/srv.err" 2>/dev/null; then
    wait $srvpid 2>/dev/null
    skip "multicast unavailable"
fi
if ! grep -q '^serving node=' "$WORK/srv.out"; then
    kill $srvpid 2>/dev/null; wait $srvpid 2>/dev/null
    cat "$WORK/srv.err"
    t_fail serve "atalkdrive serve never announced itself"
    t_done
fi
t_pass serve

# op 1: code 0, the 4096-byte sweep, byte-exact.
: > "$WORK/req.bin"
"$DRIVE" call "$OBJ" "$TYPE" 1 < "$WORK/req.bin" > "$WORK/got.bin" 2> "$WORK/call1.err"
rc=$?
if [ "$rc" != 0 ]; then
    cat "$WORK/call1.err"
    t_fail call_ok "exit $rc, expected 0"
elif cmp -s "$WORK/got.bin" "$WORK/reply.bin"; then
    t_pass call_ok
else
    cmp "$WORK/got.bin" "$WORK/reply.bin" 2>&1 | head -1
    t_fail call_ok "reply differs from reply.bin"
fi

# op 2: code 5, empty reply -> exit 3.
"$DRIVE" call "$OBJ" "$TYPE" 2 < "$WORK/req.bin" > "$WORK/got2.bin" 2> "$WORK/call2.err"
rc=$?
if [ "$rc" = 3 ] && grep -q '^code 5$' "$WORK/call2.err"; then
    t_pass call_code
else
    cat "$WORK/call2.err"
    t_fail call_code "exit $rc (expected 3) / code line missing"
fi

kill $srvpid 2>/dev/null
wait $srvpid 2>/dev/null

# A name nobody registered: the NBP lookup finds nothing and the tool must
# give up (exit 1) well inside 8 s -- its lookup window is 3 s.
start=$(date +%s)
"$DRIVE" call "Nobody-$$" "$TYPE" 1 < "$WORK/req.bin" > /dev/null 2> "$WORK/call3.err"
rc=$?
elapsed=$(( $(date +%s) - start ))
if [ "$rc" = 1 ] && [ "$elapsed" -lt 8 ]; then
    t_pass call_missing
else
    cat "$WORK/call3.err"
    t_fail call_missing "exit $rc after ${elapsed}s (expected 1 within 8s)"
fi
t_done
