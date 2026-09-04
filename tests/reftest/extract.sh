#!/bin/sh
# Port of internal/reftest/reftest_test.go TestFencesExtract: the language
# reference must still hold at least 20 ```rust fences.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_reftest.sh" || die "helper lib failed to load"

n=$(fences "$REFMD")
if [ "$n" -ge 20 ]; then
    t_pass count
else
    t_fail count "expected at least 20 rust fences, got $n"
fi
t_done
