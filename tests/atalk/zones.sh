#!/bin/sh
# tests/atalk/zones.sh (2026-09-06 appletalk spec %4.3, %8.1, Task 8):
# `serviceBrowser.zones(out)` is SYNCHRONOUS -- it returns with `out`
# already filled, no event and no pump pass. A network with no router has
# no zone list to fetch, and the spec's answer is the one-element list
# ["*"], so a program never special-cases the routerless case. Every host
# lane run is routerless, so "zones 1 *" is the whole contract here.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_atalk.sh" || die "helper lib failed to load"

require_tool "$TOOLS/atalkdrive"
atalk_skip_unless_multicast

if atalk_build zones; then
    t_pass build
else
    t_fail build "$(tail -20 "$WORK/zones.build")"
    t_done
fi

"$TOOLS/timeout" 30 "$WORK/zones" > "$WORK/out" 2> "$WORK/log"
rc=$?
if [ $rc != 0 ]; then
    t_fail zones "exit $rc: $(tr '\n' '|' < "$WORK/log")"
elif [ "$(cat "$WORK/log")" = 'zones 1 *' ]; then
    t_pass zones
else
    t_fail zones "log was [$(tr '\n' '|' < "$WORK/log")], want [zones 1 *]"
fi
t_done
