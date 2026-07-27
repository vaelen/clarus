/* runtime/mac/rt_ui.h -- ABI for the Clarus classic-Mac UI runtime (windows,
   widgets, menus, canvas, timers). This is the pinned contract from
   docs/superpowers/plans/2026-07-24-mac-target-4b.md ("Contracts pinned by
   this plan"): struct layouts and function names are consumed identically
   by hand-written C (internal/mactest/uiprobe/probe_ui.c, Task 1) and by
   clarusc's emitted C (Tasks 4-5) -- do not rename or reorder fields
   without updating the plan.

   Menus (Chapter 9), canvas (Chapter 11), and timers (`every`) are declared
   here and given working bodies in rt_ui.c as of Task 2. The canvas op list
   below was amended against Ch11 during Task 2 (see the comment just above
   the canvas prototypes) -- `rt_ui_canvas_circle` and
   `rt_ui_canvas_draw_text` are additions beyond this plan's original ABI
   sketch, per the plan's own "the reference wins" rule.

   mac-target-4d Task 3 adds RTUI_POPUP (the System 6 manual PopUpMenuSelect
   path), rt_ui_widget_set_int, and the form/bind descriptors a popup uses
   to find its bound enum's labels (rt_ui_form_desc/rt_ui_bind_desc, below).
   Both rt_ui_widget_desc and rt_ui_window_desc gained ONE new field each,
   appended at the END of the struct (`extra` and `form` respectively) --
   every existing positional initializer (probe and emitted C alike) still
   compiles unchanged, the new trailing field simply zero-inits. Do the same
   for any FUTURE addition to either struct: append, never insert.

   mac-target-4d Task 4 adds RTUI_TABLE (the List Manager, JMP-stub LDEF):
   a table widget's `extra` (unused by every other kind so far) is a
   `const rt_ui_table_desc *` -- its own column list and a pointer to the
   rt_list* holding its rows, below. RTUI_WEV_SELECT/RTUI_WEV_DBLCLICK join
   the widget-event vocabulary; RTUI_PROP_SELECTED (already popup's) is
   reused for a table's current row. rt_ui_tables_sync (below) is the one
   new runtime-API entry point: it re-syncs every open table's native List
   Manager row count to its bound rt_list's current count, called from both
   event loops (rt_ui.c) so a program that push/removes rows never needs to
   poke the table itself. */
#ifndef CLARUS_RT_UI_H
#define CLARUS_RT_UI_H

#include <stdint.h> /* uint8_t -- rt_ui_launch's openDoc fnptr (mac-target-4c Task 5).
                        Safe to include unconditionally: rt_ui.c includes this header
                        BEFORE rt.h (which also pulls stdint.h), and every OTHER caller
                        (clarusc's emitted C) already includes rt.h first anyway -- this
                        is the one file-header addition needed to make rt_ui.c's own
                        (reversed) include order still see uint8_t at this point. */

/* ==================== kinds, layout sentinels, flags (RTUI_*) ====================
 * Not all of these constants are individually spelled out in the plan's
 * ABI sketch (only the *fields* that hold them are pinned); the specific
 * integer values below are this task's implementation choice, free to
 * pick since nothing outside rt_ui.c/rt_ui.h and its callers inspects the
 * raw numbers. */

/* rt_ui_widget_desc.kind */
#define RTUI_BUTTON   0
#define RTUI_CHECK    1
#define RTUI_CANVAS   2
#define RTUI_LABEL    3
#define RTUI_FIELD    4   /* single-line TextEdit, `label:` reuses the caption slot (mac-target-4c Task 1) */
#define RTUI_TEXTVIEW 5   /* multi-line TextEdit, optional scrollbar via flags below */
#define RTUI_POPUP    6   /* System 6 popup menu (manual PopUpMenuSelect path), mac-target-4d Task 3 */
#define RTUI_TABLE    7   /* List Manager-backed table (JMP-stub LDEF), mac-target-4d Task 4 */

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
#define RTUI_SCROLL_V 8   /* textview: vertical scrollbar (mac-target-4c Task 1) */
#define RTUI_SCROLL_H 16  /* textview: horizontal scrollbar (window-zoom-hscroll Task 2).
                             Implies no word wrap: the TE is created crOnly (lines break
                             only at CR) with a fixed RTUI_TE_NOWRAP_W-wide destRect, the
                             classic wrap-off + wide-dest TE idiom -- but the scroll RANGE
                             (fix-hbar) tracks the widest line, not that fixed destRect
                             width: content that fits the view leaves the bar dimmed
                             (thumbless), and the view auto-scrolls to keep the caret
                             visible (TEAutoView). */

/* rt_ui_handlers.winEvent `event` values (Ch8 Window Events) */
#define RTUI_EV_OPENED       0
#define RTUI_EV_CLOSEREQUEST 1  /* a = (long)&long cancelFlag; handler sets *cancelFlag=1 to cancel */
#define RTUI_EV_CLOSED       2
#define RTUI_EV_RESIZED      3
#define RTUI_EV_KEY          4  /* a = the typed char */

/* rt_ui_handlers.widget `event` values (Ch8 widget Events column) */
#define RTUI_WEV_CLICK  0        /* button */
#define RTUI_WEV_CHANGE 1        /* check: a = new bool value (0/1); field/textview: content changed */
#define RTUI_WEV_DRAG   2        /* canvas (Task 2): a = x, b = y */
#define RTUI_WEV_ENTER  3        /* field (mac-target-4c Task 1): Return/Enter pressed while
                                    focused -- no character is inserted; textview's Return
                                    inserts a CR instead and never fires this event */
#define RTUI_WEV_SELECT   4     /* table (mac-target-4d Task 4): a = row index clicked/selected */
#define RTUI_WEV_DBLCLICK 5     /* table (mac-target-4d Task 4): a = row index double-clicked;
                                    always preceded by its own RTUI_WEV_SELECT (select fires
                                    first, matching real-Mac click-then-double semantics) */

/* TextEdit content cap (mac-target-4c Task 1): every field/textview mutation
   path (TEKey, cut/paste, rt_ui_widget_set_str/set_text) clamps to this many
   bytes and calls rt_set_lasterr (rt.h) on truncation -- pinned by the plan,
   not derived from any Toolbox limit (TextEdit's own ~32K-line-table ceiling
   is unrelated and much larger). */
#define RTUI_TE_MAX 32000

/* `prop` values for rt_ui_widget_get/set_* -- one per Ch8 runtime-property
 * cell; not individually spelled out in the plan's ABI sketch either, same
 * free-to-pick status as the kind/flags constants above. */
#define RTUI_PROP_CAPTION  0   /* button */
#define RTUI_PROP_TEXT     1   /* label; field (string, via *_get_str/set_str); textview (rt_text, via *_get_text/set_text) */
#define RTUI_PROP_ENABLED  2   /* button */
#define RTUI_PROP_CHECKED  3   /* check */
#define RTUI_PROP_SELECTED 4   /* popup; table (mac-target-4d Task 4): current row, -1 if none */
#define RTUI_PROP_WIDTH    5   /* canvas */
#define RTUI_PROP_HEIGHT   6   /* canvas */

/* ==================== descriptors (static const in emitted C / probe) ==================== */

typedef struct { short kind;              /* RTUI_BUTTON/CHECK/CANVAS/LABEL/FIELD/TEXTVIEW
                                              (FIELD/TEXTVIEW added mac-target-4c Task 1) */
                 const char *name;        /* widget name for traces */
                 const unsigned char *caption;  /* Str255 or NULL */
                 short atKind, x, y;      /* RTUI_AT_XY/NEXT/RIGHT; y or RTUI_BOTTOM */
                 short width;             /* px, or RTUI_FILL */
                 short fill;              /* RTUI_FILL_NONE/BOTH */
                 short flags;             /* RTUI_DEFAULT|RTUI_CANCEL|RTUI_BUFFERED|RTUI_SCROLL_V|RTUI_SCROLL_H
                                              (RTUI_SCROLL_V/H added mac-target-4c Task 1) */
                 const void *extra;       /* mac-target-4d Task 3: reserved for a future per-kind
                                              descriptor; RTUI_POPUP leaves this NULL and finds its
                                              items via the OWNING WINDOW's `form` field instead
                                              (rt_ui_window_desc, below), not through this pointer.
                                              mac-target-4d Task 4: RTUI_TABLE is the first kind to
                                              actually use it -- a `const rt_ui_table_desc *` (below). */
} rt_ui_widget_desc;

typedef struct { const char *name; const unsigned char *title;  /* Str255 */
                 short w, h; short resizable, minW, minH;
                 short nWidgets; const rt_ui_widget_desc *widgets;
                 short stateSize;         /* per-instance user-var struct size */
                 const struct rt_ui_handlers *handlers;
                 const struct rt_ui_form_desc *form; /* mac-target-4d Task 3: NULL = not a form (no
                                                          popup in this window can find bound enum
                                                          labels); see rt_ui_form_desc below. */
} rt_ui_window_desc;

typedef struct { const char *name; const unsigned char *title;
                 short nItems; const struct rt_ui_item_desc *items;
                 short standardEdit; /* mac-target-4c Task 3: `menu M { standard edit }` --
                                        nItems/items are 0/NULL for such a menu (the runtime
                                        builds Undo/Cut/Copy/Paste/Clear itself); every OTHER
                                        menu emits standardEdit 0 with its normal items array. */
} rt_ui_menu_desc;

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

/* The (at most one) `app` section (Ch7 Application Identity): name/version/
 * author/about, each a Str255 or the empty Pascal string ("\p", len 0)
 * when the property (or the whole `app` section) is absent -- icon/id are
 * build-time-only (app icon resource, bundle/creator code) and never reach
 * this struct. clarusc emits a strong `rt_ui_app_info` only when the
 * program declares an `app` section at all (Task 2); rt_ui.c's weak
 * default below covers every other program. */
typedef struct rt_ui_app_desc {
    const unsigned char *name;     /* Pascal; len 0 = no app section */
    const unsigned char *version;
    const unsigned char *author;
    const unsigned char *about;
} rt_ui_app_desc;
extern const rt_ui_app_desc rt_ui_app_info;

/* Opaque forward declaration ONLY -- textview's `text` runtime property is
   an rt_text* (internal/build/rt/rt.h's growable byte buffer), but this
   header must never #include rt.h (rt_ui.c includes both directly; see its
   own file header). rt_ui_widget_get_text/set_text below are the only
   entry points that touch it, both by pointer, so the incomplete type is
   enough for callers too (mac-target-4c Task 1). */
typedef struct rt_text rt_text;

/* Opaque forward declaration ONLY, same convention as rt_text above --
   rt_layout_desc/rt_field_desc are internal/build/rt/rt.h's record-layout
   descriptors (mac-target-4d Task 1); this header must never #include
   rt.h, so a popup's form binding below refers to it only by pointer.
   rt_ui.c (and any hand-written caller, e.g. uiprobe) sees the full struct
   by including rt.h directly alongside this header. */
typedef struct rt_layout_desc rt_layout_desc;

/* Popup binding (mac-target-4d Task 3, Ch8): a `form`'s `binds` array pairs
   a window's popup WIDGET index with the FIELD index (into its `layout`)
   whose bound enum supplies that popup's item labels -- rt_ui_make_widgets
   finds the bind whose widgetIndex matches, then reads
   layout->fields[fieldIndex].enumLabels/enumCount (rt.h's rt_field_desc)
   to build the native menu. A popup in a window with a NULL `form`, or with
   no matching bind, draws empty rather than crashing -- the compiler is
   expected to reject that shape before it ever reaches here (a later task),
   so this runtime stays defensive only, not a validator. */
typedef struct { short widgetIndex; short fieldIndex; } rt_ui_bind_desc;
typedef struct rt_ui_form_desc { const rt_layout_desc *layout;
                                 short nBinds; const rt_ui_bind_desc *binds; } rt_ui_form_desc;

/* Opaque forward declarations ONLY, same convention as rt_text/rt_layout_desc
   above -- rt_list is internal/build/rt/rt.h's growable-array type (a
   table's rows); rt_map is forward-declared alongside it for the same
   future-proofing reason as rt_text (no widget needs it yet, but this
   header must never #include rt.h to find out later). rt_ui.c and any
   hand-written caller (uiprobe) see the full definitions by including
   rt.h directly alongside this header (mac-target-4d Task 4). */
typedef struct rt_list rt_list;
typedef struct rt_map  rt_map;

/* Table column (mac-target-4d Task 4, Ch8): `header` is a Str255 drawn in
   the header strip; `widthPx` is a fixed pixel width; `widthFill` marks
   the (at most one) column that instead absorbs whatever width is left
   over after every fixed column (view width - sum of fixed widthPx) --
   widthPx is ignored on a widthFill column. `fieldIndex` indexes the
   bound rt_layout_desc's `fields` array (the SAME rt_field_desc shape a
   popup's bound enum already uses), telling the runtime both the value's
   type (rt_field_desc.ftype: STR/INT/FIXED/BOOL/CHAR/ENUM, each rendered
   differently) and its byte offset into one row record. */
typedef struct { const unsigned char *header; short widthPx; short widthFill;
                 short fieldIndex; } rt_ui_col_desc;
/* A table's `extra` (rt_ui_widget_desc, above): `rows` is a pointer to the
   PROGRAM's own rt_list* variable (double indirection, not the list
   itself) so the runtime always re-reads the CURRENT list via `*rows` --
   never caches a stale rt_list* across calls, since the list can grow/move
   (Handle-backed) or be reassigned by the program between draws. */
typedef struct rt_ui_table_desc { rt_list **rows; const rt_layout_desc *layout;
                                  short nCols; const rt_ui_col_desc *cols; } rt_ui_table_desc;

/* ==================== runtime API (called by emitted code / probe) ==================== */

/* PORT DISCIPLINE RULE: every rt_ui entry point below that touches
 * QuickDraw/Control Manager state (the widget/canvas setters and getters
 * that draw or invalidate) self-asserts the correct GrafPort with
 * GetPort/SetPort and restores the CALLER's port before returning. Nothing
 * here may assume "the current port is already correct" on entry, and
 * nothing here may leave the port changed on exit -- a widget click
 * happens to already have the right port set by the time it dispatches,
 * but a menu handler or an `every` block can run with any port current
 * (mid-canvas-draw, a different window, ...), and Task 3's scripted
 * dispatch and Tasks 4-5's emitted call sites get no other guarantee than
 * this one. This is not ambient behavior to preserve by convention -- it
 * is an explicit contract every future rt_ui.c entry point in this
 * category must keep.
 */
void  rt_ui_startup(const rt_ui_window_desc **wins, short nWins,
                    const rt_ui_menu_desc **menus, short nMenus,
                    const rt_ui_menu_handler *mh, short nMh,
                    const rt_ui_every_desc *ev, short nEv);
void  rt_ui_run(void);                       /* the event loop; returns on quit */
/* rt_ui_launch (mac-target-4c Task 5, Ch7): called once at startup, AFTER
 * rt_ui_startup and the program's own App.launch handler, and BEFORE
 * rt_ui_run -- decides openDocument-vs-startEmpty, the same call for every
 * build: RT_MAC_TEST dispatches the compiled-in script's `launchdoc <path>`
 * lines (one openDoc call per line, in order; none at all -> startEmpty);
 * a real System 7+ build with AppleEvents (Gestalt + this app's own SIZE(-1)
 * isHighLevelEventAware bit) installs AEInstallEventHandler for
 * oapp/odoc/pdoc/quit and returns immediately WITHOUT calling either --
 * the Finder's first AppleEvent decides, once, later; a real System 6 (or
 * non-HLE-aware) build uses CountAppFiles/GetAppFiles, which only ever
 * fires at launch (Ch7's Mac note: documents dropped on a running System 6
 * app never arrive at all -- that needs AppleEvents, hence System 7+).
 * openDoc/startEmpty are each the program's own handler or 0 (absent);
 * either being 0 is a normal, supported shape, not an error -- rt_ui.c
 * documents the exact fallback each dispatch path takes when openDoc is 0
 * but the launch actually carried documents. */
void  rt_ui_launch(void (*openDoc)(const uint8_t *path255), void (*startEmpty)(void));
void *rt_ui_open(const rt_ui_window_desc *d);        /* `open W`  -> instance */
void  rt_ui_close(void *inst);                       /* `close w` */
/* `quit` in a UI program (reference doc's Quit Semantics, normative,
 * ~line 767): sends closeRequest to every open window, front-to-back
 * (the exact cascade rt_ui_close's own closeRequest/closed pair uses, one
 * window at a time). Any handler that cancels aborts the WHOLE quit and
 * leaves the app running -- windows already closed earlier in the same
 * pass stay closed; windows not yet visited stay open. If nothing
 * cancels, every window ends up closed and the app exits (rt_quit(0), the
 * same primitive a non-UI `quit` already compiles to). clarusc lowers
 * `quit` to a call to this function in any program that declares a
 * window/menu; the RT_MAC_TEST scripted `quit` verb and script exhaustion
 * (rt_ui.c) call it too -- there is exactly one quit-cascade
 * implementation, not a scripted-mode copy of it. Does not touch the
 * QuickDraw port itself (DisposeWindow does, transitively, same as
 * rt_ui_close already accepts) -- not a PORT DISCIPLINE RULE entry point
 * by the definition above, since it draws nothing of its own. */
void  rt_ui_quit(void);
void *rt_ui_front(const rt_ui_window_desc *d);       /* `W.front`, NULL if none */
void *rt_ui_state(void *inst);                       /* per-instance user vars */
void  rt_ui_set_title(void *inst, const unsigned char *s);
void  rt_ui_get_title(void *inst, unsigned char *dst255);    /* GetWTitle, fill-in-place */
void  rt_ui_widget_set_str(void *inst, short wIdx, short prop, const unsigned char *s);
/* rt_ui_widget_get_str (mac-target-4c Task 1): fill-in-place read of a
   Str255-shaped runtime property -- currently only RTUI_FIELD's
   RTUI_PROP_TEXT (no existing dispatcher reads back a widget's string; the
   label/button captions were write-only before this task). dst255 must
   have room for a full Str255 (256 bytes); a no-match (wrong kind/prop)
   writes a length-0 Pascal string rather than leaving dst255 untouched. */
void  rt_ui_widget_get_str (void *inst, short wIdx, short prop, unsigned char *dst255);
/* rt_ui_widget_get_text/set_text (mac-target-4c Task 1): textview's
   RTUI_PROP_TEXT, bridged to/from the TE's own byte buffer via
   rt_text_from_bytes/rt_text_to_bytes (rt.h) -- `out`/`t` are never NULL.
   set_text clamps to RTUI_TE_MAX and calls rt_set_lasterr (rt.h) on
   truncation, then runs the same clamp/scrollbar-recompute funnel TEKey/
   cut/paste use -- but, being a PROGRAMMATIC set, fires neither the
   `T FIRE <Win>.<W>.change` trace nor RTUI_WEV_CHANGE (final review fix,
   mac-target-4c: only a real user edit does; see rt_ui.c's rt_ui_te_mutated). */
void  rt_ui_widget_get_text(void *inst, short wIdx, rt_text *out);
void  rt_ui_widget_set_text(void *inst, short wIdx, const rt_text *t);
void  rt_ui_widget_set_bool(void *inst, short wIdx, short prop, int v);
int   rt_ui_widget_get_bool(void *inst, short wIdx, short prop);
short rt_ui_widget_get_int(void *inst, short wIdx, short prop);  /* canvas width/height; popup SELECTED (mac-target-4d Task 3) */
/* rt_ui_widget_set_int (mac-target-4d Task 3): popup's RTUI_PROP_SELECTED
   only so far -- clamps v to [0, item count - 1], redraws (InvalRect), and
   traces `T SET <Win>.<W>.selected <v>` under RT_MAC_TEST, but fires NEITHER
   the change trace NOR RTUI_WEV_CHANGE (same "a PROGRAMMATIC set doesn't
   fire `change`" rule as set_str/set_text/set_bool -- only an actual user
   pick through the popup does). */
void  rt_ui_widget_set_int(void *inst, short wIdx, short prop, long v);
/* rt_ui_tables_sync (mac-target-4d Task 4): re-syncs every OPEN table's
   native List Manager row count to its bound rt_list's CURRENT
   rt_list_count -- a program pushes/removes rows on its own rt_list
   directly (no table-specific mutation API), so this is what makes that
   change actually visible. Called by rt_ui.c itself at the loop-bottom of
   both the real WaitNextEvent loop and the RT_MAC_TEST scripted pump, so
   callers never need to invoke it directly; exposed here only because it
   is, structurally, a normal runtime-API entry point like every other
   function in this section (idempotent and cheap to call again when
   nothing changed). */
void  rt_ui_tables_sync(void);
void  rt_ui_menu_enable(short menuIdx, short itemIdx, int on);

/* Ch12 Dialogs (mac-target-4c Task 4): askOpen/askSave/askSaveChanges.
 * path255/name are Str255-shaped, same as every other rt_ui string
 * parameter. rt_ui_ask_open/rt_ui_ask_save fill path255 IN PLACE (a real
 * build via Standard File's SFGetFile/SFPutFile; RT_MAC_TEST via the
 * scripted answer queue below) and return 1 on a successful pick, 0 on
 * Cancel (path255 untouched on 0). rt_ui_ask_save_changes returns the
 * saveChoice enum word (0=Save 1=Discard 2=Cancel) clarusc's lowering
 * already treats as a plain int (types.cla's seeded saveChoice enum). */
int   rt_ui_ask_open(unsigned char *path255);
int   rt_ui_ask_save(unsigned char *path255, const unsigned char *suggested);
short rt_ui_ask_save_changes(const unsigned char *name);

/* canvas ops (Ch11 subset used by bounce + demos).
 *
 * ABI ADJUSTMENT (Task 2, per the plan's "reference wins" rule): Ch11 lists
 * SEVEN canvas methods -- clear, line, rect, fillRect, circle, fillCircle,
 * drawText -- not the four in this plan's header sketch. `rect` already
 * covers rect/fillRect with its `fill` flag (a legitimate collapse: both
 * Clarus method names lower to one runtime call with fill=0/1), but the
 * sketch had no plain (outline) `circle` at all and no `drawText` -- both
 * genuinely missing ops, not just differently shaped ones. Added below,
 * mirroring rt_ui_canvas_fill_circle's own shape rather than bolting a
 * fill flag onto it, since the reference spells `circle`/`fillCircle` as
 * two distinct method names, not one parameterized by a flag. */
void  rt_ui_canvas_clear(void *inst, short wIdx);
void  rt_ui_canvas_fill_circle(void *inst, short wIdx, short x, short y, short r);
void  rt_ui_canvas_circle(void *inst, short wIdx, short x, short y, short r);      /* Ch11 outline circle -- added, Task 2 */
void  rt_ui_canvas_line(void *inst, short wIdx, short x0, short y0, short x1, short y1);
void  rt_ui_canvas_rect(void *inst, short wIdx, short x, short y, short w, short h, int fill);
void  rt_ui_canvas_pattern(void *inst, short wIdx, short level);
void  rt_ui_canvas_draw_text(void *inst, short wIdx, short x, short y, const unsigned char *s); /* Ch11 drawText -- added, Task 2; s is Str255-compatible like other rt_ui string params */

/* ==================== RT_MAC_TEST scripted events (Task 3) ====================
 * Compiled-in event script consumed by rt_ui_run's scripted-input path
 * (rt_ui.c) INSTEAD of WaitNextEvent, per the plan's pinned grammar
 * (click/drag/key/menu/close/resize/tick/snap/quit). Defined weak and
 * empty in rt_ui.c -- an empty script means "no scripted input; run the
 * normal WaitNextEvent loop with real input" -- so a generated events.c
 * (scripts/build-mac.sh's `--events FILE`, or the committed sample at
 * internal/mactest/uiprobe/events.c) need only provide ONE strong,
 * non-empty definition of this exact symbol to override it at link time;
 * declared here so that generated code has an authoritative signature to
 * match without including rt_ui.c or guessing the type. RT_MAC_TEST only:
 * normal (non-test) builds never reference this symbol at all. */
#ifdef RT_MAC_TEST
extern const char rt_ui_test_script[];
#endif

#endif /* CLARUS_RT_UI_H */
