#!/bin/sh
# Port of internal/hostrt/memtest_c_test.go TestMemC: rt_mem_test.c is
# compiled ALONE (it #includes rt_mem.h then rt_mem_host.inc directly -- no
# rt.c link), and it re-execs itself with CLARUS_MEM_PARANOID=1 via a
# relative "./<argv[0]>", so cwd must be the exe's own directory.
. "$(dirname "$0")/../lib.sh"
exe=$WORK/memtest
$CC -std=c99 -Wall -Werror -I "$HOSTRT" "$HOSTRT/rt_mem_test.c" -o "$exe" || die "compile"
cd "$WORK" || die "cd $WORK"
got=$("$exe" 2>&1) || die "run: $got"
[ "$got" = OK ] || die "output: $got"
