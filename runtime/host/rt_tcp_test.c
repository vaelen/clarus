/* runtime/host/rt_tcp_test.c -- hand-written C harness for the `connection`
 * type's TCP transport glue (2026-09-07 mactcp spec, Task 5:
 * runtime/host/rt_tcp.inc, #included at the bottom of rt.c). Mirrors
 * rt_serial_test.c's style: CHECK macro, "OK\n" on success, its own extern
 * prototypes (no rt_ext_* symbol is ever declared in rt.h -- see that file's
 * header comment for why).
 *
 * Compile + run by hand:
 *   cc -std=c99 -Wall -Werror -I runtime/host \
 *      runtime/host/rt_tcp_test.c runtime/host/rt.c -o /tmp/tcptest
 *   /tmp/tcptest
 * tests/hostrt/tcp.sh does exactly this via lib.sh's run_c_test.
 *
 * Everything runs on 127.0.0.1 against OS-chosen ephemeral ports, so no
 * fixed port number appears anywhere and this never collides with another
 * test (or another worktree) running at the same time. Eight scenarios:
 *
 *   1 connect      -- LsnOpen rejects port 0, then a real listener + a real
 *                     ActiveOpen meet: LsnPoll 1 / Poll 1 / LsnAccept.
 *   2 echo         -- 256 bytes client->server, then 5000 bytes back the
 *                     other way as one 4096 chunk plus one 904 chunk, the
 *                     second only issued once SendBusy has gone quiet. A
 *                     `received` event may deliver the payload in pieces,
 *                     so both directions accumulate rather than expecting
 *                     one event per send.
 *   3 close        -- Close half-closes, the peer sees event 3, and the
 *                     closer sees event 3 once the peer is gone.
 *   4 refused      -- a connect to a port nothing listens on is reported
 *                     ONCE, as the positive errno ECONNREFUSED (never a
 *                     value in 1..4, which are event codes), after which
 *                     the slot is idle.
 *   5 deny         -- LsnOpen is idempotent while already listening;
 *                     LsnDeny drops an accepted-but-unclaimed peer with a
 *                     reset rather than a graceful close.
 *   6 close deadline -- a Close toward a peer that never closes still
 *                     reports event 3, at the RT_TCP_CLOSE_SECS deadline.
 *                     This scenario alone is why the whole test takes
 *                     ~10 s; there is no way to observe a 10 s timer in
 *                     less than 10 s.
 *   7 close drains -- a Close with a Send remainder still queued defers
 *                     the shutdown(SHUT_WR): every byte handed to Send
 *                     arrives, in order, and EOF comes after them.
 *   8 close connecting -- a Close on a still-CONNECTING slot resets it
 *                     rather than leaving the connect in flight.
 *
 * main() runs 7 and 8 before 6, so a failure there is not stuck behind
 * scenario 6's 10 s deadline.
 */
#include "rt.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include <poll.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <netinet/in.h>
#include <arpa/inet.h>

extern int32_t rt_ext_TcpHInit(void);
extern int32_t rt_ext_TcpHCreate(int32_t slot);
extern int32_t rt_ext_TcpHActiveOpen(int32_t slot, int32_t ip, int32_t port);
extern int32_t rt_ext_TcpHPoll(int32_t slot);
extern int32_t rt_ext_TcpHRecvLen(int32_t slot);
extern void   *rt_ext_TcpHRecvPtr(int32_t slot);
extern int32_t rt_ext_TcpHRecvArm(int32_t slot);
extern int32_t rt_ext_TcpHSendBusy(int32_t slot);
extern int32_t rt_ext_TcpHSend(int32_t slot, void *p, int32_t n);
extern int32_t rt_ext_TcpHClose(int32_t slot);
extern void    rt_ext_TcpHRelease(int32_t slot);
extern int32_t rt_ext_TcpHLsnOpen(int32_t lsn, int32_t port);
extern int32_t rt_ext_TcpHLsnPoll(int32_t lsn);
extern int32_t rt_ext_TcpHLsnAccept(int32_t lsn, int32_t slot);
extern void    rt_ext_TcpHLsnDeny(int32_t lsn);
extern void    rt_ext_TcpHLsnClose(int32_t lsn);

#define LOOPBACK_IP 0x7f000001
/* Mirrors rt_tcp.inc's RT_TCP_CHUNK, which lives in that .inc and so is
 * not visible from this translation unit: the largest single Send. */
#define SEND_CHUNK 4096

static int failed = 0;
#define CHECK(cond, msg) \
    do { if (!(cond)) { fprintf(stderr, "FAIL: %s (%s:%d)\n", msg, __FILE__, __LINE__); failed = 1; } } while (0)

/* tick: the pump's own idle wait -- poll() with no fds is the portable
 * sub-second sleep, and it is what a caller of this waist does between
 * Poll passes. */
static void tick(int ms) { poll(NULL, 0, ms); }

/* bind_ephemeral: bind+listen a plain BSD socket on 127.0.0.1:0 (the OS
 * picks a free port) and report which port via getsockname. */
static int bind_ephemeral(int *portOut) {
    int fd;
    struct sockaddr_in addr;
    socklen_t alen = sizeof(addr);

    fd = socket(AF_INET, SOCK_STREAM, 0);
    if (fd < 0) return -1;
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    addr.sin_port = 0;
    if (bind(fd, (struct sockaddr *)&addr, sizeof(addr)) < 0 ||
        listen(fd, 4) < 0 ||
        getsockname(fd, (struct sockaddr *)&addr, &alen) < 0) {
        close(fd);
        return -1;
    }
    *portOut = ntohs(addr.sin_port);
    return fd;
}

/* free_port: a port number nothing is bound to -- bind one and drop it
 * again. Racy in principle, fine for a short-lived test on loopback. */
static int free_port(void) {
    int port = 0, fd = bind_ephemeral(&port);
    if (fd >= 0) close(fd);
    return port;
}

/* connect_to: a plain BLOCKING client socket connected to 127.0.0.1:port --
 * the raw peer scenario 5 has the listener deny. (Scenario 6's raw peer
 * goes the other way round: it accepts, so it uses bind_ephemeral.) */
static int connect_to(int port) {
    int fd;
    struct sockaddr_in addr;

    fd = socket(AF_INET, SOCK_STREAM, 0);
    if (fd < 0) return -1;
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    addr.sin_port = htons((uint16_t)port);
    if (connect(fd, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
        close(fd);
        return -1;
    }
    return fd;
}

/* The listener's port, opened by scenario 1 and reused (still listening)
 * by scenario 5's idempotent-reopen and deny checks. */
static int lsn_port;

/* ---- Scenario 1: listen + connect in one process ---- */
static void test_connect(void) {
    int i, sawLsn = 0, sawOpen = 0;

    CHECK(rt_ext_TcpHInit() == 0, "TcpHInit");
    CHECK(rt_ext_TcpHLsnOpen(0, 0) == EINVAL, "LsnOpen rejects port 0");
    lsn_port = free_port();
    CHECK(lsn_port > 0, "picked a port");
    CHECK(rt_ext_TcpHLsnOpen(0, lsn_port) == 0, "LsnOpen");
    CHECK(rt_ext_TcpHCreate(1) == 0, "Create slot 1");
    CHECK(rt_ext_TcpHActiveOpen(1, LOOPBACK_IP, lsn_port) == 0, "ActiveOpen slot 1");

    for (i = 0; i < 200 && !(sawLsn && sawOpen); i++) {
        if (!sawLsn && rt_ext_TcpHLsnPoll(0) == 1) sawLsn = 1;
        if (!sawOpen && rt_ext_TcpHPoll(1) == 1) sawOpen = 1;
        if (!(sawLsn && sawOpen)) tick(10);
    }
    CHECK(sawLsn, "LsnPoll reported a waiting peer");
    CHECK(sawOpen, "Poll reported event 1 (opened)");
    CHECK(rt_ext_TcpHCreate(2) == 0, "Create slot 2");
    CHECK(rt_ext_TcpHLsnAccept(0, 2) == 0, "LsnAccept into slot 2");
}

/* recv_all: pump `slot` (and `other`, so the sender's own chunk keeps
 * draining) until `want` bytes have been accumulated, re-arming after each
 * `received` event. Returns how many bytes actually arrived. */
static int32_t recv_all(int32_t slot, int32_t other, uint8_t *buf, int32_t want) {
    int32_t got = 0;
    int i;

    for (i = 0; i < 5000 && got < want; i++) {
        if (rt_ext_TcpHPoll(slot) == 2) {
            int32_t n = rt_ext_TcpHRecvLen(slot);
            CHECK(n > 0 && got + n <= want, "received chunk fits the expected total");
            if (n > 0 && got + n <= want) {
                memcpy(buf + got, rt_ext_TcpHRecvPtr(slot), (size_t)n);
                got += n;
            }
            rt_ext_TcpHRecvArm(slot);
            continue;   /* more may already be queued -- don't sleep on it */
        }
        rt_ext_TcpHPoll(other);
        tick(1);
    }
    return got;
}

/* ---- Scenario 2: echo both ways ---- */
static void test_echo(void) {
    uint8_t sweep[256], sweepGot[256], big[5000], bigGot[5000];
    int32_t got = 0;
    int i, sentTail = 0;

    for (i = 0; i < 256; i++) sweep[i] = (uint8_t)i;
    CHECK(rt_ext_TcpHSend(1, sweep, 256) == 0, "Send 256 client->server");
    CHECK(recv_all(2, 1, sweepGot, 256) == 256, "server received all 256");
    CHECK(memcmp(sweepGot, sweep, 256) == 0, "the 256-byte sweep is intact");

    /* 5000 bytes back the other way: one full chunk plus the remainder,
     * with the receiving slot pumped in the same loop so the sender's
     * socket buffer keeps draining. */
    for (i = 0; i < 5000; i++) big[i] = (uint8_t)(i * 7 + 3);
    CHECK(rt_ext_TcpHSend(2, big, 4096) == 0, "Send 4096 server->client");
    for (i = 0; i < 5000 && got < 5000; i++) {
        if (rt_ext_TcpHPoll(1) == 2) {
            int32_t n = rt_ext_TcpHRecvLen(1);
            CHECK(n > 0 && got + n <= 5000, "received chunk fits 5000");
            if (n > 0 && got + n <= 5000) {
                memcpy(bigGot + got, rt_ext_TcpHRecvPtr(1), (size_t)n);
                got += n;
            }
            rt_ext_TcpHRecvArm(1);
        }
        rt_ext_TcpHPoll(2);
        if (!sentTail && !rt_ext_TcpHSendBusy(2)) {
            CHECK(rt_ext_TcpHSend(2, big + 4096, 904) == 0, "Send the 904-byte tail");
            sentTail = 1;
        }
        if (got < 5000) tick(1);
    }
    CHECK(sentTail, "the tail chunk went out once SendBusy cleared");
    CHECK(got == 5000, "client received all 5000");
    CHECK(memcmp(bigGot, big, 5000) == 0, "the 5000-byte payload is intact");
}

/* ---- Scenario 3: half-close and drain ---- */
static void test_close(void) {
    int i, sawPeer = 0, sawSelf = 0;

    CHECK(rt_ext_TcpHClose(1) == 0, "Close slot 1");
    for (i = 0; i < 200 && !sawPeer; i++) {
        if (rt_ext_TcpHPoll(2) == 3) sawPeer = 1; else tick(10);
    }
    CHECK(sawPeer, "the peer slot saw event 3 (closed)");
    rt_ext_TcpHRelease(2);
    /* The peer released first, so slot 1's own event 3 is the FIN coming
     * back rather than the RT_TCP_CLOSE_SECS deadline -- but allow the
     * deadline's worth of budget either way. */
    for (i = 0; i < 1200 && !sawSelf; i++) {
        if (rt_ext_TcpHPoll(1) == 3) sawSelf = 1; else tick(10);
    }
    CHECK(sawSelf, "the closing slot saw event 3");
    rt_ext_TcpHRelease(1);
}

/* ---- Scenario 4: refused connect ---- */
static void test_refused(void) {
    int dead = free_port(), i;
    int32_t ev = 0;

    CHECK(dead > 0, "picked a dead port");
    CHECK(rt_ext_TcpHCreate(3) == 0, "Create slot 3");
    CHECK(rt_ext_TcpHActiveOpen(3, LOOPBACK_IP, dead) == 0, "ActiveOpen to a dead port succeeds");
    for (i = 0; i < 200 && ev == 0; i++) {
        ev = rt_ext_TcpHPoll(3);
        if (ev == 0) tick(10);
    }
    CHECK(ev == ECONNREFUSED, "Poll reports the failed open as ECONNREFUSED");
    CHECK(ev > 4, "the errno can never be mistaken for an event code");
    CHECK(rt_ext_TcpHPoll(3) == 0, "the slot is idle after the single report");
}

/* ---- Scenario 5: deny ---- */
static void test_deny(void) {
    int client, i;
    int32_t ev = 0;
    ssize_t n;
    char b[1];

    CHECK(rt_ext_TcpHLsnOpen(0, lsn_port) == 0, "LsnOpen is a no-op while already listening");
    client = connect_to(lsn_port);
    CHECK(client >= 0, "raw client connected");
    for (i = 0; i < 200 && ev != 1; i++) {
        ev = rt_ext_TcpHLsnPoll(0);
        if (ev != 1) tick(10);
    }
    CHECK(ev == 1, "LsnPoll reported the raw client");
    rt_ext_TcpHLsnDeny(0);
    n = client >= 0 ? recv(client, b, sizeof b, 0) : 0;
    CHECK(n == 0 || (n < 0 && errno == ECONNRESET), "the denied client sees EOF or a reset");
    if (client >= 0) close(client);
    rt_ext_TcpHLsnClose(0);
    CHECK(rt_ext_TcpHLsnPoll(0) < 0, "a closed listener polls dead (negative errno)");
}

/* ---- Scenario 7 (review fix round 1): Close drains a pending remainder ----
 * Close must not shutdown(SHUT_WR) while a Send remainder is still queued:
 * the next flush would fail EPIPE and those bytes would be lost behind a
 * perfectly innocent-looking event 3. Getting a remainder at all takes a
 * peer that never reads -- keep Sending 4096-byte chunks until its receive
 * buffer and our send buffer are both full and SendBusy latches 1. Then
 * Close, then let the peer read: every byte handed to Send must arrive, in
 * order, and EOF must come after them rather than instead of them. */
static void test_close_drains_pending(void) {
    uint8_t chunk[SEND_CHUNK], rbuf[65536];
    int srv, peer = -1, port = 0, i;
    int32_t ev = 0, handed = 0, got = 0;
    int eof = 0, bad = 0;

    for (i = 0; i < SEND_CHUNK; i++) chunk[i] = (uint8_t)i;
    srv = bind_ephemeral(&port);
    CHECK(srv >= 0, "drain peer listener");
    if (srv < 0) return;
    fcntl(srv, F_SETFL, fcntl(srv, F_GETFL, 0) | O_NONBLOCK);
    CHECK(rt_ext_TcpHCreate(5) == 0, "Create slot 5");
    CHECK(rt_ext_TcpHActiveOpen(5, LOOPBACK_IP, port) == 0, "ActiveOpen slot 5");
    for (i = 0; i < 200 && (peer < 0 || ev != 1); i++) {
        if (peer < 0) peer = accept(srv, NULL, NULL);
        if (ev != 1) ev = rt_ext_TcpHPoll(5);
        if (peer < 0 || ev != 1) tick(10);
    }
    CHECK(peer >= 0 && ev == 1, "slot 5 opened to a peer that will not read");
    if (peer < 0 || ev != 1) { close(srv); return; }
    fcntl(peer, F_SETFL, fcntl(peer, F_GETFL, 0) | O_NONBLOCK);

    /* The peer reads nothing in this loop, so it terminates on a full pipe. */
    for (i = 0; i < 4000 && !rt_ext_TcpHSendBusy(5); i++) {
        if (rt_ext_TcpHSend(5, chunk, SEND_CHUNK) != 0) break;
        handed += SEND_CHUNK;
        rt_ext_TcpHPoll(5);
    }
    CHECK(rt_ext_TcpHSendBusy(5) == 1, "a Send remainder is pending");
    CHECK(handed > 0, "bytes were handed to Send");
    CHECK(rt_ext_TcpHClose(5) == 0, "Close with a remainder pending");

    /* Now drain from the peer's side. The deferred shutdown only fires
     * once the remainder is out, so EOF must be the LAST thing seen. */
    for (i = 0; i < 20000 && !eof; i++) {
        ssize_t n;
        rt_ext_TcpHPoll(5);
        n = recv(peer, rbuf, sizeof rbuf, 0);
        if (n > 0) {
            ssize_t k;
            for (k = 0; k < n; k++) {
                if (rbuf[k] != (uint8_t)((got + k) % SEND_CHUNK)) bad = 1;
            }
            got += (int32_t)n;
        } else if (n == 0) {
            eof = 1;
        } else if (errno != EAGAIN && errno != EWOULDBLOCK) {
            break;      /* a reset here is exactly the bug under test */
        } else {
            tick(1);
        }
    }
    CHECK(got == handed, "every byte handed to Send arrived after the Close");
    CHECK(!bad, "the drained bytes are in order and intact");
    CHECK(eof, "the peer saw EOF, and only after the last byte");
    rt_ext_TcpHRelease(5);
    if (peer >= 0) close(peer);
    close(srv);
}

/* ---- Scenario 8 (review fix round 1): Close while still CONNECTING ----
 * There is no write side to half-close yet, so Close resets the slot. The
 * bug it guards against is the opposite: a silent no-op that leaves the
 * connect in flight and later reports event 1 (or an errno) on a
 * connection the caller already walked away from. */
static void test_close_while_connecting(void) {
    int dead = free_port(), i;

    CHECK(dead > 0, "picked a dead port");
    CHECK(rt_ext_TcpHCreate(6) == 0, "Create slot 6");
    CHECK(rt_ext_TcpHActiveOpen(6, LOOPBACK_IP, dead) == 0, "ActiveOpen slot 6");
    CHECK(rt_ext_TcpHClose(6) == 0, "Close while still CONNECTING");
    /* Poll well past the point the refusal would otherwise have landed
     * (scenario 4 sees ECONNREFUSED within a pass or two): stay silent. */
    for (i = 0; i < 40; i++) {
        int32_t ev = rt_ext_TcpHPoll(6);
        CHECK(ev == 0, "the abandoned slot stays idle -- never event 1, never an errno");
        if (ev != 0) break;
        tick(5);
    }
}

/* ---- Scenario 6: close deadline ---- */
static void test_close_deadline(void) {
    int srv, peer = -1, port = 0, i;
    int32_t ev = 0;
    struct timeval t0, t1;
    double dt;

    srv = bind_ephemeral(&port);
    CHECK(srv >= 0, "raw peer listener");
    if (srv < 0) return;
    fcntl(srv, F_SETFL, fcntl(srv, F_GETFL, 0) | O_NONBLOCK);
    CHECK(rt_ext_TcpHCreate(4) == 0, "Create slot 4");
    CHECK(rt_ext_TcpHActiveOpen(4, LOOPBACK_IP, port) == 0, "ActiveOpen to the raw peer");
    for (i = 0; i < 200 && (peer < 0 || ev != 1); i++) {
        if (peer < 0) peer = accept(srv, NULL, NULL);
        if (ev != 1) ev = rt_ext_TcpHPoll(4);
        if (peer < 0 || ev != 1) tick(10);
    }
    CHECK(peer >= 0, "the raw peer accepted");
    CHECK(ev == 1, "slot 4 opened");

    /* The peer never closes and never sends: only the deadline can end
     * this, and it must actually take the full RT_TCP_CLOSE_SECS. */
    CHECK(rt_ext_TcpHClose(4) == 0, "Close toward a peer that never closes");
    gettimeofday(&t0, NULL);
    ev = 0;
    for (i = 0; i < 1300 && ev != 3; i++) {
        ev = rt_ext_TcpHPoll(4);
        if (ev != 3) tick(10);
    }
    gettimeofday(&t1, NULL);
    dt = (double)(t1.tv_sec - t0.tv_sec) + (double)(t1.tv_usec - t0.tv_usec) / 1e6;
    CHECK(ev == 3, "the close deadline reported event 3");
    CHECK(dt >= 9.0, "the deadline did not fire early");
    CHECK(dt <= 12.0, "the deadline did not fire late");
    rt_ext_TcpHRelease(4);
    if (peer >= 0) close(peer);
    close(srv);
}

int main(void) {
    /* Every wait above is a bounded poll() loop except scenario 5's one
     * blocking recv() on the denied client; 120 s is far above the honest
     * worst-case sum (~70 s, of which scenario 6's deadline is 13 s and
     * scenario 7's drain budget is 20 s) and exists only so a pathological
     * hang is a failure, not a wedged test run. A clean run takes ~10 s,
     * essentially all of it scenario 6.
     *
     * Scenarios 7 and 8 (the review fix round) run BEFORE 6 so that a
     * regression in either surfaces in under a second instead of behind
     * the 10-second deadline wait. */
    alarm(120);

    test_connect();
    test_echo();
    test_close();
    test_refused();
    test_deny();
    test_close_drains_pending();
    test_close_while_connecting();
    test_close_deadline();

    if (failed) {
        fprintf(stderr, "FAILED\n");
        return 1;
    }
    printf("OK\n");
    return 0;
}
