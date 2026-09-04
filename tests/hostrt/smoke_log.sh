#!/bin/sh
# Port of internal/hostrt/rtsmoke_test.go TestRuntimeSmokeLog: rt_log writes
# to stderr (never stdout) with a trailing newline, rendering embedded CR
# bytes as LF.
. "$(dirname "$0")/../lib.sh"
exe=$WORK/smokelog
$CC -std=c99 -Wall -Werror -I "$HOSTRT" "$HOSTRT/rt_smoke_log_test.c" "$HOSTRT/rt.c" -o "$exe" || die "compile"
"$exe" > "$WORK/out" 2> "$WORK/err" || die "run: $(cat "$WORK/err")"
[ ! -s "$WORK/out" ] || die "unexpected stdout: $(cat "$WORK/out")"
printf 'hi\nyou\n' > "$WORK/want"
cmp -s "$WORK/err" "$WORK/want" || die "stderr: $(cat "$WORK/err")"
