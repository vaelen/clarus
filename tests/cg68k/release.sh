#!/bin/sh
# timeout: 15m
# cg68k/release -- port of internal/cg68k/callresult_release_test.go's
# TestCallResultRelease, TestGetterResultRelease and
# TestAndOrShortCircuitRelease: the per-function rtTextRelease call counts
# that pin the 68k call-result leak fix.
#
# These fixtures pull in the full runtime (--rtdir), so they pack into
# MULTIPLE segments and rtTextRelease does not land in the same segment as
# the fixture's own functions. A cross-segment call goes through the
# A5-relative jump table (`JSR d16(A5)`, d16 = cgJtDisp(slot) =
# 32 + slot*8 + 2), a same-segment call through `BSR.W LBL_n`/`JSR LBL_n`
# -- and a68 label numbers restart at 0 per segment, so the label form is
# only counted inside rtTextRelease's OWN segment.
. "$(dirname "$0")/../lib.sh" || exit 2

# --- helpers ---------------------------------------------------------

# seg_count DIR : how many out.segN.s listings emit68k wrote (0 = none)
seg_count() {
    _n=0
    while [ -f "$1/out.seg$((_n + 1)).s" ]; do _n=$((_n + 1)); done
    echo "$_n"
}

# find_release_info DIR : locate rtTextRelease's definition and derive both
# call forms. Sets REL_SEG (1-based segment number), REL_LBL (LBL_n) and
# REL_DISP (the jump-table displacement d of "JSR d(A5)"). Mirrors
# findReleaseInfo: markerRe `; func rtTextRelease\s+\(JT slot (\d+)\)`,
# then the FIRST `LBL_\d+:` after it; disp = 32 + slot*8 + 2.
find_release_info() {
    REL_SEG=; REL_LBL=; REL_DISP=
    _n=$(seg_count "$1")
    _i=1
    while [ "$_i" -le "$_n" ]; do
        _info=$(awk '
            !f && match($0, /; func rtTextRelease[ \t]+\(JT slot [0-9]+\)/) {
                s = substr($0, RSTART, RLENGTH)
                match(s, /[0-9]+\)$/)
                slot = substr(s, RSTART, RLENGTH - 1) + 0
                f = 1
                next
            }
            f && match($0, /LBL_[0-9]+:/) {
                print slot, substr($0, RSTART, RLENGTH - 1)
                exit
            }
        ' "$1/out.seg$_i.s")
        if [ -n "$_info" ]; then
            REL_SEG=$_i
            REL_LBL=${_info#* }
            _slot=${_info% *}
            REL_DISP=$((32 + _slot * 8 + 2))
            return 0
        fi
        # The marker with no label after it is the Go test's own fatal.
        if grep -qE '; func rtTextRelease[ 	]+\(JT slot [0-9]+\)' "$1/out.seg$_i.s"; then
            die "no label after rtTextRelease marker in segment $_i"
        fi
        _i=$((_i + 1))
    done
    die "no segment defines rtTextRelease"
}

# func_seg DIR NAME : echo the 1-based number of the FIRST segment that
# defines func NAME, or fail. Mirrors findFuncInSeg's literal-string scan
# over segments in order.
func_seg() {
    _n=$(seg_count "$1")
    _i=1
    while [ "$_i" -le "$_n" ]; do
        if grep -q "; func $2 " "$1/out.seg$_i.s"; then echo "$_i"; return 0; fi
        _i=$((_i + 1))
    done
    return 1
}

# func_body DIR SEG NAME : print func NAME's listing lines from just after
# the "; func NAME " marker to just before the next "; func " marker.
func_body() {
    awk -v m="; func $3 " '
        !f { i = index($0, m); if (i > 0) { f = 1; print substr($0, i + length(m)) } next }
        index($0, "; func ") > 0 { exit }
        { print }
    ' "$1/out.seg$2.s"
}

# count_release SEGIDX : count calls to rtTextRelease in the listing text
# on stdin (emitted into segment SEGIDX). Same-segment BSR.W/JSR to
# REL_LBL count only when SEGIDX == REL_SEG; cross-segment
# `JSR d(A5)` matches count from any segment.
count_release() {
    awk -v same="$([ "$1" = "$REL_SEG" ] && echo 1 || echo 0)" \
        -v lbl="$REL_LBL" -v disp="$REL_DISP" '
        function cnt(s, re,   k) {
            k = 0
            while (match(s, re)) { k++; s = substr(s, RSTART + RLENGTH) }
            return k
        }
        BEGIN {
            lblre = "(BSR\\.W|JSR)[ \t]+" lbl "[^0-9A-Za-z_]"
            # The literal "d(A5)" of Go`s regexp.QuoteMeta(rel.disp), with
            # the parens neutralised as bracket expressions.
            dispre = "JSR[ \t]+" disp "[(]A5[)]"
        }
        {
            # Trailing space stands in for Go`s \b at end-of-line.
            line = $0 " "
            if (same) n += cnt(line, lblre)
            n += cnt(line, dispre)
        }
        END { print n + 0 }
    '
}

# short_circuit_region : read a function body on stdin and print
# "OK <shortLbl>" (or "ERR <detail>") on line 1, followed by the guarded
# region -- the lines from the first `BEQ.W LBL_x` through the following
# `BRA.W LBL_y`. Mirrors shortCircuitRegion, including the check that the
# short label is bound AFTER the region.
short_circuit_region() {
    awk '
        { L[NR] = $0 }
        END {
            for (i = 1; i <= NR; i++)
                if (!start && L[i] ~ /^[ \t]*BEQ\.W[ \t]+LBL_[0-9]+[ \t]*$/) {
                    start = i
                    match(L[i], /LBL_[0-9]+/)
                    lbl = substr(L[i], RSTART, RLENGTH)
                }
            if (!start) { print "ERR no BEQ.W short-circuit branch in body"; exit }
            for (i = start + 1; i <= NR; i++)
                if (!end && index(L[i], "BRA.W ") > 0) end = i
            if (!end) { print "ERR no BRA.W closing the guarded region"; exit }
            for (i = 1; i <= NR; i++) {
                t = L[i]
                gsub(/^[ \t]+/, "", t); gsub(/[ \t]+$/, "", t)
                if (!bind && t == lbl ":") bind = i
            }
            if (!bind || bind <= end) {
                printf "ERR %s bound at line %d, not past the guarded region (ends %d)\n", lbl, bind + 0, end
                exit
            }
            print "OK " lbl
            for (i = start; i <= end; i++) print L[i]
        }
    '
}

# emit_fixture DIR : emit68k -o out.bin --listing --rtdir <rtdir> DIR/src.cla
emit_fixture() {
    if ! _out=$(emit68k -o "$1/out.bin" --listing "$1/src.cla" 2>&1); then
        echo "$_out"
        return 1
    fi
    return 0
}

# check_count CASE FN WANT : count releases in FN's whole body
check_count() {
    _seg=$(func_seg "$DIR" "$2") || { t_fail "$1" "no segment defines func $2"; return 1; }
    _body=$(func_body "$DIR" "$_seg" "$2")
    _got=$(printf '%s\n' "$_body" | count_release "$_seg")
    if [ "$_got" != "$3" ]; then
        t_fail "$1" "$2: $_got rtTextRelease calls, want $3"
        printf '%s\n' "$_body"
        return 1
    fi
    t_pass "$1"
    return 0
}

# ==== TestCallResultRelease ==========================================
DIR=$WORK/callresult
mkdir -p "$DIR" || die "mkdir $DIR"
cat > "$DIR/src.cla" <<'EOF'
func g(): text {
    var t: text
    t.append("hello")
    return t
}

func f(t: text): int {
    return t.length
}

func direct(): int {
    return f(g())
}

func viaLocal(): int {
    var x: text
    x = g()
    return f(x)
}

func recv(): int {
    return g().length
}

func opnd(): int {
    var n: int
    n = (g() + g()).length
    return n
}

on App.launch {
    log(string(direct() + viaLocal() + recv() + opnd()))
}
EOF
if ! emit_fixture "$DIR"; then
    t_fail callresult_emit "emit68k failed on the call-result fixture"
else
    find_release_info "$DIR"
    # direct: g()'s tracked result, released once after f returns.
    check_count callresult_direct direct 1
    # viaLocal: release of x's old value at init-store, at the g() store,
    # and at scope exit -- "no double release on the assignment path".
    check_count callresult_viaLocal viaLocal 3
    # recv: g()'s tracked result, released once after .length.
    check_count callresult_recv recv 1
    # opnd: two g() temps + the concat destination temp.
    check_count callresult_opnd opnd 3
fi

# ==== TestGetterResultRelease ========================================
DIR=$WORK/getter
mkdir -p "$DIR" || die "mkdir $DIR"
cat > "$DIR/src.cla" <<'EOF'
window LogWin {
    title: "L"
    textview LogView { at: 20, 20; fill: both }
}

func appendish(w: LogWin, filtered: text): text {
    var t: text
    t = w.LogView.text + filtered
    return t
}

on App.launch {
    var w: LogWin
    var extra: text
    appendish(w, extra)
}
EOF
if ! emit_fixture "$DIR"; then
    t_fail getter_emit "emit68k failed on the textview-getter fixture"
else
    find_release_info "$DIR"
    # pinned: pre-fix 4 (confirmed leak), post-fix 4+1 (the getter's box).
    check_count getter_appendish appendish 5
fi

# ==== TestAndOrShortCircuitRelease ===================================
DIR=$WORK/andor
mkdir -p "$DIR" || die "mkdir $DIR"
cat > "$DIR/src.cla" <<'EOF'
func g(): text {
    var t: text
    t.append("hello")
    return t
}

func h(): text {
    var t: text
    t.append("world")
    return t
}

func guarded(flag: bool): int {
    var s: text
    var n: int

    n = 0
    s = h()
    if flag and g().length > 0 {
        n = 1
    }
    return n + s.length
}

func guardedIntr(flag: bool, a: text): int {
    var n: int

    n = 0
    if flag and (a + a).length > 0 {
        n = 1
    }
    return n
}

on App.launch {
    var a: text
    log(string(guarded(false) + guardedIntr(false, a)))
}
EOF
if ! emit_fixture "$DIR"; then
    t_fail andor_emit "emit68k failed on the and/or short-circuit fixture"
else
    find_release_info "$DIR"
    # guarded: __store2's init box, s's old box before the store, g()'s
    # call-result temp (now guarded), s at scope exit -- 4 total, pinning
    # "moved, not added". guardedIntr: the concat temp only.
    for pair in guarded:4 guardedIntr:1; do
        fn=${pair%:*}
        want=${pair#*:}
        seg=$(func_seg "$DIR" "$fn") || { t_fail "andor_$fn" "no segment defines func $fn"; continue; }
        body=$(func_body "$DIR" "$seg" "$fn")
        got=$(printf '%s\n' "$body" | count_release "$seg")
        if [ "$got" != "$want" ]; then
            t_fail "andor_$fn" "$fn: $got rtTextRelease calls total, want $want"
            printf '%s\n' "$body"
        else
            t_pass "andor_$fn"
        fi

        region=$(printf '%s\n' "$body" | short_circuit_region)
        head1=$(printf '%s\n' "$region" | sed -n 1p)
        case "$head1" in
            OK\ *)
                shortLbl=${head1#OK }
                rgot=$(printf '%s\n' "$region" | sed -n '2,$p' | count_release "$seg")
                if [ "$rgot" != 1 ]; then
                    t_fail "andor_${fn}_guarded_region" "$fn: $rgot rtTextRelease calls inside the $shortLbl-guarded region, want 1"
                    printf '%s\n' "$region" | sed -n '2,$p'
                else
                    t_pass "andor_${fn}_guarded_region"
                fi
                ;;
            *)
                t_fail "andor_${fn}_guarded_region" "${head1#ERR }"
                printf '%s\n' "$body"
                ;;
        esac
    done
fi

t_done
