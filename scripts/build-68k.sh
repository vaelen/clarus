#!/bin/bash
# build-68k.sh NAME file.cla...
# Emits a native 68k .bin directly via `clarusc emit68k` -- no C, no cmake,
# no Retro68. Bootstraps clarusc from the committed snapshot exactly like
# build-mac.sh's own step 1 (cached on clarusc.c's mtime). Output:
# build-68k/NAME/NAME.bin
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
NAME="$1"
shift
FILES=("$@")

mkdir -p "$ROOT/build-68k"
# 1. bootstrap clarusc from the committed snapshot (cached)
CLARUSC="$ROOT/build-68k/clarusc"
if [ ! -x "$CLARUSC" ] || [ "$ROOT/clarusc/clarusc.c" -nt "$CLARUSC" ]; then
    cc -O1 -I"$ROOT/internal/build/rt" -o "$CLARUSC" \
        "$ROOT/clarusc/clarusc.c" "$ROOT/internal/build/rt/rt.c"
fi

# 2. emit directly to a native .bin
OUT="$ROOT/build-68k/$NAME"
mkdir -p "$OUT"
"$CLARUSC" emit68k --rtdir "$ROOT/runtime/clarus/" -o "$OUT/$NAME.bin" "${FILES[@]}"
echo "built: $OUT/$NAME.bin"
