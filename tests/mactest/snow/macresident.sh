#!/bin/sh
# timeout: 180m
# The Mac-resident compiler's acceptance evidence -- ported from
# internal/mactest/macresident_test.go's TestMacResidentClaruscOnSnow.
# ClarusC.APPL compiles tickprobe.cla and then catprobe.cla ON the emulated
# Mac; each produced .APPL must be byte-identical (resource fork, reserved
# span excluded) to the host compiler's own output for the same source --
# the strongest oracle available. catprobe.cla additionally proves an
# `include` of a toolbox/ catalog file resolves via the baked 'CLFS'
# resource fallback: toolbox/osutils.cla is deliberately NEVER staged on
# the volume.
#
# Wall clock: the default settle is 110 minutes, and the Go test's own doc
# comment records that this is NOT enough to finish both compiles on real
# (emulated) hardware -- "on the order of TEN HOURS ... at ~7x
# fast-forward". Set CLARUS_MACRESIDENT_SETTLE=12h (and expect this
# script's own `# timeout:` header to need raising to match) for a run
# actually meant to reach the byte-compare; CLARUS_MACRESIDENT_DONE names
# a marker file an operator watching the emulator can create to end the
# settle the moment the scripted `quit` visibly lands.
. "$(dirname "$0")/../../lib.sh"
. "$(dirname "$0")/../../lib_snow.sh" || die "helper lib failed to load"
require_env CLARUS_SNOW_TESTS

TICK=$ROOT/testdata/cg68k/tickprobe.cla
CATP=$ROOT/testdata/mac-resident/catprobe.cla
EVENTS=$ROOT/testdata/mac-resident/clarusc.events
BIN=$ROOT/build-68k/ClarusC/ClarusC.bin

# Host oracles first (current-source compiler, no flags).
snow_oracle "$TICK" "$WORK/tick-oracle.bin"
snow_oracle "$CATP" "$WORK/cat-oracle.bin"

"$ROOT/scripts/build-clarusc-mac.sh" --events "$EVENTS" > "$WORK/build.log" 2>&1 \
    || die "build-clarusc-mac.sh --events $EVENTS: $(tail -5 "$WORK/build.log" | tr '\n' ' ')"
[ -f "$BIN" ] || die "$BIN not built"

snow_disk
snow_put_bin "$BIN" ClarusC
snow_put "$TICK" tickprobe.cla
snow_put "$CATP" catprobe.cla

SETTLE=$(settle_seconds "${CLARUS_MACRESIDENT_SETTLE:-110m}")
DONE=$(snow_settle_done "$SETTLE")
if [ -n "${CLARUS_MACRESIDENT_DONE:-}" ]; then
    DONE="$DONE || test -e \"$CLARUS_MACRESIDENT_DONE\""
fi
# 20-minute headroom above the settle: runSnow's timeout is a hard kill,
# the settle is when the poll loop decides to quit Snow, so the two must
# never be equal.
snow_run $(( SETTLE + 1200 )) "$DONE"

snow_get ":System Folder:Startup Items:out" "$WORK/out"
echo "--- app out ($(wc -c < "$WORK/out" | tr -d ' ') bytes)"
cat "$WORK/out"
echo "--- end app out"

fire=$(snow_count 'T FIRE File.Compile.select' "$WORK/out")
ask=$(snow_count 'T ASKOPEN :::' "$WORK/out")
if [ "$fire" != 2 ] || [ "$ask" != 2 ]; then
    t_fail dispatches "want 2 Compile.select dispatches + 2 real askOpen answers, got $fire/$ask (the settle window most likely expired before both compiles finished)"
    t_done
fi
t_pass dispatches

snow_no_error_markers no_error_markers "$WORK/out"

if grep -qF '##CLARUS-EXIT## 0' "$WORK/out"; then
    t_pass clean_exit
else
    t_fail clean_exit "app out missing clean exit trailer (both compiles may not have finished within the settle window)"
fi

# gcCompile writes the compiled app with a BARE name and natWriteRes pokes
# no ioDirID, so the landing directory is not a sure thing -- try both.
snow_extract_app TickProbe "$WORK/TickProbe.bin" \
    || { t_fail extract_tickprobe "TickProbe not found at any candidate location (raise CLARUS_MACRESIDENT_SETTLE if both listings look like an untouched boot disk)"; t_done; }
snow_extract_app CatProbe "$WORK/CatProbe.bin" \
    || { t_fail extract_catprobe "CatProbe not found at any candidate location (raise CLARUS_MACRESIDENT_SETTLE if both listings look like an untouched boot disk)"; t_done; }

if snow_fork_same TickProbe "$WORK/TickProbe.bin" "$WORK/tick-oracle.bin"; then
    t_pass tickprobe_fork_identity
else
    t_fail tickprobe_fork_identity "on-Mac TickProbe fork differs from the host oracle (see the dump above)"
fi
if snow_fork_same CatProbe "$WORK/CatProbe.bin" "$WORK/cat-oracle.bin"; then
    t_pass catprobe_fork_identity
else
    t_fail catprobe_fork_identity "on-Mac CatProbe fork differs from the host oracle (see the dump above)"
fi

# Launchable-app proof: TickProbe, the on-Mac-produced app, booted
# standalone on a FRESH disk with no --events (the real, non-scripted
# rtUiRun/UiTickCount event loop) -- proof the byte-identity check isn't
# comparing two equally broken outputs. macResidentLaunchSettle: 30s.
snow_disk
snow_put_bin "$WORK/TickProbe.bin" TickProbe
snow_run 180 "$(snow_settle_done 30)"

snow_get ":System Folder:Startup Items:out" "$WORK/tickout"
if grep -qF 'T OPEN' "$WORK/tickout"; then
    t_pass tickprobe_window_open
else
    t_fail tickprobe_window_open "TickProbe out missing window-open trace: $(tr '\n' ' ' < "$WORK/tickout")"
fi
if grep -qF 'T FRONT' "$WORK/tickout"; then
    t_pass tickprobe_window_front
else
    t_fail tickprobe_window_front "TickProbe out missing window-front trace: $(tr '\n' ' ' < "$WORK/tickout")"
fi
ticks=$(snow_count 'T FIRE every.' "$WORK/tickout")
if [ "$ticks" -ge 60 ]; then
    t_pass tickprobe_real_ticks
else
    t_fail tickprobe_real_ticks "TickProbe out has only $ticks \"T FIRE every.\" lines, want >= 60 (real-tick event loop)"
fi

t_done
