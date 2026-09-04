# tests/lib.sh -- sourced by every test script (POSIX sh). The runner
# (tests/run1.sh) exports ROOT and runs scripts with cwd = repo root;
# the fallback lets a script be run by hand from anywhere.
set -u
ROOT=${ROOT:-$(git -C "$(dirname "$0")" rev-parse --show-toplevel)}
cd "$ROOT" || exit 2
BR=$ROOT/build-run
TOOLS=$BR/tools
CLARUSC=$BR/clarusc-current
CLARUSC_SNAPSHOT=$BR/clarusc-snapshot
RTDIR=$ROOT/runtime/clarus/
HOSTRT=$ROOT/runtime/host
CC=${CC:-cc}
WORK=$(mktemp -d "${TMPDIR:-/tmp}/clarus-test.XXXXXX") || exit 2
trap 'rm -rf "$WORK"' EXIT
STATUS=0

# --- result protocol -------------------------------------------------
t_pass() { echo "PASS $1"; }
t_fail() { echo "FAIL $1: $2"; STATUS=1; }
t_done() { exit $STATUS; }
die()    { echo "FATAL: $*" >&2; exit 1; }
skip()   { echo "SKIP: $*"; exit 77; }

# --- gates -----------------------------------------------------------
require_env()  { eval "_v=\${$1:-}"; [ "$_v" = 1 ] || skip "$1 not set"; }
require_tool() { [ -x "$1" ] || skip "$1 not found"; }
require_vasm() {
    VASM=$ROOT/vasm/vasmm68k_mot
    [ -x "$VASM" ] || skip "vasm not built"
    printf ' dc.b 1,2,3,4\n' > "$WORK/probe.s"
    "$VASM" -m68000 -no-opt -Fbin -quiet -o "$WORK/probe.bin" "$WORK/probe.s" >/dev/null 2>&1 \
        || skip "vasm -Fbin probe failed"
    [ "$(od -An -tx1 "$WORK/probe.bin" | tr -d ' \n')" = 01020304 ] || skip "vasm -Fbin probe wrong bytes"
}
env_set() { eval "_v=\${$1:-}"; [ -n "$_v" ]; }

# --- goldens ---------------------------------------------------------
# golden_check FILE GOLDEN BLESSVAR : bless (copy) if $BLESSVAR is set,
# else byte-compare; on mismatch print the first differing byte and a
# unified diff excerpt and return 1.
golden_check() {
    if env_set "$3"; then cp "$1" "$2"; echo "BLESSED $2"; return 0; fi
    cmp -s "$1" "$2" && return 0
    echo "golden mismatch: $2"
    cmp "$1" "$2" 2>&1 | head -1
    diff -u "$2" "$1" | head -60
    return 1
}
# first_diff A B : line-oriented first mismatch (mirrors mactest firstDiff)
first_diff() { diff "$1" "$2" | head -5; }

# --- building --------------------------------------------------------
# host_build OUT FILE.cla... : clarusc emit + cc, host binary at OUT
host_build() {
    _out=$1; shift
    "$CLARUSC" emit --rtdir "$RTDIR" -o "$_out.c" "$@" || return 1
    $CC -O1 -I "$HOSTRT" -o "$_out" "$_out.c" "$HOSTRT/rt.c"
}
# emit68k ARGS... : clarusc emit68k with the runtime dir supplied
emit68k() { "$CLARUSC" emit68k --rtdir "$RTDIR" "$@"; }
# run_c_test SRC.c : cc -std=c99 -Wall -Werror against rt.c, run, expect "OK"
run_c_test() {
    _exe=$WORK/$(basename "$1" .c)
    $CC -std=c99 -Wall -Werror -I "$HOSTRT" "$1" "$HOSTRT/rt.c" -o "$_exe" || return 1
    _got=$("$_exe" 2>&1) || { echo "$_got"; return 1; }
    [ "$_got" = OK ] || { echo "expected OK, got: $_got"; return 1; }
}
# mem_live LOGFILE : the last ##CLARUS-MEM## live=N count, or empty
mem_live() { grep -o '##CLARUS-MEM## live=[0-9]*' "$1" | tail -1 | sed 's/.*live=//'; }
