#include "Dialogs.r"

resource 'ALRT' (128, purgeable) {
    {40, 40, 190, 460}, 128,
    { OK, visible, silent, OK, visible, silent,
      OK, visible, silent, OK, visible, silent },
    alertPositionMainScreen
};

/* DITL 128's OK button rect was {120,360,140,420} (attempt-abort Task 10,
   field-reported 2026-08-14): ALRT 128's inner frame above is 420x150
   ({40,40,190,460}), so right=420 sat flush on the frame's own right edge,
   and the Dialog Manager's default-button ring (drawn ~4px OUTSIDE the item
   rect) ran off the dialog. Moved to {117,347,137,407} -- a 13px inset from
   both the right (420) and bottom (150) inner edges, standard 20-tall x
   60-wide button -- so the ring (411/141) stays inside. */
resource 'DITL' (128, purgeable) {
    {
        {117, 347, 137, 407}, Button { enabled, "OK" },
        {10, 20, 110, 420},  StaticText { disabled, "^0" }
    }
};

/* ALRT/DITL 130 -- askSaveChanges's three-way "Save changes to ...?"
   confirmation (Ch12, mac-target-4c Task 4). rt_ui.c's
   rt_ui_ask_save_changes drives it via ParamText's ^0 + Alert(130, NULL);
   item 1 (Save, default) / 2 (Don't Save) / 3 (Cancel), item-1 mapping
   straight onto saveChoice's Save/Discard/Cancel = 0/1/2. Classic layout:
   Don't Save at the far left, Cancel and Save (rightmost, default) grouped
   together at the right. Plain straight quotes around ^0, not MacRoman's
   curly 0xD2/0xD3 pair the reference prose uses -- Rez's string literals
   have no clean hex-byte escape for arbitrary MacRoman bytes the way C's
   \0xNN does, and this is cosmetic only (disclosed; revisit if a later
   task wants the exact glyph). */
resource 'ALRT' (130, purgeable) {
    {40, 40, 156, 420}, 130,
    { OK, visible, silent, OK, visible, silent,
      OK, visible, silent, OK, visible, silent },
    alertPositionMainScreen
};

resource 'DITL' (130, purgeable) {
    {
        {80, 290, 100, 360}, Button { enabled, "Save" },
        {80, 20, 100, 140},  Button { enabled, "Don't Save" },
        {80, 210, 100, 280}, Button { enabled, "Cancel" },
        {10, 20, 60, 360},   StaticText { disabled, "Save changes to \"^0\"?" }
    }
};
