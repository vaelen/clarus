#!/bin/sh
# cg68k/return_str_intr -- compile-only proof that `return <string
# intrinsic>` builds on the native lane for the fill-in-place intrinsics
# that have no arm of their own in cgEmitReturnStr: ui_log_line,
# ui_get_field_text, ui_get_label_text, ui_get_title, map_get_dv,
# list_pop and list_first. Each used to abort the compile with
# "cgEmitReturnStr: intrinsic <nm> unsupported in return context"; they now
# fall through to the generic rtStrStore tail, whose cgExprAddr
# materializes them via cgEmitStoreStr. `return gl[0]` (already worked) and
# two `string(8)` returns (str_coerce unwrap + rtStrStore's clamp) ride
# along. The fixture lives here, not in testdata/cg68k/, so it gets no .s
# golden.
. "$(dirname "$0")/../lib.sh" || exit 2

run=$WORK/return_str_intr
mkdir -p "$run" || die "mkdir $run"
cat >"$run/r.cla" <<'EOF' || die "write fixture"
app Demo { name: "Demo" }
var gm: map of string
var gl: list of string
window Main {
    title: "Main"
    size: 300, 200
    logpanel Log { }
    field F { }
    label L { text: "x" }
}
func fLog(w: Main): string { return w.Log.line(0) }
func fField(w: Main): string { return w.F.text }
func fLabel(w: Main): string { return w.L.text }
func fTitle(w: Main): string { return w.title }
func fMapDv(): string { return gm.get("x", "") }
func fPop(): string { return gl.pop() }
func fFirst(): string { return gl.first() }
func fIndex(): string { return gl[0] }
func fCapped(w: Main): string(8) { return w.F.text }
func fCappedPop(): string(8) { return gl.pop() }
extend Main {
    on opened {
        var s: string
        gm["x"] = "y"
        gl.add("a")
        gl.add("b")
        s = fLog(window) + fField(window) + fLabel(window) + fTitle(window)
        s = s + fMapDv() + fFirst() + fIndex() + fPop() + fCapped(window) + fCappedPop()
        L.text = s
    }
}
EOF

if out=$("$CLARUSC" emit68k -o "$run/out.bin" --rtdir "$RTDIR" "$run/r.cla" 2>&1); then
    t_pass emit68k
else
    t_fail emit68k "clarusc emit68k failed: $(printf '%s\n' "$out" | grep -v '^\[' | head -3)"
fi

t_done
