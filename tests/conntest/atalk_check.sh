#!/bin/sh
# tests/conntest/atalk_check.sh (AppleTalk phase, Task 3): the front-end
# surface -- `service` and its methods/events, serviceBrowser.zones/done/
# find(type, zone), listener.stop, connection.open(appletalk ...)/open(addr),
# string(addr) -- must CHECK clean. Check-only on purpose: lowering every
# one of those shapes is still fenced this task (lowUnsupported), so
# `clarusc emit` on this fixture is expected to fail and the errors group's
# own scripts cover the diagnostics.
. "$(dirname "$0")/../lib.sh" || exit 2

out=$("$CLARUSC" "$ROOT/testdata/valid/atalk_ok.cla" 2>&1)
rc=$?
if [ $rc -ne 0 ] || [ -n "$(printf '%s' "$out" | tr -d '[:space:]')" ]; then
    t_fail check "clarusc check not clean (exit $rc): $out"
else
    t_pass check
fi
t_done
