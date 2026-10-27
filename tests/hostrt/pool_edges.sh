#!/bin/sh
# hostrt/pool_edges.sh (SE wave 2 Task 2): the intern pool's edge strings
# ("", 255 bytes, byte 0, bytes >= 0x80, a repeat) must compile to the SAME
# bytes under the committed snapshot and the current sources -- the pool
# numbering shows up in the literal pool. The snapshot-vs-current cmp is
# vacuous once the snapshot is regenerated from these same sources; the
# lasting guard is the pinned stdout, testdata/lowlevel/pool_edges.out
# (checked by tests/lowlevel/run.sh).
. "$(dirname "$0")/../lib.sh" || exit 2
src=testdata/lowlevel/pool_edges.cla
mkdir -p "$WORK/a" "$WORK/b"
"$CLARUSC_SNAPSHOT" build68k --rtdir "$RTDIR" -o "$WORK/a/pe.bin" "$src" || die "snapshot build68k"
"$CLARUSC" build68k --rtdir "$RTDIR" -o "$WORK/b/pe.bin" "$src" || die "current build68k"
cmp -s "$WORK/a/pe.bin" "$WORK/b/pe.bin" && t_pass build68k || t_fail build68k "snapshot/current .bin differ"
"$CLARUSC_SNAPSHOT" emit --rtdir "$RTDIR" -o "$WORK/a/pe.c" "$src" || die "snapshot emit"
"$CLARUSC" emit --rtdir "$RTDIR" -o "$WORK/b/pe.c" "$src" || die "current emit"
cmp -s "$WORK/a/pe.c" "$WORK/b/pe.c" && t_pass emit || t_fail emit "snapshot/current .c differ"
t_done
