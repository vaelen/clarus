#!/bin/sh
# timeout: 180m
# "A failing compile leaves ClarusC.APPL alive" -- ported from
# internal/mactest/macresident_test.go's
# TestMacResidentFailedCompileStaysAliveOnSnow. One Snow session, two
# scripted compiles: badabort.cla trips a real, user-reachable abort()
# site inside cg68k's native backend (gcCompile's `attempt ... aborted msg`
# wrap must catch it -- alert text in the trace, no ExitToShell), then
# tickprobe.cla compiles successfully in the SAME session and its produced
# app is byte-compared against the host oracle.
#
# Same wall-clock caveat as macresident.sh: the 110-minute default settle
# is not enough to finish both compiles on emulated hardware; set
# CLARUS_MACRESIDENT_SETTLE (and CLARUS_MACRESIDENT_DONE) for a run meant
# to reach the byte-compare.
. "$(dirname "$0")/../../lib.sh"
. "$(dirname "$0")/../../lib_snow.sh" || die "helper lib failed to load"
require_env CLARUS_SNOW_TESTS

BAD=$ROOT/testdata/mac-resident/badabort.cla
TICK=$ROOT/testdata/cg68k/tickprobe.cla
EVENTS=$ROOT/testdata/mac-resident/badabort.events
BIN=$ROOT/build-68k/ClarusC/ClarusC.bin

# badAbortMessage: the exact abort() message cgAttemptStmt emits when an
# abort-enabled program nests `attempt` past cgBailTargets' fixed depth.
ABORTMSG="cg68k: attempt nesting exceeds cgBailTargets' fixed depth (32)"

# Host oracle for the SECOND (successful) compile only -- the first is
# expected to fail on-Mac too, by construction of badabort.cla.
snow_oracle "$TICK" "$WORK/tick-oracle.bin"

"$ROOT/scripts/build-clarusc-mac.sh" --events "$EVENTS" > "$WORK/build.log" 2>&1 \
    || die "build-clarusc-mac.sh --events $EVENTS: $(tail -5 "$WORK/build.log" | tr '\n' ' ')"
[ -f "$BIN" ] || die "$BIN not built"

snow_disk
snow_put_bin "$BIN" ClarusC
snow_put "$BAD" badabort.cla
snow_put "$TICK" tickprobe.cla

SETTLE=$(settle_seconds "${CLARUS_MACRESIDENT_SETTLE:-110m}")
DONE=$(snow_settle_done "$SETTLE")
if [ -n "${CLARUS_MACRESIDENT_DONE:-}" ]; then
    DONE="$DONE || test -e \"$CLARUS_MACRESIDENT_DONE\""
fi
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

# The core assertion: the abort's own message reached the trace via
# gcCompile's aborted-block + rtUiAlertMsg -- proof the abort was CAUGHT,
# not left to the synthesized top-level default (which would quit the app,
# the exact pre-fix field defect).
if grep -qF "$ABORTMSG" "$WORK/out"; then
    t_pass caught_abort_alert
else
    t_fail caught_abort_alert "app out missing the caught abort's own alert text (\"$ABORTMSG\") -- gcCompile's aborted-block may not have fired"
fi

# Exactly one exit trailer, from the script's own final `quit` -- never one
# right after the failed compile.
exits=$(snow_count '##CLARUS-EXIT##' "$WORK/out")
if [ "$exits" = 1 ]; then
    t_pass one_exit_trailer
else
    t_fail one_exit_trailer "app out has $exits ##CLARUS-EXIT## trailers, want exactly 1 (a premature one would mean the failed compile killed the app)"
fi
if grep -qF '##CLARUS-EXIT## 0' "$WORK/out"; then
    t_pass clean_exit
else
    t_fail clean_exit "app out missing the clean exit trailer (##CLARUS-EXIT## 0) from the script's own final quit"
fi

# clir-load-perf design B: the CLIR resource is read/verified/parsed at
# most ONCE per app session (bkParsedValid), so gcResolveBakePath's own
# pre-parse Status-bar announcement must appear exactly once across the
# whole two-compile session. The "(Step" suffix is unique to
# feProgressStep's rendering, which distinguishes it from the log()
# trailer copy of the same words.
loads=$(snow_count 'Loading Baked Runtime (Step' "$WORK/out")
if [ "$loads" = 1 ]; then
    t_pass one_bake_load
else
    t_fail one_bake_load "app out has $loads \"Loading Baked Runtime\" stage lines, want exactly 1 (compile #2 should skip the reload via bkParsedValid)"
fi

# The second, successful compile must have produced a real, byte-correct
# app -- not just "the app didn't crash".
snow_extract_app TickProbe "$WORK/TickProbe.bin" \
    || { t_fail extract_tickprobe "TickProbe not found at any candidate location (raise CLARUS_MACRESIDENT_SETTLE if both listings look like an untouched boot disk)"; t_done; }
if snow_fork_same TickProbe "$WORK/TickProbe.bin" "$WORK/tick-oracle.bin"; then
    t_pass tickprobe_fork_identity
else
    t_fail tickprobe_fork_identity "on-Mac TickProbe fork differs from the host oracle (see the dump above)"
fi

t_done
