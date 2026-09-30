#!/bin/sh
# `clarusc --version` prints exactly `clarusc <V>` and exits 0, and <V>
# (drive.cla's claruscVersion) matches the literal `version:` in
# clarusc/macgui.cla's `app ClarusC` -- an app property takes only a
# literal, so the two must be kept in step by hand.
. "$(dirname "$0")/../lib.sh" || exit 2
"$CLARUSC" --version > "$WORK/out" 2> "$WORK/err"; rc=$?
[ $rc -eq 0 ] || die "clarusc --version exit $rc: $(cat "$WORK/err")"
out=$(cat "$WORK/out")
case "$out" in
    "clarusc "[0-9]*.[0-9]*) t_pass flag ;;
    *) t_fail flag "stdout is '$out', want 'clarusc N.N'" ;;
esac
app=$(sed -n 's/^ *version: *"\([^"]*\)".*/\1/p' clarusc/macgui.cla)
[ -n "$app" ] || die "no version: literal in clarusc/macgui.cla"
if [ "$out" = "clarusc $app" ]; then
    t_pass matches_app
else
    t_fail matches_app "clarusc --version says '$out', macgui.cla's app version is '$app'"
fi
t_done
