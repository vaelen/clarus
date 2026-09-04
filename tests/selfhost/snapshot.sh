#!/bin/sh
# timeout: 30m
# selfhost/snapshot -- port of internal/selfhost/snapshot_test.go's
# TestSnapshotBuilds: the committed clarusc/clarusc.c ALONE must reproduce a
# working clarusc. It is staged (as committed, not a fresh emission) into a
# scratch dir alongside a copy of runtime/host/* minus the *_test.c harness
# sources -- rt.c #includes its .inc/.h siblings, so a flat dir-copy keeps
# that layout and the compile needs no -I -- then compiled there and run as
# a checker over three corpus samples. Its stdout and exit code must match
# the current-source clarusc exactly.
#
# The samples are named with the same "../../testdata/..." relative paths the
# Go test used, from the same nesting depth, so a diagnostic that echoes its
# input path is compared like-for-like on both sides.
. "$(dirname "$0")/../lib.sh"
. "$ROOT/tests/lib_selfhost.sh"

stage=$WORK/snap
mkdir -p "$stage"
cp clarusc/clarusc.c "$stage/main.c" || die "stage clarusc.c"
for f in runtime/host/*; do
    [ -f "$f" ] || continue
    case $f in *_test.c) continue ;; esac
    cp "$f" "$stage/" || die "stage $f"
done

if ! $CC -std=c99 -O1 "$stage/main.c" "$stage/rt.c" -o "$stage/prog" \
        > "$WORK/cc.log" 2>&1; then
    t_fail snapshot_builds "cc rejected clarusc-emitted C:
$(cat "$WORK/cc.log")"
    t_done
fi

cd "$ROOT/tests/selfhost" || die "cd $ROOT/tests/selfhost"

for f in ../../testdata/diag/chk_undefined.cla \
         ../../testdata/diag/chk_typemismatch.cla \
         ../../testdata/valid/bookmarks.cla; do
    # stdout only is the oracle (Go's runClarusc lets stderr through to the
    # test's own stderr); keep it in the log for debuggability.
    "$CLARUSC" "$f" > "$WORK/want" 2> "$WORK/want.err"
    wantcode=$?
    "$stage/prog" "$f" > "$WORK/got" 2> "$WORK/got.err"
    gotcode=$?
    if [ "$gotcode" = "$wantcode" ] && cmp -s "$WORK/got" "$WORK/want"; then
        t_pass "$f"
    else
        t_fail "$f" "divergence on $f
  current-source    (exit $wantcode): $(cat "$WORK/want")
  snapshot-built cc (exit $gotcode): $(cat "$WORK/got")"
    fi
done

t_done
