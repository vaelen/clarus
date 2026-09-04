#!/bin/sh
# Port of internal/bake/bakeidentity_test.go's
# TestRtbakeTestapiNonUiNegative (fix round 3, CRITICAL 1): a NON-UI
# --testapi program naming UiTestVerb must error identically under
# --rtbake and from-source. From-source only ever splices the early
# runtime (uitest.cla included) for a UI program (driveEarlySplice's own
# isUiProgram gate), so a non-UI --testapi program naming UiTestVerb is
# `undefined` there regardless of testapi; the bake path's own testapi
# branch used to install checker visibility unconditionally on `testapi`
# alone (driveIsUiProgram now gates it identically on both paths).
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"

BAKE=$WORK/rt68k.clir
bake_ir 68k "$BAKE"

FIXTURE=$WORK/nonui.cla
cat > "$FIXTURE" <<'CLA'
func main() {
    UiTestVerb("click Foo")
}
CLA

if "$CLARUSC" emit68k --testapi -o "$WORK/src.bin" "$FIXTURE" > "$WORK/src.log" 2>&1; then
    t_fail src_exit "from-source --testapi (non-UI) naming UiTestVerb: expected failure, got success: $(head -3 "$WORK/src.log" | tr '\n' ' ')"
else
    t_pass src_exit
fi

if "$CLARUSC" emit68k --rtbake "$BAKE" --testapi -o "$WORK/bake.bin" "$FIXTURE" > "$WORK/bake.log" 2>&1; then
    t_fail bake_exit "--rtbake --testapi (non-UI) naming UiTestVerb: expected failure, got success: $(head -3 "$WORK/bake.log" | tr '\n' ' ')"
else
    t_pass bake_exit
fi

WANT='undefined: UiTestVerb'
if grep -q "$WANT" "$WORK/src.log"; then
    t_pass src_diagnostic
else
    t_fail src_diagnostic "from-source diagnostic missing \"$WANT\": $(head -5 "$WORK/src.log" | tr '\n' ' ')"
fi
if grep -q "$WANT" "$WORK/bake.log"; then
    t_pass bake_diagnostic
else
    t_fail bake_diagnostic "--rtbake diagnostic missing \"$WANT\": $(head -5 "$WORK/bake.log" | tr '\n' ' ')"
fi
t_done
