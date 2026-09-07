# tests/lib_tcp.sh -- helpers shared by tests/tcp/*.sh (sourced right
# after lib.sh). The TCP end-to-end group is loopback-only: it needs no
# emulator, no multicast group and therefore no lock -- but it DOES bind
# real ports, so every script takes one from tcpdrive rather than a
# hardcoded number.

# tcp_build NAME : host-build tests/tcp/testdata/NAME.cla into $WORK/NAME
# with the CURRENT-source clarusc (the committed snapshot cannot parse
# `tcp`); build output lands in $WORK/NAME.build.
tcp_build() {
    host_build "$WORK/$1" "$ROOT/tests/tcp/testdata/$1.cla" > "$WORK/$1.build" 2>&1
}

# tcp_sweep FILE : every byte value 0-255, once, in order. The hex list
# through `xxd -r -p` is the byte-safe way to do this in POSIX sh (awk's
# printf "%c" goes via the locale's character set, so NUL and high bytes
# do not survive). Copied from lib_conntest.sh's conn_sweep.
tcp_sweep() {
    _i=0
    while [ $_i -lt 256 ]; do
        printf '%02x' $_i
        _i=$((_i + 1))
    done | xxd -r -p > "$1"
    [ "$(wc -c < "$1")" -eq 256 ] || die "tcp_sweep: $1 is not 256 bytes"
}

# tcp_wait_self_exit PID NAME : the program must exit ON ITS OWN, status
# 0, within 10 s -- the CLI lifetime rule (spec %4.3). Never killed to
# make the check pass; a still-running process is a FAIL (and only then
# killed, to clean up). Copied from lib_conntest.sh's conn_wait_self_exit
# with a wider window: a TCP close lingers until the peer's FIN arrives.
tcp_wait_self_exit() {
    _pid=$1
    _name=$2
    _i=0
    while [ $_i -lt 10 ] && kill -0 "$_pid" 2>/dev/null; do
        sleep 1
        _i=$((_i + 1))
    done
    if kill -0 "$_pid" 2>/dev/null; then
        kill "$_pid" 2>/dev/null
        wait "$_pid" 2>/dev/null
        t_fail "$_name" "did not exit on its own within 10s (lifetime rule violated)"
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

# tcp_wait_port FILE PID : echo the port `tcpdrive listen 0` bound, read
# back from its own "port N" line. Empty output means it never bound (the
# caller reports the failure and cleans the peer up). `listen 0` closes
# the pick-port-then-bind race that a separately picked port leaves open.
tcp_wait_port() {
    _i=0
    while [ $_i -lt 10 ]; do
        _p=$(sed -n "s/^port //p" "$1" 2>/dev/null)
        if [ -n "$_p" ]; then
            echo "$_p"
            return 0
        fi
        kill -0 "$2" 2>/dev/null || return 1
        sleep 1
        _i=$((_i + 1))
    done
    return 1
}
