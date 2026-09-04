#!/bin/sh
# pbm2icn: TestPbm2Icn + TestPbm2IcnErrors (internal/mactest/
# pbm2icn_test.go) -- scripts/pbm2icn.c turns a 32x32 P1/P4 PBM into Rez
# 'ICN#' (icon + derived transparency mask) and 'ICON' (bare icon)
# resources.
#
# The Go test recomputed the mask with a second BFS in Go; per the phase
# spec (§9 item 7) this script instead CONSTRUCTS a fixture whose answer
# is known by inspection -- a black ring with an enclosed white hole,
# surrounded by border-reachable white -- and checks the specific mask
# bits with od. Nothing here reimplements the flood fill.
. "$(dirname "$0")/../lib.sh"

bin=$WORK/pbm2icn
$CC -Wall -o "$bin" "$ROOT/scripts/pbm2icn.c" > "$WORK/cc.log" 2>&1 \
    || die "cc scripts/pbm2icn.c: $(cat "$WORK/cc.log")"

# --- the fixture, by construction ------------------------------------
# rows 0-7 / 24-31 and cols 0-7 / 24-31 are white and touch the border, so
# the flood fill reaches them: mask 0 (transparent). Rows 8 and 23 plus
# cols 8 and 23 are the black ring: mask 1. The white inside the ring is
# enclosed, so the fill never reaches it: mask 1 (opaque) even though it is
# white -- the whole point of the mask not being a naive icon inversion.
blank=00000000000000000000000000000000
edge_=00000000111111111111111100000000
side_=00000000100000000000000100000000
{
    printf 'P1\n32 32\n'
    i=0
    while [ $i -lt 32 ]; do
        case $i in
            8|23) printf '%s\n' "$edge_" ;;
            9|1[0-9]|2[0-2]) printf '%s\n' "$side_" ;;
            *) printf '%s\n' "$blank" ;;
        esac
        i=$(( i + 1 ))
    done
} > "$WORK/probe.pbm"

# The same bitmap as a P4 (raw) file, packed MSB-first -- both the second
# input encoding and the expected icon bitmap.
LC_ALL=C awk '/^[01]+$/ {
    for (i = 1; i <= 32; i += 8) {
        b = 0
        for (j = 0; j < 8; j++) b = b * 2 + substr($0, i + j, 1)
        printf "%c", b
    }
}' "$WORK/probe.pbm" > "$WORK/raster.bin"
rbytes=$(wc -c < "$WORK/raster.bin" | tr -d ' ')
[ "$rbytes" = 128 ] || die "fixture packing produced $rbytes bytes, want 128"
{ printf 'P4\n32 32\n'; cat "$WORK/raster.bin"; } > "$WORK/probe_p4.pbm"

# --- helpers ---------------------------------------------------------
# run NAME PBM WANTEXIT : run the converter, capture stdout/stderr, check
# the exit code, and (mirroring runPbm2Icn) require a stderr message on
# any nonzero exit. Returns 1 on mismatch, having reported it.
run() {
    _n=$1
    OUT=$WORK/$_n.out
    ERRF=$WORK/$_n.err
    "$bin" "$2" > "$OUT" 2> "$ERRF"
    _rc=$?
    if [ $_rc -ne 0 ] && [ ! -s "$ERRF" ]; then
        t_fail "$_n" "nonzero exit ($_rc) with no stderr message"
        return 1
    fi
    if [ "$_rc" != "$3" ]; then
        t_fail "$_n" "exit $_rc, want $3: $(head -2 "$ERRF" "$OUT" | tr '\n' ' ')"
        return 1
    fi
    return 0
}

# hexblock FIRST LAST FILE OUT : decode Rez $"..." hex lines FIRST..LAST of
# FILE into the binary OUT.
hexblock() {
    sed -n 's/.*\$"\([0-9A-Fa-f ]*\)".*/\1/p' "$3" | sed -n "$1,$2p" \
        | LC_ALL=C awk 'BEGIN { h = "0123456789ABCDEF" }
            { gsub(/ /, "")
              for (i = 1; i <= length($0); i += 2)
                  printf "%c", (index(h, substr($0, i, 1)) - 1) * 16 \
                               + index(h, substr($0, i + 1, 1)) - 1 }' > "$4"
}

# bit_at FILE ROW COL : the row-major, MSB-first bit at (ROW, COL) of a
# 32x32 bitmap, read out of the byte od reports.
bit_at() {
    _i=$(( $2 * 32 + $3 ))
    _v=$(od -An -tu1 -j $(( _i / 8 )) -N 1 "$1" | tr -d ' \n')
    echo $(( ( _v >> ( 7 - _i % 8 ) ) & 1 ))
}

# --- P1 conversion ---------------------------------------------------
if run Convert "$WORK/probe.pbm" 0; then
    p1out=$OUT
    ok=1
    for _hdr in "resource 'ICN#' (128, purgeable)" "resource 'ICON' (128, purgeable)"; do
        grep -qF "$_hdr" "$p1out" || { t_fail Convert "missing $_hdr in output"; ok=0; }
    done
    nlines=$(sed -n 's/.*\$"\([0-9A-Fa-f ]*\)".*/\1/p' "$p1out" | wc -l | tr -d ' ')
    if [ "$nlines" != 24 ]; then
        t_fail Convert "expected 24 hex-string lines (8 ICN# icon + 8 ICN# mask + 8 ICON), got $nlines"
        ok=0
    fi
    [ "$ok" = 1 ] && t_pass Convert
fi

if [ -s "$WORK/Convert.out" ] && [ "${nlines:-0}" = 24 ]; then
    hexblock 1 8   "$WORK/Convert.out" "$WORK/icon.bin"
    hexblock 9 16  "$WORK/Convert.out" "$WORK/mask.bin"
    hexblock 17 24 "$WORK/Convert.out" "$WORK/iconres.bin"

    if cmp -s "$WORK/icon.bin" "$WORK/raster.bin"; then
        t_pass IconBytes
    else
        t_fail IconBytes "ICN# icon bytes != the input bitmap: $(cmp "$WORK/icon.bin" "$WORK/raster.bin" 2>&1 | head -1)"
    fi
    if cmp -s "$WORK/iconres.bin" "$WORK/icon.bin"; then
        t_pass IconResourceBytes
    else
        t_fail IconResourceBytes "ICON resource bytes != the icon (should equal icon, not mask): $(cmp "$WORK/iconres.bin" "$WORK/icon.bin" 2>&1 | head -1)"
    fi

    # Mask semantics, by construction: (15,15) is white and enclosed by the
    # ring -> opaque; (15,0) and (0,0) are white and border-reachable ->
    # transparent; (15,8) is a black ring pixel -> opaque.
    ok=1
    [ "$(bit_at "$WORK/icon.bin" 15 15)" = 0 ] \
        || { t_fail MaskFloodFill "fixture assumption broken: icon bit at the enclosed hole (15,15) is not white"; ok=0; }
    [ "$(bit_at "$WORK/mask.bin" 15 15)" = 1 ] \
        || { t_fail MaskFloodFill "expected opaque mask bit at enclosed hole (row 15 col 15)"; ok=0; }
    [ "$(bit_at "$WORK/mask.bin" 15 0)" = 0 ] \
        || { t_fail MaskFloodFill "expected transparent mask bit at border-reachable white (row 15 col 0)"; ok=0; }
    [ "$(bit_at "$WORK/mask.bin" 0 0)" = 0 ] \
        || { t_fail MaskFloodFill "expected transparent mask bit at border-reachable white (row 0 col 0)"; ok=0; }
    [ "$(bit_at "$WORK/mask.bin" 15 8)" = 1 ] \
        || { t_fail MaskFloodFill "expected opaque mask bit at a black ring pixel (row 15 col 8)"; ok=0; }
    [ "$ok" = 1 ] && t_pass MaskFloodFill

    # --- P4 encoding of the same bitmap: byte-identical Rez output ----
    if run ConvertP4 "$WORK/probe_p4.pbm" 0; then
        if cmp -s "$WORK/Convert.out" "$WORK/ConvertP4.out"; then
            t_pass P1P4Identical
        else
            t_fail P1P4Identical "P4 output differs from P1 output for the same bitmap: $(first_diff "$WORK/Convert.out" "$WORK/ConvertP4.out" | tr '\n' ' ')"
        fi
    fi
else
    t_fail IconBytes "no usable converter output to decode"
fi

# --- error cases (TestPbm2IcnErrors) ---------------------------------
{ printf 'P1\n16 16\n'; i=0; while [ $i -lt 256 ]; do printf '0 '; i=$(( i + 1 )); done; } \
    > "$WORK/small.pbm"
run WrongSize "$WORK/small.pbm" 1 && t_pass WrongSize

printf 'not a pbm file at all\n' > "$WORK/garbage.pbm"
run Garbage "$WORK/garbage.pbm" 1 && t_pass Garbage

run Missing "$WORK/does-not-exist.pbm" 1 && t_pass Missing

t_done
