/* runtime/host/rt_rc_test.c -- hand-written C harness for the counted
 * text/list/map boxes (ARC Task 1: rc field + retain/release API,
 * rt_*_free aliased to rt_*_release). Standalone: includes rt.h, rt_mem.h,
 * rt_mem_host.inc, then rt_core.inc directly (no rt.c link), and supplies
 * the rt_panic stub rt_core.inc actually calls (rt_alert/rt_log/rt_quit are
 * declared in rt.h but never referenced by rt_core.inc, so they need no
 * stub here). Compiled + run host-side by rctest_c_test.go. Mirrors
 * rt_mem_test.c's style: assert via CHECK, "OK\n" on success; the
 * over-release check (7) forks a child and asserts SIGABRT since a normal
 * CHECK can't observe an abort() from the same process.
 */
#include "rt.h"
#include "rt_mem.h"
#include "rt_mem_host.inc"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

void rt_panic(const char *msg)
{
    fprintf(stderr, "runtime error: %s\n", msg);
    exit(3);
}

#include "rt_core.inc"

static int failed = 0;
#define CHECK(cond, msg) \
    do { if (!(cond)) { fprintf(stderr, "FAIL: %s (%s:%d)\n", msg, __FILE__, __LINE__); failed = 1; } } while (0)

/* Local mirror of the box header: rc is the first field of every box, so
   casting any box pointer to this and reading ->rc works regardless of
   which real struct (opaque via rt.h) it points at. */
struct rc_box_head { int32_t rc; };
#define RC_OF(box) (((struct rc_box_head *)(box))->rc)

static uint8_t *str255(const char *s)
{
    static uint8_t buf[256];
    size_t n = strlen(s);
    if (n > 255) n = 255;
    buf[0] = (uint8_t)n;
    memcpy(buf + 1, s, n);
    return buf;
}

/* 1: rt_text_new() starts at rc == 1. */
static void test_text_new_rc(void)
{
    rt_text *t = rt_text_new();
    CHECK(RC_OF(t) == 1, "rt_text_new: rc starts at 1");
    rt_text_release(t);
}

/* 2: retain -> release: value still usable after one release when rc was 2. */
static void test_retain_release_usable(void)
{
    rt_text *t = rt_text_new();
    rt_text_store(t, str255("hi"));
    rt_text_retain(t);
    CHECK(RC_OF(t) == 2, "retain: rc is 2");
    rt_text_release(t);
    CHECK(RC_OF(t) == 1, "release: rc back to 1");
    CHECK(rt_text_cmp_str(t, str255("hi")) == 0, "value still readable after one release");
    rt_text_store(t, str255("bye"));
    CHECK(rt_text_cmp_str(t, str255("bye")) == 0, "value still writable after one release");
    rt_text_release(t);
}

/* 3: release to zero disposes -- live count drops by 2 (box + data handle). */
static void test_release_to_zero_disposes(void)
{
    long before, after;
    rt_text *t;
    before = rt_mem_live_count();
    t = rt_text_new();
    CHECK(rt_mem_live_count() == before + 2, "new text is 2 live blocks (box + handle)");
    rt_text_release(t);
    after = rt_mem_live_count();
    CHECK(after == before, "release-to-zero drops live count back down by 2");
}

/* 4: NULL retain/release are no-ops. */
static void test_null_noop(void)
{
    rt_text_retain(NULL);
    rt_text_release(NULL);
    rt_list_retain(NULL);
    rt_list_release(NULL);
    rt_map_retain(NULL);
    rt_map_release(NULL);
    CHECK(1, "NULL retain/release did not crash");
}

/* 5: list and map -- same birth/retain/release/zero-dispose cycle. Map
   drops 3 blocks (keys + vals + box). */
static void test_list_and_map_cycle(void)
{
    long before, after;
    rt_list *l;
    rt_map *m;
    int32_t v;

    l = rt_list_new(sizeof(int32_t));
    CHECK(RC_OF(l) == 1, "rt_list_new: rc starts at 1");
    v = 42;
    rt_list_push(l, &v);
    rt_list_retain(l);
    CHECK(RC_OF(l) == 2, "list retain: rc is 2");
    rt_list_release(l);
    CHECK(RC_OF(l) == 1, "list release: rc back to 1");
    rt_list_at(l, 0); /* still usable */
    before = rt_mem_live_count();
    rt_list_release(l);
    after = rt_mem_live_count();
    CHECK(before - after == 2, "list release-to-zero drops live count by 2");

    m = rt_map_new(sizeof(int32_t));
    CHECK(RC_OF(m) == 1, "rt_map_new: rc starts at 1");
    v = 7;
    rt_map_set(m, str255("k"), &v);
    rt_map_retain(m);
    CHECK(RC_OF(m) == 2, "map retain: rc is 2");
    rt_map_release(m);
    CHECK(RC_OF(m) == 1, "map release: rc back to 1");
    CHECK(rt_map_has(m, str255("k")), "map still usable after one release");
    before = rt_mem_live_count();
    rt_map_release(m);
    after = rt_mem_live_count();
    /* map-hashtable phase Task 5: the hashtable rewrite added two more
       Handles (keypool, index) to the box, so a fresh map now drops 5
       blocks (keys+vals+keypool+index+box), not 3. */
    CHECK(before - after == 5, "map release-to-zero drops live count by 5 (keys+vals+keypool+index+box)");
}

/* 6: rt_text_free on an rc==1 value == release-to-zero (alias behavior). */
static void test_free_is_release_alias(void)
{
    long before, after;
    rt_text *t;
    before = rt_mem_live_count();
    t = rt_text_new();
    rt_text_free(t);
    after = rt_mem_live_count();
    CHECK(after == before, "rt_text_free on rc==1 disposes just like release");
}

/* 7: over-release abort -- fork a child that releases an already-zero box;
   assert it terminated by SIGABRT. */
static void test_over_release_aborts(void)
{
    pid_t pid;
    int status;

    pid = fork();
    if (pid < 0) {
        CHECK(0, "fork failed");
        return;
    }
    if (pid == 0) {
        rt_text *t = rt_text_new();
        freopen("/dev/null", "w", stderr); /* silence the expected abort message */
        rt_text_release(t); /* rc 1 -> 0, disposes */
        rt_text_release(t); /* over-release: must abort */
        _exit(0); /* unreached if the guard works */
    }
    waitpid(pid, &status, 0);
    CHECK(WIFSIGNALED(status) && WTERMSIG(status) == SIGABRT, "over-release aborts with SIGABRT");
}

/* 8 (ARC Task 6 fix round 3): rt_*_lastref -- true only at rc==1, false
   once retained, true again after the matching release, and NULL-safe
   false for all three kinds. */
static void test_lastref(void)
{
    rt_text *t = rt_text_new();
    rt_list *l = rt_list_new(sizeof(int32_t));
    rt_map *m = rt_map_new(sizeof(int32_t));

    CHECK(rt_text_lastref(t), "fresh text is its own last ref");
    rt_text_retain(t);
    CHECK(!rt_text_lastref(t), "retained text is not the last ref");
    rt_text_release(t);
    CHECK(rt_text_lastref(t), "text back to last ref after matching release");

    CHECK(rt_list_lastref(l), "fresh list is its own last ref");
    rt_list_retain(l);
    CHECK(!rt_list_lastref(l), "retained list is not the last ref");
    rt_list_release(l);
    CHECK(rt_list_lastref(l), "list back to last ref after matching release");

    CHECK(rt_map_lastref(m), "fresh map is its own last ref");
    rt_map_retain(m);
    CHECK(!rt_map_lastref(m), "retained map is not the last ref");
    rt_map_release(m);
    CHECK(rt_map_lastref(m), "map back to last ref after matching release");

    CHECK(!rt_text_lastref(NULL), "NULL text is never the last ref");
    CHECK(!rt_list_lastref(NULL), "NULL list is never the last ref");
    CHECK(!rt_map_lastref(NULL), "NULL map is never the last ref");

    rt_text_release(t);
    rt_list_release(l);
    rt_map_release(m);
}

int main(void)
{
    test_text_new_rc();
    test_retain_release_usable();
    test_release_to_zero_disposes();
    test_null_noop();
    test_list_and_map_cycle();
    test_free_is_release_alias();
    test_over_release_aborts();
    test_lastref();

    if (failed) {
        fprintf(stderr, "FAILED\n");
        return 1;
    }
    printf("OK\n");
    return 0;
}
