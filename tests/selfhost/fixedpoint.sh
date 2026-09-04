#!/bin/sh
# timeout: 30m
# selfhost/fixedpoint -- port of internal/selfhost/fixedpoint_test.go's
# TestSnapshotFixedPoint, the snapshot fixed-point + freshness oracle.
#
#   gen1 = snapshot-built clarusc's emission of the CURRENT clarusc/main.cla.
#          It must byte-equal the committed clarusc/clarusc.c (freshness:
#          the snapshot embodies the logic that produced clarusc.c and
#          emission is deterministic, so re-running it over unchanged source
#          reproduces clarusc.c exactly).
#   gen2 = current-source clarusc's emission of the same source. gen1 ==
#          gen2 means self-compilation has reached a fixed point.
#
# Neither emission passes --rtdir: clarusc searches runtime/clarus/ from the
# cwd upward, and the runner's cwd is the repo root, so it lands on the same
# runtime the Go test found by walking up from internal/selfhost.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$ROOT/tests/lib_selfhost.sh" || die "helper lib failed to load"

emit_gen() { # emit_gen COMPILER OUT.c
    if ! "$1" emit -o "$2" "$ROOT/clarusc/main.cla" > "$WORK/emit.log" 2>&1; then
        t_fail fixedpoint "clarusc emit -o $2 $ROOT/clarusc/main.cla: $(cat "$WORK/emit.log")"
        t_done
    fi
}

gen1=$WORK/gen1.c
emit_gen "$CLARUSC_SNAPSHOT" "$gen1"

if ! cmp -s "$gen1" clarusc/clarusc.c; then
    t_fail snapshot_fresh "clarusc/clarusc.c is stale: committed snapshot ($(wc -c < clarusc/clarusc.c | tr -d ' ') bytes) != fresh emission from the snapshot-built compiler ($(wc -c < "$gen1" | tr -d ' ') bytes).

The committed snapshot must always match what clarusc currently emits for
its own source. To regenerate it (Go-free, from the old snapshot):

  cc -O1 -I runtime/host -o /tmp/boot clarusc/clarusc.c runtime/host/rt.c
  /tmp/boot emit --rtdir runtime/clarus/ -o /tmp/cur.c clarusc/main.cla
  cc -O1 -I runtime/host -o /tmp/cur /tmp/cur.c runtime/host/rt.c
  /tmp/cur emit --rtdir runtime/clarus/ -o clarusc/clarusc.c clarusc/main.cla

Then commit the updated clarusc/clarusc.c.
$(first_divergence clarusc/clarusc.c "$gen1" c2 c3)"
    t_done
fi
t_pass snapshot_fresh

gen2=$WORK/gen2.c
emit_gen "$CLARUSC" "$gen2"

if cmp -s "$gen1" "$gen2"; then
    echo "snapshot fixed point reached: gen1 == gen2 ($(wc -c < "$gen1" | tr -d ' ') bytes), and matches the committed snapshot"
    t_pass fixed_point
else
    t_fail fixed_point "snapshot fixed point FAILED: generation N emission ($(wc -c < "$gen1" | tr -d ' ') bytes) != generation N+1 emission ($(wc -c < "$gen2" | tr -d ' ') bytes)
$(first_divergence "$gen1" "$gen2" c2 c3)"
fi

t_done
