/* runtime/host/rt.h — host stand-in for the future Toolbox runtime. May use libc. */
#ifndef CLARUS_RT_H
#define CLARUS_RT_H
#include <stdint.h>

/* Strings: [len][bytes...] — a strN value is a struct {uint8_t len; uint8_t b[N];}.
   All functions take the raw pointer to the len byte plus the capacity N. */
void rt_str_store(uint8_t *dst, int dstcap, const uint8_t *src);      /* clamped; sets lastError on truncation */
void rt_str_concat(uint8_t *out255, const uint8_t *a, const uint8_t *b); /* out is a str255 temp */
void rt_str_concat_char(uint8_t *out255, const uint8_t *a, uint8_t c);
int  rt_str_cmp(const uint8_t *a, const uint8_t *b);                  /* bytewise -1/0/1 */
int  rt_str_len(const uint8_t *s);
uint8_t rt_str_index(const uint8_t *s, int32_t i);                    /* panics OOB */
void rt_str_set_index(uint8_t *s, int32_t i, uint8_t c);
void rt_str_from_bytes(uint8_t *dst, int dstcap, const uint8_t *buf, int bufcap, int32_t count);
int32_t rt_str_to_bytes(const uint8_t *src, uint8_t *buf, int bufcap);

int32_t rt_fix_mul(int32_t a, int32_t b);                             /* (a*b)>>16 via int64 */
int32_t rt_fix_div(int32_t a, int32_t b);                             /* (a<<16)/b via int64; b==0 panics "division by zero" */

void rt_panic(const char *msg);                                       /* "runtime error: MSG" to stderr, exit(3) */
void rt_alert(const uint8_t *s);                                      /* stdout + \n; CR bytes rendered as LF */

extern int32_t rt_lasterr_code;
extern uint8_t rt_lasterr_msg[256];                                    /* a str255 */
void rt_set_lasterr(int32_t code, const char *msg);
#endif
