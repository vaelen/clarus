#!/bin/sh
# Port of internal/hostrt/rtsmoke_test.go TestRuntimeSmokeTextSliceLenTooLong:
# the len>255 half of the strict-bounds check, which only bites text
# (unbounded, so start+len can stay within the source while len alone still
# exceeds what a str255 result can hold).
. "$(dirname "$0")/../lib.sh" || exit 2
cat > "$WORK/main.c" <<'EOF'
#include "rt.h"
int main(void) {
    rt_text *t = rt_text_new();
    for (int i = 0; i < 300; i++) rt_text_append_char(t, 'a');
    struct { uint8_t len; uint8_t b[255]; } out = {0};
    rt_text_slice((uint8_t*)&out, t, 0, 260); /* within t's length but len>255 */
    return 0;
}
EOF
exe=$WORK/smoke
$CC -std=c99 -Wall -Werror -I "$HOSTRT" "$WORK/main.c" "$HOSTRT/rt.c" -o "$exe" || die "compile"
"$exe" 2> "$WORK/err"; rc=$?
[ $rc -eq 3 ] || die "want exit 3, got $rc (stderr=$(cat "$WORK/err"))"
grep -q 'slice out of range' "$WORK/err" || die "stderr = $(cat "$WORK/err"), want it to mention slice out of range"
