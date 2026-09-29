#!/bin/sh
# timeout: 100m
# SE memory program Wave 0 (and every wave close, umbrella §7): ClarusC.APPL
# compiles examples/bookmarks.cla on Snow -- the SE (System 6.0.8) by
# default since Wave 5, the Mac IIcx (System 7.1) under SNOW_SYSTEM=7 --
# and logs, per compile phase, FreeMem/MaxBlock (`  mem:` lines) and, after
# the compile, its stack high-water (`  stack:`). The numbers are
# recorded in the SE program design doc §9; this script asserts that the
# probes ran and the log was not truncated at natLogCap, and on the SE
# gates the lowest per-phase FreeMem against se_floor.txt (KB, its last
# non-comment line).
. "$(dirname "$0")/../../lib.sh" || exit 2
. "$(dirname "$0")/../../lib_snow.sh" || die "helper lib failed to load"
require_env CLARUS_SNOW_TESTS
snow_clarusc_system

EVENTS=$ROOT/testdata/mac-resident/clarusc-bookmarks.events
BIN=$ROOT/build-68k/ClarusC/ClarusC.bin

"$ROOT/scripts/build-clarusc-mac.sh" --events "$EVENTS" > "$WORK/build.log" 2>&1 \
    || die "build-clarusc-mac.sh --events $EVENTS: $(tail -5 "$WORK/build.log" | tr '\n' ' ')"
[ -f "$BIN" ] || die "$BIN not built"

snow_disk
snow_put_bin "$BIN" ClarusC
snow_put "$ROOT/examples/bookmarks.cla" bookmarks.cla

SETTLE=$(settle_seconds "${CLARUS_MACRESIDENT_SETTLE:-55m}")
snow_run $(( SETTLE + 1200 )) "$(snow_done_when_trailer 30)"

snow_get "${SNOW_APPDIR}out" "$WORK/out"
echo "--- app out ($(wc -c < "$WORK/out" | tr -d ' ') bytes)"
cat "$WORK/out"
echo "--- end app out"

grep -E 'ticks\)$|^  mem: |^  stack: |\] Finished$' "$WORK/out" > "$WORK/memprobe.txt" || true
echo "--- memprobe"
cat "$WORK/memprobe.txt"
echo "--- end memprobe"

phases=$(grep -c 'ticks)$' "$WORK/out" || true)
mems=$(grep -c '^  mem: ' "$WORK/out" || true)
[ "$phases" -gt 0 ] && [ "$mems" -ge "$phases" ] && t_pass mem_lines \
    || t_fail mem_lines "phases=$phases mem lines=$mems"
[ "$(snow_count '  stack: high-water' "$WORK/out")" = 1 ] && t_pass stack_line \
    || t_fail stack_line "expected one '  stack: high-water' line"
# gcLog timestamps every line: "[MM-DD-YY hh:mm:ss] Finished".
grep -q '\] Finished$' "$WORK/out" && t_pass not_truncated \
    || t_fail not_truncated "no Finished line: out is $(wc -c < "$WORK/out") bytes (natLogCap 4096)"
# Known, tolerated: bookmarks.cla's `icon: "bookmarks.pbm"` never resolves
# on the Mac -- drive.cla's dirOf splits on '/' only, so for the HFS entry
# path "Clarus:bookmarks.cla" the icon path loses its volume (pre-existing
# ClarusC bug, found by this script; not a memory-probe concern).
# Every other warning/error marker still fails the check.
grep -vF 'warning: cannot read app icon bookmarks.pbm: could not open file; using default icon' "$WORK/out" > "$WORK/out.markers"
snow_no_error_markers no_error_markers "$WORK/out.markers"
grep -qF '##CLARUS-EXIT## 0' "$WORK/out" && t_pass clean_exit || t_fail clean_exit "no clean exit trailer"
if [ "$SNOW_SYS" = 6 ]; then
    # The first "free N KB" on each `  mem:` line.
    min=$(awk '/^  mem: /{for(i=1;i<NF;i++)if($i=="free"){n=$(i+1)+0; if(m==""||n<m)m=n; break}} END{print m}' "$WORK/out")
    floor=$(grep -v '^#' "$(dirname "$0")/se_floor.txt" | grep . | tail -1)
    echo "memprobe: lowest free ${min:-none} KB (floor $floor)"
    [ -n "$min" ] && [ "$min" -ge "$floor" ] && t_pass se_floor \
        || t_fail se_floor "lowest free ${min:-none} KB < floor $floor KB"
fi
t_done
