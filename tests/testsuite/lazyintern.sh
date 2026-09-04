#!/bin/sh
# testsuite/lazyintern.sh -- port of internal/testsuite/lazyintern_test.go
# TestLazyInternGuardsAreReset: a mechanical guard against reintroducing the
# stale-pool-index miscompile class libReset() exists to close off. Every
# lazy-guard-interning global in clarusc/*.cla -- either the sentinel idiom
#   `if X == -1 { X = intern(...) }`   (Go: `if (\w+) == -1 \{\s*(\w+) = intern\(`)
# or the bool idiom
#   `var XInited: bool`                (Go: `var (\w*Inited): bool`)
# -- must have a per-compile reset assignment (`X = -1` / `X = false`)
# SOMEWHERE in clarusc/*.cla, in any function.
#
# Pure-comment lines are stripped BEFORE scanning: doc comments quote the
# guard idiom as prose, which would otherwise false-positive as a real
# accessor with a made-up name. A trailing comment on a real code line is
# kept -- only a line whose trimmed content STARTS with "//" is dropped.
#
# Byte-safe: two clarusc/*.cla files are MacRoman-encoded, so the whole scan
# runs under LC_ALL=C (the patterns themselves are pure ASCII).
#
# Limitation, inherited verbatim: convention-enforced, not exhaustive. A
# guard spelled `< 0` instead of `== -1`, or a bool guard named anything
# other than `*Inited`, slips through undetected.
. "$(dirname "$0")/../lib.sh" || exit 2

set -- clarusc/*.cla
[ -f "$1" ] || die "glob clarusc/*.cla matched no files"

# Comment-stripped corpus, in glob order (Go's filepath.Glob is sorted).
LC_ALL=C awk '{ s = $0; sub(/^[ \t\f\r]+/, "", s); if (s !~ /^\/\//) print }' "$@" \
    > "$WORK/corpus" || die "building corpus failed"

# The scan. Go's `\s*` in the sentinel regex spans newlines, so the text
# after `{` is followed across lines until the first non-whitespace; that
# text must then be `<name> = intern(` with the SAME name (Go verifies the
# two captures agree, RE2 having no backreferences).
#
# Emits one "MISS <kind> <name>" line per guarded global with no reset, and
# a final "COUNT <n>" of distinct guarded globals seen.
LC_ALL=C awk '
function trim(s) { sub(/^[ \t\f\r]+/, "", s); sub(/[ \t\f\r]+$/, "", s); return s }

# hasReset(name, want): want assigned as a bare statement anywhere in the
# corpus, excluding name own "var name:" declaration line.
function hasReset(name, want,    i, t, decl) {
    decl = "var " name ":"
    for (i = 1; i <= n; i++) {
        t = trim(line[i])
        if (index(t, decl) == 1) continue      # the declaration, not a reset
        if (index(t, want) > 0) return 1
    }
    return 0
}

# firstWord(i, rest): the first non-whitespace run starting at rest on line
# i, continuing onto following lines while rest is all whitespace.
function restAfter(i, rest,    j) {
    j = i
    while (1) {
        sub(/^[ \t\f\r]+/, "", rest)
        if (rest != "") return rest
        j++
        if (j > n) return ""
        rest = line[j]
    }
}

{ line[NR] = $0 }

END {
    n = NR

    # --- sentinel guards: if X == -1 { <ws> X = intern( -----------------
    for (i = 1; i <= n; i++) {
        s = line[i]
        while (match(s, /if [A-Za-z0-9_]+ == -1 \{/)) {
            m = substr(s, RSTART, RLENGTH)
            rest = substr(s, RSTART + RLENGTH)
            s = rest
            name = substr(m, 4, length(m) - 3 - 8)   # strip "if " and " == -1 {"
            tail = restAfter(i, rest)
            if (match(tail, /^[A-Za-z0-9_]+ = intern\(/) != 1) continue
            again = substr(tail, 1, index(tail, " ") - 1)
            if (name != again) continue
            if (name in seen) continue
            seen[name] = 1
            if (!hasReset(name, name " = -1")) print "MISS sentinel " name
        }
    }

    # --- bool guards: var X...Inited: bool ------------------------------
    for (i = 1; i <= n; i++) {
        s = line[i]
        while (match(s, /var [A-Za-z0-9_]*Inited: bool/)) {
            m = substr(s, RSTART, RLENGTH)
            s = substr(s, RSTART + RLENGTH)
            name = substr(m, 5, length(m) - 4 - 6)   # strip "var " and ": bool"
            if (name in seen) continue
            seen[name] = 1
            if (!hasReset(name, name " = false")) print "MISS bool " name
        }
    }

    c = 0
    for (k in seen) c++
    print "COUNT " c
}
' "$WORK/corpus" > "$WORK/scan" || die "scan failed"

count=$(sed -n 's/^COUNT //p' "$WORK/scan")
if [ "$count" = 0 ]; then
    t_fail Detection "found zero lazy-guard-interning globals across clarusc/*.cla -- the detection patterns are probably broken (expected at least rnInit/cnInit/cwInit/kwInit plus the ~163 ir.cla/lower.cla sentinel accessors)"
else
    t_pass Detection
fi

nmiss=0
while read -r tag kind name; do
    [ "$tag" = MISS ] || continue
    nmiss=$((nmiss + 1))
    case $kind in
        sentinel) t_fail "$name" "lazy-guard intern sentinel (idiom: \`if $name == -1 { $name = intern(...) }\`) has no per-compile reset (\`$name = -1\`) anywhere in clarusc/*.cla -- add one to the right reset function (irReset/checkReset/driveReset/lexAll/lowerProgram/...), or this becomes the next stale-pool-index miscompile once libReset() recycles the pool" ;;
        bool) t_fail "$name" "lazy-guard-bool (a \`var $name: bool\` process-lifetime init guard) has no per-compile reset (\`$name = false\`) anywhere in clarusc/*.cla -- same stale-pool-index hazard class as rnInit/rnInited" ;;
    esac
done < "$WORK/scan"
[ "$nmiss" = 0 ] && t_pass GuardsReset

t_done
