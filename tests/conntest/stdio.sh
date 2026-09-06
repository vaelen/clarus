#!/bin/sh
# tests/conntest/stdio.sh -- the `stdio` serial transport (appletalk phase,
# Task 4; spec 4.7): CLARUS_SERIAL_MODEM=stdio makes the program itself the
# terminal program -- it reads fd 0 and writes fd 1, no socket anywhere.
# The same echo.cla fixture connect.sh/listen.sh use, driven through a FIFO
# on stdin with stdout captured to a file.
#
# stdio is never "unattached" the way a listening socket or an unattached
# pty is (fd 0 and fd 1 exist from the moment the process starts), so the
# `on conn.opened { conn.send("READY\n") }` greeting cannot be discarded
# here -- unlike listen.sh, this script can and does assert the whole
# stream byte-exactly, greeting included: "READY\r" (a Clarus "\n" literal
# is CR on the wire), then the 0-255 sweep echoed back, then the "QQQ"
# terminator echoed back before the program closes itself.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_conntest.sh" || die "helper lib failed to load"

conn_build echo || { t_fail build "$(cat "$WORK/echo.build")"; t_done; }
t_pass build

conn_sweep "$WORK/sweep"
printf 'QQQ' > "$WORK/qqq"
printf 'READY\r' > "$WORK/expect"
cat "$WORK/sweep" "$WORK/qqq" >> "$WORK/expect"
want=$(wc -c < "$WORK/expect")

mkfifo "$WORK/in" || die "mkfifo failed"
CLARUS_SERIAL_MODEM=stdio "$WORK/echo" < "$WORK/in" > "$WORK/out" 2> "$WORK/prog.err" &
prog=$!
# Read-write open: never blocks waiting for a reader, and our own read end
# keeps the FIFO from signalling EOF if a `cat` below finishes early.
exec 3<> "$WORK/in"

# The greeting is written with a bare write(1, ...), so it lands in the
# output file as soon as the pump's first pass fires `opened` -- polling
# the file's size is a real synchronisation point, not a sleep.
i=0
while [ $i -lt 10 ] && [ "$(wc -c < "$WORK/out")" -lt 6 ]; do
    sleep 1
    i=$((i + 1))
done
if [ "$(wc -c < "$WORK/out")" -lt 6 ]; then
    exec 3>&-
    kill "$prog" 2>/dev/null
    wait "$prog" 2>/dev/null
    t_fail greeting "no READY on stdout within 10s: $(cat "$WORK/prog.err")"
    t_done
fi
t_pass greeting

cat "$WORK/sweep" >&3
cat "$WORK/qqq" >&3

i=0
while [ $i -lt 10 ] && [ "$(wc -c < "$WORK/out")" -lt "$want" ]; do
    sleep 1
    i=$((i + 1))
done
head -c "$want" "$WORK/out" > "$WORK/got"
if cmp -s "$WORK/expect" "$WORK/got"; then
    t_pass exchange
else
    t_fail exchange "stdout differs: $(cmp "$WORK/expect" "$WORK/got" 2>&1 | head -1)"
fi

exec 3>&-
conn_wait_self_exit "$prog" lifetime || echo "prog stderr: $(cat "$WORK/prog.err")"
t_done
