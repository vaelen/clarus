/* runtime/mac/rt_ui.c -- Toolbox-native implementation of the Clarus UI
   runtime ABI (rt_ui.h). Windows are Window Manager WindowRecords; widgets
   (button/check) are Control Manager controls; label is drawn directly
   with TETextBox (Ch8's widget table has no Control Manager equivalent for
   plain static text). Every per-instance allocation (the instance struct
   itself, its widget-rect/control-pointer arrays, its label text buffers,
   its user-var state block) is a locked, never-relocated Handle -- same
   "locked master pointer" discipline rt_mac.c uses for rt_text/rt_list/
   rt_map, chosen here because none of these blocks grow after open() sizes
   them, so there is no need for the movable-Handle + re-derive dance those
   collections need.

   Scope (Task 1 of docs/superpowers/plans/2026-07-24-mac-target-4b.md):
   windows, widgets (button/check/label), the Ch8 layout engine, and the
   real-input WaitNextEvent loop.

   Task 2 (this revision) adds menus (Ch9), canvas (Ch11), and `every`
   timers:
     - Menus are built once at startup (NewMenu/AppendMenu/InsertMenu/
       DrawMenuBar); MenuSelect (mouseDown in the menu bar) and MenuKey
       (cmdKey keyDown) both funnel into one dispatch routine keyed off the
       native (menuID, item) pair. App-scope handlers (scope==NULL) always
       fire; window-scoped handlers fire with the type's front instance and
       are auto-dimmed via native (Dis|En)ableItem whenever the frontmost
       window of that type changes (open/close/click-to-front) -- the
       `T DIM` trace line itself is Task 3, but the dimming BEHAVIOR (the
       item actually becomes unselectable) is real now. The Apple menu
       (Ch9: "provided by the runtime automatically; no declaration is
       needed") is built here too: an About item that shows the
       application's name only (Ch9 pins exactly that much, nothing
       richer), a separator, then the standard System 6 desk-accessory
       list via AppendResMenu('DRVR')/OpenDeskAcc.
     - Canvas is a widget kind with no Control Manager backing (like
       label). When RTUI_BUFFERED, each instance owns an offscreen 1-bit
       GrafPort+BitMap (the pre-Color-QuickDraw "OffscreenBitmap" recipe --
       this codebase is already strictly B&W, see the 512x342 1-bit snap
       format pinned by the plan, so there's no reason to pull in Color
       QuickDraw/GWorld for this); drawing ops target the offscreen port,
       and the accumulated drawing is blitted to the screen via CopyBits
       once per rt_ui_run iteration (the point where "the current handler
       or timer returns control to the event loop", Ch11) rather than
       after each op, so a sequence of draws never flickers. Unbuffered
       canvas ops draw straight into the window's own port, offset into
       the widget's rect, visible immediately (Ch11). Click/drag hit
       testing is layered onto the existing FindControl-miss path with
       widget-local coordinates.
     - `every` blocks are scheduled on TickCount deltas, pumped once per
       rt_ui_run iteration; when any exist, WaitNextEvent's sleep argument
       drops to 1 tick so timers fire close to on schedule (unchanged at
       30 ticks when there are none, preserving Task 1's polling cadence).

   RT_MAC_TEST scripted events/trace/snaps are Task 3; nothing in this file
   branches on RT_MAC_TEST, so it compiles identically in both modes. */
#include "rt_ui.h"
#include "rt.h"
#include <Quickdraw.h>
#include <Fonts.h>
#include <Windows.h>
#include <Controls.h>
#include <ControlDefinitions.h>
#include <TextEdit.h>
#include <Events.h>
#include <Memory.h>
#include <ToolUtils.h>
#include <Menus.h>
#include <Dialogs.h>   /* NoteAlert, for the About item (Ch9) */
#include <Devices.h>   /* OpenDeskAcc, for the Apple menu's desk-accessory list */
#include <LowMem.h>    /* LMGetCurApName -- the running app's name, for About (Ch9) */
#ifdef RT_MAC_TEST
#include <stdio.h>     /* sprintf/sscanf -- trace-line formatting and script-line parsing (Task 3) */
#include <string.h>    /* strcmp -- script verb dispatch (Task 3) */
#include <stdlib.h>    /* atoi -- script argument parsing (Task 3) */
#endif

/* rt_mac.c's eager Toolbox init, exposed non-static for exactly this call
   (see runtime/mac/rt_mac.c). */
extern void rt_mac_init_toolbox(void);

#ifdef RT_MAC_TEST
/* rt_mac.c's shared capture-stream hook (Task 3): every trace line and
   framebuffer snap chunk below goes through this single entry point, so
   they interleave into the SAME `out` capture file as alert/log output and
   the 4a exit trailer -- there is no second output channel on the Mac
   side (see rt_mac.c's own header comment). */
extern void rt_test_emit(const char *line);

/* rt_ui_run's real WaitNextEvent loop wires `quit` (the menu item, the
   close-to-quit path, etc.) through rt_quit (internal/build/rt/rt.h) --
   the plain process-exit primitive every non-UI `quit` statement already
   compiles to. The scripted `quit` command and script exhaustion (Task 3)
   go through the exact same function: rt_ui.c has no richer "quit cascade"
   of its own yet (that is future clarusc-lowering work, per the design
   doc's aspirational note -- out of this task's scope), so "same path as
   the quit statement" means literally this call, not a hand-rolled
   window-closing loop. */
extern void rt_quit(int32_t code);
#endif

/* Marks our own windows in WindowPeek->windowKind so rt_ui_front/
   rt_ui_winst_of never mistake some other window (a DA, an alert dialog)
   for one of ours when walking the window list. Positive and >= 8, the
   range Inside Macintosh reserves for application use. */
#define RTUI_WINDOW_KIND 2001

/* Layout constants (Ch8 doesn't specify pixel values, only relative
   placement rules) -- ponytail: fixed per-kind control heights and one
   shared gap/margin constant, tuned to look like a normal System 6 dialog.
   Revisit if a future widget kind needs a different natural height. */
#define RTUI_GAP        8
#define RTUI_BUTTON_H  20
#define RTUI_CHECK_H   16
#define RTUI_LABEL_H   16
#define RTUI_CANVAS_H 100  /* natural height when not `fill: both` -- Ch8/11 pin no default; picked to be a usable default canvas size */

/* Native menu IDs: 1 is conventionally the Apple menu (not built here, see
   the file header comment), so declared menus start at 2, one ID per
   `menus[]` array index in order. */
#define RTUI_MENU_ID_BASE 2

/* ==================== per-instance state ==================== */

/* One offscreen 1-bit GrafPort+BitMap per buffered canvas widget. `port`
   doubles as the "is this canvas buffered and allocated" flag: NULL for
   every non-canvas widget and for unbuffered canvases. Allocated with
   NewPtrClear (not Handle-locked like the rest of rt_ui_winst) because
   OpenPort/SetPortBits/PortSize want a real, permanently-fixed GrafPort
   record to install as the current port -- same "never relocates" property
   a locked Handle gives, just via the more direct API these calls expect. */
typedef struct { GrafPtr port; BitMap bits; Ptr pixels; } rt_ui_canvas_buf;

typedef struct rt_ui_winst {
    Handle selfH;                    /* this struct's own locked box */
    WindowPtr wp;
    const rt_ui_window_desc *desc;
    Handle stateH; void *state;      /* per-instance user vars, or NULL if stateSize==0 */
    Handle ctrlsH; ControlHandle *ctrls;  /* nWidgets entries; NULL for non-Control kinds */
    Handle rectsH; Rect *rects;           /* nWidgets entries, window-local coords */
    Handle labelsH; unsigned char (*labels)[256]; /* nWidgets entries; only LABEL kinds used */
    Handle canvasH; rt_ui_canvas_buf *canvases;   /* nWidgets entries; only buffered CANVAS kinds used */
#ifdef RT_MAC_TEST
    short traceId;                    /* 1-based per-type instance counter for T OPEN/CLOSE/FRONT (Task 3) */
#endif
} rt_ui_winst;

/* Allocates a Handle that never moves (NewHandleClear + HLock, held locked
   for the instance's lifetime) and returns both the Handle (for later
   disposal) and its locked master pointer. Mirrors rt_mac.c's
   rt_mac_new_struct, but exposes the Handle too since, unlike rt_text/
   rt_list/rt_map, these blocks ARE disposed (at rt_ui_close). */
static void *rt_ui_alloc_locked(Size sz, Handle *outH)
{
    Handle h;
    h = NewHandleClear(sz);
    if (!h) rt_panic("out of memory");
    HLock(h);
    *outH = h;
    return *h;
}

#ifdef RT_MAC_TEST
/* ==================== RT_MAC_TEST trace lines (Task 3) ====================
 * One line per contract-listed action (docs/superpowers/plans/
 * 2026-07-24-mac-target-4b.md, "Contracts pinned by this plan"), appended
 * to the 4a capture stream via rt_test_emit (rt_mac.c) -- golden-file
 * vocabulary, byte-exact, do not reword without updating the plan and
 * every scenario `.trace` golden that depends on it (Task 6). Every
 * helper here is called from exactly the runtime action it names; none of
 * this compiles into a normal build (the whole block, and every call site
 * below guarded the same way, is `#ifdef RT_MAC_TEST`). */

static void rt_ui_trace_id(const char *verb, const char *name, short id)
{
    char buf[300];
    sprintf(buf, "T %s %s %d", verb, name, (int)id);
    rt_test_emit(buf);
}

static void rt_ui_trace_fire1(const char *name, const char *event)
{
    char buf[300];
    sprintf(buf, "T FIRE %s.%s", name, event);
    rt_test_emit(buf);
}

static void rt_ui_trace_fire2(const char *name, const char *wname, const char *event)
{
    char buf[300];
    sprintf(buf, "T FIRE %s.%s.%s", name, wname, event);
    rt_test_emit(buf);
}

static void rt_ui_trace_menu_select(const char *menu, const char *item)
{
    char buf[300];
    sprintf(buf, "T FIRE %s.%s.select", menu, item);
    rt_test_emit(buf);
}

static void rt_ui_trace_every(short n)
{
    char buf[64];
    sprintf(buf, "T FIRE every.%d", (int)n);
    rt_test_emit(buf);
}

static void rt_ui_trace_dim(const char *menu, const char *item, int on)
{
    char buf[300];
    sprintf(buf, "T DIM %s.%s %d", menu, item, on ? 1 : 0);
    rt_test_emit(buf);
}

/* Runtime-property names exactly as Ch8's widget table spells them
   (`caption`/`text`/`enabled`/`checked`/`selected`/`width`/`height`) --
   the SET trace line names the property the way `.cla` source names it,
   not the RTUI_PROP_* C constant. */
static const char *rt_ui_prop_name(short prop)
{
    switch (prop) {
    case RTUI_PROP_CAPTION:  return "caption";
    case RTUI_PROP_TEXT:     return "text";
    case RTUI_PROP_ENABLED:  return "enabled";
    case RTUI_PROP_CHECKED:  return "checked";
    case RTUI_PROP_SELECTED: return "selected";
    case RTUI_PROP_WIDTH:    return "width";
    case RTUI_PROP_HEIGHT:   return "height";
    default:                 return "?";
    }
}

/* `T SET <WinType>.<Widget>.<prop> <value>` -- value is the Pascal-string
   bytes as-is for a string write (widget captions/labels/text in this
   codebase are plain ASCII, no embedded NUL/newline to worry about). */
static void rt_ui_trace_set_str(const char *name, const char *wname, short prop, const unsigned char *s)
{
    char buf[512];
    int n, i, len;
    n = sprintf(buf, "T SET %s.%s.%s ", name, wname, rt_ui_prop_name(prop));
    len = s ? s[0] : 0;
    for (i = 0; i < len && n < (int)sizeof(buf) - 1; i++) buf[n++] = (char)s[1 + i];
    buf[n] = '\0';
    rt_test_emit(buf);
}

static void rt_ui_trace_set_bool(const char *name, const char *wname, short prop, int v)
{
    char buf[300];
    sprintf(buf, "T SET %s.%s.%s %d", name, wname, rt_ui_prop_name(prop), v ? 1 : 0);
    rt_test_emit(buf);
}

/* Per-WinType 1-based instance counter for T OPEN/CLOSE/FRONT ids (Task 3).
   Sized off rt_ui_startup's own `wins` array -- linear scan is plenty for
   the handful of window types any real program declares. */
static const rt_ui_window_desc **gTraceWinTypes = NULL;
static short *gTraceWinCounts = NULL;
static short gTraceNWinTypes = 0;

static short rt_ui_trace_next_id(const rt_ui_window_desc *d)
{
    short i;
    for (i = 0; i < gTraceNWinTypes; i++) {
        if (gTraceWinTypes[i] == d) {
            gTraceWinCounts[i]++;
            return gTraceWinCounts[i];
        }
    }
    return 0; /* defensive: a window type rt_ui_startup was never told about */
}

/* T FRONT: fires only when the frontmost-of-ours WINDOW actually changes,
   at the 4 real call sites where it can (open, close, click-to-front,
   drag-to-front) -- see rt_ui_after_front_change below, which wraps every
   such call site's existing rt_ui_menu_recompute_dim() call. */
static rt_ui_winst *gTraceLastFront = NULL;

static void rt_ui_trace_front_check(void)
{
    WindowPeek w;
    rt_ui_winst *cur;

    w = (WindowPeek)FrontWindow();
    cur = (w && w->windowKind == RTUI_WINDOW_KIND) ? (rt_ui_winst *)GetWRefCon((WindowPtr)w) : NULL;
    if (cur == gTraceLastFront) return;
    gTraceLastFront = cur;
    if (cur) rt_ui_trace_id("FRONT", cur->desc->name, cur->traceId);
}

/* T DIM: only the AUTOMATIC window-scoped dimming recompute is traced (per
   the contract: "dimming recompute changed an item") -- a program calling
   rt_ui_menu_enable directly (`MenuName.Item.enabled = b`, Ch9) has no
   trace line of its own in the pinned vocabulary. gDimPrev holds the last
   COMPUTED state per scoped handler entry (gMenuHandlerTable index,
   allocated to gNMenuHandlers in rt_ui_startup); gDimFirst suppresses the
   very first computation (rt_ui_startup's own initial call, before any
   window has opened) so the trace stream doesn't open with a burst of
   "just discovered nothing is open yet" lines that no script action
   caused. */
static char *gDimPrev = NULL;
static int gDimFirst = 1;

/* Set for the duration of rt_ui_run_scripted (see below): governs the one
   sanctioned real/scripted divergence in rt_ui_handle_content_click. */
static int gUiScripted = 0;
#endif /* RT_MAC_TEST */

static int rt_ui_is_ours(WindowPtr wp)
{
    return wp != NULL && ((WindowPeek)wp)->windowKind == RTUI_WINDOW_KIND;
}

static rt_ui_winst *rt_ui_winst_of(WindowPtr wp)
{
    if (!rt_ui_is_ours(wp)) return NULL;
    return (rt_ui_winst *)GetWRefCon(wp);
}

/* ==================== layout engine (Ch8) ====================
 * Walks the widget list in declaration order, computing each widget's
 * window-local Rect from its atKind/x/y/width/fill against the window's
 * CURRENT content size (the live portRect, so this also serves as the
 * resize re-layout: same algorithm, just re-run against the new size) and
 * against the immediately preceding widget's computed box (Ch8: "at:
 * right, y" / "at: next, bottom" are both relative to "the previous
 * widget", i.e. the one before them in declaration order -- not the
 * nearest widget in space). For the first widget, "previous" is treated
 * as an empty box at the origin -- undefined by the language reference,
 * but a graceful default for a widget declared with no predecessor. */
static short rt_ui_kind_height(short kind)
{
    switch (kind) {
    case RTUI_BUTTON: return RTUI_BUTTON_H;
    case RTUI_CHECK:  return RTUI_CHECK_H;
    case RTUI_LABEL:  return RTUI_LABEL_H;
    case RTUI_CANVAS: return RTUI_CANVAS_H;
    default:          return RTUI_CHECK_H;
    }
}

/* portRect helpers: a WindowPtr is a GrafPtr, and window content-local
   coordinates always start at (0,0) in classic Mac OS, so the port's own
   rect IS the content size -- this also means it reflects post-resize
   sizes for free once SizeWindow has run. */
static short wp_content_width(WindowPtr wp)
{
    return (short)(((GrafPtr)wp)->portRect.right - ((GrafPtr)wp)->portRect.left);
}

static short wp_content_height(WindowPtr wp)
{
    return (short)(((GrafPtr)wp)->portRect.bottom - ((GrafPtr)wp)->portRect.top);
}

static void rt_ui_layout(rt_ui_winst *inst)
{
    const rt_ui_window_desc *d;
    short contentW, contentH;
    short prevLeft, prevRight, prevBottom;
    short i;

    d = inst->desc;
    contentW = wp_content_width(inst->wp);
    contentH = wp_content_height(inst->wp);
    prevLeft = 0;
    prevRight = 0;
    prevBottom = 0;

    for (i = 0; i < d->nWidgets; i++) {
        const rt_ui_widget_desc *wd;
        short x, y, w, h;

        wd = &d->widgets[i];
        h = rt_ui_kind_height(wd->kind);
        switch (wd->atKind) {
        case RTUI_AT_RIGHT:
            x = prevRight + RTUI_GAP;
            break;
        case RTUI_AT_NEXT:
            x = prevLeft;
            break;
        case RTUI_AT_XY:
        default:
            x = wd->x;
            break;
        }
        /* RTUI_BOTTOM is a valid y sentinel regardless of atKind (Ch8's
           "bottom" keyword is a propValue in its own right, e.g.
           `at: 10, bottom` is at-xy with an explicit x) -- resolve it here,
           once, rather than only inside the RTUI_AT_NEXT case. */
        y = (wd->y == RTUI_BOTTOM) ? (short)(prevBottom + RTUI_GAP) : wd->y;
        w = (wd->width == RTUI_FILL) ? (short)(contentW - x - RTUI_GAP) : wd->width;
        if (w < 0) w = 0;
        if (wd->fill == RTUI_FILL_BOTH) {
            h = (short)(contentH - y - RTUI_GAP);
            if (h < 0) h = 0;
        }

        SetRect(&inst->rects[i], x, y, (short)(x + w), (short)(y + h));
        if (inst->ctrls[i]) {
            MoveControl(inst->ctrls[i], x, y);
            SizeControl(inst->ctrls[i], w, h);
        }

        prevLeft = x;
        prevRight = (short)(x + w);
        prevBottom = (short)(y + h);
    }
}

/* ==================== widget creation ==================== */

static void rt_ui_pstrcpy(unsigned char *dst, const unsigned char *src)
{
    unsigned char n, i;
    n = src ? src[0] : 0;
    for (i = 0; i < n; i++) dst[1 + i] = src[1 + i];
    dst[0] = n;
}

static const unsigned char kEmptyPStr[1] = { 0 };

static void rt_ui_make_widgets(rt_ui_winst *inst)
{
    const rt_ui_window_desc *d;
    Rect placeholder;
    short i;

    d = inst->desc;
    SetRect(&placeholder, 0, 0, 0, 0);
    for (i = 0; i < d->nWidgets; i++) {
        const rt_ui_widget_desc *wd;
        const unsigned char *cap;
        wd = &d->widgets[i];
        cap = wd->caption ? wd->caption : kEmptyPStr;
        switch (wd->kind) {
        case RTUI_BUTTON:
            inst->ctrls[i] = NewControl(inst->wp, &placeholder, cap,
                                         (Boolean)1, 0, 0, 1, pushButProc, 0L);
            break;
        case RTUI_CHECK:
            inst->ctrls[i] = NewControl(inst->wp, &placeholder, cap,
                                         (Boolean)1, 0, 0, 1, checkBoxProc, 0L);
            break;
        default: /* RTUI_LABEL, RTUI_CANVAS: no Control Manager backing */
            inst->ctrls[i] = NULL;
            rt_ui_pstrcpy(inst->labels[i], cap);
            break;
        }
        if (inst->ctrls[i]) (*inst->ctrls[i])->contrlRfCon = i;
    }
}

/* ==================== canvas offscreen buffers (Ch11 buffered) ====================
 * Classic pre-Color-QuickDraw offscreen bitmap recipe: a real GrafPort
 * record (OpenPort'd so it's fully initialized) whose portBits is pointed
 * at a manually allocated 1-bit-per-pixel buffer, sized and cleared to
 * white. Every drawing op targets this port directly; the screen only
 * sees it via the CopyBits in rt_ui_flush_all_buffered. */
static void rt_ui_canvas_dispose(rt_ui_canvas_buf *cb)
{
    if (!cb->port) return;
    ClosePort(cb->port); /* releases the port's own visRgn/clipRgn Handles before the port record itself is freed */
    DisposePtr((Ptr)cb->port);
    DisposePtr(cb->pixels);
    cb->port = NULL;
    cb->pixels = NULL;
}

static void rt_ui_canvas_make(rt_ui_canvas_buf *cb, short w, short h)
{
    long rowBytes;
    Rect r;

    if (w < 1) w = 1;
    if (h < 1) h = 1;
    cb->port = (GrafPtr)NewPtrClear(sizeof(GrafPort));
    if (!cb->port) rt_panic("out of memory");
    rowBytes = (((long)w + 15) / 16) * 2; /* word-aligned rowBytes, classic QD convention */
    cb->pixels = NewPtrClear(rowBytes * (long)h);
    if (!cb->pixels) rt_panic("out of memory");
    OpenPort(cb->port); /* also SetPort(cb->port): SetPortBits/PortSize/SetOrigin below act on it */
    SetRect(&r, 0, 0, w, h);
    cb->bits.baseAddr = cb->pixels;
    cb->bits.rowBytes = (short)rowBytes;
    cb->bits.bounds = r;
    SetPortBits(&cb->bits);
    PortSize(w, h);
    SetOrigin(0, 0);
}

/* (Re)allocates the offscreen buffer for every buffered canvas widget at
   its CURRENT laid-out size -- called once at open, and again after any
   resize's re-layout, since a `fill: both` canvas's size tracks the
   window. Old content does not survive a resize (a fresh, cleared buffer
   is made); Ch11 promises no more than that. */
static void rt_ui_canvas_realloc_all(rt_ui_winst *inst)
{
    short i;
    for (i = 0; i < inst->desc->nWidgets; i++) {
        const rt_ui_widget_desc *wd = &inst->desc->widgets[i];
        if (wd->kind != RTUI_CANVAS || !(wd->flags & RTUI_BUFFERED)) continue;
        rt_ui_canvas_dispose(&inst->canvases[i]);
        rt_ui_canvas_make(&inst->canvases[i],
                           (short)(inst->rects[i].right - inst->rects[i].left),
                           (short)(inst->rects[i].bottom - inst->rects[i].top));
    }
}

/* Blits every buffered canvas's offscreen content to its window, once per
   rt_ui_run iteration (see the file header comment) -- this IS the "single
   copy when the current handler or timer returns to the event loop" Ch11
   describes, and it also covers redrawing a buffered canvas after an
   updateEvt (the offscreen bits persist; nothing needs to re-draw them). */
static void rt_ui_flush_buffered_canvases(rt_ui_winst *inst)
{
    short i;
    if (!inst) return;
    for (i = 0; i < inst->desc->nWidgets; i++) {
        rt_ui_canvas_buf *cb = &inst->canvases[i];
        if (!cb->port) continue;
        SetPort(inst->wp);
        CopyBits(&cb->bits, &((GrafPtr)inst->wp)->portBits, &cb->bits.bounds, &inst->rects[i], srcCopy, NULL);
    }
}

static void rt_ui_flush_all_buffered(void)
{
    WindowPeek w;
    for (w = (WindowPeek)FrontWindow(); w != NULL; w = w->nextWindow) {
        if (w->windowKind == RTUI_WINDOW_KIND)
            rt_ui_flush_buffered_canvases((rt_ui_winst *)GetWRefCon((WindowPtr)w));
    }
}

/* ==================== menus (Ch9) ====================
 * Built once at startup from the descriptor tables and never rebuilt.
 * Native menu IDs are RTUI_MENU_ID_BASE + array index, so mapping a
 * MenuSelect/MenuKey result back to a `menus[]`/`items[]` pair is pure
 * arithmetic; `rt_ui_menu_handler.menuIndex/itemIndex` (both 0-based, same
 * convention as widgetIndex and the every-block trace index) are looked up
 * against that pair directly -- the name fields in rt_ui_menu_handler are
 * for trace output (Task 3), not needed for dispatch. RTUI_MENU_ID_BASE
 * leaves ID 1 free for the Apple menu, built separately below (it has no
 * descriptor and no app-authored handler, so it isn't part of this table). */

static MenuHandle *gMenuHandles = NULL;  /* gNMenus entries */
static short gNMenus = 0;
static const rt_ui_menu_handler *gMenuHandlerTable = NULL;
static short gNMenuHandlers = 0;
static MenuHandle gAppleMenu = NULL;

#define RTUI_APPLE_MENU_ID 1

/* Ch9: "The Apple menu and its About item are provided by the runtime
   automatically; no declaration is needed." Standard System 6 shape: an
   About item (Ch9 pins its content to "the application's name only" --
   shown via the same ALRT 128 / DITL "^0" resource rt_mac.c's own
   rt_alert uses, substituting the app's name instead of an error message),
   a separator, then the desk-accessory list. Inserted before the declared
   menus so it lands leftmost in the bar. */
static void rt_ui_build_apple_menu(void)
{
    gAppleMenu = NewMenu(RTUI_APPLE_MENU_ID, (const unsigned char *)"\p\024");
    AppendMenu(gAppleMenu, (const unsigned char *)"\pAbout This Application;-");
    AppendResMenu(gAppleMenu, 'DRVR');
    InsertMenu(gAppleMenu, 0);
}

static void rt_ui_apple_select(short itemNum)
{
    if (itemNum == 1) {
        ParamText(LMGetCurApName(), (const unsigned char *)"\p",
                  (const unsigned char *)"\p", (const unsigned char *)"\p");
        NoteAlert(128, NULL);
    } else {
        Str255 name;
        GetMenuItemText(gAppleMenu, itemNum, name);
        OpenDeskAcc(name); /* item 2 is the separator; the Menu Manager never returns it as a selection */
    }
}

static void rt_ui_build_menus(const rt_ui_menu_desc **menus, short nMenus)
{
    short i, j;

    gNMenus = nMenus;
    gMenuHandles = nMenus > 0 ? (MenuHandle *)NewPtrClear((Size)nMenus * sizeof(MenuHandle)) : NULL;
    for (i = 0; i < nMenus; i++) {
        const rt_ui_menu_desc *md;
        MenuHandle mh;

        md = menus[i];
        mh = NewMenu((short)(RTUI_MENU_ID_BASE + i), md->title);
        for (j = 0; j < md->nItems; j++) {
            const rt_ui_item_desc *it = &md->items[j];
            if (it->separator) {
                AppendMenu(mh, (const unsigned char *)"\p-");
                continue;
            }
            /* AppendMenu's `/K` metacharacter wires the cmd-key
               equivalent straight from the item text (no separate
               SetItemCmd call needed). Not escaped against a caption that
               itself contains '/', '!', '<', or '(': none of this task's
               captions do, and the reference doesn't ask for that
               generality yet. */
            {
                unsigned char buf[258]; /* 255-byte Str255 + "/K" + count byte */
                unsigned char n;
                rt_ui_pstrcpy(buf, it->label);
                n = buf[0];
                if (it->key) {
                    buf[1 + n] = '/';
                    buf[2 + n] = it->key;
                    buf[0] = (unsigned char)(n + 2);
                }
                AppendMenu(mh, buf);
            }
        }
        InsertMenu(mh, 0);
        gMenuHandles[i] = mh;
    }
    DrawMenuBar();
}

void rt_ui_menu_enable(short menuIdx, short itemIdx, int on)
{
    MenuHandle mh;

    if (!gMenuHandles || menuIdx < 0 || menuIdx >= gNMenus) return;
    mh = gMenuHandles[menuIdx];
    if (!mh) return;
    if (on) EnableItem(mh, (short)(itemIdx + 1));
    else DisableItem(mh, (short)(itemIdx + 1));
}

/* Recomputes native enable state for every window-scoped menu handler,
   keyed off whether its scope type currently has a front instance
   (rt_ui_front, unchanged from Task 1) -- call after anything that can
   change which window is frontmost: open, close, click-to-front. App-scope
   handlers (scope == NULL) are untouched: they stay enabled unless the
   program calls rt_ui_menu_enable itself. */
static void rt_ui_menu_recompute_dim(void)
{
    short k;
    for (k = 0; k < gNMenuHandlers; k++) {
        const rt_ui_menu_handler *h = &gMenuHandlerTable[k];
        int on;
        if (!h->scope) continue;
        on = rt_ui_front(h->scope) != NULL;
        rt_ui_menu_enable(h->menuIndex, h->itemIndex, on);
#ifdef RT_MAC_TEST
        if (!gDimFirst && gDimPrev && gDimPrev[k] != (char)on) rt_ui_trace_dim(h->menu, h->item, on);
        if (gDimPrev) gDimPrev[k] = (char)on;
#endif
    }
#ifdef RT_MAC_TEST
    gDimFirst = 0;
#endif
}

/* Wraps rt_ui_menu_recompute_dim at every call site where frontmost CAN
   change (open, close, click-to-front, drag-to-front) with the T FRONT
   trace check (Task 3) -- rt_ui_startup's own initial call (before any
   window exists) is left as a bare rt_ui_menu_recompute_dim() call, not
   this wrapper, since there is no frontmost change to report yet. */
static void rt_ui_after_front_change(void)
{
    rt_ui_menu_recompute_dim();
#ifdef RT_MAC_TEST
    rt_ui_trace_front_check();
#endif
}

/* Shared by MenuSelect (mouseDown in the menu bar) and MenuKey (cmdKey
   keyDown) -- both return the same packed (menuID, item) long. */
static void rt_ui_menu_dispatch(long result)
{
    short menuID, itemNum, menuIdx, itemIdx, k;

    menuID = HiWord(result);
    itemNum = LoWord(result);
    HiliteMenu(0);
    if (menuID == 0) return;
    if (menuID == RTUI_APPLE_MENU_ID) {
        rt_ui_apple_select(itemNum);
        return;
    }
    menuIdx = (short)(menuID - RTUI_MENU_ID_BASE);
    itemIdx = (short)(itemNum - 1);
    for (k = 0; k < gNMenuHandlers; k++) {
        const rt_ui_menu_handler *h = &gMenuHandlerTable[k];
        void *front;
        if (h->menuIndex != menuIdx || h->itemIndex != itemIdx) continue;
        if (h->scope) {
            front = rt_ui_front(h->scope);
            if (!front) continue; /* dimmed; the Menu Manager already blocks this selection natively -- defensive no-op */
        } else {
            front = NULL;
        }
#ifdef RT_MAC_TEST
        rt_ui_trace_menu_select(h->menu, h->item);
#endif
        if (h->fire) h->fire(front);
    }
}

/* ==================== widget click/change dispatch ====================
 * Shared by real mouse clicks (after TrackControl confirms the release
 * landed back inside the control) and by the Return/Escape default/cancel
 * key wiring (Ch8: "default and cancel on a button wire the Return and
 * Escape keys respectively") -- both are "this widget just got activated",
 * modeled identically. */
static void rt_ui_fire_widget(rt_ui_winst *inst, short wIdx)
{
    const rt_ui_widget_desc *wd;
    ControlHandle ctrl;
    GrafPtr savedPort;

    /* Self-asserts and restores its own port (see the rt_ui.h header
       comment on this rule) -- Return/Escape-key dispatch reaches here
       without the caller having set a port first, unlike content-click. */
    GetPort(&savedPort);
    SetPort(inst->wp);
    wd = &inst->desc->widgets[wIdx];
    ctrl = inst->ctrls[wIdx];
    switch (wd->kind) {
    case RTUI_CHECK: {
        short newVal;
        newVal = (short)(GetControlValue(ctrl) ? 0 : 1);
        SetControlValue(ctrl, newVal);
#ifdef RT_MAC_TEST
        rt_ui_trace_fire2(inst->desc->name, wd->name, "change");
#endif
        if (inst->desc->handlers && inst->desc->handlers->widget)
            inst->desc->handlers->widget(inst, wIdx, RTUI_WEV_CHANGE, (long)newVal, 0);
        break;
    }
    case RTUI_BUTTON:
#ifdef RT_MAC_TEST
        rt_ui_trace_fire2(inst->desc->name, wd->name, "click");
#endif
        if (inst->desc->handlers && inst->desc->handlers->widget)
            inst->desc->handlers->widget(inst, wIdx, RTUI_WEV_CLICK, 0, 0);
        break;
    default:
        break;
    }
    SetPort(savedPort);
}

/* ==================== update / activate ==================== */

static void rt_ui_draw_default_outline(const Rect *box)
{
    Rect r;
    r = *box;
    InsetRect(&r, -4, -4);
    PenSize(3, 3);
    FrameRoundRect(&r, 16, 16);
    PenNormal();
}

static void rt_ui_handle_update(WindowPtr wp)
{
    rt_ui_winst *inst;
    short i;

    SetPort(wp);
    BeginUpdate(wp);
    inst = rt_ui_winst_of(wp);
    if (inst) {
        DrawControls(wp);
        for (i = 0; i < inst->desc->nWidgets; i++) {
            const rt_ui_widget_desc *wd;
            wd = &inst->desc->widgets[i];
            if (wd->kind == RTUI_LABEL) {
                unsigned char *s;
                s = inst->labels[i];
                TETextBox(s + 1, s[0], &inst->rects[i], teJustLeft);
            } else if (wd->kind == RTUI_BUTTON && (wd->flags & RTUI_DEFAULT)) {
                rt_ui_draw_default_outline(&inst->rects[i]);
            }
        }
        rt_ui_flush_buffered_canvases(inst); /* re-blit persisted offscreen content; unbuffered has none to restore (Ch11) */
    }
    EndUpdate(wp);
}

/* Ch8 exposes no user-visible "activate" event -- only the Toolbox-visual
   effect (dimming every control on deactivate, undimming on activate)
   needs handling here. ponytail: this blanket dim/undim doesn't remember
   which controls the app itself had already disabled via
   rt_ui_widget_set_bool(..., RTUI_PROP_ENABLED, 0) before a deactivate --
   add per-widget "logically enabled" tracking if/when Task 2's multi-
   window probe shows that mattering in practice. */
static void rt_ui_handle_activate(WindowPtr wp, int activating)
{
    rt_ui_winst *inst;
    short i;

    inst = rt_ui_winst_of(wp);
    if (!inst) return;
    SetPort(wp);
    for (i = 0; i < inst->desc->nWidgets; i++) {
        if (inst->ctrls[i]) HiliteControl(inst->ctrls[i], (short)(activating ? 0 : 255));
    }
}

/* ==================== mouse ==================== */

/* Shared by real GrowWindow tracking below and the scripted `resize W H`
   command (Task 3, rt_ui_script_resize): everything AFTER "we now know the
   new size" -- resizing the WindowRecord itself, re-laying-out widgets,
   reallocating buffered-canvas offscreen buffers, and firing the
   `resized` handler -- is identical whether that size came from a real
   interactive GrowWindow drag or a script line. */
static void rt_ui_apply_resize(WindowPtr wp, rt_ui_winst *inst, short newW, short newH)
{
    SizeWindow(wp, newW, newH, (Boolean)1);
    rt_ui_layout(inst);
    rt_ui_canvas_realloc_all(inst); /* buffered canvas sizes may have tracked the resize (fill: both) */
#ifdef RT_MAC_TEST
    rt_ui_trace_fire1(inst->desc->name, "resized");
#endif
    if (inst->desc->handlers && inst->desc->handlers->winEvent)
        inst->desc->handlers->winEvent(inst, RTUI_EV_RESIZED, 0, 0);
}

static void rt_ui_handle_grow(WindowPtr wp, rt_ui_winst *inst, Point where)
{
    Rect limits;
    long newSize;

    if (!inst->desc->resizable) return;
    SetRect(&limits,
            (short)(inst->desc->minW > 0 ? inst->desc->minW : 1),
            (short)(inst->desc->minH > 0 ? inst->desc->minH : 1),
            32767, 32767);
    newSize = GrowWindow(wp, where, &limits);
    if (newSize == 0) return;
    rt_ui_apply_resize(wp, inst, LoWord(newSize), HiWord(newSize));
}

/* `where` arrives as ev->where, which EventRecord always carries in GLOBAL
   coordinates; FindControl/TrackControl both require LOCAL (window-
   relative) coordinates, so it must be converted (via the window's own
   port) before either call -- easy to miss since FindWindow, TrackGoAway,
   DragWindow, and GrowWindow all take the SAME EventRecord field
   unconverted (they operate on window furniture in global screen space). */
/* Canvas widgets have no Control Manager backing (like label), so a click
   that FindControl doesn't claim is checked against canvas widget rects
   next -- coordinates delivered to the handler are widget-local (Ch8:
   canvas's `click`/`drag` events carry (x, y) relative to the canvas's own
   origin), matching RTUI_WEV_DRAG's header comment. */
static int rt_ui_canvas_hit(rt_ui_winst *inst, Point local, short *outIdx)
{
    short i;
    for (i = 0; i < inst->desc->nWidgets; i++) {
        if (inst->desc->widgets[i].kind == RTUI_CANVAS && PtInRect(local, &inst->rects[i])) {
            *outIdx = i;
            return 1;
        }
    }
    return 0;
}

static void rt_ui_fire_canvas_xy(rt_ui_winst *inst, short wIdx, short event, Point local)
{
    const Rect *r;
    r = &inst->rects[wIdx];
#ifdef RT_MAC_TEST
    rt_ui_trace_fire2(inst->desc->name, inst->desc->widgets[wIdx].name, event == RTUI_WEV_CLICK ? "click" : "drag");
#endif
    if (inst->desc->handlers && inst->desc->handlers->widget)
        inst->desc->handlers->widget(inst, wIdx, event, (long)(local.h - r->left), (long)(local.v - r->top));
}

static void rt_ui_handle_canvas_click(WindowPtr wp, rt_ui_winst *inst, short wIdx, Point where)
{
    Point last;

    rt_ui_fire_canvas_xy(inst, wIdx, RTUI_WEV_CLICK, where);
    last = where;
    while (StillDown()) {
        Point cur;
        /* GetMouse reports in the CURRENT port's local coords -- the click
           handler just fired may have left a canvas's offscreen port
           current (drawing calls SetPort it), so re-assert the window's
           own port before every read. */
        SetPort(wp);
        GetMouse(&cur);
        if (cur.h != last.h || cur.v != last.v) {
            rt_ui_fire_canvas_xy(inst, wIdx, RTUI_WEV_DRAG, cur);
            last = cur;
        }
    }
}

static void rt_ui_handle_content_click(WindowPtr wp, rt_ui_winst *inst, Point where)
{
    ControlHandle ctrl;
    short cpart;

    SetPort(wp);
    GlobalToLocal(&where);
    cpart = FindControl(where, wp, &ctrl);
    if (cpart != 0 && ctrl != NULL) {
        short wIdx;
        wIdx = (short)(*ctrl)->contrlRfCon;
#ifdef RT_MAC_TEST
        /* The ONE sanctioned real/scripted divergence (Task 3, see the
           plan's self-review notes): TrackControl's modal tracking loop
           blocks waiting for a REAL mouse-up, which a scripted `click`
           command never produces (there is no live mouse in RT_MAC_TEST
           scripted mode -- gUiScripted is set only for the duration of
           rt_ui_run_scripted). A synthetic click that FindControl
           resolves to one of our own controls is dispatched directly --
           exactly as if TrackControl had returned "released inside the
           control" -- instead of calling TrackControl at all. Traced
           identically to a real click either way: rt_ui_fire_widget is
           the one shared "this widget just activated" entry point real
           clicks and Return/Escape-key wiring already used before this
           task; nothing downstream can tell the difference. */
        if (gUiScripted) { rt_ui_fire_widget(inst, wIdx); return; }
#endif
        {
            short trackPart = TrackControl(ctrl, where, NULL);
            if (trackPart != 0) rt_ui_fire_widget(inst, wIdx);
        }
        return;
    }
    {
        short cIdx;
        if (rt_ui_canvas_hit(inst, where, &cIdx))
            rt_ui_handle_canvas_click(wp, inst, cIdx, where);
    }
}

static void rt_ui_handle_mouse_down(const EventRecord *ev)
{
    WindowPtr wp;
    short part;
    rt_ui_winst *inst;

    part = FindWindow(ev->where, &wp);
    switch (part) {
    case inGoAway:
        if (wp != NULL && TrackGoAway(wp, ev->where)) {
            inst = rt_ui_winst_of(wp);
            if (inst) rt_ui_close(inst);
        }
        break;
    case inDrag: {
        Rect dragBounds;
        dragBounds = qd.screenBits.bounds;
        InsetRect(&dragBounds, 4, 4);
        DragWindow(wp, ev->where, &dragBounds); /* also brings wp to front if it wasn't -- click-to-front */
        rt_ui_after_front_change();
        break;
    }
    case inGrow:
        inst = rt_ui_winst_of(wp);
        if (inst) rt_ui_handle_grow(wp, inst, ev->where);
        break;
    case inContent:
        if (wp != FrontWindow()) {
            SelectWindow(wp);
            rt_ui_after_front_change(); /* click-to-front changed frontmost */
            break;
        }
        inst = rt_ui_winst_of(wp);
        if (inst) rt_ui_handle_content_click(wp, inst, ev->where);
        break;
    case inMenuBar:
        rt_ui_menu_dispatch(MenuSelect(ev->where));
        break;
    default:
        break; /* inDesk, inSysWindow: nothing to do */
    }
}

/* ==================== keyboard ==================== */

static int rt_ui_find_flagged(rt_ui_winst *inst, short flag, short *outIdx)
{
    short i;
    for (i = 0; i < inst->desc->nWidgets; i++) {
        const rt_ui_widget_desc *wd = &inst->desc->widgets[i];
        if (wd->kind == RTUI_BUTTON && (wd->flags & flag)) {
            *outIdx = i;
            return 1;
        }
    }
    return 0;
}

static void rt_ui_handle_key(const EventRecord *ev)
{
    WindowPtr wp;
    rt_ui_winst *inst;
    unsigned char ch;
    short wIdx;

    ch = (unsigned char)(ev->message & charCodeMask);
    if (ev->modifiers & cmdKey) {
        rt_ui_menu_dispatch(MenuKey(ch));
        return;
    }
    wp = FrontWindow();
    inst = rt_ui_winst_of(wp);
    if (!inst) return;
    if ((ch == 13 || ch == 3) && rt_ui_find_flagged(inst, RTUI_DEFAULT, &wIdx)) {
        rt_ui_fire_widget(inst, wIdx);
        return;
    }
    if (ch == 27 && rt_ui_find_flagged(inst, RTUI_CANCEL, &wIdx)) {
        rt_ui_fire_widget(inst, wIdx);
        return;
    }
#ifdef RT_MAC_TEST
    rt_ui_trace_fire1(inst->desc->name, "key");
#endif
    if (inst->desc->handlers && inst->desc->handlers->winEvent)
        inst->desc->handlers->winEvent(inst, RTUI_EV_KEY, (long)ch, 0);
}

/* ==================== public API ==================== */

/* every-table: scheduled on TickCount deltas, pumped once per rt_ui_run
   iteration (see file header comment). gEveryDue holds, per entry, the
   next absolute TickCount at which it's due; on firing it's rescheduled
   from `now` (not accumulated from the missed deadline) so a stall (e.g. a
   long TrackControl drag) doesn't make a timer burst-fire to catch up --
   Ch11 only promises "never re-entered while a previous run is still
   executing", not catch-up semantics, and drift-over-burst is the less
   surprising choice for animation. */
static const rt_ui_every_desc *gEveryTable = NULL;
static short gNEvery = 0;
static unsigned long *gEveryDue = NULL;

static void rt_ui_build_every(const rt_ui_every_desc *ev, short nEv)
{
    unsigned long now;
    short i;

    gEveryTable = ev;
    gNEvery = nEv;
    gEveryDue = nEv > 0 ? (unsigned long *)NewPtrClear((Size)nEv * sizeof(unsigned long)) : NULL;
#ifdef RT_MAC_TEST
    /* Scripted mode's virtual tick counter (gVirtualTicks, below) always
       starts at 0 -- if the "due" baseline here came from the REAL
       TickCount() instead (as the non-scripted branch below still needs),
       every-block firing would depend on how many real ticks the Toolbox
       boot sequence happened to burn before main() reached rt_ui_startup,
       exactly the non-determinism the contract rules out ("TickCount is
       not consulted... making runs deterministic"). Checking
       rt_ui_test_script here (rather than referencing gVirtualTicks
       directly, which is not yet declared at this point in the file) is
       equivalent: gVirtualTicks is always still 0 when rt_ui_startup runs. */
    now = (rt_ui_test_script[0] != '\0') ? 0UL : TickCount();
#else
    now = TickCount();
#endif
    for (i = 0; i < nEv; i++) gEveryDue[i] = now + (unsigned long)ev[i].ticks;
}

static void rt_ui_every_pump(void)
{
    unsigned long now;
    short i;

    if (!gEveryTable) return;
    now = TickCount();
    for (i = 0; i < gNEvery; i++) {
        if ((long)(now - gEveryDue[i]) < 0) continue; /* not due yet */
        gEveryDue[i] = now + (unsigned long)gEveryTable[i].ticks;
#ifdef RT_MAC_TEST
        rt_ui_trace_every(i);
#endif
        if (gEveryTable[i].fire) gEveryTable[i].fire();
    }
}

void rt_ui_startup(const rt_ui_window_desc **wins, short nWins,
                    const rt_ui_menu_desc **menus, short nMenus,
                    const rt_ui_menu_handler *mh, short nMh,
                    const rt_ui_every_desc *ev, short nEv)
{
    (void)wins; (void)nWins;
    rt_mac_init_toolbox(); /* eager: subsumes rt_mac.c's own lazy init */
    FlushEvents(everyEvent, 0);
    rt_ui_build_apple_menu(); /* inserted first so it lands leftmost in the bar */
    rt_ui_build_menus(menus, nMenus);
    gMenuHandlerTable = mh;
    gNMenuHandlers = nMh;
#ifdef RT_MAC_TEST
    gTraceWinTypes = wins;
    gTraceNWinTypes = nWins;
    gTraceWinCounts = nWins > 0 ? (short *)NewPtrClear((Size)nWins * sizeof(short)) : NULL;
    gDimPrev = nMh > 0 ? (char *)NewPtrClear((Size)nMh) : NULL;
    gDimFirst = 1;
#endif
    rt_ui_menu_recompute_dim(); /* no windows open yet: all window-scoped items start dimmed */
    rt_ui_build_every(ev, nEv);
}

#ifdef RT_MAC_TEST
/* ==================== RT_MAC_TEST scripted events (Task 3) ====================
 * `rt_ui_test_script` (weak, empty by default -- see rt_ui.h) is consumed
 * here INSTEAD of WaitNextEvent when non-empty, per the plan's pinned
 * grammar. The injection point is exactly this: rt_ui_run's single
 * WaitNextEvent call site is replaced wholesale by rt_ui_run_scripted
 * below; every downstream dispatch function (rt_ui_handle_mouse_down,
 * rt_ui_handle_key, rt_ui_menu_dispatch, rt_ui_fire_widget,
 * rt_ui_fire_canvas_xy, ...) is the SAME code real input already used --
 * the only sanctioned exception is the TrackControl bypass documented at
 * its one call site in rt_ui_handle_content_click. */

__attribute__((weak)) const char rt_ui_test_script[] = "";

static const char *gScriptCursor = NULL;
static unsigned long gVirtualTicks = 0; /* replaces TickCount() for `every` scheduling in scripted mode */

/* Reads one non-blank line (verb + args, NUL-terminated, trailing '\n'
   stripped) from rt_ui_test_script into buf. Returns 0 at end of script
   (script exhaustion), which the caller treats as `quit`. Lines longer
   than bufsz-1 are truncated -- generated/hand-written scripts are always
   short lines, so this is a defensive bound, not a real limit. */
static int rt_ui_script_next_line(char *buf, int bufsz)
{
    int n;
    if (!gScriptCursor) gScriptCursor = rt_ui_test_script;
    for (;;) {
        if (*gScriptCursor == '\0') return 0;
        n = 0;
        while (*gScriptCursor && *gScriptCursor != '\n') {
            if (n < bufsz - 1) buf[n++] = *gScriptCursor;
            gScriptCursor++;
        }
        if (*gScriptCursor == '\n') gScriptCursor++;
        buf[n] = '\0';
        if (n > 0) return 1; /* blank line: keep reading */
    }
}

/* Drains queued update/activate events (never mouseDown/keyDown -- nothing
   generates those without a real WaitNextEvent call in scripted mode) so
   InvalRect'd content (e.g. a label rewritten by rt_ui_widget_set_str)
   actually reaches the screen bits before the next script action or a
   `snap`, matching what a real WaitNextEvent-driven loop would have
   processed between one action and the next by now. Bounded: these are
   software-queued Toolbox events, not blocking waits on real input. */
static void rt_ui_pump_passive(void)
{
    EventRecord ev;
    while (GetNextEvent(updateMask | activMask, &ev)) {
        if (ev.what == updateEvt) rt_ui_handle_update((WindowPtr)ev.message);
        else if (ev.what == activateEvt) rt_ui_handle_activate((WindowPtr)ev.message, (ev.modifiers & activeFlag) != 0);
    }
}

/* `click X Y` (GLOBAL coords): synthesizes a mouseDown EventRecord and
   feeds it through the EXACT SAME rt_ui_handle_mouse_down real clicks use
   -- goAway/drag/grow/menu-bar/content all resolve identically; the one
   divergence (button clicks skip TrackControl's modal loop) is documented
   at its call site in rt_ui_handle_content_click. */
static void rt_ui_script_click(short x, short y)
{
    EventRecord ev;
    ev.what = mouseDown;
    ev.where.h = x;
    ev.where.v = y;
    ev.modifiers = 0;
    rt_ui_handle_mouse_down(&ev);
}

/* `drag X Y` (GLOBAL coords): "mouse-moved-while-down" has no Toolbox
   event type of its own -- real canvas dragging is polled with StillDown()
   inside rt_ui_handle_canvas_click's own loop, which scripted mode cannot
   drive (there is no continuously-held real mouse button). A script drag
   is therefore its own discrete action: resolve (X,Y) via FindWindow
   exactly like a content click would, and if it lands inside a canvas
   widget's rect on the frontmost window, fire RTUI_WEV_DRAG directly --
   same widget-local coordinate conversion and same rt_ui_fire_canvas_xy
   entry point real dragging uses, just without TrackControl/StillDown's
   real-mouse machinery in between. A point that misses (no window, wrong
   window, not over a canvas) is a silent no-op, same as a real drag that
   wanders off every hit-testable widget. */
static void rt_ui_script_drag(short x, short y)
{
    WindowPtr wp;
    Point where, local;
    short part, cIdx;
    rt_ui_winst *inst;

    where.h = x;
    where.v = y;
    part = FindWindow(where, &wp);
    if (part != inContent || wp != FrontWindow()) return;
    inst = rt_ui_winst_of(wp);
    if (!inst) return;
    SetPort(wp);
    local = where;
    GlobalToLocal(&local);
    if (rt_ui_canvas_hit(inst, local, &cIdx)) rt_ui_fire_canvas_xy(inst, cIdx, RTUI_WEV_DRAG, local);
}

/* `key C`: synthesizes a keyDown EventRecord for the exact same
   rt_ui_handle_key real typing uses (menu-key equivalents, Return/Escape
   default/cancel wiring, and the frontmost window's `key` handler all
   resolve identically). */
static void rt_ui_script_key(unsigned char ch)
{
    EventRecord ev;
    ev.what = keyDown;
    ev.message = ch;
    ev.modifiers = 0;
    rt_ui_handle_key(&ev);
}

/* `close`: "goAway click on frontmost" -- a real goAway click needs
   TrackGoAway to confirm the mouse-up landed back in the box (impossible
   to simulate meaningfully without a real mouse); a script `close` means
   "the close box was clicked and released", so it goes directly to
   rt_ui_close, exactly what a successful TrackGoAway leads to in
   rt_ui_handle_mouse_down's inGoAway case. */
static void rt_ui_script_close(void)
{
    WindowPtr wp;
    rt_ui_winst *inst;

    wp = FrontWindow();
    if (!wp) return;
    inst = rt_ui_winst_of(wp);
    if (inst) rt_ui_close(inst);
}

/* `resize W H`: real resizing is interactive (GrowWindow blocks on a real
   mouse drag); a script gives the new size directly, so it skips straight
   to rt_ui_apply_resize -- the same post-GrowWindow logic (layout, canvas
   realloc, `resized` trace + handler) rt_ui_handle_grow already factors
   out for exactly this reuse. */
static void rt_ui_script_resize(short w, short h)
{
    WindowPtr wp;
    rt_ui_winst *inst;

    wp = FrontWindow();
    if (!wp) return;
    inst = rt_ui_winst_of(wp);
    if (inst && inst->desc->resizable) rt_ui_apply_resize(wp, inst, w, h);
}

/* `tick N`: advances the VIRTUAL tick counter (TickCount is never
   consulted in scripted mode) and pumps the every-table off of it, once --
   same "reschedule from now, no burst catch-up" policy rt_ui_every_pump
   already uses for real timers (see its comment), just against
   gVirtualTicks instead of TickCount(). A separate function from
   rt_ui_every_pump (rather than a shared one parameterized on "now") keeps
   real-build `every` scheduling untouched by anything scripted-mode adds. */
static void rt_ui_script_every_pump(void)
{
    short i;
    if (!gEveryTable) return;
    for (i = 0; i < gNEvery; i++) {
        if ((long)(gVirtualTicks - gEveryDue[i]) < 0) continue; /* not due yet */
        gEveryDue[i] = gVirtualTicks + (unsigned long)gEveryTable[i].ticks;
        rt_ui_trace_every(i);
        if (gEveryTable[i].fire) gEveryTable[i].fire();
    }
}

static void rt_ui_script_tick(long n)
{
    gVirtualTicks += (unsigned long)n;
    rt_ui_script_every_pump();
    rt_ui_flush_all_buffered(); /* same "returns control to the event loop" point real rt_ui_run uses, Ch11 */
}

/* `snap NAME`: hex-dumps RTUI_SNAP_BYTES bytes starting at
   qd.screenBits.baseAddr between the pinned sentinels, uppercase, 128 hex
   chars (64 source bytes) per line -- RTUI_SNAP_BYTES is an exact multiple
   of 64, so every line is a full line, no partial-line case to handle.
   rowBytes is asserted (not just assumed) to be 64, since the whole
   64-bytes-per-hex-line convention depends on it. */
#define RTUI_SNAP_BYTES 10944L

static void rt_ui_hex_line(char *out, const unsigned char *src)
{
    static const char hexd[16] = "0123456789ABCDEF";
    int i;
    for (i = 0; i < 64; i++) {
        out[i * 2] = hexd[(src[i] >> 4) & 0xF];
        out[i * 2 + 1] = hexd[src[i] & 0xF];
    }
    out[128] = '\0';
}

static void rt_ui_test_snap(const char *name)
{
    unsigned char *base;
    long off;
    char hdr[280];
    char line[130];

    if (qd.screenBits.rowBytes != 64) rt_panic("snap: screenBits.rowBytes is not 64");
    sprintf(hdr, "##CLARUS-SNAP## %s", name);
    rt_test_emit(hdr);
    base = (unsigned char *)qd.screenBits.baseAddr;
    for (off = 0; off < RTUI_SNAP_BYTES; off += 64) {
        rt_ui_hex_line(line, base + off);
        rt_test_emit(line);
    }
    rt_test_emit("##CLARUS-SNAP-END##");
}

/* Menu bar position -> native (menuID, itemNum), for `menu M I` (Task 3):
   M is the 1-based BAR position, where position 1 is ALWAYS the Apple
   menu (native ID RTUI_APPLE_MENU_ID == 1) and positions 2..N+1 are the N
   declared menus in declaration order (native IDs RTUI_MENU_ID_BASE(2)..
   RTUI_MENU_ID_BASE+N-1). Both are built with InsertMenu(mh, 0)
   (append-to-list == rightward-in-bar) in that exact order at startup
   (rt_ui_build_apple_menu then rt_ui_build_menus), so bar position and
   native menu ID are numerically IDENTICAL -- `menu M I` needs no
   position-to-ID translation at all: passing M as the native menuID and I
   as the native 1-based itemNum reproduces exactly what MenuSelect would
   have returned for a real click on that (position, item). So `menu 2 1`
   is the FIRST declared menu's FIRST item (position 1 is Apple). Task 6's
   goldens pin this numbering -- do not change RTUI_MENU_ID_BASE or the
   Apple-menu-first insertion order in rt_ui_startup without updating this
   comment and the two call sites above (rt_ui_build_apple_menu /
   rt_ui_build_menus) that make it true. */
static void rt_ui_script_menu(short m, short i)
{
    rt_ui_menu_dispatch(((long)m << 16) | (unsigned short)i);
}

static void rt_ui_run_scripted(void)
{
    char line[256];
    char verb[32];
    char arg1[64], arg2[64];

    gUiScripted = 1;
    HideCursor(); /* determinism for `snap` -- scripted-mode startup only, per the contract */
    for (;;) {
        int nf;
        if (!rt_ui_script_next_line(line, sizeof(line))) { rt_quit(0); return; }
        arg1[0] = '\0';
        arg2[0] = '\0';
        nf = sscanf(line, "%31s %63s %63s", verb, arg1, arg2);
        if (nf < 1) continue;
        if (strcmp(verb, "click") == 0) {
            rt_ui_script_click((short)atoi(arg1), (short)atoi(arg2));
        } else if (strcmp(verb, "drag") == 0) {
            rt_ui_script_drag((short)atoi(arg1), (short)atoi(arg2));
        } else if (strcmp(verb, "key") == 0) {
            rt_ui_script_key((unsigned char)arg1[0]);
        } else if (strcmp(verb, "menu") == 0) {
            rt_ui_script_menu((short)atoi(arg1), (short)atoi(arg2));
        } else if (strcmp(verb, "close") == 0) {
            rt_ui_script_close();
        } else if (strcmp(verb, "resize") == 0) {
            rt_ui_script_resize((short)atoi(arg1), (short)atoi(arg2));
        } else if (strcmp(verb, "tick") == 0) {
            rt_ui_script_tick((long)atoi(arg1));
        } else if (strcmp(verb, "snap") == 0) {
            rt_ui_test_snap(arg1);
        } else if (strcmp(verb, "quit") == 0) {
            rt_quit(0);
            return;
        }
        rt_ui_pump_passive();
    }
}
#endif /* RT_MAC_TEST */

void rt_ui_run(void)
{
    EventRecord ev;
#ifdef RT_MAC_TEST
    if (rt_ui_test_script[0] != '\0') {
        rt_ui_run_scripted();
        return; /* unreachable in practice: rt_ui_run_scripted only returns via rt_quit, which does not */
    }
#endif
    for (;;) {
        WaitNextEvent(everyEvent, &ev, (short)(gNEvery > 0 ? 1 : 30), NULL);
        switch (ev.what) {
        case mouseDown:
            rt_ui_handle_mouse_down(&ev);
            break;
        case keyDown:
        case autoKey:
            rt_ui_handle_key(&ev);
            break;
        case updateEvt:
            rt_ui_handle_update((WindowPtr)ev.message);
            break;
        case activateEvt:
            rt_ui_handle_activate((WindowPtr)ev.message, (ev.modifiers & activeFlag) != 0);
            break;
        default:
            break;
        }
        rt_ui_every_pump();
        rt_ui_flush_all_buffered(); /* "returns control to the event loop" point, Ch11 */
    }
}

void *rt_ui_open(const rt_ui_window_desc *d)
{
    rt_ui_winst *inst;
    Handle instH;
    Rect bounds;
    short screenW, left, top;

    inst = (rt_ui_winst *)rt_ui_alloc_locked(sizeof(rt_ui_winst), &instH);
    inst->selfH = instH;
    inst->desc = d;
    if (d->stateSize > 0) {
        inst->state = rt_ui_alloc_locked((Size)d->stateSize, &inst->stateH);
    } else {
        inst->state = NULL;
        inst->stateH = NULL;
    }
    inst->ctrls = (ControlHandle *)rt_ui_alloc_locked((Size)d->nWidgets * sizeof(ControlHandle), &inst->ctrlsH);
    inst->rects = (Rect *)rt_ui_alloc_locked((Size)d->nWidgets * sizeof(Rect), &inst->rectsH);
    inst->labels = (unsigned char (*)[256])rt_ui_alloc_locked((Size)d->nWidgets * 256, &inst->labelsH);
    inst->canvases = (rt_ui_canvas_buf *)rt_ui_alloc_locked((Size)d->nWidgets * sizeof(rt_ui_canvas_buf), &inst->canvasH);

    screenW = (short)(qd.screenBits.bounds.right - qd.screenBits.bounds.left);
    left = (short)((screenW - d->w) / 2);
    if (left < 4) left = 4;
    top = 44;
    SetRect(&bounds, left, top, (short)(left + d->w), (short)(top + d->h));

    inst->wp = NewWindow(NULL, &bounds, d->title, (Boolean)0,
                          d->resizable ? documentProc : noGrowDocProc,
                          (WindowPtr)-1L, (Boolean)1, 0L);
    if (!inst->wp) rt_panic("out of memory");
    ((WindowPeek)inst->wp)->windowKind = RTUI_WINDOW_KIND;
    SetWRefCon(inst->wp, (long)inst);

    rt_ui_make_widgets(inst);
    rt_ui_layout(inst);
    rt_ui_canvas_realloc_all(inst);

    ShowWindow(inst->wp);
    SelectWindow(inst->wp);
#ifdef RT_MAC_TEST
    inst->traceId = rt_ui_trace_next_id(d);
    rt_ui_trace_id("OPEN", d->name, inst->traceId);
#endif
    rt_ui_after_front_change(); /* frontmost changed: this instance is now front */

    /* `opened` is not in the T FIRE event vocabulary (only closeRequest/
       closed/resized/key are) -- T OPEN above already covers "a window was
       opened", so no trace line accompanies this handler call. */
    if (d->handlers && d->handlers->winEvent)
        d->handlers->winEvent(inst, RTUI_EV_OPENED, 0, 0);

    return inst;
}

void rt_ui_close(void *instV)
{
    rt_ui_winst *inst;
    long cancelFlag;

    inst = (rt_ui_winst *)instV;
    cancelFlag = 0;
#ifdef RT_MAC_TEST
    rt_ui_trace_fire1(inst->desc->name, "closeRequest");
#endif
    if (inst->desc->handlers && inst->desc->handlers->winEvent)
        inst->desc->handlers->winEvent(inst, RTUI_EV_CLOSEREQUEST, (long)&cancelFlag, 0);
    if (cancelFlag) return;

    /* Ch8: "on closed ... The window has finished closing; its per-instance
       state is about to be freed" -- so the window is gone (DisposeWindow,
       which also disposes its Controls) before `closed` fires, and our own
       bookkeeping Handles (which still hold valid data at this point) are
       freed only after the handler returns. */
    DisposeWindow(inst->wp);
#ifdef RT_MAC_TEST
    rt_ui_trace_id("CLOSE", inst->desc->name, inst->traceId);
#endif
    rt_ui_after_front_change(); /* frontmost changed: this instance is gone */
#ifdef RT_MAC_TEST
    rt_ui_trace_fire1(inst->desc->name, "closed");
#endif
    if (inst->desc->handlers && inst->desc->handlers->winEvent)
        inst->desc->handlers->winEvent(inst, RTUI_EV_CLOSED, 0, 0);

    {
        short i;
        for (i = 0; i < inst->desc->nWidgets; i++) rt_ui_canvas_dispose(&inst->canvases[i]);
    }
    if (inst->stateH) DisposeHandle(inst->stateH);
    DisposeHandle(inst->ctrlsH);
    DisposeHandle(inst->rectsH);
    DisposeHandle(inst->labelsH);
    DisposeHandle(inst->canvasH);
    DisposeHandle(inst->selfH);
}

void *rt_ui_front(const rt_ui_window_desc *d)
{
    WindowPeek w;

    w = (WindowPeek)FrontWindow();
    while (w) {
        if (((WindowPeek)w)->windowKind == RTUI_WINDOW_KIND) {
            rt_ui_winst *inst;
            inst = (rt_ui_winst *)GetWRefCon((WindowPtr)w);
            if (inst->desc == d) return inst;
        }
        w = ((WindowPeek)w)->nextWindow;
    }
    return NULL;
}

void *rt_ui_state(void *inst)
{
    return ((rt_ui_winst *)inst)->state;
}

void rt_ui_set_title(void *inst, const unsigned char *s)
{
    SetWTitle(((rt_ui_winst *)inst)->wp, s);
}

void rt_ui_widget_set_str(void *instV, short wIdx, short prop, const unsigned char *s)
{
    rt_ui_winst *inst;
    const rt_ui_widget_desc *wd;
    GrafPtr savedPort;

    inst = (rt_ui_winst *)instV;
    /* InvalRect/SetControlTitle work in the CURRENT port's terms -- fine
       when called from widget-click dispatch (already SetPort'd to this
       window), NOT fine from a menu handler or every-block, which can run
       with any port current (a canvas op, another window, ...). Self-
       assert and restore rather than trusting the caller's ambient state
       (the rt_ui.h header comment codifies this as a rule every
       Toolbox-touching entry point follows). */
    GetPort(&savedPort);
    SetPort(inst->wp);
    wd = &inst->desc->widgets[wIdx];
#ifdef RT_MAC_TEST
    rt_ui_trace_set_str(inst->desc->name, wd->name, prop, s);
#endif
    if (wd->kind == RTUI_LABEL && prop == RTUI_PROP_TEXT) {
        rt_ui_pstrcpy(inst->labels[wIdx], s);
        InvalRect(&inst->rects[wIdx]);
    } else if (wd->kind == RTUI_BUTTON && prop == RTUI_PROP_CAPTION && inst->ctrls[wIdx]) {
        SetControlTitle(inst->ctrls[wIdx], s);
    }
    SetPort(savedPort);
}

void rt_ui_widget_set_bool(void *instV, short wIdx, short prop, int v)
{
    rt_ui_winst *inst;
    const rt_ui_widget_desc *wd;
    GrafPtr savedPort;

    inst = (rt_ui_winst *)instV;
    GetPort(&savedPort); /* same reasoning as rt_ui_widget_set_str -- see its comment */
    SetPort(inst->wp);
    wd = &inst->desc->widgets[wIdx];
#ifdef RT_MAC_TEST
    rt_ui_trace_set_bool(inst->desc->name, wd->name, prop, v);
#endif
    if (wd->kind == RTUI_CHECK && prop == RTUI_PROP_CHECKED && inst->ctrls[wIdx]) {
        SetControlValue(inst->ctrls[wIdx], (short)(v ? 1 : 0));
    } else if (wd->kind == RTUI_BUTTON && prop == RTUI_PROP_ENABLED && inst->ctrls[wIdx]) {
        HiliteControl(inst->ctrls[wIdx], (short)(v ? 0 : 255));
    }
    SetPort(savedPort);
}

int rt_ui_widget_get_bool(void *instV, short wIdx, short prop)
{
    rt_ui_winst *inst;
    const rt_ui_widget_desc *wd;

    inst = (rt_ui_winst *)instV;
    wd = &inst->desc->widgets[wIdx];
    if (wd->kind == RTUI_CHECK && prop == RTUI_PROP_CHECKED && inst->ctrls[wIdx]) {
        return GetControlValue(inst->ctrls[wIdx]) != 0;
    }
    if (wd->kind == RTUI_BUTTON && prop == RTUI_PROP_ENABLED && inst->ctrls[wIdx]) {
        return (*inst->ctrls[wIdx])->contrlHilite == 0;
    }
    return 0;
}

short rt_ui_widget_get_int(void *instV, short wIdx, short prop)
{
    rt_ui_winst *inst;
    inst = (rt_ui_winst *)instV;
    if (prop == RTUI_PROP_HEIGHT)
        return (short)(inst->rects[wIdx].bottom - inst->rects[wIdx].top);
    return (short)(inst->rects[wIdx].right - inst->rects[wIdx].left); /* default: width */
}

/* ==================== canvas drawing ops (Ch11) ====================
 * Every op targets a canvas's offscreen port (buffered) or the window's
 * own port at an offset (unbuffered), per rt_ui_canvas_begin, in
 * widget-local coordinates either way (Ch11: "the origin (0,0) is the
 * canvas's top-left corner"). Buffered ops are NOT blitted to the screen
 * here -- rt_ui_flush_all_buffered (called once per rt_ui_run iteration)
 * does that, which is what gives buffered drawing its flicker-free,
 * one-copy-per-handler behavior (Ch11's "Buffered vs. Unbuffered"). */
typedef struct { GrafPtr port; short dx, dy; GrafPtr savedPort; } rt_ui_canvas_target;

/* Self-asserts and restores its own port, like every other Toolbox-touching
   rt_ui entry point (rt_ui.h header rule) -- paired with rt_ui_canvas_end,
   which every op below calls before returning. */
static rt_ui_canvas_target rt_ui_canvas_begin(rt_ui_winst *inst, short wIdx)
{
    rt_ui_canvas_target t;
    rt_ui_canvas_buf *cb;

    cb = &inst->canvases[wIdx];
    if (cb->port) {
        t.port = cb->port;
        t.dx = 0;
        t.dy = 0;
    } else {
        t.port = inst->wp;
        t.dx = inst->rects[wIdx].left;
        t.dy = inst->rects[wIdx].top;
    }
    GetPort(&t.savedPort);
    SetPort(t.port);
    return t;
}

static void rt_ui_canvas_end(rt_ui_canvas_target t)
{
    SetPort(t.savedPort);
}

void rt_ui_canvas_clear(void *instV, short wIdx)
{
    rt_ui_winst *inst;
    rt_ui_canvas_target t;
    Rect r;

    inst = (rt_ui_winst *)instV;
    t = rt_ui_canvas_begin(inst, wIdx);
    if (inst->canvases[wIdx].port) r = inst->canvases[wIdx].bits.bounds;
    else r = inst->rects[wIdx];
    EraseRect(&r);
    rt_ui_canvas_end(t);
}

void rt_ui_canvas_line(void *instV, short wIdx, short x0, short y0, short x1, short y1)
{
    rt_ui_winst *inst;
    rt_ui_canvas_target t;

    inst = (rt_ui_winst *)instV;
    t = rt_ui_canvas_begin(inst, wIdx);
    MoveTo((short)(x0 + t.dx), (short)(y0 + t.dy));
    LineTo((short)(x1 + t.dx), (short)(y1 + t.dy));
    rt_ui_canvas_end(t);
}

void rt_ui_canvas_rect(void *instV, short wIdx, short x, short y, short w, short h, int fill)
{
    rt_ui_winst *inst;
    rt_ui_canvas_target t;
    Rect r;

    inst = (rt_ui_winst *)instV;
    t = rt_ui_canvas_begin(inst, wIdx);
    SetRect(&r, (short)(x + t.dx), (short)(y + t.dy), (short)(x + t.dx + w), (short)(y + t.dy + h));
    if (fill) PaintRect(&r);
    else FrameRect(&r);
    rt_ui_canvas_end(t);
}

void rt_ui_canvas_fill_circle(void *instV, short wIdx, short x, short y, short r)
{
    rt_ui_winst *inst;
    rt_ui_canvas_target t;
    Rect box;

    inst = (rt_ui_winst *)instV;
    t = rt_ui_canvas_begin(inst, wIdx);
    SetRect(&box, (short)(x + t.dx - r), (short)(y + t.dy - r), (short)(x + t.dx + r), (short)(y + t.dy + r));
    PaintOval(&box);
    rt_ui_canvas_end(t);
}

void rt_ui_canvas_circle(void *instV, short wIdx, short x, short y, short r)
{
    rt_ui_winst *inst;
    rt_ui_canvas_target t;
    Rect box;

    inst = (rt_ui_winst *)instV;
    t = rt_ui_canvas_begin(inst, wIdx);
    SetRect(&box, (short)(x + t.dx - r), (short)(y + t.dy - r), (short)(x + t.dx + r), (short)(y + t.dy + r));
    FrameOval(&box);
    rt_ui_canvas_end(t);
}

void rt_ui_canvas_draw_text(void *instV, short wIdx, short x, short y, const unsigned char *s)
{
    rt_ui_winst *inst;
    rt_ui_canvas_target t;

    inst = (rt_ui_winst *)instV;
    t = rt_ui_canvas_begin(inst, wIdx);
    MoveTo((short)(x + t.dx), (short)(y + t.dy));
    DrawString(s);
    rt_ui_canvas_end(t);
}
