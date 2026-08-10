/* runtime/mac/rt_ext_mac.inc: Mac Toolbox implementations of `external
 * func` symbols (Plan 5b Task 3: waist widening). Mirrors
 * runtime/host/rt_ext_host.inc's function set exactly (same rt_ext_*
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

/* Task 7 (native-5e UI port): headers for Toolbox calls used by rt_ext_Ui*
 * wrappers below, several of which are defined ahead of the
 * "Task 7 glue" include block further down (AppleEvents.h/OSUtils.h at
 * ~line 384) -- moved up here so every wrapper in the file, regardless of
 * position, sees the declarations it needs (verified against rt_ui.c's own
 * include list, the oracle for this port: it pulls in the same headers for
 * the same reasons). */
#include <Sound.h>    /* SysBeep -- rt_ext_UiSysBeep */
#include <Gestalt.h>  /* Gestalt/gestaltAppleEventsAttr -- rt_ext_UiGestalt{Err,Value}, rt_ext_UiLaunchReal */
#include <Devices.h>  /* OpenDeskAcc -- rt_ext_UiOpenDeskAcc */
#include <SegLoad.h>  /* CountAppFiles/GetAppFiles/ClrAppFiles/AppFile -- rt_ext_UiLaunchReal */
#include <Resources.h> /* GetResource/ReleaseResource -- rt_ext_UiLaunchReal's SIZE-resource probe */
#include <Scrap.h>     /* ZeroScrap -- rt_ext_UiZeroScrap (Task 8); TEFromScrap/TEToScrap/
                           TEGetScrapLength come from TextEdit.h, already visible transitively. */
#include <Lists.h>     /* List Manager -- Task 9's uitable.cla externs (rt_ui.c's own precedent, :69) */
#include <NumberFormatting.h> /* NumToString -- Task 9 table cell int/fixed rendering, no libc needed */
#include <StandardFile.h> /* SFGetFile/SFPutFile -- Task 10's rt_ext_UiSFGetFile/rt_ext_UiSFPutFile (rt_ui.c's own precedent, :73) */

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
/* rt_ext_FileWriteData: same static 'CLRD'/'????' default as the host
 * .inc's own copy (native-gaps-cleanup Task 2) -- see that file's own
 * comment; this fixture's behavior is otherwise unaffected (path/text
 * round-trip is all it checks, never FInfo). */
static const uint8_t rt_ext_default_type[] = {4, 'C', 'L', 'R', 'D'};
static const uint8_t rt_ext_default_creator[] = {4, '?', '?', '?', '?'};
int32_t rt_ext_FileWriteData(const uint8_t *path, rt_text *t) { return rt_file_write_data(path, t, rt_ext_default_type, rt_ext_default_creator); }
int32_t rt_ext_FileReadTextInto(const uint8_t *path, rt_text *out) { return rt_file_read_text(path, out); }
/* rt_ext_SerFileWriteData/rt_ext_SerFileReadTextInto: ser.cla's own extern
 * names (Plan 5b Task 7 fix), same reasoning as the host .inc -- kept
 * distinct from rt_ext_FileWriteData/rt_ext_FileReadTextInto so ser.cla's
 * `path: ptr` declaration can never collide with a user program's own
 * `external func FileWriteData(path: string, ...)` in one merged TU.
 * type/creator (native-gaps-cleanup Task 2) are ser.cla's own real,
 * caller-supplied values -- threaded straight through. */
int32_t rt_ext_SerFileWriteData(void *path, rt_text *t, void *type, void *creator) { return rt_file_write_data((const uint8_t *)path, t, (const uint8_t *)type, (const uint8_t *)creator); }
int32_t rt_ext_SerFileReadTextInto(void *path, rt_text *out) { return rt_file_read_text((const uint8_t *)path, out); }
/* rt_ext_Ser{BlockMoveData,NewPtr,DisposePtr}: final-review fix, mirroring
 * runtime/host/rt_ext_host.inc's block exactly -- ser.cla's remaining
 * externs were still unprefixed and collided with a user program's own
 * `external func NewPtr`/etc. (the documented Ch13 escape hatch) the
 * moment that program also called file.save/file.load. Thin aliases of the
 * same primitives the generic rt_ext_* wrappers above call.
 * (rt_ext_SerSetLastErr/rt_ext_SerPanic, ser.cla's own former SetLastErr/
 * Panic aliases, are gone as of Plan native-5d Task 3 -- see the host
 * .inc's own header comment. rt_ext_Ser{ListCount,ListAt,ListClear,
 * ListPush,MapCount,MapKeyAt,MapValAt,MapSet,MapClear}, ser.cla's own
 * former List/Map container aliases, are gone as of Plan native-5d
 * Task 4 -- see the host .inc's own header comment.) */
void rt_ext_SerBlockMoveData(void *src, void *dst, int32_t n) { BlockMoveData((Ptr)src, (Ptr)dst, (Size)n); }
void *rt_ext_SerNewPtr(int32_t size) { return (void *)NewPtr((Size)size); }
void rt_ext_SerDisposePtr(void *p) { DisposePtr((Ptr)p); }
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

/* rt_ext_CorePanic: core.cla's own extern name (Plan native-5d Task 3),
 * mirroring runtime/host/rt_ext_host.inc's own rt_ext_CorePanic
 * exactly -- core.cla is now spliced FIRST (unconditional, ahead of every
 * other runtime module), so its rtPanic -> CorePanic call must not share a
 * name with the generic rt_ext_Panic a user program might also declare. */
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
 * just above (mirrors runtime/host/rt_ext_host.inc exactly); core.cla's
 * rtSetLastErr forwards here so lastError storage is platform-owned again
 * (rt_lasterr_code/rt_lasterr_msg, rt_core.inc), not a separate Clarus-side
 * global pair -- this is what makes runtime/mac/rt_ui.c's TextEdit >32k
 * clamp (which calls rt_set_lasterr directly from inside the event loop)
 * visible to a subsequent `lastError` read again. */
void rt_ext_CoreSetLastErr(int32_t code, const uint8_t *msg) {
    char buf[256];
    uint8_t n = msg[0];
    memmove(buf, msg + 1, (size_t)n);
    buf[n] = '\0';
    rt_set_lasterr(code, buf);
}

/* rt_ext_StrBlockMoveData: str.cla's own extern name (Plan 5b Task 8),
 * same reasoning as the host .inc -- str.cla is unconditional, so it
 * can't share a name with the generic waist extern a user program might
 * also declare (testdata/lowlevel/peekpoke.cla's own `external func
 * BlockMoveData`). (rt_ext_StrSetLastErr/rt_ext_StrPanic, str.cla's own
 * former SetLastErr/Panic aliases, are gone as of Plan native-5d Task 3 --
 * see the host .inc's own header comment.) */
void rt_ext_StrBlockMoveData(void *src, void *dst, int32_t n) { BlockMoveData((Ptr)src, (Ptr)dst, (Size)n); }

/* rt_ext_TextHandleDeref/TextSetHandleSize/TextBlockMoveData/TextNewPtr/
 * TextDisposePtr: text.cla's own extern names (Plan 5b Task 9), same
 * reasoning as the host .inc -- text.cla is unconditional, so it can't
 * share a name with the generic/Str/Ser waist externs a user program or
 * another runtime module might also declare. (rt_ext_TextNewRaw, the
 * one-time "whole rt_text_new delegation" birth-allocation wrapper, is
 * gone as of Plan 5c wave2a Task 2 -- birth moved into text.cla itself,
 * built from rt_ext_TextNewPtr/TextNewHandle below. rt_ext_TextSetLastErr/
 * rt_ext_TextPanic, text.cla's own former SetLastErr/Panic aliases, are
 * gone as of Plan native-5d Task 3 -- see the host .inc's own header
 * comment.) */
void *rt_ext_TextHandleDeref(void *h) { return *(void **)h; }
int32_t rt_ext_TextSetHandleSize(void *h, int32_t n) { SetHandleSize((Handle)h, (Size)n); return (int32_t)MemError(); }
void rt_ext_TextBlockMoveData(void *src, void *dst, int32_t n) { BlockMoveData((Ptr)src, (Ptr)dst, (Size)n); }
/* rt_ext_TextNewPtr (review round 1 fix, Critical): text.cla's own
 * scratch-buffer allocator, a NewPtr block mirroring rt_text_concat's own
 * scratch choice (rt_core.inc:307-308) exactly. Checks for NULL and panics
 * right here, same placement rt_core_new_struct uses for every OTHER
 * NewPtr in this runtime, rather than pushing a ptr(0) check out to
 * text.cla's own call sites. */
void *rt_ext_TextNewPtr(int32_t size) {
    void *p = (void *)NewPtr((Size)size);
    if (!p) rt_panic("out of memory");
    return p;
}
void rt_ext_TextDisposePtr(void *p) { DisposePtr((Ptr)p); }

/* rt_ext_TextNewHandle/TextDisposeHandle/TextRcCheck (Plan 5c Task 1: ARC
 * waist externs; live as of Task 2, which ports rtTextNew/rtTextRetain/
 * rtTextRelease into text.cla against exactly these three): mirrors
 * runtime/host/rt_ext_host.inc's block exactly, except
 * rt_ext_TextRcCheck's body is a no-op -- no ledger on Mac, and the real
 * Memory Manager has no equivalent lookup (same "Mac: no-op" rule
 * rt_rc_check itself uses, rt_core.inc:765-766). */
void *rt_ext_TextNewHandle(int32_t n) {
    void *h = (void *)NewHandle((Size)n);
    if (!h) rt_core_oom();
    return h;
}
void rt_ext_TextDisposeHandle(void *h) { DisposeHandle((Handle)h); }
void rt_ext_TextRcCheck(void *box, int32_t rc) { (void)box; (void)rc; }

/* rt_ext_ListHandleDeref/ListSetHandleSize/ListBlockMoveData: list.cla's
 * own extern names (Plan 5b Task 10), mirroring
 * runtime/host/rt_ext_host.inc's List block exactly -- same reasoning
 * as the Text family above. (rt_ext_ListNewRaw, the one-time "whole
 * rt_list_new delegation" birth-allocation wrapper, is gone as of Plan 5c
 * wave2a Task 3 -- birth moved into list.cla itself, built from
 * rt_ext_ListNewPtr/ListNewHandle below. rt_ext_ListPanic, list.cla's own
 * former Panic alias, is gone as of Plan native-5d Task 3 -- see the host
 * .inc's own header comment.) */
void *rt_ext_ListHandleDeref(void *h) { return *(void **)h; }
int32_t rt_ext_ListSetHandleSize(void *h, int32_t n) { SetHandleSize((Handle)h, (Size)n); return (int32_t)MemError(); }
void rt_ext_ListBlockMoveData(void *src, void *dst, int32_t n) { BlockMoveData((Ptr)src, (Ptr)dst, (Size)n); }

/* rt_ext_ListNewHandle/ListDisposeHandle/ListRcCheck/ListNewPtr/
 * ListDisposePtr (Plan 5c Task 1: ARC waist externs; live as of Task 3,
 * which ports rtListNew/rtListRetain/rtListRelease into list.cla against
 * exactly these five): mirrors runtime/host/rt_ext_host.inc's block
 * exactly, except rt_ext_ListRcCheck's body is a no-op -- no ledger on
 * Mac, and the real Memory Manager has no equivalent lookup (same "Mac:
 * no-op" rule rt_rc_check itself uses, rt_core.inc:765-766). */
void *rt_ext_ListNewHandle(int32_t n) {
    void *h = (void *)NewHandle((Size)n);
    if (!h) rt_core_oom();
    return h;
}
void rt_ext_ListDisposeHandle(void *h) { DisposeHandle((Handle)h); }
void rt_ext_ListRcCheck(void *box, int32_t rc) { (void)box; (void)rc; }
void *rt_ext_ListNewPtr(int32_t size) {
    void *p = (void *)NewPtr((Size)size);
    if (!p) rt_panic("out of memory");
    return p;
}
void rt_ext_ListDisposePtr(void *p) { DisposePtr((Ptr)p); }

/* rt_ext_MapHandleDeref/MapSetHandleSize/MapBlockMoveData: map.cla's own
 * extern names (Plan 5b Task 11), mirroring
 * runtime/host/rt_ext_host.inc's Map block exactly -- same reasoning
 * as the Text/List families above. (rt_ext_MapNewRaw is gone as of Plan 5c
 * wave2a Task 4 -- see that .inc file's own header comment. rt_ext_MapPanic,
 * map.cla's own former Panic alias, is gone as of Plan native-5d Task 3 --
 * see the host .inc's own header comment.) */
void *rt_ext_MapHandleDeref(void *h) { return *(void **)h; }
int32_t rt_ext_MapSetHandleSize(void *h, int32_t n) { SetHandleSize((Handle)h, (Size)n); return (int32_t)MemError(); }
void rt_ext_MapBlockMoveData(void *src, void *dst, int32_t n) { BlockMoveData((Ptr)src, (Ptr)dst, (Size)n); }

/* rt_ext_MapNewHandle/MapDisposeHandle/MapRcCheck/MapNewPtr/MapDisposePtr
 * (Plan 5c Task 1: ARC waist externs): mirrors
 * runtime/host/rt_ext_host.inc's block exactly, except
 * rt_ext_MapRcCheck's body is a no-op, same reasoning as the List family
 * above. */
void *rt_ext_MapNewHandle(int32_t n) {
    void *h = (void *)NewHandle((Size)n);
    if (!h) rt_core_oom();
    return h;
}
void rt_ext_MapDisposeHandle(void *h) { DisposeHandle((Handle)h); }
void rt_ext_MapRcCheck(void *box, int32_t rc) { (void)box; (void)rc; }
void *rt_ext_MapNewPtr(int32_t size) {
    void *p = (void *)NewPtr((Size)size);
    if (!p) rt_panic("out of memory");
    return p;
}
void rt_ext_MapDisposePtr(void *p) { DisposePtr((Ptr)p); }

/* rt_ext_SortedMapHandleDeref/SortedMapSetHandleSize/SortedMapBlockMoveData/
 * SortedMapNewPtr/SortedMapDisposePtr/SortedMapNewHandle/SortedMapDisposeHandle/
 * SortedMapRcCheck (map-hashtable Task 1, 2026-08-10): sortedmap.cla's own
 * extern wrappers backing the preserved sorted-array map implementation.
 * Mirrors runtime/host/rt_ext_host.inc's block exactly, except
 * rt_ext_SortedMapRcCheck's body is a no-op -- no ledger on Mac. */
void *rt_ext_SortedMapHandleDeref(void *h) { return *(void **)h; }
int32_t rt_ext_SortedMapSetHandleSize(void *h, int32_t n) { SetHandleSize((Handle)h, (Size)n); return (int32_t)MemError(); }
void rt_ext_SortedMapBlockMoveData(void *src, void *dst, int32_t n) { BlockMoveData((Ptr)src, (Ptr)dst, (Size)n); }
void *rt_ext_SortedMapNewHandle(int32_t n) {
    void *h = (void *)NewHandle((Size)n);
    if (!h) rt_core_oom();
    return h;
}
void rt_ext_SortedMapDisposeHandle(void *h) { DisposeHandle((Handle)h); }
void rt_ext_SortedMapRcCheck(void *box, int32_t rc) { (void)box; (void)rc; }
void *rt_ext_SortedMapNewPtr(int32_t size) {
    void *p = (void *)NewPtr((Size)size);
    if (!p) rt_panic("out of memory");
    return p;
}
void rt_ext_SortedMapDisposePtr(void *p) { DisposePtr((Ptr)p); }

/* ---- native-5e Task 7 Step 1: ui.cla/uiwidgets.cla Toolbox extern block ----
 * One rt_ext_Ui<Name> wrapper per `external func Ui<Name>` declared in
 * runtime/clarus/ui.cla and runtime/clarus/uiwidgets.cla -- Mac-ONLY (no
 * runtime/host/rt_ext_host.inc counterpart: there is no host/console
 * UI). Each is a thin one-line cast-and-call of the real Toolbox routine,
 * mirroring the two files' own doc comments for exactly which rt_ui.c call
 * site(s) need it; no logic beyond the cast (Step 1 adds no behavior).
 * cprint always renders an extern call as `rt_ext_NAME(args)` regardless of
 * its `trap`/`inline` clause (fpCallExt, cprint.cla:1016 -- clauses are a
 * codegen68k-only concern, confirmed by grep: cprint.cla has no "inline"/
 * trap-clause handling at all) -- so UiHandleDeref needs a wrapper here too,
 * exactly like TextHandleDeref/ListHandleDeref/MapHandleDeref already do
 * above, even though its own declaration reads `= inline deref`. */
/* rt_ext_ui_pt: every Point-by-value extern param (ui.cla/uiwidgets.cla's
 * own doc comments: "4-byte Toolbox by-value structs (Point/Cell) are
 * `int` extern params, packed v/h, v in the high word") arrives here as a
 * plain int32_t -- rebuild the real Point by shifting rather than
 * `*(Point *)&pt` (a strict-aliasing violation the m68k cross-compiler is
 * not guaranteed to tolerate); v in the high 16 bits, h in the low 16,
 * matching QuickDraw's own Point-as-long convention on this big-endian
 * target. */
static Point rt_ext_ui_pt(int32_t packed) {
    Point p;
    p.v = (short)(packed >> 16);
    p.h = (short)(packed & 0xFFFF);
    return p;
}
void *rt_ext_UiHandleDeref(void *h) { return *(void **)h; }
void *rt_ext_UiNewPtr(int32_t size) { return (void *)NewPtr((Size)size); }
void *rt_ext_UiNewPtrClear(int32_t size) { return (void *)NewPtrClear((Size)size); }
void *rt_ext_UiNewHandleClear(int32_t size) { return (void *)NewHandleClear((Size)size); }
void rt_ext_UiDisposeHandle(void *h) { DisposeHandle((Handle)h); }
void rt_ext_UiDisposePtr(void *p) { DisposePtr((Ptr)p); }
void rt_ext_UiHLock(void *h) { HLock((Handle)h); }
void rt_ext_UiHUnlock(void *h) { HUnlock((Handle)h); }
void rt_ext_UiBlockMoveData(void *src, void *dst, int32_t n) { BlockMoveData((Ptr)src, (Ptr)dst, (Size)n); }

void rt_ext_UiGetPort(void *port) { GetPort((GrafPtr *)port); }
void rt_ext_UiSetPort(void *port) { SetPort((GrafPtr)port); }

void *rt_ext_UiFrontWindow(void) { return (void *)FrontWindow(); }
void *rt_ext_UiNewWindow(void *wStorage, void *boundsRect, void *title, int32_t visible, short procId, void *behind, int32_t goAwayFlag, int32_t refCon) {
    return (void *)NewWindow(wStorage, (const Rect *)boundsRect, (ConstStr255Param)title, (Boolean)visible, procId, (WindowRef)behind, (Boolean)goAwayFlag, (long)refCon);
}
void rt_ext_UiShowWindow(void *window) { ShowWindow((WindowRef)window); }
void rt_ext_UiDisposeWindow(void *window) { DisposeWindow((WindowRef)window); }
void rt_ext_UiSetWRefCon(void *window, int32_t data) { SetWRefCon((WindowRef)window, (long)data); }
int32_t rt_ext_UiGetWRefCon(void *window) { return (int32_t)GetWRefCon((WindowRef)window); }
void rt_ext_UiSetWTitle(void *window, void *title) { SetWTitle((WindowRef)window, (ConstStr255Param)title); }
void rt_ext_UiGetWTitle(void *window, void *title) { GetWTitle((WindowRef)window, (unsigned char *)title); }
void rt_ext_UiSelectWindow(void *window) { SelectWindow((WindowRef)window); }
void rt_ext_UiDragWindow(void *window, int32_t startPt, void *boundsRect) { DragWindow((WindowRef)window, rt_ext_ui_pt(startPt), (const Rect *)boundsRect); }
int32_t rt_ext_UiGrowWindow(void *window, int32_t startPt, void *bBox) { return (int32_t)GrowWindow((WindowRef)window, rt_ext_ui_pt(startPt), (const Rect *)bBox); }
void rt_ext_UiSizeWindow(void *window, short w, short h, int32_t fUpdate) { SizeWindow((WindowRef)window, w, h, (Boolean)fUpdate); }
void rt_ext_UiZoomWindow(void *window, short partCode, int32_t front) { ZoomWindow((WindowRef)window, partCode, (Boolean)front); }
int32_t rt_ext_UiTrackBox(void *window, int32_t thePt, short partCode) { return (int32_t)TrackBox((WindowRef)window, rt_ext_ui_pt(thePt), partCode); }
int32_t rt_ext_UiTrackGoAway(void *window, int32_t thePt) { return (int32_t)TrackGoAway((WindowRef)window, rt_ext_ui_pt(thePt)); }
short rt_ext_UiFindWindow(int32_t pt, void *wpOut) { return (short)FindWindow(rt_ext_ui_pt(pt), (WindowRef *)wpOut); }

void *rt_ext_UiNewMenu(short menuId, void *menuTitle) { return (void *)NewMenu(menuId, (ConstStr255Param)menuTitle); }
void rt_ext_UiDisposeMenu(void *theMenu) { DisposeMenu((MenuRef)theMenu); }
void rt_ext_UiAppendMenu(void *theMenu, void *data) { AppendMenu((MenuRef)theMenu, (ConstStr255Param)data); }
/* rt_ext_UiAppendMenuStr: UiAppendMenu's `string`-param sibling (Task 7) --
 * same trap (0xA933), the `string` param arrives already Str255-marshaled
 * (same convention as every other `string` extern param this port uses),
 * so the body is identical to rt_ext_UiAppendMenu's. */
void rt_ext_UiAppendMenuStr(void *theMenu, const uint8_t *data) { AppendMenu((MenuRef)theMenu, (ConstStr255Param)data); }
void rt_ext_UiInsertMenu(void *theMenu, short beforeId) { InsertMenu((MenuRef)theMenu, beforeId); }
void rt_ext_UiDeleteMenu(short menuId) { DeleteMenu(menuId); }
void rt_ext_UiDrawMenuBar(void) { DrawMenuBar(); }
void rt_ext_UiHiliteMenu(short menuId) { HiliteMenu(menuId); }
void rt_ext_UiEnableItem(void *theMenu, short item) { EnableItem((MenuRef)theMenu, item); }
void rt_ext_UiDisableItem(void *theMenu, short item) { DisableItem((MenuRef)theMenu, item); }
short rt_ext_UiCountMItems(void *theMenu) { return (short)CountMItems((MenuRef)theMenu); }
void rt_ext_UiGetMenuItemText(void *theMenu, short item, void *itemString) { GetMenuItemText((MenuRef)theMenu, item, (unsigned char *)itemString); }
void rt_ext_UiAppendResMenu(void *theMenu, int32_t theType) { AppendResMenu((MenuRef)theMenu, (ResType)theType); }
int32_t rt_ext_UiMenuSelect(int32_t startPt) { return (int32_t)MenuSelect(rt_ext_ui_pt(startPt)); }
int32_t rt_ext_UiMenuKey(short ch) { return (int32_t)MenuKey((CharParameter)ch); }

int32_t rt_ext_UiWaitNextEvent(short eventMask, void *theEvent, int32_t sleep, void *mouseRgn) {
    return (int32_t)WaitNextEvent((EventMask)eventMask, (EventRecord *)theEvent, (UInt32)sleep, (RgnHandle)mouseRgn);
}
int32_t rt_ext_UiGetNextEvent(short eventMask, void *theEvent) { return (int32_t)GetNextEvent((EventMask)eventMask, (EventRecord *)theEvent); }
void rt_ext_UiFlushEvents(int32_t masks) { FlushEvents((EventMask)(masks & 0xFFFF), (EventMask)((masks >> 16) & 0xFFFF)); }
int32_t rt_ext_UiStillDown(void) { return (int32_t)StillDown(); }
void rt_ext_UiGetMouse(void *mouseLoc) { GetMouse((Point *)mouseLoc); }
void rt_ext_UiGlobalToLocal(void *pt) { GlobalToLocal((Point *)pt); }
void rt_ext_UiSysBeep(short duration) { SysBeep(duration); }

int32_t rt_ext_UiTickCount(void) { return (int32_t)TickCount(); }
/* Gestalt answers in two registers on the raw 68k trap (D0 = OSErr, A0 =
   response value), so ui.cla declares it as two single-result externs --
   see toolbox/osutils.cla's header comment. The C lane just calls the real
   Gestalt() twice; it is a pure query. Deliberate lane divergence on the
   ERROR path: this shim returns 0 when Gestalt fails, while the native
   `ret a0` extern returns whatever A0 happens to hold. Harmless -- every
   caller checks the Err half first and never reads the Value half on a
   failure -- and not worth a native-side guard the language can't express
   without emitting glue. */
short rt_ext_UiGestaltErr(int32_t selector) { long r; return (short)Gestalt((OSType)selector, &r); }
int32_t rt_ext_UiGestaltValue(int32_t selector) { long r = 0; if (Gestalt((OSType)selector, &r) != noErr) { r = 0; } return (int32_t)r; }
void rt_ext_UiHideCursor(void) { HideCursor(); }
short rt_ext_UiOpenDeskAcc(void *deskAccName) { return OpenDeskAcc((ConstStr255Param)deskAccName); }
void rt_ext_UiParamText(void *param0, void *param1, void *param2, void *param3) {
    ParamText((ConstStr255Param)param0, (ConstStr255Param)param1, (ConstStr255Param)param2, (ConstStr255Param)param3);
}
short rt_ext_UiNoteAlert(short alertId, void *modalFilter) { return NoteAlert(alertId, (ModalFilterUPP)modalFilter); }
short rt_ext_UiAlert(short alertId, void *modalFilter) { return Alert(alertId, (ModalFilterUPP)modalFilter); }

void *rt_ext_UiNewControl(void *owningWindow, void *boundsRect, void *controlTitle, int32_t initiallyVisible, short initialValue, short minimumValue, short maximumValue, short procId, int32_t controlReference) {
    return (void *)NewControl((WindowRef)owningWindow, (const Rect *)boundsRect, (ConstStr255Param)controlTitle, (Boolean)initiallyVisible, initialValue, minimumValue, maximumValue, procId, (SInt32)controlReference);
}
void rt_ext_UiMoveControl(void *theControl, short h, short v) { MoveControl((ControlRef)theControl, h, v); }
void rt_ext_UiSizeControl(void *theControl, short w, short h) { SizeControl((ControlRef)theControl, w, h); }
void rt_ext_UiHiliteControl(void *theControl, short hiliteState) { HiliteControl((ControlRef)theControl, hiliteState); }
void rt_ext_UiSetControlValue(void *theControl, short newValue) { SetControlValue((ControlRef)theControl, newValue); }
short rt_ext_UiGetControlValue(void *theControl) { return (short)GetControlValue((ControlRef)theControl); }
void rt_ext_UiSetControlTitle(void *theControl, void *title) { SetControlTitle((ControlRef)theControl, (ConstStr255Param)title); }
void rt_ext_UiDrawControls(void *theWindow) { DrawControls((WindowRef)theWindow); }
/* rt_ext_UiFindControl/rt_ext_UiTrackControl: Task 7 Step 4 review fix --
 * see uiwidgets.cla's own comment. */
short rt_ext_UiFindControl(int32_t testPoint, void *theWindow, void *theControl) {
    return FindControl(rt_ext_ui_pt(testPoint), (WindowRef)theWindow, (ControlRef *)theControl);
}
short rt_ext_UiTrackControl(void *theControl, int32_t startPoint, void *actionProc) {
    return TrackControl((ControlRef)theControl, rt_ext_ui_pt(startPoint), (ControlActionUPP)actionProc);
}

void rt_ext_UiMoveTo(short h, short v) { MoveTo(h, v); }
void rt_ext_UiLineTo(short h, short v) { LineTo(h, v); }
void rt_ext_UiSetRect(void *r, short left, short top, short right, short bottom) { SetRect((Rect *)r, left, top, right, bottom); }
void rt_ext_UiInsetRect(void *r, short dh, short dv) { InsetRect((Rect *)r, dh, dv); }
int32_t rt_ext_UiEqualRect(void *rect1, void *rect2) { return (int32_t)EqualRect((const Rect *)rect1, (const Rect *)rect2); }
void rt_ext_UiEraseRect(void *r) { EraseRect((const Rect *)r); }
void rt_ext_UiFrameRect(void *r) { FrameRect((const Rect *)r); }
void rt_ext_UiFillRect(void *r, void *pat) { FillRect((const Rect *)r, (const Pattern *)pat); }
void rt_ext_UiInvalRect(void *badRect) { InvalRect((const Rect *)badRect); }
int32_t rt_ext_UiPtInRect(int32_t pt, void *r) { return (int32_t)PtInRect(rt_ext_ui_pt(pt), (const Rect *)r); }
void rt_ext_UiFrameOval(void *r) { FrameOval((const Rect *)r); }
void rt_ext_UiFillOval(void *r, void *pat) { FillOval((const Rect *)r, (const Pattern *)pat); }
void rt_ext_UiPenSize(short width, short height) { PenSize(width, height); }
void rt_ext_UiPenNormal(void) { PenNormal(); }
void rt_ext_UiFrameRoundRect(void *r, short ovalWidth, short ovalHeight) { FrameRoundRect((const Rect *)r, ovalWidth, ovalHeight); }
void rt_ext_UiDrawString(void *s) { DrawString((ConstStr255Param)s); }
void rt_ext_UiCopyBits(void *srcBits, void *dstBits, void *srcRect, void *dstRect, short mode, void *maskRgn) {
    CopyBits((const BitMap *)srcBits, (const BitMap *)dstBits, (const Rect *)srcRect, (const Rect *)dstRect, mode, (RgnHandle)maskRgn);
}
void *rt_ext_UiNewRgn(void) { return (void *)NewRgn(); }
void rt_ext_UiDisposeRgn(void *rgn) { DisposeRgn((RgnHandle)rgn); }
void rt_ext_UiClipRect(void *r) { ClipRect((const Rect *)r); }
void rt_ext_UiSetClip(void *rgn) { SetClip((RgnHandle)rgn); }
void rt_ext_UiGetClip(void *rgn) { GetClip((RgnHandle)rgn); }
void rt_ext_UiDrawGrowIcon(void *window) { DrawGrowIcon((WindowRef)window); }
void rt_ext_UiBeginUpdate(void *window) { BeginUpdate((WindowRef)window); }
void rt_ext_UiEndUpdate(void *window) { EndUpdate((WindowRef)window); }
/* rt_ext_UiTextBox: Task 7 Step 1 review fix -- see uiwidgets.cla's own
 * UiTextBox comment for why this stateless TextEdit.h primitive (no live
 * TEHandle involved) belongs in the in-scope extern set despite sharing a
 * file with the excluded live-TE calls. */
void rt_ext_UiTextBox(void *text, int32_t length, void *box, short just) { TETextBox(text, (long)length, (const Rect *)box, just); }

void rt_ext_UiOpenPort(void *port) { OpenPort((GrafPtr)port); }
void rt_ext_UiClosePort(void *port) { ClosePort((GrafPtr)port); }
void rt_ext_UiPortSize(short width, short height) { PortSize(width, height); }
void rt_ext_UiSetOrigin(short h, short v) { SetOrigin(h, v); }
void rt_ext_UiSetPortBits(void *bm) { SetPortBits((const BitMap *)bm); }

/* ---- native-5e Task 8: uitext.cla's own TextEdit-Manager/Scrap-Manager/
 * scrollbar extern block. One rt_ext_Ui<Name> wrapper per `external func
 * Ui<Name>` declared there -- same thin cast-and-call convention as the
 * Task 7 block just above. */
void *rt_ext_UiTENew(void *dst, void *view) { return (void *)TENew((const Rect *)dst, (const Rect *)view); }
void rt_ext_UiTEDispose(void *te) { TEDispose((TEHandle)te); }
void rt_ext_UiTESetText(void *text, int32_t length, void *te) { TESetText(text, (long)length, (TEHandle)te); }
void rt_ext_UiTECalText(void *te) { TECalText((TEHandle)te); }
void rt_ext_UiTEUpdate(void *r, void *te) { TEUpdate((const Rect *)r, (TEHandle)te); }
void rt_ext_UiTEClick(int32_t pt, int32_t extend, void *te) { TEClick(rt_ext_ui_pt(pt), (Boolean)extend, (TEHandle)te); }
void rt_ext_UiTEKey(short ch, void *te) { TEKey((CharParameter)ch, (TEHandle)te); }
void rt_ext_UiTECopy(void *te) { TECopy((TEHandle)te); }
void rt_ext_UiTECut(void *te) { TECut((TEHandle)te); }
void rt_ext_UiTEDelete(void *te) { TEDelete((TEHandle)te); }
void rt_ext_UiTEActivate(void *te) { TEActivate((TEHandle)te); }
void rt_ext_UiTEDeactivate(void *te) { TEDeactivate((TEHandle)te); }
void rt_ext_UiTEIdle(void *te) { TEIdle((TEHandle)te); }
void rt_ext_UiTEPaste(void *te) { TEPaste((TEHandle)te); }
void rt_ext_UiTESetSelect(int32_t start, int32_t stop, void *te) { TESetSelect((long)start, (long)stop, (TEHandle)te); }
void rt_ext_UiTEScroll(short dh, short dv, void *te) { TEScroll(dh, dv, (TEHandle)te); }
void rt_ext_UiTEAutoView(int32_t autoFlag, void *te) { TEAutoView((Boolean)autoFlag, (TEHandle)te); }
short rt_ext_UiTextWidth(void *tb, short firstByte, short byteCount) { return TextWidth(tb, firstByte, byteCount); }
void rt_ext_UiTextFont(short f) { TextFont(f); }
void rt_ext_UiTextFace(short face) { TextFace((short)face); }
void rt_ext_UiTextSize(short s) { TextSize(s); }
/* rt_ext_UiTEFromScrap/UiTEToScrap/UiTEGetScrapLength: bare Clarus externs
 * (uitext.cla's own comment explains why -- no real A-line trap word for
 * any of the three, verified against Multiverse.h/TextEdit.h) -- just call
 * the real Toolbox name/macro directly, same as UiMacInitToolbox et al. */
int32_t rt_ext_UiTEFromScrap(void) { return (int32_t)TEFromScrap(); }
int32_t rt_ext_UiTEToScrap(void) { return (int32_t)TEToScrap(); }
int32_t rt_ext_UiTEGetScrapLength(void) { return (int32_t)TEGetScrapLength(); }
int32_t rt_ext_UiZeroScrap(void) { return (int32_t)ZeroScrap(); }
/* rt_ext_UiPutScrap/UiGetScrap (toolbox-cookbook rider 2): wrappers for
 * uitext.cla's own UiPutScrap/UiGetScrap externs, which back the real
 * nat_UiTEFromScrap/nat_UiTEToScrap desk-scrap bridge (native lane only
 * -- see uitext.cla's own doc comment). Same shape as rt_ext_PutScrap/
 * rt_ext_GetScrap below (toolbox/scrap.cla's own catalog wrappers,
 * Task 1); kept as separate symbols since the two extern sets are
 * declared in different Clarus modules. */
int32_t rt_ext_UiPutScrap(int32_t length, int32_t theType, void *source) { return (int32_t)PutScrap((long)length, (ResType)theType, (Ptr)source); }
int32_t rt_ext_UiGetScrap(void *hDest, int32_t theType, void *offset) { return (int32_t)GetScrap((Handle)hDest, (ResType)theType, (long *)offset); }
int32_t rt_ext_UiHGetState(void *h) { return (int32_t)HGetState((Handle)h); }
void rt_ext_UiHSetState(void *h, int32_t flag) { HSetState((Handle)h, (SignedByte)flag); }
short rt_ext_UiGetControlMaximum(void *theControl) { return GetControlMaximum((ControlRef)theControl); }
void rt_ext_UiSetControlMaximum(void *theControl, short newMaximum) { SetControlMaximum((ControlRef)theControl, newMaximum); }

/* ---- native-5e Task 9: uitable.cla's own List Manager/Menu Manager/
 * QuickDraw/QuickdrawText extern block. One rt_ext_Ui<Name> wrapper per
 * `external func Ui<Name>` declared there -- same thin cast-and-call
 * convention as the Task 7/8 blocks above. Point/Cell by-value params
 * arrive packed (rt_ext_ui_pt, already declared above this file). */
void *rt_ext_UiLNew(void *rView, void *dataBounds, int32_t cSize, short theProc, void *theWindow, int32_t drawIt, int32_t hasGrow, int32_t scrollHoriz, int32_t scrollVert) {
    return (void *)LNew((const Rect *)rView, (const Rect *)dataBounds, rt_ext_ui_pt(cSize), theProc, (WindowRef)theWindow, (Boolean)drawIt, (Boolean)hasGrow, (Boolean)scrollHoriz, (Boolean)scrollVert);
}
void rt_ext_UiLDispose(void *lHandle) { LDispose((ListHandle)lHandle); }
short rt_ext_UiLAddRow(short count, short rowNum, void *lHandle) { return LAddRow(count, rowNum, (ListHandle)lHandle); }
void rt_ext_UiLDelRow(short count, short rowNum, void *lHandle) { LDelRow(count, rowNum, (ListHandle)lHandle); }
int32_t rt_ext_UiLGetSelect(int32_t next, void *theCell, void *lHandle) { return (int32_t)LGetSelect((Boolean)next, (Cell *)theCell, (ListHandle)lHandle); }
void rt_ext_UiLSetSelect(int32_t setIt, int32_t theCell, void *lHandle) { LSetSelect((Boolean)setIt, rt_ext_ui_pt(theCell), (ListHandle)lHandle); }
void rt_ext_UiLSize(short listWidth, short listHeight, void *lHandle) { LSize(listWidth, listHeight, (ListHandle)lHandle); }
void rt_ext_UiLActivate(int32_t act, void *lHandle) { LActivate((Boolean)act, (ListHandle)lHandle); }
void rt_ext_UiLSetDrawingMode(int32_t drawIt, void *lHandle) { LSetDrawingMode((Boolean)drawIt, (ListHandle)lHandle); }
void rt_ext_UiLUpdate(void *theRgn, void *lHandle) { LUpdate((RgnHandle)theRgn, (ListHandle)lHandle); }
int32_t rt_ext_UiLClick(int32_t pt, short modifiers, void *lHandle) { return (int32_t)LClick(rt_ext_ui_pt(pt), (EventModifiers)modifiers, (ListHandle)lHandle); }

void rt_ext_UiSetMenuItemText(void *theMenu, short item, void *itemString) { SetMenuItemText((MenuRef)theMenu, item, (ConstStr255Param)itemString); }
void *rt_ext_UiGetMenuHandle(short menuId) { return (void *)GetMenuHandle(menuId); }
int32_t rt_ext_UiPopUpMenuSelect(void *theMenu, short top, short left, short popUpItem) { return (int32_t)PopUpMenuSelect((MenuRef)theMenu, top, left, popUpItem); }

void rt_ext_UiInvertRect(void *r) { InvertRect((const Rect *)r); }
void rt_ext_UiDrawText(void *textBuf, short firstByte, short byteCount) { DrawText(textBuf, firstByte, byteCount); }
void rt_ext_UiGetFontInfo(void *info) { GetFontInfo((FontInfo *)info); }
void rt_ext_UiLocalToGlobal(void *pt) { LocalToGlobal((Point *)pt); }
void rt_ext_UiNumToString(int32_t theNum, void *theString) { NumToString((long)theNum, (unsigned char *)theString); }

/* rt_ext_UiCbAddr (Task 9, toolbox-integration Feature C: `callback func`
 * migration): the trivial identity extern uitable.cla's own UiCbAddr
 * declares -- ptr in, same ptr out. Its ONLY job is to satisfy
 * checkCallbackFunc's decay rule (a bare `callback func` name is legal
 * only as an extern call's ptr-typed argument) so uitable.cla's own
 * rtUiMakeLdefStub can turn rtUiLdefDraw's own glue address into a plain
 * `ptr` value it can int()-convert and poke into the LDEF JMP-stub
 * Handle. This REPLACES the two hand-written pascal wrappers (and the
 * two zero-arg externs they backed) that used to live here: the real
 * pascal marshaling for rtUiScrollbarAction/rtUiLdefDraw now lives entirely in
 * cprint's generated clar_cb_<name> glue (CLAR_PASCAL-qualified,
 * emitted per Task 7/8's `callback func` machinery) -- rtUiScrollbarAction
 * itself decays directly into UiTrackControl's own actionProc argument
 * (uitext.cla), needing no wrapper here at all. */
void *rt_ext_UiCbAddr(void *cb) { return cb; }

/* ==================== Task 7 (native-5e UI port) glue ==================== */
#include <AppleEvents.h>
#include <OSUtils.h> /* SetCurrentA5 -- rt_ext_UiCurrentA5 (Task 7 Step 5) */

/* rt_ext_UiStrAddr (Task 7 Step 5, uiscript.cla's own UiStrAddr): the
 * `string` extern param `s` ALREADY arrives here as a plain address
 * (the compiler's own str-marshaling did the work at the call site) --
 * this is a pure identity function, letting Clarus source recover a
 * `ptr` from a literal/local `string` expression it otherwise has no
 * address-of operator for (see uiscript.cla's own header comment).
 */
void *rt_ext_UiStrAddr(const uint8_t *s) { return (void *)s; }

/* rt_ext_UiCurrentA5: this task's own brief already calls out
 * "UiCurrentA5 (cprint shim only this task)" as required. */
void *rt_ext_UiCurrentA5(void) { return (void *)SetCurrentA5(); }

/* rt_ext_TbCurrentA5 (test-suite-review Task 13): testsuite/toolbox/
 * cases_a5.cla's own locally-declared `TbCurrentA5` extern (same
 * `= inline a5` clause as UiCurrentA5 above, distinct name to avoid
 * colliding with uiscript.cla's own declaration once the runtime module
 * splices in -- same precedent as cases_events.cla's TbTickCount/
 * TbMenuKey). The native (cg68k) lane resolves `inline a5` directly to a
 * `MOVE.L A5,D0` with no C shim at all; cprint ignores the clause
 * entirely (irExternConv is a native-only concern) and falls back to an
 * ordinary named rt_ext_ shim instead, same as every other bare glue
 * extern -- identical body to rt_ext_UiCurrentA5 above. */
void *rt_ext_TbCurrentA5(void) { return (void *)SetCurrentA5(); }

/* rt_ext_UiTestEmit: no-ops unless RT_MAC_TEST (mirrors rt_mac.c's own
 * pattern -- this task's own brief). `s` is a `ptr` to a fresh rt_text*
 * (text.cla's own box layout: `{ int32_t rc; Handle h; int32_t len;
 * int32_t cap; }`, rt_core.inc) -- read its bytes directly and hand them
 * to the EXISTING rt_test_emit (rt_mac.c:160, NUL-terminated-C-string
 * convention, unchanged).
 */
#ifdef RT_MAC_TEST
void rt_ext_UiTestEmit(void *s) {
    rt_text *t = (rt_text *)s;
    char buf[512];
    int32_t n = t->len;
    if (n > (int32_t)sizeof(buf) - 1) n = (int32_t)sizeof(buf) - 1;
    if (n > 0) memmove(buf, *(t->h), (size_t)n);
    buf[n] = '\0';
    rt_test_emit(buf);
}
#else
void rt_ext_UiTestEmit(void *s) { (void)s; }
#endif

/* rt_ui_test_script's weak default: moved here from rt_ui.c, which is
 * never linked (build-mac.sh drops it from the CMake source list
 * entirely) -- without this, a build with no `--events` override (a
 * real, non-scripted build) would leave the symbol wholly undefined, a
 * link error. Every scripted scenario's own generated events.c still
 * provides a STRONG override (unchanged weak/strong precedent, same as
 * rt_app_creator's own, rt_mac.c:380).
 */
__attribute__((weak)) const char rt_ui_test_script[] = "";

void rt_ext_UiMacInitToolbox(void) { rt_mac_init_toolbox(); }
void rt_ext_UiRtQuit(int32_t code) { rt_quit(code); }
void *rt_ext_UiTestScript(void) { return (void *)rt_ui_test_script; }
void rt_ext_UiScreenBounds(void *out) { *(Rect *)out = qd.screenBits.bounds; }
/* rt_ext_UiScreenBits: Task 7 Step 5's own pragmatic snap-data accessor
 * -- see uiscript.cla's own UiScreenBits comment for why this exists
 * alongside (not instead of) UiCurrentA5. */
void rt_ext_UiScreenBits(void *baseAddrOut, void *rowBytesOut, void *boundsOut) {
    *(void **)baseAddrOut = (void *)qd.screenBits.baseAddr;
    *(int32_t *)rowBytesOut = (int32_t)qd.screenBits.rowBytes;
    *(Rect *)boundsOut = qd.screenBits.bounds;
}

/* rt_ext_UiLaunchReal and its AE handlers below call
 * clar_fn_clar_ui_fire_launchdoc/clar_fn_clar_ui_fire_startempty -- the
 * lower.cla-synthesized dispatchers a UI program's generated C defines
 * (lowSynthUiDispatchers). This whole file is compiled unconditionally
 * (rt_mac.c #includes it always, for every program, UI or not), but a
 * non-UI program's own emitted C never defines these two symbols (its
 * main() is the plain CLI path -- it never calls rt_ext_UiLaunchReal at
 * all, since nothing in a non-UI build's own C references it either), so
 * both externs are `weak` here: a UI program's own strong definition
 * overrides as usual, and a non-UI program's build links clean with the
 * unresolved reference silently pinned to null (never actually called).
 *
 * rt_ext_UiLaunchReal: rt_ui_launch's real-build branch (rt_ui.c:3963-4028)
 * adapted verbatim -- AEInstallEventHandler + the 4 pascal AE handlers +
 * AEDesc decoding stay pure C (no function pointers reach Clarus, per
 * Task 7 report log entry #3); each handler calls the Task-6-synthesized
 * dispatcher's own raw C symbol directly (same TU, no extern-indirection
 * needed) instead of the C reference's own openDoc/startEmpty function-
 * pointer args (gone: the synthesized dispatchers are always reachable by
 * name now). Never exercised by any golden scenario (every one is
 * script-driven, taking rt_ui_launch's OTHER branch, ported in Clarus in
 * ui.cla's own rtUiLaunch) -- ported for contract completeness.
 */
extern void clar_fn_clar_ui_fire_launchdoc(void *path) __attribute__((weak));
extern void clar_fn_clar_ui_fire_startempty(void) __attribute__((weak));

#define RT_UI_SIZE_HLE_MASK 0x0040 /* isHighLevelEventAware -- see rt_ui.c's own derivation comment, :3780-3798 */

static void rt_ext_ui_pstrcpy(unsigned char *dst, const unsigned char *src) {
    unsigned char n, i;
    n = src ? src[0] : 0;
    for (i = 0; i < n; i++) dst[1 + i] = src[1 + i];
    dst[0] = n;
}

/* rt_ext_UiSFGetFile/rt_ext_UiSFPutFile (Task 10): the real (non-scripted)
 * halves of askOpen/askSave -- rt_ui_ask_open/rt_ui_ask_save's own Point/
 * SFReply marshaling (rt_ui.c:2399-2455) adapted verbatim. SFGetFile/
 * SFPutFile are routine-selector Pascal traps (Multiverse.h's own
 * M68K_INLINE(0x3F3C, <selector>, 0xA9EA) encoding), not a single plain
 * trap word uidialogs.cla's own `= trap` clause could express directly --
 * bare Clarus externs (UiSFGetFile/UiSFPutFile, uidialogs.cla) resolving
 * to these wrappers, same "the cprint-lane rt_ext_ wrapper just calls the
 * real C name directly" precedent uitext.cla's own UiTEFromScrap/
 * UiTEToScrap/UiTEGetScrapLength already established. Point is always the
 * fixed {100,100} corner (rt_ui.c's own comment: "System 6 has no
 * auto-center convention") -- never varies by caller, so it's baked in
 * here rather than threaded through as a Clarus-side argument.
 * SFReply.fName (Str63) is copied into the caller's Str255 scratch via
 * the same rt_ext_ui_pstrcpy helper just above (already used for an
 * FSSpec name in the AE odoc handler below). Never exercised by any
 * golden scenario (every one is script-driven, taking rtUiAskOpen/
 * rtUiAskSave's OTHER branch in uidialogs.cla) -- ported for contract
 * completeness, same status as rt_ext_UiLaunchReal below. */
/* rt_ext_UiSFGetFile (native-gaps-cleanup Task 2): filter255 is askOpen's
 * own `types` arg (a Str255 -- comma-separated 4-char codes, "*" = all
 * files). Parsed here into up to 4 SFTypeList slots via
 * rt_mac_pack4cc_range (rt_mac.c, defined ahead of this include point) --
 * a 5th code, or any code longer than 4 characters, is lastError + return
 * 0 WITHOUT calling SFGetFile, same rule uidialogs.cla's own
 * nat_UiSFGetFile implements for the native lane.
 */
int32_t rt_ext_UiSFGetFile(void *path255, void *filter255) {
    Point where;
    SFTypeList types;
    SFReply reply;
    const uint8_t *f = (const uint8_t *)filter255;
    uint8_t flen = f[0];
    short numTypes;
    int i, segStart, n;
    unsigned long packed;

    where.h = 100;
    where.v = 100;

    if (flen == 1 && f[1] == '*') {
        numTypes = -1;
    } else {
        n = 0;
        segStart = 0;
        for (i = 0; i <= flen; i++) {
            if (i == flen || f[1 + i] == ',') {
                if (n >= 4) {
                    rt_set_lasterr(2, "askOpen filter must have at most 4 entries");
                    return 0;
                }
                if (!rt_mac_pack4cc_range(f, 1 + segStart, i - segStart, &packed)) {
                    rt_set_lasterr(2, "askOpen filter entry must be at most 4 characters");
                    return 0;
                }
                types[n] = (OSType)packed;
                n++;
                segStart = i + 1;
            }
        }
        numTypes = (short)n;
    }

    SFGetFile(where, (ConstStr255Param)"\p", NULL, numTypes, types, NULL, &reply);
    if (!reply.good) return 0;
    SetVol(NULL, reply.vRefNum);
    rt_ext_ui_pstrcpy((unsigned char *)path255, reply.fName);
    return 1;
}
int32_t rt_ext_UiSFPutFile(void *suggested255, void *path255) {
    Point where;
    SFReply reply;
    where.h = 100;
    where.v = 100;
    SFPutFile(where, (ConstStr255Param)"\pSave as:", (ConstStr255Param)suggested255, NULL, &reply);
    if (!reply.good) return 0;
    SetVol(NULL, reply.vRefNum);
    rt_ext_ui_pstrcpy((unsigned char *)path255, reply.fName);
    return 1;
}

/* rt_ext_PBGetFInfoSync (native-gaps-cleanup Task 3): toolbox/files.cla's
 * `external func PBGetFInfoSync(paramBlock: ptr): int = trap 0xA00C reg`
 * catalog entry, cprint lane. Every OTHER `= trap N reg` extern in this
 * catalog (PBSetVolSync, PBSetFInfoSync) had never actually been CALLED
 * from cprint-compiled Clarus source before Task 3's FInfoStamp case --
 * they're consumed only by the native-68k lane, where cg68k emits the raw
 * A-line trap opcode directly (no C link needed at all), and by
 * runtime/clarus/native.cla/uidialogs.cla's own NATIVE-ONLY redeclarations
 * (never spliced into a cprint build). A bare `trap N reg` extern has no
 * generic cprint fallback -- every rt_ext_NAME symbol needs a hand-written
 * C body, same as every wrapper above -- so this one was simply never
 * written until something called it. One-line passthrough to Retro68's own
 * Universal Interfaces declaration (Files.h), which IS the real Toolbox
 * trap; the ParmBlkPtr cast matches toolbox/files.cla's own FileParam
 * catalog comment (ioNamePtr/ioVRefNum/ioFDirIndex/fdType/fdCreator laid
 * out at the SAME offsets PBGetFInfoSync itself reads/writes). ponytail:
 * PBSetFInfoSync's own cprint-lane wrapper is still missing -- add it the
 * same way the moment a case calls it; toolbox/files.cla's declaration
 * already works native-side, untouched by this gap. */
int32_t rt_ext_PBGetFInfoSync(void *pb) { return (int32_t)PBGetFInfoSync((ParmBlkPtr)pb); }

static OSErr rt_ext_ui_ae_check_missed(const AppleEvent *evt) {
    DescType actualType;
    Size actualSize;
    if (AEGetAttributePtr(evt, keyMissedKeywordAttr, typeWildCard, &actualType, NULL, 0, &actualSize) == noErr) {
        return errAEParamMissed;
    }
    return noErr;
}

static pascal OSErr rt_ext_ui_ae_oapp(const AppleEvent *evt, AppleEvent *reply, long refcon) {
    OSErr err;
    (void)reply; (void)refcon;
    err = rt_ext_ui_ae_check_missed(evt);
    if (err != noErr) return err;
    clar_fn_clar_ui_fire_startempty();
    return noErr;
}

static pascal OSErr rt_ext_ui_ae_odoc(const AppleEvent *evt, AppleEvent *reply, long refcon) {
    AEDescList docList;
    long n, i;
    OSErr err;
    (void)reply; (void)refcon;
    if (AEGetParamDesc(evt, keyDirectObject, typeAEList, &docList) != noErr) return noErr;
    if (AECountItems(&docList, &n) == noErr) {
        for (i = 1; i <= n; i++) {
            FSSpec spec;
            AEKeyword kw;
            DescType actualType;
            Size actualSize;
            short wd;
            unsigned char path255[256];
            if (AEGetNthPtr(&docList, i, typeFSS, &kw, &actualType, &spec, (long)sizeof(spec), &actualSize) != noErr) continue;
            if (OpenWD(spec.vRefNum, spec.parID, 'ERIK', &wd) == noErr) SetVol(NULL, wd);
            rt_ext_ui_pstrcpy(path255, spec.name);
            clar_fn_clar_ui_fire_launchdoc(path255);
        }
    }
    AEDisposeDesc(&docList);
    err = rt_ext_ui_ae_check_missed(evt);
    if (err != noErr) return err;
    return noErr;
}

static pascal OSErr rt_ext_ui_ae_pdoc(const AppleEvent *evt, AppleEvent *reply, long refcon) {
    (void)evt; (void)reply; (void)refcon;
    return errAEEventNotHandled;
}

static pascal OSErr rt_ext_ui_ae_quit(const AppleEvent *evt, AppleEvent *reply, long refcon) {
    OSErr err;
    (void)reply; (void)refcon;
    err = rt_ext_ui_ae_check_missed(evt);
    if (err != noErr) return err;
    rt_ext_UiRtQuit(0); /* rt_ui_quit's real cascade is the ported rtUiQuit --
                            unreachable from here without function pointers,
                            so this mirrors ONLY the C reference's degenerate
                            "quit AE with no windows open" case; a real
                            close-cascade quit-via-AE isn't exercised by any
                            golden (see this block's own header comment). */
    return noErr;
}

void rt_ext_UiLaunchReal(void) {
    long resp;
    int aeAware;

    aeAware = 0;
    if (Gestalt(gestaltAppleEventsAttr, &resp) == noErr && resp != 0) {
        Handle sizeH = GetResource('SIZE', -1);
        if (sizeH) {
            HLock(sizeH);
            if ((*(short *)*sizeH) & RT_UI_SIZE_HLE_MASK) aeAware = 1;
            HUnlock(sizeH);
            ReleaseResource(sizeH);
        }
    }

    if (aeAware) {
        AEInstallEventHandler(kCoreEventClass, kAEOpenApplication, NewAEEventHandlerUPP(rt_ext_ui_ae_oapp), 0, false);
        AEInstallEventHandler(kCoreEventClass, kAEOpenDocuments, NewAEEventHandlerUPP(rt_ext_ui_ae_odoc), 0, false);
        AEInstallEventHandler(kCoreEventClass, kAEPrintDocuments, NewAEEventHandlerUPP(rt_ext_ui_ae_pdoc), 0, false);
        AEInstallEventHandler(kCoreEventClass, kAEQuitApplication, NewAEEventHandlerUPP(rt_ext_ui_ae_quit), 0, false);
        return;
    }

    {
        short count, i;
        OSErr msg;
        CountAppFiles(&msg, &count);
        if (count > 0) {
            for (i = 1; i <= count; i++) {
                AppFile file;
                unsigned char path255[256];
                GetAppFiles(i, &file);
                SetVol(NULL, file.vRefNum);
                rt_ext_ui_pstrcpy(path255, file.fName);
                clar_fn_clar_ui_fire_launchdoc(path255);
            }
            for (i = 1; i <= count; i++) ClrAppFiles(i);
        } else {
            clar_fn_clar_ui_fire_startempty();
        }
    }
}

/* rt_ext_UiAEProcessEvent (mac-resident-clarusc Task 12): ui.cla's shared
 * rtUiRun gained a real kHighLevelEvent arm (UiAEProcessEvent(evBuf)) --
 * this is its cprint-lane body, a one-line forward to the real Toolbox
 * call (already available: AppleEvents.h is included above, for
 * rt_ext_UiLaunchReal's own AE handlers). Link-safety only: rtUiRun is
 * shared source, compiled into every UI program's C output on this lane
 * too, so the symbol must resolve even though rt_ext_UiLaunchReal's own
 * SIZE(-1) resource (build-mac.sh's appres.r, HASAPP-gated the same way
 * app68BuildSize used to be before this task's own native-lane fix) means
 * this arm stays practically unreachable on the cprint lane for a
 * non-app-section program -- a known, deliberately out-of-scope parallel
 * gap this task's report calls out (the native/Snow lane is this task's
 * only proof target). Result discarded, matching rt_ui.c's own call site.
 */
void rt_ext_UiAEProcessEvent(void *evBuf) { (void)AEProcessAppleEvent((EventRecord *)evBuf); }

/* ---- test-suite-review Task 12: testsuite/toolbox/cases_events.cla's own
 * externs (Tb prefix, NOT part of the runtime/clarus/ waist) -- cprint
 * always renders an `external func ... = trap ...` as rt_ext_NAME
 * regardless of which module declared it (fpCallExt's own doc comment),
 * so the Retro68/cprint lane needs a glue entry here even though
 * emit68k's `= trap` compiles straight to the TRAP instruction with no
 * glue required. Same trap words/bodies as rt_ext_UiTickCount/
 * rt_ext_UiMenuKey above -- these are deliberately the SAME real Toolbox
 * calls, just reachable under the testsuite's own extern names so
 * cases_events.cla can declare them without reaching into ui.cla. */
int32_t rt_ext_TbTickCount(void) { return (int32_t)TickCount(); }
int32_t rt_ext_TbMenuKey(short ch) { return (int32_t)MenuKey((CharParameter)ch); }
/* rt_ext_TbHiliteMenu: same real Toolbox call as rt_ext_UiHiliteMenu
 * above (menuKeyMatches-fix, 2026-08-05) -- caseMenuKeyMatches calls the
 * raw MenuKey trap directly and must unhilite the matched menu title
 * itself afterward, same as rtUiMenuDispatch does for real dispatch. */
void rt_ext_TbHiliteMenu(short menuId) { HiliteMenu(menuId); }

/* ---- Task 2 (toolbox-integration): testsuite/toolbox/cases_gestalt.cla's
 * own externs (Tb prefix, same "cprint always renders rt_ext_NAME, needs a
 * glue entry regardless of clause" precedent as the Task 12 block just
 * above) -- same real Toolbox call as rt_ext_UiGestaltErr/
 * rt_ext_UiGestaltValue above, reachable under the suite's own extern
 * names so cases_gestalt.cla can declare its named-reg clauses without
 * reaching into ui.cla. GestaltNamed's whole point is proving the NAMED
 * reg(...) clause dispatches correctly on the native (cg68k) lane; the
 * clause is invisible here exactly as the design spec requires (cprint
 * ignores irExternConv entirely, positional or named alike) -- which is
 * also why the WRONG native register binding this pair replaced
 * (pack3-standardfile Task 5a) never showed on this lane at all. */
short rt_ext_TbGestaltErr(int32_t selector) { long r; return (short)Gestalt((OSType)selector, &r); }
int32_t rt_ext_TbGestaltValue(int32_t selector) { long r = 0; if (Gestalt((OSType)selector, &r) != noErr) { r = 0; } return (int32_t)r; }

/* ---- Task 6 (toolbox-integration Feature B):
 * testsuite/toolbox/cases_event.cla's own externs -- same "cprint always
 * renders rt_ext_NAME regardless of clause" precedent as the two blocks
 * just above. rt_ext_TbEventAvail is the real Toolbox Event Manager trap
 * (task-6-review Critical 1: `_OSEventAvail`, 0xA030, is bit-11-clear --
 * an OS/register-convention trap -- so cases_event.cla declares its
 * Pascal-convention Toolbox sibling `_EventAvail`, 0xA971, instead; same
 * check-without-removing-from-the-queue semantics, see that file's own
 * header comment for the full trap-word bit-11 evidence). The clause
 * (`= trap 0xA971`) is invisible here exactly like TbGestaltErr/
 * TbGestaltValue's own named-reg clauses above -- cprint calls by NAME only.
 * rt_ext_TbXRecAddr mirrors Task 5's own rt_ext_XRecAddr host-lane
 * identity shim (runtime/host/rt_ext_host.inc) -- "the address of my
 * own argument" has no real Toolbox call behind it on ANY backend, so
 * every lane (host rt_ext_, this Mac rt_ext_, and cg68k's nat_ fallback)
 * resolves it as a plain identity. */
int32_t rt_ext_TbEventAvail(short mask, void *ev) { return (int32_t)EventAvail((EventMask)mask, (EventRecord *)ev); }
void *rt_ext_TbXRecAddr(void *p) { return p; }

/* rt_ext_XRecAddr (task-6-review Important 3): testsuite/core/
 * cases_xrec.cla's own extern -- the UNPREFIXED sibling of
 * rt_ext_TbXRecAddr just above, same plain identity, needed here for the
 * SAME reason (cprint always renders rt_ext_NAME regardless of clause) --
 * core suite fixtures reuse Task 5's own `XRecAddr` name directly (no
 * `Tb` prefix -- that convention is toolbox-suite-local) since the host
 * lane's rt_ext_XRecAddr (runtime/host/rt_ext_host.inc) already
 * exists under this exact name. */
void *rt_ext_XRecAddr(void *p) { return p; }

/* rt_ext_TbPostEvent (ui-scenario-retirement Task 3, fix round 1;
 * clobber list verified by decode, native-gaps-cleanup Task 7):
 * testsuite/toolbox/cases_uitest.cla's own extern -- same "cprint always
 * renders rt_ext_NAME regardless of clause" precedent as every block
 * above. Hand-written raw register-trap glue rather than a real-prototype
 * C call like every other block in this file: PostEvent DOES have an
 * EXTERN_API prototype in Retro68's Universal Interfaces
 * (CIncludes/Events.h:562-565, `PostEvent(EventKind eventNum, UInt32
 * eventMsg) ONEWORDINLINE(0xA02F)`, unconditionally available --
 * correcting this block's earlier "no prototype" claim, which grep
 * disproves) -- but its own inline form is a bare ONEWORDINLINE (no
 * post-trap register-shuffling instruction), so hand-rolling the same
 * trap word is equivalent; this glue stays hand-written. eventNum in
 * A0 (low word), eventMsg in D0, `trap 0xA02F` (bit 11 clear -- OS/
 * register convention, cases_event.cla's own header comment works out
 * this exact rule), result read back from D0 -- the identical register
 * assignment cases_uitest.cla's own `= trap 0xA02F reg(a0: eventNum,
 * d0: eventMsg) ret d0` clause already gives cg68k's native lane (that
 * lane needs no glue at all -- the clause compiles straight to the
 * TRAP instruction).
 *
 * Register contract, cited not assumed:
 *   - CIncludes/Events.h:560 `#pragma parameter __D0
 *     PostEvent(__A0, __D0)`: eventNum in A0, eventMsg in D0, OSErr
 *     result in D0. No A0 output listed.
 *   - AIncludes/Events.a:507-519 (`_PostEvent: OPWORD $A02F`) gives the
 *     same contract in its own hand-written comment: "parameters:
 *     eventNum => A0, eventMsg => D0; returns: OSErr <= D0" -- again
 *     no A0 on exit.
 *   - Inside Macintosh Volume II, "Summary of the Operating System
 *     Event Manager" (p. II-74) assembly-language routine table:
 *     "PostEvent  On entry: A0: eventCode (word), D0: eventMsg (long)
 *     / On exit: D0: result code (word)" -- again D0 only; the SAME
 *     table lists FlushEvents' D0 on both entry AND exit (a register
 *     whose exit value genuinely IS defined), so the omission of A0
 *     from PostEvent's exit column is a real "undefined here", not an
 *     editorial gap.
 *   - BUT PostEvent's sibling trap PPostEvent (same low trap byte
 *     0x2F, one extra flag bit: CIncludes/Events.h:496-502,
 *     `TWOWORDINLINE(0xA12F, 0x2288)`) decodes as trap word 0xA12F
 *     followed by second word 0x2288 = MOVE.L A0,(A1) -- Apple's own
 *     compiler-generated glue reads A0 AFTER the trap returns and
 *     stores it into *qEl (AIncludes/Events.a:434-441 confirms
 *     `_PPostEvent: OPWORD $A12F`, `pascal OSErr PPostEvent(EventKind
 *     eventCode, UInt32 eventMsg, EvQElPtr *qEl)`). That proves the
 *     underlying Event Manager trap handler for trap-number 0x2F
 *     leaves a live queue-element pointer in A0 on return; PostEvent's
 *     plain form (bit8 clear) just doesn't surface it. A0 is Event-
 *     Manager-internal scratch/result state after 0xA02F too, not a
 *     caller-preserved register.
 *
 * Verdict: A0 must be a clobber, not a plain input. The prior `"r"(a0)`
 * (input-only) let gcc assume physical a0 is unchanged across the asm
 * -- a latent miscompile risk if gcc ever keeps an unrelated live
 * value pinned in a0 across this statement. Fixed to `"+r"(a0)` (gcc
 * disallows listing a hard-register operand in both an input
 * constraint and the clobber list, so read-write is the standard idiom
 * for "destroyed but I don't need the new value"). D1/A1 stay in the
 * clobber list unchanged: none of the three sources above documents
 * them as preserved for PostEvent, and per project convention
 * (decode-don't-trust), silence is not a preservation guarantee --
 * over-clobbering is safe, under-clobbering isn't. */
/* Non-static: links into every Retro68 Mac build (dead code in no-flag
 * builds; harmless). */
short rt_ext_TbPostEvent(short eventNum, int32_t eventMsg) {
    register int32_t d0 asm("d0") = eventMsg;
    register int32_t a0 asm("a0") = (int32_t)(uint16_t)eventNum;
    asm volatile (
        ".word 0xA02F"
        : "+r" (d0), "+r" (a0)
        :
        : "d1", "a1", "cc", "memory"
    );
    return (short)d0;
}

/* ---- toolbox-cookbook Task 2: testsuite/toolbox/cases_catalog.cla's
 * Catalog case hardware-proves the shipped toolbox/{memory,events,
 * osutils,scrap}.cla extern catalog (Task 1) against real ROM -- same
 * "cprint always renders rt_ext_NAME regardless of clause" precedent as
 * every block above, but the catalog declares its externs under their
 * PLAIN Toolbox names (NewPtr, DisposePtr, NewHandle, DisposeHandle,
 * GetHandleSize, SetHandleSize, BlockMoveData, HLock, HUnlock, TickCount,
 * GestaltErr, GestaltValue, EventAvail, ZeroScrap, PutScrap, GetScrap,
 * InfoScrap), not a
 * suite-local Tb-prefixed alias -- so most of them resolve to glue that
 * already exists elsewhere in this same file: rt_ext_NewPtr/
 * rt_ext_DisposePtr/rt_ext_NewHandle/rt_ext_DisposeHandle/
 * rt_ext_GetHandleSize/rt_ext_SetHandleSize/rt_ext_BlockMoveData are the
 * 5a waist's own definitions at the top of this file -- reused as-is,
 * not redefined here (a second definition under the same C name would be
 * a duplicate-symbol build error, not a passing build). Only the names
 * with no existing plain-named wrapper get one below. */
void rt_ext_HLock(void *h) { HLock((Handle)h); }
void rt_ext_HUnlock(void *h) { HUnlock((Handle)h); }
int32_t rt_ext_TickCount(void) { return (int32_t)TickCount(); }

/* ---- Date/time (2026-08-10 datetime-instrumentation spec) ---- */
int32_t rt_ext_DtReadDateTime(void *t) { return (int32_t)ReadDateTime((unsigned long *)t); }
void rt_ext_DtSecs2Date(int32_t secs, void *d) { SecondsToDate((unsigned long)secs, (DateTimeRec *)d); }
int32_t rt_ext_ReadDateTime(void *t) { return (int32_t)ReadDateTime((unsigned long *)t); }
void rt_ext_SecondsToDate(int32_t secs, void *d) { SecondsToDate((unsigned long)secs, (DateTimeRec *)d); }
int32_t rt_ext_DateToSeconds(void *d) { unsigned long s; DateToSeconds((DateTimeRec *)d, &s); return (int32_t)s; }

short rt_ext_GestaltErr(int32_t selector) { long r; return (short)Gestalt((OSType)selector, &r); }
int32_t rt_ext_GestaltValue(int32_t selector) { long r = 0; if (Gestalt((OSType)selector, &r) != noErr) { r = 0; } return (int32_t)r; }
int32_t rt_ext_EventAvail(short mask, void *ev) { return (int32_t)EventAvail((EventMask)mask, (EventRecord *)ev); }
int32_t rt_ext_ZeroScrap(void) { return (int32_t)ZeroScrap(); }
int32_t rt_ext_PutScrap(int32_t length, int32_t theType, void *source) { return (int32_t)PutScrap((long)length, (ResType)theType, (Ptr)source); }
int32_t rt_ext_GetScrap(void *hDest, int32_t theType, void *offset) { return (int32_t)GetScrap((Handle)hDest, (ResType)theType, (long *)offset); }
void *rt_ext_InfoScrap(void) { return (void *)InfoScrap(); }
/* Uncalled catalog externs -- MoreMasters, Button, StillDown, GetMouse,
 * PostEvent, GetNextEvent, Delay, SysBeep, LoadScrap, UnloadScrap -- are
 * tree-shaken from this suite build (cases_catalog.cla never names them)
 * and need no wrapper yet; add one on demand alongside whichever future
 * case calls it. */

#endif /* CLARUS_RT_EXT_MAC_INC */
