/* internal/mactest/uiprobe/events.c -- committed sample event script for
   Task 3 (mac-target-4b) manual verification of runtime/mac/rt_ui.c's
   scripted-event machinery. Strong definition of rt_ui_test_script:
   overrides rt_ui.c's weak empty default at link time (only linked in
   when CMakeLists.txt's UI_EVENTS cache variable points here).

   Script (per the plan's pinned grammar):
     click 166 74   -- global coords inside the Probe window's content area,
                       but NOT frontmost yet at startup (main() opens Bounce
                       last, so Bounce is frontmost) -- this first click is
                       consumed as a click-to-front select, same as a real
                       single click on a background window's content never
                       reaches the widget underneath it.
     click 166 74   -- Probe is now frontmost; this one lands on the "Go"
                       button (local rect (20,20)-(100,40), window origin
                       (106,44) per rt_ui_open's centering) and fires it.
     tick 120       -- advances virtual time (TickCount is not consulted in
                       scripted mode); the Bounce window's every-block is
                       due within 120 ticks and fires at least once.
     snap S1        -- one framebuffer checkpoint.
     quit           -- ends the run (rt_ui_quit(), same as the quit statement:
                       closeRequest to Probe and Bounce, front-to-back, then
                       rt_quit(0) since neither cancels). */
const char rt_ui_test_script[] =
    "click 166 74\n"
    "click 166 74\n"
    "tick 120\n"
    "snap S1\n"
    "quit\n";
