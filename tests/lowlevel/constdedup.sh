#!/bin/sh
# lowlevel/constdedup.sh -- port of internal/lowlevel/incdedup_test.go
# TestConstDedupAcrossIncludePaths: a TOP-LEVEL `const` reached via two
# DIFFERENT include routes in one compile (constdedup.cla's own explicit
# `include "../../toolbox/files.cla"` plus the runtime's independent
# uidialogs.cla -> toolbox/files.cla include) must not redeclaration-error.
. "$(dirname "$0")/../lib.sh"

n=ConstDedupAcrossIncludePaths
if "$CLARUSC" emit -o "$WORK/constdedup.c" "$ROOT/testdata/incdedup/constdedup.cla" \
        > "$WORK/constdedup.log" 2>&1; then
    t_pass "$n"
else
    t_fail "$n" "emit failed: $(head -3 "$WORK/constdedup.log" | tr '\n' ' ')"
fi
t_done
