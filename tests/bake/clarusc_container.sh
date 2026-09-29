#!/bin/sh
# ClarusC.APPL's container (SE wave 4 Task 7, spec 3.4/W2): the CLIR v9
# runtime library lives in the application's DATA fork, where ClarusC
# finds it through GetAppParms and reads it lazily with file.openRead --
# not in a resource, which the Resource Manager would load whole. Builds
# ClarusC.bin with scripts/build-clarusc-mac.sh and checks, from the
# MacBinary image alone:
#   - the data fork (length at header offset 83) is non-empty, starts
#     with 'CLIR', parses as a 68k-lane library, and is byte-for-byte the
#     library the script baked;
#   - the resource fork (length at 87) has no __clir_bake_68k__ resource,
#     still carries the __clarusc_stamp__ sidecar and the CLFS sources.
#
# CLARUSC_BIN: the script bootstraps from the committed snapshot, which
# may predate the compiler this tree builds (a snapshot regeneration is a
# serialization point), so the test hands it clarusc-current -- the same
# sources, compiled by the snapshot. CLARUSC_MAC_OUT keeps the build out
# of the repo's own build-68k/ClarusC.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"

RESFORK=$TOOLS/resfork
OUT=$WORK/mac
BIN=$OUT/ClarusC.bin

CLARUSC_BIN=$CLARUSC CLARUSC_MAC_OUT=$OUT "$ROOT/scripts/build-clarusc-mac.sh" \
    > "$WORK/build.log" 2>&1 || die "build-clarusc-mac.sh failed: $(tail -5 "$WORK/build.log" | tr '\n' ' ')"
[ -f "$BIN" ] || die "no $BIN (CLARUSC_MAC_OUT ignored?)"

# be32 FILE OFF: the big-endian u32 at byte offset OFF.
be32() {
    od -An -tu1 -j "$2" -N 4 "$1" | awk '{ print (($1 * 256 + $2) * 256 + $3) * 256 + $4 }'
}

dlen=$(be32 "$BIN" 83)
rlen=$(be32 "$BIN" 87)
if [ "$dlen" -gt 0 ]; then
    t_pass data_fork_nonempty
else
    t_fail data_fork_nonempty "MacBinary data fork length is $dlen (the library must live in the data fork)"
fi

dd if="$BIN" of="$WORK/data.clir" bs=128 skip=1 count=$(( (dlen + 127) / 128 )) 2>/dev/null
dd if="$WORK/data.clir" of="$WORK/data.trim" bs=1 count="$dlen" 2>/dev/null
magic=$(dd if="$WORK/data.trim" bs=1 count=4 2>/dev/null)
[ "$magic" = CLIR ] && t_pass data_fork_magic \
    || t_fail data_fork_magic "data fork starts with '$magic', want 'CLIR'"

if "$CLIRHDR" "$WORK/data.trim" > "$WORK/data.hdr" 2> "$WORK/data.err"; then
    lane=$(clir_field lane "$WORK/data.hdr")
    [ "$lane" = 68k ] && t_pass data_fork_library \
        || t_fail data_fork_library "data fork library lane = $lane, want 68k"
else
    t_fail data_fork_library "clirhdr: $(cat "$WORK/data.err")"
fi

cmp -s "$WORK/data.trim" "$OUT/clarusc-mac.clir" && t_pass data_fork_is_bake \
    || t_fail data_fork_is_bake "data fork differs from the script's own bake $OUT/clarusc-mac.clir"

# Padding: the data fork is padded to 128, then the resource fork follows.
expect=$(( 128 + (dlen + 127) / 128 * 128 + (rlen + 127) / 128 * 128 ))
size=$(wc -c < "$BIN" | tr -d ' ')
[ "$size" = "$expect" ] && t_pass macbinary_layout \
    || t_fail macbinary_layout "image is $size bytes, want $expect (128 + padded data $dlen + padded resource $rlen)"

if "$RESFORK" list "$BIN" > "$WORK/res.list" 2> "$WORK/res.err"; then
    if grep -q '"__clir_bake_68k__"' "$WORK/res.list"; then
        t_fail no_clir_resource "resource fork still carries __clir_bake_68k__"
    else
        t_pass no_clir_resource
    fi
    grep -q '^CLFS .* "__clarusc_stamp__"' "$WORK/res.list" && t_pass stamp_resource \
        || t_fail stamp_resource "no CLFS __clarusc_stamp__ resource (feExpectedStamp would refuse every library)"
    grep -q '^CLFS .* "runtime/clarus/core.cla"' "$WORK/res.list" && t_pass clfs_sources \
        || t_fail clfs_sources "no CLFS runtime/clarus/core.cla source resource"
else
    t_fail no_clir_resource "resfork list: $(cat "$WORK/res.err")"
fi
t_done
