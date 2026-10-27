#!/bin/sh
# Port of internal/bake/bakeidentity_test.go's
# TestRtbakeCorruptBodyRefused, retargeted to CLIR v9 (SE wave 4 Task 6):
# v9 has no body hash (W6 -- a lazy, partial read cannot verify one), so a
# corrupt library is refused by structure instead. `clirhdr --flip-body`
# flips the first byte after the stamp -- the module count's high byte --
# which throws the module list and section directory off; the loader must
# refuse with a clear diagnostic and a nonzero exit, never read on into
# garbage. Every header field (magic/version/lane/stamp) still matches.
#
# The fixture is generated, not committed, same reasoning as
# refuse_stamp.sh's own note.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"

VALID=$WORK/valid-body-68k.clir
CORRUPT=$WORK/corrupt-body-68k.clir
bake_ir 68k "$VALID"
"$CLIRHDR" --flip-body "$VALID" "$CORRUPT" || die "clirhdr --flip-body $VALID failed"

if "$CLARUSC" build68k --rtbake "$CORRUPT" -o "$WORK/out.bin" \
        "$ROOT/testdata/cg68k/arith.cla" > "$WORK/log" 2>&1; then
    t_fail exit "clarusc build68k --rtbake <corrupt-body>: expected nonzero exit, got success: $(head -3 "$WORK/log" | tr '\n' ' ')"
else
    t_pass exit
fi

if grep -q 'corrupt header' "$WORK/log"; then
    t_pass diagnostic
else
    t_fail diagnostic "expected a clear corrupt-header diagnostic, got: $(head -5 "$WORK/log" | tr '\n' ' ')"
fi

# lane_set (SE wave 4 Task 7): the directory must hold the lane's own
# section set, not merely the right count of unique known ids. Retag the
# 68k library's GlobalInits (52) as IrStmts (2), a c-lane-only section:
# still 47 unique known ids, but the loader must refuse the directory
# itself rather than parse a GlobalInits payload as statements.
LANESET=$WORK/laneset-68k.clir
clir_retag_section "$VALID" "$LANESET" 52 2 || die "clir_retag_section $VALID failed"
if "$CLARUSC" build68k --rtbake "$LANESET" -o "$WORK/out.bin" \
        "$ROOT/testdata/cg68k/arith.cla" > "$WORK/laneset.log" 2>&1; then
    t_fail lane_set "clarusc build68k --rtbake <c-lane section in a 68k library>: expected nonzero exit, got success"
elif grep -q 'corrupt header' "$WORK/laneset.log"; then
    t_pass lane_set
else
    t_fail lane_set "expected the corrupt-header (section directory) diagnostic, got: $(head -5 "$WORK/laneset.log" | tr '\n' ' ')"
fi
# A corrupt shake summary (section 51) is refused as a framing mismatch
# (bake.cla's bkShakeSummaryValid), not left for shakeReplay to index out
# of range. Its payload is funcs(4) | count(4) start[0](4) start[1](4) ...;
# start[1] becomes 0x7fffffff, past the name list's end.
SUMOFF=$("$CLIRHDR" "$VALID" | awk '$1 == "section" && $2 == 51 { print $4 }')
[ -n "$SUMOFF" ] || die "no shake-summary section in $VALID"
cp "$VALID" "$WORK/corrupt-sum-68k.clir" || die "cp failed"
printf '\177\377\377\377' | dd of="$WORK/corrupt-sum-68k.clir" bs=1 seek=$((SUMOFF + 12)) conv=notrunc 2>/dev/null \
    || die "dd failed"
if "$CLARUSC" build68k --rtbake "$WORK/corrupt-sum-68k.clir" -o "$WORK/sum.bin" \
        "$ROOT/testdata/cg68k/arith.cla" > "$WORK/sum.log" 2>&1; then
    t_fail summary_exit "clarusc build68k --rtbake <corrupt-summary>: expected nonzero exit, got success"
else
    t_pass summary_exit
fi
if grep -q 'section 51 framing mismatch' "$WORK/sum.log"; then
    t_pass summary_diagnostic
else
    t_fail summary_diagnostic "expected a section 51 framing diagnostic, got: $(tail -3 "$WORK/sum.log" | tr '\n' ' ')"
fi
t_done
