#!/bin/sh
# compiler-cleanup phase: T1-speed `emit68k --rtbake` byte-identity for the
# datetime runtime split (datetime_68k.cla / datetime_c.cla) -- the one
# per-lane value-typed runtime module tests/bake/connfileh.sh and
# identity.sh do not touch. Standing rule (CLAUDE.md): a phase that adds a
# value-typed runtime module adds its tests/bake/<module>.sh twin in the
# same task; a --rtbake-only bug in that module then fails HERE in T1, not
# in the opt-in full-corpus sweep.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"

BAKE=$WORK/rt68k.clir
bake_ir 68k "$BAKE"

cat > "$WORK/datetime.cla" <<'CLA'
on App.startCLI(args: list of string) {
    var a: int
    var b: int
    var span: int

    a = now()
    b = now()
    span = b - a
    if span < 0 {
        quit 1
    }
    quit 0
}
CLA

if detail=$(emit68k_pair datetime "$WORK/datetime.cla"); then
    t_pass datetime.cla
else
    t_fail datetime.cla "$detail"
fi
t_done
