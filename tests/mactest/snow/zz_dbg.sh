#!/bin/sh
. "$(dirname "$0")/../../lib.sh" || exit 2
. "$(dirname "$0")/../../lib_snow.sh" || die "helper lib failed to load"
BIN=$ROOT/build-68k/SnowRoundTrip/SnowRoundTrip.bin
printf 'marker\n' > "$WORK/Marker.txt"
snow_disk ${SYS:-6}
snow_put "$WORK/Marker.txt" Marker.txt
snow_put_bin "$BIN" SnowRoundTrip
( i=0; while [ $i -lt 12 ]; do sleep 5; i=$((i+1)); w=$(xwininfo -root -tree | grep -a '"Snow.*scratch' | grep -a -v mutter | awk '{print $1}' | head -1); [ -n "$w" ] && import -window $w /tmp/claude-1000/-home-andrew-repos-clarus/7e2ed503-f96b-496c-ac23-d2cfcccb4a36/scratchpad/shot$i.png 2>/dev/null; done ) &
snow_run ${SECS:-60} "$(snow_settle_done ${SETTLE:-55})"
cp "$SNOW_IMG" /tmp/claude-1000/-home-andrew-repos-clarus/7e2ed503-f96b-496c-ac23-d2cfcccb4a36/scratchpad/dbg_boot.img; cp "$SNOW_CLARUS_IMG" /tmp/claude-1000/-home-andrew-repos-clarus/7e2ed503-f96b-496c-ac23-d2cfcccb4a36/scratchpad/dbg_clarus.img; cp "$WORK/snow.log" /tmp/claude-1000/-home-andrew-repos-clarus/7e2ed503-f96b-496c-ac23-d2cfcccb4a36/scratchpad/dbg_snow.log
t_done
