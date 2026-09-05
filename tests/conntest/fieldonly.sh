#!/bin/sh
# tests/conntest/fieldonly.sh (compiler-cleanup, spec %4.3c): a program
# whose ONLY connection-typed things are a record field and a parameter (no
# global `var x: connection`) must still splice conn.cla/conn_c.cla on the
# host lane -- usesConn is set from resolveType now, i.e. from ANY type
# position, not only from a global var decl. It used to fail at LINK time
# with undefined clar_fn_rtConn* symbols.
#
# No TCP peer: nothing is ever opened. The assertions are that it builds and
# links, and then runs to completion on its own (the pump loop is entered
# with zero connections and rtConnAlive() is false immediately).
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_conntest.sh" || die "helper lib failed to load"

conn_build fieldonly || { t_fail build "$(cat "$WORK/fieldonly.build")"; t_done; }
t_pass build

grep -q 'clar_fn_rtConnPump' "$WORK/fieldonly.c" && t_pass conn_spliced \
    || t_fail conn_spliced "emitted C never mentions clar_fn_rtConnPump: conn.cla was not spliced"

"$WORK/fieldonly" > "$WORK/out" 2> "$WORK/err"
rc=$?
[ $rc -eq 0 ] && t_pass run \
    || t_fail run "exit $rc, want 0 (stdout: $(cat "$WORK/out"), stderr: $(cat "$WORK/err"))"

# The native lane splices conn.cla unconditionally (drive.cla's want68k
# arm), so this half never depended on usesConn -- pinned anyway so a
# future narrowing of that arm cannot silently reintroduce the same gap.
emit68k -o "$WORK/fieldonly.bin" "$ROOT/tests/conntest/testdata/fieldonly.cla" \
    > "$WORK/emit68k.log" 2>&1 && t_pass native_emit \
    || t_fail native_emit "emit68k failed: $(tail -20 "$WORK/emit68k.log")"

t_done
