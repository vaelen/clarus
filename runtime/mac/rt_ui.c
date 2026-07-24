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
       item actually becomes unselectable) is real now. The Apple menu and
       About item (Ch9) are intentionally NOT built here: nothing in this
       plan's ABI or Task 2's probe exercises them, and Ch9 itself says a
       richer About dialog is future work -- ponytail: add when something
       actually needs it.
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

/* rt_mac.c's eager Toolbox init, exposed non-static for exactly this call
   (see runtime/mac/rt_mac.c). */
extern void rt_mac_init_toolbox(void);

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
 * for trace output (Task 3), not needed for dispatch. The Apple menu is
 * deliberately not built (see the file header comment). */

static MenuHandle *gMenuHandles = NULL;  /* gNMenus entries */
static short gNMenus = 0;
static const rt_ui_menu_handler *gMenuHandlerTable = NULL;
static short gNMenuHandlers = 0;

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
        if (!h->scope) continue;
        rt_ui_menu_enable(h->menuIndex, h->itemIndex, rt_ui_front(h->scope) != NULL);
    }
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

    SetPort(inst->wp); /* Return/Escape-key dispatch reaches here without having set a port first (unlike the content-click caller) */
    wd = &inst->desc->widgets[wIdx];
    ctrl = inst->ctrls[wIdx];
    switch (wd->kind) {
    case RTUI_CHECK: {
        short newVal;
        newVal = (short)(GetControlValue(ctrl) ? 0 : 1);
        SetControlValue(ctrl, newVal);
        if (inst->desc->handlers && inst->desc->handlers->widget)
            inst->desc->handlers->widget(inst, wIdx, RTUI_WEV_CHANGE, (long)newVal, 0);
        break;
    }
    case RTUI_BUTTON:
        if (inst->desc->handlers && inst->desc->handlers->widget)
            inst->desc->handlers->widget(inst, wIdx, RTUI_WEV_CLICK, 0, 0);
        break;
    default:
        break;
    }
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

static void rt_ui_handle_grow(WindowPtr wp, rt_ui_winst *inst, Point where)
{
    Rect limits;
    long newSize;
    short newW, newH;

    if (!inst->desc->resizable) return;
    SetRect(&limits,
            (short)(inst->desc->minW > 0 ? inst->desc->minW : 1),
            (short)(inst->desc->minH > 0 ? inst->desc->minH : 1),
            32767, 32767);
    newSize = GrowWindow(wp, where, &limits);
    if (newSize == 0) return;
    newW = LoWord(newSize);
    newH = HiWord(newSize);
    SizeWindow(wp, newW, newH, (Boolean)1);
    rt_ui_layout(inst);
    rt_ui_canvas_realloc_all(inst); /* buffered canvas sizes may have tracked the resize (fill: both) */
    if (inst->desc->handlers && inst->desc->handlers->winEvent)
        inst->desc->handlers->winEvent(inst, RTUI_EV_RESIZED, 0, 0);
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
        short trackPart;
        short wIdx;
        wIdx = (short)(*ctrl)->contrlRfCon;
        trackPart = TrackControl(ctrl, where, NULL);
        if (trackPart != 0) rt_ui_fire_widget(inst, wIdx);
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
        rt_ui_menu_recompute_dim();
        break;
    }
    case inGrow:
        inst = rt_ui_winst_of(wp);
        if (inst) rt_ui_handle_grow(wp, inst, ev->where);
        break;
    case inContent:
        if (wp != FrontWindow()) {
            SelectWindow(wp);
            rt_ui_menu_recompute_dim(); /* click-to-front changed frontmost */
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
    now = TickCount();
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
    rt_ui_build_menus(menus, nMenus);
    gMenuHandlerTable = mh;
    gNMenuHandlers = nMh;
    rt_ui_menu_recompute_dim(); /* no windows open yet: all window-scoped items start dimmed */
    rt_ui_build_every(ev, nEv);
}

void rt_ui_run(void)
{
    EventRecord ev;
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
    rt_ui_menu_recompute_dim(); /* frontmost changed: this instance is now front */

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
    if (inst->desc->handlers && inst->desc->handlers->winEvent)
        inst->desc->handlers->winEvent(inst, RTUI_EV_CLOSEREQUEST, (long)&cancelFlag, 0);
    if (cancelFlag) return;

    /* Ch8: "on closed ... The window has finished closing; its per-instance
       state is about to be freed" -- so the window is gone (DisposeWindow,
       which also disposes its Controls) before `closed` fires, and our own
       bookkeeping Handles (which still hold valid data at this point) are
       freed only after the handler returns. */
    DisposeWindow(inst->wp);
    rt_ui_menu_recompute_dim(); /* frontmost changed: this instance is gone */
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

    inst = (rt_ui_winst *)instV;
    /* InvalRect/SetControlTitle work in the CURRENT port's terms -- fine
       when called from widget-click dispatch (already SetPort'd to this
       window), NOT fine from a menu handler or every-block, which can run
       with any port current (a canvas op, another window, ...). Set it
       explicitly rather than trusting the caller's ambient state. */
    SetPort(inst->wp);
    wd = &inst->desc->widgets[wIdx];
    if (wd->kind == RTUI_LABEL && prop == RTUI_PROP_TEXT) {
        rt_ui_pstrcpy(inst->labels[wIdx], s);
        InvalRect(&inst->rects[wIdx]);
    } else if (wd->kind == RTUI_BUTTON && prop == RTUI_PROP_CAPTION && inst->ctrls[wIdx]) {
        SetControlTitle(inst->ctrls[wIdx], s);
    }
}

void rt_ui_widget_set_bool(void *instV, short wIdx, short prop, int v)
{
    rt_ui_winst *inst;
    const rt_ui_widget_desc *wd;

    inst = (rt_ui_winst *)instV;
    SetPort(inst->wp); /* same reasoning as rt_ui_widget_set_str -- see its comment */
    wd = &inst->desc->widgets[wIdx];
    if (wd->kind == RTUI_CHECK && prop == RTUI_PROP_CHECKED && inst->ctrls[wIdx]) {
        SetControlValue(inst->ctrls[wIdx], (short)(v ? 1 : 0));
    } else if (wd->kind == RTUI_BUTTON && prop == RTUI_PROP_ENABLED && inst->ctrls[wIdx]) {
        HiliteControl(inst->ctrls[wIdx], (short)(v ? 0 : 255));
    }
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
typedef struct { GrafPtr port; short dx, dy; } rt_ui_canvas_target;

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
    SetPort(t.port);
    return t;
}

void rt_ui_canvas_clear(void *instV, short wIdx)
{
    rt_ui_winst *inst;
    Rect r;

    inst = (rt_ui_winst *)instV;
    rt_ui_canvas_begin(inst, wIdx);
    if (inst->canvases[wIdx].port) r = inst->canvases[wIdx].bits.bounds;
    else r = inst->rects[wIdx];
    EraseRect(&r);
}

void rt_ui_canvas_line(void *instV, short wIdx, short x0, short y0, short x1, short y1)
{
    rt_ui_winst *inst;
    rt_ui_canvas_target t;

    inst = (rt_ui_winst *)instV;
    t = rt_ui_canvas_begin(inst, wIdx);
    MoveTo((short)(x0 + t.dx), (short)(y0 + t.dy));
    LineTo((short)(x1 + t.dx), (short)(y1 + t.dy));
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
}

void rt_ui_canvas_draw_text(void *instV, short wIdx, short x, short y, const unsigned char *s)
{
    rt_ui_winst *inst;
    rt_ui_canvas_target t;

    inst = (rt_ui_winst *)instV;
    t = rt_ui_canvas_begin(inst, wIdx);
    MoveTo((short)(x + t.dx), (short)(y + t.dy));
    DrawString(s);
}
