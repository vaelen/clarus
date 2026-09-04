#!/bin/sh
# tests/summary.sh RESULT... -- print counts, dump failing logs, exit 1 on any FAIL.
[ $# -gt 0 ] || { echo "summary: no tests matched" >&2; exit 2; }
pass=0; skip=0; fail=0
for r in "$@"; do
    case "$(cut -d' ' -f1 "$r")" in
        PASS) pass=$((pass+1)) ;;
        SKIP) skip=$((skip+1)) ;;
        *) fail=$((fail+1)); echo "=== $(cat "$r")"; tail -40 "${r%.result}.log"; echo ;;
    esac
done
echo "tests: $pass passed, $skip skipped, $fail failed"
[ $fail -eq 0 ]
