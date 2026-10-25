#!/bin/sh
# tests/emitui/uiblob.sh -- port of internal/emitui's TestUiBlobGolden.
# Pins uiblob.cla's uibBuild() byte output for testdata/emitui/
# uiblob_probe.cla against uiblob_probe.blob.golden (the plan's normative
# UI descriptor blob format), then STRUCTURALLY decodes the committed
# golden with build-run/tools/uiblob and pins that dump against
# uiblob_probe.dump.golden -- so a future change that reorders fields but
# happens to preserve the total byte count doesn't slip through
# undetected. (The dump golden replaces the Go decoder's per-field
# assertions one-for-one; see the go-retirement Task 5 report's
# cross-check table.)
#
# Only the blob's byte identity is normative (uiblob.cla's own doc
# comment); the surrounding C array-literal spelling is cprint.cla's
# business and is pinned separately, by emitui/goldens.sh's own
# uiblob_probe.c.golden.
#
# Both goldens are FROZEN: they compare with a plain `cmp` and have no
# bless path at all, not even an unset variable name someone could export
# (same rule as tests/mactest/resparity.sh). To regenerate after an
# intentional uiblob.cla format change: rerun this script's emit +
# extraction by hand, write the bytes to uiblob_probe.blob.golden,
# regenerate the dump with build-run/tools/uiblob, and re-verify the dump
# against the format spec BY HAND.
. "$(dirname "$0")/../lib.sh" || exit 2

fixture=testdata/emitui/uiblob_probe.cla
"$CLARUSC" emit -o "$WORK/probe.c" "$fixture" || die "clarusc emit $fixture"

# Extract clar_ui_blob[]'s byte VALUES from the emitted C -- same intent as
# the Go test's uiBlobArrayRe/uiBlobIntRe: take everything between the
# array's `= {` and its closing `};`, and read every decimal integer in it
# (cprint.cla emits plain unsigned decimal, one 0-255 byte per element).
awk '/clar_ui_blob\[\] *= *\{/{f=1;next} f&&/\};/{exit} f' "$WORK/probe.c" \
  | tr -d ' \n' | tr ',' '\n' | grep -v '^$' \
  | awk '{printf "%02x", $1+0}' | xxd -r -p > "$WORK/probe.blob" \
  || die "extract clar_ui_blob[] from $WORK/probe.c"
[ -s "$WORK/probe.blob" ] || die "clar_ui_blob[] array literal not found in $WORK/probe.c"

if cmp -s "$WORK/probe.blob" testdata/emitui/uiblob_probe.blob.golden; then
    t_pass blob_bytes
else
    t_fail blob_bytes "clar_ui_blob bytes differ from testdata/emitui/uiblob_probe.blob.golden ($(wc -c < "$WORK/probe.blob" | tr -d ' ') vs $(wc -c < testdata/emitui/uiblob_probe.blob.golden | tr -d ' ') bytes): $(cmp "$WORK/probe.blob" testdata/emitui/uiblob_probe.blob.golden 2>&1 | head -1)"
fi

# Structural decode of the COMMITTED golden (what the Go decoder walked).
if "$TOOLS/uiblob" testdata/emitui/uiblob_probe.blob.golden > "$WORK/probe.dump" 2> "$WORK/probe.err"; then
    if cmp -s "$WORK/probe.dump" testdata/emitui/uiblob_probe.dump.golden; then
        t_pass blob_structure
    else
        t_fail blob_structure "decoded structure differs from testdata/emitui/uiblob_probe.dump.golden: $(cmp "$WORK/probe.dump" testdata/emitui/uiblob_probe.dump.golden 2>&1 | head -1)"
    fi
else
    t_fail blob_structure "uiblob decode failed: $(tr '\n' ' ' < "$WORK/probe.err")"
fi

# Blob v2 (ui-widgets Task 1): decode testdata/emitui/ui_batch_decl.cla's
# FRESHLY EMITTED blob and assert every new field reached it -- a widget's
# height/font/fontSize/face/align/maxLines/divStyle, a column's align (and
# a formatted column's fieldIndex -1 / fmtId 0 + its Layout), and a menu item's
# itemFlags/submenuIdx. Field-by-field greps rather than a frozen dump, so
# the emitui/goldens.sh .c.golden stays this fixture's one byte pin.
batch=testdata/emitui/ui_batch_decl.cla
if "$CLARUSC" emit -o "$WORK/batch.c" "$batch" > "$WORK/batch.err" 2>&1; then
    awk '/clar_ui_blob\[\] *= *\{/{f=1;next} f&&/\};/{exit} f' "$WORK/batch.c" \
      | tr -d ' \n' | tr ',' '\n' | grep -v '^$' \
      | awk '{printf "%02x", $1+0}' | xxd -r -p > "$WORK/batch.blob"
    if "$TOOLS/uiblob" "$WORK/batch.blob" > "$WORK/batch.dump" 2> "$WORK/batch.derr"; then
        for want in \
            'header magic=0x434C5549 version=2 ' \
            'widget 0 0 kind=3 name="Status" .* flags=32 .* height=20 font="Monaco" fontSize=9 face=5 align=2 maxLines=0 divStyle=0$' \
            'widget 0 1 kind=4 name="Who" .* height=30 font="Geneva" fontSize=12 face=2 ' \
            'widget 0 2 kind=5 name="Notes" .* width=200 .* height=60 font="Monaco" fontSize=9 face=0 ' \
            'widget 0 3 kind=2 name="Meter" .* width=120 .* height=40 font="Chicago" ' \
            'widget 0 4 kind=7 name="Callers" .* widthIsFill=0 width=300 .* height=120 font="Geneva" fontSize=9 ' \
            'col 0 4 0 header="Name" widthPx=120 widthFill=0 fieldIndex=0 align=0 fmtId=-1 fmtLayoutOff=0$' \
            'col 0 4 1 header="Time" widthPx=0 widthFill=1 fieldIndex=-1 align=2 fmtId=0 fmtLayoutOff=[1-9][0-9]*$' \
            'widget 0 5 kind=9 name="TopRule" .* widthIsFill=1 .* flags=0 .* height=3 font=- fontSize=0 face=0 align=0 maxLines=0 divStyle=1$' \
            'widget 0 6 kind=9 name="SideRule" .* height=0 font=- .* divStyle=0$' \
            'widget 0 7 kind=8 name="Log" .* fillBoth=1 flags=56 .* font="Monaco" fontSize=9 face=1 align=0 maxLines=100 divStyle=0$' \
            'item 0 1 name="S9600" .* itemFlags=1 submenuIdx=-1$' \
            'item 1 0 name="Init" .* key=73 .* itemFlags=1 submenuIdx=-1$' \
            'item 1 1 name="Port" .* itemFlags=0 submenuIdx=0$'
        do
            if grep -q -- "$want" "$WORK/batch.dump"; then
                t_pass "batch_v2: $want"
            else
                t_fail batch_v2 "no dump line matches '$want' in $WORK/batch.dump"
            fi
        done
    else
        t_fail batch_v2 "uiblob decode failed: $(tr '\n' ' ' < "$WORK/batch.derr")"
    fi
else
    t_fail batch_v2 "clarusc emit $batch failed: $(head -3 "$WORK/batch.err" | tr '\n' ' ')"
fi

# The Go test also m68k compile-checks the FRESHLY EMITTED C (not the
# golden -- that half is emitui/goldens.sh's job). Compile only, no link.
GCC=$ROOT/toolchain/bin/m68k-apple-macos-gcc
if [ -x "$GCC" ]; then
    if ! "$GCC" -x c -c -I "$HOSTRT" -I "$ROOT/runtime/mac" \
            "$WORK/probe.c" -o "$WORK/probe.o" > "$WORK/cc.log" 2>&1; then
        t_fail m68k_compile "m68k-apple-macos-gcc -c $fixture emit failed: $(head -5 "$WORK/cc.log" | tr '\n' ' ')"
    elif [ ! -s "$WORK/probe.o" ]; then
        t_fail m68k_compile "m68k-apple-macos-gcc -c: no object file produced"
    else
        t_pass m68k_compile
    fi
else
    # The Go test skipped WHOLESALE here, losing the blob assertions above;
    # this lane keeps them and only drops the compile step.
    echo "note: $GCC not found, m68k_compile not run"
fi
t_done
