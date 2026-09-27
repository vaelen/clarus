#!/bin/sh
# SE memory program ratchet (Wave 0 onward): peak live heap of a compile,
# in 68k-equivalent bytes (round4(size) + 8-byte block header, + 4 per
# handle master pointer -- the SE's 24-bit Memory Manager), measured by
# the host runtime's counters (CLARUS_MEM_PEAK=1, rt_mem_host.inc) and
# compared with tests/memgate/budget.txt. Host allocation is
# deterministic; the budget is the measured peak + 1%. Lower a budget
# whenever a change earns it ("note: ratchet available"); never raise
# one without a written reason in budget.txt. Spec:
# docs/superpowers/specs/2026-09-27-se-wave0-measurement-design.md §3.4.
. "$(dirname "$0")/../lib.sh" || exit 2
BUDGET=$ROOT/tests/memgate/budget.txt
[ -f "$BUDGET" ] || die "missing $BUDGET"

"$CLARUSC" --bake-ir --lane 68k --rtdir "$RTDIR" -o "$WORK/rt.clir" > "$WORK/bake.log" 2>&1 \
    || die "bake-ir failed: $(tail -3 "$WORK/bake.log" | tr '\n' ' ')"

measure() {
    _name=$1; shift
    _budget=$(awk -v n="$_name" '$1 == n { print $2 }' "$BUDGET")
    case "$_budget" in
        ''|*[!0-9]*) t_fail "$_name" "no numeric budget for $_name in $BUDGET"; return ;;
    esac
    if ! CLARUS_MEM_PEAK=1 "$CLARUSC" emit68k "$@" -o "$WORK/$_name.bin" > /dev/null 2> "$WORK/$_name.err"; then
        t_fail "$_name" "emit68k failed: $(tail -3 "$WORK/$_name.err" | tr '\n' ' ')"
        return
    fi
    grep '^memprobe:' "$WORK/$_name.err"
    _peak=$(sed -n 's/^memprobe: TOTAL | peakAll68k=\([0-9][0-9]*\)$/\1/p' "$WORK/$_name.err")
    case "$_peak" in ''|*[!0-9]*) t_fail "$_name" "unparseable memprobe TOTAL: $_peak"; return ;; esac
    _pct=$(awk -v p="$_peak" -v b="$_budget" 'BEGIN { printf "%.1f", 100 * p / b }')
    echo "$_name: peak $_peak / budget $_budget ($_pct%)"
    if [ "$_peak" -gt "$_budget" ]; then
        t_fail "$_name" "peak $_peak exceeds budget $_budget"
        return
    fi
    awk -v p="$_peak" -v b="$_budget" 'BEGIN { exit !(p < 0.95 * b) }' \
        && echo "note: ratchet available for $_name (peak under 95% of budget)"
    t_pass "$_name"
}

measure bookmarks_rtbake --rtdir "$RTDIR" --rtbake "$WORK/rt.clir" examples/bookmarks.cla
measure bookmarks_src --rtdir "$RTDIR" examples/bookmarks.cla
measure hello_src --rtdir "$RTDIR" examples/hello-mac.cla
t_done
