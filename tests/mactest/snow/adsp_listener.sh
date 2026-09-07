#!/bin/sh
# timeout: 30m
# mactest/snow/adsp_listener (2026-09-07 appletalk spec 8.3/9.5, Task 13c):
# the SYSTEM 7 half of the ADSP stream proof. Snow -- a Mac II booting
# System 7 off the Clarus.snoww scratch clone -- runs
# examples/atalkchat.cla as the ADSP LISTENER, and Mini vMac (System 6,
# macplus/, via LaunchAPPL) runs the SAME binary source as the client.
# The twelve assertions are tests/mactest/adsp_68k.sh's, verbatim; see
# that script's header for what each one proves. What THIS script adds is
# that the listener half runs on different system software, a different
# CPU and a different emulator from the client -- so a green run says the
# native ADSP bodies in runtime/clarus/atalk_68k.cla talk to System 7's
# .DSP as well as to the Mac Plus ROM's, and that the two interoperate
# over LocalTalk-over-UDP.
#
# ---- sequencing ----
# Snow has no headless mode and snow_run BLOCKS for the whole boot, so
# the client half runs in a background subshell started before it. That
# subshell does not boot immediately: it polls `atalkdrive lookup` on the
# shared multicast group until the server's OWN NBP name is registered,
# which is a real signal (NBP answered) rather than a guessed sleep, and
# only then calls run_mac. A client that boots before the listener exists
# would burn its eight brs.find retries on an empty group.
#
# snow_run's done command is snow_done_when_trailer: the server quits
# itself when the client closes the stream (`on chat.closed { quit }`),
# and natQuit's ##CLARUS-EXIT## trailer reaches the live disk image
# mid-boot. Both captures are then split with capture_split, the same
# parse both lanes' `out` streams use.
#
# ---- timing budget ----
# Measured on the P5 probe boot (task-13c-report.md): the host's
# `atalkdrive lookup` first sees a Snow guest's NBP name 35 s after Snow
# is launched -- System 7 boot, Startup Items launch, and NBP's own
# ~3.2 s verified register, all in. The scripted server then has
# 400 `tick 12` lines x Delay(10) ~= 66 s of real life before its own
# watchdog quits it (examples/atalkchat.cla), and the client needs ~20 s
# from LaunchAPPL start to `closing` (task-13a-report.md: the whole
# two-boot Mini vMac pair is 20 s). So the exchange sits inside a ~66 s
# server window with ~45 s of slack. snow_run's 600 s is the CEILING for
# a boot that never writes a trailer, not an expectation; run_mac's own
# 300 s and the client half's 240 s discovery bound sit under it.
#
# ---- the click ----
# The scripted server events file clicks the Serve button in GLOBAL
# screen coordinates, and ui.cla centers a window horizontally on the
# real screen (`left = (screenW - reqW) / 2`, rtUiOpen). Snow's monitor
# is 640x480, not the Mac Plus's 512x342, so a 300-wide window opens at
# left 170, not 106, and the committed testdata/ui/atalkchat_server.events
# click (156,64 -- correct for 512) lands on the desktop here. The sed
# below restamps it to 220,64, which is that same Serve button on a
# 640-wide screen. If it ever misses, `serving Chat-` never appears and
# server_registered fails loudly.
#
# Unlike adsp_68k.sh there is deliberately NO `failed -1273` boot-disk
# skip here (the same ruling as the toolbox suite's AdspLeak case): a
# machine that can run the Snow lane at all is by definition one with the
# LaunchAPPL AppleTalk patch and a System 7 disk that carries .DSP, so
# twelve loud FAILs are the right answer to a missing driver, not a
# green-by-skip.
. "$(dirname "$0")/../../lib.sh" || exit 2
. "$(dirname "$0")/../../lib_snow.sh" || die "helper lib failed to load"
. "$(dirname "$0")/../../lib_mac.sh" || die "helper lib failed to load"
. "$(dirname "$0")/../../lib_atalk.sh" || die "helper lib failed to load"
require_env CLARUS_SNOW_TESTS
require_env CLARUS_MAC_TESTS

DRIVE=$TOOLS/atalkdrive
require_tool "$DRIVE"
atalk_skip_unless_multicast

# Per-run NBP type, for the same reason adsp_68k.sh stamps one: the
# client connects to the FIRST match of the type it searches, and the
# loopback multicast group is shared with Andrew's own sessions and with
# any concurrent gate run.
TYPE=ClarusChat$$
sed "s/ClarusChat/$TYPE/g" examples/atalkchat.cla > "$WORK/atalkchat.cla" \
    || die "could not stamp a per-run NBP type into the example"
sed "s/^click 156 64\$/click 220 64/" testdata/ui/atalkchat_server.events \
    > "$WORK/server.events" || die "could not restamp the Serve click"
grep -qx 'click 220 64' "$WORK/server.events" \
    || die "Serve click restamp did not take (testdata/ui/atalkchat_server.events changed?)"

emit68k -o "$WORK/chatsrv.bin" --events "$WORK/server.events" \
    "$WORK/atalkchat.cla" > "$WORK/emit_srv.log" 2>&1 \
    || die "clarusc emit68k atalkchat (server): $(tail -10 "$WORK/emit_srv.log")"
emit68k -o "$WORK/chatcli.bin" --events testdata/ui/atalkchat_client.events \
    "$WORK/atalkchat.cla" > "$WORK/emit_cli.log" 2>&1 \
    || die "clarusc emit68k atalkchat (client): $(tail -10 "$WORK/emit_cli.log")"

# snow_run makes this same refusal, but only AFTER snow_localtalk_b has
# been armed below -- and an armed clicker whose parent then died on that
# refusal is a clicker looking for a Snow window that is somebody else's.
# (snow_localtalk_b's own $WORK/snow.log gate is the belt to this
# braces; both are cheap.)
_other=$(pgrep -x Snow | tr '\n' ' ')
[ -z "$_other" ] || die "another Snow process is already running (pid $_other) -- refusing to boot"

# The fixture COMPILES above need no network; the lock is taken as late
# as possible (tests/lib_atalk.sh's own rule).
atalk_lock

# One cleanup for every exit path from here on: kill our two background
# halves (and, by its own per-run cwd -- never by app name -- any
# emulator the client half has started), drop the LToUDP lock, remove
# $WORK. atalk_lock installed a trap without the kills, and snow_run
# replaces the trap with one of its own, so this is installed here and
# re-installed after snow_run returns. Both halves ALSO give up on their
# own when $WORK disappears, which covers the one window neither trap
# does: a `die` inside snow_run runs snow_run's trap, not this one.
cleanup() {
    [ -n "${SNOW_LTALK_PID:-}" ] && kill "$SNOW_LTALK_PID" 2>/dev/null
    [ -n "${CLIPID:-}" ] && kill "$CLIPID" 2>/dev/null
    pkill -f "$WORK/launch" 2>/dev/null
    atalk_unlock
    rm -rf "$WORK"
    return 0
}
trap cleanup EXIT
trap 'cleanup; exit 2' INT TERM

snow_disk
snow_put_bin "$WORK/chatsrv.bin" AtalkChat

# ---- the client half, running while snow_run blocks ----
# `trap - EXIT`: a backgrounded subshell would otherwise run lib.sh's own
# `rm -rf "$WORK"` when it finishes and delete the tree the parent is
# still writing into. run_mac's `die` path is wrapped in an inner
# subshell so that a client boot which dies still lets this function
# return -- the parent's own `[ -f "$CLI" ]` check below is what reports
# it, with client.out's diagnostic attached.
client_half() {
    trap - EXIT
    _end=$(( $(date +%s) + 240 ))
    _t0=$(date +%s)
    while [ "$(date +%s)" -lt "$_end" ]; do
        # The parent is gone (every EXIT trap here removes $WORK) -- stop
        # before booting an emulator nobody is left to read.
        [ -d "$WORK" ] || return 0
        "$DRIVE" lookup "$TYPE" > "$WORK/lk.out" 2>&1
        if grep -q ":$TYPE" "$WORK/lk.out"; then
            echo "listener visible after $(( $(date +%s) - _t0 ))s: $(tr '\n' '|' < "$WORK/lk.out")"
            break
        fi
        sleep 3
    done
    grep -q ":$TYPE" "$WORK/lk.out" \
        || echo "listener NEVER visible on the group in $(( $(date +%s) - _t0 ))s -- booting the client anyway"
    [ -d "$WORK" ] || return 0
    (
        run_mac "$WORK/chatcli.bin" 300
        echo "$MAC_EXIT" > "$WORK/client.exit"
        mv "$WORK/cap.log" "$WORK/cli.log"
    )
}
client_half > "$WORK/client.out" 2>&1 &
CLIPID=$!

# Snow's LocalTalk-over-UDP bridge is off by default and cannot be
# turned on from the command line or the workspace file -- see
# snow_localtalk_b's own header. Without it the Snow guest's AppleTalk
# is alive but talks to nobody, and every assertion below fails for a
# reason that has nothing to do with ADSP. Armed before snow_run (which
# blocks), checked after it.
snow_localtalk_b

snow_run 600 "$(snow_done_when_trailer 20)"
# snow_run installed its own EXIT trap and left `kill -9 <snow>;
# rm -rf "$WORK"` behind it, which drops both the unlock and the
# background-half kills. Restore ours. A lock leaked by a crash in
# between is self-healing: atalk_lock steals a lock whose recorded holder
# pid is gone.
trap cleanup EXIT
trap 'cleanup; exit 2' INT TERM
wait "$CLIPID" 2>/dev/null
# A bridge that never came up is a HARNESS fault, not a verdict about
# ADSP: every assertion below would fail, all twelve for the same reason.
# Die with the real one instead. (t_fail would also be wrong -- this
# script's contract is 12 result lines, adsp_68k.sh's, exactly.)
sed 's/^/  snow: /' "$WORK/ltalk.log"
wait "$SNOW_LTALK_PID" || die "LocalTalk bridge not enabled: $(tr '\n' ' ' < "$WORK/ltalk.log")"

snow_get ":System Folder:Startup Items:out" "$WORK/srv.raw"
capture_split "$WORK/srv.raw"
SRV_EXIT=$MAC_EXIT
mv "$WORK/cap.log" "$WORK/srv.log"

SRV=$WORK/srv.log
CLI=$WORK/cli.log
[ -f "$CLI" ] || { cat "$WORK/client.out"; die "the client boot produced no log: $(tail -5 "$WORK/client.out" | tr '\n' ' ')"; }

# Everything, verbatim, into this test's own log: the server's per-run
# name suffix and the entity the client actually picked exist nowhere
# else, and a failure is unreadable without them. Prefixed so no line of
# guest output can look like a result line to the runner.
sed 's/^/  host: /' "$WORK/client.out"
sed 's/^/  server: /' "$SRV"
sed 's/^/  client: /' "$CLI"

# want_line NAME FILE TEXT : FILE must contain TEXT as a WHOLE line --
# an exact match is what keeps "received 5" from being satisfied by a
# "received 57" (adsp_68k.sh's own helper, unchanged).
want_line() {
    if grep -qxF "$3" "$2"; then
        t_pass "$1"
    else
        t_fail "$1" "log has no \"$3\" line: $(tr '\n' '|' < "$2")"
    fi
}

CLI_EXIT=$(cat "$WORK/client.exit" 2>/dev/null)
[ "$SRV_EXIT" = 0 ] && t_pass server_exit || t_fail server_exit "exit $SRV_EXIT, want 0"
[ "$CLI_EXIT" = 0 ] && t_pass client_exit || t_fail client_exit "exit ${CLI_EXIT:-<none>}, want 0"

# Server: the Serve click landed on the right widget and lsn.register was
# reached. The name carries the example's own per-run suffix, so only the
# prefix is fixed.
if grep -q '^serving Chat-' "$SRV"; then
    t_pass server_registered
else
    t_fail server_registered "server log has no \"serving Chat-...\" line: $(tr '\n' '|' < "$SRV")"
fi
# NBP advertised it, and System 7's .DSP delivered the incoming request
# to dspCLListen, which the runtime accepted as an already-open
# connection (spec 4.2).
want_line server_accepted "$SRV" "accepted"
# The 256-byte sweep, delivered in one piece.
want_line server_sweep "$SRV" "received 256"
# "hello", after the client saw the sweep's echo -- the lock step.
want_line server_hello "$SRV" "received 5"
# spec 4.1: on ADSP, `closed` is a real event -- the peer's close.
want_line server_closed "$SRV" "closed"

# Client: the NBP lookup found the System 7 listener's name and the ADSP
# open to it completed.
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
