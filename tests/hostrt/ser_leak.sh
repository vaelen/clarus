#!/bin/sh
# Port of internal/hostrt/sertest_c_test.go TestSerC: compile rt_ser_test.c
# against rt.c and run it in a temp cwd (its file.save/load round trips use
# relative paths: rec.dat, list.dat, map.dat). Two subcases: the plain run
# must print OK, and a CLARUS_MEM_STRICT+PARANOID run must report live=0 --
# the strict leak gate (the worst repeatable leak was rt_file_save/
# rt_file_load leaking a whole rt_text per call).
. "$(dirname "$0")/../lib.sh" || exit 2
exe=$WORK/sertest
$CC -std=c99 -Wall -Werror -I "$HOSTRT" "$HOSTRT/rt_ser_test.c" "$HOSTRT/rt.c" -o "$exe" || die "compile"
cd "$WORK" || die "cd $WORK"

got=$("$exe" 2>&1) || die "run: $got"
[ "$got" = OK ] && t_pass plain || t_fail plain "output: $got"

CLARUS_MEM_STRICT=1 CLARUS_MEM_PARANOID=1 "$exe" > "$WORK/out" 2> "$WORK/err" \
    || die "strict run: $(cat "$WORK/err")"
if [ "$(cat "$WORK/out")" != OK ]; then
    t_fail leak "output: $(cat "$WORK/out")"
else
    live=$(mem_live "$WORK/err")
    if [ -z "$live" ]; then
        t_fail leak "no ##CLARUS-MEM## live= line in stderr: $(cat "$WORK/err")"
    elif [ "$live" -ne 0 ]; then
        t_fail leak "leaked $live block(s): $(cat "$WORK/err")"
    else
        t_pass leak
    fi
fi
t_done
