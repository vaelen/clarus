#!/bin/sh
# timeout: 20m
# mactest/runerr_68k -- port of internal/mactest/native_test.go's
# TestRunErrOn68k: four runtime-panic fixtures booted natively (`clarusc
# emit68k`, no --events). Each must exit 3 and its captured LOG must
# contain the fixture's own testdata/runerr/<name>.err text.
#
# `oob` traps through cgListElemAddr's fixed-array arm; `listindex` through
# cgListAddrFromRegs' INLINE bounds check + cgEmitPanic (the path whose
# stale by-value-string ABI once printed an EMPTY message); divzero/modzero
# through the integer-division guards.
. "$(dirname "$0")/../lib.sh"
. "$(dirname "$0")/../lib_mac.sh" || die "helper lib failed to load"
require_env CLARUS_MAC_TESTS

for base in oob listindex divzero modzero; do
    fixture=testdata/runerr/$base.cla
    want=$(cat "testdata/runerr/$base.err") || die "reading testdata/runerr/$base.err"

    emit68k -o "$WORK/err$base.bin" "$fixture" > "$WORK/emit.log" 2>&1 \
        || die "clarusc emit68k $fixture: $(tail -10 "$WORK/emit.log")"
    run_mac "$WORK/err$base.bin" 180

    bad=
    [ "$MAC_EXIT" = 3 ] || bad="exit: got $MAC_EXIT want 3"
    if ! grep -qF "$want" "$WORK/cap.log"; then
        bad="$bad; log \"$(tr '\n' ' ' < "$WORK/cap.log")\" missing \"$want\""
    fi
    if [ -n "$bad" ]; then t_fail "$base" "$bad"; else t_pass "$base"; fi
done

t_done
