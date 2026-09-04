#!/bin/sh
# timeout: 30m
# selfhost/crossgen -- port of internal/selfhost/crossgen_test.go's
# TestCrossGenDifferential. Generation N is the snapshot-bootstrapped
# clarusc (build-run/clarusc-snapshot, from the committed clarusc/clarusc.c);
# generation N+1 is current-source clarusc built BY generation N
# (build-run/clarusc-current). For every fixture in the runnable corpus both
# generations emit+compile+run it and their behavior_blob captures are
# compared. Run output, not byte-identical emitted C, is the oracle -- same
# strength as the retired Go differential sweep.
#
# Arbiter rule: an INTENTIONAL behavior change in clarusc/*.cla is fixed by
# re-blessing the affected .behavior goldens (selfhost/behavior), not here --
# this script only ever compares the two live-built generations.
. "$(dirname "$0")/../lib.sh"
. "$ROOT/tests/lib_selfhost.sh"

runnable_fixtures > "$WORK/fixtures"

while IFS= read -r f; do
    base=${f%.cla}
    name=${f#testdata/}

    set --
    case $f in
    testdata/run/*)
        if [ -f "$base.args" ]; then
            # strings.Fields: whitespace-split, hence deliberately unquoted
            set -- $(cat "$base.args")
        fi
        ;;
    esac

    if ! bo=$(fixture_build "$WORK/snap" "$CLARUSC_SNAPSHOT" "$f" 2>&1); then
        t_fail "$name" "$bo"
        continue
    fi
    if ! bo=$(fixture_build "$WORK/cur" "$CLARUSC" "$f" 2>&1); then
        t_fail "$name" "$bo"
        continue
    fi

    behavior_blob "$WORK/snap" "$WORK/snap.blob" "$@"
    behavior_blob "$WORK/cur" "$WORK/cur.blob" "$@"

    if cmp -s "$WORK/snap.blob" "$WORK/cur.blob"; then
        t_pass "$name"
    else
        t_fail "$name" "generation divergence for $f
snapshot: $(cat "$WORK/snap.blob")
current:  $(cat "$WORK/cur.blob")"
    fi
done < "$WORK/fixtures"

t_done
