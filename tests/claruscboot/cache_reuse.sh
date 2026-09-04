#!/bin/sh
# Port of internal/claruscboot/claruscboot_test.go TestCacheReuse: the
# bootstrap cache must be warm after a build, so a second ensure pass must
# not rebuild. Under the Make harness "a second ensure pass" is a second
# `make bootstrap` (the Go stamp files are now mtime prerequisites), and the
# artifact's mtime must be unchanged.
. "$(dirname "$0")/../lib.sh" || exit 2
exe=build-run/clarusc-current
[ -x "$exe" ] || die "$exe missing: the bootstrap prerequisite did not run"
before=$(stat -f %m "$exe") || die "stat before"
make bootstrap > "$WORK/make.log" 2>&1 || die "make bootstrap: $(cat "$WORK/make.log")"
after=$(stat -f %m "$exe") || die "stat after"
[ "$before" = "$after" ] || die "cache miss on warm tree: mtime $before -> $after
$(cat "$WORK/make.log")"
