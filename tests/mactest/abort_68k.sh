#!/bin/sh
# timeout: 20m
# mactest/abort_68k -- port of internal/mactest/native_test.go's
# TestAbortOn68k: the `emit_array` abort fixture (7 lines of pre-panic
# alert() output, then a deliberate array-bounds panic) booted natively.
# Expectation is byte-exact `out` against its golden and exit == its .exit
# golden.
#
# The golden is testdata/run/<name>.out68k when that file exists, else the
# shared testdata/run/<name>.out: native.cla's nat_CorePanic writes the
# "runtime error: ..." trace line to `out` IMMEDIATELY via natAlert, ahead
# of natQuit's buffered-log trailer, so on THIS lane only an aborting
# fixture's `out` ends with that extra line.
. "$(dirname "$0")/../lib.sh"
. "$(dirname "$0")/../lib_mac.sh"
require_env CLARUS_MAC_TESTS

for name in emit_array; do
    golden=testdata/run/$name.out68k
    [ -f "$golden" ] || golden=testdata/run/$name.out
    [ -f "$golden" ] || die "no out golden for $name"
    want_exit=$(tr -d ' \t\n' < "testdata/run/$name.exit") || die "reading $name.exit"
    case $want_exit in
        ''|*[!0-9]*) die "malformed golden exit code \"$want_exit\"" ;;
    esac

    emit68k -o "$WORK/abort$name.bin" "testdata/run/$name.cla" \
        > "$WORK/emit.log" 2>&1 \
        || die "clarusc emit68k testdata/run/$name.cla: $(tail -10 "$WORK/emit.log")"
    run_mac "$WORK/abort$name.bin" 180

    bad=
    [ "$MAC_EXIT" = "$want_exit" ] || bad="exit: got $MAC_EXIT want $want_exit"
    if ! cmp -s "$WORK/cap.out" "$golden"; then
        bad="$bad; out mismatch vs $golden: $(first_diff "$golden" "$WORK/cap.out" | tr '\n' ' ')"
    fi
    if [ -n "$bad" ]; then t_fail "$name" "$bad"; else t_pass "$name"; fi
done

t_done
