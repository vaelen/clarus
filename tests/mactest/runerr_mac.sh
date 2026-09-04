#!/bin/sh
# timeout: 20m
# mactest/runerr_mac -- port of internal/mactest/mac_test.go's
# TestRunErrOnMac: the Retro68/cprint diagnostic lane's single
# representative panic fixture, `oob` (plain array-bounds panic, the
# simplest real-mode trap shape), built through scripts/build-mac.sh
# --test and booted. Must exit 3 with the fixture's own .err text in the
# captured log.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_mac.sh" || die "helper lib failed to load"
require_env CLARUS_CPRINT_MAC_TESTS

for base in oob; do
    want=$(cat "testdata/runerr/$base.err") || die "reading testdata/runerr/$base.err"
    bin=$(build_mac "Err$base" "testdata/runerr/$base.cla" --test) || exit 1
    run_mac "$bin" 180

    bad=
    [ "$MAC_EXIT" = 3 ] || bad="exit: got $MAC_EXIT want 3"
    if ! grep -qF "$want" "$WORK/cap.log"; then
        bad="$bad; log \"$(tr '\n' ' ' < "$WORK/cap.log")\" missing \"$want\""
    fi
    if [ -n "$bad" ]; then t_fail "$base" "$bad"; else t_pass "$base"; fi
done

t_done
