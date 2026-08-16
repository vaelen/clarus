/* runtime/host/rt_serial.inc -- host TCP glue for the `connection` type's
 * serial transport (2026-08-15 serial-connection spec, Task 4). #included
 * at the bottom of rt.c, exactly like rt_ser.inc above it -- never a
 * separate translation unit. Host lane only: the native 68k lane's real
 * Device Manager glue is conn_68k.cla (Task 6), a Clarus-only file with no
 * C counterpart here.
 *
 * The whole point is Snow's own `--serial-bridge-a/-b tcp:PORT` idea,
 * restated as this runtime's own transport: a Clarus program that opens
 * `serial "modem:9600"` on the host maps port -> TCP endpoint via an env
 * var instead of touching a real SCC. Two ports (portIdx 0 "modem" / 1
 * "printer"), read from CLARUS_SERIAL_MODEM / CLARUS_SERIAL_PRINTER, each
 * holding one of:
 *   "listen:PORT"      -- bind+listen (nonblocking); accept is deferred to
 *                          the first rt_ext_ConnHAvail poll, so open itself
 *                          never blocks waiting for a peer.
 *   "connect:HOST:PORT" -- ordinary blocking connect (fine: open happens
 *                          once, not on every pump pass).
 * Unset or unparseable -> rt_ext_ConnHOpen returns a nonzero code, which
 * conn.cla surfaces verbatim as the `failed` event's error code -- no
 * panic, per spec ("environmental failures are events").
 *
 * conn_c.cla's own six rtConnDev* waist functions are thin wrappers over
 * the seven rt_ext_ConnH* externs declared there (ConnH family prefix,
 * see ser.cla's own header comment for why runtime externs need one at
 * all); baud is accepted by rtConnDevOpen but never reaches here -- TCP
 * has no baud rate, the host lane ignores it exactly as the spec says.
 *
 * fd blocking discipline (deliberately simple): the LISTEN fd alone is
 * O_NONBLOCK, so ConnHAvail's accept() poll never blocks the pump when no
 * peer has connected yet. Every OTHER fd (an accepted client, or a
 * connect-mode socket) stays plain blocking for its whole life --
 * ConnHReadByte is only ever called after ConnHAvail confirmed bytes are
 * already waiting (so recv() can't block), and ConnHWrite's "loop send()
 * to completion" is then free to be a genuinely blocking loop with no
 * EAGAIN/retry dance. ConnHGone's peek uses MSG_DONTWAIT explicitly since
 * IT must never block regardless of the fd's own mode.
 */
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <sys/select.h>
#include <netinet/in.h>
#include <netdb.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <signal.h>
#include <stdlib.h>
#include <string.h>

#define RT_CONN_MAX 4

typedef struct {
    int fd;         /* -1 = closed/never opened */
    int listening;  /* 1 = fd is a listen socket, accept still pending */
} rt_conn_slot_t;

static rt_conn_slot_t rt_conn_slots[RT_CONN_MAX] = {
    { -1, 0 }, { -1, 0 }, { -1, 0 }, { -1, 0 }
};

static int rt_conn_slot_ok(int32_t slot) {
    return slot >= 0 && slot < RT_CONN_MAX;
}

/* rt_conn_listen: bind+listen on port, nonblocking, backlog 1 (a serial
 * line has exactly one peer). Returns the fd, or -1 on any failure. */
static int rt_conn_listen(int port) {
    int fd = socket(AF_INET, SOCK_STREAM, 0);
    if (fd < 0) return -1;
    int yes = 1;
    setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(yes));
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = htonl(INADDR_ANY);
    addr.sin_port = htons((uint16_t)port);
    if (bind(fd, (struct sockaddr *)&addr, sizeof(addr)) != 0 || listen(fd, 1) != 0) {
        close(fd);
        return -1;
    }
    int flags = fcntl(fd, F_GETFL, 0);
    fcntl(fd, F_SETFL, flags | O_NONBLOCK);
    return fd;
}

/* rt_conn_connect: blocking connect to host:port (getaddrinfo, tries each
 * candidate address until one connects). Returns the fd, or -1. */
static int rt_conn_connect(const char *host, int port) {
    char portbuf[16];
    struct addrinfo hints, *res, *rp;
    int fd = -1;

    snprintf(portbuf, sizeof(portbuf), "%d", port);
    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    if (getaddrinfo(host, portbuf, &hints, &res) != 0) return -1;
    for (rp = res; rp != NULL; rp = rp->ai_next) {
        fd = socket(rp->ai_family, rp->ai_socktype, rp->ai_protocol);
        if (fd < 0) continue;
        if (connect(fd, rp->ai_addr, rp->ai_addrlen) == 0) break;
        close(fd);
        fd = -1;
    }
    freeaddrinfo(res);
    return fd;
}

/* rt_conn_ignore_sigpipe: one-time process-wide SIGPIPE suppression
 * (review fix, Task 4 follow-up). Without this, ConnHWrite's send() to a
 * peer that already closed its end raises SIGPIPE, which terminates the
 * whole process by default -- the BBS's routine "user hung up mid-write"
 * case, not an exceptional one. SIG_IGN here (rather than SO_NOSIGPIPE
 * per fd, the macOS-only alternative) is portable to both build targets
 * this runtime cares about (macOS/BSD and Linux) in one line; every
 * send()/write() in the process silently returns EPIPE instead of
 * signaling from this point on, which is exactly what ConnHWrite already
 * checks for via its `k <= 0` test. Guarded so a slot's Nth open doesn't
 * re-signal(); called from ConnHOpen since that's the one glue entry
 * point guaranteed to run before any ConnHWrite ever could. */
static void rt_conn_ignore_sigpipe(void) {
    static int done = 0;
    if (!done) {
        signal(SIGPIPE, SIG_IGN);
        done = 1;
    }
}

/* rt_ext_ConnHOpen: parses CLARUS_SERIAL_MODEM (portIdx 0) /
 * CLARUS_SERIAL_PRINTER (portIdx 1), opens the slot per the spec above.
 * Returns 0 on success, else a nonzero code (bare errno when one is
 * available, 1 for a parse failure with no syscall involved). */
int32_t rt_ext_ConnHOpen(int32_t slot, int32_t portIdx) {
    const char *spec;
    int fd;

    rt_conn_ignore_sigpipe();
    if (!rt_conn_slot_ok(slot)) return 1;
    if (portIdx == 0) {
        spec = getenv("CLARUS_SERIAL_MODEM");
    } else if (portIdx == 1) {
        spec = getenv("CLARUS_SERIAL_PRINTER");
    } else {
        spec = NULL;
    }
    if (spec == NULL) return 1;

    if (strncmp(spec, "listen:", 7) == 0) {
        int port = atoi(spec + 7);
        if (port <= 0) return 1;
        fd = rt_conn_listen(port);
        if (fd < 0) return errno != 0 ? errno : 1;
        rt_conn_slots[slot].fd = fd;
        rt_conn_slots[slot].listening = 1;
        return 0;
    }
    if (strncmp(spec, "connect:", 8) == 0) {
        const char *rest = spec + 8;
        const char *colon = strrchr(rest, ':');
        char host[256];
        size_t hlen;
        int port;

        if (colon == NULL) return 1;
        hlen = (size_t)(colon - rest);
        if (hlen == 0 || hlen >= sizeof(host)) return 1;
        memcpy(host, rest, hlen);
        host[hlen] = '\0';
        port = atoi(colon + 1);
        if (port <= 0) return 1;
        fd = rt_conn_connect(host, port);
        if (fd < 0) return errno != 0 ? errno : 1;
        rt_conn_slots[slot].fd = fd;
        rt_conn_slots[slot].listening = 0;
        return 0;
    }
    return 1; /* garbled: neither listen: nor connect: */
}

/* rt_ext_ConnHAvail: accepts a pending client first (if still listening),
 * then reports bytes ready via FIONREAD. 0 whenever there's genuinely
 * nothing to read yet (including "still listening, no peer"). */
int32_t rt_ext_ConnHAvail(int32_t slot) {
    rt_conn_slot_t *s;
    int n;

    if (!rt_conn_slot_ok(slot)) return 0;
    s = &rt_conn_slots[slot];
    if (s->fd < 0) return 0;
    if (s->listening) {
        int c = accept(s->fd, NULL, NULL);
        if (c < 0) return 0; /* no peer yet */
        close(s->fd);
        s->fd = c;
        s->listening = 0;
    }
    n = 0;
    if (ioctl(s->fd, FIONREAD, &n) != 0) return 0;
    return (int32_t)n;
}

/* rt_ext_ConnHReadByte: next byte, 0-255. Only ever called right after
 * ConnHAvail reported > 0, so this can't block. */
int32_t rt_ext_ConnHReadByte(int32_t slot) {
    unsigned char b;
    ssize_t n;

    if (!rt_conn_slot_ok(slot) || rt_conn_slots[slot].fd < 0) return 0;
    n = recv(rt_conn_slots[slot].fd, &b, 1, 0);
    if (n <= 0) return 0;
    return (int32_t)b;
}

/* rt_ext_ConnHWrite: loops send() to completion (the fd is plain blocking
 * -- see the header comment). Returns 0 on success, nonzero on any
 * send failure (peer gone is then caught on the next ConnHGone poll).
 * SIGPIPE is neutralized process-wide by rt_conn_ignore_sigpipe (called
 * from ConnHOpen, guaranteed to have run before this can) -- a send() to
 * an already-closed peer fails with EPIPE here, `k <= 0`, same as any
 * other write failure, instead of killing the process. */
int32_t rt_ext_ConnHWrite(int32_t slot, void *p, int32_t n) {
    const unsigned char *buf;
    int32_t sent;
    ssize_t k;

    if (!rt_conn_slot_ok(slot)) return 1;
    if (rt_conn_slots[slot].fd < 0 || rt_conn_slots[slot].listening) return 1;
    buf = (const unsigned char *)p;
    sent = 0;
    while (sent < n) {
        k = send(rt_conn_slots[slot].fd, buf + sent, (size_t)(n - sent), 0);
        if (k <= 0) return 1;
        sent += (int32_t)k;
    }
    return 0;
}

/* rt_ext_ConnHClose: idempotent -- closes the fd (if any) and resets the
 * slot. Callable on an already-closed slot (conn.cla's own rtConnClose is
 * idempotent; this is its device-level half). */
void rt_ext_ConnHClose(int32_t slot) {
    if (!rt_conn_slot_ok(slot)) return;
    if (rt_conn_slots[slot].fd >= 0) close(rt_conn_slots[slot].fd);
    rt_conn_slots[slot].fd = -1;
    rt_conn_slots[slot].listening = 0;
}

/* rt_ext_ConnHGone: orderly peer close, detected the standard way -- a
 * MSG_PEEK recv returning exactly 0. MSG_DONTWAIT is mandatory here
 * regardless of the fd's own blocking mode: this call must never block.
 * A still-listening slot (no peer yet) isn't "gone", just not there. */
int32_t rt_ext_ConnHGone(int32_t slot) {
    unsigned char b;
    ssize_t n;

    if (!rt_conn_slot_ok(slot)) return 0;
    if (rt_conn_slots[slot].fd < 0 || rt_conn_slots[slot].listening) return 0;
    n = recv(rt_conn_slots[slot].fd, &b, 1, MSG_PEEK | MSG_DONTWAIT);
    if (n == 0) return 1;
    if (n < 0 && errno != EAGAIN && errno != EWOULDBLOCK) return 1;
    return 0;
}

/* rt_ext_ConnHIdle: select()-with-timeout across every open slot's fd, so
 * Task 5's host pump loop blocks efficiently instead of spinning. Plain
 * usleep when no slot is open at all (select() with an empty fd_set and a
 * timeout is portable but this reads more plainly). */
void rt_ext_ConnHIdle(int32_t ms) {
    fd_set rfds;
    struct timeval tv;
    int maxfd;
    int i;
    int any;

    FD_ZERO(&rfds);
    maxfd = -1;
    any = 0;
    for (i = 0; i < RT_CONN_MAX; i++) {
        int fd = rt_conn_slots[i].fd;
        if (fd >= 0) {
            FD_SET(fd, &rfds);
            if (fd > maxfd) maxfd = fd;
            any = 1;
        }
    }
    if (ms < 0) ms = 0;
    if (!any) {
        usleep((useconds_t)ms * 1000);
        return;
    }
    tv.tv_sec = ms / 1000;
    tv.tv_usec = (ms % 1000) * 1000;
    select(maxfd + 1, &rfds, NULL, NULL, &tv);
}
