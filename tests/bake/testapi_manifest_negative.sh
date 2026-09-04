#!/bin/sh
# Port of internal/bake/bakeidentity_test.go's
# TestRtbakeTestapiManifestOnlyNegative: a --testapi program naming a
# MANIFEST-ONLY module's own internal (sortedmapKeySlot,
# runtime/clarus/sortedmap.cla -- one of the four modules
# driveManifestSplice only ever splices for check#2, never check#1) must
# error identically under --rtbake and from-source, EVEN THOUGH testapi's
# own preload covers the full thirteen early-spliced modules. Proves that
# widening stayed correctly scoped.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"

BAKE=$WORK/rt68k.clir
bake_ir 68k "$BAKE"

FIXTURE=$WORK/manifest_internal.cla
cat > "$FIXTURE" <<'CLA'
app ManifestInternalTest {
    name: "ManifestInternalTest"
    version: "1.0"
    author: "Andrew C. Young <andrew@vaelen.org>"
    about: "testapi manifest-only-internal negative fixture."
    id: "MFIT"
}

window Probe {
    title: "ManifestInternalTest"
    size: 300, 120
}

on App.launch {
    open Probe
}

extend Probe {
    on opened {
        sortedmapKeySlot(0, 0)
    }
}
CLA

if "$CLARUSC" emit68k --testapi -o "$WORK/src.bin" "$FIXTURE" > "$WORK/src.log" 2>&1; then
    t_fail src_exit "from-source --testapi naming sortedmapKeySlot: expected failure, got success: $(head -3 "$WORK/src.log" | tr '\n' ' ')"
else
    t_pass src_exit
fi

if "$CLARUSC" emit68k --rtbake "$BAKE" --testapi -o "$WORK/bake.bin" "$FIXTURE" > "$WORK/bake.log" 2>&1; then
    t_fail bake_exit "--rtbake --testapi naming sortedmapKeySlot: expected failure, got success: $(head -3 "$WORK/bake.log" | tr '\n' ' ')"
else
    t_pass bake_exit
fi

WANT='undefined: sortedmapKeySlot'
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
