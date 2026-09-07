#!/bin/sh
# timeout: 30m
# mactest/snow/tcp_selfconnect (MacTCP phase, spec 8.3): the ONLY hardware
# proof of the TCP transport. Snow's Mac II (System 7, DaynaPORT NAT at
# SCSI 3, MacTCP 2.x at 10.0.0.2) boots examples/tcpchat.cla with a script
# that clicks Self: listen(tcp 2323) + open(tcp "10.0.0.2:2323") in ONE
# program, a 256-byte sweep echoed with '>' prepended, then "hello", then a
# close seen as `closed` on the other end. Proves our .IPP integration --
# create/passive/active open, send, receive, close, release -- not the
# network: Snow's NAT is outbound-only, so nothing outside the guest can
# take part (spec 2).
#
# The dialled address is the guest's OWN 10.0.0.2, not 127.0.0.1: the
# phase's probe wave (task-8-report.md, P2) measured MacTCP answering a
# 127.0.0.1 active open with err 0 while the listener's passive open never
# completed -- a self-connect that looks green and is not. Against
# 10.0.0.2 the passive open completes in 0 ticks.
#
# testdata/ui/tcpchat_self.events carries SNOW coordinates: its `click
# 400 64` is the Self button's centre on a 640x480 screen (window content
# left = (640 - 300) / 2 = 170, top = 44; button 80x20 at 190,10). The
# same button is at 336,64 on a 512x342 Mac Plus, so this file is not
# reusable for a Mini vMac boot without a restamp -- exactly the trap
# task-8-report.md's P5 boot hit with atalkchat's own script.
#
# snow_run boots snow/ClarusSnow, a separate copy from the `Snow` a BBS
# session may be running on this machine: the two coexist, and snow_run
# refuses only when another ClarusSnow is already up.
. "$(dirname "$0")/../../lib.sh" || exit 2
. "$(dirname "$0")/../../lib_snow.sh" || die "helper lib failed to load"
require_env CLARUS_SNOW_TESTS

emit68k -o "$WORK/TcpChat.bin" --events "$ROOT/testdata/ui/tcpchat_self.events" \
    "$ROOT/examples/tcpchat.cla" > "$WORK/build.log" 2>&1 \
    || die "clarusc emit68k examples/tcpchat.cla: $(tail -5 "$WORK/build.log" | tr '\n' ' ')"

snow_disk
snow_ethernet
snow_put_bin "$WORK/TcpChat.bin" TcpChat

# 40 s of script delays + boot; the trailer is the real completion signal.
snow_run 300 "$(snow_done_when_trailer 10)"

snow_get ":System Folder:Startup Items:out" "$WORK/out"
sed 's/^/  guest: /' "$WORK/out"

want_line() {   # want_line NAME TEXT
    if grep -qxF "$2" "$WORK/out"; then t_pass "$1"; else t_fail "$1" "no \"$2\" line"; fi
}
want_line listening "listening 2323"
want_line accepted "accepted"
want_line opened "opened"
want_line sweep_in "received 256"
want_line sweep_echo "received 257"
want_line hello_in "received 5"
want_line hello_echo "received 6"
want_line echo_exact "echo ok"
want_line client_closing "closing"
want_line server_closed "closed"
if grep -qF 'failed ' "$WORK/out"; then t_fail no_failed "$(grep 'failed ' "$WORK/out" | head -1)"; else t_pass no_failed; fi
if grep -qF '##CLARUS-EXIT## 0' "$WORK/out"; then t_pass clean_exit; else t_fail clean_exit "no clean exit trailer"; fi
t_done
