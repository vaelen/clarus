#!/bin/sh
# timeout: 25m
# Snow file round-trip -- ported from internal/mactest/snow_test.go's
# TestSnowRoundTrip: the Snow harness's own foundation self-test. Plant a
# marker file at the root of the scratch "Clarus" volume, install the
# roundtrip fixture as the self-launching app (snow_put_bin), boot, let it
# read/write/quit, quit Snow, and check everything that came back out.
# SNOW_SYSTEM=7 runs it on the System 7.1 machine instead of System 6.
. "$(dirname "$0")/../../lib.sh" || exit 2
. "$(dirname "$0")/../../lib_snow.sh" || die "helper lib failed to load"
require_env CLARUS_SNOW_TESTS

BIN=$ROOT/build-68k/SnowRoundTrip/SnowRoundTrip.bin
"$ROOT/scripts/build-68k.sh" testdata/snow/roundtrip.cla --capture > "$WORK/build.log" 2>&1 \
    || die "build-68k.sh testdata/snow/roundtrip.cla: $(tail -5 "$WORK/build.log" | tr '\n' ' ')"
[ -f "$BIN" ] || die "$BIN not built"

printf 'Snow round-trip marker: %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)-$$" > "$WORK/Marker.txt"

snow_disk
snow_put "$WORK/Marker.txt" Marker.txt
snow_put_bin "$BIN" SnowRoundTrip

# The guest quits itself once the round trip is done (it retries the read
# for up to 20 s while the Clarus volume mounts), so end on its exit
# trailer reaching the host image, held 10 s for the Copy.txt/catalog
# flush; 180 s is only the ceiling.
snow_run 180 "$(snow_done_when_trailer 10)"

snow_get Copy.txt "$WORK/Copy.txt" "$SNOW_CLARUS_IMG"
if cmp -s "$WORK/Copy.txt" "$WORK/Marker.txt"; then
    t_pass copy_byte_exact
else
    t_fail copy_byte_exact "Copy.txt mismatch: want $(cat "$WORK/Marker.txt"), got $(cat "$WORK/Copy.txt")"
fi

snow_get "${SNOW_APPDIR}out" "$WORK/out"
out_has() {
    if grep -qF "$2" "$WORK/out"; then
        t_pass "$1"
    else
        t_fail "$1" "app out missing \"$2\": $(tr '\n' ' ' < "$WORK/out")"
    fi
}
out_has read_ok 'read ok'
out_has write_ok 'write ok'
out_has clean_exit '##CLARUS-EXIT## 0'

t_done
