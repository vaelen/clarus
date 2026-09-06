#!/bin/sh
# tests/bake/every_cli.sh -- T1-speed regression for a C-LANE --rtbake
# byte-identity bug the opt-in T2 sweep (full_corpus_emitui.sh, behind
# CLARUS_BAKE_FULL) was the only thing that could catch.
#
# The bug: bkInstallArenas TRUNCATES irStrLits back to the base boundary on
# a non-testapi install (dropping uitest.cla's literals) but restored the
# baked lowStrIdx -- lowering's string-literal-BY-VALUE dedup map -- whole.
# Every entry that map carried for a uitest.cla literal then pointed PAST
# the installed pool, so a user program whose own source contained that
# same string deduped to a dead index: the --rtbake fork emitted a
# reference to a clar_lit_K nothing defines, and would not even have
# compiled. Fixed by filtering the map to the installed pool on load,
# exactly as irFuncIdxByName is rebuilt rather than copied for the very
# same truncation.
#
# testdata/emitui/every_cli.cla is the fixture because it is the first
# corpus program to hit it: it logs "tick ", which uitest.cla also uses as
# a literal. **Keep that string** -- change it and this test still passes
# while proving nothing. (It is also the whole `every`-on-the-host-lane
# shape, so this doubles as the AppleTalk phase Task 5 bake pair CLAUDE.md's
# standing rule asks for.)
#
# C lane, so no MacBinary wrap and no embedded output filename: the two
# forks can be written side by side under distinct names in one directory,
# the way full_corpus_emitui.sh does it (emit68k_pair's separate-directory
# dance is for the 68k lane's header only).
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"

BAKE=$WORK/rtc.clir
bake_ir c "$BAKE"

ENTRY=testdata/emitui/every_cli.cla
grep -q '"tick "' "$ENTRY" || die "$ENTRY no longer contains the uitest.cla-colliding literal this test exists for"

if ! "$CLARUSC" emit --rtdir runtime/clarus/ -o "$WORK/src.c" "$ENTRY" > "$WORK/src.log" 2>&1; then
    t_fail every_cli "from-source compile failed: $(head -3 "$WORK/src.log" | tr '\n' ' ')"
    t_done
fi
if ! "$CLARUSC" emit --rtdir runtime/clarus/ --rtbake "$BAKE" -o "$WORK/bake.c" "$ENTRY" > "$WORK/bake.log" 2>&1; then
    t_fail every_cli "--rtbake compile failed: $(head -3 "$WORK/bake.log" | tr '\n' ' ')"
    t_done
fi
# A silent from-source fallback would make the comparison pass VACUOUSLY --
# emit68k_pair's own PAIRFB=forbid check, for the same reason.
if grep -q 'falling back' "$WORK/bake.log"; then
    t_fail every_cli "unexpectedly fell back to from-source -- expected the real bake path: $(grep 'falling back' "$WORK/bake.log" | head -1)"
    t_done
fi

if cmp -s "$WORK/src.c" "$WORK/bake.c"; then
    t_pass every_cli
else
    t_fail every_cli "--rtbake fork ($(wc -c < "$WORK/bake.c" | tr -d ' ') bytes) != from-source fork ($(wc -c < "$WORK/src.c" | tr -d ' ') bytes): $(cmp "$WORK/src.c" "$WORK/bake.c" 2>&1 | head -1); $(first_diff "$WORK/src.c" "$WORK/bake.c" | tr '\n' ' ')"
fi
t_done
