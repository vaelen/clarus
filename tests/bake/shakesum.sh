#!/bin/sh
# tests/bake/shakesum.sh (SE wave 4, Task 2): the baked call-graph summary
# (bkSecShakeSummary) must drive shake to EXACTLY the marks and edges the
# IR walk gives. For each program, `build68k --shake-dump` from source (IR
# walk) and from `--rtbake` (summary replay for every baked runtime
# function and global initializer) must dump the same `M`/`E` lines. The
# dump's trailing `R n` line counts the runtime bodies replayed from the
# summary: it must be 0 from source and > 0 from --rtbake, or the
# comparison would pass vacuously.
#
# The per-function half (every runtime function's baked list equals the
# IR walk of its body) is the bake's own self-check: `--bake-ir` aborts on
# a mismatch (bkCheckShakeSummary), so bake_ir failing here is that FAIL.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"

BAKE=$WORK/rt68k.clir
bake_ir 68k "$BAKE"
CBAKE=$WORK/rtc.clir
bake_ir c "$CBAKE"

# The atalk/tcp bake twins keep their fixture in a heredoc; reuse it.
for t in atalk tcp; do
    sed -n "/<<'CLA'\$/,/^CLA\$/p" "$ROOT/tests/bake/$t.sh" | sed '1d;$d' > "$WORK/$t.cla"
    [ -s "$WORK/$t.cla" ] || die "could not extract the $t.sh fixture"
done

# pair NAME EMIT BAKEFILE FILE: one from-source/--rtbake dump comparison.
# The C lane (host `emit`) has no bake self-check of its own, and once the
# 68k library drops IR bodies the summary is shake's only source for baked
# runtime functions on both lanes.
pair() {
    nm=$1 emit=$2 bk=$3 f=$4
    s=$WORK/$nm.src.dump
    b=$WORK/$nm.bake.dump
    if ! "$CLARUSC" $emit --shake-dump "$s" -o "$WORK/$nm.src.out" "$f" > "$WORK/$nm.src.log" 2>&1; then
        t_fail "$nm" "from-source compile failed: $(tail -2 "$WORK/$nm.src.log" | tr '\n' ' ')"
        return
    fi
    if ! "$CLARUSC" $emit --rtbake "$bk" --shake-dump "$b" -o "$WORK/$nm.bake.out" "$f" > "$WORK/$nm.bake.log" 2>&1; then
        t_fail "$nm" "--rtbake compile failed: $(tail -2 "$WORK/$nm.bake.log" | tr '\n' ' ')"
        return
    fi
    if grep -q 'falling back' "$WORK/$nm.bake.log"; then
        t_fail "$nm" "--rtbake fell back to from-source"
        return
    fi
    # Clarus "\n" is CR; turn the dumps into ordinary lines.
    tr '\r' '\n' < "$s" > "$s.n"
    tr '\r' '\n' < "$b" > "$b.n"
    s=$s.n
    b=$b.n
    rs=$(sed -n 's/^R //p' "$s")
    rb=$(sed -n 's/^R //p' "$b")
    if [ "$rs" != 0 ] || [ -z "$rb" ] || [ "$rb" -le 0 ]; then
        t_fail "$nm" "replay counts: source '$rs' (want 0), rtbake '$rb' (want > 0)"
        return
    fi
    grep -v '^R ' "$s" > "$s.me"
    grep -v '^R ' "$b" > "$b.me"
    if ! grep -q '^E ' "$s.me"; then
        t_fail "$nm" "from-source dump has no edges"
    elif cmp -s "$s.me" "$b.me"; then
        t_pass "$nm"
    else
        t_fail "$nm" "marks/edges differ: $(diff "$s.me" "$b.me" | head -3 | tr '\n' ' ')"
    fi
}

for f in examples/bookmarks.cla examples/hello-mac.cla examples/texteditor.cla \
         examples/tcpchat.cla "$WORK/atalk.cla" "$WORK/tcp.cla"; do
    pair "$(basename "$f" .cla)" build68k "$BAKE" "$f"
done
# tcpchat and the twins use connection/AppleTalk, which the C-lane bake
# omits (from-source fallback), so the C pair covers the other three.
for f in examples/bookmarks.cla examples/hello-mac.cla examples/texteditor.cla; do
    pair "c-$(basename "$f" .cla)" emit "$CBAKE" "$f"
done
t_done
