#!/bin/sh
# lowlevel/boxsize68k.sh -- SE wave 2 final-review I2 guard. The 68k
# container box sizes in runtime/clarus/boxsize_68k.cla (datetime_68k.cla
# until SE wave 3) carry ZERO slack:
# each must equal 4 x its overlay record's field count, and every field must
# be a 4-byte type on 68k (int/ptr). A field added to RtText/RtList/RtMap/
# RtSortedMap without bumping the const under-sizes every native box (heap
# corruption on native boots only -- the host lane keeps 2x slack).
. "$(dirname "$0")/../lib.sh" || exit 2

RT=$ROOT/runtime/clarus
DT=$RT/boxsize_68k.cla
[ -f "$DT" ] || die "missing $DT"

# check RECORD FILE CONST
check() {
    rec=$1 src=$RT/$2.cla const=$3
    [ -f "$src" ] || { t_fail "$rec" "missing $src"; return; }
    # Field lines of `overlay record REC {` up to its closing `}`; prints
    # "count bad" where bad lists fields whose type is not int/ptr.
    res=$(awk -v rec="$rec" '
        $0 ~ "^overlay record " rec " \\{" { inrec = 1; found = 1; next }
        inrec && /^}/ { inrec = 0; next }
        inrec && /:/ {
            n++
            t = $0; sub(/^[^:]*:[ \t]*/, "", t); sub(/[ \t]*(\/\/.*)?$/, "", t)
            if (t != "int" && t != "ptr") bad = bad " " $1 t
        }
        END { if (found) print n + 0, bad; else print "NOTFOUND" }' "$src")
    case "$res" in
        NOTFOUND*) t_fail "$rec" "no 'overlay record $rec {' in $src"; return ;;
    esac
    n=${res%% *}
    bad=${res#"$n"}
    [ "$n" -gt 0 ] || { t_fail "$rec" "no fields parsed in $src"; return; }
    [ -z "${bad# }" ] || { t_fail "$rec" "non-4-byte field(s):$bad"; return; }
    val=$(sed -n "s/^const $const: int = \([0-9][0-9]*\)[ \t]*\$/\1/p" "$DT")
    [ -n "$val" ] || { t_fail "$rec" "no 'const $const: int = N' in $DT"; return; }
    if [ "$val" -eq $((n * 4)) ]; then
        t_pass "$rec"
    else
        t_fail "$rec" "$const = $val but $rec has $n fields (need $((n * 4)))"
    fi
}

check RtText text rtTextBoxSize
check RtList list rtListBoxSize
check RtMap map rtMapBoxSize
check RtSortedMap sortedmap rtSortedMapBoxSize
t_done
