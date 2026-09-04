#!/bin/sh
# Port of internal/reftest/reftest_test.go TestRequiredProgramsInManifest: the
# four full worked programs must all be in the check-clean manifest, located
# by the same distinctive content substrings the Go test uses (robust to index
# shifts from future doc edits). All substrings of a program must match.
. "$(dirname "$0")/../lib.sh"
. "$(dirname "$0")/../lib_reftest.sh"

NFENCE=$(fences "$REFMD")

# find_prog SUBSTR... : index of the first fence containing ALL substrings.
find_prog() {
    _i=0
    while [ "$_i" -lt "$NFENCE" ]; do
        fences "$REFMD" "$_i" > "$WORK/body"
        _ok=1
        for _s in "$@"; do
            grep -Fq "$_s" "$WORK/body" || { _ok=0; break; }
        done
        [ "$_ok" = 1 ] && { echo "$_i"; return 0; }
        _i=$((_i + 1))
    done
    return 1
}

# check NAME SUBSTR... : the program must exist, and its index be in the manifest.
check() {
    _name=$1
    shift
    _idx=$(find_prog "$@") || { t_fail "$_name" "required program not found"; return; }
    if manifest_indices | grep -qx "$_idx"; then
        t_pass "$_name (index $_idx)"
    else
        t_fail "$_name" "required program (index $_idx) not in manifest"
    fi
}

check 'Ch1 example' 'record Person {'
check 'Ch11 bounce' 'title: "Bounce"'
check 'Appendix C bookmark manager' 'window EditForm {' 'enum Protocol'
check 'Appendix C text editor' 'menu Edit { standard edit }' 'func openPath'
t_done
