/* internal/build/rt/rt.c — host implementation of the Clarus runtime layer.
 * Host stand-in for the future Mac Toolbox runtime; free to use libc.
 *
 * String layout: a strN value is {uint8_t len; uint8_t b[N];}. Every
 * function here takes the raw pointer to the len byte, with the buffer's
 * declared capacity N passed alongside as a separate int (the len byte
 * itself is not part of that capacity count).
 */
#include "rt.h"
#include "rt_mem.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "rt_mem_host.inc"

void rt_panic(const char *msg) {
    fprintf(stderr, "runtime error: %s\n", msg);
    exit(3);
}

void rt_quit(int32_t code) {
    rt_run_cleanup();
    exit(code);
}

void rt_alert(const uint8_t *s) {
    uint8_t len = s[0];
    for (uint8_t i = 0; i < len; i++) {
        uint8_t c = s[1 + i];
        putchar(c == '\r' ? '\n' : c); /* CR (Mac newline) renders as LF on the host */
    }
    putchar('\n');
}

/* Diagnostic stream (Ch12): same CR->LF rendering as rt_alert, but to
   stderr rather than stdout. */
void rt_log(const uint8_t *s) {
    uint8_t len = s[0];
    for (uint8_t i = 0; i < len; i++) {
        uint8_t c = s[1 + i];
        fputc(c == '\r' ? '\n' : c, stderr);
    }
    fputc('\n', stderr);
}

/* Forward decl: rt_file_write_data is `static` and defined below (Task 1,
 * mac-target-4d), after this include point -- rt_ext_host.inc's
 * rt_ext_FileWriteData wrapper (Plan 5b Task 3) needs it in scope here
 * rather than moving the definition up. */
static int rt_file_write_data(const uint8_t *path, const rt_text *t);

#include "rt_core.inc"
#include "rt_ext_host.inc"

/* ==================== CLI args ====================
 * ponytail: this is already the full Task-4 implementation (there's nothing
 * simpler to stub) — argv is just stashed, and rt_args_list() lazily builds
 * a str255 rt_list from it once, the same construction rt_str_from_bytes
 * would produce for each element.
 */
static int g_argc = 0;
static char **g_argv = NULL;
static rt_list *g_args_list = NULL;

void rt_args_init(int argc, char **argv) {
    g_argc = argc;
    g_argv = argv;
    g_args_list = NULL; /* rebuild lazily on next rt_args_list() call */

    /* Every emitted main() calls this first, before any Clarus code runs --
     * unlike rt_mem_alloc_block's own atexit registration (which only fires
     * once something is actually allocated), this guarantees the
     * CLARUS_MEM_STRICT leak report gets written even for a program that
     * allocates nothing through rt_mem at all (trivially zero leaks, but
     * previously silent: no allocation ever happened => no report ever
     * written => the differential harness saw a missing file, not a 0). */
    if (!rt_mem_atexit_done) {
        rt_mem_atexit_done = 1;
        atexit(rt_mem_exit_check);
    }
}

rt_list *rt_args_list(void) {
    if (g_args_list == NULL) {
        g_args_list = rt_list_new(256); /* str255 layout: 1 len byte + 255 data bytes */
        for (int i = 1; i < g_argc; i++) {
            uint8_t arg[256] = {0};
            size_t n = strlen(g_argv[i]);
            if (n > 255) n = 255;
            memmove(arg + 1, g_argv[i], n);
            arg[0] = (uint8_t)n;
            rt_list_push(g_args_list, arg);
        }
        rt_list_note(g_args_list, "rt_args_list: process-lifetime argv snapshot"); /* ponytail: never freed by cl_free_globals -- not a program global, exempt by design */
    }
    return g_args_list;
}

/* ==================== files (Task 13) ==================== */

/* path255 is at most 255 bytes; buf holds it plus a NUL terminator for the
 * libc file calls. */
static void path_to_cstr(char *buf, const uint8_t *path255) {
    uint8_t n = path255[0];
    memmove(buf, path255 + 1, (size_t)n);
    buf[n] = '\0';
}

int rt_file_read_text(const uint8_t *path, rt_text *t) {
    char cpath[256];
    path_to_cstr(cpath, path);
    FILE *f = fopen(cpath, "rb");
    if (!f) {
        rt_set_lasterr(2, "could not open file");
        return 0;
    }
    if (fseek(f, 0, SEEK_END) != 0) {
        fclose(f);
        rt_set_lasterr(2, "could not read file");
        return 0;
    }
    long sz = ftell(f);
    if (sz < 0 || fseek(f, 0, SEEK_SET) != 0) {
        fclose(f);
        rt_set_lasterr(2, "could not read file");
        return 0;
    }
    rt_text_grow(t, (int32_t)sz);
    size_t got = sz > 0 ? fread(*t->h, 1, (size_t)sz, f) : 0;
    fclose(f);
    if ((long)got != sz) {
        rt_set_lasterr(2, "could not read file");
        return 0;
    }
    t->len = (int32_t)sz;
    return 1;
}

int rt_file_write_text(const uint8_t *path, const rt_text *t) {
    char cpath[256];
    path_to_cstr(cpath, path);
    FILE *f = fopen(cpath, "wb");
    if (!f) {
        rt_set_lasterr(2, "could not open file");
        return 0;
    }
    size_t wrote = t->len > 0 ? fwrite(*t->h, 1, (size_t)t->len, f) : 0;
    int closeErr = fclose(f);
    if ((int32_t)wrote != t->len || closeErr != 0) {
        rt_set_lasterr(2, "could not write file");
        return 0;
    }
    return 1;
}

void rt_file_name(uint8_t *dst255, const uint8_t *path) {
    uint8_t n = path[0];
    int start = 0;
    for (int i = 0; i < n; i++) {
        if (path[1 + i] == '/') start = i + 1;
    }
    uint8_t len = n - (uint8_t)start;
    memmove(dst255 + 1, path + 1 + start, (size_t)len);
    dst255[0] = len;
}

/* ==================== serialization (Task 1, mac-target-4d) ====================
 * rt_ser.inc's own per-runtime primitive: a fopen/fwrite clone of
 * rt_file_write_text above (no type/creator concept on the host
 * filesystem, unlike the Mac 'CLRD' file). */
static int rt_file_write_data(const uint8_t *path, const rt_text *t) {
    char cpath[256];
    path_to_cstr(cpath, path);
    FILE *f = fopen(cpath, "wb");
    if (!f) {
        rt_set_lasterr(2, "could not open file");
        return 0;
    }
    size_t wrote = t->len > 0 ? fwrite(*t->h, 1, (size_t)t->len, f) : 0;
    int closeErr = fclose(f);
    if ((int32_t)wrote != t->len || closeErr != 0) {
        rt_set_lasterr(2, "could not write file");
        return 0;
    }
    return 1;
}

#include "rt_ser.inc"
