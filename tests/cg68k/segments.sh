#!/bin/sh
# tests/cg68k/segments.sh -- port of internal/cg68k/segment_test.go:
# TestSegmentationMultiSegment (real multi-segment CODE packing on the core
# suite's CLI composition), TestSegmentationOversizedFunction and
# TestSegmentationOversizedFrame (compile errors, not crashes).
#
# Subcase order follows Go's own vasm dependency, not this file's reading
# order: segment_test.go calls requireVasm(t) only at the round-trip step,
# so everything it asserts before that -- plus the two oversized tests,
# which are separate Go tests that never touch vasm -- runs above the
# `require_vasm` gate below. Without the vasm symlink this script still
# reports those eight subcases, then exits 77 exactly where Go skips.
. "$(dirname "$0")/../lib.sh"

RESFORK=$TOOLS/resfork

# -- fixture: test-suite-review Task 9's core suite CLI composition (the
# same multi-file build internal/mactest's suite boots), big enough to
# exceed the classic 32KB single-segment limit. Kept in segment_test.go's
# own order; every cases_*.cla listed there is required, because
# core/runner.cla calls each family's entry point unconditionally.
FIXTURE="testsuite/kit.cla
testsuite/core/runner.cla
testsuite/core/cases_str.cla
testsuite/core/cases_text.cla
testsuite/core/cases_list.cla
testsuite/core/cases_map.cla
testsuite/core/cases_sortedmap.cla
testsuite/core/cases_intmap.cla
testsuite/core/cases_rec.cla
testsuite/core/cases_arr.cla
testsuite/core/cases_enumfix.cla
testsuite/core/cases_ser.cla
testsuite/core/cases_misc.cla
testsuite/core/cases_xrec.cla
testsuite/core/cases_datetime.cla
testsuite/core/cases_param.cla
testsuite/core/cases_abort.cla
testsuite/core/cases_textrange.cla
testsuite/core/cases_errret.cla
testsuite/core/cases_evalorder.cla
testsuite/core/cases_textbinary.cla
testsuite/core/cases_fileh.cla
testsuite/core/cases_dirops.cla
testsuite/core/cases_ptrcall.cla
testsuite/core/cli_mac.cla"
# lib.sh already cd'd to $ROOT, so these relative paths are what clarusc
# sees; $@ carries them for the three emit68k runs below.
set -- $FIXTURE
for f in "$@"; do
    [ -f "$f" ] || die "missing fixture file $f"
done

D1=$WORK/run1
D2=$WORK/run2
D3=$WORK/run3
mkdir -p "$D1" "$D2" "$D3" || die "mkdir"

if ! emit68k -o "$D1/out.bin" --listing "$@" > "$D1/emit.log" 2>&1; then
    t_fail multisegment "emit68k --listing failed: $(tail -5 "$D1/emit.log")"
    t_done
fi
IMG=$D1/out.bin
BASE=$D1/out

# -- more than one CODE segment: this test's whole reason to exist --
segcount=0
while [ -f "$BASE.seg$(( segcount + 1 )).s" ]; do
    segcount=$(( segcount + 1 ))
done
if [ "$segcount" -gt 1 ]; then
    t_pass multisegment
else
    t_fail multisegment "core CLI composition produced $segcount CODE segment(s), want >1 -- the fixture exceeds the 32KB single-segment limit"
    t_done
fi

# -- resource inventory: CODE 0..segcount plus exactly one SIZE(-1) --
if ! lst=$("$RESFORK" list "$IMG" 2>&1); then
    t_fail inventory "$lst"
    t_done
fi
inv=$(echo "$lst" | awk '{print $1, $2}' | sort)
wantinv=$(awk -v n="$segcount" 'BEGIN{for(i=0;i<=n;i++) print "CODE", i; print "SIZE", -1}' | sort)
if [ "$inv" = "$wantinv" ]; then
    t_pass inventory
else
    t_fail inventory "resources [$(echo "$inv" | tr '\n' ',')], want CODE 0..$segcount + SIZE -1"
fi

# -- CODE 0's jump table: every slot well-formed and inside its OWN
# owning segment's code range (resfork appends BAD when it isn't) --
if ! c0=$("$RESFORK" code0 "$IMG" 2>&1); then
    t_fail jumptable "$c0"
    t_done
fi
# (Parsed with sed, not `set --`: $@ still holds the fixture file list.)
jtsize=$(echo "$c0" | sed -n '1s/.*jt_size=\([0-9]*\).*/\1/p')
nentries=$(( jtsize / 8 ))
slots=$(echo "$c0" | tail -n +2)
badslots=$(echo "$slots" | grep -n 'BAD$' | head -3)
if [ -z "$badslots" ] && [ "$nentries" -gt 0 ]; then
    t_pass jumptable
else
    t_fail jumptable "$nentries entries, malformed slot(s): $(echo "$badslots" | tr '\n' ';')"
fi
# JT entry 0 is the synthesized startup routine: offset 0, and Startup
# always stays in CODE 1.
slot0=$(echo "$slots" | head -1)
if [ "$slot0" = "slot 1 0 filler=3F3C trailer=A9F0" ]; then
    t_pass jt_slot0
else
    t_fail jt_slot0 "JT entry 0 (startup, JT slot 0) = [$slot0], want [slot 1 0 filler=3F3C trailer=A9F0]"
fi
# Every real segment must own at least one JT entry -- otherwise
# cg68WriteImage built a CODE resource nothing ever points at.
segsseen=$(echo "$slots" | awk '{print $2}' | sort -n -u)
wantsegs=$(awk -v n="$segcount" 'BEGIN{for(i=1;i<=n;i++) print i}' | sort -n -u)
if [ "$segsseen" = "$wantsegs" ]; then
    t_pass segments_own_slots
else
    t_fail segments_own_slots "segments owning JT entries = [$(echo "$segsseen" | tr '\n' ',')], want 1..$segcount"
fi

# -- every cross-segment `JSR d16(A5)` aims at a slot's ENTRY POINT (+2) --
#
# Both forms of a classic 8-byte JT entry keep their first word as DATA
# (routine offset when unloaded, segment number once _LoadSeg has patched
# it) and their code at entry+2, so a cross-segment call must satisfy
# (d16 - 32) % 8 == 2. Aiming at the entry start executes that data word
# as an opcode.
: > "$WORK/disp.txt"
n=1
while [ "$n" -le "$segcount" ]; do
    grep -o -E 'JSR[[:space:]]+-?[0-9]+\(A5\)' "$BASE.seg$n.s" \
        | sed "s/^JSR[[:space:]]*//; s/(A5)\$//; s/^/$n /" >> "$WORK/disp.txt"
    n=$(( n + 1 ))
done
ncalls=0
badcalls=
while read -r seg d; do
    ncalls=$(( ncalls + 1 ))
    if [ "$d" -lt 32 ] || [ $(( (d - 32) % 8 )) -ne 2 ]; then
        badcalls="$badcalls segment $seg: JSR $d(A5) targets JT byte $d, not a slot entry point (want d >= 32 and (d-32)%8 == 2);"
        continue
    fi
    if [ $(( (d - 34) / 8 )) -ge "$nentries" ]; then
        badcalls="$badcalls segment $seg: JSR $d(A5) targets JT slot $(( (d - 34) / 8 )), past the last slot $(( nentries - 1 ));"
    fi
done < "$WORK/disp.txt"
if [ "$ncalls" -eq 0 ]; then
    t_fail jt_entry_points "no cross-segment JSR d16(A5) call sites found in a multi-segment build -- the entry-point assertion is vacuous"
elif [ -z "$badcalls" ]; then
    t_pass jt_entry_points
else
    t_fail jt_entry_points "$(echo "$badcalls" | cut -c1-400)"
fi
# segment_test.go's own t.Logf, plus the two counts that prove the checks
# above aren't vacuous.
echo "info: $segcount CODE segment(s), $nentries JT entries, $ncalls cross-segment JSR d16(A5) call site(s)"

# -- oversized function: a diagnostic, not a crash --
OD=$WORK/oversized
mkdir -p "$OD" || die "mkdir"
{
    echo 'func hugefn(): int {'
    echo '    var x: int'
    echo '    x = 0'
    awk 'BEGIN{for(i=0;i<6000;i++) printf "    x = x + %d\n", i}'
    echo '    return x'
    echo '}'
    echo 'on App.launch {'
    echo '    var r: int'
    echo '    r = hugefn()'
    echo '}'
} > "$OD/oversized.cla"
if emit68k -o "$OD/out.bin" "$OD/oversized.cla" > "$OD/emit.log" 2>&1; then
    t_fail oversized_function "emit68k unexpectedly succeeded on an oversized function"
elif ! grep -q 'function hugefn exceeds the 32KB segment limit' "$OD/emit.log"; then
    t_fail oversized_function "expected the named oversized-function error, got: $(tail -3 "$OD/emit.log")"
elif [ -e "$OD/out.bin" ]; then
    t_fail oversized_function "emit68k left a .bin behind despite the oversized-function error"
else
    t_pass oversized_function
fi

# -- oversized frame: 70 `"a" + "N"` call-argument temps (70*512 = 35840
# bytes) overflow the caller's 32767-byte A6 frame cap. The overflowing
# frame belongs to the CALLER, so assert the message shape, not a name.
FD=$WORK/oversizedframe
mkdir -p "$FD" || die "mkdir"
awk 'BEGIN{
    n = 70
    printf "func takeMany("
    for (i = 1; i <= n; i++) { if (i > 1) printf ", "; printf "p%d: string", i }
    printf "): int {\n    return "
    for (i = 1; i <= n; i++) { if (i > 1) printf " + "; printf "p%d.length", i }
    printf "\n}\n"
    printf "on App.startCLI(args: list of string) {\n    var n: int\n    n = takeMany("
    for (i = 1; i <= n; i++) { if (i > 1) printf ", "; printf "\"a\" + \"%d\"", i }
    printf ")\n    quit 0\n}\n"
}' > "$FD/oversizedframe.cla"
if emit68k -o "$FD/out.bin" "$FD/oversizedframe.cla" > "$FD/emit.log" 2>&1; then
    t_fail oversized_frame "emit68k unexpectedly succeeded on a function needing a >32KB frame"
elif ! grep -q 'needs a' "$FD/emit.log" \
    || ! grep -q -- '-byte frame' "$FD/emit.log" \
    || ! grep -q -- 'caps frames at 32767 bytes -- split the function or the statement' "$FD/emit.log"; then
    t_fail oversized_frame "expected the named oversized-frame error, got: $(tail -3 "$FD/emit.log")"
elif [ -e "$FD/out.bin" ]; then
    t_fail oversized_frame "emit68k left a .bin behind despite the oversized-frame error"
else
    t_pass oversized_frame
fi

# -- vasm gate: everything above reproduces what Go asserts BEFORE
# segment_test.go's own requireVasm(t) call, plus the two oversized tests
# (separate Go tests that never touch vasm). Only the round trip and the
# determinism check below sit after the gate, exactly as Go loses both --
# and a FAIL already printed must never be hidden by exit 77.
[ "$STATUS" = 0 ] || t_done
require_vasm

# -- per-segment vasm round trip on every .segN.s/.segN.dat pair --
rtfail=
n=1
while [ "$n" -le "$segcount" ]; do
    if ! "$VASM" -quiet -m68000 -no-opt -Fbin -o "$WORK/vasm_seg$n.bin" "$BASE.seg$n.s" > "$WORK/vasm_seg$n.log" 2>&1; then
        rtfail="$rtfail segment $n: vasm assemble failed: $(tail -2 "$WORK/vasm_seg$n.log");"
    elif ! cmp -s "$BASE.seg$n.dat" "$WORK/vasm_seg$n.bin"; then
        rtfail="$rtfail segment $n: vasm round-trip diverged: $(cmp "$BASE.seg$n.dat" "$WORK/vasm_seg$n.bin" 2>&1 | head -1);"
    fi
    n=$(( n + 1 ))
done
if [ -z "$rtfail" ]; then
    t_pass vasm_roundtrip
else
    t_fail vasm_roundtrip "$rtfail"
fi

# -- double-emit determinism on the multi-segment image itself --
if ! emit68k -o "$D2/out.bin" "$@" > "$D2/emit.log" 2>&1; then
    t_fail determinism "emit68k (run 2) failed: $(tail -5 "$D2/emit.log")"
elif ! emit68k -o "$D3/out.bin" "$@" > "$D3/emit.log" 2>&1; then
    t_fail determinism "emit68k (run 3) failed: $(tail -5 "$D3/emit.log")"
elif cmp -s "$D2/out.bin" "$D3/out.bin"; then
    t_pass determinism
else
    t_fail determinism "emit68k is non-deterministic on a multi-segment build: $(cmp "$D2/out.bin" "$D3/out.bin" 2>&1 | head -1)"
fi

t_done
