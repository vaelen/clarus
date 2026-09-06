#!/bin/sh
# timeout: 100m
# The baked-'CLIR' path on real hardware -- ported from internal/mactest/
# clarusc_bake_test.go's TestClarusCBakePathOnSnow. Builds ClarusC.APPL with
# the CLIR resource baked in (build-clarusc-mac.sh's default), boots it with
# ONE scripted compile of tickprobe.cla, and requires the trace to name the
# BAKE path specifically (never the CLFS-source fallback) and the produced
# app to be byte-identical to the host compiler's own output.
#
# The boot ends on a real completion probe, not a timer: snow_run quits
# Snow once the ##CLARUS-EXIT## trailer has been visible in the live disk
# image for 30s (snow_done_when_trailer). CLARUS_MACRESIDENT_SETTLE (55m
# by default, the same env var macresident.sh reads) is now only the base
# of the CEILING -- settle+20m -- at which a guest that never writes a
# trailer is given up on; raise it if the emulated compile itself needs
# longer than that.
. "$(dirname "$0")/../../lib.sh" || exit 2
. "$(dirname "$0")/../../lib_snow.sh" || die "helper lib failed to load"
require_env CLARUS_SNOW_TESTS

TICK=$ROOT/testdata/cg68k/tickprobe.cla
EVENTS=$ROOT/testdata/mac-resident/clarusc-bake-single.events
BIN=$ROOT/build-68k/ClarusC/ClarusC.bin

snow_oracle "$TICK" "$WORK/tick-oracle.bin"

"$ROOT/scripts/build-clarusc-mac.sh" --events "$EVENTS" > "$WORK/build.log" 2>&1 \
    || die "build-clarusc-mac.sh --events $EVENTS: $(tail -5 "$WORK/build.log" | tr '\n' ' ')"
[ -f "$BIN" ] || die "$BIN not built"

snow_disk
snow_put_bin "$BIN" ClarusC
snow_put "$TICK" tickprobe.cla

SETTLE=$(settle_seconds "${CLARUS_MACRESIDENT_SETTLE:-55m}")
snow_run $(( SETTLE + 1200 )) "$(snow_done_when_trailer 30)"

snow_get ":System Folder:Startup Items:out" "$WORK/out"
echo "--- app out ($(wc -c < "$WORK/out" | tr -d ' ') bytes)"
cat "$WORK/out"
echo "--- end app out"

# The compile must have taken the BAKE path, not silently fallen back to
# CLFS-source (what a stamp/version/lane mismatch would do invisibly).
if grep -qF 'clarusc: bake path (CLIR resource)' "$WORK/out"; then
    t_pass bake_path_taken
else
    t_fail bake_path_taken "bake path not taken -- want gcResolveBakePath's log() line \"clarusc: bake path (CLIR resource)\" in the captured trace"
fi
if grep -qF 'CLFS-source fallback' "$WORK/out"; then
    t_fail no_clfs_fallback "compile fell back to CLFS-source (want the bake path)"
else
    t_pass no_clfs_fallback
fi

fire=$(snow_count 'T FIRE File.Compile.select' "$WORK/out")
ask=$(snow_count 'T ASKOPEN :::' "$WORK/out")
if [ "$fire" != 1 ] || [ "$ask" != 1 ]; then
    t_fail dispatches "want 1 Compile.select dispatch + 1 real askOpen answer, got $fire/$ask"
    t_done
fi
t_pass dispatches

snow_no_error_markers no_error_markers "$WORK/out"

if grep -qF '##CLARUS-EXIT## 0' "$WORK/out"; then
    t_pass clean_exit
else
    t_fail clean_exit "app out missing clean exit trailer (settle window may be too short)"
fi

snow_extract_app TickProbe "$WORK/TickProbe.bin" \
    || { t_fail extract_tickprobe "TickProbe not found at any candidate location (raise CLARUS_MACRESIDENT_SETTLE if both listings look like an untouched boot disk)"; t_done; }
if snow_fork_same TickProbe "$WORK/TickProbe.bin" "$WORK/tick-oracle.bin"; then
    t_pass tickprobe_fork_identity
else
    t_fail tickprobe_fork_identity "on-Mac TickProbe fork differs from the host oracle (see the dump above)"
fi

t_done
