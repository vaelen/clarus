#!/bin/sh
# timeout: 20m
# mactest/smoke_bounce -- port of internal/mactest/native_test.go's
# TestSmokeBounceOn68k: the smallest native UI boot (testdata/valid/
# bounce.cla + testdata/ui/smoke_bounce.events, built by `clarusc emit68k
# --events`, no Retro68/cmake/C), compared byte-exact against the frozen
# trace + PBM snap goldens. CLARUS_MAC_BLESS=1 rewrites them.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_mac.sh" || die "helper lib failed to load"
require_env CLARUS_MAC_TESTS

emit68k -o "$WORK/smoke_bounce.bin" \
    --events testdata/ui/smoke_bounce.events \
    testdata/valid/bounce.cla > "$WORK/emit.log" 2>&1 \
    || die "clarusc emit68k smoke_bounce: $(tail -10 "$WORK/emit.log")"

run_mac "$WORK/smoke_bounce.bin" 180
ui_split "$WORK/cap.out"
ui_goldens smoke_bounce 0
[ $STATUS -eq 0 ] && t_pass smoke_bounce
t_done
