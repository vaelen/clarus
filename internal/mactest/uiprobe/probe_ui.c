/* probe_ui.c -- hand-authored rt_ui descriptor app proving runtime/mac/
   rt_ui.c end to end. Task 1 proved windows/widgets/layout/events with one
   window type ("Probe": default button, checkbox, label). Task 2 adds:

     - a "Probe" menu (app-scope "Toggle" item that flips Probe.front's
       check the same way the Go button does; a "Scoped" item nested under
       Probe's own scope, only enabled while a Probe window is frontmost;
       a "Quit" item -- now that menus exist, closing a window no longer
       ends the run by itself, see probe_win_event's RTUI_EV_CLOSED case).
     - a second window type, "Bounce": a single buffered canvas animated by
       a top-level every-block (a bouncing filled square), which doubles
       as the "prove dimming" window -- it is a DIFFERENT type from Probe,
       so closing Probe while Bounce stays open must leave the Scoped item
       disabled (rt_ui_front(&kProbeWindow) is nil either way).

   Both windows are opened at startup so the animation is visible
   immediately and the dimming proof only requires closing Probe's own
   close box. */
#include "rt_ui.h"
#include "rt.h"
#include <stddef.h> /* offsetof -- TableProbe's rt_field_desc offsets (Task 4, mac-target-4d) */
#include <NumberFormatting.h> /* NumToString -- FormProbe's Price/fixed result trace (Task 6 fix round 1) */

/* ==================== Probe window (Task 1, extended) ==================== */

enum { W_GO = 0, W_ON = 1, W_STATUS = 2 };

typedef struct { short clicks; } ProbeState;

static void ui8_to_pstr(unsigned char *out, int n)
{
    /* n: 0..99, all this probe ever needs -- no sprintf, no rt_text. */
    if (n >= 10) {
        out[0] = 2;
        out[1] = (unsigned char)('0' + (n / 10) % 10);
        out[2] = (unsigned char)('0' + n % 10);
    } else {
        out[0] = 1;
        out[1] = (unsigned char)('0' + n);
    }
}

static void build_status(unsigned char *out, int checked, int clicks)
{
    static const unsigned char onWord[] = { 3, 'O', 'n', ' ' };
    static const unsigned char offWord[] = { 4, 'O', 'f', 'f', ' ' };
    const unsigned char *word;
    unsigned char num[4];
    unsigned char i;

    word = checked ? onWord : offWord;
    for (i = 0; i < word[0]; i++) out[1 + i] = word[1 + i];
    out[0] = word[0];
    ui8_to_pstr(num, clicks);
    for (i = 0; i < num[0]; i++) out[1 + out[0] + i] = num[1 + i];
    out[0] = (unsigned char)(out[0] + num[0]);
}

/* Shared by the Go button's click handler and the Probe menu's app-scope
   "Toggle" item -- both are "flip the check, bump the counter, rewrite the
   label", the same action from two different entry points. */
static void probe_do_toggle(void *inst)
{
    ProbeState *st;
    unsigned char status[16];
    int checked;

    checked = rt_ui_widget_get_bool(inst, W_ON, RTUI_PROP_CHECKED);
    rt_ui_widget_set_bool(inst, W_ON, RTUI_PROP_CHECKED, !checked);
    st = (ProbeState *)rt_ui_state(inst);
    st->clicks++;
    build_status(status, !checked, st->clicks);
    rt_ui_widget_set_str(inst, W_STATUS, RTUI_PROP_TEXT, status);
}

static void probe_widget_event(void *inst, short widgetIndex, short event, long a, long b)
{
    (void)a; (void)b;
    if (widgetIndex == W_GO && event == RTUI_WEV_CLICK) probe_do_toggle(inst);
}

static void probe_win_event(void *inst, short event, long a, long b)
{
    (void)b;
    switch (event) {
    case RTUI_EV_KEY: {
        unsigned char title[2];
        title[0] = 1;
        title[1] = (unsigned char)a;
        rt_ui_set_title(inst, title);
        break;
    }
    default:
        break; /* opened, closeRequest (no cancel), closed, resized: nothing
                   to do -- Quit (the menu item, Task 2) ends the run now */
    }
}

static const rt_ui_widget_desc kProbeWidgets[] = {
    { RTUI_BUTTON, "Go", (const unsigned char *)"\pGo",
      RTUI_AT_XY, 20, 20, 80, RTUI_FILL_NONE, RTUI_DEFAULT },
    { RTUI_CHECK, "On", (const unsigned char *)"\pOn",
      RTUI_AT_RIGHT, 0, 22, 60, RTUI_FILL_NONE, 0 },
    { RTUI_LABEL, "Status", (const unsigned char *)"\pOff 0",
      RTUI_AT_NEXT, 0, RTUI_BOTTOM, RTUI_FILL, RTUI_FILL_NONE, 0 },
    /* Exercises `at: 10, bottom` (RTUI_AT_XY with an explicit x AND the
       RTUI_BOTTOM y-sentinel) -- distinct from Status's RTUI_AT_NEXT case
       above, which resolves RTUI_BOTTOM too but takes its x from the
       previous widget instead of stating one. */
    { RTUI_LABEL, "Note", (const unsigned char *)"\pBelow Status",
      RTUI_AT_XY, 20, RTUI_BOTTOM, RTUI_FILL, RTUI_FILL_NONE, 0 }
};

static const rt_ui_handlers kProbeHandlers = { probe_win_event, probe_widget_event };

static const rt_ui_window_desc kProbeWindow = {
    "Probe", (const unsigned char *)"\pProbe",
    300, 170, 1, 220, 130,
    4, kProbeWidgets,
    (short)sizeof(ProbeState),
    &kProbeHandlers
};

/* ==================== Bounce window (Task 2: canvas + every) ==================== */

enum { B_BOARD = 0 };

typedef struct { short x, dx; } BounceState;

static void bounce_win_event(void *inst, short event, long a, long b)
{
    (void)a; (void)b;
    if (event == RTUI_EV_OPENED) {
        BounceState *st;
        st = (BounceState *)rt_ui_state(inst);
        st->x = 10;
        st->dx = 3;
    }
}

static const rt_ui_widget_desc kBounceWidgets[] = {
    { RTUI_CANVAS, "Board", (const unsigned char *)0,
      RTUI_AT_XY, 0, 0, RTUI_FILL, RTUI_FILL_BOTH, RTUI_BUFFERED }
};

static const rt_ui_handlers kBounceHandlers = { bounce_win_event, 0 };

static const rt_ui_window_desc kBounceWindow = {
    "Bounce", (const unsigned char *)"\pBounce",
    160, 160, 1, 120, 120, /* resizable: exercises buffered-canvas offscreen-buffer reallocation on grow (rt_ui_canvas_realloc_all) */
    1, kBounceWidgets,
    (short)sizeof(BounceState),
    &kBounceHandlers
};

#define BOUNCE_SQUARE 20

/* Top-level every-block (Ch11/Ch7): looks up the front Bounce instance
   itself (mirrors the reference's `Game.front` pattern) since
   rt_ui_every_desc's `fire` takes no instance argument -- an every-block
   is not tied to any one window type. */
static void bounce_tick(void)
{
    void *g;
    BounceState *st;
    short cw;

    g = rt_ui_front(&kBounceWindow);
    if (!g) return;
    st = (BounceState *)rt_ui_state(g);
    cw = rt_ui_widget_get_int(g, B_BOARD, RTUI_PROP_WIDTH);
    st->x = (short)(st->x + st->dx);
    if (st->x < 0) {
        st->x = 0;
        st->dx = (short)-st->dx;
    } else if (st->x + BOUNCE_SQUARE > cw) {
        st->x = (short)(cw - BOUNCE_SQUARE);
        st->dx = (short)-st->dx;
    }
    rt_ui_canvas_clear(g, B_BOARD);
    rt_ui_canvas_rect(g, B_BOARD, st->x, 60, BOUNCE_SQUARE, BOUNCE_SQUARE, 1);
}

static const rt_ui_every_desc kEvery[] = {
    { bounce_tick, 4 } /* 60/4 = 15 ticks/sec: clearly visible motion within a 1s window */
};

/* ==================== Probe menu (Task 2) ====================
 * "Toggle" is app-scope: always enabled, and it finds Probe.front itself.
 * "Scoped" is window-scoped to kProbeWindow: the runtime only enables it
 * while a Probe window is frontmost, and always calls it with that
 * instance directly. "Quit" is app-scope and ends the run -- see the file
 * header comment for why a menu Quit replaces Task 1's close-to-quit. */

static void probe_menu_toggle(void *frontInstOrNull)
{
    void *p;
    (void)frontInstOrNull; /* app-scope: always nil: this handler finds its own target */
    p = rt_ui_front(&kProbeWindow);
    if (p) probe_do_toggle(p);
}

static void probe_menu_scoped(void *frontInst)
{
    /* frontInst is guaranteed a live Probe instance: the runtime only
       calls a window-scoped handler while its scope is frontmost. */
    rt_ui_set_title(frontInst, (const unsigned char *)"\pScoped");
}

static void probe_menu_quit(void *frontInstOrNull)
{
    /* mac-target-4b final review: route through the real quit cascade
       (runtime/mac/rt_ui.c's rt_ui_quit) instead of exiting directly, for
       the same reason clarusc now lowers a UI program's `quit` to this
       call -- Probe/Bounce are both real rt_ui windows with no
       closeRequest handler of their own (probe_win_event's default case),
       so neither cancels; this Quit item now closes both (CLOSE/closed
       for each, front-to-back) before the run ends, where it previously
       ended the run without closing either. */
    (void)frontInstOrNull;
    rt_ui_quit();
}

static const rt_ui_item_desc kProbeMenuItems[] = {
    { "Toggle", (const unsigned char *)"\pToggle Check", 'T', 0 },
    { "Scoped", (const unsigned char *)"\pScoped Action", 'S', 0 },
    { "sep1",   (const unsigned char *)0,                 0,   1 },
    { "Quit",   (const unsigned char *)"\pQuit",           'Q', 0 }
};

static const rt_ui_menu_desc kProbeMenu = {
    "Probe", (const unsigned char *)"\pProbe", 4, kProbeMenuItems, 0
};

static const rt_ui_menu_handler kProbeMenuHandlers[] = {
    { probe_menu_toggle, "Probe", "Toggle", 0, 0, 0 },
    { probe_menu_scoped, "Probe", "Scoped", 0, 1, &kProbeWindow },
    { probe_menu_quit,   "Probe", "Quit",   0, 3, 0 }
};

/* ==================== TextProbe window (Task 1, mac-target-4c) ====================
 * Exercises RTUI_FIELD (with a `label:`) and RTUI_TEXTVIEW (`fill: both` +
 * RTUI_SCROLL_V) -- click-to-focus, typing via TEKey, a field's Return
 * firing `enter` (vs. a textview's Return inserting a newline), and the
 * mutation funnel's `change` trace/event. Both widgets are pushed well down
 * the window (y: 175/RTUI_BOTTOM in a 320x280 window) so their screen rects
 * fall entirely below Probe's (bottom 214) and Bounce's (bottom 204) own
 * content -- opened FIRST (see main(), below), so it starts furthest back
 * in z-order, but nothing else ever covers that lower band, keeping every
 * existing events.c click target (which never mentions TextProbe at all)
 * completely unaffected: front-to-back window order for Probe/Bounce is
 * unchanged from Task 1/2/3. */

enum { T_NAME = 0, T_BODY = 1 };

/* Proves a focused field's Return reaches app code as `enter` (rt_ui.c
   itself already emits the T FIRE trace and RTUI_WEV_CHANGE for both
   widgets' `change` automatically -- nothing extra needed for those). */
static void textprobe_widget_event(void *inst, short widgetIndex, short event, long a, long b)
{
    (void)a; (void)b;
    if (widgetIndex == T_NAME && event == RTUI_WEV_ENTER)
        rt_ui_set_title(inst, (const unsigned char *)"\pEntered");
}

static const rt_ui_widget_desc kTextProbeWidgets[] = {
    { RTUI_FIELD, "Name", (const unsigned char *)"\pName:",
      RTUI_AT_XY, 20, 175, 220, RTUI_FILL_NONE, 0 },
    { RTUI_TEXTVIEW, "Body", (const unsigned char *)0,
      RTUI_AT_XY, 20, RTUI_BOTTOM, RTUI_FILL, RTUI_FILL_BOTH, RTUI_SCROLL_V }
};

static const rt_ui_handlers kTextProbeHandlers = { 0, textprobe_widget_event };

static const rt_ui_window_desc kTextProbeWindow = {
    "TextProbe", (const unsigned char *)"\pText Probe",
    320, 280, 1, 250, 200,
    2, kTextProbeWidgets,
    0,
    &kTextProbeHandlers
};

/* ==================== PopupProbe window (Task 3, mac-target-4d) ====================
 * Exercises RTUI_POPUP end to end: a hand-rolled rt_field_desc/
 * rt_ui_form_desc pair (the same shapes clarusc's own lowering will emit,
 * Task 4/5) binds the "Color" popup to a 3-member enum (Red/Green/Blue);
 * "Get" reads the popup's current selection via rt_ui_widget_get_int and
 * writes the matching name into the "Result" label; "Set Red" calls
 * rt_ui_widget_set_int directly (RTUI_PROP_SELECTED, index 0) to prove the
 * setter's own clamp/redraw/trace WITHOUT a change event, independent of
 * any popup click. Opened LAST in main() (below) so it's frontmost at
 * startup -- no click-to-front step needed before its own widgets are
 * reachable, unlike TextProbe's own first click (see that window's header
 * comment). */

enum { PP_COLOR = 0, PP_GET = 1, PP_SETRED = 2, PP_RESULT = 3 };

static const unsigned char kColorRed[]   = "\pRed";
static const unsigned char kColorGreen[] = "\pGreen";
static const unsigned char kColorBlue[]  = "\pBlue";
/* Reused both as the popup's own item labels (via kColorField.enumLabels
   below) and, here in the probe, as the "Get" handler's index->name lookup
   for the Result label -- the same array serves both roles because a
   popup's displayed item text and a program's own reverse lookup are
   naturally the same list. */
static const unsigned char *const kColorNames[] = { kColorRed, kColorGreen, kColorBlue };
static const int32_t kColorValues[] = { 0, 1, 2 };

static const rt_field_desc kColorField = {
    RT_FT_ENUM, 0, 0, 3, kColorValues, kColorNames
};
static const rt_layout_desc kPopupLayout = { 0, 1, &kColorField };
static const rt_ui_bind_desc kPopupBinds[] = { { PP_COLOR, 0 } };
static const rt_ui_form_desc kPopupForm = { &kPopupLayout, 1, kPopupBinds };

static void popupprobe_widget_event(void *inst, short widgetIndex, short event, long a, long b)
{
    (void)a; (void)b;
    if (event != RTUI_WEV_CLICK) return;
    if (widgetIndex == PP_GET) {
        short sel = (short)rt_ui_widget_get_int(inst, PP_COLOR, RTUI_PROP_SELECTED);
        rt_ui_widget_set_str(inst, PP_RESULT, RTUI_PROP_TEXT, kColorNames[sel]);
    } else if (widgetIndex == PP_SETRED) {
        rt_ui_widget_set_int(inst, PP_COLOR, RTUI_PROP_SELECTED, 0);
    }
}

static const rt_ui_widget_desc kPopupProbeWidgets[] = {
    { RTUI_POPUP, "Color", (const unsigned char *)"\pColor:",
      RTUI_AT_XY, 20, 20, 0, RTUI_FILL_NONE, 0 },
    { RTUI_BUTTON, "Get", (const unsigned char *)"\pGet",
      RTUI_AT_XY, 20, RTUI_BOTTOM, 0, RTUI_FILL_NONE, 0 },
    { RTUI_BUTTON, "SetRed", (const unsigned char *)"\pSet Red",
      RTUI_AT_RIGHT, 0, 48, 0, RTUI_FILL_NONE, 0 },
    { RTUI_LABEL, "Result", (const unsigned char *)"\p-",
      RTUI_AT_XY, 20, RTUI_BOTTOM, RTUI_FILL, RTUI_FILL_NONE, 0 }
};

static const rt_ui_handlers kPopupProbeHandlers = { 0, popupprobe_widget_event };

static const rt_ui_window_desc kPopupProbeWindow = {
    "PopupProbe", (const unsigned char *)"\pPopup Probe",
    280, 120, 1, 200, 100,
    4, kPopupProbeWidgets,
    0,
    &kPopupProbeHandlers,
    &kPopupForm
};

/* ==================== TableProbe window (Task 4, mac-target-4d) ====================
 * Exercises RTUI_TABLE end to end: a hand-rolled record layout (STR/INT/
 * BOOL columns -- Name/Qty/Done, the same rt_field_desc shape PopupProbe's
 * bound enum already uses) over a plain rt_list seeded with 3 rows in
 * main(). "Add" pushes a 4th row directly onto that rt_list (liveness:
 * proves rt_ui_tables_sync picks it up with no table-specific mutation
 * call); "Remove" removes whatever row is currently selected (read via
 * rt_ui_widget_get_int's RTUI_PROP_SELECTED). The table's own SELECT/
 * DBLCLICK events are wired to rewrite the "Result" label with the
 * clicked row's name plus an S<row>/D<row> suffix -- ground truth for the
 * events script to verify against (rather than trusting pixel-coordinate
 * guesses alone), since the T FIRE trace line itself carries no row
 * number (`select`/`doubleClick`, same 2-part shape as every other
 * fire2 trace in this file). Opened LAST in main() (below) so it's
 * frontmost at startup -- no click-to-front step needed, same as
 * PopupProbe's own precedent. */

typedef struct { unsigned char name[21]; /* 1 len + 20 data bytes (strCap 20) */
                 int32_t qty; int32_t done; } TableRow;

static rt_list *gTableRows = NULL;

static const rt_field_desc kTableFields[] = {
    { RT_FT_STR,  20, offsetof(TableRow, name), 0, NULL, NULL },
    { RT_FT_INT,   0, offsetof(TableRow, qty),  0, NULL, NULL },
    { RT_FT_BOOL,  0, offsetof(TableRow, done), 0, NULL, NULL }
};
static const rt_layout_desc kTableLayout = { (long)sizeof(TableRow), 3, kTableFields };

static const unsigned char kColName[] = "\pName";
static const unsigned char kColQty[]  = "\pQty";
static const unsigned char kColDone[] = "\pDone";
static const rt_ui_col_desc kTableCols[] = {
    { kColName, 0,  1, 0 }, /* the one fill column */
    { kColQty,  60, 0, 1 },
    { kColDone, 50, 0, 2 }
};
static const rt_ui_table_desc kTableDesc = { &gTableRows, &kTableLayout, 3, kTableCols };

enum { TP_ADD = 0, TP_REMOVE = 1, TP_RESULT = 2, TP_TABLE = 3 };

/* n: 0..20, all this probe ever needs for a row name -- no sprintf, no
   rt_text, mirrors ui8_to_pstr's own "no libc" spirit above. */
static void set_pname(unsigned char *dst, const char *s)
{
    unsigned char n = 0;
    while (s[n] != '\0' && n < 20) { dst[1 + n] = (unsigned char)s[n]; n++; }
    dst[0] = n;
}

static void tableprobe_widget_event(void *inst, short widgetIndex, short event, long a, long b)
{
    (void)b;
    if (widgetIndex == TP_ADD && event == RTUI_WEV_CLICK) {
        TableRow row;
        set_pname(row.name, "Extra");
        row.qty = 40;
        row.done = 1;
        rt_list_push(gTableRows, &row);
    } else if (widgetIndex == TP_REMOVE && event == RTUI_WEV_CLICK) {
        short sel = (short)rt_ui_widget_get_int(inst, TP_TABLE, RTUI_PROP_SELECTED);
        if (sel >= 0) rt_list_remove(gTableRows, sel);
    } else if (widgetIndex == TP_TABLE && (event == RTUI_WEV_SELECT || event == RTUI_WEV_DBLCLICK)) {
        unsigned char out[32];
        unsigned char num[4];
        long count;
        unsigned char i;

        count = rt_list_count(gTableRows);
        if (a >= 0 && a < count) {
            TableRow *r = (TableRow *)rt_list_at(gTableRows, a);
            for (i = 0; i < r->name[0]; i++) out[1 + i] = r->name[1 + i];
            out[0] = r->name[0];
        } else {
            out[0] = 3; out[1] = 'O'; out[2] = 'O'; out[3] = 'R';
        }
        out[1 + out[0]] = ' ';
        out[0]++;
        out[1 + out[0]] = (unsigned char)(event == RTUI_WEV_SELECT ? 'S' : 'D');
        out[0]++;
        ui8_to_pstr(num, (int)a);
        for (i = 0; i < num[0]; i++) out[1 + out[0] + i] = num[1 + i];
        out[0] = (unsigned char)(out[0] + num[0]);
        rt_ui_widget_set_str(inst, TP_RESULT, RTUI_PROP_TEXT, out);
    }
}

static const rt_ui_widget_desc kTableProbeWidgets[] = {
    { RTUI_BUTTON, "Add", (const unsigned char *)"\pAdd",
      RTUI_AT_XY, 20, 20, 0, RTUI_FILL_NONE, 0 },
    { RTUI_BUTTON, "Remove", (const unsigned char *)"\pRemove",
      RTUI_AT_RIGHT, 0, 20, 0, RTUI_FILL_NONE, 0 },
    { RTUI_LABEL, "Result", (const unsigned char *)"\p-",
      RTUI_AT_XY, 20, RTUI_BOTTOM, RTUI_FILL, RTUI_FILL_NONE, 0 },
    { RTUI_TABLE, "Items", (const unsigned char *)0,
      RTUI_AT_XY, 20, RTUI_BOTTOM, RTUI_FILL, RTUI_FILL_BOTH, 0, (const void *)&kTableDesc }
};

static const rt_ui_handlers kTableProbeHandlers = { 0, tableprobe_widget_event };

static const rt_ui_window_desc kTableProbeWindow = {
    "TableProbe", (const unsigned char *)"\pTable Probe",
    320, 240, 1, 240, 160,
    4, kTableProbeWidgets,
    0,
    &kTableProbeHandlers
};

/* ==================== FormProbe / FormLauncher (Task 6, mac-target-4d) ====
 * Exercises rt_ui_edit end to end: FormProbe is a modal ("form") window
 * bound to a plain record (str/int/bool/enum fields -- the SAME
 * rt_field_desc shapes PopupProbe/TableProbe already use, per the task
 * brief's own scope) via rt_ui_form_desc/rt_ui_bind_desc. It is NEVER
 * opened at startup -- only via rt_ui_edit, triggered by FormLauncher's
 * one "Edit" button. FormLauncher opens LAST (frontmost at startup, same
 * precedent as PopupProbe/TableProbe -- no click-to-front step needed for
 * its own button). FormProbe is still listed in kWindows[] below (every
 * window TYPE needs to be, for the T OPEN/CLOSE/FRONT per-type instance
 * counter -- rt_ui_trace_next_id), even though `main` never rt_ui_opens it
 * directly.
 *
 * gFormRec/gFormEverAccepted model "the record this launcher edits":
 * first Edit click is isNew=1 (defaults); after any successful accept,
 * gFormEverAccepted flips true and the NEXT Edit reopens the now-real data
 * with isNew=0 -- both digits end up in FormLauncher's own Result label
 * (`T SET FormLauncher.Result.text ...`), so a script can verify isNew via
 * the ordinary golden-diffed trace, no new vocabulary needed for that
 * part. formprobe_win_event (FormProbe's OWN handler, called while gModal
 * is still active) does the actual writing: it looks up FormLauncher's
 * front instance the same way bounce_tick looks up Bounce's, since
 * RTUI_EV_ACCEPTED/CANCELLED only ever hand it FormProbe's own inst. */

typedef struct { unsigned char name[21]; /* 1 len + 20 data bytes (strCap 20) */
                 int32_t qty; int32_t active; int32_t color;
                 int32_t price; /* RT_FT_FIXED, 16.16 -- Fix round 1 coverage
                                    for rt_ui_parse_fixed's whole-number bug */
} FormRec;

static FormRec gFormRec;
static int gFormEverAccepted = 0;

static const rt_field_desc kFormFields[] = {
    { RT_FT_STR,   20, offsetof(FormRec, name),   0, NULL, NULL },
    { RT_FT_INT,    0, offsetof(FormRec, qty),    0, NULL, NULL },
    { RT_FT_BOOL,   0, offsetof(FormRec, active), 0, NULL, NULL },
    { RT_FT_ENUM,   0, offsetof(FormRec, color),  3, kColorValues, kColorNames },
    { RT_FT_FIXED,  0, offsetof(FormRec, price),  0, NULL, NULL }
};
static const rt_layout_desc kFormLayout = { (long)sizeof(FormRec), 5, kFormFields };

enum { F_NAME = 0, F_QTY = 1, F_ACTIVE = 2, F_COLOR = 3, F_PRICE = 4, F_OK = 5, F_CANCEL = 6 };

static const rt_ui_bind_desc kFormBinds[] = {
    { F_NAME, 0 }, { F_QTY, 1 }, { F_ACTIVE, 2 }, { F_COLOR, 3 }, { F_PRICE, 4 }
};
static const rt_ui_form_desc kFormForm = { &kFormLayout, 5, kFormBinds };

enum { FL_EDIT = 0, FL_RESULT = 1 };
static const rt_ui_window_desc kFormLauncherWindow; /* forward: formprobe_win_event needs it below */

/* Builds FormLauncher's Result text from the CURRENT gFormRec plus a tag
   ('A'ccepted/'C'ancelled) and, for accepted, isNew's digit -- no sprintf,
   no rt_text, same "no libc" spirit as ui8_to_pstr/build_status above.
   Qty is printed via ui8_to_pstr, so this probe only ever types small
   (0..99) quantities into FormProbe's Qty field. Price is printed via
   NumToString as the RAW 16.16 fixed int32 (not re-formatted through
   rt_ui_fixed_to_str) specifically so the trace shows the exact stored bit
   pattern -- Fix round 1's coverage for rt_ui_parse_fixed's whole-number
   bug wants to see "458752" (7<<16) for a typed "7", not "7.0000". */
static void build_form_result(unsigned char *out, char tag, int isNewFlag)
{
    unsigned char n = 0, i;
    out[1 + n++] = (unsigned char)tag;
    out[1 + n++] = ' ';
    for (i = 0; i < gFormRec.name[0]; i++) out[1 + n + i] = gFormRec.name[1 + i];
    n = (unsigned char)(n + gFormRec.name[0]);
    out[1 + n++] = ' ';
    {
        unsigned char num[4];
        ui8_to_pstr(num, (int)gFormRec.qty);
        for (i = 0; i < num[0]; i++) out[1 + n + i] = num[1 + i];
        n = (unsigned char)(n + num[0]);
    }
    out[1 + n++] = ' ';
    out[1 + n++] = (unsigned char)(gFormRec.active ? 'Y' : 'N');
    out[1 + n++] = ' ';
    out[1 + n++] = (unsigned char)('0' + gFormRec.color);
    out[1 + n++] = ' ';
    {
        Str255 pricebuf;
        NumToString((long)gFormRec.price, pricebuf);
        for (i = 0; i < pricebuf[0]; i++) out[1 + n + i] = pricebuf[1 + i];
        n = (unsigned char)(n + pricebuf[0]);
    }
    if (tag == 'A') {
        out[1 + n++] = ' ';
        out[1 + n++] = (unsigned char)('0' + isNewFlag);
    }
    out[0] = n;
}

static void formprobe_win_event(void *inst, short event, long a, long b)
{
    void *launcher;
    unsigned char result[48];

    (void)a; (void)b;
    launcher = rt_ui_front(&kFormLauncherWindow);
    if (event == RTUI_EV_ACCEPTED) {
        gFormEverAccepted = 1;
        build_form_result(result, 'A', rt_ui_form_is_new());
        if (launcher) rt_ui_widget_set_str(launcher, FL_RESULT, RTUI_PROP_TEXT, result);
    } else if (event == RTUI_EV_CANCELLED) {
        static const unsigned char kCancelled[] = "\pCancelled";
        if (launcher) rt_ui_widget_set_str(launcher, FL_RESULT, RTUI_PROP_TEXT, kCancelled);
    }
    (void)inst;
}

static const rt_ui_handlers kFormHandlers = { formprobe_win_event, 0 };

static const rt_ui_widget_desc kFormWidgets[] = {
    { RTUI_FIELD, "Name", (const unsigned char *)"\pName:",
      RTUI_AT_XY, 20, 20, 200, RTUI_FILL_NONE, 0 },
    { RTUI_FIELD, "Qty", (const unsigned char *)"\pQty:",
      RTUI_AT_XY, 20, RTUI_BOTTOM, 200, RTUI_FILL_NONE, 0 },
    { RTUI_CHECK, "Active", (const unsigned char *)"\pActive",
      RTUI_AT_XY, 20, RTUI_BOTTOM, 0, RTUI_FILL_NONE, 0 },
    { RTUI_POPUP, "Color", (const unsigned char *)"\pColor:",
      RTUI_AT_XY, 20, RTUI_BOTTOM, 0, RTUI_FILL_NONE, 0 },
    { RTUI_FIELD, "Price", (const unsigned char *)"\pPrice:",
      RTUI_AT_XY, 20, RTUI_BOTTOM, 200, RTUI_FILL_NONE, 0 },
    { RTUI_BUTTON, "OK", (const unsigned char *)"\pOK",
      RTUI_AT_XY, 20, RTUI_BOTTOM, 80, RTUI_FILL_NONE, RTUI_DEFAULT },
    { RTUI_BUTTON, "Cancel", (const unsigned char *)"\pCancel",
      RTUI_AT_RIGHT, 0, 156, 80, RTUI_FILL_NONE, RTUI_CANCEL }
};

static const rt_ui_window_desc kFormWindow = {
    "FormProbe", (const unsigned char *)"\pForm Probe",
    280, 200, 0, 0, 0,
    7, kFormWidgets,
    0,
    &kFormHandlers,
    &kFormForm
};

static void formlauncher_widget_event(void *inst, short widgetIndex, short event, long a, long b)
{
    (void)inst; (void)a; (void)b;
    if (widgetIndex == FL_EDIT && event == RTUI_WEV_CLICK) {
        rt_ui_edit(&kFormWindow, &gFormRec, (short)!gFormEverAccepted,
                   RT_UI_WB_ADDR, &gFormRec, NULL, 0, NULL, NULL);
    }
}

static const rt_ui_widget_desc kFormLauncherWidgets[] = {
    { RTUI_BUTTON, "Edit", (const unsigned char *)"\pEdit",
      RTUI_AT_XY, 20, 20, 0, RTUI_FILL_NONE, 0 },
    { RTUI_LABEL, "Result", (const unsigned char *)"\p-",
      RTUI_AT_XY, 20, RTUI_BOTTOM, RTUI_FILL, RTUI_FILL_NONE, 0 }
};

static const rt_ui_handlers kFormLauncherHandlers = { 0, formlauncher_widget_event };

static const rt_ui_window_desc kFormLauncherWindow = {
    "FormLauncher", (const unsigned char *)"\pForm Launcher",
    240, 100, 0, 0, 0,
    2, kFormLauncherWidgets,
    0,
    &kFormLauncherHandlers
};

/* ==================== wiring ==================== */

static const rt_ui_window_desc *kWindows[] = { &kTextProbeWindow, &kProbeWindow, &kBounceWindow, &kPopupProbeWindow, &kTableProbeWindow, &kFormWindow, &kFormLauncherWindow };
static const rt_ui_menu_desc *kMenus[] = { &kProbeMenu };

int main(void)
{
    rt_args_init(0, (char **)0);
    rt_ui_startup(kWindows, 7, kMenus, 1, kProbeMenuHandlers, 3, kEvery, 1);
    /* TextProbe opens FIRST -- Probe-then-Bounce below is the exact same
       relative open order Task 1/2/3 already had, so Bounce is still
       frontmost at startup, exactly as events.c's own header comment
       documents (TextProbe, opened even earlier, ends up furthest back).
       PopupProbe (Task 3) opens next-to-last; TableProbe (Task 4) then
       FormLauncher (Task 6) open LAST -- FormLauncher ends up frontmost,
       so events_form.c's clicks land on it (and, once opened, FormProbe
       itself) without a click-to-front step, same precedent PopupProbe/
       TableProbe already set. FormProbe is never rt_ui_open'd here at all
       -- only via rt_ui_edit, from FormLauncher's own Edit button. */
    gTableRows = rt_list_new((int32_t)sizeof(TableRow));
    {
        TableRow r;
        set_pname(r.name, "Alpha"); r.qty = 10; r.done = 0; rt_list_push(gTableRows, &r);
        set_pname(r.name, "Beta");  r.qty = 20; r.done = 1; rt_list_push(gTableRows, &r);
        set_pname(r.name, "Gamma"); r.qty = 30; r.done = 0; rt_list_push(gTableRows, &r);
    }
    set_pname(gFormRec.name, "");
    gFormRec.qty = 0;
    gFormRec.active = 0;
    gFormRec.color = 0;
    gFormRec.price = 0;
    rt_ui_open(&kTextProbeWindow);
    rt_ui_open(&kProbeWindow);
    rt_ui_open(&kBounceWindow);
    rt_ui_open(&kPopupProbeWindow);
    rt_ui_open(&kTableProbeWindow);
    rt_ui_open(&kFormLauncherWindow);
    rt_ui_run();
    return 0;
}
