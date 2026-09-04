#!/bin/sh
# timeout: 20m
# mactest/native_compare -- port of internal/mactest/native_test.go's
# TestNativeSmoke / TestNativeStrContainers / TestNativeArrWholeAssign (all
# three call runNativeHostCompare). Each fixture is built BOTH ways -- the
# host expectation via `clarusc emit` + cc, the native image via `clarusc
# emit68k --listing` -- and the emulator's captured `out` must be
# byte-identical to the host binary's stdout, with both exit codes 0.
# The CODE-segment count each build produced is logged (visible evidence
# that packing really did or did not split the app).
. "$(dirname "$0")/../lib.sh"
. "$(dirname "$0")/../lib_mac.sh" || die "helper lib failed to load"
require_env CLARUS_MAC_TESTS

for name in smoke strcontainers arr_whole_assign; do
    fixture=testdata/cg68k/$name.cla

    # --- host oracle: clarusc emit + cc, run in a fresh cwd -------------
    if ! host_build "$WORK/host_$name" "$fixture" > "$WORK/hostbuild.log" 2>&1; then
        t_fail "$name" "host build failed: $(tail -10 "$WORK/hostbuild.log")"
        continue
    fi
    mkdir -p "$WORK/hostrun_$name"
    if ! ( cd "$WORK/hostrun_$name" && "$WORK/host_$name" ) \
            > "$WORK/want_$name" 2> "$WORK/hostrun.err"; then
        t_fail "$name" "run host $name failed: $(tail -5 "$WORK/hostrun.err")"
        continue
    fi

    # --- native image ---------------------------------------------------
    run=$WORK/nat_$name
    mkdir -p "$run" || die "mkdir $run"
    if ! emit68k -o "$run/native.bin" --listing "$fixture" > "$WORK/emit.log" 2>&1; then
        t_fail "$name" "clarusc emit68k --listing $fixture failed: $(tail -10 "$WORK/emit.log")"
        continue
    fi
    segs=0
    while [ -f "$run/native.seg$((segs + 1)).s" ]; do segs=$((segs + 1)); done
    echo "$name packed into $segs CODE segment(s) (seglimit=0)"

    run_mac "$run/native.bin" 300
    if [ "$MAC_EXIT" != 0 ]; then
        t_fail "$name" "exit code $MAC_EXIT, want 0"
    elif ! cmp -s "$WORK/cap.out" "$WORK/want_$name"; then
        t_fail "$name" "output mismatch (native vs host): $(first_diff "$WORK/want_$name" "$WORK/cap.out" | tr '\n' ' ')"
    else
        t_pass "$name"
    fi
done

t_done
