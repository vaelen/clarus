# tests/lib_atalk.sh -- helpers shared by the three groups that put an
# LToUDP stack on the loopback multicast group: tests/atalk/*.sh,
# tests/atalkdrive/*.sh and tests/hostrt/atalk.sh (sourced right after
# lib.sh). The AppleTalk end-to-end scripts all have the same three
# needs: build a fixture, refuse to run without multicast, and register
# names that cannot collide with another run (or with Andrew's live
# emulator sessions, which share the loopback group -- spec %8.4).

# atalk_build NAME : host-build tests/atalk/testdata/NAME.cla into
# $WORK/NAME with the CURRENT-source clarusc (the committed snapshot
# cannot lower AppleTalk); build output lands in $WORK/NAME.build.
atalk_build() {
    host_build "$WORK/$1" "$ROOT/tests/atalk/testdata/$1.cla" > "$WORK/$1.build" 2>&1
}

# atalk_skip_unless_multicast : SKIP the whole script when the LToUDP
# stack cannot join the loopback multicast group. atalkdrive exits 77 for
# exactly that case (and only that case), so its own verdict is the probe
# -- no second copy of the "is multicast up" rule anywhere.
atalk_skip_unless_multicast() {
    "$TOOLS/atalkdrive" lookup ProbeNone > /dev/null 2>&1
    [ $? = 77 ] && skip "multicast unavailable"
    return 0
}

# atalk_name PREFIX : PREFIX with this run's own suffix appended. NBP
# names are global to the group, so every registered name a test uses
# must be unique per run (spec %8.4).
atalk_name() { echo "$1-T$$"; }

# atalk_wait_line FILE PATTERN PID : wait up to 20 s for PATTERN to show
# up in FILE, giving up early if PID died. Returns 0 when it appeared.
# (The atalkdrive peers announce themselves on stdout once their own NBP
# registration is confirmed -- ~3 s -- so every script waits for the line
# rather than sleeping a guessed interval.)
atalk_wait_line() {
    _i=0
    while [ $_i -lt 20 ]; do
        grep -q "$2" "$1" 2>/dev/null && return 0
        kill -0 "$3" 2>/dev/null || return 1
        sleep 1
        _i=$((_i + 1))
    done
    return 1
}

# atalk_wait_exit PID NAME : the program must exit ON ITS OWN, status 0,
# within 15 s -- the host CLI lifetime rule (spec %4.7: alive while a
# service is serving, a search is in flight, or an event is pending).
# Ported from tests/lib_conntest.sh's conn_wait_self_exit, with the longer
# window an NBP name removal needs.
atalk_wait_exit() {
    _pid=$1
    _name=$2
    _i=0
    while [ $_i -lt 15 ] && kill -0 "$_pid" 2>/dev/null; do
        sleep 1
        _i=$((_i + 1))
    done
    if kill -0 "$_pid" 2>/dev/null; then
        kill "$_pid" 2>/dev/null
        wait "$_pid" 2>/dev/null
        t_fail "$_name" "did not exit on its own within 15s (lifetime rule violated)"
        return 1
    fi
    wait "$_pid"
    _rc=$?
    if [ $_rc -eq 0 ]; then
        t_pass "$_name"
        return 0
    fi
    t_fail "$_name" "exit $_rc, want 0"
    return 1
}

# atalk_sweep FILE N : the first N bytes of the repeating 0..255 byte
# sweep. printf's octal escapes, not awk's "%c" -- awk goes through the
# locale's character set and mangles NUL and everything above 127.
atalk_sweep() {
    _i=0
    while [ $_i -lt "$2" ]; do
        printf "\\$(printf '%03o' $((_i % 256)))"
        _i=$((_i + 1))
    done > "$1"
    [ "$(wc -c < "$1" | tr -d ' ')" = "$2" ] || die "atalk_sweep: $1 is not $2 bytes"
}

# atalk_lock / atalk_unlock : serialize every script that puts an LToUDP
# stack on the loopback multicast group -- tests/hostrt/atalk.sh,
# tests/atalkdrive/*.sh and the network half of tests/atalk/*.sh. Under
# `make -j` those otherwise start within the same seconds, and a dozen
# stacks racing for 127 node ids is a source of flakiness that no amount
# of protocol hardening removes (a peer can only defend its node id while
# something is polling it, which a test process between operations is not).
#
# mkdir is the lock: it is the one atomic create POSIX sh has (macOS has no
# flock). The holder's pid goes inside, so a killed holder's lock is stolen
# rather than blocking every later run until the wait bound expires.
#
# The EXIT trap re-does lib.sh's own `rm -rf "$WORK"`: lib.sh is frozen, so
# there is no way to CHAIN a handler onto it, and replacing it without the
# rm would leak the work directory.
atalk_lock() {
    _lk=$BR/atalk.lock
    _i=0
    mkdir -p "$BR"
    while ! mkdir "$_lk" 2>/dev/null; do
        _owner=$(cat "$_lk/pid" 2>/dev/null)
        if [ -n "$_owner" ] && ! kill -0 "$_owner" 2>/dev/null; then
            rm -rf "$_lk"          # holder died without releasing; steal it
            continue
        fi
        [ "$_i" -ge 600 ] && die "atalk_lock: $_lk still held after 600s"
        sleep 1
        _i=$((_i + 1))
    done
    echo $$ > "$_lk/pid"
    ATALK_LOCK=$_lk
    trap 'atalk_unlock; rm -rf "$WORK"' EXIT
    trap 'atalk_unlock; rm -rf "$WORK"; exit 2' INT TERM
}

atalk_unlock() {
    [ -n "${ATALK_LOCK:-}" ] || return 0
    # Only the holder may remove it. Without this check, a waiter that
    # stole a dead holder's lock and then exited could delete the
    # directory a SECOND waiter had since legitimately created -- two
    # scripts on the group at once, which is the one thing the lock
    # exists to prevent.
    [ "$(cat "$ATALK_LOCK/pid" 2>/dev/null)" = "$$" ] || return 0
    rm -rf "$ATALK_LOCK"
    ATALK_LOCK=
}
