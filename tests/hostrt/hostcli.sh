#!/bin/sh
# rt_hostcli_test.c: the `clarusc build` host primitives (HostGetEnv,
# HostDefaultDataDir/Cc, HostSpawn, HostMkTemp) in rt_ext_host.inc, once
# with the default build-time strings and once with CLARUS_DATADIR
# overridden (run_c_test takes no cflags, so the second build is direct).
. "$(dirname "$0")/../lib.sh" || exit 2
cd "$WORK" || die "cd $WORK"
run_c_test "$HOSTRT/rt_hostcli_test.c" || die "rt_hostcli_test"
t_pass default
$CC -std=c99 -Wall -Werror -I "$HOSTRT" \
    -DCLARUS_DATADIR='"/opt/x"' -DEXPECT_DATADIR='"/opt/x"' \
    "$HOSTRT/rt_hostcli_test.c" "$HOSTRT/rt.c" -o "$WORK/hostcli_override" \
    || die "override build"
_got=$("$WORK/hostcli_override" 2>&1)
[ "$_got" = OK ] || die "override: $_got"
t_pass datadir_override
t_done
