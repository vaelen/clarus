#!/bin/sh
# build-mac.sh NAME file.cla... [--test]
# Emits C via the snapshot-built clarusc and builds a classic Mac APPL
# via Retro68. Output: build-mac/NAME/NAME.{bin,APPL,dsk}
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
NAME="$1"; shift
TESTDEF=""
FILES=""
for a in "$@"; do
    if [ "$a" = "--test" ]; then TESTDEF="-DRT_MAC_TEST=1"; else FILES="$FILES $a"; fi
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
"$CLARUSC" emit -o "$OUT/$NAME.c" $FILES
# 3. Retro68 build
cat > "$OUT/CMakeLists.txt" <<EOF
cmake_minimum_required(VERSION 3.9)
project($NAME C)
add_definitions(-I$ROOT/internal/build/rt $TESTDEF)
add_application($NAME $NAME.c $ROOT/runtime/mac/rt_mac.c $ROOT/runtime/mac/alert.r)
EOF
cmake -S "$OUT" -B "$OUT/build" \
    -DCMAKE_TOOLCHAIN_FILE="$ROOT/toolchain/m68k-apple-macos/cmake/retro68.toolchain.cmake" \
    > /dev/null
make -C "$OUT/build" > /dev/null
for ext in bin APPL dsk; do cp -R "$OUT/build/$NAME.$ext" "$OUT/" 2>/dev/null || true; done
echo "built: $OUT/$NAME.bin"
