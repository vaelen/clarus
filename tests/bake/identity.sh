#!/bin/sh
# Port of internal/bake/bakeidentity_test.go's TestBakePathByteIdentity:
# for every fixture in its cg68kFixtures slice plus a self-compile,
# `emit68k --rtbake` must produce a byte-identical fork to plain
# from-source `emit68k`. Host-only, no emulator.
#
# The slice is the six multi-segment testdata/cg68k fixtures the Go file
# names verbatim; the exhaustive no-allowlist sweep is
# full_corpus_cg68k.sh (CLARUS_BAKE_FULL=1).
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"

BAKE=$WORK/rt68k.clir
bake_ir 68k "$BAKE"

for f in tickprobe.cla bounce.cla arc.cla clear_deep.cla smoke.cla strcontainers.cla; do
    if detail=$(emit68k_pair "$f" "$ROOT/testdata/cg68k/$f"); then
        t_pass "$f"
    else
        t_fail "$f" "$detail"
    fi
done

if detail=$(emit68k_pair self-compile clarusc/main.cla); then
    t_pass self-compile
else
    t_fail self-compile "$detail"
fi
t_done
