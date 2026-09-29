#!/bin/sh
# tests/bake/lazyread.sh (SE wave 4 Task 6): a v9 `--rtbake` compile reads
# the library lazily -- the header, the directory and the resident table
# sections, then only the object code of the runtime functions its program
# reaches. CLARUS_BAKE_READLOG=1 makes the host loader print one
# `bakeread: ID BYTES` line per read (ID = the section id, 0 for the
# header and directory, -1 for an object-code span). Asserted:
#   - hello-mac reads fewer bytes than bookmarks, which reads fewer than
#     the whole file;
#   - the same order holds for the object-code spans alone, and bookmarks'
#     spans stay under the ObjCode section's own length;
#   - neither reads an IR body section (IrStmts 2, IrExprs 3 -- absent
#     from a v9 68k library) or the testapi-only checker symbols (42).
. "$(dirname "$0")/../lib.sh" || exit 2
. "$(dirname "$0")/../lib_bake.sh" || die "helper lib failed to load"

BAKE=$WORK/rt68k.clir
bake_ir 68k "$BAKE"
size=$(wc -c < "$BAKE" | tr -d ' ')
"$CLIRHDR" "$BAKE" > "$WORK/hdr" 2> "$WORK/hdr.err" || die "clirhdr: $(cat "$WORK/hdr.err")"
objlen=$(awk '$1 == "section" && $2 == 48 { print $3 }' "$WORK/hdr")
[ -n "$objlen" ] || die "no ObjCode section (48) in the library"

for nm in hello-mac bookmarks; do
    if ! CLARUS_BAKE_READLOG=1 "$CLARUSC" emit68k --rtbake "$BAKE" -o "$WORK/$nm.bin" \
            "examples/$nm.cla" > "$WORK/$nm.log" 2>&1; then
        die "$nm --rtbake compile failed: $(tail -3 "$WORK/$nm.log" | tr '\n' ' ')"
    fi
    grep '^bakeread: ' "$WORK/$nm.log" > "$WORK/$nm.reads"
    [ -s "$WORK/$nm.reads" ] || die "$nm: no bakeread lines (CLARUS_BAKE_READLOG ignored?)"
    eval "total_$(echo $nm | tr - _)=$(awk '{ s += $3 } END { print s + 0 }' "$WORK/$nm.reads")"
    eval "obj_$(echo $nm | tr - _)=$(awk '$2 == -1 { s += $3 } END { print s + 0 }' "$WORK/$nm.reads")"
    bad=$(awk '$2 == 2 || $2 == 3 || $2 == 42 { print $2 }' "$WORK/$nm.reads" | sort -u | tr '\n' ' ')
    [ -z "$bad" ] && t_pass "$nm/no_bodies" \
        || t_fail "$nm/no_bodies" "read section(s) $bad"
done

echo "total: hello-mac $total_hello_mac, bookmarks $total_bookmarks, file $size"
echo "objcode: hello-mac $obj_hello_mac, bookmarks $obj_bookmarks, section $objlen"
if [ "$total_hello_mac" -lt "$total_bookmarks" ] && [ "$total_bookmarks" -lt "$size" ]; then
    t_pass total_order
else
    t_fail total_order "hello-mac $total_hello_mac, bookmarks $total_bookmarks, file $size -- want strictly increasing"
fi
if [ "$obj_hello_mac" -gt 0 ] && [ "$obj_hello_mac" -lt "$obj_bookmarks" ] && [ "$obj_bookmarks" -lt "$objlen" ]; then
    t_pass objcode_order
else
    t_fail objcode_order "object spans: hello-mac $obj_hello_mac, bookmarks $obj_bookmarks, section $objlen -- want 0 < hello < bookmarks < section"
fi
t_done
