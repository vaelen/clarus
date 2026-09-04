#!/bin/sh
# Port of internal/hostrt/rtsmoke_test.go TestRuntimeSmokeSliceOutOfRange:
# the strict-bounds panic for a string slice whose start+len exceeds the
# source length (Ch3: "slice out of range"). Its C main stays inline here,
# as it is in the Go test -- only the five OK-printing mains were extracted
# to runtime/host/rt_smoke*_test.c.
. "$(dirname "$0")/../lib.sh"
cat > "$WORK/main.c" <<'EOF'
#include "rt.h"
int main(void) {
    struct { uint8_t len; uint8_t b[255]; } hello = {5, {'h','e','l','l','o'}};
    struct { uint8_t len; uint8_t b[255]; } out = {0};
    rt_str_slice((uint8_t*)&out, (uint8_t*)&hello, 3, 5); /* start+len=8 > length 5 */
    return 0;
}
EOF
exe=$WORK/smoke
$CC -std=c99 -Wall -Werror -I "$HOSTRT" "$WORK/main.c" "$HOSTRT/rt.c" -o "$exe" || die "compile"
"$exe" 2> "$WORK/err"; rc=$?
[ $rc -eq 3 ] || die "want exit 3, got $rc (stderr=$(cat "$WORK/err"))"
grep -q 'slice out of range' "$WORK/err" || die "stderr = $(cat "$WORK/err"), want it to mention slice out of range"
