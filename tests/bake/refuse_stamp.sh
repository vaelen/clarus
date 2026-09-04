#!/bin/sh
# Port of internal/bake/bakeidentity_test.go's
# TestRtbakeCorruptStampRefused: the loader must refuse a bake whose stamp
# doesn't match the loading compiler's own recomputed hash -- clear
# diagnostic, nonzero exit (runtime-ir-bake Task 4's refusal contract).
#
# The fixture is generated, not committed: `clirhdr --flip-stamp` is the
# script-side CorruptStampFixture (bake.go), because a committed blob
# would go stale the moment clarusc/clarusc.c is regenerated and the real
# stamp changes.
. "$(dirname "$0")/../lib.sh"
. "$(dirname "$0")/../lib_bake.sh"

VALID=$WORK/valid-68k.clir
CORRUPT=$WORK/corrupt-stamp-68k.clir
bake_ir 68k "$VALID"
"$CLIRHDR" --flip-stamp "$VALID" "$CORRUPT" || die "clirhdr --flip-stamp $VALID failed"

if "$CLARUSC" emit68k --rtbake "$CORRUPT" -o "$WORK/out.bin" \
        "$ROOT/testdata/cg68k/arith.cla" > "$WORK/log" 2>&1; then
    t_fail exit "clarusc emit68k --rtbake <corrupt-stamp>: expected nonzero exit, got success: $(head -3 "$WORK/log" | tr '\n' ' ')"
else
    t_pass exit
fi

if grep -q 'stamp mismatch' "$WORK/log"; then
    t_pass diagnostic
else
    t_fail diagnostic "expected a clear stamp-mismatch diagnostic, got: $(head -5 "$WORK/log" | tr '\n' ' ')"
fi
t_done
