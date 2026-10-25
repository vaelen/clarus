#!/bin/sh
# Port of internal/bake/bake_test.go's TestBakeHeaderSanity: parse each
# lane's artifact and check the fixed header fields (magic and the
# every-byte-accounted-for section framing are clirhdr's own exit status)
# plus the per-lane module manifest.
#
# modules 30 (68k) / 21 (c) mirrors clarusc/bake.cla's bakeModuleList and
# the Go test's wantModuleCounts: 21 modules on both lanes, plus
# conn.cla + conn_68k.cla + atalk.cla + atalk_68k.cla + tcp.cla +
# tcp_68k.cla + fileh.cla + fileh_68k.cla + native.cla on the 68k lane's
# unconditional full-superset splice (the c lane keeps conn/atalk/tcp/
# fileh usage-gated, so none of those pairs is ever in its bake list).
# 23 -> 25 in the AppleTalk phase's Task 9, when the atalk pair joined
# that splice; 25 -> 27 in the MacTCP phase's Task 6, when the tcp pair
# did; 27/18 -> 28/19 in SE wave 3 Task 2, when the boxsize lane pair
# (boxsize_68k.cla / boxsize_c.cla, one per lane) joined both lists;
# 28/19 -> 30/21 in ui-widgets Task 2, when uilog.cla and uifont.cla did.
# sections 47 (68k) / 48 (c) are bkSectionCount68k/bkSectionCountC: 48
# on both lanes after SE wave 4 Task 2 (+bkSecShakeSummary); CLIR v9 (SE
# wave 4 Task 6) drops IrStmts/IrExprs from the 68k library and adds
# bkSecGlobalInits, the c library keeps its bodies. version 9 is that
# format: a section directory, no body hash, an indexed ObjCode section
# (v8 was language-runtime-cleanup's IRWindowDesc.menuMask).
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"

for lane in 68k c; do
    case $lane in
        68k) modules=30 sections=47 ;;
        c)   modules=21 sections=48 ;;
    esac

    bake_ir "$lane" "$WORK/$lane.clir"
    if ! "$CLIRHDR" "$WORK/$lane.clir" > "$WORK/$lane.hdr" 2> "$WORK/$lane.err"; then
        t_fail "$lane/parse" "$(cat "$WORK/$lane.err")"
        continue
    fi

    got=$(clir_field version "$WORK/$lane.hdr")
    [ "$got" = 9 ] && t_pass "$lane/version" \
        || t_fail "$lane/version" "version = $got, want 9 (SE wave 4 Task 6: section directory, no body hash, no 68k IR bodies, indexed ObjCode)"

    got=$(clir_field lane "$WORK/$lane.hdr")
    [ "$got" = "$lane" ] && t_pass "$lane/lanetag" \
        || t_fail "$lane/lanetag" "lane tag = $got, want $lane"

    got=$(clir_field stamp "$WORK/$lane.hdr")
    [ -n "$got" ] && t_pass "$lane/stamp" \
        || t_fail "$lane/stamp" "stamp is empty, want a non-empty compiler-identity hash"

    got=$(clir_field modules "$WORK/$lane.hdr")
    [ "$got" = "$modules" ] && t_pass "$lane/modules" \
        || t_fail "$lane/modules" "modules = $got, want $modules; keys: $(sed -n 's/^module //p' "$WORK/$lane.hdr" | tr '\n' ' ')"

    got=$(clir_field sections "$WORK/$lane.hdr")
    [ "$got" = "$sections" ] && t_pass "$lane/sections" \
        || t_fail "$lane/sections" "sections = $got, want $sections (bkSectionCount68k/bkSectionCountC)"

    # The 68k library carries no IR bodies (IrStmts 2, IrExprs 3) and has
    # the GlobalInits arena (52); the c library is the other way round.
    ids=$(awk '$1 == "section" && ($2 == 2 || $2 == 3 || $2 == 52) { print $2 }' "$WORK/$lane.hdr" | tr '\n' ' ')
    case $lane in
        68k) want="52 " ;;
        c)   want="2 3 " ;;
    esac
    [ "$ids" = "$want" ] && t_pass "$lane/bodies" \
        || t_fail "$lane/bodies" "body/GlobalInits sections = '$ids', want '$want'"

    # Every module key follows rtModuleKey's "runtime/clarus/NAME" scheme
    # (Go: filepath.Dir(m) == "runtime/clarus", i.e. exactly one path
    # segment under it).
    sed -n 's/^module //p' "$WORK/$lane.hdr" > "$WORK/$lane.mods"
    bad=$(grep -v '^runtime/clarus/[^/]*$' "$WORK/$lane.mods" | tr '\n' ' ')
    [ -z "$bad" ] && t_pass "$lane/modkeys" \
        || t_fail "$lane/modkeys" "module keys not under runtime/clarus/: $bad"

    # native.cla is present iff this is the 68k lane.
    if grep -qx 'runtime/clarus/native.cla' "$WORK/$lane.mods"; then have=true; else have=false; fi
    case $lane in
        68k) want=true ;;
        c)   want=false ;;
    esac
    [ "$have" = "$want" ] && t_pass "$lane/native" \
        || t_fail "$lane/native" "native.cla present = $have, want $want (lane $lane)"
done
t_done
