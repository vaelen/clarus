#!/bin/sh
# docs/clarusc.1: it lints clean, and its COMMANDS section and
# clarusc/main.cla's usage lines name the same commands. (install.sh
# covers where `make install` puts it.)
. "$(dirname "$0")/../lib.sh" || exit 2
MAN=$ROOT/docs/clarusc.1
[ -f "$MAN" ] || die "no $MAN"

# man_lint: mandoc -Tlint (WARNING or worse fails), else groff -ww
# (any stderr output fails); neither installed SKIPs this subcase only.
if command -v mandoc > /dev/null 2>&1; then
    mandoc -Tlint -W warning "$MAN" > "$WORK/lint.out" 2>&1
    if [ -s "$WORK/lint.out" ]; then t_fail man_lint "mandoc: $(cat "$WORK/lint.out")"
    else t_pass man_lint; fi
elif command -v groff > /dev/null 2>&1; then
    groff -man -ww -z "$MAN" > "$WORK/lint.out" 2>&1
    if [ -s "$WORK/lint.out" ]; then t_fail man_lint "groff: $(cat "$WORK/lint.out")"
    else t_pass man_lint; fi
else
    echo "SKIP man_lint: neither mandoc nor groff installed"
fi

# The command words the page documents: each `.B word` right after a
# `.TP` in COMMANDS.
cmds=$(sed -n '/^\.SH COMMANDS/,/^\.SH /p' "$MAN" | awk 'tp && /^\.B [a-z]/ {print $2} {tp = /^\.TP/}')
[ -n "$cmds" ] || die "no commands parsed out of $MAN's COMMANDS section"

cat > "$WORK/hello.cla" <<'EOF'
on App.startCLI(args: list of string) {
    alert("hi")
}
EOF
# accepted WORD: clarusc treats WORD as a command, not as an entry file
# name (which fails "cannot open entry file"); a command's own usage
# error for the missing -o is fine. CLARUS_DATADIR, not --rtdir, finds
# the runtime: appinfo takes no --rtdir.
accepted() {
    (cd "$WORK" && CLARUS_DATADIR=$ROOT "$CLARUSC" "$1" hello.cla) > "$WORK/acc.out" 2>&1; _rc=$?
    { [ $_rc -eq 0 ] || [ $_rc -eq 2 ]; } && ! grep -q 'cannot open entry file' "$WORK/acc.out"
}

# page_cmds_accepted: every documented command runs.
bad=
for c in $cmds; do accepted "$c" || bad="$bad $c(rc $_rc: $(head -1 "$WORK/acc.out"))"; done
if [ -z "$bad" ]; then t_pass page_cmds_accepted
else t_fail page_cmds_accepted "$bad"; fi

# unknown_cmd_rejected: the probe above can tell a bogus word apart.
if accepted frobnicate; then t_fail unknown_cmd_rejected "frobnicate was accepted"
else t_pass unknown_cmd_rejected; fi

# usage_cmds_documented: every command a main.cla usage line names (the
# generic `[check | build ... | appinfo | ...]` list and each
# `usage: clarusc WORD`) is in the page's COMMANDS, and --version and
# --bake-ir are mentioned.
ucmds=$( { grep -o 'usage: clarusc [a-z][a-z0-9]*' "$ROOT/clarusc/main.cla" | awk '{print $3}'
    grep -o 'usage: clarusc \[[^]]*\]' "$ROOT/clarusc/main.cla" | grep -o '[[|] *[a-z][a-z0-9]*' | tr -d '[| '; } | sort -u)
[ -n "$ucmds" ] || die "no usage commands parsed out of clarusc/main.cla"
miss=
for u in $ucmds; do
    echo "$cmds" | grep -qx "$u" || miss="$miss $u"
done
for o in '\-\-version' '\-\-bake\-ir'; do
    grep -qF -- "$o" "$MAN" || miss="$miss $o"
done
if [ -z "$miss" ]; then t_pass usage_cmds_documented
else t_fail usage_cmds_documented "not in the page:$miss (usage commands: $(echo $ucmds))"; fi
t_done
