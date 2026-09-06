/* runtime/host/rt_serial_test.c -- hand-written C harness for the
 * `connection` type's host TCP glue (2026-08-15 serial-connection spec,
 * Task 4: runtime/host/rt_serial.inc, #included at the bottom of rt.c).
 * Mirrors rt_ser_test.c's style: CHECK macro, "OK\n" on success.
 *
 * Compile + run (mirrors sertest_c_test.go's own cc invocation --
 * internal/hostrt/serialtest_c_test.go wires this into `go test` the
 * same way, this line is just for anyone running it by hand):
 *   cc -std=c99 -Wall -Werror -I runtime/host \
 *      runtime/host/rt_serial_test.c runtime/host/rt.c -o /tmp/serialtest
 *   /tmp/serialtest
 *
 * Exercises rt_serial.inc purely through its public rt_ext_ConnH* API
 * (no prototypes for these live in rt.h -- see that file's own header
 * comment on why rt_ext_* symbols are never centrally declared -- so this
 * file declares its own extern prototypes below, exactly matching the
 * definitions rt_serial.inc supplies once linked in via rt.c).
 *
 * Two scenarios, each a full round trip against a real BSD peer socket
 * bound to 127.0.0.1 on an OS-chosen ephemeral port (no fixed port
 * numbers anywhere, so this never collides with anything else running):
 *   - listen mode  (slot 0, portIdx 0 / CLARUS_SERIAL_MODEM): the glue is
 *     the SERVER, a plain socket is the peer that connects in.
 *   - connect mode (slot 1, portIdx 1 / CLARUS_SERIAL_PRINTER): the glue
 *     is the CLIENT, a plain socket is the peer that accepts.
 * Both directions of 256 bytes of data are pushed through
 * ConnHWrite/ConnHAvail/ConnHReadByte in each scenario; the listen-mode
 * scenario additionally proves ConnHGone fires once the peer closes.
 *
 * A third scenario (slot 2, review fix round) proves the SIGPIPE fix:
 * write into a slot whose peer already closed its end, without ever
 * calling ConnHClose/observing Gone first -- exactly the state a real
 * open connection sits in between "peer hangs up" and "the next pump
 * pass's Gone check gets around to closing it". Before the fix, that
 * write's send() would raise SIGPIPE and kill the whole process with the
 * default disposition; the assertion IS the process still being alive to
 * check ConnHWrite's return value at all.
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
#include <termios.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <netinet/in.h>
#include <arpa/inet.h>

extern int32_t rt_ext_ConnHOpen(int32_t slot, int32_t portIdx);
extern int32_t rt_ext_ConnHAvail(int32_t slot);
extern int32_t rt_ext_ConnHReadByte(int32_t slot);
extern int32_t rt_ext_ConnHWrite(int32_t slot, void *p, int32_t n);
extern void    rt_ext_ConnHClose(int32_t slot);
extern int32_t rt_ext_ConnHGone(int32_t slot);
extern void    rt_ext_ConnHIdle(int32_t ms);

static int failed = 0;
#define CHECK(cond, msg) \
    do { if (!(cond)) { fprintf(stderr, "FAIL: %s (%s:%d)\n", msg, __FILE__, __LINE__); failed = 1; } } while (0)

/* bind_ephemeral: bind+listen a plain BSD socket to 127.0.0.1:0 (OS picks
 * a free port) and report which port via getsockname -- the "find a free
 * port" trick, good enough for a short-lived test. */
static int bind_ephemeral(int *portOut) {
    int fd;
    struct sockaddr_in addr;
    socklen_t alen;

    fd = socket(AF_INET, SOCK_STREAM, 0);
    if (fd < 0) return -1;
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    addr.sin_port = 0;
    if (bind(fd, (struct sockaddr *)&addr, sizeof(addr)) != 0) { close(fd); return -1; }
    if (listen(fd, 1) != 0) { close(fd); return -1; }
    alen = sizeof(addr);
    if (getsockname(fd, (struct sockaddr *)&addr, &alen) != 0) { close(fd); return -1; }
    *portOut = (int)ntohs(addr.sin_port);
    return fd;
}

static void fill_pattern(unsigned char *buf, int n, unsigned char start) {
    int i;
    for (i = 0; i < n; i++) buf[i] = (unsigned char)(start + i);
}

/* set_recv_timeout: belt-and-suspenders bound on the PEER side's own
 * recv() calls (plain_recv_all below) -- defense in depth alongside the
 * process-wide alarm() watchdog in main(), so a genuinely stuck peer
 * socket fails this one CHECK fast instead of hanging the whole test.
 * Callers pass 30s (up from 10s, port-hygiene fix round, serial-connection
 * Task 7). The ORIGINAL 10s firing under the real T1 gate's parallel load
 * turned out, on investigation, to be wait_accept_and_write's own
 * accept-race (Bug B, that function's own doc comment): bytes were never
 * sent at all in most reproductions, not merely slow to arrive -- fixed
 * there, not here. 30s stays anyway as real belt-and-suspenders headroom
 * for genuine parallel-load latency in the (now much rarer) case the
 * bytes really were sent and just took a while to actually reach recv(). */
static void set_recv_timeout(int fd, int seconds) {
    struct timeval tv;
    tv.tv_sec = seconds;
    tv.tv_usec = 0;
    setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv));
}

/* plain_send_all/plain_recv_all: the peer side's own byte-shovel, over an
 * ordinary blocking BSD socket -- no glue involved, just proving what the
 * glue wrote/read against ground truth. */
static void plain_send_all(int fd, const unsigned char *buf, int n) {
    int sent = 0;
    while (sent < n) {
        ssize_t k = send(fd, buf + sent, (size_t)(n - sent), 0);
        if (k <= 0) { fprintf(stderr, "plain_send_all failed\n"); exit(1); }
        sent += (int)k;
    }
}

static void plain_recv_all(int fd, unsigned char *buf, int n) {
    int got = 0;
    while (got < n) {
        ssize_t k = recv(fd, buf + got, (size_t)(n - got), 0);
        if (k <= 0) { fprintf(stderr, "plain_recv_all failed\n"); exit(1); }
        got += (int)k;
    }
}

/* wait_avail: polls rt_ext_ConnHAvail(slot) (which itself performs the
 * deferred accept, in listen mode) until at least `want` bytes are ready
 * or a bounded number of retries elapses -- local loopback delivery is
 * fast but not synchronous with send(). */
static int wait_avail(int slot, int want) {
    int i;
    for (i = 0; i < 2000; i++) {
        if (rt_ext_ConnHAvail(slot) >= want) return 1;
        usleep(1000);
    }
    return 0;
}

static int wait_gone(int slot) {
    int i;
    for (i = 0; i < 2000; i++) {
        if (rt_ext_ConnHGone(slot)) return 1;
        usleep(1000);
    }
    return 0;
}

/* wait_accept_and_write: a client-side connect() returning success only
 * guarantees the OS has queued the completed handshake for the SERVER's
 * accept() -- it does NOT guarantee the server (this same process, in
 * listen mode) has already dequeued it by the time connect() returns.
 * Under light load that window is sub-microsecond and invisible; under
 * heavy concurrent load it's wide enough to matter.
 *
 * Root-caused this task (port-hygiene fix round, serial-connection Task
 * 7): the OLD version of this function retried "ConnHAvail (nudge the
 * accept), then ConnHWrite, stop once ConnHWrite==0" -- but
 * rt_ext_ConnHWrite's OWN documented contract (rt_serial.inc) is that a
 * write to a slot STILL LISTENING (no peer accepted yet) DISCARDS and
 * reports SUCCESS (0), not failure -- mirroring a real unattached serial
 * line, by design (test_write_before_accept's own scenario proves this
 * exact behavior deliberately). That makes "ConnHWrite == 0" genuinely
 * AMBIGUOUS as a stop condition: it cannot tell "really sent to an
 * accepted peer" from "silently discarded because still listening", so
 * the old loop could -- and, confirmed by direct reproduction, DID --
 * declare victory on its very first iteration despite accept() never
 * actually completing, leaving the peer's own plain_recv_all below
 * blocking on bytes that were never sent (that IS this test's own
 * historical "plain_recv_all failed" flake; adding more retries or a
 * longer read timeout, both tried first, cannot fix an ambiguous stop
 * condition -- the loop was never actually retrying past iteration 1).
 *
 * Fix: resolve the ambiguity with an independent, unambiguous signal
 * instead of trusting ConnHWrite's return code at all. peerFd (the SAME
 * already-connected peer socket the caller is about to read the real
 * payload back on) sends one throwaway sentinel byte first, in the
 * OPPOSITE direction (peer -> glue) from the real payload this function
 * writes (glue -> peer) -- full-duplex TCP, so this never touches what
 * the caller reads back. rt_ext_ConnHAvail's own FIONREAD path only ever
 * reports real queued bytes once accept() has actually happened
 * (rt_serial.inc's own doc comment: "0 whenever there's genuinely
 * nothing to read yet, including still listening"), so `wait_avail`
 * seeing that sentinel is unambiguous, definitive proof of acceptance --
 * unlike ConnHWrite's own return value. Only once that's confirmed does
 * this call ConnHWrite exactly once, now safe to trust fully. */
static int wait_accept_and_write(int slot, int peerFd, const unsigned char *buf, int32_t n) {
    unsigned char sentinel = 0xAA;
    int i;

    if (send(peerFd, &sentinel, 1, 0) != 1) return 0;
    /* Sentinel wait: this file's own historically-flakiest assertion
     * (see the doc comment above) gets its own explicit, most-generous
     * budget -- 30000 * 1ms = 30s, matching set_recv_timeout's own bumped
     * 30s -- rather than reusing wait_avail's generic 2000*1ms=2s bound
     * (which would have made THIS wait tighter than every sibling budget
     * this same fix round widened for real parallel-load headroom). */
    for (i = 0; i < 30000; i++) {
        if (rt_ext_ConnHAvail(slot) >= 1) {
            rt_ext_ConnHReadByte(slot); /* drain the sentinel, value irrelevant */
            return rt_ext_ConnHWrite(slot, (void *)buf, n) == 0;
        }
        usleep(1000);
    }
    return 0;
}

/* glue_read_all: drains exactly n bytes through ConnHReadByte, ONLY after
 * wait_avail already confirmed they're ready -- mirrors conn.cla's own
 * "avail>0 then ReadByte" discipline (rtConnPump's doc comment). */
static void glue_read_all(int slot, unsigned char *buf, int n) {
    int i;
    for (i = 0; i < n; i++) {
        buf[i] = (unsigned char)rt_ext_ConnHReadByte(slot);
    }
}

/* open_listen_retrying: bind_ephemeral probes a free port (bind+listen+
 * getsockname+close), then hands that literal port number to
 * rt_ext_ConnHOpen's own listen mode (on the given slot) -- which has no
 * ephemeral-port support of its own (its CLARUS_SERIAL_MODEM=listen:PORT
 * spec takes a literal port, and the ConnHOpen ABI has no way to report
 * back an OS-chosen one). That leaves an inherent gap between "probe
 * learns a free port" and "the glue re-binds that same port number"
 * where another process on this machine can steal it. Under a parallel
 * `go test` run (a dozen packages, including this test's own sibling
 * internal/conntest, all drawing from the same OS ephemeral port pool at
 * once) that gap is real, not theoretical: it reproduced 100% serialized
 * (`-p 1`) and intermittently under the default parallel scheduler,
 * root-caused as TestSerialC's historical "plain_recv_all failed" flake
 * (test_listen_mode used to plow ahead after a failed ConnHOpen with no
 * early return, cascading into a confusing timeout deep in the byte
 * exchange instead of failing where the real problem was). Every
 * listen-mode scenario in this file (test_listen_mode slot 0, test_sigpipe
 * slot 2, test_write_before_accept slot 3) shares this exact same
 * probe-close-reopen shape, so this is the ONE place that retries --
 * fixing only test_listen_mode's own call site left the other two
 * scenarios exposed to the identical race (confirmed: test_sigpipe's own
 * "write after peer close eventually reports a nonzero error" CHECK
 * failed under the same parallel run this fix's first pass had already
 * supposedly fixed). Retrying with a freshly re-probed port on each
 * collision makes the race self-heal; bounded at 20 attempts (a stuck
 * retry loop should fail loud, not hang the suite). */
static int open_listen_retrying(int slot, int *listenPortOut) {
    int i;
    int probe;
    int listenPort;
    char envbuf[64];

    for (i = 0; i < 20; i++) {
        probe = bind_ephemeral(&listenPort);
        if (probe < 0) { usleep(1000); continue; }
        close(probe);
        snprintf(envbuf, sizeof(envbuf), "listen:%d", listenPort);
        setenv("CLARUS_SERIAL_MODEM", envbuf, 1);
        unsetenv("CLARUS_SERIAL_PRINTER");
        if (rt_ext_ConnHOpen(slot, 0) == 0) {
            *listenPortOut = listenPort;
            return 1;
        }
        usleep(1000);
    }
    return 0;
}

/* test_listen_mode: the glue is the SERVER (slot 0, portIdx 0,
 * CLARUS_SERIAL_MODEM=listen:PORT); a plain socket connects in as the
 * peer. Round-trips 256 bytes each direction, then proves ConnHGone. */
static void test_listen_mode(void) {
    int listenPort;
    int peer;
    struct sockaddr_in addr;
    unsigned char out[256], in[256], got[256];

    if (!open_listen_retrying(0, &listenPort)) {
        CHECK(0, "listen-mode ConnHOpen should succeed (retried 20x against fresh ephemeral ports)");
        return;
    }

    peer = socket(AF_INET, SOCK_STREAM, 0);
    CHECK(peer >= 0, "peer socket() should succeed");
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    addr.sin_port = htons((uint16_t)listenPort);
    CHECK(connect(peer, (struct sockaddr *)&addr, sizeof(addr)) == 0, "peer connect should succeed");
    set_recv_timeout(peer, 30);

    /* server(glue) -> client(plain): fill, wait_accept_and_write (see its
       own doc comment for why this confirms real acceptance via a
       sentinel byte before trusting ConnHWrite's own ambiguous return
       code), plain_recv_all, compare. */
    fill_pattern(out, sizeof(out), 0);
    CHECK(wait_accept_and_write(0, peer, out, (int32_t)sizeof(out)), "listen mode: accept+ConnHWrite should eventually succeed");
    plain_recv_all(peer, in, (int)sizeof(in));
    CHECK(memcmp(out, in, sizeof(out)) == 0, "listen mode: server->client bytes match");

    /* client(plain) -> server(glue): fill a DIFFERENT pattern, plain send,
       wait for the glue to see it, drain via ConnHReadByte, compare. */
    fill_pattern(out, sizeof(out), 128);
    plain_send_all(peer, out, (int)sizeof(out));
    CHECK(wait_avail(0, (int)sizeof(out)), "listen mode: ConnHAvail should see the client's bytes");
    glue_read_all(0, got, (int)sizeof(got));
    CHECK(memcmp(out, got, sizeof(out)) == 0, "listen mode: client->server bytes match");

    CHECK(!rt_ext_ConnHGone(0), "listen mode: not gone while peer is still connected");
    close(peer);
    CHECK(wait_gone(0), "listen mode: ConnHGone should fire once the peer closes");

    rt_ext_ConnHClose(0);
}

/* test_connect_mode: the glue is the CLIENT (slot 1, portIdx 1,
 * CLARUS_SERIAL_PRINTER=connect:127.0.0.1:PORT); a plain socket is the
 * server it connects to. Round-trips 256 bytes each direction. */
static void test_connect_mode(void) {
    int serverFd;
    int serverPort;
    char envbuf[64];
    int accepted;
    unsigned char out[256], in[256], got[256];
    int rc;

    serverFd = bind_ephemeral(&serverPort);
    CHECK(serverFd >= 0, "server bind_ephemeral should succeed");

    snprintf(envbuf, sizeof(envbuf), "connect:127.0.0.1:%d", serverPort);
    setenv("CLARUS_SERIAL_PRINTER", envbuf, 1);

    /* rt_ext_ConnHOpen's connect mode blocks until connected (brief:
       "blocking connect is fine") -- by the time it returns, the
       three-way handshake already completed, so accept() below never
       blocks either. */
    rc = rt_ext_ConnHOpen(1, 1);
    CHECK(rc == 0, "connect-mode ConnHOpen should succeed");

    accepted = accept(serverFd, NULL, NULL);
    CHECK(accepted >= 0, "server accept should succeed");
    set_recv_timeout(accepted, 30);

    fill_pattern(out, sizeof(out), 0);
    CHECK(rt_ext_ConnHWrite(1, out, (int32_t)sizeof(out)) == 0, "ConnHWrite (connect mode) should succeed");
    plain_recv_all(accepted, in, (int)sizeof(in));
    CHECK(memcmp(out, in, sizeof(out)) == 0, "connect mode: client(glue)->server bytes match");

    fill_pattern(out, sizeof(out), 128);
    plain_send_all(accepted, out, (int)sizeof(out));
    CHECK(wait_avail(1, (int)sizeof(out)), "connect mode: ConnHAvail should see the server's bytes");
    glue_read_all(1, got, (int)sizeof(got));
    CHECK(memcmp(out, got, sizeof(out)) == 0, "connect mode: server->client(glue) bytes match");

    rt_ext_ConnHClose(1);
    close(accepted);
    close(serverFd);
}

/* write_until_fails: retries ConnHWrite until it reports a failure (or a
 * bounded number of attempts elapses). A single write right after a
 * peer's ORDERLY close very often still succeeds locally -- TCP usually
 * needs one more round trip (this side's next send actually reaching the
 * peer and getting an RST back) before EPIPE shows up -- so proving the
 * SIGPIPE fix needs "keep writing until it fails", not "the first write
 * fails". Bounded at 500 * 20ms = 10s, safely inside main()'s own watchdog
 * (port-hygiene fix round, serial-connection Task 7: 50*20ms=1s was found
 * too tight under the real T1 gate's heavy parallel CPU contention --
 * getting the RST processed and surfaced through ConnHWrite's own error
 * path can take longer than 1s when a dozen other Go test packages are
 * fighting for cores, not because the SIGPIPE fix itself is wrong). */
static int write_until_fails(int slot, const unsigned char *buf, int32_t n) {
    int i;
    for (i = 0; i < 500; i++) {
        int rc = rt_ext_ConnHWrite(slot, (void *)buf, n);
        if (rc != 0) return rc;
        usleep(20000);
    }
    return 0;
}

/* test_sigpipe: slot 2 (unused by the two scenarios above -- their own
 * slots 0/1 are already closed by the time this runs). See this file's
 * header comment for the scenario. */
static void test_sigpipe(void) {
    int listenPort;
    int peer;
    struct sockaddr_in addr;
    unsigned char out[16];
    int rc;

    if (!open_listen_retrying(2, &listenPort)) {
        CHECK(0, "sigpipe test: ConnHOpen should succeed (retried 20x against fresh ephemeral ports)");
        return;
    }

    peer = socket(AF_INET, SOCK_STREAM, 0);
    CHECK(peer >= 0, "sigpipe test: peer socket() should succeed");
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    addr.sin_port = htons((uint16_t)listenPort);
    CHECK(connect(peer, (struct sockaddr *)&addr, sizeof(addr)) == 0, "sigpipe test: peer connect should succeed");

    fill_pattern(out, sizeof(out), 0);
    CHECK(wait_accept_and_write(2, peer, out, (int32_t)sizeof(out)), "sigpipe test: initial accept+write should succeed");

    /* Close the peer's end -- WITHOUT closing our own slot 2 or calling
       ConnHGone first, so the slot is exactly in the "stOpen but the
       channel is actually dead" window a real rtConnPump hasn't caught
       up to yet. */
    close(peer);

    rc = write_until_fails(2, out, (int32_t)sizeof(out));
    /* The real assertion is reaching this line at all: the default
       SIGPIPE disposition would have killed the process partway through
       write_until_fails, before any CHECK below could run. */
    CHECK(rc != 0, "sigpipe test: write after peer close eventually reports a nonzero error (process survived, no silent 0)");

    rt_ext_ConnHClose(2);
}

/* test_write_before_accept: a slot still LISTENING (bound, no peer
 * accepted yet) must not fail ConnHWrite -- controller ruling on Task 5's
 * own review: it mirrors an unattached real serial line, bytes sent into
 * an unplugged cable go nowhere but that's not an error. Slot 3. Writes
 * BEFORE any peer connects, asserting 0 (discarded, success); then a real
 * peer connects and a SUBSEQUENT write reaches them, proving the discard
 * path doesn't wedge the slot for later real traffic. */
static void test_write_before_accept(void) {
    int listenPort;
    int peer;
    struct sockaddr_in addr;
    unsigned char out[16], in[16];

    if (!open_listen_retrying(3, &listenPort)) {
        CHECK(0, "write-before-accept: ConnHOpen should succeed (retried 20x against fresh ephemeral ports)");
        return;
    }

    /* No peer yet -- ConnHAvail (which itself does the deferred accept
       poll) confirms the slot is still just listening. */
    CHECK(rt_ext_ConnHAvail(3) == 0, "write-before-accept: nothing available before any peer connects");

    fill_pattern(out, sizeof(out), 7);
    CHECK(rt_ext_ConnHWrite(3, out, (int32_t)sizeof(out)) == 0,
        "write-before-accept: write to a still-listening slot discards and reports success, not failure");

    /* Now connect a real peer and prove writes reach them normally -- the
       discard above must not have wedged the slot for later traffic. */
    peer = socket(AF_INET, SOCK_STREAM, 0);
    CHECK(peer >= 0, "write-before-accept: peer socket() should succeed");
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    addr.sin_port = htons((uint16_t)listenPort);
    CHECK(connect(peer, (struct sockaddr *)&addr, sizeof(addr)) == 0, "write-before-accept: peer connect should succeed");
    set_recv_timeout(peer, 30);

    fill_pattern(out, sizeof(out), 99);
    CHECK(wait_accept_and_write(3, peer, out, (int32_t)sizeof(out)), "write-before-accept: post-accept write should succeed");
    plain_recv_all(peer, in, (int)sizeof(in));
    CHECK(memcmp(out, in, sizeof(out)) == 0, "write-before-accept: post-accept bytes reach the peer");

    close(peer);
    rt_ext_ConnHClose(3);
}

/* test_open_failure: unset env var / garbled spec both report a nonzero
 * code, never crash -- the two environmental-failure paths conn.cla's own
 * rtConnOpen turns into a `failed` event rather than a panic. */
static void test_open_failure(void) {
    unsetenv("CLARUS_SERIAL_MODEM");
    CHECK(rt_ext_ConnHOpen(2, 0) != 0, "ConnHOpen with unset env var should fail");

    setenv("CLARUS_SERIAL_MODEM", "garbled-not-a-spec", 1);
    CHECK(rt_ext_ConnHOpen(2, 0) != 0, "ConnHOpen with a garbled spec should fail");

    setenv("CLARUS_SERIAL_MODEM", "listen:0", 1);
    CHECK(rt_ext_ConnHOpen(2, 0) != 0, "ConnHOpen with a zero port should fail");
}

/* ---------------------------------------------------------------------
 * stdio / pty transports (appletalk phase, Task 4; spec 4.7 + 6.3).
 * Both are non-socket fds, so these scenarios drive the glue against
 * ordinary pipes / a real pty pair rather than the loopback sockets
 * above: read()/write() instead of recv()/send(), and EOF (read returning
 * 0) instead of a MSG_PEEK of 0 as the "channel went away" signal.
 * ------------------------------------------------------------------- */

/* fd_read_all: plain_recv_all's read() twin -- recv() only works on
 * sockets, and neither a pipe nor a pty master is one. Bounded by poll()
 * so a missing byte fails this test fast instead of parking in read()
 * until main()'s own watchdog fires. */
static int fd_read_all(int fd, unsigned char *buf, int n, int seconds) {
    int got = 0;
    while (got < n) {
        struct pollfd p;
        ssize_t k;
        p.fd = fd;
        p.events = POLLIN;
        p.revents = 0;
        if (poll(&p, 1, seconds * 1000) <= 0) return 0;
        k = read(fd, buf + got, (size_t)(n - got));
        if (k <= 0) return 0;
        got += (int)k;
    }
    return 1;
}

/* test_stdio: CLARUS_SERIAL_MODEM=stdio, slot 0 (closed again by
 * test_listen_mode above). A pipe pair stands in for the terminal: the
 * read end is dup2'd onto fd 0 (what the glue reads) and a second pipe's
 * write end onto fd 1 (what the glue writes), with the real fd 0/1 saved
 * and restored around the whole scenario -- printf("OK") in main() only
 * reaches the harness at all if that restore works, and if
 * rt_ext_ConnHClose left fd 1 alone rather than closing the process's own
 * stdout. fd 0 is a pipe here, never a tty, so the isatty()-gated raw
 * mode is deliberately NOT exercised (that path needs a real terminal;
 * the atexit restore is the reason it is safe to skip). */
static void test_stdio(void) {
    int inPipe[2], outPipe[2];
    int save0, save1;
    unsigned char out[300], got[300], sweep[256], back[256];
    int rc;

    CHECK(pipe(inPipe) == 0, "stdio: input pipe() should succeed");
    CHECK(pipe(outPipe) == 0, "stdio: output pipe() should succeed");
    save0 = dup(0);
    save1 = dup(1);
    CHECK(save0 >= 0 && save1 >= 0, "stdio: saving fd 0/1 should succeed");
    CHECK(dup2(inPipe[0], 0) == 0, "stdio: dup2 onto fd 0 should succeed");
    CHECK(dup2(outPipe[1], 1) == 1, "stdio: dup2 onto fd 1 should succeed");

    setenv("CLARUS_SERIAL_MODEM", "stdio", 1);
    unsetenv("CLARUS_SERIAL_PRINTER");
    rc = rt_ext_ConnHOpen(0, 0);
    CHECK(rc == 0, "stdio: ConnHOpen should succeed");

    /* terminal -> program: 300 bytes (more than one 256-byte pattern, so
       the count itself is not a coincidence of the pattern length). */
    fill_pattern(out, (int)sizeof(out), 0);
    CHECK(write(inPipe[1], out, sizeof(out)) == (ssize_t)sizeof(out), "stdio: feeding the input pipe should succeed");
    CHECK(wait_avail(0, (int)sizeof(out)), "stdio: ConnHAvail should report the 300 fed bytes");
    glue_read_all(0, got, (int)sizeof(got));
    CHECK(memcmp(out, got, sizeof(out)) == 0, "stdio: terminal->program bytes match, in order");
    CHECK(!rt_ext_ConnHGone(0), "stdio: not gone while the input pipe's writer is still open");

    /* program -> terminal: the full 0-255 sweep, byte-exact on fd 1. */
    fill_pattern(sweep, (int)sizeof(sweep), 0);
    CHECK(rt_ext_ConnHWrite(0, sweep, (int32_t)sizeof(sweep)) == 0, "stdio: ConnHWrite should succeed");
    CHECK(fd_read_all(outPipe[0], back, (int)sizeof(back), 5), "stdio: the sweep should reach the output pipe");
    CHECK(memcmp(sweep, back, sizeof(sweep)) == 0, "stdio: program->terminal bytes match");

    /* EOF on fd 0 is the terminal going away. */
    close(inPipe[1]);
    CHECK(wait_gone(0), "stdio: ConnHGone should fire once the input pipe's writer closes");

    rt_ext_ConnHClose(0);
    CHECK(dup2(save0, 0) == 0, "stdio: restoring fd 0 should succeed");
    CHECK(dup2(save1, 1) == 1, "stdio: restoring fd 1 should succeed");
    close(save0);
    close(save1);
    close(inPipe[0]);
    close(outPipe[0]);
    close(outPipe[1]);
}

/* test_pty: CLARUS_SERIAL_MODEM=pty, slot 1 (closed again by
 * test_connect_mode above). stderr is captured over a pipe just for the
 * ConnHOpen call so the announced slave path can be parsed back out (and
 * so it never pollutes run_c_test's own "expect exactly OK" capture),
 * then this test plays the CONSUMER: opens /dev/ttysNNN itself, puts the
 * line discipline in raw mode (a real client's job -- see
 * rt_serial.inc's own pty comment), and round-trips bytes each way.
 * Also pins the "no slave attached yet" state (Avail 0, Write discarded
 * with success, Gone 0) before opening the slave, and Gone once the slave
 * closes again. */
static void test_pty(void) {
    int errPipe[2];
    int save2;
    char line[160];
    char path[128];
    ssize_t n;
    int slave;
    struct termios tio;
    unsigned char out[256], got[256], back[256];
    int rc;

    CHECK(pipe(errPipe) == 0, "pty: stderr pipe() should succeed");
    save2 = dup(2);
    CHECK(save2 >= 0, "pty: saving fd 2 should succeed");
    fflush(stderr);
    CHECK(dup2(errPipe[1], 2) == 2, "pty: dup2 onto fd 2 should succeed");

    setenv("CLARUS_SERIAL_MODEM", "pty", 1);
    rc = rt_ext_ConnHOpen(1, 0);
    fflush(stderr);
    CHECK(dup2(save2, 2) == 2, "pty: restoring fd 2 should succeed");
    close(save2);
    close(errPipe[1]);
    CHECK(rc == 0, "pty: ConnHOpen should succeed");

    memset(line, 0, sizeof(line));
    n = read(errPipe[0], line, sizeof(line) - 1);
    close(errPipe[0]);
    path[0] = '\0';
    CHECK(n > 0 && sscanf(line, "pty %127s", path) == 1 && strncmp(path, "/dev/", 5) == 0,
        "pty: open should announce `pty /dev/...` on stderr");
    if (path[0] == '\0') { rt_ext_ConnHClose(1); return; }

    /* No slave attached yet: the `listening` state, per spec 4.7. */
    fill_pattern(out, (int)sizeof(out), 0);
    CHECK(rt_ext_ConnHAvail(1) == 0, "pty: nothing available before a slave attaches");
    CHECK(rt_ext_ConnHWrite(1, out, 8) == 0, "pty: a write with no slave attached discards and reports success");
    CHECK(!rt_ext_ConnHGone(1), "pty: not gone before a slave has ever attached");

    slave = open(path, O_RDWR | O_NOCTTY);
    CHECK(slave >= 0, "pty: opening the announced slave should succeed");
    if (slave < 0) { rt_ext_ConnHClose(1); return; }
    /* Raw the slave BEFORE anything is written through it: a cooked pty
       echoes what the master writes straight back at the master and
       translates CR/LF, which would corrupt both byte sweeps below. */
    CHECK(tcgetattr(slave, &tio) == 0, "pty: tcgetattr on the slave should succeed");
    cfmakeraw(&tio);
    CHECK(tcsetattr(slave, TCSANOW, &tio) == 0, "pty: tcsetattr(raw) on the slave should succeed");

    /* consumer -> program: the full 0-255 sweep. */
    CHECK(write(slave, out, sizeof(out)) == (ssize_t)sizeof(out), "pty: writing the sweep into the slave should succeed");
    CHECK(wait_avail(1, (int)sizeof(out)), "pty: ConnHAvail should see the slave's bytes");
    glue_read_all(1, got, (int)sizeof(got));
    CHECK(memcmp(out, got, sizeof(out)) == 0, "pty: consumer->program bytes match");

    /* program -> consumer: a DIFFERENT pattern, so an echoed copy of the
       sweep above could never pass for it. */
    fill_pattern(out, (int)sizeof(out), 128);
    CHECK(rt_ext_ConnHWrite(1, out, (int32_t)sizeof(out)) == 0, "pty: ConnHWrite with a slave attached should succeed");
    CHECK(fd_read_all(slave, back, (int)sizeof(back), 5), "pty: the written bytes should reach the slave");
    CHECK(memcmp(out, back, sizeof(out)) == 0, "pty: program->consumer bytes match");

    CHECK(!rt_ext_ConnHGone(1), "pty: not gone while the slave is still open");
    close(slave);
    CHECK(wait_gone(1), "pty: ConnHGone should fire once the slave closes");

    rt_ext_ConnHClose(1);
}

/* on_alarm: process-wide watchdog (see wait_accept_and_write's own
 * comment for the specific race this whole file used to be vulnerable
 * to) -- if ANY blocking call anywhere in this file ever hangs for a
 * reason not already covered by a bounded retry or a socket timeout,
 * this converts that hang into a fast, loud failure instead of stalling
 * the whole `go test -timeout 30m` gate for half an hour. */
static void on_alarm(int sig) {
    (void)sig;
    fprintf(stderr, "FAIL: watchdog fired -- a call hung past the 270s bound\n");
    fprintf(stderr, "FAILED\n");
    _exit(1);
}

int main(void) {
    signal(SIGALRM, on_alarm);
    /* 240s (up from 20s, port-hygiene fix round, serial-connection Task 7,
     * fix round 1): headroom above the HONEST worst-case sequential sum of
     * every bounded blocking call in this file, computed per scenario
     * (review fix round 1, Important 4 -- the original 90s bound and its
     * comment undercounted this):
     *   test_listen_mode:         wait_accept_and_write 30s + plain_recv_all
     *                              (set_recv_timeout) 30s + wait_avail 2s +
     *                              wait_gone 2s               = 64s
     *   test_connect_mode:        plain_recv_all 30s + wait_avail 2s = 32s
     *   test_sigpipe:              wait_accept_and_write 30s +
     *                              write_until_fails 10s      = 40s
     *   test_write_before_accept: wait_accept_and_write 30s +
     *                              plain_recv_all 30s          = 60s
     *   test_open_failure:                                     = 0s
     *   test_stdio:               wait_avail 2s + fd_read_all 5s +
     *                              wait_gone 2s                = 9s
     *   test_pty:                 wait_avail 2s + fd_read_all 5s +
     *                              wait_gone 2s                = 9s
     *   ------------------------------------------------------------
     *   sum                                                    = 214s
     * 270s (up from 240s, appletalk Task 4, which added the two
     * non-socket scenarios above) leaves ~56s of headroom above that
     * honest sum. Still loud and
     * fast in the overwhelmingly common case (a clean run finishes in well
     * under a second); this only matters on the rare, deeply pathological
     * run where every single one of these hit its own worst case at once. */
    alarm(270);

    test_listen_mode();
    test_connect_mode();
    test_sigpipe();
    test_write_before_accept();
    test_open_failure();
    test_stdio();
    test_pty();
    /* ConnHIdle: just prove it returns promptly with nothing open (all
       slots were closed by their own tests above) rather than hanging --
       the select()-vs-usleep branch's cheap half. */
    rt_ext_ConnHIdle(1);
    if (failed) {
        fprintf(stderr, "FAILED\n");
        return 1;
    }
    printf("OK\n");
    return 0;
}
