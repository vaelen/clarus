#!/bin/sh
# scripts/memcensus.sh --at-peak (CLARUS_MEM_PEAK=3): the compiler-global
# census taken at the overall peak moment, not at a phase boundary. The
# snapshot must sit within 64 KB of the TOTAL peak (the mechanism), and
# must name the IR expression arena, the largest block live at the
# bookmarks --rtbake peak: cv_irExprs since SE wave 2 Task 7 moved that
# peak out of the bake parse into fork building (cv_bkLdIrExprs, its
# parse staging, while the peak sat inside the parse).
. "$(dirname "$0")/../lib.sh" || exit 2
"$ROOT/scripts/memcensus.sh" --rtbake --at-peak "$ROOT/examples/bookmarks.cla" > "$WORK/out" 2>&1 \
    || die "memcensus failed: $(tail -3 "$WORK/out" | tr '\n' ' ')"
cat "$WORK/out"
peak=$(sed -n 's/^memprobe: TOTAL | peakAll68k=\([0-9]*\).*/\1/p' "$WORK/out" | tail -1)
snap=$(sed -n 's/^memprobe: peakcensus at live68k=\([0-9]*\).*/\1/p' "$WORK/out" | tail -1)
if [ -n "$peak" ] && [ -n "$snap" ] && [ $((peak - snap)) -ge 0 ] && [ $((peak - snap)) -le 65536 ]; then
    t_pass at_peak
else
    t_fail at_peak "last peakcensus live68k=${snap:-none} not within 64 KB of peakAll68k=${peak:-none}"
fi
if grep -Eq '^memprobe: peakcensus .* cv_(irExprs|bkLdIrExprs) ' "$WORK/out"; then
    t_pass bookmarks_rtbake
else
    t_fail bookmarks_rtbake "no peakcensus line names cv_irExprs or cv_bkLdIrExprs"
fi
t_done
