#!/bin/sh
# Port of internal/bake/bakeidentity_test.go's
# TestRtbakeTestapiCollisionParity (deliverable (c)): a --testapi program
# that itself DECLARES a top-level `UiTestVerb` collides with the preloaded
# checker symbol. scopeDeclare's "first declared, in this scope, keeps it"
# rule attributes the diagnostic to the USER's file at the user's own
# collision line -- never to the runtime file -- on BOTH paths, because
# bkInstallCheckerSymbolsForTestapi runs its preload before the user's own
# checkPhase1 exactly as driveEarlySplice does. Asserts that parity
# directly: the same "redeclaration of UiTestVerb" at the same file:line.
. "$(dirname "$0")/../lib.sh"
. "$(dirname "$0")/../lib_bake.sh"

BAKE=$WORK/rt68k.clir
bake_ir 68k "$BAKE"

FIXTURE=$WORK/collide.cla
cat > "$FIXTURE" <<'CLA'
app CollideTest {
    name: "CollideTest"
    version: "1.0"
    author: "Andrew C. Young <andrew@vaelen.org>"
    about: "forced redeclaration fixture."
    id: "CLTS"
}

window Probe {
    title: "CollideTest"
    size: 300, 120
}

on App.launch {
    open Probe
}

func UiTestVerb(x: int): bool {
    return true
}
CLA

if "$CLARUSC" emit68k --testapi -o "$WORK/src.bin" "$FIXTURE" > "$WORK/src.log" 2>&1; then
    t_fail src_exit "from-source: expected the redeclaration to fail the compile, got success: $(head -3 "$WORK/src.log" | tr '\n' ' ')"
else
    t_pass src_exit
fi

if "$CLARUSC" emit68k --rtbake "$BAKE" --testapi -o "$WORK/bake.bin" "$FIXTURE" > "$WORK/bake.log" 2>&1; then
    t_fail bake_exit "--rtbake: expected the redeclaration to fail the compile, got success: $(head -3 "$WORK/bake.log" | tr '\n' ' ')"
else
    t_pass bake_exit
fi

WANT='collide.cla:18:1: redeclaration of UiTestVerb'
if grep -q "$WANT" "$WORK/src.log"; then
    t_pass src_diagnostic
else
    t_fail src_diagnostic "from-source diagnostic missing \"$WANT\": $(head -5 "$WORK/src.log" | tr '\n' ' ')"
fi
if grep -q "$WANT" "$WORK/bake.log"; then
    t_pass bake_diagnostic
else
    t_fail bake_diagnostic "--rtbake diagnostic missing \"$WANT\": $(head -5 "$WORK/bake.log" | tr '\n' ' ')"
fi
t_done
