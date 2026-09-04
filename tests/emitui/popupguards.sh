#!/bin/sh
# tests/emitui/popupguards.sh -- port of internal/emitui's
# TestEmitUiTablePopupGuards (8 subtests). Each fixture below is
# checker-clean syntax (or, for popup_nonform.cla, syntax the checker
# itself already rejects -- see that fixture's own doc comment) that
# `clarusc emit` must still reject loudly: nonzero exit and a matching
# message. No golden for any of them: none ever successfully emits.
#
# stdout AND stderr are both matched, combined, exactly as the Go test did:
# lower.cla's lowUnsupported diagnostics go to stderr, while check.cla's own
# checker diagnostics print via `alert` (main.cla), i.e. stdout.
. "$(dirname "$0")/../lib.sh" || exit 2

# fixture|expected substring.  Comments on each case, keyed to the Go test:
#   popup_unbound         lower.cla lowWidgetDesc popup guard: no `binds:`
#   popup_nonform         check.cla checkBindsProperty (stdout)
#   table_rows_expr       lower.cla lowWidgetDesc table guard: `rows:` a call
#   table_rows_local      checker: `rows:` names a window-local var (stdout)
#   table_zero_cols       mac-target-4d Task 7: zero-column table
#   isnew_wrong           Task 7: lower.cla lowSelect TyRec case
#   edit_bad_target       Task 7: lower.cla lowEditStmt unsupported target
#   form_for_handle_field ARC fix-wave Task 3: check.cla checkWindowDecl
while IFS='|' read -r fixture want; do
    [ -n "$fixture" ] || continue
    if "$CLARUSC" emit -o "$WORK/out.c" "testdata/emitui/$fixture" \
            > "$WORK/out.txt" 2>&1 < /dev/null; then
        t_fail "$fixture" "clarusc emit: want nonzero exit, got success (output: $(tr '\n' ' ' < "$WORK/out.txt"))"
    elif ! grep -Fq "$want" "$WORK/out.txt"; then
        t_fail "$fixture" "output missing \"$want\": $(tr '\n' ' ' < "$WORK/out.txt")"
    else
        t_pass "$fixture"
    fi
done <<'EOF'
popup_unbound.cla|popup requires binds inside a form window
popup_nonform.cla|binds: requires the window to declare form for
table_rows_expr.cla|table rows must be a global list variable
table_rows_local.cla|undefined: localRows
table_zero_cols.cla|table must have at least one column
isnew_wrong.cla|isNew is only defined on the accepted handler's parameter
edit_bad_target.cla|edit target must be a variable, list element, or map element
form_for_handle_field.cla|form for NoteRec: field body must be a by-value type
EOF
t_done
