#!/bin/sh
# compiler-cleanup: seenPaths is marked only after a SUCCESSFUL read. The
# observable: two includers naming the same missing path each get their own
# diagnostic (the second attempt is a real attempt, not a silent dedupe
# against a path that was never loaded). One compile cannot watch a file
# appear, so the negative half is what this pins.
. "$(dirname "$0")/../lib.sh" || exit 2

mkdir -p "$WORK/p"
cat > "$WORK/p/a.cla" <<'CLA'
include "lib/missing.cla"
CLA
cat > "$WORK/p/b.cla" <<'CLA'
include "lib/missing.cla"
CLA
cat > "$WORK/p/main.cla" <<'CLA'
include "a.cla"
include "b.cla"
on App.startCLI(args: list of string) {
    quit 0
}
CLA

"$CLARUSC" emit --rtdir "$ROOT/runtime/clarus/" -o "$WORK/out.c" "$WORK/p/main.cla" > "$WORK/out.txt" 2>&1
n=$(grep -c 'missing.cla' "$WORK/out.txt")
if [ "$n" -ge 2 ]; then
    t_pass include_retry_diags
else
    t_fail include_retry_diags "want >=2 diagnostics naming missing.cla, got $n: $(cat "$WORK/out.txt")"
fi
t_done
