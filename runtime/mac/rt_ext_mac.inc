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
/* rt_ext_Ser{BlockMoveData,NewPtr,DisposePtr}: final-review fix, mirroring
 * internal/build/rt/rt_ext_host.inc's block exactly -- ser.cla's remaining
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
 * mirroring internal/build/rt/rt_ext_host.inc's own rt_ext_CorePanic
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
 * just above (mirrors internal/build/rt/rt_ext_host.inc exactly); core.cla's
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
 * internal/build/rt/rt_ext_host.inc's block exactly, except
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
 * internal/build/rt/rt_ext_host.inc's List block exactly -- same reasoning
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
 * exactly these five): mirrors internal/build/rt/rt_ext_host.inc's block
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
 * internal/build/rt/rt_ext_host.inc's Map block exactly -- same reasoning
 * as the Text/List families above. (rt_ext_MapNewRaw is gone as of Plan 5c
 * wave2a Task 4 -- see that .inc file's own header comment. rt_ext_MapPanic,
 * map.cla's own former Panic alias, is gone as of Plan native-5d Task 3 --
 * see the host .inc's own header comment.) */
void *rt_ext_MapHandleDeref(void *h) { return *(void **)h; }
int32_t rt_ext_MapSetHandleSize(void *h, int32_t n) { SetHandleSize((Handle)h, (Size)n); return (int32_t)MemError(); }
void rt_ext_MapBlockMoveData(void *src, void *dst, int32_t n) { BlockMoveData((Ptr)src, (Ptr)dst, (Size)n); }

/* rt_ext_MapNewHandle/MapDisposeHandle/MapRcCheck/MapNewPtr/MapDisposePtr
 * (Plan 5c Task 1: ARC waist externs): mirrors
 * internal/build/rt/rt_ext_host.inc's block exactly, except
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

/* ---- native-5e Task 7 Step 1: ui.cla/uiwidgets.cla Toolbox extern block ----
 * One rt_ext_Ui<Name> wrapper per `external func Ui<Name>` declared in
 * runtime/clarus/ui.cla and runtime/clarus/uiwidgets.cla -- Mac-ONLY (no
 * internal/build/rt/rt_ext_host.inc counterpart: there is no host/console
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
int32_t rt_ext_UiMenuKey(uint8_t ch) { return (int32_t)MenuKey((CharParameter)ch); }

int32_t rt_ext_UiWaitNextEvent(short eventMask, void *theEvent, int32_t sleep, void *mouseRgn) {
    return (int32_t)WaitNextEvent((EventMask)eventMask, (EventRecord *)theEvent, (UInt32)sleep, (RgnHandle)mouseRgn);
}
int32_t rt_ext_UiGetNextEvent(short eventMask, void *theEvent) { return (int32_t)GetNextEvent((EventMask)eventMask, (EventRecord *)theEvent); }
void rt_ext_UiFlushEvents(short whichMask, short stopMask) { FlushEvents((EventMask)whichMask, (EventMask)stopMask); }
int32_t rt_ext_UiStillDown(void) { return (int32_t)StillDown(); }
void rt_ext_UiGetMouse(void *mouseLoc) { GetMouse((Point *)mouseLoc); }
void rt_ext_UiGlobalToLocal(void *pt) { GlobalToLocal((Point *)pt); }
void rt_ext_UiSysBeep(short duration) { SysBeep(duration); }

int32_t rt_ext_UiTickCount(void) { return (int32_t)TickCount(); }
short rt_ext_UiGestalt(int32_t selector, void *response) { return (short)Gestalt((OSType)selector, (long *)response); }
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
void rt_ext_UiTextBox(void *text, int32_t length, void *box, short just) { TextBox(text, (long)length, (const Rect *)box, just); }

void rt_ext_UiOpenPort(void *port) { OpenPort((GrafPtr)port); }
void rt_ext_UiClosePort(void *port) { ClosePort((GrafPtr)port); }
void rt_ext_UiPortSize(short width, short height) { PortSize(width, height); }
void rt_ext_UiSetOrigin(short h, short v) { SetOrigin(h, v); }
void rt_ext_UiSetPortBits(void *bm) { SetPortBits((const BitMap *)bm); }

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

/* rt_ui_test_script's weak default (Task 7 Step 4): moved here from
 * rt_ui.c, which is dropped from the CMake source list entirely under
 * CLARUS_UIPORT=1 (build-mac.sh) -- without this, a --uiport build with
 * no `--events` override (a real, non-scripted build) would leave the
 * symbol wholly undefined, a link error. Every scripted scenario's own
 * generated events.c still provides a STRONG override (unchanged
 * weak/strong precedent, same as rt_app_creator's own, rt_mac.c:380).
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

/* rt_ext_UiLaunchReal: rt_ui_launch's real-build branch (rt_ui.c:3963-4028)
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
extern void clar_fn_clar_ui_fire_launchdoc(void *path);
extern void clar_fn_clar_ui_fire_startempty(void);

#define RT_UI_SIZE_HLE_MASK 0x0040 /* isHighLevelEventAware -- see rt_ui.c's own derivation comment, :3780-3798 */

static void rt_ext_ui_pstrcpy(unsigned char *dst, const unsigned char *src) {
    unsigned char n, i;
    n = src ? src[0] : 0;
    for (i = 0; i < n; i++) dst[1 + i] = src[1 + i];
    dst[0] = n;
}

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

#endif /* CLARUS_RT_EXT_MAC_INC */
