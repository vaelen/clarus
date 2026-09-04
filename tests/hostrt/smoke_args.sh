#!/bin/sh
# Port of internal/hostrt/rtsmoke_test.go TestRuntimeSmokeArgs: rt_args_init
# skips argv[0], and rt_args_list memoizes (built once).
. "$(dirname "$0")/../lib.sh" || exit 2
run_c_test runtime/host/rt_smoke_args_test.c || die "rt_smoke_args_test"
