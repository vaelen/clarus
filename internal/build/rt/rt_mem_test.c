/* internal/build/rt/rt_mem_test.c -- hand-written C harness for the host
 * paranoid Memory Manager shim (rt_mem.h + rt_mem_host.inc). Standalone:
 * includes rt_mem.h then rt_mem_host.inc directly (no rt.c link) and
 * supplies its own no-op rt_run_cleanup stub (the real one lands in
 * rt_core.inc in a later task). Compiled + run host-side by
 * memtest_c_test.go in a temp cwd. Mirrors rt_ser_test.c's style: assert
 * via CHECK, "OK\n" on success.
 *
 * CLARUS_MEM_PARANOID can't be set portably with setenv before main() on
 * every host, so the paranoid-relocation checks (3) run in a re-exec'd
 * child: argv[1]=="paranoid" runs just those checks and reports success
 * purely via exit code (no stdout so the parent's own final "OK\n" stays
 * the only line of output on a passing run); the parent spawns that
 * child with the env var set via system() and propagates its exit.
 */
#include "rt_mem.h"
#include "rt_mem_host.inc"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void rt_run_cleanup(void) {}

static int failed = 0;
#define CHECK(cond, msg) \
    do { if (!(cond)) { fprintf(stderr, "FAIL: %s (%s:%d)\n", msg, __FILE__, __LINE__); failed = 1; } } while (0)

/* 1 + 2: NewHandle, then SetHandleSize -- resize always relocates, but
   the first 16 bytes of payload survive the move. */
static void test_new_handle_and_resize(void)
{
    Handle h;
    char *old_p;
    int i;

    h = NewHandle(16);
    CHECK(h != NULL, "NewHandle(16) returns non-NULL");
    CHECK(GetHandleSize(h) == 16, "GetHandleSize returns 16");
    CHECK(rt_mem_live_count() == 1, "live_count is 1 after one NewHandle");

    for (i = 0; i < 16; i++) (*h)[i] = (char)(i + 1);
    old_p = *h;
    SetHandleSize(h, 4096);
    CHECK(GetHandleSize(h) == 4096, "GetHandleSize returns 4096 after resize");
    CHECK(*h != old_p, "resize always relocates -- *h changed");
    for (i = 0; i < 16; i++) {
        CHECK((unsigned char)(*h)[i] == (unsigned char)(i + 1), "payload preserved across resize");
    }
    DisposeHandle(h);
}

/* Review fix (Critical): a locked handle must never move. Growing beyond
   the current raw allocation must fail with memFullErr and leave the
   handle/address/size untouched; shrinking resizes in place. */
static void test_locked_resize(void)
{
    Handle h;
    char *p;
    Size sz;

    h = NewHandle(16);
    HLock(h);
    p = *h;
    sz = GetHandleSize(h);

    SetHandleSize(h, 4096); /* grow while locked: must fail, must not move */
    CHECK(*h == p, "locked grow: address unchanged");
    CHECK(MemError() == memFullErr, "locked grow: MemError is memFullErr");
    CHECK(GetHandleSize(h) == sz, "locked grow: size unchanged");

    SetHandleSize(h, 8); /* shrink while locked: resizes in place */
    CHECK(*h == p, "locked shrink: address unchanged");
    CHECK(GetHandleSize(h) == 8, "locked shrink: size updated");

    HUnlock(h);
    SetHandleSize(h, 4096); /* grow now allowed: relocates */
    CHECK(GetHandleSize(h) == 4096, "grow succeeds again once unlocked");

    DisposeHandle(h);
}

/* 3: paranoid relocation sweep -- run only in the re-exec'd child. */
static void test_paranoid(void)
{
    Handle h1, h2;
    char *p;

    h1 = NewHandle(8);
    p = *h1;
    h2 = NewHandle(8);
    CHECK(*h1 != p, "paranoid: an unrelated allocation moved h1");

    HLock(h1);
    p = *h1;
    NewHandle(8); /* deliberately not disposed: exercises the sweep, not held */
    CHECK(*h1 == p, "paranoid: a locked handle is pinned across an allocation");
    HUnlock(h1);

    DisposeHandle(h1);
    DisposeHandle(h2);
}

/* 4: scramble -- disposed memory reads back as 0xA5. */
static void test_scramble(void)
{
    Handle h;
    char *q;

    h = NewHandle(4);
    q = *h;
    DisposeHandle(h);
    CHECK((unsigned char)q[0] == 0xA5, "disposed memory reads back scrambled 0xA5");
}

/* 5: NULL DisposeHandle/DisposePtr are no-ops (must not abort). */
static void test_null_dispose(void)
{
    DisposeHandle(NULL);
    DisposePtr(NULL);
    CHECK(1, "NULL DisposeHandle/DisposePtr did not abort");
}

/* 6: NewPtr never moves, even across an allocating Handle call. */
static void test_ptr_never_moves(void)
{
    Ptr p1;
    Handle h;

    p1 = NewPtr(8);
    CHECK(p1 != NULL, "NewPtr(8) returns non-NULL");
    p1[0] = 'z';
    h = NewHandle(8);
    CHECK(p1[0] == 'z', "a NewPtr block never relocates across an allocating call");
    DisposeHandle(h);
    DisposePtr(p1);
}

/* 7: rt_mem_note marks a block leak-by-design, dropping it from the count. */
static void test_note(void)
{
    Handle h;
    long before, after;

    before = rt_mem_live_count();
    h = NewHandle(4);
    CHECK(rt_mem_live_count() == before + 1, "live_count increments for a new handle");
    rt_mem_note(h, "by design");
    after = rt_mem_live_count();
    CHECK(after == before, "live_count drops back down once the block is noted");
}

/* 8: BlockMoveData's argument order is Toolbox src-first, unlike memmove. */
static void test_blockmove(void)
{
    char a[4];
    char b[4];

    memcpy(a, "abc", 4);
    memset(b, 0, 4);
    BlockMoveData(a, b, 4);
    CHECK(b[0] == 'a', "BlockMoveData copies src-first into dst");
}

/* 9: bulk Ptr churn -- exercises DisposePtr block-record recovery across
   index growth, probe collisions, and recycled payload addresses (the
   quarantine caps at 64 blocks / 1 MiB, so a mass dispose forces real
   free()s and near-certain address reuse by later NewPtr calls). */
static void test_ptr_churn(void)
{
    enum { CHURN_N = 5000 };
    static Ptr ps[CHURN_N];
    int i;
    long before;

    before = rt_mem_live_count();
    for (i = 0; i < CHURN_N; i++) {
        ps[i] = NewPtr(32);
        CHECK(ps[i] != NULL, "churn NewPtr non-NULL");
        ps[i][0] = (char)(i & 0x7F);
    }
    /* dispose evens first, then odds, so recovery sees interleaved holes */
    for (i = 0; i < CHURN_N; i += 2) DisposePtr(ps[i]);
    for (i = 1; i < CHURN_N; i += 2) {
        CHECK(ps[i][0] == (char)(i & 0x7F), "odd survivor intact after even mass-dispose");
        DisposePtr(ps[i]);
    }
    CHECK(rt_mem_live_count() == before, "all churn blocks disposed");
    /* fresh Ptrs after the mass dispose recycle freed payload addresses:
       dispose must resolve each to its NEW (live) record, not a dead one */
    for (i = 0; i < 128; i++) {
        Ptr q;

        q = NewPtr(32);
        CHECK(q != NULL, "recycle NewPtr non-NULL");
        q[0] = 'q';
        DisposePtr(q);
    }
    CHECK(rt_mem_live_count() == before, "recycled-address dispose resolved to the live record");
}

/* 10 + 11: the two DisposePtr diagnostics must still abort (the paranoid
   shim's whole reason to exist). Run in re-exec'd children, parent
   expects nonzero exit.

   The inner "2>/dev/null" only silences the child's own stderr (its
   abort() diagnostic). On a shell that reports signal deaths (macOS
   /bin/sh does, for any command it runs, interactive or not), the shell
   ITSELF writes a "Abort trap: 6" notification to its own stderr once
   the child dies -- unaffected by a redirect scoped to the child. That
   notification is only suppressable by redirecting the reporting
   shell's stderr from outside it, so this nests one more "sh -c" layer
   and redirects that whole layer's stderr too, keeping the parent's
   final stdout ("OK\n") the only output on a passing run. */
static void expect_child_abort(const char *argv0, const char *mode)
{
    char cmd[1024];
    int rc;

    if (argv0[0] == '/') {
        snprintf(cmd, sizeof cmd, "sh -c '%s %s 2>/dev/null' 2>/dev/null", argv0, mode);
    } else {
        snprintf(cmd, sizeof cmd, "sh -c './%s %s 2>/dev/null' 2>/dev/null", argv0, mode);
    }
    rc = system(cmd);
    if (rc == 0) {
        fprintf(stderr, "FAIL: %s child exited 0, expected abort\n", mode);
        failed = 1;
    }
}

int main(int argc, char **argv)
{
    if (argc > 1 && strcmp(argv[1], "paranoid") == 0) {
        test_paranoid();
        return failed ? 1 : 0;
    }
    if (argc > 1 && strcmp(argv[1], "doubledispose") == 0) {
        Ptr p;

        p = NewPtr(8);
        DisposePtr(p);
        DisposePtr(p); /* must abort: double dispose */
        return 0;
    }
    if (argc > 1 && strcmp(argv[1], "unrecognized") == 0) {
        char stackbuf[8];

        DisposePtr((Ptr)stackbuf); /* must abort: never allocated */
        return 0;
    }

    test_new_handle_and_resize();
    test_locked_resize();

    {
        char cmd[1024];
        int rc;
        if (argv[0][0] == '/') {
            snprintf(cmd, sizeof cmd, "CLARUS_MEM_PARANOID=1 %s paranoid", argv[0]);
        } else {
            snprintf(cmd, sizeof cmd, "CLARUS_MEM_PARANOID=1 ./%s paranoid", argv[0]);
        }
        rc = system(cmd);
        if (rc != 0) { fprintf(stderr, "FAIL: paranoid child exited %d\n", rc); failed = 1; }
    }

    test_scramble();
    test_null_dispose();
    test_ptr_never_moves();
    test_note();
    test_blockmove();
    test_ptr_churn();
    expect_child_abort(argv[0], "doubledispose");
    expect_child_abort(argv[0], "unrecognized");

    if (failed) {
        fprintf(stderr, "FAILED\n");
        return 1;
    }
    printf("OK\n");
    return 0;
}
