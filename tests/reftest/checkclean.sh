#!/bin/sh
# Port of internal/reftest/reftest_test.go TestCheckCleanFences: every fence
# index in tests/reftest/manifest.txt must check clean standalone under
# clarusc -- exit 0 AND no output at all.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_reftest.sh" || die "helper lib failed to load"

n=$(fences "$REFMD")
# lib_reftest.sh's [ -s ] guard passes a comments-only manifest, which would
# make this script a silent green with zero assertions -- so count what we
# actually iterate (same idiom as tests/selfhost/diag.sh).
count=0
for idx in $(manifest_indices); do
    count=$((count + 1))
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
[ "$count" -gt 0 ] || die "manifest has no indices"
t_done
