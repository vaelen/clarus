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

if "$CLARUSC" emit68k --rtbake "$CORRUPT" -o "$WORK/out.bin" \
        "$ROOT/testdata/cg68k/arith.cla" > "$WORK/log" 2>&1; then
    t_fail exit "clarusc emit68k --rtbake <corrupt-body>: expected nonzero exit, got success: $(head -3 "$WORK/log" | tr '\n' ' ')"
else
    t_pass exit
fi

if grep -q 'corrupt header' "$WORK/log"; then
    t_pass diagnostic
else
    t_fail diagnostic "expected a clear corrupt-header diagnostic, got: $(head -5 "$WORK/log" | tr '\n' ' ')"
fi
t_done
