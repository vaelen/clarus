#!/bin/sh
# Port of internal/bake/bakeidentity_test.go's
# TestRtbakeTestapiIncludeParity: a --testapi UI program that directly
# `include`s toolbox/files.cla -- early-visible for EVERY testapi UI build
# (uidialogs.cla, one of the 13 early-spliced modules, itself includes it)
# -- and calls one of its externs. Under Task 2's mechanism this is case
# (b): hash-equal + early-visible -> full dedup, matching from-source's own
# post-dedup state, so it must compile clean and byte-identical on both
# paths with no "falling back" note, NOT produce Task 1's own verbatim
# "redeclaration of ..." diagnostic block.
#
# The fixture must live at the repo root: `include "toolbox/files.cla"` is
# repo-root-relative and resolves against the FIXTURE's own location, not
# the cwd. The EXIT trap is re-armed to remove it, and still $WORK.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"

NAME=testapi_include_parity_fixture.cla
FIXTURE=$ROOT/$NAME
trap 'rm -rf "$WORK"; rm -f "$FIXTURE"' EXIT

BAKE=$WORK/rt68k.clir
bake_ir 68k "$BAKE"

cat > "$FIXTURE" <<'CLA'
include "toolbox/files.cla"

app TestapiIncludeParity {
    name: "TestapiIncludeParity"
    version: "1.0"
    author: "Andrew C. Young <andrew@vaelen.org>"
    about: "fallback-trigger-narrowing Task 3 testapi include-collision parity fixture."
    id: "TIPF"
}

window Probe {
    title: "TestapiIncludeParity"
    size: 300, 120
}

on App.launch {
    open Probe
}

extend Probe {
    on opened {
        var pb: ptr
        var r: int
        r = PBGetFInfoSync(pb)
    }
}
CLA

PAIRFLAGS=--testapi
if detail=$(emit68k_pair parity "$NAME"); then
    t_pass testapi_include_parity
else
    t_fail testapi_include_parity "$detail"
fi
t_done
