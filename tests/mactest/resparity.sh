#!/bin/sh
# tests/mactest/resparity.sh -- port of internal/mactest/resparity_test.go:
# TestApp68kResourceParity, TestApp68kIconMissingWarns and
# TestApp68kIconAcceptsCRLineEndings. No emulator, no Retro68, no cmake --
# just `clarusc emit68k` plus resfork, an independent resource-fork reader.
#
# The testdata/mac/resparity/*.bin goldens are FROZEN, pinned once from a
# real Retro68 build of the same two fixtures: any divergence is a real
# app68k/res68k regression, so there is deliberately no bless variable
# (golden_check's third argument is an always-unset name).
. "$(dirname "$0")/../lib.sh"

RESFORK=$TOOLS/resfork
GOLD=$ROOT/testdata/mac/resparity
NO_BLESS=RESPARITY_GOLDENS_ARE_FROZEN

# build_probe DIR FIXTURE : emit68k FIXTURE to DIR/out.bin, log to DIR/emit.log
build_probe() {
    mkdir -p "$1" || return 1
    emit68k -o "$1/out.bin" "$2" > "$1/emit.log" 2>&1
}

# check_goldens PREFIX IMG : read "TYPE ID" pairs on stdin, extract each
# resource and byte-compare it against $GOLD/PREFIX_TYPE_ID.bin.
check_goldens() {
    _prefix=$1
    _img=$2
    _bad=
    while read -r _typ _id; do
        [ -n "$_typ" ] || continue
        _out=$WORK/$_prefix.$_typ.$_id
        if ! "$RESFORK" get "$_img" "$_typ" "$_id" "$_out" 2>"$WORK/get.err"; then
            _bad="$_bad $(cat "$WORK/get.err");"
            continue
        fi
        golden_check "$_out" "$GOLD/${_prefix}_${_typ}_${_id}.bin" "$NO_BLESS" > "$WORK/gc.out" 2>&1 \
            || _bad="$_bad ${_typ} ${_id}: $(head -2 "$WORK/gc.out" | tr '\n' ' ');"
    done
    if [ -z "$_bad" ]; then
        t_pass "${_prefix}_goldens"
    else
        t_fail "${_prefix}_goldens" "$_bad"
    fi
}

# size_flags IMG : the SIZE(-1) flag word, as 4 lowercase hex digits.
size_flags() { "$RESFORK" size "$1" | cut -c1-4; }

# --------------------------------------------------------------------
# TestApp68kResourceParity / appres_icon: app section WITH a declared icon
# --------------------------------------------------------------------
A=$WORK/appres
if ! build_probe "$A" testdata/ui/appres.cla; then
    t_fail appres_build "emit68k failed: $(tail -3 "$A/emit.log")"
else
    creator=$("$RESFORK" header "$A/out.bin" | sed -n 's/.*creator=\([^ ]*\).*/\1/p')
    if [ "$creator" = PRBR ]; then
        t_pass appres_creator
    else
        t_fail appres_creator "creator = \"$creator\", want \"PRBR\" (appres.cla declares id: \"PRBR\")"
    fi
    # DITL 129 is the 5-item variant here: it has the Icon item.
    check_goldens appres "$A/out.bin" <<'EOF'
ALRT 128
DITL 128
ALRT 129
DITL 129
ALRT 130
DITL 130
vers 1
PRBR 0
FREF 128
FREF 129
BNDL 128
ICN# 128
ICON 128
ICN# 129
ICON 129
EOF
    # SIZE(-1): only the FLAG WORD is a Rez parity target (the two size
    # longs are this backend's own tuning choice). 0x00C0 =
    # is32BitCompatible|isHighLevelEventAware. `resfork size` itself fails
    # unless the resource is exactly 10 bytes.
    if ! flags=$(size_flags "$A/out.bin" 2>&1); then
        t_fail appres_size "$flags"
    elif [ "$flags" = 00c0 ]; then
        t_pass appres_size
    else
        t_fail appres_size "SIZE flags = 0x$flags, want 0x00C0 (is32BitCompatible|isHighLevelEventAware)"
    fi
fi

# --------------------------------------------------------------------
# TestApp68kResourceParity / about_noicon: app section with NO icon
# --------------------------------------------------------------------
B=$WORK/about
if ! build_probe "$B" testdata/ui/about.cla; then
    t_fail about_build "emit68k failed: $(tail -3 "$B/emit.log")"
else
    creator=$("$RESFORK" header "$B/out.bin" | sed -n 's/.*creator=\([^ ]*\).*/\1/p')
    if [ "$creator" = PRBA ]; then
        t_pass about_creator
    else
        t_fail about_creator "creator = \"$creator\", want \"PRBA\" (about.cla declares id: \"PRBA\")"
    fi
    # DITL 129 is the 4-item variant here: no icon declared.
    check_goldens about "$B/out.bin" <<'EOF'
ALRT 128
DITL 128
ALRT 129
DITL 129
ALRT 130
DITL 130
vers 1
EOF
    # about.cla declares no icon: no signature STR/FREF/BNDL/ICN#/ICON
    # family at all.
    stray=$("$RESFORK" list "$B/out.bin" | awk '$1=="FREF"||$1=="BNDL"||$1=="ICN#"||$1=="ICON"{printf "%s %s;", $1, $2}')
    if [ -z "$stray" ]; then
        t_pass about_no_icon_family
    else
        t_fail about_no_icon_family "unexpected icon-family resource(s): $stray (about.cla declares no icon)"
    fi
    if ! flags=$(size_flags "$B/out.bin" 2>&1); then
        t_fail about_size "$flags"
    elif [ "$flags" = 00c0 ]; then
        t_pass about_size
    else
        t_fail about_size "SIZE flags = 0x$flags, want 0x00C0 (is32BitCompatible|isHighLevelEventAware)"
    fi
fi

# --------------------------------------------------------------------
# TestApp68kIconMissingWarns: a missing/malformed icon file WARNS on both
# channels and falls back to hasIcon=false -- exactly the path an
# icon-less program already takes, so the two forks must be identical.
# The two builds share the SAME -o basename in different dirs: the
# MacBinary header's filename field mirrors -o's basename, so a different
# name would make an otherwise-identical fork differ at byte 2.
# --------------------------------------------------------------------
WI=$WORK/iconmissing_with
ST=$WORK/iconmissing_stripped
mkdir -p "$WI" "$ST" || die "mkdir"
cp testdata/ui/iconmissing.cla "$WI/iconmissing.cla" || die "cp"
grep -v 'icon:' testdata/ui/iconmissing.cla > "$ST/iconmissing.cla" || die "strip"

if ! emit68k -o "$WI/out.bin" "$WI/iconmissing.cla" > "$WI/emit.log" 2>&1; then
    t_fail icon_missing_warns "clarusc emit68k (icon missing) failed (want success): $(tail -3 "$WI/emit.log")"
# The directory half of the path is matched with `.*` rather than pinned
# to $WI: clarusc normalizes the "//" a TMPDIR ending in "/" leaves in
# $WORK, so an exact-path pattern would spuriously miss.
elif ! grep -q 'warning: cannot read app icon .*/no-such-file\.pbm: .*; using default icon' "$WI/emit.log"; then
    t_fail icon_missing_warns "emit68k output missing the icon warning: $(grep -i warn "$WI/emit.log" | head -2)"
else
    t_pass icon_missing_warns
fi

if ! emit68k -o "$ST/out.bin" "$ST/iconmissing.cla" > "$ST/emit.log" 2>&1; then
    t_fail icon_stripped_silent "clarusc emit68k (icon stripped) failed: $(tail -3 "$ST/emit.log")"
elif grep -q 'warning:' "$ST/emit.log"; then
    t_fail icon_stripped_silent "icon-stripped fixture unexpectedly warned: $(grep 'warning:' "$ST/emit.log" | head -1)"
else
    t_pass icon_stripped_silent
fi

if [ -f "$WI/out.bin" ] && [ -f "$ST/out.bin" ] && cmp -s "$WI/out.bin" "$ST/out.bin"; then
    t_pass icon_missing_fork_identical
else
    t_fail icon_missing_fork_identical "icon-missing fork not byte-identical to icon-stripped fork: $(cmp "$WI/out.bin" "$ST/out.bin" 2>&1 | head -1)"
fi

# Icon-PRESENT regression check: examples/mandelbrot.cla's own pbm
# resolves, so its compile must still succeed with no warning at all.
MB=$WORK/mandel
mkdir -p "$MB" || die "mkdir"
if ! emit68k -o "$MB/mandel.bin" examples/mandelbrot.cla > "$MB/emit.log" 2>&1; then
    t_fail icon_present_silent "clarusc emit68k examples/mandelbrot.cla failed: $(tail -3 "$MB/emit.log")"
elif grep -q 'warning:' "$MB/emit.log"; then
    t_fail icon_present_silent "examples/mandelbrot.cla (icon present, resolves) unexpectedly warned: $(grep 'warning:' "$MB/emit.log" | head -1)"
else
    t_pass icon_present_silent
fi

# --------------------------------------------------------------------
# TestApp68kIconAcceptsCRLineEndings: a Mac-staged (CR) or CRLF PBM icon
# must decode identically to its LF original -- app68PbmDecode/
# app68PbmSkipWs must not fall back to the warn-and-continue no-icon path
# just because the line terminators aren't bare LF. (The PBM's header
# carries a '#' comment line, the trigger for the comment-to-EOL scan bug:
# it only recognized LF, so a CR-only comment ate the rest of the file.)
# --------------------------------------------------------------------
cat > "$WORK/iconcrlf.cla" <<'EOF'
app IconCRLFProbe {
    name: "Icon CRLF Probe"
    version: "1.0"
    author: "Test"
    about: "Icon CRLF probe."
    icon: "icon.pbm"
    id: "TCRL"
}

window Main {
    title: "Main"
    size: 200, 100
}

on App.launch {
    open Main
}
EOF

PBM=$ROOT/tests/mactest/testdata/icon_probe.pbm
tr '\n' '\r' < "$PBM" > "$WORK/icon_cr.pbm"
sed 's/$/\r/' "$PBM" > "$WORK/icon_crlf.pbm"

# crlf_variant NAME PBMFILE : stage the probe + that PBM in a fresh dir
# (same -o basename everywhere) and build it.
crlf_variant() {
    _d=$WORK/crlf_$1
    mkdir -p "$_d" || return 1
    cp "$WORK/iconcrlf.cla" "$_d/iconcrlf.cla" || return 1
    cp "$2" "$_d/icon.pbm" || return 1
    emit68k -o "$_d/out.bin" "$_d/iconcrlf.cla" > "$_d/emit.log" 2>&1
}

if ! crlf_variant lf "$PBM"; then
    t_fail icon_crlf "LF baseline emit68k failed: $(tail -3 "$WORK/crlf_lf/emit.log")"
    t_done
fi
if grep -q 'warning:' "$WORK/crlf_lf/emit.log"; then
    t_fail icon_crlf_lf_silent "LF baseline PBM unexpectedly warned: $(grep 'warning:' "$WORK/crlf_lf/emit.log" | head -1)"
    t_done
fi
# The baseline must really have produced an icon family, or the
# comparisons below are vacuous.
have=$("$RESFORK" list "$WORK/crlf_lf/out.bin" | awk '($1=="ICN#"||$1=="ICON") && $2==128 {printf "%s;", $1}')
if [ "$have" = "ICN#;ICON;" ]; then
    t_pass icon_crlf_lf_baseline
else
    t_fail icon_crlf_lf_baseline "LF baseline PBM produced no ICN#/ICON 128 resource (found [$have])"
    t_done
fi

for v in cr crlf; do
    if ! crlf_variant "$v" "$WORK/icon_$v.pbm"; then
        t_fail "icon_crlf_$v" "emit68k failed: $(tail -3 "$WORK/crlf_$v/emit.log")"
    elif grep -q 'warning:' "$WORK/crlf_$v/emit.log"; then
        t_fail "icon_crlf_$v" "$v-terminated PBM produced a malformed-icon/cannot-read warning; want silent accept"
    elif cmp -s "$WORK/crlf_lf/out.bin" "$WORK/crlf_$v/out.bin"; then
        t_pass "icon_crlf_$v"
    else
        t_fail "icon_crlf_$v" "$v fork differs from the LF baseline: $(cmp "$WORK/crlf_lf/out.bin" "$WORK/crlf_$v/out.bin" 2>&1 | head -1)"
    fi
done

t_done
