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
