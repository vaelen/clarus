#!/bin/sh
# timeout: 20m
# mactest/atalk_68k (2026-09-06 appletalk spec %8.2, Task 10): ONE native
# Mini vMac boot of examples/atalkclock.cla with `atalkdrive` on the host
# as the peer -- NBP and ATP both ways between a real ROM AppleTalk stack
# and runtime/host's LocalTalk-over-UDP one.
#
#   host -> Mac : the tool looks the app's own NBP name up, then calls it
#                 twice -- op 2 echoes a 578-byte sweep back byte-exact
#                 (ATP's own request ceiling), op 1 answers with the Mac's
#                 clock.
#   Mac -> host : the app browses for ClarusClock, finds the tool's
#                 "Host-...:ClarusClock" name and calls IT, logging the
#                 reply -- the reply path (PSendResponse on the tool side,
#                 the ROM's ATP request side on the Mac's) that
#                 atalk_selfserve.sh, having no peer, could not reach.
#
# run_mac BLOCKS until the app quits and only hands back the capture
# afterwards, so the host half runs in a background subshell started
# BEFORE the boot; it polls `atalkdrive lookup` for the app's name and
# writes its own verdicts to $WORK/host.out, which this script asserts on
# once run_mac returns.
#
# The app is driven by testdata/atalk/clockdrive.cla (an `every 60 ticks`
# state machine composed onto the example), not by a --events script: see
# that fixture's header -- scripted mode never waits in real time, and
# every round trip here needs real seconds.
#
# .XPP/.DSP are absent from LaunchAPPL's stripped boot disk, so every
# ASSERTION here is NBP + ATP only: no listener, no ADSP, and nothing
# checks the zone list. The example does call `browser.zones()` for its
# own window label, which is safe on this disk -- with no .XPP (and no
# router) it degrades to the single zone ["*"], the same noBridgeErr path
# atalk_selfserve.sh pins as `zones 1 *`.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_mac.sh" || die "helper lib failed to load"
. "$(dirname "$0")/../lib_atalk.sh" || die "helper lib failed to load"
require_env CLARUS_MAC_TESTS

DRIVE=$TOOLS/atalkdrive
require_tool "$DRIVE"
atalk_skip_unless_multicast

TYPE=ClarusClock
HOSTOBJ=$(atalk_name Host)

srvpid=
hostpid=
# Only OUR OWN two host processes are ever killed here: a blanket
# `pkill -f minivmac` would take down a concurrent two-boot test's
# emulators as well. This trap REPLACES lib.sh's own
# `trap 'rm -rf "$WORK"' EXIT`, so it has to sweep $WORK too -- a boot
# leaves the LaunchAPPL disk build, the capture and the .bin in there.
cleanup() {
    [ -n "$hostpid" ] && kill "$hostpid" 2>/dev/null
    [ -n "$srvpid" ] && kill "$srvpid" 2>/dev/null
    rm -rf "$WORK"
    return 0
}
trap cleanup EXIT INT TERM

# ---- the host peer the Mac calls back ----
printf 'HOSTTIME' > "$WORK/hosttime"
printf '1 0 %s\n' "$WORK/hosttime" > "$WORK/script"
"$DRIVE" serve "$HOSTOBJ" "$TYPE" 300 "$WORK/script" > "$WORK/srv.out" 2> "$WORK/srv.err" &
srvpid=$!
if atalk_wait_line "$WORK/srv.out" '^serving node=' $srvpid; then
    t_pass peer_serving
else
    t_fail peer_serving "atalkdrive serve never announced itself: $(cat "$WORK/srv.err")"
    t_done
fi
HOSTNODE=$(sed -n 's/^serving node=\([0-9]*\).*/\1/p' "$WORK/srv.out")

emit68k -o "$WORK/atalkclock.bin" examples/atalkclock.cla testdata/atalk/clockdrive.cla \
    > "$WORK/emit.log" 2>&1 \
    || die "clarusc emit68k atalkclock: $(tail -10 "$WORK/emit.log")"

# ---- the host half, running while the boot blocks ----
#
# The app's own name is "Clock-<digits>" (examples/atalkclock.cla derives
# the suffix from now()); tests/atalk/serve.sh's host-side fixture
# registers "Clock-T<pid>" under the SAME type on the same multicast
# group, so the match is anchored on the all-digits suffix AND on a node
# that is not this script's own peer. Foreign entities are otherwise
# tolerated (spec %8.4).
# at_call OP IN OUT ERR : `atalkdrive call $_obj $TYPE OP`, retried up to
# three times when the tool's OWN NBP lookup of the name comes back empty.
# The name is known to exist -- the discovery loop below just saw it, and
# the same_entity subcase proves it is this boot's app -- so a "not found"
# here is a lost lookup on a shared, lossy multicast group (Andrew's live
# sessions and any concurrent emulator boot share it), not a verdict. A
# real failure (no answer, a nonzero code) is returned on the first try.
at_call() {
    _i=0
    while : ; do
        "$DRIVE" call "$_obj" "$TYPE" "$1" < "$2" > "$3" 2> "$4"
        _rc=$?
        grep -q '^not found: ' "$4" || return $_rc
        _i=$(( _i + 1 ))
        [ $_i -ge 3 ] && return $_rc
        sleep 2
    done
}

atalk_host_half() {
    _t0=$(date +%s)
    _end=$(( _t0 + 170 ))
    _ent=
    _node=
    while [ "$(date +%s)" -lt "$_end" ]; do
        "$DRIVE" lookup "$TYPE" > "$WORK/lk.out" 2> "$WORK/lk.err"
        _hit=$(awk -v hn="$HOSTNODE" '
            { split($1, a, "."); e = $2; sub(/@.*/, "", e)
              if (a[2] != hn && e ~ /^Clock-[0-9]+:ClarusClock$/) { print a[2], e; exit } }
            ' "$WORK/lk.out")
        if [ -n "$_hit" ]; then
            _node=${_hit%% *}
            _ent=${_hit#* }
            break
        fi
        sleep 2
    done
    _took=$(( $(date +%s) - _t0 ))
    if [ -z "$_ent" ]; then
        echo "discover FAIL no Clock-<digits>:$TYPE at a foreign node in ${_took}s; last lookup: $(tr '\n' '|' < "$WORK/lk.out")"
        return 0
    fi
    if [ "$_node" = 0 ]; then
        echo "discover FAIL $_ent answered at node 0"
        return 0
    fi
    echo "discover OK $_ent node=$_node (${_took}s)"
    _obj=${_ent%%:*}

    # op 2 -- byte-exact echo of a 578-byte request (ATP's own ceiling),
    # answered by the ROM's ATP responder through the runtime's waist.
    at_call 2 "$WORK/req578" "$WORK/echo.out" "$WORK/echo.err"
    _rc=$?
    if [ $_rc != 0 ]; then
        echo "echo578 FAIL exit $_rc ($(tr '\n' '|' < "$WORK/echo.err"))"
    elif cmp -s "$WORK/req578" "$WORK/echo.out"; then
        echo "echo578 OK"
    else
        echo "echo578 FAIL $(cmp "$WORK/req578" "$WORK/echo.out" 2>&1 | head -1)"
    fi

    # op 1 -- the Mac's own clock, as dateTimeStr formats it.
    at_call 1 /dev/null "$WORK/time.out" "$WORK/time.err"
    _rc=$?
    _n=$(wc -c < "$WORK/time.out" | tr -d ' ')
    if [ $_rc = 0 ] && [ "$_n" -gt 0 ]; then
        echo "time OK $_n [$(cat "$WORK/time.out")]"
    else
        echo "time FAIL exit $_rc, $_n bytes ($(tr '\n' '|' < "$WORK/time.err"))"
    fi
}

atalk_sweep "$WORK/req578" 578
atalk_host_half > "$WORK/host.out" 2>&1 &
hostpid=$!

# The app quits itself ~200 s in (clockdrive.cla); the budget is deliberately
# far past that, because run_mac's OWN expiry path pkills every minivmac on
# the machine -- which would take a concurrent two-boot test down with it.
run_mac "$WORK/atalkclock.bin" 420

wait $hostpid 2>/dev/null
hostpid=
kill $srvpid 2>/dev/null
wait $srvpid 2>/dev/null
srvpid=

LOG=$WORK/cap.log

[ "$MAC_EXIT" = 0 ] && t_pass exit || t_fail exit "exit $MAC_EXIT, want 0"

# ---- host -> Mac ----
check_host() {   # check_host NAME PREFIX
    if grep -q "^$2 OK" "$WORK/host.out"; then
        t_pass "$1"
    else
        t_fail "$1" "$(grep "^$2 " "$WORK/host.out" || echo "no $2 line: $(tr '\n' '|' < "$WORK/host.out")")"
    fi
}
check_host discover discover
check_host echo_578 echo578
check_host reply_time time

# ---- the app's own log ----
want_line() {   # want_line NAME TEXT
    if grep -qF "$2" "$LOG"; then
        t_pass "$1"
    else
        t_fail "$1" "log has no \"$2\": $(tr '\n' '|' < "$LOG")"
    fi
}

# serve() completed: the name the host just looked up is the app's own.
want_line serving "serving Clock-"
# Mac -> host: the browse saw the tool's name and the sync call got its
# reply back through the ROM's ATP requester.
want_line remote_call "remote $HOSTOBJ:$TYPE HOSTTIME"
# clockdrive.cla's own last line -- the app ended on its own, not on a
# watchdog or an alert. ANCHORED (`grep -x`): the example logs
# `browse done N` seconds after launch, which a substring match would
# have accepted forever.
if grep -qx "done" "$LOG"; then
    t_pass done_line
else
    t_fail done_line "no bare \"done\" line: $(tr '\n' '|' < "$LOG")"
fi

# The group is shared (spec %8.4): Andrew's live sessions can hold a
# Clock-<digits> name of their own, and every host-side check above would
# be satisfied by one of those with this boot's app never touched. The
# entity the host discovered has to be the one the app says it is
# serving.
HOSTENT=$(sed -n 's/^discover OK \([^ ]*\) .*/\1/p' "$WORK/host.out")
if [ -z "$HOSTENT" ]; then
    t_fail same_entity "the host half discovered nothing: $(tr '\n' '|' < "$WORK/host.out")"
elif grep -qx "serving $HOSTENT" "$LOG"; then
    t_pass same_entity
else
    t_fail same_entity "host called $HOSTENT, app logged $(grep '^serving ' "$LOG" || echo 'nothing')"
fi

if grep -q '^clock failed \|^browse failed ' "$LOG"; then
    t_fail no_failures "$(grep '^clock failed \|^browse failed ' "$LOG")"
else
    t_pass no_failures
fi

t_done
