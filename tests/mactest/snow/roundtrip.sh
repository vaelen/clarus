#!/bin/sh
# timeout: 25m
# Snow file round-trip -- ported from internal/mactest/snow_test.go's
# TestSnowRoundTrip: the Snow harness's own foundation self-test. Plant a
# marker file at the volume root, install the roundtrip fixture into
# Startup Items, boot, let it self-launch/read/write/quit, quit Snow, and
# check everything that came back out.
. "$(dirname "$0")/../../lib.sh"
. "$(dirname "$0")/../../lib_snow.sh" || die "helper lib failed to load"
require_env CLARUS_SNOW_TESTS

BIN=$ROOT/build-68k/SnowRoundTrip/SnowRoundTrip.bin
"$ROOT/scripts/build-68k.sh" testdata/snow/roundtrip.cla > "$WORK/build.log" 2>&1 \
    || die "build-68k.sh testdata/snow/roundtrip.cla: $(tail -5 "$WORK/build.log" | tr '\n' ' ')"
[ -f "$BIN" ] || die "$BIN not built"

printf 'Snow round-trip marker: %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)-$$" > "$WORK/Marker.txt"

snow_disk
snow_put "$WORK/Marker.txt" Marker.txt
snow_put_bin "$BIN" SnowRoundTrip

# snowRoundTripSettle: 30s, a generous multiple of the fixture's own work
# (open a window, two file ops, quit), not a measured minimum.
snow_run 180 "$(snow_settle_done 30)"

snow_get Copy.txt "$WORK/Copy.txt"
if cmp -s "$WORK/Copy.txt" "$WORK/Marker.txt"; then
    t_pass copy_byte_exact
else
    t_fail copy_byte_exact "Copy.txt mismatch: want $(cat "$WORK/Marker.txt"), got $(cat "$WORK/Copy.txt")"
fi

snow_get ":System Folder:Startup Items:out" "$WORK/out"
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
