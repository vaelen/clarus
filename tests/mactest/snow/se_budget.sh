#!/bin/sh
# timeout: 15m
# SE memory program Wave 0: measure the single-app memory budget on the
# Snow SE (4 MB, System 6.0.8; boot-block autostart, no MultiFinder).
# Prints the raw probe line plus derived numbers; asserts only that the
# probe ran. The numbers are recorded in the SE program's design doc §9.
. "$(dirname "$0")/../../lib.sh" || exit 2
. "$(dirname "$0")/../../lib_snow.sh" || die "helper lib failed to load"
require_env CLARUS_SNOW_TESTS
SNOW_SYSTEM=6
export SNOW_SYSTEM

BIN=$ROOT/build-68k/SeBudget/SeBudget.bin
"$ROOT/scripts/build-68k.sh" testdata/snow/sebudget.cla > "$WORK/build.log" 2>&1 \
    || die "build-68k.sh testdata/snow/sebudget.cla: $(tail -5 "$WORK/build.log" | tr '\n' ' ')"
[ -f "$BIN" ] || die "$BIN not built"

snow_disk 6
snow_put_bin "$BIN" SeBudget
snow_run 300 "$(snow_done_when_trailer 10)"
snow_get "${SNOW_APPDIR}out" "$WORK/out"
cat "$WORK/out"

line=$(grep '^SEBUDGET ' "$WORK/out")
if [ -n "$line" ]; then t_pass probe_ran; else t_fail probe_ran "no SEBUDGET line in out"; fi
grep -qF '##CLARUS-EXIT## 0' "$WORK/out" && t_pass clean_exit || t_fail clean_exit "no clean exit trailer"

val() { echo "$line" | tr ' ' '\n' | sed -n "s/^$1=//p"; }
if [ -n "$line" ]; then
    free=$(val FreeMem); zone=$(val ApplZone); buf=$(val BufPtr)
    echo "SE budget: FreeMem=$free bytes ($((free / 1024)) KB); app space BufPtr-ApplZone=$((buf - zone)) bytes ($(((buf - zone) / 1024)) KB)"
fi
t_done
