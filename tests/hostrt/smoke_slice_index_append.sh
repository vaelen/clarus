#!/bin/sh
# Port of internal/hostrt/rtsmoke_test.go TestRuntimeSmokeSliceIndexAppend:
# string/text slice and indexOf, amortized append growth, self-append.
. "$(dirname "$0")/../lib.sh"
run_c_test runtime/host/rt_smoke_slice_index_append_test.c || die "rt_smoke_slice_index_append_test"
