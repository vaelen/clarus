#!/bin/sh
# tests/tcp/deny.sh (MacTCP phase, Task 6, spec %4.2, "slot table full"):
# with all rtConnMax (8) connection slots taken, the runtime aborts the
# next client's connection and re-arms SILENTLY -- the client sees a
# reset, the server sees nothing (no `failed`, no ninth `accepted`).
#
# nine.cla accepts and holds; eight tcpdrive peers each just sleep, and a
# ninth waits to be closed. `await-close 3` succeeds on the reset the deny
# sends, so the ninth peer exiting 0 IS the assertion.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_tcp.sh" || die "helper lib failed to load"

require_tool "$TOOLS/tcpdrive"

tcp_build nine || { t_fail build "$(cat "$WORK/nine.build")"; t_done; }
t_pass build

printf 'sleep 6000\n' > "$WORK/hold.script"
printf 'await-close 3\n' > "$WORK/ninth.script"

port=$("$TOOLS/tcpdrive" pick-port) || { t_fail listen "pick-port failed"; t_done; }
"$WORK/nine" "$port" > "$WORK/prog.out" 2>&1 &
prog=$!

# Eight holders. --retry 5 absorbs both the server's startup and the
# pick-port race; each is dialled and confirmed in turn so the accepts
# cannot interleave with the ninth's.
holders=
i=1
while [ $i -le 8 ]; do
    "$TOOLS/tcpdrive" connect "127.0.0.1:$port" --retry 5 "$WORK/hold.script" \
        > "$WORK/hold$i.out" 2>&1 &
    holders="$holders $!"
    i=$((i + 1))
done

# All eight accepts must land before the ninth dials, or the ninth could
# legitimately take a still-free slot.
i=0
while [ $i -lt 20 ]; do
    [ "$(grep -c '^accepted$' "$WORK/prog.out" 2>/dev/null)" -ge 8 ] && break
    sleep 1
    i=$((i + 1))
done

"$TOOLS/tcpdrive" connect "127.0.0.1:$port" --retry 5 "$WORK/ninth.script" \
    > "$WORK/ninth.out" 2>&1
nrc=$?
if [ $nrc -eq 0 ]; then
    t_pass ninth_reset
else
    t_fail ninth_reset "tcpdrive exit $nrc, want 0 (the deny should have closed it): $(cat "$WORK/ninth.out")"
fi

n=$(grep -c '^accepted$' "$WORK/prog.out" 2>/dev/null)
[ "$n" = 8 ] && t_pass eight_accepted \
    || t_fail eight_accepted "$n 'accepted' lines, want exactly 8: $(tr '\n' '|' < "$WORK/prog.out")"

if grep -q '^lfailed' "$WORK/prog.out"; then
    t_fail no_listener_failed "a denied client made the listener fail: $(tr '\n' '|' < "$WORK/prog.out")"
else
    t_pass no_listener_failed
fi

kill $holders "$prog" 2>/dev/null
wait $holders 2>/dev/null
wait "$prog" 2>/dev/null
t_done
