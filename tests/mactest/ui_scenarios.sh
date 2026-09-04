#!/bin/sh
# timeout: 20m
# mactest/ui_scenarios -- port of internal/mactest/native_test.go's
# TestUiScenariosOn68k (uiScenarios68k's three surviving frozen golden
# scenarios: smoke_mandel, texteditor, bookmarks). One native `clarusc
# emit68k --events` build + boot per row, each compared byte-exact against
# testdata/ui/<row>.trace and testdata/uisnaps/<row>.<snap>.pbm, plus the
# two per-scenario successive-snap-differ checks ui_test.go's
# checkSmokeMandelSnaps/checkBookmarksSnaps make. CLARUS_DEBUG_UI=1 dumps
# the whole capture; CLARUS_MAC_BLESS=1 rewrites the goldens.
#
# smoke_bounce is NOT repeated here -- it has its own script, mirroring its
# own standalone TestSmokeBounceOn68k.
. "$(dirname "$0")/../lib.sh"
. "$(dirname "$0")/../lib_mac.sh"
require_env CLARUS_MAC_TESTS

# snaps_differ SCENARIO A B WHY : cmp two produced snaps; equal is a FAIL.
snaps_differ() {
    if [ ! -e "$WORK/snap.$2.pbm" ] || [ ! -e "$WORK/snap.$3.pbm" ]; then
        t_fail "$1/snaps" "expected snaps $2 and $3; got: $(ls "$WORK"/snap.*.pbm 2>/dev/null | sed 's|.*/snap\.||;s|\.pbm||' | tr '\n' ' ')"
        return
    fi
    cmp -s "$WORK/snap.$2.pbm" "$WORK/snap.$3.pbm" \
        && t_fail "$1/snaps" "snap $2 == $3 -- $4"
}

# run_scenario NAME EVENTS CLA... : build, boot, compare goldens.
run_scenario() {
    _name=$1; _events=$2; shift 2
    emit68k -o "$WORK/$_name.bin" --events "$_events" "$@" \
        > "$WORK/emit.log" 2>&1 \
        || die "clarusc emit68k $_name: $(tail -10 "$WORK/emit.log")"
    run_mac "$WORK/$_name.bin" 180
    if env_set CLARUS_DEBUG_UI; then
        echo "$_name: exit=$MAC_EXIT"
        echo "--- out ---"; cat "$WORK/cap.out"
        echo "--- log ---"; cat "$WORK/cap.log"
    fi
    ui_split "$WORK/cap.out"
    ui_goldens "$_name" 0
}

before=$STATUS
run_scenario smoke_mandel testdata/ui/smoke_mandel.events examples/mandelbrot.cla
snaps_differ smoke_mandel S1 S2 "the render did not progress between snaps"
snaps_differ smoke_mandel S2 S3 "File > New did not restart the render"
[ $STATUS -eq $before ] && t_pass smoke_mandel

before=$STATUS
run_scenario texteditor testdata/ui/texteditor.events \
    examples/texteditor.cla testdata/ui/texteditor_opendoc_setup.cla
[ $STATUS -eq $before ] && t_pass texteditor

before=$STATUS
run_scenario bookmarks testdata/ui/bookmarks.events examples/bookmarks.cla
snaps_differ bookmarks S1 S2 "fixing the port and accepting did not add a row"
snaps_differ bookmarks S2 S3 "adding the second bookmark did not add a row"
snaps_differ bookmarks S3 S4 "the edit round did not change the table's row"
snaps_differ bookmarks S4 S5 "Remove did not delete a row"
[ $STATUS -eq $before ] && t_pass bookmarks

t_done
