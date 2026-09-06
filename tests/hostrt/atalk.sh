#!/bin/sh
# hostrt/atalk -- compile rt_atalk_test.c against rt.c (which #includes
# rt_atalk.inc) and run it: two LToUDP stack instances on loopback
# multicast, exercising LLAP node acquisition, NBP and ATP against each
# other.
#
# Not lib.sh's run_c_test, for one reason: a sandbox with no multicast must
# SKIP, and the binary reports that as exit 77 (the harness's own skip
# code). run_c_test only knows exit 0 + stdout "OK", so it would turn an
# environmental skip into a FAIL. The compile line below is run_c_test's,
# verbatim.
. "$(dirname "$0")/../lib.sh" || exit 2

exe=$WORK/rt_atalk_test
$CC -std=c99 -Wall -Werror -I "$HOSTRT" runtime/host/rt_atalk_test.c \
    "$HOSTRT/rt.c" -o "$exe" || die "rt_atalk_test failed to compile"

out=$("$exe" 2>&1)
rc=$?
[ "$rc" = 77 ] && skip "multicast unavailable"
if [ "$rc" = 0 ] && [ "$out" = OK ]; then
    t_pass atalk
else
    echo "$out"
    t_fail atalk "exit $rc"
fi
t_done
