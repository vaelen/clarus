#!/bin/bash
# build-clarusc-mac.sh [--events FILE] [--no-bake-ir]
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
# Environment overrides (tests/bake/clarusc_container.sh):
#   CLARUSC_BIN      the clarusc binary to use instead of the snapshot
#                    bootstrap (e.g. build-run/clarusc-current, when this
#                    tree's compiler has moved past the committed snapshot)
#   CLARUSC_MAC_OUT  output directory instead of build-68k/ClarusC (the
#                    CLIR library is written there too, as clarusc-mac.clir)
#
# --events FILE: a scripted-event source file, pass-through to
# `clarusc emit68k --events FILE` -- same purpose as build-68k.sh's own
# --events (deterministic UI driving, e.g. a boot-smoke test that just
# needs the app to open its window and quit, with no real input).
#
# CLIR bake (runtime-ir-bake Task 6, Mac integration): by DEFAULT, this
# script also runs `clarusc --bake-ir --lane 68k` to generate the 68k-lane
# runtime library, then embeds it via `emit68k --bake-ir FILE` -- the
# library as the application's DATA fork (SE wave 4 Task 7: read lazily
# with file.openRead, never loaded whole), its stamp sidecar as a CLFS
# resource -- so ClarusC.APPL consumes the baked runtime by default
# (clarusc/macgui.cla's gcResolveBakePath: library present + accepted ->
# bake path; absent or refused -> CLFS-source fallback, same as always).
# --no-bake-ir skips both steps,
# for building a from-source-only ClarusC.APPL (fallback-path testing, or
# isolating a bake-specific bug).
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
BAKE_IR=1
while [ $# -gt 0 ]; do
    case "$1" in
        --events) shift; EVENTS="$1" ;;
        --no-bake-ir) BAKE_IR=0 ;;
        *) echo "usage: build-clarusc-mac.sh [--events FILE] [--no-bake-ir]" >&2; exit 2 ;;
    esac
    shift
done

# 1. bootstrap clarusc from the committed snapshot (cached on clarusc.c's
#    mtime, same recipe as build-68k.sh/clarus-run.sh's own step 1).
mkdir -p build-run
if [ -n "${CLARUSC_BIN:-}" ]; then
    CLARUSC="$CLARUSC_BIN"
else
    CLARUSC="$ROOT/build-run/clarusc"
    if [ ! -x "$CLARUSC" ] || [ clarusc/clarusc.c -nt "$CLARUSC" ]; then
        cc -O1 -Iruntime/host -o "$CLARUSC" clarusc/clarusc.c runtime/host/rt.c
    fi
fi
OUT="${CLARUSC_MAC_OUT:-build-68k/ClarusC}"
mkdir -p "$OUT"

# 2. one --bake flag per runtime/clarus + toolbox source file.
BAKES=""
for f in runtime/clarus/*.cla toolbox/*.cla; do BAKES="$BAKES --bake $f"; done

EVENTS_ARG=""
if [ -n "$EVENTS" ]; then
    # --events implies --capture inside clarusc; spelled out so the
    # capture-mode build (the `out` test protocol) is visible here. A plain
    # build is production: ClarusC.APPL writes no `out` file.
    EVENTS_ARG="--events $EVENTS --capture"
fi

# 2b. by default, generate the 68k-lane CLIR runtime bake with the SAME
#     $CLARUSC, then embed it (data fork + stamp resource,
#     cliResolveBakeIr/main.cla) via `--bake-ir` below. --bake-ir also
#     writes CLIR_PATH.stamp unconditionally (main.cla's bakeIrMode) --
#     no separate step needed here.
BAKE_IR_ARG=""
if [ "$BAKE_IR" = "1" ]; then
    CLIR_PATH="$OUT/clarusc-mac.clir"
    "$CLARUSC" --bake-ir --lane 68k --rtdir runtime/clarus/ -o "$CLIR_PATH"
    BAKE_IR_ARG="--bake-ir $CLIR_PATH"
fi

# 3. emit. --partition 50331648 (48MB): the plan's own section 7 estimate for
#    this app's compile working set was 14-22MB, plus headroom. Originally
#    landed at a 4MB compromise (Task 10) because the then-current
#    snow/Clarus.snoww workspace booted with pmmu_enabled=false (no
#    32-bit addressing), capping Process-Manager-allocatable RAM at
#    ~6.8MB regardless of the 128MB physical ram_size, confirmed by a
#    REAL Finder alert requesting 64MB ("There is not enough memory to
#    open ClarusC (65,536K needed, 6,968K available)"). As of 2026-08-09
#    the Snow acceptance machine runs a 32-bit-clean ROM
#    (snow/rominator.rom) with 32-bit addressing enabled (Largest Unused
#    Block 129,868K verified), removing that ceiling -- raised to 48MB,
#    comfortably covering the estimate with the 127MB now actually
#    available. See clarusc/cg68k.cla's cgSizePartitionBytes doc comment
#    for the same note. NOTE (Linux emulator port, 2026-09-27): the Snow
#    System 7 machine (snow/system7.snoww) is again a 32-bit-clean
#    rominator Mac IIcx with 128MB, which this partition fits; the System 6
#    machine is a 4MB SE, which it does not -- but there the app runs as
#    the startup program and gets all of memory, which ClarusC fits since
#    SE wave 5, so the compiling tests/mactest/snow/ ClarusC scripts
#    default to the SE (snow_clarusc_system).
# --testapi (trace-noise phase, clir-load-perf): macgui.cla itself never
# calls a UiTest* verb, so this is a no-op on the emitted binary (proven
# byte-identical against a no-flag build of unmodified macgui.cla) --
# it's here solely so macgui.cla can NAME one runtime/clarus symbol
# directly (whole-program-visibility early splice, main.cla's own doc
# comment): rtUiTraceSuppressed (runtime/clarus/uiscript.cla), which
# feProgressTick brackets around its own spinner repaint so it doesn't
# flood the captured trace. Without --testapi, ordinary programs cannot
# name ANY runtime/clarus symbol at all (see this repo's CLAUDE.md).
"$CLARUSC" emit68k --testapi --rtdir runtime/clarus/ -o "$OUT/ClarusC.bin" \
    $BAKES $EVENTS_ARG $BAKE_IR_ARG --partition 50331648 clarusc/macgui.cla
echo "built: $OUT/ClarusC.bin"
