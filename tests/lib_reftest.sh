# tests/lib_reftest.sh -- ```rust fence extraction from the language
# reference (port of internal/reftest/reftest.go's ExtractFences). Sourced
# right after lib.sh by tests/reftest/*.sh; lib.sh itself is frozen.

# fences FILE              -> number of fences
# fences FILE N            -> body of fence N (0-based) on stdout
# fences FILE find SUBSTR  -> index of first fence containing SUBSTR
fences() {
    awk -v want="${2:-count}" -v sub_="${3:-}" '
        /^```rust$/ && !in_f { in_f=1; body=""; next }
        /^```$/ && in_f { in_f=0;
            if (want=="count") n++;
            else if (want=="find") { if (index(body, sub_)) { print n; exit } ; n++ }
            else if (n==want+0) { printf "%s", body; exit } else n++;
            next }
        in_f { body = body $0 "\n" }
        END { if (want=="count") print n+0 }' "$1"
}

# REFMD is the reference document all three reftest scripts read.
REFMD=$ROOT/docs/clarus-language-reference.md
# MANIFEST holds the check-clean fence indices ("#" lines are comments).
MANIFEST=$ROOT/tests/reftest/manifest.txt
# manifest_indices : those indices, one per line, comments stripped.
manifest_indices() { grep -v '^#' "$MANIFEST"; }
