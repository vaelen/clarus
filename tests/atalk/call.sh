#!/bin/sh
# tests/atalk/call.sh (2026-09-06 appletalk spec %4.4, %8.1, Task 8): the
# mirror of serve.sh -- a Clarus `service.call` program as the CLIENT,
# `atalkdrive serve` as the server. Pins all four documented outcomes of
# `call`: true with a 4000-byte multi-packet reply, false with lastError
# { 5, "service" } for a nonzero server code, false with nbpNoConfirm
# (-1025) for a name that resolves to nothing, and false with atpLenErr
# (-3106) for a request over ATP's 578-byte ceiling.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_atalk.sh" || die "helper lib failed to load"
atalk_lock   # one LToUDP script on the group at a time

DRIVE=$TOOLS/atalkdrive
require_tool "$DRIVE"
atalk_skip_unless_multicast

if atalk_build caller; then
    t_pass build
else
    t_fail build "$(tail -20 "$WORK/caller.build")"
    t_done
fi

OBJ=$(atalk_name Echo)
TYPE=ClarusEcho

# 4000 bytes = 7 ATP packets, well past the single-packet case.
atalk_sweep "$WORK/reply.bin" 4000
printf '1 0 %s\n2 5 -\n' "$WORK/reply.bin" > "$WORK/script"

"$DRIVE" serve "$OBJ" "$TYPE" 40 "$WORK/script" > "$WORK/srv.out" 2> "$WORK/srv.err" &
srvpid=$!
if atalk_wait_line "$WORK/srv.out" '^serving node=' $srvpid; then
    t_pass peer_serving
else
    kill $srvpid 2>/dev/null; wait $srvpid 2>/dev/null
    t_fail peer_serving "atalkdrive serve never announced itself: $(cat "$WORK/srv.err")"
    t_done
fi

start=$(date +%s)
"$TOOLS/timeout" 60 "$WORK/caller" "$OBJ:$TYPE" "Nobody-T$$:$TYPE" > "$WORK/out" 2> "$WORK/log"
rc=$?
elapsed=$(( $(date +%s) - start ))
kill $srvpid 2>/dev/null
wait $srvpid 2>/dev/null

if [ $rc = 0 ]; then
    t_pass caller_exit
else
    t_fail caller_exit "exit $rc: $(cat "$WORK/log")"
fi

check_line() {   # check_line NAME LINE
    if grep -qxF "$2" "$WORK/log"; then
        t_pass "$1"
    else
        t_fail "$1" "no [$2] line; log was: $(tr '\n' '|' < "$WORK/log")"
    fi
}
check_line call_ok        'ok 4000'
check_line call_code      'err 5 service'
check_line call_no_name   'err -1025 name not found'
check_line call_too_long  'err -3106 request too long'

# Every call has to come back from its own answer or its own lookup
# window, never from a 2 s x 3 request timeout. THREE of the four
# name-form calls cost a fixed ~3 s NBP lookup on the host lane (~9 s
# observed); the over-length one costs nothing at all since Task 9 hoisted
# rtSvcCallName's own length check above the lookup (spec %4.4: rejected
# "before any packet leaves"). A single timed-out transaction would put
# this well past the bound.
if [ "$elapsed" -lt 15 ]; then
    t_pass no_timeouts
else
    t_fail no_timeouts "the four calls took ${elapsed}s (want < 15s)"
fi
t_done
