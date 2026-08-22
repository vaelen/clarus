/* runtime/host/rt_fileh_test.c -- hand-written C harness for the
 * `filehandle` type's host pread/pwrite glue (2026-08-22 binary-files
 * spec, Task 5: runtime/host/rt_fileh.inc, #included at the bottom of
 * rt.c). Mirrors rt_ser_test.c/rt_serial_test.c's style: CHECK macro,
 * "OK\n" on success.
 *
 * Compile + run (mirrors sertest_c_test.go's own cc invocation --
 * internal/hostrt/filehtest_c_test.go wires this into `go test` the same
 * way, this line is just for anyone running it by hand):
 *   cc -std=c99 -Wall -Werror -I runtime/host \
 *      runtime/host/rt_fileh_test.c runtime/host/rt.c -o /tmp/filehtest
 *   cd $(mktemp -d) && /tmp/filehtest
 *
 * Exercises rt_fileh.inc purely through its public rt_ext_FhH* API (no
 * prototypes for these live in rt.h -- see rt_ext_host.inc's own header
 * comment on why rt_ext_* symbols are never centrally declared -- so this
 * file declares its own extern prototypes below, exactly matching the
 * definitions rt_fileh.inc supplies once linked in via rt.c). Writes a
 * scratch file relative to the process cwd (a temp dir, per the compile
 * comment above), so nothing here touches the repo.
 *
 * create/pwrite/pread/size/truncate/fsync/close round trip, plus the two
 * documented-not-an-error edge cases (short read at EOF, append via
 * pos == -1) and the two-open-failure-mode/stale-handle checks.
 */
#include "rt.h"
#include <stdio.h>
#include <string.h>
#include <unistd.h>

extern int32_t rt_ext_FhHOpen(const uint8_t *path);
extern int32_t rt_ext_FhHCreate(const uint8_t *path);
extern int32_t rt_ext_FhHReadAt(int32_t h, int32_t pos, void *p, int32_t n);
extern int32_t rt_ext_FhHWriteAt(int32_t h, int32_t pos, void *p, int32_t n);
extern int32_t rt_ext_FhHSize(int32_t h);
extern int32_t rt_ext_FhHSetSize(int32_t h, int32_t n);
extern int32_t rt_ext_FhHFlush(int32_t h);
extern void    rt_ext_FhHClose(int32_t h);
extern int32_t rt_ext_FhHErrno(void);

static int failed = 0;
#define CHECK(cond, msg) \
    do { if (!(cond)) { fprintf(stderr, "FAIL: %s (%s:%d)\n", msg, __FILE__, __LINE__); failed = 1; } } while (0)

static void mkpath(uint8_t *out255, const char *s) {
    size_t n = strlen(s);
    out255[0] = (uint8_t)n;
    memcpy(out255 + 1, s, n);
}

/* test_round_trip: create, write at 0 and at 100 (a gap that must
 * zero-fill on the host, per spec %3.1), size, read back both regions
 * plus a past-EOF read (empty, not an error), setSize grow+truncate,
 * flush, close, reopen via FhHOpen, read the surviving byte back,
 * close. */
static void test_round_trip(void) {
    uint8_t path[256];
    int32_t h;
    unsigned char hello[5] = "hello";
    unsigned char world[5] = "WORLD";
    unsigned char buf[16];
    int32_t got;

    mkpath(path, "fileh_test_round.dat");

    h = rt_ext_FhHCreate(path);
    CHECK(h != 0, "create should succeed");

    CHECK(rt_ext_FhHWriteAt(h, 0, hello, 5) == 0, "writeAt(0) should succeed");
    CHECK(rt_ext_FhHWriteAt(h, 100, world, 5) == 0, "writeAt(100) should succeed");
    CHECK(rt_ext_FhHSize(h) == 105, "size should be 105 after the far write");

    memset(buf, 0xAA, sizeof(buf));
    got = rt_ext_FhHReadAt(h, 0, buf, 5);
    CHECK(got == 5, "readAt(0,5) should return 5 bytes");
    CHECK(memcmp(buf, hello, 5) == 0, "readAt(0,5) content matches");

    memset(buf, 0xAA, sizeof(buf));
    got = rt_ext_FhHReadAt(h, 5, buf, 10);
    CHECK(got == 10, "readAt(5,10) should return the full 10-byte gap+start");
    CHECK(buf[0] == 0 && buf[9] == 0, "the gap between old EOF and the far write zero-fills on the host");

    memset(buf, 0xAA, sizeof(buf));
    got = rt_ext_FhHReadAt(h, 100, buf, 5);
    CHECK(got == 5, "readAt(100,5) should return the far write");
    CHECK(memcmp(buf, world, 5) == 0, "readAt(100,5) content matches");

    /* Past-EOF read: succeeds with 0 bytes, not an error. */
    got = rt_ext_FhHReadAt(h, 1000, buf, 10);
    CHECK(got == 0, "readAt past EOF returns 0 bytes, not -1");

    /* Short read crossing EOF. */
    got = rt_ext_FhHReadAt(h, 103, buf, 10);
    CHECK(got == 2, "readAt crossing EOF returns a short count, not -1");

    /* append: pos == -1 means "at current EOF". */
    CHECK(rt_ext_FhHWriteAt(h, -1, hello, 5) == 0, "writeAt(-1) (append) should succeed");
    CHECK(rt_ext_FhHSize(h) == 110, "size should grow by the appended length");

    /* setSize: truncate, then grow (zero-filled on the host). */
    CHECK(rt_ext_FhHSetSize(h, 8) == 0, "setSize(8) (truncate) should succeed");
    CHECK(rt_ext_FhHSize(h) == 8, "size should be 8 after truncating");
    CHECK(rt_ext_FhHSetSize(h, 20) == 0, "setSize(20) (grow) should succeed");
    CHECK(rt_ext_FhHSize(h) == 20, "size should be 20 after growing");
    memset(buf, 0xAA, sizeof(buf));
    got = rt_ext_FhHReadAt(h, 8, buf, 12);
    CHECK(got == 12, "readAt over the grown region should return the full count");
    {
        int i;
        int allZero = 1;
        for (i = 0; i < 12; i++) if (buf[i] != 0) allZero = 0;
        CHECK(allZero, "the grown region zero-fills on the host");
    }

    CHECK(rt_ext_FhHFlush(h) == 0, "flush should succeed");
    rt_ext_FhHClose(h);

    /* Reopen via FhHOpen (existing file), prove the surviving byte. */
    h = rt_ext_FhHOpen(path);
    CHECK(h != 0, "open (existing file) should succeed");
    memset(buf, 0xAA, sizeof(buf));
    got = rt_ext_FhHReadAt(h, 0, buf, 1);
    CHECK(got == 1 && buf[0] == 'h', "reopened file's first byte survives");
    rt_ext_FhHClose(h);

    unlink((const char *)(path + 1));
}

/* test_open_failure: opening a nonexistent file fails (0), with a nonzero
 * errno retrievable via FhHErrno -- the environmental-failure path
 * fileh.cla's own rtFhOpen turns into lastError, never a panic. */
static void test_open_failure(void) {
    uint8_t path[256];
    int32_t h;

    mkpath(path, "fileh_test_does_not_exist.dat");
    h = rt_ext_FhHOpen(path);
    CHECK(h == 0, "open of a nonexistent file should fail");
    CHECK(rt_ext_FhHErrno() != 0, "FhHErrno should report a nonzero code after the failed open");
}

/* test_create_truncates: file.create truncates an existing file to 0 and
 * reopens it read/write (spec %3.1). */
static void test_create_truncates(void) {
    uint8_t path[256];
    int32_t h;
    unsigned char data[4] = { 1, 2, 3, 4 };

    mkpath(path, "fileh_test_truncate.dat");
    h = rt_ext_FhHCreate(path);
    CHECK(h != 0, "first create should succeed");
    CHECK(rt_ext_FhHWriteAt(h, 0, data, 4) == 0, "initial write should succeed");
    CHECK(rt_ext_FhHSize(h) == 4, "size should be 4 before the second create");
    rt_ext_FhHClose(h);

    h = rt_ext_FhHCreate(path);
    CHECK(h != 0, "second create (truncate) should succeed");
    CHECK(rt_ext_FhHSize(h) == 0, "size should be 0 immediately after create truncates");
    rt_ext_FhHClose(h);

    unlink((const char *)(path + 1));
}

int main(void) {
    test_round_trip();
    test_open_failure();
    test_create_truncates();
    if (failed) {
        fprintf(stderr, "FAILED\n");
        return 1;
    }
    printf("OK\n");
    return 0;
}
