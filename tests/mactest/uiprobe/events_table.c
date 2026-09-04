/* tests/mactest/uiprobe/events_table.c -- scripted verification of the
   TableProbe window added in mac-target-4d Task 4 (RTUI_TABLE). An
   alternative strong rt_ui_test_script to events.c/events_text.c/
   events_popup.c, selected instead of them via CMakeLists.txt's UI_EVENTS
   cache var -- only one of the four links into any given build.

   TableProbe opens LAST in probe_ui.c's main() (frontmost at startup, no
   click-to-front step needed -- see that window's own header comment).
   Its window opens at (96,44) (screen 512x342, content 320x240: left =
   (512-320)/2 = 96; top = 44, the usual menu-bar-plus-breathing-room
   default, fits). Widget rects (window-local):
     Add    (button):  (20,20)-(100,40)
     Remove (button):  (108,20)-(188,40)
     Result (label):   (20,48)-(312,64)
     Items  (table):   (20,72)-(312,232) -- header strip carved off the
                        top, 3 seeded rows (Alpha/10/off, Beta/20/on,
                        Gamma/30/off) below it.

   Row-click Y coordinates below are MEASURED, not guessed: a one-off debug
   trace temporarily added to rt_ui_table_relayout (removed before this
   task's final commit) printed the actual runtime geometry for this exact
   window -- headerH = 20px, rowH = 16px, so the list's own view starts at
   local y = 72 + 20 = 92 and each row is 16px tall (NOT the classic
   Chicago-12 ascent/descent/leading figures a textbook guess would give;
   whatever this Retro68/Mini vMac build's actual GetFontInfo returns for
   the application font, it isn't that). Cross-checked independently at
   verification time too: the table's own SELECT/DBLCLICK handler rewrites
   the Result label to "<name> S<row>"/"<name> D<row>", so a click landing
   on the wrong row is caught by trace inspection, not just eyeballed off
   a snap -- and every line below was confirmed against that ground truth
   before this script was finalized.

   Script:
     click 196 152   -- global (96+100, 44+108): row 1 (Beta), band
                        [108,124) -- table SELECT fires, Result set to
                        "Beta S1".
     snap S1         -- 3 rows, headers, checkmark column (Beta's Done),
                        row 1 highlighted.
     dblclick 196 139 -- global (96+100, 44+95): row 0 (Alpha), band
                        [92,108) -- SELECT fires first (Result "Alpha
                        S0"), then DBLCLICK (Result overwritten to "Alpha
                        D0") -- both T FIRE lines present, select-before-
                        double proven by the trace order.
     click 156 74    -- global (96+60, 44+30): the Add button -- pushes a
                        4th row ("Extra", qty 40, done true) straight onto
                        gTableRows with no table-specific call.
     snap S2         -- liveness: 4 rows now visible with no other action
                        having touched the table itself.
     click 196 192   -- global (96+100, 44+148): row 3 (Extra, the newest/
                        LAST row), band [140,156) -- SELECT fires, Result
                        "Extra S3". Deliberately the tail row: the table's
                        own sync (rt_ui_tables_sync) diffs LM's row count
                        against rt_list_count and always LAddRow/LDelRow
                        AT THE END, so removing the row that is ALSO the
                        tail keeps this scenario's proof unambiguous (see
                        the Task 4 report's self-review for the general
                        mid-list-removal caveat this sidesteps, not fixes).
     click 244 74    -- global (96+148, 44+30): the Remove button -- reads
                        the currently-selected row (3) and rt_list_removes
                        it, dropping back to 3 rows (Alpha, Beta, Gamma).
     snap S3         -- liveness: back to 3 rows, Extra gone, content
                        re-derived fresh (not a stale cache) for every
                        remaining row.
     quit            -- closeRequest to TableProbe/PopupProbe/TextProbe/
                        Probe/Bounce front-to-back, then process exit --
                        same real quit cascade every other scripted
                        scenario ends with. */
const char rt_ui_test_script[] =
    "click 196 152\n"
    "snap S1\n"
    "dblclick 196 139\n"
    "click 156 74\n"
    "snap S2\n"
    "click 196 192\n"
    "click 244 74\n"
    "snap S3\n"
    "quit\n";
