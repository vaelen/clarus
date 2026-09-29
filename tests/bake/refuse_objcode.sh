#!/bin/sh
# Port of internal/bake/bakeidentity_test.go's
# TestRtbakeCorruptObjCodeRefused: the loader must refuse a
# STRUCTURALLY-VALID library whose object code (bkSecObjCode) carries an
# out-of-range reloc symbol -- bkObjRelocSymValid, run by the lazy object
# read (bake.cla's bkLoadObjCode) over every record it reads.
#
# The fixture is CorruptObjCodeFixture (bake.go): clarusc's own
# undocumented `--bake-ir --corrupt-objcode-testonly` flag, which corrupts
# the first call-kind hole of EVERY function (CLIR v9: a compile validates
# only the records it reads, its reachable functions', so the corruption
# must be wherever arith.cla reaches). v9 has no body hash to trip first,
# so the refusal can only come from the reloc-symbol check.
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

if grep -q 'object-code section' "$WORK/log" && grep -q 'out of range' "$WORK/log"; then
    t_pass diagnostic
else
    t_fail diagnostic "expected a clear object-code reloc-symbol-out-of-range diagnostic, got: $(head -5 "$WORK/log" | tr '\n' ' ')"
fi
t_done
