#!/bin/bash
# build-68k.sh NAME file.cla... [--events FILE]
# build-68k.sh file.cla... [--events FILE]   (NAME derived, Task 13 parity
#                                              with build-mac.sh's own Task 6)
# Emits a native 68k .bin directly via `clarusc emit68k` -- no C, no cmake,
# no Retro68. Bootstraps clarusc from the committed snapshot exactly like
# build-mac.sh's own step 1 (cached on clarusc.c's mtime). Output:
# build-68k/NAME/NAME.bin
#
# NAME is optional (Task 13, native-5e resource parity, mirroring
# build-mac.sh's own appinfo-driven naming): if the first arg ends in
# .cla, NAME is derived from `clarusc appinfo`'s name= line (or, absent an
# app section, its filename fallback), sanitized to [A-Za-z0-9_-]. Unlike
# build-mac.sh, no separate appinfo-driven About/icon/CREATOR resource
# generation step is needed here -- `clarusc emit68k` builds those
# resources itself now (clarusc/app68k.cla + res68k.cla), so appinfo is
# only consulted for the naming fallback.
#
# --events FILE (Task 12, native-5e): a scripted-event source file,
# pass-through to `clarusc emit68k --events FILE` (pours the raw file
# bytes into the native constant pool -- see cg68k.cla's cgEmitUiEventsPool
# doc comment) -- the native-boot counterpart to build-mac.sh's own
# --events (which round-trips the file through a generated C string
# literal for the cprint lane instead).
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
NAME=""
case "$1" in
*.cla) ;; # leave NAME empty, derived below; $1 stays in the arg stream
*) NAME="$1"; shift ;;
esac
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
    cc -O1 -I"$ROOT/runtime/host" -o "$CLARUSC" \
        "$ROOT/clarusc/clarusc.c" "$ROOT/runtime/host/rt.c"
fi

# 1b. derive NAME when omitted (appinfo's name= line, or its filename
# fallback), same resolution build-mac.sh's own step 1b uses.
if [ -z "$NAME" ]; then
    APPINFO="$("$CLARUSC" appinfo "${FILES[@]}")"
    RAWNAME=$(printf '%s\n' "$APPINFO" | sed -n 's/^name=//p')
    NAME=$(printf '%s' "$RAWNAME" | sed 's/[^A-Za-z0-9_-]/-/g')
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
