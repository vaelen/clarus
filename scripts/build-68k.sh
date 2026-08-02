#!/bin/bash
# build-68k.sh NAME file.cla... [--events FILE]
# Emits a native 68k .bin directly via `clarusc emit68k` -- no C, no cmake,
# no Retro68. Bootstraps clarusc from the committed snapshot exactly like
# build-mac.sh's own step 1 (cached on clarusc.c's mtime). Output:
# build-68k/NAME/NAME.bin
#
# --events FILE (Task 12, native-5e): a scripted-event source file,
# pass-through to `clarusc emit68k --events FILE` (pours the raw file
# bytes into the native constant pool -- see cg68k.cla's cgEmitUiEventsPool
# doc comment) -- the native-boot counterpart to build-mac.sh's own
# --events (which round-trips the file through a generated C string
# literal for the cprint lane instead).
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
NAME="$1"
shift
FILES=()
EVENTS=""
while [ $# -gt 0 ]; do
    case "$1" in
        --events) shift; EVENTS="$1" ;;
        *) FILES+=("$1") ;;
    esac
    shift
done

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
EVENTS_ARGS=()
if [ -n "$EVENTS" ]; then
    EVENTS_ARGS=(--events "$EVENTS")
fi
"$CLARUSC" emit68k --rtdir "$ROOT/runtime/clarus/" -o "$OUT/$NAME.bin" "${EVENTS_ARGS[@]}" "${FILES[@]}"
echo "built: $OUT/$NAME.bin"
