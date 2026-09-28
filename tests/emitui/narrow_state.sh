#!/bin/sh
# tests/emitui/narrow_state.sh -- SE wave 3 Task 3: window-scoped narrow
# vars. Emits testdata/emitui/narrow_state.cla and m68k compile-checks the
# fresh C, whose clar_ui_szassert_Main pins cprint's clar_uistate_Main
# size against uiblob's uibStateSize (a 2-byte slot per narrow var).
. "$(dirname "$0")/../lib.sh" || exit 2

GCC=$ROOT/toolchain/bin/m68k-apple-macos-gcc
require_tool "$GCC"

fixture=testdata/emitui/narrow_state.cla
"$CLARUSC" emit -o "$WORK/out.c" "$fixture" > "$WORK/emit.log" 2>&1 \
    || die "clarusc emit $fixture: $(head -3 "$WORK/emit.log" | tr '\n' ' ')"
if ! "$GCC" -x c -c -I "$HOSTRT" -I "$ROOT/runtime/mac" \
        "$WORK/out.c" -o "$WORK/out.o" > "$WORK/cc.log" 2>&1; then
    t_fail szassert "m68k-apple-macos-gcc -c failed: $(head -5 "$WORK/cc.log" | tr '\n' ' ')"
else
    t_pass szassert
fi
t_done
