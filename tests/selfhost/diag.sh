#!/bin/sh
# timeout: 30m
# selfhost/diag -- port of internal/selfhost/diag_test.go's TestErrorGoldens.
# Each testdata/errors/*.cla fixture goes through `clarusc emit` (NOT bare
# check-only mode: check-only never calls lowerProgram, so a lowering-phase
# diagnostic would check clean and silently defeat its golden), must exit
# nonzero, and its combined stdout+stderr is byte-compared against the
# committed <base>.expect golden.
#
# The goldens embed "../../testdata/errors/<f>.cla" -- the relative path
# clarusc echoes back -- because they were captured from internal/selfhost.
# tests/selfhost is at the same nesting depth, so running from here makes
# the path round-trip unchanged with no golden edits.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$ROOT/tests/lib_selfhost.sh" || die "helper lib failed to load"

cd "$ROOT/tests/selfhost" || die "cd $ROOT/tests/selfhost"

n=0
for f in ../../testdata/errors/*.cla; do
    [ -f "$f" ] || continue
    n=$((n + 1))
    name=$(basename "$f")
    want=${f%.cla}.expect
    if [ ! -f "$want" ]; then
        t_fail "$name" "read $want: no such file"
        continue
    fi

    "$CLARUSC" emit -o "$WORK/out.c" "$f" > "$WORK/got" 2>&1
    rc=$?
    if [ $rc -eq 0 ]; then
        t_fail "$name" "$f: want nonzero exit, got 0 (out: $(cat "$WORK/got"))"
        continue
    fi
    if cmp -s "$WORK/got" "$want"; then
        t_pass "$name"
    else
        t_fail "$name" "$f: diagnostics vs $want mismatch
$(diff -u "$want" "$WORK/got" | head -40)"
    fi
done
[ "$n" -gt 0 ] || die "no testdata/errors fixtures found"

t_done
