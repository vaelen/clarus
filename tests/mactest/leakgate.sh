#!/bin/sh
# leakgate: TestLeakGate's five fixture subcases (internal/mactest/
# leakgate_test.go) -- build each host-lane fixture and require zero live
# heap blocks at exit under the CLARUS_MEM_STRICT ledger. The three
# in-process double-compile subcases live in dblcompile{,_bake,_abort}.sh.
. "$(dirname "$0")/../lib.sh"
. "$ROOT/tests/lib_mactest_host.sh" || die "helper lib failed to load"

scratch_under_br mactest-leakgate

leak_fixture StoreTemps     testdata/leakgate/stemp.cla
leak_fixture ArrStore       testdata/leakgate/arrstore.cla
leak_fixture ClearRefElems  testdata/leakgate/clearprobe.cla
leak_fixture ArrElem        testdata/leakgate/arrelem.cla
leak_fixture PopArgLeak     testdata/run/popargleak.cla

t_done
