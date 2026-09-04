#!/bin/sh
# testsuite/core_cli.sh -- port of internal/testsuite/core_cli_test.go
# TestCoreSuiteCLI: builds the core suite's host CLI (internal/mactest's
# `coreCLIFiles` composition + testsuite/core/cli.cla, kit.cla first) and
# drives it three ways -- `all`, one named case, an unknown name -- parsing
# the normative `PASS <name>` / `FAIL <name>: <detail>` / `TOTAL <n> PASS
# <p> FAIL <f>` log format from kit.cla's tkReport.
#
# The `all` case's expected case names, in order, are core_cases.txt (the
# Go test's wantCases list).
. "$(dirname "$0")/../lib.sh" || exit 2

cases=$ROOT/tests/testsuite/core_cases.txt
ncases=$(wc -l < "$cases" | tr -d ' ')

# --- build ------------------------------------------------------------
# host_build == `clarusc emit --rtdir runtime/clarus/ -o X.c FILES` + cc -O1
# against runtime/host/rt.c, the same recipe as buildCoreCLI.
if ! host_build "$WORK/core_cli" \
        testsuite/kit.cla \
        testsuite/core/runner.cla \
        testsuite/core/cases_str.cla \
        testsuite/core/cases_text.cla \
        testsuite/core/cases_list.cla \
        testsuite/core/cases_map.cla \
        testsuite/core/cases_sortedmap.cla \
        testsuite/core/cases_intmap.cla \
        testsuite/core/cases_rec.cla \
        testsuite/core/cases_arr.cla \
        testsuite/core/cases_enumfix.cla \
        testsuite/core/cases_ser.cla \
        testsuite/core/cases_misc.cla \
        testsuite/core/cases_xrec.cla \
        testsuite/core/cases_datetime.cla \
        testsuite/core/cases_param.cla \
        testsuite/core/cases_abort.cla \
        testsuite/core/cases_textrange.cla \
        testsuite/core/cases_errret.cla \
        testsuite/core/cases_evalorder.cla \
        testsuite/core/cases_textbinary.cla \
        testsuite/core/cases_fileh.cla \
        testsuite/core/cases_dirops.cla \
        testsuite/core/cases_ptrcall.cla \
        testsuite/core/cli.cla > "$WORK/build.log" 2>&1; then
    die "build core CLI: $(tail -10 "$WORK/build.log")"
fi

# run_case NAME ARGV... : run the CLI in a fresh cwd (the ser family does
# real file I/O -- keep its scratch files out of the repo tree), leaving
# stdout in $WORK/$1.out and the exit code in $rc.
run_case() {
    _n=$1; shift
    mkdir -p "$WORK/run_$_n"
    ( cd "$WORK/run_$_n" && "$WORK/core_cli" "$@" ) > "$WORK/$_n.out" 2> "$WORK/$_n.err"
    rc=$?
}

# bad_lines FILE : print any line that is not PASS/FAIL/TOTAL (parseCoreLog
# fatals on an unrecognized log line).
bad_lines() { grep -v -E '^(PASS |FAIL |TOTAL )' "$1"; }

# --- all --------------------------------------------------------------
n=all
run_case all all
if [ ! -s "$WORK/all.out" ]; then
    t_fail "$n" "empty stdout, expected at least a TOTAL line"
elif [ -n "$(bad_lines "$WORK/all.out")" ]; then
    t_fail "$n" "unrecognized log line: $(bad_lines "$WORK/all.out" | head -1)"
elif [ $rc -ne 0 ]; then
    t_fail "$n" "expected exit 0, got $rc: $(grep '^FAIL ' "$WORK/all.out" | head -3 | tr '\n' ' ')"
else
    total=$(grep '^TOTAL ' "$WORK/all.out")
    sed -n 's/^PASS //p' "$WORK/all.out" > "$WORK/all.names"
    nlines=$(grep -c -E '^(PASS |FAIL )' "$WORK/all.out" | tr -d ' ')
    if [ "$total" != "TOTAL $ncases PASS $ncases FAIL 0" ]; then
        t_fail "$n" "TOTAL line: got \"$total\", want \"TOTAL $ncases PASS $ncases FAIL 0\""
    elif [ "$nlines" != "$ncases" ]; then
        t_fail "$n" "expected $ncases case lines, got $nlines"
    elif ! cmp -s "$WORK/all.names" "$cases"; then
        t_fail "$n" "case names/order: $(first_diff "$cases" "$WORK/all.names" | tr '\n' ' ')"
    else
        t_pass "$n"
    fi
fi

# --- single case ------------------------------------------------------
n=single_case
run_case single StrIndexing
if [ -n "$(bad_lines "$WORK/single.out")" ]; then
    t_fail "$n" "unrecognized log line: $(bad_lines "$WORK/single.out" | head -1)"
elif [ $rc -ne 0 ]; then
    t_fail "$n" "expected exit 0, got $rc: $(head -3 "$WORK/single.out" | tr '\n' ' ')"
elif [ "$(grep -c -E '^(PASS |FAIL )' "$WORK/single.out" | tr -d ' ')" != 1 ]; then
    t_fail "$n" "expected exactly 1 case line: $(grep -E '^(PASS |FAIL )' "$WORK/single.out" | tr '\n' ' ')"
elif [ "$(grep -E '^(PASS |FAIL )' "$WORK/single.out")" != "PASS StrIndexing" ]; then
    t_fail "$n" "got \"$(grep -E '^(PASS |FAIL )' "$WORK/single.out")\", want \"PASS StrIndexing\""
elif [ "$(grep '^TOTAL ' "$WORK/single.out")" != "TOTAL 1 PASS 1 FAIL 0" ]; then
    t_fail "$n" "TOTAL line: got \"$(grep '^TOTAL ' "$WORK/single.out")\", want \"TOTAL 1 PASS 1 FAIL 0\""
else
    t_pass "$n"
fi

# --- unknown case -----------------------------------------------------
n=unknown_case
run_case unknown NotACase
if [ -n "$(bad_lines "$WORK/unknown.out")" ]; then
    t_fail "$n" "unrecognized log line: $(bad_lines "$WORK/unknown.out" | head -1)"
elif [ $rc -eq 0 ]; then
    t_fail "$n" "expected nonzero exit for an unknown case, got 0"
elif [ "$(grep -c -E '^(PASS |FAIL )' "$WORK/unknown.out" | tr -d ' ')" != 1 ] \
        || [ "$(awk '/^TOTAL /{print $6}' "$WORK/unknown.out")" != 1 ]; then
    t_fail "$n" "expected exactly 1 FAIL line: $(cat "$WORK/unknown.out" | tr '\n' ' ')"
elif [ "$(grep -E '^(PASS |FAIL )' "$WORK/unknown.out")" != "FAIL NotACase: unknown test case" ]; then
    t_fail "$n" "got \"$(grep -E '^(PASS |FAIL )' "$WORK/unknown.out")\", want \"FAIL NotACase: unknown test case\""
else
    t_pass "$n"
fi

t_done
