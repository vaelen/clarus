#!/bin/sh
# Port of internal/asm68k/vasm_test.go TestVasmRoundTrip: the vasm round-trip
# oracle. exercise.cla replays clarusc/asm68k.cla's own a68SelfExercise()
# stream and dumps both faces of it -- the listing text (exer.s) and the
# encoder's own bytes (exer.dat). A REAL third-party 68000 assembler (vasm)
# assembles the listing; its output must be byte-identical to exer.dat.
# Neither side is trusted a priori; convergence is the evidence.
#
# SKIPs (via require_vasm) when vasm/vasmm68k_mot is missing or was built
# without the bin output module -- an environment gap, not a code bug.
# require_vasm's probe is a real assemble-and-check, not a banner grep: a
# stale local binary built without the bin module (this repo has hit that)
# must SKIP, not fail.
#
# vasm/ in this repo ships only vasm's doc plus a gitignored binary (like
# the Retro68/toolchain symlinks -- see repo CLAUDE.md); the binary is NOT
# committed and must be built locally from vasm 1.8g source with the bin
# output module enabled:
#
#	cd <vasm-source-checkout>          # e.g. a sibling clone of vasm 1.8g
#	make CPU=m68k SYNTAX=mot           # top-level Makefile; OUTFMTS in
#	                                   # Makefile already includes -DOUTBIN
#	cp vasmm68k_mot <clarus-repo>/vasm/vasmm68k_mot
. "$(dirname "$0")/../lib.sh" || exit 2

require_vasm

# Show cc's output only on a build failure, as the Go test's CombinedOutput did.
host_build "$WORK/exercise" tests/asm68k/exercise.cla > "$WORK/build.log" 2>&1 \
    || { t_fail roundtrip "build exercise.cla failed: $(cat "$WORK/build.log")"; t_done; }

# exercise.cla writes exer.s/exer.dat via relative paths, so run it in $WORK.
( cd "$WORK" && "$WORK/exercise" ) > "$WORK/run.log" 2>&1 \
    || { t_fail roundtrip "run exercise: $(cat "$WORK/run.log")"; t_done; }

( cd "$WORK" && "$VASM" -quiet -m68000 -no-opt -Fbin -o out.bin exer.s ) > "$WORK/vasm.log" 2>&1 \
    || { t_fail roundtrip "vasm assemble exer.s: $(cat "$WORK/vasm.log")"; t_done; }

if cmp -s "$WORK/exer.dat" "$WORK/out.bin"; then
    t_pass roundtrip
else
    detail=$(cmp "$WORK/exer.dat" "$WORK/out.bin" 2>&1 | head -1)
    # cmp's "char N" is 1-based; a length-only difference reports no char.
    off=$(printf '%s' "$detail" | sed -n 's/.*differ: char \([0-9]*\).*/\1/p')
    if [ -n "$off" ]; then off=$((off - 1)); else off=0; fi
    start=$((off - 16))
    [ "$start" -lt 0 ] && start=0
    t_fail roundtrip "vasm round-trip diverged at byte offset $off (encoder $(wc -c < "$WORK/exer.dat" | tr -d ' ') bytes, vasm $(wc -c < "$WORK/out.bin" | tr -d ' ') bytes): $detail"
    echo " encoder (exer.dat) at $start:"
    xxd -s "$start" -l 32 "$WORK/exer.dat"
    echo " vasm (out.bin) at $start:"
    xxd -s "$start" -l 32 "$WORK/out.bin"
fi
t_done
