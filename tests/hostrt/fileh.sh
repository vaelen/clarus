#!/bin/sh
# Port of internal/hostrt/filehtest_c_test.go TestFilehC: compile
# rt_fileh_test.c against rt.c (the host runtime, which #includes
# rt_fileh.inc) and run it in a temp cwd -- it creates files by relative
# path, so cwd must not be the repo.
. "$(dirname "$0")/../lib.sh"
cd "$WORK" || die "cd $WORK"
run_c_test "$HOSTRT/rt_fileh_test.c" || die "rt_fileh_test"
