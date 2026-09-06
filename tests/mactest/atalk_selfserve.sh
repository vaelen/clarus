#!/bin/sh
# timeout: 20m
# mactest/atalk_selfserve (2026-09-06 appletalk spec %8.2, Task 9): one
# native Mini vMac boot of testdata/atalk/selfserve.cla -- the no-peer
# hardware proof of runtime/clarus/atalk_68k.cla's own bodies. See that
# fixture's header for what each asserted line proves and for the two
# things it deliberately does not attempt (a peer reply, which is Task
# 10's two-machine harness, and the node's own address, which no waist
# entry exposes).
#
# The .DSP driver ships in the AppleTalk System file, which LaunchAPPL's
# stripped boot disk drops -- so `lsn.register` is EXPECTED to fail here
# with the runtime's own ".DSP missing" message. The assertion is written
# so that a boot disk which DOES carry AppleTalk (Andrew's LaunchAPPL fix,
# in flight) passes too: a listener failure is allowed only if it is that
# one, and its absence is fine.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_mac.sh" || die "helper lib failed to load"
require_env CLARUS_MAC_TESTS

emit68k -o "$WORK/selfserve.bin" testdata/atalk/selfserve.cla \
    > "$WORK/emit.log" 2>&1 \
    || die "clarusc emit68k selfserve: $(tail -10 "$WORK/emit.log")"

run_mac "$WORK/selfserve.bin" 300

LOG=$WORK/cap.log

# want_line NAME TEXT : the captured log must contain TEXT.
want_line() {
    if grep -qF "$2" "$LOG"; then
        t_pass "$1"
    else
        t_fail "$1" "log has no \"$2\": $(tr '\n' '|' < "$LOG")"
    fi
}

# deny_line NAME TEXT : the captured log must NOT contain TEXT.
deny_line() {
    if grep -qF "$2" "$LOG"; then
        t_fail "$1" "log has \"$2\": $(tr '\n' '|' < "$LOG")"
    else
        t_pass "$1"
    fi
}

[ "$MAC_EXIT" = 0 ] && t_pass exit || t_fail exit "exit $MAC_EXIT, want 0"

# serve(): POpenATPSkt + PRegisterName(verify) + the first async
# PGetRequest all succeeded -- any of them failing stages an svc.failed.
want_line served "served"
deny_line no_svc_failure "svcfail"

# zones(): no router and (on this disk) no .XPP -> the one-element ["*"].
want_line zones "zones 1 *"

# find(): the async PLookupName ran to completion and parsed zero tuples.
# `done` is also what ends the program, so its absence is a watchdog quit.
want_line lookup_done "done 0"
deny_line no_brs_failure "brsfail"
deny_line no_watchdog "watchdog"

# call(): the synchronous "Name:Type" form, spun to completion on lookup
# slot 10, finding nothing -> nbpNoConfirm.
want_line call_no_name "call err -1025 name not found"

# stop(): PRemoveName + PCloseATPSkt both returned 0 (a nonzero RemoveName
# would have staged nothing, but stop() is what the next line follows).
want_line stopped "stopped"

# The listener: allowed to fail, but only with the ".DSP absent" message.
if grep -q '^lsnfail ' "$LOG"; then
    if grep -qF "lsnfail -1273 streams not available on this lane" "$LOG"; then
        t_pass listener_no_dsp
    else
        t_fail listener_no_dsp "unexpected listener failure: $(grep '^lsnfail ' "$LOG")"
    fi
else
    t_pass listener_no_dsp
fi

t_done
