#!/bin/sh
# timeout: 25m
# mactest/adsp_68k (2026-09-06 appletalk spec 8.2, Task 11): TWO native
# Mini vMac boots of examples/atalkchat.cla at once -- macplus/ as the
# ADSP listener, macplus2/ as the client -- proving the whole stream
# stack against real ROM AppleTalk and a real second machine:
# lsn.register + NBP advertisement, brs.find of that name, an
# open(appletalk "Name:Type") that resolves it, `accepted` handing over
# an already-open connection, a byte-exact echo in both directions, and
# `closed` firing on the peer's close.
#
# The two boots are the SAME binary source with two different --events
# scripts; the only difference is which button the script clicks (spec
# 8.5). run_mac_pair (tests/lib_mac.sh) staggers them by 5 s, kills both
# by cwd on any failure -- never by app name, which would take out an
# unrelated session's emulator -- and splits each capture into
# $WORK/cap{1,2}.log with MAC_EXIT1/MAC_EXIT2.
#
# The lengths asserted below are the lock-step exchange the example
# performs: the client sends a 256-byte 0..255 sweep, the server echoes
# it with a '>' prepended (257), the client then sends "hello" (5) and
# gets ">hello" (6) back. `echo ok` is the client's own byte-for-byte
# check of both echoes -- the length lines alone would pass on a stream
# that dropped or reordered bytes.
#
# There is no multicast/no-peer skip -- both peers here are emulators this
# script boots itself, so either the pair runs or the environment gate
# (CLARUS_MAC_TESTS) already declined -- but there IS a boot-disk skip:
# see the -1273 check after run_mac_pair below.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_mac.sh" || die "helper lib failed to load"
require_env CLARUS_MAC_TESTS
[ -d "$ROOT/macplus2" ] || skip "macplus2 not present"

# The NBP TYPE is made per-run here rather than in the committed example
# (spec 8.4's "register names with a per-run suffix"): the example's own
# per-run suffix is on the NAME, but the client can only search by type,
# so a concurrent ClarusChat on the group -- Andrew's own session, or a
# second gate run -- would otherwise be a live false-failure vector. The
# client connects to the first match, and with a PID-stamped type the
# only match is this run's own server. The committed example keeps the
# plain "ClarusChat" so it stays a readable demo.
sed "s/ClarusChat/ClarusChat$$/g" examples/atalkchat.cla > "$WORK/atalkchat.cla" \
    || die "could not stamp a per-run NBP type into the example"

emit68k -o "$WORK/chatsrv.bin" --events testdata/ui/atalkchat_server.events \
    "$WORK/atalkchat.cla" > "$WORK/emit_srv.log" 2>&1 \
    || die "clarusc emit68k atalkchat (server): $(tail -10 "$WORK/emit_srv.log")"
emit68k -o "$WORK/chatcli.bin" --events testdata/ui/atalkchat_client.events \
    "$WORK/atalkchat.cla" > "$WORK/emit_cli.log" 2>&1 \
    || die "clarusc emit68k atalkchat (client): $(tail -10 "$WORK/emit_cli.log")"

run_mac_pair "$WORK/chatsrv.bin" "$WORK/chatcli.bin" 420

SRV=$WORK/cap1.log
CLI=$WORK/cap2.log

# Both logs, verbatim, into this test's own log -- the server's name
# suffix and the entity the client actually picked are only visible here,
# and a failure is unreadable without them. Prefixed so no line of guest
# output can ever look like a result line to the runner.
sed 's/^/  server: /' "$SRV"
sed 's/^/  client: /' "$CLI"

# The boot disk LaunchAPPL builds is System + AutoQuit + the app and
# nothing else -- in particular no `AppleTalk` system file, so the .DSP
# driver is absent and `lsn.register` fails with -1273 (the example logs
# it as "failed -1273 ..."). Without ADSP there is no stream stack to
# test, so the run is a SKIP, not a failure. This check runs BEFORE the
# first t_fail/want_line on purpose: a FAIL line in the log beats exit 77
# in this harness, so a single assertion ahead of it would turn the skip
# into a red result. Task 13's out-of-repo LaunchAPPL patch (carry the
# AppleTalk file onto the disk) is what makes this script run for real;
# every assertion below is kept intact for that lane.
if grep -q '^failed -1273 ' "$SRV"; then
    skip "boot disk lacks .DSP (AppleTalk system file not carried by LaunchAPPL)"
fi

# want_line NAME FILE TEXT : FILE must contain TEXT as a WHOLE line. The
# log lines asserted here are all complete lines the example emits, and
# an exact match is what keeps "received 5" from being satisfied by a
# "received 57".
want_line() {
    if grep -qxF "$3" "$2"; then
        t_pass "$1"
    else
        t_fail "$1" "log has no \"$3\" line: $(tr '\n' '|' < "$2")"
    fi
}

[ "$MAC_EXIT1" = 0 ] && t_pass server_exit || t_fail server_exit "exit $MAC_EXIT1, want 0"
[ "$MAC_EXIT2" = 0 ] && t_pass client_exit || t_fail client_exit "exit $MAC_EXIT2, want 0"

# Server: the Serve click landed and `lsn.register` was reached -- the
# half that still works on a boot disk with no AppleTalk file, and the
# only proof the scripted click hit the right widget. The name carries
# the example's own per-run suffix, so only the prefix is fixed.
if grep -q '^serving Chat-' "$SRV"; then
    t_pass server_registered
else
    t_fail server_registered "server log has no \"serving Chat-...\" line: $(tr '\n' '|' < "$SRV")"
fi
# NBP advertised it, and the incoming ADSP request was accepted as an
# already-open connection (spec 4.2).
want_line server_accepted "$SRV" "accepted"
# The 256-byte sweep, delivered in one piece.
want_line server_sweep "$SRV" "received 256"
# "hello", after the client saw the sweep's echo -- the lock step.
want_line server_hello "$SRV" "received 5"
# spec 4.1: on ADSP, `closed` is a real event -- the peer's close.
want_line server_closed "$SRV" "closed"

# Client: the NBP lookup found the server's name and the ADSP open to it
# completed (spec 4.1's "opened fires on a later pump pass").
want_line client_opened "$CLI" "opened"
# The echoes, ">"-prefixed by the server: 256+1 and 5+1.
want_line client_sweep_echo "$CLI" "received 257"
want_line client_hello_echo "$CLI" "received 6"
# The byte-for-byte half of the echo proof; the client logs one per echo,
# so a single `echo bad` anywhere is a failure.
want_line client_echo_exact "$CLI" "echo ok"
if grep -qxF "echo bad" "$CLI"; then
    t_fail client_echo_bytes "client reported a byte mismatch in an echo"
else
    t_pass client_echo_bytes
fi

t_done
