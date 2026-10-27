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

# mac_launch DIR : the LaunchAPPL command line for one Mini vMac
# boot, every option explicit so nothing depends on ~/.LaunchAPPL.cfg or a
# RETRO68 prefix config (--config-file /dev/null replaces both defaults).
# DIR is the machine directory (macplus/ or macplus2/): its Linux Mini vMac
# binary is named after the directory, next to vMac.ROM, disk1.dsk
# (System 6.0.8, the --system-image) and autoquit-1.1.1.dsk.
#
# Nothing here writes into DIR: LaunchAPPL COPIES the emulator binary into
# its own temp dir under the cwd, builds a fresh disk1.dsk boot disk there,
# symlinks the ROM, and only ever mounts the system and AutoQuit images
# read-only (MiniVMac.cc). That matters because Andrew runs ./macplus/macplus
# on macplus/disk1.dsk himself. `AppleTalk` is carried onto the stripped
# boot disk (--system-extra-file, upstream PR #316) so .XPP/.DSP open.
#
# The binary must be a LocalTalk build (`-lt -lto udp`, Mini vMac's X11
# api -- the SDL2 api has no LocalTalk) and must run in background
# (WantInitRunInBackground 1, which `-lt` defaults on; else `-bg 1`): a
# build that pauses when its window loses keyboard focus stalls a boot on
# a desktop in use until its deadline (measured 2026-09-27: 1s of CPU in
# 150s; toolbox_68k and toolbox_jiggle timed out). CLARUS_MINIVMAC=/abs/path overrides the
# binary for both machines, e.g. to try a rebuild without touching DIR.
mac_launch() {
    _d=$ROOT/$1
    _bin=${CLARUS_MINIVMAC:-$_d/$1}
    [ -x "$_bin" ] || skip "$_bin (Linux Mini vMac) not present"
    [ -n "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ] \
        || die "DISPLAY is not set -- emulator boots need an X display (e.g. DISPLAY=:0 XAUTHORITY=/run/user/1000/.mutter-Xwaylandauth.*)"
    MAC_LAUNCH="$ROOT/toolchain/bin/LaunchAPPL --config-file /dev/null -e minivmac \
        --minivmac-dir $_d --minivmac-path $_bin --minivmac-rom ./vMac.ROM \
        --system-image ./disk1.dsk --autoquit-image ./autoquit-1.1.1.dsk \
        --system-extra-file AppleTalk"
}

# mac_kill_ours DIR : kill every emulator LaunchAPPL started under DIR --
# its copy is DIR/<tempdir>/minivmac, so a pattern containing our own
# unique $WORK path can only ever match our own boots, never Andrew's
# ./macplus/macplus or another script's.
mac_kill_ours() { pkill -f "^$1/[^ ]*/minivmac" 2>/dev/null; :; }

# run_mac BIN SECS : LaunchAPPL BIN on macplus/ with cwd=$WORK/launch
# (LaunchAPPL makes its temp dir -- and its copy of the emulator -- in cwd)
# under a SECS deadline. On expiry the emulator is swept up by its $WORK
# path and the script dies -- exactly what RunMac's ctx.Err() branch did.
# The raw capture lands in $WORK/cap.raw and is split by capture_split.
run_mac() {
    mac_launch macplus
    mkdir -p "$WORK/launch"
    # Word splitting of $MAC_LAUNCH is the point (no spaces in its paths).
    # shellcheck disable=SC2086
    ( cd "$WORK/launch" && "$TOOLS/timeout" "$2" $MAC_LAUNCH "$1" \
        > "$WORK/cap.raw" 2> "$WORK/cap.err" )
    _rc=$?
    mac_kill_ours "$WORK/launch"
    if [ $_rc -eq 124 ]; then
        die "LaunchAPPL $1 timed out after $2s (emulator killed): $(head -5 "$WORK/cap.err")"
    fi
    [ $_rc -eq 0 ] || die "LaunchAPPL $1 failed ($_rc): $(head -5 "$WORK/cap.err")"
    capture_split "$WORK/cap.raw"
}

MAC_EXIT1=
MAC_EXIT2=

# run_mac_pair BIN1 BIN2 SECS (2026-09-06 appletalk spec 8.2, Task 11):
# TWO Mini vMac boots at once -- BIN1 on macplus/ and, 5 s later, BIN2 on
# macplus2/. Each boot gets its OWN cwd under $WORK, because LaunchAPPL
# makes its temp dir -- and the copy of the emulator it actually runs -- in
# cwd; that cwd string is also the only safe kill key (mac_kill_ours).
#
# Both boots run under the same SECS deadline, so the second can outlive
# the first by at most the 5 s stagger. Either one failing (a timeout, or
# LaunchAPPL itself erroring) sweeps up BOTH cwds and dies.
#
# The captures land in $WORK/cap{1,2}.raw and are split by capture_split
# into $WORK/cap1.{out,log} / $WORK/cap2.{out,log} with MAC_EXIT1 /
# MAC_EXIT2 -- capture_split itself writes the un-numbered cap.* names,
# so each split is renamed before the next one overwrites it.
run_mac_pair() {
    mac_launch macplus;  _lA=$MAC_LAUNCH
    mac_launch macplus2; _lB=$MAC_LAUNCH
    mkdir -p "$WORK/launchA" "$WORK/launchB"
    # shellcheck disable=SC2086
    ( cd "$WORK/launchA" && "$TOOLS/timeout" "$3" $_lA "$1" \
        > "$WORK/cap1.raw" 2> "$WORK/cap1.err" ) &
    _pidA=$!
    # The stagger is what makes the pair a server/client pair: BIN1 is
    # listening (or at least booting) before BIN2 starts looking for it.
    sleep 5
    # shellcheck disable=SC2086
    ( cd "$WORK/launchB" && "$TOOLS/timeout" "$3" $_lB "$2" \
        > "$WORK/cap2.raw" 2> "$WORK/cap2.err" ) &
    _pidB=$!
    wait "$_pidA"; _rcA=$?
    wait "$_pidB"; _rcB=$?
    mac_kill_ours "$WORK/launchA"
    mac_kill_ours "$WORK/launchB"
    if [ $_rcA -ne 0 ] || [ $_rcB -ne 0 ]; then
        # The guest's own partial stdout (cap*.raw) is the only evidence
        # of how far a timed-out boot actually got -- LaunchAPPL's stderr
        # says nothing about it.
        die "LaunchAPPL pair failed (rc $_rcA/$_rcB, 124 = timed out after $3s):
  $1: $(head -5 "$WORK/cap1.err")
  $1 capture tail: $(tail -5 "$WORK/cap1.raw" | tr '\n' '|')
  $2: $(head -5 "$WORK/cap2.err")
  $2 capture tail: $(tail -5 "$WORK/cap2.raw" | tr '\n' '|')"
    fi
    capture_split "$WORK/cap1.raw"
    MAC_EXIT1=$MAC_EXIT
    mv "$WORK/cap.out" "$WORK/cap1.out"
    mv "$WORK/cap.log" "$WORK/cap1.log"
    capture_split "$WORK/cap2.raw"
    MAC_EXIT2=$MAC_EXIT
    mv "$WORK/cap.out" "$WORK/cap2.out"
    mv "$WORK/cap.log" "$WORK/cap2.log"
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
    ( cd "$BR/emitcwd" && "$CLARUSC" build68k --rtdir "$RTDIR" -o "$1" \
        --events "../../$2" --testapi \
        --bake ../../testdata/mac-resident/resbake.bin $_args ) \
        > "$WORK/emit.log" 2>&1 \
        || die "clarusc build68k toolbox suite: $(tail -20 "$WORK/emit.log")"
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
