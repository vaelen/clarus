/* runtime/host/rt_atalk.h -- the instance-level C API of rt_atalk.inc
 * (2026-09-06 appletalk spec %6.1, Task 2), split into a header for the
 * ONE reason a header ever earns its place here: three translation units
 * need the same struct layouts. rt_atalk.inc defines them, and
 * rt_atalk_test.c plus tests/tools/atalkdrive.c both link against rt.c
 * and must agree byte-for-byte -- three hand-copied copies of
 * rt_at_req/rt_at_tuple would be a silent ABI bug waiting to happen.
 *
 * The rt_ext_AtalkH* Clarus-facing externs are deliberately NOT declared
 * here: they follow rt.h's own rule (see its header comment) that no
 * rt_ext_* symbol is ever centrally prototyped -- callers declare their
 * own extern. This header is only the rt_at_* instance API.
 *
 * Include AFTER rt.h (it needs int32_t/uint8_t, which rt.h pulls in).
 */
#ifndef RT_ATALK_H
#define RT_ATALK_H

#include <stdint.h>

/* Hard protocol limits (Inside AppleTalk 2nd ed.): one ATP request packet
 * carries at most 578 data bytes, and a response is at most 8 of them. */
#define RT_AT_MAXREQ  578
#define RT_AT_MAXRESP 4624

typedef struct rt_atalk rt_atalk;

typedef struct { uint16_t net; uint8_t node, socket; } rt_at_addr;

/* An NBP tuple as it comes back from a lookup. The three name fields are
 * NUL-terminated C strings (32 chars max each, the NBP limit, + NUL). */
typedef struct { rt_at_addr addr; char obj[33], type[33], zone[33]; } rt_at_tuple;

/* One dequeued ATP request. `userbytes` is the transaction's 32-bit user
 * bytes field -- what Clarus calls the operation code. */
typedef struct {
    rt_at_addr from;
    uint16_t   tid;
    uint8_t    bitmap;
    int        xo;
    int32_t    userbytes;
    uint8_t    data[RT_AT_MAXREQ];
    int        len;
} rt_at_req;

/* --- lifecycle ---------------------------------------------------- */
rt_atalk *rt_at_open(const char *iface_ip); /* NULL + errno; joins the group, acquires a node id */
void      rt_at_close(rt_atalk *a);
int       rt_at_fd(const rt_atalk *a);      /* for select() */
uint8_t   rt_at_node(const rt_atalk *a);
void      rt_at_poll(rt_atalk *a);          /* drain UDP, run timers; never blocks */

/* --- NBP ----------------------------------------------------------- */
#define RT_AT_NLK 10                        /* lookup slots, 0..9 */
int  rt_at_nbp_register(rt_atalk *a, const char *obj, const char *type, uint8_t socket); /* 0, or -1027 */
int  rt_at_nbp_remove(rt_atalk *a, const char *obj, const char *type);                   /* 0, or -1028 */
int  rt_at_nbp_lookup_start(rt_atalk *a, int lk, const char *obj, const char *type, const char *zone);
int  rt_at_nbp_lookup_done(rt_atalk *a, int lk);   /* 1 once the 3x1s window has elapsed */
int  rt_at_nbp_lookup_count(rt_atalk *a, int lk);
const rt_at_tuple *rt_at_nbp_lookup_get(rt_atalk *a, int lk, int i);

/* --- ATP responder ------------------------------------------------- */
int  rt_at_atp_open(rt_atalk *a);                   /* socket 128..254, or negative OSErr */
void rt_at_atp_close(rt_atalk *a, int sock);
int  rt_at_atp_get_request(rt_atalk *a, int sock, rt_at_req *out);  /* 1 if one was dequeued */
int  rt_at_atp_send_response(rt_atalk *a, int sock, const rt_at_req *req,
                             int32_t userbytes, const uint8_t *data, int len); /* len <= 4624 */

/* --- ATP requester (blocking; polls with select internally) -------- */
int  rt_at_atp_call(rt_atalk *a, rt_at_addr to, int32_t userbytes,
                    const uint8_t *req, int reqlen,
                    uint8_t *resp, int respcap, int *resplen, int32_t *resp_userbytes,
                    int timeout_s, int retries); /* 0, -1096 reqFailed, -3106 atpLenErr */

/* --- test-only hooks ------------------------------------------------
 * Exposed unconditionally (rt.c is its own translation unit, so an
 * #ifdef in the test cannot reach it) but named rt_at_test_* and used by
 * nothing outside runtime/host/rt_atalk_test.c. */
#define RT_AT_DROP_TREL 1
void rt_at_test_force_node(rt_atalk *a, uint8_t node);  /* re-acquire starting from `node` */
void rt_at_test_idle_hook(void (*fn)(void));            /* called from every internal wait loop */
void rt_at_test_drop_next_tx(rt_atalk *a, int n);       /* drop the (n+1)-th outgoing datagram, once */
void rt_at_test_drop_next_rx(rt_atalk *a, int what);    /* RT_AT_DROP_TREL: ignore the next TRel */
/* Re-inject the last TReq verbatim and re-run its wait loop -- the XO
 * duplicate-replay probe. (The plan wrote this as a bare `(b)`; it needs
 * the response out-params to be observable at all.) */
int  rt_at_test_resend_last_treq(rt_atalk *a, uint8_t *resp, int respcap, int *resplen);

#endif /* RT_ATALK_H */
