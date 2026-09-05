#!/bin/sh
# timeout: 30m
# selfhost/modules -- port of internal/selfhost/modules_test.go's
# TestClarusModules. Each clarusc/test/*_test.cla driver (one per clarusc
# module; each pulls its module in via a relative `include "../X.cla"`) is
# built with the CURRENT-source clarusc + `cc` and its stdout byte-compared
# against the committed <base>.out golden. A nonzero exit is a failure.
#
# CLARUS_MODULES_BLESS=1 rewrites those .out goldens from the current
# compiler instead of comparing (Task 11, final-review item 21) -- the
# fifth bless variable, and like the other four it counts only when set to
# exactly 1 (lib.sh's env_set, via golden_check).
. "$(dirname "$0")/../lib.sh" || exit 2
. "$ROOT/tests/lib_selfhost.sh" || die "helper lib failed to load"

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
    if golden_check "$WORK/got" "$want" CLARUS_MODULES_BLESS; then
        t_pass "$name"
    else
        t_fail "$name" "$f: stdout vs $want mismatch (golden_check diff above)"
    fi
done
[ "$n" -gt 0 ] || die "no clarusc/test/*_test.cla drivers found"

t_done
