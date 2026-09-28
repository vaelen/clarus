#!/bin/sh
# lowlevel/extern_narrow.sh -- SE wave 3 Task 6 (spec §3.2 step 1): int16
# and uint8 at extern, callback, reg and extern-record positions marshal
# byte-for-byte like word and byte. The fixture is compiled as written and
# again with int16 -> word, uint8 -> byte; both emit68k and emit must match.
# Also: uint8/uint16 in an extern or callback signature is a build error.
. "$(dirname "$0")/../lib.sh" || exit 2

# A subdirectory: lowlevel/run host-RUNS every top-level fixture.
SRC=$ROOT/testdata/lowlevel/narrow/extern_narrow.cla
[ -f "$SRC" ] || die "missing $SRC"
mkdir -p "$WORK/n" "$WORK/w"
cp "$SRC" "$WORK/n/p.cla"
# Only the boundary positions: extern record bodies and extern/callback
# signature lines (the program's own locals stay narrow in both twins).
sed -e '/^extern record/,/^}/{s/\bint16\b/word/g;s/\buint8\b/byte/g;}' \
    -e '/^external func\|^callback func/s/\bint16\b/word/g' "$SRC" > "$WORK/w/p.cla"
cmp -s "$SRC" "$WORK/w/p.cla" && die "twin rewrite changed nothing"

for lane in emit68k emit; do
    ok=1
    for v in n w; do
        "$CLARUSC" $lane --rtdir "$RTDIR" -o "$WORK/$v/out.$lane" "$WORK/$v/p.cla" \
            > "$WORK/$v/$lane.log" 2>&1 || { t_fail "$lane-$v" "$(head -5 "$WORK/$v/$lane.log")"; ok=0; }
    done
    [ $ok = 1 ] || continue
    if cmp -s "$WORK/n/out.$lane" "$WORK/w/out.$lane"; then
        t_pass "$lane-identical"
    else
        t_fail "$lane-identical" "$(cmp "$WORK/n/out.$lane" "$WORK/w/out.$lane" 2>&1)"
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
t_done
