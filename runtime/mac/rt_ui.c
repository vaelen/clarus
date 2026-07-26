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

   RT_MAC_TEST scripted events/trace/snaps are Task 3: rt_ui_run_scripted,
   the T-line trace helpers, and the `snap` hex-dump all live behind
   #ifdef RT_MAC_TEST below and compile out of a normal (non-test) build
   entirely -- everything else in this file (windows, widgets, menus,
   canvas, timers, the quit cascade) is the SAME code in both modes. */
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
#include <Scrap.h>     /* ZeroScrap/TEToScrap/TEFromScrap -- standard-edit cut/copy/paste (Task 3) */
#include <Dialogs.h>   /* NoteAlert, for the About item (Ch9) */
#include <StandardFile.h> /* SFGetFile/SFPutFile, for askOpen/askSave (Ch12, Task 4) */
#include <Devices.h>   /* OpenDeskAcc, for the Apple menu's desk-accessory list */
#include <LowMem.h>    /* LMGetCurApName -- the running app's name, for About (Ch9) */
#include <AppleEvents.h> /* AEInstallEventHandler + kCoreEventClass/kAEOpen.../kAEQuit... (Task 5) */
#include <Gestalt.h>     /* Gestalt(gestaltAppleEventsAttr, ...) (Task 5); NOT GestaltEqu.h, which
                            is a compatibility shim that #errors telling you to use this one instead */
#include <SegLoad.h>     /* CountAppFiles/GetAppFiles/ClrAppFiles -- System 6's pre-AppleEvents
                            "documents at launch" mechanism (Task 5) */
#include <Files.h>       /* FSSpec/OpenWD/SetVol (Task 5) -- already pulled in transitively by
                            StandardFile.h above; included directly too since rt_ui_launch's own
                            AE path uses it by name, not just through StandardFile's dialogs */
#ifdef RT_MAC_TEST
#include <stdio.h>     /* sprintf/sscanf -- trace-line formatting and script-line parsing (Task 3) */
#include <string.h>    /* strcmp -- script verb dispatch (Task 3) */
#include <stdlib.h>    /* atoi -- script argument parsing (Task 3) */
#endif

/* rt_mac.c's eager Toolbox init, exposed non-static for exactly this call
   (see runtime/mac/rt_mac.c). */
extern void rt_mac_init_toolbox(void);

/* Weak default for rt_ui.h's rt_ui_app_info -- every field the empty
   Pascal string, meaning "no `app` section". Same weak-override contract
   as rt_ui_test_script below (rt_ui.h), but NOT test-only: this one exists
   in every build, test or not, since a program with no `app` section is
   the common case, not a test fixture. clarusc emits ONE strong,
   non-empty definition of this exact symbol (Task 2, cprint.cla's
   cpEmitAppInfo) only for a program that declares an `app` section,
   overriding this default at link time; every other program links
   against this weak definition unchanged. */
__attribute__((weak)) const rt_ui_app_desc rt_ui_app_info = {
    (const unsigned char *)"\p", (const unsigned char *)"\p",
    (const unsigned char *)"\p", (const unsigned char *)"\p"
};

#ifdef RT_MAC_TEST
/* rt_mac.c's shared capture-stream hook (Task 3): every trace line and
   framebuffer snap chunk below goes through this single entry point, so
   they interleave into the SAME `out` capture file as alert/log output and
   the 4a exit trailer -- there is no second output channel on the Mac
   side (see rt_mac.c's own header comment). */
extern void rt_test_emit(const char *line);

/* rt_ui_quit (below) is the real quit cascade: closeRequest to every open
   window front-to-back, any cancel aborts the whole quit, otherwise
   rt_quit(0) -- the plain process-exit primitive every non-UI `quit`
   statement already compiles to (internal/build/rt/rt.h). The scripted
   `quit` command and script exhaustion (Task 3) call rt_ui_quit() too, not
   rt_quit() directly: "same path as the quit statement" (the design doc's
   pinned contract) means literally the same function, cascade included. */
extern void rt_quit(int32_t code);
#endif

/* Marks our own windows in WindowPeek->windowKind so rt_ui_front/
   rt_ui_winst_of never mistake some other window (a DA, an alert dialog)
   for one of ours when walking the window list. Positive and >= 8, the
   range Inside Macintosh reserves for application use. */
#define RTUI_WINDOW_KIND 2001

/* Screen-clamp constants (bugfix, mac-target-4c-fixes): rt_ui_open's
   NewWindow bounds and rt_ui_handle_grow's GrowWindow max limit both need
   "how much screen is actually usable", so both are pinned here.
   RTUI_MENUBAR_H is the fixed 20px menu bar height -- these Universal
   Interfaces (Retro68/InterfacesAndLibraries) don't declare GetMBarHeight,
   so this is the plain System 6/7 constant, not a live call.
   RTUI_TITLEBAR_H is a document window's fixed 19px title bar.
   RTUI_SCREEN_MARGIN is 2px of breathing room against the RIGHT and
   BOTTOM screen edges, consistent with rt_ui_open's pre-existing
   left>=4 convention (a slightly bigger margin on the left/top, where a
   window's own title bar furniture already reads close to the edge). */
#define RTUI_MENUBAR_H      20
#define RTUI_TITLEBAR_H     19
#define RTUI_SCREEN_MARGIN   2

/* Layout constants (Ch8 doesn't specify pixel values, only relative
   placement rules) -- ponytail: fixed per-kind control heights and one
   shared gap/margin constant, tuned to look like a normal System 6 dialog.
   Revisit if a future widget kind needs a different natural height. */
#define RTUI_GAP        8
#define RTUI_BUTTON_H  20
#define RTUI_CHECK_H   16
#define RTUI_LABEL_H   16
#define RTUI_CANVAS_H 100  /* natural height when not `fill: both` -- Ch8/11 pin no default; picked to be a usable default canvas size */

/* Natural WIDTHS, same free-to-pick status as the heights above, added by
   Task 6 (mac-target-4b) once a real compiled program exposed the gap:
   Ch8's own widget property table gives `check` and `label` NO `width`
   property at all (only `button` and `field` have one), and `canvas` has
   none either (only `fill`) -- so any check/label/unfilled-canvas widget a
   .cla program declares lowers with a literal width of 0 (clarusc's
   default when no `width:` property exists to read -- see
   clarusc/lower.cla's lowWidgetDesc), and used to render as a genuinely
   zero-pixel-wide (invisible) control. Applied in rt_ui_layout below only
   when the declared width is that literal-zero "unset" case (an explicit
   `width: 0` is not a sentence anyone would write, and is indistinguishable
   from "omitted" at this layer either way) -- `width: fill` (RTUI_FILL,
   button/field only) and `fill: both` both still take priority, unchanged. */
#define RTUI_BUTTON_W  80
#define RTUI_CHECK_W   90
#define RTUI_LABEL_W  150
#define RTUI_CANVAS_W 200

/* field/textview natural size (mac-target-4c Task 1) -- same free-to-pick
   status as the constants above; field's height matches a button/single
   edit line, its width a typical labeled form field; textview's height
   matches canvas's own natural (non-`fill:both`) default, wide enough to
   be useful unfilled. Pinned here per the plan's own header-comment rule. */
#define RTUI_FIELD_H       20
#define RTUI_FIELD_W      200
#define RTUI_TEXTVIEW_H   100
#define RTUI_TEXTVIEW_W   200

/* A field's `label:` property reuses the labels[]/TETextBox lane the
   RTUI_LABEL kind already has (rt_ui_handle_update draws it the same way)
   -- fixed-width lane rather than measured via StringWidth. ponytail:
   fixed width, not text-measured; revisit if a long label routinely
   truncates against it. RTUI_TE_FRAME_INSET is the gap between a field/
   textview's own outer box and its TE view/dest rect, leaving room for the
   FrameRect border drawn around it. RTUI_SCROLLBAR_W is the classic Mac
   vertical scrollbar's fixed width. */
#define RTUI_FIELD_LABEL_W  70
#define RTUI_TE_FRAME_INSET  3
#define RTUI_SCROLLBAR_W    15
#define RTUI_TE_NOWRAP_W  2000 /* no-wrap destRect width == horizontal scroll ceiling; longest-line tracking rejected in the spec */
#define RTUI_HSCROLL_STEP 8    /* horizontal arrow nudge, roughly one character */

/* Field/textview text caps (mac-target-4c Task 1): a field's `text` is
   Ch8's `string(255)`-shaped Str255, so 255 is a structural cap already
   enforced by every Str255 call site; RTUI_TE_MAX (rt_ui.h, 32000) is the
   textview `text` (rt_text, unbounded on its own) cap this runtime adds.
   Both are enforced in one place: rt_ui_te_mutated's clamp, below. */
#define RTUI_FIELD_TEXT_MAX 255

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
typedef struct { GrafPtr port; BitMap bits; Ptr pixels; short patLevel; } rt_ui_canvas_buf;

typedef struct rt_ui_winst {
    Handle selfH;                    /* this struct's own locked box */
    WindowPtr wp;
    const rt_ui_window_desc *desc;
    Handle stateH; void *state;      /* per-instance user vars, or NULL if stateSize==0 */
    Handle ctrlsH; ControlHandle *ctrls;  /* nWidgets entries; NULL for non-Control kinds */
    Handle rectsH; Rect *rects;           /* nWidgets entries, window-local coords */
    Handle labelsH; unsigned char (*labels)[256]; /* nWidgets entries; only LABEL kinds used */
    Handle canvasH; rt_ui_canvas_buf *canvases;   /* nWidgets entries; only buffered CANVAS kinds used */
    /* mac-target-4c Task 1: TextEdit field/textview widgets. `tes` holds one
       TEHandle per widget (NULL for every non-FIELD/TEXTVIEW kind); a
       textview's own vertical scrollbar (when RTUI_SCROLL_V) is a normal
       Control Manager control living in `ctrls[i]` like a button/check.
       refCon scheme (window-zoom-hscroll Task 2): ordinary widget `i`;
       textview V bar `0x8000|i`; textview H bar `0xC000|i` (`hbars[i]`,
       below); scrollbar test is `rfCon & 0x8000L`, horizontal test
       `rfCon & 0x4000L`, index mask `0x3FFF`. `logicalEnabled` fixes the
       pre-existing (mac-target-4b) blanket-HiliteControl bug: it
       remembers which widgets the PROGRAM disabled via
       RTUI_PROP_ENABLED, independent of the window's own active/inactive
       dimming, so reactivating a window doesn't visually re-enable a
       control the app explicitly turned off. `focusIdx` is the one
       FIELD/TEXTVIEW with the caret (-1 = none). */
    Handle teH; TEHandle *tes;
    Handle hbarsH; ControlHandle *hbars; /* nWidgets; textview horizontal scrollbar (RTUI_SCROLL_H) or NULL */
    Handle enabledH; char *logicalEnabled;
    short focusIdx;
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

/* `T ABOUT <name>|<version>|<author>|<about>` -- rt_ui_apple_select's
   RT_MAC_TEST substitute for the real ParamText+Alert(129) About box (the
   scripted event reader can't dismiss a modal ALRT, so the four fields it
   would have shown are traced as plain text instead). Each is a Pascal
   string (rt_ui_app_info's fields, all ASCII per the reference's `app`
   section grammar), copied byte-by-byte the same bounded way
   rt_ui_trace_set_str copies a widget's text/caption. Only called when
   rt_ui_app_info.name[0] != 0, so all four fields come from the program's
   own `app` section (never the all-empty weak default). */
static void rt_ui_trace_about(void)
{
    char buf[1040]; /* "T ABOUT " + 4 * 255-byte fields + 3 '|' separators + NUL */
    const unsigned char *fields[4];
    int n, f, i, len;

    fields[0] = rt_ui_app_info.name;
    fields[1] = rt_ui_app_info.version;
    fields[2] = rt_ui_app_info.author;
    fields[3] = rt_ui_app_info.about;
    n = sprintf(buf, "T ABOUT ");
    for (f = 0; f < 4; f++) {
        if (f > 0 && n < (int)sizeof(buf) - 1) buf[n++] = '|';
        len = fields[f] ? fields[f][0] : 0;
        for (i = 0; i < len && n < (int)sizeof(buf) - 1; i++) buf[n++] = (char)fields[f][1 + i];
    }
    buf[n] = '\0';
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

/* ==================== dialogs (Ch12): scripted answer queue (Task 4) ====
 * askOpen/askSave/askSaveChanges (below, near rt_ui_menu_enable) consume
 * this queue INSTEAD of a real Standard File dialog or Alert(130) whenever
 * RT_MAC_TEST is defined -- same "a scripted build never shows a modal the
 * script reader can't dismiss" policy as rt_ui_apple_select's About
 * substitution above, and unconditional on the macro (not gUiScripted): an
 * interactive --test build with an empty script still can't drive a real
 * modal SF dialog or Alert either, so there is no real/scripted fork to
 * make here, only RT_MAC_TEST/not. Fed by the answer-open/answer-save/
 * answer-changes/answer-cancel script verbs (rt_ui_run_scripted below).
 * Fixed 8-slot ring buffer (7 usable -- the full/empty ambiguity of a
 * head==tail ring is broken by never letting tail catch up to head, the
 * usual one-slot-sacrificed idiom): no script ever queues more than a
 * couple of dialogs ahead of where it consumes them, and a script that
 * DOES overflow this gets a loud rt_panic rather than silently clobbering
 * an unconsumed entry. */
#define RT_UI_ANS_OPEN    0
#define RT_UI_ANS_SAVE    1
#define RT_UI_ANS_CHANGES 2
#define RT_UI_ANS_CANCEL  3

typedef struct { short kind; short val; unsigned char str[256]; } rt_ui_answer;

static rt_ui_answer gAnswerQ[8];
static int gAnswerHead = 0; /* next entry to consume */
static int gAnswerTail = 0; /* next free slot to fill */

/* Shared full-check: called before every push (see call sites below) --
   both push functions write gAnswerQ[gAnswerTail] and must never do so
   when that slot is still the unconsumed head one ring-lap ahead. */
static void rt_ui_answer_check_room(void)
{
    if ((gAnswerTail + 1) % 8 == gAnswerHead) rt_panic("scripted dialog answer queue overflow");
}

static void rt_ui_answer_push_path(short kind, const char *path)
{
    rt_ui_answer *a;
    size_t n;

    rt_ui_answer_check_room();
    a = &gAnswerQ[gAnswerTail];
    n = strlen(path);
    if (n > 255) n = 255; /* Str255 cap, same silent clamp as every other Pascal-string fill in this file */
    a->kind = kind;
    a->str[0] = (unsigned char)n;
    memcpy(a->str + 1, path, n);
    gAnswerTail = (gAnswerTail + 1) % 8;
}

static void rt_ui_answer_push_val(short kind, short val)
{
    rt_ui_answer_check_room();
    gAnswerQ[gAnswerTail].kind = kind;
    gAnswerQ[gAnswerTail].val = val;
    gAnswerTail = (gAnswerTail + 1) % 8;
}

static const rt_ui_answer *rt_ui_answer_pop(void)
{
    const rt_ui_answer *a;

    if (gAnswerHead == gAnswerTail) rt_panic("scripted dialog with no queued answer");
    a = &gAnswerQ[gAnswerHead];
    gAnswerHead = (gAnswerHead + 1) % 8;
    return a;
}

/* `T ASKOPEN <path>` / `T ASKSAVE <path>` -- the queued path is a Pascal
   string (a->str); the trace line wants a plain C string, same
   byte-by-byte copy rt_ui_trace_about uses for its Pascal fields above. */
static void rt_ui_trace_ask_path(const char *verb, const unsigned char *pstr)
{
    char buf[300];
    int n, i, p;

    n = pstr[0];
    p = sprintf(buf, "T %s ", verb);
    for (i = 0; i < n && p < (int)sizeof(buf) - 1; i++) buf[p++] = (char)pstr[1 + i];
    buf[p] = '\0';
    rt_test_emit(buf);
}
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
/* Defined below, after widget creation (needs the TEHandle each widget owns)
   -- forward-declared here so rt_ui_layout (immediately below) can call it
   as the FIELD/TEXTVIEW counterpart to plain MoveControl/SizeControl. */
static void rt_ui_te_relayout(rt_ui_winst *inst, short wIdx);

/* Defined below (needs gMenuHandlerTable/gStdEditMenuIdx, both set up at
   startup) -- forward-declared here so rt_ui_te_set_focus (Task 3) can
   recompute standard-edit-item dimming right when TE focus changes WITHIN
   a window (the front-window-changed call sites already wrap this same
   call via rt_ui_after_front_change; a same-window focus switch has no
   front-window change to piggyback on, so it calls this directly). */
static void rt_ui_menu_recompute_dim(void);

static short rt_ui_kind_height(short kind)
{
    switch (kind) {
    case RTUI_BUTTON:   return RTUI_BUTTON_H;
    case RTUI_CHECK:    return RTUI_CHECK_H;
    case RTUI_LABEL:    return RTUI_LABEL_H;
    case RTUI_CANVAS:   return RTUI_CANVAS_H;
    case RTUI_FIELD:    return RTUI_FIELD_H;
    case RTUI_TEXTVIEW: return RTUI_TEXTVIEW_H;
    default:            return RTUI_CHECK_H;
    }
}

/* Natural-width fallback for a widget declared with no `width:` (or, for
   check/label/canvas, one that has no such property to give at all) -- see
   the RTUI_*_W constants' own comment just above. */
static short rt_ui_kind_width(short kind)
{
    switch (kind) {
    case RTUI_BUTTON:   return RTUI_BUTTON_W;
    case RTUI_CHECK:    return RTUI_CHECK_W;
    case RTUI_LABEL:    return RTUI_LABEL_W;
    case RTUI_CANVAS:   return RTUI_CANVAS_W;
    case RTUI_FIELD:    return RTUI_FIELD_W;
    case RTUI_TEXTVIEW: return RTUI_TEXTVIEW_W;
    default:            return RTUI_CHECK_W;
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
    GrafPtr savedPort;

    /* Self-assert/restore (rt_ui.h's PORT DISCIPLINE RULE): this function's
       own MoveControl/SizeControl calls don't care about the ambient port
       (same as NewControl, they take the control handle directly), but
       rt_ui_te_relayout's TECalText/TEScroll do -- same port-capture gap
       TENew's own fix (rt_ui_make_widgets) closed one layer up. Bracketing
       here (rather than at each of this function's three call sites --
       rt_ui_open, rt_ui_apply_resize, and any future one) covers all of
       them in one place. Neither existing caller was asserting this
       before: rt_ui_open calls rt_ui_layout AFTER rt_ui_make_widgets has
       already restored ITS OWN saved (pre-widget-creation) port, and
       rt_ui_apply_resize has no port handling of its own at all. */
    GetPort(&savedPort);
    SetPort(inst->wp);

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
        /* BUG FIX (Task 6, mac-target-4b): Ch8 says `fill: both` "stretch[es]
           a widget to fill remaining width, or both dimensions" -- i.e.
           fill:both implies width:fill too, not just a height override. A
           widget declared with `fill: both` alone (no separate `width:
           fill`) -- which is how every .cla source in this codebase spells
           it (see testdata/emitui/win_basic.cla's Board, every.cla's Board)
           -- lowers to a literal width of 0 (clarusc's default when no
           `width:` property is given), so without this fix the layout would
           size such a canvas to zero pixels wide. Fixed at the single place
           that computes layout for both hand-written (uiprobe, which
           happens to spell width explicitly as RTUI_FILL alongside
           RTUI_FILL_BOTH) and emitted descriptors, rather than duplicating
           the "fill:both implies width:fill" rule in clarusc's lowering
           too. */
        if (wd->width == RTUI_FILL || wd->fill == RTUI_FILL_BOTH) {
            w = (short)(contentW - x - RTUI_GAP);
        } else if (wd->width == 0) {
            w = rt_ui_kind_width(wd->kind); /* no `width:` given (or none exists for this kind) -- see RTUI_*_W's comment */
        } else {
            w = wd->width;
        }
        if (w < 0) w = 0;
        if (wd->fill == RTUI_FILL_BOTH) {
            h = (short)(contentH - y - RTUI_GAP);
            if (h < 0) h = 0;
        }

        SetRect(&inst->rects[i], x, y, (short)(x + w), (short)(y + h));
        if (wd->kind == RTUI_FIELD || wd->kind == RTUI_TEXTVIEW) {
            /* Derives the TE view/dest rect (and, for a textview, moves/
               sizes its own scrollbar control) from inst->rects[i] just
               set above -- covers both the initial layout and any later
               resize re-layout (rt_ui_apply_resize calls this same
               function), so there is no separate resize-path duplicate. */
            rt_ui_te_relayout(inst, i);
        } else if (inst->ctrls[i]) {
            MoveControl(inst->ctrls[i], x, y);
            SizeControl(inst->ctrls[i], w, h);
        }

        prevLeft = x;
        prevRight = (short)(x + w);
        prevBottom = (short)(y + h);
    }
    SetPort(savedPort);
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
    GrafPtr savedPort;
    short i;

    d = inst->desc;
    /* NewControl takes `inst->wp` explicitly and doesn't care about the
       ambient port, which is why button/check/label never needed this --
       but TENew has no window parameter at all: it captures whatever port
       is CURRENT at the moment it's called as the TE's own inPort, and
       nothing upstream of rt_ui_open actually guarantees inst->wp is
       current by this point (NewWindow does NOT make the new window the
       current port -- an earlier assumption in this file that turned out
       to be false, caught by TextEdit's own inPort bookkeeping rather than
       any control-position symptom, since controls never depended on it).
       Self-assert/restore here, the one place in this function that
       actually needs it. */
    GetPort(&savedPort);
    SetPort(inst->wp);
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
        case RTUI_FIELD:
            /* `label:` reuses the labels[]/TETextBox lane RTUI_LABEL already
               has (drawn in rt_ui_handle_update); the field itself is a TE,
               not a Control Manager widget, same as label/canvas. */
            inst->ctrls[i] = NULL;
            rt_ui_pstrcpy(inst->labels[i], cap);
            inst->tes[i] = TENew(&placeholder, &placeholder);
            break;
        case RTUI_TEXTVIEW:
            inst->tes[i] = TENew(&placeholder, &placeholder);
            if (wd->flags & RTUI_SCROLL_V) {
                inst->ctrls[i] = NewControl(inst->wp, &placeholder, kEmptyPStr,
                                             (Boolean)1, 0, 0, 0, scrollBarProc, 0L);
                /* High bit tags this control as a textview's scrollbar (not
                   a plain widget index) for rt_ui_handle_content_click and
                   the scrollbar action proc to tell apart from FindControl's
                   result -- set directly here rather than via the generic
                   "if (inst->ctrls[i]) contrlRfCon = i" below, which this
                   case skips (see that line's own guard). */
                (*inst->ctrls[i])->contrlRfCon = (long)(0x8000 | i);
            } else {
                inst->ctrls[i] = NULL;
            }
            if (wd->flags & RTUI_SCROLL_H) {
                (*inst->tes[i])->crOnly = -1; /* no word wrap: lines break only at CR */
                inst->hbars[i] = NewControl(inst->wp, &placeholder, kEmptyPStr,
                                             (Boolean)1, 0, 0, 0, scrollBarProc, 0L);
                (*inst->hbars[i])->contrlRfCon = (long)(0xC000L | i);
            } else {
                inst->hbars[i] = NULL;
            }
            break;
        default: /* RTUI_LABEL, RTUI_CANVAS: no Control Manager backing */
            inst->ctrls[i] = NULL;
            rt_ui_pstrcpy(inst->labels[i], cap);
            break;
        }
        if (inst->ctrls[i] && wd->kind != RTUI_TEXTVIEW) (*inst->ctrls[i])->contrlRfCon = i;
    }
    SetPort(savedPort);
}

/* ==================== TextEdit field/textview widgets (mac-target-4c Task 1) ====================
 * A field or textview's `tes[i]` is a real TEHandle; layout derives its
 * view/dest rect from the widget's own laid-out rect (rt_ui_te_relayout,
 * called from rt_ui_layout for both the initial open and any resize
 * re-layout); every content mutation (typing, cut/paste/clear, `set_str`/
 * `set_text`) funnels through rt_ui_te_mutated, the ONE hook that clamps to
 * the kind's text cap and recomputes the scrollbar (if any) -- always, for
 * both funnel branches. Its `userEdit` flag (final review fix, mac-target-4c)
 * splits the two: a USER edit (typing, cut, paste, clear -- the caller
 * passes 1) additionally traces `T FIRE <Win>.<W>.change` and fires
 * RTUI_WEV_CHANGE; a PROGRAMMATIC set (`set_str`'s FIELD branch, `set_text`
 * -- the caller passes 0) does neither, matching every OTHER widget kind's
 * runtime property setter (rt_ui_widget_set_bool/set_str's LABEL/BUTTON
 * branches never fire their own event either) and making the reference's
 * own `on Body.change { dirty = true }` + openPath idiom (Ch8/Appendix C)
 * behave: a freshly opened document's programmatic Body.text fill must NOT
 * mark it dirty. Fires once per call, not coalesced, when it does fire (the
 * plan's pinned policy: a single TEKey keystroke is one `change`, regardless
 * of whether the byte count actually moved). */

/* Recomputes a textview's scrollbar range(s) from its current content and
   pins each control's value to its TE's *actual* view/dest offset -- called
   after every layout change and every content mutation. A no-op for a
   field (no scrollbar) or a textview declared without RTUI_SCROLL_V/H
   (ctrls[wIdx]/hbars[wIdx] is NULL either way). Deriving value-from-offset
   (rather than only clamping the control's OLD value downward) matters
   because relayout resets destRect to the view origin: after any resize
   the old clamp-only code could leave a thumb pointing at a scroll
   position the TE no longer had. If the derived offset exceeds the new
   max, scrolls the TE back into view (TEScroll) rather than leaving it
   showing blank space past the new end. */
static void rt_ui_te_scroll_sync(rt_ui_winst *inst, short wIdx)
{
    TEHandle te;
    ControlHandle sb, hb;
    short viewH, contentH, maxScroll, offset;

    te = inst->tes[wIdx];
    if (!te) return;
    sb = inst->ctrls[wIdx];
    hb = inst->hbars[wIdx];
    if (sb) {
        viewH = (short)((*te)->viewRect.bottom - (*te)->viewRect.top);
        contentH = (short)((*te)->nLines * (*te)->lineHeight);
        maxScroll = (short)(contentH - viewH);
        if (maxScroll < 0) maxScroll = 0;
        SetControlMaximum(sb, maxScroll);
        offset = (short)((*te)->viewRect.top - (*te)->destRect.top);
        if (offset > maxScroll) {
            TEScroll(0, (short)(offset - maxScroll), te); /* positive dv: content back down */
            offset = maxScroll;
        }
        SetControlValue(sb, offset);
    }
    if (hb) {
        short viewW, destW;

        viewW = (short)((*te)->viewRect.right - (*te)->viewRect.left);
        destW = (short)((*te)->destRect.right - (*te)->destRect.left);
        maxScroll = (short)(destW - viewW);
        if (maxScroll < 0) maxScroll = 0;
        SetControlMaximum(hb, maxScroll);
        offset = (short)((*te)->viewRect.left - (*te)->destRect.left);
        if (offset > maxScroll) {
            TEScroll((short)(offset - maxScroll), 0, te);
            offset = maxScroll;
        }
        SetControlValue(hb, offset);
    }
}

/* Enforces the kind's text cap (255 for a field's Str255-shaped text, the
   plan's RTUI_TE_MAX for a textview's rt_text) after any mutation that
   could have grown content past it (TEKey typing; set_str/set_text are
   already within-cap by construction -- see their own comments -- so this
   is a cheap early-return no-op for them). Preserves the caret/selection
   start, clamped into range, same as any other truncating edit.
   Disclosed limitation: truncation always keeps bytes [0, maxLen) and
   drops the END of the buffer -- correct when the just-typed character IS
   the one that pushed teLength over maxLen (the caret is normally at the
   end), but if the caret is NOT at the end (e.g. after TESetSelect moved
   it, or a future paste-in-the-middle), the byte actually dropped is the
   buffer's last byte, not the one just typed at the caret. No scenario in
   this task exercises typing away from the end while already at the cap,
   so this hasn't been observed in practice; a real fix would need to
   delete the character at/after the caret rather than truncate the tail. */
static void rt_ui_te_clamp(TEHandle te, short maxLen)
{
    CharsHandle th;
    short sel;

    if ((*te)->teLength <= maxLen) return;
    th = TEGetText(te);
    HLock((Handle)th);
    TESetText(*th, maxLen, te);
    HUnlock((Handle)th);
    sel = (*te)->selStart;
    if (sel > maxLen) sel = maxLen;
    TESetSelect(sel, sel, te);
    rt_set_lasterr(1, "string truncated");
}

/* The one mutation funnel every field/textview content change routes
   through (TEKey below; rt_ui_widget_set_str's FIELD branch and
   rt_ui_widget_set_text, further down). `userEdit` is 1 for a real user
   action (TEKey typing, standard-edit Cut/Paste/Clear) and 0 for a
   programmatic set (set_str/set_text) -- see this section's own header
   comment just above for why the two must diverge past the shared
   clamp/scroll-sync. */
static void rt_ui_te_mutated(rt_ui_winst *inst, short wIdx, int userEdit)
{
    const rt_ui_widget_desc *wd;
    TEHandle te;

    wd = &inst->desc->widgets[wIdx];
    te = inst->tes[wIdx];
    if (te) rt_ui_te_clamp(te, (short)(wd->kind == RTUI_FIELD ? RTUI_FIELD_TEXT_MAX : RTUI_TE_MAX));
    rt_ui_te_scroll_sync(inst, wIdx);
    if (!userEdit) return; /* programmatic set: clamp + scroll-sync only, no trace/event -- see header comment */
#ifdef RT_MAC_TEST
    rt_ui_trace_fire2(inst->desc->name, wd->name, "change");
#endif
    if (inst->desc->handlers && inst->desc->handlers->widget)
        inst->desc->handlers->widget(inst, wIdx, RTUI_WEV_CHANGE, 0, 0);
}

/* Derives widget i's TE view/dest rect (and, for a textview, its
   scrollbar's rect) from inst->rects[i], already SetRect by the caller
   (rt_ui_layout) -- see that function's own comment. TENew has no "move"
   call of its own; TERec's destRect/viewRect are plain fields, the
   documented way to reposition one (Inside Macintosh's own TESample does
   the same), followed by TECalText to re-wrap against the new width. */
static void rt_ui_te_relayout(rt_ui_winst *inst, short i)
{
    const rt_ui_widget_desc *wd;
    TEHandle te;
    Rect box, teRect, sbRect, frame;

    wd = &inst->desc->widgets[i];
    te = inst->tes[i];
    if (!te) return;
    /* The frame border (FrameRect of viewRect outset by RTUI_TE_FRAME_INSET,
       drawn directly by the update handler) isn't self-maintaining the way
       a Control's own MoveControl/SizeControl is: when a relayout (a
       resize/grow, real or scripted) moves it, the OLD border's painted
       pixels just sit there as garbage otherwise -- SizeWindow only
       auto-invalidates the newly-exposed margin, never the interior a
       relayout moved widgets within, and InvalRect alone only marks a
       region eligible for the NEXT paint call that happens to touch it;
       it doesn't erase anything itself (FrameRect draws a one-pixel
       outline, not a filled erase-then-frame). EraseRect the old position
       right now (before it's overwritten below), matching the same
       erase-before-resize idiom rt_ui_apply_zoom already uses for the
       whole window; InvalRect the new position at the bottom of this
       function so the update handler's FrameRect/TEUpdate actually runs
       there. A harmless no-op-ish erase the first time a widget is laid
       out (viewRect is still TENew's zero placeholder). */
    frame = (*te)->viewRect;
    InsetRect(&frame, -RTUI_TE_FRAME_INSET, -RTUI_TE_FRAME_INSET);
    EraseRect(&frame);
    box = inst->rects[i];
    if (wd->kind == RTUI_FIELD && inst->labels[i][0] > 0)
        box.left = (short)(box.left + RTUI_FIELD_LABEL_W);
    teRect = box;
    if (wd->kind == RTUI_TEXTVIEW) {
        Boolean hasV, hasH;

        hasV = inst->ctrls[i] != NULL;
        hasH = inst->hbars[i] != NULL;
        if (hasV) {
            /* stops RTUI_SCROLLBAR_W short of the bottom when an H bar
               shares the corner -- the standard grow-notch square */
            SetRect(&sbRect, (short)(box.right - RTUI_SCROLLBAR_W), box.top,
                    box.right, (short)(box.bottom - (hasH ? RTUI_SCROLLBAR_W : 0)));
            MoveControl(inst->ctrls[i], sbRect.left, sbRect.top);
            SizeControl(inst->ctrls[i], (short)(sbRect.right - sbRect.left),
                        (short)(sbRect.bottom - sbRect.top));
            teRect.right = (short)(teRect.right - RTUI_SCROLLBAR_W);
        }
        if (hasH) {
            SetRect(&sbRect, box.left, (short)(box.bottom - RTUI_SCROLLBAR_W),
                    (short)(box.right - (hasV ? RTUI_SCROLLBAR_W : 0)), box.bottom);
            MoveControl(inst->hbars[i], sbRect.left, sbRect.top);
            SizeControl(inst->hbars[i], (short)(sbRect.right - sbRect.left),
                        (short)(sbRect.bottom - sbRect.top));
            teRect.bottom = (short)(teRect.bottom - RTUI_SCROLLBAR_W);
        }
    }
    InsetRect(&teRect, RTUI_TE_FRAME_INSET, RTUI_TE_FRAME_INSET);
    if (teRect.right < teRect.left) teRect.right = teRect.left;
    if (teRect.bottom < teRect.top) teRect.bottom = teRect.top;
    (*te)->viewRect = teRect;
    (*te)->destRect = teRect;
    if (wd->kind == RTUI_TEXTVIEW && inst->hbars[i])
        (*te)->destRect.right = (short)(teRect.left + RTUI_TE_NOWRAP_W);
    TECalText(te);
    rt_ui_te_scroll_sync(inst, i);
    frame = teRect;
    InsetRect(&frame, -RTUI_TE_FRAME_INSET, -RTUI_TE_FRAME_INSET);
    InvalRect(&frame);
}

/* Click-to-focus (Behavior contract: "one focused TE per window"):
   TEDeactivate's the previously focused TE (if any) and TEActivate's the
   new one. A no-op when the click lands on the already-focused TE. */
static void rt_ui_te_set_focus(rt_ui_winst *inst, short newIdx)
{
    if (inst->focusIdx == newIdx) return;
    if (inst->focusIdx >= 0 && inst->tes[inst->focusIdx]) TEDeactivate(inst->tes[inst->focusIdx]);
    inst->focusIdx = newIdx;
    if (inst->focusIdx >= 0 && inst->tes[inst->focusIdx]) TEActivate(inst->tes[inst->focusIdx]);
    /* Standard-edit Cut/Copy/Paste/Clear dim on "does the front window have
       a focused TE" (Task 3) -- a no-op when no standard-edit menu exists
       (rt_ui_menu_recompute_dim's dedicated block below is gated on
       gStdEditMenuIdx >= 0), so this costs nothing for every pre-existing
       scenario. */
    rt_ui_menu_recompute_dim();
}

/* Hit-tests against each FIELD/TEXTVIEW's own (already-derived) TE
   viewRect -- not the widget's full outer box -- so a click on a field's
   label lane or a textview's scrollbar lane (handled separately via
   FindControl) never focuses the TE. `local` is window-local, same
   convention rt_ui_canvas_hit already uses. */
static int rt_ui_te_hit(rt_ui_winst *inst, Point local, short *outIdx)
{
    short i;
    for (i = 0; i < inst->desc->nWidgets; i++) {
        short k = inst->desc->widgets[i].kind;
        if ((k == RTUI_FIELD || k == RTUI_TEXTVIEW) && inst->tes[i] &&
            PtInRect(local, &(*inst->tes[i])->viewRect)) {
            *outIdx = i;
            return 1;
        }
    }
    return 0;
}

/* Continuous scroll-button/page-button tracking (TrackControl's actionProc,
   called repeatedly while the mouse stays down over an arrow/page part --
   never called for inThumb, which TrackControl tracks live on its own).
   Looks up the owning window via the control's own contrlOwner since an
   action proc only receives the ControlHandle. */
static pascal void rt_ui_scrollbar_action(ControlHandle ctrl, short part)
{
    rt_ui_winst *inst;
    short wIdx, step;
    TEHandle te;
    long rfCon;
    Boolean horiz;

    if (part == 0) return;
    inst = rt_ui_winst_of((*ctrl)->contrlOwner);
    if (!inst) return;
    rfCon = (*ctrl)->contrlRfCon;
    horiz = (rfCon & 0x4000L) != 0;
    wIdx = (short)(rfCon & 0x3FFFL);
    te = inst->tes[wIdx];
    if (!te) return;
    if (horiz) {
        short viewW;

        viewW = (short)((*te)->viewRect.right - (*te)->viewRect.left);
        switch (part) {
        case kControlUpButtonPart:   step = (short)-RTUI_HSCROLL_STEP; break; /* left arrow */
        case kControlDownButtonPart: step = RTUI_HSCROLL_STEP; break;         /* right arrow */
        case kControlPageUpPart:     step = (short)-viewW; break;
        case kControlPageDownPart:   step = viewW; break;
        default: return;
        }
    } else {
        short lineH, viewH;

        lineH = (*te)->lineHeight;
        if (lineH <= 0) lineH = 1;
        viewH = (short)((*te)->viewRect.bottom - (*te)->viewRect.top);
        switch (part) {
        case kControlUpButtonPart:   step = (short)-lineH; break;
        case kControlDownButtonPart: step = lineH; break;
        case kControlPageUpPart:     step = (short)-viewH; break;
        case kControlPageDownPart:   step = viewH; break;
        default: return;
        }
    }
    {
        short oldVal, newVal, maxVal, applied;
        oldVal = GetControlValue(ctrl);
        maxVal = GetControlMaximum(ctrl);
        newVal = (short)(oldVal + step);
        if (newVal < 0) newVal = 0;
        if (newVal > maxVal) newVal = maxVal;
        applied = (short)(oldVal - newVal);
        if (applied == 0) return;
        SetControlValue(ctrl, newVal);
        if (horiz) TEScroll(applied, 0, te);
        else       TEScroll(0, applied, te);
    }
}

/* FindControl resolved a click to a textview's scrollbar (contrlRfCon's
   high bit set, see rt_ui_make_widgets) -- dispatched separately from an
   ordinary widget control (rt_ui_handle_content_click), since a scrollbar
   click never fires a widget event, only scrolls its TE. */
static void rt_ui_handle_scrollbar_click(rt_ui_winst *inst, ControlHandle ctrl, short wIdx, short cpart, Point where)
{
#ifdef RT_MAC_TEST
    if (gUiScripted) {
        /* No real mouse to hold an arrow down or drag the thumb (the same
           reason button clicks bypass TrackControl in scripted mode, see
           rt_ui_handle_content_click) -- a script `click` on a scrollbar
           part is one discrete nudge via the same action routine real
           tracking calls once per part hit. Thumb clicks aren't
           meaningfully scriptable (no drag distance) and are a no-op here;
           no scenario exercises them yet. */
        if (cpart == kControlUpButtonPart || cpart == kControlDownButtonPart ||
            cpart == kControlPageUpPart || cpart == kControlPageDownPart)
            rt_ui_scrollbar_action(ctrl, cpart);
        return;
    }
#endif
    if (cpart == kControlIndicatorPart) {
        short oldVal, newVal;
        Boolean horiz;

        horiz = ((*ctrl)->contrlRfCon & 0x4000L) != 0;
        oldVal = GetControlValue(ctrl);
        if (TrackControl(ctrl, where, NULL) != 0) {
            newVal = GetControlValue(ctrl);
            if (newVal != oldVal && inst->tes[wIdx]) {
                if (horiz) TEScroll((short)(oldVal - newVal), 0, inst->tes[wIdx]);
                else       TEScroll(0, (short)(oldVal - newVal), inst->tes[wIdx]);
            }
        }
    } else {
        TrackControl(ctrl, where, NewControlActionUPP(rt_ui_scrollbar_action));
    }
}

/* TEIdle blinks the caret; called once per real event-loop iteration and
   once per scripted `tick` (Behavior contract) for the FRONTMOST window's
   focused TE only -- background windows never blink a caret, same
   convention any classic Mac app follows. */
static void rt_ui_te_idle_front(void)
{
    WindowPtr wp;
    rt_ui_winst *inst;
    GrafPtr saved;

    wp = FrontWindow();
    inst = rt_ui_winst_of(wp);
    if (!inst || inst->focusIdx < 0 || !inst->tes[inst->focusIdx]) return;
    GetPort(&saved);
    SetPort(wp);
    TEIdle(inst->tes[inst->focusIdx]);
    SetPort(saved);
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

/* `standard edit` (Ch9, mac-target-4c Task 3): which declared menu (0-based,
   same indexing as gMenuHandles) is the standard-edit one, -1 if the
   program declares none. Accept-first if a program somehow declares more
   than one -- ponytail: one standard-edit menu per program is the only
   case the reference's own example shows, so the second and later ones
   just build their fixed Undo/Cut/Copy/Paste/Clear items (rt_ui_build_menus
   still gives every one of them the real menu items and the disabled
   Undo) but are never the dispatch/dim target; revisit with a per-menu
   flag array if a program ever needs more than one wired up. */
static short gStdEditMenuIdx = -1;
#ifdef RT_MAC_TEST
static const char *gStdEditMenuName = NULL; /* for T DIM trace lines */
static char gStdEditDimPrev = 0;            /* last computed on/off, valid once !gDimFirst */
#endif

#define RTUI_APPLE_MENU_ID 1

/* Ch9: "The Apple menu and its About item are provided by the runtime
   automatically; no declaration is needed." Standard System 6 shape: an
   About item, a separator, then the desk-accessory list. Inserted before
   the declared menus so it lands leftmost in the bar.
   Without an `app` section (rt_ui_app_info.name empty, the weak default),
   the About item stays "About This Application" and selecting it shows the
   name-only ALRT 128 / DITL "^0" resource rt_mac.c's own rt_alert uses,
   substituting the app's name instead of an error message. WITH an `app`
   section (Task 2's strong rt_ui_app_info), the item instead reads
   "About <name>..." and selecting it shows the richer ALRT 129 (name,
   version, author, about via ParamText's four ^0-^3 substitutions) --
   see rt_ui_apple_select below. */
static void rt_ui_build_apple_menu(void)
{
    gAppleMenu = NewMenu(RTUI_APPLE_MENU_ID, (const unsigned char *)"\p\024");
    if (rt_ui_app_info.name[0] != 0) {
        /* "About <name>..." -- same buf/fix-up-the-count-byte idiom as the
           /K cmd-key append above (:673-684), just appending a literal
           prefix and suffix around the name's own bytes instead of a `/K`
           pair. Pascal chars live in buf[1..n], so appending the name means
           copying ONLY its characters into buf[1+n .. n+len] -- rt_ui_pstrcpy
           can't be reused here as a shortcut the way the /K case doesn't
           need to: calling it on buf+n would write name's own count byte
           into buf[n], clobbering the prefix's last character (the trailing
           space) instead of landing in a free slot. BlockMoveData copies
           just the characters, leaving n (still "About "'s length, 6) to
           advance by name's length by hand. Worked example: prefix 6 +
           name "Mandelbrot" (10) -> chars 1-6 "About ", 7-16 "Mandelbrot",
           17 ellipsis, count byte (buf[0]) 17. Two of the same disclosed
           limitations as the /K case still apply: not escaped against
           AppendMenu metacharacters (;/!<() -- the app's name isn't
           expected to contain any -- and the Pascal count byte wraps
           (silently) rather than truncates if "About " + name + the
           ellipsis exceeds 255 bytes. */
        unsigned char buf[264]; /* 255-byte Str255 name + "About " (6) + ellipsis (1) + count byte */
        unsigned char n;
        rt_ui_pstrcpy(buf, (const unsigned char *)"\pAbout ");
        n = buf[0]; /* 6: prefix occupies buf[1..6], buf[6] is its trailing space */
        BlockMoveData((Ptr)(rt_ui_app_info.name + 1), (Ptr)(buf + 1 + n), rt_ui_app_info.name[0]);
        n = (unsigned char)(n + rt_ui_app_info.name[0]);
        buf[1 + n] = (unsigned char)0xC9; /* MacRoman ellipsis */
        buf[0] = (unsigned char)(n + 1);
        AppendMenu(gAppleMenu, buf);
        AppendMenu(gAppleMenu, (const unsigned char *)"\p-");
    } else {
        AppendMenu(gAppleMenu, (const unsigned char *)"\pAbout This Application;-");
    }
    AppendResMenu(gAppleMenu, 'DRVR');
    InsertMenu(gAppleMenu, 0);
}

static void rt_ui_apple_select(short itemNum)
{
    if (itemNum == 1) {
        if (rt_ui_app_info.name[0] != 0) {
#ifdef RT_MAC_TEST
            rt_ui_trace_about();   /* modal Alert would block the script reader */
#else
            ParamText(rt_ui_app_info.name, rt_ui_app_info.version,
                      rt_ui_app_info.author, rt_ui_app_info.about);
            Alert(129, NULL);      /* plain Alert: never draws a system icon */
#endif
        } else {
            ParamText(LMGetCurApName(), (const unsigned char *)"\p",
                      (const unsigned char *)"\p", (const unsigned char *)"\p");
            NoteAlert(128, NULL);
        }
        return;
    }
    {
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
        if (md->standardEdit) {
            /* Fixed Ch9 shape: Undo (permanently disabled -- no undo stack,
               a disclosed limitation), separator, Cut/Copy/Paste (cmd-key
               via AppendMenu's `/K` metachar, same idiom the generic item
               loop below uses dynamically -- these four captions/keys are
               compile-time fixed, so a literal Pascal string is simpler),
               Clear (no standard cmd-key equivalent). */
            AppendMenu(mh, (const unsigned char *)"\pUndo/Z");
            AppendMenu(mh, (const unsigned char *)"\p-");
            AppendMenu(mh, (const unsigned char *)"\pCut/X");
            AppendMenu(mh, (const unsigned char *)"\pCopy/C");
            AppendMenu(mh, (const unsigned char *)"\pPaste/V");
            AppendMenu(mh, (const unsigned char *)"\pClear");
            DisableItem(mh, 1); /* Undo: permanently dimmed */
            if (gStdEditMenuIdx < 0) {
                gStdEditMenuIdx = i;
#ifdef RT_MAC_TEST
                gStdEditMenuName = md->name;
#endif
            }
            InsertMenu(mh, 0);
            gMenuHandles[i] = mh;
            continue;
        }
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

/* ==================== dialogs (Ch12: Task 4) ====================
 * askOpen/askSave/askSaveChanges. A real build shows Standard File's
 * SFGetFile/SFPutFile (fixed {100,100} corner -- System 6 has no
 * auto-center convention, unlike {-1,-1} on later systems) or a
 * ParamText+Alert(130) three-way confirmation; a RT_MAC_TEST build
 * consumes the scripted answer queue above instead of any of that (see
 * its own header comment for why). SetVol(NULL, reply.vRefNum) after a
 * good SFGetFile/SFPutFile makes the picked file's volume the DEFAULT
 * volume, so the plain (vRefNum-0) path rt_file_read_text/rt_file_write_text
 * hand FSOpen/Create resolves correctly afterward -- RT_MAC_TEST paths
 * skip this entirely and are used as-is on the boot volume, per the
 * plan. */

int rt_ui_ask_open(unsigned char *path255)
{
#ifdef RT_MAC_TEST
    const rt_ui_answer *a;

    a = rt_ui_answer_pop();
    if (a->kind == RT_UI_ANS_CANCEL) {
        rt_test_emit("T ASKOPEN cancel");
        return 0;
    }
    if (a->kind != RT_UI_ANS_OPEN) rt_panic("askOpen: scripted answer kind mismatch");
    rt_ui_pstrcpy(path255, a->str);
    rt_ui_trace_ask_path("ASKOPEN", a->str);
    return 1;
#else
    Point where;
    SFTypeList types;
    SFReply reply;

    where.h = 100;
    where.v = 100;
    types[0] = 'TEXT';
    SFGetFile(where, (const unsigned char *)"\p", NULL, 1, types, NULL, &reply);
    if (!reply.good) return 0;
    SetVol(NULL, reply.vRefNum);
    rt_ui_pstrcpy(path255, reply.fName);
    return 1;
#endif
}

int rt_ui_ask_save(unsigned char *path255, const unsigned char *suggested)
{
#ifdef RT_MAC_TEST
    const rt_ui_answer *a;

    a = rt_ui_answer_pop();
    if (a->kind == RT_UI_ANS_CANCEL) {
        rt_test_emit("T ASKSAVE cancel");
        return 0;
    }
    if (a->kind != RT_UI_ANS_SAVE) rt_panic("askSave: scripted answer kind mismatch");
    rt_ui_pstrcpy(path255, a->str);
    rt_ui_trace_ask_path("ASKSAVE", a->str);
    return 1;
#else
    Point where;
    SFReply reply;

    where.h = 100;
    where.v = 100;
    SFPutFile(where, (const unsigned char *)"\pSave as:", suggested, NULL, &reply);
    if (!reply.good) return 0;
    SetVol(NULL, reply.vRefNum);
    rt_ui_pstrcpy(path255, reply.fName);
    return 1;
#endif
}

short rt_ui_ask_save_changes(const unsigned char *name)
{
#ifdef RT_MAC_TEST
    const rt_ui_answer *a;
    char buf[32];

    a = rt_ui_answer_pop();
    if (a->kind != RT_UI_ANS_CHANGES) rt_panic("askSaveChanges: scripted answer kind mismatch");
    sprintf(buf, "T ASKCHANGES %s", a->val == 0 ? "save" : (a->val == 1 ? "discard" : "cancel"));
    rt_test_emit(buf);
    return a->val;
#else
    short item;

    ParamText(name, (const unsigned char *)"\p", (const unsigned char *)"\p", (const unsigned char *)"\p");
    item = Alert(130, NULL);
    return (short)(item - 1); /* item 1/2/3 -> Save/Discard/Cancel 0/1/2 */
#endif
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
    /* Standard-edit menu (Ch9 `standard edit`, Task 3): Cut/Copy/Paste/
       Clear (itemIdx 2-5) dim together, on iff the frontmost window is
       ours AND has a focused field/textview. No gMenuHandlerTable entry
       exists for these (the runtime, not the program, owns them), so they
       get their own prev/trace bookkeeping instead of a loop slot above.
       Undo (itemIdx 0) is untouched here -- disabled once at build time,
       never re-enabled. */
    if (gStdEditMenuIdx >= 0) {
        rt_ui_winst *front;
        int on;
        short j;

        front = rt_ui_winst_of(FrontWindow());
        on = front != NULL && front->focusIdx >= 0;
        for (j = 2; j <= 5; j++) rt_ui_menu_enable(gStdEditMenuIdx, j, on);
#ifdef RT_MAC_TEST
        if (!gDimFirst && gStdEditDimPrev != (char)on) {
            static const char *kStdEditItems[4] = { "Cut", "Copy", "Paste", "Clear" };
            short m;
            for (m = 0; m < 4; m++) rt_ui_trace_dim(gStdEditMenuName, kStdEditItems[m], on);
        }
        gStdEditDimPrev = (char)on;
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

/* Ch9 `standard edit`'s dispatch (Task 3): itemIdx is 0-based, matching the
   fixed layout rt_ui_build_menus appended above (0=Undo, 1=separator,
   2=Cut, 3=Copy, 4=Paste, 5=Clear). DA-frontmost check FIRST: SystemEdit's
   own editCmd convention (0=undo, 2=cut, 3=copy, 4=paste, 5=clear -- item 1
   is the separator, never passed to SystemEdit) is on the SAME numeric
   scale as this function's itemIdx (both skip 1 the same way), so no
   translation is needed; a previous revision of this comment mis-stated
   SystemEdit's numbering as 0/1/2/3/4 -- the CODE was always correct, only
   the parenthetical lied. Otherwise acts on the front rt_ui window's
   focused field/textview, if any -- native dimming ordinarily keeps a real
   click/cmd-key from reaching here with Undo selected or nothing focused,
   but a scripted `menu M I` call (rt_ui_script_menu) bypasses that gate by
   calling rt_ui_menu_dispatch directly, so both are guarded defensively
   here too: Undo/the separator fall out silently, no focused TE is a
   silent no-op. Cut/Paste/Clear route their TE mutation through
   rt_ui_te_mutated as a USER edit (change trace/event + clamp + scrollbar
   sync, same funnel typing and set_text use, `userEdit`=1 -- final review
   fix, mac-target-4c: see that function's own header comment); Copy does
   not mutate, so it fires no change event/trace at all (pinned: Copy is
   observably silent). PORT DISCIPLINE RULE (rt_ui.h): self-asserts/
   restores the port around the TE calls, which draw. */
static void rt_ui_std_edit_dispatch(short itemIdx)
{
    rt_ui_winst *inst;
    TEHandle te;
    GrafPtr savedPort;

    if (!rt_ui_is_ours(FrontWindow())) {
        SystemEdit(itemIdx);
        return;
    }
    if (itemIdx < 2 || itemIdx > 5) return; /* Undo (permanently disabled) or the separator */
    inst = rt_ui_winst_of(FrontWindow());
    if (!inst || inst->focusIdx < 0) return;
    te = inst->tes[inst->focusIdx];
    if (!te) return;
    GetPort(&savedPort);
    SetPort(inst->wp);
    switch (itemIdx) {
    case 2: /* Cut */
        TECut(te);
        ZeroScrap();
        TEToScrap();
        rt_ui_te_mutated(inst, inst->focusIdx, 1);
        break;
    case 3: /* Copy: no mutation -- no change trace/event (pinned) */
        TECopy(te);
        ZeroScrap();
        TEToScrap();
        break;
    case 4: /* Paste (final review fix, mac-target-4c): guarded against a
               TEXTVIEW overflow BEFORE calling TEPaste at all -- teLength
               is a `short`, so pasting enough scrap to push it past 32,767
               wraps NEGATIVE, and rt_ui_te_clamp's `<= maxLen` check then
               waves the (apparently-tiny-or-negative) length straight
               through uncaught, corrupting the TE. Computing newLen as a
               `long` BEFORE the paste lands catches this while it's still
               exact, and skips the paste entirely (no partial insert) --
               same rt_set_lasterr code/message family as rt_ui_te_clamp's
               own truncation report. A FIELD's own post-paste clamp is
               left alone: Str255's 255-byte structural cap can never
               approach the short-overflow hazard a 32,000-byte textview
               can. */
        TEFromScrap();
        {
            long newLen = (long)(*te)->teLength - ((*te)->selEnd - (*te)->selStart) + TEGetScrapLength();
            if (inst->desc->widgets[inst->focusIdx].kind == RTUI_TEXTVIEW && newLen > RTUI_TE_MAX) {
                rt_set_lasterr(1, "string truncated");
            } else {
                TEPaste(te);
                rt_ui_te_mutated(inst, inst->focusIdx, 1);
            }
        }
        break;
    case 5: /* Clear */
        TEDelete(te);
        rt_ui_te_mutated(inst, inst->focusIdx, 1);
        break;
    }
    SetPort(savedPort);
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
    if (menuIdx == gStdEditMenuIdx) {
        rt_ui_std_edit_dispatch(itemIdx);
        return;
    }
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
        if (inst->desc->resizable) {
            Rect corner;
            RgnHandle saveClip;

            corner = wp->portRect;
            corner.left = (short)(corner.right - RTUI_SCROLLBAR_W);
            corner.top = (short)(corner.bottom - RTUI_SCROLLBAR_W);
            saveClip = NewRgn();
            GetClip(saveClip);
            ClipRect(&corner); /* corner only: widgets are inset from the window edge, the full-edge lane lines would cut through them */
            DrawGrowIcon(wp);
            SetClip(saveClip);
            DisposeRgn(saveClip);
        }
        for (i = 0; i < inst->desc->nWidgets; i++) {
            const rt_ui_widget_desc *wd;
            wd = &inst->desc->widgets[i];
            if (wd->kind == RTUI_LABEL) {
                unsigned char *s;
                s = inst->labels[i];
                TETextBox(s + 1, s[0], &inst->rects[i], teJustLeft);
            } else if (wd->kind == RTUI_FIELD || wd->kind == RTUI_TEXTVIEW) {
                /* Field/textview draw a frame around their TE view (un-
                   insetting rt_ui_te_relayout's own inset gives back
                   exactly the box that inset came from -- see that
                   function), then TEUpdate for the text/caret itself; a
                   field additionally draws its `label:` lane the same
                   TETextBox way RTUI_LABEL does, just narrower. */
                TEHandle te = inst->tes[i];
                if (te) {
                    Rect frame = (*te)->viewRect;
                    InsetRect(&frame, -RTUI_TE_FRAME_INSET, -RTUI_TE_FRAME_INSET);
                    FrameRect(&frame);
                    TEUpdate(&(*te)->viewRect, te);
                }
                if (wd->kind == RTUI_FIELD && inst->labels[i][0] > 0) {
                    Rect labelRect;
                    unsigned char *s;
                    labelRect = inst->rects[i];
                    labelRect.right = (short)(labelRect.left + RTUI_FIELD_LABEL_W - 4);
                    s = inst->labels[i];
                    TETextBox(s + 1, s[0], &labelRect, teJustLeft);
                }
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
   needs handling here. Deactivating always dims regardless of an
   individual control's logical enabled state (an inactive window's
   controls all look dim, same Mac convention either way); reactivating
   only undims a control the program hasn't itself disabled --
   `logicalEnabled` (mac-target-4c Task 1) is exactly that memory, fixing
   the mac-target-4b bug this comment used to describe (a deactivate/
   reactivate cycle no longer visually re-enables a control
   rt_ui_widget_set_bool(..., RTUI_PROP_ENABLED, 0) had turned off). Every
   existing scenario always disables a widget while its window is already
   frontmost (never mid-deactivate), so this is a no-op change for all of
   them: logicalEnabled starts at 1 for every widget and nothing in those
   scenarios ever sets it otherwise. Also (de)activates the window's one
   focused TE, if any -- a field/textview's caret should stop blinking (and
   its selection un-hilite) when its own window isn't frontmost, same as
   any Toolbox-native TE-backed window. */
static void rt_ui_handle_activate(WindowPtr wp, int activating)
{
    rt_ui_winst *inst;
    short i;

    inst = rt_ui_winst_of(wp);
    if (!inst) return;
    SetPort(wp);
    for (i = 0; i < inst->desc->nWidgets; i++) {
        if (inst->ctrls[i]) {
            int on = activating && inst->logicalEnabled[i];
            HiliteControl(inst->ctrls[i], (short)(on ? 0 : 255));
        }
    }
    if (inst->focusIdx >= 0 && inst->tes[inst->focusIdx]) {
        if (activating) TEActivate(inst->tes[inst->focusIdx]);
        else TEDeactivate(inst->tes[inst->focusIdx]);
    }
}

/* ==================== mouse ==================== */

/* Shared by real GrowWindow tracking below and the scripted `resize W H`
   command (Task 3, rt_ui_script_resize): everything AFTER "we now know the
   new size" -- resizing the WindowRecord itself, re-laying-out widgets,
   reallocating buffered-canvas offscreen buffers, and firing the
   `resized` handler -- is identical whether that size came from a real
   interactive GrowWindow drag or a script line. */
static void rt_ui_inval_grow_corner(WindowPtr wp)
{
    Rect r;

    r = wp->portRect;
    r.left = (short)(r.right - RTUI_SCROLLBAR_W);
    r.top = (short)(r.bottom - RTUI_SCROLLBAR_W);
    /* EraseRect, not just InvalRect (this call's own "erase the stale grow
       icon" comment at its call site was already the intent -- InvalRect
       alone only marks the region eligible for the next paint call that
       happens to touch it; it never actually clears anything, so the OLD
       corner's DrawGrowIcon pixels survived as a floating stale glyph
       until window-zoom-hscroll Task 2's hscroll.events became the first
       scenario to snap-verify a plain `resize` -- zoom's own wrapper
       masked this by EraseRect'ing the WHOLE window first). */
    EraseRect(&r);
    InvalRect(&r);
}

static void rt_ui_apply_resize(WindowPtr wp, rt_ui_winst *inst, short newW, short newH)
{
    GrafPtr save;

    GetPort(&save);
    SetPort(wp);
    rt_ui_inval_grow_corner(wp); /* old corner: erase the stale grow icon */
    SizeWindow(wp, newW, newH, (Boolean)1);
    rt_ui_inval_grow_corner(wp); /* new corner */
    SetPort(save);
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
    Rect limits, content;
    short screenW, screenH, maxW, maxH, minW, minH;
    long newSize;

    if (!inst->desc->resizable) return;

    /* BUG FIX (mac-target-4c-fixes): the old 32767 max let GrowWindow drag
       a window's bottom/right edge arbitrarily far off-screen. Cap growth
       at however much screen is left from the window's CURRENT top-left --
       contRgn's bbox is the content rect in global coords, valid even if
       DragWindow has since moved the window from where rt_ui_open put it. */
    content = (*((WindowPeek)wp)->contRgn)->rgnBBox;
    screenW = (short)(qd.screenBits.bounds.right - qd.screenBits.bounds.left);
    screenH = (short)(qd.screenBits.bounds.bottom - qd.screenBits.bounds.top);
    maxW = (short)(screenW - content.left - RTUI_SCREEN_MARGIN);
    maxH = (short)(screenH - content.top - RTUI_SCREEN_MARGIN);
    if (maxW < 1) maxW = 1;
    if (maxH < 1) maxH = 1;

    minW = (short)(inst->desc->minW > 0 ? inst->desc->minW : 1);
    minH = (short)(inst->desc->minH > 0 ? inst->desc->minH : 1);
    /* review fix: a window dragged far enough right/down can leave less
       screen room than the declared minimum -- floor max at min so
       GrowWindow's limit rect never inverts (which silently let the
       window collapse below its declared minimum). This corner case
       means the window may grow partly off-screen again; that's the
       lesser bug next to violating a declared minimum. */
    if (maxW < minW) maxW = minW;
    if (maxH < minH) maxH = minH;

    SetRect(&limits, minW, minH, maxW, maxH);
    newSize = GrowWindow(wp, where, &limits);
    if (newSize == 0) return;
    rt_ui_apply_resize(wp, inst, LoWord(newSize), HiWord(newSize));
}

/* Zoom shares rt_ui_apply_resize's post-size funnel. stdState is refreshed
   before every zoom-out: the full screen minus menu bar (same constants as
   the open-time clamp), so zoom can never put the title bar off-screen.
   ZoomWindow itself saves the current rect into userState on inZoomOut and
   restores it on inZoomIn. */
static void rt_ui_apply_zoom(WindowPtr wp, rt_ui_winst *inst, short part)
{
    GrafPtr save;

    if (part == inZoomOut) {
        WStateData **ws;
        Rect std;
        short screenW, screenH;

        screenW = (short)(qd.screenBits.bounds.right - qd.screenBits.bounds.left);
        screenH = (short)(qd.screenBits.bounds.bottom - qd.screenBits.bounds.top);
        SetRect(&std, 4, RTUI_MENUBAR_H + RTUI_TITLEBAR_H,
                (short)(screenW - RTUI_SCREEN_MARGIN),
                (short)(screenH - RTUI_SCREEN_MARGIN));
        ws = (WStateData **)((WindowPeek)wp)->dataHandle;
        if (ws) (*ws)->stdState = std;
    }
    GetPort(&save);
    SetPort(wp);
    EraseRect(&wp->portRect); /* classic pre-ZoomWindow erase: avoids the old content flashing inside the new frame */
    ZoomWindow(wp, part, (Boolean)(wp == FrontWindow()));
    InvalRect(&wp->portRect);
    SetPort(save);
    rt_ui_apply_resize(wp, inst,
                       (short)(wp->portRect.right - wp->portRect.left),
                       (short)(wp->portRect.bottom - wp->portRect.top));
}

static void rt_ui_handle_zoom(WindowPtr wp, rt_ui_winst *inst, Point where, short part)
{
    if (!inst->desc->resizable) return; /* can't happen (no zoom box without zoomDocProc); cheap symmetry with handle_grow */
    if (!TrackBox(wp, where, part)) return;
    rt_ui_apply_zoom(wp, inst, part);
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

static void rt_ui_handle_content_click(WindowPtr wp, rt_ui_winst *inst, Point where, Boolean shiftDown)
{
    ControlHandle ctrl;
    short cpart;

    SetPort(wp);
    GlobalToLocal(&where);
    cpart = FindControl(where, wp, &ctrl);
    if (cpart != 0 && ctrl != NULL) {
        long rfCon = (*ctrl)->contrlRfCon;
        if (rfCon & 0x8000L) {
            /* A textview's own scrollbar (mac-target-4c Task 1), tagged at
               creation time (rt_ui_make_widgets) -- never a widget index,
               dispatched separately: it scrolls its TE, it never fires a
               widget event. */
            rt_ui_handle_scrollbar_click(inst, ctrl, (short)(rfCon & 0x3FFFL), cpart, where);
            return;
        }
        {
            short wIdx = (short)rfCon;
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
        }
        return;
    }
    {
        short cIdx;
        if (rt_ui_canvas_hit(inst, where, &cIdx)) {
            rt_ui_handle_canvas_click(wp, inst, cIdx, where);
            return;
        }
    }
    {
        short tIdx;
        if (rt_ui_te_hit(inst, where, &tIdx)) {
            /* click-to-focus (Behavior contract): switching focus always
               TEDeactivate/TEActivate's; shift-click extends the CURRENT
               selection only when it lands back in the ALREADY-focused TE
               (extending across a focus switch isn't meaningful -- the old
               TE's selection is about to be deactivated away). */
            Boolean extend = (Boolean)(shiftDown && tIdx == inst->focusIdx);
            rt_ui_te_set_focus(inst, tIdx);
            TEClick(where, extend, inst->tes[tIdx]);
        }
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
    case inZoomIn:
    case inZoomOut:
        inst = rt_ui_winst_of(wp);
        if (inst) rt_ui_handle_zoom(wp, inst, ev->where, part);
        break;
    case inContent:
        if (wp != FrontWindow()) {
            SelectWindow(wp);
            rt_ui_after_front_change(); /* click-to-front changed frontmost */
            break;
        }
        inst = rt_ui_winst_of(wp);
        if (inst) rt_ui_handle_content_click(wp, inst, ev->where, (Boolean)((ev->modifiers & shiftKey) != 0));
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

    /* Focused-TE ordering (Behavior contract): cmdKey (above) -> a focused
       FIELD's Return/Enter fires `enter` (no insertion) -> a focused TE's
       other keys go to TEKey -> only THEN the pre-existing default/cancel/
       generic-key chain. A focused TE swallows Return/typing entirely (a
       textview's own Return inserts a CR rather than falling through to
       the window's default button -- pressing Return while editing a
       multi-line field should never also trigger OK); Escape is the one
       exception, left to fall through to the Cancel-button check below
       even while a TE is focused, since Escape-cancels-the-dialog is the
       Mac convention regardless of which control has focus. Every existing
       scenario has no FIELD/TEXTVIEW widgets, so focusIdx is always -1 and
       every line below this block runs exactly as it did before this
       task -- zero risk to any existing golden. */
    if (inst->focusIdx >= 0) {
        const rt_ui_widget_desc *fwd = &inst->desc->widgets[inst->focusIdx];
        if (fwd->kind == RTUI_FIELD && (ch == 13 || ch == 3)) {
#ifdef RT_MAC_TEST
            rt_ui_trace_fire2(inst->desc->name, fwd->name, "enter");
#endif
            if (inst->desc->handlers && inst->desc->handlers->widget)
                inst->desc->handlers->widget(inst, inst->focusIdx, RTUI_WEV_ENTER, 0, 0);
            return;
        }
        if (ch != 27 && (ch < 28 || ch > 31)) {
            /* Ordinary typing/editing key (not Escape, not an arrow code) --
               ponytail: this task wires no arrow-key cursor navigation
               (TEKey itself doesn't handle arrow codes either -- passing
               one through would literally insert the control byte as
               text), silently swallowed instead; add real cursor-key
               support if a later task needs it. */
            GrafPtr saved;
            GetPort(&saved);
            SetPort(wp);
            TEKey((CharParameter)ch, inst->tes[inst->focusIdx]);
            rt_ui_te_mutated(inst, inst->focusIdx, 1); /* USER edit -- see rt_ui_te_mutated's header comment */
            SetPort(saved);
            return;
        }
        if (ch >= 28 && ch <= 31) return; /* arrow keys: swallowed, see above */
        /* ch == 27 (Escape): falls through to the Cancel-button check below. */
    }

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

/* ==================== App.openDocument launch dispatch (Task 5) ====================
 * rt_ui_launch (rt_ui.h) is called once at startup, AFTER rt_ui_startup and
 * the program's own App.launch handler and BEFORE rt_ui_run, and decides
 * Ch7's openDocument-vs-startEmpty split. Three dispatch modes:
 *
 *   1. RT_MAC_TEST (below, in the #ifdef): the compiled-in script is
 *      pre-scanned HERE, once, for every `launchdoc <path>` line -- see
 *      that #ifdef block's own comment.
 *
 *   2. Real build, AppleEvents available (this function's #else, first
 *      branch): Gestalt(gestaltAppleEventsAttr) succeeds AND this
 *      program's own SIZE(-1) resource has isHighLevelEventAware set
 *      (build-mac.sh's appres.r sets that bit only when the program
 *      declares an `app` section -- Ch7's Mac note, docs/clarus-language-
 *      reference.md). AEInstallEventHandler is installed for
 *      oapp/odoc/pdoc/quit and this function returns WITHOUT calling
 *      openDoc/startEmpty directly -- the Finder's first AppleEvent
 *      (delivered through rt_ui_run's kHighLevelEvent case, below) decides
 *      which one fires, exactly once. This is the ONLY path where a
 *      document dropped on an ALREADY-RUNNING app can open (Ch7's Mac
 *      note: System 6 documents arrive at launch only).
 *
 *   3. Real build, System 6 (or no HLE flag) (this function's #else,
 *      second branch): CountAppFiles/GetAppFiles/ClrAppFiles, the
 *      pre-AppleEvents Segment Loader mechanism -- fires once, at launch,
 *      never again.
 *
 * SIZE flag-bit derivation (RT_UI_SIZE_HLE_MASK below): Processes.r's
 * `type 'SIZE'` template (the Rez template every SIZE(-1) resource,
 * including build-mac.sh's appres.r override, is declared against) lists
 * 16 one-bit boolean fields before its two closing longword memory-size
 * fields; Rez packs consecutive boolean fields MSB-first into the
 * containing 16-bit word (field N, 1-indexed, occupies bit 16-N).
 * Counting Processes.r's own field order -- reserved(1); ignoreSuspend
 * ResumeEvents/acceptSuspendResumeEvents(2); reserved(3); cannotBackground/
 * canBackground(4); needsActivateOnFGSwitch/doesActivateOnFGSwitch(5);
 * backgroundAndForeground/onlyBackground(6); dontGetFrontClicks/
 * getFrontClicks(7); ignoreAppDiedEvents/acceptAppDiedEvents(8);
 * not32BitCompatible/is32BitCompatible(9); notHighLevelEventAware/
 * isHighLevelEventAware(10); ... -- the HLE field is the 10th, so bit
 * 16-10 = 6 (mask 0x0040). Cross-checked independently against Retro68's
 * own multiversal glue header (toolchain/multiversal/CIncludes/
 * Multiverse.h), whose hand-transcribed `SZ_t` enum lists
 * `SZisHighLevelEventAware = 1 << 6` at the same position -- two
 * independently derived readings agree. */
#define RT_UI_SIZE_HLE_MASK 0x0040 /* isHighLevelEventAware -- see derivation above */

#ifndef RT_MAC_TEST
/* Stashed by rt_ui_launch for the AE handlers below to call once the
   Finder's first AppleEvent actually arrives -- same file-scope-static
   convention rt_ui_startup already uses for gMenuHandlerTable/
   gNMenuHandlers (there is exactly one live UI program per process, so one
   slot each is enough). */
static void (*gAeOpenDoc)(const uint8_t *path255) = 0;
static void (*gAeStartEmpty)(void) = 0;

/* Standard AppleEvent completeness check (part of the Apple Event Manager's
   own contract for every installed handler, not a Clarus-specific rule):
   AEGetAttributePtr for keyMissedKeywordAttr SUCCEEDS iff the incoming
   event carried some REQUIRED parameter this handler never fetched --
   oapp/quit take no parameters at all (so any required one is necessarily
   missed) and odoc only ever fetches keyDirectObject, so all three route
   through this one check. It FAILING (typically errAEDescNotFound --
   there is no such attribute) is the normal "nothing missed" case. */
static OSErr rt_ui_ae_check_missed(const AppleEvent *evt)
{
    DescType actualType;
    Size actualSize;

    if (AEGetAttributePtr(evt, keyMissedKeywordAttr, typeWildCard, &actualType, NULL, 0, &actualSize) == noErr) {
        return errAEParamMissed;
    }
    return noErr;
}

static pascal OSErr rt_ui_ae_oapp(const AppleEvent *evt, AppleEvent *reply, long refcon)
{
    OSErr err;

    (void)reply; (void)refcon;
    err = rt_ui_ae_check_missed(evt);
    if (err != noErr) return err;
    if (gAeStartEmpty) gAeStartEmpty();
    return noErr;
}

/* kAEOpenDocuments: the direct object is a list of FSSpecs (one per
   document); OpenWD+SetVol before each openDoc call mirrors this file's
   existing askOpen/askSave SetVol(NULL, reply.vRefNum) convention -- makes
   the picked file's volume the DEFAULT volume so a plain (vRefNum-0)
   rt_file_read_text/rt_file_write_text resolves correctly inside the
   handler. 'ERIK' is this WD entry's owner tag (OpenWD's `procID`
   parameter) -- an arbitrary 4-char code, unrelated to the app's own
   build-time creator code (build-mac.sh's CREATOR/APPID default '????');
   its only job is to distinguish this app's own working-directory
   entries from another process's, which any fixed constant does equally
   well.
   ponytail: each OpenWD here is never matched by a CloseWD -- one WD
   refnum leaks per document opened this way, for the life of the process.
   Bounded (a real launch opens a handful of documents, not thousands) and
   period-typical (plenty of real System 7 apps did the same); add
   CloseWD(wd) right after the openDoc call above if a program that opens
   documents by the hundreds ever makes this matter. */
static pascal OSErr rt_ui_ae_odoc(const AppleEvent *evt, AppleEvent *reply, long refcon)
{
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
            rt_ui_pstrcpy(path255, spec.name);
            if (gAeOpenDoc) gAeOpenDoc(path255);
        }
        /* No App.openDocument handler (final review fix, mac-target-4c):
           mirror the GetAppFiles/System-6 fallback above -- run startEmpty
           once rather than silently opening nothing. */
        if (!gAeOpenDoc && gAeStartEmpty) gAeStartEmpty();
    }
    AEDisposeDesc(&docList);
    err = rt_ui_ae_check_missed(evt);
    if (err != noErr) return err;
    return noErr;
}

static pascal OSErr rt_ui_ae_pdoc(const AppleEvent *evt, AppleEvent *reply, long refcon)
{
    (void)evt; (void)reply; (void)refcon;
    /* No rt_ui_ae_check_missed call here: this handler unconditionally
       declines the event (no printing support -- documented limitation,
       Ch7), so there is no "normal" path whose completeness needs
       checking -- errAEEventNotHandled is returned either way. */
    return errAEEventNotHandled;
}

static pascal OSErr rt_ui_ae_quit(const AppleEvent *evt, AppleEvent *reply, long refcon)
{
    OSErr err;

    (void)reply; (void)refcon;
    err = rt_ui_ae_check_missed(evt);
    if (err != noErr) return err;
    /* rt_ui_quit() is the real quit cascade: if every window's closeRequest
       lets it through, this calls rt_quit(0) (ExitToShell), which does NOT
       return -- the process ends right here, inside the handler, and no
       reply is ever sent. That IS the period-standard, deliberate
       behavior for a quit handler (there is no app left to reply from).
       `return noErr` below is reached ONLY on the cancelled path (some
       window's closeRequest ran `cancel`), where the app stays open and
       genuinely did handle the event. */
    rt_ui_quit();
    return noErr;
}
#endif /* !RT_MAC_TEST */

void rt_ui_launch(void (*openDoc)(const uint8_t *path255), void (*startEmpty)(void))
{
#ifdef RT_MAC_TEST
    /* Pre-scan the WHOLE script for `launchdoc <path>` lines, once, before
       rt_ui_run's own per-event scripted dispatch begins -- these are
       documents the Finder handed the app AT LAUNCH, not an event fired
       later, so they are consumed here rather than by
       rt_ui_run_scripted's line-at-a-time reader (which explicitly skips
       `launchdoc` lines the second time it walks the same script -- see
       its own comment). A path may contain spaces (same "rest of line"
       convention as the `type`/`answer-open` verbs), so this walks the
       script by hand rather than via sscanf. No `launchdoc` line at all
       is a bare launch: startEmpty, matching the real-build fallback for
       zero documents below. */
    const char *cursor = rt_ui_test_script;
    char line[256];
    int found = 0;

    for (;;) {
        int n = 0;
        if (*cursor == '\0') break;
        while (*cursor && *cursor != '\n') {
            if (n < (int)sizeof(line) - 1) line[n++] = *cursor;
            cursor++;
        }
        if (*cursor == '\n') cursor++;
        line[n] = '\0';
        if (strncmp(line, "launchdoc ", 10) == 0) {
            const char *path = line + 10;
            unsigned char path255[256];
            size_t plen = strlen(path);
            char buf[300];

            found = 1;
            if (plen > 255) plen = 255; /* Str255 cap, same silent clamp as every other
                                            Pascal-string fill in this file */
            path255[0] = (unsigned char)plen;
            memcpy(path255 + 1, path, plen);
            sprintf(buf, "T OPENDOC %s", path);
            rt_test_emit(buf);
            if (openDoc) openDoc(path255);
        }
    }
    if (!found && startEmpty) startEmpty();
#else
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
        gAeOpenDoc = openDoc;
        gAeStartEmpty = startEmpty;
        AEInstallEventHandler(kCoreEventClass, kAEOpenApplication, NewAEEventHandlerUPP(rt_ui_ae_oapp), 0, false);
        AEInstallEventHandler(kCoreEventClass, kAEOpenDocuments, NewAEEventHandlerUPP(rt_ui_ae_odoc), 0, false);
        AEInstallEventHandler(kCoreEventClass, kAEPrintDocuments, NewAEEventHandlerUPP(rt_ui_ae_pdoc), 0, false);
        AEInstallEventHandler(kCoreEventClass, kAEQuitApplication, NewAEEventHandlerUPP(rt_ui_ae_quit), 0, false);
        return; /* the Finder's first AppleEvent decides -- do not call openDoc/startEmpty
                    directly on this path */
    }

    {
        short count, i;
        OSErr msg;

        /* msg comes back appOpen or appPrint for the WHOLE batch (System 6
           has no per-file open/print mix); appPrint is treated exactly like
           appOpen below -- no printing support, same documented limitation
           the AE pdoc handler above states for System 7+. */
        CountAppFiles(&msg, &count);
        if (count > 0) {
            if (openDoc) {
                for (i = 1; i <= count; i++) {
                    AppFile file;
                    unsigned char path255[256];

                    GetAppFiles(i, &file);
                    SetVol(NULL, file.vRefNum);
                    rt_ui_pstrcpy(path255, file.fName);
                    openDoc(path255);
                }
            } else if (startEmpty) {
                /* No App.openDocument handler: the reference says
                   openDocument fires per document; a program that never
                   declared the handler just ignores the docs -- startEmpty
                   still runs so the app opens SOMETHING rather than
                   nothing. */
                startEmpty();
            }
            /* ClrAppFiles' index is 1-based PER FILE (Inside Macintosh),
               not a single call with a 0 "clear everything" sentinel --
               final review fix, mac-target-4c: the previous single
               `ClrAppFiles(0)` call was wrong per IM, though harmless in
               practice (nothing here re-reads the AppFiles list after this
               point). */
            for (i = 1; i <= count; i++) ClrAppFiles(i);
        } else if (startEmpty) {
            startEmpty();
        }
    }
#endif
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
   wanders off every hit-testable widget.

   mac-target-4c Task 3 addition: a drag landing inside the ALREADY-focused
   field/textview extends its selection to this point instead (script
   `click <start>` then `drag <end>`, mirroring a real mouse-down-drag-
   release select). TEClick's own `extend` flag (Inside Macintosh's
   shift-click affordance) is the exact mechanism a real click already
   uses for shift-extend (rt_ui_handle_content_click computes the same
   `extend` bool from the shift key) -- calling it here with extend=true
   produces the identical final anchor/endpoint selection state a real
   click-hold-drag-release to the same point would, since TE's own
   selection math only depends on the anchor and the final point, never
   the path between them (the live tracking redraw a real drag also does
   is the only thing scripted mode can't reproduce, and it has no
   observable effect on the eventual selection or on any snap/trace this
   harness can assert against). Deliberately does NOT start a new TE's
   focus on a drag (only extends the CURRENTLY-focused one, checked via
   tIdx == inst->focusIdx) -- "drag" is a continuation of a prior click,
   not an independent click of its own. */
static void rt_ui_script_drag(short x, short y)
{
    WindowPtr wp;
    Point where, local;
    short part, cIdx, tIdx;
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
    if (rt_ui_canvas_hit(inst, local, &cIdx)) {
        rt_ui_fire_canvas_xy(inst, cIdx, RTUI_WEV_DRAG, local);
        return;
    }
    if (rt_ui_te_hit(inst, local, &tIdx) && tIdx == inst->focusIdx && inst->tes[tIdx]) {
        TEClick(local, (Boolean)1, inst->tes[tIdx]);
    }
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

/* `key`'s arg1 decoder (mac-target-4c Task 2): a literal character (e.g.
   `key x`) is the common case, but some keystrokes -- Return/Enter (13)
   chief among them, needed to script a focused FIELD's `enter` event --
   have no printable spelling a text-based .events script can carry
   through scripts/build-mac.sh's `--events FILE` pipeline: that pipeline
   C-escapes the file's raw BYTES into a string literal (see its own
   comment), and a literal 0x0D byte there is mis-lexed as a source
   line-ending by the C compiler (CR is a valid lone line terminator to
   it), while a literal backslash-escape spelling (`\r`) gets its
   backslash doubled by that same escaping pass and so decodes back to
   the two characters `\`+`r`, not a CR byte -- there is no way to name
   byte 13 in the FILE at all, only in hand-written C (e.g.
   internal/mactest/uiprobe/events_text.c's `"...\r\n"`, a real source
   escape, never routed through the shell-level pipeline). Decimal digits
   were never a valid literal-character spelling in any existing script
   (every current `key` line names a letter, e.g. buttons.events' `key
   x`), so treating an all-digit arg1 as a decimal byte CODE instead of a
   literal character is a purely additive, backward-compatible grammar
   extension: `key 13` sends Return, `key x` still sends 'x'. */
static unsigned char rt_ui_script_key_arg(const char *arg1)
{
    const char *p;
    int allDigits;

    if (arg1[0] == '\0') return 0;
    allDigits = 1;
    for (p = arg1; *p != '\0'; p++) {
        if (*p < '0' || *p > '9') { allDigits = 0; break; }
    }
    if (allDigits) return (unsigned char)atoi(arg1);
    return (unsigned char)arg1[0];
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

/* `zoom`: real zooming is interactive (TrackBox blocks on a real mouse);
   a script toggles directly. Direction: if the window already occupies the
   standard state, zoom back in; otherwise zoom out. */
static void rt_ui_script_zoom(void)
{
    WindowPtr wp;
    rt_ui_winst *inst;
    Rect content, std;
    short screenW, screenH, part;

    wp = FrontWindow();
    if (!wp) return;
    inst = rt_ui_winst_of(wp);
    if (!inst || !inst->desc->resizable) return;
    screenW = (short)(qd.screenBits.bounds.right - qd.screenBits.bounds.left);
    screenH = (short)(qd.screenBits.bounds.bottom - qd.screenBits.bounds.top);
    SetRect(&std, 4, RTUI_MENUBAR_H + RTUI_TITLEBAR_H,
            (short)(screenW - RTUI_SCREEN_MARGIN),
            (short)(screenH - RTUI_SCREEN_MARGIN));
    content = (*((WindowPeek)wp)->contRgn)->rgnBBox;
    part = EqualRect(&content, &std) ? inZoomIn : inZoomOut;
    rt_ui_apply_zoom(wp, inst, part);
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
    rt_ui_te_idle_front(); /* blink the focused TE's caret, same as the real loop's per-iteration TEIdle */
    rt_ui_flush_all_buffered(); /* same "returns control to the event loop" point real rt_ui_run uses, Ch11 */
}

/* `snap NAME`: hex-dumps the FULL screen -- rows * rowBytes bytes starting
   at qd.screenBits.baseAddr -- between the pinned sentinels, uppercase,
   128 hex chars (64 source bytes) per line. rowBytes is asserted (not
   just assumed) to be 64, both because the 64-bytes-per-hex-line
   convention depends on it AND because it's what makes rows*rowBytes an
   exact multiple of 64 (342*64 = 21,888 bytes for the pinned 512x342 1-bit
   screen), so every line is a full line -- no partial-line case to
   handle. Computed, not hardcoded: self-documents that 21,888 comes from
   the screen's own dimensions rather than being a magic number the
   contract just happens to pin (see docs/superpowers/plans/
   2026-07-24-mac-target-4b.md and the design doc's own correction of an
   earlier 10,944 miscalculation). */
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
    long off, total, rows;
    char hdr[280];
    char line[130];

    if (qd.screenBits.rowBytes != 64) rt_panic("snap: screenBits.rowBytes is not 64");
    rows = (long)qd.screenBits.bounds.bottom - (long)qd.screenBits.bounds.top;
    total = rows * (long)qd.screenBits.rowBytes;
    sprintf(hdr, "##CLARUS-SNAP## %s", name);
    rt_test_emit(hdr);
    base = (unsigned char *)qd.screenBits.baseAddr;
    for (off = 0; off < total; off += 64) {
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
        if (!rt_ui_script_next_line(line, sizeof(line))) { rt_ui_quit(); return; }
        arg1[0] = '\0';
        arg2[0] = '\0';
        nf = sscanf(line, "%31s %63s %63s", verb, arg1, arg2);
        if (nf < 1) continue;
        if (strcmp(verb, "click") == 0) {
            rt_ui_script_click((short)atoi(arg1), (short)atoi(arg2));
        } else if (strcmp(verb, "drag") == 0) {
            rt_ui_script_drag((short)atoi(arg1), (short)atoi(arg2));
        } else if (strcmp(verb, "key") == 0) {
            rt_ui_script_key(rt_ui_script_key_arg(arg1));
        } else if (strcmp(verb, "type") == 0) {
            /* `type <rest-of-line>` (mac-target-4c Task 1): unlike every
               other verb's args, the typed text can contain spaces (and
               even a literal CR byte, value 13, to script a Return
               keystroke mid-string -- only '\n' terminates a script line,
               see rt_ui_script_next_line), so it is NOT read via sscanf's
               %63s (which stops at the first space and truncates). Skip
               past the verb itself and exactly one separating space, then
               feed every remaining byte through rt_ui_script_key one at a
               time -- the same per-character path a run of individual
               `key` lines would produce. */
            const char *p = line + 4; /* strlen("type") */
            if (*p == ' ') p++;
            for (; *p != '\0'; p++) rt_ui_script_key((unsigned char)*p);
        } else if (strcmp(verb, "menu") == 0) {
            rt_ui_script_menu((short)atoi(arg1), (short)atoi(arg2));
        } else if (strcmp(verb, "close") == 0) {
            rt_ui_script_close();
        } else if (strcmp(verb, "resize") == 0) {
            rt_ui_script_resize((short)atoi(arg1), (short)atoi(arg2));
        } else if (strcmp(verb, "zoom") == 0) {
            rt_ui_script_zoom();
        } else if (strcmp(verb, "tick") == 0) {
            rt_ui_script_tick((long)atoi(arg1));
        } else if (strcmp(verb, "snap") == 0) {
            rt_ui_test_snap(arg1);
        } else if (strcmp(verb, "quit") == 0) {
            rt_ui_quit(); /* returns here only if a closeRequest handler
                              cancelled the whole quit -- rt_quit(0) inside
                              never returns, so falling through to the
                              bottom of the loop means "keep scripting" */
        } else if (strcmp(verb, "answer-open") == 0) {
            /* `answer-open <rest-of-line path>` (Task 4): same rest-of-line
               parsing as `type` above -- a path can contain spaces, so it
               is read past the verb and one separating space, not via
               sscanf's %63s arg1 (already populated above but unused
               here). */
            const char *p = line + 11; /* strlen("answer-open") */
            if (*p == ' ') p++;
            rt_ui_answer_push_path(RT_UI_ANS_OPEN, p);
        } else if (strcmp(verb, "answer-save") == 0) {
            const char *p = line + 11; /* strlen("answer-save") */
            if (*p == ' ') p++;
            rt_ui_answer_push_path(RT_UI_ANS_SAVE, p);
        } else if (strcmp(verb, "answer-changes") == 0) {
            short v;
            if (strcmp(arg1, "save") == 0) v = 0;
            else if (strcmp(arg1, "discard") == 0) v = 1;
            else if (strcmp(arg1, "cancel") == 0) v = 2;
            else { rt_panic("answer-changes: bad argument (want save|discard|cancel)"); v = 0; }
            rt_ui_answer_push_val(RT_UI_ANS_CHANGES, v);
        } else if (strcmp(verb, "answer-cancel") == 0) {
            /* Queues a cancel for whichever of askOpen/askSave consumes it
               next -- rt_ui_ask_open/rt_ui_ask_save both recognize
               RT_UI_ANS_CANCEL; rt_ui_ask_save_changes does not (its own
               three-way cancel is `answer-changes cancel` instead). */
            rt_ui_answer_push_val(RT_UI_ANS_CANCEL, 0);
        } else if (strcmp(verb, "launchdoc") == 0) {
            /* Explicit no-op, not silent unknown-verb fallthrough (Task 5):
               `launchdoc` lines are consumed once, up front, by
               rt_ui_launch's own pre-scan (above) -- by the time this
               per-event reader reaches one, it has already been dispatched
               and must not fire a second time. */
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
        /* Sleep argument drops to 1 tick whenever there's a live `every`
           timer (unchanged from Task 2) OR the frontmost window has a
           focused field/textview (mac-target-4c Task 1) -- either way,
           something needs to keep running close to on schedule (a timer
           firing, or TEIdle blinking a caret) rather than the plain
           30-tick polling cadence a window with neither gets. */
        {
            rt_ui_winst *frontInst = rt_ui_winst_of(FrontWindow());
            short sleepTicks = (short)((gNEvery > 0 || (frontInst && frontInst->focusIdx >= 0)) ? 1 : 30);
            WaitNextEvent(everyEvent, &ev, sleepTicks, NULL);
        }
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
        case kHighLevelEvent:
            /* AppleEvents (Task 5) -- only ever arrives once rt_ui_launch's
               AE-mode branch has installed handlers (harmless on System 6
               or a non-HLE-aware build: no such event is ever posted
               there, so this case just never fires). */
            AEProcessAppleEvent(&ev);
            break;
        default:
            break;
        }
        rt_ui_every_pump();
        rt_ui_te_idle_front();
        rt_ui_flush_all_buffered(); /* "returns control to the event loop" point, Ch11 */
    }
}

void *rt_ui_open(const rt_ui_window_desc *d)
{
    rt_ui_winst *inst;
    Handle instH;
    Rect bounds;
    short screenW, screenH, left, top, w, h;

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
    inst->tes = (TEHandle *)rt_ui_alloc_locked((Size)d->nWidgets * sizeof(TEHandle), &inst->teH);
    inst->hbars = (ControlHandle *)rt_ui_alloc_locked((Size)d->nWidgets * sizeof(ControlHandle), &inst->hbarsH);
    inst->logicalEnabled = (char *)rt_ui_alloc_locked((Size)d->nWidgets * sizeof(char), &inst->enabledH);
    inst->focusIdx = -1;
    {
        short wi;
        for (wi = 0; wi < d->nWidgets; wi++) {
            inst->canvases[wi].patLevel = 8;
            inst->logicalEnabled[wi] = 1; /* NewHandleClear zeroes this to "disabled" by default -- every widget starts logically enabled */
        }
    }

    /* BUG FIX (mac-target-4c-fixes): `size:` in a .cla program is a
       REQUEST, not a guarantee (Ch8 Mac-note) -- a window taller or wider
       than the actual screen used to open partway off-screen (bottom rows
       and the grow icon unreachable). Clamp both position and size to fit
       qd.screenBits.bounds before NewWindow ever sees the rect. */
    screenW = (short)(qd.screenBits.bounds.right - qd.screenBits.bounds.left);
    screenH = (short)(qd.screenBits.bounds.bottom - qd.screenBits.bounds.top);
    left = (short)((screenW - d->w) / 2);
    if (left < 4) left = 4;
    w = d->w;
    if (w > (short)(screenW - left - RTUI_SCREEN_MARGIN)) {
        w = (short)(screenW - left - RTUI_SCREEN_MARGIN);
        if (w < 1) w = 1; /* degenerate screen; NewWindow still needs a positive rect */
    }

    /* Preferred top (pre-existing convention: menu bar + title bar + a
       few px breathing room). If the window doesn't fit there, pull it up
       flush under the title bar instead; if it STILL doesn't fit even
       there, the size itself has to give -- clamp the height too. */
    top = 44;
    h = d->h;
    if ((short)(top + h + RTUI_SCREEN_MARGIN) > screenH) {
        top = RTUI_MENUBAR_H + RTUI_TITLEBAR_H; /* 39: flush under the title bar */
        if ((short)(top + h + RTUI_SCREEN_MARGIN) > screenH) {
            h = (short)(screenH - top - RTUI_SCREEN_MARGIN);
            if (h < 1) h = 1;
        }
    }
    SetRect(&bounds, left, top, (short)(left + w), (short)(top + h));

    inst->wp = NewWindow(NULL, &bounds, d->title, (Boolean)0,
                          d->resizable ? zoomDocProc : noGrowDocProc,
                          (WindowPtr)-1L, (Boolean)1, 0L);
    if (!inst->wp) rt_panic("out of memory");
    ((WindowPeek)inst->wp)->windowKind = RTUI_WINDOW_KIND;
    SetWRefCon(inst->wp, (long)inst);

    rt_ui_make_widgets(inst);
    rt_ui_layout(inst);
    rt_ui_canvas_realloc_all(inst);

    /* Auto-focus the FIRST field/textview-kind widget (final review fix,
       mac-target-4c): Ch8 gives a freshly opened window no caret at all
       until something clicks a field/textview by hand -- every period
       text-entry dialog auto-focuses its one text control instead, and
       typing right after `open` should go somewhere. Same focus path a
       click uses (rt_ui_te_set_focus: TEActivate + standard-edit dim
       recompute), and traces no differently than a click does either --
       no line of its own, only whatever DIM side effect falls out. MUST
       run here, BEFORE ShowWindow/SelectWindow below: rt_ui_menu_
       recompute_dim (inside rt_ui_te_set_focus) keys off FrontWindow(),
       which never returns a still-invisible window, so this call's own
       recompute is a same-behavior no-op (this window isn't front yet) --
       the real dim flip happens once, moments later, in
       rt_ui_after_front_change's own recompute call below, which by then
       sees BOTH "front changed" and "focus already set" together and
       traces them as one merged DIM group ahead of T FRONT. Self-asserts/
       restores the port (PORT DISCIPLINE RULE, rt_ui.h): rt_ui_layout just
       above already restored the CALLER's port, not this window's. */
    {
        short wi;
        for (wi = 0; wi < d->nWidgets; wi++) {
            if (d->widgets[wi].kind == RTUI_FIELD || d->widgets[wi].kind == RTUI_TEXTVIEW) {
                GrafPtr savedPort;
                GetPort(&savedPort);
                SetPort(inst->wp);
                rt_ui_te_set_focus(inst, wi);
                SetPort(savedPort);
                break;
            }
        }
    }

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

/* Shared close-cascade primitive: fires closeRequest and, unless the
   handler cancels, disposes the window and fires closed. Returns 1 if the
   window closed, 0 if closeRequest cancelled it (the window, its widgets,
   and its state are untouched -- exactly as if this call had never
   happened). rt_ui_close (a single window, `close w`) and rt_ui_quit (the
   whole open-window list, `quit`) both funnel through here so "cancel"
   means the identical thing -- and produces the identical trace -- from
   either caller. */
static int rt_ui_close_internal(rt_ui_winst *inst)
{
    long cancelFlag;

    cancelFlag = 0;
#ifdef RT_MAC_TEST
    rt_ui_trace_fire1(inst->desc->name, "closeRequest");
#endif
    if (inst->desc->handlers && inst->desc->handlers->winEvent)
        inst->desc->handlers->winEvent(inst, RTUI_EV_CLOSEREQUEST, (long)&cancelFlag, 0);
    if (cancelFlag) return 0;

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
        for (i = 0; i < inst->desc->nWidgets; i++) {
            rt_ui_canvas_dispose(&inst->canvases[i]);
            if (inst->tes[i]) TEDispose(inst->tes[i]); /* TEHandle is its own separate Handle, not covered by DisposeHandle(inst->teH) below */
        }
    }
    if (inst->stateH) DisposeHandle(inst->stateH);
    DisposeHandle(inst->ctrlsH);
    DisposeHandle(inst->rectsH);
    DisposeHandle(inst->labelsH);
    DisposeHandle(inst->canvasH);
    DisposeHandle(inst->teH);
    DisposeHandle(inst->hbarsH);
    DisposeHandle(inst->enabledH);
    DisposeHandle(inst->selfH);
    return 1;
}

void rt_ui_close(void *instV)
{
    rt_ui_close_internal((rt_ui_winst *)instV);
}

/* `quit` in a UI program -- see this function's declaration in rt_ui.h for
   the pinned semantics (reference doc's Quit Semantics, ~line 767) and
   rt_ui_close_internal's comment for the shared cascade primitive both
   rt_ui_close and this walk through.

   Front-to-back order: FrontWindow()/WindowPeek.nextWindow is the OS's own
   front-to-back window list -- rt_ui_front (below) walks it the same way
   to find a type's frontmost instance. `next` is captured before the
   close call because DisposeWindow (inside rt_ui_close_internal) unlinks
   the window from that very list; walking off a pointer already freed as
   a side effect of visiting it would be a use-after-free. */
void rt_ui_quit(void)
{
    WindowPtr wp, next;
    rt_ui_winst *inst;

    for (wp = FrontWindow(); wp != NULL; wp = next) {
        next = (WindowPtr)((WindowPeek)wp)->nextWindow;
        if (!rt_ui_is_ours(wp)) continue;
        inst = (rt_ui_winst *)GetWRefCon(wp);
        if (!rt_ui_close_internal(inst)) return; /* cancelled: abort the quit, leave the rest open */
    }
    rt_quit(0);
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

void rt_ui_get_title(void *inst, unsigned char *dst255)
{
    GetWTitle(((rt_ui_winst *)inst)->wp, dst255);
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
    } else if (wd->kind == RTUI_FIELD && prop == RTUI_PROP_TEXT && inst->tes[wIdx]) {
        /* Str255 is already capped at 255 bytes structurally (s[0] can
           never exceed that), so rt_ui_te_mutated's own clamp is a no-op
           safety net here, not a real truncation path -- unlike textview's
           set_text below, which can genuinely exceed RTUI_TE_MAX. */
        unsigned char len = s ? s[0] : 0;
        TESetText(s + 1, len, inst->tes[wIdx]);
        TECalText(inst->tes[wIdx]);
        InvalRect(&(*inst->tes[wIdx])->viewRect);
        rt_ui_te_mutated(inst, wIdx, 0); /* PROGRAMMATIC set -- no trace/event, see rt_ui_te_mutated's header comment */
    }
    SetPort(savedPort);
}

/* rt_ui_widget_get_str (mac-target-4c Task 1): see rt_ui.h's own comment.
   Fill-in-place read; a non-matching kind/prop writes a length-0 Pascal
   string rather than leaving dst255 untouched. */
void rt_ui_widget_get_str(void *instV, short wIdx, short prop, unsigned char *dst255)
{
    rt_ui_winst *inst;
    const rt_ui_widget_desc *wd;

    inst = (rt_ui_winst *)instV;
    wd = &inst->desc->widgets[wIdx];
    dst255[0] = 0;
    if (wd->kind == RTUI_FIELD && prop == RTUI_PROP_TEXT && inst->tes[wIdx]) {
        TEHandle te = inst->tes[wIdx];
        Handle th = (*te)->hText;
        short len = (*te)->teLength;
        if (len > 255) len = 255; /* defensive only -- rt_ui_te_mutated already keeps a field's own content <=255 */
        HLock(th);
        BlockMoveData(*th, dst255 + 1, len);
        HUnlock(th);
        dst255[0] = (unsigned char)len;
    }
}

/* rt_ui_widget_get_text/set_text (mac-target-4c Task 1): textview's
   RTUI_PROP_TEXT, bridged via rt_text_from_bytes/rt_text_to_bytes (rt.h).
   No RT_MAC_TEST trace line: the plan's pinned trace vocabulary has no
   `T SET`-style entry for an rt_text value (unlike the Str255 `T SET`
   lines rt_ui_trace_set_str prints), and set_text's own mutation funnel
   call already traces `T FIRE <Win>.<W>.change`, which is the observable
   effect a script cares about. */
void rt_ui_widget_get_text(void *instV, short wIdx, rt_text *out)
{
    rt_ui_winst *inst;
    const rt_ui_widget_desc *wd;
    TEHandle te;

    inst = (rt_ui_winst *)instV;
    wd = &inst->desc->widgets[wIdx];
    if (wd->kind != RTUI_TEXTVIEW || !inst->tes[wIdx]) {
        rt_text_from_bytes(out, (const unsigned char *)"", 0, 0);
        return;
    }
    te = inst->tes[wIdx];
    HLock((Handle)(*te)->hText);
    rt_text_from_bytes(out, (const unsigned char *)*(*te)->hText, (*te)->teLength, (*te)->teLength);
    HUnlock((Handle)(*te)->hText);
}

void rt_ui_widget_set_text(void *instV, short wIdx, const rt_text *t)
{
    rt_ui_winst *inst;
    const rt_ui_widget_desc *wd;
    GrafPtr savedPort;
    Ptr buf;
    long copied;

    inst = (rt_ui_winst *)instV;
    wd = &inst->desc->widgets[wIdx];
    if (wd->kind != RTUI_TEXTVIEW || !inst->tes[wIdx]) return;
    GetPort(&savedPort);
    SetPort(inst->wp);
    /* A heap scratch buffer, not a stack one: RTUI_TE_MAX (32000) bytes
       would blow a 68k app's small default stack. rt_text_to_bytes itself
       clamps to bufcap and calls rt_set_lasterr("string truncated") on
       overflow (rt.h/rt_mac.c) -- the same truncation-reporting convention
       every other rt_str_ and rt_text_ fill-in-place call already uses, so
       no separate clamp/lasterr call is needed here. */
    buf = NewPtr((Size)RTUI_TE_MAX);
    if (!buf) rt_panic("out of memory");
    copied = rt_text_to_bytes(t, (unsigned char *)buf, RTUI_TE_MAX);
    TESetText(buf, copied, inst->tes[wIdx]);
    DisposePtr(buf);
    TECalText(inst->tes[wIdx]);
    InvalRect(&(*inst->tes[wIdx])->viewRect);
    rt_ui_te_mutated(inst, wIdx, 0); /* PROGRAMMATIC set -- no trace/event, see rt_ui_te_mutated's header comment */
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
        /* logicalEnabled (mac-target-4c Task 1) remembers this independent
           of the window's own active/inactive dimming -- see
           rt_ui_handle_activate's comment. Only actually undim right now
           if this window is currently frontmost; enabling a widget in a
           background window defers the visible undim to its next
           activate (undimming it immediately would look wrong under an
           inactive window, and HiliteControl(...,0) on an inactive
           window's control is exactly the pre-existing bug this fixes).
           Every existing scenario only ever calls this while its window
           is already frontmost, so the HiliteControl call below still
           fires exactly when it used to -- no behavior change for them. */
        inst->logicalEnabled[wIdx] = (char)(v ? 1 : 0);
        if (inst->wp == FrontWindow())
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
        /* logicalEnabled, not contrlHilite (mac-target-4c Task 1 fix): the
           old contrlHilite read reported "disabled" for any button in a
           merely-INACTIVE window, even one the program never disabled --
           see rt_ui_handle_activate's comment for the full bug. */
        return inst->logicalEnabled[wIdx] != 0;
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

/* Nine 8x8 fill patterns, level 0 (white) .. 8 (black): an ordered-dither
   density ramp (levels 5-7 are the bitwise complements of 3-1). QuickDraw
   aligns patterns to the port, not the filled rect, so adjacent fills at
   any rect size tile into one seamless dither (Ch11: pattern). */
static const Pattern rt_ui_gray_pats[9] = {
    {{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}},   /* 0: white  */
    {{0x88, 0x00, 0x22, 0x00, 0x88, 0x00, 0x22, 0x00}},   /* 1: 12.5%  */
    {{0x88, 0x22, 0x88, 0x22, 0x88, 0x22, 0x88, 0x22}},   /* 2: 25%    */
    {{0xAA, 0x22, 0xAA, 0x88, 0xAA, 0x22, 0xAA, 0x88}},   /* 3: 37.5%  */
    {{0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55}},   /* 4: 50%    */
    {{0x55, 0xDD, 0x55, 0x77, 0x55, 0xDD, 0x55, 0x77}},   /* 5: 62.5%  */
    {{0x77, 0xDD, 0x77, 0xDD, 0x77, 0xDD, 0x77, 0xDD}},   /* 6: 75%    */
    {{0x77, 0xFF, 0xDD, 0xFF, 0x77, 0xFF, 0xDD, 0xFF}},   /* 7: 87.5%  */
    {{0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF}},   /* 8: black  */
};

void rt_ui_canvas_pattern(void *instV, short wIdx, short level)
{
    rt_ui_winst *inst;

    inst = (rt_ui_winst *)instV;
    if (level < 0) level = 0;
    if (level > 8) level = 8;
    inst->canvases[wIdx].patLevel = level;
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
    if (fill) FillRect(&r, &rt_ui_gray_pats[inst->canvases[wIdx].patLevel]);
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
    FillOval(&box, &rt_ui_gray_pats[inst->canvases[wIdx].patLevel]);
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
