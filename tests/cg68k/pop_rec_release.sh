#!/bin/sh
# cg68k/pop_rec_release -- listing-level proof that a popped handle-bearing
# RECORD gets exactly ONE release-walk call per evaluation, in each of the
# three consuming positions the fixture exercises: receiver
# (`lst.pop().t.length`), operand (`lst.pop().n + 1`) and call argument
# (`popTake(lst.pop())`). language-runtime-cleanup, spec 3.1.
#
# cgIntrListPopLike deliberately leaves its KRec scratch untracked (every
# other consumer block-copies the bytes out into a destination that then
# owns them), so in receiver/operand position nothing owned the record and
# its `text` field leaked one block per evaluation. cgMaterializeToTemp's
# tracked-temp gate now covers that shape, so the end-of-statement flush
# walks the copy's fields.
#
# The check: emit68k --listing testdata/cg68k/pop_rec.cla, find the
# cg_release_<Rec> walk's label (the listing annotates the walk's own
# binding site with "; cg_release_PopRec(...)" -- the label is the line
# right above it; the label itself is a bare LBL_<n>), then count calls to
# that label inside App.launch's handler body.
#
# Expected 3 -- one per pop() consumption. Pre-fix it is 1: only the
# argument shape got a release, scheduled by cgPushArgs. That scheduling is
# gone now (the materialized copy is tracked instead), so a 4 here means
# the argument shape releases TWICE.
. "$(dirname "$0")/../lib.sh" || exit 2

FIX=$ROOT/testdata/cg68k/pop_rec.cla
run=$WORK/pop_rec_release
mkdir -p "$run" || die "mkdir $run"

if ! out=$("$CLARUSC" emit68k -o "$run/out.bin" --listing --rtdir "$RTDIR" "$FIX" 2>&1); then
    t_fail emit "clarusc emit68k --listing $FIX failed"
    echo "$out"
    t_done
fi

S=$run/out.seg1.s
[ -f "$S" ] || die "no listing at $S"

# The release walk's label: the line above the "; cg_release_PopRec(" comment.
lbl=$(awk '/; cg_release_PopRec\(/ { print prev; exit } { prev = $0 }' "$S" |
    sed 's/[: ]*$//; s/^[ 	]*//')
case "$lbl" in
    LBL_[0-9]*) t_pass release_label_found ;;
    *)
        t_fail release_label_found "no cg_release_PopRec walk label in $S (got '$lbl')"
        t_done
        ;;
esac

# App.launch's handler body: from its "; func handler_App_launch" annotation
# to the next "; func " annotation.
n=$(awk -v l="$lbl" '
    /^[ \t]*; func handler_App_launch/ { inh = 1; next }
    inh && /^[ \t]*; func / { exit }
    inh && $0 ~ ("(BSR\\.[WBL]|JSR)[ \t]+" l "([ \t]|$)") { c++ }
    END { print c + 0 }
' "$S")

if [ "$n" = 3 ]; then
    t_pass release_calls
else
    t_fail release_calls "expected 3 calls to $lbl in App.launch, got $n"
fi

t_done
