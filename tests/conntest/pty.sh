#!/bin/sh
# tests/conntest/pty.sh -- the `pty` serial transport (appletalk phase,
# Task 4; spec 4.7): CLARUS_SERIAL_MODEM=pty allocates a pty master and
# announces the slave path on stderr, so a terminal program can be driven
# by anything that opens a serial device. The same echo.cla fixture the
# socket scripts use; the client half is a short python3 driver (there is
# no TCP here for $TOOLS/tcpdrive to speak).
#
# Two shapes worth knowing, both rt_serial.inc's documented behaviour:
#  1. a pty with no slave attached is the `listening` state -- the
#     program's `on conn.opened { conn.send("READY\n") }` greeting is
#     DISCARDED, exactly as a write into an unplugged cable is. The
#     runtime only counts a slave as attached once bytes arrive FROM it,
#     so the driver's own first byte is always the first thing that can
#     provoke a write back. Like listen.sh, the driver therefore sends a
#     one-byte probe ("!", a byte that appears neither in "READY\r" nor in
#     the QQQ terminator) and consumes through its echo before the exact
#     sweep comparison, tolerating a greeting that did make it out.
#  2. the client owns the slave's line discipline, as it owns a real
#     serial device's -- the driver raws the slave BEFORE sending anything
#     (rule 1 guarantees it wins that race), because a cooked pty echoes
#     the master's own writes back at it, which would turn an echo server
#     into an infinite loop.
# A third: closing a pty master discards anything the client has not read
# yet, so the driver asserts the hangup after "QQQ" rather than the echo
# of "QQQ" itself (see the driver's own comment).
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_conntest.sh" || die "helper lib failed to load"

command -v python3 >/dev/null 2>&1 || skip "python3 not found"

conn_build echo || { t_fail build "$(cat "$WORK/echo.build")"; t_done; }
t_pass build

cat > "$WORK/driver.py" <<'PY'
import os, sys, termios, time, tty

path = sys.argv[1]
fd = os.open(path, os.O_RDWR | os.O_NOCTTY | os.O_NONBLOCK)
tty.setraw(fd, termios.TCSAFLUSH)   # cfmakeraw + drop anything already queued
deadline = time.time() + 20

def fail(msg):
    sys.stderr.write(msg + "\n")
    sys.exit(1)

def write_all(data):
    off = 0
    while off < len(data):
        try:
            off += os.write(fd, data[off:])
        except BlockingIOError:
            time.sleep(0.01)

def read_n(n, what):
    buf = b""
    while len(buf) < n:
        if time.time() > deadline:
            fail("timeout reading %s: got %d of %d bytes (%r)" % (what, len(buf), n, buf[:32]))
        try:
            b = os.read(fd, n - len(buf))
        except BlockingIOError:
            b = b""
        except OSError as e:
            fail("read failed reading %s: %s" % (what, e))
        if b:
            buf += b
        else:
            time.sleep(0.01)
    return buf

write_all(b"!")
seen = b""
while True:
    seen += read_n(1, "probe echo")
    if seen.endswith(b"!"):
        break
    if len(seen) > 8:
        fail("no probe echo within 8 bytes: %r" % seen)

sweep = bytes(range(256))
write_all(sweep)
got = read_n(len(sweep), "sweep echo")
if got != sweep:
    bad = next(i for i in range(len(sweep)) if got[i] != sweep[i])
    fail("sweep echo differs at byte %d: got %d want %d" % (bad, got[bad], sweep[bad]))

# "QQQ" makes echo.cla close its side. Closing a pty master DISCARDS
# whatever the client has not read yet (macOS: no TIOCOUTQ, no tcdrain on
# a master -- rt_serial.inc says so too), so the echo of QQQ itself may or
# may not survive the close that follows it in the same handler; what is
# guaranteed, and what this asserts, is that the hangup reaches the client
# and that anything that DID arrive is a prefix of the echo, never stray
# bytes.
write_all(b"QQQ")
tail = b""
while True:
    if time.time() > deadline:
        fail("no hangup after QQQ (trailing bytes so far: %r)" % tail)
    try:
        b = os.read(fd, 16)
    except BlockingIOError:
        time.sleep(0.01)
        continue
    except OSError:
        break       # EIO: the master went away
    if not b:
        break       # EOF: the master closed
    tail += b
if tail not in (b"", b"Q", b"QQ", b"QQQ"):
    fail("unexpected trailing bytes after QQQ: %r" % tail)
sys.exit(0)
PY

CLARUS_SERIAL_MODEM=pty "$WORK/echo" > "$WORK/prog.out" 2> "$WORK/prog.err" &
prog=$!

# The announcement is fprintf(stderr)+fflush at open, so polling the file
# is a real synchronisation point rather than a sleep.
dev=
i=0
while [ $i -lt 10 ]; do
    dev=$(sed -n 's/^pty //p' "$WORK/prog.err" 2>/dev/null | head -1)
    [ -n "$dev" ] && break
    sleep 1
    i=$((i + 1))
done
if [ -z "$dev" ]; then
    kill "$prog" 2>/dev/null
    wait "$prog" 2>/dev/null
    t_fail announce "no 'pty /dev/...' line on stderr within 10s: $(cat "$WORK/prog.err")"
    t_done
fi
case "$dev" in
    /dev/*) t_pass announce ;;
    *) kill "$prog" 2>/dev/null; wait "$prog" 2>/dev/null
       t_fail announce "announced path is not a device: $dev"; t_done ;;
esac

if python3 "$WORK/driver.py" "$dev" > "$WORK/driver.out" 2>&1; then
    t_pass exchange
else
    t_fail exchange "driver: $(cat "$WORK/driver.out")"
fi

conn_wait_self_exit "$prog" lifetime || echo "prog stderr: $(cat "$WORK/prog.err")"
t_done
