/* tests/mactest/uiprobe/events_text.c -- scripted verification of the
   TextProbe window added in mac-target-4c Task 1 (field/textview widgets).
   An alternative strong rt_ui_test_script to events.c (Task 3,
   mac-target-4b), selected instead of it via CMakeLists.txt's UI_EVENTS
   cache var -- only one of the two links into any given build.

   TextProbe opens FIRST in probe_ui.c's main() (furthest back in z-order;
   Probe then Bounce open after it, unchanged from Task 1-3, so Bounce is
   still frontmost at startup). TextProbe's own widgets are deliberately
   pushed down its 320x280 window (field at y:175, textview filling below
   it) so their screen rects -- (116,219)-(336,239) for the field's TE view,
   (116,247)-(408,316) for the textview's -- fall entirely below Probe's
   content bottom (214) and Bounce's (204): both target points below are
   NEVER covered by Probe or Bounce regardless of z-order, so TextProbe is
   reachable by click even while backmost.

   Script:
     click 261 229  -- TextProbe isn't frontmost yet; FindWindow resolves
                       this point to TextProbe anyway (Probe/Bounce don't
                       cover it), but wp != FrontWindow() -- click-to-front
                       only, same "background window's content never
                       reaches the widget underneath it" rule events.c's
                       own first click already exercises for Probe.
     click 261 229  -- TextProbe is now frontmost; lands inside the "Name"
                       field's TE view rect (past its label lane) -- focus
                       switches to it (TEActivate) and TEClick.
     type Hello\r   -- "Hello" typed via TEKey (with the trailing raw CR
                       byte -- 0x0D, embedded directly in the type verb's
                       argument, not a line terminator -- only '\n' ends a
                       script line) firing field.enter (no insertion) since
                       the focused widget is a FIELD; the handler retitles
                       the window to "Entered".
     click 256 279  -- lands inside the "Body" textview's TE view rect;
                       focus switches away from Name (TEDeactivate) to Body
                       (TEActivate) and TEClick.
     type Hi there\r -- "Hi there" (exercising a space) typed via TEKey,
                        then the trailing CR inserts a newline (Body is a
                        TEXTVIEW, not a FIELD -- Return inserts rather than
                        firing `enter`), each keystroke firing `change`.
     snap S1        -- one framebuffer checkpoint: Chicago text visible in
                       both widgets, a frame + caret line, and Body's
                       vertical scrollbar drawn.
     quit           -- closeRequest to TextProbe/Probe/Bounce front-to-back,
                       then process exit -- same real quit cascade every
                       other scripted scenario ends with. */
const char rt_ui_test_script[] =
    "click 261 229\n"
    "click 261 229\n"
    "type Hello\r\n"
    "click 256 279\n"
    "type Hi there\r\n"
    "snap S1\n"
    "quit\n";
