#!/bin/bash
# build-mac.sh NAME file.cla... [--test] [--events FILE]
# build-mac.sh file.cla... [--test] [--events FILE]   (NAME derived, Task 6)
# Emits C via the snapshot-built clarusc and builds a classic Mac APPL
# via Retro68. Output: build-mac/NAME/NAME.{bin,APPL,dsk}
#
# --events FILE (Task 3, mac-target-4b): generates <out>/events.c, a
# strong `const char rt_ui_test_script[] = ...;` definition of the
# scripted-event-script grammar (docs/superpowers/plans/
# 2026-07-24-mac-target-4b.md), C-escaped from FILE's bytes with newlines
# preserved as literal '\n' escapes (the runtime's script reader consumes
# them as line separators), and adds it to the generated CMakeLists' app
# sources so it overrides rt_ui.c's weak empty default at link time.
#
# NAME is optional (Task 6, app-section plan): if the first arg ends in
# .cla, NAME is derived from `clarusc appinfo`'s name= line (or, absent an
# app section, its filename fallback), sanitized to [A-Za-z0-9_-]. Whether
# or not NAME was given explicitly, `clarusc appinfo` always runs: if the
# program has an app section (app=1), an appres.r is generated (About
# ALRT/DITL 129, vers, and -- when an icon is declared -- ICN#/BNDL/FREF/
# signature) and passed to add_application along with TYPE/CREATOR, and the
# built .dsk's bundle bit is stamped via setbundle.
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
NAME=""
case "$1" in
*.cla) ;; # leave NAME empty, derived below; $1 stays in the arg stream
*) NAME="$1"; shift ;;
esac
TESTDEF=""
EVENTS=""
FILES=()
while [ $# -gt 0 ]; do
    case "$1" in
    --test) TESTDEF="-DRT_MAC_TEST=1" ;;
    --events) shift; EVENTS="$1" ;;
    *) FILES+=("$1") ;;
    esac
    shift
done

mkdir -p "$ROOT/build-mac"
# 1. bootstrap clarusc from the committed snapshot (cached)
CLARUSC="$ROOT/build-mac/clarusc"
if [ ! -x "$CLARUSC" ] || [ "$ROOT/clarusc/clarusc.c" -nt "$CLARUSC" ]; then
    cc -O1 -I"$ROOT/internal/build/rt" -o "$CLARUSC" \
        "$ROOT/clarusc/clarusc.c" "$ROOT/internal/build/rt/rt.c"
fi

# 1b. app info (always runs; drives naming, About resources, CREATOR)
APPINFO="$("$CLARUSC" appinfo "${FILES[@]}")"
RAWNAME=$(printf '%s\n' "$APPINFO" | sed -n 's/^name=//p')
HASAPP=$(printf '%s\n' "$APPINFO" | sed -n 's/^app=//p')
VERSION=$(printf '%s\n' "$APPINFO" | sed -n 's/^version=//p')
APPID=$(printf '%s\n' "$APPINFO" | sed -n 's/^id=//p')
ICONPBM=$(printf '%s\n' "$APPINFO" | sed -n 's/^icon=//p')
if [ -z "$NAME" ]; then
    NAME=$(printf '%s' "$RAWNAME" | sed 's/[^A-Za-z0-9_-]/-/g')
fi

# 2. emit
OUT="$ROOT/build-mac/$NAME"
mkdir -p "$OUT"
# CLARUS_UIPORT=1 (native-5e Task 7): emit against the PORTED UI runtime
# (runtime/clarus/ui*.cla, spliced into the program by clarusc's own
# --uiport flag) instead of the frozen runtime/mac/rt_ui.c -- see step 3
# below, where rt_ui.c is dropped from the CMake source list to match.
UIPORT_FLAG=""
if [ "$CLARUS_UIPORT" = "1" ]; then
    UIPORT_FLAG="--uiport"
fi
"$CLARUSC" emit $UIPORT_FLAG -o "$OUT/$NAME.c" "${FILES[@]}"
# 2b. optional compiled-in event script
EXTRA_SRC=""
if [ -n "$EVENTS" ]; then
    {
        echo 'const char rt_ui_test_script[] ='
        echo '""' # seed so an empty FILE still yields valid C (`= ;` is a syntax error)
        while IFS= read -r line || [ -n "$line" ]; do
            esc="${line//\\/\\\\}"
            esc="${esc//\"/\\\"}"
            printf '"%s\\n"\n' "$esc"
        done < "$EVENTS"
        echo ';'
    } > "$OUT/events.c"
    EXTRA_SRC="$OUT/events.c"
fi

# 2c. app resources (About ALRT/DITL, vers, and -- with an icon -- ICN#/
# BNDL/FREF/signature); setbundle stamping happens after the dsk is built.
APPRES=""
SETBUNDLE=""
if [ "$HASAPP" = "1" ]; then
    APPRES="$OUT/appres.r"
    ICONITEM=""
    if [ -n "$ICONPBM" ]; then
        ICONITEM=$',\n            {13, 20, 45, 52},   Icon { disabled, 128 }'
    fi
    cat > "$APPRES" <<EOF
#include "MacTypes.r"
#include "Dialogs.r"
#include "Processes.r"
resource 'ALRT' (129, purgeable) {
    {40, 40, 220, 460}, 129,
    { OK, visible, silent, OK, visible, silent,
      OK, visible, silent, OK, visible, silent },
    alertPositionMainScreen
};
resource 'DITL' (129, purgeable) {
    {
        {150, 350, 170, 410}, Button { enabled, "OK" },
        {13, 70, 29, 410},   StaticText { disabled, "^0  ^1" },
        {33, 70, 49, 410},   StaticText { disabled, "^2" },
        {60, 20, 140, 410},  StaticText { disabled, "^3" }$ICONITEM
    }
};
// SIZE(-1) (mac-target-4c Task 5, Ch7 Mac note): identical to Retro68's own
// default (toolchain/m68k-apple-macos/RIncludes/Retro68APPL.r) EXCEPT
// notHighLevelEventAware -> isHighLevelEventAware -- an app section (the
// only case this whole appres.r exists at all) is what makes a Clarus
// build AppleEvent-aware, per rt_ui_launch's own Gestalt+SIZE(-1) check
// (runtime/mac/rt_ui.c). Emitted for EVERY app-section program, icon or
// not: App.openDocument's AppleEvents dispatch mode doesn't depend on
// having a custom icon. add_application's rsrc_files ordering
// (Retro68/cmake/add_application.cmake:66-72) makes this OVERRIDE
// retrocrt's own default SIZE(-1) at link time -- appres.r is always
// listed after the app's other sources, and the later one wins.
resource 'SIZE' (-1) {
	reserved,
	ignoreSuspendResumeEvents,
	reserved,
	cannotBackground,
	needsActivateOnFGSwitch,
	backgroundAndForeground,
	dontGetFrontClicks,
	ignoreChildDiedEvents,
	is32BitCompatible,
	isHighLevelEventAware,
	onlyLocalHLEvents,
	notStationeryAware,
	dontUseTextEditServices,
	reserved,
	reserved,
	reserved,
	1024 * 1024,
	1024 * 1024
};
EOF
    if [ -n "$VERSION" ]; then
        cat >> "$APPRES" <<EOF
resource 'vers' (1, purgeable) {
    0x1, 0x0, release, 0x0, verUS,
    "$VERSION",
    "$RAWNAME $VERSION"
};
EOF
    fi
    if [ -n "$ICONPBM" ]; then
        cat >> "$APPRES" <<EOF
#include "Finder.r"
#include "Icons.r"
type '$APPID' as 'STR ';
resource '$APPID' (0, purgeable) { "$RAWNAME $VERSION" };
resource 'FREF' (128, purgeable) { 'APPL', 0, "" };
// FREF 129 (mac-target-4c Task 5): the app's own document icon (local ID
// 1, below) -- 'TEXT' is the only document type Clarus's file builtins
// read/write (Ch12), so every icon-bearing program gets exactly one
// document FREF, not one per declared window document type.
resource 'FREF' (129, purgeable) { 'TEXT', 1, "" };
resource 'BNDL' (128, purgeable) {
    '$APPID', 0,
    { 'ICN#', { 0, 128, 1, 129 }, 'FREF', { 0, 128, 1, 129 } }
};
EOF
        # pbm2icn: bitmap -> Rez 'ICN#' text (cached, like the clarusc bootstrap)
        PBM2ICN="$ROOT/build-mac/pbm2icn"
        if [ ! -x "$PBM2ICN" ] || [ "$ROOT/scripts/pbm2icn.c" -nt "$PBM2ICN" ]; then
            cc -O1 -o "$PBM2ICN" "$ROOT/scripts/pbm2icn.c"
        fi
        "$PBM2ICN" "$ICONPBM" >> "$APPRES"

        # Static generic document icon (ICN#/ICON 129, mac-target-4c Task 5):
        # a hand-drawn 32x32 dog-eared-page glyph (rectangle outline + folded
        # top-right corner + two short "text lines"), unlike the app icon
        # above (128, derived per-program from the declared `icon:` PBM via
        # pbm2icn) -- every icon-bearing Clarus program gets the SAME
        # document icon; there is no per-document-type icon declaration to
        # derive one from.
        cat >> "$APPRES" <<'EOF'
resource 'ICN#' (129, purgeable) {
	{
		$"0000 0000 0000 0000 0000 0000 03FF F000"
		$"0200 1800 0200 1400 0200 1200 0200 1100"
		$"0200 1080 0200 1040 0200 0040 0200 0040"
		$"0200 0040 0200 0040 027F FE40 0200 0040"
		$"0200 0040 0200 0040 027F F040 0200 0040"
		$"0200 0040 0200 0040 0200 0040 0200 0040"
		$"0200 0040 0200 0040 0200 0040 0200 0040"
		$"03FF FFC0 0000 0000 0000 0000 0000 0000",
		$"0000 0000 0000 0000 0000 0000 03FF F000"
		$"03FF F800 03FF FC00 03FF FE00 03FF FF00"
		$"03FF FF80 03FF FFC0 03FF FFC0 03FF FFC0"
		$"03FF FFC0 03FF FFC0 03FF FFC0 03FF FFC0"
		$"03FF FFC0 03FF FFC0 03FF FFC0 03FF FFC0"
		$"03FF FFC0 03FF FFC0 03FF FFC0 03FF FFC0"
		$"03FF FFC0 03FF FFC0 03FF FFC0 03FF FFC0"
		$"03FF FFC0 0000 0000 0000 0000 0000 0000"
	}
};

resource 'ICON' (129, purgeable) {
		$"0000 0000 0000 0000 0000 0000 03FF F000"
		$"0200 1800 0200 1400 0200 1200 0200 1100"
		$"0200 1080 0200 1040 0200 0040 0200 0040"
		$"0200 0040 0200 0040 027F FE40 0200 0040"
		$"0200 0040 0200 0040 027F F040 0200 0040"
		$"0200 0040 0200 0040 0200 0040 0200 0040"
		$"0200 0040 0200 0040 0200 0040 0200 0040"
		$"03FF FFC0 0000 0000 0000 0000 0000 0000"
};
EOF

        # setbundle: stamps the Finder bundle bit on the built .dsk (cached)
        SETBUNDLE="$ROOT/build-mac/setbundle"
        if [ ! -x "$SETBUNDLE" ] || [ "$ROOT/scripts/setbundle.c" -nt "$SETBUNDLE" ]; then
            LIBHFS="$(find "$ROOT/../Retro68-build" -name 'libhfs.a' 2>/dev/null | head -1)"
            if [ -n "$LIBHFS" ]; then
                cc -O1 -I"$ROOT/Retro68/hfsutils/libhfs" -o "$SETBUNDLE" \
                    "$ROOT/scripts/setbundle.c" "$LIBHFS"
            else
                cc -O1 -I"$ROOT/Retro68/hfsutils/libhfs" -o "$SETBUNDLE" \
                    "$ROOT/scripts/setbundle.c" "$ROOT"/Retro68/hfsutils/libhfs/*.c
            fi
        fi
    fi
fi

# 3. Retro68 build
#
# rt_ui.c is always added to the sources (Task 5, mac-target-4b), even for a
# UI-free program: the simplest correct approach over conditionally
# detecting UI declarations in the generated C, at the cost of a UI-free
# .bin linking a few dead rt_ui_* functions it never calls -- acceptable per
# the plan's own note. -I.../runtime/mac is needed unconditionally too, both
# for rt_ui.c's own #include "rt_ui.h" and for a UI program's generated
# $NAME.c, which includes the same header when it declares any window/menu.
EXTRA_APP_ARGS=""
if [ "$HASAPP" = "1" ]; then
    EXTRA_APP_ARGS="TYPE \"APPL\" CREATOR \"${APPID:-????}\""
fi
# CLARUS_UIPORT=1 (native-5e Task 7): rt_ui.c is dropped from the CMake
# source list entirely -- the emitted $NAME.c above already carries the
# ported UI runtime's own C output (from runtime/clarus/ui*.cla), so
# linking rt_ui.c too would duplicate every rt_ui_* symbol. rt_mac.c
# (which #includes runtime/mac/rt_ext_mac.inc -- the ported runtime's own
# C-side glue, e.g. UiLaunchReal/UiTestEmit/UiStrAddr)/alert.r/events.c
# stay unconditionally -- only rt_ui.c itself is the frozen C UI runtime
# this whole task replaces.
RT_UI_C="$ROOT/runtime/mac/rt_ui.c"
UIPORTDEF=""
if [ "$CLARUS_UIPORT" = "1" ]; then
    RT_UI_C=""
    # Task 7 Step 7 review fix: rt_ext_mac.inc's rt_ext_UiLaunchReal (+ its
    # AE handlers) calls clar_fn_clar_ui_fire_launchdoc/_startempty, symbols
    # that exist ONLY in a --uiport build's generated C -- rt_ext_mac.inc
    # itself is #included unconditionally by rt_mac.c on BOTH lanes, so
    # without this define the default (non-ported) lane linked those
    # undefined references every time. See that file's own matching
    # #ifdef CLARUS_UIPORT comment.
    UIPORTDEF="-DCLARUS_UIPORT=1"
fi
cat > "$OUT/CMakeLists.txt" <<EOF
cmake_minimum_required(VERSION 3.9)
project($NAME C)
add_definitions(-I$ROOT/internal/build/rt -I$ROOT/runtime/mac $TESTDEF $UIPORTDEF)
add_application($NAME $EXTRA_APP_ARGS $NAME.c $ROOT/runtime/mac/rt_mac.c $RT_UI_C $ROOT/runtime/mac/alert.r $APPRES $EXTRA_SRC)
EOF
cmake -S "$OUT" -B "$OUT/build" \
    -DCMAKE_TOOLCHAIN_FILE="$ROOT/toolchain/m68k-apple-macos/cmake/retro68.toolchain.cmake" \
    > /dev/null
make -C "$OUT/build" > /dev/null
for ext in bin APPL dsk; do cp -R "$OUT/build/$NAME.$ext" "$OUT/" 2>/dev/null || true; done

# 4. stamp the Finder bundle bit (Rez names the file inside the .dsk from
# the output stem, i.e. $NAME)
if [ -n "$SETBUNDLE" ]; then
    "$SETBUNDLE" "$OUT/$NAME.dsk" "$NAME"
fi
echo "built: $OUT/$NAME.bin"
