#!/bin/sh
# Port of internal/sertest/clrdcompare_test.go TestCLRDByteCompare: the CLRD
# byte-compare gate. For each save-capable sertest fixture, build+run with the
# current clarusc and byte-compare stdout and every produced .dat file against
# the pinned goldens in testdata/sertest/clrd_goldens.
#
# The goldens are a FROZEN baseline of the C serializer (rt_ser.inc), not a
# live re-capture of clarusc's current output (history: the retired Go twin's
# package doc, `git show go-harness-final^:internal/sertest/clrdcompare_test.go`).
# CLRD_BLESS=1 rewrites them; only ever do that deliberately.
. "$(dirname "$0")/../lib.sh" || exit 2

GDIR=testdata/sertest/clrd_goldens

# fixture + the .dat files its program produces (badfield.cla never reaches
# file.save -- clarusc emit rejects it first, per sertest/badfield.sh).
FIXTURE=roundtrip.cla
DATFILES='rec.dat list.dat map.dat'

# cc's warnings on the emitted C are pre-existing noise; show them only on a
# build failure, the way the Go test's CombinedOutput did.
host_build "$WORK/prog" "testdata/sertest/$FIXTURE" > "$WORK/build.log" 2>&1 \
    || { t_fail "$FIXTURE" "emit+cc failed: $(cat "$WORK/build.log")"; t_done; }

run=$WORK/run
mkdir -p "$run"
if ! ( cd "$run" && "$WORK/prog" ) > "$WORK/stdout" 2> "$WORK/stderr"; then
    t_fail "$FIXTURE" "run exited nonzero: $(cat "$WORK/stdout" "$WORK/stderr")"
    t_done
fi

golden_check "$WORK/stdout" "$GDIR/$FIXTURE.stdout" CLRD_BLESS \
    && t_pass "$FIXTURE/stdout" || t_fail "$FIXTURE/stdout" "mismatch vs $GDIR/$FIXTURE.stdout"

for name in $DATFILES; do
    if [ ! -f "$run/$name" ]; then
        t_fail "$FIXTURE/$name" "not produced by the run"
        continue
    fi
    golden_check "$run/$name" "$GDIR/$FIXTURE.$name" CLRD_BLESS \
        && t_pass "$FIXTURE/$name" || t_fail "$FIXTURE/$name" "mismatch vs $GDIR/$FIXTURE.$name"
done
t_done
