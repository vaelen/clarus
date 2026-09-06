#!/bin/sh
# cg68k/array_assign -- port of internal/cg68k/array_assign_test.go's
# TestSAssignWholeArraySucceeds and
# TestSAssignWholeArrayHandleElemFailsClosed. A scalar-element whole-array
# assign (`b = a` for `arr N of T`) must emit and vasm-round-trip; an
# element type that itself needs ARC release (text[n]) must still fail
# closed with the named error.
#
# Case order matters: only the round-trip case needs an assembler, so the
# fail-closed case runs FIRST and unconditionally (matching Go, where
# TestSAssignWholeArrayHandleElemFailsClosed calls no requireVasm). The
# t_done guard between them keeps a real fail-closed FAIL from being
# masked by the exit-77 SKIP that require_vasm raises on a vasm-less box.
. "$(dirname "$0")/../lib.sh" || exit 2

# --- TestSAssignWholeArrayHandleElemFailsClosed (no assembler needed) --
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

# --- handle-bearing array PARAMETER by value: named diagnostic ---------
# (native-array-return-and-fileh-guards, spec %3). cgParamByRef routes
# every handle-free array by address, so a KArr reaching cgPushArgs' by-
# value arm is handle-bearing by construction and must fail closed with
# a message that names the element, not the generic value-context abort.
dir=$WORK/hparam
mkdir -p "$dir" || die "mkdir $dir"
cat > "$dir/hparam.cla" <<'EOF'
record Named {
    label: text
}

func f(a: Named[2]): int {
    return 1
}

on App.launch {
    var n: Named[2]
    if f(n) == 0 {
        return
    }
}
EOF
if out=$("$CLARUSC" emit68k -o "$dir/out.bin" "$dir/hparam.cla" 2>&1); then
    t_fail handle_param_named_error "emit68k unexpectedly succeeded on a handle-bearing array parameter"
    echo "$out"
elif ! printf '%s\n' "$out" | grep -q 'cannot be passed by value natively'; then
    t_fail handle_param_named_error "expected the named handle-bearing-parameter error, got: $out"
elif ! printf '%s\n' "$out" | grep -q 'record Named'; then
    t_fail handle_param_named_error "diagnostic does not name the element record: $out"
else
    t_pass handle_param_named_error
fi
if [ -f "$dir/out.bin" ]; then
    t_fail handle_param_no_bin "emit68k left a .bin behind despite the array-parameter error"
else
    t_pass handle_param_no_bin
fi

# --- handle-bearing array RETURN: named diagnostic ---------------------
# Definition order no longer matters: cgCheckArrayReturns is a pre-pass
# over every reachable function, run once before the measure pass, so the
# named diagnostic wins whichever function the emitter would have reached
# first. The caller_first subcase below pins exactly that.
dir=$WORK/hret
mkdir -p "$dir" || die "mkdir $dir"
cat > "$dir/hret.cla" <<'EOF'
func g(): text[2] {
    var t: text[2]
    return t
}

on App.launch {
    g()
}
EOF
if out=$("$CLARUSC" emit68k -o "$dir/out.bin" "$dir/hret.cla" 2>&1); then
    t_fail handle_return_named_error "emit68k unexpectedly succeeded on a handle-bearing array return"
    echo "$out"
elif ! printf '%s\n' "$out" | grep -q 'cannot be returned natively'; then
    t_fail handle_return_named_error "expected the named handle-bearing-return error, got: $out"
elif ! printf '%s\n' "$out" | grep -q 'function g '; then
    t_fail handle_return_named_error "diagnostic does not name the function: $out"
else
    t_pass handle_return_named_error
fi
if [ -f "$dir/out.bin" ]; then
    t_fail handle_return_no_bin "emit68k left a .bin behind despite the array-return error"
else
    t_pass handle_return_no_bin
fi

# --- handle-bearing array RETURN, CALLER DEFINED FIRST -----------------
# (final review F1) The pre-pass exists for this shape: emission runs in
# irFuncs index order, so before it, caller's own `u = g()` hit the older
# generic whole-array-assign abort -- no function name, no element type,
# and advice ("assign element-wise") impossible to follow for a call
# result. The named return diagnostic must win here too.
dir=$WORK/hretcaller
mkdir -p "$dir" || die "mkdir $dir"
cat > "$dir/hretcaller.cla" <<'EOF'
func caller(): int {
    var u: text[2]
    u = g()
    return 1
}

func g(): text[2] {
    var t: text[2]
    return t
}

on App.launch {
    if caller() == 0 {
        return
    }
}
EOF
if out=$("$CLARUSC" emit68k -o "$dir/out.bin" "$dir/hretcaller.cla" 2>&1); then
    t_fail handle_return_caller_first "emit68k unexpectedly succeeded on a handle-bearing array return"
    echo "$out"
elif ! printf '%s\n' "$out" | grep -q 'cannot be returned natively'; then
    t_fail handle_return_caller_first "expected the named handle-bearing-return error, got: $out"
elif ! printf '%s\n' "$out" | grep -q 'function g '; then
    t_fail handle_return_caller_first "diagnostic does not name the function: $out"
elif printf '%s\n' "$out" | grep -q 'whole-array assignment of handle-bearing elements'; then
    t_fail handle_return_caller_first "the generic whole-array-assign abort won over the named return diagnostic: $out"
else
    t_pass handle_return_caller_first
fi
if [ -f "$dir/out.bin" ]; then
    t_fail handle_return_caller_first_no_bin "emit68k left a .bin behind despite the array-return error"
else
    t_pass handle_return_caller_first_no_bin
fi

# Never let the SKIP below swallow a fail-closed regression.
[ "$STATUS" -eq 0 ] || t_done

require_vasm

# --- TestSAssignWholeArraySucceeds ------------------------------------
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

t_done
