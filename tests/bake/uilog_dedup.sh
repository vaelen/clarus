#!/bin/sh
# bake/uilog_dedup -- `emit68k --rtbake` byte identity when the user's own
# literals equal strings only uilog.cla uses (ui-widgets, rtbake fix round
# 1). A logpanel-less 68k program never splices uilog.cla from source, but
# the baked library always has it, so bkInstallArenas hides uilog.cla's
# literals: out of cg68Measure's whole pool AND out of the by-value dedup
# map. Without the second half, log("copy") deduped to a dropped pool index
# and the --rtbake build panicked "list index out of range". Covers the
# plain, --testapi (uitest.cla's literals follow the hidden range) and
# logpanel (nothing hidden) installs.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"

BAKE=$WORK/rt68k.clir
bake_ir 68k "$BAKE"

cat > "$WORK/cli.cla" <<'CLA'
on App.startCLI(args: list of string) {
    log("copy")
    log("has lines")
    log("has a selection")
    log("logpanel line out of range")
    quit 0
}
CLA

if detail=$(emit68k_pair cli "$WORK/cli.cla"); then
    t_pass cli
else
    t_fail cli "$detail"
fi

write_ui() {
    cat > "$1" <<CLA
app UilogDedup {
    name: "UilogDedup"
    version: "1.0"
    author: "Andrew C. Young <andrew@vaelen.org>"
    about: "bake/uilog_dedup fixture."
    id: "ULDD"
}

window Probe {
    title: "UilogDedup"
    size: 300, 120
    $2
}

on App.launch {
    open Probe
}

extend Probe {
    on opened {
        log("copy")
        UiTestVerb("click Foo")
    }
}
CLA
}

write_ui "$WORK/ui_nolog.cla" ""
PAIRFLAGS=--testapi
if detail=$(emit68k_pair ui_nolog "$WORK/ui_nolog.cla"); then
    t_pass testapi_nologpanel
else
    t_fail testapi_nologpanel "$detail"
fi

write_ui "$WORK/ui_log.cla" "logpanel Log { maxLines: 10; fill: both }"
if detail=$(emit68k_pair ui_log "$WORK/ui_log.cla"); then
    t_pass testapi_logpanel
else
    t_fail testapi_logpanel "$detail"
fi
t_done
