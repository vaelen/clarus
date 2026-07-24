#include "Dialogs.r"

resource 'ALRT' (128, purgeable) {
    {40, 40, 190, 460}, 128,
    { OK, visible, silent, OK, visible, silent,
      OK, visible, silent, OK, visible, silent },
    alertPositionMainScreen
};

resource 'DITL' (128, purgeable) {
    {
        {120, 360, 140, 420}, Button { enabled, "OK" },
        {10, 20, 110, 420},  StaticText { disabled, "^0" }
    }
};
