#!/bin/sh
# SE wave 3 (spec 3.5): T1-speed `build68k --rtbake` byte-identity for the
# box-size runtime lane pair (boxsize_68k.cla / boxsize_c.cla). Standing
# rule (CLAUDE.md): a phase that adds a value-typed runtime module adds its
# tests/bake/<module>.sh twin in the same task. The probe builds every
# container the box-size constants size (text/list/map/sortedmap).
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"

[ -f "$ROOT/runtime/clarus/boxsize_68k.cla" ] || die "runtime/clarus/boxsize_68k.cla missing"
[ -f "$ROOT/runtime/clarus/boxsize_c.cla" ] || die "runtime/clarus/boxsize_c.cla missing"

BAKE=$WORK/rt68k.clir
bake_ir 68k "$BAKE"

cat > "$WORK/boxsize.cla" <<'CLA'
on App.startCLI(args: list of string) {
    var t: text
    var l: list of int
    var m: map of int
    var s: sortedmap of int

    t.append('a')
    t.append('b')
    l.add(1)
    m["k"] = 2
    s["k"] = 3
    if t.length + l.count + m.count + s.count != 5 {
        quit 1
    }
    quit 0
}
CLA

if detail=$(emit68k_pair boxsize "$WORK/boxsize.cla"); then
    t_pass boxsize.cla
else
    t_fail boxsize.cla "$detail"
fi
t_done
