#!/bin/sh
# rt_tcp.inc's own C unit test: compile rt_tcp_test.c against rt.c (which
# #includes rt_tcp.inc) and run it. Six scenarios on 127.0.0.1 with
# OS-chosen ports -- no files, so cwd is the repo root like serial.sh.
# Takes ~10s: scenario 6 observes rt_tcp.inc's 10-second close deadline,
# which cannot be observed in less than 10 seconds.
. "$(dirname "$0")/../lib.sh" || exit 2
run_c_test runtime/host/rt_tcp_test.c || die "rt_tcp_test"
