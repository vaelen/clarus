#!/bin/sh
# tests/tcp/waist68k.sh (2026-09-08 mactcp spec, Task 7): the compile
# check for runtime/clarus/tcp_68k.cla, the MacTCP waist.
#
# The module used to be passed POSITIONALLY here, as ordinary user code:
# it was not in the 68k superset manifest yet. Task 6's Ruling 1 splice
# put it there, so passing it again is now a `redeclaration of
# rtTcpDevInit` -- the runtime supplies it, and the probe alone is the
# whole build. What that still proves is what this script has always
# proved without hardware: the file parses, every csCode/offset/flag/
# error name it pokes resolves against toolbox/mactcp.cla, the types
# check, and cg68k emits code for all sixteen waist functions (the probe
# names each one behind an `if false`, so shake keeps them). MacTCP
# itself is absent from every emulator here (spec %2), so nothing boots
# -- Task 11 does that on Snow.
. "$(dirname "$0")/../lib.sh" || exit 2

PROBE=$ROOT/tests/tcp/testdata/waist68k_probe.cla

if emit68k -o "$WORK/probe.bin" --listing "$PROBE" > "$WORK/emit.log" 2>&1; then
    t_pass emit68k
else
    t_fail emit68k "$(tail -20 "$WORK/emit.log")"
fi

if [ -s "$WORK/probe.bin" ]; then
    t_pass nonempty
else
    t_fail nonempty "no 68k binary produced"
fi

# All sixteen waist entry points reached codegen. --listing writes the
# assembly beside the binary, so the symbol names are greppable; without
# this the test would prove only that SOMETHING compiled.
missing=
for f in Init Create ActiveOpen Poll RecvLen RecvPtr RecvArm SendBusy \
         Send Close Release LsnOpen LsnPoll LsnAccept LsnDeny LsnClose; do
    grep -q "rtTcpDev$f" "$WORK"/probe.seg*.s 2>/dev/null || missing="$missing rtTcpDev$f"
done
if [ -z "$missing" ]; then
    t_pass all_sixteen
else
    t_fail all_sixteen "no code emitted for:$missing"
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
