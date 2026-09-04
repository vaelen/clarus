#!/bin/sh
# Port of internal/bake/bakeidentity_test.go's
# TestRtbakeCorruptBodyRefused: the loader must refuse a bake whose BODY
# (past the header -- module manifest or any IR section) was corrupted, via
# the format-v4 bodyHash check -- clear diagnostic, nonzero exit. Every
# header field (magic/version/lane/stamp) still matches here, so this
# proves the bodyHash check catches a class the pre-v4 header check
# couldn't.
#
# `clirhdr --flip-body` is the script-side CorruptBodyFixture (bake.go):
# generated, not committed, same reasoning as refuse_stamp.sh's own note.
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

if grep -q 'body hash mismatch' "$WORK/log"; then
    t_pass diagnostic
else
    t_fail diagnostic "expected a clear body-hash-mismatch diagnostic, got: $(head -5 "$WORK/log" | tr '\n' ' ')"
fi
t_done
