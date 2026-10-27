#!/bin/sh
# timeout: 15m
# `make install` / `make uninstall`: the installed tree's shape, a build
# with nothing but the installed clarusc (its baked data dir), the
# CLARUS_DATADIR override, DESTDIR staging and a clean uninstall. Installs
# only under $WORK.
. "$(dirname "$0")/../lib.sh" || exit 2
unset CFLAGS
# A nested make must not join the runner's jobserver.
# INSTALL_BR keeps the test off build-run/clarusc-install*, so a user's
# later `sudo make install` never has to rebuild as root.
MKCMD=make
command -v gmake > /dev/null 2>&1 && MKCMD=gmake
mk() { env -u MAKEFLAGS -u MAKELEVEL -u MFLAGS $MKCMD -C "$ROOT" --no-print-directory INSTALL_BR="$WORK/ibr" "$@"; }
shared() { (cd "$BR" && ls -li clarusc-install* 2>/dev/null && cksum clarusc-install* 2>/dev/null); }
before=$(shared)
I=$WORK/inst

# install_tree
mk install PREFIX="$I" > "$WORK/inst.log" 2>&1 || die "make install failed: $(tail -20 "$WORK/inst.log")"
miss=
for f in share/clarus/runtime/clarus/core.cla share/clarus/runtime/host/rt.c \
    share/clarus/toolbox/memory.cla share/doc/clarus/clarus-language-reference.md \
    share/man/man1/clarusc.1; do
    [ -f "$I/$f" ] || miss="$miss $f"
done
[ -x "$I/bin/clarusc" ] || miss="$miss bin/clarusc(x)"
tests=$(ls "$I"/share/clarus/runtime/host/*_test.c 2>/dev/null)
if [ -z "$miss" ] && [ -z "$tests" ]; then t_pass install_tree
else t_fail install_tree "missing:$miss; test files: $tests"; fi

# rebuild_noop: a second install-bin with the same variables rebuilds
# nothing (a rebuild mv's a fresh file over the binary: a new inode).
ino() { ls -i "$WORK/ibr/clarusc-install" | awk '{print $1}'; }
i1=$(ino)
mk install-bin PREFIX="$I" > "$WORK/nb.log" 2>&1 || die "make install-bin failed: $(tail -20 "$WORK/nb.log")"
if [ -n "$i1" ] && [ "$(ino)" = "$i1" ]; then t_pass rebuild_noop
else t_fail rebuild_noop "inode $i1 -> $(ino): $(cat "$WORK/nb.log")"; fi

# relative_datadir: refused before anything is built or installed.
mk install PREFIX="$WORK/rel" DATADIR=rel/data > "$WORK/rd.log" 2>&1; rc=$?
if [ $rc -ne 0 ] && grep -q "DATADIR must be an absolute path" "$WORK/rd.log" \
    && [ ! -e "$WORK/rel" ] && [ ! -e "$ROOT/rel" ] && [ "$(ino)" = "$i1" ]; then
    t_pass relative_datadir
else t_fail relative_datadir "rc $rc: $(cat "$WORK/rd.log")"; fi

# installed_build: no --rtdir, cwd outside the repo, no CLARUS_DATADIR.
mkdir -p "$WORK/proj"
cat > "$WORK/proj/hi.cla" <<'CLA'
include "toolbox/memory.cla"
on App.startCLI(args: list of string) {
    alert("installed hi")
}
CLA
(cd "$WORK/proj" && env -u CLARUS_DATADIR "$I/bin/clarusc" build -o hi hi.cla) > "$WORK/b.err" 2>&1; rc=$?
if [ $rc -eq 0 ] && [ "$("$WORK/proj/hi" 2>&1)" = "installed hi" ]; then t_pass installed_build
else t_fail installed_build "rc $rc: $(cat "$WORK/b.err")"; fi

# installed_build68k
(cd "$WORK/proj" && env -u CLARUS_DATADIR "$I/bin/clarusc" build68k -o h.bin "$ROOT/examples/hello-mac.cla") > "$WORK/b68.err" 2>&1; rc=$?
sig=$(dd if="$WORK/proj/h.bin" bs=1 skip=65 count=4 2>/dev/null)
if [ $rc -eq 0 ] && [ "$sig" = APPL ]; then t_pass installed_build68k
else t_fail installed_build68k "rc $rc, type '$sig': $(cat "$WORK/b68.err")"; fi

# env_override: CLARUS_DATADIR beats the baked-in data dir.
cp -R "$I/share/clarus" "$WORK/alt"
echo 'func markerValue(): int { return 7 }' > "$WORK/alt/toolbox/marker.cla"
cat > "$WORK/proj/mk.cla" <<'CLA'
include "toolbox/marker.cla"
on App.startCLI(args: list of string) {
    alert("m")
}
CLA
(cd "$WORK/proj" && CLARUS_DATADIR=$WORK/alt "$I/bin/clarusc" build -o m mk.cla) > "$WORK/e1.err" 2>&1; rc1=$?
(cd "$WORK/proj" && env -u CLARUS_DATADIR "$I/bin/clarusc" build -o m2 mk.cla) > "$WORK/e2.err" 2>&1; rc2=$?
if [ $rc1 -eq 0 ] && [ $rc2 -ne 0 ]; then t_pass env_override
else t_fail env_override "with var rc $rc1 ($(cat "$WORK/e1.err")); without rc $rc2"; fi

# uninstall_clean (+ uninstall_keeps_foreign: a file install did not put
# in DATADIR survives, and so does DATADIR itself).
echo keep > "$I/share/clarus/keep.txt"
mk uninstall PREFIX="$I" > "$WORK/un.log" 2>&1 || t_fail uninstall_clean "make uninstall: $(tail -5 "$WORK/un.log")"
left=$(find "$I" -type f ! -path "$I/share/clarus/keep.txt")
if [ -z "$left" ]; then t_pass uninstall_clean
else t_fail uninstall_clean "left behind: $left"; fi
if [ -f "$I/share/clarus/keep.txt" ]; then t_pass uninstall_keeps_foreign
else t_fail uninstall_keeps_foreign "uninstall removed a file install never put there"; fi

# destdir: staged under DESTDIR, but the binary names the final path.
R=$WORK/root
mk install DESTDIR="$R" PREFIX=/usr > "$WORK/d.log" 2>&1 || die "DESTDIR install failed: $(tail -20 "$WORK/d.log")"
n=$(grep -c /usr/share/clarus "$R/usr/bin/clarusc" 2>/dev/null)
if [ -x "$R/usr/bin/clarusc" ] && [ -f "$R/usr/share/clarus/runtime/clarus/core.cla" ] && [ "${n:-0}" -ge 1 ]; then
    t_pass destdir
else t_fail destdir "binary/runtime missing or path not baked (grep -c $n)"; fi

# mandir: MANDIR overrides where the page goes (under DESTDIR); uninstall
# removes the page and leaves man1 (a shared system dir) in place.
mk install DESTDIR="$R" PREFIX=/usr MANDIR=/usr/man > "$WORK/m.log" 2>&1 || die "MANDIR install failed: $(tail -20 "$WORK/m.log")"
pg=$R/usr/man/man1/clarusc.1
mode=$(ls -l "$pg" 2>/dev/null | cut -c1-10)
if cmp -s "$pg" "$ROOT/docs/clarusc.1" && [ "$mode" = -rw-r--r-- ]; then t_pass mandir_install
else t_fail mandir_install "page at $pg missing, different or mode '$mode'"; fi
mk uninstall DESTDIR="$R" PREFIX=/usr MANDIR=/usr/man > "$WORK/mu.log" 2>&1 || t_fail mandir_uninstall "make uninstall: $(tail -5 "$WORK/mu.log")"
if [ ! -e "$pg" ] && [ -d "$R/usr/man/man1" ]; then t_pass mandir_uninstall
else t_fail mandir_uninstall "page left behind or man1 removed"; fi

# reinstall_datadir: a changed DATADIR rebuilds the install binary.
mk install PREFIX="$WORK/i2" DATADIR="$WORK/i2/data" > "$WORK/r.log" 2>&1 || die "DATADIR install failed: $(tail -20 "$WORK/r.log")"
if grep -q "$WORK/i2/data" "$WORK/i2/bin/clarusc" && ! grep -q "$WORK/inst/share" "$WORK/i2/bin/clarusc"; then
    t_pass reinstall_datadir
else t_fail reinstall_datadir "binary does not carry only $WORK/i2/data"; fi
# shared_untouched: build-run/clarusc-install* unchanged by this run.
if [ "$(shared)" = "$before" ]; then t_pass shared_untouched
else t_fail shared_untouched "build-run/clarusc-install* changed"; fi
t_done
