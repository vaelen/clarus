#!/bin/bash
# build-clarusc-mac.sh [--events FILE]
#
# Builds ClarusC.APPL, the Mac-resident compiler's GUI front end (Task 10,
# mac-resident-clarusc phase): clarusc/macgui.cla, self-baked with the
# whole runtime/clarus + toolbox source catalog so it can resolve every
# runtime-module include when it compiles OTHER .cla programs on the Mac
# (feHasKey/feReadSource, macgui.cla's own front-end seam), no host
# filesystem involved. Bootstraps clarusc from the committed snapshot
# exactly like build-68k.sh's own step 1 (cached on clarusc.c's mtime).
# Output: build-68k/ClarusC/ClarusC.bin
#
# --events FILE: a scripted-event source file, pass-through to
# `clarusc emit68k --events FILE` -- same purpose as build-68k.sh's own
# --events (deterministic UI driving, e.g. a boot-smoke test that just
# needs the app to open its window and quit, with no real input).
#
# Always runs from the repo root (cd below): every --bake NAME is used
# VERBATIM as the baked resource's own name (cliResolveBake, main.cla),
# and that name is also the KEY drive.cla's driveKeyResolve computes for
# a runtime-module include -- an absolute or cwd-relative spelling here
# would silently break every baked-resource lookup this app depends on.
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

EVENTS=""
while [ $# -gt 0 ]; do
    case "$1" in
        --events) shift; EVENTS="$1" ;;
        *) echo "usage: build-clarusc-mac.sh [--events FILE]" >&2; exit 2 ;;
    esac
    shift
done

# 1. bootstrap clarusc from the committed snapshot (cached on clarusc.c's
#    mtime, same recipe as build-68k.sh/clarus-run.sh's own step 1).
mkdir -p build-run
CLARUSC="$ROOT/build-run/clarusc"
if [ ! -x "$CLARUSC" ] || [ clarusc/clarusc.c -nt "$CLARUSC" ]; then
    cc -O1 -Iruntime/host -o "$CLARUSC" clarusc/clarusc.c runtime/host/rt.c
fi

# 2. one --bake flag per runtime/clarus + toolbox source file.
BAKES=""
for f in runtime/clarus/*.cla toolbox/*.cla; do BAKES="$BAKES --bake $f"; done

EVENTS_ARG=""
if [ -n "$EVENTS" ]; then
    EVENTS_ARG="--events $EVENTS"
fi

# 3. emit. --partition 4194304 (4MB): the plan's own budget for this
#    app's SIZE(-1) partition was "comfortably above" the ~48-64MB
#    high-water estimate for the compile working set (cg68k.cla's own
#    cgBigTmpSlots doc comment cites the same range) on the "128MB Snow
#    acceptance machine" -- but the checked-in snow/Clarus.snoww workspace
#    boots with pmmu_enabled=false (no 32-bit addressing), which caps
#    Process-Manager-allocatable RAM at ~6.8MB regardless of the 128MB
#    physical ram_size (empirically found booting a 64MB request:
#    "There is not enough memory to open ClarusC (65,536K needed, 6,968K
#    available)"). 4MB is double the ordinary 2MB default -- genuinely
#    more headroom for a compile -- while staying safely inside that
#    ~6.8MB ceiling. Revisit once the acceptance image gets a 32-bit-
#    addressing enabler (out of scope here); see clarusc/cg68k.cla's
#    cgSizePartitionBytes doc comment for the same note.
mkdir -p build-68k/ClarusC
"$CLARUSC" emit68k --rtdir runtime/clarus/ -o build-68k/ClarusC/ClarusC.bin \
    $BAKES $EVENTS_ARG --partition 4194304 clarusc/macgui.cla
echo "built: build-68k/ClarusC/ClarusC.bin"
