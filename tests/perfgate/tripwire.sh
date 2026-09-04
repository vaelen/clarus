#!/bin/sh
# Port of internal/perfgate/perfgate_test.go TestEmitPerfTripwire: time
# `clarusc emit` of testdata/emitui/every.cla three times, take the median,
# and fail if it exceeds 2x baseline.txt. A tripwire against a silent
# 30x-style emit-time regression, NOT a benchmark -- it does not fail on
# being merely slow, only on being more than 2x the recorded baseline.
# Excluded from `make t1` (timing under a parallel load is meaningless); run
# by `make t2` / `make test T=perfgate/` on its own.
. "$(dirname "$0")/../lib.sh"
base=$(grep -v '^#' tests/perfgate/baseline.txt | grep -v '^$' | head -1)
[ -n "$base" ] || die "tests/perfgate/baseline.txt: no baseline value line found"
i=1
while [ $i -le 3 ]; do
    "$TOOLS/timeout" --elapsed 300 "$CLARUSC" emit --rtdir "$RTDIR" \
        -o "$WORK/every.c" testdata/emitui/every.cla > /dev/null 2> "$WORK/err" \
        || die "clarusc emit run $i failed: $(cat "$WORK/err")"
    ms=$(sed -n 's/^elapsed_ms=//p' "$WORK/err")
    [ -n "$ms" ] || die "emit run $i: no elapsed_ms line"
    echo "$ms" >> "$WORK/all"
    i=$((i + 1))
done
sort -n "$WORK/all" > "$WORK/runs"
median=$(sed -n 2p "$WORK/runs")
limit=$(awk -v b="$base" 'BEGIN{printf "%d", b*2*1000}')
echo "emit runs (ms): $(tr '\n' ' ' < "$WORK/runs"); median ${median}ms; baseline ${base}s; limit ${limit}ms"
[ "$median" -le "$limit" ] || die "emit-time tripwire: median ${median}ms exceeds 2x baseline ${base}s (limit ${limit}ms) -- either a real regression, or the baseline is stale: re-baseline by editing tests/perfgate/baseline.txt to the new median and justifying the change in the commit message"
