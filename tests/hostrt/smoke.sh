#!/bin/sh
# Port of internal/hostrt/rtsmoke_test.go TestRuntimeSmokeStrings: strings,
# fixed-point and rt_alert. rt_alert prints "hello" before the "OK", so the
# expected combined output is two lines, not the bare "OK" of run_c_test.
. "$(dirname "$0")/../lib.sh" || exit 2
exe=$WORK/smoke
$CC -std=c99 -Wall -Werror -I "$HOSTRT" "$HOSTRT/rt_smoke_test.c" "$HOSTRT/rt.c" -o "$exe" || die "compile"
"$exe" > "$WORK/out" 2>&1 || die "run: $(cat "$WORK/out")"
printf 'hello\nOK\n' > "$WORK/want"
cmp -s "$WORK/out" "$WORK/want" || die "output: $(cat "$WORK/out")"
