#!/bin/sh
# tests/emitui/appinfo.sh -- port of internal/emitui/appinfo_test.go (5
# tests). Pins the exact `clarusc appinfo` stdout contract the build
# scripts parse: `app=1` when the program declares an app section, then
# name/id/icon/version lines. Covers all three name-resolution rungs (the
# `name:` property, the app section's label, the first file's basename),
# the icon path's join against the DECLARING file's directory, and checker
# errors passing straight through (exit 1 + diagnostic, no special-casing).
. "$(dirname "$0")/../lib.sh"

code=0
run_appinfo() {
    "$CLARUSC" appinfo "$@" > "$WORK/out" 2> "$WORK/err" < /dev/null
    code=$?
}
# expect_ok NAME : exit 0 and stdout byte-identical to $WORK/want.
expect_ok() {
    if [ "$code" -ne 0 ]; then
        t_fail "$1" "clarusc appinfo: exit $code (stdout: $(tr '\n' '|' < "$WORK/out"), stderr: $(tr '\n' '|' < "$WORK/err"))"
    elif ! cmp -s "$WORK/out" "$WORK/want"; then
        t_fail "$1" "stdout = [$(tr '\n' '|' < "$WORK/out")], want [$(tr '\n' '|' < "$WORK/want")]"
    else
        t_pass "$1"
    fi
}

# --- TestAppInfoFullFixture: the committed app_info.cla fixture (app
# section with name/version/author/about, no icon/id). ----------------
run_appinfo testdata/emitui/app_info.cla
printf 'app=1\nname=Bookmarks\nversion=1.0\n' > "$WORK/want"
expect_ok TestAppInfoFullFixture

# --- TestAppInfoLabelFallback: name resolution's SECOND rung -- no
# `name` property, so name= falls back to the app section's label. -----
cat > "$WORK/probe.cla" <<'EOF'
app Zap {}

on App.startCLI(args: list of string) {
    quit 0
}
EOF
run_appinfo "$WORK/probe.cla"
printf 'app=1\nname=Zap\n' > "$WORK/want"
expect_ok TestAppInfoLabelFallback

# --- TestAppInfoFilenameFallback: THIRD rung -- no app section at all,
# so name= is the first file's basename minus .cla, and no app=1 line. --
cat > "$WORK/myprog.cla" <<'EOF'
on App.startCLI(args: list of string) {
    quit 0
}
EOF
run_appinfo "$WORK/myprog.cla"
printf 'name=myprog\n' > "$WORK/want"
expect_ok TestAppInfoFilenameFallback

# --- TestAppInfoIconJoin: the icon path joins against the DECLARING
# file's directory (not the cwd, not the entry file), plus the id line. --
# $TMPDIR may end in a slash, so $WORK can contain a doubled one; clarusc
# cleans the joined path lexically, so collapse it here the same way.
sub=$(printf '%s' "$WORK/sub" | tr -s /)
mkdir -p "$sub" || die mkdir
cat > "$sub/prog.cla" <<'EOF'
app Sprocket {
    name: "Sprocket"
    icon: "art/i.pbm"
    id: "TEST"
}

on App.startCLI(args: list of string) {
    quit 0
}
EOF
run_appinfo "$sub/prog.cla"
printf 'app=1\nname=Sprocket\nid=TEST\nicon=%s\n' "$sub/art/i.pbm" > "$WORK/want"
expect_ok TestAppInfoIconJoin

# --- TestAppInfoCheckError: a program failing the checker (an invalid app
# id) prints its diagnostic and exits 1, exactly like `clarusc check`/
# `clarusc emit` -- appinfo runs the same pipeline, no special-casing.
# stdout AND stderr are matched combined, as the Go test did. ----------
cat > "$WORK/bad.cla" <<'EOF'
app Bad {
    id: "bad"
}

on App.startCLI(args: list of string) {
    quit 0
}
EOF
run_appinfo "$WORK/bad.cla"
want="app id must be exactly 4 printable characters"
cat "$WORK/out" "$WORK/err" > "$WORK/both"
if [ "$code" -ne 1 ]; then
    t_fail TestAppInfoCheckError "exit = $code, want 1 (output: $(tr '\n' '|' < "$WORK/both"))"
elif ! grep -Fq "$want" "$WORK/both"; then
    t_fail TestAppInfoCheckError "stdout+stderr missing \"$want\": $(tr '\n' '|' < "$WORK/both")"
else
    t_pass TestAppInfoCheckError
fi

t_done
