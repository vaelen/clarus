#!/bin/sh
# The runtime lookup chain (installed-toolchain phase): --rtdir, then the
# upward search from the cwd, then $CLARUS_DATADIR/runtime/clarus/, then
# the built-in -DCLARUS_DATADIR default. Each data dir carries a marker
# toolbox file only it has, so a build that includes the marker proves
# WHICH data dir won (toolbox includes fall back to <rtdir>/../../toolbox).
. "$(dirname "$0")/../lib.sh" || exit 2

$CC -O1 -I "$HOSTRT" -DCLARUS_DATADIR='"'"$WORK/dflt"'"' -o "$WORK/cc-dflt" \
    "$BR/clarusc-current.c" "$HOSTRT/rt.c" || die "cannot build cc-dflt"
for d in dflt envd; do
    mkdir -p "$WORK/$d/runtime" || die "mkdir $d"
    cp -R "$RTDIR" "$WORK/$d/runtime/clarus" || die "copy runtime to $d"
    cp -R "$ROOT/toolbox" "$WORK/$d/toolbox" || die "copy toolbox to $d"
    printf 'func markOk(): int { return 1 }\n' > "$WORK/$d/toolbox/mark_$d.cla"
    cat > "$WORK/p_$d.cla" <<EOF
include "toolbox/mark_$d.cla"
on App.startCLI(args: list of string) {
    log(string(markOk()))
}
EOF
done
mkdir -p "$WORK/proj"
cat > "$WORK/proj/self.cla" <<'EOF'
on App.startCLI(args: list of string) {
    log("hi")
}
EOF

# expect NAME WANT(0|nz) CMD... -- runs CMD in $WORK/proj; WANT is 0 or nz.
expect() {
    n=$1; want=$2; shift 2
    (cd "$WORK/proj" && "$@") > "$WORK/$n.err" 2>&1; rc=$?
    if [ "$want" = 0 ] && [ $rc -eq 0 ]; then t_pass "$n"
    elif [ "$want" = nz ] && [ $rc -ne 0 ]; then t_pass "$n"
    else t_fail "$n" "exit $rc, want $want: $(head -3 "$WORK/$n.err")"
    fi
}

expect default_used 0 env -u CLARUS_DATADIR "$WORK/cc-dflt" emit -o x.c ../p_dflt.cla
expect env_beats_default 0 env CLARUS_DATADIR="$WORK/envd" "$WORK/cc-dflt" emit -o x.c ../p_envd.cla
expect env_beats_default_neg nz env CLARUS_DATADIR="$WORK/envd" "$WORK/cc-dflt" emit -o x.c ../p_dflt.cla
expect env_trailing_slash 0 env CLARUS_DATADIR="$WORK/envd/" "$WORK/cc-dflt" emit -o x.c ../p_envd.cla
expect env_bogus_falls_through 0 env CLARUS_DATADIR="$WORK/nope" "$WORK/cc-dflt" emit -o x.c ../p_dflt.cla

(cd "$ROOT" && env CLARUS_DATADIR="$WORK/envd" "$CLARUSC" emit -o "$WORK/r.c" "$WORK/p_envd.cla") \
    > /dev/null 2>&1 && t_fail repo_beats_env "the env data dir beat the repo's runtime" \
    || t_pass repo_beats_env

expect rtdir_beats_all 0 env CLARUS_DATADIR="$WORK/dflt" "$WORK/cc-dflt" emit \
    --rtdir "$WORK/envd/runtime/clarus/" -o x.c ../p_envd.cla

expect none_resolves nz env -u CLARUS_DATADIR "$CLARUSC" emit -o x.c self.cla
if grep -q CLARUS_DATADIR "$WORK/none_resolves.err" && grep -q "no built-in default" "$WORK/none_resolves.err"; then
    t_pass none_resolves_msg
else
    t_fail none_resolves_msg "stderr: $(cat "$WORK/none_resolves.err")"
fi

# env_too_long: a CLARUS_DATADIR too long for a 255-byte rtdir is skipped
# (falls through to the default), and the not-found abort still ends with
# its hint (the value is shown capped).
A50=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
LONGD=/x/$A50/$A50/$A50/$A50/$A50/$A50
expect env_too_long 0 env CLARUS_DATADIR="$LONGD" "$WORK/cc-dflt" emit -o x.c ../p_dflt.cla
(cd "$WORK/proj" && env CLARUS_DATADIR="$LONGD" "$CLARUSC" emit -o x.c self.cla) > "$WORK/etl.err" 2>&1; rc=$?
if [ $rc -ne 0 ] && [ $rc -ne 3 ] && tail -1 "$WORK/etl.err" | grep -q 'use --rtdir or set CLARUS_DATADIR$'; then
    t_pass env_too_long_msg
else
    t_fail env_too_long_msg "exit $rc; stderr: $(cat "$WORK/etl.err")"
fi

# longpath BASE LEN: BASE extended with /aaa... components to LEN bytes
# (the last one 1..51 bytes, never empty).
longpath() {
    _p=$1
    while [ $(($2 - ${#_p})) -gt 52 ]; do _p=$_p/$A50; done
    _p=$_p/$(echo "${A50}a" | cut -c1-$(($2 - ${#_p} - 1)))
    echo "$_p"
}
# env_long_slash: a 200-byte value with a trailing '/' (a symlink to envd)
# resolves. env_240_slash_no_panic: 240 bytes with the '/' still fits the 255-byte
# rtdir once stripped, but no module path fits after it, so it falls
# through to the default cleanly (no slice panic).
LD199=$(longpath "$WORK/ld199" 199)
LD239=$(longpath "$WORK/ld239" 239)
for lp in "$LD199" "$LD239"; do
    mkdir -p "${lp%/*}" && ln -s "$WORK/envd" "$lp" || die "long data dir $lp"
done
expect env_long_slash 0 env CLARUS_DATADIR="$LD199/" "$WORK/cc-dflt" emit -o x.c ../p_envd.cla
expect env_240_slash_no_panic 0 env CLARUS_DATADIR="$LD239/" "$WORK/cc-dflt" emit -o x.c ../p_dflt.cla

# bakeir_msg: --bake-ir's not-found abort uses the same seam wording.
(cd "$WORK/proj" && env -u CLARUS_DATADIR "$CLARUSC" --bake-ir --lane 68k -o x.clir) > "$WORK/bk.err" 2>&1; rc=$?
if [ $rc -ne 0 ] && grep -q 'no built-in default); use --rtdir or set CLARUS_DATADIR$' "$WORK/bk.err"; then
    t_pass bakeir_msg
else
    t_fail bakeir_msg "exit $rc; stderr: $(cat "$WORK/bk.err")"
fi

(cd "$WORK/proj" && env -u CLARUS_DATADIR "$CLARUSC" self.cla) > /dev/null 2>&1; a=$?
(cd "$WORK/proj" && env -u CLARUS_DATADIR "$CLARUSC_SNAPSHOT" self.cla) > /dev/null 2>&1; b=$?
if [ $a -eq $b ]; then t_pass check_unchanged; else t_fail check_unchanged "exit $a, snapshot $b"; fi
t_done
