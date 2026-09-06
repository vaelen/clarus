#!/bin/sh
# tests/atalk/examples.sh (2026-09-07 appletalk final fix wave): the three
# AppleTalk examples must keep compiling. Each is otherwise built only
# inside a gated emulator boot -- atalkclock.cla by mactest/atalk_68k.sh,
# atalkchat.cla by mactest/adsp_68k.sh, atalkfind.cla by nothing at all --
# so a language or runtime change could rot them and no T1 run would say
# so. This EMITS (`clarusc emit -o ...`) rather than check-only: the
# AppleTalk caps and the address/service fences live in LOWERING, which
# check-only never runs, so a check-only pass would miss exactly the
# breakage this script exists to catch. No network, no lock, no cc; all
# three emit in well under a second.
. "$(dirname "$0")/../lib.sh" || exit 2

for f in atalkclock atalkchat atalkfind; do
    if "$CLARUSC" emit --rtdir "$RTDIR" -o "$WORK/$f.c" "$ROOT/examples/$f.cla" \
        > "$WORK/$f.log" 2>&1; then
        t_pass "$f"
    else
        t_fail "$f" "$(tail -20 "$WORK/$f.log")"
    fi
done

t_done
