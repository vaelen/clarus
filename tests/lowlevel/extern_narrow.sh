#!/bin/sh
# lowlevel/extern_narrow.sh -- SE wave 3 (spec §3.2 step 1): int16 and
# uint8 at extern, callback, reg and extern-record positions compile on
# both lanes; the old `word`/`byte` spellings are gone (Task 12); and
# uint8/uint16 in an extern or callback signature is a build error.
#
# Byte-identity with the old spellings holds by construction: the parser
# builds the same TxWord/TxByte nodes `word`/`byte` built, and no code path
# can tell them apart. Task 6 proved it with a word/byte sed twin; Task 12
# (the removal) re-proved it once against the snapshot compiler, which
# still took `word` -- the twin cannot compile any more, so it was dropped.
# testdata/cg68k and the bake goldens pin the marshaling itself.
. "$(dirname "$0")/../lib.sh" || exit 2

# A subdirectory: lowlevel/run host-RUNS every top-level fixture.
SRC=$ROOT/testdata/lowlevel/narrow/extern_narrow.cla
[ -f "$SRC" ] || die "missing $SRC"
for lane in emit68k emit; do
    if "$CLARUSC" $lane --rtdir "$RTDIR" -o "$WORK/out.$lane" "$SRC" > "$WORK/$lane.log" 2>&1; then
        t_pass "$lane-compiles"
    else
        t_fail "$lane-compiles" "$(head -5 "$WORK/$lane.log")"
    fi
done

# rejected SUBCASE DECL EXPECTED-DIAG-SUBSTRING
rejected() {
    printf '%s\non App.startCLI(args: list of string) {\n}\n' "$2" > "$WORK/$1.cla"
    if "$CLARUSC" "$WORK/$1.cla" --rtdir "$RTDIR" > "$WORK/$1.log" 2>&1; then
        t_fail "$1" "compiled; expected: $3"
    elif grep -qF "$3" "$WORK/$1.log"; then
        t_pass "$1"
    else
        t_fail "$1" "want '$3', got: $(head -3 "$WORK/$1.log")"
    fi
}
rejected ext_uint16_param 'external func F(a: uint16) = trap 0xA9C8' 'uint16 cannot cross the Toolbox boundary'
rejected ext_uint8_ret 'external func F(): uint8 = trap 0xA9C8' 'uint8 cannot cross the Toolbox boundary'
rejected cb_uint16_param 'callback func cb(a: uint16) {
}' 'uint16 cannot cross the Toolbox boundary'
rejected cb_uint8_ret 'callback func cb(): uint8 {
    return 1
}' 'uint8 cannot cross the Toolbox boundary'
rejected xrec_uint16_field 'extern record R {
    a: uint16
}' 'extern record field type must be'
rejected reg_uint8_param 'external func F(a: uint8, p: ptr) = trap 0xA031 reg(d0: a, a0: p)' 'uint8 cannot cross the Toolbox boundary'
rejected ptrcall_uint8_param 'external func F(target: ptr, a: uint8) = ptr' 'uint8 cannot cross the Toolbox boundary'
rejected word_param 'external func F(a: word) = trap 0xA9C8' 'undefined: word'
rejected word_ret 'external func F(): word = trap 0xA9C8' 'undefined: word'
rejected cb_word_param 'callback func cb(a: word) {
}' 'undefined: word'
rejected xrec_word_field 'extern record R {
    a: word
}' 'extern record field type must be'
rejected xrec_byte_field 'extern record R {
    a: byte
}' 'extern record field type must be'
t_done
