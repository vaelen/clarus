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
#include <signal.h>
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
 * socket fails this one CHECK fast instead of hanging the whole test. */
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
 * heavy concurrent load (the real T1 gate runs a dozen Go test packages
 * at once) it's wide enough to matter -- a single unretried
 * ConnHAvail/ConnHWrite pair can genuinely observe "still listening" and
 * silently no-op (ConnHWrite refuses to write through a still-listening
 * fd), which used to leave the peer's plain_recv_all below waiting
 * forever for bytes that were never sent. Retrying the accept nudge
 * (ConnHAvail) alongside the write, bounded, closes that race instead of
 * assuming it away. */
static int wait_accept_and_write(int slot, const unsigned char *buf, int32_t n) {
    int i;
    for (i = 0; i < 5000; i++) {
        rt_ext_ConnHAvail(slot); /* nudges the deferred accept along */
        if (rt_ext_ConnHWrite(slot, (void *)buf, n) == 0) return 1;
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

/* test_listen_mode: the glue is the SERVER (slot 0, portIdx 0,
 * CLARUS_SERIAL_MODEM=listen:PORT); a plain socket connects in as the
 * peer. Round-trips 256 bytes each direction, then proves ConnHGone. */
static void test_listen_mode(void) {
    int listenPort;
    int probe;
    char envbuf[64];
    int peer;
    struct sockaddr_in addr;
    unsigned char out[256], in[256], got[256];
    int rc;

    /* pick_free_port: bind+close a throwaway socket on port 0 just to
       learn an unused port number -- rt_ext_ConnHOpen's own listen mode
       takes a literal port, it has no ephemeral-port query of its own. */
    probe = bind_ephemeral(&listenPort);
    CHECK(probe >= 0, "probe bind should succeed");
    close(probe);

    snprintf(envbuf, sizeof(envbuf), "listen:%d", listenPort);
    setenv("CLARUS_SERIAL_MODEM", envbuf, 1);
    unsetenv("CLARUS_SERIAL_PRINTER");

    rc = rt_ext_ConnHOpen(0, 0);
    CHECK(rc == 0, "listen-mode ConnHOpen should succeed");

    peer = socket(AF_INET, SOCK_STREAM, 0);
    CHECK(peer >= 0, "peer socket() should succeed");
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    addr.sin_port = htons((uint16_t)listenPort);
    CHECK(connect(peer, (struct sockaddr *)&addr, sizeof(addr)) == 0, "peer connect should succeed");
    set_recv_timeout(peer, 10);

    /* server(glue) -> client(plain): fill, wait_accept_and_write (see its
       own comment for why this is a retry loop and not one unconditional
       call), plain_recv_all, compare. */
    fill_pattern(out, sizeof(out), 0);
    CHECK(wait_accept_and_write(0, out, (int32_t)sizeof(out)), "listen mode: accept+ConnHWrite should eventually succeed");
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
    set_recv_timeout(accepted, 10);

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
 * fails". Bounded at 50 * 20ms = 1s, safely inside main()'s alarm(20). */
static int write_until_fails(int slot, const unsigned char *buf, int32_t n) {
    int i;
    for (i = 0; i < 50; i++) {
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
    int probe;
    char envbuf[64];
    int peer;
    struct sockaddr_in addr;
    unsigned char out[16];
    int rc;

    probe = bind_ephemeral(&listenPort);
    CHECK(probe >= 0, "sigpipe test: probe bind should succeed");
    close(probe);

    snprintf(envbuf, sizeof(envbuf), "listen:%d", listenPort);
    setenv("CLARUS_SERIAL_MODEM", envbuf, 1);

    rc = rt_ext_ConnHOpen(2, 0);
    CHECK(rc == 0, "sigpipe test: ConnHOpen should succeed");

    peer = socket(AF_INET, SOCK_STREAM, 0);
    CHECK(peer >= 0, "sigpipe test: peer socket() should succeed");
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    addr.sin_port = htons((uint16_t)listenPort);
    CHECK(connect(peer, (struct sockaddr *)&addr, sizeof(addr)) == 0, "sigpipe test: peer connect should succeed");

    fill_pattern(out, sizeof(out), 0);
    CHECK(wait_accept_and_write(2, out, (int32_t)sizeof(out)), "sigpipe test: initial accept+write should succeed");

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

/* on_alarm: process-wide watchdog (see wait_accept_and_write's own
 * comment for the specific race this whole file used to be vulnerable
 * to) -- if ANY blocking call anywhere in this file ever hangs for a
 * reason not already covered by a bounded retry or a socket timeout,
 * this converts that hang into a fast, loud failure instead of stalling
 * the whole `go test -timeout 30m` gate for half an hour. */
static void on_alarm(int sig) {
    (void)sig;
    fprintf(stderr, "FAIL: watchdog fired -- a call hung past the 20s bound\n");
    fprintf(stderr, "FAILED\n");
    _exit(1);
}

int main(void) {
    signal(SIGALRM, on_alarm);
    alarm(20);

    test_listen_mode();
    test_connect_mode();
    test_sigpipe();
    test_open_failure();
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
