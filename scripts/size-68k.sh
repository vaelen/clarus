#!/bin/sh
# size-68k.sh -- emitted-native-size meter (peephole68k phase, Task 1).
# Builds the CURRENT compiler (two-stage from the committed snapshot),
# emit68k's three representative programs with --listing, and reports
# total CODE bytes + segment count per target:
#   SIZE <name> bytes=<sum of .segN.dat> segments=<N> bin=<bin size>
# Deterministic and host-only; used to record before/after numbers for
# every peephole pattern.
#
# The suite compositions below mirror tests/mactest/coregui_files.txt and
# tests/mactest/toolbox_files.txt exactly (those two lists, plus
# tests/testsuite/core_cli.sh's own core-CLI composition, are the
# authoritative lists -- not this script's earlier draft). Notably:
# toolbox_files.txt is NOT just "kit.cla + runner.cla + cases_*.cla +
# gui.cla" -- it also threads in five toolbox/*.cla catalog files and
# testsuite/toolbox/harness.cla (harness.cla doesn't match the cases_*.cla
# glob), and the toolbox GUI build needs --testapi (tests/mactest/
# toolbox_68k.sh prepends it) while the core GUI build does not
# (tests/mactest/coresuite_68k.sh passes no such flag, and no core/*.cla
# file references UiTest*).
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
    testsuite/core/cases_sortedmap.cla testsuite/core/cases_intmap.cla \
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

# clarusc measured last: mac-resident-clarusc Task 3 closed every codegen
# gap self-hosting clarusc/main.cla through emit68k used to hit (the old
# "too many str/rec temps"/"unaddressable KStr/KRec argument" errors this
# comment used to describe are gone -- cgBigTmpSlots/cgTmpSlots bumped to
# clarusc's own observed need, three real backend gaps fixed: discarded
# str/rec-returning call statements, `return <- nested call` for string
# returns, and depth-2 call-result materialization). Task 13 then closed
# the pool-duplication blocker Task 3 found next (cgPackProgram used to
# charge every segment the FULL constant pool -- clarusc's own pool alone
# was ~32.8KB, bigger than the entire 32KB segment budget -- see Task 3's
# own report); each segment now carries only the pool entries its own
# packed functions actually reference (cgPackProgram/cg68Measure,
# clarusc/cg68k.cla). That left a THIRD, unrelated structural limit: a
# single function, fpIntrCall (cprint.cla's ~1258-line C-target
# intrinsic-call dispatcher), compiled alone to ~105KB of native 68k
# code -- more than 3x the whole 32KB segment budget, so no packing
# strategy (pool-related or not) could ever fit it in one segment. Task
# 14 closed this too: pure source-level code motion split fpIntrCall's
# dispatch into fpIntrCall1..7 (a thin fpIntrCall dispatcher chaining
# through them via a fpIntrMatched fallthrough flag, same output bytes,
# same order -- see that task's own report for the differential-guard
# evidence and the near-limit function-size audit). clarusc now emits
# itself cleanly at the default segment limit; this SIZE line prints for
# real. Still ordered last so the other two targets' SIZE lines print
# first regardless (set -e).
measure clarusc clarusc/main.cla
