#!/bin/sh
# Port of internal/reftest/reftest_test.go TestCheckCleanFences: every fence
# index in tests/reftest/manifest.txt must check clean standalone under
# clarusc -- exit 0 AND no output at all.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_reftest.sh" || die "helper lib failed to load"

n=$(fences "$REFMD")
for idx in $(manifest_indices); do
    if [ "$idx" -ge "$n" ]; then
        t_fail "f$idx" "manifest index $idx out of range ($n fences)"
        continue
    fi
    f=$WORK/f$idx.cla
    fences "$REFMD" "$idx" > "$f"
    out=$("$CLARUSC" "$f" 2>&1)
    rc=$?
    # Go's check is err == nil AND len(bytes.TrimSpace(out)) == 0.
    if [ $rc -ne 0 ] || [ -n "$(printf '%s' "$out" | tr -d '[:space:]')" ]; then
        t_fail "f$idx" "clarusc check not clean (exit $rc): $out"
    else
        t_pass "f$idx"
    fi
done
t_done
