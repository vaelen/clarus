# tests/lib_conntest.sh -- helpers shared by tests/conntest/*.sh (sourced
# right after lib.sh). Ported from internal/conntest/conntest_test.go's own
# buildConnFixture / sweepBytes / waitExit.

# conn_build NAME : host-build tests/conntest/testdata/NAME.cla into
# $WORK/NAME with the CURRENT-source clarusc (the committed snapshot cannot
# parse `serial`); build output lands in $WORK/NAME.build.
conn_build() {
    host_build "$WORK/$1" "$ROOT/tests/conntest/testdata/$1.cla" > "$WORK/$1.build" 2>&1
}

# conn_sweep FILE : every byte value 0-255, once, in order -- the design
# spec's "full 0-255 byte sweep". The hex list through `xxd -r -p` is the
# byte-safe way to do this in POSIX sh (awk's printf "%c" is not: it goes
# via the locale's character set, so NUL and high bytes do not survive).
conn_sweep() {
    _i=0
    while [ $_i -lt 256 ]; do
        printf '%02x' $_i
        _i=$((_i + 1))
    done | xxd -r -p > "$1"
    [ "$(wc -c < "$1")" -eq 256 ] || die "conn_sweep: $1 is not 256 bytes"
}

# conn_wait_self_exit PID NAME : the program must exit ON ITS OWN, status
# 0, within 5 s -- the lifetime rule (spec §3: exits once nothing is open
# and no event is pending). Deliberately never kills it to make the check
# pass; a still-running process is a FAIL (and only then gets killed, to
# clean up).
conn_wait_self_exit() {
    _pid=$1
    _name=$2
    _i=0
    while [ $_i -lt 5 ] && kill -0 "$_pid" 2>/dev/null; do
        sleep 1
        _i=$((_i + 1))
    done
    if kill -0 "$_pid" 2>/dev/null; then
        kill "$_pid" 2>/dev/null
        wait "$_pid" 2>/dev/null
        t_fail "$_name" "did not exit on its own within 5s (lifetime rule violated)"
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
