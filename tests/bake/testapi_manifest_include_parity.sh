#!/bin/sh
# Port of internal/bake/bakeidentity_test.go's
# TestRtbakeTestapiManifestOnlyIncludeParity: a --testapi UI program that
# directly `include`s a MANIFEST-ONLY module (runtime/clarus/sortedmap.cla,
# one of the four driveManifestSplice only ever splices for check#2) --
# case (a) UNDER testapi, a genuinely new combination.
# bkManifestEarlyVisible["runtime/clarus/sortedmap.cla"] is false, so the
# collision stays check-only regardless of --testapi, which exercises the
# field-info install boundary for the first time: sortedmap.cla declares
# RtSortedMap, whose fields bkInstallFieldInfo installs wholesale BEFORE
# checkPhase1, and then the user's own check-only copy declares the same
# record again during checkPhase1. Must stay clean and byte-identical to
# from-source, with no "falling back" note.
#
# The fixture must live at the repo root (repo-root-relative include); the
# EXIT trap is re-armed to remove it, and still $WORK.
. "$(dirname "$0")/../lib.sh"
. "$(dirname "$0")/../lib_bake.sh"

NAME=manifest_include_parity_fixture.cla
FIXTURE=$ROOT/$NAME
trap 'rm -rf "$WORK"; rm -f "$FIXTURE"' EXIT

BAKE=$WORK/rt68k.clir
bake_ir 68k "$BAKE"

cat > "$FIXTURE" <<'CLA'
include "runtime/clarus/sortedmap.cla"

app ManifestIncludeParity {
    name: "ManifestIncludeParity"
    version: "1.0"
    author: "Andrew C. Young <andrew@vaelen.org>"
    about: "fallback-trigger-narrowing Task 3 testapi manifest-only include parity fixture."
    id: "MIPF"
}

window Probe {
    title: "ManifestIncludeParity"
    size: 300, 120
}

on App.launch {
    open Probe
}

extend Probe {
    on opened {
        var m: ptr
        sortedmapKeySlot(m, 0)
    }
}
CLA

PAIRFLAGS=--testapi
if detail=$(emit68k_pair parity "$NAME"); then
    t_pass testapi_manifest_include_parity
else
    t_fail testapi_manifest_include_parity "$detail"
fi
t_done
