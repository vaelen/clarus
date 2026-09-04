#!/bin/sh
# Port of internal/bake/bakeidentity_test.go's
# TestRtbakeCorruptObjCodeRefused: the loader must refuse a
# STRUCTURALLY-VALID bake whose object-code section (bkSecObjCode) carries
# an out-of-range reloc symbol -- object-code-linker Task 2's own
# bkObjRelocSymValid check, NOT the pre-existing v4 body-hash check.
#
# The fixture is CorruptObjCodeFixture (bake.go): clarusc's own
# undocumented `--bake-ir --corrupt-objcode-testonly` flag, which corrupts
# the first call-kind hole's reloc symbol BEFORE bkHashText computes the
# body hash -- so the artifact's own body hash is genuinely correct for its
# corrupted content, and this test cannot pass vacuously via
# refuse_body.sh's generic mismatch path (asserted below).
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"

CORRUPT=$WORK/corrupt-objcode-68k.clir
"$CLARUSC" --bake-ir --lane 68k --corrupt-objcode-testonly -o "$CORRUPT" \
    || die "clarusc --bake-ir --lane 68k --corrupt-objcode-testonly failed"

if "$CLARUSC" emit68k --rtbake "$CORRUPT" -o "$WORK/out.bin" \
        "$ROOT/testdata/cg68k/arith.cla" > "$WORK/log" 2>&1; then
    t_fail exit "clarusc emit68k --rtbake <corrupt-objcode>: expected nonzero exit, got success: $(head -3 "$WORK/log" | tr '\n' ' ')"
else
    t_pass exit
fi

if grep -q 'body hash mismatch' "$WORK/log"; then
    t_fail not_bodyhash "refused via the generic body-hash check, not the reloc-symbol check -- CorruptObjCodeFixture's own hash recompute did not take effect: $(head -5 "$WORK/log" | tr '\n' ' ')"
else
    t_pass not_bodyhash
fi

if grep -q 'object-code section' "$WORK/log" && grep -q 'out of range' "$WORK/log"; then
    t_pass diagnostic
else
    t_fail diagnostic "expected a clear object-code reloc-symbol-out-of-range diagnostic, got: $(head -5 "$WORK/log" | tr '\n' ' ')"
fi
t_done
