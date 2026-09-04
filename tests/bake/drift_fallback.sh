#!/bin/sh
# Port of internal/bake/bakeidentity_test.go's TestRtbakeDriftFallback:
# proves the drift guard itself. When the on-disk copy of a manifest path
# no longer matches the hash baked into the CLIR artifact, --rtbake falls
# back to a from-source compile for that ONE compile, naming the drifted
# file in its own log line (drive.cla's haveRtbake branch), and the result
# is byte-identical to a plain from-source compile of the same drifted tree.
#
# Bakes from a PRIVATE copy of runtime/clarus/ + toolbox/ (via --rtdir at
# bake time) so the mutation never touches anything git tracks. No --rtdir
# override at COMPILE time, matching the Go original: toolbox/files.cla is
# a NESTED include, so its manifest-path identity comes from the baked
# declFileTab's verbatim bake-time string, and the fixture -- placed at the
# SAME tmpRoot the bake's --rtdir pointed into -- resolves its own
# `include "toolbox/files.cla"` to that exact string.
. "$(dirname "$0")/../lib.sh"
. "$(dirname "$0")/../lib_bake.sh"

# Collapse doubled slashes first: TMPDIR usually ends in "/", so lib.sh's
# own mktemp template leaves $WORK looking like ".../T//clarus-test.XXXX",
# and clarusc normalizes that away in the path it names in the drift note --
# so the note would never match a $WORK-derived expectation verbatim.
TMPROOT=$(printf '%s' "$WORK/root" | sed 's|//*|/|g')
mkdir -p "$TMPROOT/runtime/clarus" "$TMPROOT/toolbox" || die mkdir
cp -R runtime/clarus/. "$TMPROOT/runtime/clarus/" || die "copyTree runtime/clarus"
cp -R toolbox/. "$TMPROOT/toolbox/" || die "copyTree toolbox"

RTDIR_TMP=$TMPROOT/runtime/clarus
BAKE=$TMPROOT/rt68k.clir
"$CLARUSC" --bake-ir --lane 68k -o "$BAKE" --rtdir "$RTDIR_TMP" > "$WORK/bakeir.log" 2>&1 \
    || die "--bake-ir --rtdir $RTDIR_TMP: $(head -3 "$WORK/bakeir.log" | tr '\n' ' ')"

# Append a comment line AFTER baking -- the baked hash reflects the
# pre-mutation bytes, so this is genuine drift.
TBFILES=$TMPROOT/toolbox/files.cla
printf '// drift marker (Task 3 fixture)\n' >> "$TBFILES" || die "append drift marker"

FIXTURE=$TMPROOT/drift_fixture.cla
cat > "$FIXTURE" <<'CLA'
include "toolbox/files.cla"

func main() {
    var pb: ptr
    var r: int
    r = PBGetFInfoSync(pb)
}
CLA

WANTLOG="clarusc --rtbake: $TBFILES differs from the baked copy; falling back to a from-source compile"

mkdir -p "$TMPROOT/bake-out" "$TMPROOT/src-out" || die mkdir
BAKEOUT=$TMPROOT/bake-out/drift.bin
SRCOUT=$TMPROOT/src-out/drift.bin

if "$CLARUSC" emit68k --rtbake "$BAKE" -o "$BAKEOUT" "$FIXTURE" > "$WORK/bake.log" 2>&1; then
    t_pass bake_compiles
    if grep -qF "$WANTLOG" "$WORK/bake.log"; then
        t_pass drift_note
    else
        t_fail drift_note "expected the drift log line: $WANTLOG -- got: $(head -5 "$WORK/bake.log" | tr '\n' ' ')"
    fi
else
    t_fail bake_compiles "--rtbake compile of the drifted fixture failed: $(head -5 "$WORK/bake.log" | tr '\n' ' ')"
    t_fail drift_note "--rtbake compile failed"
fi

if "$CLARUSC" emit68k -o "$SRCOUT" "$FIXTURE" > "$WORK/src.log" 2>&1; then
    t_pass src_compiles
else
    t_fail src_compiles "plain from-source compile of the drifted tree failed: $(head -5 "$WORK/src.log" | tr '\n' ' ')"
fi

if [ -f "$BAKEOUT" ] && [ -f "$SRCOUT" ] && cmp -s "$BAKEOUT" "$SRCOUT"; then
    t_pass identity
else
    t_fail identity "--rtbake fallback compile ($(wc -c < "$BAKEOUT" 2>/dev/null | tr -d ' ') bytes) != plain from-source compile ($(wc -c < "$SRCOUT" 2>/dev/null | tr -d ' ') bytes) of the same drifted tree"
fi
t_done
