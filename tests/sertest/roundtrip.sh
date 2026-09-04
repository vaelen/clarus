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
# SER_BLESS=1 rewrites these three goldens (the Go test had no bless path;
# golden_check needs a variable name, and hand-editing binary goldens is worse).
. "$(dirname "$0")/../lib.sh"

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
golden_check "$WORK/stdout" "$G/roundtrip.out.golden" SER_BLESS \
    && t_pass stdout || t_fail stdout "mismatch vs $G/roundtrip.out.golden"

# check_bytes SAVEDFILE GOLDEN
check_bytes() {
    if [ ! -f "$run/$1" ]; then
        t_fail "$1" "not produced by the run"
        return
    fi
    golden_check "$run/$1" "$G/$2" SER_BLESS \
        && t_pass "$1" || t_fail "$1" "bytes mismatch vs $G/$2"
}
check_bytes rec.dat roundtrip.bytes.golden
check_bytes pad.dat padprobe.bytes.golden
t_done
