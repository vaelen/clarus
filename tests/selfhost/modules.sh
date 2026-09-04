#!/bin/sh
# timeout: 30m
# selfhost/modules -- port of internal/selfhost/modules_test.go's
# TestClarusModules. Each clarusc/test/*_test.cla driver (one per clarusc
# module; each pulls its module in via a relative `include "../X.cla"`) is
# built with the CURRENT-source clarusc + `cc` and its stdout byte-compared
# against the committed <base>.out golden. A nonzero exit is a failure.
. "$(dirname "$0")/../lib.sh"
. "$ROOT/tests/lib_selfhost.sh"

n=0
for f in clarusc/test/*_test.cla; do
    [ -f "$f" ] || continue
    n=$((n + 1))
    name=$(basename "$f")
    want=${f%.cla}.out
    if [ ! -f "$want" ]; then
        t_fail "$name" "read $want: no such file"
        continue
    fi

    if ! bo=$(fixture_build "$WORK/drv" "$CLARUSC" "$f" 2>&1); then
        t_fail "$name" "$bo"
        continue
    fi

    "$WORK/drv" > "$WORK/got" 2> "$WORK/goterr"
    rc=$?
    if [ $rc -ne 0 ]; then
        t_fail "$name" "run $f: exit $rc: $(cat "$WORK/goterr")"
        continue
    fi
    if cmp -s "$WORK/got" "$want"; then
        t_pass "$name"
    else
        t_fail "$name" "$f: stdout vs $want mismatch
$(diff -u "$want" "$WORK/got" | head -40)"
    fi
done
[ "$n" -gt 0 ] || die "no clarusc/test/*_test.cla drivers found"

t_done
