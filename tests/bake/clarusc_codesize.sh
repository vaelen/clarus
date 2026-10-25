#!/bin/sh
# ClarusC.APPL's CODE budget (SE wave 5, spec 3.2/W2). cg_free_globals
# used to unroll one release per global and was duplicated into every
# segment (~11 KB x ~50 segments of ClarusC's ~1.6 MB of CODE); it is
# table-driven now. Builds ClarusC.bin with scripts/build-clarusc-mac.sh
# and sums every CODE resource's length (CODE 0 included) from the
# resource map; fails over LIMIT. SE wave 5 set 1193734 (the pre-table
# 1,603,334 minus 400 KB; measured 1,141,980). ui-widgets Task 12b raised
# it once, like tests/memgate/budget.txt, to measured + 1%: 1198592 ->
# 1210578 (the phase's always-linked widget runtime, spec 4.9, plus
# lower.cla's dispatcher synthesis; the SE floor in
# tests/mactest/snow/se_floor.txt stays the hard check). Measured at the
# ui-widgets tip: 1203844 (about 0.56% under LIMIT).
#
# CLARUSC_BIN/CLARUSC_MAC_OUT: as tests/bake/clarusc_container.sh -- the
# harness's own clarusc-current, output under $WORK.
. "$(dirname "$0")/../lib.sh" || exit 2

RESFORK=$TOOLS/resfork
OUT=$WORK/mac
BIN=$OUT/ClarusC.bin
LIMIT=1210578

CLARUSC_BIN=$CLARUSC CLARUSC_MAC_OUT=$OUT "$ROOT/scripts/build-clarusc-mac.sh" \
    > "$WORK/build.log" 2>&1 || die "build-clarusc-mac.sh failed: $(tail -5 "$WORK/build.log" | tr '\n' ' ')"
[ -f "$BIN" ] || die "no $BIN (CLARUSC_MAC_OUT ignored?)"

"$RESFORK" list "$BIN" > "$WORK/res.list" 2> "$WORK/res.err" \
    || die "resfork list: $(cat "$WORK/res.err")"
set -- $(awk '$1 == "CODE" { s += $NF; n++ } END { print n + 0, s + 0 }' "$WORK/res.list")
nseg=$1
total=$2
if [ "$nseg" -gt 1 ] && [ "$total" -le "$LIMIT" ]; then
    t_pass "code_total $total bytes in $nseg CODE resources (limit $LIMIT)"
else
    t_fail code_total "$total bytes in $nseg CODE resources, limit $LIMIT"
fi
t_done
