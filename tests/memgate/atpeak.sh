#!/bin/sh
# scripts/memcensus.sh --at-peak (CLARUS_MEM_PEAK=3): the compiler-global
# census taken at the overall peak moment, not at a phase boundary. The
# bookmarks --rtbake peak sits inside the bake parse, where
# cv_bkLdIrExprs is live, so the last snapshot must name it.
. "$(dirname "$0")/../lib.sh" || exit 2
"$ROOT/scripts/memcensus.sh" --rtbake --at-peak "$ROOT/examples/bookmarks.cla" > "$WORK/out" 2>&1 \
    || die "memcensus failed: $(tail -3 "$WORK/out" | tr '\n' ' ')"
cat "$WORK/out"
if grep -q '^memprobe: peakcensus .* cv_bkLdIrExprs ' "$WORK/out"; then
    t_pass bookmarks_rtbake
else
    t_fail bookmarks_rtbake "no peakcensus line names cv_bkLdIrExprs"
fi
t_done
