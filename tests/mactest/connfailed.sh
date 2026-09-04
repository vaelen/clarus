#!/bin/sh
# timeout: 20m
# mactest/connfailed -- port of internal/mactest/native_test.go's
# TestConnFailedHandlerOn68k: the regression pin for the cg68k KErr
# call-argument ABI fix. testdata/cg68k/connfailprobe.cla opens serial
# "modem:99" (not one of the Serial Driver's eleven standard baud rates),
# so `on conn.failed(err: error)` fires on the first scripted pump pass and
# alert()s err.message -- which must be EXACTLY conn.cla's own "invalid
# connection spec" text, not whatever garbage a stale
# LEA-instead-of-MOVEA read would produce.
. "$(dirname "$0")/../lib.sh"
. "$(dirname "$0")/../lib_mac.sh"
require_env CLARUS_MAC_TESTS

emit68k -o "$WORK/connfailprobe.bin" \
    --events testdata/cg68k/connfailprobe.events \
    testdata/cg68k/connfailprobe.cla > "$WORK/emit.log" 2>&1 \
    || die "clarusc emit68k connfailprobe: $(tail -10 "$WORK/emit.log")"

run_mac "$WORK/connfailprobe.bin" 180
if [ "$MAC_EXIT" != 0 ]; then
    t_fail connfailed "connfailprobe exit code $MAC_EXIT, want 0: $(cat "$WORK/cap.out")"
elif ! grep -qF 'invalid connection spec' "$WORK/cap.out"; then
    t_fail connfailed "trace missing \"invalid connection spec\" (KErr call-arg ABI regression -- got garbage or nothing instead): $(cat "$WORK/cap.out")"
else
    t_pass connfailed
fi
t_done
