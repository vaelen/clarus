#!/bin/sh
# tests/atalk/runerr.sh (2026-09-06 appletalk spec %4.5, %8.1, Task 8):
# the error-principle fences. Contract violations -- `reply` outside a
# request handler, `reply` twice in one handler, `send` on a connection
# whose (asynchronous) open has not completed -- are RUNTIME ERRORS, and
# a resource-variable count past its cap is a BUILD error naming the cap.
# Everything environmental stays a `failed` event, which the other four
# scripts in this group cover.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_atalk.sh" || die "helper lib failed to load"

DRIVE=$TOOLS/atalkdrive
require_tool "$DRIVE"
atalk_skip_unless_multicast

# --- 1. runtime errors that need no peer -----------------------------
check_panic() {   # check_panic NAME TEXT
    if ! atalk_build "$1"; then
        t_fail "$1" "build failed: $(tail -20 "$WORK/$1.build")"
        return
    fi
    "$TOOLS/timeout" 10 "$WORK/$1" > "$WORK/$1.out" 2> "$WORK/$1.err"
    _rc=$?
    if [ $_rc = 0 ]; then
        t_fail "$1" "exited 0; expected a runtime error"
    elif grep -q "runtime error: $2" "$WORK/$1.err"; then
        t_pass "$1"
    else
        t_fail "$1" "exit $_rc, stderr [$(tr '\n' '|' < "$WORK/$1.err")], want [runtime error: $2]"
    fi
}
check_panic reply_outside 'reply outside a request handler'
# `open(appletalk ...)` is asynchronous like every other open, so the very
# next line's `send` runs on a connection that is not open (and, on the
# host lane this phase, never will be -- spec %4.6).
check_panic send_unopened_adsp 'connection not open'

# --- 2. reply twice: needs a real request to reach the handler --------
if atalk_build reply_twice; then
    t_pass reply_twice_build
else
    t_fail reply_twice_build "$(tail -20 "$WORK/reply_twice.build")"
    t_done
fi

NAME=$(atalk_name Twice)
TYPE=ClarusTwice
"$WORK/reply_twice" "$NAME" > "$WORK/twice.out" 2> "$WORK/twice.err" &
pid=$!
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
if [ $seen != 1 ]; then
    kill $pid 2>/dev/null; wait $pid 2>/dev/null
    t_fail reply_twice "$NAME:$TYPE never appeared in an NBP lookup: $(cat "$WORK/twice.err")"
    t_done
fi

: > "$WORK/empty"
"$DRIVE" call "$NAME" "$TYPE" 1 < "$WORK/empty" > /dev/null 2>&1
# The program dies inside the handler, on the second reply.
i=0
while [ $i -lt 10 ] && kill -0 $pid 2>/dev/null; do
    sleep 1
    i=$((i + 1))
done
if kill -0 $pid 2>/dev/null; then
    kill $pid 2>/dev/null; wait $pid 2>/dev/null
    t_fail reply_twice "still running after the second reply; expected a runtime error"
else
    wait $pid
    rc=$?
    if [ $rc != 0 ] && grep -q 'runtime error: reply already sent' "$WORK/twice.err"; then
        t_pass reply_twice
    else
        t_fail reply_twice "exit $rc, stderr [$(tr '\n' '|' < "$WORK/twice.err")]"
    fi
fi

# --- 3. the three caps, at BUILD time --------------------------------
check_cap() {   # check_cap NAME DIAGNOSTIC
    if "$CLARUSC" emit --rtdir "$RTDIR" -o "$WORK/$1.c" \
            "$ROOT/tests/atalk/testdata/$1.cla" > "$WORK/$1.emit" 2>&1; then
        t_fail "$1" "clarusc emit succeeded; expected [$2]"
    elif grep -q "$2" "$WORK/$1.emit"; then
        t_pass "$1"
    else
        t_fail "$1" "emit failed without [$2]: $(tr '\n' '|' < "$WORK/$1.emit")"
    fi
}
check_cap too_many_lsn 'too many listener variables (max 2)'
check_cap too_many_brs 'too many serviceBrowser variables (max 2)'
check_cap too_many_svc 'too many service variables (max 2)'
t_done
