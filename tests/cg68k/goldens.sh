#!/bin/sh
# timeout: 15m
# cg68k/goldens -- port of internal/cg68k/golden_test.go's TestCg68kGoldens.
# For every testdata/cg68k/*.cla fixture: `clarusc emit68k -o out.bin
# --listing <fixture>` in a fresh dir, then compare EVERY emitted
# out.segN.s against its own committed golden (segment 1 keeps the
# un-suffixed <name>.s; segment N>1 uses <name>.segN.s).
# CLARUS_CG68K_BLESS=1 rewrites the goldens instead of comparing.
. "$(dirname "$0")/../lib.sh"

GDIR=$ROOT/testdata/cg68k

# golden_path BASE SEG
golden_path() {
    if [ "$2" = 1 ]; then echo "$GDIR/$1.s"; else echo "$GDIR/$1.seg$2.s"; fi
}

nfix=0
for fixture in "$GDIR"/*.cla; do
    [ -f "$fixture" ] || continue
    nfix=$((nfix + 1))
    name=${fixture##*/}
    base=${name%.cla}
    run=$WORK/g_$base
    mkdir -p "$run" || die "mkdir $run"

    # Mirrors the Go test exactly: no --rtdir (findRtDir's upward search).
    if ! out=$("$CLARUSC" emit68k -o "$run/out.bin" --listing "$fixture" 2>&1); then
        t_fail "$name" "clarusc emit68k -o $run/out.bin --listing $fixture failed"
        echo "$out"
        continue
    fi

    # segCount: how many out.segN.s listings emit68k wrote (>=1 required).
    n=0
    while [ -f "$run/out.seg$((n + 1)).s" ]; do n=$((n + 1)); done
    if [ "$n" -eq 0 ]; then
        t_fail "$name" "no out.seg*.s listings found in $run"
        continue
    fi

    bad=
    seg=1
    while [ "$seg" -le "$n" ]; do
        segS=$run/out.seg$seg.s
        golden=$(golden_path "$base" "$seg")
        if env_set CLARUS_CG68K_BLESS; then
            golden_check "$segS" "$golden" CLARUS_CG68K_BLESS
        elif [ ! -f "$golden" ]; then
            echo "missing golden $golden (run with CLARUS_CG68K_BLESS=1 to create it)"
            bad="$bad seg$seg(no golden)"
        elif ! golden_check "$segS" "$golden" CLARUS_CG68K_BLESS; then
            bad="$bad seg$seg"
        fi
        seg=$((seg + 1))
    done

    # A golden that exists for a segment this fixture did NOT emit is a
    # failure too: it is a stale file that nothing compares any more.
    # (Skipped under bless: blessing writes segments 1..n and must never FAIL.)
    if ! env_set CLARUS_CG68K_BLESS; then
        for g in "$GDIR/$base".seg*.s; do
            [ -f "$g" ] || continue
            gb=${g##*/}
            gn=${gb#"$base".seg}
            gn=${gn%.s}
            case "$gn" in
                ''|*[!0-9]*) continue ;;
            esac
            if [ "$gn" -gt "$n" ]; then
                echo "stale golden $g: fixture emitted only $n segment(s)"
                bad="$bad stale-seg$gn"
            fi
        done
    fi

    if [ -n "$bad" ]; then
        t_fail "$name" "listing does not match golden(s):$bad"
    else
        t_pass "$name"
    fi
done

[ "$nfix" -gt 0 ] || die "no testdata/cg68k/*.cla fixtures found"
t_done
