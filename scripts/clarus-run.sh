#!/bin/bash
# clarus-run.sh FILE.cla [-- args...]
#
# The day-to-day `clarus run` replacement, Go-free (test-suite-review Task
# 6): snapshot-bootstrapped clarusc (built from the committed
# clarusc/clarusc.c with `cc` alone, cached under build-run/, same recipe
# as internal/selfhost/behavior_test.go's bootstrapSnapshotClarusc and
# build-68k.sh's own step 1) emits C for FILE.cla, `cc` compiles that
# against the on-disk host runtime (internal/build/rt), and the resulting
# binary runs with any args passed after `--`. No Go compiler anywhere in
# this path -- the Go compiler is deleted; clarusc is the only compiler.
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if [ -z "$1" ]; then
    echo "usage: clarus-run.sh FILE.cla [-- args...]" >&2
    exit 2
fi
FILE="$1"
shift
ARGS=()
if [ "$1" = "--" ]; then
    shift
    ARGS=("$@")
fi

# 1. bootstrap clarusc from the committed snapshot (cached on clarusc.c's
#    mtime, same caching convention as build-68k.sh/build-mac.sh).
mkdir -p "$ROOT/build-run"
CLARUSC="$ROOT/build-run/clarusc"
if [ ! -x "$CLARUSC" ] || [ "$ROOT/clarusc/clarusc.c" -nt "$CLARUSC" ]; then
    cc -O1 -I"$ROOT/internal/build/rt" -o "$CLARUSC" \
        "$ROOT/clarusc/clarusc.c" "$ROOT/internal/build/rt/rt.c"
fi

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

# 2. emit C for FILE.cla.
"$CLARUSC" emit --rtdir "$ROOT/runtime/clarus/" -o "$WORK/main.c" "$FILE"

# 3. compile against the host runtime.
cc -O1 -I"$ROOT/internal/build/rt" -o "$WORK/prog" "$WORK/main.c" "$ROOT/internal/build/rt/rt.c"

# 4. run.
exec "$WORK/prog" "${ARGS[@]}"
