/* internal/build/rt/rt_mem_host.inc -- host implementation of rt_mem.h's
 * memory seam: a paranoid host-only Memory Manager shim. Real double
 * indirection (a Handle IS the address of a block record's first field,
 * so it survives relocation and even dispose), relocation-on-resize,
 * MacsBug-style scramble of freed/moved-from memory, guard bytes around
 * every block, and a ledger of live allocations for leak reporting.
 *
 * #include "rt_mem.h" then this file directly (rt_mem_test.c does this
 * standalone; rt.c will do the same once Task 2 wires rt_run_cleanup).
 * Guarded against multiple inclusion, matching the header-guard shape of
 * every other .h/.inc in this tree even though it is never #included
 * twice in one translation unit today.
 */
#ifndef CLARUS_RT_MEM_HOST_INC
#define CLARUS_RT_MEM_HOST_INC

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define RT_MEM_GUARD_LEN 8
#define RT_MEM_GUARD_BYTE 0x47
#define RT_MEM_SCRAMBLE_BYTE 0xA5

/* Quarantine caps for rt_mem_retire_raw (below): whichever trips first. */
#define RT_MEM_QUARANTINE_MAX_BLOCKS 64
#define RT_MEM_QUARANTINE_MAX_BYTES (1024L * 1024L)

/* Block record. The Handle a caller holds is &b->p, and because p is the
   FIRST member, (rt_mem_block *)h recovers the record. Records are
   malloc'd individually and never freed (ledger keeps dead records to
   catch double-dispose); a freed record slot is not reused. */
typedef struct rt_mem_block {
    Ptr p;                    /* master pointer; NULL once disposed */
    Size size;
    unsigned char locked, noted, is_ptr, live;
    const char *tag;
    struct rt_mem_block *next; /* all-blocks list head: rt_mem_blocks */
} rt_mem_block;

static rt_mem_block *rt_mem_blocks = NULL;
static OSErr rt_mem_err = noErr;
static int rt_mem_paranoid_flag = -1; /* -1 = not yet read from env */
static int rt_mem_atexit_done = 0;

/* Defined by Task 2 (rt_core.inc); on the host it runs registered
   per-collection cleanup before the leak report below is written. The
   standalone rt_mem_test.c supplies its own no-op stub. */
extern void rt_run_cleanup(void);

static void rt_mem_exit_check(void);

static void rt_mem_fill_guards(unsigned char *raw, Size size)
{
    memset(raw, RT_MEM_GUARD_BYTE, RT_MEM_GUARD_LEN);
    memset(raw + RT_MEM_GUARD_LEN + size, RT_MEM_GUARD_BYTE, RT_MEM_GUARD_LEN);
}

static void rt_mem_check_guards(rt_mem_block *b)
{
    unsigned char *raw;
    unsigned char *tail;
    int i;

    raw = (unsigned char *)b->p - RT_MEM_GUARD_LEN;
    tail = (unsigned char *)b->p + b->size;
    for (i = 0; i < RT_MEM_GUARD_LEN; i++) {
        if (raw[i] != RT_MEM_GUARD_BYTE || tail[i] != RT_MEM_GUARD_BYTE) {
            fprintf(stderr, "rt_mem: guard smashed at %s\n", b->tag);
            abort();
        }
    }
}

/* FIFO quarantine node for rt_mem_retire_raw: a scrambled raw block sits
   here (still resident, still readable, still poisoned) until the
   quarantine's size or byte cap is exceeded, at which point the oldest
   entries are actually free()'d. */
typedef struct rt_mem_qnode {
    unsigned char *raw;
    size_t rawsize;
    struct rt_mem_qnode *next;
} rt_mem_qnode;

static rt_mem_qnode *rt_mem_qhead = NULL; /* oldest */
static rt_mem_qnode *rt_mem_qtail = NULL; /* newest */
static int rt_mem_qcount = 0;
static size_t rt_mem_qbytes = 0;

static void rt_mem_quarantine_evict(void)
{
    rt_mem_qnode *node;

    while ((rt_mem_qcount > RT_MEM_QUARANTINE_MAX_BLOCKS
            || (long)rt_mem_qbytes > RT_MEM_QUARANTINE_MAX_BYTES)
           && rt_mem_qhead != NULL) {
        node = rt_mem_qhead;
        rt_mem_qhead = node->next;
        if (rt_mem_qhead == NULL) rt_mem_qtail = NULL;
        rt_mem_qcount--;
        rt_mem_qbytes -= node->rawsize;
        free(node->raw);
        free(node);
    }
}

/* Scrambles a moved-from/disposed raw block, then quarantines it rather
   than freeing it immediately: some allocators (macOS's tiny zone,
   confirmed empirically here) write live freelist bookkeeping into a
   chunk the instant free() runs, overwriting exactly the poison bytes a
   use-after-free test wants to read back. But this file backs every host
   binary once Task 2 wires it into rt.c -- including full clarusc
   bootstrap compiles -- so leaking every disposal forever would grow
   with allocation churn, not live-set size.
   ponytail: bounded FIFO quarantine, capped at RT_MEM_QUARANTINE_MAX_BLOCKS
   (64) blocks or RT_MEM_QUARANTINE_MAX_BYTES (1 MiB) total, whichever
   trips first -- past the cap the oldest quarantined blocks are actually
   free()'d. Recently-disposed memory (what the scramble-readback test
   reads) stays poisoned; long-run churn is bounded. Raise the caps if a
   test needs poisoned memory to survive more churn than that. */
static void rt_mem_retire_raw(unsigned char *raw, Size size)
{
    rt_mem_qnode *node;
    size_t rawsize;

    rawsize = (size_t)size + 2 * RT_MEM_GUARD_LEN;
    memset(raw, RT_MEM_SCRAMBLE_BYTE, rawsize);

    node = malloc(sizeof(rt_mem_qnode));
    if (node == NULL) {
        /* Can't track it for delayed free -- free now rather than leak
           unconditionally. */
        free(raw);
        return;
    }
    node->raw = raw;
    node->rawsize = rawsize;
    node->next = NULL;
    if (rt_mem_qtail != NULL) rt_mem_qtail->next = node; else rt_mem_qhead = node;
    rt_mem_qtail = node;
    rt_mem_qcount++;
    rt_mem_qbytes += rawsize;

    rt_mem_quarantine_evict();
}

/* Never called on locked or is_ptr blocks -- callers (rt_mem_upheaval,
   rt_mem_set_handle_size) filter those out before calling. */
static void rt_mem_relocate(rt_mem_block *b)
{
    unsigned char *newraw;
    unsigned char *oldraw;

    newraw = malloc((size_t)b->size + 2 * RT_MEM_GUARD_LEN);
    if (newraw == NULL) {
        rt_mem_err = memFullErr;
        return;
    }
    memcpy(newraw + RT_MEM_GUARD_LEN, b->p, (size_t)b->size);
    rt_mem_fill_guards(newraw, b->size);

    oldraw = (unsigned char *)b->p - RT_MEM_GUARD_LEN;
    rt_mem_retire_raw(oldraw, b->size);

    b->p = (Ptr)(newraw + RT_MEM_GUARD_LEN);
}

static int rt_mem_is_paranoid(void)
{
    if (rt_mem_paranoid_flag < 0) {
        rt_mem_paranoid_flag = (getenv("CLARUS_MEM_PARANOID") != NULL) ? 1 : 0;
    }
    return rt_mem_paranoid_flag;
}

/* ponytail: relocation sweep is O(live blocks) per allocation under
   PARANOID; fine for corpus-sized programs, do not enable it for
   bootstrap-scale runs */
static void rt_mem_upheaval(void)
{
    rt_mem_block *b;

    if (!rt_mem_is_paranoid()) return;
    for (b = rt_mem_blocks; b != NULL; b = b->next) {
        if (b->live && !b->locked && !b->is_ptr) {
            rt_mem_relocate(b);
        }
    }
}

static rt_mem_block *rt_mem_alloc_block(Size n, int clear, const char *tag, int is_ptr)
{
    unsigned char *raw;
    rt_mem_block *b;

    raw = malloc((size_t)n + 2 * RT_MEM_GUARD_LEN);
    if (raw == NULL) {
        rt_mem_err = memFullErr;
        return NULL;
    }
    if (clear) memset(raw + RT_MEM_GUARD_LEN, 0, (size_t)n);
    rt_mem_fill_guards(raw, n);

    b = malloc(sizeof(rt_mem_block));
    if (b == NULL) {
        free(raw);
        rt_mem_err = memFullErr;
        return NULL;
    }
    b->p = (Ptr)(raw + RT_MEM_GUARD_LEN);
    b->size = n;
    b->locked = 0;
    b->noted = 0;
    b->is_ptr = (unsigned char)is_ptr;
    b->live = 1;
    b->tag = tag;
    b->next = rt_mem_blocks;
    rt_mem_blocks = b;

    if (!rt_mem_atexit_done) {
        rt_mem_atexit_done = 1;
        atexit(rt_mem_exit_check);
    }

    rt_mem_err = noErr;
    return b;
}

Handle rt_mem_new_handle(Size n, int clear, const char *tag)
{
    rt_mem_block *b;

    rt_mem_upheaval();
    b = rt_mem_alloc_block(n, clear, tag, 0);
    if (b == NULL) return NULL;
    return &b->p;
}

Ptr rt_mem_new_ptr(Size n, int clear, const char *tag)
{
    rt_mem_block *b;

    rt_mem_upheaval();
    b = rt_mem_alloc_block(n, clear, tag, 1);
    if (b == NULL) return NULL;
    return b->p;
}

void rt_mem_set_handle_size(Handle h, Size n)
{
    rt_mem_block *b;
    unsigned char *newraw;
    unsigned char *oldraw;
    Size copyn;

    rt_mem_upheaval();
    if (h == NULL) { rt_mem_err = nilHandleErr; return; }
    b = (rt_mem_block *)h;
    rt_mem_check_guards(b);

    if (b->locked) {
        if (n > b->size) {
            /* A locked handle never moves. This shim never over-allocates
               headroom for future growth, so growing in place is never
               possible once locked -- exactly like a real Memory Manager
               heap fragmented tight around a locked block. Surface it as
               the OOM it would be there: that's the discipline violation
               this shim exists to make visible. */
            rt_mem_err = memFullErr;
            return;
        }
        /* Shrink (or same-size) in place: same raw allocation and
           address, just move the tail guard down to the new size. */
        rt_mem_fill_guards((unsigned char *)b->p - RT_MEM_GUARD_LEN, n);
        b->size = n;
        rt_mem_err = noErr;
        return;
    }

    newraw = malloc((size_t)n + 2 * RT_MEM_GUARD_LEN);
    if (newraw == NULL) { rt_mem_err = memFullErr; return; }

    copyn = (n < b->size) ? n : b->size;
    memcpy(newraw + RT_MEM_GUARD_LEN, b->p, (size_t)copyn);
    rt_mem_fill_guards(newraw, n);

    oldraw = (unsigned char *)b->p - RT_MEM_GUARD_LEN;
    rt_mem_retire_raw(oldraw, b->size);

    b->p = (Ptr)(newraw + RT_MEM_GUARD_LEN);
    b->size = n;
    rt_mem_err = noErr;
}

Size GetHandleSize(Handle h)
{
    rt_mem_block *b;

    if (h == NULL) { rt_mem_err = nilHandleErr; return 0; }
    b = (rt_mem_block *)h;
    rt_mem_err = noErr;
    return b->size;
}

void HLock(Handle h)
{
    rt_mem_block *b;

    if (h == NULL) { rt_mem_err = nilHandleErr; return; }
    b = (rt_mem_block *)h;
    b->locked = 1;
    rt_mem_err = noErr;
}

void HUnlock(Handle h)
{
    rt_mem_block *b;

    if (h == NULL) { rt_mem_err = nilHandleErr; return; }
    b = (rt_mem_block *)h;
    b->locked = 0;
    rt_mem_err = noErr;
}

void DisposeHandle(Handle h)
{
    rt_mem_block *b;
    unsigned char *raw;

    if (h == NULL) return;
    b = (rt_mem_block *)h;
    if (!b->live) {
        fprintf(stderr, "rt_mem: double dispose at %s (allocated %s)\n", b->tag, b->tag);
        abort();
    }
    rt_mem_check_guards(b);
    raw = (unsigned char *)b->p - RT_MEM_GUARD_LEN;
    rt_mem_retire_raw(raw, b->size);
    b->p = NULL;
    b->live = 0;
    rt_mem_err = noErr;
}

void DisposePtr(Ptr p)
{
    rt_mem_block *b;
    unsigned char *raw;

    if (p == NULL) return;
    for (b = rt_mem_blocks; b != NULL; b = b->next) {
        if (b->is_ptr && b->p == p) break;
    }
    if (b == NULL) {
        fprintf(stderr, "rt_mem: DisposePtr of unrecognized pointer\n");
        abort();
    }
    if (!b->live) {
        fprintf(stderr, "rt_mem: double dispose at %s (allocated %s)\n", b->tag, b->tag);
        abort();
    }
    rt_mem_check_guards(b);
    raw = (unsigned char *)b->p - RT_MEM_GUARD_LEN;
    rt_mem_retire_raw(raw, b->size);
    /* ponytail: unlike a Handle (whose identity is the stable address of
       b->p itself, unaffected by nulling that field), a bare Ptr's only
       identity IS the payload value -- nulling b->p here would destroy the
       one way to find this record again on a second dispose. Leave b->p
       as-is and rely on b->live for double-dispose detection instead. */
    b->live = 0;
    rt_mem_err = noErr;
}

OSErr MemError(void)
{
    OSErr e;

    e = rt_mem_err;
    rt_mem_err = noErr;
    return e;
}

void BlockMoveData(const void *src, void *dst, Size n)
{
    memmove(dst, src, (size_t)n);
}

void rt_mem_note_(void *block, const char *why)
{
    rt_mem_block *b;

    (void)why;
    if (block == NULL) return;
    b = (rt_mem_block *)block;
    b->noted = 1;
}

long rt_mem_live_count(void)
{
    rt_mem_block *b;
    long n;

    n = 0;
    for (b = rt_mem_blocks; b != NULL; b = b->next) {
        if (b->live && !b->noted) n++;
    }
    return n;
}

static void rt_mem_exit_check(void)
{
    const char *strict;
    const char *reportPath;
    FILE *out;
    rt_mem_block *b;
    long n;

    rt_run_cleanup();

    strict = getenv("CLARUS_MEM_STRICT");
    if (strict == NULL) return;

    reportPath = getenv("CLARUS_MEM_REPORT");
    out = reportPath ? fopen(reportPath, "w") : stderr;
    if (out == NULL) out = stderr;

    n = rt_mem_live_count();
    fprintf(out, "##CLARUS-MEM## live=%ld\n", n);
    for (b = rt_mem_blocks; b != NULL; b = b->next) {
        if (b->live && !b->noted) {
            fprintf(out, "rt_mem: leak %s (%ld bytes)\n", b->tag, (long)b->size);
        }
    }
    if (out != stderr) fclose(out);
}

#endif /* CLARUS_RT_MEM_HOST_INC */
