#!/bin/sh
# tests/atalk/find.sh (2026-09-06 appletalk spec %4.3, %8.1, Task 8):
# `serviceBrowser.find` end to end against a name `atalkdrive register`
# is holding. Three runs of the same fixture, one per shape the spec
# names: the one-argument form (which supplies the "*" zone at the
# lowering seam), the explicit two-argument form, and a type nobody has
# registered -- which must still fire `done`, since "a search that matches
# nothing is done with no found, not a failure".
#
# The group is shared with whatever else is on this machine, so nothing
# asserts an entity COUNT -- only that our own name is among the hits with
# the address the tool itself printed, and that `done` is the last line.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_atalk.sh" || die "helper lib failed to load"

DRIVE=$TOOLS/atalkdrive
require_tool "$DRIVE"
atalk_skip_unless_multicast

if atalk_build finder; then
    t_pass build
else
    t_fail build "$(tail -20 "$WORK/finder.build")"
    t_done
fi

OBJ=$(atalk_name Svc)
TYPE=ClarusFind

"$DRIVE" register "$OBJ" "$TYPE" 40 > "$WORK/reg.out" 2> "$WORK/reg.err" &
regpid=$!
if atalk_wait_line "$WORK/reg.out" '^registered node=' $regpid; then
    t_pass peer_registered
else
    kill $regpid 2>/dev/null; wait $regpid 2>/dev/null
    t_fail peer_registered "atalkdrive register never announced itself: $(cat "$WORK/reg.err")"
    t_done
fi

# "registered node=N sock=S" -> the address string(addr) must render, on a
# routerless LocalTalk network (net 0): "0.N.S".
node=$(sed -n 's/^registered node=\([0-9]*\) .*/\1/p' "$WORK/reg.out")
sock=$(sed -n 's/^registered node=[0-9]* sock=\([0-9]*\).*/\1/p' "$WORK/reg.out")
WANT="found $OBJ:$TYPE 0.$node.$sock"

check_find() {   # check_find NAME ARGS...
    _name=$1
    shift
    "$TOOLS/timeout" 30 "$WORK/finder" "$@" > "$WORK/$_name.out" 2> "$WORK/$_name.log"
    _rc=$?
    if [ $_rc != 0 ]; then
        t_fail "$_name" "exit $_rc: $(tr '\n' '|' < "$WORK/$_name.log")"
        return
    fi
    if [ "$(grep -c "^found " "$WORK/$_name.log")" -lt 1 ]; then
        t_fail "$_name" "no found line: $(tr '\n' '|' < "$WORK/$_name.log")"
        return
    fi
    if ! grep -qxF "$WANT" "$WORK/$_name.log"; then
        t_fail "$_name" "no [$WANT] line: $(tr '\n' '|' < "$WORK/$_name.log")"
        return
    fi
    if [ "$(tail -1 "$WORK/$_name.log")" != done ]; then
        t_fail "$_name" "done is not the last line: $(tr '\n' '|' < "$WORK/$_name.log")"
        return
    fi
    t_pass "$_name"
}
check_find find_one_arg "$TYPE"
check_find find_two_arg "$TYPE" '*'

# A type nobody registered: `done` with no `found` at all, and no failure.
"$TOOLS/timeout" 30 "$WORK/finder" "NoSuch$TYPE" > "$WORK/none.out" 2> "$WORK/none.log"
rc=$?
kill $regpid 2>/dev/null
wait $regpid 2>/dev/null
if [ $rc = 0 ] && [ "$(cat "$WORK/none.log")" = done ]; then
    t_pass find_no_matches
else
    t_fail find_no_matches "exit $rc, log was: $(tr '\n' '|' < "$WORK/none.log")"
fi
t_done
