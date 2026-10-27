#!/bin/sh
# cg68k/freeglobals -- SE wave 5 (spec 3.2/W2): cg_free_globals is a loop
# over a per-segment (A5 offset, kind) table instead of one unrolled
# release per global. For every testdata/cg68k/freeglobals/*.cla fixture:
#   - the C lane builds and runs it to a clean `quit 0`;
#   - native build68k builds it;
#   - with a .order file: the table (CLARUS_FREEGLOBALS_DUMP=1's
#     `freeglobals: SEG IDX A5OFF KIND` lines, every segment) equals the
#     release order the pre-table unrolled code visited, dumped once from
#     that code (f5a38fc1 plus a probe) and committed;
#   - multiseg: fgQuitter lands in segment >= 2 and its quit site BSRs
#     that segment's OWN cg_free_globals label;
#   - (needs vasm, last) each segment's cg_free_globals, table included,
#     is at most 512 bytes + 4 per table entry.
# none.cla has no handle-typed globals of its own; the always-spliced
# runtime (tcp.cla's text[8], ...) still owns some, so no native program
# reaches the empty no-table body today.
. "$(dirname "$0")/../lib.sh" || exit 2

FDIR=testdata/cg68k/freeglobals
FIXTURES="none records containers multiseg"

for f in $FIXTURES; do
    src=$FDIR/$f.cla
    [ -f "$src" ] || die "missing fixture $src"
    run=$WORK/$f
    mkdir -p "$run" || die "mkdir $run"

    if host_build "$run/host" "$src" > "$run/host.log" 2>&1 && "$run/host" >> "$run/host.log" 2>&1; then
        t_pass "${f}_host"
    else
        t_fail "${f}_host" "C-lane build/run failed: $(tail -3 "$run/host.log" | tr '\n' ' ')"
    fi

    if CLARUS_FREEGLOBALS_DUMP=1 build68k -o "$run/out.bin" --listing "$src" > "$run/emit.log" 2>&1; then
        t_pass "${f}_emit68k"
    else
        t_fail "${f}_emit68k" "build68k failed: $(tail -3 "$run/emit.log" | tr '\n' ' ')"
        continue
    fi
    grep '^freeglobals: ' "$run/emit.log" > "$run/dump"

    if [ -f "$FDIR/$f.order" ]; then
        if cmp -s "$FDIR/$f.order" "$run/dump"; then
            t_pass "${f}_order"
        else
            t_fail "${f}_order" "table order differs from the unrolled order: $(diff "$FDIR/$f.order" "$run/dump" | head -4 | tr '\n' ' ')"
        fi
    fi
done

# multiseg: the quit site in segment >= 2 reaches its own segment's copy.
B=$WORK/multiseg/out
qs=$(grep -l '; func fgQuitter ' "$B".seg*.s 2>/dev/null | head -1)
qseg=${qs##*.seg}
qseg=${qseg%.s}
if [ -z "$qs" ]; then
    t_fail multiseg_quit_site "fgQuitter not found in any segment listing"
elif [ "$qseg" -lt 2 ]; then
    t_fail multiseg_quit_site "fgQuitter packed into segment $qseg, want >= 2 (grow the fixture)"
else
    fglbl=$(awk '/^LBL_[0-9]+:$/ { l = $1 } /; cg_free_globals$/ { sub(/:$/, "", l); print l; exit }' "$qs")
    bsrs=$(awk '/; func fgQuitter /{p=1; next} p && /; (func |cg_)/{exit} p && $1 == "BSR.W" { print $2 }' "$qs")
    if [ -n "$fglbl" ] && echo "$bsrs" | grep -qx "$fglbl"; then
        t_pass "multiseg_quit_site (segment $qseg, $fglbl)"
    else
        t_fail multiseg_quit_site "segment $qseg: fgQuitter BSRs [$(echo $bsrs)] do not include its cg_free_globals label '$fglbl'"
    fi
fi

require_vasm

# fgsize LISTING: cg_free_globals' byte size -- label the region's start
# and the next routine's start, assemble with vasm, subtract.
fgsize() {
    awk '/; cg_free_globals$/ { print "ZFGSTART:"; p = 1; print; next }
         p == 1 && /^ *; (func |cg_|constant pool)/ { print "ZFGEND:"; p = 2 }
         { print }
         END { if (p == 1) print "ZFGEND:" }' "$1" > "$1.fg.s"
    "$VASM" -quiet -m68000 -no-opt -Fbin -o "$1.fg.bin" -L "$1.fg.lst" "$1.fg.s" > /dev/null 2>&1 || return 1
    awk 'function hex(s,  i, v) {
             v = 0
             for (i = 1; i <= length(s); i++)
                 v = v * 16 + index("0123456789ABCDEF", toupper(substr(s, i, 1))) - 1
             return v
         }
         /^ZFG(START|END) +A:/ { v = $NF; sub(/^A:/, "", v); a[$1] = hex(v) }
         END { print a["ZFGEND"] - a["ZFGSTART"] }' "$1.fg.lst"
}

for f in $FIXTURES; do
    B=$WORK/$f/out
    [ -f "$B.seg1.s" ] || continue
    bad=
    seg=1
    while [ -f "$B.seg$seg.s" ]; do
        n=$(awk -v s=$seg '$2 == s' "$WORK/$f/dump" | wc -l | tr -d ' ')
        limit=$((512 + 4 * n))
        if ! sz=$(fgsize "$B.seg$seg.s"); then
            bad="$bad seg$seg(vasm)"
        elif [ "$sz" -gt "$limit" ]; then
            bad="$bad seg$seg:${sz}>${limit}"
        fi
        seg=$((seg + 1))
    done
    if [ -n "$bad" ]; then
        t_fail "${f}_size" "cg_free_globals over 512 + 4/entry:$bad"
    else
        t_pass "${f}_size (seg1 $(fgsize "$B.seg1.s") bytes)"
    fi
done
t_done
