# tests/lib_selfhost.sh -- helpers for tests/selfhost/*.sh, the port of
# internal/selfhost's six Go-free oracles (go-retirement Task 12). Sourced
# by each of those scripts right after the frozen tests/lib.sh.

# runnable_fixtures : print the runnable corpus one path per line --
# testdata/run/*.cla first, then testdata/runerr/*.cla. These are the two
# directories that are actually EXECUTED (as opposed to
# testdata/{valid,errors,include,diag}); mirrors behavior_test.go's
# runnableFixtures, including its t.Fatal when either family is empty.
# Callers tell the two families apart by the path prefix.
runnable_fixtures() {
    _rf_n=0
    for _rf_f in testdata/run/*.cla; do
        [ -f "$_rf_f" ] || continue
        echo "$_rf_f"
        _rf_n=$((_rf_n + 1))
    done
    [ "$_rf_n" -gt 0 ] || die "no testdata/run fixtures found"
    _rf_n=0
    for _rf_f in testdata/runerr/*.cla; do
        [ -f "$_rf_f" ] || continue
        echo "$_rf_f"
        _rf_n=$((_rf_n + 1))
    done
    [ "$_rf_n" -gt 0 ] || die "no testdata/runerr fixtures found"
}

# fixture_build OUTBIN CLARUSC FIXTURE.cla : `clarusc emit --rtdir` + `cc`
# against the on-disk host runtime, host binary at OUTBIN (emitted C at
# OUTBIN.c). The compiler-parametrized twin of lib.sh's host_build, which
# hardcodes the current generation -- behavior/crossgen need the snapshot
# generation too. Prints the failing tool's output and returns 1.
fixture_build() {
    _fb_bin=$1; _fb_cc=$2; _fb_cla=$3
    if ! "$_fb_cc" emit --rtdir "$RTDIR" -o "$_fb_bin.c" "$_fb_cla" \
            > "$WORK/fb.log" 2>&1; then
        echo "clarusc emit $_fb_cla failed:"
        cat "$WORK/fb.log"
        return 1
    fi
    if ! $CC -O1 -I "$HOSTRT" "$_fb_bin.c" "$HOSTRT/rt.c" -o "$_fb_bin" \
            > "$WORK/fb.log" 2>&1; then
        echo "cc compile emitted C for $_fb_cla failed:"
        cat "$WORK/fb.log"
        return 1
    fi
}

# behavior_blob EXE OUT [ARGV...] : run EXE (an absolute path) with ARGV in
# a fresh empty cwd -- fixtures touch the filesystem and must not litter the
# source tree -- and write the captured run into OUT in the byte-exact
# layout of behavior_test.go's behaviorBlob:
#
#   exit=<N>\n--- stdout ---\n<stdout bytes>--- stderr ---\n<stderr bytes>
#
# Note there is NO separator before "--- stderr ---": stdout's bytes butt
# straight against it, exactly as bytes.Buffer.Write does.
#
# The run inherits whatever the caller exported (behavior.sh exports the
# strict-mode CLARUS_MEM_* trio for the run corpus). Also sets BB_EXIT and
# BB_OUT/BB_ERR -- the exit status and the two capture files -- valid until
# the next call, so callers can additionally diff stdout/stderr against
# .out/.log goldens.
#
# ponytail: a signal-killed fixture records 128+N here where Go's
# ExitCode() records -1. No corpus fixture dies on a signal; revisit only
# if one starts to.
behavior_blob() {
    _bb_exe=$1; _bb_out=$2
    shift 2
    BB_OUT=$WORK/bb.stdout
    BB_ERR=$WORK/bb.stderr
    rm -rf "$WORK/bbcwd"
    mkdir -p "$WORK/bbcwd"
    ( cd "$WORK/bbcwd" && exec "$_bb_exe" "$@" ) > "$BB_OUT" 2> "$BB_ERR"
    BB_EXIT=$?
    printf 'exit=%d\n--- stdout ---\n' "$BB_EXIT" > "$_bb_out"
    cat "$BB_OUT" >> "$_bb_out"
    printf '%s\n' '--- stderr ---' >> "$_bb_out"
    cat "$BB_ERR" >> "$_bb_out"
}

# check_mem_report REPORT LEAKSFILE NAME : mirrors behavior_test.go's
# checkMemReport. The report's FIRST line must be "##CLARUS-MEM## live=<N>"
# (lib.sh's mem_live takes the LAST match anywhere in a log, which is a
# weaker assertion -- not used here) and N must equal LEAKSFILE's integer,
# or 0 when that file does not exist. t_fail's and returns 1 on mismatch.
check_mem_report() {
    if [ ! -f "$1" ]; then
        t_fail "$3" "runtime wrote no mem report -- is STRICT plumbed? ($1)"
        return 1
    fi
    _cm_want=0
    if [ -f "$2" ]; then
        _cm_want=$(tr -d '[:space:]' < "$2")
        case $_cm_want in
            '' | *[!0-9]*) t_fail "$3" "bad .leaks: $2"; return 1 ;;
        esac
    fi
    _cm_first=$(head -1 "$1")
    case $_cm_first in
        '##CLARUS-MEM## live='[0-9]*) ;;
        *) t_fail "$3" "mem report missing ##CLARUS-MEM## header: $_cm_first"
           return 1 ;;
    esac
    _cm_got=${_cm_first#'##CLARUS-MEM## live='}
    _cm_got=$(printf '%s' "$_cm_got" | sed 's/[^0-9].*$//')
    [ "$_cm_got" = "$_cm_want" ] && return 0
    t_fail "$3" "live leaks: got $_cm_got want $_cm_want
--- mem report ---
$(cat "$1")"
    return 1
}

# first_divergence A B LABELA LABELB : reproduce fixedpoint_test.go's
# diffFirstDivergence -- the 1-based first differing line plus +-2 lines of
# context from each side, ">>> " marking the divergent line.
#
# ponytail: Go splits on "\n" so a trailing newline yields one extra empty
# element; awk's record count omits it. Only reachable when the sole
# difference is a missing final newline, and this text is a diagnostic, not
# an assertion -- the cmp above it is what passes or fails.
first_divergence() {
    awk -v la="$3" -v lb="$4" '
    function ctx(arr, n, at,    lo, hi, j) {
        lo = at - 2; if (lo < 1) lo = 1
        hi = at + 2; if (hi > n) hi = n
        for (j = lo; j <= hi; j++)
            printf "%s%5d: %s\n", (j == at ? ">>> " : "    "), j, arr[j]
    }
    NR == FNR { a[FNR] = $0; na = FNR; next }
    { b[FNR] = $0; nb = FNR }
    END {
        n = (na < nb) ? na : nb
        i = 1
        while (i <= n && a[i] == b[i]) i++
        if (i > na || i > nb)
            printf "first divergence at line %d: one side ends early (%s has %d lines, %s has %d lines)\n", i, la, na, lb, nb
        else
            printf "first divergence at line %d:\n", i
        printf "--- %s ---\n", la; ctx(a, na, i)
        printf "--- %s ---\n", lb; ctx(b, nb, i)
    }' "$1" "$2"
}
