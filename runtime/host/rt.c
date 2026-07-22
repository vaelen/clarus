/* runtime/host/rt.c — host implementation of the Clarus runtime layer.
 * Host stand-in for the future Mac Toolbox runtime; free to use libc.
 *
 * String layout: a strN value is {uint8_t len; uint8_t b[N];}. Every
 * function here takes the raw pointer to the len byte, with the buffer's
 * declared capacity N passed alongside as a separate int (the len byte
 * itself is not part of that capacity count).
 */
#include "rt.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int32_t rt_lasterr_code = 0;
uint8_t rt_lasterr_msg[256] = {0};

void rt_set_lasterr(int32_t code, const char *msg) {
    size_t n = strlen(msg);
    if (n > 255) n = 255;
    rt_lasterr_code = code;
    memmove(rt_lasterr_msg + 1, msg, n);
    rt_lasterr_msg[0] = (uint8_t)n;
}

void rt_panic(const char *msg) {
    fprintf(stderr, "runtime error: %s\n", msg);
    exit(3);
}

void rt_alert(const uint8_t *s) {
    uint8_t len = s[0];
    for (uint8_t i = 0; i < len; i++) {
        uint8_t c = s[1 + i];
        putchar(c == '\r' ? '\n' : c); /* CR (Mac newline) renders as LF on the host */
    }
    putchar('\n');
}

void rt_str_store(uint8_t *dst, int dstcap, const uint8_t *src) {
    uint8_t srclen = src[0];
    int n = srclen < dstcap ? srclen : dstcap;
    memmove(dst + 1, src + 1, (size_t)n);
    dst[0] = (uint8_t)n;
    if (n < srclen) rt_set_lasterr(1, "string truncated");
}

void rt_str_concat(uint8_t *out255, const uint8_t *a, const uint8_t *b) {
    int la = a[0], lb = b[0];
    int total = la + lb;
    /* ponytail decision: the CONCAT result is itself a str255 temp, so
     * combining two strings past 255 bytes total IS a clamped (truncating)
     * store into that temp per Ch4 — set lastError same as any other
     * truncating store, not just when the caller later stores it further. */
    int n = total > 255 ? 255 : total;
    int fromA = la < n ? la : n;
    int fromB = n - fromA;
    memmove(out255 + 1, a + 1, (size_t)fromA);
    memmove(out255 + 1 + fromA, b + 1, (size_t)fromB);
    out255[0] = (uint8_t)n;
    if (n < total) rt_set_lasterr(1, "string truncated");
}

void rt_str_concat_char(uint8_t *out255, const uint8_t *a, uint8_t c) {
    int la = a[0];
    int total = la + 1;
    int n = total > 255 ? 255 : total;
    memmove(out255 + 1, a + 1, (size_t)(n < la ? n : la));
    if (n > la) out255[n] = c;
    out255[0] = (uint8_t)n;
    if (n < total) rt_set_lasterr(1, "string truncated");
}

int rt_str_cmp(const uint8_t *a, const uint8_t *b) {
    int la = a[0], lb = b[0];
    int n = la < lb ? la : lb;
    int c = n > 0 ? memcmp(a + 1, b + 1, (size_t)n) : 0;
    if (c < 0) return -1;
    if (c > 0) return 1;
    if (la < lb) return -1;
    if (la > lb) return 1;
    return 0;
}

int rt_str_len(const uint8_t *s) { return s[0]; }

uint8_t rt_str_index(const uint8_t *s, int32_t i) {
    if (i < 0 || i >= s[0]) rt_panic("string index out of range");
    return s[1 + i];
}

void rt_str_set_index(uint8_t *s, int32_t i, uint8_t c) {
    if (i < 0 || i >= s[0]) rt_panic("string index out of range");
    s[1 + i] = c;
}

void rt_str_from_bytes(uint8_t *dst, int dstcap, const uint8_t *buf, int bufcap, int32_t count) {
    int want = count < 0 ? 0 : (int)count;
    int n = want;
    if (n > bufcap) n = bufcap;
    if (n > dstcap) n = dstcap;
    memmove(dst + 1, buf, (size_t)n);
    dst[0] = (uint8_t)n;
    if (n < want) rt_set_lasterr(1, "string truncated");
}

int32_t rt_str_to_bytes(const uint8_t *src, uint8_t *buf, int bufcap) {
    int srclen = src[0];
    int n = srclen < bufcap ? srclen : bufcap;
    memmove(buf, src + 1, (size_t)n);
    if (n < srclen) rt_set_lasterr(1, "string truncated");
    return n;
}

int32_t rt_fix_mul(int32_t a, int32_t b) {
    int64_t p = (int64_t)a * (int64_t)b;
    return (int32_t)(p >> 16);
}

int32_t rt_fix_div(int32_t a, int32_t b) {
    if (b == 0) rt_panic("division by zero");
    int64_t n = (int64_t)a << 16;
    return (int32_t)(n / b);
}
