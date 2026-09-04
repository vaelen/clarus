#!/bin/sh
# timeout: 30m
# selfhost/behavior -- port of internal/selfhost/behavior_test.go's
# TestBehaviorGoldens, the Go-free drift arbiter. For every fixture in the
# runnable corpus the SNAPSHOT-bootstrapped clarusc emits + compiles + runs
# it, and the captured (exit, stdout, stderr) is byte-compared against the
# committed <base>.behavior golden (CLARUS_BLESS_BEHAVIOR=1 rewrites them).
# Where a fixture also carries the older .out/.exit/.log (run) or .err
# (runerr) goldens, those are cross-checked too -- even while blessing,
# since they are independent of the new golden. testdata/run additionally
# runs under the strict+paranoid allocator and its live-leak count is
# checked against an optional .leaks golden (default 0).
. "$(dirname "$0")/../lib.sh"
. "$ROOT/tests/lib_selfhost.sh"

runnable_fixtures > "$WORK/fixtures"

while IFS= read -r f; do
    base=${f%.cla}
    name=${f#testdata/}

    if ! bo=$(fixture_build "$WORK/prog" "$CLARUSC_SNAPSHOT" "$f" 2>&1); then
        t_fail "$name" "$bo"
        continue
    fi

    ok=1
    case $f in
    testdata/run/*)
        set --
        if [ -f "$base.args" ]; then
            # strings.Fields: whitespace-split, hence deliberately unquoted
            set -- $(cat "$base.args")
        fi
        wantexit=0
        if [ -f "$base.exit" ]; then
            wantexit=$(tr -d '[:space:]' < "$base.exit")
            case $wantexit in
                '' | *[!0-9]*) t_fail "$name" "bad .exit: $base.exit"; continue ;;
            esac
        fi

        mem=$WORK/mem.txt
        rm -f "$mem"
        export CLARUS_MEM_STRICT=1 CLARUS_MEM_PARANOID=1 CLARUS_MEM_REPORT="$mem"
        behavior_blob "$WORK/prog" "$WORK/blob" "$@"
        unset CLARUS_MEM_STRICT CLARUS_MEM_PARANOID CLARUS_MEM_REPORT

        if [ "$BB_EXIT" != "$wantexit" ]; then
            t_fail "$name" "exit: got $BB_EXIT want $wantexit (stderr: $(cat "$BB_ERR"))"
            ok=0
        fi
        if [ -f "$base.out" ] && ! cmp -s "$BB_OUT" "$base.out"; then
            t_fail "$name" "stdout vs $base.out golden mismatch
$(diff -u "$base.out" "$BB_OUT" | head -40)"
            ok=0
        fi
        if [ -f "$base.log" ] && ! cmp -s "$BB_ERR" "$base.log"; then
            t_fail "$name" "stderr vs $base.log golden mismatch
$(diff -u "$base.log" "$BB_ERR" | head -40)"
            ok=0
        fi
        golden_check "$WORK/blob" "$base.behavior" CLARUS_BLESS_BEHAVIOR || {
            t_fail "$name" "behavior golden $base.behavior mismatch"
            ok=0
        }
        check_mem_report "$mem" "$base.leaks" "$name" || ok=0
        ;;
    testdata/runerr/*)
        if [ ! -f "$base.err" ]; then
            t_fail "$name" "read $base.err: no such file"
            continue
        fi
        # strings.TrimSpace of the whole golden: $(cat) drops trailing
        # newlines, sed drops leading/trailing blanks.
        want=$(cat "$base.err")
        want=$(printf '%s' "$want" | sed -e '1s/^[[:space:]]*//' -e '$s/[[:space:]]*$//')

        # Historical default: every pre-existing runerr fixture is an
        # rt_panic, which exits 3. An optional .exit golden overrides it
        # (the uncaught-abort default exits 1).
        wantexit=3
        if [ -f "$base.exit" ]; then
            wantexit=$(tr -d '[:space:]' < "$base.exit")
            case $wantexit in
                '' | *[!0-9]*) t_fail "$name" "bad .exit: $base.exit"; continue ;;
            esac
        fi

        behavior_blob "$WORK/prog" "$WORK/blob"

        if [ "$BB_EXIT" != "$wantexit" ]; then
            t_fail "$name" "exit: got $BB_EXIT want $wantexit (stderr: $(cat "$BB_ERR"))"
            ok=0
        fi
        errtxt=$(cat "$BB_ERR")
        case $errtxt in
            *"$want"*) ;;
            *) t_fail "$name" "stderr $errtxt missing $want"; ok=0 ;;
        esac
        golden_check "$WORK/blob" "$base.behavior" CLARUS_BLESS_BEHAVIOR || {
            t_fail "$name" "behavior golden $base.behavior mismatch"
            ok=0
        }
        ;;
    esac
    [ "$ok" = 1 ] && t_pass "$name"
done < "$WORK/fixtures"

t_done
