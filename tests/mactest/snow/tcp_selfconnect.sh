#!/bin/sh
# mactest/snow/tcp_selfconnect (MacTCP phase, spec 8.3): the hardware
# proof of the TCP transport -- examples/tcpchat.cla on a Snow Mac II
# (System 7, DaynaPORT Ethernet at SCSI 3, MacTCP at 10.0.0.2) listening
# on and self-connecting to its OWN address (MacTCP does not loop
# 127.0.0.1 back), then a 256-byte sweep echo, "hello", and a close.
#
# RETIRED to a skip by the Linux emulator port (2026-09-27): MacTCP/
# Ethernet integration on the emulators is out of scope, and the SE
# workspaces that replaced the Mac II carry no DaynaPORT adapter and no
# MacTCP install (and a 512x342 screen, which moves the scripted Self
# click in testdata/ui/tcpchat_self.events). The full script is in git at
# c960bb96 (tests/mactest/snow/tcp_selfconnect.sh).
. "$(dirname "$0")/../../lib.sh" || exit 2
. "$(dirname "$0")/../../lib_snow.sh" || die "helper lib failed to load"
require_env CLARUS_SNOW_TESTS
snow_skip_no_network "MacTCP self-connect over Snow's DaynaPORT Ethernet"
