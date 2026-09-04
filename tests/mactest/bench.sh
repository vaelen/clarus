#!/bin/sh
# timeout: 45m
# mactest/bench -- port of internal/mactest/bench_test.go's
# TestParseBench68k + TestStrBench68k. Both are MEASUREMENT INSTRUMENTS,
# not gates: they fail only on build/boot/protocol errors (a missing BENCH
# line, or a missing `BENCH done` sentinel = truncated run), NEVER on a
# timing value -- the tick counts are just logged.
#
# 45m header, not the boot scripts' usual 20m: the two per-boot deadlines
# below (8m + 12m, copied from the Go tests' own measured budgets) already
# sum to 20m, so the outer deadline has to clear them plus both builds.
#
# Run: CLARUS_MAC_TESTS=1 CLARUS_BENCH68K=1 make test T=mactest/bench
. "$(dirname "$0")/../lib.sh"
. "$(dirname "$0")/../lib_mac.sh"
require_env CLARUS_BENCH68K
require_env CLARUS_MAC_TESTS

# --- parse/lex benchmark (clarusc's own lexer, no ast/parse) -----------
emit68k -o "$WORK/parsebench.bin" \
    clarusc/lib.cla clarusc/tok.cla clarusc/lex.cla \
    toolbox/events.cla testdata/bench/parsebench.cla > "$WORK/emit.log" 2>&1 \
    || die "clarusc emit68k parsebench: $(tail -10 "$WORK/emit.log")"

run_mac "$WORK/parsebench.bin" 480
if [ "$MAC_EXIT" != 0 ]; then
    t_fail parsebench "bench app exited $MAC_EXIT: $(cat "$WORK/cap.out")"
elif ! grep -E 'BENCH (parse|lex) iters=[0-9]+ ticks=[0-9]+' "$WORK/cap.out"; then
    t_fail parsebench "no BENCH line in output: $(cat "$WORK/cap.out")"
else
    t_pass parsebench
fi

# --- string-cost calibration benchmark --------------------------------
emit68k -o "$WORK/strbench.bin" \
    toolbox/events.cla testdata/bench/strbench.cla > "$WORK/emit.log" 2>&1 \
    || die "clarusc emit68k strbench: $(tail -10 "$WORK/emit.log")"

run_mac "$WORK/strbench.bin" 720
if [ "$MAC_EXIT" != 0 ]; then
    t_fail strbench "bench app exited $MAC_EXIT: $(cat "$WORK/cap.out")"
elif ! grep -qF 'BENCH done' "$WORK/cap.out"; then
    t_fail strbench "no \`BENCH done\` sentinel (truncated run?): $(cat "$WORK/cap.out")"
elif ! grep -oE 'BENCH [a-z0-9_]+ iters=[0-9]+ ticks=[0-9]+' "$WORK/cap.out"; then
    t_fail strbench "no BENCH lines in output: $(cat "$WORK/cap.out")"
else
    t_pass strbench
fi

t_done
