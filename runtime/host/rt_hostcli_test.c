/* runtime/host/rt_hostcli_test.c -- C harness for the `clarusc build`
 * host primitives in rt_ext_host.inc (installed-toolchain Task 1):
 * HostGetEnv, HostDefaultDataDir/Cc, HostSpawn, HostMkTemp. Same shape
 * as rt_fileh_test.c: CHECK macro, "OK\n" on success. Run by
 * tests/hostrt/hostcli.sh; with -DEXPECT_DATADIR='"..."' (and the same
 * value as -DCLARUS_DATADIR) it checks the build-time override. */
#include "rt.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

extern int32_t rt_ext_HostGetEnv(const uint8_t *name, rt_text *out);
extern void    rt_ext_HostDefaultDataDir(rt_text *out);
extern void    rt_ext_HostDefaultCc(rt_text *out);
extern int32_t rt_ext_HostSpawn(rt_text *argv);
extern int32_t rt_ext_HostMkTemp(rt_text *out);

#ifndef EXPECT_DATADIR
#define EXPECT_DATADIR "/usr/local/share/clarus"
#endif

static int failed = 0;
#define CHECK(cond, msg) \
    do { if (!(cond)) { fprintf(stderr, "FAIL: %s (%s:%d)\n", msg, __FILE__, __LINE__); failed = 1; } } while (0)

/* text contents as a NUL-terminated C string (static buffer). */
static const char *cstr(const rt_text *t)
{
    static char buf[1024];
    int32_t n = rt_text_to_bytes(t, (uint8_t *)buf, (int)sizeof buf - 1);
    buf[n] = '\0';
    return buf;
}

/* spawn an argv given as a C literal of NUL-terminated args, n bytes. */
static int32_t spawn(const char *args, int n)
{
    rt_text *t = rt_text_new();
    int32_t r;
    rt_text_from_bytes(t, (const uint8_t *)args, n, n);
    r = rt_ext_HostSpawn(t);
    rt_text_free(t);
    return r;
}
#define SPAWN(lit) spawn(lit, (int)sizeof(lit) - 1)

int main(void)
{
    rt_text *t = rt_text_new();
    char a[1024];
    struct stat st;
    size_t n;

    /* getenv_set / getenv_empty / getenv_unset */
    setenv("X_T", "abc", 1);
    CHECK(rt_ext_HostGetEnv((const uint8_t *)"\3X_T", t) == 1, "getenv_set returns 1");
    CHECK(strcmp(cstr(t), "abc") == 0, "getenv_set value");
    setenv("X_T", "", 1);
    rt_text_store(t, (const uint8_t *)"\3old");
    CHECK(rt_ext_HostGetEnv((const uint8_t *)"\3X_T", t) == 1, "getenv_empty returns 1");
    CHECK(rt_text_len(t) == 0, "getenv_empty value");
    unsetenv("X_T");
    rt_text_store(t, (const uint8_t *)"\3old");
    CHECK(rt_ext_HostGetEnv((const uint8_t *)"\3X_T", t) == 0, "getenv_unset returns 0");
    CHECK(rt_text_len(t) == 0, "getenv_unset empties out");

    /* default_datadir / default_cc */
    rt_ext_HostDefaultDataDir(t);
    CHECK(strcmp(cstr(t), EXPECT_DATADIR) == 0, "default_datadir");
    rt_ext_HostDefaultCc(t);
    CHECK(strcmp(cstr(t), "cc") == 0, "default_cc");

    /* spawn_* */
    CHECK(SPAWN("true\0") == 0, "spawn_true");
    CHECK(SPAWN("sh\0-c\0exit 3\0") == 3, "spawn_exit3");
    CHECK(SPAWN("sh\0-c\0test \"$1\" = 'a b'\0x\0a b\0") == 0, "spawn_space_arg");
    {
        int32_t r = SPAWN("/nonexistent/x\0");
        CHECK(r == -1 || r == 127, "spawn_missing is -1 or 127");
        CHECK(r != 0, "spawn_missing never 0");
    }
    CHECK(SPAWN("sh\0-c\0kill -9 $$\0") == 128 + 9, "spawn_signal");

    /* mktemp: file exists, ends .c, two calls differ */
    CHECK(rt_ext_HostMkTemp(t) == 1, "mktemp returns 1");
    strcpy(a, cstr(t));
    n = strlen(a);
    CHECK(n > 2 && strcmp(a + n - 2, ".c") == 0, "mktemp path ends .c");
    CHECK(stat(a, &st) == 0, "mktemp file exists");
    CHECK(rt_ext_HostMkTemp(t) == 1, "mktemp second returns 1");
    CHECK(strcmp(a, cstr(t)) != 0, "mktemp two calls differ");
    remove(a);
    remove(cstr(t));

    rt_text_free(t);
    if (failed) return 1;
    printf("OK\n");
    return 0;
}
