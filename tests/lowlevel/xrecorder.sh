#!/bin/sh
# lowlevel/xrecorder.sh -- port of internal/lowlevel/xrecorder_test.go
# TestXRecOrderDiagnoses: `var r: SomeXRec` with `extern record SomeXRec`
# declared AFTER the using func must produce the honest diagnostic and a
# nonzero exit, not lowering's old "list index out of range" panic. Same
# fixture as internal/selfhost's TestErrorGoldens (single source of truth),
# but visible to the fast gate.
. "$(dirname "$0")/../lib.sh"

n=XRecOrderDiagnoses
"$CLARUSC" emit -o "$WORK/out.c" "$ROOT/testdata/errors/xrec_order.cla" \
    > "$WORK/xrec.log" 2>&1
rc=$?
if [ $rc -eq 0 ]; then
    t_fail "$n" "expected nonzero exit (unresolved extern-record layout), got success"
elif ! grep -qF 'extern record SomeXRec is not declared before this use' "$WORK/xrec.log"; then
    t_fail "$n" "diagnostic missing the expected message: $(head -3 "$WORK/xrec.log" | tr '\n' ' ')"
elif grep -qF 'list index out of range' "$WORK/xrec.log"; then
    t_fail "$n" "output still contains the old panic string -- guard regressed"
else
    t_pass "$n"
fi
t_done
