#!/bin/sh
# tests/bake/untaint.sh (SE wave 4 Task 1): every runtime function the
# 68k bake captures carries valid object code. Before wave 4, 26 functions
# that call a per-program synthesized reverse-waist dispatcher
# (clar_ui_fire_*, clar_conn_*, clar_lsn_/brs_/svc_fire_*) were "tainted"
# (cgObjValid false) and code-generated fresh on every --rtbake compile;
# the call now captures as a cgHoleSynthCall paste hole instead.
# `--objstats-testonly` logs one `objcode: invalid NAME` line per invalid
# function and a closing `objcode: valid V of N` line.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"

"$CLARUSC" --bake-ir --lane 68k --objstats-testonly -o "$WORK/rt68k.clir" \
    > "$WORK/stats.log" 2>&1 || die "bake failed: $(tail -3 "$WORK/stats.log")"

line=$(grep '^objcode: valid ' "$WORK/stats.log")
set -- $line
if [ -z "$line" ]; then
    t_fail count "no 'objcode: valid' line in the bake log"
elif [ "$3" = "$5" ] && [ "$5" -gt 0 ]; then
    t_pass count
else
    t_fail count "$3 of $5 valid; invalid: $(grep '^objcode: invalid ' "$WORK/stats.log" | cut -d' ' -f3 | tr '\n' ' ')"
fi
t_done
