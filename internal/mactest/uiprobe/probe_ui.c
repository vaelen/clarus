/* probe_ui.c -- hand-authored rt_ui descriptor app proving runtime/mac/
   rt_ui.c end to end: one window type ("Probe", resizable) with a default
   button, a checkbox, and a label, laid out with all three Ch8 `at` kinds
   (button at an explicit x,y; the checkbox at the button's right edge;
   the label below the checkbox, filling the remaining width). This is the
   "living example of descriptor authorship" Task 4's emitter must later
   reproduce -- every table below is exactly the shape clarusc will emit
   from a `window Probe { ... }` declaration.

   Interaction proven:
     - clicking Go toggles On (rt_ui_widget_get/set_bool) and rewrites the
       Status label (rt_ui_widget_set_str) with the check state plus a
       click counter kept in the window's own per-instance state
       (rt_ui_state), proving stateSize/rt_ui_state end to end too.
     - typing a key sets the window title to that character
       (rt_ui_set_title), proving the `key` window event.
     - the close box's closeRequest handler allows the close (no cancel);
       once the window has actually finished closing, `closed` calls
       rt_quit(0) so the whole run ends cleanly (no menu yet -- Task 2 --
       so this is the probe's own way to terminate for verification). */
#include "rt_ui.h"
#include "rt.h"

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

static void probe_widget_event(void *inst, short widgetIndex, short event, long a, long b)
{
    (void)a; (void)b;
    if (widgetIndex == W_GO && event == RTUI_WEV_CLICK) {
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
    case RTUI_EV_CLOSED:
        rt_quit(0);
        break;
    default:
        break; /* opened, closeRequest (no cancel), resized: nothing to do */
    }
}

static const rt_ui_widget_desc kProbeWidgets[] = {
    { RTUI_BUTTON, "Go", (const unsigned char *)"\pGo",
      RTUI_AT_XY, 20, 20, 80, RTUI_FILL_NONE, RTUI_DEFAULT },
    { RTUI_CHECK, "On", (const unsigned char *)"\pOn",
      RTUI_AT_RIGHT, 0, 22, 60, RTUI_FILL_NONE, 0 },
    { RTUI_LABEL, "Status", (const unsigned char *)"\pOff 0",
      RTUI_AT_NEXT, 0, RTUI_BOTTOM, RTUI_FILL, RTUI_FILL_NONE, 0 }
};

static const rt_ui_handlers kProbeHandlers = { probe_win_event, probe_widget_event };

static const rt_ui_window_desc kProbeWindow = {
    "Probe", (const unsigned char *)"\pProbe",
    300, 140, 1, 220, 100,
    3, kProbeWidgets,
    (short)sizeof(ProbeState),
    &kProbeHandlers
};

static const rt_ui_window_desc *kWindows[] = { &kProbeWindow };

int main(void)
{
    rt_args_init(0, (char **)0);
    rt_ui_startup(kWindows, 1, (const rt_ui_menu_desc **)0, 0,
                  (const rt_ui_menu_handler *)0, 0, (const rt_ui_every_desc *)0, 0);
    rt_ui_open(&kProbeWindow);
    rt_ui_run();
    return 0;
}
