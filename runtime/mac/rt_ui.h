/* runtime/mac/rt_ui.h -- ABI for the Clarus classic-Mac UI runtime (windows,
   widgets, menus, canvas, timers). This is the pinned contract from
   docs/superpowers/plans/2026-07-24-mac-target-4b.md ("Contracts pinned by
   this plan"): struct layouts and function names are consumed identically
   by hand-written C (internal/mactest/uiprobe/probe_ui.c, Task 1) and by
   clarusc's emitted C (Tasks 4-5) -- do not rename or reorder fields
   without updating the plan.

   Menus (Chapter 9), canvas (Chapter 11 subset), and timers (`every`) are
   declared here in full per the contract; rt_ui.c gives them working
   bodies except where explicitly a Task 2 stub (see rt_ui.c's comments). */
#ifndef CLARUS_RT_UI_H
#define CLARUS_RT_UI_H

/* ==================== kinds, layout sentinels, flags (RTUI_*) ====================
 * Not all of these constants are individually spelled out in the plan's
 * ABI sketch (only the *fields* that hold them are pinned); the specific
 * integer values below are this task's implementation choice, free to
 * pick since nothing outside rt_ui.c/rt_ui.h and its callers inspects the
 * raw numbers. */

/* rt_ui_widget_desc.kind */
#define RTUI_BUTTON 0
#define RTUI_CHECK  1
#define RTUI_CANVAS 2
#define RTUI_LABEL  3

/* rt_ui_widget_desc.atKind (Ch8 Layout: "at x,y" / "at right,y" / "at next,bottom") */
#define RTUI_AT_XY    0   /* x, y both explicit */
#define RTUI_AT_NEXT  1   /* x = previous widget's x; y = RTUI_BOTTOM or explicit */
#define RTUI_AT_RIGHT 2   /* x = previous widget's right edge + gap; y explicit */

/* rt_ui_widget_desc.y sentinel, meaningful only with RTUI_AT_NEXT */
#define RTUI_BOTTOM (-1)

/* rt_ui_widget_desc.width sentinel (Ch8: "width: fill") */
#define RTUI_FILL (-1)

/* rt_ui_widget_desc.fill (Ch8: "fill: both") */
#define RTUI_FILL_NONE 0
#define RTUI_FILL_BOTH 1

/* rt_ui_widget_desc.flags (bitmask) */
#define RTUI_DEFAULT  1   /* button: wires the Return key (Ch8) */
#define RTUI_CANCEL   2   /* button: wires the Escape key (Ch8) */
#define RTUI_BUFFERED 4   /* canvas: offscreen GrafPort (Ch11, Task 2) */

/* rt_ui_handlers.winEvent `event` values (Ch8 Window Events) */
#define RTUI_EV_OPENED       0
#define RTUI_EV_CLOSEREQUEST 1  /* a = (long)&int cancelFlag; handler sets *cancelFlag=1 to cancel */
#define RTUI_EV_CLOSED       2
#define RTUI_EV_RESIZED      3
#define RTUI_EV_KEY          4  /* a = the typed char */

/* rt_ui_handlers.widget `event` values (Ch8 widget Events column) */
#define RTUI_WEV_CLICK  0        /* button */
#define RTUI_WEV_CHANGE 1        /* check: a = new bool value (0/1) */
#define RTUI_WEV_DRAG   2        /* canvas (Task 2): a = x, b = y */

/* `prop` values for rt_ui_widget_get/set_* -- one per Ch8 runtime-property
 * cell; not individually spelled out in the plan's ABI sketch either, same
 * free-to-pick status as the kind/flags constants above. */
#define RTUI_PROP_CAPTION  0   /* button */
#define RTUI_PROP_TEXT     1   /* label (field/textview in later tasks) */
#define RTUI_PROP_ENABLED  2   /* button */
#define RTUI_PROP_CHECKED  3   /* check */
#define RTUI_PROP_SELECTED 4   /* popup, table (later tasks) */
#define RTUI_PROP_WIDTH    5   /* canvas */
#define RTUI_PROP_HEIGHT   6   /* canvas */

/* ==================== descriptors (static const in emitted C / probe) ==================== */

typedef struct { short kind;              /* RTUI_BUTTON/CHECK/CANVAS/LABEL */
                 const char *name;        /* widget name for traces */
                 const unsigned char *caption;  /* Str255 or NULL */
                 short atKind, x, y;      /* RTUI_AT_XY/NEXT/RIGHT; y or RTUI_BOTTOM */
                 short width;             /* px, or RTUI_FILL */
                 short fill;              /* RTUI_FILL_NONE/BOTH */
                 short flags;             /* RTUI_DEFAULT|RTUI_CANCEL|RTUI_BUFFERED */
} rt_ui_widget_desc;

typedef struct { const char *name; const unsigned char *title;  /* Str255 */
                 short w, h; short resizable, minW, minH;
                 short nWidgets; const rt_ui_widget_desc *widgets;
                 short stateSize;         /* per-instance user-var struct size */
                 const struct rt_ui_handlers *handlers; } rt_ui_window_desc;

typedef struct { const char *name; const unsigned char *title;
                 short nItems; const struct rt_ui_item_desc *items; } rt_ui_menu_desc;

typedef struct rt_ui_item_desc { const char *name; const unsigned char *label;
                 unsigned char key; short separator; } rt_ui_item_desc;

/* handler tables: entries may be NULL */
typedef struct rt_ui_handlers {
  void (*winEvent)(void *inst, short event, long a, long b); /* RTUI_EV_* */
  void (*widget)(void *inst, short widgetIndex, short event, long a, long b);
} rt_ui_handlers;

typedef struct { void (*fire)(void); long ticks; } rt_ui_every_desc;

typedef struct { void (*fire)(void *frontInstOrNull); const char *menu, *item;
                 short menuIndex, itemIndex; const rt_ui_window_desc *scope; } rt_ui_menu_handler;

/* ==================== runtime API (called by emitted code / probe) ==================== */

void  rt_ui_startup(const rt_ui_window_desc **wins, short nWins,
                    const rt_ui_menu_desc **menus, short nMenus,
                    const rt_ui_menu_handler *mh, short nMh,
                    const rt_ui_every_desc *ev, short nEv);
void  rt_ui_run(void);                       /* the event loop; returns on quit */
void *rt_ui_open(const rt_ui_window_desc *d);        /* `open W`  -> instance */
void  rt_ui_close(void *inst);                       /* `close w` */
void *rt_ui_front(const rt_ui_window_desc *d);       /* `W.front`, NULL if none */
void *rt_ui_state(void *inst);                       /* per-instance user vars */
void  rt_ui_set_title(void *inst, const unsigned char *s);
void  rt_ui_widget_set_str(void *inst, short wIdx, short prop, const unsigned char *s);
void  rt_ui_widget_set_bool(void *inst, short wIdx, short prop, int v);
int   rt_ui_widget_get_bool(void *inst, short wIdx, short prop);
short rt_ui_widget_get_int(void *inst, short wIdx, short prop);  /* canvas width/height */
void  rt_ui_menu_enable(short menuIdx, short itemIdx, int on);
/* canvas ops (Ch11 subset used by bounce + demos) */
void  rt_ui_canvas_clear(void *inst, short wIdx);
void  rt_ui_canvas_fill_circle(void *inst, short wIdx, short x, short y, short r);
void  rt_ui_canvas_line(void *inst, short wIdx, short x0, short y0, short x1, short y1);
void  rt_ui_canvas_rect(void *inst, short wIdx, short x, short y, short w, short h, int fill);

#endif /* CLARUS_RT_UI_H */
