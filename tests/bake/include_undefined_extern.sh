#!/bin/sh
# Port of internal/bake/bakeidentity_test.go's
# TestRtbakeIncludeCheckOnlyUndefinedExternNegative: include_checkonly.sh's
# negative twin. The fixture includes toolbox/files.cla (a real manifest
# collision, hash-equal, check-only include) but references SFGetFile and
# SFReply -- both declared in toolbox/standardfile.cla, a DIFFERENT nested
# include reached via the SAME early-spliced module (uidialogs.cla:10-11
# includes both) -- so a check-only include that accidentally widened
# visibility to its own SIBLING manifest module would compile this where
# from-source errors. SFReply (an extern record used as a var's type) aims
# at the field-info visibility gap: bkInstallFieldInfo installs
# recFieldsHeadByName for every baked record with no visibility gate.
#
# The fixture must live at the repo root (repo-root-relative include); the
# EXIT trap is re-armed to remove it, and still $WORK.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"

NAME=checkonly_undefined_extern_fixture.cla
FIXTURE=$ROOT/$NAME
trap 'rm -rf "$WORK"; rm -f "$FIXTURE"' EXIT

BAKE=$WORK/rt68k.clir
bake_ir 68k "$BAKE"

cat > "$FIXTURE" <<'CLA'
include "toolbox/files.cla"

func main() {
    var pb: ptr
    var r: int
    var reply: SFReply
    r = PBGetFInfoSync(pb)
    SFGetFile(pb)
}
CLA

if "$CLARUSC" emit68k -o "$WORK/src.bin" "$NAME" > "$WORK/src.log" 2>&1; then
    t_fail src_exit "from-source: referencing SFReply/SFGetFile (declared only in toolbox/standardfile.cla, not toolbox/files.cla): expected failure, got success: $(head -3 "$WORK/src.log" | tr '\n' ' ')"
else
    t_pass src_exit
fi

if "$CLARUSC" emit68k --rtbake "$BAKE" -o "$WORK/bake.bin" "$NAME" > "$WORK/bake.log" 2>&1; then
    t_fail bake_exit "--rtbake: referencing SFReply/SFGetFile (declared only in toolbox/standardfile.cla, not toolbox/files.cla): expected failure, got success: $(head -3 "$WORK/bake.log" | tr '\n' ' ')"
else
    t_pass bake_exit
fi

for want in 'undefined: SFReply' 'undefined: SFGetFile'; do
    tag=$(echo "$want" | sed 's/undefined: //')
    if grep -q "$want" "$WORK/src.log"; then
        t_pass "src/$tag"
    else
        t_fail "src/$tag" "from-source diagnostic missing \"$want\": $(head -5 "$WORK/src.log" | tr '\n' ' ')"
    fi
    if grep -q "$want" "$WORK/bake.log"; then
        t_pass "bake/$tag"
    else
        t_fail "bake/$tag" "--rtbake diagnostic missing \"$want\": $(head -5 "$WORK/bake.log" | tr '\n' ' ')"
    fi
done
t_done
