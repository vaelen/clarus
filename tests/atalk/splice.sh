#!/bin/sh
# tests/atalk/splice.sh (2026-09-06 appletalk spec %7, Task 7): the host
# splice of atalk.cla + atalk_c.cla, and the C-lane --rtbake gap that
# splice would otherwise widen.
#
# A program that merely DECLARES `service`/`serviceBrowser` sets the
# checker's usesAtalk, which now pulls conn.cla + conn_c.cla + atalk.cla +
# atalk_c.cla into the host manifest as one unit. Every AppleTalk method is
# still fenced in lowering (Task 8), so the fixture calls none: what is
# asserted here is that all four modules check, lower, emit compilable C
# and link, and that the runtime globals actually reached the output.
#
# Function-level coverage of atalk.cla's own bodies arrives with Task 8:
# shake.cla drops every runtime function nothing roots, and rtAtalkPump is
# rooted (beside rtConnPump/rtConnAlive) only once lowering wires the pump.
# The globals below are the available splice witness until then.
. "$(dirname "$0")/../lib.sh" || exit 2

FIX=$ROOT/tests/atalk/testdata/splice.cla

# --- 1. the host build ------------------------------------------------
if host_build "$WORK/splice" "$FIX" > "$WORK/build.log" 2>&1; then
    t_pass build
else
    t_fail build "$(tail -20 "$WORK/build.log")"
fi

for g in cv_rtAtUp cv_rtSvcState cv_rtAdspPhase cv_rtConnSlotTransport cv_rtConnState; do
    if grep -q "$g" "$WORK/splice.c" 2>/dev/null; then
        t_pass "spliced_$g"
    else
        t_fail "spliced_$g" "emitted C never mentions $g: the atalk/conn splice did not happen"
    fi
done

if [ -x "$WORK/splice" ]; then
    # log() writes to stderr on the host lane.
    "$WORK/splice" > "$WORK/out" 2> "$WORK/err"
    rc=$?
    if [ $rc -eq 0 ] && grep -q 'atalk splice fixture' "$WORK/err"; then
        t_pass run
    else
        t_fail run "exit $rc (stdout: $(cat "$WORK/out"), stderr: $(cat "$WORK/err"))"
    fi
else
    t_fail run "no binary to run"
fi

# --- 2. the C-lane --rtbake gap (docs/TODO.md's fix (b)) --------------
# bakeModuleList leaves the usage-gated host pairs out of the C-lane baked
# chain, and the bake path bypasses driveManifestSplice, so a host program
# using connection/filehandle/AppleTalk used to emit C that CALLED
# clar_fn_rtConnOpen/rtSvcServe with no definition anywhere. drive.cla now
# falls back to a from-source compile for exactly those programs.
if "$CLARUSC" --bake-ir --lane c -o "$WORK/RTC.clir" > "$WORK/bakeir.log" 2>&1; then
    t_pass bake_ir
else
    t_fail bake_ir "$(tail -20 "$WORK/bakeir.log")"
fi

rtbake_fork() {   # rtbake_fork NAME FILE.cla
    "$CLARUSC" emit --rtdir "$RTDIR" --rtbake "$WORK/RTC.clir" \
        -o "$WORK/$1.c" "$2" > "$WORK/$1.log" 2>&1
}

if rtbake_fork bake "$FIX"; then
    if grep -q 'falling back to a from-source compile' "$WORK/bake.log"; then
        t_pass bake_fallback_logged
    else
        t_fail bake_fallback_logged "no fallback line: $(cat "$WORK/bake.log")"
    fi
    if grep -q cv_rtAtUp "$WORK/bake.c"; then
        t_pass bake_spliced
    else
        t_fail bake_spliced "the baked fork never spliced atalk.cla"
    fi
    if $CC -O1 -I "$HOSTRT" -o "$WORK/bake" "$WORK/bake.c" "$HOSTRT/rt.c" > "$WORK/bake.cc" 2>&1; then
        t_pass bake_compiles
    else
        t_fail bake_compiles "$(tail -20 "$WORK/bake.cc")"
    fi
else
    t_fail bake_fallback_logged "emit --rtbake failed: $(tail -20 "$WORK/bake.log")"
    t_fail bake_spliced "no output"
    t_fail bake_compiles "no output"
fi

# The same gap for a plain SERIAL connection program -- the shape
# docs/TODO.md's repro used, and the reason conn programs now carry
# atalk.cla too.
if rtbake_fork echo "$ROOT/tests/conntest/testdata/echo.cla"; then
    if grep -q 'falling back to a from-source compile' "$WORK/echo.log" \
        && grep -q 'clar_fn_rtConnOpen(int32_t' "$WORK/echo.c"; then
        t_pass bake_conn_defined
    else
        t_fail bake_conn_defined "rtConnOpen still undefined in the baked fork"
    fi
    if $CC -O1 -I "$HOSTRT" -o "$WORK/echo" "$WORK/echo.c" "$HOSTRT/rt.c" > "$WORK/echo.cc" 2>&1; then
        t_pass bake_conn_compiles
    else
        t_fail bake_conn_compiles "$(tail -20 "$WORK/echo.cc")"
    fi
else
    t_fail bake_conn_defined "emit --rtbake failed: $(tail -20 "$WORK/echo.log")"
    t_fail bake_conn_compiles "no output"
fi

# ...and the negative: an ordinary host program must still take the bake
# path. Without this, a fallback condition that over-triggers (or is left
# unconditional) would silently retire the whole --rtbake fast path.
cat > "$WORK/plain.cla" <<'EOF'
on App.startCLI(args: list of string) {
    log("plain")
}
EOF
if rtbake_fork plain "$WORK/plain.cla"; then
    if grep -q 'falling back to a from-source compile' "$WORK/plain.log"; then
        t_fail bake_plain_no_fallback "a runtime-free program fell back: $(cat "$WORK/plain.log")"
    else
        t_pass bake_plain_no_fallback
    fi
else
    t_fail bake_plain_no_fallback "emit --rtbake failed: $(tail -20 "$WORK/plain.log")"
fi

t_done
