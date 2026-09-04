#!/bin/sh
# Port of internal/bake/bakeidentity_test.go's TestBakeFullCorpusEmitui
# (deliverable (d)): `emit --rtbake` (C lane, --bake-ir --lane c) against
# from-source `emit`, over the FULL testdata/emitui corpus -- no allowlist.
#
# Fixtures that error IDENTICALLY on both sides (a parse/check-diagnostic
# fixture, e.g. err_const_at.cla) are skipped: there is no compiled output
# to compare, and both sides already share the emitui diagnostic-text
# golden coverage. The exit statuses must still agree -- that is the real
# assertion for those. Skipped subcases print a SKIP line (the runner's
# per-script protocol has PASS/FAIL only), mirroring the Go subtest's
# t.Skip.
#
# Unlike the emit68k halves, the C-lane forks are written side by side in
# ONE directory under distinct names, exactly as the Go original does: no
# MacBinary wrap, so no embedded output filename to diverge on.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"
require_env CLARUS_BAKE_FULL

BAKE=$WORK/rtc.clir
bake_ir c "$BAKE"

n=0
for entry in "$ROOT"/testdata/emitui/*.cla; do
    [ -f "$entry" ] || continue
    n=$((n+1))
done
[ "$n" -gt 0 ] || die "glob testdata/emitui/*.cla: 0 matches"

for entry in "$ROOT"/testdata/emitui/*.cla; do
    base=$(basename "$entry")
    srcout=$WORK/src-$base.c
    bakeout=$WORK/bake-$base.c

    "$CLARUSC" emit --rtdir runtime/clarus/ -o "$srcout" "$entry" > "$WORK/src.log" 2>&1
    srcrc=$?
    "$CLARUSC" emit --rtdir runtime/clarus/ --rtbake "$BAKE" -o "$bakeout" "$entry" > "$WORK/bake.log" 2>&1
    bakerc=$?

    if [ "$srcrc" -eq 0 ] && [ "$bakerc" -ne 0 ]; then
        t_fail "$base" "exit mismatch (from-source ok, bake rc=$bakerc): $(head -3 "$WORK/bake.log" | tr '\n' ' ')"
        continue
    fi
    if [ "$srcrc" -ne 0 ] && [ "$bakerc" -eq 0 ]; then
        t_fail "$base" "exit mismatch (from-source rc=$srcrc, bake ok): $(head -3 "$WORK/src.log" | tr '\n' ' ')"
        continue
    fi
    if [ "$srcrc" -ne 0 ]; then
        echo "SKIP $base: fixture errors identically on both sides -- no compiled output to compare"
        continue
    fi

    if cmp -s "$srcout" "$bakeout"; then
        t_pass "$base"
    else
        t_fail "$base" "--rtbake fork ($(wc -c < "$bakeout" | tr -d ' ') bytes) != from-source fork ($(wc -c < "$srcout" | tr -d ' ') bytes): $(cmp "$srcout" "$bakeout" 2>&1 | head -1)"
    fi
done
t_done
