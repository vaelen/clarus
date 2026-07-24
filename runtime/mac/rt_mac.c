/* runtime/mac/rt_mac.c -- Toolbox-native implementation of the Clarus
   runtime ABI (internal/build/rt/rt.h). Handles + BlockMoveData + Str255;
   no malloc, no console library. RT_MAC_TEST redirects alert/log/quit/panic
   for the corpus harness (Task 10).

   String layout matches Str255 exactly: a strN value is
   {uint8_t len; uint8_t b[N];}. The byte-logic functions below are ports
   of internal/build/rt/rt.c with IDENTICAL observable semantics (same
   clamping, same lastError codes/messages, same panic messages) --
   memmove is replaced with BlockMoveData (same argument order as memmove:
   BlockMoveData(src, dst, count)); memcmp/strlen stay as they are pure
   comparisons/measurement, not copies.

   text/list/map/file are temporary stubs here (Tasks 9-10 replace them
   with Handle-backed implementations); every symbol in rt.h is defined. */
#include "rt.h"
#include <Dialogs.h>
#include <Files.h>
#include <Memory.h>
#include <Quickdraw.h>
#include <Fonts.h>
#include <Windows.h>
#include <Menus.h>
#include <TextEdit.h>
#include <string.h>

static int rt_mac_inited = 0;

static void rt_mac_toolbox_init(void)
{
    if (rt_mac_inited) return;
    InitGraf(&qd.thePort);
    InitFonts();
    InitWindows();
    InitMenus();
    TEInit();
    InitDialogs(NULL);
    InitCursor();
    rt_mac_inited = 1;
}

#ifndef RT_MAC_TEST
void rt_alert(const uint8_t *s)
{
    Str255 msg;
    rt_mac_toolbox_init();
    BlockMoveData(s + 1, msg + 1, s[0]);
    msg[0] = s[0];
    ParamText(msg, "\p", "\p", "\p");
    NoteAlert(128, NULL);
}

void rt_log(const uint8_t *s) { (void)s; } /* no stderr on System 6; 4b revisits */

void rt_quit(int32_t code) { (void)code; ExitToShell(); }

void rt_panic(const char *msg)
{
    Str255 p;
    int n = 0;
    const char *pre = "runtime error: ";
    rt_mac_toolbox_init();
    while (*pre && n < 255) p[++n] = *pre++;
    while (*msg && n < 255) p[++n] = *msg++;
    p[0] = n;
    ParamText(p, "\p", "\p", "\p");
    StopAlert(128, NULL);
    ExitToShell();
}
#endif

void rt_args_init(int argc, char **argv) { (void)argc; (void)argv; }

rt_list *rt_args_list(void)
{
    static rt_list *args = NULL;
    if (!args) args = rt_list_new(256);
    return args;
}

/* ==================== last-error state ==================== */

int32_t rt_lasterr_code = 0;
uint8_t rt_lasterr_msg[256] = {0};

void rt_set_lasterr(int32_t code, const char *msg)
{
    size_t n;
    n = strlen(msg);
    if (n > 255) n = 255;
    rt_lasterr_code = code;
    BlockMoveData(msg, rt_lasterr_msg + 1, (Size)n);
    rt_lasterr_msg[0] = (uint8_t)n;
}

/* ==================== strings ==================== */

void rt_str_store(uint8_t *dst, int dstcap, const uint8_t *src)
{
    uint8_t srclen;
    int n;
    srclen = src[0];
    n = srclen < dstcap ? srclen : dstcap;
    BlockMoveData(src + 1, dst + 1, (Size)n);
    dst[0] = (uint8_t)n;
    if (n < srclen) rt_set_lasterr(1, "string truncated");
}

/* out255 must not alias b (a-aliasing is safe); the printer always passes a fresh temp as out. */
void rt_str_concat(uint8_t *out255, const uint8_t *a, const uint8_t *b)
{
    int la, lb, total, n, fromA, fromB;
    la = a[0];
    lb = b[0];
    total = la + lb;
    /* ponytail decision (kept from host rt.c): the CONCAT result is itself
     * a str255 temp, so combining two strings past 255 bytes total IS a
     * clamped (truncating) store into that temp per Ch4 -- set lastError
     * same as any other truncating store. */
    n = total > 255 ? 255 : total;
    fromA = la < n ? la : n;
    fromB = n - fromA;
    BlockMoveData(a + 1, out255 + 1, (Size)fromA);
    BlockMoveData(b + 1, out255 + 1 + fromA, (Size)fromB);
    out255[0] = (uint8_t)n;
    if (n < total) rt_set_lasterr(1, "string truncated");
}

/* out255 must not alias b (a-aliasing is safe); the printer always passes a fresh temp as out. */
void rt_str_concat_char(uint8_t *out255, const uint8_t *a, uint8_t c)
{
    int la, total, n;
    la = a[0];
    total = la + 1;
    n = total > 255 ? 255 : total;
    BlockMoveData(a + 1, out255 + 1, (Size)(n < la ? n : la));
    if (n > la) out255[n] = c;
    out255[0] = (uint8_t)n;
    if (n < total) rt_set_lasterr(1, "string truncated");
}

/* out255 must not alias a; the printer always passes a fresh temp as out. */
void rt_str_prepend_char(uint8_t *out255, uint8_t c, const uint8_t *a)
{
    int la, total, n;
    la = a[0];
    total = la + 1;
    n = total > 255 ? 255 : total;
    out255[1] = c; /* n >= 1, so the char always fits */
    BlockMoveData(a + 1, out255 + 2, (Size)(n - 1));
    out255[0] = (uint8_t)n;
    if (n < total) rt_set_lasterr(1, "string truncated");
}

int rt_str_cmp(const uint8_t *a, const uint8_t *b)
{
    int la, lb, n, c;
    la = a[0];
    lb = b[0];
    n = la < lb ? la : lb;
    c = n > 0 ? memcmp(a + 1, b + 1, (size_t)n) : 0;
    if (c < 0) return -1;
    if (c > 0) return 1;
    if (la < lb) return -1;
    if (la > lb) return 1;
    return 0;
}

int rt_str_len(const uint8_t *s) { return s[0]; }

uint8_t rt_str_index(const uint8_t *s, int32_t i)
{
    if (i < 0 || i >= s[0]) rt_panic("string index out of range");
    return s[1 + i];
}

void rt_str_set_index(uint8_t *s, int32_t i, uint8_t c)
{
    if (i < 0 || i >= s[0]) rt_panic("string index out of range");
    s[1 + i] = c;
}

void rt_str_from_bytes(uint8_t *dst, int dstcap, const uint8_t *buf, int bufcap, int32_t count)
{
    int want, n;
    want = count < 0 ? 0 : (int)count;
    n = want;
    if (n > bufcap) n = bufcap;
    if (n > dstcap) n = dstcap;
    BlockMoveData(buf, dst + 1, (Size)n);
    dst[0] = (uint8_t)n;
    if (n < want) rt_set_lasterr(1, "string truncated");
}

int32_t rt_str_to_bytes(const uint8_t *src, uint8_t *buf, int bufcap)
{
    int srclen, n;
    srclen = src[0];
    n = srclen < bufcap ? srclen : bufcap;
    BlockMoveData(src + 1, buf, (Size)n);
    if (n < srclen) rt_set_lasterr(1, "string truncated");
    return n;
}

/* Strict bounds (Ch3): start<0, len<0, len>255, or start+len>srclen all
   panic "slice out of range" -- there is no clamping here, unlike the
   byte-copy family above. */
void rt_str_slice(uint8_t *out255, const uint8_t *src, int32_t start, int32_t len)
{
    int32_t srclen;
    srclen = src[0];
    if (len < 0 || len > 255) rt_panic("slice out of range");
    if (start < 0 || start > srclen - len) rt_panic("slice out of range");
    BlockMoveData(src + 1 + start, out255 + 1, (Size)len);
    out255[0] = (uint8_t)len;
}

int32_t rt_str_index_of_str(const uint8_t *s, const uint8_t *needle)
{
    int slen, nlen, i;
    slen = s[0];
    nlen = needle[0];
    if (nlen == 0) return 0; /* empty needle convention (Ch3) */
    if (nlen > slen) return -1;
    for (i = 0; i <= slen - nlen; i++) {
        if (memcmp(s + 1 + i, needle + 1, (size_t)nlen) == 0) return i;
    }
    return -1;
}

int32_t rt_str_index_of_char(const uint8_t *s, uint8_t c)
{
    int slen, i;
    slen = s[0];
    for (i = 0; i < slen; i++) {
        if (s[1 + i] == c) return i;
    }
    return -1;
}

/* ==================== fixed-point ==================== */

int32_t rt_fix_mul(int32_t a, int32_t b)
{
    int64_t p;
    p = (int64_t)a * (int64_t)b;
    return (int32_t)(p >> 16);
}

int32_t rt_fix_div(int32_t a, int32_t b)
{
    int64_t n;
    if (b == 0) rt_panic("division by zero");
    n = (int64_t)a * 65536; /* not <<16: left shift of negative is UB (C99 6.5.7p4) */
    return (int32_t)(n / b);
}

/* ==================== added by the C printer (Task 8) ==================== */

int32_t rt_arr_check(int32_t i, int32_t n)
{
    if (i < 0 || i >= n) rt_panic("array index out of range");
    return i;
}

int32_t rt_enum_from_int(const int32_t *vals, int n, int32_t v)
{
    int i;
    for (i = 0; i < n; i++) {
        if (vals[i] == v) return v;
    }
    rt_panic("no enum member with value");
    return v; /* unreached; rt_panic never returns, but silences -Wreturn-type-style analyzers */
}

/* ==================== text (stub -- Task 9) ==================== */

rt_text *rt_text_new(void) { rt_panic("not yet implemented on mac"); return 0; }
void rt_text_store(rt_text *t, const uint8_t *s) { rt_panic("not yet implemented on mac"); }
void rt_text_store_text(rt_text *t, const rt_text *src) { rt_panic("not yet implemented on mac"); }
void rt_text_concat(rt_text *t, const rt_text *a, const uint8_t *bstr, const rt_text *btext) { rt_panic("not yet implemented on mac"); }
void rt_text_concat_sl(rt_text *t, const uint8_t *sstr, const rt_text *btext) { rt_panic("not yet implemented on mac"); }
int  rt_text_cmp_str(const rt_text *t, const uint8_t *s) { rt_panic("not yet implemented on mac"); return 0; }
int32_t rt_text_len(const rt_text *t) { rt_panic("not yet implemented on mac"); return 0; }
uint8_t rt_text_index(const rt_text *t, int32_t i) { rt_panic("not yet implemented on mac"); return 0; }
void rt_text_set_index(rt_text *t, int32_t i, uint8_t c) { rt_panic("not yet implemented on mac"); }
void rt_text_from_bytes(rt_text *t, const uint8_t *buf, int bufcap, int32_t count) { rt_panic("not yet implemented on mac"); }
int32_t rt_text_to_bytes(const rt_text *t, uint8_t *buf, int bufcap) { rt_panic("not yet implemented on mac"); return 0; }
void rt_text_slice(uint8_t *out255, const rt_text *t, int32_t start, int32_t len) { rt_panic("not yet implemented on mac"); }
int32_t rt_text_index_of_str(const rt_text *t, const uint8_t *needle) { rt_panic("not yet implemented on mac"); return 0; }
int32_t rt_text_index_of_char(const rt_text *t, uint8_t c) { rt_panic("not yet implemented on mac"); return 0; }
void rt_text_append_str(rt_text *t, const uint8_t *s) { rt_panic("not yet implemented on mac"); }
void rt_text_append_char(rt_text *t, uint8_t c) { rt_panic("not yet implemented on mac"); }
void rt_text_append_text(rt_text *t, const rt_text *src) { rt_panic("not yet implemented on mac"); }
int rt_text_cmp(const rt_text *a, const rt_text *b) { rt_panic("not yet implemented on mac"); return 0; }

/* ==================== list (stub -- Task 9) ==================== */

rt_list *rt_list_new(int32_t elemsize) { rt_panic("not yet implemented on mac"); return 0; }
void rt_list_push(rt_list *l, const void *elem) { rt_panic("not yet implemented on mac"); }
void rt_list_pop(rt_list *l, void *out) { rt_panic("not yet implemented on mac"); }
void rt_list_shift(rt_list *l, void *out) { rt_panic("not yet implemented on mac"); }
void rt_list_unshift(rt_list *l, const void *elem) { rt_panic("not yet implemented on mac"); }
void rt_list_first(const rt_list *l, void *out) { rt_panic("not yet implemented on mac"); }
void rt_list_last(const rt_list *l, void *out) { rt_panic("not yet implemented on mac"); }
void rt_list_remove(rt_list *l, int32_t i) { rt_panic("not yet implemented on mac"); }
void *rt_list_at(rt_list *l, int32_t i) { rt_panic("not yet implemented on mac"); return 0; }
int32_t rt_list_count(const rt_list *l) { rt_panic("not yet implemented on mac"); return 0; }

/* ==================== map (stub -- Task 9) ==================== */

rt_map *rt_map_new(int32_t valsize) { rt_panic("not yet implemented on mac"); return 0; }
void rt_map_set(rt_map *m, const uint8_t *key, const void *val) { rt_panic("not yet implemented on mac"); }
void rt_map_get(rt_map *m, const uint8_t *key, void *out) { rt_panic("not yet implemented on mac"); }
int  rt_map_get_dv(rt_map *m, const uint8_t *key, void *out) { rt_panic("not yet implemented on mac"); return 0; }
int  rt_map_has(rt_map *m, const uint8_t *key) { rt_panic("not yet implemented on mac"); return 0; }
void rt_map_remove(rt_map *m, const uint8_t *key) { rt_panic("not yet implemented on mac"); }
int32_t rt_map_count(const rt_map *m) { rt_panic("not yet implemented on mac"); return 0; }
void rt_map_key_at(const rt_map *m, int32_t i, uint8_t *key255) { rt_panic("not yet implemented on mac"); }
void rt_map_val_at(const rt_map *m, int32_t i, void *out) { rt_panic("not yet implemented on mac"); }

/* ==================== files (stub -- Task 13) ==================== */

int rt_file_read_text(const uint8_t *path, rt_text *t) { rt_panic("not yet implemented on mac"); return 0; }
int rt_file_write_text(const uint8_t *path, const rt_text *t) { rt_panic("not yet implemented on mac"); return 0; }
void rt_file_name(uint8_t *dst255, const uint8_t *path) { rt_panic("not yet implemented on mac"); }
