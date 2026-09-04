#!/bin/sh
# testsuite/catalog_ui.sh -- port of internal/testsuite/catalog_test.go
# TestCatalogComposesWithUIRuntime: a UI program may compose
# toolbox/standardfile.cla + files.cla POSITIONALLY even though the UI
# runtime (runtime/clarus/uidialogs.cla) includes the same two files
# itself; those files' decls must be HOISTED ahead of uidialogs.cla,
# because record TYPES (SFReply/SFTypeList/VolumeParam) are order-
# sensitive. Before clarusc's hoist fix this panicked the compiler
# ("list index out of range", exit 3) on BOTH emit lanes.
#
# Paths are repo-root-RELATIVE with cwd == root -- including `--rtdir
# runtime/clarus/`, deliberately NOT lib.sh's absolute $RTDIR (nor its
# emit68k helper) -- so the runtime's own "../../toolbox/standardfile.cla"
# normalizes to exactly the positional spelling and the dedup fires.
. "$(dirname "$0")/../lib.sh" || exit 2

cat > "$WORK/compose.cla" <<'CLA_EOF'
window Main {
    title: "Compose"
    size: 200, 100
}
CLA_EOF

for mode in emit emit68k; do
    case $mode in
        emit) out=$WORK/compose.c ;;
        emit68k) out=$WORK/compose.bin ;;
    esac
    "$CLARUSC" "$mode" --rtdir runtime/clarus/ -o "$out" "$WORK/compose.cla" \
        toolbox/standardfile.cla toolbox/files.cla > "$WORK/$mode.log" 2>&1
    rc=$?
    if [ $rc -ne 0 ]; then
        t_fail "$mode" "clarusc $mode failed (exit $rc): $(head -5 "$WORK/$mode.log" | tr '\n' ' ')"
    elif grep -qF 'list index out of range' "$WORK/$mode.log"; then
        t_fail "$mode" "output contains the old hoist panic string"
    else
        t_pass "$mode"
    fi
done
t_done
