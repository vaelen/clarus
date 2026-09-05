#!/bin/sh
# compiler-cleanup: two --rtdir spellings that denote the SAME directory
# only via a symlink must produce byte-identical output. The symlink is on
# the repo ROOT (not on runtime/clarus itself): runtime modules include
# "../../toolbox/*.cla", so a link planted directly on runtime/clarus would
# strand those two-levels-up includes and test nothing but a broken tree.
#
# This is the tripwire for runtime-origin provenance. declIsRuntimeOrigin
# (lower.cla) no longer compares path strings at all: drive.cla records
# each file's origin when expand() reads it (drvRuntimeFiles, keyed by
# pool index, marked while drvSpliceActive is true), so no spelling of
# --rtdir -- symlinked, relative, or aliased -- can change the answer.
# The predecessor mechanism could: a lexical prefix match against rtDir
# saw two spellings of one directory as two directories, misclassified
# runtime decls as user code, and silently dropped their abort-propagation
# exemption. This passes before and after that change (with --rtdir, decl
# paths are derived FROM rtDir, so within one run they cannot diverge);
# it is here so a future return to deciding origin by path cannot quietly
# reintroduce the gap.
. "$(dirname "$0")/../lib.sh" || exit 2

ln -s "$ROOT" "$WORK/rootlink" || die "symlink"
SRC=$ROOT/testdata/cg68k/globals.cla
[ -f "$SRC" ] || die "missing fixture $SRC"

"$CLARUSC" emit --rtdir "$ROOT/runtime/clarus/" -o "$WORK/a.c" "$SRC" > "$WORK/a.log" 2>&1 || die "emit (direct) failed: $(cat "$WORK/a.log")"
"$CLARUSC" emit --rtdir "$WORK/rootlink/runtime/clarus/" -o "$WORK/b.c" "$SRC" > "$WORK/b.log" 2>&1 || die "emit (symlink) failed: $(cat "$WORK/b.log")"
if cmp -s "$WORK/a.c" "$WORK/b.c"; then
    t_pass rtdir_symlink_identity
else
    t_fail rtdir_symlink_identity "$(first_diff "$WORK/a.c" "$WORK/b.c")"
fi
t_done
