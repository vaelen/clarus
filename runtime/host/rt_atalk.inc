/* runtime/host/rt_atalk.inc -- host LocalTalk-over-UDP stack (2026-09-06
 * appletalk spec %6.1, Task 2). #included at the bottom of rt.c, exactly
 * like rt_serial.inc above it -- never a separate translation unit.
 *
 * The point: a host Clarus program (and the atalkdrive test tool) becomes
 * a GENUINE AppleTalk peer of the Mini vMac / Snow emulators, which are
 * LocalTalk-over-UDP builds. One UDP socket joined to multicast
 * 239.192.76.84:1954 carries LLAP frames; on top of that sit short-header
 * DDP, NBP (name registration + lookup) and ATP (the request/response
 * transaction protocol Clarus `service`/`call` is built on). No ADSP on
 * this lane (spec Q2: Macs only), no routers, no extended nets: the zone
 * is always "*" and replies never leave net 0.
 *
 * Written INSTANCE-able -- rt_at_open returns a heap struct, and two
 * peers can live in one process -- because that is the only way
 * rt_atalk_test.c can test a protocol against itself. The Clarus-facing
 * rt_ext_AtalkH* layer at the bottom is a thin shim over one lazily
 * opened process-global instance (section h).
 *
 * Everything here is non-blocking except rt_at_atp_call and NBP register's
 * verify-lookup, which loop on select() under their own deadline. Those
 * loops call rt_at_tick, which also invokes the test idle hook -- the
 * single-threaded way rt_atalk_test.c drives its second peer.
 *
 * Wire formats are Inside AppleTalk 2nd ed. (DDP ch. 4, NBP ch. 7,
 * ATP ch. 9); the LToUDP envelope (4-byte sender id + LLAP frame) is the
 * emulators' own convention.
 *
 * Sections, in order:
 *   (a) constants and the instance struct
 *   (b) LToUDP I/O
 *   (c) LLAP node acquisition
 *   (d) DDP short header
 *   (e) NBP
 *   (f) ATP requester
 *   (g) ATP responder + rt_at_poll
 *   (h) the rt_ext_AtalkH* Clarus layer
 */
#include "rt_atalk.h"

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/select.h>
#include <sys/time.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <strings.h>
#include <time.h>

/* ==================== (a) constants and the instance struct ========= */

#define RT_AT_GROUP    "239.192.76.84"
#define RT_AT_PORT     1954
#define RT_AT_DGRAM    1024      /* an LToUDP datagram never exceeds 4+3+586 */

/* LLAP frame types. */
#define RT_AT_LLAP_SHORT 0x01
#define RT_AT_LLAP_LONG  0x02
#define RT_AT_LLAP_ENQ   0x81
#define RT_AT_LLAP_ACK   0x82

/* DDP protocol types we care about. 6 (ZIP) and 7 (ADSP) are dropped. */
#define RT_AT_DDP_NBP  2
#define RT_AT_DDP_ATP  3

#define RT_AT_SOCK_NIS 2         /* the Names Information Socket */
#define RT_AT_BROADCAST 255

/* NBP functions. */
#define RT_AT_NBP_BRRQ  1
#define RT_AT_NBP_LKUP  2
#define RT_AT_NBP_REPLY 3

/* OSErrs this file can produce (Inside Macintosh). */
#define RT_AT_ERR_DUP      (-1027)  /* nbpDuplicate */
#define RT_AT_ERR_NOTFOUND (-1028)  /* nbpNotFound */
#define RT_AT_ERR_BADENTRY (-1029)  /* nbpBadEntry: our own table is full */
#define RT_AT_ERR_REQFAIL  (-1096)  /* reqFailed: retransmit count exhausted */
#define RT_AT_ERR_LEN      (-3106)  /* atpLenErr */
#define RT_AT_ERR_NOSOCK   (-1024)  /* ddpSktErr: no free dynamic socket */

#define RT_AT_NNAMES 4           /* local NBP names table */
#define RT_AT_NTUPLE 32          /* tuples collected per lookup */
#define RT_AT_NSOCK  4           /* bound ATP responder sockets */
#define RT_AT_NQ     4           /* pending requests per socket */
#define RT_AT_NXO    8           /* XO transactions remembered per socket */
#define RT_AT_LK_INT 1.0         /* NBP retry interval; 3 x 1 s is the spec's window */
#define RT_AT_LK_TRY 3
#define RT_AT_NPKT   8           /* ATP response packets per transaction */
#define RT_AT_XO_SECS 30.0       /* XO release timer */

typedef struct {
    int     used;
    char    obj[33], type[33];
    uint8_t socket;
    uint8_t enumerator;
} rt_at_name;

typedef struct {
    int         active;
    uint8_t     nbpid;
    char        obj[33], type[33], zone[33];
    double      next_tx;
    double      deadline;
    int         tx_left;
    double      interval;
    int         count;
    rt_at_tuple tuples[RT_AT_NTUPLE];
} rt_at_lookup;

/* One completed exactly-once transaction, kept so a retransmitted TReq is
 * answered from here instead of running the service a second time. */
typedef struct {
    int        used;
    uint16_t   tid;
    rt_at_addr from;
    uint8_t    mysock;           /* the responder socket the reply goes out from */
    int        npkt;
    int32_t    userbytes;
    int        len[RT_AT_NPKT];
    uint8_t    data[RT_AT_NPKT][RT_AT_MAXREQ];
    double     expiry;
} rt_at_xo;

typedef struct {
    int       used;
    uint8_t   sock;
    rt_at_req q[RT_AT_NQ];
    int       qhead, qcount;
    rt_at_xo  xo[RT_AT_NXO];
} rt_at_sockslot;

/* The single outstanding ATP request. `reqdata` is kept after completion
 * so rt_at_test_resend_last_treq can re-inject it verbatim. */
typedef struct {
    int        active;
    uint16_t   tid;
    rt_at_addr to;
    uint8_t    mysock;
    int32_t    userbytes;
    uint8_t    reqdata[RT_AT_MAXREQ];
    int        reqlen;
    uint8_t    got[RT_AT_NPKT];
    int        len[RT_AT_NPKT];
    uint8_t    data[RT_AT_NPKT][RT_AT_MAXREQ];
    int        eom_seq;          /* -1 until an EOM packet arrives */
    int32_t    resp_userbytes;
} rt_at_rqstate;

struct rt_atalk {
    int                fd;
    uint8_t            sender[4];  /* LToUDP sender id; our own datagrams are dropped */
    uint8_t            node;       /* 0 while unacquired */
    int                acquiring;  /* 1 inside rt_at_acquire: lapENQ means "collision" */
    int                collided;
    struct sockaddr_in group;

    rt_at_name         names[RT_AT_NNAMES];
    uint8_t            enum_next;
    uint8_t            nbp_id;
    /* Slot RT_AT_NLK is register's private verify-lookup; 0..RT_AT_NLK-1
     * are the caller's. */
    rt_at_lookup       lk[RT_AT_NLK + 1];

    rt_at_sockslot     socks[RT_AT_NSOCK];
    uint8_t            sock_next;  /* round-robin hint into 128..254 */

    rt_at_rqstate      rq;
    uint16_t           tid_next;

    /* test hooks (see rt_atalk.h) */
    long               tx_count;
    long               drop_tx_at;  /* -1 = off */
    int                drop_rx_trel;
};

static void (*rt_at_idle_fn)(void);

void rt_at_test_idle_hook(void (*fn)(void)) { rt_at_idle_fn = fn; }

static double rt_at_now(void) {
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return (double)tv.tv_sec + (double)tv.tv_usec / 1e6;
}

/* rt_at_seed: one process-wide srand, so two instances in one process do
 * not draw the same node id and sender id from a fresh identical seed. */
static void rt_at_seed(void) {
    static int done = 0;
    if (!done) {
        srand((unsigned)(time(NULL) ^ (getpid() << 8)));
        done = 1;
    }
}

/* rt_at_cstr: copy at most cap-1 chars, always NUL-terminated. */
static void rt_at_cstr(char *dst, size_t cap, const char *src) {
    size_t n = 0;
    if (src != NULL) while (src[n] != '\0' && n + 1 < cap) { dst[n] = src[n]; n++; }
    dst[n] = '\0';
}

int     rt_at_fd(const rt_atalk *a)   { return a != NULL ? a->fd : -1; }
uint8_t rt_at_node(const rt_atalk *a) { return a != NULL ? a->node : 0; }

/* ==================== (b) LToUDP I/O ================================
 * Datagram = 4-byte sender id + LLAP frame (dst node, src node, LLAP
 * type, payload). Our own datagrams come back through IP_MULTICAST_LOOP
 * and are dropped on the sender id. */

/* rt_at_tx: one LLAP frame onto the group. The drop_tx_at test hook
 * silently discards the (n+1)-th call after it is armed, once. */
static void rt_at_tx(rt_atalk *a, uint8_t dst, uint8_t type,
                     const uint8_t *payload, int len) {
    uint8_t buf[RT_AT_DGRAM];
    int drop;

    if (a == NULL || a->fd < 0 || len < 0 || len + 7 > (int)sizeof(buf)) return;
    drop = (a->drop_tx_at >= 0 && a->tx_count == a->drop_tx_at);
    a->tx_count++;
    if (drop) { a->drop_tx_at = -1; return; }

    memcpy(buf, a->sender, 4);
    buf[4] = dst;
    buf[5] = a->node;
    buf[6] = type;
    if (len > 0) memcpy(buf + 7, payload, (size_t)len);
    sendto(a->fd, buf, (size_t)len + 7, 0,
           (struct sockaddr *)&a->group, sizeof(a->group));
}

void rt_at_test_drop_next_tx(rt_atalk *a, int n) {
    if (a == NULL) return;
    a->tx_count = 0;
    a->drop_tx_at = n;
}

void rt_at_test_drop_next_rx(rt_atalk *a, int what) {
    if (a != NULL && what == RT_AT_DROP_TREL) a->drop_rx_trel = 1;
}

/* ==================== (c) LLAP node acquisition =====================
 * Random id in the 1..127 workstation range, lapENQ it three times 20 ms
 * apart, move on to another id if anyone lapACKs (or probes the same id
 * at the same moment). 20 tries, then EADDRINUSE. */

static void rt_at_drain(rt_atalk *a);

/* rt_at_tick: the one wait primitive. Runs the test idle hook (which is
 * how a second in-process peer gets serviced at all), then blocks in
 * select for at most `ms`, then drains whatever arrived. */
static void rt_at_tick(rt_atalk *a, int ms) {
    fd_set r;
    struct timeval tv;

    if (rt_at_idle_fn != NULL) rt_at_idle_fn();
    if (a == NULL || a->fd < 0) return;
    FD_ZERO(&r);
    FD_SET(a->fd, &r);
    tv.tv_sec = ms / 1000;
    tv.tv_usec = (ms % 1000) * 1000;
    select(a->fd + 1, &r, NULL, NULL, &tv);
    rt_at_drain(a);
}

/* rt_at_acquire: claim a node id, starting from `first` (1..127) or a
 * random one when first <= 0. Returns 0, or -1 with errno EADDRINUSE.
 * Eight lapENQ probes, not three: Inside AppleTalk sends up to 20, and a
 * peer only answers ENQ while something is polling it, so a lone ACK
 * inside a 60 ms window is easy to miss when the group is busy.
 *
 * Each probe waits on a CLOCK, not on one rt_at_tick: tick's select
 * returns the instant ANY datagram lands, so on a busy group the whole
 * probe loop used to finish in about a millisecond -- far quicker than
 * the ACK round trip -- and the id was claimed while its real owner was
 * still answering. That is the T1 interference bug (2026-09-07): the
 * duplicate node ids it minted are what let one process's NBP replies be
 * delivered to another's lookups. */
static int rt_at_acquire(rt_atalk *a, int first) {
    int try_;

    for (try_ = 0; try_ < 20; try_++) {
        int cand = (try_ == 0 && first > 0 && first < 128) ? first : (rand() % 127) + 1;
        int probe;

        a->node = (uint8_t)cand;
        a->acquiring = 1;
        a->collided = 0;
        for (probe = 0; probe < 8 && !a->collided; probe++) {
            double until = rt_at_now() + 0.025;
            rt_at_tx(a, (uint8_t)cand, RT_AT_LLAP_ENQ, NULL, 0);
            while (rt_at_now() < until && !a->collided) rt_at_tick(a, 5);
        }
        a->acquiring = 0;
        if (!a->collided) return 0;
    }
    a->node = 0;
    errno = EADDRINUSE;
    return -1;
}

void rt_at_test_force_node(rt_atalk *a, uint8_t node) {
    if (a != NULL) rt_at_acquire(a, node);
}

/* ==================== (d) DDP short header ==========================
 * [hop/len hi][len lo][dst socket][src socket][DDP type], length counting
 * the header itself. We only ever SEND short headers (net 0, no
 * checksum); long ones are accepted on receipt. */

static void rt_at_ddp_send(rt_atalk *a, rt_at_addr to, uint8_t srcsock,
                           uint8_t ddptype, const uint8_t *data, int dlen) {
    uint8_t p[5 + 586];
    int total = 5 + dlen;

    if (dlen < 0 || dlen > 586) return;
    p[0] = (uint8_t)((total >> 8) & 0x03);
    p[1] = (uint8_t)(total & 0xFF);
    p[2] = to.socket;
    p[3] = srcsock;
    p[4] = ddptype;
    if (dlen > 0) memcpy(p + 5, data, (size_t)dlen);
    rt_at_tx(a, to.node, RT_AT_LLAP_SHORT, p, total);
}

/* rt_at_sock_alloc: next free dynamic socket in 128..254 not already
 * bound here. (A number in use on ANOTHER node is fine -- sockets are
 * per-node.) Returns 0 when everything local is taken. */
static uint8_t rt_at_sock_alloc(rt_atalk *a) {
    int n;
    for (n = 0; n < 127; n++) {
        uint8_t cand = (uint8_t)(128 + ((a->sock_next + n) % 127));
        int i, taken = 0;
        for (i = 0; i < RT_AT_NSOCK; i++)
            if (a->socks[i].used && a->socks[i].sock == cand) taken = 1;
        if (a->rq.mysock == cand) taken = 1;
        if (!taken) {
            a->sock_next = (uint8_t)((cand - 128 + 1) % 127);
            return cand;
        }
    }
    return 0;
}

/* ==================== (e) NBP =======================================
 * Header [func<<4 | tuple count][NBP id], then tuples of
 * AddrBlock(4) enumerator(1) obj type zone (packed Pascal strings). */

/* rt_at_put_pstr / rt_at_get_pstr: the packed Pascal strings inside a
 * tuple. get returns the number of bytes consumed, or 0 on overrun. */
static int rt_at_put_pstr(uint8_t *p, int cap, const char *s) {
    size_t n = strlen(s);
    if (n > 32) n = 32;
    if ((int)n + 1 > cap) return 0;
    p[0] = (uint8_t)n;
    memcpy(p + 1, s, n);
    return (int)n + 1;
}

static int rt_at_get_pstr(const uint8_t *p, int avail, char *out) {
    int n;
    if (avail < 1) return 0;
    n = p[0];
    if (n > 32 || n + 1 > avail) return 0;
    memcpy(out, p + 1, (size_t)n);
    out[n] = '\0';
    return n + 1;
}

/* rt_at_name_match: NBP matching, case-insensitive, with "=" as the full
 * wildcard. ponytail: the partial-wildcard character (0xC5 in MacRoman)
 * is not implemented -- nothing in the Clarus surface exposes it. */
static int rt_at_name_match(const char *pat, const char *s) {
    if (pat[0] == '=' && pat[1] == '\0') return 1;
    return strcasecmp(pat, s) == 0;
}

/* Our lane has exactly one zone, "*" (no router -- spec %2). */
static int rt_at_zone_match(const char *pat) {
    return pat[0] == '\0' || strcmp(pat, "*") == 0 || strcasecmp(pat, "local") == 0;
}

/* rt_at_nbp_send: one NBP packet with `count` tuples already encoded in
 * `body` (of `blen` bytes). */
static void rt_at_nbp_send(rt_atalk *a, rt_at_addr to, uint8_t srcsock,
                           int func, int count, uint8_t nbpid,
                           const uint8_t *body, int blen) {
    uint8_t p[586];
    if (blen + 2 > (int)sizeof(p)) return;
    p[0] = (uint8_t)(((func & 0x0F) << 4) | (count & 0x0F));
    p[1] = nbpid;
    if (blen > 0) memcpy(p + 2, body, (size_t)blen);
    rt_at_ddp_send(a, to, srcsock, RT_AT_DDP_NBP, p, blen + 2);
}

/* rt_at_tuple_put: encode one tuple into `p`. Returns bytes written. */
static int rt_at_tuple_put(uint8_t *p, int cap, rt_at_addr addr, uint8_t enumerator,
                           const char *obj, const char *type, const char *zone) {
    int at = 0, k;
    if (cap < 5) return 0;
    p[0] = (uint8_t)(addr.net >> 8);
    p[1] = (uint8_t)(addr.net & 0xFF);
    p[2] = addr.node;
    p[3] = addr.socket;
    p[4] = enumerator;
    at = 5;
    k = rt_at_put_pstr(p + at, cap - at, obj);  if (k == 0) return 0; at += k;
    k = rt_at_put_pstr(p + at, cap - at, type); if (k == 0) return 0; at += k;
    k = rt_at_put_pstr(p + at, cap - at, zone); if (k == 0) return 0; at += k;
    return at;
}

/* rt_at_lookup_tx: one LkUp broadcast for slot `lk` (node 255, socket 2 --
 * the NIS), asking for replies at our own NIS socket. */
static void rt_at_lookup_tx(rt_atalk *a, rt_at_lookup *L) {
    uint8_t body[256];
    rt_at_addr me, bcast;
    int n;

    me.net = 0; me.node = a->node; me.socket = RT_AT_SOCK_NIS;
    n = rt_at_tuple_put(body, (int)sizeof(body), me, 0, L->obj, L->type, L->zone);
    if (n == 0) return;
    bcast.net = 0; bcast.node = RT_AT_BROADCAST; bcast.socket = RT_AT_SOCK_NIS;
    rt_at_nbp_send(a, bcast, RT_AT_SOCK_NIS, RT_AT_NBP_LKUP, 1, L->nbpid, body, n);
}

/* rt_at_lookup_begin: shared by the public lookup_start and by register's
 * own verify lookup. Both use the spec's 3 x 1 s window: the Mac's
 * registerName blocks ~3.2 s for the same verify (interval 8, count 3), so
 * host parity is right, and duplicate detection is the one NBP path that
 * must not be hurried on a network with 8 MHz peers. A register therefore
 * blocks for that window -- accepted, controller ruling 2026-09-07. */
static int rt_at_lookup_begin(rt_atalk *a, int lk, const char *obj, const char *type,
                              const char *zone) {
    rt_at_lookup *L;

    if (a == NULL || lk < 0 || lk > RT_AT_NLK) return -1;
    L = &a->lk[lk];
    memset(L, 0, sizeof(*L));
    L->active = 1;
    a->nbp_id++;
    if (a->nbp_id == 0) a->nbp_id = 1;
    L->nbpid = a->nbp_id;
    rt_at_cstr(L->obj, sizeof(L->obj), obj);
    rt_at_cstr(L->type, sizeof(L->type), type);
    rt_at_cstr(L->zone, sizeof(L->zone), (zone != NULL && zone[0] != '\0') ? zone : "*");
    L->interval = RT_AT_LK_INT;
    L->tx_left = RT_AT_LK_TRY;
    L->deadline = rt_at_now() + RT_AT_LK_INT * RT_AT_LK_TRY;

    rt_at_lookup_tx(a, L);
    L->tx_left--;
    L->next_tx = rt_at_now() + RT_AT_LK_INT;
    return 0;
}

int rt_at_nbp_lookup_start(rt_atalk *a, int lk, const char *obj, const char *type,
                           const char *zone) {
    if (lk < 0 || lk >= RT_AT_NLK) return -1;
    return rt_at_lookup_begin(a, lk, obj, type, zone);
}

int rt_at_nbp_lookup_done(rt_atalk *a, int lk) {
    if (a == NULL || lk < 0 || lk > RT_AT_NLK) return 1;
    if (!a->lk[lk].active) return 1;
    return rt_at_now() >= a->lk[lk].deadline;
}

int rt_at_nbp_lookup_count(rt_atalk *a, int lk) {
    if (a == NULL || lk < 0 || lk > RT_AT_NLK) return 0;
    return a->lk[lk].count;
}

const rt_at_tuple *rt_at_nbp_lookup_get(rt_atalk *a, int lk, int i) {
    if (a == NULL || lk < 0 || lk > RT_AT_NLK) return NULL;
    if (i < 0 || i >= a->lk[lk].count) return NULL;
    return &a->lk[lk].tuples[i];
}

/* rt_at_lookup_add: de-duplicated by (address, obj, type) -- the same
 * entity answers all three broadcasts. (The plan said (address,
 * enumerator); the name is the finer key, and it survives a peer that
 * re-registers with a fresh enumerator mid-window.)
 *
 * The pattern re-check is not belt-and-braces: an NBP id is 8 bits and a
 * LkUp-Reply is unicast to the requester's NODE, so on a busy group a
 * reply meant for somebody else's lookup can land here (two hosts holding
 * the same node id, ids colliding). A lookup must only ever report
 * entities matching what IT asked for. */
static void rt_at_lookup_add(rt_at_lookup *L, rt_at_addr addr,
                             const char *obj, const char *type, const char *zone) {
    int i;
    if (!rt_at_name_match(L->obj, obj) || !rt_at_name_match(L->type, type)) return;
    for (i = 0; i < L->count; i++) {
        rt_at_tuple *t = &L->tuples[i];
        if (t->addr.net == addr.net && t->addr.node == addr.node &&
            t->addr.socket == addr.socket && strcasecmp(t->obj, obj) == 0 &&
            strcasecmp(t->type, type) == 0)
            return;
    }
    if (L->count >= RT_AT_NTUPLE) return;
    L->tuples[L->count].addr = addr;
    rt_at_cstr(L->tuples[L->count].obj, 33, obj);
    rt_at_cstr(L->tuples[L->count].type, 33, type);
    rt_at_cstr(L->tuples[L->count].zone, 33, zone);
    L->count++;
}

/* rt_at_nbp_in: an NBP packet arrived. LkUp/BrRq get answered from the
 * local names table; LkUp-Reply feeds whichever lookup slot owns the id. */
static void rt_at_nbp_in(rt_atalk *a, rt_at_addr from, const uint8_t *d, int n) {
    int func, count, at, i;
    uint8_t nbpid;

    if (n < 2) return;
    func = d[0] >> 4;
    count = d[0] & 0x0F;
    nbpid = d[1];
    at = 2;

    for (i = 0; i < count; i++) {
        rt_at_addr taddr;
        char obj[33], type[33], zone[33];
        int k;

        if (at + 5 > n) return;
        taddr.net = (uint16_t)((d[at] << 8) | d[at + 1]);
        taddr.node = d[at + 2];
        taddr.socket = d[at + 3];
        at += 5;                     /* d[at+4] is the enumerator: unused on receipt */
        k = rt_at_get_pstr(d + at, n - at, obj);  if (k == 0) return; at += k;
        k = rt_at_get_pstr(d + at, n - at, type); if (k == 0) return; at += k;
        k = rt_at_get_pstr(d + at, n - at, zone); if (k == 0) return; at += k;

        if (func == RT_AT_NBP_LKUP || func == RT_AT_NBP_BRRQ) {
            uint8_t body[586];
            rt_at_addr reply;
            int matches = 0, blen = 0, j;

            if (!rt_at_zone_match(zone)) continue;
            for (j = 0; j < RT_AT_NNAMES && matches < 15; j++) {
                rt_at_name *nm = &a->names[j];
                rt_at_addr mine;
                int w;
                if (!nm->used) continue;
                if (!rt_at_name_match(obj, nm->obj) || !rt_at_name_match(type, nm->type))
                    continue;
                mine.net = 0; mine.node = a->node; mine.socket = nm->socket;
                w = rt_at_tuple_put(body + blen, (int)sizeof(body) - blen, mine,
                                    nm->enumerator, nm->obj, nm->type, "*");
                if (w == 0) break;
                blen += w;
                matches++;
            }
            if (matches == 0) continue;
            /* Replies go to the address IN THE TUPLE (NBP's own rule), not
             * to the DDP source -- a router would differ. Fall back to the
             * DDP source if the tuple carries no node. */
            reply = taddr.node != 0 ? taddr : from;
            rt_at_nbp_send(a, reply, RT_AT_SOCK_NIS, RT_AT_NBP_REPLY,
                           matches, nbpid, body, blen);
        } else if (func == RT_AT_NBP_REPLY) {
            int lk;
            for (lk = 0; lk <= RT_AT_NLK; lk++)
                if (a->lk[lk].active && a->lk[lk].nbpid == nbpid)
                    rt_at_lookup_add(&a->lk[lk], taddr, obj, type, zone);
        }
    }
}

int rt_at_nbp_register(rt_atalk *a, const char *obj, const char *type, uint8_t socket) {
    int i, free_slot = -1;

    if (a == NULL) return RT_AT_ERR_BADENTRY;
    for (i = 0; i < RT_AT_NNAMES; i++) {
        if (!a->names[i].used) { if (free_slot < 0) free_slot = i; continue; }
        if (strcasecmp(a->names[i].obj, obj) == 0 && strcasecmp(a->names[i].type, type) == 0)
            return RT_AT_ERR_DUP;
    }
    if (free_slot < 0) return RT_AT_ERR_BADENTRY;

    /* Verify-lookup first: NBP has no registry, so "is this name taken?"
     * is literally "does anyone answer a lookup for it?". */
    if (rt_at_lookup_begin(a, RT_AT_NLK, obj, type, "*") == 0) {
        while (!rt_at_nbp_lookup_done(a, RT_AT_NLK)) rt_at_tick(a, 10);
        a->lk[RT_AT_NLK].active = 0;
        if (a->lk[RT_AT_NLK].count > 0) return RT_AT_ERR_DUP;
    }

    a->enum_next++;
    if (a->enum_next == 0) a->enum_next = 1;
    a->names[free_slot].used = 1;
    rt_at_cstr(a->names[free_slot].obj, 33, obj);
    rt_at_cstr(a->names[free_slot].type, 33, type);
    a->names[free_slot].socket = socket;
    a->names[free_slot].enumerator = a->enum_next;
    return 0;
}

int rt_at_nbp_remove(rt_atalk *a, const char *obj, const char *type) {
    int i;
    if (a == NULL) return RT_AT_ERR_NOTFOUND;
    for (i = 0; i < RT_AT_NNAMES; i++)
        if (a->names[i].used && strcasecmp(a->names[i].obj, obj) == 0 &&
            strcasecmp(a->names[i].type, type) == 0) {
            a->names[i].used = 0;
            return 0;
        }
    return RT_AT_ERR_NOTFOUND;
}

/* ==================== (f) ATP requester =============================
 * Header (8 bytes): [control][bitmap or seq][TID hi][TID lo][user bytes x4].
 * control = func<<6 | XO 0x20 | EOM 0x10 | STS 0x08. STS is never set. */

#define RT_AT_ATP_TREQ  1
#define RT_AT_ATP_TRESP 2
#define RT_AT_ATP_TREL  3

static void rt_at_atp_hdr(uint8_t *p, int func, int flags, uint8_t seqmap,
                          uint16_t tid, int32_t ub) {
    p[0] = (uint8_t)(((func & 3) << 6) | flags);
    p[1] = seqmap;
    p[2] = (uint8_t)(tid >> 8);
    p[3] = (uint8_t)(tid & 0xFF);
    p[4] = (uint8_t)((ub >> 24) & 0xFF);
    p[5] = (uint8_t)((ub >> 16) & 0xFF);
    p[6] = (uint8_t)((ub >> 8) & 0xFF);
    p[7] = (uint8_t)(ub & 0xFF);
}

/* rt_at_rq_bitmap: bits still wanted. Before EOM is known, every packet
 * we have not got; after, only those up to the EOM sequence. */
static uint8_t rt_at_rq_bitmap(const rt_at_rqstate *r) {
    int last = r->eom_seq >= 0 ? r->eom_seq : RT_AT_NPKT - 1;
    uint8_t m = 0;
    int i;
    for (i = 0; i <= last; i++) if (!r->got[i]) m |= (uint8_t)(1 << i);
    return m;
}

static int rt_at_rq_complete(const rt_at_rqstate *r) {
    return r->eom_seq >= 0 && rt_at_rq_bitmap(r) == 0;
}

static void rt_at_rq_treq(rt_atalk *a, uint8_t bitmap) {
    uint8_t p[8 + RT_AT_MAXREQ];
    rt_at_rqstate *r = &a->rq;
    rt_at_atp_hdr(p, RT_AT_ATP_TREQ, 0x20, bitmap, r->tid, r->userbytes);
    if (r->reqlen > 0) memcpy(p + 8, r->reqdata, (size_t)r->reqlen);
    rt_at_ddp_send(a, r->to, r->mysock, RT_AT_DDP_ATP, p, 8 + r->reqlen);
}

/* rt_at_rq_wait: send the TReq, then poll until every response packet is
 * in or the retransmit budget runs out; TRel on success. */
static int rt_at_rq_wait(rt_atalk *a, uint8_t *resp, int respcap, int *resplen,
                         int timeout_s, int retries) {
    rt_at_rqstate *r = &a->rq;
    int tries;

    if (timeout_s < 1) timeout_s = 1;
    if (retries < 0) retries = 0;
    r->active = 1;
    rt_at_rq_treq(a, rt_at_rq_bitmap(r));

    for (tries = 0; tries <= retries; tries++) {
        double deadline = rt_at_now() + timeout_s;
        while (rt_at_now() < deadline) {
            if (rt_at_rq_complete(r)) goto done;
            rt_at_tick(a, 10);
        }
        if (rt_at_rq_complete(r)) goto done;
        if (tries < retries) rt_at_rq_treq(a, rt_at_rq_bitmap(r));
    }
    r->active = 0;
    return RT_AT_ERR_REQFAIL;

done:
    {
        uint8_t p[8];
        int total = 0, i, at = 0;
        rt_at_atp_hdr(p, RT_AT_ATP_TREL, 0x20, 0, r->tid, 0);
        rt_at_ddp_send(a, r->to, r->mysock, RT_AT_DDP_ATP, p, 8);
        for (i = 0; i <= r->eom_seq; i++) total += r->len[i];
        r->active = 0;
        if (total > respcap) return RT_AT_ERR_LEN;
        for (i = 0; i <= r->eom_seq; i++) {
            if (r->len[i] > 0) memcpy(resp + at, r->data[i], (size_t)r->len[i]);
            at += r->len[i];
        }
        if (resplen != NULL) *resplen = total;
        return 0;
    }
}

int rt_at_atp_call(rt_atalk *a, rt_at_addr to, int32_t userbytes,
                   const uint8_t *req, int reqlen,
                   uint8_t *resp, int respcap, int *resplen, int32_t *resp_userbytes,
                   int timeout_s, int retries) {
    rt_at_rqstate *r;
    int rc;

    if (a == NULL) return RT_AT_ERR_REQFAIL;
    if (reqlen < 0 || reqlen > RT_AT_MAXREQ) return RT_AT_ERR_LEN;
    r = &a->rq;
    if (r->mysock == 0) {
        r->mysock = rt_at_sock_alloc(a);
        if (r->mysock == 0) return RT_AT_ERR_NOSOCK;
    }
    memset(r->got, 0, sizeof(r->got));
    memset(r->len, 0, sizeof(r->len));
    r->eom_seq = -1;
    r->resp_userbytes = 0;
    r->to = to;
    r->userbytes = userbytes;
    r->reqlen = reqlen;
    if (reqlen > 0) memcpy(r->reqdata, req, (size_t)reqlen);
    a->tid_next++;
    if (a->tid_next == 0) a->tid_next = 1;
    r->tid = a->tid_next;

    rc = rt_at_rq_wait(a, resp, respcap, resplen, timeout_s, retries);
    if (resp_userbytes != NULL) *resp_userbytes = r->resp_userbytes;
    return rc;
}

int rt_at_test_resend_last_treq(rt_atalk *a, uint8_t *resp, int respcap, int *resplen) {
    rt_at_rqstate *r;
    if (a == NULL || a->rq.tid == 0) return RT_AT_ERR_REQFAIL;
    r = &a->rq;
    memset(r->got, 0, sizeof(r->got));
    memset(r->len, 0, sizeof(r->len));
    r->eom_seq = -1;
    return rt_at_rq_wait(a, resp, respcap, resplen, 2, 3);
}

/* ==================== (g) ATP responder + rt_at_poll ================ */

static rt_at_sockslot *rt_at_sock_find(rt_atalk *a, uint8_t sock) {
    int i;
    for (i = 0; i < RT_AT_NSOCK; i++)
        if (a->socks[i].used && a->socks[i].sock == sock) return &a->socks[i];
    return NULL;
}

int rt_at_atp_open(rt_atalk *a) {
    int i;
    uint8_t sock;
    if (a == NULL) return RT_AT_ERR_NOSOCK;
    for (i = 0; i < RT_AT_NSOCK; i++) if (!a->socks[i].used) break;
    if (i == RT_AT_NSOCK) return RT_AT_ERR_NOSOCK;
    sock = rt_at_sock_alloc(a);
    if (sock == 0) return RT_AT_ERR_NOSOCK;
    memset(&a->socks[i], 0, sizeof(a->socks[i]));
    a->socks[i].used = 1;
    a->socks[i].sock = sock;
    return (int)sock;
}

void rt_at_atp_close(rt_atalk *a, int sock) {
    rt_at_sockslot *s;
    if (a == NULL || sock < 0 || sock > 255) return;
    s = rt_at_sock_find(a, (uint8_t)sock);
    if (s != NULL) memset(s, 0, sizeof(*s));
}

int rt_at_atp_get_request(rt_atalk *a, int sock, rt_at_req *out) {
    rt_at_sockslot *s;
    if (a == NULL || sock < 0 || sock > 255) return 0;
    s = rt_at_sock_find(a, (uint8_t)sock);
    if (s == NULL || s->qcount == 0) return 0;
    if (out != NULL) *out = s->q[s->qhead];
    s->qhead = (s->qhead + 1) % RT_AT_NQ;
    s->qcount--;
    return 1;
}

static int rt_at_same_peer(rt_at_addr x, rt_at_addr y) {
    return x.net == y.net && x.node == y.node && x.socket == y.socket;
}

/* rt_at_xo_find: the remembered transaction for (tid, peer), or NULL. */
static rt_at_xo *rt_at_xo_find(rt_at_sockslot *s, uint16_t tid, rt_at_addr from) {
    int i;
    for (i = 0; i < RT_AT_NXO; i++)
        if (s->xo[i].used && s->xo[i].tid == tid && rt_at_same_peer(s->xo[i].from, from))
            return &s->xo[i];
    return NULL;
}

/* rt_at_xo_replay: resend exactly the packets `bitmap` still asks for. */
static void rt_at_xo_replay(rt_atalk *a, rt_at_xo *x, uint8_t bitmap) {
    int i;
    for (i = 0; i < x->npkt; i++) {
        uint8_t p[8 + RT_AT_MAXREQ];
        int eom = (i == x->npkt - 1) ? 0x10 : 0;
        if (!((bitmap >> i) & 1)) continue;
        rt_at_atp_hdr(p, RT_AT_ATP_TRESP, eom, (uint8_t)i, x->tid, x->userbytes);
        if (x->len[i] > 0) memcpy(p + 8, x->data[i], (size_t)x->len[i]);
        rt_at_ddp_send(a, x->from, x->mysock, RT_AT_DDP_ATP, p, 8 + x->len[i]);
    }
}

int rt_at_atp_send_response(rt_atalk *a, int sock, const rt_at_req *req,
                            int32_t userbytes, const uint8_t *data, int len) {
    rt_at_sockslot *s;
    rt_at_xo *x = NULL;
    int npkt, i, at, oldest = 0;
    double now, oldest_t;

    if (a == NULL || req == NULL) return RT_AT_ERR_REQFAIL;
    if (len < 0 || len > RT_AT_MAXRESP) return RT_AT_ERR_LEN;
    s = rt_at_sock_find(a, (uint8_t)sock);
    if (s == NULL) return RT_AT_ERR_NOSOCK;

    npkt = (len + RT_AT_MAXREQ - 1) / RT_AT_MAXREQ;
    if (npkt == 0) npkt = 1;

    /* Store first (so a retransmitted TReq can be replayed even if it
     * arrives before our own packets are all on the wire), then replay
     * against the request's bitmap -- which IS the first transmission. */
    now = rt_at_now();
    oldest_t = 0;
    for (i = 0; i < RT_AT_NXO; i++) {
        if (!s->xo[i].used) { x = &s->xo[i]; break; }
        if (oldest_t == 0 || s->xo[i].expiry < oldest_t) { oldest_t = s->xo[i].expiry; oldest = i; }
    }
    if (x == NULL) x = &s->xo[oldest];
    memset(x, 0, sizeof(*x));
    x->used = 1;
    x->tid = req->tid;
    x->from = req->from;
    x->mysock = s->sock;
    x->npkt = npkt;
    x->userbytes = userbytes;
    x->expiry = now + RT_AT_XO_SECS;
    at = 0;
    for (i = 0; i < npkt; i++) {
        int k = len - at;
        if (k > RT_AT_MAXREQ) k = RT_AT_MAXREQ;
        if (k > 0) memcpy(x->data[i], data + at, (size_t)k);
        x->len[i] = k;
        at += k;
    }
    rt_at_xo_replay(a, x, req->bitmap != 0 ? req->bitmap : 0xFF);
    /* A non-XO request needs no memory of the transaction. */
    if (!req->xo) x->used = 0;
    return 0;
}

/* rt_at_atp_in: one ATP packet. TReq -> XO replay or the request queue;
 * TResp -> the single outstanding requester state; TRel -> forget. */
static void rt_at_atp_in(rt_atalk *a, rt_at_addr from, uint8_t dstsock,
                         const uint8_t *d, int n) {
    int func, ctl;
    uint16_t tid;
    int32_t ub;

    if (n < 8) return;
    ctl = d[0];
    func = (ctl >> 6) & 3;
    tid = (uint16_t)((d[2] << 8) | d[3]);
    ub = (int32_t)(((uint32_t)d[4] << 24) | ((uint32_t)d[5] << 16) |
                   ((uint32_t)d[6] << 8) | (uint32_t)d[7]);

    if (func == RT_AT_ATP_TRESP) {
        rt_at_rqstate *r = &a->rq;
        int seq = d[1];
        /* The sender check matters on a shared multicast group: without it
         * a foreign peer that happens to reuse our TID could splice bytes
         * into the response. (net is 0 on both sides on this routerless
         * lane -- see rt_at_ddp_send.) */
        if (!r->active || dstsock != r->mysock || tid != r->tid) return;
        if (!rt_at_same_peer(from, r->to)) return;
        if (seq >= RT_AT_NPKT) return;
        if (!r->got[seq]) {
            int k = n - 8;
            if (k > RT_AT_MAXREQ) k = RT_AT_MAXREQ;
            if (k > 0) memcpy(r->data[seq], d + 8, (size_t)k);
            r->len[seq] = k;
            r->got[seq] = 1;
            if (seq == 0) r->resp_userbytes = ub;
        }
        if (ctl & 0x10) r->eom_seq = seq;
        return;
    }

    {
        rt_at_sockslot *s = rt_at_sock_find(a, dstsock);
        if (s == NULL) return;

        if (func == RT_AT_ATP_TREL) {
            rt_at_xo *x = rt_at_xo_find(s, tid, from);
            if (x == NULL) return;
            /* Test hook, checked here and not earlier so a foreign peer's
             * TRel on the shared group cannot eat the arm. */
            if (a->drop_rx_trel) { a->drop_rx_trel = 0; return; }
            x->used = 0;
            return;
        }
        if (func != RT_AT_ATP_TREQ) return;
        {
            rt_at_xo *x = rt_at_xo_find(s, tid, from);
            int i, k;
            if (x != NULL) { rt_at_xo_replay(a, x, d[1]); return; }
            /* Already queued and not yet answered: a retransmit, not a
             * second transaction. */
            for (i = 0; i < s->qcount; i++) {
                rt_at_req *q = &s->q[(s->qhead + i) % RT_AT_NQ];
                if (q->tid == tid && rt_at_same_peer(q->from, from)) return;
            }
            if (s->qcount >= RT_AT_NQ) return;  /* full: drop, the peer retransmits */
            {
                rt_at_req *q = &s->q[(s->qhead + s->qcount) % RT_AT_NQ];
                memset(q, 0, sizeof(*q));
                q->from = from;
                q->tid = tid;
                q->bitmap = d[1];
                q->xo = (ctl & 0x20) ? 1 : 0;
                q->userbytes = ub;
                k = n - 8;
                if (k > RT_AT_MAXREQ) k = RT_AT_MAXREQ;
                if (k > 0) memcpy(q->data, d + 8, (size_t)k);
                q->len = k;
                s->qcount++;
            }
        }
    }
}

/* rt_at_frame_in: one received LToUDP datagram, already stripped of the
 * sender id. */
static void rt_at_frame_in(rt_atalk *a, const uint8_t *f, int n) {
    uint8_t dst, src, type;
    const uint8_t *p;
    int plen;

    if (n < 3) return;
    dst = f[0];
    src = f[1];
    type = f[2];
    p = f + 3;
    plen = n - 3;

    if (type == RT_AT_LLAP_ENQ) {
        if (dst != a->node) return;
        /* Someone is probing the id we hold -- or, mid-acquisition, the id
         * we are trying to hold, in which case we yield rather than both
         * claiming it. */
        if (a->acquiring) a->collided = 1;
        else rt_at_tx(a, dst, RT_AT_LLAP_ACK, NULL, 0);
        return;
    }
    if (type == RT_AT_LLAP_ACK) {
        if (a->acquiring && dst == a->node) a->collided = 1;
        return;
    }
    if (a->node != 0 && dst != a->node && dst != RT_AT_BROADCAST) return;

    {
        rt_at_addr from;
        uint8_t dstsock, ddptype;
        const uint8_t *data;
        int len, dlen;

        if (type == RT_AT_LLAP_SHORT) {
            if (plen < 5) return;
            len = ((p[0] & 0x03) << 8) | p[1];
            if (len < 5 || len > plen) return;
            dstsock = p[2];
            from.net = 0; from.node = src; from.socket = p[3];
            ddptype = p[4];
            data = p + 5;
            dlen = len - 5;
        } else if (type == RT_AT_LLAP_LONG) {
            if (plen < 13) return;
            len = ((p[0] & 0x03) << 8) | p[1];
            if (len < 13 || len > plen) return;
            from.net = (uint16_t)((p[6] << 8) | p[7]);
            dstsock = p[10];
            from.node = p[9];
            from.socket = p[11];
            ddptype = p[12];
            data = p + 13;
            dlen = len - 13;
        } else {
            return;
        }

        if (ddptype == RT_AT_DDP_NBP) rt_at_nbp_in(a, from, data, dlen);
        else if (ddptype == RT_AT_DDP_ATP) rt_at_atp_in(a, from, dstsock, data, dlen);
        /* ZIP (6) and ADSP (7) are dropped: no router, no ADSP on this lane. */
    }
}

/* rt_at_drain: read every datagram the socket has, dropping our own. */
static void rt_at_drain(rt_atalk *a) {
    uint8_t buf[RT_AT_DGRAM];
    ssize_t n;
    int guard;

    if (a == NULL || a->fd < 0) return;
    for (guard = 0; guard < 256; guard++) {
        n = recv(a->fd, buf, sizeof(buf), 0);
        if (n < 0) return;
        if (n < 7) continue;
        if (memcmp(buf, a->sender, 4) == 0) continue;   /* our own echo */
        rt_at_frame_in(a, buf + 4, (int)n - 4);
    }
}

void rt_at_poll(rt_atalk *a) {
    double now;
    int lk, i, j;

    if (a == NULL) return;
    rt_at_drain(a);
    now = rt_at_now();

    for (lk = 0; lk <= RT_AT_NLK; lk++) {
        rt_at_lookup *L = &a->lk[lk];
        if (!L->active || L->tx_left <= 0) continue;
        if (now >= L->next_tx) {
            rt_at_lookup_tx(a, L);
            L->tx_left--;
            L->next_tx = now + L->interval;
        }
    }
    for (i = 0; i < RT_AT_NSOCK; i++) {
        if (!a->socks[i].used) continue;
        for (j = 0; j < RT_AT_NXO; j++)
            if (a->socks[i].xo[j].used && now >= a->socks[i].xo[j].expiry)
                a->socks[i].xo[j].used = 0;
    }
}

/* ==================== open / close =================================== */

rt_atalk *rt_at_open(const char *iface_ip) {
    rt_atalk *a;
    struct sockaddr_in bindaddr;
    struct ip_mreq mreq;
    int yes = 1, flags;
    unsigned char loop = 1;
    struct in_addr iface;

    rt_at_seed();
    a = (rt_atalk *)calloc(1, sizeof(*a));
    if (a == NULL) { errno = ENOMEM; return NULL; }
    a->fd = -1;
    a->drop_tx_at = -1;

    iface.s_addr = htonl(INADDR_ANY);
    if (iface_ip != NULL && iface_ip[0] != '\0') {
        in_addr_t v = inet_addr(iface_ip);
        if (v == INADDR_NONE) { free(a); errno = EINVAL; return NULL; }
        iface.s_addr = v;
    }

    a->fd = socket(AF_INET, SOCK_DGRAM, 0);
    if (a->fd < 0) { free(a); return NULL; }
    setsockopt(a->fd, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(yes));
#ifdef SO_REUSEPORT
    /* Mandatory for two instances in one process (and for coexisting with
     * a Mini vMac on the same machine). */
    setsockopt(a->fd, SOL_SOCKET, SO_REUSEPORT, &yes, sizeof(yes));
#endif
    {   /* Best-effort: an instance is drained once per pump pass, and the
         * default receive buffer overflows on a group with a dozen live
         * peers -- a dropped lapACK there costs a duplicate node id. */
        int rcvbuf = 256 * 1024;
        setsockopt(a->fd, SOL_SOCKET, SO_RCVBUF, &rcvbuf, sizeof(rcvbuf));
    }
    memset(&bindaddr, 0, sizeof(bindaddr));
    bindaddr.sin_family = AF_INET;
    bindaddr.sin_addr.s_addr = htonl(INADDR_ANY);
    bindaddr.sin_port = htons(RT_AT_PORT);
    if (bind(a->fd, (struct sockaddr *)&bindaddr, sizeof(bindaddr)) != 0) goto fail;

    memset(&mreq, 0, sizeof(mreq));
    mreq.imr_multiaddr.s_addr = inet_addr(RT_AT_GROUP);
    mreq.imr_interface = iface;
    if (setsockopt(a->fd, IPPROTO_IP, IP_ADD_MEMBERSHIP, &mreq, sizeof(mreq)) != 0)
        goto fail;
    setsockopt(a->fd, IPPROTO_IP, IP_MULTICAST_LOOP, &loop, sizeof(loop));
    if (iface.s_addr != htonl(INADDR_ANY))
        setsockopt(a->fd, IPPROTO_IP, IP_MULTICAST_IF, &iface, sizeof(iface));

    flags = fcntl(a->fd, F_GETFL, 0);
    fcntl(a->fd, F_SETFL, flags | O_NONBLOCK);

    memset(&a->group, 0, sizeof(a->group));
    a->group.sin_family = AF_INET;
    a->group.sin_addr.s_addr = inet_addr(RT_AT_GROUP);
    a->group.sin_port = htons(RT_AT_PORT);

    a->sender[0] = (uint8_t)(rand() & 0xFF);
    a->sender[1] = (uint8_t)(rand() & 0xFF);
    a->sender[2] = (uint8_t)(rand() & 0xFF);
    a->sender[3] = (uint8_t)((rand() & 0xFE) | 1);   /* never all-zero */
    a->sock_next = (uint8_t)(rand() % 127);
    a->nbp_id = (uint8_t)(rand() & 0xFF);   /* not 1 in every fresh instance */
    a->tid_next = (uint16_t)(rand() & 0xFFFF);
    a->rq.eom_seq = -1;

    if (rt_at_acquire(a, 0) != 0) goto fail;
    return a;

fail:
    {
        int e = errno;
        close(a->fd);
        free(a);
        errno = e;
        return NULL;
    }
}

void rt_at_close(rt_atalk *a) {
    if (a == NULL) return;
    if (a->fd >= 0) close(a->fd);
    free(a);
}

/* ==================== (h) the Clarus rt_ext_AtalkH* layer ============
 * One lazily opened process-global instance. `string` parameters arrive
 * as Pascal strings; addresses cross as net<<16 | node<<8 | socket. */

static rt_atalk *rt_at_g;
static rt_at_req rt_at_g_req;      /* the last request AtpGetRequest dequeued */
static int       rt_at_g_req_live; /* 0 once answered or once a dequeue came up empty */
static int32_t   rt_at_g_code;     /* the last AtpCall's response user bytes */

/* rt_at_pstr: a Clarus Pascal string to a C string. Deliberately NOT
 * rt.c's path_to_cstr -- that one rewrites ':' to '/' for HFS paths, and
 * ':' is meaningful in an NBP name. */
static void rt_at_pstr(char *buf, size_t cap, const uint8_t *p) {
    size_t n;
    if (p == NULL) { buf[0] = '\0'; return; }
    n = p[0];
    if (n > cap - 1) n = cap - 1;
    memcpy(buf, p + 1, n);
    buf[n] = '\0';
}

static int32_t rt_at_pack(rt_at_addr x) {
    return (int32_t)(((uint32_t)x.net << 16) | ((uint32_t)x.node << 8) | x.socket);
}

int32_t rt_ext_AtalkHUp(void) {
    if (rt_at_g != NULL) return 0;
    errno = 0;
    rt_at_g = rt_at_open(getenv("CLARUS_ATALK_IFACE"));
    if (rt_at_g == NULL) return errno != 0 ? (int32_t)errno : 1;
    return 0;
}

int32_t rt_ext_AtalkHNode(void) { return (int32_t)rt_at_node(rt_at_g); }

int32_t rt_ext_AtalkHRegister(const uint8_t *obj, const uint8_t *type, int32_t sock) {
    char o[64], t[64];
    if (rt_at_g == NULL) return RT_AT_ERR_BADENTRY;
    rt_at_pstr(o, sizeof(o), obj);
    rt_at_pstr(t, sizeof(t), type);
    return rt_at_nbp_register(rt_at_g, o, t, (uint8_t)sock);
}

int32_t rt_ext_AtalkHRemove(const uint8_t *obj, const uint8_t *type) {
    char o[64], t[64];
    if (rt_at_g == NULL) return RT_AT_ERR_NOTFOUND;
    rt_at_pstr(o, sizeof(o), obj);
    rt_at_pstr(t, sizeof(t), type);
    return rt_at_nbp_remove(rt_at_g, o, t);
}

int32_t rt_ext_AtalkHLookupStart(int32_t lk, const uint8_t *obj, const uint8_t *type,
                                 const uint8_t *zone) {
    char o[64], t[64], z[64];
    if (rt_at_g == NULL) return -1;
    rt_at_pstr(o, sizeof(o), obj);
    rt_at_pstr(t, sizeof(t), type);
    rt_at_pstr(z, sizeof(z), zone);
    return rt_at_nbp_lookup_start(rt_at_g, (int)lk, o, t, z);
}

int32_t rt_ext_AtalkHLookupDone(int32_t lk)  { return rt_at_nbp_lookup_done(rt_at_g, (int)lk); }
int32_t rt_ext_AtalkHLookupCount(int32_t lk) { return rt_at_nbp_lookup_count(rt_at_g, (int)lk); }

int32_t rt_ext_AtalkHLookupAddr(int32_t lk, int32_t i) {
    const rt_at_tuple *t = rt_at_nbp_lookup_get(rt_at_g, (int)lk, (int)i);
    return t != NULL ? rt_at_pack(t->addr) : 0;
}

/* rt_ext_AtalkHLookupName: "obj:type" as a Pascal string in a 68-byte
 * buffer (1 length + 32 + 1 + 32 + slack). */
void rt_ext_AtalkHLookupName(int32_t lk, int32_t i, void *out) {
    const rt_at_tuple *t = rt_at_nbp_lookup_get(rt_at_g, (int)lk, (int)i);
    uint8_t *p = (uint8_t *)out;
    char joined[80];
    size_t n;

    if (p == NULL) return;
    if (t == NULL) { p[0] = 0; return; }
    snprintf(joined, sizeof(joined), "%s:%s", t->obj, t->type);
    n = strlen(joined);
    if (n > 67) n = 67;
    p[0] = (uint8_t)n;
    memcpy(p + 1, joined, n);
}

int32_t rt_ext_AtalkHAtpOpen(void) {
    if (rt_at_g == NULL) return RT_AT_ERR_NOSOCK;
    return rt_at_atp_open(rt_at_g);
}

void rt_ext_AtalkHAtpClose(int32_t sock) { rt_at_atp_close(rt_at_g, (int)sock); }

int32_t rt_ext_AtalkHAtpGetRequest(int32_t sock, void *buf, int32_t cap) {
    int n;
    if (rt_at_g == NULL) return -1;
    if (!rt_at_atp_get_request(rt_at_g, (int)sock, &rt_at_g_req)) {
        /* Nothing dequeued: drop the previous transaction on the floor, or
         * a SendResponse after an empty poll would send a second, unasked-
         * for response and re-arm a fresh 30 s XO entry under the old TID. */
        rt_at_g_req_live = 0;
        return -1;
    }
    rt_at_g_req_live = 1;
    n = rt_at_g_req.len;
    if (n > (int)cap) n = (int)cap;
    if (n > 0 && buf != NULL) memcpy(buf, rt_at_g_req.data, (size_t)n);
    return n;
}

int32_t rt_ext_AtalkHAtpReqOp(void)   { return rt_at_g_req.userbytes; }
int32_t rt_ext_AtalkHAtpReqFrom(void) { return rt_at_pack(rt_at_g_req.from); }

/* rt_ext_AtalkHAtpSendResponse: answers the request the last successful
 * AtalkHAtpGetRequest dequeued, once. */
int32_t rt_ext_AtalkHAtpSendResponse(int32_t sock, int32_t code, void *buf, int32_t n) {
    int32_t rc;
    if (rt_at_g == NULL) return RT_AT_ERR_NOSOCK;
    if (!rt_at_g_req_live) return RT_AT_ERR_REQFAIL;
    rc = rt_at_atp_send_response(rt_at_g, (int)sock, &rt_at_g_req, code,
                                 (const uint8_t *)buf, (int)n);
    if (rc == 0) rt_at_g_req_live = 0;
    return rc;
}

int32_t rt_ext_AtalkHAtpCall(int32_t addr, int32_t op, void *req, int32_t reqLen,
                             void *resp, int32_t respCap) {
    rt_at_addr to;
    int rlen = 0, rc;
    if (rt_at_g == NULL) return RT_AT_ERR_REQFAIL;
    to.net = (uint16_t)((addr >> 16) & 0xFFFF);
    to.node = (uint8_t)((addr >> 8) & 0xFF);
    to.socket = (uint8_t)(addr & 0xFF);
    rt_at_g_code = 0;
    rc = rt_at_atp_call(rt_at_g, to, op, (const uint8_t *)req, (int)reqLen,
                        (uint8_t *)resp, (int)respCap, &rlen, &rt_at_g_code, 2, 3);
    return rc != 0 ? rc : rlen;
}

int32_t rt_ext_AtalkHAtpCallCode(void) { return rt_at_g_code; }

void rt_ext_AtalkHPoll(void) { rt_at_poll(rt_at_g); }

/* rt_ext_AtalkHFd: the stack's UDP fd for a host pump's select set, or -1
 * while the stack is down. rt_ext_ConnHIdle (rt_serial.inc) FD_SETs it
 * when it is >= 0, so an AppleTalk-only host server sleeps on traffic
 * instead of taking that pump's 20 ms usleep arm. */
int32_t rt_ext_AtalkHFd(void) { return (int32_t)rt_at_fd(rt_at_g); }
