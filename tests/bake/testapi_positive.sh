#!/bin/sh
# Port of internal/bake/bakeidentity_test.go's TestRtbakeTestapiPositive:
# `--rtbake --testapi` compiles a program that legitimately names UiTest*
# (runtime-ir-bake Task 5, deliverable (a)). Functional only -- compiles
# cleanly, exit 0, non-trivial output; full_corpus_testapi.sh is the
# byte-identity counterpart.
. "$(dirname "$0")/../lib.sh"
. "$(dirname "$0")/../lib_bake.sh"

BAKE=$WORK/rt68k.clir
bake_ir 68k "$BAKE"
write_testapi_fixture "$WORK/testapi_fixture.cla"

OUT=$WORK/out.bin
if "$CLARUSC" emit68k --rtbake "$BAKE" --testapi -o "$OUT" \
        "$WORK/testapi_fixture.cla" > "$WORK/log" 2>&1; then
    t_pass compiles
    n=$(wc -c < "$OUT" | tr -d ' ')
    if [ "$n" -ge 1024 ]; then
        t_pass size
    else
        t_fail size "--rtbake --testapi output suspiciously small: $n bytes"
    fi
else
    t_fail compiles "clarusc emit68k --rtbake --testapi: unexpected failure: $(head -5 "$WORK/log" | tr '\n' ' ')"
    t_fail size "compile failed"
fi
t_done
