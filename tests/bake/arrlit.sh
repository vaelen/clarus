#!/bin/sh
# bake/arrlit -- `emit68k --rtbake` byte identity for the array-literal
# constant-pool class (language-runtime-cleanup, spec %4.4). The class is
# a genuine CLIR format extension: bkSecIrArrLits carries the pool, and
# cgRelClsPoolArr is a new relocation class the object-code paste path
# has to resolve. This is the T1-speed proof that a program using a
# `const` array and a `var` array initializer compiles byte-identically
# from source and through a bake -- the standing rule for any task adding
# a new baked arena, so it fails here rather than only in the T2-only
# full-corpus sweep.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"

BAKE=$WORK/rt68k.clir
bake_ir 68k "$BAKE"

cat > "$WORK/arrlit.cla" <<'CLA'
enum Mode { Off, On, Auto }

const squares: int[5] = [0, 1, 4, 9, 16]
const flags: bool[3] = [true, false, true]
const letters: char[3] = ['a', 'b', 'c']
const modes: Mode[2] = [Auto, Off]

var table: int[4] = [10, 20, 30, 40]

on App.startCLI(args: list of string) {
    var local: int[3] = [7, 8, 9]
    var n: int

    n = squares[2] + squares[4] + table[1] + local[2]
    if flags[0] and letters[1] == 'b' and modes[0] == Auto {
        n = n + 1
    }
    log(string(n))
    quit 0
}
CLA

if detail=$(emit68k_pair arrlit "$WORK/arrlit.cla"); then
    t_pass arrlit.cla
else
    t_fail arrlit.cla "$detail"
fi
t_done
