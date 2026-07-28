/* runtime/mac/rt_mac.c -- Toolbox-native implementation of the Clarus
   runtime ABI (internal/build/rt/rt.h). Handles + BlockMoveData + Str255;
   no malloc, no console library. RT_MAC_TEST redirects alert/log/quit/panic
   for the corpus harness (Task 10).

   String layout matches Str255 exactly: a strN value is
   {uint8_t len; uint8_t b[N];}. The byte-logic functions below are ports
   of internal/build/rt/rt.c with IDENTICAL observable semantics (same
   clamping, same lastError codes/messages, same panic messages) --
   memmove is replaced with BlockMoveData (same argument order as memmove:
   BlockMoveData(src, dst, count)); memcmp/strlen stay as they are pure
   comparisons/measurement, not copies.

   text/list/map are Handle-backed (Task 9); file is File Manager-backed
   (Task 10); every symbol in rt.h is defined. */
#include "rt.h"
#include "rt_mem.h"
#include <Dialogs.h>
#include <Files.h>
#include <Memory.h>
#include <Quickdraw.h>
#include <Fonts.h>
#include <Windows.h>
#include <Menus.h>
#include <TextEdit.h>
#include <string.h>
#ifdef RT_MAC_TEST
#include <stdio.h>
#include <stdlib.h>
#endif

static int rt_mac_inited = 0;

static void rt_mac_toolbox_init(void)
{
    if (rt_mac_inited) return;
    InitGraf(&qd.thePort);
    InitFonts();
    InitWindows();
    InitMenus();
    TEInit();
    InitDialogs(NULL);
    InitCursor();
    rt_mac_inited = 1;
}

/* Non-static wrapper so runtime/mac/rt_ui.c (Task 1, mac-target-4b) can
   force eager Toolbox init from rt_ui_startup, reusing this exact routine
   instead of duplicating InitGraf/InitFonts/... -- idempotent same as the
   static version above (rt_mac_inited guards both). No other rt_mac.c
   behavior changes. */
void rt_mac_init_toolbox(void) { rt_mac_toolbox_init(); }

#ifndef RT_MAC_TEST
void rt_alert(const uint8_t *s)
{
    Str255 msg;
    rt_mac_toolbox_init();
    BlockMoveData(s + 1, msg + 1, s[0]);
    msg[0] = s[0];
    ParamText(msg, "\p", "\p", "\p");
    NoteAlert(128, NULL);
}

void rt_log(const uint8_t *s) { (void)s; } /* no stderr on System 6; 4b revisits */

void rt_quit(int32_t code) { (void)code; rt_run_cleanup(); ExitToShell(); }

void rt_panic(const char *msg)
{
    Str255 p;
    int n = 0;
    const char *pre = "runtime error: ";
    rt_mac_toolbox_init();
    while (*pre && n < 255) p[++n] = *pre++;
    while (*msg && n < 255) p[++n] = *msg++;
    p[0] = n;
    ParamText(p, "\p", "\p", "\p");
    StopAlert(128, NULL);
    ExitToShell();
}
#else
/* ==================== RT_MAC_TEST: single-file capture build (Task 10) ====
 *
 * LaunchAPPL only ever echoes back a file literally named `out` on the
 * boot volume once the emulated app quits (see
 * internal/mactest/probe/FINDINGS.md) -- there is no second output
 * channel -- so every stream this build produces multiplexes into that
 * one file:
 *
 *   - rt_alert appends its bytes live: CR->LF (Mac newline rendered as
 *     the host's LF) plus a trailing LF, byte-identical to host
 *     rt_alert's stdout stream (internal/build/rt/rt.c).
 *   - rt_log instead buffers (same CR->LF + trailing LF, matching host
 *     rt_log's stderr stream) into an in-memory rt_text; it is NOT
 *     written to `out` during the run.
 *   - At exit -- normal main return, rt_quit, or rt_panic -- an atexit
 *     handler appends the trailer
 *         ##CLARUS-EXIT## <decimal code>\n##CLARUS-LOG##\n
 *     followed by the buffered log bytes, then FSCloses + FlushVols and
 *     calls ExitToShell(). The handler is registered once, the first
 *     time any of alert/log/quit/panic touches the capture file
 *     (rt_test_open, guarded by its own static so repeat calls are a
 *     no-op), and rt_test_done guards the trailer itself against being
 *     written twice.
 */

static short    rt_test_ref = -1;   /* refnum for `out`, cached across calls */
static rt_text *rt_test_log = NULL; /* buffered rt_log bytes; flushed at exit */
static int32_t  rt_test_code = 0;   /* pending exit code; 0 = normal main return */
static int      rt_test_done = 0;   /* guard: write the exit trailer only once */

static void rt_test_atexit(void);
static void rt_test_flush_log(void); /* defined after struct rt_text (below) is visible */

/* Opens (creating if needed) `out` on the default volume and registers
   the exit-trailer handler, once. Safe to call from every capture entry
   point (rt_alert/rt_log/rt_quit/rt_panic) -- idempotent after the first
   call, so whichever of those four the program hits first is the one
   that wires up the atexit handler. */
static void rt_test_open(void)
{
    static int tried = 0;
    if (tried) return;
    tried = 1;
    /* dupFNErr if LaunchAPPL pre-created `out` (it does); ignored either
       way -- FSOpen just below is the real success/failure gate. */
    Create((const unsigned char *)"\pout", 0, 'MPS ', 'TEXT');
    if (FSOpen((const unsigned char *)"\pout", 0, &rt_test_ref) != noErr) {
        rt_test_ref = -1;
        return;
    }
    SetEOF(rt_test_ref, 0);
    atexit(rt_test_atexit);
}

/* Appends raw bytes at the current file mark (always EOF: nothing here
   ever seeks) and flushes, so output written before a crash/hang stays
   visible on disk. */
static void rt_test_write(const uint8_t *buf, long n)
{
    long count;
    rt_test_open();
    if (rt_test_ref < 0 || n <= 0) return;
    count = n;
    FSWrite(rt_test_ref, &count, buf);
    FlushVol(NULL, 0);
}

/* Exposed for runtime/mac/rt_ui.c (Task 3, mac-target-4b): the shared hook
   every UI trace line and framebuffer snap chunk goes through, so they
   interleave into the SAME `out` capture stream as alert/log output ahead
   of the 4a exit trailer, byte-identically to how rt_alert already does it.
   `line` is a plain NUL-terminated C string (NOT a Str255 -- window/widget/
   menu names in rt_ui.h's descriptors are already plain `const char *`,
   so there is no Pascal-string count byte to strip here); a trailing '\n'
   is appended, matching the LF-terminated trace-line contract. Declared
   `extern` directly in rt_ui.c (same convention as rt_mac_init_toolbox
   just below) rather than added to the frozen internal/build/rt/rt.h. */
void rt_test_emit(const char *line)
{
    char buf[512];
    int n;
    n = 0;
    while (line[n] != '\0' && n < (int)sizeof(buf) - 1) { buf[n] = line[n]; n++; }
    buf[n++] = '\n';
    rt_test_write((const uint8_t *)buf, (long)n);
}

/* CR->LF plus a trailing LF -- the same rendering host rt_alert/rt_log
   apply before their own trailing newline (rt.c). dst must hold >=256
   bytes; returns the number of bytes written to dst (up to 256, for a
   255-byte str255 plus the trailing LF -- an int, NOT a uint8_t: 256
   wraps a uint8_t counter to 0, silently dropping the whole record). */
static int rt_test_crlf(uint8_t *dst, const uint8_t *s)
{
    uint8_t len, i;
    int n;
    len = s[0];
    n = 0;
    for (i = 0; i < len; i++) dst[n++] = (s[1 + i] == '\r') ? '\n' : s[1 + i];
    dst[n++] = '\n';
    return n;
}

void rt_alert(const uint8_t *s)
{
    uint8_t buf[256];
    rt_test_write(buf, (long)rt_test_crlf(buf, s));
}

void rt_log(const uint8_t *s)
{
    uint8_t buf[256];
    int n, i;
    rt_test_open();
    if (!rt_test_log) rt_test_log = rt_text_new();
    n = rt_test_crlf(buf, s);
    for (i = 0; i < n; i++) rt_text_append_char(rt_test_log, buf[i]);
}

static void rt_test_atexit(void)
{
    static const char pre[] = "##CLARUS-EXIT## ";
    static const char mid[] = "\n##CLARUS-LOG##\n";
    char num[16];
    int nlen;

    if (rt_test_done) return;
    rt_test_done = 1;
    rt_test_write((const uint8_t *)pre, (long)(sizeof(pre) - 1));
    nlen = sprintf(num, "%ld", (long)rt_test_code);
    rt_test_write((const uint8_t *)num, (long)nlen);
    rt_test_write((const uint8_t *)mid, (long)(sizeof(mid) - 1));
    rt_test_flush_log();
    if (rt_test_ref >= 0) {
        FSClose(rt_test_ref);
        FlushVol(NULL, 0);
    }
    ExitToShell();
}

void rt_quit(int32_t code)
{
    rt_run_cleanup();
    rt_test_open();
    rt_test_code = code;
    exit((int)code);
}

void rt_panic(const char *msg)
{
    static int reentered = 0; /* guards against rt_panic calling back into
        itself -- e.g. rt_text_new/rt_text_append_char below panicking
        "out of memory" while building the very log record this call is
        trying to write */
    const char *pre = "runtime error: ";
    rt_test_open();
    if (reentered) {
        static const char fallback[] = "runtime error: out of memory\n";
        rt_test_write((const uint8_t *)fallback, (long)(sizeof(fallback) - 1));
        rt_test_code = 3;
        exit(3);
    }
    reentered = 1;
    if (!rt_test_log) rt_test_log = rt_text_new();
    while (*pre) rt_text_append_char(rt_test_log, (uint8_t)*pre++);
    while (*msg) rt_text_append_char(rt_test_log, (uint8_t)*msg++);
    rt_text_append_char(rt_test_log, '\n');
    rt_test_code = 3;
    exit(3);
}
#endif

/* emitted main() always calls this first (cprint.go's emitMain), before
   anything else -- in RT_MAC_TEST this is what guarantees the exit
   trailer gets registered even for a program that never calls
   alert/log/quit/panic, not just whichever of those four happens to run
   first. */
void rt_args_init(int argc, char **argv)
{
    (void)argc;
    (void)argv;
#ifdef RT_MAC_TEST
    rt_test_open();
#endif
}

rt_list *rt_args_list(void)
{
    static rt_list *args = NULL;
    if (!args) args = rt_list_new(256);
    return args;
}

#include "rt_core.inc"

#ifdef RT_MAC_TEST
/* Writes the buffered rt_log bytes (rt_test_log, a plain rt_text) to the
   capture file in one shot. Defined here rather than up in the RT_MAC_TEST
   block above because struct rt_text isn't visible until this point in
   the file; rt_test_atexit calls it through the forward declaration. */
static void rt_test_flush_log(void)
{
    if (rt_test_log) rt_test_write((const uint8_t *)*rt_test_log->h, (long)rt_test_log->len);
}
#endif

/* ==================== files ====================
 * File Manager port of internal/build/rt/rt.c's files (Task 13): same
 * lastError codes/messages on failure, same rt_file_name basename
 * semantics (byte scan for '/', identical to the host -- this is a pure
 * string algorithm, not an OS path convention, so it is ported as-is
 * rather than adapted to Mac's ':' separator). Paths are str255 values
 * taken as-is on the default volume (vRefNum 0): no cstr conversion, no
 * ':'-splitting -- ConstStr255Param has the same [len][bytes] layout a
 * strN value already has. Created files get type 'TEXT', creator 'MPS ',
 * the same File Manager pattern the probe (internal/mactest/probe/probe.c)
 * proved: Create/FSOpen/SetEOF/FSWrite/FSClose/FlushVol to write; GetEOF
 * + FSRead to read. */

int rt_file_read_text(const uint8_t *path, rt_text *t)
{
    short ref;
    long eof, got;

    if (FSOpen(path, 0, &ref) != noErr) {
        rt_set_lasterr(2, "could not open file");
        return 0;
    }
    if (GetEOF(ref, &eof) != noErr) {
        FSClose(ref);
        rt_set_lasterr(2, "could not read file");
        return 0;
    }
    rt_text_grow(t, (int32_t)eof);
    got = eof;
    if (eof > 0 && FSRead(ref, &got, *t->h) != noErr) {
        FSClose(ref);
        rt_set_lasterr(2, "could not read file");
        return 0;
    }
    FSClose(ref);
    if (got != eof) {
        rt_set_lasterr(2, "could not read file");
        return 0;
    }
    t->len = (int32_t)eof;
    return 1;
}

int rt_file_write_text(const uint8_t *path, const rt_text *t)
{
    short ref;
    long count;

    /* dupFNErr if the file already exists; ignored either way -- FSOpen
       just below is the real success/failure gate (matches the host's
       fopen(path, "wb"), which also just opens-or-truncates). */
    Create(path, 0, 'MPS ', 'TEXT');
    if (FSOpen(path, 0, &ref) != noErr) {
        rt_set_lasterr(2, "could not open file");
        return 0;
    }
    SetEOF(ref, 0);
    count = t->len;
    if (t->len > 0 && FSWrite(ref, &count, *t->h) != noErr) {
        FSClose(ref);
        FlushVol(NULL, 0);
        rt_set_lasterr(2, "could not write file");
        return 0;
    }
    FSClose(ref);
    FlushVol(NULL, 0);
    if (count != t->len) {
        rt_set_lasterr(2, "could not write file");
        return 0;
    }
    return 1;
}

void rt_file_name(uint8_t *dst255, const uint8_t *path)
{
    uint8_t n, start, i, len;
    n = path[0];
    start = 0;
    for (i = 0; i < n; i++) {
        if (path[1 + i] == '/') start = (uint8_t)(i + 1);
    }
    len = (uint8_t)(n - start);
    BlockMoveData(path + 1 + start, dst255 + 1, (Size)len);
    dst255[0] = len;
}

/* Weak default for rt.h's rt_app_creator -- '????' until clarusc emits a
   strong definition for a program whose `app` section declares an id
   (Task 2). rt_mac.c is in every Mac link (unlike rt_ui.c), so CLI-only
   programs still resolve this symbol. Same weak/strong precedent as
   rt_ui.c's rt_ui_app_info. */
const unsigned long rt_app_creator __attribute__((weak)) = 0x3F3F3F3FUL; /* '????' */

/* ==================== serialization (Task 1, mac-target-4d) ====================
 * rt_ser.inc's own per-runtime primitive: same File Manager shape as
 * rt_file_write_text above, but type 'CLRD' (not 'TEXT') and creator
 * rt_app_creator (not the fixed 'MPS ') -- so saved data files stay
 * distinguishable from documents in the Finder. */
static int rt_file_write_data(const uint8_t *path, const rt_text *t)
{
    short ref;
    long count;

    Create(path, 0, rt_app_creator, 'CLRD');
    if (FSOpen(path, 0, &ref) != noErr) {
        rt_set_lasterr(2, "could not open file");
        return 0;
    }
    SetEOF(ref, 0);
    count = t->len;
    if (t->len > 0 && FSWrite(ref, &count, *t->h) != noErr) {
        FSClose(ref);
        FlushVol(NULL, 0);
        rt_set_lasterr(2, "could not write file");
        return 0;
    }
    FSClose(ref);
    FlushVol(NULL, 0);
    if (count != t->len) {
        rt_set_lasterr(2, "could not write file");
        return 0;
    }
    return 1;
}

#include "rt_ser.inc"
