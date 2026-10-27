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

if "$CLARUSC" build68k --rtbake "$CORRUPT" -o "$WORK/out.bin" \
        "$ROOT/testdata/cg68k/arith.cla" > "$WORK/log" 2>&1; then
    t_fail exit "clarusc build68k --rtbake <corrupt-objcode>: expected nonzero exit, got success: $(head -3 "$WORK/log" | tr '\n' ' ')"
else
    t_pass exit
fi

if grep -q 'object-code section' "$WORK/log" && grep -q 'out of range' "$WORK/log"; then
    t_pass diagnostic
else
    t_fail diagnostic "expected a clear object-code reloc-symbol-out-of-range diagnostic, got: $(head -5 "$WORK/log" | tr '\n' ' ')"
fi
# A library whose index marks every record empty (`--empty-objcode-testonly`)
# passes bkLoadObjCode -- it reads nothing -- but CLIR v9's 68k library has
# no IR bodies to fall back on, so Measure must refuse the first reachable
# baked function (cg68k.cla's cgObjLibMissing) instead of emitting it empty.
EMPTY=$WORK/empty-objcode-68k.clir
"$CLARUSC" --bake-ir --lane 68k --empty-objcode-testonly -o "$EMPTY" \
    || die "clarusc --bake-ir --lane 68k --empty-objcode-testonly failed"
if "$CLARUSC" build68k --rtbake "$EMPTY" -o "$WORK/empty.bin" \
        "$ROOT/testdata/cg68k/arith.cla" > "$WORK/empty.log" 2>&1; then
    t_fail empty_exit "clarusc build68k --rtbake <empty-objcode>: expected nonzero exit, got success"
else
    t_pass empty_exit
fi
if grep -q 'has no object record' "$WORK/empty.log"; then
    t_pass empty_diagnostic
else
    t_fail empty_diagnostic "expected a missing-object-record diagnostic, got: $(tail -3 "$WORK/empty.log" | tr '\n' ' ')"
fi
t_done
