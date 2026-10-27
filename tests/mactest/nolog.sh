#!/bin/sh
# timeout: 10m
# mactest/nolog -- a production native build (build68k WITHOUT --capture or
# --events) writes no `out` file at all. testdata/mactest/nolog.cla calls
# log("x") and quits 0; booted with run_mac's own LaunchAPPL invocation.
#
# Observed LaunchAPPL behavior with no `out` file (2026-09-29): it treats
# the missing file as an empty capture -- exit 0, nothing on stdout. So
# the assertion is exit 0 plus an empty capture (in particular, no
# ##CLARUS-EXIT## trailer). Before production mode existed this boot
# captured "##CLARUS-EXIT## 0 / ##CLARUS-LOG## / x" (35 bytes).
#
# Second subcase (initpanic): the opposite direction. A --capture build of
# testdata/mactest/initpanic.cla, whose GLOBAL INITIALIZER panics before
# any handler runs, must still write `out` with "##CLARUS-EXIT## 3" and
# the panic text in the log -- natSetCapture has to run before
# cg_init_globals, not after it.
#
# log-trace-optin subcases: logout (a production build of
# testdata/mactest/logout.cla that calls app.writeLog("out") -- the
# capture must be exactly "l1\nl2\nl3\n") and tracelog (a production
# build of testdata/cg68k/tickprobe.cla, whose app.writeLog("out") +
# app.trace(true) must leave its UI trace lines in out), plus logvol (the
# log stays in its own folder after the default directory moves), and
# logpanic (a production build of testdata/mactest/logpanic.cla that
# logs one line and then panics -- out must be exactly that line plus the
# runtime error line).
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_mac.sh" || die "helper lib failed to load"
require_env CLARUS_MAC_TESTS

# prod_boot NAME SRC : a production build68k (no --capture) of SRC, booted
# with run_mac's LaunchAPPL call minus capture_split (which dies on a
# missing trailer -- the whole point here). Leaves the raw capture in
# $WORK/NAME.raw and LaunchAPPL's exit code in $rc.
prod_boot() {
    build68k -o "$WORK/$1.bin" "$2" > "$WORK/$1.emit" 2>&1 \
        || die "clarusc build68k $1: $(tail -10 "$WORK/$1.emit")"
    mkdir -p "$WORK/launch_$1"
    # shellcheck disable=SC2086
    ( cd "$WORK/launch_$1" && "$TOOLS/timeout" 180 $MAC_LAUNCH "$WORK/$1.bin" \
        > "$WORK/$1.raw" 2> "$WORK/$1.err" )
    rc=$?
    mac_kill_ours "$WORK/launch_$1"
    [ $rc -eq 124 ] && die "LaunchAPPL $1.bin timed out (emulator killed): $(head -5 "$WORK/$1.err")"
    [ $rc -eq 0 ] || t_fail "$1" "LaunchAPPL exit $rc, want 0: $(head -5 "$WORK/$1.err")"
}
mac_launch macplus

prod_boot nolog testdata/mactest/nolog.cla
if [ $rc -eq 0 ]; then
    if [ -s "$WORK/nolog.raw" ]; then
        t_fail nolog "capture not empty ($(wc -c < "$WORK/nolog.raw") bytes): $(head -5 "$WORK/nolog.raw")"
    else
        t_pass nolog
    fi
fi

# logout: a production build that opts in with app.writeLog("out") -- the
# capture is exactly its log lines, in the production format.
prod_boot logout testdata/mactest/logout.cla
printf 'l1\nl2\nl3\n' > "$WORK/logout.want"
if [ $rc -eq 0 ]; then
    if cmp -s "$WORK/logout.raw" "$WORK/logout.want"; then
        t_pass logout
    else
        t_fail logout "capture is not exactly l1/l2/l3: $(od -c "$WORK/logout.raw" | head -5)"
    fi
fi

# logvol: the default directory moves (PBSetVol, as askOpen/askSave do)
# after app.writeLog -- the lines flushed after the move must still land
# in the log's own folder (the fixture checks and reports via `out`).
prod_boot logvol testdata/mactest/logvol.cla
printf 'sublog ok\n' > "$WORK/logvol.want"
if [ $rc -eq 0 ]; then
    if cmp -s "$WORK/logvol.raw" "$WORK/logvol.want"; then
        t_pass logvol
    else
        t_fail logvol "capture is not \"sublog ok\": $(od -c "$WORK/logvol.raw" | head -5)"
    fi
fi

# logpanic: a production runtime panic flushes the log before quitting
# and writes nothing else (no trailer, no second copy of the error line).
prod_boot logpanic testdata/mactest/logpanic.cla
printf 'before\nruntime error: list index out of range\n' > "$WORK/logpanic.want"
if [ $rc -eq 0 ]; then
    if cmp -s "$WORK/logpanic.raw" "$WORK/logpanic.want"; then
        t_pass logpanic
    else
        t_fail logpanic "capture is not before + the runtime error line: $(od -c "$WORK/logpanic.raw" | head -5)"
    fi
fi

# tracelog: testdata/cg68k/tickprobe.cla built WITHOUT --capture calls
# app.writeLog("out") + app.trace(true) itself -- the production UI trace
# (the same boot mactest/snow/macresident makes of the on-Mac-compiled
# TickProbe). Its out must hold the trace lines and no capture markers.
prod_boot tracelog testdata/cg68k/tickprobe.cla
if [ $rc -eq 0 ]; then
    fires=$(grep -c '^T FIRE every\.' "$WORK/tracelog.raw")
    if grep -q '##CLARUS-' "$WORK/tracelog.raw"; then
        t_fail tracelog "capture markers in a production log: $(head -3 "$WORK/tracelog.raw")"
    elif ! grep -q '^T OPEN' "$WORK/tracelog.raw" || ! grep -q '^T FRONT' "$WORK/tracelog.raw"; then
        t_fail tracelog "no T OPEN/T FRONT: $(head -5 "$WORK/tracelog.raw")"
    elif [ "$fires" -lt 60 ]; then
        t_fail tracelog "only $fires T FIRE every. lines, want >= 60"
    else
        t_pass tracelog
    fi
fi

build68k --capture -o "$WORK/initpanic.bin" testdata/mactest/initpanic.cla \
    > "$WORK/emit2.log" 2>&1 \
    || die "clarusc build68k initpanic: $(tail -10 "$WORK/emit2.log")"
run_mac "$WORK/initpanic.bin" 180
if [ "$MAC_EXIT" != 3 ]; then
    t_fail initpanic "exit code $MAC_EXIT, want 3"
elif ! grep -q 'runtime error' "$WORK/cap.log"; then
    t_fail initpanic "panic text missing from the captured log: $(head -3 "$WORK/cap.log")"
else
    t_pass initpanic
fi
t_done
