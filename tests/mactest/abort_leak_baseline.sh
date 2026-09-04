#!/bin/sh
# abort_leak_baseline: TestAbortLeakBaseline (internal/mactest/
# leakgate_test.go) -- testdata/leakgate/abortbaseline.cla loops the
# attempt-abort phase's three shapes 500 times each (the AbortRelease
# middle-frame text local, probe (a)'s never-released synthetic return
# temp, probe (b)'s abandoned mid-statement transient) and must end with
# zero live heap blocks: an abort unwinds by ordinary ARC, so it is
# exactly as leak-free as a normal return.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$ROOT/tests/lib_mactest_host.sh" || die "helper lib failed to load"

scratch_under_br mactest-abort-leak-baseline

leak_fixture AbortLeakBaseline testdata/leakgate/abortbaseline.cla

t_done
