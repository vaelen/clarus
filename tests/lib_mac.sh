# tests/lib_mac.sh -- group helpers for tests/mactest/* (the Mini vMac /
# Retro68 emulator lane). Sourced by every script in that group right
# after lib.sh, which stays frozen.
#
# Ports internal/mactest's RunMac/parseCapture (mac_test.go),
# parseUIOutput/pbmBytes/checkUIGoldens (ui_test.go) and
# checkCoreSuiteCapture/checkToolboxSuiteCapture (coresuite_test.go).
#
# Emulator boots are SERIAL by construction: LaunchAPPL boots a whole Mac,
# so `make test T=mactest/` must run with -j1 (see the root Makefile's own
# t2/smoke recipes).

MAC_EXIT=

# run_mac BIN SECS : LaunchAPPL -e minivmac BIN with cwd=$WORK/launch
# (LaunchAPPL makes its temp dir in cwd) under a SECS deadline. On expiry
# the detached emulator survives the group kill, so sweep it up with pkill
# and die -- exactly what RunMac's ctx.Err() branch does. The raw capture
# lands in $WORK/cap.raw and is split by capture_split.
run_mac() {
    mkdir -p "$WORK/launch"
    ( cd "$WORK/launch" && "$TOOLS/timeout" "$2" \
        "$ROOT/toolchain/bin/LaunchAPPL" -e minivmac "$1" \
        > "$WORK/cap.raw" 2> "$WORK/cap.err" )
    _rc=$?
    if [ $_rc -eq 124 ]; then
        pkill -f minivmac.app
        die "LaunchAPPL $1 timed out after $2s (emulator killed): $(head -5 "$WORK/cap.err")"
    fi
    [ $_rc -eq 0 ] || die "LaunchAPPL $1 failed ($_rc): $(head -5 "$WORK/cap.err")"
    capture_split "$WORK/cap.raw"
}

# capture_split RAW : split the capture at the LAST "##CLARUS-EXIT## "
# line (the record may legitimately start at byte 0 for an alert-free
# program) into $WORK/cap.out (everything before it, byte-exact), the
# integer after the marker (-> MAC_EXIT) and $WORK/cap.log (everything
# after the mandatory "##CLARUS-LOG##" line that follows it). Mirrors
# parseCapture, including its three malformed-trailer fatals.
capture_split() {
    : > "$WORK/cap.out"
    : > "$WORK/cap.log"
    # `lg`, not `log`: awk has a BUILT-IN log() function, and one-true-awk
    # (macOS /usr/bin/awk) silently discards `print ... > log` when the
    # redirection target names it -- an empty cap.log with a zero exit
    # status, which is exactly what the four runerr_68k cases caught.
    awk -v out="$WORK/cap.out" -v lg="$WORK/cap.log" -v ex="$WORK/cap.exit" '
        { lines[NR] = $0; if (index($0, "##CLARUS-EXIT## ") == 1) last = NR }
        END {
            if (!last) exit 1
            for (i = 1; i < last; i++) print lines[i] > out
            sub(/^##CLARUS-EXIT## /, "", lines[last]); print lines[last] > ex
            if (lines[last + 1] != "##CLARUS-LOG##") exit 2
            for (i = last + 2; i <= NR; i++) print lines[i] > lg
        }' "$1"
    case $? in
        0) ;;
        1) die "no \"##CLARUS-EXIT## \" trailer in capture ($1, $(wc -c < "$1") bytes): $(head -20 "$1")" ;;
        *) die "malformed capture trailer: expected \"##CLARUS-LOG##\" after the exit code ($1): $(tail -5 "$1")" ;;
    esac
    MAC_EXIT=$(cat "$WORK/cap.exit")
    case $MAC_EXIT in
        ''|*[!0-9]*) die "malformed exit code \"$MAC_EXIT\" in capture ($1)" ;;
    esac
}

# ui_split OUT : split a UI capture's `out` stream into $WORK/ui.trace
# (every "T ..." line, in order) and one $WORK/snap.NAME.pbm per
# "##CLARUS-SNAP## NAME" ... hex ... "##CLARUS-SNAP-END##" block, wrapped
# in the pinned P4 512x342 header. Like parseUIOutput this REJECTS any
# line that is neither a trace line, a snap marker/body, nor empty, and
# rejects an unterminated snap block or a snap that does not decode to
# exactly 21,888 bytes.
ui_split() {
    rm -f "$WORK"/snap.*.hex "$WORK"/snap.*.pbm
    grep '^T ' "$1" > "$WORK/ui.trace"
    awk -v w="$WORK" '
        f && $0 == "##CLARUS-SNAP-END##" {
            print hex > (w "/snap." name ".hex"); close(w "/snap." name ".hex"); f = 0; next }
        f { hex = hex $0; next }
        /^##CLARUS-SNAP## / { name = $2; hex = ""; f = 1; next }
        /^T / { next }
        $0 == "" { next }
        { print "unexpected capture line outside trace/snap: " $0; bad = 1 }
        END { if (f) { print "unterminated snap block " name; bad = 1 }
              exit bad ? 1 : 0 }' "$1" || die "malformed UI capture ($1)"
    for _h in "$WORK"/snap.*.hex; do
        [ -e "$_h" ] || break
        _n=${_h%.hex}
        { printf 'P4\n512 342\n'; xxd -r -p "$_h"; } > "$_n.pbm"
        _sz=$(wc -c < "$_n.pbm" | tr -d ' ')
        [ "$_sz" = 21899 ] || die "snap ${_n##*/snap.}: decoded to $((_sz - 11)) bytes, want 21888"
    done
}

# ui_goldens SCENARIO WANT_EXIT : the checkUIGoldens contract -- exit code,
# testdata/ui/SCENARIO.trace and every produced snap against
# testdata/uisnaps/SCENARIO.NAME.pbm, byte-exact (or rewritten under
# CLARUS_MAC_BLESS=1).
ui_goldens() {
    [ "$MAC_EXIT" = "$2" ] || t_fail "$1/exit" "exit $MAC_EXIT, want $2"
    golden_check "$WORK/ui.trace" "testdata/ui/$1.trace" CLARUS_MAC_BLESS || t_fail "$1/trace" mismatch
    for _p in "$WORK"/snap.*.pbm; do
        [ -e "$_p" ] || break
        _n=${_p#"$WORK"/snap.}; _n=${_n%.pbm}
        golden_check "$_p" "testdata/uisnaps/$1.$_n.pbm" CLARUS_MAC_BLESS \
            || t_fail "$1/snap.$_n" mismatch
    done
}

# suite_report_check OUT WANT_CASES : the tkReport PASS/FAIL/TOTAL contract
# both suite gates assert. Re-emits every case line so the runner reports
# one subcase per suite case (checkToolboxSuiteCapture's per-case t.Run).
suite_report_check() {
    grep -E '^(PASS|FAIL) ' "$1"
    _p=$(grep -c '^PASS ' "$1" | tr -d ' ')
    _f=$(grep -c '^FAIL ' "$1" | tr -d ' ')
    [ "$_p" -eq "$2" ] || t_fail total "PASS lines $_p, want $2"
    [ "$_f" -eq 0 ] || t_fail total "$_f FAIL lines"
    grep -qx "TOTAL $2 PASS $2 FAIL 0" "$1" || t_fail total "TOTAL line missing or wrong: $(grep '^TOTAL ' "$1")"
}

# toolbox_emit68k OUT EVENTS : build the toolbox suite's native image
# (toolbox_files.txt + --testapi + --bake), the shared body of
# toolbox_68k.sh and toolbox_jiggle.sh.
#
# Run from $BR/emitcwd -- a directory exactly TWO levels below the repo
# root, so `../../<path>` resolves the same way it does from
# internal/mactest, where the Go test ran clarusc. That is load-bearing for
# --bake and only for --bake: Get1NamedResource keys the baked 'CLFS'
# resource by the VERBATIM string on the command line, and
# testsuite/toolbox/cases_resources.cla's own tbResBakeName is
# "../../testdata/mac-resident/resbake.bin", character for character. The
# .cla/--events arguments get the same ../../ prefix for the same cwd.
toolbox_emit68k() {
    mkdir -p "$BR/emitcwd" || die "mkdir $BR/emitcwd"
    _args=
    while IFS= read -r _f; do
        [ -n "$_f" ] || continue
        _args="$_args ../../$_f"
    done < "$ROOT/tests/mactest/toolbox_files.txt"
    # Word splitting is the point: the list has no spaces in it.
    # shellcheck disable=SC2086
    ( cd "$BR/emitcwd" && "$CLARUSC" emit68k --rtdir "$RTDIR" -o "$1" \
        --events "../../$2" --testapi \
        --bake ../../testdata/mac-resident/resbake.bin $_args ) \
        > "$WORK/emit.log" 2>&1 \
        || die "clarusc emit68k toolbox suite: $(tail -20 "$WORK/emit.log")"
}

# build_mac NAME ARGS... : scripts/build-mac.sh NAME ARGS... (the Retro68/
# cprint lane's runBuildMac), echoing the built .bin's path. Shared by the
# four CLARUS_CPRINT_MAC_TESTS-gated boot scripts.
build_mac() {
    _name=$1; shift
    "$ROOT/scripts/build-mac.sh" "$_name" "$@" > "$WORK/buildmac.log" 2>&1 \
        || die "build-mac.sh $_name failed: $(tail -10 "$WORK/buildmac.log")"
    _bin=$ROOT/build-mac/$_name/$_name.bin
    [ -f "$_bin" ] || die "expected built binary $_bin (build-mac.sh output: $(tail -5 "$WORK/buildmac.log"))"
    echo "$_bin"
}
