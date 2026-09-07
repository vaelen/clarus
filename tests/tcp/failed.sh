#!/bin/sh
# tests/tcp/failed.sh (MacTCP phase, Task 6, spec %4.1) -- every open
# failure arrives as a `failed` event on a later pump pass, never a crash
# and never synchronously from open() itself. Three at once: a refused
# connect (a positive errno -- ECONNREFUSED, 61 on macOS), a host NAME
# (the DNR's job, so an invalid spec on both lanes) and a spec with no
# port at all. The program quits 0 after the third, which is also the
# lifetime rule: three failed slots hold nothing open.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_tcp.sh" || die "helper lib failed to load"

tcp_build failed || { t_fail build "$(cat "$WORK/failed.build")"; t_done; }
t_pass build

"$TOOLS/timeout" 20 "$WORK/failed" > "$WORK/out" 2>&1
rc=$?
[ $rc -eq 0 ] && t_pass exit0 \
    || t_fail exit0 "exit $rc, want 0 (124 = never quit within 20s): $(tr '\n' '|' < "$WORK/out")"

check() {   # check NAME REGEX
    if grep -Eq "$2" "$WORK/out"; then
        t_pass "$1"
    else
        t_fail "$1" "no line matching [$2]: $(tr '\n' '|' < "$WORK/out")"
    fi
}
check refused '^failed 0 [0-9]+ could not open connection$'
check hostname '^failed 1 -2 invalid connection spec$'
check noport   '^failed 2 -2 invalid connection spec$'
t_done
