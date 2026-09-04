#!/bin/sh
# Port of internal/claruscboot/claruscboot_test.go TestCurrentExeChecksFixture:
# the bootstrapped current-source clarusc must actually work -- run it in
# default check mode over a known-clean corpus fixture and require a clean
# exit with no output at all.
. "$(dirname "$0")/../lib.sh"
"$CLARUSC" testdata/valid/bookmarks.cla > "$WORK/out" 2>&1; rc=$?
[ $rc -eq 0 ] || die "clarusc check testdata/valid/bookmarks.cla not clean: exit $rc
$(cat "$WORK/out")"
[ ! -s "$WORK/out" ] || die "clarusc check testdata/valid/bookmarks.cla not clean: output
$(cat "$WORK/out")"
