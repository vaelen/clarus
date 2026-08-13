/* runtime/host/rt.h — host stand-in for the future Toolbox runtime. May use libc. */
#ifndef CLARUS_RT_H
#define CLARUS_RT_H
#include <stdint.h>
#include <string.h>

/* clarus int/fixed arithmetic wraps on overflow (two's-complement, same as
   the 68k lane's real ALU: AND.L/MULU.L/ASL.L etc. never trap). Plain
   `int32_t` `+`/`-`/`*`/`<<` in C is instead UB on signed overflow, which
   clang -O1+ exploits (see docs/.../snow-failure-rca.md, 2026-08-13: it
   proved -O1 deletes a masking `&` that follows an overflowing `int32_t *`
   because it can assume the multiply never overflows). cprint.cla's fpBin/
   fpUn route every wrap-sensitive `+ - * << unary-` through these so the C
   lane wraps by construction instead of by (missing) luck. Division,
   modulo, comparisons, and `>>` are excluded: div/mod trap by contract on
   both lanes instead of wrapping, and `>>` must stay a signed arithmetic
   shift to match the 68k lane's ASR (an unsigned shift would change
   negative-operand behavior instead of preserving it). */
#define CLAR_ADD32(a, b) ((int32_t)((uint32_t)(a) + (uint32_t)(b)))
#define CLAR_SUB32(a, b) ((int32_t)((uint32_t)(a) - (uint32_t)(b)))
#define CLAR_MUL32(a, b) ((int32_t)((uint32_t)(a) * (uint32_t)(b)))
#define CLAR_SHL32(a, b) ((int32_t)((uint32_t)(a) << (uint32_t)(b)))
#define CLAR_NEG32(a)    ((int32_t)(0u - (uint32_t)(a)))

/* Strings: [len][bytes...] — a strN value is a struct {uint8_t len; uint8_t b[N];}.
   All functions take the raw pointer to the len byte plus the capacity N. */
void rt_str_store(uint8_t *dst, int dstcap, const uint8_t *src);      /* clamped; sets lastError on truncation */
void rt_str_concat(uint8_t *out255, const uint8_t *a, const uint8_t *b); /* out is a str255 temp */
void rt_str_concat_char(uint8_t *out255, const uint8_t *a, uint8_t c);
void rt_str_prepend_char(uint8_t *out255, uint8_t c, const uint8_t *a); /* out is a str255 temp */
int  rt_str_cmp(const uint8_t *a, const uint8_t *b);                  /* bytewise -1/0/1 */
int  rt_str_len(const uint8_t *s);
uint8_t rt_str_index(const uint8_t *s, int32_t i);                    /* panics OOB */
void rt_str_set_index(uint8_t *s, int32_t i, uint8_t c);
void rt_str_from_bytes(uint8_t *dst, int dstcap, const uint8_t *buf, int bufcap, int32_t count);
int32_t rt_str_to_bytes(const uint8_t *src, uint8_t *buf, int bufcap);
void rt_str_slice(uint8_t *out255, const uint8_t *src, int32_t start, int32_t len); /* strict bounds; panics "slice out of range" (len>255 or OOB) */
int32_t rt_str_index_of_str(const uint8_t *s, const uint8_t *needle);  /* -1 if absent; empty needle -> 0 */
int32_t rt_str_index_of_char(const uint8_t *s, uint8_t c);             /* -1 if absent */

int32_t rt_fix_mul(int32_t a, int32_t b);                             /* (a*b)>>16 via int64 */
int32_t rt_fix_div(int32_t a, int32_t b);                             /* (a<<16)/b via int64; b==0 panics "division by zero" */

void rt_panic(const char *msg);                                       /* "runtime error: MSG" to stderr, exit(3) */
void rt_alert(const uint8_t *s);                                      /* stdout + \n; CR bytes rendered as LF */
void rt_log(const uint8_t *s);                                        /* stderr + \n; CR bytes rendered as LF (Ch12) */
void rt_quit(int32_t code);                                           /* `quit [code]` statement: exit(code) */

extern int32_t rt_lasterr_code;
extern uint8_t rt_lasterr_msg[256];                                    /* a str255 */
void rt_set_lasterr(int32_t code, const char *msg);

typedef struct rt_text rt_text;   /* opaque; growable byte buffer */
rt_text *rt_text_new(void);
void rt_text_store(rt_text *t, const uint8_t *s);            /* from string */
void rt_text_store_text(rt_text *t, const rt_text *src);
void rt_text_concat(rt_text *t, const rt_text *a, const uint8_t *bstr, const rt_text *btext); /* one of bstr/btext non-NULL */
void rt_text_concat_sl(rt_text *t, const uint8_t *sstr, const rt_text *btext); /* string on the left */
int  rt_text_cmp_str(const rt_text *t, const uint8_t *s);
int32_t rt_text_len(const rt_text *t);
uint8_t rt_text_index(const rt_text *t, int32_t i);
void rt_text_set_index(rt_text *t, int32_t i, uint8_t c);
void rt_text_from_bytes(rt_text *t, const uint8_t *buf, int bufcap, int32_t count);
int32_t rt_text_to_bytes(const rt_text *t, uint8_t *buf, int bufcap);
void rt_text_slice(uint8_t *out255, const rt_text *t, int32_t start, int32_t len); /* same strict bounds as rt_str_slice */
int32_t rt_text_index_of_str(const rt_text *t, const uint8_t *needle); /* -1 if absent; empty needle -> 0 */
int32_t rt_text_index_of_char(const rt_text *t, uint8_t c);            /* -1 if absent */
void rt_text_append_str(rt_text *t, const uint8_t *s);    /* amortized growth */
void rt_text_append_char(rt_text *t, uint8_t c);
void rt_text_append_text(rt_text *t, const rt_text *src); /* src may alias t (self-append doubles) */

typedef struct rt_list rt_list;   /* growable array of fixed-size elements */
rt_list *rt_list_new(int32_t elemsize);
void rt_list_push(rt_list *l, const void *elem);
void rt_list_pop(rt_list *l, void *out);      /* panics empty: "pop on empty list" etc. */
void rt_list_shift(rt_list *l, void *out);
void rt_list_unshift(rt_list *l, const void *elem);
void rt_list_first(const rt_list *l, void *out);
void rt_list_last(const rt_list *l, void *out);
void rt_list_remove(rt_list *l, int32_t i);   /* panics OOB */
void *rt_list_at(rt_list *l, int32_t i);      /* element pointer; panics OOB (used for l[i] read AND in-place write) */
int32_t rt_list_count(const rt_list *l);

/* ---- CLI args (main()'s argc/argv plumbing; the printer's Task-3 emitMain
   always calls both, regardless of whether the program declares App.startCLI) ----
   argv[1..argc-1] are stored as str255 values; rt_args_list() builds the
   rt_list once, on first call, and returns that same list on every later
   call. */
void rt_args_init(int argc, char **argv);
rt_list *rt_args_list(void);   /* list of str255 (256-byte elements: 1 len byte + 255 data bytes) */

/* string keys (up to 255 bytes) -> fixed-size values. map-hashtable phase
   Task 5: an open-addressed hashtable (rt_core.inc has the full layout/
   algorithm doc) -- iteration visits entries in an unspecified but
   deterministic order (insertion order, perturbed by removes), NOT
   sorted; use `sortedmap of T` (runtime/clarus/sortedmap.cla -- a
   Clarus-lane-only type, no C-lane rt_sortedmap_* API exists) when
   ascending key order is required. */
typedef struct rt_map rt_map;
rt_map *rt_map_new(int32_t valsize);
void rt_map_set(rt_map *m, const uint8_t *key, const void *val);
void rt_map_get(rt_map *m, const uint8_t *key, void *out);        /* panics absent: "map key not found" */
int  rt_map_get_dv(rt_map *m, const uint8_t *key, void *out);     /* returns 0 and leaves out untouched if absent */
int  rt_map_has(rt_map *m, const uint8_t *key);
void rt_map_remove(rt_map *m, const uint8_t *key);
int32_t rt_map_count(const rt_map *m);
/* iteration for `for k, v in m`: stable snapshot by index, in whatever
   order rt_map's own insertion/removal history currently produces */
void rt_map_key_at(const rt_map *m, int32_t i, uint8_t *key255);
void rt_map_val_at(const rt_map *m, int32_t i, void *out);

/* ---- reference counting (ARC Task 1) ---- NULL-safe; retain increments,
   release decrements and disposes at 0. rt_*_free remain declared as
   aliases for rt_*_release (existing 4e-generated call sites keep working
   unchanged; a value at rc==1 disposes exactly as free() used to). */
void rt_text_retain(rt_text *t);
void rt_text_release(rt_text *t);
void rt_list_retain(rt_list *l);
void rt_list_release(rt_list *l);
void rt_map_retain(rt_map *m);
void rt_map_release(rt_map *m);

/* ARC Task 6 fix round 3: NULL-safe "is this the box's only live
   reference" predicate (true iff non-NULL and rc == 1) -- the compiler
   gates a container's ELEMENT-release walk on this before releasing the
   container itself, so two references sharing one list/map don't each
   walk and re-release the same elements. See rt_core.inc's own comment
   for the full account. */
int rt_text_lastref(const rt_text *t);
int rt_list_lastref(const rt_list *l);
int rt_map_lastref(const rt_map *m);

/* ---- dispose (4e) ---- shallow, NULL-safe; compiler emits element frees.
   Now one-line aliases for the corresponding release above. */
void rt_text_free(rt_text *t);
void rt_list_free(rt_list *l);
void rt_map_free(rt_map *m);
/* one-slot at-exit/quit hook; emitted main registers cl_free_globals */
void rt_register_cleanup(void (*fn)(void));
void rt_run_cleanup(void);
/* marks a list's two ledger blocks (struct box + data Handle) as a
   deliberate process-lifetime allocation -- e.g. rt_args_list's cached
   result -- so the host leak ledger doesn't flag it. No-op on Mac. */
void rt_list_note(rt_list *l, const char *why);

/* ---- added by the C printer (Task 8) ---- */

/* Fixed-array bounds check for `a[i]`: panics "array index out of range" if
   i is out of [0,n); otherwise returns i, so the printer can embed the call
   directly as the array subscript: a.e[rt_arr_check(i, N)]. */
int32_t rt_arr_check(int32_t i, int32_t n);

/* Checked int->enum conversion (`EnumType(i)`): returns v if it appears in
   vals[0..n), else panics "no enum member with value N". */
int32_t rt_enum_from_int(const int32_t *vals, int n, int32_t v);

/* text-vs-text byte-wise comparison (rt_text_cmp_str only compares a text
   against a fixed string; this is the text/text sibling the printer needs
   for `t1 == t2`). */
int rt_text_cmp(const rt_text *a, const rt_text *b);

/* ---- files (Task 13) ----
   path is a str255 (len-prefixed, as elsewhere in this header). Clarus's
   `\n` is CR (Chapter 3) — these copy file contents verbatim, byte for
   byte, with no newline translation; only rt_alert translates CR to LF. */
int rt_file_read_text(const uint8_t *path, rt_text *t);        /* whole-file read into t; false + lastError on open/read failure */
/* create/truncate write of t's contents, stamped with type255/creator255
   (Str255-shaped, native-gaps-cleanup Task 2's mandatory file.writeText
   args) -- host lane ignores both (no FInfo concept on this filesystem),
   Mac lane pads/validates and stamps real FInfo; false + lastError on
   failure (including an over-4-char type/creator on the Mac lane). */
int rt_file_write_text(const uint8_t *path, const rt_text *t, const uint8_t *type255, const uint8_t *creator255);
void rt_file_name(uint8_t *dst255, const uint8_t *path);       /* basename of path; always succeeds */

/* file.readResource/file.writeRes (Task 7, mac-resident-clarusc): host
   stubs only -- no resource-fork concept on this filesystem. readResource
   always fills nothing and returns false; writeRes always writes nothing
   and returns false. Real implementations are runtime/clarus/native.cla's
   natReadResource/natWriteRes (Mac lane only). */
int rt_file_read_resource(const uint8_t *name, rt_text *t);
int rt_file_write_res(const uint8_t *path, const rt_text *t, const uint8_t *type255, const uint8_t *creator255);

/* ---- record serialization (Task 1, mac-target-4d) ----
   Canonical big-endian, field-wise file format shared verbatim between the
   host and Mac runtimes via rt_ser.inc (#included at the bottom of each
   runtime's .c file): 'C' 'L' 'R' 'S', a version byte (1), a container
   byte, then the payload. REC = fields in layout order (RT_FT_* below);
   LIST = 4B BE count + that many records; MAP = 4B BE count + (1 len byte
   + key bytes + record) entries in natural (ascending) key order. */
#define RT_FT_INT   0  /* int32, 4B BE */
#define RT_FT_FIXED 1  /* 4B BE, raw runtime representation */
#define RT_FT_BOOL  2  /* 1B */
#define RT_FT_CHAR  3  /* 1B */
#define RT_FT_STR   4  /* 1 len byte + strCap data bytes (fixed width, zero-padded) */
#define RT_FT_ENUM  5  /* int32 value, 4B BE; load validates membership in enumValues */

typedef struct { short ftype; short strCap; long offset;
                 short enumCount; const int32_t *enumValues;
                 const unsigned char *const *enumLabels; /* Str255s, popup/table render */
} rt_field_desc;
/* Tagged (not anonymous) specifically so runtime/mac/rt_ui.h -- which must
   never #include this header -- can forward-declare the SAME type via
   `typedef struct rt_layout_desc rt_layout_desc;` (mac-target-4d Task 3,
   same opaque-forward-declare convention as rt_text above) and have it
   resolve to this exact complete definition wherever both headers are
   included together (rt_ui.c, uiprobe). An anonymous struct here would
   give rt_ui.h's forward declaration nothing to eventually complete
   against -- two unrelated types spelled the same. */
typedef struct rt_layout_desc { long recSize; short nFields; const rt_field_desc *fields; } rt_layout_desc;

#define RT_SER_REC  0
#define RT_SER_LIST 1
#define RT_SER_MAP  2
int rt_file_save(const uint8_t *path, short container, const void *data, const rt_layout_desc *ld);
int rt_file_load(const uint8_t *path, short container, void *data,       const rt_layout_desc *ld);
void rt_list_clear(rt_list *l); /* count = 0; capacity kept, same growth-preserving pattern as pop/remove */
void rt_map_clear (rt_map *m);  /* count = 0; capacity kept */

/* rt_app_creator (Mac data-file creator weak/strong default) is RETIRED as
   of native-gaps-cleanup Task 2: rt_file_save's own type/creator stamp now
   comes from the caller's own mandatory args, threaded down to the static
   rt_file_write_data primitive each platform's own .c file defines (host
   ignores them; rt_mac.c stamps real FInfo) -- not a program-wide global.
   Its only reader was rt_mac.c's rt_file_write_data. */

/* Plan 5a: peek/poke helpers. memcpy keeps them alignment- and
   strict-aliasing-safe on host; native byte order by design (see
   language reference Ch13 endianness rule). Shared with Mac builds. */
static inline int32_t rt_peekb(void *p) { unsigned char v; memcpy(&v, p, 1); return (int32_t)v; }
static inline int32_t rt_peekw(void *p) { uint16_t v; memcpy(&v, p, 2); return (int32_t)v; }
static inline int32_t rt_peekl(void *p) { uint32_t v; memcpy(&v, p, 4); return (int32_t)v; }
static inline void rt_pokeb(void *p, int32_t x) { unsigned char v = (unsigned char)x; memcpy(p, &v, 1); }
static inline void rt_pokew(void *p, int32_t x) { uint16_t v = (uint16_t)x; memcpy(p, &v, 2); }
static inline void rt_pokel(void *p, int32_t x) { uint32_t v = (uint32_t)x; memcpy(p, &v, 4); }
#endif
