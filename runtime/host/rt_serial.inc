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
 *   "stdio"            -- read fd 0, write fd 1: the program IS the
 *                          terminal program (appletalk phase, Task 4).
 *   "pty"              -- a fresh pty master, its slave path announced
 *                          on stderr for a client to attach to.
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
 *
 * The two NON-socket kinds (stdio, pty) keep that same discipline with
 * read()/write() in place of recv()/send() -- a pipe and a pty master are
 * not sockets, so recv/send/MSG_PEEK are all unavailable on them. What
 * changes is two things. First, "how many bytes are ready" cannot use
 * FIONREAD: on macOS a pty master answers 0 to FIONREAD even with bytes
 * genuinely waiting (verified directly -- poll() says readable, FIONREAD
 * says 0, read() then hands over the bytes). So the non-socket kinds get
 * a small per-slot read buffer instead: rt_conn_fd_avail poll()s, read()s
 * what is there into the buffer, and reports the buffer's depth, and
 * ConnHReadByte pops from it. Second, "the channel went away": there is
 * no MSG_PEEK on a pipe or pty either, so EOF is that same read() coming
 * back 0 (or failing hard), latched in the slot's own `gone` flag, which
 * ConnHGone reports once the buffer has also been drained -- deliberately
 * the same "all data first, THEN gone" ordering the socket path gets from
 * MSG_PEEK. select() (ConnHIdle) needs no change: it works on pipes,
 * ttys and pty masters as it does on sockets.
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
#include <poll.h>
#include <termios.h>
#include <signal.h>
#include <stdlib.h>
#include <string.h>

/* 4 -> 8: AppleTalk phase Task 9 grew conn.cla's own slot table to 8
 * (spec 4.1 -- an ADSP listener hands out accepted connections from it).
 * The two must agree: conn.cla indexes this array by slot. */
#define RT_CONN_MAX 8

/* Read buffer for the non-socket kinds (see the header comment: FIONREAD
 * is useless on a pty master). One pump pass hands the program at most
 * this many bytes; the next pass picks up the rest, exactly as a slow
 * reader already behaves on the socket path. 512 is a serial line's worth
 * of burst, not a tuning knob anyone has needed to turn.
 * ponytail: fixed size, grow it if a real workload starves. */
#define RT_CONN_BUFSZ 512

/* kind: which of the three transports the slot's fd is. Everything that
 * differs between them (recv/send vs read/write, how "the other end went
 * away" is detected, whether close() may touch the fd at all) switches on
 * this one field; kind 0 keeps the original socket paths byte-identical. */
#define RT_CONN_SOCKET 0
#define RT_CONN_STDIO  1
#define RT_CONN_PTY    2

typedef struct {
    int fd;         /* -1 = closed/never opened; stdio reads 0, writes 1 */
    int listening;  /* kind 0: fd is a listen socket, accept still pending.
                     * kind 2: no pty slave has attached yet -- deliberately
                     * the SAME state (writes discarded, Avail 0, Gone 0),
                     * per spec 4.7: an unattached pty is an unplugged
                     * cable, exactly like a bound-but-unaccepted socket. */
    int kind;       /* RT_CONN_SOCKET / RT_CONN_STDIO / RT_CONN_PTY */
    int gone;       /* kinds 1-2: EOF seen (rt_conn_fd_avail latches it) */
    int bufLen;     /* kinds 1-2: bytes held in buf */
    int bufPos;     /* kinds 1-2: how many of those are already popped */
    unsigned char buf[RT_CONN_BUFSZ];
} rt_conn_slot_t;

static rt_conn_slot_t rt_conn_slots[RT_CONN_MAX] = {
    { -1, 0, 0, 0 }, { -1, 0, 0, 0 }, { -1, 0, 0, 0 }, { -1, 0, 0, 0 },
    { -1, 0, 0, 0 }, { -1, 0, 0, 0 }, { -1, 0, 0, 0 }, { -1, 0, 0, 0 }
};

static int rt_conn_slot_ok(int32_t slot) {
    return slot >= 0 && slot < RT_CONN_MAX;
}

/* rt_conn_slot_clear: reset a slot to its never-opened state, closing the
 * fd only when the slot actually OWNS it -- the stdio kind's fds are the
 * process's own inherited stdin/stdout, and closing those would take the
 * whole program's console down with the connection. Both ConnHClose and
 * every ConnHOpen branch's belt go through here, so no path can reset
 * half the fields or close somebody else's fd. */
static void rt_conn_slot_clear(rt_conn_slot_t *s) {
    if (s->fd >= 0 && s->kind != RT_CONN_STDIO) close(s->fd);
    s->fd = -1;
    s->listening = 0;
    s->kind = RT_CONN_SOCKET;
    s->gone = 0;
    s->bufLen = 0;
    s->bufPos = 0;
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

/* rt_conn_stdio_raw / rt_conn_stdio_restore: put the terminal in raw mode
 * for the "stdio" transport, so the program sees every keystroke byte
 * as it is typed instead of the tty's cooked line discipline eating
 * control characters and holding bytes until Return. Only when fd 0 is
 * genuinely a tty -- under a pipe (a test harness, a shell pipeline)
 * there is no termios to set and the whole step is skipped silently.
 * The saved termios is restored by an atexit handler, which covers both
 * a normal return from main and Clarus's own `quit`; a program killed by
 * an uncaught signal still leaves the terminal raw, the standard cost of
 * the atexit approach (a full sigaction net is out of scope here). */
static struct termios rt_conn_tty_saved;
static int rt_conn_tty_raw = 0;

static void rt_conn_stdio_restore(void) {
    if (rt_conn_tty_raw) {
        tcsetattr(0, TCSANOW, &rt_conn_tty_saved);
        rt_conn_tty_raw = 0;
    }
}

static void rt_conn_stdio_raw(void) {
    struct termios t;
    if (rt_conn_tty_raw || !isatty(0)) return;
    if (tcgetattr(0, &rt_conn_tty_saved) != 0) return;
    t = rt_conn_tty_saved;
    cfmakeraw(&t);
    if (tcsetattr(0, TCSANOW, &t) != 0) return;
    rt_conn_tty_raw = 1;
    atexit(rt_conn_stdio_restore);
}

/* rt_conn_open_pty: a fresh pty master, its slave path announced on
 * stderr ("pty /dev/ttysNNN") so a client can attach with `screen`, a
 * test driver, or anything else that opens a serial device. Returns the
 * master fd, or -1.
 *
 * The runtime deliberately does NOT open the slave itself: holding one
 * open would make the master permanently "attached" (no unattached state,
 * and no EOF when the real client leaves), and on macOS the master fd is
 * not a tty at all -- tcgetattr on it fails with ENOTTY -- so the runtime
 * cannot set the pair's line discipline from this side either. The client
 * owns the slave's termios, exactly as it owns a real serial device's,
 * and a client that wants the byte transparency `connection` promises
 * sets raw mode itself on the slave before sending anything (a cooked pty
 * echoes the master's own writes back at it and rewrites CR/LF). */
static int rt_conn_open_pty(void) {
    int fd = posix_openpt(O_RDWR | O_NOCTTY);
    const char *path;
    if (fd < 0) return -1;
    if (grantpt(fd) != 0 || unlockpt(fd) != 0) { close(fd); return -1; }
    path = ptsname(fd);
    if (path == NULL) { close(fd); return -1; }
    fprintf(stderr, "pty %s\n", path);
    fflush(stderr);
    return fd;
}

/* rt_conn_fd_avail: the non-socket kinds' ConnHAvail step, and the only
 * place their fd is ever read or their EOF ever detected. Compacts what
 * the caller has already popped, tops the buffer up from the fd, and
 * reports the depth.
 *
 * poll() with a zero timeout keeps this off the pump's critical path, and
 * makes the following read() safe on a plain blocking fd: poll said
 * readable, so read() either hands over bytes or reports EOF, and cannot
 * park. Once a slave closes again, the master polls readable and read()
 * returns 0 (macOS) -- and any hard read error is treated as EOF too
 * rather than left to spin, since there is no recovery path for a serial
 * line whose fd has broken.
 *
 * The EOF latch's own gate, `!s->listening || (p.revents & POLLIN)`, is
 * where the two platforms have to be reconciled, so it is worth spelling
 * out what each half is for.
 *
 * `!s->listening` suppresses the latch during the unattached window. On
 * macOS an unattached master polls as nothing at all (verified), so the
 * read() is never even reached; on Linux it reports a BARE POLLHUP, whose
 * read() fails EIO -- and latching that would condemn the connection
 * before the client ever arrived, so the first byte finally sent would
 * clear `listening` on an already-dead slot and the pump would tear it
 * down after one drain.
 *
 * `p.revents & POLLIN` is what lets a REAL hangup through while still
 * listening -- a client that attaches and detaches without ever sending a
 * byte (a `screen` attach with no keystrokes; a driver that dies before
 * writing). Verified on macOS: that leaves the master polling 0x11
 * (POLLIN|POLLHUP) with read() == 0, persistently, and Linux's unattached
 * window is a bare POLLHUP with no POLLIN, so the two states stay
 * distinguishable on both. Without this half the slot would wedge in
 * `listening` forever -- `gone` never latched, ConnHGone stuck on its own
 * `listening` early-return -- with ConnHIdle's select() finding the fd
 * permanently readable and spinning the pump hot. `listening` is cleared
 * along with the latch for that same reason: a hangup proves a client WAS
 * there, so the slot is no longer "not there yet", and ConnHGone's early
 * return must let the verdict through.
 *
 * Linux is untested here -- this repo's gate is macOS only -- so the gate
 * is written to be correct on both by construction rather than by
 * observation. One known Linux-only wart is left standing, out of scope
 * for this task: because an unattached master polls readable there
 * (POLLHUP), ConnHIdle's select() returns immediately every pass until a
 * client attaches, so a program waiting on an empty pty busy-spins. That
 * is inherent in keeping the slot alive-but-unattached rather than a
 * defect of this gate; the fix, if it ever matters, is for ConnHIdle to
 * leave a still-listening pty master out of its fd_set and fall back to
 * its usleep. */
static int32_t rt_conn_fd_avail(rt_conn_slot_t *s) {
    struct pollfd p;
    ssize_t k;

    if (s->bufPos > 0) {
        if (s->bufPos < s->bufLen)
            memmove(s->buf, s->buf + s->bufPos, (size_t)(s->bufLen - s->bufPos));
        s->bufLen -= s->bufPos;
        s->bufPos = 0;
    }
    if (s->bufLen < RT_CONN_BUFSZ) {
        p.fd = s->fd;
        p.events = POLLIN;
        p.revents = 0;
        if (poll(&p, 1, 0) > 0) {
            k = read(s->fd, s->buf + s->bufLen, (size_t)(RT_CONN_BUFSZ - s->bufLen));
            if (k > 0) {
                s->bufLen += (int)k;
                s->listening = 0;   /* a pty slave is unmistakably attached */
            } else if ((!s->listening || (p.revents & POLLIN)) &&
                       (k == 0 || (errno != EAGAIN && errno != EWOULDBLOCK && errno != EINTR))) {
                s->gone = 1;
                s->listening = 0;   /* a hangup proves a client was here */
            }
        }
    }
    return (int32_t)(s->bufLen - s->bufPos);
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

    if (strcmp(spec, "stdio") == 0) {
        /* No fd is opened at all: fd 0 is read, fd 1 is written, both
         * inherited. Stored as fd 0 so ConnHAvail/ConnHIdle poll the
         * right one; ConnHWrite is the only place fd 1 appears. */
        rt_conn_stdio_raw();
        rt_conn_slot_clear(&rt_conn_slots[slot]);
        rt_conn_slots[slot].fd = 0;
        rt_conn_slots[slot].kind = RT_CONN_STDIO;
        return 0;
    }
    if (strcmp(spec, "pty") == 0) {
        fd = rt_conn_open_pty();
        if (fd < 0) return errno != 0 ? errno : 1;
        rt_conn_slot_clear(&rt_conn_slots[slot]);
        rt_conn_slots[slot].fd = fd;
        rt_conn_slots[slot].listening = 1;   /* no slave attached yet */
        rt_conn_slots[slot].kind = RT_CONN_PTY;
        return 0;
    }
    if (strncmp(spec, "listen:", 7) == 0) {
        int port = atoi(spec + 7);
        if (port <= 0) return 1;
        fd = rt_conn_listen(port);
        if (fd < 0) return errno != 0 ? errno : 1;
        /* Belt, not currently reachable: conn.cla's rtConnOpen only ever
         * calls down here when rtConnState[slot] != stOpen, so slot's fd
         * should already be -1 here. Close it first anyway in case that
         * invariant ever loosens (e.g. a future direct-reopen path). */
        rt_conn_slot_clear(&rt_conn_slots[slot]);
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
        /* Belt, not currently reachable -- see the listen: branch above. */
        rt_conn_slot_clear(&rt_conn_slots[slot]);
        rt_conn_slots[slot].fd = fd;
        return 0;
    }
    return 1; /* garbled: none of stdio, pty, listen:, connect: */
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
    if (s->kind != RT_CONN_SOCKET) return rt_conn_fd_avail(s);
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
    if (rt_conn_slots[slot].kind != RT_CONN_SOCKET) {
        rt_conn_slot_t *s = &rt_conn_slots[slot];
        /* Pops the buffer rt_conn_fd_avail filled. The refill here is
         * belt: the documented contract is ConnHAvail first, and the
         * pump honours it, but a bare ReadByte should still work. */
        if (s->bufPos >= s->bufLen) rt_conn_fd_avail(s);
        if (s->bufPos >= s->bufLen) return 0;
        return (int32_t)s->buf[s->bufPos++];
    }
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
 * other write failure, instead of killing the process.
 *
 * A slot still LISTENING (bind+listen succeeded, no client accepted yet)
 * mirrors an unattached real serial line, per the controller's ruling on
 * Task 5's own review: `opened` firing at successful bind is correct
 * (open success is transport-invisible; a raw serial cable has no
 * peer-arrival signal either -- carrier detect is out of scope this
 * phase), so a write in that window is not an error -- physical bytes
 * sent into an unplugged cable just go nowhere. Discard and report
 * success (0), exactly as a real SCC write would; once a peer IS
 * accepted (rt_conn_slots[slot].listening flips false, ConnHAvail's own
 * accept step), writes flow normally through the branch below,
 * unchanged. */
int32_t rt_ext_ConnHWrite(int32_t slot, void *p, int32_t n) {
    rt_conn_slot_t *s;
    const unsigned char *buf;
    int32_t sent;
    ssize_t k;
    int wfd;

    if (!rt_conn_slot_ok(slot)) return 1;
    s = &rt_conn_slots[slot];
    if (s->fd < 0) return 1;
    /* Unattached: a listening socket with no peer, or a pty with no
     * slave. Same ruling either way -- discard, report success. */
    if (s->listening) return 0;
    if (s->kind != RT_CONN_SOCKET && s->gone) return 1;
    buf = (const unsigned char *)p;
    sent = 0;
    /* stdio reads fd 0 but writes fd 1; every other kind writes its own
     * fd. write() rather than send() for both non-socket kinds -- send()
     * is a socket call and fails with ENOTSOCK on a pipe or pty. */
    wfd = (s->kind == RT_CONN_STDIO) ? 1 : s->fd;
    while (sent < n) {
        k = (s->kind == RT_CONN_SOCKET)
            ? send(s->fd, buf + sent, (size_t)(n - sent), 0)
            : write(wfd, buf + sent, (size_t)(n - sent));
        /* A signal landing mid-write is not a failed write: retry rather
         * than report an error and silently drop the tail of a message
         * whose prefix already went out. write() to a pty master is a
         * good deal more interruptible than a loopback send(). */
        if (k < 0 && errno == EINTR) continue;
        if (k <= 0) return 1;
        sent += (int32_t)k;
    }
    return 0;
}

/* rt_ext_ConnHClose: idempotent -- closes the fd (if any) and resets the
 * slot. Callable on an already-closed slot (conn.cla's own rtConnClose is
 * idempotent; this is its device-level half).
 *
 * One transport-visible wart, worth knowing rather than papering over:
 * closing a pty MASTER discards whatever the client has not read yet, so
 * a program that sends a goodbye and closes in the same breath may hand
 * its client a truncated one. There is no fix from this side on macOS --
 * the queued bytes sit in the SLAVE's input queue, which the master can
 * neither count (TIOCOUTQ answers 0) nor drain (tcdrain is a no-op there,
 * the master not being a tty at all) -- so it is documented, in the
 * language reference too, instead. Sockets and stdio have no such wart. */
void rt_ext_ConnHClose(int32_t slot) {
    if (!rt_conn_slot_ok(slot)) return;
    rt_conn_slot_clear(&rt_conn_slots[slot]);
}

/* rt_ext_ConnHGone: orderly peer close, detected the standard way -- a
 * MSG_PEEK recv returning exactly 0. MSG_DONTWAIT is mandatory here
 * regardless of the fd's own blocking mode: this call must never block.
 * A still-listening slot (no peer yet) isn't "gone", just not there.
 * The non-socket kinds have no MSG_PEEK; they report the `gone` flag
 * rt_conn_fd_avail latches instead (see that function). */
int32_t rt_ext_ConnHGone(int32_t slot) {
    unsigned char b;
    ssize_t n;

    if (!rt_conn_slot_ok(slot)) return 0;
    if (rt_conn_slots[slot].fd < 0) return 0;
    if (rt_conn_slots[slot].kind != RT_CONN_SOCKET) {
        /* Non-socket kinds: the latched EOF flag. Polled here as well as
         * from ConnHAvail so a caller that only ever asks "gone?" (the
         * pump's own order is Avail first, but nothing requires that)
         * still sees the hangup. Note this runs even while `listening`,
         * unlike the socket branch below: an unattached pty that IS being
         * hung up on (a client that attached and left without sending a
         * byte) has no other way to be noticed, and rt_conn_fd_avail's own
         * gate is what keeps a merely-unattached one quiet. */
        rt_conn_slot_t *s = &rt_conn_slots[slot];
        if (!s->gone) rt_conn_fd_avail(s);
        /* Buffered bytes outrank the hangup: the socket path's MSG_PEEK
         * only reports 0 once the receive queue is drained too, so `gone`
         * waits for the last byte here as well. */
        return (s->gone && s->bufPos >= s->bufLen) ? 1 : 0;
    }
    if (rt_conn_slots[slot].listening) return 0;
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
