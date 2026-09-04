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
mkdir -p "$(dirname "$result")"
start=$(date +%s)
build-run/tools/timeout "$t" sh "$script" > "$log" 2>&1
rc=$?
secs=$(( $(date +%s) - start ))
if [ $rc -eq 77 ]; then st=SKIP
elif [ $rc -eq 124 ]; then st="FAIL(timeout ${t}s)"
elif [ $rc -eq 0 ] && ! grep -q '^FAIL ' "$log"; then st=PASS
else st="FAIL(exit $rc)"; fi
echo "$st $name ${secs}s" | tee "$result"
