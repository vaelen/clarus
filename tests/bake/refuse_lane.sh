#!/bin/sh
# Port of internal/bake/bakeidentity_test.go's
# TestRtbakeLaneMismatchRefused: a c-lane bake fed to emit68k must be
# refused -- a stamp-refusal-class error with a clear message, nonzero exit
# (the controller's own resolution for "wrong lane").
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"

CBAKE=$WORK/rtc.clir
bake_ir c "$CBAKE"

if "$CLARUSC" emit68k --rtbake "$CBAKE" -o "$WORK/out.bin" \
        "$ROOT/testdata/cg68k/arith.cla" > "$WORK/log" 2>&1; then
    t_fail exit "clarusc emit68k --rtbake <c-lane bake>: expected nonzero exit, got success: $(head -3 "$WORK/log" | tr '\n' ' ')"
else
    t_pass exit
fi

if grep -q 'lane mismatch' "$WORK/log"; then
    t_pass diagnostic
else
    t_fail diagnostic "expected a clear lane-mismatch diagnostic, got: $(head -5 "$WORK/log" | tr '\n' ' ')"
fi
t_done
