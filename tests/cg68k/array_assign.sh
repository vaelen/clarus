#!/bin/sh
# cg68k/array_assign -- port of internal/cg68k/array_assign_test.go's
# TestSAssignWholeArraySucceeds and
# TestSAssignWholeArrayHandleElemFailsClosed. A scalar-element whole-array
# assign (`b = a` for `arr N of T`) must emit and vasm-round-trip; an
# element type that itself needs ARC release (text[n]) must still fail
# closed with the named error.
#
# NOTE: the Go lane skips only the first test when vasm is missing (the
# fail-closed test needs no assembler). Here require_vasm gates the whole
# script, so a no-vasm machine SKIPs both -- deliberate, so that a genuine
# fail-closed regression can never be masked by a SKIP exit status.
. "$(dirname "$0")/../lib.sh"

require_vasm

# --- TestSAssignWholeArraySucceeds -----------------------------------
dir=$WORK/ok
mkdir -p "$dir" || die "mkdir $dir"
cat > "$dir/wholearray.cla" <<'EOF'
on App.launch {
    var a: int[3]
    var b: int[3]
    a[0] = 1
    b = a
}
EOF

ok=1
if ! out=$("$CLARUSC" emit68k -o "$dir/out.bin" --listing "$dir/wholearray.cla" 2>&1); then
    t_fail whole_array_succeeds "clarusc emit68k --listing $dir/wholearray.cla failed"
    echo "$out"
    ok=0
elif [ ! -f "$dir/out.bin" ]; then
    t_fail whole_array_succeeds "emit68k reported success but left no .bin"
    ok=0
fi
if [ "$ok" = 1 ]; then
    if ! out=$("$VASM" -quiet -m68000 -no-opt -Fbin -o "$dir/vasm_out.bin" "$dir/out.seg1.s" 2>&1); then
        t_fail whole_array_succeeds "vasm assemble $dir/out.seg1.s failed"
        echo "$out"
    elif [ ! -f "$dir/out.seg1.dat" ]; then
        t_fail whole_array_succeeds "read $dir/out.seg1.dat: no such file"
    elif ! cmp -s "$dir/out.seg1.dat" "$dir/vasm_out.bin"; then
        t_fail whole_array_succeeds "$dir/out.seg1.s: vasm round-trip diverged (encoder $(wc -c < "$dir/out.seg1.dat" | tr -d ' ') bytes, vasm $(wc -c < "$dir/vasm_out.bin" | tr -d ' ') bytes)"
    else
        t_pass whole_array_succeeds
    fi
fi

# --- TestSAssignWholeArrayHandleElemFailsClosed ----------------------
dir=$WORK/closed
mkdir -p "$dir" || die "mkdir $dir"
cat > "$dir/wholearraytext.cla" <<'EOF'
on App.launch {
    var a: text[2]
    var b: text[2]
    a[0] = "x"
    b = a
}
EOF

# No --listing here, mirroring the Go test.
if out=$("$CLARUSC" emit68k -o "$dir/out.bin" "$dir/wholearraytext.cla" 2>&1); then
    t_fail handle_elem_fails_closed "emit68k unexpectedly succeeded on a handle-bearing whole-array assignment"
    echo "$out"
elif ! printf '%s\n' "$out" | grep -q 'whole-array assignment of handle-bearing elements unsupported natively'; then
    t_fail handle_elem_fails_closed "expected the named handle-bearing-element fail-closed error"
    echo "$out"
else
    t_pass handle_elem_fails_closed
fi
if [ -f "$dir/out.bin" ]; then
    t_fail handle_elem_no_bin "emit68k left a .bin behind despite the whole-array-assign error"
else
    t_pass handle_elem_no_bin
fi

t_done
