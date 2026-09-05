#!/bin/sh
# tests/cg68k/unspliced_guard.sh (compiler-cleanup, spec %4.3d; docs/TODO.md
# "STILL LIVE unspliced-runtime-function crash"): a native build whose
# program reaches a runtime function that is NOT in the build must fail with
# a NAMED diagnostic and a nonzero exit -- never `runtime error: list index
# out of range`, never exit 3 from a runtime error.
#
# Both shapes are pinned, against a well-formed COPY of the compiler's own
# source tree ($WORK/rtroot/{runtime/clarus,toolbox} -- the toolbox half is
# required because fileh_68k.cla `include`s it through the
# <rtdir>/../../toolbox/ fallback, so a bare runtime/clarus copy fails for
# the wrong reason entirely). `baseline` builds against that untouched tree,
# so neither failure below can be an artifact of the copy itself; each
# variant is a `cp -R` of that ONE copy, not a fresh sweep of $ROOT
# (Task 11, final-review item 6).
#
#   missing_module   -- datetime_68k.cla deleted, program calls now():
#                       drive.cla's manifest splice names the module.
#   missing_function -- rtStrStore deleted from str.cla, program stores a
#                       string: nothing else references it, so it survives
#                       the whole-program check and reaches cg68k's own
#                       cgJsrByName/cgCallFnScalar guard family
#                       (cg68k.cla ~10035, ~11829), which names the function.
#
# Task 11 (final-review item 5): each subcase asserts its OWN exact
# diagnostic text, not a shared alternation -- a checker that regressed to
# a generic `undefined: rtStrStore` now FAILS missing_function instead of
# passing on the `rtStrStore` alternative.
. "$(dirname "$0")/../lib.sh" || exit 2

# guard_check NAME RTDIR PROG WANT : emit68k must exit nonzero with WANT
# (a fixed string) in its output and no runtime-error crash.
guard_check() {
    _name=$1
    _rt=$2
    _prog=$3
    _want=$4
    "$CLARUSC" emit68k --rtdir "$_rt" -o "$WORK/$_name.bin" "$_prog" > "$WORK/$_name.out" 2>&1
    _rc=$?
    if [ $_rc -eq 0 ]; then
        t_fail "$_name" "want nonzero exit, got 0"
    elif grep -q 'list index out of range' "$WORK/$_name.out"; then
        t_fail "$_name" "crashed instead of diagnosing: $(tail -3 "$WORK/$_name.out")"
    elif grep -Fq "$_want" "$WORK/$_name.out"; then
        t_pass "$_name"
    else
        t_fail "$_name" "exit $_rc but not the expected diagnostic \"$_want\": $(tail -3 "$WORK/$_name.out")"
    fi
}

# The ONE full copy of the compiler's source tree. Every variant below is a
# cp -R of this, so $ROOT is swept exactly once.
rtbase="$WORK/rtroot"
rm -rf "$rtbase"
mkdir -p "$rtbase/runtime/clarus" "$rtbase/toolbox" || die "mkdir $rtbase"
cp "$ROOT"/runtime/clarus/*.cla "$rtbase/runtime/clarus/" || die "cp runtime"
cp "$ROOT"/toolbox/*.cla "$rtbase/toolbox/" || die "cp toolbox"

# rtroot_variant DEST : a fresh derivative of the one base tree.
rtroot_variant() {
    rm -rf "$1"
    cp -R "$rtbase" "$1" || die "cp -R $rtbase $1"
}

cat > "$WORK/needs_dt.cla" <<'CLA'
on App.startCLI(args: list of string) {
    var t: int
    t = now()
    quit 0
}
CLA

cat > "$WORK/needs_ss.cla" <<'CLA'
on App.startCLI(args: list of string) {
    var s: string
    s = "hi"
    log(s)
    quit 0
}
CLA

# baseline: the untouched copy builds the program clean.
if "$CLARUSC" emit68k --rtdir "$rtbase/runtime/clarus/" -o "$WORK/ok.bin" \
        "$WORK/needs_ss.cla" > "$WORK/ok.out" 2>&1; then
    t_pass baseline
else
    t_fail baseline "untouched runtime copy does not build: $(tail -5 "$WORK/ok.out")"
    t_done
fi

rtroot_variant "$WORK/nomod"
rm -f "$WORK/nomod/runtime/clarus/datetime_68k.cla"
guard_check missing_module "$WORK/nomod/runtime/clarus/" "$WORK/needs_dt.cla" \
    'runtime module datetime_68k.cla not found'

rtroot_variant "$WORK/nofn"
LC_ALL=C sed '/^func rtStrStore(/,/^}$/d' "$rtbase/runtime/clarus/str.cla" > "$WORK/str.stripped" \
    || die "sed str.cla"
grep -q 'func rtStrStore(' "$WORK/str.stripped" \
    && die "sed did not remove rtStrStore from str.cla"
cp "$WORK/str.stripped" "$WORK/nofn/runtime/clarus/str.cla"
guard_check missing_function "$WORK/nofn/runtime/clarus/" "$WORK/needs_ss.cla" \
    'cg68k: rtStrStore not found/reachable'

t_done
