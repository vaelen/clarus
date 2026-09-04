#!/bin/sh
# tests/emitui/goldens.sh -- port of internal/emitui's TestEmitUiGoldens.
# For every testdata/emitui/*.cla that HAS a committed .c.golden: run
# `clarusc emit`, byte-compare the emitted C to the golden, then m68k
# compile-check the GOLDEN (the committed contract, not the fresh bytes --
# so a mismatch above is reported as a golden mismatch and this step still
# exercises the pinned contract even if emission has drifted) against
# rt_ui.h. Compile only, no link: this gate verifies LOWERING, fixture by
# fixture.
#
# `-x c` is REQUIRED: gcc picks a source language purely from the file
# extension, ".c.golden" isn't in its table, and without -x it silently
# treats the file as a link-only input, warns, and exits 0 with NO object
# emitted -- hence the non-empty-object check too.
#
# The whole script skips without the m68k cross-compiler, exactly as the
# Go test's m68kGCC(t) skipped.
. "$(dirname "$0")/../lib.sh"

GCC=$ROOT/toolchain/bin/m68k-apple-macos-gcc
require_tool "$GCC"

found=0
for fixture in testdata/emitui/*.cla; do
    golden=${fixture%.cla}.c.golden
    [ -f "$golden" ] || continue      # error fixtures have none, by design
    found=$((found + 1))
    name=$(basename "$fixture")

    if ! "$CLARUSC" emit -o "$WORK/out.c" "$fixture" > "$WORK/emit.log" 2>&1; then
        t_fail "$name" "clarusc emit failed: $(head -3 "$WORK/emit.log" | tr '\n' ' ')"
        continue
    fi
    if ! cmp -s "$WORK/out.c" "$golden"; then
        t_fail "$name" "emitted C does not match $golden: $(cmp "$WORK/out.c" "$golden" 2>&1 | head -1); $(first_diff "$golden" "$WORK/out.c" | tr '\n' ' ')"
        continue
    fi
    rm -f "$WORK/out.o"
    if ! "$GCC" -x c -c -I "$HOSTRT" -I "$ROOT/runtime/mac" \
            "$golden" -o "$WORK/out.o" > "$WORK/cc.log" 2>&1; then
        t_fail "$name" "m68k-apple-macos-gcc -c $golden failed: $(head -5 "$WORK/cc.log" | tr '\n' ' ')"
        continue
    fi
    if [ ! -s "$WORK/out.o" ]; then
        t_fail "$name" "m68k-apple-macos-gcc -c $golden: no object file produced"
        continue
    fi
    t_pass "$name"
done

[ "$found" -gt 0 ] || die "no testdata/emitui/*.cla fixtures with a .c.golden found"
t_done
