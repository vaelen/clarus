#!/bin/sh
# tests/cg68k/geomshake.sh (ui-widgets Task 6 fix round 1): the deferred
# setBounds apply and the geometry entry points are linked only where
# they can run. bookmarks.cla never calls setBounds nor reads
# contentWidth/contentHeight, so its listing must contain none of them;
# ui_batch_decl.cla does both, so it must contain all of them
# (lower.cla's lowUsesSetBounds/lowUsesContentSize gates and
# clar_ui_fire_geomapply).
. "$(dirname "$0")/../lib.sh" || exit 2

FNS="rtUiWidgetSetBounds rtUiApplyPendingBounds rtUiApplyAllPending rtUiSetCtrlVis rtUiWinContentW rtUiWinContentH"

emit68k -o "$WORK/bm.bin" --listing "$ROOT/examples/bookmarks.cla" > "$WORK/bm.log" 2>&1 \
    || die "emit68k bookmarks: $(tail -5 "$WORK/bm.log")"
emit68k -o "$WORK/ui.bin" --listing "$ROOT/testdata/emitui/ui_batch_decl.cla" > "$WORK/ui.log" 2>&1 \
    || die "emit68k ui_batch_decl: $(tail -5 "$WORK/ui.log")"

found=
missing=
for f in $FNS; do
    grep -q "; func $f " "$WORK"/bm.seg*.s && found="$found $f"
    grep -q "; func $f " "$WORK"/ui.seg*.s || missing="$missing $f"
done
if [ -z "$found" ]; then t_pass unused_shaken; else t_fail unused_shaken "bookmarks links:$found"; fi
if [ -z "$missing" ]; then t_pass used_linked; else t_fail used_linked "ui_batch_decl lacks:$missing"; fi
t_done
