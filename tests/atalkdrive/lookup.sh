#!/bin/sh
# atalkdrive/lookup -- two atalkdrive processes as two AppleTalk peers on
# the loopback multicast group: one registers a name for 8 s, the other
# NBP-looks the type up and must see it. Proves register + LkUp answering
# + lookup collection end to end through the real wire, which the in-
# process unit test (hostrt/atalk) cannot: these are separate processes.
#
# The group is shared with whatever else is on this machine (Andrew's live
# emulator sessions, an EtherTalk bridge), so the name carries this
# script's pid and nothing asserts an entity count.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_atalk.sh" || die "helper lib failed to load"
atalk_lock   # one LToUDP script on the group at a time

DRIVE=$TOOLS/atalkdrive
require_tool "$DRIVE"

OBJ=Drive-$$
TYPE=ClarusDrive$$

"$DRIVE" register "$OBJ" "$TYPE" 8 > "$WORK/reg.out" 2> "$WORK/reg.err" &
regpid=$!

# The registrar's own verify-lookup runs before it prints; wait for the
# line rather than a fixed sleep. (sleep 1, not a fractional sleep: POSIX
# only defines integer seconds.)
i=0
while [ $i -lt 20 ]; do
    grep -q '^registered node=' "$WORK/reg.out" 2>/dev/null && break
    if ! kill -0 $regpid 2>/dev/null; then break; fi
    sleep 1
    i=$((i + 1))
done

if grep -q '^SKIP: multicast unavailable' "$WORK/reg.err" 2>/dev/null; then
    wait $regpid 2>/dev/null
    skip "multicast unavailable"
fi
if ! grep -q '^registered node=' "$WORK/reg.out"; then
    kill $regpid 2>/dev/null
    wait $regpid 2>/dev/null
    cat "$WORK/reg.err"
    t_fail register "atalkdrive register never announced itself"
    t_done
fi
t_pass register

"$DRIVE" lookup "$TYPE" > "$WORK/look.out" 2> "$WORK/look.err"
rc=$?
kill $regpid 2>/dev/null
wait $regpid 2>/dev/null

if [ "$rc" != 0 ]; then
    cat "$WORK/look.err"
    t_fail lookup "atalkdrive lookup exited $rc"
elif grep -q "[0-9]\.[0-9]* $OBJ:$TYPE@" "$WORK/look.out"; then
    t_pass lookup
else
    echo "--- lookup output ---"; cat "$WORK/look.out"
    t_fail lookup "registered name $OBJ:$TYPE not in the lookup results"
fi
t_done
