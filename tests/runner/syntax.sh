#!/bin/sh
# Runner self-check: every shell file under tests/ must parse. A syntax
# error inside a SOURCED helper (lib_<group>.sh) once produced a green PASS
# with zero assertions -- the source failed, the script kept going, and the
# empty log had no FAIL line to grep. `sh -n` over the whole tree catches
# that class before it can lie again; the guarded source lines (`. ... ||
# die`) catch the rest at runtime.
. "$(dirname "$0")/../lib.sh" || exit 2

find tests -name '*.sh' | sort > "$WORK/files"
n=0
while IFS= read -r f; do
    n=$((n + 1))
    sh -n "$f" 2> "$WORK/err" || t_fail "syntax $f" "$(head -3 "$WORK/err" | tr '\n' ' ')"
done < "$WORK/files"
[ "$n" -gt 0 ] || t_fail files "no tests/**/*.sh found"
t_pass "parsed $n files"
t_done
