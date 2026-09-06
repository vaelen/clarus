#!/bin/sh
# tests/atalk/examples.sh (2026-09-07 appletalk final fix wave): the three
# AppleTalk examples must keep compiling. Each is otherwise built only
# inside a gated emulator boot -- atalkclock.cla by mactest/atalk_68k.sh,
# atalkchat.cla by mactest/adsp_68k.sh, atalkfind.cla by nothing at all --
# so a language or runtime change could rot them and no T1 run would say
# so. Check-only (`clarusc FILE --rtdir DIR`), which is enough to catch
# every front-end and lowering-fence break: no network, no lock, no cc.
. "$(dirname "$0")/../lib.sh" || exit 2

for f in atalkclock atalkchat atalkfind; do
    if "$CLARUSC" "$ROOT/examples/$f.cla" --rtdir "$RTDIR" > "$WORK/$f.log" 2>&1; then
        t_pass "$f"
    else
        t_fail "$f" "$(tail -20 "$WORK/$f.log")"
    fi
done

t_done
