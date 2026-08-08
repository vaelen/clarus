#!/bin/sh
# size-68k.sh -- emitted-native-size meter (peephole68k phase, Task 1).
# Builds the CURRENT compiler (two-stage from the committed snapshot),
# emit68k's three representative programs with --listing, and reports
# total CODE bytes + segment count per target:
#   SIZE <name> bytes=<sum of .segN.dat> segments=<N> bin=<bin size>
# Deterministic and host-only; used to record before/after numbers for
# every peephole pattern.
#
# The suite compositions below mirror internal/mactest/coresuite_test.go's
# coreGUIFiles/toolboxFiles exactly (that file, plus suite_host_test.go's
# coreCLIFiles, is the authoritative list -- not this script's own
# earlier draft). Notably: toolboxFiles is NOT just
# "kit.cla + runner.cla + cases_*.cla + gui.cla" -- it also threads in
# five toolbox/*.cla catalog files and testsuite/toolbox/harness.cla
# (harness.cla doesn't match the cases_*.cla glob), and the toolbox GUI
# build needs --testapi (TestToolboxSuiteOn68k prepends it) while the
# core GUI build does not (TestCoreSuiteGUIOn68k passes no such flag,
# and no core/*.cla file references UiTest*).
set -e
cd "$(dirname "$0")/.."

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

cc -O1 -I runtime/host -o "$work/boot" clarusc/clarusc.c runtime/host/rt.c
"$work/boot" emit --rtdir runtime/clarus/ -o "$work/cur.c" clarusc/main.cla
cc -O1 -I runtime/host -o "$work/cur" "$work/cur.c" runtime/host/rt.c

measure() {
    name=$1; shift
    out="$work/$name"
    "$work/cur" emit68k --rtdir runtime/clarus/ --listing -o "$out.bin" "$@"
    bytes=0
    segs=0
    for d in "$out".seg*.dat; do
        [ -f "$d" ] || continue
        bytes=$((bytes + $(wc -c < "$d")))
        segs=$((segs + 1))
    done
    printf 'SIZE %s bytes=%d segments=%d bin=%d\n' \
        "$name" "$bytes" "$segs" "$(wc -c < "$out.bin")"
}

measure coregui testsuite/kit.cla testsuite/core/runner.cla \
    testsuite/core/cases_arr.cla testsuite/core/cases_enumfix.cla \
    testsuite/core/cases_list.cla testsuite/core/cases_map.cla \
    testsuite/core/cases_misc.cla testsuite/core/cases_rec.cla \
    testsuite/core/cases_ser.cla testsuite/core/cases_str.cla \
    testsuite/core/cases_text.cla testsuite/core/cases_xrec.cla \
    testsuite/core/gui.cla

measure toolboxgui --testapi testsuite/kit.cla \
    toolbox/memory.cla toolbox/events.cla toolbox/osutils.cla \
    toolbox/scrap.cla toolbox/files.cla \
    testsuite/toolbox/runner.cla \
    testsuite/toolbox/cases_events.cla testsuite/toolbox/cases_draw.cla \
    testsuite/toolbox/cases_a5.cla testsuite/toolbox/cases_gestalt.cla \
    testsuite/toolbox/cases_event.cla testsuite/toolbox/harness.cla \
    testsuite/toolbox/cases_uitest.cla testsuite/toolbox/cases_pattern.cla \
    testsuite/toolbox/cases_buttons.cla testsuite/toolbox/cases_winvar.cla \
    testsuite/toolbox/cases_textwidgets.cla testsuite/toolbox/cases_menus.cla \
    testsuite/toolbox/cases_editmenu.cla testsuite/toolbox/cases_canvas.cla \
    testsuite/toolbox/cases_zoomwin.cla testsuite/toolbox/cases_hscroll.cla \
    testsuite/toolbox/cases_popuptable.cla testsuite/toolbox/cases_dialogs.cla \
    testsuite/toolbox/cases_hdim.cla testsuite/toolbox/cases_formedit.cla \
    testsuite/toolbox/cases_bigtext.cla testsuite/toolbox/cases_catalog.cla \
    testsuite/toolbox/cases_finfo.cla testsuite/toolbox/gui.cla

# clarusc measured last: as of this writing, self-hosting clarusc/main.cla
# through emit68k hits a pre-existing native-backend gap (cg68k.cla,
# "too many str/rec temps needed in one statement -- bump cgBigTmpSlots";
# bumping that constant just uncovers a second, deeper gap --
# "cgPushArgs: unaddressable, unmaterializable KStr/KRec argument"),
# unrelated to peephole68k. Ordered last so the other two targets' SIZE
# lines still print before this one aborts the script (set -e).
measure clarusc clarusc/main.cla
