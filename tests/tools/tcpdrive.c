/* tests/tools/tcpdrive.c -- script-driven TCP peer for the conntest and
 * (Task 14) Snow serial-bridge tests. One process, POSIX sockets, poll()
 * for every deadline, no threads: a test script spawns this as the other
 * end of a connection and it walks a line-oriented step list.
 *
 * usage: tcpdrive pick-port
 *        tcpdrive listen PORT SCRIPT
 *        tcpdrive connect HOST:PORT [--retry SECS] SCRIPT
 *
 * Exit 0 when the script completes, 1 on a divergence (with the step
 * number, the reason, the byte offset and a 32-byte hex window), 2 on a
 * usage or socket error. */
#include <errno.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <poll.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <time.h>
#include <unistd.h>

#define READ_DEADLINE_MS 30000L /* per-step read deadline (expect/expect-sub) */
#define ACCEPT_MS        30000L /* listen mode: wait this long for a peer */
#define RBUF             65536
#define MAXFILE          (4L * 1024 * 1024)

static const char USAGE[] =
"usage: tcpdrive pick-port\n"
"       tcpdrive listen PORT SCRIPT          (PORT 0 = ephemeral)\n"
"       tcpdrive connect HOST:PORT [--retry SECS] SCRIPT\n"
"\n"
"pick-port prints a free 127.0.0.1 port. listen prints \"port N\" (the\n"
"port it actually bound) before waiting for a peer, so PORT 0 works.\n"
"connect --retry SECS re-dials every 250 ms, each attempt allowed 500 ms,\n"
"until SECS elapse.\n"
"\n"
"SCRIPT is a line-oriented step list; blank lines and lines whose first\n"
"non-space character is '#' are ignored. Steps:\n"
"  expect FILE          read exactly size(FILE) bytes (30 s deadline) and\n"
"                       byte-compare them against FILE\n"
"  expect-sub STRING N  read at most N bytes, succeeding as soon as STRING\n"
"                       has been seen. Bytes BEFORE the match are discarded,\n"
"                       so leading garbage is tolerated (Snow's serial\n"
"                       bridge emits one noise byte ahead of the first real\n"
"                       byte). STRING may be double-quoted and may use the\n"
"                       escapes \\r \\n \\t \\0 \\\\ \\\" -- e.g.\n"
"                       expect-sub \"READY\\r\" 64\n"
"  send FILE            write every byte of FILE\n"
"  sleep MS             wait MS milliseconds\n"
"  close                orderly shutdown of our writing half\n"
"  await-close SECS     the peer must close within SECS; bytes that arrive\n"
"                       meanwhile are drained and discarded\n"
"\n"
"exit 0 = script completed; 1 = divergence (\"step N: REASON at byte K\"\n"
"plus a 32-byte hex window of got vs want); 2 = usage or socket error.\n";

static int usage(void) { fputs(USAGE, stderr); return 2; }

static int sock = -1;   /* the live connection */
static int stepno;      /* 1-based, for the divergence line */

/* --- read buffer: everything received flows through here, so expect-sub
 * can over-read past its needle without losing bytes a later step needs. */
static unsigned char rbuf[RBUF];
static size_t rpos, rlen;

static long now_ms(void) {
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return tv.tv_sec * 1000L + tv.tv_usec / 1000L;
}

static void die2(const char *what) {
    fprintf(stderr, "tcpdrive: %s: %s\n", what, strerror(errno));
    exit(2);
}

/* hexline: up to 32 bytes of p as hex, or "(none)". */
static void hexline(const char *label, const unsigned char *p, size_t n) {
    size_t i;
    fprintf(stderr, "  %-5s", label);
    if (n == 0) { fputs(" (none)\n", stderr); return; }
    if (n > 32) n = 32;
    for (i = 0; i < n; i++) fprintf(stderr, " %02x", p[i]);
    fputc('\n', stderr);
}

/* diverge: the exit-1 protocol -- one reason line plus the hex window. */
static void diverge(const char *reason, size_t at,
                    const unsigned char *got, size_t gotn,
                    const unsigned char *want, size_t wantn) {
    fprintf(stderr, "step %d: %s at byte %lu\n", stepno, reason, (unsigned long)at);
    hexline("got:", got, gotn);
    if (want) hexline("want:", want, wantn);
    exit(1);
}

/* fill: wait for and read more bytes. Returns 1 on data, 0 on peer EOF,
 * -1 on deadline expiry. Compacts the buffer first so a long-running
 * script never wedges on a full rbuf. */
static int fill(long deadline) {
    struct pollfd pfd;
    ssize_t k;
    long left;

    if (rpos > 0) {
        memmove(rbuf, rbuf + rpos, rlen - rpos);
        rlen -= rpos;
        rpos = 0;
    }
    if (rlen == sizeof rbuf) { fprintf(stderr, "tcpdrive: read buffer full\n"); exit(2); }
    for (;;) {
        left = deadline - now_ms();
        if (left < 0) return -1;
        pfd.fd = sock;
        pfd.events = POLLIN;
        if (poll(&pfd, 1, (int)left) < 0) {
            if (errno == EINTR) continue;
            die2("poll");
        }
        if (!pfd.revents) return -1;    /* timed out */
        k = read(sock, rbuf + rlen, sizeof rbuf - rlen);
        if (k < 0) {
            if (errno == EINTR) continue;
            if (errno == ECONNRESET) return 0;   /* an abortive close is a close */
            die2("read");
        }
        if (k == 0) return 0;
        rlen += (size_t)k;
        return 1;
    }
}

/* load: whole file into a malloc'd buffer. */
static unsigned char *load(const char *path, size_t *n) {
    FILE *f = fopen(path, "rb");
    unsigned char *p;
    long sz;
    if (!f) { fprintf(stderr, "tcpdrive: open %s: %s\n", path, strerror(errno)); exit(2); }
    if (fseek(f, 0, SEEK_END) != 0) die2("fseek");
    sz = ftell(f);
    if (sz < 0 || sz > MAXFILE) { fprintf(stderr, "tcpdrive: %s: bad size %ld\n", path, sz); exit(2); }
    rewind(f);
    p = malloc((size_t)sz + 1);
    if (!p) { fprintf(stderr, "tcpdrive: out of memory\n"); exit(2); }
    if (sz > 0 && fread(p, 1, (size_t)sz, f) != (size_t)sz) {
        fprintf(stderr, "tcpdrive: short read of %s\n", path);
        exit(2);
    }
    fclose(f);
    *n = (size_t)sz;
    return p;
}

/* --- steps ---------------------------------------------------------- */

static void step_expect(const char *path) {
    size_t n, i = 0;
    unsigned char *want = load(path, &n);
    long deadline = now_ms() + READ_DEADLINE_MS;

    while (i < n) {
        if (rpos == rlen) {
            int r = fill(deadline);
            if (r == 0) diverge("peer closed mid-expect", i, NULL, 0, want + i, n - i);
            if (r < 0) diverge("read deadline expired", i, NULL, 0, want + i, n - i);
        }
        while (i < n && rpos < rlen) {
            if (rbuf[rpos] != want[i])
                diverge("expect mismatch", i, rbuf + rpos, rlen - rpos, want + i, n - i);
            rpos++;
            i++;
        }
    }
    free(want);
}

static void step_expect_sub(const unsigned char *needle, size_t nlen, size_t maxbytes) {
    unsigned char *seen;
    size_t total = 0;
    long deadline = now_ms() + READ_DEADLINE_MS;
    char reason[128];

    if (nlen == 0 || nlen > maxbytes) { fprintf(stderr, "tcpdrive: bad expect-sub arguments\n"); exit(2); }
    seen = malloc(maxbytes);
    if (!seen) { fprintf(stderr, "tcpdrive: out of memory\n"); exit(2); }
    while (total < maxbytes) {
        if (rpos == rlen) {
            int r = fill(deadline);
            snprintf(reason, sizeof reason, "%s before substring seen",
                     r == 0 ? "peer closed" : "read deadline expired");
            if (r <= 0) diverge(reason, total, seen, total, needle, nlen);
        }
        seen[total++] = rbuf[rpos++];
        if (total >= nlen && memcmp(seen + total - nlen, needle, nlen) == 0) {
            free(seen);
            return;
        }
    }
    snprintf(reason, sizeof reason, "substring not found in %lu bytes", (unsigned long)maxbytes);
    diverge(reason, total, seen, total, needle, nlen);
}

static void step_send(const char *path) {
    size_t n, off = 0;
    unsigned char *buf = load(path, &n);
    while (off < n) {
        ssize_t k = write(sock, buf + off, n - off);
        if (k < 0) {
            if (errno == EINTR) continue;
            die2("write");
        }
        off += (size_t)k;
    }
    free(buf);
}

static void step_sleep(long ms) {
    struct timespec ts;
    ts.tv_sec = ms / 1000;
    ts.tv_nsec = (ms % 1000) * 1000000L;
    while (nanosleep(&ts, &ts) < 0 && errno == EINTR) { }
}

static void step_await_close(long secs) {
    long deadline = now_ms() + secs * 1000L;
    char reason[128];
    rpos = rlen = 0;                    /* buffered bytes are drained too */
    for (;;) {
        int r = fill(deadline);
        if (r == 0) return;
        if (r < 0) {
            snprintf(reason, sizeof reason, "peer did not close within %lds", secs);
            diverge(reason, 0, rbuf + rpos, rlen - rpos, NULL, 0);
        }
        rpos = rlen = 0;                /* discard whatever arrived */
    }
}

/* --- script --------------------------------------------------------- */

/* unquote: rewrite tok in place, resolving "..." and backslash escapes.
 * Returns the resulting length (the result can contain NULs). */
static size_t unquote(char *tok) {
    char *r = tok, *w = tok;
    if (*r == '"') {
        size_t n = strlen(r);
        if (n >= 2 && r[n - 1] == '"') { r[n - 1] = '\0'; r++; }
    }
    while (*r) {
        if (*r == '\\' && r[1]) {
            r++;
            switch (*r) {
                case 'r': *w++ = '\r'; break;
                case 'n': *w++ = '\n'; break;
                case 't': *w++ = '\t'; break;
                case '0': *w++ = '\0'; break;
                default:  *w++ = *r;   break;   /* \\ and \" land here */
            }
            r++;
        } else {
            *w++ = *r++;
        }
    }
    return (size_t)(w - tok);
}

/* split: whitespace-separated tokens, honouring one level of double
 * quotes (the quotes are left on the token for unquote to strip). */
static int split(char *line, char *tok[], int maxtok) {
    int n = 0;
    char *p = line;
    while (*p) {
        while (*p == ' ' || *p == '\t') p++;
        if (!*p) break;
        if (n == maxtok) return -1;
        tok[n++] = p;
        if (*p == '"') {
            p++;
            while (*p && *p != '"') { if (*p == '\\' && p[1]) p++; p++; }
            if (*p == '"') p++;
        } else {
            while (*p && *p != ' ' && *p != '\t') p++;
        }
        if (*p) *p++ = '\0';
    }
    return n;
}

static long numarg(const char *s, const char *what) {
    char *end;
    long v = strtol(s, &end, 10);
    if (*s == '\0' || *end != '\0' || v < 0) {
        fprintf(stderr, "tcpdrive: step %d: bad %s \"%s\"\n", stepno, what, s);
        exit(2);
    }
    return v;
}

static void run_script(const char *path) {
    FILE *f = fopen(path, "r");
    char line[1024];
    char *tok[8];
    int n;

    if (!f) { fprintf(stderr, "tcpdrive: open %s: %s\n", path, strerror(errno)); exit(2); }
    while (fgets(line, sizeof line, f)) {
        size_t len = strlen(line);
        while (len > 0 && (line[len - 1] == '\n' || line[len - 1] == '\r')) line[--len] = '\0';
        n = split(line, tok, 8);
        if (n < 0) { fprintf(stderr, "tcpdrive: too many words: %s\n", line); exit(2); }
        if (n == 0 || tok[0][0] == '#') continue;
        stepno++;
        if (!strcmp(tok[0], "expect") && n == 2) {
            step_expect(tok[1]);
        } else if (!strcmp(tok[0], "expect-sub") && n == 3) {
            size_t nlen = unquote(tok[1]);
            step_expect_sub((unsigned char *)tok[1], nlen,
                            (size_t)numarg(tok[2], "MAXBYTES"));
        } else if (!strcmp(tok[0], "send") && n == 2) {
            step_send(tok[1]);
        } else if (!strcmp(tok[0], "sleep") && n == 2) {
            step_sleep(numarg(tok[1], "MS"));
        } else if (!strcmp(tok[0], "close") && n == 1) {
            if (shutdown(sock, SHUT_WR) < 0) die2("shutdown");
        } else if (!strcmp(tok[0], "await-close") && n == 2) {
            step_await_close(numarg(tok[1], "SECS"));
        } else {
            fprintf(stderr, "tcpdrive: step %d: unknown step \"%s\"\n", stepno, tok[0]);
            exit(2);
        }
    }
    fclose(f);
}

/* --- transports ----------------------------------------------------- */

static void addr_local(struct sockaddr_in *sa, int port) {
    memset(sa, 0, sizeof *sa);
    sa->sin_family = AF_INET;
    sa->sin_port = htons((unsigned short)port);
    sa->sin_addr.s_addr = htonl(INADDR_LOOPBACK);
}

static int pick_port(void) {
    struct sockaddr_in sa;
    socklen_t sl = sizeof sa;
    int s = socket(AF_INET, SOCK_STREAM, 0);
    if (s < 0) die2("socket");
    addr_local(&sa, 0);
    if (bind(s, (struct sockaddr *)&sa, sizeof sa) < 0) die2("bind");
    if (getsockname(s, (struct sockaddr *)&sa, &sl) < 0) die2("getsockname");
    printf("%d\n", ntohs(sa.sin_port));
    close(s);
    return 0;
}

static void do_listen(int port) {
    struct sockaddr_in sa;
    socklen_t sl = sizeof sa;
    struct pollfd pfd;
    int ls, one = 1;

    ls = socket(AF_INET, SOCK_STREAM, 0);
    if (ls < 0) die2("socket");
    setsockopt(ls, SOL_SOCKET, SO_REUSEADDR, &one, sizeof one);
    addr_local(&sa, port);
    if (bind(ls, (struct sockaddr *)&sa, sizeof sa) < 0) die2("bind");
    if (listen(ls, 1) < 0) die2("listen");
    if (getsockname(ls, (struct sockaddr *)&sa, &sl) < 0) die2("getsockname");
    /* The bound port, before we block on accept: a test script that asked
     * for port 0 reads it from here (and any script can use the line as
     * "the listening socket is up now"). Unbuffered so a redirected
     * stdout carries it immediately, not at exit. */
    printf("port %d\n", ntohs(sa.sin_port));
    fflush(stdout);
    pfd.fd = ls;
    pfd.events = POLLIN;
    if (poll(&pfd, 1, (int)ACCEPT_MS) <= 0) {
        fprintf(stderr, "tcpdrive: no peer connected within %lds\n", ACCEPT_MS / 1000);
        exit(2);
    }
    sock = accept(ls, NULL, NULL);
    if (sock < 0) die2("accept");
    close(ls);
}

static void do_connect(const char *host, int port, long retry_secs) {
    long deadline = now_ms() + retry_secs * 1000L;
    struct sockaddr_in sa;
    struct pollfd pfd;
    int s, err;
    socklen_t el;

    memset(&sa, 0, sizeof sa);
    sa.sin_family = AF_INET;
    sa.sin_port = htons((unsigned short)port);
    if (inet_pton(AF_INET, host, &sa.sin_addr) != 1) {
        fprintf(stderr, "tcpdrive: bad host \"%s\" (dotted-quad IPv4 only)\n", host);
        exit(2);
    }
    for (;;) {
        s = socket(AF_INET, SOCK_STREAM, 0);
        if (s < 0) die2("socket");
        if (fcntl(s, F_SETFL, O_NONBLOCK) < 0) die2("fcntl");
        if (connect(s, (struct sockaddr *)&sa, sizeof sa) == 0) goto up;
        if (errno == EINPROGRESS) {
            pfd.fd = s;
            pfd.events = POLLOUT;
            if (poll(&pfd, 1, 500) > 0) {
                err = 0;
                el = sizeof err;
                if (getsockopt(s, SOL_SOCKET, SO_ERROR, &err, &el) == 0 && err == 0) goto up;
            }
        }
        close(s);
        if (now_ms() >= deadline) {
            fprintf(stderr, "tcpdrive: connect %s:%d failed\n", host, port);
            exit(2);
        }
        step_sleep(250);
    }
up:
    if (fcntl(s, F_SETFL, 0) < 0) die2("fcntl");
    sock = s;
}

int main(int argc, char **argv) {
    long retry = 0;
    const char *script, *colon;
    char host[64];
    int port, ai;

    if (argc < 2) return usage();
    if (!strcmp(argv[1], "pick-port")) return argc == 2 ? pick_port() : usage();

    if (!strcmp(argv[1], "listen")) {
        if (argc != 4) return usage();
        port = (int)numarg(argv[2], "PORT");
        script = argv[3];
        do_listen(port);
    } else if (!strcmp(argv[1], "connect")) {
        ai = 2;
        if (argc - ai < 2) return usage();
        colon = strrchr(argv[ai], ':');
        if (!colon || (size_t)(colon - argv[ai]) >= sizeof host) return usage();
        memcpy(host, argv[ai], (size_t)(colon - argv[ai]));
        host[colon - argv[ai]] = '\0';
        port = (int)numarg(colon + 1, "PORT");
        ai++;
        if (ai < argc && !strcmp(argv[ai], "--retry")) {
            if (argc - ai < 3) return usage();
            retry = numarg(argv[ai + 1], "SECS");
            ai += 2;
        }
        if (ai != argc - 1) return usage();
        script = argv[ai];
        do_connect(host, port, retry);
    } else {
        return usage();
    }
    run_script(script);
    return 0;
}
