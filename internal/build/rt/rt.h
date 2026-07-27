/* internal/build/rt/rt.h — host stand-in for the future Toolbox runtime. May use libc. */
#ifndef CLARUS_RT_H
#define CLARUS_RT_H
#include <stdint.h>

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

typedef struct rt_map rt_map;     /* string keys -> fixed-size values */
rt_map *rt_map_new(int32_t valsize);
void rt_map_set(rt_map *m, const uint8_t *key, const void *val);
void rt_map_get(rt_map *m, const uint8_t *key, void *out);        /* panics absent: "map key not found" */
int  rt_map_get_dv(rt_map *m, const uint8_t *key, void *out);     /* returns 0 and leaves out untouched if absent */
int  rt_map_has(rt_map *m, const uint8_t *key);
void rt_map_remove(rt_map *m, const uint8_t *key);
int32_t rt_map_count(const rt_map *m);
/* iteration for `for k, v in m`: stable snapshot by index */
void rt_map_key_at(const rt_map *m, int32_t i, uint8_t *key255);
void rt_map_val_at(const rt_map *m, int32_t i, void *out);

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
int rt_file_write_text(const uint8_t *path, const rt_text *t); /* create/truncate write of t's contents; false + lastError on failure */
void rt_file_name(uint8_t *dst255, const uint8_t *path);       /* basename of path; always succeeds */

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
typedef struct { long recSize; short nFields; const rt_field_desc *fields; } rt_layout_desc;

#define RT_SER_REC  0
#define RT_SER_LIST 1
#define RT_SER_MAP  2
int rt_file_save(const uint8_t *path, short container, const void *data, const rt_layout_desc *ld);
int rt_file_load(const uint8_t *path, short container, void *data,       const rt_layout_desc *ld);
void rt_list_clear(rt_list *l); /* count = 0; capacity kept, same growth-preserving pattern as pop/remove */
void rt_map_clear (rt_map *m);  /* count = 0; capacity kept */

/* Mac data-file creator, distinct from the 'TEXT' documents rt_file_write_text
   produces (files saved via rt_file_save get type 'CLRD'). Weak zero default
   in rt_mac.c (every Mac link includes rt_mac.c, so CLI-only programs still
   link); clarusc overrides it with a strong definition when an `app` section
   declares an id (Task 2) -- same weak/strong precedent as rt_ui_app_info. */
extern const unsigned long rt_app_creator;
#endif
