# tests/lib_mactest_host.sh -- helpers for the host-only mactest scripts
# (leakgate, dblcompile*, abort_leak_baseline, bake_named). Sourced right
# after lib.sh. POSIX sh.
#
# Helpers set ERR and return 1 instead of calling t_fail themselves: a
# t_fail inside a command substitution would land its FAIL line in a
# variable (the runner greps the LOG for it) and lose STATUS=1 with the
# subshell.

# scratch_under_br NAME : a fresh scratch dir under build-run/, removed on
# exit along with lib.sh's $WORK. The dblcompile harnesses' cwd MUST sit
# under the repo root -- their nested compiles do their own findRtDir /
# bkFindClarusC walk-up ("../" x10) at RUN time to locate runtime/clarus/
# and clarusc/clarusc.c, which a $TMPDIR cwd cannot satisfy.
scratch_under_br() {
    SCRATCH=$BR/tests-work/$1
    rm -rf "$SCRATCH"
    mkdir -p "$SCRATCH" || die "mkdir $SCRATCH"
    trap 'rm -rf "$WORK" "$SCRATCH"' EXIT
}

# leak_run DIR EXE [ARGS...] : run EXE with cwd DIR under the strict-memory
# ledger. On success sets LIVE (the ##CLARUS-MEM## live count), ERRLOG
# (stderr alone -- where the host lane's log() lands) and RUNLOG (both
# streams); on failure sets ERR and returns 1.
leak_run() {
    _dir=$1
    shift
    mkdir -p "$_dir" || die "mkdir $_dir"
    RUNLOG=$_dir/run.log
    ERRLOG=$_dir/err.log
    _rep=$_dir/report.txt
    LIVE=
    rm -f "$_rep"
    ( cd "$_dir" && CLARUS_MEM_STRICT=1 CLARUS_MEM_REPORT="$_rep" "$@" ) \
        > "$_dir/out.log" 2> "$ERRLOG"
    _rc=$?
    cat "$_dir/out.log" "$ERRLOG" > "$RUNLOG"
    if [ $_rc -ne 0 ]; then
        ERR="run failed (exit $_rc): $(tail -3 "$RUNLOG" | tr '\n' ' ')"
        return 1
    fi
    if [ ! -f "$_rep" ]; then ERR="no mem report at $_rep"; return 1; fi
    LIVE=$(mem_live "$_rep")
    if [ -z "$LIVE" ]; then ERR="mem report has no ##CLARUS-MEM## line"; return 1; fi
    return 0
}

# leak_fixture NAME FILE.cla : host_build the single fixture, run it under
# the ledger, PASS iff it exits 0 with zero live blocks at exit.
leak_fixture() {
    _n=$1
    if ! host_build "$WORK/$_n" "$2" > "$WORK/$_n.build.log" 2>&1; then
        t_fail "$_n" "build failed: $(tail -3 "$WORK/$_n.build.log" | tr '\n' ' ')"
        return 1
    fi
    if ! leak_run "$SCRATCH/$_n" "$WORK/$_n"; then
        t_fail "$_n" "$ERR"
        return 1
    fi
    if [ "$LIVE" != 0 ]; then
        t_fail "$_n" "live=$LIVE blocks at exit, want 0; $(grep '^rt_mem: leak' "$RUNLOG" | head -20 | tr '\n' ' ')"
        return 1
    fi
    t_pass "$_n"
}

# fork_identity NAME DIR [WHAT] : leakfork_0.bin vs leakfork_2.bin byte
# compare -- the stale-state oracle.
fork_identity() {
    _n=$1
    _d=$2
    _what=${3:-"stale state leaked into the 3rd compile fork"}
    for _f in leakfork_0.bin leakfork_2.bin; do
        if [ ! -f "$_d/$_f" ]; then t_fail "$_n" "missing $_f in $_d"; return 1; fi
    done
    cmp -s "$_d/leakfork_0.bin" "$_d/leakfork_2.bin" && return 0
    t_fail "$_n" "leakfork_0.bin ($(bytes_of "$_d/leakfork_0.bin") bytes) != leakfork_2.bin ($(bytes_of "$_d/leakfork_2.bin") bytes): $_what"
    return 1
}

# growth_ok NAME LIVE1 LIVEN LABEL : per-extra-compile live-block growth
# over a 3-compile run, (liveN - live1) / 2, must stay <= $GROWTH_LIMIT.
growth_ok() {
    _g=$(( ( $3 - $2 ) / 2 ))
    [ "$_g" -le "$GROWTH_LIMIT" ] && return 0
    t_fail "$1" "$4live-block growth per extra compile = $_g (live1=$2 live3=$3), want <= $GROWTH_LIMIT"
    return 1
}

bytes_of() { wc -c < "$1" | tr -d ' '; }
