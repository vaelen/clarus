#!/bin/sh
# Port of internal/hostrt/rtsmoke_test.go TestSliceOverflowPanics: the int32
# overflow in slice bounds checking -- start=INT32_MAX, len=5 would wrap
# start+len negative in the old code and bypass the check. The reordered
# check (start > srclen-len) avoids the addition entirely.
. "$(dirname "$0")/../lib.sh"
cat > "$WORK/main.c" <<'EOF'
#include "rt.h"
#include <stdint.h>
int main(void) {
    struct { uint8_t len; uint8_t b[255]; } s = {10, {'a','b','c','d','e','f','g','h','i','j'}};
    struct { uint8_t len; uint8_t b[255]; } out = {0};
    rt_str_slice((uint8_t*)&out, (uint8_t*)&s, INT32_MAX, 5);
    return 0;
}
EOF
exe=$WORK/smoke
$CC -std=c99 -Wall -Werror -I "$HOSTRT" "$WORK/main.c" "$HOSTRT/rt.c" -o "$exe" || die "compile"
"$exe" 2> "$WORK/err"; rc=$?
[ $rc -eq 3 ] || die "want exit 3, got $rc (stderr=$(cat "$WORK/err"))"
grep -q 'slice out of range' "$WORK/err" || die "stderr = $(cat "$WORK/err"), want it to mention slice out of range"
