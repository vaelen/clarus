/* internal/mactest/uiprobe/events_form.c -- scripted verification of the
   FormProbe/FormLauncher windows added in mac-target-4d Task 6 (rt_ui_edit,
   the binding walker, and the modality filter), extended in Fix round 1 for
   the FIXED-bind bug (rt_ui_parse_fixed) and the quit-while-modal bug (a
   form window reaching rt_ui_close_internal via `quit`'s cascade). An
   alternative strong rt_ui_test_script to events.c/events_text.c/
   events_popup.c/events_table.c (Tasks 3/4b/4c/4d), selected instead of them
   via CMakeLists.txt's UI_EVENTS cache var -- only one of these links into
   any given build.

   FormLauncher opens LAST in probe_ui.c's main() (frontmost at startup, no
   click-to-front step needed -- same precedent PopupProbe/TableProbe set).
   Its window opens at (136,44) (screen 512x342, content 240x100: left =
   (512-240)/2 = 136; top = 44, the usual default, fits). FormProbe (opened
   only via rt_ui_edit, never at startup) opens at (116,44) (content
   280x200: left = (512-280)/2 = 116) -- centered independent of whatever
   else is open, same formula every other probe window already uses; its
   rect (116,44)-(396,244) fully covers FormLauncher's (136,44)-(376,144)
   underneath it. Adding the Price field (Fix round 1) only pushed OK/
   Cancel down within FormProbe's OWN unchanged outer rect (w/h/position all
   the same as before) -- Name/Qty/Active/Color keep their original
   coordinates below.

   FormProbe widget rects (window-local): Name/Qty/Price are FIELDs with a
   `label:` caption, so their CLICKABLE area is the narrower TE view rect
   (label lane RTUI_FIELD_LABEL_W=70px + RTUI_TE_FRAME_INSET=3px eaten from
   the left/every edge of the widget's own box), not its full outer box --
   Name's box (20,20)-(220,40) -> TE view rect (93,23)-(217,37); Qty's box
   (20,48)-(220,68) -> TE view rect (93,51)-(217,65); Price's box
   (20,128)-(220,148) -> TE view rect (93,131)-(217,145). Active (CHECK) and
   Color (POPUP) and OK/Cancel (BUTTON) all hit-test against their FULL
   outer box (no label-lane narrowing -- rt_ui_popup_hit's own comment
   confirms a popup's hit-test, unlike its narrower DRAWN box, uses the
   full rect): Active (20,76)-(110,92); Color (20,100)-(220,120); OK
   (20,156)-(100,176); Cancel (108,156)-(188,176).

   Global points used below (window origin (116,44) for FormProbe, (136,44)
   for FormLauncher):
     FormLauncher Edit (20,20)-(100,40)      -> click 196 74
     FormProbe Name TE  (93,23)-(217,37)     -> click 266 74
     FormProbe Qty  TE  (93,51)-(217,65)     -> click 321 102 (near the
                                                 right edge, past the "0"
                                                 default -- TE hit-testing
                                                 past the last character
                                                 places the caret at the
                                                 END of the text)
     FormProbe Active   (20,76)-(110,92)     -> click 176 128
     FormProbe Color    (20,100)-(220,120)   -> click 266 154
     FormProbe Price TE (93,131)-(217,145)   -> click 321 182 (past the
                                                 default "0.0000")
     FormProbe OK       (20,156)-(100,176)   -> click 176 210
     FormProbe Cancel  (108,156)-(188,176)   -> click 266 210
   A point OUTSIDE FormProbe's own rect but inside TableProbe's (96,44)-
   (416,284), opened earlier so it sits BEHIND FormProbe/FormLauncher but
   is still the frontmost window covering x>396 -- click 400 100 -- proves
   the modality filter (background click while a form is open beeps, no
   `T FIRE` line appears at all; its ABSENCE from the trace, between the
   two neighboring lines that DO appear, is the proof, same convention
   this codebase's other "no event fired" scenarios already use).

   Script:
     click 196 74     -- Edit (FormLauncher, frontmost, no click-to-front
                          needed): rt_ui_edit opens FormProbe (isNew=1,
                          gFormRec's all-default values, Price shows
                          "0.0000").
     click 266 74     -- focus Name field.
     type Bob         -- "Bob" typed via TEKey into the STR-bound field;
                          no character filter applies to STR (only INT/
                          FIXED do), each keystroke fires `change`.
     click 321 102    -- focus Qty field (caret lands at the end of the
                          default "0", past all its text).
     key 8            -- backspace: clears the default "0" -> "".
     type 12x         -- '1' and '2' insert normally ("1", "12", each
                          firing `change`); 'x' is NOT a digit and not a
                          leading '-' (rt_ui_form_char_ok, RT_FT_INT) --
                          SysBeep, dropped BEFORE TEKey ever sees it, no
                          `change` trace for it at all (its absence, right
                          where a 3rd Qty `change` line would otherwise
                          sit between the '2' and the next backspace's own
                          lines, is the keystroke-filter proof). Field
                          content stays "12".
     key 8            -- backspace -> "1".
     key 8            -- backspace -> "" (empty).
     click 176 128    -- toggle the Active checkbox on (BOOL bind).
     answer-popup 1   -- queues item index 1 (Green) for the next popup
                          click (mac-target-4d Task 3's scripted-popup
                          bypass, unrelated to modality).
     click 266 154    -- Color popup: selection 0 -> 1 (ENUM bind).
     click 176 210    -- OK (RTUI_DEFAULT): Qty is EMPTY -- rt_ui_parse_int
                          fails ("empty/malformed/int32-overflow fails",
                          task brief) -- SysBeep, Qty refocused (no-op,
                          already focused) with TESetSelect(0,32767)
                          (selects its -- empty -- content), trace
                          `T FIRE FormProbe.invalid.Qty`, window stays
                          open. Name/Active/Color/Price are NOT re-
                          validated past this point (declaration order:
                          Name is bind 0 and already passed; Qty is bind
                          1, the first failure) and are NOT written back
                          either.
     snap S1          -- validation-beep state: Name "Bob", Qty empty and
                          focused, Active checked, Color "Green", Price
                          still the untouched default "0.0000".
     type 42          -- Qty's selection was empty (0 length) -- typing
                          simply inserts, field becomes "42".
     click 321 182    -- focus Price field (caret at the end of the
                          default "0.0000", 6 characters).
     type \b\b\b\b\b\b -- six backspaces (C source escapes, not the
                          scripted `key 8` verb, just a shorter way to
                          spell the same six keystrokes): clears
                          "0.0000" -> "".
     type 7           -- Price field becomes "7" -- NO '.' at all. Fix
                          round 1's bug: rt_ui_parse_fixed's fraction loop
                          used to run unconditionally (`for (j=len-1;
                          j>dot; j--)` with `dot` still -1 for a dot-less
                          string), re-consuming "7" itself as if it were a
                          fractional digit and corrupting the result;
                          fixed to skip that loop entirely when no `.` is
                          present, so "7" parses to EXACTLY 7<<16 = 458752.
     click 176 210    -- OK again: every bind now validates (Qty parses to
                          42; Price parses to 458752 via the FIXED fix
                          above; Name/Active/Color never fail) -- writes
                          gModal's scratch buffer, applies RT_UI_WB_ADDR
                          (gFormRec = {"Bob", 42, 1, 1, 458752}), fires
                          `T FIRE FormProbe.accepted` + RTUI_EV_ACCEPTED;
                          formprobe_win_event (FormProbe's own handler,
                          gModal still active so rt_ui_form_is_new() reads
                          1) writes FormLauncher's Result label --
                          `T SET FormLauncher.Result.text A Bob 42 Y 1
                          458752 1` (tag 'A'ccepted, name, qty, active
                          Y/N, color digit, the RAW price int32 -- proving
                          the exact stored bit pattern, not a re-formatted
                          "7.0000" -- then isNew digit) -- THEN tears the
                          window down: `T CLOSE FormProbe 1`, no
                          closeRequest line at all (a form skips that
                          hook).
     snap S2          -- post-accept state: FormProbe gone, FormLauncher
                          frontmost again showing the Result line above.
     click 196 74     -- Edit again: reopens FormProbe (isNew=0 this time
                          -- gFormEverAccepted is now true), filled from
                          the just-written gFormRec ("Bob"/42/checked/
                          Green/"7.0000" -- Price's FILL side re-formats
                          458752 back through rt_ui_fixed_to_str, proving
                          that half of the round trip too).
     click 400 100    -- lands on TableProbe (opened earlier, now behind
                          both FormLauncher and the re-opened FormProbe,
                          but still the frontmost window covering x>396,
                          outside FormProbe's own (116,44)-(396,244) rect)
                          while FormProbe is modal: the filter beeps and
                          returns before FindWindow's result is even
                          switched on -- no `T FIRE` line of any kind
                          appears for this click (compare the trace: the
                          line right after this 2nd "click 196 74"'s own
                          T OPEN/T FRONT pair is `T FIRE FormProbe.
                          cancelled` below, with nothing in between).
     key 27           -- Escape: FormProbe's RTUI_CANCEL button (Cancel)
                          is wired to it (rt_ui_find_flagged) -- routes
                          through the SAME rt_ui_fire_widget choke point
                          the OK button uses, this time gModal.active &&
                          (flags & RTUI_CANCEL) -> rt_ui_form_cancel:
                          `T FIRE FormProbe.cancelled` + RTUI_EV_CANCELLED;
                          formprobe_win_event sets FormLauncher's Result to
                          "Cancelled" (`T SET FormLauncher.Result.text
                          Cancelled`); tears down (`T CLOSE FormProbe 2`),
                          again no closeRequest line.
     snap S3          -- final state: FormLauncher frontmost, Result
                          "Cancelled".
     click 196 74     -- Edit a 3rd time (isNew=0 again): reopens FormProbe
                          -- Fix round 1's quit-while-modal coverage below
                          needs a form open when `quit` runs.
     quit             -- rt_ui_quit walks every open window front-to-back
                          via rt_ui_close_internal; FormProbe (currently
                          frontmost/modal) hits that function's new
                          `gModal.active && inst == gModal.inst` carve-out
                          FIRST: `T FIRE FormProbe.cancelled` +
                          RTUI_EV_CANCELLED (NOT `T FIRE FormProbe.
                          closeRequest` -- a form never gets that hook,
                          same as every other accept/cancel path), gModal
                          cleared, window disposed via rt_ui_form_teardown
                          -- THEN the cascade continues normally with every
                          remaining window's own real closeRequest/closed
                          pair (FormLauncher, TableProbe, PopupProbe,
                          Bounce, Probe, TextProbe), and the process exits
                          0. This probe has no dirty-document window of
                          its own (nothing here ever cancels a
                          closeRequest), so the "something LATER in the
                          cascade cancels the whole quit, leaving the app
                          alive with the form already cleanly
                          cancelled-and-gone" branch isn't independently
                          exercised by this script -- it follows from the
                          SAME code path (rt_ui_close_internal's carve-out
                          runs and returns 1 "closed" unconditionally,
                          `gModal` is fully cleared and the window fully
                          disposed, exactly like the ordinary Escape/
                          Cancel-button path already proven above, BEFORE
                          rt_ui_quit's loop ever reaches whatever window
                          would cancel the rest) rather than from a second
                          live trace; see task-6-report.md's "Fix round 1"
                          section for the honest split between what's
                          scripted here and what's read off the code. */
const char rt_ui_test_script[] =
    "click 196 74\n"
    "click 266 74\n"
    "type Bob\n"
    "click 321 102\n"
    "key 8\n"
    "type 12x\n"
    "key 8\n"
    "key 8\n"
    "click 176 128\n"
    "answer-popup 1\n"
    "click 266 154\n"
    "click 176 210\n"
    "snap S1\n"
    "type 42\n"
    "click 321 182\n"
    "type \b\b\b\b\b\b\n"
    "type 7\n"
    "click 176 210\n"
    "snap S2\n"
    "click 196 74\n"
    "click 400 100\n"
    "key 27\n"
    "snap S3\n"
    "click 196 74\n"
    "quit\n";
