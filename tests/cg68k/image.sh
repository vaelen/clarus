#!/bin/sh
# tests/cg68k/image.sh -- port of internal/cg68k/image_test.go:
# TestImageStructure (MacBinary header fields, resource-fork self-
# consistency, CODE 0's jump table, CODE 1's header, SIZE(-1)'s exact 10
# bytes) and TestImageDeterminism (two emits, byte-identical). The
# CRC-16/XMODEM vector test (TestCrc16XmodemVector) is resfork's own
# startup self-test -- it aborts with exit 2 if "123456789" != 0x31C3, so
# every resfork invocation below carries it.
#
# The structural invariants image_test.go asserts inside parseResourceFork
# (data offset 256, map offset == dataOff+dataLen, map end == fork length,
# map >= 30 bytes, every ref-list attr byte 0, empty name list sitting at
# the map's own end) plus the MacBinary framing ones (length a multiple of
# 128, version byte 0, name length 1..63, fork fits, zero tail padding)
# live in resfork.c and surface here as a "parse error: ..." exit 1.
. "$(dirname "$0")/../lib.sh"

RESFORK=$TOOLS/resfork
FIXTURE=$ROOT/testdata/cg68k/globals.cla
D1=$WORK/run1
D2=$WORK/run2
mkdir -p "$D1" "$D2" || die "mkdir"

emit1() {
    emit68k -o "$1/out.bin" "$FIXTURE" > "$1/emit.log" 2>&1
}

if ! emit1 "$D1"; then
    t_fail structure "emit68k failed: $(tail -3 "$D1/emit.log")"
    t_done
fi
IMG=$D1/out.bin

# -- MacBinary header (name/type/creator/fork lengths/version bytes/CRC/dates) --
if ! hdr=$("$RESFORK" header "$IMG" 2>&1); then
    t_fail header "$hdr"
    t_done
fi
# rsrclen is the only field that legitimately drifts with codegen size.
hdrfixed=$(echo "$hdr" | sed 's/ rsrclen=[0-9]*//')
want='name=out type=APPL creator=???? datalen=0 ver=129/129 crc=ok dates=0'
if [ "$hdrfixed" = "$want" ]; then
    t_pass header
else
    t_fail header "got [$hdrfixed], want [$want] (full line: $hdr)"
fi

# -- resource inventory: exactly CODE 0, CODE 1, SIZE(-1), nothing else --
if ! lst=$("$RESFORK" list "$IMG" 2>&1); then
    t_fail inventory "$lst"
    t_done
fi
inv=$(echo "$lst" | awk '{print $1, $2}' | sort)
wantinv='CODE 0
CODE 1
SIZE -1'
if [ "$inv" = "$wantinv" ]; then
    t_pass inventory
else
    t_fail inventory "resources [$(echo "$inv" | tr '\n' ',')], want CODE 0, CODE 1, SIZE -1"
fi

# -- SIZE(-1): exactly 10 bytes, flags 0x0080, preferred/minimum 2MB --
if ! sz=$("$RESFORK" size "$IMG" 2>&1); then
    t_fail size "$sz"
else
    # 0080 = is32BitCompatible only; 00200000 = 2097152 (2MB), twice.
    wantsz=00800020000000200000
    if [ "$sz" = "$wantsz" ]; then
        t_pass size
    else
        t_fail size "SIZE(-1) bytes = $sz, want $wantsz"
    fi
fi

# -- CODE 1's own 4-byte header: first-JT-entry offset 0, entry count --
if ! "$RESFORK" get "$IMG" CODE 1 "$WORK/code1.bin" 2>"$WORK/get.err"; then
    t_fail code1_header "$(cat "$WORK/get.err")"
    t_done
fi
set -- $(od -An -tx1 -N4 "$WORK/code1.bin")
firstoff=$(( 0x$1 * 256 + 0x$2 ))
entrycount=$(( 0x$3 * 256 + 0x$4 ))
if [ "$firstoff" -eq 0 ]; then
    t_pass code1_first_entry_off
else
    t_fail code1_first_entry_off "CODE 1 first-JT-entry offset = $firstoff, want 0 (single segment)"
fi

# -- CODE 0: A5-world header + every jump-table slot --
if ! c0=$("$RESFORK" code0 "$IMG" 2>&1); then
    t_fail code0 "$c0"
    t_done
fi
set -- $(echo "$c0" | head -1)
above=${1#above_a5=}
below=${2#below_a5=}
jtsize=${3#jt_size=}
jtoff=${4#jt_off=}
nentries=$(( jtsize / 8 ))

if [ "$jtoff" -eq 32 ]; then
    t_pass code0_jt_off
else
    t_fail code0_jt_off "CODE 0 JT offset from A5 = $jtoff, want 32"
fi
if [ "$nentries" -eq "$entrycount" ]; then
    t_pass code0_entry_count
else
    t_fail code0_entry_count "CODE 0 JT entry count ($nentries) != CODE 1 header's own count ($entrycount)"
fi
# globals.cla declares two below-A5 globals (an int and a string(255)).
if [ "$below" -gt 0 ]; then
    t_pass code0_below_a5
else
    t_fail code0_below_a5 "CODE 0 below-A5 size = 0, want > 0 (globals.cla declares globals)"
fi
if [ "$above" -eq $(( 32 + jtsize )) ]; then
    t_pass code0_above_a5
else
    t_fail code0_above_a5 "CODE 0 above-A5 size = $above, want 32+jtLen = $(( 32 + jtsize ))"
fi

slots=$(echo "$c0" | tail -n +2)
nslots=$(echo "$slots" | grep -c '^slot ')
if [ "$nslots" -eq "$nentries" ] && [ "$nentries" -gt 0 ]; then
    t_pass code0_slot_count
else
    t_fail code0_slot_count "$nslots slot lines for $nentries jump-table entries"
fi
# resfork marks a slot BAD when its filler word isn't 0x3F3C, its trailer
# word isn't 0xA9F0, or its offset lands outside its owning segment's own
# code range.
badslots=$(echo "$slots" | grep -n 'BAD$' | head -3)
if [ -z "$badslots" ]; then
    t_pass code0_slots
else
    t_fail code0_slots "malformed JT slot(s): $(echo "$badslots" | tr '\n' ';')"
fi
# Single segment: every slot must name segment 1.
notseg1=$(echo "$slots" | grep -vc '^slot 1 ')
if [ "$notseg1" -eq 0 ]; then
    t_pass code0_slot_segments
else
    t_fail code0_slot_segments "$notseg1 JT slot(s) name a segment other than 1"
fi
# JT entry 0 is the synthesized startup routine, always the very first
# thing emitted -- its offset must be exactly 0 (a stray +4 enters startup
# past its `LEA -belowA5(A5),A0`, so globals are never zeroed).
slot0=$(echo "$slots" | head -1)
if [ "$slot0" = "slot 1 0 filler=3F3C trailer=A9F0" ]; then
    t_pass code0_slot0
else
    t_fail code0_slot0 "JT entry 0 (startup, JT slot 0) = [$slot0], want [slot 1 0 filler=3F3C trailer=A9F0]"
fi

# -- determinism: the same fixture emitted into a second dir, byte-identical --
if ! emit1 "$D2"; then
    t_fail determinism "second emit68k failed: $(tail -3 "$D2/emit.log")"
elif cmp -s "$IMG" "$D2/out.bin"; then
    t_pass determinism
else
    t_fail determinism "emitted images differ: $(cmp "$IMG" "$D2/out.bin" 2>&1 | head -1)"
fi

t_done
