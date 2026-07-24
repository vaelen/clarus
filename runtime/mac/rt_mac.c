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

/* ==================== Handle-backed collections (Task 9) ====================
 *
 * Ports of internal/build/rt/rt.c's text/list/map with IDENTICAL observable
 * semantics (same amortized growth, panic messages, sorted-key map
 * insertion + snapshot iteration, self-append doubling). Storage differs:
 * host uses malloc/realloc on a flat pointer; here every growable buffer is
 * a relocatable Handle, resized with SetHandleSize, and dereferenced fresh
 * (*h) after any call that can move memory (NewHandle/SetHandleSize/NewPtr).
 * A dereferenced pointer is never cached across such a call.
 *
 * The rt_text/rt_list/rt_map structs themselves live in locked, never-
 * unlocked master-pointer Handles (rt_mac_new_struct) so that rt_text,
 * rt_list, rt_map pointer values -- ordinary C pointers to the caller --
 * stay stable for the program's lifetime, matching the host's plain-pointer
 * ABI. None of these are ever freed, same as the host (rt.h has no dispose
 * calls).
 */

static void rt_mac_oom(void) { rt_panic("out of memory"); }

/* Allocates a small block that never moves: NewHandle + HLock, held locked
   forever. Used only for the rt_text/rt_list/rt_map struct itself (never
   for their growable data), so this is one tiny locked block per
   collection, not per element -- fine for System 6's heap. */
static void *rt_mac_new_struct(Size sz)
{
    Handle box;
    box = NewHandle(sz);
    if (!box) rt_mac_oom();
    HLock(box);
    return *box;
}

/* Shared amortized-doubling grower for text/list/map data Handles: doubles
   *cap (starting from 4 if currently empty) until it covers `need`, then
   SetHandleSize once. Mirrors host rt.c's grow() exactly, just against a
   Handle instead of a realloc'd pointer. */
static void rt_mac_grow(Handle h, int32_t *cap, int32_t need, int32_t elemsize)
{
    int32_t newcap;
    if (need <= *cap) return;
    newcap = *cap > 0 ? *cap : 4;
    while (newcap < need) newcap *= 2;
    SetHandleSize(h, (Size)newcap * (Size)elemsize);
    if (MemError() != noErr) rt_mac_oom();
    *cap = newcap;
}

/* ==================== text ==================== */

struct rt_text { Handle h; int32_t len; int32_t cap; };

static void rt_text_grow(rt_text *t, int32_t need)
{
    rt_mac_grow(t->h, &t->cap, need, 1);
}

rt_text *rt_text_new(void)
{
    rt_text *t;
    t = (rt_text *)rt_mac_new_struct(sizeof(rt_text));
    t->h = NewHandle(0);
    if (!t->h) rt_mac_oom();
    t->len = 0;
    t->cap = 0;
    return t;
}

void rt_text_store(rt_text *t, const uint8_t *s)
{
    int32_t n;
    n = s[0];
    rt_text_grow(t, n);
    BlockMoveData(s + 1, *t->h, (Size)n);
    t->len = n;
}

void rt_text_store_text(rt_text *t, const rt_text *src)
{
    int32_t n;
    n = src->len;
    rt_text_grow(t, n);
    BlockMoveData(*src->h, *t->h, (Size)n); /* no-op copy if t == src */
    t->len = n;
}

/* t may alias a (and, defensively, btext); build the result into scratch
 * (a non-relocatable NewPtr block) first, then copy into t -- sidesteps
 * every aliasing case without special-casing t == a, same approach as the
 * host's malloc scratch buffer. */
void rt_text_concat(rt_text *t, const rt_text *a, const uint8_t *bstr, const rt_text *btext)
{
    int32_t alen, blen, total;
    Ptr scratch;
    alen = a->len;
    blen = bstr ? bstr[0] : btext->len;
    total = alen + blen;
    scratch = NewPtr((Size)(total > 0 ? total : 1));
    if (!scratch) rt_mac_oom();
    BlockMoveData(*a->h, scratch, (Size)alen);
    if (bstr) {
        BlockMoveData(bstr + 1, scratch + alen, (Size)blen);
    } else {
        BlockMoveData(*btext->h, scratch + alen, (Size)blen);
    }
    rt_text_grow(t, total);
    BlockMoveData(scratch, *t->h, (Size)total);
    t->len = total;
    DisposePtr(scratch);
}

/* string on the left, text on the right; mirrors rt_text_concat's
 * scratch-then-copy approach (t may alias btext), no truncation -- text is
 * unbounded. */
void rt_text_concat_sl(rt_text *t, const uint8_t *sstr, const rt_text *btext)
{
    int slen;
    int32_t blen, total;
    Ptr scratch;
    slen = sstr[0];
    blen = btext->len;
    total = slen + blen;
    scratch = NewPtr((Size)(total > 0 ? total : 1));
    if (!scratch) rt_mac_oom();
    BlockMoveData(sstr + 1, scratch, (Size)slen);
    BlockMoveData(*btext->h, scratch + slen, (Size)blen);
    rt_text_grow(t, total);
    BlockMoveData(scratch, *t->h, (Size)total);
    t->len = total;
    DisposePtr(scratch);
}

int rt_text_cmp_str(const rt_text *t, const uint8_t *s)
{
    int32_t tlen, n;
    int slen, c;
    tlen = t->len;
    slen = s[0];
    n = tlen < slen ? tlen : slen;
    c = n > 0 ? memcmp(*t->h, s + 1, (size_t)n) : 0;
    if (c < 0) return -1;
    if (c > 0) return 1;
    if (tlen < slen) return -1;
    if (tlen > slen) return 1;
    return 0;
}

int32_t rt_text_len(const rt_text *t) { return t->len; }

uint8_t rt_text_index(const rt_text *t, int32_t i)
{
    if (i < 0 || i >= t->len) rt_panic("text index out of range");
    return ((uint8_t *)*t->h)[i];
}

void rt_text_set_index(rt_text *t, int32_t i, uint8_t c)
{
    uint8_t *p;
    if (i < 0 || i >= t->len) rt_panic("text index out of range");
    p = (uint8_t *)*t->h;
    p[i] = c;
}

/* Text is growable, so from_bytes never truncates on the destination side;
   it only clamps to bufcap (the source buffer's own size). */
void rt_text_from_bytes(rt_text *t, const uint8_t *buf, int bufcap, int32_t count)
{
    int32_t want, n;
    want = count < 0 ? 0 : count;
    n = want > bufcap ? bufcap : want;
    rt_text_grow(t, n);
    BlockMoveData(buf, *t->h, (Size)n);
    t->len = n;
}

int32_t rt_text_to_bytes(const rt_text *t, uint8_t *buf, int bufcap)
{
    int32_t n;
    n = t->len < bufcap ? t->len : bufcap;
    BlockMoveData(*t->h, buf, (Size)n);
    if (n < t->len) rt_set_lasterr(1, "string truncated");
    return n;
}

/* Same strict-bounds rule as rt_str_slice, but against t->len. */
void rt_text_slice(uint8_t *out255, const rt_text *t, int32_t start, int32_t len)
{
    int32_t tlen;
    tlen = t->len;
    if (len < 0 || len > 255) rt_panic("slice out of range");
    if (start < 0 || start > tlen - len) rt_panic("slice out of range");
    BlockMoveData(*t->h + start, out255 + 1, (Size)len);
    out255[0] = (uint8_t)len;
}

int32_t rt_text_index_of_str(const rt_text *t, const uint8_t *needle)
{
    int32_t tlen, i;
    int nlen;
    uint8_t *p;
    tlen = t->len;
    nlen = needle[0];
    if (nlen == 0) return 0; /* empty needle convention (Ch3) */
    if (nlen > tlen) return -1;
    p = (uint8_t *)*t->h;
    for (i = 0; i <= tlen - nlen; i++) {
        if (memcmp(p + i, needle + 1, (size_t)nlen) == 0) return i;
    }
    return -1;
}

int32_t rt_text_index_of_char(const rt_text *t, uint8_t c)
{
    int32_t i;
    uint8_t *p;
    p = (uint8_t *)*t->h;
    for (i = 0; i < t->len; i++) {
        if (p[i] == c) return i;
    }
    return -1;
}

/* Amortized growth: rt_mac_grow doubles capacity, so a loop of N appends
   costs O(N) total, not O(N^2). */
void rt_text_append_str(rt_text *t, const uint8_t *s)
{
    int32_t n;
    n = s[0];
    rt_text_grow(t, t->len + n);
    BlockMoveData(s + 1, *t->h + t->len, (Size)n);
    t->len += n;
}

void rt_text_append_char(rt_text *t, uint8_t c)
{
    uint8_t *p;
    rt_text_grow(t, t->len + 1);
    p = (uint8_t *)*t->h;
    p[t->len] = c;
    t->len += 1;
}

/* src may alias t (self-append doubles): n is captured before rt_text_grow
   can move t->h's block (which is src->h too, when src == t). For
   self-append, the destination range (t->len, t->len+n) never overlaps the
   source (0, n) because t->len == n when src == t -- no separate
   self-append branch needed, same as the host. */
void rt_text_append_text(rt_text *t, const rt_text *src)
{
    int32_t n;
    n = src->len;
    rt_text_grow(t, t->len + n);
    BlockMoveData(*src->h, *t->h + t->len, (Size)n);
    t->len += n;
}

int rt_text_cmp(const rt_text *a, const rt_text *b)
{
    int32_t alen, blen, n;
    int c;
    alen = a->len;
    blen = b->len;
    n = alen < blen ? alen : blen;
    c = n > 0 ? memcmp(*a->h, *b->h, (size_t)n) : 0;
    if (c < 0) return -1;
    if (c > 0) return 1;
    if (alen < blen) return -1;
    if (alen > blen) return 1;
    return 0;
}

/* ==================== list ==================== */

struct rt_list {
    Handle data;
    int32_t elemsize;
    int32_t count;
    int32_t cap;
};

rt_list *rt_list_new(int32_t elemsize)
{
    rt_list *l;
    l = (rt_list *)rt_mac_new_struct(sizeof(rt_list));
    l->data = NewHandle(0);
    if (!l->data) rt_mac_oom();
    l->elemsize = elemsize;
    l->count = 0;
    l->cap = 0;
    return l;
}

static void *list_slot(rt_list *l, int32_t i)
{
    return (uint8_t *)*l->data + (size_t)i * (size_t)l->elemsize;
}

void rt_list_push(rt_list *l, const void *elem)
{
    rt_mac_grow(l->data, &l->cap, l->count + 1, l->elemsize);
    BlockMoveData(elem, list_slot(l, l->count), (Size)l->elemsize);
    l->count++;
}

void rt_list_pop(rt_list *l, void *out)
{
    if (l->count == 0) rt_panic("pop on empty list");
    l->count--;
    BlockMoveData(list_slot(l, l->count), out, (Size)l->elemsize);
}

void rt_list_shift(rt_list *l, void *out)
{
    if (l->count == 0) rt_panic("shift on empty list");
    BlockMoveData(list_slot(l, 0), out, (Size)l->elemsize);
    BlockMoveData(list_slot(l, 1), list_slot(l, 0), (Size)(l->count - 1) * (Size)l->elemsize);
    l->count--;
}

void rt_list_unshift(rt_list *l, const void *elem)
{
    rt_mac_grow(l->data, &l->cap, l->count + 1, l->elemsize);
    BlockMoveData(list_slot(l, 0), list_slot(l, 1), (Size)l->count * (Size)l->elemsize);
    BlockMoveData(elem, list_slot(l, 0), (Size)l->elemsize);
    l->count++;
}

void rt_list_first(const rt_list *l, void *out)
{
    if (l->count == 0) rt_panic("first on empty list");
    BlockMoveData(*l->data, out, (Size)l->elemsize);
}

void rt_list_last(const rt_list *l, void *out)
{
    if (l->count == 0) rt_panic("last on empty list");
    BlockMoveData((uint8_t *)*l->data + (size_t)(l->count - 1) * (size_t)l->elemsize, out, (Size)l->elemsize);
}

void rt_list_remove(rt_list *l, int32_t i)
{
    int32_t tail;
    if (i < 0 || i >= l->count) rt_panic("list index out of range");
    tail = l->count - 1 - i;
    if (tail > 0) BlockMoveData(list_slot(l, i + 1), list_slot(l, i), (Size)tail * (Size)l->elemsize);
    l->count--;
}

/* CONTRACT: the returned pointer is invalidated by any subsequent mutation
   (push/unshift/remove) of the same list -- the C printer must never hold
   it across an intervening mutation (same contract as the host). */
void *rt_list_at(rt_list *l, int32_t i)
{
    if (i < 0 || i >= l->count) rt_panic("list index out of range");
    return list_slot(l, i);
}

int32_t rt_list_count(const rt_list *l) { return l->count; }

/* ==================== map ====================
 * Sorted parallel arrays, same layout as the host: `keys` holds `count`
 * str255 blocks (256 bytes each) and `vals` holds `count` fixed-size
 * values, index-aligned with `keys`. Entries stay in ascending key order
 * (rt_str_cmp, byte-wise): lookup is a binary search, insertion opens the
 * sorted position in both arrays, removal compacts. Iteration
 * (rt_map_key_at/rt_map_val_at) walks the arrays directly, so it delivers
 * the same ascending-key snapshot order the host's goldens depend on. */

#define MAP_KEYBLOCK 256

struct rt_map {
    Handle keys;     /* count * MAP_KEYBLOCK bytes */
    Handle vals;     /* count * valsize bytes */
    int32_t valsize;
    int32_t count;
    int32_t cap;     /* keys capacity, in entries */
    int32_t valcap;  /* vals capacity, in entries (grown in lockstep with cap) */
};

rt_map *rt_map_new(int32_t valsize)
{
    rt_map *m;
    m = (rt_map *)rt_mac_new_struct(sizeof(rt_map));
    m->keys = NewHandle(0);
    if (!m->keys) rt_mac_oom();
    m->vals = NewHandle(0);
    if (!m->vals) rt_mac_oom();
    m->valsize = valsize;
    m->count = 0;
    m->cap = 0;
    m->valcap = 0;
    return m;
}

static uint8_t *map_key_slot(const rt_map *m, int32_t i)
{
    return (uint8_t *)*m->keys + (size_t)i * MAP_KEYBLOCK;
}

static uint8_t *map_val_slot(const rt_map *m, int32_t i)
{
    return (uint8_t *)*m->vals + (size_t)i * (size_t)m->valsize;
}

/* Binary search for the smallest index whose key is >= `key` (lower bound).
   Sets *found if the key at that index is an exact match. */
static int32_t map_lower_bound(const rt_map *m, const uint8_t *key, int *found)
{
    int32_t lo, hi, mid;
    lo = 0;
    hi = m->count;
    while (lo < hi) {
        mid = lo + (hi - lo) / 2;
        if (rt_str_cmp(map_key_slot(m, mid), key) < 0) {
            lo = mid + 1;
        } else {
            hi = mid;
        }
    }
    *found = lo < m->count && rt_str_cmp(map_key_slot(m, lo), key) == 0;
    return lo;
}

static int32_t map_find(const rt_map *m, const uint8_t *key)
{
    int found;
    int32_t pos;
    pos = map_lower_bound(m, key, &found);
    return found ? pos : -1;
}

void rt_map_set(rt_map *m, const uint8_t *key, const void *val)
{
    int found;
    int32_t pos, tail, klen;
    uint8_t *kslot;
    pos = map_lower_bound(m, key, &found);
    if (found) {
        BlockMoveData(val, map_val_slot(m, pos), (Size)m->valsize);
        return;
    }
    rt_mac_grow(m->keys, &m->cap, m->count + 1, MAP_KEYBLOCK);
    rt_mac_grow(m->vals, &m->valcap, m->count + 1, m->valsize);
    tail = m->count - pos;
    if (tail > 0) {
        BlockMoveData(map_key_slot(m, pos), map_key_slot(m, pos + 1), (Size)tail * MAP_KEYBLOCK);
        BlockMoveData(map_val_slot(m, pos), map_val_slot(m, pos + 1), (Size)tail * (Size)m->valsize);
    }
    klen = key[0];
    kslot = map_key_slot(m, pos);
    kslot[0] = (uint8_t)klen;
    BlockMoveData(key + 1, kslot + 1, (Size)klen);
    BlockMoveData(val, map_val_slot(m, pos), (Size)m->valsize);
    m->count++;
}

void rt_map_get(rt_map *m, const uint8_t *key, void *out)
{
    int32_t idx;
    idx = map_find(m, key);
    if (idx < 0) rt_panic("map key not found");
    BlockMoveData(map_val_slot(m, idx), out, (Size)m->valsize);
}

int rt_map_get_dv(rt_map *m, const uint8_t *key, void *out)
{
    int32_t idx;
    idx = map_find(m, key);
    if (idx < 0) return 0;
    BlockMoveData(map_val_slot(m, idx), out, (Size)m->valsize);
    return 1;
}

int rt_map_has(rt_map *m, const uint8_t *key)
{
    return map_find(m, key) >= 0;
}

void rt_map_remove(rt_map *m, const uint8_t *key)
{
    int32_t idx, tail;
    idx = map_find(m, key);
    if (idx < 0) return; /* silently succeeds if absent */
    tail = m->count - 1 - idx;
    if (tail > 0) {
        BlockMoveData(map_key_slot(m, idx + 1), map_key_slot(m, idx), (Size)tail * MAP_KEYBLOCK);
        BlockMoveData(map_val_slot(m, idx + 1), map_val_slot(m, idx), (Size)tail * (Size)m->valsize);
    }
    m->count--;
}

int32_t rt_map_count(const rt_map *m) { return m->count; }

void rt_map_key_at(const rt_map *m, int32_t i, uint8_t *key255)
{
    if (i < 0 || i >= m->count) rt_panic("map key not found");
    BlockMoveData(map_key_slot(m, i), key255, MAP_KEYBLOCK);
}

void rt_map_val_at(const rt_map *m, int32_t i, void *out)
{
    if (i < 0 || i >= m->count) rt_panic("map key not found");
    BlockMoveData(map_val_slot(m, i), out, (Size)m->valsize);
}

/* ==================== files (stub -- Task 13) ==================== */

int rt_file_read_text(const uint8_t *path, rt_text *t) { rt_panic("not yet implemented on mac"); return 0; }
int rt_file_write_text(const uint8_t *path, const rt_text *t) { rt_panic("not yet implemented on mac"); return 0; }
void rt_file_name(uint8_t *dst255, const uint8_t *path) { rt_panic("not yet implemented on mac"); }
