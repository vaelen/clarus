#!/bin/sh
# cg68k/nested_tmp_alias -- listing-level proof that a compound statement's
# OWN tracked temp is not aliased by its body's scratch slots.
# language-runtime-cleanup Task 12b.
#
# `for x in mk()` parks mk()'s list handle in a statement-temp slot and
# releases it at the END of the whole for statement (cgStmt's own
# cgFreeStmtTmps tail). Through the compiler-cleanup phase cgStmt reset the
# temp pool's bump allocator to 0 at the start of EVERY statement, body
# statements included -- so the first body statement needing a scratch slot
# (here `seen.add(x)`, which passes its int argument by address) got the
# SAME frame offset and overwrote the parked handle. The release at the end
# then ran rtListRelease on whatever integer the body had last stored
# there. Hardware-reproduced on the toolbox suite: benign for one value,
# a hard hang for the next.
#
# The check: emit68k --listing the fixture below, isolate App.launch's
# body, take the first `MOVE.L D0,-N(A6)` whose N is NOT one of the
# listing's own declared `; local ... : -N(A6)` offsets (that is the parked
# handle's slot), and require exactly ONE store to it in the whole body.
# Pre-fix there are two.
. "$(dirname "$0")/../lib.sh" || exit 2

run=$WORK/nested_tmp_alias
mkdir -p "$run" || die "mkdir $run"
FIX=$run/nested_tmp.cla

cat > "$FIX" <<'EOF'
// Fixture for tests/cg68k/nested_tmp_alias.sh -- see that script's header.
func mk(): list of int {
    var l: list of int

    l.add(4)
    l.add(7)
    return l
}

on App.launch {
    var seen: list of int
    var x: int

    for x in mk() {
        seen.add(x)
    }
    alert(string(seen.count))
}
EOF

if ! out=$("$CLARUSC" emit68k -o "$run/out.bin" --listing --rtdir "$RTDIR" "$FIX" 2>&1); then
    t_fail emit "clarusc emit68k --listing $FIX failed"
    echo "$out"
    t_done
fi

S=$run/out.seg1.s
[ -f "$S" ] || die "no listing at $S"

# One pass over App.launch's body: remember every declared local's own
# frame offset, then count stores to the first non-local temp offset.
res=$(awk '
    /^[ \t]*; func handler_App_launch/ { inh = 1; next }
    inh && /^[ \t]*; func / { exit }
    inh && /^[ \t]*;[ \t]+local .*:[ \t]*-[0-9]+\(A6\)/ {
        if (match($0, /-[0-9]+\(A6\)/)) local[substr($0, RSTART, RLENGTH)] = 1
        next
    }
    inh && /^[ \t]*MOVE\.L[ \t]+D0,-[0-9]+\(A6\)$/ {
        match($0, /-[0-9]+\(A6\)/)
        d = substr($0, RSTART, RLENGTH)
        if (d in local) next
        if (tmp == "") tmp = d
        if (d == tmp) n++
    }
    END { print (tmp == "" ? "NONE" : tmp) " " (n + 0) }
' "$S")

tmp=${res% *}
n=${res#* }

if [ "$tmp" = NONE ]; then
    t_fail temp_found "no non-local D0 frame store in App.launch -- fixture or listing shape changed"
    t_done
fi
t_pass temp_found

if [ "$n" = 1 ]; then
    t_pass single_store
else
    t_fail single_store "the for-statement's own tracked temp $tmp is stored $n times in App.launch (want 1) -- a body statement is aliasing it"
fi

t_done
