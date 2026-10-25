#!/bin/sh
# tests/emitui/colfmt.sh (ui-widgets Task 3) -- the synthesized UiColFmt/
# UiLogOp dispatchers and the element-store hook, checked in the emitted C:
#   - clar_ui_fire_colfmt has one `cv_fmtId == k` arm per formatted column,
#     and the blob's col entry carries that fmtId plus a one-field Layout;
#   - clar_ui_fire_logop calls rtUiLogDo in a program with a logpanel;
#   - an inline element store (`l[i] = v`, `l[i].f = v`) is followed by an
#     rtListNoteSet call in a table-declaring program, and not in one
#     without a table;
#   - an aborting formatter's arm sits inside the attempt frame (the
#     `attN_h:` / `clar_aborting = 0;` shape fpAttemptStmt prints) whose
#     handler returns false;
#   - both fixtures also compile on the native lane (emit68k).
. "$(dirname "$0")/../lib.sh" || exit 2

# body FILE FN : the C body of static function FN (prototype line excluded).
body() {
    awk -v fn="clar_fn_$2(" 'index($0, fn) && /^static/ && /\{$/ {f=1} f {print} f && /^}$/ {exit}' "$1"
}

batch=testdata/emitui/ui_batch_decl.cla
"$CLARUSC" emit -o "$WORK/batch.c" "$batch" > "$WORK/err" 2>&1 \
    || die "clarusc emit $batch: $(head -3 "$WORK/err" | tr '\n' ' ')"

body "$WORK/batch.c" clar_ui_fire_colfmt > "$WORK/colfmt.c"
n=$(grep -c 'cv_fmtId == ' "$WORK/colfmt.c")
if [ "$n" -eq 1 ] && grep -q 'clar_fn_[a-zA-Z]*urationStr(' "$WORK/colfmt.c"; then
    t_pass batch_colfmt_arms
else
    t_fail batch_colfmt_arms "want 1 fmtId arm calling durationStr, got $n: $(tr '\n' ' ' < "$WORK/colfmt.c")"
fi

if body "$WORK/batch.c" clar_ui_fire_logop | grep -q 'clar_fn_rtUiLogDo('; then
    t_pass batch_logop_calls_rtUiLogDo
else
    t_fail batch_logop_calls_rtUiLogDo "clar_ui_fire_logop does not call rtUiLogDo"
fi

# The line after each element store must be the hook.
if awk '/clar_fn_layoutMain\(/ && /\{$/ {f=1} f && prev ~ /cv_counts/ && prev ~ /cv_n/ && /clar_fn_rtListNoteSet\(\(void\*\)cv_counts\)|clar_fn_rtListNoteSet\(cv_counts\)/ {ok=1} f {prev=$0} f && /^}$/ {exit} END {exit !ok}' "$WORK/batch.c"; then
    t_pass batch_list_store_hook
else
    t_fail batch_list_store_hook "counts[0] = n not followed by rtListNoteSet(counts)"
fi
if awk '/clar_fn_layoutMain\(/ && /\{$/ {f=1} f && prev ~ /cv_callers/ && prev ~ /cv_secs/ && /clar_fn_rtListNoteSet\(\(void\*\)cv_callers\)|clar_fn_rtListNoteSet\(cv_callers\)/ {ok=1} f {prev=$0} f && /^}$/ {exit} END {exit !ok}' "$WORK/batch.c"; then
    t_pass batch_field_store_hook
else
    t_fail batch_field_store_hook "callers[0].secs = n not followed by rtListNoteSet(callers)"
fi

# No table: the same statement gets no hook (and rtListNoteSet is shaken).
cp testdata/emitui/win_basic.cla "$WORK/win_basic.cla"
cat >> "$WORK/win_basic.cla" <<'X'

var counts: list of int

func bump(n: int) {
    counts[0] = n
}
X
"$CLARUSC" emit -o "$WORK/basic.c" "$WORK/win_basic.cla" > "$WORK/err" 2>&1 \
    || die "clarusc emit win_basic+store: $(head -3 "$WORK/err" | tr '\n' ' ')"
if ! grep -q 'cv_counts' "$WORK/basic.c"; then
    t_fail notable_no_hook "the store itself is missing from the emitted C"
elif grep -q 'rtListNoteSet' "$WORK/basic.c"; then
    t_fail notable_no_hook "rtListNoteSet emitted in a program without a table"
else
    t_pass notable_no_hook
fi

# Aborting formatter: two formatted columns, attempt frame, false on abort.
fx=testdata/emitui/ui_colfmt_abort.cla
"$CLARUSC" emit -o "$WORK/abort.c" "$fx" > "$WORK/err" 2>&1 \
    || die "clarusc emit $fx: $(head -3 "$WORK/err" | tr '\n' ' ')"
body "$WORK/abort.c" clar_ui_fire_colfmt > "$WORK/acolfmt.c"
n=$(grep -c 'cv_fmtId == ' "$WORK/acolfmt.c")
if [ "$n" -eq 2 ]; then
    t_pass abort_colfmt_arms
else
    t_fail abort_colfmt_arms "want 2 fmtId arms, got $n"
fi
if grep -q 'if (clar_aborting) goto att[0-9]*_h;' "$WORK/acolfmt.c" \
   && grep -q '^ *att[0-9]*_h:;' "$WORK/acolfmt.c" \
   && grep -A3 '^ *att[0-9]*_h:;' "$WORK/acolfmt.c" | grep -q 'clar_aborting = 0;' \
   && grep -A4 '^ *att[0-9]*_h:;' "$WORK/acolfmt.c" | grep -q 'return 0;'; then
    t_pass abort_colfmt_contained
else
    t_fail abort_colfmt_contained "no attempt frame returning false: $(tr '\n' ' ' < "$WORK/acolfmt.c")"
fi
if body "$WORK/abort.c" clar_ui_fire_logop | grep -q 'rtUiLogDo'; then
    t_fail abort_logop_stub "rtUiLogDo called in a program without a logpanel"
else
    t_pass abort_logop_stub
fi

# Blob: col 0 of the abort fixture carries fmtId 0 and a one-field Layout
# for its string result (ftype 4, offset 0, strCap 255); col 1 fmtId 1 with
# an int (ftype 0) Layout.
awk '/clar_ui_blob\[\] *= *\{/{f=1;next} f&&/\};/{exit} f' "$WORK/abort.c" \
  | tr -d ' \n' | tr ',' '\n' | grep -v '^$' \
  | awk '{printf "%02x", $1+0}' | xxd -r -p > "$WORK/abort.blob"
"$TOOLS/uiblob" "$WORK/abort.blob" > "$WORK/abort.dump" 2>&1 || die "uiblob decode failed"
# i32 OFF : the big-endian int32 at byte offset OFF of the blob.
i32() { od -An -tu1 -j "$1" -N4 "$WORK/abort.blob" | awk '{v=$1*16777216+$2*65536+$3*256+$4; if (v>=2147483648) v-=4294967296; print v}'; }
check_col() {
    line=$(grep "^col 0 0 $1 " "$WORK/abort.dump")
    id=$(printf '%s\n' "$line" | sed -n 's/.* fmtId=\([-0-9]*\) .*/\1/p')
    lo=$(printf '%s\n' "$line" | sed -n 's/.* fmtLayoutOff=\([0-9]*\)$/\1/p')
    if [ "$id" != "$1" ] || [ -z "$lo" ] || [ "$lo" -eq 0 ]; then
        t_fail "blob_col$1" "want fmtId=$1 and a layout offset: $line"
        return
    fi
    got="$(i32 "$lo") $(i32 $((lo + 4))) $(i32 $((lo + 8))) $(i32 $((lo + 12))) $(i32 $((lo + 16)))"
    if [ "$got" = "$2" ]; then
        t_pass "blob_col$1"
    else
        t_fail "blob_col$1" "layout at $lo = [$got], want [$2]"
    fi
}
check_col 0 "256 1 4 0 255"
check_col 1 "4 1 0 0 0"

# Native lane: both fixtures lower and assemble.
for f in "$batch" "$fx"; do
    if emit68k -o "$WORK/n.bin" "$f" > "$WORK/err" 2>&1; then
        t_pass "emit68k $(basename "$f")"
    else
        t_fail "emit68k $(basename "$f")" "$(head -3 "$WORK/err" | tr '\n' ' ')"
    fi
done

t_done
