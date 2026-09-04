#!/bin/sh
# lowlevel/rtinc.sh -- port of internal/lowlevel/rtinc_test.go: TestRtInc's
# 6 subtests and TestTestApiFlag's 3 -- 9 subcases named after the Go
# subtests (ToolboxIncludeFallbackCheckOnly's two nested subtests report
# under their parent's name, as one case).
#
# Every "no runtime/clarus/ anywhere above this" cwd is a fresh dir under
# $WORK (mktemp -d in $TMPDIR), the shell twin of Go's t.TempDir().
. "$(dirname "$0")/../lib.sh" || exit 2

prog=$ROOT/testdata/rtinc/prog.cla
noflag=$ROOT/testdata/rtinc/noflag.cla
rtdir=$ROOT/testdata/rtinc/rt
clarusrt=$ROOT/runtime/clarus            # no trailing slash, as in the Go test
fallback=$ROOT/testdata/rtinc/toolbox_fallback/main.cla
cannotopen='cannot open included file "toolbox/files.cla"'

# --- IncludesRuntimeModule -------------------------------------------
# rt/ser.cla includes rt/helper.cla: both must be spliced, helper first,
# and the runtime module's decls must precede every user decl. The Go test
# compares byte offsets of "clar_fn_rtIncHelper" / "clar_fn_rtFileSave" /
# the first "clar_fn_"; the ordered stream of clar_fn_ symbols below is the
# same comparison without needing byte arithmetic in sh.
n=IncludesRuntimeModule
if ! "$CLARUSC" emit -o "$WORK/inc.c" --rtdir "$rtdir" "$prog" > "$WORK/inc.log" 2>&1; then
    t_fail "$n" "emit failed: $(head -3 "$WORK/inc.log" | tr '\n' ' ')"
else
    grep -o 'clar_fn_[A-Za-z0-9_]*' "$WORK/inc.c" > "$WORK/inc.syms"
    ih=$(grep -n 'clar_fn_rtIncHelper' "$WORK/inc.syms" | head -1 | cut -d: -f1)
    fs=$(grep -n 'clar_fn_rtFileSave' "$WORK/inc.syms" | head -1 | cut -d: -f1)
    if [ -z "$fs" ]; then
        t_fail "$n" "emitted C missing clar_fn_rtFileSave"
    elif [ -z "$ih" ]; then
        t_fail "$n" "emitted C missing clar_fn_rtIncHelper (ser.cla's own include silently dropped)"
    elif [ "$ih" -ge "$fs" ]; then
        t_fail "$n" "clar_fn_rtIncHelper (sym $ih) must precede clar_fn_rtFileSave (sym $fs)"
    elif [ "$ih" -ne 1 ]; then
        t_fail "$n" "clar_fn_rtIncHelper is not the first clar_fn_ symbol (first is $(head -1 "$WORK/inc.syms"))"
    else
        t_pass "$n"
    fi
fi

# --- MissingRtdirErrors ----------------------------------------------
# No --rtdir and a cwd with no runtime/clarus/ above it: the fatal abort
# prints "runtime module" on stderr.
n=MissingRtdirErrors
mkdir -p "$WORK/nortdir"
( cd "$WORK/nortdir" && "$CLARUSC" emit -o "$WORK/miss.c" "$prog" ) \
    > "$WORK/miss.out" 2> "$WORK/miss.err"
rc=$?
if [ $rc -eq 0 ]; then
    t_fail "$n" "expected nonzero exit, got success"
elif ! grep -q 'runtime module' "$WORK/miss.err"; then
    t_fail "$n" "stderr missing \"runtime module\": $(head -3 "$WORK/miss.err" | tr '\n' ' ')"
else
    t_pass "$n"
fi

# --- ToolboxIncludeFallback ------------------------------------------
# toolbox_fallback/main.cla's bare `include "toolbox/..."` spellings only
# resolve via the rtdir-sibling fallback; a clean compile also proves the
# two routes to toolbox/files.cla dedup instead of redeclaring.
n=ToolboxIncludeFallback
if "$CLARUSC" emit -o "$WORK/fb.c" --rtdir "$clarusrt" "$fallback" > "$WORK/fb.log" 2>&1; then
    t_pass "$n"
else
    t_fail "$n" "emit failed: $(head -3 "$WORK/fb.log" | tr '\n' ' ')"
fi

# --- ToolboxIncludeFallbackNoRtDir -----------------------------------
# Same fixture, no --rtdir, cwd with no runtime/clarus/ above: the
# fallback stays a silent no-op and the ordinary cannot-open diagnostic
# (emitDiag, on stdout) still fires.
n=ToolboxIncludeFallbackNoRtDir
mkdir -p "$WORK/fbnort"
( cd "$WORK/fbnort" && "$CLARUSC" emit -o "$WORK/fbnort.c" "$fallback" ) \
    > "$WORK/fbnort.out" 2> "$WORK/fbnort.err"
rc=$?
if [ $rc -eq 0 ]; then
    t_fail "$n" "expected nonzero exit, got success"
elif ! grep -qF "$cannotopen" "$WORK/fbnort.out"; then
    t_fail "$n" "stdout missing the honest cannot-open diagnostic: $(head -3 "$WORK/fbnort.out" | tr '\n' ' ')"
else
    t_pass "$n"
fi

# --- ToolboxIncludeFallbackCheckOnly ---------------------------------
# Bare check-only mode (no emit subcommand) over a copy of the WHOLE
# fixture directory -- main.cla AND sub/foo.cla -- in a dir with no
# runtime/clarus/ anywhere above it (Go's copyDir into t.TempDir()).
co=$WORK/checkonly
mkdir -p "$co"
cp -R "$ROOT/testdata/rtinc/toolbox_fallback/." "$co/"

# Both nested Go subtests (WithRtDir, NoRtDirStillErrors) report under the
# parent subtest's name; the detail string says which half broke.
n=ToolboxIncludeFallbackCheckOnly
why=
if ! ( cd "$co" && "$CLARUSC" --rtdir "$clarusrt" main.cla ) > "$WORK/co1.out" 2> "$WORK/co1.err"; then
    why="WithRtDir: check failed: $(cat "$WORK/co1.out" "$WORK/co1.err" | head -3 | tr '\n' ' ')"
fi
( cd "$co" && "$CLARUSC" main.cla ) > "$WORK/co2.out" 2> "$WORK/co2.err"
rc=$?
if [ $rc -eq 0 ]; then
    why="$why NoRtDirStillErrors: expected nonzero exit, got success"
elif ! grep -qF "$cannotopen" "$WORK/co2.out"; then
    why="$why NoRtDirStillErrors: stdout missing the honest cannot-open diagnostic: $(head -3 "$WORK/co2.out" | tr '\n' ' ')"
fi
[ -z "$why" ] && t_pass "$n" || t_fail "$n" "$why"

# --- NoInclusionWithoutUsage -----------------------------------------
# noflag.cla never calls file.save, so no runtime module is spliced.
n=NoInclusionWithoutUsage
if ! "$CLARUSC" emit -o "$WORK/nf.c" "$noflag" > "$WORK/nf.log" 2>&1; then
    t_fail "$n" "emit failed: $(head -3 "$WORK/nf.log" | tr '\n' ' ')"
elif grep -q 'rtFileSave' "$WORK/nf.c"; then
    t_fail "$n" "emitted C unexpectedly contains rtFileSave"
else
    t_pass "$n"
fi

# --- TestTestApiFlag -------------------------------------------------
# A UI program naming UiTest* only checks clean when uitest.cla is spliced
# (--testapi); a windowless program is unaffected either way.
cat > "$WORK/uiprog.cla" <<'EOF'
window Panel {
    title: "Panel"
    size: 300, 160

    button Go { at: 20, 20; caption: "Go"; width: 80 }
}

on App.launch {
    open Panel
}

extend Panel {
    on Go.click {
        UiTestClick(10, 10)
        UiTestChecksum(0, 0, 8, 8)
    }
}
EOF
cat > "$WORK/nonui.cla" <<'EOF'
on App.startCLI(args: list of string) {
    alert("hi")
}
EOF

n=WithFlagResolves
if ! "$CLARUSC" emit --testapi --rtdir "$clarusrt" -o "$WORK/ui.c" "$WORK/uiprog.cla" \
        > "$WORK/ui.log" 2>&1; then
    t_fail "$n" "emit failed: $(head -3 "$WORK/ui.log" | tr '\n' ' ')"
elif ! grep -q 'clar_fn_UiTestVerb' "$WORK/ui.c"; then
    t_fail "$n" "emitted C missing clar_fn_UiTestVerb (uitest.cla not spliced)"
else
    t_pass "$n"
fi

n=WithoutFlagRejected
"$CLARUSC" emit --rtdir "$clarusrt" -o "$WORK/ui2.c" "$WORK/uiprog.cla" > "$WORK/ui2.log" 2>&1
rc=$?
if [ $rc -eq 0 ]; then
    t_fail "$n" "expected nonzero exit (UiTestClick undefined without --testapi), got success"
elif ! grep -q 'UiTestClick' "$WORK/ui2.log"; then
    t_fail "$n" "diagnostic missing \"UiTestClick\": $(head -3 "$WORK/ui2.log" | tr '\n' ' ')"
else
    t_pass "$n"
fi

n=NonUiNoop
if ! "$CLARUSC" emit --testapi --rtdir "$clarusrt" -o "$WORK/nu.c" "$WORK/nonui.cla" \
        > "$WORK/nu.log" 2>&1; then
    t_fail "$n" "emit failed: $(head -3 "$WORK/nu.log" | tr '\n' ' ')"
elif grep -q 'clar_fn_UiTestVerb' "$WORK/nu.c"; then
    t_fail "$n" "emitted C unexpectedly contains clar_fn_UiTestVerb for a non-UI program"
else
    t_pass "$n"
fi

t_done
