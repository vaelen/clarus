#!/bin/sh
# timeout: 20m
# mactest/abort_mac -- port of internal/mactest/mac_test.go's
# TestAbortAppsOnMac: the Retro68/cprint diagnostic lane's single
# representative abort fixture, `emit_array`, built through
# scripts/build-mac.sh --test and booted. Byte-exact `out` against the
# SHARED testdata/run/emit_array.out golden (this lane predates the native
# lane's own .out68k trailing-panic-line variant -- see abort_68k.sh) and
# exit == its .exit golden.
. "$(dirname "$0")/../lib.sh"
. "$(dirname "$0")/../lib_mac.sh" || die "helper lib failed to load"
require_env CLARUS_CPRINT_MAC_TESTS

for name in emit_array; do
    golden=testdata/run/$name.out
    [ -f "$golden" ] || die "no out golden for $name"
    want_exit=$(tr -d ' \t\n' < "testdata/run/$name.exit") || die "reading $name.exit"
    case $want_exit in
        ''|*[!0-9]*) die "malformed golden exit code \"$want_exit\"" ;;
    esac

    bin=$(build_mac "Abort$name" "testdata/run/$name.cla" --test) || exit 1
    run_mac "$bin" 180

    bad=
    [ "$MAC_EXIT" = "$want_exit" ] || bad="exit: got $MAC_EXIT want $want_exit"
    if ! cmp -s "$WORK/cap.out" "$golden"; then
        bad="$bad; out mismatch vs $golden: $(first_diff "$golden" "$WORK/cap.out" | tr '\n' ' ')"
    fi
    if [ -n "$bad" ]; then t_fail "$name" "$bad"; else t_pass "$name"; fi
done

t_done
