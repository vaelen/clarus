#!/bin/sh
# Port of internal/bake/bakeidentity_test.go's
# TestRtbakeTestapiManifestOnlyNegative: a --testapi program naming a
# MANIFEST-ONLY module's own internal (rtFhSize,
# runtime/clarus/fileh.cla -- one of the modules driveManifestSplice
# only ever splices for check#2, never check#1) must error identically
# under --rtbake and from-source, EVEN THOUGH testapi's own preload
# covers the whole early-spliced set. Proves that widening stayed
# correctly scoped.
#
# MacTCP phase, debt 3: the probe used to be sortedmapKeySlot
# (runtime/clarus/sortedmap.cla). sortedmap.cla stopped being
# manifest-only on the 68k lane when the connection/AppleTalk families
# joined the --testapi early-visible set -- the early list has to stay a
# strict PREFIX of the manifest order, so sortedmap/datetime came along
# with them (clarusc/drive.cla's driveEarlySplice). native.cla, fileh.cla
# and fileh_68k.cla are what is still manifest-only on this lane, and
# rtFhSize is fileh.cla's.
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
        rtFhSize(0)
    }
}
CLA

if "$CLARUSC" emit68k --testapi -o "$WORK/src.bin" "$FIXTURE" > "$WORK/src.log" 2>&1; then
    t_fail src_exit "from-source --testapi naming rtFhSize: expected failure, got success: $(head -3 "$WORK/src.log" | tr '\n' ' ')"
else
    t_pass src_exit
fi

if "$CLARUSC" emit68k --rtbake "$BAKE" --testapi -o "$WORK/bake.bin" "$FIXTURE" > "$WORK/bake.log" 2>&1; then
    t_fail bake_exit "--rtbake --testapi naming rtFhSize: expected failure, got success: $(head -3 "$WORK/bake.log" | tr '\n' ' ')"
else
    t_pass bake_exit
fi

WANT='undefined: rtFhSize'
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
