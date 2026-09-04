#!/bin/sh
# timeout: 25m
# examples/pagefile.cla (a vDB-shaped page-store demo) over Snow's emulated
# serial port -- ported from internal/mactest/pagefile_snow_test.go's
# TestPageFileOnSnow. Same scratch-workspace clone, --serial-bridge-a
# wiring and dial-with-retry as serial_echo.sh; the only added step is
# reading pagefile's one CR-terminated result line, which must be exactly
# "PASS 16".
. "$(dirname "$0")/../../lib.sh" || exit 2
. "$(dirname "$0")/../../lib_snow.sh" || die "helper lib failed to load"
require_env CLARUS_SNOW_TESTS

DRIVE=$TOOLS/tcpdrive
[ -x "$DRIVE" ] || die "$DRIVE not built (make tools)"

emit68k -o "$WORK/PageFile.bin" "$ROOT/examples/pagefile.cla" > "$WORK/build.log" 2>&1 \
    || die "clarusc emit68k examples/pagefile.cla: $(tail -5 "$WORK/build.log" | tr '\n' ' ')"

snow_disk
snow_put_bin "$WORK/PageFile.bin" PageFile

PORT=$("$DRIVE" pick-port) || die "tcpdrive pick-port failed"

# One result line, CR-terminated (Clarus's `\n` escape emits CR, the Mac
# newline). expect-sub tolerates the leading noise byte Snow's bridge
# emits on a freshly launched bridge's first client connection, so this is
# the same "scan a capped window for the substring" tolerance
# readResultLine applies. pageFileResultBudget (120s) has to cover guest
# boot PLUS the whole 16-page write-ahead-journal pass inside App.launch
# (~27s observed end to end), so the step gets that as its read deadline.
cat > "$WORK/drive.txt" <<EOF
deadline 120000
expect-sub "PASS 16\r" 4096
sleep 5000
EOF

cat > "$WORK/drive.sh" <<EOF
"$DRIVE" connect 127.0.0.1:$PORT --retry 120 "$WORK/drive.txt" > "$WORK/drive.log" 2>&1
echo \$? > "$WORK/drive.rc"
EOF

# pageFileSnowTimeout: 4 min.
snow_run 240 "sh $WORK/drive.sh" --serial-bridge-a "tcp:$PORT"

if [ "$(cat "$WORK/drive.rc" 2>/dev/null)" = 0 ]; then
    t_pass result_line_pass_16
else
    t_fail result_line_pass_16 "want the result line \"PASS 16\"; tcpdrive exit $(cat "$WORK/drive.rc" 2>/dev/null): $(tr '\n' ' ' < "$WORK/drive.log")"
fi

snow_get ":System Folder:Startup Items:out" "$WORK/out"
if grep -qF '##CLARUS-EXIT## 0' "$WORK/out"; then
    t_pass clean_exit
else
    t_fail clean_exit "app out missing clean exit trailer: $(tr '\n' ' ' < "$WORK/out")"
fi

t_done
