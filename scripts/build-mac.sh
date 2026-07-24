#!/bin/bash
# build-mac.sh NAME file.cla... [--test] [--events FILE]
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
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
NAME="$1"; shift
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
# 3. Retro68 build
cat > "$OUT/CMakeLists.txt" <<EOF
cmake_minimum_required(VERSION 3.9)
project($NAME C)
add_definitions(-I$ROOT/internal/build/rt $TESTDEF)
add_application($NAME $NAME.c $ROOT/runtime/mac/rt_mac.c $ROOT/runtime/mac/alert.r $EXTRA_SRC)
EOF
cmake -S "$OUT" -B "$OUT/build" \
    -DCMAKE_TOOLCHAIN_FILE="$ROOT/toolchain/m68k-apple-macos/cmake/retro68.toolchain.cmake" \
    > /dev/null
make -C "$OUT/build" > /dev/null
for ext in bin APPL dsk; do cp -R "$OUT/build/$NAME.$ext" "$OUT/" 2>/dev/null || true; done
echo "built: $OUT/$NAME.bin"
