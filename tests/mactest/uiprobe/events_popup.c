/* tests/mactest/uiprobe/events_popup.c -- scripted verification of the
   PopupProbe window added in mac-target-4d Task 3 (RTUI_POPUP). An
   alternative strong rt_ui_test_script to events.c/events_text.c (Task 3,
   mac-target-4b / mac-target-4c), selected instead of them via
   CMakeLists.txt's UI_EVENTS cache var -- only one of the three links into
   any given build.

   PopupProbe opens LAST in probe_ui.c's main() (frontmost at startup, no
   click-to-front step needed -- see that window's own header comment).
   Its window opens at (116,44) (screen 512x342, content 280x120: left =
   (512-280)/2 = 116; top = 44, the usual menu-bar-plus-breathing-room
   default, fits). Widget rects (window-local):
     Color  (popup):   (20,20)-(220,40)   -- box (after the "Color:" label
                        lane) is (90,20)-(220,40); hit-testing uses the
                        FULL rect, so anywhere in (20,20)-(220,40) opens it.
     Get    (button):   (20,48)-(100,68)
     SetRed (button):  (108,48)-(188,68)
     Result (label):    (20,76)-(272,92)

   Script:
     answer-popup 2  -- queues item index 2 (0-based -- Blue, the 3rd item)
                        for the NEXT popup click to consume instead of
                        calling PopUpMenuSelect (gUiScripted bypass,
                        rt_ui_handle_content_click's popup lane).
     click 266 74    -- global point (116+150, 44+30), inside Color's full
                        rect -- popup click: selection changes 0 -> 2,
                        fires `T FIRE PopupProbe.Color.change` and
                        RTUI_WEV_CHANGE(a=2), redraws (now shows "Blue").
     click 176 102   -- global point (116+60, 44+58), the "Get" button:
                        fires `T FIRE PopupProbe.Get.click`; its handler
                        calls rt_ui_widget_get_int(..., RTUI_PROP_SELECTED)
                        (reads 2) and rt_ui_widget_set_str's the Result
                        label to "Blue" (`T SET PopupProbe.Result.text
                        Blue`).
     click 264 102   -- global point (116+148, 44+58), "Set Red": fires
                        `T FIRE PopupProbe.SetRed.click`; its handler calls
                        rt_ui_widget_set_int(..., RTUI_PROP_SELECTED, 0)
                        directly -- `T SET PopupProbe.Color.selected 0`,
                        NO change trace/event (a programmatic set, not a
                        pick), redraws back to "Red".
     click 176 102   -- "Get" again: reads back 0, sets Result to "Red"
                        (`T SET PopupProbe.Result.text Red`) -- proves the
                        set_int -> get_int round trip independent of any
                        popup click.
     snap S1         -- one framebuffer checkpoint: the popup box (frame +
                        drop shadow + "Red" + down-arrow), both buttons,
                        and the "Red" Result label all visible.
     quit            -- closeRequest to PopupProbe/TextProbe/Probe/Bounce
                        front-to-back, then process exit -- same real quit
                        cascade every other scripted scenario ends with. */
const char rt_ui_test_script[] =
    "answer-popup 2\n"
    "click 266 74\n"
    "click 176 102\n"
    "click 264 102\n"
    "click 176 102\n"
    "snap S1\n"
    "quit\n";
