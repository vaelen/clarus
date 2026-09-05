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
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>

extern int32_t rt_ext_FhHOpen(const uint8_t *path);
extern int32_t rt_ext_FhHCreate(const uint8_t *path);
extern int32_t rt_ext_FhHReadAt(int32_t h, int32_t pos, void *p, int32_t n);
extern int32_t rt_ext_FhHWriteAt(int32_t h, int32_t pos, void *p, int32_t n);
extern int32_t rt_ext_FhHSize(int32_t h);
extern int32_t rt_ext_FhHSetSize(int32_t h, int32_t n);
extern int32_t rt_ext_FhHFlush(int32_t h);
extern void    rt_ext_FhHClose(int32_t h);
extern int32_t rt_ext_FhHErrno(void);
extern int32_t rt_ext_FhHStat(const uint8_t *path);
extern int32_t rt_ext_FhHStatField(int32_t which);

/* filesystem-api Task 4: the directory/catalog surface's host lane. */
extern int32_t rt_ext_FhHMakeDir(const uint8_t *path);
extern int32_t rt_ext_FhHDelete(const uint8_t *path);
extern int32_t rt_ext_FhHListBegin(const uint8_t *path);
extern int32_t rt_ext_FhHListNext(void *buf);
extern void    rt_ext_FhHListEnd(void);
extern int32_t rt_ext_FhHSetTimes(const uint8_t *path, int32_t created, int32_t modified);
extern int32_t rt_ext_FhHRename(const uint8_t *path, const uint8_t *newName);
extern int32_t rt_ext_FhHMove(const uint8_t *path, const uint8_t *dirPath);

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

/* test_stat: FhHStat/FhHStatField (filesystem-api Task 3) -- a scratch
 * file's size and isDir==0, the cwd's isDir==1, and a nonexistent path's
 * failure mode (mirrors test_open_failure's own ENOENT check). */
static void test_stat(void) {
    uint8_t path[256];
    int32_t h;
    unsigned char data[3] = { 1, 2, 3 };

    mkpath(path, "fileh_test_stat.dat");
    h = rt_ext_FhHCreate(path);
    CHECK(h != 0, "create should succeed");
    CHECK(rt_ext_FhHWriteAt(h, 0, data, 3) == 0, "initial write should succeed");
    rt_ext_FhHClose(h);

    CHECK(rt_ext_FhHStat(path) == 0, "stat of the scratch file should succeed");
    CHECK(rt_ext_FhHStatField(0) == 3, "stat size should match the written length");
    CHECK(rt_ext_FhHStatField(4) == 0, "a plain file's isDir field should be 0");

    {
        uint8_t dot[256];
        mkpath(dot, ".");
        CHECK(rt_ext_FhHStat(dot) == 0, "stat of the cwd should succeed");
        CHECK(rt_ext_FhHStatField(4) == 1, "the cwd's isDir field should be 1");
    }

    {
        uint8_t nope[256];
        mkpath(nope, "fileh_test_stat_does_not_exist.dat");
        CHECK(rt_ext_FhHStat(nope) == -1, "stat of a nonexistent path should fail");
        CHECK(rt_ext_FhHErrno() == ENOENT, "FhHErrno should report ENOENT after the failed stat");
    }

    unlink((const char *)(path + 1));
}

/* test_hfs_path_translation (filesystem-api Task 4, spec %4.4): the
 * translation table -- ":a:b" -> "a/b", "a" -> "a" (unchanged, no colon),
 * "Vol:x" -> "Vol/x" -- proved through rt_ext_FhHMakeDir itself (which
 * routes every path through path_to_cstr's rt_fh_posix_path hook) rather
 * than a standalone unit test of the static helper, then confirmed with a
 * plain POSIX stat() on the translated name. */
static void test_hfs_path_translation(void) {
    uint8_t p0[256], p1[256], p2[256], p3[256], p4[256];
    struct stat st;

    mkpath(p1, ":t1");
    CHECK(rt_ext_FhHMakeDir(p1) == 0, "makeDir(':t1') should succeed (leading colon dropped)");
    mkpath(p2, ":t1:sub");
    CHECK(rt_ext_FhHMakeDir(p2) == 0, "makeDir(':t1:sub') should succeed (':' -> '/')");
    CHECK(stat("t1/sub", &st) == 0 && S_ISDIR(st.st_mode), "t1/sub should exist as a directory (POSIX-side proof)");

    mkpath(p3, "a");
    CHECK(rt_ext_FhHMakeDir(p3) == 0, "makeDir('a') (no colon) should succeed unchanged");
    CHECK(stat("a", &st) == 0 && S_ISDIR(st.st_mode), "a should exist as a directory");

    /* "Vol:x" -> "Vol/x" (spec %4.4: a full path's volume name becomes an
     * ordinary leading directory component) -- makeDir requires the
     * parent to already exist, so "Vol" itself is made first. */
    mkpath(p0, "Vol");
    CHECK(rt_ext_FhHMakeDir(p0) == 0, "makeDir('Vol') should succeed");
    mkpath(p4, "Vol:x");
    CHECK(rt_ext_FhHMakeDir(p4) == 0, "makeDir('Vol:x') should succeed ('Vol:x' -> 'Vol/x')");
    CHECK(stat("Vol/x", &st) == 0 && S_ISDIR(st.st_mode), "Vol/x should exist as a directory");

    rmdir("t1/sub");
    rmdir("t1");
    rmdir("a");
    rmdir("Vol/x");
    rmdir("Vol");
}

/* test_list: FhHListBegin/FhHListNext over a folder with one subfolder --
 * sees "sub" exactly once, then FhHListNext returns 1 (done). */
static void test_list(void) {
    uint8_t dir[256], sub[256], buf[256];
    int32_t got;
    int seen;

    mkpath(dir, "fileh_test_list");
    CHECK(rt_ext_FhHMakeDir(dir) == 0, "makeDir(list dir) should succeed");
    mkpath(sub, "fileh_test_list:sub");
    CHECK(rt_ext_FhHMakeDir(sub) == 0, "makeDir(list dir sub) should succeed");

    CHECK(rt_ext_FhHListBegin(dir) == 0, "listBegin should succeed");
    got = rt_ext_FhHListNext(buf);
    CHECK(got == 0, "listNext should see one entry");
    seen = (got == 0 && buf[0] == 3 && memcmp(buf + 1, "sub", 3) == 0);
    CHECK(seen, "the one entry should be 'sub'");
    got = rt_ext_FhHListNext(buf);
    CHECK(got == 1, "listNext should report done after the one entry");
    rt_ext_FhHListEnd();

    rmdir("fileh_test_list/sub");
    rmdir("fileh_test_list");
}

/* test_rename_move: FhHRename renames in place (same dir); FhHMove moves
 * into a target dir keeping the name; round trip back. */
static void test_rename_move(void) {
    uint8_t dir[256], a[256], b[256], newName[256];
    int32_t h;

    mkpath(dir, "fileh_test_mvdir");
    CHECK(rt_ext_FhHMakeDir(dir) == 0, "makeDir(move target dir) should succeed");
    mkpath(a, "fileh_test_a.dat");
    h = rt_ext_FhHCreate(a);
    CHECK(h != 0, "create a.dat should succeed");
    rt_ext_FhHClose(h);

    /* rename's newName is a leaf name, not a path (spec %3): it REPLACES
     * the leaf entirely, so "fileh_test_a.dat" renamed to "b.dat" becomes
     * plain "b.dat" in the same directory -- not "fileh_test_b.dat". */
    mkpath(newName, "b.dat");
    CHECK(rt_ext_FhHRename(a, newName) == 0, "rename a.dat -> b.dat should succeed");
    {
        struct stat st;
        CHECK(stat("b.dat", &st) == 0, "b.dat should exist after rename");
        CHECK(stat("fileh_test_a.dat", &st) != 0, "fileh_test_a.dat should no longer exist after rename");
    }

    mkpath(b, "b.dat");
    CHECK(rt_ext_FhHMove(b, dir) == 0, "move b.dat into fileh_test_mvdir should succeed");
    {
        struct stat st;
        CHECK(stat("fileh_test_mvdir/b.dat", &st) == 0, "the moved file should exist in the target dir");
        CHECK(stat("b.dat", &st) != 0, "the moved file should no longer exist at the old location");
    }

    unlink("fileh_test_mvdir/b.dat");
    rmdir("fileh_test_mvdir");
}

/* test_delete_dir: FhHDelete of a non-empty folder fails (ENOTEMPTY, or
 * EEXIST on some BSDs); it succeeds once the folder is empty. */
static void test_delete_dir(void) {
    uint8_t dir[256], sub[256];
    int32_t rc;

    mkpath(dir, "fileh_test_deldir");
    CHECK(rt_ext_FhHMakeDir(dir) == 0, "makeDir(deldir) should succeed");
    mkpath(sub, "fileh_test_deldir:sub");
    CHECK(rt_ext_FhHMakeDir(sub) == 0, "makeDir(deldir sub) should succeed");

    rc = rt_ext_FhHDelete(dir);
    CHECK(rc != 0, "delete of a non-empty folder should fail");
    CHECK(rt_ext_FhHErrno() == ENOTEMPTY || rt_ext_FhHErrno() == EEXIST, "FhHErrno should report ENOTEMPTY/EEXIST for a non-empty folder");

    CHECK(rt_ext_FhHDelete(sub) == 0, "delete of the now-empty sub folder should succeed");
    CHECK(rt_ext_FhHDelete(dir) == 0, "delete of the now-empty folder should succeed");
}

/* test_set_times: FhHSetTimes(path, 0, modified) restamps mtime;
 * FhHStat/FhHStatField(3) reflects it back exactly -- modified taken from
 * a real FhHStatField(3) reading plus an offset, so this test needs no
 * duplicate of rt_fh_mac_time's own epoch math. */
static void test_set_times(void) {
    uint8_t path[256];
    int32_t h;
    int32_t before, target;

    mkpath(path, "fileh_test_times.dat");
    h = rt_ext_FhHCreate(path);
    CHECK(h != 0, "create should succeed");
    rt_ext_FhHClose(h);

    CHECK(rt_ext_FhHStat(path) == 0, "stat before setTimes should succeed");
    before = rt_ext_FhHStatField(3);
    target = before - 3600; /* one hour earlier -- comfortably clear of DST-transition noise */

    CHECK(rt_ext_FhHSetTimes(path, 0, target) == 0, "setTimes should succeed");
    CHECK(rt_ext_FhHStat(path) == 0, "stat after setTimes should succeed");
    CHECK(rt_ext_FhHStatField(3) == target, "modified field should match the value just set");

    /* modified == 0 means "leave unchanged". */
    CHECK(rt_ext_FhHSetTimes(path, 0, 0) == 0, "setTimes with modified == 0 should succeed as a no-op");
    CHECK(rt_ext_FhHStat(path) == 0, "stat after the no-op setTimes should succeed");
    CHECK(rt_ext_FhHStatField(3) == target, "modified field should be unchanged after a modified == 0 call");

    unlink((const char *)(path + 1));
}

/* test_long_names: the over-long-name guards (language-runtime-cleanup
 * Task 4). Only FhHListNext's is reachable through the public API -- a
 * Pascal Str255 argument caps `path` and `newName` at 255 bytes each, and
 * FhHRename/FhHMove's target[512] holds 255 + '/' + 255 + NUL exactly, so
 * their snprintf guards can never fire from here and are defensive only.
 * readdir() by contrast hands back whatever the filesystem stored: APFS
 * counts its 255-name limit in CHARACTERS, so 150 two-byte UTF-8 glyphs
 * make a legal 300-BYTE dirent that cannot fit a Str255. On a filesystem
 * that counts bytes (ext4, HFS+) the setup fopen() fails and this case
 * reports itself skipped instead of failing. */
static void test_long_names(void) {
    uint8_t dir[256], buf[256];
    char name[512];
    char path[1024];
    FILE *f;
    int i;
    int32_t got;

    mkpath(dir, "fileh_test_longname");
    CHECK(rt_ext_FhHMakeDir(dir) == 0, "makeDir(longname dir) should succeed");

    for (i = 0; i < 150; i++) {          /* U+0416, 2 bytes, no NFD form */
        name[i * 2] = (char)0xD0;
        name[i * 2 + 1] = (char)0x96;
    }
    name[300] = '\0';
    snprintf(path, sizeof path, "fileh_test_longname/%s", name);

    f = fopen(path, "w");
    if (!f) {
        fprintf(stderr, "SKIP: this filesystem rejects a 300-byte name (%s)\n", strerror(errno));
        rmdir("fileh_test_longname");
        return;
    }
    fclose(f);

    CHECK(rt_ext_FhHListBegin(dir) == 0, "listBegin(longname dir) should succeed");
    got = rt_ext_FhHListNext(buf);
    CHECK(got == -1, "listNext should fail on an entry too long for a Str255");
    CHECK(rt_ext_FhHErrno() == ENAMETOOLONG, "FhHErrno should report ENAMETOOLONG for an over-long entry");
    rt_ext_FhHListEnd();

    unlink(path);
    rmdir("fileh_test_longname");
}

int main(void) {
    test_round_trip();
    test_open_failure();
    test_create_truncates();
    test_stat();
    test_hfs_path_translation();
    test_list();
    test_rename_move();
    test_delete_dir();
    test_set_times();
    test_long_names();
    if (failed) {
        fprintf(stderr, "FAILED\n");
        return 1;
    }
    printf("OK\n");
    return 0;
}
