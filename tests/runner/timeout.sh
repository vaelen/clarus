#!/bin/sh
. "$(dirname "$0")/../lib.sh" || exit 2
"$TOOLS/timeout" 1 sleep 5; rc=$?
[ $rc -eq 124 ] && t_pass expiry || t_fail expiry "exit $rc, want 124"
"$TOOLS/timeout" 5 sh -c 'exit 7'; rc=$?
[ $rc -eq 7 ] && t_pass propagate || t_fail propagate "exit $rc, want 7"

# The grandchild reports its own pid into $WORK so we can check it with
# kill -0 instead of `pgrep -f 'sleep N'`, which matches any process on the
# box with that string -- a false FAIL when a sibling worktree runs this
# same self-check concurrently (they would all share the pattern).
alive() { [ -s "$1" ] && kill -0 "$(cat "$1")" 2>/dev/null; }
gc='sleep 31337 & echo $! > "$1"; wait'

# the deadline must kill the whole group, grandchild included
"$TOOLS/timeout" 1 sh -c "$gc" sh "$WORK/group.pid"
sleep 1
alive "$WORK/group.pid" && t_fail group "grandchild survived" || t_pass group

# a signal at the parent must reach the child group too, not orphan it
"$TOOLS/timeout" 60 sh -c "$gc" sh "$WORK/fwd.pid" &
tpid=$!
sleep 1
kill -TERM $tpid 2>/dev/null
wait $tpid 2>/dev/null
sleep 1
alive "$WORK/fwd.pid" && t_fail forward "child survived parent SIGTERM" || t_pass forward

# a non-numeric or zero deadline is rejected, never silently alarm(0)
"$TOOLS/timeout" bogus true 2>/dev/null; rc=$?
[ $rc -eq 2 ] && t_pass badsecs || t_fail badsecs "exit $rc, want 2"
"$TOOLS/timeout" 0 true 2>/dev/null; rc=$?
[ $rc -eq 2 ] && t_pass zerosecs || t_fail zerosecs "exit $rc, want 2"

ms=$("$TOOLS/timeout" --elapsed 5 sleep 0 2>&1 | sed -n 's/^elapsed_ms=//p')
[ -n "$ms" ] && t_pass elapsed || t_fail elapsed "no elapsed_ms line"
t_done
