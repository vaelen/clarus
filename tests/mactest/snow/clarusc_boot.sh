#!/bin/sh
# timeout: 25m
# ClarusC.APPL native boot smoke -- ported from internal/mactest/
# clarusc_boot_test.go's TestClarusCBootOnSnow. Builds the Mac-resident
# compiler's GUI front end with a single scripted "quit" baked in,
# installs it into Startup Items, boots Snow, and checks the captured
# trace for a window-open line and a clean exit. Runs on the System 6 SE
# only (Linux emulator port, 2026-09-27): there the app is the boot
# blocks' startup program with no MultiFinder, so its 48MB SIZE(-1)
# partition is ignored and it gets the whole 4MB -- enough to open the
# window and quit (measured PASS), though not for a compile (see
# snow_skip_clarusc). Under System 7's Process Manager the partition does
# not fit a 4MB machine.
. "$(dirname "$0")/../../lib.sh" || exit 2
. "$(dirname "$0")/../../lib_snow.sh" || die "helper lib failed to load"
require_env CLARUS_SNOW_TESTS
[ "${SNOW_SYSTEM:-6}" = 6 ] || snow_skip_clarusc

BIN=$ROOT/build-68k/ClarusC/ClarusC.bin
EVENTS=$ROOT/testdata/mac-resident/clarusc-boot.events
"$ROOT/scripts/build-clarusc-mac.sh" --events "$EVENTS" > "$WORK/build.log" 2>&1 \
    || die "build-clarusc-mac.sh --events $EVENTS: $(tail -5 "$WORK/build.log" | tr '\n' ' ')"
[ -f "$BIN" ] || die "$BIN not built"

snow_disk
snow_put_bin "$BIN" ClarusC

# clarusCBootSettle: 45s (raised from 20s -- a 48MB SIZE(-1) partition
# takes the Process Manager measurably longer to zone/launch). A timer,
# not snow_done_when_trailer: this guest does quit, but the whole settle
# is shorter than that probe's own 30s flush hold, so the probe could only
# make this boot slower.
snow_run 180 "$(snow_settle_done 45)"

snow_get "${SNOW_APPDIR}out" "$WORK/out"
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
