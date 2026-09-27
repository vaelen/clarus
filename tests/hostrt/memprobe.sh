#!/bin/sh
# SE Wave 0: host Memory Manager shim counters (live/peak, 68k cost model)
# and rtm_dump's silence when CLARUS_MEM_PEAK is unset.
. "$(dirname "$0")/../lib.sh" || exit 2
unset CLARUS_MEM_PEAK
run_c_test runtime/host/rt_memprobe_test.c || die "rt_memprobe_test"
echo "PASS memprobe"
