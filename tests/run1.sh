#!/bin/sh
# tests/run1.sh SCRIPT RESULT -- run one test script under the deadline,
# write "<STATUS> <name> <secs>s" to RESULT and the log next to it.
script=$1; result=$2
ROOT=$(cd "$(dirname "$0")/.." && pwd); export ROOT; cd "$ROOT"
log=${result%.result}.log
name=${script#tests/}; name=${name%.sh}
t=$(sed -n 's/^# timeout: *//p' "$script" | head -1)
case "$t" in
    "") t=600 ;;
    *h) t=$(( ${t%h} * 3600 )) ;;
    *m) t=$(( ${t%m} * 60 )) ;;
    *s) t=${t%s} ;;
esac
# A malformed header must not silently disable the deadline: anything that
# is not a positive decimal after unit conversion falls back to the default.
# (This has to run AFTER the conversions -- "bogus" ends in "s", so the *s
# arm above strips it to "bogu" rather than leaving it intact.)
case "$t" in
    ""|0|*[!0-9]*) t=600 ;;
esac
mkdir -p "$(dirname "$result")"
start=$(date +%s)
build-run/tools/timeout "$t" sh "$script" > "$log" 2>&1
rc=$?
secs=$(( $(date +%s) - start ))
# A FAIL line in the log beats every other verdict except a timeout: a
# script that reported a failing subcase and THEN skipped (or exited 0) is
# a FAIL, not a SKIP -- so the grep arm is tested before the rc 77 arm.
if [ $rc -eq 124 ]; then st="FAIL(timeout ${t}s)"
elif grep -q '^FAIL ' "$log"; then st="FAIL(exit $rc)"
elif [ $rc -eq 77 ]; then st=SKIP
elif [ $rc -eq 0 ]; then st=PASS
else st="FAIL(exit $rc)"; fi
echo "$st $name ${secs}s" | tee "$result"
