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
"$CLARUSC" emit -o "$OUT/$NAME.c" "${FILES[@]}"
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
resource 'BNDL' (128, purgeable) {
    '$APPID', 0,
    { 'ICN#', { 0, 128 }, 'FREF', { 0, 128 } }
};
EOF
        # pbm2icn: bitmap -> Rez 'ICN#' text (cached, like the clarusc bootstrap)
        PBM2ICN="$ROOT/build-mac/pbm2icn"
        if [ ! -x "$PBM2ICN" ] || [ "$ROOT/scripts/pbm2icn.c" -nt "$PBM2ICN" ]; then
            cc -O1 -o "$PBM2ICN" "$ROOT/scripts/pbm2icn.c"
        fi
        "$PBM2ICN" "$ICONPBM" >> "$APPRES"

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
cat > "$OUT/CMakeLists.txt" <<EOF
cmake_minimum_required(VERSION 3.9)
project($NAME C)
add_definitions(-I$ROOT/internal/build/rt -I$ROOT/runtime/mac $TESTDEF)
add_application($NAME $EXTRA_APP_ARGS $NAME.c $ROOT/runtime/mac/rt_mac.c $ROOT/runtime/mac/rt_ui.c $ROOT/runtime/mac/alert.r $APPRES $EXTRA_SRC)
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
