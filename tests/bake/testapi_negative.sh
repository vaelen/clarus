#!/bin/sh
# Port of internal/bake/bakeidentity_test.go's TestRtbakeTestapiNegative:
# the other half of deliverable (a) -- a NON-testapi compile naming a
# UiTest* runtime symbol must error EXACTLY like a from-source non-testapi
# compile does (undefined name, check#1), because no runtime symbol is ever
# visible without --testapi on EITHER path.
. "$(dirname "$0")/../lib.sh"
. "$(dirname "$0")/../lib_bake.sh"

BAKE=$WORK/rt68k.clir
bake_ir 68k "$BAKE"

FIXTURE=$WORK/neg.cla
cat > "$FIXTURE" <<'CLA'
func main() {
    UiTestVerb("click Foo")
}
CLA

if "$CLARUSC" emit68k -o "$WORK/src.bin" "$FIXTURE" > "$WORK/src.log" 2>&1; then
    t_fail src_exit "from-source non-testapi naming UiTestVerb: expected failure, got success: $(head -3 "$WORK/src.log" | tr '\n' ' ')"
else
    t_pass src_exit
fi

if "$CLARUSC" emit68k --rtbake "$BAKE" -o "$WORK/bake.bin" "$FIXTURE" > "$WORK/bake.log" 2>&1; then
    t_fail bake_exit "--rtbake non-testapi naming UiTestVerb: expected failure, got success: $(head -3 "$WORK/bake.log" | tr '\n' ' ')"
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
