/* runtime/mac/rt_ext_mac.inc: Mac Toolbox implementations of `external
 * func` symbols (Plan 5b Task 3: waist widening). Mirrors
 * internal/build/rt/rt_ext_host.inc's function set exactly (same rt_ext_*
 * names, same C signatures) so a program built either target sees an
 * identical extern surface; the bodies differ only in that rt_mem.h's Mac
 * branch (`#if defined(__m68k__) || defined(macintosh)`) maps
 * NewHandle/DisposeHandle/GetHandleSize/SetHandleSize/BlockMoveData/
 * NewPtr/DisposePtr straight onto the real Memory Manager (`#include
 * <Memory.h>`, no host paranoid shim), rather than rt_mem_host.inc's
 * ledger.
 *
 * The 5a seven (NewHandle...DisposePtr) never got a Mac-side rt_ext_
 * wrapper until this task -- cprint always emits calls as rt_ext_NAME
 * regardless of target, so both halves belong in the same file. #included
 * from rt_mac.c AFTER rt_file_write_data's definition (rt_ext_FileWriteData
 * below calls it directly, no forward declaration needed on this side).
 */
#ifndef CLARUS_RT_EXT_MAC_INC
#define CLARUS_RT_EXT_MAC_INC

/* ---- 5a: ptr/Handle waist (Plan 5a Task 3) ---- */
void *rt_ext_NewHandle(int32_t size) { return (void *)NewHandle((Size)size); }
void rt_ext_DisposeHandle(void *h) { DisposeHandle((Handle)h); }
int32_t rt_ext_GetHandleSize(void *h) { return (int32_t)GetHandleSize((Handle)h); }
int32_t rt_ext_SetHandleSize(void *h, int32_t n) { SetHandleSize((Handle)h, (Size)n); return (int32_t)MemError(); }
void rt_ext_BlockMoveData(void *src, void *dst, int32_t n) { BlockMoveData((Ptr)src, (Ptr)dst, (Size)n); }
void *rt_ext_NewPtr(int32_t size) { return (void *)NewPtr((Size)size); }
void rt_ext_DisposePtr(void *p) { DisposePtr((Ptr)p); }

/* ---- Plan 5b Task 3: str/text params + file/container/lasterr ---- */
void *rt_ext_HandleDeref(void *h) { return *(void **)h; }
int32_t rt_ext_FileWriteData(const uint8_t *path, rt_text *t) { return rt_file_write_data(path, t); }
int32_t rt_ext_FileReadTextInto(const uint8_t *path, rt_text *out) { return rt_file_read_text(path, out); }
/* rt_ext_SerFileWriteData/rt_ext_SerFileReadTextInto: ser.cla's own extern
 * names (Plan 5b Task 7 fix), same reasoning as the host .inc -- kept
 * distinct from rt_ext_FileWriteData/rt_ext_FileReadTextInto so ser.cla's
 * `path: ptr` declaration can never collide with a user program's own
 * `external func FileWriteData(path: string, ...)` in one merged TU. */
int32_t rt_ext_SerFileWriteData(void *path, rt_text *t) { return rt_file_write_data((const uint8_t *)path, t); }
int32_t rt_ext_SerFileReadTextInto(void *path, rt_text *out) { return rt_file_read_text((const uint8_t *)path, out); }
/* rt_set_lasterr takes a NUL-terminated C string; the Clarus-side msg is a
 * str255 ([len][bytes]), so build a NUL-terminated copy here first -- same
 * convention as the host wrapper. */
void rt_ext_SetLastErr(int32_t code, const uint8_t *msg) {
    char buf[256];
    uint8_t n = msg[0];
    memmove(buf, msg + 1, (size_t)n);
    buf[n] = '\0';
    rt_set_lasterr(code, buf);
}
int32_t rt_ext_ListCount(void *l) { return rt_list_count((rt_list *)l); }
void *rt_ext_ListAt(void *l, int32_t i) { return rt_list_at((rt_list *)l, i); }
void rt_ext_ListClear(void *l) { rt_list_clear((rt_list *)l); }
void rt_ext_ListPush(void *l, void *elem) { rt_list_push((rt_list *)l, elem); }
int32_t rt_ext_MapCount(void *m) { return rt_map_count((rt_map *)m); }
void rt_ext_MapKeyAt(void *m, int32_t i, void *key255) { rt_map_key_at((rt_map *)m, i, (uint8_t *)key255); }
void rt_ext_MapValAt(void *m, int32_t i, void *out) { rt_map_val_at((rt_map *)m, i, out); }
void rt_ext_MapSet(void *m, void *key255, void *val) { rt_map_set((rt_map *)m, (const uint8_t *)key255, val); }
void rt_ext_MapClear(void *m) { rt_map_clear((rt_map *)m); }
/* rt_panic takes a NUL-terminated C string; the Clarus-side msg is a str255
 * ([len][bytes]), so build a NUL-terminated copy here first -- same
 * conversion shape as rt_ext_SetLastErr above (Plan 5b Task 7). */
void rt_ext_Panic(const uint8_t *msg) {
    char buf[256];
    uint8_t n = msg[0];
    memmove(buf, msg + 1, (size_t)n);
    buf[n] = '\0';
    rt_panic(buf);
}

/* rt_ext_StrSetLastErr/rt_ext_StrPanic/rt_ext_StrBlockMoveData: str.cla's
 * own extern names (Plan 5b Task 8), same reasoning as the host .inc --
 * str.cla is unconditional from this task forward, so it can't share a
 * name with the generic waist externs a user program might also declare
 * (testdata/lowlevel/peekpoke.cla's own `external func BlockMoveData`). */
void rt_ext_StrSetLastErr(int32_t code, const uint8_t *msg) {
    char buf[256];
    uint8_t n = msg[0];
    memmove(buf, msg + 1, (size_t)n);
    buf[n] = '\0';
    rt_set_lasterr(code, buf);
}
void rt_ext_StrPanic(const uint8_t *msg) {
    char buf[256];
    uint8_t n = msg[0];
    memmove(buf, msg + 1, (size_t)n);
    buf[n] = '\0';
    rt_panic(buf);
}
void rt_ext_StrBlockMoveData(void *src, void *dst, int32_t n) { BlockMoveData((Ptr)src, (Ptr)dst, (Size)n); }

/* rt_ext_TextHandleDeref/TextNewHandle/TextSetHandleSize/TextDisposeHandle/
 * TextBlockMoveData/TextSetLastErr/TextPanic/TextNewRaw: text.cla's own
 * extern names (Plan 5b Task 9), same reasoning as the host .inc -- text.cla
 * is unconditional from this task forward, so it can't share a name with
 * the generic/Str/Ser waist externs a user program or another runtime
 * module might also declare. rt_ext_TextNewRaw delegates the WHOLE
 * rt_text_new construction (Task 9's "external delegation" birth-allocation
 * choice), so rc is written exactly once, entirely in C. */
void *rt_ext_TextHandleDeref(void *h) { return *(void **)h; }
void *rt_ext_TextNewHandle(int32_t size) { return (void *)NewHandle((Size)size); }
int32_t rt_ext_TextSetHandleSize(void *h, int32_t n) { SetHandleSize((Handle)h, (Size)n); return (int32_t)MemError(); }
void rt_ext_TextDisposeHandle(void *h) { DisposeHandle((Handle)h); }
void rt_ext_TextBlockMoveData(void *src, void *dst, int32_t n) { BlockMoveData((Ptr)src, (Ptr)dst, (Size)n); }
void rt_ext_TextSetLastErr(int32_t code, const uint8_t *msg) {
    char buf[256];
    uint8_t n = msg[0];
    memmove(buf, msg + 1, (size_t)n);
    buf[n] = '\0';
    rt_set_lasterr(code, buf);
}
void rt_ext_TextPanic(const uint8_t *msg) {
    char buf[256];
    uint8_t n = msg[0];
    memmove(buf, msg + 1, (size_t)n);
    buf[n] = '\0';
    rt_panic(buf);
}
void *rt_ext_TextNewRaw(void) { return (void *)rt_text_new(); }

#endif /* CLARUS_RT_EXT_MAC_INC */
