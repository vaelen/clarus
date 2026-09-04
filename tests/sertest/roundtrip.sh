#!/bin/sh
# Port of internal/sertest/sertest_test.go TestRoundtrip: emit+compile+run
# testdata/sertest/roundtrip.cla host-side in a fresh cwd. A Bookmark record
# (every serializable field kind: string(n)/int/bool/char/fixed/enum) round-
# trips through file.save/file.load as a bare record, a `list of` and a `map
# of`. stdout is compared to roundtrip.out.golden, and the saved files to
# roundtrip.bytes.golden / padprobe.bytes.golden byte-for-byte -- the latter
# two pin the on-disk format (magic/version/container header, BE ints,
# zero-padded strings) exactly, not just "it round-trips".
#
# No bless path: the Go test had none, and these three goldens are pinned
# format baselines -- an env var that rewrites them and turns the test green is
# exactly what must not exist here.
. "$(dirname "$0")/../lib.sh" || exit 2

# cc's warnings on the emitted C are pre-existing noise; show them only on a
# build failure, the way the Go test's CombinedOutput did.
host_build "$WORK/roundtrip" testdata/sertest/roundtrip.cla > "$WORK/build.log" 2>&1 \
    || { t_fail build "emit+cc roundtrip.cla failed: $(cat "$WORK/build.log")"; t_done; }

run=$WORK/run
mkdir -p "$run"
if ! ( cd "$run" && "$WORK/roundtrip" ) > "$WORK/stdout" 2> "$WORK/stderr"; then
    t_fail run "roundtrip exited nonzero: $(cat "$WORK/stdout" "$WORK/stderr")"
    t_done
fi

G=testdata/sertest

# compare NAME GOT GOLDEN : byte-compare, with cmp's first-difference offset as
# the failure detail (plus first_diff's line view, useful for the text golden).
compare() {
    if [ ! -f "$2" ]; then
        t_fail "$1" "not produced by the run"
        return
    fi
    if cmp -s "$2" "$3"; then
        t_pass "$1"
    else
        t_fail "$1" "mismatch vs $3: $(cmp "$2" "$3" 2>&1 | head -1)"
        first_diff "$3" "$2"
    fi
}
compare stdout  "$WORK/stdout" "$G/roundtrip.out.golden"
compare rec.dat "$run/rec.dat" "$G/roundtrip.bytes.golden"
compare pad.dat "$run/pad.dat" "$G/padprobe.bytes.golden"
t_done
