#!/bin/sh
# ClarusC.APPL's library fallback (SE wave 4 Task 7). A library whose
# header passes but which fails to load later is not the user's fault:
# the resident compile (drive.cla's driveCompileFork, which macgui.cla's
# gcCompile calls) logs why and compiles from source, where the host
# `--rtbake` CLI exits 1 (refuse_objcode.sh, refuse_body.sh). Driven
# through clarusc/test/dblcompile_bake.cla, the host harness that calls
# driveCompileFork the way ClarusC does. Three failures, one per load stage:
#   objcode: a corrupt object-code section, found by bkLoadObjCode after
#            shake (driveEmit68kFork);
#   empty:   an object-code index with no valid record, found by cg68k.cla's
#            cgObjLibMissing in Measure (the bodyless library cannot
#            code-generate a baked function itself);
#   laneset: a directory without the lane's own section set, refused by
#            bkLoadRtbake before Phase A (driveCompile).
# Each must log the fallback and build the same fork as the good library.
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"
. "$ROOT/tests/lib_mactest_host.sh" || die "helper lib failed to load"

# The harness's compiles walk up from their cwd for runtime/clarus/ and
# clarusc/clarusc.c (the stamp), so they run under build-run/.
scratch_under_br bake-resident-fallback

ENTRY=$ROOT/testdata/cg68k/tickprobe.cla
GOOD=$WORK/good.clir
bake_ir 68k "$GOOD"
"$CLARUSC" --bake-ir --lane 68k --corrupt-objcode-testonly -o "$WORK/objcode.clir" \
    || die "clarusc --bake-ir --corrupt-objcode-testonly failed"
"$CLARUSC" --bake-ir --lane 68k --empty-objcode-testonly -o "$WORK/empty.clir" \
    || die "clarusc --bake-ir --empty-objcode-testonly failed"
clir_retag_section "$GOOD" "$WORK/laneset.clir" 52 2 || die "clir_retag_section failed"
host_build "$WORK/dblcompile_bake" clarusc/test/dblcompile_bake.cla > "$WORK/build.log" 2>&1 \
    || die "build clarusc/test/dblcompile_bake.cla failed: $(tail -5 "$WORK/build.log")"

# run NAME LIB : one resident compile of ENTRY against LIB in $SCRATCH/NAME.
run() {
    mkdir -p "$SCRATCH/$1"
    (cd "$SCRATCH/$1" && "$WORK/dblcompile_bake" "$2" "$ENTRY") > "$WORK/$1.log" 2>&1
}

run good "$GOOD" || die "good library compile failed: $(tail -5 "$WORK/good.log")"
if grep -q 'CLFS-source fallback' "$WORK/good.log"; then
    die "the good library fell back: $(grep 'fallback' "$WORK/good.log")"
fi

for c in objcode empty laneset; do
    if ! run "$c" "$WORK/$c.clir"; then
        t_fail "$c" "compile failed instead of falling back: $(tail -5 "$WORK/$c.log" | tr '\n' ' ')"
    elif ! grep -q 'clarusc: CLFS-source fallback (CLIR library failed to load)' "$WORK/$c.log"; then
        t_fail "$c" "no fallback line: $(head -5 "$WORK/$c.log" | tr '\n' ' ')"
    elif ! cmp -s "$SCRATCH/good/leakfork_0.bin" "$SCRATCH/$c/leakfork_0.bin"; then
        t_fail "$c" "the from-source fork differs from the good library's"
    else
        t_pass "$c"
    fi
done
grep -q 'object-code section' "$WORK/objcode.log" && t_pass objcode_reason \
    || t_fail objcode_reason "the object-code diagnostic was not logged"
grep -q 'has no object record' "$WORK/empty.log" && t_pass empty_reason \
    || t_fail empty_reason "the missing-object-record diagnostic was not logged"
grep -q 'corrupt header' "$WORK/laneset.log" && t_pass laneset_reason \
    || t_fail laneset_reason "the corrupt-header diagnostic was not logged"
t_done
