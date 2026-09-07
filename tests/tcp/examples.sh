#!/bin/sh
# tests/tcp/examples.sh (2026-09-07 mactcp phase, Task 10): the TCP example
# must keep compiling on both lanes. examples/tcpchat.cla is otherwise built
# only inside tests/mactest/snow/tcp_selfconnect.sh, a CLARUS_SNOW_TESTS-only
# 30-minute emulator boot -- so a language or runtime change could rot it and
# no T1 run would say so.
#
# Both halves EMIT rather than check-only (tests/atalk/examples.sh's own
# reasoning): the transport caps and the address/port fences live in
# LOWERING, which check-only never runs. There is no host `cc` half -- this
# is a UI program and the host C lane only compiles non-UI ones -- so the
# native emit68k is the second lane, and it carries --events so the boot's
# scripted-event file is loaded and embedded here too, not first inside the
# Snow boot. No network, no lock, no emulator; both emits take well under a
# second.
. "$(dirname "$0")/../lib.sh" || exit 2

if "$CLARUSC" emit --rtdir "$RTDIR" -o "$WORK/tcpchat.c" "$ROOT/examples/tcpchat.cla" \
    > "$WORK/host.log" 2>&1; then
    t_pass tcpchat_host
else
    t_fail tcpchat_host "$(tail -20 "$WORK/host.log")"
fi

if emit68k -o "$WORK/TcpChat.bin" --events "$ROOT/testdata/ui/tcpchat_self.events" \
    "$ROOT/examples/tcpchat.cla" > "$WORK/68k.log" 2>&1; then
    t_pass tcpchat_68k
else
    t_fail tcpchat_68k "$(tail -20 "$WORK/68k.log")"
fi

t_done
