#!/bin/sh
# Port of internal/bake/bake_test.go's TestBakeCorruptStampFixture, which
# proves clirhdr --flip-stamp (the script-side CorruptStampFixture)
# actually corrupts the stamp and nothing else the header cares about: the
# flipped file still parses structurally -- only the stamp VALUE changed,
# not the framing -- but its stamp bytes differ from the valid bake's, at
# the same file length, in exactly one byte. The loader-refusal tests that
# consume these fixtures generate them the same way rather than reading a
# committed binary blob, which would go stale the moment
# clarusc/clarusc.c is regenerated and the real stamp changes.
#
# --flip-body is the CorruptBodyFixture counterpart. Flipping the first
# body byte lands on the module count's high byte, so the result is NOT
# expected to still parse (Go's own byte patch behaves identically); all
# this checks is that the flip is a single in-place byte at body_off.
. "$(dirname "$0")/../lib.sh"
. "$(dirname "$0")/../lib_bake.sh"

VALID=$WORK/valid-68k.clir
bake_ir 68k "$VALID"
if ! "$CLIRHDR" "$VALID" > "$WORK/valid.hdr" 2> "$WORK/valid.err"; then
    die "parse header of freshly-baked $VALID: $(cat "$WORK/valid.err")"
fi

CORRUPT=$WORK/corrupt-stamp-68k.clir
if ! "$CLIRHDR" --flip-stamp "$VALID" "$CORRUPT" 2> "$WORK/flip.err"; then
    die "clirhdr --flip-stamp: $(cat "$WORK/flip.err")"
fi

if "$CLIRHDR" "$CORRUPT" > "$WORK/corrupt.hdr" 2> "$WORK/corrupt.err"; then
    t_pass parses
    a=$(clir_field stamp "$WORK/valid.hdr")
    b=$(clir_field stamp "$WORK/corrupt.hdr")
    [ "$a" != "$b" ] && t_pass stamp_differs \
        || t_fail stamp_differs "corrupt fixture's stamp ($b) equals the valid bake's; corruption did not take effect"
else
    t_fail parses "$(cat "$WORK/corrupt.err") -- a corrupted STAMP byte must not break the file's structural framing"
    t_fail stamp_differs "corrupt fixture did not parse"
fi

va=$(wc -c < "$VALID")
vb=$(wc -c < "$CORRUPT")
[ "$va" = "$vb" ] && t_pass same_length \
    || t_fail same_length "corrupt fixture length $vb != valid bake length $va; corruption should only flip one byte in place"

diffs=$(cmp -l "$VALID" "$CORRUPT" | wc -l | tr -d ' ')
[ "$diffs" = 1 ] && t_pass one_byte \
    || t_fail one_byte "corrupt fixture differs from the valid bake in $diffs bytes, want exactly 1"

# --flip-body: one in-place byte, at body_off (1-based for cmp -l).
BODY=$WORK/corrupt-body-68k.clir
if ! "$CLIRHDR" --flip-body "$VALID" "$BODY" 2> "$WORK/flipb.err"; then
    t_fail flip_body "clirhdr --flip-body: $(cat "$WORK/flipb.err")"
else
    want=$(( $(clir_field body_off "$WORK/valid.hdr") + 1 ))
    cmp -l "$VALID" "$BODY" > "$WORK/bodydiff"
    got=$(wc -l < "$WORK/bodydiff" | tr -d ' ')
    at=$(awk 'NR==1{print $1}' "$WORK/bodydiff")
    if [ "$got" = 1 ] && [ "$at" = "$want" ]; then
        t_pass flip_body
    else
        t_fail flip_body "flipped $got bytes at offset $at, want exactly 1 at $want"
    fi
fi
t_done
