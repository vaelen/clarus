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
/* rt_ext_Ser{BlockMoveData,NewPtr,DisposePtr}: final-review fix -- ser.cla's
 * remaining externs were still unprefixed and collided with a user
 * program's own `external func NewPtr`/etc. (the documented Ch13 escape
 * hatch) the moment that program also called file.save/file.load, the same
 * irRegisterExtern dedup gap the SerFileWriteData/SerFileReadTextInto pair
 * above was already fixed for. Thin aliases of the exact same primitives
 * the generic rt_ext_* wrappers above call -- no logic of their own.
 * (rt_ext_SerSetLastErr/rt_ext_SerPanic, ser.cla's own former SetLastErr/
 * Panic aliases, are gone as of Plan native-5d Task 3: ser.cla calls
 * core.cla's rtSetLastErr/rtPanic directly now. rt_ext_Ser{ListCount,
 * ListAt,ListClear,ListPush,MapCount,MapKeyAt,MapValAt,MapSet,MapClear},
 * ser.cla's own former List/Map container aliases, are gone as of Plan
 * native-5d Task 4: list.cla/map.cla are now spliced ahead of ser.cla in
 * main.cla's manifest, so ser.cla calls their rtList/rtMap functions
 * directly -- a plain intra-Clarus call, no extern needed at all.) */
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

/* rt_ext_CorePanic: core.cla's own extern name (Plan native-5d Task 3),
 * same "own prefixed name, not the generic waist extern" reasoning as
 * every other family below -- core.cla is UNCONDITIONALLY included (it is
 * now spliced FIRST, ahead of every other runtime module), so its rtPanic
 * -> CorePanic call must not share a name with the generic rt_ext_Panic a
 * user program might also declare via its own `external func Panic`. Same
 * str255-to-NUL-terminated-C-string conversion shape as rt_ext_Panic
 * above.
 */
void rt_ext_CorePanic(const uint8_t *msg) {
    char buf[256];
    uint8_t n = msg[0];
    memmove(buf, msg + 1, (size_t)n);
    buf[n] = '\0';
    rt_panic(buf);
}

/* rt_ext_CoreSetLastErr: core.cla's own extern name (Plan native-5d Task
 * 12.5, lastError storage-inversion fix) -- same "own prefixed name" and
 * str255-to-NUL-terminated-C-string conversion shape as rt_ext_CorePanic
 * just above; core.cla's rtSetLastErr forwards here so lastError storage
 * is platform-owned again (rt_lasterr_code/rt_lasterr_msg, rt_core.inc),
 * not a separate Clarus-side global pair. */
void rt_ext_CoreSetLastErr(int32_t code, const uint8_t *msg) {
    char buf[256];
    uint8_t n = msg[0];
    memmove(buf, msg + 1, (size_t)n);
    buf[n] = '\0';
    rt_set_lasterr(code, buf);
}

/* rt_ext_StrBlockMoveData: str.cla's own extern name (Plan 5b Task 8),
 * same reasoning as rt_ext_SerFileWriteData/rt_ext_SerFileReadTextInto
 * above -- str.cla is UNCONDITIONALLY included in every emitted program,
 * so its own BlockMoveData calls must not share a name with the generic
 * waist extern a user program might also declare (testdata/lowlevel/
 * peekpoke.cla already declares its own `external func BlockMoveData` and
 * would otherwise collide -- checkFuncSig's scopeDeclare keys purely on
 * name, no signature comparison). Thin alias of the same primitive the
 * generic wrapper above already calls. (rt_ext_StrSetLastErr/
 * rt_ext_StrPanic, str.cla's own former SetLastErr/Panic aliases, are gone
 * as of Plan native-5d Task 3: str.cla calls core.cla's rtSetLastErr/
 * rtPanic directly now -- a plain intra-Clarus call, no extern needed at
 * all.) */
void rt_ext_StrBlockMoveData(void *src, void *dst, int32_t n) { BlockMoveData((Ptr)src, (Ptr)dst, (Size)n); }

/* rt_ext_TextHandleDeref/TextSetHandleSize/TextBlockMoveData/TextNewPtr/
 * TextDisposePtr: text.cla's own extern names (Plan 5b Task 9), same
 * reasoning as the Str family above -- text.cla is UNCONDITIONALLY
 * included in every emitted program, so its own waist calls must not
 * share a name with the generic/Str/Ser externs a user program or another
 * runtime module might also declare. Bodies are thin aliases of the same
 * primitives the generic wrappers above already call. (rt_ext_TextNewRaw,
 * the one-time "whole rt_text_new delegation" birth-allocation wrapper, is
 * gone as of Plan 5c wave2a Task 2 -- birth moved into text.cla itself,
 * built from rt_ext_TextNewPtr/TextNewHandle below. rt_ext_TextSetLastErr/
 * rt_ext_TextPanic, text.cla's own former SetLastErr/Panic aliases, are
 * gone as of Plan native-5d Task 3: text.cla calls core.cla's
 * rtSetLastErr/rtPanic directly now -- a plain intra-Clarus call, no
 * extern needed at all.) */
void *rt_ext_TextHandleDeref(void *h) { return *(void **)h; }
int32_t rt_ext_TextSetHandleSize(void *h, int32_t n) { SetHandleSize((Handle)h, (Size)n); return (int32_t)MemError(); }
void rt_ext_TextBlockMoveData(void *src, void *dst, int32_t n) { BlockMoveData((Ptr)src, (Ptr)dst, (Size)n); }
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
 * waist externs; live as of Task 2, which ports rtTextNew/rtTextRetain/
 * rtTextRelease into text.cla against exactly these three): text.cla's own
 * NewHandle/DisposeHandle wrappers and its rc over-release guard, same "own
 * extern name" reasoning as the rest of this family -- text.cla is
 * unconditional, so it can't share a name with the generic waist externs.
 * rt_ext_TextNewHandle panics via rt_core_oom() on NULL, the same placement
 * rt_core_new_struct uses for every NewPtr/NewHandle in this runtime.
 * rt_ext_TextRcCheck's host body mirrors rt_rc_check's host branch
 * (rt_core.inc:768-774) exactly, so an over-release reached via this
 * extern produces the same diagnostic as one caught internally -- text.cla
 * calls it only on the cold `rc <= 0` path (rtTextRelease's own doc
 * comment), never unconditionally. */
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

/* rt_ext_ListHandleDeref/ListSetHandleSize/ListBlockMoveData: list.cla's
 * own extern names (Plan 5b Task 10), same reasoning as the Text family
 * above -- list.cla is UNCONDITIONALLY included in every emitted program,
 * so its own waist calls must not share a name with the generic/Str/Text/
 * Ser externs a user program or another runtime module might also
 * declare. Bodies are thin aliases of the same primitives the generic
 * wrappers above already call. (rt_ext_ListNewRaw, the one-time "whole
 * rt_list_new delegation" birth-allocation wrapper, is gone as of Plan 5c
 * wave2a Task 3 -- birth moved into list.cla itself, built from
 * rt_ext_ListNewPtr/ListNewHandle below. rt_ext_ListPanic, list.cla's own
 * former Panic alias, is gone as of Plan native-5d Task 3: list.cla calls
 * core.cla's rtPanic directly now -- a plain intra-Clarus call, no extern
 * needed at all.) */
void *rt_ext_ListHandleDeref(void *h) { return *(void **)h; }
int32_t rt_ext_ListSetHandleSize(void *h, int32_t n) { SetHandleSize((Handle)h, (Size)n); return (int32_t)MemError(); }
void rt_ext_ListBlockMoveData(void *src, void *dst, int32_t n) { BlockMoveData((Ptr)src, (Ptr)dst, (Size)n); }

/* rt_ext_ListNewHandle/ListDisposeHandle/ListRcCheck/ListNewPtr/
 * ListDisposePtr (Plan 5c Task 1: ARC waist externs; live as of Task 3,
 * which ports rtListNew/rtListRetain/rtListRelease into list.cla against
 * exactly these five): list.cla's own NewHandle/DisposeHandle/NewPtr/
 * DisposePtr wrappers and its rc over-release guard, same reasoning as the
 * Text family above. rt_ext_ListNewPtr mirrors rt_ext_TextNewPtr's
 * oom-panic placement exactly (Text already carries NewPtr/DisposePtr from
 * Task 9, so List's own pair lands here instead); rt_ext_ListRcCheck's
 * host body mirrors rt_rc_check's host branch (rt_core.inc:768-774)
 * exactly -- list.cla calls it only on the cold `rc <= 0` path
 * (rtListRelease's own doc comment), never unconditionally. */
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

/* rt_ext_MapHandleDeref/MapSetHandleSize/MapBlockMoveData: map.cla's own
 * extern names (Plan 5b Task 11), same reasoning as the List family above
 * -- map.cla is UNCONDITIONALLY included in every emitted program, so its
 * own waist calls must not share a name with the generic/Str/Text/List/
 * Ser externs a user program or another runtime module might also
 * declare. Bodies are thin aliases of the same primitives the generic/
 * List wrappers above already call. (rt_ext_MapNewRaw, the one-time
 * "whole rt_map_new delegation" birth-allocation wrapper, is gone as of
 * Plan 5c wave2a Task 4 -- birth moved into map.cla itself, built from
 * rt_ext_MapNewPtr/MapNewHandle below, mirroring the List family's own
 * Task 3 update. rt_ext_MapPanic, map.cla's own former Panic alias, is
 * gone as of Plan native-5d Task 3: map.cla calls core.cla's rtPanic
 * directly now -- a plain intra-Clarus call, no extern needed at all.) */
void *rt_ext_MapHandleDeref(void *h) { return *(void **)h; }
int32_t rt_ext_MapSetHandleSize(void *h, int32_t n) { SetHandleSize((Handle)h, (Size)n); return (int32_t)MemError(); }
void rt_ext_MapBlockMoveData(void *src, void *dst, int32_t n) { BlockMoveData((Ptr)src, (Ptr)dst, (Size)n); }

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

/* rt_ext_XRecAddr (Task 5, toolbox-integration Feature B: `extern
 * record`): identity shim lets a testdata/lowlevel fixture recover the raw
 * address an extern-record decay (EXRecAddr) produced, so pure-Clarus
 * peek/poke can cross-check the checker/lower.cla packed-offset layout
 * against the ACTUAL bytes cprint/rt.h emit -- no logic of its own, same
 * "thin C ABI wrapper" convention as every other rt_ext_* in this file. */
void *rt_ext_XRecAddr(void *p) { return p; }

/* rt_ext_CbInvoke (Task 7, toolbox-integration Feature C: `callback
 * func`): invokes a callback's decayed glue address (a plain C function
 * pointer on this lane -- see cprint.cla's ECbAddr rendering, `((void*)
 * &clar_cb_<name>)`) using the exact host-lane wire shape cprint's own
 * cpEmitExternProtos generates for `external func CbInvoke(fn: ptr, a:
 * int, b: ptr): int` (int32_t, void pointer, int32_t -> int32_t, cpCType's
 * ordinary mapping) -- the seam testdata/lowlevel/callback_host.cla calls
 * through to prove decay end-to-end on host: a real function-pointer call
 * through a value the compiler produced, not a hand exercised code path.
 *
 * Deviates from the task brief's literal draft signature (`static long
 * rt_ext_CbInvoke(void *fn, long a, void *b)`): every OTHER rt_ext_* in
 * this file has external linkage (no `static`), matching
 * cpEmitExternProtos's own `extern` forward declaration -- a `static`
 * definition here would conflict with that extern (linkage mismatch, a
 * hard C error) the moment a program actually declares `external func
 * CbInvoke`. `long` is also wrong on an LP64 host (8 bytes here, vs. the
 * 4-byte int32_t cpCType actually emits for Clarus `int`) -- int32_t/
 * void* matches the real generated prototype exactly. See the task-7
 * report for the full reasoning (same "brief draft adjusted to the file's
 * established idiom" precedent as Task 2's own `ptrOf` deviation).
 */
int32_t rt_ext_CbInvoke(void *fn, int32_t a, void *b) {
    return ((int32_t (*)(int32_t, void *))fn)(a, b);
}

#endif /* CLARUS_RT_EXT_HOST_INC */
