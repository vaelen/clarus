#!/bin/sh
# lowlevel/incdedup.sh -- port of internal/lowlevel/incdedup_test.go
# TestIncludeDedup: include-once identity is the LEXICALLY NORMALIZED path,
# not the raw include spelling.
. "$(dirname "$0")/../lib.sh"

main=$ROOT/testdata/incdedup/main.cla

# --- TwoSpellings -----------------------------------------------------
# main.cla reaches sub/common.cla as both "sub/common.cla" and
# "sub/../sub/common.cla". "clar_fn_common42(" alone also matches the
# forward declaration and the call site, so the definition marker (the
# body-opening "{") is what distinguishes a genuine duplicate DEFINITION.
n=TwoSpellings
if ! "$CLARUSC" emit -o "$WORK/main.c" "$main" > "$WORK/main.log" 2>&1; then
    t_fail "$n" "emit failed: $(head -3 "$WORK/main.log" | tr '\n' ' ')"
else
    c=$(grep -oF 'clar_fn_common42(void) {' "$WORK/main.c" | wc -l | tr -d ' ')
    [ "$c" = 1 ] && t_pass "$n" \
        || t_fail "$n" "expected exactly one definition of clar_fn_common42(, got $c"
fi

# --- EntryFileDedup ---------------------------------------------------
# The second spelling is built by string concatenation, NOT by any path
# cleaner, so the "/./" segment survives byte-for-byte: it must be a
# textually distinct spelling of the same file, or a raw-string-keyed
# seenPaths map would already dedup it trivially.
n=EntryFileDedup
second=$ROOT/testdata/incdedup/./main.cla
if "$CLARUSC" emit -o "$WORK/dup.c" "$main" "$second" > "$WORK/dup.log" 2>&1; then
    t_pass "$n"
else
    t_fail "$n" "emit failed: $(head -3 "$WORK/dup.log" | tr '\n' ' ')"
fi

t_done
