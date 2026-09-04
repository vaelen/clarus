#!/bin/sh
# tests/emitui/errconst.sh -- port of internal/emitui's TestEmitUiErrConstAt.
# A window property whose geometry value is a named int constant rather than
# a literal is legal SYNTAX (checkWidget validates only the property NAME,
# not this value's shape), so `clarusc emit` must fail loudly
# (lower.cla's lowRequireIntLit) instead of silently reading a wrong value:
# nonzero exit, and the diagnostic on STDERR (not stdout).
. "$(dirname "$0")/../lib.sh"

fixture=testdata/emitui/err_const_at.cla
want="window property requires an integer literal"

if "$CLARUSC" emit -o "$WORK/out.c" "$fixture" 2> "$WORK/err.txt"; then
    t_fail TestEmitUiErrConstAt "clarusc emit $fixture: want nonzero exit, got success (stderr: $(tr '\n' ' ' < "$WORK/err.txt"))"
elif ! grep -q "$want" "$WORK/err.txt"; then
    t_fail TestEmitUiErrConstAt "stderr missing \"$want\": $(tr '\n' ' ' < "$WORK/err.txt")"
else
    t_pass TestEmitUiErrConstAt
fi
t_done
