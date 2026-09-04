#!/bin/sh
# timeout: 15m
# cg68k/vasm -- port of internal/cg68k/golden_test.go's
# TestCg68kVasmRoundTrip. For every testdata/cg68k/*.cla fixture and EVERY
# segment it emits, assemble the just-emitted out.segN.s with vasm and
# require the result to be byte-identical to out.segN.dat (cg68k.cla's own
# encoder, via asm68k.cla's a68Bytes()).
. "$(dirname "$0")/../lib.sh"

require_vasm

GDIR=$ROOT/testdata/cg68k

nfix=0
for fixture in "$GDIR"/*.cla; do
    [ -f "$fixture" ] || continue
    nfix=$((nfix + 1))
    name=${fixture##*/}
    base=${name%.cla}
    run=$WORK/v_$base
    mkdir -p "$run" || die "mkdir $run"

    if ! out=$("$CLARUSC" emit68k -o "$run/out.bin" --listing "$fixture" 2>&1); then
        t_fail "$name" "clarusc emit68k -o $run/out.bin --listing $fixture failed"
        echo "$out"
        continue
    fi

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
        segDat=$run/out.seg$seg.dat
        vasmOut=$run/vasm_out.seg$seg.bin
        if ! out=$("$VASM" -quiet -m68000 -no-opt -Fbin -o "$vasmOut" "$segS" 2>&1); then
            echo "vasm assemble $segS failed"
            echo "$out"
            bad="$bad seg$seg(vasm)"
        elif [ ! -f "$segDat" ]; then
            echo "read $segDat: no such file"
            bad="$bad seg$seg(no .dat)"
        elif ! cmp -s "$segDat" "$vasmOut"; then
            echo "$name seg$seg: vasm round-trip diverged (encoder $(wc -c < "$segDat" | tr -d ' ') bytes, vasm $(wc -c < "$vasmOut" | tr -d ' ') bytes)"
            cmp "$segDat" "$vasmOut" 2>&1 | head -1
            bad="$bad seg$seg"
        fi
        seg=$((seg + 1))
    done

    if [ -n "$bad" ]; then
        t_fail "$name" "vasm round-trip diverged:$bad"
    else
        t_pass "$name"
    fi
done

[ "$nfix" -gt 0 ] || die "no testdata/cg68k/*.cla fixtures found"
t_done
