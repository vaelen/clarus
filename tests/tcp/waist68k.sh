#!/bin/sh
# tests/tcp/waist68k.sh (2026-09-08 mactcp spec, Task 7): the compile
# check for runtime/clarus/tcp_68k.cla, the MacTCP waist.
#
# The module is not in the 68k superset manifest yet (Task 9 does that),
# so the only way to compile it today is to pass it POSITIONALLY, as
# ordinary user code, beside a program that names every rtTcpDev* entry.
# That is enough to prove what this task can prove without hardware: the
# file parses, every csCode/offset/flag/error name it pokes resolves
# against toolbox/mactcp.cla, the types check, and cg68k emits code for
# all sixteen waist functions. MacTCP itself is absent from every
# emulator here (spec %2), so nothing boots -- Task 11 does that on Snow.
#
# NOTE for Task 9: once tcp_68k.cla is spliced, this build becomes a
# `redeclaration of rtTcpDevInit` -- user code cannot redefine a runtime
# function. Retire or rewrite this script in that task.
. "$(dirname "$0")/../lib.sh" || exit 2

WAIST=$ROOT/runtime/clarus/tcp_68k.cla
PROBE=$ROOT/tests/tcp/testdata/waist68k_probe.cla

if emit68k -o "$WORK/probe.bin" "$WAIST" "$PROBE" > "$WORK/emit.log" 2>&1; then
    t_pass emit68k
else
    t_fail emit68k "$(tail -20 "$WORK/emit.log")"
fi

if [ -s "$WORK/probe.bin" ]; then
    t_pass nonempty
else
    t_fail nonempty "no 68k binary produced"
fi

# The waist is worthless if it silently compiled against something other
# than Task 4's catalog -- a stray local const of the same name would do
# it. The emit log names every file the build included.
if grep -q 'toolbox/mactcp.cla' "$WORK/emit.log"; then
    t_pass catalog_included
else
    t_fail catalog_included "the build never included toolbox/mactcp.cla: $(cat "$WORK/emit.log")"
fi

t_done
