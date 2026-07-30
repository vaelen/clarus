/* internal/build/rt/rt_ext_host.inc: host implementations of `external
 * func` symbols (Task 3, Ch13: Low-Level Memory Access -- the narrow-waist
 * seam, Plan 5a). Each rt_ext_* delegates to the host Memory Manager shim
 * (rt_mem.h/rt_mem_host.inc) rather than bare malloc/free, so the strict-
 * ledger/paranoid/leak-gate instrumentation that already covers every
 * INTERNAL allocation (rt_text/rt_list/rt_map, ...) covers an `external
 * func` allocation exactly the same way -- NewHandle/NewPtr are both
 * already present in the host shim (verified against rt_mem.h's host
 * branch + rt_mem_host.inc before writing this file), so no malloc-backed
 * fallback is needed for either.
 *
 * Every wrapper here just narrows/widens between the C ABI's plain
 * int32_t/void* (what clarusc's cprint emits for `int`/`ptr`) and
 * rt_mem.h's Size/Handle/Ptr/OSErr typedefs -- no logic of its own.
 */
#ifndef CLARUS_RT_EXT_HOST_INC
#define CLARUS_RT_EXT_HOST_INC

void *rt_ext_NewHandle(int32_t size) { return (void *)NewHandle((Size)size); }
void rt_ext_DisposeHandle(void *h) { DisposeHandle((Handle)h); }
int32_t rt_ext_GetHandleSize(void *h) { return (int32_t)GetHandleSize((Handle)h); }
int32_t rt_ext_SetHandleSize(void *h, int32_t n) { SetHandleSize((Handle)h, (Size)n); return (int32_t)MemError(); }
void rt_ext_BlockMoveData(void *src, void *dst, int32_t n) { BlockMoveData((Ptr)src, (Ptr)dst, (Size)n); }
void *rt_ext_NewPtr(int32_t size) { return (void *)NewPtr((Size)size); }
void rt_ext_DisposePtr(void *p) { DisposePtr((Ptr)p); }

/* ---- Plan 5b Task 3: waist widening -- str/text params + file/container/
 * lasterr externals. Every wrapper below just narrows/widens between the C
 * ABI (int32_t, void pointer, const uint8_t pointer, rt_text pointer --
 * what cprint's cpEmitExternProtos/fpCallExt now emit for int/ptr/str/text
 * params) and the rt_core.inc/rt.c primitives already used internally by
 * rt_ser.inc -- no logic of its own, same convention as the 5a seven
 * above. rt_file_write_data is `static` and defined further down in rt.c
 * (after this .inc's include point); rt.c carries a forward declaration
 * ahead of that include so rt_ext_FileWriteData can call it here.
 */
void *rt_ext_HandleDeref(void *h) { return *(void **)h; }
int32_t rt_ext_FileWriteData(const uint8_t *path, rt_text *t) { return rt_file_write_data(path, t); }
int32_t rt_ext_FileReadTextInto(const uint8_t *path, rt_text *out) { return rt_file_read_text(path, out); }
/* rt_ext_SerFileWriteData/rt_ext_SerFileReadTextInto: ser.cla's own extern
 * names (Plan 5b Task 7 fix) for the same two primitives above, taking a
 * `void *path` (ser.cla's rtFileSave/rtFileLoad already hold path as a raw
 * ptr, not a str to re-marshal) -- kept distinct from rt_ext_FileWriteData/
 * rt_ext_FileReadTextInto so a user program's own `external func
 * FileWriteData(path: string, ...)` (testdata/lowlevel/exttext.cla's
 * shape) can never collide with ser.cla's `path: ptr` declaration of the
 * same C symbol in one merged translation unit. */
int32_t rt_ext_SerFileWriteData(void *path, rt_text *t) { return rt_file_write_data((const uint8_t *)path, t); }
int32_t rt_ext_SerFileReadTextInto(void *path, rt_text *out) { return rt_file_read_text((const uint8_t *)path, out); }
/* rt_ext_Ser{SetLastErr,Panic,ListCount,ListAt,ListClear,ListPush,MapCount,
 * MapKeyAt,MapValAt,MapSet,MapClear,BlockMoveData,NewPtr,DisposePtr}: final-
 * review fix -- ser.cla's remaining fourteen externs were still unprefixed
 * and collided with a user program's own `external func NewPtr`/etc. (the
 * documented Ch13 escape hatch) the moment that program also called
 * file.save/file.load, the same irRegisterExtern dedup gap the
 * SerFileWriteData/SerFileReadTextInto pair above was already fixed for.
 * Thin aliases of the exact same primitives the generic rt_ext_* wrappers
 * above call -- no logic of their own. */
void rt_ext_SerSetLastErr(int32_t code, const uint8_t *msg) {
    char buf[256];
    uint8_t n = msg[0];
    memmove(buf, msg + 1, (size_t)n);
    buf[n] = '\0';
    rt_set_lasterr(code, buf);
}
void rt_ext_SerPanic(const uint8_t *msg) {
    char buf[256];
    uint8_t n = msg[0];
    memmove(buf, msg + 1, (size_t)n);
    buf[n] = '\0';
    rt_panic(buf);
}
int32_t rt_ext_SerListCount(void *l) { return rt_list_count((rt_list *)l); }
void *rt_ext_SerListAt(void *l, int32_t i) { return rt_list_at((rt_list *)l, i); }
void rt_ext_SerListClear(void *l) { rt_list_clear((rt_list *)l); }
void rt_ext_SerListPush(void *l, void *elem) { rt_list_push((rt_list *)l, elem); }
int32_t rt_ext_SerMapCount(void *m) { return rt_map_count((rt_map *)m); }
void rt_ext_SerMapKeyAt(void *m, int32_t i, void *key255) { rt_map_key_at((rt_map *)m, i, (uint8_t *)key255); }
void rt_ext_SerMapValAt(void *m, int32_t i, void *out) { rt_map_val_at((rt_map *)m, i, out); }
void rt_ext_SerMapSet(void *m, void *key255, void *val) { rt_map_set((rt_map *)m, (const uint8_t *)key255, val); }
void rt_ext_SerMapClear(void *m) { rt_map_clear((rt_map *)m); }
void rt_ext_SerBlockMoveData(void *src, void *dst, int32_t n) { BlockMoveData((Ptr)src, (Ptr)dst, (Size)n); }
void *rt_ext_SerNewPtr(int32_t size) { return (void *)NewPtr((Size)size); }
void rt_ext_SerDisposePtr(void *p) { DisposePtr((Ptr)p); }
/* rt_set_lasterr takes a NUL-terminated C string (rt_core.inc:19's
 * strlen(msg)); the Clarus-side msg is a str255 ([len][bytes]), so build a
 * NUL-terminated copy here before delegating. */
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
 * own extern names (Plan 5b Task 8), same reasoning as
 * rt_ext_SerFileWriteData/rt_ext_SerFileReadTextInto above -- str.cla is
 * UNCONDITIONALLY included in every emitted program from this task
 * forward, so its own SetLastErr/Panic/BlockMoveData calls must not share
 * a name with the generic waist externs a user program might also declare
 * (testdata/lowlevel/peekpoke.cla already declares its own `external func
 * BlockMoveData` and would otherwise collide the moment str.cla became
 * unconditional -- checkFuncSig's scopeDeclare keys purely on name, no
 * signature comparison). Bodies are thin aliases of the same primitives
 * the generic wrappers above already call. */
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

/* rt_ext_TextHandleDeref/TextSetHandleSize/TextBlockMoveData/
 * TextSetLastErr/TextPanic/TextNewRaw/TextNewPtr/TextDisposePtr: text.cla's
 * own extern names (Plan 5b Task 9), same reasoning as the Str family
 * above -- text.cla is UNCONDITIONALLY included in every emitted program
 * from this task forward, so its own waist calls must not share a name
 * with the generic/Str/Ser externs a user program or another runtime
 * module might also declare. Bodies are thin aliases of the same
 * primitives the generic wrappers above already call. rt_ext_TextNewRaw is
 * the sole exception to "thin alias": it delegates the WHOLE rt_text_new
 * construction (the Task 9 "external delegation" birth-allocation choice),
 * so rc is written exactly once, entirely in C. */
void *rt_ext_TextHandleDeref(void *h) { return *(void **)h; }
int32_t rt_ext_TextSetHandleSize(void *h, int32_t n) { SetHandleSize((Handle)h, (Size)n); return (int32_t)MemError(); }
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
/* rt_ext_TextNewPtr (review round 1 fix, Critical): text.cla's own
 * scratch-buffer allocator (rtTextConcat/rtTextConcatSl), a NewPtr block
 * mirroring rt_text_concat's own scratch choice (rt_core.inc:307-308)
 * exactly. Checks for NULL and panics right here -- the same
 * "if (!p) rt_core_oom()" placement rt_core_new_struct uses for every
 * OTHER NewPtr in this runtime -- rather than pushing a ptr(0) check out
 * to text.cla's own call sites. */
void *rt_ext_TextNewPtr(int32_t size) {
    void *p = (void *)NewPtr((Size)size);
    if (!p) rt_panic("out of memory");
    return p;
}
void rt_ext_TextDisposePtr(void *p) { DisposePtr((Ptr)p); }

/* rt_ext_TextNewHandle/TextDisposeHandle/TextRcCheck (Plan 5c Task 1: ARC
 * waist externs): text.cla's own NewHandle/DisposeHandle wrappers and its rc
 * over-release guard, same "own extern name" reasoning as the rest of this
 * family -- text.cla is unconditional, so it can't share a name with the
 * generic waist externs. rt_ext_TextNewHandle panics via rt_core_oom() on
 * NULL, the same placement rt_core_new_struct uses for every NewPtr/
 * NewHandle in this runtime. rt_ext_TextRcCheck's host body mirrors
 * rt_rc_check's host branch (rt_core.inc:768-774) exactly, so an
 * over-release reached via this extern produces the same diagnostic as one
 * caught internally. */
void *rt_ext_TextNewHandle(int32_t n) {
    void *h = (void *)NewHandle((Size)n);
    if (!h) rt_core_oom();
    return h;
}
void rt_ext_TextDisposeHandle(void *h) { DisposeHandle((Handle)h); }
void rt_ext_TextRcCheck(void *box, int32_t rc) {
    if (rc <= 0) {
        fprintf(stderr, "rt_rc: over-release at %s\n", rt_mem_tag_of(box));
        abort();
    }
}

/* rt_ext_ListHandleDeref/ListSetHandleSize/ListBlockMoveData/ListPanic/
 * ListNewRaw: list.cla's own extern names (Plan 5b Task 10), same reasoning
 * as the Text family above -- list.cla is UNCONDITIONALLY included in every
 * emitted program from this task forward, so its own waist calls must not
 * share a name with the generic/Str/Text/Ser externs a user program or
 * another runtime module might also declare. Bodies are thin aliases of the
 * same primitives the generic wrappers above already call.
 * rt_ext_ListNewRaw is the sole exception to "thin alias": it delegates the
 * WHOLE rt_list_new construction (the Task 9 "external delegation" birth-
 * allocation choice, same pattern as rt_ext_TextNewRaw), so rc is written
 * exactly once, entirely in C. */
void *rt_ext_ListHandleDeref(void *h) { return *(void **)h; }
int32_t rt_ext_ListSetHandleSize(void *h, int32_t n) { SetHandleSize((Handle)h, (Size)n); return (int32_t)MemError(); }
void rt_ext_ListBlockMoveData(void *src, void *dst, int32_t n) { BlockMoveData((Ptr)src, (Ptr)dst, (Size)n); }
void rt_ext_ListPanic(const uint8_t *msg) {
    char buf[256];
    uint8_t n = msg[0];
    memmove(buf, msg + 1, (size_t)n);
    buf[n] = '\0';
    rt_panic(buf);
}
void *rt_ext_ListNewRaw(int32_t elemsize) { return (void *)rt_list_new(elemsize); }

/* rt_ext_ListNewHandle/ListDisposeHandle/ListRcCheck/ListNewPtr/
 * ListDisposePtr (Plan 5c Task 1: ARC waist externs): list.cla's own
 * NewHandle/DisposeHandle/NewPtr/DisposePtr wrappers and its rc
 * over-release guard, same reasoning as the Text family above.
 * rt_ext_ListNewPtr mirrors rt_ext_TextNewPtr's oom-panic placement
 * exactly (Text already carries NewPtr/DisposePtr from Task 9, so List's
 * own pair lands here instead); rt_ext_ListRcCheck's host body mirrors
 * rt_rc_check's host branch (rt_core.inc:768-774) exactly. */
void *rt_ext_ListNewHandle(int32_t n) {
    void *h = (void *)NewHandle((Size)n);
    if (!h) rt_core_oom();
    return h;
}
void rt_ext_ListDisposeHandle(void *h) { DisposeHandle((Handle)h); }
void rt_ext_ListRcCheck(void *box, int32_t rc) {
    if (rc <= 0) {
        fprintf(stderr, "rt_rc: over-release at %s\n", rt_mem_tag_of(box));
        abort();
    }
}
void *rt_ext_ListNewPtr(int32_t size) {
    void *p = (void *)NewPtr((Size)size);
    if (!p) rt_panic("out of memory");
    return p;
}
void rt_ext_ListDisposePtr(void *p) { DisposePtr((Ptr)p); }

/* rt_ext_MapHandleDeref/MapSetHandleSize/MapBlockMoveData/MapPanic/
 * MapNewRaw: map.cla's own extern names (Plan 5b Task 11), same reasoning
 * as the List family above -- map.cla is UNCONDITIONALLY included in every
 * emitted program from this task forward, so its own waist calls must not
 * share a name with the generic/Str/Text/List/Ser externs a user program or
 * another runtime module might also declare. Bodies are thin aliases of the
 * same primitives the generic/List wrappers above already call.
 * rt_ext_MapNewRaw is the sole exception to "thin alias": it delegates the
 * WHOLE rt_map_new construction (same "external delegation" birth-
 * allocation choice as rt_ext_TextNewRaw/rt_ext_ListNewRaw), so rc is
 * written exactly once, entirely in C. */
void *rt_ext_MapHandleDeref(void *h) { return *(void **)h; }
int32_t rt_ext_MapSetHandleSize(void *h, int32_t n) { SetHandleSize((Handle)h, (Size)n); return (int32_t)MemError(); }
void rt_ext_MapBlockMoveData(void *src, void *dst, int32_t n) { BlockMoveData((Ptr)src, (Ptr)dst, (Size)n); }
void rt_ext_MapPanic(const uint8_t *msg) {
    char buf[256];
    uint8_t n = msg[0];
    memmove(buf, msg + 1, (size_t)n);
    buf[n] = '\0';
    rt_panic(buf);
}
void *rt_ext_MapNewRaw(int32_t valsize) { return (void *)rt_map_new(valsize); }

/* rt_ext_MapNewHandle/MapDisposeHandle/MapRcCheck/MapNewPtr/MapDisposePtr
 * (Plan 5c Task 1: ARC waist externs): map.cla's own NewHandle/
 * DisposeHandle/NewPtr/DisposePtr wrappers and its rc over-release guard,
 * same reasoning as the List family above. */
void *rt_ext_MapNewHandle(int32_t n) {
    void *h = (void *)NewHandle((Size)n);
    if (!h) rt_core_oom();
    return h;
}
void rt_ext_MapDisposeHandle(void *h) { DisposeHandle((Handle)h); }
void rt_ext_MapRcCheck(void *box, int32_t rc) {
    if (rc <= 0) {
        fprintf(stderr, "rt_rc: over-release at %s\n", rt_mem_tag_of(box));
        abort();
    }
}
void *rt_ext_MapNewPtr(int32_t size) {
    void *p = (void *)NewPtr((Size)size);
    if (!p) rt_panic("out of memory");
    return p;
}
void rt_ext_MapDisposePtr(void *p) { DisposePtr((Ptr)p); }

#endif /* CLARUS_RT_EXT_HOST_INC */
