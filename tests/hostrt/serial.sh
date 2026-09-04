#!/bin/sh
# Port of internal/hostrt/serialtest_c_test.go TestSerialC: compile
# rt_serial_test.c against rt.c (which #includes rt_serial.inc) and run it
# (TCP loopback only -- no files, so cwd is the repo root as in Go).
. "$(dirname "$0")/../lib.sh" || exit 2
run_c_test runtime/host/rt_serial_test.c || die "rt_serial_test"
