/* runtime/host/rt_atalk_test.c -- hand-written C harness for the host
 * LocalTalk-over-UDP stack (2026-09-06 appletalk spec %6.1/%8.1, Task 2:
 * runtime/host/rt_atalk.inc, #included at the bottom of rt.c). Mirrors
 * rt_serial_test.c's style: CHECK macro, "OK\n" on success.
 *
 * Compile + run by hand:
 *   cc -std=c99 -Wall -Werror -I runtime/host \
 *      runtime/host/rt_atalk_test.c runtime/host/rt.c -o /tmp/atalktest
 *   /tmp/atalktest
 * (tests/hostrt/atalk.sh does exactly this via lib.sh's run_c_test.)
 *
 * Two stack instances, `A` and `B`, in ONE process, talking to each other
 * over loopback multicast (239.192.76.84:1954, IP_MULTICAST_LOOP on) --
 * i.e. the same wire the Mini vMac/Snow LToUDP builds are on. Everything
 * is single-threaded: the requester's internal wait loop calls the global
 * idle hook (rt_at_test_idle_hook) once per iteration, and this test's
 * hook is what drives A -- poll it, and answer any ATP request that has
 * arrived. That is also how A gets polled during B's node acquisition and
 * during B's NBP verify-lookup.
 *
 * The multicast group is shared with whatever else is on this machine's
 * network (Andrew's live emulator sessions, an EtherTalk bridge), so
 * nothing here asserts an exact entity count and every registered name
 * carries the pid.
 *
 * A sandbox with no multicast is not a failure: if rt_at_open fails with
 * ENODEV/EADDRNOTAVAIL/EPERM/EAFNOSUPPORT the test prints
 * "SKIP: multicast unavailable" and exits 77, the harness's own skip code
 * (tests/hostrt/atalk.sh propagates it). Exit 0 + "OK" means it really ran.
 */
#include "rt.h"
#include "rt_atalk.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <sys/select.h>
#include <sys/time.h>

static int failed = 0;
#define CHECK(cond, msg) \
    do { if (!(cond)) { fprintf(stderr, "FAIL: %s (%s:%d)\n", msg, __FILE__, __LINE__); failed = 1; } } while (0)

static rt_atalk *A, *B;
static int      a_sock = -1;     /* A's ATP responder socket */
static int      a_reqs;          /* successful rt_at_atp_get_request calls on A */
static int32_t  a_last_op;       /* userbytes of the last request A dequeued */
static uint8_t  a_reply[4000];   /* 4000 bytes => 7 response packets */

#define A_REPLY_CODE 9

/* drive_a: the global idle hook. Every internal wait loop in rt_atalk.inc
 * calls this once per iteration, which is the only reason A ever runs at
 * all while B is blocked inside a call. */
static void drive_a(void) {
    rt_at_req req;
    if (A == NULL) return;
    rt_at_poll(A);
    if (a_sock >= 0 && rt_at_atp_get_request(A, a_sock, &req)) {
        a_reqs++;
        a_last_op = req.userbytes;
        rt_at_atp_send_response(A, a_sock, &req, A_REPLY_CODE, a_reply, (int)sizeof(a_reply));
    }
}

/* pump: hand-drive both stacks for `ms` milliseconds. Used where the test
 * itself is the wait loop (NBP lookups), rather than rt_atalk.inc's. */
static void pump(int ms) {
    int i;
    for (i = 0; i < ms / 10; i++) {
        drive_a();
        if (B != NULL) rt_at_poll(B);
        usleep(10000);
    }
}

static double now_s(void) {
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return (double)tv.tv_sec + (double)tv.tv_usec / 1e6;
}

/* wait_lookup: pump until the lookup's own 3 x 1 s window closes. */
static void wait_lookup(rt_atalk *a, int lk) {
    double deadline = now_s() + 8.0;
    while (!rt_at_nbp_lookup_done(a, lk) && now_s() < deadline) pump(50);
}

/* found_obj: 1 if lookup `lk` on `a` returned a tuple with obj == name. */
static int found_obj(rt_atalk *a, int lk, const char *name) {
    int i, n = rt_at_nbp_lookup_count(a, lk);
    for (i = 0; i < n; i++) {
        const rt_at_tuple *t = rt_at_nbp_lookup_get(a, lk, i);
        if (t != NULL && strcmp(t->obj, name) == 0) return 1;
    }
    return 0;
}

/* --- 1/2: node acquisition ------------------------------------------ */
static void test_nodes(void) {
    uint8_t na = rt_at_node(A), nb = rt_at_node(B);
    CHECK(na >= 1 && na <= 127, "A node out of the 1..127 workstation range");
    CHECK(nb >= 1 && nb <= 127, "B node out of the 1..127 workstation range");
    CHECK(na != nb, "A and B acquired the same node id");

    /* Forced collision: make B re-acquire starting from A's id. A answers
     * the lapENQ with a lapACK (via the idle hook), so B must move on. */
    rt_at_test_force_node(B, na);
    nb = rt_at_node(B);
    CHECK(nb >= 1 && nb <= 127, "B node out of range after forced collision");
    CHECK(nb != na, "forced collision left B on A's node id");
}

/* --- 3: NBP --------------------------------------------------------- */
static char nbp_obj[40];

static void test_nbp(void) {
    int rc;

    snprintf(nbp_obj, sizeof(nbp_obj), "Unit-%ld", (long)getpid());
    rc = rt_at_nbp_register(A, nbp_obj, "ClarusTest", 200);
    CHECK(rc == 0, "register on A failed");

    rt_at_nbp_lookup_start(B, 0, "=", "ClarusTest", "*");
    wait_lookup(B, 0);
    CHECK(rt_at_nbp_lookup_count(B, 0) >= 1, "wildcard lookup found nothing");
    CHECK(found_obj(B, 0, nbp_obj), "wildcard lookup missed A's registered name");

    rc = rt_at_nbp_register(B, nbp_obj, "ClarusTest", 201);
    CHECK(rc == -1027, "duplicate register did not return nbpDuplicate");

    rc = rt_at_nbp_remove(A, nbp_obj, "ClarusTest");
    CHECK(rc == 0, "remove on A failed");
    rc = rt_at_nbp_remove(A, nbp_obj, "ClarusTest");
    CHECK(rc == -1028, "second remove did not return nbpNotFound");

    rt_at_nbp_lookup_start(B, 1, "=", "ClarusTest", "*");
    wait_lookup(B, 1);
    CHECK(!found_obj(B, 1, nbp_obj), "removed name still answered a lookup");
}

/* --- 4/5/6: ATP ----------------------------------------------------- */
static rt_at_addr a_addr(void) {
    rt_at_addr to;
    to.net = 0;
    to.node = rt_at_node(A);
    to.socket = (uint8_t)a_sock;
    return to;
}

/* one_call: the shared "B calls A, A answers 4000 bytes" assertion body. */
static void one_call(const char *what) {
    uint8_t resp[RT_AT_MAXRESP];
    int rlen = 0, i, bad = 0, rc;
    int32_t rub = 0;

    rc = rt_at_atp_call(B, a_addr(), 7, (const uint8_t *)"ping", 4,
                        resp, (int)sizeof(resp), &rlen, &rub, 1, 4);
    if (rc != 0) {
        fprintf(stderr, "FAIL: %s: atp_call rc=%d\n", what, rc);
        failed = 1;
        return;
    }
    CHECK(rlen == 4000, "response length is not 4000");
    CHECK(rub == A_REPLY_CODE, "response user bytes wrong");
    for (i = 0; i < rlen && i < 4000; i++) if (resp[i] != (uint8_t)(i & 0xFF)) bad++;
    CHECK(bad == 0, "response body bytes wrong");
    CHECK(a_last_op == 7, "responder saw the wrong request user bytes");
    /* The requester's TRel is on the wire but A has not looked at it yet;
     * settle it here so the next case's drop_next_rx arms against ITS OWN
     * TRel and not this one's. */
    pump(100);
}

static void test_atp(void) {
    unsigned i;
    uint8_t big[RT_AT_MAXRESP + 1];
    rt_at_req dummy;
    int rlen = 0, rc;
    int32_t rub = 0;

    for (i = 0; i < sizeof(a_reply); i++) a_reply[i] = (uint8_t)(i & 0xFF);

    a_sock = rt_at_atp_open(A);
    CHECK(a_sock >= 128 && a_sock <= 254, "atp_open did not return a dynamic socket");
    if (a_sock < 0) return;

    /* 4: plain 4000-byte transaction (7 response packets). */
    a_reqs = 0;
    one_call("plain call");
    CHECK(a_reqs == 1, "responder dequeued other than one request");

    /* 5: drop A's 4th outgoing datagram once -- the bitmap retransmit must
     * still bring the transaction home. */
    a_reqs = 0;
    rt_at_test_drop_next_tx(A, 3);
    one_call("call with a dropped response packet");
    CHECK(a_reqs == 1, "dropped-packet call re-entered the request queue");

    /* 6: XO duplicate replay. A ignores the TRel, so the transaction stays
     * in its XO list; B re-injects the same TReq and must be answered from
     * that list, WITHOUT the request reaching get_request a second time. */
    a_reqs = 0;
    rt_at_test_drop_next_rx(A, RT_AT_DROP_TREL);
    one_call("call whose TRel is dropped");
    CHECK(a_reqs == 1, "TRel-dropped call did not dequeue exactly one request");
    {
        uint8_t resp2[RT_AT_MAXRESP];
        int rlen2 = 0, bad = 0, j;
        rc = rt_at_test_resend_last_treq(B, resp2, (int)sizeof(resp2), &rlen2);
        CHECK(rc == 0, "replayed TReq was not answered");
        CHECK(rlen2 == 4000, "replayed response length is not 4000");
        for (j = 0; j < rlen2 && j < 4000; j++) if (resp2[j] != (uint8_t)(j & 0xFF)) bad++;
        CHECK(bad == 0, "replayed response body bytes wrong");
        CHECK(a_reqs == 1, "XO replay reached get_request instead of the XO list");
    }

    /* 7: oversize both ways. */
    rc = rt_at_atp_call(B, a_addr(), 1, big, RT_AT_MAXREQ + 1,
                        big, (int)sizeof(big), &rlen, &rub, 1, 1);
    CHECK(rc == -3106, "579-byte request did not return atpLenErr");
    memset(&dummy, 0, sizeof(dummy));
    dummy.from = a_addr();
    dummy.tid = 1;
    dummy.bitmap = 0xFF;
    rc = rt_at_atp_send_response(A, a_sock, &dummy, 0, big, RT_AT_MAXRESP + 1);
    CHECK(rc == -3106, "4625-byte response did not return atpLenErr");
}

/* --- 8: select() idle wake ------------------------------------------ */
static void test_idle_wake(void) {
    fd_set r;
    struct timeval tv;
    double t0;
    int n;

    pump(100);                       /* drain anything already queued on A */
    rt_at_nbp_lookup_start(B, 2, "=", "ClarusTest", "*");
    t0 = now_s();
    FD_ZERO(&r);
    FD_SET(rt_at_fd(A), &r);
    tv.tv_sec = 2;
    tv.tv_usec = 0;
    n = select(rt_at_fd(A) + 1, &r, NULL, NULL, &tv);
    CHECK(n > 0, "select on the AppleTalk fd did not wake on B's lookup");
    CHECK(now_s() - t0 < 0.5, "select took longer than 500 ms to wake");
}

/* --- 9: the Clarus-facing rt_ext_AtalkH* layer ----------------------
 * A THIRD stack instance, the process-global one those wrappers own.
 * Everything above tests the rt_at_* instance API directly; this pins the
 * shim Task 7's atalk_c.cla actually calls -- the Pascal-string
 * conversions, the packed net<<16|node<<8|socket address, and the
 * "obj:type" name buffer. Runs last so the extra node on the wire cannot
 * perturb anything else. */
extern int32_t rt_ext_AtalkHUp(void);
extern int32_t rt_ext_AtalkHNode(void);
extern int32_t rt_ext_AtalkHFd(void);
extern void    rt_ext_AtalkHPoll(void);
extern int32_t rt_ext_AtalkHLookupStart(int32_t lk, const uint8_t *obj,
                                        const uint8_t *type, const uint8_t *zone);
extern int32_t rt_ext_AtalkHLookupDone(int32_t lk);
extern int32_t rt_ext_AtalkHLookupCount(int32_t lk);
extern int32_t rt_ext_AtalkHLookupAddr(int32_t lk, int32_t i);
extern void    rt_ext_AtalkHLookupName(int32_t lk, int32_t i, void *out);
extern int32_t rt_ext_AtalkHAtpOpen(void);
extern void    rt_ext_AtalkHAtpClose(int32_t sock);
extern int32_t rt_ext_AtalkHAtpGetRequest(int32_t sock, void *buf, int32_t cap);
extern int32_t rt_ext_AtalkHAtpSendResponse(int32_t sock, int32_t code, void *buf, int32_t n);

/* pstr: a C string as the Pascal string a Clarus `string` argument is. */
static void pstr(uint8_t *p, const char *s) {
    size_t n = strlen(s);
    if (n > 63) n = 63;
    p[0] = (uint8_t)n;
    memcpy(p + 1, s, n);
}

static void test_ext(void) {
    uint8_t po[64], pt[64], pz[64], name[68];
    char want[80];
    int32_t rc, node, i, n;
    double deadline;
    int seen = 0;

    rc = rt_ext_AtalkHUp();
    CHECK(rc == 0, "AtalkHUp failed");
    if (rc != 0) return;
    CHECK(rt_ext_AtalkHUp() == 0, "AtalkHUp is not idempotent");
    node = rt_ext_AtalkHNode();
    CHECK(node >= 1 && node <= 127, "AtalkHNode out of the workstation range");
    CHECK(rt_ext_AtalkHFd() >= 0, "AtalkHFd is negative while the stack is up");

    /* A re-registers the name test_nbp removed, and the global instance
     * finds it through the Clarus-facing wrappers. */
    CHECK(rt_at_nbp_register(A, nbp_obj, "ClarusTest", 200) == 0, "re-register on A failed");
    pstr(po, "=");
    pstr(pt, "ClarusTest");
    pstr(pz, "*");
    CHECK(rt_ext_AtalkHLookupStart(0, po, pt, pz) == 0, "AtalkHLookupStart failed");
    deadline = now_s() + 8.0;
    while (!rt_ext_AtalkHLookupDone(0) && now_s() < deadline) {
        drive_a();
        rt_at_poll(B);
        rt_ext_AtalkHPoll();
        usleep(10000);
    }
    n = rt_ext_AtalkHLookupCount(0);
    CHECK(n >= 1, "AtalkHLookupCount found nothing");
    snprintf(want, sizeof(want), "%s:ClarusTest", nbp_obj);
    for (i = 0; i < n; i++) {
        int32_t addr = rt_ext_AtalkHLookupAddr(0, i);
        memset(name, 0, sizeof(name));
        rt_ext_AtalkHLookupName(0, i, name);
        if (name[0] == (uint8_t)strlen(want) && memcmp(name + 1, want, strlen(want)) == 0) {
            seen = 1;
            CHECK(((addr >> 16) & 0xFFFF) == 0, "packed address has a nonzero net");
            CHECK(((addr >> 8) & 0xFF) == rt_at_node(A), "packed address has the wrong node");
            CHECK((addr & 0xFF) == 200, "packed address has the wrong socket");
        }
    }
    CHECK(seen, "AtalkHLookupName never produced \"obj:ClarusTest\"");
    rt_at_nbp_remove(A, nbp_obj, "ClarusTest");

    /* A SendResponse with no live request must be refused: without the
     * guard it would answer the PREVIOUS transaction a second time and
     * re-arm a fresh 30 s XO entry under that old TID. */
    {
        int32_t sk = rt_ext_AtalkHAtpOpen();
        uint8_t body[8];
        CHECK(sk >= 128 && sk <= 254, "AtalkHAtpOpen did not return a dynamic socket");
        if (sk >= 0) {
            CHECK(rt_ext_AtalkHAtpGetRequest(sk, body, (int32_t)sizeof(body)) == -1,
                  "AtalkHAtpGetRequest invented a request");
            CHECK(rt_ext_AtalkHAtpSendResponse(sk, 0, body, 0) == -1096,
                  "AtalkHAtpSendResponse answered a stale request");
            rt_ext_AtalkHAtpClose(sk);
        }
    }
}

int main(void) {
    /* Watchdog: three NBP lookups at 3 s each, three registers whose own
     * verify-lookup is another 3 s each, a handful of ATP calls with a 1 s
     * retransmit timer, plus the opens. A clean run is ~24 s. */
    alarm(120);

    A = rt_at_open(NULL);
    if (A == NULL) {
        if (errno == ENODEV || errno == EADDRNOTAVAIL || errno == EPERM ||
            errno == EAFNOSUPPORT) {
            fprintf(stderr, "SKIP: multicast unavailable (%s)\n", strerror(errno));
            return 77;
        }
        fprintf(stderr, "FAIL: rt_at_open(A): %s\n", strerror(errno));
        return 1;
    }
    rt_at_test_idle_hook(drive_a);   /* set BEFORE B opens: A must answer B's lapENQ */
    B = rt_at_open(NULL);
    if (B == NULL) {
        fprintf(stderr, "FAIL: rt_at_open(B): %s\n", strerror(errno));
        return 1;
    }

    test_nodes();
    test_nbp();
    test_atp();
    test_idle_wake();
    test_ext();

    if (a_sock >= 0) rt_at_atp_close(A, a_sock);
    rt_at_test_idle_hook(NULL);
    rt_at_close(B);
    rt_at_close(A);

    if (failed) {
        fprintf(stderr, "FAILED\n");
        return 1;
    }
    printf("OK\n");
    return 0;
}
