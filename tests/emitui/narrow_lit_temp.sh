#!/bin/sh
# tests/emitui/narrow_lit_temp.sh -- SE wave 3 final review, finding 1.
# Emits testdata/emitui/narrow_lit_temp.cla and checks that every value
# temp passed by address to rtListPush/rtListUnshift/rtMapSet/
# rtIntMapSet/rtSortedMapSet is declared at the container's narrow width,
# never int32_t (the runtime copies elemSize bytes from &temp, so an
# int32_t temp reads back 0 on a big-endian target). Six such calls.
. "$(dirname "$0")/../lib.sh" || exit 2

fixture=testdata/emitui/narrow_lit_temp.cla
"$CLARUSC" emit --rtdir "$RTDIR" -o "$WORK/out.c" "$fixture" > "$WORK/emit.log" 2>&1 \
    || die "clarusc emit $fixture: $(head -3 "$WORK/emit.log" | tr '\n' ' ')"
res=$(awk '
    /^ *(u?int(8|16|32)_t) t[0-9]+;$/ { n = $2; sub(/;/, "", n); ty[n] = $1; next }
    /clar_fn_rt(ListPush|ListUnshift|MapSet|IntMapSet|SortedMapSet)\(/ {
        s = $0
        v = ""
        while (match(s, /&\(t[0-9]+\)/)) { v = substr(s, RSTART + 2, RLENGTH - 3); s = substr(s, RSTART + RLENGTH) }
        if (v == "") next
        calls++
        if (ty[v] == "int32_t") bad = bad " " v
    }
    END { print calls + 0 ":" bad }' "$WORK/out.c")
calls=${res%%:*}
bad=${res#*:}
if [ "$calls" -ne 6 ]; then
    t_fail calls "expected 6 by-address narrow sets/pushes in the emitted C, found $calls"
elif [ -n "$bad" ]; then
    t_fail width "int32_t value temp(s) passed to a narrow container:$bad"
else
    t_pass width
fi
t_done
