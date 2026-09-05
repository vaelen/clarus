#!/bin/sh
# Port of internal/bake/bake_test.go's TestBakeHeaderSanity: parse each
# lane's artifact and check the fixed header fields (magic and the
# every-byte-accounted-for section framing are clirhdr's own exit status)
# plus the per-lane module manifest.
#
# modules 23 (68k) / 18 (c) mirrors clarusc/bake.cla's bakeModuleList and
# the Go test's wantModuleCounts: 18 shared modules on both lanes, plus
# conn.cla + conn_68k.cla + fileh.cla + fileh_68k.cla + native.cla on the
# 68k lane's unconditional full-superset splice (the c lane keeps
# conn/fileh usage-gated, so neither pair is ever in its bake list).
# sections 46 is bkSectionCount. version 7 is clir-load-perf Task 4's
# format (hash swapped FNV-mul -> shift-add).
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"

for lane in 68k c; do
    case $lane in
        68k) modules=23 ;;
        c)   modules=18 ;;
    esac

    bake_ir "$lane" "$WORK/$lane.clir"
    if ! "$CLIRHDR" "$WORK/$lane.clir" > "$WORK/$lane.hdr" 2> "$WORK/$lane.err"; then
        t_fail "$lane/parse" "$(cat "$WORK/$lane.err")"
        continue
    fi

    got=$(clir_field version "$WORK/$lane.hdr")
    [ "$got" = 8 ] && t_pass "$lane/version" \
        || t_fail "$lane/version" "version = $got, want 8 (language-runtime-cleanup: +bkSecIrArrLits, +bkSecUitestBounds arrlit boundary)"

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
    [ "$got" = 47 ] && t_pass "$lane/sections" \
        || t_fail "$lane/sections" "sections = $got, want 47 (bkSectionCount, language-runtime-cleanup: +bkSecIrArrLits)"

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
