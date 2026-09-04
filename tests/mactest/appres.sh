#!/bin/sh
# mactest/appres -- port of internal/mactest/appres_test.go's
# TestAppResNaming / TestAppResResources / TestAppResBundleBit. All three
# inspect different artifacts of the SAME build (naming, appres.r +
# CMakeLists.txt, the stamped .dsk), so one `scripts/build-mac.sh` run
# serves all three -- exactly what the Go file's appResOnce did. No
# emulator boot at all; the Retro68 toolchain is what it needs.
#
# The build deliberately omits a leading NAME arg (the first arg ends in
# .cla), exercising build-mac.sh's appinfo-driven naming path: appres.cla's
# `app AppResProbe` name sanitized to App-Res-Probe.
. "$(dirname "$0")/../lib.sh"
. "$(dirname "$0")/../lib_mac.sh"
require_env CLARUS_CPRINT_MAC_TESTS

"$ROOT/scripts/build-mac.sh" testdata/ui/appres.cla --test \
    > "$WORK/buildmac.log" 2>&1 \
    || die "build-mac.sh appres.cla --test failed: $(tail -10 "$WORK/buildmac.log")"
dir=$ROOT/build-mac/App-Res-Probe

# --- naming ------------------------------------------------------------
if [ -f "$dir/App-Res-Probe.bin" ]; then
    t_pass naming
else
    t_fail naming "expected sanitized-name binary $dir/App-Res-Probe.bin"
fi

# --- generated resources ----------------------------------------------
n=resources
if [ ! -f "$dir/appres.r" ]; then
    t_fail $n "appres.r missing"
elif [ ! -f "$dir/CMakeLists.txt" ]; then
    t_fail $n "CMakeLists.txt missing"
else
    bad=
    # One want-string per line; read with IFS= so leading/trailing spaces
    # and the embedded quotes survive verbatim.
    while IFS= read -r want; do
        grep -qF "$want" "$dir/appres.r" || bad="$bad [$want]"
    done <<'WANTS'
resource 'ALRT' (129
resource 'vers' (1
resource 'SIZE' (-1
isHighLevelEventAware
resource 'BNDL' (128
{ 'ICN#', { 0, 128, 1, 129 }, 'FREF', { 0, 128, 1, 129 } }
'PRBR'
resource 'ICN#' (128
resource 'ICON' (128
resource 'FREF' (129, purgeable) { 'TEXT', 1, "" };
resource 'ICN#' (129
resource 'ICON' (129
WANTS
    grep -qF 'CREATOR "PRBR"' "$dir/CMakeLists.txt" \
        || bad="$bad [CMakeLists.txt CREATOR \"PRBR\"]"
    if [ -n "$bad" ]; then t_fail $n "missing:$bad"; else t_pass $n; fi
fi

# --- bundle bit on the built .dsk -------------------------------------
n=bundlebit
libhfs=$ROOT/../Retro68-build/hfsutils/libhfs/libhfs.a
if [ ! -f "$libhfs" ]; then
    die "libhfs.a not found at $libhfs (need a built Retro68-build tree)"
fi
$CC -Wall -I "$ROOT/Retro68/hfsutils/libhfs" -o "$WORK/setbundle" \
    "$ROOT/scripts/setbundle.c" "$libhfs" > "$WORK/setbundle.log" 2>&1 \
    || die "cc scripts/setbundle.c: $(tail -10 "$WORK/setbundle.log")"

dsk=$dir/App-Res-Probe.dsk
if [ ! -f "$dsk" ]; then
    t_fail $n "expected .dsk $dsk"
else
    # Rez names the file inside the .dsk from the output stem.
    flags=$("$WORK/setbundle" -q "$dsk" App-Res-Probe 2> "$WORK/setbundle.err") \
        || die "setbundle -q: $(cat "$WORK/setbundle.err")"
    flags=$(printf '%s' "$flags" | tr -d ' \t\n')
    case $flags in
        ''|*[!0-9A-Fa-f]*) die "malformed fdflags output \"$flags\"" ;;
    esac
    bad=
    [ $(( 0x$flags & 0x2000 )) -ne 0 ] || bad="bundle bit (0x2000) not set"
    [ $(( 0x$flags & 0x0100 )) -eq 0 ] || bad="$bad; hasBeenInited bit (0x0100) still set"
    if [ -n "$bad" ]; then t_fail $n "fdflags $flags: $bad"; else t_pass $n; fi
fi

t_done
