/* runtime/host/rt.c — host implementation of the Clarus runtime layer.
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
#include <time.h>
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
static int rt_file_write_data(const uint8_t *path, const rt_text *t, const uint8_t *type255, const uint8_t *creator255);

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

/* rt_fh_posix_path: HFS spelling -> POSIX (filesystem-api Task 4, spec
 * %4.4): a leading ':' is dropped, every other ':' becomes '/'. A path
 * with no colon is unchanged; a full path "Vol:a:b" becomes the relative
 * "Vol/a/b" (documented, not special-cased -- spec %4.4's own note).
 * Lives here, directly above path_to_cstr (which calls it right after the
 * memmove), so EVERY path-taking C entry point in this file AND in
 * rt_fileh.inc (#included below, so it cannot define this helper itself)
 * gets the translation for free through this one hook: rt_file_read_text/
 * write_text/save/load/name above and below, plus every rt_ext_FhH* in
 * rt_fileh.inc, existing and new. */
static void rt_fh_posix_path(char *buf) {
    char *s = buf;
    char *d = buf;
    if (*s == ':') s++;
    for (; *s; s++, d++) *d = (*s == ':') ? '/' : *s;
    *d = '\0';
}

/* path255 is at most 255 bytes; buf holds it plus a NUL terminator for the
 * libc file calls, then gets the HFS->POSIX translation above applied. */
static void path_to_cstr(char *buf, const uint8_t *path255) {
    uint8_t n = path255[0];
    memmove(buf, path255 + 1, (size_t)n);
    buf[n] = '\0';
    rt_fh_posix_path(buf);
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

int rt_file_write_text(const uint8_t *path, const rt_text *t, const uint8_t *type255, const uint8_t *creator255) {
    (void)type255; (void)creator255; /* no type/creator concept on the host filesystem (see rt_file_write_data below) */
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

/* rt_file_read_resource/rt_file_write_res (Task 7, mac-resident-clarusc):
 * host-only stubs -- this filesystem has no resource-fork concept at all,
 * so both always fail. Real implementations are runtime/clarus/native.cla's
 * natReadResource/natWriteRes (Mac lane only). */
int rt_file_read_resource(const uint8_t *name, rt_text *t) {
    (void)name; (void)t;
    rt_set_lasterr(2, "resources not supported on this platform");
    return 0;
}

int rt_file_write_res(const uint8_t *path, const rt_text *t, const uint8_t *type255, const uint8_t *creator255) {
    (void)path; (void)t; (void)type255; (void)creator255;
    rt_set_lasterr(2, "resources not supported on this platform");
    return 0;
}

/* rt_file_name: the display name is the last POSIX component of the
 * TRANSLATED path (filesystem-api Task 4, spec %4.4 ruling) -- routes
 * through path_to_cstr for the same ':'->'/' translation every other
 * path-taking call gets, then splits on the last '/'; a bare name (no
 * colon in the original, so no '/' after translation) is unchanged. */
void rt_file_name(uint8_t *dst255, const uint8_t *path) {
    char cpath[256];
    path_to_cstr(cpath, path);
    size_t n = strlen(cpath);
    size_t start = 0;
    for (size_t i = 0; i < n; i++) {
        if (cpath[i] == '/') start = i + 1;
    }
    uint8_t len = (uint8_t)(n - start);
    memmove(dst255 + 1, cpath + start, (size_t)len);
    dst255[0] = len;
}

/* ==================== serialization (Task 1, mac-target-4d) ====================
 * rt_ser.inc's own per-runtime primitive: a fopen/fwrite clone of
 * rt_file_write_text above (no type/creator concept on the host
 * filesystem, unlike the Mac 'CLRD' file). type255/creator255
 * (native-gaps-cleanup Task 2) are accepted and ignored, same as
 * rt_file_write_text above -- see that function's own comment. */
static int rt_file_write_data(const uint8_t *path, const rt_text *t, const uint8_t *type255, const uint8_t *creator255) {
    (void)type255; (void)creator255;
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

/* Serial connection glue (2026-08-15 serial-connection spec, Task 4): host
 * TCP stand-in for the SCC, only spliced into a build that actually calls
 * it (conn.cla + conn_c.cla, usage-gated by drive.cla) -- unconditionally
 * included here regardless, same as rt_ser.inc above: it's cheap dead
 * weight in an unused build and every rt_ext_ConnH* symbol only gets
 * referenced (and thus only gets linked) when the Clarus side actually
 * calls it. */
#include "rt_serial.inc"

/* Filehandle glue (2026-08-22 binary-files spec, Task 5): host pread/pwrite
 * stand-in for the `filehandle` type's positioned file I/O, only spliced
 * into a build that actually calls it (fileh.cla + fileh_c.cla, usage-
 * gated by drive.cla) -- unconditionally included here regardless, same as
 * rt_serial.inc above: cheap dead weight in an unused build, and every
 * rt_ext_FhH* symbol only gets referenced (and thus only gets linked) when
 * the Clarus side actually calls it. */
#include "rt_fileh.inc"

/* AppleTalk glue (2026-09-06 appletalk spec %6.1, Task 2): the host's own
 * LocalTalk-over-UDP stack -- LLAP/DDP/NBP/ATP over multicast
 * 239.192.76.84:1954, the same wire the Mini vMac and Snow emulators are
 * on. Included after rt_serial.inc (whose CLARUS_ATALK_IFACE-less serial
 * slots it shares nothing with) and unconditionally, same as every .inc
 * above: cheap dead weight in a build that never calls it, since each
 * rt_ext_AtalkH* symbol is only referenced -- and so only linked -- when
 * the Clarus side actually calls it. */
#include "rt_atalk.inc"
