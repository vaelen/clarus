#!/bin/sh
# timeout: 30m
# Real Mac serial port (SCC channel A / the modem port) emulated by Snow,
# bridged to a host TCP port -- ported from internal/mactest/
# serial_snow_test.go's TestSerialEchoOnSnow. Builds examples/serialecho.cla
# for native 68k (no --events: the REAL event loop has to pump the
# connection), boots it with --serial-bridge-a tcp:PORT, and drives the
# whole spec surface over that one connection while Snow is still running:
# the READY\r greeting, a byte-exact 0-255 sweep, a larger sustained sweep,
# then QQQ to make the guest quit itself.
. "$(dirname "$0")/../../lib.sh"
. "$(dirname "$0")/../../lib_snow.sh" || die "helper lib failed to load"
require_env CLARUS_SNOW_TESTS

DRIVE=$TOOLS/tcpdrive
[ -x "$DRIVE" ] || die "$DRIVE not built (make tools)"

emit68k -o "$WORK/SerialEcho.bin" "$ROOT/examples/serialecho.cla" > "$WORK/build.log" 2>&1 \
    || die "clarusc emit68k examples/serialecho.cla: $(tail -5 "$WORK/build.log" | tr '\n' ' ')"

snow_disk
snow_put_bin "$WORK/SerialEcho.bin" SerialEcho

# sweep256: every byte value 0-255 once, in order. The hex list through
# `xxd -r -p` is the byte-safe way to do this in POSIX sh (awk's printf
# "%c" goes via the locale's character set, so NUL and high bytes do not
# survive) -- lib_conntest.sh's conn_sweep uses the same idiom.
i=0
while [ $i -lt 256 ]; do printf '%02x' $i; i=$(( i + 1 )); done | xxd -r -p > "$WORK/sweep256"
[ "$(wc -c < "$WORK/sweep256" | tr -d ' ')" -eq 256 ] || die "sweep256 is not 256 bytes"
# sustainedSweep: 8x the 0-255 sweep, 2048 bytes -- a burst well past the
# driver's un-enlarged default receive queue.
i=0
while [ $i -lt 8 ]; do cat "$WORK/sweep256"; i=$(( i + 1 )); done > "$WORK/sustained"
[ "$(wc -c < "$WORK/sustained" | tr -d ' ')" -eq 2048 ] || die "sustained sweep is not 2048 bytes"
printf 'QQQ' > "$WORK/qqq"

PORT=$("$DRIVE" pick-port) || die "tcpdrive pick-port failed"

# The exchange, as one tcpdrive script. The greeting gets
# serialSnowDialBudget (120s -- it has to cover guest boot, 4.7-22.2s
# observed across four clean boots); every echo step after it gets
# serialSnowOpBudget (30s, also tcpdrive's own default).
cat > "$WORK/drive.txt" <<EOF
deadline 120000
expect-sub "READY\r" 4096
deadline 30000
send $WORK/sweep256
expect $WORK/sweep256
send $WORK/sustained
expect $WORK/sustained
send $WORK/qqq
expect $WORK/qqq
sleep 5000
EOF

# The done command: run the whole exchange once, record its exit status,
# and always succeed, so snow_run stops polling and quits Snow gracefully
# whether the exchange passed or diverged (a divergence is reported below
# from the recorded status, not by burning the outer bound).
cat > "$WORK/drive.sh" <<EOF
"$DRIVE" connect 127.0.0.1:$PORT --retry 120 "$WORK/drive.txt" > "$WORK/drive.log" 2>&1
echo \$? > "$WORK/drive.rc"
EOF

# serialEchoSnowTimeout: 6 min, the outer bound above the exchange's own
# internal budgets (dial 120s + greeting + two echo passes + QQQ + a 5s
# quit settle).
snow_run 360 "sh $WORK/drive.sh" --serial-bridge-a "tcp:$PORT"

if [ "$(cat "$WORK/drive.rc" 2>/dev/null)" = 0 ]; then
    t_pass serial_exchange
else
    t_fail serial_exchange "tcpdrive exit $(cat "$WORK/drive.rc" 2>/dev/null): $(tr '\n' ' ' < "$WORK/drive.log")"
fi

snow_get ":System Folder:Startup Items:out" "$WORK/out"
if grep -qF '##CLARUS-EXIT## 0' "$WORK/out"; then
    t_pass clean_exit
else
    t_fail clean_exit "app out missing clean exit trailer: $(tr '\n' ' ' < "$WORK/out")"
fi

t_done
