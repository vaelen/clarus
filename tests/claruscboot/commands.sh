#!/bin/sh
# The installed-toolchain command surface: bare check (with its info
# line), `check`, `build` (emit C + run cc), `build68k`, and the
# deprecated `emit68k` alias.
. "$(dirname "$0")/../lib.sh" || exit 2
unset CFLAGS
HOSTCC=$CC
W=$WORK
cat > "$W/hello.cla" <<'EOF'
on App.startCLI(args: list of string) {
    alert("hi")
}
EOF
cat > "$W/bad.cla" <<'EOF'
on App.startCLI(args: list of string) {
    var x: int
    x = "nope"
}
EOF
INFO="checking only"

# bare_info: bare check logs the info line; stdout + exit match `check`.
"$CLARUSC" --rtdir "$RTDIR" "$W/hello.cla" > "$W/b.out" 2> "$W/b.err"; brc=$?
"$CLARUSC" check --rtdir "$RTDIR" "$W/hello.cla" > "$W/c.out" 2> "$W/c.err"; crc=$?
if grep -q "$INFO" "$W/b.err" && [ $brc -eq $crc ] && cmp -s "$W/b.out" "$W/c.out"; then
    t_pass bare_info
else
    t_fail bare_info "rc $brc vs $crc; stderr: $(cat "$W/b.err")"
fi
# check_quiet
if [ $crc -eq 0 ] && [ ! -s "$W/c.err" ]; then t_pass check_quiet
else t_fail check_quiet "rc $crc; stderr: $(cat "$W/c.err")"; fi

# o_alone_checks: -o with no command does not build.
(cd "$W" && "$CLARUSC" --rtdir "$RTDIR" -o x hello.cla > /dev/null 2>&1); orc=$?
if [ ! -e "$W/x" ] && [ $orc -ne 0 ]; then t_pass o_alone_checks
else t_fail o_alone_checks "rc $orc, x exists: $([ -e "$W/x" ] && echo yes || echo no)"; fi

# build68k_same_bytes (same basename: MacBinary carries the file name)
mkdir "$W/a" "$W/b"
"$CLARUSC" build68k --rtdir "$RTDIR" -o "$W/a/x.bin" examples/hello-mac.cla 2> "$W/a.err"; arc=$?
"$CLARUSC" emit68k --rtdir "$RTDIR" -o "$W/b/x.bin" examples/hello-mac.cla 2> "$W/e.err"; erc=$?
if [ $arc -eq 0 ] && [ $erc -eq 0 ] && cmp -s "$W/a/x.bin" "$W/b/x.bin" \
    && grep -q "'emit68k' is deprecated; please use 'build68k'" "$W/e.err" \
    && ! grep -q deprecated "$W/a.err"; then
    t_pass build68k_same_bytes
else
    t_fail build68k_same_bytes "rc $arc/$erc; build68k err: $(cat "$W/a.err"); emit68k err: $(cat "$W/e.err")"
fi

# build_runs (+ no_tmp_leak: TMPDIR is left empty)
mkdir -p "$W/sp ace" "$W/tmp"
TMPDIR=$W/tmp CC=$HOSTCC "$CLARUSC" build --rtdir "$RTDIR" -o "$W/sp ace/hi" "$W/hello.cla" 2> "$W/r.err"; rrc=$?
if [ $rrc -eq 0 ] && [ "$("$W/sp ace/hi" 2>&1)" = hi ]; then t_pass build_runs
else t_fail build_runs "rc $rrc; stderr: $(cat "$W/r.err")"; fi
if [ -z "$(ls -A "$W/tmp")" ]; then t_pass no_tmp_leak
else t_fail no_tmp_leak "left in TMPDIR: $(ls -A "$W/tmp")"; fi

# build_relative: relative -o and --rtdir from another cwd.
ln -s "$ROOT" "$W/repo"
mkdir "$W/rel"
(cd "$W" && CC=$HOSTCC "$CLARUSC" build -o rel/hi --rtdir repo/runtime/clarus hello.cla) > "$W/rel.err" 2>&1
if [ "$("$W/rel/hi" 2>&1)" = hi ]; then t_pass build_relative
else t_fail build_relative "output: $(cat "$W/rel.err")"; fi

# build_bad_no_cc: a program with diagnostics never reaches cc.
printf '#!/bin/sh\ntouch "%s/called"\nexit 0\n' "$W" > "$W/ccspy"
chmod +x "$W/ccspy"
CC=$W/ccspy "$CLARUSC" build --rtdir "$RTDIR" -o "$W/badout" "$W/bad.cla" > /dev/null 2>&1; xrc=$?
if [ $xrc -ne 0 ] && [ ! -e "$W/called" ] && [ ! -e "$W/badout" ]; then t_pass build_bad_no_cc
else t_fail build_bad_no_cc "rc $xrc"; fi

# build_cc_argv: default -O1 and -I .../host; CFLAGS replaces -O1.
printf '#!/bin/sh\nfor a in "$@"; do printf "%%s\\n" "$a"; done >> "%s/cc.log"\nexec %s "$@"\n' "$W" "$HOSTCC" > "$W/ccspy-log"
chmod +x "$W/ccspy-log"
CC=$W/ccspy-log "$CLARUSC" build --rtdir "$RTDIR" -o "$W/argv1" "$W/hello.cla" 2> "$W/v.err"; v1=$?
if [ $v1 -eq 0 ] && grep -qx -- -O1 "$W/cc.log" && grep -qx -- -I "$W/cc.log" && grep -q '/host$' "$W/cc.log"; then
    t_pass build_cc_argv_default
else
    t_fail build_cc_argv_default "rc $v1; argv: $(cat "$W/cc.log" 2>/dev/null); stderr: $(cat "$W/v.err")"
fi
rm -f "$W/cc.log"
CFLAGS="-O0 -g" CC=$W/ccspy-log "$CLARUSC" build --rtdir "$RTDIR" -o "$W/argv2" "$W/hello.cla" 2> "$W/v.err"; v2=$?
if [ $v2 -eq 0 ] && grep -qx -- -O0 "$W/cc.log" && grep -qx -- -g "$W/cc.log" && ! grep -qx -- -O1 "$W/cc.log"; then
    t_pass build_cc_argv_cflags
else
    t_fail build_cc_argv_cflags "rc $v2; argv: $(cat "$W/cc.log" 2>/dev/null); stderr: $(cat "$W/v.err")"
fi

# build_cc_missing / build_cc_fails (each leaves TMPDIR empty)
TMPDIR=$W/tmp CC=/nonexistent/cc "$CLARUSC" build --rtdir "$RTDIR" -o "$W/m" "$W/hello.cla" 2> "$W/m.err"; mrc=$?
if [ $mrc -ne 0 ] && grep -q 'clarusc build:' "$W/m.err"; then t_pass build_cc_missing
else t_fail build_cc_missing "rc $mrc; stderr: $(cat "$W/m.err")"; fi
if [ -z "$(ls -A "$W/tmp")" ]; then t_pass build_cc_missing_clean
else t_fail build_cc_missing_clean "left in TMPDIR: $(ls -A "$W/tmp")"; fi
TMPDIR=$W/tmp CC=false "$CLARUSC" build --rtdir "$RTDIR" -o "$W/f" "$W/hello.cla" 2> "$W/f.err"; frc=$?
if [ $frc -ne 0 ] && grep -q failed "$W/f.err"; then t_pass build_cc_fails
else t_fail build_cc_fails "rc $frc; stderr: $(cat "$W/f.err")"; fi
if [ -z "$(ls -A "$W/tmp")" ]; then t_pass build_cc_fails_clean
else t_fail build_cc_fails_clean "left in TMPDIR: $(ls -A "$W/tmp")"; fi

# keep_c: the temp .c survives, its path on stderr.
TMPDIR=$W/tmp CC=$HOSTCC "$CLARUSC" build --keep-c --rtdir "$RTDIR" -o "$W/k" "$W/hello.cla" 2> "$W/k.err"; krc=$?
kept=$(sed -n 's/^clarusc build: kept //p' "$W/k.err")
# (in TMPDIR, so no_tmp_leak's empty dir really means TMPDIR was used)
case $kept in "$W/tmp/"*.c) kin=1 ;; *) kin= ;; esac
if [ $krc -eq 0 ] && [ -n "$kin" ] && [ -s "$kept" ]; then t_pass keep_c
else t_fail keep_c "rc $krc; stderr: $(cat "$W/k.err")"; fi
# Over-255-byte values (a Clarus string holds 255): each is refused with a
# message, never a slice panic (exit 3) or a silent truncation.
A50=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
# longpath BASE LEN: BASE extended with /aaa... components to LEN bytes
# (the last one 1..51 bytes, never empty).
longpath() {
    _p=$1
    while [ $(($2 - ${#_p})) -gt 52 ]; do _p=$_p/$A50; done
    _p=$_p/$(echo "${A50}a" | cut -c1-$(($2 - ${#_p} - 1)))
    echo "$_p"
}
# toolong NAME GREP: the last build (rc in $lrc, stderr in $W/NAME.err)
# failed cleanly with GREP in its message.
toolong() {
    if [ $lrc -ne 0 ] && [ $lrc -ne 3 ] && grep -q "$2" "$W/$1.err"; then t_pass "$1"
    else t_fail "$1" "rc $lrc; stderr: $(cat "$W/$1.err")"; fi
}
LT=$(longpath "$W/lt" 250)
mkdir -p "$LT" || die "mkdir long TMPDIR"
TMPDIR=$LT CC=$HOSTCC "$CLARUSC" build --rtdir "$RTDIR" -o "$W/lt1" "$W/hello.cla" 2> "$W/tmpdir_too_long.err"; lrc=$?
toolong tmpdir_too_long 'clarusc build: temp path too long (set TMPDIR to a shorter directory)'
if [ -z "$(ls -A "$LT")" ]; then t_pass tmpdir_too_long_clean
else t_fail tmpdir_too_long_clean "left: $(ls -A "$LT")"; fi
CC=$(longpath /x 300) "$CLARUSC" build --rtdir "$RTDIR" -o "$W/lt2" "$W/hello.cla" 2> "$W/cc_too_long.err"; lrc=$?
toolong cc_too_long 'clarusc build: CC too long'
CFLAGS="-O1 -D$(longpath X 300)" CC=$HOSTCC "$CLARUSC" build --rtdir "$RTDIR" -o "$W/lt3" "$W/hello.cla" 2> "$W/cflags_word_too_long.err"; lrc=$?
toolong cflags_word_too_long 'clarusc build: CFLAGS word too long'

# cc_with_args: CC's words after the first are leading cc arguments.
rm -f "$W/cc.log"
printf '#!/bin/sh\nfor a in "$@"; do printf "%%s\\n" "$a"; done >> "%s/cc.log"\n[ "$1" = --marker ] && shift\nexec %s "$@"\n' "$W" "$HOSTCC" > "$W/ccspy-marker"
chmod +x "$W/ccspy-marker"
CC="$W/ccspy-marker --marker" "$CLARUSC" build --rtdir "$RTDIR" -o "$W/ccargs" "$W/hello.cla" 2> "$W/ca.err"; carc=$?
if [ $carc -eq 0 ] && [ "$(head -1 "$W/cc.log")" = --marker ] && [ "$("$W/ccargs" 2>&1)" = hi ]; then t_pass cc_with_args
else t_fail cc_with_args "rc $carc; argv: $(cat "$W/cc.log" 2>/dev/null); stderr: $(cat "$W/ca.err")"; fi
t_done
