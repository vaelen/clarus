#!/bin/sh
# Was bodyhash.sh, a port of internal/bake/bake_test.go's
# TestBakeHeaderBodyHashMasked, which pins the Snow bake-path fix wave's
# symptom shut (2026-08-13, snow-failure-rca.md): bkHashTextFrom
# (clarusc/bake.cla) always ends its loop with `h = h & 0x7FFFFFFF`, so a
# correctly-computed hash can never have bit 31 set. Before the fix
# cprint.cla emitted the hash multiply as plain signed `int32_t *` --
# signed-overflow UB that clang -O1+ used to prove the following mask dead
# and delete it, so a HOST-written header carried the raw unmasked value
# the real 68k AND.L never produces, which is what made the Mac refuse
# the artifact. CLIR v9 (SE wave 4 Task 6) dropped the body hash; the
# stamp is the same bkHashText over clarusc/clarusc.c, so it carries the
# check now.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"

for lane in 68k c; do
    bake_ir "$lane" "$WORK/$lane.clir"
    if ! "$CLIRHDR" "$WORK/$lane.clir" > "$WORK/$lane.hdr" 2> "$WORK/$lane.err"; then
        t_fail "$lane/parse" "$(cat "$WORK/$lane.err")"
        continue
    fi
    hash=$(clir_field stamp "$WORK/$lane.hdr")
    if [ -z "$hash" ] || [ "$hash" = 00000000 ]; then
        t_fail "$lane" "no stamp on clirhdr's header line (clarusc/clarusc.c not found?)"
    elif [ $((0x$hash & 0x80000000)) -eq 0 ]; then
        t_pass "$lane"
    else
        t_fail "$lane" "stamp = 0x$hash has bit 31 set; bkHashTextFrom's \`& 0x7FFFFFFF\` mask cannot produce this value -- signed-overflow UB regression (snow-failure-rca.md)"
    fi
done
t_done
