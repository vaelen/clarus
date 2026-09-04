#!/bin/sh
. "$(dirname "$0")/../lib.sh"
"$TOOLS/timeout" 1 sleep 5; rc=$?
[ $rc -eq 124 ] && t_pass expiry || t_fail expiry "exit $rc, want 124"
"$TOOLS/timeout" 5 sh -c 'exit 7'; rc=$?
[ $rc -eq 7 ] && t_pass propagate || t_fail propagate "exit $rc, want 7"
"$TOOLS/timeout" 1 sh -c 'sleep 30 & wait' ; rc=$?
sleep 1
pgrep -f 'sleep 30' >/dev/null && t_fail group "grandchild survived" || t_pass group
ms=$("$TOOLS/timeout" --elapsed 5 sleep 0 2>&1 | sed -n 's/^elapsed_ms=//p')
[ -n "$ms" ] && t_pass elapsed || t_fail elapsed "no elapsed_ms line"
t_done
