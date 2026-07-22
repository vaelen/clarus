/* internal/build/rt/rt.c — host implementation of the Clarus runtime layer.
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

void rt_quit(int32_t code) {
    exit(code);
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

/* out255 must not alias b (a-aliasing is safe); the printer always passes a fresh temp as out. */
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

/* out255 must not alias b (a-aliasing is safe); the printer always passes a fresh temp as out. */
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
    int64_t n = (int64_t)a * 65536; /* not <<16: left shift of negative is UB (C99 6.5.7p4) */
    return (int32_t)(n / b);
}

/* ---- growable-buffer helper (text, list, map) ----
 * Growth doubles the capacity (x2) whenever more room is needed. Simple
 * integer math, plenty good for host test runs; not tuned for huge lists. */
static void grow(void **data, int32_t *cap, int32_t need, size_t elemsize) {
    if (need <= *cap) return;
    int32_t newcap = *cap > 0 ? *cap : 4;
    while (newcap < need) newcap *= 2;
    void *p = realloc(*data, (size_t)newcap * elemsize);
    if (!p) rt_panic("out of memory");
    *data = p;
    *cap = newcap;
}

/* ==================== text ==================== */

struct rt_text {
    uint8_t *data;
    int32_t len;
    int32_t cap;
};

rt_text *rt_text_new(void) {
    rt_text *t = calloc(1, sizeof(*t));
    if (!t) rt_panic("out of memory");
    return t;
}

void rt_text_store(rt_text *t, const uint8_t *s) {
    int32_t n = s[0];
    grow((void **)&t->data, &t->cap, n, 1);
    memmove(t->data, s + 1, (size_t)n);
    t->len = n;
}

void rt_text_store_text(rt_text *t, const rt_text *src) {
    grow((void **)&t->data, &t->cap, src->len, 1);
    memmove(t->data, src->data, (size_t)src->len); /* no-op copy if t == src */
    t->len = src->len;
}

/* t may alias a (and, defensively, btext); build the result into a scratch
 * buffer first, then copy into t. Costs one extra malloc per concat but
 * sidesteps every aliasing case without special-casing t == a. */
void rt_text_concat(rt_text *t, const rt_text *a, const uint8_t *bstr, const rt_text *btext) {
    int32_t alen = a->len;
    int32_t blen = bstr ? bstr[0] : btext->len;
    int32_t total = alen + blen;
    uint8_t *scratch = malloc((size_t)(total > 0 ? total : 1));
    if (!scratch) rt_panic("out of memory");
    memmove(scratch, a->data, (size_t)alen);
    if (bstr) {
        memmove(scratch + alen, bstr + 1, (size_t)blen);
    } else {
        memmove(scratch + alen, btext->data, (size_t)blen);
    }
    grow((void **)&t->data, &t->cap, total, 1);
    memmove(t->data, scratch, (size_t)total);
    t->len = total;
    free(scratch);
}

int rt_text_cmp_str(const rt_text *t, const uint8_t *s) {
    int32_t tlen = t->len;
    int slen = s[0];
    int n = tlen < slen ? tlen : slen;
    int c = n > 0 ? memcmp(t->data, s + 1, (size_t)n) : 0;
    if (c < 0) return -1;
    if (c > 0) return 1;
    if (tlen < slen) return -1;
    if (tlen > slen) return 1;
    return 0;
}

int32_t rt_text_len(const rt_text *t) { return t->len; }

uint8_t rt_text_index(const rt_text *t, int32_t i) {
    if (i < 0 || i >= t->len) rt_panic("text index out of range");
    return t->data[i];
}

void rt_text_set_index(rt_text *t, int32_t i, uint8_t c) {
    if (i < 0 || i >= t->len) rt_panic("text index out of range");
    t->data[i] = c;
}

/* Text is growable, so from_bytes never truncates on the destination side;
 * it only clamps to bufcap (the source buffer's own size — reading past it
 * would be a source overread, not a text truncation). */
void rt_text_from_bytes(rt_text *t, const uint8_t *buf, int bufcap, int32_t count) {
    int32_t want = count < 0 ? 0 : count;
    int32_t n = want > bufcap ? bufcap : want;
    grow((void **)&t->data, &t->cap, n, 1);
    memmove(t->data, buf, (size_t)n);
    t->len = n;
}

int32_t rt_text_to_bytes(const rt_text *t, uint8_t *buf, int bufcap) {
    int32_t n = t->len < bufcap ? t->len : bufcap;
    memmove(buf, t->data, (size_t)n);
    if (n < t->len) rt_set_lasterr(1, "string truncated");
    return n;
}

/* ==================== list ==================== */

struct rt_list {
    uint8_t *data;
    int32_t elemsize;
    int32_t count;
    int32_t cap;
};

rt_list *rt_list_new(int32_t elemsize) {
    rt_list *l = calloc(1, sizeof(*l));
    if (!l) rt_panic("out of memory");
    l->elemsize = elemsize;
    return l;
}

static void *list_slot(rt_list *l, int32_t i) {
    return l->data + (size_t)i * (size_t)l->elemsize;
}

void rt_list_push(rt_list *l, const void *elem) {
    grow((void **)&l->data, &l->cap, l->count + 1, (size_t)l->elemsize);
    memmove(list_slot(l, l->count), elem, (size_t)l->elemsize);
    l->count++;
}

void rt_list_pop(rt_list *l, void *out) {
    if (l->count == 0) rt_panic("pop on empty list");
    l->count--;
    memmove(out, list_slot(l, l->count), (size_t)l->elemsize);
}

void rt_list_shift(rt_list *l, void *out) {
    if (l->count == 0) rt_panic("shift on empty list");
    memmove(out, list_slot(l, 0), (size_t)l->elemsize);
    memmove(list_slot(l, 0), list_slot(l, 1), (size_t)(l->count - 1) * (size_t)l->elemsize);
    l->count--;
}

void rt_list_unshift(rt_list *l, const void *elem) {
    grow((void **)&l->data, &l->cap, l->count + 1, (size_t)l->elemsize);
    memmove(list_slot(l, 1), list_slot(l, 0), (size_t)l->count * (size_t)l->elemsize);
    memmove(list_slot(l, 0), elem, (size_t)l->elemsize);
    l->count++;
}

void rt_list_first(const rt_list *l, void *out) {
    if (l->count == 0) rt_panic("first on empty list");
    memmove(out, l->data, (size_t)l->elemsize);
}

void rt_list_last(const rt_list *l, void *out) {
    if (l->count == 0) rt_panic("last on empty list");
    memmove(out, l->data + (size_t)(l->count - 1) * (size_t)l->elemsize, (size_t)l->elemsize);
}

void rt_list_remove(rt_list *l, int32_t i) {
    if (i < 0 || i >= l->count) rt_panic("list index out of range");
    int32_t tail = l->count - 1 - i;
    if (tail > 0) memmove(list_slot(l, i), list_slot(l, i + 1), (size_t)tail * (size_t)l->elemsize);
    l->count--;
}

/* CONTRACT: the returned pointer is invalidated by any subsequent mutation (push/unshift/remove) of the same list. The C printer must never hold it across an intervening mutation. */
void *rt_list_at(rt_list *l, int32_t i) {
    if (i < 0 || i >= l->count) rt_panic("list index out of range");
    return list_slot(l, i);
}

int32_t rt_list_count(const rt_list *l) { return l->count; }

/* ==================== CLI args ====================
 * ponytail: this is already the full Task-4 implementation (there's nothing
 * simpler to stub) — argv is just stashed, and rt_args_list() lazily builds
 * a str255 rt_list from it once, the same construction rt_str_from_bytes
 * would produce for each element.
 */
static int g_argc = 0;
static char **g_argv = NULL;
static rt_list *g_args_list = NULL;

void rt_args_init(int argc, char **argv) {
    g_argc = argc;
    g_argv = argv;
    g_args_list = NULL; /* rebuild lazily on next rt_args_list() call */
}

rt_list *rt_args_list(void) {
    if (g_args_list == NULL) {
        g_args_list = rt_list_new(256); /* str255 layout: 1 len byte + 255 data bytes */
        for (int i = 1; i < g_argc; i++) {
            uint8_t arg[256] = {0};
            size_t n = strlen(g_argv[i]);
            if (n > 255) n = 255;
            memmove(arg + 1, g_argv[i], n);
            arg[0] = (uint8_t)n;
            rt_list_push(g_args_list, arg);
        }
    }
    return g_args_list;
}

/* ==================== map ====================
 * Sorted parallel arrays: `keys` holds `count` str255 blocks (256 bytes
 * each: one length byte + up to 255 data bytes, same layout rt_str_* uses)
 * and `vals` holds `count` fixed-size values, index-aligned with `keys`.
 * Entries are kept in ascending key order (rt_str_cmp, byte-wise): lookup
 * is a binary search, insertion memmoves both arrays open at the sorted
 * position, removal compacts.
 *
 * CONTRACT (language reference, Ch3 Maps): iteration visits entries in
 * ascending byte-wise key order. `rt_map_key_at`/`rt_map_val_at` deliver
 * that order directly because the arrays ARE the sort. Goldens depend on
 * it, and the future Mac runtime must honor the same order (its planned
 * layout is a key-sorted offset table over a packed arena — see the design
 * spec §4).
 *
 * ponytail: 256-byte key slots waste space; fine for the host test double.
 * The packed-arena layout is the Mac runtime's job.
 */

#define MAP_KEYBLOCK 256

struct rt_map {
    uint8_t *keys; /* count * MAP_KEYBLOCK bytes */
    uint8_t *vals; /* count * valsize bytes */
    int32_t valsize;
    int32_t count;
    int32_t cap;    /* keys capacity, in entries */
    int32_t valcap; /* vals capacity, in entries (grown in lockstep with cap) */
};

rt_map *rt_map_new(int32_t valsize) {
    rt_map *m = calloc(1, sizeof(*m));
    if (!m) rt_panic("out of memory");
    m->valsize = valsize;
    return m;
}

static uint8_t *map_key_slot(const rt_map *m, int32_t i) {
    return m->keys + (size_t)i * MAP_KEYBLOCK;
}

static uint8_t *map_val_slot(const rt_map *m, int32_t i) {
    return m->vals + (size_t)i * (size_t)m->valsize;
}

/* Binary search for the smallest index whose key is >= `key` (lower bound).
   Sets *found if the key at that index is an exact match. */
static int32_t map_lower_bound(const rt_map *m, const uint8_t *key, int *found) {
    int32_t lo = 0, hi = m->count;
    while (lo < hi) {
        int32_t mid = lo + (hi - lo) / 2;
        if (rt_str_cmp(map_key_slot(m, mid), key) < 0) {
            lo = mid + 1;
        } else {
            hi = mid;
        }
    }
    *found = lo < m->count && rt_str_cmp(map_key_slot(m, lo), key) == 0;
    return lo;
}

static int32_t map_find(const rt_map *m, const uint8_t *key) {
    int found;
    int32_t pos = map_lower_bound(m, key, &found);
    return found ? pos : -1;
}

void rt_map_set(rt_map *m, const uint8_t *key, const void *val) {
    int found;
    int32_t pos = map_lower_bound(m, key, &found);
    if (found) {
        memmove(map_val_slot(m, pos), val, (size_t)m->valsize);
        return;
    }
    grow((void **)&m->keys, &m->cap, m->count + 1, MAP_KEYBLOCK);
    grow((void **)&m->vals, &m->valcap, m->count + 1, (size_t)m->valsize);
    int32_t tail = m->count - pos;
    if (tail > 0) {
        memmove(map_key_slot(m, pos + 1), map_key_slot(m, pos), (size_t)tail * MAP_KEYBLOCK);
        memmove(map_val_slot(m, pos + 1), map_val_slot(m, pos), (size_t)tail * (size_t)m->valsize);
    }
    int32_t klen = key[0];
    uint8_t *kslot = map_key_slot(m, pos);
    kslot[0] = (uint8_t)klen;
    memmove(kslot + 1, key + 1, (size_t)klen);
    memmove(map_val_slot(m, pos), val, (size_t)m->valsize);
    m->count++;
}

void rt_map_get(rt_map *m, const uint8_t *key, void *out) {
    int32_t idx = map_find(m, key);
    if (idx < 0) rt_panic("map key not found");
    memmove(out, map_val_slot(m, idx), (size_t)m->valsize);
}

int rt_map_get_dv(rt_map *m, const uint8_t *key, void *out) {
    int32_t idx = map_find(m, key);
    if (idx < 0) return 0;
    memmove(out, map_val_slot(m, idx), (size_t)m->valsize);
    return 1;
}

int rt_map_has(rt_map *m, const uint8_t *key) {
    return map_find(m, key) >= 0;
}

void rt_map_remove(rt_map *m, const uint8_t *key) {
    int32_t idx = map_find(m, key);
    if (idx < 0) return; /* silently succeeds if absent */
    int32_t tail = m->count - 1 - idx;
    if (tail > 0) {
        memmove(map_key_slot(m, idx), map_key_slot(m, idx + 1), (size_t)tail * MAP_KEYBLOCK);
        memmove(map_val_slot(m, idx), map_val_slot(m, idx + 1), (size_t)tail * (size_t)m->valsize);
    }
    m->count--;
}

int32_t rt_map_count(const rt_map *m) { return m->count; }

void rt_map_key_at(const rt_map *m, int32_t i, uint8_t *key255) {
    if (i < 0 || i >= m->count) rt_panic("map key not found");
    memmove(key255, map_key_slot(m, i), MAP_KEYBLOCK);
}

void rt_map_val_at(const rt_map *m, int32_t i, void *out) {
    if (i < 0 || i >= m->count) rt_panic("map key not found");
    memmove(out, map_val_slot(m, i), (size_t)m->valsize);
}

/* ==================== added by the C printer (Task 8) ==================== */

int32_t rt_arr_check(int32_t i, int32_t n) {
    if (i < 0 || i >= n) rt_panic("array index out of range");
    return i;
}

int32_t rt_enum_from_int(const int32_t *vals, int n, int32_t v) {
    for (int i = 0; i < n; i++) {
        if (vals[i] == v) return v;
    }
    rt_panic("no enum member with value");
    return v; /* unreached; rt_panic never returns, but silences -Wreturn-type-style analyzers */
}

int rt_text_cmp(const rt_text *a, const rt_text *b) {
    int32_t alen = a->len, blen = b->len;
    int32_t n = alen < blen ? alen : blen;
    int c = n > 0 ? memcmp(a->data, b->data, (size_t)n) : 0;
    if (c < 0) return -1;
    if (c > 0) return 1;
    if (alen < blen) return -1;
    if (alen > blen) return 1;
    return 0;
}

/* ==================== files (Task 13) ==================== */

/* path255 is at most 255 bytes; buf holds it plus a NUL terminator for the
 * libc file calls. */
static void path_to_cstr(char *buf, const uint8_t *path255) {
    uint8_t n = path255[0];
    memmove(buf, path255 + 1, (size_t)n);
    buf[n] = '\0';
}

int rt_file_read_text(const uint8_t *path, rt_text *t) {
    char cpath[256];
    path_to_cstr(cpath, path);
    FILE *f = fopen(cpath, "rb");
    if (!f) {
        rt_set_lasterr(2, "could not open file");
        return 0;
    }
    if (fseek(f, 0, SEEK_END) != 0) {
        fclose(f);
        rt_set_lasterr(2, "could not read file");
        return 0;
    }
    long sz = ftell(f);
    if (sz < 0 || fseek(f, 0, SEEK_SET) != 0) {
        fclose(f);
        rt_set_lasterr(2, "could not read file");
        return 0;
    }
    grow((void **)&t->data, &t->cap, (int32_t)sz, 1);
    size_t got = sz > 0 ? fread(t->data, 1, (size_t)sz, f) : 0;
    fclose(f);
    if ((long)got != sz) {
        rt_set_lasterr(2, "could not read file");
        return 0;
    }
    t->len = (int32_t)sz;
    return 1;
}

int rt_file_write_text(const uint8_t *path, const rt_text *t) {
    char cpath[256];
    path_to_cstr(cpath, path);
    FILE *f = fopen(cpath, "wb");
    if (!f) {
        rt_set_lasterr(2, "could not open file");
        return 0;
    }
    size_t wrote = t->len > 0 ? fwrite(t->data, 1, (size_t)t->len, f) : 0;
    int closeErr = fclose(f);
    if ((int32_t)wrote != t->len || closeErr != 0) {
        rt_set_lasterr(2, "could not write file");
        return 0;
    }
    return 1;
}

void rt_file_name(uint8_t *dst255, const uint8_t *path) {
    uint8_t n = path[0];
    int start = 0;
    for (int i = 0; i < n; i++) {
        if (path[1 + i] == '/') start = i + 1;
    }
    uint8_t len = n - (uint8_t)start;
    memmove(dst255 + 1, path + 1 + start, (size_t)len);
    dst255[0] = len;
}
