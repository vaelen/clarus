#!/bin/sh
# mactest/snow/adsp_listener (AppleTalk phase, 2026-09-07, Task 13c): the
# System 7 half of the two-machine ADSP stream proof -- a Snow guest as
# the examples/atalkchat.cla listener, a Mini vMac guest as the client,
# over LocalTalk-over-UDP.
#
# RETIRED to a skip by the Linux emulator port (2026-09-27): the Linux
# Mini vMac has no LocalTalk at all, and the Snow SE workspaces
# (snow/system{6,7}.snoww) carry no LocalTalk bridge wired for this lane
# (the macOS version turned it on by clicking Snow's in-window Ports menu
# with CGEvents). The full macOS script -- sequencing, timing budget, the
# 640x480 click restamp -- is in git at c960bb96
# (tests/mactest/snow/adsp_listener.sh) if a networked lane comes back.
. "$(dirname "$0")/../../lib.sh" || exit 2
. "$(dirname "$0")/../../lib_snow.sh" || die "helper lib failed to load"
require_env CLARUS_SNOW_TESTS
snow_skip_no_network "the Snow<->Mini vMac ADSP stream (LocalTalk between two emulators)"
