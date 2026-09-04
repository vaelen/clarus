#!/bin/sh
# Port of internal/bake/bakeidentity_test.go's TestRtbakeIncludeCheckOnly
# (was TestRtbakeIncludeDedupFallback): a user file that directly
# `include`s a baked runtime module -- a bare manifest-key path matching
# bkComputeManifestPaths' own -- USED to trigger an unconditional
# from-source fallback for the whole compile. Task 2's drift guard narrows
# that: the on-disk file is unmodified, so its hash matches the baked
# copy's, and non-testapi has no preloaded checker symbols to collide with,
# so the compile takes the real check-only-include bake path (no "falling
# back" note at all) and stays byte-identical to plain from-source.
#
# Two subcases: CoreCla is a top-level runtime module with real funcs/
# globals/strlits; ToolboxFiles is a NESTED-include catalog file
# (toolbox/files.cla, reached only via runtime/clarus/uidialogs.cla's own
# `include`) that is pure extern/record declarations -- a collision target
# with a real call site but zero lowered bodies of its own.
#
# Both fixtures must live AT THE REPO ROOT: their `include` paths are
# repo-root-relative and resolve against the FIXTURE's own location, not
# the cwd. The EXIT trap is re-armed to remove them (and still $WORK,
# lib.sh's own trap being replaced, not chained).
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"

FX_CORE=$ROOT/checkonly_fixture_core.cla
FX_TB=$ROOT/checkonly_fixture_toolbox_files.cla
trap 'rm -rf "$WORK"; rm -f "$FX_CORE" "$FX_TB"' EXIT

BAKE=$WORK/rt68k.clir
bake_ir 68k "$BAKE"

cat > "$FX_CORE" <<'CLA'
include "runtime/clarus/core.cla"

func main() {
    log("hello from the dedup fallback fixture")
}
CLA

cat > "$FX_TB" <<'CLA'
include "toolbox/files.cla"

func main() {
    var pb: ptr
    var r: int
    r = PBGetFInfoSync(pb)
}
CLA

if detail=$(emit68k_pair CoreCla checkonly_fixture_core.cla); then
    t_pass CoreCla
else
    t_fail CoreCla "$detail"
fi

if detail=$(emit68k_pair ToolboxFiles checkonly_fixture_toolbox_files.cla); then
    t_pass ToolboxFiles
else
    t_fail ToolboxFiles "$detail"
fi
t_done
