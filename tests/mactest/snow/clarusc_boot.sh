#!/bin/sh
# timeout: 25m
# ClarusC.APPL native boot smoke -- ported from internal/mactest/
# clarusc_boot_test.go's TestClarusCBootOnSnow. Builds the Mac-resident
# compiler's GUI front end with a single scripted "quit" baked in,
# installs it into Startup Items, boots Snow, and checks the captured
# trace for a window-open line and a clean exit. Snow, not Mini vMac:
# ClarusC.APPL's SIZE(-1) partition does not fit a 4MB Mac Plus.
. "$(dirname "$0")/../../lib.sh"
. "$(dirname "$0")/../../lib_snow.sh" || die "helper lib failed to load"
require_env CLARUS_SNOW_TESTS

BIN=$ROOT/build-68k/ClarusC/ClarusC.bin
EVENTS=$ROOT/testdata/mac-resident/clarusc-boot.events
"$ROOT/scripts/build-clarusc-mac.sh" --events "$EVENTS" > "$WORK/build.log" 2>&1 \
    || die "build-clarusc-mac.sh --events $EVENTS: $(tail -5 "$WORK/build.log" | tr '\n' ' ')"
[ -f "$BIN" ] || die "$BIN not built"

snow_disk
snow_put_bin "$BIN" ClarusC

# clarusCBootSettle: 45s (raised from 20s -- a 48MB SIZE(-1) partition
# takes the Process Manager measurably longer to zone/launch, and `done`
# is a pure elapsed-time heuristic with no real completion signal).
snow_run 180 "$(snow_settle_done 45)"

snow_get ":System Folder:Startup Items:out" "$WORK/out"
out_has() {
    if grep -qF "$2" "$WORK/out"; then
        t_pass "$1"
    else
        t_fail "$1" "app out missing \"$2\": $(tr '\n' ' ' < "$WORK/out")"
    fi
}
out_has window_open 'T OPEN Log'
out_has clean_exit '##CLARUS-EXIT## 0'

t_done
