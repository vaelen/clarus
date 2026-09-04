#!/bin/sh
# Port of internal/hostrt/rctest_c_test.go TestRcC: rt_rc_test.c is compiled
# ALONE (it #includes rt.h, rt_mem.h, rt_mem_host.inc, then rt_core.inc
# directly -- no rt.c link) and run in a temp cwd.
. "$(dirname "$0")/../lib.sh"
exe=$WORK/rctest
$CC -std=c99 -Wall -Werror -I "$HOSTRT" "$HOSTRT/rt_rc_test.c" -o "$exe" || die "compile"
cd "$WORK" || die "cd $WORK"
got=$("$exe" 2>&1) || die "run: $got"
[ "$got" = OK ] || die "output: $got"
