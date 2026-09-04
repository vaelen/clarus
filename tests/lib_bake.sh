# tests/lib_bake.sh -- bake-group helpers, sourced right after lib.sh.

CLIRHDR=$TOOLS/clirhdr

# bake_ir LANE OUT : mirrors internal/bake.RunBakeIR. lib.sh has already
# cd'd to the repo root, which is what RunBakeIR's cmd.Dir does, so the
# default --rtdir search finds runtime/clarus/ the way an ordinary
# `clarusc emit68k` invocation does. RunBakeIR t.Fatalf's on a failed
# bake; die is the script-side equivalent.
bake_ir() {
    "$CLARUSC" --bake-ir --lane "$1" -o "$2" || die "clarusc --bake-ir --lane $1 -o $2 failed"
}

# clir_field KEY HDR : the value of one key=value pair on clirhdr's first
# output line (the `module`/`section` lines that follow carry no "=", so
# the NR==1 guard is belt-and-braces).
clir_field() {
    awk -v k="$1" 'NR==1{for(i=1;i<=NF;i++){n=index($i,"=");
        if(substr($i,1,n-1)==k){print substr($i,n+1);exit}}}' "$2"
}

# emit68k_pair NAME FILES... : compile FILES twice -- plain from-source and
# `emit68k --rtbake "$BAKE"` -- and compare the two images. Mirrors
# bakeidentity_test.go's runEmit68k, called once per fork.
#
# The two outputs share a BASENAME in separate subdirectories, never
# distinct basenames in one directory: the MacBinary wrap embeds the OUTPUT
# FILENAME in its header (cg68WriteImageWrap), so two differently-NAMED
# forks of identical code still differ byte-for-byte in that field alone --
# the exact false alarm TestBakePathByteIdentity's own doc comment flags.
#
# Knobs, read as globals:
#   BAKE      the .clir artifact to load (required)
#   PAIRFLAGS extra flags for BOTH forks, word-split (--testapi, --rtdir)
#   PAIRFB    `forbid` (default) fails on runEmit68k's own "falling back"
#             note: a silent from-source fallback would make the
#             comparison pass VACUOUSLY, comparing from-source against a
#             from-source recompile and proving nothing about --rtbake.
#             `ignore` skips that check, for the one ported test
#             (TestBakeFullCorpusTestapi) whose Go original does not make
#             it either.
#
# Prints the failure reason on stdout and returns 1; silent, returns 0, on
# success -- so a caller with subcases can wrap it in t_pass/t_fail.
emit68k_pair() {
    _nm=$1; shift
    mkdir -p "$WORK/src/$_nm" "$WORK/bake/$_nm" || { echo "mkdir failed"; return 1; }
    _so=$WORK/src/$_nm/out.bin
    _bo=$WORK/bake/$_nm/out.bin
    if ! "$CLARUSC" emit68k ${PAIRFLAGS:-} -o "$_so" "$@" > "$WORK/pair-src.log" 2>&1; then
        echo "from-source compile failed: $(head -3 "$WORK/pair-src.log" | tr '\n' ' ')"
        return 1
    fi
    if ! "$CLARUSC" emit68k ${PAIRFLAGS:-} --rtbake "$BAKE" -o "$_bo" "$@" > "$WORK/pair-bake.log" 2>&1; then
        echo "--rtbake compile failed: $(head -3 "$WORK/pair-bake.log" | tr '\n' ' ')"
        return 1
    fi
    if [ "${PAIRFB:-forbid}" = forbid ] && grep -q 'falling back' "$WORK/pair-bake.log"; then
        echo "unexpectedly fell back to from-source -- expected the real bake path: $(grep 'falling back' "$WORK/pair-bake.log" | head -1)"
        return 1
    fi
    cmp -s "$_so" "$_bo" && return 0
    echo "--rtbake fork ($(wc -c < "$_bo" | tr -d ' ') bytes) != from-source fork ($(wc -c < "$_so" | tr -d ' ') bytes): $(cmp "$_so" "$_bo" 2>&1 | head -1)"
    return 1
}

# write_testapi_fixture PATH : bakeidentity_test.go's testapiFixtureSrc +
# writeTestapiFixture, verbatim -- a small UI program that BOTH declares a
# window (driveEarlySplice's own isUiProgram gate) and actually CALLS a
# UiTest* function. Shared by testapi_positive.sh and
# full_corpus_testapi.sh, exactly as the Go const is.
write_testapi_fixture() {
    cat > "$1" <<'CLA'
app TestapiFixture {
    name: "TestapiFixture"
    version: "1.0"
    author: "Andrew C. Young <andrew@vaelen.org>"
    about: "runtime-ir-bake Task 5 testapi fixture."
    id: "TAPI"
}

window Probe {
    title: "TestapiFixture"
    size: 300, 120
}

on App.launch {
    open Probe
}

extend Probe {
    on opened {
        UiTestVerb("click Foo")
    }
}
CLA
}
