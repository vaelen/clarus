#!/bin/sh
# timeout: 30m
# mactest/snow/tcp_selfconnect (MacTCP phase, spec 8.3): the ONLY hardware
# proof of the TCP transport. examples/tcpchat.cla boots on the Snow
# System 7 machine (a Mac IIcx; Snow's "Ethernet" NAT target at SCSI 3,
# MacTCP at 10.0.0.2, gateway 10.0.0.1 -- read from its MacTCP Prep) with a
# script that clicks Self: listen(tcp 2323) + open(tcp "10.0.0.2:2323") in
# ONE program, a 256-byte sweep echoed with '>' prepended, then "hello",
# then a close seen as `closed` on the other end. Proves our .IPP
# integration -- create/passive/active open, send, receive, close,
# release -- not the network: Snow's NAT is outbound-only, so nothing
# outside the guest can take part (spec 2).
#
# System 7, not the default System 6 SE: system6.img has no MacTCP
# installed at all (no MacTCP control panel, no .IPP), so the SE lane has
# nothing to test here. The Ethernet target comes from the template
# workspace itself; snow_disk clones it unchanged.
#
# The dialled address is the guest's OWN 10.0.0.2, not 127.0.0.1: the
# phase's probe wave (task-8-report.md, P2) measured MacTCP answering a
# 127.0.0.1 active open with err 0 while the listener's passive open never
# completed -- a self-connect that looks green and is not. Against
# 10.0.0.2 the passive open completes in 0 ticks.
#
# testdata/ui/tcpchat_self.events carries the old 640x480 Snow Mac II's
# coordinates: its `click 400 64` is the Self button's centre there
# (window content left = (640 - 300) / 2 = 170; button 80x20 at 190,10).
# The IIcx's RGB12 monitor is 512 wide, like a Mac Plus, so the same
# button is at 336,64 -- restamped below; if it ever misses, `listening
# 2323` never appears.
. "$(dirname "$0")/../../lib.sh" || exit 2
. "$(dirname "$0")/../../lib_snow.sh" || die "helper lib failed to load"
require_env CLARUS_SNOW_TESTS

sed "s/^click 400 64\$/click 336 64/" "$ROOT/testdata/ui/tcpchat_self.events" \
    > "$WORK/self.events" || die "could not restamp the Self click"
grep -qx 'click 336 64' "$WORK/self.events" \
    || die "Self click restamp did not take (testdata/ui/tcpchat_self.events changed?)"
emit68k -o "$WORK/TcpChat.bin" --events "$WORK/self.events" \
    "$ROOT/examples/tcpchat.cla" > "$WORK/build.log" 2>&1 \
    || die "clarusc emit68k examples/tcpchat.cla: $(tail -5 "$WORK/build.log" | tr '\n' ' ')"

snow_disk 7
grep -q '"Ethernet"' "$SNOW_WS" || skip "snow/system7.snoww has no Ethernet SCSI target"
snow_put_bin "$WORK/TcpChat.bin" TcpChat

# 40 s of script delays + boot; the trailer is the real completion signal.
snow_run 300 "$(snow_done_when_trailer 10)"

snow_get "${SNOW_APPDIR}out" "$WORK/out"
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
# Both exchanges, individually: presence alone would let a byte-wrong
# 256-byte sweep echo pass on the trivial "hello" echo's own `echo ok`.
# The example turns a mismatch into a `failed -1 echo mismatch` line too,
# which no_failed below catches -- this is the second, independent gate.
if [ "$(grep -cxF 'echo ok' "$WORK/out")" = 2 ]; then
    t_pass sweep_and_hello_ok
else
    t_fail sweep_and_hello_ok "want 2 \"echo ok\" lines, got $(grep -cxF 'echo ok' "$WORK/out")"
fi
want_line client_closing "closing"
want_line server_closed "closed"
if grep -qF 'failed ' "$WORK/out"; then t_fail no_failed "$(grep 'failed ' "$WORK/out" | head -1)"; else t_pass no_failed; fi
if grep -qF '##CLARUS-EXIT## 0' "$WORK/out"; then t_pass clean_exit; else t_fail clean_exit "no clean exit trailer"; fi
t_done
