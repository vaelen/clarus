#!/bin/sh
# tests/atalk/serve.sh (2026-09-06 appletalk spec %4.4, %8.1, Task 8): a
# Clarus `service` program as the SERVER, `atalkdrive` as the client. Two
# real processes on the loopback multicast group -- a program can never
# call its own registered name (the LToUDP stack drops its own datagrams),
# so the peer has to be the tool.
#
# Covers every reply shape the spec names: a fixed payload, a byte-exact
# echo at ATP's 578-byte request ceiling, the runtime's automatic -1 empty
# reply for a handler that returns without replying, a nonzero application
# code, the program's own unknown-op arm, and `stop()` followed by the
# host CLI lifetime rule ending the process on its own.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_atalk.sh" || die "helper lib failed to load"

DRIVE=$TOOLS/atalkdrive
require_tool "$DRIVE"
atalk_skip_unless_multicast

if atalk_build clock; then
    t_pass build
else
    t_fail build "$(tail -20 "$WORK/clock.build")"
    t_done
fi

NAME=$(atalk_name Clock)
TYPE=ClarusClock

"$WORK/clock" "$NAME" > "$WORK/srv.out" 2> "$WORK/srv.err" &
pid=$!

# The name is findable once serve()'s own NBP registration completes
# (~3 s). Poll the tool rather than sleeping a guessed interval.
i=0
seen=0
while [ $i -lt 20 ]; do
    if "$DRIVE" lookup "$TYPE" 2>/dev/null | grep -q "$NAME:$TYPE"; then
        seen=1
        break
    fi
    kill -0 $pid 2>/dev/null || break
    sleep 1
    i=$((i + 1))
done
if [ $seen = 1 ]; then
    t_pass registered
else
    kill $pid 2>/dev/null; wait $pid 2>/dev/null
    t_fail registered "$NAME:$TYPE never appeared in an NBP lookup: $(cat "$WORK/srv.err")"
    t_done
fi

: > "$WORK/empty"

# op 1 -- reply(0, "12:00")
"$DRIVE" call "$NAME" "$TYPE" 1 < "$WORK/empty" > "$WORK/op1.out" 2> "$WORK/op1.err"
rc=$?
if [ $rc = 0 ] && [ "$(cat "$WORK/op1.out")" = "12:00" ]; then
    t_pass op1_fixed_reply
else
    t_fail op1_fixed_reply "exit $rc, reply [$(cat "$WORK/op1.out")] ($(cat "$WORK/op1.err"))"
fi

# op 2 -- byte-exact echo of a 578-byte request (ATP's own ceiling).
atalk_sweep "$WORK/req578" 578
"$DRIVE" call "$NAME" "$TYPE" 2 < "$WORK/req578" > "$WORK/op2.out" 2> "$WORK/op2.err"
rc=$?
if [ $rc != 0 ]; then
    t_fail op2_echo_578 "exit $rc ($(cat "$WORK/op2.err"))"
elif cmp -s "$WORK/req578" "$WORK/op2.out"; then
    t_pass op2_echo_578
else
    t_fail op2_echo_578 "echo differs: $(cmp "$WORK/req578" "$WORK/op2.out" 2>&1 | head -1)"
fi

# op 3 -- handler returns without replying: the runtime's automatic -1.
# op 4 -- an explicit nonzero application code.
# op 9 -- no arm matches: the program's own default replies -1.
check_code() {   # check_code NAME OP WANTCODE
    "$DRIVE" call "$NAME" "$TYPE" "$2" < "$WORK/empty" > /dev/null 2> "$WORK/$1.err"
    _rc=$?
    if [ $_rc = 3 ] && grep -q "^code $3\$" "$WORK/$1.err"; then
        t_pass "$1"
    else
        t_fail "$1" "exit $_rc (want 3), stderr [$(cat "$WORK/$1.err")] (want code $3)"
    fi
}
check_code op3_auto_minus1 3 -1
check_code op4_server_code 4 7
check_code op9_unknown_op 9 -1

# op 5 -- reply, then stop(): nothing is serving, no event is pending, so
# the host CLI pump loop's own condition (rtAtalkAlive) goes false and the
# program exits ON ITS OWN. Never killed to make this pass.
"$DRIVE" call "$NAME" "$TYPE" 5 < "$WORK/empty" > "$WORK/op5.out" 2> "$WORK/op5.err"
rc=$?
if [ $rc = 0 ] && [ "$(cat "$WORK/op5.out")" = "bye" ]; then
    t_pass op5_reply
else
    t_fail op5_reply "exit $rc, reply [$(cat "$WORK/op5.out")] ($(cat "$WORK/op5.err"))"
fi
atalk_wait_exit $pid self_exit

if [ -s "$WORK/srv.err" ]; then
    t_fail no_failed_events "the server logged: $(cat "$WORK/srv.err")"
else
    t_pass no_failed_events
fi
t_done
