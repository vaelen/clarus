#!/bin/sh
# timeout: 100m
# SE memory program Wave 5 close test: ClarusC.APPL, on the Snow SE by
# default (SNOW_SYSTEM=7 for the IIcx), compiles a program whose one
# expression nests 20000 parentheses deep. The parser's depth guard must
# turn that into the ordinary diagnostic `source too deeply nested` and
# the app must then quit normally (`##CLARUS-EXIT## 0`) -- never a stack
# overflow crash or a hang (snow_run's ceiling plus the trailer check).
# 20000 levels exhausts even a ~20-byte-per-level parse chain in 320 KB of
# stack. If the guard does not fire, raise DEPTH -- but also check for
# the other failure modes: the lexer running out of memory on the long
# token stream first, or the app's out log filling (natLogCap) before the
# diagnostic is written.
#
# Needs Wave 5 Task 3's guard (the diagnostic) and Task 1's disk mount
# (the SE compile reads deep.cla from the Clarus volume), so it passes
# meaningfully only once both are merged.
. "$(dirname "$0")/../../lib.sh" || exit 2
. "$(dirname "$0")/../../lib_snow.sh" || die "helper lib failed to load"
require_env CLARUS_SNOW_TESTS
snow_clarusc_system

DEPTH=20000
EVENTS=$ROOT/testdata/mac-resident/clarusc-deep.events
BIN=$ROOT/build-68k/ClarusC/ClarusC.bin

awk -v d=$DEPTH 'BEGIN {
    printf "on App.launch {\n    var x: int\n    x = "
    for (i = 0; i < d; i++) printf "("
    printf "1"
    for (i = 0; i < d; i++) printf ")"
    printf "\n}\n"
}' > "$WORK/deep.cla" || die "generate deep.cla"

"$ROOT/scripts/build-clarusc-mac.sh" --events "$EVENTS" > "$WORK/build.log" 2>&1 \
    || die "build-clarusc-mac.sh --events $EVENTS: $(tail -5 "$WORK/build.log" | tr '\n' ' ')"
[ -f "$BIN" ] || die "$BIN not built"

snow_disk
snow_put_bin "$BIN" ClarusC
snow_put "$WORK/deep.cla" deep.cla

SETTLE=$(settle_seconds "${CLARUS_MACRESIDENT_SETTLE:-55m}")
snow_run $(( SETTLE + 1200 )) "$(snow_done_when_trailer 30)"

snow_get "${SNOW_APPDIR}out" "$WORK/out"
echo "--- app out ($(wc -c < "$WORK/out" | tr -d ' ') bytes)"
cat "$WORK/out"
echo "--- end app out"

grep -qF 'source too deeply nested' "$WORK/out" && t_pass nested_diag \
    || t_fail nested_diag "app out missing 'source too deeply nested'"
grep -qF '##CLARUS-EXIT## 0' "$WORK/out" && t_pass clean_exit \
    || t_fail clean_exit "no clean exit trailer (crash or hang)"
t_done
