/* runtime/host/rt_tcp.inc -- host BSD-socket glue for the `connection`
 * type's TCP transport (MacTCP phase, Task 5). #included at the bottom of
 * rt.c after rt_atalk.inc. The native twin is runtime/clarus/tcp_68k.cla
 * (MacTCP through .IPP); both answer the same waist tcp.cla calls, listed
 * in docs/superpowers/plans/2026-09-07-mactcp.md.
 *
 * Every fd is O_NONBLOCK. Poll is one pass, no select: the CLI lifetime
 * pump calls it every iteration. Errors are positive errnos, 0 = ok;
 * errno values 1..4 collide with the event codes so they are reported
 * as EIO. rt_conn_ignore_sigpipe() is rt_serial.inc's, visible because
 * rt.c includes that file first -- a send() into a peer that already went
 * away must return EPIPE, not kill the process.
 *
 * Event codes (tcp.cla's own): 0 none, 1 opened, 2 received, 3 closed,
 * 4 sent. Poll reports a FAILED open once, as a positive errno, after
 * which the slot is idle. LsnPoll is the mirror image: 0 nothing, 1 a
 * peer is waiting, and a NEGATIVE errno for a dead listener (the waist
 * contract, so a caller can tell "no peer yet" from "this listener is
 * finished" without a second call).
 *
 * Close's two rules (spec 4.1, "pending sends drain first, then the
 * graceful close"), both review fixes over the planned design:
 *   - A Close with an unflushed Send remainder enters CLOSING and starts
 *     the deadline AT ONCE, but DEFERS the shutdown(SHUT_WR) until Poll's
 *     flush has emptied the buffer (shutPending). Shutting the write side
 *     down with bytes still queued makes the next flush fail EPIPE and
 *     loses them, reporting 3 as though the data had gone out. The sent
 *     event (4) still fires exactly once, when the remainder drains; if
 *     the peer never reads, the deadline ends the slot anyway.
 *   - A Close on a CONNECTING slot RESETS it: there is no write side to
 *     half-close yet, and leaving the connect in flight would later hand
 *     the caller event 1 on a connection it had already abandoned.
 */
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <poll.h>
#include <string.h>
#include <time.h>
#include <sys/time.h>

/* rt_ext_TcpTickCount: host twin of tcp.cla's runtime-private
 * TcpTickCount extern (_TickCount, 0xA975). Private name because a
 * plain `TickCount` collides with toolbox/events.cla's identical
 * clause under `--rtbake --testapi`; the tick source is the same one
 * rt_ext_TickCount (rt_ext_host.inc, included by rt.c first) uses. */
int32_t rt_ext_TcpTickCount(void) { return rt_ext_TickCount(); }

#define RT_TCP_SLOTS 8
#define RT_TCP_LSNS  2
#define RT_TCP_CHUNK 4096
#define RT_TCP_CLOSE_SECS 10

enum { RT_TCP_IDLE = 0, RT_TCP_CONNECTING, RT_TCP_OPEN, RT_TCP_CLOSING };

typedef struct {
    int fd;
    int state;
    uint8_t rcv[RT_TCP_CHUNK];
    int32_t rcvLen;          /* bytes in rcv after a received event */
    uint8_t snd[RT_TCP_CHUNK];
    int32_t sndLen, sndOff;  /* unwritten remainder of the last chunk */
    int sentPending;         /* report event 4 once after the chunk drains */
    int shutPending;         /* CLOSING: shutdown(SHUT_WR) owed once snd drains */
    time_t closeDeadline;    /* RT_TCP_CLOSING: report 3 at the latest here */
} rt_tcp_slot;

typedef struct { int fd; int ready; } rt_tcp_lsn;   /* ready: accepted fd, or -1 */

/* Both tables carry their -1 fds from the static initializer rather than
 * from TcpHInit, so that a stray entry point reached before Init (or in a
 * build whose Clarus side forgot it) can never close(0) via rt_tcp_reset.
 * Init is then only the SIGPIPE guard. */
static rt_tcp_slot rt_tcp_slots[RT_TCP_SLOTS] = {
    { .fd = -1 }, { .fd = -1 }, { .fd = -1 }, { .fd = -1 },
    { .fd = -1 }, { .fd = -1 }, { .fd = -1 }, { .fd = -1 }
};
static rt_tcp_lsn rt_tcp_lsns[RT_TCP_LSNS] = {
    { .fd = -1, .ready = -1 }, { .fd = -1, .ready = -1 }
};

static int32_t rt_tcp_err(void) { int e = errno; return e > 4 ? e : EIO; }
static void rt_tcp_nonblock(int fd) { int f = fcntl(fd, F_GETFL, 0); fcntl(fd, F_SETFL, f | O_NONBLOCK); }
static int rt_tcp_slot_ok(int32_t s) { return s >= 0 && s < RT_TCP_SLOTS; }
static int rt_tcp_lsn_ok(int32_t l) { return l >= 0 && l < RT_TCP_LSNS; }
static void rt_tcp_reset(rt_tcp_slot *s) { if (s->fd >= 0) close(s->fd); memset(s, 0, sizeof *s); s->fd = -1; }

int32_t rt_ext_TcpHInit(void) {
    rt_conn_ignore_sigpipe();
    return 0;
}
int32_t rt_ext_TcpHCreate(int32_t slot) { return rt_tcp_slot_ok(slot) ? 0 : EINVAL; }

int32_t rt_ext_TcpHActiveOpen(int32_t slot, int32_t ip, int32_t port) {
    struct sockaddr_in sa; int fd;
    if (!rt_tcp_slot_ok(slot) || port <= 0 || port > 65535) return EINVAL;
    rt_tcp_reset(&rt_tcp_slots[slot]);
    fd = socket(AF_INET, SOCK_STREAM, 0);
    if (fd < 0) return rt_tcp_err();
    rt_tcp_nonblock(fd);
    memset(&sa, 0, sizeof sa);
    sa.sin_family = AF_INET; sa.sin_addr.s_addr = htonl((uint32_t)ip); sa.sin_port = htons((uint16_t)port);
    if (connect(fd, (struct sockaddr *)&sa, sizeof sa) < 0 && errno != EINPROGRESS) { int32_t e = rt_tcp_err(); close(fd); return e; }
    rt_tcp_slots[slot].fd = fd; rt_tcp_slots[slot].state = RT_TCP_CONNECTING;
    return 0;
}

/* rt_tcp_flush: write the pending remainder; 0 ok, errno on a hard error. */
static int32_t rt_tcp_flush(rt_tcp_slot *s) {
    while (s->sndOff < s->sndLen) {
        ssize_t n = send(s->fd, s->snd + s->sndOff, (size_t)(s->sndLen - s->sndOff), 0);
        if (n < 0) { if (errno == EAGAIN || errno == EWOULDBLOCK) return 0; return rt_tcp_err(); }
        s->sndOff += (int32_t)n;
    }
    if (s->sndLen > 0) { s->sndLen = s->sndOff = 0; s->sentPending = 1; }
    return 0;
}

int32_t rt_ext_TcpHPoll(int32_t slot) {
    rt_tcp_slot *s; struct pollfd p; int so_err = 0; socklen_t sl = sizeof so_err; ssize_t n;
    if (!rt_tcp_slot_ok(slot)) return EINVAL;
    s = &rt_tcp_slots[slot];
    if (s->state == RT_TCP_IDLE) return 0;
    if (s->state == RT_TCP_CONNECTING) {
        /* POLLHUP/POLLERR come back regardless of `events`, which is how a
         * refused connect surfaces here at all: poll() counts the fd, and
         * SO_ERROR then says why. */
        p.fd = s->fd; p.events = POLLOUT; p.revents = 0;
        if (poll(&p, 1, 0) <= 0) return 0;
        if (getsockopt(s->fd, SOL_SOCKET, SO_ERROR, &so_err, &sl) < 0 || so_err != 0) {
            int32_t e = so_err > 4 ? so_err : EIO; rt_tcp_reset(s); return e;
        }
        s->state = RT_TCP_OPEN; return 1;
    }
    /* OPEN or CLOSING: drain sends first, then one receive. */
    if (s->sndLen > 0) { int32_t e = rt_tcp_flush(s); if (e) { rt_tcp_reset(s); return 3; } }
    /* The remainder is out: only now is it safe to half-close (see the
     * header's Close rules -- shutting down earlier loses those bytes). */
    if (s->shutPending && s->sndLen == 0) { s->shutPending = 0; shutdown(s->fd, SHUT_WR); }
    if (s->sentPending) { s->sentPending = 0; return 4; }
    if (s->rcvLen > 0) return 0;   /* the last received event is not consumed yet */
    n = recv(s->fd, s->rcv, sizeof s->rcv, 0);
    if (n > 0) { s->rcvLen = (int32_t)n; return 2; }
    if (n == 0 || (errno != EAGAIN && errno != EWOULDBLOCK)) { rt_tcp_reset(s); return 3; }
    if (s->state == RT_TCP_CLOSING && time(NULL) >= s->closeDeadline) { rt_tcp_reset(s); return 3; }
    return 0;
}
int32_t rt_ext_TcpHRecvLen(int32_t slot) { return rt_tcp_slot_ok(slot) ? rt_tcp_slots[slot].rcvLen : 0; }
void   *rt_ext_TcpHRecvPtr(int32_t slot) { return rt_tcp_slot_ok(slot) ? rt_tcp_slots[slot].rcv : NULL; }
int32_t rt_ext_TcpHRecvArm(int32_t slot) { if (rt_tcp_slot_ok(slot)) rt_tcp_slots[slot].rcvLen = 0; return 0; }
int32_t rt_ext_TcpHSendBusy(int32_t slot) { return rt_tcp_slot_ok(slot) && rt_tcp_slots[slot].sndLen > 0; }
int32_t rt_ext_TcpHSend(int32_t slot, void *p, int32_t n) {
    rt_tcp_slot *s;
    if (!rt_tcp_slot_ok(slot) || n <= 0 || n > RT_TCP_CHUNK) return EINVAL;
    s = &rt_tcp_slots[slot];
    if (s->state != RT_TCP_OPEN && s->state != RT_TCP_CLOSING) return ENOTCONN;
    if (s->sndLen > 0) return EBUSY;
    memcpy(s->snd, p, (size_t)n); s->sndLen = n; s->sndOff = 0;
    return rt_tcp_flush(s);
}
int32_t rt_ext_TcpHClose(int32_t slot) {
    rt_tcp_slot *s;
    if (!rt_tcp_slot_ok(slot)) return EINVAL;
    s = &rt_tcp_slots[slot];
    if (s->state == RT_TCP_CONNECTING) { rt_tcp_reset(s); return 0; }
    if (s->state != RT_TCP_OPEN) return 0;
    s->state = RT_TCP_CLOSING; s->closeDeadline = time(NULL) + RT_TCP_CLOSE_SECS;
    if (s->sndLen > 0) s->shutPending = 1;   /* deferred: Poll shuts down once it drains */
    else shutdown(s->fd, SHUT_WR);
    return 0;
}
void rt_ext_TcpHRelease(int32_t slot) { if (rt_tcp_slot_ok(slot)) rt_tcp_reset(&rt_tcp_slots[slot]); }

int32_t rt_ext_TcpHLsnOpen(int32_t lsn, int32_t port) {
    int fd, yes = 1; struct sockaddr_in sa;
    if (!rt_tcp_lsn_ok(lsn) || port <= 0 || port > 65535) return EINVAL;
    if (rt_tcp_lsns[lsn].fd >= 0) return 0;      /* already listening: re-arm is a no-op */
    fd = socket(AF_INET, SOCK_STREAM, 0);
    if (fd < 0) return rt_tcp_err();
    setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof yes);
    memset(&sa, 0, sizeof sa);
    sa.sin_family = AF_INET; sa.sin_addr.s_addr = htonl(INADDR_ANY); sa.sin_port = htons((uint16_t)port);
    if (bind(fd, (struct sockaddr *)&sa, sizeof sa) < 0 || listen(fd, 4) < 0) { int32_t e = rt_tcp_err(); close(fd); return e; }
    rt_tcp_nonblock(fd);
    rt_tcp_lsns[lsn].fd = fd; rt_tcp_lsns[lsn].ready = -1;
    return 0;
}
int32_t rt_ext_TcpHLsnPoll(int32_t lsn) {
    int c;
    if (!rt_tcp_lsn_ok(lsn) || rt_tcp_lsns[lsn].fd < 0) return -EINVAL;
    if (rt_tcp_lsns[lsn].ready >= 0) return 1;
    c = accept(rt_tcp_lsns[lsn].fd, NULL, NULL);
    if (c < 0) return (errno == EAGAIN || errno == EWOULDBLOCK || errno == EINTR) ? 0 : -rt_tcp_err();
    rt_tcp_nonblock(c); rt_tcp_lsns[lsn].ready = c;
    return 1;
}
int32_t rt_ext_TcpHLsnAccept(int32_t lsn, int32_t slot) {
    if (!rt_tcp_lsn_ok(lsn) || !rt_tcp_slot_ok(slot) || rt_tcp_lsns[lsn].ready < 0) return EINVAL;
    rt_tcp_reset(&rt_tcp_slots[slot]);
    rt_tcp_slots[slot].fd = rt_tcp_lsns[lsn].ready; rt_tcp_slots[slot].state = RT_TCP_OPEN;
    rt_tcp_lsns[lsn].ready = -1;
    return 0;
}
void rt_ext_TcpHLsnDeny(int32_t lsn) {
    if (rt_tcp_lsn_ok(lsn) && rt_tcp_lsns[lsn].ready >= 0) {
        struct linger lg = { 1, 0 };   /* RST, not FIN: "the client sees a reset" */
        setsockopt(rt_tcp_lsns[lsn].ready, SOL_SOCKET, SO_LINGER, &lg, sizeof lg);
        close(rt_tcp_lsns[lsn].ready); rt_tcp_lsns[lsn].ready = -1;
    }
}
void rt_ext_TcpHLsnClose(int32_t lsn) {
    if (!rt_tcp_lsn_ok(lsn)) return;
    rt_ext_TcpHLsnDeny(lsn);
    if (rt_tcp_lsns[lsn].fd >= 0) { close(rt_tcp_lsns[lsn].fd); rt_tcp_lsns[lsn].fd = -1; }
}
